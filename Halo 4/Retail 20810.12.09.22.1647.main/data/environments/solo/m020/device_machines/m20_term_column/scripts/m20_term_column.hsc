//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m20_requiem
// script for the Terminus Tower device machine walls opening/closing
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// === f_init: init function

/*
script startup instanced init()
	//dprint_door( "init" );
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
	

	// initialize variables
	speed_set_open( 10 );
	//speed_set_close( 4 );
	
	sound_open_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start' ); //AUDIO!
	sound_close_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end' ); //AUDIO!
	//sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start', this, light_5, 1 ); //Start sound
	//sound_looping_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop', this, light_5, 1 ); //Start looping sound

	//set_jittering( FALSE );
		
	//chain_delay_set( DEF_SPEED_DEFAULT / 8 );
	
//	animate( 0.0, R_door_start_position );

	//sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop' ); //Stop looping sound
	//sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end', this, light_5, 1 ); //End sound

end
*/

script startup instanced init()
	//dprint_door( "init" );
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
	

	// initialize variables
	speed_set_open( 10 );
	speed_set_close( 10 );
	
	sound_open_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start' ); //AUDIO!
	sound_close_set( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end' ); //AUDIO!
	//sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start', this, light_5, 1 ); //Start sound
	//sound_looping_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop', this, light_5, 1 ); //Start looping sound

	// animate( 0.0, R_door_start_position );

	//sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop' ); //Stop looping sound
	//sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end', this, light_5, 1 ); //End sound

end









/*
script static instanced void animate()
local real r_time = 10.0;
local real r_pos = 1.0;

	dprint( "ANIMATE!!!" );
	sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start', this, light_5, 1 ); //Start sound
	sound_looping_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop', this, light_5, 1 ); //Start looping sound

	//set_jittering( FALSE );

	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );

	//sleep_until( device_get_position(this) == r_pos, 1 );

	sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop' ); //Stop looping sound
	sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end', this, light_5, 1 ); //End sound

end


script static instanced void de_animate()
local real r_time = 10.0;
local real r_pos = 0.0;

	if device_get_position(this) !=  r_pos then 
	dprint( "DE ANIMATE!!!" );
	sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_start', this, light_5, 1 ); //Start sound
	sound_looping_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop', this, light_5, 1 ); //Start looping sound

	//set_jittering( FALSE );

	device_animate_position( this, r_pos, r_time, 0, 0, TRUE );
	
	sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_end_pillars_loop' ); //Stop looping sound
	sound_impulse_start_marker ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_end_pillars_end', this, light_5, 1 ); //End sound
	
	sleep_until( device_get_position(this) == r_pos, 1 );
	end
	
end

*/