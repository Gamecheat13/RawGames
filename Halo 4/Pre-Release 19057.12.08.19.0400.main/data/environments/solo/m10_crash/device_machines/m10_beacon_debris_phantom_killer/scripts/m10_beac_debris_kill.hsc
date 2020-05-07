//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
// === f_init: init function

//global boolean killer = TRUE;

script static instanced void launch()
	//dprint("animate 100% over 60 seconds");
	
	device_set_position_track( this, 'any:idle', 0.0 );
	//dprint("spam");
	//object_hide(this, false);
	device_animate_position( this, 0.6, 2, 0.1, 0.1, TRUE );
	sleep_until(device_get_position(this) >= 0.59, 1);
	effect_new_on_object_marker (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, this, "m_boom");
	//sleep_s(2);
	device_animate_position( this, 1, 3, 0.1, 0.1, TRUE );
	//sleep(90);
//
//	sleep(90);
	//dprint("animations go");
	//until(not killer);
end 

script static instanced void reset()
device_animate_position( this, 0, 1, 0, 0, TRUE );
end 