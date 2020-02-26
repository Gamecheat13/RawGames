/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;

main()
{	

	// This MUST be first for CreateFX!	
	maps\yemen_fx::main();

	level_precache();
	level_init_flags();
	setup_skiptos();
	setup_level();	
	
	setup_objectives();
	level thread maps\_objectives::objectives();
	level thread maps\createart\yemen_art::main();
	
	level thread maps\_quadrotor::init();
	
	maps\_load::main();

	maps\yemen_fx::main();
	maps\yemen_amb::main();
	maps\yemen_anim::main();
}


level_precache()
{
	PrecacheItem( "rpg_magic_bullet_sp" );
//	PrecacheItem( "avenger_side_minigun" );
	PrecacheItem( "deserttac_sp" );
	PrecacheItem( "xm25_sp" );
	PrecacheItem( "mp5k_sp" );
	
	PrecacheShader( "mtl_karma_retina_bink" );
	//PreCacheShader( "fullscreen_dirt_bottom" );
	
	PrecacheModel( "p6_street_vendor_goods_table02" );
}


level_init_flags()
{
	maps\yemen_speech::init_flags();
	maps\yemen_market::init_flags();
	maps\yemen_terrorist_hunt::init_flags();
	maps\yemen_metal_storms::init_flags();
	maps\yemen_morals::init_flags();
	maps\yemen_drone_control::init_flags();
	maps\yemen_hijacked::init_flags();
	maps\yemen_capture::init_flags();
}


setup_level()
{
	// Set threatbias for the first few sections, for the teamswitch system
	maps\yemen_utility::teamswitch_threatbias_setup();
	
	// Set up for all the patrollers
	maps\yemen_utility::temp_vtol_stop_and_rappel();
	
	//TODO: put Defalco Alive logic here
	level.is_defalco_alive = true;	
}



/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
setup_skiptos()
{
	add_skipto( "speech", 			maps\yemen_speech::skipto_speech, 					"Speech", 			maps\yemen_speech::main );
	add_skipto( "market", 			maps\yemen_market::skipto_market, 					"Market", 			maps\yemen_market::main );
	add_skipto( "terrorist_hunt", 	maps\yemen_terrorist_hunt::skipto_terrorist_hunt, 	"Terrorist_Hunt",	maps\yemen_terrorist_hunt::main );
	add_skipto( "metal_storms", 	maps\yemen_metal_storms::skipto_metal_storms, 		"Metal_Storms", 	maps\yemen_metal_storms::main );
	add_skipto( "morals", 			maps\yemen_morals::skipto_morals, 					"Morals", 			maps\yemen_morals::main );
	add_skipto( "drone_control", 	maps\yemen_drone_control::skipto_drone_control, 	"Drone_Control", 	maps\yemen_drone_control::main );
	add_skipto( "hijacked", 		maps\yemen_hijacked::skipto_hijacked, 				"Hijacked", 		maps\yemen_hijacked::main );
	add_skipto( "capture", 			maps\yemen_capture::skipto_capture, 				"Capture", 			maps\yemen_capture::main );
	default_skipto( "speech" );
	
}



/* ------------------------------------------------------------------------------------------
Objectives
-------------------------------------------------------------------------------------------*/
setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	//level.OBJ_NAME = register_objective( &"LEVEL_OBJ_NAME" );
	level.OBJ_MARKET_MEET_MANENDEZ = register_objective( "Meet up with Manendez." );
	
	level.OBJ_TERRORIST_HUNT_HALL = register_objective( "Clear the hall of terrorists." );
	
	//Drone control
	level.OBJ_DRONE_CONTROL_BRIDGE = register_objective( "Regroup at the bridge." );
	
	//Capture
	level.OBJ_CAPTURE_MENENDEZ = register_objective( "Capture Menendez" );
	
	level thread objectives_speech();
	level thread objectives_market();
	level thread objectives_terrorist_hunt();
	level thread objectives_metal_storms();
	level thread objectives_morals();
	level thread objectives_drone_control();
	level thread objectives_hijacked();
	level thread objectives_capture();
}

objectives_speech()
{
	
}

objectives_market()
{
	flag_wait( "market_start" );
	s_market_meet = getstruct( "obj_market_meet_manendez", "targetname" );
	set_objective( level.OBJ_MARKET_MEET_MANENDEZ, s_market_meet, "breadcrumb" );		
}

objectives_terrorist_hunt()
{
	flag_wait( "terrorist_hunt_start" );
	s_market_meet = getstruct( "obj_rocket_hall_door", "targetname" );
	set_objective( level.OBJ_MARKET_MEET_MANENDEZ, s_market_meet, "breadcrumb" );
	
	flag_wait( "terrorist_hunt_rockethall_start" );
	set_objective( level.OBJ_MARKET_MEET_MANENDEZ, undefined );
	set_objective( level.OBJ_TERRORIST_HUNT_HALL, undefined );
	
	flag_wait( "terrorist_hunt_rockethall_done" );
	set_objective( level.OBJ_TERRORIST_HUNT_HALL, undefined, "remove" );
	// set_objective( level.OBJ_MARKET_MEET_MANENDEZ, s_market_meet, "breadcrumb" );
}

objectives_metal_storms()
{
	flag_wait( "metal_storms_start" );
	s_market_meet = getstruct( "obj_metalstorm_meet_manendez", "targetname" );
	set_objective( level.OBJ_MARKET_MEET_MANENDEZ, s_market_meet, "breadcrumb" );		
}

objectives_morals()
{
	
}

objectives_drone_control()
{
	flag_wait( "obj_drone_control_follow" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, level.salazar, "follow" );
	
	flag_wait( "obj_drone_control_guantlet" );
	s_obj_gauntlet = GetStruct( "obj_drone_control_guantlet" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, level.salazar, "remove" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "breadcrumb" );
	
	flag_wait( "obj_drone_control_bridge" );
	s_obj_bridge = GetStruct( "obj_drone_control_bridge" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "remove" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_bridge, "breadcrumb" );
}

objectives_hijacked()
{
//	s_obj_bridge = GetStruct( "obj_drone_control_bridge" );
//	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_bridge, "breadcrumb" );
}

objectives_capture()
{
	flag_wait( "obj_capture_sitrep" );
	s_obj_capture_sitrep = GetStruct( "s_obj_capture_sitrep", "targetname" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_obj_capture_sitrep, "breadcrumb" );
//	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_bridge, "breadcrumb" );
	
//	flag_wait( "obj_capture_rockarch" );
//	s_obj_capture_rockarch = GetStruct( "s_obj_capture_rockarch", "targetname" );
//	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_obj_capture_rockarch.origin, "breadcrumb" );
//	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_obj_capture_sitrep, "remove" );
	
	flag_wait( "obj_capture_menendez" );
	s_obj_capture_menendez = GetStruct( "s_obj_capture_menendez", "targetname" )
	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_obj_capture_menendez, "breadcrumb" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_obj_capture_sitrep, "remove" );
}

/* ------------------------------------------------------------------------------------------
Challenges
-------------------------------------------------------------------------------------------*/
//
//setup_challenges()
//{
//	self thread maps\_challenges_sp::register_challenge( "nodeath", maps\yemen_capture::challenge_nodeath );
//	self thread maps\_challenges_sp::register_challenge( "menendezsnipekills",  maps\yemen_capture::capture_challenge_snipekills );
//}
