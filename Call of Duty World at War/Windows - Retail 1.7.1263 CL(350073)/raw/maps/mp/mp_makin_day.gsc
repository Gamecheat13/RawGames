main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	maps\mp\mp_makin_day_fx::main();

	precachemodel("collision_wall_256x256x10");
	precachemodel("collision_geo_128x128x128");
	precachemodel("collision_geo_64x64x256");

	maps\mp\_load::main();

	maps\mp\mp_makin_day_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_makin_day");
	
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

	// round hut
	thread trigger_killer( (-9824, -16816, 328), 475, 227 );  // large and thin

	// tree blocker
	spawncollision("collision_geo_64x64x256","collider",(-7608.5, -16543, 371), (0, 135, 0));
	// hut blocker
	spawncollision("collision_geo_128x128x128","collider",(-10085, -14817, 129), (0, 120, 0));
	// round hut fence blockers
	spawncollision("collision_wall_256x256x10","collider",(-10072, -16352, 185), (0, 0, 0));
	spawncollision("collision_wall_256x256x10","collider",(-9617, -17242, 407), (0, 25, 0));

	createSpawnpoint( "mp_ctf_spawn_allies", (-8330, -17715, 170.5), 51.2 );
	createSpawnpoint( "mp_ctf_spawn_allies", (-9531.5, -17443.5, 99), 29 );
	createSpawnpoint( "mp_ctf_spawn_allies", (-9856, -17313.5, 85.5), 175.6 );
	createSpawnpoint( "mp_ctf_spawn_allies", (-10628.5, -17469.5, 19), 21 );
	createSpawnpoint( "mp_ctf_spawn_allies", (-10747.7, -18077.8, 116), 91.8 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-10404, -18163, 9), 45.4 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-9997, -18329, 110), 20.1 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-9977, -18506, 79), 18.1 );
	createSpawnpoint( "mp_ctf_spawn_allies", (-9214.7, -18796.2, 113.7), 108 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-10721.2, -18509.8, -30.5), 107.5 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-10468, -18794, 110), 107.6 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-9671, -18904, 93.5), 150.7 );	
	createSpawnpoint( "mp_ctf_spawn_allies", (-10663, -18993, 37.5), 356 );		
	createSpawnpoint( "mp_ctf_spawn_allies", (-10695, -19459.5, 71.5), 62.9 );		
	createSpawnpoint( "mp_ctf_spawn_allies", (-10648, -19867, 74.5), 99.4 );		
	createSpawnpoint( "mp_ctf_spawn_allies", (-9964, -19974, 117.5), 102 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-9593.1, -15799.5, 124.8), 353.8 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-9725.5, -14858.1, 123.2), 205 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-10169, -14368, 118), 283 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-10294.9, -14998.5, 89.7), 300 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-10708, -14189, 131.5), 0 );			
	createSpawnpoint( "mp_ctf_spawn_axis", (-10778, -15942, 110), 75.4 );			
	createSpawnpoint( "mp_ctf_spawn_axis", (-10820, -15331, 110), 26.2 );			
	createSpawnpoint( "mp_ctf_spawn_axis", (-10872, -15219, 59.5), 33.8 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-10907, -14504, 121), 270 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-11269, -14180, 68), 270 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-11595, -14108, 54.5), 306.6 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-11462, -14617, 46), 30 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-11308, -15132, 22.5), 22.6 );	
	createSpawnpoint( "mp_ctf_spawn_axis", (-11312, -15563, 20.5), 303.8 );		
	createSpawnpoint( "mp_ctf_spawn_axis", (-11392, -15720, 106), 341.4 );						
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

