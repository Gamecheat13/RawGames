-- object mp_equipment_pod_placement:mp_powerup_placement
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_powerup_placement_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_pod_placement.lua');

hstructure mp_equipment_pod_placement:mp_powerup_placement
	detonationProximity:number
end

function mp_equipment_pod_placement:AssignParcel():boolean
	self.mpEquipmentPlacementParcel = _G["MPEquipmentPodPlacement"];
	return self.mpEquipmentPlacementParcel ~= nil;
end

function mp_equipment_pod_placement:init()
	if (self.mpEquipmentPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	if (self:AssignParcel() == nil) then
		return;
	end

	self.detonationProximity = self.detonationProximity or 2;

	self:Initialize();
	self.isInvisible = true;
end

function mp_equipment_pod_placement.StartPlacementParcel(self):void
	self.mpEquipmentPlacementInstance = self.mpEquipmentPlacementParcel:NewEquipmentPodPlacement(
		hmake MPEquipmentPodPlacementInitArgs
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
			containerObject = self.components.spawner,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = self.maxCount,
			hasInvisibleDispenser = self.isInvisible,
			equipment = self.equipment,
			energyModifier = self.energyModifier,
			factionFilters = self.factionFiltersBooleans,
			classWeightOverrides = self.classWeightOverrides,
			detonationProximity = self.detonationProximity,
			incomingParticleFX = nil,
			altIncomingParticleFX = nil,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = nil,
			previewAsHologram = false,
			itemShouldRotate = true,
			broadcastChannelPower = nil,
			broadcastChannelControl = nil,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpEquipmentPlacementInstance, self.mpEquipmentPlacementInstance.parcelName);
end

