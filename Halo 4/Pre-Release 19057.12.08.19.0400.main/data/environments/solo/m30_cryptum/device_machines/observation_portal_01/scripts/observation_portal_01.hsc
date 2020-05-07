//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// observation_portal_1
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("portal 1 set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	dprint ("portal 1 opening");

	device_animate_position (this, 1.0, 7.0, 0.1, 0.1, TRUE);
	
end

script static instanced void f_animate_instant()

	dprint ("portal 1 opening instantly");

	device_animate_position (this, 1.0, 0.1, 0.1, 0.1, TRUE);
	//device_set_position_track(this, 'any:idle', 1);
	
end
