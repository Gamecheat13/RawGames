--## SERVER

-------------------------------------------------------------------------------------------------
-- Grenade Pickup Callback
-- Called by the game whenever a grenade is explicitly picked up by a player.
-------------------------------------------------------------------------------------------------

hstructure GrenadePickupEventStruct
	player:					player;
	grenadePickup:			object;
	grenadeType:			grenade_type;
	grenadePosition:		location;
end

-- Callback from C++
function GrenadePickupCallback(player:player, pickedUpGrenade:object, pickedUpGrenadeType:grenade_type, pickedUpGrenadePosition:location)
	local eventArgs = hmake GrenadePickupEventStruct
		{
			player = player,
			grenadePickup = pickedUpGrenade,
			grenadeType = pickedUpGrenadeType,
			grenadePosition = pickedUpGrenadePosition,
		};

	CallEvent(g_eventTypes.grenadePickupEvent, pickedUpGrenade, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Grenade Throw Callback
-- Called by the game whenever a grenade is thrown by a unit.
-------------------------------------------------------------------------------------------------

hstructure GrenadeThrowEventStruct
	player:					player;
	grenadeType:			grenade_type;
end

-- Callback from C++
function GrenadeThrowCallback(player:player, thrownGrenadeType:grenade_type)
	local eventArgs = hmake GrenadeThrowEventStruct
		{
			player = player,
			grenadeType = thrownGrenadeType,
		};

	CallEvent(g_eventTypes.grenadeThrowEvent, nil, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Grenade Drop Callback
-- Called by the game whenever a grenade is dropped by a unit.
-------------------------------------------------------------------------------------------------

hstructure GrenadeDropEventStruct
	player:					player;
	spawnedGrenade:			object;
	grenadeType:			grenade_type;
end

-- Callback from C++
function GrenadeDropCallback(player:player, spawnedGrenade:object, droppedGrenadeType:grenade_type)
	local eventArgs = hmake GrenadeDropEventStruct
		{
			player = player,
			spawnedGrenade = spawnedGrenade,
			grenadeType = droppedGrenadeType,
		};

	CallEvent(g_eventTypes.grenadeDropEvent, nil, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Equipment Pickup Callback
-- Called by the game whenever equipment is explicitly picked up by a player.
-------------------------------------------------------------------------------------------------

hstructure EquipmentPickupEventStruct
	player:					player;
	equipment:				object;
	equipmentPosition:		location;
end

-- Callback from C++
function EquipmentPickupCallback(player:player, pickedUpEquipment:object, pickedUpEquipmentPosition:location)
	local eventArgs = hmake EquipmentPickupEventStruct
		{
			player = player,
			equipment = pickedUpEquipment,
			equipmentPosition = pickedUpEquipmentPosition,
		};

	CallEvent(g_eventTypes.equipmentPickupEvent, pickedUpEquipment, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Equipment Ability Activate Callback
-- Called by the game whenever an equipment ability is activated
-------------------------------------------------------------------------------------------------

hstructure EquipmentAbilityActivateEventStruct
	owner:					object;
	equipment:				object;
	equipmentAbilityTypes:	table;
end

-- Callback from C++
function EquipmentAbilityActivateCallback(owner:object, equipment:object,  ...)
	local eventArgs = hmake EquipmentAbilityActivateEventStruct
		{
			owner = owner,
			equipment = equipment,
			equipmentAbilityTypes = arg,	 -- the varargs, which are the set of ability types which this ability has
		};

	-- Note that if Unit_GetPlayer(owner) returns nil, then the inlined array below will be equivalent to { owner, equipment }
	-- meaning that the callback will still fire as expected
	CallEventWithOnItemArray(g_eventTypes.equipmentAbilityActivateEvent, { owner, equipment, Unit_GetPlayer(owner) }, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Equipment Ability Deactivate Callback
-- Called by the game whenever an equipment ability is deactivated
-------------------------------------------------------------------------------------------------

hstructure EquipmentAbilityDeactivateEventStruct
	owner:					object;
	equipment:				object;
	equipmentAbilityTypes:	table;
end

-- Callback from C++
function EquipmentAbilityDeactivateCallback(owner:object, equipment:object,  ...)
	local eventArgs = hmake EquipmentAbilityDeactivateEventStruct
		{
			owner = owner,
			equipment = equipment,
			equipmentAbilityTypes = arg,	 -- the varargs, which are the set of ability types which this ability has
		};

	CallEventWithOnItemArray(g_eventTypes.equipmentAbilityDeactivateEvent, { owner, equipment }, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Equipment Ability Energy Exhausted Callback
-- Called by the game whenever an equipment ability runs out of energy
-------------------------------------------------------------------------------------------------

hstructure EquipmentAbilityExhaustedEventStruct
	unit:					object;
	equipmentTag:			tag;
end

-- Callback from C++
function EquipmentAbilityEnergyExhaustedCallback(unit:object, equipmentTag:tag)
	local eventArgs = hmake EquipmentAbilityExhaustedEventStruct
		{
			unit = unit,
			equipmentTag = equipmentTag,
		};

	CallEvent(g_eventTypes.equipmentAbilityEnergyExhaustedCallback, unit, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Spartan Ability Exhausted Callback
-- Called by the game whenever an spartan ability has used all energy and cannot be re-used
-------------------------------------------------------------------------------------------------

-- Callback from C++
function SpartanAbilityExhaustedEnergyCallback(unit:object, equipmentTag:tag)
	local eventArgs = hmake EquipmentAbilityExhaustedEventStruct
		{
			unit = unit,
			equipmentTag = equipmentTag,
		};

	CallEvent(g_eventTypes.spartanAbilityEnergyExhaustedCallback, unit, eventArgs);
end


hstructure SpartanAbilityStateChangedEventStruct
	unit:					object;
	activated:				boolean;
	abilityTag:				tag;
end

function SpartanAbilityStateChangedCallback(unit:object, activated:boolean, abilityTag:tag)
	local eventArgs = hmake SpartanAbilityStateChangedEventStruct
	{
		unit = unit,
		activated = activated,
		abilityTag = abilityTag,
	};

	CallEvent(g_eventTypes.spartanAbilityStateChangedCallback, unit, eventArgs);
end

--## SERVER

-------------------------------------------------------------------------------------------------
-- Player Used Equipment Callback
-- Called by the game whenever a player uses an equipment or ability defined in EquipmentAbilityData in global_multiplayer_init.lua.
-- This subset is the equipment the player can pick up and use in MP modes.
-------------------------------------------------------------------------------------------------

hstructure PlayerUsedEquipmentEventStruct
	player:					player;
	equipmentTag:			tag;
	equipmentName:			string;
end

-- Callback from Lua (global_multiplayer_medals.lua)
function PlayerUsedEquipmentCallback(player:player, equipmentTag:tag, equipmentName:string)
	local eventArgs = hmake PlayerUsedEquipmentEventStruct
		{
			player = player,
			equipmentTag = equipmentTag,
			equipmentName = equipmentName,
		};

	CallEvent(g_eventTypes.playerUsedEquipment, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Grapple Hook Reel In Item Initiated Callback
-- Called by the game whenever an item is first grabbed by a grapple hook
-------------------------------------------------------------------------------------------------

hstructure GrappleReelInItemInitiatedEventStruct
	playerUnit:				object;
	item:					object;
end

-- Callback from C++
function GrappleHookReelInItemInitiatedCallback(playerUnit:object, item:object)
	local eventArgs = hmake GrappleReelInItemInitiatedEventStruct
		{
			playerUnit = playerUnit,
			item = item,
		};

	CallEvent(g_eventTypes.grappleHookReelInItemInitiatedCallback, item, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Grapple Pull Ended Callback
-- Called by the game when a grapple hook pull stage has ended
-------------------------------------------------------------------------------------------------

hstructure GrapplePullEndedEventStruct
	playerUnit:				object;
	item:					object;
end

-- Callback from C++
function GrapplePullEndedCallback(playerUnit:object, item:object)
	local eventArgs = hmake GrapplePullEndedEventStruct
		{
			playerUnit = playerUnit,
			item = item,
		};

	CallEvent(g_eventTypes.grapplePullEnded, item, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Grapple Impact Callback
-- Called by the game when a grapple hook attaches to something
-------------------------------------------------------------------------------------------------

hstructure GrappleHookImpactEventStruct
	playerUnit:				object;
	attachedObject:			object;
	distanceSquared:		number;
end

-- Callback from C++
function GrappleHookImpactCallback(playerUnit:object, attachedObject:object, distanceSquared:number)
	local eventArgs = hmake GrappleHookImpactEventStruct
		{
			playerUnit = playerUnit,
			attachedObject = attachedObject,
			distanceSquared = distanceSquared,
		};

	CallEvent(g_eventTypes.grappleHookImpactEvent, attachedObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Player Shields Low Callback
-- Called by the game whenever a participant's shields drop below 10%.
-------------------------------------------------------------------------------------------------
hstructure PlayerShieldsLowEventStruct
	player:player;
end

function PlayerShieldsLowCallback(player:player)
	local eventArgs = hmake PlayerShieldsLowEventStruct
	{
		player = player,
	};

	CallEvent(g_eventTypes.playerShieldsLowEvent, player, eventArgs);
end