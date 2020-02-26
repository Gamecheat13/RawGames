main()
{
	maps\mp\mp_airfield_fx::main();
	maps\mp\createart\mp_airfield_art::main();	

	maps\mp\_load::main();
	
	//maps\mp\mp_airfield_amb::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_airfield");

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

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_AIRFIELD_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_AIRFIELD_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_AIRFIELD_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_AIRFIELD_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_AIRFIELD_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_AIRFIELD_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_AIRFIELD_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_AIRFIELD_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_AIRFIELD_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_AIRFIELD_E";

	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	createSpawnpoint( "mp_ctf_spawn_allies", (2803, 2929, 42), 4 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (2736, 2869, 42), 270.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (4553, 2384, -34), 135 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (2649.5, 1903, 136), 227.1 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3309.5, 1355.5, -21.5), 46.2 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (2364, 1611, 134), 47.1 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (2330, 1018, 33), 168.6 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (1840, 1518, 63), 212 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (1762, 942, 7), 150 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (1540, 694, -5), 152.7 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (1158, 655, 5), 99.3 ); 
	createSpawnpoint( "mp_ctf_spawn_allies", (3790, 2227.5, 10), 60 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1290, 5880, 188), 342.8 );
	createSpawnpoint( "mp_ctf_spawn_axis", (1680, 5834, 37), 291.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (949, 5739, 37), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1322, 5428, 181), 240 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1616, 5376.5, 16), 290 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (2284, 5424, 28), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (2934, 5259, 50), 318.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1412, 4865, 42), 281.8 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (2040, 4468, -78), 90 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (380, 4535, 34), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (785, 4515, 16), 270 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1947, 4178, 1), 0 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1402, 4106, 26), 335.6 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1304, 3666, 13), 313.4 ); 
	createSpawnpoint( "mp_ctf_spawn_axis", (1771, 3295, 25), 231.2 );
					
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