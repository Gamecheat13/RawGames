main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	//maps\mp\mp_shrine_fx::main();
	
	precachemodel("collision_wall_128x128x10");
	precachemodel("collision_geo_128x128x128");
	precachemodel("collision_wall_512x512x10");
	precachemodel("collision_geo_32x32x128");
	
	maps\mp\mp_shrine_fx::main();
	maps\mp\createart\mp_shrine_art::main();	

	maps\mp\_load::main();

	maps\mp\createart\mp_shrine_art::main();

	//maps\mp\mp_shrine_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_shrine");
	
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

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_SHRINE_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_SHRINE_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_SHRINE_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_SHRINE_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_SHRINE_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_SHRINE_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_SHRINE_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_SHRINE_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_SHRINE_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_SHRINE_E";

	
	thread trigger_killer( (-1494.5, -2054, -246.5), 1000, 10 );
	thread trigger_killer( (-3712.5, -2311.5, -323), 2000, 10 );
	
	
	spawncollision("collision_wall_128x128x10","collider",(-760, -1073, 15.5), (0, 350, 0));
	spawncollision("collision_wall_128x128x10","collider",(-2116, 937.5, -135), (0, 30.5, 0));
	spawncollision("collision_geo_128x128x128","collider",(-3808, 845.5, -92), (0, 206, 0));
	spawncollision("collision_geo_128x128x128","collider",(-2163, 707, -301.5), (0, 0, 0));
	spawncollision("collision_geo_128x128x128","collider",(-72, 496, -248), (0, 0, 0));
	spawncollision("collision_geo_128x128x128","collider",(-2451, -72.5, -409.5), (0, 0, 0));
	spawncollision("collision_wall_256x256x10","collider",(-1464, 1329, -17), (0, 130, 0));
	spawncollision("collision_wall_256x256x10","collider",(-1259, 1279, -17), (0, 203, 0));

//fix for getting onto hilltop by sniper nest window
	spawncollision("collision_geo_32x32x128","collider",(-1880.5, 672, -152), (0, 346.8, 0));

	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	createSpawnpoint( "mp_ctf_spawn_allies", (-726, 1430, -259.8), 163.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-980, 1224, -315.8), 225.8 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-743, 1015, -287.8), 219.8 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (409, 994, -134.8), 223.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (702, 646, -383.8), 210 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-368, 524, -301.8), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (71, 396, -304.8), 96.2 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (71, 348, -304.8), 276.2 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-719, 323, -293.8), 177.4 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (289, 40, -323.8), 176 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (620, -139, -343.8), 178.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (408, -291, -300.8), 206.2 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (434.692, -540.709, -130.8), 200.2 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-273.259, -672.68, -297.8), 152.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1298, -453, -334.8), 133 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1424, -528, -309.8), 255 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-375.3, -840.7, -265.8), 152.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1034, -1036, -231.8), 106.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-1051, -1285, -73.8), 151.8 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (-871, -1315, -97.8), 241.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4135, 983.3, -201), 15.5 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3543.1, 839.982, -274.4), 10.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-2975.3, 690.01, -306.9), 285.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3632.06, 614.081, -327.4), 306.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4647.7, 693, -251.9), 23 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4709.05, 570.731, -251.9), 293 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4647.3, -58.7947, -330), 6.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3994.08, -138.063, -264.4), 38.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4340.1, -187.1, -236.4), 38.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4136.32, -216.736, -161), 315.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3579.45, -248.633, -234), 90.5 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4647.31, -374.78, -212), 12.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-4375.32, -714.762, -148), 32.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3749.82, -634.236, -140), 10.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3913.42, -1069.06, -73.8), 384.2 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-2505.4, -726.7, -168.8), 165 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-2477.34, -771.398, -150.8), 255 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-2889.53, -843.904, -152.8), 92.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-2884.4, -1189.02, -52.8), 347.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (-3253.41, -1298.04, -25.8), 1.2 );						
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