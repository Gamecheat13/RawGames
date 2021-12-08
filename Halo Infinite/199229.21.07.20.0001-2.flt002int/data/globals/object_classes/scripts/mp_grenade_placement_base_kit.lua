-- object mp_grenade_placement_base
--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_grenade_placement.lua');
REQUIRES('globals\scripts\global_multiplayer_init.lua');

hstructure mp_grenade_placement_base

	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
	equipmentContainer:object
	filters:table
	factionFiltersBooleans:table
	symmetricalChannelId:string
	isInvisible:boolean
	pingMessaging:boolean

	groupCountStringBase:string
	spawnCyclicallyBase:boolean

	-- Kit state
	mpGrenadePlacementInstance:table
	mpGrenadePlacementParcel:table
	
	-- Asset Tunables
	stockAnimDelay:number	-- The amount of time after the container begins to open to wait before actually spawning the weapon
	incomingDuration:number -- The amount of time to display an indication that a weapon is incoming before playing open animation

	-- Faber Scriptable Properties
		
	-- Grenade Selection
	grenade:string --$$ METADATA {"prettyName": "Static Grenade", "source": ["Random (Default)", "Frag Grenade", "Plasma Grenade", "Spike Grenade", "Dynamo Grenade"], "tooltip": "Grenade to be spawned if static selection is enabled.", "groupName": "Grenade Selection" }
	
	navpoint:boolean --$$ METADATA {"prettyName": "Spawn Messaging", "tooltip": "Enable navpoints for when the Grenade spawns", "groupName": "Base Properties" }
	spawnProperties:string --$$ METADATA {"prettyName": "Spawn Properties", "source": ["Default", "Custom"], "tooltip": "Default uses 343 spawn settings. Select Custom to enable the unique spawn properties below.", "groupName": "Base Properties" }
	staticSelection:string --$$ METADATA {"prettyName": "Static Selection", "source": ["Disabled (Default)", "Enabled"], "tooltip": "If enabled, always use the 'Static Grenade' entry if specified.", "groupName": "Base Properties" }

	-- Spawning
	spawnLogic:string	--$$ METADATA {"prettyName": "Spawn Logic", "source": ["Dynamic (Pickup)", "Dynamic (Expired)", "Static (Time)", "External Trigger"], "tooltip": "Event that triggers the Grenade's spawn time", "groupName": "Custom Spawn Properties" }		
	spawnTime:number --$$ METADATA {"min": 5, "prettyName": "Spawn Time", "tooltip": "Number of seconds it takes for the Weapon to spawn", "groupName": "Custom Spawn Properties" }
	initialSpawnDelay:number --$$ METADATA {"prettyName": "Initial Spawn Delay", "tooltip": "Number of seconds before the first spawn", "groupName": "Custom Spawn Properties" }	

	randomize:string	 --$$ METADATA {"prettyName": "Select New Grenade", "source": ["Every Game (Default)", "Every Round", "Every Spawn"], "tooltip": "Frequency at which a new random Grenade is selected", "groupName": "Custom Spawn Properties" }
	faction:string --$$ METADATA {"prettyName": "Faction Limitation", "source": ["Any", "UNSC", "Banished"], "tooltip": "Allow random Grenades from certain factions", "groupName": "Custom Spawn Properties" }
	
	-- Channels
	symmetricalChannel:string --$$ METADATA {"prettyName": "Symmetrical Channel", "source": ["None", "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel", "India", "Juliet"], "tooltip": "If set, all placements on this channel and of the same type will spawn the same random Grenade", "groupName": "Channels" }
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

	groupCount:number

	unsc:boolean
	banished:boolean
end

function mp_grenade_placement_base:AssignParcel():boolean
	self.mpGrenadePlacementParcel = _G["MPGrenadePlacement"];
	return self.mpGrenadePlacementParcel ~= nil;
end

function mp_grenade_placement_base:init()
	self:Initialize();
end

function mp_grenade_placement_base:Initialize():void
	if (self.components.spawner == nil) then
		return;		-- don't spin up the parcel if no container object. this could be a badly made kit, or could have been turned off by another system, i.e. megalo labels
	end

	if (self.mpGrenadePlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self.spawnProperties = self.spawnProperties or "Default";
	self.spawnLogic = self.spawnLogic or "Dynamic (Pickup)";
	self.randomize = self.randomize or "Every Game (Default)";
	self.incomingDuration = math.max(self.spawnTime - 1, 0);
	self.spawnTime = self.spawnTime or 30;
	self.symmetricalChannel = self.symmetricalChannel or "None";
	self.selectiveChannel = self.selectiveChannel or "None";
	self.stockAnimDelay = self.stockAnimDelay or 1;
	self.pingMessaging = true;
	self.seedSequenceKey = self.seedSequenceKey or "GeneralPlacementKey";
	self.staticSelection = self.staticSelection or "Disabled (Default)";

	local groupCountNum:number = tonumber(self.groupCountStringBase or "2");
	self.groupCount = math.Bound(groupCountNum, 1, 2);

	self:SetupFactionBooleans();

	self.symmetricalChannelId = self:GetSymmetricalChannelID();

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
	RegisterGlobalEvent(g_eventTypes.enteredBetweenRoundStateEvent, function(self) self.HandleRoundCleanup(self) end, self);
	RegisterGlobalEvent(GetFinalRoundCleanupEventType(), function(self) self.HandleRoundCleanup(self) end, self);
end

function mp_grenade_placement_base.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	if (self.mpGrenadePlacementInstance == nil) then
		self.StartPlacementParcel(self);
	end
end

function mp_grenade_placement_base.StartPlacementParcel(self):void
	self.mpGrenadePlacementInstance = self.mpGrenadePlacementParcel:NewGrenadePlacement(
		hmake MPGrenadePlacementInitArgs
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
			equipmentType = "Grenade",
			isMessagingVisible = self.navpoint,
			pingMessaging = self.pingMessaging,
			containerObject = self.components.spawner,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = 0,
			hasInvisibleDispenser = self.isInvisible,
			equipment = self.grenade,
			groupCount = self.groupCount,
			spawnCyclically = self.spawnCyclicallyBase,
			energyModifier = "100%",
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = nil,
			incomingParticleFX = self.incomingParticleFX,
			altIncomingParticleFX = self.altIncomingParticleFX,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = self.restrictedParticleFX,
			previewAsHologram = false,
			itemShouldRotate = true,
			broadcastChannelPower = self.powerBroadcast,
			broadcastChannelControl = self.controlBroadcast,
			legendaryItemUsage = "Exclude",
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpGrenadePlacementInstance, self.mpGrenadePlacementInstance.parcelName);
end

function mp_grenade_placement_base.HandleRoundCleanup(self):void
	if (self.mpGrenadePlacementInstance == nil) then
		print("Error, attempting to end an MPEquipmentPlacement parcel that was never started. Consider calling StartPlacementParcel() if round start was missed.");
		return;
	end

	if (self.mpGrenadePlacementInstance:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Game) then
		--print("saving grenade for next round");
		self.grenade = self.mpGrenadePlacementInstance:CurrentEquipmentIdentifierAsString();
	end

	ParcelEnd(self.mpGrenadePlacementInstance);
	self.mpGrenadePlacementInstance = nil;
end

function mp_grenade_placement_base.SetupFactionBooleans(self):void
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
		[MP_ITEM_FACTION.UNSC] = self.unsc,
		[MP_ITEM_FACTION.Forerunner] = false,
		[MP_ITEM_FACTION.Banished] = self.banished,
		[MP_ITEM_FACTION.Covenant] = false,
	};
end

function mp_grenade_placement_base.GetSymmetricalChannelID(self):string
	if (self.symmetricalChannel == nil or self.symmetricalChannel == "None") then
		return "None";
	end

	local id = tostring(self.symmetricalChannel) .. "_" .. tostring(MP_EQUIPMENT_CLASS.Grenade) .. "_";

	-- Faction
	if (self.unsc) then
		id = id .. tostring(MP_ITEM_FACTION.UNSC) .. "_";
	end

	if (self.banished) then
		id = id .. tostring(MP_ITEM_FACTION.Banished) .. "_";
	end

	return id;
end	

