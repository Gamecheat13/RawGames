//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
//  Mission: 					m80_delta
//  Insertion Points:	lift								(or ili)
//	Insertion Points:	atrium destruction 	(or iad)
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ELEVATOR ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
//object_damage_damage_section (elevator_name, "body", 1000); 

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_elevator_ride_low_rumble_id = 								0;
global boolean B_elevator_restart = 												FALSE;
global boolean B_elevator_finished = 												FALSE;
 
// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_startup::: Startup
script startup f_elevator_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_elevator_startup :::" );

	// init crash
	wake( f_elevator_init );

end

// === f_elevator_init::: Initialize
script dormant f_elevator_init()
	//dprint( "::: f_elevator_init :::" );
	
	// wait for init condition
	sleep_until( f_elevator_started(), 1 );
	
	// init sub modules
	wake( f_elevator_lift_init );
	wake( f_elevator_buttons_init );
	wake( f_elevator_doors_init );
	wake( f_elevator_props_init );
	
	// setup trigger
	wake( f_elevator_trigger );

end

// === f_elevator_deinit::: Deinitialize
script dormant f_elevator_deinit()
	//dprint( "::: f_elevator_deinit :::" );

	// kill functions
	kill_script( f_elevator_init );
	kill_script( f_elevator_trigger );
	kill_script( f_elevator_start );

	// deinit sub modules
	wake( f_elevator_lift_deinit );
	wake( f_elevator_buttons_deinit );
	wake( f_elevator_doors_deinit );
	wake( f_elevator_props_deinit );

end

// === f_elevator_trigger::: Trigger
script dormant f_elevator_trigger()
	sleep_until( f_elevator_started(), 1 );
	//dprint( "::: f_elevator_trigger :::" );

	/*
	// prepare zone load
	if ( zoneset_current() < S_ZONESET_MECHROOM_RETURN ) then
		zoneset_prepare( S_ZONESET_MECHROOM_RETURN );
	end
	*/
	
	// start
	wake( f_elevator_start );

	// blip the control button
//	sleep_until( object_valid(door_elevator_exit) and (device_get_position(door_elevator_exit) > 0.0), 1 );
	sleep_until( object_valid(door_elevator_exit) and object_active_for_script(door_elevator_exit) and (door_elevator_exit->position_close_check() == FALSE), 1 );
	f_objective_blip( DEF_R_OBJECTIVE_ELEVATOR_ENTER(), FALSE );

	// dialog
	wake( f_dialog_m80_atrium_elevator );

	// setup the next objective
	sleep_until( dialog_id_played_check(l_dlg_atrium_elevator) or dialog_foreground_id_line_index_check_greater_equel(l_dlg_atrium_elevator,0), 1 );
	f_objective_set( DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE(), TRUE, FALSE, FALSE, TRUE );
	
	// blip
	sleep_until( dialog_id_played_check(l_dlg_atrium_elevator), 1 );
	f_objective_blip( DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE(), TRUE );
	
end 

// === f_elevator_start::: Start
script dormant f_elevator_start()
	//dprint( "::: f_elevator_start :::" );

	// set datamining
	data_mine_set_mission_segment( "m80_Elevator" );
	
	// collect garbages
	garbage_collect_now();

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_elevator_start" );	

	// blip the objective	
	sleep_s( 0.25 );
	f_objective_blip( DEF_R_OBJECTIVE_ELEVATOR_ENTER(), TRUE, FALSE );

end

// === f_elevator_started::: Checks if the guns sequence was started
script static boolean f_elevator_started()
static boolean b_started = FALSE;

	if ( not b_started ) then
		b_started = f_objective_current_check( DEF_R_OBJECTIVE_ELEVATOR_ENTER() );
	end
 
	// return
	b_started;

end	

// === f_elevator_knock_back::: Triggers the knock back
script static void f_elevator_knock_back()

	damage_new( 'environments\solo\m80_delta\damage_effects\m80_atrium_destruction_knock_back.damage_effect', flg_elevator_knock_back_01 );

	// damage
	object_damage_damage_section( dm_elevator, "body", 60.0 );
	sleep( 15 );

	damage_new( 'environments\solo\m80_delta\damage_effects\m80_atrium_destruction_knock_back.damage_effect', flg_elevator_knock_back_02 );
	
end

// === f_elevator_low_runble_start::: Starts the elevator rumble
script static void f_elevator_low_rumble_start()
	//dprint( "::: f_elevator_low_rumble_start :::" );
	L_elevator_ride_low_rumble_id = f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_VERY_LOW() * 0.50, 0.25, NONE );
end

// === f_elevator_low_rumble_restart::: Starts the elevator rumble
script static void f_elevator_low_rumble_restart()
	//dprint( "::: f_elevator_low_rumble_restart :::" );
	L_elevator_ride_low_rumble_id = f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_VERY_LOW() * 0.50, 0.25, NONE );
end

// === f_elevator_low_rumble_stop::: Stops the elevator rumble
script static void f_elevator_low_rumble_stop()
	//dprint( "::: f_elevator_low_rumble_stop :::" );
	f_screenshake_rumble_global_remove( L_elevator_ride_low_rumble_id, DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_VERY_LOW() * 0.50, 0.75 );
end

// === f_elevator_composer_stolen::: Sets composer stolen moment
script static void f_elevator_composer_stolen()
	thread( f_objective_set(DEF_R_OBJECTIVE_ELEVATOR_COMPOSER_STOLEN(), FALSE, FALSE, FALSE, TRUE) );
end

// === f_elevator_exit_prepare::: Prepares the next area
script static void f_elevator_exit_prepare()
	zoneset_prepare( S_ZONESET_COMPOSER_REMOVAL_EXIT );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_props_init::: Init
script dormant f_elevator_props_init()
	//dprint( "::: f_elevator_props_init :::" );

	// setup trigger
	wake( f_elevator_props_trigger );
	
end

// === f_elevator_props_deinit::: Deinit
script dormant f_elevator_props_deinit()
	//dprint( "::: f_elevator_props_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_props_init );
	
end

// === f_elevator_props_trigger::: Trigger
script dormant f_elevator_props_trigger()
	sleep_until( zoneset_current_active() >= S_ZONESET_COMPOSER_REMOVAL_ENTER, 1 );
	//dprint( "::: f_elevator_props_trigger :::" );
	
	// kill functions
	wake( f_elevator_props_action );
	
end

// === f_elevator_props_action::: Action
script dormant f_elevator_props_action()
	//dprint( "::: f_elevator_props_action :::" );
	
	// create the atrium props
	object_create_folder( atrium_destroyed_scenery );
	
	// make sure atrium props are gone
	object_destroy_folder( atrium_crates );
	object_destroy_folder( atrium_scenery );
	object_destroy_folder( atrium_bipeds );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: LIFT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_lift_init::: Init
script dormant f_elevator_lift_init()
	sleep_until( f_elevator_started(), 1 );
	//dprint( "::: f_elevator_lift_init :::" );
	
	// create the elevator
	object_create_anew( dm_elevator );
	
end

// === f_elevator_lift_deinit::: Deinit
script dormant f_elevator_lift_deinit()
	//dprint( "::: f_elevator_lift_deinit :::" );

	// deinit sub modules
	object_destroy( dm_elevator );
	
	// kill functions
	kill_script( f_elevator_lift_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: CONTROLS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_buttons_init::: Init
script dormant f_elevator_buttons_init()
	sleep_until( f_elevator_started(), 1 );
	//dprint( "::: f_elevator_buttons_init :::" );
	
	// create all the conrols
	object_create_folder_anew( dc_elevator_controls );
	
	// init sub modules
	wake( f_elevator_control_start_init );
	wake( f_elevator_control_exit_init );
	
end

// === f_elevator_buttons_deinit::: Deinit
script dormant f_elevator_buttons_deinit()
	//dprint( "::: f_elevator_buttons_deinit :::" );

	// deinit sub modules
	wake( f_elevator_control_start_deinit );
	wake( f_elevator_control_exit_deinit );
	
	// kill functions
	kill_script( f_elevator_buttons_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: CONTROLS: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_control_start_init::: Init
script dormant f_elevator_control_start_init()
	sleep_until( object_valid(dc_elevator_start), 1 );
	//dprint( "::: f_elevator_control_start_init :::" );

	// attach the button
	object_hide( dc_elevator_start, TRUE );
	device_set_power( dc_elevator_start, 0.0 );

	sleep_until( f_objective_blipped_check(DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE()) and object_valid(dc_elevator_start), 1 );
	device_set_power( dc_elevator_start, 1.0 );
	
end

// === f_elevator_control_start_deinit::: Deinit
script dormant f_elevator_control_start_deinit()
	//dprint( "::: f_elevator_control_start_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_control_start_init );
	kill_script( f_elevator_control_start_action );
	kill_script( f_elevator_control_start_delete_extras );
	
end

// === f_elevator_control_start_action::: Button pressed
script static void f_elevator_control_start_action( object obj_control, unit u_activator )
local long l_pup_id = 0;
	//dprint( "::: f_elevator_control_start_action :::" );

	// complete the objective
	device_set_power( device(obj_control), 0.0 );
	
	// play the button press
	p_player_puppet = u_activator;
	l_pup_id = pup_play_show( 'pup_elevator_control_start' );

	// complete the objective
	thread( f_objective_complete(DEF_R_OBJECTIVE_ELEVATOR_ACTIVATE(), FALSE, TRUE) );

	// wait for show to finish
	sleep_until( not pup_is_playing(l_pup_id), 1 );

	// enable the zone load
	zoneset_prepare_and_load( S_ZONESET_COMPOSER_REMOVAL );

	// create the destroyed scenery
	object_create_folder( atrium_destroyed_scenery );	 
	
	// set gun to distant
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_DISTANT() );

	// start extra garbage cleanup
	wake( f_elevator_control_start_delete_extras );

	// play the show
	l_pup_id = pup_play_show( 'atrium_destruction' );
	
	// restart	
	sleep_until( dialog_id_played_check(l_dlg_atrium_vignette_composer_leaving) or dialog_foreground_id_line_index_check_greater_equel(l_dlg_atrium_vignette_composer_leaving, S_dlg_atrium_vignette_elevator_restart_index), 1 );
	B_elevator_restart = TRUE;
	
	// wait for elevator to finish
	sleep_until( B_elevator_finished, 1 );

	// exit blip
	sleep_until( dialog_id_played_check(l_dlg_atrium_vignette_composer_leaving) or dialog_foreground_id_line_index_check_greater_equel(l_dlg_atrium_vignette_composer_leaving, S_dlg_atrium_vignette_composer_leaving_blip_index), 1 );
	f_objective_set( DEF_R_OBJECTIVE_ELEVATOR_EXIT(), FALSE, TRUE, FALSE, TRUE );

end

// === f_elevator_control_start_delete_extras::: Action
script dormant f_elevator_control_start_delete_extras()
	//dprint( "::: f_elevator_control_start_delete_extras :::" );

	sleep_until( object_valid(elevator_shaft_door_lower), 1 );
	//dprint( "::: f_elevator_control_start_delete_extras: elevator_shaft_door_lower :::" );
	object_destroy( elevator_shaft_door_lower );
	sleep_until( object_valid(elevator_shaft_door_upper), 1 );
	//dprint( "::: f_elevator_control_start_delete_extras: elevator_shaft_door_upper :::" );
	object_destroy( elevator_shaft_door_upper );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: CONTROLS: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_control_exit_init::: Init
script dormant f_elevator_control_exit_init()
sleep_until( object_valid(dc_elevator_exit), 1 );
	//dprint( "::: f_elevator_control_exit_init :::" );

	// set button to power down state
	device_set_position_immediate( dc_elevator_exit, 1.0 );
	device_set_power( dc_elevator_exit, 0.0 );

	// attach the button
	//sleep_until( object_valid(dm_elevator), 1 );
	//objects_attach( dm_elevator, "button_position", dc_elevator_exit, "unsc_button_marker" );
	
end

// === f_elevator_control_exit_deinit::: Deinit
script dormant f_elevator_control_exit_deinit()
	//dprint( "::: f_elevator_control_exit_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_control_exit_init );
	kill_script( f_elevator_control_exit_action );
	
end

// === f_elevator_exit_action::: Button pressed
script static void f_elevator_control_exit_action( object obj_control, unit u_activator )
local long l_pup_id = 0;
	//dprint( "::: f_elevator_exit_action :::" );
	
	thread( f_objective_blip(DEF_R_OBJECTIVE_ELEVATOR_EXIT(), FALSE, FALSE) );
	
	// play the button press
	p_player_puppet = u_activator;
	l_pup_id = pup_play_show( 'pup_elevator_control_exit' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
	// set complete objective
	f_objective_set( DEF_R_OBJECTIVE_COMPLETE(), TRUE, FALSE, FALSE, FALSE );
	
	// play cinematic
	ins_cine_83();

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_doors_init::: Init
script dormant f_elevator_doors_init()
	sleep_until( f_elevator_started(), 1 );
	//dprint( "::: f_elevator_doors_init :::" );
	
	// init sub modules
	wake( f_elevator_door_left_enter_init );
	wake( f_elevator_door_left_mid_init );
	wake( f_elevator_door_right_enter_init );
	wake( f_elevator_door_right_mid_init );
	wake( f_elevator_door_room_init );
	
end

// === f_elevator_doors_deinit::: Deinit
script dormant f_elevator_doors_deinit()
	//dprint( "::: f_elevator_doors_deinit :::" );

	// deinit sub modules
	wake( f_elevator_door_left_enter_deinit );
	wake( f_elevator_door_left_mid_deinit );
	wake( f_elevator_door_right_enter_deinit );
	wake( f_elevator_door_right_mid_deinit );
	wake( f_elevator_door_room_deinit );
	
	// kill functions
	kill_script( f_elevator_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOOR: LEFT: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_door_left_enter_init::: Init
script dormant f_elevator_door_left_enter_init()
	sleep_until( object_valid(door_mechroom_enter) and object_active_for_script(door_mechroom_enter), 1 );
	//dprint( "::: f_elevator_door_left_enter_init :::" );

	// condition
	sleep_until( f_elevator_started(), 1 );

	// setup auto disable	
	thread( door_mechroom_enter->auto_enabled_zoneset(FALSE, S_ZONESET_COMPOSER_REMOVAL_ENTER, -1) );

	// open
	door_mechroom_enter->zoneset_auto_open_setup( S_ZONESET_MECHROOM_RETURN, TRUE, TRUE, -1, S_ZONESET_MECHROOM_RETURN, TRUE );
	door_mechroom_enter->auto_distance_open( -5.0, FALSE );

	// force close
	sleep_until( zoneset_current() >= S_ZONESET_COMPOSER_REMOVAL_ENTER, 1 );
	door_mechroom_enter->close_immediate();
	
end

// === f_elevator_door_left_enter_deinit::: Deinit
script dormant f_elevator_door_left_enter_deinit()
	//dprint( "::: f_elevator_door_left_enter_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_door_left_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOOR: LEFT: MID
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_door_left_mid_init::: Init
script dormant f_elevator_door_left_mid_init()
	sleep_until( object_valid(door_mechroom_interior_left) and object_active_for_script(door_mechroom_interior_left), 1 );
	//dprint( "::: f_elevator_door_left_mid_init :::" );

	// open
	sleep_until( object_valid(door_mechroom_enter) and object_active_for_script(door_mechroom_enter) and door_mechroom_enter->position_not_close_check(), 1 );
	door_mechroom_interior_left->auto_distance_open( -5.0, FALSE );
	
end

// === f_elevator_door_left_mid_deinit::: Deinit
script dormant f_elevator_door_left_mid_deinit()
	//dprint( "::: f_elevator_door_left_mid_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_door_left_mid_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOOR: RIGHT: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_door_right_enter_init::: Init
script dormant f_elevator_door_right_enter_init()
	sleep_until( object_valid(door_mechroom_exit) and object_active_for_script(door_mechroom_exit), 1 );
	//dprint( "::: f_elevator_door_right_enter_init :::" );

	// condition
	sleep_until( f_elevator_started(), 1 );

	// setup auto disable	
	thread( door_mechroom_exit->auto_enabled_zoneset(FALSE, S_ZONESET_COMPOSER_REMOVAL_ENTER, -1) );

	// open
	door_mechroom_exit->zoneset_auto_open_setup( S_ZONESET_MECHROOM_RETURN, TRUE, TRUE, -1, S_ZONESET_MECHROOM_RETURN, TRUE );
	door_mechroom_exit->auto_distance_open( -5.0, FALSE );

	// force close
	sleep_until( zoneset_current() >= S_ZONESET_COMPOSER_REMOVAL_ENTER, 1 );
	door_mechroom_exit->close_immediate();
	
end

// === f_elevator_door_right_enter_deinit::: Deinit
script dormant f_elevator_door_right_enter_deinit()
	//dprint( "::: f_elevator_door_right_enter_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_door_right_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOOR: RIGHT: MID
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_door_right_mid_init::: Init
script dormant f_elevator_door_right_mid_init()
	sleep_until( object_valid(door_mechroom_interior_right) and object_active_for_script(door_mechroom_interior_right), 1 );
	//dprint( "::: f_elevator_door_right_mid_init :::" );

	// open
	sleep_until( object_valid(door_mechroom_exit) and object_active_for_script(door_mechroom_exit) and door_mechroom_exit->position_not_close_check(), 1 );
	door_mechroom_interior_right->auto_distance_open( -5.0, FALSE );
	
end

// === f_elevator_door_right_mid_deinit::: Deinit
script dormant f_elevator_door_right_mid_deinit()
	//dprint( "::: f_elevator_door_right_mid_deinit :::" );
	
	// kill functions
	kill_script( f_elevator_door_right_mid_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ELEVATOR: DOOR: ROOM
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_elevator_door_room_init::: Init
script dormant f_elevator_door_room_init()
	sleep_until( object_valid(door_elevator_exit) and object_active_for_script(door_elevator_exit), 1 );
	//dprint( "::: f_elevator_door_room_init :::" );

	// setup door
	door_elevator_exit->speed_open( 3.5 );

	// setup auto disable	
	thread( door_elevator_exit->auto_enabled_zoneset(FALSE, S_ZONESET_COMPOSER_REMOVAL, -1) );
	
	// open
	door_elevator_exit->zoneset_auto_open_setup( S_ZONESET_COMPOSER_REMOVAL_ENTER, TRUE, TRUE, -1, S_ZONESET_COMPOSER_REMOVAL_ENTER, TRUE );
	door_elevator_exit->auto_trigger_open_any_in( tv_elevator_open_any_in, FALSE );
	//door_elevator_exit->auto_distance_open( -5.0, FALSE );

	// close
	door_elevator_exit->zoneset_auto_close_setup( S_ZONESET_COMPOSER_REMOVAL, TRUE, FALSE, -1, S_ZONESET_COMPOSER_REMOVAL, TRUE );
	door_elevator_exit->auto_trigger_close_all_in( tv_elevator_close_all_in, TRUE );

	// force closed
	sleep_until( zoneset_current() == S_ZONESET_COMPOSER_REMOVAL, 1 );
		
	// attach the door
	objects_attach( dm_elevator, "door_position", door_elevator_exit, "" );
	sleep( 1 );
	//device_animate_position( door_elevator_exit, 0.0, 0.0, 0.0, 0.0, TRUE );
	door_elevator_exit->close_immediate();
	
end

// === f_elevator_door_room_deinit::: Deinit
script dormant f_elevator_door_room_deinit()
	dprint( "::: f_elevator_door_room_deinit :::" );
	
	// kill functions
	//kill_script( f_elevator_door_room_init );
	
end
