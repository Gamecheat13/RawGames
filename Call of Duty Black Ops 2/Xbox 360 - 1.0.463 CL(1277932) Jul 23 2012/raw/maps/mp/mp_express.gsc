#include maps\mp\_utility;
#include common_scripts\utility; 

main()
{
	level.levelSpawnDvars = ::levelSpawnDvars;
	
	//needs to be first for create fx
	maps\mp\mp_express_fx::main();

	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_express");

	maps\mp\mp_express_amb::main();

	// Set up the default range of the compass
	setdvar("compassmaxrange","2100");

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

	// enable new spawning system

	RegisterClientField( "vehicle", "train_moving", 1, "int" );
	RegisterClientField( "scriptmover", "train_moving", 1, "int" );

	if ( GetGametypeSetting( "allowMapScripting" ) )
	{
		maps\mp\mp_express_train::init();
	}
	
	/# 
		level thread devgui_express();
		execdevgui( "devgui_mp_express" );
	#/
}

levelSpawnDvars ( reset_dvars )
{
	ss = level.spawnsystem;
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", "1900", reset_dvars);	
}


/#
	devgui_express()
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

			case "train_start":
				level notify( "train_start" );
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
#/