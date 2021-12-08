-- object mp_vehicle_classic_placement:mp_vehicle_placement
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_vehicle_placement_kit.lua');

hstructure mp_vehicle_classic_placement:mp_vehicle_placement
	dummy:boolean				-- need something in hstructure to derive
end

function mp_vehicle_classic_placement:init()
	if (self.mpVehiclePlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	self:Initialize();
	self.isInvisible = true;
	self.previewAsHologram = false;
	self.pingMessaging = false;
end
