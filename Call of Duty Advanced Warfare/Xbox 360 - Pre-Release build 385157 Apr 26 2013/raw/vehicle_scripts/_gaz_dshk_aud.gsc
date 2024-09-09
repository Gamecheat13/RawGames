#include maps\_utility;
#include maps\_shg_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include soundscripts\_audio;
#include soundscripts\_audio_vehicle_manager;
#include soundscripts\_snd;

kGaz_FirstGear			= 5;	// Speed where first gear starts (mph)
kGaz_SecondGear			= 22;	// Speed where second gear starts (mph)
kGaz_MaxSpeed			= 45;	// Maximum speed for the vehicle (mph)
kGaz_LightBump			= 20.0;
kGaz_MediumBump			= 40.0;
kGaz_HeavyBump			= 60.0;

snd_init_gaz()
{
	VM2_register_callback("zvelocity", ::gaz_input_callback_zvelocity);
	VM2_register_callback("about_to_stop", ::gaz_input_callback_about_to_stop);
//	VM2_register_callback("on_dirt", ::gaz_input_callback_on_dirt);
	
	snd_message("snd_register_vehicle", "gaz_dshk", ::snd_gaz_dshk_constructor);
}

snd_start_gaz()
{
	if (IsDefined(self.snd_instance))
	{
		wait( 1.0 );
		snd_stop_gaz( 1.0 );
	}
	
	self thread snd_monitor_new_path();

	args = SpawnStruct();
	args.preset_name = "gaz_dshk";
	self snd_message("snd_start_vehicle", args);
}

snd_stop_gaz( fadeout_time_ )
{
	if (IsDefined(self.snd_instance))
	{
		self snd_message( "snd_stop_vehicle", fadeout_time_ );
		self notify( "snd_stop_vehicle" );
	}
}

snd_monitor_new_path()
{
	self endon( "death" );
	self endon( "snd_stop_vehicle" );

	while(1)
	{
		self.about_to_stop = undefined;
		self thread snd_monitor_about_to_stop();
		self waittill( "newpath" );
	}
}

snd_monitor_about_to_stop()
{
	self endon( "newpath" );
	self endon( "death" );
	self endon( "snd_stop_vehicle" );

	self waittill( "about_to_stop", stopTime );

	if(stopTime > 1.0)
	{
		wait(stopTime - 1.0);

		if ( !IsDefined( self ) )
			return;
	}

	self.about_to_stop = true;
}

snd_gaz_dshk_constructor()
{
	VM2_begin_preset_def( "gaz_dshk" );

		VM2_begin_loop_data();
		
			VM2_begin_loop_def( "veh_gaz_idle_lp" ); //idle
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "gaz_idle_vel2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "veh_gaz_drive_slow_lp" ); //drive_slow
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "gaz_drive_slow_vel2vol" );
					VM2_add_param_map_env( "pitch", "gaz_drive_slow_vel2pit" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "veh_gaz_drive_fast_lp" ); //drive_fast
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "gaz_drive_fast_vel2vol" );
					VM2_add_param_map_env( "pitch", "gaz_drive_fast_vel2pit" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			// TODO: WHAT HAPPEN TO THIS ALIAS?  NO LONGER EXISTS!
//			VM2_begin_loop_def( "veh_gaz_road_noise_lp" ); //road_noise
//				VM2_begin_param_map( "speed" );
//					VM2_add_param_map_env( "volume", "gaz_road_noise_vel2vol" );
//				VM2_end_param_map();
//			VM2_end_loop_def();
			
		VM2_end_loop_data();
		
		//Oneshot Data
		VM2_begin_oneshot_data(0.5);
		
			VM2_begin_oneshot_def( "veh_gaz_shutoff_01", "gaz_shutoff_duck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_drive_offload_to_idle", "gaz_offload_duck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_stop_pavement", "gaz_noduck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_pull_away", "gaz_onload_from_idle_duck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_rev_single", "gaz_noduck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_drive_onload", "gaz_onload_duck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_drive_offload", "gaz_offload_duck" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_bump_susp", "gaz_noduck" );
			 	VM2_begin_param_map( "zvelocity" );
					VM2_add_param_map_env( "volume", "gaz_bump_zvel2vol", "gaz_bump_zvel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "veh_gaz_tire_chatter", "gaz_noduck" );
			VM2_end_oneshot_def();

		VM2_end_oneshot_data();
		
		//Behavior Data
		VM2_begin_behavior_data();
		
			VM2_begin_behavior_def( "to_state_off_initial", ::gaz_condition_callback_state_off );
				VM2_add_loops( "NONE" );
			VM2_end_behavior_def();
			
			//VM2_begin_behavior_def( "to_state_off", ::gaz_condition_callback_to_off, 0.5, 0.5 );
			VM2_begin_behavior_def( "to_state_off", ::gaz_condition_callback_to_off );
				VM2_add_loops( "NONE" );
				VM2_add_oneshots( "veh_gaz_shutoff_01" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_idle_from_off", ::gaz_condition_callback_off_to_idle );
				VM2_add_loops( "ALL" );
				VM2_begin_param_map( "speed", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
	
			// VM2_begin_behavior_def( "to_state_idle_from_drive", ::gaz_condition_callback_drive_to_idle, 0.5, 0.5, ["speed", "about_to_stop"] );
			VM2_begin_behavior_def( "to_state_idle_from_drive", ::gaz_condition_callback_drive_to_idle );
				VM2_add_loops( "ALL" );
				VM2_add_oneshots( [ "veh_gaz_drive_offload_to_idle", "veh_gaz_stop_pavement" ] );
				VM2_begin_param_map( "speed", 1.0, 1.0 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_stop", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_first_from_idle", ::gaz_condition_callback_idle_to_first, 0.5, 0.5, ["about_to_stop"] );
			VM2_begin_behavior_def( "to_state_first_from_idle", ::gaz_condition_callback_idle_to_first );
				VM2_add_loops( "ALL" );
				VM2_add_oneshots( [ "veh_gaz_pull_away", "veh_gaz_rev_single" ] );				
				VM2_begin_param_map( "speed", 0.3, 0.3 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_stop", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_second_from_first", ::gaz_condition_callback_first_to_second, 0.5, 0.25 );
			VM2_begin_behavior_def( "to_state_second_from_first", ::gaz_condition_callback_first_to_second);			
				VM2_add_loops( "ALL" );
				VM2_add_oneshots( "veh_gaz_drive_onload" );				
				VM2_begin_param_map( "speed", 0.3, 0.3 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_first_from_second", ::gaz_condition_callback_second_to_first, 0.5, 0.5 );
			VM2_begin_behavior_def( "to_state_first_from_second", ::gaz_condition_callback_second_to_first );
				VM2_add_loops( "ALL" );
				VM2_add_oneshots( "veh_gaz_drive_offload" );				
				VM2_begin_param_map( "speed", 0.3, 0.3 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_wheels_bump", ::gaz_condition_callback_to_state_wheels_bump, 0.5, 0.5, ["zvelocity", "speed"] );
			VM2_begin_behavior_def( "to_state_wheels_bump", ::gaz_condition_callback_to_state_wheels_bump, [ "zvelocity" ] );
				VM2_add_loops( "ALL" );
				VM2_begin_param_map( "speed", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_wheels_skid", ::gaz_condition_callback_to_state_wheels_skid, 0.5, 0.25, ["yaw", "speed"] );
			VM2_begin_behavior_def( "to_state_wheels_skid", ::gaz_condition_callback_to_state_wheels_skid, [ "yaw" ] );																	    
				VM2_add_loops( "ALL" );
				VM2_begin_param_map( "speed", 0.3, 0.65 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
		VM2_end_behavior_data();
		
		// State Data
		VM2_begin_state_data();
				
			VM2_begin_state_group( "engine_oneshots", "state_off", "to_state_off_initial", 50, 1.0 );
	
				VM2_begin_state_def( "state_off", 0.0, 50 );
					VM2_add_state_transition( "state_idle", "to_state_idle_from_off" );
					VM2_add_state_transition( "state_drive_first_gear", "to_state_first_from_idle" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_idle", 0.0, 50);
					VM2_add_state_transition( "state_off", "to_state_off" );
					VM2_add_state_transition( "state_drive_first_gear", "to_state_first_from_idle" );
				VM2_end_state_def();
			
				VM2_begin_state_def( "state_drive_first_gear" );
					VM2_add_state_transition( "state_off", "to_state_off" );
					VM2_add_state_transition( "state_idle", "to_state_idle_from_drive" );
					VM2_add_state_transition( "state_drive_second_gear", "to_state_second_from_first" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_drive_second_gear" );
					VM2_add_state_transition( "state_off", "to_state_off" );
					VM2_add_state_transition( "state_idle", "to_state_idle_from_drive" );
					VM2_add_state_transition( "state_drive_first_gear", "to_state_first_from_second" );
				VM2_end_state_def();
				
			VM2_end_state_group();

			VM2_begin_state_group( "wheel_bumps", "wheels_bump_1", "to_state_wheels_bump", 50, 1.0 );
			
				VM2_begin_state_def( "wheels_bump_1", 0.0, 50 );
					VM2_add_state_transition( "wheels_bumps_2", "to_state_wheels_bump" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheels_bumps_2", 0.0, 50 );
					VM2_add_state_transition( "wheels_bump_1", "to_state_wheels_bump" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
			VM2_begin_state_group( "wheel_skids", "wheels_skid_1", "to_state_wheels_skid" );
			
				VM2_begin_state_def( "wheels_skid_1", 0.0, 50 );
					VM2_add_state_transition( "wheels_skid_2", "to_state_wheels_skid" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheels_skid_2", 0.0, 50 );
					VM2_add_state_transition( "wheels_skid_1", "to_state_wheels_skid" );
				VM2_end_state_def();
			
			VM2_end_state_group();
		
		VM2_end_state_data();	
		
// END NEW GAZ DATA //
		
		//	Envelope Data
		VM2_add_envelope( "gaz_linearvol",
			[
				[0.00,	0.00],
				[1.00,	1.00]
			]
		);
		
		VM2_add_envelope( "gaz_idle_vel2vol",
			[
	        	[0.0,	0.5],
	        	[5.0,	0.0]
	        ]
		);
		
		VM2_add_envelope( "gaz_drive_slow_vel2vol",
			[
				[1.0,					0.0],
				[kGaz_FirstGear + 5,	0.7],
				[kGaz_SecondGear - 5,	0.7],
				[kGaz_SecondGear + 5,	0.0]
	        ]
		);
		
		VM2_add_envelope( "gaz_drive_slow_vel2pit",
			[
				[kGaz_FirstGear,		0.85],
				[kGaz_SecondGear,		1.15]
	        ]
		);
		
		VM2_add_envelope( "gaz_drive_fast_vel2vol",
			[
				[kGaz_SecondGear - 5,	0.0],
				[kGaz_SecondGear + 5,	0.7]
	        ]
		);
						 
		VM2_add_envelope( "gaz_drive_fast_vel2pit",
			[
				[kGaz_SecondGear,		0.85],
				[kGaz_MaxSpeed,			1.15]
	        ]			 
		);
						 
		VM2_add_envelope( "gaz_road_noise_vel2vol",
			[
				[0.0,	0.0],
				[1.0,	0.7],
				[10.0,	0.7],
				[25.0,	0.25],
				[40.0,	0.7]
	        ]	
		);
		
		VM2_add_envelope( "gaz_bump_zvel2vol",
			[
				[-1.0*kGaz_HeavyBump,	1.0],
				[-1.0*kGaz_MediumBump,	0.7],
				[-1.0*kGaz_LightBump,	0.5],
				[0.0,					0.0],
				[kGaz_LightBump,		0.5],
				[kGaz_MediumBump,		0.7],
				[kGaz_HeavyBump,		1.0]
			]
		);
		
		VM2_add_envelope( "gaz_shutoff_duck",
			[
				[0.00,	0.00],
				[2.00,	1.00]
			]
		);
		
		VM2_add_envelope( "gaz_onload_from_idle_duck",
			[
				[0.00,	0.5],
				[2.00,	1.00]
			]
		);
		
		VM2_add_envelope( "gaz_onload_duck",
			[
				[0.00,	0.5],
				[1.00,	1.00]
			]
		);
	    
		VM2_add_envelope( "gaz_offload_duck",
			[
				[0.00,	0.5],
				[1.5,	1.00]
			]
		);
		
		VM2_add_envelope( "gaz_noduck",
			[
				[0.00,	1.0],
				[1.00,	1.0]
			]
		);

	VM2_end_preset_def();
}

////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////

gaz_input_callback_zvelocity()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	
	z_velocity = vehicle_entity get_differentiated_velocity();
	return z_velocity[2];
}

gaz_input_callback_about_to_stop()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	return IsDefined(vehicle_entity.about_to_stop);
}

/*
gaz_input_callback_on_dirt()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	assert(IsDefined(vehicle_entity));
	
	surfacetype = vehicle_entity gaz_get_surface_type();
	if ( surfacetype == "dirt" )
		return 1;

	return 0;
}

gaz_get_surface_type()
{
	if ( !IsDefined(self.last_surface_trace_time) )
	{
		self.last_surface_trace_time = 0;
	}
	if ( !IsDefined(self.surfacetype) )
	{
		self.surfacetype = "none";
	}

	time = GetTime();

	if(time - self.last_surface_trace_time > 100)
	{
		vehicleBumperOffset = aud_rotate_vector_yaw( ( 75, 0, 0 ), self.angles[1] );
		traceStart = self.origin + vehicleBumperOffset + ( 0, 0, 100 );
		traceStop = traceStart - ( 0, 0, 150 );
		trace = bullettrace( traceStart, traceStop, false, self );
		
		self.last_surface_trace_time = time;
		self.surfacetype = trace[ "surfacetype" ];
	}

	return self.surfacetype;
}
*/

gaz_condition_callback_state_off(curr_smoothed_input_keyed_values, vars)
{
	return false;
}

gaz_condition_callback_off_to_idle(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];

	if (speed < kGaz_FirstGear)
	{
		vars.last_gear_change_time = 0;
		return true;
	}
	
	return false;
}

gaz_condition_callback_drive_to_idle(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];
	about_to_stop = curr_smoothed_input_keyed_values["about_to_stop"];
	
	result = false;

	if (about_to_stop > 0.5 || speed < kGaz_FirstGear)
	{
		vars.last_gear_change_time = GetTime();
		result = true;
	}

	return result;
}

gaz_condition_callback_idle_to_first(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];
	about_to_stop = curr_smoothed_input_keyed_values["about_to_stop"];

	result = false;

	if ( !IsDefined( vars.last_gear_change_time ) )
	{	
		vars.last_gear_change_time = 0;
	}

	time = GetTime();

	if (about_to_stop < 0.5 && speed >= kGaz_FirstGear && time - vars.last_gear_change_time > 2000 )
	{
		vars.last_gear_change_time = time;
		result = true;
	}

	return result;
}

gaz_condition_callback_first_to_second(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];

	result = false;

	if ( !IsDefined( vars.last_gear_change_time ) )
	{	
		vars.last_gear_change_time = 0;
	}

	time = GetTime();

	if (speed >= kGaz_SecondGear && time - vars.last_gear_change_time > 2000 )
	{
		vars.last_gear_change_time = time;
		result = true;
	}

	return result;
}
	
gaz_condition_callback_second_to_first(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];

	result = false;

	if ( !IsDefined( vars.last_gear_change_time ) )
	{	
		vars.last_gear_change_time = 0;
	}

	time = GetTime();

	if (speed < kGaz_SecondGear && time - vars.last_gear_change_time > 2000 )
	{
		vars.last_gear_change_time = time;
		result = true;
	}

	return result;
}

gaz_condition_callback_to_off(curr_smoothed_input_keyed_values, vars)
{
	return false;
}


gaz_condition_callback_to_state_wheels_bump( curr_smoothed_input_keyed_values, vars )
{
	zvel = curr_smoothed_input_keyed_values["zvelocity"];
	speed = curr_smoothed_input_keyed_values["speed"];

	result = false;
	
	if ( !IsDefined( vars.last_bump_time ) )
	{	
		vars.last_bump_time = 0;
	}

	if ( IsDefined( vars.previous_bump_zvel ) )
	{	
		zvel_delta = zvel - vars.previous_bump_zvel;
		time = GetTime();
		
		if ( abs( zvel_delta ) >= kGaz_LightBump && speed > kGaz_FirstGear && time - vars.last_bump_time > 400 )
		{
			vars.last_bump_time = time;

			result =	[ "veh_gaz_bump_susp" ];
		}
	}
	
	vars.previous_bump_zvel = zvel;

	return result;
}


gaz_condition_callback_to_state_wheels_skid( curr_smoothed_input_keyed_values, vars )
{
	yaw = curr_smoothed_input_keyed_values["yaw"];
	speed = curr_smoothed_input_keyed_values["speed"];

	result = false;
	
	if ( !IsDefined( vars.last_skid_time ) )
	{	
		vars.last_skid_time = 0;
	}

	if ( IsDefined( vars.previous_yaw ) )
	{	
		yaw_delta = AngleClamp180(yaw - vars.previous_yaw);
		time = GetTime();

		if ( abs( yaw_delta ) > 5.0 && speed > kGaz_FirstGear && time - vars.last_skid_time > 1000 )
		{
			vars.last_skid_time = time;

			result =	[ "veh_gaz_tire_chatter" ];
		}
	}
	
	vars.previous_yaw = yaw;

	return result;
}
