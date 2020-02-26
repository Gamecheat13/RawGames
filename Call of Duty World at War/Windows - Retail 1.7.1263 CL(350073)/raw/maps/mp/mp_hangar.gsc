main()
{
	maps\mp\mp_hangar_fx::main();		
	
	precachemodel("collision_wall_512x512x10");
	precachemodel("collision_wall_128x128x10");
	precachemodel("collision_wall_32x32x10");
	precachemodel("collision_geo_64x64x128");
	
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

	// Spawned Collision
	spawncollision("collision_wall_512x512x10","collider",(-949.5, 22, 1045.25), (0, 270, 0));
	spawncollision("collision_wall_128x128x10","collider",(-41, -136, 908), (0, 270, 0));
	spawncollision("collision_wall_512x512x10","collider",(-384, -2451, 1136), (0, 0, 0));
	//keep people from leaving the map by using a partner
	spawncollision("collision_wall_512x512x10","collider",(-1613, -842, 852), (0, 270, 0));
	//prevent players from going under the stairs in the admin bldg
	spawncollision("collision_wall_32x32x10","collider",(-366, -2026, 652), (0, 270, 0));
	//keep people from accessing the lamp which can be used to access the roof
	spawncollision("collision_geo_32x32x128","collider",(-320, -2480, 892), (0, 0, 0));

		//prevent 2 player access to roof of mess hall
	spawncollision("collision_geo_64x64x128","collider",(64, -80, 848), (0, 0, 0));
	
	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	createSpawnpoint( "mp_ctf_spawn_allies", (842, 1096, 676), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (456, 771, 676), 301 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (174, 1000, 676), 0 );
	createSpawnpoint( "mp_ctf_spawn_allies", (158, 846, 676), 270 );
	createSpawnpoint( "mp_ctf_spawn_allies", (226, 776, 820), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1146, 504, 696), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-690, 398, 666), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-994, 174, 666), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1064, 148, 696), 237.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-4, -105, 680), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1090, -262, 674), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-488, -412, 786), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-646, -460, 660), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-244, -466, 642), 293.8 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-112, -576, 786), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-436, -780, 666), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (12, -804, 666), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-776, -994, 662), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1253, -1078, 682), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-980, -1443, 744), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1244, -1585, 744), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1735, -373, 676), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1802, -550.5, 677), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (756, -881, 676), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1757, -998, 676), 151.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1208, -1429, 676), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1052, -1775, 676), 193 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-299, -1781, 676), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (473, -2102, 676), 157.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-303, -2348, 646), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (290, -2503, 668), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-403, -2593, 707), 168.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (55, -2924, 668), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (381, -2918, 668), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (673, -3066, 668), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (848, -2907, 668), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1121, -2562, 756), 153.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1179, -2704, 756), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1417, -2515, 756), 90 );
					
}

createSpawnpoint( classname, origin, yaw )
{
	spawnpoint = spawn( "script_origin", origin );
	spawnpoint.angles = (0,yaw,0);
	
	if ( !isdefined( level.extraSpawnpoints ) )
		level.extraSpawnpoints = [];
	if ( !isdefined( level.extraSpawnpoints[classname] ) )
		level.extraSpawnpoints[classname] = [];
	level.extraSpawnpoints[classname][ level.extraSpawnpoints[classname].size ] = spawnpoint;
}
