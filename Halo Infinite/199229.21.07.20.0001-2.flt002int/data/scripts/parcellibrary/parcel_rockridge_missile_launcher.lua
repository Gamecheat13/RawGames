-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

global TriggerableMissileLauncher:table = Parcel.MakeParcel
{
	instanceName = "TriggerableMissileLauncher", 

	--Whether the parcel has had it's completion requirements met.  The parcel ends when this is true
	complete = false,
	isActive = false,

	deviceMachine = nil,
	animationName = "",

	CONFIG = 
	{
		enableDebugPrint = false,
		updateDeltaSeconds = 0.1, 

		powerMessage = "",
		controlMessage = "",

		secondToReset = 45,
	},

	CONST =
	{
		objectFunctionOpen = 1,
		objectFunctionClosed = 0,
	}
}

function TriggerableMissileLauncher:New(instanceName:string, deviceMachine:object, animationName:string):void
	local newTriggerableMissileLauncher = self:CreateParcelInstance();

	newTriggerableMissileLauncher.instanceName = instanceName;
	newTriggerableMissileLauncher.deviceMachine = deviceMachine;
	newTriggerableMissileLauncher.animationName = animationName;

	return newTriggerableMissileLauncher;

end

--
-- Parcel Functions
--

function TriggerableMissileLauncher:Initialize():void

end

function TriggerableMissileLauncher:shouldEnd():boolean
	return self.complete
end

function TriggerableMissileLauncher:Run():void
	self:SleepUntilValid();

	if self.CONFIG.powerMessage ~= "" then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectPowerUpdated, self.PowerMessageReceived, self.CONFIG.powerMessage);
	end

	if self.CONFIG.controlMessage ~= "" then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectControlUpdated, self.ControlMessageReceived, self.CONFIG.controlMessage);
	end
end

function TriggerableMissileLauncher:SleepUntilValid():void
	--Used to wait for all players to be loaded in the game.
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function TriggerableMissileLauncher:EndShutdown():void

end

--
-- Object Message System
--
function TriggerableMissileLauncher:PowerMessageReceived(eventStruct:CommunicationObjectPowerUpdateEventStruct):void
	Object_SetFunctionValue(self, self.animationName, 1, 0);
	self:CreateThread(self.ResetAnim);
end


function TriggerableMissileLauncher:ControlMessageReceived(eventStruct:CommunicationObjectControlUpdateEventStruct):void
	Object_SetFunctionValue(self.deviceMachine, self.animationName, self.CONST.objectFunctionOpen, 0);
	self:CreateThread(self.ResetAnim);
end

function TriggerableMissileLauncher:ResetAnim():void
	SleepSeconds(self.CONFIG.secondToReset);
	Object_SetFunctionValue(self.deviceMachine, self.animationName, self.CONST.objectFunctionClosed, 0);
end