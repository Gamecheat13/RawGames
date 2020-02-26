main()
{
	maps\mp\mp_hangar_fx::main();		
	maps\mp\_load::main();
	
	maps\mp\mp_hangar_amb::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_hangar");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_HANGAR_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_HANGAR_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_HANGAR_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_HANGAR_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_HANGAR_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_HANGAR_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_HANGAR_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_HANGAR_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_HANGAR_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_HANGAR_E";

	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}