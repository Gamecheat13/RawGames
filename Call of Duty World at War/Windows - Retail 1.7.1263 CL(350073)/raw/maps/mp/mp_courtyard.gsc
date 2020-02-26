main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	//maps\mp\mp_courtyard_fx::main();
	
	
	maps\mp\mp_courtyard_fx::main();
  maps\mp\createart\mp_courtyard_art::main();
	

	maps\mp\_load::main();
	
  
	//maps\mp\mp_courtyard_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_courtyard");
	
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

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_COURTYARD_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_COURTYARD_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_COURTYARD_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_COURTYARD_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_COURTYARD_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_COURTYARD_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_COURTYARD_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_COURTYARD_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_COURTYARD_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_COURTYARD_E";

	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

	createSpawnpoint( "mp_ctf_spawn_allies", (3508, 1158, 70), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (4030, 733, 80), 14.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3831, 646, 124), 334.4 );
	createSpawnpoint( "mp_ctf_spawn_allies", (3753, 400, 80), 344.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3312, 375, 124), 323.4 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3284, 37, 124), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3911, -1586, 96), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3667, -1692, 101), 90 );
	createSpawnpoint( "mp_ctf_spawn_allies", (3667, -1790, 109), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (4177, -1972, 109), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (5004, 1213, 133), 210.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (5564, 624, 86), 210.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (6273, 594, 179), 200 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (5923, -1295, 86), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (6255, -1432, 180), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (5449, -1450, 86), 180 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (5319, -1619, 97), 208.4 );
					
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
