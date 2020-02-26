/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\la_utility;
#include maps\la_1b_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\la_1b_fx::main();
	
	VisionSetNaked( "la_1" );

	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();

	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\la_1b_amb::main();
	maps\la_1b_anim::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\la_1b_art::main();
	
	maps\_rusher::init_rusher();
	maps\_lockonmissileturret::init( true );
	
	level thread objectives();
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
}

on_player_connect()
{
	setup_challenges();
}

// All precache calls go here
level_precache()
{
	PrecacheItem( "frag_grenade_sonar_sp" );
	PrecacheItem( "rpg_player_sp" );
	
	PrecacheModel( "p_jun_vc_ammo_crate" );
	PrecacheModel( "p_jun_vc_ammo_crate_open_single" );
	
	PrecacheShader( "mtl_karma_retina_bink" );
	
	PrecacheShellshock( "khe_sanh_woods" );
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// section 1
	add_skipto( "intro",				::skipto_la_1 );
	add_skipto( "after_the_attack",		::skipto_la_1 );
	add_skipto( "sam",					::skipto_la_1 );
	add_skipto( "cougar_fall",			::skipto_la_1 );
	add_skipto( "sniper_rappel",		::skipto_la_1 );
	add_skipto( "g20_group1",			::skipto_la_1 );
	add_skipto( "drive",				::skipto_la_1 );
	add_skipto( "skyline",				::skipto_la_1 );
	
	// section 2
	add_skipto( "street",				maps\la_street::skipto_street,
	           &"SKIPTO_STRING_HERE", 	maps\la_street::main );
	
	add_skipto( "plaza",				maps\la_plaza::skipto_plaza,
	           &"SKIPTO_STRING_HERE", 	maps\la_plaza::main );
	
	add_skipto( "arena",				maps\la_arena::skipto_arena,
	           &"SKIPTO_STRING_HERE", 	maps\la_arena::main );
	
	add_skipto( "arena_exit",			maps\la_arena::skipto_arena_exit,
	           &"SKIPTO_STRING_HERE", 	maps\la_arena::main );
	
	// section 3 - flyable f35
	add_skipto( "f35_wakeup",			::skipto_la_2 );
	add_skipto( "f35_boarding",			::skipto_la_2 );
	add_skipto( "f35_flying", 			::skipto_la_2 );
	add_skipto( "f35_ground_targets", 	::skipto_la_2 );
	add_skipto( "f35_pacing", 			::skipto_la_2 );
	add_skipto( "f35_rooftops", 		::skipto_la_2 );
	add_skipto( "f35_dogfights", 		::skipto_la_2 );
	add_skipto( "f35_trenchrun", 		::skipto_la_2 );
	add_skipto( "f35_hotel", 			::skipto_la_2 );
	add_skipto( "f35_eject", 			::skipto_la_2 );
	add_skipto( "f35_outro", 			::skipto_la_2 );
	
	default_skipto( "street" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_la_1()
{
	/#
		AddDebugCommand( "devmap la_1" );
	#/
}

skipto_la_2()
{
	/#
		AddDebugCommand( "devmap la_2" );
	#/
}

setup_challenges()
{	
	self thread maps\_challenges_sp::register_challenge( "rescuesecond", maps\la_plaza::challenge_rescuesecond );
	self thread maps\_challenges_sp::register_challenge( "sonar", maps\la_plaza::challenge_sonar );
	self thread maps\_challenges_sp::register_challenge( "roofdrones", maps\la_arena::challenge_roofdrones );
	self thread maps\_challenges_sp::register_challenge( "saveanderson", maps\la_arena::challenge_saveanderson );
}
