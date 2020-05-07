//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	horseshoe (or iho)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HORSESHOE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

global boolean 	B_horseshoe_phantom_went_boom = 								FALSE;
global boolean 	B_horseshoe_bypassed_side_right = 							FALSE;
global boolean 	B_horseshoe_reached_center = 										FALSE;
global boolean 	B_horseshoe_on_balcony = 												FALSE;
global object 	OBJ_horseshoe_pup_actor =         							NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_startup::: Startup
script startup f_horseshoe_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_horseshoe_startup :::" );

	// init horseshoe
	wake( f_horseshoe_init );

end

// === f_horseshoe_init::: Initialize
script dormant f_horseshoe_init()
	//dprint( "::: f_horseshoe_init :::" );

	// pre-setup
	kill_volume_disable( kill_tv_horseshoe_shield );

	// setup cleanup
	wake( f_horseshoe_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current() >= S_ZONESET_TO_HORSESHOE) and (zoneset_current() <= S_ZONESET_HORSESHOE), 1 );
	
	// init modules
	wake( f_horseshoe_ai_init );
	wake( f_horseshoe_narrative_init );
	//wake( f_horseshoe_audio_init );
	wake( f_horseshoe_fx_init );
	
	// init sub modules
	wake( f_horseshoe_doors_init );
	wake( f_horseshoe_puppeteer_init );
	wake( f_horseshoe_crane_init );
	wake( f_horseshoe_props_init );
	
	wake( f_horseshoe_shield_init );
	//wake( f_horseshoe_center_init );
	wake( f_horseshoe_exit_init );

	wake( f_horseshoe_checkpoints_init );
	
	// setup trigger
	wake( f_horseshoe_trigger );

end

// === f_horseshoe_deinit::: Deinitialize
script dormant f_horseshoe_deinit()
	//dprint( "::: f_horseshoe_deinit :::" );

	// init modules
	wake( f_horseshoe_ai_deinit );
	wake( f_horseshoe_narrative_deinit );
	//wake( f_horseshoe_audio_deinit );
	wake( f_horseshoe_fx_deinit );
	
	// deinit sub modules
	wake( f_horseshoe_doors_deinit );
	wake( f_horseshoe_puppeteer_deinit );
	wake( f_horseshoe_crane_deinit );
	wake( f_horseshoe_shield_deinit );
	wake( f_horseshoe_center_deinit );
	wake( f_horseshoe_exit_deinit );
	wake( f_horseshoe_props_deinit );

	wake( f_horseshoe_checkpoints_deinit );

	// kill functions
	kill_script( f_horseshoe_startup );
	kill_script( f_horseshoe_init );
	kill_script( f_horseshoe_trigger );

end

// === f_horseshoe_cleanup::: Cleanup
script dormant f_horseshoe_cleanup()

	sleep_until( zoneset_current() > S_ZONESET_TO_LAB, 1 );
	//dprint( "::: f_horseshoe_cleanup :::" );

	// Deinitialize
	wake( f_horseshoe_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_horseshoe_trigger::: Trigger
script dormant f_horseshoe_trigger()
	//dprint( "::: f_horseshoe_trigger :::" );

	// trigger start
	sleep_until( f_horseshoe_started(), 1 );
	wake( f_horseshoe_start );

end

script dormant f_horseshoe_start()
	//dprint( "::: f_horseshoe_start :::" );

	// start data minining
	data_mine_set_mission_segment( "m80_Horseshoe" );

	// start horseshoe objective
	f_objective_set_timer_reminder( DEF_R_OBJECTIVE_HORSESHOE_ENTER(), TRUE, FALSE, FALSE, TRUE );
	
	// checkpoint
	thread( checkpoint_no_timeout(TRUE, "f_horseshoe_door_enter_trigger") );

	// music
	thread( f_mus_m80_e01_begin() );
	
end

// === f_horseshoe_started::: Checks if the horseshoe sequence was started
script static boolean f_horseshoe_started()
static boolean b_started = FALSE;

	if ( (not b_started) and object_valid(door_horseshoe_enter) and object_active_for_script(door_horseshoe_enter) ) then
		b_started = not door_horseshoe_enter->position_close_check();
	end

	// return
	b_started;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: CHECKPOINTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_checkpoints_init::: Init
script dormant f_horseshoe_checkpoints_init()
sleep_until( f_horseshoe_started(), 1 );
	//dprint( "::: f_horseshoe_checkpoints_init :::" );
	
	// init sub modules
	wake( f_horseshoe_checkpoint_right_trigger );
	wake( f_horseshoe_checkpoint_center_start_trigger );
	wake( f_horseshoe_checkpoint_center_battle_trigger );
	wake( f_horseshoe_checkpoint_center_battle_trigger_2 );
	wake( f_horseshoe_checkpoint_center_battle_trigger_3 );
	wake( f_horseshoe_checkpoint_left_top_trigger );
	wake( f_horseshoe_checkpoint_left_battle_trigger );
	
end

// === f_horseshoe_checkpoints_deinit::: Deinit
script dormant f_horseshoe_checkpoints_deinit()
	//dprint( "::: f_horseshoe_checkpoints_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_checkpoints_init );

	kill_script( f_horseshoe_checkpoint_right_trigger );
	kill_script( f_horseshoe_checkpoint_center_start_trigger );
	kill_script( f_horseshoe_checkpoint_left_top_trigger );
	kill_script( f_horseshoe_checkpoint_left_battle_trigger );
	
end

// === f_horseshoe_checkpoint_right_trigger::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_right_trigger()
	sleep_until( volume_test_players(tv_hs_right_quicksave), 1 );
	//dprint( "::: f_horseshoe_checkpoint_right_trigger :::" );
	
	checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_right_trigger" );
	
end

// === f_horseshoe_checkpoint_center_start_trigger::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_center_start_trigger()
	sleep_until( volume_test_players(tv_hs_center_start), 1 );
	//dprint( "::: f_horseshoe_checkpoint_center_start_trigger :::" );

	checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_center_start_trigger" );
	
end

// === f_horseshoe_checkpoint_center_battle_trigger::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_center_battle_trigger()
	sleep_until(B_horseshoe_center_drop_2_complete, 1);
	//dprint( "::: f_horseshoe_checkpoint_center_battle_trigger :::" );

	if( not f_horseshoe_shield_active() ) then
		checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_center_battle_trigger" );
	end
	
end

// === f_horseshoe_checkpoint_center_battle_trigger_2::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_center_battle_trigger_2()
	sleep_until(B_horseshoe_center_dropoffs_complete, 1);
	//dprint( "::: f_horseshoe_checkpoint_center_battle_trigger_2 :::" );

	if( not f_horseshoe_shield_active() ) then
		checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_center_battle_trigger" );
	end
	
end

// === f_horseshoe_checkpoint_center_battle_trigger_2::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_center_battle_trigger_3()
	sleep_until(ai_living_count( sg_center_count ) <= 6, 1);
	//dprint( "::: f_horseshoe_checkpoint_center_battle_trigger_2 :::" );

	if( not f_horseshoe_shield_active() ) then
		checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_center_battle_trigger" );
	end
	
end

// === f_horseshoe_checkpoint_left_battle_trigger::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_left_battle_trigger()
	sleep_until( f_ai_is_partially_defeated(sg_hs_sniper, 5), 1 );
	//dprint( "::: f_horseshoe_checkpoint_left_battle_trigger :::" );

	checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_left_battle_trigger" );
	
end

// === f_horseshoe_checkpoint_left_top_trigger::: Checkpoint Trigger
script dormant f_horseshoe_checkpoint_left_top_trigger()
	sleep_until( volume_test_players(tv_hs_reached_building_top), 1 );
	//dprint( "::: f_horseshoe_checkpoint_left_top_trigger :::" );

	checkpoint_no_timeout( TRUE, "f_horseshoe_checkpoint_left_top_trigger" );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_props_init::: Init
script dormant f_horseshoe_props_init()
	//dprint( "::: f_horseshoe_props_init :::" );

	// setup triggers
	wake( f_horseshoe_props_trigger );
	
end

// === f_horseshoe_props_deinit::: Deinit
script dormant f_horseshoe_props_deinit()
	//dprint( "::: f_horseshoe_props_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_props_init );
	kill_script( f_horseshoe_props_trigger );
	
	object_destroy_folder( hs_crates_right );
	object_destroy_folder( hs_crates_center );
	object_destroy_folder( hs_crates_left );
	
end

// === f_horseshoe_props_trigger::: Trigger
script dormant f_horseshoe_props_trigger()
	//dprint( "::: f_horseshoe_props_trigger :::" );
 
	sleep_until( B_horseshoe_shield_activated, 1 );
	//dprint( "::: f_horseshoe_props_trigger: LEFT CREATE :::" );
	object_create_folder_anew( hs_crates_left );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: SHIELD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_shield_init::: Init
script dormant f_horseshoe_shield_init()
	//dprint( "::: f_horseshoe_shield_init :::" );
	
	// init sub modules
	wake( f_horseshoe_shield_control_init );
	
	// trigger
	wake( f_horseshoe_shield_trigger );
	
end

// === f_horseshoe_shield_deinit::: Deinit
script dormant f_horseshoe_shield_deinit()
	//dprint( "::: f_horseshoe_shield_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_shield_init );
	kill_script( f_horseshoe_shield_trigger );
	kill_script( f_horseshoe_shield_action_start );
	kill_script( f_horseshoe_shield_action_activate );
	kill_script( f_horseshoe_shield_action_end );
	kill_script( f_horseshoe_shield_active_kill );
	
end

// === f_horseshoe_shield_trigger::: Trigger
script dormant f_horseshoe_shield_trigger()

	// trigger action start
	sleep_until( 
		volume_test_players( tv_hs_center_left_entrance_1 ) or
		volume_test_players( tv_hs_center_left_entrance_3 ) or
		volume_test_players( tv_hs_center_left_entrance_2 ) or
		f_objective_current_check( DEF_R_OBJECTIVE_HORSESHOE_SHIELD() ) or 
		dialog_id_played_check( L_dlg_horseshoe_intro ) or
		dialog_foreground_id_line_index_check_greater_equel( L_dlg_horseshoe_intro, S_dlg_horseshoe_intro_objective_line_index )
		, 1 );
	//dprint( "::: f_horseshoe_shield_trigger: START :::" );
	thread( f_horseshoe_shield_action_start() );

	sleep_until( f_horseshoe_shield_control_activated(), 1 );
	//dprint( "::: f_horseshoe_shield_trigger: ACTIVATE :::" );
	wake( f_horseshoe_shield_action_activate );

	sleep_until( f_horseshoe_shield_active(), 1 );
	//dprint( "::: f_horseshoe_shield_trigger: END :::" );
	wake( f_horseshoe_shield_action_end );
	
end

// === f_horseshoe_shield_action_start::: XXX
script static void f_horseshoe_shield_action_start()
	//dprint( "::: f_horseshoe_shield_action_start :::" );
	
	// Start objective
	if ( not f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()) ) then
		f_objective_set( DEF_R_OBJECTIVE_HORSESHOE_SHIELD(), TRUE, FALSE, FALSE, TRUE );
	end
	
end

// === f_horseshoe_shield_action_activate::: XXX
script dormant f_horseshoe_shield_action_activate()
local short s_count = 3;
local real r_sequence_delay = 0.25;
local boolean b_spawned_phantom = FALSE;

	//dprint( "::: f_horseshoe_shield_action_activate :::" );
	f_mus_m80_e01_horseshoe_shield_activated(); // send music cue that shield is activated
	
	// do light sequence	
	repeat
	
		// One more phantom, so the player gets to see someone crash and burn
		if ( (not b_spawned_phantom) and (s_count <= 2) and B_horseshoe_center_dropoffs_complete ) then
			//dprint( "::: f_horseshoe_shield_action_activate: SPAWNING PHANTOM!!!! :::" );
			ai_place( phantom_hits_shield );
			b_spawned_phantom = TRUE;
		end
	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_1 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_4 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_7 );	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_10 );
		sleep_s( r_sequence_delay );
	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_2 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_5 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_8 );	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_11 );
		sleep_s( r_sequence_delay );
	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_3 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_6 );
		f_dynamic_light_red_on( nar_hs_shield_frame_light_9 );	
		f_dynamic_light_red_on( nar_hs_shield_frame_light_12 );
		sleep_s( r_sequence_delay );
	
		f_dynamic_light_off( nar_hs_shield_frame_light_1 );
		f_dynamic_light_off( nar_hs_shield_frame_light_4 );
		f_dynamic_light_off( nar_hs_shield_frame_light_7 );	
		f_dynamic_light_off( nar_hs_shield_frame_light_10 );
		sleep_s( r_sequence_delay );
	
		f_dynamic_light_off( nar_hs_shield_frame_light_2 );
		f_dynamic_light_off( nar_hs_shield_frame_light_5 );
		f_dynamic_light_off( nar_hs_shield_frame_light_8 );	
		f_dynamic_light_off( nar_hs_shield_frame_light_11 );
		sleep_s( r_sequence_delay );
	
		f_dynamic_light_off( nar_hs_shield_frame_light_3 );
		f_dynamic_light_off( nar_hs_shield_frame_light_6 );
		f_dynamic_light_off( nar_hs_shield_frame_light_9 );	
		f_dynamic_light_off( nar_hs_shield_frame_light_12 );
		sleep_s( r_sequence_delay );

		// decrement counter
		s_count = s_count - 1;

	until( s_count <= 0, 1 );

	// create the shield
	object_create( hs_temp_shield );
	
	// apply the shield fx
	object_set_function_variable( hs_temp_shield, 'shield_on', 1.0, 2.0 );	// XXX move into fx script
	
	// start the phantom killer
	wake( f_horseshoe_shield_active_kill );
	
end

// === f_horseshoe_shield_active_kill::: XXX
script dormant f_horseshoe_shield_active_kill()
	//dprint( "::: f_horseshoe_shield_active_kill :::" );
	
	// enable the kill volume
	kill_volume_enable( kill_tv_horseshoe_shield );

	// destroy incoming phantoms
	repeat
		damage_objects( volume_return_objects_by_campaign_type(kill_tv_horseshoe_shield, 31), engine_right, 10000 );
		damage_objects( volume_return_objects_by_campaign_type(kill_tv_horseshoe_shield, 31), engine_left, 10000 );
		damage_objects( volume_return_objects_by_campaign_type(kill_tv_horseshoe_shield, 31), hull, 10000 );
		object_can_take_damage( volume_return_objects_by_campaign_type(kill_tv_horseshoe_shield, 31) );
		
	until( FALSE, 1 );

end

// === f_horseshoe_shield_action_end::: XXX
script dormant f_horseshoe_shield_action_end()
	//dprint( "::: f_horseshoe_shield_action_end :::" );
	
	// End objective
	f_objective_complete( DEF_R_OBJECTIVE_HORSESHOE_SHIELD(), TRUE, TRUE );
	
	// checkpoint
	checkpoint_no_timeout( TRUE, "f_horseshoe_shield_action_end" );
	
	// start the center
	wake( f_horseshoe_center_start );
	
end

// === f_horseshoe_shield_active::: XXX
script static boolean f_horseshoe_shield_active()
	( object_valid(hs_temp_shield) ) ;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: SHIELD: CONTROL
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_horseshoe_shield_activated = 								FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_shield_control_init::: Init
script dormant f_horseshoe_shield_control_init()
	sleep_until( object_valid(dc_horseshoe_shield_control), 1 );
	//dprint( "::: f_horseshoe_shield_control_init :::" );

	object_set_variant( dc_horseshoe_shield_control, "idle" );

	// trigger
	wake( f_horseshoe_shield_control_trigger );
	
end

// === f_horseshoe_shield_control_deinit::: Deinit
script dormant f_horseshoe_shield_control_deinit()
	//dprint( "::: f_horseshoe_shield_control_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_shield_control_init );
	kill_script( f_horseshoe_shield_control_trigger );
	kill_script( f_horseshoe_shield_control_action );
	
end

// === f_horseshoe_shield_control_trigger::: Trigger
script dormant f_horseshoe_shield_control_trigger()
	//dprint( "::: f_horseshoe_shield_control_trigger :::" );

	// blip the control
	sleep_until( 
		(
			dialog_foreground_id_line_index_check_greater_equel( L_dlg_horseshoe_raise, S_dlg_horseshoe_raise_blip_index )
			or
			dialog_id_played_check( L_dlg_horseshoe_raise )
		)
		, 1 );

	// make sure this is the current objective
	if ( not f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()) ) then
		thread( f_horseshoe_shield_action_start() );
		sleep_until( f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()), 1 );
	end

	f_objective_blip( DEF_R_OBJECTIVE_HORSESHOE_SHIELD(), TRUE, FALSE );
	
end

// === f_horseshoe_shield_control_activated::: XXX
script static boolean f_horseshoe_shield_control_activated()
	B_horseshoe_shield_activated;
end

// === f_horseshoe_shield_control_action::: Hooked up from the device control, this will be called when it is activated
script static void f_horseshoe_shield_control_action( object obj_control, unit u_activator )
local long l_pup_id = -1;
	//dprint( "::: f_horseshoe_shield_control_action :::" );

	// force disable interaction so no one else can use it while one player is
	device_set_power( device(obj_control), 0.0 );

	// unblip the control
	f_objective_blip( DEF_R_OBJECTIVE_HORSESHOE_SHIELD(), FALSE );

	// prepare activator
	p_player_puppet = u_activator;

	// start puppet active
	f_button_user_active( u_activator, TRUE );
	
	// play the button press
	l_pup_id = pup_play_show( 'pup_horseshoe_shield_button' );
	
	// wait for pup to finish or button activated
	sleep_until( not pup_is_playing(l_pup_id) or f_horseshoe_shield_control_activated() or (unit_get_health(u_activator) <= 0.0), 1 );

	// set activated variant
	if ( f_horseshoe_shield_control_activated() ) then
		object_set_variant( dc_horseshoe_shield_control, "engage" );
	end

	// wait for pup to finish
	sleep_until( not pup_is_playing(l_pup_id) or (unit_get_health(u_activator) <= 0.0), 1 );

	// end puppet active
	f_button_user_active( u_activator, FALSE );
	
	// make sure the show is dead
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	
	// check if button press was not completed
	if ( not f_horseshoe_shield_control_activated() ) then
		device_set_power( device(obj_control), 1.0 );
		f_objective_blip( DEF_R_OBJECTIVE_HORSESHOE_SHIELD(), TRUE );
	end
	
	// OLD BUTTON CHECK CONDITIONS
/*	
	//if ( ai_living_count (sg_center_count) < 1 ) then
	//if ( (not objects_can_see_object(ai_actors(sg_center_count),u_activator, 10.0)) and (objects_distance_to_object(ai_actors(sg_center_count),u_activator) >= 10.0) ) then
*/	

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: CENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_center_init::: Init
//script dormant f_horseshoe_center_init()
	//dprint( "::: f_horseshoe_center_init :::" );
	
	// XXX
	
//end

// === f_horseshoe_center_deinit::: Deinit
script dormant f_horseshoe_center_deinit()
	//dprint( "::: f_horseshoe_center_deinit :::" );
	
	// kill functions
	//kill_script( f_horseshoe_center_init );
	kill_script( f_horseshoe_center_start );
	
end

// === f_horseshoe_center_start::: XXX
script dormant f_horseshoe_center_start()
local long l_blip_thread = 0;
	//dprint( "::: f_horseshoe_center_start :::" );
	
	// set the objective
	f_objective_set( DEF_R_OBJECTIVE_HORSESHOE_CENTER(), FALSE, TRUE, FALSE, TRUE );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_exit_init::: Init
script dormant f_horseshoe_exit_init()
	//dprint( "::: f_horseshoe_exit_init :::" );
	
	// Setup trigger
	wake( f_horseshoe_exit_trigger );
	
end

// === f_horseshoe_exit_deinit::: Deinit
script dormant f_horseshoe_exit_deinit()
	//dprint( "::: f_horseshoe_exit_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_exit_init );
	kill_script( f_horseshoe_exit_trigger );
	
end

// === f_horseshoe_exit_trigger::: XXX
script dormant f_horseshoe_exit_trigger()

	// setup blip
	sleep_until( volume_test_players(tv_hs_building_roof_back), 1 );
	//dprint( "::: f_horseshoe_exit_trigger: BLIP :::" );
	f_objective_set( DEF_R_OBJECTIVE_HORSESHOE_EXIT(), TRUE, TRUE, FALSE, TRUE );

/*
	sleep_until( volume_test_players(tv_hs_exited), 1 );
	//dprint( "::: f_horseshoe_exit_trigger: UNBLIP :::" );
	f_objective_blip( DEF_R_OBJECTIVE_HORSESHOE_EXIT(), FALSE, FALSE );
*/	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: CRANE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_crane_init::: Init
script dormant f_horseshoe_crane_init()
	//dprint( "::: f_horseshoe_crane_init :::" );
	
	// setup trigger
	wake( f_horseshoe_crane_trigger );
	
end

// === f_horseshoe_crane_deinit::: Deinit
script dormant f_horseshoe_crane_deinit()
	//dprint( "::: f_horseshoe_crane_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_crane_init );
	kill_script( f_horseshoe_crane_trigger );
	kill_script( f_horseshoe_crane_action );
	
end

// === f_horseshoe_crane_trigger::: Trigger
script dormant f_horseshoe_crane_trigger()
	sleep_until( object_valid(dm_horseshoe_crane_1), 1 );
	//dprint( "::: f_horseshoe_crane_trigger :::" );

	wake( f_horseshoe_crane_action );

end

// === f_horseshoe_crane_action::: Action
script dormant f_horseshoe_crane_action()
local real r_pos_target = 		0.0;
local real r_pos_audio_stop = 0.0;
	//dprint( "::: f_horseshoe_crane_action :::" );

	repeat
	
		// get a random target positon
		if ( device_get_position(dm_horseshoe_crane_1) <= 0.50 ) then
			r_pos_target = real_random_range( 0.60, 0.81 );
			r_pos_audio_stop = r_pos_target * 0.90;
		else
			r_pos_target = real_random_range( 0.0, 0.40 );
			r_pos_audio_stop = r_pos_target + (r_pos_target * 0.10);
		end
		//inspect( r_pos_target );
		
		// Move the crane
		device_set_position( dm_horseshoe_crane_1, r_pos_target );
		
		// start the sound
		sound_looping_start_marker('sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\horseshoe_crane_large_m80_loop', dm_horseshoe_crane_1, crane_motor, 1 );
		
		// wait until it hits the audio stop position
		if ( r_pos_target > device_get_position(dm_horseshoe_crane_1) ) then
			sleep_until( device_get_position(dm_horseshoe_crane_1) >= r_pos_audio_stop, 1 );
		else
			sleep_until( device_get_position(dm_horseshoe_crane_1) <= r_pos_audio_stop, 1 );
		end
		sound_looping_stop('sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\horseshoe_crane_large_m80_loop');
		
		sleep_until( device_get_position(dm_horseshoe_crane_1) == r_pos_target, 1 );
		
		// delay a little bit in between
		sleep_s( 2.5, 5.0 );
		
	until( FALSE, 1 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: TURRETS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: TURRETS: GAUSS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_player_gauss_turret_check_on::: XXX
script static boolean f_horseshoe_player_gauss_turret_check_on()

	object_valid( turret_horseshoe_gauss ) and player_in_vehicle( turret_horseshoe_gauss );
	
end

// === f_horseshoe_player_gauss_turret_check_ready::: XXX
script static boolean f_horseshoe_player_gauss_turret_check_ready()

	unit_has_weapon_readied( Player0, "objects\vehicles\human\turrets\gauss_turret\weapon\machinegun_turret\gauss_turret_turret.weapon" ) or
	unit_has_weapon_readied( Player1, "objects\vehicles\human\turrets\gauss_turret\weapon\machinegun_turret\gauss_turret_turret.weapon" ) or
	unit_has_weapon_readied( Player2, "objects\vehicles\human\turrets\gauss_turret\weapon\machinegun_turret\gauss_turret_turret.weapon" ) or
	unit_has_weapon_readied( Player3, "objects\vehicles\human\turrets\gauss_turret\weapon\machinegun_turret\gauss_turret_turret.weapon" );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: TURRETS: PLASMA
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_player_plasma_turret_check_ready::: XXX
/*script static boolean f_horseshoe_player_plasma_turret_check_ready()

	unit_has_weapon_readied( Player0, "objects\vehicles\covenant\turrets\plasma_turret\weapon\plasma_turret_detached\storm_plasma_turret.weapon" ) or
	unit_has_weapon_readied( Player1, "objects\vehicles\covenant\turrets\plasma_turret\weapon\plasma_turret_detached\storm_plasma_turret.weapon" ) or
	unit_has_weapon_readied( Player2, "objects\vehicles\covenant\turrets\plasma_turret\weapon\plasma_turret_detached\storm_plasma_turret.weapon" ) or
	unit_has_weapon_readied( Player3, "objects\vehicles\covenant\turrets\plasma_turret\weapon\plasma_turret_detached\storm_plasma_turret.weapon" );
	
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: PUPPETEER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_horseshoe_puppeteer_marine_kill = 						FALSE;
global boolean B_horseshoe_puppeteer_jackal_interruptable = 	FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_puppeteer_init::: Init
script dormant f_horseshoe_puppeteer_init()
	//dprint( "::: f_horseshoe_puppeteer_init :::" );
	
	// setup trigger
	wake( f_horseshoe_puppeteer_trigger );
	
end

// === f_horseshoe_puppeteer_deinit::: Deinit
script dormant f_horseshoe_puppeteer_deinit()
	//dprint( "::: f_horseshoe_puppeteer_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_puppeteer_init );
	kill_script( f_horseshoe_puppeteer_trigger );
	kill_script( f_horseshoe_puppeteer_action );
	
end

// === f_horseshoe_puppeteer_trigger::: Trigger
script dormant f_horseshoe_puppeteer_trigger()
	sleep_until( object_valid(door_horseshoe_enter) and (device_get_position(door_horseshoe_enter) >= 0.675) and (ai_living_count(humans_hs_right_oni.jackal_attack) > 0) and (ai_living_count(sq_hs_right_jackal_attack.jackal_01) > 0), 1 );
	//dprint( "::: f_horseshoe_puppeteer_trigger :::" );
	
	// setup trigger
	wake( f_horseshoe_puppeteer_action );
	
end

// === f_horseshoe_puppeteer_action::: Action
script dormant f_horseshoe_puppeteer_action()
local long l_l_pup_id = -1;
local object obj_jackal = ai_get_object( sq_hs_right_jackal_attack );
	//dprint( "::: f_horseshoe_puppeteer_action :::" );
	
	// play the show
	//wake( f_horseshoe_puppeteer_debug_jackal_health );
	l_l_pup_id = pup_play_show( pup_hs_jackal_attack );
	sleep_until( not pup_is_playing(l_l_pup_id) or (B_horseshoe_puppeteer_jackal_interruptable and (object_get_health(obj_jackal) <= 0.75)), 1 );
	//sleep_forever( f_horseshoe_puppeteer_debug_jackal_health );
	
	// Kill or restore human
	if ( B_horseshoe_puppeteer_marine_kill ) then
		f_horseshoe_puppeteer_human_kill();
	end
	
end
/*
script dormant f_horseshoe_puppeteer_debug_jackal_health()
local object obj_test = ai_get_object( sq_hs_right_jackal_attack );
	//dprint( "::: f_horseshoe_puppeteer_debug_jackal_health :::" );
	repeat
		//inspect( object_get_health(obj_test) );
	until( (obj_test == NONE) or (object_get_health(obj_test) <= 0.0), 1 );
end
*/
// === f_horseshoe_puppeteer_human_health_set::: XXX
script static void f_horseshoe_puppeteer_human_health_set( real r_ratio )
	//dprint( "::: f_horseshoe_puppeteer_human_health_set :::" );
	//inspect( r_ratio );

	object_can_take_damage( ai_get_object(humans_hs_right_oni.jackal_attack) );
	units_set_current_vitality( ai_actors(humans_hs_right_oni.jackal_attack), r_ratio, 0.0 );

end

// === f_horseshoe_puppeteer_human_kill::: XXX
script static void f_horseshoe_puppeteer_human_kill()
	//dprint( "::: f_horseshoe_puppeteer_human_kill :::" );
	
	B_horseshoe_puppeteer_marine_kill = FALSE;
	
	object_can_take_damage( ai_get_object(humans_hs_right_oni.jackal_attack) );
	ai_kill_silent( humans_hs_right_oni.jackal_attack );
	
end

// === command_script cs_hs_right_sci_flee_1()

script command_script cs_hs_right_sci_flee_1()

	local long l_pup_id = -1;
	sleep_until( f_horseshoe_started(), 1 );

		repeat
    	// flee stance
      cs_push_stance( panic );

      // go to a random point
      begin_random_count( 1 )
          cs_go_to( ps_hs_right_sci_flee.p1 );
          cs_go_to( ps_hs_right_sci_flee.p2 );
          cs_go_to( ps_hs_right_sci_flee.p3 );
     end
                                
      // play puppet show
      
      //dprint ("::: BEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFORE:::");
      
      OBJ_horseshoe_pup_actor = ai_get_object( ai_current_actor );
      pup_play_show( 'pup_scientist_flee_1' );
      
        //dprint ("::: AFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTER:::");
      
      sleep_until( not pup_is_playing(l_pup_id), 1 );
      
     sleep_s(1,2); 
                               
     until( FALSE, 1 );
               
end

script command_script cs_hs_right_sci_flee_2()

	local long l_pup_id = -1;
	sleep_until( f_horseshoe_started(), 1 );
          
   repeat                      
      // play puppet show
      
      //dprint ("::: BEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFOREBEFORE:::");
      
      OBJ_horseshoe_pup_actor = ai_get_object( ai_current_actor );
      pup_play_show( 'pup_scientist_flee_1' );
            
        //dprint ("::: AFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTERAFTER:::");
      
      sleep_until( not pup_is_playing(l_pup_id), 1 );
     
     sleep_s(1,2); 
                                
     until( FALSE, 1 );

               
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_doors_init::: Init
script dormant f_horseshoe_doors_init()
	//dprint( "::: f_horseshoe_doors_init :::" );
	
	// init sub modules
	wake( f_horseshoe_door_center_init );
	wake( f_horseshoe_door_exit_init );
	
end

// === f_horseshoe_doors_deinit::: Deinit
script dormant f_horseshoe_doors_deinit()
	//dprint( "::: f_horseshoe_doors_deinit :::" );

	// deinit sub modules
	wake( f_horseshoe_door_center_deinit );
	wake( f_horseshoe_door_exit_deinit );
	
	// kill functions
	kill_script( f_horseshoe_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: DOOR: CENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_horseshoe_door_center_init::: Init
script dormant f_horseshoe_door_center_init()
	sleep_until( object_valid(door_horseshoe_center_maya) and object_active_for_script(door_horseshoe_center_maya), 1 );
	//dprint( "::: f_horseshoe_door_center_init :::" );

	// setup trigger
	wake( f_horseshoe_door_center_trigger );
	
end

// === f_horseshoe_door_center_deinit::: Deinit
script dormant f_horseshoe_door_center_deinit()
	//dprint( "::: f_horseshoe_door_center_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_door_center_init );
	kill_script( f_horseshoe_door_center_trigger );
	
end

// === f_horseshoe_door_center_trigger::: Trigger
script dormant f_horseshoe_door_center_trigger()

	// condition		
	sleep_until( 
			f_horseshoe_shield_active()
			and
			volume_test_players( tv_horseshoe_center_door_open )
			and
			f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_CENTER())
		  and
			(
				objects_can_see_object( Players(), door_horseshoe_center_maya, 7.5 )
				or
				( objects_distance_to_object(Players(), door_horseshoe_center_maya) <= 12.5 )
			)
		, 1 );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_horseshoe_door_center_trigger" );

	// prepare next zone
	//door_horseshoe_center_maya->zoneset_auto_open_setup( S_ZONESET_TO_LAB, TRUE, TRUE, -1, S_ZONESET_TO_LAB, TRUE );
	
	repeat

		// open
		door_horseshoe_center_maya->open();
		if ( zoneset_current() < S_ZONESET_TO_LAB ) then
			thread( zoneset_prepare_and_load(S_ZONESET_TO_LAB) );
		end
	
		// close
		door_horseshoe_center_maya->auto_trigger_close_all_out( tv_horseshoe_center_door_close_out, TRUE );
		
		// wait for reset
		sleep_until( volume_test_players(tv_horseshoe_center_door_reset), 1 );
		
	until( zoneset_current() > S_ZONESET_TO_LAB, 1 );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_horseshoe_door_exit_init::: Init
script dormant f_horseshoe_door_exit_init()
	sleep_until( object_valid(door_horseshoe_exit_maya) and object_active_for_script(door_horseshoe_exit_maya), 1 );
	//dprint( "::: f_horseshoe_door_exit_init :::" );

	// setup auto disable	
	thread( door_horseshoe_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_LAB, -1) );

	// open
	door_horseshoe_exit_maya->zoneset_auto_open_setup( S_ZONESET_TO_LAB, TRUE, TRUE, S_ZONESET_TO_HORSESHOE, S_ZONESET_TO_LAB, TRUE );
	door_horseshoe_exit_maya->auto_trigger_open_any_in( tv_horseshoe_exit_open, TRUE );
	
	// close
	door_horseshoe_exit_maya->zoneset_auto_close_setup( S_ZONESET_LAB, TRUE, FALSE, S_ZONESET_TO_HORSESHOE, S_ZONESET_LAB, TRUE );
	door_horseshoe_exit_maya->auto_trigger_close_all_out( tv_horseshoe_door_exit_close, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_HORSESHOE_EXIT(), FALSE, TRUE );

	// force closed
	door_horseshoe_exit_maya->close_immediate();

	// shut down encounter music
	thread( f_mus_m80_e01_finish() );
	
	// force cleanup
	wake( f_horseshoe_deinit );
	
end

// === f_horseshoe_door_exit_deinit::: Deinit
script dormant f_horseshoe_door_exit_deinit()
	//dprint( "::: f_horseshoe_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_horseshoe_door_exit_init );
	
end
