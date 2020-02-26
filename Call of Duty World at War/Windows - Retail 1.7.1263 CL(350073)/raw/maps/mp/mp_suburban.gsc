main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	//maps\mp\mp_suburban_fx::main();
	
	precachemodel("collision_wall_128x128x10");
	precachemodel("collision_geo_32x32x128");	
	precachemodel("collision_wall_256x256x10");	
	precachemodel("collision_geo_256x256x256");	
	
	maps\mp\mp_suburban_fx::main();	
	
	maps\mp\createart\mp_suburban_art::main();	

	maps\mp\_load::main();

	maps\mp\mp_suburban_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_suburban");

	
	//setExpFog(600, 3500, 0.3, 0.3, 0.25, 0);
	//VisionSetNaked( "mp_cargoship" );
	//ambientPlay("ambient_cargoshipmp_ext");

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_SUBURBAN_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_SUBURBAN_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_SUBURBAN_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_SUBURBAN_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_SUBURBAN_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_SUBURBAN_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_SUBURBAN_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_SUBURBAN_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_SUBURBAN_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_SUBURBAN_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	spawncollision("collision_wall_128x128x10","collider",(-43.5, -2952, -272), (0, 90, 0));
	
	//stuck spot on the north side of the creek house
	spawncollision("collision_wall_128x128x10","collider",(2043, -3014.5, -427), (0, 270, 0));

	//jump from window to burned out roof of burning house
	spawncollision("collision_geo_256x256x256","collider",(1383, -3593, -292), (0, 0, 0));
	spawncollision("collision_geo_256x256x256","collider",(1639, -3633, -136), (0, 0, 0));

  //keep people off the broken wall in the middle of the map
	spawncollision("collision_geo_32x32x128","collider",(636, -2788.5, -277), (0, 0, 0));
	spawncollision("collision_wall_256x256x10","collider",(748, -2813.5, -208), (0, 0, 0));
	spawncollision("collision_wall_256x256x10","collider",(748, -2823.5, -208), (0, 0, 0));



	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
