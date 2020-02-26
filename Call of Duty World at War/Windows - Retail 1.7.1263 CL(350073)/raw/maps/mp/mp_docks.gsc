main()
{
// needs to be first for create fx
	maps\mp\mp_docks_fx::main();
// maps\mp\createart\mp_docks_art::main();


	maps\mp\_load::main();

	maps\mp\mp_docks_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_docks");
//	setExpFog(512, 3316, 0.47, 0.52, 0.47, 0);
//	setVolFog(512, 3316, 512, 0, .47, 0.52, 0.47, 0);

   VisionSetNaked( "mp_docks" );
// ambientPlay("ambient_cargoshipmp_ext");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";
	
	game["strings"]["war_callsign_a"] = &"PATCH_CALLSIGN_DOCKS_A";
	game["strings"]["war_callsign_b"] = &"PATCH_CALLSIGN_DOCKS_B";
	game["strings"]["war_callsign_c"] = &"PATCH_CALLSIGN_DOCKS_C";
	game["strings"]["war_callsign_d"] = &"PATCH_CALLSIGN_DOCKS_D";
	game["strings"]["war_callsign_e"] = &"PATCH_CALLSIGN_DOCKS_E";

	game["strings_menu"]["war_callsign_a"] = "@PATCH_CALLSIGN_DOCKS_A";
	game["strings_menu"]["war_callsign_b"] = "@PATCH_CALLSIGN_DOCKS_B";
	game["strings_menu"]["war_callsign_c"] = "@PATCH_CALLSIGN_DOCKS_C";
	game["strings_menu"]["war_callsign_d"] = "@PATCH_CALLSIGN_DOCKS_D";
	game["strings_menu"]["war_callsign_e"] = "@PATCH_CALLSIGN_DOCKS_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
