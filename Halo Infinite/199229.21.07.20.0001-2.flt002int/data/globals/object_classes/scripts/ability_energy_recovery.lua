-- object ability_energy_recovery

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
hstructure ability_energy_recovery
	meta:table
	instance:luserdata
end

global g_energyRecoveryConst = table.makePermanent
{
	fullEnergy = 1,
	halfEnergy = 0.5,
	thirdEnergy = 0.33333,
	quarterEnergy = 0.25,
	range = 0.4
}

function ability_energy_recovery:init() : void
	CreateObjectThread(self, self.CustomInitThread, self);
end

function ability_energy_recovery:CustomInitThread():void
	HealthPackPickedUp(self)
end

function HealthPackPickedUp(self)
	local myCenter:location = location(self, "")
	local childObjList:object_list = nil;
	while object_index_valid(self) do
		local objectsNearby:object_list = Object_GetObjectsInSphere(myCenter, g_energyRecoveryConst.range);
		local playerDetected:boolean = false;
		for _, detectedObj in hpairs(objectsNearby) do
			if Object_IsPlayer(detectedObj) then 
				playerDetected = true;
				local detectedPlayer:player = Player_GetUnit(detectedObj)

				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_plasma_grenade\ability_plasma_grenade_chief.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_frag_grenade\ability_frag_grenade_chief.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_spike_grenade\ability_spike_grenade_chief.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end
				
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_lightning_grenade\ability_lightning_grenade_chief.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				-- Getting the base nades in for DoP test
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_plasma_grenade\ability_plasma_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_frag_grenade\ability_frag_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_spike_grenade\ability_spike_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end
				
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_lightning_grenade\ability_lightning_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end
				
				-- Sapper totem
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_sapper_grenade\ability_sapper_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				-- loc sensor
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_loc_sensor_grenade\ability_loc_sensor_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				-- knockback
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_knockback_consumable\ability_knockback_consumable.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				-- Demo Charge
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\attachment_abilities\ability_explosive_charge\ability_explosive_charge_grenade.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end

				-- Stasis field grenade
				childObjList = object_list_children(detectedObj, TAG('objects\armor\attachments\proto_abilities\proto_equipment_stasis_grenade_mp\equipment_stasis_field_mp.equipment'))
				for _, childObj in hpairs(childObjList) do
					CreateThread(SetEquipmentEnergy, self, detectedPlayer, Equipment_GetInventoryIndex(childObj), g_energyRecoveryConst.halfEnergy);
				end
			end
		end
		Sleep(5)
	end	
end

function SetEquipmentEnergy(self, playerObj, equipIndex, energyAmount)
	local curEnergy:number = Unit_GetEquipmentEnergyFraction(playerObj, equipIndex);
	
	if curEnergy < 1 then
		-- Adding this here because we get weird leftover floating values when using up the grenades that then stack when you pick up again, so you could eventually have an extra charge without ever picking one up
		if(curEnergy < 0.1) then
			curEnergy = 0;
		end
		
		if curEnergy ~= nil then
			Unit_SetEquipmentEnergyFraction(playerObj, equipIndex, curEnergy + energyAmount);
		end
		object_destroy(self);
	end
end

--## CLIENT
