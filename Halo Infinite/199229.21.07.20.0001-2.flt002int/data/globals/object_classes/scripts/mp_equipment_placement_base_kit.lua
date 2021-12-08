-- object mp_equipment_placement_base
--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_placement.lua');
REQUIRES('globals\scripts\global_multiplayer_init.lua');

hstructure mp_equipment_placement_base
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
	equipmentContainer:object
	factionFiltersBooleans:table
	symmetricalChannelId:string
	isInvisible:boolean
	previewAsHologram:boolean
	classWeightOverrides:table
	pingMessaging:boolean

	-- Kit state
	mpEquipmentPlacementInstance:table
	mpEquipmentPlacementParcel:table
	
	-- Asset Tunables
	stockAnimDelay:number	-- The amount of time after the container begins to open to wait before actually spawning the weapon
	incomingDuration:number -- The amount of time to display an indication that a weapon is incoming before playing open animation

	-- Faber Scriptable Properties
		
	-- Equipment Selection
	equipmentType:string -- filled in from derived classes
	equipment:string	 -- filled in from derived classes

	legendary:string	--$$ METADATA {"prettyName": "Variants", "source": ["Exclude", "Include", "Preferred"], "tooltip": "Determines if legendary variants of equipment can spawn. Exclude = no (default), Include = yes, Preferred = always use if available", "groupName": "Equipment Selection" }	

	navpoint:boolean --$$ METADATA {"prettyName": "Spawn Messaging", "tooltip": "Notify players of the Equipment's spawn with a navpoint", "groupName": "Base Properties" }
	spawnProperties:string --$$ METADATA {"prettyName": "Spawn Properties", "source": ["Default", "Custom"], "tooltip": "Default uses 343 spawn settings. Select Custom to enable the unique spawn properties below.", "groupName": "Base Properties" }
	staticSelection:string --$$ METADATA {"prettyName": "Static Selection", "source": ["Disabled (Default)", "Enabled"], "tooltip": "If enabled, always use the 'Static Equipment' entry if specified.", "groupName": "Base Properties" }

	-- Spawning
	spawnLogic:string	--$$ METADATA {"prettyName": "Spawn Logic", "source": ["Dynamic (Pickup)", "Dynamic (Expired)", "Static (Time)", "External Trigger"], "tooltip": "Event that triggers the Equipment's spawn time", "groupName": "Custom Spawn Properties" }	
	spawnTime:number --$$ METADATA {"min": 5, "prettyName": "Spawn Time", "tooltip": "Number of seconds it takes for the Equipment to spawn", "groupName": "Custom Spawn Properties" }
	initialSpawnDelay:number --$$ METADATA {"prettyName": "Initial Spawn Delay", "tooltip": "Number of seconds before the first spawn", "groupName": "Custom Spawn Properties" }
	maxCount:number --$$ METADATA {"prettyName": "Max Deployed", "min": 0, "tooltip": "Block production of more Equipment than this number at any given time. Use zero for no limit.", "groupName": "Custom Spawn Properties" }

	randomize:string	 --$$ METADATA {"prettyName": "Select New Equipment", "source": ["Every Game (Default)", "Every Round", "Every Spawn"], "tooltip": "Frequency at which new random Equipment is selected", "groupName": "Custom Spawn Properties" }
	energyModifier:string --$$ METADATA {"prettyName": "Charge Multiplier", "source": ["50%", "100%", "150%", "Max"], "tooltip": "Amount of charges the spawned Equipment will provide as a percentage of the default value", "groupName": "Custom Spawn Properties" }

	-- Channels
	symmetricalChannel:string --$$ METADATA {"prettyName": "Symmetrical Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel and of the same type will spawn the same random Equipment", "groupName": "Channels" }
	selectiveChannel:string --$$ METADATA {"prettyName": "Selective Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel can be limited to spawn a percentage of the group's total in the Game Variant or be used for Managed Distribution. In BTB, Hotel, India and Juliet will use Managed Distribution by default.", "groupName": "Channels" }

	-- Effects
	incomingParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "prettyName": "Incoming Visual FX", "tooltip": "Effect system to appear when spawner is in an incoming state", "groupName": "Effects" }
	altIncomingParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "prettyName": "Alt Incoming Visual FX", "tooltip": "Alternate effect system to appear when spawner is in an incoming state", "groupName": "Effects" }
	spawnedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "prettyName": "Spawned Visual FX", "tooltip": "Effect system to appear when spawner is active", "groupName": "Effects" }
	altSpawnedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "prettyName": "Alt Spawned Visual FX", "tooltip": "Alternate effect system to appear when spawner is active", "groupName": "Effects" }
	restrictedParticleFX:tag --$$ METADATA {"visible": true, "allowedExtensions": [ "effect" ], "prettyName": "Restricted Visual FX", "tooltip": "Effect system to appear when spawner is in a restricted state", "groupName": "Effects" }

	-- Broadcast Channels
	powerBroadcast:string --$$ METADATA {"prettyName": "Receive Power Broadcast", "tooltip": "Set Power Channel that spawner will listen to toggle itself on/off", "groupName": "Broadcast Channels"}
	controlBroadcast:string --$$ METADATA {"prettyName": "Receive Control Broadcast", "tooltip": "Set Control Channel that spawner will listen to custom spawn an item", "groupName": "Broadcast Channels"}

	-- Random Seeding
	seedSequenceKey:string	--$$ METADATA {"prettyName": "Seed Sequence Key", "source": ["GeneralPlacementKey", "WeaponRackPlacementKey", "WeaponTrunkPlacementKey", "PowerWeaponPadPlacementKey", "GrenadePadPlacementKey", "EquipmentPadPlacementKey", "PowerUpPadPlacementKey", "OrdnancePodPlacementKey", "VehiclePadPlacementKey", "VehicleDropPlacementKey"], "tooltip": "The key used to determine the random seed sequence that will be used for the spawner.", "groupName": "Random Seeding" }
end

function mp_equipment_placement_base:AssignParcel():boolean
	self.mpEquipmentPlacementParcel = _G["MPEquipmentPlacement"];
	return self.mpEquipmentPlacementParcel ~= nil;
end

function mp_equipment_placement_base:Initialize():void		-- abstract
	debug_assert(false, "mp_equipment_placement_base is an abstract base class and should never be instantiated");
end

function mp_equipment_placement_base:InitializeBase():void
	if (self.components.spawner == nil) then
		return;		-- don't spin up the parcel if no container object. this could be a badly made kit, or could have been turned off by another system, i.e. megalo labels
	end

	self.spawnProperties = self.spawnProperties or "Default";
	self.spawnLogic = self.spawnLogic or "Dynamic (Pickup)";
	self.randomize = self.randomize or "Every Game (Default)";
	self.legendary = self.legendary or "Exclude";
	self.incomingDuration = math.max(self.spawnTime - 1, 0);
	self.spawnTime = self.spawnTime or 30;
	self.symmetricalChannel = self.symmetricalChannel or "None";
	self.selectiveChannel = self.selectiveChannel or "None";
	self.stockAnimDelay = self.stockAnimDelay or 0.25;
	self.energyModifier = self.energyModifier or "100%";
	self.pingMessaging = true;
	self.seedSequenceKey = self.seedSequenceKey or "GeneralPlacementKey";
	self.staticSelection = self.staticSelection or "Disabled (Default)";

	if (self.isInvisible == nil) then
		self.isInvisible = false;
	end

	self:SetupFactionBooleans();

	self.symmetricalChannelId = self:GetSymmetricalChannelID();

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
	RegisterGlobalEvent(g_eventTypes.enteredBetweenRoundStateEvent, function(self) self.HandleRoundCleanup(self) end, self);
	RegisterGlobalEvent(GetFinalRoundCleanupEventType(), function(self) self.HandleRoundCleanup(self) end, self);
end

function mp_equipment_placement_base.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	if (self.mpEquipmentPlacementInstance == nil) then
		self.StartPlacementParcel(self);
	end
end

function mp_equipment_placement_base.StartPlacementParcel(self):void
	self.mpEquipmentPlacementInstance = self.mpEquipmentPlacementParcel:NewEquipmentPlacement(
		hmake MPEquipmentPlacementInitArgs
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
			equipmentType = self.equipmentType,
			isMessagingVisible = self.navpoint,
			pingMessaging = self.pingMessaging,
			containerObject = self.components.spawner,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = self.maxCount,
			hasInvisibleDispenser = self.isInvisible,
			equipment = self.equipment,
			energyModifier = self.energyModifier,
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = self.classWeightOverrides,
			incomingParticleFX = self.incomingParticleFX,
			altIncomingParticleFX = self.altIncomingParticleFX,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = self.restrictedParticleFX,
			previewAsHologram = self.previewAsHologram,
			itemShouldRotate = true,
			broadcastChannelPower = self.powerBroadcast,
			broadcastChannelControl = self.controlBroadcast,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpEquipmentPlacementInstance, self.mpEquipmentPlacementInstance.parcelName);
end

function mp_equipment_placement_base.HandleRoundCleanup(self):void
	if (self.mpEquipmentPlacementInstance == nil) then
		print("Error, attempting to end an MPEquipmentPlacement parcel that was never started. Consider calling StartPlacementParcel() if round start was missed.");
		return;
	end

	if (self.mpEquipmentPlacementInstance:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Game) then
		--print("saving equipment for next round");
		self.equipment = self.mpEquipmentPlacementInstance:CurrentEquipmentIdentifierAsString();
	end

	ParcelEnd(self.mpEquipmentPlacementInstance);
	self.mpEquipmentPlacementInstance = nil;
end

function mp_equipment_placement_base:SetupFactionBooleans():void
	self.factionFiltersBooleans =
	{
		[MP_ITEM_FACTION.UNSC] = true,
		[MP_ITEM_FACTION.Forerunner] = false,
		[MP_ITEM_FACTION.Banished] = false,
		[MP_ITEM_FACTION.Covenant] = false,
	};
end

function mp_equipment_placement_base:GetSymmetricalChannelID():string
	if (self.symmetricalChannel == nil or self.symmetricalChannel == "None") then
		return "None";
	end

	local id = tostring(self.symmetricalChannel) .. "_";

	if (self.equipmentType == "Base") then
		id = id .. tostring(MP_EQUIPMENT_CLASS.Equipment) .. "_";
	elseif (self.equipmentType == "Power") then
		id = id .. tostring(MP_EQUIPMENT_CLASS.PowerUp) .. "_";
	end

	return id;
end	
