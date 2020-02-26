--## SERVER

-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- *** global zone set ***
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global l_zoneset_emulate_current_537dd121:zone_set=nil;
global l_zoneset_emulate_current_active_537dd121:zone_set=nil;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- GENERAL
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_current: Gets the current zone set
--	RETURNS:  long; game = current_zone_set(), editor = L_zoneset_emulate_current
function zoneset_current():zone_set
	if  not editor_mode() then
		return current_zone_set();
	else
		return l_zoneset_emulate_current_537dd121;
	end
end

-- === zoneset_current_active: Gets the current fully active zone set
--	RETURNS:  long; game = current_zone_set_fully_active(), editor = L_zoneset_emulate_current_active
function zoneset_current_active():zone_set
	if  not editor_mode() then
		return current_zone_set_fully_active();
	else
		return l_zoneset_emulate_current_active_537dd121;
	end
end
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global l_zoneset_preparing_537dd121:zone_set=nil;
global s_zoneset_prepare_delay_537dd121:number=0;

-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_prepare: Prepares zone set for loading
--			l_zoneset_id = zone set index to load
--			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
--	RETURNS: [BOOLEAN] TRUE; Zone Set has been prepared or loaded
function zoneset_prepare( l_zoneset_id:zone_set, b_check_loaded:boolean ):boolean
	dprint("::: zoneset_prepare");
	if (zoneset_current()~=l_zoneset_id and l_zoneset_preparing_537dd121~=l_zoneset_id) or  not b_check_loaded then
		-- stamp the zone set timer
		sys_zoneset_timer_stamp();
		-- set which zone set is loading
		l_zoneset_preparing_537dd121 = l_zoneset_id;
		if zoneset_prepare_delay_get() > 0 then
			Sleep(zoneset_prepare_delay_get());
		end
		-- load the zone set
		dprint("::: zoneset_prepare: PREPARING");
		prepare_to_switch_to_zone_set(l_zoneset_id);
		if l_zoneset_preparing_537dd121 == l_zoneset_id then
			-- set the emulation variables
			l_zoneset_emulate_current_active_537dd121 = nil;
			l_zoneset_emulate_current_537dd121 = l_zoneset_id;
			dprint("::: zoneset_prepare: WAITING");
			repeat
				Sleep(1);
				dprint("zoneset_prepare: zoneset_current_active()");
				print(zoneset_current_active());
				dprint("zoneset_prepare: zoneset_current()");
				print(zoneset_current());
				dprint("zoneset_prepare: l_zoneset_id");
				print(l_zoneset_id);
				dprint("zoneset_prepare: L_zoneset_preparing");
				print(l_zoneset_preparing_537dd121);
			until zoneset_current() == l_zoneset_id or l_zoneset_preparing_537dd121~=l_zoneset_id;
		end
		if zoneset_current()~=l_zoneset_id then
			dprint("::: zoneset_prepare: INDEX CHANGED");
		end
		dprint("::: zoneset_prepare: COMPLETE");
	end
	-- RETURN
	return zoneset_current() == l_zoneset_id;
end

--[[
script static boolean zoneset_prepare( zone_set l_zoneset_id )
	zoneset_prepare( l_zoneset_id, TRUE );
end
]]
-- === zoneset_preparing: Returns the zone set that is preparing
function zoneset_preparing():zone_set
	return l_zoneset_preparing_537dd121;
end

-- === zoneset_prepare_delay: Get/get the zone set prepare delay
function zoneset_prepare_delay_set( s_delay:number ):void
	s_zoneset_prepare_delay_537dd121 = s_delay;
end

function zoneset_prepare_delay_get():number
	return s_zoneset_prepare_delay_537dd121;
end

-- === zoneset_preparing_index: Returns what zone set index is currently preparing
--	RETURNS:  [long] current zone set preparing; -1 if no zone set is preparing
function zoneset_preparing_index():zone_set
	if zoneset_current_active() == nil and PreparingToSwitchZoneSet() then
		return zoneset_current();
	else
		return nil;
	end
end

-- === zoneset_prepare_complete: Checks if a zone set index has finished preparing
--	RETURNS:  [boolean] XXX
function zoneset_prepare_complete( l_zoneset_id:zone_set ):boolean
	return zoneset_current_active() == l_zoneset_id or (zoneset_current() == l_zoneset_id and  not PreparingToSwitchZoneSet());
end
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- LOADING
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global l_zoneset_loading_537dd121:zone_set=nil;
global s_zoneset_load_delay_537dd121:number=0;

-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_load: Loads an insertion index
--			l_zoneset_id = zone set index to load
--			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
--	RETURNS: [BOOLEAN] TRUE; Zone Set has been loaded
function zoneset_load( l_zoneset_id:zone_set, b_check_loaded:boolean ):boolean
	dprint("::: zoneset_load ::: ");
	if (zoneset_current_active()~=l_zoneset_id and l_zoneset_loading_537dd121~=l_zoneset_id) or  not b_check_loaded then
		-- stamp the zone set timer
		sys_zoneset_timer_stamp();
		-- set which zone set is loading
		l_zoneset_loading_537dd121 = l_zoneset_id;
		if zoneset_load_delay_get() > 0 then
			Sleep(zoneset_load_delay_get());
		end
		-- load the zone set
		dprint("::: zoneset_load: LOADING");
		switch_zone_set(l_zoneset_id);
		if l_zoneset_loading_537dd121 == l_zoneset_id then
			-- set the emulation variables
			if editor_mode() then
				Sleep(1);
			end
			l_zoneset_emulate_current_537dd121 = l_zoneset_id;
			l_zoneset_emulate_current_active_537dd121 = l_zoneset_id;
			dprint("::: zoneset_load: WAITING");
			repeat
				Sleep(1);
				dprint("zoneset_load: zoneset_current_active()");
				print(zoneset_current_active());
				dprint("zoneset_load: zoneset_current()");
				print(zoneset_current());
				dprint("zoneset_load: l_zoneset_id");
				print(l_zoneset_id);
				dprint("zoneset_load: L_zoneset_loading");
				print(l_zoneset_loading_537dd121);
			until zoneset_current_active() == l_zoneset_id or l_zoneset_loading_537dd121~=l_zoneset_id;
		end
		if zoneset_current_active()~=l_zoneset_id then
			dprint("::: zoneset_load: INDEX CHANGED");
		end
		dprint("::: zoneset_load: COMPLETE");
	end
	-- RETURN
	return zoneset_current_active() == l_zoneset_id;
end

--[[
script static boolean zoneset_load( zone_set l_zoneset_id )
	zoneset_load( l_zoneset_id, TRUE );
end
]]
-- === zoneset_loading: Returns the zone set that is loading
function zoneset_loading():zone_set
	return l_zoneset_loading_537dd121;
end

-- === zoneset_load_delay: Get/get the zone set load delay
function zoneset_load_delay( s_delay:number ):void
	s_zoneset_load_delay_537dd121 = s_delay;
end

function zoneset_load_delay_get():number
	return s_zoneset_load_delay_537dd121;
end

-- === zoneset_load_auto: xxx
--	RETURNS:  [xx] xxx
function zoneset_load_auto( l_zoneset_id:zone_set ):boolean
	-- wait for zone set to be preparing
	SleepUntil([| zoneset_current() == l_zoneset_id ], 1);
	-- wait prepare to finish
	if zoneset_current_active()~=l_zoneset_id then
		SleepUntil([| zoneset_preparing_index()~=l_zoneset_id ], 1);
		-- load zone set
		if zoneset_current() == l_zoneset_id then
			zoneset_load(l_zoneset_id, true);
		end
	end
	-- RETURN
	return zoneset_current_active() == l_zoneset_id;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE & LOAD
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_prepare_and_load: Prepares and loads a zone set when it is ready or the timer expires
--			l_zoneset_id = zone set index to load
--			r_delay_max = Delay before forcing the load
--						[r_delay_max < 0.0] Disable delay timer
--	RETURNS:  [boolean] 
function zoneset_prepare_and_load( l_zoneset_id:zone_set, r_delay_max:number ):boolean
	if compare_zone_sets(l_zoneset_id,ZONE_SETS[0])>=0 then
		-- prepare
		zoneset_prepare(l_zoneset_id, true);
		-- wait for prepare to complete
		SleepUntil([| zoneset_preparing_index()~=l_zoneset_id or (r_delay_max >= 0.0 and zoneset_timer_expired(r_delay_max)) ], 1);
		-- load
		if zoneset_current() == l_zoneset_id then
			zoneset_load(l_zoneset_id, true);
		end
	end
	-- RETURN
	return zoneset_current_active() == l_zoneset_id;
end

--[[
script static boolean zoneset_prepare_and_load( zone_set l_zoneset_id )
	zoneset_prepare_and_load( l_zoneset_id, -1.0 );
end
]]
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGERS
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_trigger_prepare_enable: xxx
--	RETURNS:  [xx] xxx
function zoneset_trigger_prepare_enable( sid_zone_set:string, l_zoneset_id:zone_set, b_enabled:boolean, b_auto_disable:boolean ):thread
	local l_thread:thread=nil;
	-- trigger enable/disable
	zone_set_trigger_volume_enable(sid_zone_set, b_enabled);
	if b_enabled then
		-- setup the emulation trigger
		if editor_mode() then
			sys_zoneset_trigger_prepare_emulate(trigger_volume_from_string(sid_zone_set), l_zoneset_id, b_auto_disable);
		end
		-- setup automatic diable
		if b_auto_disable then
			l_thread = CreateThread(sys_zoneset_trigger_prepare_disable_auto, sid_zone_set, l_zoneset_id);
		end
	end
	return l_thread;
end

-- RETURN
--[[
script static long zoneset_trigger_prepare_enable( string_id sid_zone_set, zone_set l_zoneset_id, boolean b_enabled )
	zoneset_trigger_prepare_enable( sid_zone_set, l_zoneset_id, b_enabled, TRUE );
end
]]
-- === zoneset_trigger_load_enable: xxx
--	RETURNS:  [xx] xxx
function zoneset_trigger_load_enable( sid_zone_set:string, l_zoneset_id:zone_set, b_enabled:boolean, b_auto_disable:boolean ):thread
	local l_thread:thread=nil;
	-- trigger enable/disable
	zone_set_trigger_volume_enable(sid_zone_set, b_enabled);
	if b_enabled then
		-- setup the emulation trigger
		if editor_mode() then
			sys_zoneset_trigger_load_emulate(trigger_volume_from_string(sid_zone_set), l_zoneset_id, b_auto_disable);
		end
		-- setup automatic diable
		if b_auto_disable then
			l_thread = CreateThread(sys_zoneset_trigger_load_disable_auto, sid_zone_set, l_zoneset_id);
		end
	end
	return l_thread;
end

-- RETURN
--[[
script static long zoneset_trigger_load_enable( string_id sid_zone_set, zone_set l_zoneset_id, boolean b_enabled )
	zoneset_trigger_load_enable( sid_zone_set, l_zoneset_id, b_enabled, TRUE );
end
]]
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- === sys_zoneset_trigger_prepare_emulate: xxx
function sys_zoneset_trigger_prepare_emulate( tv_volume:volume, l_zoneset_id:zone_set, b_auto_disable:boolean ):void
	-- wait for player to trigger the volume
	SleepUntil([| volume_test_players(tv_volume) or (b_auto_disable and zoneset_current() == l_zoneset_id) ], 1);
	-- set the emulation variables
	if zoneset_current()~=l_zoneset_id then
		l_zoneset_emulate_current_active_537dd121 = nil;
		l_zoneset_emulate_current_537dd121 = l_zoneset_id;
	end
end

-- === sys_zoneset_trigger_prepare_disable_auto: xxx
function sys_zoneset_trigger_prepare_disable_auto( sid_zone_set:string, l_zoneset_id:zone_set ):void
	-- wait for zone set to switch
	SleepUntil([| zoneset_current() == l_zoneset_id ], 1);
	-- disable the volume
	zone_set_trigger_volume_enable(sid_zone_set, false);
	-- debug
	dprint("sys_zoneset_trigger_prepare_disable_auto");
	print(sid_zone_set);
end

-- === sys_zoneset_trigger_load_emulate: xxx
function sys_zoneset_trigger_load_emulate( tv_volume:volume, l_zoneset_id:zone_set, b_auto_disable:boolean ):void
	-- wait for player to trigger the volume
	SleepUntil([| volume_test_players(tv_volume) or (b_auto_disable and zoneset_current_active() == l_zoneset_id) ], 1);
	-- set the emulation variables
	if zoneset_current_active()~=l_zoneset_id then
		l_zoneset_emulate_current_active_537dd121 = l_zoneset_id;
		l_zoneset_emulate_current_537dd121 = l_zoneset_id;
	end
end

-- === sys_zoneset_trigger_load_disable_auto: xxx
function sys_zoneset_trigger_load_disable_auto( sid_zone_set:string, l_zoneset_id:zone_set ):void
	-- wait for zone set to switch
	SleepUntil([| zoneset_current_active() == l_zoneset_id ], 1);
	-- disable the volume
	zone_set_trigger_volume_enable(sid_zone_set, false);
	-- debug
	dprint("sys_zone_set_begin_trigger_auto_disable");
	print(sid_zone_set);
end
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TIMER
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global l_sys_zoneset_timer_stamp_537dd121:number=-1;
global l_zoneset_timer_stamp_current_537dd121:zone_set=nil;
global l_zoneset_timer_stamp_current_active_537dd121:zone_set=nil;

-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === zoneset_timer_expired: xxx
--	RETURNS:  [xx] xxx
function zoneset_timer_expired( r_time:number ):boolean
	return timer_expired(l_sys_zoneset_timer_stamp_537dd121, r_time);
end

--[[
script static boolean zoneset_timer_expired()
	timer_expired( L_sys_zoneset_timer_stamp );
end
]]
-- === zoneset_timer_current: xxx
--	RETURNS:  [xx] xxx
function zoneset_timer_current():zone_set
	return l_zoneset_timer_stamp_current_537dd121;
end

-- === zoneset_timer_current_active: xxx
--	RETURNS:  [xx] xxx
function zoneset_timer_current_active():zone_set
	return l_zoneset_timer_stamp_current_active_537dd121;
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- === sys_zoneset_timer_stamp: XXX
function sys_zoneset_timer_stamp():void
	dprint("sys_zoneset_timer_stamp");
	if l_sys_zoneset_timer_stamp_537dd121 < 0 then
		l_sys_zoneset_timer_stamp_537dd121 = 0;
		CreateThread(sys_zoneset_timer);
	end
end

-- === sys_zoneset_timer: XXX
function sys_zoneset_timer():void
	repeat
		Sleep(1);
		-- store the stamp values
		l_sys_zoneset_timer_stamp_537dd121 = timer_stamp();
		l_zoneset_timer_stamp_current_537dd121 = zoneset_current();
		l_zoneset_timer_stamp_current_active_537dd121 = zoneset_current_active();
		SleepUntil([| zoneset_current()~=l_zoneset_timer_stamp_current_537dd121 or zoneset_current_active()~=l_zoneset_timer_stamp_current_active_537dd121 ], 1);
	until false;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- RANGE
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
function zoneset_range( l_zoneset:number, l_zoneset_min:number, l_zoneset_max:number ):boolean
	return (l_zoneset_min <= l_zoneset or l_zoneset_min == -1) and (l_zoneset <= l_zoneset_max or l_zoneset_max == -1);
end
