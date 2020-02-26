#include common_scripts\utility;
#include maps\_utility;

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
weapon_crate_future_basic - minimal cache, has one extra weapon slot
weapon_crate_future_full - large cache, has two extra slots
ammo_crate_future - future version of the ammo cache
weapon_crate_80s_basic - minimal cache, has one extra weapon slot WORK IN PROGRESS
weapon_crate_80s_full - large cache, has two extra slots WORK IN PROGRESS
ammo_crate_80s - 80's version of the ammo cache

Ammo Cache related kvp's

targetname 			- please DO NOT change this value
script_noteworthy 	- use this to give a unique name
ac_slot1			- the first extra slot for weapons. This is located on all ammo cache types, on the ground in front of the cache
ac_slot2			- the second extra slot for weapons. This is located on the rightmost side of the full cache only

Note: Use the weapon name for the extra weapon slots, the same as you would list in your csv (ex: rpg_sp )
*/

//-- Called from _load.gsc, threads logic function for each trigger
main()
{
	//setup and support old system for now
	a_ammo_crates = GetEntArray( "trigger_ammo_refill", "targetname" );
	array_thread( a_ammo_crates, ::_ammo_refill_think_old );
	thread place_player_loadout_old();
	
	//new system
	a_ammo_crates = GetEntArray( "sys_ammo_cache", "targetname" );
	array_thread( a_ammo_crates, ::_setup_ammo_cache );
	
	//new system
	a_weapon_crates = GetEntArray( "sys_weapon_cache", "targetname" );
	array_thread( a_weapon_crates, ::_setup_weapon_cache );	
}

//self is a use trigger in the crate prefab
_ammo_refill_think_old()
{
	self SetHintString( &"SCRIPT_AMMO_REFILL" );
	self SetCursorHint( "HINT_NOICON" );	
	
	while( 1 )
	{
		self waittill( "trigger", e_player );
		
		e_player DisableWeapons();
		e_player playsound( "fly_ammo_crate_refill" );
					
		wait 2;
		
		a_str_weapons = e_player GetWeaponsList();
		foreach( str_weapon in a_str_weapons )
		{
			if( !_is_banned_refill_weapon( str_weapon ) )
			{
				e_player GiveMaxAmmo( str_weapon );
				e_player SetWeaponAmmoClip( str_weapon, WeaponClipSize( str_weapon ) );				
			}			
		}	
			
		e_player EnableWeapons();
	}
}

place_player_loadout_old()
{
	str_primary_weapon = GetLoadoutItem( "primary" );	
	str_secondary_weapon = GetLoadoutItem( "secondary" );	
	
	primary_weapon_pos_array = GetEntArray( "ammo_refill_primary_weapon", "targetname" );
	foreach( primary_pos in primary_weapon_pos_array )
	{
		if( !issubstr( str_primary_weapon, "null" ) )//check for weapon_null_sp
		{
			m_weapon_script_model = spawn( "weapon_" + str_primary_weapon, primary_pos.origin );
			m_weapon_script_model.angles = primary_pos.angles;			
		}
	}
	
	secondary_weapon_pos_array = GetEntArray( "ammo_refill_secondary_weapon", "targetname" );
	foreach( secondary_pos in secondary_weapon_pos_array )
	{
		if( !issubstr( str_primary_weapon, "null" ) )//check for weapon_null_sp
		{		
			m_weapon_script_model = spawn( "weapon_" + str_secondary_weapon, secondary_pos.origin );
			m_weapon_script_model.angles = secondary_pos.angles;
		}
	}	
}

//Updated system

_setup_ammo_cache()
{
	waittill_asset_loaded( "xmodel", self.model );	
	
	self IgnoreCheapEntityFlag( true );
	
	self thread _ammo_refill_think();
	if( self.model != "p6_ammo_resupply_future_01" && self.model != "p6_ammo_resupply_80s_final_01" )
	{
		self thread _place_player_loadout();
		self thread _check_extra_slots();		
	}
	
	//-- used for filling ammo when you are on a horse or aren't just walking into it as a player
	if( IsDefined( level._ammo_refill_think_alt ) )
	{
		self thread [[level._ammo_refill_think_alt]]();
	}
}

_setup_weapon_cache()
{
	waittill_asset_loaded( "xmodel", self.model );	
	
	self IgnoreCheapEntityFlag( true );
	
	self thread _place_player_loadout();
	self thread _check_extra_slots();
	
	//self thread _debug_tags();
}

//sets up trigger/ammo refill section of the cache
_ammo_refill_think()
{
	self endon( "disable_ammo_cache" );
	
	t_ammo_cache = self _get_closest_ammo_trigger();

	t_ammo_cache SetHintString( &"SCRIPT_AMMO_REFILL" );
	t_ammo_cache SetCursorHint( "HINT_NOICON" );	
	
	while( 1 )
	{
		t_ammo_cache waittill( "trigger", e_player );
		
		e_player DisableWeapons();
		e_player playsound( "fly_ammo_crate_refill" );
					
		wait 2;
		
		a_str_weapons = e_player GetWeaponsList();
		foreach( str_weapon in a_str_weapons )
		{
			if( !_is_banned_refill_weapon( str_weapon ) )
			{
				e_player GiveMaxAmmo( str_weapon );
				e_player SetWeaponAmmoClip( str_weapon, WeaponClipSize( str_weapon ) );				
			}
		}
			
		e_player EnableWeapons();
	}
}

_get_closest_ammo_trigger()
{
	a_ammo_cache = GetEntArray( "trigger_ammo_cache", "targetname" );
	t_ammo_cache = getclosest( self.origin, a_ammo_cache );

	return t_ammo_cache;	
}

//places player loadout weapons at loadout tags
_place_player_loadout()
{
	str_primary_weapon = GetLoadoutItem( "primary" );	
	str_secondary_weapon = GetLoadoutItem( "secondary" );	
	
	v_basic_offset = (-5, 0, 15);
	v_full_offset = (-10, 0, 15);
	v_model_offset = (0,0,15);
	n_offset_multiplier = 0;
	
	switch( self.model )
	{
		/*case "p6_ammo_resupply_02":
		case "p6_ammo_resupply_80s_02":
			v_model_offset = v_basic_offset;
			break;*/
			
		case "p6_ammo_resupply_01":
		case "p6_ammo_resupply_80s_01":
			n_offset_multiplier = 5;
			break;
	}	
	
	if( !issubstr( str_primary_weapon, "null" ) && IsAssetLoaded( "weapon", str_primary_weapon ) )//check for weapon_null_sp
	{
		primary_weapon_pos = self GetTagOrigin( "loadOut_B" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_B" ) ) * n_offset_multiplier;
		m_weapon_script_model = spawn( "weapon_" + str_primary_weapon, primary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_B" ) + (0, -90, 0);		

		/*tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "loadOut_B" ) );
		
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_B" ) ) * n_offset_multiplier;
		tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "loadOut_B" ) + tmp_offset );*/	
	}

	if( !issubstr( str_secondary_weapon, "null" ) && IsAssetLoaded( "weapon", str_secondary_weapon ) )//check for weapon_null_sp
	{	
		secondary_weapon_pos = self GetTagOrigin( "loadOut_A" );
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_A" ) ) * n_offset_multiplier;		
		m_weapon_script_model = spawn( "weapon_" + str_secondary_weapon, secondary_weapon_pos + ( tmp_offset + v_model_offset ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "loadOut_A" ) + (0, -90, 0);
		
		/*tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "loadOut_A" ) );
		
		tmp_offset = anglestoright( self GetTagAngles( "loadOut_A" ) ) * n_offset_multiplier;
		tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "loadOut_A" ) + tmp_offset );*/
	}
}

//checks extra slot data to see if extra weapons should be placed or not
_check_extra_slots()
{
	if( isdefined( self.ac_slot1 ) )//Front ground position
	{
		auxilary_weapon_pos = self GetTagOrigin( "auxilary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 5;
		m_weapon_script_model = Spawn( "weapon_" + self.ac_slot1, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "auxilary_A" ) + (0, -90, 0);
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );

		/*tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "auxilary_A" ) );
		tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 5;
		tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "auxilary_A" ) + tmp_offset );*/		
	}
	
	if( isdefined( self.ac_slot2 ) )//Side right position
	{
		auxilary_weapon_pos = self GetTagOrigin( "secondary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 7;
		m_weapon_script_model = spawn( "weapon_" + self.ac_slot2, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "secondary_A" );
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );

		/*tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "secondary_A" ) );
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 5;
		tmp_bottle = spawn_model( "trash_bottle_water2", self GetTagOrigin( "secondary_A" ) + tmp_offset );	*/	
	}	
}

//List of weapons that will NOT get refilled
_is_banned_refill_weapon( str_weapon )
{
	switch( str_weapon )
	{
		case "irstrobe_dpad_sp":
		case "molotov_dpad_sp":
		case "molotov_sp":
		case "mortar_shell_dpad_sp":
		case "nightingale_dpad_sp":
		case "sticky_grenade_dpad_sp":
		case "beartrap_sp":
		case "tc6_mine_sp":
		case "sticky_grenade_afghan_sp":
			return true;
			break;
			
		default:
			return false;
			break;
	}
}

/#
_debug_tags()
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

_loop_text( tag )
{
	while(1)
	{
		if( isdefined( self GetTagOrigin( tag ) ) )
		{
			print3d( self GetTagOrigin( tag ), tag, (1,1,1), 1, 0.15 );
		}
		wait 0.05;
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
disable_ammo_cache( str_ammo_cache_id )
{	
	a_ammo_cache = GetEntArray( str_ammo_cache_id, "script_noteworthy" );
	
	Assert( isdefined( a_ammo_cache ), "There is no ammo cache with the script_noteworthy '" + str_ammo_cache_id + "'. Please double check the names used" );
	if( a_ammo_cache.size > 1 )
	{
		AssertMsg( "There is more than one ammo cache with the script_noteworthy '" + str_ammo_cache_id + "'. Please give each a unique name" ); 
	}
	
	a_ammo_cache[0] notify( "disable_ammo_cache" );
	
	t_ammo_cache = a_ammo_cache[0] _get_closest_ammo_trigger();
	t_ammo_cache trigger_off();
}

/@
"Name: activate_extra_slot( <n_slot_number>, <str_weapon> )"
"Summary: Activates an ammo cache extra slot on the fly. Use this if you don't want an extra slot to be active by default"
"Module: Ammo Cache Utility"
"MandatoryArg: <num> : The slot you want to activate. 1 is front floor, 2 is right side and full cache only"
"MandatoryArg: <str> : The name of the weapon you want to add."
"Example: m_ammo_cache activate_extra_slot( 1, "rpg_sp" );;"
"SPMP: singleplayer"
@/
activate_extra_slot( n_slot_number, str_weapon )
{
	if( n_slot_number < 1 || n_slot_number > 2 )
	{
		AssertMsg( "Only values of 1 or 2 are valid slot positions" );
	}
	assert( isdefined( str_weapon ), "Weapon is not defined" );
	
	if( n_slot_number == 1 )
	{		
		auxilary_weapon_pos = self GetTagOrigin( "auxilary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_future_full prefab to use this slot" );	
		
		tmp_offset = anglestoright( self GetTagAngles( "auxilary_A" ) ) * 5;
		m_weapon_script_model = Spawn( "weapon_" + str_weapon, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );
		m_weapon_script_model.angles = self GetTagAngles( "auxilary_A" ) + (0, -90, 0);
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );		
	}
	
	if( n_slot_number == 2 )
	{
		auxilary_weapon_pos = self GetTagOrigin( "secondary_A" );
		Assert( isdefined( auxilary_weapon_pos ), "Please use the ammo_refill_crate_*_full prefab to use this slot" );	
		
		tmp_offset = anglestoforward( self GetTagAngles( "secondary_A" ) ) * 7;
		m_weapon_script_model = spawn( "weapon_" + str_weapon, auxilary_weapon_pos + ( tmp_offset + (0, 0, 10) ), 8 );	
		m_weapon_script_model.angles = self GetTagAngles( "secondary_A" );
		m_weapon_script_model ItemWeaponSetAmmo( 9999, 9999 );		
	}	
}