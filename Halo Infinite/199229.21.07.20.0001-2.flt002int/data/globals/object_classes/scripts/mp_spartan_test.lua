-- object mp_spartan_test

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER


hstructure mp_spartan_test
	meta:table
	instance:luserdata
	regenFieldObject:object
end

global g_mpSpartanConstants = table.makePermanent
{
	
}

-- Global variables to store equipment overrides
global overrideEquipmentPickup = false;
global overrideEquipmentType = nil;
global overridePowerEquipmentPickup = false;
global overridePowerEquipmentType = nil;

function mp_spartan_test:init() : void 
	if g_suppressionVariables.descopeSuppressionEnabled == true then
		RegisterSuppressionSystemEventsForObject(self);
	end

	self.regenFieldObject = nil;

	if overrideEquipmentPickup or overridePowerEquipmentPickup then
		RegisterGlobalEvent(g_eventTypes.equipmentPickupEvent, self.OnEquipmentPickedUp, self);
	end
end

function mp_spartan_test:GetIsAffectedByOtherRegenField(ownerObj:object):boolean
	if(self.regenFieldObject == nil or self.regenFieldObject == ownerObj) then
		return false;
	else
		return true;
	end
end

function mp_spartan_test:SetAffectedByRegenField(state:boolean, ownerObj:object):void
	self.regenFieldObject = ownerObj;
end

function mp_spartan_test.OnEquipmentPickedUp(eventArgs:EquipmentPickupEventStruct, self):void
	if Unit_GetPlayer(self) == eventArgs.player then

		if Object_GetDefinition(eventArgs.equipment) ~= TAG(nil) then
			CreateThread(self.OverrideEquipment, self);
		end
	end
end

function mp_spartan_test:OverrideEquipment():void
	-- Wait for the equipment to equip properly before we attempt to override it
	SleepSeconds(0.5);

	local equipmentDef = ObjectGetFrameAttachmentImplementationInSlot(self, 0);
	local equipmentToSwap = nil;
	local equipmentIsPowerup = false;

	if equipmentDef == TAG('objects\equipment\unsc\active_camo\active_camo.equipment') or equipmentDef == TAG('objects\equipment\unsc\overshield\overshield.equipment') then
		equipmentIsPowerup = true;
	end

	if overridePowerEquipmentPickup and equipmentIsPowerup then
		equipmentToSwap = overridePowerEquipmentType;
	elseif overrideEquipmentPickup and not equipmentIsPowerup then
		equipmentToSwap = overrideEquipmentType;
	else
		return;
	end

	-- Set the energy to 0 to clear out the slot, otherwise we would have to disable this equipment first and it would pop out a pickup, which we do not want
	ObjectSetFrameAttachmentImplementationEnergyInSlot(self, 0, 0);

	Sleep(1);

	-- Enable the override equipment
	PlayerFrameAttachmentEnable(self, equipmentToSwap, 0, true);
end

function SetOverrideEquipment (equipmentName):void
	print("Equipment Is Overriding");
	
	if equipmentName == nil then
		return;
	end

	-- We have to kill all players so the global event registers on respawn and detects the equipment swapping
	if overrideEquipmentPickup == false and overridePowerEquipmentPickup == false then
		Engine_KillAllPlayers();
	end

	overrideEquipmentPickup = true;
	overrideEquipmentType = equipmentName;
end

function SetOverridePowerEquipment (equipmentName):void
	print("Power Equipment Is Overriding");
	
	if equipmentName == nil then
		return;
	end

	-- We have to kill all players so the global event registers on respawn and detects the equipment swapping
	if overrideEquipmentPickup == false and overridePowerEquipmentPickup == false then
		Engine_KillAllPlayers();
	end

	overridePowerEquipmentPickup = true;
	overridePowerEquipmentType = equipmentName;
end

function ClearOverrideEquipment():void
	overrideEquipmentPickup = false;
	overrideEquipmentPickup = false;
	overrideEquipmentType = nil;
	overridePowerEquipmentType = nil;
end
