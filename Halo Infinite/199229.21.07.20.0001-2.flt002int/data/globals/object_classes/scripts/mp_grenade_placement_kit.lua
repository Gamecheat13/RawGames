-- object mp_grenade_placement:mp_grenade_placement_base
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_grenade_placement_base_kit.lua');

hstructure mp_grenade_placement:mp_grenade_placement_base

	-- Grenade Selection
	groupCountString:string --$$ METADATA {"prettyName": "Grenade Quantity", "source": ["1", "2"], "tooltip": "Total number of Grenades to spawn", "groupName": "Grenade Selection" }
	
	-- Spawning
	spawnCyclically:boolean --$$ METADATA {"prettyName": "Spawn Cyclically", "tooltip": "Enable to spawn one Grenade each interval. Disable to spawn all Grenades at once.", "groupName": "Custom Spawn Properties" }
end

function mp_grenade_placement:init()
	if (self.mpGrenadePlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	self.isInvisible = false;
	self.groupCountStringBase = self.groupCountString;
	self.spawnCyclicallyBase = self.spawnCyclically;
	self:Initialize();
end
