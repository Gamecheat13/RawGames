//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					XXX
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// === f_init: init function
script startup instanced obj_init()

	dprint( "HEX COVER INIT" );

	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0.0 );

end

script static instanced void animate()
local real r_time = 10.0;
local real r_pos = 1.0;

	dprint( "ANIMATE!!!" );
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_cat_hex_rise', this, 1 );
	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );
	//effect_new_on_object_marker(environments\solo\m020\fx\atmosphere\hex_rising_wisps.effect, this, fx_freon);
	//sleep_until( device_get_position(this) == r_pos, 1 );

end


script static instanced void de_animate()
local real r_time = 5.0;
local real r_pos = 0.0;

	if device_get_position(this) !=  r_pos then 
	dprint( "ANIMATE!!!" );
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_cat_hex_lower', this, 1 );
	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );
	sleep_until( device_get_position(this) == r_pos, 1 );
	end
	
end


