-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_lua_events.lua');
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_manager.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_placement.lua');

--//////
-- Parcel Setup
--//////

global MPVehiclePlacement:table = MPItemPlacement:CreateSubclass();

MPVehiclePlacement.parcelName = "MPVehiclePlacement";
MPVehiclePlacement.className = nil;
MPVehiclePlacement.terrainFilters = {};
MPVehiclePlacement.initialContainerPosition = nil;
MPVehiclePlacement.initialForwardDir = nil;
MPVehiclePlacement.initialUpDir = nil;
MPVehiclePlacement.minTravelDistanceSq = 0;
MPVehiclePlacement.leavePadThread = nil;
MPVehiclePlacement.hologramScale = 1;
MPVehiclePlacement.verticalOffset = nil;

MPVehiclePlacement.CONFIG.intelNavpointIncomingColor = color_rgba(0.4, 0.4, 0.4, 0.1);
MPVehiclePlacement.CONFIG.intelNavpointReadyColor = color_rgba(0.15, 1, 0.25, 1.0);

MPVehiclePlacement.CONFIG.imminentCheckDuration = 0.25;	-- amount of time before vehicle becomes available where we check if pad is obstructed and begin scale up of hologram
MPVehiclePlacement.CONFIG.avoidanceSpeed = 3;
MPVehiclePlacement.CONFIG.defaultPadVerticalOffset = 0.15;		-- distance above the pad the place the vehicle to guarantee the wheels don't end up underground

MPVehiclePlacement.CONST.minTravelDistanceForExit = 0.5;
MPVehiclePlacement.CONST.boundaryHeight = 3;
MPVehiclePlacement.CONST.navpointPresentationNameItemType = "vehicle";	-- override


function MPVehiclePlacement:NewVehiclePlacement(initArgs:MPVehiclePlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMpVehiclePlacement = self:NewItemPlacement(
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

	newMpVehiclePlacement.className = initArgs.vehicleClass;

	if (newMpVehiclePlacement.className == "Support") then
		newMpVehiclePlacement.class = MP_VEHICLE_CLASS.Support;
	elseif (newMpVehiclePlacement.className == "Duelist") then
		newMpVehiclePlacement.class = MP_VEHICLE_CLASS.Duelist;
	elseif (newMpVehiclePlacement.className == "Cavalry") then
		newMpVehiclePlacement.class = MP_VEHICLE_CLASS.Cavalry;
	elseif (newMpVehiclePlacement.className == "Siege") then
		newMpVehiclePlacement.class = MP_VEHICLE_CLASS.Siege;
	else
		newMpVehiclePlacement.categoryIsRandom = true;
	end

	if (initArgs.vehicle ~= nil and initArgs.vehicle ~= "Random (Default)") then
		newMpVehiclePlacement.explicitIdentifier = newMpVehiclePlacement:VehicleStringToIdentifier(initArgs.vehicle);
	end

	newMpVehiclePlacement.terrainFilters = initArgs.terrainFilters;

	return self:TryAndApplyPresets(newMpVehiclePlacement, initArgs.spawnProperties);
end

function MPVehiclePlacement:TryAndApplyPresets(newPlacement:table, spawnPropType:string):table
	if (spawnPropType == "Default") then
		local presets:table = GetMPVehicleSpawnerPresets();
		local gameMode:number = GetItemSpawnerPresetGameModeType();

		local props:MPVehiclePropertyPreset = presets[gameMode][newPlacement.class];

		if (props ~= nil) then
			newPlacement.CONFIG.spawnLogic = props.spawnLogic;
			newPlacement.CONFIG.respawnRandomFrequency = props.randomizeFreq;
			newPlacement.CONFIG.initialSpawnDelay = props.initialSpawnDelay;
			newPlacement.CONFIG.respawnTime = props.respawnTime;
			newPlacement.CONFIG.defaultIncomingDuration = math.max(props.respawnTime - newPlacement.CONST.mandatoryDormantPeriod, 0);
			newPlacement.CONFIG.maxDeployedItemCount = props.maxDeployedItemCount;
			
			newPlacement.factionFilters[MP_ITEM_FACTION.UNSC] = props.faction == MP_ITEM_FACTION.UNSC or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Banished] = props.faction == MP_ITEM_FACTION.Banished or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Forerunner] = props.faction == MP_ITEM_FACTION.Forerunner or props.faction == nil;
		end
	end

	return newPlacement;
end

function MPVehiclePlacement:AcquireItemManager():void	-- override
	self.itemManager = _G["MPVehicleManagerInstance"];
	self.canUseItemManager = self.itemManager ~= nil;
end

function MPVehiclePlacement:InitializeImmediate():void	-- override
	if (self.CONFIG.maxDeployedItemCount == 0) then
		self.CONFIG.maxDeployedItemCount = math.huge;
	end

	self:InitializeImmediateBase();

	if (self:IsVehicleFlightBanned(self.explicitIdentifier)) then
		self:HandleBannedExplicitIdentifier();
	end
end

function MPVehiclePlacement:Run():void
	--Run is used once the Parcel is officially kicked off.
	if self.CONFIG.isMessagingVisible and Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts") then
		RunClientScript("IntelMapSetVehiclePlacementIcon", self.containerObject, "intel_map_icon_circle", self.CONFIG.intelNavpointIncomingColor);
		SleepSeconds(IntelMap_GetIntroEndTime() * 0.5);		--TODO: Tie this reveal to a hui event from olympus_multiplayer.user_interface_globals_definition once it's created
		RunClientScript("IntelMapSetVehiclePlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, self.itemStringId);
	end

	self:SleepUntilValid();

	self:CreateThread(self.InitializeContainer);
end

--
--	INTERNAL PARCEL LOGIC
--

function MPVehiclePlacement:InitializeContainer():void	-- override
	if (self.containerObject ~= nil) then
		self.initialContainerPosition = GetObjectTransform(self.containerObject);
		self.initialForwardDir = Object_GetForward(self.containerObject);
		self.initialUpDir = Object_GetUp(self.containerObject);
		self.minTravelDistanceSq = math.pow(self.CONST.minTravelDistanceForExit, 2);
		self:InitializeContainerBase();
	end
end

function MPVehiclePlacement:ItemIsNotExplicitlySpecified():boolean		-- override
	return self.explicitIdentifier == nil or
		not self.CONFIG.staticSelectionEnabled or
		self.explicitIdentifier == MP_VEHICLE_IDENTIFIER.None;
end

function MPVehiclePlacement:HandleBannedExplicitIdentifier():void
	-- ok, we explicitly have specified a banned vehicle, let's find another one from that vehicle's class or fallback class if possible
	local allVehiclesTable:table = self:GetFullDefinitionTable();
	local itemDef:MPVehicleTableEntry = allVehiclesTable[self.explicitIdentifier];

	if (itemDef ~= nil) then
		self.class = itemDef.class;
		self:GenerateAvailableVehicleTable(allVehiclesTable);
				
		if (table.countKeys(self.availableItemTable) > 0) then
			-- something from our own class is available
			self.explicitIdentifier = table.anyVal(self.availableItemTable).identifier;
		else
			-- change class to fallback (if one exists), try again
			local fallbackClass:mp_vehicle_class = MPVehicleClassFallbacks[itemDef.class];

			if (fallbackClass ~= nil) then
				self.class = fallbackClass;
				self:GenerateAvailableVehicleTable(allVehiclesTable);
				
				if (table.countKeys(self.availableItemTable) > 0) then
					self.explicitIdentifier = table.anyVal(self.availableItemTable).identifier;
				end
			end
		end
	end
end

function MPVehiclePlacement:AssignInitialItemTag():void	-- override
	SleepOneFrame();	-- let all placements register themselves with manager before making potential channel decisions

	local allVehicleTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableVehicleTable(allVehicleTable);

	if (self:ItemIsExplicitlySpecified() or self:ShouldUseGamePersistentItem()) then
		self:AssignItemFromIdentifier(self.explicitIdentifier, allVehicleTable);
	elseif (table.countKeys(self.availableItemTable) == 0 and self.class ~= nil) then
		-- we've got nothing to choose from here. change class to fallback (if one exists), try again
		local fallbackClass:mp_vehicle_class = MPVehicleClassFallbacks[self.class];

		if (fallbackClass ~= nil) then
			self.class = fallbackClass;
			self:GenerateAvailableVehicleTable(allVehicleTable);
		end
	end

	-- If tag is not nil, that means we've saved previous round's tag because we're on 'Game' frequency or set explicitly above
	if (self.itemIdentifier == nil or self.itemTag == nil) then
		self:SetSpawningItem();
	end

	self:SetVariant();
end

function MPVehiclePlacement:AssignItemFromDefinition(itemDef:MPVehicleTableEntry):void	-- override
	self:AssignItemFromDefinitionBase(itemDef);

	self.itemConfig = itemDef.config;
	self:TryAndAssignLegendaryVariant(itemDef);
	self.class = itemDef.class;
	self.hologramScale = itemDef.hologramScale;
	self.verticalOffset = itemDef.verticalOffset;

	local boundary:mp_object_boundary = CreateNewBoundary(BOUNDARY_TYPE.Cylinder, itemDef.clearance, self.CONST.boundaryHeight);	-- clearance is a diameter here
	if (boundary ~= nil) then
		Object_SetBoundary(self.containerObject, boundary);
	end
end

function MPVehiclePlacement:GetFullDefinitionTable():table		-- override
	return GetMPVehiclePlacementTable();
end

function MPVehiclePlacement:GetFallbackIdentifier():mp_vehicle_identifier		-- override
	return MP_VEHICLE_IDENTIFIER.Mongoose;
end

function MPVehiclePlacement:StockContainer():void	-- override
	if (self.CONFIG.isMessagingVisible or self.CONFIG.pingMessaging) then
		self:MessagingReady();
		if Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts") then
			RunClientScript("IntelMapSetVehiclePlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointReadyColor, self.itemStringId);
		end
	end

	self:StockContainerBase();

	if (self.spawnedItemObject ~= nil) then
		self:RegisterEventOnSelf(g_eventTypes.deathEvent, self.OnVehicleDestroyed, self.spawnedItemObject);
		self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.spawnedItemObject);
	end

	self.leavePadThread = self:CreateThread(self.CheckForVehicleExitPad);
end

function MPVehiclePlacement:GetImminentSpawnCheckDuration():number	--override
	return self.CONFIG.imminentCheckDuration;
end

function MPVehiclePlacement:CreateItemObject():void		-- override
	self.spawnedItemObject = Object_CreateFromTagWithConfigurationAndLocation(self.itemTag, self.itemConfig, self:GetDesiredVehiclePositionOnPad());

	Object_SetRotation(self.spawnedItemObject, self.initialForwardDir, self.initialUpDir);
	Object_SetScale(self.spawnedItemObject, self.itemScale, 0);
end

function MPVehiclePlacement:GetDesiredVehiclePositionOnPad():location
	local offset:number = self.verticalOffset;
	
	if (offset == nil) then
		offset = self.CONFIG.defaultPadVerticalOffset;
	end

	return self.initialContainerPosition.pos + vector(0, 0, offset);
end

function MPVehiclePlacement:SetHologramPreviewStateEnabled(item:object, enable:boolean):void		-- override
	Object_SetHologramPreviewStateEnabledWithSelfInteractionLock(item, enable);
end

function MPVehiclePlacement:ItemHologramConversion(toHologram:boolean):void		-- override
	if (toHologram) then
		self:ItemHologramConversionBase(true);
		Vehicle_SetUnitSeatInteraction(self.spawnedHologramObject, "", false, false, false);
	else
		Vehicle_SetUnitSeatInteraction(self.spawnedHologramObject, "", true, true, true);
		self:ItemHologramConversionBase(false);
	end
end

function MPVehiclePlacement:ShouldEnforceVehiclePlacement():boolean	-- virtual
	return true;
end

function MPVehiclePlacement:ForceItemToCorrectScale():void		-- override
	if (self.previewAsHologram and self.spawnedHologramObject ~= nil) then
		Object_SetScaleRecursive(self.spawnedHologramObject, self.hologramScale, 0);
		Object_SetPosition(self.spawnedHologramObject, self:GetDesiredVehiclePositionOnPad());
	elseif (self.spawnedItemObject ~= nil) then
		Object_SetScaleRecursive(self.spawnedItemObject, self.itemScale, 0);

		if (self:ShouldEnforceVehiclePlacement()) then
			Object_SetPosition(self.spawnedItemObject, self:GetDesiredVehiclePositionOnPad());
		end

		object_wake_physics(self.spawnedItemObject);
	else
		print("Error: nil item object in MPVehiclePlacement:ForceItemToCorrectScale() for", self.instanceName);
	end
end

function MPVehiclePlacement:AddSpawnedItemToDeployedList():void
	if (self.deployedItems[self.spawnedItemObject] == nil) then
		self:DebugPrint("Adding deployed item: ", self.spawnedItemObject);
		self.deployedItems[self.spawnedItemObject] = self.itemIdentifier;
	end

	if (self.canUseItemManager) then
		self.itemManager:OnItemSpawned(self.itemIdentifier);
	end
end

function MPVehiclePlacement:RemoveItemFromDeployedList(item:object):void
	if (self.deployedItems[item] ~= nil) then
		if (self.canUseItemManager) then
			self.itemManager:OnItemCleanedUp(self.deployedItems[item]);
		end

		self.deployedItems[item] = nil;
		self:DebugPrint("Removing deployed item: ", item, " Remaining: ", table.countKeys(self.deployedItems));

		if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.DynamicOnExpire) then
			self.lifecycleThread = self:CreateThread(self.RestartLifecycle);
		elseif (self.deploymentState == DeploymentState.Restricted and self:CanDeploy()) then
			self.delayedResetThread = self:CreateThread(self.DelayedResetRoutine);
		end
	end
end

function MPVehiclePlacement:ForceDormantState():void			-- override
	if (self.leavePadThread ~= nil) then
		self:KillThread(self.leavePadThread);
		self.leavePadThread = nil;
	end

	self:ForceDormantStateBase();
end

function MPVehiclePlacement:OnVehicleDestroyed(eventArgs:DeathEventStruct):void
	self:OnVehicleRemoved(eventArgs.deadObject);
	self:UnregisterEventOnSelf(g_eventTypes.deathEvent, self.OnVehicleDestroyed, eventArgs.deadObject);
end

function MPVehiclePlacement:OnObjectDeleted(eventArgs:ObjectDeletedStruct):void
	self:OnVehicleRemoved(eventArgs.deletedObject);
	self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, eventArgs.deletedObject);
end

function MPVehiclePlacement:OnVehicleRemoved(removedVehicle:object):void
	if (self.spawnedItemObject == removedVehicle and self.leavePadThread ~= nil) then
		self:DebugPrint("Handle vehicle removal");
		self:OnVehicleExitedPad(true);
		self:KillThread(self.leavePadThread);
		self.leavePadThread = nil;
	end

	self:RemoveItemFromDeployedList(removedVehicle);
end

function MPVehiclePlacement:VehicleHasTraveled():boolean	-- virtual
	return Object_GetDistanceSquaredToPosition(self.spawnedItemObject, self.initialContainerPosition.pos) > self.minTravelDistanceSq;
end

function MPVehiclePlacement:CheckForVehicleExitPad():void
	repeat
		SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self:VehicleHasTraveled();

	self:DebugPrint("Detect vehicle travel");
	self:OnVehicleExitedPad(false);
end

function MPVehiclePlacement:OnVehicleExitedPad(destroyed:boolean):void	-- virtual
	self:OnVehicleExitedPadBase();
end

function MPVehiclePlacement:OnVehicleExitedPadBase(destroyed:boolean):void
	self:DebugPrint("MPVehiclePlacement:OnVehicleExitedPadBase()");
	self:GoToDormantState();

	self.resetThread = self:CreateThread(self.LifecycleResetRoutine);
	local driver:object = Vehicle_GetDriver(self.spawnedItemObject);
	self.spawnedItemObject = nil;

	if (self.leavePadThread ~= nil) then
		self:KillThread(self.leavePadThread);
		self.leavePadThread = nil;
	end

	if (destroyed) then
		return;
	end

	-- TODO: sound (ADO:340504)

	if (self.CONFIG.isMessagingVisible) then
		self:MessagingPickedUp(driver);
		RunClientScript("IntelMapSetVehiclePlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, self.itemStringId);
	end
end

function MPVehiclePlacement:IsPadObstructed(objectTypeMask:wholenum):boolean	-- objectTypeMask can be ObjectTypeMask.BipedAndVehicle, ObjectTypeMask.Vehicle, etc
	local obstructions:object_list = Object_GetWithinMPBoundaryWithMask(self.containerObject, objectTypeMask);

	local vehicles:table = {};
	local bipeds:table = {};

	if (obstructions ~= nil and #obstructions > 0) then

		--This will spam since it's in a repeating thread. Uncomment if needed for debugging purposes
		--self:DebugPrint("MPVehiclePlacement:IsPadObstructed() - Obstruction count = ", #obstructions);

		for _, obstructingObj in ipairs(obstructions) do
			if (obstructingObj ~= self.spawnedHologramObject and not Object_GetHologramPreviewStateEnabled(obstructingObj)) then
				if (Unit_GetTreatAsVehicle(obstructingObj)) then
					table.insert(vehicles, obstructingObj);
				else
					table.insert(bipeds, obstructingObj);
				end
			end
		end

		-- slide bipeds out of the way, but only if there's not an obstructing vehicle, otherwise, they'll have to get to it to move it!
		if (#bipeds > 0 and #vehicles == 0) then
			for _, obstructingBiped in ipairs(bipeds) do
				self:SlideObstructionOutOfRange(obstructingBiped);
			end
		end
	end

	return #bipeds + #vehicles > 0;
end

function MPVehiclePlacement:SlideObstructionOutOfRange(obstructingObj:object):void
	local toObject = Object_GetPosition(obstructingObj).vector - self.initialContainerPosition.pos;
	toObject.z = 0;
	local slideDir:vector = Vector_Normalize(toObject) * self.CONFIG.avoidanceSpeed;

	Object_ApplyPointAccelerationUnscaled(obstructingObj, self.initialContainerPosition.pos, slideDir);
end

function MPVehiclePlacement:OnSpawningImminent():void	-- override
	self:PauseUntilUnobstructed();
end

function MPVehiclePlacement:PauseUntilUnobstructed():void
	if (self:IsPadObstructed(ObjectTypeMask.BipedAndVehicle)) then
		self:DebugPrint("Waiting if pad is obstructed");

		Timer_Stop(self.respawnTimer);
		self:SetStatusBarColor(self.CONST.restrictedColor, self.CONST.colorLerpTime);
		self:GotoClosingAnimState();

		SleepUntilSeconds([| not self:IsPadObstructed(ObjectTypeMask.BipedAndVehicle)], self.CONFIG.updateDeltaSeconds);

		Timer_Start(self.respawnTimer);
		self:SetStatusBarColor(self.CONST.activeColor, self.CONST.colorLerpTime);
	end

	if (self.spawnedHologramObject ~= nil) then
		MPLuaCall("__OnVehicleSpawnScaleUp", self.initialContainerPosition.pos);
		Object_SetScaleRecursive(self.spawnedHologramObject, self.itemScale, self.CONFIG.imminentCheckDuration);
	end
end

function MPVehiclePlacement:GenerateAvailableVehicleTable(vehicleTable:table):void
	self.availableItemTable = {}; 
	for id, vehicleEntry in hpairs (vehicleTable) do
		local classCheck:boolean = self.class == nil or vehicleEntry.class == self.class;
		local terrainCheck:boolean = self.terrainFilters[vehicleEntry.terrain] or false;
		local factionCheck:boolean = self.factionFilters[vehicleEntry.faction] or false;

		if (classCheck and terrainCheck and factionCheck and not self:IsVehicleFlightBanned(vehicleEntry.identifier)) then
			self.availableItemTable[id] = vehicleEntry;
		end
	end
end

function MPVehiclePlacement:IsVehicleFlightBanned(vehicleID:mp_vehicle_identifier):boolean
	return MultiplayerItems_LimitForFlighting and table.contains(MPFlightingProhibitedVehicles, vehicleID);
end

function MPVehiclePlacement:RebuildAvailableItemTable():void						-- override
	local allVehicleTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableVehicleTable(allVehicleTable);
	
	-- did we not get anything due to flight banning or poor filtering combinations? then let's pick a fallback class and try again
	if (table.countKeys(self.availableItemTable) == 0 and self.class ~= nil) then
		local fallbackClass:mp_vehicle_class = MPWeaponClassFallbacks[self.class];

		if (fallbackClass ~= nil) then
			self.class = fallbackClass;
			self:GenerateAvailableVehicleTable(allVehicleTable);
			-- if we've still got nothing, then hey, at least we tried and the global fallback will kick in later
		end
	end
end

function MPVehiclePlacement:EnsureLegitimateFactionFilters():void					-- override
	-- all vehicles are either UNSC or Banished... let's make sure they're not all off
	if (not self.factionFilters[MP_ITEM_FACTION.UNSC] and not self.factionFilters[MP_ITEM_FACTION.Banished]) then
		self.factionFilters[MP_ITEM_FACTION.UNSC] = true;
	end
end

function MPVehiclePlacement:EnsureLegitimateTerrainTypeFilters():void
	-- all vehicles are either Land or Air... let's make sure they're not both off
	if (not self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE.Land] and not self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE.Air]) then
		self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE.Land] = true;
		self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE.Air] = true;
	end
end

function MPVehiclePlacement:VehicleStringToIdentifier(vehicle:string):mp_vehicle_identifier
	if (vehicle == "Mongoose") then
		return MP_VEHICLE_IDENTIFIER.Mongoose;
	elseif (vehicle == "Gungoose") then
		return MP_VEHICLE_IDENTIFIER.Gungoose;
	elseif (vehicle == "Ghost") then
		return MP_VEHICLE_IDENTIFIER.Ghost;
	elseif (vehicle == "Chopper") then
		return MP_VEHICLE_IDENTIFIER.Chopper;
	elseif (vehicle == "Razorback") then
		return MP_VEHICLE_IDENTIFIER.Razorback;
	elseif (vehicle == "Warthog") then
		return MP_VEHICLE_IDENTIFIER.Warthog;
	elseif (vehicle == "Rockethog") then
		return MP_VEHICLE_IDENTIFIER.Rockethog;
	elseif (vehicle == "Wraith") then
		return MP_VEHICLE_IDENTIFIER.Wraith;
	elseif (vehicle == "Scorpion") then
		return MP_VEHICLE_IDENTIFIER.Scorpion;
	elseif (vehicle == "Wasp") then
		return MP_VEHICLE_IDENTIFIER.Wasp;
	elseif (vehicle == "Banshee") then
		return MP_VEHICLE_IDENTIFIER.Banshee;
	else
		return nil;
	end
end

function MPVehiclePlacement:CurrentVehicleIdentifierAsString():string
	if (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Mongoose) then
		return "Mongoose";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Gungoose) then
		return "Gungoose";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Ghost) then
		return "Ghost";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Chopper) then
		return "Chopper";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Razorback) then
		return "Razorback";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Warthog) then
		return "Warthog";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Rockethog) then
		return "Rockethog";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Wraith) then
		return "Wraith";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Scorpion) then
		return "Scorpion";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Wasp) then
		return "Wasp";
	elseif (self.itemIdentifier == MP_VEHICLE_IDENTIFIER.Banshee) then
		return "Banshee";
	else
		return nil;
	end
end

function MPVehiclePlacement:OnPlacementHide():void	-- override
	if (self.spawnedItemObject ~= nil) then
		self:UnregisterEventOnSelf(g_eventTypes.deathEvent, self.OnVehicleDestroyed, self.spawnedItemObject);
		self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.spawnedItemObject);
	end
end

function MPVehiclePlacement:OnPlacementShow():void	-- override
	self:CreateThread(self.InitializeContainer);
end

function MPVehiclePlacement:GetHologramLoopingSound():tag	-- override
	return MPItemSpawnerAudioAssets.vehicleHologramLoop;
end

function MPVehiclePlacement:SetVariant():void	-- override
	if (self.class == MP_VEHICLE_CLASS.Siege) then 
		object_set_variant(self.containerObject, self.CONST.defaultVariantName);
	else
		object_set_variant(self.containerObject, self.CONST.downgradedVariantName);
	end
end

-- OVERRIDES

function MPVehiclePlacement:HandleOverrideReceived(itemManager:table):void	-- override
	if (not self.canUseItemManager or self.itemManager ~= itemManager) then
		return;
	end

	-- have we overridden the class? if so, swap it
	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None and self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class ~= MP_VEHICLE_CLASS.None) then
		self.class = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class;
	end

	-- ok, now that that's been sorted, let's override by class, channel and then global
	if (self.class ~= nil and self.class ~= MP_VEHICLE_CLASS.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perClassOverrides[self.class]);
	end

	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId]);
	end

	self:ProcessOverrideDataSet(self.itemManager.CONFIG.globalOverrides);

	self:EnsureLegitimateFactionFilters();
	self:EnsureLegitimateTerrainTypeFilters();
end

function MPVehiclePlacement:ProcessOverrideDataSet(overrideData:MPVehicleOverrideData):void
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

	for i = 0, #MP_VEHICLE_TERRAIN_TYPE - 1 do
		if (overrideData.terrainFilters[MP_VEHICLE_TERRAIN_TYPE[i]] == 0) then
			self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE[i]] = false;
		elseif (overrideData.terrainFilters[MP_VEHICLE_TERRAIN_TYPE[i]] ~= self.CONST.noManagerOverride) then
			self.terrainFilters[MP_VEHICLE_TERRAIN_TYPE[i]] = true;
		end
	end

	if (overrideData.forceRandomItem) then
		self.explicitIdentifier = nil;
	elseif (overrideData.vehicle ~= MP_VEHICLE_IDENTIFIER.None) then
		self:TryOverridingItemFromIdentifier(overrideData.vehicle);
	end
end

function MPVehiclePlacement:TryOverridingItemFromIdentifier(overrideIdentifier:mp_vehicle_identifier):void
	local vehicleTable:table = self:GetFullDefinitionTable();
	self:AssignItemFromIdentifier(overrideIdentifier, vehicleTable);
end

function MPVehiclePlacement:TryOverridingItem():boolean	-- override
	local overridden:boolean = false;
	local overrideData:MPVehicleOverrideData = nil;

	if (self.canUseItemManager) then
		if (self.class ~= nil) then
			overrideData = self.itemManager.CONFIG.perClassOverrides[self.class];
			if (not overrideData.forceRandomItem and overrideData.vehicle ~= MP_VEHICLE_IDENTIFIER.None) then
				self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perClassOverrides[self.class].vehicle);
				overridden = true;
			end
		end

		if (self.selectiveChannelId ~= nil) then
			overrideData = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId];
			if (not overrideData.forceRandomItem and overrideData.vehicle ~= MP_VEHICLE_IDENTIFIER.None) then
				self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].vehicle);
				overridden = true;
			end
		end
	end

	return overridden;
end

-- NAVPOINTS

function MPVehiclePlacement:GetNavpointPresentationTierName():string	-- override
	if (self.deploymentState == DeploymentState.Incoming) then
		return self.CONST.navpointPresentationNameRecharging;
	end

	if (self.class == MP_VEHICLE_CLASS.Siege) then 
		return self.CONST.navpointPresentationNamePower;
	else
		return self.CONST.navpointPresentationNameGeneral;
	end
end

-- MESSAGING 

function MPVehiclePlacement:MessagingIncoming():void	-- override
	self:MessagingIncomingBase();

	-- Uncomment if incoming Vehicle VO should play
	--if (self.canUseItemManager and self.class == MP_VEHICLE_CLASS.Siege) then
	--	self.itemManager:PlayVO(
	--		hmake MPItemSpawnerPendingVOData
	--		{
	--			responseName	= "__OnVehiclePadIncoming",
	--			itemName		= nil,
	--			itemType		= MPItemGroupType.Vehicle,
	--			voType			= MPItemVOType.Incoming,
	--		});
	--else
	--	MPLuaCall("__OnVehiclePadIncoming");
	--end
end

function MPVehiclePlacement:MessagingReady():void	-- override
	self:MessagingReadyBase();

	if (not self.canDisplayReadyMessage) then
		return;
	end

	-- Uncomment if ready Vehicle VO should play
	--if (self.canUseItemManager and self.class == MP_VEHICLE_CLASS.Siege) then
	--	self.itemManager:PlayVO(
	--		hmake MPItemSpawnerPendingVOData
	--		{
	--			responseName	= "__OnVehiclePadSpawned",
	--			itemName		= nil,
	--			itemType		= MPItemGroupType.Vehicle,
	--			voType			= MPItemVOType.Ready,
	--		});
	--else
	--	MPLuaCall("__OnVehiclePadSpawned", nil);
	--end
end

function MPVehiclePlacement:MessagingPickedUp(lootingPlayer:player):void	-- override
	self:MessagingPickedUpBase(lootingPlayer);
	-- MPLuaCall("__OnWeaponPadPickedUp", lootingPlayer);	-- TODO
end

-- EFFECTS

function MPVehiclePlacement:GetIncomingEffect():tag	-- override
	if (self.class == MP_VEHICLE_CLASS.Siege) then 
		return self.incomingParticleFX;
	else
		return self.altIncomingParticleFX;
	end
end

function MPVehiclePlacement:GetSpawnedEffect():tag	-- override
	if (self.class == MP_VEHICLE_CLASS.Siege) then 
		return self.spawnedParticleFX;
	else
		return self.altSpawnedParticleFX;
	end
end

function MPVehiclePlacement:GetRestrictedAudio():tag	-- override
	return MPItemSpawnerAudioAssets.vehicleRestrictedLoop;
end

function MPVehiclePlacement:GetHologramPreviewColor():object_runtime_hologram_color	-- override
	if (self.class == MP_VEHICLE_CLASS.Siege) then 
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Gold;
	else
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Blue;
	end
end

function MPVehiclePlacement:GetRezInEffect():tag		-- override
	if (self.class == MP_VEHICLE_CLASS.Siege) then
		return MPItemSpawnerRezInEffects.powerItem;
	else
		return MPItemSpawnerRezInEffects.baseItem;
	end
end

--## CLIENT

function remoteClient.IntelMapSetVehiclePlacementIcon(vehiclePadObject:object, vehicleIcon:string_id, iconColor:color_rgba, vehicleName:string_id):void
	iconColor = iconColor or UI_GetBitmapColorForDisposition(DISPOSITION.Neutral);
	IntelMapSetColoredIcon(vehicleIcon, "intel_map_icon_hexagon_bg", vehicleName, iconColor, vehiclePadObject);
end
