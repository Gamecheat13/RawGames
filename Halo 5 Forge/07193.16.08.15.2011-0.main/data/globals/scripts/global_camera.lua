global r_fov_default:number=78.0; -- constant

--## SERVER
-- -------------------------------------------------------------------------------------------------
-- CAMERA SHAKE -- server
-- -------------------------------------------------------------------------------------------------

function rumble_shake_small(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_small", numSeconds);
end

function rumble_shake_medium(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_medium", numSeconds);
end

function rumble_shake_large(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_large", numSeconds);
end

function rumble_shake(numSeconds:number, rumble_shake:tag)
	RunClientScript ("start_rumble_shake_client", numSeconds, rumble_shake);
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- CAMERA HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- GAZE
-- -------------------------------------------------------------------------------------------------
-- variables
global l_gazelock_p0_thread:thread=nil;
global l_gazelock_p1_thread:thread=nil;
global l_gazelock_p2_thread:thread=nil;
global l_gazelock_p3_thread:thread=nil;

-- functions
-- === players_control_lock_gaze: Lock/unlock gaze of players on a point reference
--			s_player = player index to apply gaze on
--				[s_player < 0] = apply to all players
--			pr_point = point reference to lock gaze on
--				[pr_point == NONE] = When b_lock == FALSE, force unlocking of the gaze, no matter the current point reference
--			r_velocity = max velocity degrees/second camera transition
--			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
--	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
--	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
function players_control_lock_gaze( s_player:number, pr_point:point, r_velocity:number, b_lock:boolean ):boolean
	--[[
static point_reference pr_player0 = NONE; 
static point_reference pr_player1 = NONE; 
static point_reference pr_player2 = NONE; 
static point_reference pr_player3 = NONE; 
]]
	local b_return:boolean=false;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, nil);
			player_control_lock_gaze(PLAYERS.player0, pr_point, r_velocity);
			--pr_player0 = pr_point;
			b_return = true;
		end
		if player_valid(PLAYERS.player1) and (s_player < 0 or s_player == 1) then
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, nil);
			player_control_lock_gaze(PLAYERS.player1, pr_point, r_velocity);
			--pr_player1 = pr_point;
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, nil);
			player_control_lock_gaze(PLAYERS.player2, pr_point, r_velocity);
			--pr_player2 = pr_point;
			b_return = true;
		end
		if player_valid(PLAYERS.player3) and (s_player < 0 or s_player == 3) then
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, nil);
			player_control_lock_gaze(PLAYERS.player3, pr_point, r_velocity);
			--pr_player3 = pr_point;
			b_return = true;
		end
	end
	return b_return;
end

-- return
--xxx
function players_control_lock_gaze_trigger( s_player:number, pr_point:point, r_velocity:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):boolean
	local b_return:boolean=false;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, CreateThread(sys_players_control_lock_gaze_trigger, 0, pr_point, r_velocity, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player1()) and (s_player < 0 or s_player == 1) then
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, CreateThread(sys_players_control_lock_gaze_trigger, 1, pr_point, r_velocity, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, CreateThread(sys_players_control_lock_gaze_trigger, 2, pr_point, r_velocity, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player3()) and (s_player < 0 or s_player == 3) then
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, CreateThread(sys_players_control_lock_gaze_trigger, 3, pr_point, r_velocity, b_lock, tv_volume, b_inside));
			b_return = true;
		end
	end
	return b_return;
end

-- return
--xxx
function sys_players_control_lock_gaze_trigger( s_player:number, pr_point:point, r_velocity:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):void
	SleepUntil([| volume_test_object(tv_volume, player_get(s_player)) == b_inside ], 1);
	players_control_lock_gaze(s_player, pr_point, r_velocity, b_lock);
end

-- === players_control_lock_gaze_clamp: Lock/unlock gaze of players on a point reference
--			s_player = player index to apply gaze on
--				[s_player < 0] = apply to all players
--			pr_point = point reference to lock gaze on
--				[pr_point == NONE] = When b_lock == FALSE, force unlocking of the gaze, no matter the current point reference
--			r_angle = angle of look control
--			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
--	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
--	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
function players_control_lock_gaze_clamp( s_player:number, pr_point:point, r_angle:number, b_lock:boolean ):boolean
	local b_return:boolean=false;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, nil);
			player_control_clamp_gaze(PLAYERS.player0, pr_point, r_angle);
			--pr_player0 = pr_point;
			b_return = true;
		end
		if player_valid(player1()) and (s_player < 0 or s_player == 1) then
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, nil);
			player_control_clamp_gaze(player1(), pr_point, r_angle);
			--pr_player1 = pr_point;
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, nil);
			player_control_clamp_gaze(player2(), pr_point, r_angle);
			--pr_player2 = pr_point;
			b_return = true;
		end
		if player_valid(player3()) and (s_player < 0 or s_player == 3) then
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, nil);
			player_control_clamp_gaze(player3(), pr_point, r_angle);
			--pr_player3 = pr_point;
			b_return = true;
		end
	end
	return b_return;
end

-- return
-- xxx
function players_control_lock_gaze_clamp_trigger( s_player:number, pr_point:point, r_angle:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):boolean
	local b_return:boolean=false;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, CreateThread(sys_players_control_lock_gaze_clamp_trigger, 0, pr_point, r_angle, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player1()) and (s_player < 0 or s_player == 1) then
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, CreateThread(sys_players_control_lock_gaze_clamp_trigger, 1, pr_point, r_angle, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, CreateThread(sys_players_control_lock_gaze_clamp_trigger, 2, pr_point, r_angle, b_lock, tv_volume, b_inside));
			b_return = true;
		end
		if player_valid(player3()) and (s_player < 0 or s_player == 3) then
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, CreateThread(sys_players_control_lock_gaze_clamp_trigger, 3, pr_point, r_angle, b_lock, tv_volume, b_inside));
			b_return = true;
		end
	end
	return b_return;
end

-- return
-- xxx
function sys_players_control_lock_gaze_clamp_trigger( s_player:number, pr_point:point, r_angle:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):void
	SleepUntil([| volume_test_object(tv_volume, player_get(s_player)) == b_inside ], 1);
	players_control_lock_gaze_clamp(s_player, pr_point, r_angle, b_lock);
end

-- === players_control_lock_gaze_clamp: Lock/unlock gaze of players on a point reference
--			s_player = player index to apply gaze on
--				[s_player < 0] = apply to all players
--XXX
--			r_angle = angle of look control
--			b_lock = TRUE; lock gaze on the point reference, FALSE; Unlock the gaze on the point reference
--	RETURNS:  boolean; TRUE if gaze lock/unlock was applied
--	[TODO] Store point sets assigned to players so on the unlock it can be tested if they are currently looking at that point
function players_control_clamp_gaze_marker( s_player:number, obj_target:object, str_marker:string, r_angle:number, b_lock:boolean ):boolean
	local b_return:boolean=false;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, nil);
			player_control_clamp_gaze_marker(PLAYERS.player0, obj_target, str_marker, r_angle);
			--pr_player0 = pr_point;
			b_return = true;
		end
		if player_valid(player1()) and (s_player < 0 or s_player == 1) then
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, nil);
			player_control_clamp_gaze_marker(player1(), obj_target, str_marker, r_angle);
			--pr_player1 = pr_point;
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, nil);
			player_control_clamp_gaze_marker(player2(), obj_target, str_marker, r_angle);
			--pr_player2 = pr_point;
			b_return = true;
		end
		if player_valid(player3()) and (s_player < 0 or s_player == 3) then
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, nil);
			player_control_clamp_gaze_marker(player3(), obj_target, str_marker, r_angle);
			--pr_player3 = pr_point;
			b_return = true;
		end
	end
	return b_return;
end

-- return
-- XXX
function players_control_clamp_gaze_marker_trigger( s_player:number, obj_target:object, str_marker:string, r_angle:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):boolean
	local b_return:boolean=false;
	local l_thread_new:thread=nil;
	if  not b_lock then
		b_return = players_control_unlock_gaze(s_player);
	end
	if b_lock then
		if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
			l_thread_new = CreateThread(sys_players_control_clamp_gaze_marker_trigger, 0, obj_target, str_marker, r_angle, b_lock, tv_volume, b_inside);
			l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, l_thread_new);
			b_return = true;
		end
		if player_valid(player1()) and (s_player < 0 or s_player == 1) then
			l_thread_new = CreateThread(sys_players_control_clamp_gaze_marker_trigger, 1, obj_target, str_marker, r_angle, b_lock, tv_volume, b_inside);
			l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, l_thread_new);
			b_return = true;
		end
		if player_valid(player2()) and (s_player < 0 or s_player == 2) then
			l_thread_new = CreateThread(sys_players_control_clamp_gaze_marker_trigger, 2, obj_target, str_marker, r_angle, b_lock, tv_volume, b_inside);
			l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, l_thread_new);
			b_return = true;
		end
		if player_valid(player3()) and (s_player < 0 or s_player == 3) then
			l_thread_new = CreateThread(sys_players_control_clamp_gaze_marker_trigger, 3, obj_target, str_marker, r_angle, b_lock, tv_volume, b_inside);
			l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, l_thread_new);
			b_return = true;
		end
	end
	return b_return;
end

-- return
-- XXX
function sys_players_control_clamp_gaze_marker_trigger( s_player:number, obj_target:object, str_marker:string, r_angle:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):void
	SleepUntil([| volume_test_object(tv_volume, player_get(s_player)) == b_inside ], 1);
	players_control_clamp_gaze_marker(s_player, obj_target, str_marker, r_angle, b_lock);
end

-- === sys_gaze_unlock: Unlocks players gaze
--			s_player = player index to apply gaze on
--				[s_player < 0] = apply to all players
--	RETURNS:  boolean; TRUE if gaze unlock was applied
function players_control_unlock_gaze( s_player:number ):boolean
	local b_return:boolean=false;
	if player_valid(PLAYERS.player0) and (s_player < 0 or s_player == 0) then
		l_gazelock_p0_thread = f_thread_cleanup(l_gazelock_p0_thread, nil);
		player_control_unlock_gaze(PLAYERS.player0);
		b_return = true;
	end
	if player_valid(player1()) and (s_player < 0 or s_player == 1) then
		l_gazelock_p1_thread = f_thread_cleanup(l_gazelock_p1_thread, nil);
		player_control_unlock_gaze(player1());
		b_return = true;
	end
	if player_valid(player2()) and (s_player < 0 or s_player == 2) then
		l_gazelock_p2_thread = f_thread_cleanup(l_gazelock_p2_thread, nil);
		player_control_unlock_gaze(player2());
		b_return = true;
	end
	if player_valid(player3()) and (s_player < 0 or s_player == 3) then
		l_gazelock_p3_thread = f_thread_cleanup(l_gazelock_p3_thread, nil);
		player_control_unlock_gaze(player3());
		b_return = true;
	end
	return b_return;
end



--------------------------------------
------ GLOBAL TELEPORT FUNCTIONS ------
--------------------------------------
global b_TeleportFX:boolean = true;
global n_TeleportSleepTimer:number = 0;

-- Gets called from C++ when a player is teleported
--playerUnit is the unit of the player that got teleported.
function OnPlayerTeleported(playerUnit:object)
	print("Player ", playerUnit, "teleported!");
	if b_TeleportFX then
		print ("teleporting with FX");
		RunClientScript("TeleportPlayerEffect", playerUnit);
	end
end

function TeleportNoFX(timer:number)
	print ("SETTING TELEPORT TO NOT PLAY TELEPORT EFFECT FOR 2 SECONDS");
	if b_TeleportFX then
		b_TeleportFX = false;
		CreateThread (TeleportTimeOut, timer);
	else
		n_TeleportSleepTimer = timer or 2;
	end
end

function TeleportTimeOut(timer:number)
	n_TeleportSleepTimer = timer or 2;
	repeat
		sleep_s (1);
		n_TeleportSleepTimer = n_TeleportSleepTimer - 1;
	until n_TeleportSleepTimer <= 0
	
	b_TeleportFX = true;
end


--## CLIENT
-- FOV changes and camera shakes are for clients only

-- -------------------------------------------------------------------------------------------------
-- FOV
-- -------------------------------------------------------------------------------------------------
-- variables
global l_sys_transition_fov_thread:thread=nil;
global l_time_start_number:number=0;
global l_time_end_number:number=0;
global r_fov_range_number:number=0.0;
global r_fov_delta_number:number=0.0;
global r_time_range_number:number=0.0;

-- functions
-- === transition_fov: Tranisitions FOV over time
--			r_fov_start = starting FOV value
--				[r_fov_start < 0] = camera_fov; current camera FOV
--			r_fov_end = final FOV value
--				[r_fov_end < 0] = R_FOV_default; Default camera FOV value
--			r_seconds = number of seconds the gravity transition should take place
--
--			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
--	RETURNS:  void
function transition_fov( r_fov_start:number, r_fov_end:number, r_seconds:number, s_refresh:number ):void
	local l_local_thread:thread=nil;
	if l_sys_transition_fov_thread~=nil then
		KillThread(l_sys_transition_fov_thread);
	end
	l_sys_transition_fov_thread = CreateThread(sys_transition_fov, r_fov_start, r_fov_end, r_seconds, s_refresh);
	l_local_thread = l_sys_transition_fov_thread;
	SleepUntil([|  not IsThreadValid(l_local_thread) ], 1);
end

-- === sys_transition_fov: System function for transition_FOV
--		NOTE: DO NOT USE THIS FUNCTION
function sys_transition_fov( r_fov_start:number, r_fov_end:number, r_seconds:number, s_refresh:number ):void
	-- set defaults
	if r_fov_start < 0 then
		r_fov_start = camera_fov;
	end
	if r_fov_end < 0 then
		r_fov_end = r_fov_default;
	end
	if s_refresh < 0 then
		s_refresh = 1;
	end
	-- get start time	
	l_time_start_number = game_tick_get();
	-- get end time	
	l_time_end_number = l_time_start_number + seconds_to_frames(r_seconds);
	-- setup variables
	r_fov_range_number = r_fov_end - r_fov_start;
	r_time_range_number = l_time_end_number - l_time_start_number;
	if r_time_range_number > 0.001 then
		repeat
			Sleep(s_refresh);
			r_fov_delta_number = (game_tick_get() - l_time_start_number) / r_time_range_number;
			-- set fov to the current % of time progress
			camera_fov = r_fov_start + r_fov_range_number * r_fov_delta_number;
		until game_tick_get() >= l_time_end_number;
	end
	camera_fov = r_fov_end;
end

-- -------------------------------------------------------------------------------------------------
-- CAMERA SHAKE
-- -------------------------------------------------------------------------------------------------
-- use example: cam_shake_player( player0, 1, 1, 1, 7);

--function camera_shake_player5( actor:player, attack:number, intensity:number, duration:number, decay:number ):void
--	camera_shake_player(actor, attack, intensity, duration, decay, nil);
--end

-- === f_screenshake_event: Screenshake for a fixed time
--		simple screenshake function
--			actor = the player you want to shake
--			intensity = Intensity of the screenshake
--			attack = Duration in seconds to scale to intensity
--			duration = Durration of the screenshake (not including attack & decay)
--			decay = Duration in seconds to scale from intensity
--			snd_sound = sound tag to play
--	RETURNS:  void; when the screenshake is complete

function camera_shake_player( actor:player, attack:number, intensity:number, duration:number, decay:number, shake_sound:tag ):void
		-- play the sound
	if shake_sound~=nil then
		sound_impulse_start(shake_sound, nil, 1);
	end
	
	attack = attack or 0.5;

	intensity = intensity or  0.75;

	duration = duration or 0.75;

	decay = decay or 0.75;
	
	player_effect_set_max_rotation_for_player(actor, intensity * 3, intensity * 3, intensity * 3);
	player_effect_set_max_rumble_for_player(actor, 1, 1);
	player_effect_start_for_player(actor, intensity, attack);

	
	if duration >= 0 then
		Sleep(duration * n_fps());
	end
	if decay >= 0 then
		player_effect_stop_for_player(actor, decay);
	end
	player_effect_set_max_rumble_for_player(actor, 0, 0);
end


-- camera shake for all 4 coop players
-- all parameters are optional, leave blank for default shake
function camera_shake_all_coop_players( attack:number, intensity:number, duration:number, decay:number, shake_sound:tag ):void
	-- play the sound
	
	if shake_sound~=nil then
		sound_impulse_start(shake_sound, nil, 1);
	else
		sound_impulse_start(TAG('sound\002_ui\002_ui_hud\002_ui_hud_rumble\002_ui_hud_2d_rumble_short.sound'), nil, 1);
		Sleep(1);
	end
	
	attack = attack or 0.5;

	intensity = intensity or  0.75;

	duration = duration or 0.75;

	decay = decay or 0.75;
	
	for _, val in ipairs(players()) do
		player_effect_set_max_rotation_for_player(val, intensity * 3, intensity * 3, intensity * 3);
		player_effect_set_max_rumble_for_player(val, 1, 1);
		player_effect_start_for_player(val, intensity, attack);
	end
		
	sleep_s(duration);
	
	for _, val in ipairs(players()) do
		player_effect_stop_for_player(val, decay);
		player_effect_set_max_rumble_for_player(val, 0, 0);
	end
	
	
end


--	start_camera_shake_loop (shake_type, shake_frequency):
--				Use:
--					shake_type: 			"weak", "medium" or "heavy" for desired intensity
--					shake_frequency:	"low", "medium" or "long" for desired wait between shakes
-- loops are dangerous because of players being dead and respawning
function start_camera_shake_loop( shake_type:string, shake_frequency:string, shake_sound:tag ):void
	s_camera_shake_loop_on = true;
	print("global: starting camera shake");
	repeat
		Sleep(1);
		if shake_type == "weak" then
			CreateThread(camera_shake_all_coop_players, real_random_range(0.25, 1.5), real_random_range(0.1, 0.23), real_random_range(0.25, 1.5), real_random_range(0.1, 1.0), shake_sound);
			print("low shake!");
		elseif shake_type == "medium" then
			CreateThread(camera_shake_all_coop_players, real_random_range(0.75, 2.25), real_random_range(0.23, 0.36), real_random_range(0.75, 2.25), real_random_range(0.5, 1.5), shake_sound);
			print("medium shake!");
		elseif shake_type == "heavy" then
			CreateThread(camera_shake_all_coop_players, real_random_range(1.25, 3), real_random_range(0.35, 0.7), real_random_range(1.5, 3), real_random_range(1, 2.5), shake_sound);
			print("heavy shake!");
		else
			CreateThread(camera_shake_all_coop_players, real_random_range(0.75, 2.25), real_random_range(0.23, 0.36), real_random_range(0.75, 2.25), real_random_range(0.5, 1.5), shake_sound);
			print("default shake!");
		end
		if shake_frequency == "long" then
			sleep_s(real_random_range(8, 15));
		elseif shake_frequency == "medium" then
			sleep_s(real_random_range(5, 10));
		elseif shake_frequency == "short" then
			sleep_s(real_random_range(2, 6));
		else
			sleep_s(real_random_range(5, 10));
		end
	until s_camera_shake_loop_on == false;
end

function stop_camera_shake_loop():void
	s_camera_shake_loop_on = false;
	print("global: stopping camera shake");
	Sleep(1);
end

--stop rumble -- put in to fix bug 49444 on a global scale
function stop_camera_shake():void
	print("stop camera shake");
	player_effect_stop_for_player(PLAYERS.player0, 0);
	player_effect_set_max_rumble_for_player(PLAYERS.player0, 0, 0);
	if game_coop_player_count() <= 2 then
		player_effect_set_max_rumble_for_player(PLAYERS.player1, 0, 0);
		player_effect_stop_for_player(PLAYERS.player1, 0);
	end
	if game_coop_player_count() <= 3 then
		player_effect_set_max_rumble_for_player(PLAYERS.player2, 0, 0);
		player_effect_stop_for_player(PLAYERS.player2, 0);
	end
	if game_coop_player_count() <= 4 then
		player_effect_set_max_rumble_for_player(PLAYERS.player3, 0, 0);
		player_effect_stop_for_player(PLAYERS.player3, 0);
	end
end

-- === rumble scripts: Screenshake and rumble for a fixed time
--		simple screenshake and rumble function
--			numSeconds = number of seconds to shake
--	RETURNS:  void; when the screenshake is complete
function remoteClient.start_global_rumble_shake_small(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_small.effect'));
end

function remoteClient.start_global_rumble_shake_medium(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium.effect'));
end

function remoteClient.start_global_rumble_shake_large(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_large.effect'));
end

function remoteClient.start_rumble_shake_client(numSeconds:number, rumble_shake:tag)
	start_global_rumble_shake(numSeconds, rumble_shake);
end

-- === rumble scripts: Screenshake and rumble for a fixed time
--		simple screenshake and rumble function
--			numSeconds = number of seconds to shake
--			rumble_shake = the rumble effect tag to play
--	RETURNS:  void; when the screenshake is complete
function start_global_rumble_shake(numSeconds:number, rumble_shake:tag)
	numSeconds = numSeconds or 1.5;
	rumble_shake = rumble_shake or TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium.effect');
	local sleepTime = 0.9;
	repeat
		effect_new(rumble_shake, PLAYERS.local0);
		sleep_s(sleepTime);
		numSeconds = numSeconds - sleepTime;
	until numSeconds <= 0.0
end

--This is called from a server function which is called through code whenever a player is teleported
--if the player is the one that was teleported, play a teleport effect.
function remoteClient.TeleportPlayerEffect(playerUnit:object)
	--print (playerUnit);
	--print (player_get_unit(PLAYERS.local0));
	--OSR-149881 - gmu -- having this only play on the local client no matter what
	if playerUnit == player_get_unit(PLAYERS.local0) then
		print ("playing teleport effect on this client");
		effect_new_on_object_marker(TAG('levels\campaignworld010\w1_evacuation\fx\fx_teleport_scrfx_in_attached.effect'), playerUnit,"head");
	end
end
