-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

-- requires
REQUIRES('scripts\ParcelLibrary\parcel_mp_item_vo_supervisor.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_item_seedsequence.lua');
REQUIRES('scripts\Helpers\StopwatchDaemonStartup.lua');

--[[
--   __     ______   ______     __    __        __    __     ______     __   __     ______     ______     ______     ______    
--  /\ \   /\__  _\ /\  ___\   /\ "-./  \      /\ "-./  \   /\  __ \   /\ "-.\ \   /\  __ \   /\  ___\   /\  ___\   /\  == \   
--  \ \ \  \/_/\ \/ \ \  __\   \ \ \-./\ \     \ \ \-./\ \  \ \  __ \  \ \ \-.  \  \ \  __ \  \ \ \__ \  \ \  __\   \ \  __<   
--   \ \_\    \ \_\  \ \_____\  \ \_\ \ \_\     \ \_\ \ \_\  \ \_\ \_\  \ \_\\"\_\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_\ \_\ 
--    \/_/     \/_/   \/_____/   \/_/  \/_/      \/_/  \/_/   \/_/\/_/   \/_/ \/_/   \/_/\/_/   \/_____/   \/_____/   \/_/ /_/ 
--]]


global MPItemVOSupervisorInstance = nil;

----------------------------------------------
---- Global Item Spawner Overrides ----
----------------------------------------------

function TriggerItemOverrideEvent(manager:table):void
	manager:TriggerEvent(manager.EVENTS.onOverrideReceived, manager);
end

----------------------------------------------
---- MPItemManager Parcel ----
----------------------------------------------

---- This parcel should be used as an abstract base class for other managers, i.e. MPWeaponManager and MPEquipmentManager

global MPItemManager:table = Parcel.MakeParcel
{
	instanceName = "ItemManager",
	complete = false,
	spawnerRegistrationStarted = false,

	-- weighted item spawning
	existingItemCountTable = {},
	weightedItemTable = {},
	totalWeight = 0,

	-- weighting table to use if escalation is specified
	escalatingCategoryWeights = {},
	escalatingCategoryWeightMinValues = {},

	-- per class placements
	perClassPlacements = {},

	-- channel management
	perChannelItemSelections = {},
	symmetricalChannelPlacements = {},			-- specific to full channel ID, comprised of name, class and exclusions
	selectiveChannelPlacements = {},			-- specific only to kit specified channel name
	managedDistributionLists = {},				-- shuffled order of placements to distribute per selective channel is specified by variant
	managedDistributionThread = nil,

	dropPodObjectLookupTable = {},				-- used to track weapon or equipment drop pod object / placement

	logEntries = nil,
	initialLogTime = nil,
	proximityResults = {},

	voSupervisor = nil,

	CONFIG = 
	{
		enableDebugPrint = false,	-- A debug variable used to enable/disable debug prints in the parcel.
		enableDebugLogging = false,	-- A debug variable used to enable/disable storage of debug print messages

		-- modify these to change the sensitivity of the algorithm that keeps variety within class
		weightIncrementPerDeployedItem = 99.99,
		minimumItemWeight = 0.01,

		-- hold overrides from game variant
		perClassOverrides = {},
		perChannelOverrides = {},
		globalOverrides = nil,

		-- used to limit a specific selective channel to a maximium amount of spawners
		maxSelectiveChannelCounts = {},

		useEscalatingCategoryWeights = false,
		escalatingCategoryWeightIncrement = 8,
	},

	CONST = 
	{
		noManagerOverride = 255,

		unusedClass = -1,
		fullItemWeighting = 100,	-- starting point for determining item to choose based on what has already spawned in world
		defaultManagedDistributionInterval = 30,

		maxLogEntryCount = 10,
	},

	EVENTS =
	{
		onOverrideReceived = "OnOverrideReceived",
		onSlideLockerGateOpen = "OnSlideLockerGateOpen",
		onSlideLockerGateClose = "OnSlideLockerGateClose",
	},
};

function MPItemManager:New():table
	local newItemManager = self:CreateParcelInstance();
	return newItemManager;
end

function MPItemManager:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function MPItemManager:InitializeImmediate():void
	self:InitializeForRound();
end

function MPItemManager:Initialize():void
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundPreStartEvent, self.HandleRoundPreStart);
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundEndEvent, self.HandleRoundEnd);

	if (MPItemVOSupervisorInstance == nil) then
		-- this will act as a singleton as we only want one for all types of items
		MPItemVOSupervisorInstance = MPItemVOSupervisor:New();
		MPItemVOSupervisorInstance.instanceName = "MPItemVOSupervisorInstance";
		ParcelAddAndStart(MPItemVOSupervisorInstance, MPItemVOSupervisorInstance.instanceName);
	end

	self.voSupervisor = MPItemVOSupervisorInstance;
end

function MPItemManager:HandleRoundPreStart(eventArgs:RoundStartEventStruct):void
	self:InitializeForRound();
end

function MPItemManager:HandleRoundEnd():void
	if (self.managedDistributionThread ~= nil) then
		self:DebugPrint(self.instanceName, ": Killing managed distribution thread on round end");
		self:KillThread(self.managedDistributionThread);
		self.managedDistributionThread = nil;
	end
end

function MPItemManager:InitializeForRound():void
	self.perChannelItemSelections = {};
	self.symmetricalChannelPlacements = {};
	self.selectiveChannelPlacements = {};
	self.perClassPlacements = {};
	self.dropPodObjectLookupTable = {};

	self:InitializeEscalatingCategoryWeights();
	self:ValidateCategoryWeightingTable(false);
	self:ValidateCategoryWeightingTable(true);
	self:CreateThread(self.ApplyVariantOverridesRoutine);
end

function MPItemManager:InitializeEscalatingCategoryWeights():void		-- virtual
end

function MPItemManager:ApplyVariantOverridesRoutine():void		-- virtual
end

function MPItemManager:Run()
end

function MPItemManager:SleepUntilValid():void
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function MPItemManager:IsComplete():boolean
	return self.complete;
end

function MPItemManager:shouldEnd():boolean
	return self:IsComplete();
end

function MPItemManager:EndShutdown():void
end

function MPItemManager:AddOnOverrideReceived(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onOverrideReceived, callbackFunc, callbackOwner);
end

function MPItemManager:RemoveOnOverrideReceived(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onOverrideReceived, callbackFunc, callbackOwner);
end

function MPItemManager:EnableEscalationCategoryWeighting(enable:boolean):void
	self.CONFIG.useEscalatingCategoryWeights = enable;
end

function MPItemManager:SetEscalatingCategoryWeightIncrement(increment:number):void
	self.CONFIG.escalatingCategoryWeightIncrement = increment;
end

function MPItemManager:GetType():number		-- abstract
	return 0;
end

--
--	RANDOM WEIGHTED CLASS SELECTION
--

function MPItemManager:ValidateCategoryWeightingTable(useEscalation:boolean):boolean
	local weights:table = self:GetWeightingTable(useEscalation);

	if (weights == nil or table.countKeys(weights) == 0) then
		return true;
	end

	local totalWeight:number = 0;

	for _, weight in hpairs (weights) do
		totalWeight = totalWeight + weight;		
	end

	debug_assert(totalWeight == 100, "MPItemManager:ValidateCategoryWeightingTable - global weights must total 100 for " .. self.instanceName);
	return totalWeight == 100;
end

function MPItemManager:RenormalizeCategoryWeightings(weightingTable:table):table
	-- Note: weights are between 0-100, so "normalized" is a bit of a misnomer here
	if (weightingTable == nil) then
		return weightingTable;
	end
	
	local normalizedWeights:table = table.simpleCopy(weightingTable);	
	local totalWeight:number = 0;
	
	for _, weight in hpairs(normalizedWeights) do
		totalWeight = totalWeight + weight;		
	end
	
	if (totalWeight ~= 0 and totalWeight ~= 100) then
		for category, weight in hpairs (normalizedWeights) do
			normalizedWeights[category] = weight * (100 / totalWeight);		
		end
	end

	return normalizedWeights;
end

function MPItemManager:ChooseRandomWeightedCategory(itemPlacement:table, weightingTable:table):ui64
	if (weightingTable == nil) then
		weightingTable = self:GetWeightingTable(self.CONFIG.useEscalatingCategoryWeights);
	end

	debug_assert(weightingTable ~= nil, "Error: Cannot select random weighted class with a nil weighting table");

	local normalizedWeights:table = self:RenormalizeCategoryWeightings(weightingTable);
	local selectedWeight = itemPlacement:GetRandomRange(1, 100);
	local weightSum = 0;

	for category, weight in hpairs(normalizedWeights) do
		weightSum = weightSum + weight;
		if weightSum >= selectedWeight then
			self:DebugPrint("MPItemManager:ChooseRandomWeightedCategory() - selected", category);
			return category;
		end
	end

	return nil;
end

function MPItemManager:GetWeightingTable(useEscalation:boolean):table	-- virtual
	debug_assert(false, "Attempted to call pure virtual function GetWeightingTable(). This function must be overridden!");
	return nil;
end

function MPItemManager:EscalateCategoryWeights(categoryWeights:table):void	-- virtual
end

function MPItemManager:CanCategoryWeightDeescalate(categoryWeights:table, entry):boolean
	return categoryWeights[entry] > self.escalatingCategoryWeightMinValues[entry];
end

function MPItemManager:DecrementCategoryWeight(categoryWeights:table, entry):void
	categoryWeights[entry] = math.max(categoryWeights[entry] - self.CONFIG.escalatingCategoryWeightIncrement, self.escalatingCategoryWeightMinValues[entry]);
end

function MPItemManager:IncrementCategoryWeight(categoryWeights:table, entry, redistributeCount:number):void
	debug_assert(redistributeCount > 0);
	categoryWeights[entry] = math.min(categoryWeights[entry] + (self.CONFIG.escalatingCategoryWeightIncrement / redistributeCount), 100);
end

--
--	RANDOM IN-CLASS SPAWNING
--

function MPItemManager:OnItemSpawned(item:ui64):void
	debug_assert(item ~= nil);
	self.existingItemCountTable[item] = (self.existingItemCountTable[item] or 0) + 1;
end

function MPItemManager:OnItemCleanedUp(item:ui64):void
	if (self.existingItemCountTable[item] ~= nil) then
		self.existingItemCountTable[item] = math.max(0, self.existingItemCountTable[item] - 1);
	end
end

function MPItemManager:ClearExistingItemCounts():void
	self.existingItemCountTable = {};
end

function MPItemManager:ChooseItemFromAvailableSet(itemPlacement:table, availableItems:table):ui64
	self:ClearWeightedTable();

	for id, item in hpairs (availableItems) do
		local weight:number = self.CONST.fullItemWeighting;

		if (self.existingItemCountTable[id] ~= nil) then
			weight = math.max(self.CONFIG.minimumItemWeight, weight - (self.existingItemCountTable[id] * self.CONFIG.weightIncrementPerDeployedItem));
		end

		self:AddToWeightedTable(id, weight);
	end

	return self:SelectWeightedItem(itemPlacement);
end

function MPItemManager:ClearWeightedTable():void
	self.weightedItemTable = {};
	self.totalWeight = 0;
end

function MPItemManager:AddToWeightedTable(identifier:ui64, weight:number):void
	-- subtract weight if identifier already present for some reason
	local oldWeight = self.weightedItemTable[identifier];
	if (oldWeight ~= nil) then
		self.totalWeight = self.totalWeight - oldWeight;
	end

	-- add a new entry and adjust total
	weight = math.max(weight or 1, 1);				-- weights must be >= 1
	self.weightedItemTable[identifier] = weight;
	self.totalWeight = self.totalWeight + weight;
end

function MPItemManager:SelectWeightedItem(itemPlacement:table):ui64
	-- Choose a random weight and find the identifier that corresponds to the weight range it falls into
	if (table.countKeys(self.weightedItemTable) == 1) then
		for identifier, weight in hpairs(self.weightedItemTable) do
			return identifier;
		end
	elseif (self.totalWeight > 1) then
		local selectedWeight = itemPlacement:GetRandomRange(1, self.totalWeight);
		local weightSum = 0;
		for identifier, weight in hpairs(self.weightedItemTable) do
			weightSum = weightSum + weight;
			if (weightSum >= selectedWeight) then
				return identifier;
			end
		end
	end

	assert(next(self.weightedItemTable) == nil, "Weighted item table failed to select item. Are the assigned weights and total weight valid?");
	return nil;
end

--
--	PER CLASS CHILD MANAGEMENT
--

function MPItemManager:RegisterPlacementByClass(class:ui64, thePlacement:table):void
	local placementClass = class or self.CONST.unusedClass;

	if (self.perClassPlacements[placementClass] == nil) then
		self.perClassPlacements[placementClass] = {};
	end

	table.insert(self.perClassPlacements[placementClass], thePlacement);
end

function MPItemManager:GetAllPlacementsOfClass(class:ui64):table
	return self.perClassPlacements[class];
end

function MPItemManager:GetAllPlacements():table
	local allPlacements:table = {};

	for class, curClassPlacements in hpairs(self.perClassPlacements) do
		for i, curPlacement in ipairs(curClassPlacements) do
			table.insert(allPlacements, curPlacement)
		end
	end

	return allPlacements;
end

function MPItemManager:FindPlacementByName(name:string):table
	for class, curClassPlacements in hpairs(self.perClassPlacements) do
		for i, curPlacement in ipairs(curClassPlacements) do
			if (curPlacement.instanceName == name) then
				return curPlacement;
			end
		end
	end

	return nil;
end

--
--	SELECTIVE CHANNEL MANAGEMENT
--

function MPItemManager:GetAllPlacementsOnSelectiveChannel(selectiveChannel:mp_item_channel):table
	if (self.selectiveChannelPlacements[selectiveChannel] ~= nil) then
		return self.selectiveChannelPlacements[selectiveChannel];
	end

	return nil;
end

function MPItemManager:RegisterPlacementSelectiveChannel(selectiveChannel:mp_item_channel, thePlacement:table):void
	if (self.selectiveChannelPlacements[selectiveChannel] == nil) then
		self.selectiveChannelPlacements[selectiveChannel] = {};
	end

	table.insert(self.selectiveChannelPlacements[selectiveChannel], thePlacement);

	if (self:ChannelUsesManagedDistribution(selectiveChannel)) then
		-- since this spawner will use managed distribution, don't allow it to use it's own spawn logic
		thePlacement.CONFIG.spawnLogic = MP_SPAWN_LOGIC.ExternalTrigger;

		if (self.managedDistributionLists[selectiveChannel] == nil) then
			self.managedDistributionLists[selectiveChannel] = {};
		end
	end

	if (not self.spawnerRegistrationStarted) then
		self.spawnerRegistrationStarted = true;
		self:CreateThread(self.OnSpawnerRegistrationComplete);
	end
end

function MPItemManager:OnSpawnerRegistrationComplete():void
	self:DebugPrint("MPItemManager:OnSpawnerRegistrationComplete()");

	Sleep(1);
	self:SetSelectiveChannelVisibility();

	-- for any channel that requires managed distribution, add all spawners that didn't get hidden
	-- to a new table. this table will get shuffled and the manager will go one by one and spawn
	-- each item on a fixed interval
	for channel, list in hpairs(self.managedDistributionLists) do
		if (self.managedDistributionLists[channel] ~= nil) then
			for i, spawner in ipairs(self.selectiveChannelPlacements[channel]) do
				if (not spawner.isHidden and spawner:IsDormant()) then
					table.insert(self.managedDistributionLists[channel], spawner);
				end
			end

			table.shuffle(self.managedDistributionLists[channel]);
			self.managedDistributionThread = self:CreateThread(self.ManageChannelDistribution, channel);
		end
	end
end

function MPItemManager:ChannelUsesManagedDistribution(channel:mp_item_channel):boolean	-- virtual
	return false;
end

function MPItemManager:GetChannelManagedDistributionInterval(channel:mp_item_channel):number	-- virtual
	return self.CONST.defaultManagedDistributionInterval;
end

function MPItemManager:GetChannelManagedDistributionVariance(channel:mp_item_channel):number	-- virtual
	return 0;
end

function MPItemManager:ManageChannelDistribution(channel:mp_item_channel):void
	local interval:number = self:GetChannelManagedDistributionInterval(channel);
	local variance:number = self:GetChannelManagedDistributionVariance(channel);

	repeat
		local adjustedInterval:number = interval;

		if (variance > 0) then
			local rnd:number = -variance + (random_ratio() * variance * 2);
			adjustedInterval = math.max(0, adjustedInterval * (1 + rnd));
		end

		SleepSeconds(adjustedInterval);

		local channelChannelList:table = self.managedDistributionLists[channel];
		local channelSpawnerCount:number = #channelChannelList;

		if (channelSpawnerCount > 0) then
			self:DebugPrint("MPItemManager: Managed Distribution Spawn for channel", channel);
			local spawner:table = channelChannelList[channelSpawnerCount];
			spawner:TriggerItemSpawn();
			table.remove(channelChannelList, channelSpawnerCount);
		end

		-- we've run out of spawners to manage. if any are dormant, meaning they've spawned and
		-- been picked up / driven away, we can add it back into the available list again
		if (#channelChannelList == 0) then
			for _, spawner in ipairs(self.selectiveChannelPlacements[channel]) do
				if (not spawner.isHidden and spawner:IsDormant()) then
					table.insert(channelChannelList, spawner);
				end
			end
		end
	until false;
end

function MPItemManager:LimitSelectiveChannelSpawners(selectiveChannel:mp_item_channel, amount:number):void
	debug_assert(amount >= 0, "The amount of spawners to show cannot be a negative number");

	if (self.selectiveChannelPlacements[selectiveChannel] == nil) then
		return;
	end

	self.CONFIG.maxSelectiveChannelCounts[selectiveChannel] = math.min(amount, #self.selectiveChannelPlacements[selectiveChannel]);
	self:SetSelectiveChannelVisibility();
end

function MPItemManager:LimitSelectiveChannelSpawnersByPercentage(selectiveChannel:mp_item_channel, pct:number):void
	if (self.selectiveChannelPlacements[selectiveChannel] == nil) then
		return;
	end

	debug_assert(pct >= 0 and pct <= 1, "The percentage of spawners to show must be between 0 and 1");
	local amount = math.ceil(#self.selectiveChannelPlacements[selectiveChannel] * pct);
	self.CONFIG.maxSelectiveChannelCounts[selectiveChannel] = amount;
	self:SetSelectiveChannelVisibility();
end

function MPItemManager:SetSelectiveChannelVisibility():void
	for channel, maxCount in hpairs(self.CONFIG.maxSelectiveChannelCounts) do
		if (self.selectiveChannelPlacements[channel] ~= nil and maxCount > 0) then
			local subsetIndices:table = self:SelectRandomSubset(#self.selectiveChannelPlacements[channel], maxCount);

			for idx, placement in ipairs(self.selectiveChannelPlacements[channel]) do
				if (table.contains(subsetIndices, idx)) then
					placement:Show();
				else
					placement:Hide();
				end
			end
		end
	end
end

function MPItemManager:SelectRandomSubset(itemCount:number, subsetCount:number):table
	self:DebugPrint("MPItemManager:SelectRandomSubset()");

	local fnSubsetGenerator = self:RandomSubsetGenerator(subsetCount);
	local theSubset = {};

	for i = 1, itemCount do
		theSubset = fnSubsetGenerator(i);
	end

	return theSubset;
end

function MPItemManager:RandomSubsetGenerator(subsetCount:number)
	local i = 0;
	local subset = {};

	return function(item:number)	-- Knuth algorithm S
		i = i + 1;
		if (i <= subsetCount) then
			table.insert(subset, item);
		elseif (random_range(1, i) <= subsetCount) then
			subset[random_range(1, subsetCount)] = item;
		end

		return subset;
	end
end

--
--	SYMMETRICAL CHANNEL MANAGEMENT
--

function MPItemManager:RegisterPlacementSymmetricalChannel(symmetricalChannelId:string, thePlacement:table):void
	if (self.symmetricalChannelPlacements[symmetricalChannelId] == nil) then
		self.symmetricalChannelPlacements[symmetricalChannelId] = {};
	end

	self.symmetricalChannelPlacements[symmetricalChannelId][thePlacement] = false;
end

function MPItemManager:AssignChannelItem(symmetricalChannelId:string, itemIdentifier:ui64):void
	self.perChannelItemSelections[symmetricalChannelId] = itemIdentifier;
end

function MPItemManager:GetChannelItem(symmetricalChannelId:string):ui64
	return self.perChannelItemSelections[symmetricalChannelId];
end

function MPItemManager:HasChannelItemAssigned(symmetricalChannelId:string):boolean
	return self.perChannelItemSelections[symmetricalChannelId] ~= nil;
end

function MPItemManager:ClearChannelItem(symmetricalChannelId:string):void
	self.perChannelItemSelections[symmetricalChannelId] = nil;
end

function MPItemManager:SetChannelItemSpawned(symmetricalChannelId:string, thePlacement:table):void
	if (self.symmetricalChannelPlacements[symmetricalChannelId] == nil or self.symmetricalChannelPlacements[symmetricalChannelId][thePlacement] == nil) then
		return;
	end

	self.symmetricalChannelPlacements[symmetricalChannelId][thePlacement] = true;
end

function MPItemManager:IsChannelItemSpawned(symmetricalChannelId:string, thePlacement:table):boolean
	if (self.symmetricalChannelPlacements[symmetricalChannelId] == nil or self.symmetricalChannelPlacements[symmetricalChannelId][thePlacement] == nil) then
		return false;
	end

	return self.symmetricalChannelPlacements[symmetricalChannelId][thePlacement];
end

function MPItemManager:IsChannelFullySpawned(symmetricalChannelId:string):boolean
	if (self.symmetricalChannelPlacements[symmetricalChannelId] == nil) then
		return false;
	end

	for _, hasSpawned in hpairs (self.symmetricalChannelPlacements[symmetricalChannelId]) do
		if (not hasSpawned) then
			return false;
		end
	end

	return true;
end

function MPItemManager:ClearChannelSpawnedData(symmetricalChannelId:string):void
	if (self.symmetricalChannelPlacements[symmetricalChannelId] == nil) then
		return;
	end

	for curPlacement, _ in hpairs (self.symmetricalChannelPlacements[symmetricalChannelId]) do
		self.symmetricalChannelPlacements[symmetricalChannelId][curPlacement] = false;
	end
end

function MPItemManager:UpdateChannelStatus(symmetricalChannelId:string, thePlacement:table):void
	-- has every placement on this channel already spawned an item? if so, refresh everything, 
	-- otherwise if passed in placement has already spawned, clear the channel item so a new one will be picked
	if (self:IsChannelFullySpawned(symmetricalChannelId)) then
		self:ClearChannelItem(symmetricalChannelId);
		self:ClearChannelSpawnedData(symmetricalChannelId);
	elseif (self:IsChannelItemSpawned(symmetricalChannelId, thePlacement)) then
		self:ClearChannelItem(symmetricalChannelId);
	end
end

function MPItemManager:AddOnSlideLockerGateOpen(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onSlideLockerGateOpen, callbackFunc, callbackOwner);
end

function MPItemManager:RemoveOnSlideLockerGateOpen(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onSlideLockerGateOpen, callbackFunc, callbackOwner);
end

function MPItemManager:AddOnSlideLockerGateClose(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onSlideLockerGateClose, callbackFunc, callbackOwner);
end

function MPItemManager:RemoveOnSlideLockerGateClose(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onSlideLockerGateClose, callbackFunc, callbackOwner);
end

function MPItemManager:TriggerSlideLockerGateOpenEvent():void
	self:TriggerEvent(self.EVENTS.onSlideLockerGateOpen, self);
end

function MPItemManager:TriggerSlideLockerGateCloseEvent():void
	self:TriggerEvent(self.EVENTS.onSlideLockerGateClose, self);
end


-- VO SCHEDULING
function MPItemManager:PlayVO(voData:MPItemSpawnerPendingVOData):void
	if (self.voSupervisor ~= nil) then
		self.voSupervisor:PlayVO(voData);
	end
end

-- DROP POD TRACKING

function MPItemManager:RegisterDropPod(placement:table, pod:object):void
	self.dropPodObjectLookupTable[placement] = pod;
end

function MPItemManager:UnregisterDropPod(placement:table):void
	self.dropPodObjectLookupTable[placement] = nil;
end

function MPItemManager:GetPlacementDropPodObject(placement:table):void
	return self.dropPodObjectLookupTable[placement];
end

function MPItemManager:TryAndGetDropPodOwner(pod:object):table
	for placement, obj in hpairs(self.dropPodObjectLookupTable) do
		if (obj == pod) then
			return placement;
		end
	end

	return nil;
end

-- DEBUGGING

function MPItemManager:EnableDebugPrint(enable):void
	self.CONFIG.enableDebugPrint = enable;
end

function MPItemManager:DebugPrint(...):void
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	if (self.CONFIG.enableDebugPrint) then
		print(...);

		if (self.CONFIG.enableDebugLogging) then
			AddMPItemLogEntry(self, ...);
		end
	end	
end

function MPItemManager:PrintExistingCountTable():void
	for item, count in hpairs (self.existingItemCountTable) do
		self:DebugPrint("Item: ", item, " count: ", count);
	end
end

function AddMPItemLogEntry(parcel:table, ...):void
	if (parcel.logEntries == nil) then
		parcel.logEntries = QueueClass:New();
		parcel.initialLogTime = Game_TimeGet();
	end

	local entry:string = "";

	local argCount:number = select('#', ...);
	local argsTable:table = { ...};
	for idx = 1, argCount do
		entry = entry .. GetEngineString(argsTable[idx]) .. " ";
	end

	local msgTime:number = Game_TimeGet():ElapsedTime(parcel.initialLogTime);
	local logMsg:string = string.format("%.3f : %s", msgTime, entry);

	parcel.logEntries:Push(logMsg);

	if (parcel.logEntries:Count() > parcel.CONST.maxLogEntryCount) then
		parcel.logEntries:Pop();
	end
end

-- IMGUI

global g_mpItemSpawnerDebuggerShown = false;
global g_resizeMPItemSpawnerDebuggerWindow = false;

function DebugMPItemSpawners()
	if (g_mpItemSpawnerDebuggerShown) then
		ImGui_DeactivateCallback("sys_DebugMPItemSpawnersImGUI");
		g_mpItemSpawnerDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_DebugMPItemSpawnersImGUI");
		g_mpItemSpawnerDebuggerShown = true;
	end
end

function sys_DebugMPItemSpawnersImGUI()
	--button to resize window
	if (g_resizeMPItemSpawnerDebuggerWindow) then
		ImGui_SetNextWindowSize(600, 600);
		g_resizeMPItemSpawnerDebuggerWindow = false;
	end
	
	if (ImGui_Begin("MP Item Spawner Debugger")) then
		if (ImGui_Button("  Resize Window  ")) then
			g_resizeMPItemSpawnerDebuggerWindow = true;
		end

		if (ImGui_Button("  Close MP Item Spawner Debugger  ")) then
			DebugMPItemSpawners();
		end

		local windowWidth:number = ImGui_GetWindowWidth();

		local weaponManager:table = _G["MPWeaponManagerInstance"];
		local equipmentManager:table = _G["MPEquipmentManagerInstance"];
		local vehicleManager:table = _G["MPVehicleManagerInstance"];

		if (weaponManager ~= nil) then
			ImGui_Spacing();
			imguiVars.standardHeader("Weapon Manager", sys_DebugMPSpawnerManagerImGUI, weaponManager, "Weapon", windowWidth);
		end
		
		if (equipmentManager ~= nil) then
			ImGui_Spacing();
			imguiVars.standardHeader("Equipment Manager", sys_DebugMPSpawnerManagerImGUI, equipmentManager, "Equipment", windowWidth);
		end

		if (vehicleManager ~= nil) then
			ImGui_Spacing();
			imguiVars.standardHeader("Vehicle Manager", sys_DebugMPSpawnerManagerImGUI, vehicleManager, "Vehicle", windowWidth);
		end
	end
	ImGui_End();
end

function sys_GetFriendlyIdentifierName(item:ui64):string
	if (item == nil) then
		return "nil";
	end

	local itemName:string = GetEngineString(item)
	local first, last = string.find(itemName, " ");
	return string.sub(itemName, first + 1, -1);
end

function sys_ToggleDebugPrintingButton(parcel:table):void
	local printLabel:string = "  Enable Debug Printing: " .. parcel.instanceName .. "  ";
	if (parcel.CONFIG.enableDebugPrint) then
		printLabel = "  Disable Debug Printing: " .. parcel.instanceName .. "  ";
	end

	if (ImGui_Button(printLabel)) then
		parcel.CONFIG.enableDebugPrint = not parcel.CONFIG.enableDebugPrint;
	end

	if (parcel.CONFIG.enableDebugPrint) then
		local logLabel:string = "  Enable Debug Logging: " .. parcel.instanceName .. "  ";
		if (parcel.CONFIG.enableDebugLogging) then
			logLabel = "  Disable Debug Logging: " .. parcel.instanceName .. "  ";
		end

		if (ImGui_Button(logLabel)) then
			parcel.CONFIG.enableDebugLogging = not parcel.CONFIG.enableDebugLogging;
		end
	end
end

global g_itemSpawnerProximityThreshold:string = "0.25";

function sys_DebugProximityCheck(manager:table, allPlacements:table, windowWidth:number)
	ImGui_Columns(2);

	if (ImGui_Button("  Proximity Check  ")) then
		local threshold:number = tonumber(g_itemSpawnerProximityThreshold) or 0.25;
		manager.proximityResults = {};

		for i = 1, #allPlacements do
			local iSpawner:table = allPlacements[i];
			local iPos:location = Object_GetPosition(iSpawner.containerObject);

			for j = i + 1, #allPlacements do
				local jSpawner:table = allPlacements[j];
				local jPos:location = Object_GetPosition(jSpawner.containerObject);

				local distance:number = DistanceBetweenLocations(iPos, jPos);

				if (distance < threshold) then
					table.insert(manager.proximityResults, iSpawner.instanceName .. ", " .. jSpawner.instanceName .. " | Distance = " .. distance);
				end
			end
		end
	end
	
	ImGui_NextColumn();
	ImGui_SetNextItemWidth(windowWidth * 0.2);
	g_itemSpawnerProximityThreshold = ImGui_InputText("Threshold", g_itemSpawnerProximityThreshold);
	ImGui_Columns(1);

	if (#manager.proximityResults > 0) then
		ImGui_Indent();
		if (ImGui_CollapsingHeader("Proximity Results")) then
			for i, result in ipairs(manager.proximityResults) do
				ImGui_Indent();
				ImGui_Text(result);
				ImGui_Unindent();
			end
		end
		ImGui_Unindent();
	end
end

function sys_DebugMPSpawnerManagerImGUI(manager:table, desc:string, windowWidth:number):void
	sys_ToggleDebugPrintingButton(manager);

	local all = manager:GetAllPlacements();
	
	sys_DebugProximityCheck(manager, all, windowWidth);

	ImGui_Text("Total " .. desc .. " Spawner Count: " .. #all);

	local minDist:number = math.huge;
	local closest:number = 0;

	for i, spawner in ipairs(all) do
		local curDist:number = Object_GetDistanceSquaredToObject(PLAYERS.player0, spawner.containerObject);

		if (curDist < minDist) then
			minDist = curDist;
			closest = i;
		end
	end

	if (#all > 0) then
		ImGui_Text("Closest " .. desc .. " Spawner: " .. all[closest].instanceName);
		imguiVars.standardHeader("Spawners Per Class", sys_ShowClassificationTable, manager, windowWidth);
	end

	imguiVars.standardHeader("Existing " .. desc .. " Counts", sys_ShowExistingTable, manager, windowWidth);
	imguiVars.standardHeader(desc .. " Category Weighting", sys_ShowCategoryWeightingTable, manager, windowWidth);
	imguiVars.standardHeader("Symmetrical " .. desc .. " Channel Data", sys_ShowSymmetricalChannelData, manager);
	imguiVars.standardHeader("Spawners Per Selective Channel", sys_ShowSelectiveChannelSpawners, manager, windowWidth);
	imguiVars.standardHeader("Managed Distribution Data", sys_ShowManagedDistributionData, manager, windowWidth);
	imguiVars.standardHeader("Full " .. desc .. " Definition Table", sys_ShowDefinitionTable, manager);
	imguiVars.standardHeader("Override Data", sys_ShowAllOverrideData, manager);
	imguiVars.standardHeader("Random Seed Sequence Info", sys_ShowRandomSeedSequenceInfo);

	if (table.countKeys(manager.dropPodObjectLookupTable) > 0) then
		imguiVars.standardHeader("Active Drop Pods", sys_ShowDropPods, manager);
	end

	if (manager.CONFIG.enableDebugLogging and manager.logEntries ~= nil) then
		imguiVars.standardHeader(desc .. " Log Entries", sys_ShowLogEntries, manager);
	end
end

function sys_ShowLogEntries(parcel:table):void
	for msg in queue_elements(parcel.logEntries) do
		ImGui_Text(msg);
	end
end

function sys_ShowAllOverrideData(manager:table):void
	local managerType = manager:GetType();
	imguiVars.standardHeader("Per Class", sys_ShowGroupOverrideData, manager.CONFIG.perClassOverrides, managerType);
	if (manager:GetType() == MPItemGroupType.Weapon) then
		imguiVars.standardHeader("Per Tier", sys_ShowGroupOverrideData, manager.CONFIG.perTierOverrides, managerType);
	end
	imguiVars.standardHeader("Per Selective Channel", sys_ShowGroupOverrideData, manager.CONFIG.perChannelOverrides, managerType);
	imguiVars.standardHeader("Global", sys_ShowOverrideDataSet, manager.CONFIG.globalOverrides, managerType);
end

function sys_ShowGroupOverrideData(overrideDataList:table, managerType:number):void
	for k, v in hpairs(overrideDataList) do
		local name:string = sys_GetFriendlyIdentifierName(k);

		if (name ~= "None") then
			imguiVars.standardHeader(name, sys_ShowOverrideDataSet, v, managerType);
		end
	end
end

function sys_ShowOverrideDataSet(overrideData, managerType:number):void
	if (overrideData.spawnLogic == MP_SPAWN_LOGIC.Kit) then
		imguiVars.standardTwoItemInfo("Spawn Logic:", "-");
	else
		imguiVars.standardTwoItemInfo("Spawn Logic:", sys_GetFriendlyIdentifierName(overrideData.spawnLogic));
	end
	
	if (overrideData.randomizeFrequency == MP_RANDOMIZE_FREQUENCY.Kit) then
		imguiVars.standardTwoItemInfo("Randomize Frequency:", "-");
	else
		imguiVars.standardTwoItemInfo("Randomize Frequency:", sys_GetFriendlyIdentifierName(overrideData.randomizeFrequency));
	end

	if (overrideData.legendaryItemUsage == MP_LEGENDARY_ITEM_USAGE.Kit) then
		imguiVars.standardTwoItemInfo("Legendary Usage:", "-");
	else
		imguiVars.standardTwoItemInfo("Legendary Usage:", sys_GetFriendlyIdentifierName(overrideData.legendaryItemUsage));
	end
	
	if (overrideData.maxDeployCount == 0) then
		imguiVars.standardTwoItemInfo("Max Deploy Count:", "-");
	else
		imguiVars.standardTwoItemInfo("Max Deploy Count:", overrideData.maxDeployCount);
	end
	
	if (overrideData.navpoint == MPItemManager.CONST.noManagerOverride) then
		imguiVars.standardTwoItemInfo("Navpoint:", "-");
	elseif (overrideData.navpoint > 0) then
		imguiVars.standardTwoItemInfo("Navpoint:", "True");
	else
		imguiVars.standardTwoItemInfo("Navpoint:", "False");
	end

	if (overrideData.initialSpawnDelay <= 0) then
		imguiVars.standardTwoItemInfo("Initial Spawn Delay:", "-");
	else
		imguiVars.standardTwoItemInfo("Initial Spawn Delay:", overrideData.initialSpawnDelay);
	end

	if (overrideData.respawnTime <= 0) then
		imguiVars.standardTwoItemInfo("Respawn Time:", "-");
	else
		imguiVars.standardTwoItemInfo("Respawn Time:", overrideData.respawnTime);
	end

	if (overrideData.seedSequenceKey == nil or overrideData.seedSequenceKey == "") then
		imguiVars.standardTwoItemInfo("Seed Sequence Key:", "-");
	else
		imguiVars.standardTwoItemInfo("Seed Sequence Key:", overrideData.seedSequenceKey);
	end

	if (overrideData.staticSelection == MPItemManager.CONST.noManagerOverride) then
		imguiVars.standardTwoItemInfo("Static Selection:", "-");
	elseif (overrideData.staticSelection > 0) then
		imguiVars.standardTwoItemInfo("Static Selection:", "True");
	else
		imguiVars.standardTwoItemInfo("Static Selection:", "False");
	end

	imguiVars.standardHeader("Faction Filters", sys_ShowOverrideDataSetFilters, overrideData.factionFilters);
	
	if (managerType == MPItemGroupType.Weapon) then
		if (overrideData.initialAmmoLevel <= 0) then
			imguiVars.standardTwoItemInfo("Ammo Modifier:", "-");
		else
			imguiVars.standardTwoItemInfo("Ammo Modifier:", overrideData.initialAmmoLevel);
		end
	
		if (overrideData.forceRandomItem) then
			imguiVars.standardTwoItemInfo("Weapon:", "Random");
		elseif (overrideData.weapon == MP_WEAPON_IDENTIFIER.None) then
			imguiVars.standardTwoItemInfo("Weapon:", "-");
		else
			imguiVars.standardTwoItemInfo("Weapon:", sys_GetFriendlyIdentifierName(overrideData.weapon));
		end

		if (overrideData.class == nil or overrideData.class == MP_WEAPON_CLASS.None) then
			imguiVars.standardTwoItemInfo("Class:", "-");
		else
			imguiVars.standardTwoItemInfo("Class:", sys_GetFriendlyIdentifierName(overrideData.class));
		end
		
		if (overrideData.tier == nil or overrideData.tier == MP_WEAPON_TIER.None) then
			imguiVars.standardTwoItemInfo("Tier:", "-");
		else
			imguiVars.standardTwoItemInfo("Tier:", sys_GetFriendlyIdentifierName(overrideData.tier));
		end
	elseif (managerType == MPItemGroupType.Equipment) then
		if (overrideData.initialEnergyCharge <= 0) then
			imguiVars.standardTwoItemInfo("Energy Charges:", "-");
		else
			imguiVars.standardTwoItemInfo("Energy Charges:", overrideData.initialEnergyCharge);
		end
	
		if (overrideData.grenadeCount <= 0) then
			imguiVars.standardTwoItemInfo("Grenade Count:", "-");
		else
			imguiVars.standardTwoItemInfo("Grenade Count:", overrideData.grenadeCount);
		end
	
		if (overrideData.cyclicalSpawn == MPItemManager.CONST.noManagerOverride) then
			imguiVars.standardTwoItemInfo("Grenade Cyclical Spawn:", "-");
		elseif (overrideData.cyclicalSpawn > 0) then
			imguiVars.standardTwoItemInfo("Grenade Cyclical Spawn:", "True");
		else
			imguiVars.standardTwoItemInfo("Grenade Cyclical Spawn:", "False");
		end
	
		if (overrideData.forceRandomItem) then
			imguiVars.standardTwoItemInfo("Equipment:", "Random");
		elseif (overrideData.equipment == MP_EQUIPMENT_IDENTIFIER.None) then
			imguiVars.standardTwoItemInfo("Equipment:", "-");
		else
			imguiVars.standardTwoItemInfo("Equipment:", sys_GetFriendlyIdentifierName(overrideData.equipment));
		end
	
		if (overrideData.class == nil or overrideData.class == MP_EQUIPMENT_CLASS.None) then
			imguiVars.standardTwoItemInfo("Class:", "-");
		else
			imguiVars.standardTwoItemInfo("Class:", sys_GetFriendlyIdentifierName(overrideData.class));
		end
	elseif (managerType == MPItemGroupType.Vehicle) then
		imguiVars.standardHeader("Terrain Type Filters", sys_ShowOverrideDataSetFilters, overrideData.terrainFilters);
	
		if (overrideData.forceRandomItem) then
			imguiVars.standardTwoItemInfo("Vehicle:", "Random");
		elseif (overrideData.vehicle == MP_VEHICLE_IDENTIFIER.None) then
			imguiVars.standardTwoItemInfo("Vehicle:", "-");
		else
			imguiVars.standardTwoItemInfo("Vehicle:", sys_GetFriendlyIdentifierName(overrideData.vehicle));
		end
	
		if (overrideData.class == nil or overrideData.class == MP_VEHICLE_CLASS.None) then
			imguiVars.standardTwoItemInfo("Class:", "-");
		else
			imguiVars.standardTwoItemInfo("Class:", sys_GetFriendlyIdentifierName(overrideData.class));
		end
	end
end

function sys_ShowOverrideDataSetFilters(filters):void
	for k, v in hpairs(filters) do
		if (v == MPItemManager.CONST.noManagerOverride) then
			imguiVars.standardTwoItemInfo(sys_GetFriendlyIdentifierName(k), "-");
		elseif (v > 0) then
			imguiVars.standardTwoItemInfo(sys_GetFriendlyIdentifierName(k), "True");
		else
			imguiVars.standardTwoItemInfo(sys_GetFriendlyIdentifierName(k), "False");
		end
	end
end

function sys_ShowDefinitionTable(manager:table):void
	if (manager:GetType() == MPItemGroupType.Weapon) then
		local allWeapons:table = GetMPWeaponPlacementTable();
		for k, v in hpairs(allWeapons) do
			imguiVars.standardHeader(sys_GetFriendlyIdentifierName(v.identifier), sys_DebugTable, v);
		end
	elseif (manager:GetType() == MPItemGroupType.Equipment) then
		local allEquip:table = GetMPEquipmentPlacementTable(MP_EQUIPMENT_CLASS.Equipment);
		for k, v in hpairs(allEquip) do
			imguiVars.standardHeader(sys_GetFriendlyIdentifierName(v.identifier), sys_DebugTable, v);
		end
		allEquip = GetMPEquipmentPlacementTable(MP_EQUIPMENT_CLASS.Grenade);
		for k, v in hpairs(allEquip) do
			imguiVars.standardHeader(sys_GetFriendlyIdentifierName(v.identifier), sys_DebugTable, v);
		end
	elseif (manager:GetType() == MPItemGroupType.Vehicle) then
		local allVehicles:table = GetMPVehiclePlacementTable();
		for k, v in hpairs(allVehicles) do
			imguiVars.standardHeader(sys_GetFriendlyIdentifierName(v.identifier), sys_DebugTable, v);
		end
	end
end

function sys_ShowAvailableDefinitionTable(availableItems:table):void
	for k, v in hpairs(availableItems) do
		imguiVars.standardHeader(sys_GetFriendlyIdentifierName(v.identifier), sys_DebugTable, v);
	end
end

function sys_ShowClassificationTable(manager:table, windowWidth:number):void
	for class, classPlacements in hpairs(manager.perClassPlacements) do
		local className:string = "Unspecified/Random";
		if (class ~= manager.CONST.unusedClass) then
			className = sys_GetFriendlyIdentifierName(class);
		end

		if (ImGui_CollapsingHeader("Spawners for " .. className .. " Class")) then
			for i, spawner in ipairs(classPlacements) do
				ImGui_Indent();
				sys_ShowIndividualSpawner(spawner, manager, windowWidth);
				ImGui_Unindent();
			end
		end
	end
end

function sys_ShowIndividualSpawner(spawner:table, manager:table, windowWidth:number):void
	if (ImGui_CollapsingHeader(spawner.instanceName)) then
		ImGui_Indent();
		sys_ToggleDebugPrintingButton(spawner);

		if (spawner.spawnedItemObject == nil and spawner:GetDeploymentStateName() ~= "Restricted") then
			if (ImGui_Button("  Force Spawn Item  ")) then
				spawner:CreateThread(spawner.StartSpawningState);
			end
		end

		imguiVars.standardTwoItemInfo("Parcel:", spawner.parcelName);
				
		if (spawner.containerObject ~= nil) then
			imguiVars.standardTwoItemInfo("Properties:", spawner.spawnProperties);
			imguiVars.standardTwoItemInfo("World Location:", Object_GetPosition(spawner.containerObject));

			local containerStatus:string = "";

			if (Object_GetIsAwake(spawner.containerObject)) then
				containerStatus = containerStatus .. "Awake";
			else
				containerStatus = containerStatus .. "Asleep";
			end

			if (Object_GetVisibilityWakeManagerEnabled(spawner.containerObject)) then
				containerStatus = containerStatus .. ", Viz Wake Mgr Enabled";

				if (Object_GetVisibilityWakeManagerSleepLocking(spawner.containerObject)) then
					containerStatus = containerStatus .. ", Sleep Locked";
				end
			end

			imguiVars.standardTwoItemInfo("Container Status:", containerStatus);

			if (spawner.hasVisibleDispenser) then
				imguiVars.standardTwoItemInfo("Container Type:", "Classic (Invisible)");
			else
				local containerTag:tag = Object_GetDefinition(spawner.containerObject);
				local containerName:string = GetEngineString(containerTag);
				local containerType:string = nil;

				if (string.find(containerName, "rack")) then
					containerType = "Rack";
				elseif (string.find(containerName, "pad")) then
					containerType = "Pad";
				elseif (string.find(containerName, "trunk") or string.find(containerName, "chest")) then
					containerType = "Trunk";
				elseif (string.find(containerName, "pod")) then
					containerType = "Drop Pod";
				end

				if (containerType ~= nil) then
					imguiVars.standardTwoItemInfo("Container Type:", containerType);
				end
			end
		end

		imguiVars.standardTwoItemInfo("Item to Spawn:", sys_GetFriendlyIdentifierName(spawner.itemIdentifier));
		imguiVars.standardTwoItemInfo("Tag to Spawn:", spawner.itemTag);
		if (spawner.itemConfig ~= nil) then
			imguiVars.standardTwoItemInfo("Config to Spawn:", spawner.itemConfig);
		end

		imguiVars.standardTwoItemInfo("Static Selection Enabled:", spawner.CONFIG.staticSelectionEnabled);
		if (spawner.explicitIdentifier ~= nil) then
			imguiVars.standardTwoItemInfo("Kit Specified Item:", sys_GetFriendlyIdentifierName(spawner.explicitIdentifier));
		end

		imguiVars.standardTwoItemInfo("Currently Spawned Object:", tostring(spawner.spawnedItemObject));

		imguiVars.standardTwoItemInfo("Deployment State:", spawner:GetDeploymentStateName());
		imguiVars.standardTwoItemInfo("Initial Spawn Delay:", spawner.CONFIG.initialSpawnDelay .. " Seconds");
		imguiVars.standardTwoItemInfo("Respawn Duration:", spawner.CONFIG.respawnTime .. " Seconds");
		imguiVars.standardTwoItemInfo("Respawn Logic:", sys_GetFriendlyIdentifierName(spawner:GetSpawnLogic()));
		
		if (spawner:GetSpawnLogic() == MP_SPAWN_LOGIC.FixedInterval) then
			local stopwatchTimeStr:string = "Unused";
			local stopwatchTime:number = GlobalStopwatchDaemon:GetElapsedTimeForTarget(spawner, spawner.fixedIntervalStopwatch);
			if (stopwatchTime >= 0) then
				stopwatchTimeStr = string.format("%.2f seconds", stopwatchTime);
			end
			imguiVars.standardTwoItemInfo("Stopwatch Elapsed:", stopwatchTimeStr);
		end

		imguiVars.standardTwoItemInfo("Legendary Usage:", sys_GetFriendlyIdentifierName(spawner.CONFIG.legendaryItemUsage));
		imguiVars.standardTwoItemInfo("Displays Navpoint:", spawner.CONFIG.isMessagingVisible);
		imguiVars.standardTwoItemInfo("Items in Use:", table.countKeys(spawner.deployedItems));
					
		local maxActive:string = tostring(spawner.CONFIG.maxDeployedItemCount);
		if (spawner.CONFIG.maxDeployedItemCount == math.huge) then
			maxActive = "Unlimited";
		end
					
		imguiVars.standardTwoItemInfo("Max Active Items:", maxActive);
		imguiVars.standardTwoItemInfo("Randomization Frequency:", sys_GetFriendlyIdentifierName(spawner:GetRandomRespawnFrequency()));
					
		if (manager:GetType() == MPItemGroupType.Weapon) then
			local ammoModifierName:string = tostring(spawner.CONFIG.initialAmmoModifier * 100) .. "%%";
			if (spawner.CONFIG.initialAmmoModifier == math.huge) then
				ammoModifierName = "Maximum";
			end
					
			imguiVars.standardTwoItemInfo("Initial Ammo Multiplier:", ammoModifierName);
			imguiVars.standardTwoItemInfo("Plasma Detonation Detaches:", spawner.doDamageDetach);
					
			imguiVars.standardTwoItemInfo("Kit Specified Tier:", spawner.tierName);
			imguiVars.standardTwoItemInfo("Current Tier:", sys_GetFriendlyIdentifierName(spawner.tier));
		elseif (manager:GetType() == MPItemGroupType.Equipment) then
			imguiVars.standardTwoItemInfo("Attachment to Spawn:", spawner.attachmentTag);
			local chargeModifierName:string = tostring(spawner.CONFIG.initialEnergyModifier * 100) .. "%%";
			if (spawner.CONFIG.initialEnergyModifier == math.huge) then
				chargeModifierName = "Maximum";
			end
					
			imguiVars.standardTwoItemInfo("Initial Energy Charge Multiplier:", chargeModifierName);

			if (spawner.parcelName == "MPGrenadePlacement") then
				imguiVars.standardTwoItemInfo("Spawn Cyclically:", spawner.CONFIG.spawnCyclically);
				imguiVars.standardTwoItemInfo("Grenade Count:", spawner.CONFIG.groupCount);
			end

			imguiVars.standardHeader("Tracking Data", sys_ShowEquipmentTrackingData, spawner);
		elseif (manager:GetType() == MPItemGroupType.Vehicle) then
			imguiVars.standardHeader("Allowed Terrain Types", sys_ShowFiltersTable, spawner.terrainFilters, windowWidth);
		end

		imguiVars.standardTwoItemInfo("Kit Specified Class:", spawner.className);
					
		if (spawner.class ~= nil) then
			imguiVars.standardTwoItemInfo("Current Class:", sys_GetFriendlyIdentifierName(spawner.class));
		end

		imguiVars.standardHeader("Allowed Factions", sys_ShowFiltersTable, spawner.factionFilters, windowWidth);
		imguiVars.standardHeader("Available Filtered Items", sys_ShowAvailableDefinitionTable, spawner.availableItemTable);

		if (spawner.categoryWeightOverrides ~= nil) then
			imguiVars.standardHeader("Weight Overrides", sys_ShowWeightedTable, spawner.categoryWeightOverrides, windowWidth);
		end

		imguiVars.standardTwoItemInfo("Shows Hologram Preview:", spawner.previewAsHologram);
		imguiVars.standardTwoItemInfo("Should Rotate:", spawner.itemShouldRotate);
		--imguiVars.standardTwoItemInfo("Current Animation State:", Object_DebugGetFirstActiveAnimationName(spawner.containerObject));
		imguiVars.standardHeader("Object Functions", sys_ShowObjectFunctions, spawner);
					
		imguiVars.standardTwoItemInfo("Symmetrical Channel:", spawner.symmetricalChannel);
		imguiVars.standardTwoItemInfo("Selective Channel:", spawner.selectiveChannel);

		if (not spawner.CONST.seedSequenceEnabled) then
			imguiVars.standardTwoItemInfo("Random Seed Sequence:", "Unused");
		else
			if (spawner.CONFIG.variantSeedSequenceKey ~= nil) then
				imguiVars.standardTwoItemInfo("Random Seed Sequence Key:", spawner.CONFIG.variantSeedSequenceKey);
			end
		end

		if ((spawner.CONFIG.enableDebugLogging or manager.CONFIG.enableDebugLogging) and spawner.logEntries ~= nil) then
			imguiVars.standardHeader("Log Entries", sys_ShowLogEntries, spawner);
		end

		ImGui_Unindent();
	end
end

function sys_ShowExistingTable(manager:table, windowWidth:number):void
	sys_ShowWeightedTable(manager.existingItemCountTable, windowWidth);
end

function sys_ShowCategoryWeightingTable(manager:table, windowWidth:number):void
	local basicWeightingTable:table = manager:GetWeightingTable(false);
	local escalatingCategoryWeightingTable:table = manager:GetWeightingTable(true);
	local isVehicleMgr:boolean = manager:GetType() == MPItemGroupType.Vehicle;
	local hasAirDropEscalating:boolean = isVehicleMgr and manager.CONFIG.useEscalatingCategoryWeightsForAirdrop;

	if ((manager.CONFIG.useEscalatingCategoryWeights or hasAirDropEscalating) and table.countKeys(escalatingCategoryWeightingTable) > 0) then
		ImGui_Indent();
		imguiVars.standardHeader("Basic Weights", sys_ShowWeightedTable, basicWeightingTable, windowWidth);
		imguiVars.standardHeader("Escalating Weights", sys_ShowWeightedTable, escalatingCategoryWeightingTable, windowWidth);

		if (isVehicleMgr) then
			imguiVars.standardTwoItemInfo("Air Terrain Prerequisite Count:", manager.CONFIG.airTerrainVehiclePrerequisiteCount);
			imguiVars.standardTwoItemInfo("Escalating Vehicles Spawned:", manager.totalEscalatingSpawnCount);
		end

		ImGui_Unindent();
	else
		sys_ShowWeightedTable(basicWeightingTable, windowWidth);
	end
end

function sys_ShowWeightedTable(weightTable:table, windowWidth:number):void
	ImGui_Indent();
	ImGui_Columns(2);
	for item, weight in hpairs(weightTable) do
		ImGui_SetNextItemWidth(windowWidth * 0.8);
		ImGui_Text(sys_GetFriendlyIdentifierName(item));
		ImGui_NextColumn();
		ImGui_SetNextItemWidth(windowWidth * 0.2);
		ImGui_Text(tostring(weight));
		ImGui_NextColumn();
	end
	ImGui_Columns(1);
	ImGui_Unindent();
end

function sys_ShowDropPods(manager:table):void
	ImGui_Indent();
	ImGui_Columns(2);
	for placement, pod in hpairs(manager.dropPodObjectLookupTable) do
		ImGui_Text(placement.instanceName);
		ImGui_NextColumn();
		ImGui_Text(tostring(pod));
		ImGui_NextColumn();
	end
	ImGui_Columns(1);
	ImGui_Unindent();
end

function sys_ShowEquipmentTrackingData(spawner:table):void
	for i, data in ipairs (spawner.deployedItems) do
		imguiVars.standardHeader("Item " .. i, sys_ShowEquipmentTrackingDatum, data);
	end
end

function sys_ShowEquipmentTrackingDatum(datum):void
	if (datum.definition == nil) then
		imguiVars.standardTwoItemInfo("Definition:", "nil");
	else
		imguiVars.standardHeader("Definition", sys_DebugTable, datum.definition);
	end

	imguiVars.standardTwoItemInfo("Equipment Object:", datum.equipment);
	imguiVars.standardTwoItemInfo("Unit:", datum.unit);

	if (datum.state == 1) then
		imguiVars.standardTwoItemInfo("Lifecyle State:", "Placed");
	elseif (datum.state == 2) then
		imguiVars.standardTwoItemInfo("Lifecyle State:", "Carried");
	elseif (datum.state == 3) then
		imguiVars.standardTwoItemInfo("Lifecyle State:", "Dropped");
	end
end

function sys_ShowObjectFunctions(spawner:table):void
	imguiVars.standardTwoItemInfo(spawner.CONST.loadingAnimateName, object_get_function_value(spawner.containerObject, spawner.CONST.loadingAnimateName));
	imguiVars.standardTwoItemInfo(spawner.CONST.openingAnimateName, object_get_function_value(spawner.containerObject, spawner.CONST.openingAnimateName));
	imguiVars.standardTwoItemInfo(spawner.CONST.closingAnimateName, object_get_function_value(spawner.containerObject, spawner.CONST.closingAnimateName));
	imguiVars.standardTwoItemInfo(spawner.CONST.rotatingAnimateName, object_get_function_value(spawner.containerObject, spawner.CONST.rotatingAnimateName));
	imguiVars.standardTwoItemInfo(spawner.CONST.loadingSpeedName, object_get_function_value(spawner.containerObject, spawner.CONST.loadingSpeedName));
	imguiVars.standardTwoItemInfo(spawner.CONST.statusBarColorName, object_get_function_value(spawner.containerObject, spawner.CONST.statusBarColorName));

	if (spawner.parcelName == "MPWeaponPlacement") then
		for class, fnName in hpairs(spawner.CONST.hologramIconSelectionName) do
			imguiVars.standardTwoItemInfo(GetEngineString(fnName), object_get_function_value(spawner.containerObject, fnName));
		end

		imguiVars.standardTwoItemInfo(GetEngineString(spawner.CONST.hologramIconColorName), object_get_function_value(spawner.containerObject, spawner.CONST.hologramIconColorName));
	elseif (spawner.parcelName == "MPGrenadePlacement") then
		imguiVars.standardTwoItemInfo(spawner.CONST.occupiedOpenRightAnimName, object_get_function_value(spawner.containerObject, spawner.CONST.occupiedOpenRightAnimName));
		imguiVars.standardTwoItemInfo(spawner.CONST.occupiedOpenLeftAnimName, object_get_function_value(spawner.containerObject, spawner.CONST.occupiedOpenLeftAnimName));
	end
end

function sys_ShowSymmetricalChannelData(manager:table):void
	ImGui_Indent();
	for channel, item in hpairs(manager.perChannelItemSelections) do
		channel = string.sub(channel, 1, 30);
		imguiVars.standardTwoItemInfo(channel .. " ...", sys_GetFriendlyIdentifierName(item));
	end
	ImGui_Unindent();
end

function sys_ShowSelectiveChannelSpawners(manager:table, windowWidth:number):void
	ImGui_Indent();
	for i = 0, #MP_ITEM_CHANNEL - 1 do
		local channelPlacements:table = manager.selectiveChannelPlacements[MP_ITEM_CHANNEL[i]];
		if (channelPlacements ~= nil and #channelPlacements > 0) then
			if (ImGui_CollapsingHeader("Spawners for " .. sys_GetFriendlyIdentifierName(MP_ITEM_CHANNEL[i]) .. " Channel")) then
				for j, spawner in ipairs(channelPlacements) do
					ImGui_Indent();
					sys_ShowIndividualSpawner(spawner, manager, windowWidth);
					ImGui_Unindent();
				end
			end
		end
	end
	ImGui_Unindent();
end

function sys_ShowManagedDistributionData(manager:table, windowWidth:number):void
	ImGui_Indent();
	for i = 0, #MP_ITEM_CHANNEL - 1 do
		if (manager:ChannelUsesManagedDistribution(MP_ITEM_CHANNEL[i])) then
			if (ImGui_CollapsingHeader(sys_GetFriendlyIdentifierName(MP_ITEM_CHANNEL[i]) .. " Channel")) then
				ImGui_Indent();
				imguiVars.standardTwoItemInfo("Interval", manager:GetChannelManagedDistributionInterval(MP_ITEM_CHANNEL[i]));
				imguiVars.standardTwoItemInfo("Variance", manager:GetChannelManagedDistributionVariance(MP_ITEM_CHANNEL[i]));

					local upcoming:table = manager.managedDistributionLists[MP_ITEM_CHANNEL[i]];
					if (upcoming ~= nil and #upcoming > 0) then
						if (ImGui_CollapsingHeader("Spawn Order")) then
							ImGui_Indent();
							for j = #upcoming, 1, -1 do
								sys_ShowIndividualSpawner(upcoming[j], manager, windowWidth);
							end
							ImGui_Unindent();
						end
					end
				ImGui_Unindent();
			end
		end
	end
	ImGui_Unindent();
end

function sys_ShowFiltersTable(filters:table, windowWidth:number):void
	local columns = table.countKeys(filters);
	ImGui_Columns(columns);
	for type, value in hpairs(filters) do
		ImGui_SetNextItemWidth(windowWidth / (columns * 1.75));
		ImGui_Checkbox(sys_GetFriendlyIdentifierName(type), value);
		ImGui_NextColumn();
	end
	ImGui_Columns(1);
end

function sys_ShowRandomSeedSequenceInfo():void
	imguiVars.standardHeader("Variant Sequence Keys", sys_ShowRandomSeedSequenceKeys);
	imguiVars.standardHeader("Global Tokens", sys_DebugTable, SeedSequence.GLOBALS.seedMacroList);
end

function sys_ShowRandomSeedSequenceKeys():void
	local seqKeys:table = GetGeneralMPItemGameVariantSeedSequenceKeyArgs();

	if (seqKeys ~= nil) then
		for k, v in hpairs(seqKeys) do
			imguiVars.standardHeader(k, sys_DebugTable, v);
		end
	end
end
