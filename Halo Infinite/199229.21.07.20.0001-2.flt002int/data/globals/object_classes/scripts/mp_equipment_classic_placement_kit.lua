-- object mp_equipment_classic_placement:mp_powerup_placement
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_powerup_placement_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_placement.lua');

hstructure mp_equipment_classic_placement:mp_powerup_placement
	dummy:boolean				-- need something in hstructure to derive
end

function mp_equipment_classic_placement:init()
	if (self.mpEquipmentPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	self:Initialize();
	self.isInvisible = true;
	self.previewAsHologram = false;
	self.pingMessaging = false;
end
