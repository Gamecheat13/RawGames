main()
{
	maps\mp\mp_outskirts_fx::main();
	maps\mp\createart\mp_outskirts_art::main();
	
	maps\mp\_load::main();
	
	// maps\mp\mp_outskirts_amb::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_outskirts");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_OUTSKIRTS_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_OUTSKIRTS_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_OUTSKIRTS_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_OUTSKIRTS_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_OUTSKIRTS_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_OUTSKIRTS_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_OUTSKIRTS_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_OUTSKIRTS_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_OUTSKIRTS_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_OUTSKIRTS_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
