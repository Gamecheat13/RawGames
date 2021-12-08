--## SERVER

-- Global Player Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Player Added Callback
-- Called by the game whenever a player joins the match
-------------------------------------------------------------------------------------------------

hstructure PlayerAddedEventStruct
	player:player;
	joinInProgress:boolean;
	rejoin:boolean;
end

-- Callback from C++
function GlobalObjectEventPlayerJoined(player:player, joinInProgress:boolean, rejoin:boolean)
	local eventArgs = hmake PlayerAddedEventStruct
		{
			player = player,
			joinInProgress = joinInProgress,
			rejoin = rejoin
		};

	CallEvent(g_eventTypes.playerAddedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Simulation Started Callback
-- Called by the game whenever a player has loaded into the map and is succesfully running simulation.
-- This will only happen when a client acknowledges a zone set switch or 
-- when a player loads into a map (whether jipping, or connecting) since that causes a zone set switch.
-- If you are running without a server, this will never be called.
-------------------------------------------------------------------------------------------------

hstructure PlayerSimulationStartedEventStruct
	player:player;
end

-- Callback from C++
function GlobalObjectEventPlayerSimulationStarted(player:player)
	local eventArgs = hmake PlayerSimulationStartedEventStruct
		{
			player = player
		};

	CallEvent(g_eventTypes.playerSimulationStartedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Activated Callback
-- Called by the game when a player is active in game
-------------------------------------------------------------------------------------------------

hstructure PlayerActiveInGameEventStruct
	player:player;
	joinInProgress:boolean;
end

-- Callback from C++
function GlobalObjectEventPlayerActiveInGame(player:player, joinInProgress:boolean)
	local eventArgs = hmake PlayerActiveInGameEventStruct
		{
			player = player,

			-- After a green build (2020/11/18) the below can change to just "joinInProgress = joinInProgress"; the current version
			-- is to handle old binaries not sending the joinInProgress arg and it coming across as nil
			joinInProgress = joinInProgress or false,
		};

	CallEvent(g_eventTypes.playerActiveInGameEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Spawned callback
-- Called by the game whenever a player spawns
-------------------------------------------------------------------------------------------------

hstructure PlayerSpawnEventStruct
	playerUnit:object;
	player:player;
end

-- Callback from C++
function GlobalObjectEventPlayerSpawn(playerUnit:object, player:player)
	local event = hmake PlayerSpawnEventStruct
		{
			playerUnit = playerUnit,
			player = player,
		};
	
	CallEvent(g_eventTypes.playerSpawnEvent, player, event);
end

-------------------------------------------------------------------------------------------------
-- Player Spawn Protection Start callback
-- Called by the game whenever a player's Spawn Protection starts (only fires if Spawn Protection is enabled and has a nonzero duration)
-------------------------------------------------------------------------------------------------

hstructure PlayerSpawnProtectionStartEventStruct
	playerUnit:object;
	player:player;
end

-- Callback from C++
function PlayerSpawnProtectionStartCallback(playerUnit:object, player:player)
	local event = hmake PlayerSpawnProtectionStartEventStruct
		{
			playerUnit = playerUnit,
			player = player,
		};
	
	CallEvent(g_eventTypes.playerSpawnProtectionStart, player, event);
end

-------------------------------------------------------------------------------------------------
-- Player Spawn Protection End callback
-- Called by the game whenever a player's Spawn Protection ends
-------------------------------------------------------------------------------------------------

hstructure PlayerSpawnProtectionEndEventStruct
	playerUnit:object;
	player:player;
end

-- Callback from C++
function PlayerSpawnProtectionEndCallback(playerUnit:object, player:player)
	local event = hmake PlayerSpawnProtectionEndEventStruct
		{
			playerUnit = playerUnit,
			player = player,
		};
	
	CallEvent(g_eventTypes.playerSpawnProtectionEnd, player, event);
end

-------------------------------------------------------------------------------------------------
-- Player Unit Replaced Callback
--
-- Called by the game whenever a player unit is refreshed but without the player dying, e.g. when
-- the representation changes.
-------------------------------------------------------------------------------------------------

global g_playerUnitReplacedEvent = "playerUnitReplacedEvent";

hstructure PlayerUnitReplacedEventStruct
	newUnit:object;
	oldUnit:object;
	player:player;
end

-- Callback from C++
function GlobalObjectEventPlayerUnitReplaced(newUnit:object, oldUnit:object, player:player)
	local event = hmake PlayerUnitReplacedEventStruct
		{
			newUnit = newUnit,
			oldUnit = oldUnit,
			player = player,
		};
	
	CallEvent(g_playerUnitReplacedEvent, player, event);
end

-------------------------------------------------------------------------------------------------
-- Player Removed Callback
-- Called by the game whenever a player is about to be removed, but before we clean up their data
-- Note that the Player Post Removed Callback (below) is called once we have cleaned up all of the player's data
-------------------------------------------------------------------------------------------------

hstructure PlayerRemovedEventStruct
	player 			:player;
	playerTeam 		:mp_team;
	playerUnit 		:object;
	playerDeadUnit 	:object;
end

-- Callback from C++
function PlayerRemovedCallback(player:player, playerTeam:mp_team, playerUnit:object, playerDeadUnit:object)
	local eventArgs = hmake PlayerRemovedEventStruct
		{
			player = player,
			playerTeam = playerTeam,
			playerUnit = playerUnit,
			playerDeadUnit = playerDeadUnit,
		};

	CallEvent(g_eventTypes.playerRemovedEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Post Removed Callback
-- Called by the game when a player has finished being removed and we have cleaned up their data
-------------------------------------------------------------------------------------------------

hstructure PlayerPostRemovedEventStruct
	player:player;
end

-- Callback from C++
function PlayerPostRemovedCallback(player:player)
	local eventArgs = hmake PlayerPostRemovedEventStruct
		{
			player = player
		};

	CallEvent(g_eventTypes.playerPostRemovedEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Changed Index Callback
-- Called by the engine whenever a player's index changed
-------------------------------------------------------------------------------------------------

hstructure PlayerChangedIndexEventStruct
	oldPlayer:player;
	newPlayer:player;
end

-- Callback from C++
function PlayerChangedIndexCallback(oldPlayer:player, newPlayer:player)
	local eventArgs = hmake PlayerChangedIndexEventStruct
		{
			oldPlayer = oldPlayer,
			newPlayer = newPlayer
		};

	CallEvent(g_eventTypes.playerChangedIndexEvent, oldPlayer, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Changed Team Callback
-- Called by the engine whenever a player changes team
-------------------------------------------------------------------------------------------------

hstructure PlayerChangedTeamEventStruct
	player:player;
	oldTeam:mp_team;
	newTeam:mp_team;
end

-- Callback from C++
function PlayerChangedTeamCallback(player:player, oldTeam:mp_team, newTeam:mp_team)
	local eventArgs = hmake PlayerChangedTeamEventStruct
		{
			player = player,
			oldTeam = oldTeam,
			newTeam = newTeam
		};

	CallEvent(g_eventTypes.playerChangedTeamEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Changed Multiplayer Squad Callback
-- Called by the engine whenever a player changes multiplayer squad
-------------------------------------------------------------------------------------------------

hstructure PlayerChangedMultiplayerSquadEventStruct
	player:player;
	oldSquad:mp_squad;
	newSquad:mp_squad;
end

-- Callback from C++
function PlayerChangedMultiplayerSquadCallback(player:player, oldSquad:mp_squad, newSquad:mp_squad)
	local eventArgs = hmake PlayerChangedMultiplayerSquadEventStruct
		{
			player = player,
			oldSquad = oldSquad,
			newSquad = newSquad
		};

	CallEvent(g_eventTypes.playerChangedMultiplayerSquadEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Level Changed Callback
-- Called by the engine whenever a player's level changes
-------------------------------------------------------------------------------------------------

hstructure PlayerChangedLevelEventStruct
	player:player;
	previousLevel:number;
	newLevel:number;
end

-- Callback from C++
function PlayerLevelChangedCallback(player:player, previousLevel:number, newLevel:number)
	local eventArgs = hmake PlayerChangedLevelEventStruct
		{
			player = player,
			previousLevel = previousLevel,
			newLevel = newLevel
		};

	CallEvent(g_eventTypes.playerChangedLevelEvent, player, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Player Power Frame Points Changed Callback
-- Called by the engine whenever a player's power frame points changes
-------------------------------------------------------------------------------------------------

hstructure PlayerPowerFramePointsChangedEventStruct
	player:player;
	previousPoints:number;
	newPoints:number;
end

-- Callback from C++
function PlayerPowerFramePointsChangedCallback(player:player, previousPoints:number, newPoints:number)
	local eventArgs = hmake PlayerPowerFramePointsChangedEventStruct
		{
			player = player,
			previousPoints = previousPoints,
			newPoints = newPoints
		};

	CallEvent(g_eventTypes.playerPowerFramePointsChangedEvent, player, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Player Attachment Modified Callback
-- Called by the engine whenever a player's power frame modifies an attachment
-------------------------------------------------------------------------------------------------

hstructure PlayerPowerFrameRequestHandledEventStruct
	player:player;
	bucket:string_id;
	modifiedProperty:string_id;
end

-- Callback from C++
function PlayerPowerFrameRequestHandledCallback(player:player, bucket:string_id, modifiedProperty:string_id)
	local eventArgs = hmake PlayerPowerFrameRequestHandledEventStruct
		{
			player = player,
			bucket = bucket,
			modifiedProperty = modifiedProperty
		};

	CallEvent(g_eventTypes.playerPowerFrameRequestHandledEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Attachment Modified Callback
-- Called by the engine whenever a player's power frame modifies an attachment
-------------------------------------------------------------------------------------------------

hstructure PlayerCalloutEventStruct
	playerWhoPinged:player;
	calloutPosition:vector;
	targets:table;
	existingNavpoints:table;
	undoable: boolean;
end

-- Callback from C++
function CalloutReceivedCallback(player:player, calloutPosition:vector, targets:table, existingNavpoints:table)

	 if (type(targets) ~= "table") then
		targets = { [1] = targets };
	 end

	local eventArgs = hmake PlayerCalloutEventStruct
		{
			playerWhoPinged = player,
			calloutPosition = calloutPosition,
			targets = targets,
			existingNavpoints = existingNavpoints,
			undoable = true
		};

	CallEvent(g_eventTypes.playerCalloutEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Spotted Target Callback
-- Called when a player spots a registered enemy target
-- A target is spotted when it is within the max range and FOV (defined in the game variant) and
-- there is a clear line of sight.
-------------------------------------------------------------------------------------------------

hstructure PlayerSpottedTargetEventStruct
	spotter:player;
	target:object;
	identifier:number;
end

-- Callback from C++
function PlayerSpottedTargetCallback(spotter:player, target:object, identifier:number)
	local eventArgs = hmake PlayerSpottedTargetEventStruct
		{
			spotter = spotter,
			target = target,
			identifier = identifier,
		};

	CallEvent(g_eventTypes.playerSpottedTargetEvent, nil, eventArgs);
end
