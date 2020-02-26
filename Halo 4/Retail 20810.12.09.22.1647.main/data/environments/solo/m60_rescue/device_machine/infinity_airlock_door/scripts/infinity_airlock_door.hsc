//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 60_rescue
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
	device_set_position_track(this, 'any:idle', 0);
   
  	sound_open_set( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_open');
	sound_close_set( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_close' );
end
