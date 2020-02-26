#include maps\_utility;
#include common_scripts\utility;
#include maps\war_room_util;
#include maps\frontend_util;

#insert raw\common_scripts\utility.gsh;

#define CLIENT_FLAG_FROSTED_GLASS	11
#define CLIENT_FLAG_CLOCK			12
#define CLIENT_FLAG_MAP_MONITOR		13

main()
{	
	//This MUST be first for CreateFX!
	maps\frontend_fx::main();

	frontend_precache();
	
	maps\_load::main();
	maps\frontend_amb::main();
	maps\frontend_anim::main();
	maps\_patrol::patrol_init();

	level thread maps\createart\frontend_art::main();
	
	frontend_init_common();
	
	frontend_flag_init();
	level thread level_player_init();
	
	setup_objectives();
	
	wait_for_first_player();
	
	screen_fade_out( 0 );
	
	frontend_do_save();
	
	level thread frontend_run_scene();
	level thread frontend_watch_resume();
	
	/#
		level thread randomize_war_map();
	#/
}

setup_objectives()
{
	level.OBJ_WAR_ROOM = register_objective( &"FRONTEND_REPORT_TO_WAR_ROOM" );
	level thread maps\_objectives::objectives();
}

frontend_flag_init()
{
	flag_init( "lockout_screen_passed" );
	flag_init( "bootup_sequence_done_first_time" );
	flag_init( "lockout_screen_skipped" );
	flag_init( "lockout_screen_skipped_freeroam"  );
	flag_init( "glasses_toggling_enabled" );
	flag_init( "strikeforce_stats_loaded" );
	flag_init( "frontend_scene_ready" );
}

frontend_precache()
{
	PrecacheShader( "logo_cod2" );
	PreCacheShader("cinematic");

	PreCacheModel("p6_sunglasses");
	
	PreCacheModel("bo2_frontend_menu_char_sp");
	PreCacheModel("bo2_frontend_menu_char_mp");
	PreCacheModel("bo2_frontend_menu_char_zm");
	PreCacheModel("bo2_frontend_menu_char_box");

	//ASSAULT RIFLES
	PreCacheModel("t6_wpn_ar_xm8_world");
	PreCacheModel("t6_wpn_ar_type95_world");
	PreCacheModel("t5_weapon_M16A1_world");
	PreCacheModel("t6_wpn_ar_an94_world");
	PreCacheModel("t6_wpn_ar_scarh_world");
	PreCacheModel("t6_wpn_ar_saritch_world");
	PreCacheModel("t6_wpn_ar_rx4_world");
	PreCacheModel("t6_wpn_ar_tavor_world");
	PreCacheModel("t6_wpn_ar_sig556_world");
	PreCacheModel("t6_wpn_ar_m4_world");
	PreCacheModel("t6_wpn_ar_ak47_world");
	PreCacheModel("t5_weapon_fal_world");
	PreCacheModel("t5_weapon_galil_world");
	PrecacheModel( "c_usa_cia_frnd_viewbody_vson" );
	PrecacheModel( "c_usa_cia_masonjr_viewbody_vson_ui3d" );
	PrecacheModel( "c_usa_cia_frnd_viewbody_vsoff" );

	PreCacheString( &"frontend_screen" );
	PreCacheString( &"toggle_glasses" );
	PreCacheString( &"toggle_secret" );
	PreCacheString( &"show_track_info" );
	PreCacheString( &"hide_track_info" );
	PreCacheString( &"FRONT_END_MAIN_INFO" );
	PreCacheString( &"start_credits" );
	PreCacheString( &"stop_credits" );
	PreCacheString( &"frontend_restore" );
	PreCacheString( &"toggle_strikeforce" );
	PreCacheString( &"hide_freeroammenu" );
	PreCacheString( &"add_strikeforcemission");
	
	
	// Necessary for communicating with LUI
	PreCacheMenu( "lockout" );
	PreCacheMenu( "menu_close" );
	PreCacheMenu( "vcs_action" );
	PreCacheMenu( "music_action" );
	PreCacheMenu( "campaign_state" );
	PreCacheMenu( "strikeforce_action" );
}

level_player_init()
{	
	level thread watch_for_lockout_screen();
	
	wait_for_first_player();
	
	on_player_connect();
	
	wait_network_frame();

	//-- Short delay to get player in position
	wait_network_frame();
	
	if ( frontend_just_finished_rts() )
	{
		level thread turn_on_glasses( false );
	}
	else
	{
		level thread turn_on_glasses( true );
	}
	
	level.player thread listen_for_music_track_change();
	level.player thread listen_for_campaign_state_change();
	
	//level delay_thread( 2.0, ::turn_on_glasses );
	
	VisionSetNaked( "sp_blackout_bridge", 0.0 );
}


// Initialization for the 
frontend_init_common()
{
	// Allows the HUD to show during scenes.
	get_level_era();
	
	holo_table_system_init();
	
	level.e_player_align = GetEnt( "player_align_node", "targetname" );

	level.m_rts_names = [];
	level.m_rts_names["so_rts_mp_dockside"]		= &"FRONTEND_SF_SINGAPORE";
	level.m_rts_names["so_rts_mp_carrier"]		= &"FRONTEND_SF_CARRIER";
	level.m_rts_names["so_rts_afghanistan"]		= &"FRONTEND_SF_AFGHANISTAN";
	level.m_rts_names["so_rts_mp_drone"]		= &"FRONTEND_SF_DRONE";
	level.m_rts_names["so_rts_mp_socotra"]		= &"FRONTEND_SF_DRONE";
	level.m_rts_names["so_rts_mp_overflow"]		= &"FRONTEND_SF_OVERFLOW";
	
	level.m_rts_scene = [];
	level.m_rts_scene["so_rts_mp_dockside"]		= maps\frontend_sf_a::scene_dockside_briefing;
	level.m_rts_scene["so_rts_mp_carrier"]		= maps\frontend_sf_a::scene_dockside_briefing;
	level.m_rts_scene["so_rts_afghanistan"]		= maps\frontend_sf_a::scene_dockside_briefing;
	level.m_rts_scene["so_rts_mp_drone"]		= maps\frontend_sf_a::scene_dockside_briefing;
	level.m_rts_scene["so_rts_mp_socotra"]		= maps\frontend_sf_a::scene_dockside_briefing;
	level.m_rts_scene["so_rts_mp_overflow"]		= maps\frontend_sf_a::scene_dockside_briefing;
	
	level.m_rts_city_tag = [];
	level.m_rts_city_tag["so_rts_mp_dockside"] = "tag_fx_keppel";
	level.m_rts_city_tag["so_rts_mp_carrier"] = "tag_fx_carrier";
	level.m_rts_city_tag["so_rts_afghanistan"] = "tag_fx_kabul";
	level.m_rts_city_tag["so_rts_mp_drone"] = "tag_fx_pyongyang";
	level.m_rts_city_tag["so_rts_mp_socotra"] = "tag_fx_socotra";
	level.m_rts_city_tag["so_rts_mp_overflow"] = "tag_fx_pakistan";
	
	// Disputed territories associated with levels.
	level.m_rts_territory = [];
	level.m_rts_territory["so_rts_mp_dockside"]	= "iran";
	level.m_rts_territory["so_rts_mp_carrier"]	= "india";
	level.m_rts_territory["so_rts_afghanistan"]	= "afghanistan";
	level.m_rts_territory["so_rts_mp_drone"]	= "north_korea";
	
	// Objectives.
	add_global_spawn_function( "axis", ::no_grenade_bag_drop );
	
	trigger_off( "table_interact_trigger" );
	
	table_trig = GetEnt( "table_interact_trigger", "targetname" );
	table_trig SetHintString( &"FRONTEND_USE_STRIKEFORCE" );
	
	level.m_drone_collision = GetEntArray( "drone_collision", "targetname" );
	
	level thread frontend_init_shaders();
	
	globe = build_globe();
	float_pos = GetEnt( "holo_table_floating", "targetname" );
	globe.origin = float_pos.origin;
}

frontend_init_shaders()
{
	// Wait for the player so we know the client script is running.
	wait_for_first_player();
	
	clock_list = GetEntArray( "world_clock", "targetname" );
	foreach( clock in clock_list )
	{
		clock IgnoreCheapEntityFlag( true );
		clock SetClientFlag( CLIENT_FLAG_CLOCK );
	}
	
	monitor_list = GetEntArray( "world_map", "targetname" );
	foreach( monitor in monitor_list )
	{
		monitor IgnoreCheapEntityFlag( true );

		monitor SetClientFlag( CLIENT_FLAG_MAP_MONITOR );

		monitor setscale( 2.0 );
	}
}

war_room_frost_glass( frosting_on )
{
	glass_list = GetEntArray( "frosted_glass", "targetname" );
	
	glass_list = get_array_of_closest( level.player.origin, glass_list );
	
	foreach ( glass in glass_list )
	{
		if ( frosting_on )
		{
			glass SetClientFlag( CLIENT_FLAG_FROSTED_GLASS );  
		} else {
			glass ClearClientFlag( CLIENT_FLAG_FROSTED_GLASS );
		}
		
		wait(0.25);
	}
}
	
