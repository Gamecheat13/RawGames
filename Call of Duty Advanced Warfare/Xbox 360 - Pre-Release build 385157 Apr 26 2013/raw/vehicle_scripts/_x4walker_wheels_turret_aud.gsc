#include soundscripts\_snd;
#include soundscripts\_audio_vehicle_manager;
#include vehicle_scripts\_x4walker_wheels_turret;

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
snd_init_x4_walker_wheels_turret()
{
	VM2_register_callback("x4wwt_zvelocity_front_left",		::x4wwt_input_callback_wheel_zvelocity_front_left);
	VM2_register_callback("x4wwt_zvelocity_front_right",	::x4wwt_input_callback_wheel_zvelocity_front_right);
	VM2_register_callback("x4wwt_zvelocity_rear_left",		::x4wwt_input_callback_wheel_zvelocity_rear_left);
	VM2_register_callback("x4wwt_zvelocity_rear_right",		::x4wwt_input_callback_wheel_zvelocity_rear_right);
	VM2_register_callback("x4wwt_gun_pitch_rate",			::x4wwt_input_callback_gun_pitch_rate);
	VM2_register_callback("x4wwt_gun_yaw_rate",				::x4wwt_input_callback_gun_yaw_rate);
	VM2_register_callback("x4wwt_player_driver",			::x4wwt_input_callback_player_driver);
	
	//duplicates inputs so different smoothing values can be used
	VM2_register_callback("x4wwt_gun_pitch_rate2",			::x4wwt_input_callback_gun_pitch_rate);
	VM2_register_callback("x4wwt_gun_yaw_rate2",			::x4wwt_input_callback_gun_yaw_rate);
	
	self snd_message("snd_register_vehicle", "x4walker_wheels_turret", vehicle_scripts\_x4walker_wheels_turret_aud::snd_x4walker_wheels_turret_constructor);
}


/**********************************************************************************************************/
/****************************************** PRESET ********************************************************/
/**********************************************************************************************************/

snd_start_x4_walker_wheels_turret(mode)
{
	if (IsDefined(self.snd_instance))
	{
		wait(1);
		fade_out_time = 1;
		self snd_message("snd_stop_vehicle", fade_out_time);
		self snd_message("player_exit_walker");
	}
	
	if (mode == "npc") 
		return; // Do not allow the "npc" version to be ceated; only the "plr" version.
	// TODO: The aliases for the "NPC version of this vehicle do not exist; need to create them (and will sound wrong from this perspective using the PC version).
	args = SpawnStruct();
	args.preset_name = "x4walker_wheels_turret";
	args.player_mode = (mode == "plr");	
	self snd_message( "snd_start_vehicle", args );
	self snd_message("player_enter_walker");
}

snd_x4walker_wheels_turret_constructor()
{
	VM2_begin_preset_def( "x4walker_wheels_turret" );
	
		//LOOP DATA//
		VM2_begin_loop_data();
		
			VM2_begin_loop_def( "x4_turret_idle2" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_idle_vel2vol", "x4_idle_vel2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4_turret_move" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_move_vel2vol", "x4_move_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_move_vel2pch", "x4_move_vel2pch");
				VM2_end_param_map();
				
				VM2_begin_param_map( "pitch", 0.65, 0.30 );
					VM2_add_param_map_env( "pitch", "x4_move_pit2pch", "x4_move_pit2pch" );
				vm2_end_param_map();		
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4_turret_move2" );
				VM2_begin_param_map( "speed", 0.65, 0.80 );
					VM2_add_param_map_env( "volume", "x4_move2_lp_vel2vol");
					VM2_add_param_map_env( "pitch", "x4_move2_lp_vel2pch");
				VM2_end_param_map();
				
				VM2_begin_param_map( "pitch", 0.65, 0.30 );
					VM2_add_param_map_env( "pitch", "x4_move_pit2pch", "x4_move_pit2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
			VM2_begin_loop_def( "x4_turret_sub_lp" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_sub_lp_vel2vol", "x4_sub_lp_vel2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4_turret_rotate_faster" );
				VM2_begin_param_map( "x4wwt_gun_yaw_rate", 0.30, 0.30 );
					VM2_add_param_map_env( "volume", "x4_turret_rot_fast_vel2vol", "x4_turret_rot_fast_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_turret_rot_slow_vel2pit", "x4_turret_rot_slow_vel2pit" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "speed", 0.30, 0.30 );
					VM2_add_param_map_env( "volume", "x4_veh_speed_to_turret_rot_vel2vol", "x4_veh_speed_to_turret_rot_vel2vol" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "x4wwt_gun_yaw_rate2", 0.90, 0.90 );
					VM2_add_param_map_env( "volume", "x4_veh_speed_to_turret_rot_gate", "x4_veh_speed_to_turret_rot_gate" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "x4_turret_rotate_slow" );
				VM2_begin_param_map( "x4wwt_gun_yaw_rate", 0.30, 0.30 );
					VM2_add_param_map_env( "volume", "x4_turret_rot_slow_vel2vol", "x4_turret_rot_slow_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_turret_rot_slow_vel2pit", "x4_turret_rot_slow_vel2pit" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "x4wwt_gun_yaw_rate2", 1.0, 1.0 );
					VM2_add_param_map_env( "volume", "x4_veh_speed_to_turret_rot_gate", "x4_veh_speed_to_turret_rot_gate" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
			VM2_begin_loop_def( "x4_turret_elevate" );
				VM2_begin_param_map( "x4wwt_gun_pitch_rate", 0.30, 0.30 );
					VM2_add_param_map_env( "volume", "x4_turret_pitch_rate_vel2vol", "x4_turret_pitch_rate_vel2vol" );
					VM2_add_param_map_env( "pitch", "x4_turret_pitch_rate_vel2pit", "x4_turret_pitch_rate_vel2pit" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "x4wwt_gun_pitch_rate2", 1.0, 1.0 );
					VM2_add_param_map_env( "volume", "x4_turret_pitch_rate_gate", "x4_turret_pitch_rate_gate" );
				VM2_end_param_map();
			VM2_end_loop_def();
		
		VM2_end_loop_data();
		
		//ONESHOTS//
		VM2_begin_oneshot_data(0.25);
			
			VM2_begin_oneshot_def( "x4_turret_startup", "x4_startup_duck_envelope" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4_turret_shutoff", "xwalk_shutoff_duck_envelope" );
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4_turret_accel_hard", "xwalk_accel_duck_envelope" );
				VM2_begin_param_map( "acceleration_g", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_accel_1shot_accel2vol", "x4_accel_1shot_accel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4_turret_decel_1", "xwalk_stop_duck_envelope", 0.5, true, ["x4_turret_decel"]);
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_break_squeal_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4_turret_decel_2", "xwalk_stop_duck_envelope", 0.5, true, ["x4_turret_decel", "x4_turret_stop_squeal"] );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_break_squeal_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "x4_turret_stop_chuff" );
				VM2_begin_param_map( "speed", 1.0, 1.0 );
					VM2_add_param_map_env( "volume", "x4_chuff_vel2vol", "x4_chuff_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();

			VM2_begin_oneshot_def( "x4_turret_suspen_bump_hard", "xwalk_stop_duck_envelope" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
					VM2_add_param_map_env( "volume", "x4_suspen_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();	

			VM2_begin_oneshot_def("x4_turret_rotate_stop", "xwalk_stop_duck_envelope" );
//				VM2_begin_param_map( "speed", 0.65, 0.30 );
//					VM2_add_param_map_env( "volume", "x4_suspen_vel2vol" );
//				VM2_end_param_map();
			VM2_end_oneshot_def();	
			
		VM2_end_oneshot_data();
		
		
		//BEHAVIORS//
		VM2_begin_behavior_data();
			
			VM2_begin_behavior_def( "to_state_off",				::x4wwt_condition_callback_to_state_off );
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_startup",			::x4wwt_condition_callback_to_state_startup );
				VM2_add_oneshots( "x4_turret_startup" );
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_shutoff",			::x4wwt_condition_callback_to_state_shutoff,		["x4wwt_player_driver"] );
				VM2_add_oneshots( "x4_turret_shutoff" );
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_enter_vehicle",	::x4wwt_condition_callback_to_state_enter_vehicle,	["x4wwt_player_driver"] );
			VM2_end_behavior_def();	
		
			VM2_begin_behavior_def( "to_state_idle",			::x4wwt_condition_callback_to_state_idle,			["speed"] );
				VM2_add_loops("ALL");			
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_start_move",		::x4wwt_condition_callback_to_state_start_move );
				VM2_add_oneshots( "x4_turret_accel_hard" );
				VM2_begin_param_map( "speed", 0.65, 0.30 );
				VM2_end_param_map();
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_moving",			::x4wwt_condition_callback_to_state_moving,			["speed"] );
			VM2_end_behavior_def();
	
			VM2_begin_behavior_def( "to_state_breaking",		::x4wwt_condition_callback_to_state_breaking );	
				VM2_begin_param_map( "speed", 0.65, 0.30 );
				VM2_end_param_map();
				VM2_begin_param_map( "pitch", 0.65, 0.30 );
				VM2_end_param_map();
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_stop",			::x4wwt_condition_callback_to_state_stopped,		["speed"] );
				VM2_add_oneshots( "x4_turret_stop_chuff" );
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def( "to_state_destruct", ::x4wwt_condition_callback_to_state_destruct );				// UNIMPLEMENTED.
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_wheels_neutral", ::x4wwt_condition_callback_to_state_wheels_neutral );	// UNIMPLEMENTED.
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_wheels_bump_impact", ::x4wwt_condition_callback_to_state_wheels_bump_impact );
				VM2_add_oneshots( "x4_turret_suspen_bump_hard" );
				VM2_begin_param_map( "x4wwt_zvelocity_front_left",	0.65, 0.30 );
				VM2_end_param_map();			
				VM2_begin_param_map( "x4wwt_zvelocity_front_right",	0.65, 0.30 );
				VM2_end_param_map();		
				VM2_begin_param_map( "x4wwt_zvelocity_rear_left",	0.65, 0.30 );
				VM2_end_param_map();	
				VM2_begin_param_map( "x4wwt_zvelocity_rear_right",	0.65, 0.30 );
				VM2_end_param_map();	
				VM2_begin_param_map( "speed", 						0.65, 0.30 );
				VM2_end_param_map();
			VM2_end_behavior_def();
	
			VM2_begin_behavior_def( "to_state_turret_rotate", ::x4wwt_condition_callback_to_state_turret_rotate,	["x4wwt_gun_yaw_rate"]); // UNIMPLEMENTED.
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_turret_rotate_accel", ::x4wwt_condition_callback_to_state_turret_rotate_accel );
				VM2_add_oneshots( "x4_turret_rotate_stop" );
				VM2_begin_param_map( "x4wwt_gun_yaw_rate", 1, 1 );
				VM2_end_param_map();
				VM2_begin_param_map( "speed", 0.6, 0.6 );
				VM2_end_param_map();
			VM2_end_behavior_def();	

			VM2_begin_behavior_def( "to_state_turret_rotate_decel", ::x4wwt_condition_callback_to_state_turret_rotate_decel, ["x4wwt_gun_yaw_rate"] );	// UNIMPLEMENTED.
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_turret_stopped", ::x4wwt_condition_callback_to_state_turret_stopped, ["pitch", "x4wwt_gun_yaw_rate"] );	// UNIMPLEMENTED.
			VM2_end_behavior_def();
		
			VM2_begin_behavior_def( "to_state_turret_elevate", ::x4wwt_condition_callback_to_state_turret_elevate, ["x4wwt_gun_pitch_rate"] );			// UNIMPLEMENTED.
			VM2_end_behavior_def();
		VM2_end_behavior_data();
		
		//STATE DATA//
		VM2_begin_state_data();
			
			//Group 1//
			VM2_begin_state_group( "main_oneshots", "state_enter_vehicle", "to_state_enter_vehicle", 50, 1.0 );
			
				VM2_begin_state_def( "state_off" );
					VM2_add_state_transition( "state_enter_vehicle", "to_state_enter_vehicle" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_startup" );
					VM2_add_state_transition( "state_idle", "to_state_idle" );
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
				
				VM2_begin_state_def( "state_enter_vehicle" );
					VM2_add_state_transition( "state_startup", "to_state_startup" );
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
					
			//Group 2//
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
			
			//Group 3//
			VM2_begin_state_group( "turret_rotate", "state_turret_rotate_accel", "to_state_turret_rotate_accel", 50, 1.0 );
			
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
			
			//Group 4//
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
		
		VM2_add_envelope( "x4_move_vel2vol",
			[
                [kX4Walker_MinSpeed,	0.0],
                [kX4Walker_MaxSpeed/4,	0.9],
                [kX4Walker_MaxSpeed,	0.0]
            ]
		);
		
		VM2_add_envelope( "x4_move2_lp_vel2vol",
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
		
		VM2_add_envelope( "x4_turret_rot_fast_vel2vol",
			[
		        [ -100 ,	.6 	],
		        [ -30 ,		.2 	],
		        [ 0,		0 	],
		        [ 30 ,		.2 	],
		        [ 100 ,		.6 	]
			]
		);
		
		VM2_add_envelope( "x4_turret_rot_slow_vel2vol",
			[
		        [ -100 ,	0.6 ],
		        [ -10 ,		0.5 ],
		        [ 0,		0 	],
		        [ 10 ,		0.5	],
		        [ 100 ,		0.6 ]
			]
		);
		
		VM2_add_envelope( "x4_turret_rot_slow_vel2pit",
			[
		        [ -30 ,		.7 ],
		        [ 0,		.5 ],
		        [ 30 ,		.7 ]
			]
		);
		
		VM2_add_envelope( "x4_turret_rot_fast_vel2pit",
			[
		        [ -150 ,	3 	],
				[ -30 ,		0.3 ],
		        [ 0,		0	],
		        [ 30 ,		0.3 ],
		        [ 150 ,		3 	]
			]
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_vel2vol",
			[
		        [ -10,		0.6 ],
				[ -1,		0.4 ],
		        [ 0,		0.0 ],
		        [ 1,		0.4 ],
		        [ 10,		0.6 ]
			]
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_gate",
			[
		        [ -0.3,		1 ],
		        [ -0.2,		0 ],
		        [ 0,		0 ],
		        [ 0.2,		0 ],
		        [ 0.3,		1 ]
			]
		);
		
		VM2_add_envelope( "x4_turret_pitch_rate_vel2pit",
			[
		        [ -100,		.5 ],
		        [ 0,		.5 ],
		        [ 100,		.5 ]
			]
		);

		VM2_add_envelope( "x4_move_vel2pch",
			[
				[kX4Walker_MinSpeed,	0.9],
				[kX4Walker_MaxSpeed,	1.1]
			]			 				 
		);
		VM2_add_envelope( "x4_move2_lp_vel2pch",
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
		
		VM2_add_envelope( "x4_veh_speed_to_turret_rot_vel2vol",
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
		
		VM2_add_envelope( "x4_suspen_vel2vol",
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
		
		VM2_add_envelope( "x4_move_pit2pch",
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
		        [1.00,  0.50],
		        [1.60,  1.00]
			]
		);
		
		VM2_add_envelope( "xwalk_shutoff_duck_envelope",
			[
		        [0.00,  1.00],
		        [0.16,  0.40],
		        [1.10,  0.00]
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
kXWalker_Wheel_Bounce_Thresh		= 20;

x4wwt_condition_callback_to_state_off(curr_smoothed_input_keyed_values, vars)
{
	return true;	
}

x4wwt_condition_callback_to_state_enter_vehicle(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	player_inside = curr_smoothed_input_keyed_values["x4wwt_player_driver"];
	if (player_inside)
	{
		result = true;	
	}
	return result;		
}

x4wwt_condition_callback_to_state_exit_vehicle(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	player_inside = curr_smoothed_input_keyed_values["x4wwt_player_driver"];
	if (!player_inside)
	{
		result = true;	
	}
	return result;		
}

x4wwt_condition_callback_to_state_startup(curr_smoothed_input_keyed_values, vars)
{
	// initial some globals for the vehicle
	vars.g_xwalk_pitched_hard = false;  	// used for when the vehicle has a big pitch angle change
	vars.g_xwalk_was_stopped = true;    
	vars.g_xwalk_time_started_to_move = 0;  // used in places to calculate how long the vehicle has been moving.
		
	return true;		
}

x4wwt_condition_callback_to_state_shutoff(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	player_inside = curr_smoothed_input_keyed_values["x4wwt_player_driver"];
	// if the player is not inside the vehicle, then the player has exited
	if (!player_inside)
	{
		result = true;	
	}
	return result;		
}

x4wwt_condition_callback_to_state_idle(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	velo 		= curr_smoothed_input_keyed_values["speed"];
	
	// STATE TRIGGER CONDITION.
	if (velo <= kXWalker_Idle_Threshold)
	{
		result = true;
	}
	
	return result;
}

x4wwt_condition_callback_to_state_start_move(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	velo 		= curr_smoothed_input_keyed_values["speed"];
	//accel		= curr_smoothed_input_keyed_values["acceleration_g"];
		
	if ( !IsDefined( vars.start_move ) )
    {
		vars.start_move = SpawnStruct();
    	vars.start_move.prev_velo = velo;
    	vars.start_move.time_accel = 0;
    	vars.start_move.acceltime = 0;
    	vars.start_move.accelerating = false;
    	vars.start_move.strain_accel_last_trigger = 0;
    	vars.start_move.strain_accel_time_since_trigger = 1000;  
    }
	else
	{
		// get the delta velocity
		curr_dv = velo - vars.start_move.prev_velo;
		
		// check to see if we were previously accelerating and the delta vel was greater than zero
		
		if ( vars.start_move.accelerating == false && curr_dv > 0 )
		{
			// we can play the accelerate sound and set the accelerating variable to true.
			vars.start_move.accelerating = true;  
			vars.start_move.acceltime = gettime();  // store the time we started the acceleration
		}
		else if ( vars.start_move.accelerating == true && curr_dv > 0 )
		{
			// increase the amount of time it has been accelerating
			vars.start_move.time_accel = vars.start_move.time_accel + gettime() - vars.start_move.acceltime;
		}
		else if (curr_dv <= 0 || velo >= kX4Walker_MaxSpeed)
		{
			// we are no longer accelerating reset the variables
			vars.start_move.accelerating = false;
			vars.start_move.acceltime = 0;
			vars.start_move.time_accel = 0;
		}
		
		
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
				
				// once the acceleration is triggered, capture the time of when moving started.
				vars.g_xwalk_time_started_to_move = gettime();
				
				// reset various variables
				vars.start_move.acceltime = 0;
				vars.start_move.accelerating = false;
				vars.start_move.time_accel = 0;
				vars.g_xwalk_pitched_hard = false;
				vars.start_move.strain_accel_last_trigger = gettime();
				vars.g_xwalk_was_stopped = false; 
				
			}
		}
		else if ( vars.start_move.time_accel > 400 && curr_dv > 0.4 )
		{
			// we check to see if a hard acceleration has occured.   
			// if the time accel is greater than the 400ms threshold and the delta velocity is big enough trigger the acceleration.
			result = true;
			vars.g_xwalk_time_started_to_move = gettime();
			vars.start_move.acceltime = 0;
			vars.start_move.accelerating = false;
			vars.start_move.time_accel = 0;
			vars.g_xwalk_was_stopped = false;
		}
		else if (velo >= kX4Walker_MaxSpeed && vars.g_xwalk_was_stopped)
		{
			// if there was a very slow accel, this will cover it
			result = true;
			vars.g_xwalk_time_started_to_move = gettime();
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

x4wwt_condition_callback_to_state_moving(curr_smoothed_input_keyed_values, vars)
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

x4wwt_condition_callback_to_state_breaking( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	
	velo 	= curr_smoothed_input_keyed_values["speed"];
	pitch	= curr_smoothed_input_keyed_values["pitch"];
	
	// update the time moving
	time_x4_was_moving = gettime() - vars.g_xwalk_time_started_to_move;
	
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
		if ( abs( dp ) > .5 )
		{
//			result = 	["ONESHOTS_EXCLUSIVE",
//							["alias", "x4_turret_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4_turret_decel_1"];
			
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
			// if the vehicle was breaking and the delta is still < 0, increase the breaking time
			vars.breaking.time_breaking = vars.breaking.time_breaking + gettime() - vars.breaking.breaktime;
		}
		else if (curr_dv >= 0)
		{
			// if the delta >= 0 , we are no longer breaking.  Reset the variables.
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
//				["alias", "x4_turret_decel", "xwalk_stop_duck_envelope"],
//				["alias", "x4_turret_stop_squeal", "xwalk_stop_duck_envelope"]];
			result = ["x4_turret_decel_2"];
		}
		else if ( vars.breaking.time_breaking > 400 && curr_dv < -0.6 && time_x4_was_moving <= 2000 )
		{
			// if the breaking time is > than the threshold and the delta is large enough and the vehicle was NOT moving long enough
			// trigger a softer slow down - decel sound only.
			
			vars.breaking.breaktime = 0;
			vars.breaking.breaking = false;
			vars.breaking.time_breaking = 0;
//			result = 	["ONESHOTS_EXCLUSIVE",	
//							["alias", "x4_turret_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4_turret_decel_1"];
		}
		else if ( velo < kXWalker_Move_To_Stopped_Thresh )
		{
			// this should cover the case when a very slow slow down occrus
			result = true;
			vars.breaking.breaktime = 0;
			vars.breaking.breaking = false;
			vars.breaking.time_breaking = 0;
//			result = 	["ONESHOTS_EXCLUSIVE",	
//							["alias", "x4_turret_decel", "xwalk_stop_duck_envelope"]
//						];
			result = ["x4_turret_decel_1"];
		}
		
		// store the previous velo and pitch		
		vars.breaking.prev_velo	= velo;
    	vars.breaking.prev_pitch = pitch;
	}

	return result;
}

x4wwt_condition_callback_to_state_stopped( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	curr_velo 	= curr_smoothed_input_keyed_values["speed"];
	//accel		= curr_smoothed_input_keyed_values["acceleration_g"];
	
	// STATE TRIGGER CONDITION. if the velocity is below the threshold then it has stopped.
	if ( curr_velo < kXWalker_Move_To_Stopped_Thresh )
	{
		result = true;
		vars.g_xwalk_was_stopped = true;  //set the global stopped to true.
	}
		
	return result;
}

x4wwt_condition_callback_to_state_destruct( curr_smoothed_input_keyed_values, vars )
{
	return false;	
}

x4wwt_condition_callback_to_state_wheels_neutral( curr_smoothed_input_keyed_values, vars )
{
	return false;
}

x4wwt_condition_callback_to_state_wheels_bump_impact( curr_smoothed_input_keyed_values, vars )
{
	// this handles when to play a suspension bump sound.
	
	// create an arrary for the different wheel id's
	wheel_vel_ids = ["zv_front_left", "zv_front_right", "zv_rear_left", "zv_rear_right"];
	
	// create arrary and store the current wheel velocities.
	zv = [];
	zv["zv_front_left"] 	= curr_smoothed_input_keyed_values["x4wwt_zvelocity_front_left"];
	zv["zv_front_right"]	= curr_smoothed_input_keyed_values["x4wwt_zvelocity_front_right"];
	zv["zv_rear_left"] 		= curr_smoothed_input_keyed_values["x4wwt_zvelocity_rear_left"];
	zv["zv_rear_right"] 	= curr_smoothed_input_keyed_values["x4wwt_zvelocity_rear_right"];
	
	// get the vehicle speed
	velo = curr_smoothed_input_keyed_values["speed"];
	
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
			// store the current velocity as the previous velocity.
			vars.wheels_bump_impact.prev_zv[wheel_tag] = zv[wheel_tag];			
		}
	}
	
	return result;
}

x4wwt_condition_callback_to_state_turret_rotate( curr_smoothed_input_keyed_values, vars )
{
	result = false;
	return result;
}

x4wwt_condition_callback_to_state_turret_stopped( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	return result;
}

x4wwt_condition_callback_to_state_turret_rotate_accel( curr_smoothed_input_keyed_values, vars )
{
	// TODO could use some optimizing - TODO Lp.
	
	result = false;
	rot_velo = abs( curr_smoothed_input_keyed_values[ "x4wwt_gun_yaw_rate" ] );
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
//								["alias", "x4_turret_rotate_stop", "xwalk_stop_duck_envelope"]
//							];
				result = ["x4_turret_rotate_stop"];
				
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
//								["alias", "x4_turret_rotate_stop", "xwalk_stop_duck_envelope"]
//							];
				result = ["x4_turret_rotate_stop"];
				
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

x4wwt_condition_callback_to_state_turret_rotate_decel( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	return result;
}

x4wwt_condition_callback_to_state_turret_elevate( curr_smoothed_input_keyed_values, vars )
{
	result		= false;
	return result;
}

/**********************************************************************************************************/
/****************************************** CUSTOM INPUT CALLBACKS ****************************************/
/**********************************************************************************************************/
x4wwt_input_callback_wheel_zvelocity_front_left()
{
	return x4wwt_input_callback_wheel_zvelocity( "tag_wheel_front_left" );
}

x4wwt_input_callback_wheel_zvelocity_front_right()
{
	return x4wwt_input_callback_wheel_zvelocity( "tag_wheel_front_right" );
}

x4wwt_input_callback_wheel_zvelocity_rear_left()
{
	return x4wwt_input_callback_wheel_zvelocity( "tag_wheel_back_left" );
}

x4wwt_input_callback_wheel_zvelocity_rear_right()
{
	return x4wwt_input_callback_wheel_zvelocity( "tag_wheel_back_right" );
}

x4wwt_input_callback_wheel_zvelocity(wheel_tag)
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	velocity_vector = vehicle_entity vehicle_scripts\_x4walker_wheels_turret::get_wheel_velocity( wheel_tag );
	z_velocity = velocity_vector[2];
	return z_velocity;
}

x4wwt_input_callback_gun_pitch_rate()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	rate = vehicle_entity vehicle_scripts\_x4walker_wheels_turret::get_gun_pitch_rate();
	return rate;
}

x4wwt_input_callback_gun_yaw_rate()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	rate = vehicle_entity vehicle_scripts\_x4walker_wheels_turret::get_gun_yaw_rate();
	return rate;
}

x4wwt_input_callback_player_driver()
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








