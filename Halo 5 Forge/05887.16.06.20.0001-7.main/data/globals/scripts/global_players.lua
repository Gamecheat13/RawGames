--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- PLAYER HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
global player_00:number=0;
global player_01:number=1;
global player_02:number=2;
global player_03:number=3;

-- -------------------------------------------------------------------------------------------------
-- BASICS
-- -------------------------------------------------------------------------------------------------
-- === player0: Returns player 0
--	RETURNS:  unit; of Player 0
function player0():object
	return player_get(player_00);
end

-- === player0: Returns player 1
--	RETURNS:  unit; of Player 1
function player1():object
	return player_get(player_01);
end

-- === player0: Returns player 2
--	RETURNS:  unit; of Player 2
function player2():object
	return player_get(player_02);
end

-- === player0: Returns player 3
--	RETURNS:  unit; of Player 3
function player3():object
	return player_get(player_03);
end

-- RETURNS: boolean; if the player index != NONE (-1)
-- easy to understand function name
function player_valid( player_index:player ):boolean
	return object_index_valid(player_index);
end

-- -------------------------------------------------------------------------------------------------
-- COOP
-- -------------------------------------------------------------------------------------------------
-- === player_count: Returns the player count
--	RETURNS:  short; total number of players
function player_count():number
	--list_count( players() );
	return game_coop_player_count();
end

-- === coop_players_2: Returns if the player count is at least 2
--	RETURNS:  boolean; TRUE, if player count is at least 2
function coop_players_2():boolean
	return game_coop_player_count() >= 2;
end

-- === coop_players_3: Returns if the player count is at least 3
--	RETURNS:  boolean; TRUE, if player count is at least 3
function coop_players_3():boolean
	return game_coop_player_count() >= 3;
end

-- === coop_players_4: Returns if the player count is at least 4
--	RETURNS:  boolean; TRUE, if player count is at least 4
function coop_players_4():boolean
	return game_coop_player_count() >= 4;
end

function musketeers()
	return ai_actors(GetMusketeerSquad());
end

function spartans()
	local t_spartans = players();
	for _, obj in ipairs (musketeers()) do
		t_spartans[#t_spartans + 1] = obj;
	end
	--table.dprint (t_spartans);
	return t_spartans
end

-- === VolumeReturnSpartans: Get the total count of Spartan units in a trigger volume
--	RETURNS:  table (can be used as an object_list too); table of Spartans in a volume
function VolumeReturnSpartans(vol:volume)
	local obj_tab = volume_return_objects(vol); -- doesn't work with sector volumes
	local spa_tab = {};
	for _,obj in ipairs(obj_tab) do
 	--print (obj);
	 	for _,spartan in ipairs (spartans()) do
	 		if obj == spartan then
	 			spa_tab[#spa_tab + 1] = obj;
	 		--	print (obj);
	 		end
	 	end
	end
	return spa_tab;
end

-- === f_volume_teleport_all_not_inside: Teleports players and musketeers not inside of the volume to a flag
--				[trigger_volume] tv - Teleport volume
--				[location] loc - location to teleport to
function f_volume_teleport_all_not_inside(tv:volume, loc:location)
--	local sp = VolumeReturnSpartans (tv);
--	for _,spartan in ipairs(spartans()) do
--		if not table.contains (sp, spartan) then
--			object_teleport( spartan , loc);
--	--	end
--	end

	for _,spartan in ipairs( spartans() ) do
		if not volume_test_object (tv, spartan) then
			object_teleport( spartan , loc);
		end
	end
end
	

-- === f_volume_teleport_all_inside: Teleports players and musketeers inside of the volume to a flag
--				[trigger_volume] tv - Teleport volume
--				[location] loc - location to teleport to
function f_volume_teleport_all_inside(tv:volume, loc:location)
--	local sp = VolumeReturnSpartans (tv);
	--for _,spartan in ipairs( sp ) do
	--	object_teleport( spartan , loc);
	--end
	
	for _,spartan in ipairs( spartans() ) do
		if volume_test_object (tv, spartan) then
			object_teleport( spartan , loc);
		end
	end	
end

-- for advanced teleporting, an objects position and facing can be used
-- for example, this will teleport the spartans 2 units ahead of where the warthog is facing
--	local m:matrix = GetObjectTransform(OBJECTS.warthog);
--	m.pos = m:transform(vector (2,0,0));
--	f_volume_teleport_all_inside (VOLUMES.tv_volume, m);

-- === player_valid_count: Get the total count of valid players
--	RETURNS:  short; total number of valid players
function player_valid_count():number
	local s_cnt:number=0;
	if player_valid(PLAYERS.player0) then
		s_cnt = s_cnt + 1;
	end
	if player_valid(PLAYERS.player1) then
		s_cnt = s_cnt + 1;
	end
	if player_valid(PLAYERS.player2) then
		s_cnt = s_cnt + 1;
	end
	if player_valid(PLAYERS.player3) then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end

-- === PlayersAreAlive: returns true if any players are alive
--	RETURNS:  boolean; any player is alive
function PlayersAreAlive():boolean
	-- returns true if any players are alive.
	-- used to determine when to start missions, vignettes, etc
	return
	object_get_health (PLAYERS.player0) > 0 or
	object_get_health (PLAYERS.player1) > 0 or
	object_get_health (PLAYERS.player2) > 0 or
	object_get_health (PLAYERS.player3) > 0;
	
end

-- === player_living_fraction: Returns the % of living players
--	RETURNS:  real; % of living players
function player_living_fraction():number
	return player_living_count() / player_count();
end

-- === player_shield_fraction: Returns the % of players shields
--	RETURNS:  real; % of players shields
function player_shield_fraction():number
	return (unit_get_shield(PLAYERS.player0) + unit_get_shield(PLAYERS.player1) + unit_get_shield(PLAYERS.player2) + unit_get_shield(PLAYERS.player3) + (4 - player_count())) / player_count();
end

-- === players_can_take_damage: Sets if players can take damage
--			s_player = player index to allow taking of damage
--				[s_player < 0] = All players
--			b_take_damage = TRUE; Allows player(s) to take damage, FALSE; Disables player(s) taking damage
--	RETURNS:  void
function players_can_take_damage( s_player:number, b_take_damage:boolean ):void
	if s_player < 0 then
		if b_take_damage then
			object_can_take_damage(players());
		else
			object_cannot_take_damage(players());
		end
	elseif s_player >= 0 and s_player <= 3 then
		if b_take_damage then
			object_can_take_damage(player_get(s_player));
		else
			object_cannot_take_damage(player_get(s_player));
		end
	end
end

-- -------------------------------------------------------------------------------------------------
-- PLAYER TELEPORT
-- -------------------------------------------------------------------------------------------------
-- === volume_teleport_players: Teleports players inside or outside of the volume to a flag
--				[trigger_volume] tv_teleport - Teleport volume
--				[cutscene_flag] flg_teleport - Flag to teleport to
--				[boolean] b_teleport_inside - TRUE; teleports players inside the volume, FALSE; teleports players outside the volume
--	RETURNS:  VOID
function volume_teleport_players( tv_teleport:volume, flg_teleport:flag, b_teleport_inside:boolean ):void
	if  not b_teleport_inside then
		volume_teleport_players_not_inside(tv_teleport, flg_teleport);
	else
		volume_teleport_players_inside(tv_teleport, flg_teleport);
	end
end

-- === volume_teleport_players_zone_set_sequence: Like volume_teleport_players_zone_set but is indended if you have an ordered sequence of zone sets (IE, it's always incrementing up).  Makes it easy to have all your co-op teleports all setup in one function.
--	RETURNS:  TRUE; Triggered teleport, FALSE; Did not trigger teleport
function volume_teleport_players_zone_set_sequence( tv_teleport:volume, flg_teleport:flag, b_teleport_inside:boolean, s_zone_set_index:zone_set ):boolean
	SleepUntil([| current_zone_set() >= s_zone_set_index or zoneset_preparing() >= s_zone_set_index or zoneset_loading() >= s_zone_set_index ], 1);
	if current_zone_set() == s_zone_set_index or zoneset_preparing() == s_zone_set_index or zoneset_loading() == s_zone_set_index then
		volume_teleport_players(tv_teleport, flg_teleport, b_teleport_inside);
		-- extra safety to make sure all players make it
		if current_zone_set()~=s_zone_set_index then
			SleepUntil([| current_zone_set() == s_zone_set_index ], 1);
			volume_teleport_players(tv_teleport, flg_teleport, b_teleport_inside);
		end
		return true;
	else
		return false;
	end
end

-- -------------------------------------------------------------------------------------------------
-- PLAYER VEHICLES
-- -------------------------------------------------------------------------------------------------
-- === any_players_in_vehicle: returns TRUE if any player is in a vehicle
--	RETURNS:  boolean; TRUE, if any player is in a vehicle
function any_players_in_vehicle():boolean
	return unit_in_vehicle(PLAYERS.player0) or unit_in_vehicle(PLAYERS.player1) or unit_in_vehicle(PLAYERS.player2) or unit_in_vehicle(PLAYERS.player3);
end

-- === players_in_vehicle_cnt: Returns the total # of players in vehicles
--	RETURNS:  short; Number of players in vehicles
function players_in_vehicle_cnt():number
	local s_cnt:number=0;
	if unit_in_vehicle(PLAYERS.player0) then
		s_cnt = s_cnt + 1;
	end
	if unit_in_vehicle(PLAYERS.player1) then
		s_cnt = s_cnt + 1;
	end
	if unit_in_vehicle(PLAYERS.player2) then
		s_cnt = s_cnt + 1;
	end
	if unit_in_vehicle(PLAYERS.player3) then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end

-- === players_in_vehicle_fraction: Returns the % of players in vehicles
--	RETURNS:  real; % of players in vehicles
function players_in_vehicle_fraction():number
	return players_in_vehicle_cnt() / player_count();
end

-- === players_hide: Hides/unhides players
--			s_player = player index to apply hide on
--				[s_player < 0] = apply to all players
--			b_hide = TRUE; hides the player(s), FALSE; unhides the player(s)
--	RETURNS:  void
function players_hide( s_player:number, b_hide:boolean ):void
	for k, player in ipairs (spartans()) do
		if s_player < k - 1 or s_player == k - 1 then
			--print ("hide spartan", k - 1 );
			object_hide(player, b_hide);
		end
	end
end

-- -------------------------------------------------------------------------------------------------
-- WEAPONS
-- -------------------------------------------------------------------------------------------------
-- === players_weapon_down: Makes players raise/lower their weapon
--			s_player = Player(s) to lower/raise weapon
--				[s_player < 0] = All players
--			r_time = Time (in seconds) to raise/lower their weapon
--			b_weapon_down = TRUE; Puts weapon down, FALSE; Puts weapon up
--	RETURNS:  void
function players_weapon_down( s_player:number, r_time:number, b_weapon_down:boolean ):void
	for k, player in ipairs (players()) do
		if s_player <= k - 1 then
			--print ("weapons down for player", k - 1 );
			CreateThread(sys_players_weapon_down, player, r_time, b_weapon_down);
		end
	end
end
global l_player00_thread_number:thread=nil;
global l_player01_thread_number:thread=nil;
global l_player02_thread_number:thread=nil;
global l_player03_thread_number:thread=nil;

function sys_players_weapon_down( u_player:object, r_time:number, b_weapon_down:boolean ):void
	if b_weapon_down then
		chud_show_crosshair(false);
		hud_show_crosshair(false);
		unit_lower_weapon(u_player, seconds_to_frames(r_time));
	else
		unit_raise_weapon(u_player, seconds_to_frames(r_time));
		sleep_s(r_time);
		chud_show_crosshair(true);
		hud_show_crosshair(true);
	end
end

function f_player_has_weapon( od_weapon:tag ):boolean
	return unit_has_weapon(PLAYERS.player0, od_weapon) or unit_has_weapon(PLAYERS.player1, od_weapon) or unit_has_weapon(PLAYERS.player2, od_weapon) or unit_has_weapon(PLAYERS.player3, od_weapon);
end

function f_player_has_weapon_readied( od_weapon:tag ):boolean
	return unit_has_weapon_readied(PLAYERS.player0, od_weapon) or unit_has_weapon_readied(PLAYERS.player1, od_weapon) or unit_has_weapon_readied(PLAYERS.player2, od_weapon) or unit_has_weapon_readied(PLAYERS.player3, od_weapon);
end

-- -------------------------------------------------------------------------------------------------
-- CAN SEE
-- -------------------------------------------------------------------------------------------------
-- === players_can_see_object_cnt: Returns the number of players that can see an object
--			obj_target = Target object to look for
--			r_degrees = Degrees angle from player to look
--				[r_degrees < 0] = R_FOV_default; Default game FOV
--	RETURNS:  short; Number of players that can see the object
function players_can_see_object_cnt( obj_target:object, r_degrees:number ):number
	local s_cnt:number=0;
	if r_degrees < 0 then
		r_degrees = r_fov_default;
	end
	if objects_can_see_object(PLAYERS.player0, obj_target, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(PLAYERS.player1, obj_target, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(PLAYERS.player2, obj_target, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(PLAYERS.player3, obj_target, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end


-- === players_can_see_object_fraction: % of players that can see an object
--			obj_target = Target object to look for
--			r_degrees = Degrees angle from player to look
--				[r_degrees < 0] = R_FOV_default; Default game FOV
--	RETURNS:  real; % of players that can see the object
function players_can_see_object_fraction( obj_target:object, r_degrees:number ):number
	return (players_can_see_object_cnt(obj_target, r_degrees)) / (player_count());
end

-- === objects_can_see_player: Checks if an object can see a player
--			obj_list = List of objects to see if they can see the player
--			r_degrees = Degrees angle from player to look
--				[r_degrees < 0] = R_FOV_default; Default game FOV
--	RETURNS:  TRUE; If any one of the objects can see the player
function objects_can_see_player( obj_list:object_list, r_degrees:number ):boolean
	return objects_can_see_object(obj_list, PLAYERS.player0, r_degrees) or objects_can_see_object(obj_list, PLAYERS.player1, r_degrees) or objects_can_see_object(obj_list, PLAYERS.player2, r_degrees) or objects_can_see_object(obj_list, PLAYERS.player3, r_degrees);
end

-- === objects_can_see_player_cnt: Checks if an object can see a player
--			obj_list = List of objects to see if they can see the player
--			r_degrees = Degrees angle from player to look
--				[r_degrees < 0] = R_FOV_default; Default game FOV
--	RETURNS:  TRUE; If any one of the objects can see the player
function objects_can_see_player_cnt( obj_list:object_list, r_degrees:number ):number
	local s_cnt:number=0;
	if objects_can_see_object(obj_list, PLAYERS.player0, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(obj_list, PLAYERS.player1, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(obj_list, PLAYERS.player2, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	if objects_can_see_object(obj_list, PLAYERS.player3, r_degrees) then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end

--## COMMON

-- -------------------------------------------------------------------------------------------------
-- LIVING/HEALTH/SHIELD
-- -------------------------------------------------------------------------------------------------
-- === player_living_count: Get the total count of living players
--	RETURNS:  short; total number of living players
function player_living_count():number
	local s_cnt:number=0;
	if unit_get_health(PLAYERS.player0) > 0 then
		s_cnt = s_cnt + 1;
	end
	if unit_get_health(PLAYERS.player1) > 0 then
		s_cnt = s_cnt + 1;
	end
	if unit_get_health(PLAYERS.player2) > 0 then
		s_cnt = s_cnt + 1;
	end
	if unit_get_health(PLAYERS.player3) > 0 then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end

--## SERVER

-- -------------------------------------------------------------------------------------------------
-- INPUT
-- -------------------------------------------------------------------------------------------------

-- Scales the input for all players to strength over seconds. After timeoutSeconds the input will be
-- reset back to full (defaults to 5 seconds).
function PlayersScaleAllInput(strength:number, seconds:number, timeoutSeconds:number)
	if timeoutSeconds == nil then
		timeoutSeconds = 5;
	end

	RunClientScript("PlayersScaleAllInputClient", strength, seconds, timeoutSeconds);
end

--## CLIENT

global th_restoreInputThread:thread = nil;

function RestoreInputScale(timeoutSeconds:number)
	sleep_s(timeoutSeconds);
	player_control_scale_all_input(1, 1);
	th_restoreInputThread = nil;
end


function remoteClient.PlayersScaleAllInputClient(strength:number, seconds:number, timeoutSeconds:number)
	-- Scale the player's inputs.
	player_control_scale_all_input(strength, seconds);

	-- If there is an old thread to restore the input, kill it immediately.
	if (th_restoreInputThread ~= nil) then
		KillThread(th_restoreInputThread);
		th_restoreInputThread = nil;
	end

	-- If we are changing the player's input to something other than full, 
	-- create a thread to restore it at some point.
	if (strength ~= 1) then
		th_restoreInputThread = CreateThread(RestoreInputScale, timeoutSeconds);
	end
end
