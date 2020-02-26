main()
{	
	maps\mp\mp_downfall_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_downfall_amb::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_downfall");
		
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_DOWNFALL_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_DOWNFALL_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_DOWNFALL_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_DOWNFALL_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_DOWNFALL_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_DOWNFALL_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_DOWNFALL_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_DOWNFALL_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_DOWNFALL_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_DOWNFALL_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
