-- object primitive_socket_object_base_class : primitive_switch_object_base_class
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\object_classes\scripts\primitives\primitive_switch_object_base_class.lua');
REQUIRES('scripts\ParcelLibrary\parcel_attachable.lua');

global SocketBaseParcel:table = SwitchBaseParcel:CreateParcelInstance();

hstructure SocketTeamFilterStruct
	canInsertObject:boolean;
	canRemoveObject:boolean;
end

-- Members

SocketBaseParcel.attachMarker = nil;
SocketBaseParcel.attachPointMarker = nil;
SocketBaseParcel.attachedObject = nil;
SocketBaseParcel.objectAttachedCallbackFunc = nil;
SocketBaseParcel.objectDetachedCallbackFunc = nil;
SocketBaseParcel.attachedObjectDeletedCallbackFunc = nil;
SocketBaseParcel.requiredTagsFilter = TagFilterClass:New();
SocketBaseParcel.requiredTeamFilter = {}
SocketBaseParcel.attachableParcelInstance = nil;

-- Setters

function SocketBaseParcel:SetAttachMarker(newAttachMarker:string):void
	if not stringIsNullOrEmpty(newAttachMarker) then
		self.attachMarker = newAttachMarker;
	else
		self:DebugPrint("SocketBaseParcel:SetAttachMarker: newAttachMarker is nil! Please make sure that this object is valid.");
	end
end

function SocketBaseParcel:SetAttachPointMarker(newAttachPointMarker:string):void
	if stringIsNullOrEmpty(newAttachPointMarker) == false then
		self.attachPointMarker = newAttachPointMarker;
	else
		self:DebugPrint("SocketBaseParcel:SetAttachPointMarker: newAttachPointMarker is nil! Please make sure that this object is valid.");
	end
end

function SocketBaseParcel:SetOnObjectAttachedFunction(func:ifunction):void
	self.objectAttachedCallbackFunc = func;
end

function SocketBaseParcel:SetOnObjectDetachedFunction(func:ifunction):void
	self.objectDetachedCallbackFunc = func;
end

function SocketBaseParcel:SetOnAttachedObjectDeletedFunction(func:ifunction):void
	self.attachedObjectDeletedCallbackFunc = func;
end

-- Class Functions

function SocketBaseParcel:AddRequiredCarriableTag(requiredCarriableTag:tag, requiredCarriableVariantId:string):void
	self.requiredTagsFilter:Add(requiredCarriableTag, requiredCarriableVariantId);
end

function SocketBaseParcel:AddRequiredTeamFilter(requiredTeam:mp_team_designator, canInsertObject:boolean, canRemoveObject:boolean):void
	if requiredTeam == nil then return; end;
	local data = hmake SocketTeamFilterStruct
	{
		canInsertObject = canInsertObject,
		canRemoveObject = canRemoveObject
	};

	self.requiredTeamFilter[requiredTeam] = data;
end

function SocketBaseParcel:InsertObject(someObject:object, optionalUnit:object):void	
	if self:CanInsertObject(someObject, optionalUnit) then
		local attachableParcel = AttachableParcel:New(someObject);

		attachableParcel:AddOnObjectAttachedCallback(self, self.OnAttachedInternal);
		attachableParcel:AddOnObjectDetachedCallback(self, self.OnDetachedInternal);
		attachableParcel:AddOnObjectDeletedCallback(self, self.OnObjectDeletedInternal);

		attachableParcel:Attach(self.managedObject, self.attachMarker, self.attachPointMarker);

		self:StartChildParcel(attachableParcel, attachableParcel.instanceName);
		
		self.attachableParcelInstance = attachableParcel;
		self.attachedObject = someObject;
	else
		self:DebugPrint("SocketBaseParcel:InsertObject: Could not insert object.");
		self:DebugPrint("SocketBaseParcel:InsertObject: Make sure that there's no attached object and that the inserted object matches the filters.");
	end
end

function SocketBaseParcel:RemoveObject(optionalUnitToGiveTo:object):void	
	if self:CanRemoveObject(optionalUnitToGiveTo) then
		local oldAttachedObject = self.attachedObject;

		Object_Filter_RemoveAllFilters(oldAttachedObject);

		self.attachableParcelInstance:Detach();

		if optionalUnitToGiveTo ~= nil then
			if (not (Unit_GiveWeapon(optionalUnitToGiveTo, oldAttachedObject, WEAPON_ADDITION_METHOD.PrimaryWeapon) or
					Unit_GiveWeapon(optionalUnitToGiveTo, oldAttachedObject, WEAPON_ADDITION_METHOD.SwapForPrimaryWeapon))) then
				ObjectTeleportToObjectOffset(oldAttachedObject, optionalUnitToGiveTo, vector(0.18, 0, 0.3));
			end
		end
	end
end

-- Checks if the player can interact based on the state of this object and the player
function SocketBaseParcel:DoesObjectMatchTagFilter(someObject:object):boolean
	if not self:HaveTagRestrictions() then
		return true;
	end

	return self.requiredTagsFilter:Matches(someObject);
end

-- Helpers

function SocketBaseParcel:HaveTagRestrictions():boolean
	return self.requiredTagsFilter:GetCount() > 0;
end

function SocketBaseParcel:HasAttachedObject():boolean
	return object_index_valid(self.attachedObject);
end

function SocketBaseParcel:CanInsertObject(someObject:object, optionalUnit:object):boolean
	if not object_index_valid(someObject) then
		return false;
	end
	
	-- First check the team filter if we were supplied a unit; if the unit doesn't pass the team check then early out with false
	if optionalUnit ~= nil then
		local data:SocketTeamFilterStruct = self.requiredTeamFilter[Object_GetTeamDesignator(optionalUnit)];
		if (data ~= nil) and (not data.canInsertObject) then 
			return false;
		end
	end
	return not self:HasAttachedObject() and self:DoesObjectMatchTagFilter(someObject);
end

function SocketBaseParcel:CanRemoveObject(optionalUnit:object):boolean
	-- First check the team filter if we were supplied a unit; if the unit doesn't pass the team check then early out with false
	if optionalUnit ~= nil then
		local data:SocketTeamFilterStruct = self.requiredTeamFilter[Object_GetTeamDesignator(optionalUnit)];
		if (data ~= nil) and (not data.canRemoveObject) then 
			return false;
		end
	end
	return self:HasAttachedObject();
end

-- Class Functions: Private

-- Internal Event Callbacks

function SocketBaseParcel:OnAttachedInternal(attachedObject:object):void
	self.attachedObject = attachedObject;
	-- If we have an assigned callback, call it
	if self.objectAttachedCallbackFunc ~= nil then
		self:objectAttachedCallbackFunc(attachedObject);
	end
end

function SocketBaseParcel:OnDetachedInternal(detachedObject:object):void	
	if self.objectDetachedCallbackFunc ~= nil then
		self:objectDetachedCallbackFunc(detachedObject);
	end

	self:EndChildParcel(self.attachableParcelInstance);

	self.attachableParcelInstance = nil;
	self.attachedObject = nil;
end

function SocketBaseParcel:OnObjectDeletedInternal(deletedObject:object):void
	if self.attachedObjectDeletedCallbackFunc ~= nil then
		self:attachedObjectDeletedCallbackFunc(deletedObject);
	end

	self:EndChildParcel(self.attachableParcelInstance);

	self.attachableParcelInstance = nil;
	self.attachedObject = nil;
end