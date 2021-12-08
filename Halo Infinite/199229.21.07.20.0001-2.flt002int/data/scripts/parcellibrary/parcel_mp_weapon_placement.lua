-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_lua_events.lua');
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_manager.lua');
REQUIRES('scripts\parcellibrary\parcel_mp_item_placement.lua');
REQUIRES('multiplayer\lua\weaponconstants.lua');

--//////
-- Parcel Setup
--//////

global MPWeaponPlacement:table = MPItemPlacement:CreateSubclass();

MPWeaponPlacement.parcelName = "MPWeaponPlacement";

MPWeaponPlacement.className = nil;
MPWeaponPlacement.tierName = nil;
MPWeaponPlacement.tier = nil;
MPWeaponPlacement.hologramIconPosition = 0;
MPWeaponPlacement.exhaustedWeapons = {};		-- any weapons deployed from this placement that are now out of ammo

MPWeaponPlacement.spawnMarker = "mkr_weapon";
MPWeaponPlacement.childMarker = "weapon_pad_offset";

MPWeaponPlacement.doDamageDetach = false;
MPWeaponPlacement.damageDetachMaxDistanceSq = 1;
MPWeaponPlacement.damageForceModifierHorz = 1;
MPWeaponPlacement.damageForceModifierVert = 1;
MPWeaponPlacement.damageDetachMinAngleCosine = 0;
MPWeaponPlacement.damageDetachMaxAngleCosine = 0;
MPWeaponPlacement.damageDetachMinAngleRad = 0;
MPWeaponPlacement.damageDetachMaxAngleRad = 0;

MPWeaponPlacement.CONFIG.initialAmmoModifier = 1;

MPWeaponPlacement.CONFIG.intelNavpointIncomingColor = color_rgba(0.4, 0.4, 0.4, 0.1);
MPWeaponPlacement.CONFIG.intelNavpointReadyColor = color_rgba(0.15, 1, 0.25, 1.0);

MPWeaponPlacement.CONST.damageDetachType = Engine_ResolveStringId("plasma_explosion_heavy");
MPWeaponPlacement.CONST.damageDetachMaxDistance = 1.25;
MPWeaponPlacement.CONST.navpointPresentationNameItemType = "weapon";	-- override
MPWeaponPlacement.CONST.wakeWithinDistance = 32;
MPWeaponPlacement.CONST.sleepBeyondDistance = 35;

MPWeaponPlacement.CONST.hologramIconSelectionName = {};
MPWeaponPlacement.CONST.hologramIconColorName = Engine_ResolveStringId("weapon_icon_color");
MPWeaponPlacement.CONST.restrictedHologramIconColor = 0;
MPWeaponPlacement.CONST.baseTierHologramIconColor = 0.5;
MPWeaponPlacement.CONST.powerTierHologramIconColor = 1;
MPWeaponPlacement.CONST.damageDetachMinAngle = 30;	-- degrees
MPWeaponPlacement.CONST.damageDetachMaxAngle = 75;	-- degrees

function MPWeaponPlacement:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function MPWeaponPlacement:NewWeaponPlacement(initArgs:MPWeaponPlacementInitArgs):table
	assert(initArgs ~= nil);

	local newMPWeaponPlacement = self:NewItemPlacement(
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

	newMPWeaponPlacement.tierName = initArgs.weaponTier;

	if (newMPWeaponPlacement.tierName == "Base") then
		newMPWeaponPlacement.tier = MP_WEAPON_TIER.Base;
	elseif (newMPWeaponPlacement.tierName == "Power") then
		newMPWeaponPlacement.tier = MP_WEAPON_TIER.Power;
	else
		newMPWeaponPlacement.tier = nil;	-- "Any"
	end

	newMPWeaponPlacement.categoryIsRandom = newMPWeaponPlacement.tier == nil;

	newMPWeaponPlacement.className = initArgs.weaponClass;

	if (newMPWeaponPlacement.className == "Pistol") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.Pistol;
	elseif (newMPWeaponPlacement.className == "Assault Rifle") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.AssaultRifle;
	elseif (newMPWeaponPlacement.className == "Tactical Rifle") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.TacticalRifle;
	elseif (newMPWeaponPlacement.className == "SMG") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.SMG;
	elseif (newMPWeaponPlacement.className == "Shotgun") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.Shotgun;
	elseif (newMPWeaponPlacement.className == "Sniper Rifle") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.SniperRifle;
	elseif (newMPWeaponPlacement.className == "Launcher") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.Launcher;
	elseif (newMPWeaponPlacement.className == "Melee") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.Melee;
	elseif (newMPWeaponPlacement.className == "Anti-Vehicle") then
		newMPWeaponPlacement.class = MP_WEAPON_CLASS.AntiVehicle;
	else
		newMPWeaponPlacement.class = nil;	-- "Any"
	end

	if (initArgs.weapon ~= nil and initArgs.weapon ~= "Random (Default)") then
		newMPWeaponPlacement.explicitIdentifier = newMPWeaponPlacement:WeaponStringToIdentifier(initArgs.weapon);
	end

	if (initArgs.ammoModifier ~= nil) then
		newMPWeaponPlacement.CONFIG.initialAmmoModifier = self:ConvertPercentageStringToNormalizedValue(initArgs.ammoModifier);		-- will be clamped to max rounds on set
	end

	newMPWeaponPlacement.doDamageDetach = initArgs.plasmaExplosionDetach or false;
	newMPWeaponPlacement.damageForceModifierHorz = initArgs.plasmaForceModHorz or 1;
	newMPWeaponPlacement.damageForceModifierVert = initArgs.plasmaForceModVert or 1;

	return self:TryAndApplyPresets(newMPWeaponPlacement, initArgs.spawnProperties);
end

function MPWeaponPlacement:TryAndApplyPresets(newPlacement:table, spawnPropType:string):table
	if (spawnPropType == "Default") then
		local presets:table = GetMPWeaponSpawnerPresets();
		local gameMode:number = GetItemSpawnerPresetGameModeType();

		local presetTier:mp_weapon_tier = MP_WEAPON_TIER.Base;

		if (newPlacement.tier ~= MP_WEAPON_TIER.Base) then
			presetTier = MP_WEAPON_TIER.Power;	-- accomodate "Any"
		end

		local props:MPWeaponPropertyPreset = presets[gameMode][presetTier][newPlacement.class];

		if (props ~= nil) then
			newPlacement.CONFIG.spawnLogic = props.spawnLogic;
			newPlacement.CONFIG.respawnRandomFrequency = props.randomizeFreq;
			newPlacement.CONFIG.initialSpawnDelay = props.initialSpawnDelay;
			newPlacement.CONFIG.respawnTime = props.respawnTime;
			newPlacement.CONFIG.defaultIncomingDuration = math.max(props.respawnTime - newPlacement.CONST.mandatoryDormantPeriod, 0);
			newPlacement.CONFIG.maxDeployedItemCount = props.maxDeployedItemCount;
			newPlacement.CONFIG.initialAmmoModifier = props.ammoModifier;

			newPlacement.factionFilters[MP_ITEM_FACTION.UNSC] = props.faction == MP_ITEM_FACTION.UNSC or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Banished] = props.faction == MP_ITEM_FACTION.Banished or props.faction == nil;
			newPlacement.factionFilters[MP_ITEM_FACTION.Forerunner] = props.faction == MP_ITEM_FACTION.Forerunner or props.faction == nil;
		end
	end

	return newPlacement;
end

function MPWeaponPlacement:AcquireItemManager():void	-- override
	self.itemManager = _G["MPWeaponManagerInstance"];
	self.canUseItemManager = self.itemManager ~= nil;
end

function MPWeaponPlacement:InitializeImmediate():void	-- override
	self:InitializeImmediateWeapon();
end

function MPWeaponPlacement:InitializeImmediateWeapon():void
	if (self.CONFIG.maxDeployedItemCount == 0) then
		self.CONFIG.maxDeployedItemCount = math.huge;
	end

	-- cache some values needed for knocking weapons off the pads with plasma grenades
	self.damageDetachMinAngleRad = math.rad(self.CONST.damageDetachMinAngle);
	self.damageDetachMaxAngleRad = math.rad(self.CONST.damageDetachMaxAngle);
	self.damageDetachMinAngleCosine = math.cos(self.damageDetachMinAngleRad);
	self.damageDetachMaxAngleCosine = math.cos(self.damageDetachMaxAngleRad);
	self.damageDetachMaxDistanceSq = self.CONST.damageDetachMaxDistance * self.CONST.damageDetachMaxDistance;

	self:InitializeImmediateBase();

	if (self:IsWeaponFlightBanned(self.explicitIdentifier)) then
		self:HandleBannedExplicitIdentifier();
	end
end

function MPWeaponPlacement:Run():void
	--Run is used once the Parcel is officially kicked off.
	if (self.CONFIG.isMessagingVisible and Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts")) then
		RunClientScript("IntelMapSetWeaponPlacementIcon", self.containerObject, "intel_map_icon_circle", self.CONFIG.intelNavpointIncomingColor);
		SleepSeconds(IntelMap_GetIntroEndTime() * 0.5);		--TODO: Tie this reveal to a hui event from olympus_multiplayer.user_interface_globals_definition once it's created
		RunClientScript("IntelMapSetWeaponPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, self.itemStringId);
	end

	self:SleepUntilValid();

	self:CreateThread(self.InitializeContainer);
end

--
--	INTERNAL PARCEL LOGIC
--

function MPWeaponPlacement:InitializeContainer():void	-- override
	if (self.containerObject ~= nil) then
		if (self.doDamageDetach and self:GetAccelerationProxy() ~= nil) then
			self:RegisterEventOnSelf(g_eventTypes.objectDamageAccelerationEvent, self.OnDamageAccelerationApplied, self:GetAccelerationProxy());
		end

		self:InitializeContainerBase();

		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.Pistol] = Engine_ResolveStringId("pistol_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.AssaultRifle] = Engine_ResolveStringId("assault_rifle_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.TacticalRifle] = Engine_ResolveStringId("tactical_rifle_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.SMG] = Engine_ResolveStringId("smg_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.Shotgun] = Engine_ResolveStringId("shotgun_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.SniperRifle] = Engine_ResolveStringId("sniper_rifle_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.Launcher] = Engine_ResolveStringId("launcher_icon_selection");
		self.CONST.hologramIconSelectionName[MP_WEAPON_CLASS.Melee] = Engine_ResolveStringId("melee_icon_selection");

		self:HideHologramIcon();
	end
end

function MPWeaponPlacement:GetAccelerationProxy():object -- virtual
	return self.containerObject;
end

function MPWeaponPlacement:OnDamageAccelerationApplied(eventArgs:ObjectDamageAccelerationAppliedEventStruct):void
	self:DebugPrint("MPWeaponPlacement:OnDamageAccelerationApplied()", eventArgs.damageType, eventArgs.damageSource);
	if (self:GetAccelerationProxy() == eventArgs.acceleratedObject and 
		eventArgs.damageType == self.CONST.damageDetachType and 
		eventArgs.damageSource == PlasmaGrenadeObjectName and 
		self.deploymentState == DeploymentState.Spawned and
		self.spawnedItemObject ~= nil) then

		-- let's just correct to use the direction to the weapon, not container
		local toWeapon = self.spawnMarkerWorldPos - eventArgs.epicenter;

		if (toWeapon.lengthSq > self.damageDetachMaxDistanceSq) then
			return;
		end

		self:DebugPrint("Knocking weapon of pad from plasma explosion");

		Object_Detach(self.spawnedItemObject);
		self:TriggerEvent(self.EVENTS.onItemBlastDetach, self.spawnedItemObject);

		-- acceleration is now normalized so that force applied will always be the same as long as inside max distance
		local acceleration:vector = Vector_Normalize(toWeapon);

		-- let's adjust the angle if almost vertical or almost horizontal for better looking results
		local accelHorz:vector = vector(acceleration.x, acceleration.y, 0);
		accelHorz = Vector_Normalize(accelHorz);

		local dot = acceleration ^ accelHorz;

		if (dot > self.damageDetachMinAngleCosine) then					-- these seem backwards, but cosines go from 1 -> 0
			self:DebugPrint("too low, adjusting angle", dot);
			accelHorz.z = math.tan(self.damageDetachMinAngleRad);		-- we had a unit vector here, opp = adj * tan(angle)
			acceleration = Vector_Normalize(accelHorz);
		end
		
		if (dot < self.damageDetachMaxAngleCosine) then
			self:DebugPrint("too high, adjusting angle", dot);
			accelHorz.z = math.tan(self.damageDetachMaxAngleRad);
			acceleration = Vector_Normalize(accelHorz);
		end

		acceleration.x = acceleration.x * self.damageForceModifierHorz;
		acceleration.y = acceleration.y * self.damageForceModifierHorz;
		acceleration.z = acceleration.z * self.damageForceModifierVert;

		Object_ApplyCenterOfMassAccelerationUnscaled(self.spawnedItemObject, acceleration);
		self:ProcessBasicWeaponPickup();

		if (self.CONFIG.isMessagingVisible) then
			Navpoint_SetEnabled(self.mainNavpoint, false);
		end
	end
end

function MPWeaponPlacement:ItemIsNotExplicitlySpecified():boolean		-- override
	return self.explicitIdentifier == nil or
		not self.CONFIG.staticSelectionEnabled or
		self.explicitIdentifier == MP_WEAPON_IDENTIFIER.None;
end

function MPWeaponPlacement:HandleBannedExplicitIdentifier():void
	-- ok, we explicitly have specified a banned weapon, let's find another one from that weapon's class or fallback class if possible
	local allWeaponsTable:table = self:GetFullDefinitionTable();
	local itemDef:MPWeaponTableEntry = allWeaponsTable[self.explicitIdentifier];

	if (itemDef ~= nil) then
		self.class = itemDef.class;
		self:GenerateAvailableWeaponsTable(allWeaponsTable);

		if (table.countKeys(self.availableItemTable) > 0) then
			-- something from our own class is available
			self.explicitIdentifier = table.anyVal(self.availableItemTable).identifier;
		else
			-- change class to fallback (if one exists), try again
			local fallbackTier:mp_weapon_tier = self.tier or MP_WEAPON_TIER.Base;
			local fallbackClass:mp_weapon_class = MPWeaponClassFallbacks[fallbackTier][itemDef.class];

			if (fallbackClass == nil) then
				if (fallbackTier == MP_WEAPON_TIER.Power) then
					fallbackClass = MPWeaponClassFallbacks[MP_WEAPON_TIER.Base][itemDef.class];
				else
					fallbackClass = MPWeaponClassFallbacks[MP_WEAPON_TIER.Power][itemDef.class];
				end
			end

			if (fallbackClass ~= nil) then
				self.class = fallbackClass;
				self:GenerateAvailableWeaponsTable(allWeaponsTable);
				
				if (table.countKeys(self.availableItemTable) > 0) then
					self.explicitIdentifier = table.anyVal(self.availableItemTable).identifier;
				end
			end
		end
	end
end

function MPWeaponPlacement:AssignInitialItemTag():void	-- override
	SleepOneFrame();	-- let all placements register themselves with manager before making potential channel decisions

	local allWeaponsTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableWeaponsTable(allWeaponsTable);

	if (self:ItemIsExplicitlySpecified() or self:ShouldUseGamePersistentItem()) then
		self:AssignItemFromIdentifier(self.explicitIdentifier, allWeaponsTable);
	elseif (table.countKeys(self.availableItemTable) == 0 and self.class ~= nil) then
		-- we've got nothing to choose from here. change class to fallback (if one exists), try again
		local fallbackTier:mp_weapon_tier = self.tier or MP_WEAPON_TIER.Base;
		local fallbackClass:mp_weapon_class = MPWeaponClassFallbacks[fallbackTier][self.class];

		if (fallbackClass == nil) then
			if (fallbackTier == MP_WEAPON_TIER.Power) then
				fallbackClass = MPWeaponClassFallbacks[MP_WEAPON_TIER.Base][self.class];
			else
				fallbackClass = MPWeaponClassFallbacks[MP_WEAPON_TIER.Power][self.class];
			end
		end

		if (fallbackClass ~= nil) then
			self.class = fallbackClass;
			self:GenerateAvailableWeaponsTable(allWeaponsTable);
		end
	end

	-- If identifier is not nil, that means we've saved previous round's identifier because we're on 'Game' frequency or set explicitly above
	if (self.itemIdentifier == nil or self.itemTag == nil) then
		self:SetSpawningItem();
	end

	self:SetVariant();
end

function MPWeaponPlacement:AssignItemFromDefinition(itemDef:MPWeaponTableEntry):void	-- override
	self:AssignItemFromDefinitionBase(itemDef);
	self.itemConfig = itemDef.config;
	self:TryAndAssignLegendaryVariant(itemDef);
	self.tier = itemDef.tier;
	self.class = itemDef.class;
	self.hologramIconPosition = itemDef.hologramIconPos or 0;
end

function MPWeaponPlacement:GetFullDefinitionTable():table		-- override
	return GetMPWeaponPlacementTable();
end

function MPWeaponPlacement:GetFallbackIdentifier():mp_weapon_identifier	-- override
	return MP_WEAPON_IDENTIFIER.AssaultRifle;
end

function MPWeaponPlacement:DisplayHologramIcon(restricted:boolean):void
	self:DebugPrint("MPWeaponPlacement:DisplayHologramIcon()");
	debug_assert(not self.previewAsHologram, "Hologram icons should only be shown when a 3D hologram isn't");

	if (self.class == nil) then
		return;
	end

	for curClass, fnName in hpairs(self.CONST.hologramIconSelectionName) do
		local iconValue:number = 0;
		if (curClass == self.class) then
			iconValue = self.hologramIconPosition;
		end

		Object_SetFunctionValue(self.containerObject, fnName, iconValue, 0);
	end

	local tierColor:number = self.CONST.restrictedHologramIconColor;
	
	if (not restricted) then
		if (self.tier == MP_WEAPON_TIER.Power) then
			tierColor = self.CONST.powerTierHologramIconColor;
		else
			tierColor = self.CONST.baseTierHologramIconColor;
		end
	end

	Object_SetFunctionValue(self.containerObject, self.CONST.hologramIconColorName, tierColor, 0);
end

function MPWeaponPlacement:HideHologramIcon():void
	self:DebugPrint("MPWeaponPlacement:HideHologramIcon()");

	for k, v in hpairs(self.CONST.hologramIconSelectionName) do
		Object_SetFunctionValue(self.containerObject, self.CONST.hologramIconSelectionName[k], 0, 0);
	end

	Object_SetFunctionValue(self.containerObject, self.CONST.hologramIconColorName, 0, 0);
end

-- OVERRIDES

function MPWeaponPlacement:HandleOverrideReceived(itemManager:table):void	-- override
	if (not self.canUseItemManager or self.itemManager ~= itemManager) then
		return;
	end

	-- have we overridden the class? if so, swap it with tier first, then channel
	if (self.tier ~= nil and self.itemManager.CONFIG.perTierOverrides[self.tier].class ~= MP_WEAPON_CLASS.None) then
		self.class = self.itemManager.CONFIG.perTierOverrides[self.tier].class;
	end

	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None and self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class ~= MP_WEAPON_CLASS.None) then
		self.class = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].class;
	end

	-- have we overridden the tier? if so, swap it with class first, then channel
	if (self.class ~= nil and self.itemManager.CONFIG.perClassOverrides[self.class].tier ~= MP_WEAPON_TIER.None) then
		self.tier = self.itemManager.CONFIG.perClassOverrides[self.class].tier;
	end

	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None and self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].tier ~= MP_WEAPON_TIER.None) then
		self.tier = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].tier;
	end

	-- ok, now that that's been sorted, let's override by class, tier, channel and then global
	if (self.class ~= nil and self.class ~= MP_WEAPON_CLASS.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perClassOverrides[self.class]);
	end

	if (self.tier ~= nil and self.tier ~= MP_WEAPON_TIER.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perTierOverrides[self.tier]);
	end

	if (self.selectiveChannelId ~= MP_ITEM_CHANNEL.None) then
		self:ProcessOverrideDataSet(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId]);
	end

	self:ProcessOverrideDataSet(self.itemManager.CONFIG.globalOverrides);

	self:EnsureLegitimateFactionFilters();
end

function MPWeaponPlacement:ProcessOverrideDataSet(overrideData:MPWeaponOverrideData):void
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

	if (overrideData.initialAmmoLevel > 0) then
		self.CONFIG.initialAmmoModifier = overrideData.initialAmmoLevel;
	end

	if (overrideData.forceRandomItem) then
		self.explicitIdentifier = nil;
	elseif (overrideData.weapon ~= MP_WEAPON_IDENTIFIER.None) then
		self:TryOverridingItemFromIdentifier(overrideData.weapon);
	end
end

function MPWeaponPlacement:TryOverridingItemFromIdentifier(overrideIdentifier:mp_weapon_identifier):boolean
	if (self.canUseItemManager and overrideIdentifier ~= nil) then
		local weaponsTable:table = self:GetFullDefinitionTable();

		if (weaponsTable[overrideIdentifier].tier == MP_WEAPON_TIER.Power and self.tier == MP_WEAPON_TIER.Base) then
			-- don't allow power tier weapons to be overridden by class if power is not allowed here or you might end up with a gravity hammer sticking out of a weapon rack
			return false;
		end

		self:DebugPrint("MPWeaponPlacement:TryOverridingItem()", self.class, overrideIdentifier);
		self:AssignItemFromIdentifier(overrideIdentifier, weaponsTable);
		return true;
	end

	return false;
end

function MPWeaponPlacement:TryOverridingItem():boolean	-- override
	local overridden:boolean = false;
	local overrideData:MPWeaponOverrideData = nil;

	if (self.canUseItemManager) then
		if (self.class ~= nil) then
			overrideData = self.itemManager.CONFIG.perClassOverrides[self.class];
			if (not overrideData.forceRandomItem and overrideData.weapon ~= MP_WEAPON_IDENTIFIER.None) then
				overridden = self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perClassOverrides[self.class].weapon);
			end
		end
		
		if (self.tier ~= nil) then
			overrideData = self.itemManager.CONFIG.perTierOverrides[self.tier];
			if (not overrideData.forceRandomItem and overrideData.weapon ~= MP_WEAPON_IDENTIFIER.None) then
				overridden = self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perTierOverrides[self.tier].weapon);
			end
		end
		
		if (self.selectiveChannelId ~= nil) then
			overrideData = self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId];
			if (not overrideData.forceRandomItem and overrideData.weapon ~= MP_WEAPON_IDENTIFIER.None) then
				overridden = self:TryOverridingItemFromIdentifier(self.itemManager.CONFIG.perChannelOverrides[self.selectiveChannelId].weapon);
			end
		end
	end

	return overridden;
end

function MPWeaponPlacement:ForceDormantState():void			-- override
	self:ForceDormantStateBase();

	if (not self.previewAsHologram) then
		self:HideHologramIcon();
	end
end

function MPWeaponPlacement:GoToRestrictedState():void		-- override
	self:DebugPrint("MPWeaponPlacement:GoToRestrictedState()");
	self:EnableRestrictedEffect(true);
	self:GoToRestrictedStateBase();

	if (not self.previewAsHologram) then
		self:DisplayHologramIcon(true);
	end
end

function MPWeaponPlacement:StartIncomingState():void		-- override
	self:DebugPrint("MPWeaponPlacement:StartIncomingState()");

	if (not self.previewAsHologram) then
		self:DisplayHologramIcon(false);
	end

	self:StartIncomingStateBase();
end

function MPWeaponPlacement:StockContainer():void	-- override
	self:PlaySoundReady(self.containerObject);

	if (self.CONFIG.isMessagingVisible or self.CONFIG.pingMessaging) then
		self:MessagingReady();
		if (Variant_GetStringIdProperty("IntelMapType") ~= Engine_ResolveStringId("bts")) then
			RunClientScript("IntelMapSetWeaponPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointReadyColor, self.itemStringId);
		end
	end

	self:StockContainerBase();
	self:HideHologramIcon();

	if (self.spawnedItemObject ~= nil) then
		self:SetInitialAmmoLevel();
		self:AddSpawnedItemToDeployedList();
		self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.spawnedItemObject);
		self:RegisterEventOnSelf(g_eventTypes.weaponPickupEvent, self.HandleWeaponPickupEvent, self.spawnedItemObject);

		-- when this fires, it's because the weapon we just spawned will have been picked up and then had ammo added to it either here or elsewhere
		self:RegisterEventOnSelf(g_eventTypes.weaponPickupForAmmoRefillEvent, self.HandleWeaponAmmoPickupEvent, self.spawnedItemObject);
		self:RegisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleWeaponGrappledEvent, self.spawnedItemObject);
	end
end

function MPWeaponPlacement:SetInitialAmmoLevel():void
	if (self.CONFIG.initialAmmoModifier == 1) then
		return;
	end

	if (Weapon_IsAgeBased(self.spawnedItemObject)) then
		weapon_set_current_amount(self.spawnedItemObject, math.min(self.CONFIG.initialAmmoModifier, 1))		-- energy based weapons can never exceed 100%
		self:DebugPrint("Setting initial energy level to", self.CONFIG.initialAmmoModifier, "for", self.itemIdentifier);
	else
		local magazineMaxRounds:number = Weapon_GetMagazineMaximumRounds(self.spawnedItemObject, 0);
		local defaultInitialRounds:number = weapon_get_rounds_total(self.spawnedItemObject, 0);
		local maxRounds:number = Weapon_GetMaxRounds(self.spawnedItemObject, 0);
		local desiredInitialAmmo:number = math.Round(defaultInitialRounds * self.CONFIG.initialAmmoModifier, magazineMaxRounds);
		desiredInitialAmmo = math.min(desiredInitialAmmo, maxRounds);

		if (self.spawnedItemObject ~= nil) then
			self:DebugPrint("Setting initial ammo level to", desiredInitialAmmo, "for", self.itemIdentifier);
			Weapon_SetInitialRounds(self.spawnedItemObject, desiredInitialAmmo);
		else
			print("Error: attempting to set initial ammo level on nil weapon");
		end
	end
end

function MPWeaponPlacement:OnObjectDeleted(eventArgs:ObjectDeletedStruct):void
	self:DebugPrint("MPWeaponPlacement:OnObjectDeleted(): ", eventArgs.deletedObject);

	if (table.contains(self.exhaustedWeapons, eventArgs.deletedObject)) then
		self:DebugPrint("OnObjectDeleted - Removing from exhausted list: ", eventArgs.deletedObject);
		table.removeValue(self.exhaustedWeapons, eventArgs.deletedObject);
	end

	self:CreateThread(self.OnCompleteObjectDeletion, eventArgs.deletedObject);
end

function MPWeaponPlacement:OnCompleteObjectDeletion(deletedObject:object):void
	-- Let's sleep here in case we were about to get an ammo refill callback in which
	-- case that should handle the removal from deployed list and lifecycle logic first
	SleepOneFrame();

	self:RemoveItemFromDeployedList(deletedObject);
	self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, deletedObject);
end

function MPWeaponPlacement:OnWeaponOutOfAmmo(eventArgs:WeaponOutOfAmmoEventStruct):void
	self:DebugPrint("Weapon out of ammo: ", eventArgs.weapon);

	if (not table.contains(self.exhaustedWeapons, eventArgs.weapon)) then
		self:DebugPrint("Adding to exhausted list");
		table.insert(self.exhaustedWeapons, eventArgs.weapon);	-- keep reference to this as we'll need to add it back later if we refill same weapon
	end

	self:RemoveItemFromDeployedList(eventArgs.weapon);
end

function MPWeaponPlacement:EmptyWeaponsAreMarkedAsUndeployed():boolean
	if (self.canUseItemManager) then
		return self.itemManager.CONFIG.markEmptyWeaponOverride;
	else
		return true;
	end
end

function MPWeaponPlacement:AddSpawnedItemToDeployedList():void
	if (self.canUseItemManager and self:AddItemToDeployedList(self.spawnedItemObject)) then
		self.itemManager:OnItemSpawned(self.itemIdentifier);
	end		
end

function MPWeaponPlacement:AddItemToDeployedList(item:object):boolean
	if (self:EmptyWeaponsAreMarkedAsUndeployed() and self.deployedItems[item] == nil) then
		self:RegisterEventOnSelf(g_eventTypes.weaponOutOfAmmoEvent, self.OnWeaponOutOfAmmo, item);
	end

	if (self.deployedItems[item] == nil) then
		self:DebugPrint("Adding deployed item: ", item);
		self.deployedItems[item] = self.itemIdentifier;
		return true;
	end

	return false;
end

function MPWeaponPlacement:RemoveItemFromDeployedList(item:object):void
	self:DebugPrint("MPWeaponPlacement:RemoveItemFromDeployedList()");

	if (self.deployedItems[item] ~= nil) then
		if (self:EmptyWeaponsAreMarkedAsUndeployed()) then
			self:UnregisterEventOnSelf(g_eventTypes.weaponOutOfAmmoEvent, self.OnWeaponOutOfAmmo, item);
		end

		if (self.canUseItemManager) then
			self.itemManager:OnItemCleanedUp(self.deployedItems[item]);
		end

		self.deployedItems[item] = nil;
		self:DebugPrint("Removing deployed item: ", item, " Remaining: ", table.countKeys(self.deployedItems));

		if (self:GetSpawnLogic() == MP_SPAWN_LOGIC.DynamicOnExpire) then
			-- make sure no weapons left deployed as ammo refills would kick off reset on deletion otherwise
			if (table.countKeys(self.deployedItems) == 0) then
				self:DebugPrint("Restart lifecyle because no deployed items and DynamicOnExpire");
				self.lifecycleThread = self:CreateThread(self.RestartLifecycle);
			end
		elseif (self.deploymentState == DeploymentState.Restricted and self:CanDeploy()) then
			self.delayedResetThread = self:CreateThread(self.DelayedResetRoutine);
		end
	end
end

function MPWeaponPlacement:HandleWeaponAmmoPickupEvent(eventArgs:WeaponPickupForAmmoRefillEventStruct):void
	self:DebugPrint("Weapon looted for ammo: ", eventArgs.weapon, " Full pickup? ", eventArgs.weaponFullyPickedUp);

	debug_assert(self:AreObjectsEqual(eventArgs.weapon, self.spawnedItemObject));

	local heldWeapon:object = eventArgs.inventoryWeaponBeingRefilled;

	if (table.contains(self.exhaustedWeapons, heldWeapon)) then
		self:DebugPrint("Weapon no longer exhausted: ", heldWeapon);
		self:AddItemToDeployedList(heldWeapon);		-- put this back into the list as now it's usable again
		table.removeValue(self.exhaustedWeapons, heldWeapon);
	end

	if (not eventArgs.weaponFullyPickedUp) then
		Object_Delete(self.spawnedItemObject);	-- We don't want "used" weapons on racks, so clean them up even if they aren't fully depleted
	end

	self:ProcessInitialWeaponPickup(eventArgs.player);
end

function MPWeaponPlacement:HandleWeaponPickupEvent(eventArgs:WeaponPickupEventStruct):void
	self:DebugPrint("Weapon picked up: ", eventArgs.weapon);
	debug_assert(self:AreObjectsEqual(eventArgs.weapon, self.spawnedItemObject));
	self:TriggerEvent(self.EVENTS.onItemPickedUp, eventArgs);
	self:ProcessInitialWeaponPickup(eventArgs.player);
end

function MPWeaponPlacement:HandleWeaponGrappledEvent(eventArgs:GrappleReelInItemInitiatedEventStruct):void
	self:DebugPrint("Weapon grappled out of container: ", eventArgs.item);
	debug_assert(self:AreObjectsEqual(eventArgs.item, self.spawnedItemObject));
	self:ProcessInitialWeaponPickup(eventArgs.playerUnit);
end

function MPWeaponPlacement:ProcessBasicWeaponPickup():void
	self:GoToDormantState();
	self:UnregisterEventOnSelf(g_eventTypes.weaponPickupEvent, self.HandleWeaponPickupEvent, self.spawnedItemObject);
	self:UnregisterEventOnSelf(g_eventTypes.weaponPickupForAmmoRefillEvent, self.HandleWeaponAmmoPickupEvent, self.spawnedItemObject);
	self:UnregisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleWeaponGrappledEvent, self.spawnedItemObject);

	self.resetThread = self:CreateThread(self.LifecycleResetRoutine);
	self.spawnedItemObject = nil;
end

function MPWeaponPlacement:ProcessInitialWeaponPickup(lootingPlayer:player):void
	self:ProcessBasicWeaponPickup();

	self:PlaySoundPickedUp(self.containerObject);

	if (self.CONFIG.isMessagingVisible) then
		self:MessagingPickedUp(lootingPlayer);
		RunClientScript("IntelMapSetWeaponPlacementIcon", self.containerObject, "intel_map_icon_pad", self.CONFIG.intelNavpointIncomingColor, self.itemStringId);
	end
end

function MPWeaponPlacement:RenormalizeOverrideWeights():void	-- override
	self.categoryWeightOverrides = self.itemManager:RenormalizeCategoryWeightings(self.categoryWeightOverrides);
end

function MPWeaponPlacement:ChooseRandomizedCategory():void	-- override
	self.tier = self.itemManager:ChooseRandomWeightedCategory(self, self.categoryWeightOverrides);
end

function MPWeaponPlacement:GenerateAvailableWeaponsTable(weaponsTable:table):void
	self.availableItemTable = {}; 
	local hasExplicitIdentifier = self:ItemIsExplicitlySpecified();

	for id, weapon in hpairs (weaponsTable) do
		local tierCheck:boolean = self.tier == nil or weapon.tier == self.tier;
		local factionCheck:boolean = self.factionFilters[weapon.faction] or false;

		local classCheck:boolean = false;

		if (self.class == MP_WEAPON_CLASS.AntiVehicle) then
			classCheck = weapon.antivehicle;
		else
			classCheck = (self.class == nil) or (self.class == weapon.class);
		end

		local loadoutCheck:boolean = true;
		
		if (self.canUseItemManager and (not hasExplicitIdentifier or self.explicitIdentifier ~= weapon.identifier)) then	-- if this weapon wasn't explicitly specified, we can prohibit if necessary
			loadoutCheck = not self.itemManager:IsWeaponProhibited(weapon.tag);
		end

		if (tierCheck and classCheck and factionCheck and loadoutCheck and not self:IsWeaponFlightBanned(weapon.identifier)) then
			self.availableItemTable[id] = weapon;
		end
	end
end

function MPWeaponPlacement:IsWeaponFlightBanned(weaponID:mp_weapon_identifier):boolean
	return MultiplayerItems_LimitForFlighting and table.contains(MPFlightingProhibitedWeapons, weaponID);
end

function MPWeaponPlacement:RebuildAvailableItemTable():void						-- override
	local allWeaponsTable:table = self:GetFullDefinitionTable();
	self:GenerateAvailableWeaponsTable(allWeaponsTable);
	
	-- did we not get anything due to flight banning or poor filtering combinations? then let's pick a fallback class and try again
	if (table.countKeys(self.availableItemTable) == 0 and self.class ~= nil) then
		local fallbackTier:mp_weapon_tier = self.tier or MP_WEAPON_TIER.Base;
		local fallbackClass:mp_weapon_class = MPWeaponClassFallbacks[fallbackTier][self.class];

		if (fallbackClass ~= nil) then
			self.class = fallbackClass;
			self:GenerateAvailableWeaponsTable(allWeaponsTable);
			-- if we've still got nothing, then hey, at least we tried and the global fallback will kick in later
		end
	end
end

function MPWeaponPlacement:EnsureLegitimateFactionFilters():void				-- override
	-- all weapons are either UNSC, Forerunner or Banished... let's make sure they're not all off
	if (not self.factionFilters[MP_ITEM_FACTION.UNSC] and
			not self.factionFilters[MP_ITEM_FACTION.Forerunner] and
			not self.factionFilters[MP_ITEM_FACTION.Banished]) then
		self.factionFilters[MP_ITEM_FACTION.UNSC] = true;
	end
end

function MPWeaponPlacement:WeaponStringToIdentifier(weapon:string):mp_weapon_identifier
	if (weapon == "CQS48 Bulldog") then
		return MP_WEAPON_IDENTIFIER.Bulldog;
	elseif (weapon == "Needler") then
		return MP_WEAPON_IDENTIFIER.Needler;
	elseif (weapon == "Disruptor") then
		return MP_WEAPON_IDENTIFIER.Disruptor;
	elseif (weapon == "Plasma Pistol") then
		return MP_WEAPON_IDENTIFIER.PlasmaPistol;
	elseif (weapon == "Mangler") then
		return MP_WEAPON_IDENTIFIER.Mangler;
	elseif (weapon == "Mk50 Sidekick") then
		return MP_WEAPON_IDENTIFIER.SideKick;
	elseif (weapon == "BR75") then
		return MP_WEAPON_IDENTIFIER.BattleRifle;
	elseif (weapon == "Stalker Rifle") then
		return MP_WEAPON_IDENTIFIER.StalkerRifle;
	elseif (weapon == "Shock Rifle") then
		return MP_WEAPON_IDENTIFIER.ShockRifle;
	elseif (weapon == "MA40 AR") then
		return MP_WEAPON_IDENTIFIER.AssaultRifle;
	elseif (weapon == "Pulse Carbine") then
		return MP_WEAPON_IDENTIFIER.PulseCarbine;
	elseif (weapon == "VK78 Commando") then
		return MP_WEAPON_IDENTIFIER.CommandoRifle;
	elseif (weapon == "Heatwave") then
		return MP_WEAPON_IDENTIFIER.Heatwave;
	elseif (weapon == "Hydra") then
		return MP_WEAPON_IDENTIFIER.Hydra;
	elseif (weapon == "Ravager") then
		return MP_WEAPON_IDENTIFIER.Ravager;
	elseif (weapon == "Sentinel Beam") then
		return MP_WEAPON_IDENTIFIER.SentinelBeam;
	elseif (weapon == "Energy Sword") then
		return MP_WEAPON_IDENTIFIER.EnergySword;
	elseif (weapon == "Gravity Hammer") then
		return MP_WEAPON_IDENTIFIER.GravityHammer;
	elseif (weapon == "M41 SPNKr") then
		return MP_WEAPON_IDENTIFIER.RocketLauncher;
	elseif (weapon == "Skewer") then
		return MP_WEAPON_IDENTIFIER.Skewer;
	elseif (weapon == "S7 Sniper") then
		return MP_WEAPON_IDENTIFIER.SniperRifle;
	elseif (weapon == "Cindershot") then
		return MP_WEAPON_IDENTIFIER.Cindershot;
	else
		return nil;
	end
end

function MPWeaponPlacement:CurrentWeaponIdentifierAsString():string
	if (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Bulldog) then
		return "CQS48 Bulldog";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Needler) then
		return "Needler";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Disruptor) then
		return "Disruptor";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.PlasmaPistol) then
		return "Plasma Pistol";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Mangler) then
		return "Mangler";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SideKick) then
		return "Mk50 Sidekick";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.BattleRifle) then
		return "BR75";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.StalkerRifle) then
		return "Stalker Rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.ShockRifle) then
		return "Shock Rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.AssaultRifle) then
		return "MA40 AR";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.PulseCarbine) then
		return "Pulse Carbine";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.CommandoRifle) then
		return "VK78 Commando";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Heatwave) then
		return "Heatwave";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Hydra) then
		return "Hydra";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Ravager) then
		return "Ravager";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SentinelBeam) then
		return "Sentinel Beam";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.EnergySword) then
		return "Energy Sword";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.GravityHammer) then
		return "Gravity Hammer";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.RocketLauncher) then
		return "M41 SPNKr";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Skewer) then
		return "Skewer";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SniperRifle) then
		return "S7 Sniper";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Cindershot) then
		return "Cindershot";
	else
		return nil;
	end
end

function MPWeaponPlacement:CurrentWeaponIdentifierAsWeaponConstantID():string
	if (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Bulldog) then
		return "proto_combat_shotgun";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Needler) then
		return "needler";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Disruptor) then
		return "arc_zapper";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.PlasmaPistol) then
		return "plasma_pistol";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Mangler) then
		return "spike_revolver";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SideKick) then
		return "sidearm_pistol";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.BattleRifle) then
		return "battle_rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.StalkerRifle) then
		return "plasma_blaster";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.ShockRifle) then
		return "volt_action";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.AssaultRifle) then
		return "assault_rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.PulseCarbine) then
		return "wetwork";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.CommandoRifle) then
		return "commando_rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Heatwave) then
		return "hotrod";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Hydra) then
		return "mlrs";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Ravager) then
		return "slag_maker";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SentinelBeam) then
		return "sentinel_beam";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.EnergySword) then
		return "energy_sword";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.GravityHammer) then
		return "gravity_hammer";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.RocketLauncher) then
		return "spnkr_rocket_launcher";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Skewer) then
		return "skewer";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.SniperRifle) then
		return "sniper_rifle";
	elseif (self.itemIdentifier == MP_WEAPON_IDENTIFIER.Cindershot) then
		return "heatwave";
	else
		return nil;
	end
end

function MPWeaponPlacement:OnPlacementHide():void
	if (self.spawnedItemObject ~= nil) then
		self:UnregisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.spawnedItemObject);
		self:UnregisterEventOnSelf(g_eventTypes.weaponPickupEvent, self.HandleWeaponPickupEvent, self.spawnedItemObject);
		self:UnregisterEventOnSelf(g_eventTypes.weaponPickupForAmmoRefillEvent, self.HandleWeaponAmmoPickupEvent, self.spawnedItemObject);
		self:UnregisterEventOnSelf(g_eventTypes.grappleHookReelInItemInitiatedCallback, self.HandleWeaponGrappledEvent, self.spawnedItemObject);
	end

	if (self.doDamageDetach and self:GetAccelerationProxy() ~= nil) then
		self:UnregisterEventOnSelf(g_eventTypes.objectDamageAccelerationEvent, self.OnDamageAccelerationApplied, self:GetAccelerationProxy());
	end

	self.exhaustedWeapons = {};
end

function MPWeaponPlacement:OnPlacementShow():void	-- override
	self:CreateThread(self.InitializeContainer);
end

function MPWeaponPlacement:SetVariant():void	-- override
	if (self.tier == MP_WEAPON_TIER.Power) then
		object_set_variant(self.containerObject, self.CONST.defaultVariantName);
	else
		object_set_variant(self.containerObject, self.CONST.downgradedVariantName);
	end
end

-- NAVPOINTS

function MPWeaponPlacement:GetNavpointPresentationTierName():string		-- override
	if (self.deploymentState == DeploymentState.Incoming) then
		return self.CONST.navpointPresentationNameRecharging;
	end

	if (self.tier == MP_WEAPON_TIER.Power) then
		return self.CONST.navpointPresentationNamePower;
	else
		return self.CONST.navpointPresentationNameGeneral;
	end
end

-- MESSAGING 

function MPWeaponPlacement:MessagingIncoming():void		-- override
	self:MessagingIncomingBase();

	local incomingWeapon:string = self:CurrentWeaponIdentifierAsWeaponConstantID();

	if (self.canUseItemManager and self.tier == MP_WEAPON_TIER.Power) then
		self.itemManager:PlayVO(
			hmake MPItemSpawnerPendingVOData
			{
				responseName	= "__OnWeaponPadIncoming",
				itemName		= incomingWeapon,
				itemType		= MPItemGroupType.Weapon,
				voType			= MPItemVOType.Incoming,
			});
	else
		MPLuaCall("__OnWeaponPadIncoming", incomingWeapon);
	end
end

function MPWeaponPlacement:MessagingReady():void	-- override
	self:MessagingReadyBase();

	if (not self.canDisplayReadyMessage) then
		return;
	end

	local spawnedWeapon:string = self:CurrentWeaponIdentifierAsWeaponConstantID();

	if (self.canUseItemManager and self.tier == MP_WEAPON_TIER.Power) then
		self.itemManager:PlayVO(
			hmake MPItemSpawnerPendingVOData
			{
				responseName	= "__OnWeaponPadReady",
				itemName		= spawnedWeapon,
				itemType		= MPItemGroupType.Weapon,
				voType			= MPItemVOType.Ready,
			});
	else
		MPLuaCall("__OnWeaponPadReady", spawnedWeapon);
	end
end

function MPWeaponPlacement:MessagingPickedUp(lootingPlayer:player):void		-- override
	self:MessagingPickedUpBase(lootingPlayer);
	-- MPLuaCall("__OnWeaponPadPickedUp", lootingPlayer);
end

-- EFFECTS

function MPWeaponPlacement:GetIncomingEffect():tag	-- override
	if (self.tier == MP_WEAPON_TIER.Power) then
		return self.incomingParticleFX;
	else
		return self.altIncomingParticleFX;
	end
end

function MPWeaponPlacement:GetSpawnedEffect():tag	-- override
	if (self.tier == MP_WEAPON_TIER.Power) then
		return self.spawnedParticleFX;
	else
		return self.altSpawnedParticleFX;
	end
end

function MPWeaponPlacement:GetHologramPreviewColor():object_runtime_hologram_color	-- override
	if (self.tier == MP_WEAPON_TIER.Power) then
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Gold;
	else
		return OBJECT_RUNTIME_HOLOGRAM_COLOR.Blue;
	end
end

function MPWeaponPlacement:GetRezInEffect():tag		-- override
	if (self.class == MP_WEAPON_TIER.Power) then
		return MPItemSpawnerRezInEffects.powerItem;
	else
		return MPItemSpawnerRezInEffects.baseItem;
	end
end

-- SOUNDS

function MPWeaponPlacement:GetHologramLoopingSound():tag	-- override
	return MPItemSpawnerAudioAssets.weaponHologramLoop;
end

function MPWeaponPlacement:PlaySoundIncoming(weaponObject:object):void
	if (self.tier == MP_WEAPON_TIER.Power) then
		MPLuaCall("__OnWeaponPadIncomingSound", weaponObject);
	else
		-- Add Weapon Racks sound for "incoming" state 
	end
end

function MPWeaponPlacement:PlaySoundReady(weaponObject:object):void
	if (self.tier == MP_WEAPON_TIER.Power) then
		MPLuaCall("__OnWeaponPadReadySound", weaponObject);
	else
		MPLuaCall("__OnWeaponRackReadySound", weaponObject);
	end	
end

function MPWeaponPlacement:PlaySoundPickedUp(weaponObject:object):void
	if (self.tier == MP_WEAPON_TIER.Power) then
		MPLuaCall("__OnWeaponPadPickedUpSound", weaponObject);
	else
		MPLuaCall("__OnWeaponRackPickedUpSound", weaponObject);
	end	
end

-- EVENTS

function MPWeaponPlacement:AddOnWeaponPickedUp(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onItemPickedUp, callbackFunc, callbackOwner);
end

function MPWeaponPlacement:RemoveOnWeaponPickedUp(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onItemPickedUp, callbackFunc, callbackOwner);
end

function MPWeaponPlacement:AddOnWeaponBlastDetach(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onItemBlastDetach, callbackFunc, callbackOwner);
end

function MPWeaponPlacement:RemoveOnWeaponBlastDetach(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onItemBlastDetach, callbackFunc, callbackOwner);
end

--## CLIENT

function remoteClient.IntelMapSetWeaponPlacementIcon(weaponPadObject:object, weaponIcon:string_id, iconColor:color_rgba, weaponName:string_id):void
	iconColor = iconColor or UI_GetBitmapColorForDisposition(DISPOSITION.Neutral);
	IntelMapSetColoredIcon(weaponIcon, "intel_map_icon_hexagon_bg", weaponName, iconColor, weaponPadObject);
end