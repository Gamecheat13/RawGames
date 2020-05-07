//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_donut_device
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

static real datt = 3; // device animtation time total
static real dcp = 1; //device complete percentage 0-1 
global boolean b_pylon1_off = FALSE;


script startup instanced f_init()
 	print ("pylon eye has been set up");
  device_set_position_track(this, 'any:idle', 0);
  

  
end

script static instanced void f_animate_loop(device switch, device shaft)
  
//	device_set_position_track(	this, 'any:idle', 1 );
	repeat
		
		device_set_position_track(this,'any:idle', 0);
		dprint ("pylon eye looping");
		device_animate_position (this, 0.5, 3.0, 0.1, 0.1, TRUE);
		sleep_until (device_get_position (this) >= 0.5);
	until ((device_get_position (switch) != 0), 1);
	
	dprint ("pylon eye shutting down");
	device_animate_position (this, 1, 3.0, 0.1, 0.1, TRUE);
 	
 	sleep_until (device_get_position (this) == 1);
 	
 	objects_attach (shaft, "pylon1_beam_shaft", this, "");
end

//

//script static instanced void check_animation()
//	sleep_until( dcp == 0.666);
//	datt = 0.5;
//	sleep_until(device_get_position (this) == 0.666, 1);
//	print ("speeding up");
//	datt = 1;

//dcp = 1;
//end

/*

script startup instanced f_init()
	// set it's base overlay animation to 'any:idle'
	device_set_overlay_track( this, 'any:idle' );

end

	static real datt = 15;		// device animatation time total
	static real dat = 0.50;			// device animation time

	device_set_position_track( this, 'any:idle', 0 );
	device_animate_position( this, dat, datt, 1, 0.1, 0 );

script static void 

/*
// DEFINES
global real DEF_PANELDOOR_MED_SLOW = 4.5;
global real DEF_PANELDOOR_MED_DEFAULT = 3.25;
global real DEF_PANELDOOR_MED_FAST = 1.75;

// object variables
global long VAR_R_OPEN_SPEED = 1;
global long VAR_R_CLOSE_SPEED = 2;
global long VAR_L_JITTERING = 3;

// door positions
global real r_door_open_position = 1.0;
global real r_door_close_position = 0.0;

// jitter variables
global real r_jitter_open_min = 0.05;
global real r_jitter_open_max = 0.175;

global real r_jitter_close_min = 0.0;
global real r_jitter_close_max = 0.1;

global real r_jitter_delay_min = 0.125;
global real r_jitter_delay_max = 0.5;

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', r_door_close_position );
	
	// initialize variables
	speed_set_open( DEF_PANELDOOR_MED_DEFAULT );
	speed_set_close( DEF_PANELDOOR_MED_DEFAULT );
	set_jittering( FALSE );

end

// -------------------------------------------------------------------------------------------------
// CHECK STATE
// -------------------------------------------------------------------------------------------------
// === check: checks the door state
script static instanced boolean check_open()
	device_get_position(this) == r_door_open_position;
end
script static instanced boolean check_closed()
	device_get_position(this) == r_door_close_position;
end

// -------------------------------------------------------------------------------------------------
// SPEEDS
// -------------------------------------------------------------------------------------------------
// === speed: speed functions
script static instanced real speed_slow()
	DEF_PANELDOOR_MED_SLOW;
end
script static instanced real speed_default()
	DEF_PANELDOOR_MED_DEFAULT;
end
script static instanced real speed_fast()
	DEF_PANELDOOR_MED_FAST;
end
script static instanced void speed_set( real r_speed )
	speed_set_open( r_speed );
	speed_set_close( r_speed );
end
script static instanced void speed_set_open( real r_speed )
	SetObjectRealVariable( this, VAR_R_OPEN_SPEED, r_speed );
end
script static instanced void speed_set_open_type( string str_type )

	if ( str_type == "SLOW" ) then
		speed_set_open( speed_slow() );
	end
	
	if ( str_type == "DEFAULT" ) then
		speed_set_open( speed_default() );
	end

	if ( str_type == "FAST" ) then
		speed_set_open( speed_fast() );
	end
	
end
script static instanced void speed_set_close( real r_speed )
	SetObjectRealVariable( this, VAR_R_CLOSE_SPEED, r_speed );
end
script static instanced void speed_set_close_type( string str_type )

	if ( str_type == "SLOW" ) then
		speed_set_close( speed_slow() );
	end
	
	if ( str_type == "DEFAULT" ) then
		speed_set_close( speed_default() );
	end

	if ( str_type == "FAST" ) then
		speed_set_close( speed_fast() );
	end
	
end
script static instanced real speed_get_open()
	GetObjectRealVariable( this, VAR_R_OPEN_SPEED );
end
script static instanced real speed_get_close()
	GetObjectRealVariable( this, VAR_R_CLOSE_SPEED );
end

// -------------------------------------------------------------------------------------------------
// OPEN
// -------------------------------------------------------------------------------------------------
// === open: open functions
script static instanced void open_speed( real r_speed )

	device_animate_position( this, r_door_open_position, r_abs((r_door_open_position - device_get_position(this))*r_speed), 0, 0, TRUE );
	sleep_until( check_open(), 1 );
	
end 
script static instanced void open_slow()
	open_speed( speed_slow() );
end 
script static instanced void open_default()
	open_speed( speed_default() );
end 
script static instanced void open_fast()
	open_speed( speed_fast() );
end 
script static instanced void open_instant()
	open_speed( 0.0 );
end 
script static instanced void open()
	open_speed( speed_get_open() );
end 

// -------------------------------------------------------------------------------------------------
// CLOSE
// -------------------------------------------------------------------------------------------------
// === close: close functions
script static instanced void close_speed( real r_speed )

	device_animate_position( this, r_door_close_position, r_abs((device_get_position(this) - r_door_close_position)*r_speed), 0, 0, TRUE );
	sleep_until( check_closed(), 1 );

end 
script static instanced void close_slow()
	close_speed( speed_slow() );
end 
script static instanced void close_default()
	close_speed( speed_default() );
end 
script static instanced void close_fast()
	close_speed( speed_fast() );
end 
script static instanced void close_instant()
	close_speed( 0.0 );
end 
script static instanced void close()
	close_speed( speed_get_close() );
end

// -------------------------------------------------------------------------------------------------
// AUTO DISTANCE
// -------------------------------------------------------------------------------------------------
// XXX ADD SUPPORT FOR PARTIAL OPEN/CLOSE
// === auto distance: handles automatic opening/closing with distances
script static instanced void auto_distance_open_close( real r_open_distance, real r_close_distance )

	thread( auto_distance_open(r_open_distance) );
	sleep_until( check_open(), 1 );
	
	thread( auto_distance_close(r_close_distance) );
	sleep_until( check_closed(), 1 );

	thread( auto_distance_open_close(r_open_distance,r_close_distance) );

end

script static instanced void auto_distance( real r_distance )

	auto_distance_open_close( r_distance, r_distance );

end

script static instanced void auto_distance_open( real r_distance )
	sleep_until( objects_distance_to_object(players(),this) <= r_distance, 1 );

	open();

end

script static instanced void auto_distance_close( real r_distance )
	sleep_until( objects_distance_to_object(players(),this) > r_distance, 1 );

	close();

end

// -------------------------------------------------------------------------------------------------
// AUTO TRIGGER
// -------------------------------------------------------------------------------------------------
// XXX ADD SUPPORT FOR PARTIAL OPEN/CLOSE
script static instanced void auto_trigger_open_close( trigger_volume tv_open, boolean b_openall, trigger_volume tv_close, boolean b_closeall )

	thread( auto_trigger_open(tv_open, b_openall) );
	sleep_until( check_open(), 1 );
	
	thread( auto_trigger_close(tv_close, b_closeall) );
	sleep_until( check_closed(), 1 );

	thread( auto_trigger_open_close(tv_open, b_openall, tv_close, b_closeall) );

end

script static instanced boolean auto_trigger_open( trigger_volume tv_open, boolean b_openall )
	sleep_until( (volume_test_players_all(tv_open)) or (not b_openall and volume_test_players(tv_open)), 1 );

	open();
	
	(volume_test_players_all(tv_open)) or (not b_openall and volume_test_players(tv_open));

end

script static instanced boolean auto_trigger_close( trigger_volume tv_close, boolean b_closeall )
	sleep_until( (volume_test_players_all(tv_close)) or (not b_closeall and volume_test_players(tv_close)), 1 );
	
	close();
	
	(volume_test_players_all(tv_close)) or (not b_closeall and volume_test_players(tv_close));

end

// -------------------------------------------------------------------------------------------------
// JITTER
// -------------------------------------------------------------------------------------------------
// === jitter: functions that make the door jitter
script static instanced void set_jittering( boolean b_enable )
	
	if ( not(b_enable) ) then
		SetObjectLongVariable( this, VAR_L_JITTERING, 0 );
	elseif ( not(get_jittering()) ) then
		SetObjectLongVariable( this, VAR_L_JITTERING, 1 );
		thread( jitter_loop() );
	end
	
end

script static instanced boolean get_jittering()
	GetObjectLongVariable( this, VAR_L_JITTERING ) == 1;
end

script static instanced void jitter_loop()

	// jitter open
	if ( get_jittering() ) then
		jitter_action( r_jitter_open_min, r_jitter_open_max, r_jitter_delay_min, r_jitter_delay_max, speed_get_open() );
	end

	// jitter closed
	if ( get_jittering() ) then
		jitter_action( r_jitter_close_min, r_jitter_close_max, r_jitter_delay_min, r_jitter_delay_max, speed_get_close() );
	end

	// rethread
	if ( get_jittering() ) then
		thread( jitter_loop() );
	end

end 

script static instanced void jitter_action( real r_min_pos, real r_max_pos, real r_min_delay, real r_max_delay, real r_speed )
static real r_pos = 0.0;
static real r_time = 0.0;
static long l_tick = 0;

	if ( get_jittering() ) then
	
		// get new target position
		r_pos = real_random_range( r_min_pos, r_max_pos );

		// get the time to animate
		r_time = (r_abs(device_get_position(this)-r_pos))*r_speed;
		
		// animate to new position
		device_animate_position( this, r_pos, r_time , 0, 0, FALSE );
		
		// target time to animate
		l_tick = game_tick_get() + (r_time * 30);
		
		// wait until it's animated to new position
		sleep_until( (device_get_position(this)==r_pos) or (game_tick_get() > l_tick), 1 );

	end

	if ( get_jittering() ) then

		// sleep delay time
		sleep_rand_s( r_min_delay, r_max_delay );
		
	end

end

// XXX TEMP
script static real r_abs( real r_val )
	if ( r_val < 0 ) then
		-r_val;
	else
		r_val;
	end
end
*/