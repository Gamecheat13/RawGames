//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m60
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
 	print ("infinity rock fall has been set up");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_animate()

	print ("rocks falling");
//	device_set_position_track(	this, 'any:idle', 1 );
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_rock_fall', this, 1 ); //AUDIO!
	device_animate_position (this, 1, 10.0, 0.1, 0.1, TRUE);

end