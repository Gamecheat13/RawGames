//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: NARRATIVE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_narrative_init::: Init
script dormant f_e7m1_narrative_init()
	//dprint( "f_e7m1_narrative_init" );
	
	// setup default radio delays
	spops_radio_transmission_delay_start_default( 10.0 / 30.0 );
	spops_radio_transmission_delay_end_default( 0.0 / 30.0 );
	
	// initialize sub-modules
	wake( f_e7m1_narrative_intro_init );
	wake( f_e7m1_narrative_attack_init );

	// setup triggers
	wake( f_e7m1_narrative_trigger );

end

// === f_e7m1_narrative_trigger::: General trigger for linear VO
script dormant f_e7m1_narrative_trigger()
	//dprint( "f_e7m1_narrative_trigger" );

	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C, 1 );
	//dprint( "f_e7m1_narrative_trigger: KEEP MOVING" );
	wake( f_e7m1_dialog_keep_moving );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: NARRATIVE: INTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_narrative_intro_init::: Init
script dormant f_e7m1_narrative_intro_init()
	//dprint( "f_e7m1_narrative_intro_init" );

	// setup trigger
	wake( f_e7m1_narrative_intro_trigger );

end

// === f_e7m1_narrative_intro_trigger::: Trigger
script dormant f_e7m1_narrative_intro_trigger()
	sleep_until( f_spops_mission_ready_complete(), 1 );
	//dprint( "f_e7m1_narrative_intro_trigger" );

	// trigger action
	wake( f_e7m1_narrative_intro_action );

end

// === f_e7m1_narrative_intro_action::: Action
script dormant f_e7m1_narrative_intro_action()
	//dprint( "f_e7m1_narrative_intro_action" );

	// prep for pup
	f_spops_mission_intro_complete( TRUE );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: NARRATIVE: ATTACK ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_narrative_attack_init::: Init
script dormant f_e7m1_narrative_attack_init()
	//dprint( "f_e7m1_narrative_attack_init" );

	// setup trigger
	wake( f_e7m1_narrative_attack_trigger );

end

// === f_e7m1_narrative_attack_trigger::: Trigger
script dormant f_e7m1_narrative_attack_trigger()
	//dprint( "f_e7m1_narrative_attack_trigger" );

	// Attack #1
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A, 1 );
	repeat
		sleep_until( not dialog_foreground_active_check(), 1 );
		sleep_s( 1.0, 3.0 );
	until( not dialog_foreground_active_check(), 1 );
	wake( f_e7m1_under_attack_01 );
	
	// Attack #2
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F, 1 );
	repeat
		sleep_until( not dialog_foreground_active_check(), 1 );
		sleep_s( 1.0 );
	until( not dialog_foreground_active_check(), 1 );
	wake( f_e7m1_under_attack_02 );
	
	// Attack #3
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C, 1 );
	repeat
		sleep_until( not dialog_foreground_active_check(), 1 );
		sleep_s( 1.0, 3.0 );
	until( not dialog_foreground_active_check(), 1 );
	wake( f_e7m1_under_attack_03 );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: NARRATIVE: OUTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e7m1_outro_events = 				0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_narrative_outro_action::: Action
script dormant f_e7m1_narrative_outro_action()
local long l_timer = 0;
local long l_pup_id = 0;
	//dprint( "f_e7m1_narrative_outro_action" );

	spops_audio_music_event( 'play_mus_pve_e07m1_objective_pickup_end', "play_mus_pve_e07m1_objective_pickup_end" );
	fade_out( 0, 0, 0, seconds_to_frames(1.0) );
	player_control_fade_out_all_input( 0.1 );
	sleep_s( 1.0 );	
	hud_show( FALSE );
	object_hide( player0, TRUE );
	object_hide( player1, TRUE );
	object_hide( player2, TRUE );
	object_hide( player3, TRUE );
	object_set_physics( player0, FALSE ); 
	object_set_physics( player1, FALSE ); 
	object_set_physics( player2, FALSE ); 
	object_set_physics( player3, FALSE ); 
	object_destroy( dm_e7m1_phantom_grav_lift );
	object_destroy( vh_e7m1_phantom_ally );
	l_pup_id = pup_play_show( 'e7_m1_outro' );
	//ai_vehicle_enter_immediate( ai_e7m1_outro_braindead, phant_e7m1outro, close_turret_doors );
	
	// wait for end
	sleep_until( S_e7m1_outro_events >= 2, 1 );
	l_timer = timer_stamp( 1.0 );
	fade_out( 0, 0, 0, seconds_to_frames(1.0) );

	thread( f_spops_mission_end_complete(TRUE) );
	sleep_until( timer_expired(l_timer), 1 );
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
		Camera_control( FALSE );
	end
	
end