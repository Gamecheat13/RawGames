--## CLIENT

-- =================================================================================================
-- =================================================================================================
-- LIGHTING SCRIPTS
-- =================================================================================================
-- =================================================================================================
-- variables
--global real R_lightmap_direct_scale_target = 1.0;
--global real R_lightmap_indirect_scale_target = 1.0;
-- functions
-- === start_lighting_startup::: Automatically restores lighting to the targeted value
--[[
script startup start_lighting_startup()
	lightmapDirectScalar = R_lightmap_direct_scale_target;
	lightmapIndirectScalar = R_lightmap_indirect_scale_target;
end
]]

global g_dm_render_atmosphere_fog:boolean = true;
global g_dm_render_patchy_fog:boolean = true;

-- -------------------------------------------------------------------------------------------------
-- LIGHTING: DEFAULTS
-- -------------------------------------------------------------------------------------------------
-- variables
global r_lightmap_direct_scale_default:number=1.0;
global r_lightmap_indirect_scale_default:number=1.0;

-- functions
-- === f_lighting_direct_default_set::: Set the default direct lighting values
--	r_lighting - New value for default direct lighting
--		DEFAULT [ < 0] = 1.0
function f_lighting_direct_default_set( r_lighting:number ):void
	if r_lighting < 0 then
		r_lighting = 1.0;
	end
	r_lightmap_direct_scale_default = r_lighting;
end

-- === f_lighting_direct_default_get::: Gets the current default direct lighting value
--			RETURN: R_lightmap_direct_scale_default
function f_lighting_direct_default_get():number
	return r_lightmap_direct_scale_default;
end

-- === f_lighting_indirect_default_set::: Set the default indirect lighting values
--	r_lighting - New value for default direct lighting
--		DEFAULT [ < 0] = 1.0
function f_lighting_indirect_default_set( r_lighting:number ):void
	if r_lighting < 0 then
		r_lighting = 1.0;
	end
	r_lightmap_indirect_scale_default = r_lighting;
end

-- === f_lighting_indirect_default_get::: Gets the current default indirect lighting value
--			RETURN: R_lightmap_indirect_scale_default
function f_lighting_indirect_default_get():number
	return r_lightmap_indirect_scale_default;
end

-- -------------------------------------------------------------------------------------------------
-- LIGHTING: ENVIRONMENT
-- -------------------------------------------------------------------------------------------------
-- variables
-- functions
-- === f_lighting_environment_set::: Scales the direct & indirect lighting over time
--	r_time - The time the lighting transition should happen over
--		NOTE: r_time < 0 is relative time, scaled based on difference ration between start and end time (normalized for both direct and indirect)
--	r_lighting_direct_start - Starting direct light scale value
--		DEFAULT [ < 0] = f_lighting_direct_get()
--	r_lighting_direct_end - Ending direct light scale value
--		DEFAULT [ < 0] = f_lighting_direct_default_get()
--	r_lighting_indirect_start - Starting indirect light scale value
--		DEFAULT [ < 0] = f_lighting_indirect_get()
--	r_lighting_indirect_end - Ending indirect light scale value
--		DEFAULT [ < 0] = f_lighting_indirect_default_get()
--	s_rate - The rate in ticks the lighting value is changed
--		DEFAULT [ < 0] = 1
function f_lighting_environment_set( r_time:number, r_lighting_direct_start:number, r_lighting_direct_end:number, r_lighting_indirect_start:number, r_lighting_indirect_end:number, s_rate:number ):void
	local l_lighting_thread_local:number=0;
	-- store fake thread
	l_lighting_thread_static_80a41450 = l_lighting_thread_static_80a41450 + 1;
	l_lighting_thread_local = l_lighting_thread_static_80a41450;
	-- set defaults
	if r_lighting_direct_start < 0 then
		r_lighting_direct_start = f_lighting_direct_get();
	end
	if r_lighting_direct_end < 0 then
		r_lighting_direct_end = f_lighting_direct_default_get();
	end
	if r_lighting_indirect_start < 0 then
		r_lighting_indirect_start = f_lighting_indirect_get();
	end
	if r_lighting_indirect_end < 0 then
		r_lighting_indirect_end = f_lighting_indirect_default_get();
	end
	if s_rate < 0 then
		s_rate = 1;
	end
	-- scale relative time
	if r_time < 0.0 then
		local s_count:number=0;
		local r_mod:number=0.0;
		-- sum mod times
		-- direct
		r_mod = r_mod + abs_r(r_lighting_direct_end - r_lighting_direct_start);
		s_count = s_count + 1;
		-- indirect
		r_mod = r_mod + abs_r(r_lighting_indirect_end - r_lighting_indirect_start);
		s_count = s_count + 1;
		r_time = abs_r(r_time * (r_mod / s_count));
	end
	-- thread light scalers
	CreateThread(f_lighting_direct_set, r_time, r_lighting_direct_start, r_lighting_direct_end, s_rate);
	CreateThread(f_lighting_indirect_set, r_time, r_lighting_indirect_start, r_lighting_indirect_end, s_rate);
	SleepUntil([| (f_lighting_direct_get() == r_lighting_direct_end and f_lighting_indirect_get() == r_lighting_indirect_end) or l_lighting_thread_local~=l_lighting_thread_static_80a41450 ], 1);
end
global l_lighting_thread_static_80a41450:number=0;

-- -------------------------------------------------------------------------------------------------
-- LIGHTING: DIRECT
-- -------------------------------------------------------------------------------------------------
-- variables
-- functions
-- === f_lighting_direct_set::: Sets the direct lighting over time
--	r_time - The time the lighting transition should happen over
--		NOTE: r_time < 0 is relative time; scaled based on difference ration between start and end time
--	r_lighting_start - Starting direct light scale value
--		DEFAULT [ < 0] = f_lighting_direct_get()
--	r_lighting_end - Ending direct light scale value
--		DEFAULT [ < 0] = f_lighting_direct_default_get()
--	s_rate - The rate in ticks the lighting value is changed
--		DEFAULT [ < 0] = 1
function f_lighting_direct_set( r_time:number, r_lighting_start:number, r_lighting_end:number, s_rate:number ):void
	local l_lighting_thread_local:thread=nil;
	if l_lighting_thread_static_8a230f56~=nil then
		KillThread(l_lighting_thread_static_8a230f56);
		l_lighting_thread_static_8a230f56 = nil;
	end
	-- store the scale target for reset
	--R_lightmap_direct_scale_target = r_lighting_end;
	-- thread the lighting scale	
	l_lighting_thread_static_8a230f56 = CreateThread(sys_lighting_direct_thread, r_time, r_lighting_start, r_lighting_end, s_rate);
	l_lighting_thread_local = l_lighting_thread_static_8a230f56;
	-- wait for it to finish
	SleepUntil([| r_lighting_end == f_lighting_direct_get() or l_lighting_thread_local~=l_lighting_thread_static_8a230f56 ], 1);
	if l_lighting_thread_local == l_lighting_thread_static_8a230f56 then
		l_lighting_thread_static_8a230f56 = nil;
	end
end
global l_lighting_thread_static_8a230f56:thread=nil;

-- === f_lighting_direct_get::: Gets the current direct lighting scaler value
--	RETURN: lightmapDirectScalar - Current direct lighting scaler value
function f_lighting_direct_get():number
	return lightmapDirectScalar;
end

-- === sys_lighting_direct_thread::: Handles the logic for scaling the lighting
--			NOTE: Do not use this function, use f_lighting_direct_set instead
function sys_lighting_direct_thread( r_time:number, r_lighting_start:number, r_lighting_end:number, s_rate:number ):void
	-- initialize defualt values
	if r_lighting_start < 0 then
		r_lighting_start = f_lighting_direct_get();
	end
	if r_lighting_end < 0 then
		r_lighting_end = f_lighting_direct_default_get();
	end
	if s_rate < 0 then
		s_rate = 1;
	end
	-- scale relative time
	if r_time < 0.0 then
		r_time = abs_r(r_time * (r_lighting_end - r_lighting_start));
	end
	-- get start time	
	l_time_start_8b9f697b = game_tick_get();
	-- get end time	
	l_time_end_8b9f697b = l_time_start_8b9f697b + seconds_to_frames(r_time);
	-- setup variables
	r_lighting_range_8b9f697b = r_lighting_end - r_lighting_start;
	r_time_range_8b9f697b = l_time_end_8b9f697b - l_time_start_8b9f697b;
	if r_lighting_range_8b9f697b > 0.001 and r_time_range_8b9f697b > 0.001 then
		repeat
			Sleep(s_rate);
			r_lighting_delta_8b9f697b = (game_tick_get() - l_time_start_8b9f697b) / r_time_range_8b9f697b;
			-- apply lighting
			lightmapDirectScalar = r_lighting_start + r_lighting_range_8b9f697b * r_lighting_delta_8b9f697b;
		until game_tick_get() > l_time_end_8b9f697b;
	end
	-- make sure the lighting gets to it's final state
	lightmapDirectScalar = r_lighting_end;
end
global l_time_start_8b9f697b:number=0;
global l_time_end_8b9f697b:number=0;
global r_lighting_range_8b9f697b:number=0.0;
global r_lighting_delta_8b9f697b:number=0.0;
global r_time_range_8b9f697b:number=0.0;

-- -------------------------------------------------------------------------------------------------
-- LIGHTING: INDIRECT
-- -------------------------------------------------------------------------------------------------
-- variables
-- functions
-- === f_lighting_indirect_set::: Sets the indirect lighting over time
--	r_time - The time the lighting transition should happen over
--		NOTE: r_time < 0 is relative time; scaled based on difference ration between start and end time
--	r_lighting_start - Starting indirect light scale value
--		DEFAULT [ < 0] = f_lighting_indirect_get()
--	r_lighting_end - Ending indirect light scale value
--		DEFAULT [ < 0] = f_lighting_indirect_default_get()
--	s_rate - The rate in ticks the lighting value is changed
--		DEFAULT [ < 0] = 1
function f_lighting_indirect_set( r_time:number, r_lighting_start:number, r_lighting_end:number, s_rate:number ):void
	local l_lighting_thread_local:thread=nil;
	if l_lighting_thread_static_85aba7d0~=nil then
		KillThread(l_lighting_thread_static_85aba7d0);
		l_lighting_thread_static_85aba7d0 = nil;
	end
	-- store the scale target for reset
	--R_lightmap_indirect_scale_target = r_lighting_end;
	-- thread the lighting scale	
	l_lighting_thread_static_85aba7d0 = CreateThread(sys_lighting_indirect_thread, r_time, r_lighting_start, r_lighting_end, s_rate);
	l_lighting_thread_local = l_lighting_thread_static_85aba7d0;
	-- wait for it to finish
	SleepUntil([| r_lighting_end == f_lighting_indirect_get() or l_lighting_thread_local~=l_lighting_thread_static_85aba7d0 ], 1);
	if l_lighting_thread_local == l_lighting_thread_static_85aba7d0 then
		l_lighting_thread_static_85aba7d0 = nil;
	end
end
global l_lighting_thread_static_85aba7d0:thread=nil;

-- === f_lighting_indirect_get::: Gets the current indirect lighting scaler value
--	RETURN: lightmapIndirectScalar - Current indirect lighting scaler value
function f_lighting_indirect_get():number
	return lightmapIndirectScalar;
end

-- === sys_lighting_indirect_thread::: Handles the logic for scaling the lighting
--			NOTE: Do not use this function, use f_lighting_indirect_set instead
function sys_lighting_indirect_thread( r_time:number, r_lighting_start:number, r_lighting_end:number, s_rate:number ):void
	-- initialize defualt values
	if r_lighting_start < 0 then
		r_lighting_start = f_lighting_indirect_get();
	end
	if r_lighting_end < 0 then
		r_lighting_end = f_lighting_indirect_default_get();
	end
	if s_rate < 0 then
		s_rate = 1;
	end
	-- scale relative time
	if r_time < 0.0 then
		r_time = abs_r(r_time * (r_lighting_end - r_lighting_start));
	end
	-- get start time	
	l_time_start_ad73af29 = game_tick_get();
	-- get end time	
	l_time_end_ad73af29 = l_time_start_ad73af29 + seconds_to_frames(r_time);
	-- setup variables
	r_lighting_range_ad73af29 = r_lighting_end - r_lighting_start;
	r_time_range_ad73af29 = l_time_end_ad73af29 - l_time_start_ad73af29;
	if r_lighting_range_ad73af29 > 0.001 and r_time_range_ad73af29 > 0.001 then
		repeat
			Sleep(s_rate);
			r_lighting_delta_ad73af29 = (game_tick_get() - l_time_start_ad73af29) / r_time_range_ad73af29;
			-- apply lighting
			lightmapIndirectScalar = r_lighting_start + r_lighting_range_ad73af29 * r_lighting_delta_ad73af29;
		until game_tick_get() > l_time_end_ad73af29;
	end
	-- make sure the lighting gets to it's final state
	lightmapIndirectScalar = r_lighting_end;
end
global l_time_start_ad73af29:number=0;
global l_time_end_ad73af29:number=0;
global r_lighting_range_ad73af29:number=0.0;
global r_lighting_delta_ad73af29:number=0.0;
global r_time_range_ad73af29:number=0.0;
-- -------------------------------------------------------------------------------------------------
-- LIGHTING: PULSE
-- -------------------------------------------------------------------------------------------------
-- variables
global l_lightmap_pulse_thread:thread=nil;
global r_lightmap_pulse_light_min_scale:number=1.0;
global r_lightmap_pulse_light_max_scale:number=1.0;

-- functions
--[[
global long l_test_lighting_pulse_thread = 0;
script static void test_lighting_pulse_start()
	l_test_lighting_pulse_thread = f_lighting_pulse_start( 2.5, 3.0, 0.10, 0.15, 2.5, 3.0, 0.90, 1.0, 1.5, 2.0 );
	dprint( "test_lighting_pulse_start: COMPLETE!!!!" );
end
script static void test_lighting_pulse_end()
	f_lighting_pulse_end( l_test_lighting_pulse_thread, -3.0, TRUE );
	dprint( "test_lighting_pulse_end: COMPLETE!!!!" );
end
]]
-- === f_lighting_pulse_start::: Starts the lighting pulse loop thread
--			r_low_time_min - Min time to transition to low lighting
--			r_low_time_max - Max time to transition to low lighting
--			r_low_lighting_min - Min low lighting pulse scale
--				[r_low_lighting_min < 0] = r_low_lighting_max
--			r_low_lighting_max - Max low lighting pulse scale
--				[r_low_lighting_max < 0] = r_low_lighting_min
--			r_high_time_min - Min time to transition to high lighting
--			r_high_time_max - Max time to transition to high lighting
--			r_high_lighting_min - Min high lighting pulse scale
--				[r_high_lighting_min < 0] = r_high_lighting_max
--			r_high_lighting_max - Max high lighting pulse scale
--				[r_high_lighting_max < 0] = r_high_lighting_min
--			r_pause_time_min - Min time between low & high lighting pulses
--			r_pause_time_max - Max time between low & high lighting pulses
--	RETURN: Returns the index to the lighting pulse thread
function f_lighting_pulse_start( r_low_time_min:number, r_low_time_max:number, r_low_lighting_min:number, r_low_lighting_max:number, r_high_time_min:number, r_high_time_max:number, r_high_lighting_min:number, r_high_lighting_max:number, r_pause_time_min:number, r_pause_time_max:number ):thread
	local s_error:string="";
	local l_return:thread=nil;
	-- DEFAULTS: convert default values
	if r_low_lighting_min < 0 then
		r_low_lighting_min = r_low_lighting_max;
	end
	if r_low_lighting_max < 0 then
		r_low_lighting_max = r_low_lighting_min;
	end
	if r_high_lighting_min < 0 then
		r_high_lighting_min = r_high_lighting_max;
	end
	if r_high_lighting_max < 0 then
		r_high_lighting_max = r_high_lighting_min;
	end
	-- ERROR CHECK: Test for errors
	if r_low_lighting_min >= r_high_lighting_max then
		s_error = "f_lighting_pulse_start: ASSERT: r_low_lighting_min >= r_high_lighting_max";
	end
	if r_low_lighting_min < 0 or r_low_lighting_max < 0 or r_low_time_min < 0 or r_low_time_max < 0 or r_high_lighting_min < 0 or r_high_lighting_max < 0 or r_high_time_min < 0 or r_high_time_max < 0 then
		s_error = "f_lighting_pulse_start: ASSERT: light or time value still < 0";
	end
	-- start the thread	
	if s_error == "" then
		if l_lightmap_pulse_thread~=nil then
			KillThread(l_lightmap_pulse_thread);
			l_lightmap_pulse_thread = nil;
		end
		l_lightmap_pulse_thread = CreateThread(sys_lighting_pulse_thread, r_low_time_min, r_low_time_max, r_low_lighting_min, r_low_lighting_max, r_high_time_min, r_high_time_max, r_high_lighting_min, r_high_lighting_max, r_pause_time_min, r_pause_time_max);
		l_return = l_lightmap_pulse_thread;
	else
		Breakpoint(s_error);
		Sleep(1);
	end
	return l_return;
end

-- return the thread
-- === f_lighting_pulse_end::: Ends the lighting pulse loop
--			l_thread_id - The thread ID to shut down;
--				< 0 = Kills any thread
--			b_lighting_restore - TRUE; Will restore the lighting back to the current set default direct & indirect lighting
--			r_time - Time to scale the lighting back to default
--				NOTE: r_time < 0 is relative time, scaled based on difference ration between start and end time (normalized for both direct and indirect)
function f_lighting_pulse_end( l_thread_id:thread, b_lighting_restore:boolean, r_time:number ):void
	if l_lightmap_pulse_thread == l_thread_id or l_thread_id == nil then
		local l_lighting_thread_local:thread=l_lightmap_pulse_thread;
		KillThread(l_lightmap_pulse_thread);
		if b_lighting_restore then
			f_lighting_environment_set(r_time, -1, f_lighting_direct_default_get(), -1, f_lighting_indirect_default_get(), 1);
		end
		if f_lighting_pulse_active(l_lighting_thread_local) then
			l_lightmap_pulse_thread = nil;
		end
	end
end

-- === f_lighting_pulse_active::: Checks if a pulse thread is active
--			l_thread_id - Pulse thread to check if active
--				NOTE: l_thread_id =nil -> Check if any pulse lighting thread is active
function f_lighting_pulse_active( l_thread_id:thread ):boolean
	return (l_lightmap_pulse_thread == l_thread_id and l_thread_id~=nil) or (l_lightmap_pulse_thread~=nil and l_thread_id == nil);
end

-- === sys_lighting_pulse_thread::: System function that manages the lighting pulse
--	NOTE: DO NOT USE THIS FUNCTION
function sys_lighting_pulse_thread( r_low_time_min:number, r_low_time_max:number, r_low_lighting_min:number, r_low_lighting_max:number, r_high_time_min:number, r_high_time_max:number, r_high_lighting_min:number, r_high_lighting_max:number, r_pause_time_min:number, r_pause_time_max:number ):void
	repeat
		Sleep(1);
		if b_low_dfa093d0 then
			dprint("sys_lighting_pulse_thread: LOW");
			r_lighting_target_dfa093d0 = real_random_range(r_low_lighting_min, r_low_lighting_max);
			r_lighting_time_dfa093d0 = real_random_range(r_low_time_min, r_low_time_max);
		else
			dprint("sys_lighting_pulse_thread: HIGH");
			r_lighting_target_dfa093d0 = real_random_range(r_high_lighting_min, r_high_lighting_max);
			r_lighting_time_dfa093d0 = real_random_range(r_high_time_min, r_high_time_max);
		end
		f_lighting_environment_set(r_lighting_time_dfa093d0, -1, r_lighting_target_dfa093d0, -1, r_lighting_target_dfa093d0, 1);
		dprint("sys_lighting_pulse_thread: PAUSE");
		sleep_rand_s(r_pause_time_min, r_pause_time_max);
		b_low_dfa093d0 =  not b_low_dfa093d0;
	until false;
end
global b_low_dfa093d0:boolean=true;
global r_lighting_target_dfa093d0:number=0.0;
global r_lighting_time_dfa093d0:number=0.0;
