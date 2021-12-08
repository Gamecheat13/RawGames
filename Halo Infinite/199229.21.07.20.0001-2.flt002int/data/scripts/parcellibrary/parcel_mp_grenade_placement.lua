-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_equipment_placement.lua');

hstructure GrenadeTrackingEntry
	grenade				:object
	grenadeType			:grenade_type
	tag					:tag
	inventoryPlayer		:player
	state				:number
end

--//////
-- Parcel Setup
--//////

global MPGrenadePlacement:table = MPEquipmentPlacement:CreateSubclass();

MPGrenadePlacement.parcelName = "MPGrenadePlacement";
MPGrenadePlacement.spawnedItemList = {};
MPGrenadePlacement.lastSpawnIndex = -1;

MPGrenadePlacement.CONFIG.groupCount = 2;
MPGrenadePlacement.CONFIG.spawnCyclically = false;

-- overrides
MPGrenadePlacement.spawnMarker = "grenade_";
MPGrenadePlacement.CONST.navpointPresentationNameItemType = "grenade";	-- override
MPGrenadePlacement.CONST.occupiedOpenRightAnimName = "is_grenade_right";
MPGrenadePlacement.CONST.occupiedOpenLeftAnimName = "is_grenade_left";

MPGrenadePlacement.CONST.quickCloseDuration = 1;
MPGrenadePlacement.CONST.wakeWithinDistance = 12;
MPGrenadePlacement.CONST.sleepBeyondDistance = 16;


function MPGrenadePlacement:NewGrenadePlacement(initArgs:MPGrenadePlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMpGrenadePlacement = self:NewEquipmentPlacement(
		hmake MPEquipmentPlacementInitArgs
		{
			instanceName = initArgs.instanceName,
			spawnProperties = initArgs.spawnProperties,
			spawnLogic = initArgs.spawnLogic,
			symmetricalChannel	= initArgs.symmetricalChannel,
			symmetricalChannelId = initArgs.symmetricalChannelId,
			selectiveChannel = initArgs.selectiveChannel,
			factionFilters = initArgs.factionFilters;
			initialSpawnDelay = initArgs.initialSpawnDelay,
			respawnTime = initArgs.respawnTime,
			respawnType = initArgs.respawnType,
			isMessagingVisible  = initArgs.isMessagingVisible,
			pingMessaging = initArgs.pingMessaging,
			containerObject = initArgs.containerObject,
			stockAnimDelay = initArgs.stockAnimDelay,
			incomingDuration = initArgs.incomingDuration,
			hasInvisibleDispenser = initArgs.hasInvisibleDispenser,
			maxDeployedItemCount = initArgs.maxDeployedItemCount,
			equipmentType = initArgs.equipmentType,	-- will always be grenades from kit
			equipment = initArgs.equipment,
			energyModifier = initArgs.energyModifier,
			classWeightOverrides = initArgs.classWeightOverrides,
			incomingParticleFX = initArgs.incomingParticleFX,
			altIncomingParticleFX = initArgs.altIncomingParticleFX,
			spawnedParticleFX = initArgs.spawnedParticleFX,
			altSpawnedParticleFX = initArgs.altSpawnedParticleFX,
			restrictedParticleFX = initArgs.restrictedParticleFX,
			previewAsHologram = initArgs.previewAsHologram,
			itemShouldRotate = initArgs.itemShouldRotate,
			broadcastChannelPower = initArgs.broadcastChannelPower,
			broadcastChannelControl = initArgs.broadcastChannelControl,
			legendaryItemUsage = initArgs.legendaryItemUsage,	-- will always be exclude from kit
			seedSequenceKey = initArgs.seedSequenceKey,
			staticSelection = initArgs.staticSelection,
		});

	if (initArgs.groupCount ~= nil) then
		newMpGrenadePlacement.CONFIG.groupCount = math.floor(initArgs.groupCount + 0.5);
	end

	newMpGrenadePlacement.CONFIG.spawnCyclically = initArgs.spawnCyclically;

	if (initArgs.spawnProperties == "Default") then
		local presets:table = GetMPEquipmentSpawnerPresets();
		local gameMode:number = GetItemSpawnerPresetGameModeType();

		newMpGrenadePlacement.CONFIG.spawnCyclically = presets[gameMode][MP_EQUIPMENT_CLASS.Grenade].spawnGrenadesCyclically;
	end

	return newMpGrenadePlacement;
end

function MPGrenadePlacement:TriggerItemSpawn():boolean	-- override
	if (not ParcelIsValid(self)) then
		print("MPGrenadePlacement: Cannot attempt to externally trigger item spawn until parcel has been initialized");
		return false;
	end

	if (self:CanTriggerExternally() and self:AllSlotsAreEmpty()) then
		self:StartSpawningState();
		return true;
	end

	return false;
end

function MPGrenadePlacement:EndShutdown():void			-- override
	self:EndShutdownItem();

	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self.spawnedItemList[idx] ~= nil) then
			Object_Delete(self.spawnedItemList[idx]);
			self.spawnedItemList[idx] = nil;
		end
	end
end

function MPGrenadePlacement:InitializeImmediate():void	-- override
	self:AcquireItemManager();
	self.CONFIG.maxDeployedItemCount = math.huge;
	self:InitializeImmediateBase();

	if (self:IsEquipmentFlightBanned(self.explicitIdentifier)) then
		self:HandleBannedExplicitIdentifier();
	end
end

function MPGrenadePlacement:InitializeContainer():void	-- override
	self:InitializeContainerBase();
	self:RegisterForUsageEvents();		-- stay registered as we'll always need this
end

function MPGrenadePlacement:GetFallbackIdentifier():mp_equipment_identifier	-- override
	return MP_EQUIPMENT_IDENTIFIER.FragGrenade;
end

function MPGrenadePlacement:RegisterForDeployedEvents(theObject:object):void		-- override
	self:RegisterEventOnSelf(g_eventTypes.grenadePickupEvent, self.HandleGrenadePickup, theObject);
end

function MPGrenadePlacement:UnregisterForDeployedEvents(theObject:object):void		-- override
	self:UnregisterEventOnSelf(g_eventTypes.grenadePickupEvent, self.HandleGrenadePickup, theObject);
end

function MPGrenadePlacement:RegisterForUsageEvents():void		-- override
	self:RegisterGlobalEventOnSelf(g_eventTypes.grenadeThrowEvent, self.HandleGrenadeThrow);
	self:RegisterGlobalEventOnSelf(g_eventTypes.grenadeDropEvent, self.HandleGrenadeDrop);
end

function MPGrenadePlacement:HandleGrenadePickup(eventArgs:GrenadePickupEventStruct):void
	self:OnGrenadePickedUp(eventArgs.grenadePickup, eventArgs.grenadeType, eventArgs.player);
end

function MPGrenadePlacement:HandleGrenadeThrow(eventArgs:GrenadeThrowEventStruct):void
	self:RemoveTrackingDataOnThrow(eventArgs.grenadeType, eventArgs.player);
end

function MPGrenadePlacement:HandleGrenadeDrop(eventArgs:GrenadeDropEventStruct):void
	self:ModifyTrackingDataOnGrenadeDrop(eventArgs.spawnedGrenade, eventArgs.grenadeType, eventArgs.player);
end

function MPGrenadePlacement:OnGrenadePickedUp(pickedUpGrenade:object, grenadeType:grenade_type, lootingPlayer:player)
	self:DebugPrint("MPGrenadePlacement:OnGrenadePickedUp()", pickedUpGrenade);

	-- object was just deleted, now keep track that this specific player is "carrying" the equipment
	self:ModifyTrackingDataOnGrenadePickup(pickedUpGrenade, grenadeType, lootingPlayer);

	-- stop listening for pickup of the item on the pad
	self:UnregisterForDeployedEvents(pickedUpGrenade);
	self:UnregisterForDeletionEvent(pickedUpGrenade);

	self:OnGrenadeRemovedFromPad(self:GetObjectSlot(pickedUpGrenade));

	if (self.CONFIG.isMessagingVisible) then
		self:MessagingPickedUp(lootingPlayer);
		local navText:string = self.CONFIG.navpointIncomingText .. (self.itemStringId or "");
		RunClientScript("IntelMapSetEquipmentPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, navText);
	end
end

function MPGrenadePlacement:OnGrenadeRemovedFromPad(grenadeSlot:number):void
	self.spawnedItemList[grenadeSlot] = nil;

	local allSlotsEmpty:boolean = self:AllSlotsAreEmpty();

	if (allSlotsEmpty) then
		self:GoToDormantStateBase();
	end

	if (self.resetThread == nil) then	-- don't start reset thread if it was already started by next cyclical
		self:DebugPrint("Reset grenade from removal from pad");
		self.resetThread = self:CreateThread(self.LifecycleResetRoutine, allSlotsEmpty);
	elseif (allSlotsEmpty) then
		self:DebugPrint("All slots now empty, close the door");
		self:CreateThread(self.PlayCloseAnimationWhenAllowed);
	end
end

function MPGrenadePlacement:OnObjectDeleted(eventArgs:ObjectDeletedStruct):void
	for _, data in ipairs (self.deployedItems) do
		if (self:AreObjectsEqual(data.grenade, eventArgs.deletedObject) and data.state == MPEquipmentLifecycleState.Dropped) then
			self:DebugPrint("MPGrenadePlacement:CleanUpDeletedObject(): ", eventArgs.deletedObject);

			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.identifier);
			end

			table.removeValue(self.deployedItems, data);
			break;
		end
	end

	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self:AreObjectsEqual(self.spawnedItemList[idx], eventArgs.deletedObject)) then
			self:DebugPrint("A grenade on the pad was deleted, most likely because it was sniped");
			self:OnGrenadeRemovedFromPad(idx);
			self:RemoveTrackingDataOnGrenadeSniped(eventArgs.deletedObject);
			break;
		end
	end

	self:UnregisterForDeletionEvent(eventArgs.deletedObject);
end

function MPGrenadePlacement:CreateTrackingData():void		-- override
	self:DebugPrint("MPGrenadePlacement:CreateTrackingData()");

	assert(self.lastSpawnIndex > 0, "The last grenade spawn index is invalid");

	local entry = hmake GrenadeTrackingEntry
	{
		grenade = self.spawnedItemList[self.lastSpawnIndex],
		grenadeType = GRENADE_TYPE.NONE,
		tag = self.itemTag,
		inventoryPlayer = nil,
		state = MPEquipmentLifecycleState.Placed,
	};

	table.insert(self.deployedItems, entry);

	if (self.canUseItemManager) then
		self.itemManager:OnItemSpawned(self.itemIdentifier);
	end

	self:DebugPrint("Adding deployed item: ", self.itemIdentifier);
end

function MPGrenadePlacement:ModifyTrackingDataOnGrenadePickup(grenadePickup:object, grenadeType:grenade_type, lootingPlayer:player):void
	for _, data in ipairs (self.deployedItems) do
		if (data.state ~= MPEquipmentLifecycleState.Carried and self:AreObjectsEqual(data.grenade, grenadePickup)) then
			self:DebugPrint("MPGrenadePlacement:ModifyTrackingDataOnPickup(): ", grenadePickup, grenadeType);

			data.grenade = nil;
			data.grenadeType = grenadeType;
			data.inventoryPlayer = lootingPlayer;
			data.state = MPEquipmentLifecycleState.Carried;
			break;
		end
	end
end

function MPGrenadePlacement:RemoveTrackingDataOnGrenadeSniped(grenadePickup:object):void
	for idx, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Placed and self:AreObjectsEqual(data.grenade, grenadePickup)) then
			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.identifier);
			end

			table.remove(self.deployedItems, idx);

			self:DebugPrint("MPGrenadePlacement:RemoveTrackingDataOnGrenadeSniped(): ", grenadePickup, " Remaining: ", table.countKeys(self.deployedItems));
			break;
		end
	end
end

function MPGrenadePlacement:RemoveTrackingDataOnThrow(grenadeType:grenade_type, throwingPlayer:player):void
	for idx, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Carried and data.grenadeType == grenadeType and data.inventoryPlayer == throwingPlayer) then
			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.identifier);
			end

			table.remove(self.deployedItems, idx);

			self:DebugPrint("MPGrenadePlacement:RemoveTrackingDataOnThrow(): ", data.identifier, " Remaining: ", table.countKeys(self.deployedItems));
			break;
		end
	end
end

function MPGrenadePlacement:ModifyTrackingDataOnGrenadeDrop(spawnedGrenade:object, grenadeType:grenade_type, deadPlayer:player):void
	for _, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Carried and data.grenadeType == grenadeType and data.inventoryPlayer == deadPlayer) then
			self:DebugPrint("MPGrenadePlacement:ModifyTrackingDataOnGrenadeDrop(): ", grenadeType);

			data.grenade = spawnedGrenade;
			data.state = MPEquipmentLifecycleState.Dropped;
			data.inventoryPlayer = nil;

			self:RegisterForDeployedEvents(spawnedGrenade);
			self:RegisterForDeletionEvent(spawnedGrenade);
			break;
		end
	end
end

function MPGrenadePlacement:GotoLoadingAnimState():void		-- override
	self:GotoLoadingAnimStateBase();
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 0, 0);
end

function MPGrenadePlacement:GotoOpeningAnimState():void		-- override
	self:EnableClientVisibilityWakeManager(false);

	Object_SetFunctionValue(self.containerObject, self.CONST.loadingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.closingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.rotatingAnimateName, 0, 0);

	if (self:AllSlotsAreEmpty()) then
		Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 1, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 0, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 0, 0);
	elseif (self.spawnedItemList[1] ~= nil) then
		Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 0, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 1, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 0, 0);
	else
		Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 0, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 0, 0);
		Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 1, 0);
	end

	if (self.itemShouldRotate) then
		self:CreateThread(self.WaitForRotation);
	end
end

function MPGrenadePlacement:GotoClosingAnimState():void		-- override
	self:GotoClosingAnimStateBase();
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 0, 0);
end

function MPGrenadePlacement:GotoRotatingAnimState():void	-- override
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenRightAnimName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.occupiedOpenLeftAnimName, 0, 0);
	self:GotoRotatingAnimStateBase();
end

function MPGrenadePlacement:WaitForRotation():void		-- override
	SleepSeconds(self.CONFIG.rotationDelay);

	if (self.deploymentState == DeploymentState.Spawned or 
		(self.deploymentState == DeploymentState.Dormant and not self:AllSlotsAreEmpty())) then
		self:GotoRotatingAnimState();
	end
end

-- deprecated: to avoid problems with rotating grenades on pad, don't play the incoming animations if the pad is partially occupied
function MPGrenadePlacement:PlayIncomingAnimationWhileOpen(duration:number):void
	self:DebugPrint("MPGrenadePlacement:PlayIncomingAnimationWhileOpen()");

	if (self.hasInvisibleDispenser) then
		return;
	end

	self:SetStatusBarColor(self.CONST.inactiveColor, self.CONST.colorLerpTime);

	self:SetLoadingAnimationPlayRate(duration);
	self:GotoOpenLoadingAnimState();
end

-- cyclical spawning
function MPGrenadePlacement:GetMarkerName(index:number):string
	return self.spawnMarker .. index;
end

function MPGrenadePlacement:IsSlotOccupied(index:number):boolean
	return self.spawnedItemList[index] ~= nil;
end

function MPGrenadePlacement:GetFirstOpenSlot():number
	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self.spawnedItemList[idx] == nil) then
			return idx;
		end
	end

	return -1;
end

function MPGrenadePlacement:AllSlotsAreFull():boolean
	return self:GetFirstOpenSlot() < 0;
end

function MPGrenadePlacement:AllSlotsAreEmpty():boolean
	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self.spawnedItemList[idx] ~= nil) then
			return false;
		end
	end

	return true;
end

function MPGrenadePlacement:GetObjectSlot(item:object):number
	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self.spawnedItemList[idx] == item) then
			return idx;
		end
	end

	return -1;
end

function MPGrenadePlacement:ShouldSelectNewRandomItem():boolean		-- override
	return self:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Respawn and self:ItemIsNotExplicitlySpecified() and self:AllSlotsAreEmpty();
end

function MPGrenadePlacement:GoToDormantState():void		-- override	
	self:DebugPrint("MPGrenadePlacement:GoToDormantState()");
	self:EnableIncomingEffect(false);
	self:EnableSpawnedEffect(false);
	self.deploymentState = DeploymentState.Dormant;
end

function MPGrenadePlacement:StartIncomingState():void		-- override
	self:DebugPrint("MPGrenadePlacement:StartIncomingState()");

	if (not self:AllSlotsAreEmpty()) then
		-- quick open spawn close, no incoming animation if just adding new grenade to the pile
		self.deploymentState = DeploymentState.Incoming;
		local incomingWaitTime:number = 0;

		if (self.CONFIG.isMessagingVisible) then
			incomingWaitTime = self.navpointDisplayDuration;
		else
			incomingWaitTime = self.incomingDuration;
		end

		self:EnableIncomingEffect(true);
		self:EnableSpawnedEffect(true);
		-- let's no longer play incoming while door open here to avoid stopping grenade rotation during incoming state
		SleepSeconds(incomingWaitTime - self.CONST.quickCloseDuration);		-- could use imminent spawn functions, but special cases would make that less efficient
		self:EnableSpawnedEffect(false);									-- will turn on again in StartSpawningState()
		self:PlayCloseAnimation();
		SleepSeconds(self.CONST.quickCloseDuration);
		self:StartSpawningState();
	else
		if (self:ShouldSelectNewRandomItem()) then
			-- only reshuffle if the pad is empty to avoid mix of grenades
			self:SetSpawningItem();
		end

		self:StartIncomingStateBase();
	end
end

function MPGrenadePlacement:TryCreateSingleItemObject(index:number):boolean
	if (self:IsSlotOccupied(index)) then
		self:DebugPrint("Unable to fill grenade slot ", index);
		return false;
	end

	local newItem:object = Engine_CreateObject(self.itemTag, Object_GetPosition(self.containerObject));

	if (newItem ~= nil) then
		Object_SetScale(newItem, self.itemScale + self.CONFIG.scaleFudgeFactor, 0);

		if (not self.hasInvisibleDispenser) then
			self:AttachItemToParent(self.containerObject, self:GetMarkerName(index), newItem, self.childMarker);
		else
			SetObjectTransform(newItem, GetObjectTransform(self.containerObject));
		end
	end

	self.spawnedItemList[index] = newItem;
	self.lastSpawnIndex = index;

	return true;
end

function MPGrenadePlacement:CreateItemObject():void				-- override
	if (self.CONFIG.spawnCyclically) then
		self:DebugPrint("MPGrenadePlacement:CreateItemObject() - Cyclically");

		local slot:number = self:GetFirstOpenSlot();

		if (slot > 0) then
			self:TryCreateSingleItemObject(slot);
			self:RegisterSingleSpawnedObject(slot);

			-- if there's still a slot open, let's start the process again until all grenades are on the pad
			if (self:GetSpawnLogic() ~= MP_SPAWN_LOGIC.FixedInterval and self.resetThread == nil and not self:AllSlotsAreFull()) then
				self:DebugPrint("Reset from cyclical spawn");
				self.resetThread = self:CreateThread(self.LifecycleResetRoutine, false);		-- don't close the doors as this is not a pickup situation
			end
		end
	else
		for idx = 1, self.CONFIG.groupCount, 1 do
			if (self:TryCreateSingleItemObject(idx)) then
				self:DebugPrint("MPGrenadePlacement:CreateItemObject() - En Masse", idx);
				self:RegisterSingleSpawnedObject(idx);
			end
		end
	end
end

function MPGrenadePlacement:ForceItemToCorrectScale():void		-- override
	for idx = 1, self.CONFIG.groupCount, 1 do
		if (self.spawnedItemList[idx] ~= nil) then
			Object_SetScale(self.spawnedItemList[idx], self.itemScale, 0);
		end
	end
end

function MPGrenadePlacement:SpawnWasSuccessful():boolean		-- override
	return self:IsSlotOccupied(self.lastSpawnIndex);
end

function MPGrenadePlacement:SetPostSpawnState():void			-- override
	self:DebugPrint("MPGrenadePlacement:SetPostSpawnState()");
	if (self:AllSlotsAreFull()) then
		self:GoToDormantState();
		self:EnableSpawnedEffect(true);
		self.deploymentState = DeploymentState.Spawned;
	else
		self.deploymentState = DeploymentState.Dormant;	-- don't want to mess with effect here as this is the quick open situation
	end
end

function MPGrenadePlacement:RegisterNewlySpawnedObject():void	-- override
end

function MPGrenadePlacement:DisableGroundEffect():void			-- override
	-- Grenades have no ground effect, so no-op here
end

function MPGrenadePlacement:RegisterSingleSpawnedObject(index:number):void
	if (index > 0) then
		local newGrenade:object = self.spawnedItemList[index];
		
		if (newGrenade ~= nil) then
			self:RegisterForDeployedEvents(newGrenade);
			self:RegisterForDeletionEvent(newGrenade);
		end
	end
end

-- OVERRIDES

function MPGrenadePlacement:ProcessOverrideDataSet(overrideData:MPEquipmentOverrideData):void	-- override
	self:ProcessOverrideDataSetEquipment(overrideData);

	if (overrideData.grenadeCount > 0) then
		self.CONFIG.groupCount = math.Bound(overrideData.grenadeCount, 1, 2);
	end

	if (overrideData.cyclicalSpawn == 0) then
		self.CONFIG.spawnCyclically = false;
	elseif (overrideData.cyclicalSpawn ~= self.CONST.noManagerOverride) then
		self.CONFIG.spawnCyclically = true;
	end
end

