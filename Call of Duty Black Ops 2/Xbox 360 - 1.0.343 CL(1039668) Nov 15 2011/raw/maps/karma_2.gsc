/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_skipto;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\karma_2_fx::main();
	maps\_metal_storm::init();

	level_precache();
	init_flags();
	init_spawn_funcs();
	setup_objectives();
	setup_skiptos();
	
	maps\_load::main();

	maps\karma_2_amb::main();
	maps\karma_2_anim::main();
	maps\_heatseekingmissile::init();
	
	// Global extra cam entity
	level.e_extra_cam = GetEnt( "endgame_extra_cam", "targetname" );

	OnPlayerConnect_Callback( ::on_player_connect );	
	
	init_fade_settings();
	level thread maps\_drones::init();
	level thread maps\karma_civilians::civ_init();
	maps\_civilians::init_civilians();
	level thread maps\createart\karma_art::main();
}

on_player_connect()
{
	setup_challenges();
	
	level thread maps\createart\karma_art::karma_fog_intro();
	level.karma_vision = "checkin_landingpad_vision";
	level thread update_vision();
}


//
// Put all precache calls here
level_precache()
{
	precacheitem( "noweapon_sp" );
	PreCacheItem ("flash_grenade_sp");
	PreCacheItem ("concussion_grenade_sp");		
	precachemodel( "anim_glo_bullet_tip" );
	precachemodel( "test_p_anim_specialty_lockbreaker_device" );
	precachemodel( "test_p_anim_specialty_lockbreaker_padlock" );
	precachemodel( "test_p_anim_specialty_trespasser_card_swipe" );
	precachemodel( "test_p_anim_specialty_trespasser_device" );	
	precachemodel( "test_p_anim_karma_toolbox");
	Precachemodel( "test_p_anim_karma_briefcase" );
	Precachemodel( "com_clipboard_mocap" );
	PrecacheItem( "rpg_player_sp" );
	
	// ShellShock
	PrecacheShellshock( "concussion_grenade_mp" );
	
	// HUD
	PreCacheString( &"hud_shades_bootup" );
	
	// SECTION 1
	precachemodel( "t6_wpn_pistol_fiveseven_world_detect" );

	// SECTION 2
	precacheshader( "mtl_karma_retina_bink" );

	// SECTION 3
	precacheshader( "hud_karma_ui3d" );
	precachemodel( "veh_iw_air_osprey_fly" );
	precachemodel( "c_cub_prostitute_fb" );		// karma fb model
	
	PreCacheShader("cinematic");
	
	maps\karma_civilians::civ_precache();
}


//
// Each event's init_flags called here
init_flags()
{
	// EXTRA CAM: Hardcoded numbers to match karma_2.csc
	// Control the turning on/off of the 'extra cam'
	level.CLIENT_FLAG_EXTRA_CAM = 1; 	// Karma scanner
	level.CLIENT_FLAG_GLASSES_CAM = 2;
	level.CLIENT_FACE_SWAP = 3;		// Advertisement face swapping
	
	//AYERS: Adding in client flag so civial footsteps will not be ridiculous
	level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_MALE = 2;
	level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_FEMALE = 3;

	flag_init( "holster_weapons" );
	flag_init( "draw_weapons" );
	flag_init( "player_among_civilians" );
	flag_init( "player_act_normally" );
	flag_init( "trespasser_reward_enabled" );

	
	// SECTION 3
	maps\karma_exit_club::init_flags();
	maps\karma_enter_mall::init_flags();
	maps\karma_little_bird::init_flags();
	maps\karma_the_end::init_flags();
}


//
//  Each event's init_spawn_funcs called here.
init_spawn_funcs()
{
	// SECTION 3
	maps\karma_exit_club::init_spawn_funcs();
	maps\karma_enter_mall::init_spawn_funcs();
	maps\karma_little_bird::init_spawn_funcs();
	maps\karma_the_end::init_spawn_funcs();
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// SECTION 1
	add_skipto( "K1_e2_checkin",		::skipto_karma );
	add_skipto( "K1_e3_tower_lift", 	::skipto_karma );
	add_skipto( "K1_e3_lobby", 			::skipto_karma );
	add_skipto( "K1_e3_dropdown",		::skipto_karma );
	add_skipto( "K1_e4_spiderbot",		::skipto_karma );
	add_skipto( "K1_e4_gulliver",		::skipto_karma );

	// SECTION 2
	add_skipto( "K1_e5_crc", 			::skipto_karma );
	add_skipto( "K1_e5_construction",	::skipto_karma );
	add_skipto( "K1_e6_outer_solar", 	::skipto_karma );
	add_skipto( "K1_e6_inner_solar", 	::skipto_karma );
	add_skipto( "K1_e6_solar_fight", 	::skipto_karma );

	// SECTION 3
	add_skipto( "e7_exit_club",		maps\karma_exit_club::skipto_exit_club,
				"EXIT CLUB",  		maps\karma_exit_club::main );
	add_skipto( "e8_enter_mall",	maps\karma_enter_mall::skipto_enter_mall,
				"ENTER MALL",  		maps\karma_enter_mall::main );
	add_skipto( "e9_little_bird",	maps\karma_little_bird::skipto_little_bird,
				"LITTLE BIRD",		maps\karma_little_bird::main );
	add_skipto( "e10_the_end",		maps\karma_the_end::skipto_the_end,
				"THE END",  		maps\karma_the_end::main );

	default_skipto( "e7_exit_club" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}


skipto_karma()
{
	/#
		AddDebugCommand( "devmap karma" );
	#/
}


//
// Load the right gump for the skipto
load_gumps_karma()
{
	if ( is_after_skipto( "e9_little_bird" ) )
	{
		load_gump( "karma_gump_10" );
	}
	else if ( is_after_skipto( "e8_enter_mall" ) )
	{
		load_gump( "karma_gump_9" );
	}
	else
	{
		load_gump( "karma_gump_exit_club_mall" );
	}
}


//
//	Free up variables
var_cleanup()
{
	//	Cleanup level.struct to free vars
	for(i = level.struct.size; i >= 0; i--)
	{
		level.struct[i] = undefined;
	}
	level.struct = undefined;
}


//
// sets flags for the skipto's and exits out at appropriate skipto point.  
//	All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	var_cleanup();

	skipto = level.skipto_point;

	// Change the skybox to the normal mode - we need this in case people jump around using skiptos as the variable doesn't reset
	SetSavedDvar( "r_skyTransition", 1 );

	load_gumps_karma();
	
	thread skip_objective( level.OBJ_SECURITY );
//	flag_set( "elevator_reached_lobby" );
	thread skip_objective( level.OBJ_FIND_CRC );
	thread skip_objective( level.OBJ_CRC_GUY );
	thread skip_objective( level.OBJ_SCAN_EYE );
//	flag_set( "spiderbot_end" );
	thread skip_objective( level.OBJ_ENTER_CRC );

//	flag_set( "salazar_start_overwatch" );
//	flag_set( "civ_kill_club" );
//	flag_set( "start_club_fight" );

	//	SECTION 3
	if ( skipto == "e7_exit_club" )
		return;
	
	if ( skipto == "e8_enter_mall" )
		return;
	
	if ( skipto == "e9_little_bird" )
		return;
}


//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//-----------------------------------------------------------------------------------------------
setup_challenges()
{
//	self thread maps\_challenges_sp::register_challenge( "retrievespiderbot", maps\karma_crc::retrieve_bot_challenge );
//	self thread maps\_challenges_sp::register_challenge( "karmanodeath", maps\karma_checkin::karma_no_death_challenge );
//	self thread maps\_challenges_sp::register_challenge( "botsalive", maps\karma_spiderbot::bots_alive_challenge );
}

