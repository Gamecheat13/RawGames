-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalObjectCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');

-- The Damageable Base Parcel provides a reusable set of functionality for tracking damage-related logic and querying damage-related behavior

global DamageableParcel:table = Parcel.MakeParcel
{
	-- Required: Do not modify outside of class
	managedObject = nil,
	isComplete = false,
	-- The tag definition of the managed object passed in
	managedObjectTagDefinition = nil,
	-- Has the parcel received a damage event?
	wasParcelDamaged = false,
	-- Has the current managed object been damaged?
	wasManagedObjectDamaged = false, 
	-- Was self:DestroyManagedObject() called and the object about to be deleted?
	markedForDeletion = false,
	-- Optional: Should be set via Setters
	-- Is the parcel completed when its managed object is deleted?	
	destroyParcelOnObjectDeletion = true,
	 -- The parcel "wasDamaged" state always matches the managed object's "isDamaged" state, even when the object is respawned 
	syncWasDamagedToManagedObjectOnRespawn = true,
	damageSectionNames = {},
	EVENTS =
	{
		onObjectDamaged = "OnObjectDamaged",
		onObjectDamageSectionDestroyed = "OnObjectDamageSectionDestroyed",
		onObjectRespawned = "OnObjectRespawned",
		onObjectDeleted = "OnObjectDeleted"
	}
};

-- Constructor

function DamageableParcel:New(objectInstance):table
	local parcel = self:CreateParcelInstance();

	parcel.managedObject = objectInstance;
	parcel.isComplete = false;
	parcel.instanceName = "DamageableParcel_"..tostring(self);
	parcel.managedObjectTagDefinition = Object_GetDefinition(objectInstance);

	return parcel;
end

-- Required Parcel Overrides: Needed in order for the parcel to be instantiated and work properly

function DamageableParcel:shouldEnd():boolean
	return self.isComplete;
end

function DamageableParcel:Run():void
	self:RegisterForEvents();
	self:LoadDamageSectionNames();
end

-- Class Functions: Should be treated as public

function DamageableParcel:EndParcel()
	self.isComplete = true;
end

-- Getters

function DamageableParcel:WasParcelDamaged():boolean
	return self.wasParcelDamaged == true;
end

function DamageableParcel:WasManagedObjectDamaged():boolean
	return self.wasManagedObjectDamaged == true;
end

function DamageableParcel:IsManagedObjectValid():boolean
	return object_index_valid(self.managedObject);
end

function DamageableParcel:IsManagedObjectMarkedForDeletion():boolean
	return self.markedForDeletion == true;
end

function DamageableParcel:GetVitality():number
	return Object_GetHealth(self.managedObject);
end

function DamageableParcel:TryGetDamageSectionHealth(damageSectionName:string_id):number
	if damageSectionName == nil then return nil; end
	if self:IsManagedObjectValid() == false then return nil; end
	return object_damage_section_get_health(self.managedObject, damageSectionName)
end

-- Setters

function DamageableParcel:SetDestroyParcelOnObjectDeletion(isEnabled:boolean):void
	if isEnabled == nil then return; end
	self.destroyParcelOnObjectDeletion = isEnabled;
end

function DamageableParcel:SetSyncWasDamagedToManagedObjectOnRespawn(isEnabled:boolean):void
	if isEnabled == nil then return; end
	self.syncWasDamagedToManagedObject = isEnabled;
end

function DamageableParcel:ApplyDamageToSection(damageSectionName:string, damageAmount:number):void	
	if self:IsManagedObjectValid() == false then return end;		
	if damageSectionName == nil then return; end
	object_damage_damage_section(self.managedObject, damageSectionName, damageAmount);
end

function DamageableParcel:ResetDamage():void
	self:ResetManagedObjectDamage();
	if self.syncWasDamagedToManagedObject == true then
		self:ResetParcelDamage();
	end
end

function DamageableParcel:ResetParcelDamage():void
	if self.syncWasDamagedToManagedObject == false then
		self.wasParcelDamaged = false;
	end
end

function DamageableParcel:ResetManagedObjectDamage():void
	if self:IsManagedObjectValid() then
		object_damage_repair_section_all(self.managedObject);
		self.wasManagedObjectDamaged = false;
		if self.syncWasDamagedToManagedObject == true then
			self.wasParcelDamaged = false;
		end
	end
end

function DamageableParcel:DestroyManagedObject():boolean
	if not self:IsManagedObjectValid() then return false; end

	Object_Detach(self.managedObject);
	Object_Delete(self.managedObject);

	self.markedForDeletion = true;

	return true;
end

function DamageableParcel:RespawnManagedObject():boolean
	if self.isComplete == true then 
		print("DamageableParcel:RespawnManagedObject: Parcel has ended. Can't respawn.");
		return false; 
	end

	if not IsValidTag(self.managedObjectTagDefinition) then 
		print("DamageableParcel:RespawnManagedObject: No tag definition found. Can't respawn.");
		return false;
	end

	local managedObjectTagVariant = nil;
	local newObject = nil;

	if self.managedObject ~= nil and self:IsManagedObjectValid() == true then
		managedObjectTagVariant = ObjectGetVariant(self.managedObject);
	else
		print("[DamageableParcel - RespawnManagedObject] Validation Error: self.managedObject is nil or invalid. self.managedObjectTagDefinition:", self.managedObjectTagDefinition);
	end

	if managedObjectTagVariant ~= nil then
		newObject = Object_CreateFromTagWithVariant(self.managedObjectTagDefinition, managedObjectTagVariant);
	else
		newObject = Object_CreateFromTag(self.managedObjectTagDefinition);
	end

	if newObject ~= nil then
		self:DestroyManagedObject();
		self.managedObject = newObject;
		self:CreateThread(self.OnObjectRespawned, newObject, self);
	else
		print("DamageableParcel:RespawnManagedObject: Object could not be instantiated.");
	end

	return newObject ~= nil;
end

-- Events

function DamageableParcel:AddOnObjectDamagedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDamaged, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:RemoveOnObjectDamagedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDamaged, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:AddOnObjectDamageSectionDestroyedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDamageSectionDestroyed, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:RemoveOnObjectDamageSectionDestroyedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDamageSectionDestroyed, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:AddOnObjectRespawnedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectRespawned, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:RemoveOnObjectRespawnedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectRespawned, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:AddOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:RegisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:RemoveOnObjectDeletedCallback(callbackOwner:object, callbackFunc:ifunction):void
	if self:CallbackArguementsValid(callbackOwner, callbackFunc) then
		self:UnregisterCallback(self.EVENTS.onObjectDeleted, callbackFunc, callbackOwner);
	end
end

function DamageableParcel:CallbackArguementsValid(callbackOwner:object, callbackFunc):boolean
	if callbackOwner == nil then
		dprint("DamageableParcel:CallbackArguementsValid: Callback owner is invalid.")
		return false;
	end

	if callbackFunc == nil then
		dprint("DamageableParcel:CallbackArguementsValid: Callback function is invalid.")
		return false;
	end

	return true;
end

-- Class Functions: Should be treated as private

function DamageableParcel:RegisterForEvents():void
	if not self:IsItemRegistered(g_eventTypes.objectDamagedEvent, self.OnObjectDamaged, self.managedObject) then
		self:RegisterEventOnSelf(g_eventTypes.objectDamagedEvent, self.OnObjectDamaged, self.managedObject);
	else
		print("WARNING: self.OnObjectDamaged is registered for", self.managedObject, "twice!");
	end

	if not self:IsItemRegistered(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.managedObject) then
		self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, self.OnObjectDeleted, self.managedObject);
	else
		print("WARNING: self.OnObjectDeleted is registered for", self.managedObject, "twice!");
	end
end

function DamageableParcel:LoadDamageSectionNames()
	local objectDamageSections = Object_GetDamageSectionNames(self.managedObject);

	for _, damageSectionName in hpairs(objectDamageSections) do
		self.damageSectionNames[damageSectionName] = self:TryGetDamageSectionHealth(damageSectionName);
	end
end

-- Callbacks

function DamageableParcel:OnObjectDamaged(eventArgs:ObjectDamagedEventStruct):void
	if self:GetVitality() < 1 then
		self.wasManagedObjectDamaged = true;
		self.wasParcelDamaged = true;

		self:TriggerEvent(self.EVENTS.onObjectDamaged, eventArgs);

		for damageSectionName, health in hpairs(self.damageSectionNames) do
			local currentHealth = self:TryGetDamageSectionHealth(damageSectionName);
			if currentHealth ~= nil then				
				if currentHealth <= 0 and health > 0 then
					currentHealth = 0;
					self:TriggerEvent(self.EVENTS.onObjectDamageSectionDestroyed, damageSectionName);
				end
				self.damageSectionNames[damageSectionName] = currentHealth;
			end
		end 
	end
end

function DamageableParcel:OnObjectRespawned(newObject:object):void
	self.markedForDeletion = false;

	self:ResetDamage();
	self:LoadDamageSectionNames();
	self:RegisterForEvents();

	self:TriggerEvent(self.EVENTS.onObjectRespawned, newObject);
end

function DamageableParcel:OnObjectDeleted(deletedObject:object):void
	if self:IsItemRegistered(g_eventTypes.objectDamagedEvent, self.OnObjectDamaged, deletedObject) then
		self:UnregisterEventOnSelf(g_eventTypes.objectDamagedEvent, self.OnObjectDamaged, deletedObject);
	end

	self.markedForDeletion = false;
	self.isComplete = self.destroyParcelOnObjectDeletion;

	self:TriggerEvent(self.EVENTS.onObjectDeleted, deletedObject);
end

