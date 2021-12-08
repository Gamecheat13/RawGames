--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.

-------------------------------------------------------------------------------------------------
-- Seat Entered Callback
-- Called by the game whenever a unit enters a seats
-------------------------------------------------------------------------------------------------

hstructure SeatEnteredEventStruct
	mount:object;
	instigator:object;
	seatLabel:string;
end

-- Callback from C++
function SeatEnteredCallback(mount:object, instigator:object, seatLabel:string)
	local eventArgs = hmake SeatEnteredEventStruct
	{
		mount = mount,
		instigator = instigator,
		seatLabel = seatLabel,
	};

	CallEventWithOnItemArray(g_eventTypes.seatEnteredEvent, { mount, instigator }, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Seat Exited Callback
-- Called by the game whenever a unit exits a seats
-------------------------------------------------------------------------------------------------

hstructure SeatExitedEventStruct
	mount:object;
	instigator:object;
	seatLabel:string;
end

-- Callback from C++
function SeatExitedCallback(mount:object, instigator:object, seatLabel:string)
	local eventArgs = hmake SeatExitedEventStruct
	{
		mount = mount,
		instigator = instigator,
		seatLabel = seatLabel,
	};

	CallEventWithOnItemArray(g_eventTypes.seatExitedEvent, { mount, instigator }, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Mount Entered Callback
-- Called by the game whenever a unit enters a mount
-------------------------------------------------------------------------------------------------

hstructure MountEnteredEventStruct
	mount:object;
	instigator:object;
end

-- Callback from C++
function MountEnteredCallback(mount:object, instigator:object)
	local eventArgs = hmake MountEnteredEventStruct
	{
		mount = mount,
		instigator = instigator
	}

	CallEvent(g_eventTypes.mountEnteredEvent, mount, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Mount Exited Callback
-- Called by the game whenever a unit exits a mount
-------------------------------------------------------------------------------------------------

hstructure MountExitedEventStruct
	mount:object;
	instigator:object;
end

-- Callback from C++
function MountExitedCallback(mount:object, instigator:object)
	local eventArgs = hmake MountExitedEventStruct
	{
		mount = mount,
		instigator = instigator
	}

	CallEvent(g_eventTypes.mountExitedEvent, mount, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Mount Upside Down Evict Callback
-- Called by the game when a mount flips and evicts a biped. Fired for each evictee.
-------------------------------------------------------------------------------------------------

hstructure MountUpsideDownEvictEventStruct
	mount:object;
	evictee:object;
	seatName:string_id;
end

-- Callback from C++
function MountUpsideDownEvictCallback(mount:object, evictee:object, seatName:string_id )
	local eventArgs = hmake MountUpsideDownEvictEventStruct
	{
		mount = mount,
		evictee = evictee,
		seatName = seatName
	}
		
	CallEvent(g_eventTypes.mountUpsideDownEvictEvent, mount, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Vehicle Hijacked Callback
-- Called by the game when a player hijack a vehicle
-------------------------------------------------------------------------------------------------

hstructure VehicleJackedEventStruct
	vehicle:object;
	enteringPlayer:player;
end

-- Callback from C++
function VehicleJackedCallback(vehicle:object, enteringPlayer:player)
	local eventArgs = hmake VehicleJackedEventStruct
	{
		vehicle = vehicle,
		enteringPlayer = enteringPlayer,
	}
		
	CallEvent(g_eventTypes.vehicleJacked, nil, eventArgs);
end