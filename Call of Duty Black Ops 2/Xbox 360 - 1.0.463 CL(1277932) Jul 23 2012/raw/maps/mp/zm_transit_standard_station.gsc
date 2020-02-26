#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

standard_start()
{
	//precacheModel("zm_collision_transit_town_survival");
		
	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects("station");
	maps\mp\zombies\_zm_game_module::kill_all_zombies();
	flag_wait("initial_blackscreen_passed");
	
	players = GET_PLAYERS();
//	spawnpoints =getstructarray("initial_spawn_points","targetname");
//	for(i=0;i<players.size;i++)
//	{
//		players[i] SetOrigin( spawnpoints[i].origin );
//		players[i] SetPlayerAngles( spawnpoints[i].angles );
//	}

	//iprintlnbold("Survive in the Bus Depot as long as you can!");
	
	//hide the starting chest
	wait(3.0);
	start_chest = getent("start_chest","script_noteworthy");
	start_chest maps\mp\zombies\_zm_magicbox::hide_chest();	
	
	// set up the magic box , and make it not fly away
	chest = getent("depot_chest","script_noteworthy");
	chest maps\mp\zombies\_zm_magicbox::hide_rubble();	
	chest maps\mp\zombies\_zm_magicbox::show_chest();	
	chest.no_fly_away = true;	
		
	level.chests[level.chest_index] = chest;
	level thread maps\mp\zombies\_zm_perks::perk_machine_removal("specialty_quickrevive", "p_glo_tools_chest_tall");

	flag_set( "power_on" );
}