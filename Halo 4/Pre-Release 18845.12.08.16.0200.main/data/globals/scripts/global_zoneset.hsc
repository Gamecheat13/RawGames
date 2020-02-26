// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** global zone set ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_zoneset_emulate_current = 										0; 
static long L_zoneset_emulate_current_active = 							0;



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GENERAL
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_current: Gets the current zone set
//	RETURNS:  long; game = current_zone_set(), editor = L_zoneset_emulate_current
script static long zoneset_current()
	if ( not editor_mode() ) then
		current_zone_set();
	else
		L_zoneset_emulate_current;
	end
end

// === zoneset_current_active: Gets the current fully active zone set
//	RETURNS:  long; game = current_zone_set_fully_active(), editor = L_zoneset_emulate_current_active
script static long zoneset_current_active()
	if ( not editor_mode() ) then
		current_zone_set_fully_active();
	else
		L_zoneset_emulate_current_active;
	end
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// PREPARE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_zoneset_preparing = 													-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_prepare: Prepares zone set for loading
//			l_zoneset_id = zone set index to load
//			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
//	RETURNS: [BOOLEAN] TRUE; Zone Set has been prepared or loaded
script static boolean zoneset_prepare( long l_zoneset_id, boolean b_check_loaded )

	dprint( "::: zoneset_prepare" );
	if ( ((zoneset_current() != l_zoneset_id) and (L_zoneset_preparing != l_zoneset_id)) or (not b_check_loaded) ) then

		// stamp the zone set timer
		sys_zoneset_timer_stamp();

		// set which zone set is loading
		L_zoneset_preparing = l_zoneset_id;

		// load the zone set
		dprint( "::: zoneset_prepare: PREPARING" );
		prepare_to_switch_to_zone_set( l_zoneset_id );

		if (L_zoneset_preparing == l_zoneset_id) then

			// set the emulation variables
			L_zoneset_emulate_current_active = -1;
			L_zoneset_emulate_current = l_zoneset_id;

			dprint( "::: zoneset_prepare: WAITING" );
			repeat
				dprint( "zoneset_prepare: zoneset_current_active()" );
				inspect( zoneset_current_active() );
				dprint( "zoneset_prepare: zoneset_current()" );
				inspect( zoneset_current() );
				dprint( "zoneset_prepare: l_zoneset_id" );
				inspect( l_zoneset_id );
				dprint( "zoneset_prepare: L_zoneset_preparing" );
				inspect( L_zoneset_preparing );
			until( (zoneset_current() == l_zoneset_id) or (L_zoneset_preparing != l_zoneset_id), 1);
		
		end

		if ( zoneset_current() != l_zoneset_id ) then
			dprint( "::: zoneset_prepare: INDEX CHANGED" );
		end
		
		dprint( "::: zoneset_prepare: COMPLETE" );
	end
	
	// RETURN
	zoneset_current() == l_zoneset_id;
	
end
script static boolean zoneset_prepare( long l_zoneset_id )
	zoneset_prepare( l_zoneset_id, TRUE );
end

// === zoneset_preparing_index: Returns what zone set index is currently preparing
//	RETURNS:  [long] current zone set preparing; -1 if no zone set is preparing
script static long zoneset_preparing_index()

	if ( (zoneset_current_active() == -1) and (PreparingToSwitchZoneSet()) ) then
		zoneset_current();
	else
		-1;
	end

end

// === zoneset_prepare_complete: Checks if a zone set index has finished preparing
//	RETURNS:  [boolean] XXX
script static boolean zoneset_prepare_complete( long l_zoneset_id )
	( zoneset_current_active() == l_zoneset_id ) or ( (zoneset_current() == l_zoneset_id) and (not PreparingToSwitchZoneSet()) );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LOADING
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_zoneset_loading = 														-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_load: Loads an insertion index
//			l_zoneset_id = zone set index to load
//			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
//	RETURNS: [BOOLEAN] TRUE; Zone Set has been loaded
script static boolean zoneset_load( long l_zoneset_id, boolean b_check_loaded )

	dprint( "::: zoneset_load ::: " );
	if ( ((zoneset_current_active() != l_zoneset_id) and (L_zoneset_loading != l_zoneset_id)) or (not b_check_loaded) ) then
		// stamp the zone set timer
		sys_zoneset_timer_stamp();

		// set which zone set is loading
		L_zoneset_loading = l_zoneset_id;

		// load the zone set
		dprint( "::: zoneset_load: LOADING" );
		switch_zone_set( l_zoneset_id );

		if (L_zoneset_loading == l_zoneset_id) then
		
			// set the emulation variables
			if ( editor_mode() ) then
				sleep( 1 );
			end
			L_zoneset_emulate_current = l_zoneset_id;
			L_zoneset_emulate_current_active = l_zoneset_id;

			dprint( "::: zoneset_load: WAITING" );
			repeat
				dprint( "zoneset_load: zoneset_current_active()" );
				inspect( zoneset_current_active() );
				dprint( "zoneset_load: zoneset_current()" );
				inspect( zoneset_current() );
				dprint( "zoneset_load: l_zoneset_id" );
				inspect( l_zoneset_id );
				dprint( "zoneset_load: L_zoneset_loading" );
				inspect( L_zoneset_loading );
			until( (zoneset_current_active() == l_zoneset_id) or (L_zoneset_loading != l_zoneset_id), 1);
			
		end

		if ( zoneset_current_active() != l_zoneset_id ) then
			dprint( "::: zoneset_load: INDEX CHANGED" );
		end

		dprint( "::: zoneset_load: COMPLETE" );

	end
	
	// RETURN
	zoneset_current_active() == l_zoneset_id;
	
end
script static boolean zoneset_load( long l_zoneset_id )
	zoneset_load( l_zoneset_id, TRUE );
end

// === zoneset_load_auto: xxx
//	RETURNS:  [xx] xxx
script static boolean zoneset_load_auto( long l_zoneset_id )

	// wait for zone set to be preparing
	sleep_until( zoneset_current() == l_zoneset_id, 1 );

	// wait prepare to finish
	if ( zoneset_current_active() != l_zoneset_id ) then
		sleep_until( zoneset_preparing_index() != l_zoneset_id, 1 );

		// load zone set
		if ( zoneset_current() == l_zoneset_id ) then
			zoneset_load( l_zoneset_id, TRUE );
		end
	end
	
	// RETURN
	zoneset_current_active() == l_zoneset_id;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// PREPARE & LOAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_prepare_and_load: Prepares and loads a zone set when it is ready or the timer expires
//			l_zoneset_id = zone set index to load
//			r_delay_max = Delay before forcing the load
//						[r_delay_max < 0.0] Disable delay timer
//	RETURNS:  [boolean] 
script static boolean zoneset_prepare_and_load( long l_zoneset_id, real r_delay_max )

	if ( l_zoneset_id >= 0 ) then
	
		// prepare
		zoneset_prepare( l_zoneset_id, TRUE );

		// wait for prepare to complete
		sleep_until( (zoneset_preparing_index() != l_zoneset_id) or ((r_delay_max >= 0.0) and zoneset_timer_expired(r_delay_max)), 1 );

		// load
		if ( zoneset_current() == l_zoneset_id ) then
			zoneset_load( l_zoneset_id, TRUE );
		end

	end

	// RETURN
	zoneset_current_active() == l_zoneset_id;

end
script static boolean zoneset_prepare_and_load( long l_zoneset_id )
	zoneset_prepare_and_load( l_zoneset_id, -1.0 );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// TRIGGERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_trigger_prepare_enable: xxx
//	RETURNS:  [xx] xxx
script static long zoneset_trigger_prepare_enable( string_id sid_zone_set, long l_zoneset_id, boolean b_enabled, boolean b_auto_disable )
local long l_thread = 0;

	// trigger enable/disable
	zone_set_trigger_volume_enable( sid_zone_set, b_enabled );

	if ( b_enabled ) then
	
		// setup the emulation trigger
		if ( editor_mode() ) then
			sys_zoneset_trigger_prepare_emulate( trigger_volume_from_string(sid_zone_set), l_zoneset_id, b_auto_disable );
		end

		// setup automatic diable
		if ( b_auto_disable ) then
			l_thread = thread( sys_zoneset_trigger_prepare_disable_auto(sid_zone_set, l_zoneset_id) );
		end
		
	end

	// RETURN
	l_thread;
	
end
script static long zoneset_trigger_prepare_enable( string_id sid_zone_set, long l_zoneset_id, boolean b_enabled )
	zoneset_trigger_prepare_enable( sid_zone_set, l_zoneset_id, b_enabled, TRUE );
end

// === zoneset_trigger_load_enable: xxx
//	RETURNS:  [xx] xxx
script static long zoneset_trigger_load_enable( string_id sid_zone_set, long l_zoneset_id, boolean b_enabled, boolean b_auto_disable )
local long l_thread = 0;

	// trigger enable/disable
	zone_set_trigger_volume_enable( sid_zone_set, b_enabled );

	if ( b_enabled ) then
	
		// setup the emulation trigger
		if ( editor_mode() ) then
			sys_zoneset_trigger_load_emulate( trigger_volume_from_string(sid_zone_set), l_zoneset_id, b_auto_disable );
		end

		// setup automatic diable
		if ( b_auto_disable ) then
			l_thread = thread( sys_zoneset_trigger_load_disable_auto(sid_zone_set, l_zoneset_id) );
		end
		
	end

	// RETURN
	l_thread;
	
end
script static long zoneset_trigger_load_enable( string_id sid_zone_set, long l_zoneset_id, boolean b_enabled )
	zoneset_trigger_load_enable( sid_zone_set, l_zoneset_id, b_enabled, TRUE );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// === sys_zoneset_trigger_prepare_emulate: xxx
script static void sys_zoneset_trigger_prepare_emulate( trigger_volume tv_volume, long l_zoneset_id, boolean b_auto_disable )

	// wait for player to trigger the volume
	sleep_until( volume_test_players(tv_volume) or (b_auto_disable and (zoneset_current() == l_zoneset_id)), 1 );
	
	// set the emulation variables
	if ( zoneset_current() != l_zoneset_id ) then
		L_zoneset_emulate_current_active = -1;
		L_zoneset_emulate_current = l_zoneset_id;
	end

end

// === sys_zoneset_trigger_prepare_disable_auto: xxx
script static void sys_zoneset_trigger_prepare_disable_auto( string_id sid_zone_set, long l_zoneset_id )

	// wait for zone set to switch
	sleep_until( zoneset_current() == l_zoneset_id, 1 );

	// disable the volume
	zone_set_trigger_volume_enable( sid_zone_set, FALSE );
	
	// debug
	dprint( "sys_zoneset_trigger_prepare_disable_auto" );
	inspect( sid_zone_set );
	
end

// === sys_zoneset_trigger_load_emulate: xxx
script static void sys_zoneset_trigger_load_emulate( trigger_volume tv_volume, long l_zoneset_id, boolean b_auto_disable )

	// wait for player to trigger the volume
	sleep_until( volume_test_players(tv_volume) or (b_auto_disable and (zoneset_current_active() == l_zoneset_id)), 1 );
	
	// set the emulation variables
	if ( zoneset_current_active() != l_zoneset_id ) then
		L_zoneset_emulate_current_active = l_zoneset_id;
		L_zoneset_emulate_current = l_zoneset_id;
	end

end

// === sys_zoneset_trigger_load_disable_auto: xxx
script static void sys_zoneset_trigger_load_disable_auto( string_id sid_zone_set, long l_zoneset_id )

	// wait for zone set to switch
	sleep_until( zoneset_current_active() == l_zoneset_id, 1 );

	// disable the volume
	zone_set_trigger_volume_enable( sid_zone_set, FALSE );

	// debug
	dprint( "sys_zone_set_begin_trigger_auto_disable" );
	inspect( sid_zone_set );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// TIMER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_sys_zoneset_timer_stamp = 										-1;
static long L_zoneset_timer_stamp_current = 								-1;
static long L_zoneset_timer_stamp_current_active = 				-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_timer_expired: xxx
//	RETURNS:  [xx] xxx
script static boolean zoneset_timer_expired( real r_time )
	timer_expired( L_sys_zoneset_timer_stamp, r_time );
end
script static boolean zoneset_timer_expired()
	timer_expired( L_sys_zoneset_timer_stamp );
end

// === zoneset_timer_current: xxx
//	RETURNS:  [xx] xxx
script static long zoneset_timer_current()
	L_zoneset_timer_stamp_current;
end

// === zoneset_timer_current_active: xxx
//	RETURNS:  [xx] xxx
script static long zoneset_timer_current_active()
	L_zoneset_timer_stamp_current_active;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_zoneset_timer_stamp: XXX
script static void sys_zoneset_timer_stamp()
	dprint( "sys_zoneset_timer_stamp" );
	if ( L_sys_zoneset_timer_stamp < 0 ) then
		L_sys_zoneset_timer_stamp = 0;
		thread( sys_zoneset_timer() );
	end
end

// === sys_zoneset_timer: XXX
script static void sys_zoneset_timer()

	repeat
	
		// store the stamp values
		L_sys_zoneset_timer_stamp = timer_stamp();
		L_zoneset_timer_stamp_current = zoneset_current();
		L_zoneset_timer_stamp_current_active = zoneset_current_active();
		
		sleep_until( (zoneset_current() != L_zoneset_timer_stamp_current) or (zoneset_current_active() != L_zoneset_timer_stamp_current_active), 1 );
		
	until( FALSE, 1 );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// RANGE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean zoneset_range( long l_zoneset, long l_zoneset_min, long l_zoneset_max )
	( (l_zoneset_min <= l_zoneset) or (l_zoneset_min == -1) )
	and
	( (l_zoneset <= l_zoneset_max) or (l_zoneset_max == -1) );
end
