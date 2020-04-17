// =================================================================================================
// =================================================================================================
// =================================================================================================
// PLAYER HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

global short player_00 = 0;
global short player_01 = 1;
global short player_02 = 2;
global short player_03 = 3;

// -------------------------------------------------------------------------------------------------
// BASICS
// -------------------------------------------------------------------------------------------------
// === player0: Returns player 0
//	RETURNS:  unit; of Player 0
script static unit player0()
	player_get( player_00 );
end

// === player0: Returns player 1
//	RETURNS:  unit; of Player 1
script static unit player1()
	player_get( player_01 );
end

// === player0: Returns player 2
//	RETURNS:  unit; of Player 2
script static unit player2()
	player_get( player_02 );
end

// === player0: Returns player 3
//	RETURNS:  unit; of Player 3
script static unit player3()
	player_get( player_03 );
end

// -------------------------------------------------------------------------------------------------
// COOP
// -------------------------------------------------------------------------------------------------
 // === player_count: Returns the player count
//	RETURNS:  short; total number of players
script static short player_count()
  list_count( players() );
end

// === coop_players_2: Returns if the player count is at least 2
//	RETURNS:  boolean; TRUE, if player count is at least 2
script static boolean coop_players_2()
	game_coop_player_count() >= 2;
end

// === coop_players_2: Returns if the player count is at least 3
//	RETURNS:  boolean; TRUE, if player count is at least 3
script static boolean coop_players_3()
	game_coop_player_count() >= 3;
end

// === coop_players_2: Returns if the player count is at least 4
//	RETURNS:  boolean; TRUE, if player count is at least 4
script static boolean coop_players_4()
	game_coop_player_count() >= 4;
end

// -------------------------------------------------------------------------------------------------
// LIVING/HEALTH/SHIELD
// -------------------------------------------------------------------------------------------------
// === player_living_count: Get the total count of living players
//	RETURNS:  short; total number of living players
script static short player_living_count()
local short s_cnt = 0;
	
	if ( unit_get_health(player_get(player_00)) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player_get(player_01)) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player_get(player_02)) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player_get(player_03)) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	
	//return
	s_cnt;
end

// === player_living_fraction: Returns the % of living players
//	RETURNS:  real; % of living players
script static real player_living_fraction()
	player_living_count() / player_count();
end

// === player_shield_fraction: Returns the % of players shields
//	RETURNS:  real; % of players shields
script static real player_shield_fraction()
	(
		unit_get_shield( player_get(player_00) ) + 
		unit_get_shield( player_get(player_01) ) + 
		unit_get_shield( player_get(player_02) ) + 
		unit_get_shield( player_get(player_03) ) + 
		(4 - player_count())
	)	
	/player_count();
end

// === replenish_players: Replenish players vitality
//	RETURNS:  void
script static void replenish_players()
	if b_debug_globals then
		print ("replenish player health...");
	end
	
	unit_set_current_vitality( player_get(player_00), 80, 80 );
	unit_set_current_vitality( player_get(player_01), 80, 80 );
	unit_set_current_vitality( player_get(player_02), 80, 80 );
	unit_set_current_vitality( player_get(player_03), 80, 80 );
end

// === players_can_take_damage: Sets if players can take damage
//			s_player = player index to allow taking of damage
//				[s_player < 0] = All players
//			b_take_damage = TRUE; Allows player(s) to take damage, FALSE; Disables player(s) taking damage
//	RETURNS:  void
script static void players_can_take_damage( short s_player, boolean b_take_damage )

	if ( s_player < 0 ) then
	
		if ( b_take_damage ) then
			object_can_take_damage( players() );
		else
			object_cannot_take_damage( players() );
		end
		
	else
	
		if ( (s_player < 0) or (s_player == 0) ) then
			if ( b_take_damage ) then
				object_can_take_damage( player_get(player_00) );
			else
				object_cannot_take_damage( player_get(player_00) );
			end
		end
		if ( (s_player < 0) or (s_player == 1) ) then
			if ( b_take_damage ) then
				object_can_take_damage( player_get(player_01) );
			else
				object_cannot_take_damage( player_get(player_01) );
			end
		end
		if ( (s_player < 0) or (s_player == 2) ) then
			if ( b_take_damage ) then
				object_can_take_damage( player_get(player_02) );
			else
				object_cannot_take_damage( player_get(player_02) );
			end
		end
		if ( (s_player < 0) or (s_player == 3) ) then
			if ( b_take_damage ) then
				object_can_take_damage( player_get(player_03) );
			else
				object_cannot_take_damage( player_get(player_03) );
			end
		end
		
	end

end

// -------------------------------------------------------------------------------------------------
// PLAYER VEHICLES
// -------------------------------------------------------------------------------------------------
// === any_players_in_vehicle: returns TRUE if any player is in a vehicle
//	RETURNS:  boolean; TRUE, if any player is in a vehicle
script static boolean any_players_in_vehicle()
	unit_in_vehicle( player_get(player_00) ) or 
	unit_in_vehicle( player_get(player_01) ) or 
	unit_in_vehicle( player_get(player_02) ) or 
	unit_in_vehicle( player_get(player_03) );
end

// === players_in_vehicle_cnt: Returns the total # of players in vehicles
//	RETURNS:  short; Number of players in vehicles
script static short players_in_vehicle_cnt()
local short s_cnt = 0;
	
	if ( unit_in_vehicle(player_get(player_00)) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player_get(player_01)) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player_get(player_02)) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player_get(player_03)) ) then
		s_cnt = s_cnt + 1;
	end
	
	//return
	s_cnt;
end

// === players_in_vehicle_fraction: Returns the % of players in vehicles
//	RETURNS:  real; % of players in vehicles
script static real players_in_vehicle_fraction()
	players_in_vehicle_cnt() / player_count();
end

	// === players_hide: Hides/unhides players
//			s_player = player index to apply hide on
//				[s_player < 0] = apply to all players
//			b_hide = TRUE; hides the player(s), FALSE; unhides the player(s)
//	RETURNS:  void
script static void players_hide( short s_player, boolean b_hide )

	if ( (s_player < 0) or (s_player == 0) ) then
		object_hide( player_get(player_00), b_hide );
	end
	if ( (s_player < 0) or (s_player == 1) ) then
		object_hide( player_get(player_01), b_hide );
	end
	if ( (s_player < 0) or (s_player == 2) ) then
		object_hide( player_get(player_02), b_hide );
	end
	if ( (s_player < 0) or (s_player == 3) ) then
		object_hide( player_get(player_03), b_hide );
	end

end



// -------------------------------------------------------------------------------------------------
// WEAPONS
// -------------------------------------------------------------------------------------------------
// === players_weapon_down: Makes players raise/lower their weapon
//			s_player = Player(s) to lower/raise weapon
//				[s_player < 0] = All players
//			r_time = Time (in seconds) to raise/lower their weapon
//			b_weapon_down = TRUE; Puts weapon down, FALSE; Puts weapon up
//	RETURNS:  void
script static void players_weapon_down( short s_player, real r_time, boolean b_weapon_down )
static long l_player00_thread = 0;
static long l_player01_thread = 0;
static long l_player02_thread = 0;
static long l_player03_thread = 0;

	if ( (s_player < 0) or (s_player == 0) ) then
		if ( IsThreadValid(l_player00_thread) ) then
			kill_thread( l_player00_thread );
		end
		l_player00_thread = thread( sys_players_weapon_down(player_get(player_00), r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 1) ) then
		if ( IsThreadValid(l_player01_thread) ) then
			kill_thread( l_player01_thread );
		end
		l_player01_thread = thread( sys_players_weapon_down(player_get(player_01), r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 2) ) then
		if ( IsThreadValid(l_player02_thread) ) then
			kill_thread( l_player02_thread );
		end
		l_player02_thread = thread( sys_players_weapon_down(player_get(player_02), r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 3) ) then
		if ( IsThreadValid(l_player03_thread) ) then
			kill_thread( l_player03_thread );
		end
		l_player03_thread = thread( sys_players_weapon_down(player_get(player_03), r_time, b_weapon_down) );
	end

end
script static void sys_players_weapon_down( unit u_player, real r_time, boolean b_weapon_down )

	if ( b_weapon_down ) then
		chud_show_crosshair( FALSE );
		hud_show_crosshair( FALSE );
		unit_lower_weapon( u_player, seconds_to_frames(r_time) );
	else
		unit_raise_weapon( u_player, seconds_to_frames(r_time) );
		sleep_s( r_time );
		chud_show_crosshair( TRUE );
		hud_show_crosshair( TRUE );
	end
end


// -------------------------------------------------------------------------------------------------
// CAN SEE
// -------------------------------------------------------------------------------------------------
// === players_can_see_object_cnt: Returns the number of players that can see an object
//			obj_target = Target object to look for
//			r_degrees = Degrees angle from player to look
//				[r_degrees < 0] = R_FOV_default; Default game FOV
//	RETURNS:  short; Number of players that can see the object
script static short players_can_see_object_cnt( object obj_target, real r_degrees )
local short s_cnt = 0;

	if ( r_degrees < 0 ) then
		r_degrees = R_FOV_default;
	end

	if ( objects_can_see_object(player_get(player_00), obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player_get(player_01), obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player_get(player_02), obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player_get(player_03), obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	
	// return
	s_cnt;
	
end

// === players_can_see_object_fraction: % of players that can see an object
//			obj_target = Target object to look for
//			r_degrees = Degrees angle from player to look
//				[r_degrees < 0] = R_FOV_default; Default game FOV
//	RETURNS:  real; % of players that can see the object
script static real players_can_see_object_fraction( object obj_target, real r_degrees )
	real( players_can_see_object_cnt(obj_target,r_degrees) ) / real( player_count() );
end
			