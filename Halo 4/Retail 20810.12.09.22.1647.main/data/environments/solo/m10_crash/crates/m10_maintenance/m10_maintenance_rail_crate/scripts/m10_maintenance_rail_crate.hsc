//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// a generic panel that disables physics until needed
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

global real R_chain_parent_pos_default = 0.05;

// === f_init: init function
script startup instanced init()

	if ( editor_mode() ) then
		object_set_physics( this, FALSE );
	end

end

script static instanced void chain_release( device dm_parent, real r_parent_pos, object o_attached, real r_delay_min, real r_delay_max )

	if ( o_attached == NONE ) then
		object_set_physics( this, FALSE );
	end

	// wait for parent position
	if ( r_parent_pos < 0 ) then
		r_parent_pos = R_chain_parent_pos_default;
	end

	sleep_until( (dm_parent == NONE) or (device_get_position(dm_parent) >= r_parent_pos), 1 );
	
	if ( o_attached != NONE ) then
		objects_detach( o_attached, this );
	end

	// delay the chain
	sleep_rand_s( r_delay_min, r_delay_max );

	// fire the open eject sequence
	object_set_physics( this, TRUE );
	object_wake_physics( this );

end


