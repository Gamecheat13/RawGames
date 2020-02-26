main()
{	
	maps\mp\mp_downfall_fx::main();

	precachemodel("collision_geo_128x128x128");
	precachemodel("collision_geo_64x64x64");
	precachemodel("collision_wall_256x256x10");
	precachemodel("collision_wall_64x64x10");
	precachemodel("collision_geo_64x64x256");
	
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
	
	spawncollision("collision_geo_128x128x128","collider",(2964, 9470, -113), (0, 348.6, 0));



//stuck spot at boxes by truck
	spawncollision("collision_geo_64x64x64","collider",(-1214, 8213, -50.5), (0, 348.6, 0));

//block access to roof issue ID 44204
	spawncollision("collision_wall_256x256x10","collider",(-758, 7611, 122), (0, 0, 0));

//sandbags issue ID 44251 may wnf sandbag issue
	spawncollision("collision_wall_64x64x10","collider",(360, 6642, 52), (0, 333.2, 0));

//sandbags may wnf
	spawncollision("collision_wall_64x64x10","collider",(909, 6672, 44), (0, 0, 0));
	spawncollision("collision_wall_64x64x10","collider",(798, 6676, 42), (0, 0, 0));

//prone into wall issue ID 44233 may wnf if it causes any issues
	spawncollision("collision_wall_256x256x10","collider",(4629.5, 8539.5, -112.5), (0, 257, 0));
	spawncollision("collision_wall_256x256x10","collider",(4555.5, 8295.5, -112.5), (0, 249.3, 0));

//hiding in rubble pile issue ID 44547
	spawncollision("collision_geo_128x128x128","collider",(3821, 10522, -133), (0, 0, 0));

//stuck spots in tree planters
	spawncollision("collision_geo_64x64x256","collider",(2786, 8295, 104), (0, 0, 0));
	spawncollision("collision_geo_64x64x256","collider",(2744, 9148, 104), (0, 0, 0));
	
	
	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
