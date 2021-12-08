-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

--[[
--  __     __     ______     ______     ______   ______     __   __        ______     ______     _____     __   __     ______     __   __     ______     ______        ______     ______     ______     ______   ______    
-- /\ \  _ \ \   /\  ___\   /\  __ \   /\  == \ /\  __ \   /\ "-.\ \      /\  __ \   /\  == \   /\  __-.  /\ "-.\ \   /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\      /\  ___\   /\  == \   /\  __ \   /\__  _\ /\  ___\   
-- \ \ \/ ".\ \  \ \  __\   \ \  __ \  \ \  _-/ \ \ \/\ \  \ \ \-.  \     \ \ \/\ \  \ \  __<   \ \ \/\ \ \ \ \-.  \  \ \  __ \  \ \ \-.  \  \ \ \____  \ \  __\      \ \ \____  \ \  __<   \ \  __ \  \/_/\ \/ \ \  __\   
--  \ \__/".~\_\  \ \_____\  \ \_\ \_\  \ \_\    \ \_____\  \ \_\\"\_\     \ \_____\  \ \_\ \_\  \ \____-  \ \_\\"\_\  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\     \ \_____\  \ \_\ \_\  \ \_\ \_\    \ \_\  \ \_____\ 
--   \/_/   \/_/   \/_____/   \/_/\/_/   \/_/     \/_____/   \/_/ \/_/      \/_____/   \/_/ /_/   \/____/   \/_/ \/_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/      \/_____/   \/_/ /_/   \/_/\/_/     \/_/   \/_____/ 
--]]
                                                                                                                                                                                                                      


REQUIRES('scripts\ParcelLibrary\parcel_mp_item_ordnance_crate.lua');

--//////
-- Parcel Setup
--//////

global MPWeaponOrdnanceCrate:table = MPItemOrdnanceCrate:CreateSubclass();

MPWeaponOrdnanceCrate.instanceName = "MPWeaponOrdnanceCrate";

MPWeaponOrdnanceCrate.CONST.crateTag = TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\unsc_wo_weaponpod_a.device_machine');
MPWeaponOrdnanceCrate.CONST.crateMarkerName = "mkr_weapon";
MPWeaponOrdnanceCrate.CONST.cargoMarkerName = "weapon_pad_offset";

function MPWeaponOrdnanceCrate:RegisterForTrackingEvents():void	-- override
	self:RegisterEventOnSelf(g_eventTypes.weaponPickupEvent, self.HandleWeaponPickup, self.cargo);
	self:RegisterEventOnSelf(g_eventTypes.weaponPickupForAmmoRefillEvent, self.HandleWeaponPickupForAmmo, self.cargo);
	self:RegisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleWeaponGrappledEvent, self.cargo);

	self:RegisterForTrackingEventsBase();
end

function MPWeaponOrdnanceCrate:HandleWeaponPickup(eventArgs:WeaponPickupEventStruct):void
	self:ScheduleForDeletion();
end

function MPWeaponOrdnanceCrate:HandleWeaponPickupForAmmo(eventArgs:WeaponPickupForAmmoRefillEventStruct):void
	if (not eventArgs.weaponFullyPickedUp) then
		Object_Delete(self.cargo);
	end

	self:ScheduleForDeletion();
end

function MPWeaponOrdnanceCrate:HandleWeaponGrappledEvent(eventArgs:GrappleReelInItemInitiatedEventStruct):void
	self:ScheduleForDeletion();
end

