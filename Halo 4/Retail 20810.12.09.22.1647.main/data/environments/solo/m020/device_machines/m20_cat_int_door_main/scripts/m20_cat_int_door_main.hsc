//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// === f_init: init function
script startup instanced init()
	//dprint_door( "init" );
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
	
	// initialize variables
	speed_set_open( 6 );
	speed_set_close( 4 );
	
	sound_engage_open_setup( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_open_set' );
	sound_loop_open_setup( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_door_a_motor_loop', 0.05, 0.95 );
	sound_disengage_open_setup( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_open_end_set', 0.85, 0.9 );
	
	sound_engage_close_setup( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_close_set', 0.85, 0.9 );
	sound_loop_close_setup( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_door_a_motor_loop', 0.05, 0.95 );
	sound_disengage_close_setup( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_close_end_set' );

//	set_jittering( FALSE );
		
	//chain_delay_set( DEF_SPEED_DEFAULT / 8 );
	
//	animate( 0.0, R_door_start_position );

end