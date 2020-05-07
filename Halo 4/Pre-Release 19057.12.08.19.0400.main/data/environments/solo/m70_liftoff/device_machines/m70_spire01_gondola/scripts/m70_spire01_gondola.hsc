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
end

script static instanced void f_gondola_move_to(real r_start_position, real r_end_position, real r_time)
	//make sure start position is true
	if device_get_position(this) != r_start_position then
		device_set_position(this, r_start_position);
	end
	//animate to position
	device_animate_position (this, r_end_position, r_time, 0.1, 0.1, TRUE);
	
end
