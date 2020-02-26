#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "close";

	// settings for this challenge
	setdvar( "pmc_gametype", "mode_elimination" );
	setdvar( "pmc_enemies", "10" );
	setdvar( "pmc_all_juggernauts", "1" );
	setdvar( "pmc_enemies_alive", 3 );
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	
	level.disable_interactive_tv_use_triggers = true;
	
	maps\createart\favela_fog::main();
	maps\createart\favela_art::main();
	maps\createfx\favela_audio::main();
	maps\favela_precache::main();
	maps\favela_fx::main();
	maps\_compass::setupMiniMap( "compass_map_favela" );
	maps\_pmc::preLoad();
	maps\_load::main();
	maps\_pmc::main();
	thread maps\favela_amb::main();
	
	music_loop( "favela_uppervillage_start", 121 );
}