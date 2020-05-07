//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343



script startup instanced f_init()
 	dprint ("prober b");
  device_set_position_track(this, 'any:idle', 0);
 
end

script static instanced void f_set_open( real time )
	dprint("set wall mover open" );
  device_animate_position( this, 0.0, time, 0.1, 0.0, TRUE );

 
end

script static instanced void f_set_closed( real time )
	dprint("set wall mover closed" );
  device_animate_position( this, 1.0, time, 0.1, 0.0, TRUE );

end


