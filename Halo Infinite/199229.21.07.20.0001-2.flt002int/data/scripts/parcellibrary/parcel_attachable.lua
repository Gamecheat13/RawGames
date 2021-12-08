-- Copyright (c) Microsoft. All rights reserved.

-- Reach out to the Sandbox Objects team if you have any questions

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalObjectCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');

-- The Attachable Parcel provides an easy way of handling dynamic attachments

global AttachableParcel:table = Parcel.MakeParcel
{
	-- Required: Do not modify outside of class
	managedObject = nil,
	isComplete = false,
	subscribedToEvents = false,
	EVENTS =
	{
		onObjectAttached = "OnObjectAttached",
		onObjectDetached = "OnObjectDetached",
		onObjectDeleted  = "OnObjectDeleted"
	}
}

-- Constructor

function AttachableParcel:New(objectInstance):table
	local parcel = nil;

	if objectInstance ~= nil then
		parcel = self:CreateParcelInstance();
		parcel.managedObject = objectInstance;
		parcel.isComplete = false;
		parcel.instanceName = "AttachableParcel_"..tostring(self);
	end

	return parcel;
end

-- Class Functions: Public

-- Required Parcel Overrides: Needed in order for the parcel to be instantiated and work properly

function AttachableParcel:shouldEnd():boolean
	return self.isComplete;
end

function AttachableParcel:Run():void
	if self.managedObject ~= nil then
		self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.managedObject, self);
		if Engine_GetObjectType(self.managedObject) == OBJECT_TYPE._object_type_weapon then
			self:RegisterEventOnceOnSelf(g_eventTypes.weaponPickupEvent, self.OnDetached, self.managedObject, self);
		end
	end
end

-- Core Functions

function AttachableParcel:Attach(objectToAttachTo:object, attachMarker:string, childAttachPointMarker:string):void
	if self:IsAttached() then
		dprint("AttachableParcel: Managed object is attached to something already. Please detach first, then attach.");
		return;
	end

	if objectToAttachTo == nil or not object_index_valid(self.managedObject) then return; end

	objects_attach(objectToAttachTo, attachMarker, self.managedObject, childAttachPointMarker);
	self:OnAttached(self.managedObject);
end

function AttachableParcel:PhysicallyAttach(objectToAttachTo:object, attachMarker:string, childAttachPointMarker:string):void
	if self:IsAttached() then
		dprint("AttachableParcel: Managed object is already attached to something. Please detach first, then attach.");
		return;
	end
	
	if objectToAttachTo == nil or not object_index_valid(self.managedObject) then return; end
	
	objects_physically_attach(objectToAttachTo, attachMarker, self.managedObject, childAttachPointMarker);

	self:OnAttached(self.managedObject);
end

function AttachableParcel:Detach():void
	if not self:IsAttached() or not object_index_valid(self.managedObject) then return; end
	objects_detach(Object_GetParent(self.managedObject), self.managedObject);	
	self:OnDetached(self.managedObject);
end

-- Events

-- OnObjectAttached

function AttachableParcel:AddOnObjectAttachedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectAttached, callbackFunc, callbackOwner);
	end
end

function AttachableParcel:RemoveOnObjectAttachedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectAttached, callbackFunc, callbackOwner);
	end
end

-- OnObjectDetached

function AttachableParcel:AddOnObjectDetachedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDetached, callbackFunc, callbackOwner);
	end
end

function AttachableParcel:RemoveOnObjectDetachedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDetached, callbackFunc, callbackOwner);
	end
end

-- OnObjectDeleted

function AttachableParcel:AddOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

function AttachableParcel:RemoveOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

-- Helpers

function AttachableParcel:IsAttached():boolean
	return Object_GetParent(self.managedObject) ~= nil;
end

function AttachableParcel:EventCallbackArguementsValid(callbackOwner:object, callbackFunc):boolean
	if callbackOwner == nil then
		dprint("AttachableParcel:EventCallbackArguementsValid: Callback owner is invalid.")
		return false;
	end

	if callbackFunc == nil then
		dprint("AttachableParcel:EventCallbackArguementsValid: Callback function is invalid.")
		return false;
	end

	return true;
end

-- Class Functions: Private

-- Internal Event Callbacks

function AttachableParcel:OnAttached(attachedObject:object):void
	self:TriggerEvent(self.EVENTS.onObjectAttached, attachedObject);
end

function AttachableParcel:OnDetached(detachedObject:object):void
	self:TriggerEvent(self.EVENTS.onObjectDetached, detachedObject);
end

function AttachableParcel:OnObjectDeleted(deletedObject:object):void
	self:TriggerEvent(self.EVENTS.onObjectDeleted, deletedObject);
	self.isComplete = true;
end