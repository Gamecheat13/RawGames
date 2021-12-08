-- Copyright (c) Microsoft. All rights reserved.
--=====================================
--=== DOMINION CONTROLS ===
--=====================================

--## SERVER

global DominionEnum = table.makeAutoEnum
	{
		"none",
		"green",
		"green_digsite",
		"yellow",
		"yellow_aagun",
		"red",
	};

-- === GetPlayerDominion: returns the DominionEnum number of the dominion that the player is in
--		playerArg				- the player to check the dominion (defaults to fireteam leader)
-- === RETURNS: the DominionEnum number
-- === if the player is not in a dominion or the DominionVolumeTable in nil then it returns DominionEnum.none
function GetPlayerDominion(playerArg:player):number
	local domTable:table = GetDominionTable();
	if domTable ~= nil then
		--default to the fireteam leader
		playerArg = playerArg or GetFireTeamLeader();

		local playerUnit:object = Player_GetUnit(playerArg);
		if playerUnit ~= nil then
			for enum, volumeTable in hpairs(domTable) do
				if GetEngineType(volumeTable) == "table" and sys_DominionCheck(playerUnit, volumeTable) == true then
					return enum;
				end
			end
		end
	end
	return DominionEnum.none;
end
---helpers

function GetDominionTable():table
	return _G["DominionVolumeTable"];
end

function sys_DominionCheck(playerUnit:player, volumeTable:table):boolean
	--check all the volumes in the specific dominion table for the player
	for _, volume in ipairs(volumeTable) do
		local playerList = ActivationVolume_GetPlayers(volume);
		if table.contains(playerList, playerUnit) then
			return true;
		end
	end

	return false;
end