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

script static instanced void launch()
	effect_new_on_object_marker_loop (objects\props\covenant\drop_pod_elite_cheap\fx\contrail\drop_pod_trail_atmospheric.effect, this, m_beacon);
	device_animate_position( this, 1, 6.0, 0.1, 0.1, TRUE );
	
end 