#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;


race_start()
{
	init_power_race();
	
	maps\mp\zombies\_zm_game_module_race::hide_non_race_objects();
	
	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (10169, 7610, 0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_power_race" );
		level.spawned_collmap DisconnectPaths();

		//neon = Spawn( "script_model", (-9872, 1344, 0));
		//neon SetModel( "zm_tunnel_encounters_neon" );		
	}
	
	maps\mp\zombies\_zm_game_module::kill_all_zombies();

	flag_wait("start_encounters_match_logic");
	iprintlnbold("RACE TO THE FINISH BEFORE YOUR OPPONENTS");
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,1,"end_race",undefined,2,2,.4,undefined,undefined,undefined,false,false);
	level thread init_power_race_players();
	
	level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill" , getstruct("race_power_instakill_drop","targetname").origin);
	
	level thread monitor_players_entering_outhouse(); // mark the players as having entered the outhouse so they can't just run and touch the 'finish' trigger and bypass the race

}

init_power_race()
{
	level._verify_player_finished = ::check_player_went_through_outhouse;
	level._override_race_death_callback = ::tunnel_race_death_callback_void;
	level._combine_team_zombies = true;	
	level.custom_intermission  = ::power_race_intermission;
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_RACE_INDEX);	
	level._race_door_prefix = "race_power_";
	level._race_location = "power";
	flag_clear("zombie_drop_powerups");
	setup_race_player_areas();
	level._game_module_point_adjustment = undefined;
	level._all_zombies_supersprinters = true;
	level._powerup_timeout_override = ::power_powerup_timeout_override_void;
	level.calc_closest_player_using_paths = false;
}

power_powerup_timeout_override_void()
{
	
}

init_power_race_players()
{
	players = GET_PLAYERS();
	foreach(player in players)
	{
		player thread kill_zombies_targeting_player(); //kills only zombies that are targeting the player who goes into last stand
		player._entered_outhouse = false;		
		lethal_grenade = player get_player_lethal_grenade(); //give 4 grenades 
		player GiveWeapon( lethal_grenade );	
		player SetWeaponAmmoClip( lethal_grenade, 4 );
	}
}

race_end()
{
	level._race_finish_trig = getent("transit_race_power_finish","targetname");	
	winning_team = maps\mp\zombies\_zm_race_utility::wait_for_all_players_finished(level._race_finish_trig);
	level notify("end_race",winning_team);
}

setup_race_player_areas()
{
	
	level._race_team_1_spawn_points = getstructarray("race_transit_power_team1_spawn","targetname");
	level._race_team_2_spawn_points = getstructarray("race_transit_power_team2_spawn","targetname");
	
	init_race_player_area("transit_race_power_area",1,"race_power_area_zombie_spawn",1);
	init_race_player_area("transit_race_power_area",1,"race_power_area_zombie_spawn",2);
	
}

tunnel_race_death_callback_void(zombie) //needed because zombies aren't split up into teams 
{

}

tunnel_race_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("tunnel_race_intermission_cam");
}

monitor_players_entering_outhouse()
{
	level endon("end_race");
	
	trig = getent("race_power_outhouse_trigger","targetname");
	while(1)
	{
		trig waittill("trigger",who);
		who._entered_outhouse = true;
	}
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

power_race_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("power_race_intermission_cam");
}

delete_bus_pieces()
{
	wait(2); //give the bus a chance to spawn in before deleting it
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

kill_zombies_targeting_player()
{
	self endon("disconnect");
	level endon("end_race");
	while(1)
	{
		self waittill("player_downed");
		zombies = getaiarray();
		foreach(zombie in zombies)
		{
			if(isDefined(zombie) && isDefined(zombie.favoriteenemy) && zombie.favoriteenemy == self)
			{
				playfx(level._effect["spawn_cloud"],zombie.origin);
				zombie delete();
			}
		}		
	}
}

check_player_went_through_outhouse()
{
	if(is_true(self._entered_outhouse))
	{
		return true;
	}
	return false;
}