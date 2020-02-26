/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;
#include maps\_vehicle;
#include maps\_glasses;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\pakistan_2_fx::main();
	
	init_flags();
	maps\pakistan_2_anim::main();
	
	VisionSetNaked( "default" );

	level_precache();
	setup_objectives();
	setup_skiptos();
	
	maps\_claw::init();
	maps\_soct::init();
	maps\_truck_gazTIGR::init();
	
	level._vehicle_load_lights = true;

	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\pakistan_2_amb::main();

	level thread maps\createart\pakistan_2_art::main();
	
	SetSavedDvar( "phys_buoyancy", 1 );  // this enables buoyant physics objects in Radiant (our boat)
	
	maps\_swimming::main();  // enable swimming feature
	
	// Handles the updating of objectives
	level thread objectives();
	
	OnPlayerConnect_Callback( ::on_player_connect );
}

// All precache calls go here
level_precache()
{
	PrecacheItem( "usrpg_player_sp" );
	PreCacheItem( "data_glove_sp" );
	PreCacheItem( "rappelgun_sp" );
	PreCacheItem( "usrpg_magic_bullet_sp" );
	PreCacheItem( "rpg_grapple_anchor_sp" );
	
	PreCacheModel( "t6_wpn_knife_melee" );
	
	PrecacheItem("vector_sp");
	
	PrecacheShader( "compass_static" );
	PrecacheShader( "photo_menendez" );
	PrecacheShader( "photo_defalco" );
	
	PrecacheShellShock( "default " );
	PrecacheRumble( "explosion_generic" );
	
	PrecacheString( &"hud_claw_grenade_fire" );
	PreCacheString( &"claw_offline_temp" );
	PrecacheString( &"yemen_kill_pilot" );
	
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vson" );
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vsoff" );
	
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
	add_skipto( "anthem", 			maps\pakistan_anthem::skipto_anthem,
	           undefined, 			maps\pakistan_anthem::main );
	
	add_skipto( "roof_meeting", 	maps\pakistan_roof_meeting::skipto_roof_meeting,
	           undefined, 			maps\pakistan_roof_meeting::main );
	
	add_skipto( "underground",		maps\pakistan_roof_meeting::skipto_underground,
	           undefined,			maps\pakistan_roof_meeting::underground_main );
	
	add_skipto( "claw", 			maps\pakistan_claw::skipto_claw,
	           undefined, 			maps\pakistan_claw::main );
	
	// section 3
	add_skipto( "escape_intro",		::skipto_pakistan_3 );
	add_skipto( "escape_battle",	::skipto_pakistan_3 );
	add_skipto( "escape_bosses",	::skipto_pakistan_3 );
	add_skipto( "warehouse",		::skipto_pakistan_3 );
	add_skipto( "hangar",			::skipto_pakistan_3 );
	add_skipto( "standoff",			::skipto_pakistan_3 );
	add_skipto( "dev_s3_script",	::skipto_pakistan_3 );
	add_skipto( "dev_s3_build",		::skipto_pakistan_3 );
	
	default_skipto( "anthem" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_pakistan()
{
	ChangeLevel( "pakistan", true );
}

skipto_pakistan_3()
{
	ChangeLevel( "pakistan_3", true );
}

on_player_connect()
{
	level.player = get_players()[0];
	
	// Handles water sheeting for swimming.
	level.player thread run_swimming_sheeting();
}
