// =================================================================================================
// =================================================================================================
// ABILITIES
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// ABILITY TIMER
// -------------------------------------------------------------------------------------------------
// variables
global long			L_ability_timer_thread 					= 0;
global long 		L_ability_timer_active_start 		= 0;
global real 		R_ability_timer_active_time			= 0.0;
global long 		L_ability_timer_inactive_start 	= 0;
global real 		R_ability_timer_inactive_time 	= 0.0;
global long			L_ability_timer_enabled_time		= 0;

// functions
// === f_ability_timer_start::: Starts the equipment watch
script static void f_ability_timer_start( boolean b_reset )

	if ( L_ability_timer_thread == 0 ) then
		dprint( "::: f_ability_timer_start :::" );
		L_ability_timer_thread = thread( f_ability_timer_loop() );
	end
	
	if ( b_reset ) then
		f_ability_timer_reset();
	end
	
	L_ability_timer_enabled_time = game_tick_get();

end

// === f_ability_timer_loop::: Watches the amount of time the players have used the equipment
script static void f_ability_timer_loop()
static boolean b_active = FALSE;
	dprint( "::: f_ability_timer_loop :::" );
	
	repeat
	
		// get what to watch for
		b_active = player_action_test_equipment();
		
		// update all the timers to their current status
		f_ability_timer_update();

		if ( b_active ) then
			// start the timer
			L_ability_timer_active_start = game_tick_get();
			
			// reset the other timer
			L_ability_timer_inactive_start = 0;
		else
			// start the timer
			L_ability_timer_inactive_start = game_tick_get();

			// reset the other timer
			L_ability_timer_active_start = 0;
		end

		sleep_until( player_action_test_equipment() != b_active, 1 );
	
	until ( FALSE, 1 );

end

// === f_ability_timer_update::: Updates the time equipment active/inactive
script static void f_ability_timer_update()
//	dprint( "::: f_ability_timer_update :::" );

	// update the timers
	f_ability_timer_update_active();
	f_ability_timer_update_inactive();
	
end
// === f_ability_timer_update_active::: Updates the time equipment active
script static void f_ability_timer_update_active()
//	dprint( "::: f_ability_timer_update_active :::" );

	// check if time needs to be added to active
	if ( L_ability_timer_active_start > 0 ) then
		R_ability_timer_active_time = R_ability_timer_active_time + frames_to_seconds( game_tick_get() - L_ability_timer_active_start );
		L_ability_timer_active_start = game_tick_get();
	end
	
end

// === f_ability_timer_update_inactive::: Updates the time equipment inactive
script static void f_ability_timer_update_inactive()
//	dprint( "::: f_ability_timer_update_inactive :::" );

	// check if time needs to be added to inactive
	if ( L_ability_timer_inactive_start > 0 ) then
		R_ability_timer_inactive_time = R_ability_timer_inactive_time + frames_to_seconds( game_tick_get() - L_ability_timer_inactive_start );
		L_ability_timer_inactive_start = game_tick_get();
	end
	
end

// === f_ability_timer_check_active::: Updates and returns the time equipment used
script static real f_ability_timer_check_active()
//	dprint( "::: f_ability_timer_check_active :::" );

	// update the timer based on current time
	f_ability_timer_update_active();
	
	// RETURN
	R_ability_timer_active_time;
	
end

// === f_ability_timer_check_inactive::: Updates and returns the time equipment used
script static real f_ability_timer_check_inactive()
//	dprint( "::: f_ability_timer_check_inactive :::" );

	// update the timer based on current time
	f_ability_timer_update_inactive();
	
	// RETURN
	R_ability_timer_inactive_time;
	
end

// === f_ability_timer_reset::: Reset the timer of the equipment watch
script static void f_ability_timer_reset()
	dprint( "::: f_ability_timer_reset :::" );

	// reset both
	f_ability_timer_reset_active();
	f_ability_timer_reset_inactive();

end

// === f_ability_timer_reset::: Reset the timer of the equipment watch active
script static void f_ability_timer_reset_active()
	dprint( "::: f_ability_timer_reset :::" );

	if ( L_ability_timer_active_start != 0 ) then
		L_ability_timer_active_start = game_tick_get();
	end
	
	R_ability_timer_active_time = 0.0;

end

// === f_ability_timer_reset_inactive::: Reset the timer of the equipment watch inactive
script static void f_ability_timer_reset_inactive()
	dprint( "::: f_ability_timer_reset_inactive :::" );

	if ( L_ability_timer_inactive_start != 0 ) then
		L_ability_timer_inactive_start = game_tick_get();
	end
	
	R_ability_timer_inactive_time = 0.0;

end

// === f_ability_timer_stop::: Stops the equipment watch
script static void f_ability_timer_stop()

	if ( L_ability_timer_thread != 0 ) then
		dprint( "::: f_ability_timer_stop :::" );

		// kill the thread
		kill_thread( L_ability_timer_thread );

		// update timers
		f_ability_timer_update();

		// set the watch variables to not watching
		R_ability_timer_active_time = 0;
		R_ability_timer_inactive_time = 0;

		// since the thread was killed, reset the variable
		L_ability_timer_thread = 0;
		
		L_ability_timer_enabled_time = game_tick_get() - L_ability_timer_enabled_time;

	end

end

// === f_ability_timer_enabled::: Returns if the activity timer is currently enabled
script static boolean f_ability_timer_enabled()
	L_ability_timer_thread != 0;
end

// === f_ability_timer_enabled_time::: Returns the amount of time in seconds the ability timer has been active, or was active if it's not enabled anymore
script static real f_ability_timer_enabled_time()
	if ( f_ability_timer_enabled() ) then
		frames_to_seconds( game_tick_get() - L_ability_timer_enabled_time );
	else
		frames_to_seconds( L_ability_timer_enabled_time );
	end
end



// -------------------------------------------------------------------------------------------------
// ABILITY CHECK
// -------------------------------------------------------------------------------------------------
script static boolean f_ability_check_players_all( object_definition od_equipment )
// dead players are ignored
	(
		( player_count() > 0 )
		and
		(
			( unit_get_health( Player0() ) <= 0.0 )
			or
			unit_has_equipment( Player0(), od_equipment )
		)
		and
		(
			( unit_get_health( Player1() ) <= 0.0 )
			or
			unit_has_equipment( Player1(), od_equipment )
		)
		and
		(
			( unit_get_health( Player2() ) <= 0.0 )
			or
			unit_has_equipment( Player2(), od_equipment )
		)
		and
		(
			( unit_get_health( Player3() ) <= 0.0 )
			or
			unit_has_equipment( Player3(), od_equipment )
		)
	);

end
