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
//dprint("track set");	
end

script static instanced void exit()
	//dprint("animate 67% over 3 seconds");
	device_animate_position( this, 1, 5, 0.1, 0.1, TRUE );
	//dprint("animations go");
end 


script static instanced void temp()
//dprint("animate 100% over 2 seconds");
device_animate_position( this, 1, 2, 0.1, 0.1, TRUE );
//dprint("animations go");
end 