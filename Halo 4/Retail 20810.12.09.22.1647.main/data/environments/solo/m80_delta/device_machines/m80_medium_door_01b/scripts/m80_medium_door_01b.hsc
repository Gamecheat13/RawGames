//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: m80_delta
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// === f_init: init function
script startup instanced init()
	dprint_door( "init" );
	
	// set animation
	device_set_position_track( this, 'any:idle', 0 );
	
	// open/close range positions
	position_close_start( 0.314 );
	position_open_start( 0.875 );

	// speeds
	speed_setup( 3.625 );
	
	// blend speed
	blend_setup( 1.0 );

	// sounds
	sound_engage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_open_start', 0.10, 0.15 );
	sound_loop_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop', 0.315, 0.87 );
	sound_disengage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_apex', 0.85, 0.95 );
	
	sound_engage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_fully_open_start', 0.85, 0.95 );
	sound_loop_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop', 0.315, 0.87);
	sound_disengage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_close_end', 0.1, 0.15  );

end
