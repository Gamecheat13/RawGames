-- object primitive_switch_object_base_class : communication_object_base_class
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');
REQUIRES('scripts\ParcelLibrary\parcel_interactive.lua');

global SwitchBaseParcel:table = CommNodeBaseParcel:CreateParcelInstance();

-- Members
SwitchBaseParcel.subscribedToInteractEvents = false;
SwitchBaseParcel.interactObject = nil;
SwitchBaseParcel.interactCallbackFunc = nil;
SwitchBaseParcel.interactiveParcelInstance = nil;

-- Setters

function SwitchBaseParcel:SetInteractFunction(func:ifunction):void
	self.interactCallbackFunc = func;
end

function SwitchBaseParcel:SetInteractObjectFromMarker(interactMarkerName:string):void
	if stringIsNullOrEmpty(interactMarkerName) == false then
		local newInteractObject = Object_GetObjectAtMarker(self.managedObject, interactMarkerName);
		if newInteractObject == nil then
			self:DebugPrint("SwitchBaseParcel:SetinteractObject: No object found at marker (" .. interactMarkerName .. ") location. This object will not be interactible!");
		else           
			self:SetInteractObject(newInteractObject);
		end
	else
		self:DebugPrint("SwitchBaseParcel:SetinteractObject: interactMarkerName is null or empty.");
	end
end

function SwitchBaseParcel:SetInteractObject(newInteractObject:object):void
	if newInteractObject ~= nil then        
		if self.subscribedToInteractEvents == true then
			-- Need to unsubscribe from the previous object so we don't handle events from it
			self:UnsubscribeFromInteractEvents();
		end

		self.interactObject = newInteractObject;
	
		if self.interactiveParcelInstance ~= nil then
			self.interactiveParcelInstance:EndParcel();
			self.interactiveParcelInstance = nil;			
		end
		
		local interactiveParcel:table = InteractiveParcel:New(self.interactObject);
		if interactiveParcel ~= nil then
			self:StartChildParcel(interactiveParcel, interactiveParcel.instanceName);
			self.interactiveParcelInstance = interactiveParcel;
		end
	else
		self:DebugPrint("SwitchBaseParcel:SetInteractObject: newInteractObject is nil! Please make sure that this object is valid.");
	end
end

function SwitchBaseParcel:SetActionString(actionStringID:string):void
	if not self:HaveValidInteractObject() then
		self:DebugPrint("SwitchBaseParcel:SetActionString: The interact object is nil. Returning.");
		return;
	end

	self.interactiveParcelInstance:SetActionString(actionStringID);
end

function SwitchBaseParcel:SetDeviceAllowsHoldingSupportWeapons(allowsSupportWeapons:boolean):void
	if not self:HaveValidInteractObject() then
		self:DebugPrint("SwitchBaseParcel:SetDeviceAllowsHoldingSupportWeapons: The interact object is nil. Returning.");
		return;
	end

	self.interactiveParcelInstance:SetDeviceAllowsHoldingSupportWeapons(allowsSupportWeapons);
end

-- Class Functions

-- Destroys the interact object
function SwitchBaseParcel:DestroyInteractObject():void
	if self.interactObject ~= nil then	
		object_destroy(self.interactObject);
		self.interactObject = nil;
	end
end

-- Registers this object for interact events
function SwitchBaseParcel:SubscribeToInteractEvents():void
	if self:IsSubscribedToInteractEvents() then return; end
	if self.interactObject == nil then 
		self:DebugPrint("SwitchBaseParcel:SubscribeToInteractEvents: The interact object is nil! Please assign one via SetInteractObject(interactObject:object).");
		return;
	end
	if self.interactCallbackFunc == nil then
		self:DebugPrint("SwitchBaseParcel:SubscribeFromInteractEvents: No callback function set via SetInteractFunction or SetInteractObjectDeletedFunction. Ignoring.");
		return;
	end
	if self.interactiveParcelInstance == nil then
		self:DebugPrint("SwitchBaseParcel:SubscribeFromInteractEvents: No Interactive Parcel assigned. Ignoring.");
		return;
	end

	self.interactiveParcelInstance:AddOnInteractCallback(self, self.OnInteractInternal);
	self.interactiveParcelInstance:AddOnObjectDeletedCallback(self, self.OnInteractObjectDeletedInternal);
	self.subscribedToInteractEvents = true;
end

-- Unregisters this object from interact events
function SwitchBaseParcel:UnsubscribeFromInteractEvents():void
	if self.interactCallbackFunc == nil then
		self:DebugPrint("SwitchBaseParcel:UnsubscribeFromInteractEvents: No callback function set via SetInteractFunction or SetInteractObjectDeletedFunction. Ignoring.");
		return;
	end

	if self:IsSubscribedToInteractEvents() then
		if self.interactiveParcelInstance ~= nil then
			self.interactiveParcelInstance:RemoveOnInteractCallback(self, self.OnInteractInternal);
			self.interactiveParcelInstance:RemoveOnObjectDeletedCallback(self, self.OnInteractObjectDeletedInternal);
		end
	end

	self.subscribedToInteractEvents = false;
end

-- Callbacks

function SwitchBaseParcel:OnInteractInternal(eventArgs:InteractEventStruct):void
	if self.interactCallbackFunc ~= nil then
		self:interactCallbackFunc(eventArgs);
	end
end

function SwitchBaseParcel:OnInteractObjectDeletedInternal(deletedObject:object):void
	self:UnsubscribeFromInteractEvents();
end

-- Helpers

function SwitchBaseParcel:HaveValidInteractObject():boolean
	return object_index_valid(self.interactObject);
end

function SwitchBaseParcel:IsSubscribedToInteractEvents():boolean
	return self.subscribedToInteractEvents == true;
end