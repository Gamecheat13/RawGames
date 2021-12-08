-- Copyright (C) Microsoft. All rights reserved.

--## SERVER

--[[
--  __     ______   ______     __    __        __   __   ______        ______     __  __     ______   ______     ______     __   __   __     ______     ______     ______    
-- /\ \   /\__  _\ /\  ___\   /\ "-./  \      /\ \ / /  /\  __ \      /\  ___\   /\ \/\ \   /\  == \ /\  ___\   /\  == \   /\ \ / /  /\ \   /\  ___\   /\  __ \   /\  == \   
-- \ \ \  \/_/\ \/ \ \  __\   \ \ \-./\ \     \ \ \'/   \ \ \/\ \     \ \___  \  \ \ \_\ \  \ \  _-/ \ \  __\   \ \  __<   \ \ \'/   \ \ \  \ \___  \  \ \ \/\ \  \ \  __<   
--  \ \_\    \ \_\  \ \_____\  \ \_\ \ \_\     \ \__|    \ \_____\     \/\_____\  \ \_____\  \ \_\    \ \_____\  \ \_\ \_\  \ \__|    \ \_\  \/\_____\  \ \_____\  \ \_\ \_\ 
--   \/_/     \/_/   \/_____/   \/_/  \/_/      \/_/      \/_____/      \/_____/   \/_____/   \/_/     \/_____/   \/_/ /_/   \/_/      \/_/   \/_____/   \/_____/   \/_/ /_/ 
--]]


global MPItemVOSupervisor:table = Parcel.MakeParcel
{
	instanceName = "ItemVOSupervisor",
	complete = false,

	pendingIncomingVO = {},
	pendingReadyVO = {},

	incomingWindowTimer = nil,
	readyWindowTimer = nil,

	CONFIG = 
	{
		enableDebugPrint = false,
	},

	CONST = 
	{
		windowDuration = 0.5,	-- time in seconds for which incoming VO will be grouped together
		commonIncomingResponsesByType = { "__OnIncomingPowerWeapons", "__OnIncomingPowerups", "__OnIncomingSiegeVehicles", "__OnIncomingDropPods", },
		commonIncomingMultiTypeResponse = "__OnIncomingPowerItems";
		commonReadyResponsesByType = { "__OnPowerWeaponsSpawned", "__OnPowerupsSpawned", "__OnSiegeVehiclesSpawned", nil, },
		commonReadyMultiTypeResponse = "__OnPowerItemsSpawned";
	},

	EVENTS =
	{
	},
};

function MPItemVOSupervisor:New():table
	local newSupervisor = self:CreateParcelInstance();
	return newSupervisor;
end

function MPItemVOSupervisor:IsComplete():boolean
	return self.complete;
end

function MPItemVOSupervisor:shouldEnd():boolean
	return self:IsComplete();
end

function MPItemVOSupervisor:EndShutdown():void
	if (self.incomingWindowTimer ~= nil) then
		Engine_DeleteTimer(self.incomingWindowTimer);
		self.incomingWindowTimer = nil;
	end

	if (self.readyWindowTimer ~= nil) then
		Engine_DeleteTimer(self.readyWindowTimer);
		self.readyWindowTimer = nil;
	end
end

function MPItemVOSupervisor:Run():void
end

function MPItemVOSupervisor:Initialize():void
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundStartEvent, self.HandleRoundStart);

	self.incomingWindowTimer = Engine_CreateTimer();

	if (self.incomingWindowTimer ~= nil) then
		self:RegisterEventOnSelf(g_eventTypes.timerExpiredEvent, self.HandleIncomingWindowTimerExpired, self.incomingWindowTimer);
	else
		print("Error creating MPItemVOSupervisor incoming timer");
	end

	self.readyWindowTimer = Engine_CreateTimer();

	if (self.readyWindowTimer ~= nil) then
		self:RegisterEventOnSelf(g_eventTypes.timerExpiredEvent, self.HandleReadyWindowTimerExpired, self.readyWindowTimer);
	else
		print("Error creating MPItemVOSupervisor ready timer");
	end
end

function MPItemVOSupervisor:HandleRoundStart(roundStartArgs:RoundStartEventStruct):void
	self.pendingIncomingVO = {};
	self.pendingReadyVO = {};
end

function MPItemVOSupervisor:PlayVO(voData:MPItemSpawnerPendingVOData):void
	self:DebugPrint("MPItemVOSupervisor:PlayVO");

	if (voData.voType == MPItemVOType.Incoming) then
		self:QueueVO(self.pendingIncomingVO, voData, self.incomingWindowTimer);
	else
		self:QueueVO(self.pendingReadyVO, voData, self.readyWindowTimer);
	end
end

function MPItemVOSupervisor:QueueVO(pendingVO:table, voData:MPItemSpawnerPendingVOData, windowTimer:timer):void
	self:DebugPrint("MPItemVOSupervisor:QueueVO", voData.voType, voData.itemType, voData.itemName);

	if (table.IsEmpty(pendingVO)) then
		Timer_SetSecondsLeft(windowTimer, self.CONST.windowDuration);
		Timer_Start(windowTimer);
	end

	table.insert(pendingVO, voData);
end

function MPItemVOSupervisor:HandleIncomingWindowTimerExpired(eventArgs:TimerExpiredEventStruct):void
	Timer_Stop(self.incomingWindowTimer);
	self:ProcessVO(self.pendingIncomingVO, self.CONST.commonIncomingResponsesByType, self.CONST.commonIncomingMultiTypeResponse);
	self.pendingIncomingVO = {};
end

function MPItemVOSupervisor:HandleReadyWindowTimerExpired(eventArgs:TimerExpiredEventStruct):void
	Timer_Stop(self.readyWindowTimer);
	self:ProcessVO(self.pendingReadyVO, self.CONST.commonReadyResponsesByType, self.CONST.commonReadyMultiTypeResponse);
	self.pendingReadyVO = {};
end

function MPItemVOSupervisor:ProcessVO(pendingVO:table, responsesByType:table, commonResponse:string):void
	self:DebugPrint("MPItemVOSupervisor:ProcessVO");

	if (table.IsEmpty(pendingVO)) then
		return;
	end
	
	local mixedTypes:boolean = false;
	local types:table = {};

	for i, voData in ipairs(pendingVO) do
		if (not table.contains(types, voData.itemType)) then
			if (i ~= 1) then
				mixedTypes = true;
				break;
			end

			table.insert(types, voData.itemType);
		end
	end

	if (mixedTypes) then
		MPLuaCall(commonResponse);
		self:DebugPrint("Play multi ITEM VO", pendingVO[1].voType);
	elseif (#pendingVO > 1) then
		local response:string = responsesByType[pendingVO[1].itemType];
		if (response ~= nil) then
			MPLuaCall(response);
			self:DebugPrint("Play multi TYPE VO", pendingVO[1].itemType, pendingVO[1].voType);
		end
	elseif (pendingVO[1].responseName ~= nil) then
		MPLuaCall(pendingVO[1].responseName, pendingVO[1].itemName, pendingVO[1].matchingPlayers);
		self:DebugPrint("Play solo VO", pendingVO[1].voType, pendingVO[1].itemType, pendingVO[1].itemName);
	end
end

-- DEBUGGING

function MPItemVOSupervisor:EnableDebugPrint(enable):void
	self.CONFIG.enableDebugPrint = enable;
end

function MPItemVOSupervisor:DebugPrint(...):void
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	if (self.CONFIG.enableDebugPrint) then
		print(...);
	end	
end

