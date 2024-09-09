#include soundscripts\_snd;
#include soundscripts\_audio_vehicle_manager;
//#include vehicle_scripts\_cover_drone;

kCDrn_Speed_Min				= 0.0;
kCDrn_Speed_Max				= 2.5;

kCDrn_Startup_Scalar		= 1.0;
kCDrn_Shutdown_Scalar		= 1.0;
kCDrn_Throt_Scalar			= 0; //0.25; // Not using "throttle" (wine boat) for this vehicle.
kCDrn_Wheel_Scalar			= 0.50;	
kCDrn_Rolling_Scalar		= 0.50;
kCDrn_Servo_Scalar			= 0.10;	
kCDrn_Servo_Threshold		= 4.0;	

// Not using "throttle" (wine boat) for this vehicle.
kCDrn_Throt_Min				= 0;
kCDrn_Throt_Max				= 55;
kCDrn_Throt_Range			= kCDrn_Throt_Max - kCDrn_Throt_Min;
kCDrn_Throt_MinPch			= 1.00;
kCDrn_Throt_MaxPch			= 1.40;

kCDrn_Wheel_MinSpeed		= 0;
kCDrn_Wheel_MaxSpeed		= 45;
kCDrn_Wheel_MinVol			= 0.25;
kCDrn_Wheel_MaxVol			= 0.60;
kCDrn_Wheel_MinPch			= 0.95;
kCDrn_Wheel_MaxPch			= 1.1;

kCDrn_BallRoll_MinSpeed		= 0;
kCDrn_BallRoll_MaxSpeed		= 20;
kCDrn_Ball_MinVol			= 0.0;
kCDrn_BallBump_MaxVol		= 0.9;
kCDrn_Ball_MinPch			= 0.8;
kCDrn_Ball_MaxPch			= 1.1;


////////////////////
// INITIALIZATION //
////////////////////
// Called on snd vehicle entity.
snd_init_cover_drone()
{
	// Register Input Callbacks.
	VM2_register_callback("input_cdrn_in_use",					::input_cdrn_in_use);
	VM2_register_callback("input_cdrn_speed",					::input_cdrn_speed);
	VM2_register_callback("input_cdrn_throttle",				::input_cdrn_throttle);
	VM2_register_callback("input_cdrn_wheel_speed_left",		::input_cdrn_wheel_speed_left);
	VM2_register_callback("input_cdrn_wheel_speed_right",		::input_cdrn_wheel_speed_right);
	VM2_register_callback("input_cdrn_ball_joint_pitch_rate",	::input_cdrn_ball_joint_pitch_rate);
	VM2_register_callback("input_cdrn_ball_joint_roll_rate",	::input_cdrn_ball_joint_roll_rate);
	VM2_register_callback("input_cdrn_stuck_amount",			::input_cdrn_stuck_amount);	
	
	// Register snd messages.
	snd_register_message("cdrn_auto_unlink", ::cdrn_auto_unlink);
	
	snd_message("snd_register_vehicle", "cover_drone", ::snd_cover_drone_constructor);
	    
	args = SpawnStruct();
	args.preset_name = "cover_drone";
	snd_message("snd_start_vehicle", args);
}

snd_stop_cover_drone(fadeout_time_, stop_delay_)
{
	self snd_message("snd_stop_vehicle", fadeout_time_, stop_delay_);
}

cdrn_intance_init(vars)
{
//	assert( IsDefined( vars ) );
//	
//	if ( !IsDefined( vars.g ) )
//	{
//		vars.g = SpawnStruct();
//		vars.g.inst_count	= 0;
//	}
}

/////////////////////
// PRESET CALLBACK //
/////////////////////

snd_cover_drone_constructor()
{
	VM2_begin_preset_def( "cover_drone" );
	
		//LOOPS//
		VM2_begin_loop_data();
			
			VM2_begin_loop_def( "cdrn_rolling_wheels_lp" );
				VM2_begin_param_map( "input_cdrn_speed", 0.5, 0.5 );
					VM2_add_param_map_env( "volume", "cdrn_rolling_wheels", "cdrn_rolling_wheels" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
			VM2_begin_loop_def( "cdrn_throttle_lw_lp");
				VM2_begin_param_map( "input_cdrn_throttle", 0.1, 0.5 );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_lw", "cdrn_throt2vol_lw" );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_all", "cdrn_throt2vol_all" );
					VM2_add_param_map_env( "pitch", "cdrn_throt2pch", "cdrn_throt2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
			VM2_begin_loop_def( "cdrn_throttle_md_lp" );
				VM2_begin_param_map( "input_cdrn_throttle", 0.1, 0.5 );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_md", "cdrn_throt2vol_md" );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_all", "cdrn_throt2vol_all" );
					VM2_add_param_map_env( "pitch", "cdrn_throt2pch", "cdrn_throt2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "cdrn_throttle_hi_lp" );
				VM2_begin_param_map( "input_cdrn_throttle", 0.1, 0.5 );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_hi", "cdrn_throt2vol_hi" );
					VM2_add_param_map_env( "volume", "cdrn_throt2vol_all", "cdrn_throt2vol_all" );
					VM2_add_param_map_env( "pitch", "cdrn_throt2pch", "cdrn_throt2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
			VM2_begin_loop_def( "cdrn_rccar_lg" );
				VM2_begin_param_map( "input_cdrn_wheel_speed_left", 0.09, 0.40 );
					VM2_add_param_map_env( "volume", "cdrn_wheel_vel2vol", "cdrn_wheel_vel2vol" );
					VM2_add_param_map_env( "pitch", "cdrn_wheel_vel2pch", "cdrn_wheel_vel2pch" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "input_cdrn_in_use", 0.09, 0.40 );
					VM2_add_param_map_env( "volume", "cdrn_wheel_inuse2vol", "cdrn_wheel_inuse2vol" );
					VM2_add_param_map_env( "pitch", "cdrn_wheel_inuse2pch", "cdrn_wheel_inuse2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "cdrn_rccar_md" ); //"wheel_right_lp"
				VM2_begin_param_map( "input_cdrn_wheel_speed_right", 0.15, 0.5 );
					VM2_add_param_map_env( "volume", "cdrn_wheel_vel2vol", "cdrn_wheel_vel2vol" );
					VM2_add_param_map_env( "pitch", "cdrn_wheel_vel2pch", "cdrn_wheel_vel2pch" );
				VM2_end_param_map();
				
				VM2_begin_param_map( "input_cdrn_in_use", 0.6, 0.2 );
					VM2_add_param_map_env( "volume", "cdrn_wheel_inuse2vol", "cdrn_wheel_inuse2vol" );
					VM2_add_param_map_env( "pitch", "cdrn_wheel_inuse2pch", "cdrn_wheel_inuse2pch" );
				VM2_end_param_map();
			VM2_end_loop_def();
		
		VM2_end_loop_data();
		
		//DEFINE ONESHOTS//
		VM2_begin_oneshot_data(0.25);
			
			VM2_begin_oneshot_def( "cdrn_startup", "cdrn_startup_duck_envelope" );
				VM2_begin_param_map( "input_cdrn_in_use" );
					VM2_add_param_map_env( "volume", "cdrn_startup_scalar" );							
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_shutdown", "cdrn_startup_duck_envelope" );
				VM2_begin_param_map( "input_cdrn_in_use" );
					VM2_add_param_map_env( "volume", "cdrn_shutdown_scalar" );							
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_wheel_start_move_l" , undefined , 0.25 , false , "cdrn_wheel_start_move" );
				VM2_begin_param_map( "input_cdrn_wheel_speed_left" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );				
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_wheel_stop_move_l" , undefined , 0.25 , false , "cdrn_wheel_stop_move" );
				VM2_begin_param_map( "input_cdrn_wheel_speed_left" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );					
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );					
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_wheel_start_move_r" , undefined , 0.25 , false , "cdrn_wheel_start_move" );
				VM2_begin_param_map( "input_cdrn_wheel_speed_right" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );					
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );				
				VM2_end_param_map();			
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_wheel_stop_move_r" , undefined , 0.25 , false , "cdrn_wheel_stop_move" );
				VM2_begin_param_map( "input_cdrn_wheel_speed_right" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );				
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );					
				VM2_end_param_map();			
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_ball_pitch_start" , undefined , 0.25 , false , "cdrn_ball_pitch_start_stop" );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );					
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );					
				VM2_end_param_map();			
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def(  "cdrn_ball_pitch_stop" , undefined , 0.25 , false , "cdrn_ball_pitch_start_stop" );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );					
				VM2_end_param_map();			
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_ball_roll_start_move" , undefined , 0.25 , false );
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );					
					VM2_add_param_map_env( "pitch", ::cdrn_servo_oneshot_pch_func, "cdrn_servo_oneshot_pch_scalar" );					
				VM2_end_param_map();			
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_ball_roll_stop_move" , undefined , 0.25 , false );
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_servo_oneshot_vol_scalar" );				
				VM2_end_param_map();			
			VM2_end_oneshot_def ();
			
			VM2_begin_oneshot_def( "cdrn_bump_lg", "cdrn_bump_duck_env" , 0.25 , false );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_bump_md", "cdrn_bump_duck_env" , 0.25 , false );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def( "cdrn_bump_sm", "cdrn_bump_duck_env", 0.25, false );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
			VM2_end_oneshot_def();			
			
			
		VM2_end_oneshot_data();
		
		//BEHAVIOR DATA//		
		VM2_begin_behavior_data();
		
			//Behaviors; State Group 1: Main Vehicle
			VM2_begin_behavior_def( "to_vehicle_off", ::to_vehicle_off, [ "input_cdrn_in_use" ] );
				VM2_add_loops("NONE");			
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_vehicle_startup", ::to_vehicle_startup, [ "input_cdrn_in_use" ] );
				VM2_add_loops("ALL");	
				VM2_add_oneshots( "cdrn_startup" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_vehicle_on", ::to_vehicle_on, [ "input_cdrn_in_use" ] );
				VM2_add_loops("ALL");
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_vehicle_shutdown", ::to_vehicle_shutdown, [ "input_cdrn_in_use" ] );
				VM2_add_loops("NONE");
				VM2_add_oneshots( "cdrn_shutdown" );
			VM2_end_behavior_def();	
				
			//Behaviors; State Group 2: Left Wheel (wheel_left)
			VM2_begin_behavior_def( "to_wheel_left_idle", ::to_wheel_left_idle, [ "input_cdrn_wheel_speed_left" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_left_start_move", ::to_wheel_left_start_move, [ "input_cdrn_wheel_speed_left" ] );
				VM2_add_oneshots( "cdrn_wheel_start_move_l" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_left_moving", ::to_wheel_left_moving, [ "input_cdrn_wheel_speed_left" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_left_stop_move", ::to_wheel_left_stop_move, [ "input_cdrn_wheel_speed_left" ] );
				VM2_add_oneshots( "cdrn_wheel_stop_move_l" );
			VM2_end_behavior_def();
			
			//Behaviors; State Group 3: Right Wheel (wheel_right)
			VM2_begin_behavior_def( "to_wheel_right_idle", ::to_wheel_right_idle, [ "input_cdrn_wheel_speed_right" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_right_start_move", ::to_wheel_right_start_move, [ "input_cdrn_wheel_speed_right" ] );
				VM2_add_oneshots( "cdrn_wheel_start_move_r" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_right_moving", ::to_wheel_right_moving, [ "input_cdrn_wheel_speed_right" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_wheel_right_stop_move", ::to_wheel_right_stop_move, [ "input_cdrn_wheel_speed_right" ] );
				VM2_add_oneshots( "cdrn_wheel_stop_move_r" );
			VM2_end_behavior_def();
			
			//Behaviors; State Group 4: Ball Joint Pitch (ball_pitch)
			VM2_begin_behavior_def( "to_ball_pitch_idle", ::to_ball_pitch_idle, [ "input_cdrn_ball_joint_pitch_rate" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_pitch_start_move", ::to_ball_pitch_start_move, [ "input_cdrn_ball_joint_pitch_rate" ] );
				VM2_add_oneshots( "cdrn_ball_pitch_start" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_pitch_moving", ::to_ball_pitch_moving, [ "speed" ] );
				VM2_begin_param_map( "input_cdrn_ball_joint_pitch_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_pitch_stop_move", ::to_ball_pitch_stop_move, [ "input_cdrn_ball_joint_pitch_rate" ] );
				VM2_add_oneshots( "cdrn_ball_pitch_stop" );
			VM2_end_behavior_def();
			
			//Behaviors; State Group 5: Ball Joint Roll (ball_roll)
			VM2_begin_behavior_def( "to_ball_roll_idle", ::to_ball_roll_idle, [ "input_cdrn_ball_joint_roll_rate" ] );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_roll_start_move", ::to_ball_roll_start_move, [ "input_cdrn_ball_joint_roll_rate" ] );
				VM2_add_oneshots( "cdrn_ball_roll_start_move" );
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_roll_moving", ::to_ball_roll_moving, [ "speed" ] );
				VM2_begin_param_map( "input_cdrn_ball_joint_roll_rate" );
					VM2_add_param_map_env( "volume", "cdrn_ball_roll_bump_vel2vol" );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_ball_roll_stop_move", ::to_ball_roll_stop_move, [ "input_cdrn_ball_joint_roll_rate" ] );
				//VM2_add_oneshots( "cdrn_ball_roll_stop_move" );												//Updated; commented out as per deprecated script.
			VM2_end_behavior_def();
		
		VM2_end_behavior_data();
		
		//STATES//
		VM2_begin_state_data();
			
			//Group 1
			VM2_begin_state_group( "vehicle", "vehicle_off", "to_vehicle_off", 50, 0.0);		
		
				VM2_begin_state_def( "vehicle_off" );
					VM2_add_state_transition( "vehicle_startup", "to_vehicle_startup" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "vehicle_startup", 0.0, 100 );
					VM2_add_state_transition( "vehicle_on", "to_vehicle_on" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "vehicle_on" );
					VM2_add_state_transition( "vehicle_shutdown", "to_vehicle_shutdown" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "vehicle_shutdown" );
					VM2_add_state_transition( "vehicle_off", "to_vehicle_off" );
				VM2_end_state_def();
				
			VM2_end_state_group();	

/*			
			//Group 2
			VM2_begin_state_group( "wheel_left", "wheel_left_idle", "to_wheel_left_idle" );
			
				VM2_begin_state_def( "wheel_left_idle" );
					VM2_add_state_transition( "wheel_left_start_move", "to_wheel_left_start_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheel_left_start_move" );
					VM2_add_state_transition( "wheel_left_moving", "to_wheel_left_moving" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheel_left_moving" );
					VM2_add_state_transition( "wheel_left_stop_move", "to_wheel_left_stop_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheel_left_stop_move" );												
					VM2_add_state_transition( "wheel_left_idle", "to_wheel_left_idle" );					
				VM2_end_state_def();																		
																											
			VM2_end_state_group();																			
																											
			//Group 3																						//Updated; commented out as per deprecated script.
			VM2_begin_state_group( "wheel_right", "wheel_right_idle", "to_wheel_right_idle" );				
																											
				VM2_begin_state_def( "wheel_right_idle" );													
					VM2_add_state_transition( "wheel_right_start_move", "to_wheel_right_start_move" );		
				VM2_end_state_def();																		
																											
				VM2_begin_state_def( "wheel_right_start_move" );
					VM2_add_state_transition( "wheel_right_moving", "to_wheel_right_moving" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheel_right_moving" );
					VM2_add_state_transition( "wheel_right_stop_move", "to_wheel_right_stop_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "wheel_right_stop_move" );
					VM2_add_state_transition( "wheel_right_idle", "to_wheel_right_idle" );
				VM2_end_state_def();
				
			VM2_end_state_group();																			
*/
			
			//Group 4
			VM2_begin_state_group( "ball_pitch", "ball_pitch_idle", "to_ball_pitch_idle", 50 );
			
				VM2_begin_state_def( "ball_pitch_idle" );
					VM2_add_state_transition( "ball_pitch_start_move", "to_ball_pitch_start_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_pitch_start_move" );
					VM2_add_state_transition( "ball_pitch_moving", "to_ball_pitch_moving" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_pitch_moving" );
					VM2_add_state_transition( "ball_pitch_stop_move", "to_ball_pitch_stop_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_pitch_stop_move" );
					VM2_add_state_transition( "ball_pitch_idle", "to_ball_pitch_idle" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
			//Group 5
			VM2_begin_state_group( "ball_roll", "ball_roll_idle", "to_ball_roll_idle", 50, 0.25);
			
				VM2_begin_state_def( "ball_roll_idle" );
					VM2_add_state_transition( "ball_roll_start_move", "to_ball_roll_start_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_roll_start_move" );
					VM2_add_state_transition( "ball_roll_moving", "to_ball_roll_moving" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_roll_moving" );
					VM2_add_state_transition( "ball_roll_moving", "to_ball_roll_moving" );
					VM2_add_state_transition( "ball_roll_stop_move", "to_ball_roll_stop_move" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "ball_roll_stop_move", 0.25, 60 );
					VM2_add_state_transition( "ball_roll_idle", "to_ball_roll_idle" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
		VM2_end_state_data();
		
		//ENVELOPES//
			VM2_add_envelope("cdrn_foo_env_function", ::foo_env_function ); 
			VM2_add_envelope("cdrn_throt2vol_all",
				[
					[ kCDrn_Throt_Max * 0.0000,	(0.65 + 0.35 * 0.0000) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.0204,	(0.65 + 0.35 * 0.0330) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.0816,	(0.65 + 0.35 * 0.0587) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.1836,	(0.65 + 0.35 * 0.1111) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.3265,	(0.65 + 0.35 * 0.2214) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.5102,	(0.65 + 0.35 * 0.4444) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 0.7346,	(0.65 + 0.35 * 0.7901) * kCDrn_Throt_Scalar ],
					[ kCDrn_Throt_Max * 1.0000,	(0.65 + 0.35 * 1.0000) * kCDrn_Throt_Scalar ]
                ]
//				,
//				[
//					[ kCDrn_Throt_Min, 0],																	//Updated; commented out as per deprecated script.
//					[ kCDrn_Throt_Max, 0]
//				]
			);
			
			VM2_add_envelope( "cdrn_rolling_wheels",
				[
					[ kCDrn_Speed_Max * 0.0000,	0.0000 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.0204,	0.0330 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.0816,	0.0587 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.1836,	0.1111 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.3265,	0.2214 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.5102,	0.4444 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 0.7346,	0.7901 * kCDrn_Rolling_Scalar ],
					[ kCDrn_Speed_Max * 1.0000,	1.0000 * kCDrn_Rolling_Scalar ]
                ] 
//				,
//				[
//					[ kCDrn_Throt_Min, 0 ],																	//Updated; commented out as per deprecated script.
//					[ kCDrn_Throt_Max, 0 ],
//				]
			);
			
			VM2_add_envelope( "cdrn_throt2vol_lw",
				[
					[ kCDrn_Throt_Min,				1.0 ],
                    [ kCDrn_Throt_Range	* 0.333,	1.0 ],
					[ kCDrn_Throt_Max,				0.0 ]
				]
			);
			
			VM2_add_envelope( "cdrn_throt2vol_md",
				[
					[ kCDrn_Throt_Min,								0.0 ],
                    [ kCDrn_Throt_Min + kCDrn_Throt_Range * 0.333,	1.0 ],
                    [ kCDrn_Throt_Min + kCDrn_Throt_Range * 0.666,	1.0 ],
                    [ kCDrn_Throt_Max,								0.6 ]	
                ]
			);
			
			VM2_add_envelope( "cdrn_throt2vol_hi",
				[
					[ kCDrn_Throt_Min,								0.0 ],
                    [ kCDrn_Throt_Min + kCDrn_Throt_Range * 0.666,	1.0 ],
                    [ kCDrn_Throt_Max,								1.0 ]
                ]
			);
			
			VM2_add_envelope( "cdrn_throt2pch",
				[			 	
                    [ 0.0,	kCDrn_Throt_MinPch ],
                    [ 1.0,	kCDrn_Throt_MaxPch ]
                ] 	
			);
			
			VM2_add_envelope( "cdrn_wheel_vel2vol",
				[
					[ kCDrn_Wheel_MaxSpeed * 0.0000,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.0000) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.0204,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.0330) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.0816,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.0587) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.1836,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.1111) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.3265,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.2214) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.5102,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.4444) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 0.7346,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 0.7901) * kCDrn_wheel_Scalar ],
					[ kCDrn_Wheel_MaxSpeed * 1.0000,	(kCDrn_Wheel_MinVol + (kCDrn_Wheel_MaxVol - kCDrn_Wheel_MinVol) * 1.0000) * kCDrn_wheel_Scalar ]
				]
			);
			
			VM2_add_envelope( "cdrn_wheel_vel2pch",
				[
			        [ kCDrn_Wheel_MinSpeed,	kCDrn_Wheel_MinPch ],
			        [ kCDrn_Wheel_MaxSpeed,	kCDrn_Wheel_MaxPch ]
			    ]
			);
		
			VM2_add_envelope( "cdrn_wheel_inuse2vol",
				[
					[ 0.0,	0],
                    [ 0.5,	kCDrn_Wheel_MaxVol ],
                    [ 1.0,	kCDrn_Wheel_MaxVol ]
                ]
			);
			
			VM2_add_envelope( "cdrn_wheel_inuse2pch",
				[
					 [ 0.0,	kCDrn_Wheel_MinPch/4 ],
                     [ 1.0,	1.0 ]
                ]
			);
			
			VM2_add_envelope( "cdrn_ball_roll_bump_vel2vol",
				[					
                    [ kCDrn_BallRoll_MinSpeed,		kCDrn_BallBump_MaxVol * 0.25 ],
                    [ kCDrn_BallRoll_MaxSpeed,		kCDrn_BallBump_MaxVol ]
                ]
			);
			
			VM2_add_envelope( "cdrn_startup_duck_envelope",								
				[
					[0.00,  1.00],
			        [0.20,	0.60],
			        [0.50,  0.60],
			        [0.60,  1.00]
			    ]
			);
			
			VM2_add_envelope( "cdrn_bump_duck_env",
				[
					[0.00,  1.00],
			        [0.10,	0.60],
			        [0.25,  0.60],
			        [0.50,  1.00]
			    ]
			);
			
			VM2_add_envelope( "cdrn_fullvol",
				[
					[0.00,	1.00],
			        [1.0,	1.00]
			    ]
			);
			
			VM2_add_envelope( "cdrn_startup_scalar",									
				[	
					[ 0.00,	kCDrn_Startup_Scalar ],									
			        [ 1.0,	kCDrn_Startup_Scalar ]									
			    ]
			);
			
			VM2_add_envelope( "cdrn_shutdown_scalar",
				[
					[ 0.00,	kCDrn_Shutdown_Scalar ],
			        [ 1.0,	kCDrn_Shutdown_Scalar ]
			    ]
			);
			
			VM2_add_envelope( "cdrn_servo_oneshot_vol_scalar",
				[
					[ kCDrn_Wheel_MinSpeed,	kCDrn_Servo_Scalar ],
					[ kCDrn_Wheel_MaxSpeed,	kCDrn_Servo_Scalar ]
				]
			);
			
			VM2_add_envelope( "cdrn_servo_oneshot_pch_scalar",
				[				 
					[kCDrn_BallRoll_MinSpeed,	kCDrn_Ball_MinPch],
//			        [kCDrn_BallRoll_MaxSpeed,	kCDrn_Ball_MaxPch]						//Updated; commented out as per deprecated script.
			        [kCDrn_BallRoll_MinSpeed,	0.8],
			        [kCDrn_BallRoll_MaxSpeed,	0.8]
			    ]
			);
				
	VM2_end_preset_def();		
}

// Test env function.
foo_env_function()
{
	return 1.0;
}


cdrn_servo_oneshot_pch_func( input )
{
	return RandomFloatRange( 0.7, 1.0);
}

		
////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////
/*
	BEHAVIOR CALLBACKS
	Called on vehicle instance.
*/

print_state(result, state, value_)
{
	if (IsArray(result) || result)
	{
		val_str = "";
		if (IsDefined(value_))
			val_str += value_;
			
		IPrintLnBold(state + " " + val_str);
	}
}

to_vehicle_off( curr_smoothed_input_keyed_values, vars )
{
	result =  curr_smoothed_input_keyed_values["input_cdrn_in_use"] == false;
	//print_state(result, "to_vehicle_off");
	return result;
}
	
to_vehicle_startup( curr_smoothed_input_keyed_values, vars )
{
	result =  curr_smoothed_input_keyed_values["input_cdrn_in_use"] == true;
	if (result)
	{
		//print_state(result, "to_vehicle_startup");
	}
	return result;
}

to_vehicle_on( curr_smoothed_input_keyed_values, vars )
{
	result =  curr_smoothed_input_keyed_values["input_cdrn_in_use"] == true;
	//print_state(result, "to_vehicle_on");
	return result;
}

to_vehicle_shutdown( curr_smoothed_input_keyed_values, vars )
{
	result = curr_smoothed_input_keyed_values["input_cdrn_in_use"] == false;
	//print_state(result, "to_vehicle_shutdown");
	return result;
}
				
to_wheel_left_idle( curr_smoothed_input_keyed_values, vars )
{
	spd	=  curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_left"];
	result	=  spd < kCDrn_Servo_Threshold;
	//print_state(result, "to_wheel_left_idle");
	return result;
}
	
to_wheel_left_start_move( curr_smoothed_input_keyed_values, vars )
{
	spd	= curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_left"];
	result	= spd > kCDrn_Servo_Threshold;
	if (result)
	{
		//print_state(result, "to_wheel_left_start_move");
	}
	return result;
}

to_wheel_left_moving( curr_smoothed_input_keyed_values, vars )
{
	spd	= curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_left"] > 0;
	result	= spd > 0;
	//print_state(result, "to_wheel_left_moving");
	return result;
}

to_wheel_left_stop_move( curr_smoothed_input_keyed_values, vars )
{
	spd	= curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_left"] < kCDrn_Servo_Threshold;
	result	= spd < kCDrn_Servo_Threshold;
	if (result)
	{
		//print_state(result, "to_wheel_left_stop_move");
	}
	return result;
}

to_wheel_right_idle( curr_smoothed_input_keyed_values, vars )
{
	spd	= curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_right"] < kCDrn_Servo_Threshold;
	result	= spd > 0;
	//print_state(result, "to_wheel_right_idle");
	return result;
}
	
to_wheel_right_start_move( curr_smoothed_input_keyed_values, vars )
{
	spd	=  curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_right"];
	result	= spd > kCDrn_Servo_Threshold;
	//print_state(result, "to_wheel_right_start_move");
	return result;
}

to_wheel_right_moving( curr_smoothed_input_keyed_values, vars )
{
	spd	= curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_right"];
	result	= spd > 0;
	//print_state(result, "to_wheel_right_moving");
	return result;
}

to_wheel_right_stop_move( curr_smoothed_input_keyed_values, vars )
{
	spd	=  curr_smoothed_input_keyed_values["input_cdrn_wheel_speed_right"];
	result	= spd < kCDrn_Servo_Threshold;
	//print_state(result, "to_wheel_right_stop_move");
	return result;
}

to_ball_pitch_idle( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_pitch_rate"];
	result	= abs( rate ) < kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_pitch_idle", rate);
//	}
	return result;
}
	
to_ball_pitch_start_move( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_pitch_rate"];
	result	= abs( rate ) > kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_pitch_start_move", rate);
//	}
	return result;
}

to_ball_pitch_moving( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_pitch_rate"];
	speed	= curr_smoothed_input_keyed_values["speed"];
//	result	= abs( rate ) > 0;
//	if (result)
//	{
//		print_state(result, "to_ball_pitch_moving", rate);
//	}
		
	result = do_bumps( rate, speed, vars );
	
	return result;
}

to_ball_pitch_stop_move( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_pitch_rate"];
	result	= abs( rate ) < kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_pitch_stop_move");
//	}
	return result;
}

to_ball_roll_idle( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_roll_rate"];
	result	= abs( rate ) < kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_roll_idle");
//	}
	return result;
}
	
to_ball_roll_start_move( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_roll_rate"];
	result	= abs( rate ) > kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_roll_start_move", rate);
//	}
	return result;
}

kCDrn_ball_roll_moving_accel_threshold_lw				= 2.0;
kCDrn_ball_roll_moving_accel_threshold_md				= 10.0;
kCDrn_ball_roll_moving_accel_threshold_lg				= 20.0;
kCDrn_ball_roll_moving_accel_oneshot_retrigger_msecs	= 0.25;
to_ball_roll_moving( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_roll_rate"];
	speed	= curr_smoothed_input_keyed_values["speed"];
		
	result = do_bumps( rate, speed, vars );
	
	return result;
}

do_bumps( rate, speed, vars )
{		
	result = true;	// Boolean to replace previously-used empty list.  Signals that we're still in this state, but don't play any oneshots.
	
	if ( !IsDefined( vars.to_ball_roll_moving ) )
    {
		vars.to_ball_roll_moving = SpawnStruct();
		v = vars.to_ball_roll_moving;
		
		v.prev_rate = rate;
		v.prev_accel_oneshot_time = 0;
    }
	v = vars.to_ball_roll_moving;
	
	accel = abs( rate - v.prev_rate );
	if (accel > 0)
	{
		//IPrintLn("Ball Roll Accell: " + accel);
	}
	curr_time_ms = GetTime();
	if ( speed > 0.5 && ( accel > kCDrn_ball_roll_moving_accel_threshold_lw ) && ( curr_time_ms - v.prev_accel_oneshot_time  > kCDrn_ball_roll_moving_accel_oneshot_retrigger_msecs ) )
	{
		if ( accel > kCDrn_ball_roll_moving_accel_threshold_lg )
		{
			result = [ "cdrn_bump_lg" ];
			//IPrintLnBold("BUMP LARGE");
		}
		else if ( accel > kCDrn_ball_roll_moving_accel_threshold_md )
		{
			result = [ "cdrn_bump_md" ];
			//IPrintLnBold("BUMP MEDIUM");
		}
		else
		{
			result = [ "cdrn_bump_sm" ];
			//IPrintLnBold("BUMP SMALL");
		}
		
		v.prev_accel_oneshot_time = curr_time_ms;
	}
	
	v.prev_rate = rate;
	
	if ( (IsArray(result) && result.size > 0 )|| result)
	{
		//print_state(true, "to_ball_roll_moving", rate);
	}
	
	return result;
}

to_ball_roll_stop_move( curr_smoothed_input_keyed_values, vars )
{
	rate	= curr_smoothed_input_keyed_values["input_cdrn_ball_joint_roll_rate"];
	result	= abs( rate ) < kCDrn_Servo_Threshold;
//	if (result)
//	{
//		print_state(result, "to_ball_roll_stop_move", rate);
//	}
	return result;
}


/*******************************************************************************/
/******************************* INPUT CALLBACKS *******************************/
/*******************************************************************************/
input_cdrn_in_use()
{
	result = 0;
	veh_ent = self VM2x_get_vehicle_entity();
	if ( IsDefined(veh_ent.linked_player) )
		result = 1.0;
	
	return result;
}

input_cdrn_speed()
{
	vehicle = self VM2x_get_vehicle_entity();
	speed = vehicle Vehicle_GetSpeed();
	//IPrintLn("speed: " + speed);
	return speed;
}

input_cdrn_throttle()
{
	left_speed = self input_cdrn_wheel_speed(0);
	right_speed = self input_cdrn_wheel_speed(1);
	throttle = (left_speed + right_speed) * 0.5;
	//IPrintLn("throttle: " + throttle);
	return throttle;
}

input_cdrn_wheel_speed_left()
{
	spd = self input_cdrn_wheel_speed(0);
	//IPrintLn("wheel_speed_left: " + spd);	
	return spd;
}

input_cdrn_wheel_speed_right()
{
	spd = self input_cdrn_wheel_speed(1);
	//IPrintLn("wheel_speed_right: " + spd);	
	return spd;
}

input_cdrn_wheel_speed(wheel)
{
	vehicle = self VM2x_get_vehicle_entity();
	
	if(!IsDefined(vehicle.cover_drone_wheels))
		vehicle.cover_drone_wheels = [];
	
	if(!IsDefined(vehicle.cover_drone_wheels[wheel]))
		vehicle.cover_drone_wheels[wheel] = SpawnStruct();
	
	if(wheel == 0)
		y_offset = 18;
	else
		y_offset = -18;
	
	vehicle.cover_drone_wheels[wheel].origin = vehicle.origin + AnglesToRight(vehicle.angles) * y_offset;
	
	speed = vehicle.cover_drone_wheels[wheel] maps\_shg_utility::get_differentiated_speed();
	return speed;
}

input_cdrn_ball_joint_pitch_rate()
{
	rate = self input_cdrn_ball_joint_rate(0);
	
//	if ( self input_cdrn_in_use() == true && rate > 10)
//		//IPrintLn("ball_pitch_rate: " + rate);

	return rate;
}

input_cdrn_ball_joint_roll_rate()
{
	rate = 0;
	
	if ( self input_cdrn_in_use() )
	{
		rate = self input_cdrn_ball_joint_rate(2);
		
		if ( abs( rate ) < 1.0)
		{
			rate = 0;
		}
		//IPrintLn("ball_roll_rate: " + rate);
	}

	return rate;
}

input_cdrn_ball_joint_rate(axis)
{
	vehicle = self VM2x_get_vehicle_entity();
	
	cur_time_msec = GetTime();
	
	if(!IsDefined(vehicle.ball_joint_last_update_msec))
	{
		vehicle.ball_joint_last_update_msec = cur_time_msec;
		vehicle.ball_joint_last_angles = vehicle.angles;
		vehicle.ball_joint_angles_rate = (0, 0, 0);

	}
	else if(vehicle.ball_joint_last_update_msec != cur_time_msec)
	{
		dt = (cur_time_msec - vehicle.ball_joint_last_update_msec) * .001;
		vehicle.ball_joint_last_update_msec = cur_time_msec;
		
		// the ball joint internally clamps itself to pitch and roll of these values, and we don't care about yaw
		// see MOBILE_COVER_MAX_PITCH/ROLL in CG_Vehicle_DoControllers()
		vehicle_angles = (
			Clamp(AngleClamp180(vehicle.angles[0]), -20, 20),
			0,
			Clamp(AngleClamp180(vehicle.angles[2]), -10, 10));
		
		
		delta_angles = vehicle_angles - vehicle.ball_joint_last_angles;
		delta_angles = (AngleClamp180(delta_angles[0]), AngleClamp180(delta_angles[1]), AngleClamp180(delta_angles[2]));
		vehicle.ball_joint_last_angles = vehicle.angles;

		vehicle.ball_joint_angles_rate = delta_angles / dt;		
	}
	
	return vehicle.ball_joint_angles_rate[axis];	
}

input_cdrn_stuck_amount()
{
	// TODO:
	return 0;
}

/*******************************************************************************/
/******************************* INPUT CALLBACKS *******************************/
/*******************************************************************************/
/*
	Called on vehicle instance.
*/
kCDrn_IMod_MinScalar	= 0.4;	// Mulitplier.
kCDrn_IMod_MaxScalar	= 1.2;	// Mulitplier.
kCDrn_IMod_MinDeltaTime	= 0.5;	// Secs.
kCDrn_IMod_MaxDeltaTime	= 2.0;	// Sces.

cdrn_wheel_speed_modifier_callback_linear(actual_speed, vars)
{	
	// Init persitent vars first time through.
	if ( !IsDefined( vars.wheel_speed_modifier ) )
    {
    	vars.wheel_speed_modifier = SpawnStruct();
		vars.wheel_speed_modifier.scalar_actual	= 1.0;
		vars.wheel_speed_modifier.scalar_target	= 1.0;
		vars.wheel_speed_modifier.start_time	= 0;
		vars.wheel_speed_modifier.curr_time		= 0;
		vars.wheel_speed_modifier.total_time	= 0;
		vars.wheel_speed_modifier.dt			= self VM2_get_update_rate();
		vars.wheel_speed_modifier.total_dist	= 0;
		vars.wheel_speed_modifier.dx			= 0;
		vars.wheel_speed_modifier.frac			= 0;
		/#
		vars.wheel_speed_modifier.going_down	= false;
		#/
    }
	
	v = vars.wheel_speed_modifier;
	v.curr_time = GetTime()/1000;
	
	if ( v.curr_time >= v.start_time + v.dt )	// Time to reset?
	{
		/#
		if ( v.going_down )
		{
			Assert( v.scalar_actual <= v.scalar_target );
		}
		#/
		
		// Reset params.
		v.start_time	= v.curr_time;
		v.scalar_actual	= 1.0;
		v.scalar_target	= RandomFloatRange(	kCDrn_IMod_MinScalar,		kCDrn_IMod_MaxScalar );
		v.total_time	= RandomFloatRange(	kCDrn_IMod_MinDeltaTime,	kCDrn_IMod_MaxDeltaTime );
		v.total_dist	= v.scalar_target - v.scalar_actual;
		v.frac			= v.dt/v.total_time;
		v.dx			= v.frac * v.total_dist;
	
		/#
		v.going_down	= (v.scalar_target < v.scalar_actual);
		#/
	}
	
	v.scalar_actual += v.dx;

//	// Debuging...
//	if (v.instance_name == "cdrn_0" && self.name == "rotor")
//	{
//		//IPrintLn("scalar=" + v.scalar_actual);
//	}
	
	return actual_speed * v.scalar_actual;
}

/*******************************************************************************/
/******************************* SND MSG HANDLERS ******************************/
/*******************************************************************************/
cdrn_auto_unlink()
{
	// Stubbed.  Play an "error-like" sound.
}

