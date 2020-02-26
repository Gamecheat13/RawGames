/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;
#include maps\_vehicle;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\pakistan_3_fx::main();
	
	init_flags();
	maps\pakistan_3_anim::main();
	
	VisionSetNaked( "default" );

	level_precache();
	setup_objectives();
	setup_skiptos();
	
	maps\_pbr::init();
	maps\_soct::init();
	maps\_lockonmissileturret::init( false, undefined, 1, true );
	
	level._vehicle_load_lights = true;

	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\pakistan_3_amb::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\pakistan_3_art::main();
	
	SetSavedDvar( "phys_buoyancy", 1 );  // this enables buoyant physics objects in Radiant (our boat)
	SetSavedDvar( "phys_ragdoll_buoyancy", 1 );  // this enables ragdoll corpses to float. Note required, but fun. 
	
	maps\_boat_soct_ride::init();
	
	// Handles the updating of objectives
	level thread objectives();
}

on_player_connect()
{
	setup_challenges();
}

// All precache calls go here
level_precache()
{
	PrecacheItem( "usrpg_player_sp" );
	
	PrecacheModel( "c_usa_cia_combat_harper_burned_fb" );
	PrecacheModel( "veh_t6_mil_soc_t_steeringwheel" );
	PrecacheModel( "veh_t6_mil_soc_t_no_col" );
	
	PrecacheShader( "compass_static" );
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// section 1
	add_skipto( "intro", 						::skipto_pakistan );
	add_skipto( "market", 						::skipto_pakistan );
	add_skipto( "dev_market_perk", 				::skipto_pakistan );
	add_skipto( "dev_market_no_perk", 			::skipto_pakistan );
	add_skipto( "car_smash", 					::skipto_pakistan );
	add_skipto( "market_exit",	 				::skipto_pakistan );
	add_skipto( "dev_market_exit_perk",	 		::skipto_pakistan );
	add_skipto( "dev_market_exit_no_perk",		::skipto_pakistan );		
	add_skipto( "frogger",						::skipto_pakistan );
	add_skipto( "bus_street", 					::skipto_pakistan );
	add_skipto( "bus_dam", 						::skipto_pakistan );
	add_skipto( "alley", 						::skipto_pakistan );
	add_skipto( "anthem_approach", 				::skipto_pakistan );
	add_skipto( "sewer_exterior", 				::skipto_pakistan );
	add_skipto( "sewer_interior", 				::skipto_pakistan );
	add_skipto( "dev_sewer_interior_perk", 		::skipto_pakistan );
	add_skipto( "dev_sewer_interior_no_perk",	::skipto_pakistan );
	
	// section 2
	add_skipto( "anthem",		::skipto_pakistan_2 );
	add_skipto( "roof_meeting",	::skipto_pakistan_2 );
	add_skipto( "underground",	::skipto_pakistan_2 );
	add_skipto( "claw",			::skipto_pakistan_2 );
	
	// section 3
	add_skipto( "escape_intro",		maps\pakistan_escape_intro::skipto_escape_intro,
	           undefined, 			maps\pakistan_escape_intro::main );
	
	add_skipto( "escape_battle",	maps\pakistan_escape::skipto_escape_battle,
	           undefined, 			maps\pakistan_escape::main );
	
	add_skipto( "escape_bosses",	maps\pakistan_escape_end::skipto_escape_bosses,
	           undefined, 			maps\pakistan_escape_end::main );
	
	add_skipto( "warehouse",		maps\pakistan_escape_end::skipto_warehouse,
	           undefined, 			maps\pakistan_escape_end::warehouse_main );
	
	add_skipto( "hangar",			maps\pakistan_evac::skipto_hangar,
	           undefined, 			maps\pakistan_evac::hangar_main );
	
	add_skipto( "standoff",			maps\pakistan_evac::skipto_standoff,
	           undefined, 			maps\pakistan_evac::standoff_main );
	
	add_skipto( "dev_s3_script",	maps\pakistan_evac::skipto_dev_s3_script );
	add_skipto( "dev_s3_build",		maps\pakistan_evac::skipto_dev_s3_build );
	
	default_skipto( "escape_intro" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_pakistan()
{
	ChangeLevel( "pakistan", true );
}

skipto_pakistan_2()
{
	ChangeLevel( "pakistan_2", true );
}

/* ------------------------------------------------------------------------------------------
CHALLENGES
-------------------------------------------------------------------------------------------*/
setup_challenges()
{
	// section 3
	self thread maps\_challenges_sp::register_challenge( "nodeath",		::challenge_nodeath );
	self thread maps\_challenges_sp::register_challenge( "bigjump",		::challenge_big_jumps );
	self thread maps\_challenges_sp::register_challenge( "takedown",	::challenge_takedowns );
}

challenge_nodeath( str_notify )
{
	trigger_wait( "prepare_for_hangar" );
	
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
}

challenge_big_jumps( str_notify )
{
	flag_wait( "section_3_started" );
		
	while ( true )
	{
		level waittill( "big_jump" );
		self notify( str_notify );
	}
}

challenge_takedowns( str_notify )
{
	flag_wait( "section_3_started" );
		
	while ( true )
	{
		level waittill( "takedown" );
		self notify( str_notify );
	}
}