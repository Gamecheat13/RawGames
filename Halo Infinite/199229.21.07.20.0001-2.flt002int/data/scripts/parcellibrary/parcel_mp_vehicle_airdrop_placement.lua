-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('scripts\parcellibrary\parcel_mp_vehicle_placement.lua');
REQUIRES('scripts\AirDrop\AirDrop.lua');
REQUIRES('scripts\AirDrop\RouteRequest.lua');
REQUIRES('scripts\AirDrop\Flight.lua');

--//////
-- Parcel Setup
--//////

global MPVehicleAirDropPlacement:table = MPVehiclePlacement:CreateSubclass();

MPVehicleAirDropPlacement.parcelName = "MPVehicleAirDropPlacement";
MPVehicleAirDropPlacement.droppedPosition = nil;
MPVehicleAirDropPlacement.routeQueryHandle = nil;

MPVehicleAirDropPlacement.CONFIG.useDropZone = true;
MPVehicleAirDropPlacement.CONFIG.acceptanceRadius = 10;

MPVehicleAirDropPlacement.CONST.dropSettleTime = 1.5;

MPVehicleAirDropPlacement.EVENTS = {
	onCargoDelivered = "onCargoDelivered",
	onFlightCompleted = "onFlightCompleted",
	onFlightInterrupted = "onFlightInterrupted",
	onFlightRouteFailure = "onFlightRouteFailure"
};

function MPVehicleAirDropPlacement:NewVehicleAirDropPlacement(initArgs:MPVehicleAirdropPlacementInitArgs):table
	assert(initArgs ~= nil);

	local newVehiclePlacementParcel = self:NewVehiclePlacement(
		hmake MPVehiclePlacementInitArgs
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
			vehicle = initArgs.vehicle,
			vehicleClass = initArgs.vehicleClass,
			terrainFilters = initArgs.terrainFilters,
			factionFilters = initArgs.factionFilters,
			classWeightOverrides = initArgs.classWeightOverrides,
			incomingParticleFX = initArgs.incomingParticleFX,
			altIncomingParticleFX = initArgs.altIncomingParticleFX,
			spawnedParticleFX = initArgs.spawnedParticleFX,
			altSpawnedParticleFX = initArgs.altSpawnedParticleFX,
			restrictedParticleFX = initArgs.restrictedParticleFX,
			previewAsHologram = initArgs.previewAsHologram,
			itemShouldRotate = initArgs.itemShouldRotate,
			broadcastChannelPower = initArgs.broadcastChannelPower,		-- should be nil from kit
			broadcastChannelControl = initArgs.broadcastChannelControl,	-- should be nil from kit
			legendaryItemUsage = initArgs.legendaryItemUsage,
			seedSequenceKey = initArgs.seedSequenceKey,
			staticSelection = initArgs.staticSelection,
		});

	newVehiclePlacementParcel.CONFIG.useDropZone = initArgs.useDropZone;
	newVehiclePlacementParcel.CONFIG.acceptanceRadius = initArgs.acceptanceRadius;

	-- EventManager needs to be manually built becuase we're a subclass
	newVehiclePlacementParcel.EVENTS = MPVehicleAirDropPlacement.EVENTS;
	newVehiclePlacementParcel:AddEventManager();

	return newVehiclePlacementParcel;
end

------------------------
-- Lua Event Wrappers --
------------------------
function MPVehicleAirDropPlacement:AddOnCargoDelivered(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onCargoDelivered, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:RemoveOnCargoDelivered(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onCargoDelivered, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:AddOnFlightCompleted(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onFlightCompleted, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:RemoveOnFlightCompleted(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onFlightCompleted, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:AddOnFlightInterrupted(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onFlightInterrupted, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:RemoveOnFlightInterrupted(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onFlightInterrupted, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:AddOnFlightRouteFailure(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onFlightRouteFailure, callbackFunc, callbackOwner);
end

function MPVehicleAirDropPlacement:RemoveOnFlightRouteFailure(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onFlightRouteFailure, callbackFunc, callbackOwner);
end

--
--	INTERNAL PARCEL LOGIC
--

function MPVehicleAirDropPlacement:InitializeImmediate():void	-- override
	if (self.CONFIG.maxDeployedItemCount == 0) then
		self.CONFIG.maxDeployedItemCount = math.huge;
	end

	if (self.CONFIG.isMessagingVisible) then
		self:CreateNavpoints();
	end

	self:InitializeImmediateBase();
end

function MPVehicleAirDropPlacement:TryAndEscalateCategoryWeights():boolean	-- override
	if (self.itemManager.CONFIG.useEscalatingCategoryWeightsForAirdrop) then
		self.itemManager:EscalateCategoryWeights();										-- global weighting table

		if (self.categoryWeightOverrides ~= nil) then
			self.itemManager:EscalateCategoryWeights(self.categoryWeightOverrides);		-- locally stored overrides if used
		end

		return true;
	end

	return false;
end

function MPVehicleAirDropPlacement:TriggerItemSpawn():boolean	-- override
	if (not ParcelIsValid(self)) then
		print("MPVehicleAirDropPlacement: Cannot attempt to externally trigger item spawn until parcel has been initialized");
		return false;
	end

	if (self.spawnedItemObject == nil and self:CanTriggerExternally() and not self:IsPadObstructed(ObjectTypeMask.Vehicle)) then
		self:CreateThread(self.StartSpawningState);
		return true;
	end

	return false;
end

function MPVehicleAirDropPlacement:CreateItemObject():void		-- override
	local routeRequest:table = AirDrop.RouteRequest:New(get_string_id_from_string("Vehicle Air Drop"));

	--Change Drop Vehicle Logic based on Boolean set from Kit Placement. Set to true by default
	if (self.CONFIG.useDropZone) then
		local dropZoneData = hmake AirDropZone {
			location = self.initialContainerPosition.pos,
			range = self.CONFIG.acceptanceRadius,
		};

		routeRequest:SetDropZone(dropZoneData);
	else
		routeRequest:UseExactDropLocation(self.initialContainerPosition);
	end


	routeRequest:SetDropShip(GetGlobalVehicleAirDropShipInits());
	
	local flyInOutSettings:table = AirDrop.FlightSettings:MakeDefault();
	local transitionType:airdrop_flight_transition_type = AIRDROP_FLIGHT_TRANSITION_TYPE.Warp;
	flyInOutSettings:SetTransitionData(transitionType, 3);

	routeRequest:SetFlyInSettings(flyInOutSettings);
	routeRequest:SetFlyOutSettings(flyInOutSettings);

	local cargoDeliveryItem:table = AirDrop.DeliveryItem:CreateFromObjectDefinition(self.itemTag);
	local cargoItemIndex:number = routeRequest:AddDeliveryItem(cargoDeliveryItem);
	self.routeQueryHandle = AirDrop_RequestRoute(routeRequest);

	if (self.routeQueryHandle == nil) then
		print("Failed to get query handle");
		self:TriggerEvent(self.EVENTS.onFlightRouteFailure, self);
		return;
	end

	SleepUntil([| AirDrop_IsRouteQueryComplete(self.routeQueryHandle) ]);

	local routeResult:table = AirDrop_GetRouteQueryResult(self.routeQueryHandle);
	if (routeResult == nil) then
		print("Route result is nil. Aborting.");
		self:TriggerEvent(self.EVENTS.onFlightRouteFailure, self);
		return;
	end

	self.spawnedItemObject = Object_CreateFromTagWithConfiguration(self.itemTag, self.itemConfig);
	Object_SetScale(self.spawnedItemObject, self.itemScale, 0);
	local cargoItem:table = routeResult.deliveryLocations[cargoItemIndex];
	local cargoDest:table = AirDrop.FlightDestination:MakeObjectDeliveryDestinationFromDropLocation(cargoItem, self.spawnedItemObject);
	local flight:table = AirDrop.Flight:CreateFromRouteQuery(self.routeQueryHandle, get_string_id_from_string("Supply Flight"));
	local ship = AirDrop_GetDropShipFromFlight(flight.flightHandle)
	flight:AddDestination(cargoDest);
	flight:TakeOff();

	--Make Pelicans Invulnurable and not affected by damage types
	Object_SetObjectCannotTakeDamage(ship, true);

	MPLuaCall("__OnFieldResupply", self.spawnedItemObject, Object_GetPositionVector(ship));

	if (self.CONFIG.isMessagingVisible) then
		self:UpdateNavpoint();
	end

	self:DebugPrint("Air drop flight initiated", flight.flightHandle);

	self:RegisterEventOnceOnSelf(g_eventTypes.airDropCargoDelivered, self.OnCargoDelivered, flight.flightHandle);
	self:RegisterEventOnceOnSelf(g_eventTypes.airDropFlightCompleted, self.OnFlightCompleted, flight.flightHandle);
	self:RegisterEventOnceOnSelf(g_eventTypes.airDropFlightInterrupted, self.OnFlightInterrupted, flight.flightHandle);

	SleepUntilSeconds([| self.droppedPosition ~= nil], 1);	-- wait here so we don't start checking for vehicle travel until it's been delivered
end

function MPVehicleAirDropPlacement:ShouldEnforceVehiclePlacement():boolean					-- override
	return false;
end

function MPVehicleAirDropPlacement:VehicleHasTraveled():boolean						-- override
	return self.droppedPosition ~= nil and Object_GetDistanceSquaredToPosition(self.spawnedItemObject, self.droppedPosition) > self.minTravelDistanceSq;
end

function MPVehicleAirDropPlacement:OnVehicleExitedPad(destroyed:boolean):void		-- override
	self.droppedPosition = nil;
	Navpoint_RemoveObjectParent(self.mainNavpoint, self.spawnedItemObject);

	self:OnVehicleExitedPadBase();
end

function MPVehicleAirDropPlacement:OnCargoDelivered(eventArgs:AirDropCargoDeliveredEventStruct):void
	self:DebugPrint("MPVehicleAirDropPlacement:OnCargoDelivered", eventArgs.flight, eventArgs.cargo);
	if (eventArgs.cargo == self.spawnedItemObject) then
		self:TriggerEvent(self.EVENTS.onCargoDelivered, self, eventArgs.cargo);
		self:CreateThread(self.CacheDroppedPosition);
	end
end

function MPVehicleAirDropPlacement:OnFlightCompleted(eventArgs:AirDropFlightCompletedEventStruct):void
	self:DebugPrint("MPVehicleAirDropPlacement:OnFlightCompleted - releasing query", eventArgs.flight);
	local ship = AirDrop_GetDropShipFromFlight(eventArgs.flight)
	MPLuaCall("__OnFieldResupplyCompleted", Object_GetPositionVector(ship));

	AirDrop_ReleaseRouteQuery(self.routeQueryHandle);
	self:TriggerEvent(self.EVENTS.onFlightCompleted, self, eventArgs.flight);
end

function MPVehicleAirDropPlacement:OnFlightInterrupted(eventArgs:AirDropFlightInterruptedEventStruct):void
	self:DebugPrint("MPVehicleAirDropPlacement:OnFlightInterrupted", eventArgs.flight);
	self:TriggerEvent(self.EVENTS.onFlightInterrupted, self, eventArgs.flight);

	if (self.deploymentState == DeploymentState.Dormant and self.spawnedItemObject ~= nil) then
		-- Object was created for deployment, but flight failed before delivery
		Object_Delete(self.spawnedItemObject);
		self.spawnedItemObject = nil;
	end
end

function MPVehicleAirDropPlacement:CacheDroppedPosition():void
	SleepSeconds(self.CONST.dropSettleTime);
	self.droppedPosition = Object_GetPosition(self.spawnedItemObject);
	Object_SetPosition(self.containerObject, self.droppedPosition);
end

function MPVehicleAirDropPlacement:IsMessagingCapable():boolean	--override
	return true;
end

function MPVehicleAirDropPlacement:CreateNavpoints():void		-- override
	self.mainNavpoint = Navpoint_Create(self.CONST.navpointPresentationTagName);
	if (self.mainNavpoint ~= nil) then
		self:CreateNavpointVisualStates();

		Navpoint_SetVisibleOffscreen(self.mainNavpoint, self.CONFIG.navpointDocked);
		self:SetNavpointsCanBeOccluded(false);
		Navpoint_SetVisibilityDistance(self.mainNavpoint, self.CONFIG.navpointVisibilityDistance);
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.mainNavpoint, false);
	else
		print("WARNING: Unable to create Navpoint for", self.instanceName);
	end
end

function MPVehicleAirDropPlacement:UpdateNavpoint():void
	if (self.spawnedItemObject == nil) then
		print("Cannot update air drop navpoint because there is no spawned vehicle");
	end

	Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.mainNavpoint, true);
	Navpoint_SetObjectParent(self.mainNavpoint, self.spawnedItemObject);
	Navpoint_SetObjectMarker(self.mainNavpoint, "");

	if (self.itemStringId ~= nil) then
		Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointTierVisualState, self:GetNavpointPresentationTierName());
		Navpoint_SetDisplayText(self.mainNavpoint, self.CONFIG.navpointReadyText .. self.itemStringId);
	end
end

--## CLIENT

