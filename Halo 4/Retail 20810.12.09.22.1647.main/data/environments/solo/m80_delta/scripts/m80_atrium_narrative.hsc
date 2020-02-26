//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_atrium (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ATRIUM: NARRATIVE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean b_atrium_shuttle_destroyed = 						FALSE;

// === f_atrium_narrative_init::: Initialize
script dormant f_atrium_narrative_init()
	//dprint( "::: f_atrium_narrative_init :::" );

	// init sub modules
	wake( f_atrium_narrative_scan_init );
	
	thread( f_atrium_narrative_science_1());
	thread( f_atrium_narrative_science_2());
	thread( f_atrium_narrative_science_3());
	thread( f_atrium_narrative_science_4());
	thread( f_atrium_narrative_science_5());
	

	// setup trigger
	wake( f_atrium_narrative_trigger );
	dprint("f_atrium_narrative_trigger initiated");
	// setup conversations
	/*
	NOTE: SCIENTISTS HAVE BEEN REMOVED FROM THIS AREA
	thread( f_atrium_narrative_scientist_01_trigger(sq_atrium_scientists.convo1_male_01) );
	thread( f_atrium_narrative_scientist_01_trigger(sq_atrium_scientists.convo1_female_01) );
	thread( f_atrium_narrative_scientist_01_trigger(sq_atrium_marines.convo1_marine_01) );

	thread( f_atrium_narrative_scientist_02_trigger(sq_atrium_scientists.convo2_male_01) );
	thread( f_atrium_narrative_scientist_02_trigger(sq_atrium_scientists.convo2_male_02) );

	thread( f_atrium_narrative_scientist_03_trigger(sq_atrium_scientists.convo3_female_01) );
	thread( f_atrium_narrative_scientist_03_trigger(sq_atrium_scientists.convo3_male_01) );
	thread( f_atrium_narrative_scientist_03_trigger(sq_atrium_scientists.convo3_male_02) );
	thread( f_atrium_narrative_scientist_03_trigger(sq_atrium_marines.convo3_marine_01) );
	thread( f_atrium_narrative_scientist_03_trigger(sq_atrium_marines.convo3_marine_02) );

	thread( f_atrium_narrative_scientist_04_trigger(sq_atrium_scientists.convo4_male_01) );
	thread( f_atrium_narrative_scientist_04_trigger(sq_atrium_scientists.convo4_male_02) );

	thread( f_atrium_narrative_scientist_05_trigger(sq_atrium_scientists.convo5_female_01) );
	*/

	thread( f_atrium_narrative_mantis_01_trigger(sq_atrium_marines.convo_mech_02_marine_01) );
	thread( f_atrium_narrative_mantis_inversion_trigger(sq_atrium_marines.convo_mech_03_marine_01) );
	

end

// === f_atrium_narrative_deinit::: Deinitialize
script dormant f_atrium_narrative_deinit()
	//dprint( "::: f_atrium_narrative_deinit :::" );

	// deinit sub modules
	wake( f_atrium_narrative_scan_deinit );  

	// kill functions
	kill_script( f_atrium_narrative_init );
	kill_script( f_atrium_narrative_trigger );

	kill_script( f_atrium_narrative_science_1 );
	kill_script( f_atrium_narrative_science_2 );
	kill_script( f_atrium_narrative_science_3 );
	kill_script( f_atrium_narrative_science_4 );
	kill_script( f_atrium_narrative_science_5 );
	
	
	kill_script( f_atrium_narrative_scientist_01_trigger );
	kill_script( f_atrium_narrative_scientist_02_trigger );
	kill_script( f_atrium_narrative_scientist_03_trigger );
	kill_script( f_atrium_narrative_scientist_04_trigger );
	kill_script( f_atrium_narrative_scientist_05_trigger );
	kill_script( f_atrium_narrative_mantis_01_trigger );
	kill_script( f_atrium_narrative_mantis_inversion_trigger );

end

// === f_atrium_narrative_trigger::: Deinitialize
script dormant f_atrium_narrative_trigger()
local long l_timer = 0;
	//dprint( "::: f_atrium_narrative_trigger :::" );

	// hallway dialog
	sleep_until( volume_test_players(m80_atrium_hallway), 1 );
	dprint("f_atrium_narrative_trigger narrative function fired");
	wake(f_dialog_m80_atrium_hallway);
	
	//dprint("");
	
	// enterance dialog
	sleep_until( volume_test_players(atrium_chapter_int), 1 );
	thread( f_chapter_title_atrium() );

	// screenshake event
	l_timer = timer_stamp( 60.0 );
	sleep_until( volume_test_players(tv_atrium_entered_event) or timer_expired(l_timer) or ((zoneset_timer_current() == S_ZONESET_ATRIUM_HUB) and zoneset_timer_expired(30.0)), 1 );
	b_atrium_shuttle_destroyed = TRUE;
	l_timer = timer_stamp( 3.0, 5.0 );
	
	sleep_until( timer_expired(l_timer) and (not dialog_foreground_active_check()), 1 );
	// delay; extra delay in case it's coming straight out of dialog
	sleep_s( 2.00, 2.50 );
	
	// shake for shuttle destruction
	f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH() * 1.125, -1.5, -1, -6.5, f_sfx_atrium_shuttle_destruction_first() );
	
	// dialog
	sleep_s( 0.25, 0.50 );
	wake( f_dialog_m80_atrium_defenses_offline );	

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: NARRATIVE: SCAN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_atrium_narrative_scan_init::: Init
script dormant f_atrium_narrative_scan_init()
	//dprint( "::: f_atrium_narrative_scan_init :::" );
	
	// setup trigger
	wake( f_atrium_narrative_scan_trigger );
	
end

// === f_atrium_narrative_scan_deinit::: Deinit
script dormant f_atrium_narrative_scan_deinit()
	//dprint( "::: f_atrium_narrative_scan_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_narrative_scan_init );
	kill_script( f_atrium_narrative_scan_trigger );
	kill_script( f_atrium_narrative_scan_action );
	
end

// === f_atrium_narrative_scan_trigger::: Trigger
script dormant f_atrium_narrative_scan_trigger()
	sleep_until( object_valid(door_mechroom_interior_right) and (device_get_position(door_mechroom_interior_right) > 0.0), 1 );
	//dprint( "::: f_atrium_narrative_scan_trigger :::" );
	
	// action
	//wake( f_atrium_narrative_scan_action );

end

// === f_atrium_narrative_scan_action::: Action
script dormant f_atrium_narrative_scan_action()
	//dprint( "::: f_atrium_narrative_scan_action :::" );
	
	// play scan
	sleep_s(3);
	sleep_s( 0.875, 1.25 );
	//thread( f_fx_composer_scan() );
	
end

script static void f_atrium_narrative_scientist_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_atrium_scientist_01 );
	end

end
   
script static void f_atrium_narrative_scientist_02_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_atrium_scientist_02 );
	end

end

script static void f_atrium_narrative_scientist_03_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_atrium_scientist_03 );
	end

end

script static void f_atrium_narrative_scientist_04_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_atrium_scientist_04 );
	end

end

script static void f_atrium_narrative_scientist_05_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_atrium_scientist_05 );
	end

end

script static void f_atrium_narrative_mantis_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_mantis_scientist_01 );
	end

end

script static void f_atrium_narrative_mantis_02_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_mantis_scientist_02 );
	end

end

script static void f_atrium_narrative_mantis_inversion_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );

	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_mantis_inversion_01 );
	end

end

script static void f_atrium_narrative_button_wait( object_name dc_button )

	sleep_until( object_valid(dc_button) );
	object_hide( dc_button, TRUE );
	device_set_power( device(dc_button), 1.0 );
	sleep_until ( device_get_position(device(dc_button)) != 0, 1 );
	device_set_power( device(dc_button), 0.0 );

end

script static void f_atrium_narrative_science_1()
	sleep_until ( object_valid( device_control_atrium_science1 ) and (device_get_position( device_control_atrium_science1 ) != 0) );

	//dprint( "::: f_atrium_narrative_science_1: ACTIVATED :::" );
	thread(f_dialog_m80_atrium_computer_01());
	object_destroy(device_control_atrium_science1);
	
	
end

script static void f_atrium_narrative_science_2()
	sleep_until ( object_valid( device_control_atrium_science2 ) and (device_get_position( device_control_atrium_science2 ) != 0) );
	
	//dprint( "::: f_atrium_narrative_science_2: ACTIVATED :::" );
	thread(f_dialog_m80_atrium_computer_02());
	object_destroy(device_control_atrium_science2);
end

script static void f_atrium_narrative_science_3()
	sleep_until ( object_valid( device_control_atrium_science3 ) and (device_get_position( device_control_atrium_science3 ) != 0) );
	
	//dprint( "::: f_atrium_narrative_science_3: ACTIVATED :::" );
	thread(f_dialog_m80_atrium_computer_03());
  object_destroy(device_control_atrium_science3);
end

script static void f_atrium_narrative_science_4()
	sleep_until ( object_valid( device_control_atrium_science4 ) and (device_get_position( device_control_atrium_science4 ) != 0) );
	
	//dprint( "::: f_atrium_narrative_science_4: ACTIVATED :::" );
	thread(f_dialog_m80_atrium_computer_04());
 	object_destroy(device_control_atrium_science4);
end

script static void f_atrium_narrative_science_5()
	sleep_until ( object_valid( device_control_atrium_science5 ) and (device_get_position( device_control_atrium_science5 ) != 0) );
	
	//dprint( "::: f_atrium_narrative_science_5: ACTIVATED :::" );
	thread(f_dialog_m80_atrium_computer_05());
	object_destroy(device_control_atrium_science5);
	
end
