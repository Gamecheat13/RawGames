-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_lua_events.lua');
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_manager.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_placement.lua');

global MPEquipmentLifecycleState = table.makeAutoEnum
{
	"Placed",
	"Carried",
	"Dropped",
};

hstructure EquipmentTrackingEntry
	definition			:MPEquipmentTableEntry
	equipment			:object
	unit				:object
	state				:number
end

--//////
-- Parcel Setup
--//////

global MPEquipmentPlacement:table = MPItemPlacement:CreateSubclass();

MPEquipmentPlacement.parcelName = "MPEquipmentPlacement";
MPEquipmentPlacement.className = nil;


MPEquipmentPlacement.spawnMarker = "spawn";
MPEquipmentPlacement.childMarker = "weapon_pad_offset";

MPEquipmentPlacement.CONFIG.intelNavpointIncomingColor = color_rgba(0.4, 0.4, 0.4, 0.1);
MPEquipmentPlacement.CONFIG.intelNavpointReadyColor = color_rgba(0.15, 1, 0.25, 1.0);

MPEquipmentPlacement.CONFIG.initialEnergyModifier = 1;

MPEquipmentPlacement.CONST.navpointPresentationNameItemType = "equipment";	-- override
MPEquipmentPlacement.CONST.navpointPresentationNameCamo = "camo";
MPEquipmentPlacement.CONST.navpointPresentationNameOverShield = "overshield";
MPEquipmentPlacement.CONST.equipmentGroundEffectFunctionName = "ground_pickup";
MPEquipmentPlacement.CONST.wakeWithinDistance = 25;
MPEquipmentPlacement.CONST.sleepBeyondDistance = 27;


function MPEquipmentPlacement:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function MPEquipmentPlacement:NewEquipmentPlacement(initArgs:MPEquipmentPlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMpEquipmentPlacement = self:NewItemPlacement(
		hmake MPItemPlacementInitArgs
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
			pingMessaging = initArgs.pingMessaging,
			containerObject = initArgs.containerObject,
			stockAnimDelay = initArgs.stockAnimDelay,
			incomingDuration = initArgs.incomingDuration,
			maxDeployedItemCount = initArgs.maxDeployedItemCount,
			hasInvisibleDispenser = initArgs.hasInvisibleDispenser,
			factionFilters = initArgs.factionFilters,
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
			legendaryItemUsage = initArgs.legendaryItemUsage,
			seedSequenceKey = initArgs.seedSequenceKey,
			staticSelection = initArgs.staticSelection,
		});

	newMpEquipmentPlacement.className = initArgs.equipmentType;

	if (newMpEquipmentPlacement.className == "Grenade") then
		newMpEquipmentPlacement.class = MP_EQUIPMENT_CLASS.Grenade;
	elseif (newMpEquipmentPlacement.className == "Base") then
		newMpEquipmentPlacement.class = MP_EQUIPMENT_CLASS.Equipment;
	elseif (newMpEquipmentPlacement.className == "Power") then
		newMpEquipmentPlacement.class = MP_EQUIPMENT_CLASS.PowerUp;
	else
		newMpEquipmentPlacement.categoryIsRandom = true;
	end

	if (initArgs.equipment ~= nil and initArgs.equipment ~= "Random (Default)") then
		newMpEquipmentPlacement.explicitIdentifier = newMpEquipmentPlacement:EquipmentStringToIdentifier(initArgs.equipment);
	end

	if (initArgs.energyModifier ~= nil) then
		newMpEquipmentPlacement.CONFIG.initialEnergyModifier = self:ConvertPercentageStringToNormalizedValue(initArgs.energyModifier);		-- will be clamped to a normalized value on set
	end

	return self:TryAndApplyPresets(newMpEquipmentPlacement, initArgs.spawnProperties);
end

function MPEquipmentPlacement:TryAndApplyPresets(newPlacement:table, spawnPropType:string):table
	if (spawnPropType == "Default") then
		local presets:table = GetMPEquipmentSpawnerPresets();
		local gameMode:number = GetItemSpawnerPresetGameModeType();

		local props:MPEquipmentPropertyPreset = presets[gameMode][newPlacement.class];

		if (props ~= nil) then
			newPlacement.CONFIG.spawnLogic = props.spawnLogic;
			newPlacement.CONFIG.respawnRandomFrequency = props.randomizeFreq;
			newPlacement.CONFIG.initialSpawnDelay = props.initialSpawnDelay;
			newPlacement.CONFIG.respawnTime = props.respawnTime;
			newPlacement.CONFIG.defaultIncomingDuration = math.max(props.respawnTime - newPlacement.CONST.mandatoryDormantPeriod, 0);
			newPlacement.CONFIG.maxDeployedItemCount = props.maxDeployedItemCount;
			newPlacement.CONFIG.initialEnergyModifier = props.energyModifier;
			
			newPlacement.factionFilters[MP_ITEM_FACTION.UNSC] = props.faction == MP_ITEM_FACTION.UNSC or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Banished] = props.faction == MP_ITEM_FACTION.Banished or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Forerunner] = props.faction == MP_ITEM_FACTION.Forerunner or props.faction == nil;
		end
	end

	return newPlacement;
end

function MPEquipmentPlacement:AcquireItemManager():void		-- override
	self.itemManager = _G["MPEquipmentManagerInstance"];
	self.canUseItemManager = self.itemManager ~= nil;
end

function MPEquipmentPlacement:InitializeImmediate():void	-- override
	self:InitializeImmediateEquipment();
end

function MPEquipmentPlacement:InitializeImmediateEquipment():void
	if (self.CONFIG.maxDeployedItemCount == 0) then
		self.CONFIG.maxDeployedItemCount = math.huge;
	end

	self:InitializeImmediateBase();

	if (self:IsEquipmentFlightBanned(self.explicitIdentifier)) then
		self:HandleBannedExplicitIdentifier();
	end
end

function MPEquipmentPlacement:Run():void
	--Run is used once the Parcel is officially kicked off.
	if self.CONFIG.isMessagingVisible and Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts") then
		RunClientScript("IntelMapSetEquipmentPlacementIcon", self.containerObject, "intel_map_icon_circle", self.CONFIG.intelNavpointIncomingColor);
		SleepSeconds(IntelMap_GetIntroEndTime() * 0.5);		--TODO: Tie this reveal to a hui event from olympus_multiplayer.user_interface_globals_definition once it's created
		RunClientScript("IntelMapSetEquipmentPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, self.itemStringId);
	end

	self:SleepUntilValid();

	self:CreateThread(self.InitializeContainer);
end

--
--	INTERNAL PARCEL LOGIC
--

function MPEquipmentPlacement:ItemIsNotExplicitlySpecified():boolean		-- override
	return self.explicitIdentifier == nil or
		not self.CONFIG.staticSelectionEnabled or
		self.explicitIdentifier == MP_EQUIPMENT_IDENTIFIER.None;
end

function MPEquipmentPlacement:HandleBannedExplicitIdentifier():void
	-- ok, we explicitly have specified banned equipment, let's use a fallback item
	if (MPEquipmentItemFallbacks[self.explicitIdentifier] ~= nil) then
		self.explicitIdentifier = MPEquipmentItemFallbacks[self.explicitIdentifier];

		if (self:IsEquipmentFlightBanned(self.explicitIdentifier)) then
			-- welp, our fallback was also banned so we'll just get anything that's available now and if there isn't any, you'll get the ultimate fall back
			self.explicitIdentifier = nil;
		end
	end
end

function MPEquipmentPlacement:AssignInitialItemTag():void	-- override
	SleepOneFrame();	-- let all placements register themselves with manager before making potential channel decisions

	local allEquipmentTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableEquipmentTable(allEquipmentTable);

	if (self:ItemIsExplicitlySpecified() or self:ShouldUseGamePersistentItem()) then
		self:AssignItemFromIdentifier(self.explicitIdentifier, allEquipmentTable);
	end

	-- If tag is not nil, that means we've saved previous round's tag because we're on 'Game' frequency or set explicitly above
	-- and if we have no available tiems, we'll just go to fallback item because equipment doesn't use fallback classes
	if (self.itemIdentifier == nil or self.itemTag == nil) then
		self:SetSpawningItem();
	end

	self:SetVariant();
end

function MPEquipmentPlacement:GetFullDefinitionTable():table		-- override
	return GetMPEquipmentPlacementTable(self.class);
end

function MPEquipmentPlacement:GetFallbackIdentifier():mp_equipment_identifier	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return MP_EQUIPMENT_IDENTIFIER.Camo;
	else
		return MP_EQUIPMENT_IDENTIFIER.Wall;
	end
end

function MPEquipmentPlacement:StockContainer():void		-- override
	if (self.CONFIG.isMessagingVisible or self.CONFIG.pingMessaging) then
		self:MessagingReady();
		if Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts") then
			RunClientScript("IntelMapSetEquipmentPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointReadyColor, self.itemStringId);
		end
	end

	self:StockContainerBase();
	self:RegisterNewlySpawnedObject();
	self:ModifyInitialEnergyLevel();
	self:DisableGroundEffect();
end

function MPEquipmentPlacement:RegisterNewlySpawnedObject():void		-- virtual
	if (self.spawnedItemObject ~= nil) then
		self:RegisterForDeployedEvents(self.spawnedItemObject);
		self:RegisterForDeletionEvent(self.spawnedItemObject);
	end
end

function MPEquipmentPlacement:DisableGroundEffect():void			-- virtual
	Object_SetFunctionValue(self.spawnedItemObject, self.CONST.equipmentGroundEffectFunctionName, 0, 0);
end

function MPEquipmentPlacement:ModifyInitialEnergyLevel():void
	if (self.CONFIG.initialEnergyModifier == 1) then
		return;
	end

	local initialEquipEnergy = Equipment_GetInitialEnergy(self.spawnedItemObject);
	initialEquipEnergy = math.Bound(initialEquipEnergy * self.CONFIG.initialEnergyModifier, 0, 1);
	Equipment_SetPickupEnergyToNearestCharge(self.spawnedItemObject, initialEquipEnergy);
end

function MPEquipmentPlacement:AddSpawnedItemToDeployedList():void	-- override
	self:CreateTrackingData();
end

function MPEquipmentPlacement:CreateTrackingData():void		-- virtual
	local entry = hmake EquipmentTrackingEntry
	{
		definition = self:GetCurrentEquipmentDefinition(),
		equipment = self.spawnedItemObject,
		unit = nil,
		state = MPEquipmentLifecycleState.Placed,
	};

	table.insert(self.deployedItems, entry);

	if (self.canUseItemManager) then
		self.itemManager:OnItemSpawned(self.itemIdentifier);
	end

	self:DebugPrint("Adding deployed item: ", self.itemIdentifier);
end

function MPEquipmentPlacement:ModifyTrackingDataOnPickup(pickedUpEquipment:object, lootingUnit:object):void
	for _, data in ipairs (self.deployedItems) do
		if (data.state ~= MPEquipmentLifecycleState.Carried and self:AreObjectsEqual(data.equipment, pickedUpEquipment)) then
			self:DebugPrint("MPEquipmentPlacement:ModifyTrackingDataOnPickup(): ", pickedUpEquipment);

			data.unit = lootingUnit;
			data.equipment = nil;
			data.state = MPEquipmentLifecycleState.Carried;
			break;
		end
	end
end

function MPEquipmentPlacement:IsAttachmentInDefinition(attachmentTag:tag, itemDef:MPEquipmentTableEntry):boolean
	if (attachmentTag == itemDef.attachmentTag) then
		return true;
	end

	if (itemDef.legendaryVariantAttachments ~= nil) then
		for i, variantAttach in ipairs(itemDef.legendaryVariantAttachments) do
			if (variantAttach == attachmentTag) then
				return true;
			end
		end
	end

	return false;
end

function MPEquipmentPlacement:RemoveTrackingDataOnItemUse(detachedItem:tag, usingUnit:object):void
	for _, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Carried and self:IsAttachmentInDefinition(detachedItem, data.definition) and data.unit == usingUnit) then
			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.definition.identifier);
			end

			table.removeValue(self.deployedItems, data);

			self:DebugPrint("MPEquipmentPlacement:RemoveTrackingDataOnItemUse(): ", data.definition.tag, " Remaining: ", table.countKeys(self.deployedItems));

			self:UnregisterForUsageEvents();

			if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.DynamicOnExpire) then
				self.lifecycleThread = self:CreateThread(self.RestartLifecycle);
			elseif (self.deploymentState == DeploymentState.Restricted and self:CanDeploy()) then
				self.delayedResetThread = self:CreateThread(self.DelayedResetRoutine);
			end
			break;
		end
	end
end

function MPEquipmentPlacement:RemoveTrackingDataOnReplenish(replenisherEquipment:object, usingUnit:object):void
	for _, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Placed and self:AreObjectsEqual(data.equipment, replenisherEquipment)) then
			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.definition.identifier);
			end

			table.removeValue(self.deployedItems, data);

			self:DebugPrint("MPEquipmentPlacement:RemoveTrackingDataOnReplenish(): ", data.definition.tag, " Remaining: ", table.countKeys(self.deployedItems));
			break;
		end
	end
end

function MPEquipmentPlacement:ModifyTrackingDataOnDrop(detachedItem:tag, droppingUnit:object, newPickups:table):void
	local foundTracking:boolean = false;

	for _, data in ipairs (self.deployedItems) do
		if (data.state == MPEquipmentLifecycleState.Carried and self:IsAttachmentInDefinition(detachedItem, data.definition) and data.unit == droppingUnit) then

			self:DebugPrint("MPEquipmentPlacement:ModifyTrackingDataOnDrop(): ", droppingUnit, data.definition.tag);
			foundTracking = true;

			self:UnregisterForUsageEvents();

			if (#newPickups > 0) then
				data.state = MPEquipmentLifecycleState.Dropped;
				data.unit = droppingUnit;
				data.equipment = newPickups[1];

				self:RegisterForDeployedEvents(data.equipment);
				self:RegisterForDeletionEvent(data.equipment);
			else
				print("Warning: no pickups spawning OnDrop");
			end
			break;
		end
	end

	if (not foundTracking) then
		print("Error: Unable to locate", self.instanceName, "OnDrop tracking data for", detachedItem);
	end
end

function MPEquipmentPlacement:OnEquipmentPickedUp(pickedUpEquipment:object, unit:object)
	self:ModifyTrackingDataOnPickup(pickedUpEquipment, unit);

	-- was this the item on the pad? then restart cycle. otherwise, this was a dropped item and should be tracked, but cause no lifecycle change to spawner 
	
	-- stop listening for pickup of the item on the pad, either because picked up or replenished from
	self:UnregisterForDeployedEvents(pickedUpEquipment);
	self:UnregisterForDeletionEvent(pickedUpEquipment);

	-- object was just deleted, now keep track that this specific player is "carrying" the equipment
	self:RegisterForUsageEvents();

	if (self:AreObjectsEqual(pickedUpEquipment, self.spawnedItemObject)) then
		self:GoToDormantState();

		self.resetThread = self:CreateThread(self.LifecycleResetRoutine);

		if (self.CONFIG.isMessagingVisible) then
			self:MessagingPickedUp(unit);
			local navText:string = self.CONFIG.navpointIncomingText .. (self.itemStringId or "");
			RunClientScript("IntelMapSetEquipmentPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, navText);
		end

		self.spawnedItemObject = nil;
	end
end

function MPEquipmentPlacement:HandleEquipmentAttachedEvent(eventArgs:ObjectFrameAttachmentAttachedEventStruct):void
	self:DebugPrint("MPEquipmentPlacement:HandleEquipmentAttachedEvent(): ", eventArgs.unit, eventArgs.pickedUpEquipment, eventArgs.attachedImplementation);
	self:OnEquipmentPickedUp(eventArgs.pickedUpEquipment, eventArgs.unit);
end

function MPEquipmentPlacement:HandleEquipmentReplenishEvent(eventArgs:ObjectFrameAttachmentReplenishedEventStruct):void
	self:DebugPrint("MPEquipmentPlacement:HandleEquipmentReplenishEvent(): ", eventArgs.unit, eventArgs.replenisherEquipment, eventArgs.attachedImplementation);

	local replenisherOnPad:boolean = self:AreObjectsEqual(eventArgs.replenisherEquipment, self.spawnedItemObject);

	if (eventArgs.wasDepleted and replenisherOnPad) then
		-- treat this like a regular pickup event
		self:OnEquipmentPickedUp(eventArgs.replenisherEquipment, eventArgs.unit);
	else
		-- we should stop tracking this because it was used up refilling another one
		self:RemoveTrackingDataOnReplenish(eventArgs.replenisherEquipment, eventArgs.unit);

		-- we replenished from the one on the pad and should start cycle again
		if (replenisherOnPad) then
			if (self.deploymentState == DeploymentState.Restricted and self:CanDeploy()) then
				self.delayedResetThread = self:CreateThread(self.DelayedResetRoutine);
			else
				self:GoToDormantState();
				self.resetThread = self:CreateThread(self.LifecycleResetRoutine);
			end

			self.spawnedItemObject = nil;
		end
	end
end

function MPEquipmentPlacement:HandleEquipmentDetachedEvent(eventArgs:ObjectFrameAttachmentDeletedEventStruct):void
	self:DebugPrint("MPEquipmentPlacement:HandleEquipmentDetachedEvent(): ", eventArgs.unit, eventArgs.detachedImplementation, #eventArgs.spawnedObjects);

	if (#eventArgs.spawnedObjects == 0) then
		self:RemoveTrackingDataOnItemUse(eventArgs.detachedImplementation, eventArgs.unit);							-- Equipment deleted and nothing spawned in its place
	else
		for _, obj in hpairs(eventArgs.spawnedObjects) do
			Object_RegisterForCandyMonitorGarbageCollection(obj);
		end

		self:ModifyTrackingDataOnDrop(eventArgs.detachedImplementation, eventArgs.unit, eventArgs.spawnedObjects);	-- Equipment deleted and pinata'd new pickups
	end
end

function MPEquipmentPlacement:HandleAbilityExhaustionEvent(eventArgs:EquipmentAbilityExhaustedEventStruct):void
	self:DebugPrint("MPEquipmentPlacement:HandleAbilityExhaustionEvent(): ", eventArgs.unit, eventArgs.equipmentTag);
	self:RemoveTrackingDataOnItemUse(eventArgs.equipmentTag, eventArgs.unit);
end

function MPEquipmentPlacement:HandleEquipmentGrappledEvent(eventArgs:GrappleReelInItemInitiatedEventStruct):void
	self:DebugPrint("Equipment grappled out of container: ", eventArgs.item);
	self:OnEquipmentPickedUp(eventArgs.item, eventArgs.playerUnit);
end

function MPEquipmentPlacement:OnObjectDeleted(eventArgs:ObjectDeletedStruct):void
	for _, data in ipairs (self.deployedItems) do
		if (self:AreObjectsEqual(data.equipment, eventArgs.deletedObject) and data.state == MPEquipmentLifecycleState.Dropped) then
			self:DebugPrint("MPEquipmentPlacement:OnObjectDeleted(): ", eventArgs.deletedObject);

			if (self.canUseItemManager) then
				self.itemManager:OnItemCleanedUp(data.definition.identifier);
			end

			table.removeValue(self.deployedItems, data);

			if (self.deploymentState == DeploymentState.Restricted and self:CanDeploy()) then
				self.delayedResetThread = self:CreateThread(self.DelayedResetRoutine);
			end
			break;
		end
	end

	self:UnregisterForDeletionEvent(eventArgs.deletedObject);
end

function MPEquipmentPlacement:RegisterForDeployedEvents(theObject:object):void		-- virtual
	self:RegisterEventOnSelf(g_eventTypes.objectFrameAttachmentAttachedEvent, self.HandleEquipmentAttachedEvent, theObject);
	self:RegisterEventOnSelf(g_eventTypes.objectFrameAttachmentReplenishedEvent, self.HandleEquipmentReplenishEvent, theObject);
	self:RegisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleEquipmentGrappledEvent, theObject);
end

function MPEquipmentPlacement:UnregisterForDeployedEvents(theObject:object):void	-- virtual
	self:UnregisterEventOnSelf(g_eventTypes.objectFrameAttachmentAttachedEvent, self.HandleEquipmentAttachedEvent, theObject);
	self:UnregisterEventOnSelf(g_eventTypes.objectFrameAttachmentReplenishedEvent, self.HandleEquipmentReplenishEvent, theObject);
	self:UnregisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleEquipmentGrappledEvent, theObject);
end

function MPEquipmentPlacement:RegisterForUsageEvents():void		-- virtual
	self:RegisterGlobalEventOnSelf(g_eventTypes.objectFrameAttachmentDeletedEvent, self.HandleEquipmentDetachedEvent);
	self:RegisterGlobalEventOnSelf(g_eventTypes.equipmentAbilityEnergyExhaustedCallback, self.HandleAbilityExhaustionEvent);
	self:RegisterGlobalEventOnSelf(g_eventTypes.spartanAbilityEnergyExhaustedCallback, self.HandleAbilityExhaustionEvent);
end

function MPEquipmentPlacement:UnregisterForUsageEvents():void
	self:UnregisterGlobalEventOnSelf(g_eventTypes.objectFrameAttachmentDeletedEvent, self.HandleEquipmentDetachedEvent);
	self:UnregisterGlobalEventOnSelf(g_eventTypes.equipmentAbilityEnergyExhaustedCallback, self.HandleAbilityExhaustionEvent);
	self:UnregisterGlobalEventOnSelf(g_eventTypes.spartanAbilityEnergyExhaustedCallback, self.HandleAbilityExhaustionEvent);
end

function MPEquipmentPlacement:RegisterForDeletionEvent(theObject:object):void
	self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, theObject);
end

function MPEquipmentPlacement:UnregisterForDeletionEvent(theObject:object):void
	self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, theObject);
end

function MPEquipmentPlacement:AssignItemFromDefinition(itemDef:MPEquipmentTableEntry):void	-- override
	self:AssignItemFromDefinitionBase(itemDef);
	self:TryAndAssignLegendaryVariant(itemDef);
	self.class = itemDef.class;
end

function MPEquipmentPlacement:AssignLegendaryVariantFromTag(itemDef:MPEquipmentTableEntry, legendaryIdx:number):void		-- override
	self:DebugPrint("MPEquipmentPlacement:AssignLegendaryVariantFromTag");

	if (itemDef.legendaryVariants ~= nil and legendaryIdx <= #itemDef.legendaryVariants) then
		self.itemTag = itemDef.legendaryVariants[legendaryIdx];
	end

	if (itemDef.legendaryVariantAttachments ~= nil and legendaryIdx <= #itemDef.legendaryVariantAttachments) then
		self.attachmentTag = itemDef.legendaryVariantAttachments[legendaryIdx];
	end
end

function MPEquipmentPlacement:GenerateAvailableEquipmentTable(equipmentTable:table):void
	self.availableItemTable = {}; 
	for id, equip in hpairs (equipmentTable) do
		local classCheck:boolean = self.class == nil or equip.class == self.class;
		local factionCheck:boolean = self.factionFilters[equip.faction] or false;

		if (classCheck and factionCheck and not self:IsEquipmentFlightBanned(equip.identifier)) then
			self.availableItemTable[id] = equip;
		end
	end
end

function MPEquipmentPlacement:IsEquipmentFlightBanned(equipID:mp_equipment_identifier):boolean
	return MultiplayerItems_LimitForFlighting and table.contains(MPFlightingProhibitedEquipment, equipID);
end

function MPEquipmentPlacement:RebuildAvailableItemTable():void						-- override
	self.availableItemTable = {};
	local allEquipmentTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableEquipmentTable(allEquipmentTable);
end

function MPEquipmentPlacement:EnsureLegitimateFactionFilters():void					-- override
	-- Grenades can be UNSC/Banished. Equipment and PowerUps can only be UNSC. Let's not deal with a situation where nothing valid is allowed
	local noValidFactions:boolean = self.class ~= MP_EQUIPMENT_CLASS.Grenade or
									(not self.factionFilters[MP_ITEM_FACTION.UNSC] and
									 not self.factionFilters[MP_ITEM_FACTION.Banished]);

	if (noValidFactions) then
		self.factionFilters[MP_ITEM_FACTION.UNSC] = true;
	end
end

function MPEquipmentPlacement:GetCurrentEquipmentDefinition():MPEquipmentTableEntry 
	local allEquipmentTable:table = self:GetFullDefinitionTable();

	for equipmentId, equip in hpairs (allEquipmentTable) do
		if (equip.tag == self.itemTag) then
			return equip;
		else
			for i, variantTag in ipairs(equip.legendaryVariants) do
				if (variantTag == self.itemTag) then
					return equip;
				end
			end
		end
	end

	return nil;
end

function MPEquipmentPlacement:EquipmentStringToIdentifier(equip:string):mp_equipment_identifier
	if (equip == "Thruster") then
		return MP_EQUIPMENT_IDENTIFIER.Evade;
	elseif (equip == "Grappleshot") then
		return MP_EQUIPMENT_IDENTIFIER.Grapple;
	elseif (equip == "Repulsor") then
		return MP_EQUIPMENT_IDENTIFIER.Knockback;
	elseif (equip == "Threat Sensor") then
		return MP_EQUIPMENT_IDENTIFIER.LocSensor;
	elseif (equip == "Drop Wall") then
		return MP_EQUIPMENT_IDENTIFIER.Wall;
	elseif (equip == "Frag Grenade") then
		return MP_EQUIPMENT_IDENTIFIER.FragGrenade;
	elseif (equip == "Dynamo Grenade") then
		return MP_EQUIPMENT_IDENTIFIER.DynamoGrenade;
	elseif (equip == "Plasma Grenade") then
		return MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade;
	elseif (equip == "Spike Grenade") then
		return MP_EQUIPMENT_IDENTIFIER.SpikeGrenade;
	elseif (equip == "Active Camouflage") then
		return MP_EQUIPMENT_IDENTIFIER.Camo;
	elseif (equip == "Overshield") then
		return MP_EQUIPMENT_IDENTIFIER.OverShield;
	else
		return nil;
	end
end

function MPEquipmentPlacement:CurrentEquipmentIdentifierAsString():string
	if (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Evade) then
		return "Thruster";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Grapple) then
		return "Grappleshot";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Knockback) then
		return "Repulsor";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.LocSensor) then
		return "Threat Sensor";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Wall) then
		return "Drop Wall";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.FragGrenade) then
		return "Frag Grenade";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.DynamoGrenade) then
		return "Dynamo Grenade";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade) then
		return "Plasma Grenade";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.SpikeGrenade) then
		return "Spike Grenade";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Camo) then
		return "Active Camouflage";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.OverShield) then
		return "Overshield";
	else
		return nil;
	end
end

function MPEquipmentPlacement:CurrentEquipmentIdentifierAsWeaponConstantID():string
	if (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Camo) then
		return "active_camo";
	elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.OverShield) then
		return "overshield";
	else
		return nil;
	end
end

function MPEquipmentPlacement:OnPlacementHide():void	-- override
	if (self.spawnedItemObject ~= nil) then
		self:UnregisterForDeletionEvent(self.spawnedItemObject);
		self:UnregisterForDeployedEvents(self.spawnedItemObject);
	end
end

function MPEquipmentPlacement:OnPlacementShow():void	-- override
	self:CreateThread(self.InitializeContainer);
end

function MPEquipmentPlacement:GetHologramLoopingSound():tag	-- override
	return MPItemSpawnerAudioAssets.equipmentHologramLoop;
end

function MPEquipmentPlacement:SetVariant():void	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		object_set_variant(self.containerObject, self.CONST.defaultVariantName);
	else
		object_set_variant(self.containerObject, self.CONST.downgradedVariantName);
	end
end

-- OVERRIDES

function MPEquipmentPlacement:HandleOverrideReceived(itemManager:table):void	-- override
	if (not self.canUseItemManager or self.itemManager ~= itemManager) then
		return;
	end

	-- have we overridden the class? if so, swap it
	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None and self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class ~= MP_EQUIPMENT_CLASS.None) then
		self.class = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class;
	end

	-- ok, now that that's been sorted, let's override by class, channel and then global

	if (self.class ~= nil and self.class ~= MP_EQUIPMENT_CLASS.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perClassOverrides[self.class]);
	end

	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId]);
	end

	self:ProcessOverrideDataSet(self.itemManager.CONFIG.globalOverrides);

	self:EnsureLegitimateFactionFilters();
end

function MPEquipmentPlacement:ProcessOverrideDataSet(overrideData:MPEquipmentOverrideData):void		-- virtual
	self:ProcessOverrideDataSetEquipment(overrideData);
end

function MPEquipmentPlacement:ProcessOverrideDataSetEquipment(overrideData:MPEquipmentOverrideData):void
	self:ProcessOverrideDataSetBase(
		hmake MPItemOverrideData
		{
			spawnLogic = overrideData.spawnLogic,
			randomizeFrequency = overrideData.randomizeFrequency,
			legendaryItemUsage = overrideData.legendaryItemUsage,
			maxDeployCount = overrideData.maxDeployCount,
			factionFilters = overrideData.factionFilters,
			navpoint = overrideData.navpoint,
			initialSpawnDelay = overrideData.initialSpawnDelay,
			respawnTime = overrideData.respawnTime,
			seedSequenceKey = overrideData.seedSequenceKey,
			staticSelection = overrideData.staticSelection,
		});

	if (overrideData.initialEnergyCharge > 0) then
		self.CONFIG.initialEnergyCharge = overrideData.initialEnergyCharge;
	end

	if (overrideData.forceRandomItem) then
		self.explicitIdentifier = nil;
	elseif (overrideData.equipment ~= MP_EQUIPMENT_IDENTIFIER.None) then
		self:TryOverridingItemFromIdentifier(overrideData.equipment);
	end
end

function MPEquipmentPlacement:TryOverridingItemFromIdentifier(overrideIdentifier:mp_equipment_identifier):void
	local equipTable:table = self:GetFullDefinitionTable();
	self:AssignItemFromIdentifier(overrideIdentifier, equipTable);
end

function MPEquipmentPlacement:TryOverridingItem():boolean	-- override
	local overridden:boolean = false;
	local overrideData:MPEquipmentOverrideData = nil;

	if (self.canUseItemManager) then
		if (self.class ~= nil) then
			overrideData = self.itemManager.CONFIG.perClassOverrides[self.class];
			if (not overrideData.forceRandomItem and overrideData.equipment ~= MP_EQUIPMENT_IDENTIFIER.None) then
				self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perClassOverrides[self.class].equipment);
				overridden = true;
			end
		end

		if (self.selectiveChannelId ~= nil) then
			overrideData = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId];
			if (not overrideData.forceRandomItem and overrideData.equipment ~= MP_EQUIPMENT_IDENTIFIER.None) then
				self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].equipment);
				overridden = true;
			end
		end
	end

	return overridden;
end

-- NAVPOINTS

function MPEquipmentPlacement:GetNavpointPresentationTierName():string		-- override
	if (self.deploymentState == DeploymentState.Incoming) then
		return self.CONST.navpointPresentationNameRecharging;
	end

	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return self.CONST.navpointPresentationNamePower;
	else
		return self.CONST.navpointPresentationNameGeneral;
	end
end

function MPEquipmentPlacement:GetNavpointPresentationItemType():string	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		if (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.Camo) then
			return self.CONST.navpointPresentationNameCamo;
		elseif (self.itemIdentifier == MP_EQUIPMENT_IDENTIFIER.OverShield) then
			return self.CONST.navpointPresentationNameOverShield;
		end
	end

	return self.CONST.navpointPresentationNameItemType;
end


-- MESSAGING 

function MPEquipmentPlacement:MessagingIncoming():void	-- override
	self:MessagingIncomingBase();
	
	local incomingEquipment:string = self:CurrentEquipmentIdentifierAsWeaponConstantID();

	if (self.canUseItemManager and self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		self.itemManager:PlayVO(
			hmake MPItemSpawnerPendingVOData
			{
				responseName	= "__OnEquipmentPadIncoming",
				itemName		= incomingEquipment,
				itemType		= MPItemGroupType.Equipment,
				voType			= MPItemVOType.Incoming,
			});
	else
		MPLuaCall("__OnEquipmentPadIncoming", incomingEquipment);
	end
end

function MPEquipmentPlacement:MessagingReady():void	-- override
	self:MessagingReadyBase();

	if (not self.canDisplayReadyMessage) then
		return;
	end

	local spawnedEquipment:string = self:CurrentEquipmentIdentifierAsWeaponConstantID();

	if (self.canUseItemManager and self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		self.itemManager:PlayVO(
			hmake MPItemSpawnerPendingVOData
			{
				responseName	= "__OnEquipmentPadReady",
				itemName		= spawnedEquipment,
				itemType		= MPItemGroupType.Equipment,
				voType			= MPItemVOType.Ready,
			});
	else
		MPLuaCall("__OnEquipmentPadReady", spawnedEquipment);
	end
end

-- EFFECTS

function MPEquipmentPlacement:GetIncomingEffect():tag	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return self.incomingParticleFX;
	else
		return self.altIncomingParticleFX;
	end
end

function MPEquipmentPlacement:GetSpawnedEffect():tag	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return self.spawnedParticleFX;
	else
		return self.altSpawnedParticleFX;
	end
end

function MPEquipmentPlacement:GetHologramPreviewColor():object_runtime_hologram_color	-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Gold;
	else
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Blue;
	end
end

function MPEquipmentPlacement:GetRezInEffect():tag		-- override
	if (self.class == MP_EQUIPMENT_CLASS.PowerUp) then
		return MPItemSpawnerRezInEffects.powerItem;
	else
		return MPItemSpawnerRezInEffects.baseItem;
	end
end

function MPEquipmentPlacement:MessagingPickedUp(lootingPlayer:player):void	-- override
	self:MessagingPickedUpBase(lootingPlayer);
	-- MPLuaCall("__OnEquipmentPadPickedUp", lootingPlayer);
end

--## CLIENT

function remoteClient.IntelMapSetEquipmentPlacementIcon(equipmentPadObject:object, equipmentIcon:string_id, iconColor:color_rgba, equipmentName:string_id):void
	iconColor = iconColor or UI_GetBitmapColorForDisposition(DISPOSITION.Neutral);
	IntelMapSetColoredIcon(equipmentIcon, "intel_map_icon_hexagon_bg", equipmentName, iconColor, equipmentPadObject);
end

