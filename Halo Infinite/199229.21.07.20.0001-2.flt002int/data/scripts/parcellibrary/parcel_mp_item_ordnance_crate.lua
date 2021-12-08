-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

-- MPItemOrdnanceCrate serves as an abstract base class for MPWeaponOrdnanceCrate and MPEquipmentOrdnanceCrate

REQUIRES('globals\scripts\global_hstructs.lua');

--//////
-- Parcel Setup
--//////

global MPItemOrdnanceCrate:table = Parcel.MakeParcel
{
	instanceName = "MPItemOrdnanceCrate",

	canStart = false,
	complete = false,

	cargo = nil,
	crate = nil,
	hideInCrate = false,

	deletionDelay = 3, 

	CONFIG = 
	{
	},

	CONST =
	{
		damageToOpen = 100000,
	},

	EVENTS =
	{
		onCrateDeleted = "OnCrateDeleted",
		onCrateCargoImmediatePickup = "OnCrateCargoImmediatePickup",
	},
}

function MPItemOrdnanceCrate:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function MPItemOrdnanceCrate:AddOnCrateDeleted(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onCrateDeleted, callbackFunc, callbackOwner);
end

function MPItemOrdnanceCrate:RemoveOnCrateDeleted(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onCrateDeleted, callbackFunc, callbackOwner);
end

function MPItemOrdnanceCrate:AddOnCrateCargoImmediatePickup(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onCrateCargoImmediatePickup, callbackFunc, callbackOwner);
end

function MPItemOrdnanceCrate:RemoveOnCrateCargoImmediatePickup(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onCrateCargoImmediatePickup, callbackFunc, callbackOwner);
end

function MPItemOrdnanceCrate:SleepUntilValid():void
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function MPItemOrdnanceCrate:IsComplete():boolean
	return self.complete;
end

function MPItemOrdnanceCrate:shouldEnd():boolean
	return self:IsComplete();
end

function MPItemOrdnanceCrate:EndShutdown():void
	if (self.crate ~= nil) then
		Object_Delete(self.crate);
	end
end

function MPItemOrdnanceCrate:Run():void
	self:SleepUntilValid();
end

function MPItemOrdnanceCrate:NewCrateParcel(initArgs:MPOrdnanceDropInitArgs):table
	local newCrate = self:CreateParcelInstance();

	if (initArgs ~= nil) then
		newCrate.deletionDelay = initArgs.deletionDelay;
	end

	return newCrate;
end

function MPItemOrdnanceCrate:CreateCargo(itemTag:tag, configTag:tag, scale:number, hideInCrate:boolean):object
	self.hideInCrate = hideInCrate or false;
	self.cargo = Object_CreateFromTagWithConfiguration(itemTag, configTag);
	Object_SetScale(self.cargo, scale, 0);

	if (self.cargo ~= nil) then
		Object_RegisterForCandyMonitorGarbageCollection(self.cargo);
		self.crate = Object_CreateFromTag(self.CONST.crateTag);

		if (self.crate ~= nil) then
			Item_SetRetainScaleOnHierarchyChange(self.cargo, true);
			Object_AttachScaledObjectToMarker(self.crate, self.CONST.crateMarkerName, self.cargo, self.CONST.cargoMarkerName);
			Item_SetRetainScaleOnHierarchyChange(self.cargo, false);

			self:RegisterForTrackingEvents();
		else
			debug_assert(false, "Unable to create item drop crate");
			object_destroy(self.cargo);
			self.cargo = nil;
		end
	end

	if (self.hideInCrate) then
		self:HideCargo(true);
	end

	return self.cargo;
end

function MPItemOrdnanceCrate:RegisterForTrackingEvents():void	-- abstract
	debug_assert(false, "MPItemOrdnanceCrate is an abstract base class and should not be instantiated");
end

function MPItemOrdnanceCrate:RegisterForTrackingEventsBase():void
	self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.HandleItemDeletedEvent, self.cargo);
end

function MPItemOrdnanceCrate:HideCargo(hide:boolean):void
	if (self.cargo ~= nil) then
		object_hide(self.cargo, hide);
	end
end

function MPItemOrdnanceCrate:Destroy():void
	if (self.hideInCrate) then
		if (object_index_valid(self.cargo)) then
			self:HideCargo(false);
		else
			-- crate must have dropped on us and triggered an immediate refill from item
			self:TriggerEvent(self.EVENTS.onCrateCargoImmediatePickup, self);
		end
	end

	if (self.crate ~= nil) then
		damage_object(self.crate, "default", self.CONST.damageToOpen);
		MPLuaCall("__OnWeaponPodOpen", self.cargo);
	end
end

function MPItemOrdnanceCrate:GetCargo():object
	return self.cargo;
end

function MPItemOrdnanceCrate:GetCrate():object
	return self.crate;
end

function MPItemOrdnanceCrate:HandleItemDeletedEvent(eventArgs:ObjectDeletedStruct):void
	self:ScheduleForDeletion();
end

function MPItemOrdnanceCrate:ScheduleForDeletion():void
	if (self.deleteThread == nil) then
		self.deleteThread = self:CreateThread(self.DeleteCrate);
	end
end

function MPItemOrdnanceCrate:DeleteCrate():void
	SleepSeconds(self.deletionDelay);
	self:TriggerEvent(self.EVENTS.onCrateDeleted, self);
	self.complete = true;
end

