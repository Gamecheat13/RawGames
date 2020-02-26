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
#insert raw\maps\karma.gsh;

main()
{
	level.createfx_callback_thread = ::createfx_setup;

	// This MUST be first for CreateFX!
	maps\karma_fx::main();
	maps\karma_anim::main();
	maps\_metal_storm::init();

	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();
	
	maps\_load::main();

	init_spawn_funcs();	// This needs to be after _load so _vehicles::init_vehicles runs first (needed for vehicle spawn funcs)
	
	maps\karma_amb::main();
	maps\_heatseekingmissile::init();
	
	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\_drones::init();
	level thread maps\karma_civilians::civ_init();
	maps\_civilians::init_civilians();
	level thread maps\createart\karma_art::main();
	
	// Remove clips used to make connect paths behave
	a_m_clips = GetEntArray( "compile_paths_clips", "targetname" );
	foreach( m_clip in a_m_clips )
	{
		m_clip Delete();
	}
}

on_player_connect()
{
	level.player = get_players()[0];	

	level.player setup_challenges();
	
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_flyin_desat" );
	run_thread_on_targetname( "vision_trigger", ::vision_set_trigger_think );
}


//
// Put all precache calls here
level_precache()
{
	PrecacheItem( "noweapon_sp" );
	PrecacheItem( "noweapon_sp_arm_raise" );

	PrecacheItem( "flash_grenade_sp" );
	PrecacheItem( "concussion_grenade_sp" );

	PrecacheModel( "test_p_anim_specialty_lockbreaker_device" );
	PrecacheModel( "test_p_anim_specialty_lockbreaker_padlock" );
	PrecacheModel( "test_p_anim_specialty_trespasser_card_swipe" );
	PrecacheModel( "t6_wpn_hacking_dongle_prop" );

	// ShellShock
	PrecacheShellshock( "concussion_grenade_mp" );
	
	// Bink movie
	PrecacheString( &"eye_v5" );
	PrecacheString( &"hud_spiderbot_eyescan" );
	PrecacheString( &"hud_spiderbot_eyescan_end" );
	
	// SECTION 1
	PrecacheModel( "p6_spiderbot_case_anim" );
	PrecacheModel( "c_mul_jinan_guard_bscatter_fb");
	PrecacheModel( "c_mul_jinan_demoworker_bscatter_fb" );
	PrecacheModel( "p6_anim_duffle_bag_karma" );
	PrecacheModel( "p6_anim_metal_briefcase" );
	PrecacheModel( "veh_t6_drone_asd_attch" );
	PrecacheModel( "veh_t6_drone_asd_attch_torso" );
	PrecacheModel( "veh_t6_drone_asd_angry" );
	PrecacheModel( "t6_wpn_pistol_fiveseven_world_detect" );
	PrecacheModel( "p6_3d_gizmo" );
	PrecacheModel( "t6_wpn_grenade_flash_prop_view" );
	PrecacheModel( "t6_wpn_knife_melee" );

	// SECTION 2
	// Bar props
	PrecacheModel( "hjk_vodka_glass_lrg" );
	PrecacheModel( "p6_wine_glass" );
	PrecacheModel( "p6_martini_glass" );
	PrecacheModel( "p6_bar_beer_glass" );
	PrecacheModel( "p6_bar_shaker_no_lid" );
	PrecacheModel( "p6_vodka_bottle" );
	
	PrecacheModel( "c_usa_unioninsp_harper_cin_fb" );
	PrecacheModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	
	// AR
	//PrecacheString( &"KARMA_ARGUS_HELI_VTOL" );
	//PrecacheString( &"KARMA_ARGUS_AL_JINAN" );
	//PrecacheString( &"KARMA_ARGUS_SCANNER" );
	//PrecacheString( &"KARMA_ARGUS_HELI_HIP" );
	//PrecacheString( &"KARMA_ARGUS_METAL_STORM" );
	
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


	// SECTION 1
	maps\karma_arrival::init_flags();
	maps\karma_checkin::init_flags();
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
	maps\karma_arrival::init_spawn_funcs();
	maps\karma_checkin::init_spawn_funcs();
	maps\karma_dropdown::init_spawn_funcs();
	maps\karma_spiderbot::init_spawn_funcs();
	
	// SECTION 2
	maps\karma_crc::init_spawn_funcs();
	maps\karma_construction::init_spawn_funcs();
	maps\karma_outer_solar::init_spawn_funcs();
	maps\karma_inner_solar::init_spawn_funcs();
	
	array_thread( GetSpawnerTeamArray("axis"), ::add_spawn_function, ::turn_on_enemy_highlight);
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	// SECTION 1
	add_skipto( "e1_arrival", 		maps\karma_arrival::skipto_arrival,
				"ARRIVAL",  		maps\karma_arrival::arrival );
	add_skipto( "e2_checkin", 		maps\karma_checkin::skipto_checkin,
				"CHECKIN",  		maps\karma_checkin::checkin );
	add_skipto( "e3_tower_lift", 	maps\karma_checkin::skipto_tower_lift,
				"TOWER LIFT",  		maps\karma_checkin::tower_lift );

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
	add_skipto( "e7_exit_club",		::skipto_karma_2 );
	add_skipto( "e8_enter_mall",	::skipto_karma_2 );
	add_skipto( "e9_little_bird",	::skipto_karma_2 );
	add_skipto( "e10_the_end",		::skipto_karma_2 );

	default_skipto( "e1_arrival" );
	
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
	else if ( is_after_skipto( "e3_tower_lift" ) )
	{
		load_gump( "karma_gump_construction" );
	}
	else
	{
		load_gump( "karma_gump_checkin" );
	}
}


//
// sets flags for the skipto's and exits out at appropriate skipto point.  
//	All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	skipto = level.skipto_point;

	// Change the skybox to the normal mode - we need this in case people jump around using skiptos as the variable doesn't reset
	SetSavedDvar( "r_skyTransition", 0 );

	load_gumps_karma();
	
    //	SECTION 1
	level.player thread weapon_controller();
	level.player thread check_civ_status();
	flag_set( "holster_weapons" );
	flag_set( "player_among_civilians" );
	
	if ( skipto == "e1_arrival" )
		return;

	flag_set( "start_tarmac" );
	flag_set( "glasses_activated" );
	flag_set( "deplaned" );

	if ( skipto == "e2_checkin" )
		return;
	
	maps\_glasses::play_bootup();

//	thread add_argus_info();
	thread skip_objective( level.OBJ_SECURITY );

	t_obj = GetEnt( "trig_tower_lift", "targetname" );
	thread set_objective( level.OBJ_FIND_CRC, t_obj );

	if ( skipto == "e3_tower_lift" )
		return;
	
//	flag_set( "elevator_reached_lobby" );
//
//	if ( skipto == "e3_lobby" )
//		return;

	flag_clear( "player_among_civilians" );

	if ( skipto == "e3_dropdown" )
		return;
	
	thread set_objective( level.OBJ_FIND_CRC, undefined, "done" );
	flag_set( "spiderbot_bootup_done" );
	
	if ( skipto == "e4_spiderbot" )
		return;

	thread set_objective( level.OBJ_ENTER_CRC );
	flag_clear( "holster_weapons" );
	
	if ( skipto == "e4_gulliver" )
		return;
	
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

	thread skip_objective( level.OBJ_ID_KARMA );

	if ( skipto == "e5_construction" )
		return;
	
//	if ( skipto == "e5_5_elevator3" )
//		return;

	flag_set( "holster_weapons" );
	flag_set( "player_among_civilians" );
	
	if ( skipto == "e6_outer_solar" )
		return;	

	flag_set( "club_door_closed" );
	flag_set( "harper_pip_done" );

	// Change the skybox to the alternate mode
	SetSavedDvar( "r_skyTransition", 1 );

	if ( skipto == "e6_inner_solar" )
		return;
	
	flag_set( "salazar_start_overwatch" );
	flag_set( "stop_club_fx" );
	flag_set( "run_to_bar" );
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
		level.player AllowProne( false );
	
		flag_wait( "player_act_normally" );

		flag_clear( "player_among_civilians" );
		level.player AllowJump( true );
		level.player AllowSprint( true );
		level.player AllowProne( true );
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

	// Make sure the player doesn't use the future grenade weapon
	//	This will need to be fixed by UI to disallow it
	str_offhand = self GetCurrentOffhand();
	if ( str_offhand == "frag_grenade_future_sp" )
	{
		self TakeWeapon( str_offhand );
		self GiveWeapon( "frag_grenade_sp" );
	}
	
	while (1)
	{
		// Put weapons away, arm yourself with fake hands
		flag_wait( "holster_weapons" );

		flag_clear( "draw_weapons" );
		self DisableWeapons();
		
		//Wait for lower animation to finish
		wait 2.0;
		
		self thread take_and_giveback_weapons( "draw_weapons" );
		self GiveWeapon( "noweapon_sp" );
		self SwitchToWeapon( "noweapon_sp" );
		self HideViewModel();
		self AllowAds( false );
		SetSavedDvar( "cg_drawCrosshair", 0 );
		LUINotifyEvent( &"hud_shrink_ammo" );
		
		// Draw your weapons
		flag_wait( "draw_weapons" );

		flag_clear( "holster_weapons" );
		self TakeWeapon( "noweapon_sp" );
		self notify( "draw_weapons" );
		self ShowViewModel();
		self AllowAds( true );
		SetSavedDvar( "cg_drawCrosshair", 1 );
		LUINotifyEvent( &"hud_expand_ammo" );
		self EnableWeapons();
	}
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//-----------------------------------------------------------------------------------------------
setup_challenges()
{
	// Karma 1 & 2
	self thread maps\_challenges_sp::register_challenge( "specialvisionkills", ::special_vision_kills_challenge );
	self thread maps\_challenges_sp::register_challenge( "hurtciv", ::no_killing_civ );
//	self thread maps\_challenges_sp::register_challenge( "nodeath", ::karma_no_death_challenge );
//	self thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	
	// Karma 1
	self thread maps\_challenges_sp::register_challenge( "retrievespiderbot", ::retrieve_bot_challenge );
	self thread maps\_challenges_sp::register_challenge( "fastspiderbotcomplete", ::fast_complete_spider_bot );
	self thread maps\_challenges_sp::register_challenge( "clubspeedkill", ::club_speed_kill_challenge );

	// Karma 2
//	self thread maps\_challenges_sp::register_challenge( "killrappellingenemies", ::rappel_kills_challenge );
//	self thread maps\_challenges_sp::register_challenge( "destroyhelicopters", ::kill_helicopters_challenge );
//	self thread maps\_challenges_sp::register_challenge( "asdalive", ::keep_asd_alive_challenge );
}


// 
//	Add argus info for our glasses HUD
//		Helis are handled separately in karma_arrival::setup_vtol
add_argus_info()
{
	player = GetPlayers()[0];
	
	// Generic Argus points
//	a_info = GetStructArray( "argus_info", "targetname" );
//	foreach( s_info in a_info )
//	{
//		Assert( IsDefined( s_info.script_string ), "No script_string specified for argus_info @ ( "+s_info.origin+" )" );
//		switch( s_info.script_string )
//		{
//			case "al_jinan":
//				player maps\_ar::add_ar_target( undefined, &"KARMA_ARGUS_AL_JINAN", 1200, 800, s_info.origin );
//				break;
//				
//			case "scanner":
//				player maps\_ar::add_ar_target( undefined, &"KARMA_ARGUS_SCANNER", 900, 400, s_info.origin );
//				break;
//				
//		}
//	}
//	
//	// Metal Storm vehicles
//	a_m_metal_storm = GetEntArray( "metal_storm", "targetname" );
//	foreach( m_metal_storm in a_m_metal_storm )
//	{
//		player maps\_ar::add_ar_target( m_metal_storm, &"KARMA_ARGUS_METAL_STORM", 900, 400 );
//	}
	
}