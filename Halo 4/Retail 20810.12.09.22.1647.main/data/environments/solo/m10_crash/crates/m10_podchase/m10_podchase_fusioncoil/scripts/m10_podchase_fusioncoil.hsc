//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// a generic panel that disables physics until needed
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced init()
static real DEF_R_DEG_MIN = -180.0;
static real DEF_R_DEG_MAX = 180.0;

	object_set_gravity( this, 0.0, FALSE );
	object_set_scale( this, 2.5, 0 );
	//object_rotate_by_offset(this, 0, 0, 0, real_random_range(DEF_R_DEG_MIN,DEF_R_DEG_MAX), real_random_range(DEF_R_DEG_MIN,DEF_R_DEG_MAX), real_random_range(DEF_R_DEG_MIN,DEF_R_DEG_MAX) );
	
end
