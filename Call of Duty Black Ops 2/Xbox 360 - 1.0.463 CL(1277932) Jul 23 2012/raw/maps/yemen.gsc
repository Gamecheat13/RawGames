/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_skipto;
#include maps\_camo_suit;
#include maps\_scene;
#include maps\yemen_wounded;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{		
	level.createfx_callback_thread = ::createfx_setup;
	
	// This MUST be first for CreateFX!	
	maps\yemen_fx::main();

	maps\_quadrotor::init();
	maps\_metal_storm::init();	
	
	setup_objectives();
	level thread maps\_objectives::objectives();
	
	level_precache();
	level_init_flags();
	setup_skiptos();
	
	//overrides default introscreen function
	level.custom_introscreen = ::yemen_custom_introscreen;	
	
	level thread maps\createart\yemen_art::main();
	level thread maps\_heatseekingmissile::init();
	
	maps\_load::main();
	
	setup_level();
	
	level thread maps\_drones::init();
	maps\yemen_fx::main();
	maps\yemen_amb::main();
	maps\yemen_anim::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	SetSavedDvar( "r_skyTransition", 0 );
	SetSavedDvar( "g_destructibleCutoffDistance", 1600 );	// make sure the player sees the destruction
}

on_player_connect()
{
	level.player = get_players()[0];
	self thread setup_challenge();
	
	SetSavedDvar( "wind_global_vector", "300 200 0" );	// There shouldn't be any wind on Z
    SetSavedDvar( "wind_global_low_altitude", 5000 );
    SetSavedDvar( "wind_global_hi_altitude", 10000 );
    SetSavedDvar( "wind_global_low_strength_percent", 0.7 );
    
    SetSavedDvar( "g_destructibleCutoffDistance", 1600 );
    
    load_story_stats();
}

autoexec _brute_force_perk()
{
	flag_wait( "player_has_bruteforce" );
	
	t_bruteforce = GetEnt( "use_bruteforce", "targetname" );
	set_objective( level.OBJ_BRUTEFORCE, t_bruteforce.origin, "interact" );
	
	t_bruteforce trigger_wait();
	
	set_objective( level.OBJ_BRUTEFORCE, undefined, "remove" );
	
	run_scene_and_delete( "bruteforce_perk" );
	level.player GiveWeapon( "pulwar_sword_sp" );
}

level_precache()
{
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "mp5k_sp" );
	PrecacheItem( "rpg_player_sp" );
	PrecacheItem( "fhj18_sp" );
	PrecacheItem( "m1911_sp" );
	PrecacheItem( "pulwar_sword_sp" );
	
	PreCacheShader( "fullscreen_dirt_bottom_b" );
	
	PrecacheModel( "c_yem_houthis_drone_1_a_fb" );
	PrecacheModel( "c_yem_houthis_drone_1_b_fb" );
	PrecacheModel( "c_yem_houthis_drone_1_c_fb" );
	PrecacheModel( "c_yem_houthis_drone_1_d_fb" );
	PrecacheModel( "c_yem_houthis_drone_1_e_fb" );
	PrecacheModel( "c_yem_houthis_drone_1_f_fb" );

	PrecacheModel( "c_yem_houthis_drone_2_a_fb" );
	PrecacheModel( "c_yem_houthis_drone_2_b_fb" );
	PrecacheModel( "c_yem_houthis_drone_2_c_fb" );
	PrecacheModel( "c_yem_houthis_drone_2_d_fb" );
	PrecacheModel( "c_yem_houthis_drone_2_e_fb" );
	PrecacheModel( "c_yem_houthis_drone_2_f_fb" );

	PrecacheModel( "c_yem_houthis_drone_3_a_fb" );
	PrecacheModel( "c_yem_houthis_drone_3_b_fb" );
	PrecacheModel( "c_yem_houthis_drone_3_c_fb" );
	PrecacheModel( "c_yem_houthis_drone_3_d_fb" );
	PrecacheModel( "c_yem_houthis_drone_3_e_fb" );
	PrecacheModel( "c_yem_houthis_drone_3_f_fb" );
	
	PrecacheModel( "c_yem_houthis_light_nogear" );
	PrecacheModel( "c_yem_houthis_medium_nogear" );
	PrecacheModel( "c_yem_houthis_heavy_nogear" );
	
	PrecacheModel( "p6_street_vendor_goods_table02" );
	PrecacheModel( "t6_wpn_pistol_m1911_view" );
	PrecacheModel( "t6_wpn_pistol_judge_world" );
	PrecacheModel( "t6_wpn_ar_an94_world" );
	PrecacheModel( "iw_proj_sidewinder_missile_x2" );
	PrecacheModel( "t6_wpn_pistol_fiveseven_prop" );
	PrecacheModel( "t6_wpn_launch_fhj18_world" );
	PrecacheModel( "fxanim_war_sing_rappel_rope_01_mod" );
	PrecacheModel( "p6_anim_handcuffs" );
	PrecacheModel( "p6_street_vendor_cover_cart_anim" );
	
	PrecacheModel( "t6_wpn_jaws_of_life_prop" );
	PrecacheModel( "t6_wpn_pulwar_sword_view" );
	
	PrecacheRumble( "heartbeat" );
	PreCacheRumble( "heartbeat_low" );
	PrecacheRumble( "crash_heli_rumble" );
	
	//-- need to precache mason
	PrecacheModel( "c_usa_cia_masonjr_viewhands" );
	PrecacheModel( "c_usa_cia_masonjr_viewbody" );
	
	// Bink movies
	PrecacheString( &"yemen_men_ally" );
	PrecacheString( &"yemen_drone_cam" );
	PrecacheString( &"yemen_kill_pilot" );
	PreCacheString( &"rewind" );
	
	maps\_fire_direction::precache();
	maps\_camo_suit::precache();
}


level_init_flags()
{
	maps\yemen_speech::init_flags();
	maps\yemen_market::init_flags();
	maps\yemen_terrorist_hunt::init_flags();
	maps\yemen_metal_storms::init_flags();
	maps\yemen_morals::init_flags();
	maps\yemen_morals_rail::init_flags();
	maps\yemen_drone_control::init_flags();
	maps\yemen_hijacked::init_flags();
	maps\yemen_capture::init_flags();
}


setup_level()
{
	level.spawn_manager_max_frame_spawn = 1;
	level.spawn_manager_max_ai = 23;
	
	level.alerted_terrorists = [];
	
	// Set threatbias for the first few sections, for the teamswitch system
	maps\yemen_utility::teamswitch_threatbias_setup();
	
	// Set up for all the patrollers
	maps\yemen_utility::temp_vtol_stop_and_rappel();
	
	// spawn functions
	add_spawn_function_veh_by_type( "heli_quadrotor", ::watch_for_turret_kill );
	level thread maps\yemen_speech::init_spawn_funcs();
	level thread maps\yemen_market::init_spawn_funcs();
	level thread maps\yemen_morals_rail::init_spawn_funcs();
	level thread maps\yemen_drone_control::init_spawn_funcs();
	level thread maps\yemen_hijacked::init_spawn_funcs();
	
	// Affix collision to doors where necessary.
	maps\yemen_speech::init_doors();
}

load_story_stats()
{
	dead_stat = level.player get_story_stat( "DEFALCO_DEAD_IN_KARMA" );
	
	//FIXME: Once Defalco's alive animations are in, we will load the stat.
	// For now, default to dead.
	level.is_defalco_alive = false; // (dead_stat == 0);
	
	level.is_farid_alive = true;
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
setup_skiptos()
{
	add_skipto( "intro", 						maps\yemen_speech::skipto_intro, 								"Intro", 					maps\yemen_speech::intro_main );
	add_skipto( "speech", 						maps\yemen_speech::skipto_speech, 								"Speech", 					maps\yemen_speech::speech_main );
	add_skipto( "market", 						maps\yemen_market::skipto_market, 								"Market", 					maps\yemen_market::main );
	add_skipto( "terrorist_hunt", 				maps\yemen_terrorist_hunt::skipto_terrorist_hunt, 				"Terrorist_Hunt",			maps\yemen_terrorist_hunt::main );
	add_skipto( "metal_storms", 				maps\yemen_metal_storms::skipto_metal_storms, 					"Metal_Storms", 			maps\yemen_metal_storms::main );
	add_skipto( "morals", 						maps\yemen_morals::skipto_morals, 								"Morals", 					maps\yemen_morals::main );
	
	add_skipto( "morals_rail", 					maps\yemen_morals_rail::skipto_morals_rail, 					"Morals_Rail", 				maps\yemen_morals_rail::main );
	add_skipto( "morals_rail_skip", 			maps\yemen_morals_rail::skipto_morals_rail_skip, 				"Morals_Rail_Skip", 		maps\yemen_morals_rail::main );
	add_skipto( "morals_rail_menendez", 		maps\yemen_morals_rail::skipto_morals_rail_menendez,			"Morals_Rail_Menendez",		maps\yemen_morals_rail::main );
	
	add_skipto( "drone_control", 				maps\yemen_drone_control::skipto_drone_control, 				"Drone_Control",			maps\yemen_drone_control::main );
	
	add_skipto( "hijacked", 					maps\yemen_hijacked::skipto_hijacked, 							"Hijacked", 				maps\yemen_hijacked::main );
	add_skipto( "hijacked_bridge", 				maps\yemen_hijacked::skipto_hijacked_bridge, 					"Hijacked_Bridge", 			maps\yemen_hijacked::main );
	add_skipto( "hijacked_menendez", 			maps\yemen_hijacked::skipto_hijacked_menendez, 					"Hijacked_Menendez", 		maps\yemen_hijacked::main );
		
	add_skipto( "capture",						maps\yemen_capture::skipto_capture, 							"Capture", 					maps\yemen_capture::main );
	
	add_skipto( "dev_drone_crash", maps\yemen_market::skipto_drone_crash, "Capture" );
	add_skipto( "dev_outro_vtol", maps\yemen_capture::skipto_outro_vtol, "Capture VTOL" );
	
	default_skipto( "intro" );
	
	set_skipto_cleanup_func( ::skipto_setup );
}



/* ------------------------------------------------------------------------------------------
Objectives
-------------------------------------------------------------------------------------------*/
setup_objectives()
{
	level.OBJ_SPEECH = register_objective( &"YEMEN_OBJ_SPEECH" );
	level.OBJ_MARKET_MEET_MENENDEZ = register_objective( &"YEMEN_OBJ_MEET_MENENDEZ" );
	
	level.OBJ_INTERACT = register_objective( "" );
	level.OBJ_BRUTEFORCE = register_objective( "" );
	
	level.OBJ_MORALS_RAIL = register_objective( &"YEMEN_OBJ_LZ" );
	
	//Drone control
	level.OBJ_DRONE_CONTROL_BRIDGE = register_objective( &"YEMEN_OBJ_BRIDGE" );
	
	//Capture
	level.OBJ_CAPTURE_MENENDEZ = register_objective( &"YEMEN_OBJ_CAPTURE_MENENDEZ" );
	
	level thread objectives_morals();
	level thread objectives_morals_rail();
	level thread objectives_morals_rail_skipped();
	level thread objectives_drone_control();
	level thread objectives_hijacked();
	level thread objectives_capture();
}

meet_menendez_objectives()
{
	objective_breadcrumb( level.OBJ_MARKET_MEET_MENENDEZ, "rockethall_objective_trigger" );
	
	s_metal_storms_meet = getstruct( "obj_metalstorm_meet_manendez", "targetname" );
	set_objective( level.OBJ_MARKET_MEET_MENENDEZ, s_metal_storms_meet, "breadcrumb" );
}

objectives_morals()
{
	trigger_wait( "start_morals" );
	set_objective( level.OBJ_MARKET_MEET_MENENDEZ, undefined, "done" );
}

objectives_morals_rail()
{
	flag_wait( "morals_rail_start" );
	set_objective( level.OBJ_MORALS_RAIL );
	
	flag_wait( "morals_rail_done" );
	s_obj_gauntlet = GetStruct( "obj_drone_control" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "breadcrumb" );
	set_objective( level.OBJ_MORALS_RAIL, undefined, "done" );
}

objectives_morals_rail_skipped()
{
	flag_wait( "morals_rail_done" );
	s_obj_gauntlet = GetStruct( "obj_drone_control" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "breadcrumb" );
}

objectives_drone_control()
{
	flag_wait( "drone_control_guantlet_started" );
	s_obj_gauntlet = GetStruct( "obj_drone_control_guantlet" );
	s_obj_alley = GetStruct( "obj_drone_control" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_alley, "remove" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "breadcrumb" );
	
	flag_wait( "drone_control_farmhouse_started" );
	s_obj_bridge = GetStruct( "obj_drone_control_bridge" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_gauntlet, "remove" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_bridge, "breadcrumb" );
}

objectives_hijacked()
{
}

objectives_capture()
{
	flag_wait( "obj_capture_sitrep" );
	t_sit_rep_trig = GetEnt( "trig_capture_sitrep", "targetname" );
	s_obj_bridge = GetStruct( "obj_drone_control_bridge" );
	set_objective( level.OBJ_DRONE_CONTROL_BRIDGE, s_obj_bridge, "remove" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, t_sit_rep_trig, "breadcrumb" );
	
	flag_wait( "obj_capture_menendez" );
	s_capture_spot = GetStruct( "menendez_surrender", "targetname" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, t_sit_rep_trig, "remove" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_capture_spot, "breadcrumb" );
}

/* ------------------------------------------------------------------------------------------
Challenges
-------------------------------------------------------------------------------------------*/

setup_challenge()
{
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::nodeath_challenge );
	self thread maps\_challenges_sp::register_challenge( "locateintel", ::locateintel_challenge );
	self thread maps\_challenges_sp::register_challenge( "camomelee", ::camomelee_challenge );
	self thread maps\_challenges_sp::register_challenge( "swordkills", ::swordkills_challenge );
	self thread maps\_challenges_sp::register_challenge( "turretqrkills", ::turretqrkills_challenge );
	self thread maps\_challenges_sp::register_challenge( "turretkills", ::turretkills_challenge );
	self thread maps\_challenges_sp::register_challenge( "usenodrone", maps\yemen_drone_control::usenodrone_challenge );
	self thread maps\_challenges_sp::register_challenge( "undercover", ::undercover_challenge );
	self thread maps\_challenges_sp::register_challenge( "killdrones", ::killdrones_challenge );
	self thread maps\_challenges_sp::register_challenge( "pickingsides", ::pickingsides_challenge );
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

camomelee_challenge( str_notify )
{
	self waittill( "camo_suit_equipped" );
	
	while ( true )
	{
		self waittill( "melee_kill" );
		if ( self ent_flag( "camo_suit_on" ) )
		{
			self notify( str_notify );
		}
	}
}

swordkills_challenge( str_notify )
{
	while ( true )
	{
		self waittill( "sword_kill" );
		self notify( str_notify );
	}
}

// spawn function for qr drones
watch_for_turret_kill()
{
	if ( flag( "morals_start" ) )
	{
		return;
	}
	
	self waittill( "death", attacker, type, weapon );
	if ( IsPlayer( attacker ) && ( weapon == "auto_gun_turret_sp" ) )
	{
		level.player notify( "turret_kill" );
	}
}

turretqrkills_challenge( str_notify )
{
	flag_wait( "metal_storms_start" );
	
	add_spawn_function_veh_by_type( "heli_quadrotor", maps\yemen_metal_storms::turretqrkills_death_listener, str_notify );
}

turretkills_challenge( str_notify )
{
	while ( true )
	{
		self waittill( "turret_kill" );
		self notify( str_notify );
	}
}

undercover_challenge( str_notify )
{
	
}

killdrones_challenge( str_notify )
{
	
}

pickingsides_challenge( str_notify )
{
	level endon( "player_killed_yemeni" );
	level waittill( "nextmission" );
	self notify( str_notify );
}

/* ------------------------------------------------------------------------------------------
Custom Introscreen
-------------------------------------------------------------------------------------------*/

yemen_custom_introscreen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 

	flag_wait( "show_introscreen_title" );

	const pausetime = 0.75;
	const totaltime = 14.25;
	time_to_redact = ( 0.525 * totaltime);
	rubout_time = 1;
	color = (1,1,1);

	const delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	const delay_between_redacts_max = 500;

	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

	// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		

	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	wait (totaltime - totalpausetime);

	//default wait time
	wait 2.5;

	level notify("introscreen_done");
	
	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 
}
