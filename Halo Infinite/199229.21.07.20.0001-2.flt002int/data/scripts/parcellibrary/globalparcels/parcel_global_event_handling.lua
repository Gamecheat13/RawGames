-- Copyright (c) Microsoft. All rights reserved.
--[[												
  _______  __        ______   .______        ___       __          ___________    ____  _______ .__   __. .___________.   .___  ___.      ___      .__   __.      ___       _______  _______ .______      
 /  _____||  |      /  __  \  |   _  \      /   \     |  |        |   ____\   \  /   / |   ____||  \ |  | |           |   |   \/   |     /   \     |  \ |  |     /   \     /  _____||   ____||   _  \     
|  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |  |__   \   \/   /  |  |__   |   \|  | `---|  |----`   |  \  /  |    /  ^  \    |   \|  |    /  ^  \   |  |  __  |  |__   |  |_)  |    
|  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |   __|   \      /   |   __|  |  . `  |     |  |        |  |\/|  |   /  /_\  \   |  . `  |   /  /_\  \  |  | |_ | |   __|  |      /     
|  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  |____   \    /    |  |____ |  |\   |     |  |        |  |  |  |  /  _____  \  |  |\   |  /  _____  \ |  |__| | |  |____ |  |\  \----.
 \______| |_______| \______/  |______/  /__/     \__\ |_______|   |_______|   \__/     |_______||__| \__|     |__|        |__|  |__| /__/     \__\ |__| \__| /__/     \__\ \______| |_______|| _| `._____|
                                                                                                                                                                                                                                      
--]] 

--## SERVER

global GlobalEventManagerParcel = 
{
	--Parcel Variables
	--Place all the variables your parcel needs here.

	--//////
	-- Parcel
	--//////
	--Whether the parcel is ready to start.  Used by the parcel manager
	canStart = false,  				
	--Whether the parcel has had it's completion requirements met.  The parcel ends when this is true
	complete = false,
	--Ideally each instance of this parcel would have a unique name.  Set via the New() function
	instanceName = "GlobalEventManagerParcel",

	eventManger = nil,

	registeredEventNames = {},

	CONFIG = 
	{
		--CONFIG variables are for variables you want to edit for variants and use in New.

		--//////
		--// Parcel
		--//////

		--A debug variable used to enable/disable debug prints in the parcel.
		enableDebugPrint = false, 


	},
	
	CONST = 
	{
		--CONST variables are variables you may want to change for creation, but never change at run time.

	},
	
};

function GlobalEventManagerParcel:New():table
	--New is used to set up all the variables and functions for the parcel.

	local newGlobalEventManagerParcel = ParcelParent(self);

	newGlobalEventManagerParcel.eventManager = EventManager:New(newGlobalEventManagerParcel.instanceName);
	
	return newGlobalEventManagerParcel;
end

function GlobalEventManagerParcel:InitializeImmediate():void
	--Initialize Immediate initializes variables and events that are needed for the parcel.
end

function GlobalEventManagerParcel:Initialize():void

end

function GlobalEventManagerParcel:Run():void

end

function GlobalEventManagerParcel:IsComplete():boolean
	--Check to see if the parcel is complete.
	return self:shouldEnd();
end

function GlobalEventManagerParcel:shouldEnd():boolean
	--Check to see what complete is set to.
	return self.complete;
end

function GlobalEventManagerParcel:EndShutdown():void
	-- Unregister Events here so they are cleaned up when the Parcel is finished.
	-- Events registered through the parcel system are automatically cleaned up at this point.
	for _, globalEvent in hpairs (self.registeredEventNames) do
		self.eventManager:UnRegisterEvent(globalEvent);
	end
end

--Use this Function to Register Global Events in the Parcel you want to register events with.
function GlobalEventManagerParcel:RegisterParcelGlobalEvent(eventName:string):void
    if (not self:EventExists(eventName)) then
		self.eventManager:RegisterEvent(eventName);
		self.registeredEventNames[eventName] = eventName;
    end
end

-- Allows for cleanup of registered event types (e.g. for when an event-owning round-based parcel's lifetime ends)
function GlobalEventManagerParcel:UnRegisterParcelGlobalEvent(eventName:string):void
	if (self:EventExists(eventName)) then
		self.registeredEventNames[eventName] = nil;
		self.eventManager:UnRegisterEvent(eventName);
	else
		assert(false, "GlobalEventManagerParcel: Error: Attempted to Deregister and event that does not exist! EventName = " .. eventName);
	end
end

--Use this Function to fire off Registered Global Events
function GlobalEventManagerParcel:FireGlobalEvent(globalEventName:string, ...):void
	if (self:EventExists(globalEventName)) then
		self.eventManager:TriggerEvent(globalEventName, unpack(arg));
	else
		assert(self:EventExists(globalEventName), "ERROR! Event does not exist!");
	end

end

--Checks to see if an event actually exists.
function GlobalEventManagerParcel:EventExists(eventName:string):boolean
	return self.registeredEventNames[eventName] ~= nil;
end

--
-- EVENT CALLBACKS
--
function GlobalEventManagerParcel:AddGlobalEvent(eventName:string, callbackOwner, callbackFunc:ifunction):void
	self.eventManager:RegisterCallBack(eventName, callbackFunc, callbackOwner);
end

function GlobalEventManagerParcel:RemoveGlobalEvent(eventName:string, callbackOwner, callbackFunc:ifunction):void
	self.eventManager:UnRegisterCallBack(eventName, callbackFunc, callbackOwner);
end