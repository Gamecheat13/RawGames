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

script static instanced void open()

	device_animate_overlay( this, 1, 3.75, 0, 0 );
	
end 

script static instanced void close()

	device_animate_overlay( this, 0.0, 2.5, 0, 0 );
	
end 

script static instanced boolean check_close()
	device_get_position(this) == 0.0;
end
