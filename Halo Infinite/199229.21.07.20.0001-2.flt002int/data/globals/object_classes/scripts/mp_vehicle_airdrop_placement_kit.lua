-- object mp_vehicle_airdrop_placement
--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_vehicle_airdrop_placement.lua');
REQUIRES('globals\scripts\global_multiplayer_init.lua');

hstructure mp_vehicle_airdrop_placement
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
	filters:table
	terrainFiltersBooleans:table
	factionFiltersBooleans:table
	symmetricalChannelId:string
	classWeightOverrides:table

	-- Kit state
	mpVehicleAirDropPlacementInstance:table
	mpVehicleAirDropPlacementParcel:table

	-- Faber Scriptable Properties	

	-- Vehicle Selection
	vehicleClass:string	--$$ METADATA {"prettyName": "Class", "source": ["Any", "Support", "Duelist", "Cavalry", "Siege"], "tooltip": "The class of vehicle to spawn if randomly selecting.", "groupName": "Vehicle Selection" }
	terrainType:string --$$ METADATA {"prettyName": "Terrain Type", "source": ["Any", "Land", "Air"], "tooltip": "The allowed terrain type of the vehicle", "groupName": "Vehicle Selection" }
	vehicle:string --$$ METADATA {"prettyName": "Static Vehicle", "source": ["Random (Default)", "Banshee", "Chopper", "Ghost", "Gungoose", "Mongoose", "Razorback", "Rockethog", "Scorpion", "Warthog", "Wasp", "Wraith"], "tooltip": "Vehicle to be spawned if static selection is enabled.", "groupName": "Vehicle Selection" }
	legendary:string	--$$ METADATA {"prettyName": "Variants", "source": ["Exclude", "Include", "Preferred"], "tooltip": "Determines if legendary variants of vehicles can spawn. Exclude = no (default), Include = yes, Preferred = always use if available", "groupName": "Vehicle Selection" }	

	-- Spawning
	navpoint:boolean --$$ METADATA {"prettyName": "Navpoint", "tooltip": "Enable navpoints for when the Vehicle spawns", "groupName": "Spawning" }
	spawnProperties:string --$$ METADATA {"prettyName": "Spawn Properties", "source": ["Default", "Custom"], "tooltip": "Default uses 343 spawn settings. Select Custom to enable the unique spawn properties below.", "groupName": "Base Properties" }
	staticSelection:string --$$ METADATA {"prettyName": "Static Selection", "source": ["Disabled (Default)", "Enabled"], "tooltip": "If enabled, always use the 'Static Vehicle' entry if specified.", "groupName": "Base Properties" }

	-- Advanced Selection
	randomize:string	 --$$ METADATA {"prettyName": "Randomize", "source": ["Every Game (Default)", "Every Round", "Every Spawn"], "tooltip": "The frequency at which the Vehicle will be randomized", "groupName": "Advanced Selection" }
	faction:string --$$ METADATA {"prettyName": "Faction", "source": ["Any", "UNSC", "Banished"], "tooltip": "The allowed faction of the vehicle", "groupName": "Advanced Selection" }
	
	-- Advanced Spawning
	symmetricalChannel:string --$$ METADATA {"prettyName": "Symmetrical Channel", "source": ["None", "AirDrop Alpha", "AirDrop Bravo", "AirDrop Charlie", "AirDrop Delta"], "tooltip": "If not set to 'None', other placements with same channel will spawn identical vehicles", "groupName": "Advanced Spawning" }
	selectiveChannel:string --$$ METADATA {"prettyName": "Selective Channel", "source": ["None", "AirDrop Alpha", "AirDrop Bravo", "AirDrop Charlie", "AirDrop Delta"], "tooltip": "If not set to 'None', other placements with same channel can be limited to a random subset", "groupName": "Advanced Spawning" }

	-- Weight Overrides
	overrideClassWeighting:boolean --$$ METADATA {"prettyName": "Override Class Weights", "tooltip": "If 'Random' class is selected, use the weightings shown below instead of the global values to weight vehicle class", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	supportWeight:number --$$ METADATA {"min": 0, "prettyName": "Support Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	duelistWeight:number --$$ METADATA {"min": 0, "prettyName": "Duelist Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	cavalryWeight:number --$$ METADATA {"min": 0, "prettyName": "Cavalry Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}
	siegeWeight:number --$$ METADATA {"min": 0, "prettyName": "Siege Weighting", "groupName": "Vehicle Class Weighting Overrides (Optional)"}

	-- Drop Zone Configs
	dropType:string	--$$ METADATA {"prettyName": "Cargo Drop Type", "source": ["Drop Zone", "Exact Drop"], "tooltip": "Drop Zone checks for the area around the drop point and checks to see if it can drop. Exact drop ignores check and takes rotation of the point with how the Pelican will face", "groupName": "Cargo Drop Configs" }
	dropRange:number --$$ METADATA {"min": 1, "prettyName": "Drop Range", "tooltip": "Used only for Drop Zone Drop Type. Checks in a circle around drop point with given range.", "groupName": "Cargo Drop Configs"}

	-- Random Seeding
	seedSequenceKey:string	--$$ METADATA {"prettyName": "Seed Sequence Key", "source": ["GeneralPlacementKey", "WeaponRackPlacementKey", "WeaponTrunkPlacementKey", "PowerWeaponPadPlacementKey", "GrenadePadPlacementKey", "EquipmentPadPlacementKey", "PowerUpPadPlacementKey", "OrdnancePodPlacementKey", "VehiclePadPlacementKey", "VehicleDropPlacementKey"], "tooltip": "The key used to determine the random seed sequence that will be used for the spawner.", "groupName": "Random Seeding" }

	land:boolean
	air:boolean

	unsc:boolean
	banished:boolean

	useDropZone:boolean
end

function mp_vehicle_airdrop_placement:init()
	if (self.components.spawner == nil) then
		return;		-- don't spin up the parcel if no container object. this could be a badly made kit, or could have been turned off by another system, i.e. megalo labels
	end

	self.mpVehicleAirDropPlacementParcel = _G["MPVehicleAirDropPlacement"];

	if self.mpVehicleAirDropPlacementParcel == nil then
		return;
	end

	self.randomize = self.randomize or "Every Game (Default)";
	self.symmetricalChannel = self.symmetricalChannel or "None";
	self.selectiveChannel = self.selectiveChannel or "None";
	self.legendary = self.legendary or "Exclude";
	self.seedSequenceKey = self.seedSequenceKey or "GeneralPlacementKey";
	self.staticSelection = self.staticSelection or "Disabled (Default)";

	if (self.dropType == "Exact Drop") then
		self.useDropZone = false;
	else
		self.useDropZone = true;
	end

	self.dropRange = self.dropRange or 5;

	self:SetupTerrainBooleans();
	self:SetupFactionBooleans();
	self:SetupWeightingOverrides();

	self.symmetricalChannelId = self:GetSymmetricalChannelID();

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
	RegisterGlobalEvent(g_eventTypes.enteredBetweenRoundStateEvent, function(self) self.HandleRoundCleanup(self) end, self);
	RegisterGlobalEvent(GetFinalRoundCleanupEventType(), function(self) self.HandleRoundCleanup(self) end, self);
end

function mp_vehicle_airdrop_placement.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	if (self.mpVehicleAirDropPlacementInstance == nil) then
		self.StartPlacementParcel(self);
	end
end

function mp_vehicle_airdrop_placement.StartPlacementParcel(self):void
	self.mpVehicleAirDropPlacementInstance = self.mpVehicleAirDropPlacementParcel:NewVehicleAirDropPlacement(
		hmake MPVehicleAirdropPlacementInitArgs
		{
			instanceName = self.components.NAME,
			spawnLogic = "External Trigger",
			symmetricalChannel	= self.symmetricalChannel,
			symmetricalChannelId = self.symmetricalChannelId,
			selectiveChannel = self.selectiveChannel,
			initialSpawnDelay = 0,
			respawnTime = 30,	-- should be irrelevant as these are all spawned externally
			respawnType = self.randomize,
			isMessagingVisible = self.navpoint,
			containerObject = self.components.spawner,
			stockAnimDelay = 0,
			incomingDuration = 10,
			maxDeployedItemCount = 0,
			hasInvisibleDispenser = true,
			vehicle = self.vehicle,
			vehicleClass = self.vehicleClass,
			terrainFilters = self.terrainFiltersBooleans,
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = self.classWeightOverrides,
			incomingParticleFX = nil,
			altIncomingParticleFX = nil,
			spawnedParticleFX = nil,
			altSpawnedParticleFX = nil,
			restrictedParticleFX = nil,
			previewAsHologram = false,
			itemShouldRotate = false,
			useDropZone = self.useDropZone,
			acceptanceRadius = self.dropRange,
			broadcastChannelPower = nil,
			broadcastChannelControl = nil,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpVehicleAirDropPlacementInstance, self.mpVehicleAirDropPlacementInstance.parcelName);
end

function mp_vehicle_airdrop_placement.HandleRoundCleanup(self):void
	if (self.mpVehicleAirDropPlacementInstance == nil) then
		print("Error, attempting to end an MPVehiclePlacement parcel that was never started. Consider calling StartPlacementParcel() if round start was missed.");
		return;
	end

	if (self.mpVehicleAirDropPlacementInstance:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Game) then
		--print("saving vehicle for next round");
		self.vehicle = self.mpVehicleAirDropPlacementInstance:CurrentVehicleIdentifierAsString();
	end

	ParcelEnd(self.mpVehicleAirDropPlacementInstance);
	self.mpVehicleAirDropPlacementInstance = nil;
end

function mp_vehicle_airdrop_placement:SetupTerrainBooleans():void
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

function mp_vehicle_airdrop_placement:SetupFactionBooleans():void
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

function mp_vehicle_airdrop_placement:SetupWeightingOverrides():void
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

function mp_vehicle_airdrop_placement:GetSymmetricalChannelID():string
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
