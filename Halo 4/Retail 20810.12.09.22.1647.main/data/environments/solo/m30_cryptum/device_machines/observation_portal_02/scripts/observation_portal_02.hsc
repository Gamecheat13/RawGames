//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// observation_portal_02
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("portal 2 set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	dprint ("portal 2 opening");

	device_animate_position (this, 1.0, 7.0, 0.1, 0.1, TRUE);
	
end