#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

standard_start()
{
	level._classic_setup_func = maps\mp\zm_transit::setup_classic_gametype;
	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects("town");
	maps\mp\zombies\_zm_game_module::kill_all_zombies();
	flag_wait("initial_blackscreen_passed");
	
	players = GET_PLAYERS();
	spawnpoints =getstructarray("town_standard_player_spawns","targetname");
	for(i=0;i<players.size;i++)
	{
		players[i] SetOrigin( spawnpoints[i].origin );
		players[i] SetPlayerAngles( spawnpoints[i].angles );
	}

	//iprintlnbold("Survive in Town as long as you can!");

	//spawn the collision map
	collision = Spawn( "script_model", (1363, 471, 0), 1 );
	collision SetModel( "zm_collision_transit_town_survival" );
	collision DisconnectPaths();
		
	//hide the starting chest
	wait(3.0);
		
	start_chest = getent("start_chest","script_noteworthy");
	start_chest maps\mp\zombies\_zm_magicbox::hide_chest();	
	
	// set up the magic box , and make it not fly away
	chest = getent("town_chest","script_noteworthy");
	chest maps\mp\zombies\_zm_magicbox::hide_rubble();	
	chest maps\mp\zombies\_zm_magicbox::show_chest();	
	chest.no_fly_away = true;	
	
	level.chests[level.chest_index] = chest;	
	
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