#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

standard_start()
{
	init_standard_farm();
	
	maps\mp\zombies\_zm_game_module::kill_all_zombies();
	flag_wait("initial_blackscreen_passed");
	
	players = GET_PLAYERS();
	spawnpoints =getstructarray("farm_standard_player_spawns","targetname");
	for(i=0;i<players.size;i++)
	{
		players[i] SetOrigin( spawnpoints[i].origin );
		players[i] SetPlayerAngles( spawnpoints[i].angles );
	}

	//iprintlnbold("Survive in the farm as long as you can!");
	
	// sets the active zone
	//flag_set("OnFarm_enter");
	flag_set ("power_on");
	
	//spawn the collision map
	collision = Spawn( "script_model", (8000,-5800,0), 1 );
	collision SetModel( "zm_collision_transit_farm_survival" );
	collision DisconnectPaths();

	//hide the starting chest
	wait(3.0);
	start_chest = getent("start_chest","script_noteworthy");
	start_chest maps\mp\zombies\_zm_magicbox::hide_chest();	
	
	// set up the magic box , and make it not fly away
	chest = getent("farm_chest","script_noteworthy");
	chest maps\mp\zombies\_zm_magicbox::show_chest();
	chest maps\mp\zombies\_zm_magicbox::hide_rubble();	
	chest.no_fly_away = true;	
	level.chests[level.chest_index] = chest;	

	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_far_ext" );

	level notify("revive_on");				
	wait_network_frame();
	level notify("doubletap_on");
	wait_network_frame();
	level notify("marathon_on");
	wait_network_frame();
	level notify("juggernog_on");
	wait_network_frame();
	level notify("sleight_on");
	wait_network_frame();
	level notify("Pack_A_Punch_on");
}


init_standard_farm()
{
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_STANDARD_INDEX);	
	maps\mp\zm_transit::setup_classic_gametype();
			
	ents = getentarray();
	foreach(ent in ents)
	{
		if(isDefined(ent.script_flag) && ent.script_flag == "OnFarm_enter")
		{
			ent delete();
			continue;
		}		
		if(isDefined(ent.script_parameters))
		{
			tokens = strtok(ent.script_parameters," ");
			remove = false;
			foreach(token in tokens)
			{
				if(token == "standard_remove")
				{
					remove = true;
				}
			}
			if(remove)
			{
				ent delete();
			}
		}
	}
}
