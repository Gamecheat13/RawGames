-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

------------------------------------------------------------------------------------------
-- FlightDestination
------------------------------------------------------------------------------------------

-- NOTE: AirDrop.lua must be included before this file for the AirDrop namespace to be available.
-- Usage Doc: https://halolibrary/display/CD/Air+Drop+System#AirDropSystem-AirDrop.DeliveryItem
REQUIRES('scripts\AirDrop\AirDrop.lua')

-- https://halolibrary/display/CD/Air+Drop+System#AirDropSystem-AirDrop.FlightDestination
AirDrop.FlightDestination = table.makePermanent
{
};

-- Tells the ship to just fly to this location. Immediately begins executing the next destination upon arrival.
function AirDrop.FlightDestination:MakeFlyToDestination(location:matrix):table
	local dest:table = setmetatable({}, {__index = AirDrop.FlightDestination});
	dest.flyToLocation = location;
	return dest;
end

-- Creates an object delivery destination from the itemDropLocation that is returned from the drop query.
-- This version will use the calculated ship position from the query to align the ship in the correct location for the drop.
function AirDrop.FlightDestination:MakeObjectDeliveryDestinationFromDropLocation(itemDropLocation:table, cargo:object):table
	local dest:table = AirDrop.FlightDestination:MakeObjectDeliveryDestination(
		itemDropLocation.dropLocation,
		itemDropLocation.dropFromHeight,
		cargo);

	dest:SetShipLocationForDrop(itemDropLocation.shipDropLocation);
	return dest;
end

-- Creates an object delivery destination.
-- Note that this version will just put the ship directly over the dropLocation and won't align the ship to drop the cargo exactly at the drop location.
-- You can control where the ship is positioned for this destination with FlightDestination:SetShipLocationForDrop.
function AirDrop.FlightDestination:MakeObjectDeliveryDestination(dropLocation:matrix, dropFromHeight:number, cargo:object):table
	assert(cargo ~= nil);
	assert(dropFromHeight > 0.0);

	local dest:table = setmetatable({}, {__index = AirDrop.FlightDestination});
	dest.dropLocation = dropLocation;
	dest.dropFromHeight = dropFromHeight;
	dest.cargo = cargo;
	return dest;
end

-- Creates a passenger delivery destination from the itemDropLocation that is returned from the drop query.
-- This version will use the calculated ship position from the query to align the ship in the correct location for the drop.
-- seatPreference enum is PASSENGER_SEAT_PREFERENCE. 
-- Options are: Left, Right, Both, Center. If both is selected the left side will be loaded first.
function AirDrop.FlightDestination:MakePassengerDeliveryDestinationFromDropLocation(itemDropLocation:table, passengers:object_list, seatPreference:passenger_seat_preference):table
	local dest:table = AirDrop.FlightDestination:MakePassengerDeliveryDestination(
		itemDropLocation.dropLocation,
		itemDropLocation.dropFromHeight,
		passengers,
		seatPreference);

	dest:SetShipLocationForDrop(itemDropLocation.shipDropLocation);
	return dest;
end

-- Note that this version will just put the ship directly over the dropLocation and won't align the ship to drop the cargo exactly at the drop location.
-- You can control where the ship is positioned for this destination with FlightDestination:SetShipLocationForDrop.
-- seatPreference enum is PASSENGER_SEAT_PREFERENCE. 
-- Options are: Left, Right, Both, Center. If both is selected the left side will be loaded first.
function AirDrop.FlightDestination:MakePassengerDeliveryDestination(
	dropLocation:matrix,
	dropFromHeight:number,
	passengers:object_list,
	seatPreference:passenger_seat_preference):table

	assert(passengers ~= nil);
	assert(dropFromHeight > 0.0);

	local dest:table = setmetatable({}, {__index = AirDrop.FlightDestination});
	dest.dropLocation = dropLocation;
	dest.dropFromHeight = dropFromHeight;
	dest.cargo = passengers;
	dest.cargoType = CARGO_TYPE.Passengers;
	dest.passengerSeatPreference = seatPreference;
	return dest;
end

-- Sets where the ship should be located for this destination.
function AirDrop.FlightDestination:SetShipLocationForDrop(shipLocation:matrix):void
	self.shipDropLocation = shipLocation;
end

-- Not currently implemented.
function AirDrop.FlightDestination:SetSecondsToArrive(secondsToArrive:number):void
	assert(secondsToArrive > 0.0);
	self.secondsToArrive = secondsToArrive;
end

------------------------------------------------------------------------------------------
-- Flight
------------------------------------------------------------------------------------------

-- https://halolibrary/display/CD/Air+Drop+System#AirDropSystem-AirDrop.Flight
AirDrop.Flight = table.makePermanent
{
	flightHandle = nil
};

-- Caller is responsible for spawning the pilot and ship when using this constructor.
function AirDrop.Flight:New(pilotInstance:object, shipInstance:object, name:string_id):table
	local flight:table = setmetatable({}, {__index = AirDrop.Flight});
	flight.flightHandle = AirDrop_CreateFlight(pilotInstance, shipInstance, name);
	return flight;
end

-- Creates a flight with the drop ship/pilot specified in the route query. This function will handle spawning
-- both the ship and the pilot.
function AirDrop.Flight:CreateFromRouteQuery(routeQueryHandle:handle, name:string_id):table
	local flight:table = setmetatable({}, {__index = AirDrop.Flight});
	flight.flightHandle = AirDrop_CreateFlightFromRouteQuery(routeQueryHandle, name);
	return flight;
end

function AirDrop.Flight:CreateFromRouteQueryWithExistingShip(routeQueryHandle:handle, pilotInstance:object, shipInstance:object, name:string_id):table
	local flight:table = setmetatable({}, {__index = AirDrop.Flight});
	flight.flightHandle = AirDrop_CreateFlightFromRouteQueryWithExistingShip(routeQueryHandle, pilotInstance, shipInstance, name);
	return flight;
end

-- Tries to get the active flight associated with a squad spawner.
-- IsValid should be checked to ensure a valid flight was found.
function AirDrop.Flight:GetFromSquadSpawner(spawner):table
	local flight:table = setmetatable({}, {__index = AirDrop.Flight});
	flight.flightHandle = AirDrop_GetFlightFromSquadSpawner(spawner);
	return flight;
end

function AirDrop.Flight:IsValid():boolean
	if self.flightHandle ~= nil then
		return AirDrop_IsFlightValid(self.flightHandle);
	end

	return false;
end

-- Takes an AirDrop.FlightDestination table as an argument.
-- Returns a boolean indicating if the destination was successfully added to the flight.
function AirDrop.Flight:AddDestination(destination:table):boolean
	assert(destination ~= nil);
	return AirDrop_AddDestinationToFlight(self.flightHandle, destination);
end

-- Tells the flight to starting running operations. Once this has been called no more cargo can be added to the flight.
function AirDrop.Flight:TakeOff():void
	assert(self.flightHandle ~= nil);
	AirDrop_FlightTakeOff(self.flightHandle);
	self.hasTakenOff = true;
end

function AirDrop.Flight:HasTakenOff():boolean
	return self.hasTakenOff or false;
end

-- Destroys the flight, ship, pilot and cargo unless ejectCargo is true.
function AirDrop.Flight:Destroy(ejectCargo:boolean):void
	AirDrop_DestroyFlight(self.flightHandle, ejectCargo);
	self.flightHandle = nil;
end

function AirDrop.Flight:GetDropShip()
	if self.flightHandle ~= nil then
		return AirDrop_GetDropShipFromFlight(self.flightHandle);
	end

	return nil;
end