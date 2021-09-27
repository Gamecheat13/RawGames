#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

main()
{
	define_loadout( "london" );
	maps\createart\london_art::main();
	maps\westminster_station_precache::main();
	maps\london_fx::main();
    
	describe_start( "west_station",			maps\london_west::start_west_station,			"Westminster Station",		maps\london_west::west_station	);
 	describe_start( "west_ending",			maps\london_west::start_west_ending,			"Westminster",				maps\london_west::west_ending	);
 	describe_start( "west_ending_stairs",	maps\london_west::start_west_ending_stairs,		"Westminster Stairs",		maps\london_west::west_ending	);
// 	describe_start( "west_ending_explosion",maps\london_west::start_west_ending_explosion,	"Westminster Explosion"	);
	
	maps\london_starts::main();
	
	maps\london_code::level_precache();
	maps\london_west::pre_load();

	maps\_load::main();	
	maps\_drone_civilian::init(); 
	maps\_drone_ai::init(); 
	
	maps\london_code::init_level();
	thread maps\london_starts::enter_objectives();
	thread maps\london_starts::enter_music();
  	thread maps\london_starts::exit_vision();
}
