/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\war_room_util;

// internal references
#include maps\blackout_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\blackout_fx::main();

	level_precache();
	init_flags();
	init_spawn_funcs();
	setup_objectives();
	
	maps\blackout_sensitive_geo::run_sensitive_geo();
	
	init_spawner_teams();
	init_kill_functions();
	
	setup_skiptos();
	
	setup_level();
	
	// Set up the turrets.
	level thread maps\_cic_turret::init();

	// There should not be any waits before this function is called.  If you need a wait, make sure the 	function
	//	is either threaded or called after _load::main.
	maps\_load::main();
	
	maps\_drones::init();  // required for drones to function
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	// Set up turret triggers.
	init_hackable_turrets();
	
	level thread run_distant_explosions();

	maps\blackout_anim::main();
	
	maps\blackout_amb::main();
		
	maps\blackout_util::init_fxanims();
	level thread maps\createart\blackout_art::main();
	init_doors();
	
	level.m_mason_height = getdvarfloatdefault( "player_standingViewHeight", 60 );
	level.m_menendez_height = level.m_mason_height + 5;
	
	// automagically deletes the holo table at the appropriate time.
	level thread maps\blackout_bridge::holo_table_flicker_out();
	
	init_turret_damage_override();
	
	setup_extra_cams();
	//hide_fa38_elevator_fxanim_model();
}

on_player_connect()
{
	level.player = get_players()[0];
	level.player thread setup_challenge();	
	level.player thread run_m32_autokill();
	
	clip = GetEnt( "mason_elevator_clip", "targetname" );
	clip NotSolid();
	
	retrieve_story_stats();	
		
	level notify( "story_stats_loaded" );
}

// temp aftermath server room whoever alive/dead here
setup_level()
{	
	// this will later be set, depending on what the player, as menendez, does to briggs.
	level.is_briggs_alive = true;
	level.num_seals_saved = 0;
}

//
// All precache calls go here
level_precache()
{
	// precache the player models.
	precache_player_models();
	
	// Global
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "usrpg_magic_bullet_sp" );
	PrecacheItem( "usrpg_magic_bullet_cmd_sp" );
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "f35_missile_turret" );
	PrecacheItem( "f35_side_minigun" );
	PrecacheItem( "cic_turret" );
	
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vson" );
	PrecacheModel( "veh_t6_air_fa38_extracam" );
	PrecacheModel( "veh_iw_sea_slava_cruiser_des" );
	PrecacheModel( "veh_iw_arleigh_burke_des" );
	PrecacheModel( "veh_iw_sea_rus_burya_corvette" );
	PrecacheModel( "test_p_anim_specialty_lockbreaker_device" );
	PrecacheModel( "test_p_anim_specialty_lockbreaker_padlock" );
	
	PrecacheModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	
	// Mason pt. 1
	PrecacheModel( "p6_bloody_rag" );
	PrecacheModel( "com_folding_chair" );
	PrecacheModel( "t6_wpn_tazor_knuckles_prop_view" );
	PrecacheModel( "t6_wpn_hacking_dongle_prop" );
	PrecacheModel( "t6_wpn_turret_cic_world" );
	PrecacheItem( "tazer_knuckles_sp" );
	
	// Menendez
	PrecacheModel( "t6_wpn_pistol_judge_prop_world" );
	PreCacheItem( "m32_gas_sp" );
	PrecacheModel( "c_mul_defalco_gasmask" );
	PrecacheModel( "c_usa_salazar_gasmask" );
	PrecacheModel( "c_mul_neomarx_la_light_gasmask" );
	PrecacheModel( "c_mul_neomarx_la_medium_gasmask" );
	PrecacheModel( "c_usa_chloe_head_bruised_cin" );
	PrecacheModel( "p6_breather_mask" );
	PrecacheModel( "p6_celerium_chip" );
	PrecacheModel( "p6_celerium_chip_eye" );
	PrecacheModel( "t6_wpn_launch_m32_prop" );
	PrecacheModel( "t6_wpn_pendant_prop_damaged" );
	PrecacheModel( "c_mul_menendez_old_noeye" );
	PrecacheModel( "veh_t6_air_fa38_landing_gear" );
	PrecacheModel( "paris_crowbar_02" );
	
	PrecacheModel( "veh_t6_air_fa38_landing_gear_proto" );
	PrecacheModel( "veh_t6_air_fa38_ladder_proto" );
	
	// Mason pt. 2
	PrecacheModel( "t6_wpn_laser_cutter_prop" );

//	PreCacheString( &"register_pip_material" );
//	PreCacheString( &"cinematic_start" );
//	PreCacheString( &"cinematic_stop" );
	PrecacheShader( "mtl_karma_retina_bink" );
	
	PreCacheString( &"rewind" );
	
	PreCacheString( &"blackout_dradis" );
	PreCacheString( &"blackout_general" );
	
	PreCacheString( &"mtl_karma_retina_bink" );
	
	PreCacheModel( "t6_wpn_jaws_of_life_prop" );
	
	PreCacheModel( "p6_mason_vent_panel" );
	PreCacheModel( "p6_mason_vent" );
	PreCacheModel( "p6_console_chair_swivel" );	
}

//
// Each event's init_flags called here
init_flags()
{
	// Utility
	maps\blackout_util::init_flags();
	
	// SECTION 1
	maps\blackout_interrogation::init_flags();
	maps\blackout_bridge::init_flags();
	maps\blackout_security::init_flags();
	
	// SECTION 2
	maps\blackout_menendez_start::init_flags();
	maps\blackout_menendez_combat::init_flags();
	
	// SECTION 3
	maps\blackout_server_room::init_flags();	
	maps\blackout_hangar::init_flags();
	maps\blackout_deck::init_flags();
	
	flag_init( "sea_cowbell_running" );
	flag_init( "bridge_launchers_running" );
	flag_init( "any_pipes_destroyed" );
	
	flag_init( "intruder_perk_used" );
	flag_init( "brute_force_perk_used" );
	flag_init( "lockbreaker_used" );
	
	// debug booleans.
	level.branching_scene_debug = false;
}


init_doors()
{
	maps\blackout_interrogation::init_doors();
	maps\blackout_bridge::init_doors();
	maps\blackout_defend::init_doors();
	maps\blackout_security::init_doors();
	maps\blackout_menendez_start::init_doors();
	maps\blackout_menendez_combat::init_doors();
	
	doors = GetEntArray( "rotating_door", "script_noteworthy" );
	for ( i = 0; i < doors.size; i++ )
	{
		model = GetEnt( doors[i].target, "targetname" );
		if ( IsDefined( model ) )
		{
			model LinkTo( doors[i] );
		}
	}
}


//
//  Each event's init_spawn_funcs called here.
init_spawn_funcs()
{
	// SECTION 1
//	maps\blackout_eventname::init_spawn_funcs();
	maps\blackout_bridge::spawn_functions();
	
	// SECTION 2

	// SECTION 3
	maps\blackout_hangar::init_spawn_funcs();
	maps\blackout_deck::init_spawn_funcs();
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/

setup_skiptos()
{
	//-- Skipto's.  These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info


//mason specific skiptos
	add_skipto( "mason_start",					maps\blackout_interrogation::skipto_mason_start,				&"SKIPTO_STRING_HERE", maps\blackout_interrogation::run_mason_start );
	add_skipto( "mason_interrogation_room", 	maps\blackout_interrogation::skipto_mason_interrogation_room, 	&"SKIPTO_STRING_HERE", maps\blackout_interrogation::run_mason_interrogation_room );
	add_skipto( "mason_wakeup",					maps\blackout_interrogation::skipto_mason_wakeup,				&"SKIPTO_STRING_HERE", maps\blackout_interrogation::run_mason_wakeup );
	add_skipto( "mason_hallway",				maps\blackout_interrogation::skipto_mason_hallway,				&"SKIPTO_STRING_HERE", maps\blackout_interrogation::run_mason_hallway );
	add_skipto( "mason_salazar_exit",			maps\blackout_bridge::skipto_mason_salazar_exit,				&"SKIPTO_STRING_HERE", maps\blackout_bridge::run_mason_salazar_exit );
	add_skipto( "mason_bridge", 				maps\blackout_bridge::skipto_mason_bridge, 						&"SKIPTO_STRING_HERE", maps\blackout_bridge::run_mason_bridge );
	add_skipto( "mason_catwalk",	 			maps\blackout_bridge::skipto_mason_catwalk, 					&"SKIPTO_STRING_HERE", maps\blackout_bridge::run_mason_catwalk );
	add_skipto( "mason_lower_level",	 		maps\blackout_security::skipto_mason_lower_level, 				&"SKIPTO_STRING_HERE", maps\blackout_security::run_mason_lower_level );
	add_skipto( "mason_defend", 				maps\blackout_security::skipto_mason_security, 					&"SKIPTO_STRING_HERE", maps\blackout_security::run_mason_security);
	add_skipto( "mason_cctv",				 	maps\blackout_security::skipto_mason_cctv, 						&"SKIPTO_STRING_HERE", maps\blackout_security::run_mason_cctv );
	
//menendez specific skiptos

	add_skipto( "menendez_start",	 		maps\blackout_menendez_start::skipto_menendez_start,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_start::run_menendez_start );
	add_skipto( "menendez_meat_shield",		maps\blackout_menendez_start::skipto_menendez_meat_shield,	&"SKIPTO_STRING_HERE", maps\blackout_menendez_start::run_menendez_meat_shield );
	add_skipto( "menendez_betrayal",		maps\blackout_menendez_start::skipto_menendez_betrayal,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_start::run_menendez_betrayal );
	add_skipto( "menendez_combat",			maps\blackout_menendez_combat::skipto_menendez_combat,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_combat::run_menendez_combat );
	add_skipto( "menendez_hangar",			maps\blackout_menendez_combat::skipto_menendez_hangar,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_combat::run_menendez_hangar );
	add_skipto( "menendez_plane",			maps\blackout_menendez_combat::skipto_menendez_plane,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_combat::run_menendez_plane );
	add_skipto( "menendez_deck",			maps\blackout_menendez_escape::skipto_menendez_deck,		&"SKIPTO_STRING_HERE", maps\blackout_menendez_escape::run_menendez_deck );
	
// back to mason
	add_skipto( "mason_vent",				maps\blackout_server_room::skipto_mason_vent,				"MASON_VENT",	maps\blackout_server_room::run_mason_vent );
	add_skipto( "mason_server_room",		maps\blackout_server_room::skipto_mason_server_room,		"MASON_SERVER_ROOM",	maps\blackout_server_room::run_mason_server_room );
	add_skipto( "mason_hangar", 			maps\blackout_hangar::skipto_mason_hangar, 					"MASON_HANGER",	maps\blackout_hangar::run_mason_hangar );
	add_skipto( "mason_salazar_caught",		maps\blackout_hangar::skipto_mason_salazar_caught,			&"SKIPTO_STRING_HERE",	maps\blackout_hangar::run_mason_salazar_caught );
	add_skipto( "mason_elevator",			maps\blackout_hangar::skipto_mason_elevator,				"MASON_ELEVATOR",	maps\blackout_hangar::run_mason_elevator );
	add_skipto( "mason_deck", 				maps\blackout_deck::skipto_mason_deck, 						&"SKIPTO_STRING_HERE",	maps\blackout_deck::run_mason_deck );
	add_skipto( "mason_plane_crash",	 	maps\blackout_deck::skipto_mason_plane_crash,				&"SKIPTO_STRING_HERE",	maps\blackout_deck::run_mason_plane_crash );
	add_skipto( "mason_deck_final", 		maps\blackout_deck::skipto_mason_deck_final, 				&"SKIPTO_STRING_HERE",	maps\blackout_deck::run_mason_anderson );
	add_skipto( "mason_anderson", 			maps\blackout_deck::skipto_mason_anderson, 					&"SKIPTO_STRING_HERE",	maps\blackout_deck::run_mason_deck_final );
	
	default_skipto( "mason_start" );
}


/* ------------------------------------------------------------------------------------------
Objectives
-------------------------------------------------------------------------------------------*/

//
//	List all level objectives
setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	// perk objectives.
	level.OBJ_LOCK_PERK			= register_objective( &"" );
	level.OBJ_HACK_PERK			= register_objective( &"" );
	
	// SECTION 1
	level.OBJ_INTERROGATE		= register_objective( &"BLACKOUT_INTERROGATE" );
	level.OBJ_PICKUP_WEAPONS	= register_objective( &"BLACKOUT_PICKUP_GUNS" );
	level.OBJ_FOLLOW_SALAZAR	= register_objective( &"BLACKOUT_FOLLOW_SALAZAR" );
	level.OBJ_RESTORE_CONTROL	= register_objective( &"BLACKOUT_RESTORE_CONTROL" );
	level.OBJ_DEFEND_HACKER		= register_objective( &"BLACKOUT_DEFEND_HACKER" );
	level.OBJ_RENDEZVOUS		= register_objective( &"BLACKOUT_RENDEZVOUS" );
	level.OBJ_CCTV				= register_objective( &"BLACKOUT_VIEW_CCTV" );
	level.OBJ_HELP_SEALS		= register_objective( "Assist the SEALs using a sniper rifle." ); //TODO: make localized string
	
	/*
	level.OBJ_NAME			= register_objective( "Temp string here.  Replace with localized string." );
	level.OBJ_NAME2			= register_objective( &"blackout_OBJ_NAME2" );
	*/

	// SECTION 2
	level.OBJ_GRAB_BRIGGS		= register_objective( &"BLACKOUT_GRAB_BRIGGS" );
	level.OBJ_MEAT_SHIELD		= register_objective( &"BLACKOUT_SHIELD_PUSH" );
	level.OBJ_BRIGGS_CHAIR		= register_objective( &"BLACKOUT_BRIGGS_TERMINAL" );
	level.OBJ_VIRUS				= register_objective( &"BLACKOUT_UPLOAD_VIRUS" );
	level.OBJ_BOARD_PLANE		= register_objective( &"BLACKOUT_BOARD_PLANE" );
	level.OBJ_MZ_FOLLOW_SALAZAR = register_objective( &"BLACKOUT_MENENDEZ_FOLLOW_SALAZAR" );
	level.OBJ_MENENDEZ_PLANE	= register_objective( "Get the plane to the flight deck." );
	
	// SECTION 3
	level.OBJ_SERVER	 	= maps\_objectives::register_objective( &"BLACKOUT_OBJ_SERVER" );	
	level.OBJ_FIND_MENEN 	= maps\_objectives::register_objective( &"BLACKOUT_OBJ_FIND_MENEN" );
	level.OBJ_STOP_MENEN 	= maps\_objectives::register_objective( &"BLACKOUT_OBJ_STOP_MENEN" );
	level.OBJ_CLEAR			= maps\_objectives::register_objective( &"BLACKOUT_OBJ_CLEAR" );
	level.OBJ_EVAC 			= maps\_objectives::register_objective( &"BLACKOUT_OBJ_EVAC" );
	
	level.OBJ_BREADCRUMB	= maps\_objectives::register_objective( &"" );
	level.OBJ_ENTER			= maps\_objectives::register_objective( &"" );
	level.OBJ_INTERACT  	= maps\_objectives::register_objective( &"" );
	level.OBJ_FOLLOW  		= maps\_objectives::register_objective( &"" );
	
	// Handles the updating of objectives
	level thread maps\_objectives::objectives();
}


/* ------------------------------------------------------------------------------------------
Challenges
-------------------------------------------------------------------------------------------*/

setup_challenge()
{
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::nodeath_challenge );
	self thread maps\_challenges_sp::register_challenge( "intel", ::locateintel_challenge );
	self thread maps\_challenges_sp::register_challenge( "masonroom", ::masonroom_challenge);
	
	self thread maps\_challenges_sp::register_challenge( "turretkills", ::challenge_turret_kills );
	self thread maps\_challenges_sp::register_challenge( "saveseals", ::challenge_seals );
	self thread maps\_challenges_sp::register_challenge( "electrocutions", ::challenge_electrocutions );
	self thread maps\_challenges_sp::register_challenge( "turretoneshot", ::challenge_turret_oneshot );
	self thread maps\_challenges_sp::register_challenge( "gaskills", ::challenge_gaskills );
	self thread maps\_challenges_sp::register_challenge( "brutekills", ::challenge_brutekills );
	self thread maps\_challenges_sp::register_challenge( "vtoltimer", ::vtol_challenge );
}

challenge_turret_kills( str_notify )
{
	const wpn_name = "cic_turret";
	while ( true )
	{
		level waittill( "player_performed_kill", victim, type, str_weapon );
		if ( str_weapon == wpn_name && victim.team == "axis" )
		{
			self notify( str_notify );
		}
	}
}

challenge_seals( str_notify )
{
	level endon( "seal_challenge_done" );
	
	while ( true )
	{
		level waittill( "seal_saved" );
		self notify( str_notify );
	}
}

challenge_electrocutions( str_notify )
{
	const wpn_name = "tazer_knuckles_sp";
	while ( true )
	{
		level waittill( "player_performed_kill", victim, type, str_weapon );
		if ( str_weapon == wpn_name && victim.team == "axis" )
		{
			self notify( str_notify );
		}
	}
}

challenge_turret_oneshot( str_notify )
{
	init_turret_kill_challenge( str_notify );
}

challenge_gaskills( str_notify )
{
	const wpn_name = "m32_gas_sp";
	while ( true )
	{
		level waittill( "player_performed_kill", victim, type, str_weapon );
		if ( str_weapon == wpn_name && victim.team == "axis" )
		{
			self notify( str_notify );
		}
	}
}

challenge_brutekills( str_notify )
{
	level.brute_force_ai_killed = 0;
	trigger_wait( "brute_force_computer" );
	
	while( level.brute_force_ai_killed < 4 )
	{
		wait 1;
	}
	self notify( str_notify );
}

nodeath_challenge( str_notify )
{
	level.player waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}	
}

locateintel_challenge( str_notify )
{
	level.player waittill( "mission_finished" );
	
	has_player_collected_all = collected_all();
	
	if( has_player_collected_all )
	{
		self notify( str_notify );		
	}
}

masonroom_challenge( str_notify )
{
	level waittill( "masons_personal_effects_found" );
	self notify( str_notify );
}

vtol_challenge( str_notify )
{
	level waittill( "start_vtol_timer" );
	
	n_timer = 90;
	level.b_vtol_reached = false;
	
	while( n_timer > 0 && !level.b_vtol_reached )
	{
		wait 1;
		n_timer -= 1;
	}
	
	if( level.b_vtol_reached && n_timer > 0 )
	{
		self notify( str_notify );
	}
}
