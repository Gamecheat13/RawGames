-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

------------------------------------------------------------------------------------------
-- AirDropDeliveryItem
------------------------------------------------------------------------------------------

-- NOTE: AirDrop.lua must be included before this file for the AirDrop namespace to be available.
-- Usage Doc: https://halolibrary/display/CD/Air+Drop+System#AirDropSystem-AirDrop.DeliveryItem
REQUIRES('scripts\AirDrop\AirDrop.lua')

AirDrop.DeliveryItem = table.makePermanent
{
};

-- You must provide the dropFromHeight if you just create it from the radius
function AirDrop.DeliveryItem:CreateFromRadius(radius:number, dropFromHeight:number, cargoType:cargo_type):table
	local deliveryItem:table = setmetatable({}, {__index = AirDrop.DeliveryItem});
	deliveryItem.cargoType = cargoType;
	deliveryItem:OverrideRadius(radius);
	deliveryItem:SetDropFromHeight(dropFromHeight);
	return deliveryItem;
end

-- The dropFromHeight will default to that for the corresponding cargo type of the object.
-- Use SetFromFromHeight if you wish to override it.
function AirDrop.DeliveryItem:CreateFromObjectDefinition(objectDefinition:tag):table
	assert(IsValidTag(objectDefinition));
	local deliveryItem:table = setmetatable({}, {__index = AirDrop.DeliveryItem});
	deliveryItem.cargo = objectDefinition;
	return deliveryItem;
end

-- For passenger delivery items, sets what seats the units should occupy (PASSENGER_SEAT_PREFERENCE)
-- Options are: Left, Right, Both, Center. If both is selected the left side will be loaded first.
function AirDrop.DeliveryItem:SetPassengerSeatPreference(seatPreference:passenger_seat_preference):void
	self.passengerSeatPreference = seatPreference;
end

-- Sets the radius of the item. This is used to determine how much area the item occupies when looking
-- for a place to drop it.
function AirDrop.DeliveryItem:OverrideRadius(radius:number):void
	assert(radius > 0.0, "Item radius must be > 0");
	self.radius = radius;
end

-- a default for the cargo type will be used if not specified
function AirDrop.DeliveryItem:SetDropFromHeight(dropFromHeight:number):void
	assert(dropFromHeight > 0.0, "dropFromHeight must be > 0");
	self.dropFromHeight = dropFromHeight;
end

------------------------------------------------------------------------------------------
-- FlightSettings
------------------------------------------------------------------------------------------

AirDrop.FlightSettings = table.makePermanent
{
	travelType = nil, -- airdrop_flight_travel_type
};

-- Makes an immediate flight preset.
-- Fly in: Ship appears above the drop point instantly.
-- Fly out: Ship disappears immediately.
function AirDrop.FlightSettings:MakeImmediate():table
	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Immediate;
	return settings;
end

-- Makes a fast flight preset.
-- Fly in: Ship flies in from directly above.
-- Fly out: Ship flies directly up then disappears.
function AirDrop.FlightSettings:MakeFast():table
	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Fast;
	return settings;
end

-- Makes a custom flight preset.
-- Fly in/out: Ship follows a fancy flight path and can transition.
-- flightPathKit: a kit definition containing flight path splines to choose from.
function AirDrop.FlightSettings:MakeCustom(flightPathKit:tag):table
	assert (flightPathKit ~= nil);
	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Custom;
	settings.flightPathKit = flightPathKit;
	return settings;
end

-- Makes a flight preset with the default flight path kit.
-- Fly in/out: Ship follows a fancy flight path and can transition. If the kit is not found, it will fallback to MakFast()
function AirDrop.FlightSettings:MakeDefault():table
	local flightPathKit:tag = AirDrop_GetDefaultFlightPathKit();

	if (flightPathKit == nil) then
		print("Could not find Default flight path kit, substituting Fast");
		return self:MakeFast();
	end

	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Custom;
	settings.flightPathKit = flightPathKit;
	return settings;
end

-- Makes a custom flight preset, using a spline in the level as the flight path.
-- Fly in/out: Ship follows a fancy flight path and can transition.
-- levelSpline: A spline in the level to use as the flight path.
function AirDrop.FlightSettings:MakeCustomFromLevelSpline(levelSpline:spline_placement):table
	assert(levelSpline ~= nil);
	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Custom;
	settings.flightPathLevelSplines = {};
	settings.flightPathLevelSplines[1] = levelSpline;
	return settings;
end

-- Makes a custom flight preset, using multiple splines in the level as possible flight paths.
-- The paths will be tested and scored like those in a kit and the best will be chosen.
-- Fly in/out: Ship follows a fancy flight path and can transition.
-- levelSpline: A spline in the level to use as the flight path.
function AirDrop.FlightSettings:MakeCustomFromLevelSplines(levelSplines:table):table
	assert(levelSplines ~= nil);
	local settings:table = setmetatable({}, {__index = AirDrop.FlightSettings});
	settings.travelType = AIRDROP_FLIGHT_TRAVEL_TYPE.Custom;
	settings.flightPathLevelSplines = levelSplines;
	return settings;
end

-- The direction it looks like the ship is coming from if entering or where it looks like it's going towards if exiting.
-- Only value for custom flight paths.
function AirDrop.FlightSettings:SetDesiredDestinationDirection(direction:vector):void
	assert(self.travelType == AIRDROP_FLIGHT_TRAVEL_TYPE.Custom);
	self.desiredDestinationDirection = direction;
end

-- Only value for custom flight paths.
-- transitionType: AIRDROP_FLIGHT_TRANSITION_TYPE.None or AIRDROP_FLIGHT_TRANSITION_TYPE.Warp.
-- secondsToTransition: how many seconds the transition should take.
function AirDrop.FlightSettings:SetTransitionData(transitionType:airdrop_flight_transition_type, secondsToTransition:number):void
	assert(self.travelType == AIRDROP_FLIGHT_TRAVEL_TYPE.Custom);
	self.transitionType = transitionType;
	self.secondsToTransition = secondsToTransition;
end

------------------------------------------------------------------------------------------
-- AirDropRouteRequest
------------------------------------------------------------------------------------------

-- https://halolibrary/display/CD/Air+Drop+System#AirDropSystem-AirDrop.RouteRequest
AirDrop.RouteRequest = table.makePermanent
{
	requestName = nil, -- string
	dropShip = nil, -- AirDropShip
	deliveryItems = nil, -- array of AirDropDeliveryItems
	dropZone = nil, -- AirDropZone
	flyInSettings = nil, -- AirDropFlightSettings
	flyOutSettings = nil -- AirDropFlightSettings
};

function AirDrop.RouteRequest:New(name:string_id):table
	local routeRequest:table = setmetatable({}, {__index = AirDrop.RouteRequest});
	routeRequest.requestName = name;
	routeRequest.deliveryItems = {};
	return routeRequest;
end

function AirDrop.RouteRequest:SetDropShip(dropShip:AirDropShip):void
	self.dropShip = dropShip;
end

-- Sets the area to search for drop locations in.
function AirDrop.RouteRequest:SetDropZone(dropZone:AirDropZone):void
	assert(dropZone.range > 0.0, "Drop Zone range must be > 0.");
	self.dropZone = dropZone;
end

-- If this is set the dropZone is ignored and the ship will be positioned above this point.
-- This option also skips any tests to ensure the ship can fit here and that the cargo has a valid place to land.
-- This means it's up to you to ensure this is a valid position.
-- We will still do the flight path tests though to check the ship can arrive from the start location to this point though.
-- Note that with this option all cargo is dropped from this position.
--
-- @param groundDropLocation: Where on the ground the cargo should be dropped. The ship will be positioned above this point by the item's drop from height.
-- If the matrix contains a rotation the ship will also face that direction when dropping off the cargo.
function AirDrop.RouteRequest:UseExactDropLocation(groundDropLocation:matrix):void
	self.exactDropLocation = groundDropLocation;
	self.dropZone = nil;
end

-- Returns the index of the delivery item. This index can be used to look up the corresponding deliveryLocation in the route result.
function AirDrop.RouteRequest:AddDeliveryItem(deliveryItem:table):number
	assert(deliveryItem ~= nil, "deliveryItem must not be nil");
	local count:number = table.getn(self.deliveryItems);
	table.insert(self.deliveryItems, deliveryItem);
	return count + 1;
end

-- Takes an AirDrop.FlightSettings table.
function AirDrop.RouteRequest:SetFlyInSettings(settings:table):void
	self.flyInSettings = settings;
end

-- Takes an AirDrop.FlightSettings table.
function AirDrop.RouteRequest:SetFlyOutSettings(settings:table):void
	self.flyOutSettings = settings;
end