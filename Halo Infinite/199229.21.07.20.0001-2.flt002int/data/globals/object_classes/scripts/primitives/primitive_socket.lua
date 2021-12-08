-- object primitive_socket : communication_object_base_class
-- Copyright (c) Microsoft. All rights reserved.

-- Reach out to the Sandbox Objects team if you have any questions

--## SERVER
REQUIRES('globals\object_classes\scripts\primitives\primitive_socket_object_base_class.lua');

hstructure primitive_socket : communication_object_base_class
	currentPowerLevel:number;              --$$ METADATA {"prettyName": "Current Power Level", "tooltip": "The current power level", "min": 0.0, "max": 1.0}
	oneTimeUse:boolean                     --$$ METADATA {"prettyName": "One Time Use", "tooltip": "Do we only want to interact with (insert or remove from) this socket once?"}               
	requiredCarriableTag:tag;              --$$ METADATA {"prettyName": "Required Carriable Tag", "allowedExtensions": ["weapon"], "tooltip": "The tag required for the player to be able to interact"}
	requiredCarriableVariantId:string;     --$$ METADATA {"prettyName": "Required Carriable Variant ID"}
	createWithCarriableAttached:boolean;   --$$ METADATA {"prettyName": "Spawn and Attach Carriable On Start", "tooltip": "Creates a new object already inserted into the socket"}
	useDeviceInteraction:boolean;			--$$ METADATA {"prettyName": "Use a device for interaction instead of weapon interaction"}
	deviceInteractHoldTime:number;			--$$ METADATA {"prettyName": "Hold time to remove attached object"}
	completedKey:persistence_key;			--$$ METADATA {"prettyName": "Objective Key to set this socket to completed on spawn"}
	setToCompletedKey:persistence_key;		--$$ METADATA {"prettyName": "Set to Completed Key"}
end

global SocketParcel = SocketBaseParcel:CreateParcelInstance();

SocketParcel.CONST = 
{
	 interactMarker = "interact",
	 attachMarker = "battery_attach",
	 attachPointMarker = "root",
	 maxPower = 1,
	 noPower = 0,
	 drainInterval = 1,
	 drainDelay = 2,
	 drainAmount = -0.2,
	 damageChargeAmount = 0.1,
	 filterRadius = 3,
	 filterUpdateIntervalSec = 0.1,
};

function primitive_socket:init():void
	self.currentPowerLevel = self.currentPowerLevel or 0;
	self.oneTimeUse = self.oneTimeUse or false;
	self.useDeviceInteraction = self.useDeviceInteraction or false;
	self.deviceInteractHoldTime = self.deviceInteractHoldTime or 0;

	local variantId = ObjectGetVariant(self);
	local parcelName:string = "Socket_"..tostring(self);

	if variantId ~= nil then
		local parcel:table = SocketParcel:New(self);

		parcel.variantId = variantId;
		parcel.oneTimeUse = self.oneTimeUse;
		parcel.useDeviceInteraction = self.useDeviceInteraction;
		parcel.deviceInteractHoldTime = self.deviceInteractHoldTime;

		parcel:AddRequiredCarriableTag(self.requiredCarriableTag, self.requiredCarriableVariantId);

		parcel:SetRunFunction(parcel.OnStart);
		parcel:SetInitialStateDeterminedFunction(parcel.OnInitialStateDetermined);
		parcel:SetInteractFunction(parcel.OnInteract);
		parcel:SetControlUpdateFunction(parcel.OnControlUpdate)
		parcel:SetOnObjectAttachedFunction(parcel.OnObjectAttached);
		parcel:SetOnObjectDetachedFunction(parcel.OnObjectDetached);
		parcel:SetOnAttachedObjectDeletedFunction(parcel.OnAttachedObjectDeleted);

		self:ParcelAddAndStartOnSelf(parcel, "Socket_"..tostring(self));
	else
		self:DebugPrint(parcelName, "did not have variant assigned, aborting initialization");
	end
end

-- Class Functions: Public
function primitive_socket:SetToCompleted():object
	return self.parcelInstance and self.parcelInstance:SetToCompleted() or nil;
end

function primitive_socket:GetAttachedObject():object
	return self.parcelInstance and self.parcelInstance.attachedObject or nil;
end

-- Setters

function SocketParcel:AdjustPowerLevel(adjustment:number):void
	self:SetPowerLevel(self.currentPowerLevel + adjustment);
end

function SocketParcel:SetPowerLevel(powerLevel:number)
	local newPowerLevel:number = math.min(self.CONST.maxPower, math.max(self.CONST.noPower, powerLevel));
	local hasPower:boolean = newPowerLevel > self.CONST.noPower;

	self.currentPowerLevel = newPowerLevel;

	self:ChangePowerState(hasPower);
	self:BroadcastSend(commObjectChannelsEnum.power, hasPower);
	self:UpdateVisualState();

	if hasPower and not self:HasAttachedObject() and self.drainThread == nil then
		self:CreateDrainThread();
	end
end

function SocketParcel:SetIsEnabled(isEnabled:boolean)
	self:ChangeControlState(isEnabled);
	self:BroadcastSend(commObjectChannelsEnum.control, isEnabled);
end

function SocketParcel:SetCarriableAttached():object
	local managedObject = self.managedObject;
	if managedObject == nil then
		return nil;
	end

	local objectTag:tag = managedObject.requiredCarriableTag;
	local objectVariantID:string = managedObject.requiredCarriableVariantId;
	if IsValidTag(objectTag) then
		if objectVariantID ~= nil then
			return Object_CreateFromTagWithVariant(objectTag, objectVariantID);
		else
			return Object_CreateFromTag(objectTag);
		end
	end
	return nil;
end

function SocketParcel:SetToCompleted():object
	local seedObject = self:SetCarriableAttached();
	self:InsertObject(seedObject);
	self:TurnOffEverything();
	return seedObject;
end
-- Class Functions: Private

-- Initialization

function SocketParcel:InitializeData():void
	self.interactMarker = self.interactMarker or self.CONST.interactMarker;
	self.attachedObject = nil;
	self.interactFilterThread = nil;
	self.attachMarker = self.attachMarker or self.CONST.attachMarker;
	self.attachPointMarker = self.attachPointMarker or self.CONST.attachPointMarker;
	self.currentPowerLevel = self.managedObject.currentPowerLevel or self.CONST.noPower;
	
	self.createWithCarriableAttached = self.managedObject.createWithCarriableAttached or false;

	if IsItemKeyComplete(self.managedObject.completedKey) then
		self:SetToCompleted();
	end
	
	self.drainThread = nil;
	self.lastInteractingPlayer = nil;
end

function SocketParcel:DetermineInitialPowerState():void
	local initialAttachedObject = nil;

	if self.createWithCarriableAttached == true then
		initialAttachedObject = self:SetCarriableAttached();
	end
	
	if initialAttachedObject == nil then
		if self.managedObject.initiallyUnpowered == true then
			self.currentPowerLevel = self.CONST.noPower;
		end
	else
		if not self.managedObject.initiallyUnpowered then
			self:InsertObject(initialAttachedObject);
		else
			self:DebugPrint("SocketParcel:DetermineInitialPowerState: Requested to spawn with object and start unpowered. Defaulting to powered.");
		end
	end

	self:SetPowerLevel(self.currentPowerLevel);
end

-- Power

function SocketParcel:CreateDrainThread()
	if self.drainThread == nil then
		self.drainThread = self:CreateThread(self.DrainPower);
	else
		self:DebugPrint("SocketParcel:CreateDrainThread: Thread is already active!")
	end
end

function SocketParcel:KillDrainThread()
	if self.drainThread ~= nil then
		self:KillThread(self.drainThread);
		self.drainThread = nil;
	end
end

function SocketParcel:DrainPower():void
	-- First we handle a small delay before the draining actually starts
	SleepSeconds(self.CONST.drainDelay);

	while self.currentPowerLevel > self.CONST.noPower do
		SleepSeconds(self.CONST.drainInterval);
		self:AdjustPowerLevel(self.CONST.drainAmount);
	end

	self.drainThread = nil;
end

function SocketParcel:UpdateVisualState():void
	object_set_function_variable(self.managedObject, "power_level", self.currentPowerLevel / self.CONST.maxPower, 0.1);
end

-- Filter Management --

function SocketParcel:CreateInteractFilterThread()
	if self.interactFilterThread == nil then
		self.interactFilterThread = self:CreateThread(self.UpdateInteractFilter, self);
	end
end

function SocketParcel:UpdateInteractFilter():void
	Object_Filter_RemoveAllFilters(self.interactObject);
	Object_Filter_RemoveAllFilters(self.managedObject);
	local interactFilter:player_interaction_filter = Object_Filter_CreatePlayerMaskFilter(self.interactObject);
	local interactFilterWeapon:player_interaction_filter = Object_Filter_CreatePlayerMaskFilter(self.managedObject);

	repeat
		local socketLocation:location = ToLocation(self.managedObject);

		if LocationIsValidInWorld(socketLocation) then
			-- Check for bipeds in radius
			local bipedList:object_list = Object_GetObjectsInSphere(socketLocation, self.CONST.filterRadius, ObjectTypeMask.Biped);
			for _, biped in hpairs(bipedList) do
				local targetPlayer:player = Unit_GetPlayer(biped);
				if targetPlayer ~= nil then
					-- Make sure we update the filter to determine if the player can interact with the socket
					local canPlayerInteract:boolean = false;

					if self:HasAttachedObject() then
						canPlayerInteract = self:CanRemoveObject(targetPlayer);
					else
						local carriable:object = Unit_GetPrimaryWeapon(targetPlayer);
						 
						if (self:CanInsertObject(carriable, targetPlayer)) then
							local inventoryWeapons = Unit_GetInventoryWeapons(targetPlayer);
							if (inventoryWeapons ~= nil and #inventoryWeapons > 1) then		-- We want to make sure that units can't place their only weapon inside of the socket
								if (self:ValidateWeaponAmmunition(carriable) )then -- dont allow empty weapons
									local parent:object = Object_GetParent(self.managedObject);
									local toHologramVehicle:boolean = Object_IsUnit(parent) and Unit_GetTreatAsVehicle(parent) and Object_GetHologramPreviewStateEnabled(parent);

									if (not toHologramVehicle) then								-- Don't use a socket if it's a child of a vehicle that's in the hologram state
										canPlayerInteract = true;
									end
								end
							end
						end
					end

					Object_Filter_SetPlayer(self.interactObject, interactFilter, targetPlayer, canPlayerInteract);
					Object_Filter_SetPlayer(self.managedObject, interactFilterWeapon, targetPlayer, canPlayerInteract and not self.useDeviceInteraction);
				end
			end
		end
		SleepSeconds(self.CONST.filterUpdateIntervalSec);
	until false;
end

function SocketParcel:ValidateWeaponAmmunition(carriable:object):boolean
	local ammunitionValidation:boolean = true; -- capacitors will fail all ammo checks
	
	if (Weapon_IsAgeBased(carriable) and weapon_get_age(carriable) >=1 ) then -- check age weapons
		ammunitionValidation = false;
	else 
		if (Weapon_GetMaxRounds(carriable, 0)>0 and weapon_get_rounds_total(carriable, 0) <= 0 ) then -- check magazine weapons
			ammunitionValidation = false;
		end
	end

	return(ammunitionValidation);
end

function SocketParcel:KillInteractFilterThread():void
	if self.interactFilterThread ~= nil then
		self:KillThread(self.interactFilterThread);
		self.interactFilterThread = nil;

		if self.interactObject ~= nil then
			Object_Filter_RemoveAllFilters(self.interactObject);
		end
		self:DebugPrint("SocketParcel:KillFilterThread: Interact Filter destroyed.");
	end
end

-- Internal Event Callbacks

-- Parcel Overrides

function SocketParcel:OnStart()
	self:InitializeData();
	self:SetInteractObjectFromMarker(self.interactMarker);
end

function SocketParcel:OnInitialStateDetermined()
	self:CreateThread(self.SetupSocketThread);
end

function SocketParcel:SetupSocketThread():void
	self:DetermineInitialPowerState();
	self:RegisterEventOnSelf(g_eventTypes.objectDamagedEvent, self.OnDamaged, self.managedObject);

	if not self:HaveValidInteractObject() then
		self:DebugPrint("SocketParcel:OnInit: Did not find valid interact object.");
		return;
	end
end

function SocketParcel:OnControlUpdate():void
	if not self:HaveValidInteractObject() then return end;

	Device_SetPower(self.interactObject, self.isEnabled and 1 or 0);

	if self.isEnabled then	
		self:CreateInteractFilterThread();
		self:SubscribeToInteractEvents();
	else
		self:KillInteractFilterThread();
		self:UnsubscribeFromInteractEvents();
	end
end

-- Event Callbacks

function SocketParcel:OnDamaged(eventArgs:ObjectDamagedEventStruct):void
	local weapon:object = Unit_GetPrimaryWeapon(eventArgs.attacker);
	if Object_WeaponRefillSettingsMatch(self.managedObject, weapon) then
		if not self:HasAttachedObject() then 	
			-- Need to handle the slow drain of damage based charge
			self:KillDrainThread();
			self:AdjustPowerLevel(self.CONST.damageChargeAmount);			
		end
	end
end

function SocketParcel:OnObjectAttached():void
	if self.interactObject ~= nil and object_index_valid(self.interactObject) == true then
		if self.useDeviceInteraction then
			-- Disable all interaction on the attachedObject since only the socket should be interactable
			local objectFilter:player_interaction_filter = Object_Filter_CreateToggleEnabledFilter(self.attachedObject);
			Object_Filter_SetToggleEnabled(self.attachedObject, objectFilter, false); 

			-- Change interact string to reflect new state of socket.
			device_control_set_use_secondary_strings(self.interactObject, true);

			Device_SetInteractionHoldTime(self.interactObject, self.deviceInteractHoldTime);
			Device_SetPower(self.interactObject, 1);
		else
			Device_SetPower(self.interactObject, 0);
		end
	else
		print("[SocketParcel - OnObjectAttached] Validation Error: self.interactObject is nil or invalid.");
	end

	-- Update state
	ObjectSetSpartanTrackingEnabled(self.managedObject, false);
	
	if self.oneTimeUse then
		ObjectSetSpartanTrackingEnabled(self.attachedObject, false);
	end
	object_set_function_variable(self.managedObject, "isinserted", 1, 0.1);
	self:SetPowerLevel(self.CONST.maxPower);
	
	-- Need to handle the edge case of inserting an object into a socket that is still being powered by elemental damage
	self:KillDrainThread();
end

function SocketParcel:OnObjectDetached(detachedObject:object):void
	ObjectSetSpartanTrackingEnabled(self.managedObject, true);
	object_set_function_variable(self.managedObject, "isinserted", 0, 0.1);
	self:SetPowerLevel(self.CONST.noPower);

	if (self.attachedObject ~= nil) then
		object_set_function_variable(self.attachedObject, "isinserted", 0, 0.1);
	end

	if self.useDeviceInteraction then
		-- Change interact string to reflect new state of socket.
		device_control_set_use_secondary_strings(self.interactObject, false);
		Device_SetInteractionHoldTime(self.interactObject, 0);
	else
		Device_SetPower(self.interactObject, 1);
	end
end

function SocketParcel:OnAttachedObjectDeleted(deletedObject:object):void
	self:OnObjectDetached(deletedObject);
end

function SocketParcel:OnInteract(eventArgs:InteractEventStruct):void
	local validInteractionOccurred:boolean = false;

	if not self:HasAttachedObject() then
		local objectToAttach = Unit_GetPrimaryWeapon(eventArgs.interacter);
		
		if self:CanInsertObject(objectToAttach) then
			self.lastInteractingPlayer = Unit_GetPlayer(eventArgs.interacter);
			validInteractionOccurred = true;

			Unit_DropWeapon(eventArgs.interacter, objectToAttach);
			
			object_set_function_variable(objectToAttach, "isinserted", 1, 0.1);
			self:InsertObject(objectToAttach);
		end
	else
		self.lastInteractingPlayer = Unit_GetPlayer(eventArgs.interacter);
		validInteractionOccurred = true;

		-- This parameter is an optional unit to give the detached object to; in this case we pass the interacting player
		self:RemoveObject(eventArgs.interacter);
	end
	
	-- Clean up state and destroy the interactable object if this was our one allowed interaction
	if self.oneTimeUse == true and validInteractionOccurred then
		self:TurnOffEverything();
		SetItemKeyComplete(self.managedObject.setToCompletedKey);
	end
end

function SocketParcel:TurnOffEverything():void
	if self.attachedObject then
		local objectFilter:player_interaction_filter = Object_Filter_CreateToggleEnabledFilter(self.attachedObject);
		Object_Filter_SetToggleEnabled(self.attachedObject, objectFilter, false);
		ObjectSetSpartanTrackingEnabled(self.attachedObject, false);
	end

	ObjectSetSpartanTrackingEnabled(self.managedObject, false);
	self:UnsubscribeFromInteractEvents();
	self:KillInteractFilterThread();
	self:ChangeControlState(false);
	self:DestroyInteractObject();
end