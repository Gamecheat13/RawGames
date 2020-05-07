//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
		device_set_position_track( this, 'any:idle', 0 );

end
 
 script static instanced void start()
 device_animate_position( this, 1, 51, 0.1, 0.1, TRUE);
 sleep(1530); 
thread(loop_01());
 end
 
 script static instanced void start_loop()
 device_set_position(this, 0.175);
 device_animate_position( this, 1, 80, 0.1, 0.1, TRUE);
 sleep(2400);
 thread(loop_01());
 end
 
 script static instanced void loop_01()
 device_set_position(this, 0.175);
 device_animate_position( this, 1, 80, 0.1, 0.1, TRUE);
 sleep(2400);
 thread(loop_02());
 end
 
 script static instanced void loop_02()
 device_set_position(this, 0.175);
 device_animate_position( this, 1, 80, 0.1, 0.1, TRUE);
 sleep(2400);
 thread(loop_01());
 end