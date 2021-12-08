-- object mp_weapon_pod_placement:mp_weapon_full_placement
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_weapon_full_placement_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_pod_placement.lua');

hstructure mp_weapon_pod_placement:mp_weapon_full_placement
	detonationProximity:number
end

function mp_weapon_pod_placement:AssignParcel():boolean
	self.mpWeaponPlacementParcel = _G["MPWeaponPodPlacement"];
	return self.mpWeaponPlacementParcel ~= nil;
end

function mp_weapon_pod_placement:init()
	if (self:AssignParcel() == nil) then
		return;
	end

	self.detonationProximity = self.detonationProximity or 2.5;

	self:Initialize();
	self.isInvisible = true;
end

function mp_weapon_pod_placement.StartPlacementParcel(self):void
	self.mpWeaponPlacementInstance = self.mpWeaponPlacementParcel:NewWeaponPodPlacement(
		hmake MPWeaponPodPlacementInitArgs
		{
			instanceName = self.components.NAME,
			spawnProperties = self.spawnProperties,
			spawnLogic = self.spawnLogic,
			symmetricalChannel	= self.symmetricalChannel,
			symmetricalChannelId = self.symmetricalChannelId,
			selectiveChannel = self.selectiveChannel,
			initialSpawnDelay = self.initialSpawnDelay,
			respawnTime = self.spawnTime,
			respawnType = self.respawnType,
			containerObject = self.components.container,
			isMessagingVisible = self.navpoint,
			stockAnimDelay = self.stockAnimDelay,
			incomingDuration = self.incomingDuration,
			maxDeployedItemCount = self.maxCount,
			hasInvisibleDispenser = self.isInvisible,
			weaponClass = self.weaponClass,
			weaponTier = self.weaponTier,
			weapon = self.weapon,
			ammoModifier = self.ammoModifier,
			factionFilters = self.factionFiltersBooleans,
			detonationProximity = self.detonationProximity,
			classWeightOverrides = self.tierWeightOverrides,
			incomingParticleFX = nil,
			altIncomingParticleFX = nil,
			spawnedParticleFX = self.spawnedParticleFX,
			altSpawnedParticleFX = self.altSpawnedParticleFX,
			restrictedParticleFX = nil,
			previewAsHologram = false,
			itemShouldRotate = true,
			plasmaExplosionDetach = self.plasmaExplosionDetach,
			plasmaForceModHorz = self.plasmaForceModHorz,
			plasmaForceModVert = self.plasmaForceModVert,
			broadcastChannelPower = nil,
			broadcastChannelControl = nil,
			legendaryItemUsage = self.legendary,
			seedSequenceKey = self.seedSequenceKey,
			staticSelection = self.staticSelection,
		});

	ParcelAddAndStart(self.mpWeaponPlacementInstance, self.mpWeaponPlacementInstance.parcelName);
end

