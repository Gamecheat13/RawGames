#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	// settings for this challenge
	setdvar( "pmc_gametype", "mode_elimination" );
	setdvar( "pmc_enemies", "15" );
	setdvar( "pmc_all_juggernauts", "1" );
	setdvar( "pmc_enemies_alive", 3 );
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\oilrig_precache::main();
	maps\createart\oilrig_fog::main();
	maps\oilrig_fx::main();
	maps\createfx\oilrig_audio::main();
	maps\_pmc::preLoad();
    maps\_load::main();
    maps\_pmc::main();
    level thread maps\oilrig_amb::main();
    
    door1 = getent( "door_deck1", "targetname" );
    door1 connectPaths();
    door1 delete();
    
    door2 = getent( "door_deck1_opposite", "targetname" );
    door2 connectPaths();
    door2 delete();
    
    eGate = getent( "gate_01", "targetname" );
	eGate connectpaths();
	eGate moveto( ( eGate.origin - ( 0, -170, 0 ) ), 1 );

	maps\_compass::setupMiniMap( "compass_map_oilrig_lvl_1" );
	array_thread( getentarray( "compassTriggers", "targetname" ), maps\oilrig::compass_triggers_think );
	array_call( getentarray( "hide", "script_noteworthy" ), ::hide );

	music_loop( "airlift_ride_music", 130 );
}