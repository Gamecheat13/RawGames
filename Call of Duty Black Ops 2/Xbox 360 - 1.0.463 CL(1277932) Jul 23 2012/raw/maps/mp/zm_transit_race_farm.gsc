#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

race_start()
{
	if(!isDefined(level._spawned_neon))
	{
		level._spawned_neon = Spawn( "script_model", (8000,-5800,0));
		level._spawned_neon SetModel( "zm_farm_encounters_neon" );	
	}
	init_farm_race();

	maps\mp\zombies\_zm_game_module_race::hide_non_race_objects();
	maps\mp\zombies\_zm_game_module::kill_all_zombies();
	level.custom_intermission  = ::farm_race_intermission;
	flag_wait("start_encounters_match_logic");
	if ( IsDefined( level._team_loadout ) )
	{
		players = GET_PLAYERS();
		foreach(player in players)
		{
			player GiveWeapon( level._team_loadout );
			player SwitchToWeapon( level._team_loadout );
		}
	}
	
	level thread grief_init_targets();
	
	iprintlnbold("RACE TO THE FINISH BEFORE YOUR OPPONENTS");
	
	//race_zombie_spawn_logic(room_num,team,end_on,new_area_trig,zombie_start_round,zombie_end_round,spawn_timer,next_area_door_trig,start_on,ai_clear_vol,last_room,flood_zombies,zombie_speed)

	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,1,"team_1_room_1_clear",undefined,1,5,undefined,"race_farm_team_1_door_1");
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(1,2,"team_2_room_1_clear",undefined,1,5,undefined,"race_farm_team_2_door_1");	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(2,1,"team_1_room_2_clear","race_farm_area_2_team_1_ready",2,7,undefined,"race_farm_team_1_door_2","team_1_room_1_clear","race_farm_team_1_area_1_clear_ai");
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(2,2,"team_2_room_2_clear","race_farm_area_2_team_2_ready",2,7,undefined,"race_farm_team_2_door_2","team_2_room_1_clear","race_farm_team_2_area_1_clear_ai");	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(3,1,"team_1_room_3_clear","race_farm_area_3_team_1_ready",3,8,undefined,"race_farm_team_1_door_3","team_1_room_2_clear","race_farm_area_2_team_1_ready",true);
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(3,2,"team_2_room_3_clear","race_farm_area_3_team_2_ready",3,8,undefined,"race_farm_team_2_door_3","team_2_room_2_clear","race_farm_area_2_team_2_ready",true);	
	
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(4,1,"race_won","race_farm_area_4_team_1_ready",5,5,.25,undefined,"team_1_room_3_clear",undefined,undefined,true);
	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(4,2,"race_won","race_farm_area_4_team_2_ready",5,5,.25,undefined,"team_2_room_3_clear",undefined,undefined,true);
		
//	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(5,1,"race_won","race_farm_area_5_team_1_ready",5,5,.25,undefined,"team_1_room_4_clear",undefined,undefined,true);
//	level thread maps\mp\zombies\_zm_game_module_race::race_zombie_spawn_logic(5,2,"race_won","race_farm_area_5_team_2_ready",5,5,.25,undefined,"team_2_room_4_clear",undefined,undefined,true);
	
}
init_farm_race()
{
	setup_race_player_areas();
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_RACE_INDEX);	
	level._race_door_prefix = "race_farm_";
	level._race_location = "farm";
	flag_clear("zombie_drop_powerups");	

	level._chests_deleted = false;
	
	if(!is_true(level._nodes_unlinked))
	{	
		nodes = getnodearray("meat_farm_barrier_traversals","targetname");
		foreach(node in nodes)
		{
			unlinknodes(node,getnode(node.target,"targetname"));
		}
		level._nodes_unlinked = true;	
	}
	level thread open_all_doors();
}

open_all_doors()
{
	//HACKS!! needed to get around pathnode disconnection limits
	SetDvar("zombie_unlock_all",1);	
	players = GET_PLAYERS();
	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	for( i = 0; i < zombie_doors.size; i++ )
	{
		zombie_doors[i] notify("trigger",players[0]);
		wait(.05);
	}
	SetDvar("zombie_unlock_all",0);	
		
	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (8000,-5800,0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_farm_race" );
		level.spawned_collmap DisconnectPaths();	
	}
		
}

race_end()
{
	level._race_finish_trig = getent("race_farm_finish","targetname");	
	winning_team = maps\mp\zombies\_zm_race_utility::wait_for_all_players_finished(level._race_finish_trig);
	level notify("end_race",winning_team);
}

setup_race_player_areas()
{
	
	level._race_team_1_spawn_points = getstructarray("race_transit_farm_team1_spawn","targetname");
	level._race_team_2_spawn_points = getstructarray("race_transit_farm_team2_spawn","targetname");
	
	//team 1
	init_race_player_area("race_farm_team_1_area_1_clear_ai",1,"race_farm_area_1_team_1_zombie_spawn",1);
	init_race_player_area("race_farm_area_2_team_1_ready",2,"race_farm_area_2_team_1_zombie_spawn",1);
	init_race_player_area("race_farm_area_3_team_1_ready",3,"race_farm_area_3_team_1_zombie_spawn",1);
	init_race_player_area("race_farm_area_4_team_1_ready",4,"race_farm_area_4_team_1_zombie_spawn",1);
	//init_race_player_area("race_farm_area_5_team_1_ready",5,"race_farm_area_5_team_1_zombie_spawn",1);
		
	//team 2
	init_race_player_area("race_farm_team_2_area_1_clear_ai",1,"race_farm_area_1_team_2_zombie_spawn",2);
	init_race_player_area("race_farm_area_2_team_2_ready",2,"race_farm_area_2_team_2_zombie_spawn",2);
	init_race_player_area("race_farm_area_3_team_2_ready",3,"race_farm_area_3_team_2_zombie_spawn",2);
	init_race_player_area("race_farm_area_4_team_2_ready",4,"race_farm_area_4_team_2_zombie_spawn",2);
	//init_race_player_area("race_farm_area_5_team_2_ready",5,"race_farm_area_5_team_2_zombie_spawn",2);

}

farm_race_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("farm_race_intermission_cam");
}