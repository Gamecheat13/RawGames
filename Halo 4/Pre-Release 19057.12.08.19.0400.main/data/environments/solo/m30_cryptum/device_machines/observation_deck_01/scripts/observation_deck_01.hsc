//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// observation deck 1
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("observation deck set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	dprint ("observation deck moving");

	device_animate_position (this, 1.0, 3.5, 0.1, 0.1, TRUE);
	
end