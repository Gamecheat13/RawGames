// =================================================================================================
// =================================================================================================
// DEVICE MACHINES
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// POSITION
// -------------------------------------------------------------------------------------------------
// === f_check_device_position: Check if a device has passed the position
//		dm_device [device machine] 	- Device machine to test
//		r_frames_check [real] 			- Frame to check
//			NOTE: Is a real so that you can check for even interpolated between frame positions
//		l_frames_total [long]				- Total number of frames in the animation
script static boolean f_check_device_position( device dm_device, real r_frames_check, long l_frames_total )
	( device_get_position(dm_device) >= (r_frames_check / l_frames_total) );
end

script static boolean device_check_range( device dm_device, real r_min, real r_max )
	range_check( device_get_position(dm_device), r_min, r_max );
end

// -------------------------------------------------------------------------------------------------
// RELATIVE
// -------------------------------------------------------------------------------------------------
// === device_animate_position_relative: Plays an time based on the devices relative position to it's start and end position
//			r_pos_end [real] = Ending position of the animation sequence
//			[parameters] see: device_animate_position
script static void device_animate_position_relative( device dm_device, real r_position, real r_time, real r_blend_in, real r_blend_out, boolean b_blend_apply )
local real r_pos_scale = 1.0;

	// calculate the relative scale
	r_pos_scale = abs_r( r_position - device_get_position(dm_device) );

	device_animate_position( dm_device, r_position, r_time * r_pos_scale, r_blend_in * r_pos_scale, r_blend_out * r_pos_scale, b_blend_apply );

end

// -------------------------------------------------------------------------------------------------
// VARIABLE SPEED
// -------------------------------------------------------------------------------------------------
// variables
global real r_device_machine_scale = 1.0;

// functions
// === device_animate_position_variable: Plays a device machine animation but allows speed scaling while the animation is playing
//			[parameters] see: device_animate_position
script static void device_animate_position_variable( device dm_device, real r_pos, real r_time, real r_blend_in, real r_blend_out, boolean b_blend_apply )
local real r_current_scale = 1.0;
local real r_starting_pos = device_get_position( dm_device );
local real r_scale_pos = 1.0;

	repeat
		//r_time * r_current_scale * (1.0 - device_get_position(dm_vehiclebay_hull))
		if ( dm_device != NONE ) then
		
			r_current_scale = r_device_machine_scale;
			r_scale_pos = 1.0;
			
			if ( r_starting_pos < r_pos ) then
				r_scale_pos = 1.0 - ( (device_get_position(dm_device) - r_starting_pos) / (r_pos - r_starting_pos) );
			end
			if ( r_starting_pos > r_pos ) then
				r_scale_pos = 1.0 - ( (r_starting_pos - device_get_position(dm_device)) / (r_starting_pos - r_pos) );
			end
			inspect( r_scale_pos );
			device_animate_position( dm_device, r_pos, r_time * r_current_scale * r_scale_pos, r_blend_in, r_blend_out, b_blend_apply );
		end
		sleep_until( (dm_device == NONE) or (device_get_position(dm_device) == r_pos) or (r_current_scale != r_device_machine_scale), 1 );
	
	until( (dm_device == NONE) or (device_get_position(dm_device) == r_pos), 1 );

end

// === transition_device_scale: Transitions device animation scale over time
//			r_scale_start = starting scale value
//				[r_scale_start < 0] = current scale
//			r_scale_end = final scale target
//				[r_scale_end < 0] = 1.0 (normal)
//			r_seconds = number of seconds the scale to change
//			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
//				[r_refresh < 0] = 1;
//	RETURNS:  void
script static void transition_device_scale( real r_scale_start, real r_scale_end, real r_seconds, short s_refresh )
static long l_sys_transition_device_scale = 0;

	if ( l_sys_transition_device_scale != 0 ) then
		kill_thread( l_sys_transition_device_scale );
	end

	l_sys_transition_device_scale = thread( sys_transition_device_scale(r_scale_start, r_scale_end, r_seconds, s_refresh) );

end
// === sys_transition_device_scale: System function for transition_device_scale
//			NOTE: DO NOT USE THIS FUNCTION
script static void sys_transition_device_scale( real r_scale_start, real r_scale_end, real r_seconds, short s_refresh )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_scale_range = 0.0;
static real r_scale_delta = 0.0;
static real r_time_range = 0.0;

	// defaults
	if ( r_scale_start < 0 ) then
		r_scale_start = r_device_machine_scale;
	end
	if ( r_scale_end < 0 ) then
		r_scale_end = 1.0;
	end
	if ( s_refresh < 0 ) then
		s_refresh = 1;
	end

	// get start time	
	l_time_start = game_tick_get();
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_seconds );
	
	// setup variables
	r_scale_range = r_scale_end - r_scale_start;
	r_time_range = l_time_end - l_time_start;

	if ( (r_scale_range > 0.001) and (r_time_range > 0.001) ) then
		repeat
			r_scale_delta = real( game_tick_get() - l_time_start ) / r_time_range;

			// set gravity to the current % of time progress
			r_device_machine_scale = r_scale_start + ( r_scale_range * r_scale_delta );
		until ( game_tick_get() >= l_time_end, s_refresh );
	end
	r_device_machine_scale = r_scale_end;

end
