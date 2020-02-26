//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// a generic panel that disables physics until needed
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced init()

	object_set_gravity( this, 0.0, FALSE );
	begin_random_count(1)
		object_set_variant( this, "debris_01" );
		object_set_variant( this, "debris_02" );
		object_set_variant( this, "debris_03" );
		object_set_variant( this, "debris_04" );
		object_set_variant( this, "debris_05" );
	end
	
end