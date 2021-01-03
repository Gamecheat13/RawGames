#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_skipto;

//Model tags:
//BONE 0 -1 "tag_origin"
//BONE 1 0 "ammo_A"
//BONE 2 0 "ammo_B"
//BONE 3 0 "auxilary_A"
//BONE 4 0 "auxilary_B"
//BONE 5 0 "grenade"
//BONE 6 0 "loadOut_A"
//BONE 7 0 "loadOut_B"
//BONE 8 0 "secondary_A"

/*Ammo Cache prefabs located in /map_source/_prefabs/library/ammo_refill/
weapon_crate_future_full - large cache, has two extra slots
ammo_crate_future - future version of the ammo cache

Ammo Cache related kvp's

targetname 			- please DO NOT change this value
script_noteworthy 	- use this to give a unique name
ac_slot1			- the first extra slot for weapons. This is located on all ammo cache types, on the ground in front of the cache
ac_slot2			- the second extra slot for weapons. This is located on the rightmost side of the full cache only

Note: Use the weapon name for the extra weapon slots, the same as you would list in your csv (ex: rpg_sp )
*/

#namespace cache;

function autoexec __init__sytem__() {     system::register("cache",&__init__,undefined,undefined);    }

//-- Called from _load.gsc, threads logic function for each trigger
function __init__()
{
	a_ammo_crates = GetEntArray( "sys_ammo_cache", "targetname" );
	array::thread_all( a_ammo_crates,&_setup_ammo_cache );

	a_weapon_crates = GetEntArray( "sys_weapon_cache", "targetname" );
	array::thread_all( a_weapon_crates,&_setup_weapon_cache );	
}

//Updated system

function _setup_ammo_cache()
{
	util::waittill_asset_loaded( "xmodel", self.model );	
	
	self thread _ammo_refill_think();
	if( self.model != "p6_ammo_resupply_future_01" && self.model != "p6_ammo_resupply_80s_final_01" )
	{
		//self thread _place_player_loadout();
		//self thread _check_extra_slots();		
	}
	
	//-- used for filling ammo when you are on a horse or aren't just walking into it as a player
	if( isdefined( level._ammo_refill_think_alt ) )
	{
		self thread [[level._ammo_refill_think_alt]]();
	}
}

function _setup_weapon_cache()
{
	util::waittill_asset_loaded( "xmodel", self.model );	
	
	level flag::wait_till( "all_players_connected" );
	
	self thread _place_player_loadout();
	self thread _check_extra_slots();
	
	//self thread _debug_tags();
}

//sets up trigger/ammo refill section of the cache
function _ammo_refill_think()
{
	self endon( "disable_ammo_cache" );
	
	t_ammo_cache = self _get_closest_ammo_trigger();
	
	if( isdefined( t_ammo_cache.script_string ) && t_ammo_cache.script_string == "no_grenade" )
	{
		t_ammo_cache.no_grenade = true;
	}

	t_ammo_cache SetHintString( &"SCRIPT_AMMO_REFILL" );
	t_ammo_cache SetCursorHint( "HINT_NOICON" );	
	
	while( 1 )
	{
		t_ammo_cache waittill( "trigger", e_player );
		
		e_player DisableWeapons();
		e_player playsound( "fly_ammo_crate_refill" );
					
		wait 2;
		
		a_weapons = e_player GetWeaponsList();
		foreach( weapon in a_weapons )
		{
			if( ( isdefined( t_ammo_cache.no_grenade ) && t_ammo_cache.no_grenade ) && weapons::is_grenade( weapon ) )
			{
				continue;	
			}
			else
			{
				e_player GiveMaxAmmo( weapon );
				e_player SetWeaponAmmoClip( weapon, weapon.clipSize );				
			}
		}
			
		e_player EnableWeapons();
		e_player notify( "ammo_refilled" );
	}
}

function _get_closest_ammo_trigger()
{
	a_ammo_cache = GetEntArray( "trigger_ammo_cache", "targetname" );
	t_ammo_cache = array::get_closest( self.origin, a_ammo_cache );

	return t_ammo_cache;
}

//places player loadout weapons at loadout tags
function _place_player_loadout()
{
	w_primary_weapon = level.players[0] GetLoadoutWeapon( 0, "primary" );
	w_secondary_weapon = level.players[0] GetLoadoutWeapon( 0, "secondary" );
	
	v_basic_offset = (-5, 0, 15);
	v_full_offset = (-10, 0, 15);
	v_model_offset = (0,0,15);
	n_offset_multiplier = 0;	
	
	w_primary_weapon_base = w_primary_weapon.rootWeapon;

	if( w_primary_weapon_base != level.weaponNull && IsAssetLoaded( "weapon", w_primary_weapon_base.name ) )
	{
		primary_weapon_pos = self GetTagOrigin( "loadOut_B" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_B" ) ) * n_offset_multiplier;
		m_weapon_script_model = Spawn( "weapon_" + w_primary_weapon.name + level.game_mode_suffix, primary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_B" ) + (0, -90, 0);
	}
	else if( IsAssetLoaded( "weapon", "hk416" + level.game_mode_suffix ) )//Primary failed, let's try a default
	{
		primary_weapon_pos = self GetTagOrigin( "loadOut_B" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_B" ) ) * n_offset_multiplier;
		m_weapon_script_model = Spawn( "weapon_" + "ar_standard" + level.game_mode_suffix, primary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_B" ) + (0, -90, 0);		
	}
	
	switch( self.model )
	{
		case "p6_weapon_resupply_future_02":
		case "p6_weapon_resupply_future_01":
			n_offset_multiplier = -3;
			break;			
		
		default:
			n_offset_multiplier = -4;
			break;
	}	

	w_secondary_weapon_base = w_secondary_weapon.rootWeapon;

	if( w_secondary_weapon_base != level.weaponNull && IsAssetLoaded( "weapon", w_secondary_weapon_base.name ) )
	{	
		secondary_weapon_pos = self GetTagOrigin( "loadOut_A" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_A" ) ) * n_offset_multiplier;		
		m_weapon_script_model = Spawn( "weapon_" + w_secondary_weapon + level.game_mode_suffix, secondary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_A" ) + (0, -90, 0);
		
		//level thread place_player_loadout_camo( m_weapon_script_model, "secondarycamo" );
	}
	else if( IsAssetLoaded( "weapon", "smg_fastfire" + level.game_mode_suffix ) )//Secondary failed, let's try a default
	{
		secondary_weapon_pos = self GetTagOrigin( "loadOut_A" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_A" ) ) * n_offset_multiplier;
		m_weapon_script_model = Spawn( "weapon_" + "smg_fastfire" + level.game_mode_suffix, secondary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_A" ) + (0, -90, 0);		
	}	
}

//function place_player_loadout_camo( m_weapon_script_model, camo_type )
//{
//	skipto::wait_for_first_player();
//	
//	if( camo_type == "primarycamo" )
//	{
//		primaryCamoIndex = GetLoadoutItemIndex( "primarycamo" );
//		primaryWeaponOptions = level.players[0] calcweaponoptions( primaryCamoIndex );
//		m_weapon_script_model ItemWeaponSetOptions( primaryWeaponOptions );
//	}
//	else if( camo_type == "secondarycamo" )
//	{
//		secondaryCamoIndex = GetLoadoutItemIndex( "secondarycamo" );
//		secondaryWeaponOptions = level.players[0] calcweaponoptions( secondaryCamoIndex );
//		m_weapon_script_model ItemWeaponSetOptions( secondaryWeaponOptions );			
//	}
//}

//checks extra slot data to see if extra weapons should be placed or not
function _check_extra_slots()
{
	if( isdefined( self.ac_slot1 ) )//Front ground position
	{
		auxilary_weapon_pos = self GetTagOrigin( "auxilary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		switch( self.model )
		{
			/*case "p6_weapon_resupply_80s_02":
			case "p6_weapon_resupply_future_02":
				tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 20;
				break;*/
				
			default:
				tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 5;		
				break;
		}
		m_weapon_script_model = Spawn( "weapon_" + self.ac_slot1 + level.game_mode_suffix, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "auxilary_A" ) + (0, -90, 0);
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );	
	}
	
	if( isdefined( self.ac_slot2 ) )//Side right position
	{
		auxilary_weapon_pos = self GetTagOrigin( "secondary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 10;
		m_weapon_script_model = Spawn( "weapon_" + self.ac_slot2 + level.game_mode_suffix, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "secondary_A" );
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );

		/*tmp_bottle = util::spawn_model( "trash_bottle_water2", self GetTagOrigin( "secondary_A" ) );
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 5;
		tmp_bottle = util::spawn_model( "trash_bottle_water2", self GetTagOrigin( "secondary_A" ) + tmp_offset );	*/	
	}	
}

/#
function _debug_tags()
{
	tag_array = [];
	tag_array[tag_array.size] = "ammo_A";
	tag_array[tag_array.size] = "ammo_B";
	tag_array[tag_array.size] = "auxilary_A";
	tag_array[tag_array.size] = "auxilary_B";
	tag_array[tag_array.size] = "grenade";
	tag_array[tag_array.size] = "loadOut_A";
	tag_array[tag_array.size] = "loadOut_B";
	tag_array[tag_array.size] = "secondary_A";

	foreach( tag in tag_array )
	{
		self thread _loop_text( tag );
	}
}

function _loop_text( tag )
{
	while(1)
	{
		if( isdefined( self GetTagOrigin( tag ) ) )
		{
			print3d( self GetTagOrigin( tag ), tag, (1,1,1), 1, 0.15 );
		}
		{wait(.05);};
	}
}
#/

/@
"Name: disable_ammo_cache( <str_ammo_cache_id> )"
"Summary: Disables an ammo cache from being used as a refill station anymore."
"Module: Ammo Cache Utility"
"MandatoryArg: <str> : The ammo cache you want to disable."
"Example: level disable_ammo_cache( "basic_test" );;"
"SPMP: singleplayer"
@/
function disable_ammo_cache( str_ammo_cache_id )
{	
	a_ammo_cache = GetEntArray( str_ammo_cache_id, "script_noteworthy" );
	
	Assert( isdefined( a_ammo_cache ), "There is no ammo cache with the script_noteworthy '" + str_ammo_cache_id + "'. Please double check the names used" );
	if( a_ammo_cache.size > 1 )
	{
		AssertMsg( "There is more than one ammo cache with the script_noteworthy '" + str_ammo_cache_id + "'. Please give each a unique name" ); 
	}
	
	a_ammo_cache[0] notify( "disable_ammo_cache" );
	
	t_ammo_cache = a_ammo_cache[0] _get_closest_ammo_trigger();
	t_ammo_cache TriggerEnable( false );
}

/@
"Name: activate_extra_slot( <n_slot_number>, <w_weapon> )"
"Summary: Activates an ammo cache extra slot on the fly. Use this if you don't want an extra slot to be active by default"
"Module: Ammo Cache Utility"
"MandatoryArg: <num> : The slot you want to activate. 1 is front floor, 2 is right side and full cache only"
"MandatoryArg: <str> : The name of the weapon you want to add."
"Example: m_ammo_cache activate_extra_slot( 1, GetWeapon( "rpg" ) );;"
"SPMP: singleplayer"
@/
function activate_extra_slot( n_slot_number, w_weapon )
{
	if( n_slot_number < 1 || n_slot_number > 2 )
	{
		AssertMsg( "Only values of 1 or 2 are valid slot positions" );
	}
	assert( isdefined( w_weapon ), "Weapon is not defined" );
	
	if( n_slot_number == 1 )
	{		
		auxilary_weapon_pos = self GetTagOrigin( "auxilary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 5;
		m_weapon_script_model = Spawn( "weapon_" + w_weapon.name + level.game_mode_suffix, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "auxilary_A" ) + (0, -90, 0);
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );		
	}
	
	if( n_slot_number == 2 )
	{
		auxilary_weapon_pos = self GetTagOrigin( "secondary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_*_full prefab to use this slot" );	
		
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 7;
		m_weapon_script_model = Spawn( "weapon_" + w_weapon.name + level.game_mode_suffix, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );	
		m_weapon_script_model.angles = self GetTagAngles( "secondary_A" );
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );		
	}	
}


/@
"Name: cleanup_cache()"
"Summary: Calling this on a cache will competely remove it and all of its resources from the game"
"Module: Ammo Cache Utility"
"Example: m_test_cache = getent( "test_cache", "script_noteworthy" );"
"Example: m_test_cache thread cleanup_cache();"
"SPMP: singleplayer"
@/
function cleanup_cache()//self = ammo or weapon cache
{
	//p6_ammo_
	//p6_weapon_
	if( IsSubStr( self.model, "p6_weapon_" ) )
	{
		a_weapons_list = [];
		//cleanup weapons cache
		a_item_list = GetItemArray();
		foreach( item in a_item_list )
		{
			if( IsSubStr( item.classname, "weapon_" ) )
			{
				a_weapons_list[a_weapons_list.size] = item;
			}
		}
		
		n_weapon_counter = 2;
		if( isdefined( self.ac_slot1 ) )
		{
			n_weapon_counter++;	
		}
		if( isdefined( self.ac_slot2 ) )
		{
			n_weapon_counter++;	
		}
		
		for( x = 0; x < n_weapon_counter; x++ )
		{
			e_closest_weapon = array::get_closest( self.origin, a_weapons_list, 50 );
			if( isdefined( e_closest_weapon ) )
			{
				e_closest_weapon Delete();
			}
			//a_weapons_list = array::remove_undefined_from_array( a_weapons_list );
		}
		self Delete();
	}
	else
	{
		self notify( "disable_ammo_cache" );
		t_ammo_trigger = _get_closest_ammo_trigger();
		if( isdefined( t_ammo_trigger ) )
		{
			t_ammo_trigger Delete();
		}
		self Delete();
	}
}