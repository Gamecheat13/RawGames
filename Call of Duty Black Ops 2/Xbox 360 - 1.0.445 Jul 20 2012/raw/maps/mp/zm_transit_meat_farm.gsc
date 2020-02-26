#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_game_module_meat_utility;

meat_start()
{
	if(!isDefined(level._spawned_neon))
	{
		level._spawned_neon = Spawn( "script_model", (8000,-5800,0));
		level._spawned_neon SetModel( "zm_farm_encounters_neon" );	
	}
	
	farm_meat_init();
//	level thread init_minigun_ring();
//	level thread init_splitter_ring();
	level thread init_ammo_ring();

	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (8000,-5800,0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_farm_meat" );
		level.spawned_collmap DisconnectPaths();			
	}	

	level maps\mp\zombies\_zm_game_module_meat::hide_non_meat_objects();
	level thread maps\mp\zombies\_zm_game_module_meat::setup_meat_world_objects();

	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_MEAT_INDEX);
		
	maps\mp\zombies\_zm_game_module_meat::meat_player_initial_spawn();
	level thread maps\mp\zombies\_zm_game_module_meat::item_meat_reset(level._meat_start_point);
	level thread maps\mp\zombies\_zm_game_module_meat::spawn_meat_zombies();
	level thread maps\mp\zombies\_zm_game_module_meat::monitor_meat_on_team();	
	
	wait(1); 
	level thread link_traversals();
	level._dont_reconnect_paths = true;
	iprintlnbold("ZOMBIES ARE ATTRACTED TO THE TEAM WITH THE MEAT. STAY ALIVE AS LONG AS YOU CAN BY THROWING THE MEAT TO YOUR OPPONENTS SIDE");
	
}

farm_meat_init()
{
	level._meat_location = "farm";	
	level._meat_start_point = getstruct("meat_farm_spawn_point","targetname").origin;
	level._meat_team_1_zombie_spawn_points = getstructarray("meat_farm_team_1_zombie_spawn_points","targetname");
	level._meat_team_2_zombie_spawn_points = getstructarray("meat_farm_team_2_zombie_spawn_points","targetname");
	level._meat_team_1_volume = getent("meat_farm_team_1_volume","targetname");
	level._meat_team_2_Volume = getent("meat_farm_team_2_volume","targetname");
	flag_clear("zombie_drop_powerups");
	level.custom_intermission  = ::farm_meat_intermission;
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
	traversal_nodes = getnodearray("meat_farm_barrier_traversals","targetname");
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

farm_meat_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("farm_meat_intermission_cam");
}