main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	maps\mp\mp_makin_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_makin_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_makin");
	
	//setExpFog(300, 1400, 0.5, 0.5, 0.5, 0);
	//VisionSetNaked( "mp_cargoship" );
	//ambientPlay("ambient_cargoshipmp_ext");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAKIN_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAKIN_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAKIN_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAKIN_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAKIN_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAKIN_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAKIN_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAKIN_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAKIN_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAKIN_E";


	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
