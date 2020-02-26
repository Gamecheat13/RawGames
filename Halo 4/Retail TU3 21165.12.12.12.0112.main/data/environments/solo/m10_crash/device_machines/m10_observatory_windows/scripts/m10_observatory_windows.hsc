//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

script startup instanced f_init()
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void open()

device_animate_position( this, 1, 8, 0.1, 0.1, TRUE);

//device_animate_position( this, 1, 15, 1, 1, 1 );

end


script static instanced void close()

device_animate_position( this, 0, 1, 0.1, 0.1, TRUE);

//device_animate_position( this, 0, 15, 1, 1, 1 );

end

