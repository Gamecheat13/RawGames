//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("observation deck supports set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	dprint ("observation deck support is moving");

	device_animate_position (this, 1.0, 3.5, 0.1, 0.1, TRUE);
	
end