//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()

	// set it's base animation to 'any:idle'
		device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate_full( real r_time )
static real r_play_time = 0.0;

	if ( r_time >= 0.0 ) then
		r_play_time = r_time;
	else
		r_play_time = 0.33;
	end

	device_animate_position( this, 1.0, r_play_time, 0, 0, FALSE );
	
end 

script static instanced boolean animation_complete()
	device_get_position(this) == 1.0;
end 

script static instanced boolean animation_started()
	device_get_position(this) > 0.0;
end 