//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced f_init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void open()

	device_animate_position( this, 1, 4.5, 0, 0, TRUE );   
	sound_impulse_start( 'sound\environments\solo\m010\placeholder\beacon_deck\m_m10_placeholder_beacon_doors_opening', this, 1 );
	sleep_until( check_open(), 1 );
	
end 

script static instanced void destroy()
	device_animate_position( this, 1.0, 5, 0, 0, TRUE );   
end 


script static instanced void open_instant()

	device_animate_position( this, 1.0, 0.0, 0, 0, FALSE );   
	sleep_until( check_open(), 1 );
	
end 

script static instanced boolean check_open()
	device_get_position(this) == 0.550833;
end

script static instanced boolean check_close()
	device_get_position(this) == 0.0;
end
