-- object vehicle_shade_shield_helper

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('scripts\ParcelLibrary\parcel_vehicle_shield_manager.lua');

hstructure vehicle_shade_shield_helper
	meta : table
	instance : luserdata
end

-- Object Class

function vehicle_shade_shield_helper:init():void
	local markers:table =
	{
		"front_shield",
		"right_shield",
		"left_shield"
	}

	local stunTime:number = 7;
	local driverSeatLabel:string = "shade_d"
	
	local VehicleShieldParcel = VehicleShieldParcel:New(self, markers, stunTime, driverSeatLabel);
	local parcelName:string = "VehicleShieldParcel"..tostring(VehicleShieldParcel);
	self:ParcelAddAndStartOnSelf(VehicleShieldParcel, parcelName);
end

--## CLIENT
