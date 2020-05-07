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
	position_close_start( 0.001 );
	position_open_start( 0.45 );
	
	// speeds
	speed_setup( 3.0, 3.25 );
	
	// blend speed
	blend_setup( 0.5 );
	
	// sounds
	sound_engage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_open_set' );
	sound_loop_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_movement_loop' );
	sound_disengage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_open_end_set' );
	
	sound_engage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_close_set' );
	sound_loop_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_movement_loop' );
	sound_disengage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_close_end_set' );

end
