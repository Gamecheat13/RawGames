-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

-- requires
REQUIRES('globals\scripts\global_lua_events.lua');
REQUIRES('scripts\parcellibrary\parcel_item_placement_base.lua');
REQUIRES('scripts\Helpers\StopwatchDaemonStartup.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_item_seedsequence.lua');

global MPItemPlacement:table = ItemPlacementBase:CreateSubclass();

MPItemPlacement.canUseItemManager = false;
MPItemPlacement.itemManager = nil;

MPItemPlacement.spawnProperties = nil;
MPItemPlacement.explicitIdentifier = nil;
MPItemPlacement.itemIdentifier = nil;
MPItemPlacement.itemStringId = "";
MPItemPlacement.spawnedHologramObject = nil;
MPItemPlacement.deployedItems = {};			-- items "in play" from this placement
MPItemPlacement.availableItemTable = {};
MPItemPlacement.class = nil;
MPItemPlacement.categoryIsRandom = false;
MPItemPlacement.symmetricalChannel = nil;
MPItemPlacement.symmetricalChannelId = nil;
MPItemPlacement.selectiveChannel = nil;
MPItemPlacement.selectiveChannelId = nil;
MPItemPlacement.factionFilters = {};
MPItemPlacement.navpointDisplayDuration = nil;
MPItemPlacement.incomingDuration = nil;
MPItemPlacement.canDisplayReadyMessage = false;
MPItemPlacement.openAnimationHasCompleted = false;
MPItemPlacement.closeAnimationHasCompleted = false;

MPItemPlacement.respawnTimer = nil;
MPItemPlacement.resetThread = nil;
MPItemPlacement.delayedResetThread = nil;
MPItemPlacement.lifecycleThread = nil;

MPItemPlacement.fixedIntervalStopwatch = nil;

MPItemPlacement.mainNavpoint = nil;
MPItemPlacement.navpointItemTypeVisualState = nil;
MPItemPlacement.navpointTierVisualState = nil;
MPItemPlacement.navpointCanBeOccluded = false;	-- Determines if navpoint is visible through geo
MPItemPlacement.navpointVerticalOffset = 0;

MPItemPlacement.spawnMarkerWorldPos = nil;
MPItemPlacement.spawnMarkerHeight = 0;

MPItemPlacement.categoryWeightOverrides = nil;
MPItemPlacement.isHidden = false;

MPItemPlacement.incomingParticleFX = nil;
MPItemPlacement.altIncomingParticleFX = nil;
MPItemPlacement.spawnedParticleFX = nil;
MPItemPlacement.altSpawnedParticleFX = nil;
MPItemPlacement.restrictedParticleFX = nil;

MPItemPlacement.logEntries = nil;
MPItemPlacement.initialLogTime = nil;

MPItemPlacement.seedSequence = nil;
MPItemPlacement.parentSeedSequence = nil;

-- CONFIGURATION VARIABLES
MPItemPlacement.CONFIG.enableDebugLogging = false;	-- A debug variable used to enable/disable storage of debug print messages

MPItemPlacement.CONFIG.staticSelectionEnabled = false;
MPItemPlacement.CONFIG.spawnLogic = nil;
MPItemPlacement.CONFIG.respawnRandomFrequency = nil;
MPItemPlacement.CONFIG.legendaryItemUsage = nil;
MPItemPlacement.CONFIG.maxDeployedItemCount = 0;
MPItemPlacement.CONFIG.initialSpawnDelay = 0;
MPItemPlacement.CONFIG.respawnTime = 30;
MPItemPlacement.CONFIG.isMessagingVisible = false;
MPItemPlacement.CONFIG.pingMessaging = false;
MPItemPlacement.CONFIG.defaultIncomingDuration = 15;
MPItemPlacement.CONFIG.nearingSpawnTime = 10;		-- Incoming item messaging amplifies when remaining respawn time (seconds) equals this much
MPItemPlacement.CONFIG.previewAsHologram = false;
MPItemPlacement.CONFIG.hologramFadeDuration = 0.5;	-- If hologramProgressFade is false, this determines how quickly the hologram goes from 0 to hologramOpacity 
MPItemPlacement.CONFIG.hologramOpacity = 1.0;
MPItemPlacement.CONFIG.hologramProgressFade = true;	-- If true, the hologram will fade from 0 to the hologramOpacity over its lifetime, reflecting the progress of the spawn
MPItemPlacement.CONFIG.rotationDelay = 2.5;
MPItemPlacement.CONFIG.prohibitCloseAnimPeriod = 2;	-- If item is picked up while still opening, it will pop to beginning of close animation immediately. Wait until completion instead
MPItemPlacement.CONFIG.closeAnimationDuration = 2;	-- Conservative estimate of close animation timing

MPItemPlacement.CONFIG.broadcastChannelPower = nil;
MPItemPlacement.CONFIG.broadcastChannelControl = nil;

-- Global Item Navpoint Variables
MPItemPlacement.CONFIG.navpointVisibilityDistance = 150;	-- N = .5 meters in game
MPItemPlacement.CONFIG.navpointPinningEnabled = false;		-- Enables navpoint pinning offscreen (if false, navpointPinnedIncoming and are navpointPinnedNearingSpawn irrelevant)
MPItemPlacement.CONFIG.navpointPinnedIncoming = false;		-- Determines the initial pinning rules for when the navpoint is offscreen
MPItemPlacement.CONFIG.navpointPinnedNearingSpawn = true;	-- Determines the pinning rules for when the navpoint is offscreen when the item is nearing spawn or spawned

-- unused, but leave these in here in case we need to prefix our strings
MPItemPlacement.CONFIG.navpointIncomingText = "";
MPItemPlacement.CONFIG.navpointReadyText = "";

MPItemPlacement.CONFIG.intelNavpointReadyColor = color_rgba(1, 1, 1, 1);

-- seed sequence variables
MPItemPlacement.CONFIG.variantSeedSequenceKey = GetGeneralMPItemGameVariantSeedSequenceKeyArgs().GeneralPlacementKey.instanceName;
MPItemPlacement.CONFIG.placementSeed = nil;
MPItemPlacement.CONFIG.placementSeedRoundReset = true;

-- CONSTANT VARIABLES
MPItemPlacement.CONST.noManagerOverride = 255;

MPItemPlacement.CONST.navpointPresentationTagName = "item_pad";
MPItemPlacement.CONST.navpointPresentationItemTypeGroup = "type_group";
MPItemPlacement.CONST.navpointPresentationNameItemType = "";			-- virtual

MPItemPlacement.CONST.navpointPresentationTierGroup = "tier_group";
MPItemPlacement.CONST.navpointPresentationNameRecharging = "recharging";
MPItemPlacement.CONST.navpointPresentationNameGeneral = "general";
MPItemPlacement.CONST.navpointPresentationNamePower = "power";

MPItemPlacement.CONST.mandatoryDormantPeriod = 1;
MPItemPlacement.CONST.minimumFixedIntervalIncomingPeriod = 15;
MPItemPlacement.CONST.defaultNavpointDisplayDuration = 30;
MPItemPlacement.CONST.hologramDisplayDuration = 30;
MPItemPlacement.CONST.defaultNavpointVerticalOffset = 0.15;
MPItemPlacement.CONST.navpointPingedDuration = 3;

MPItemPlacement.CONST.wakeWithinDistance = 7;
MPItemPlacement.CONST.sleepBeyondDistance = 8;

MPItemPlacement.CONST.minimumRespawnDuration = 5;
MPItemPlacement.CONST.effectMarkerName = "fx_root";
MPItemPlacement.CONST.defaultVariantName = "default";
MPItemPlacement.CONST.downgradedVariantName = "basic";

MPItemPlacement.CONST.maxLogEntryCount = 30;

MPItemPlacement.CONST.seedSequenceEnabled = true;

function MPItemPlacement:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function MPItemPlacement:EndShutdown():void				-- override
	self:EndShutdownItem();
end

function MPItemPlacement:EndShutdownItem():void
	self:EndShutdownBase();

	if (self.respawnTimer ~= nil) then
		Engine_DeleteTimer(self.respawnTimer);
	end

	if (self.mainNavpoint ~= nil) then
		Navpoint_Delete(self.mainNavpoint);
	end

	if (self.itemManager ~= nil) then
		self.itemManager:RemoveOnOverrideReceived(self, self.HandleOverrideReceived);
	end

	if (self.fixedIntervalStopwatch ~= nil) then
		GlobalStopwatchDaemon:DisposeDiscreteIntervalStopwatch(self.fixedIntervalStopwatch);
	end

	self:GotoClosingAnimState();
end


--
--	INTERNAL PARCEL LOGIC
--

function MPItemPlacement:NewItemPlacement(initArgs:MPItemPlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMPItemPlacement = self:NewItemPlacementBase(
		hmake ItemPlacementBaseInitArgs
		{
			instanceName = initArgs.instanceName,
			containerObject = initArgs.containerObject,
			hasInvisibleDispenser = initArgs.hasInvisibleDispenser,
			stockAnimDelay = initArgs.stockAnimDelay,
			itemShouldRotate = initArgs.itemShouldRotate,
		});

	newMPItemPlacement.spawnProperties = initArgs.spawnProperties;

	newMPItemPlacement.categoryWeightOverrides = initArgs.classWeightOverrides;	-- nil is an acceptable value here

	if (initArgs.isMessagingVisible ~= nil) then
		newMPItemPlacement.CONFIG.isMessagingVisible = initArgs.isMessagingVisible;
	end

	if (initArgs.pingMessaging ~= nil) then
		-- Ping navpoints are using up too much of our navpoint availability. For now, let's turn off, but 
		-- a new solution will be needed, i.e. client-side navpoints, pooling, etc. (v-darsc 1/28/21)
		newMPItemPlacement.CONFIG.pingMessaging = false;	-- initArgs.pingMessaging;
	end

	if (initArgs.incomingDuration ~= nil) then
		newMPItemPlacement.CONFIG.defaultIncomingDuration = math.max(initArgs.incomingDuration, 0);
	end

	if (initArgs.initialSpawnDelay ~= nil) then
		newMPItemPlacement.CONFIG.initialSpawnDelay = initArgs.initialSpawnDelay;
	end

	if (initArgs.maxDeployedItemCount ~= nil) then
		newMPItemPlacement.CONFIG.maxDeployedItemCount = math.max(0, initArgs.maxDeployedItemCount);
	end

	if (initArgs.spawnLogic == "Dynamic (Pickup)") then
		newMPItemPlacement.CONFIG.spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup;
	elseif (initArgs.spawnLogic == "Dynamic (Expired)") then
		newMPItemPlacement.CONFIG.spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire;
	elseif (initArgs.spawnLogic == "Static (Time)") then
		newMPItemPlacement.CONFIG.spawnLogic = MP_SPAWN_LOGIC.FixedInterval;
		debug_assert(newMPItemPlacement.CONFIG.respawnTime > 0, "Static (Time) spawn logic requires a non-zero interval");
	else
		newMPItemPlacement.CONFIG.spawnLogic = MP_SPAWN_LOGIC.ExternalTrigger;
	end

	if (initArgs.respawnTime ~= nil) then
		if (newMPItemPlacement:IsSpawnLogicFixedInterval()) then
			-- fixed interval spawners must have increments in a multiple of 15 secs
			local rounded:number = math.Round(initArgs.respawnTime, newMPItemPlacement.CONST.minimumFixedIntervalIncomingPeriod);
			newMPItemPlacement.CONFIG.respawnTime = math.max(rounded, newMPItemPlacement.CONST.minimumFixedIntervalIncomingPeriod);		-- don't let it round down to 0
		else
			if (initArgs.respawnTime < self.CONST.minimumRespawnDuration) then
				print("WARNING, a respawn time of less than", newMPItemPlacement.CONST.minimumRespawnDuration, "seconds was specified for", newMPItemPlacement.instanceName);
			end

			newMPItemPlacement.CONFIG.respawnTime = math.max(newMPItemPlacement.CONST.minimumRespawnDuration, initArgs.respawnTime); 
		end
	end

	if (initArgs.respawnType == "Every Spawn") then
		newMPItemPlacement.CONFIG.respawnRandomFrequency = MP_RANDOMIZE_FREQUENCY.Respawn;
	elseif (initArgs.respawnType == "Every Round") then
		newMPItemPlacement.CONFIG.respawnRandomFrequency = MP_RANDOMIZE_FREQUENCY.Round;
	else
		newMPItemPlacement.CONFIG.respawnRandomFrequency = MP_RANDOMIZE_FREQUENCY.Game;
	end

	if (initArgs.legendaryItemUsage == "Include") then
		newMPItemPlacement.CONFIG.legendaryItemUsage = MP_LEGENDARY_ITEM_USAGE.Include;
	elseif (initArgs.legendaryItemUsage == "Preferred") then
		newMPItemPlacement.CONFIG.legendaryItemUsage = MP_LEGENDARY_ITEM_USAGE.Preferred;
	else
		newMPItemPlacement.CONFIG.legendaryItemUsage = MP_LEGENDARY_ITEM_USAGE.Exclude;
	end

	newMPItemPlacement.symmetricalChannel = initArgs.symmetricalChannel;

	if (newMPItemPlacement.symmetricalChannel ~= nil and newMPItemPlacement.symmetricalChannel ~= "" and newMPItemPlacement.symmetricalChannel ~= "None") then
		newMPItemPlacement.symmetricalChannelId = initArgs.symmetricalChannelId;
	end

	newMPItemPlacement.selectiveChannel = initArgs.selectiveChannel;
	newMPItemPlacement.factionFilters = initArgs.factionFilters;

	if (newMPItemPlacement.selectiveChannel ~= nil) then
		if (newMPItemPlacement.selectiveChannel == "None") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.None;
		elseif (newMPItemPlacement.selectiveChannel == "Alpha") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Alpha;
		elseif (newMPItemPlacement.selectiveChannel == "Bravo") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Bravo;
		elseif (newMPItemPlacement.selectiveChannel == "Charlie") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Charlie;
		elseif (newMPItemPlacement.selectiveChannel == "Delta") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Delta;
		elseif (newMPItemPlacement.selectiveChannel == "Echo") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Echo;
		elseif (newMPItemPlacement.selectiveChannel == "Foxtrot") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Foxtrot;
		elseif (newMPItemPlacement.selectiveChannel == "Gamma") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Gamma;
		elseif (newMPItemPlacement.selectiveChannel == "Hotel") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Hotel;
		elseif (newMPItemPlacement.selectiveChannel == "India") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.India;
		elseif (newMPItemPlacement.selectiveChannel == "Juliet") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.Juliet;
		elseif (newMPItemPlacement.selectiveChannel == "AirDrop Alpha") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.AirDropAlpha;
		elseif (newMPItemPlacement.selectiveChannel == "AirDrop Bravo") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.AirDropBravo;
		elseif (newMPItemPlacement.selectiveChannel == "AirDrop Charlie") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.AirDropCharlie;
		elseif (newMPItemPlacement.selectiveChannel == "AirDrop Delta") then
			newMPItemPlacement.selectiveChannelId = MP_ITEM_CHANNEL.AirDropDelta;
		end
	end

	newMPItemPlacement.incomingParticleFX = initArgs.incomingParticleFX;
	newMPItemPlacement.altIncomingParticleFX = initArgs.altIncomingParticleFX;
	newMPItemPlacement.spawnedParticleFX = initArgs.spawnedParticleFX;
	newMPItemPlacement.altSpawnedParticleFX = initArgs.altSpawnedParticleFX;
	newMPItemPlacement.restrictedParticleFX = initArgs.restrictedParticleFX;

	newMPItemPlacement.previewAsHologram = initArgs.previewAsHologram;

	newMPItemPlacement.CONFIG.broadcastChannelPower = initArgs.broadcastChannelPower;
	newMPItemPlacement.CONFIG.broadcastChannelControl = initArgs.broadcastChannelControl;

	newMPItemPlacement.CONFIG.variantSeedSequenceKey = initArgs.seedSequenceKey;
	newMPItemPlacement.CONFIG.staticSelectionEnabled = initArgs.staticSelection == "Enabled";

	return newMPItemPlacement;
end

function MPItemPlacement:AcquireItemManager():void		-- virtual
end

function MPItemPlacement:InitializeImmediate():void		-- virtual
end

function MPItemPlacement:InitializeImmediateBase():void
	debug_assert(self.containerObject ~= nil, "Container Object is nil. This is catastrophic.");

	self:AcquireItemManager();

	if (not editor_mode() and not self.canUseItemManager) then
		self:DebugPrint("Warning: No item manager found for item placement");
	end

	if (self.canUseItemManager) then
		self.itemManager:RegisterPlacementByClass(self.class, self);

		if (self.symmetricalChannelId ~= nil) then
			self.itemManager:ClearChannelItem(self.symmetricalChannelId);
			self.itemManager:RegisterPlacementSymmetricalChannel(self.symmetricalChannelId, self);
		end

		if (self.selectiveChannelId ~= nil and self.selectiveChannelId ~= MP_ITEM_CHANNEL.None) then
			self.itemManager:RegisterPlacementSelectiveChannel(self.selectiveChannelId, self);
		end

		self.itemManager:AddOnOverrideReceived(self, self.HandleOverrideReceived);

		-- setup the child seed sequence for the spawner
		self:SeedSequenceInitialize();

		-- overridden weights might not equal 100%. zero out prohibited classes first
		self:RenormalizeOverrideWeights();
	end

	-- even though navpoints are specified, we may be incapable of displaying them
	self.CONFIG.isMessagingVisible = self.CONFIG.isMessagingVisible and self:IsMessagingCapable();

	self.deploymentState = DeploymentState.Dormant;
	self:CreateThread(self.AssignInitialItemTag);
end

function MPItemPlacement:Initialize():void
	self.navpointDisplayDuration = self.CONST.defaultNavpointDisplayDuration;
	self.incomingDuration = self.CONFIG.defaultIncomingDuration;

	if (self.CONFIG.isMessagingVisible or self.CONFIG.pingMessaging) then
		self:CreateNavpoints();
	end

	if (self.itemShouldRotate) then
		-- the dispenser device machine has a visibility wake manager that will put it to sleep when not visible
		-- by any players. we want it to be be the authoritative source of sleep wake when enabled, which should
		-- only be when we're in the rotation state.
		RunClientScript("SetVisibilityWakeManagerSleepLocking", self.containerObject, true);
		self:EnableClientVisibilityWakeManager(false);
	end

	-- ensure incoming state will take less time than entire interval
	if (self.CONFIG.isMessagingVisible) then
		self:CalculateNavpointDisplayDuration(self.CONFIG.respawnTime);
	else
		if (self.CONFIG.respawnTime <= self.incomingDuration) then
			self.incomingDuration = math.max(self.CONFIG.respawnTime - self.CONST.mandatoryDormantPeriod, 0);
		end
	end	

	if (self:IsSpawnLogicFixedInterval()) then
		self:InitializeFixedInterval();
	end

	self:RegisterGlobalEventOnSelf(g_eventTypes.roundEndEvent, self.HandleRoundEnd);

	if (self.CONFIG.broadcastChannelPower ~= nil and self.CONFIG.broadcastChannelPower ~= "") then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectPowerUpdated, self.PowerBroadcastReceived, self.CONFIG.broadcastChannelPower);
	elseif (self.CONFIG.broadcastChannelControl ~= nil and self.CONFIG.broadcastChannelControl ~= "") then
		-- only register for control channel if we're not doing power
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectControlUpdated, self.ControlBroadcastReceived, self.CONFIG.broadcastChannelControl);
	end
end

function MPItemPlacement:HandleRoundEnd():void
	self:ForceDormantState();
	
	if (self.spawnedHologramObject ~= nil) then
		Object_Delete(self.spawnedHologramObject);
		self.spawnedHologramObject = nil;
	end
end

function MPItemPlacement:RenormalizeOverrideWeights():void	-- virtual
	self.categoryWeightOverrides = self.itemManager:RenormalizeCategoryWeightings(self.categoryWeightOverrides);
end

function MPItemPlacement:AssignInitialItemTag():void	-- virtual
end

function MPItemPlacement:InitializeContainer():void		-- virtual
	self:InitializeContainerBase();
end

function MPItemPlacement:InitializeContainerBase():void
	self:DebugPrint("MPItemPlacement:InitializeContainerBase():", self.instanceName);
	self.deploymentState = DeploymentState.Dormant;

	if (self.isHidden) then
		-- entire placement disabled
		return;
	end

	if (self.CONFIG.pingMessaging) then
		self:RegisterEventOnSelf(g_eventTypes.spartanTrackingPingObjectEvent, self.OnSpawnedItemPinged, self.containerObject);
	end

	if (self.hasInvisibleDispenser) then
		-- just hide the asset but still function as usual
		object_hide(self.containerObject, true);
	end

	if (self.spawnMarker ~= nil and self.spawnMarker ~= "") then
		self.spawnMarkerWorldPos = Object_GetMarkerWorldPosition(self.containerObject, self.spawnMarker);
		local containerPos:location = Object_GetPosition(self.containerObject);
		self.spawnMarkerHeight = self.spawnMarkerWorldPos.z - containerPos.vector.z;
	end

	self.deploymentState = DeploymentState.Dormant;

	if (not self.hasInvisibleDispenser) then
		Device_SetPower(self.containerObject, 0);
		self:SetStatusBarColor(self.CONST.inactiveColor, 0);
	end

	if (self.itemShouldRotate) then
		RunClientScript("SetVisibilityWakeManagerDistances", self.containerObject, self.CONST.wakeWithinDistance, self.CONST.sleepBeyondDistance);
	end

	self:DoInitialSpawn();
end

function MPItemPlacement:PowerBroadcastReceived(eventArgs:CommunicationObjectPowerUpdateEventStruct):void
	if (eventArgs.isPowered) then
		self:Show();
	else
		self:Hide();
	end
end

function MPItemPlacement:ControlBroadcastReceived(eventArgs:CommunicationObjectControlUpdateEventStruct):void
	if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.ExternalTrigger) then
		self:CreateThread(self.TriggerItemSpawn);
	end
end

function MPItemPlacement:CalculateNavpointDisplayDuration(duration:number):void
	local navDuration:number = 0;

	if (self:IsSpawnLogicFixedInterval()) then
		navDuration = math.max(duration, 0);
		self.navpointDisplayDuration = math.min(navDuration, self.CONST.defaultNavpointDisplayDuration);
	else
		navDuration = math.max(duration - self.CONST.mandatoryDormantPeriod, 0);
		self.navpointDisplayDuration = math.min(navDuration, self.CONST.defaultNavpointDisplayDuration);
	end
end

function MPItemPlacement:DoInitialSpawn():void
	self:DebugPrint("MPItemPlacement:DoInitialSpawn()");
	if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.ExternalTrigger) then
		return;
	end

	self.canDisplayReadyMessage = false;

	if (self.CONFIG.initialSpawnDelay <= 0) then							-- spawn right away if there was no specified initial delay
		self:DebugPrint("MPItemPlacement:DoInitialSpawn():", self.itemIdentifier, " - Immediate");

		Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointItemTypeVisualState, self:GetNavpointPresentationItemType());
		Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointTierVisualState, self:GetNavpointPresentationTierName());
		self:SetNavpointsCanBeOccluded(false);
		self:SetNavpointPositionalOffset();
		if (self.CONFIG.navpointPinningEnabled) then
			Navpoint_SetVisibleOffscreen(self.mainNavpoint, self.CONFIG.navpointPinnedNearingSpawn);
		else
			Navpoint_SetVisibleOffscreen(self.mainNavpoint, false);
		end

		self:StartSpawningState();
		self:CreateThread(self.DelayedInitialSpawnEffect);
	end

	self:CreateThread(self.StartLifecycleAfterIntroCompletion);
end

function MPItemPlacement:StartLifecycleAfterIntroCompletion():void
	if (self:CanTriggerExternally()) then
		return;
	end

	self:DebugPrint("MPItemPlacement:StartLifecycleAfterIntroCompletion() - Start");
	SleepUntilIntroComplete();
	self:DebugPrint("MPItemPlacement:StartLifecycleAfterIntroCompletion() - End");

	if (self:IsSpawnLogicFixedInterval()) then
		GlobalStopwatchDaemon:StartDiscreteIntervalStopwatchForTarget(self, self.fixedIntervalStopwatch);
	end

	if (self.CONFIG.initialSpawnDelay <= 0) then
		return;
	end

	local originalIncoming:number = self.incomingDuration;
	self.incomingDuration = self.CONFIG.initialSpawnDelay;
	self.closeAnimationHasCompleted = true;
	self:CalculateNavpointDisplayDuration(self.CONFIG.initialSpawnDelay);
	self:StartIncomingState();

	-- ok, that pesky initial delay is over with, let's go back to the real incoming duration
	self.incomingDuration = originalIncoming;
	self:CalculateNavpointDisplayDuration(self.CONFIG.respawnTime);
end

function MPItemPlacement:StartIncomingState():void		-- virtual
	self:StartIncomingStateBase();
end

function MPItemPlacement:StartIncomingStateBase():void
	self:DebugPrint("MPItemPlacement:StartIncomingStateBase():", self.itemIdentifier);

	if (self.CONFIG.isMessagingVisible) then
		self.canDisplayReadyMessage = true;
	end

	if (self:CanDeploy()) then
		self.deploymentState = DeploymentState.Incoming;
		local incomingWaitTime:number = self.incomingDuration;
		local playVizFX:boolean = true;					-- assume pfx and hologram will show up immediately (conditions may vary, refer to terms of service below)

		if (self.CONFIG.isMessagingVisible) then
			local navpointWaitTime = 0;													-- assume we're showing the navpoint right at start of incoming phase

			if (incomingWaitTime > self.navpointDisplayDuration) then					-- nope, there's more than default time (30 secs) remaining so let's sleep it off
				navpointWaitTime = incomingWaitTime - self.navpointDisplayDuration;
			end

			self:UpdateNavpointText(self.CONFIG.navpointIncomingText);

			playVizFX = false;															-- not ready to turn on incoming viz effects until navpoint comes
			self:CreateThread(self.DelayedMessagingRoutine, navpointWaitTime, true);	-- turn on navpoint and possibly hologram preview when ready (could be immediately if close to spawn)

		elseif (self.previewAsHologram and self.incomingDuration > self.CONST.hologramDisplayDuration) then
			-- no navpoints here, so hologram & viz effects should delay if longer than default time so turn on effect and hologram preview when ready
			playVizFX = false;																									
			self:CreateThread(self.DelayedMessagingRoutine, incomingWaitTime - self.CONST.hologramDisplayDuration, false);		
		end

		self:EnableRestrictedEffect(false);
		self:EnableIncomingEffect(true, playVizFX, true);

		self:SetStatusBarColor(self.CONST.inactiveColor, self.CONST.colorLerpTime);
		self:CreateThread(self.PlayIncomingAnimationWhenAllowed, incomingWaitTime);

		-- only preview here if we're not waiting for incoming periods longer than default wait (navpoints regardless)
		if (self.previewAsHologram and playVizFX) then
			self:StockContainerPreview();
		end

		-- Wait to deliver the "incoming" VO messaging (and changing the navpoint pinning state) until we get closer to the spawn
		if (self.CONFIG.isMessagingVisible) then
			if (incomingWaitTime > self.CONFIG.nearingSpawnTime) then
				SleepSeconds(incomingWaitTime - self.CONFIG.nearingSpawnTime);
				incomingWaitTime = self.CONFIG.nearingSpawnTime;
				self:MessagingIncoming();
			else
				self:MessagingIncoming();
			end
		end

		local imminentSpawnDuration = self:GetImminentSpawnCheckDuration();
		assert(imminentSpawnDuration <= incomingWaitTime, "The imminent spawn duration must be shorter than the incoming period for " .. self.instanceName .. " | Imminent Duration: " .. imminentSpawnDuration .. " Incoming duration: " .. incomingWaitTime);

		SleepSeconds(incomingWaitTime - imminentSpawnDuration);
		self:OnSpawningImminent();

		if (imminentSpawnDuration > 0) then
			SleepSeconds(imminentSpawnDuration);
		end

		self:StartSpawningState();
	else
		self:GoToRestrictedState();
	end
end

function MPItemPlacement:DelayedMessagingRoutine(delay:number, navpoint:boolean):void
	self:DebugPrint("MPItemPlacement:DelayedMessagingRoutine()");
	SleepSeconds(delay);

	self:EnableIncomingEffect(true, true, false);	-- turn on visual, but not audio (already on)

	if (self.previewAsHologram) then
		self:StockContainerPreview();
	end

	if (navpoint) then
		Navpoint_SetEnabled(self.mainNavpoint, true);	
		self:DisplayNavpoint();
	end
end

function MPItemPlacement:InitializeFixedInterval():void
	self:DebugPrint("MPItemPlacement:InitializeFixedInterval():", self.instanceName);

	-- "Static (Time)" spawners can only spawn items at multiples of the respawn time, i.e. 1:00, 2:00, 17:00, etc.

	TryAndCreateGlobalStopwatchDaemonParcel();

	self.fixedIntervalStopwatch = GlobalStopwatchDaemon:CreateDiscreteIntervalStopwatch(
		self,
		self.CONFIG.respawnTime,
		self.HandleFixedIntervalExpired,
		false,
		self.instanceName .. "_FixedIntervalStopwatch");
end

function MPItemPlacement:HandleFixedIntervalExpired():void
	self:DebugPrint("MPItemPlacement:HandleFixedIntervalExpired:", self.instanceName);
	-- the logic of when to spawn next item happens in the incoming state, either triggered at pickup or end of restricted stage
end

function MPItemPlacement:StartFixedIntervalIncomingState():void
	-- set proper incoming duration
	self.incomingDuration = self:GetTimeUntilNextFixedInterval();

	if (not self:DoesEnoughTimeRemainForFixedIntervalSpawn(self.incomingDuration)) then
		-- not enough time for the next spawn, so let's wait until the following interval
		self.incomingDuration = self.incomingDuration + self.CONFIG.respawnTime;
	end

	self:CalculateNavpointDisplayDuration(self.incomingDuration);
	self:CreateThread(self.StartIncomingState);
end

function MPItemPlacement:GetTimeUntilNextFixedInterval():number
	return self.CONFIG.respawnTime - GlobalStopwatchDaemon:GetElapsedTimeForTarget(self, self.fixedIntervalStopwatch);
end

function MPItemPlacement:DoesEnoughTimeRemainForFixedIntervalSpawn(remainingTime:number):boolean
	return remainingTime >= self.CONST.minimumFixedIntervalIncomingPeriod;
end

function MPItemPlacement:OnSpawningImminent():void					-- virtual
end

function MPItemPlacement:GetImminentSpawnCheckDuration():number		--virtual
	return 0;
end

function MPItemPlacement:StartSpawningState():void	-- override
	self:DebugPrint("MPItemPlacement:StartSpawningState()");

	if (self.deploymentState == DeploymentState.Restricted) then
		return;	-- Incoming state could have been interrupted while we slept
	end

	self:PlayOpenAnimation();
	self:CreateThread(self.StartCloseAnimationProhibitionPeriod);
	self:StockContainer();

	self:EnableIncomingEffect(false);
	self:EnableSpawnedEffect(true);

	self.resetThread = nil;
	self.delayedResetThread = nil;
	self.lifecycleThread = nil;
end

function MPItemPlacement:StartCloseAnimationProhibitionPeriod():void
	self.openAnimationHasCompleted = false;
	self.closeAnimationHasCompleted = false;
	SleepSeconds(self.CONFIG.prohibitCloseAnimPeriod);
	self.openAnimationHasCompleted = true;
	self:DebugPrint("Open animation completed - close no longer prohibited");
end

function MPItemPlacement:WaitForRotation():void		-- virtual
	SleepSeconds(self.CONFIG.rotationDelay);

	if (self.deploymentState == DeploymentState.Spawned) then	-- while waiting item could have been picked up
		self:GotoRotatingAnimState();
	end
end

function MPItemPlacement:PlayIncomingAnimationWhenAllowed(duration:number):void
	self:DebugPrint("PlayIncomingAnimationWhenAllowed(), delay = ", duration);
	SleepUntil([| self.closeAnimationHasCompleted], 1);
	self:PlayIncomingAnimation(duration);
end

function MPItemPlacement:PlayIncomingAnimation(duration:number):void
	self:DebugPrint("MPItemPlacement:PlayIncomingAnimation()");
	if (self.hasInvisibleDispenser) then
		return;
	end

	self:SetLoadingAnimationPlayRate(duration);
	self:GotoLoadingAnimState();
end

function MPItemPlacement:StockContainer():void	-- virtual
end

function MPItemPlacement:StockContainerBase():void
	if (self.previewAsHologram and self.spawnedHologramObject ~= nil) then
		self:ItemHologramConversion(false);
	end

	if (self.spawnedItemObject == nil) then
		self:CreateItemObject();
	end

	if (self:SpawnWasSuccessful()) then
		self:OnSuccessfulSpawn();
	end
end

function MPItemPlacement:OnSuccessfulSpawn():void			-- override
	self:DebugPrint("MPItemPlacement:OnSuccessfulSpawn()");

	self:OnSuccessfulSpawnBase();

	if (self.mainNavpoint ~= nil and self.navpointTierVisualState ~= nil) then
		Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointTierVisualState, self:GetNavpointPresentationTierName());
	end

	self:AddSpawnedItemToDeployedList();

	self:ApplyBotPOIAmbition(self.spawnedItemObject);
end

function MPItemPlacement:AddSpawnedItemToDeployedList():void	-- virtual
end

function MPItemPlacement:ForceItemToCorrectScale():void		-- override
	if (self.previewAsHologram and self.spawnedHologramObject ~= nil) then
		Object_SetScale(self.spawnedHologramObject, self.itemScale, 0);
	elseif (self.spawnedItemObject ~= nil) then
		Object_SetScale(self.spawnedItemObject, self.itemScale, 0);
	else
		print("Error: nil item object in MPItemPlacement:ForceItemToCorrectScale() for", self.instanceName);
	end
end

function MPItemPlacement:StockContainerPreview():void
	self:DebugPrint("MPItemPlacement:StockContainerPreview()");

	if (self.spawnedHologramObject ~= nil) then
		print("ERROR: A hologram preview already exists for", self.instanceName, "aborting.");
		return;
	end

	self:CreateItemObject();
	self:ItemHologramConversion(true);
	self:CreateThread(self.ForceScaleUpdateRoutine);
end

function MPItemPlacement:ItemHologramConversion(toHologram:boolean):void	-- virtual
	self:ItemHologramConversionBase(toHologram);
end

function MPItemPlacement:SetHologramPreviewStateEnabled(item:object, enable:boolean):void		-- virtual
	Object_SetHologramPreviewStateEnabled(item, enable);
end

function MPItemPlacement:ItemHologramConversionBase(toHologram:boolean):void
	self:DebugPrint("MPItemPlacement:ItemHologramConversion()", toHologram);

	if (toHologram) then
		self.spawnedHologramObject = self.spawnedItemObject;
		self.spawnedItemObject = nil;

		self:SetHologramPreviewStateEnabled(self.spawnedHologramObject, true);
		
		local fadeDurationMax:number = 1;

		if (self.CONFIG.isMessagingVisible) then
			fadeDurationMax = self.navpointDisplayDuration;
		else
			fadeDurationMax = self.incomingDuration;
		end
		
		local fadeDuration:number = fadeDurationMax;

		if (not self.CONFIG.hologramProgressFade) then
			fadeDuration = math.min(self.CONFIG.hologramFadeDuration, fadeDurationMax);
		end

		Object_SetHologramRuntimeOpacity(self.spawnedHologramObject, 0, self.CONFIG.hologramOpacity, fadeDuration);
		Object_SetHologramRuntimeColor(self.spawnedHologramObject, self:GetHologramPreviewColor());
		Object_SetEnemyLoopingSound(self.spawnedHologramObject, self:GetHologramLoopingSound());
		Object_SetFriendlyLoopingSound(self.spawnedHologramObject, self:GetHologramLoopingSound());
	else
		self:SetHologramPreviewStateEnabled(self.spawnedHologramObject, false);
		Object_StopLoopingSounds(self.spawnedHologramObject);
		self.spawnedItemObject = self.spawnedHologramObject;
		self.spawnedHologramObject = nil;

		RunClientScript("PlayNewItemSpawnEffect", self.spawnedItemObject, self:GetRezInEffect());
	end
end

function MPItemPlacement:GetRezInEffect():tag	-- virtual
	return MPItemSpawnerRezInEffects.baseItem;
end

function MPItemPlacement:GetHologramPreviewColor():object_runtime_hologram_color	-- virtual
	return OBJECT_RUNTIME_HOLOGRAM_COLOR.Default;
end

function MPItemPlacement:GetHologramLoopingSound():tag	-- virtual
	return nil;
end

function MPItemPlacement:SetPostSpawnState():void	-- virtual
	self.deploymentState = DeploymentState.Spawned;
end

function MPItemPlacement:ShouldSelectNewRandomItem():boolean	-- virtual
	return self:GetRandomRespawnFrequency() == MP_RANDOMIZE_FREQUENCY.Respawn and self:ItemIsNotExplicitlySpecified();
end

function MPItemPlacement:ItemIsNotExplicitlySpecified():boolean		-- virtual
	return self.explicitIdentifier == nil;
end

function MPItemPlacement:ItemIsExplicitlySpecified():boolean
	return not self:ItemIsNotExplicitlySpecified();
end

function MPItemPlacement:ShouldUseGamePersistentItem():boolean
	return self.explicitIdentifier ~= nil and self.CONFIG.respawnRandomFrequency == MP_RANDOMIZE_FREQUENCY.Game and Engine_GetRoundIndex() > 0;
end

function MPItemPlacement:LifecycleResetRoutine(playCloseAnim:boolean):void
	self:DebugPrint("MPItemPlacement:LifecycleResetRoutine():", self.itemIdentifier);
	if (playCloseAnim == nil) then
		playCloseAnim = true;
	end

	if (playCloseAnim) then
		self:CreateThread(self.PlayCloseAnimationWhenAllowed);
	end

	if (self:ShouldSelectNewRandomItem()) then
		self:SetSpawningItem();
	end

	-- Only start spawn process from DynamicOnPickup. FixedInterval will happen on timer callbacks, 
	-- and DynamicOnExpire will happen from thread kicked off at deletion/expiration, but let's say 
	-- we're restricted until then
	if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.DynamicOnPickup and self.CONFIG.respawnTime > 0) then
		self:RestartLifecycle();
	elseif (self:IsSpawnLogicFixedInterval()) then
		self:GoToDormantState();
	
		if (self:CanDeploy()) then
			self:StartFixedIntervalIncomingState();
		else
			self:GoToRestrictedState();
		end
	elseif (self:GetSpawnLogic() == MP_SPAWN_LOGIC.DynamicOnExpire) then
		self:GoToRestrictedState();
	end
end

function MPItemPlacement:PlayCloseAnimationWhenAllowed():void
	SleepUntil([| self.openAnimationHasCompleted], 1);
	self.closeAnimationHasCompleted = false;
	self:PlayCloseAnimation();
	SleepSeconds(self.CONFIG.closeAnimationDuration);
	self.closeAnimationHasCompleted = true;
	self:DebugPrint("Close animation has completed, incoming no longer prohibited");
end

function MPItemPlacement:RestartLifecycle():void
	self:DebugPrint("MPItemPlacement:RestartLifecycle()");
	self:GoToDormantState();

	SleepSeconds(self.CONST.mandatoryDormantPeriod);
	self:StartIncomingState();
end

function MPItemPlacement:DelayedResetRoutine():void	-- called when all items from this container have been cleaned up and deployment is allowed again
	self:DebugPrint("MPItemPlacement:DelayedResetRoutine()");
	if (self:IsSpawnLogicFixedInterval()) then
		self:GoToDormantState();
		self:StartFixedIntervalIncomingState();
	elseif (self:IsSpawnLogicDynamic()) then
		self:StartIncomingState();
	end
end

function MPItemPlacement:CanDeploy():boolean
	local belowLimit:boolean = table.countKeys(self.deployedItems) < self.CONFIG.maxDeployedItemCount;

	if (not belowLimit) then
		self:DebugPrint("MPItemPlacement:CanDeploy() Restricted - Deployed: ", table.countKeys(self.deployedItems), "Max Allowed:", self.CONFIG.maxDeployedItemCount);
	end

	return belowLimit;
end

function MPItemPlacement:ForceDormantState():void	-- virtual
	self:ForceDormantStateBase();
end

function MPItemPlacement:ForceDormantStateBase():void
	self:GoToDormantState();

	if (self.resetThread ~= nil) then
		self:KillThread(self.resetThread);
		self.resetThread = nil;
	end

	if (self.delayedResetThread ~= nil) then
		self:KillThread(self.delayedResetThread);
		self.delayedResetThread = nil;
	end
	
	if (self.lifecycleThread ~= nil) then
		self:KillThread(self.lifecycleThread);
		self.lifecycleThread = nil;
	end
end

function MPItemPlacement:GoToDormantState():void	-- override
	self:GoToDormantStateBase();
end

function MPItemPlacement:GoToDormantStateBase():void
	self:DebugPrint("MPItemPlacement:GoToDormantState()");
	self:EnableIncomingEffect(false);
	self:EnableSpawnedEffect(false);
	self:EnableRestrictedEffect(false);

	-- remove the picked up item from bot ambition objects
	self:RemoveBotPOIAmbition(self.spawnedItemObject);

	self.deploymentState = DeploymentState.Dormant;
	self:SetStatusBarColor(self.CONST.inactiveColor, self.CONST.colorLerpTime);
end

function MPItemPlacement:GoToRestrictedState():void		-- override
	self:DebugPrint("MPItemPlacement:GoToRestrictedState()");
	self:EnableRestrictedEffect(true);
	self:GoToRestrictedStateBase();
end

-- OVERRIDES

function MPItemPlacement:HandleOverrideReceived(itemManager:table):void	-- virtual
end

function MPItemPlacement:ProcessOverrideDataSetBase(overrideData:MPItemOverrideData):void
	if (overrideData.spawnLogic ~= MP_SPAWN_LOGIC.Kit) then
		self.CONFIG.spawnLogic = overrideData.spawnLogic;
	end

	if (overrideData.randomizeFrequency ~= MP_RANDOMIZE_FREQUENCY.Kit) then
		self.CONFIG.respawnRandomFrequency = overrideData.randomizeFrequency;
	end

	if (overrideData.legendaryItemUsage ~= MP_LEGENDARY_ITEM_USAGE.Kit) then
		self.CONFIG.legendaryItemUsage = overrideData.legendaryItemUsage;
	end

	if (overrideData.maxDeployCount > 0) then
		self.CONFIG.maxDeployedItemCount = overrideData.maxDeployCount;
	end

	if (overrideData.navpoint == 0) then
		self.CONFIG.isMessagingVisible = false;
	elseif (overrideData.navpoint ~= self.CONST.noManagerOverride) then
		self.CONFIG.isMessagingVisible = true;
	end

	if (overrideData.initialSpawnDelay > 0) then
		self.CONFIG.initialSpawnDelay = overrideData.initialSpawnDelay;
	end

	if (overrideData.respawnTime > 0) then
		self.CONFIG.respawnTime = overrideData.respawnTime;
		self.CONFIG.defaultIncomingDuration = math.max(self.CONFIG.respawnTime - self.CONST.mandatoryDormantPeriod, 0);
	end

	if (overrideData.seedSequenceKey ~= nil and overrideData.seedSequenceKey ~= "") then
		self.CONFIG.variantSeedSequenceKey = overrideData.seedSequenceKey;
	end

	if (overrideData.staticSelection == 0) then
		self.CONFIG.staticSelectionEnabled = false;
	elseif (overrideData.staticSelection ~= self.CONST.noManagerOverride) then
		self.CONFIG.staticSelectionEnabled = true;
	end

	for i = 0, #MP_ITEM_FACTION - 1 do
		if (overrideData.factionFilters[MP_ITEM_FACTION[i]] == 0) then
			self.factionFilters[MP_ITEM_FACTION[i]] = false;
		elseif (overrideData.factionFilters[MP_ITEM_FACTION[i]] ~= self.CONST.noManagerOverride) then
			self.factionFilters[MP_ITEM_FACTION[i]] = true;
		end
	end
end

function MPItemPlacement:TryOverridingItem():boolean	-- virtual
	return false;
end

function MPItemPlacement:AssignRandomItem():void
	local itemIdentifier:ui64 = self:GetRandomItem();
	self:AssignItemFromIdentifier(itemIdentifier, self.availableItemTable);
end

function MPItemPlacement:GetFullDefinitionTable():table		-- virtual
	return nil;
end

function MPItemPlacement:AssignItemFromIdentifier(itemIdentifier:ui64, definitionTable:table):void	-- virtual
	if (itemIdentifier ~= nil) then
		self.itemIdentifier = itemIdentifier;
	else
		self.itemIdentifier = self:GetFallbackIdentifier();
		definitionTable = self:GetFullDefinitionTable();		-- make sure fallback is there by using full table
		print("Warning: Invalid item selcted. Substituting fallback item.", self.itemIdentifier, self.class);
	end

	self:AssignItemFromDefinition(definitionTable[self.itemIdentifier]);
end

function MPItemPlacement:AssignItemFromDefinition(itemDef:MPItemTableEntry):void	-- virtual
	self:AssignItemFromDefinitionBase(itemDef);
end

function MPItemPlacement:AssignItemFromDefinitionBase(itemDef:MPItemTableEntry):void
	self.itemTag = itemDef.tag;
	self.itemStringId = itemDef.navpointStringId;

	if (itemDef.containerScale ~= nil) then
		self.itemScale = itemDef.containerScale;
	else
		self.itemScale = 1;
	end

	if (itemDef.navpointOffset ~= nil) then
		self.navpointVerticalOffset = itemDef.navpointOffset;
	else
		self.navpointVerticalOffset = self.CONST.defaultNavpointVerticalOffset;
	end
end

function MPItemPlacement:TryAndAssignLegendaryVariant(itemDef:MPItemTableEntry):void
	if (itemDef.legendaryVariants ~= nil and self.CONFIG.legendaryItemUsage ~= MP_LEGENDARY_ITEM_USAGE.Exclude) then
		local numLegendary:number = #itemDef.legendaryVariants;

		if (numLegendary > 0) then
			local minRange:number = 0;	-- by having the minimum at zero, we can choose not to pick an legendary variant if we're only including them, but force it if preferred with a min of 1

			if (self.CONFIG.legendaryItemUsage == MP_LEGENDARY_ITEM_USAGE.Preferred) then
				minRange = 1;
			end

			local legendaryIdx:number = random_range(minRange, numLegendary);
			
			if (legendaryIdx > 0) then
				self:AssignLegendaryVariantFromTag(itemDef, legendaryIdx);
			end
		end
	end
end

function MPItemPlacement:AssignLegendaryVariantFromTag(itemDef:MPItemTableEntry, legendaryIdx:number):void	-- virtual
	self:DebugPrint("MPItemPlacement:AssignLegendaryVariantFromTag");

	if (itemDef.legendaryVariants ~= nil and legendaryIdx <= #itemDef.legendaryVariants) then
		self.itemConfig = itemDef.legendaryVariants[legendaryIdx];
	end
end

function MPItemPlacement:GetFallbackIdentifier():ui64							-- virtual
	return nil;
end

function MPItemPlacement:RebuildAvailableItemTable():void						-- virtual
end

function MPItemPlacement:TryAndEscalateCategoryWeights():boolean				-- virtual
	if (self.itemManager.CONFIG.useEscalatingCategoryWeights) then
		self.itemManager:EscalateCategoryWeights();										-- global weighting table

		if (self.categoryWeightOverrides ~= nil) then
			self.itemManager:EscalateCategoryWeights(self.categoryWeightOverrides);		-- locally stored overrides if used
		end

		return true;
	end

	return false;
end

function MPItemPlacement:ChooseRandomizedCategory():void	-- virtual
	self.class = self.itemManager:ChooseRandomWeightedCategory(self, self.categoryWeightOverrides);
end

function MPItemPlacement:SetSpawningItem():void
	if (not self.canUseItemManager) then
		self:AssignRandomItem();
		self:SetVariant();
		return;
	end

	if (self.categoryIsRandom) then
		self:ChooseRandomizedCategory();
		self:HandleOverrideReceived(self.itemManager);	-- if we've changed a class or tier, we should reapply overrides that are per category
		self:RebuildAvailableItemTable();

		-- Escalate the weigting for picking a random class/tier. Let's only do this for spawns that happen in the course of action, not on level load
		if (self.hasDoneInitialSpawn or self.CONFIG.initialSpawnDelay > 0) then
			self:TryAndEscalateCategoryWeights();
		end
	end

	-- Despite all the other logic for figuring out the right item, it might have just been plain overriden
	if (self:TryOverridingItem()) then
		self:DebugPrint("Item was OVERRIDDEN - ", self.itemIdentifier, self.instanceName);
		self:SetVariant();
		return;
	end

	if (self.symmetricalChannelId ~= nil) then
		-- handle determination of whether to change item for channel or if channel should be wiped clean
		self.itemManager:UpdateChannelStatus(self.symmetricalChannelId, self);
	
		-- if we've already assigned a item for the channel, give it to each placement, otherwise pick a new one
		if (self.itemManager:HasChannelItemAssigned(self.symmetricalChannelId)) then
			local itemIdentifier = self.itemManager:GetChannelItem(self.symmetricalChannelId);
			self:AssignItemFromIdentifier(itemIdentifier, self:GetFullDefinitionTable());
			self:DebugPrint("USING assigned chanel item - ", self.itemIdentifier, self.itemTag);
		else
			self:AssignRandomItem();
			self.itemManager:AssignChannelItem(self.symmetricalChannelId, self.itemIdentifier);
			self:DebugPrint("ASSIGNING chanel item - ", self.itemIdentifier, self.itemTag);
		end
	
		self.itemManager:SetChannelItemSpawned(self.symmetricalChannelId, self);
	else
		self:AssignRandomItem();
	end

	self:SetVariant();
end

function MPItemPlacement:GetRandomItem():ui64
	local numAvailable:number = table.countKeys(self.availableItemTable);
	if (self.availableItemTable == nil or numAvailable == 0) then
		return nil;
	end

	if (not self.canUseItemManager) then
		local keys:table = table.getKeysAsArray(self.availableItemTable);
		local randomPick:number = random_range(1, numAvailable); 
		return self.availableItemTable[keys[randomPick]].identifier;
	end

	return self.itemManager:ChooseItemFromAvailableSet(self, self.availableItemTable);
end

function MPItemPlacement:GetSpawnLogic():mp_spawn_logic
	return self.CONFIG.spawnLogic;
end

function MPItemPlacement:CanTriggerExternally():boolean		-- override
	return self:GetSpawnLogic() == MP_SPAWN_LOGIC.ExternalTrigger;
end

function MPItemPlacement:IsSpawnLogicDynamic():boolean
	local logic:mp_spawn_logic = self:GetSpawnLogic();
	return logic == MP_SPAWN_LOGIC.DynamicOnPickup or logic == MP_SPAWN_LOGIC.DynamicOnExpire;
end

function MPItemPlacement:IsSpawnLogicFixedInterval():boolean
	return self:GetSpawnLogic() == MP_SPAWN_LOGIC.FixedInterval;
end

function MPItemPlacement:GetRandomRespawnFrequency():mp_randomize_frequency
	return self.CONFIG.respawnRandomFrequency;
end

function MPItemPlacement:SetVariant():void	-- virtual
end

function MPItemPlacement:Hide():void
	if (self.isHidden) then
		return;
	end

	self:DebugPrint("Hiding container: ", self.containerObject);

	self:OnPlacementHide();

	if (self.canUseItemManager) then
		self.itemManager:OnItemCleanedUp(self.itemIdentifier);
	end

	if (self.spawnedItemObject ~= nil) then
		Object_Delete(self.spawnedItemObject);
	end

	self.deployedItems = {};
	self.spawnedItemObject = nil;

	if (self.CONFIG.pingMessaging) then
		self:UnregisterEventOnSelf(g_eventTypes.spartanTrackingPingObjectEvent, self.OnSpawnedItemPinged, self.spawnedItemObject);
	end

	object_hide(self.containerObject, true);
	self.isHidden = true;
end

function MPItemPlacement:Show():void
	if (not self.isHidden) then
		return;
	end

	self:DebugPrint("Showing container: ", self.containerObject);
	
	self.isHidden = false;
	object_hide(self.containerObject, false);
	self:OnPlacementShow();
end

function MPItemPlacement:OnPlacementHide():void	-- virtual
end

function MPItemPlacement:OnPlacementShow():void	-- virtual
end

function MPItemPlacement:EnsureLegitimateFactionFilters():void	-- virtual
end

-- apply POI ambitions to objects that have a power item navpoint treatment
function MPItemPlacement:ApplyBotPOIAmbition(botAmbitionObject)
	if ((self:GetNavpointPresentationTierName() == self.CONST.navpointPresentationNamePower) and (self.CONFIG.isMessagingVisible == true)) then
		Bot_AddAmbitionObject(botAmbitionObject, BOT_AMBITION.POI, 1.0, MP_TEAM_DESIGNATOR.Neutral);
	end
end

function MPItemPlacement:RemoveBotPOIAmbition(botAmbitionObject)
	Bot_RemoveAmbitionObject(botAmbitionObject);
end

--
--	SEED SEQUENCE MANAGEMENT
--
function MPItemPlacement:SeedSequenceInitialize():boolean

	if (self.CONST.seedSequenceEnabled == true) then

		-- seed's root is the symetrical channel or the container object; this serves as an offset to the variant seed (if it exists)
		local seed = self.symmetricalChannelId or tostring(self.containerObject);

		-- create sequence for placement
		self.seedSequence = SeedSequence:New(seed, true);

		-- get variant seed sequence parent
		if (self.CONFIG.variantSeedSequenceKey ~= nil) then
			local seedSeqTable:table = GetGeneralMPItemGameVariantSeedSequenceKeyArgs();

			-- check if the key isn't a valid Game Variant type
			if (seedSeqTable[self.CONFIG.variantSeedSequenceKey] ==  nil) then
				debug_assert(true, "MPItemPlacement:SeedSequenceInitialize - Attempting to create in invalid game variant item placement type: " .. tostring(self.CONFIG.variantSeedSequenceKey));
				return false;
			end

			-- get the key sequence if it already exists
			self.parentSeedSequence = MPSeedSequenceManager:KeyGet(self.CONFIG.variantSeedSequenceKey);

			-- if it doesn't exist...
			if (self.parentSeedSequence == nil) then

				-- setup the new GameVarent Item Type Seed Sequence manager
				self.parentSeedSequence = SeedSequence:New(seedSeqTable[self.CONFIG.variantSeedSequenceKey].seed, true);

				-- add it to the manager so it can be referenced quickly
				MPSeedSequenceManager:KeyAdd(self.CONFIG.variantSeedSequenceKey, self.parentSeedSequence);

			end

			-- set the parent
			self.seedSequence:ParentSet(self.parentSeedSequence);

		end
		
		return (self.seedSequence ~= nil);

	end
	
	return false;
end

--
--	GET RANDOM MANAGEMENT
--
function MPItemPlacement:GetRandomRange(min:number, max:number):number

	if (self.CONST.seedSequenceEnabled == true) then
		local seedSeqTable:table = GetGeneralMPItemGameVariantSeedSequenceKeyArgs();

		-- check round reset; this was put in here to make sure there wouldn't be any race conditions between resetting the sequences, it has low-ish overhead and this function isn't called a ton so overhead should be minimal
		-- reset parent first
		if ((self.parentSeedSequence ~= nil) and (self.CONFIG.variantSeedSequenceKey ~= nil)) then

			-- check if the round reset has happened or not; if not, reset;
			if (self.parentSeedSequence.roundReset ~= Engine_GetRoundIndex()) then
				self.parentSeedSequence.roundReset = Engine_GetRoundIndex();

				if (seedSeqTable[self.CONFIG.variantSeedSequenceKey].roundReset) then
					self.parentSeedSequence:Reset();
				else
					self.parentSeedSequence:Next();	-- since the parent is just an "offset" it is important for it to skip to the "next" if not round reset to shift the seed value of the children in a predictible way
				end

			end

		end 

		return self.seedSequence:NextRandomSequenceRange(min, max);
	end

	-- use default random if seeds are disabled
	return random_range(min, max);

end

-- NAVPOINTS
function MPItemPlacement:IsMessagingCapable():boolean	--virtual
	return not self.CONFIG.hasInvisibleDispenser;
end

function MPItemPlacement:GetNavpointPresentationTierName():string	-- virtual
	if (self.deploymentState == DeploymentState.Incoming) then
		return self.CONST.navpointPresentationNameRecharging;
	else
		return self.CONST.navpointPresentationNameGeneral;
	end
end

function MPItemPlacement:SetNavpointPositionalOffset():void
	Navpoint_SetPositionOffset(self.mainNavpoint, vector(0, 0, self.spawnMarkerHeight + self.navpointVerticalOffset));
end

function MPItemPlacement:CreateNavpointVisualStates():void
	self.navpointItemTypeVisualState = Navpoint_VisualStates_CreateState(self.mainNavpoint);
	Navpoint_VisualStates_SetStateGroupName(self.mainNavpoint, self.navpointItemTypeVisualState, self.CONST.navpointPresentationItemTypeGroup);
	Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointItemTypeVisualState, self:GetNavpointPresentationItemType());
	
	self.navpointTierVisualState = Navpoint_VisualStates_CreateState(self.mainNavpoint);
	Navpoint_VisualStates_SetStateGroupName(self.mainNavpoint, self.navpointTierVisualState, self.CONST.navpointPresentationTierGroup);
	Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointTierVisualState, self.CONST.navpointPresentationNameGeneral);
end

function MPItemPlacement:GetNavpointPresentationItemType():string	-- virtual
	return self.CONST.navpointPresentationNameItemType;
end

function MPItemPlacement:CreateNavpoints():void	-- virtual
	self:DebugPrint("MPItemPlacement:CreateNavpoints()");
	self.respawnTimer = Engine_CreateTimer();

	if (self.respawnTimer == nil) then
		print("Error creating respawn timer for navpoint");
	end

	self.mainNavpoint = Navpoint_Create(self.CONST.navpointPresentationTagName);
	if (self.mainNavpoint ~= nil) then
		self:CreateNavpointVisualStates();
		
		if (self.CONFIG.navpointPinningEnabled) then
			if (self.CONFIG.isMessagingVisible) then
				Navpoint_SetVisibleOffscreen(self.mainNavpoint, self.CONFIG.navpointPinnedIncoming);
			else
				Navpoint_SetVisibleOffscreen(self.mainNavpoint, false);
			end
		end

		Navpoint_SetObjectParent(self.mainNavpoint, self.containerObject);
		self:SetNavpointsCanBeOccluded(true);
		self:ClearNavpointVisibilityFilter();
		Navpoint_SetVisibilityDistance(self.mainNavpoint, self.CONFIG.navpointVisibilityDistance);

		Navpoint_SetEnabled(self.mainNavpoint, false);
	else
		print("WARNING: Unable to create Navpoint for", self.instanceName);
	end
end

function MPItemPlacement:SetNavpointsCanBeOccluded(occlude:boolean):void
	Navpoint_SetCanBeOccluded(self.mainNavpoint, occlude);
end

function MPItemPlacement:ClearNavpointVisibilityFilter():void
	if (self.CONFIG.isMessagingVisible) then
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.mainNavpoint, true);
	else
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.mainNavpoint, false);
	end
end

function MPItemPlacement:UpdateNavpointText(text:string):void	
	local newText = text;

	if (self.itemStringId ~= nil) then
		newText = newText .. (self.itemStringId);
	end

	Navpoint_SetDisplayText(self.mainNavpoint, newText);
end

function MPItemPlacement:DisplayNavpoint():void
	self:DebugPrint("MPItemPlacement:DisplayNavpoint()");
	self:SetNavpointsCanBeOccluded(false);
	self:ClearNavpointVisibilityFilter();
	self:SetNavpointPositionalOffset();

	local incomingItemText = self.CONFIG.navpointIncomingText;

	if (self.itemStringId ~= nil) then
		incomingItemText = incomingItemText .. (self.itemStringId);
	end

	Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointItemTypeVisualState, self:GetNavpointPresentationItemType());
	Navpoint_VisualStates_SetStateUnfilteredName(self.mainNavpoint, self.navpointTierVisualState, self:GetNavpointPresentationTierName());
	Navpoint_SetDisplayText(self.mainNavpoint, incomingItemText);

	self:StartNavpointTimer();
end

function MPItemPlacement:StartNavpointTimer():void
	self:DebugPrint("MPItemPlacement:StartNavpointTimer()", self.navpointDisplayDuration);
	Timer_SetSecondsLeft(self.respawnTimer, self.navpointDisplayDuration);
	Timer_StartWithRate(self.respawnTimer, 1);
	Navpoint_SetTimer(self.mainNavpoint, TIMER_SLOT.Primary, self.respawnTimer);
end

function MPItemPlacement:OnSpawnedItemPinged(eventArgs:SpartanTrackingPingEventStruct):void
	local pingPlayer = Unit_GetPlayer(eventArgs.playerUnit);
	local wasOccluded = Navpoint_GetCanBeOccluded(self.mainNavpoint);

	Navpoint_SetEnabled(self.mainNavpoint, true);
	self:SetNavpointsCanBeOccluded(false);
	Navpoint_VisibilityFilter_SetPlayerDefaultFilter(self.mainNavpoint, pingPlayer, true);
	self:CreateThread(self.DelayDisableNavpoint, pingPlayer, wasOccluded);
end

function MPItemPlacement:DelayDisableNavpoint(pingPlayer:player, occlude:boolean):void
	SleepSeconds(self.CONST.navpointPingedDuration);

	if (not self.CONFIG.isMessagingVisible) then
		Navpoint_SetEnabled(self.mainNavpoint, false);
	end

	Navpoint_VisibilityFilter_SetPlayerDefaultFilter(self.mainNavpoint, pingPlayer, false);
	self:SetNavpointsCanBeOccluded(occlude);
end

-- MESSAGING 

function MPItemPlacement:MessagingIncoming():void	-- virtual
end

function MPItemPlacement:MessagingReady():void		-- virtual
end

function MPItemPlacement:MessagingPickedUp(lootingPlayer:player):void	-- virtual
end

function MPItemPlacement:MessagingIncomingBase():void	
	if (self.CONFIG.isMessagingVisible) then
		Navpoint_SetEnabled(self.mainNavpoint, true);
		if (self.CONFIG.navpointPinningEnabled) then
			Navpoint_SetVisibleOffscreen(self.mainNavpoint, self.CONFIG.navpointPinnedNearingSpawn);
		end
	end

	self:UpdateNavpointText(self.CONFIG.navpointIncomingText);
end

function MPItemPlacement:MessagingReadyBase():void
	if (self.CONFIG.isMessagingVisible) then
		Navpoint_SetEnabled(self.mainNavpoint, true);
	end

	self:UpdateNavpointText(self.CONFIG.navpointReadyText);
end

function MPItemPlacement:MessagingPickedUpBase(lootingPlayer:player):void
	Navpoint_SetEnabled(self.mainNavpoint, false);
	if (self.CONFIG.navpointPinningEnabled) then
		Navpoint_SetVisibleOffscreen(self.mainNavpoint, self.CONFIG.navpointPinnedIncoming);
	end
end

-- EFFECTS
function MPItemPlacement:GetIncomingEffect():tag	-- virtual
	return self.incomingParticleFX;
end

function MPItemPlacement:PlayEffectVisual(enable:boolean, effect:tag):void
	if (effect == nil) then
		return;
	end

	if (enable) then
		RunClientScript("DisplaySpawnerParticleEffect", self.containerObject, effect, self.CONST.effectMarkerName);
	else
		RunClientScript("RemoveSpawnerParticleEffect", self.containerObject, effect, self.CONST.effectMarkerName);
	end
end

function MPItemPlacement:PlayEffectAudio(enable:boolean, clip:tag):void
	if (enable) then
		Object_SetEnemyLoopingSound(self.containerObject, clip);
		Object_SetFriendlyLoopingSound(self.containerObject, clip);
	else
		Object_StopLoopingSounds(self.containerObject);
	end
end

function MPItemPlacement:EnableIncomingEffect(enable:boolean, doVisual:boolean, doAudio:boolean):void
	if (not enable or doVisual) then
		self:PlayEffectVisual(enable, self:GetIncomingEffect());
	end

	if (not enable or doAudio) then
		self:PlayEffectAudio(enable, MPItemSpawnerAudioAssets.incomingLoop);
	end
end

function MPItemPlacement:GetSpawnedEffect():tag	-- virtual
	return self.spawnedParticleFX;
end

function MPItemPlacement:EnableSpawnedEffect(enable:boolean):void	-- virtual
	self:PlayEffectVisual(enable, self:GetSpawnedEffect());
end

function MPItemPlacement:DelayedInitialSpawnEffect():void
	-- This is hacky, but apparently remoteClient calls aren't being received for spawner objects that do their spawning
	-- right at startup. Once things have settled, they appear to get through. This problem seems worse the larger
	-- the level is.
	SleepSeconds(2);

	if (self.deploymentState == DeploymentState.Spawned) then
		self:EnableSpawnedEffect(true);
	end
end

function MPItemPlacement:GetRestrictedAudio():tag		-- virtual
	return MPItemSpawnerAudioAssets.restrictedLoop;
end

function MPItemPlacement:EnableRestrictedEffect(enable:boolean):void
	self:PlayEffectVisual(enable, self.restrictedParticleFX);
	self:PlayEffectAudio(enable, self:GetRestrictedAudio());
end


-- UTILITY

function MPItemPlacement:ConvertPercentageStringToNormalizedValue(stringPct):number
	local normalizedVal:number = 0;

	if (stringPct == "Max") then
		normalizedVal = math.huge;							-- should be clamped to a reasonable value upon use
	else
		local ammoStripped:string = stringPct:sub(1, -2);	-- strip off the percentage sign
		normalizedVal = tonumber(ammoStripped) / 100;
	end

	return normalizedVal or 0;								-- catch nil returned by non-numerical string passed to tonumber
end

-- DEBUGGING

function MPItemPlacement:DebugPrint(...):void	-- override
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	local managerPrintingEnabled = self.canUseItemManager and self.itemManager.CONFIG.enableDebugPrint;
	if (self.CONFIG.enableDebugPrint or managerPrintingEnabled) then
		if (self.CONFIG.debugPrintInstance == nil or self.CONFIG.debugPrintInstance == self.instanceName) then
			print(...);

			if (self.CONFIG.enableDebugLogging or self.itemManager.CONFIG.enableDebugLogging) then
				local logFn = _G["AddMPItemLogEntry"];
				if (logFn ~= nil) then
					logFn(self, ...);
				end
			end
		end
	end	
end

--## CLIENT

function remoteClient.DisplaySpawnerParticleEffect(container:object, effect:tag, markerName:string)
	if (container ~= nil) then
		HsEffectTryAndCreateNewAtObjectMarker(effect, container, markerName);
	end
end

function remoteClient.RemoveSpawnerParticleEffect(container:object, effect:tag, markerName:string)
	if (container ~= nil) then
		effect_kill_object_marker(effect, container, markerName);
	end
end

function remoteClient.SetVisibilityWakeManagerDistances(container:object, wakeWithinDistance:number, sleepBeyondDistance:number)
	Object_SetVisibilityWakeManagerWakeWithinDistance(container, wakeWithinDistance);
	Object_SetVisibilityWakeManagerSleepBeyondDistance(container, sleepBeyondDistance);
end

function remoteClient.PlayNewItemSpawnEffect(item:object, fx:tag)
	if (item ~= nil) then
		HSEffectPlayFromObject(fx, item);
	end
end
