//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

global long L_frame_start = 0;
global long L_frame_end = 35;
global real L_frame_eject = 35.0;

global real R_eject_velocity_x = 3.0;
global real R_eject_velocity_y = 0.0;
global real R_eject_velocity_z = 0.0;

global real R_animate_time_default = 0.475;
global real R_kill_time_default = 10.0;
global real R_rest_time_default = 0.0125;
global real R_chain_time_default = 0.125;

global real R_chain_parent_pos_default = 0.25;

// === init: init function
script startup instanced init()

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );

end

script static instanced void open( real r_time )

	// default time
	if ( r_time < 0 ) then
		r_time = R_animate_time_default;
	end

	if ( device_get_position(this) == 0.0 ) then
		// animate
		device_animate_position( this, 1.0, r_time, 0.1, 0, TRUE );
	end
	// wait for the physics frame
	sleep_until( device_get_position(this) == 1.0, 1 );
	
end 

script static instanced void trigger_open( trigger_volume tv_volume, real r_time )

	sleep_until( volume_test_players(tv_volume) or (device_get_position(this) > 0.0), 1 );
	open( r_time );

end

script static instanced void chain_open_eject( device dm_parent, real r_parent_pos, real r_time_chain, real r_anim_time, object_name o_warthog, trigger_volume tv_kill, real r_velocity_mod )

	// wait for parent position
	if ( r_parent_pos < 0 ) then
		r_parent_pos = R_chain_parent_pos_default;
	end
	sleep_until( (dm_parent == NONE) or (device_get_position(dm_parent) >= r_parent_pos), 1 );

	// delay the chain
	if ( r_time_chain < 0 ) then
		r_time_chain = R_chain_time_default;
	end
	sleep_s( r_time_chain );

	// fire the open eject sequence
	open_eject( r_anim_time, o_warthog, tv_kill, r_velocity_mod );

end

script static instanced void open_eject( real r_time, object_name o_warthog, trigger_volume tv_kill, real r_velocity_mod )
	// open
	thread( open(r_time) );
	
	// eject
	sleep_until( device_get_position(this) >= (L_frame_eject/(L_frame_end-L_frame_start)), 1 );
	sleep_s( R_rest_time_default );
	
	if ( object_valid(o_warthog) ) then
		//dprint( "eject" );
		thread( eject_kill(o_warthog, tv_kill) );
		object_set_velocity( o_warthog, R_eject_velocity_x * r_velocity_mod, R_eject_velocity_y * r_velocity_mod, R_eject_velocity_z * r_velocity_mod );
	end

end

script static instanced void eject_kill( object_name o_warthog, trigger_volume tv_kill )

	sleep_until( (not object_valid(o_warthog)) or volume_test_objects(tv_kill,o_warthog), 1 );
	//dprint( "eject_kill" );
	
	if ( object_valid(o_warthog) ) then
		kill_warthog( o_warthog );
	end
	
end

script static void kill_warthog( object_name o_warthog )
	//dprint( "kill_warthog" );

	damage_object( o_warthog, "mat_windshield", 1000 );
	damage_object( o_warthog, "mat_hood", 1000 );
	damage_object( o_warthog, "mat_mainhull", 1000 );
	damage_object( o_warthog, "mat_bumper", 1000 );
	damage_object( o_warthog, "mat_fronthull", 1000 );
	damage_object( o_warthog, "mat_tailgate", 1000 );
	damage_object( o_warthog, "mat_rr_fender", 1000 );
	damage_object( o_warthog, "mat_lr_fender", 1000 );
	damage_object( o_warthog, "mat_rf_fender", 1000 );
	damage_object( o_warthog, "mat_lf_fender", 1000 );
	damage_object( o_warthog, "mat_rf_wheel", 1000 );
	
end