main()
{

	maps\mp\mp_roundhouse_fx::main();	
	maps\mp\createart\mp_roundhouse_art::main();

	precachemodel("collision_geo_ramp");
	precachemodel("collision_geo_32x32x128");
	precachemodel("collision_wall_512x512x10");
	precachemodel("collision_wall_256x256x10");
	precachemodel("collision_geo_64x64x64");
	precachemodel("collision_geo_256x256x256");
	
	maps\mp\_load::main();
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	
	
	maps\mp\mp_roundhouse_amb::main();

	// uncomment this when you have your own mini-map for this map
	maps\mp\_compass::setupMiniMap("compass_map_mp_roundhouse");

	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_ROUNDHOUSE_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_ROUNDHOUSE_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_ROUNDHOUSE_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_ROUNDHOUSE_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_ROUNDHOUSE_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_ROUNDHOUSE_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_ROUNDHOUSE_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_ROUNDHOUSE_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_ROUNDHOUSE_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_ROUNDHOUSE_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	thread trigger_killer( (1646,-3590, -518), 500, 10 );  // large and thin

	spawncollision("collision_geo_256x256x256.map","collider",(1124, -1735, -375), (0,0,0)); 

	
	//the one, the only, the original map hole
	spawncollision("collision_geo_ramp","collider",(1616, -3592, -416), (0,0,0));
	//lamp jump
	spawncollision("collision_geo_32x32x128","collider",(-463, -874, -277), (0,0,0));
		
	//wall climbing out of map
	spawncollision("collision_wall_512x512x10","collider",(-63, 1080, -218), (0,32.3,0)); 
	spawncollision("collision_wall_256x256x10","collider",(-386, 876, -346), (0,32.3,0)); 

	//Stuck Spot in boxes
	spawncollision("collision_geo_64x64x64","collider",(-798, -932, -432), (0,0,0)); 

	//stuck spot at ovens
	spawncollision("collision_wall_128x128x10","collider",(-895.5, -1825, -300), (0,270,0)); 

	//Garage Door
	spawncollision("collision_wall_512x512x10","collider",(-583, 727, -218), (0,40.1,0)); 
	
	//Jumping Puzzle
	spawncollision("collision_wall_512x512x10","collider",(2701, -2239, 8), (0,44.9,0)); 

	//prevent players from getting under the train car with the crane on it
	spawncollision("collision_geo_256x256x256","collider",(3179, -1017, -555), (0,0,0)); 
	spawncollision("collision_geo_256x256x256","collider",(3049, -1017, -555), (0,0,0)); 
	
	//stuck spot at (1333 338 -402) issue ID 41401
	spawncollision("collision_geo_32x32x128","collider",(1349, 323, -407), (0,0,0)); 
	
	//exploit at (1411 -3818 -347) issue ID 42441 jumping from traincar to broken beam
	spawncollision("collision_wall_256x256x10","collider",(1352, -3873, -304), (0,358.2,0)); 

	//exploit at (2951 -2783 -111) issue ID 44271 2 player access inside geo
	spawncollision("collision_wall_512x512x10","collider",(2999, -2864, 74), (0,315,0)); 

	//exploit at (3477 -1968 228) issue ID 44302 getting into "secret" room
	spawncollision("collision_wall_256x256x10","collider",(3222, -2342, -123), (0,42,0)); 

	return;
}

trigger_killer( position, width, height )
{
	kill_trig = spawn("trigger_radius", position, 0, width, height);

	while(1)
	{
		kill_trig waittill("trigger",player);
		if ( isplayer( player ) )
		{
			player suicide();
		}
	}
}

