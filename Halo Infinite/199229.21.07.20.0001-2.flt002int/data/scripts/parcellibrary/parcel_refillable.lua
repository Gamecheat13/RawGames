-- Copyright (c) Microsoft. All rights reserved.

-- Reach out to the Sandbox Objects team if you have any questions

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalObjectCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');

-- The Attachable Parcel provides an easy way of handling dynamic attachments

global RefillableParcel:table = Parcel.MakeParcel
{
	-- Required: Do not modify outside of class
	isComplete = false,
	EVENTS =
	{
		onMagazineAmmoRefilled = "OnMagazineAmmoRefilled",
		onBackpackAmmoRefilled = "OnBackpackAmmoRefilled",
	}
}

-- Constructor

function RefillableParcel:New():table
	local parcel = nil;

	parcel = self:CreateParcelInstance();
	parcel.isComplete = false;
	parcel.instanceName = "RefillableParcel_"..tostring(self);

	return parcel;
end

-- Class Functions: Public

-- Required Parcel Overrides: Needed in order for the parcel to be instantiated and work properly

function RefillableParcel:shouldEnd():boolean
	return self.isComplete;
end

function RefillableParcel:Run():void
	return;
end

-- Getters

-- Returns a value between 0-100 that represents the percentage or -1 if something is invalid
function RefillableParcel:GetRemainingMagazineAmmoPercentage(weapon:object):number
	if not self:IsWeapon(weapon) then return -1; end

	local amountRemaining = 100;

	if self:IsMagazineBased(weapon)  then
		local maxMagazineRounds = Weapon_GetMagazineMaximumRounds(weapon, 0);
		local currentMagazineRounds = WeaponGetRoundsInMagazine(weapon, 0);

		if currentMagazineRounds < maxMagazineRounds then
			amountRemaining = (currentMagazineRounds / maxMagazineRounds) * 100;
		end
	else
		local currentWeaponAge = weapon_get_age(weapon);
		if currentWeaponAge > 0 then
			amountRemaining = (1 - currentWeaponAge) * 100;
		end
	end

	return amountRemaining;
end

-- Returns a value between 0-100 that represents the percentage or -1 if something is invalid
function RefillableParcel:GetRemainingBackpackAmmoPercentage(weapon:object):number
	if not self:IsWeapon(weapon) then return -1; end

	if not self:IsMagazineBased(weapon) then
		return self:GetRemainingMagazineAmmoPercentage(weapon);
	end

	-- The maximum amount the player can hold in their backpack
	local maxBackpackAmount = Weapon_GetMaxRounds(weapon, 0);

	-- The current backpack ammo, (current magazine + backpack) - (current magazine)
	local currentBackpackAmmoAmount = weapon_get_rounds_total(weapon, 0) - WeaponGetRoundsInMagazine(weapon, 0);
	local amountRemaining = (currentBackpackAmmoAmount / maxBackpackAmount) * 100;

	return amountRemaining;
end

function RefillableParcel:GetMissingMagazineAmmoAmount(weapon:object):number
	if self:IsMagazineBased(weapon)  then
		local maxMagazineRounds = Weapon_GetMagazineMaximumRounds(weapon, 0);
		return maxMagazineRounds - WeaponGetRoundsInMagazine(weapon, 0);
	else
		return weapon_get_age(weapon) * 100;
	end
end

-- Core Functions

function RefillableParcel:RefillMagazineAmmo(weapon:object, optionalAmount:number, optionalWeaponOwner:object):void
	if not self:IsWeapon(weapon) then return; end

	local amountRemaining =  self:GetRemainingMagazineAmmoPercentage(weapon);
	local percentageToFill = 100 - amountRemaining;

	if optionalAmount ~= nil then
		percentageToFill = math.ceil(math.Bound(optionalAmount, 0, 100));
	end

	-- If we have to replenish the weapon...
	if percentageToFill > 0 then
		if self:IsMagazineBased(weapon) then
			weapon_set_current_amount(weapon, (amountRemaining + percentageToFill) / 100);	
		else
			-- If it's age based, set the new age
			-- Note that it's possible to have an age-based weapon that has a magazine but in the overwhelming majority of cases, this is not true
			-- If that case comes up, we need a more robust way of handling that behavior
						
			local newAge = weapon_get_age(weapon) - (percentageToFill / 100);
			weapon_set_age(weapon, newAge);
		end	

		self:OnMagazineAmmoRefilled(percentageToFill, optionalWeaponOwner);
	end
end

function RefillableParcel:RefillBackpackAmmo(weapon:object, weaponOwner:object, optionalAmount:number)
	if not self:IsWeapon(weapon) then return; end

	if not self:IsMagazineBased(weapon) then
		self:RefillMagazineAmmo(weapon, optionalAmount, weaponOwner);
		return;
	end

	if weaponOwner == nil then
		dprint("RefillableParcel:No owner. Can't refill backpack ammo")
		return;
	end

	local weaponSlotType = nil;
	
	if Unit_GetPrimaryWeapon(weaponOwner) == weapon then
		weaponSlotType = RESPAWN_WEAPON_SLOT.Primary;
	else
		weaponSlotType = RESPAWN_WEAPON_SLOT.Backpack;
	end

	local percentageToFill = 100 - self:GetRemainingBackpackAmmoPercentage(weapon);

	if optionalAmount ~= nil then
		percentageToFill = math.ceil(math.Bound(optionalAmount, 0, 100));
	end

	if percentageToFill > 0 then
		Unit_AddAmmo(weaponOwner, weaponSlotType, percentageToFill / 100);

		self:OnBackpackAmmoRefilled(percentageToFill, weaponOwner);
	end
end

function RefillableParcel:EndParcel()
	self.isComplete = true;
end

-- Events

function RefillableParcel:AddOnMagazineAmmoRefilledCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onMagazineAmmoRefilled, callbackFunc, callbackOwner);
	end
end

function RefillableParcel:RemoveMagazineAmmoRefilledCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onMagazineAmmoRefilled, callbackFunc, callbackOwner);
	end
end

function RefillableParcel:AddOnBackpackAmmoRefilledCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onBackpackAmmoRefilled, callbackFunc, callbackOwner);
	end
end

function RefillableParcel:RemoveBackpackAmmoRefilledCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:EventCallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onBackpackAmmoRefilled, callbackFunc, callbackOwner);
	end
end


-- Helpers

function RefillableParcel:EventCallbackArguementsValid(callbackOwner:object, callbackFunc):boolean
	if callbackOwner == nil then
		dprint("RefillableParcel:EventCallbackArguementsValid: Callback owner is invalid.")
		return false;
	end

	if callbackFunc == nil then
		dprint("RefillableParcel:EventCallbackArguementsValid: Callback function is invalid.")
		return false;
	end

	return true;
end

function RefillableParcel:IsWeapon(someObject:object):boolean
	return Engine_GetObjectType(someObject) == OBJECT_TYPE._object_type_weapon
end

function RefillableParcel:IsMagazineBased(weapon:object):boolean
	-- TODO: Remove this _G check and replace the temp func usage below with Weapon_IsMagazineBased after a green build (4/14)
	local isMagazineBasedFunc = _G["Weapon_IsMagazineBased"];
	if (isMagazineBasedFunc == nil) then
		isMagazineBasedFunc = 
			function (weapon)
				return (not Weapon_IsAgeBased(weapon));
			end
	end
	return self:IsWeapon(weapon) and isMagazineBasedFunc(weapon);
end

-- Class Functions: Private

-- Internal Event Callbacks

function RefillableParcel:OnMagazineAmmoRefilled(amount:number, optionalWeaponOwner:object)
	self:TriggerEvent(self.EVENTS.onMagazineAmmoRefilled, amount, optionalWeaponOwner);
end

function RefillableParcel:OnBackpackAmmoRefilled(amount:number, optionalWeaponOwner:object)
	self:TriggerEvent(self.EVENTS.onBackpackAmmoRefilled, amount, optionalWeaponOwner);
end