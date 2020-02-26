//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// global variables
global long L_frame_cnt = 50;
global real R_start_pos = 10 / L_frame_cnt;
global real R_full_pos = L_frame_cnt / L_frame_cnt;

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate_start( real r_time )

	if ( r_time < 0.0 ) then
		r_time = 0.25;
	end

	if ( device_get_position(this) < R_start_pos ) then
		device_animate_position( this, R_start_pos, r_time, 0, 0, TRUE );
		sleep_until( device_get_position(this) == R_start_pos, 1 );
	end
	
end

script static instanced void animate_full( real r_time )
static real r_play_time = 0.0;
	if ( r_time >= 0.0 ) then
		r_play_time = r_play_time;
	else
		r_play_time = 1.25;
	end

	if ( device_get_position(this) < R_full_pos ) then
		device_animate_position( this, R_full_pos, r_play_time * (1.0 - device_get_position(this)), 0, 0, TRUE );
		sleep_until( device_get_position(this) == R_full_pos, 1 );
	end
		
end
