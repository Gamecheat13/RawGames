//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// Mission: 					m80
//
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
/*
obj_<OBJECTIVE 1>				= "<OBJECTIVE TEXT>"
obj_<OBJECTIVE 2>				= "<OBJECTIVE TEXT>"
*/									

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// OBJECTIVES
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_R_OBJECTIVE_CRASH_EXIT()													01.0;		end

script static real DEF_R_OBJECTIVE_HORSESHOE_ENTER()										02.0;		end
script static real DEF_R_OBJECTIVE_HORSESHOE_SHIELD()										02.5;		end
script static real DEF_R_OBJECTIVE_HORSESHOE_CENTER()										02.7;		end
script static real DEF_R_OBJECTIVE_HORSESHOE_EXIT()											02.9;		end

script static real DEF_R_OBJECTIVE_LAB_ENTER()													03.0;		end
script static real DEF_R_OBJECTIVE_LAB_CONTROL()												03.9;		end

script static real DEF_R_OBJECTIVE_ATRIUM()															04.0;		end
script static real DEF_R_OBJECTIVE_ATRIUM_EXIT()												04.9;		end

script static real DEF_R_OBJECTIVE_HALLWAYS_ONE()												05.0;		end

script static real DEF_R_OBJECTIVE_AIRLOCKS_ONE()												06.0;		end
script static real DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT()									06.9;		end

script static real DEF_R_OBJECTIVE_AIRLOCKS_ENEMIES()										08.5;		end
script static real DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT()									08.9;		end

script static real DEF_R_OBJECTIVE_GUNS_ENTER()													09.0;		end
script static real DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT()									09.3;		end
script static real DEF_R_OBJECTIVE_GUNS_ONLINE()												09.5;		end
script static real DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE()									09.7;		end
script static real DEF_R_OBJECTIVE_GUNS_EXIT()													09.9;		end

script static real DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER()								10.0;		end
script static real DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER()								10.3;		end
script static real DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT()								10.5;		end

script static real DEF_R_OBJECTIVE_ELEVATOR_ENTER()											11.0;		end
script static real DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE()									11.3;		end
script static real DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN()						11.5;		end	
script static real DEF_R_OBJECTIVE_ELEVATOR_EXIT()											11.9;		end

script static real DEF_R_OBJECTIVE_COMPLETE()														12.0;		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_objective_activate_distance =															2.50;

// STARTUP --------------------------------------------------------------------------------------------------------------------------------------------------
script startup mission_objectives_startup()

	sleep_until( b_mission_started, 1 );
	thread( f_objective_pause_primary_manage(1, 'pause_primary_1_locate_tilson', DEF_R_OBJECTIVE_CRASH_EXIT(), -1, TRUE, DEF_R_OBJECTIVE_ATRIUM(), -1, FALSE, -1, -1) );
	thread( f_objective_pause_primary_manage(2, 'pause_primary_2_station_defenses', DEF_R_OBJECTIVE_ATRIUM_EXIT(), -1, TRUE, DEF_R_OBJECTIVE_GUNS_ONLINE(), -1, FALSE, -1, -1) );
	thread( f_objective_pause_primary_manage(3, 'pause_primary_3_rendezvous_tilson', DEF_R_OBJECTIVE_GUNS_EXIT(), -1, TRUE, DEF_R_OBJECTIVE_COMPLETE(), -1, FALSE, -1, -1) );
	thread( f_objective_pause_primary_manage(4, 'pause_primary_4_defend_composer', DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT(), -1, TRUE, DEF_R_OBJECTIVE_ELEVATOR_ENTER(), DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE(), TRUE, DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN(), -1, FALSE) );

end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_mission_objective_blip: Blips an objective index
script static boolean f_mission_objective_blip( real r_index, boolean b_blip )
local boolean b_blipped = FALSE;
	// set the default return value
	b_blipped = FALSE;

	//dprint( "::: f_mission_objective_blip :::" );
	//inspect( r_index );

	// DEF_R_OBJECTIVE_CRASH_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_CRASH_EXIT() ) then
		if ( b_blip ) then
			f_blip_flag( flg_objective_crash_exit, "default" );
		end
		if ( not b_blip ) then
			f_unblip_flag( flg_objective_crash_exit );
		end
		b_blipped = TRUE;
	end	

	// DEF_R_OBJECTIVE_HORSESHOE_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_ENTER() ) then
	
		static long l_horseshoe_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_horseshoe_enter_blip)) ) then
			l_horseshoe_enter_blip = f_blip_auto_flag_trigger( flg_objective_horseshoe_enter, "default", tv_objective_horseshoe_enter_blip_in, TRUE );
		end
		if ( not b_blip ) then
			kill_thread( l_horseshoe_enter_blip );
		end
		
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_HORSESHOE_SHIELD()
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_SHIELD() ) then
	
		static long l_horseshoe_shield_blip = 0;
		if ( b_blip and (not isthreadvalid(l_horseshoe_shield_blip)) ) then
			l_horseshoe_shield_blip = f_blip_auto_flag_distance_toggle( flg_horseshoe_shield_control, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_horseshoe_shield_control, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_horseshoe_shield_control, 0.0 );
			kill_thread( l_horseshoe_shield_blip );
		end
		
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_HORSESHOE_CENTER()
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_CENTER() ) then

		static long l_horseshoe_center_blip = 0;
		if ( b_blip and (not isthreadvalid(l_horseshoe_center_blip)) ) then
			l_horseshoe_center_blip = f_blip_auto_flag_trigger( flg_objective_horseshoe_center, "default", tv_objective_horseshoe_center_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_horseshoe_center_blip );
		end
		
		b_blipped = TRUE;
	
	end
	// DEF_R_OBJECTIVE_HORSESHOE_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_EXIT() ) then
	
		static long l_horseshoe_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_horseshoe_exit_blip)) ) then
			l_horseshoe_exit_blip = f_blip_auto_flag_trigger( flg_objective_horseshoe_exit, "default", tv_objective_horseshoe_exit_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_horseshoe_exit_blip );
		end
	
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_LAB_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_LAB_ENTER() ) then
		
		static long l_lab_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_lab_enter_blip)) ) then
			l_lab_enter_blip = f_blip_auto_flag_trigger( flg_objective_lab_enter, "default", tv_coop_teleport_lab_exit_in, TRUE );
		end
		if ( not b_blip ) then
			kill_thread( l_lab_enter_blip );
		end
		
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_LAB_CONTROL()
	if ( r_index == DEF_R_OBJECTIVE_LAB_CONTROL() ) then
	
		static long l_lab_control_blip = 0;
		if ( b_blip and (not isthreadvalid(l_lab_control_blip)) ) then
			device_set_position( dc_lab_exit, 0.0 );
			l_lab_control_blip = f_blip_auto_flag_distance_toggle( flg_lab_exit_objective, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_lab_exit, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_lab_exit, 0.0 );
			kill_thread( l_lab_control_blip );
		end
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_ATRIUM()
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM() ) then
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_ATRIUM_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_EXIT() ) then
		
		static long l_atrium_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_atrium_exit_blip)) ) then
			l_atrium_exit_blip = f_blip_auto_flag_trigger( flg_objective_atrium_exit, "default", tv_objective_atrium_exit_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_atrium_exit_blip );
		end
		
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_HALLWAYS_ONE()
	if ( r_index == DEF_R_OBJECTIVE_HALLWAYS_ONE() ) then
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_AIRLOCKS_ONE()
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ONE() ) then
		b_blipped = TRUE;
	end
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT() ) then
		
		static long l_airlocks_one_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_airlocks_one_exit_blip)) ) then
			l_airlocks_one_exit_blip = f_blip_auto_flag_trigger( flg_objective_airlocks_one_exit, "default", tv_coop_teleport_airlock_two_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_airlocks_one_exit_blip );
		end
	
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_AIRLOCKS_ENEMIES()
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ENEMIES() ) then
		if ( b_blip ) then
			f_blip_ai( sg_airlock_two_units, "neutralize" );
		end
		if ( not b_blip ) then
			f_unblip_ai( sg_airlock_two_units );
		end
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT() ) then
		
		static long l_airlocks_two_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_airlocks_two_exit_blip)) ) then
			l_airlocks_two_exit_blip = f_blip_auto_flag_trigger( flg_objective_airlocks_two_exit, "default", tv_objective_airlocks_two_exit_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_airlocks_two_exit_blip );
		end
	
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_GUNS_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_GUNS_ENTER() ) then
		
		static long l_guns_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_guns_enter_blip)) ) then
			l_guns_enter_blip = f_blip_auto_flag_trigger( flg_objective_guns_enter, "default", tv_objective_guns_enter_blip_in, TRUE );
		end
		if ( not b_blip ) then
			kill_thread( l_guns_enter_blip );
		end
		
		b_blipped = TRUE;
	end
	
	// DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT()
	if ( r_index == DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT() ) then
	
		static long l_guns_plinth_insert = 0;
		if ( b_blip and (not isthreadvalid(l_guns_plinth_insert)) ) then
			l_guns_plinth_insert = f_blip_auto_flag_distance_toggle( flg_objective_guns_plinth, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_guns_plinth_insert, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_guns_plinth_insert, 0.0 );
			kill_thread( l_guns_plinth_insert );
		end
		//R_objective_activate_distance
		b_blipped = TRUE; 
	end
	// DEF_R_OBJECTIVE_GUNS_ONLINE()
	if ( r_index == DEF_R_OBJECTIVE_GUNS_ONLINE() ) then
		b_blipped = TRUE; 
	end
	// DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE()
	if ( r_index == DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE() ) then
	
		static long l_guns_plinth_remove = 0;
		if ( b_blip and (not isthreadvalid(l_guns_plinth_remove)) ) then
			l_guns_plinth_remove = f_blip_auto_flag_distance_toggle( flg_objective_guns_plinth, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_guns_plinth_remove, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_guns_plinth_remove, 0.0 );
			kill_thread( l_guns_plinth_remove );
		end
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_GUNS_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_GUNS_EXIT() ) then
		
		static long l_guns_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_guns_exit_blip)) ) then
			l_guns_exit_blip = f_blip_auto_flag_trigger( flg_objective_guns_exit, "default", tv_objective_guns_exit_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_guns_exit_blip );
		end
		
		b_blipped = TRUE;
	end

	// DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER() ) then
		
		static long l_atrium_return_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_atrium_return_enter_blip)) ) then
			l_atrium_return_enter_blip = f_blip_auto_flag_trigger( flg_objective_atrium_return_enter, "default", tv_objective_atrium_return_enter_blip_in, TRUE );
		end
		if ( not b_blip ) then
			kill_thread( l_atrium_return_enter_blip );
		end
		
		b_blipped = TRUE;
	
	end
	// DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER() ) then
		
		static long l_atrium_lookout_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_atrium_lookout_enter_blip)) ) then
			l_atrium_lookout_enter_blip = f_blip_auto_flag_trigger( flg_objective_atrium_lookout_enter, "default", tv_objective_atrium_lookout_enter_blip_out, FALSE );
		end
		if ( not b_blip ) then
			kill_thread( l_atrium_lookout_enter_blip );
		end
		
		b_blipped = TRUE;
	
	end
	// DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT()
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT() ) then
		
		static long l_atrium_lookout_exit_blip = 0;
		if ( b_blip and (not isthreadvalid(l_atrium_lookout_exit_blip)) ) then
			l_atrium_lookout_exit_blip = f_blip_auto_flag_trigger( flg_objective_atrium_lookout_exit, "default", tv_objective_atrium_lookout_exit_blip_in, TRUE );
		end
		if ( not b_blip ) then
			kill_thread( l_atrium_lookout_exit_blip );
		end
		
		b_blipped = TRUE;
	
	end
	
	// DEF_R_OBJECTIVE_ELEVATOR_ENTER()
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_ENTER() ) then
		
		static long l_atrium_elevator_enter_blip = 0;
		if ( b_blip and (not isthreadvalid(l_atrium_elevator_enter_blip)) ) then
		
			// find the nearest flag
			local cutscene_flag flg_elevator_enter_flag = flg_objective_atrium_elevator_enter_right;
			if ( objects_distance_to_flag(Players(),flg_objective_atrium_elevator_enter_left) <= objects_distance_to_flag(Players(),flg_objective_atrium_elevator_enter_right) ) then
				flg_elevator_enter_flag = flg_objective_atrium_elevator_enter_left;
			end

			// setup main blip
			l_atrium_elevator_enter_blip = f_blip_auto_flag_trigger( flg_elevator_enter_flag, "default", tv_objective_atrium_elevator_enter_blip_out, FALSE );
			f_blip_auto_flag_trigger( flg_objective_atrium_elevator_enter_back, "default", tv_objective_atrium_elevator_enter_blip_out, TRUE, l_atrium_elevator_enter_blip );

		end
		if ( not b_blip ) then
			kill_thread( l_atrium_elevator_enter_blip );
		end
		
		b_blipped = TRUE;
	
	end

	// DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE()
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE() ) then
	
		static long l_elevator_activate = 0;
		if ( b_blip and (not isthreadvalid(l_elevator_activate)) ) then
			l_elevator_activate = f_blip_auto_flag_distance_toggle( flg_atrium_destruction_start, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_elevator_start, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_elevator_start, 0.0 );
			kill_thread( l_elevator_activate );
		end
		b_blipped = TRUE;
	end
	// DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN()
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN() ) then
		b_blipped = TRUE;
	end
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_EXIT() ) then
		static long l_elevator_exit = 0;
		if ( b_blip and (not isthreadvalid(l_elevator_exit)) ) then
			device_set_position( dc_elevator_exit, 0.0 );
			l_elevator_exit = f_blip_auto_flag_distance_toggle( flg_atrium_destruction_exit, "activate", "default", R_objective_activate_distance );
			device_set_power( dc_elevator_exit, 1.0 );
		end
		if ( not b_blip ) then
			device_set_power( dc_elevator_exit, 0.0 );
			kill_thread( l_elevator_exit );
		end
		b_blipped = TRUE;
	end
	
	// DEF_R_OBJECTIVE_COMPLETE()
	if ( r_index == DEF_R_OBJECTIVE_COMPLETE() ) then
		b_blipped = TRUE;
	end
	
	// return if something was blipped
	b_blipped;

end

// === f_mission_objective_title: Returns the index title title
script static string_id f_mission_objective_title( real r_index )
local string_id sid_return = SID_objective_none;


	if ( (DEF_R_OBJECTIVE_CRASH_EXIT() <= r_index) and (r_index <= DEF_R_OBJECTIVE_HORSESHOE_ENTER()) ) then
		sid_return = 'objective_title_crash';
	end

	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_SHIELD() ) then
		sid_return = 'objective_title_horseshoe';
	end

	if ( (DEF_R_OBJECTIVE_HORSESHOE_CENTER() <= r_index) and (r_index <= DEF_R_OBJECTIVE_LAB_CONTROL()) ) then
		sid_return = 'objective_title_crash';
	end

	if ( r_index == DEF_R_OBJECTIVE_ATRIUM() ) then
		sid_return = 'objective_title_atrium';
	end

	if ( (DEF_R_OBJECTIVE_ATRIUM_EXIT() <= r_index) and (r_index <= DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE()) ) then
		sid_return = 'objective_title_turrets';
	end
	
	if ( (DEF_R_OBJECTIVE_GUNS_EXIT() <= r_index) and (r_index <= DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER()) ) then
		sid_return = 'objective_title_final';
	end

	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT() ) then
		sid_return = 'objective_title_atrium_return';
	end

	if ( (DEF_R_OBJECTIVE_ELEVATOR_ENTER() <= r_index) and (r_index <= DEF_R_OBJECTIVE_COMPLETE()) ) then
		sid_return = 'objective_title_final';
	end

/*
	if ( r_index == DEF_R_OBJECTIVE_CRASH_EXIT() ) then
		sid_return = 'objective_title_crash';
	end

	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_ENTER() ) then
		sid_return = 'objective_title_crash';
	end
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_SHIELD() ) then
		sid_return = 'objective_title_horseshoe';
	end
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_CENTER() ) then
		sid_return = 'objective_title_crash';
	end
	if ( r_index == DEF_R_OBJECTIVE_HORSESHOE_EXIT() ) then
		sid_return = 'objective_title_crash';
	end

	if ( r_index == DEF_R_OBJECTIVE_LAB_ENTER() ) then
		sid_return = 'objective_title_crash';
	end
	if ( r_index == DEF_R_OBJECTIVE_LAB_CONTROL() ) then
		sid_return = 'objective_title_crash';
	end
	
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM() ) then
		sid_return = 'objective_title_atrium';
	end
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_EXIT() ) then
		sid_return = 'objective_title_turrets';
	end

	if ( r_index == DEF_R_OBJECTIVE_HALLWAYS_ONE() ) then
		sid_return = 'objective_title_turrets';
	end

	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ONE() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT() ) then
		sid_return = 'objective_title_turrets';
	end

	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_ENEMIES() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT() ) then
		sid_return = 'objective_title_turrets';
	end

	if ( r_index == DEF_R_OBJECTIVE_GUNS_ENTER() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_GUNS_ONLINE() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE() ) then
		sid_return = 'objective_title_turrets';
	end
	if ( r_index == DEF_R_OBJECTIVE_GUNS_EXIT() ) then
		sid_return = 'objective_title_final';
	end

	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER() ) then
		sid_return = 'objective_title_final';
	end
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER() ) then
		sid_return = 'objective_title_final';
	end
	if ( r_index == DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT() ) then
		sid_return = 'objective_title_atrium_return';
	end
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_ENTER() ) then
		sid_return = 'objective_title_final';
	end

	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE() ) then
		sid_return = 'objective_title_final';
	end
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN() ) then
		sid_return = 'objective_title_final';
	end
	if ( r_index == DEF_R_OBJECTIVE_ELEVATOR_EXIT() ) then
		sid_return = 'objective_title_final';
	end

	if ( r_index == DEF_R_OBJECTIVE_COMPLETE() ) then
		sid_return = 'objective_title_final';
	end
*/	
	// return
	sid_return;

end

// === f_mission_objective_missioncomplete::: Handles all the general mission complete
script static void f_mission_objective_missioncomplete()
	//dprint( "::: f_mission_objective_missioncomplete :::" );

	// disable controls, etc
	player_action_test_reset();

	player_enable_input( 0 );
	camera_control( 1 );

	// complete current index
	f_objective_complete( f_objective_current_index(), FALSE, TRUE );
	
	// general mission complete
	f_objective_missioncomplete();

end


/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// OBJECTIVES LIST
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
//global short S_objective_list_lichride_index = 					0;
global short S_objective_list_crash_index = 						1;
global short S_objective_list_horseshoe_index = 				2;
global short S_objective_list_atrium_index = 						3;
global short S_objective_list_turrets_index = 					4;
global short S_objective_list_atrium_return_index = 		5;
global short S_objective_list_final_index = 						6;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_objective_list_crash_start::: Start
script dormant f_objective_list_crash_start()
	//dprint( "::: f_objective_list_crash_start :::" );

	objectives_show( S_objective_list_crash_index );
	
end

// === f_objective_list_crash_end::: Start
script static void f_objective_list_crash_end()
	//dprint( "::: f_objective_list_crash_end :::" );

	objectives_finish( S_objective_list_crash_index );

end
*/