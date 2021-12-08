-- object mp_vehicle_placement
--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_vehicle_placement.lua');
REQUIRES('globals\scripts\global_multiplayer_init.lua');

hstructure mp_vehicle_placement
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
	terrainFiltersBooleans:table
	factionFiltersBooleans:table
	symmetricalChannelId:string
	classWeightOverrides:table
	isInvisible:boolean
	previewAsHologram:boolean
	pingMessaging:boolean

	-- Kit state
	mpVehiclePlacementInstance:table
	mpVehiclePlacementParcel:table

	-- Asset Tunables
	stockAnimDelay:number	-- The amount of time after the container begins to open to wait before actually spawning the weapon
	incomingDuration:number -- The amount of time to display an indication that a weapon is incoming before playing open animation

	-- Faber Scriptable Properties	

	-- Vehicle Selection
	vehicleClass:string	--$$ METADATA {"prettyName": "Class", "source": ["Any", "Support", "Duelist", "Cavalry", "Siege"], "tooltip": "The class of vehicle to spawn if randomly selecting.", "groupName": "Vehicle Selection" }
	terrainType:string --$$ METADATA {"prettyName": "Terrain Type", "source": ["Any", "Land", "Air"], "tooltip": "Allowed terrain type of the random Vehicle", "groupName": "Vehicle Selection" }
	vehicle:string --$$ METADATA {"prettyName": "Static Vehicle", "source": ["Random (Default)", "Banshee", "Chopper", "Ghost", "Gungoose", "Mongoose", "Razorback", "Rockethog", "Scorpion", "Warthog", "Wasp", "Wraith"], "tooltip": "Vehicle to be spawned if static selection is enabled.", "groupName": "Vehicle Selection" }
	legendary:string	--$$ METADATA {"prettyName": "Variants", "source": ["Exclude", "Include", "Preferred"], "tooltip": "Determines if legendary variants of vehicles can spawn. Exclude = no (default), Include = yes, Preferred = always use if available", "groupName": "Vehicle Selection" }	

	navpoint:boolean --$$ METADATA {"prettyName": "Spawn Messaging", "tooltip": "Enable navpoints for when the Vehicle spawns", "groupName": "Base Properties" }
	spawnProperties:string --$$ METADATA {"prettyName": "Spawn Properties", "source": ["Default", "Custom"], "tooltip": "Default uses 343 spawn settings. Select Custom to enable the unique spawn properties below.", "groupName": "Base Properties" }
	staticSelection:string --$$ METADATA {"prettyName": "Static Selection", "source": ["Disabled (Default)", "Enabled"], "tooltip": "If enabled, always use the 'Static Weapon' entry if specified.", "groupName": "Base Properties" }

	-- Spawning
	spawnLogic:string	--$$ METADATA {"prettyName": "Spawn Logic", "source": ["Dynamic (Pickup)", "Dynamic (Expired)", "Static (Time)", "External Trigger"], "tooltip": "Event that triggers the Vehicle's spawn time", "groupName": "Custom Spawn Properties" }	
	spawnTime:number --$$ METADATA {"min": 5, "prettyName": "Spawn Time", "tooltip": "Number of seconds it takes for the Vehicle to spawn", "groupName": "Custom Spawn Properties" }
	initialSpawnDelay:number --$$ METADATA {"prettyName": "Initial Spawn Delay", "tooltip": "Number of seconds before the first spawn", "groupName": "Custom Spawn Properties" }
	maxCount:number --$$ METADATA { "min": 0, "prettyName": "Max Deployed", "tooltip": "Block production of more Weapons than this number at any given time. Use zero for no limit.", "groupName": "Custom Spawn Properties" }

	randomize:string	 --$$ METADATA {"prettyName": "Select New Vehicle", "source": ["Every Game (Default)", "Every Round", "Every Spawn"], "tooltip": "Frequency at which a new random Vehicle is selected", "groupName": "Custom Spawn Properties" }
	faction:string --$$ METADATA {"prettyName": "Faction Limitation", "source": ["Any", "UNSC", "Banished"], "tooltip": "Allow random Vehicles from certain factions", "groupName": "Custom Spawn Properties" }

	-- Channels
	symmetricalChannel:string --$$ METADATA {"prettyName": "Symmetrical Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel and of the same type will spawn the same random Vehicle", "groupName": "Channels" }
	selectiveChannel:string --$$ METADATA {"prettyName": "Selective Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel can be limited to spawn a percentage of the group's total in the Game Variant or be used for Managed Distribution.", "groupName": "Channels" }

	-- Weight Overrides
	overrideClassWeighting:boolean --$$ METADATA {"prettyName": "Override Class Weights", "tooltip": "If 'Random' class is selected, use the weightings shown below instead of the global values to weight vehicle class", "groupName": "Vehicle Class Weighting Overrides (Optional)" }
	supportWeight:number --$$ METADATA {"min": 0, "prettyName": "Support Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	duelistWeight:number --$$ METADATA {"min": 0, "prettyName": "Duelist Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	cavalryWeight:number --$$ METADATA {"min": 0, "prettyName": "Cavalry Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	siegeWeight:number --$$ METADATA {"min": 0, "prettyName": "Siege Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}

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
	
	land:boolean
	air:boolean

	unsc:boolean
	banished:boolean
end

function mp_vehicle_placement:init()
	self:Initialize();
end

function mp_vehicle_placement:Initialize():void
	if (self.components.spawner == nil) then
		return;		-- don't spin up the parcel if no container object. this could be a badly made kit, or could have been turned off by another system, i.e. megalo labels
	end

	if (self.mpVehiclePlacementParcel ~= nil) then
		return;
	end

	self.mpVehiclePlacementParcel = _G["MPVehiclePlacement"];

	if self.mpVehiclePlacementParcel == nil then
		return;
	end

	self.spawnProperties = self.spawnProperties or "Default";
	self.spawnLogic = self.spawnLogic or "Dynamic (Pickup)";
	self.randomize = self.randomize or "Every Game (Default)";
	self.legendary = self.legendary or "Exclude";
	self.incomingDuration = math.max(self.spawnTime - 1, 0);
	self.spawnTime = self.spawnTime or 30;
	self.symmetricalChannel = self.symmetricalChannel or "None";
	self.selectiveChannel = self.selectiveChannel or "None";
	self.stockAnimDelay = self.stockAnimDelay or 0;
	self.previewAsHologram = true;
	self.pingMessaging = true;
	self.seedSequenceKey = self.seedSequenceKey or "GeneralPlacementKey";
	self.staticSelection = self.staticSelection or "Disabled (Default)";

	if (self.isInvisible == nil) then
		self.isInvisible = false;
	end

	self:SetupTerrainBooleans();
	self:SetupFactionBooleans();
	self:SetupWeightingOverrides();

	self.symmetricalChannelId = self:GetSymmetricalChannelID();

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
	RegisterGlobalEvent(g_eventTypes.enteredBetweenRoundStateEvent, function(self) self.HandleRoundCleanup(self) end, self);
	RegisterGlobalEvent(GetFinalRoundCleanupEventType(), function(self) self.HandleRoundCleanup(self) end, self);
end

function mp_vehicle_placement.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	if (self.mpVehiclePlacementInstance == nil) then
		self.StartPlacementParcel(self);
	end
end

function mp_vehicle_placement.StartPlacementParcel(self):void
	self.mpVehiclePlacementInstance = self.mpVehiclePlacementParcel:NewVehiclePlacement(
		hmake MPVehiclePlacementInitArgs
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
			isMessagingVisible = self.navpoint,
			pingMessaging = self.pingMessaging,
			containerObject = self.components.spawner,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = self.maxCount,
			hasInvisibleDispenser = self.isInvisible,
			vehicle = self.vehicle,
			vehicleClass = self.vehicleClass,
			terrainFilters = self.terrainFiltersBooleans,
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = self.classWeightOverrides,
			incomingParticleFX = self.incomingParticleFX,
			altIncomingParticleFX = self.altIncomingParticleFX,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = self.restrictedParticleFX,
			previewAsHologram = self.previewAsHologram,
			itemShouldRotate = false,
			broadcastChannelPower = self.powerBroadcast,
			broadcastChannelControl = self.controlBroadcast,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpVehiclePlacementInstance, self.mpVehiclePlacementInstance.parcelName);
end

function mp_vehicle_placement.HandleRoundCleanup(self):void
	if (self.mpVehiclePlacementInstance == nil) then
		print("Error, attempting to end an MPVehiclePlacement parcel that was never started. Consider calling StartPlacementParcel() if round start was missed.");
		return;
	end

	if (self.mpVehiclePlacementInstance:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Game) then
		--print("saving vehicle for next round");
		self.vehicle = self.mpVehiclePlacementInstance:CurrentVehicleIdentifierAsString();
	end

	ParcelEnd(self.mpVehiclePlacementInstance);
	self.mpVehiclePlacementInstance = nil;
end

function mp_vehicle_placement:SetupTerrainBooleans():void
	if (self.terrainType == "Land") then
		self.land = true;	
	elseif (self.terrainType == "Air") then
		self.air = true;
	else
		self.land = true;
		self.air = true;
	end
	
	self.terrainFiltersBooleans =
	{
		[MP_VEHICLE_TERRAIN_TYPE.Land] = self.land or false,
		[MP_VEHICLE_TERRAIN_TYPE.Air] = self.air or false,
	};
end

function mp_vehicle_placement:SetupFactionBooleans():void
	if (self.faction == "UNSC") then
		self.unsc = true;	
	elseif (self.faction == "Banished") then
		self.banished = true;
	else
		self.unsc = true;
		self.banished = true;
	end
	
	self.factionFiltersBooleans =
	{
		[MP_ITEM_FACTION.UNSC] = self.unsc or false,
		[MP_ITEM_FACTION.Forerunner] = false,
		[MP_ITEM_FACTION.Banished] = self.banished or false,
		[MP_ITEM_FACTION.Covenant] = false,
	};
end

function mp_vehicle_placement:SetupWeightingOverrides():void
	if (not self.overrideClassWeighting) then
		self.classWeightOverrides = nil;
		return;
	end

	self.classWeightOverrides =
	{
		[MP_VEHICLE_CLASS.Support] = self.supportWeight or 0,
		[MP_VEHICLE_CLASS.Duelist] = self.duelistWeight or 0,
		[MP_VEHICLE_CLASS.Cavalry] = self.cavalryWeight or 0,
		[MP_VEHICLE_CLASS.Siege] = self.siegeWeight or 0,
	};
end

function mp_vehicle_placement:GetSymmetricalChannelID():string
	if (self.symmetricalChannel == nil or self.symmetricalChannel == "None") then
		return "None";
	end

	local id = tostring(self.symmetricalChannel) .. "_";
	
	-- Vehicle Class
	if (self.vehicleClass == "Support") then
		id = id .. tostring(MP_VEHICLE_CLASS.Support) .. "_";
	elseif (self.vehicleClass == "Duelist") then
		id = id .. tostring(MP_VEHICLE_CLASS.Duelist) .. "_";
	elseif (self.vehicleClass == "Cavalry") then
		id = id .. tostring(MP_VEHICLE_CLASS.Cavalry) .. "_";
	elseif (self.vehicleClass == "Siege") then
		id = id .. tostring(MP_VEHICLE_CLASS.Siege) .. "_";
	end
	
	-- Terrain
	if (self.land) then
		id = id .. tostring(MP_VEHICLE_TERRAIN_TYPE.Land) .. "_";
	end

	if (self.air) then
		id = id .. tostring(MP_VEHICLE_TERRAIN_TYPE.Air) .. "_";
	end

	-- Faction
	if (self.unsc) then
		id = id .. tostring(MP_ITEM_FACTION.UNSC) .. "_";
	end

	if (self.banished) then
		id = id .. tostring(MP_ITEM_FACTION.Banished) .. "_";
	end

	return id;
end	
