-- object primitive_ammo_container : communication_object_base_class

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');
REQUIRES('scripts\ParcelLibrary\parcel_interactive.lua');
REQUIRES('scripts\ParcelLibrary\parcel_refillable.lua');

hstructure primitive_ammo_container : communication_object_base_class
	currentCharge : number						--$$ METADATA {"prettyName": "Current Charge", "tooltip": "The amount of charge the container has. Once it reaches 0, it cannot provide any ammo.", "min": 0.0, "max": 1.0 } 
	infiniteAmmo : boolean						--$$ METADATA {"prettyName": "Infinite Ammo", "tooltip": "The container has infinite ammo." } 
	interactMarkerOverride : string				--$$ METADATA {"prettyName": "Interact Marker Override", "tooltip": "An optional override to define the marker where the device control is."}
	interactFailMarkerOverride : string			--$$ METADATA {"prettyName": "Interact Fail Marker Override", "tooltip": "An optional override to define the marker where the device control is."}

	actionStringID:string;						--$$ METADATA {"prettyName": "Action String ID", "tooltip": "An optional override to define the action string for the ammo container."}
end

global g_ammoCrateNodeGraphEvents = table.makePermanent
{
	ammoPickUp = "audio_object_ammocrate_interact"
};

global AmmoContainerParcel:table = CommNodeBaseParcel:CreateParcelInstance();

AmmoContainerParcel.CONST = 
{
	defaultInteractMarker = "interact",
	defaultInteractFailMarker = "interact_fail",
	defaultActiveStringID = "generic_activate",
	minCharge = 0,
	maxCharge = 1,
	interactFilterRadiusSq = 2 ^ 2
};

function primitive_ammo_container:__DebugImgui()
	local parcel:table = self.parcelInstance;
	imguiVars.standardTwoItemInfo("Current Charge:", parcel.currentCharge);
	communication_object_base_class.__DebugImgui(self);
end

function primitive_ammo_container:init()
	local variantId = ObjectGetVariant(self);
	local parcelName:string = "AmmoContainer_"..tostring(self);
	if variantId ~= nil then
		local parcel:table = AmmoContainerParcel:New(self);

		parcel.variantId = variantId;
		parcel:SetInitialStateDeterminedFunction(parcel.OnInitialStateDetermined);

		self:ParcelAddAndStartOnSelf(parcel, parcelName);
	else
		self:DebugPrint(parcelName, "did not have variant assigned, aborting initialization");
	end
end

function AmmoContainerParcel:OnInitialStateDetermined():void
	self.currentCharge = self.managedObject.currentCharge or self.CONST.maxCharge;
	self.infiniteAmmo = self.managedObject.infiniteAmmo or false;
	self.actionStringID = self.managedObject.actionStringID or self.CONST.actionStringID;
	self.interactObject = Object_GetObjectAtMarker(self.managedObject, self.interactMarkerOverride or self.CONST.defaultInteractMarker);
	self.interactFailObject = Object_GetObjectAtMarker(self.managedObject, self.interactFailMarkerOverride or self.CONST.defaultInteractFailMarker);

	if self.interactObject ~= nil then
		local interactiveParcel:table = InteractiveParcel:New(self.interactObject);

		if interactiveParcel ~= nil then
			interactiveParcel:SetDevicePower(self:HaveAmmo() and 1 or 0);
			interactiveParcel:AddOnInteractCallback(self, self.OnInteract);
			self:StartChildParcel(interactiveParcel, interactiveParcel.instanceName);
			self.interactiveParcelInstance = interactiveParcel;
		end

		local refillableParcel:table = RefillableParcel:New();

		if refillableParcel ~= nil then
			refillableParcel:AddOnMagazineAmmoRefilledCallback(self, self.OnAmmoRefilled);
			refillableParcel:AddOnBackpackAmmoRefilledCallback(self, self.OnAmmoRefilled);
			self.refillableParcelInstance = refillableParcel;
		end
	end

	self:UpdateVisualState();
	self.updateInteractPromptThread = self:CreateThread(self.UpdateInteractPromptThread);

	self:DebugPrint("Ammo Container: Current charge is: ", self.currentCharge);
end

function AmmoContainerParcel:OnInteract(eventArgs:InteractEventStruct)
	self:CreateThread(self.OnInteractThread, eventArgs);
end

function AmmoContainerParcel:OnInteractThread(eventArgs:InteractEventStruct):void
	if self.refillableParcelInstance ~= nil then
		local interactingUnit = eventArgs.interacter;
		local weapons = { Unit_GetPrimaryWeapon(interactingUnit), Unit_GetBackpackWeapon(interactingUnit) }
		
		for _, weapon in hpairs(weapons) do
			if weapon ~= nil and Object_CanRefillWeaponAmmo(self.managedObject, weapon) == true then
				-- Adding this so that way we're not getting the definition every time for no reason
				if self.managedObject.debugPrint == true then
					self:DebugPrint("Attempting to refill: ", Object_GetDefinition(weapon))
				end

				local isMagazineBased = self.refillableParcelInstance:IsMagazineBased(weapon);
				local maxBackpackRounds = Weapon_GetMaxRounds(weapon, 0);

				if self:HaveAmmo() then
					local remainingBackpackPercentage = self.refillableParcelInstance:GetRemainingBackpackAmmoPercentage(weapon);
					local minimumFillThreshold =  1;

					if self.refillableParcelInstance:IsMagazineBased(weapon) then
						minimumFillThreshold =  1 / maxBackpackRounds;
					end

					local backpackFillPercentage = 100 - remainingBackpackPercentage;
					
					-- If the weapon needs backpack ammo and is less than the minimum fill threshold
					-- It means that the proportion was slightly under what would count as "1" ammo
					-- So let's at least give the player 1 ammo
					if backpackFillPercentage > 0 and backpackFillPercentage < minimumFillThreshold then
						backpackFillPercentage = minimumFillThreshold;
					end

					if self.managedObject.debugPrint == true then
						if isMagazineBased then
							self:DebugPrint("Remaining Backpack Ammo: ", remainingBackpackPercentage, "%");
						else
							self:DebugPrint("Current Weapon Age: ", remainingBackpackPercentage, "%");
						end
					end

					local chargePercentage = self.currentCharge * 100;

					if chargePercentage < backpackFillPercentage then
						self:DebugPrint("Don't have enough charge to refill all. Refilling ", chargePercentage, "%");
						backpackFillPercentage = chargePercentage;
					end

					if backpackFillPercentage > 0 then
						if isMagazineBased then
							self:DebugPrint("Refilling missing", backpackFillPercentage, "% of backpack ammo.");
						else
							self:DebugPrint("Refilling missing", backpackFillPercentage, "% of ammo.");
						end
					
						self.refillableParcelInstance:RefillBackpackAmmo(weapon, interactingUnit, backpackFillPercentage);
						self:DebugPrint("Reducing ammo container charge by ", backpackFillPercentage, "%.");
						self:UpdateCharge((chargePercentage - backpackFillPercentage) / 100);
					end
				else
					break;
				end
			end	
		end
	end
end

function AmmoContainerParcel:OnAmmoRefilled(amount:number, optionalWeaponOwner:object)
	local ownerPlayer:player = Unit_GetPlayer(optionalWeaponOwner);

	if ownerPlayer ~= nil then
		RunClientScript("AmmoCrateSendNodeGraphEvent", optionalWeaponOwner, g_ammoCrateNodeGraphEvents.ammoPickUp);
	end
end

function AmmoContainerParcel:UpdateCharge(newCharge:number):void	
	-- The new charge amount based on the amount used to refill the weapon(s), capped from 0 to the max charge the crate can have
	local newChargeAmount = math.Bound(newCharge, self.CONST.minCharge, self.CONST.maxCharge);

	if self.currentCharge ~= newChargeAmount then
		if not self.infiniteAmmo then
			self:DebugPrint("Ammo Container: Charge Remaining: ", self.currentCharge);
			self.currentCharge = newChargeAmount;
		else	
			self:DebugPrint("Ammo Container: Has infinite ammo - charge level not updated ");
		end

		self:UpdateVisualState();
		
		if self.interactiveParcelInstance ~= nil then
			local haveAmmo = self:HaveAmmo();

			self.interactiveParcelInstance:SetDevicePower(haveAmmo and 1 or 0);

			if not haveAmmo and self.updateInteractPromptThread ~= nil then
				self:KillThread(self.updateInteractPromptThread);
				self.updateInteractPromptThread = nil;
			end
		end
	end
end

function AmmoContainerParcel:UpdateInteractPromptThread():void
	Object_Filter_RemoveAllFilters(self.interactObject);
	Object_Filter_RemoveAllFilters(self.interactObjectFail);

	local interactFilter:player_interaction_filter = Object_Filter_CreatePlayerMaskFilter(self.interactObject);
	local interactFailFilter:player_interaction_filter = Object_Filter_CreatePlayerMaskFilter(self.interactFailObject);
	local sleepyTime:number = real_random_range(0.1, 0.2);

	repeat
		--[[ local sleepDistanceScalar:number = 1;
		local nearbyPlayers:object_list = GetPlayersWithinSquaredRadiusOfLocation(ToLocation(self.managedObject), self.CONST.interactFilterRadiusSq);

		if #nearbyPlayers > 0 then
			for _, targetPlayer in ipairs(nearbyPlayers) do

				local primaryWeapon = Unit_GetPrimaryWeapon(targetPlayer);
				local backpackWeapon = Unit_GetBackpackWeapon(targetPlayer);
				local canRefillPrimary = false;
				local canRefillBackpack = false;
				if primaryWeapon ~= nil then
					canRefillPrimary = Object_CanRefillWeaponAmmo(self.managedObject, primaryWeapon) and
										self.refillableParcelInstance:GetRemainingBackpackAmmoPercentage(primaryWeapon) < 100;
				end
				if backpackWeapon ~= nil then
					canRefillBackpack = Object_CanRefillWeaponAmmo(self.managedObject, backpackWeapon) and
										self.refillableParcelInstance:GetRemainingBackpackAmmoPercentage(backpackWeapon) < 100;
				end
				local canRefill = canRefillPrimary or canRefillBackpack;
				local typesMatch = Object_WeaponRefillSettingsMatch(self.managedObject, primaryWeapon) or
					Object_WeaponRefillSettingsMatch(self.managedObject, backpackWeapon);
				Object_Filter_SetPlayer(
					self.interactObject,
					interactFilter,
					targetPlayer, 
					canRefill);
				--If types match use secondary flag.
				device_control_set_use_secondary_strings(self.interactFailObject, typesMatch);
				--If we cannot refill, use failed device control
				Object_Filter_SetPlayer(
					self.interactFailObject,
					interactFailFilter,
					targetPlayer, 
					not canRefill);
			end
		else
			local shortestDistance:number = GetShortestSquaredDistanceBetweenLocationAndAnyPlayer(self.managedObject);

			if shortestDistance > 0 then
				sleepDistanceScalar = shortestDistance / self.CONST.interactFilterRadiusSq;
			end
		end ]]

		local closestDistance:number = math.huge;
		for _, targetPlayer in hpairs(PLAYERS.active) do
			local distSq = Object_GetDistanceSquaredToObject(targetPlayer, self.managedObject);
			if distSq ~= -1 then
				closestDistance = math.min(closestDistance, distSq);
		
				if distSq <= self.CONST.interactFilterRadiusSq then
					local primaryWeapon = Unit_GetPrimaryWeapon(targetPlayer);
					local backpackWeapon = Unit_GetBackpackWeapon(targetPlayer);
					local canRefillPrimary = false;
					local canRefillBackpack = false;
					if primaryWeapon ~= nil then
						canRefillPrimary = Object_CanRefillWeaponAmmo(self.managedObject, primaryWeapon) and
											self.refillableParcelInstance:GetRemainingBackpackAmmoPercentage(primaryWeapon) < 100;
					end
					if backpackWeapon ~= nil then
						canRefillBackpack = Object_CanRefillWeaponAmmo(self.managedObject, backpackWeapon) and
											self.refillableParcelInstance:GetRemainingBackpackAmmoPercentage(backpackWeapon) < 100;
					end
					local canRefill = canRefillPrimary or canRefillBackpack;
					local typesMatch = Object_WeaponRefillSettingsMatch(self.managedObject, primaryWeapon) or
						Object_WeaponRefillSettingsMatch(self.managedObject, backpackWeapon);
					Object_Filter_SetPlayer(
						self.interactObject,
						interactFilter,
						targetPlayer, 
						canRefill);
					--If types match use secondary flag.
					device_control_set_use_secondary_strings(self.interactFailObject, typesMatch);
					--If we cannot refill, use failed device control
					Object_Filter_SetPlayer(
						self.interactFailObject,
						interactFailFilter,
						targetPlayer, 
						not canRefill);
				end
			end
		end

		local sleepDistanceScalar:number = Clamp(closestDistance / self.CONST.interactFilterRadiusSq, 1, 100);
		SleepSeconds(sleepyTime * sleepDistanceScalar);
	until false;
end

function AmmoContainerParcel:UpdateVisualState():void
	local chargeFraction = self.currentCharge / self.CONST.maxCharge;
	object_set_function_variable(self.managedObject, "ammo_count", chargeFraction, .2);
	ObjectSetSpartanTrackingEnabled(self.managedObject, self:HaveAmmo());
end

function AmmoContainerParcel:HaveAmmo():boolean
	return self.currentCharge > 0;
end

--## CLIENT

function remoteClient.AmmoCrateSendNodeGraphEvent(unit:object, evt:string_id)
	--send the nodegraph event to the player biped
	ObjectNodeGraph_NotifyGetGameEventNode(unit, evt);	
end