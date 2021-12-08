--## SERVER

-- Global State Callbacks
-- Copyright (C) Microsoft. All rights reserved.

-------------------------------------------------------------------------------------------------
-- OLD STATE BROKER CALLBACKS FOR BACKWARDS COMPATIBILITY
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- State Broker Bool Value Changed Callback 
-- Called by the game when a tracked value in the State Broker has changed
-------------------------------------------------------------------------------------------------

hstructure BoolStateChangedEventStruct
	newValue:boolean;
	stateName:string_id;
	owningPlayer:player;
end

-- Callback from C++
function StateBrokerBoolValueChangedCallback(name:string_id, value:boolean, owningPlayer:player)

	local eventArgs = hmake BoolStateChangedEventStruct
	{
		newValue = value,
		stateName = name,
		owningPlayer = owningPlayer
	};
	
	if (owningPlayer) then
		CallEvent(g_eventTypes.playerBoolStateChanged, name, eventArgs);
	else
		CallEvent(g_eventTypes.boolStateChanged, name, eventArgs);
	end
end

-------------------------------------------------------------------------------------------------
-- State Broker Int Value Changed Callback
-- Called by the game when a tracked value in the State Broker has changed
-------------------------------------------------------------------------------------------------

hstructure ShortStateChangedEventStruct
	newValue:number;
	stateName:string_id;
	owningPlayer:player;
end

-- Callback from C++
function StateBrokerShortValueChangedCallback(name:string_id, value:number, owningPlayer:player)

	local eventArgs = hmake ShortStateChangedEventStruct
	{
		newValue = value,
		stateName = name,
		owningPlayer = owningPlayer;
	};

	if (owningPlayer) then
		CallEvent(g_eventTypes.playerShortStateChanged, name, eventArgs);
	else
		CallEvent(g_eventTypes.shortStateChanged, name, eventArgs);
	end
end

-------------------------------------------------------------------------------------------------
-- State Broker Int Value Changed Callback
-- Called by the game when a tracked value in the State Broker has changed
-------------------------------------------------------------------------------------------------

hstructure LongStateChangedEventStruct
	newValue:number;
	stateName:string_id;
	owningPlayer:player;
end

-- Callback from C++
function StateBrokerLongValueChangedCallback(name:string_id, value:number, owningPlayer:player)

	local eventArgs = hmake LongStateChangedEventStruct
	{
		newValue = value,
		stateName = name,
		owningPlayer = owningPlayer;
	};

	if (owningPlayer) then
		CallEvent(g_eventTypes.playerLongStateChanged, name, eventArgs);
	else
		CallEvent(g_eventTypes.longStateChanged, name, eventArgs);
	end
end

-------------------------------------------------------------------------------------------------
-- State Broker StringId Value Changed Callback
-- Called by the game when a tracked value in the State Broker has changed
-------------------------------------------------------------------------------------------------

hstructure StringIdStateChangedEventStruct
	newValue:string_id;
	stateName:string_id;
	owningPlayer:player;
end

-- Callback from C++
function StateBrokerStringIdValueChangedCallback(name:string_id, value:string_id, owningPlayer:player)

	local eventArgs = hmake StringIdStateChangedEventStruct
	{
		newValue = value,
		stateName = name,
		owningPlayer = owningPlayer;
	};

	if (owningPlayer) then
		CallEvent(g_eventTypes.playerStringIdStateChanged, name, eventArgs);
	else
		CallEvent(g_eventTypes.stringIdStateChanged, name, eventArgs);
	end
end

-------------------------------------------------------------------------------------------------
-- State Broker Value Changed Callback
-- Called by the game when a tracked value in the State Broker has changed
-------------------------------------------------------------------------------------------------

hstructure StateChangedEventStruct
	newValue:any;
	stateName:string_id;
	owningPlayer:player;
	isInitialState:boolean;
end

-- Callback from C++
function StateBrokerValueChangedCallback(name:string_id, value:any, owningPlayer:player, isInitialState:boolean)

	local eventArgs = hmake StateChangedEventStruct
	{
		newValue = value,
		stateName = name,
		owningPlayer = owningPlayer,
		isInitialState = isInitialState
	};
	
	local eventtype = g_eventTypes.stateChanged;
	
	local stateBrokerIsInGreenBuild = false;
	if stateBrokerIsInGreenBuild then 
		CallEvent(eventtype, name, eventArgs);
	else
		-- Oh my god it's so ugly someone please take it out back and put it out of its misery
		-- We need to remove this AS SOON as the state broker changes are in a green build because looking at it makes me nauseous please send help
		if (StateBroker_GetBoolState(name) ~= nil) then
			eventArgs = hmake BoolStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer,
			};
			eventtype = g_eventTypes.boolStateChanged;
		elseif (StateBroker_GetShortState(name) ~= nil) then
			eventArgs = hmake ShortStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.shortStateChanged;
		elseif (StateBroker_GetLongState(name) ~= nil) then
			eventArgs = hmake LongStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.longStateChanged;
		elseif (StateBroker_GetStringIdState(name) ~= nil) then
			eventArgs = hmake StringIdStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.stringIdStateChanged;
		elseif (StateBroker_GetBoolPlayerState(name, owningPlayer) ~= nil) then
			eventArgs = hmake BoolStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer,
			};
			eventtype = g_eventTypes.playerBoolStateChanged;
		elseif (StateBroker_GetShortPlayerState(name, owningPlayer) ~= nil) then
			eventArgs = hmake ShortStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.playerShortStateChanged;
		elseif (StateBroker_GetLongPlayerState(name, owningPlayer) ~= nil) then
			eventArgs = hmake LongStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.playerLongStateChanged;
		else
			eventArgs = hmake StringIdStateChangedEventStruct
			{
				newValue = value,
				stateName = name,
				owningPlayer = owningPlayer;
			};
			eventtype = g_eventTypes.playerStringIdStateChanged;
		end

		CallEvent(eventtype, name, eventArgs);
	end
end

-------------------------------------------------------------------------------------------------
-- Objective Updated Callback
-- Called by a lua function when a players objective has changed.  Should be changed by a POI and utilized by the map
-------------------------------------------------------------------------------------------------

hstructure MissionObjectiveChangedEventStruct
	objPersistenceState:persistence_key;
end

function MissionObjectiveChangedCallback(objPersistenceKey:persistence_key)
	local eventArgs = hmake MissionObjectiveChangedEventStruct
		{
			objPersistenceState = objPersistenceKey,
		};

	CallEvent(g_eventTypes.missionObjectiveChanged, objPersistenceKey, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Tracking Object Updated Callback
-- Called by a lua function when a missions tracking objective has changed
-------------------------------------------------------------------------------------------------


hstructure MissionTrackingObjectChangedEventStruct
	missionOrObjectiveKey:persistence_key;
	trackingObject:location;
	trackingPlayer:player;
	shouldTrack:boolean;
end

function MissionTrackingObjectChangedCallback(missionOrObjectiveKeyArg:persistence_key, trackingObjectArg:location, trackingPlayerArg:player, shouldTrackArg:boolean)
	local eventArgs = hmake MissionTrackingObjectChangedEventStruct
		{
			missionOrObjectiveKey = missionOrObjectiveKeyArg,
			trackingObject = trackingObjectArg,
			trackingPlayer = trackingPlayerArg,
			shouldTrack = shouldTrackArg,
		};

	CallEvent(g_eventTypes.missionTrackingObjectChanged, missionOrObjectiveKeyArg, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Waypoint Events
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Waypoint Activator Created Callback
-- Called by a lua function when a Waypoint Activator Kit is created
-- This should only be called by the Waypoint Interface
-------------------------------------------------------------------------------------------------

hstructure WaypointActivatorCreatedEventStruct
	waypointActivator:folder;
	missionPersistenceKey:persistence_key;
end

function WaypointActivatorCreatedCallback(waypointActivatorArg:folder, missionPersistenceKeyArg:persistence_key)
	local eventArgs = hmake WaypointActivatorCreatedEventStruct
	{
		waypointActivator = waypointActivatorArg;
		missionPersistenceKey = missionPersistenceKeyArg;
	};

	CallEvent(g_eventTypes.waypointActivatorCreated, waypointActivatorArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Waypoint Activator Destroyed Callback
-- Called by a lua function when a Waypoint Activator Kit is destroyed
-- This should only be called by the Waypoint Interface
-------------------------------------------------------------------------------------------------

hstructure WaypointActivatorDestroyedEventStruct
	waypointActivator:folder;
	missionPersistenceKey:persistence_key;
end

function WaypointActivatorDestroyedCallback(waypointActivatorArg:folder, missionPersistenceKeyArg:persistence_key)
	local eventArgs = hmake WaypointActivatorDestroyedEventStruct
	{
		waypointActivator = waypointActivatorArg;
		missionPersistenceKey = missionPersistenceKeyArg;
	};

	CallEvent(g_eventTypes.waypointActivatorDestroyed, waypointActivatorArg, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Communication Objects
-------------------------------------------------------------------------------------------------

global commObjectChannelsEnum:table = table.makeAutoEnum
	{
		"power",
		"control",
		"ownership",
		"pinged",
		"relayObject",
	};

-------------------------------------------------------------------------------------------------
-- Communication Object Power Update Callback
-- Called by a lua function when an Communication object has changed its power state
-- This should only be called by an Communication object
-------------------------------------------------------------------------------------------------

hstructure CommunicationObjectBaseEventStruct
	channel:number;
	broadcaster:any;
end

hstructure CommunicationObjectPowerUpdateEventStruct : CommunicationObjectBaseEventStruct
	isPowered:boolean;
end

-- callback from Lua
function CommunicationObjectPowerUpdateCallback(channelArg:any, broadcasterArg:any, isPoweredArg:boolean):void
	-- Early out if arguments are nil
	if channelArg == nil or channelArg == "" or broadcasterArg == nil then
		return;
	end
	
	local eventArgs = hmake CommunicationObjectPowerUpdateEventStruct
	{
		channel = commObjectChannelsEnum.power,
		broadcaster = broadcasterArg,
		isPowered = isPoweredArg,
	};

	CallEvent(g_eventTypes.communicationObjectPowerUpdated, channelArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Communication Object Control Update Callback
-- Called by a lua function when an Communication object has changed its control state
-- This should only be called by an Communication object
-------------------------------------------------------------------------------------------------

hstructure CommunicationObjectControlUpdateEventStruct : CommunicationObjectBaseEventStruct
	isEnabled:boolean;
end

-- callback from Lua
function CommunicationObjectControlUpdateCallback(channelArg:any, broadcasterArg:any, isEnabledArg:boolean):void
	-- Early out if arguments are nil
	if channelArg == nil or channelArg == "" or broadcasterArg == nil then
		return;
	end
	
	local eventArgs = hmake CommunicationObjectControlUpdateEventStruct
	{
		channel = commObjectChannelsEnum.control,
		broadcaster = broadcasterArg,
		isEnabled = isEnabledArg,
	};

	CallEvent(g_eventTypes.communicationObjectControlUpdated, channelArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Communication Object Ownership Update Callback
-- Called by a lua function when an Communication object has changed its owner team
-- This should only be called by an Communication object
-------------------------------------------------------------------------------------------------

hstructure CommunicationObjectOwnershipUpdateEventStruct : CommunicationObjectBaseEventStruct
	owner:mp_team_designator;
end

-- callback from Lua
function CommunicationObjectOwnershipUpdateCallback(channelArg:any, broadcasterArg:any, ownerArg:mp_team_designator):void
	-- Early out if arguments are nil
	if channelArg == nil or channelArg == "" or broadcasterArg == nil then
		return;
	end
	
	local eventArgs = hmake CommunicationObjectOwnershipUpdateEventStruct
	{
		channel = commObjectChannelsEnum.ownership,
		broadcaster = broadcasterArg,
		owner = ownerArg,
	};

	CallEvent(g_eventTypes.communicationObjectOwnershipUpdated, channelArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Communication Object Pinged Callback
-- Called by a lua function when an Communication object has been pinged
-- This should only be called by an Communication object
-------------------------------------------------------------------------------------------------

hstructure CommunicationObjectPingedEventStruct : CommunicationObjectBaseEventStruct
end

-- callback from Lua
function CommunicationObjectPingedCallback(channelArg:any, broadcasterArg:any):void
	-- Early out if arguments are nil
	if channelArg == nil or channelArg == "" or broadcasterArg == nil then
		return;
	end
	
	local eventArgs = hmake CommunicationObjectPingedEventStruct
	{
		channel = commObjectChannelsEnum.pinged,
		broadcaster = broadcasterArg,
	};

	CallEvent(g_eventTypes.communicationObjectPinged, channelArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Communication Object Relay Object Callback
-- Called by a lua function when an Communication object needs to relay an object to another Communication object
-- This should only be called by an Communication object
-------------------------------------------------------------------------------------------------

hstructure CommunicationObjectRelayObjectEventStruct : CommunicationObjectBaseEventStruct
	target:object;
end

-- callback from Lua
function CommunicationObjectRelayObjectCallback(channelArg:any, broadcasterArg:any, targetArg:object):void
	-- Early out if arguments are nil
	if channelArg == nil or channelArg == "" or broadcasterArg == nil then
		return;
	end
	
	local eventArgs = hmake CommunicationObjectRelayObjectEventStruct
	{
		channel = commObjectChannelsEnum.relayObject,
		broadcaster = broadcasterArg,
		target = targetArg,
	};

	CallEvent(g_eventTypes.communicationObjectRelayObject, channelArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- POI Streamed In Callback
-- Called by a lua function when a POI is streamed in (like from an activator kit)
-------------------------------------------------------------------------------------------------

hstructure PoiStreamedInEventStruct
	poiPersistenceKey	:persistence_key;
	loadedKit			:folder;
end

-- callback from Lua, currently from an activator kit
function PoiStreamedInCallback(poiPersistenceKeyArg:persistence_key, loadedKitArg:folder):void
	local eventArgs = hmake PoiStreamedInEventStruct
	{
		poiPersistenceKey = poiPersistenceKeyArg,
		loadedKit = loadedKitArg,
	};

	CallEvent(g_eventTypes.poiStreamedIn, poiPersistenceKeyArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- POI Entered Callback
-- Called by a lua function when a POI is entered
-------------------------------------------------------------------------------------------------

hstructure PoiEnteredEventStruct
	poiPersistenceKey	:persistence_key;
	noIntro				:boolean;
	previousKeyState	:any;
end

-- callback from Lua, currently from an activator kit
function PoiEnteredCallback(poiPersistenceKeyArg:persistence_key, previousKeyStateArg:any, noIntroArg:boolean):void
	local eventArgs = hmake PoiEnteredEventStruct
	{
		poiPersistenceKey = poiPersistenceKeyArg,
		previousKeyState = previousKeyStateArg,
		noIntro = noIntroArg,
	};

	CallEvent(g_eventTypes.poiEntered, poiPersistenceKeyArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- POI Intro Completed Callback
-- Called by a lua function when a POI intro is completed
-------------------------------------------------------------------------------------------------

hstructure PoiIntroCompletedEventStruct
	poiPersistenceKey	:persistence_key;
end

-- callback from Lua, currently from an activator kit
function PoiIntroCompletedCallback(poiPersistenceKeyArg:persistence_key):void
	local eventArgs = hmake PoiIntroCompletedEventStruct
	{
		poiPersistenceKey = poiPersistenceKeyArg,
	};

	CallEvent(g_eventTypes.poiIntroCompleted, poiPersistenceKeyArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- POI Exited Callback
-- Called by a lua function when a POI is exited
-------------------------------------------------------------------------------------------------

hstructure PoiExitedEventStruct
	poiPersistenceKey	:persistence_key;
end

-- callback from Lua, currently from an activator kit
function PoiExitedCallback(poiPersistenceKeyArg:persistence_key, enteredArg:boolean):void
	local eventArgs = hmake PoiExitedEventStruct
	{
		poiPersistenceKey = poiPersistenceKeyArg,
	};

	CallEvent(g_eventTypes.poiExited, poiPersistenceKeyArg, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- POI Streamed Out Callback
-- Called by a lua function when a POI is streamed out (like from an activator kit)
-------------------------------------------------------------------------------------------------

hstructure PoiStreamedOutEventStruct
	poiPersistenceKey	:persistence_key;
	kitName				:string;
end

-- callback from Lua, currently from an activator kit
function PoiStreamedOutCallback(poiPersistenceKeyArg:persistence_key, kitNameArg:string):void
	local eventArgs = hmake PoiStreamedOutEventStruct
	{
		poiPersistenceKey = poiPersistenceKeyArg,
		kitName = kitNameArg,
	};

	CallEvent(g_eventTypes.poiStreamedOut, poiPersistenceKeyArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Pre-Level Transition
-- Called by global loading just before a level transition will occur
-------------------------------------------------------------------------------------------------

hstructure PreLevelTransitionEventStruct
	level:string
	zoneSet:string
	spawnPoint:string
end

-- callback from global loading
function PreLevelTransitionCallback(levelArg:string, zoneSetArg:string, spawnPointArg:string):void
	local eventArgs = hmake PreLevelTransitionEventStruct
	{
		level = levelArg,
		zoneSet = zoneSetArg,
		spawnPoint = spawnPointArg,
	};

	CallEvent(g_eventTypes.preLevelTransition, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Pre-Level Transition Fade In
-- Called by fade in system when all opt-ins have cleared their initialization
-------------------------------------------------------------------------------------------------

-- callback from fade in management
function PreLevelTransitionFadeInCallback():void
	CallEvent(g_eventTypes.preLevelTransitionFadeIn, nil);
end