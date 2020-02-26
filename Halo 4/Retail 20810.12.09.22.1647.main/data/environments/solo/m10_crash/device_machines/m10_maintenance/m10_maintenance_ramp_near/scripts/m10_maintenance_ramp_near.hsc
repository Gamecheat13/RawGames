//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343


global short L_frame_start 				= 0;
global short L_frame_end					= 100;

global short L_frame_physics 			= 3;
global short L_frame_drop_start 	= 50;
global short L_frame_drop_end 		= 75;

// === init: init function
script startup instanced init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );

end

script static instanced void break( real r_time, trigger_volume tv_volume_top, trigger_volume tv_volume_bottom )

	// animate
	device_animate_position( this, 1.0, r_time, 0.1, 0, TRUE );
	
	sleep_until( device_get_position(this) >= (L_frame_physics/(L_frame_end-L_frame_start)), 1 );
	thread( triggerobjs_setvelocity_rand(tv_volume_top, s_objtype_weapon+s_objtype_equipment+s_objtype_crate, -0.125, 0.125, -0.125, 0.125, 0.75, 1.25) );

	sleep_until( device_get_position(this) >= 0.975, 1 );
	thread( triggerobjs_setvelocity_rand(tv_volume_bottom, s_objtype_weapon+s_objtype_equipment+s_objtype_crate, -0.0625, 0.0625, -0.0625, 0.0625, 0.375, 0.625) );
	
end 

script static real drop_frame_random()
	random_range(L_frame_drop_start,L_frame_drop_end)/(L_frame_end-L_frame_start);
end