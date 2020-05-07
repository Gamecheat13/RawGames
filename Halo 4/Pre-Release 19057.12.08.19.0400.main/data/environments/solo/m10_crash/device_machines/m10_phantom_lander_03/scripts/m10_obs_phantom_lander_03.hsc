//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()
//dprint("set track");
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );
	//device_set_overlay_track( this, 'any:idle' );
//dprint("track set");	
end

script static instanced void launch()
	//dprint("animate 100% over 60 seconds");
	device_animate_position( this, 1, 6, 0.1, 0.1, TRUE );
	//device_animate_overlay ( this, 1, 1, 1, 1);
	//dprint("animations go");
end 


script static instanced void reset()
//device_animate_overlay ( this, 0, 1, 0.1, 0.1);
//dprint("reset animation in 2 seconds");
device_animate_position( this, 0, 2, 0, 0, TRUE );
//dprint("animation reset");
end 