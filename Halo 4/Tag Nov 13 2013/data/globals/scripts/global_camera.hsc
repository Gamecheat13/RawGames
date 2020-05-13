// =================================================================================================
// =================================================================================================
// =================================================================================================
// CAMERA HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// FOV
// -------------------------------------------------------------------------------------------------
// variables
global real R_FOV_default		= 78.0;
global long l_sys_transition_fov_thread = 0;

// functions
// === transition_fov: Tranisitions FOV over time
//			r_fov_start = starting FOV value
//				[r_fov_start < 0] = camera_fov; current camera FOV
//			r_fov_end = final FOV value
//				[r_fov_end < 0] = R_FOV_default; Default camera FOV value
//			r_seconds = number of seconds the gravity transition should take place
//
//			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
//	RETURNS:  void
script static void transition_fov( real r_fov_start, real r_fov_end, real r_seconds, short s_refresh )
local long l_local_thread = 0;

	if ( l_sys_transition_fov_thread != 0 ) then
		kill_thread( l_sys_transition_fov_thread );
	end
	
	l_sys_transition_fov_thread = thread( sys_transition_fov(r_fov_start, r_fov_end, r_seconds, s_refresh) );
	l_local_thread = l_sys_transition_fov_thread;
	sleep_until( not IsThreadValid(l_local_thread), 1 );

end

// === sys_transition_fov: System function for transition_FOV
//		NOTE: DO NOT USE THIS FUNCTION
script static void sys_transition_fov( real r_fov_start, real r_fov_end, real r_seconds, short s_refresh )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_fov_range = 0.0;
static real r_fov_delta = 0.0;
static real r_time_range = 0.0;
	
	// set defaults
	if ( r_fov_start < 0 ) then
		r_fov_start = camera_fov;
	end
	if ( r_fov_end < 0 ) then
		r_fov_end = R_FOV_default;
	end
	if ( s_refresh < 0 ) then
		s_refresh = 1;
	end
	// get start time	
	l_time_start = game_tick_get();
	
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_seconds );

	// setup variables
	r_fov_range = r_fov_end - r_fov_start;
	r_time_range = l_time_end - l_time_start;
	
	if ( r_time_range > 0.001 ) then
		repeat
			r_fov_delta = real( game_tick_get()-l_time_start ) / r_time_range;
			// set fov to the current % of time progress
			camera_fov = r_fov_start + ( r_fov_range * r_fov_delta );
		until ( game_tick_get() >= l_time_end, s_refresh );
	end
	camera_fov = r_fov_end ;

end



// -------------------------------------------------------------------------------------------------
// GAZE
// -------------------------------------------------------------------------------------------------
// variables
global long L_gazelock_p0_thread					= 0;
global long L_gazelock_p1_thread					= 0;
global long L_gazelock_p2_thread					= 0;
global long L_gazelock_p3_thread					= 0;

// functions
// === players_control_lock_gaze: Lock/unlock gaze of players on a point reference
//			s_player = player index to apply gaze on
//				[s_player < 0] = apply to all players
//			pr_point = point reference to lock gaze on
//				[pr_point == NONE] = When b_lock == FALSE, force unlocking of the gaze, no matter the current point reference
//			r_velocity = max velocity degrees/second camera transition
//			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
//	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
//	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
script static boolean players_control_lock_gaze( short s_player, point_reference pr_point, real r_velocity, boolean b_lock )
/*
static point_reference pr_player0 = NONE; 
static point_reference pr_player1 = NONE; 
static point_reference pr_player2 = NONE; 
static point_reference pr_player3 = NONE; 
*/
local boolean b_return = FALSE;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, 0 );
			player_control_lock_gaze( player0, pr_point, r_velocity );
			//pr_player0 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player1)) and ( (s_player < 0) or (s_player == 1) ) ) then
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, 0 );
			player_control_lock_gaze( player1, pr_point, r_velocity );
			//pr_player1 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, 0 );
			player_control_lock_gaze( player2, pr_point, r_velocity );
			//pr_player2 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player3)) and ( (s_player < 0) or (s_player == 3) ) ) then
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, 0 );
			player_control_lock_gaze( player3, pr_point, r_velocity );
			//pr_player3 = pr_point;
			b_return = TRUE;
		end
	end
	
	// return
	b_return;

end

//xxx
script static boolean players_control_lock_gaze_trigger( short s_player, point_reference pr_point, real r_velocity, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
local boolean b_return = FALSE;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, thread( sys_players_control_lock_gaze_trigger(0,pr_point,r_velocity,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, thread( sys_players_control_lock_gaze_trigger(1,pr_point,r_velocity,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, thread( sys_players_control_lock_gaze_trigger(2,pr_point,r_velocity,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, thread( sys_players_control_lock_gaze_trigger(3,pr_point,r_velocity,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
	end
	
	// return
	b_return;

end

//xxx
script static void sys_players_control_lock_gaze_trigger( short s_player, point_reference pr_point, real r_velocity, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
	sleep_until( volume_test_object(tv_volume,player_get(s_player)) == b_inside, 1 );
	players_control_lock_gaze( s_player, pr_point, r_velocity, b_lock );
end

// === players_control_lock_gaze_clamp: Lock/unlock gaze of players on a point reference
//			s_player = player index to apply gaze on
//				[s_player < 0] = apply to all players
//			pr_point = point reference to lock gaze on
//				[pr_point == NONE] = When b_lock == FALSE, force unlocking of the gaze, no matter the current point reference
//			r_angle = angle of look control
//			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
//	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
//	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
script static boolean players_control_lock_gaze_clamp( short s_player, point_reference pr_point, real r_angle, boolean b_lock )
local boolean b_return = FALSE;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, 0 );
			player_control_clamp_gaze( player0, pr_point, r_angle );
			//pr_player0 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, 0 );
			player_control_clamp_gaze( player1(), pr_point, r_angle );
			//pr_player1 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, 0 );
			player_control_clamp_gaze( player2(), pr_point, r_angle );
			//pr_player2 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, 0 );
			player_control_clamp_gaze( player3(), pr_point, r_angle );
			//pr_player3 = pr_point;
			b_return = TRUE;
		end
	
	end
	
	// return
	b_return;

end

// xxx
script static boolean players_control_lock_gaze_clamp_trigger( short s_player, point_reference pr_point, real r_angle, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
local boolean b_return = FALSE;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, thread( sys_players_control_lock_gaze_clamp_trigger(0,pr_point,r_angle,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, thread( sys_players_control_lock_gaze_clamp_trigger(1,pr_point,r_angle,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, thread( sys_players_control_lock_gaze_clamp_trigger(2,pr_point,r_angle,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
		if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, thread( sys_players_control_lock_gaze_clamp_trigger(3,pr_point,r_angle,b_lock,tv_volume,b_inside) ) );
			b_return = TRUE;
		end
	end
	
	// return
	b_return;

end

// xxx
script static void sys_players_control_lock_gaze_clamp_trigger( short s_player, point_reference pr_point, real r_angle, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
	sleep_until( volume_test_object(tv_volume,player_get(s_player)) == b_inside, 1 );
	players_control_lock_gaze_clamp( s_player, pr_point, r_angle, b_lock );
end

// === players_control_lock_gaze_clamp: Lock/unlock gaze of players on a point reference
//			s_player = player index to apply gaze on
//				[s_player < 0] = apply to all players
//XXX
//			r_angle = angle of look control
//			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
//	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
//	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
script static boolean players_control_clamp_gaze_marker( short s_player, object obj_target, string_id str_marker, real r_angle, boolean b_lock )
local boolean b_return = FALSE;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, 0 );
			player_control_clamp_gaze_marker( player0, obj_target, str_marker, r_angle );
			//pr_player0 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, 0 );
			player_control_clamp_gaze_marker( player1(), obj_target, str_marker, r_angle );
			//pr_player1 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, 0 );
			player_control_clamp_gaze_marker( player2(), obj_target, str_marker, r_angle );
			//pr_player2 = pr_point;
			b_return = TRUE;
		end
		if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, 0 );
			player_control_clamp_gaze_marker( player3(), obj_target, str_marker, r_angle );
			//pr_player3 = pr_point;
			b_return = TRUE;
		end
	
	end
	
	// return
	b_return;

end

// XXX
script static boolean players_control_clamp_gaze_marker_trigger( short s_player, object obj_target, string_id str_marker, real r_angle, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
local boolean b_return = FALSE;
local long l_thread_new = 0;

	if ( not b_lock ) then
		b_return = players_control_unlock_gaze( s_player );
	end
	if ( b_lock ) then
		if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
			l_thread_new = thread( sys_players_control_clamp_gaze_marker_trigger(0,obj_target,str_marker,r_angle,b_lock,tv_volume,b_inside) );
			L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, l_thread_new );
			b_return = TRUE;
		end
		if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
			l_thread_new = thread( sys_players_control_clamp_gaze_marker_trigger(1,obj_target,str_marker,r_angle,b_lock,tv_volume,b_inside) );
			L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, l_thread_new );
			b_return = TRUE;
		end
		if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
			l_thread_new = thread( sys_players_control_clamp_gaze_marker_trigger(2,obj_target,str_marker,r_angle,b_lock,tv_volume,b_inside) );
			L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, l_thread_new );
			b_return = TRUE;
		end
		if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
			l_thread_new = thread( sys_players_control_clamp_gaze_marker_trigger(3,obj_target,str_marker,r_angle,b_lock,tv_volume,b_inside) );
			L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, l_thread_new );
			b_return = TRUE;
		end
	end
	
	// return
	b_return;

end

// XXX
script static void sys_players_control_clamp_gaze_marker_trigger( short s_player, object obj_target, string_id str_marker, real r_angle, boolean b_lock, trigger_volume tv_volume, boolean b_inside )
	sleep_until( volume_test_object(tv_volume,player_get(s_player)) == b_inside, 1 );
	players_control_clamp_gaze_marker( s_player, obj_target, str_marker, r_angle, b_lock );
end

// === sys_gaze_unlock: Unlocks players gaze
//			s_player = player index to apply gaze on
//				[s_player < 0] = apply to all players
//	RETURNS:  boolean; TRUE if gaze unlock was applied
script static boolean players_control_unlock_gaze( short s_player )
local boolean b_return = FALSE;

	if ( (player_valid(player0)) and ( (s_player < 0) or (s_player == 0) ) ) then
		L_gazelock_p0_thread = f_thread_cleanup( L_gazelock_p0_thread, 0 );
		player_control_unlock_gaze( player0 );
		b_return = TRUE;
	end
	if ( (player_valid(player1())) and ( (s_player < 0) or (s_player == 1) ) ) then
		L_gazelock_p1_thread = f_thread_cleanup( L_gazelock_p1_thread, 0 );
		player_control_unlock_gaze( player1() );
		b_return = TRUE;
	end
	if ( (player_valid(player2())) and ( (s_player < 0) or (s_player == 2) ) ) then
		L_gazelock_p2_thread = f_thread_cleanup( L_gazelock_p2_thread, 0 );
		player_control_unlock_gaze( player2() );
		b_return = TRUE;
	end
	if ( (player_valid(player3())) and ( (s_player < 0) or (s_player == 3) ) ) then
		L_gazelock_p3_thread = f_thread_cleanup( L_gazelock_p3_thread, 0 );
		player_control_unlock_gaze( player3() );
		b_return = TRUE;
	end

	// return
	b_return;
	
end



// -------------------------------------------------------------------------------------------------
// CAMERA SHAKE
// -------------------------------------------------------------------------------------------------
// use example: cam_shake_player( player0, 1, 1, 1, 7);
global boolean b_screenshake_shake 							= FALSE;	// Adding these debug variables for now.  will integrate into these functions
global boolean b_screenshake_rumble 						= FALSE;
global boolean b_screenshake_audio = FALSE; // check whether screenshake audio is already playing

script static void camera_shake_player (player actor, real attack, real intensity, short duration, real decay)
	camera_shake_player (actor, attack, intensity, duration, decay, NONE);
end

script static void camera_shake_player (player actor, real attack, real intensity, short duration, real decay, sound shake_sound)
	player_effect_set_max_rotation_for_player (actor, (intensity*3), (intensity*3), (intensity*3));
	player_effect_set_max_rumble_for_player (actor, 1, 1);
	player_effect_start_for_player (actor, intensity, attack);
            
	// play the sound
	if (shake_sound != NONE) then
		sound_impulse_start(shake_sound, NONE, 1);
	end
	
	if ( duration >= 0 ) then
		sleep( duration * 30);
	end

	if ( decay >= 0 ) then
		player_effect_stop_for_player( actor, decay );
	end

	player_effect_set_max_rumble_for_player (actor, 0, 0);
end

script static void camera_shake_all_coop_players ( real attack, real intensity, short duration, real decay)
	camera_shake_all_coop_players(attack, intensity, duration, decay, NONE);
end

// camera shake for all 4 coop players
script static void camera_shake_all_coop_players ( real attack, real intensity, short duration, real decay, sound shake_sound)

	// play the sound
	if (shake_sound != NONE) then
		sound_impulse_start(shake_sound, NONE, 1);
	end
	
	player_effect_set_max_rotation_for_player (player0, (intensity*3), (intensity*3), (intensity*3));
	player_effect_set_max_rumble_for_player (player0, 1, 1);
	player_effect_start_for_player (player0, intensity, attack);

	if ( game_coop_player_count() <= 2 ) then
		player_effect_set_max_rotation_for_player (player1, (intensity*3), (intensity*3), (intensity*3));
		player_effect_set_max_rumble_for_player (player1, 1, 1);	
		player_effect_start_for_player (player1, intensity, attack);
	end
		
	if ( game_coop_player_count() <= 3 ) then	
		player_effect_set_max_rotation_for_player (player2, (intensity*3), (intensity*3), (intensity*3));
		player_effect_set_max_rumble_for_player (player2, 1, 1);
		player_effect_start_for_player (player2, intensity, attack);
	end
	
	if ( game_coop_player_count() <= 4 ) then		
		player_effect_set_max_rotation_for_player (player3, (intensity*3), (intensity*3), (intensity*3));	
		player_effect_set_max_rumble_for_player (player3, 1, 1);
		player_effect_start_for_player (player3, intensity, attack);
	end
	
	sleep (duration * 30);
	
	player_effect_stop_for_player (player0, decay);
	player_effect_set_max_rumble_for_player (player0, 0, 0);
	
	if ( game_coop_player_count() <= 2 ) then
		player_effect_set_max_rumble_for_player (player1, 0, 0);
		player_effect_stop_for_player (player1, decay);
	end
	
	if ( game_coop_player_count() <= 3 ) then
		player_effect_set_max_rumble_for_player (player2, 0, 0);
		player_effect_stop_for_player (player2, decay);
	end
	
	if ( game_coop_player_count() <= 4 ) then
		player_effect_set_max_rumble_for_player (player3, 0, 0);
		player_effect_stop_for_player (player3, decay);
	end

end

script static void start_camera_shake_loop (string shake_type, string shake_frequency)
	start_camera_shake_loop(shake_type, shake_frequency, NONE);
end

//	start_camera_shake_loop (shake_type, shake_frequency):
//				Use:
//					shake_type: 			"weak", "medium" or "heavy" for desired intensity
//					shake_frequency:	"low", "medium" or "long" for desired wait between shakes
script static void start_camera_shake_loop (string shake_type, string shake_frequency, sound shake_sound)

	s_camera_shake_loop_on = TRUE;
	
	print("global: starting camera shake");
	
	repeat
		if (shake_type == "weak") then
			thread (camera_shake_all_coop_players ( real_random_range(0.25, 1.5), real_random_range(0.1, 0.23), real_random_range(0.25, 1.5), real_random_range(0.1, 1.0), shake_sound));
			print("low shake!"); 
		elseif (shake_type == "medium") then
			thread (camera_shake_all_coop_players ( real_random_range(0.75, 2.25), real_random_range(0.23, 0.36), real_random_range(0.75, 2.25), real_random_range(0.5, 1.5), shake_sound));
			print("medium shake!"); 
		elseif (shake_type == "heavy") then
			thread (camera_shake_all_coop_players ( real_random_range(1.25, 3), real_random_range(0.35, 0.7), real_random_range(1.5, 3), real_random_range(1, 2.5), shake_sound));
			print("heavy shake!"); 
		else
			thread (camera_shake_all_coop_players ( real_random_range(0.75, 2.25), real_random_range(0.23, 0.36), real_random_range(0.75, 2.25), real_random_range(0.5, 1.5), shake_sound));
			print("default shake!"); 
		end
		
		if (shake_frequency == "long") then
			sleep_s(real_random_range(8, 15));
		elseif (shake_frequency == "medium") then
			sleep_s(real_random_range(5, 10));
		elseif (shake_frequency == "short") then
			sleep_s(real_random_range(2, 6));	
		else
			sleep_s(real_random_range(5, 10));
		end
		
	until (s_camera_shake_loop_on == FALSE, 1);

end

script static void stop_camera_shake_loop()
	s_camera_shake_loop_on = FALSE;
	print("global: stopping camera shake");
	sleep (1);
end


//stop rumble -- put in to fix bug 49444 on a global scale
script static void stop_camera_shake
	print ("stop camera shake");
	player_effect_stop_for_player (player0, 0);
	player_effect_set_max_rumble_for_player (player0, 0, 0);
	
	if ( game_coop_player_count() <= 2 ) then
		player_effect_set_max_rumble_for_player (player1, 0, 0);
		player_effect_stop_for_player (player1, 0);
	end
	
	if ( game_coop_player_count() <= 3 ) then
		player_effect_set_max_rumble_for_player (player2, 0, 0);
		player_effect_stop_for_player (player2, 0);
	end
	
	if ( game_coop_player_count() <= 4 ) then
	player_effect_set_max_rumble_for_player (player3, 0, 0);
		player_effect_stop_for_player (player3, 0);
	end
end
