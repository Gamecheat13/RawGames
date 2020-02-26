//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_hallways (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GUNS: HALLWAY ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_startup::: Startup
script startup f_guns_hallway_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_guns_hallway_startup :::" );

	// init crash
	wake( f_guns_hallway_init );

end

// === f_guns_hallway_init::: Initialize
script dormant f_guns_hallway_init()
	//dprint( "::: f_guns_hallway_init :::" );
	
	// setup cleanup
	wake( f_guns_hallway_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() >= S_ZONESET_LOOKOUT_EXIT) and (zoneset_current() <= S_ZONESET_ATRIUM_RETURNING), 1 );

	// init modules
	wake( f_guns_hallway_ai_init );
	wake( f_guns_hallway_narrative_init );

	// init sub modules
	wake( f_guns_hallway_doors_init );
//	wake( f_guns_hallway_teaser_init );
	
	// setup trigger
	wake( f_guns_hallway_trigger );

end

// === f_guns_hallway_deinit::: Deinitialize
script dormant f_guns_hallway_deinit()
	//dprint( "::: f_guns_hallway_deinit :::" );

	// deinit modules
	wake( f_guns_hallway_ai_deinit );
	wake( f_guns_hallway_narrative_deinit );

	// deinit sub modules
	wake( f_guns_hallway_doors_deinit );
//	wake( f_guns_hallway_teaser_deinit );

	// kill functions
	kill_script( f_guns_hallway_init );
	kill_script( f_guns_hallway_trigger );
	kill_script( f_guns_hallway_start );
	kill_script( f_guns_hallway_action );

end

// === f_guns_hallway_cleanup::: Cleanup
script dormant f_guns_hallway_cleanup()
	sleep_until( zoneset_current() > S_ZONESET_ATRIUM_RETURNING, 1 );
	//dprint( "::: f_guns_hallway_cleanup :::" );

	// Deinitialize
	wake( f_guns_hallway_deinit );

	// collect garbages
	sleep( 1 );
	garbage_collect_now();

end

// === f_guns_hallway_trigger::: Trigger
script dormant f_guns_hallway_trigger()
	//dprint( "::: f_guns_hallway_trigger :::" );

	// start
	wake( f_guns_hallway_start );
	
	// started area
	sleep_until( f_guns_hallway_started(), 1 );
	//dprint( "::: f_guns_hallway_trigger: A :::" );
	wake( f_dialog_atrium_return_hallway );

	// action
	sleep_until( f_guns_hallway_entered(), 1 );
	//dprint( "::: f_guns_hallway_trigger: B :::" );
	wake( f_guns_hallway_action );

	// mid-checkpoint
	sleep_until( f_ai_is_defeated(sg_guns_hallway_hub_enemies) or f_ai_is_defeated(sg_guns_hallway_lower) or f_ai_is_defeated(sg_guns_hallway_upper), 1 );
	//dprint( "::: f_guns_hallway_trigger: C :::" );
	if ( not f_ai_is_defeated(sg_guns_hallway_upper) ) then
		//dprint( "::: f_guns_hallway_trigger: D :::" );
		checkpoint_no_timeout( TRUE, "f_guns_hallway_trigger: MID" );	
	end
	
	// final checkpoint 
	sleep_until( f_ai_is_defeated(sg_guns_hallway_upper), 1 );
	//dprint( "::: f_guns_hallway_trigger: E :::" );
	
	// set objective
	if ( f_objective_current_index() < DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER() ) then
		f_objective_set( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER(), TRUE, TRUE, FALSE, TRUE );
	end

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_guns_hallway_trigger: FINAL" );	

end

// === f_guns_hallway_start::: Start
script dormant f_guns_hallway_start()
	//dprint( "::: f_guns_hallway_start :::" );

	// set datamining
	data_mine_set_mission_segment( "m80_Guns_Hallway" );
	
	// collect garbages
	//garbage_collect_now();

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_guns_hallway_start" );	

end

// === f_guns_hallway_action::: Action
script dormant f_guns_hallway_action()
	//dprint( "::: f_guns_hallway_action :::" );

	// set gun close
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_CLOSE() );

	// dialog
	wake( m80_atrium_return_covenant );

end

// === f_guns_hallway_started::: Checks if the area was started
script static boolean f_guns_hallway_started()
static boolean b_started = FALSE;

	if ( (not b_started) and object_valid(door_turret_hub_enter_maya) ) then
		b_started = ( device_get_position(door_turret_hub_enter_maya) > 0.0 );
	end
 
	// return
	b_started;

end

// === f_guns_hallway_entered::: Checks if the area was entered
script static boolean f_guns_hallway_entered()
static boolean b_entered = FALSE;

	if ( not b_entered ) then
		b_entered = volume_test_players( tv_guns_hallway_entered );
	end
 
	// return
	b_entered;

end

// === f_guns_hallway_entered::: Checks if the area was entered
script static boolean f_guns_hallway_return_started()
static boolean b_started = FALSE;

	if ( not b_started ) then
		b_started = ( zoneset_current_active() >= S_ZONESET_LOOKOUT_HALLWAYS_B );
	end
 
	// return
	b_started;

end

// === f_guns_hallway_mid::: Checks if the area was mid
script static boolean f_guns_hallway_mid()
static boolean b_mid = FALSE;

	if ( not b_mid ) then
		b_mid = ( ai_living_count(sg_guns_hallway_lower) <= 2 ) or volume_test_players(tv_guns_hallway_scan);
	end
 
	// return
	b_mid;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_doors_init::: Init
script dormant f_guns_hallway_doors_init()
	//dprint( "::: f_guns_hallway_doors_init :::" );
	
	// init sub modules
	wake( f_guns_hallway_a_door_enter_init );
	wake( f_guns_hallway_a_door_exit_init );
	wake( f_guns_hallway_b_door_enter_init );
	wake( f_guns_hallway_b_door_exit_init );
	
end

// === f_guns_hallway_doors_deinit::: Deinit
script dormant f_guns_hallway_doors_deinit()
	//dprint( "::: f_guns_hallway_doors_deinit :::" );

	// deinit sub modules
	wake( f_guns_hallway_a_door_enter_deinit );
	wake( f_guns_hallway_a_door_exit_deinit );
	wake( f_guns_hallway_b_door_enter_deinit );
	wake( f_guns_hallway_b_door_exit_deinit );
	
	// kill functions
	kill_script( f_guns_hallway_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: A: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_a_door_enter_init::: Init
script dormant f_guns_hallway_a_door_enter_init()
	sleep_until( object_valid(door_turret_hub_enter_maya) and object_active_for_script(door_turret_hub_enter_maya), 1 );
	//dprint( "::: f_guns_hallway_a_door_enter_init :::" );

	// setup door
	//door_turret_hub_enter_maya->speed_setup( 6.0, 1.5 );

	// wait for zone timing
	sleep_until( (zoneset_current() == S_ZONESET_LOOKOUT_EXIT) or (zoneset_current() == S_ZONESET_LOOKOUT_HALLWAYS_A), 1 );

	// setup auto disable	
	thread( door_turret_hub_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_LOOKOUT_HALLWAYS_B, -1) );

	// open
	door_turret_hub_enter_maya->zoneset_auto_open_setup( S_ZONESET_LOOKOUT_HALLWAYS_A, TRUE, TRUE, -1, S_ZONESET_LOOKOUT_HALLWAYS_A, TRUE );
	door_turret_hub_enter_maya->auto_distance_open( -4.5, FALSE );
	
	// set objective
	f_objective_set_timer_reminder( DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER(), TRUE, FALSE, FALSE, TRUE ); 
	
	// close
	door_turret_hub_enter_maya->auto_trigger_close_all_out( tv_guns_hallway_a_door_enter_close_out, TRUE );

	// force closed
	door_turret_hub_enter_maya->close_immediate();
	
end

// === f_guns_hallway_a_door_enter_deinit::: Deinit
script dormant f_guns_hallway_a_door_enter_deinit()
	//dprint( "::: f_guns_hallway_a_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_a_door_enter_init );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//GUNS: HALLWAY: A: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_a_door_exit_init::: Init
script dormant f_guns_hallway_a_door_exit_init()
local long l_thread = 0;
	sleep_until( object_valid(door_turret_hub_exit_maya) and object_active_for_script(door_turret_hub_exit_maya), 1 );
	//dprint( "::: f_guns_hallway_a_door_exit_init :::" );

	// setup door
	//door_turret_hub_exit_maya->speed_close( 1.5 );

	// setup auto disable	
	thread( door_lookout_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_LOOKOUT_HALLWAYS_B, -1) );

	// open
	sleep_until(
		(
			( ai_living_count(sg_guns_hallway_hub_enemies) > 0 )
			and
			( objects_distance_to_object(ai_actors(sg_guns_hallway_hub_enemies),door_turret_hub_exit_maya) <= 2.25 )
		)
		or
		( objects_distance_to_object(Players(),door_turret_hub_exit_maya) <= 4.0 )
		or
		( zoneset_current() >= S_ZONESET_LOOKOUT_HALLWAYS_B )
	, 1 );
	l_thread = thread( door_turret_hub_exit_maya->open() );
	sleep_until( door_turret_hub_exit_maya->position_open_check() or (zoneset_current() >= S_ZONESET_LOOKOUT_HALLWAYS_B), 1 );
	kill_thread( l_thread );

	// close
	door_turret_hub_exit_maya->zoneset_auto_close_setup( S_ZONESET_LOOKOUT_HALLWAYS_B, TRUE, FALSE, -1, S_ZONESET_LOOKOUT_HALLWAYS_B, TRUE );
	door_turret_hub_exit_maya->auto_trigger_close_all_out( tv_guns_hallway_a_door_exit_close_out, TRUE );

	// force closed
	door_turret_hub_exit_maya->close_immediate();
	
	// force guns to shut down now
	wake( f_guns_deinit );
	
end

// === f_guns_hallway_a_door_exit_deinit::: Deinit
script dormant f_guns_hallway_a_door_exit_deinit()
	//dprint( "::: f_guns_hallway_a_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_a_door_exit_init );
	///kill_script( f_guns_hallway_a_door_exit_trigger );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: B: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_b_door_enter_init::: Init
script dormant f_guns_hallway_b_door_enter_init()
	sleep_until( object_valid(door_atrium_return_enter_maya) and object_active_for_script(door_atrium_return_enter_maya), 1 );
	//dprint( "::: f_guns_hallway_b_door_enter_init :::" );

	// setup auto disable	
	thread( door_atrium_return_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_ATRIUM_RETURNING, -1) );

	// open
	door_atrium_return_enter_maya->zoneset_auto_open_setup( S_ZONESET_LOOKOUT_HALLWAYS_B, TRUE, TRUE, -1, S_ZONESET_LOOKOUT_HALLWAYS_B, TRUE );
	door_atrium_return_enter_maya->auto_trigger_open_any_in( tv_door_atrium_return_enter_open_in, FALSE );

	// close
	door_atrium_return_enter_maya->zoneset_auto_close_setup( S_ZONESET_ATRIUM_RETURNING, TRUE, FALSE, -1, S_ZONESET_ATRIUM_RETURNING, TRUE );
	door_atrium_return_enter_maya->auto_trigger_close_all_out( tv_door_atrium_return_enter_close_out, TRUE );

	// complete the enter objective
	f_objective_complete( DEF_R_OBJECTIVE_ATRIUM_RETURN_ENTER(), FALSE, TRUE );

	// force closed
	door_atrium_return_enter_maya->close_immediate();

end

// === f_guns_hallway_b_door_enter_deinit::: Deinit
script dormant f_guns_hallway_b_door_enter_deinit()
	//dprint( "::: f_guns_hallway_b_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_b_door_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: B: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_b_door_exit_init::: Init
script dormant f_guns_hallway_b_door_exit_init()
	sleep_until( object_valid(door_atrium_return_exit_maya) and object_active_for_script(door_atrium_return_exit_maya), 1 );
	//dprint( "::: f_guns_hallway_b_door_exit_init :::" );

	// setup auto disable	
	thread( door_atrium_return_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_ATRIUM_LOOKOUT, -1) );

	// open
	sleep_until( zoneset_current_active() == S_ZONESET_LOOKOUT_HALLWAYS_B, 1 );
	door_atrium_return_exit_maya->zoneset_auto_open_setup( S_ZONESET_ATRIUM_RETURNING, TRUE, TRUE, -1, S_ZONESET_ATRIUM_RETURNING, TRUE );
	door_atrium_return_exit_maya->auto_distance_open( -4.25, FALSE );
	
	// set objective
	if ( f_objective_current_index() < DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER() ) then
		f_objective_set( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER(), TRUE, TRUE, FALSE, TRUE );
	end
	
	// open
	door_atrium_return_exit_maya->zoneset_auto_close_setup( S_ZONESET_ATRIUM_LOOKOUT, TRUE, FALSE, -1, S_ZONESET_ATRIUM_LOOKOUT, TRUE );
	door_atrium_return_exit_maya->auto_trigger_close_all_in( tv_guns_hallway_b_door_exit_close_in, TRUE );

	// force closed
	door_atrium_return_exit_maya->close_immediate();

	// cleanup
	wake( f_guns_hallway_deinit );
	
end

// === f_guns_hallway_b_door_exit_deinit::: Deinit
script dormant f_guns_hallway_b_door_exit_deinit()
	//dprint( "::: f_guns_hallway_b_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_b_door_exit_init );
	
end
