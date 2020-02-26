#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

race_start()
{

	if(!isDefined(level._spawned_neon))
	{
		level._spawned_neon = Spawn( "script_model", (0, 0, 0));
		level._spawned_neon SetModel( "zm_town_encounters_neon" );
	}
	
	if(!is_true(level._nodes_unlinked))
	{	
		nodes = getnodearray("classic_only_traversal","targetname");
		foreach(node in nodes)
		{
			unlinknodes(node,getnode(node.target,"targetname"));	
		}
				
		nodes = getnodearray("race_disconnect_node","targetname");
		foreach(node in nodes)
		{
			unlinknodes(node,getnode(node.target,"targetname"));		
		}
		level._nodes_unlinked = true;
	}
	init_town_race();

	maps\mp\zombies\_zm_game_module_race::hide_non_race_objects();
	maps\mp\zombies\_zm_game_module::kill_all_zombies();
	
	flag_wait("start_encounters_match_logic");
		
	level thread grief_init_targets();
	
	level thread open_all_doors_when_in_last_area();
	
	iprintlnbold("RACE TO THE FINISH BEFORE YOUR OPPONENTS");

	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,1,"team_1_room_1_clear",undefined,1,5,undefined,"race_town_team_1_door_1");
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,2,"team_2_room_1_clear",undefined,1,5,undefined,"race_town_team_2_door_1");	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(2,1,"team_1_room_2_clear","race_town_area_2_team_1_ready",2,7,undefined,"race_town_team_1_door_2","team_1_room_1_clear","race_town_area_1_team_1_clear_ai");
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(2,2,"team_2_room_2_clear","race_town_area_2_team_2_ready",2,7,undefined,"race_town_team_2_door_2","team_2_room_1_clear","race_town_area_1_team_2_clear_ai");	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(3,1,"team_1_room_3_clear","race_town_area_3_team_1_ready",3,8,undefined,"race_town_team_1_door_3","team_1_room_2_clear","race_town_area_2_team_1_ready");
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(3,2,"team_2_room_3_clear","race_town_area_3_team_2_ready",3,8,undefined,"race_town_team_2_door_3","team_2_room_2_clear","race_town_area_2_team_2_ready");	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(4,1,"team_1_room_4_clear","race_town_area_4_team_1_ready",4,9,undefined,"race_town_team_1_door_4","team_1_room_3_clear","race_town_area_3_team_1_ready",true);
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(4,2,"team_2_room_4_clear","race_town_area_4_team_2_ready",4,9,undefined,"race_town_team_2_door_4","team_2_room_3_clear","race_town_area_3_team_2_ready",true);	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(5,1,"race_won","race_town_area_5_team_1_ready",3,3,.25,undefined,"team_1_room_4_clear",undefined,undefined,true);
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(5,2,"race_won","race_town_area_5_team_2_ready",3,3,.25,undefined,"team_2_room_4_clear",undefined,undefined,true);
	
}

open_all_doors_when_in_last_area()
{
	level endon("end_race");
	
	level waittill_either("team_1_room_4_clear","team_2_room_4_clear");
	wait_network_frame();	
	level._all_doors_open = true;
	level notify("team_1_room_1_clear");
	level notify("team_2_room_1_clear");
	update_team_door_hud(1);
	update_team_door_hud(2);	
	level._race_team_1_progress++;
	level._race_team_2_progress++;	
	wait_network_frame();	
	level notify("team_1_room_2_clear");
	level notify("team_2_room_2_clear"); 
	update_team_door_hud(1);
	update_team_door_hud(2);
	level._race_team_1_progress++;
	level._race_team_2_progress++;		
	wait_network_frame();
	level notify("team_1_room_3_clear");
	level notify("team_2_room_3_clear");	 
	update_team_door_hud(1);
	update_team_door_hud(2);
	level._race_team_1_progress++;
	level._race_team_2_progress++;
	wait_network_frame();
	level notify("team_1_room_4_clear");
	level notify("team_2_room_4_clear");
	update_team_door_hud(1);
	update_team_door_hud(2);	
	level._race_team_1_progress++;
	level._race_team_2_progress++;
	level clientnotify("1_5");
	level clientnotify("2_5");	
}

init_town_race()
{

	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_RACE_INDEX);	
	level._race_door_prefix = "race_town_";
	level._race_location = "town";
	flag_clear("zombie_drop_powerups");
	level._all_doors_open = false;
	level thread cleanup_nonrace_objects();
	setup_race_player_areas();
	level._chests_deleted = false;
	level.custom_intermission  = ::town_race_intermission;
	level.do_final_fireworks = true;
	//level thread open_all_doors();

	//Need to spawn the race collision map
	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (1363, 471, 0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_town_race" );
		level.spawned_collmap DisconnectPaths();
	}
}


race_end()
{
	
	level._race_finish_trig = getent("town_race_finish","targetname");	
	winning_team = maps\mp\zombies\_zm_race_utility::wait_for_all_players_finished(level._race_finish_trig);
	level notify("end_race",winning_team);

}

setup_race_player_areas()
{
	
	level._race_team_1_spawn_points = getstructarray("race_transit_town_team1_spawn","targetname");
	level._race_team_2_spawn_points = getstructarray("race_transit_town_team2_spawn","targetname");
	
	//team 1
	init_race_player_area("race_town_area_1_team_1_clear_ai",1,"race_town_area_1_team_1_zombie_spawn",1);
	init_race_player_area("race_town_area_2_team_1_ready",2,"race_town_area_2_team_1_zombie_spawn",1);
	init_race_player_area("race_town_area_3_team_1_ready",3,"race_town_area_3_team_1_zombie_spawn",1);
	init_race_player_area("race_town_area_4_team_1_ready",4,"race_town_area_4_team_1_zombie_spawn",1);
	init_race_player_area("race_town_area_5_team_1_ready",5,"race_town_area_5_team_1_zombie_spawn",1);
			
	//team 2
	init_race_player_area("race_town_area_1_team_2_clear_ai",1,"race_town_area_1_team_2_zombie_spawn",2);
	init_race_player_area("race_town_area_2_team_2_ready",2,"race_town_area_2_team_2_zombie_spawn",2);
	init_race_player_area("race_town_area_3_team_2_ready",3,"race_town_area_3_team_2_zombie_spawn",2);
	init_race_player_area("race_town_area_4_team_2_ready",4,"race_town_area_4_team_2_zombie_spawn",2);
	init_race_player_area("race_town_area_5_team_2_ready",5,"race_town_area_5_team_2_zombie_spawn",2);	
}

cleanup_nonrace_objects()
{	
	// clean up the objects used for Meat mode
	ents = getentarray("meat_town_barriers","targetname");
	for(i=0;i<ents.size;i++)
	{
		if(isDefined(ents[i].spawnflags) && ents[i].spawnflags == 1)
		{
			ents[i] connectpaths();
		}
		ents[i] notsolid();
		ents[i] hide();
	}		
	ents = getentarray("meat_barriers","targetname");
	for(i=0;i<ents.size;i++)
	{
		if(isDefined(ents[i].spawnflags) && ents[i].spawnflags == 1)
		{
			ents[i] hide();
			ents[i] notsolid();
		}
	}
	level thread delete_bus_pieces();	
}

town_race_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("town_race_intermission_cam");
}

delete_bus_pieces()
{
	wait(1); //give the bus a chance to spawn in before deleting it
	if(is_true(level._bus_pieces_deleted))
	{
		return;
	}
	level._bus_pieces_deleted = true;
	
	//mantle brush
	hatch_mantle = getent("hatch_mantle","targetname");
	if(isDefined(hatch_mantle))
	{
		hatch_mantle delete();
	}
	
	//roof hatch 
	bus_roof = getent("bus_roof","targetname");
	if(isDefined(bus_roof))
	{
		bus_roof delete();
	}
	
	//hatch clip
	hatch_clip = getentarray("hatch_clip","targetname");
	foreach(clip in hatch_clip)
	{
		if(isDefined(clip))
		{
			clip delete();
		}
	}
	
	//lights
	light = getent("busLight2","targetname");
	if(isDefined(light))
	{
		light delete();
	}
	light = getent("busLight1","targetname");
	if(isDefined(light))
	{
		light delete();
	}
	
	//path blocker
	blocker = getent("bus_path_blocker","targetname");
	if(isDefined(blocker))
	{
		blocker delete();
	}
	
	//brake lights
	lights = getentarray("bus_break_lights","targetname");
	foreach(light in lights)
	{
		if(isDefined(light))
		{
			light delete();
		}
	}
	
	//delete the bus "bounds" origins
	orgs = getentarray("bus_bounds_origin","targetname");
	foreach(org in orgs)
	{
		if(isDefined(org))
		{
			org delete();
		}
	}
	
	//bus door blockers
	door_blocker = getentarray("bus_door_blocker","targetname");
	foreach(blocker in door_blocker)
	{
		if(isDefined(blocker))
		{
			blocker delete();
		}
	}
	
	//bus driver	
	driver = getent("bus_driver_head","targetname");
	if(isDefined(driver))
	{
		driver delete();
	}
	driver_body = getentarray("bus_driver_body","targetname");
	foreach(body in driver_body)
	{
		if(isDefined(body))
		{
			body delete();
		}
	}
	
	//delete the 'plow' trigger
	plow = getent("trigger_plow","targetname");
	if(isDefined(plow))
	{
		plow delete();
	}
	plow_attach_point = getent("plow_attach_point","targetname");
	if(isDefined(plow_attach_point))
	{
		plow_attach_point delete();
	}

	//delete "the bus" 
	bus = getent("the_bus","targetname");
	if(isDefined(bus))
	{
		bus delete();
	}	
	delete_lava_triggers();
	
}

delete_lava_triggers()
{
	lava = GetEntArray("lava_damage", "targetname");
	foreach(spot in lava)
	{
		if(isDefined(spot))
		{
			spot delete();
		}
	}
}

