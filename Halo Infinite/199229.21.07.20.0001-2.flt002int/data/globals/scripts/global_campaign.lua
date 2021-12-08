-- Copyright (c) Microsoft. All rights reserved.
-- ===============================================================================================================================================
-- CAMPAIGN GLOBALS ================================================================================================================================
-- ===============================================================================================================================================
REQUIRES('globals\scripts\global_persistence.lua');
REQUIRES('globals\scripts\global_audio_interface.lua');
REQUIRES('globals\scripts\global_telemetry.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\global_mixstates.lua');

--## SERVER
global g_allActivatorKits = {};

--global enums for mission states (tac map, mission manager).  This is base 0 because the persistence keys default to 0
global missionStateEnum = table.makeEnum
	{
		undiscovered = 0,
		unknown = 1,
		intelReceived = 2,
		discovered = 3,
		scouted = 4,
		hasSeenIntro = 5,
		reclaimed = 6,
		partialCompleted = 7,
		missionCompletedButNotAllTheSubmissions = 8,
		replay = 9,
		completed = 10,
		completed_easy = 11,
		completed_normal = 12,
		completed_heroic = 13,
		completed_legendary = 14,
		completed_legendary_all_skulls = 15,
	};
	
--global enums for collectible state
global collectibleStateEnum = table.makeEnum
	{
		--change these to missionStateEnum. ?
		uncollected = 0,
		discovered = 3,
		collected = 10,
	};

function IsCollectibleCollected(collectibleKey:persistence_key, participant:player):boolean
	if (participant ~= nil) then
		return Persistence_GetByteKeyForParticipant(participant,collectibleKey) == collectibleStateEnum.collected;
	else
		return Persistence_GetByteKey(collectibleKey) == collectibleStateEnum.collected;
	end
end

function SetCollectibleCollected(persistenceKey:persistence_key, participant:player):void
	if (participant ~= nil) then
		Persistence_SetByteKeyForParticipant(participant, persistenceKey, collectibleStateEnum.collected);
	else
		Persistence_SetByteKey(persistenceKey, collectibleStateEnum.collected);
	end
end

function SetHalseyCollectibleCollected(persistenceKey:persistence_key, participant:player):void
	if (participant ~= nil) then
		Persistence_SetByteKeyForParticipant(participant, persistenceKey, collectibleStateEnum.collected);
	else
		SetItemKeyComplete(persistenceKey)
	end
	NarrativeInterface.SendClientHuiEvent("show_halsey_datapad");
	SleepSeconds(10);
	NarrativeInterface.SendClientHuiEvent("hide_halsey_datapad");
end

function SetCollectibleState(persistenceKey:persistence_key, state:number, participant:player):void
	state = state or collectibleStateEnum.uncollected;
	if (participant ~= nil) then
		Persistence_SetByteKeyForParticipant(participant, persistenceKey, state);
	else
		Persistence_SetByteKey(persistenceKey, state);
	end
end

-- if a mission is completed on legendary difficulty with all of the skulls enabled, 
-- we need to record that information as its own completion state, which is completed_legendary_all_skulls, 
-- in order to drive the "Ahead of Everyone Else" achievement.
function GetMissionStateEnumCompletedLegendary():number
	if get_num_active_skulls() == #SKULL then
		return missionStateEnum.completed_legendary_all_skulls;
	else
		return missionStateEnum.completed_legendary;
	end
end

global missionStateDifficultyMap = table.makePermanent
	{
		[DIFFICULTY.easy] = missionStateEnum.completed_easy,
		[DIFFICULTY.normal] = missionStateEnum.completed_normal,
		[DIFFICULTY.heroic] = missionStateEnum.completed_heroic,
		--[DIFFICULTY.legendary] = missionStateEnum.completed_legendary, -- mission state on legnedary difficulty is going to be evaluated when indexing 
	};

setmetatable(missionStateDifficultyMap, {
	__index = function(mytable, key)
		if key == DIFFICULTY.legendary then
			return GetMissionStateEnumCompletedLegendary();
		else
			return mytable[key];
		end
	end
});

global difficultyMissionStateMap = table.makePermanent
	{
		[missionStateEnum.completed] = DIFFICULTY.normal,
		[missionStateEnum.completed_easy] = DIFFICULTY.easy,
		[missionStateEnum.completed_normal] = DIFFICULTY.normal,
		[missionStateEnum.completed_heroic] = DIFFICULTY.heroic,
		[missionStateEnum.completed_legendary] = DIFFICULTY.legendary,
		[missionStateEnum.completed_legendary_all_skulls] = DIFFICULTY.legendary,
	};

global poiTypes = table.makeAutoEnum
	{
		"spire",
		"base",
		"pilotBase",
		"prisonBase",
		"refineryBase",
		"bossHQInterior",
		"bossHQExterior",
		"outpost",
		"deadSpartan",
		"memoryCore",
		"dungeon",
		"aaGun",
		"fob",
		"epoi",
		"scanner",
		"banishedShip",
		"underbelly",
		"cortanaPalace",
		"skull",
		"hvt",
		"marineSupport",
		"totem",
		"armorLocker",
		"bridge",
		"collectible",
		"forerunnerTower",
		"spartanSuperMission",
		"hvtSuperMission",
		"marineSuperMission",
		"collectibleSuperMission",
		"scannerSuperMission",
		"banishedDatapad",
		"unscDatapad"
	};

-- UNLOCK FUNCTION
--switch this to persistence_key type
function UnlockCampaignItem(persistenceKey:string)
	print("** Unlocked schematic: ", persistenceKey );
	if persistenceKey ~= nil then
		Persistence_SetBoolKey(Persistence_TryCreateKeyFromString(persistenceKey), true);
	end
end

function IsMissionCompleted(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	return state >= missionStateEnum.completed;
end

function IsMissionCompletedForPlayer(player:player, missionKey:persistence_key):boolean
	local state = Persistence_GetByteKeyForParticipant(player, missionKey);
	return state >= missionStateEnum.completed;
end

function IsMissionHasSeenIntro(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	return state == missionStateEnum.hasSeenIntro;
end

function IsMissionReceived(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	return state == missionStateEnum.intelReceived;
end

function IsMissionDiscovered(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	return state == missionStateEnum.discovered;
end

-- ======================
-- == TRY TO SET STATE ==
-- ======================

--if the current intState of the persistence key is less than the missionState argument, then set the intState to the missionState argument
--please do not use this function directly
function SetMissionStateIfLessThan(persistentState:persistence_key, newState:number):number
	--error check the persistentState.  Have to check against _G because the table exists in the game variant
	--	which means PersistenceKeys table won't compile in Faber without loading the campaign game variant
	local persistenceKeysTable:table =  PersistenceKeys;
	
	if persistenceKeysTable == nil then
		print("Persistence: Can't set persistence keys, there is no PersistenceKeys table to error check");
		print("if in Faber use SetEditorScriptVariant('tags\scripts\VariantScriptOutput\OlympusCampaign-Normal.txt') ");
		return newState;
	end
	
	assert(newState ~= nil, "SetMissionState: newState argument is nil");
	assert(newState >= missionStateEnum.undiscovered, "SetMissionState: newState argument is less than "..tostring(missionStateEnum.undiscovered));
	assert(newState <= missionStateEnum.completed_legendary_all_skulls, "SetMissionState: newState argument is greater than "..tostring(missionStateEnum.completed_legendary_all_skulls));

	if persistentState == nil then 
		return newState;
	end
	
	local isStateUpgraded:number = 0;

	-- Set the key for each player only if this value is higher than their current value.
	-- Don't want to stomp a Legendary completion with a Normal completion for example.
	for k, player in ipairs(PLAYERS.active) do
		local playerPersistentState:number = Persistence_GetByteKeyForParticipant(player, persistentState);
		if (playerPersistentState < newState) then
			SetPoiToMissionStateForParticipant(persistentState, newState, player);
			isStateUpgraded = 1;
		end
	end
	
	-- After participant sets, the world state is updated automatically to the slowest buffalo, return that.
	local currentPersistentState:number = Persistence_GetByteKey(persistentState);
	return currentPersistentState, isStateUpgraded;
end


-- =======================
-- == SET POI FUNCTIONS ==
-- =======================


function SetPoiToUndiscovered(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.undiscovered);
end

function SetPoiToUnknown(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.unknown);
end

function SetPoiToIntelReceived(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.intelReceived);
end

function SetPoiToDiscovered(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.discovered);
end

function SetPoiToScouted(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.scouted);
end

function SetPoiToHasSeenIntro(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.hasSeenIntro);
end

--reclaimed is special because it can go backwards, so force it to the state
function SetPoiToReclaimed(persistentStateKey:persistence_key):number
	return SetPoiToMissionState(persistentStateKey, missionStateEnum.reclaimed);
end

function SetPoiToPartialCompleted(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.partialCompleted);
end

function SetPoiToMissionCompletedButNotAllTheSubmissions(persistentStateKey:persistence_key):number
	return SetMissionStateIfLessThan(persistentStateKey, missionStateEnum.missionCompletedButNotAllTheSubmissions);
end

function SetPoiToCompleted(persistentStateKey:persistence_key):number
	local enum:number = missionStateDifficultyMap[game_difficulty_get_real()];
	return SetMissionStateIfLessThan(persistentStateKey, enum);
end

function SetPoiToMissionState(persistentStateKey:persistence_key, stateEnum:number):number
	--error check when available
	Persistence_SetByteKey(persistentStateKey, stateEnum);
	return stateEnum;
end

function SetPoiToMissionStateForParticipant(persistentStateKey:persistence_key, stateEnum:number, player:player):number
	Persistence_SetByteKeyForParticipant(player, persistentStateKey, stateEnum);
	AudioMixStates.SetAudioPersistenceState(persistentStateKey, stateEnum);

	return stateEnum;
end

--POI entered and discovered
global g_poiEnteredTrackingTable:table = {};
g_poiEnteredTrackingTable.enteredThread = nil

function DiscoverPoi(poiKey:persistence_key, noIntro:boolean)
	if poiKey == nil then
		print("no poiKey set in DiscoverPOI");
		return;
	end
	print("DiscoverPOI for", poiKey);
	--wait the engine to be warmed up so that the mission manager inits and AI can spawn
	SleepUntil([| _G["g_currentMissionManager"] ~= nil ], 1);
	--does this need to check on booleans?
	local previousKeyState:number = Persistence_GetByteKey(poiKey);
	
	--set the poi's persistence key to discovered if it is not already
	SetPoiToDiscovered(poiKey);
	
	--call the poi entered callback
	PoiEnteredCallback(poiKey, previousKeyState, noIntro);
end

function ExitPoi(poiKey:persistence_key)
	if poiKey == nil then
		print("no poiKey set in ExitPoi");
		return;
	end

	PoiExitedCallback(poiKey);
end


-- =======================
-- ====== UTILITIES ======
-- =======================

function RemoveAllPingLines(player:player)
	RunFunctionIfFunctionNameDefined("RemoveAllCommObjectConnections", player);
	RemoveAllObjectiveShadersAndNavpoints(player);
end

function RemoveAllObjectiveShadersAndNavpoints(player:player)
	RunFunctionIfFunctionNameDefined("RemoveAllObjectiveInformation", player);
end

hstructure bannerStruct
	messageType:splash_message_type		--the splash_message_type the banner will use (mostly animation and icon, text fields
	collectibleTable:table
	rewardParameters:table
	realizationTable:table
	customHeaderStringId:string_id		--string id for the "header" part of the banner.  The headerID string_id's are set in ingame.txt
	iconDataTable:table
	maxDuration:number					--length that the banner will be shown
	messageStringId:string_id			--string id for the "message" part of the banner.  The message string_id's are set in campaign_map.txt
	postCall:ifunction					--function that will be called after the banner has been shown (can also block)
	blocking:boolean					--if set to true then BannerManager:DisplayBanner will block until the banner has shown
	isCurrentlyBlocking:boolean			--used by the system, please don't set
end



--EXAMPLE for table
--[[

	{
		GetCollectibleIconOrder(collectibleStringType),	--icon index:number 
		GetCountOfCollectedCollectibles(typeTable),		--current items:number 
		typeTable.maxCount,								--max items:number 
		false,											--ItemCountUpdated:boolean
	};

--]]




--EXAMPLES for rewards
--[[
	{
	  PresentingRewards =
		{
		   {iconindex, titleStringId, param(if it has)},
		   {iconindex, titleStringId},
		   {iconindex, titleStringId, nil},
		},
	   ExtraRewardsCount = number,
	},
 

	{
	  PresentingRewards = {
		{ 0, Engine_ResolveStringId("test_reward"), 100 },
		{ 0, Engine_ResolveStringId("mongoose"),      },
		{ 0, Engine_ResolveStringId("frag_grenade"),    },
	   },
	  ExtraRewardsCount = 10,
	 },

--]]


--EXAMPLE for realization
--[[
	{
		RealizationText = realizationStringId, -- realization string_id,
		RealizationType = SPLASH_REALIZATION_TYPE.Equipment,  --splash_realization_type
	};

--]]


--EXAMPLE FOR ICONS
--[[
	 
	{
		POIIconId = missionStatePath.icon, --string_id
		POIMarkerType = missionStatePath.iconMarkerType or mapIcons.default.defaultMarkerType, --map_marker type
		POIMissionType = missionType or g_mapMissionTypes.default;  --mission_type
	};

--]]

global BannerManager:table =
	{
		queueThread = nil,
		bannerQueue = nil,
		displayedBanner = nil,
		currentBanner = nil,
		bannerDuration = 8,
		bannerDelay = 0.0,
		paused = false;
		queueStarted = false;
	};

function BannerManager:DeleteBanner():void
	if self.queueThread ~= nil then
		KillThread(self.queueThread);
	end

end

function DisplayBannerTest(hstruct)
	hstruct = hstruct or
	hmake bannerStruct
		{
			messageType = SPLASH_MESSAGE_TYPE.DiscoveredLocation,
			collectibleTable = nil,
			rewardParameters = nil,
			realizationTable = nil,
			customHeaderStringId = nil,
			iconDataTable = nil,
			maxDuration = nil,
			messageStringId = nil
		};

	BannerManager:DisplayBanner(hstruct)
end

function BannerManager:DisplayBanner(hstruct:bannerStruct):void

	--start a banner, returns when the banner has played
	self.bannerQueue = self.bannerQueue or QueueClass:New();
	
	--fixup hstruct
	hstruct = self:ValidateHstruct(hstruct);

	if hstruct.blocking == true then
		hstruct.isCurrentlyBlocking = true;
	end

	self.bannerQueue:Push( hstruct );

	if self.queueThread == nil then
		self.queueStarted = false;
		self.queueThread = CreateThread(self.DisplayQueue, self);
	end
		
	SleepUntil([| hstruct.isCurrentlyBlocking ~= true ], 1);
end

function BannerManager:ValidateHstruct(hstruct:bannerStruct)
	--should this build an hstruct??
	if type(hstruct) ~= "struct" or struct.name(hstruct) ~= "bannerStruct" then
		print("BannerManager: bad data used in DisplayBanner, showing default banner", hstruct);
		hstruct = hmake bannerStruct {customHeaderStringId = "unknown_banner"};
	end
	
	hstruct.messageType = hstruct.messageType or SPLASH_MESSAGE_TYPE.DiscoveredLocation;
	hstruct.collectibleTable = hstruct.collectibleTable or nil;
	hstruct.rewardParameters = hstruct.rewardParameters or nil;
	hstruct.realizationTable = hstruct.realizationTable or nil;
	hstruct.customHeaderStringId = hstruct.customHeaderStringId or nil; --"generic_header";
	hstruct.iconDataTable = hstruct.iconDataTable or nil;
	hstruct.maxDuration = hstruct.maxDuration or self.bannerDuration;
	hstruct.messageStringId = hstruct.messageStringId or "unknown_message";

	return hstruct;
end

function BannerManager:_PushBannerToPlayers(hstruct:bannerStruct)
	--print what this banner is
	SplashEx_PushToAllPlayers(
		hstruct.messageType,
		hstruct.collectibleTable,
		hstruct.rewardParameters,
		hstruct.realizationTable,
		hstruct.customHeaderStringId,
		hstruct.iconDataTable,
		hstruct.maxDuration,
		hstruct.messageStringId
	);
end

function BannerManager:DisplayQueue()
	while self.bannerQueue:NotEmpty() == true do
		if self.paused == false then
			self.queueStarted = true;
			
			local bannerDetails:bannerStruct = self.bannerQueue:Pop();
			self.currentBanner = bannerDetails;
			self:_PushBannerToPlayers(bannerDetails);

			SleepSeconds(bannerDetails.maxDuration)
						
			if bannerDetails.postCall then
				bannerDetails.postCall();
			end
			--remove isCurrentlyBlocking in case is set to blocking
			bannerDetails.isCurrentlyBlocking = false;
			SleepSeconds(self.bannerDelay)

			if self.pausedCallback ~= nil then
				self.pausedCallback();
				self.pausedCallback = nil;
			end

		else
			if self.queueStarted == false and self.pausedCallback ~= nil then
				self.pausedCallback();
				self.pausedCallback = nil;
			end
			SleepUntilSeconds([| self.paused == false ], 1);
		end
	end

	self.queueStarted = false;
	self.currentBanner = nil;
	self.queueThread = nil;
end

function BannerManager:Pause(clearedCallback:ifunction):void
	self.paused = true;

	if self.queueThread ~= nil then
		self.pausedCallback = clearedCallback;
	else
		self.pausedCallback = nil;
		clearedCallback();
	end
end

function BannerManager:Unpause():void
	self.paused = false;
	self.pausedCallback = nil;
end

--=========================================
--=========== player objectives ===========
--=========================================

--===========
--functions
--===========
--new string_id's can be added here: //depot/Shiva/Main/tags/ui/strings/_olympus/campaign/campaign_map.multilingual_unicode_string_list
--through this file //depot/Shiva/Main/data/ui/strings/_olympus/campaign/campaign_map.txt

--[[
 __   __  ___   _______  _______  ___   _______  __    _    _______  _______      ___  _______  _______  _______  ___   __   __  _______  _______ 
|  |_|  ||   | |       ||       ||   | |       ||  |  | |  |       ||  _    |    |   ||       ||       ||       ||   | |  | |  ||       ||       |
|       ||   | |  _____||  _____||   | |   _   ||   |_| |  |   _   || |_|   |    |   ||    ___||       ||_     _||   | |  |_|  ||    ___||  _____|
|       ||   | | |_____ | |_____ |   | |  | |  ||       |  |  | |  ||       |    |   ||   |___ |       |  |   |  |   | |       ||   |___ | |_____ 
|       ||   | |_____  ||_____  ||   | |  |_|  ||  _    |  |  |_|  ||  _   |  ___|   ||    ___||      _|  |   |  |   | |       ||    ___||_____  |
| ||_|| ||   |  _____| | _____| ||   | |       || | |   |  |       || |_|   ||       ||   |___ |     |_   |   |  |   |  |     | |   |___  _____| |
|_|   |_||___| |_______||_______||___| |_______||_|  |__|  |_______||_______||_______||_______||_______|  |___|  |___|   |___|  |_______||_______|
--]]

global objectiveOverrideTable:table =
	{
		overrideKeys = {};
		overrideMissions = {};
	};
--this is the correct way for adding objectives
-- === This shows strings associated with the objective in the HUD and campaign map
--	objPersistenceKey	= the persistence key associated with the objective
--	objectArg			= the object that is told to ping
--	RETURNS:  void
function MissionObjectiveAdd(objPersistenceKey:persistence_key, objectArg:object):void
	MissionObjectiveUpdate(objPersistenceKey, missionStateEnum.discovered, objectArg, true);
end


--this is the correct way for completing objectives
-- === This shows an objective as complete in the HUD and campaign map
--	objPersistenceKey	= the persistence key associated with the objective
--	objectArg			= the object on which the ping will be turned off
--	RETURNS:  void
function MissionObjectiveComplete(objPersistenceKey:persistence_key, objectArg:object):void
	MissionObjectiveUpdate(objPersistenceKey, missionStateEnum.completed, objectArg, false);
end

--this is not the correct way for completing objectives :)
--	objPersistenceKey	= the persistence key associated with the objective
--	RETURNS:  void
function MissionObjectiveDebugComplete(objPersistenceKey:persistence_key):void
	Persistence_SetByteKey(objPersistenceKey, missionStateEnum.completed);
end

--this is the correct way for removing objectives
-- === This shows an objective as removed in the HUD and campaign map
--	objPersistenceKey	= the persistence key associated with the objective
--	objectArg			= the object on which the ping will be turned off
--	RETURNS:  void
function MissionObjectiveRemoved(objPersistenceKey:persistence_key, objectArg:object):void
	MissionObjectiveUpdate(objPersistenceKey, missionStateEnum.reclaimed, objectArg, false);
end

--this adds tracking objects to the current POI or the optional POI
function MissionTrackObjectStart(objectArg:location, missionOrObjectiveKeyArg:persistence_key, playerArg:player):void
	MissionTrackingObjectChangedCallback(missionOrObjectiveKeyArg, objectArg, playerArg, true);
end

--this stops tracking objects to the current POI or the optional POI
function MissionTrackObjectStop(objectArg:location, missionOrObjectiveKeyArg:persistence_key, playerArg:player):void
	MissionTrackingObjectChangedCallback(missionOrObjectiveKeyArg, objectArg, playerArg, false);
end


function MissionObjectiveUpdate(objPersistenceKey:persistence_key, missionStateEnumType:number, objectArg:object, shouldTrack:boolean):void
	--storing the changed keys locally, so that there isn't a race condition with getting the event?
	if objPersistenceKey ~= nil then
		g_changedObjectives[objPersistenceKey] = missionStateEnumType;
	end

	-- perhaps force the state change if the state is not discovered??
	--Persistence_SetByteKey(objPersistenceKey, missionStateEnumType);	
	
	--MissionObjectiveChangedCallback(objPersistenceKey, missionStateEnumType);
	
	MissionObjectiveChangedCallback(objPersistenceKey);

	if objectArg ~= nil then
		MissionTrackingObjectChangedCallback(objPersistenceKey, objectArg, nil, shouldTrack);
	end
	--telemetry
	FireTelemetryEvent("MissionObjectiveUpdated", {objective_PersistenceKey = objPersistenceKey});
end

global g_changedObjectives = {};


function MissionSetMissionObjectiveHasBeenAdded(objPersistenceKey:persistence_key)
	if Persistence_GetKeyType(objPersistenceKey) == PERSISTENCE_KEY_TYPE.Byte then
		SetMissionStateIfLessThan(objPersistenceKey, missionStateEnum.discovered);
	end
end

--Objective overrides
function SetObjectiveKeyOverride(key:persistence_key)
	if Persistence_GetKeyType(key) == PERSISTENCE_KEY_TYPE.Bool then
		Persistence_OverrideBoolKey(key);
	else
		Persistence_OverrideByteKey(key);
	end
	objectiveOverrideTable.overrideKeys[key] = true;
end

function SetKeyToOverridenValue(key:persistence_key)
	local currentValue = nil;
	if Persistence_GetKeyType(key) == PERSISTENCE_KEY_TYPE.Bool then
		currentValue = Persistence_GetBoolKey(key);
		Persistence_RemoveBoolKeyOverride(key);
		Persistence_SetBoolKey(key, currentValue);
		--Persistence_OverrideBoolKey(key);
	else
		currentValue = Persistence_GetByteKey(key);
		Persistence_RemoveByteKeyOverride(key);
		Persistence_SetByteKey(key, currentValue);
		--Persistence_OverrideByteKey(key);
	end
end

function SetObjectiveOverrideKeys()
	for key, _ in hpairs(objectiveOverrideTable.overrideKeys) do
		SetKeyToOverridenValue(key);
	end
	objectiveOverrideTable.overrideKeys = {};
end

--function MissionObjectiveOverrideAdd(objPersistenceKey:persistence_key):void
	--Persistence_OverrideByteKey(objPersistenceKey)
	--MissionObjectiveAdd(objPersistenceKey);
--end
--
--function MissionObjectiveOverrideComplete(objPersistenceKey:persistence_key):void
	--Persistence_OverrideByteKey(objPersistenceKey);
	--MissionObjectiveComplete(objPersistenceKey);
--end

function Persistence_OverrideAndSetByteKey(key:persistence_key, state:number):void
	Persistence_OverrideByteKey(key);
	Persistence_SetByteKey(key, state);
end

function MissionRemoveOverride(objPersistenceKey:persistence_key):void
	Persistence_RemoveByteKeyOverride(objPersistenceKey);
	MissionObjectiveChangedCallback(objPersistenceKey);
end

--Supermission functions
function SupermissionGetDiscoveredAndCompletedCounts(keyList:table)
	local completedCount:number = 0;
	local discoveredCount:number = 0;
	for _, key in ipairs(keyList) do
		if SupermissionIsObjectiveCompleted(key) == true then
			completedCount = completedCount + 1;
		else
			discoveredCount = discoveredCount + 1;
		end
	end

	return discoveredCount, completedCount;
end

function SupermissionIsObjectiveCompleted(persKey:persistence_key):boolean
	if Persistence_GetKeyType(persKey) == PERSISTENCE_KEY_TYPE.Bool then
		return Persistence_GetBoolKey(persKey) == true;
	end
	
	local keyNum:number = Persistence_GetByteKey(persKey);
	return keyNum >= missionStateEnum.completed;
end

-- Objective Helper Functions
function MissionIsObjectiveComplete(objKey:persistence_key):boolean
	local state = Persistence_GetByteKey(objKey);
	if state >= missionStateEnum.completed then
		return true;
	end

	if g_changedObjectives[objKey] ~= nil and g_changedObjectives[objKey] >= missionStateEnum.completed then
		return true;
	end

	return false;
end

function MissionIsObjectiveActive(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	if state == missionStateEnum.discovered then
		return true;
	end
	return false;
end

function MissionIsObjectiveRemoved(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	if state == missionStateEnum.reclaimed then
		return true;
	end
	return false;
end

function MissionIsObjectiveCompleteOrRemoved(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	if MissionIsValueCompleteOrRemoved(state) then
		return true;
	end
	return false;
end

function MissionIsValueCompleteOrRemoved(missionValue):boolean -- used for when the value is already known.
	return missionValue == missionStateEnum.reclaimed or missionValue >= missionStateEnum.completed;
end

function MissionIsObjectiveUndiscovered(missionKey:persistence_key):boolean
	local state = Persistence_GetByteKey(missionKey);
	if state == missionStateEnum.undiscovered then
		return true;
	end
	return false;
end


function PoiHasSeenIntro(poiKey:persistence_key):boolean
	local state = Persistence_GetByteKey(poiKey);
	if state == missionStateEnum.hasSeenIntro then
		return true;
	end
	return false;
end

-- Complete Campfire Persistence Key --
-- Use case: Using the override system (such as in a dungeon) we want to complete a campfire key for
-- serial DM logic.
function CampfireObjectiveComplete(campfirePersistenceKey:persistence_key):void
	SetObjectiveKeyOverride(campfirePersistenceKey);
	SetPoiToCompleted(campfirePersistenceKey);
end

--=====================================
--ITEM KEYS
--=====================================
--sets a bool or byte key to complete (returns if successful)
function SetItemKeyComplete(key:persistence_key):boolean
	if key == nil then
		return false;
	end
	local keyType:persistence_key_type = Persistence_GetKeyType(key);
	local isBool:boolean = keyType == PERSISTENCE_KEY_TYPE.Bool;
	--if current mission is set to override, then override
	local currentMissionManager:table = _G["g_currentMissionManager"];
	if ParcelIsActive(currentMissionManager) then
		if objectiveOverrideTable.overrideMissions[currentMissionManager:GetCurrentMission()] then
			if isBool then
				Persistence_OverrideBoolKey(key);
			else
				Persistence_OverrideByteKey(key);
			end
			objectiveOverrideTable.overrideKeys[key] = true;
		end
	end

	if isBool then
		return Persistence_SetBoolKey(key, true);
	else
		return Persistence_SetByteKey(key, missionStateEnum.completed);
	end
	return false;
end

function IsItemKeyComplete(key:persistence_key):boolean
	--gets a bool or byte key and checks if complete
	if Persistence_GetKeyType(key) == PERSISTENCE_KEY_TYPE.Bool then
		return Persistence_GetBoolKey(key);
	else
		return Persistence_GetByteKey(key) >= missionStateEnum.completed;
	end
end

--=====================================
-- Return true if Spire01 has been completed
function IsDungeonSpire01Completed():boolean
	local perKey:persistence_key = Persistence_TryCreateKeyFromString("poi_green_spire");
	if (perKey ~= nil) then
		return (Persistence_GetByteKey(perKey) >= missionStateEnum.missionCompletedButNotAllTheSubmissions);
	end
	return false;
end


--=====================================
-- Level up a player's Supply Lines Level, unlocking sets of supply lines items.
function SupplyLines_LevelUp(interacter : object):void
	-- PROTO. This logic should probably live on the catalog, but currently there is no way to unlock items via a number value
	local supplyLinesLevels = {
		[1] = { "Schematic-EnergySwordLegendary",
				"Schematic-GravityHammerLegendary",
				"Schematic-SpikeRevolver",
				"Schematic-PlasmaPistolVoidsTearLegendary",
				"Schematic-NeedlerLegendary",
				"Schematic-HotRodLegendary",
				"Schematic-WetworkLegendary",
				"Schematic-SniperRifleNornFang",
				"Schematic-SlagMakerLegendary",
				--MISSING ROCKET LAUNCHER LEGENDARY
				},
		[2] = {	"Schematic-Mongoose",
				"Schematic-Gungoose",
				"Schematic-Treadgoose",
				"Schematic-SidearmPistol",
				"Schematic-AssaultRifle",
				"Schematic-PlasmaPistol",
				"Schematic-FragGrenade",
				},
		[3] = {	"Schematic-Warthog",
				"Schematic-RocketHog",
				"Schematic-GaussHog",
				"Schematic-NeedleHog",
				"Schematic-BattleRifle",
				"Schematic-SpikeRevolver",
				"Schematic-Heatwave",
				"Schematic-PlasmaBlaster",
				},
		[4] = {	"Schematic-Ghost",
				"Schematic-GhostLegendary",
				"Schematic-GhostLegendary2",
				"Schematic-Needler",
				"Schematic-Wetwork",
				"Schematic-PlasmaGrenade",
				"Schematic-ArcZapper",
				},
		[5] = {	"Schematic-Chopper",
				"Schematic-ChopperLegendary",
				"Schematic-CombatShotgun",
				"Schematic-VoltAction",
				"Schematic-CommandoRifle",
				"Schematic-LightningGrenade",
				},
		[6] = {	"Schematic-Scorpion",
				"Schematic-ScorpionLegendary",
				"Schematic-SniperRifle",
				"Schematic-Heatwave",
				"Schematic-SpikeGrenade",
				"Schematic-Skewer",
				},
		[7] = {	"Schematic-Wraith",
				"Schematic-WraithLegendary",
				--MISSING OVERCHARGER / INFUSER
				--MISSING HYDRA,
				"Schematic-EnergySword",
				},
		[8] = {	"Schematic-Banshee",
				--TBD Banshee Variant
				"Schematic-SlagMaker",
				"Schematic-GravityHammer",
				},
		[9] = {	"Schematic-Wasp",
				"Schematic-StingerWasp",
				"Schematic-SentinelBeam",
				"Schematic-RocketLauncher",
				},
	}
	local maxSupplyLinesLevel = table.getn(supplyLinesLevels);	
	local supplyLinesLevel = Persistence_GetLongKeyForParticipant(interacter, Persistence_TryCreateKeyFromString("SupplyLines-Level")) or 0;

	if supplyLinesLevel < maxSupplyLinesLevel then
		supplyLinesLevel = supplyLinesLevel + 1;
		print("UNLOCKING SUPPLY LEVEL", supplyLinesLevel);
		Persistence_SetLongKeyForParticipant(interacter, Persistence_TryCreateKeyFromString("SupplyLines-Level"), supplyLinesLevel)

		for key, value in hpairs(supplyLinesLevels[supplyLinesLevel]) do
			if Persistence_GetBoolKeyForParticipant(interacter, Persistence_TryCreateKeyFromString(value)) ~= nil then
				print("------", string.gsub(value, "Schematic%-", ""));
				Persistence_SetBoolKeyForParticipant(interacter, Persistence_TryCreateKeyFromString(value), true);
			end
		end
	else
		print("Already at maximum Supply Lines Level:", maxSupplyLinesLevel);
	end
end

--[[
 __  ___  __  .___________.    _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
|  |/  / |  | |           |   |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
|  '  /  |  | `---|  |----`   |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
|    <   |  |     |  |        |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
|  .  \  |  |     |  |        |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
|__|\__\ |__|     |__|        |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
																														 
--]]


------------------------
-- poi activator kits --
------------------------
global g_shouldActivate = true;

-- ActivatorKit_SetShouldActivate
--		shouldActivate: boolean for turning of poi activation
--	sets whether poi activator kits are allowed to activate their child kits
function ActivatorKit_SetShouldActivate(shouldActivate:boolean):void
	if shouldActivate == nil then
		shouldActivate = true;
	end
	g_shouldActivate = shouldActivate;
	SetShouldCampfireSave(shouldActivate);
	
	if g_shouldActivate == true then
		-- Activate inactive kits that the player is within the vacinity of
		for poiKit, _ in hpairs(g_allActivatorKits) do
			if not ActivatorKit_IsKeyInInclusionTable(poiKit.persistentFlag) then
				local actVolume = poiKit:GetActivationVolume();
				local playersInVolume = VicinityVolume_GetPlayers(actVolume);
				if #playersInVolume >= 1 then
				   poiKit:ActivationVolumeVicinityEntered(actVolume);
				end
			end
		end
		ActivatorKit_ClearInclusionTable();
	end
	dprint("Activator kits are set to activate", shouldActivate);
end

-- ActivatorKit_GetShouldActivate
--		kitKey: persistence key for the activator kit
-- RETURNS: whether a poi kit is allowed to activate
function ActivatorKit_GetShouldActivate(kitKey:persistence_key):boolean
	return g_shouldActivate == true or ActivatorKit_IsKeyInInclusionTable(kitKey) == true;
end

--Inclusion list for poi kits and fob kits
--view the list with ImGui menu turned on and DebugTable(g_activatorInclusionTable);
global g_activatorInclusionTable = SetClass:New();

-- ActivatorKit_AddKeyToInclusionTable
--		kitKey: persistence key for the activator kit
-- RETURNS: whether the key was added to the table
-- Adds a poi key to an inclusion table so that it will stream in its child kit
-- even if activator kits are disabled globally
function ActivatorKit_AddKeyToInclusionTable(kitKey:persistence_key):boolean
	--if already there return false
	return g_activatorInclusionTable:Insert(kitKey);
end

-- ActivatorKit_AddTableOfKeysToInclusionTable
--		keyTable: array of keys to add to the inclusion table
function ActivatorKit_AddTableOfKeysToInclusionTable(keyTable:table):void
	for _, key in ipairs(keyTable) do
		if GetEngineType(key) == "persistence_key" then
			ActivatorKit_AddKeyToInclusionTable(key);
		end
	end
end

-- ActivatorKit_RemoveKeyFromInclusionTable
--		kitKey: persistence key for the activator kit
-- RETURNS: whether the key was removed from the table
-- removes a poi key from an inclusion table.  It will now be disabled
-- when the activator kits are globally disabled
function ActivatorKit_RemoveKeyFromInclusionTable(kitKey:persistence_key):boolean
	--if not already there return false?
	return g_activatorInclusionTable:Remove(kitKey);
end

-- ActivatorKit_RemoveTableOfKeysFromInclusionTable
--		keyTable: array of keys to remove from the inclusion table
function ActivatorKit_RemoveTableOfKeysFromInclusionTable(keyTable:table)
	for _, key in ipairs(keyTable) do
		if GetEngineType(key) == "persistence_key" then
			ActivatorKit_RemoveKeyFromInclusionTable(key);
		end
	end
end

function ActivatorKit_ClearInclusionTable():void
	g_activatorInclusionTable = SetClass:New();
end

-- ActivatorKit_IsKeyInInclusionTable
--		kitKey: persistence key for the activator kit
-- RETURNS: whether the key is in the global activator kit inclusion table
function ActivatorKit_IsKeyInInclusionTable(kitKey:persistence_key):boolean
	--if already there return false
	return g_activatorInclusionTable:Contains(kitKey);
end

-------------------
-- approach kits --
-------------------
global g_approachKitCanActivate = true;

function ApproachKit_SetCanActivate(canActivate:boolean):void
	if canActivate == nil then
		canActivate = true;
	end
	g_approachKitCanActivate = canActivate;
end

function ApproachKit_GetCanActivate():boolean
	return g_approachKitCanActivate;
end

------------------------
-- dynamic event kits --
------------------------

-- completely disable dynamic events from automatically activating
global disableDynamicEvents = false;
global disabledDynamicEventList = {};

function DisableDynamicEvents()
	disableDynamicEvents = true;
end

function EnableDynamicEvents()
	if disableDynamicEvents == true then
		disableDynamicEvents = false;
		CreateThread(EnableDynamicEvents_ThreadedHelper);
	end
end

function EnableDynamicEvents_ThreadedHelper()
	for kit, handle in hpairs(disabledDynamicEventList) do
		if KitIsActive(handle) then
			kit:OnVolumeEntered();
		end
		disabledDynamicEventList[kit] = nil;
	end
end

----------------------------
-- Campfire saving
----------------------------
global g_campfiresCanSave = true;

function SetShouldCampfireSave(shouldSaveCampfire:boolean)
	g_campfiresCanSave = shouldSaveCampfire;
end

function ShouldCampfireSave()
	return g_campfiresCanSave
end

----------------------------
-- Suppressed objects
----------------------------
global g_pingSuppression = 
	{
		objects = SetClass:New(),
		excludedObjects = SetClass:New(),
	};
setmetatable(g_pingSuppression.objects.list, { __mode = "kv" }); -- Make the tracking table weak so expired objects will get collected.
setmetatable(g_pingSuppression.excludedObjects.list, { __mode = "kv" }); -- Make the tracking table weak so expired objects will get collected.

function AddOrRemovePingSuppressedObject(_object:object, add:boolean)
	if _object == nil or object_index_valid(_object) == false then
		g_pingSuppression.objects:Remove(_object);
		return;
	end
	
	if IsObjectPingSuppressedExcluded(_object) == true then
		g_pingSuppression.objects:Remove(_object);
		return;
	end
	
	if add == nil then add = true end;

	if add == true then
		if g_pingSuppression.objects:Insert(_object) == true then
			if RunMethodIfObjectHasMethod(_object, "SetSpartanTracking", _object, not add) == false then
				ObjectSetSpartanTrackingEnabled(_object, not add);
			end
			RegisterEventOnce(g_eventTypes.objectDeletedEvent, PingSuppressionObjectDeletedCallback, _object);
		end
	else
		if g_pingSuppression.objects:Remove(_object) == true then
			if RunMethodIfObjectHasMethod(_object, "SetSpartanTracking", _object, not add) == false then
				ObjectSetSpartanTrackingEnabled(_object, not add);
			end
			UnregisterEvent(g_eventTypes.objectDeletedEvent, PingSuppressionObjectDeletedCallback, _object);
		end
	end
end

function AddOrRemovePingSuppressedExcludedObject(_object:object, add:boolean)
	if _object == nil or object_index_valid(_object) == false then
		g_pingSuppression.excludedObjects:Remove(_object);
		return;
	end

	if add == nil then add = true end;
	
	if add == true then
		g_pingSuppression.excludedObjects:Insert(_object);
	else
		g_pingSuppression.excludedObjects:Remove(_object);
	end
end

function IsObjectPingSuppressed(_object:object):boolean
	--print("checking if ping is suppressed on", _object);
	return g_pingSuppression.objects:Contains(_object);
end

function IsObjectPingSuppressedExcluded(_object:object):boolean
	return g_pingSuppression.excludedObjects:Contains(_object);
end

function PingSuppressionObjectDeletedCallback(eventArgs:ObjectDeletedStruct)
	g_pingSuppression.objects:Remove(eventArgs.deletedObject);
end

function DebugPingSuppression()
	DebugTable(g_pingSuppression);
end