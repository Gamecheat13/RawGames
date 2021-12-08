--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- PLAYER HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================

function ChiefResetArmorLoadout()
	PlayerFrameEraseConfigByName(CONTROLLER.controller1, 'chief_openworld')
end

-- RETURNS: boolean; if the player index != NONE (-1)
-- easy to understand function name
function player_valid( player_index:player ):boolean
	return object_index_valid(player_index);
end

-- Accepts an inputted array of units, and returns a new array of players from those units;
-- optionally can include the players of units that are dead from the inputted list
function GetPlayerArrayFromUnitArray(unitArray:table, includeDeadPlayers:boolean):table
	local playerArray:table = {};

	if (unitArray ~= nil) then
		for _, unit in ipairs(unitArray) do
			local unitPlayer:player = Unit_GetPlayer(unit);
			if (unitPlayer == nil and includeDeadPlayers == true) then
				unitPlayer = Unit_GetLastPlayer(unit);
			end

			if (unitPlayer ~= nil) then
				table.insert(playerArray, unitPlayer);
			end
		end
	end

	return playerArray;
end

-- -------------------------------------------------------------------------------------------------
-- COOP
-- -------------------------------------------------------------------------------------------------
function musketeers()
	return nil;
end

function spartans()
	local t_spartans = players();
	for _, obj in ipairs (musketeers()) do
		t_spartans[#t_spartans + 1] = obj;
	end
	--table.dprint (t_spartans);
	return t_spartans
end

-- === player_count: Returns the player count
--	RETURNS:  short; total number of players
function player_count():number
	--list_count( players() );
	return GetTotalPlayerCount();
end

--GMU - these are only sticking around for backwards compatibility with Arrival, won't need this in the future
-- === VolumeReturnSpartans: Get the total count of Spartan units in a trigger volume
--	RETURNS:  table (can be used as an object_list too); table of Spartans in a volume
function VolumeReturnSpartans(vol:volume)
	local obj_tab = volume_return_objects(vol); -- doesn't work with sector volumes
	local spa_tab = {};
	for _,obj in ipairs(obj_tab) do
 	--print (obj);
	 	for _,spartan in ipairs (players()) do
	 		if obj == spartan then
	 			spa_tab[#spa_tab + 1] = obj;
	 		--	print (obj);
	 		end
	 	end
	end
	return spa_tab;
end

--GMU - these are only sticking around for backwards compatibility with Arrival, won't need this in the future

-- === f_volume_teleport_all_not_inside: Teleports players not inside of the volume to a flag
--				[trigger_volume] tv - Teleport volume
--				[location] loc - location to teleport to
function f_volume_teleport_all_not_inside(tv:volume, loc:location):void
	for _,spartan in ipairs( players() ) do
		if not volume_test_object (tv, spartan) then
			object_teleport( spartan , loc);
		end
	end
end
	
--GMU - these are only sticking around for backwards compatibility with Arrival, won't need this in the future

-- === f_volume_teleport_all_inside: Teleports players inside of the volume to a flag
--				[trigger_volume] tv - Teleport volume
--				[location] loc - location to teleport to
function f_volume_teleport_all_inside(tv:volume, loc:location):void
	for _,spartan in ipairs( players() ) do
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



-- -------------------------------------------------------------------------------------------------
-- PLAYER DAMAGE AND LIFE
-- -------------------------------------------------------------------------------------------------

-- === player_valid_count: Get the total count of valid players
--	RETURNS:  short; total number of valid players
function player_valid_count():number
	
	return #players();
end

-- === PlayersAreAlive: returns true if any players are alive
--	RETURNS:  boolean; any player is alive
function PlayersAreAlive():boolean
	-- returns true if any players are alive.
	-- used to determine when to start missions, vignettes, etc
	for k, player in hpairs (PLAYERS.active) do
		if object_get_health (player) > 0 then
			return true;
		end
	end
	return false;
end

-- === player_living_fraction: Returns the % of living players
--	RETURNS:  real; % of living players
function player_living_fraction():number
	return player_living_count() / player_count();
end


-- === PlayersCanTakeDamage: Sets if players can take damage
--			
--			b_take_damage = TRUE; Allows player(s) to take damage, FALSE; Disables player(s) taking damage
--	RETURNS:  void
function PlayersCanTakeDamage(b_take_damage:boolean):void
	if b_take_damage then
		object_can_take_damage(PLAYERS.active);
	else
		object_cannot_take_damage(PLAYERS.active);
	end
end

-- === PlayerCanTakeDamage: Sets if a player can take damage
--			pl = specific player
--			b_take_damage = TRUE; Allows player(s) to take damage, FALSE; Disables player(s) taking damage
--	RETURNS:  void
function PlayerCanTakeDamage(pl:player, b_take_damage:boolean):void
	if pl ~= nil then
		if b_take_damage then
			object_can_take_damage(pl);
		else
			object_cannot_take_damage(pl);
		end
	end
end

-- === GetPlayerFromObject: Gets a units player or last player if the unit is dead (and used to have a player)
--			unit = a unit to get the player
--			NOTE: this will return nil if the argument is an object and not a unit
--	RETURNS:  player
function GetPlayerFromObject(unit:object):player
	local realUnit:object = Object_TryAndGetUnit(unit);
	return Unit_GetPlayer(realUnit) or Unit_GetLastPlayer(realUnit);
end

-- -------------------------------------------------------------------------------------------------
-- MULTIPLAYER
-- -------------------------------------------------------------------------------------------------

function GetPlayersByTeam(team:mp_team):table
	local teamTable:table = {};
	for _, player in ipairs(PLAYERS.active) do
		if Player_GetMultiplayerTeam(player) == team then
			table.insert(teamTable, player);
		end
	end
	return teamTable;
end

function AddAllPlayersToTeamTable(teamTable:table):table
	teamTable = teamTable or {};
	for _, player in ipairs(PLAYERS.active) do
		AddPlayerToTeamTable(player, teamTable);
	end
	return teamTable;
end

function AddPlayerToTeamTable(player:player, teamTable:table):table
	teamTable = teamTable or {};
	if player ~= nil then
		local mpTeam = Player_GetMultiplayerTeam(player);
		if teamTable[mpTeam] == nil then
			teamTable[mpTeam] = {};
		end
		table.insert(teamTable[mpTeam], player);
	end
	return teamTable;
end

-- -------------------------------------------------------------------------------------------------
-- PLAYER VEHICLES
-- -------------------------------------------------------------------------------------------------
-- === any_players_in_vehicle: returns TRUE if any player is in a vehicle
--	RETURNS:  boolean; TRUE, if any player is in a vehicle
function any_players_in_vehicle():boolean
	for k, player in hpairs (players()) do
		if unit_in_vehicle(player) then
			return true;
		end
	end
	return false;
end

-- === players_in_vehicle_cnt: Returns the total # of players in vehicles
--	RETURNS:  short; Number of players in vehicles
function PlayersInVehicleCount():number
	local s_cnt:number=0;
	for k, player in hpairs (PLAYERS.active) do
		if unit_in_vehicle(player) then
			s_cnt = s_cnt + 1;
		end
	end
	return s_cnt;
end

-- === PlayersInVehicleFraction: Returns the % of players in vehicles
--	RETURNS:  real; % of players in vehicles
function PlayersInVehicleFraction():number
	return PlayersInVehicleCount() / player_count();
end

-- === players_hide: Hides/unhides players
--			s_player = player index to apply hide on
--				[s_player < 0] = apply to all players
--			b_hide = TRUE; hides the player(s), FALSE; unhides the player(s)
--	RETURNS:  void
function PlayersHide(b_hide:boolean ):void
	for k, player in ipairs (PLAYERS.active) do		
		if (Player_GetUnit(player) ~= nil) then
			object_hide(player, b_hide);
		end
	end
end

-- -------------------------------------------------------------------------------------------------
-- WEAPONS
-- -------------------------------------------------------------------------------------------------
-- === PlayersWeaponsDown: Makes players raise/lower their weapon
--			time = Time (in seconds) to raise/lower their weapon
--			b_weapon_down = TRUE; Puts weapon down, FALSE; Puts weapon up
--	RETURNS:  void
function PlayersWeaponsDown( time:number, b_weapon_down:boolean ):void
	for k, player in ipairs (PLAYERS.active) do
		CreateThread(PlayerWeaponDown, player, time, b_weapon_down);
	end
end

-- === PlayerWeaponsDown: Makes a player raise/lower their weapon
--			u_player = player to raise/lower weapon
--			time = Time (in seconds) to raise/lower their weapon
--			b_weapon_down = TRUE; Puts weapon down, FALSE; Puts weapon up
--	RETURNS:  void
function PlayerWeaponDown( u_player, time:number, b_weapon_down:boolean ):void
	if b_weapon_down then
		hud_show_crosshair(false);
		unit_lower_weapon(u_player, seconds_to_frames(time));
	else
		unit_raise_weapon(u_player, seconds_to_frames(time));
		if time > 0 then
			SleepSeconds(time);
		end
		hud_show_crosshair(true);
	end
end


-- === PlayerAnyHasWeaponReadied: returns true if any player has the weapon tag readied
--			od_weapon = tag of weapon to be checked
--	RETURNS:  boolean
function PlayerAnyHasWeaponReadied( od_weapon:tag ):boolean
	for k, player in ipairs (PLAYERS.active) do
		if unit_has_weapon_readied(player, od_weapon) then
			return true;
		end
	end
	return false;
end

-- === PlayerAnyHasWeapon: returns true if any player has the weapon
--			od_weapon = tag of weapon to be checked
--	RETURNS:  boolean
function PlayerAnyHasWeapon( player, od_weapon:tag ):boolean
	for k, player in ipairs (PLAYERS.active) do
		if unit_has_weapon(player, od_weapon) then
			return true;
		end
	end
	return false;
end

-- -------------------------------------------------------------------------------------------------
-- CAN SEE
-- -------------------------------------------------------------------------------------------------
global g_playerCanSeeDegreesDefault = 37.5;
-- === AnyUnitCanSeePlayers: Checks if an object list can see a player
--			obj_list = List of objects to see if they can see the player
--			degrees = Degrees angle from player to look
--	RETURNS:  TRUE; If any one of the objects can see the player
function AnyUnitCanSeePlayers( obj_list:object_list, degrees:number ):boolean
	for _, player in ipairs (PLAYERS.active) do
		if objects_can_see_object(obj_list, player, degrees) then
			return true;
		end
	end
	return false;
end


-- === PlayerCanSeeObject: Checks if a player can see an object
--			player = player to check
--			object = the object to check if the player can see
--			offsets = numbers to offset from the root node of the object (use to try to point to a good spot on the object)
--			note: there is a sleep after each raycast to minimize perf
--	RETURNS:  TRUE; If player can see the biped
function PlayerCanSeeObject(player:player, object:object, locXOffset:number, locYOffset:number, locZOffset:number):boolean
	if object == nil or object_index_valid(object) == false then
		print("PlayerCanSeeObject was passed a nil or invalid object argument");
		return false;
	end
	player = player or PLAYERS.player0;	
	if objects_can_see_object(player, object, g_playerCanSeeDegreesDefault) then
		local rayTable:table = RaycastFromPlayerVisorToDynamicObject(player, object, locXOffset, locYOffset, locZOffset);
		SleepSeconds(0.33);
		if rayTable ~= nil then
			if rayTable.hitObject == object then
				return true;
			end
		end
	end
	return false;
end

-- === AnyPlayerCanSeeObject: Checks if any player can see an object
--			object = the object to check if any player can see
--			offsets = numbers to offset from the root node of the object (use to try to point to a good spot on the object)
--	RETURNS:  TRUE; If any player can see the biped
function AnyPlayerCanSeeObject(object:object, locXOffset:number, locYOffset:number, locZOffset:number):boolean
	if object == nil then
		print("AnyPlayerCanSeeObject was passed a nil object argument");
		return false;
	end

	local players = PLAYERS.active;
	for _, player in ipairs(players) do
		if PlayerCanSeeObject(player, object, locXOffset, locYOffset, locZOffset) then
			return true;
		end
		--add a sleep because casts are expensive
		Sleep(1);
	end
	return false;
end

-- -------------------------------------------------------------------------------------------------
-- LIVING/HEALTH/SHIELD
-- -------------------------------------------------------------------------------------------------
-- === player_living_count: Get the total count of living players
--	RETURNS:  short; total number of living players
function player_living_count():number
	return #players();
end

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
	timeoutSeconds = timeoutSeconds or 3;
	
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

function PlayerIsLocal(pl:player):boolean
	return Player_IsLocal(pl);
end

--## COMMON
function GetLookPosition(plr:player, x_offset:number, y_offset:number, z_offset:number):matrix
	local playerUnit = Player_GetUnit(plr);
	if playerUnit == nil then
		return nil;
	end

	--defer to pretty good default values if none are specified
	--how far away from the player on the x-axis (the ground) in world units
	x_offset = x_offset or 3;
	
	--how far off the center to the left or right of the viewport
	y_offset = y_offset or 0;
	
	--how far off the bottom to the up or down of the viewport
	--0.5 is right at the reticle
	z_offset = z_offset or 0.5;
	
	local m = ToLocation(plr).matrix;
	
	local lookYaw = object_get_function_value(playerUnit, "look_yaw") or 0;
	local lookPitch = object_get_function_value(playerUnit, "look_pitch") or 0;

	m.angles = vector(0, m.angles.y + lookPitch, m.angles.z + lookYaw);
	
	m.pos = m:transform(vector(x_offset, y_offset, z_offset));

	return m;
end