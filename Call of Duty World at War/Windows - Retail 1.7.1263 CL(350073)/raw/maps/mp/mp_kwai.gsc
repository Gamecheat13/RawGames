main()
{
	maps\mp\mp_kwai_fx::main();
	//maps\mp\createart\mp_kwai_art::main();

	maps\mp\_load::main();

  //maps\mp\mp_kwai_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_kwai");
	
	//setExpFog(300, 1400, 0.5, 0.5, 0.5, 0);
	VisionSetNaked( "mp_kwai" );
	//ambientPlay("ambient_cargoshipmp_ext");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";
	
	game["strings"]["war_callsign_a"] = &"PATCH_CALLSIGN_KWAI_A";
	game["strings"]["war_callsign_b"] = &"PATCH_CALLSIGN_KWAI_B";
	game["strings"]["war_callsign_c"] = &"PATCH_CALLSIGN_KWAI_C";
	game["strings"]["war_callsign_d"] = &"PATCH_CALLSIGN_KWAI_D";
	game["strings"]["war_callsign_e"] = &"PATCH_CALLSIGN_KWAI_E";

	game["strings_menu"]["war_callsign_a"] = "@PATCH_CALLSIGN_KWAI_A";
	game["strings_menu"]["war_callsign_b"] = "@PATCH_CALLSIGN_KWAI_B";
	game["strings_menu"]["war_callsign_c"] = "@PATCH_CALLSIGN_KWAI_C";
	game["strings_menu"]["war_callsign_d"] = "@PATCH_CALLSIGN_KWAI_D";
	game["strings_menu"]["war_callsign_e"] = "@PATCH_CALLSIGN_KWAI_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");	
	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	

}
