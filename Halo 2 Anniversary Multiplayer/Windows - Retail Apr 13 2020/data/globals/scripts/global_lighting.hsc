// =================================================================================================
// =================================================================================================
// LIGHTING SCRIPTS
// =================================================================================================
// =================================================================================================
// variables
//global real R_lightmap_direct_scale_target = 1.0;
//global real R_lightmap_indirect_scale_target = 1.0;

// functions
// === start_lighting_startup::: Automatically restores lighting to the targeted value
/*
script startup start_lighting_startup()
	lightmapDirectScalar = R_lightmap_direct_scale_target;
	lightmapIndirectScalar = R_lightmap_indirect_scale_target;
end
*/

// -------------------------------------------------------------------------------------------------
// LIGHTING: DEFAULTS
// -------------------------------------------------------------------------------------------------
// variables
global real R_lightmap_direct_scale_default = 1.0;
global real R_lightmap_indirect_scale_default = 1.0;

// functions
// === f_lighting_direct_default_set::: Set the default direct lighting values
//	r_lighting - New value for default direct lighting
//		DEFAULT [ < 0] = 1.0
script static void f_lighting_direct_default_set( real r_lighting )

	if ( r_lighting < 0 ) then
		r_lighting = 1.0;
	end
	R_lightmap_direct_scale_default = r_lighting;
	
end
// === f_lighting_direct_default_get::: Gets the current default direct lighting value
//			RETURN: R_lightmap_direct_scale_default
script static real f_lighting_direct_default_get()
	R_lightmap_direct_scale_default;
end
// === f_lighting_indirect_default_set::: Set the default indirect lighting values
//	r_lighting - New value for default direct lighting
//		DEFAULT [ < 0] = 1.0
script static void f_lighting_indirect_default_set( real r_lighting )

	if ( r_lighting < 0 ) then
		r_lighting = 1.0;
	end
	R_lightmap_indirect_scale_default = r_lighting;
	
end
// === f_lighting_indirect_default_get::: Gets the current default indirect lighting value
//			RETURN: R_lightmap_indirect_scale_default
script static real f_lighting_indirect_default_get()
	R_lightmap_indirect_scale_default;
end

// -------------------------------------------------------------------------------------------------
// LIGHTING: ENVIRONMENT
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_lighting_environment_set::: Scales the direct & indirect lighting over time
//	r_time - The time the lighting transition should happen over
//		NOTE: r_time < 0 is relative time, scaled based on difference ration between start and end time (normalized for both direct and indirect)
//	r_lighting_direct_start - Starting direct light scale value
//		DEFAULT [ < 0] = f_lighting_direct_get()
//	r_lighting_direct_end - Ending direct light scale value
//		DEFAULT [ < 0] = f_lighting_direct_default_get()
//	r_lighting_indirect_start - Starting indirect light scale value
//		DEFAULT [ < 0] = f_lighting_indirect_get()
//	r_lighting_indirect_end - Ending indirect light scale value
//		DEFAULT [ < 0] = f_lighting_indirect_default_get()
//	s_rate - The rate in ticks the lighting value is changed
//		DEFAULT [ < 0] = 1
script static void f_lighting_environment_set( real r_time, real r_lighting_direct_start, real r_lighting_direct_end, real r_lighting_indirect_start, real r_lighting_indirect_end, short s_rate )
static short l_lighting_thread_static = 0;
local short l_lighting_thread_local = 0;

	// store fake thread
	l_lighting_thread_static = l_lighting_thread_static + 1;
	l_lighting_thread_local = l_lighting_thread_static;

	// set defaults
	if ( r_lighting_direct_start < 0 ) then
		r_lighting_direct_start = f_lighting_direct_get();
	end
	if ( r_lighting_direct_end < 0 ) then
		r_lighting_direct_end = f_lighting_direct_default_get();
	end
	if ( r_lighting_indirect_start < 0 ) then
		r_lighting_indirect_start = f_lighting_indirect_get();
	end
	if ( r_lighting_indirect_end < 0 ) then
		r_lighting_indirect_end = f_lighting_indirect_default_get();
	end
	if ( s_rate < 0 ) then
		s_rate = 1;
	end

	// scale relative time
	if ( r_time < 0.0 ) then
		local short s_count = 0;
		local real r_mod = 0.0;
	
		// sum mod times
		// direct
		r_mod = r_mod + abs_r( r_lighting_direct_end - r_lighting_direct_start );
		s_count = s_count + 1;
		// indirect
		r_mod = r_mod + abs_r( r_lighting_indirect_end - r_lighting_indirect_start );
		s_count = s_count + 1;
	
		r_time = abs_r( r_time * (r_mod/s_count) );
	end

	// thread light scalers
	local long directThreadId = thread( f_lighting_direct_set(r_time, r_lighting_direct_start, r_lighting_direct_end, s_rate) );
	local long indirectThreadId = thread( f_lighting_indirect_set(r_time, r_lighting_indirect_start, r_lighting_indirect_end, s_rate) );
	
	local long endTicks = game_tick_get() + seconds_to_frames(r_time);
	sleep_until(((not IsThreadValid(directThreadId)) and (not IsThreadValid(indirectThreadId))) or game_tick_get() > endTicks, 1);
	
end

// -------------------------------------------------------------------------------------------------
// LIGHTING: DIRECT
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_lighting_direct_set::: Sets the direct lighting over time
//	r_time - The time the lighting transition should happen over
//		NOTE: r_time < 0 is relative time; scaled based on difference ration between start and end time
//	r_lighting_start - Starting direct light scale value
//		DEFAULT [ < 0] = f_lighting_direct_get()
//	r_lighting_end - Ending direct light scale value
//		DEFAULT [ < 0] = f_lighting_direct_default_get()
//	s_rate - The rate in ticks the lighting value is changed
//		DEFAULT [ < 0] = 1
script static void f_lighting_direct_set( real r_time, real r_lighting_start, real r_lighting_end, short s_rate )
static long l_lighting_thread_static = 0;
local long l_lighting_thread_local = 0;

	if ( l_lighting_thread_static != 0 ) then
		kill_thread( l_lighting_thread_static );
		l_lighting_thread_static = 0;
	end
	
	// store the scale target for reset
	//R_lightmap_direct_scale_target = r_lighting_end;

	// thread the lighting scale	
	l_lighting_thread_static = thread( sys_lighting_direct_thread(r_time, r_lighting_start, r_lighting_end, s_rate) );
	l_lighting_thread_local = l_lighting_thread_static;
	
	// wait for it to finish
	local long endTicks = game_tick_get() + seconds_to_frames(r_time);
	sleep_until((not IsThreadValid(l_lighting_thread_local)) or game_tick_get() > endTicks, 1);
	
	if ( l_lighting_thread_local == l_lighting_thread_static ) then
		l_lighting_thread_static = 0;
	end
	
end

// === f_lighting_direct_get::: Gets the current direct lighting scaler value
//	RETURN: lightmapDirectScalar - Current direct lighting scaler value
script static real f_lighting_direct_get()
	lightmapDirectScalar;
end

// === sys_lighting_direct_thread::: Handles the logic for scaling the lighting
//			NOTE: Do not use this function, use f_lighting_direct_set instead
script static void sys_lighting_direct_thread( real r_time, real r_lighting_start, real r_lighting_end, short s_rate )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_lighting_range = 0.0;
static real r_lighting_delta = 0.0;
static real r_time_range = 0.0;
	
	// initialize defualt values
	if ( r_lighting_start < 0 ) then
		r_lighting_start = f_lighting_direct_get();
	end
	if ( r_lighting_end < 0 ) then
		r_lighting_end = f_lighting_direct_default_get();
	end
	if ( s_rate < 0 ) then
		s_rate = 1;
	end
	
	// scale relative time
	if ( r_time < 0.0 ) then
		r_time = abs_r( r_time * (r_lighting_end-r_lighting_start) );
	end

	// get start time	
	l_time_start = game_tick_get();
	
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_time );

	// setup variables
	r_lighting_range = r_lighting_end - r_lighting_start;
	r_time_range = l_time_end - l_time_start;
	
	if ( (r_lighting_range > 0.001) and (r_time_range > 0.001) ) then
		repeat
			r_lighting_delta = real( game_tick_get()-l_time_start ) / r_time_range;
			// apply lighting
			lightmapDirectScalar = r_lighting_start + ( r_lighting_range * r_lighting_delta );
		until ( game_tick_get() > l_time_end, s_rate );
	end
	
	// make sure the lighting gets to it's final state
	lightmapDirectScalar = r_lighting_end;

end

// -------------------------------------------------------------------------------------------------
// LIGHTING: INDIRECT
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_lighting_indirect_set::: Sets the indirect lighting over time
//	r_time - The time the lighting transition should happen over
//		NOTE: r_time < 0 is relative time; scaled based on difference ration between start and end time
//	r_lighting_start - Starting indirect light scale value
//		DEFAULT [ < 0] = f_lighting_indirect_get()
//	r_lighting_end - Ending indirect light scale value
//		DEFAULT [ < 0] = f_lighting_indirect_default_get()
//	s_rate - The rate in ticks the lighting value is changed
//		DEFAULT [ < 0] = 1
script static void f_lighting_indirect_set( real r_time, real r_lighting_start, real r_lighting_end, short s_rate )
static long l_lighting_thread_static = 0;
local long l_lighting_thread_local = 0;

	if ( l_lighting_thread_static != 0 ) then
		kill_thread( l_lighting_thread_static );
		l_lighting_thread_static = 0;
	end
	
	// store the scale target for reset
	//R_lightmap_indirect_scale_target = r_lighting_end;

	// thread the lighting scale	
	l_lighting_thread_static = thread( sys_lighting_indirect_thread(r_time, r_lighting_start, r_lighting_end, s_rate) );
	l_lighting_thread_local = l_lighting_thread_static;
	
	// wait for it to finish
	sleep_until( (r_lighting_end == f_lighting_indirect_get()) or (l_lighting_thread_local != l_lighting_thread_static), 1 );
	if ( l_lighting_thread_local == l_lighting_thread_static ) then
		l_lighting_thread_static = 0;
	end
	
end

// === f_lighting_indirect_get::: Gets the current indirect lighting scaler value
//	RETURN: lightmapIndirectScalar - Current indirect lighting scaler value
script static real f_lighting_indirect_get()
	lightmapIndirectScalar;
end

// === sys_lighting_indirect_thread::: Handles the logic for scaling the lighting
//			NOTE: Do not use this function, use f_lighting_indirect_set instead
script static void sys_lighting_indirect_thread( real r_time, real r_lighting_start, real r_lighting_end, short s_rate )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_lighting_range = 0.0;
static real r_lighting_delta = 0.0;
static real r_time_range = 0.0;
	
	// initialize defualt values
	if ( r_lighting_start < 0 ) then
		r_lighting_start = f_lighting_indirect_get();
	end
	if ( r_lighting_end < 0 ) then
		r_lighting_end = f_lighting_indirect_default_get();
	end
	if ( s_rate < 0 ) then
		s_rate = 1;
	end
	
	// scale relative time
	if ( r_time < 0.0 ) then
		r_time = abs_r( r_time * (r_lighting_end-r_lighting_start) );
	end

	// get start time	
	l_time_start = game_tick_get();
	
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_time );

	// setup variables
	r_lighting_range = r_lighting_end - r_lighting_start;
	r_time_range = l_time_end - l_time_start;
	
	if ( (r_lighting_range > 0.001) and (r_time_range > 0.001) ) then
		repeat
			r_lighting_delta = real( game_tick_get()-l_time_start ) / r_time_range;
			// apply lighting
			lightmapIndirectScalar = r_lighting_start + ( r_lighting_range * r_lighting_delta );
		until ( game_tick_get() > l_time_end, s_rate );
	end
	
	// make sure the lighting gets to it's final state
	lightmapIndirectScalar = r_lighting_end;

end

// -------------------------------------------------------------------------------------------------
// LIGHTING: PULSE
// -------------------------------------------------------------------------------------------------
// variables

global long L_lightmap_pulse_thread = 0;
global long L_lightmap_pulse_direct_thread = 0;
global long L_lightmap_pulse_indirect_thread = 0;
global real R_lightmap_pulse_light_min_scale = 1.0;
global real R_lightmap_pulse_light_max_scale = 1.0;

// functions
/*
global long l_test_lighting_pulse_thread = 0;
script static void test_lighting_pulse_start()
	l_test_lighting_pulse_thread = f_lighting_pulse_start( 2.5, 3.0, 0.10, 0.15, 2.5, 3.0, 0.90, 1.0, 1.5, 2.0 );
	dprint( "test_lighting_pulse_start: COMPLETE!!!!" );
end
script static void test_lighting_pulse_end()
	f_lighting_pulse_end( l_test_lighting_pulse_thread, -3.0, TRUE );
	dprint( "test_lighting_pulse_end: COMPLETE!!!!" );
end
*/

// === f_lighting_pulse_start::: Starts the lighting pulse loop thread
//			r_low_time_min - Min time to transition to low lighting
//			r_low_time_max - Max time to transition to low lighting
//			r_low_lighting_min - Min low lighting pulse scale
//				[r_low_lighting_min < 0] = r_low_lighting_max
//			r_low_lighting_max - Max low lighting pulse scale
//				[r_low_lighting_max < 0] = r_low_lighting_min
//			r_high_time_min - Min time to transition to high lighting
//			r_high_time_max - Max time to transition to high lighting
//			r_high_lighting_min - Min high lighting pulse scale
//				[r_high_lighting_min < 0] = r_high_lighting_max
//			r_high_lighting_max - Max high lighting pulse scale
//				[r_high_lighting_max < 0] = r_high_lighting_min
//			r_pause_time_min - Min time between low & high lighting pulses
//			r_pause_time_max - Max time between low & high lighting pulses
//	RETURN: Returns the index to the lighting pulse thread
script static long f_lighting_pulse_start( real r_low_time_min, real r_low_time_max, real r_low_lighting_min, real r_low_lighting_max, real r_high_time_min, real r_high_time_max, real r_high_lighting_min, real r_high_lighting_max, real r_pause_time_min, real r_pause_time_max )
local string s_error = "";
local long l_return = 0;

	// DEFAULTS: convert default values
	if ( r_low_lighting_min < 0 ) then
		r_low_lighting_min = r_low_lighting_max;
	end
	if ( r_low_lighting_max < 0 ) then
		r_low_lighting_max = r_low_lighting_min;
	end

	if ( r_high_lighting_min < 0 ) then
		r_high_lighting_min = r_high_lighting_max;
	end
	if ( r_high_lighting_max < 0 ) then
		r_high_lighting_max = r_high_lighting_min;
	end

	// ERROR CHECK: Test for errors
	if ( r_low_lighting_min >= r_high_lighting_max ) then
		s_error = "f_lighting_pulse_start: ASSERT: r_low_lighting_min >= r_high_lighting_max";
	end
	if ( (r_low_lighting_min < 0) or (r_low_lighting_max < 0) or (r_low_time_min < 0) or (r_low_time_max < 0) or (r_high_lighting_min < 0) or (r_high_lighting_max < 0) or (r_high_time_min < 0) or (r_high_time_max < 0) ) then
		s_error = "f_lighting_pulse_start: ASSERT: light or time value still < 0";
	end

	// start the thread	
	if ( s_error == "" ) then
		local long l_thread_local = 0;
	
		if ( L_lightmap_pulse_thread != 0 ) then
			kill_thread( L_lightmap_pulse_thread );
			L_lightmap_pulse_thread = 0;
		end
		L_lightmap_pulse_thread = thread( sys_lighting_pulse_thread(r_low_time_min, r_low_time_max, r_low_lighting_min, r_low_lighting_max, r_high_time_min, r_high_time_max, r_high_lighting_min, r_high_lighting_max, r_pause_time_min, r_pause_time_max) );
		
		l_return = L_lightmap_pulse_thread;
		
	else
	
		breakpoint( s_error );
		sleep( 1 );
		
	end
	
	// return the thread
	l_return;
	
end

// === f_lighting_pulse_end::: Ends the lighting pulse loop
//			l_thread_id - The thread ID to shut down;
//				< 0 = Kills any thread
//			b_lighting_restore - TRUE; Will restore the lighting back to the current set default direct & indirect lighting
//			r_time - Time to scale the lighting back to default
//				NOTE: r_time < 0 is relative time, scaled based on difference ration between start and end time (normalized for both direct and indirect)
script static void f_lighting_pulse_end( long l_thread_id, boolean b_lighting_restore, real r_time )

	if ( (L_lightmap_pulse_thread == l_thread_id) or (l_thread_id < 0) ) then
		local long l_lighting_thread_local = L_lightmap_pulse_thread;
		
		kill_thread( L_lightmap_pulse_thread );

		if ( b_lighting_restore ) then
			f_lighting_environment_set( r_time, -1, f_lighting_direct_default_get(), -1, f_lighting_indirect_default_get(), 1 );
		end
		if ( f_lighting_pulse_active(l_lighting_thread_local) ) then
			L_lightmap_pulse_thread = 0;
		end
		
	end

end

// === f_lighting_pulse_active::: Checks if a pulse thread is active
//			l_thread_id - Pulse thread to check if active
//				NOTE: l_thread_id < 0 = Check if any pulse lighting thread is active
script static boolean f_lighting_pulse_active( long l_thread_id )
	( ((L_lightmap_pulse_thread == l_thread_id) and (l_thread_id >= 0)) or ((L_lightmap_pulse_thread != 0) and (l_thread_id < 0)) );
end

// === sys_lighting_pulse_thread::: System function that manages the lighting pulse
//	NOTE: DO NOT USE THIS FUNCTION
script static void sys_lighting_pulse_thread( real r_low_time_min, real r_low_time_max, real r_low_lighting_min, real r_low_lighting_max, real r_high_time_min, real r_high_time_max, real r_high_lighting_min, real r_high_lighting_max, real r_pause_time_min, real r_pause_time_max )
static boolean b_low = TRUE;
static real r_lighting_target = 0.0;
static real r_lighting_time = 0.0;

	repeat
	
		if ( b_low ) then
			dprint( "sys_lighting_pulse_thread: LOW" );
			r_lighting_target = real_random_range( r_low_lighting_min, r_low_lighting_max );
			r_lighting_time = real_random_range( r_low_time_min, r_low_time_max );
		else
			dprint( "sys_lighting_pulse_thread: HIGH" );
			r_lighting_target = real_random_range( r_high_lighting_min, r_high_lighting_max );
			r_lighting_time = real_random_range( r_high_time_min, r_high_time_max );
		end

		f_lighting_environment_set( r_lighting_time, -1, r_lighting_target, -1, r_lighting_target, 1 );
		dprint( "sys_lighting_pulse_thread: PAUSE" );
		sleep_rand_s( r_pause_time_min, r_pause_time_max );
		b_low = not b_low;
	
	until ( FALSE, 1 );

end
