main()
{
	//maps\mp\mp_cargoship_fx::main();
	//maps\createart\mp_cargoship_art::main();
	//needs to be first for create fx
	maps\mp\mp_castle_fx::main();

	precachemodel("collision_geo_256x256x10");
	precachemodel("collision_wall_256x256x10");
	precachemodel("collision_geo_32x32x128");
	precachemodel("collision_geo_32x32x32");
	maps\mp\_load::main();

	maps\mp\mp_castle_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_castle");
	
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

	thread trigger_killer( (2166,-604, -556), 125, 10 );

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_CASTLE_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_CASTLE_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_CASTLE_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_CASTLE_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_CASTLE_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_CASTLE_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_CASTLE_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_CASTLE_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_CASTLE_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_CASTLE_E";

	// Spawned Collision
	
	//prevents players from getting on top of the stone building south of rock garden
		spawncollision("collision_geo_256x256x10","collider",(145, -2080, 49), (270, 90, 0));
	//fix for map hole west of pond, next to storage building
		spawncollision("collision_wall_256x256x10","collider",(2169, -568, -456), (0, 270, 0));
	//fix for map hole in east pond wall
		spawncollision("collision_wall_256x256x10","collider",(2409, -1333, -473), (0, 0, 0));
	//fix for map hole in north pond wall
		spawncollision("collision_wall_256x256x10","collider",(2230, -1232, -522), (0, 270, 0));
  //fix for rooftop access through dojo window using two players
  	spawncollision("collision_wall_256x256x10","collider",(3320, -2459, 59), (0, 0, 0));
  //prevents players from hiding in tree by red bridge
  	spawncollision("collision_geo_32x32x128","collider",(2471, -835, -329), (0, 0, 0));
  //stuck spot between red trims on a the southernmost wall, accessible by jumping on barrels
  	spawncollision("collision_geo_32x32x32","collider",(542.5, -1939.5, -96), (0, 0, 0));
  //fix for sticky spot by barrel at south end of rock garden
  	spawncollision("collision_geo_32x32x32","collider",(363, -2547.5, -202.5), (0, 0, 0));

  //fix map hole at terrain wall northwest side of map issue ID 44365
  	spawncollision("collision_wall_256x256x10","collider",(4397, -1207, -285), (0, 278.5, 0));
  	spawncollision("collision_wall_256x256x10","collider",(4407, -958, -285), (0, 256.9, 0));
  	spawncollision("collision_wall_256x256x10","collider",(4469.5, -711, -285), (0, 254.7, 0));
  	
  	
  //fix exploit onto small roof issue ID 42221
  	spawncollision("collision_geo_256x256x256","collider",(3325.5, -161, -266.5), (0, 0, 0));





	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);


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