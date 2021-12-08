-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

--Fast Travel is a combination of zoneset management, streaming and object teleport

--zoneset management (mostly for dungeon blink):
-- https://studio.343i.xboxgamestudios.com/display/343dshiva/Zone+Set+Streaming
--openworld streaming:
-- https://studio.343i.xboxgamestudios.com/display/343Code/Open+World+Streaming+Systems+in+Slipspace

global FastTravel:table = {
	Enabled = false,
	DebugOverride = false,
	UseLoadingScreenForDebugBlink = true,
	IsBlinking = false,
	FadeTimeSecondsMax = 5,
	manualOverride = nil,
}

function GetPlayerCentroid() : vector
	local playerCentroid = vector(0,0,0);
	local numPlayers:number = 0;
	for _, _player in ipairs(PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(_player) or Player_GetDeadUnit(_player);
		if object_index_valid(playerUnit) == true then
			playerCentroid = playerCentroid + ToLocation(playerUnit).vector;
		end
		-- This should be in the above check, but I'd rather not change this counting logic in a global file as there may be far reaching implications.
		numPlayers = numPlayers + 1;
	end

	if numPlayers > 0 then
		return playerCentroid / numPlayers;
	else 
		return playerCentroid;
	end
end

function PlayersSetLimbo(enable:boolean)
	for _, _player in ipairs(PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(_player) or Player_GetDeadUnit(_player);
		if object_index_valid(playerUnit) == true then
			local initialParent:object = object_get_ultimate_parent(playerUnit);
			object_set_limbo(initialParent, enable);
		end
	end
end

function PlayersSetStreamingPositions(position:vector)
	local playerCentroid = GetPlayerCentroid();
	for _, _player in ipairs(PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(_player) or Player_GetDeadUnit(_player);
		if object_index_valid(playerUnit) == true then
			local offset = ToLocation(playerUnit).vector - playerCentroid;
			Player_SetStreamingPosition(_player, position + offset);
		end
	end
end

function PlayersClearStreamingPositions()
	for _, _player in ipairs(PLAYERS.active) do
		Player_ClearStreamingPosition(_player);
	end
end

function PlayersTeleportToLocation(destination:location, teleportVehicles:boolean)
	local destinationMatrix:matrix = destination.matrix;
	local firstPlayer:player = nil;

	-- Teleport first player, then BroTeleport the remaining players
	for _, currentPlayer in ipairs(PLAYERS.active) do
		if firstPlayer == nil then
			firstPlayer = currentPlayer;
			Player_TeleportToLocation(firstPlayer, destinationMatrix, teleportVehicles);
		else
			Unit_BroTeleportToPlayer(currentPlayer, firstPlayer);
		end
	end
end

function PlayersSetControlEnabled(enable:boolean)
	for _, _player in ipairs(PLAYERS.active) do
		CampaignMap_SetPlayerControl(_player, enable);
	end
end

function PlayersCloseCampaignMap()
	for _, _player in ipairs(PLAYERS.active) do
		CampaignMap_CloseMap(_player);
	end
end

function IsSafeToPlay(targetZoneSet:zone_set)
	local engineReady:boolean = AllClientViewsActiveAndStable() and Engine_AreAllSystemsWarmedUp();
	return engineReady and current_zone_set_fully_active() == targetZoneSet;
end

function TeleportWithZoneset(destination:location, teleportVehicles:boolean, targetZoneSet:zone_set)

	--if no zoneset passed in, we want the automatic streaming zoneset, called "streaming"
	if targetZoneSet == nil then
		if ZONE_SETS["streaming"] ~= nil then
			targetZoneSet = ZONE_SETS["streaming"];
		else
			print("WARNING: Cannot teleport. Unable to find 'streaming' zoneset");
			return;
		end
	end
	
	local targetStreamingZoneset:boolean = ZoneSetIsStreaming(targetZoneSet);
	if targetStreamingZoneset and UseDynamicZoneSets() then --all handled under the hood
		
		if current_zone_set_fully_active() ~= targetZoneSet then
			switch_zone_set(targetZoneSet);
		end
		PlayersTeleportToLocation(destination, teleportVehicles);

	else
		if targetStreamingZoneset then --streaming static zoneset
			PlayersSetStreamingPositions(destination.vector);
		end

		ZoneSetTriggerVolumeSetEnabledAll(false);
		PlayersSetLimbo(true);

		if current_zone_set_fully_active() ~= targetZoneSet then
			prepare_to_switch_to_zone_set(targetZoneSet);
			SleepUntilSeconds([|not PreparingToSwitchZoneSet()], Game_TimeApproxFramesToSeconds(1));
			switch_zone_set(targetZoneSet);	
		end

		SleepUntilSeconds([|IsSafeToPlay(targetZoneSet)], Game_TimeApproxFramesToSeconds(1));
	
		PlayersSetLimbo(false);
		PlayersTeleportToLocation(destination, teleportVehicles);
		ZoneSetTriggerVolumeSetEnabledAll(true);

		if targetStreamingZoneset then
			PlayersClearStreamingPositions();
		end
	end
end

local function StartTravel(poiDestination:location, targetZoneSet:zone_set) : void
	-- notify the load screen and wait for fade out
	hud_show(false);
	StartingFastTravel();
	SleepUntil([|LoadScreenActive()], 1, Game_TimeApproxSecondsToFrames(FastTravel.FadeTimeSecondsMax));

	PlayersCloseCampaignMap();
	PlayersSetControlEnabled(false);
	NarrativeInterface.FastTravelSequenceCleanup();
	TeleportWithZoneset(poiDestination, false, targetZoneSet);

	EndingFastTravel();
	PlayersSetControlEnabled(true);
	hud_show(true);
end

-- ======================
--fast travel methods
-- ======================

function FastTravel.InitializeFromPersistence() : void
	local fastTravelEnabled:boolean = IsMissionCompleted(Persistence_TryCreateKeyFromString("pilotbase_reunite"));
	FastTravel.Enabled = fastTravelEnabled;
	CampaignMap_SetFastTravelPossible(FastTravel.Enabled);
end

function FastTravel.IsDisabled() : boolean
	local fastTravelDisabled:boolean = not FastTravel.Enabled;
	local debugNotEnabled:boolean = not FastTravel.DebugOverride;
	return debugNotEnabled and fastTravelDisabled;
end

function FastTravel.SetEnabled(enabled:boolean) : void
	FastTravel.Enabled = enabled;
	CampaignMap_SetFastTravelPossible(FastTravel.Enabled);
end

function FastTravel.SetManuallyDisabled(missionName:string_id)
	FastTravel.manualOverride = missionName;
end

function FastTravel.GetManuallyDisabledMissionName():string_id
	return FastTravel.manualOverride;
end

function FastTravel.DebugForceEnable() : void
	FastTravel.DebugOverride = true;
end

function FastTravel.Travel(poiDestination:matrix, targetZoneSet:zone_set)
	-- Include the FOB key if and only if we are travelling to a FOB 
	-- Mission manager has already verified the safe spot and destination

	if FastTravel.IsDisabled() then
		print("ATTENTION! We are fast travelling when it's explicitly disabled!");
		return;
	end

	StartTravel(ToLocation(poiDestination), targetZoneSet);
end

function FastTravel.NarrativeTravelOnSkip(poiDestination:location, targetZoneSet:zone_set)
	if (not FastTravel.IsBlinking) then
		StartTravel(poiDestination, targetZoneSet);
	end
end

function FastTravel.Blink(destination:vector, targetZoneSet:zone_set)
	FastTravel.IsBlinking = true;

	if FastTravel.UseLoadingScreenForDebugBlink == true then
		StartTravel(ToLocation(destination), targetZoneSet);
	else
		TeleportWithZoneset(ToLocation(destination), true, targetZoneSet);
	end
	FastTravel.IsBlinking = false;
end

function FastTravel.BlinkToLocation(destination:location, targetZoneSet:zone_set)
	FastTravel.IsBlinking = true;

	FastTravel.DebugStopAllCinematics();

	if FastTravel.UseLoadingScreenForDebugBlink == true then
		StartTravel(destination, targetZoneSet);
	else
		TeleportWithZoneset(destination, true, targetZoneSet);
	end

	FastTravel.DebugStopAllCinematics();

	FastTravel.IsBlinking = false;
end

-- Helper
function FastTravel.DebugStopAllCinematics()
	local cinematicTriggerWait:number = 3; 
	local isPlayingCinematic:boolean = cinematic_in_progress();
	repeat
		if (isPlayingCinematic == true) then
			composer_stop_all();
			SleepSeconds(cinematicTriggerWait);
			isPlayingCinematic = cinematic_in_progress();
		end
	until not isPlayingCinematic;
end
