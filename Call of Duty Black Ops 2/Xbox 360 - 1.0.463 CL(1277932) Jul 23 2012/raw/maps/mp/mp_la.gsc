#include maps\mp\_utility;
#include common_scripts\utility; 

main()
{
	//needs to be first for create fx
	maps\mp\mp_la_fx::main();

	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_la_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_la");
	}

	maps\mp\_load::main();

	maps\mp\mp_la_amb::main();

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

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 2600 );

	SetDvar( "sm_sunsamplesizenear", .39 );

	RegisterClientField( "scriptmover", "police_car_lights", 1, "int" );
	RegisterClientField( "scriptmover", "ambulance_lights", 1, "int" );

	level thread destructible_lights();
}

destructible_lights()
{
	wait( 0.05 );
	
	destructibles = GetEntArray( "destructible", "targetname" );

	foreach( destructible in destructibles )
	{
		if ( destructible.destructibledef == "veh_t6_police_car_destructible_mp" )
		{
			destructible thread destructible_think( "police_car_lights" );
			destructible SetClientField( "police_car_lights", 1 );
		}
		else if ( destructible.destructibledef == "veh_iw_civ_ambulance_destructible" )
		{
			destructible thread destructible_think( "ambulance_lights" );
			destructible SetClientField( "ambulance_lights", 1 );
		}
	}
}

destructible_think( clientfield )
{
	self waittill_any( "death", "destructible_base_piece_death" );
	self SetClientField( clientfield, 0 );
}