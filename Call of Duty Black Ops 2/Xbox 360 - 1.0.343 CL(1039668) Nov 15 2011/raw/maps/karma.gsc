/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_skipto;
#include maps\karma_util;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\karma_fx::main();
	maps\_metal_storm::init();

	level_precache();
	init_flags();
	init_spawn_funcs();
	setup_objectives();
	setup_skiptos();
	
	maps\_load::main();

	maps\karma_amb::main();
	maps\karma_anim::main();
	maps\_heatseekingmissile::init();
	
	// Global extra cam entity
	//level.e_extra_cam =  get_extracam();

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
	Precachemodel( "c_usa_jungmar_bowman_fb");
	Precachemodel( "c_mul_jinan_demoworker_bscatter_fb" );
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
	// EXTRA CAM: Hardcoded numbers to match karma.csc
	// Control the turning on/off of the 'extra cam'
	//level.CLIENT_FLAG_EXTRA_CAM = 1; 	// Karma scanner
	//level.CLIENT_FLAG_GLASSES_CAM = 2;
	level.CLIENT_FACE_SWAP = 3;		// Advertisement face swapping
	
	//AYERS: Adding in client flag so civial footsteps will not be ridiculous
	level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_MALE = 2;
	level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_FEMALE = 3;

	flag_init( "holster_weapons" );
	flag_init( "draw_weapons" );
	flag_init( "player_among_civilians" );
	flag_init( "player_act_normally" );
	flag_init( "trespasser_reward_enabled" );

	// SECTION 1
	maps\karma_checkin::init_flags();
	maps\karma_lobby::init_flags();
	maps\karma_dropdown::init_flags();
	maps\karma_spiderbot::init_flags();
	
	// SECTION 2
	maps\karma_crc::init_flags();
	maps\karma_construction::init_flags();
	maps\karma_outer_solar::init_flags();
	maps\karma_inner_solar::init_flags();
}


//
//  Each event's init_spawn_funcs called here.
init_spawn_funcs()
{
	// SECTION 1
	maps\karma_checkin::init_spawn_funcs();
	maps\karma_lobby::init_spawn_funcs();
	maps\karma_dropdown::init_spawn_funcs();
	maps\karma_spiderbot::init_spawn_funcs();
	
	// SECTION 2
	maps\karma_crc::init_spawn_funcs();
	maps\karma_construction::init_spawn_funcs();
	maps\karma_outer_solar::init_spawn_funcs();
	maps\karma_inner_solar::init_spawn_funcs();
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// SECTION 1
	add_skipto( "e2_checkin", 		maps\karma_checkin::skipto_checkin,
				"CHECKIN",  		maps\karma_checkin::checkin );
	add_skipto( "e3_tower_lift", 	maps\karma_checkin::skipto_tower_lift,
				"TOWER LIFT",  		maps\karma_checkin::tower_lift );
	add_skipto( "e3_lobby", 		maps\karma_lobby::skipto_lobby,
				"LOBBY",			maps\karma_lobby::main );
	add_skipto( "e3_dropdown",		maps\karma_dropdown::skipto_dropdown,
				"DROPDOWN",  		maps\karma_dropdown::main );	

	add_skipto( "e4_spiderbot",		maps\karma_spiderbot::skipto_spiderbot,
				"SPIDER-BOT",		maps\karma_spiderbot::vents );
	add_skipto( "e4_gulliver",		maps\karma_spiderbot::skipto_gulliver,
				"GULLIVER",			maps\karma_spiderbot::gulliver );


	// SECTION 2
	add_skipto( "e5_crc", 			maps\karma_crc::skipto_crc,
				"CRC",  			maps\karma_crc::main );	
	add_skipto( "e5_construction",	maps\karma_construction::skipto_construction,
				"CONSTRUCTION",  	maps\karma_construction::main );
	add_skipto( "e6_outer_solar", 	maps\karma_outer_solar::skipto_outer_solar,
				"OUTER_SOLAR",  	maps\karma_outer_solar::main );	
	add_skipto( "e6_inner_solar", 	maps\karma_inner_solar::skipto_inner_solar,
				"INNER_SOLAR",  	maps\karma_inner_solar::club_intro );		
	add_skipto( "e6_solar_fight", 	maps\karma_inner_solar::skipto_solar_fight,
				"INNER_SOLAR",  	maps\karma_inner_solar::club_fight );		

	// SECTION 3
	add_skipto( "K2_e7_exit_club",		::skipto_karma_2 );
	add_skipto( "K2_e8_enter_mall",		::skipto_karma_2 );
	add_skipto( "K2_e9_little_bird",	::skipto_karma_2 );
	add_skipto( "K2_e10_the_end",		::skipto_karma_2 );

	default_skipto( "e2_checkin" );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}


skipto_karma_2()
{
	/#
		AddDebugCommand( "devmap karma_2" );
	#/
}


//
// Load the right gump for the skipto
load_gumps_karma()
{
	if ( is_after_skipto( "e5_construction" ) )
	{
		load_gump( "karma_gump_club" );
	}
	else if ( is_after_skipto( "e3_dropdown" ) )
	{
		load_gump( "karma_gump_construction" );
	}
	else if ( is_after_skipto( "e3_tower_lift" ) )
	{
		load_gump( "karma_gump_hotel" );
	}
	else
	{
		load_gump( "karma_gump_checkin" );
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

//	trigger_off( "t_dropdown", "script_noteworthy" );
//	trigger_off( "t_walkways", "script_noteworthy" );

	// Change the skybox to the normal mode - we need this in case people jump around using skiptos as the variable doesn't reset
	SetSavedDvar( "r_skyTransition", 0 );

	load_gumps_karma();
	
    //	SECTION 1
	level.player thread weapon_controller();
	level.player thread check_civ_status();
	flag_set( "holster_weapons" );
	flag_set( "player_among_civilians" );
	
//	if ( skipto == "e1_arrival" )
//		return;

	thread set_objective( level.OBJ_SECURITY );
	
	if ( skipto == "e2_checkin" )
		return;
	
	thread set_objective( level.OBJ_SECURITY, undefined, "done" );
	thread set_objective( level.OBJ_FIND_CRC );

	if ( skipto == "e3_tower_lift" )
		return;
	
	flag_set( "elevator_reached_lobby" );
//	level thread maps\karma_checkin::checkin_towerlift_scene_cleanup();

	if ( skipto == "e3_lobby" )
		return;

	flag_clear( "player_among_civilians" );

	if ( skipto == "e3_dropdown" )
		return;
	
	thread set_objective( level.OBJ_FIND_CRC, undefined, "done" );

	if ( skipto == "e4_spiderbot" )
		return;

	flag_clear( "holster_weapons" );
/*
	if ( skipto == "e4_swarm" )
		return;
	
	if ( skipto == "e4_sneakers" )
		return;

	thread skip_objective( level.OBJ_IT_GUYS );
*/
	
	if ( skipto == "e4_gulliver" )
		return;
	
	thread skip_objective( level.OBJ_CRC_GUY );
	thread skip_objective( level.OBJ_SCAN_EYE );

	flag_set( "spiderbot_end" );

	//	SECTION 2
/*
	if ( skipto == "e5_1_walkway" )
		return;

	trigger_on( "t_dropdown", "script_noteworthy" );
	trigger_on( "t_walkways", "script_noteworthy" );
*/

	if ( skipto == "e5_crc" )
		return;
	
	set_objective( level.OBJ_ENTER_CRC, undefined, "done" );

	flag_clear( "holster_weapons" );

	if ( skipto == "e5_construction" )
		return;
	
//	if ( skipto == "e5_5_elevator3" )
//		return;

	flag_set( "holster_weapons" );
	
	if ( skipto == "e6_outer_solar" )
		return;	

	// Change the skybox to the alternate mode
	SetSavedDvar( "r_skyTransition", 1 );

	if ( skipto == "e6_inner_solar" )
		return;
	
	flag_set( "salazar_start_overwatch" );
	flag_set( "civ_kill_club" );
	flag_set( "start_club_fight" );
}


//
//	Forces the player to behave a little bit
check_civ_status()
{
	wait( 0.05 );	// let the skipto_cleanup run its course

	while (1)
	{
		flag_wait( "player_among_civilians" );

		flag_clear( "player_act_normally" );
		level.player AllowJump( false );
		level.player AllowSprint( false );
	
		flag_wait( "player_act_normally" );

		flag_clear( "player_among_civilians" );
		level.player AllowJump( true );
		level.player AllowSprint( true );
	}
}

	
//
//	Automatically draw and holster weapons based on setting a flag
//		Set "holster_weapons" to put weapons away
//		Set "draw_weapons" to pull them out again.
//	self is the player
weapon_controller()
{
	wait( 0.05 );	// let the skipto_cleanup run its course

	while (1)
	{
		// Put weapons away, arm yourself with fake hands
		flag_wait( "holster_weapons" );

		flag_clear( "draw_weapons" );
		self thread take_and_giveback_weapons( "draw_weapons" );
		self GiveWeapon( "noweapon_sp" );
		self SwitchToWeapon( "noweapon_sp" );
		self HideViewModel();
		
		// Draw your weapons
		flag_wait( "draw_weapons" );

		self TakeWeapon( "noweapon_sp" );
		self ShowViewModel();
		self notify( "draw_weapons" );
		flag_clear( "holster_weapons" );
	}
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//-----------------------------------------------------------------------------------------------
setup_challenges()
{
	self thread maps\_challenges_sp::register_challenge( "retrievespiderbot", maps\karma_crc::retrieve_bot_challenge );
//	self thread maps\_challenges_sp::register_challenge( "karmaallspecialties", ::karma_all_specialties_challenge );
	self thread maps\_challenges_sp::register_challenge( "karmanodeath", maps\karma_checkin::karma_no_death_challenge );
	self thread maps\_challenges_sp::register_challenge( "botsalive", maps\karma_spiderbot::bots_alive_challenge );
}

