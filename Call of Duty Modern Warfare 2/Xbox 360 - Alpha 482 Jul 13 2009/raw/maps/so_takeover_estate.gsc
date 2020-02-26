#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "far";

	// settings for this challenge
	setdvar( "pmc_gametype", "mode_elimination" );
	setdvar( "pmc_enemies", "40" );
	setdvar( "pmc_all_juggernauts", "0" );
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\estate_precache::main();
	maps\createart\estate_art::main();
	maps\createfx\estate_audio::main();
	maps\estate_fx::main();
	maps\_pmc::preLoad();
    maps\_load::main();
    maps\_pmc::main();
    thread maps\estate_amb::main();
	thread fix_windows_and_doors();
	
	maps\_compass::setupMiniMap("compass_map_estate");
	
	music_loop( "estate_ambushfight", 240 );
}

fix_windows_and_doors()
{
	getent( "fake_backwards_door", "targetname" ) delete();
	getent( "fake_backwards_door_clip", "targetname" ) delete();
	getent( "recroom_closed_doors", "targetname" ) delete();
	
	array_call( getentarray( "window_newspaper", "targetname" ), ::delete );
	array_call( getentarray( "window_pane", "targetname" ), ::delete );
	array_call( getentarray( "window_brokenglass", "targetname" ), ::delete );
	array_call( getentarray( "window_blinds", "targetname" ), ::delete );
}