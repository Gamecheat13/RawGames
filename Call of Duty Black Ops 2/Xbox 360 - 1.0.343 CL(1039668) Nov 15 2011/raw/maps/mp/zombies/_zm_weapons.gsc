#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_magicbox; 


init()
{
	init_weapons();
	init_weapon_upgrade();			//Wall buys
//T6todo	init_weapon_toggle();
//T6todo	init_pay_turret();
//	init_weapon_cabinet();
//T6todo	treasure_chest_init();
//T6todo	level thread add_limited_tesla_gun();

	PreCacheShader( "minimap_icon_mystery_box" );
	PrecacheShader( "specialty_instakill_zombies" );
	PrecacheShader( "specialty_firesale_zombies" );
}

add_zombie_weapon( weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost )
{
	if( IsDefined( level.zombie_include_weapons ) && !IsDefined( level.zombie_include_weapons[weapon_name] ) )
	{
		return;
	}
	
	// Check the table first
	table = "mp/zombiemode.csv";
	table_cost = TableLookUp( table, 0, weapon_name, 1 );
	table_ammo_cost = TableLookUp( table, 0, weapon_name, 2 );

	if( IsDefined( table_cost ) && table_cost != "" )
	{
		cost = round_up_to_ten( int( table_cost ) );
	}

	if( IsDefined( table_ammo_cost ) && table_ammo_cost != "" )
	{
		ammo_cost = round_up_to_ten( int( table_ammo_cost ) );
	}

	PrecacheString( hint );

	struct = SpawnStruct();

	if( !IsDefined( level.zombie_weapons ) )
	{
		level.zombie_weapons = [];
	}

	struct.weapon_name = weapon_name;
	struct.upgrade_name = upgrade_name;
	struct.weapon_classname = "weapon_" + weapon_name;
	struct.hint = hint;
	struct.cost = cost;
	struct.vox = weaponVO;
	struct.vox_response = weaponVOresp;
	
	println( "ZM >> Looking for weapon - " + weapon_name );
	
	struct.is_in_box = level.zombie_include_weapons[weapon_name];

	if( !IsDefined( ammo_cost ) )
	{
		ammo_cost = round_up_to_ten( int( cost * 0.5 ) );
	}

	struct.ammo_cost = ammo_cost;

	level.zombie_weapons[weapon_name] = struct;
}

default_weighting_func()
{
	return 1;
}

default_tesla_weighting_func()
{
	num_to_add = 1;
	if( isDefined( level.pulls_since_last_tesla_gun ) )
	{
		// player has dropped the tesla for another weapon, so we set all future polls to 20%
		if( isDefined(level.player_drops_tesla_gun) && level.player_drops_tesla_gun == true )
		{						
			num_to_add += int(.2 * level.zombie_include_weapons.size);		
		}
		
		// player has not seen tesla gun in late rounds
		if( !isDefined(level.player_seen_tesla_gun) || level.player_seen_tesla_gun == false )
		{
			// after round 10 the Tesla gun percentage increases to 20%
			if( level.round_number > 10 )
			{
				num_to_add += int(.2 * level.zombie_include_weapons.size);
			}		
			// after round 5 the Tesla gun percentage increases to 15%
			else if( level.round_number > 5 )
			{
				// calculate the number of times we have to add it to the array to get the desired percent
				num_to_add += int(.15 * level.zombie_include_weapons.size);
			}						
		}
	}
	return num_to_add;
}


//
//	For weapons which should only appear once the box moves
default_1st_move_weighting_func()
{
	if( level.chest_moves > 0 )
	{	
		num_to_add = 1;

		return num_to_add;	
	}
	else
	{
		return 0;
	}
}


//
//	Default weighting for a high-level weapon that is too good for the normal box
default_upgrade_weapon_weighting_func()
{
	if ( level.chest_moves > 1 )
	{
		return 1;
	}
	else
	{
		return 0;
	}
}


//
//	Slightly elevate the chance to get it until someone has it, then make it even
default_cymbal_monkey_weighting_func()
{
	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}


is_weapon_included( weapon_name )
{
	if( !IsDefined( level.zombie_weapons ) )
	{
		return false;
	}

	return IsDefined( level.zombie_weapons[weapon_name] );
}


include_zombie_weapon( weapon_name, in_box, collector, weighting_func )
{
	if( !IsDefined( level.zombie_include_weapons ) )
	{
		level.zombie_include_weapons = [];
		level.collector_achievement_weapons = [];
	}
	if( !isDefined( in_box ) )
	{
		in_box = true;
	}
	if( isDefined( collector ) && collector )
	{
		level.collector_achievement_weapons = array_add( level.collector_achievement_weapons, weapon_name );
	}

println( "ZM >> Including weapon - " + weapon_name );
	level.zombie_include_weapons[weapon_name] = in_box;

	PrecacheItem( weapon_name );

	if( !isDefined( weighting_func ) )
	{
		level.weapon_weighting_funcs[weapon_name] = ::default_weighting_func;
	}
	else
	{
		level.weapon_weighting_funcs[weapon_name] = weighting_func;
	}
}


//
//Z2 add_zombie_weapon will call PrecacheItem on the weapon name.  So this means we're loading 
//		the model even if we're not using it?  This could save some memory if we change this.
init_weapons()
{
	// Zombify
//	PrecacheItem( "zombie_melee" );

	//Z2 Weapons disabled for now
	// Pistols

	//T6todo
	add_zombie_weapon( "m1911_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "python_zm",					"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				2200,	"pistol",			"",		undefined );
	add_zombie_weapon( "cz75_zm",					"cz75_upgraded_zm",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );

	//	Weapons - SMGs
	add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"ZOMBIE_WEAPON_AK74U",					1200,		"smg",				"",		undefined );
	add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,		"smg",				"",		undefined );
//	add_zombie_weapon( "mp40_zm",					"mp40_upgraded_zm",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "mpl_zm",					"mpl_upgraded_zm",						&"ZOMBIE_WEAPON_MPL",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "pm63_zm",					"pm63_upgraded_zm",						&"ZOMBIE_WEAPON_PM63",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "spectre_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );

	//	Weapons - Dual Wield
	add_zombie_weapon( "cz75dw_zm",					"cz75dw_upgraded_zm",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

	//	Weapons - Shotguns
	add_zombie_weapon( "ithaca_zm",					"ithaca_upgraded_zm",					&"ZOMBIE_WEAPON_ITHACA",				1500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "spas_zm",					"spas_upgraded_zm",						&"ZOMBIE_WEAPON_SPAS",					2000,		"shotgun",			"",		undefined );
	add_zombie_weapon( "rottweil72_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,		"shotgun",			"",		undefined );
	add_zombie_weapon( "hs10_zm",					"hs10_upgraded_zm",						&"ZOMBIE_WEAPON_HS10",					50,		"shotgun",			"",		undefined );

	//	Weapons - Semi-Auto Rifles
	add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,		"rifle",			"",		undefined );

	//	Weapons - Burst Rifles
	add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "g11_lps_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "famas_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,		"burstrifle",		"",		undefined );

	//	Weapons - Assault Rifles
	add_zombie_weapon( "aug_acog_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
	add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					100,	"assault",			"",		undefined );
	add_zombie_weapon( "commando_zm",				"commando_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					100,	"burstrifle",			"",		undefined );

	//	Weapons - Sniper Rifles
	add_zombie_weapon( "dragunov_zm",				"dragunov_upgraded_zm",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,		"sniper",			"",		undefined );
	add_zombie_weapon( "l96a1_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );

	//	Weapons - Machineguns
	add_zombie_weapon( "rpk_zm",					"rpk_upgraded_zm",						&"ZOMBIE_WEAPON_RPK",					4000,		"mg",				"",		undefined );
	add_zombie_weapon( "hk21_zm",					"hk21_upgraded_zm",						&"ZOMBIE_WEAPON_HK21",					50,		"mg",				"",		undefined );

	// Grenades                                         		
	add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );
	add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		250,	"grenade",			"",		undefined );
//	add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );

	// Rocket Launchers
	add_zombie_weapon( "m72_law_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined ); 
	add_zombie_weapon( "china_lake_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined ); 

	// Special                                          	
 /*	add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );
 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	add_zombie_weapon( "tesla_gun_zm",				"tesla_gun_upgraded_zm",				&"ZOMBIE_WEAPON_TESLA", 				10,		"tesla",			"",		undefined );
 	add_zombie_weapon( "thundergun_zm",				"thundergun_upgraded_zm",				&"ZOMBIE_WEAPON_THUNDERGUN", 			10,		"thunder",			"",		undefined );
 	add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );
 	add_zombie_weapon( "knife_ballistic_sickle_zm",	"knife_ballistic_sickle_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",	"",		undefined );
 	add_zombie_weapon( "freezegun_zm",				"freezegun_upgraded_zm",				&"ZOMBIE_WEAPON_FREEZEGUN", 			10,		"freezegun",		"",		undefined );
 	add_zombie_weapon( "zombie_black_hole_bomb",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"gersh",			"",		undefined );
 	add_zombie_weapon( "zombie_nesting_dolls",		undefined,								&"ZOMBIE_WEAPON_NESTING_DOLLS", 		2000,	"dolls",	"",		undefined );
*/
	if(IsDefined(level._zombie_custom_add_weapons))
	{
		[[level._zombie_custom_add_weapons]]();
	}

	Precachemodel("zombie_teddybear");
}   

//remove this function and whenever it's call for production. this is only for testing purpose.
add_limited_tesla_gun()
{

	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		hint_string = weapon_spawns[i].zombie_weapon_upgrade; 
		if(hint_string == "tesla_gun_zm")
		{
			weapon_spawns[i] waittill("trigger");
			weapon_spawns[i] disable_trigger();
			break;

		}
		
	}

}


add_limited_weapon( weapon_name, amount )
{
	if( !IsDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[weapon_name] = amount;
}                                          	

// For pay turrets
init_pay_turret()
{
	pay_turrets = [];
	pay_turrets = GetEntArray( "pay_turret", "targetname" );
	
	for( i = 0; i < pay_turrets.size; i++ )
	{
		cost = level.pay_turret_cost;
		if( !isDefined( cost ) )
		{
			cost = 1000;
		}
		pay_turrets[i] SetHintString( &"ZOMBIE_PAY_TURRET", cost );
		pay_turrets[i] SetCursorHint( "HINT_NOICON" );
		pay_turrets[i] UseTriggerRequireLookAt();
		
		pay_turrets[i] thread pay_turret_think( cost );
	}
}

// For buying weapon upgrades in the environment
init_weapon_upgrade()
{
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		hint_string = get_weapon_hint( weapon_spawns[i].zombie_weapon_upgrade ); 
		cost = get_weapon_cost( weapon_spawns[i].zombie_weapon_upgrade );

		weapon_spawns[i] SetHintString( hint_string, cost ); 
		weapon_spawns[i] setCursorHint( "HINT_NOICON" ); 
		weapon_spawns[i] UseTriggerRequireLookAt();

		weapon_spawns[i] thread weapon_spawn_think(); 
		model = getent( weapon_spawns[i].target, "targetname" ); 
		model useweaponhidetags( weapon_spawns[i].zombie_weapon_upgrade );
		model hide(); 
	}
}

// For toggling which weapons can appear from the box
init_weapon_toggle()
{
	if ( !isdefined( level.magic_box_weapon_toggle_init_callback ) )
	{
		return;
	}

	level.zombie_weapon_toggles = [];
	level.zombie_weapon_toggle_max_active_count = 0;
	level.zombie_weapon_toggle_active_count = 0;

	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_DISABLED" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_ACTIVATE" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_DEACTIVATE" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_ACQUIRED" );
	level.zombie_weapon_toggle_disabled_hint = &"ZOMBIE_WEAPON_TOGGLE_DISABLED";
	level.zombie_weapon_toggle_activate_hint = &"ZOMBIE_WEAPON_TOGGLE_ACTIVATE";
	level.zombie_weapon_toggle_deactivate_hint = &"ZOMBIE_WEAPON_TOGGLE_DEACTIVATE";
	level.zombie_weapon_toggle_acquired_hint = &"ZOMBIE_WEAPON_TOGGLE_ACQUIRED";

	PrecacheModel( "zombie_zapper_cagelight" );
	PrecacheModel( "zombie_zapper_cagelight_green" );
	PrecacheModel( "zombie_zapper_cagelight_red" );
	PrecacheModel( "zombie_zapper_cagelight_on" );
	level.zombie_weapon_toggle_disabled_light = "zombie_zapper_cagelight";
	level.zombie_weapon_toggle_active_light = "zombie_zapper_cagelight_green";
	level.zombie_weapon_toggle_inactive_light = "zombie_zapper_cagelight_red";
	level.zombie_weapon_toggle_acquired_light = "zombie_zapper_cagelight_on";

	weapon_toggle_ents = [];
	weapon_toggle_ents = GetEntArray( "magic_box_weapon_toggle", "targetname" );

	for ( i = 0; i < weapon_toggle_ents.size; i++ )
	{
		struct = SpawnStruct();

		struct.trigger = weapon_toggle_ents[i];
		struct.weapon_name = struct.trigger.script_string;
		struct.upgrade_name = level.zombie_weapons[struct.trigger.script_string].upgrade_name;
		struct.enabled = false;
		struct.active = false;
		struct.acquired = false;

		target_array = [];
		target_array = GetEntArray( struct.trigger.target, "targetname" );
		for ( j = 0; j < target_array.size; j++ )
		{
			switch ( target_array[j].script_string )
			{
			case "light":
				struct.light = target_array[j];
				struct.light setmodel( level.zombie_weapon_toggle_disabled_light );
				break;
			case "weapon":
				struct.weapon_model = target_array[j];
				struct.weapon_model hide();
				break;
			}
		}

		struct.trigger SetHintString( level.zombie_weapon_toggle_disabled_hint );
		struct.trigger setCursorHint( "HINT_NOICON" );
		struct.trigger UseTriggerRequireLookAt();

		struct thread weapon_toggle_think();

		level.zombie_weapon_toggles[struct.weapon_name] = struct;
	}

	//for initial enable and disable of toggles, and determination of which are activated
	level thread [[level.magic_box_weapon_toggle_init_callback]]();
}


// an upgrade of a weapon toggle is also considered a weapon toggle
get_weapon_toggle( weapon_name )
{
	if ( !isdefined( level.zombie_weapon_toggles ) )
	{
		return undefined;
	}

	if ( isdefined( level.zombie_weapon_toggles[weapon_name] ) )
	{
		return level.zombie_weapon_toggles[weapon_name];
	}

	keys = GetArrayKeys( level.zombie_weapon_toggles );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( weapon_name == level.zombie_weapon_toggles[keys[i]].upgrade_name )
		{
			return level.zombie_weapon_toggles[keys[i]];
		}
	}

	return undefined;
}


is_weapon_toggle( weapon_name )
{
	return isdefined( get_weapon_toggle( weapon_name ) );
}


disable_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( toggle.active )
	{
		level.zombie_weapon_toggle_active_count--;
	}
	toggle.enabled = false;
	toggle.active = false;

	toggle.light setmodel( level.zombie_weapon_toggle_disabled_light );
	toggle.weapon_model hide();
	toggle.trigger SetHintString( level.zombie_weapon_toggle_disabled_hint );
}


enable_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	toggle.enabled = true;
	toggle.weapon_model show();
	toggle.weapon_model useweaponhidetags( weapon_name );

	deactivate_weapon_toggle( weapon_name );
}


activate_weapon_toggle( weapon_name, trig_for_vox )
{
	if ( level.zombie_weapon_toggle_active_count >= level.zombie_weapon_toggle_max_active_count )
	{
        if( IsDefined( trig_for_vox ) )
        {
           trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "max" );
        }
            
		return;
	}

	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}
	
	if( IsDefined( trig_for_vox ) )
	{
	    trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "activate", weapon_name );
	}

	level.zombie_weapon_toggle_active_count++;
	toggle.active = true;

	toggle.light setmodel( level.zombie_weapon_toggle_active_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_deactivate_hint );
}


deactivate_weapon_toggle( weapon_name, trig_for_vox )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}
	
	if( IsDefined( trig_for_vox ) )
	{
	    trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "deactivate", weapon_name );
	}

	if ( toggle.active )
	{
		level.zombie_weapon_toggle_active_count--;
	}
	toggle.active = false;

	toggle.light setmodel( level.zombie_weapon_toggle_inactive_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_activate_hint );
}


acquire_weapon_toggle( weapon_name, player )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( !toggle.active || toggle.acquired )
	{
		return;
	}
	toggle.acquired = true;

	toggle.light setmodel( level.zombie_weapon_toggle_acquired_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_acquired_hint );
	
	toggle thread unacquire_weapon_toggle_on_death_or_disconnect_thread( player );
}


unacquire_weapon_toggle_on_death_or_disconnect_thread( player )
{
	self notify( "end_unacquire_weapon_thread" );
	self endon( "end_unacquire_weapon_thread" );

	player waittill_any( "spawned_spectator", "disconnect" );

	unacquire_weapon_toggle( self.weapon_name );
}


unacquire_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( !toggle.active || !toggle.acquired )
	{
		return;
	}

	toggle.acquired = false;

	toggle.light setmodel( level.zombie_weapon_toggle_active_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_deactivate_hint );

	toggle notify( "end_unacquire_weapon_thread" );
}


weapon_toggle_think()
{
	for( ;; )
	{
		self.trigger waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
        
		if ( !self.enabled || self.acquired )
		{
           self.trigger thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "max" );
		}
		else if ( !self.active )
		{
			activate_weapon_toggle( self.weapon_name, self.trigger );
		}
		else
		{
			deactivate_weapon_toggle( self.weapon_name, self.trigger );
		}
	}
}


// weapon cabinets which open on use
init_weapon_cabinet()
{
	// the triggers which are targeted at doors
	weapon_cabs = GetEntArray( "weapon_cabinet_use", "targetname" ); 

	for( i = 0; i < weapon_cabs.size; i++ )
	{

		weapon_cabs[i] SetHintString( &"ZOMBIE_CABINET_OPEN_1500" ); 
		weapon_cabs[i] setCursorHint( "HINT_NOICON" ); 
		weapon_cabs[i] UseTriggerRequireLookAt();
	}

//	array_thread( weapon_cabs, ::weapon_cabinet_think ); 
}

// returns the trigger hint string for the given weapon
get_weapon_hint( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].hint;
}

get_weapon_cost( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].cost;
}

get_ammo_cost( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].ammo_cost;
}

get_is_in_box( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );
	
	return level.zombie_weapons[weapon_name].is_in_box;
}


// Check to see if this is an upgraded version of another weapon
//	weaponname can be any weapon name.
is_weapon_upgraded( weaponname )
{
	if( !isdefined( weaponname ) || weaponname == "" )
	{
		return false;
	}

	weaponname = ToLower( weaponname );

	ziw_keys = GetArrayKeys( level.zombie_weapons );
	for ( i=0; i<level.zombie_weapons.size; i++ )
	{
		if ( IsDefined(level.zombie_weapons[ ziw_keys[i] ].upgrade_name) && 
			 level.zombie_weapons[ ziw_keys[i] ].upgrade_name == weaponname )
		{
			return true;
		}
	}

	return false;
}


//	Check to see if the player has the upgraded version of the weapon
//	weaponname should only be a base weapon name
//	self is a player
has_upgrade( weaponname )
{
	has_upgrade = false;
	if( IsDefined(level.zombie_weapons[weaponname]) && IsDefined(level.zombie_weapons[weaponname].upgrade_name) )
	{
		has_upgrade = self HasWeapon( level.zombie_weapons[weaponname].upgrade_name );
	}

	// double check for the bowie variant on the ballistic knife	
	if ( !has_upgrade && "knife_ballistic_zm" == weaponname )
	{
		has_upgrade = has_upgrade( "knife_ballistic_bowie_zm" ) || has_upgrade( "knife_ballistic_sickle_zm" );
	}

	return has_upgrade;
}


//	Check to see if the player has the normal or upgraded weapon
//	weaponname should only be a base weapon name
//	self is a player
has_weapon_or_upgrade( weaponname )
{
	upgradedweaponname = weaponname;
	if ( IsDefined( level.zombie_weapons[weaponname] ) && IsDefined( level.zombie_weapons[weaponname].upgrade_name ) )
	{
		upgradedweaponname = level.zombie_weapons[weaponname].upgrade_name;
	}

	has_weapon = false;
	// If the weapon you're checking doesn't exist, it will return undefined
	if( IsDefined( level.zombie_weapons[weaponname] ) )
	{
		has_weapon = self HasWeapon( weaponname ) || self has_upgrade( weaponname );
	}

	// double check for the bowie variant on the ballistic knife	
	if ( !has_weapon && "knife_ballistic_zm" == weaponname )
	{
		has_weapon = has_weapon_or_upgrade( "knife_ballistic_bowie_zm" ) || has_weapon_or_upgrade( "knife_ballistic_sickle_zm" );
	}

	return has_weapon;
}


pay_turret_think( cost )
{
	if( !isDefined( self.target ) )
	{
		return;
	}
	turret = GetEnt( self.target, "targetname" );

	if( !isDefined( turret ) )
	{
		return;
	}
	
	turret makeTurretUnusable();
	
	// figure out what zone it's in
	zone_name = turret get_current_zone();
	if ( !IsDefined( zone_name ) )
	{
		zone_name = "";
	}

	while( true )
	{
		self waittill( "trigger", player );
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}

		if( player is_drinking() )
		{
			wait(0.1);
			continue;
		}
		
		if( player.score >= cost )
		{
			player maps\mp\zombies\_zm_score::minus_to_player_score( cost );
	//T6todo		bbPrint( "zombie_uses: playername %s playerscore %d teamscore %d round %d cost %d name %s x %f y %f z %f type turret", player.playername, player.score, level.team_pool[ player.team_num ].score, level.round_number, cost, zone_name, self.origin );
			turret makeTurretUsable();
			turret UseBy( player );
			self disable_trigger();
			
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", "mg" );
			
			player.curr_pay_turret = turret;
			
			turret thread watch_for_laststand( player );
			turret thread watch_for_fake_death( player );
			if( isDefined( level.turret_timer ) )
			{
				turret thread watch_for_timeout( player, level.turret_timer );
			}
			
			while( isDefined( turret getTurretOwner() ) && turret getTurretOwner() == player )
			{
				wait( 0.05 );
			}
			
			turret notify( "stop watching" );
			
			player.curr_pay_turret = undefined;
			
			turret makeTurretUnusable();
			self enable_trigger();
		}
		else // not enough money
		{
			play_sound_on_ent( "no_purchase" );
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 0 );
		}
	}
}

watch_for_laststand( player )
{
	self endon( "stop watching" );
	
//T6todo	while( !player maps\_laststand::player_is_in_laststand() )
//T6todo	{
//T6todo		if( isDefined( level.intermission ) && level.intermission )
//T6todo		{
//T6todo			intermission = true;
//T6todo		}
//T6todo		wait( 0.05 );
//T6todo	}
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

watch_for_fake_death( player )
{
	self endon( "stop watching" );
	
	player waittill( "fake_death" );
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

watch_for_timeout( player, time )
{
	self endon( "stop watching" );
	
	self thread cancel_timer_on_end( player );
	
//	player thread maps\_zombiemode_timer::start_timer( time, "stop watching" );
	
	wait( time );
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

cancel_timer_on_end( player )
{
	self waittill( "stop watching" );
	player notify( "stop watching" );
}

weapon_cabinet_door_open( left_or_right )
{
	if( left_or_right == "left" )
	{
		self rotateyaw( 120, 0.3, 0.2, 0.1 ); 	
	}
	else if( left_or_right == "right" )
	{
		self rotateyaw( -120, 0.3, 0.2, 0.1 ); 	
	}	
}

check_collector_achievement( bought_weapon )
{
	if ( !isdefined( self.bought_weapons ) )
	{
		self.bought_weapons = [];
		self.bought_weapons = array_add( self.bought_weapons, bought_weapon );
	}
	else if ( !is_in_array( self.bought_weapons, bought_weapon ) )
	{
		self.bought_weapons = array_add( self.bought_weapons, bought_weapon );
	}
	else
	{
		// don't bother checking, they've bought it before
		return;
	}
	
	for( i = 0; i < level.collector_achievement_weapons.size; i++ )
	{
		if ( !is_in_array( self.bought_weapons, level.collector_achievement_weapons[i] ) )
		{
			return;
		}
	}
	
	self giveachievement_wrapper( "SP_ZOM_COLLECTOR" );
}

weapon_set_first_time_hint( cost, ammo_cost )
{
	if ( isDefined( level.has_pack_a_punch ) && !level.has_pack_a_punch )
	{
		self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
	}
	else
	{
		self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO_UPGRADE", cost, ammo_cost ); 
	}
}

weapon_spawn_think()
{
	cost = get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
	is_grenade = (WeaponType( self.zombie_weapon_upgrade ) == "grenade");

	self thread decide_hide_show_hint();

	self.first_time_triggered = false; 
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( !player can_buy_weapon() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player has_powerup_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		// Allow people to get ammo off the wall for upgraded weapons
		player_has_weapon = player has_weapon_or_upgrade( self.zombie_weapon_upgrade ); 

		if( !player_has_weapon )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true; 

					if(!is_grenade)
					{
						self weapon_set_first_time_hint( cost, ammo_cost );
					}
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score( cost ); 

	//T6todo			bbPrint( "zombie_uses: playername %s playerscore %d teamscore %d round %d cost %d name %s x %f y %f z %f type weapon",
	//T6todo					player.playername, player.score, level.team_pool[ player.team_num ].score, level.round_number, cost, self.zombie_weapon_upgrade, self.origin );

				if ( is_lethal_grenade( self.zombie_weapon_upgrade ) )
				{
					player takeweapon( player get_player_lethal_grenade() );
					player set_player_lethal_grenade( self.zombie_weapon_upgrade );
				}

				player weapon_give( self.zombie_weapon_upgrade );

				player check_collector_achievement( self.zombie_weapon_upgrade );
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 1 );
				
			}
		}
		else
		{
			// MM - need to check and see if the player has an upgraded weapon.  If so, the ammo cost is much higher
			if ( player has_upgrade( self.zombie_weapon_upgrade ) )
			{
				ammo_cost = 4500;
			}
			else
			{
				ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
			}

			// if the player does have this then give him ammo.
			if( player.score >= ammo_cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true;
					if(!is_grenade)
					{ 
						self weapon_set_first_time_hint( cost, get_ammo_cost( self.zombie_weapon_upgrade ) );
					}
				}

				player check_collector_achievement( self.zombie_weapon_upgrade );

//				MM - I don't think this is necessary
// 				if( player HasWeapon( self.zombie_weapon_upgrade ) && player has_upgrade( self.zombie_weapon_upgrade ) )
// 				{
// 					ammo_given = player ammo_give( self.zombie_weapon_upgrade, true ); 
// 				}
//				else 
				if( player has_upgrade( self.zombie_weapon_upgrade ) )
				{
					ammo_given = player ammo_give( level.zombie_weapons[ self.zombie_weapon_upgrade ].upgrade_name );
				}
				else
				{
					ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				}
				
				if( ammo_given )
				{
						player maps\mp\zombies\_zm_score::minus_to_player_score( ammo_cost ); // this give him ammo to early

//T6todo					bbPrint( "zombie_uses: playername %s playerscore %d teamscore %d round %d cost %d name %s x %f y %f z %f type ammo",
//T6todo						player.playername, player.score, level.team_pool[ player.team_num ].score, level.round_number, ammo_cost, self.zombie_weapon_upgrade, self.origin );
				}
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 0 );
			}
		}
	}
}

weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1];

	if ( isdefined( self.script_int ) )
	{
		weapon_yaw -= self.script_int;
	}

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin +( AnglesToForward( ( 0, yaw, 0 ) ) * 8 ); 

	wait( 0.05 ); 
	self Show(); 

	play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}

get_pack_a_punch_weapon_options( weapon )
{
	if ( !isDefined( self.pack_a_punch_weapon_options ) )
	{
		self.pack_a_punch_weapon_options = [];
	}

	if ( !is_weapon_upgraded( weapon ) )
	{
		return self CalcWeaponOptions( 0 );
	}

	if ( isDefined( self.pack_a_punch_weapon_options[weapon] ) )
	{
		return self.pack_a_punch_weapon_options[weapon];
	}

	smiley_face_reticle_index = 21; // smiley face is reserved for the upgraded famas, keep it at the end of the list

	camo_index = 15;
	lens_index = randomIntRange( 0, 6 );
	reticle_index = randomIntRange( 0, smiley_face_reticle_index );
	reticle_color_index = randomIntRange( 0, 6 );

	if ( "famas_upgraded_zm" == weapon )
	{
		reticle_index = smiley_face_reticle_index;
	}
	
/*
/#
	if ( GetDvarInt( "scr_force_reticle_index" ) )
	{
		reticle_index = GetDvarInt( "scr_force_reticle_index" );
	}
#/
*/

	scary_eyes_reticle_index = 8; // weapon_reticle_zom_eyes
	purple_reticle_color_index = 3; // 175 0 255
	if ( reticle_index == scary_eyes_reticle_index )
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2; // weapon_reticle_zom_a
	pink_reticle_color_index = 6; // 255 105 180
	if ( reticle_index == letter_a_reticle_index )
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7; // weapon_reticle_zom_e
	green_reticle_color_index = 1; // 0 255 0
	if ( reticle_index == letter_e_reticle_index )
	{
		reticle_color_index = green_reticle_color_index;
	}

	self.pack_a_punch_weapon_options[weapon] = self CalcWeaponOptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[weapon];
}

weapon_give( weapon, is_upgrade )
{
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined;
	weapon_limit = 2;

	//if is not an upgraded perk purchase
	if( !IsDefined( is_upgrade ) )
	{
		is_upgrade = false;
	}

//t6todo 	if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
//t6todo 	{
 //t6todo		weapon_limit = 3;
//t6todo 	}

	// This should never be true for the first time.
	if( primaryWeapons.size >= weapon_limit )
	{
		current_weapon = self getCurrentWeapon(); // get his current weapon

		if ( is_placeable_mine( current_weapon ) )
		{
			current_weapon = undefined;
		}

		if( isdefined( current_weapon ) )
		{
			if( !is_offhand_weapon( weapon ) )
			{
				if ( issubstr( current_weapon, "knife_ballistic_" ) )
				{
					self notify( "zmb_lost_knife" );
				}
				self TakeWeapon( current_weapon ); 
				unacquire_weapon_toggle( current_weapon );
				if ( current_weapon == "m1911_zm" )
				{
					self.last_pistol_swap = GetTime();
				}
			}
		} 
	}
	
	if( IsDefined( level.zombiemode_offhand_weapon_give_override ) )
	{
		if( self [[ level.zombiemode_offhand_weapon_give_override ]]( weapon ) )
		{
			return;
		}
	}

//T6todo	if( weapon == "zombie_cymbal_monkey" )
//T6todo	{
//T6todo		self maps\_zombiemode_weap_cymbal_monkey::player_give_cymbal_monkey();
//T6todo		self play_weapon_vo( weapon );
//T6todo		return;
//T6todo	}

	self play_sound_on_ent( "purchase" );

	if ( !is_weapon_upgraded( weapon ) )
	{
		self GiveWeapon( weapon );
	}
	else
	{
		self GiveWeapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
	}

	acquire_weapon_toggle( weapon, self );
	self GiveStartAmmo( weapon );
	self SwitchToWeapon( weapon );
	 
	self play_weapon_vo(weapon);
}

play_weapon_vo(weapon)
{
	//Added this in for special instances of New characters with differing favorite weapons
	if ( isDefined( level._audio_custom_weapon_check ) )
	{
		type = self [[ level._audio_custom_weapon_check ]]( weapon );
	}
	else
	{
	    type = self weapon_type_check(weapon);
	}
				
	self maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", type );
}

weapon_type_check(weapon)
{
    if( !IsDefined( self.entity_num ) )
        return "crappy";    
    
    switch(self.entity_num)
    {
        case 0:   //DEMPSEY'S FAVORITE WEAPON: M16 UPGRADED: ROTTWEIL72
            if( weapon == "m16_zm" )
                return "favorite";
            else if( weapon == "rottweil72_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 1:   //NIKOLAI'S FAVORITE WEAPON: FNFAL UPGRADED: HK21
            if( weapon == "fnfal_zm" )
                return "favorite";
            else if( weapon == "hk21_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 2:   //TAKEO'S FAVORITE WEAPON: M202 UPGRADED: THUNDERGUN
            if( weapon == "china_lake_zm" )
                return "favorite";
            else if( weapon == "thundergun_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 3:   //RICHTOFEN'S FAVORITE WEAPON: MP40 UPGRADED: CROSSBOW
            if( weapon == "mp40_zm" )
                return "favorite";
            else if( weapon == "crossbow_explosive_upgraded_zm" )
                return "favorite_upgrade";   
            break;                
    }
    
    if( IsSubStr( weapon, "upgraded" ) )
        return "upgrade";
    else
        return level.zombie_weapons[weapon].vox;
}


get_player_index(player)
{
	assert( IsPlayer( player ) );
	assert( IsDefined( player.entity_num ) );
/#
	// used for testing to switch player's VO in-game from devgui
	if( player.entity_num == 0 && GetDvar( "zombie_player_vo_overwrite" ) != "" )
	{
		new_vo_index = GetDvarInt( "zombie_player_vo_overwrite" );
		return new_vo_index;
	}
#/
	return player.entity_num;
}

ammo_give( weapon )
{
	// We assume before calling this function we already checked to see if the player has this weapon...

	// Should we give ammo to the player
	give_ammo = false; 

	// Check to see if ammo belongs to a primary weapon
	if( !is_offhand_weapon( weapon ) )
	{
		if( isdefined( weapon ) )  
		{
			// get the max allowed ammo on the current weapon
			stockMax = 0;	// scope declaration
			stockMax = WeaponStartAmmo( weapon ); 

			// Get the current weapon clip count
			clipCount = self GetWeaponAmmoClip( weapon ); 

			currStock = self GetAmmoCount( weapon );

			// compare it with the ammo player actually has, if more or equal just dont give the ammo, else do
			if( ( currStock - clipcount ) >= stockMax )	
			{
				give_ammo = false; 
			}
			else
			{
				give_ammo = true; // give the ammo to the player
			}
		}
	}
	else
	{
		// Ammo belongs to secondary weapon
		if( self has_weapon_or_upgrade( weapon ) )
		{
			// Check if the player has less than max stock, if no give ammo
			if( self getammocount( weapon ) < WeaponMaxAmmo( weapon ) )
			{
				// give the ammo to the player
				give_ammo = true; 					
			}
		}		
	}	

	if( give_ammo )
	{
		self play_sound_on_ent( "purchase" ); 
		self GiveStartAmmo( weapon );
// 		if( also_has_upgrade )
// 		{
// 			self GiveMaxAmmo( weapon+"_upgraded" );
// 		}
		return true;
	}

	if( !give_ammo )
	{
		return false;
	}
}
