//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_airlocks (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AIRLOCKS: ONE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_airlock_index = 														1;

global short S_airlock_one_01_state = 										DEF_S_AIRLOCK_STATE_INIT;
global short S_airlock_one_02_state = 										DEF_S_AIRLOCK_STATE_INIT;
global short S_airlock_one_03_state = 										DEF_S_AIRLOCK_STATE_INIT;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_airlocks_one_init::: Initialize
script dormant f_airlocks_one_init()
	//dprint( "::: f_airlocks_one_init :::" );
	
	// setup cleanup
	wake( f_airlocks_one_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() == S_ZONESET_TO_AIRLOCK_ONE) or (zoneset_current_active() == S_ZONESET_TO_AIRLOCK_ONE_B), 1 );
	
	// init modules
	wake( f_airlocks_one_ai_init ); 
	
	// init sub modules
	wake( f_airlocks_one_doors_init );
	wake( f_airlocks_one_gravity_init );
	wake( f_airlocks_one_props_init );
	
	// setup trigger
	wake( f_airlocks_one_trigger );

end

// === f_airlocks_one_deinit::: Deinitialize
script dormant f_airlocks_one_deinit()
	//dprint( "::: f_airlocks_one_deinit :::" );
	
	// reset airlocks index
	if ( f_airlocks_current_index_get() == S_airlock_index ) then
		f_airlocks_current_index_set( 0 );
	end
	
	// deinit modules
	wake( f_airlocks_one_ai_deinit );
	
	// init sub modules
	wake( f_airlocks_one_doors_deinit );
	wake( f_airlocks_one_gravity_deinit );
	wake( f_airlocks_one_props_deinit );

	// kill functions
	kill_script( f_airlocks_one_init );
	kill_script( f_airlocks_one_trigger );
	kill_script( f_airlocks_one_start );
	kill_script( f_airlocks_one_start_bay_01 );
	kill_script( f_airlocks_one_start_bay_02 );
	kill_script( f_airlocks_one_start_bay_03 );

end

// === f_airlocks_one_cleanup::: Cleanup
script dormant f_airlocks_one_cleanup()
	sleep_until( (zoneset_current_active() > S_ZONESET_TO_AIRLOCK_TWO), 1 );
	//dprint( "::: f_airlocks_one_cleanup :::" );

	// Deinitialize
	wake( f_airlocks_one_deinit );

end

// === f_airlocks_one_trigger::: Trigger
script dormant f_airlocks_one_trigger() 
	//dprint( "::: f_airlocks_one_trigger :::" );
	
	// start
	sleep_until( f_airlocks_one_started(), 1 );	
	wake( f_airlocks_one_start );

	// finish
	sleep_until( f_airlocks_one_finished(), 1 );

	// post dialog (location 01)
	wake( f_dialog_m80_airlock_covenant_assault );
	
	// zone load
	if ( zoneset_current() <= S_ZONESET_TO_AIRLOCK_TWO ) then
		zoneset_prepare_and_load( S_ZONESET_TO_AIRLOCK_TWO );
	end
	
	// checkpoint
	checkpoint_no_timeout( TRUE, "f_airlocks_one_trigger: AIRLOCK ONE FINISHED", 10.0 );

end

// === f_airlocks_one_start::: Starts the airlock area
script dormant f_airlocks_one_start()
	//dprint( "::: f_airlocks_one_start :::" );.
	
	// set datamining
	data_mine_set_mission_segment( "m80_Airlock_One" );
	
	// set objective
	f_objective_set( DEF_R_OBJECTIVE_AIRLOCKS_ONE(), TRUE, FALSE, FALSE, TRUE );

	// set airlock index
	f_airlocks_current_index_set( S_airlock_index );
	
	// setup airlocks
	wake( f_airlocks_one_start_bay_01 );
	wake( f_airlocks_one_start_bay_02 );
	wake( f_airlocks_one_start_bay_03 );

	// collect garbages
	//garbage_collect_now();
	
	// checkpoint
	checkpoint_no_timeout( TRUE, "f_airlocks_one_start" );	
	
end

// === f_airlocks_one_start_bay_01::: Starts the airlock bay
script dormant f_airlocks_one_start_bay_01()
	//dprint( "::: f_airlocks_one_start_bay_01 :::" );
	
	f_airlocks_bay_manage(
		S_airlock_index, 
		1, 
		DEF_S_AIRLOCK_STATE_INNER_OPEN_IMMEDIATE, 
		DEF_S_AIRLOCK_STATE_COMPLETE, 
		sg_airlock_one_initial, 
		3.0,
		fx_12_airlock_one_door_3_a, 
		fx_12_airlock_one_door_3_b, 
		fx_12_airlock_one_door_3_c
	);

end

// === f_airlocks_one_start_bay_02::: Starts the airlock bay
script dormant f_airlocks_one_start_bay_02()
	//dprint( "::: f_airlocks_one_start_bay_02 :::" );

	// setup ai trigger
	wake( f_airlocks_one_ai_bay_02_trigger );

	f_airlocks_bay_manage(
		S_airlock_index, 
		2, 
		DEF_S_AIRLOCK_STATE_DEFAULT, 
		DEF_S_AIRLOCK_STATE_COMPLETE, 
		sg_airlock_one_outside_bay_02, 
		0.0,
		fx_12_airlock_one_door_2_a, 
		fx_12_airlock_one_door_2_b, 
		fx_12_airlock_one_door_2_c
	);

end

// === f_airlocks_one_start_bay_03::: Starts the airlock bay
script dormant f_airlocks_one_start_bay_03()
	//dprint( "::: f_airlocks_one_start_bay_03 :::" );

	// setup ai trigger
	wake( f_airlocks_one_ai_bay_03_trigger );

	f_airlocks_bay_manage(
		S_airlock_index, 
		3, 
		DEF_S_AIRLOCK_STATE_DEFAULT, 
		DEF_S_AIRLOCK_STATE_COMPLETE, 
		sg_airlock_one_outside_bay_03, 
		0.0,
		fx_12_airlock_one_door_1_a, 
		fx_12_airlock_one_door_1_b, 
		fx_12_airlock_one_door_1_c
	);

end

// === f_airlocks_one_started::: Checks if the area was started
script static boolean f_airlocks_one_started()
static boolean b_started = FALSE;

	if ( not b_started ) then
		b_started = volume_test_players( tv_airlock_one_start_01 ) or volume_test_players( tv_airlock_one_start_02 );
	end

	// return
	b_started;
end

// === f_airlocks_one_entered::: Checks if the area was entered
script static boolean f_airlocks_one_entered()
static boolean b_entered = FALSE;

	if ( not b_entered ) then
		b_entered = volume_test_players( tv_airlock_one_entered_01 ) or volume_test_players( tv_airlock_one_entered_02 );
	end

	// return
	b_entered;
end

// === f_airlocks_one_bays_finished::: Checks if the area BAYS are finished
script static boolean f_airlocks_one_bays_finished()
static boolean b_finished = FALSE;

	if ( not b_finished ) then
		b_finished = ( f_airlocks_one_state_get(1) >= DEF_S_AIRLOCK_STATE_EJECT ) and ( f_airlocks_one_state_get(2) >= DEF_S_AIRLOCK_STATE_EJECT ) and ( f_airlocks_one_state_get(3) >= DEF_S_AIRLOCK_STATE_EJECT );
	end

	// return
	b_finished;

end

// === f_airlocks_one_finished::: Checks if the area was finished
script static boolean f_airlocks_one_finished()
static boolean b_finished = FALSE;

	if ( not b_finished ) then
		b_finished = ( ai_living_count(sg_airlock_one) <= 0 ) and f_airlocks_one_bays_finished();
	end

	// return
	b_finished;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: STATE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_state_set::: Set
script static void f_airlocks_one_state_set( short s_bay_id, short s_state )
	//dprint( "::: f_airlocks_one_state_set :::" );
	//inspect( s_bay_id );
	if ( f_airlocks_one_state_get(s_bay_id) != s_state ) then
	
		if ( s_bay_id == 1 ) then
			S_airlock_one_01_state = s_state;
		elseif ( s_bay_id == 2 ) then
			S_airlock_one_02_state = s_state;
		else
			S_airlock_one_03_state = s_state;
		end
	
		//inspect( s_state );
	end
end

// === f_airlocks_one_state_get::: Get
script static short f_airlocks_one_state_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		S_airlock_one_01_state;
	elseif ( s_bay_id == 2 ) then
		S_airlock_one_02_state;
	else
		S_airlock_one_03_state;
	end

end

// === f_airlocks_one_door_inner_get::: Get
script static object_name f_airlocks_one_door_inner_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		door_airlock_one_inner_1_maya;
	elseif ( s_bay_id == 2 ) then
		door_airlock_one_inner_2_maya;
	else
		door_airlock_one_inner_3_maya;
	end

end

// === f_airlocks_one_button_get::: Get
script static object_name f_airlocks_one_button_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		button_airlock_one_inner_1;
	elseif ( s_bay_id == 2 ) then
		button_airlock_one_inner_2;
	else
		button_airlock_one_inner_3;
	end

end

// === f_airlocks_one_button_get::: Get
script static object_name f_airlocks_one_gravity_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		low_grav_airlock_one_door_1;
	elseif ( s_bay_id == 2 ) then
		low_grav_airlock_one_door_2;
	else
		low_grav_airlock_one_door_3;
	end

end

// === f_airlocks_one_button_get::: Get
script static object_name f_airlocks_one_vacuum_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		gravlift_airlock_one_1;
	elseif ( s_bay_id == 2 ) then
		gravlift_airlock_one_2;
	else
		gravlift_airlock_one_3;
	end

end

// === f_airlocks_one_door_outer_get::: Get
script static object_name f_airlocks_one_door_outer_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		door_airlock_one_outer_1_maya;
	elseif ( s_bay_id == 2 ) then
		door_airlock_one_outer_2_maya;
	else
		door_airlock_one_outer_3_maya;
	end

end

// === f_airlocks_one_bay_volume_get::: Get
script static trigger_volume f_airlocks_one_bay_volume_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		tv_airlock_one_bay_1_area;
	elseif ( s_bay_id == 2 ) then
		tv_airlock_one_bay_2_area;
	else
		tv_airlock_one_bay_3_area;
	end

end

// === f_airlocks_bay_volume_get::: Get
script static trigger_volume f_airlocks_one_eject_kill_volume_get()
	tv_airlock_one_eject_kill;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: GRAVITY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_gravity_init::: Init
script dormant f_airlocks_one_gravity_init()
	sleep_until( object_valid(airlock_one_exterior_gravity), 1 );
	//dprint( "::: f_airlocks_one_gravity_init :::" );
	
	// hide gravity object
	object_hide( airlock_one_exterior_gravity, TRUE );
	
end

// === f_airlocks_one_gravity_deinit::: Deinit
script dormant f_airlocks_one_gravity_deinit()
	//dprint( "::: f_airlocks_one_gravity_deinit :::" );

	if ( object_valid(airlock_one_exterior_gravity) ) then
		object_destroy( airlock_one_exterior_gravity );
	end
	
	// kill functions
	kill_script( f_airlocks_one_gravity_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_props_init::: Init
script dormant f_airlocks_one_props_init()
	sleep_until( (zoneset_current_active() >= S_ZONESET_TO_AIRLOCK_ONE) or (zoneset_current_active() <= S_ZONESET_AIRLOCK_TWO), 1 );
	//dprint( "::: f_airlocks_one_props_init :::" );
	
	object_create_folder( 'airlock_one_crates' );
	
end

// === f_airlocks_one_props_deinit::: Deinit
script dormant f_airlocks_one_props_deinit()
	//dprint( "::: f_airlocks_one_props_deinit :::" );

	object_destroy_folder( 'airlock_one_crates' );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_doors_init::: Init
script dormant f_airlocks_one_doors_init()
	//dprint( "::: f_airlocks_one_doors_init :::" );
	
	// init sub modules
	wake( f_airlocks_one_door_enter_main_init );
	wake( f_airlocks_one_door_enter_side_init );
	wake( f_airlocks_one_door_exit_init );
	
end

// === f_airlocks_one_doors_deinit::: Deinit
script dormant f_airlocks_one_doors_deinit()
	//dprint( "::: f_airlocks_one_doors_deinit :::" );

	// deinit sub modules
	wake( f_airlocks_one_door_enter_main_deinit );
	wake( f_airlocks_one_door_enter_side_deinit );
	wake( f_airlocks_one_door_exit_deinit );
	
	// kill functions
	kill_script( f_airlocks_one_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: DOOR: ENTER: MAIN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_door_enter_main_init::: Init
script dormant f_airlocks_one_door_enter_main_init()

	// wait for area to be ready
	sleep_until( f_airlocks_one_started() and (zoneset_current() <= S_ZONESET_AIRLOCK_ONE), 1 );

	sleep_until( object_valid(door_airlock_one_enter_maya) and object_active_for_script(door_airlock_one_enter_maya), 1 );
	//dprint( "::: f_airlocks_one_door_enter_main_init :::" );
	
	// setup door properties
	door_airlock_one_enter_maya->speed_setup( 5.0 );

	// setup auto disable	
	thread( door_airlock_one_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_AIRLOCK_ONE, -1) );

	// open
	if ( zoneset_current() <= S_ZONESET_TO_AIRLOCK_ONE_B ) then
	
		door_airlock_one_enter_maya->zoneset_auto_open_setup( S_ZONESET_TO_AIRLOCK_ONE_B, TRUE, TRUE, -1, S_ZONESET_TO_AIRLOCK_ONE_B, TRUE );
		thread( door_airlock_one_enter_maya->open() );
		sleep_until( door_airlock_one_enter_maya->position_open_check() or (zoneset_current() >= S_ZONESET_AIRLOCK_ONE), 1 );
		
	end

	// close
	door_airlock_one_enter_maya->auto_trigger_close_all_out( tv_airlock_one_door_enter_close, TRUE );

	// force closed
	door_airlock_one_enter_maya->close_immediate();

	// zone load
	if ( (zoneset_current() < S_ZONESET_AIRLOCK_ONE) and ((device_get_position(door_airlock_one_enter_maya) <= 0.0) and (device_get_position(door_to_airlock_one_exit_maya) <= 0.0)) ) then
		zoneset_prepare_and_load( S_ZONESET_AIRLOCK_ONE );
	end

end

// === f_airlocks_one_door_enter_main_deinit::: Deinit
script dormant f_airlocks_one_door_enter_main_deinit()
	//dprint( "::: f_airlocks_one_door_enter_main_deinit :::" );
	
	// kill functions
	kill_script( f_airlocks_one_door_enter_main_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: DOOR: ENTER: SIDE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_door_enter_side_init::: Init
script dormant f_airlocks_one_door_enter_side_init()

	// wait for area to be ready
	sleep_until( f_airlocks_one_started() and (zoneset_current() <= S_ZONESET_AIRLOCK_ONE), 1 );

	sleep_until( object_valid(door_to_airlock_one_exit_maya) and object_active_for_script(door_to_airlock_one_exit_maya), 1 );
	//dprint( "::: f_airlocks_one_door_enter_main_init :::" );

	// setup door properties
	door_to_airlock_one_exit_maya->speed_setup( 5.0 );

	// setup auto disable	
	thread( door_to_airlock_one_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_AIRLOCK_ONE, -1) );

	// open
	if ( zoneset_current() <= S_ZONESET_TO_AIRLOCK_ONE_B ) then
	
		door_to_airlock_one_exit_maya->zoneset_auto_open_setup( S_ZONESET_TO_AIRLOCK_ONE_B, TRUE, TRUE, -1, S_ZONESET_TO_AIRLOCK_ONE_B, TRUE );
		thread( door_to_airlock_one_exit_maya->open() );
		sleep_until( door_to_airlock_one_exit_maya->position_open_check() or (zoneset_current() >= S_ZONESET_AIRLOCK_ONE), 1 );
		
	end

	// close
	door_to_airlock_one_exit_maya->auto_trigger_close_all_out( tv_airlock_one_door_enter_close, TRUE );

	// force closed
	door_to_airlock_one_exit_maya->close_immediate();

	
	// zone load
	if ( (zoneset_current() < S_ZONESET_AIRLOCK_ONE) and ((door_airlock_one_enter_maya->position_close_check()) and (device_get_position(door_to_airlock_one_exit_maya) <= 0.0)) ) then
		zoneset_prepare_and_load( S_ZONESET_AIRLOCK_ONE );
	end
	
end

// === f_airlocks_one_door_enter_side_deinit::: Deinit
script dormant f_airlocks_one_door_enter_side_deinit()
	//dprint( "::: f_airlocks_one_door_enter_side_deinit :::" );
	
	// kill functions
	kill_script( f_airlocks_one_door_enter_side_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_door_exit_init::: Init
script dormant f_airlocks_one_door_exit_init()
	sleep_until( object_valid(door_airlock_one_exit_maya) and object_active_for_script(door_airlock_one_exit_maya), 1 );
	//dprint( "::: f_airlocks_one_door_exit_init :::" );

	// setup auto disable	
	thread( door_airlock_one_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_AIRLOCK_TWO, -1) );

	// open
	door_airlock_one_exit_maya->zoneset_auto_open_setup( S_ZONESET_TO_AIRLOCK_TWO, TRUE, TRUE, -1, S_ZONESET_TO_AIRLOCK_TWO, TRUE );
	door_airlock_one_exit_maya->auto_distance_open( -4.5, FALSE );
	
	// close
	door_airlock_one_exit_maya->zoneset_auto_close_setup( S_ZONESET_AIRLOCK_TWO, TRUE, FALSE, -1, S_ZONESET_AIRLOCK_TWO, TRUE );
	door_airlock_one_exit_maya->auto_trigger_close_all_out( tv_airlock_one_exit_close, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT(), FALSE, TRUE );

	// force closed
	door_airlock_one_exit_maya->close_immediate();
	
end

// === f_airlocks_one_door_exit_deinit::: Deinit
script dormant f_airlocks_one_door_exit_deinit()
	//dprint( "::: f_airlocks_one_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_airlocks_one_door_exit_init );
	
end
