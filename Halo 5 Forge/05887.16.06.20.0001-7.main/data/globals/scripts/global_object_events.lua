--## SERVER

-- Global object event system, responsible for managing events attached to objects.
-- Copyright (C) Microsoft. All rights reserved.


--[[
	g_objectEventTable
	This table maps events, object indices, and callbacks together.
	
	g_objectEventTable maps EventTypes -> EventMaps.
	EventMaps map items (usually objects) -> Callbacks.
	They also have a special .AllItems field. This callback will be used
	whenever anyone registers with a nil item. It will be called whenever
	that event is issued for any item.
	
	Callbacks can take any number of parameters, CallEvent passes along any
	extra parameters.
--]]
global g_objectEventTable:table = {};

-- Global used to represent "Always call this event regardless of which item it
-- occured on"
global g_allItems:string = "AllItems";

global g_firstEvent:number = 1;

-- Called from game whenever an object dies.
-- (deadObject:object, killerObject:object)
global g_deathEvent:number = 1;

-- Called from game when an object is interacted with. This might not be called for
-- every case you expect if you need this fired for another interaction, ask a programmer.
-- (interactee:object, interacter:object)
global g_interactEvent:number = 2;

-- Called from the game when a knight taint should be initialized.
-- (knightTaint:object, taskIndex:number)
global g_initKnightTaintEvent:number = 3;

-- Called from the game when a player is spawned.
-- (player:object)
global g_playerSpawnEvent:number = 4;

-- Called from the game when an object is launched by a man cannon.
-- (manCannon:object,launchedObject:object)
global g_manCannonLaunchedObjectEvent:number = 5;

-- Called from script for scripty purposes.
-- Takes any amount of variable parameters.
global g_scriptEvent:number = 6;

-- Called when a musketeer is given an order
-- (Once per musketeer who is following the order)
global g_musketeerOrderGivenEvent:number = 7;

-- Called when a bishop repairs a Prometheans's armor
global g_prometheanArmorRepairEvent:number = 8;

-- Called when a Spartan pings an object with a tracking device
global g_spartanTrackingPingObjectEvent:number = 9;

-- SET g_lastEvent to the last sequential event!
global g_lastEvent:number = g_spartanTrackingPingObjectEvent;

-- Initialize event table:
-- 		For each EventType create an empty table of callbacks.
for i = g_firstEvent, g_lastEvent do
	g_objectEventTable[i] = {};
end

--[[

  _                   _____       _            __              
 | |                 |_   _|     | |          / _|             
 | |    _   _  __ _    | |  _ __ | |_ ___ _ _|_|_ __ _  ___ ___ 
 | |   | | | |/ _` |   | | | '_ \| __/ _ \ '__/ _| _` |/ __/ _ \
 | |___| |_| | (_| |  _| |_| | | | ||  __/ | | || (_| | (_|  __/
 |______\__,_|\__,_| |_____|_| |_|\__\___|_| |_| \__,_|\___\___|
                                                             
                                                            
]]--

function RegisterDeathEvent(callback:ifunction, onItem, ...):void
	RegisterEvent(g_deathEvent, callback, onItem, ...);
end

function UnregisterDeathEvent(callback:ifunction, onItem):void
	UnregisterEvent(g_deathEvent, callback, onItem);
end

function RegisterInteractEvent(callback:ifunction, onItem, ...):void
	RegisterEvent(g_interactEvent, callback, onItem, ...);
end

function UnregisterInteractEvent(callback:ifunction, onItem):void
	UnregisterEvent(g_interactEvent, callback, onItem);
end

function RegisterInitKnightTaintEvent(callback:ifunction, onItem, ...):void
	RegisterEvent(g_initKnightTaintEvent, callback, onItem, ...);
end

function UnregisterInitKnightTaintEvent(callback:ifunction, onItem):void
	UnregisterEvent(g_initKnightTaintEvent, callback, onItem);
end

function RegisterPlayerSpawnEvent(callback:ifunction, ...):void
	RegisterEvent(g_playerSpawnEvent, callback, nil, ...);
end

function UnregisterPlayerSpawnEvent(callback:ifunction):void
	UnregisterEvent(g_playerSpawnEvent, callback, nil);
end

function RegisterManCannonLaunchedObjectEvent(callback:ifunction, onItem, ...):void
	RegisterEvent(g_manCannonLaunchedObjectEvent, callback, onItem, ...);
end

function UnregisterManCannonLaunchedObjectEvent(callback:ifunction, onItem):void
	UnregisterEvent(g_manCannonLaunchedObjectEvent, callback, onItem);
end

function RegisterScriptEvent(callback:ifunction, ...):void
	RegisterEvent(g_scriptEvent, callback, nil, ...);
end

function UnregisterScriptEvent(callback:ifunction):void
	UnregisterEvent(g_scriptEvent, callback, nil);
end

function RegisterMusketeerOrderEvent(callback:ifunction, ...):void
	RegisterEvent(g_musketeerOrderGivenEvent, callback, nil, ...);
end

function UnregisterMusketeerOrderEvent(callback:ifunction):void
	UnregisterEvent(g_musketeerOrderGivenEvent, callback, nil);
end

function RegisterPrometheanArmorRepairEvent(callback:ifunction, ...):void
	RegisterEvent(g_prometheanArmorRepairEvent, callback, nil, ...);
end

function UnregisterPrometheanArmorRepairEvent(callback:ifunction):void
	UnregisterEvent(g_prometheanArmorRepairEvent, callback, nil);
end

function RegisterSpartanTrackingPingObjectEvent(callback:ifunction, onItem, ...):void
	RegisterEvent(g_spartanTrackingPingObjectEvent, callback, onItem, ...);
end

function UnregisterSpartanTrackingPingObjectEvent(callback:ifunction, onItem):void
	UnregisterEvent(g_spartanTrackingPingObjectEvent, callback, onItem);
end

function RegisterAIDeathEvent(callback:ifunction, aiSquad:ai, livingSquadCountToCallback:number, ...)
	
	-- Default to all the AI dying
	if (livingSquadCountToCallback == nil) then
		livingSquadCountToCallback = 0;
	end

	RegisterDeathEvent(OnRegisterAIDeathEventDeath, aiSquad, callback, aiSquad, livingSquadCountToCallback, ...);
end

function OnRegisterAIDeathEventDeath(deadObject:object, killerObject:object, callback:ifunction, aiSquad:ai, livingSquadCountToCallback:number, ...)

	-- Did enough AI die to satisfy our requirements?
	if (list_count_not_dead(ai_actors(aiSquad)) <= livingSquadCountToCallback) then

		-- Stop us from getting anymore callbacks. And then call the client callback.
		UnregisterDeathEvent(OnRegisterAIDeathEventDeath, aiSquad);
		callback(deadObject, killerObject, ...);
	end
end

--[[
______                 ______                _   _                   _ _ _         
| ___ \                |  ___|              | | (_)                 | (_) |        
| |_/ / __ _ ___  ___  | |_ _   _ _ __   ___| |_ _  ___  _ __   __ _| |_| |_ _   _ 
| ___ \/ _` / __|/ _ \ |  _| | | | '_ \ / __| __| |/ _ \| '_ \ / _` | | | __| | | |
| |_/ / (_| \__ \  __/ | | | |_| | | | | (__| |_| | (_) | | | | (_| | | | |_| |_| |
\____/ \__,_|___/\___| \_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|\__,_|_|_|\__|\__, |
                                                                              __/ |
                                                                             |___/ 
																			 
--]]


-- Returns the key used in the map for the given item.
function GetItemKey(item)
	if (item == nil) then
		item = g_allItems;
	end

	return item;
end

-- Gets the table represented by key from parentTable, adds a table and returns
-- it if one does not exist.
function GetOrAddCallbackTable(parentTable:table, key):table
	local retTable:table = parentTable[key];

	if (retTable == nil) then
		retTable = {};
		parentTable[key] = retTable;
	end	

	return retTable;
end

function RegisterEvent(eventType:number, callback:ifunction, onItem, ...):void
	RegisterEventOnTable(g_objectEventTable[eventType], callback, onItem, ...);
end

function RegisterEventOnTable(eventTable:table, callback:ifunction, onItem, ...):void
	local itemKey = GetItemKey(onItem);

	local registeredCallbacks:table	= GetOrAddCallbackTable(eventTable, itemKey);
	
	-- This guarantees the same function only registers once for a call per item.
	registeredCallbacks[callback] = 
	{ 
		["callback"] = callback,
		["extraParams"] = { n=select("#", ...), ... }
	};
end

function UnregisterEvent(eventType:number, callback:ifunction, onItem):void
	UnregisterEventOnTable(g_objectEventTable[eventType], callback, onItem);
end

function UnregisterEventOnTable(eventTable:table, callback:ifunction, onItem):void
	local itemKey = GetItemKey(onItem);

	local registeredCallbacks:table = eventTable[itemKey];
	if (registeredCallbacks ~= nil) then
		 registeredCallbacks[callback] = nil;
	end
end

function CallEvent(eventType:number, onItem, ...):void
	local eventTable:table = g_objectEventTable[eventType];

	IterateTable(eventTable, onItem, CallEventOnTable, ...);
end

function IterateTable(callbackTable:table, onItem, childFunction:ifunction, ...):void
	
	-- Iterate the item. If its nil the table will just pass in nil (which childFunction should ignore).
	childFunction(callbackTable[onItem], ...);

	-- Iterate if onItem is associated with an ai squad.
	-- If its nil this will do nothing. This will do nothing for objects
	-- that are dead, they have already been detached from their AI.
	-- 
	if (GetEngineType(onItem) == "object") then
		local aiSquad = ai_get_squad(object_get_ai(onItem));
		CallEventOnTable(callbackTable[aiSquad], ...);
	end

	-- Iterate AllItems
	childFunction(callbackTable[g_allItems], ...);
end

function CallEventOnTable(registeredCallbacks:table, ...):void
	if (registeredCallbacks ~= nil) then
		for k,callback in pairs(registeredCallbacks) do
			if (callback.extraParams.n == 0) then
				callback.callback(...);
			else
				local numVarArgs:number = select("#", ...);
				local callbackArgs:table = {...};
			
				for i = 1, callback.extraParams.n do
					callbackArgs[numVarArgs + i] = callback.extraParams[i];
				end

				callback.callback(unpack(callbackArgs, 1, numVarArgs + callback.extraParams.n));
			end		
		end
	end
end

--[[
 _____       _ _ _                _           __                       _____            
/  __ \     | | | |              | |         / _|                     /  __ \ _     _   
| /  \/ __ _| | | |__   __ _  ___| | _____  | |_ _ __ ___  _ __ ___   | /  \/| |_ _| |_ 
| |    / _` | | | '_ \ / _` |/ __| |/ / __| |  _| '__/ _ \| '_ ` _ \  | |  |_   _|_   _|
| \__/\ (_| | | | |_) | (_| | (__|   <\__ \ | | | | | (_) | | | | | | | \__/\|_|   |_|  
 \____/\__,_|_|_|_.__/ \__,_|\___|_|\_\___/ |_| |_|  \___/|_| |_| |_|  \____/           
                                                                                         
--]]

-- Callback from the game when any object dies.
function global_object_event_died(deadObject:object, killerObject:object, aiSquad:object, damageModifier:number, damageSource:ui64, damageType:ui64):void

	CallEvent(g_deathEvent, deadObject, deadObject, killerObject, aiSquad, damageModifier, damageSource, damageType);

	-- Death events have to handle AISquads specially because by the time this
	-- is called the object has been removed from the squad.
	CallEventOnTable(g_objectEventTable[g_deathEvent][aiSquad], deadObject, killerObject);
end

-- Callback from the game when any object is interacted with.
function global_object_event_interact(interactee:object, interacter:object)
	CallEvent(g_interactEvent, interactee, interactee, interacter);
end

-- Callback from the game to initialize the knight taint.
function global_object_event_init_knight_taint(knightTaint:object, taskIndex:number)
	CallEvent(g_initKnightTaintEvent, knightTaint, knightTaint, taskIndex);
end

-- Callback from the game when a player spawns.
function GlobalObjectEventPlayerSpawn(player:object)
	CallEvent(g_playerSpawnEvent, nil, player);
end 

-- Callback from the game when an object is launched by the man cannon.
function GlobalObjectEventManCannonLaunchedObject(manCannon:object, launchedObject:object)
	CallEvent(g_manCannonLaunchedObjectEvent, manCannon, manCannon, launchedObject);
end

-- Callback from the game when an order is given to a musketeer.
function GlobalObjectEventMusketeerOrderGiven()
	CallEvent(g_musketeerOrderGivenEvent, nil);
end

-- Callback from the game when a promethean's armor is repaired.
function GlobalObjectEventPrometheanArmorRepairEvent(repairedUnit:object)
	CallEvent(g_prometheanArmorRepairEvent, nil, repairedUnit);
end

-- Callback from the game when an object is pinged by spartan tracking.
function remoteServer.GlobalObjectEventSpartanTrackingPingObjectEvent(pingedObject:object, playerUnit:object)
	CallEvent(g_spartanTrackingPingObjectEvent, pingedObject, playerUnit);
end

-- Callback from the game when an object is destroyed. DO NOT TOUCH UNLESS YOU
-- KNOW WHAT YOU'RE DOING.
function global_object_event_destroyed(destroyedObject:object)
	-- Purge the deleted object from our tables.
	-- destroyedObject will be nil if this object was never referenced by Lua.
	if (destroyedObject ~= nil) then
		for i = g_firstEvent, g_lastEvent do
			g_objectEventTable[i][destroyedObject] = nil;
		end
	end
end

--## CLIENT

-- Spartan Tracking runs on the clients, so this is used to forward callbacks up to the server
function GlobalObjectEventSpartanTrackingPingObjectEvent(pingedObject:object, playerUnit:object)
	RunServerScript("GlobalObjectEventSpartanTrackingPingObjectEvent", pingedObject, playerUnit);
end
