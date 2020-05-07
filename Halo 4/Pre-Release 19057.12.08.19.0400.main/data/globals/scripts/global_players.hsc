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

// RETURNS: boolean; if the player index != NONE (-1)
// easy to understand function name
script static boolean player_valid( unit player_unit_index )
   player_unit_index != NONE;
end

// RETURNS: boolean; if the unit index != NONE (-1)
script static boolean unit_index_valid( unit unit_index )
   unit_index != NONE;
end

// -------------------------------------------------------------------------------------------------
// COOP
// -------------------------------------------------------------------------------------------------
 // === player_count: Returns the player count
//	RETURNS:  short; total number of players
script static short player_count()
  //list_count( players() );
	game_coop_player_count();
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
	
	if ( unit_get_health(player0) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player1) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player2) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_get_health(player3) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	
	//return
	s_cnt;
end

// === player_valid_count: Get the total count of valid players
//	RETURNS:  short; total number of valid players
script static short player_valid_count()
local short s_cnt = 0;
	
	if ( player_valid(player0) ) then
		s_cnt = s_cnt + 1;
	end
	if ( player_valid(player1) ) then
		s_cnt = s_cnt + 1;
	end
	if ( player_valid(player2) ) then
		s_cnt = s_cnt + 1;
	end
	if ( player_valid(player3) ) then
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
		unit_get_shield( player0 ) + 
		unit_get_shield( player1 ) + 
		unit_get_shield( player2 ) + 
		unit_get_shield( player3 ) + 
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
	
	unit_set_current_vitality( player0, 80, 80 );
	unit_set_current_vitality( player1, 80, 80 );
	unit_set_current_vitality( player2, 80, 80 );
	unit_set_current_vitality( player3, 80, 80 );
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
		
	elseif ( (s_player >= 0) and (s_player <= 3) ) then

		if ( b_take_damage ) then
			object_can_take_damage( player_get(s_player) );
		else
			object_cannot_take_damage( player_get(s_player) );
		end
		
	end

end

// -------------------------------------------------------------------------------------------------
// PLAYER TELEPORT
// -------------------------------------------------------------------------------------------------
// === volume_teleport_players: Teleports players inside or outside of the volume to a flag
//				[trigger_volume] tv_teleport - Teleport volume
//				[cutscene_flag] flg_teleport - Flag to teleport to
//				[boolean] b_teleport_inside - TRUE; teleports players inside the volume, FALSE; teleports players outside the volume
//	RETURNS:  VOID
script static void volume_teleport_players( trigger_volume tv_teleport, cutscene_flag flg_teleport, boolean b_teleport_inside )
	if ( not b_teleport_inside ) then
		volume_teleport_players_not_inside( tv_teleport, flg_teleport );
	else
		volume_teleport_players_inside( tv_teleport, flg_teleport );
	end
end

// === volume_teleport_players_zone_set: Teleports players inside or outside of a volume to a flag when a zone set change happens
//				[trigger_volume] tv_teleport - Teleport volume
//				[cutscene_flag] flg_teleport - Flag to teleport to
//				[boolean] b_teleport_inside - TRUE; teleports players inside the volume, FALSE; teleports players outside the volume
//				[short] s_zone_set_index - Zone set index to initiate teleport
//				[boolean] b_zone_set_active - TRUE; Teleport if the zone set index matches the current, FALSE; teleport if it does not match the current
//	RETURNS:  VOID
script static void volume_teleport_players_zone_set( trigger_volume tv_teleport, cutscene_flag flg_teleport, boolean b_teleport_inside, short s_zone_set_index, boolean b_zone_set_active )
	sleep_until( (current_zone_set() == s_zone_set_index) == b_zone_set_active, 1 );
	volume_teleport_players( tv_teleport, flg_teleport, b_teleport_inside );
end

// === volume_teleport_players_zone_set_sequence: Like volume_teleport_players_zone_set but is indended if you have an ordered sequence of zone sets (IE, it's always incrementing up).  Makes it easy to have all your co-op teleports all setup in one function.
//	RETURNS:  TRUE; Triggered teleport, FALSE; Did not trigger teleport
script static boolean volume_teleport_players_zone_set_sequence( trigger_volume tv_teleport, cutscene_flag flg_teleport, boolean b_teleport_inside, short s_zone_set_index )
	sleep_until( current_zone_set() >= s_zone_set_index, 1 );
	if ( current_zone_set() == s_zone_set_index ) then
		volume_teleport_players( tv_teleport, flg_teleport, b_teleport_inside );
		TRUE;
	else
		FALSE;
	end
end
		
// -------------------------------------------------------------------------------------------------
// PLAYER VEHICLES
// -------------------------------------------------------------------------------------------------
// === any_players_in_vehicle: returns TRUE if any player is in a vehicle
//	RETURNS:  boolean; TRUE, if any player is in a vehicle
script static boolean any_players_in_vehicle()
	unit_in_vehicle( player0 ) or 
	unit_in_vehicle( player1 ) or 
	unit_in_vehicle( player2 ) or 
	unit_in_vehicle( player3 );
end

// === players_in_vehicle_cnt: Returns the total # of players in vehicles
//	RETURNS:  short; Number of players in vehicles
script static short players_in_vehicle_cnt()
local short s_cnt = 0;
	
	if ( unit_in_vehicle(player0) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player1) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player2) ) then
		s_cnt = s_cnt + 1;
	end
	if ( unit_in_vehicle(player3) ) then
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
		object_hide( player0, b_hide );
	end
	if ( (s_player < 0) or (s_player == 1) ) then
		object_hide( player1, b_hide );
	end
	if ( (s_player < 0) or (s_player == 2) ) then
		object_hide( player2, b_hide );
	end
	if ( (s_player < 0) or (s_player == 3) ) then
		object_hide( player3, b_hide );
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
		l_player00_thread = thread( sys_players_weapon_down(player0, r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 1) ) then
		if ( IsThreadValid(l_player01_thread) ) then
			kill_thread( l_player01_thread );
		end
		l_player01_thread = thread( sys_players_weapon_down(player1, r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 2) ) then
		if ( IsThreadValid(l_player02_thread) ) then
			kill_thread( l_player02_thread );
		end
		l_player02_thread = thread( sys_players_weapon_down(player2, r_time, b_weapon_down) );
	end

	if ( (s_player < 0) or (s_player == 3) ) then
		if ( IsThreadValid(l_player03_thread) ) then
			kill_thread( l_player03_thread );
		end
		l_player03_thread = thread( sys_players_weapon_down(player3, r_time, b_weapon_down) );
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

script static boolean f_player_has_weapon( object_definition od_weapon )
	unit_has_weapon( player0, od_weapon ) or
	unit_has_weapon( player1, od_weapon ) or
	unit_has_weapon( player2, od_weapon ) or
	unit_has_weapon( player3, od_weapon );
end
script static boolean f_player_has_weapon_readied( object_definition od_weapon )
	unit_has_weapon_readied( player0, od_weapon ) or
	unit_has_weapon_readied( player1, od_weapon ) or
	unit_has_weapon_readied( player2, od_weapon ) or
	unit_has_weapon_readied( player3, od_weapon );
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

	if ( objects_can_see_object(player0, obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player1, obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player2, obj_target, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(player3, obj_target, r_degrees) ) then
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

// === objects_can_see_player: Checks if an object can see a player
//			obj_list = List of objects to see if they can see the player
//			r_degrees = Degrees angle from player to look
//				[r_degrees < 0] = R_FOV_default; Default game FOV
//	RETURNS:  TRUE; If any one of the objects can see the player
script static boolean objects_can_see_player( object_list obj_list, real r_degrees )
	objects_can_see_object( obj_list, player0, r_degrees )
	or
	objects_can_see_object( obj_list, player1, r_degrees )
	or
	objects_can_see_object( obj_list, player2, r_degrees )
	or
	objects_can_see_object( obj_list, player3, r_degrees );
end

// === objects_can_see_player_cnt: Checks if an object can see a player
//			obj_list = List of objects to see if they can see the player
//			r_degrees = Degrees angle from player to look
//				[r_degrees < 0] = R_FOV_default; Default game FOV
//	RETURNS:  TRUE; If any one of the objects can see the player
script static short objects_can_see_player_cnt( object_list obj_list, real r_degrees )
local short s_cnt = 0;

	if ( objects_can_see_object(obj_list, player0, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(obj_list, player1, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(obj_list, player2, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	if ( objects_can_see_object(obj_list, player3, r_degrees) ) then
		s_cnt = s_cnt + 1;
	end
	
	// return
	s_cnt;
end


global short S_damage_type_default = 	0;
global short S_damage_type_fire = 		1;

script static void f_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks_min, short s_ticks_max, short s_type, real r_base_intensity, real r_health_intensity, real r_damage_intensity_mod, real r_shake_mod )
local real r_p0_damage = 0.0;
local real r_p1_damage = 0.0;
local real r_p2_damage = 0.0;
local real r_p3_damage = 0.0;
local long l_timer = 0;
	//dprint( "::: f_damage_volume_players :::" );

	// defaults
	if ( r_damage_initial < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_damage_initial = 0.33;
		else
			r_damage_initial = 1.5;
		end
	end
	if ( r_damage_mod < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_damage_mod = 1.05;
		else
			r_damage_mod = 2.25;
		end
	end
	if ( r_base_intensity < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_base_intensity = 0.4;
		else
			r_base_intensity = 0.5;
		end
	end
	if ( r_health_intensity < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_health_intensity = 0.5;
		else
			r_health_intensity = 0.5;
		end
	end
	if ( r_damage_intensity_mod < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_damage_intensity_mod = 0.0375;
		else
			r_damage_intensity_mod = 0.025;
		end
	end
	if ( r_shake_mod < 0.0 ) then
		if ( s_type == S_damage_type_fire ) then
			r_shake_mod = 0.75;
		else
			r_shake_mod = 1.0;
		end
	end

	repeat
	
		// damage players
		//b_damaging = volume_test_players( tv_damage );
		r_p0_damage = sys_damage_volume_player( tv_damage, Player0, r_damage_initial, r_damage_mod, s_type, r_p0_damage, r_base_intensity, r_health_intensity, r_damage_intensity_mod, r_shake_mod );
		r_p1_damage = sys_damage_volume_player( tv_damage, Player1, r_damage_initial, r_damage_mod, s_type, r_p1_damage, r_base_intensity, r_health_intensity, r_damage_intensity_mod, r_shake_mod );
		r_p2_damage = sys_damage_volume_player( tv_damage, Player2, r_damage_initial, r_damage_mod, s_type, r_p2_damage, r_base_intensity, r_health_intensity, r_damage_intensity_mod, r_shake_mod );
		r_p3_damage = sys_damage_volume_player( tv_damage, Player3, r_damage_initial, r_damage_mod, s_type, r_p3_damage, r_base_intensity, r_health_intensity, r_damage_intensity_mod, r_shake_mod );
		
		if ( not volume_test_players(tv_damage) and (r_p0_damage == 0.0) and (r_p1_damage == 0.0) and (r_p2_damage == 0.0) and (r_p3_damage == 0.0) ) then
			sleep_until( volume_test_players(tv_damage), 1 );
		else
			l_timer = game_tick_get() + random_range( s_ticks_min, s_ticks_max );
			sleep_until( timer_expired(l_timer) or (not volume_test_players(tv_damage)), 1 );
		end

	until( FALSE, 1 );

end
script static void f_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks_min, short s_ticks_max, short s_type )
	f_damage_volume_players( tv_damage, r_damage_initial, r_damage_mod, s_ticks_min, s_ticks_max, s_type, -1.0, -1.0, -1.0, -1.0 );
end
script static void f_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks_min, short s_ticks_max )
	f_damage_volume_players( tv_damage, r_damage_initial, r_damage_mod, s_ticks_min, s_ticks_max, S_damage_type_default, -1.0, -1.0, -1.0, -1.0 );
end
script static void f_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks )
	f_damage_volume_players( tv_damage, r_damage_initial, r_damage_mod, s_ticks, s_ticks, S_damage_type_default, -1.0, -1.0, -1.0, -1.0 );
end

script static real sys_damage_volume_player( trigger_volume tv_damage, player p_player, real r_damage_initial, real r_damage_mod, short s_type, real r_damage_current, real r_base_intensity, real r_health_intensity, real r_damage_intensity_mod, real r_shake_mod )
	//dprint( "::: sys_damage_volume_player :::" );

	if ( unit_get_health(p_player) > 0.0 ) then
		local real r_intensity = 0.0;
		
		// get health
		if ( not volume_test_object(tv_damage, p_player) ) then
			r_damage_current = 0.0;
		elseif ( r_damage_current != 0.0 ) then
			r_damage_current = r_damage_current * r_damage_mod;
		else
			r_damage_current = r_damage_initial;
		end
		
		// apply damage
		if ( r_damage_current != 0.0 ) then
			if ( s_type == S_damage_type_fire ) then
				damage_object_with_fire_from_trigger_volume( p_player, tv_damage, "body", r_damage_current );
			else
				damage_object( p_player, "body", r_damage_current );
			end
		end
		
		// calculate screen intensity
		if ( r_damage_current > 0.0 ) then
			local real r_damage_intensity = ( r_damage_current * r_damage_intensity_mod );
			r_health_intensity = ( r_health_intensity * (1.0 - unit_get_health(p_player)) );
			r_intensity = (r_base_intensity + r_health_intensity + r_damage_intensity) * r_shake_mod;
		end
		
		// shake
		sys_screenshake_player_any_apply( p_player, r_intensity, r_intensity, r_intensity );

		dprint( "sys_damage_volume_player: r_damage_current" );
		inspect( r_damage_current ); 
	else
		r_damage_current = 0.0;
	end
	
	// return
	r_damage_current;
end
