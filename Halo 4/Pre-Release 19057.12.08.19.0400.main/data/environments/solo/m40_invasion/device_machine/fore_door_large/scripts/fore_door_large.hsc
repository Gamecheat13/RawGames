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
	device_set_position_track( this, 'any:small', 0 );
	
	// initialize variables
	speed_set_open( 4.0 );
	speed_set_close( 3.0 );
	
	sound_open_set( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_b_open' );
	sound_close_set( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_b_close' );

//	set_jittering( FALSE );
	
//	weaponpickup_set( -1, -1 );
	
//	animate( 0.0, R_door_start_position );

end
