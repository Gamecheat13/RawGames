--## SERVER

-- Global callback event system, responsible for managing callbacks from C++ to Lua.
-- Copyright (C) Microsoft. All rights reserved.

global g_eventTypes:table = table.makeAutoEnum
	{
		-- AI events
		"musketeerOrderGivenEvent",
		"slipSpaceSpawnSquadGroupCompletedEvent",
		"actorDeletedEvent",
		"squadDeletedEvent",
		"virtualSquadDeletedEvent",
		"virtualSquadHydratedEvent",
		"virtualSquadDehydratedEvent",
		"virtualActorDeletedEvent",
		"squadSpawnerCreatedVirtualSquad",
		"spawnerSpawned",
		"unitFromSpawnerDeathEvent",
		"squadFromSpawnerWipedEvent",
		"dialogueStateTableRefreshEvent",
		-- Encounter events
		"encounterInitialize",
		"encounterStart",
		"encounterPreActivate",
		"encounterPostActivate",
		"encounterPreDeactivate",
		"encounterPostDeactivate",
		"encounterPreRelease",
		-- Engine events
		"teamAddedEvent",
		"vignetteEventCallback",
		"showFinishedEvent",
		"showDeletedEvent",
		"mapIntroFinishedEvent",
		"networkedPropertyDeletedEvent",
		"navpointDeletedEvent",
		"objectiveDeletedEvent",
		"medalAwardedEvent",
		"highlightEvent",
		"roundPreStartEvent",
		"roundStartEvent",
		"roundStartGameplayEvent",
		"roundPreEndEvent",
		"roundEndEvent",
		"enteredBetweenRoundStateEvent",
		"gamePreEndEvent",
		"gameEndEvent",
		"notifyServerShutdownEvent",
		"scriptWorldCenterChanged",
		"timerExpiredEvent",
		"gameplayCompleteEvent",
		"playOfTheGameEvent",
		"teamOutroStartEvent",
		"teamOutroEndEvent",
		"matchFlowIntroEndedEvent",
		"mapFlybyIntroStartEvent",
		-- Campaign map events
		"campaignMapOpenedEvent",
		"campaignMapClosedEvent",
		"campaignMapSetWaypointEvent",
		"campaignMapSetFastTravelEvent",
		"campaignMapStartMissionEvent",
		-- StateEvents
		"stateChanged",
		"boolStateChanged",
		"shortStateChanged",
		"longStateChanged",
		"stringIdStateChanged",
		"playerBoolStateChanged",
		"playerShortStateChanged",
		"playerLongStateChanged",
		"playerStringIdStateChanged",
		-- Object events
		"objectCreatedEvent",
		"objectDeletedEvent",
		"objectBeingDeletedByKillVolume",
		"deathEvent",
		"objectDamagedEvent",
		"objectDamageAccelerationEvent",
		"objectAttackedEvent",
		"manCannonLaunchedObjectEvent",
		"prometheanArmorRepairEvent",
		"spartanTrackingPingObjectEvent",
		"objectInteractEvent",
		"deviceTouchedEvent",
		"deviceDispensedEvent",
		"deviceInteractionStartedEvent",
		"deviceInteractionFinishedEvent",
		"deviceInteractionInterruptedEvent",
		"deviceInteractionReleasedEvent",
		"deviceDispenserComponentChildDetachedEvent",
		"deviceDispenserComponentChildStateUpdated",
		"objectFrameCreatedEvent",
		"objectFrameAttachmentCreatedEvent",
		"objectFrameAttachmentAttachedEvent",
		"objectFrameAttachmentReplenishedEvent",
		"objectFrameAttachmentDeletedEvent",
		"equipmentAbilityControlStateChanged",
		"equipmentSpawnedObjectControlStateChanged",
		"objectActionEvent",
		"phantomEnteredEvent",
		"phantomExitedEvent",
		"unitCrouchEvent",
		-- Player events
		"playerAddedEvent",
		"playerSimulationStartedEvent",
		"playerActiveInGameEvent",
		"playerSpawnEvent",
		"playerSpawnProtectionStart",
		"playerSpawnProtectionEnd",
		"playerRemovedEvent",
		"playerPostRemovedEvent",
		"playerChangedIndexEvent",
		"playerChangedTeamEvent",
		"playerChangedMultiplayerSquadEvent",
		"playerChangedLevelEvent",
		"playerPowerFramePointsChangedEvent",
		"playerPowerFrameRequestHandledEvent",
		"playerShieldsLowEvent",
		"playerSpottedTargetEvent",
		-- Mount events
		"seatEnteredEvent",
		"seatExitedEvent",
		"mountEnteredEvent",
		"mountExitedEvent",
		"mountUpsideDownEvictEvent",
		"vehicleJacked",
		-- Weapon events
		"weaponPadSlotStateChangedEvent",
		"playerWeaponSwapEvent",
		"weaponPickupEvent",
		"weaponPickupAtPadEvent",
		"weaponPickupForAmmoRefillEvent",
		"weaponDropEvent",
		"weaponOutOfAmmoEvent",
		"weaponLowAmmoEvent",
		"weaponThrowEvent",
		"weaponAddedToInventory",
		-- Equipment events
		"grenadePickupEvent",
		"grenadeThrowEvent",
		"grenadeDropEvent",
		"equipmentPickupEvent",
		"equipmentAbilityActivateEvent",
		"equipmentAbilityDeactivateEvent",
		"equipmentAbilityEnergyExhaustedCallback",
		"spartanAbilityEnergyExhaustedCallback",
		"spartanAbilityStateChangedCallback",
		"grappleHookReelInItemInitiatedCallback",
		"grapplePullEnded",
		"grappleHookImpactEvent",
		"playerUsedEquipment",
		-- Streaming events
		"streamingScriptActivate",
		"streamingScriptDeactivate",
		-- Activation volume events
		"activationVolumeVicinityEnteredEvent",
		"activationVolumeEnteredEvent",
		"activationVolumeExitedEvent",
		"activationVolumeVicinityExitedEvent",
		"activationVolumeVicinityPlayerEnteredEvent",
		"activationVolumePlayerEnteredEvent",
		"activationVolumePlayerExitedEvent",
		"activationVolumeVicinityPlayerExitedEvent",
		"activationVolumeCameraEnteredEvent",
		"activationVolumeCameraExitedEvent",

		-- Air drop events
		"airDropCargoDelivered",
		"airDropFlightCompleted",
		"airDropFlightInterrupted",

		-- Supply lines events
		"supplyLinesSendSmallCargo",
		"supplyLinesDropIncoming",
		"supplyLinesDropFailed",
		"supplyLinesVehicleDelivered",
		"supplyLinesSalvageCollected",

		-- Equipment Manager events
		"equipmentUpgradeEvent",

		-- Immediate Execution events (be careful!!)
		"hsInitializeForNewMapServer",

		"roundStartEventImmediate",
		"roundOutcomeRecordedEventImmediate",
		"roundEndEventImmediate",
		"gameEndEventImmediate",
		"levelEndEventImmediate",

		"playerAddedEventImmediate",
		-- Parcel events
		"parcelInitialized",
		"parcelRun",
		"parcelStop",
		"parcelEnd",

		--player objective events
		"missionObjectiveChanged",
		"missionTrackingObjectChanged",

		--Waypoint Events
		"waypointActivatorCreated",
		"waypointActivatorDestroyed",

		--poi events
		"poiStreamedIn",
		"poiEntered",
		"poiIntroCompleted",
		"poiExited",
		"poiStreamedOut",

		-- Warming up events
		"warmingUpEndServerCallback",

		-- Communication object events
		"communicationObjectPowerUpdated",
		"communicationObjectControlUpdated",
		"communicationObjectOwnershipUpdated",
		"communicationObjectPinged",
		"communicationObjectRelayObject",

		-- Communication Node events
		"communicationNodeConnectRequest",

		-- Player Pinging System
		"playerCalloutEvent",

		-- Narrative System
		"narrativeMomentActivated",
		"narrativeMomentDeactivated",
		"narrativeMomentBeatActivated",
		"narrativeMomentBeatDeactivated",

		-- FOB Vehicle Selection
		"fobVehicleSelectionOpened",
		"fobVehicleSelectionClosed",
		"fobVehicleSelectionCommit",
		"fobVehicleSelectionCancel",
		"fobVehicleSelectionNext",
		"fobVehicleSelectionPrevious",
		"fobVehicleSelectionUp",
		"fobVehicleSelectionDown",

		-- Audio Log  event
		"audioLogPlayRequested",
		"dialogWindowDismissed",

		-- MP Personal AI
		"personalAIDeployed",
		"personalAIRecalled",
		"personalAIAnimationStarted",
		"personalAIAnimationInterrupted",
		"personalAIAnimationCompleted",

		"triggerMedalEvent",
		"preLevelTransition",
		"preLevelTransitionFadeIn",

		"onScriptFileUnloaded"
	};

--[[
	g_callbackEventTable
	This table maps events, object indices, and callbacks together.

	g_callbackEventTable maps EventTypes -> EventMaps.
	EventMaps map items (usually objects) -> Callbacks.
	They also have a special .AllItems field. This callback will be used
	whenever anyone registers with a nil item. It will be called whenever
	that event is issued for any item.

	Callbacks can take any number of parameters, CallEvent passes along any
	extra parameters.
--]]

global g_callbackEventTable:table = {};

-- Global used to represent "Always call this event regardless of which item it
-- occured on"
global g_allItems:string = "AllItems";

-- Global used to represent the special string that signifies a callback table in the filter logic
global eventFilterCallbackString:string_id = get_string_id_from_string("specialCallbackString");



--hstructs that are used in the event system
hstructure MultipleOnItemArgs
	onItems:table; -- the table of extra onItem items, like a volume or parcel
end

hstructure EventFilterArgs
	func:ifunction; -- the filter function
	args:table;	-- the table of arguments for the filter function
end

hstructure EventCallbackArgs
	callback:ifunction;				-- the callback function
	firstArgument:any;				-- (optional) forces this to be the first argument for the callback function (used for defining parcels or object class instances)
	extraParams:table;				-- the table of arguments for the callback function
	eventType:any;					-- the event (probably a number)
	unregisterFunction:ifunction;	-- this function is called when a callback is fired (used to unregister the function)
	item:any;						-- the onItem (used to unregister itself)
end

function IsStateBrokerEvent(eventType)
	return eventType == g_eventTypes.boolStateChanged or
			eventType == g_eventTypes.shortStateChanged or
			eventType == g_eventTypes.longStateChanged or
			eventType == g_eventTypes.stringIdStateChanged or 
			eventType == g_eventTypes.playerBoolStateChanged or
			eventType == g_eventTypes.playerShortStateChanged or
			eventType == g_eventTypes.playerLongStateChanged or 
			eventType == g_eventTypes.playerStringIdStateChanged;
end

function GetRegisterCallbackAssertsDisabled():boolean
	if (_G["RegisterCallbackAssertsDisabled"] ~= nil and _G["RegisterCallbackAssertsDisabled"] == true) then
		return true;
	end

	return false;
end


--function that creates a multiple onItem struct
function BuildMultipleOnItemStruct(...):MultipleOnItemArgs
	--make a struct with the first item in the array as the first onItem
	--and the corresponding items in the array to be the rest of the onItems
	return hmake MultipleOnItemArgs
		{
			onItems = arg,
		};
end

function UnregisterMyCallback(eventStruct:EventCallbackArgs)
	UnregisterEvent(eventStruct.eventType, eventStruct.callback, eventStruct.item);
end

--register functions
function RegisterEvent(eventType, callback:ifunction, onItem, ...):void
	CommonRegisterFunction(nil, nil, eventType, callback, onItem, ...);
end

function RegisterEventOnce(eventType, callback:ifunction, onItem, ...):void
	CommonRegisterFunction(nil, UnregisterMyCallback, eventType, callback, onItem, ...);
end


function RegisterGlobalEvent(eventType:number, callback:ifunction, ...):void
	RegisterEvent(eventType, callback, g_allItems, ...);
end

function RegisterGlobalEventOnce(eventType:number, callback:ifunction, ...):void
	RegisterEventOnce(eventType, callback, g_allItems, ...);
end


--class callback functions
function RegisterClassCallback(classInstance, eventType, callback:ifunction, onItem, ...):void
	--if the classInstance is an object or kit with an hstruct, then register the event on itself
	if type(classInstance) == "struct" and (GetEngineType(classInstance) == "object" or GetEngineType(classInstance) == "folder" ) then
		classInstance:RegisterEventOnSelf(eventType, callback, onItem, ...);
	else
		CommonRegisterFunction(classInstance, nil, eventType, callback, onItem, ...);
	end
end

function RegisterClassCallbackOnce(classInstance, eventType, callback:ifunction, onItem, ...):void
	--if the classInstance is an object or kit with an hstruct, then register the event on itself
	if type(classInstance) == "struct" and (GetEngineType(classInstance) == "object" or GetEngineType(classInstance) == "folder" ) then
		classInstance:RegisterEventOnceOnSelf(eventType, callback, onItem, ...);
	else
		CommonRegisterFunction(classInstance, UnregisterMyCallback, eventType, callback, onItem, ...);
	end
end

function RegisterGlobalClassCallback(classInstance, eventType, callback:ifunction, ...):void
	 RegisterClassCallback(classInstance, eventType, callback, g_allItems, ...);
end

function RegisterGlobalClassCallbackOnce(classInstance, eventType, callback:ifunction, ...):void
	 RegisterClassCallbackOnce(classInstance, eventType, callback, g_allItems, ...);
end

function CommonRegisterFunction(firstCallbackArgument, unregisterFunction:ifunction, eventType, callback:ifunction, onItem, ...):void
	assert(onItem ~= nil, "Trying to register on a nil onItem.");
	assert(
		type(eventType) == "string" or
		eventType > 0 and eventType <= g_eventTypes.count, "Invalid eventType " .. eventType);
	assert(callback ~= nil, "Received a nil callback.");

	-- Make sure table is initialized for this event
	g_callbackEventTable[eventType] = g_callbackEventTable[eventType] or {};
	local eventTable:table = g_callbackEventTable[eventType];
	local registeredCallbacks:table = nil;
	local itemKey = onItem;
	--if onItem type is EventFilterArgs then add .filters and add itemKey as value in filters
	if type(onItem) == "struct" and struct.name(onItem) == "EventFilterArgs" then
		registeredCallbacks = RegisterFilterOnItem(eventTable, onItem, arg);
	elseif type(onItem) == "struct" and struct.name(onItem) == "MultipleOnItemArgs" then
		registeredCallbacks = RegisterMultipleOnItems(eventType, eventTable, onItem);
	else
		--onItem is a regular onItem
		itemKey = onItem;

		-- keys that are strings may need to be converted to string ids
		itemKey = ResolveStateBrokerStrings(itemKey, eventType);

		eventTable[itemKey] = eventTable[itemKey] or {};
		registeredCallbacks = eventTable[itemKey];

		-- Register for state change events
		RegisterStateBrokerListeningEvents(itemKey, eventType);
	end

	-- This guarantees the same function only registers once for a call per item.
	if (registeredCallbacks[callback] ~= nil) then
		print("ERROR: Event: tried to register a callback function twice: key=" .. imguiVars.GetFormattedString(itemKey) .. ", type=" .. imguiVars.GetFormattedString(eventType));
		if (GetRegisterCallbackAssertsDisabled() == false) then
			assert(false, "Event: tried to register a callback function twice");
		end
	end

	registeredCallbacks[callback] = hmake EventCallbackArgs
		{
			callback = callback,
			firstArgument = firstCallbackArgument,
			extraParams = arg,

			eventType = eventType,
			unregisterFunction = unregisterFunction,
			item = itemKey,
		};
end

function RegisterFilterOnItem(eventTable:table, onItem:EventFilterArgs, callbackArgumentTable:table):table
	eventTable.filters = eventTable.filters or {};

	--removing the n key that gets automatically applied to ellipses by Lua
	onItem.args.n = nil;

	eventTable.filters[onItem.func] = eventTable.filters[onItem.func] or {};

	--create the table heirarchy with each filterFunc argument being a key with a value of a table with the next argument
	--for example: if the filterFunc's arguments are "foo" and "bar" then the table will look like
	--{
	--	filterFunc =
	--		{
	--			foo =
	--				{
	--					bar =
	--						{}
	--				},
	--		}
	--}
	local filterFunctionArgumentTable:table = eventTable.filters[onItem.func];
	for _, filterArg in ipairs(onItem.args) do
		filterFunctionArgumentTable[filterArg] = filterFunctionArgumentTable[filterArg] or {};
		filterFunctionArgumentTable = filterFunctionArgumentTable[filterArg];
	end

	--attach the callback function
	filterFunctionArgumentTable[eventFilterCallbackString] = filterFunctionArgumentTable[eventFilterCallbackString] or {};

	--removing the n key that gets automatically applied to ellipses by Lua
	callbackArgumentTable.n = nil;

	return filterFunctionArgumentTable[eventFilterCallbackString];
end

function RegisterMultipleOnItems(eventType, eventTable:table, onItem:MultipleOnItemArgs):table
	--if multiple onItems then loop through and make table of items
	for _, onItem in ipairs(onItem.onItems) do

		local itemKey = onItem;

		-- keys that are strings may need to be converted to string ids
		itemKey = ResolveStateBrokerStrings(itemKey, eventType);

		eventTable[itemKey] = eventTable[itemKey] or {};
		eventTable = eventTable[itemKey];

		RegisterStateBrokerListeningEvents(itemKey, eventType);
	end
	return eventTable;
end

function UnregisterGlobalEvent(eventType:number, callback:ifunction):void
	UnregisterEvent(eventType, callback, g_allItems);
end

function UnregisterEvent(eventType, callback:ifunction, onItem):void
	assert(onItem ~= nil, "Trying to unregister on a nil onItem.");
	assert(
		type(eventType) == "string" or
		eventType > 0 and eventType <= g_eventTypes.count, "Invalid eventType " .. eventType);
	assert(callback ~= nil, "Received a nil callback.");

	local itemKey = onItem;

	-- keys that are strings may need to be converted to string ids
	itemKey = ResolveStateBrokerStrings(itemKey, eventType);

	-- If someone is calling unregister for some reason before this table is even initialized, then we don't need to call remove because nothing could have been added
	if g_callbackEventTable[eventType] ~= nil then
		local eventTable:table = g_callbackEventTable[eventType];
		local registeredCallbacks:table = eventTable[itemKey];

		--if the itemKey is not a filter or multipleOnItem hstruct
		if registeredCallbacks ~= nil then
			registeredCallbacks[callback] = nil;

			-- Unregister for state change events
			UnregisterStateBrokerListeningEvents(itemKey, eventType);

			-- If the itemKey no longer has any callbacks associated with it, clear it from the table.
			if table.IsEmpty(registeredCallbacks) == true then
				eventTable[itemKey] = nil;
			end
		elseif type(itemKey) == "struct" and struct.name(itemKey) == "EventFilterArgs" then
			--unregister filters based on callback
			UnregisterFilter(eventTable.filters, itemKey, callback);
			if table.IsEmpty(eventTable.filters) then
				eventTable.filters = nil;
			end
		elseif type(itemKey) == "struct" and struct.name(itemKey) == "MultipleOnItemArgs" then
			--unregister multiple on items
			UnregisterMultipleOnItems(eventType, eventTable, callback, itemKey.onItems);
		end

		--clean up the event table if it's empty
		if table.IsEmpty(g_callbackEventTable[eventType]) == true then
			g_callbackEventTable[eventType] = nil;
		end
	end
end

function CallEventWithOnItemArray(eventType, onItem, eventStruct):void
	assert(eventStruct == nil or type(eventStruct) == "struct", "eventStruct argument passed into CallEventWithOnItemArray is not an hstruct it is "..type(eventStruct));

	-- Only iterate the table if it was initialized by somebody registering a callback
	local eventTable:table = g_callbackEventTable[eventType];
	if eventTable ~= nil then
		IterateTable(eventTable, onItem, eventStruct, true);
	end
end

function CallEvent(eventType, onItem, eventStruct):void
	assert(eventStruct == nil or type(eventStruct) == "struct", "eventStruct argument passed into CallEvent is not an hstruct it is "..type(eventStruct));

	-- Only iterate the table if it was initialized by somebody registering a callback
	local eventTable:table = g_callbackEventTable[eventType];
	if eventTable ~= nil then
		CallNonYieldingFunction(IterateTable, eventTable, onItem, eventStruct, false);
	end
end

function IterateTable(callbackTable:table, onItem, eventStruct, expandOnItemIfTable:boolean):void
	-- Iterate the callback table for the given onItem (if non-nil); CallEventOnTable will guard against supplying a nil callback table.
	-- Note that if onItem is a table (and we were requested to do so), we will do this for each subitem in the onItem table
	if (onItem ~= nil) then
		if (expandOnItemIfTable == true) and (type(onItem) == "table") then
			for _, subOnItem in ipairs(onItem) do
				CallEventOnTable(callbackTable[subOnItem], eventStruct);
			end
		else
			CallEventOnTable(callbackTable[onItem], eventStruct);
		end
	end

	-- Iterate if onItem is associated with an ai squad.
	-- If its nil this will do nothing. This will do nothing for objects
	-- that are dead, they have already been detached from their AI.

	local onItemEngineType:string = GetEngineType(onItem);
	if onItemEngineType == "object" then
		local aiSquad = ai_get_squad(object_get_ai(onItem));
		CallEventOnTable(callbackTable[aiSquad], eventStruct);
	end

	-- Iterate AllItems
	CallEventOnTable(callbackTable[g_allItems], eventStruct);

	-- Iterate filters
	if callbackTable.filters ~= nil then
		--iterate through the filter functions and call functions with args
		for func, args in hpairs(callbackTable.filters) do
			--should we thread somewhere to prevent too many instructions?
			CallCallbacksIfFilterIsTrue(func, eventStruct, args);
		end
	end
end

function CallEventOnTable(onItemTable:table, eventStruct):void
	if onItemTable ~= nil then
		for _, callbackTable in hpairs(onItemTable) do
			--iterate through the table recursively and if the value is an EventCallbackArgs then CallCallbackFunction
			if type(callbackTable) == "struct" and struct.name(callbackTable) == "EventCallbackArgs" then
				CallCallbackFunction(callbackTable, eventStruct);
			elseif type(callbackTable) == "table" then
				CallEventOnTable(callbackTable, eventStruct);
			end
		end
	end
end


function CallCallbacksIfFilterIsTrue(filterFunc:ifunction, eventStruct, args:table, ...):void
	--iterate through all arguments of the filter function and call callbacks with appropriate arguments
	for arg, moreArgTable in hpairs(args) do
		if arg == eventFilterCallbackString then
			--if the filterFunc is true then call the callback with the eventArgs (should be a struct)
			-- and then the args
			local filterFuncResult:boolean = false;
			if eventStruct ~= nil then
				filterFuncResult = filterFunc(eventStruct, unpack(table.reverseArray({...})));
			else
				filterFuncResult = filterFunc(unpack(table.reverseArray({...})));
			end

			--reversing the array of filter args because the only way to add to ellipses is on the front
			if filterFuncResult == true then
				CallEventOnTable(moreArgTable, eventStruct);
			end
		else
			--recursively go through the arguments and find any callbacks there
			CallCallbacksIfFilterIsTrue(filterFunc, eventStruct, moreArgTable, arg, ...);
		end
	end
end

function CallCallbackFunction(callbackTable:EventCallbackArgs, eventStruct):void
	--if unregisterFunction is not nil, then call that function
	if callbackTable.unregisterFunction ~= nil then
		callbackTable.unregisterFunction(callbackTable);
	end
	--call the callback with the eventStruct followed by the extra params
	if eventStruct ~= nil then
		if callbackTable.firstArgument ~= nil then
			callbackTable.callback(callbackTable.firstArgument, eventStruct, unpack(callbackTable.extraParams));
		else
			callbackTable.callback(eventStruct, unpack(callbackTable.extraParams));
		end
	else
		--unless there is no eventStruct, then just pass in the extraParams (like in RoundEndCallback)
		if callbackTable.firstArgument ~= nil then
			callbackTable.callback(callbackTable.firstArgument, unpack(callbackTable.extraParams));
		else
			callbackTable.callback(unpack(callbackTable.extraParams));
		end
	end
end

function BuildEventFilter(filterFunc:ifunction, ...):EventFilterArgs
	assert(filterFunc ~= nil, "filterFunc in BuildEventFilter is nil, a function is required in BuildEventFilter");
	return hmake EventFilterArgs
	{
		func = filterFunc,
		args = arg,
	};
end

--==================================================
--===================== UNREGISTER FUNCTIONS =======
--==================================================

function UnregisterFilter(eventFilterTable:table, filterArgs:EventFilterArgs, callback:ifunction)
	filterArgs.args.n = nil;

	--if there are no arguments to the filter function then clear the table
	if table.IsEmpty(filterArgs.args) then
		eventFilterTable[filterArgs.func][eventFilterCallbackString][callback] = nil;
		if table.IsEmpty(eventFilterTable[filterArgs.func][eventFilterCallbackString]) then
			eventFilterTable[filterArgs.func][eventFilterCallbackString] = nil;
		end
	else
		--walk filterArgs.args recursively and remove the callbackFunc at the end
		--remove the key if the table is empty
		UnregisterFilterHelper(eventFilterTable[filterArgs.func], filterArgs.args, callback);
	end

	if table.IsEmpty(eventFilterTable[filterArgs.func]) then
		eventFilterTable[filterArgs.func] = nil;
	end
end


function UnregisterFilterHelper(filterFuncTable:table, filterFuncArgsArray:table, callback, index:number):void
	index = index or 1;
	assert(filterFuncTable ~= nil,
			"UnregisteringFilter: this filterFuncTable index doesn't exist: "..tostring(filterFuncArgsArray[index - 1]));
	local numKeys:number = #filterFuncArgsArray;
	local tableIndex:table = filterFuncTable[filterFuncArgsArray[index]]
	assert(tableIndex ~= nil,
			"UnregisteringFilter: this filterFuncTable index doesn't exist: "..tostring(filterFuncArgsArray[index]));

	if index == numKeys then
		--if at the end of the chain then nil out the callback and extraParams

		assert(tableIndex[eventFilterCallbackString] ~= nil,
			"UnregisteringFilter: there is no callback to unregister in "..tostring(filterFuncArgsArray[index]));

		tableIndex[eventFilterCallbackString][callback] = nil

		--if there are no more callbacks then nil the eventFilterCallbackString
		if table.IsEmpty(tableIndex[eventFilterCallbackString]) then
			tableIndex[eventFilterCallbackString] = nil;
		end
	else
		UnregisterFilterHelper(tableIndex, filterFuncArgsArray, callback, index + 1);
	end
	if table.IsEmpty(tableIndex) then
		filterFuncTable[filterFuncArgsArray[index]] = nil;
	end

end

function UnregisterMultipleOnItems(eventType, eventTable, callback:ifunction, extraItems:table, index:number):void
	index = index or 1;
	local numArgs:number = #extraItems;
	local extraItemsValue = extraItems[index];
	local itemKey = extraItemsValue;

	itemKey = ResolveStateBrokerStrings(itemKey, eventType);

	UnregisterStateBrokerListeningEvents(itemKey, eventType);

	local tableIndex:table = eventTable[itemKey];

	--if the itemKey hasn't been garbage collected then find the correct items to unregister
	if tableIndex ~= nil then
		if index == numArgs then
			tableIndex[callback] = nil;
		else
			UnregisterMultipleOnItems(eventType, tableIndex, callback, extraItems, index + 1);
		end
		if table.IsEmpty(tableIndex) == true then
			eventTable[itemKey] = nil;
		end
	end
end

-------------------------------------------------
-- StateBroker Helper Functions --
-------------------------------------------------
function ResolveStateBrokerStrings(itemKey:any, eventType)
	if type(itemKey) == "string" and IsStateBrokerEvent(eventType) then
		itemKey = Engine_ResolveStringId(itemKey);
	end
	return itemKey;
end

function RegisterStateBrokerListeningEvents(itemKey:any, eventType)
	if GetEngineType(itemKey) == "string_id" then
		if eventType == g_eventTypes.boolStateChanged then
			StateBroker_RegisterListenerForStateChanges(itemKey, STATE_TYPE.BooleanValue);
		elseif eventType == g_eventTypes.shortStateChanged then
			StateBroker_RegisterListenerForStateChanges(itemKey, STATE_TYPE.ShortValue);
		elseif eventType == g_eventTypes.longStateChanged then
			StateBroker_RegisterListenerForStateChanges(itemKey, STATE_TYPE.LongValue);
		elseif eventType == g_eventTypes.stringIdStateChanged then
			StateBroker_RegisterListenerForStateChanges(itemKey, STATE_TYPE.StringIdValue);
		elseif eventType == g_eventTypes.playerLongStateChanged then
			StateBroker_RegisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.LongValue);
		elseif eventType == g_eventTypes.playerBoolStateChanged then
			StateBroker_RegisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.BooleanValue);
		elseif eventType == g_eventTypes.playerShortStateChanged then
			StateBroker_RegisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.ShortValue);
		elseif eventType == g_eventTypes.playerStringIdStateChanged then 
			StateBroker_RegisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.StringIdValue);
		end
	end
end

function UnregisterStateBrokerListeningEvents(itemKey:any, eventType)
	-- keys that are strings may need to be converted to string ids
	if GetEngineType(itemKey) == "string_id" then
		if eventType == g_eventTypes.boolStateChanged then
			StateBroker_UnregisterListenerForStateChanges(itemKey, STATE_TYPE.BooleanValue);
		elseif eventType == g_eventTypes.shortStateChanged then
			StateBroker_UnregisterListenerForStateChanges(itemKey, STATE_TYPE.ShortValue);
		elseif eventType == g_eventTypes.longStateChanged then
			StateBroker_UnregisterListenerForStateChanges(itemKey, STATE_TYPE.LongValue);
		elseif eventType == g_eventTypes.stringIdStateChanged then
			StateBroker_UnregisterListenerForStateChanges(itemKey, STATE_TYPE.StringIdValue);
		elseif eventType == g_eventTypes.playerLongStateChanged then
			StateBroker_UnregisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.LongValue);
		elseif eventType == g_eventTypes.playerBoolStateChanged then
			StateBroker_UnregisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.BooleanValue);
		elseif eventType == g_eventTypes.playerShortStateChanged then
			StateBroker_UnregisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.ShortValue);
		elseif eventType == g_eventTypes.playerStringIdStateChanged then 
			StateBroker_UnregisterListenerForPerPlayerStateChanges(itemKey, STATE_TYPE.StringIdValue);
		end
	end
end
-------------------------------------------------
-- Registration for Immediate Execution events --
-------------------------------------------------

global g_immediateEventRegistrationServerFunctions = {};

function RegisterImmediateExecutionStartupServerEvents():void
	for funcName, func in hpairs(g_immediateEventRegistrationServerFunctions) do
		if (type(func) == "function") then
			dprint("Calling immediate execution registration function: ", funcName);
			func();
		else
			print("GlobalCallbackSystem error: non-function item was found on the g_immediateEventRegistrationServerFunctions table!");
		end
	end
end


-----------------------------------
-- ObjectNodeGraph Lua interface --
-----------------------------------

function ObjectNodeGraph_OnRegisteredEvent(event, node:node_graph_node, data:node_graph_instance_data): void
	ObjectNodeGraph_NotifyRegisterEventNode(node, data);
end


function ObjectNodeGraph_RegisterEvent(event:string, obj:object, node:node_graph_node, data:node_graph_instance_data): void
	RegisterEvent(g_eventTypes[event], ObjectNodeGraph_OnRegisteredEvent, obj, node, data);
end


--## CLIENT
global g_immediateEventRegistrationClientFunctions = {};

function RegisterImmediateExecutionStartupClientEvents():void
	for funcName, func in hpairs(g_immediateEventRegistrationClientFunctions) do
		if (type(func) == "function") then
			dprint("Calling immediate execution registration function: ", funcName);
			func();
		else
			print("GlobalCallbackSystem error: non-function item was found on the g_immediateEventRegistrationClientFunctions table!");
		end
	end
end
--## SERVER

-----------------------------
-- Event Garbage Collector --
-----------------------------

-- This mainly exists for testing purposes. Do not disable this unless you know what you're doing.
global g_eventGarbageCollectorEnabled = true;

global g_destroyedObjects = {};
global g_eventGarbageCollectorThread = nil;

function RequestEventGarbageCollectionForObject(destroyedObject):void
	if g_eventGarbageCollectorEnabled and destroyedObject ~= nil then
		if g_eventGarbageCollectorThread == nil then
			g_eventGarbageCollectorThread = CreateThread(RequestEventGarbageCollectionThread);
		end

		g_destroyedObjects[destroyedObject] = Game_GetUpdateCounter();
	end
end

function RequestEventGarbageCollectionThread():void
	repeat
		local currentCounter:number = Game_GetUpdateCounter();
		for destroyedObject, counter in pairs(g_destroyedObjects) do

			-- Delay destruction until the next frame so any post-delete events can fire first.
			if currentCounter > counter then
				ClearItemFromTable(destroyedObject);
				g_destroyedObjects[destroyedObject] = nil;
			end
		end

		Sleep(1);
	until false;
end

function ClearItemFromTable(destroyedObject):void
	for eventType, eventTable in hpairs(g_callbackEventTable) do
		-- clear events whose onItem is the destroyedObject
		if eventTable[destroyedObject] ~= nil then
			eventTable[destroyedObject] = nil;
		end

		-- Check the event actually exists in the table so we aren't inserting a nil entry when it doesn't even exist.
		-- This prevents a large memory spike from occuring when many objects get destroyed.
		if g_callbackEventTable[eventType] ~= nil and table.IsEmpty(g_callbackEventTable[eventType]) == true then
			g_callbackEventTable[eventType] = nil;
		end
	end
end

--global function for adding parameters to the event string
--This is to make more possible parameters to events like storing a volume and player to check the volume events
function EventStringConcatenate(eventString:string, ...):string
	--arg is a Lua feature that is a table of the arugments from the elipsis(...)
	local additionalParameterTable = arg;
	local concatenatedString = eventString;
	for _, param in ipairs (additionalParameterTable) do
		concatenatedString = concatenatedString..tostring(param);
	end
	return concatenatedString;
end

-- Callback from the game when an object is destroyed. DO NOT TOUCH UNLESS YOU
-- KNOW WHAT YOU'RE DOING.
function global_object_event_destroyed(destroyedObject:object)
	-- Purge the deleted object from our tables.
	-- destroyedObject will be nil if this object was never referenced by Lua.
	if (destroyedObject ~= nil) then
		RequestEventGarbageCollectionForObject(destroyedObject);
	end
end
