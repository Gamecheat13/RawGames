-- object mp_weapon_full_placement:mp_weapon_placement_base
--## SERVER
REQUIRES('globals\object_classes\scripts\mp_weapon_placement_base_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_placement.lua');

hstructure mp_weapon_full_placement:mp_weapon_placement_base
	-- Faber Scriptable Properties
		
	-- Weapon Selection
	weaponTierFull:string --$$ METADATA {"prettyName": "Tier", "source": ["Any", "Base", "Power"], "tooltip": "Tier that a random Weapon is selected from", "groupName": "Weapon Selection" }
	weaponClassFull:string --$$ METADATA {"prettyName": "Class", "source": ["Any", "Pistol", "Assault Rifle", "Tactical Rifle", "SMG", "Shotgun", "Sniper Rifle", "Launcher", "Melee"], "tooltip": "Class that a random Weapon is selected from", "groupName": "Weapon Selection" }
	weaponFull:string --$$ METADATA {"prettyName": "Static Weapon", "source": ["Random (Default)", "BR75", "Cindershot", "CQS48 Bulldog", "Disruptor", "Energy Sword", "Gravity Hammer", "Heatwave", "Hydra", "M41 SPNKr", "MA40 AR", "Mangler", "Mk50 Sidekick", "Needler", "Plasma Pistol", "Pulse Carbine", "Ravager", "S7 Sniper", "Sentinel Beam", "Shock Rifle", "Skewer", "Stalker Rifle", "VK78 Commando"], "tooltip": "Weapon to be spawned if static selection is enabled.", "groupName": "Weapon Selection" }

	-- Advanced Effects
	previewAsHologramFull:boolean --$$ METADATA {"visible": true, "prettyName": "Preview as Hologram", "tooltip": "If true, the weapon will render as a hologram in the incoming state", "groupName": "Effects" }
	itemShouldRotateFull:boolean --$$ METADATA {"visible": true, "prettyName": "Rotate Item", "tooltip": "If true, the weapon will slowly rotate on the pad", "groupName": "Effects" }
end

function mp_weapon_full_placement:init()
	if (self.mpWeaponPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self:Initialize();
end

function mp_weapon_full_placement:Initialize()	-- override
	self.weapon = self.weaponFull or "Random (Default)";
	self.weaponClass = self.weaponClassFull or "Any";
	self.weaponTier = self.weaponTierFull or "Any";

	self:InitializeBase();
	self.previewAsHologram = self.previewAsHologramFull;
	self.itemShouldRotate = self.itemShouldRotateFull;
end

