//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// lich
// =================================================================================================
// =================================================================================================
// defines

// variables
global boolean B_lich_chief_jumped = FALSE;

// functions
// === f_lich_startup::: Auto startup
script startup f_lich_startup()
	sleep_until( b_mission_started, 1 );
	
	// wake init
	wake( f_lich_init );
	
end

// === f_lich_init::: Initialize
script dormant f_lich_init()

	// disable the kill volume by default
	kill_volume_disable( kill_lich );

	// setup cleanup watch
	wake( f_lich_cleanup );
	//XXX PUT BACK AFTER UR
	//sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_03_EXIT, 1 );
	sleep_until( current_zone_set_fully_active() >= DEF_S_ZONESET_SPIRE_03_INT_D, 1 );
	data_mine_set_mission_segment ("m70_lich_end"); 
	dprint( "::: f_lich_init :::" );
	if object_valid(cr_didact_ship) then
		object_destroy(cr_didact_ship);
	end
	// init sub modules
	wake( f_lich_props_init );

	// setup trigger
	wake( f_lich_trigger );

end

// === f_lich_deinit::: Deinitialize
script dormant f_lich_deinit()
	dprint( "::: f_lich_deinit :::" );

	// kill functions
	kill_script( f_lich_init );
	kill_script( f_lich_action );
	kill_script( f_lich_trigger );
	
	// deinit sub modules
	wake( f_lich_props_deinit );

end

// === f_lich_cleanup::: Cleanup area
script dormant f_lich_cleanup()
	sleep_until( f_objective_missioncomplete_check(), 1 );
	dprint( "::: f_lich_cleanup :::" );

	wake( f_lich_deinit );
	
end

// === f_lich_trigger::: Trigger
script dormant f_lich_trigger()
	sleep_until( f_spire_state_complete(DEF_SPIRE_03), 1 );
	dprint( "::: f_lich_trigger :::" );

	// action
	wake( f_lich_action );

	// blip the lich
  sleep_until( dialog_id_played_check(L_dlg_spire_03_outro_01) or dialog_foreground_id_line_index_check_greater(L_dlg_spire_03_outro_01, S_dlg_spire_03_outro_01_blip), 1 );
  if ( not object_valid(scn_lich_target_01) ) then
  	object_create_anew( scn_lich_target_01 );
  end
  
  f_objective_blip( DEF_R_OBJECTIVE_LICH(), TRUE, FALSE );
  
	sleep_until(volume_test_players(tv_lich_jump_blip), 1);
	sleep_s(1);
	f_unblip_flag(flg_lich_jump);
	sleep_s(1);
	f_blip_object(scn_lich_target_01, "recon");
	
	sleep_until(not volume_test_players(tv_lich_platform), 1);
	
	f_unblip_object(scn_lich_target_01);
end

// === f_lich_action::: Action the Lich sequence
script dormant f_lich_action()
local real r_time_min = 60.0;
local real r_time_max = 360.0;

	// start lich sequence
	dprint( "::: f_lich_action :::" );

	// enable the kill volume
	kill_volume_enable( kill_lich );
 
 // display the objectives
  f_objective_set( DEF_R_OBJECTIVE_LICH(), FALSE, FALSE, FALSE, TRUE );
  
  // setup end triggers
  thread(f_lich_win_trigger());
  /*
  thread( f_lich_end_trigger(Player0()) );
  thread( f_lich_end_trigger(Player1()) );
  thread( f_lich_end_trigger(Player2()) );
  thread( f_lich_end_trigger(Player3()) );
*/
	// move target liches
	sleep_until( volume_test_players(tv_lich_move) or dialog_id_played_check(L_dlg_spire_03_outro_01) or dialog_foreground_id_line_index_check_greater(L_dlg_spire_03_outro_01, S_dlg_spire_03_outro_01_blip), 1 ); 
	thread( f_lich_props_move(scn_lich_target_01, 0.0, 0.0, 180.0, 180.0, ps_lich.target_01, ps_lich.target_01, ps_lich.target_01, ps_lich.target_01, ps_lich.target_01, 0.75, 1.0, FALSE, FALSE) );
	thread( f_lich_props_move(scn_lich_target_02, 0.0, 0.0, 180.0, 180.0, ps_lich.target_02, ps_lich.target_02, ps_lich.target_02, ps_lich.target_02, ps_lich.target_02, 0.75, 1.0, FALSE, FALSE) );
	thread( f_lich_props_move(scn_lich_target_03, 0.0, 0.0, 180.0, 180.0, ps_lich.target_03, ps_lich.target_03, ps_lich.target_03, ps_lich.target_03, ps_lich.target_03, 0.75, 1.0, FALSE, FALSE) );

	//thread( f_lich_props_move(scn_lich_low_01, 0.0, 0.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, real_random_range(0.75,1.00), 0.0, TRUE, FALSE) );
	//thread( f_lich_props_move(scn_lich_low_02, 0.0, 0.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, real_random_range(0.75,1.00), 0.0, TRUE, FALSE) );
	//thread( f_lich_props_move(scn_lich_low_03, 0.0, 0.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, real_random_range(0.75,1.00), 0.0, TRUE, FALSE) );
	//thread( f_lich_props_move(scn_lich_low_04, 0.0, 0.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, real_random_range(0.75,1.00), 0.0, TRUE, FALSE) );
	//thread( f_lich_props_move(scn_lich_low_05, 0.0, 0.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, real_random_range(0.75,1.00), 0.0, TRUE, FALSE) );

end

script static boolean f_lich_win_volume() 
	volume_test_players(tv_lich_jump) or volume_test_players(tv_lich_win_01) or volume_test_players(tv_lich_win_02) or volume_test_players(tv_lich_win_03);
end

script static void f_lich_win_trigger()
	sleep_until(volume_test_players(tv_lich_jump) or volume_test_players(tv_lich_win_01) or volume_test_players(tv_lich_win_02) or volume_test_players(tv_lich_win_03), 1);
	kill_script( f_dlg_spire_03_outro_01 );
	kill_script( f_lich_trigger );
	//thread( ins_cinematic_end() );
	//xxx might have to wait until cinematic ends
	f_mission_objective_missioncomplete();
end


script static void f_lich_end_trigger( object obj_player )
	sleep_until( object_get_health(obj_player) > 0.0 and (not volume_test_object(tv_lich_platform, obj_player)) and volume_test_object(tv_lich_jump, obj_player), 1 );
	
	dprint( "::: f_lich_end_trigger :::" );
	
	if ( not B_lich_chief_jumped ) then
		B_lich_chief_jumped = TRUE;
		kill_script( f_dlg_spire_03_outro_01 );
		kill_script( f_lich_trigger );
		//thread( ins_cinematic_end() );
		//xxx might have to wait until cinematic ends
		f_mission_objective_missioncomplete();
	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LICH: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lich_props_init::: Init


script dormant f_lich_props_init()
local real r_time_min = 30.0;
local real r_time_max = 90.0;
	dprint( "::: f_lich_props_init :::" );
/*
	// create start group
	object_create_folder( scn_lich_start );	
	
	thread( f_lich_props_move(scn_lich_extra_01, 00.5, 07.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_02, 20.0, 30.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_03, 10.0, 17.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_04, 20.0, 30.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_05, 10.0, 17.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_06, 00.5, 07.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_07, 20.0, 30.0, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	thread( f_lich_props_move(scn_lich_extra_08, 00.5, 07.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	//thread( f_lich_props_move(scn_lich_extra_09, 10.0, 17.5, r_time_min, r_time_max, ps_lich.extra_01, ps_lich.extra_02, ps_lich.extra_03, ps_lich.extra_04, ps_lich.extra_05, 1.0, 0.0, TRUE, TRUE) );
	*/
end

// === f_lich_props_deinit::: Deinit
script dormant f_lich_props_deinit()
	dprint( "::: f_lich_props_deinit :::" );

	object_destroy_folder( scn_lich_start );	
	object_destroy_folder( scn_lich_extras );	
	
	// kill functions
	kill_script( f_lich_props_init );
	kill_script( f_lich_props_move );
	
end

// === f_lich_props_move::: Moves a prop
script static void f_lich_props_move( object_name obj_prop, real r_delay_min, real r_delay_max, real r_time_min, real r_time_max, point_reference pr_point_01, point_reference pr_point_02, point_reference pr_point_03, point_reference pr_point_04, point_reference pr_point_05, real r_scale_min, real r_scale_max, boolean b_destroy, boolean b_recycle )
local real r_time = real_random_range( r_time_min, r_time_max );
local point_reference pr_point = pr_point_01;
	dprint( "::: f_guns_props_move :::" );

	// delay
	sleep_rand_s( r_delay_min, r_delay_max );

	// pick a point_reference
	begin_random_count( 1 )
		pr_point = pr_point_01;
		pr_point = pr_point_02;
		pr_point = pr_point_03;
		pr_point = pr_point_04;
		pr_point = pr_point_01;
	end

	// create
	if ( not object_valid(obj_prop) ) then
		object_create_anew( obj_prop );
	end
	object_set_always_active( obj_prop, TRUE );
	object_set_cinematic_visibility( obj_prop, TRUE );
	
	// down scale
	object_set_scale( obj_prop, r_scale_min, 0 );
	
	// up scale
	sleep( 1 );
	object_set_scale( obj_prop, r_scale_max, r_time * 30 );
	
	// move
	object_move_to_point( obj_prop, r_time, pr_point );
	
	// destroy
	if ( b_destroy or b_recycle ) then
		dprint( "::: f_guns_props_move: DESTROY :::" );
		object_destroy( obj_prop );
	end
	
	// destroy
	if ( b_recycle ) then
		dprint( "::: f_guns_props_move: RECYCLE :::" );
		thread( f_lich_props_move(obj_prop, 0.0, 0.5, r_time_min, r_time_max, pr_point_01, pr_point_02, pr_point_03, pr_point_04, pr_point_05, r_scale_min, r_scale_max, b_destroy, b_recycle) );
	end
	
end
