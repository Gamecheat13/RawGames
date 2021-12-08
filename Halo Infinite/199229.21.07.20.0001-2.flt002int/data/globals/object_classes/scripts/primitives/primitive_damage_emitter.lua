-- object primitive_damage_emitter : communication_object_base_class
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');

hstructure primitive_damage_emitter : communication_object_base_class
end

global DamageEmitterParcel = CommNodeBaseParcel:CreateParcelInstance();

function primitive_damage_emitter:init():void
	local variantId = ObjectGetVariant(self);
	local parcelName:string = "DamageEmitter_"..tostring(self);

	if variantId ~= nil then
		-- Create the parcel
		local parcel:table = DamageEmitterParcel:New(self);
		parcel.variantId = variantId;

		parcel:SetRunFunction(parcel.OnStart);
		parcel:SetActivatedUpdateFunction(parcel.OnActivatedUpdate);
	
		self:ParcelAddAndStartOnSelf(parcel, parcelName);
	else
		print(parcelName, "did not have variant assigned, aborting initialization");
	end
end

-- Parcel Overrides

function DamageEmitterParcel:OnStart():void
	self.unitsInsideEmitter = SetClass:New();
	self:RegisterEventOnSelf(g_eventTypes.phantomEnteredEvent, self.OnObjectEntered, self.managedObject);
	self:RegisterEventOnSelf(g_eventTypes.phantomExitedEvent, self.OnObjectExited, self.managedObject);
end

function DamageEmitterParcel:OnActivatedUpdate():void
	object_set_phantom_power(self.managedObject, self.isActivated);
	if self.unitsInsideEmitter:Count() > 0 then
		self:UpdateIsDamagingObjectFunction(self.isActivated);
	end
end

-- Class Functions

function DamageEmitterParcel:OnObjectEntered(eventArgs:PhantomEnteredEventStruct)
	if Object_IsUnit(eventArgs.enteringObject) then
		self.unitsInsideEmitter:Insert(eventArgs.enteringObject);
		self:UpdateIsDamagingObjectFunction(self.isActivated);
	end
end

function DamageEmitterParcel:OnObjectExited(eventArgs:PhantomExitedEventStruct)
	self.unitsInsideEmitter:Remove(eventArgs.exitingObject);
	if self.unitsInsideEmitter:Count() == 0 then
		self:UpdateIsDamagingObjectFunction(false);
	end
end

function DamageEmitterParcel:UpdateIsDamagingObjectFunction(on:boolean)
	Object_SetFunctionValue(self.managedObject, "isdamaging", on and 1 or 0, 0);	
end