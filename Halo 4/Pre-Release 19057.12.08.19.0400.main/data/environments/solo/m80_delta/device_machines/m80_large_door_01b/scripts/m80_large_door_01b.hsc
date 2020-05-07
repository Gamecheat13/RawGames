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
	position_close_start( 0.23 );
	position_open_start( 0.80 );
	
	// speeds
	speed_setup( 2.5 );
	
	// blend speed
	blend_setup( 0.75 );
	
	// sounds
	sound_engage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_open_start' );
	sound_loop_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop' );
	sound_disengage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_apex' );
	
	//sound_engage_close_setup( snd_sound );
	sound_loop_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop' );
	sound_disengage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_close_end' );
	
end
