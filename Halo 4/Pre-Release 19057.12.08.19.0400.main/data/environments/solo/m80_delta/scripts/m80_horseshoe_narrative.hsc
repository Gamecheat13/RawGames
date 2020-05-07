//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_horseshoe (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HORSESHOE: NARRATIVE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// === f_horseshoe_narrative_init::: Initialize
script dormant f_horseshoe_narrative_init()
	//dprint( "::: f_horseshoe_narrative_init :::" );
	
	// init sub modules
	
	wake( f_horseshoe_narrative_exit );
	wake( f_horseshoe_narrative_raise );
	wake( f_horseshoe_narrative_snipers );
	//thread(f_horseshoe_narrative_scientist_01());
	wake( f_horseshoe_narrative_wrong_platform );
	thread( f_horseshoe_narrative_scientist_01_trigger(humans_hs_center_oni_civ.spawn_points_1) );
	//thread( f_horseshoe_narrative_scientist_02_trigger(humans_hs_right_sci_flee.spawn_points_1) );
	thread( f_horseshoe_narrative_scientist_03_trigger(humans_hs_right_sci_flee.spawn_points_4) );
	thread( f_horseshoe_narrative_scientist_04_trigger(humans_hs_right_sci_flee.spawn_points_3) );
	thread( f_horseshoe_narrative_scientist_05_trigger(humans_hs_center_oni_civ.spawn_points_0) );
	//thread( f_horseshoe_narrative_scientist_06_trigger(humans_hs_right_sci_flee.spawn_points_2) );
	
	
end

// === f_horseshoe_narrative_deinit::: Deinitialize
script dormant f_horseshoe_narrative_deinit()
	//dprint( "::: f_horseshoe_narrative_deinit :::" );

	// kill functions
	kill_script( f_horseshoe_narrative_init );

	//kill scripts
	kill_script( f_horseshoe_narrative_exit );
	kill_script( f_horseshoe_narrative_raise );
	kill_script( f_horseshoe_narrative_snipers );
	kill_script( m80_horseshoe_scientist_shout );
	kill_script( f_horseshoe_narrative_nudge );
	kill_script( f_horseshoe_narrative_wrong_platform );

end

script dormant m80_horseshoe_scientist_shout()
	sleep_until( volume_test_players(m80_horseshoe_scientist_shout), 1 );
		wake( f_dialog_m80_horseshoe_scientist_02 );
		sleep_s(1);
		wake(f_dialog_m80_horseshoe_scientist_06);
end


// === m80_horseshoe_center_restock::: xxx
script dormant m80_horseshoe_center_restock()

		sleep_until( (volume_test_players(m80_horseshoe_center_restock_01) or volume_test_players(m80_horseshoe_center_restock_02) or volume_test_players(m80_horseshoe_center_restock_03) or volume_test_players(m80_horseshoe_center_restock_04)), 1 );
		  //dprint("m80_horseshoe_center_restock" );

					wake( f_dialog_m80_horseshoe_premature );

end

// === xxx::: xxx
/*script static void f_horseshoe_narrative_scientist_01()
	sleep_until( volume_test_players(m80_horseshoe_scientist_01), 1 );
		thread( f_dlg_scientist_01() );
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_scientist_03()
	sleep_until( volume_test_players(m80_horseshoe_scientist_03), 1 );
		thread( f_dlg_scientist_03() );
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_scientist_05()
	sleep_until( volume_test_players(m80_horseshoe_scientist_05), 1 );
		thread( f_dlg_scientist_05() );
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_scientist_04()
	sleep_until( volume_test_players(m80_horseshoe_hall_scientist_04), 1 );
	  thread( f_dlg_scientist_04() );
end*/

// === xxx::: xxx
script dormant f_horseshoe_narrative_snipers()
	sleep_until( volume_test_players(m80_horseshoe_snipers), 1 );
		wake( f_dialog_m80_horseshoe_snipers );
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_raise()
	sleep_until( volume_test_players(m80_horseshoe_raise) or volume_test_players(tv_hs_center_platform) or B_horseshoe_center_dropoffs_complete, 1 );
		wake( f_dialog_m80_horseshoe_raise );
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_exit()
  sleep_until( f_horseshoe_shield_control_activated() );
  wake(f_dialog_m80_shields_countdown);
		wake( f_dialog_m80_horseshoe_exit );
						kill_script(f_horseshoe_narrative_nudge);	
				sleep_forever(f_horseshoe_narrative_nudge);
end

// === xxx::: xxx
script dormant f_horseshoe_narrative_wrong_platform()
	sleep_until( volume_test_players(m80_horseshoe_wrong_platform), 1 );
		wake( f_dialog_m80_horseshoe_wrong_platform );
end

// === xxx::: xxx
script static void f_horseshoe_narrative_nudge()
	sleep_s( 90 );
		wake( f_dialog_m80_horseshoe_nudge );
end

// === xxx::: xxx
script dormant m80_shields_intro()
	sleep_until( volume_test_players(m80_shields_secure), 1 );
		wake( f_dialog_m80_horseshoe_intro );
		thread(f_horseshoe_narrative_nudge());
end
script dormant m80_thread_leave_vo()
	sleep_until( volume_test_players(tv_hs_spawn_center_phantom), 1 );
	
		wake(m80_horseshoe_center_restock);
end



script static void f_horseshoe_narrative_scientist_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_01 );
	end

end

script static void f_horseshoe_narrative_scientist_02_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_02 );
	end

end

script static void f_horseshoe_narrative_scientist_03_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, -1.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_03 );
	end

end


script static void f_horseshoe_narrative_scientist_04_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_04 );
	end

end



script static void f_horseshoe_narrative_scientist_05_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, -1.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_05 );
	end

end


script static void f_horseshoe_narrative_scientist_06_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, -1.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_horseshoe_scientist_06 );
	end

end