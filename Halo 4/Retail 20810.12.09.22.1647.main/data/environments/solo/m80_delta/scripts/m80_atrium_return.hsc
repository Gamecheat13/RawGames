;343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
;
; Mission: 					m80_delta
;	Insertion Points:	atrium return (iar)
;										
;343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343


// ================================================================================================
// ================================================================================================
// *** TABLE OF CONTENTS ***
// ================================================================================================
// ================================================================================================
//
// ================================================================================================
// *** DEBUG ***
// ================================================================================================
//
// ================================================================================================
// *** GLOBALS ***
// *** START-UP ***
// *** CLEAN-UP ***
// ================================================================================================
//
// ================================================================================================
// *** WAVE SCRIPTING ***
// *** WAVE 1 ***
// *** WAVE 2 ***
// *** WAVE 3 ***
// *** WAVE 4 ***
// *** WAVE 5 ***
// *** ENCOUNTER SCRIPTING ***
// *** CASE: PLAYER IN BANSHEE ***
// *** CASE: PLAYER ON A TURRET ***
// *** COMMAND SCRIPTS ***
// *** PHANTOM SCRIPTS ***
// *** DROP-OFF SCRIPTS ***
// *** EXIT SCRIPTS ***
// *** LEGACY EXIT SCRIPTS - NEED REVIEW AND POLISH ***
// ================================================================================================
//
// ================================================================================================
// *** PLAYER TRACKING ***
// *** SAVING ***
// *** VO ***
// ================================================================================================


// =================================================================================================
// =================================================================================================
// *** DEBUG ***
// =================================================================================================
// =================================================================================================


global short DEBUG_coop_player_count = 4;


script static short f_atriumreturn_get_player_count()

	if( DEBUG_coop_player_count > 0 ) then
		DEBUG_coop_player_count;
	else
		game_coop_player_count();
	end

end


script continuous f_atriumreturn_playerkillvolume()

	if( volume_test_object( tv_atrium_playerkillvolume, player0 ) ) then
		//dprint( "Player0 touched kill volume" );
		unit_kill( player0 );
	elseif( volume_test_object( tv_atrium_playerkillvolume, player1 ) ) then
		//dprint( "Player1 touched kill volume" );
		unit_kill( player1 );
	elseif( volume_test_object( tv_atrium_playerkillvolume, player2 ) ) then
		//dprint( "Player2 touched kill volume" );
		unit_kill( player2 );
	elseif( volume_test_object( tv_atrium_playerkillvolume, player3 ) ) then
		//dprint( "Player3 touched kill volume" );
		unit_kill( player3 );
	end

end


// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================


// General editable values
global short s_atriumreturn_ai_max_count = 24;
global short s_atriumreturn_ai_lod_count = 25;
global short s_atriumreturn_simultaneous_banshee_count = 3;
global short s_atriumreturn_banshee_reset_count = 0;

global real r_atriumreturn_delay_before_wave2_group2 = 30.0;
global real r_atriumreturn_delay_before_wave4_group2 = 30.0;
global real r_atriumreturn_delay_before_wave4_group3 = 25.0;
global real r_atriumreturn_delay_before_wave5_group2 = 30.0;
global short s_atriumreturn_alive_to_start_ending_wave1 = 10;
global short s_atriumreturn_alive_to_start_ending_wave2 = 8;
global short s_atriumreturn_alive_to_start_ending_wave3 = 5;
global short s_atriumreturn_alive_to_start_ending_wave4 = 5;
global real r_atriumreturn_wave5_retreat_timer = 30.0;


// Non-editable values
global short s_objcon_m80_atriumreturn = -1;
global boolean b_atrium_returns_has_begun = FALSE;
global boolean b_atrium_finished = FALSE;
global boolean b_return_mech_1_occupied = FALSE;
global boolean b_return_mech_2_occupied = FALSE;
global boolean b_return_turret_1_occupied = FALSE;
global boolean b_return_turret_2_occupied = FALSE;
global boolean b_return_turret_3_occupied = FALSE;
global boolean b_return_player0_in_banshee = FALSE;
global boolean b_return_player1_in_banshee = FALSE;
global boolean b_return_player2_in_banshee = FALSE;
global boolean b_return_player3_in_banshee = FALSE;
global boolean b_return_player_in_back = FALSE;
global boolean b_return_player_in_right = FALSE;
global boolean b_return_player_in_center = FALSE;
global boolean b_return_player_in_left = FALSE;
global boolean b_return_player_in_front = FALSE;
global boolean b_targets_prioritized = FALSE;


// DEFINES
global short S_OBJCON_BACK_RIGHT = 0;
global short S_OBJCON_BACK_MIDDLE = 1;
global short S_OBJCON_BACK_LEFT = 2;
global short S_OBJCON_CENTER_RAMP = 3;
global short S_OBJCON_CENTER_TOP = 4;
global short S_OBJCON_CENTER_FRONT = 5;
global short S_OBJCON_RIGHT = 6;
global short S_OBJCON_LEFT_BACK = 7;
global short S_OBJCON_LEFT_FRONT = 8;
global short S_OBJCON_FRONT = 9;


// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================


script startup m80_atrium_return_mission()
	sleep_until( b_mission_started, 1 );
	// Wait until players reach the space before initializing scripts
	wake( f_atriumreturn_init );
end

script dormant f_atriumreturn_init()
	sleep_until( zoneset_current_active() == S_ZONESET_ATRIUM_LOOKOUT, 1);
	//dprint( "m80_atrium_return_mission" );
	pup_play_show ("pup_atrium_return_worship");
	// This puppet show loops until the player enters a certain volume
	// This sound needs to play until the volume is reached
	sound_looping_start('sound\dialog\mission\m80\m80_atrium_hallway_00109', sq_ar_narrative_worshippers, 1);
	wake (f_atriumreturn_init_objects);
	wake (f_atriumreturn_start);
	wake (f_atriumreturn_begin_check);
  thread( f_atrium_narrative_science_1());
	thread( f_atrium_narrative_science_2());
	thread( f_atrium_narrative_science_3());
	thread( f_atrium_narrative_science_4());
	thread( f_atrium_narrative_science_5());
	


end

script dormant f_atriumreturn_init_objects()

	object_create_folder( bpd_atrium_return_mechs );
	object_create_folder( atrium_return_weapons );
	object_create_folder( atrium_return_equipment );
	object_create_folder( atrium_return_crates );	
	object_create_folder( veh_return_setup );
	object_destroy_folder( atrium_device_machines );
	object_destroy_folder( atrium_crates );
	object_destroy_folder( atrium_scenery );
	object_destroy_folder( atrium_bipeds );
	object_create_folder( atrium_return_weapons );
	
	vehicle_set_player_interaction( turret_atrium_1, "warthog_g", TRUE, TRUE );
	vehicle_set_player_interaction( turret_atrium_2, "warthog_g", TRUE, TRUE );
	vehicle_set_player_interaction( turret_atrium_3, "warthog_g", TRUE, TRUE );

	thread (f_atrium_return_mech_health());

end

/*script static void f_destroy_console_buttons()
			sleep_s(5);
			DPRINT("CONSOLE BUTTONS DESTROYED");
				device_set_power( device_control_atrium_science1, 0.0 );
				device_set_power( device_control_atrium_science2, 0.0 );
				device_set_power( device_control_atrium_science3, 0.0 );
				device_set_power( device_control_atrium_science4, 0.0 );
				device_set_power( device_control_atrium_science5, 0.0 );
			object_destroy(device_control_atrium_science1);
			object_destroy(device_control_atrium_science2);
			object_destroy(device_control_atrium_science3);
			object_destroy(device_control_atrium_science4);
			object_destroy(device_control_atrium_science5);

end*/

script static void f_atrium_return_mech_health
	
	dprint ("mechs health has been upped");
	
	units_set_maximum_vitality (biped_return_mech_1, 580, 145);
	units_set_maximum_vitality (biped_return_mech_2, 580, 145);
	units_set_maximum_vitality (biped_return_mech_3, 580, 145);
	
end


script dormant f_atriumreturn_start()

	//dprint( "START ENCOUNTER: m80_Atrium_Return" );
	data_mine_set_mission_segment( "m80_Atrium_Return" );

	thread( f_mus_m80_e09_begin() );
	// Set the number of non-LOD'd AI higher because it's a big fight
	ai_lod_full_detail_actors( s_atriumreturn_ai_lod_count );

	// Keep the Elites from jumping on the Gauss turrets (which they can't fire anyway, so they shouldn't get on them!)
	ai_vehicle_reserve_seat( turret_atrium_1, "warthog_g", TRUE );
	ai_vehicle_reserve_seat( turret_atrium_2, "warthog_g", TRUE );
	ai_vehicle_reserve_seat( turret_atrium_3, "warthog_g", TRUE );

	wake( f_atriumreturn_vehicle_checks );
	wake( f_atriumreturn_check_max_ai_count );
	wake( f_atriumreturn_repeating_gc );
	wake( f_atriumreturn_start_waves );
	
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_MEDIUM() );

end


script dormant f_atriumreturn_vehicle_checks()
	
	wake( f_atriumreturn_check_if_player0_in_banshee );
	wake( f_atriumreturn_check_if_player1_in_banshee );
	wake( f_atriumreturn_check_if_player2_in_banshee );
	wake( f_atriumreturn_check_if_player3_in_banshee );	
	wake( f_atriumreturn_check_if_turret_1_occupied );
	wake( f_atriumreturn_check_if_turret_2_occupied );
	wake( f_atriumreturn_check_if_turret_3_occupied );
	wake( f_atriumreturn_check_if_mech_1_occupied );
	wake( f_atriumreturn_check_if_mech_2_occupied );
	wake( f_atriumreturn_checktrigger_back );
	wake( f_atriumreturn_checktrigger_right );
	wake( f_atriumreturn_checktrigger_center );
	wake( f_atriumreturn_checktrigger_left );
	wake( f_atriumreturn_checktrigger_front );	
	wake( f_atriumreturn_objcon );
	
end


script dormant f_atriumreturn_starting_sequence()

	f_chapter_title_atrium_return();
	f_objective_set( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT(), TRUE, FALSE, FALSE, TRUE );

	sleep_until( volume_test_players(tv_atriumreturn_left_lookout) or dialog_id_played_check(l_dlg_atrium_battle), 1 );
	f_objective_blip( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT(), TRUE );
	
	sleep_until( volume_test_players(tv_atriumreturn_left_lookout), 1 );
	sleep_s( 15.0 );
	//f_fx_composer_scan(); // THIS ONE WAS CUT - THFRENCH
	wake(m80_atrium_return_covenant_02);

end

script command_script cs_blind_gunners
	
	ai_braindead (ai_current_actor, TRUE);
	ai_set_blind (ai_current_actor, TRUE);
	ai_set_deaf (ai_current_actor, TRUE);
	
end


// ================================================================================================
// ================================================================================================
// *** CLEAN-UP ***
// ================================================================================================
// ================================================================================================


script dormant f_atriumreturn_repeating_gc()

	repeat
		sleep_s( 30.0 );
		//dprint( "Garbage collecting..." );
		add_recycling_volume( tv_atrium_recycle, 20, 30 ); 
	until( 0 == 1 );	

end


script static void f_atriumreturn_cleanup()

	garbage_collect_now();
	sleep_forever( f_atriumreturn_check_if_player0_in_banshee );
	sleep_forever( f_atriumreturn_check_if_player1_in_banshee );
	sleep_forever( f_atriumreturn_check_if_player2_in_banshee );
	sleep_forever( f_atriumreturn_check_if_player3_in_banshee );
	sleep_forever( f_atriumreturn_check_if_turret_1_occupied );
	sleep_forever( f_atriumreturn_check_if_turret_2_occupied );
	sleep_forever( f_atriumreturn_check_if_turret_3_occupied );
	sleep_forever( f_atriumreturn_check_if_mech_1_occupied );
	sleep_forever( f_atriumreturn_check_if_mech_2_occupied );
	sleep_forever( f_atriumreturn_repeating_gc );
	sleep_forever( f_atriumreturn_checktrigger_back );
	sleep_forever( f_atriumreturn_checktrigger_right );
	sleep_forever( f_atriumreturn_checktrigger_center );
	sleep_forever( f_atriumreturn_checktrigger_left );
	sleep_forever( f_atriumreturn_checktrigger_front );
	sleep_forever( f_atriumreturn_objcon );
	sleep_forever( f_atriumreturn_check_max_ai_count );
	
end


// =================================================================================================
// =================================================================================================
// *** WAVE SCRIPTING ***
// =================================================================================================
// =================================================================================================


script dormant f_atriumreturn_start_waves()

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: INITIAL", 5.0 ); 
	wake( f_atriumreturn_manage_banshee_count );

	thread( f_atriumreturn_wave1_group1() );
	//dprint ("wave 1, group 1 incoming!");
	
	sleep_until(
		ai_combat_status( sg_return_wave1_group1 ) >= ai_combat_status_visible or
		object_get_recent_shield_damage( ai_get_object( ai_current_actor ) ) > 0.0 or
		b_return_mech_1_occupied == TRUE or
		b_return_mech_2_occupied == TRUE
	, 1 );
	
	//timer or event, then wait for less than max count
	sleep_until( LevelEventStatus( "m80 atrium return wave 1 group 1 phantom fleeing" ) or ai_living_count( sg_return_wave1_group1 ) <= 9, 1 );
	sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );
	
	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 1 - MID", 5.0 );

	thread( f_atriumreturn_wave1_group2() );
	//dprint ("wave 1, group 2 incoming!");

	sleep_until( ai_living_count( sg_atriumreturn ) <= s_atriumreturn_alive_to_start_ending_wave1 );

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 1 - COMPLETE", 5.0 ); 
	//dprint ( " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" );
	sleep_until( f_atriumreturn_wave_safe(TRUE, "WAVE 1 - COMPLETE"), 1 );

	//dprint ("wave 2, group 1 incoming!");
	thread( f_atriumreturn_wave2_group1() );

	//timer or event, then wait for less than max count
	sleep_s( r_atriumreturn_delay_before_wave2_group2 );
	sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 2 - MID", 5.0 );

	thread( f_atriumreturn_wave2_group2() );
	//dprint ("wave 2, group 2 incoming!");
	
	sleep_until( ai_living_count( sg_atriumreturn ) <= s_atriumreturn_alive_to_start_ending_wave2 );

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 2 - COMPLETE", 5.0 );

	//dprint ("waiting until it's safe to save...");
	sleep_until( f_atriumreturn_wave_safe(TRUE, "WAVE 2 - COMPLETE"), 1 );
	//dprint ("sleeping for 4 seconds...");
	sleep_s( 4 );

	thread( f_atriumreturn_wave3_group1() );
	//dprint ("wave 3, group 1 incoming!");

	wake (f_dialog_M80_callout_banshees);

	//timer or event, then wait for less than max count
	sleep_until( ai_living_count( sg_return_wave3_group1_banshees ) > 0 );
	sleep_until( ai_living_count( sg_return_wave3_group1_banshees ) <= 3 );
	sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 3 - MID", 5.0 ); 
	
	//thread( f_atriumreturn_wave3_group2() );
	//dprint ("wave 3, group 2 incoming!");
	
	//sleep_until( ai_living_count( sg_atriumreturn ) <= s_atriumreturn_alive_to_start_ending_wave3 );
	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 3 - COMPLETE", 5.0 );

	//dprint ("waiting until it's safe to save...");
	sleep_until( f_atriumreturn_wave_safe(TRUE, "WAVE 3 - COMPLETE"), 1 );

	//thread( f_atriumreturn_wave4_group1() );
	//dprint ("wave 4, group 1 incoming!");
	
	thread (f_atriumreturn_suicide_grunts());
	
	//timer or event, then wait for less than max count
	sleep_s( r_atriumreturn_delay_before_wave4_group2 );
	sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );
	
	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 4 - MID", 5.0 );
	//thread( f_atriumreturn_wave4_group2() );
//	//dprint ("wave 4, group 2 incoming!");

	//sleep_s( r_atriumreturn_delay_before_wave4_group3 );
	//sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );
	//wake( f_atriumreturn_wave4_halfway_save );
	
	//sleep_until( ai_living_count( sg_atriumreturn ) <= s_atriumreturn_alive_to_start_ending_wave4 );
	//wake( f_atriumreturn_finished_wave4_save );
	//dprint ("waiting until it's safe to save...");
	//sleep_until( f_atriumreturn_wave_safe(), 1 );
	//dprint ("waiting for 2 seconds...");
	sleep_s( 2 );

	thread( f_atriumreturn_wave5_group1() );
	//dprint ("wave 5, group 1 incoming!");
	wake( f_atriumreturn_prepare_to_retreat );
	
	wake (f_dialog_m80_atrium_battle_07);

	//timer or event, then wait for less than max count
	sleep_s( r_atriumreturn_delay_before_wave5_group2 );
	sleep_until( f_atriumreturn_enough_ai_slots_open_to_spawn( 0 ) == TRUE );

	checkpoint_no_timeout( TRUE, "f_atriumreturn_start_waves: WAVE 5 - MID", 5.0 );
	thread( f_atriumreturn_wave5_group2() );
	//dprint ("wave 5, group 2 incoming!");
	
end


script static boolean f_atriumreturn_enough_ai_slots_open_to_spawn( short num_waiting_to_spawn )

	local boolean b_enough_ai_slots = FALSE;

	if( ( ai_living_count( sg_atriumreturn ) + num_waiting_to_spawn ) <= s_atriumreturn_ai_max_count ) then
		b_enough_ai_slots = TRUE;
	else
		b_enough_ai_slots = FALSE;
	end
	
	b_enough_ai_slots;

end


script dormant f_atriumreturn_check_max_ai_count()

	repeat
		sleep_until( ai_living_count( sg_atriumreturn ) > s_atriumreturn_ai_max_count, 1 );
		//dprint( "*** EXCEEDED MAX AI COUNT ***" );
		sleep_until( ai_living_count( sg_atriumreturn ) <= s_atriumreturn_ai_max_count, 1 );
	until( 0 == 1, 1 );

end


// =================================================================================================
// *** WAVE 1 ***
// =================================================================================================


script static void f_atriumreturn_wave1_group1()

	//dprint( "Starting Wave 1" );
	ai_place( sg_return_wave1_group1 );
	// Create the ready-to-destroy mech that the enemies focus on right away
	//object_create( biped_return_mech_3 );
	//unit_set_maximum_vitality( biped_return_mech_3, 0.1, 0.0 );
	
	sleep_until( 
		s_objcon_m80_atriumreturn == S_OBJCON_BACK_RIGHT or
		s_objcon_m80_atriumreturn == S_OBJCON_BACK_LEFT or
		s_objcon_m80_atriumreturn == S_OBJCON_CENTER_RAMP
	, 1 );
	ai_set_task_condition( obj_atrium_infantry.wave1_cluster1, FALSE );
	if( s_objcon_m80_atriumreturn == S_OBJCON_BACK_RIGHT ) then
		ai_set_task_condition( obj_atrium_infantry.wave1_cluster2, FALSE );
	end		
	
	sleep_until( 
		s_objcon_m80_atriumreturn == S_OBJCON_RIGHT or
		s_objcon_m80_atriumreturn == S_OBJCON_CENTER_TOP or
		s_objcon_m80_atriumreturn == S_OBJCON_LEFT_FRONT		
	, 1 );
	if( s_objcon_m80_atriumreturn == S_OBJCON_BACK_RIGHT or s_objcon_m80_atriumreturn == S_OBJCON_CENTER_TOP ) then
		ai_set_task_condition( obj_atrium_infantry.wave1_cluster3, FALSE );
	elseif( s_objcon_m80_atriumreturn == S_OBJCON_LEFT_FRONT ) then
		ai_set_task_condition( obj_atrium_infantry.wave1_cluster2a, FALSE );
		ai_set_task_condition( obj_atrium_infantry.wave1_cluster3a, FALSE );
	end		
	
	sleep_until( ai_living_count( sg_return_wave1_group1 ) <= 6 );
	ai_set_task_condition( obj_atrium_infantry.wave1_cluster4, FALSE );
	
end

script static void f_atriumreturn_wave1_group2()

	//dprint( "Spawning Wave 1, Group 2" );
	f_atriumreturn_new_dropoff_phantom( sq_return_wave1_dropphantoms.spawn_points_0, NONE, NONE, "right", sq_return_wave1_squad3, NONE, NONE, NONE );
	object_teleport_to_ai_point( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_0 ), ps_atriumreturn_phantom_spawn.window_right_high);
	object_set_scale( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_0 ), 0.01, 0 );
	object_set_scale( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_0 ), 1.00, 150 );
	cs_fly_to( sq_return_wave1_dropphantoms.spawn_points_0, TRUE, ps_atriumreturn_phantoms.window_waypoint_left );
	cs_fly_to_and_face( sq_return_wave1_dropphantoms.spawn_points_0, TRUE, ps_atriumreturn_phantom_drop.platform_left_side_drop, ps_atriumreturn_phantom_drop.platform_left_side_drop_face );
	f_unload_phantom( ai_vehicle_get( sq_return_wave1_dropphantoms.spawn_points_0 ), "right" );
	sleep_s( 2.0 );
	cs_fly_to_and_face ( sq_return_wave1_dropphantoms.spawn_points_0, TRUE, ps_atriumreturn_phantoms.inner_loop_1, ps_atriumreturn_phantoms.inner_loop_window_side);
	
	cs_queue_command_script( sq_return_wave1_dropphantoms.spawn_points_0, cs_phantom_exit_window_right_high );
	
	/*
	sleep_s( 5.0 );
	f_atriumreturn_new_dropoff_phantom( sq_return_wave1_dropphantoms.spawn_points_1, NONE, NONE, "left", sq_return_wave1_squad4, NONE, NONE, NONE );
	object_teleport_to_ai_point( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_1 ), ps_atriumreturn_phantom_spawn.window_left_high);	
	object_set_scale( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_1 ), 0.01, 0 );
	object_set_scale( ai_vehicle_get_from_spawn_point( sq_return_wave1_dropphantoms.spawn_points_1 ), 1.00, 150 );
	cs_fly_to( sq_return_wave1_dropphantoms.spawn_points_1, TRUE, ps_atriumreturn_phantoms.window_waypoint_right );
	cs_fly_to_and_face( sq_return_wave1_dropphantoms.spawn_points_1, TRUE, ps_atriumreturn_phantom_drop.center_ridge_side_drop, ps_atriumreturn_phantom_drop.center_ridge_side_drop_face );
	f_unload_phantom( ai_vehicle_get( sq_return_wave1_dropphantoms.spawn_points_1 ), "left" );	
	cs_queue_command_script( sq_return_wave1_dropphantoms.spawn_points_1, cs_return_phantom_exit_back_right_1 );
	*/
end


// =================================================================================================
// *** WAVE 2 ***
// =================================================================================================


script static void f_atriumreturn_wave2_group1()

	//dprint( "Starting Wave 2" );
	
	
	ai_place (sq_return_wave2_phantom2); //carrying Wraith_2
	sleep_s( 4.0 );
	ai_place (sq_return_wave2_phantom4); //carrying Infantry
	wake (f_dialog_m80_atrium_battle_02);
	
	//ai_place( sq_return_wave2_squad1 );
	//ai_place( sq_return_wave2_squad2 );

end


script static void f_atriumreturn_wave2_group2()


	//dprint( "Spawning Wave 2, Group 2" );
	ai_place (sq_return_wave2_phantom1); //carrying Wraith_1
	sleep_s( 4.0 );
	ai_place (sq_return_wave2_phantom3); //carrying two Ghosts
	//sleep (120);
	//ai_place (sq_return_wave2_phantom5); //carrying Infantry



	/*
	ai_place( sg_return_wave2_group2_wraiths );
	ai_place( sg_return_wave2_group2_ghosts );	
	f_atriumreturn_new_dropoff_phantom( sq_return_wave2_dropphantoms.phantom1_driver, NONE, NONE, "chute", sq_return_wave2_squad3.spawn_points_0, sq_return_wave2_squad3.spawn_points_1, sq_return_wave2_squad3.spawn_points_2, sq_return_wave2_squad3.spawn_points_3 );
	f_unload_phantom( ai_vehicle_get( sq_return_wave2_dropphantoms.phantom1_driver ), "chute" );
	cs_run_command_script( sq_return_wave2_dropphantoms.phantom1_driver, cs_phantom_exit_window_left_1 ); 
	*/
end


// =================================================================================================
// *** WAVE 3 ***
// =================================================================================================


script static void f_atriumreturn_wave3_group1()

	//dprint( "Starting Wave 3" );
	//wake( f_atriumreturn_phantom_wave_3_loop );

	sleep_until( ai_living_count( sg_return_wave3_group1_phantom ) == 0 or cs_command_script_attached( sq_return_wave3_phantom1.spawn_points_0, cs_return_phantom_counterclockwise_inner_circle ) == FALSE );
	ai_place( sg_return_wave3_group1_banshees );
	
	sleep_until( ai_living_count( sg_return_wave3_group1_banshees ) <= 3 );
	//dprint( "Increasing Banshee count" );
	s_atriumreturn_simultaneous_banshee_count = 5;
	f_atriumreturn_update_banshee_count();
	
	sleep_until( ai_living_count( sg_return_wave3_group1_banshees ) == 0 );
	//dprint( "Increasing Banshee count on next reset" );
	s_atriumreturn_simultaneous_banshee_count = 6;
	
end


script dormant f_atriumreturn_phantom_wave_3_loop()

	ai_place( sq_return_wave3_phantom1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	cs_vehicle_speed( sq_return_wave3_phantom1.spawn_points_0, 0.75 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1.00, 150 );
	cs_queue_command_script( sq_return_wave3_phantom1.spawn_points_0, cs_return_phantom_counterclockwise_inner_circle );
	cs_queue_command_script( sq_return_wave3_phantom1.spawn_points_0, cs_return_phantom_exit_window_right_low );

end

/*
script static void f_atriumreturn_wave3_group2()

	//dprint( "Old wave - no reinforcements incoming" );
	//ai_place( sg_return_wave3_group2 );
	//ai_place (sq_return_wave3_banshee1);
	//ai_place (sq_return_wave3_banshee2);
	//ai_place (sq_return_wave3_banshee3);

end
*/

// =================================================================================================
// *** INTERMISSION WAVE ***
// =================================================================================================

script static void f_atriumreturn_suicide_grunts()

	ai_place (sq_return_wave2_phantom6); //carrying first group of kamikaze grunts
	sleep_s( 4.0 );
	ai_place (sq_return_wave2_phantom7); //carrying second group of kamikaze grunts

end

// =================================================================================================
// *** WAVE 4 ***
// =================================================================================================

script static void f_atriumreturn_wave4_group1()

	//dprint( "Spawning Wave 4, Group 1" );
	//ai_place( sg_return_wave4_group2 );
	ai_place (sq_return_wave2_phantom3); //carrying two Ghosts
	ai_place (sq_return_wave3_banshee1);
	ai_place (sq_return_wave3_banshee2);
	ai_place (sq_return_wave3_banshee3);
	sleep_s( 4.0 );

end


script static void f_atriumreturn_wave4_group2()

	//dprint( "Spawning Wave 4, group 2" );
	//ai_place( sg_return_wave4_group1 );
	ai_place (sq_return_wave2_phantom1); //carrying Wraith_1
	sleep_s( 4.0 );
	ai_place (sq_return_wave2_phantom2); //carrying Wraith_2
	//sleep (120);
	//ai_place (sq_return_wave2_phantom3); //carrying two Ghosts

end


// =================================================================================================
// *** WAVE 5 ***
// =================================================================================================


script static void f_atriumreturn_wave5_group1()

	//dprint( "Starting Wave 5" );
	ai_place( sg_return_wave5_group1 );

end


script static void f_atriumreturn_wave5_group2()

	//dprint( "Spawning Wave 5, Group 2" );
	ai_place( sg_return_wave5_group2 );

end


script dormant f_atriumreturn_prepare_to_retreat()

	sleep_s( r_atriumreturn_wave5_retreat_timer );
	
	//wake (f_dialog_m80_atrium_battle_leaving_01);
	wake( f_dialog_atrium_battle_post );	
	
	//retreat
	//dprint( "All airborne enemies now flee!" );
	cs_run_command_script( sg_return_wave5_group1_banshees, cs_atriumreturn_banshee_exit );

	thread( f_mus_m80_e09_finish() );
	
	b_atrium_finished = TRUE;

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_atriumreturn_prepare_to_retreat", 1.0 );	

	f_atriumreturn_cleanup();
	
	sleep_until (volume_test_players (tv_atrium_teleport_players_post_c82_out), 1);

	ai_erase( sg_return_wave2_group2_phantom );
	ai_erase( sg_return_wave3_group1_banshees );
	ai_erase( sg_return_wave3_group2_phantom );
	ai_erase( sg_return_wave5_group1_phantoms );
	ai_erase( sg_return_wave5_group2_phantoms );
	//ai_erase( sg_return_wave5_group2_banshees );
	
		


end


// =================================================================================================
// =================================================================================================
// *** ENCOUNTER SCRIPTING ***
// =================================================================================================
// =================================================================================================


script dormant f_atriumreturn_manage_banshee_count()
		dprint( "old banshee scripts from quentin era" );
	//f_atriumreturn_update_banshee_count();

//	repeat
		//sleep_until( ai_task_count( obj_atrium_banshees.gate_scripted_count ) > 0 );
		//dprint( "Waiting for gated Banshee count to reach reset count" );
	
		//sleep_until( ai_task_count( obj_atrium_banshees.gate_scripted_count ) <= s_atriumreturn_banshee_reset_count );
	//	f_atriumreturn_update_banshee_count();
	
	//until( b_atrium_finished == TRUE, 1 );

end


script static void f_atriumreturn_update_banshee_count()

		dprint( "old banshee scripts from quentin era" );
		//ai_reset_objective( obj_atrium_banshees.count_1 );
		//ai_reset_objective( obj_atrium_banshees.count_2 );
		//ai_reset_objective( obj_atrium_banshees.count_3 );
		//ai_reset_objective( obj_atrium_banshees.count_4 );
		//
		//dprint( "Restoring appropriate number of gated Banshee tasks to active status (by disabling extras)" );
		//if( s_atriumreturn_simultaneous_banshee_count < 4 ) then
		//	ai_set_task_condition( obj_atrium_banshees.count_4, FALSE ); 
		//end
		//if( s_atriumreturn_simultaneous_banshee_count < 3 ) then
		//	ai_set_task_condition( obj_atrium_banshees.count_3, FALSE ); 
		//end
		//if( s_atriumreturn_simultaneous_banshee_count < 2 ) then
		//	ai_set_task_condition( obj_atrium_banshees.count_2, FALSE ); 
		//end
		//if( s_atriumreturn_simultaneous_banshee_count < 1 ) then
		//	ai_set_task_condition( obj_atrium_banshees.count_1, FALSE ); 
		//end
		
end


// =================================================================================================
// *** CASE: PLAYER IN BANSHEE ***
// =================================================================================================

// Empty for now


// =================================================================================================
// *** CASE: PLAYER ON A TURRET ***
// =================================================================================================

// Adjust enemy behaviors:
//		Infantry find better cover
//		Greater number of Banshees can drop into the engagement zone
//		Wraiths shell from a distance to keep players from abusing the gauss
// Spawn extra or alternate groups, primarily Banshees and Phantoms-dropping-off-Wraiths


// =================================================================================================
// =================================================================================================
// *** COMMAND SCRIPTS ***
// =================================================================================================
// =================================================================================================


script command_script cs_suicide_grunts()
	
	sleep_s( 1.0, 2.0 );
	ai_grunt_kamikaze (sq_suicide_grunts);

end


script command_script cs_return_kill_third_mech()

	cs_abort_on_damage( TRUE );
	cs_abort_on_combat_status( ai_combat_status_certain );
	
	//cs_shoot( TRUE, biped_return_mech_3 );
	sleep_s( 15.0 );

end


script command_script cs_return_reverent_enemies()

	sleep_until(
		ai_combat_status( sg_return_wave1_group1 ) >= ai_combat_status_visible or
		object_get_recent_shield_damage( ai_get_object( ai_current_actor ) ) > 0.0 or
		b_return_mech_1_occupied == TRUE or
		b_return_mech_2_occupied == TRUE
	, 1 );
	sleep_s( real_random_range( 0.0, 10.0 ) );

end


script command_script cs_return_landed_banshee_pilot()

	sleep_until(
		ai_combat_status( sg_return_wave1_group1_center ) >= ai_combat_status_certain or
		object_get_recent_shield_damage( ai_get_object( ai_current_actor ) ) > 0.0 or
		b_return_mech_1_occupied == TRUE or
		b_return_mech_2_occupied == TRUE
	, 1 );
	sleep_s( 1.25 );
	//dprint( "Landed Banshee Pilot was surprised!  Going for the Banshee!" );

	//NOT WORKING, ROBERT IS LOOKING INTO IT
	ai_vehicle_enter( ai_current_actor, atrium_return_banshee );
	
	//USING THESE INSTEAD FOR NOW
	cs_go_to_vehicle( atrium_return_banshee, "banshee_d" );
	ai_vehicle_enter_immediate( ai_current_actor, atrium_return_banshee );

	if( ai_in_vehicle_count( ai_current_actor ) >= 1 ) then
		//dprint( "Landed Banshee Pilot got in his Banshee!" );
		cs_vehicle_speed( ai_current_actor, 1.0 );
		cs_fly_by( ps_atriumreturn_banshees.landed_banshee_escape_start );
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 150 );
		cs_fly_to( ps_atriumreturn_banshees.landed_banshee_escape_end );
		//dprint( "Landed Banshee Pilot exited the Atrium.  Cleaning up." );
		object_destroy( ai_vehicle_get( ai_current_actor ) );
	//else
		//dprint( "Landed Banshee Pilot failed to get into his vehicle.  Releasing from command script." );
	end

end


script command_script cs_atriumreturn_banshee_formation()

	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 0 );
	//dprint( "Arrive, flying in formation" );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 1.00, 150 );
	sleep_s( 7.5 );

end


script command_script cs_atriumreturn_banshee_exit()

	sleep_s( real_random_range( 0.0, 10.0 ) );
	cs_fly_by( ps_atriumreturn_banshees.exit1_start );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 150 );
	cs_fly_to( ps_atriumreturn_banshees.exit1_end );
	//dprint( "Landed Banshee exited the Atrium.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );	

end


script command_script cs_wave2_wraith_dropoff_1()
	//Wraith 1 dropoff phantom
	ai_place (sq_return_wave2_wraith1);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom1.driver), "phantom_lc", ai_vehicle_get_from_squad (sq_return_wave2_wraith1, 0));
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_one);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_two);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_three);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_5);
	sleep_s( 1.0 );
	vehicle_unload(ai_vehicle_get( ai_current_actor ), "phantom_lc");
	sleep_s( 0.5 );
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_3);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_2);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_1);
	cs_fly_by (ps_atriumreturn_phantoms.window_waypoint_left);
	cs_fly_by (ps_phantom_exits.window_right_high_erase);
	cs_fly_by (ps_phantom_exits.right_exit);
	ai_erase (sq_return_wave2_phantom1);
end


script command_script cs_wave2_wraith_dropoff_2()
	//Wraith 2 dropoff phantom
	ai_place (sq_return_wave2_wraith2);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom2.driver), "phantom_lc", ai_vehicle_get_from_squad (sq_return_wave2_wraith2, 0));
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_one);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_two);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_three);
	cs_fly_to (ps_atriumreturn_phantom_drop.dropzone_front_1);
	sleep_s( 1.0 );
	vehicle_unload(ai_vehicle_get( ai_current_actor ), "phantom_lc");
	sleep_s( 0.5 );
	cs_fly_to_and_face (ps_atriumreturn_phantoms.inner_loop_6, ps_atriumreturn_phantoms.inner_loop_window_side);
	cs_fly_to (ps_atriumreturn_phantoms.inner_loop_window_side);
	cs_fly_by (ps_phantom_exits.window_left_1_hover);
	cs_fly_by (ps_phantom_exits.p0);
	cs_fly_by (ps_phantom_exits.p1);
	ai_erase (sq_return_wave2_phantom2);
end


script command_script cs_wave2_wraith_dropoff_3()
	//Double Ghost dropoff phantom
	ai_place (sg_return_wave2_ghost1);
	ai_place (sg_return_wave2_ghost2);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom3.driver), "phantom_sc01", ai_vehicle_get_from_squad (sg_return_wave2_ghost1, 0));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom3.driver), "phantom_sc02", ai_vehicle_get_from_squad (sg_return_wave2_ghost2, 0));
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_right_high);
	cs_fly_to (ps_atriumreturn_phantom_drop.dropzone_front_5);
	sleep_s( 0.5 );
	vehicle_unload(ai_vehicle_get( ai_current_actor ), "phantom_sc01");
	vehicle_unload(ai_vehicle_get( ai_current_actor ), "phantom_sc02");
	sleep_s( 0.5 );
	cs_fly_by (ps_atriumreturn_phantom_drop.dropzone_front_3);
	cs_fly_by (ps_atriumreturn_phantom_drop.dropzone_front_4);
	cs_fly_by (ps_phantom_exits.window_left_1_hover);
	cs_fly_by (ps_phantom_exits.window_left_1_drop);
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 180 );
	ai_erase (sq_return_wave2_phantom3);
end

script command_script cs_wave2_wraith_dropoff_4()
	//Infantry dropoff phantom
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom4.driver), "dual", sq_return_wave2_squad1, sq_return_wave2_squad2, sq_return_wave2_grunt1, none);
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_left_high);
	cs_fly_by (ps_atriumreturn_phantoms.window_waypoint_left);
	cs_fly_to (ps_atriumreturn_phantom_drop.dropzone_front_2);
	sleep_s( 2.0 );
	f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom4.driver), "dual");
	sleep_s( 2.0 );
	cs_fly_to_and_face (ps_atriumreturn_phantoms.inner_loop_1, ps_atriumreturn_phantoms.inner_loop_window_side);
	cs_fly_by (ps_atriumreturn_phantoms.p0);
	cs_fly_by (ps_atriumreturn_phantoms.p1);
	cs_fly_by (ps_atriumreturn_phantoms.p2);
	ai_erase (sq_return_wave2_phantom4);
end


script command_script cs_wave2_wraith_dropoff_5()
	//Infantry dropoff phantom
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom5.driver), "dual", sq_return_wave2_squad1, sq_return_wave2_squad2, sq_return_wave2_grunt1, none);
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_right_high);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_three);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_5);
	sleep_s( 0.5 );
	f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom5.driver), "dual");
	sleep_s( 0.5 );
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_4);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_3);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_2);
	cs_fly_by (ps_phantom_exits.window_right_high_erase);
	cs_fly_by (ps_phantom_exits.right_exit);
	sleep( 1 );
	ai_erase (sq_return_wave2_phantom5);
end

script command_script cs_wave2_wraith_dropoff_6()
	//Suicide Grunts dropoff phantom
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom6.driver), "dual", sq_suicide_grunts, sq_suicide_grunts, none, none);
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_left_high);
	cs_fly_by (ps_atriumreturn_phantoms.window_waypoint_left);
	cs_fly_to (ps_atriumreturn_phantom_drop.dropzone_front_2);
	sleep_s( 2.0 );
	f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom6.driver), "dual");
	sleep_s( 2.0 );
	cs_run_command_script( sq_suicide_grunts, cs_suicide_grunts );
	//dprint ("grunts going kamikaze");
	cs_fly_to_and_face (ps_atriumreturn_phantoms.inner_loop_1, ps_atriumreturn_phantoms.inner_loop_window_side);
	cs_fly_by (ps_atriumreturn_phantoms.p0);
	cs_fly_by (ps_atriumreturn_phantoms.p1);
	cs_fly_by (ps_atriumreturn_phantoms.p2);
	ai_erase (sq_return_wave2_phantom4);
end

script command_script cs_wave2_wraith_dropoff_7()
	//Infantry dropoff phantom
	f_load_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom7.driver), "dual", sq_suicide_grunts, sq_suicide_grunts, none, none);
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_left_high);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_three);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_5);
	sleep_s( 0.518 );
	f_unload_phantom (ai_vehicle_get_from_spawn_point (sq_return_wave2_phantom7.driver), "dual");
	sleep_s( 1.0 );
	cs_run_command_script( sq_suicide_grunts, cs_suicide_grunts );
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_4);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_3);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_2);
	cs_fly_by (ps_phantom_exits.window_right_high_erase);
	cs_fly_by (ps_phantom_exits.right_exit);
	sleep( 1 );
	ai_erase (sq_return_wave2_phantom5);
end

script command_script cs_wave5_phantom_strafing1()
	//Phantom strafing around the atrium
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 1 );
	sleep( 1 );
	object_set_scale(ai_vehicle_get(ai_current_actor), 1.0, 90 );
	cs_fly_by (ps_atriumreturn_phantom_spawn.window_right_high);
	cs_fly_by (ps_atriumreturn_phantom_spawn.under_step_three);
	sleep_s( 6.0 );
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_5);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_4);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_3);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_2);
	cs_fly_by (ps_phantom_exits.window_right_high_erase);
	cs_fly_by (ps_phantom_exits.right_exit);
	sleep( 1 );
	ai_erase (sq_return_wave5_phantom1);
end

script command_script cs_wave5_phantom_strafing2()
	//Phantom strafing around the atrium
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 1 );
	sleep( 1 );
	object_set_scale(ai_vehicle_get(ai_current_actor), 1.0, 90 );

	cs_fly_by (ps_atriumreturn_phantoms.window_waypoint_left);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_1);
	cs_fly_by (ps_atriumreturn_phantoms.outer_loop_1);
	cs_fly_by (ps_atriumreturn_phantoms.outer_loop_3);
	sleep_s( 9.0 );
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_4);
	cs_fly_by (ps_atriumreturn_phantoms.inner_loop_5);
	cs_fly_by (ps_phantom_exits.window_left_1_hover);
	cs_fly_by (ps_phantom_exits.window_left_1_drop);
	object_set_scale(sq_return_wave5_phantom2, 0.01, 180 );
	ai_erase (sq_return_wave5_phantom2);
end

// =================================================================================================
// *** PHANTOM SCRIPTS ***
// =================================================================================================


// Pure "dropoff" phantoms and "aggressor" phantoms

script static void f_atriumreturn_new_dropoff_phantom( ai driver_spawn_point, ai left_gunner_spawn_point, ai right_gunner_spawn_point, string load_side, ai load_squad_01, ai load_squad_02, ai load_squad_03, ai load_squad_04 )

	ai_place( driver_spawn_point );
	if( left_gunner_spawn_point != NONE ) then
		ai_place( left_gunner_spawn_point );
		vehicle_load_magic( object_at_marker( ai_vehicle_get_from_spawn_point( driver_spawn_point ), "turret_l" ), "", ai_get_object( left_gunner_spawn_point ) );
	end
	if( right_gunner_spawn_point != NONE ) then
		ai_place( right_gunner_spawn_point );
		vehicle_load_magic( object_at_marker( ai_vehicle_get_from_spawn_point( driver_spawn_point ), "turret_r" ), "", ai_get_object( right_gunner_spawn_point ) );
	end
	f_load_phantom( ai_vehicle_get_from_spawn_point( driver_spawn_point ), load_side, load_squad_01, load_squad_02, load_squad_03, load_squad_04 );

end


// Phantoms should act like real pilots--unless it's a "finish it off" Phantom, they should bug out as their weapon options are taken away (or nearby "defender" squads get taken out)
// Think about allowing them to pursue players a bit or fall back away from advancing players
// Think about having them face the player until they're ready to bug out
// Try to never have to aim "too high," even for escaping Phantoms


// =================================================================================================
// *** FOR-SHOW SCRIPTS ***
// =================================================================================================


script command_script cs_return_phantom_counterclockwise_inner_circle()

	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_1 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_2 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_3 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_4 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_5 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_6 );

end


script command_script cs_phantom_clockwise_inner_circle()

	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_6 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_5 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_4 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_3 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_2 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_1 );

end


script command_script cs_phantom_wave_1_exit()

	sleep_s( 3.0 );
	cs_fly_by( ps_atriumreturn_phantoms.low_outer_loop_3 );
	cs_fly_by( ps_atriumreturn_phantoms.outer_loop_2 );
	cs_fly_by( ps_atriumreturn_phantoms.outer_loop_1 );
	cs_run_command_script( ai_current_actor, cs_phantom_exit_window_left_1 );

end

script command_script cs_phantom_wave_1_exit_v2()

	sleep_s( 20.0 );
	cs_fly_by( ps_atriumreturn_phantoms.inner_loop_window_side );
	cs_fly_by( ps_atriumreturn_phantoms.window_waypoint_left );
	cs_run_command_script( ai_current_actor, cs_phantom_exit_window_left_1 );

end


// =================================================================================================
// *** EXIT SCRIPTS ***
// =================================================================================================



script command_script cs_return_phantom_exit_window_right_low()

	//dprint( "Phantom starting exit script: window right low " );
	cs_fly_to( ps_phantom_exits.window_right_low_start );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 150 );
	cs_fly_to( ps_phantom_exits.window_right_low_end );
	//dprint( "Phantom exited atrium at window right low.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end


script command_script cs_return_phantom_exit_back_right_1()

	//dprint( "Phantom starting exit script: back right 1 " );
	cs_fly_to( ps_phantom_exits.back_right_hover );
	cs_fly_to_and_face( ps_phantom_exits.back_right_hover, ps_phantom_exits.back_right_face );
	cs_fly_to( ps_phantom_exits.back_right_drop );
	cs_fly_to( ps_phantom_exits.back_right_erase );
	//dprint( "Phantom exited atrium at back right 1.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );

end



// =================================================================================================
// *** LEGACY EXIT SCRIPTS - NEED REVIEW AND POLISH ***
// =================================================================================================


script command_script cs_phantom_exit_entrance_left_1()

	//dprint( "Phantom starting exit script: entrance left 1 " );
	cs_fly_to( ps_phantom_exits.entrance_left_1_hover );
	cs_fly_to( ps_phantom_exits.entrance_left_1_drop );
	cs_fly_to( ps_phantom_exits.entrance_left_1_erase );
	//dprint( "Phantom exited atrium at entrance left 1.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end


script command_script cs_phantom_exit_window_left_1()

	//dprint( "Phantom starting exit script: window left 1 " );
	cs_fly_to( ps_phantom_exits.window_left_1_hover );
	cs_fly_to( ps_phantom_exits.window_left_1_drop );
	cs_fly_to( ps_phantom_exits.window_left_1_erase );
	//dprint( "Phantom exited atrium at window left 1.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );

end


script command_script cs_phantom_exit_window_right_high()

	//dprint( "Phantom starting exit script: window right high " );
	cs_fly_to( ps_phantom_exits.window_right_high_1 );
	cs_fly_to( ps_phantom_exits.window_right_high_2 );
	cs_fly_to( ps_phantom_exits.window_right_high_erase );
	cs_fly_to( ps_phantom_exits.right_exit );
	//dprint( "Phantom exited atrium at window right high.  Cleaning up." );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end


// =================================================================================================
// =================================================================================================
// *** PLAYER TRACKING ***
// =================================================================================================
// =================================================================================================


script dormant f_atriumreturn_check_if_player0_in_banshee()

	repeat
		sleep_until( unit_in_vehicle_type(player0, 30) != b_return_player0_in_banshee );
		b_return_player0_in_banshee = not b_return_player0_in_banshee;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_player1_in_banshee()

	repeat
		sleep_until( unit_in_vehicle_type(player1, 30) != b_return_player1_in_banshee );
		b_return_player1_in_banshee = not b_return_player1_in_banshee;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_player2_in_banshee()

	repeat
		sleep_until( unit_in_vehicle_type(player2, 30) != b_return_player2_in_banshee );
		b_return_player2_in_banshee = not b_return_player2_in_banshee;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_player3_in_banshee()

	repeat
		sleep_until( unit_in_vehicle_type(player3, 30) != b_return_player3_in_banshee );
		b_return_player3_in_banshee = not b_return_player3_in_banshee;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_turret_1_occupied()

	repeat
		sleep_until( player_in_vehicle(turret_atrium_1) != b_return_turret_1_occupied );
		b_return_turret_1_occupied = not b_return_turret_1_occupied;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_turret_2_occupied()

	repeat
		sleep_until( player_in_vehicle(turret_atrium_2) != b_return_turret_2_occupied );
		b_return_turret_2_occupied = not b_return_turret_2_occupied;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_turret_3_occupied()

	repeat
		sleep_until( player_in_vehicle(turret_atrium_3) != b_return_turret_3_occupied );
		b_return_turret_3_occupied = not b_return_turret_3_occupied;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_mech_1_occupied()

	repeat
		sleep_until( vehicle_test_seat(biped_return_mech_1, 'mantis_d') != b_return_mech_1_occupied );
		b_return_mech_1_occupied = not b_return_mech_1_occupied;
	until( FALSE );

end


script dormant f_atriumreturn_check_if_mech_2_occupied()

	repeat
		sleep_until( vehicle_test_seat(biped_return_mech_2, 'mantis_d') != b_return_mech_2_occupied );
		b_return_mech_2_occupied = not b_return_mech_2_occupied;
	until( FALSE );

end


script dormant f_atriumreturn_begin_check
	sleep_until (volume_test_players (tv_atriumreturn_back_middle), 1);
	
	b_atrium_returns_has_begun = TRUE;
	sound_looping_stop('sound\dialog\mission\m80\m80_atrium_hallway_00109');
	//dprint ("b_atrium_returns_has_begun has been set to true");
	
end



script dormant f_atriumreturn_checktrigger_back()

	repeat
		sleep_until( 
			volume_test_players( tv_atriumreturn_back_right ) == TRUE or
			volume_test_players( tv_atriumreturn_back_middle ) == TRUE or
			volume_test_players( tv_atriumreturn_back_left ) == TRUE
		);
		//dprint( "There's a player in the back area!" );
		b_return_player_in_back = TRUE;
		sleep_until( 
			volume_test_players( tv_atriumreturn_back_right ) == FALSE and
			volume_test_players( tv_atriumreturn_back_middle ) == FALSE and
			volume_test_players( tv_atriumreturn_back_left ) == FALSE
		);
		//dprint( "There's no longer any player in the back area!" );
		b_return_player_in_back = FALSE;
	until( FALSE );

end


script dormant f_atriumreturn_checktrigger_right()

	repeat
		sleep_until( volume_test_players(tv_atriumreturn_right) != b_return_player_in_right );
		b_return_player_in_right = not b_return_player_in_right;
	until( FALSE );

end


script dormant f_atriumreturn_checktrigger_center()

	repeat
		sleep_until( 
			volume_test_players( tv_atriumreturn_center_ramp ) == TRUE or 
			volume_test_players( tv_atriumreturn_center_top ) == TRUE or 
			volume_test_players( tv_atriumreturn_center_front ) == TRUE
		);
		//dprint( "There's a player in the center area!" );
		b_return_player_in_center = TRUE;
	sleep_until( 
			volume_test_players( tv_atriumreturn_center_ramp ) == FALSE and
			volume_test_players( tv_atriumreturn_center_top ) == FALSE and
			volume_test_players( tv_atriumreturn_center_front ) == FALSE
		);
		//dprint( "There's no longer any player in the center area!" );
		b_return_player_in_center = FALSE;
	until( FALSE );

end


script dormant f_atriumreturn_checktrigger_left()

	repeat
		sleep_until( 
			volume_test_players( tv_atriumreturn_left_back ) == TRUE or
			volume_test_players( tv_atriumreturn_left_front ) == TRUE
		);
		//dprint( "There's a player in the left area!" );
		b_return_player_in_left = TRUE;
		sleep_until( 
			volume_test_players( tv_atriumreturn_left_back ) == FALSE and
			volume_test_players( tv_atriumreturn_left_front ) == FALSE
		);
		//dprint( "There's no longer any player in the left area!" );
		b_return_player_in_left = FALSE;
	until( FALSE );

end


script dormant f_atriumreturn_checktrigger_front()

	repeat
		sleep_until( volume_test_players(tv_atriumreturn_front) != b_return_player_in_front );
		b_return_player_in_front = not b_return_player_in_front;
	until( FALSE );

end


script dormant f_atriumreturn_objcon()
local short s_objcon = 0;

	repeat
		if( volume_test_players( tv_atriumreturn_back_right ) == TRUE ) then
			s_objcon = S_OBJCON_BACK_RIGHT;
		end
		if( volume_test_players( tv_atriumreturn_back_middle ) == TRUE ) then
			s_objcon = S_OBJCON_BACK_MIDDLE;
		end
		if( volume_test_players( tv_atriumreturn_back_left ) == TRUE ) then
			s_objcon = S_OBJCON_BACK_LEFT;
		end
		if( volume_test_players( tv_atriumreturn_center_ramp ) == TRUE ) then
			s_objcon = S_OBJCON_CENTER_RAMP;
		end
		if( volume_test_players( tv_atriumreturn_center_top ) == TRUE ) then
			s_objcon = S_OBJCON_CENTER_TOP;
		end
		if( volume_test_players( tv_atriumreturn_center_front ) == TRUE ) then
			s_objcon = S_OBJCON_CENTER_FRONT;
		end										
		if( volume_test_players( tv_atriumreturn_right ) == TRUE ) then
			s_objcon = S_OBJCON_RIGHT;
		end			
		if( volume_test_players( tv_atriumreturn_left_back ) == TRUE ) then
			s_objcon = S_OBJCON_LEFT_BACK;
		end					
		if( volume_test_players( tv_atriumreturn_left_back ) == TRUE ) then
			s_objcon = S_OBJCON_LEFT_FRONT;
		end					
		if( volume_test_players( tv_atriumreturn_front ) == TRUE ) then
			s_objcon = S_OBJCON_FRONT;
		end
		s_objcon_m80_atriumreturn = s_objcon;
	until( FALSE, 1 );
	
end


// =================================================================================================
// =================================================================================================
// *** SAVING ***
// =================================================================================================
// =================================================================================================

script static boolean f_atriumreturn_wave_safe( boolean b_zoneset_check, string str_location )
	// force zone load
	if ( b_zoneset_check and (zoneset_current_active() != S_ZONESET_ATRIUM_DAMAGED) ) then
		//dprint( "f_atriumreturn_wave_safe: LOADING ----------------------------" );
		//inspect( str_location );
		zoneset_prepare_and_load( S_ZONESET_ATRIUM_DAMAGED );
	end
	( game_safe_to_save() and (zoneset_current() == S_ZONESET_ATRIUM_DAMAGED) ) or ( (zoneset_current() != S_ZONESET_ATRIUM_DAMAGED) and (ai_living_count(sg_atriumreturn) <= 10) );
end


// =================================================================================================
// =================================================================================================
// *** VO ***
// =================================================================================================
// =================================================================================================







script static void f_return_phantom_chance_to_run( ai driver_spawn_point, ai squad_name, short count_to_run, ai_command_script the_exit, ai_command_script dodge_0, ai_command_script dodge_1, ai_command_script dodge_2 )

	static short s_chance_to_dodge = 50;
	static short b_index = -1;
	static boolean b_at_dodge_point_1 = FALSE;
	static short s_chance_to_run = 70;
	static short s_roll = -1;

	repeat
		if( object_get_recent_shield_damage( ai_vehicle_get_from_spawn_point( driver_spawn_point ) ) > 0.0 or object_get_recent_body_damage( ai_vehicle_get_from_spawn_point( driver_spawn_point ) ) > 0.0 ) then
			s_roll = random_range( 0 , 100 );
			if( s_roll <= s_chance_to_dodge ) then
				if( b_index < 0 or b_index > 1  ) then
					//dprint( "I think I'll move to 0" );
					cs_run_command_script( driver_spawn_point, dodge_0 );
					b_index = 0;
				elseif( b_index < 1 ) then
					//dprint( "I think I'll move to 1" );
					cs_run_command_script( driver_spawn_point, dodge_1 );
					b_index = 1;
				else
					//dprint( "I think I'll move to 2" );
					cs_run_command_script( driver_spawn_point, dodge_2 );
					b_index = 2;
				end
				sleep_s( 5.0 );
			end
			sleep_s( 2.0 );
		end
	until( ai_living_count( squad_name ) <= count_to_run or object_get_health( ai_vehicle_get_from_spawn_point( driver_spawn_point ) ) < 0.5, 1 );
	//dprint( "Thinking about leaving" );
	cs_vehicle_speed( driver_spawn_point, 0.33 );
	sleep_s( 7.0 );
	s_roll = random_range( 0 , 100 );
	if( s_roll <= s_chance_to_run ) then
		//dprint( "Bugging out" );
		cs_run_command_script( driver_spawn_point, the_exit );
	end

end