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
#insert raw\maps\karma.gsh;

main()
{
	level.createfx_callback_thread = ::createfx_setup;

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
	
	//level thread setup_challenge();
	level thread maps\_drones::init();
	level thread maps\karma_civilians::civ_init();
	maps\_civilians::init_civilians();
	level thread maps\createart\karma_2_art::main();
	
	level.callbackActorKilled = ::Callback_ActorKilled_Check;

}

on_player_connect()
{
	level.player = get_players()[0];	// this may not be setup by _load in time.

	self thread setup_challenge();
	
	level thread maps\createart\karma_2_art::vision_set_change( "sp_karma2_clubexit" );
	run_thread_on_targetname( "vision_trigger", maps\createart\karma_2_art::vision_set_trigger_think );

	setup_threat_bias_groups();
}

setup_challenge()
{
	// Karma 1 & 2
	self thread maps\_challenges_sp::register_challenge( "specialvisionkills", ::special_vision_kills_challenge );
	self thread maps\_challenges_sp::register_challenge( "hurtciv", ::no_killing_civ );
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::karma_no_death_challenge );
	self thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	
	// Karma 1
//	self thread maps\_challenges_sp::register_challenge( "retrievespiderbot", ::retrieve_bot_challenge );
//	self thread maps\_challenges_sp::register_challenge( "fastspiderbotcomplete", ::fast_complete_spider_bot );
//	self thread maps\_challenges_sp::register_challenge( "clubspeedkill", ::club_speed_kill_challenge );

	// Karma 2
	self thread maps\_challenges_sp::register_challenge( "killrappellingenemies", ::rappel_kills_challenge );
	self thread maps\_challenges_sp::register_challenge( "destroyhelicopters", ::kill_helicopters_challenge );
	self thread maps\_challenges_sp::register_challenge( "asdalive", ::keep_asd_alive_challenge );
}


//
// Put all precache calls here
level_precache()
{
	PreCacheItem ("flash_grenade_sp");
	PrecacheModel( "anim_glo_bullet_tip" );
	PrecacheModel( "test_p_anim_specialty_lockbreaker_device" );
	PrecacheModel( "test_p_anim_specialty_lockbreaker_padlock" );
	PrecacheModel( "test_p_anim_specialty_trespasser_card_swipe" );
	PrecacheModel( "test_p_anim_specialty_trespasser_device" );	
	PrecacheModel( "test_p_anim_karma_toolbox");
	PrecacheModel( "test_p_anim_karma_briefcase" );
	PrecacheModel( "com_clipboard_mocap" );
	PrecacheModel( "c_usa_chloe_lynch_organs_fb");
	PrecacheModel( "c_usa_chloe_lynch_organs_hit_fb" );
	PrecacheModel( "t6_wpn_jaws_of_life_prop" );
	PrecacheModel( "t6_wpn_laser_cutter_prop" );
	PrecacheModel( "t6_wpn_launch_fhj18_world" );
	PrecacheModel( "p6_anim_cell_phone" );
	PrecacheModel( "t6_wpn_sniper_ballista_prop_view" );
	PrecacheModel( "dest_aquarium_glass_karma" );
	
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "ballista_karma_sp" );
	PrecacheItem( "fhj18_dpad_sp" );

	// ShellShock
	PrecacheShellshock( "concussion_grenade_mp" );
	
	// LUI
	PrecacheString( &"hud_karma_circulatory_fade" );
	PrecacheString( &"hud_karma_circulatory_scan" );
	PrecacheString( &"hud_karma_circulatory_remove_scan" );
	PrecacheString( &"hud_karma_circulatory_end" );
	
	// SECTION 3
//	precacheshader( "hud_karma_ui3d" );
	PrecacheModel( "veh_iw_air_osprey_fly" );
	
	maps\karma_civilians::civ_precache();
}


//
// Each event's init_flags called here
init_flags()
{
	flag_init( "holster_weapons" );
	flag_init( "draw_weapons" );
	flag_init( "player_among_civilians" );
	flag_init( "player_act_normally" );
	flag_init( "trespasser_reward_enabled" );
	flag_init( "e10_player_raise_gun" );
	flag_init( "e10_close_vtol_door" );

	
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
	
	array_thread( GetSpawnerTeamArray("axis"), ::add_spawn_function, ::turn_on_enemy_highlight );
	array_thread( GetSpawnerTeamArray("neutral"), ::add_spawn_function, ::check_for_player_damage);
	
	sp_defalco = GetEnt( "defalco", "targetname" );
	sp_defalco add_spawn_function( ::attach_phone );
	
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
	add_skipto( "e1_arrival",		::skipto_karma );
	add_skipto( "e2_checkin",		::skipto_karma );
	add_skipto( "e3_tower_lift", 	::skipto_karma );
	add_skipto( "e3_lobby", 		::skipto_karma );
	add_skipto( "e3_dropdown",		::skipto_karma );
	add_skipto( "e4_spiderbot",		::skipto_karma );
	add_skipto( "e4_gulliver",		::skipto_karma );

	// SECTION 2
	add_skipto( "e5_crc", 			::skipto_karma );
	add_skipto( "e5_construction",	::skipto_karma );
	add_skipto( "e6_outer_solar", 	::skipto_karma );
	add_skipto( "e6_inner_solar", 	::skipto_karma );
	add_skipto( "e6_solar_fight", 	::skipto_karma );

	// SECTION 3
	add_skipto( "e7_exit_club",		maps\karma_exit_club::skipto_exit_club,
				"EXIT CLUB",  		maps\karma_exit_club::main );
	add_skipto( "e8_enter_mall",	maps\karma_enter_mall::skipto_enter_mall,
				"ENTER MALL",  		maps\karma_enter_mall::main );
	add_skipto( "e9_little_bird",	maps\karma_little_bird::skipto_little_bird,
				"LITTLE BIRD",		maps\karma_little_bird::main );
	add_skipto( "e10_the_end",		maps\karma_the_end::skipto_the_end,
				"THE END",  		maps\karma_the_end::main );
	add_skipto( "dev_e10_the_end",	maps\karma_the_end::skipto_the_end_perk,
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
		load_gump( "karma_2_gump_the_end" );
	}
	else if ( is_after_skipto( "e8_enter_mall" ) )
	{
		load_gump( "karma_2_gump_sundeck" );
	}
	else
	{
		load_gump( "karma_2_gump_mall" );
	}
}


//
// sets flags for the skipto's and exits out at appropriate skipto point.  
//	All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	skipto = level.skipto_point;

	// the perfect spot to add the fade_out for karma2 intro.
	if ( skipto == "e7_exit_club" )
	{
		screen_fade_out(0);
	}
	
	load_gumps_karma();
	
	thread skip_objective( level.OBJ_SECURITY );
	thread skip_objective( level.OBJ_ENTER_CRC );
	thread skip_objective( level.OBJ_ID_KARMA );
	thread skip_objective( level.OBJ_MEET_KARMA );

	//	SECTION 3
	if ( skipto == "e7_exit_club" )
		return;
	
	if ( skipto == "e8_enter_mall" )
		return;
	
	if ( skipto == "e9_little_bird" )
		return;
}


//
//	Need to setup threat bias groups mainly so that the ASD can work
//	as a hostile to enemies and the player's squad
setup_threat_bias_groups()
{
	CreateThreatBiasGroup( "navy_seals" );		// ally
	CreateThreatBiasGroup( "tacitus" );			// axis
	CreateThreatBiasGroup( "ship_security" );	// neutral
	CreateThreatBiasGroup( "ship_drones" );		// neutral
	CreateThreatBiasGroup( "civilians" );		// neutral

	// Tacitus attacks security, drones and players	
	SetThreatBias( "ship_security",	"tacitus", 1500 );
	SetThreatBias( "ship_drones",	"tacitus", 1500 );
	SetThreatBias( "navy_seals",	"tacitus", 1500 );
	SetThreatBias( "civilians",		"tacitus",   50 );
	
	// Security attacks Tacitus
	SetThreatBias( "tacitus",		"ship_security", 1500 );
	SetThreatBias( "navy_seals",	"ship_security", -1500 );
	SetThreatBias( "civilians",		"ship_security", -1500 );

	// ASDs attack SEALs and Tacitus
	SetThreatBias( "tacitus",		"ship_drones", 1500 );
	SetThreatBias( "navy_seals",	"ship_drones", 1500 );
	SetThreatBias( "civilians",		"ship_drones", -1500 );

	// SEALs attack Tacitus and ASDs
	SetThreatBias( "tacitus",		"navy_seals", 1500 );
	SetThreatBias( "ship_drones",	"navy_seals", 1500 );
	SetThreatBias( "ship_security",	"navy_seals", -1500 );
	SetThreatBias( "civilians",		"navy_seals", -1500 );
	
	level.player SetThreatBiasGroup( "navy_seals" );
}


check_for_player_damage()
{
	//self endon("death");
	
	self waittill("damage", damage, attacker);
	if( attacker == level.player )
	{
		level notify( "player_killed_civ" );
	}
	
}


//
//	Always stick a cell phone in your hand
//	self is Defalco
attach_phone()
{
	self Attach( "p6_anim_cell_phone", "tag_weapon_left" );
}

