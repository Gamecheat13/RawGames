--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Weapon Pad Slot State Changed Callback
-- Called by the game whenever the slot state of a Weapon Pad changes
-------------------------------------------------------------------------------------------------

hstructure WeaponPadSlotStateChangedEventStruct
	dispenserObject:object;
	slotIndex:number;		
	slotState:object_dispenser_slot_state;
	secondsLeft:number;
	dispensedObject:object;
end

-- Callback from C++
function GlobalObjectEventWeaponPadSlotStateChanged(dispenserObject:object, slotIndex:number, slotState:object_dispenser_slot_state, secondsLeft:number, dispensedObject:object)
	local eventArgs = hmake WeaponPadSlotStateChangedEventStruct
		{
			dispenserObject = dispenserObject,
			slotIndex = slotIndex,				
			slotState = slotState,	
			secondsLeft = secondsLeft,	
			dispensedObject = dispensedObject,
		};

	CallEvent(g_eventTypes.weaponPadSlotStateChangedEvent, dispenserObject, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Swap Callback
-- Called by the game whenever a player swaps weapons
-- **Only fires in standalone, will not work in distributed.
-------------------------------------------------------------------------------------------------

hstructure PlayerWeaponSwapEventStruct
	player:player;
	isSignatureWeapon:boolean;				
end

-- Callback from C++

function GlobalObjectEventPlayerWeaponSwap(player:player, isSignatureWeapon:boolean)
	local eventArgs = hmake PlayerWeaponSwapEventStruct
		{
			player = player,
			isSignatureWeapon = isSignatureWeapon,				
		};
	CallEvent(g_eventTypes.playerWeaponSwapEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Pickup Callback
-- Called by the game whenever a weapon is explicitly picked up by a player. This means:
-- NOT for ammo refill pickups, but does fire on a non-refill weapon pad pickup
-------------------------------------------------------------------------------------------------

hstructure WeaponPickupEventStruct
	player:					player;
	weapon:					object;
	weaponPosition:			vector;
end

-- Callback from C++
function WeaponPickupCallback(player:player, pickedUpWeapon:object, pickedUpWeaponPosition:vector)
	local eventArgs = hmake WeaponPickupEventStruct
		{
			player = player,
			weapon = pickedUpWeapon,
			weaponPosition = pickedUpWeaponPosition,
		};

	CallEvent(g_eventTypes.weaponPickupEvent, pickedUpWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Pickup At Pad Callback
-- Called by the game whenever a weapon is explicitly picked up by a player off of a weapon pad. This means:
-- NOT for ammo refill pickups, and that this callback fires in ADDITION to the WeaponPickupCallback
-- when a player explicitly picks up a weapon off of a weapon pad.
-------------------------------------------------------------------------------------------------

hstructure WeaponPickupAtPadEventStruct
	player:					player;
	weapon:					object;
	weaponPad:				object;
	weaponPosition:			vector;
end

-- Callback from C++
function WeaponPickupAtPadCallback(player:player, pickedUpWeapon:object, weaponPad:object, pickedUpWeaponPosition:vector)
	local eventArgs = hmake WeaponPickupAtPadEventStruct
		{
			player = player,
			weapon = pickedUpWeapon,
			weaponPad = weaponPad,
			weaponPosition = pickedUpWeaponPosition,
		};

	CallEvent(g_eventTypes.weaponPickupAtPadEvent, weaponPad, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Pickup For Ammo Refill Callback
-- Called by the game whenever a weapon is picked up by a player for ammo refill
-- Doesn't necessarily mean that the weapon is FULLY picked up (i.e. that it despawns)
-- This DOES fire even when the weapon doing the refilling is on a weapon pad.
-------------------------------------------------------------------------------------------------

hstructure WeaponPickupForAmmoRefillEventStruct
	player:							player;
	weapon:							object;
	weaponPosition:					vector;
	roundsPickedUp:					number;
	weaponFullyPickedUp:			boolean; 	-- whether or not the weapon was fully picked up, i.e. despawned
	inventoryWeaponBeingRefilled:	object;
	isAgeBased:						boolean;
end

-- Callback from C++
function WeaponPickupForAmmoRefillCallback(player:player, pickedUpWeapon:object, pickedUpWeaponPosition:vector, roundsPickedUp:number, weaponFullyPickedUp:boolean, inventoryWeaponBeingRefilled:object, isAgeBased:boolean)
	local eventArgs = hmake WeaponPickupForAmmoRefillEventStruct
		{
			player = player,
			weapon = pickedUpWeapon,
			weaponPosition = pickedUpWeaponPosition,
			roundsPickedUp = roundsPickedUp,		-- represents normalized age value if isAgeBased is true
			weaponFullyPickedUp = weaponFullyPickedUp,
			inventoryWeaponBeingRefilled = inventoryWeaponBeingRefilled,
			isAgeBased = isAgeBased,
		};

	CallEvent(g_eventTypes.weaponPickupForAmmoRefillEvent, pickedUpWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Drop Callback
-- Called by the game whenever a weapon is explicitly dropped by a player.
-------------------------------------------------------------------------------------------------
hstructure WeaponDropEventStruct
	unit:					object;
	weapon:					object;
	isPrimaryWeapon:		boolean;
end

function WeaponDropCallback(unit:object, droppedWeapon:object, isPrimaryWeapon:boolean)
	local eventArgs = hmake WeaponDropEventStruct
		{
			unit = unit,
			weapon = droppedWeapon,
			isPrimaryWeapon = isPrimaryWeapon,
		};

	CallEvent(g_eventTypes.weaponDropEvent, droppedWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Out of Ammo Callback
-- Called by the game whenever a weapon runs out of ammunition or energy.
-------------------------------------------------------------------------------------------------
hstructure WeaponOutOfAmmoEventStruct
	unit:					object;
	weapon:					object;
end

function WeaponOutOfAmmoCallback(unit:object, emptyWeapon:object)
	local eventArgs = hmake WeaponOutOfAmmoEventStruct
		{
			unit = unit,
			weapon = emptyWeapon,
		};

	CallEvent(g_eventTypes.weaponOutOfAmmoEvent, emptyWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Out of Ammo Callback
-- Called by the game whenever a weapon runs out of ammunition or energy.
-------------------------------------------------------------------------------------------------

hstructure WeaponLowAmmoEventStruct
	unit:		object;
	weapon:		object;
end

function WeaponLowAmmoCallback(unit:object, lowAmmoWeapon:object)
	local eventArgs = hmake WeaponLowAmmoEventStruct
	{
		unit = unit,
		weapon = lowAmmoWeapon,
	};

	CallEvent(g_eventTypes.weaponLowAmmoEvent, lowAmmoWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Throw Callback
-- Called by the game whenever a weapon is thrown by a unit.
-------------------------------------------------------------------------------------------------
hstructure WeaponThrownEventStruct
	player:			player;	-- nil if the throwing unit is not a player or bot
	thrownWeapon:	object;
	throwingUnit:	object;

end

-- Callback from C++
function WeaponThrowCallback(player:player, thrownWeapon:object, throwingUnit:object)
	local eventArgs = hmake WeaponThrownEventStruct
	{
		player = player,
		thrownWeapon = thrownWeapon,
		throwingUnit = throwingUnit
	};

	CallEvent(g_eventTypes.weaponThrowEvent, thrownWeapon, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Weapon Added To Inventory Callback
-- Called by the game whenever a weapon is added to a player's inventory.
-------------------------------------------------------------------------------------------------
hstructure WeaponAddedToInventoryEventStruct
	player:		player;
	weapon:		object;
end

function WeaponAddedToInventoryCallback(player:player, weapon:object)
	local eventArgs = hmake WeaponAddedToInventoryEventStruct
	{
		player = player,
		weapon = weapon
	};

	CallEvent(g_eventTypes.weaponAddedToInventory, weapon, eventArgs);
end