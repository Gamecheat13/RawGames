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
	position_open_start( 0.545 );

	// speeds
	speed_setup( 2.5, 3.0 );

	// blend speed
	blend_setup( 1.5 );

	// Sounds
	// Because of the way the m80 airlocks are set up, these sounds are triggered in the m80_airlocks script and don't need to be hooked up here
	// sound_engage_open_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_hatch_open' );	
	// sound_engage_close_setup( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_hatch_close' );	

end
