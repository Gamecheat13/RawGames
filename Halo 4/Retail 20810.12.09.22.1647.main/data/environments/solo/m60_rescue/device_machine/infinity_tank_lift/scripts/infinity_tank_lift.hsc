//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m60
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("infinity tank lift has been set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	print ("infinity elevator going up");
//	device_set_position_track(	this, 'any:idle', 1 );
	device_animate_position (this, 1, 10.0, 0.1, 0.1, TRUE);

end