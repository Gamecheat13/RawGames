-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

--[[
-- ______     ______     __  __     __     ______   __    __     ______     __   __     ______      ______     ______     _____     __   __     ______     __   __     ______     ______        ______     ______     ______     ______   ______    
--/\  ___\   /\  __ \   /\ \/\ \   /\ \   /\  == \ /\ "-./  \   /\  ___\   /\ "-.\ \   /\__  _\    /\  __ \   /\  == \   /\  __-.  /\ "-.\ \   /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\      /\  ___\   /\  == \   /\  __ \   /\__  _\ /\  ___\   
--\ \  __\   \ \ \/\_\  \ \ \_\ \  \ \ \  \ \  _-/ \ \ \-./\ \  \ \  __\   \ \ \-.  \  \/_/\ \/    \ \ \/\ \  \ \  __<   \ \ \/\ \ \ \ \-.  \  \ \  __ \  \ \ \-.  \  \ \ \____  \ \  __\      \ \ \____  \ \  __<   \ \  __ \  \/_/\ \/ \ \  __\   
-- \ \_____\  \ \___\_\  \ \_____\  \ \_\  \ \_\    \ \_\ \ \_\  \ \_____\  \ \_\\"\_\    \ \_\     \ \_____\  \ \_\ \_\  \ \____-  \ \_\\"\_\  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\     \ \_____\  \ \_\ \_\  \ \_\ \_\    \ \_\  \ \_____\ 
--  \/_____/   \/___/_/   \/_____/   \/_/   \/_/     \/_/  \/_/   \/_____/   \/_/ \/_/     \/_/      \/_____/   \/_/ /_/   \/____/   \/_/ \/_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/      \/_____/   \/_/ /_/   \/_/\/_/     \/_/   \/_____/ 
--]]
                                                                                                                                                                                                                      


REQUIRES('scripts\ParcelLibrary\parcel_mp_item_ordnance_crate.lua');

--//////
-- Parcel Setup
--//////

global MPEquipmentOrdnanceCrate:table = MPItemOrdnanceCrate:CreateSubclass();

MPEquipmentOrdnanceCrate.instanceName = "MPEquipmentOrdnanceCrate";

-- These can change if there's an equipment specific crate to use in future
MPEquipmentOrdnanceCrate.CONST.crateTag = TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\unsc_wo_weaponpod_a.device_machine');
MPEquipmentOrdnanceCrate.CONST.crateMarkerName = "mkr_weapon";
MPEquipmentOrdnanceCrate.CONST.cargoMarkerName = "weapon_pad_offset";

function MPEquipmentOrdnanceCrate:RegisterForTrackingEvents():void	-- override
	self:RegisterEventOnSelf(g_eventTypes.objectFrameAttachmentAttachedEvent, self.HandleEquipmentAttachedEvent, self.cargo);
	self:RegisterEventOnSelf(g_eventTypes.objectFrameAttachmentReplenishedEvent, self.HandleEquipmentReplenishEvent, self.cargo);

	self:RegisterForTrackingEventsBase();
end

function MPEquipmentOrdnanceCrate:HandleEquipmentAttachedEvent(eventArgs:ObjectFrameAttachmentAttachedEventStruct):void
	self:ScheduleForDeletion();
end

function MPEquipmentOrdnanceCrate:HandleEquipmentReplenishEvent(eventArgs:ObjectFrameAttachmentReplenishedEventStruct):void
	self:ScheduleForDeletion();
end

