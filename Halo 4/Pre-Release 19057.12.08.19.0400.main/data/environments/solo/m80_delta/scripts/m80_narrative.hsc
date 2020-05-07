// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** DEBUG ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GLOBALS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// General editable values
global boolean shield_controls_on = FALSE;
global boolean b_disable_flipbooks_in_editor = TRUE;
global boolean b_play_blurbs = TRUE;
global real r_min_delay_between_overlapping_blurbs = 2.0;
//global real r_lab_crane_animation1_time = 23.3;
//global real r_lab_crane_animation2_time = 30.0;
//global real r_lab_crane_animation3_time = 30.0;
//global real r_lab_crane_start_transition_time = 0.05;
//global real r_lab_crane_end_transition_time = 0.05;
//global real r_lab_crane_min_idle_delay = 7.5;
//global real r_lab_crane_max_idle_delay = 25.0;
//global real r_lab_crane_idle_time = 5.0;
//global real r_lab_crane_idle_transition_time = 0.5;


// Non-editable values
global boolean b_blurb_up = FALSE;
global boolean b_blurb_low = FALSE;
global boolean b_blurb_bottom = FALSE;
global boolean b_blurb_high = FALSE;
global boolean b_blurb_top = FALSE;
global boolean b_lab_triedsewers = FALSE;
global boolean b_scientists_encounter = FALSE;
//global boolean b_lab_crane_animating = FALSE;
//global short r_lab_canister1_attach_frame = 90;
//global short r_lab_canister2_attach_frame = 160;
//global short r_lab_canister3_attach_frame = 90;
//global short r_lab_canister1_detach_frame = 480;
//global short r_lab_canister2_detach_frame = 480;
//global short r_lab_canister3_detach_frame = 460;
//global short r_lab_canister1_anim_max_frames = 658;
//global short r_lab_canister2_anim_max_frames = 748;
//global short r_lab_canister3_anim_max_frames = 649;
global boolean b_objective_1_complete = FALSE;
global boolean b_objective_2_complete = FALSE;
global boolean b_objective_3_complete = FALSE;
global boolean b_objective_4_complete = FALSE;
global boolean b_objective_5_complete = FALSE;
global boolean b_scientist_save = FALSE;
global boolean b_mantle_lab_object = FALSE;


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** START-UP ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script startup M80_narrative_main()
	sleep_until( b_mission_started, 1 );

	wake( f_narrative_drop_datapad_02 );
	wake( m80_covenant_resistance );
	//wake( m80_scientist_room );
	//wake( m80_prelab_supply );
	wake( m80_shields_intro );
	wake( m80_airlock_didact_contact );
	wake( m80_airlock_hallways_2 );
	wake( m80_airlock_2_call_bluff );
	wake( m80_prelab_hunter_callout );
	wake( m80_lookout_rampancy );
	wake( m80_atrium_return_hallway );
	wake( m80_prelab_composer );
//	wake( m80_button_lookout ); // TRIGGERED VAI PUPPETEER - TWF
	thread(m80_control_lab_terminal1());
	thread(m80_control_lab_terminal2());
	thread(m80_control_lab_terminal3());
	thread(m80_control_lab_terminal4());
	thread(m80_lab_halsey_audiolog());
	wake(m80_post_atrium);
	wake(m80_lookout_hallway);
		wake(m80_scientist_room_02);
	wake(m80_domain_terminal_setup);
	//wake(m80_elevator_composer_dialogue);
	//wake(f_lab_narrative_audiolog);
	wake(m80_scientist_room_03);
	wake(m80_enter_final_battle);
	wake( m80_horseshoe_scientist_shout );
	//wake(m80_quarantine_01);
	
end


// XXX MOVED OVER NARRATIVE SCRIPT ------------------------------------------------------------------------------
global real R_atrium_narrative_conversation_trigger_see_dist = 	7.5;
global real R_atrium_narrative_conversation_trigger_near_dist = 5.0;

script static boolean f_narrative_distance_trigger( object obj_character, real r_distance_see, real r_distance_near, real r_obj_sees_player_angle )

	// defaults
	if ( r_obj_sees_player_angle < 0.0 ) then
		r_obj_sees_player_angle = 25.0;
	end

	// condition
	( not ai_allegiance_broken(player, human) )
	and
	(
		( objects_distance_to_object(Players(),obj_character) <= r_distance_near )
		or
		(
			( objects_distance_to_object(Players(),obj_character) <= r_distance_near )
			and
			objects_can_see_object(Players(),obj_character,25.0)
		)
	)
	and
	(
		( r_obj_sees_player_angle <= 0.0 )
		or
		objects_can_see_player( obj_character, r_obj_sees_player_angle )
	);

end


// ================================================================================================
// ================================================================================================
// *** CLEAN-UP ***
// ================================================================================================
// ================================================================================================


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CINEMATICS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// Handled in m80_delta_insertion.hsc

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** VIGNETTES ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** RAMPANCY AND HUD FX ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// *** USE ***
// The frequency applies indirectly to a random number generator in global_narrative.hsc, so consider it more of a rough pass rather than anything precise (i.e - a 1.0 setting doesn't mean it'll be 1.0 seconds between bursts)
// The length also appears to be controlled that script

// cortana_hud_rampancy_loop_begin( string effect_type, real frequency_of_effect, real delay_before_starting_effect )


// ==========================================================================================================================================================
// *** TESTING ***
// ==========================================================================================================================================================
/*

// Disruption: Low (small distortion lines)
script static void test_rampancy_jammer()

	//dprint( "Starting rampancy test: jammer" );
	thread( cortana_hud_rampancy_loop_begin( "jammer", 0.01, 0.0 ) );

end


// Disruption: Low-Medium (tv signal noise)
script static void test_rampancy_warp()

	//dprint( "Starting rampancy test: warp" );
	thread( cortana_hud_rampancy_loop_begin( "warp", 0.01, 0.0 ) );

end


// Disruption: Medium
script static void test_rampancy_glitch()

	//dprint( "Starting rampancy test: glitch" );
	thread( cortana_hud_rampancy_loop_begin( "glitch", 0.01, 0.0 ) );

end


// Disruption: Medium-High
script static void test_rampancy_noise()

	//dprint( "Starting rampancy test: noise" );
	thread( cortana_hud_rampancy_loop_begin( "noise", 0.01, 0.0 ) );

end


// Disruption: High (more or less the same as glitch?)
script static void test_rampancy_static()

	//dprint( "Starting rampancy test: static" );
	thread( cortana_hud_rampancy_loop_begin( "static", 0.01, 0.0 ) );

end


script static void test_rampancy_stop()

	//dprint( "Stopping rampancy test" );
	cortana_hud_rampancy_loop_end();	

end
*/

// ==========================================================================================================================================================
// *** SCRIPTING ***
// ================================================================================================

//script dormant f_narrative_rampancy_lichride()
//
//	// Rampancy effect from the start
//	f_cortana_rampancy_set( DEF_S_CORTANA_RAMPANCY_STATE_RAMPANT(), DEF_S_CORTANA_RAMPANCY_TYPE_NONE() );
//	f_cortana_rampancy_loop_reset();
//	f_cortana_rampancy_loop_add( DEF_S_CORTANA_RAMPANCY_TYPE_JAMMER(), 0.01, 0.01, 0.0, 0.0 );
//	f_cortana_rampancy_loop_add( DEF_S_CORTANA_RAMPANCY_TYPE_WARP(), 0.004, 0.004, 5.0, 5.0 );
//
//end
//
///*
/*script dormant f_narrative_rampancy_atrium()

	f_cortana_rampancy_effect_time_set( 0.01, 0.01 );
	f_cortana_rampancy_random_delay_set( 0.0, 0.0 );
	f_cortana_rampancy_set( DEF_S_CORTANA_RAMPANCY_STATE_RAMPANT(), DEF_S_CORTANA_RAMPANCY_TYPE_STATIC() );
	f_cortana_rampancy_loop_reset();
	// Cortana gets it under control
	f_cortana_rampancy_state_set_timer( DEF_S_CORTANA_RAMPANCY_STATE_NORMAL(), 10.0 );
	f_cortana_rampancy_set( DEF_S_CORTANA_RAMPANCY_STATE_RAMPANT(), DEF_S_CORTANA_RAMPANCY_TYPE_NONE() );
	f_cortana_rampancy_loop_reset();
	f_cortana_rampancy_loop_add( DEF_S_CORTANA_RAMPANCY_TYPE_WARP(), 0.025, 0.025, 0.0, 0.0 );
	f_cortana_rampancy_loop_add( DEF_S_CORTANA_RAMPANCY_TYPE_NOISE(), 0.008, 0.008, 5.0, 5.0 );

end*/


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** BLURBS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

/*
script dormant f_VO_crash_thruster_intro()

	f_narrative_blurb( "blurb_vo_thruster_1", TRUE );
	f_narrative_blurb( "blurb_vo_thruster_2", TRUE );
	f_narrative_blurb( "blurb_vo_thruster_3", TRUE );

end
*/

/*
script dormant f_VO_to_lab_didactscan()

	f_narrative_blurb( "blurb_vo_didactscanfindschief_1", TRUE );
	f_narrative_blurb( "blurb_vo_didactscanfindschief_2", TRUE );
	f_narrative_blurb( "blurb_vo_didactscanfindschief_3", TRUE );
	f_narrative_blurb( "blurb_vo_didactscanfindschief_4", TRUE );

end
*/


/*
script static void f_VO_lab_scientists()

	f_narrative_blurb( "blurb_vo_lab_scene_1", TRUE );
	f_narrative_blurb( "blurb_vo_lab_scene_2", TRUE );
	
end
*/

/*
script dormant f_VO_lab_hunters()

	sleep_s( 1.5 );
	f_narrative_blurb( "blurb_vo_lab_hunters_1", TRUE );
	f_narrative_blurb( "blurb_vo_lab_hunters_2", TRUE );
	wake( f_VO_lab_sewers );
	wake( f_VO_lab_triedsewers );

end


script dormant f_VO_lab_sewers()

	sleep_s( 25.0 );
	if( b_lab_triedsewers == FALSE ) then
		f_narrative_blurb( "blurb_vo_lab_sewers1", FALSE );
	end
	
end


script dormant f_VO_lab_triedsewers()

//	sleep_until( volume_test_players( tv_lab_underneath_center ) or volume_test_players( tv_under_lab_hatch5 ) );
	sleep_until( FALSE ); // XXX cannot go underneath anymore
	b_lab_triedsewers = TRUE;
	f_narrative_blurb( "blurb_vo_lab_sewers2", FALSE );

end
*/


/*
script dormant f_VO_lab_hunterdown()

	sleep_until( ai_living_count( sg_lab_hunters ) == 1, 1 );
	f_narrative_blurb( "blurb_vo_lab_hunterdown1", TRUE );
	f_narrative_blurb( "blurb_vo_lab_hunterdown2", TRUE );
	
end
*/


/*
script dormant f_VO_creepy_scan_is_creepy()

	sleep_s( 5.0 );
	f_narrative_blurb( "blurb_vo_didact_scan_creeped_out", TRUE );

end
*/


/*
script dormant f_VO_atrium_leavingdelay()

	sleep_s( 90.0 );
	if( b_atrium_exited == FALSE ) then
		f_narrative_blurb( "blurb_vo_atrium_leavingdelay1", FALSE );
	end
	sleep_s( 45.0 );
	if( b_atrium_exited == FALSE ) then	
		f_narrative_blurb( "blurb_vo_atrium_leavingdelay2", FALSE );
	end	
	
end
*/



/*
script static void f_VO_airlock_locked()

	f_narrative_blurb( "blurb_vo_hallways_airlock_button_used", FALSE );

end
*/


/*
script dormant humans_to_airlock_two_runners_vo()

	f_narrative_blurb( "blurb_vo_hallways_toairlocktwo_1", TRUE );
	f_narrative_blurb( "blurb_vo_hallways_toairlocktwo_2", TRUE );
	f_narrative_blurb( "blurb_vo_hallways_toairlocktwo_3", TRUE );

end
*/


/*
script static void f_VO_airlock_explanation()

	f_narrative_blurb( "blurb_vo_hallways_airlockuse", TRUE );

end
*/


/*
script static void f_VO_lookout()

	f_narrative_blurb( "blurb_vo_guns_console_1", TRUE );
	
end
*/


/*
script dormant f_VO_guns_didact_mockery()

	wake(f_dialog_lookout_hallway);
	
end
*/

/*
script static void f_VO_enteredatriumreturn()

	f_narrative_blurb( "blurb_vo_enteredatriumreturn1", TRUE );
	f_narrative_blurb( "blurb_vo_enteredatriumreturn2", TRUE );
	f_narrative_blurb( "blurb_vo_enteredatriumreturn3", TRUE );
	
end
*/





// ==========================================================================================================================================================
// *** BLURB DEFINITIONS ***
// ==========================================================================================================================================================


// Because the level scripts are "requesting" a blurb rather than playing it directly, removing a blurb can be done entirely in the 'm80_narrative' scenario and script WITHOUT breaking the level script calling it.  
// This is just in case the level script is checked out when a blurb needs to be changed or removed.
/*
script static void f_narrative_blurb( string blurb_name, boolean b_sleep_after )

	local string str_height = "";
	str_height = f_narrative_get_text_height();
	f_narrative_set_text_height( str_height );
	
	if( b_play_blurbs == FALSE ) then
		blurb_name = "";
	end	
	
	// If the requested blurb_name doesn't exist or doesn't match, it doesn't get played; disabling a blurb can be as simple as commenting out the appropriate lines below -- this can be done without risk of breaking the level scripts.  (See below)

	if( blurb_name == "blurb_vo_lookout_hitbutton" ) then		
		wake( f_dialog_lookout_rampancy );
	end
	
	//if( blurb_name == "blurb_b_to_continue" ) then
	//	story_blurb_add( str_height, "Press B to continue" );
	//end	




	if( b_sleep_after ) then
		sleep_s( 5.0 );
		f_narrative_blurb_finished();		
	end

	f_narrative_clear_text_height( str_height );
		
end

script static void f_narrative_blurb_finished()

	sleep_s( r_min_delay_between_overlapping_blurbs );
	b_blurb_up = FALSE;

end


script static string f_narrative_get_text_height()

	local string str_type_get = "";

	// Top: "other"
	// High: "domain"
	// Low: "vo"
	// Bottom: "cutscene"	

	if( b_blurb_low == FALSE ) then
		str_type_get = "vo";
	elseif( b_blurb_bottom == FALSE ) then
		str_type_get = "cutscene";
	elseif( b_blurb_high == FALSE ) then
		str_type_get = "domain";
	elseif( b_blurb_top == FALSE ) then
		str_type_get = "other";
	else
		str_type_get = "";
	end
	
	str_type_get;

end


script static void f_narrative_set_text_height( string str_type_set )

	if( str_type_set == "vo" ) then
		b_blurb_low = TRUE;
	elseif( str_type_set == "cutscene" ) then
		b_blurb_bottom = TRUE;
	elseif( str_type_set == "domain" ) then
		b_blurb_high = TRUE;
	elseif( str_type_set == "other" ) then
		b_blurb_top = TRUE;
	end
	
end


script static void f_narrative_clear_text_height( string str_type_clear )

	if( str_type_clear == "vo" ) then
		b_blurb_low = FALSE;
	elseif( str_type_clear == "cutscene" ) then
		b_blurb_bottom = FALSE;
	elseif( str_type_clear == "domain" ) then
		b_blurb_high = FALSE;
	elseif( str_type_clear == "other" ) then
		b_blurb_top = FALSE;
	end
	
end


script static void f_narrative_start_pip()
	Hud_play_pip("TEMP_PIP_TILLSON" );   
	pip_on();
	sleep_s( 0.5 );

end


script static void f_narrative_stop_pip()
  Hud_play_pip("" );  
	sleep_s( 1.0 );
	pip_off();

end
*/


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** NARRATIVE DROPS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// ==========================================================================================================================================================
// *** HORSESHOE ***
// ==========================================================================================================================================================


script dormant f_narrative_drop_datapad_02()

	sleep_until( ai_living_count( sq_hs_building_roof_2a ) > 0, 1 );
	//dprint( "M80_NARRATIVE: spawned the datapad squad" );
	//unit_set_equipment( sq_hs_building_roof_2.spawn_points_1, "objects\equipment\story_drops\story_drop_m80.equipment", TRUE, FALSE, FALSE );

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ENVIRONMENTAL STORYTELLING ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// ==========================================================================================================================================================
// *** LAB ***
// ==========================================================================================================================================================
// MOVED TO: m80_lab_narrative.hsc



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** NARRATIVE OUTLINE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


















/*
script dormant m80_tillson_contact()
		thread (story_blurb_add("other", "CHIEF SPEAKS WITH TILLSON, WHO LETS HIM KNOW THEY CAN'T EVACUATE BECAUSE THEY'VE LOST CONTROL OF PARTS OF THE STATION. CHIEF SAYS HE WILL HELP.") );
end
*/


script dormant m80_prelab_composer()
		sleep_until( volume_test_players(m80_prelab_composer), 1 );
		effect_new( environments\solo\m80_delta\fx\scan\dscan_horseshoe.effect, fx_horsehoe_didact_scan );
		sleep_s( 10 );
		wake( f_dialog_m80_prelab_composer );
end

script dormant m80_airlocks_scientist_didact_scan()
		effect_new( environments\solo\m80_delta\fx\scan\dscan_post_airlock.effect, fx_airlocks_scientist_didact_scan );
		

end



script dormant m80_airlock_1_didact_scan()
		effect_new( environments\solo\m80_delta\fx\scan\dscan_post_airlock.effect, fx_airlock_1_didact_scan );


end





script dormant m80_covenant_resistance()
		sleep_until( volume_test_players(m80_covenant_resistance), 1 );
		effect_new( environments\solo\m80_delta\fx\scan\dscan_post_atrium.effect, fx_airlock_1_hall_didact_scan );		
			
			
		  wake( f_dialog_m80_airlock_hallways_1 );

end

script dormant m80_prelab_supply()
		sleep_until( volume_test_players(tv_to_lab_scan), 1 );
		hud_rampancy_players_set( 0.25 );
		sleep_s(3);
		hud_rampancy_players_set( 0.0 );

			

end
script dormant m80_prelab_hunter_callout()
		sleep_until( volume_test_players(f_dialog_m80_lab_hunter), 1 );
			wake( f_dialog_m80_lab_hunter );
			wake (f_dialog_m80_lab_scientist_03);

end

script dormant m80_lab_announcement()
		sleep_until( volume_test_players(m80_lab_announcement), 1 );
			wake( f_dialog_m80_lab_announcement );
		
end
/*
script dormant m80_quarantine_01()
		sleep_until( volume_test_players(m80_quarantine_01), 1 );
			wake( f_dialog_m80_quarantine_on );
		
end
*/


script static void m80_control_lab_terminal1()
 			sleep_until ( object_valid(device_control_lab_terminal1) and (device_get_position(device_control_lab_terminal1) != 0) );
			
			thread( f_dialog_m80_lab_specimen_fr_2006());
			object_destroy( device_control_lab_terminal1 );
end

script static void m80_control_lab_terminal2()
			sleep_until ( object_valid(device_control_lab_terminal2) and (device_get_position(device_control_lab_terminal2) != 0) );
   
			thread( f_dialog_m80_lab_specimen_fr_0815 ());
			object_destroy( device_control_lab_terminal2);
end

script static void m80_control_lab_terminal3()
			sleep_until ( object_valid(device_control_lab_terminal3) and (device_get_position(device_control_lab_terminal3) != 0) );

			thread( f_dialog_m80_findings_abstract_fr_1534 ());
			object_destroy( device_control_lab_terminal3);
end

script static void m80_control_lab_terminal4()
			sleep_until ( object_valid(device_control_lab_terminal4) and (device_get_position(device_control_lab_terminal4) != 0) );

			thread( f_dialog_m80_lab_computer_04());
			object_destroy( device_control_lab_terminal4);
end


script static void m80_lab_halsey_audiolog()

			sleep_until ( object_valid(device_control_lab_audiolog_sw) and (device_get_position(device_control_lab_audiolog_sw) != 0) );
     
			thread( f_dialog_m80_lab_halsey_audiolog());
			object_destroy(device_control_lab_audiolog_sw);
			
		//	sleep_s(30);
		//	device_set_power( device_control_lab_audiolog_sw, 1.0 );
		//	device_set_position( device_control_lab_audiolog_sw, 0.0 );
end


script dormant m80_domain_terminal_setup()
	f_narrative_domain_terminal_setup( 5, domain_terminal, domain_terminal_button );
end

// === f_activator_get::: For some strange reason device controls point to this function
script static void f_activator_get( object obj_control, unit u_activator )

	if ( obj_control == domain_terminal_button ) then
		f_narrative_domain_terminal_interact( 5, domain_terminal, domain_terminal_button, u_activator, 'pup_domain_terminal' );
	end
	
end

script static void f_atrium_narrative_marine_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_atrium_narrative_conversation_trigger_see_dist, R_atrium_narrative_conversation_trigger_near_dist, -1.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m80_post_atrium );
	end

end


script dormant m80_prelab_door_controls()
				
				wake( f_dialog_m80_prelab_door_controls );
				sleep_s(2);
				wake(f_dialog_m80_lab_scientist_05);
				sleep_s(3);
				wake(f_dialog_m80_lab_scientist_01);
				
end



script dormant m80_post_atrium()
		sleep_until( volume_test_players(m80_post_atrium), 1 );
//	wake( f_dialog_m80_post_atrium );
	
end


/*
script static void m80_airlock_covenant_assault()

		thread( f_dialog_m80_airlock_covenant_assault());

end
*/

script dormant m80_airlock_didact_contact()
		sleep_until( volume_test_players(m80_airlock_didact_contact), 1 );
		//wake( f_dialog_m80_airlock_didact_contact );

end

script dormant m80_airlock_hallways_2()
		sleep_until( volume_test_players(m80_airlock_hallways_2), 1 );
		wake( f_dialog_m80_airlock_hallways_2 );
		sleep_s(2);
		wake( f_dialog_m80_airlock_hallways_scientist_01 );
		sleep_s(2);
		wake( f_dialog_m80_airlock_hallways_scientist_01b);
end


/*script dormant m80_scientist_room()
		sleep_until( volume_test_players(m80_scientist_room), 1 );
	 // wake( f_dialog_m80_airlock_hallways_scientist_01 );
		wake(m80_airlocks_scientist_didact_scan);
end*/



script dormant m80_scientist_room_02()
		sleep_until( volume_test_players(m80_scientist_room), 1 );
	  wake( f_dialog_m80_airlock_hallways_scientist_02 );

end



script dormant m80_scientist_room_03()
		sleep_until( volume_test_players(m80_scientist_room_01), 1 );	
		
			if (ai_living_count(sg_to_airlock_two_protect) > 0) then
				wake( f_dialog_airlock_hallways_2_rescue );
			end
			sleep_forever(m80_scientist_room_02);
			b_scientist_save = TRUE;
end

script dormant m80_lookout_rampancy()
		sleep_until( volume_test_players(m80_lookout_rampancy), 1 );
	  wake( f_dialog_lookout_rampancy );

end



script dormant m80_airlock_2_call_bluff()
		sleep_until( volume_test_players(m80_airlock_2_call_bluff), 1 );
	  wake( f_dialog_m80_airlock_2_call_bluff );

end


script dormant m80_airlock_2_system_lockdown()
		dprint("");
	  //wake( f_dialog_airlock_2_system_lockdown );

end



script dormant m80_lookout_hallway()
		sleep_until( volume_test_players(m80_lookout_hallway), 1 );	  
		effect_new( environments\solo\m80_delta\fx\scan\dscan_hall_pre_lookout.effect, fx_lookout_didact_scan );		
	  
		sleep_s(1);
		wake( f_dialog_lookout_hallway );
		sleep_s(1);
		wake(f_dialog_m80_ivanoff_pa_01);
end



script dormant m80_atrium_return_hallway()
		sleep_until( volume_test_players(m80_atrium_return_hallway), 1 );		
	  wake( f_dialog_atrium_return_hallway );
	  sleep_s(10);
	  wake(f_dialog_m80_ivanoff_pa_03);

end




script dormant m80_atrium_return_covenant()
		//dprint("COVENANT LINES BEING WOKEN");
	  wake( f_dialog_atrium_return_covenant );

end

script dormant m80_atrium_return_covenant_02()
		//dprint("COVENANT LINES 2 BEING WOKEN");
	  wake( f_dialog_atrium_return_covenant_02);
	  wake( f_dialog_atrium_return_covenant_03);

end



script dormant m80_airlock_2_back_online()
			sleep_until( volume_test_players(airlock_2_doors), 1 );
	  wake( f_dialog_airlock_2_back_online );

end


script dormant m80_covenant_chanting()
local boolean b_entered = FALSE;

//	sleep_until( volume_test_players(tv_atrium_return_entered) or (door_atrium_lookout_enter_maya->position_open_check() and volume_test_players_lookat(tv_composer_see, 50.0, 5.0)), 1 );
	sleep_until( volume_test_players(tv_atrium_return_entered) or (device_get_position(door_atrium_lookout_enter_maya) >= 1.0), 1 );
	b_entered = volume_test_players( tv_atrium_return_entered );
	wake( f_dialog_m80_atrium_battle_06 );
	sleep_s( 1.0 );

	sleep_until( b_entered or volume_test_players(tv_atrium_return_entered), 1 );
	effect_new( environments\solo\m80_delta\fx\scan\dscan_atrium_return.effect, composer_didact_1 );
	wake( f_dialog_atrium_battle );
	wake( f_atriumreturn_starting_sequence ); // don't show chapter title/set objective until the player goes through the doors
	wake(m80_ivanoff_pa_05);

end

script dormant m80_ivanoff_pa_05()
	sleep_until( volume_test_players(m80_ivanoff_pa_05), 1 );
	
	 wake(f_dialog_m80_ivanoff_pa_05);
end



/*

script dormant m80_elevator_composer_dialogue()

			sleep_until ( object_valid(dc_elevator_start) and (device_get_position(dc_elevator_start) != 0) );
     //dprint("m80_elevator_composer_dialogue");
     wake(f_dialog_atrium_vignette);
		
		
end
*/


script dormant m80_enter_final_battle()
		sleep_until( volume_test_players(m80_enter_final_battle) and (zoneset_current() >= S_ZONESET_ATRIUM_LOOKOUT), 1 );
		wake( f_dialog_m80_atrium_battle_01 );

			

end


/*


thread (story_blurb_add("other", "IN THE LAB, A STORAGE DEVICE REVEALS SEVERAL ARTIFACTS TO THE CHIEF.") );

thread (story_blurb_add("other", "INSIDE THE LAB'S OFFICE, THERE IS A DATAPAD BELONGING TO DR. HALSEY.") );











thread (story_blurb_add("other", "THE SHIP'S POWER GOES DOWN.") );




thread (story_blurb_add("other", "THE COVENANT ARE CHANTING.") );



*/



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// NUDGES
// ==========================================================================================================================================================
// ==========================================================================================================================================================

/*
script static void m80_objective_1_nudge()
			//dprint("Nudge fired" );
			sleep_s(900 );
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m80_nudge_1() );
			end
				if b_objective_1_complete == FALSE then
					thread( m80_objective_1_nudge() );
			end
end

script static void m80_objective_2_nudge()
			//dprint("Nudge fired" );
			sleep_s(900 );
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m80_nudge_2() );
			end
				if b_objective_1_complete == FALSE then
					thread( m80_objective_2_nudge() );
			end
end


script static void m80_objective_3_nudge()
			//dprint("Nudge fired" );
			sleep_s(900 );
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m80_nudge_3() );
			end
				if b_objective_1_complete == FALSE then
					thread( m80_objective_3_nudge() );
			end
end


script static void m80_objective_4_nudge()
			//dprint("Nudge fired" );
			sleep_s(900 );
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m80_nudge_4() );
			end
				if b_objective_1_complete == FALSE then
					thread( m80_objective_4_nudge() );
			end
end



script static void m80_objective_5_nudge()
			//dprint("Nudge fired" );
			sleep_s(900 );
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m80_nudge_5() );
			end
				if b_objective_1_complete == FALSE then
					thread( m80_objective_5_nudge() );
			end
end
*/

// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


/*
script static void f_waypoint_equipment_unlock()
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
	, 1);	
			if IsNarrativeFlagSetOnAnyPlayer(51) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 51, TRUE );
					//dprint("Active Camo acquired");

			end
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_active_shield\storm_active_shield.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_shield\storm_active_shield.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_shield\storm_active_shield.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_shield\storm_active_shield.equipment")
	, 1);	
			if IsNarrativeFlagSetOnAnyPlayer(52) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 52, TRUE );
					//dprint("Active Shield acquired");

			end
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision.equipment")
	, 1);		
	
			if IsNarrativeFlagSetOnAnyPlayer(49) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 49, TRUE );
					//dprint("Forerunner Vision acquired");

			end
	
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_hologram\storm_hologram.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_hologram\storm_hologram.equipment")
	, 1);		
			if IsNarrativeFlagSetOnAnyPlayer(53) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 53, TRUE );
					//dprint("Hologram acquired");

			end
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_jet_pack\storm_jet_pack.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_jet_pack\storm_jet_pack.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_jet_pack\storm_jet_pack.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_jet_pack\storm_jet_pack.equipment")
	, 1);		
			if IsNarrativeFlagSetOnAnyPlayer(50) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 50, TRUE );
					//dprint("Jet Pack acquired");

			end
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_auto_turret\storm_auto_turret.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_auto_turret\storm_auto_turret.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_auto_turret\storm_auto_turret.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_auto_turret\storm_auto_turret.equipment")
	, 1);					
			if IsNarrativeFlagSetOnAnyPlayer(54) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 54, TRUE );
					//dprint("Auto Turret acquired");

			end
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment")
	, 1);	
				
			if IsNarrativeFlagSetOnAnyPlayer(55) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 55, TRUE );
					//dprint("Thruster Pack acquired");
			end
end
*/