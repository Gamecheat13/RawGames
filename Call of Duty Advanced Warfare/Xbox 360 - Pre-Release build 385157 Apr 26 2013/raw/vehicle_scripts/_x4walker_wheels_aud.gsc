#include soundscripts\_snd;
#include soundscripts\_audio_vehicle_manager;
#include vehicle_scripts\_x4walker_wheels;


kX4Walker_MinSpeed		= 0;
kX4Walker_MidSpeed		= 3;
kX4Walker_MaxSpeed		= 7;
kX4Walker_Idle_MinVol	= 0.6;							
kX4Walker_Idle_MaxVol	= 0.0;
kX4Walker_Move_MinVol	= 0.5;
kX4Walker_Move_MaxVol	= 1.0;
		
/**********************************************************************************************************/
/****************************************** INITIALIZATION ************************************************/
/**********************************************************************************************************/
snd_init_x4_walker_wheels()
{
	VM2_register_callback("x4ww_zvelocity_front_left",		::x4ww_input_callback_wheel_zvelocity_front_left);
	VM2_register_callback("x4ww_zvelocity_front_right",	::x4ww_input_callback_wheel_zvelocity_front_right);
	VM2_register_callback("x4ww_zvelocity_rear_left",		::x4ww_input_callback_wheel_zvelocity_rear_left);
	VM2_register_callback("x4ww_zvelocity_rear_right",		::x4ww_input_callback_wheel_zvelocity_rear_right);
	VM2_register_callback("x4ww_gun_pitch_rate",			::x4ww_input_callback_gun_pitch_rate);
	VM2_register_callback("x4ww_gun_yaw_rate",				::x4ww_input_callback_gun_yaw_rate);
	VM2_register_callback("x4ww_player_driver",			::x4ww_input_callback_player_driver);
	
	//duplicates inputs so different smoothing values can be used
	VM2_register_callback("x4ww_gun_pitch_rate2",			::x4ww_input_callback_gun_pitch_rate);
	VM2_register_callback("x4ww_gun_yaw_rate2",			::x4ww_input_callback_gun_yaw_rate);
	
	self snd_message("snd_register_vehicle", "x4walker_wheels", vehicle_scripts\_x4walker_wheels_aud::snd_x4walker_wheels_constructor);
}

snd_start_x4_walker_wheels(mode)
{	
	// Kill currently playing sound instance if exists.
	if (IsDefined(self.snd_instance))
	{
		wait(1);
		fade_out_time = 1;
		self snd_message("snd_stop_vehicle", fade_out_time);
		
		// Signal audio that player has entered the vehicle.
		self snd_message("player_exit_walker");
	}
	
	args = SpawnStruct();
	args.preset_name = "x4walker_wheels";
	args.player_mode = (mode == "plr");	
	self snd_message("snd_start_vehicle", args);	
}


/**********************************************************************************************************/
/****************************************** PRESET ********************************************************/
/**********************************************************************************************************/

snd_x4walker_wheels_constructor()
{
	VM2_begin_preset_def( "x4walker_wheels" );
	
		//LOOPS//
		VM2_begin_loop_data(3.0, 0.65, 0.30); 
		
			VM2_begin_loop_def( "x4ww_idle");
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "x4_idle_vel2vol", "x4_idle_vel2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4ww_move");
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "x4_move_vel2vol", "x4_move_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_move_vel2pch", "x4_move_vel2pch" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "pitch" );
					VM2_add_param_map_env( "pitch", "x4_move_pit2pch", "x4_move_pit2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4ww_move2");
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "x4_move2_lp_vel2vol", "x4_move2_lp_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_move2_lp_vel2pch", "x4_move2_lp_vel2pch" );
				VM2_end_param_map();
			
				VM2_begin_param_map( "pitch" );
					VM2_add_param_map_env( "pitch", "x4_move_pit2pch", "x4_move_pit2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
		VM2_end_loop_data();
		
		//ONESHOTS//
		VM2_begin_oneshot_data();
			
			VM2_begin_oneshot_def( "x4ww_startup", "x4_startup_duck_envelope" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4ww_shutoff", "xwalk_shutoff_duck_envelope" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4ww_accel_hard", "xwalk_accel_duck_envelope" );
				VM2_begin_param_map ( "acceleration_g", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_accel_1shot_accel2vol", "x4_accel_1shot_accel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4ww_decel_1", "xwalk_stop_duck_envelope", 0.5, true, ["x4ww_decel"]);
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_break_squeal_vel2vol", "x4_break_squeal_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4ww_decel_2", "xwalk_stop_duck_envelope", 0.5, true, ["x4ww_decel", "x4ww_stop_squeal"] );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_break_squeal_vel2vol", "x4_break_squeal_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();

			VM2_begin_oneshot_def( "x4ww_stop_chuff", "xwalk_stop_duck_envelope" );
				VM2_begin_param_map( "speed", 1.0, 1.0 );
					VM2_add_param_map_env( "volume", "x4_chuff_vel2vol", "x4_chuff_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4ww_suspen_bump_hard", "xwalk_stop_duck_envelope" );
				VM2_begin_param_map( "speed" );
					VM2_add_param_map_env( "volume", "x4_chuff_vel2vol", "x4_chuff_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();

			VM2_begin_oneshot_def( "x4ww_rotate_stop", "xwalk_stop_duck_envelope" );
			VM2_end_oneshot_def();			

		VM2_end_oneshot_data();
		
		//BEHAVIORS//
		VM2_begin_behavior_data();
		
			VM2_begin_behavior_def( "to_state_off", ::x4ww_condition_callback_to_state_off );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_startup", ::x4ww_condition_callback_to_state_startup );
				VM2_add_loops("ALL");
				VM2_add_oneshots( "x4ww_startup" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_shutoff", ::x4ww_condition_callback_to_state_shutoff, ["x4ww_player_driver"] );
				VM2_add_oneshots( "x4ww_shutoff" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_enter_vehicle", ::x4ww_condition_callback_to_state_enter_vehicle, ["x4ww_player_driver"] );
			VM2_end_behavior_def();			
			
			VM2_begin_behavior_def( "to_state_idle", ::x4ww_condition_callback_to_state_idle, ["speed"] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_start_move", ::x4ww_condition_callback_to_state_start_move );
				VM2_add_oneshots( "x4ww_accel_hard" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_moving", ::x4ww_condition_callback_to_state_moving, ["speed"] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_breaking", ::x4ww_condition_callback_to_state_breaking );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
				VM2_end_param_map();
				VM2_begin_param_map( "pitch", 0.65, 0.30 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_stop", ::x4ww_condition_callback_to_state_stopped, ["speed"] );
				VM2_add_oneshots( "x4ww_stop_chuff" );
			VM2_end_behavior_def();

			VM2_begin_behavior_def( "to_state_destruct", ::x4ww_condition_callback_to_state_destruct );					// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_wheels_neutral", ::x4ww_condition_callback_to_state_wheels_neutral );		// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def(	"to_state_wheels_bump_impact", ::x4ww_condition_callback_to_state_wheels_bump_impact,  
									["x4ww_zvelocity_front_left", "x4ww_zvelocity_front_right", "x4ww_zvelocity_rear_left", "x4ww_zvelocity_rear_right", "speed"], 
									0.65, 0.30 );
				VM2_add_oneshots( "x4ww_suspen_bump_hard" );	
			VM2_end_behavior_def();

			VM2_begin_behavior_def( "to_state_turret_rotate", ::x4ww_condition_callback_to_state_turret_rotate );				// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_turret_rotate_accel", ::x4ww_condition_callback_to_state_turret_rotate_accel );
				VM2_begin_param_map( "x4ww_gun_yaw_rate", 1, 1 );
				VM2_end_param_map();
				VM2_begin_param_map( "speed", 0.6, 0.6 );
				VM2_end_param_map();
			VM2_end_behavior_def();

			VM2_begin_behavior_def( "to_state_turret_rotate_decel", ::x4ww_condition_callback_to_state_turret_rotate_decel );	// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_turret_stopped", ::x4ww_condition_callback_to_state_turret_stopped );				// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_turret_elevate", ::x4ww_condition_callback_to_state_turret_elevate );				// UNIMPLEMENTED.
			VM2_end_behavior_def();
			
		VM2_end_behavior_data();
			
		//STATES//
		VM2_begin_state_data();
		
			//Group_1//
			VM2_begin_state_group( "main_oneshots", "state_enter_vehicle", "to_state_enter_vehicle", 50, 1.0 );
		
				VM2_begin_state_def( "state_off" );
					VM2_add_state_transition( "state_enter_vehicle", "to_state_enter_vehicle" );
				VM2_end_state_def();
								
				VM2_begin_state_def( "state_enter_vehicle" );
					VM2_add_state_transition( "state_startup", "to_state_startup" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_startup" );
					VM2_add_state_transition( "state_idle", "to_state_idle" );
					VM2_add_state_transition( "state_start_move", "to_state_start_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_shutoff" );
					VM2_add_state_transition( "state_off", "to_state_off" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_idle" );
					VM2_add_state_transition( "state_start_move", "to_state_start_move" );
					VM2_add_state_transition( "state_shutoff", "to_state_shutoff" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
					
				VM2_begin_state_def( "state_start_move" );
					VM2_add_state_transition( "state_moving", "to_state_moving" );
					VM2_add_state_transition( "state_shutoff", "to_state_shutoff" );
					VM2_add_state_transition( "state_stop", "to_state_stop" );
					VM2_add_state_transition( "state_breaking", "to_state_breaking" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_breaking" );
					VM2_add_state_transition( "state_stop", "to_state_stop" );
					VM2_add_state_transition( "state_moving", "to_state_moving" );
					VM2_add_state_transition( "state_shutoff", "to_state_shutoff" );
					VM2_add_state_transition( "state_start_move", "to_state_start_move" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_stop" );
					VM2_add_state_transition( "state_idle", "to_state_idle" );
					VM2_add_state_transition( "state_shutoff", "to_state_shutoff" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_exit_vehicle" );
					VM2_add_state_transition( "state_off", "to_state_off" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_moving" );
					VM2_add_state_transition( "state_breaking", "to_state_breaking" );
					VM2_add_state_transition( "state_stop", "to_state_stop" );
					VM2_add_state_transition( "state_shutoff", "to_state_shutoff" );
					VM2_add_state_transition( "state_start_move", "to_state_start_move" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_destruct" );
					VM2_add_state_transition( "state_off", "to_state_off" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
			//Group_2//
			VM2_begin_state_group( "wheel_legs", "state_wheels_neutral", "to_state_wheels_neutral", 50, 1.0 );
			
				VM2_begin_state_def( "state_wheels_neutral" );
					VM2_add_state_transition( "state_wheels_bump_impact", "to_state_wheels_bump_impact" );
					VM2_add_state_transition( "state_wheels_neutral", "to_state_wheels_neutral" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_wheels_bump_impact" );
					VM2_add_state_transition( "state_wheels_bump_impact", "to_state_wheels_bump_impact" );
					VM2_add_state_transition( "state_wheels_neutral", "to_state_wheels_neutral" );
					VM2_add_state_transition( "state_destruct", "to_state_destruct" );
				VM2_end_state_def();
				
			VM2_end_state_group();
		
			//Group_3//
			VM2_begin_state_group( "turret_rotate", "state_turret_rotate", "to_state_turret_rotate", 50, 1.0 );
			
				VM2_begin_state_def( "state_turret_stopped" );
					VM2_add_state_transition( "state_turret_rotate", "to_state_turret_rotate" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_turret_rotate" );
					VM2_add_state_transition( "state_turret_rotate", "to_state_turret_rotate" );
					VM2_add_state_transition( "state_turret_rotate_accel", "to_state_turret_rotate_accel" );
					VM2_add_state_transition( "state_turret_rotate_decel", "to_state_turret_rotate_decel" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_turret_rotate_accel" );
					VM2_add_state_transition( "state_turret_rotate_accel", "to_state_turret_rotate_accel" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_turret_rotate_decel" );
					VM2_add_state_transition( "state_turret_rotate", "to_state_turret_rotate" );
					VM2_add_state_transition( "state_turret_rotate_accel", "to_state_turret_rotate_accel" );
				VM2_end_state_def();
				
			VM2_end_state_group();
					
			//Group_4//
			VM2_begin_state_group( "turret_elevate", "state_turret_elevate", "to_state_turret_elevate", 50, 1.0 );
			
				VM2_begin_state_def( "state_turret_elevate" );
					VM2_add_state_transition( "state_turret_elevate", "to_state_turret_elevate" );
				VM2_end_state_def();
				
			VM2_end_state_group();
		
		VM2_end_state_data();
		
		//ENVELOPES//												


		VM2_add_envelope( "x4_idle_vel2vol",						  
			[
                    [kX4Walker_MinSpeed,	0.8],
                    [kX4Walker_MaxSpeed/4,	0.3],
                    [kX4Walker_MaxSpeed/2,	0.1]
            ] 
		);
		
		VM2_add_envelope( "x4_move_vel2vol",							// Slower vehicle drive loop.
			[
                    [kX4Walker_MinSpeed,	0.0],
                    [kX4Walker_MaxSpeed/4,	0.9],
                    [kX4Walker_MaxSpeed,	0.0]
            ] 		 
		);
		
		VM2_add_envelope( "x4_move2_lp_vel2vol",						// Faster vehicle drive loop.
			[
			        [ kX4Walker_MinSpeed ,	0.0 ],
			        [ kX4Walker_MaxSpeed/4,	0.7 ],
			        [ kX4Walker_MaxSpeed ,	1.0 ]
   			]
		);
		
		VM2_add_envelope( "x4_chuff_vel2vol",
						 
			[
			        [0,	0.75],
			        [1,	1.0]
   			]
		);
		
		VM2_add_envelope( "x4_break_squeal_vel2vol",
			[
			        [kX4Walker_MinSpeed,	0.0],
			        [kX4Walker_MaxSpeed,	0.7]
   			]
		);
		
		VM2_add_envelope( "x4_turret_rot_fast_vel2vol",				// Fast turret rotate loop.				 
			[
			        [ -100 ,	.6 	],
			        [ -30 ,		.2 	],
			        [ 0,		0 	],
			        [ 30 ,		.2 	],
			        [ 100 ,		.6 	]
   			]
		);
		
		VM2_add_envelope( "x4_turret_rot_slow_vel2vol",				// Slow turret rotate loop.
			[
			        [ -100 ,	0.6 ],
			        [ -10 ,		0.5 ],
			        [ 0,		0 	],
			        [ 10 ,		0.5	],
			        [ 100 ,		0.6 ]
   			] 
		);
				
		VM2_add_envelope( "x4_turret_rot_slow_vel2pit",				// Controls the pitch of the slow turret rotate loop.
			[
			        [ -30 ,		.7 ],
			        [ 0,		.5 ],
			        [ 30 ,		.7 ]
   			]
		);
		
		VM2_add_envelope( "x4_turret_rot_fast_vel2pit",				// Controls the pitch of the fast turret rotate loop.
			[
			        [ -150 ,	3 	],
					[ -30 ,		0.3 ],
			        [ 0,		0	],
			        [ 30 ,		0.3 ],
			        [ 150 ,		3 	]
   			]
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_vel2vol",			// For the turret elevation.
			[
			        [ -10,		0.6 ],
					[ -1,		0.4 ],
			        [ 0,		0.0 ],
			        [ 1,		0.4 ],
			        [ 10,		0.6 ]
   			]    			 
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_gate",				// For the turret elevation.
			[
			        [ -0.3,		1 ],
			        [ -0.2,		0 ],
			        [ 0,		0 ],
			        [ 0.2,		0 ],
			        [ 0.3,		1 ]
   			]
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_vel2pit",			// Unused.
			[
			        [ -100,		.5 ],
			        [ 0,		.5 ],
			        [ 100,		.5 ]
   			]
		);
		
		VM2_add_envelope( "x4_move_vel2pch",						// Controls the pitch of the slow drive loop.
			[
					[kX4Walker_MinSpeed,	0.90],
					[kX4Walker_MaxSpeed,	1.10]
			]
		);
		
		VM2_add_envelope( "x4_move2_lp_vel2pch",					// Controls the pitch of the fast drive loop.
			[
			        [ kX4Walker_MinSpeed ,	0.9 ],
			        [ 2 ,					0.9 ],
			        [ kX4Walker_MaxSpeed ,	1.2 ]
   			]
		);
		
		VM2_add_envelope( "x4_sub_lp_vel2vol",
			[
			        [ kX4Walker_MinSpeed ,	0.2 ],
			        [ kX4Walker_MaxSpeed ,	0.4 ]
   			]
		);
		
		VM2_add_envelope( "x4_veh_speed_to_turret_rot_vel2vol",		// This is used to have the vehicle speed scale the turret rotation sounds.
			[
			        [ kX4Walker_MinSpeed ,	1 	],
			        [ kX4Walker_MaxSpeed/5, 0.0	],
			        [ kX4Walker_MaxSpeed ,	0.0 ]
   			]
		);
		
		VM2_add_envelope( "x4_veh_speed_to_turret_rot_gate",
			[
			        [ -1,	1],
			        [ 0,	0],
			        [ 1,	1]
   			]
		);
		
		VM2_add_envelope( "x4_suspen_vel2vol",						// Controls the volume of the suspension bounce sounds.
			[
			        [ 0,	0],
			        [ 7,	0.5]
   			]
		);
		
		VM2_add_envelope( "x4_accel_1shot_accel2vol",
			[
			        [ 0,	1	],
			        [ 0.02,	1	],
			        [ 0.1,	1	],
			        [ 0.2,	1.0	]
   			]
		);
		
		VM2_add_envelope( "xwalk_accel_duck_envelope",
			[
			        [0.00,  1.00],
			        [0.55,  0.40],
			        [1.0,  0.60],
			        [2.00,  1.00]
			]
		);
		
		VM2_add_envelope( "xwalk_accel2vol",				 
			[
			        [0,		0.7 ],
			        [0.3, 	0.7 ],
				    [1.0, 	0.7 ]    
   			]
		);
		
		VM2_add_envelope( "xwalk_vel2vol",							// Currently does nothing, hence the values both set to 1.
			[
					[kX4Walker_MinSpeed,	1.00],
					[kX4Walker_MaxSpeed,	1.00]
			]		
		);
		
		VM2_add_envelope( "x4_move_pit2pch",						// Controls the pitch of the drive loops based upon the vehicle's pitch angle.
			[
			        [-2,	0.9],
			        [0,		1.0],
			        [2,		1.1]
			]
		);
		
		VM2_add_envelope( "xwalk_stop_duck_envelope",
			[
			        [0.00,  1.00],
			        [0.55,  0.80],
			        [0.85,  0.80],
			        [2.00,  1.00]
			]
		);
		
		VM2_add_envelope( "x4_startup_duck_envelope",
			[
			        [0.00,  0.00],
			        [0.55,  0.10],
			        [0.85,  0.20],
			        [1.50,  1.00]
			]
		);
		
		VM2_add_envelope( "xwalk_shutoff_duck_envelope",
			[
			        [0.00,  1.00],
			        [0.55,  0.40],
			        [0.85,  0.30],
			        [1.50,  0.00],
			        [5.00,  0.00]
			] 
		);
		
	VM2_end_preset_def();	
}

/**********************************************************************************************************/
/****************************************** BEHAVIOR CALLBACKS ********************************************/
/**********************************************************************************************************/
kXWalker_Idle_Threshold				= 0.0001;	// MPH
kXWalker_Move_To_Stopped_Thresh		= 0.1;
kX4Walker_strained_retrigger_time 	= 4000;
kXWalker_Wheel_Bounce_Thresh		= 2;

x4ww_condition_callback_to_state_off(curr_smoothed_input_keyed_values, vars)
{
	return true;	
}

x4ww_condition_callback_to_state_enter_vehicle(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	player_inside = curr_smoothed_input_keyed_values["x4ww_player_driver"];
	if (player_inside)
	{
		result = true;	
	}
	return result;		
}

x4ww_condition_callback_to_state_exit_vehicle(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	player_inside = curr_smoothed_input_keyed_values["x4ww_player_driver"];
	if (!player_inside)
	{
		result = true;	
	}
	return result;		
}

x4ww_condition_callback_to_state_startup(curr_smoothed_input_keyed_values, vars)
{
	
	vars.g_xwalk_pitched_hard = false;
	vars.g_xwalk_was_stopped = true;
	vars.g_xwalk_vel_que = [0,0,0,0,0,0,0,0,0,0];  // xwalker velocity que
	vars.g_turret_vel_array = [0,0,0,0];
	vars.g_xwalk_started_to_move = 0;
	
		
	return true;		
}

x4ww_condition_callback_to_state_shutoff(curr_smoothed_input_keyed_values, vars)
{
	result = false;
//	player_inside = curr_smoothed_input_keyed_values["x4ww_player_driver"];
//	if (!player_inside)
//	{
//		result = true;	
//	}
	return result;		
}

x4ww_condition_callback_to_state_idle(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	velo 		= curr_smoothed_input_keyed_values["speed"];
	
	//vars.g_xwalk_vel_que = push_item_on_que(vars.g_xwalk_vel_que,velo);
	
	// STATE TRIGGER CONDITION.
	if (velo <= kXWalker_Idle_Threshold)
	{
		result = true;
	}
	
	return result;
}

x4ww_condition_callback_to_state_start_move(curr_smoothed_input_keyed_values, vars)
{
	// start move is really start acceleration.
	result		= false;
	velo 		= curr_smoothed_input_keyed_values["speed"];
	time_moving = 0;
	
		
	if ( !IsDefined( vars.start_move ) )
    {
		vars.start_move = SpawnStruct();
    	vars.start_move.prev_velo = velo;
    	vars.start_move.time_accel = 0;
    	vars.start_move.acceltime = 0;
    	vars.start_move.accelerating = false;
    	vars.start_move.strain_accel_last_trigger = 0;
    	vars.start_move.strain_accel_time_since_trigger = 1000;  
    	vars.start_move.rand_second_accel_thresh = RandomIntRange(1500,3500);
    }
	else
	{
		// get the delta velocity
		curr_dv = velo - vars.start_move.prev_velo;
		
		// check to see if we were previously accelerating and the delta vel was greater than zero
		
		if ( vars.start_move.accelerating == false && curr_dv > 0 )
		{
			// a acceleration just happened.  So set acclerating true and get the time when it happened.
			vars.start_move.accelerating = true;  
			vars.start_move.acceltime = gettime();  // store the time we started the acceleration
		}
		else if ( vars.start_move.accelerating == true && curr_dv > 0 )
		{
			// increase the amount of time it has been accelerating
			vars.start_move.time_accel = vars.start_move.time_accel + gettime() - vars.start_move.acceltime;
		}
		else if ( curr_dv <= 0 || velo >= kX4Walker_MaxSpeed )
		{
			// we are no longer accelerating reset the variables
			vars.start_move.accelerating = false;
			vars.start_move.acceltime = 0;
			vars.start_move.time_accel = 0;
		}
		
		
		
		
		time_moving = gettime() - vars.g_xwalk_started_to_move;
			
		
		
		// if the global pitched hard was true, test to see if the strained acceleration can trigger
		if ( vars.g_xwalk_pitched_hard == true && curr_dv > 0 )
		{
			
			strain_accel_time_since_trigger = gettime() - vars.start_move.strain_accel_last_trigger;
			
			// don't want the strained accel sound to play all the time
			// see if the time since trigger is greater than the retrigger threshold
			if ( strain_accel_time_since_trigger > kX4Walker_strained_retrigger_time )
			{
				
				// strained trigger
				result = true;
				vars.g_xwalk_started_to_move = gettime();
				vars.start_move.acceltime = 0;
				vars.start_move.accelerating = false;
				vars.start_move.time_accel = 0;
				vars.g_xwalk_pitched_hard = false;
				vars.start_move.strain_accel_last_trigger = gettime();
				vars.g_xwalk_was_stopped = false; 
				
			}
		}
		else if ( vars.start_move.time_accel > 400 && curr_dv > 0.1 && vars.g_xwalk_was_stopped)
		{
			// we check to see if a hard acceleration has occured.   
			// if the time accel is greater than the 400ms threshold and the delta velocity is big enough trigger the acceleration.
			result = true;
			vars.g_xwalk_started_to_move = gettime();
			vars.start_move.acceltime = 0;
			vars.start_move.accelerating = false;
			vars.start_move.time_accel = 0;
			vars.g_xwalk_was_stopped = false;
		}
		else if ( velo > 2 && time_moving > vars.start_move.rand_second_accel_thresh && time_moving < (vars.start_move.rand_second_accel_thresh + 500 ) )
		{
			// trigger a second acceleration - mimics a gear shift
			result = true;
			
			vars.start_move.acceltime = 0;
			vars.start_move.accelerating = false;
			vars.start_move.time_accel = 0;
			vars.g_xwalk_was_stopped = false;
			// get the next random threshold for the next time.
			vars.start_move.rand_second_accel_thresh = RandomIntRange(1500,3500);
		}
		else if (velo >= kX4Walker_MaxSpeed && vars.g_xwalk_was_stopped)
		{
			// if there was a very slow accel, this will cover it
			result = true;
			vars.g_xwalk_started_to_move = gettime();
			vars.start_move.acceltime = 0;
			vars.start_move.accelerating = false;
			vars.start_move.time_accel = 0;
			vars.g_xwalk_was_stopped = false;
		}
	
		
		// store the current velo as the previous velo
		vars.start_move.prev_velo	= velo;
    }
	
	return result;	
}

x4ww_condition_callback_to_state_moving(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	velo 		= curr_smoothed_input_keyed_values["speed"];
	
	// STATE TRIGGER CONDITION.
	// if the velocity is greather the than the stopped threshold velocity than the vehicle is moving.
	if (velo > kXWalker_Move_To_Stopped_Thresh)
	{
		result = true;
	}
	
	return result;
}

x4ww_condition_callback_to_state_breaking( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	
	velo 	= curr_smoothed_input_keyed_values["speed"];
	pitch	= curr_smoothed_input_keyed_values["pitch"];
	
	time_x4_was_moving = gettime() - vars.g_xwalk_started_to_move;
	
	if ( !IsDefined( vars.breaking ) )
    {
		vars.breaking = SpawnStruct();
    	vars.breaking.prev_velo = velo;
    	vars.breaking.time_breaking = 0;
    	vars.breaking.breaktime = 0;
    	vars.breaking.is_breaking = false;
    	vars.breaking.prev_pitch = 0;
    	vars.breaking.prev_dp = 0;
    	vars.breaking.time_pitching_hard = 0;
    	vars.breaking.pitching_hard = false;
    	vars.breaking.pitching_hard_start_time = 0;
    }
	else
	{
		// get the change in pitch (angle) of the vehicle
		dp = pitch - vars.breaking.prev_pitch;
		
		// check to see if the pitch delta is greater than the threshold to trigger a slowdown sound
		if ( abs( dp ) > .5 && vars.g_xwalk_pitched_hard == false )
		{
//			result = 	["ONESHOTS_EXCLUSIVE",
//							["alias", "x4ww_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4ww_decel_1"];
			
			// set the global pitch hard to true - used in the acceleration code to trigger a strained acceleration.
			vars.g_xwalk_pitched_hard = true;	
		}
			
		// get the velocity delta
		curr_dv = velo - vars.breaking.prev_velo;
		
		// if we weren't breaking and now the delta is < 0, we are now slowing
		if ( vars.breaking.is_breaking == false && curr_dv < 0 )
		{
			// set breaking to true and get the time it occured
			vars.breaking.is_breaking = true;
			vars.breaktime = gettime();
		}
		else if ( vars.breaking.is_breaking == true && curr_dv <0 )
		{
			// if the vehicle was breaking and the delta is still < 0, update the breaking time
			vars.breaking.time_breaking = vars.breaking.time_breaking + gettime() - vars.breaking.breaktime;
		}
		else if (curr_dv >= 0)
		{
			// if the delta >= 0 , we are no longer breaking.
			vars.breaking.breaking = false;
			vars.breaking.breaktime = 0;
			vars.breaking.time_breaking = 0;
		}
				
		
		// check for what kind of breaking
		if ( vars.breaking.time_breaking > 400 && curr_dv < -0.6 && time_x4_was_moving > 2000 )
		{
			// if the breaking time is > than the threshold and the delta is large enough and the vehicle was moving long enough
			// trigger a hard break - decel sound along with the brake squeal.
			
			vars.breaking.breaktime = 0;
			vars.breaking.breaking = false;
			vars.breaking.time_breaking = 0;
//				result = ["ONESHOTS_EXCLUSIVE",	
//				["alias", "x4ww_decel", "xwalk_stop_duck_envelope"],
//				["alias", "x4ww_stop_squeal", "xwalk_stop_duck_envelope"]];
				result = ["x4ww_decel_2"];
		}
		else if ( vars.breaking.time_breaking > 400 && curr_dv < -0.6 && time_x4_was_moving <= 2000 )
		{
			// if the breaking time is > than the threshold and the delta is large enough and the vehicle was NOT moving long enough
			// trigger a softer slow down - decel sound only.
			
			vars.breaking.breaktime = 0;
			vars.breaking.breaking = false;
			vars.breaking.time_breaking = 0;
//			result = 	["ONESHOTS_EXCLUSIVE",	
//							["alias", "x4ww_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4ww_decel_1"];
		}
		else if ( velo < kXWalker_Move_To_Stopped_Thresh )
		{
			// this should cover the case when a very slow slow down occrus
			result = true;
			vars.breaking.breaktime = 0;
			vars.breaking.breaking = false;
			vars.breaking.time_breaking = 0;
//			result = 	["ONESHOTS_EXCLUSIVE",	
//							["alias", "x4ww_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4ww_decel_1"];
		}
		
		// store the previous velo and pitch		
		vars.breaking.prev_velo	= velo;
    	vars.breaking.prev_pitch = pitch;
	}

	return result;
}

x4ww_condition_callback_to_state_stopped( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	curr_velo 	= curr_smoothed_input_keyed_values["speed"];
	
	if ( !IsDefined( vars.stopped ) )
    {
		vars.stopped = SpawnStruct();
    	vars.stopped.prev_velo = curr_velo;
    	vars.stopped.prev_dv = 0;  // delta accel
    }
	else
	{
		curr_dv = curr_velo - vars.stopped.prev_velo;
		
		// STATE TRIGGER CONDITION.
		if ( curr_velo < kXWalker_Move_To_Stopped_Thresh )
		{
			result = true;
			vars.g_xwalk_was_stopped = true;
		}
		
		vars.stopped.prev_velo	= curr_velo;
    	vars.stopped.prev_dv = curr_dv;
	}
	return result;
}

x4ww_condition_callback_to_state_destruct( curr_smoothed_input_keyed_values, vars )
{
	return false;	
}

x4ww_condition_callback_to_state_wheels_neutral( curr_smoothed_input_keyed_values, vars )
{
	return false;
}

x4ww_condition_callback_to_state_wheels_bump_impact( curr_smoothed_input_keyed_values, vars )
{
	// this handles when to play a suspension bump sound.
	
	wheel_vel_ids = ["zv_front_left", "zv_front_right", "zv_rear_left", "zv_rear_right"];
	zv = [];
	zv["zv_front_left"] 	= curr_smoothed_input_keyed_values["x4ww_zvelocity_front_left"];
	zv["zv_front_right"]	= curr_smoothed_input_keyed_values["x4ww_zvelocity_front_right"];
	zv["zv_rear_left"] 		= curr_smoothed_input_keyed_values["x4ww_zvelocity_rear_left"];
	zv["zv_rear_right"] 	= curr_smoothed_input_keyed_values["x4ww_zvelocity_rear_right"];
	
	velo = curr_smoothed_input_keyed_values["speed"];
	assert(IsDefined(velo));
	result = false;
	
	if ( !IsDefined( vars.wheels_bump_impact ) )
    {
		vars.wheels_bump_impact = SpawnStruct();
		vars.wheels_bump_impact.prev_zv = [];
		// setup the initial previous wheel z velocity.
		foreach ( wheel in wheel_vel_ids )
		{
			vars.wheels_bump_impact.prev_zv[wheel] = zv[wheel];
		}
		vel_delta = 0;
    }
	else
	{	
		// test each wheel velocity to see if it's velocity delta is greater than the threshold
		foreach ( wheel_tag in wheel_vel_ids )
		{
			// get the wheel delta velocity
			vel_delta = zv[wheel_tag] - vars.wheels_bump_impact.prev_zv[wheel_tag];
			
			// if the delta is greather than the threshold, trigger the suspension bounce.
			if ( abs( vel_delta ) > kXWalker_Wheel_Bounce_Thresh && velo > 0 )  // kXWalker_Wheel_Bounce_Thresh = 25
			{
				result = true;
			}
			vars.wheels_bump_impact.prev_zv[wheel_tag] = zv[wheel_tag];			
		}
	}
	
	return result;
}

x4ww_condition_callback_to_state_turret_rotate( curr_smoothed_input_keyed_values, vars )
{
	result = false;	
	return result;
}

x4ww_condition_callback_to_state_turret_stopped( curr_smoothed_input_keyed_values, vars )
{
	result		= false;	
	return result;
}

x4ww_condition_callback_to_state_turret_rotate_accel( curr_smoothed_input_keyed_values, vars )
{
	result = false;
	rot_velo = abs( curr_smoothed_input_keyed_values[ "x4ww_gun_yaw_rate" ] );
	vehicle_speed = curr_smoothed_input_keyed_values[ "speed" ];
	
	
	
	if ( !IsDefined( vars.turret_rotate_accel ) )
    {
		vars.turret_rotate_accel = SpawnStruct();
    	vars.turret_rotate_accel.prev_velo = rot_velo;
    	vars.turret_rotate_accel.prev_dv = 0;  // delta accel
    	vars.turret_rotate_accel.is_turret_accelerating = false;
    	vars.turret_rotate_accel.time_turret_accelerating = 0;
    	vars.turret_rotate_accel.time_turret_accel_started = 0;
    	vars.turret_rotate_accel.time_last_turret_accel = 1000;
    	vars.turret_rotate_accel.can_turret_start_play = true;
    	vars.turret_rotate_accel.time_turret_rotating = 0;
    	vars.turret_rotate_accel.is_turret_rotating = false;
    	vars.turret_rotate_accel.time_turret_started_rotating = 0;
    }
	else
	{
	
		// get the velocity delta of the turret rotating	
		curr_dv = rot_velo - vars.turret_rotate_accel.prev_velo;
		
		// check the rotation status
		if ( vars.turret_rotate_accel.is_turret_accelerating == false && curr_dv > 0 )
		{
			// if the turret was not accelerating and the current delta is > 0, the turret has started to move.
			vars.turret_rotate_accel.is_turret_accelerating = true;  // accel has started
			vars.turret_rotate_accel.time_turret_accel_started = gettime();
		}
		else if ( vars.turret_rotate_accel.is_turret_accelerating == true && curr_dv > 0 )
		{
			// if the turret was allready accelerating and the delta is still > 0, update the acceration time.
			vars.turret_rotate_accel.time_turret_accelerating = vars.turret_rotate_accel.time_turret_accelerating + gettime() - vars.turret_rotate_accel.time_turret_accel_started;
		}
		else if ( curr_dv <= 0 )
		{
			// the turret is no longer accelerating.
			vars.turret_rotate_accel.is_turret_accelerating = false;
			vars.turret_rotate_accel.time_turret_accelerating = 0;
			vars.turret_rotate_accel.time_turret_accel_started = 0;
		}
		// I don't want the turret to make clunk sound all the time.  
		// the time since last turret accel is used to limit when the start clunk plays.
		time_since_last_turret_accel = gettime() - vars.turret_rotate_accel.time_last_turret_accel;
		
		if ( rot_velo > 0.1 && vars.turret_rotate_accel.is_turret_rotating == false )
		{
			// the turret started rotating - now check to see what kind of rotation started
			if ( rot_velo > 2 && curr_dv > .05 && vars.turret_rotate_accel.can_turret_start_play == true && vehicle_speed < kXWalker_Move_To_Stopped_Thresh )
			{
				// if the rot_velo is greater than a treshold of 2 and  can_turret_start_play is true
				// and the vehicle is not moving -- we decided not to play the clunk sounds if the vehicle is moving.
				// play the turret start clunk.
//				result = 	["ONESHOTS_EXCLUSIVE",
//								["alias", "x4ww_rotate_stop", "xwalk_stop_duck_envelope"]
//							];
				result = ["x4ww_rotate_stop"];
				
				vars.turret_rotate_accel.time_last_turret_accel = gettime();
				vars.turret_rotate_accel.can_turret_start_play = false;
				vars.turret_rotate_accel.time_turret_started_rotating = gettime();
				vars.turret_rotate_accel.is_turret_rotating = true;
				
			}
			else if ( rot_velo > 0.5  && vars.turret_rotate_accel.can_turret_start_play == true )  //&& curr_dv > .05
			{
				// this handles the case where the velocity gradually increased and the turret start sound should not play.
				
				vars.turret_rotate_accel.can_turret_start_play = false;
				vars.turret_rotate_accel.time_turret_started_rotating = gettime();
				vars.turret_rotate_accel.is_turret_rotating = true;
				// result should still be equal to false
			}
		}
		else if ( rot_velo <= 0.1 && vars.turret_rotate_accel.is_turret_rotating == true && vehicle_speed < kXWalker_Move_To_Stopped_Thresh )
		{
			// this is where the stop sound gets handled
			
			// update the time turret was rotating
			time_turret_rotating = gettime() - vars.turret_rotate_accel.time_turret_started_rotating;
			
			if ( time_turret_rotating > 1500 && vars.turret_rotate_accel.can_turret_start_play == false )
			{
				// if the turret was rotating long enough and the turret_start_sound played trigger the stop sound.
//				result = 	["ONESHOTS_EXCLUSIVE",
//							["alias", "x4ww_rotate_stop", "xwalk_stop_duck_envelope"]
//						];
				result = ["x4ww_rotate_stop"];
				
				vars.turret_rotate_accel.can_turret_start_play = true;  // since it stopped, the start sound is allowed to play again.
				vars.turret_rotate_accel.is_turret_rotating = false;
				time_turret_rotating = 0;
			}
			else if (time_turret_rotating <= 1500)
			{
				// turret stops but don't play a stop sound
				// The turret didn't travel for a long enough time
				vars.turret_rotate_accel.is_turret_rotating = false;
				vars.turret_rotate_accel.can_turret_start_play = true;
				time_turret_rotating = 0;
			}
			
		}
		else if ( rot_velo <= 0.1 && vars.turret_rotate_accel.is_turret_rotating == true && vehicle_speed >= kXWalker_Move_To_Stopped_Thresh )
		{
			// the turret stopped but the vehicle was moving
			// don't want a stop clunk to trigger
			vars.turret_rotate_accel.is_turret_rotating = false;
			vars.turret_rotate_accel.can_turret_start_play = true;
			time_turret_rotating = 0;
		}
		
		vars.turret_rotate_accel.prev_velo	= rot_velo;
    	vars.turret_rotate_accel.prev_dv = curr_dv;
	}
	return result;
}

x4ww_condition_callback_to_state_turret_rotate_decel( curr_smoothed_input_keyed_values, vars )
{
	result	= false;
	return result;
}

x4ww_condition_callback_to_state_turret_elevate( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	return result;
}

/**********************************************************************************************************/
/****************************************** CUSTOM INPUT CALLBACKS ****************************************/
/**********************************************************************************************************/
x4ww_input_callback_wheel_zvelocity_front_left()
{
	return x4ww_input_callback_wheel_zvelocity( "tag_wheel_front_left" );
}

x4ww_input_callback_wheel_zvelocity_front_right()
{
	return x4ww_input_callback_wheel_zvelocity( "tag_wheel_front_right" );
}

x4ww_input_callback_wheel_zvelocity_rear_left()
{
	return x4ww_input_callback_wheel_zvelocity( "tag_wheel_back_left" );
}

x4ww_input_callback_wheel_zvelocity_rear_right()
{
	return x4ww_input_callback_wheel_zvelocity( "tag_wheel_back_right" );
}

x4ww_input_callback_wheel_zvelocity(wheel_tag)
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	velocity_vector = vehicle_entity vehicle_scripts\_x4walker_wheels::get_wheel_velocity( wheel_tag );
	z_velocity = velocity_vector[2];
	return z_velocity;
}

x4ww_input_callback_gun_pitch_rate()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	//rate = vehicle_entity vehicle_scripts\_x4walker_wheels::get_gun_pitch_rate();
	rate = 0;
	return rate;
}

x4ww_input_callback_gun_yaw_rate()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	//rate = vehicle_entity vehicle_scripts\_x4walker_wheels::get_gun_yaw_rate();
	rate = 0;
	return rate;
}

x4ww_input_callback_player_driver()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	return IsDefined(vehicle_entity.player_driver);
}	


/**********************************************************************************************************/
/****************************************** UTILITY FUNCTIONS *********************************************/
/**********************************************************************************************************/

push_item_on_que( que_array, item )
{
	for ( i = que_array.size - 1; i > 0 ; i-- )
	{
		que_array[i] = que_array[i-1];
	}
	que_array[0] = item;
	
	return que_array;
}

get_average_in_que( que_array )
{
	sum = 0;
	for ( i = 0; i < que_array.size; i++ )
	{
		sum = sum + que_array[i];
	}
	avg = sum / que_array.size; 
	
	return avg;
}








