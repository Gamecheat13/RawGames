-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_weapon_placement.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_ordnance_drop.lua');

--//////
-- Parcel Setup
--//////

global MPWeaponPodPlacement:table = MPWeaponPlacement:CreateSubclass();

MPWeaponPodPlacement.parcelName = "MPWeaponPodPlacement";
MPWeaponPodPlacement.ordnanceDropParcel = nil;
MPWeaponPodPlacement.ordnanceDropInstance = nil;
MPWeaponPodPlacement.proximityDistanceSq = 0;
MPWeaponPodPlacement.podIsOpen = false;
MPWeaponPodPlacement.distanceSqFromPodCheck = 0


MPWeaponPodPlacement.CONST.podDeletionDelay = 3;
MPWeaponPodPlacement.CONST.distanceFromPodCheck = 32; --Actualy Distance we want to test from player
MPWeaponPodPlacement.CONST.voDelayTime = 2.5;


function MPWeaponPodPlacement:NewWeaponPodPlacement(initArgs:MPWeaponPodPlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMPWeaponPodPlacement = self:NewWeaponPlacement(
		hmake MPWeaponPlacementInitArgs
		{
			instanceName = initArgs.instanceName,
			spawnProperties = initArgs.spawnProperties,
			spawnLogic = initArgs.spawnLogic,
			symmetricalChannel	= initArgs.symmetricalChannel,
			symmetricalChannelId = initArgs.symmetricalChannelId,
			selectiveChannel = initArgs.selectiveChannel,
			initialSpawnDelay = initArgs.initialSpawnDelay,
			respawnTime = initArgs.respawnTime,
			respawnType = initArgs.respawnType,
			isMessagingVisible  = initArgs.isMessagingVisible,
			containerObject = initArgs.containerObject,
			stockAnimDelay = initArgs.stockAnimDelay,
			incomingDuration = initArgs.incomingDuration,
			maxDeployedItemCount = initArgs.maxDeployedItemCount,
			hasInvisibleDispenser = initArgs.hasInvisibleDispenser,
			ammoModifier = initArgs.ammoModifier,
			factionFilters = initArgs.factionFilters,
			weaponClass = initArgs.weaponClass,
			weaponTier = initArgs.weaponTier,
			weapon = initArgs.weapon,
			classWeightOverrides = initArgs.classWeightOverrides,
			incomingParticleFX = initArgs.incomingParticleFX,
			altIncomingParticleFX = initArgs.altIncomingParticleFX,
			spawnedParticleFX = initArgs.spawnedParticleFX,
			altSpawnedParticleFX = initArgs.altSpawnedParticleFX,
			restrictedParticleFX = initArgs.restrictedParticleFX,
			previewAsHologram = initArgs.previewAsHologram,
			itemShouldRotate = initArgs.itemShouldRotate,
			plasmaExplosionDetach = initArgs.plasmaExplosionDetach,
			plasmaForceModHorz = initArgs.plasmaForceModHorz,
			plasmaForceModVert = initArgs.plasmaForceModVert,
			broadcastChannelPower = initArgs.broadcastChannelPower,		-- should be nil from kit
			broadcastChannelControl = initArgs.broadcastChannelControl,	-- should be nil from kit
			legendaryItemUsage = initArgs.legendaryItemUsage,
			seedSequenceKey = initArgs.seedSequenceKey,
			staticSelection = initArgs.staticSelection,
		});

	newMPWeaponPodPlacement.CONFIG.detonationProximity = initArgs.detonationProximity or 0;
	newMPWeaponPodPlacement.proximityDistanceSq = math.pow(initArgs.detonationProximity, 2);
	return newMPWeaponPodPlacement;
end

function MPWeaponPodPlacement:InitializeImmediate():void	-- override
	self.ordnanceDropParcel = _G["MPOrdnanceDrop"];

	-- Square this for the check that is squared
	self.distanceSqFromPodCheck = self.CONST.distanceFromPodCheck * self.CONST.distanceFromPodCheck;

	self:InitializeImmediateWeapon();
end

function MPWeaponPodPlacement:EndShutdown():void			-- override
	self:EndShutdownItem();

	if (self.ordnanceDropInstance ~= nil) then
		ParcelEnd(self.ordnanceDropInstance);
		self.ordnanceDropInstance = nil;
	end
end

function MPWeaponPodPlacement:GetAccelerationProxy():object -- override
	if (self.ordnanceDropInstance == nil) then
		return nil;
	end

	return self.ordnanceDropInstance:GetCrate();
end

function MPWeaponPodPlacement:CreateItemObject():void	-- override
	if (self.ordnanceDropParcel == nil) then
		print("ERROR: Unable to locate drop pod parcel");
		return;
	end

	self.ordnanceDropInstance = self.ordnanceDropParcel:NewOrdnanceParcel(
		hmake MPOrdnanceDropInitArgs
		{ 
			ordnanceType = OrdnanceType.Weapon,
			deletionDelay = self.CONST.podDeletionDelay,
		});

	if (self.ordnanceDropInstance == nil) then
		print("ERROR: Unable to instantiate drop pod parcel");
		return;
	end

	ParcelAddAndStart(self.ordnanceDropInstance, self.ordnanceDropInstance.instanceName);

	SleepOneFrame();

	local playersInArea:table = {};
	local containerPosition:location = Object_GetPosition(self.containerObject)

	for _, closePlayer in hpairs (PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(closePlayer);
		local distanceCheck:number = Object_GetDistanceSquaredToPosition(playerUnit, containerPosition);

		if distanceCheck < self.distanceSqFromPodCheck then
			table.insert(playersInArea, closePlayer);
		end
	end

	self:PlayIncomingVO(playersInArea);

	--Give enough time for announcement VO to play before dropping Pod.
	SleepSeconds(self.CONST.voDelayTime);

	if (self.ordnanceDropInstance == nil) then
		return;		-- instance used to be valid, but now is nil, indicating that the round must have ended while we waited for the VO delay time
	end

	self.podIsOpen = false;
	self.ordnanceDropInstance:DeliverCargo(self.itemTag, nil, containerPosition, self.itemScale + self.CONFIG.scaleFudgeFactor, self.CONFIG.detonationProximity == 0);

	if (self.ordnanceDropInstance == nil or self.ordnanceDropInstance:IsComplete()) then
		print("ERROR: failure delivering drop pod cargo");
		return;
	end

	if (self.canUseItemManager and self.CONFIG.detonationProximity > 0) then
		-- keep track of pod/placement pairs, but only if opening on proximity. pod self-deletes immediately otherwise
		self.itemManager:RegisterDropPod(self, self.ordnanceDropInstance:GetCrate());
	end

	self.spawnedItemObject = self.ordnanceDropInstance:GetCargo();
	self.ordnanceDropInstance.crateInstance:AddOnCrateCargoImmediatePickup(self, self.HandleImmediateCargoPickup);
	self:DebugPrint("Got weapon from ordnance drop pod:", self.spawnedItemObject);

	if (self.doDamageDetach) then
		if (not ParcelIsValid(self)) then
			print("MPWeaponPodPlacement: Parcel became invalid while waiting for pod to drop in DeliverCargo (end of round?)");
			return;
		end

		self:RegisterEventOnSelf(g_eventTypes.objectDamageAccelerationEvent, self.OnDamageAccelerationApplied, self:GetAccelerationProxy());
	end

	if (self.CONFIG.detonationProximity > 0) then
		self:CreateThread(self.MonitorProximityForOpen);
	end
end

function MPWeaponPodPlacement:MessagingIncoming():void	-- override
	-- leave empty so we don't conflict if messaging is turned on since we're going to always play VO for pods
end

function MPWeaponPodPlacement:PlayIncomingVO(playersInArea:table):void
	if (self.canUseItemManager) then
		self.itemManager:PlayVO(
			hmake MPItemSpawnerPendingVOData
			{
				responseName	= "__OnIncomingDropPods",
				itemName		= nil,
				itemType		= MPItemGroupType.Ordnance,
				voType			= MPItemVOType.Incoming,
				matchingPlayers	= playersInArea,
			});
	end
end

function MPWeaponPodPlacement:HandleImmediateCargoPickup():void
	self:ProcessBasicWeaponPickup();
end

function MPWeaponPodPlacement:MonitorProximityForOpen():void
	if (self.ordnanceDropInstance:IsComplete() or self.ordnanceDropInstance:GetPod() == nil) then
		return;
	end

	self:DebugPrint("Begin MPWeaponPodPlacement:MonitorProximityForOpen");
	repeat
		SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self:PlayerIsNearDropPod();

	self:DebugPrint("OpenPod");
	self.ordnanceDropInstance:OpenPod();
	self.podIsOpen = true;

	if (self.canUseItemManager and self.CONFIG.detonationProximity > 0) then
		self.itemManager:UnregisterDropPod(self);
	end

	self:EnableSpawnedEffect(true);
end

function MPWeaponPodPlacement:PlayerIsNearDropPod():boolean
	local crate:object = self.ordnanceDropInstance:GetCrate();

	if (crate == nil) then
		return false;
	end

	for _, player in ipairs(PLAYERS.active) do
		local playerUnit:object = Player_GetUnit(player);
		if (playerUnit ~= nil and Object_GetDistanceSquaredToObject(crate, playerUnit) < self.proximityDistanceSq) then
			return true;
		end
	end

	return false;
end

function MPWeaponPodPlacement:EnableSpawnedEffect(enable:boolean):void	-- override
	local spawnFX = self:GetSpawnedEffect();
	if (spawnFX == nil or not self.podIsOpen) then
		return;
	end

	local crate:object = self.ordnanceDropInstance:GetCrate();

	if (enable) then
		RunClientScript("DisplaySpawnerParticleEffect", crate, spawnFX, self.CONST.effectMarkerName);
	else
		RunClientScript("RemoveSpawnerParticleEffect", crate, spawnFX, self.CONST.effectMarkerName);
	end
end

