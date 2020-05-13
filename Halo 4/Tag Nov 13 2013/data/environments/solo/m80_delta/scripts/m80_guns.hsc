//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
//  Mission: 					m80_delta
//	Insertion Points:	lookout	(or ilo)
//	Insertion Points:	guns hallway (or igh)
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GUNS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_startup::: Startup
script startup f_guns_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_guns_startup :::" );

	// init crash
	wake( f_guns_init );

end

// === f_guns_init::: Initialize
script dormant f_guns_init()
	//dprint( "::: f_guns_init :::" );

	// setup cleanup
	wake( f_guns_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() >= S_ZONESET_TO_LOOKOUT) and (zoneset_current_active() <= S_ZONESET_LOOKOUT_EXIT), 1 );

	// init starting sub modules
	wake( f_guns_doors_init );

	sleep_until( zoneset_current_active() == S_ZONESET_LOOKOUT, 1 );

	// init modules
	wake( f_guns_ai_init );
	//wake( f_guns_narrative_init );
	//wake( f_guns_audio_init );
	//wake( f_guns_fx_init );
	
	// init sub modules
	wake( f_guns_doors_init );
	wake( f_guns_plinth_init );
	wake( f_guns_gravity_init );
	wake( f_guns_props_init );
	wake( f_guns_scale_init );
	
	// setup trigger
	wake( f_guns_trigger );

end

// === f_guns_deinit::: Deinitialize
script dormant f_guns_deinit()
	//dprint( "::: f_guns_deinit :::" );

	//dprint( "::: f_guns_deinit: DISTORTION ENABLE :::" );
	effects_distortion_enabled = TRUE;
	
	// deinit modules
	wake( f_guns_ai_deinit );
	
	// deinit modules
	//wake( f_guns_narrative_deinit );
	//wake( f_guns_audio_deinit );
	//wake( f_guns_fx_deinit );

	// kill functions
	kill_script( f_guns_init );
	kill_script( f_guns_trigger ); 
	kill_script( f_guns_action );

	// deinit sub modules
	wake( f_guns_doors_deinit );
	wake( f_guns_plinth_deinit );
	wake( f_guns_gravity_deinit );
	wake( f_guns_props_deinit );
	wake( f_guns_scale_deinit );

end

// === f_guns_cleanup::: Cleanup
script dormant f_guns_cleanup()
	sleep_until( zoneset_current_active() > S_ZONESET_LOOKOUT_HALLWAYS_A, 1 );
	//dprint( "::: f_guns_cleanup :::" );

	// Deinitialize
	wake( f_guns_deinit );

end

// === f_guns_trigger::: Trigger
script dormant f_guns_trigger()
	//dprint( "::: f_guns_trigger :::" );

	// Start
	wake( f_guns_start );

	sleep_until( f_guns_entered(), 1 );
	//dprint( "::: f_guns_trigger: DISTORTION DISABLE :::" );
	effects_distortion_enabled = FALSE;

	// Action
	sleep_until( f_ai_is_defeated(sg_guns_start_elites), 1 );
	wake( f_guns_action );

	// wait to prepare next zone set
	sleep_until( f_objective_current_check(DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE()), 1 );
	zoneset_prepare( S_ZONESET_LOOKOUT_EXIT );

end

// === f_guns_start::: Start
script dormant f_guns_start()
	//dprint( "::: f_guns_start :::" );

	// set datamining
	data_mine_set_mission_segment( "m80_Guns" );
	
	// collect garbages
	//garbage_collect_now();

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_guns_start" );	

end

// === f_guns_action::: Action
script dormant f_guns_action()
	//dprint( "::: f_guns_action :::" );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_guns_action" );	

	// insert
	sleep_until( dialog_id_played_check(L_dlg_lookout_rampancy) or dialog_foreground_id_line_index_check_greater_equel(L_dlg_lookout_rampancy, S_dlg_lookout_rampancy_blip_line_index), 1 );
	f_objective_set( DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT(), TRUE, TRUE, FALSE, TRUE );

	// online
	sleep_until( B_guns_turrets_reactivated, 1 );
	f_objective_set( DEF_R_OBJECTIVE_GUNS_ONLINE(), TRUE, FALSE, FALSE, TRUE );
	
	sleep_until( B_guns_turrets_reactivated and cortana_location_check_chief(), 1 );
	f_objective_set_timer_reminder( DEF_R_OBJECTIVE_GUNS_EXIT(), TRUE, FALSE, FALSE, TRUE );

end

// === f_guns_started::: Checks if the guns sequence was started
script static boolean f_guns_started()
static boolean b_started = FALSE;

	if ( (not b_started) and object_valid(door_lookout_enter_maya) ) then
		b_started = ( device_get_position(door_lookout_enter_maya) > 0.0 );
	end
 
	// return
	b_started;

end

// === f_guns_entered::: Checks if the guns sequence was completed
script static boolean f_guns_entered()
static boolean b_entered = FALSE;

	if ( not b_entered ) then
		b_entered = volume_test_players( tv_guns_entered );
	end

	// return
	b_entered;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: SCALE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_scale_init::: Init
script dormant f_guns_scale_init()
	dprint( "::: f_guns_scale_init :::" );
	
end

// === f_guns_scale_deinit::: Deinit
script dormant f_guns_scale_deinit()
	//dprint( "::: f_guns_scale_deinit :::" );
	
	// kill functions
	kill_script( f_guns_scale_init );
	kill_script( f_guns_scale_action );
	
end

// === f_guns_scale_action::: Action
script dormant f_guns_scale_action()
	//dprint( "::: f_guns_scale_action :::" );

	// collect garbages
	garbage_collect_now();
	
	// scale select modules
	wake( f_guns_props_scale );

	// deinit specific sub-modules
	wake( f_guns_doors_deinit );
	wake( f_guns_plinth_deinit );
		
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: GRAVITY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_gravity_init::: Init
script dormant f_guns_gravity_init()
	//dprint( "::: f_guns_gravity_init :::" );

	object_create( guns_local_gravity );
	object_hide( guns_local_gravity, TRUE );
	
end

// === f_guns_gravity_deinit::: Deinit
script dormant f_guns_gravity_deinit()
	//dprint( "::: f_guns_gravity_deinit :::" );
	
	// kill functions
	kill_script( f_guns_gravity_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_props_init::: Init
script dormant f_guns_props_init()
	//dprint( "::: f_guns_props_init :::" );

	// load the scenerey
	object_create_folder( scn_guns );

	// move ships
	thread( f_guns_props_move(sc_guns_cruiser_01, 450.0, ps_guns_ship_points.cruiser_01, 0.1, 0.4, TRUE) );
	thread( f_guns_props_move(sc_guns_cruiser_02, 375.0, ps_guns_ship_points.cruiser_02, 0.2, 0.5, TRUE) );
	thread( f_guns_props_move(sc_guns_cruiser_03, 300.0, ps_guns_ship_points.cruiser_03, 0.3, 0.6, TRUE) );
	thread( f_guns_props_move(sc_guns_didact_ship, 480.0, ps_guns_ship_points.didact, 45.0, 135.0, FALSE) );
	
end

// === f_guns_props_deinit::: Deinit
script dormant f_guns_props_deinit()
	//dprint( "::: f_guns_props_deinit :::" );

	object_destroy_folder( scn_guns );	
	
	// kill functions
	kill_script( f_guns_props_init );
	kill_script( f_guns_props_scale );
	kill_script( f_guns_props_move );
	
end

// === f_guns_props_scale::: Scale
script dormant f_guns_props_scale()
	dprint( "::: f_guns_props_scale :::" );

	// delete some props
	//object_destroy( guns_didact_ship );
	
end

// === f_guns_props_move::: Moves a cruiser
script static void f_guns_props_move( object_name obj_cruiser, real r_time, point_reference tp_point, real r_scale_min, real r_scale_max, boolean b_destroy )
	sleep_until( object_valid(obj_cruiser), 1 );
	//dprint( "::: f_guns_props_move :::" );
	
	// down scale
	object_set_scale( obj_cruiser, r_scale_min, 0 );
	
	sleep_until( f_guns_started(), 1 );
	
	// up scale
	sleep( 1 );
	object_set_scale( obj_cruiser, r_scale_max, r_time * 30 );
	
	// move
	object_move_to_point( obj_cruiser, r_time, tp_point );
	
	// destroy
	if ( b_destroy ) then
		object_destroy( obj_cruiser );
	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: PLINTH
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_guns_plinth_cortana_rampancy_anim = 				-1;
global real R_guns_plinth_cortana_rampancy_fx_low = 			0.0;	// SET IN Puppeteer
global real R_guns_plinth_cortana_rampancy_fx_medium = 		0.0;	// SET IN Puppeteer
global real R_guns_plinth_cortana_rampancy_fx_high = 			0.0;	// SET IN Puppeteer
global real g_rampancy_chance =		 												25.0;
global boolean g_hide_console =                           false;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_plinth_init::: Init
script dormant f_guns_plinth_init()
	//dprint( "::: f_guns_plinth_init :::" );

	wake( f_guns_plinth_insert_init );	
	wake( f_guns_plinth_remove_init );	
	
end

// === f_guns_plinth_insert_init::: Init
script dormant f_guns_plinth_insert_init()
	sleep_until( object_valid(dc_guns_plinth_insert), 1 );
	//dprint( "::: f_guns_plinth_insert_init :::" );
	
	device_set_power( dc_guns_plinth_insert, 0.0 );
	object_hide( dc_guns_plinth_insert, TRUE );
	
end

// === f_guns_plinth_remove_init::: Init
script dormant f_guns_plinth_remove_init()
	sleep_until( object_valid(dc_guns_plinth_remove), 1 );
	//dprint( "::: f_guns_plinth_remove_init :::" );
	
	device_set_power( dc_guns_plinth_remove, 0.0 );
	object_hide( dc_guns_plinth_remove, TRUE );
	
end

// === f_guns_plinth_deinit::: Deinit
script dormant f_guns_plinth_deinit()
	//dprint( "::: f_guns_plinth_deinit :::" );
	
	// kill scripts
	kill_script( f_guns_plinth_init );
	kill_script( f_guns_plinth_insert_init );
	kill_script( f_guns_plinth_remove_init );
	
end

// === f_guns_plinth_activate::: Hooked up from the device control, this will be called when it is activated
script static void f_guns_plinth_activate( object obj_control, unit u_activator )
local device dc_control = device( obj_control );
	//dprint( "::: f_guns_plinth_activate :::" );

	if ( device_get_power(dc_control) > 0.0 ) then
		// turn the power off so it can't be used until it's ready again
		device_set_power( dc_control, 0.0 );
	
		// set the puppeteer puppet as the activator
		p_player_puppet = u_activator;
	
		// place on plinth
		if ( dc_control == dc_guns_plinth_insert ) then

			f_objective_blip( DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT(), FALSE, FALSE );
			pup_play_show( 'pup_guns_plinth_insert' );

		end

		// remove from plinth
		if ( dc_control == dc_guns_plinth_remove ) then

			f_objective_blip( DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE(), FALSE, FALSE ); 
			pup_play_show( 'pup_guns_plinth_remove' );
			wake( m80_atrium_return_hallway );
		end
	
	end

end

// === f_guns_plinth_cortana_rampancy_anim_roll::: XXX
script static void f_guns_plinth_cortana_rampancy_anim_roll( short s_min, short s_max )
local short s_prev = S_guns_plinth_cortana_rampancy_anim;
	//dprint( "::: f_guns_plinth_cortana_rampancy_anim_roll :::" );
	S_guns_plinth_cortana_rampancy_anim = random_range( s_min, s_max );
	if ( S_guns_plinth_cortana_rampancy_anim == s_prev ) then
		S_guns_plinth_cortana_rampancy_anim = random_range( s_min, s_max );
	end
	//inspect( S_guns_plinth_cortana_rampancy_anim );
end

// === f_guns_plinth_cortana_rampancy_fx_low::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_low()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_low :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_low );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_low_med::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_low_med()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_low_med :::" );
	cortana_rampancy_set( real_random_range(R_guns_plinth_cortana_rampancy_fx_low,R_guns_plinth_cortana_rampancy_fx_medium) );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_med::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_med()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_med :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_medium );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_med_high::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_med_high()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_med_high :::" );
	cortana_rampancy_set( real_random_range(R_guns_plinth_cortana_rampancy_fx_medium,R_guns_plinth_cortana_rampancy_fx_high) );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_high::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_high()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_high :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_high );
	//inspect( cortana_rampancy_get() );
end
 


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_doors_init::: Init
script dormant f_guns_doors_init()
	//dprint( "::: f_guns_doors_init :::" );
	
	// init sub modules
	wake( f_guns_door_enter_init );
	wake( f_guns_door_exit_init );
	
end

// === f_guns_doors_deinit::: Deinit
script dormant f_guns_doors_deinit()
	//dprint( "::: f_guns_doors_deinit :::" );

	// deinit sub modules
	wake( f_guns_door_enter_deinit );
	wake( f_guns_door_exit_deinit );
	
	// kill functions
	kill_script( f_guns_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: DOOR: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_door_enter_init::: Init
script dormant f_guns_door_enter_init()
	sleep_until( object_valid(door_lookout_enter_maya) and object_active_for_script(door_lookout_enter_maya), 1 );
	//dprint( "::: f_guns_door_enter_init :::" );

	// setup auto disable	
	//thread( door_lookout_enter_maya->auto_enabled_zoneset(FALSE, S_ZONESET_LOOKOUT, -1) );

	// open
	door_lookout_enter_maya->zoneset_auto_open_setup( S_ZONESET_LOOKOUT, TRUE, TRUE, -1, S_ZONESET_LOOKOUT, TRUE );
	door_lookout_enter_maya->auto_distance_open( -5.0, FALSE );
	
	// set objective
	if ( f_objective_current_index() < DEF_R_OBJECTIVE_GUNS_ENTER() ) then
		f_objective_set_timer_reminder( DEF_R_OBJECTIVE_GUNS_ENTER(), TRUE, FALSE, FALSE, TRUE );
	end
	
	// close
	door_lookout_enter_maya->auto_trigger_close_all_out( tv_guns_door_enter_close_out, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_GUNS_ENTER(), FALSE, TRUE );

	// force closed
	door_lookout_enter_maya->close_immediate();
	
end

// === f_guns_door_enter_deinit::: Deinit
script dormant f_guns_door_enter_deinit()
	//dprint( "::: f_guns_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_guns_door_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_door_exit_init::: Init
script dormant f_guns_door_exit_init()
local long l_thread = 0;
	sleep_until( object_valid(door_lookout_exit) and object_active_for_script(door_lookout_exit), 1 );
	//dprint( "::: f_guns_door_exit_init :::" );

	// setup door
	//door_lookout_exit->speed_close( 3.5 );

	// wait for condition
	sleep_until( B_guns_turrets_reactivated and cortana_location_check_chief(), 1 );

	// setup auto disable	
	thread( door_lookout_exit->auto_enabled_zoneset(FALSE, S_ZONESET_LOOKOUT_HALLWAYS_A, -1) );

	// open
	door_lookout_exit->zoneset_auto_open_setup( S_ZONESET_LOOKOUT_EXIT, TRUE, TRUE, -1, S_ZONESET_LOOKOUT_EXIT, TRUE );
	l_thread = thread( door_lookout_exit->open() );
	sleep_until( door_lookout_exit->position_not_close_check() or (zoneset_current() > S_ZONESET_LOOKOUT_EXIT), 1 );
	kill_thread( l_thread );

	// close
	door_lookout_exit->zoneset_auto_close_setup( S_ZONESET_LOOKOUT_HALLWAYS_A, TRUE, FALSE, -1, S_ZONESET_LOOKOUT_HALLWAYS_A, TRUE );
	door_lookout_exit->auto_trigger_close_all_out( tv_guns_door_exit_close_out, TRUE );

	// force closed
	door_lookout_exit->close_immediate();
	
	// scale area
	wake( f_guns_scale_action );
	
end

// === f_guns_door_exit_deinit::: Deinit
script dormant f_guns_door_exit_deinit()
	//dprint( "::: f_guns_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_guns_door_exit_init );
	
end
