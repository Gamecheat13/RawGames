#include maps\mp\_utility;
#insert raw\common_scripts\utility.gsh;

main()
{
	level.levelSpawnDvars = ::levelSpawnDvars;
	
	//needs to be first for create fx
	maps\mp\mp_dockside_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_dockside_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_dockside");

	level.overridePlayerDeathWatchTimer = ::levelOverrideTime;
	level.useIntermissionPointsOnWaveSpawn = ::useIntermissionPointsOnWaveSpawn;

	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// Set up some generic War Flag Names.
	// Example from COD5: CALLSIGN_SEELOW_A is the name of the 1st flag in Selow whose string is "Cottage" 
	// The string must have MPUI_CALLSIGN_ and _A. Replace Mapname with the name of your map/bsp and in the 
	// actual string enter a keyword that names the location (Roundhouse, Missle Silo, Launchpad, Guard Tower, etc)

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";


	SetDvar( "sm_sunsamplesizenear", .39 );

	SetDvar( "sm_sunshadowsmall", 1 );

	if ( GetGametypeSetting( "allowMapScripting" ) )
	{
		level maps\mp\mp_dockside_crane::init();
	}
		
	SetHeliHeightPatchEnabled( "war_mode_heli_height_lock", false );

	// setting dvars for waves
	SetDvar( "r_waterwavespeed", ".583304 .495422 .407764 .507369" );
	SetDvar( "r_waterwaveamplitude", "8.93866 8.98639 13.9243 13.1055" );
	SetDvar( "r_waterwavewavelength", "229.912 260.78 479.609 661.14" );
	SetDvar( "r_waterwavesteepness", "1 1 1 1" );	
	SetDvar( "r_waterwaveangle", "129.49 80.8233 44.9883 107.143" );
	SetDvar( "r_waterwavephase", "0 0 0 0" );

	level thread water_trigger_init();

/#
	level thread devgui_dockside();
	execdevgui( "devgui_mp_dockside" );
#/
}

levelSpawnDvars ( reset_dvars )
{
	ss = level.spawnsystem;
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", "2700", reset_dvars);	
}

water_trigger_init()
{
	wait( 3 );

	triggers = GetEntArray( "trigger_hurt", "classname" );

	foreach( trigger in triggers )
	{
		if ( trigger.origin[2] > level.mapCenter[2] )
		{
			continue;
		}
		
		trigger thread water_trigger_think();
	}
}

water_trigger_think()
{
	for ( ;; )
	{
		self waittill( "trigger", entity );

		if ( IsPlayer( entity ) )
		{
			PlayFX( level._effect["water_splash"], entity.origin + ( 0, 0, 40 ) );
		}
	}
}


levelOverrideTime( defaultTime )
{
	if ( self isInWater() )
	{
		return 0.4;
	}
	return defaultTime;
}


useIntermissionPointsOnWaveSpawn()
{
	return self isInWater();
}


isInWater()
{
	triggers = GetEntArray( "trigger_hurt", "classname" );

	foreach( trigger in triggers )
	{
		if ( trigger.origin[2] > level.mapCenter[2] )
		{
			continue;
		}
		
		if ( self istouching( trigger ) )
		{
			return true;
		}
	}
	return false;
}





/#
devgui_dockside()
{
	SetDvar( "devgui_notify", "" );

	for ( ;; )
	{
		wait( 0.5 );

		devgui_string = GetDvar( "devgui_notify" );

		switch( devgui_string )
		{
			case "":
			break;

			case "crane_print_dvars":
				crane_print_dvars();
			break;

			default:
			break;
		}

		if ( GetDvar( "devgui_notify" ) != "" )
		{
			SetDvar( "devgui_notify", "" );
		}
	}
}

crane_print_dvars()
{
	dvars = [];
	ARRAY_ADD( dvars, "scr_crane_claw_move_time" );
	ARRAY_ADD( dvars, "scr_crane_crate_lower_time" );
	ARRAY_ADD( dvars, "scr_crane_crate_raise_time" );
	ARRAY_ADD( dvars, "scr_crane_arm_y_move_time" );
	ARRAY_ADD( dvars, "scr_crane_arm_z_move_time" );
	ARRAY_ADD( dvars, "scr_crane_claw_drop_speed" );
	ARRAY_ADD( dvars, "scr_crane_claw_drop_time_min" );
	
	foreach ( dvar in dvars )
	{
		print( dvar + ": " );
		println( GetDvar( dvar ) );
	}
}

#/