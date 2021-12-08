-- object mp_weapon_placement_base
--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_item_placement.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_placement.lua');
REQUIRES('globals\scripts\global_multiplayer_init.lua');

-- This structure is designed to act as an abstract base class and should never be instantiated. mp_weapon_placement and mp_weapon_placement_full derive from this.

hstructure mp_weapon_placement_base
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
	weaponContainer:object
	weaponObject:object
	weaponTable:table
	updateSeconds:number
	symmetricalChannelId:string
	factionFiltersBooleans:table
	isInvisible:boolean
	previewAsHologram:boolean
	itemShouldRotate:boolean
	tierWeightOverrides:table
	pingMessaging:boolean
	plasmaForceModHorz:number	-- Multiplier to apply to the explosive force when knocking a weapon off the pad in the horizontal direction
	plasmaForceModVert:number	-- Multiplier to apply to the explosive force when knocking a weapon off the pad in the vertical direction

	-- Kit state
	mpWeaponPlacementInstance:table
	mpWeaponPlacementParcel:table

	-- Asset Tunables
	stockAnimDelay:number	-- The amount of time after the container begins to open to wait before actually spawning the weapon
	incomingDuration:number -- The amount of time to display an indication that a weapon is incoming before playing open animation
	
	-- Faber Scriptable Properties

	-- Weapon Selection
	weaponClass:string	-- set by derived classes
	weaponTier:string	-- set by derived classes

	weapon:string		-- will be assigned from derived structures

	legendary:string	--$$ METADATA {"prettyName": "Variants", "source": ["Exclude", "Include", "Preferred"], "tooltip": "Determines if legendary variants of weapons can spawn. Exclude = no (default), Include = yes, Preferred = always use if available", "groupName": "Weapon Selection" }	

	-- Base Properties
	navpoint:boolean --$$ METADATA {"prettyName": "Spawn Messaging", "tooltip": "Notify players of the Weapon's spawn with a navpoint", "groupName": "Base Properties" }
	spawnProperties:string --$$ METADATA {"prettyName": "Spawn Properties", "source": ["Default", "Custom"], "tooltip": "Default uses 343 spawn settings. Select Custom to enable the unique spawn properties below.", "groupName": "Base Properties" }
	staticSelection:string --$$ METADATA {"prettyName": "Static Selection", "source": ["Disabled (Default)", "Enabled"], "tooltip": "If enabled, always use the 'Static Weapon' entry if specified.", "groupName": "Base Properties" }

	-- Custom Spawn Props
	spawnLogic:string	--$$ METADATA {"prettyName": "Spawn Logic", "source": ["Dynamic (Pickup)", "Dynamic (Expired)", "Static (Time)", "External Trigger"], "tooltip": "Event that triggers the Weapon's spawn time", "groupName": "Custom Spawn Properties" }	
	spawnTime:number --$$ METADATA {"min": 0, "prettyName": "Spawn Time", "tooltip": "Number of seconds it takes for the Weapon to spawn", "groupName": "Custom Spawn Properties" }
	initialSpawnDelay:number --$$ METADATA {"prettyName": "Initial Spawn Delay", "tooltip": "Number of seconds before the first spawn", "groupName": "Custom Spawn Properties" }
	maxCount:number --$$ METADATA {"prettyName": "Max Deployed", "min": 0, "tooltip": "Block production of more Weapons than this number at any given time. Use zero for no limit.", "groupName": "Custom Spawn Properties" }

	randomize:string	 --$$ METADATA {"prettyName": "Select New Weapon", "source": ["Every Game (Default)", "Every Round", "Every Spawn"], "tooltip": "Frequency at which a new random Weapon is selected", "groupName": "Custom Spawn Properties" }
	faction:string --$$ METADATA {"prettyName": "Faction Limitation", "source": ["Any", "UNSC", "Forerunner", "Banished"], "tooltip": "Allow random Weapons from certain factions", "groupName": "Custom Spawn Properties" }		
	
	ammoModifier:string --$$ METADATA {"prettyName": "Ammo Multiplier", "source": ["25%", "50%", "100%", "150%", "200%", "300%", "Max"], "tooltip": "Amount of ammo the spawned Weapon will provide as a percentage of the default value. Values over 100% DO NOT apply to energy-based weapons.", "groupName": "Custom Spawn Properties" }

	-- Channels
	symmetricalChannel:string --$$ METADATA {"prettyName": "Symmetrical Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel and of the same type will spawn the same random Weapon", "groupName": "Channels" }
	selectiveChannel:string --$$ METADATA {"prettyName": "Selective Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel can be limited to spawn a percentage of the group's total in the Game Variant or be used for Managed Distribution. In BTB, Hotel, India and Juliet will use Managed Distribution by default.", "groupName": "Channels" }

	-- Weight Overrides
	overrideTierWeighting:boolean --$$ METADATA {"prettyName": "Override Tier Weights", "tooltip": "If 'Random' class is selected, use the weightings shown below instead of the global values to weight weapon tier", "groupName": "Weapon Tier Weighting Overrides (Optional)"}
	baseWeight:number --$$ METADATA {"min": 0, "prettyName": "Base Weighting", "groupName": "Weapon Tier Weighting Overrides (Optional)"}
	powerWeight:number --$$ METADATA {"min": 0, "prettyName": "Power Weighting", "groupName": "Weapon Tier Weighting Overrides (Optional)"}

	-- Effects
	incomingParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "forgeTagListId": "item_spawner_fx", "prettyName": "Incoming Visual FX", "tooltip": "Effect system to appear when spawner is in a restricted state", "groupName": "Effects" }
	altIncomingParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "forgeTagListId": "item_spawner_fx", "prettyName": "Alt Incoming Visual FX", "tooltip": "Alternate effect system to appear when spawner is in an incoming state", "groupName": "Effects" }
	spawnedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "forgeTagListId": "item_spawner_fx", "prettyName": "Spawned Visual FX", "tooltip": "Effect system to appear when spawner is active", "groupName": "Effects" }
	altSpawnedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "forgeTagListId": "item_spawner_fx", "prettyName": "Alt Spawned Visual FX", "tooltip": "Alternate effect system to appear when spawner is active", "groupName": "Effects" }
	restrictedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "forgeTagListId": "item_spawner_fx", "prettyName": "Restricted Visual FX", "tooltip": "Effect system to appear when spawner is in a restricted state", "groupName": "Effects" }

	-- Plasma Explosion Response
	plasmaExplosionDetach:boolean --$$ METADATA {"visible": true, "prettyName": "Plasma Explosion Detaches", "tooltip": "Plasma explosions will blow weapons off the container (pads/pods only)", "groupName": "Effects"}

	-- Broadcast Channels
	powerBroadcast:string --$$ METADATA {"prettyName": "Receive Power Broadcast", "tooltip": "Set Power Channel that spawner will listen to toggle itself on/off", "groupName": "Broadcast Channels"}
	controlBroadcast:string --$$ METADATA {"prettyName": "Receive Control Broadcast", "tooltip": "Set Control Channel that spawner will listen to custom spawn an item", "groupName": "Broadcast Channels"}

	-- Random Seeding
	seedSequenceKey:string	--$$ METADATA {"prettyName": "Seed Sequence Key", "source": ["GeneralPlacementKey", "WeaponRackPlacementKey", "WeaponTrunkPlacementKey", "PowerWeaponPadPlacementKey", "GrenadePadPlacementKey", "EquipmentPadPlacementKey", "PowerUpPadPlacementKey", "OrdnancePodPlacementKey", "VehiclePadPlacementKey", "VehicleDropPlacementKey"], "tooltip": "The key used to determine the random seed sequence that will be used for the spawner.", "groupName": "Random Seeding" }
		
	unsc:boolean
	forerunner:boolean
	banished:boolean
end

function mp_weapon_placement_base:AssignParcel():boolean
	self.mpWeaponPlacementParcel = _G["MPWeaponPlacement"];
	return self.mpWeaponPlacementParcel ~= nil;
end

function mp_weapon_placement_base:init()
	if (self.mpWeaponPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self:Initialize();
end

function mp_weapon_placement_base:Initialize():void		-- abstract
	print("mp_weapon_placement_base is an abstract base class and should never be instantiated");
end

function mp_weapon_placement_base:InitializeBase():void
	if (self.components.container == nil) then
		return;		-- don't spin up the parcel if no container object. this could be a badly made kit, or could have been turned off by another system, i.e. megalo labels
	end

	self.spawnProperties = self.spawnProperties or "Default";
	self.weaponClass = self.weaponClass or "Any";
	self.weaponTier = self.weaponTier or "Any";
	self.legendary = self.legendary or "Exclude";
	self.spawnLogic = self.spawnLogic or "Dynamic (Pickup)";
	self.randomize = self.randomize or "Every Game (Default)";
	self.incomingDuration = math.max(self.spawnTime - 1, 0);
	self.spawnTime = self.spawnTime or 30;
	self.symmetricalChannel = self.symmetricalChannel or "None";
	self.selectiveChannel = self.selectiveChannel or "None";
	self.stockAnimDelay = self.stockAnimDelay or 0;	-- How long we delay before spawning the weapon
	self.ammoModifier = self.ammoModifier or "100%";
	self.pingMessaging = true;
	self.plasmaForceModHorz = 7;	-- Tune the force that plasma grenades apply to weapons on Weapon Pads
	self.plasmaForceModVert = 9;
	self.seedSequenceKey = self.seedSequenceKey or "GeneralPlacementKey";
	self.staticSelection = self.staticSelection or "Disabled (Default)";

	if (self.isInvisible == nil) then
		self.isInvisible = false;
	end

	self:SetupFactionBooleans();
	self:SetupWeightingOverrides();

	self.symmetricalChannelId = self:GetSymmetricalChannelID();

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
	RegisterGlobalEvent(g_eventTypes.enteredBetweenRoundStateEvent, function(self) self.HandleRoundCleanup(self) end, self);
	RegisterGlobalEvent(GetFinalRoundCleanupEventType(), function(self) self.HandleRoundCleanup(self) end, self);
end

function mp_weapon_placement_base.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	if (self.mpWeaponPlacementInstance == nil) then
		self.StartPlacementParcel(self);
	end
end

function mp_weapon_placement_base.StartPlacementParcel(self):void
	self.mpWeaponPlacementInstance = self.mpWeaponPlacementParcel:NewWeaponPlacement(
		hmake MPWeaponPlacementInitArgs
		{
			instanceName = self.components.NAME,
			spawnProperties = self.spawnProperties,
			spawnLogic = self.spawnLogic,
			symmetricalChannel	= self.symmetricalChannel,
			symmetricalChannelId = self.symmetricalChannelId,
			selectiveChannel = self.selectiveChannel,
			initialSpawnDelay = self.initialSpawnDelay,
			respawnTime = self.spawnTime,
			respawnType = self.randomize,
			containerObject = self.components.container,
			isMessagingVisible = self.navpoint,
			pingMessaging = self.pingMessaging,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = self.maxCount,
			hasInvisibleDispenser = self.isInvisible,
			weaponClass = self.weaponClass,
			weaponTier = self.weaponTier,
			weapon = self.weapon,
			ammoModifier = self.ammoModifier,
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = self.tierWeightOverrides,
			incomingParticleFX = self.incomingParticleFX,
			altIncomingParticleFX = self.altIncomingParticleFX,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = self.restrictedParticleFX,
			previewAsHologram = self.previewAsHologram,
			itemShouldRotate = self.itemShouldRotate,
			plasmaExplosionDetach = self.plasmaExplosionDetach,
			plasmaForceModHorz = self.plasmaForceModHorz,
			plasmaForceModVert = self.plasmaForceModVert,
			broadcastChannelPower = self.powerBroadcast,
			broadcastChannelControl = self.controlBroadcast,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpWeaponPlacementInstance, self.mpWeaponPlacementInstance.parcelName);
end

function mp_weapon_placement_base.HandleRoundCleanup(self):void
	if (self.mpWeaponPlacementInstance == nil) then
		print("Error, attempting to end an MPWeaponPlacement parcel that was never started. Consider calling StartPlacementParcel() if round start was missed.");
		return;
	end

	if (self.mpWeaponPlacementInstance:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Game) then
		--print("saving weapon for next round");
		self.weapon = self.mpWeaponPlacementInstance:CurrentWeaponIdentifierAsString();
	end

	ParcelEnd(self.mpWeaponPlacementInstance);
	self.mpWeaponPlacementInstance = nil;
end

function mp_weapon_placement_base:SetupFactionBooleans():void
	if (self.faction == "UNSC") then
		self.unsc = true;	
	elseif (self.faction == "Forerunner") then
		self.forerunner = true;
	elseif (self.faction == "Banished") then
		self.banished = true;
	else
		self.unsc = true;
		self.forerunner = true;
		self.banished = true;
	end
	
	self.factionFiltersBooleans =
	{
		[MP_ITEM_FACTION.UNSC] = self.unsc or false,
		[MP_ITEM_FACTION.Forerunner] = self.forerunner or false,
		[MP_ITEM_FACTION.Banished] = self.banished or false,
		[MP_ITEM_FACTION.Covenant] = false,
	};
end

function mp_weapon_placement_base:SetupWeightingOverrides():void
	if (not self.overrideTierWeighting) then
		self.tierWeightOverrides = nil;
		return;
	end

	self.tierWeightOverrides =
	{
		[MP_WEAPON_TIER.Base] = self.baseWeight or 0,
		[MP_WEAPON_TIER.Power] = self.powerWeight or 0,
	};
end

function mp_weapon_placement_base:GetSymmetricalChannelID():string
	if (self.symmetricalChannel == nil or self.symmetricalChannel == "None") then
		return "None";
	end

	local id = tostring(self.symmetricalChannel) .. "_";
	
	-- Faction
	if (self.unsc) then
		id = id .. tostring(MP_ITEM_FACTION.UNSC) .. "_";
	end

	if (self.forerunner) then
		id = id .. tostring(MP_ITEM_FACTION.Forerunner) .. "_";
	end

	if (self.banished) then
		id = id .. tostring(MP_ITEM_FACTION.Banished) .. "_";
	end

	-- Tier
	if (self.weaponTier == "Base") then
		id = id .. tostring(MP_WEAPON_TIER.Base) .. "_";
	elseif (self.weaponTier == "Power") then
		id = id .. tostring(MP_WEAPON_TIER.Power) .. "_";
	end

	-- Weapon Class
	if (self.weaponClass == "Pistol") then
		id = id .. tostring(MP_WEAPON_CLASS.Pistol) .. "_";
	elseif (self.weaponClass == "Assault Rifle") then
		id = id .. tostring(MP_WEAPON_CLASS.AssaultRifle) .. "_";
	elseif (self.weaponClass == "Tactical Rifle") then
		id = id .. tostring(MP_WEAPON_CLASS.TacticalRifle) .. "_";
	elseif (self.weaponClass == "SMG") then
		id = id .. tostring(MP_WEAPON_CLASS.SMG) .. "_";
	elseif (self.weaponClass == "Shotgun") then
		id = id .. tostring(MP_WEAPON_CLASS.Shotgun) .. "_";
	elseif (self.weaponClass == "Sniper Rifle") then
		id = id .. tostring(MP_WEAPON_CLASS.SniperRifle) .. "_";
	elseif (self.weaponClass == "Launcher") then
		id = id .. tostring(MP_WEAPON_CLASS.Launcher) .. "_";
	elseif (self.weaponClass == "Melee") then
		id = id .. tostring(MP_WEAPON_CLASS.Melee) .. "_";
	elseif (self.weaponClass == "Anti-Vehicle") then
		id = id .. tostring(MP_WEAPON_CLASS.AntiVehicle) .. "_";
	end

	return id;

end