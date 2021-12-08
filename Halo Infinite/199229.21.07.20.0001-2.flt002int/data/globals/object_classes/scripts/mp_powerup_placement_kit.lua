-- object mp_powerup_placement:mp_equipment_placement_base
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_equipment_placement_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_placement.lua');

hstructure mp_powerup_placement:mp_equipment_placement_base
	-- Faber Scriptable Properties

	-- Power Up Selection
	equipmentTypeFull:string --$$ METADATA {"prettyName": "Tier", "source": ["Any", "Base", "Power"], "tooltip": "Equipment type that can be spawned when selecting random equipment.", "groupName": "Equipment Selection" }
	equipmentFull:string --$$ METADATA {"prettyName": "Static Equipment", "source": ["Random (Default)", "Active Camouflage", "Drop Wall", "Grappleshot", "Overshield", "Repulsor", "Threat Sensor", "Thruster"], "tooltip": "Equipment to be spawned if static selection is enabled.", "groupName": "Equipment Selection" }
	
	-- Weight Overrides
	overrideClassWeighting:boolean --$$ METADATA {"prettyName": "Override Class Weights", "tooltip": "If 'Random' class is selected, use the weightings shown below instead of the global values to weight equipment type", "groupName": "Equipment Tier Weighting Overrides (Optional)"}
	equipmentWeight:number --$$ METADATA {"min": 0, "prettyName": "Base Weighting", "groupName": "Equipment Tier Weighting Overrides (Optional)"}
	powerupWeight:number --$$ METADATA {"min": 0, "prettyName": "Power Weighting", "groupName": "Equipment Tier Weighting Overrides (Optional)"}
end

function mp_powerup_placement:init()
	if (self.mpEquipmentPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self:Initialize();
end

function mp_powerup_placement:Initialize():void		-- override
	self.equipmentType = self.equipmentTypeFull or "Any";
	self.equipment = self.equipmentFull or "Random (Default)";

	self:SetupWeightingOverrides();

	self:InitializeBase();

	self.previewAsHologram = true;
end

function mp_powerup_placement.SetupWeightingOverrides(self):void
	if (not self.overrideClassWeighting) then
		self.classWeightOverrides = nil;
		return;
	end

	self.classWeightOverrides =
	{
		[MP_EQUIPMENT_CLASS.Grenade] = 0,
		[MP_EQUIPMENT_CLASS.Equipment] = self.equipmentWeight or 0,
		[MP_EQUIPMENT_CLASS.PowerUp] = self.powerupWeight or 0,
	};
end
