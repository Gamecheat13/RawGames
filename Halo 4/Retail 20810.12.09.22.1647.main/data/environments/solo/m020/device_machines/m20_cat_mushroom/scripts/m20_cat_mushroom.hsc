//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					XXX
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced obj_init()

	dprint( "MUSHROOM PLATFORM INIT" );

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate()
local real r_time = 8.0;
local real r_pos = 1.0;

	dprint( "ANIMATE!!!" );
	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_platform_rise', this, 1 );
	//sleep_until( device_get_position(this) == r_pos, 1 );
		
end