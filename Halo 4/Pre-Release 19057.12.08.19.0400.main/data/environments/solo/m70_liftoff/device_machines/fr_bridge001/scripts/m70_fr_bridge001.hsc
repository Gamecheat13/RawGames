//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70_LIFTOFF_FLIGHT
// script for the device machine: M70_SPIRE_01_EXTERIOR_DOOR_02
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//FUNCTION INDEX

// === f_init: init function
script startup instanced init()
	device_set_position_track( this, 'any:idle', 0 );
end

//MAIN FUNCTIONS

script static instanced void activate( real animation_time)
	device_animate_position(this, 1, animation_time, 0.1, 0.1, TRUE);
end

script static instanced void reset()
	device_animate_position(this, 0, 0, 0.1, 0.1, TRUE);
end
