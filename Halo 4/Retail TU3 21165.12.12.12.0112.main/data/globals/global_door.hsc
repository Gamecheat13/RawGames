// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** global door ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
// DEFINES: VARIABLE INDEXES --------------------------------------------------------------------------------------------------------------------------------
static long DEF_VAR_INDEX_R_OPEN_SPEED = 								1;
static long DEF_VAR_INDEX_R_CLOSE_SPEED = 							2;
static long DEF_VAR_INDEX_L_JITTERING = 								3;



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// STARTUP
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === f_init: init function
script startup instanced sys_startup()
	//dprint_door( "sys_startup" );
	device_operates_automatically_set(device(this), FALSE );
	sys_power_auto_enabled_active( FALSE );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ANIMATE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced real R_animate_target_speed = 								-1.0;
instanced real R_animate_target_position = 							-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === animate: XXX
script static instanced boolean animate( real r_speed, real r_position, boolean b_blocking, real r_range_min, real r_range_max )
local long l_thread = thread( sys_animate(r_speed, r_position, r_range_min, r_range_max) );
	if ( b_blocking ) then
		sleep_until( not isthreadvalid(l_thread), 1 );
	end
end
script static instanced boolean animate( real r_speed, real r_position, boolean b_blocking )
	//dprint_door( "animate: BLOCKING" );
	animate( r_speed, r_position, b_blocking, r_position, r_position );
end
script static instanced boolean animate( real r_speed, real r_position )
	//dprint_door( "animate: DEFAULT" );
	animate( r_speed, r_position, TRUE );
end

// === animate_target_position: XXX
script static instanced void animate_target_position( real r_position )
	//dprint_door( "animate_target_position: SET" );
	R_animate_target_position = r_position;
end
script static instanced real animate_target_position()
	R_animate_target_position;
end

// === animate_target_speed: XXX
script static instanced void animate_target_speed( real r_speed ) 
	//dprint_door( "animate_target_speed: SET" );
	R_animate_target_speed = r_speed;
end
script static instanced real animate_target_speed()
	R_animate_target_speed;
end

// === animate_target_speed: XXX
script static instanced boolean animate_active( real r_speed, real r_position )
	( animate_target_position() == r_position ) and ( animate_target_speed() == r_speed );
end
script static instanced boolean animate_active()
	( animate_target_position() >= 0.0 ) and ( animate_target_speed() >= 0.0 );
end

// === animate_target_speed: XXX
script static instanced boolean animate_not_active( real r_speed, real r_position )
	not animate_active( r_speed, r_position );
end
script static instanced boolean animate_not_active()
	not animate_active();
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_animate_target_start: XXX
script static instanced void sys_animate_start( real r_speed, real r_position )

	sys_power_auto_enabled_start( r_speed, r_position );
	sys_sound_start( r_speed, r_position );
	sys_interaction_lock_start( r_speed, r_position );
	sys_zoneset_auto_start( r_speed, r_position );

end

// === sys_animate_target_start: XXX
script static instanced void sys_animate_stop( real r_speed, real r_position )

	if ( position() != r_position ) then
		sleep_until( (position() == r_position) or ((animate_target_position() != r_position) and (animate_target_position() != -1)), 1 );
	end
	
	// shutdown
	sys_power_auto_enabled_stop( r_speed, r_position );
	sys_sound_stop( r_speed, r_position );
	//sys_interaction_lock_stop( r_speed, r_position );
	//sys_zoneset_auto_stop( r_speed, r_position );

	// shutdown target
	sys_animate_target_stop( r_speed, r_position );

end

// === sys_animate_target_start: XXX
script static instanced void sys_animate_target_start( real r_speed, real r_position )
	//dprint_door( "sys_animate_target_start" );

	sys_animate_target_setup( r_speed, r_position );

end

// === animate_target_position: XXX
script static instanced void sys_animate_target_stop( real r_speed, real r_position )
	//dprint_door( "sys_animate_target_stop" );

	if ( animate_active(r_speed, r_position) ) then
		sys_animate_target_reset();
	end

end

// === animate_target: XXX
script static instanced void sys_animate_target_setup( real r_speed, real r_position )
	//dprint_door( "sys_animate_target_setup" );

	animate_target_position( r_position );
	animate_target_speed( r_speed );

end

// === sys_animate_target_reset: XXX
script static instanced void sys_animate_target_reset()
	//dprint_door( "sys_animate_target_reset" );
	sys_animate_target_position_reset();
	sys_animate_target_speed_reset();
end

// === sys_animate_target_position_reset: XXX
script static instanced void sys_animate_target_position_reset()
	//dprint_door( "sys_animate_target_position_reset" );

	animate_target_position( -1.0 );

end

// === sys_animate_target_speed_reset: XXX
script static instanced void sys_animate_target_speed_reset()
	//dprint_door( "sys_animate_target_speed_reset" );

	animate_target_speed( -1.0 );

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static instanced boolean sys_animate( real r_speed, real r_position, real r_range_min, real r_range_max )

	//dprint_door( "sys_animate" );
	
	// clamp
	r_position = position_bound( r_position );
	if ( r_speed < 0.0 ) then
		r_speed = 0.0;
	end

	// make sure animation is not already moving to this target
	if ( animate_not_active(r_speed, r_position) ) then

		// set targets
		sys_animate_target_start( r_speed, r_position );

		// if the door is already at the target position, do nothing
		if ( position() != r_position ) then

			// startup
			sys_animate_start( r_speed, r_position );

			// animate			 
			if ( animate_active(r_speed, r_position) ) then
				device_animate_position_relative( this, r_position, r_speed, blend_in(), blend_out(), TRUE );
			end
			
		else
			device_animate_position( this, r_position, 0.0, 0.0, 0.0, FALSE );
		end
		
	end

	// wait for animation to finish
	if ( animate_target_position() == r_position ) then
		sleep_until( range_check(position(),r_range_min,r_range_max) or (animate_target_position() != r_position), 1 );
	end
	
	// shutdown
	if ( animate_active(r_speed, r_position) ) then
		if ( position() == r_position ) then
			sys_animate_stop( r_speed, r_position );
		else
			thread( sys_animate_stop(r_speed, r_position) );
		end
	end
	
	// RETURN
	(position() == r_position) or (animate_target_position() == r_position);
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ANIMATE: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === open::: XXX
script static instanced boolean open( real r_speed, boolean b_wait )
	//dprint_door( "open: SPEED: WAIT" );
	if ( r_speed < 0.0 ) then
		r_speed = speed_open();
	end
	animate( r_speed, position_open(), b_wait, position_open_start(), position_open() );
end 
script static instanced boolean open( real r_speed )
	//dprint_door( "open: SPEED" );
	open( r_speed, TRUE );
end 
script static instanced boolean open()
	//dprint_door( "open: DEFAULT" );
	open( speed_open(), TRUE );
end 

// === open_very_fast::: XXX
script static instanced boolean open_very_fast( boolean b_wait )
	//dprint_door( "open_fast: WAIT" );
	open( speed_very_fast(), b_wait );
end 
script static instanced boolean open_very_fast()
	//dprint_door( "open_fast" );
	open( speed_very_fast() );
end 

// === open_fast::: XXX
script static instanced boolean open_fast( boolean b_wait )
	//dprint_door( "open_fast: WAIT" );
	open( speed_fast(), b_wait );
end 
script static instanced boolean open_fast()
	//dprint_door( "open_fast" );
	open( speed_fast(), TRUE );
end 

// === open_default::: XXX
script static instanced boolean open_default( boolean b_wait )
	//dprint_door( "open_default: WAIT" );
	open( speed_default(), b_wait );
end 
script static instanced boolean open_default()
	//dprint_door( "open_default" );
	open( speed_default() );
end 

// === open_slow::: XXX
script static instanced boolean open_slow( boolean b_wait )
	//dprint_door( "open_slow: WAIT" );
	open( speed_slow(), b_wait );
end 
script static instanced boolean open_slow()
	//dprint_door( "open_slow" );
	open( speed_slow() );
end 

// === open_very_slow::: XXX
script static instanced boolean open_very_slow( boolean b_wait )
	//dprint_door( "open_very_slow: WAIT" );
	open( speed_very_slow(), b_wait );
end 
script static instanced boolean open_very_slow()
	//dprint_door( "open_very_slow" );
	open( speed_very_slow() );
end 

// === open_instant::: XXX
script static instanced boolean open_instant()
	//dprint_door( "open_instant" );
	animate( 0.0, position_open(), TRUE );
end

// === open_instant_zoneset::: XXX
script static instanced boolean open_instant_zoneset( long l_zoneset_min, long l_zoneset_max )
	sleep_until( zoneset_range(zoneset_current(), l_zoneset_min, l_zoneset_max), 1 );
	//dprint_door( "open_instant_zoneset" );
	open_instant();
end 

// === open_immediate::: XXX
script static instanced boolean open_immediate()
	//dprint_door( "open_immediate" );
	if ( position_open_check(position(),FALSE) ) then
		animate( 0.0, position_open_start(), TRUE );
	end
	open();
end 

// === open_immediate_zoneset::: XXX
script static instanced boolean open_immediate_zoneset( long l_zoneset_min, long l_zoneset_max )
	sleep_until( zoneset_range(zoneset_current(), l_zoneset_min, l_zoneset_max), 1 );
	//dprint_door( "open_immediate_zoneset" );
	open_immediate();
end 

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced boolean open_speed( real r_speed )
	open( r_speed );
end 



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ANIMATE: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === close::: XXX
script static instanced boolean close( real r_speed, boolean b_wait )
	//dprint_door( "close: SPEED: WAIT" );
	if ( r_speed < 0.0 ) then
		r_speed = speed_close();
	end
	animate( r_speed, position_close(), b_wait, position_close_start(), position_close() );
end 
script static instanced boolean close( real r_speed )
	//dprint_door( "close: SPEED" );
	close( r_speed, TRUE );
end 
script static instanced boolean close()
	//dprint_door( "close: DEFAULT" );
	close( speed_close(), TRUE );
end 

// === close_very_fast::: XXX
script static instanced boolean close_very_fast( boolean b_wait )
	//dprint_door( "close_fast: WAIT" );
	close( speed_very_fast(), b_wait );
end 
script static instanced boolean close_very_fast()
	//dprint_door( "close_fast" );
	close( speed_very_fast() );
end 

// === close_fast::: XXX
script static instanced boolean close_fast( boolean b_wait )
	//dprint_door( "close_fast: WAIT" );
	close( speed_fast(), b_wait );
end 
script static instanced boolean close_fast()
	//dprint_door( "close_fast" );
	close( speed_fast(), TRUE );
end 

// === close_default::: XXX
script static instanced boolean close_default( boolean b_wait )
	//dprint_door( "close_default: WAIT" );
	close( speed_default(), b_wait );
end 
script static instanced boolean close_default()
	//dprint_door( "close_default" );
	close( speed_default() );
end 

// === close_slow::: XXX
script static instanced boolean close_slow( boolean b_wait )
	//dprint_door( "close_slow: WAIT" );
	close( speed_slow(), b_wait );
end 
script static instanced boolean close_slow()
	//dprint_door( "close_slow" );
	close( speed_slow() );
end 

// === close_very_slow::: XXX
script static instanced boolean close_very_slow( boolean b_wait )
	//dprint_door( "close_very_slow: WAIT" );
	close( speed_very_slow(), b_wait );
end 
script static instanced boolean close_very_slow()
	//dprint_door( "close_very_slow" );
	close( speed_very_slow() );
end 

// === close_instant::: XXX
script static instanced boolean close_instant()
	//dprint_door( "close_instant" );
	animate( 0.0, position_close(), TRUE );
end

// === close_instant_zoneset::: XXX
script static instanced boolean close_instant_zoneset( long l_zoneset_min, long l_zoneset_max )
	sleep_until( zoneset_range(zoneset_current(), l_zoneset_min, l_zoneset_max), 1 );
	//dprint_door( "close_instant_zoneset" );
	close_instant();
end 

// === close_immediate::: XXX
script static instanced boolean close_immediate()
	//dprint_door( "close_immediate" );
	if ( position_close_check(position(),FALSE) ) then
		animate( 0.0, position_close_start(), TRUE );
	end
	close();
end 

// === close_immediate_zoneset::: XXX
script static instanced boolean close_immediate_zoneset( long l_zoneset_min, long l_zoneset_max )
	sleep_until( zoneset_range(zoneset_current(), l_zoneset_min, l_zoneset_max), 1 );
	//dprint_door( "close_immediate_zoneset" );
	close_immediate();
end 

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced boolean close_speed( real r_speed )
	close( r_speed );
end 
script static instanced boolean close_speed_wait( real r_speed, boolean b_wait )
	close( r_speed, b_wait );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ANIMATE: STOP
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === stop::: XXX
script static instanced boolean stop( real r_time )
	//dprint_door( "stop: TIME" );
	sleep_s( r_time );
	stop();
end
script static instanced boolean stop()
	//dprint_door( "stop" );
	animate( 0.0, position(), TRUE );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// POSITION
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === position::: XXX
script static instanced real position()
	device_get_position( this );
end

// === position_bound::: XXX
script static instanced real position_bound( real r_position )
	bound_r( r_position, position_close(), position_open() );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// POSITION: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_position_open_start = 										1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === position_open::: XXX
script static void position_open( real r_position ) 									// SET
	breakpoint( "position_open: IS NOT MODIFIABLE" );
	sleep( 1 );
end
script static real position_open() 																		// GET
	1.0;
end

// === position_open_start::: XXX
script static instanced void position_open_start( real r_position ) 	// SET
	//dprint_door( "position_open_start: SET" );
	R_position_open_start = position_bound( r_position );
end
script static real position_open_start()															// GET
	R_position_open_start;
end

// === position_open_check::: XXX
script static boolean position_open_check( real r_position, boolean b_condition )
	( range_check(r_position, position_open_start(), position_open()) == b_condition);
end
script static instanced boolean position_open_check( real r_position )
	position_open_check( r_position, TRUE );
end
script static instanced boolean position_open_check()
	position_open_check( position(), TRUE );
end

// === position_not_open_check::: XXX
script static instanced boolean position_not_open_check( real r_position )
	position_open_check( r_position, FALSE );
end
script static instanced boolean position_not_open_check()
	position_open_check( position(), FALSE );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static real open_position()
	position_open();
end
script static instanced boolean check_open()
	position_open_check();
end
script static instanced boolean check_not_open()
	position_not_open_check();
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// POSITION: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_position_close_start = 										0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === position_close::: XXX
script static void position_close( real r_position ) 									// SET
	breakpoint( "position_close: IS NOT MODIFIABLE" );
	sleep( 1 );
end
script static real position_close() 																	// GET
	0.0;
end

// === position_close_start::: XXX
script static instanced void position_close_start( real r_position ) 	// SET
	//dprint_door( "position_close_start: SET" );
	R_position_close_start = position_bound( r_position );
end
script static real position_close_start()															// GET
	R_position_close_start;
end

// === position_close_check::: XXX
script static boolean position_close_check( real r_position, boolean b_condition )
	( range_check(r_position, position_close(), position_close_start()) == b_condition);
end
script static boolean position_close_check( real r_position )
	position_close_check( r_position, TRUE );
end
script static instanced boolean position_close_check()
	position_close_check( position() );
end

// === position_not_close_check::: XXX
script static instanced boolean position_not_close_check( real r_position )
	position_close_check( r_position, FALSE );
end
script static instanced boolean position_not_close_check()
	position_close_check( position(), FALSE );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static real close_position()
	position_close();
end
script static instanced boolean check_close()
	position_close_check();
end
script static instanced boolean check_not_close()
	position_not_close_check();
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DIRECTION
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === direction_open::: XXX
script static instanced boolean direction_open( real r_position )
	r_position > position();
end
script static instanced boolean direction_open()
	direction_open( animate_target_position() );
end

// === direction_close::: XXX
script static instanced boolean direction_close( real r_position )
	r_position < position();
end
script static instanced boolean direction_close()
	direction_close( animate_target_position() );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SPEEDS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === speed_setup::: XXX
script static instanced void speed_setup( real r_speed )
	//dprint_door( "speed_setup: SINGLE" );
	speed_setup( r_speed, r_speed );
end
script static instanced void speed_setup( real r_speed_open, real r_speed_close )
	//dprint_door( "speed_setup: ALL" );
	speed_open( r_speed_open );
	speed_close( r_speed_close );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void speed_set( real r_speed )
	speed_setup( r_speed );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SPEEDS: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === speed_open::: XXX
script static instanced void speed_open( real r_speed )			// SET
	//dprint_door( "speed_open: SET" );
	SetObjectRealVariable( this, DEF_VAR_INDEX_R_OPEN_SPEED, r_speed );
end
script static instanced real speed_open()										// GET
	GetObjectRealVariable( this, DEF_VAR_INDEX_R_OPEN_SPEED );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void speed_set_open( real r_speed )
	speed_open( r_speed );
end
script static instanced real speed_get_open()
	speed_open();
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SPEEDS: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === speed_close::: XXX
script static instanced void speed_close( real r_speed )			// SET
	//dprint_door( "speed_close: SET" );
	SetObjectRealVariable( this, DEF_VAR_INDEX_R_CLOSE_SPEED, r_speed );
end
script static instanced real speed_close()										// GET
	GetObjectRealVariable( this, DEF_VAR_INDEX_R_CLOSE_SPEED );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void speed_set_close( real r_speed )
	speed_close( r_speed );
end
script static instanced real speed_get_close()
	speed_close();
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SPEEDS: DEFAULTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real DEF_SPEED_VERY_FAST = 											1.25;
global real DEF_SPEED_FAST = 														2.5;
global real DEF_SPEED_DEFAULT = 												4.0;
global real DEF_SPEED_SLOW = 														5.5; 
global real DEF_SPEED_VERY_SLOW = 											6.75;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === speed_very_fast::: XXX
script static instanced void speed_very_fast( real r_speed )	// SET
	//dprint_door( "speed_very_fast: SET" );
	DEF_SPEED_VERY_FAST = r_speed;
end
script static real speed_very_fast()													// GET
	DEF_SPEED_VERY_FAST;
end

// === speed_fast::: XXX
script static instanced void speed_fast( real r_speed )				// SET
	//dprint_door( "speed_fast: SET" );
	DEF_SPEED_FAST = r_speed;
end
script static real speed_fast()																// GET
	DEF_SPEED_FAST;
end

// === speed_default::: XXX
script static instanced void speed_default( real r_speed )		// SET
	//dprint_door( "speed_default: SET" );
	DEF_SPEED_DEFAULT = r_speed;
end
script static real speed_default()														// GET
	DEF_SPEED_DEFAULT;
end

// === speed_slow::: XXX
script static instanced void speed_slow( real r_speed )				// SET
	//dprint_door( "speed_slow: SET" );
	DEF_SPEED_SLOW = r_speed;
end
script static real speed_slow()																// GET
	DEF_SPEED_slow;
end

// === speed_very_slow::: XXX
script static instanced void speed_very_slow( real r_speed )	// SET
	//dprint_door( "speed_very_slow: SET" );
	DEF_SPEED_VERY_SLOW = r_speed;
end
script static real speed_very_slow()													// GET
	DEF_SPEED_VERY_SLOW;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// BLEND
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced real R_blend_time_in = 												0.125;
instanced real R_blend_time_out = 											0.125;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === blend_setup::: XXX
script static instanced void blend_setup( real r_time_in, real r_time_out )
	//dprint_door( "blend_setup: ALL" );
	blend_in( r_time_in );
	blend_out( r_time_out );
end
script static instanced void blend_setup( real r_time )
	//dprint_door( "blend_setup: SINGLE" );
	blend_setup( r_time, r_time );
end

// === blend_in::: XXX
script static instanced void blend_in( real r_time )					// SET
	//dprint_door( "blend_in: SET" );
	R_blend_time_in = r_time;
end
script static instanced real blend_in()												// GET
	R_blend_time_in;
end

// === blend_out::: XXX
script static instanced void blend_out( real r_time )					// SET
	//dprint_door( "blend_out: SET" );
	R_blend_time_out = r_time;
end
script static instanced real blend_out()											// GET
	R_blend_time_out;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// POWER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced boolean B_power_auto_enabled = 													TRUE;
static real R_power_active_on = 													1.0;
static real R_power_active_off = 													0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === power_active: XXX
script static instanced void power_active( boolean b_power )						// SET
	//dprint_door( "power_active: SET" );

	if ( b_power ) then
		device_set_power( this, R_power_active_on );
	else
		device_set_power( this, R_power_active_off );
	end
	
end
script static instanced boolean power_active()													// GET
	device_get_power(this) == R_power_active_on;
end

// === power_auto_enabled: XXX
script static instanced boolean power_auto_enabled()										// GET
	B_power_auto_enabled;
end
script static instanced void power_auto_enabled( boolean b_enabled )		// SET
	//dprint_door( "power_auto_enabled: SET" );
	B_power_auto_enabled = b_enabled;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_power_auto_enabled_start: XXX
script static instanced void sys_power_auto_enabled_start( real r_speed, real r_position )
	//dprint_door( "sys_power_auto_enabled_start" );

	if ( animate_active(r_speed, r_position) ) then
		sys_power_auto_enabled_active( TRUE );
	end
	
end

// === sys_power_auto_enabled_stop: XXX
script static instanced void sys_power_auto_enabled_stop( real r_speed, real r_position )
	//dprint_door( "sys_power_auto_enabled_stop" );

	if ( animate_active(r_speed, r_position) ) then
		sys_power_auto_enabled_active( FALSE );
	end
	
end

// === sys_power_auto_enabled_active: XXX
script static instanced void sys_power_auto_enabled_active( boolean b_power )
	//dprint_door( "sys_power_auto_enabled_active" );

	if ( power_auto_enabled() ) then
		power_active( b_power );
	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ZONESET AUTO
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced long L_zoneset_auto = 																-1;
instanced boolean b_zoneset_auto_prepare = 											FALSE;
instanced boolean b_zoneset_auto_load = 												FALSE;
instanced long L_zoneset_auto_zoneset_range_min = 							-1;
instanced long L_zoneset_auto_zoneset_range_max = 							-1;
instanced real R_zoneset_auto_position_range_min = 							0.0;
instanced real R_zoneset_auto_position_range_max = 							1.0;
instanced boolean B_zoneset_auto_disable = 											TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === zoneset_setup: XXX
script static instanced void zoneset_setup( long l_zoneset, boolean b_prepare, boolean b_load, long l_zoneset_range_min, long l_zoneset_range_max, real r_position_range_min, real r_position_range_max, boolean b_disable )
	//dprint_door( "zoneset_setup" );

	zoneset_auto( l_zoneset );
	zoneset_auto_prepare( b_prepare );
	zoneset_auto_load( b_load );
	zoneset_auto_zoneset_range_setup( l_zoneset_range_min, l_zoneset_range_max );
	zoneset_auto_position_range_setup( r_position_range_min, r_position_range_max );
	zoneset_auto_disable( b_disable );

end

// === zoneset_auto_open_setup: XXX
script static instanced void zoneset_auto_open_setup( long l_zoneset, boolean b_prepare, boolean b_load, long l_zoneset_range_min, long l_zoneset_range_max, boolean b_disable )
	//dprint_door( "zoneset_auto_open_setup" );
	zoneset_setup( l_zoneset, b_prepare, b_load, l_zoneset_range_min, l_zoneset_range_max, position_close_start(), position_open(), b_disable );
end

// === zoneset_auto_close_setup: XXX
script static instanced void zoneset_auto_close_setup( long l_zoneset, boolean b_prepare, boolean b_load, long l_zoneset_range_min, long l_zoneset_range_max, boolean b_disable )
	//dprint_door( "zoneset_auto_close_setup" );
	zoneset_setup( l_zoneset, b_prepare, b_load, l_zoneset_range_min, l_zoneset_range_max, position_close(), position_close_start(), b_disable );
end

// === zoneset_auto: XXX
script static instanced void zoneset_auto( long l_zoneset )														// SET
	//dprint_door( "zoneset_auto: SET" );
	L_zoneset_auto = l_zoneset;
end
script static instanced long zoneset_auto()																						// GET
	L_zoneset_auto;
end

// === zoneset_auto_valid: XXX
script static instanced boolean zoneset_auto_valid()
	( zoneset_auto() > 0 ) and ( zoneset_auto() != zoneset_current_active() );
end

// === zoneset_auto_prepare: XXX
script static instanced void zoneset_auto_prepare( boolean b_enabled )								// SET
	//dprint_door( "zoneset_auto_prepare: SET" );
	b_zoneset_auto_prepare = b_enabled;
end
script static instanced boolean zoneset_auto_prepare()																// GET
	b_zoneset_auto_prepare;
end

// === zoneset_auto_load: XXX
script static instanced void zoneset_auto_load( boolean b_enabled )										// SET
	//dprint_door( "zoneset_auto_load: SET" );
	b_zoneset_auto_load = b_enabled;
end
script static instanced boolean zoneset_auto_load()																		// GET
	b_zoneset_auto_load;
end

// === zoneset_auto_zoneset_range_setup: XXX
script static instanced void zoneset_auto_zoneset_range_setup( long l_zoneset_range_min, long l_zoneset_range_max )
	//dprint_door( "zoneset_auto_zoneset_range_setup" );
	if ( l_zoneset_range_min <= l_zoneset_range_max ) then
		zoneset_auto_zoneset_range_min( l_zoneset_range_min );
		zoneset_auto_zoneset_range_max( l_zoneset_range_max );
	else
		zoneset_auto_zoneset_range_setup( l_zoneset_range_max, l_zoneset_range_min );
	end
end

// === zoneset_auto_zoneset_range_min: XXX
script static instanced void zoneset_auto_zoneset_range_min( long l_zoneset )					// SET
	//dprint_door( "zoneset_auto_zoneset_range_min: SET" );
	L_zoneset_auto_zoneset_range_min = l_zoneset;
end
script static instanced long zoneset_auto_zoneset_range_min()													// GET
	L_zoneset_auto_zoneset_range_min;
end

// === zoneset_auto_zoneset_range_max: XXX
script static instanced void zoneset_auto_zoneset_range_max( long l_zoneset )					// SET
	//dprint_door( "zoneset_auto_zoneset_range_max: SET" );
	L_zoneset_auto_zoneset_range_max = l_zoneset;
end
script static instanced long zoneset_auto_zoneset_range_max()													// GET
	L_zoneset_auto_zoneset_range_max;
end

// === zoneset_auto_zoneset_range: XXX
script static instanced boolean zoneset_auto_zoneset_range( long l_zoneset )
	( zoneset_auto() == zoneset_current() )	or zoneset_range( l_zoneset, zoneset_auto_zoneset_range_min(), zoneset_auto_zoneset_range_max() );
end
script static instanced boolean zoneset_auto_zoneset_range()
	zoneset_auto_zoneset_range( zoneset_current() );
end

// === zoneset_auto_position_range_setup: XXX
script static instanced void zoneset_auto_position_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "zoneset_auto_position_range_setup: ALL" );

	if ( r_position_min <= r_position_max ) then
		zoneset_auto_position_range_min( r_position_min );
		zoneset_auto_position_range_max( r_position_max );
	else
		zoneset_auto_position_range_setup( r_position_max, r_position_min );
	end
	
end
script static instanced void zoneset_auto_position_range_setup( real r_position )
	//dprint_door( "zoneset_auto_position_range_setup: SINGLE" );
	zoneset_auto_position_range_setup( r_position, r_position );
end

// === zoneset_auto_position_range_min: XXX
script static instanced void zoneset_auto_position_range_min( real r_position )				// SET
	//dprint_door( "zoneset_auto_position_range_min: SET" );
	
	// DEFAULTS
	if ( r_position < 0.0 ) then
		r_position = position_close();
	end

	R_zoneset_auto_position_range_min = r_position;
	
end
script static instanced real zoneset_auto_position_range_min()												// GET
	R_zoneset_auto_position_range_min;
end

// === zoneset_auto_position_range_max: XXX
script static instanced void zoneset_auto_position_range_max( real r_position )				// SET
	//dprint_door( "zoneset_auto_position_range_max: SET" );
	
	// DEFAULTS
	if ( r_position < 0.0 ) then
		r_position = position_open();
	end

	R_zoneset_auto_position_range_max = r_position;

end
script static instanced real zoneset_auto_position_range_max()												// GET
	R_zoneset_auto_position_range_max;
end

// === zoneset_position_range: XXX
script static instanced boolean zoneset_position_range( real r_position )
	range_check( r_position, zoneset_auto_position_range_min(), zoneset_auto_position_range_max() );
end
script static instanced boolean zoneset_position_range()
	zoneset_position_range( position() );
end

// === zoneset_auto_disable: XXX
script static instanced void zoneset_auto_disable( boolean b_disable )								// SET
	//dprint_door( "zoneset_auto_disable: SET" );
	B_zoneset_auto_disable = b_disable;
end
script static instanced boolean zoneset_auto_disable()																// GET
	B_zoneset_auto_disable;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_zoneset_auto_start: XXX
script static instanced void sys_zoneset_auto_start( real r_speed, real r_position )
//dprint_door( "sys_zoneset_auto_start" );

	// Check zoneset switch valid
	if ( animate_active(r_speed, r_position) and sys_zoneset_auto_valid(r_speed, r_position) ) then
	
		if ( position_close_check() ) then
			sys_zoneset_auto_switch( r_speed, r_position );
		else
			thread( sys_zoneset_auto_switch(r_speed, r_position) );
		end

	end
	
end

// === sys_zoneset_auto_stop: XXX
//script static instanced void sys_zoneset_auto_stop( real r_speed, real r_position )
	//dprint_door( "sys_zoneset_auto_stop" );

	/*
	if ( animate_active(r_speed, r_position) ) then
	end
	*/
	
//end

// === sys_zoneset_auto_valid: XXX
script static instanced boolean sys_zoneset_auto_valid( real r_speed, real r_position )
	(animate_active(r_speed, r_position) or (position() == r_position)) and ( (zoneset_auto_prepare() or zoneset_auto_load()) and zoneset_auto_valid() and zoneset_position_range(r_position) and zoneset_auto_zoneset_range() );
end

// === sys_zoneset_auto_switch: XXX
script static instanced void sys_zoneset_auto_switch( real r_speed, real r_position )
	//dprint_door( "sys_zoneset_auto_switch" );

	// wait for close position
	if ( not position_close_check() ) then
		sleep_until( position_close_check() or (not sys_zoneset_auto_valid(r_speed, r_position)), 1 );
	end

	// prepare
	if ( sys_zoneset_auto_valid(r_speed, r_position) and zoneset_auto_prepare() ) then

		// pre-animation
		if ( not position_close_check(r_position) ) then
			device_animate_position_relative( this, position_close_start(), r_speed, blend_in(), blend_out(), TRUE );
		end

		// zoneset prepare
		zoneset_prepare( zoneset_auto() );

		// wait for prepare to finish
		if ( zoneset_auto_load() ) then
			sleep_until( (zoneset_auto() != zoneset_preparing_index()) or (not zoneset_auto_load()), 1 );
			sleep( 1 );
		elseif ( zoneset_auto_disable() ) then
			zoneset_auto_prepare( FALSE );
		end
	
	end

	// load
	if ( sys_zoneset_auto_valid(r_speed, r_position) and zoneset_auto_load() ) then

		// check auto disable
		if ( zoneset_auto_disable() ) then
			zoneset_auto_prepare( FALSE );
			zoneset_auto_load( FALSE );
		end

		// zoneset load
		zoneset_load( zoneset_auto() );
	
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced sound SND_sound_impulse = 											NONE;

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_start: XXX
script static instanced void sys_sound_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_start" );

	if ( animate_active(r_speed, r_position) and (r_speed > 0.0) ) then
	
	
		if ( direction_open(r_position) ) then
		
			sys_sound_engage_open_start( r_speed, r_position );
			sys_sound_loop_open_start( r_speed, r_position );
			sys_sound_disengage_open_start( r_speed, r_position );
			
		end
		
		if ( direction_close(r_position) ) then
		
			sys_sound_engage_close_start( r_speed, r_position );
			sys_sound_loop_close_start( r_speed, r_position );
			sys_sound_disengage_close_start( r_speed, r_position );
			
		end
		
	end
	
end

// === sys_sound_stop: XXX
script static instanced void sys_sound_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_stop" );

	if ( animate_active(r_speed, r_position) ) then
	
		if ( direction_open(r_position) ) then
		
			sys_sound_engage_open_stop( r_speed, r_position );
			sys_sound_loop_open_stop( r_speed, r_position );
			//sys_sound_disengage_open_stop( r_speed, r_position );
			
		end
		
		if ( direction_close(r_position) ) then
		
			sys_sound_engage_close_stop( r_speed, r_position );
			sys_sound_loop_close_stop( r_speed, r_position );
			//sys_sound_disengage_close_stop( r_speed, r_position );
			
		end
		
	end
	
end

// === sys_sound_impulse_start: XXX
script static instanced long sys_sound_impulse_start( sound snd_sound, real r_position_min, real r_position_max )
local long l_thread = 0;
	//dprint_door( "sys_sound_impulse_start" );

	if ( snd_sound != NONE ) then
		//dprint_door( "sys_sound_impulse_start: SOUND GOOD" );

		// play the sound		
		if ( range_check(position(), r_position_min, r_position_max) ) then
			//dprint_door( "sys_sound_impulse_start: IN POSITION" );
			sys_sound_impulse_play( snd_sound );
		else
			//dprint_door( "sys_sound_impulse_start: WATCH" );
			l_thread = thread( sys_sound_impulse_watch(snd_sound, r_position_min, r_position_max) );
		end

	end
	
	// RETURN
	l_thread;

end

// === sys_sound_impulse_play: XXX
script static instanced void sys_sound_impulse_play( sound snd_sound )
	//dprint_door( "sys_sound_impulse_play" );

	// stop prior sound
	if ( SND_sound_impulse != NONE ) then
		sound_impulse_stop( SND_sound_impulse );
		SND_sound_impulse = NONE;
	end

	// store the sound
	SND_sound_impulse = snd_sound;

	// play the sound
	sound_impulse_start( snd_sound, this, 1 );

end

// === sys_sound_impulse_watch: XXX
script static instanced void sys_sound_impulse_watch( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_impulse_watch" );

	sleep_until( range_check(position(), r_position_min, r_position_max) or (animate_not_active()), 1 );
	if ( range_check(position(), r_position_min, r_position_max) ) then
		sys_sound_impulse_play( snd_sound );
	end

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: ENGAGE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced long L_sound_engage_thread =												0;

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_engage_start: XXX
script static instanced void sys_sound_engage_start( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_engage_start" );

	// reset the sound
	sys_sound_engage_reset();

	// play the new sound
	L_sound_engage_thread = sys_sound_impulse_start( snd_sound, r_position_min, r_position_max );
	
end

// === sys_sound_engage_stop: XXX
script static instanced void sys_sound_engage_stop( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_engage_stop" );

	// reset the sound
	sys_sound_engage_reset();

end

// === sys_sound_engage_reset: XXX
script static instanced void sys_sound_engage_reset()
	//dprint_door( "sys_sound_engage_reset" );

	// kill the old sound thread
	kill_thread( L_sound_engage_thread );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: ENGAGE: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static sound SND_sound_engage_open = 											NONE;
static real R_sound_engage_open_range_min =								0.0;
static real R_sound_engage_open_range_max =								0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_engage_open_setup: XXX
script static instanced void sound_engage_open_setup( sound snd_sound )
	//dprint_door( "sound_engage_open_setup: DEFAULTS" );
	sound_engage_open_setup( snd_sound, position_close(), position_close_start() );
end
script static instanced void sound_engage_open_setup( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_engage_open_setup: POSITIONS" );
	sound_engage_open( snd_sound );
	sound_engage_open_range_setup( r_position_min, r_position_max );
end

// === sound_engage_open: XXX
script static instanced sound sound_engage_open()
	SND_sound_engage_open;
end
script static instanced void sound_engage_open( sound snd_sound )
	//dprint_door( "sound_engage_open: SET" );
	SND_sound_engage_open = snd_sound;
end

// === sound_engage_open_play_start: XXX
script static instanced void sound_engage_open_play_start()
	//dprint_door( "sound_engage_open_play_start" );
	sound_impulse_start( sound_engage_open(), this, 1 );
end

// === sound_engage_open_play_stop: XXX
script static instanced void sound_engage_open_play_stop()
	//dprint_door( "sound_engage_open_play_stop" );
	sound_impulse_stop( sound_engage_open() );
end

// === sound_engage_open_range_setup: XXX
script static instanced void sound_engage_open_range_setup()
	//dprint_door( "sound_engage_open_range_setup: DEFAULTS" );
	sound_engage_open_range_setup( position_close(), position_close_start() );
end
script static instanced void sound_engage_open_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_engage_open_range_setup: POSITIONS" );
	
	if ( r_position_min <= r_position_max ) then
		sound_engage_open_range_min( r_position_min );
		sound_engage_open_range_max( r_position_max );
	else
		sound_engage_open_range_setup( r_position_max, r_position_min );
	end
	
end

// === sound_engage_open_range: XXX
script static instanced void sound_engage_open_range( real r_position )
	range_check( r_position, sound_engage_open_range_min(), sound_engage_open_range_max() );
end
script static instanced void sound_engage_open_range()
	sound_engage_open_range( position() );
end

// === sound_engage_open_range_min: XXX
script static instanced real sound_engage_open_range_min()
	R_sound_engage_open_range_min;
end
script static instanced void sound_engage_open_range_min( real r_position_min )
	//dprint_door( "sound_engage_open_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_open_start();
	end
	R_sound_engage_open_range_min = bound_r( r_position_min, position_close(), position_open() );
	
end

// === sound_engage_open_range_max: XXX
script static instanced real sound_engage_open_range_max()
	R_sound_engage_open_range_max;
end
script static instanced void sound_engage_open_range_max( real r_position_max )
	//dprint_door( "sound_engage_open_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_open();
	end
	R_sound_engage_open_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_engage_open_start: XXX
script static instanced void sys_sound_engage_open_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_engage_open_start" );
	sys_sound_engage_start( sound_engage_open(), sound_engage_open_range_min(), sound_engage_open_range_max() );
end

// === sys_sound_engage_open_stop: XXX
script static instanced void sys_sound_engage_open_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_engage_open_stop" );
	sys_sound_engage_stop( sound_engage_open(), sound_engage_open_range_min(), sound_engage_open_range_max() );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_open_set( sound snd_sound )
	sound_engage_open_setup( snd_sound );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: ENGAGE: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static sound SND_sound_engage_close = 											NONE;
static real R_sound_engage_close_range_min =								1.0;
static real R_sound_engage_close_range_max =								1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_engage_close_setup: XXX
script static instanced void sound_engage_close_setup( sound snd_sound )
	//dprint_door( "sound_engage_close_setup: DEFAULTS" );
	sound_engage_close_setup( snd_sound, position_open_start(), position_open() );
end
script static instanced void sound_engage_close_setup( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_engage_close_setup: POSITIONS" );
	sound_engage_close( snd_sound );
	sound_engage_close_range_setup( r_position_min, r_position_max );
end

// === sound_engage_close: XXX
script static instanced sound sound_engage_close()
	SND_sound_engage_close;
end
script static instanced void sound_engage_close( sound snd_sound )
	//dprint_door( "sound_engage_close" );
	SND_sound_engage_close = snd_sound;
end

// === sound_engage_close_play_start: XXX
script static instanced void sound_engage_close_play_start()
	//dprint_door( "sound_engage_close_play_start" );
	sound_impulse_start( sound_engage_close(), this, 1 );
end

// === sound_engage_close_play_stop: XXX
script static instanced void sound_engage_close_play_stop()
	//dprint_door( "sound_engage_close_play_stop" );
	sound_impulse_stop( sound_engage_close() );
end

// === sound_engage_close_range_setup: XXX
script static instanced void sound_engage_close_range_setup()
	//dprint_door( "sound_engage_close_range_setup: DEFAULTS" );
	sound_engage_close_range_setup( position_open_start(), position_open() );
end
script static instanced void sound_engage_close_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_engage_close_range_setup: POSITIONS" );
	
	if ( r_position_min <= r_position_max ) then
		sound_engage_close_range_min( r_position_min );
		sound_engage_close_range_max( r_position_max );
	else
		sound_engage_close_range_setup( r_position_max, r_position_min );
	end
	
end

// === sound_engage_close_range: XXX
script static instanced boolean sound_engage_close_range( real r_position )
	range_check( r_position, sound_engage_close_range_min(), sound_engage_close_range_max() );
end
script static instanced boolean sound_engage_close_range()
	sound_engage_close_range( position() );
end

// === sound_engage_close_range_min: XXX
script static instanced real sound_engage_close_range_min()
	R_sound_engage_close_range_min;
end
script static instanced void sound_engage_close_range_min( real r_position_min )
	//dprint_door( "sound_engage_close_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_close();
	end
	R_sound_engage_close_range_min = position_bound( r_position_min );
	
end

// === sound_engage_close_range_max: XXX
script static instanced real sound_engage_close_range_max()
	R_sound_engage_close_range_max;
end
script static instanced void sound_engage_close_range_max( real r_position_max )
	//dprint_door( "sound_engage_close_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_close_start();
	end
	R_sound_engage_close_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_engage_close_start: XXX
script static instanced void sys_sound_engage_close_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_engage_close_start" );
	sys_sound_engage_start( sound_engage_close(), sound_engage_close_range_min(), sound_engage_close_range_max() );
end

// === sys_sound_engage_close_stop: XXX
script static instanced void sys_sound_engage_close_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_engage_close_stop" );
	sys_sound_engage_stop( sound_engage_close(), sound_engage_close_range_min(), sound_engage_close_range_max() );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_close_set( sound snd_sound )
	sound_engage_close_setup( snd_sound );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: LOOP
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced looping_sound SND_sound_loop = 									NONE;
instanced real R_sound_loop_range_min =										0.0;
instanced real R_sound_loop_range_max =										0.0;
instanced long L_sound_loop_thread =											0;


// === sound_loop_open_range: XXX
script static instanced boolean sound_loop_range()
	sound_loop_range( position() );
end
script static instanced boolean sound_loop_range( real r_position )
	range_check( r_position, sound_loop_range_min(), sound_loop_range_max() );
end

// === sound_loop_range_min: XXX
script static instanced real sound_loop_range_min()
	R_sound_loop_range_min;
end
script static instanced void sys_sound_loop_range_min( real r_position_min )
	//dprint_door( "sys_sound_loop_range_min: SET" );

	R_sound_loop_range_min = position_bound( r_position_min );
	
end

// === sound_loop_range_max: XXX
script static instanced real sound_loop_range_max()
	R_sound_loop_range_max;
end
script static instanced void sys_sound_loop_range_max( real r_position_max )
	//dprint_door( "sound_loop_range_max: SET" );

	R_sound_loop_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_loop_start: XXX
script static instanced void sys_sound_loop_start( looping_sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_loop_start" );

	// Reset if sound is changing
	if ( SND_sound_loop != snd_sound ) then
		sys_sound_loop_reset();
	end

	// store the sound
	SND_sound_loop = snd_sound;
	sys_sound_loop_range_min( r_position_min );
	sys_sound_loop_range_max( r_position_max );

	// start the thread
	if ( (not isthreadvalid(L_sound_loop_thread)) and (snd_sound != NONE) ) then
		L_sound_loop_thread = thread( sys_sound_loop_watch() );
	end

end

// === sys_sound_loop_stop: XXX
script static instanced void sys_sound_loop_stop( looping_sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_loop_stop" );

	sys_sound_loop_reset();

end

// === xxx: XXX
script static instanced void sys_sound_loop_watch()
local boolean b_active = FALSE;
	//dprint_door( "sys_sound_loop_watch" );
	
	repeat
	
		// wait for active change
		sleep_until( (sys_sound_loop_range() != b_active) or animate_not_active(), 1 );
	
		if ( b_active != sys_sound_loop_range() ) then
			b_active = not b_active;

			// start or stop the loop
			if ( b_active ) then
				sound_looping_start( SND_sound_loop, this, 1 );
			else
				sound_looping_stop( SND_sound_loop );
			end

		end
	
	until( animate_not_active(), 1 );
  
  // reset
  sys_sound_loop_reset();
  
end

script static instanced boolean sys_sound_loop_range()
	sys_sound_loop_range( position() );
end
script static instanced boolean sys_sound_loop_range( real r_position )
	( r_position != animate_target_position() ) and sound_loop_range(r_position) and animate_active();
end

// === xxx: XXX
script static instanced void sys_sound_loop_reset()
	//dprint_door( "sys_sound_loop_reset" );

	// stop prior sound
	if ( SND_sound_loop != NONE ) then
		sound_looping_stop( SND_sound_loop );
		SND_sound_loop = NONE;
	end
	
	// kill thread
	kill_thread( L_sound_loop_thread );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: LOOP: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static looping_sound SND_sound_loop_open =  							NONE;
static real R_sound_loop_open_range_min =									0.0;
static real R_sound_loop_open_range_max =									1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_loop_open_setup: XXX
script static instanced void sound_loop_open_setup( looping_sound snd_sound )
	//dprint_door( "sound_loop_open_setup: DEFAULTS" );
	sound_loop_open_setup( snd_sound, position_close(), position_open() );
end
script static instanced void sound_loop_open_setup( looping_sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_loop_open_setup: POSITIONS" );
	sound_loop_open( snd_sound );
	sound_loop_open_range_setup( r_position_min, r_position_max );
end

// === sound_loop_open: XXX
script static instanced looping_sound sound_loop_open()
	SND_sound_loop_open;
end
script static instanced void sound_loop_open( looping_sound snd_sound )
	//dprint_door( "sound_loop_open: SET" );
	SND_sound_loop_open = snd_sound;
end

// === sound_loop_open_play_start: XXX
script static instanced void sound_loop_open_play_start()
	//dprint_door( "sound_loop_open_play_start" );
	sound_looping_start( sound_loop_open(), this, 1 );
end

// === sound_loop_open_play_stop: XXX
script static instanced void sound_loop_open_play_stop()
	//dprint_door( "sound_loop_open_play_stop" );
	sound_looping_stop( sound_loop_open() );
end

// === sound_loop_open_range_setup: XXX
script static instanced void sound_loop_open_range_setup()
	//dprint_door( "sound_loop_open_range_setup: DEFAULTS" );
	sound_loop_open_range_setup( position_close(), position_open() );
end
script static instanced void sound_loop_open_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_loop_open_range_setup: POSITIONS" );

	if ( r_position_min <= r_position_max ) then
		sound_loop_open_range_min( r_position_min );
		sound_loop_open_range_max( r_position_max );
	else
		sound_loop_open_range_setup( r_position_max, r_position_min );
	end

end

// === sound_loop_open_range: XXX
script static instanced boolean sound_loop_open_range()
	sound_loop_open_range( position() );
end
script static instanced boolean sound_loop_open_range( real r_position )
	range_check( r_position, sound_loop_open_range_min(), sound_loop_open_range_max() );
end

// === sound_loop_open_range_min: XXX
script static instanced real sound_loop_open_range_min()
	R_sound_loop_open_range_min;
end
script static instanced void sound_loop_open_range_min( real r_position_min )
	//dprint_door( "sound_loop_open_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_open_start();
	end
	R_sound_loop_open_range_min = position_bound( r_position_min );
	
end

// === sound_loop_open_range_max: XXX
script static instanced real sound_loop_open_range_max()
	R_sound_loop_open_range_max;
end
script static instanced void sound_loop_open_range_max( real r_position_max )
	//dprint_door( "sound_loop_open_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_open();
	end
	R_sound_loop_open_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_loop_open_start: XXX
script static instanced void sys_sound_loop_open_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_loop_open_start" );
	sys_sound_loop_start( sound_loop_open(), sound_loop_open_range_min(), sound_loop_open_range_max() );
end

// === sys_sound_loop_open_stop: XXX
script static instanced void sys_sound_loop_open_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_loop_open_stop" );
	sys_sound_loop_stop( sound_loop_open(), sound_loop_open_range_min(), sound_loop_open_range_max() );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_open_looping_set( looping_sound snd_sound )
	sound_loop_open_setup( snd_sound );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: LOOP: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static looping_sound SND_sound_loop_close =  							NONE;
static real R_sound_loop_close_range_min =								0.0;
static real R_sound_loop_close_range_max =								1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_loop_close_setup: XXX
script static instanced void sound_loop_close_setup( looping_sound snd_sound )
	//dprint_door( "sound_loop_close_setup: DEFAULTS" );
	sound_loop_close_setup( snd_sound, position_close(), position_open() );
end
script static instanced void sound_loop_close_setup( looping_sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_loop_close_setup: POSITIONS" );
	sound_loop_close( snd_sound );
	sound_loop_close_range_setup( r_position_min, r_position_max );
end

// === looping_sound: XXX
script static instanced looping_sound sound_loop_close()
	SND_sound_loop_close;
end
script static instanced void sound_loop_close( looping_sound snd_sound )
	//dprint_door( "sound_loop_close: SET" );
	SND_sound_loop_close = snd_sound;
end

// === sound_loop_close_play_start: XXX
script static instanced void sound_loop_close_play_start()
	//dprint_door( "sound_loop_close_play_start" );
	sound_looping_start( sound_loop_close(), this, 1 );
end

// === sound_loop_close_play_stop: XXX
script static instanced void sound_loop_close_play_stop()
	//dprint_door( "sound_loop_close_play_stop" );
	sound_looping_stop( sound_loop_close() );
end

// === sound_loop_close_range_setup: XXX
script static instanced void sound_loop_close_range_setup()
	//dprint_door( "sound_loop_close_range_setup: DEFAULTS" );
	sound_loop_close_range_setup( position_close(), position_open() );
end
script static instanced void sound_loop_close_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_loop_close_range_setup: POSITIONS" );

	if ( r_position_min <= r_position_max ) then
		sound_loop_close_range_min( r_position_min );
		sound_loop_close_range_max( r_position_max );
	else
		sound_loop_close_range_setup( r_position_max, r_position_min );
	end

end

// === sound_loop_close_range: XXX
script static instanced boolean sound_loop_close_range()
	sound_loop_close_range( position() );
end
script static instanced boolean sound_loop_close_range( real r_position )
	range_check( r_position, sound_loop_close_range_min(), sound_loop_close_range_max() );
end

// === sound_loop_close_range_min: XXX
script static instanced real sound_loop_close_range_min()
	R_sound_loop_close_range_min;
end
script static instanced void sound_loop_close_range_min( real r_position_min )
	//dprint_door( "sound_loop_close_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_close();
	end
	R_sound_loop_close_range_min = position_bound( r_position_min );
	
end

// === sound_loop_close_range_max: XXX
script static instanced real sound_loop_close_range_max()
	R_sound_loop_close_range_max;
end
script static instanced void sound_loop_close_range_max( real r_position_max )
	//dprint_door( "sound_loop_close_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_close_start();
	end
	R_sound_loop_close_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_loop_close_start: XXX
script static instanced void sys_sound_loop_close_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_loop_close_start" );
	sys_sound_loop_start( sound_loop_close(), sound_loop_close_range_min(), sound_loop_close_range_max() );
end

// === sys_sound_loop_close_stop: XXX
script static instanced void sys_sound_loop_close_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_loop_close_stop" );
	sys_sound_loop_stop( sound_loop_close(), sound_loop_close_range_min(), sound_loop_close_range_max() );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_close_looping_set( looping_sound snd_sound )
	sound_loop_close_setup( snd_sound );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: DISENGAGE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced long L_sound_disengage_thread =									0;

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_disengage_start: XXX
script static instanced void sys_sound_disengage_start( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_disengage_start" );

	// reset the sound
	sys_sound_disengage_reset();

	// play the new sound
	L_sound_disengage_thread = sys_sound_impulse_start( snd_sound, r_position_min, r_position_max );
	
end

// === sys_sound_disengage_stop: XXX
//script static instanced void sys_sound_disengage_stop( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sys_sound_disengage_stop" );
//end

// === sys_sound_disengage_reset: XXX
script static instanced void sys_sound_disengage_reset()
	//dprint_door( "sys_sound_disengage_reset" );

	// kill the old sound thread
	kill_thread( L_sound_disengage_thread );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: DISENGAGE: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static sound SND_sound_disengage_open =  									NONE;
static real R_sound_disengage_open_range_min =						1.0;
static real R_sound_disengage_open_range_max =						1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_disengage_open_setup: XXX
script static instanced void sound_disengage_open_setup( sound snd_sound )
	//dprint_door( "sound_disengage_open_setup: DEFAULTS" );
	sound_disengage_open_setup( snd_sound, position_open_start(), position_open() );
end
script static instanced void sound_disengage_open_setup( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_disengage_open_setup: POSITIONS" );
	sound_disengage_open( snd_sound );
	sound_disengage_open_range_setup( r_position_min, r_position_max );
end

// === sound_disengage_open: XXX
script static instanced sound sound_disengage_open()
	SND_sound_disengage_open;
end
script static instanced void sound_disengage_open( sound snd_sound )
	//dprint_door( "sound_disengage_open: SET" );
	SND_sound_disengage_open = snd_sound;
end

// === sound_disengage_open_play_start: XXX
script static instanced void sound_disengage_open_play_start()
	//dprint_door( "sound_disengage_open_play_start" );
	sound_impulse_start( sound_disengage_open(), this, 1 );
end

// === sound_disengage_open_play_stop: XXX
script static instanced void sound_disengage_open_play_stop()
	//dprint_door( "sound_disengage_open_play_stop" );
	sound_impulse_stop( sound_disengage_open() );
end

// === sound_disengage_open_range_setup: XXX
script static instanced void sound_disengage_open_range_setup()
	//dprint_door( "sound_disengage_open_range_setup: DEFAULTS" );
	sound_disengage_open_range_setup( position_open_start(), position_open() );
end
script static instanced void sound_disengage_open_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_disengage_open_range_setup: POSITIONS" );

	if ( r_position_min <= r_position_max ) then
		sound_disengage_open_range_min( r_position_min );
		sound_disengage_open_range_max_set( r_position_max );
	else
		sound_disengage_open_range_setup( r_position_max, r_position_min );
	end

end

// === sound_disengage_open_range: XXX
script static instanced void sound_disengage_open_range( real r_position )
	range_check( r_position, sound_disengage_open_range_min(), sound_disengage_open_range_max() );
end
script static instanced void sound_disengage_open_range()
	sound_disengage_open_range( position() );
end

// === sound_disengage_open_range_min: XXX
script static instanced real sound_disengage_open_range_min()
	R_sound_disengage_open_range_min;
end
script static instanced void sound_disengage_open_range_min( real r_position_min )
	//dprint_door( "sound_disengage_open_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_open_start();
	end
	R_sound_disengage_open_range_min = position_bound( r_position_min );
	
end

// === sound_disengage_open_range_max: XXX
script static instanced real sound_disengage_open_range_max()
	R_sound_disengage_open_range_max;
end
script static instanced void sound_disengage_open_range_max_set( real r_position_max )
	//dprint_door( "sound_disengage_open_range_max_set: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_open();
	end
	R_sound_disengage_open_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_disengage_open_start: XXX
script static instanced void sys_sound_disengage_open_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_disengage_open_start" );
	sys_sound_disengage_start( sound_disengage_open(), sound_disengage_open_range_min(), sound_disengage_open_range_max() );
end

// === sys_sound_disengage_open_stop: XXX
//script static instanced void sys_sound_disengage_open_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_disengage_open_stop" );
	//sys_sound_disengage_stop( sound_disengage_open(), sound_disengage_open_range_min(), sound_disengage_open_range_max() );
//end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_open_end_set( sound snd_sound )
	sound_disengage_open_setup( snd_sound );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// SOUND: DISENGAGE: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static sound SND_sound_disengage_close =  								NONE;
static real R_sound_disengage_close_range_min =						0.0;
static real R_sound_disengage_close_range_max =						0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sound_disengage_close_setup: XXX
script static instanced void sound_disengage_close_setup( sound snd_sound )
	//dprint_door( "sound_disengage_close_setup: DEFAULTS" );
	sound_disengage_close_setup( snd_sound, position_close(), position_close_start() );
end
script static instanced void sound_disengage_close_setup( sound snd_sound, real r_position_min, real r_position_max )
	//dprint_door( "sound_disengage_close_setup: POSITIONS" );
	sound_disengage_close( snd_sound );
	sound_disengage_close_range_setup( r_position_min, r_position_max );
end

// === sound_disengage_close: XXX
script static instanced sound sound_disengage_close()
	SND_sound_disengage_close;
end
script static instanced void sound_disengage_close( sound snd_sound )
	//dprint_door( "sound_disengage_close: SET" );
	SND_sound_disengage_close = snd_sound;
end

// === sound_disengage_close_play_start: XXX
script static instanced void sound_disengage_close_play_start()
	//dprint_door( "sound_disengage_close_play_start" );
	sound_impulse_start( sound_disengage_close(), this, 1 );
end

// === sound_disengage_close_play_stop: XXX
script static instanced void sound_disengage_close_play_stop()
	//dprint_door( "sound_disengage_close_play_stop" );
	sound_impulse_stop( sound_disengage_close() );
end

// === sound_disengage_close_range_setup: XXX
script static instanced void sound_disengage_close_range_setup()
	//dprint_door( "sound_disengage_close_range_setup: DEFAULTS" );
	sound_disengage_close_range_setup( position_close(), position_close_start() );
end
script static instanced void sound_disengage_close_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "sound_disengage_close_range_setup: POSITIONS" );

	if ( r_position_min <= r_position_max ) then
		sound_disengage_close_range_min( r_position_min );
		sound_disengage_close_range_max( r_position_max );
	else
		sound_disengage_close_range_setup( r_position_max, r_position_min );
	end

end

// === sound_disengage_close_range: XXX
script static instanced boolean sound_disengage_close_range()
	sound_disengage_close_range( position() );
end
script static instanced boolean sound_disengage_close_range( real r_position )
	range_check( r_position, sound_disengage_close_range_min(), sound_disengage_close_range_max() );
end

// === sound_disengage_close_range_min: XXX
script static instanced real sound_disengage_close_range_min()
	R_sound_disengage_close_range_min;
end
script static instanced void sound_disengage_close_range_min( real r_position_min )
	//dprint_door( "sound_disengage_close_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_close();
	end
	R_sound_disengage_close_range_min = position_bound( r_position_min );
	
end

// === sound_disengage_close_range_max: XXX
script static instanced real sound_disengage_close_range_max()
	R_sound_disengage_close_range_max;
end
script static instanced void sound_disengage_close_range_max( real r_position_max )
	//dprint_door( "sound_disengage_close_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_close_start();
	end
	R_sound_disengage_close_range_max = position_bound( r_position_max );
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_sound_disengage_close_start: XXX
script static instanced void sys_sound_disengage_close_start( real r_speed, real r_position )
	//dprint_door( "sys_sound_disengage_close_start" );
	sys_sound_disengage_start( sound_disengage_close(), sound_disengage_close_range_min(), sound_disengage_close_range_max() );
end

// === sys_sound_disengage_close_stop: XXX
//script static instanced void sys_sound_disengage_close_stop( real r_speed, real r_position )
	//dprint_door( "sys_sound_disengage_close_stop" );
	//sys_sound_disengage_stop( sound_disengage_close(), sound_disengage_close_range_min(), sound_disengage_close_range_max() );
//end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void sound_close_end_set( sound snd_sound )
	sound_disengage_close_setup( snd_sound );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// INTERACTION LOCK
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced boolean B_interaction_lock_enabled = 						FALSE;
static real B_interaction_lock_range_min = 								0.0;
static real B_interaction_lock_range_max = 								1.0;
instanced long L_interaction_lock_thread = 								0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === interaction_lock_setup: XXX
script static instanced void interaction_lock_setup( boolean b_enabled )
	//dprint_door( "interaction_lock_setup: DEFAULTS" );
	interaction_lock_setup( b_enabled, position_open_start(), position_open() );
end
script static instanced void interaction_lock_setup( boolean b_enabled, real r_position_min, real r_position_max )
	//dprint_door( "interaction_lock_setup" );
	interaction_lock_enabled( b_enabled );
	interaction_lock_range_setup( r_position_min, r_position_max );
end

// === interaction_lock_enabled: XXX
script static instanced boolean interaction_lock_enabled()
	B_interaction_lock_enabled;
end
script static instanced void interaction_lock_enabled( boolean b_enabled )
	//dprint_door( "interaction_lock_enabled: SET" );
	B_interaction_lock_enabled = b_enabled;
	
	// set enabled/disabled
	sys_interaction_lock_auto_set();
end

// === interaction_lock_range_setup: XXX
script static instanced void interaction_lock_range_setup()
	//dprint_door( "interaction_lock_range_setup: DEFAULTS" );
	interaction_lock_range_setup( position_close_start(), position_open() );
end
script static instanced void interaction_lock_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "interaction_lock_range_setup: POSITIONS" );

	if ( r_position_min <= r_position_max ) then
		interaction_lock_range_min( r_position_min );
		interaction_lock_range_max( r_position_max );
	else
		interaction_lock_range_setup( r_position_max, r_position_min );
	end

end

// === interaction_lock_range_min: XXX
script static instanced real interaction_lock_range_min()
	B_interaction_lock_range_min;
end
script static instanced void interaction_lock_range_min( real r_position_min )
	//dprint_door( "interaction_lock_range_min: SET" );

	// DEFAULTS
	if ( r_position_min < 0.0 ) then
		r_position_min = position_close();
	end

	// set	
	B_interaction_lock_range_min = position_bound( r_position_min );
	
	// set enabled/disabled
	sys_interaction_lock_auto_set();
	
end

// === interaction_lock_range_max: XXX
script static instanced real interaction_lock_range_max()
	B_interaction_lock_range_max;
end
script static instanced void interaction_lock_range_max( real r_position_max )
	//dprint_door( "interaction_lock_range_max: SET" );

	// DEFAULTS
	if ( r_position_max < 0.0 ) then
		r_position_max = position_close();
	end

	// set	
	B_interaction_lock_range_max = position_bound( r_position_max );
	
	// set enabled/disabled
	sys_interaction_lock_auto_set();
	
end

// === interaction_lock_range: XXX
script static instanced boolean interaction_lock_range( real r_position )
	range_check( r_position, interaction_lock_range_min(), interaction_lock_range_max() );
end
script static instanced boolean interaction_lock_range()
	interaction_lock_range( position() );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_interaction_lock_start: XXX
script static instanced void sys_interaction_lock_start( real r_speed, real r_position )
	//dprint_door( "sys_interaction_lock_start" );

	if ( animate_active(r_speed, r_position) ) then
		if ( interaction_lock_enabled() and (not isthreadvalid(L_interaction_lock_thread)) ) then
			L_interaction_lock_thread = thread( sys_interaction_lock_watch() );
		end
	end

end

// === sys_interaction_lock_stop: XXX
//script static instanced void sys_interaction_lock_stop( real r_speed, real r_position )
	//dprint_door( "sys_interaction_lock_stop" );

	/*
	if ( animate_active(r_speed, r_position) ) then
		//dprint_door( "sys_interaction_lock_stop" );
	end
	*/

//end

// === sys_interaction_lock_auto_set: XXX
script static instanced void sys_interaction_lock_auto_set()
	//dprint_door( "sys_interaction_lock_auto_set" );
	object_set_child_interaction_locked( this, not(interaction_lock_enabled() and interaction_lock_range()) );
end

// === sys_interaction_lock_watch: XXX
script static instanced void sys_interaction_lock_watch()
local boolean b_active = interaction_lock_range();
	//dprint_door( "sys_interaction_lock_watch" );

	// initialize start
	sys_interaction_lock_auto_set();

	repeat
	
		// wait for active to change
		sleep_until( (b_active != interaction_lock_range()) or animate_not_active(), 1 );
		b_active = interaction_lock_range();
	
		// set the lock
		sys_interaction_lock_auto_set();
		
	until( animate_not_active(), 1 );

end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void weaponpickup_set( real r_position_min, real r_position_max )
	interaction_lock_setup( (r_position_min >= 0.0) or (r_position_max >= 0.0), r_position_min, r_position_max );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DISTANCE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === distance_check: XXX
script static boolean distance_check( object_list obj_list, object o_object, real r_distance )
	
	if ( r_distance >= 0 ) then
		( list_count(obj_list) > 0 ) and ( objects_distance_to_object(obj_list, o_object) >= r_distance );
	else
		( list_count(obj_list) > 0 ) and ( objects_distance_to_object(obj_list, o_object) < -r_distance );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// TRIGGER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === trigger_check: XXX
script static boolean trigger_check( object_list obj_list, trigger_volume tv_check, boolean b_checkall, boolean b_checkin )
	( list_count(obj_list) > 0 )
	and
	(
		(
			b_checkin
			and
			(
				( (not b_checkall) and volume_test_objects(tv_check, obj_list) )
				or
				( b_checkall and volume_test_objects_all(tv_check, obj_list) )
			)
		)
		or
		( (not b_checkin) and (not volume_test_objects(tv_check, obj_list)) )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced boolean B_auto_enabled = 												TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_enabled: XXX
script static instanced boolean auto_enabled()
	B_auto_enabled;
end
script static instanced void auto_enabled( boolean b_enabled )
	//dprint_door( "auto_enabled: SET" );
	B_auto_enabled = b_enabled;
end

// === auto_enabled_zoneset: XXX
script static instanced void auto_enabled_zoneset( boolean b_enabled, long l_zoneset )
	auto_enabled_zoneset( b_enabled, l_zoneset, l_zoneset );
end
script static instanced void auto_enabled_zoneset( boolean b_enabled, long l_zoneset_min, long l_zoneset_max )
	sleep_until( zoneset_range(zoneset_current(), l_zoneset_min, l_zoneset_max), 1 );
	auto_enabled( b_enabled );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: PLAYERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance: XXX
script static instanced void auto_distance( object o_object, real r_distance, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_distance: OBJECT" );


	if ( not range_check(position(), r_activate_range_min, r_activate_range_max) ) then
		local boolean b_activated = FALSE;

		repeat
	
			// activate power
			sys_power_auto_enabled_active( TRUE );
		
			// wait
			sleep_until( (distance_check(Players(),o_object,r_distance) != b_activated) or range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

			// activate/deactivate
			if ( (not range_check(position(), r_activate_range_min, r_activate_range_max)) and auto_enabled() ) then
				b_activated = distance_check( Players(), o_object, r_distance );
				
				if ( b_activated ) then
					animate( r_activate_speed, r_activate_position, not b_smart );
				else
					animate( r_deactivate_speed, r_deactivate_position, FALSE );
				end
				
			end
		
		until( range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

		// make sure it finishes it's position
		if ( auto_enabled() ) then
			animate( r_activate_speed, r_activate_position, FALSE );
		end

	end

end
script static instanced void auto_distance( real r_distance, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_distance: THIS" );
	auto_distance( this, r_distance, b_smart, r_activate_speed, r_activate_position, r_activate_range_min, r_activate_range_max, r_deactivate_speed, r_deactivate_position );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: PLAYERS: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_open: XXX
script static instanced void auto_distance_open( real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_open: THIS: DEFAULT" );
	auto_distance( this, r_distance, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_distance_open( real r_distance, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_distance_open: THIS: SPEEDS" );
	auto_distance( this, r_distance, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end
script static instanced void auto_distance_open( object o_object, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_open: OBJECT: DEFAULT" );
	auto_distance( o_object, r_distance, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_distance_open( object o_object, real r_distance, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_distance_open: OBJECT: SPEEDS" );
	auto_distance( o_object, r_distance, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: PLAYERS: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_close: XXX
script static instanced void auto_distance_close( real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_players_close: THIS: DEFAULT" );
	auto_distance( this, r_distance, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_close( real r_distance, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_distance_players_close: THIS: SPEEDS" );
	auto_distance( this, r_distance, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_close( object o_object, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_players_close: OBJECT: DEFAULT" );
	auto_distance( o_object, r_distance, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_close( object o_object, real r_distance, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_distance_players_close: OBJECT: SPEEDS" );
	auto_distance( o_object, r_distance, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OBJECTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_objlist: XXX
script static instanced void auto_distance_objlist( object o_object, object_list obj_list, real r_distance, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_distance_objlist: OBJECT" );

	if ( not range_check(position(), r_activate_range_min, r_activate_range_max) ) then
		local boolean b_activated = FALSE;

		repeat
	
			// activate power
			sys_power_auto_enabled_active( TRUE );
		
			// wait
			sleep_until( (distance_check(obj_list,o_object,r_distance) != b_activated) or range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

			// activate/deactivate
			if ( (not range_check(position(), r_activate_range_min, r_activate_range_max)) and auto_enabled() ) then
				b_activated = distance_check( obj_list, o_object, r_distance );
				
				if ( b_activated ) then
					animate( r_activate_speed, r_activate_position, not b_smart );
				else
					animate( r_deactivate_speed, r_deactivate_position, FALSE );
				end
				
			end
		
		until( range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

		// make sure it finishes it's position
		if ( auto_enabled() ) then
			animate( r_activate_speed, r_activate_position, FALSE );
		end

	end

end
script static instanced void auto_distance_objlist( object_list obj_list, real r_distance, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_distance_objlist: THIS" );
	auto_distance_objlist( this, obj_list, r_distance, b_smart, r_activate_speed, r_activate_position, r_activate_range_min, r_activate_range_max, r_deactivate_speed, r_deactivate_position );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OBJLIST: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_objlist_open: XXX
script static instanced void auto_distance_objlist_open( object_list obj_list, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_objlist_open: DEFAULTS" );
	auto_distance_objlist( this, obj_list, r_distance, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_distance_objlist_open( object_list obj_list, real r_distance, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_distance_objlist_open: SPEEDS" );
	auto_distance_objlist( this, obj_list, r_distance, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end
script static instanced void auto_distance_objlist_open( object o_object, object_list obj_list, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_objlist_open: OBJECT: DEFAULTS" );
	auto_distance_objlist( o_object, obj_list, r_distance, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_distance_objlist_open( object o_object, object_list obj_list, real r_distance, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_distance_objlist_open: OBJECT: SPEEDS" );
	auto_distance_objlist( o_object, obj_list, r_distance, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OBJLIST: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_objlist_close: XXX
script static instanced void auto_distance_objlist_close( object_list obj_list, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_objlist_close: DEFAULTS" );
	auto_distance_objlist( this, obj_list, r_distance, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_objlist_close( object_list obj_list, real r_distance, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_distance_objlist_close: SPEEDS" );
	auto_distance_objlist( this, obj_list, r_distance, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_objlist_close( object o_object, object_list obj_list, real r_distance, boolean b_smart )
	//dprint_door( "auto_distance_objlist_close: OBJECT: DEFAULTS" );
	auto_distance_objlist( o_object, obj_list, r_distance, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_distance_objlist_close( object o_object, object_list obj_list, real r_distance, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_distance_objlist_close: OBJECT: SPEEDS" );
	auto_distance_objlist( o_object, obj_list, r_distance, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OPEN_CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OPEN_CLOSE: PLAYERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_open_close: XXX
script static instanced void auto_distance_open_close( real r_open_distance, boolean b_smart )
	//dprint_door( "auto_distance_open_close: THIS: DEFAULTS" );
	auto_distance_open_close( this, r_open_distance, b_smart, -r_open_distance, b_smart );
end
script static instanced void auto_distance_open_close( real r_open_distance, boolean b_open_smart, real r_close_distance, boolean b_close_smart )
	//dprint_door( "auto_distance_open_close: THIS" );
	auto_distance_open_close( this, r_open_distance, b_open_smart, r_close_distance, b_close_smart );
end
script static instanced void auto_distance_open_close( object o_object, real r_open_distance, boolean b_open_smart, real r_close_distance, boolean b_close_smart )
local boolean b_open = position_close_check();
local long l_thread = 0;
	//dprint_door( "auto_distance_open_close: OBJECT" );

	repeat
	
		//dprint_door( "auto_distance_open_close: OBJECT" );
		if ( b_open ) then
			l_thread = thread( auto_distance_open(o_object, r_open_distance, b_open_smart) );
		end
		if ( not b_open ) then
			l_thread = thread( auto_distance_close(o_object, r_close_distance, b_close_smart) );
		end
		sleep_until( not isthreadvalid(l_thread) or (not auto_enabled()), 1 );
		
		b_open = not b_open;
	until ( not auto_enabled(), 1 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: DISTANCE: OPEN_CLOSE: OBJLIST
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_distance_objlist_open_close: XXX
script static instanced void auto_distance_objlist_open_close( object o_object, object_list obj_list, real r_open_distance, boolean b_open_smart, real r_close_distance, boolean b_close_smart )
local boolean b_open = position_close_check();
local long l_thread = 0;
	//dprint_door( "auto_distance_objlist_open_close: OBJECT" );

	repeat

		if ( b_open ) then
			l_thread = thread( auto_distance_objlist_open(o_object, obj_list, r_open_distance, b_open_smart) );
		end
		if ( not b_open ) then
			l_thread = thread( auto_distance_objlist_close(o_object, obj_list, r_close_distance, b_close_smart) );
		end
		sleep_until( not isthreadvalid(l_thread) or (not auto_enabled()), 1 );
		
		b_open = not b_open;
	until ( not auto_enabled(), 1 );

end
script static instanced void auto_distance_objlist_open_close( object_list obj_list, real r_open_distance, boolean b_open_smart, real r_close_distance, boolean b_close_smart )
	//dprint_door( "auto_distance_objlist_open_close: THIS" );
	auto_distance_objlist_open_close( this, obj_list, r_open_distance, b_open_smart, r_close_distance, b_close_smart );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: PLAYERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger: XXX
script static instanced void auto_trigger( trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_trigger" );

	if ( not range_check(position(), r_activate_range_min, r_activate_range_max) ) then
		local boolean b_activated = FALSE;

		repeat
	
			// activate power
			sys_power_auto_enabled_active( TRUE );
		
			// wait
			sleep_until( (trigger_check(Players(),tv_volume,b_all,b_inside) != b_activated) or range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

			// activate/deactivate
			if ( (not range_check(position(), r_activate_range_min, r_activate_range_max)) and auto_enabled() ) then
				b_activated = trigger_check( Players(), tv_volume, b_all, b_inside );
				
				if ( b_activated ) then
					animate( r_activate_speed, r_activate_position, not b_smart );
				else
					animate( r_deactivate_speed, r_deactivate_position, FALSE );
				end
				
			end
		
		until( range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

		// make sure it finishes it's position
		if ( auto_enabled() ) then
			animate( r_activate_speed, r_activate_position, FALSE );
		end

	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: PLAYERS: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_open: XXX
script static instanced void auto_trigger_open( trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart )
	//dprint_door( "auto_trigger_open: DEFAULTS" );
	auto_trigger( tv_volume, b_all, b_inside, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_open( trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_open: SPEEDS" );
	auto_trigger( tv_volume, b_all, b_inside, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_open_any_in: XXX
script static instanced void auto_trigger_open_any_in( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_open_any_in: DEFAULTS" );
	auto_trigger( tv_volume, FALSE, TRUE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_open_any_in( trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_open_any_in: SPEEDS" );
	auto_trigger( tv_volume, FALSE, TRUE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_open_any_out: XXX
script static instanced void auto_trigger_open_any_out( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_open_any_out: DEFAULTS" );
	auto_trigger( tv_volume, FALSE, FALSE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_open_any_out( trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_open_any_out: SPEEDS" );
	auto_trigger( tv_volume, FALSE, FALSE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_open_all_in: XXX
script static instanced void auto_trigger_open_all_in( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_open_all_in: DEFAULTS" );
	auto_trigger( tv_volume, TRUE, TRUE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_open_all_in( trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_open_all_in: SPEEDS" );
	auto_trigger( tv_volume, TRUE, TRUE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_open_all_out: XXX
script static instanced void auto_trigger_open_all_out( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_open_all_out: DEFAULTS" );
	auto_trigger( tv_volume, TRUE, FALSE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_open_all_out( trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_open_all_out: SPEEDS" );
	auto_trigger( tv_volume, TRUE, FALSE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: PLAYERS: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_close: XXX
script static instanced void auto_trigger_close( trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart )
	//dprint_door( "auto_trigger_close: DEFAULTS" );
	auto_trigger( tv_volume, b_all, b_inside, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_trigger_close( trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_close: SPEEDS" );
	auto_trigger( tv_volume, b_all, b_inside, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// === auto_trigger_close_any_in: XXX
script static instanced void auto_trigger_close_any_in( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_close_any_in: DEFAULTS" );
	auto_trigger( tv_volume, FALSE, TRUE, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_trigger_close_any_in( trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_close_any_in: SPEEDS" );
	auto_trigger( tv_volume, FALSE, TRUE, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// === auto_trigger_close_any_out: XXX
script static instanced void auto_trigger_close_any_out( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_close_any_out: DEFAULTS" );
	auto_trigger( tv_volume, FALSE, FALSE, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_trigger_close_any_out( trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_close_any_out: SPEEDS" );
	auto_trigger( tv_volume, FALSE, FALSE, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// === auto_trigger_close_all_in: XXX
script static instanced void auto_trigger_close_all_in( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_close_all_in: DEFAULTS" );
	auto_trigger( tv_volume, TRUE, TRUE, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_trigger_close_all_in( trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_close_all_in: SPEEDS" );
	auto_trigger( tv_volume, TRUE, TRUE, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// === auto_trigger_close_all_out: XXX
script static instanced void auto_trigger_close_all_out( trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_close_all_out: DEFAULTS" );
	auto_trigger( tv_volume, TRUE, FALSE, b_smart, speed_close(), position_close(), position_close(), position_close_start(), speed_open(), position_open() );
end
script static instanced void auto_trigger_close_all_out( trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_close_all_out: SPEEDS" );
	auto_trigger( tv_volume, TRUE, FALSE, b_smart, r_speed_close, position_close(), position_close(), position_close_start(), r_speed_open, position_open() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OBJLIST
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_objlist: XXX
script static instanced void auto_trigger_objlist( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_activate_speed, real r_activate_position, real r_activate_range_min, real r_activate_range_max, real r_deactivate_speed, real r_deactivate_position )
	//dprint_door( "auto_trigger_objlist" );

	if ( not range_check(position(), r_activate_range_min, r_activate_range_max) ) then
		local boolean b_activated = FALSE;

		repeat
	
			// activate power
			sys_power_auto_enabled_active( TRUE );
		
			// wait
			sleep_until( (trigger_check(obj_list,tv_volume,b_all,b_inside) != b_activated) or range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

			// activate/deactivate
			if ( (not range_check(position(), r_activate_range_min, r_activate_range_max)) and auto_enabled() ) then
				b_activated = trigger_check( obj_list, tv_volume, b_all, b_inside );
				
				if ( b_activated ) then
					animate( r_activate_speed, r_activate_position, not b_smart );
				else
					animate( r_deactivate_speed, r_deactivate_position, FALSE );
				end
				
			end
		
		until( range_check(position(), r_activate_range_min, r_activate_range_max) or (not auto_enabled()), 1 );

		// make sure it finishes it's position
		if ( auto_enabled() ) then
			animate( r_activate_speed, r_activate_position, FALSE );
		end

	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OBJLIST: OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_objlist_open: XXX
script static instanced void auto_trigger_objlist_open( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, b_all, b_inside, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_objlist_open( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_objlist_open: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, b_all, b_inside, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_objlist_open_any_in: XXX
script static instanced void auto_trigger_objlist_open_any_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open_any_in: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, TRUE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_objlist_open_any_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_objlist_open_any_in: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, TRUE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_objlist_open_any_out: XXX
script static instanced void auto_trigger_objlist_open_any_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open_any_out: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, FALSE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_objlist_open_any_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_objlist_open_any_out: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, FALSE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_objlist_open_all_in: XXX
script static instanced void auto_trigger_objlist_open_all_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open_all_in: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, TRUE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_objlist_open_all_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_objlist_open_all_in: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, TRUE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// === auto_trigger_objlist_open_all_out: XXX
script static instanced void auto_trigger_objlist_open_all_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open_all_out: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, FALSE, b_smart, speed_open(), position_open(), position_open_start(), position_open(), speed_close(), position_close() );
end
script static instanced void auto_trigger_objlist_open_all_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_open, real r_speed_close )
	//dprint_door( "auto_trigger_objlist_open_all_out: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, FALSE, b_smart, r_speed_open, position_open(), position_open_start(), position_open(), r_speed_close, position_close() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OBJLIST: CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_objlist_close: XXX
script static instanced void auto_trigger_objlist_close( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_close: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, b_all, b_inside, b_smart, speed_close(), position_close(), position_close_start(), position_close(), speed_open(), position_open() );
end
script static instanced void auto_trigger_objlist_close( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_inside, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_objlist_close: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, b_all, b_inside, b_smart, r_speed_close, position_close(), position_close_start(), position_close(), r_speed_open, position_open() );
end

// === auto_trigger_objlist_close_any_in: XXX
script static instanced void auto_trigger_objlist_close_any_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_close_any_in: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, TRUE, b_smart, speed_close(), position_close(), position_close_start(), position_close(), speed_open(), position_open() );
end
script static instanced void auto_trigger_objlist_close_any_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_objlist_close_any_in: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, TRUE, b_smart, r_speed_close, position_close(), position_close_start(), position_close(), r_speed_open, position_open() );
end

// === auto_trigger_objlist_close_any_out: XXX
script static instanced void auto_trigger_objlist_close_any_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_close_any_out: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, FALSE, b_smart, speed_close(), position_close(), position_close_start(), position_close(), speed_open(), position_open() );
end
script static instanced void auto_trigger_objlist_close_any_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_objlist_close_any_out: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, FALSE, FALSE, b_smart, r_speed_close, position_close(), position_close_start(), position_close(), r_speed_open, position_open() );
end

// === auto_trigger_objlist_close_all_in: XXX
script static instanced void auto_trigger_objlist_close_all_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_close_all_in: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, TRUE, b_smart, speed_close(), position_close(), position_close_start(), position_close(), speed_open(), position_open() );
end
script static instanced void auto_trigger_objlist_close_all_in( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_objlist_close_all_in: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, TRUE, b_smart, r_speed_close, position_close(), position_close_start(), position_close(), r_speed_open, position_open() );
end

// === auto_trigger_objlist_close_all_out: XXX
script static instanced void auto_trigger_objlist_close_all_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_close_all_out: DEFAULTS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, FALSE, b_smart, speed_close(), position_close(), position_close_start(), position_close(), speed_open(), position_open() );
end
script static instanced void auto_trigger_objlist_close_all_out( object_list obj_list, trigger_volume tv_volume, boolean b_smart, real r_speed_close, real r_speed_open )
	//dprint_door( "auto_trigger_objlist_close_all_out: SPEEDS" );
	auto_trigger_objlist( obj_list, tv_volume, TRUE, FALSE, b_smart, r_speed_close, position_close(), position_close_start(), position_close(), r_speed_open, position_open() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OPEN_CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OPEN_CLOSE: PLAYERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_open_close: XXX
script static instanced void auto_trigger_open_close( trigger_volume tv_volume, boolean b_all, boolean b_open_inside, boolean b_smart )
	//dprint_door( "auto_trigger_open_close: DEFAULTS" );
	auto_trigger_open_close( tv_volume, b_all, b_open_inside, b_smart, tv_volume, b_all, not b_open_inside, b_smart );
end
script static instanced void auto_trigger_open_close( trigger_volume tv_open, boolean b_open_all, boolean b_open_inside, boolean b_open_smart, trigger_volume tv_close, boolean b_close_all, boolean b_close_inside, boolean b_close_smart )
local boolean b_open = position_close_check();
local long l_thread = 0;
	//dprint_door( "auto_trigger_open_close: OBJECT" );

	repeat
	
		if ( b_open ) then
			l_thread = thread( auto_trigger_open(tv_open, b_open_all, b_open_inside, b_open_smart) );
		end
		if ( not b_open ) then
			l_thread = thread( auto_trigger_close(tv_close, b_close_all, b_close_inside, b_close_smart) );
		end
		sleep_until( not isthreadvalid(l_thread) or (not auto_enabled()), 1 );
		
		b_open = not b_open;
	until ( not auto_enabled(), 1 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUTO: TRIGGER: OPEN_CLOSE: OBJLIST
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === auto_trigger_objlist_open_close: XXX
script static instanced void auto_trigger_objlist_open_close( object_list obj_list, trigger_volume tv_open, boolean b_open_all, boolean b_open_inside, boolean b_open_smart, trigger_volume tv_close, boolean b_close_all, boolean b_close_inside, boolean b_close_smart )
local boolean b_open = position_close_check();
local long l_thread = 0;
	//dprint_door( "auto_trigger_objlist_open_close: OBJECT" );

	repeat

		// activate power
		sys_power_auto_enabled_active( TRUE );
	
		if ( b_open ) then
			l_thread = thread( auto_trigger_objlist_open(obj_list, tv_open, b_open_all, b_open_inside, b_open_smart) );
		end
		if ( not b_open ) then
			l_thread = thread( auto_trigger_objlist_close(obj_list, tv_close, b_close_all, b_close_inside, b_close_smart) );
		end
		sleep_until( not isthreadvalid(l_thread) or (not auto_enabled()), 1 );
		
		b_open = not b_open;
	until ( not auto_enabled(), 1 );

end
script static instanced void auto_trigger_objlist_open_close( object_list obj_list, trigger_volume tv_volume, boolean b_all, boolean b_open_inside, boolean b_smart )
	//dprint_door( "auto_trigger_objlist_open_close: DEFAULTS" );
	auto_trigger_objlist_open_close( obj_list, tv_volume, b_all, b_open_inside, b_smart, tv_volume, b_all, not b_open_inside, b_smart );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JITTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_jitter_open_range_min = 										0.5;
static real R_jitter_open_range_max = 										0.175;
static real R_jitter_close_range_min = 										0.0;
static real R_jitter_close_range_max = 										0.1;
static real R_jitter_delay_range_min = 										0.125;
static real R_jitter_delay_range_max = 										0.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === jitter_setup: XXX
script static instanced void jitter_setup( boolean b_enable, real r_open_position_min, real r_open_position_max, real r_close_position_min, real r_close_position_max, real r_delay_min, real r_delay_max )
	//dprint_door( "jitter_setup" );
	jitter_open_range_setup( r_open_position_min, r_open_position_max );
	jitter_close_range_setup( r_close_position_min, r_close_position_max );
	jitter_delay_range_setup( r_delay_min, r_delay_max );
	jitter_enabled( b_enable );
end

// === jitter_enabled: XXX
script static instanced void jitter_enabled( boolean b_enable )
	//dprint_door( "jitter_enabled: SET" );

	if ( b_enable != jitter_enabled() ) then

		// activate power
		sys_power_auto_enabled_active( TRUE );

		if ( b_enable ) then
			SetObjectLongVariable( this, DEF_VAR_INDEX_L_JITTERING, thread(sys_jitter_loop()) );
		else
			SetObjectLongVariable( this, DEF_VAR_INDEX_L_JITTERING, 0 );
		end

	end
	
end
script static instanced boolean jitter_enabled()
	isthreadvalid( GetObjectLongVariable(this, DEF_VAR_INDEX_L_JITTERING) );
end

// === jitter_open_range_setup: XXX
script static instanced void jitter_open_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "jitter_open_range_setup" );
	jitter_open_range_min( r_position_min );
	jitter_open_range_max( r_position_max );
end

// === jitter_open_range_min: XXX
script static instanced real jitter_open_range_min()
	R_jitter_open_range_min;
end
script static instanced void jitter_open_range_min( real r_position )
	//dprint_door( "jitter_open_range_min: SET" );

	// defaults
	if ( r_position < 0.0 ) then
		r_position = position_open_start();
	end
	R_jitter_open_range_min = position_bound( r_position );

end

// === jitter_open_range_max: XXX
script static instanced void jitter_open_range_max( real r_position )
	//dprint_door( "jitter_open_range_max: SET" );

	// defaults
	if ( r_position < 0.0 ) then
		r_position = position_open();
	end
	R_jitter_open_range_max = position_bound( r_position );

end
script static instanced real jitter_open_range_max()
	R_jitter_open_range_max;
end

// === jitter_close_range_setup: XXX
script static instanced void jitter_close_range_setup( real r_position_min, real r_position_max )
	//dprint_door( "jitter_close_range_setup" );
	jitter_close_range_min( r_position_min );
	jitter_close_range_max( r_position_max );
end

// === jitter_close_range_min: XXX
script static instanced void jitter_close_range_min( real r_position )
	//dprint_door( "jitter_close_range_min: SET" );

	// defaults
	if ( r_position < 0.0 ) then
		r_position = position_close();
	end
	R_jitter_close_range_min = position_bound( r_position );

end
script static instanced real jitter_close_range_min()
	R_jitter_close_range_min;
end

// === jitter_close_range_max: XXX
script static instanced real jitter_close_range_max()
	R_jitter_close_range_max;
end
script static instanced void jitter_close_range_max( real r_position )
	//dprint_door( "jitter_close_range_max: SET" );

	// defaults
	if ( r_position < 0.0 ) then
		r_position = position_close_start();
	end
	R_jitter_close_range_max = position_bound( r_position );

end

// === jitter_delay_range_setup: XXX
script static instanced void jitter_delay_range_setup( real r_delay_min, real r_delay_max )
	jitter_delay_range_min( r_delay_min );
	jitter_delay_range_max( r_delay_max );
end

// === jitter_delay_range_min: XXX
script static instanced void jitter_delay_range_min( real r_delay )
	//dprint_door( "jitter_delay_range_min: SET" );

	// defaults
	if ( r_delay < 0.0 ) then
		r_delay = 0.0;
	end
	R_jitter_delay_range_min = r_delay;

end
script static instanced real jitter_delay_range_min()
	R_jitter_delay_range_min;
end

// === jitter_delay_range_max: XXX
script static instanced void jitter_delay_range_max( real r_delay )
	//dprint_door( "jitter_delay_range_max: SET" );

	// defaults
	if ( r_delay < 0.0 ) then
		r_delay = 0.0;
	end
	R_jitter_delay_range_max = r_delay;

end
script static instanced real jitter_delay_range_max()
	R_jitter_delay_range_max;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_jitter_loop: XXX
script static instanced void sys_jitter_loop()
local boolean b_opening = ( random_range(0,1) == 0 );
local short s_cnt = random_range( 0,2 );
	//dprint_door( "sys_jitter_loop" );

	repeat

		// reset
		if ( s_cnt <= 0 ) then
			b_opening = not b_opening;
			s_cnt = random_range( 0,2 );
		end
		
		if ( b_opening ) then
			animate( speed_open(), real_random_range(jitter_open_range_min(), jitter_open_range_max()), TRUE );
		else
			animate( speed_close(), real_random_range(jitter_close_range_min(), jitter_close_range_max()), TRUE );
		end
		s_cnt = s_cnt - 1;

		// sleep delay time
		if ( jitter_enabled() ) then
			sleep_rand_s( jitter_delay_range_min(), jitter_delay_range_max() );
		end
		
	until ( not jitter_enabled(), 1 );

end 

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void set_jittering( boolean b_enable )
	jitter_enabled( b_enable );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CHAIN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short S_chain_state_equal()								0;		end
script static short S_chain_state_not_equal()						666;	end
script static short S_chain_state_less()								-1;		end
script static short S_chain_state_less_equal()					-2;		end
script static short S_chain_state_greater()							1;		end
script static short S_chain_state_greater_equal()				2;		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_chain_delay = 															0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === chain_delay: XXX
script static instanced void chain_delay( real r_delay )
	//dprint_door( "chain_delay: SET" );
	R_chain_delay = r_delay;
end
script static instanced real chain_delay()
	R_chain_delay;
end

// === chain_parent: XXX
script static instanced void chain_parent( device dm_parent, real r_parent_position, short s_state, real r_activate_position, real r_activate_speed )
	//dprint_door( "chain_parent" );
	
	if ( s_state == S_chain_state_equal() ) then
		sleep_until( device_get_position(dm_parent) == r_parent_position, 1 );
	end
	if ( s_state == S_chain_state_not_equal() ) then
		sleep_until( device_get_position(dm_parent) != r_parent_position, 1 );
	end
	if ( s_state == S_chain_state_less() ) then
		sleep_until( device_get_position(dm_parent) < r_parent_position, 1 );
	end
	if ( s_state == S_chain_state_less_equal() ) then
		sleep_until( device_get_position(dm_parent) <= r_parent_position, 1 );
	end
	if ( s_state == S_chain_state_greater() ) then
		sleep_until( device_get_position(dm_parent) > r_parent_position, 1 );
	end
	if ( s_state == S_chain_state_greater_equal() ) then
		sleep_until( device_get_position(dm_parent) >= r_parent_position, 1 );
	end
	
	//dprint_door( "chain_parent: DELAY" );
	sleep_s( chain_delay() );
	animate( r_activate_speed, r_activate_position, FALSE );
	
end

// === chain_parent_open: XXX
script static instanced void chain_parent_open( device dm_parent, real r_parent_position, short s_state )
	//dprint_door( "chain_parent_open: DEFAULTS" );
	thread( chain_parent(dm_parent, r_parent_position, s_state, open_position(), speed_get_open()) );
end
script static instanced void chain_parent_open( device dm_parent, real r_parent_position, short s_state, real r_activate_speed )
	//dprint_door( "chain_parent_open: SPEEDS" );
	thread( chain_parent(dm_parent, r_parent_position, s_state, open_position(), r_activate_speed) );
end

// === chain_parent_close: XXX
script static instanced void chain_parent_close( device dm_parent, real r_parent_position, short s_state )
	//dprint_door( "chain_parent_close: DEFAULTS" );
	thread( chain_parent(dm_parent, r_parent_position, s_state, close_position(), speed_get_close()) );
end
script static instanced void chain_parent_close( device dm_parent, real r_parent_position, short s_state, real r_activate_speed )
	//dprint_door( "chain_parent_close: SPEEDS" );
	thread( chain_parent(dm_parent, r_parent_position, s_state, close_position(), r_activate_speed) );
end

// COMPATABILITY ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
script static instanced void chain_delay_set( real r_delay )
	chain_delay( r_delay );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DEBUG
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced boolean B_door_debug_this =									FALSE;
static boolean B_door_debug_type =										FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === debug_type: XXX
script static void debug_type( boolean b_debug )
	B_door_debug_type = b_debug;
end
script static boolean debug_type()
	B_door_debug_type;
end

// === debug_this: XXX
script static instanced void debug_this( boolean b_debug )
	B_door_debug_this = b_debug;
end
script static instanced boolean debug_this()
	B_door_debug_this;
end

// === dprint_door: XXX
script static instanced void dprint_door( string str_debug )

//	if ( debug_type() or debug_this() ) then
		dprint( str_debug );
//	end
	
end







// OLD
/*
// === XXX::: XXX
script static instanced void speed_set_type( string str_type )
static real r_speed = 0.0;
	r_speed = speed_type_get( str_type );

	speed_set_open( r_speed );
	speed_set_close( r_speed );
end

// === XXX::: XXX
script static instanced real speed_type_get( string str_type )
static real r_return = 0.0;
	r_return = 0.0;

	if ( str_type == "VERY_SLOW" ) then
		r_return = speed_very_slow();
	end
	
	if ( str_type == "SLOW" ) then
		r_return = speed_slow();
	end

	if ( str_type == "DEFAULT" ) then
		r_return = speed_default();
	end

	if ( str_type == "FAST" ) then
		r_return = speed_fast();
	end
	
	if ( str_type == "VERY_FAST" ) then
		r_return = speed_very_fast();
	end
	
	// return
	r_return;
end

// === XXX::: XXX
script static instanced void speed_set_close_type( string str_type )
	//dprint_door( "speed_set_close_type" );
	speed_set_close( speed_type_get(str_type));
end

// === XXX::: XXX
script static instanced void speed_set_open_type( string str_type )
	//dprint_door( "speed_set_open_type" );
	speed_set_open( speed_type_get(str_type) );
end

*/
/*
// -------------------------------------------------------------------------------------------------
// SOUND
// -------------------------------------------------------------------------------------------------

// ------ Control audio playback ---------
// Called when open animation starts. The door could be starting in any position.
script static instanced void sound_open_play()
	//dprint_door( "global_door::sound_open_play" );

	B_door_animation_cancelled = FALSE;
	
	// stop the close end sound in case it's still playing
	if (SND_sound_disengage_close != NONE) then
		sound_impulse_stop( SND_sound_disengage_close );
	end
	
	// play the open start noise if we're starting from the fully closed position
	if ( position() <= (close_position() + 0.01) and (SND_sound_engage_open != NONE) ) then
		//dprint_door( "sound_open_play: check_close()" );
		sound_impulse_start( SND_sound_engage_open, this, 1 );
	end

	// start looping sound
	if (SND_sound_loop_open != NONE) then 
		sound_looping_start(SND_sound_loop_open, this, 1 );
	end
end

// setup when animating
script static instanced void sound_end_wait( real r_position, boolean b_opening )

	// wait for the animation to finish or get cancelled
	sleep_until( (position() == r_position) or (r_position != animate_target_position()) or B_door_animation_cancelled, 1 );

	// if it got all the way to the end position, play the end sounds
	if ( (position() == r_position) and (r_position == animate_target_position()) ) then
		if (b_opening) then
			sound_open_end_play();
		else
			sound_close_end_play();
		end
	end

end

// Called when open animation is cancelled.
script static instanced void sound_open_cancel()
	//dprint_door( "global_door::sound_open_cancel" );

	B_door_animation_cancelled = TRUE;
	
	// stop the open start sound in case it's still playing
	if (SND_sound_engage_open != NONE) then
		sound_impulse_stop( SND_sound_engage_open );
	end
	
	// stop looping sound
	if (SND_sound_loop_open != NONE) then 
		sound_looping_stop(SND_sound_loop_open);
	end
end

// Called when open animation ends naturally.
script static instanced void sound_open_end_play()
	//dprint_door( "global_door::sound_open_end_play" );

	B_door_animation_cancelled = TRUE;
	
	// stop the open start sound in case it's still playing
	if (SND_sound_engage_open != NONE) then
		sound_impulse_stop( SND_sound_engage_open );
	end
	
	// stop looping sound
	if (SND_sound_loop_open != NONE) then 
		sound_looping_stop(SND_sound_loop_open);
	end
	
	// play open end sound
	if ( (SND_sound_disengage_open != NONE) ) then
		sound_impulse_start(SND_sound_disengage_open, this, 1 );
	end
end

// Called when the close animation starts. The door could be starting in any position.
script static instanced void sound_close_play()
	//dprint_door( "global_door::sound_close_play" );

	B_door_animation_cancelled = FALSE;
	
	// stop the start end sound in case it's still playing
	if (SND_sound_disengage_open != NONE) then
		sound_impulse_stop( SND_sound_disengage_open );
	end
	
	// only play the close start sound if starting from the fully open position
	if ( position() >= (open_position() - 0.01) and (SND_sound_engage_close != NONE) ) then
		sound_impulse_start( SND_sound_engage_close, this, 1 );
	end

	// start looping sound
	if (SND_sound_loop_close != NONE) then 
		sound_looping_start(SND_sound_loop_close, this, 1 );
	end
end

// Called when close animation is cancelled.
script static instanced void sound_close_cancel()
	//dprint_door( "global_door::sound_close_cancel" );

	B_door_animation_cancelled = TRUE;
	
	// stop the close start sound in case it's still playing
	if (SND_sound_engage_close != NONE) then
		sound_impulse_stop( SND_sound_engage_close );
	end
	
	// stop looping sound
	if (SND_sound_loop_close != NONE) then 
		sound_looping_stop(SND_sound_loop_close);
	end
end

// Called when close animation ends naturally.
script static instanced void sound_close_end_play()
	//dprint_door( "global_door::sound_close_end_play" );

	B_door_animation_cancelled = TRUE;
	
	// stop the close start sound in case it's still playing
	if (SND_sound_engage_close != NONE) then
		sound_impulse_stop( SND_sound_engage_close );
	end
	
	// stop looping sound
	if (SND_sound_loop_close != NONE) then 
		sound_looping_stop(SND_sound_loop_close);
	end
	
	// play the close end sound
	if ( (SND_sound_disengage_close != NONE) ) then
		sound_impulse_start(SND_sound_disengage_close, this, 1 );
	end
end
*/
