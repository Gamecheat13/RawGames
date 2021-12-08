-- object mp_weapon_placement:mp_weapon_placement_base
--## SERVER
REQUIRES('globals\object_classes\scripts\mp_weapon_placement_base_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_placement.lua');

hstructure mp_weapon_placement:mp_weapon_placement_base
	-- Faber Scriptable Properties - Weapon Selection
	weaponClassPartial:string --$$ METADATA {"prettyName": "Class", "source": ["Any", "Pistol", "Assault Rifle", "Tactical Rifle", "SMG", "Shotgun", "Sniper Rifle", "Launcher"], "tooltip": "Class that a random Weapon is selected from", "groupName": "Weapon Selection" }
	weaponPartial:string --$$ METADATA {"prettyName": "Static Weapon", "source": ["Random (Default)", "BR75", "CQS48 Bulldog", "Disruptor", "Heatwave", "Hydra", "MA40 AR", "Mangler", "Mk50 Sidekick", "Needler", "Plasma Pistol", "Pulse Carbine", "Ravager", "Sentinel Beam", "Shock Rifle", "Stalker Rifle", "VK78 Commando"], "tooltip": "Weapon to be spawned if static selection is enabled.", "groupName": "Weapon Selection" }
end

function mp_weapon_placement:init()
	if (self.mpWeaponPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self:Initialize();
end

function mp_weapon_placement:Initialize()	-- override
	self.weapon = self.weaponPartial or "Random (Default)";
	self.weaponClass = self.weaponClassPartial or "Any";
	self.weaponTier = "Base";

	self:InitializeBase();
	self.previewAsHologram = false;
	self.itemShouldRotate = false;
end
