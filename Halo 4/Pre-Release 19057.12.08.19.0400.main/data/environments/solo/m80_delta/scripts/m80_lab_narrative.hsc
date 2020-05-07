//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_lab (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** LAB: NARRATIVE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// === f_lab_narrative_init::: Initialize
script dormant f_lab_narrative_init()
	//dprint( "::: f_lab_narrative_init :::" );
	
	// init sub module
	wake( f_lab_narrative_scan_init );
	//thread( f_lab_narrative_scientist_01_trigger(sq_lab_scientists.01) );
	thread( f_lab_narrative_scientist_02_trigger(sq_lab_scientists.02) );
	thread( f_lab_narrative_scientist_03_trigger(sq_lab_security_02.01) );
	thread( f_lab_narrative_scientist_04_trigger(sq_lab_scientists.03) );
	
	
//	wake( f_lab_narrative_crane );
	//wake( f_lab_narrative_audiolog );

end

// === f_lab_narrative_deinit::: Deinitialize
script dormant f_lab_narrative_deinit()
	//dprint( "::: f_lab_narrative_deinit :::" );
	
	// init sub module
	wake( f_lab_narrative_scan_deinit );

	// kill functions
	kill_script( f_lab_narrative_init );




//	kill_script( f_lab_narrative_crane );
	kill_script( f_lab_narrative_audiolog );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: NARRATIVE: SCAN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_narrative_scan_init::: Init
script dormant f_lab_narrative_scan_init()
	//dprint( "::: f_lab_narrative_scan_init :::" );
	
	// setup trigger
	wake( f_lab_narrative_scan_trigger );
	
end

// === f_lab_narrative_scan_deinit::: Deinit
script dormant f_lab_narrative_scan_deinit()
	//dprint( "::: f_lab_narrative_scan_deinit :::" );
	
	// kill functions
	kill_script( f_lab_narrative_scan_init );
	kill_script( f_lab_narrative_scan_trigger );
	//kill_script( f_lab_narrative_scan_action );
	
end

// === f_lab_narrative_scan_trigger::: Trigger
script dormant f_lab_narrative_scan_trigger()
	sleep_until( volume_test_players(tv_to_lab_scan), 1 );
	dprint( "::: SCAN SHOULD HAVE FIRED :::" );
	
	// action
//	wake( f_lab_narrative_scan_action );
			effect_new( environments\solo\m80_delta\fx\scan\dscan_lab.effect, fx_to_lab_didact_scan );		
	
end

/*
// === f_lab_narrative_scan_action::: Action
script dormant f_lab_narrative_scan_action()
	//dprint( "::: f_lab_narrative_scan_action :::" );
	
	
end
*/










script dormant f_lab_narrative_audiolog()
	object_create(device_control_lab_audiolog_sw);
	device_set_power( device_control_lab_audiolog_sw, 1.0 );
	
end

script static void f_lab_narrative_scientist_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
 
 
	// wait for player to be w/i distance
	sleep_until( (not dialog_background_active_check()) and (b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0)), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_lab_scientist_01 );
	end

end


script static void f_lab_narrative_scientist_02_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
//	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );
	sleep_until( (not dialog_background_active_check()) and (b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0)), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(  f_dialog_m80_lab_scientist_02 );
	end

end

script static void f_lab_narrative_scientist_03_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
//	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, -1.0), 1 );
	sleep_until( (not dialog_background_active_check()) and (b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0)), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(  f_dialog_m80_lab_scientist_03 );
	end

end

script static void f_lab_narrative_scientist_04_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
//	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );
	sleep_until( (not dialog_background_active_check()) and (b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0)), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(  f_dialog_m80_lab_scientist_04 );
	end

end

script static void f_lab_narrative_scientist_05_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
//	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );
	sleep_until( (not dialog_background_active_check()) and (b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0)), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(  f_dialog_m80_lab_scientist_05 );
	end

end
/*
script dormant f_lab_narrative_crane()

	// Setup
	sleep_until( object_valid(dm_lab_crane), 1 );
	device_set_position( dm_lab_crane, 1.0 );
	device_set_power( device_control_lab_crane, 0.0 );
	device_set_power( device_control_lab_terminal1, 0.0 );
	device_set_power( device_control_lab_terminal2, 0.0 );
	device_set_power( device_control_lab_terminal3, 0.0 );
	//object_hide( device_control_lab_crane, TRUE );
	object_hide( device_control_lab_terminal1, TRUE );
	object_hide( device_control_lab_terminal2, TRUE );
	object_hide( device_control_lab_terminal3, TRUE );
	//wake( f_lab_narrative_crane_idle );
	device_set_position_track( dm_lab_crane, "vin_m80_sync_crane_canister_1", 0.0 );
	device_animate_position( dm_lab_crane, 0.0, 0.0, 0.0, 0.0, TRUE );
	objects_attach( dm_lab_crane, "lab_cylinder_1", lab_canister1, "attach_point" );	
	objects_attach( dm_lab_crane, "lab_cylinder_2", lab_canister2, "attach_point" );
	objects_attach( dm_lab_crane, "lab_cylinder_3", lab_canister3, "attach_point" );
	// Canister's contents
	//objects_attach( lab_canister1, "canister1_contents", ###, "" );
	//objects_attach( lab_canister2, "canister2_contents", ###, "" );
	//objects_attach( lab_canister3, "canister3_contents", ###, "" );

	// Hunters dead, activate crane control
	sleep_until( f_ai_is_defeated(sg_lab_hunters) );
	device_set_power( device_control_lab_terminal1, 1.0 );

	// Wait until crane control pushed, disable crane control
	sleep_until( device_get_position( device_control_lab_terminal1 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal1, 0.0 );
	

	// Make sure the idle isn't already playing (could see about having it transition from the idle using the 0.0 in the "device_set_position_track" below ), then play the first animation
	sleep_until( b_lab_crane_animating == FALSE );
	b_lab_crane_animating = TRUE;
	device_set_position_track( dm_lab_crane, "vin_m80_sync_crane_canister_1", 0.0 );
	device_animate_position( dm_lab_crane, 1.0, r_lab_crane_animation1_time, r_lab_crane_start_transition_time, r_lab_crane_end_transition_time, TRUE );
	
	// Attach the canister to the arm at the right time
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister1_attach_frame / r_lab_canister1_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister1 );
	objects_attach( dm_lab_crane, "lab_crane_hand", lab_canister1, "attach_point" );

	// Wait for it to get to the right spot to activate the information button	
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister1_detach_frame / r_lab_canister1_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister1 );
	objects_attach( dm_lab_crane, "lab_cylinder_1", lab_canister1, "attach_point" );	
	device_set_power( device_control_lab_terminal1, 1.0 );
	f_blip_object( device_control_lab_terminal1, "default" );
	//objects_detach( dm_lab_crane, lab_canister1 );
	
	//thread( f_lab_crane_animation_done() );
	
	// Wait for the information button to be pressed
	sleep_until( device_get_position( device_control_lab_terminal1 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal1, 0.0 );
	f_unblip_object( device_control_lab_terminal1 );
	//dprint( "Lab crane narrative interaction #1" );
	
	// Reactivate the crane control
	device_set_power( device_control_lab_terminal2, 1.0 );
	device_set_position( device_control_lab_terminal2, 0.0 );
	

	
	// Wait until crane control pushed, disable crane control
	sleep_until( device_get_position( device_control_lab_terminal2 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal2, 0.0 );

	// Make sure the idle isn't already playing (could see about having it transition from the idle using the 0.0 in the "device_set_position_track" below ), then play the first animation
	sleep_until( b_lab_crane_animating == FALSE );
	b_lab_crane_animating = TRUE;
	device_set_position_track( dm_lab_crane, "vin_m80_sync_crane_canister_2", 0.0 );
	device_animate_position( dm_lab_crane, 1.0, r_lab_crane_animation2_time, r_lab_crane_start_transition_time, r_lab_crane_end_transition_time, TRUE );
	
	// Attach the canister to the arm at the right time
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister2_attach_frame / r_lab_canister2_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister2 );
	objects_attach( dm_lab_crane, "lab_crane_hand", lab_canister2, "attach_point" );
	
	// Wait for it to get to the right spot to activate the information button	
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister2_detach_frame / r_lab_canister2_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister2 );
	objects_attach( dm_lab_crane, "lab_cylinder_2", lab_canister2, "attach_point" );	
	device_set_power( device_control_lab_terminal2, 1.0 );
	f_blip_object( device_control_lab_terminal2, "default" );
	//objects_detach( dm_lab_crane, lab_canister2 );
	
	//thread( f_lab_crane_animation_done() );
	
	// Wait for the information button to be pressed
	sleep_until( device_get_position( device_control_lab_terminal2 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal2, 0.0 );
	f_unblip_object( device_control_lab_terminal2 );
	//dprint( "Lab crane narrative interaction #2" );
	
	// Reactivate the crane control
	device_set_power( device_control_lab_terminal3, 1.0 );
	device_set_position( device_control_lab_terminal3, 0.0 );
	


	// Wait until crane control pushed, disable crane control
	sleep_until( device_get_position( device_control_lab_terminal3 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal3, 0.0 );
	
	// Make sure the idle isn't already playing (could see about having it transition from the idle using the 0.0 in the "device_set_position_track" below ), then play the first animation
	sleep_until( b_lab_crane_animating == FALSE );
	b_lab_crane_animating = TRUE;
	device_set_position_track( dm_lab_crane, "vin_m80_sync_crane_canister_3", 0.0 );
	device_animate_position( dm_lab_crane, 1.0, r_lab_crane_animation3_time, r_lab_crane_start_transition_time, r_lab_crane_end_transition_time, TRUE );

	// Attach the canister to the arm at the right time
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister3_attach_frame / r_lab_canister3_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister3 );
	objects_attach( dm_lab_crane, "lab_crane_hand", lab_canister3, "attach_point" );
	
	// Wait for it to get to the right spot to activate the information button	
	sleep_until( device_get_position( dm_lab_crane ) >= ( r_lab_canister3_detach_frame / r_lab_canister3_anim_max_frames ), 1 );
	objects_detach( dm_lab_crane, lab_canister3 );
	objects_attach( dm_lab_crane, "lab_cylinder_3", lab_canister3, "attach_point" );	
	device_set_power( device_control_lab_terminal3, 1.0 );
	f_blip_object( device_control_lab_terminal3, "default" );
	//objects_detach( dm_lab_crane, lab_canister3 );
	
	//thread( f_lab_crane_animation_done() );

	// Wait for the information button to be pressed
	sleep_until( device_get_position( device_control_lab_terminal3 ) > 0.0, 1 );
	device_set_power( device_control_lab_terminal3, 0.0 );
	f_unblip_object( device_control_lab_terminal3 );
	//dprint( "Lab crane narrative interaction #3" );
	
	// Finished, do not reactivate the crane control
	//device_set_power( device_control_lab_crane, 1.0 );
	//device_set_position( device_control_lab_crane, 0.0 );

end
*/

/*
script static void f_lab_crane_animation_done()

	// Wait until the animation is done	
	sleep_until( device_get_position( dm_lab_crane ) == 1.0 );
	b_lab_crane_animating = FALSE;

end	


script dormant f_lab_narrative_crane_idle()

	local real rand_time = -1.0;

	repeat
		rand_time = real_random_range( r_lab_crane_min_idle_delay, r_lab_crane_max_idle_delay );
		sleep_s( rand_time );
		if( b_lab_crane_animating == FALSE ) then
			//b_lab_crane_animating = TRUE;
			//dprint( "Lab crane idling" );
			// Maybe play the idle at different speeds each time?
			//device_set_position_track( dm_lab_crane, "vin_m80_sync_crane_idle", 0.0 );
			//device_animate_position( dm_lab_crane, 1.0, r_lab_crane_idle_time, r_lab_crane_idle_transition_time, r_lab_crane_idle_transition_time, TRUE );
			//thread( f_lab_crane_animation_done() );
		else
			sleep_until( b_lab_crane_animating == FALSE );
			// It'll wait until the other animation is done, then loop back to the top, meaning it'll wait a new random time before starting (so it doesn't idle right after having just finished an animation );
		end		

	until( device_get_position( dc_lab_exit ) > 0.0, 1 );

end
*/