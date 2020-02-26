#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

onStartGameType()
{	
	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects( "station" );
	
	//setup all the classic mode stuff 
	maps\mp\zm_transit::setup_classic_gametype();
	
	maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_GRIEF_INDEX );

	maps\mp\zombies\_zm_game_module::kill_all_zombies();
		
	// Spawn Collision
	//----------------
	collision = Spawn( "script_model", ( -6896, 4744, 0 ), 1 );
	collision SetModel( "zm_collision_transit_busdepot_survival" );
	collision DisconnectPaths();

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

	flag_set( "power_on" );
}

onEndGame()
{
}