-- object primitive_gravity_lift : communication_object_base_class

-- Copyright (c) Microsoft. All rights reserved.

-- Reach out to the Sandbox Objects team if you have any questions

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');

hstructure primitive_gravity_lift : communication_object_base_class
end

global GravityLiftParcel = CommNodeBaseParcel:CreateParcelInstance();

function primitive_gravity_lift:init():void
	--Gravity lift height is normalized from 0 - 1000 wu to 0 to 1
	local liftHeight = DistanceBetweenLocations(location(self, "lift_direction"), location(self, "lift_direction_top")) / 1000;
	Object_SetFunctionValue(self, "liftheight", liftHeight, 0);

	local parcel:table = GravityLiftParcel:New(self);
	local parcelName:string = "GravityLift_"..tostring(self);

	if parcel ~= nil then
		parcel:SetControlUpdateFunction(parcel.OnControlUpdate);
		parcel:SetPowerUpdateFunction(parcel.OnPowerUpdate);
		parcel:SetActivatedUpdateFunction(parcel.OnActivatedUpdate);

		self:ParcelAddAndStartOnSelf(parcel, parcelName);
	else
		print(parcelName, "could not be created.")
	end
end

function GravityLiftParcel:OnControlUpdate():void
	self:ChangePowerState(self.isEnabled);
end

function GravityLiftParcel:OnPowerUpdate():void
	self:UpdateState();
end

function GravityLiftParcel:OnActivatedUpdate():void
	self:UpdateState();
end

function GravityLiftParcel:UpdateState():void
	local isPowered = self:IsPowered();

	object_set_phantom_power(self.managedObject, isPowered);
end
