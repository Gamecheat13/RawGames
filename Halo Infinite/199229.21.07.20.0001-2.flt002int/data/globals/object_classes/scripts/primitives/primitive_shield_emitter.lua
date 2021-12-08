-- object primitive_shield_emitter : communication_object_base_class

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');
REQUIRES('scripts\ParcelLibrary\parcel_damageable.lua');
REQUIRES('scripts\ParcelLibrary\parcel_interactive.lua');

global ShieldEmitterParcel:table = CommNodeBaseParcel:CreateParcelInstance();

ShieldEmitterParcel.CONST = 
{
	shieldRespawnTime = 5,
	shieldTransitionTime = 1,
	isActiveObjFuncName = "isactive",
	isActiveAudioObjFuncName = "audio_isactive",	
	isActiveObjFuncMin = 0,
	isActiveObjFuncMax = 1,
	isActiveObjFuncEpEpsilon = 0.01,
	isShieldObjFuncName = "isshield",
	isShieldObjFuncTrueState = 1,
	maintainTimeToRespawnUntilRespawned = true,
	interactMarkerName = "north_forward_1m_2m",
	activatedStringID = "generic_activate",
	deactivatedStringID = "generic_deactivate"
};


hstructure primitive_shield_emitter : communication_object_base_class
	dontRechargeOnShieldDamage:boolean;		--$$ METADATA {"prettyName": "Don't Recharge On Shield Damage"}
end

function primitive_shield_emitter:init()
	local variantId = ObjectGetVariant(self);
	local parcelName:string = "ShieldEmitter_"..tostring(self);	
	local shouldRecharge = not self.dontRechargeOnShieldDamage;

	if variantId ~= nil then
		local parcel:table = ShieldEmitterParcel:New(self);
		parcel.variantId = variantId;

		parcel:SetRunFunction(parcel.OnStart);
		parcel:SetOwnershipUpdateFunction(parcel.OnOwnershipUpdate);
		parcel:SetRechargeOnShieldDamage(shouldRecharge);
		parcel:SetActivatedUpdateFunction(parcel.OnActivatedUpdate);
		
		self:ParcelAddAndStartOnSelf(parcel, parcelName);
	else
		self:DebugPrint(parcelName, "did not have variant assigned, aborting initialization");
	end
end

-- Setters

function ShieldEmitterParcel:SetIsPowered(isPowered:boolean):void
	self:ChangePowerState(isPowered);
	self:BroadcastSend(commObjectChannelsEnum.power, isPowered);
end

function ShieldEmitterParcel:SetIsEnabled(isEnabled:boolean):void
	self:ChangeControlState(isEnabled);
	self:BroadcastSend(commObjectChannelsEnum.control, isEnabled);

	if self.interactiveParcelInstance ~= nil then
		local actionStringID = isEnabled and self.CONST.deactivatedStringID or self.CONST.activatedStringID;
		self.interactiveParcelInstance:SetActionString(actionStringID);

		-- AI want to interact with buttons at position 0, so keep it in sync with whether the shield is up or not.
		local devicePosition = isEnabled and 1 or 0;
		self.interactiveParcelInstance:SetDevicePosition(devicePosition);
	end
end

function ShieldEmitterParcel:SetTeam(newTeam:mp_team_designator)
	if newTeam ~= nil then
		self:ChangeOwnership(newTeam);
		self:BroadcastSend(commObjectChannelsEnum.ownership, newTeam);
	end
end

function ShieldEmitterParcel:SetRechargeOnShieldDamage(isEnabled:boolean)
	self.rechargeOnShieldDamage = isEnabled;
end

-- Parcel Overrides

function ShieldEmitterParcel:OnStart()
	self:ResetRespawnTimer();
	self.mainThread = nil;
	self.updateRespawnTimerThread = nil;
	self.destroyShieldThread = nil;

	self:CreateThread(self.OnAfterCommNodeInit, self);
end

function ShieldEmitterParcel:OnOwnershipUpdate():void
	local children = object_list_children(self.managedObject, nil);
	for _, child in hpairs(children) do
		Object_SetTeamDesignator(child, self.ownerTeam);
	end
end

-- Callbacks

function ShieldEmitterParcel:OnAfterCommNodeInit()
	self:InitializeData();
	
	if self:IsPowered() then
		self:SetIsEnabled(self.isEnabled);
	end

	local children = object_list_children(self.managedObject, nil);
	for index, shieldObject in hpairs(children) do
		-- This is a workaround so that the interact object is not treated as a shield
		-- That way, we don't spin up a damageable parcel for no reason
		if self.interactObject == nil or (self.interactObject ~= nil and self.interactObject ~= shieldObject) then
			local damageableParcel = self:CreateDamagableParcel(shieldObject);
			if damageableParcel ~= nil then
				Object_SetTeamDesignator(damageableParcel.managedObject, self.ownerTeam);
				ObjectSetSpartanTrackingEnabled(self.managedObject, true);
				self.damageableParcelTable[index] = damageableParcel;
				self:UpdateShieldState(self.isActivated);
			end
		end
	end

	self.mainThread = self:CreateThread(self.MainThread);
end

function ShieldEmitterParcel:OnShieldDamaged(eventArgs:ObjectDamagedEventStruct):void
	local totalDamage = eventArgs.totalDamageInVitalityPoints;

	self:DebugPrint("OnShieldDamaged: Got hit");
	self:DebugPrint("OnShieldDamaged: Damage was ", totalDamage);

	if totalDamage > 0 then
		self:KillUpdateRespawnTimerThread();
		self:ResetRespawnTimer();
		if self.wasDamageSectionDamaged == true then
			self:CreateUpdateRespawnTimerThread();
		end
	end
end

function ShieldEmitterParcel:OnShieldDamageSectionDestroyed(damageSectionName:string_id):void

	self:KillUpdateRespawnTimerThread();
	self:ResetRespawnTimer();
	self:CreateUpdateRespawnTimerThread();
	self.wasDamageSectionDamaged = true;
end

function ShieldEmitterParcel:OnShieldRespawned(shieldObject:object):void
	self.wasDamageSectionDamaged = false;
end

function ShieldEmitterParcel:OnCompleted()
	self:KillAllShieldObjectThreads();
	self:KillThread(self.mainThread);
	self.mainThread = nil;

	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		damageableParcel:SetDestroyParcelOnObjectDeletion(true);
		damageableParcel:DestroyManagedObject();
	end
end

function ShieldEmitterParcel:OnInteract(eventArgs:InteractEventStruct):void
	self:SetIsEnabled(not self.isEnabled);
end

-- Class Functions

function ShieldEmitterParcel:InitializeData():void
	self.damageableParcelTable = {};
	self.previousShieldState = nil;
	self.interactObject = Object_GetObjectAtMarker(self.managedObject, self.CONST.interactMarkerName);
	self.wasDamageSectionDamaged = false;
end

function ShieldEmitterParcel:MainThread():void
	self:DebugPrint("MainThread:Start");

	Object_SetFunctionValue(self.managedObject, "audioshieldrespawning", 0, 1);

	SleepUntil ([|	self.managedObject ~= nil and
					object_index_valid(self.managedObject) == true ], 0.1);
	
	-- Setting up interaction if there's a valid interact object
	if self.interactiveParcelInstance ~= nil then
		self.interactiveParcelInstance:EndParcel();
		self.interactiveParcelInstance = nil;			
	end

	if self.interactObject ~= nil then
		local interactiveParcel:table = InteractiveParcel:New(self.interactObject);
		if interactiveParcel ~= nil then
			interactiveParcel:AddOnInteractCallback(self, self.OnInteract);
			interactiveParcel:SetDevicePower(1);

			local devicePosition = self.isEnabled and 1 or 0;
			interactiveParcel:SetDevicePosition(devicePosition);
			
			local actionStringID = self.isEnabled and self.CONST.deactivatedStringID or self.CONST.activatedStringID;
			interactiveParcel:SetActionString(actionStringID);

			self:StartChildParcel(interactiveParcel, interactiveParcel.instanceName);
			self.interactiveParcelInstance = interactiveParcel;
		end
	end
	
	SleepUntilSeconds ([|	self.managedObject ~= nil and
					object_index_valid(self.managedObject) == true and
					self.rechargeOnShieldDamage == true], 0.5);

	-- Sleep until we're ready to respawn via the respawn timer running out or this object becomes invalid
	-- Not to be confused with respawning the shield if it goes from completely off to on
	SleepUntilSeconds ([| self:RespawnTimerReachedZero() or not object_index_valid(self.managedObject)], 0.5);

	if not object_index_valid(self.managedObject) then
		self:DebugPrint("MainThread: Managed object is invalid. Ending thread.");
		self:OnCompleted();
		return;
	end

	self:DebugPrint("MainThread: Killing respawn timer thread");
	self:KillUpdateRespawnTimerThread();

	SleepOneFrame();

	self:DebugPrint("MainThread: Preparing to respawn shield.");

	-- Kill all of the shield object threads that may be running
	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		self:KillAllShieldObjectThreads();
	end

	self:DebugPrint("MainThread: Killed all shield object threads.");

	-- Now, respawn all of them
	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		-- Since we're tracking if damage occured at all on the shield(s), we need to reset the parcel explicitly
		damageableParcel:ResetParcelDamage();
		self:CreateRespawnShieldThread(damageableParcel);
	end

	self:DebugPrint("MainThread: Waiting for the destroy shield threads to finish.")
	SleepUntil ([| self:IsRespawningShields() == false], 0.1);

	Object_SetFunctionValue(self.managedObject, "audioshieldrespawning", 1, 0);
	
	-- Reset our shield respawn time
	self:DebugPrint("MainThread: Resetting Timer");
	self:ResetRespawnTimer();

	self:KillThread(self.mainThread);
	self.mainThread = self:CreateThread(self.MainThread, self);
end

function ShieldEmitterParcel:OnActivatedUpdate()
	self:UpdateShieldState(self.isActivated);
	if self.isActivated then				
		if self.timeUntilShieldRespawn < self.CONST.shieldRespawnTime then
			self:KillUpdateRespawnTimerThread();
			if not self.CONST.maintainTimeToRespawnUntilRespawned then
				self:ResetRespawnTimer();
			end
			self:CreateUpdateRespawnTimerThread();
		end
	end
end

function ShieldEmitterParcel:UpdateShieldState(newShieldState:boolean)
	if (self.damageableParcelTable ~= nil) then
		for _, damageableParcel in hpairs(self.damageableParcelTable) do
			local haveValidShield = damageableParcel:IsManagedObjectValid();
			local shieldMarkedForDelete = damageableParcel:IsManagedObjectMarkedForDeletion();
			if newShieldState == true then
				if haveValidShield and not shieldMarkedForDelete then
					self:CreateUpdateShieldTransitionThread(damageableParcel, newShieldState);
				elseif not haveValidShield and damageableParcel.respawnShieldThread == nil then
					self:CreateRespawnShieldThread(damageableParcel);
				end
			else
				if haveValidShield and not shieldMarkedForDelete then
					self:KillUpdateShieldTransitionThread(damageableParcel);
					self:CreateDestroyShieldThread(damageableParcel, false);	
				end
			end
		end
	end
end

-- Thread Management

function ShieldEmitterParcel:KillAllShieldObjectThreads():void
	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		self:KillRespawnShieldThread(damageableParcel);
		self:KillUpdateShieldTransitionThread(damageableParcel);
		self:KillDestroyShieldThread(damageableParcel);
	end
end

-- Thread Management: RespawnShieldThread

function ShieldEmitterParcel:CreateRespawnShieldThread(damageableParcel:object):void
	if damageableParcel == nil then
		self:DebugPrint("CreateRespawnShieldThread: Damageable is nil. Returning.");
		return;
	end

	self:KillRespawnShieldThread(damageableParcel);
	
	if damageableParcel.respawnShieldThread == nil then
		damageableParcel.respawnShieldThread = self:CreateThread(self.RespawnShieldThread, damageableParcel);
	end
end

function ShieldEmitterParcel:RespawnShieldThread(damageableParcel:object):void
	if damageableParcel:IsManagedObjectValid() then
		-- Destroy the shield
		self:CreateDestroyShieldThread(damageableParcel, false);
		-- Wait until it's finished transitioning
		SleepUntil ([| damageableParcel.destroyShieldThread == nil], 0.1);
	end

	-- Spawn new shield
	if damageableParcel:RespawnManagedObject() == true then
		local respawnMarker = "forward_2m";
		if self.variantId == Engine_ResolveStringId("energy_shield_egg") then
			respawnMarker = "center";
		end

		objects_physically_attach(self.managedObject, respawnMarker, damageableParcel.managedObject, nil);
		self:CreateUpdateShieldTransitionThread(damageableParcel, self:IsShieldUp());
		SleepUntil ([| damageableParcel.shieldTransitionThread == nil], 0.1);
	else
		self:DebugPrint("RespawnShieldThread: Could not respawn object");
	end	

	self:KillRespawnShieldThread(damageableParcel);
end

function ShieldEmitterParcel:KillRespawnShieldThread(damageableParcel:object):void
	if damageableParcel.respawnShieldThread ~= nil then
		self:KillThread(damageableParcel.respawnShieldThread);
		damageableParcel.respawnShieldThread = nil;
	end
end

-- Thread Management: UpdateShieldTransitionThread

function ShieldEmitterParcel:CreateUpdateShieldTransitionThread(damageableParcel:object, lastKnownShieldState:boolean):void
	if damageableParcel == nil then
		self:DebugPrint("CreateUpdateShieldTransitionThread: Damageable is nil. Returning.");
		return;
	end

	self:KillUpdateShieldTransitionThread(damageableParcel);
	
	if damageableParcel.shieldTransitionThread == nil then
		damageableParcel.shieldTransitionThread = self:CreateThread(self.UpdateShieldTransitionThread, damageableParcel, lastKnownShieldState);
	end
end

function ShieldEmitterParcel:UpdateShieldTransitionThread(damageableParcel:object, lastKnownShieldState:boolean):void
	local isShield = object_get_function_value(damageableParcel.managedObject, self.CONST.isShieldObjFuncName);
	if isShield == self.CONST.isShieldObjFuncTrueState then
		local shieldObject = damageableParcel.managedObject;
		local targetIsActiveValue = nil;

		if lastKnownShieldState == true then
			targetIsActiveValue = self.CONST.isActiveObjFuncMax;
		else
			targetIsActiveValue = self.CONST.isActiveObjFuncMin;
		end

		local currentIsActiveValue = object_get_function_value(shieldObject, self.CONST.isActiveObjFuncName);
		local transitionTime = self:GetIsActiveObjFuncTransitionTime(shieldObject, targetIsActiveValue);
		local reachedTarget = false;

		Object_SetFunctionValue(shieldObject, self.CONST.isActiveObjFuncName, targetIsActiveValue, transitionTime);
		--when the function is set on the shield object, also set a custom object function for audio (has the same values as "isactive" except does not interpolate)
		Object_SetFunctionValue(self.managedObject, self.CONST.isActiveAudioObjFuncName, targetIsActiveValue, 0);
		ObjectSetSpartanTrackingEnabled(self.managedObject, true);
		ObjectOverrideNavMeshCutting(self.managedObject, true);

		repeat
			currentIsActiveValue = object_get_function_value(shieldObject, self.CONST.isActiveObjFuncName);		
			if NearEqualWithEpsilon(currentIsActiveValue, targetIsActiveValue, self.CONST.isActiveObjFuncEpEpsilon) then
				self:DebugPrint("UpdateShieldTransitionThread: Current active value within epsilon value. Breaking out early.");
				Object_SetFunctionValue(shieldObject, self.CONST.isActiveObjFuncName, targetIsActiveValue, 0);
				reachedTarget = true;
				break;
			end
			SleepOneFrame();
		until false;

		if not reachedTarget then
			self:DebugPrint("Did not at waiting for shield damage thread");
			self:DebugPrint("Goal was " .. targetIsActiveValue .. ", value was " .. currentIsActiveValue);
		end
	else
		self:DebugPrint("UpdateShieldTransitionThread: Child object does not have 'isshield' implemented and/or is 0.")
	end
	self:KillUpdateShieldTransitionThread(damageableParcel);
end

function ShieldEmitterParcel:KillUpdateShieldTransitionThread(damageableParcel:object):void
	if damageableParcel.shieldTransitionThread ~= nil then
		self:KillThread(damageableParcel.shieldTransitionThread);
		damageableParcel.shieldTransitionThread = nil;
	end
end

-- Thread Management: DestroyShieldThread

function ShieldEmitterParcel:CreateDestroyShieldThread(damageableParcel:object, lastKnownShieldState:boolean):void
	if damageableParcel == nil then
		self:DebugPrint("CreateDestroyShieldThread: Damageable is nil. Returning.");
		return;
	end

	self:KillDestroyShieldThread(damageableParcel);
	
	if damageableParcel.destroyShieldThread == nil then
		damageableParcel.destroyShieldThread = self:CreateThread(self.DestroyShieldThread, damageableParcel, lastKnownShieldState);
	end
end

function ShieldEmitterParcel:DestroyShieldThread(damageableParcel:object, lastKnownShieldState:boolean):void
	if damageableParcel:IsManagedObjectValid() then
		local isShield = object_get_function_value(damageableParcel.managedObject, self.CONST.isShieldObjFuncName);
		if isShield == self.CONST.isShieldObjFuncTrueState then
			self:CreateUpdateShieldTransitionThread(damageableParcel, lastKnownShieldState);		
		end

		repeat
			if not damageableParcel:IsManagedObjectValid() then
				break; 
			end
			if damageableParcel.shieldTransitionThread == nil then
				damageableParcel:DestroyManagedObject();
				ObjectSetSpartanTrackingEnabled(self.managedObject, false);
				ObjectOverrideNavMeshCutting(self.managedObject, false);
				self:DebugPrint("DestroyShieldThread: Destroyed damageable managed object.");
			end
			SleepOneFrame();		
		until false;
	end

	self:KillUpdateRespawnTimerThread();
	self:KillDestroyShieldThread(damageableParcel);
end

function ShieldEmitterParcel:KillDestroyShieldThread(damageableParcel:object):void
	if damageableParcel.destroyShieldThread ~= nil then
		self:KillThread(damageableParcel.destroyShieldThread);
		damageableParcel.destroyShieldThread = nil;
	end
end

-- Thread Management: UpdateRespawnTimerThread

function ShieldEmitterParcel:CreateUpdateRespawnTimerThread():void
	self:KillUpdateRespawnTimerThread();
	self.respawnTimerThread = self:CreateThread(self.UpdateRespawnTimerThread);
end

function ShieldEmitterParcel:UpdateRespawnTimerThread()
	repeat
		SleepSeconds(0.1);
		self.timeUntilShieldRespawn = self.timeUntilShieldRespawn - 0.1;
		self:DebugPrint("UpdateRespawnTimerThread: Current time: " .. self.timeUntilShieldRespawn);
		if self:RespawnTimerReachedZero() then
			break;
		end		
	until false;

	self:KillUpdateRespawnTimerThread();
end

function ShieldEmitterParcel:KillUpdateRespawnTimerThread():void
	if self.respawnTimerThread ~= nil then
		self:KillThread(self.respawnTimerThread);
		self.updateRespawnTimerThread = nil;
	end
end

-- Helpers

function ShieldEmitterParcel:CreateDamagableParcel(shieldObject:object):table
	if not object_index_valid(shieldObject) then
		self:DebugPrint("CreateDamagableParcel: Could not create parcel because object was invalid!");
		return nil;
	end

	local damageableParcel:table = DamageableParcel:New(shieldObject);
	local childParcelName:string = "DamageableParcel_"..tostring(damageableParcel);

	damageableParcel:SetDestroyParcelOnObjectDeletion(false);
	damageableParcel:AddOnObjectDamagedCallback(self, self.OnShieldDamaged);
	damageableParcel:AddOnObjectDamageSectionDestroyedCallback(self, self.OnShieldDamageSectionDestroyed);
	damageableParcel:AddOnObjectRespawnedCallback(self, self.OnShieldRespawned);

	self:StartChildParcel(damageableParcel, childParcelName);

	return damageableParcel;
end

function ShieldEmitterParcel:ResetRespawnTimer():void
	self.timeUntilShieldRespawn = self.CONST.shieldRespawnTime;
end

function ShieldEmitterParcel:GetIsActiveObjFuncTransitionTime(shieldObject:object, targetValue:number):number
	local transitionTime = self.CONST.shieldTransitionTime;
	local currentIsActiveValue = object_get_function_value(shieldObject, self.CONST.isActiveObjFuncName);

	if currentIsActiveValue > targetValue then
		transitionTime = currentIsActiveValue - targetValue;
	else
		transitionTime = targetValue - currentIsActiveValue;
	end
	return transitionTime;
end

function ShieldEmitterParcel:IsShieldUp()
	local isShieldUp = false;	
	if self:IsPowered() then
		isShieldUp = self.isEnabled;
	end

	return isShieldUp;
end

function ShieldEmitterParcel:IsDestroyingShields():boolean
	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		if damageableParcel.destroyShieldThread ~= nil then
			return true;
		end
	end
	return false;
end

function ShieldEmitterParcel:IsRespawningShields():boolean
	for _, damageableParcel in hpairs(self.damageableParcelTable) do
		if damageableParcel.respawnShieldThread ~= nil then
			return true;
		end
	end
	return false;
end

function ShieldEmitterParcel:RespawnTimerReachedZero():boolean
	return self.timeUntilShieldRespawn <= 0;
end

--## CLIENT