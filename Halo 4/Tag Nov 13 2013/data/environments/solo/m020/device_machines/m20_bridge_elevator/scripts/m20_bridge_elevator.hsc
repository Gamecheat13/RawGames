//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					XXX
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced obj_init()

	dprint( "BRIDGE ELEVATOR INIT" );

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate()
local real r_time = 8.0;
local real r_pos = 1.0;

	dprint( "ANIMATE!!!" );
	
	sound_looping_start ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_bridge_elevator_loop', this, 1 ); // Start looping sound	
	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );
	
	sleep_until( device_get_position(this) == r_pos, 1 );
	sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_bridge_elevator_loop' ); // Stop looping sound
end