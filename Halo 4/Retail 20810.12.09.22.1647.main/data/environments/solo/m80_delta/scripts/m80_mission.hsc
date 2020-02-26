//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					m80_delta
//	Insertion Points:	lich ride	(or ilr)
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GLOBALS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// ICS
global object g_ics_player = NONE;
global object p_player_puppet = NONE;
global object p_button_puppet = NONE;

/*
dump_current_zone_set_objects
PreparingToSwitchZoneSet() 
*/

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** START-UP ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// functions
script startup mission_startup()
	//dprint( "::: M80 - DELTA :::" );

	// set player/human allegiance
	ai_allegiance( player, human );
	//ai_allegiance( human, player );
	
	// kill rampancy
	hud_rampancy_players_set( 0.0 );

	if( b_debug ) then
		debug_game_save = TRUE;
	else
		debug_game_save = FALSE;
	end

	if ( b_game_emulate or (not editor_mode()) ) then
		fade_out( 0, 0, 0, 0 );
	end

	if ( b_game_emulate or (not editor_mode()) ) then
	
		// in editor mode make sure the players are there to start
		if ( editor_mode() ) then
			f_insertion_playerwait();
		end

		// run start function
		start();

		sleep_until( b_mission_started, 1 );
		fade_in( 0, 0, 0, (0.50 * 30) );

	end

	// wait for the game to start
	sleep_until( b_mission_started, 1 );

	// coop triggers
	wake( f_mission_coop_teleport );
	
	// setup default ai garbage values
	ai_garbage_distance_min_default_set( 10.0 );
	ai_garbage_see_degrees_default_set( 110.0 );

	// enable zone triggers
	// --- TO HORSESHOE
	//zoneset_trigger_prepare_enable( "begin_zone_set:to_horseshoe", S_ZONESET_TO_HORSESHOE, TRUE, TRUE );
	//zoneset_trigger_load_enable( "zone_set:to_horseshoe", S_ZONESET_TO_HORSESHOE, TRUE, TRUE );

	// --- LAB
	//zoneset_trigger_prepare_enable( "begin_zone_set:lab", S_ZONESET_TO_HORSESHOE, TRUE, TRUE );
	//zoneset_trigger_load_enable( "zone_set:lab", S_ZONESET_TO_HORSESHOE, TRUE, TRUE );

	// --- AIRLOCK TWO
	zoneset_trigger_load_enable( "zone_set:airlock_two", S_ZONESET_AIRLOCK_TWO, TRUE, TRUE );

	// --- COMPOSER REMOVAL
	//zoneset_trigger_load_enable( "zone_set:composer_removal", S_ZONESET_COMPOSER_REMOVAL, FALSE, TRUE );

	// display difficulty
	print_difficulty(); 
	
end

script dormant f_mission_coop_teleport()
	//dprint( "::: f_mission_coop_teleport :::" );

	// set zone set delays to give teleport a frame to do it's thing
	zoneset_prepare_delay( 1 );
	zoneset_load_delay( 1 );

	// setup teleport sequence
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_horseshoe_out, flg_coop_teleport_to_horseshoe, FALSE, S_ZONESET_TO_HORSESHOE );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_horseshoe_in, flg_coop_teleport_horseshoe, TRUE, S_ZONESET_HORSESHOE );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_lab_in, flg_coop_teleport_to_lab, TRUE, S_ZONESET_TO_LAB );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lab_out, flg_coop_teleport_lab, FALSE, S_ZONESET_LAB );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lab_exit_in, flg_coop_teleport_lab_exit, TRUE, S_ZONESET_LAB_EXIT );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_atrium_hub_in, flg_coop_teleport_atrium_hub, TRUE, S_ZONESET_ATRIUM_HUB );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_airlock_one_out, flg_coop_teleport_to_airlock_one, FALSE, S_ZONESET_TO_AIRLOCK_ONE );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_airlock_one_b_in, flg_coop_teleport_to_airlock_one_b, TRUE, S_ZONESET_TO_AIRLOCK_ONE_B );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_airlock_one_out, flg_coop_teleport_airlock_one, FALSE, S_ZONESET_AIRLOCK_ONE );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_airlock_two_out, flg_coop_teleport_to_airlock_two, FALSE, S_ZONESET_TO_AIRLOCK_TWO );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_airlock_two_out, flg_coop_teleport_airlock_two, FALSE, S_ZONESET_AIRLOCK_TWO );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_to_lookout_out, flg_coop_teleport_to_lookout, FALSE, S_ZONESET_TO_LOOKOUT );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lookout_out, flg_coop_teleport_lookout, FALSE, S_ZONESET_LOOKOUT );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lookout_exit_out, flg_coop_teleport_lookout_exit, FALSE, S_ZONESET_LOOKOUT_EXIT );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lookout_hallways_a_out, flg_coop_teleport_lookout_hallways_a, FALSE, S_ZONESET_LOOKOUT_HALLWAYS_A );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_lookout_hallways_b_out, flg_coop_teleport_lookout_hallways_b, FALSE, S_ZONESET_LOOKOUT_HALLWAYS_B );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_atrium_returning_out, flg_coop_teleport_atrium_returning, FALSE, S_ZONESET_ATRIUM_RETURNING );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_atrium_lookout_out, flg_coop_teleport_atrium_lookout, FALSE, S_ZONESET_ATRIUM_LOOKOUT );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_atrium_damaged_in, flg_coop_teleport_atrium_damaged, TRUE, S_ZONESET_ATRIUM_DAMAGED );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_mechroom_return_in, flg_coop_teleport_mechroom_return, TRUE, S_ZONESET_MECHROOM_RETURN );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_composer_removal_enter_out, flg_coop_teleport_composer_removal_enter, FALSE, S_ZONESET_COMPOSER_REMOVAL_ENTER );
	volume_teleport_players_zone_set_sequence( tv_coop_teleport_composer_removal_out, flg_coop_teleport_composer_removal, FALSE, S_ZONESET_COMPOSER_REMOVAL );

end


// ==========================================================================================================================================================
// *** BUTTONS ***
// ==========================================================================================================================================================
script static void f_button_user_active_obj( object obj_activator, boolean b_active )
	f_button_user_active( ai_get_unit(object_get_ai(obj_activator)), b_active );
end
script static void f_button_user_active( unit u_activator, boolean b_active )
	dprint( "f_button_user_active" );

	ai_disregard( u_activator, b_active );
	/*
	object_cannot_die( u_activator, b_active );
	if ( b_active ) then
		object_cannot_take_damage( u_activator );
	else
		object_can_take_damage( u_activator );
	end
	*/

end

// ==========================================================================================================================================================
// *** MISC ***
// ==========================================================================================================================================================

script static boolean f_players_check_sticky_detonator()
 	f_player_has_weapon( 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon' );
end


// -------------------------------------------------------------------------------------------------
// KILL COMMAND SCRIPTS
// -------------------------------------------------------------------------------------------------
script command_script cs_ai_kill_silent() 
	ai_kill_silent( ai_current_actor );
end
script command_script cs_ai_kill_silent_items_none()
	unit_doesnt_drop_items( ai_actors(ai_current_actor) );
	ai_kill_silent( ai_current_actor );
end
script command_script cs_ai_no_statistics()
	ai_kill_no_statistics( ai_current_actor );
end



// ==========================================================================================================================================================
// *** CHAPTER TITLES ***
// ==========================================================================================================================================================
/*
script static void f_chapter_title_display( cutscene_title ct_title )
	cinematic_show_letterbox( TRUE );
	hud_play_global_animtion( screen_fade_out );
	sleep_s( 1.5 );
	hud_stop_global_animtion( screen_fade_out );
	cinematic_set_title( ct_title );
	sleep_s(3.5);
	hud_play_global_animtion( screen_fade_in );
	sleep_s(1.5);
	hud_stop_global_animtion( screen_fade_in );
	cinematic_show_letterbox( FALSE );
	sleep_s( 1.0 );
end
*/
script static void f_chapter_title_atrium()
	f_chapter_title( chapter_title_atrium );
	//f_chapter_title_display( chapter_title_atrium );
end
//script static void f_chapter_title_lookout()
//	f_chapter_title_display( chapter_title_lookout );
//end
script static void f_chapter_title_atrium_return()
	f_chapter_title( chapter_title_atrium_return );
	//f_chapter_title_display( chapter_title_atrium_return );
end
//script static void f_chapter_title_composer_removal()
//	f_chapter_title_display( chapter_title_composer_removal );
//end
