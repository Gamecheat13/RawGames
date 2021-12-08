-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalObjectCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');

-- The Interactive Parcel provides an easy way of listening and responding to interact events on device control objects
-- Reach out to the Sandbox Objects team if you have any questions

global InteractiveParcel:table = Parcel.MakeParcel
{
	-- Required: Do not modify outside of class
	managedObject = nil,
	isComplete = false,
	subscribedToEvents = false,
	EVENTS =
	{
		onInteract = "OnInteract",
		onObjectDeleted = "OnObjectDeleted"
	}
}

-- Constructor

function InteractiveParcel:New(objectInstance):table
	local parcel = nil;	
	if objectInstance ~= nil then
		parcel = self:CreateParcelInstance();
		parcel.managedObject = objectInstance;
		parcel.isComplete = false;
		parcel.instanceName = "InteractiveParcel_"..tostring(self);
	end
	return parcel;
end

-- Class Functions: Public

-- Required Parcel Overrides: Needed in order for the parcel to be instantiated and work properly

function InteractiveParcel:shouldEnd():boolean
	return self.isComplete;
end

function InteractiveParcel:Run():void
	self:SubscribeToEvents();
end

-- Getters

function InteractiveParcel:GetDevicePower():number
	return Device_GetPower(self.managedObject);
end

-- Setters

function InteractiveParcel:SetActionString(actionStringID:string):void
	if not stringIsNullOrEmpty(actionStringID) then
		Device_SetPrimaryActionStringOverride(self.managedObject, actionStringID);
	end
end

function InteractiveParcel:SetDevicePower(newValue:number):void
	if self:IsManagedObjectValid() then
		Device_SetPower(self.managedObject, newValue);
	end
end

function InteractiveParcel:SetDevicePosition(newValue:number):void
	if self:IsManagedObjectValid() then
		Device_SetPosition(self.managedObject, newValue);
	end
end

function InteractiveParcel:SetDeviceAllowsHoldingSupportWeapons(newValue:boolean):void
	if self:IsManagedObjectValid() then
		Device_SetAllowsHoldingSupportWeapons(self.managedObject, newValue);
	end
end

-- Core Functions

function InteractiveParcel:SetTeamFilter(newTeam:mp_team_designator):void
	-- If we have a non-neutral team, we need to only allow that team to interact
	-- If the team on this object is neutral, anyone should be able to interact with it
	if newTeam ~= MP_TEAM_DESIGNATOR.Neutral then
		local filter = Object_Filter_CreateTeamDesignatorMaskFilter(self.managedObject);
		Object_Filter_SetTeamDesignatorMask(self.managedObject, filter, newTeam, true);
	else
		Object_Filter_RemoveAllFilters(self.managedObject)
	end
end

-- Events

function InteractiveParcel:AddOnInteractCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:OnInteractCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onInteract, callbackFunc, callbackOwner);
	end
end

function InteractiveParcel:RemoveOnInteractCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:OnInteractCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onInteract, callbackFunc, callbackOwner);
	end
end

function InteractiveParcel:AddOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:OnInteractCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

function InteractiveParcel:RemoveOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:OnInteractCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

function InteractiveParcel:SubscribeToEvents():void
	if self:IsManagedObjectValid() then

		if self:IsSubscribedToEvents() then return end;

		self:RegisterEventOnSelf(g_eventTypes.objectInteractEvent, self.OnInteractInternal, self.managedObject);
		self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeletedInternal, self.managedObject);

		self.subscribedToEvents = true;
	end
end

function InteractiveParcel:UnsubscribeFromEvents():void
	if self:IsSubscribedToEvents() then
		if self:IsManagedObjectValid() then
			self:UnregisterEventOnSelf(g_eventTypes.objectInteractEvent, self.OnInteractInternal, self.managedObject);
		    self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeletedInternal, self.managedObject);
		end
		self.subscribedToEvents = false;
	end
end

-- Helpers

function InteractiveParcel:EndParcel()
	self:UnsubscribeFromEvents();
	self.isComplete = true;
end

function InteractiveParcel:IsManagedObjectValid():boolean
	local objectValid:boolean = object_index_valid(self.managedObject) and self.managedObject ~= nil;
	return objectValid;
end

function InteractiveParcel:IsSubscribedToEvents():boolean
	return self.subscribedToEvents == true;
end

function InteractiveParcel:OnInteractCallbackArguementsValid(callbackOwner:object, callbackFunc):boolean
	if callbackOwner == nil then
		dprint("InteractiveParcel:OnInteractCallbackArguementsValid: Callback owner is invalid.")
		return false;
	end

	if callbackFunc == nil then
		dprint("InteractiveParcel:OnInteractCallbackArguementsValid: Callback function is invalid.")
		return false;
	end

	return true;
end

-- Class Functions: Private

-- Internal Event Callbacks

function InteractiveParcel:OnInteractInternal(eventArgs:InteractEventStruct):void
	self:TriggerEvent(self.EVENTS.onInteract, eventArgs);
end

function InteractiveParcel:OnObjectDeletedInternal(deletedObject:object):void
	self:TriggerEvent(self.EVENTS.onObjectDeleted, deletedObject);
	self.isComplete = true;
end