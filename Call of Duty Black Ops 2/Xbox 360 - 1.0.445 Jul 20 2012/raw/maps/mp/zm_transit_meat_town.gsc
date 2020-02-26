#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_game_module_meat_utility;


meat_start()
{
	if(!isDefined(level._spawned_neon))
	{
		level._spawned_neon = Spawn( "script_model", (0, 0, 0));
		level._spawned_neon SetModel( "zm_town_encounters_neon" );
	}
	
	init_town_meat();
	level thread init_minigun_ring();
	level thread init_splitter_ring();
	level thread init_ammo_ring();
	level maps\mp\zombies\_zm_game_module_meat::hide_non_meat_objects();
	level thread maps\mp\zombies\_zm_game_module_meat::setup_meat_world_objects();

	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_MEAT_INDEX);
	maps\mp\zombies\_zm_game_module_meat::meat_player_initial_spawn();
	level thread maps\mp\zombies\_zm_game_module_meat::spawn_meat_zombies();
	level thread maps\mp\zombies\_zm_game_module_meat::monitor_meat_on_team();
	level thread meat_intro();		
	
	flag_wait("start_encounters_match_logic");
	level thread link_traversals();
	level._dont_reconnect_paths = true;
	iprintlnbold("ZOMBIES ARE ATTRACTED TO THE TEAM WITH THE MEAT. STAY ALIVE AS LONG AS YOU CAN BY THROWING THE MEAT TO YOUR OPPONENTS SIDE");
	level thread stuck_meat_monitor();
	
	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (1363, 471, 0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_town_meat" );
		level.spawned_collmap DisconnectPaths();	
	}	
}

meat_intro()
{
	flag_wait("start_encounters_match_logic");
	level thread multi_launch();
	meat = launch_meat();
	org = meat.origin;
	meat delete();
	drop_meat(org,level._meat_start_point);
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_drop", undefined, undefined, true );
	level thread maps\mp\zombies\_zm_game_module_meat::item_meat_reset(level._meat_start_point);//spawn_meat(level._meat_start_point);
}

launch_meat()
{
	level waittill("launch_meat");
	spot = random(getstructarray("transit_town_meat_launch_spot","targetname"));
	meat = spawn("script_model",spot.origin);
	meat setmodel("tag_origin");
	wait_network_frame();	
	PlayFXOnTag( level._effect[ "fw_trail" ], meat, "tag_origin" );
	meat playloopsound( "zmb_souls_loop", .75 );
	
	dest =spot;	

	while(isDefined(dest) && isDefined(dest.target))
	{
		new_dest = getstruct(dest.target,"targetname");	
		dest = new_dest;
		dist = distance(new_dest.origin,meat.origin);
		time = dist/700;							
		meat MoveTo(new_dest.origin, time);
		meat waittill("movedone");
	}
 	meat playsound( "zmb_souls_end");

	playfx(level._effect["fw_burst"],meat.origin);
	wait(randomfloatrange(.2,.5));
	meat playsound( "zmb_souls_end");
	playfx(level._effect["fw_burst"],meat.origin + (randomintrange(50,150),randomintrange(50,150),randomintrange(-20,20)) );
	wait(randomfloatrange(.5,.75));
	meat playsound( "zmb_souls_end");
	playfx(level._effect["fw_burst"],meat.origin + (randomintrange(-150,-50),randomintrange(-150,50),randomintrange(-20,20)) );
	wait(randomfloatrange(.5,.75));
	meat playsound( "zmb_souls_end");
	playfx(level._effect["fw_burst"],meat.origin);
	
	return meat;
}


multi_launch()
{
	spots = getstructarray("transit_town_meat_launch_spot","targetname");
	
	for(x=0;x<3;x++)
	{
		for(i=0;i<spots.size;i++)
		{
			delay = randomfloatrange(.1,.25);
			level thread fake_launch(spots[i],delay);
		}
		wait(randomfloatrange(.25,.75));
		if(x > 1) // launch the real meat now
		{
			level notify("launch_meat");
		}
	}
}

fake_launch(launch_spot,delay)
{
	wait(delay);
	wait(randomfloatrange(.1,4));
	meat = spawn("script_model",launch_spot.origin + (randomintrange(-60,60),randomintrange(-60,60),0));
	meat setmodel("tag_origin");
	wait_network_frame();	
	PlayFXOnTag( level._effect[ "fw_trail_cheap" ], meat, "tag_origin" );
	meat playloopsound( "zmb_souls_loop", .75 );
	
	dest = launch_spot;	

	while(isDefined(dest) && isDefined(dest.target))
	{
		random_offset = (randomintrange(-60,60),randomintrange(-60,60),0);
		new_dest = getstruct(dest.target,"targetname");	
		dest = new_dest;
		dist = distance(new_dest.origin + random_offset,meat.origin);
		time = dist/700;							
		meat MoveTo(new_dest.origin + random_offset, time);
		meat waittill("movedone");
	}
 	meat playsound( "zmb_souls_end");

	playfx(level._effect["fw_pre_burst"],meat.origin);
	meat delete();
}

drop_meat(start_org,drop_spot)
{
	meat = spawn("script_model",drop_spot + (0,0,600));
	meat setmodel("tag_origin");
	dist = distance(meat.origin,drop_spot);
	time = dist/400;	
	meat MoveTo(drop_spot,time);		
	wait_network_frame();
	playfxontag(level._effect["fw_drop"],meat,"tag_origin");			
	meat waittill("movedone");
	playfx(level._effect["fw_impact"],drop_spot);
	meat delete();
}

stuck_meat_monitor()
{
	level endon("meat_end");
	trig = getent("meat_stuck_trig","targetname");
	while(1)
	{
		timer = 0;
		while(isDefined(level.item_meat) && level.item_meat istouching(trig))
		{
			timer++;
			wait(.05);
			if(timer > 60) //meat stuck? 
			{
				iprintlnbold("stuck meat detected");
				level.item_meat fake_physicslaunch(level.item_meat.origin + (randomintrange(5,10),randomintrange(5,10) ,15));
			}
		}
		wait(1);
	}
}

init_town_meat()
{
	//wait(.5); //wait a small bit to make sure everyone is connected and running before kicking off 
	level._meat_location = "town";	
	level._meat_start_point = random(getstructarray("meat_2_spawn_points","targetname")).origin;//(4352, -13824, 224);
	level._meat_team_1_zombie_spawn_points = getstructarray("meat_2_team_1_zombie_spawn_points","targetname");
	level._meat_team_2_zombie_spawn_points = getstructarray("meat_2_team_2_zombie_spawn_points","targetname");
	level._meat_team_1_volume = getent("meat_2_team_1_volume","targetname");
	level._meat_team_2_Volume = getent("meat_2_team_2_volume","targetname");
	flag_clear("zombie_drop_powerups");
	level.custom_intermission  = ::town_meat_intermission;
	level.zombie_vars["zombie_intermission_time"] = 5;
	level._supress_survived_screen = 1;
	level thread maps\mp\zombies\_zm_game_module_meat::item_meat_clear();

}

//connect the traversals
link_traversals()
{
	if(is_true(level._traversals_linked))
	{
		return;
	}
	level._traversals_linked = true;
	traversal_nodes = getnodearray("meat_town_barrier_traversals","targetname");
	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		UnLinkNodes(traversal_nodes[i],end_node);
		wait(.05);
	}
	wait(1);
	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		LinkNodes(traversal_nodes[i],end_node);
	}
}

town_meat_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("town_meat_intermission_cam");
}