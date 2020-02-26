//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
		device_set_overlay_track( this, 'any:idle' );

end

script static instanced void animate_rotate()

	device_animate_overlay( this, 0.5, 0.25, 0, 0 );
	
end

script static instanced void animate_close()

	device_animate_overlay( this, 1.0, 0.375, 0, 0 );
	
end
	 