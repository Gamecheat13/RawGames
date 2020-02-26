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

	dprint ("donut_elevator is now looping");

	repeat

		device_animate_position (this, 1.0, 3.0, 0.1, 0.1, TRUE);
		device_set_position_track (this, 'any:idle', 0);
		
	until (1 == 0);
	
end
