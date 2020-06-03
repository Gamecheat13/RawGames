main()
{

	maps\mp\mp_roundhouse_fx::main();	
	maps\mp\createart\mp_roundhouse_art::main();

	maps\mp\_load::main();
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	
	
	maps\mp\mp_roundhouse_amb::main();

	// uncomment this when you have your own mini-map for this map
	maps\mp\_compass::setupMiniMap("compass_map_mp_roundhouse");

	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_ROUNDHOUSE_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_ROUNDHOUSE_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_ROUNDHOUSE_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_ROUNDHOUSE_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_ROUNDHOUSE_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_ROUNDHOUSE_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_ROUNDHOUSE_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_ROUNDHOUSE_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_ROUNDHOUSE_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_ROUNDHOUSE_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	return;
}
