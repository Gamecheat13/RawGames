//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// DEFINES
global short DEF_S_START_FRAME = 0;
global short DEF_S_END_FRAME = 25;

global short DEF_S_MONITOR_DROP_FRONT = 2;
global short DEF_S_MONITOR_DROP_REAR = 10;

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate_full( real r_time )
static real r_play_time = 0.0;

	if ( r_time >= 0.0 ) then
		r_play_time = r_time;
	else
		r_play_time = 1.25;
	end

	if ( device_get_position(this) == 0.0 ) then
		device_animate_position( this, 1.0, r_play_time, 0, 0, FALSE );
	end
	
end

script static instanced void front_monitor_detach( object c_monitor )
	// wait until it's ready to release
	sleep_until( device_get_position(this) > ((DEF_S_MONITOR_DROP_FRONT-DEF_S_START_FRAME)/(DEF_S_END_FRAME-DEF_S_START_FRAME)), 1 );
	//dprint( "::: front_monitor_detach :::" );
	
	// release the monitor
	objects_detach( this, c_monitor );
	
end

script static instanced void rear_monitor_detach( object c_monitor )
	// wait until it's ready to release
	sleep_until( device_get_position(this) > ((DEF_S_MONITOR_DROP_REAR-DEF_S_START_FRAME)/(DEF_S_END_FRAME-DEF_S_START_FRAME)), 1 );
	//dprint( "::: rear_monitor_detach :::" );
	
	// release the monitor
	objects_detach( this, c_monitor );
	
end
