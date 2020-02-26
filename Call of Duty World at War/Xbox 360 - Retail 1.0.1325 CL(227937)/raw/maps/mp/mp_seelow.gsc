main()
{


  maps\mp\mp_seelow_fx::main();
	maps\mp\createart\mp_seelow_art::main();

	maps\mp\_load::main();
	
	thread maps\mp\mp_seelow_amb::main();

	// uncomment this when you have your own mini-map for this map
	maps\mp\_compass::setupMiniMap("compass_map_mp_seelow");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_SEELOW_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_SEELOW_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_SEELOW_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_SEELOW_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_SEELOW_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_SEELOW_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_SEELOW_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_SEELOW_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_SEELOW_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_SEELOW_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	//setVolFog(512, 1028, 1360, -448, 0.38, 0.45, 0.58, 0);
	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
}
