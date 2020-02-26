main()
{
	// enable new spawning system

 maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

	
	maps\mp\mp_subway_fx::main();		
	maps\mp\_load::main();
	maps\mp\mp_subway_amb::main();

	precachemodel("collision_geo_128x128x10");
	precachemodel("collision_geo_128x128x128");
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_subway");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "russian";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"PATCH_CALLSIGN_SUBWAY_A";
	game["strings"]["war_callsign_b"] = &"PATCH_CALLSIGN_SUBWAY_B";
	game["strings"]["war_callsign_c"] = &"PATCH_CALLSIGN_SUBWAY_C";
	game["strings"]["war_callsign_d"] = &"PATCH_CALLSIGN_SUBWAY_D";
	game["strings"]["war_callsign_e"] = &"PATCH_CALLSIGN_SUBWAY_E";

	game["strings_menu"]["war_callsign_a"] = "@PATCH_CALLSIGN_SUBWAY_A";
	game["strings_menu"]["war_callsign_b"] = "@PATCH_CALLSIGN_SUBWAY_B";
	game["strings_menu"]["war_callsign_c"] = "@PATCH_CALLSIGN_SUBWAY_C";
	game["strings_menu"]["war_callsign_d"] = "@PATCH_CALLSIGN_SUBWAY_D";
	game["strings_menu"]["war_callsign_e"] = "@PATCH_CALLSIGN_SUBWAY_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	//stuck spot by subway car, issue ID 44449
	spawncollision("collision_wall_64x64x10","collider",(-2637.5, 2962, 746), (0, 294.9, 0));
	
	//Prevent people from leaving the map by jumping on each other
	spawncollision("collision_geo_128x128x128","collider",(-3328, 1280, 928), (0, 14, 0));
	spawncollision("collision_geo_128x128x128","collider",(-3445, 1722, 928), (0, 14, 0));	

	//Block 2 player exploit getting up to trim by s&d bomb site
	spawncollision("collision_wall_256x256x10","collider",(-195, 2307.5, 1026), (0, 9, 0));	

	//prevent players from forcing their way into terrain-based pillar to hide themselves
	spawncollision("collision_geo_32x32x128","collider",(-1962.5, 3907.5, 783.5), (0, 30.8, 0));	

}
