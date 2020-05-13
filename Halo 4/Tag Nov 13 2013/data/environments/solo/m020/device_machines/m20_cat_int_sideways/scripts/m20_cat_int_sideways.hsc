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
	speed_set_open( 1.5 );
	speed_set_close( 1.5 );
	
	sound_open_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_open_set' );
	sound_open_looping_set( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_door_a_motor_loop' );
	sound_open_end_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_open_end_set' );
	
	sound_close_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_close_set' );
	sound_close_looping_set( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_door_a_motor_loop' );
	sound_close_end_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_door_a_close_end_set' );

//	animate( 0.0, R_door_start_position );

end