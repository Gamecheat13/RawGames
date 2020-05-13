//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
//  Mission: 					m80_delta
//	Insertion Points:	lookout	(or ilo)
//	Insertion Points:	atrium_return_lookout hallway (or igh)
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ATRIUM RETURN: LOOKOUT ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_return_lookout_startup::: Startup
script startup f_atrium_return_lookout_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_atrium_return_lookout_startup :::" );

	// init crash
	wake( f_atrium_return_lookout_init );

end

// === f_atrium_return_lookout_init::: Initialize
script dormant f_atrium_return_lookout_init()
	//dprint( "::: f_atrium_return_lookout_init :::" );

	// setup cleanup
	wake( f_atrium_return_lookout_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() >= S_ZONESET_ATRIUM_RETURNING) and (zoneset_current_active() <= S_ZONESET_ATRIUM_LOOKOUT), 1 );
	
	// init modules
	//wake( f_atrium_return_lookout_narrative_init );
	//wake( f_atrium_return_lookout_audio_init );
	//wake( f_atrium_return_lookout_fx_init );
	
	// init sub modules
	wake( f_atrium_return_lookout_doors_init );
	
	// setup trigger
	wake( f_atrium_return_lookout_trigger );

end

// === f_atrium_return_lookout_deinit::: Deinitialize
script dormant f_atrium_return_lookout_deinit()
	//dprint( "::: f_atrium_return_lookout_deinit :::" );
	
	// init modules
	//wake( f_atrium_return_lookout_narrative_deinit );
	//wake( f_atrium_return_lookout_audio_deinit );
	//wake( f_atrium_return_lookout_fx_deinit );
	
	// deinit sub modules
	wake( f_atrium_return_lookout_doors_deinit );

	// kill functions
	kill_script( f_atrium_return_lookout_init );
	kill_script( f_atrium_return_lookout_trigger );

end

// === f_atrium_return_lookout_cleanup::: Cleanup
script dormant f_atrium_return_lookout_cleanup()
	sleep_until( zoneset_current_active() > S_ZONESET_ATRIUM_DAMAGED, 1 );
	//dprint( "::: f_atrium_return_lookout_cleanup :::" );

	// Deinitialize
	wake( f_atrium_return_lookout_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_atrium_return_lookout_trigger::: Trigger
script dormant f_atrium_return_lookout_trigger()
	//dprint( "::: f_atrium_return_lookout_trigger :::" );

	wake( m80_covenant_chanting );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// atrium_return_lookout: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_return_lookout_doors_init::: Init
script dormant f_atrium_return_lookout_doors_init()
	//dprint( "::: f_atrium_return_lookout_doors_init :::" );
	
	// init sub modules
	wake( f_atrium_return_lookout_door_enter_init );
	wake( f_atrium_return_lookout_door_exit_init );
	
end

// === f_atrium_return_lookout_doors_deinit::: Deinit
script dormant f_atrium_return_lookout_doors_deinit()
	//dprint( "::: f_atrium_return_lookout_doors_deinit :::" );

	// deinit sub modules
	wake( f_atrium_return_lookout_door_enter_deinit );
	wake( f_atrium_return_lookout_door_exit_deinit );
	
	// kill functions
	kill_script( f_atrium_return_lookout_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// atrium_return_lookout: DOOR: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_return_lookout_door_enter_init::: Init
script dormant f_atrium_return_lookout_door_enter_init()
	sleep_until( object_valid(door_atrium_lookout_enter_maya) and object_active_for_script(door_atrium_lookout_enter_maya), 1 );
	//dprint( "::: f_atrium_return_lookout_door_enter_init :::" );

	// setup auto disable	
	thread( door_atrium_lookout_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_ATRIUM_DAMAGED, -1) );
	
	// open
	door_atrium_lookout_enter_maya->zoneset_auto_open_setup( S_ZONESET_ATRIUM_LOOKOUT, TRUE, TRUE, -1, S_ZONESET_ATRIUM_LOOKOUT, TRUE );
	door_atrium_lookout_enter_maya->auto_distance_open( -2.75, FALSE );

	// close
	door_lookout_enter_maya->auto_trigger_close_all_out( tv_atrium_return_lookout_door_enter_close_out, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER(), FALSE, TRUE );

	// force closed
	door_lookout_enter_maya->close_immediate();
	
end

// === f_atrium_return_lookout_door_enter_deinit::: Deinit
script dormant f_atrium_return_lookout_door_enter_deinit()
	//dprint( "::: f_atrium_return_lookout_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_return_lookout_door_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// atrium_return_lookout: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_return_lookout_door_exit_init::: Init
script dormant f_atrium_return_lookout_door_exit_init()
	sleep_until( object_valid(door_atrium_lookout_exit_maya) and object_active_for_script(door_atrium_lookout_exit_maya), 1 );
	//dprint( "::: f_atrium_return_lookout_door_exit_init :::" );

	sleep_until( (zoneset_current_active() == S_ZONESET_ATRIUM_LOOKOUT) and volume_test_players(tv_atrium_return_lookout_door_exit_open_in), 1 );
	//dprint( "::: f_atrium_return_lookout_door_exit_trigger - STARTED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! :::" );

	// setup auto disable	
	thread( door_atrium_lookout_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_ATRIUM_DAMAGED, -1) );

	// open
	door_atrium_lookout_exit_maya->auto_trigger_open_any_in( tv_atrium_return_lookout_door_exit_open_in, FALSE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_ENTER(), FALSE, TRUE );

	// close
	door_atrium_lookout_exit_maya->zoneset_auto_close_setup( S_ZONESET_ATRIUM_DAMAGED, TRUE, FALSE, -1, S_ZONESET_ATRIUM_DAMAGED, TRUE );
	door_atrium_lookout_exit_maya->auto_trigger_close_all_out( tv_atrium_lookout_exit_close_out, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_ATRIUM_LOOKOUT_EXIT(), FALSE, TRUE );

	// force closed
	door_atrium_lookout_exit_maya->close_immediate();
	
end

// === f_atrium_return_lookout_door_exit_deinit::: Deinit
script dormant f_atrium_return_lookout_door_exit_deinit()
	//dprint( "::: f_atrium_return_lookout_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_return_lookout_door_exit_init );
	
end
