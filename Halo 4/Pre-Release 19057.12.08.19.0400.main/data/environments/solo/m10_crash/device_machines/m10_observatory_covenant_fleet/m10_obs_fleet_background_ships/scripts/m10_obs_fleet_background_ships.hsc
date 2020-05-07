//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );
	//device_set_overlay_track( this, 'any:idle' );
	
end

script static instanced void launch()
	//dprint("animate 100% over 60 seconds");
	device_animate_position( this, 1, 40, 0.1, 0.1, TRUE );
	//device_animate_overlay ( this, 60, 1, 0.1, 0.1);
	//dprint("animations go");
end 

script static instanced void reset()
//device_animate_overlay ( this, 1, 0, 0.1, 0.1);
device_animate_position( this, 0, 1, 0, 0, TRUE );
	
end 