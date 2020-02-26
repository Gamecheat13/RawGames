main()
{	
	precachemodel("collision_geo_128x128x128");
	
	maps\mp\mp_bgate_fx::main();

	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_bgate");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"PATCH_CALLSIGN_BGATE_A";
	game["strings"]["war_callsign_b"] = &"PATCH_CALLSIGN_BGATE_B";
	game["strings"]["war_callsign_c"] = &"PATCH_CALLSIGN_BGATE_C";
	game["strings"]["war_callsign_d"] = &"PATCH_CALLSIGN_BGATE_D";
	game["strings"]["war_callsign_e"] = &"PATCH_CALLSIGN_BGATE_E";

	game["strings_menu"]["war_callsign_a"] = "@PATCH_CALLSIGN_BGATE_A";
	game["strings_menu"]["war_callsign_b"] = "@PATCH_CALLSIGN_BGATE_B";
	game["strings_menu"]["war_callsign_c"] = "@PATCH_CALLSIGN_BGATE_C";
	game["strings_menu"]["war_callsign_d"] = "@PATCH_CALLSIGN_BGATE_D";
	game["strings_menu"]["war_callsign_e"] = "@PATCH_CALLSIGN_BGATE_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
}
