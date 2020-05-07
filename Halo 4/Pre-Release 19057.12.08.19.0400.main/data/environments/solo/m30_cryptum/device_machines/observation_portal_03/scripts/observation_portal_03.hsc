//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// observation portal 3
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("portal 3 set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	dprint ("portal 3 opening");

	device_animate_position (this, 1.0, 3.5, 0.1, 0.1, TRUE);
	
end