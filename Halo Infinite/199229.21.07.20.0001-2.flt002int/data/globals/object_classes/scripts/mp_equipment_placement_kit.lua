-- object mp_equipment_placement:mp_equipment_placement_base
--## SERVER
REQUIRES('globals\object_classes\scripts\mp_equipment_placement_base_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_placement.lua');

hstructure mp_equipment_placement:mp_equipment_placement_base
	-- Equipment Selection
	equipmentPartial:string --$$ METADATA {"prettyName": "Static Equipment", "source": ["Random (Default)", "Drop Wall", "Grappleshot", "Repulsor", "Threat Sensor", "Thruster"], "tooltip": "Equipment to be spawned if static selection is enabled.", "groupName": "Equipment Selection" }
end

function mp_equipment_placement:init()
	if (self.mpEquipmentPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self:Initialize();
end

function mp_equipment_placement:Initialize()	-- override
	self.equipmentType = "Base";
	self.equipment = self.equipmentPartial or "Random (Default)";

	self:InitializeBase();
	self.previewAsHologram = false;
end
