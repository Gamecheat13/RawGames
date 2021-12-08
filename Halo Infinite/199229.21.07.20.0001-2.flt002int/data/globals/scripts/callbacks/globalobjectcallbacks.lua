REQUIRES('globals/scripts/callbacks/GlobalCallbackSystem.lua')

--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Object Created Event
-- Callback from the game when an object is created
-------------------------------------------------------------------------------------------------

hstructure ObjectCreatedStruct
	createdObject:object;
end

-- Callback from C++
function ObjectCreatedCallback(createdObject:object):void
	local eventArgs = hmake ObjectCreatedStruct
		{
			createdObject = createdObject
		};

	CallEvent(g_eventTypes.objectCreatedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Deleted Event
-- Callback from the game when an object is deleted
-------------------------------------------------------------------------------------------------

hstructure ObjectDeletedStruct
	deletedObject:object;
end

-- Callback from C++
function ObjectDeletedCallback(deletedObject:object):void
	local eventArgs = hmake ObjectDeletedStruct
		{
			deletedObject = deletedObject
		};

	CallEvent(g_eventTypes.objectDeletedEvent, deletedObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Being Deleted By Kill Volume Event
-- Callback from the engine when an object has timed out in a kill volume just before it is deleted.
-------------------------------------------------------------------------------------------------

hstructure ObjectBeingDeletedByKillVolumeStruct
	deletedObject:object;
end

function ObjectBeingDeletedByKillVolumeCallback(deletedObject:object):void
	local eventArgs = hmake ObjectBeingDeletedByKillVolumeStruct
		{
			deletedObject = deletedObject
		};

	CallEvent(g_eventTypes.objectBeingDeletedByKillVolume, deletedObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Death Event
-- Callback from the engine when an object dies
-------------------------------------------------------------------------------------------------

hstructure DeathEventStruct
	deadObject:object;
	killerObject:object;
	aiSquad:ai;
	damageModifier:damage_modifier;
	damageSource:ui64;
	damageType:ui64;
	bucketType:campaign_metagame_bucket_type;
	deadPlayer:player;
	killingPlayer:player;
	assistingPlayers:table;
	killingTeam:mp_team;
	damageSourceObject:object;
	killingWeaponObject:object;
end

function RegisterAIDeathEvent(callback:ifunction, aiSquad:ai, livingSquadCountToCallback:number, ...)
	
	-- Default to all the AI dying
	if (livingSquadCountToCallback == nil) then
		livingSquadCountToCallback = 0;
	end

	-- Depending on how the squad was created/received, the passed value may be a
	-- battelgroup parent which we should resolve to a regular squad object
	local squadActors:object_list = ai_actors(aiSquad);
	if #squadActors > 1 then
		aiSquad = ai_get_squad(object_get_ai(squadActors[1]));
	end

	RegisterEvent(g_eventTypes.deathEvent, OnRegisterAIDeathEventDeath, ai_get_squad_index(aiSquad), callback, livingSquadCountToCallback, ...);
end

function OnRegisterAIDeathEventDeath(deathEvent, callback:ifunction, livingSquadCountToCallback:number, ...)
	local aiSquad:ai = deathEvent.aiSquad;
	-- Did enough AI die to satisfy our requirements?
	if (list_count_not_dead(ai_actors(aiSquad)) <= livingSquadCountToCallback) then

		-- Stop us from getting anymore callbacks. And then call the client callback.
		UnregisterEvent(g_eventTypes.deathEvent, OnRegisterAIDeathEventDeath, ai_get_squad_index(aiSquad));
		callback(aiSquad, ...);
	end
end

-- Callback from C++
function global_object_event_died(deadObject:object, killerObject:object, aiSquad:ai, damageModifier:damage_modifier, damageSource:ui64, damageType:ui64, bucketType:campaign_metagame_bucket_type, deadPlayer:player, killingPlayer:player, assistingPlayers, killingTeam:mp_team, damageSourceObject:object, killingWeaponObject:object):void
	local eventArgs = hmake DeathEventStruct
		{
			deadObject = deadObject,
			killerObject = killerObject,
			aiSquad = aiSquad,
			damageModifier = damageModifier,
			damageSource = damageSource,
			damageType = damageType,
			bucketType = bucketType,
			deadPlayer = deadPlayer,
			killingPlayer = killingPlayer,
			assistingPlayers = assistingPlayers,
			killingTeam = killingTeam,
			damageSourceObject = damageSourceObject,
			killingWeaponObject = killingWeaponObject
		};

	CallEvent(g_eventTypes.deathEvent, deadObject, eventArgs);

	-- Death events have to handle AISquads specially because by the time this
	-- is called the object has been removed from the squad.

	if aiSquad == nil then
		return;
	end
	
	local squadActors:object_list = ai_actors(aiSquad);

	SpawnerUnitDiedCallback(aiSquad, deadObject);
	
	-- Call the event on the squad if applicable.
	-- Only process this step if a someone has registered a death event callback

	local deathEventTable:table = g_callbackEventTable[g_eventTypes.deathEvent];
	if deathEventTable ~= nil then
		-- Invoke events registerd with the squad index.
		local squadIndex:ai = ai_get_squad_index(aiSquad);
		if squadIndex ~= nil and deathEventTable[squadIndex] ~= nil then
			CallEventOnTable(deathEventTable[squadIndex], eventArgs);
			-- If the squad is now empty request all associated events be cleaned up.
			if squadActors == nil or #squadActors == 0 then
				RequestEventGarbageCollectionForObject(squadIndex);
			end
		end

		-- Invoke events registerd with the squad itself.
		if deathEventTable[aiSquad] ~= nil then
			CallEventOnTable(deathEventTable[aiSquad], eventArgs);
			-- If the squad is now empty request all associated events be cleaned up.
			if squadActors == nil or #squadActors == 0 then
				RequestEventGarbageCollectionForObject(aiSquad);
			end
		end
	end

	if #squadActors == 0 then
		SpawnerSquadWipedCallback(aiSquad, deadObject);
	end
end


-------------------------------------------------------------------------------------------------
-- All units from a squad have died Callback
-- Called by the game through the death event whenever all units in a squad have died
-------------------------------------------------------------------------------------------------

hstructure SpawnerSquadWipedEventStruct
	virtualSquad:handle;
	squad:ai;
	unit:object;
	spawner:squad_spawner;
end

function SpawnerSquadWipedCallback(squad:ai, deadObject:object)
	SpawnerDiedCallback(g_eventTypes.squadFromSpawnerWipedEvent, "SpawnerSquadWipedEventStruct", squad, deadObject);
end

-------------------------------------------------------------------------------------------------
-- Actor from a Squad from a Spawner death Callback
-- Called by the game through death event whenever a unit dies
-------------------------------------------------------------------------------------------------

hstructure SpawnerActorDeathEventStruct
	virtualSquad:handle;
	squad:ai;
	unit:object;
	spawner:squad_spawner;
end

function SpawnerUnitDiedCallback(squad:ai, deadObject:object)
	SpawnerDiedCallback(g_eventTypes.unitFromSpawnerDeathEvent, "SpawnerActorDeathEventStruct", squad, deadObject);
end


function SpawnerDiedCallback(eventType, structName:string, squad:ai, deadObject:object)
	local eventTable:table = g_callbackEventTable[eventType]
	if eventTable == nil then
		return;
	end

	local virtualSquad =  AI_GetSquadInstanceFromAISquad(squad);
	local squadSpawner = AI_GetSquadSpawnerFromSquadInstance(virtualSquad);
	local eventArgs = struct.create(structName);

	eventArgs.virtualSquad = virtualSquad;
	eventArgs.unit = deadObject;
	eventArgs.squad = squad;
	eventArgs.spawner = squadSpawner;

	CallEvent(eventType, squadSpawner, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Damaged Event
-- Callback from the engine when an object is damaged
-------------------------------------------------------------------------------------------------

hstructure ObjectDamagedEventStruct
	attacker:object;
	defender:object;			
	damageModifier:damage_modifier;
	damageSource:ui64;
	damageType:ui64;
	isAOE:boolean;
	totalDamageInVitalityPoints:number;
	totalMaxVitalityOfDefender:number;
	damageSourceObject:object;
	damageSourceObjectWeapon:object;
end

-- Callback from C++
function GlobalObjectEventObjectDamaged(attacker:object, defender:object, damageModifier, damageSource:ui64, damageType:ui64, isAOE:boolean, totalDamageInVitalityPoints:number, totalMaxVitalityOfDefender:number, damageSourceObject:object, damageSourceObjectWeapon:object)
	local eventArgs = hmake ObjectDamagedEventStruct
		{
			attacker = attacker,
			defender = defender,				
			damageModifier = damageModifier,	
			damageSource = damageSource,	
			damageType = damageType,
			isAOE = isAOE,
			totalDamageInVitalityPoints = totalDamageInVitalityPoints,
			totalMaxVitalityOfDefender = totalMaxVitalityOfDefender,
			damageSourceObject = damageSourceObject,
			damageSourceObjectWeapon = damageSourceObjectWeapon,
		};

	CallEvent(g_eventTypes.objectDamagedEvent, defender, eventArgs);
	CallEvent(g_eventTypes.objectAttackedEvent, attacker, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Damage Acceleration Applied Callback
-- Called by the game whenever an acceleration event caused by damage is applied to an object.
-------------------------------------------------------------------------------------------------
hstructure ObjectDamageAccelerationAppliedEventStruct
	acceleratedObject:	object;
	epicenter:			vector;
	acceleration:		vector;
	damageType:			string_id;
	damageSource:		string_id;
end

-- Callback from C++
function ObjectDamageAccelerationAppliedCallback(acceleratedObject:object, epicenter:vector, acceleration:vector, damageType:string_id, damageSource:string_id)
	local eventArgs = hmake ObjectDamageAccelerationAppliedEventStruct
	{
		acceleratedObject = acceleratedObject,
		epicenter = epicenter,
		acceleration = acceleration,
		damageType = damageType,
		damageSource = damageSource,
	};

	CallEvent(g_eventTypes.objectDamageAccelerationEvent, acceleratedObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Man Cannon Launched Object Callback
-- Callback from the game when an object is launched by a man cannon
-------------------------------------------------------------------------------------------------

hstructure ManCannonEventStruct
	manCannon:object;
	launchedObject:object;
end

-- Callback from C++
function GlobalObjectEventManCannonLaunchedObject(manCannon:object, launchedObject:object)
	local eventArgs = hmake ManCannonEventStruct
		{
			manCannon = manCannon,
			launchedObject = launchedObject,
		};

	CallEvent(g_eventTypes.manCannonLaunchedObjectEvent, manCannon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Promethean Armor Repair Event Callback
-- Callback from the game when an object is launched by a man cannon
-------------------------------------------------------------------------------------------------

hstructure PrometheanArmorRepairEventStruct
	repairedObject:object;
end

-- Callback from C++
function GlobalObjectEventPrometheanArmorRepairEvent(repairedObject:object)
	local eventArgs = hmake PrometheanArmorRepairEventStruct
		{
			repairedObject = repairedObject
		};

	CallEvent(g_eventTypes.prometheanArmorRepairEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Spartan Tracking Ping Object Callback
-- Callback from the game when an object is pinged by spartan tracking
-------------------------------------------------------------------------------------------------

hstructure SpartanTrackingPingEventStruct
	pingedObject:object;
	playerUnit:object;
	pingType:spartan_tracking_ping_type;
	pingGroup:string_id;
end

function GlobalObjectEventSpartanTrackingPingObjectEvent(pingedObject:object, playerUnit:object, pingType:spartan_tracking_ping_type, pingGroup:string_id)
	local eventArgs = hmake SpartanTrackingPingEventStruct
		{
			pingedObject = pingedObject,
			playerUnit = playerUnit,
			pingType = pingType,
			pingGroup = pingGroup,
		};

	Telemetry.Progression.ObjectPinged(playerUnit, pingedObject);
	CallEvent(g_eventTypes.spartanTrackingPingObjectEvent, pingedObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Interact Callback
-- Called from game when an object is interacted with. This might not be called for
-- every case you expect; if you need this fired for another interaction, ask a programmer.
-------------------------------------------------------------------------------------------------

hstructure InteractEventStruct
	interactee:object;
	interacter:object;
end

-- Callback from C++
function global_object_event_interact(interactee:object, interacter:object)
	local eventArgs = hmake InteractEventStruct
		{
			interactee = interactee,
			interacter = interacter,
		};

	--This should be re-enabled for forge once this code moves to C++.
	if not GameEngineIsForge() then
		Telemetry.Progression.UnitObjectInteraction(interacter, interactee);
	end
	CallEvent(g_eventTypes.objectInteractEvent, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Touched Callback
-- Called from the game when a device is touched by a player
-------------------------------------------------------------------------------------------------

hstructure DeviceTouchedEventStruct
	device:object;
	touchingPlayer:object;
end

-- Callback from C++
function DeviceTouchedCallback(device:object, touchingPlayer:player)
	local eventArgs = hmake DeviceTouchedEventStruct
		{
			device = device,
			touchingPlayer = touchingPlayer
		};

	CallEvent(g_eventTypes.deviceTouchedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Dispensed Callback
-- Called from the game when a device dispenses an object
-------------------------------------------------------------------------------------------------

hstructure DeviceDispensedEventStruct
	device:object;
	dispensedObject:object;
end

-- Callback from C++
function DeviceDispensedCallback(device:object, dispensedObject:object)
	local eventArgs = hmake DeviceDispensedEventStruct
		{
			device = device,
			dispensedObject = dispensedObject
		};

	CallEvent(g_eventTypes.deviceDispensedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Interaction Started Callback
-- Called from the game when a device interaction is started by a player
-------------------------------------------------------------------------------------------------

hstructure DeviceInteractionStartedEventStruct
	device:object;
	interactingPlayer:player;
end

-- Callback from C++
function DeviceInteractionStartedCallback(device:object, interactingPlayer:player)
	local eventArgs = hmake DeviceInteractionStartedEventStruct
		{
			device = device,
			interactingPlayer = interactingPlayer
		};

	CallEvent(g_eventTypes.deviceInteractionStartedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Interaction Finished Callback
-- Called from the game when a device interaction is finished by a player
-------------------------------------------------------------------------------------------------

hstructure DeviceInteractionFinishedEventStruct
	device:object;
	interactingPlayer:player;
end

-- Callback from C++
function DeviceInteractionFinishedCallback(device:object, interactingPlayer:player)
	local eventArgs = hmake DeviceInteractionFinishedEventStruct
		{
			device = device,
			interactingPlayer = interactingPlayer
		};

	CallEvent(g_eventTypes.deviceInteractionFinishedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Interaction Interrupted Callback
-- Called from the game when a device interaction by a player is interrupted. This only includes when a player dies (as of 12/4/2019), but could be expanded to fire in other moments (this would require C++ changes.).
-------------------------------------------------------------------------------------------------

hstructure DeviceInteractionInterruptedEventStruct
	device:object;
	interactingPlayer:player;
end

-- Callback from C++
function DeviceInteractionInterruptedCallback(device:object, interactingPlayer:player)
	local eventArgs = hmake DeviceInteractionInterruptedEventStruct
		{
			device = device,
			interactingPlayer = interactingPlayer
		};

	CallEvent(g_eventTypes.deviceInteractionInterruptedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Interaction Released Callback
-- Called from the game when a device interaction is released by a player. This includes interruption, letting going of interact before completion, as well as after completion.
-- (The previously listed cases are mutually exclusive.).
-------------------------------------------------------------------------------------------------

hstructure DeviceInteractionReleasedEventStruct
	device:object;
	interactingPlayer:player;
	normalizedInteractionProgress:number;
end

-- Callback from C++
function DeviceInteractionReleasedCallback(device:object, interactingPlayer:player, normalizedInteractionProgress:number)
	local eventArgs = hmake DeviceInteractionReleasedEventStruct
		{
			device = device,
			interactingPlayer = interactingPlayer,
			normalizedInteractionProgress = normalizedInteractionProgress 
		};

	CallEvent(g_eventTypes.deviceInteractionReleasedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Dispenser Component Child Detached Callback
-- Called from the game when a component child object of a device dispenser is detached
-------------------------------------------------------------------------------------------------

hstructure DeviceDispenserComponentChildDetachedEventStruct
	device:object;
	slotIndex:number;
	childObject:object;
end

-- Callback from C++
function DeviceDispenserComponentChildDetachedCallback(device:object, slotIndex:number, childObject:object)
	local eventArgs = hmake DeviceDispenserComponentChildDetachedEventStruct
		{
			device = device,
			slotIndex = slotIndex,
			childObject = childObject
		};

	CallEvent(g_eventTypes.deviceDispenserComponentChildDetachedEvent, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Device Dispenser Component Child State Updated Callback
-- Called from the game when a component child object's state is updated within a device dispenser
-------------------------------------------------------------------------------------------------

hstructure DeviceDispenserComponentChildStateUpdatedEventStruct
	device:object;
	slotIndex:number;
	childObject:object;
end

-- Callback from C++
function DeviceDispenserComponentChildStateUpdatedCallback(device:object, slotIndex:number, childObject:object)
	local eventArgs = hmake DeviceDispenserComponentChildStateUpdatedEventStruct
		{
			device = device,
			slotIndex = slotIndex,
			childObject = childObject
		};

	CallEvent(g_eventTypes.deviceDispenserComponentChildStateUpdated, device, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object frame created event
-- Callback from the engine when a frame is created for an object
-------------------------------------------------------------------------------------------------

hstructure ObjectFrameCreatedEventStruct
	obj:object;
	frameName:ui64;
end

-- Callback from C++
function ObjectFrameCreatedCallback(obj:object, frameName:ui64)
	--print("FrameCreated: ", obj, " (", frameName, ")")
	local eventArgs = hmake ObjectFrameCreatedEventStruct
		{
			obj = obj,
			frameName = frameName,
		};

	CallEvent(g_eventTypes.objectFrameCreatedEvent, obj, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object socket attachment created event
-- Callback from the engine when a socket attachment is created for an object
-------------------------------------------------------------------------------------------------

hstructure ObjectFrameAttachmentCreatedEventStruct
	obj:object;
	attachmentName:ui64;
end

-- Callback from C++
function ObjectFrameAttachmentCreatedCallback(obj:object, attachmentName:ui64)
	--print("FrameAttachmentCreated: ", obj, " (", attachmentName, ")")
	local eventArgs = hmake ObjectFrameAttachmentCreatedEventStruct
		{
			obj = obj,
			attachmentName = attachmentName,
		};

	CallEvent(g_eventTypes.objectFrameAttachmentCreatedEvent, obj, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Object socket attachment attached event
-- Callback from the engine when a socket attachment is attached for an object
-------------------------------------------------------------------------------------------------

hstructure ObjectFrameAttachmentAttachedEventStruct
	unit:object;
	pickedUpEquipment:object;
	pickedUpEquipmentTag:tag;
	attachedObjectName:string_id;
	attachedImplementation:tag;
end

-- Callback from C++
function ObjectFrameAttachmentAttachedCallback(unit:object, pickedUpEquipment:object, attachedObjectName:string_id, attachedImplementation:tag, pickedUpEquipmentTag:tag)
	local eventArgs = hmake ObjectFrameAttachmentAttachedEventStruct
		{
			unit = unit,
			pickedUpEquipment = pickedUpEquipment,
			pickedUpEquipmentTag = pickedUpEquipmentTag,
			attachedObjectName = attachedObjectName,
			attachedImplementation = attachedImplementation,
		};

	CallEvent(g_eventTypes.objectFrameAttachmentAttachedEvent, pickedUpEquipment, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Object socket attachment replenished event
-- Callback from the engine when a socket attachment is replenished by the same type of object
-------------------------------------------------------------------------------------------------

hstructure ObjectFrameAttachmentReplenishedEventStruct
	unit:object;
	replenisherEquipment:object;
	replenisherEquipmentTag:tag;
	attachedImplementation:string_id;
	wasDepleted:boolean;
end

-- Callback from C++
function ObjectFrameAttachmentReplenishedCallback(unit:object, replenisherEquipment:object, attachedImplementation:string_id, wasDepleted:boolean, replenisherEquipmentTag:tag)
	local eventArgs = hmake ObjectFrameAttachmentReplenishedEventStruct
		{
			unit = unit,
			replenisherEquipment = replenisherEquipment,
			replenisherEquipmentTag = replenisherEquipmentTag,
			attachedImplementation = attachedImplementation,
			wasDepleted = wasDepleted,
		};

	CallEvent(g_eventTypes.objectFrameAttachmentReplenishedEvent, replenisherEquipment, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Object socket attachment attached event
-- Callback from the engine when a socket attachment is attached for an object
-------------------------------------------------------------------------------------------------

hstructure ObjectFrameAttachmentDeletedEventStruct
	unit:object;
	detachedObjectName:string_id;
	detachedImplementation:string_id;
	spawnedObjects:table;
end

-- Callback from C++
function ObjectFrameAttachmentDeletedCallback(unit:object, detachedObjectName:string_id, detachedImplementation:string_id, spawnedObjects:table)
	local eventArgs = hmake ObjectFrameAttachmentDeletedEventStruct
		{
			unit = unit,
			detachedObjectName = detachedObjectName,
			detachedImplementation = detachedImplementation,
			spawnedObjects = spawnedObjects,
		};

	CallEvent(g_eventTypes.objectFrameAttachmentDeletedEvent, unit, eventArgs);
end


--## CLIENT

-------------------------------------------------------------------------------------------------
-- Object socket attachment created/deleted events for client
-- Callback from the engine when a socket attachment is created/deleted for an object
-------------------------------------------------------------------------------------------------

-- Callback from C++
function ObjectFrameAttachmentCreatedCallbackClient(obj:object, attachmentName:string_id)
	--print("FrameAttachmentCreated Client: ", obj, " (", attachmentName, ")")
	Object_EnableObjectNodeGraph(obj, attachmentName, true);
end

-- Callback from C++
function ObjectFrameAttachmentDeletedCallbackClient(obj:object, attachmentName:string_id)
	--print("FrameAttachmentDeleted Client: ", obj, " (", attachmentName, ")")
	Object_EnableObjectNodeGraph(obj, attachmentName, false);
end

--## SERVER
-------------------------------------------------------------------------------------------------
-- Object spawned equipment control state changed event
-- Callback from the engine when a spawned equipment's control state changes
-------------------------------------------------------------------------------------------------

hstructure ObjectSpawnedEquipmentControlStateChangedStruct
	equipment:object;
	spawnedObject:object;
	ownerUnit:object
	controlState:number;
end

-- Callback from C++
function ObjectSpawnedEquipmentControlStateChangedCallback(equipment:object, obj:object, owner:object, controlState:number)
	local eventArgs = hmake ObjectSpawnedEquipmentControlStateChangedStruct
		{
			equipment = equipment,
			spawnedObject = obj,
			ownerUnit = owner,
			controlState = controlState,
		};

	CallEvent(g_eventTypes.equipmentAbilityControlStateChanged, equipment, eventArgs);
	CallEvent(g_eventTypes.equipmentSpawnedObjectControlStateChanged, obj, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Object Volume Entered and Exited Callback
-- Called from Lua when an object enters or exits the registered trigger volumes
-------------------------------------------------------------------------------------------------

global g_volumeEventTable:table = {};
global g_volumeEventThread:thread = nil;
global g_volumeEnteredEvent:string = "g_volumeEnteredEvent";
global g_volumeExitedEvent:string = "g_volumeExitedEvent";

hstructure VolumeEventStruct
	volume:volume;
	obj:object;
	player:player;
	ai:ai;
end

--used by the system
function RegisterVolumeEvent(eventType:string, volume:volume, func:ifunction, onItem, ...)
	assert(volume ~= nil, "no valid volume in RegisterVolumeOnEnterEvent");
	assert(func ~=nil, "no valid function in RegisterVolumeOnEnterEvent");
	assert(onItem ~= nil,"ParcelOnRegisterVolumeOnce event attempted to be registered with a nil onItem");
	

	local multipleOnItemStruct:MultipleOnItemArgs = BuildMultipleOnItemStruct(onItem, volume);

	RegisterEvent(eventType, func, multipleOnItemStruct, ...);
	VolumeEventCheckerStart(volume);
end


--register volume events
-- === RegisterVolumeOnEnterEvent: register a callback on an item entering a trigger volume
--		volume = a trigger volume to watch for an object entering
--		func = the callback function to call when the onItem enters the volume
--		onItem = the object to watch when it enters the volume
--		... = any optional arguments
function RegisterVolumeOnEnterEvent(volume:volume, func:ifunction, onItem, ...)
	RegisterVolumeEvent(g_volumeEnteredEvent, volume, func, onItem, ...);
end

-- === RegisterVolumeOnExitEvent: register a callback on an item exiting a trigger volume
--		volume = a trigger volume to watch for an object exiting
--		func = the callback function to call when the onItem exits the volume
--		onItem = the object to watch when it exits the volume
--		... = any optional arguments
function RegisterVolumeOnExitEvent(volume:volume, func:ifunction, onItem, ...)
	RegisterVolumeEvent(g_volumeExitedEvent, volume, func, onItem, ...);
end

--unregister events
function UnregisterVolumeOnEnterEvent(volume:volume, callback:ifunction, onItem):void
	UnregisterVolumeEvent(g_volumeEnteredEvent, callback, onItem, volume);
end

function UnregisterVolumeOnExitEvent(volume:volume, callback:ifunction, onItem):void
	UnregisterVolumeEvent(g_volumeExitedEvent, callback, onItem, volume);
end


--Register Volume events that only occur once
-- === RegisterVolumeOnEnterOnceEvent: register a callback on an item entering a trigger volume (calls only once)
--		volume = a trigger volume to watch for an object entering
--		func = the callback function to call when the onItem enters the volume
--		onItem = the object to watch when it enters the volume
--		... = any optional arguments
function RegisterVolumeOnEnterOnceEvent(volume:volume, func:ifunction, onItem, ...)
	RegisterVolumeOnEnterEvent(volume, OnRegisterVolumeOnceEvent, onItem, func, onItem, UnregisterVolumeOnEnterEvent, ...);
end

-- === RegisterVolumeOnExitOnceEvent: register a callback on an item exiting a trigger volume (calls only once)
--		volume = a trigger volume to watch for an object exiting
--		func = the callback function to call when the onItem exits the volume
--		onItem = the object to watch when it exits the volume
--		... = any optional arguments
function RegisterVolumeOnExitOnceEvent(volume:volume, func:ifunction, onItem, ...)
	RegisterVolumeOnExitEvent(volume, OnRegisterVolumeOnceEvent, onItem, func, onItem, UnregisterVolumeOnExitEvent, ...);
end


--used by the system
function OnRegisterVolumeOnceEvent(onEnteredEvent:VolumeEventStruct, func:ifunction, onItem, unRegisterFunc:ifunction, ...)
	--find out if object is already in the volume and unregister if it is

	assert(onItem ~= nil, "OnRegisterVolumeOnceEvent event attempted to be registered with a nil onItem");
	-- Stop us from getting anymore callbacks. And then call the client callback.
	unRegisterFunc(onEnteredEvent.volume, OnRegisterVolumeOnceEvent, onItem);
	func(onEnteredEvent, ...);
end


--unregister events
function UnregisterVolumeOnEnterOnceEvent(volume:volume, callback:ifunction, onItem):void
	UnregisterVolumeEvent(g_volumeEnteredEvent, callback, onItem, volume);
end

function UnregisterVolumeOnExitOnceEvent(volume:volume, callback:ifunction, onItem):void
	UnregisterVolumeEvent(g_volumeExitedEvent, callback, onItem, volume);
end

--unregister event function
function UnregisterVolumeEvent(eventType:string, callback:ifunction, onItem, volume:volume):void
	local multipleOnItemStruct:MultipleOnItemArgs = BuildMultipleOnItemStruct(onItem, volume);
	UnregisterEvent(eventType, callback, multipleOnItemStruct);
	RemoveVolumeFromVolumeEventTables(volume);
end

function RemoveVolumeFromVolumeEventTables(volume:volume, numberOfEvents:number):void
	--cleanout the volume event table so that the thread stops when there are no more events
	numberOfEvents = numberOfEvents or 1;
	g_volumeEventTable[volume].count = g_volumeEventTable[volume].count - numberOfEvents;
end


--this should be called from C++, but can't so it's called from lua
function VolumeEnteredEventCall(volumeArg:volume, objectArg:object)
	local volEvents = VolumeBuildHstruct(volumeArg, objectArg);
	CallVolumeEvent(g_volumeEnteredEvent, volEvents);
end

function VolumeExitedEventCall(volumeArg:volume, objectArg:object)
	local volEvents = VolumeBuildHstruct(volumeArg, objectArg);
	CallVolumeEvent(g_volumeExitedEvent, volEvents);
end

function VolumeBuildHstruct(volumeArg:volume, objectArg:object):VolumeEventStruct
	local playerArg:player = nil;
	local aiArg:ai = nil;
	local unitType, strongType = GetEngineType(objectArg, true);
	if strongType == "biped" then
		playerArg = Unit_GetPlayer(objectArg);
		aiArg = Unit_GetActor(objectArg);
	end

	local volEvents = hmake VolumeEventStruct
		{
			volume = volumeArg,
			obj = objectArg,
			player = playerArg,
			ai = aiArg,
		}
	return volEvents;
end

function CallVolumeEvent(eventType:string, volEvent:VolumeEventStruct)
	local eventTable = g_callbackEventTable[eventType];
	if (eventTable ~= nil) then
		--prevent calling the event 4 times so filters aren't called 4 times
		if eventTable[volEvent.obj] ~= nil then
			CallEventOnTable(eventTable[volEvent.obj][volEvent.volume], volEvent);
		end
		if eventTable[volEvent.player] then
			CallEventOnTable(eventTable[volEvent.player][volEvent.volume], volEvent);
		end
		if eventTable[volEvent.ai] then
			CallEventOnTable(eventTable[volEvent.ai][volEvent.volume], volEvent);
		end
		--call event generically for the filters or g_allItems
		CallEvent(eventType, nil, volEvent);
	end
end

--this checks every registered volume every tick if registered objects enter or exit the volume
function VolumeEventChecker()
	while next(g_volumeEventTable) do
		local objList = nil;
				
		for volume, val in hpairs (g_volumeEventTable) do
			objList = volume_return_objects(volume);
							
			--get the old objects in the volume (don't count objects currently in the volume)
			local oldObjects = g_volumeEventTable[volume].objectsInVolume or objList;

			--combine the old and new objects so we can find what entered and exited
			local combinedObjects = table.combine (objList, oldObjects);
			--find the objects that have left the volume
			local leavingObjects = table.dif(objList, combinedObjects);
			--find the objects that have entered the volume
			local enteringObjects = table.dif(oldObjects, combinedObjects);

			--call onExit event for all exited objects
			for _, obj in ipairs (leavingObjects) do
				VolumeIfVehicleThenCallEventOnPassengers(obj, volume, VolumeExitedEventCall);
				CreateThread(VolumeExitedEventCall, volume, obj);
			end
				
			--call onEnter event for all entered objects
			for _, obj in ipairs (enteringObjects) do
				VolumeIfVehicleThenCallEventOnPassengers(obj, volume, VolumeEnteredEventCall);
				CreateThread(VolumeEnteredEventCall, volume, obj);
			end

			g_volumeEventTable[volume].objectsInVolume = objList;
			if g_volumeEventTable[volume].count == 0 then
				g_volumeEventTable[volume] = nil;
			end
		end
		Sleep(1);
	end
	g_volumeEventThread = nil;
end


function VolumeEventCheckerStart(volume:volume)
	--create a table of the volume (if not yet created) for the volume checker to search
	g_volumeEventTable[volume] = g_volumeEventTable[volume] or {};

	if g_volumeEventTable[volume].count == nil then
		g_volumeEventTable[volume].count = 1;
	else
		g_volumeEventTable[volume].count = g_volumeEventTable[volume].count + 1;
	end

	--create the volume event thread if it isn't created
	if g_volumeEventThread == nil then
		g_volumeEventThread = CreateThread (VolumeEventChecker);
	end
end

function VolumeIfVehicleThenCallEventOnPassengers(obj:object, volume:volume, EventCall:ifunction)
	local unitType, strongType = GetEngineType(obj, true);
	if strongType == "vehicle" or strongType == "biped" then
		--this will check for the mantis because the mantis is a biped
		if Unit_GetTreatAsVehicle(obj) then
			local passengers = Vehicle_GetPassengers(obj);
			for _, passenger in ipairs(passengers) do
				CreateThread(EventCall, volume, passenger);
			end
		end
	end
end

-------------------------------------------------------------------------------------------------
-- Object action event callback
-- Callback from the engine when an event is triggered from the action system
-------------------------------------------------------------------------------------------------

hstructure ObjectActionEventStruct
	obj:object;
	actionEventName:ui64;
end

-- Callback from C++
function ObjectActionEventCallback(obj:object, actionEventName:ui64)
	local eventArgs = hmake ObjectActionEventStruct
		{
			obj = obj,
			actionEventName = actionEventName,
		};

	CallEvent(g_eventTypes.objectActionEvent, obj, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Phantom Entered Callback
-- Called by the game whenever an object enters a Phantom
-------------------------------------------------------------------------------------------------

hstructure PhantomEnteredEventStruct
	phantomObject:object;
	enteringObject:object;
end

-- Callback from C++
function PhantomEnteredCallback(phantomObject:object, enteringObject:object)
	local eventArgs = hmake PhantomEnteredEventStruct
		{
			phantomObject = phantomObject,
			enteringObject = enteringObject
		};

	CallEvent(g_eventTypes.phantomEnteredEvent, phantomObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Phantom Exited Callback
-- Called by the game whenever a object exits a Phantom
-------------------------------------------------------------------------------------------------

hstructure PhantomExitedEventStruct
	phantomObject:object;
	exitingObject:object;
end

-- Callback from C++
function PhantomExitedCallback(phantomObject:object, exitingObject:object)
	local eventArgs = hmake PhantomExitedEventStruct
		{
			phantomObject = phantomObject,
			exitingObject = exitingObject
		};

	CallEvent(g_eventTypes.phantomExitedEvent, phantomObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Crouch Changed Callback
-- Called whenever a unit's crouch state changes
-------------------------------------------------------------------------------------------------

hstructure CrouchEventStruct
	unit:object
	player:player;
	crouching:boolean;
end

-- Callback from C++
function UnitCrouchCallback(unit:object, player:player, crouching:boolean)
	local eventArgs = hmake CrouchEventStruct
		{
			unit = unit,
			player = player,
			crouching = crouching,
		};

	CallEventWithOnItemArray(g_eventTypes.unitCrouchEvent, { unit, player }, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Trigger Medal Event 
-- Called by the medal event manager to pass a medal event to Response Lua through HSLua's Medal Manager
-------------------------------------------------------------------------------------------------

hstructure TriggerMedalEventStruct
	targetPlayer:player;
	mpLuaEventName:string;
	damageSource:string_id;
	damageType:string_id;
	deadPlayer:player;
end

-- Callback from C++
function TriggerMedalEvent(targetPlayer:player, mpLuaEventName:string, damageSource:string_id, damageType:string_id, deadPlayer:player):void
	local eventArgs = hmake TriggerMedalEventStruct
		{
			targetPlayer = targetPlayer,
			mpLuaEventName = mpLuaEventName,
			damageSource = damageSource,
			damageType = damageType,
			deadPlayer = deadPlayer,
		};

	CallEvent(g_eventTypes.triggerMedalEvent, nil, eventArgs);
end
