-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('scripts\ParcelLibrary\parcel_damageable.lua');

global k_sandboxShieldConstants:table = table.makePermanent
{
	isActiveObjFuncName = "isactive"
}

global VehicleShieldParcel:table = Parcel.MakeParcel
{
}

VehicleShieldParcel.CONST = 
{
	shieldFadeInTime = 0.75,
	shieldFadeOutTime = 0.75
}

function VehicleShieldParcel:New(objectInstance:object, markers:table, stunTime:number, driverSeatLabel:string):table
    local parcel:table = self:CreateParcelInstance();
	parcel:SetupData(objectInstance, markers, stunTime, driverSeatLabel);
    return parcel;
end

function VehicleShieldParcel:SetupData(objectInstance:object, markers:table, stunTime:number, driverSeatLabel:string)
	self.isComplete = false;
	self.vehicle = objectInstance;
	self.vehicleBase = Object_GetParent(self.vehicle);
	self.markers = markers;
	
	self.damageableParcelTable = {};
	self.threadsTable = {};
	self.objectsTable = {};

	self.stunTime = stunTime;
	self.driverSeatLabel = driverSeatLabel;

	self.shieldThread = nil;
	self.empThread = nil;
end
 
function VehicleShieldParcel:shouldEnd():boolean
	return object_index_valid(self.vehicle) == false or Object_GetHealth(self.vehicle) <= 0;
end


function VehicleShieldParcel:shouldStop():boolean
	return object_index_valid(self.vehicle) == false or Object_GetHealth(self.vehicle) <= 0;
end

function VehicleShieldParcel:Run()
	-- Seat Events
	ParcelRegisterEvent(self, g_eventTypes.seatEnteredEvent, self.OnSeatEntered, self.vehicleBase, self);
	ParcelRegisterEvent(self, g_eventTypes.seatExitedEvent, self.OnSeatExited, self.vehicleBase, self);

	-- Dameagable Parcel Setup
	for insertIndex, marker in hpairs(self.markers) do
		if object_index_valid(self.vehicle) then
			local shieldObject:object = object_at_marker(self.vehicle, marker);
			if object_index_valid(shieldObject) then
				self:CreateDamageableParcel(shieldObject, self.markers[insertIndex]);
				self:DestroyShield(self.markers[insertIndex]);
			end
		end
	end

	-- EMP Monitoring Setup
	self:RegisterEventOnSelf(g_eventTypes.objectDamagedEvent, self.OnVehicleDamaged, self.vehicleBase);
end

-- Seat Events

function VehicleShieldParcel.OnSeatEntered(seatEnteredEventArgs:SeatEnteredEventStruct, self:table):void
	-- Hacking this for E3
	--if seatEnteredEventArgs.seatLabel == self.driverSeatLabel then
	if not object_index_valid(self.vehicle) then
		return;
	end
	
	if vehicle_test_seat_unit (self.vehicle, self.driverSeatLabel, seatEnteredEventArgs.instigator) then
		self:RegenerateAllShields();
	end
	self.shieldThread = self:CreateThread(self.BlendIsActiveObjFunc, self.vehicle);
end

function VehicleShieldParcel.OnSeatExited(seatExitedEventArgs:SeatExitedEventStruct, self:table):void
	-- Hacking this for E3
	--if seatExitedEventArgs.seatLabel == self.driverSeatLabel then
	if not object_index_valid(self.vehicle) then
		return;
	end

	self:DestroyAllShields();
	self:KillThread(self.shieldThread);
	self.shieldThread = nil;
end

-- Damage Events

function VehicleShieldParcel:OnShieldDamaged(damagedEvent):void
	-- damagedEvent.defender didn't exist in playthrough of Boss HQ Exterior
	if object_index_valid(damagedEvent.defender) == false then
		print("[VehicleShieldParcel - OnShieldDamaged] Validation Error: damagedEvent.defender is nil or invalid.");
		return;
	end

	local currentHealth = object_damage_section_get_health(damagedEvent.defender, "shield");
	local marker = self.objectsTable[damagedEvent.defender];

	if currentHealth ~= nil then				
		self:KillThread(self.threadsTable[marker]);
		self.threadsTable[marker] = nil;
		if currentHealth <= 0  then
			self:DestroyedShieldSequence(marker);
		else
			self.threadsTable[marker] = self:CreateThread(self.RechargeShieldSequence, marker)
		end
	end
end

function VehicleShieldParcel:OnVehicleDamaged(damagedEvent):void
	if self:IsEmpActive() and not IsThreadValid(self.empThread) then
		self.empThread = self:CreateThread(self.EmpSequence);
	end
end

-- Shield Helpers
function VehicleShieldParcel:RechargeShieldSequence(marker:string):void
	SleepSeconds(self.stunTime);
	self:DestroyShield(marker);

	local damageParcel = self.damageableParcelTable[marker];

	SleepUntil ([| damageParcel:IsManagedObjectValid() == false], 0.1);

	self:RegenerateShield(marker);
end

function VehicleShieldParcel:DestroyedShieldSequence(marker:string):void
	self:DestroyShield(marker);
	SleepSeconds(self.stunTime);
	self:RegenerateShield(marker);
end

function VehicleShieldParcel:DestroyShield(marker:string):void
	local damageParcel:table = self.damageableParcelTable[marker]
	if table.contains(self.objectsTable, damageParcel.managedObject) then 
		table.removeValue(self.objectsTable, damageParcel.managedObject)
	end
	Object_SetFunctionValue(damageParcel.managedObject, k_sandboxShieldConstants.isActiveObjFuncName, 0, 0);
	damageParcel:DestroyManagedObject();
end

function VehicleShieldParcel:RegenerateShield(marker:string):void
	if self:IsEmpActive() or Vehicle_HasEmptySeat(self.vehicle, "", VEHICLE_SEAT.Driver) then
		return;
	end

	local damageParcel:table = self.damageableParcelTable[marker];

	if not damageParcel:IsManagedObjectValid() and damageParcel:RespawnManagedObject() == true then
		if object_index_valid(self.vehicle) then
			objects_physically_attach(self.vehicle, marker, damageParcel.managedObject, nil);
		end
		Object_SetFunctionValue(damageParcel.managedObject, k_sandboxShieldConstants.isActiveObjFuncName, 0, 0);
		Object_SetFunctionValue(damageParcel.managedObject, k_sandboxShieldConstants.isActiveObjFuncName, 1, self.CONST.shieldFadeInTime);
		self.objectsTable[damageParcel.managedObject] = marker;
	end
end

function VehicleShieldParcel:DestroyAllShields():void
	for marker, damageableParcel in hpairs(self.damageableParcelTable) do
		if damageableParcel:IsManagedObjectValid() then
			self:DestroyShield(marker)
		end
	end
end

function VehicleShieldParcel:RegenerateAllShields():void
	for marker, damageableParcel in hpairs(self.damageableParcelTable) do
		if not damageableParcel:IsManagedObjectValid() then
			self:RegenerateShield(marker)
		end
	end
end

-- EMP Helpers
function VehicleShieldParcel:IsEmpActive():boolean
	local isEmpActive:boolean = false;
	if object_get_function_value(self.vehicleBase, "emp_disabled") >= 1.0 then
		isEmpActive = true;
	end
	return isEmpActive
end

function VehicleShieldParcel:EmpSequence():void
	self:DestroyAllShields();

	SleepUntil([| object_get_function_value(self.vehicleBase, "emp_disabled") == 0 ], 1);

	-- Regenerate all shields instead of keeping individual delays as shields matching EMP state matched expectation. Players can already cheat shield time by getting out and getting back in
	self:RegenerateAllShields();
end

-- Generic Helpers

function VehicleShieldParcel:CreateDamageableParcel(shieldObject:object, marker:string):void
	local damageableParcel:table = DamageableParcel:New(shieldObject);
	local parcelName:string = "DamageableParcel_" .. marker .. "_" .. tostring(damageableParcel);

	objects_physically_attach(self.vehicle, marker, shieldObject, nil);
	self.damageableParcelTable[marker] = damageableParcel;
 
	damageableParcel:SetDestroyParcelOnObjectDeletion(false);
	damageableParcel:AddOnObjectDamagedCallback(self, self.OnShieldDamaged);

	self:StartChildParcel(damageableParcel, parcelName);
end


function VehicleShieldParcel:BlendIsActiveObjFunc(vehicle:object):void

	SleepUntil([| object_get_function_value(vehicle, k_sandboxShieldConstants.isActiveObjFuncName) == 1 ], 1);

	SleepUntil([| object_get_function_value(vehicle, k_sandboxShieldConstants.isActiveObjFuncName) < 1 ], 1);

	for _, marker in hpairs(self.markers) do
 		-- Adding due to nil self.vehicle via AutomationFramework.Tests.Bvt.GameTests.ReusableEngineTests.CampaignSmokeTests(Test).RunCampaignSmokeTestDefaultAsync("OdinVisit","ArmorLockerSmokeTests.Visit(\"Odin\")",AnyPC)
		if object_index_valid(self.vehicle) == true then
			local shieldObject:object = object_at_marker(self.vehicle, marker);
			Object_SetFunctionValue(shieldObject, k_sandboxShieldConstants.isActiveObjFuncName, 0, self.CONST.shieldFadeOutTime);
		else
			print("[VehicleShieldParcel - BlendIsActiveObjFunc] Validation Error: self.vehicle is nil or invalid.");
		end
	end
end

