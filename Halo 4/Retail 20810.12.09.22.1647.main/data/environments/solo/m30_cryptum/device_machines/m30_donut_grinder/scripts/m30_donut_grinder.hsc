//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_donut_device
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

static real datt = 3; // device animtation time total
static real dcp = 1; //device complete percentage 0-1 

script startup instanced f_init()
 	print ("set it's base overlay animation to 'any:idle'");
  device_set_position_track(	this, 'any:idle', 0 );
end

script static instanced void f_animate()

	print ("donut grinder is spinning");

	device_animate_position (this, 1.0, 4, 0.1, 0.1, TRUE);

end


//script static instanced void check_animation()
//	sleep_until( dcp == 0.666);
//	datt = 0.5;
//	sleep_until(device_get_position (this) == 0.666, 1);
//	print ("speeding up");
//	datt = 1;

//dcp = 1;
//end

