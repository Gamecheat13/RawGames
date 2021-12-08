-- Copyright (c) Microsoft. All rights reserved.

--[[
--  ______     ______     _____     __   __     ______     __   __     ______     ______        _____     ______     ______     ______  
-- /\  __ \   /\  == \   /\  __-.  /\ "-.\ \   /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\      /\  __-.  /\  == \   /\  __ \   /\  == \ 
-- \ \ \/\ \  \ \  __<   \ \ \/\ \ \ \ \-.  \  \ \  __ \  \ \ \-.  \  \ \ \____  \ \  __\      \ \ \/\ \ \ \  __<   \ \ \/\ \  \ \  _-/ 
--  \ \_____\  \ \_\ \_\  \ \____-  \ \_\\"\_\  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\     \ \____-  \ \_\ \_\  \ \_____\  \ \_\   
--   \/_____/   \/_/ /_/   \/____/   \/_/ \/_/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/      \/____/   \/_/ /_/   \/_____/   \/_/   
--]]


-- Shared between server/client
global OrdnanceDropShared:table = 
{
	CONST =
	{
		effectMarkerName = "mkr_weapon",
		beaconLightMarker = "mkr_top",
		beaconMarkerPrefix = "fx_light_0",
		beaconMarkerCount = 4,
	},
};


--## SERVER
                                                                                                                                    

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_equipment_ordnance_crate.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_ordnance_crate.lua');


global OrdnanceType:table = table.makeAutoEnum
{
	"Weapon",
	"Equipment",
};

--//////
-- Parcel Setup
--//////

global MPOrdnanceDrop:table = Parcel.MakeParcel
{
	instanceName = "MPOrdnanceDrop",

	canStart = false,
	complete = false,

	cargo = nil,
	crate = nil,
	dropPod = nil,

	crateParcel = nil,
	crateInstance = nil,
	initArgs = nil,
	deleteThread = nil,

	ensureGroundIdx = 0,

	currentImpactEffect = nil,

	CONFIG = 
	{
	},

	CONST =
	{
		crateMarkerName = "weapon_pod",
		effectDeletionDelay = 3,
		ensureGroundDelay = 1,
		ensureGroundAttempts = 10,
		impactAnimationPct = 0.85,
	},
}

function MPOrdnanceDrop:SleepUntilValid():void
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function MPOrdnanceDrop:IsComplete():boolean
	return self.complete;
end

function MPOrdnanceDrop:shouldEnd():boolean
	return self:IsComplete();
end

function MPOrdnanceDrop:EndShutdown():void
	if (self.dropPod ~= nil) then
		Object_Delete(self.dropPod);
	end
end

function MPOrdnanceDrop:Run():void
end

function MPOrdnanceDrop:NewOrdnanceParcel(initArgs:MPOrdnanceDropInitArgs):table
	self.initArgs = initArgs;
	return self:CreateParcelInstance();
end

function MPOrdnanceDrop:InitializeImmediate():void
	if (self.initArgs.ordnanceType == OrdnanceType.Weapon) then
		self.crateParcel = _G["MPWeaponOrdnanceCrate"];
	elseif (self.initArgs.ordnanceType == OrdnanceType.Equipment) then
		self.crateParcel = _G["MPEquipmentOrdnanceCrate"];
	else
		print("Invalid ordnance type");
	end
end

function MPOrdnanceDrop:DeliverCargo(itemTag:tag, configTag:tag, location:location, scale:number, openOnLand:boolean):object
	self:SleepUntilValid();

	if (self.crateParcel == nil) then
		print("ERROR: Unable to locate crate parcel");
		return nil;
	end

	self.crateInstance = self.crateParcel:NewCrateParcel(self.initArgs);
	self:StartChildParcel(self.crateInstance, self.crateInstance.instanceName);
	Sleep(1);
	self.crateInstance:AddOnCrateDeleted(self, self.HandleCrateDeleted);
	self.crateInstance:CreateCargo(itemTag, configTag, scale, true);
	self.crate = self.crateInstance:GetCrate();

	if (self.crate == nil) then
		print("ERROR: Unable to create crate");
		return nil;
	end

	local cargo:object = self:GetCargo();
	if (cargo == nil) then
		print("ERROR: Unable to create cargo");
		return nil;
	end

	self.dropPod = Object_CreateFromTag(MPOrdnanceDropAssets.podMoverTag);

	if (self.dropPod ~= nil) then
		Device_SetPosition(self.dropPod, 0);	-- Ensure the device is at the top of the animation
		object_teleport(self.dropPod, location);
		self:AttachCrate();
		self:Drop(nil, openOnLand);
		return cargo;
	else
		debug_assert(false, "ERROR: Failed to create drop pod");
		object_destroy(cargo);
		self.complete = true;
		return nil;
	end
end

function MPOrdnanceDrop:AttachCrate():void
	Object_AttachObjectToMarker(self.dropPod, self.CONST.crateMarkerName, self.crate, "");
end

function MPOrdnanceDrop:Drop(landingEffect:number, openOnLand:boolean):boolean
	Object_SetScale(self.crate, 0.01, 0);
	object_hide(self.dropPod, false);
	Object_SetScale(self.crate, 1, 0.1);

	self:CreateThread(self.PostCreationClientFunctionRoutine);

	local startPosition:location = location(Object_GetMarkerWorldPosition(self.dropPod, self.CONST.crateMarkerName));
	local endPosition:location = location(startPosition.vector - vector(0, 0, 100));
	local impactMaterial:number = GetPhysicsMaterialTypeHit(startPosition, endPosition);
	self.currentImpactEffect = GetDropPodMaterialImpactEffect(impactMaterial);

	-- Drop the pod and wait for it to land
	Device_SetDesiredPosition(self.dropPod, 1);
	if not SleepUntilReturnSeconds([| self.dropPod ~= nil and Device_GetPosition(self.dropPod) > self.CONST.impactAnimationPct], 0.1, 10) then
		print("ERROR: Drop pod never got close enough to the ground to play impact effect");
		return false;
	end

	RunClientScript("OrdnanceDropImpactEffectNewClient", self.crate, self.currentImpactEffect);
	self:CreateThread(self.ScheduleTurnOffImpactEffect);

	if not SleepUntilReturnSeconds([| self.dropPod ~= nil and Device_GetPosition(self.dropPod) == 1], 0.1, 5) then
		print("ERROR: Drop pod never reached ground with a device position of 1");
		return false;
	end

	RunClientScript("EnableOrdnanceDropBeacon", self.crate, MPOrdnanceDropAssets.beaconEffectTag, MPOrdnanceDropAssets.beaconLightEffectTag);

	self.ensureGroundIdx = 0;
	self:CreateThread(self.EnforceGroundPosition);

	-- Open by default unless explicitly told not to do so
	if (openOnLand ~= false) then
		self:OpenPod();
	end

	return true;
end

function MPOrdnanceDrop:PostCreationClientFunctionRoutine():void
	SleepSeconds(0.1);
	RunClientScript("InitializeOrdnanceObjects", self.dropPod, self.crate);
end

function MPOrdnanceDrop:ScheduleTurnOffImpactEffect():void
	SleepSeconds(self.CONST.effectDeletionDelay);
	RunClientScript("OrdnanceDropImpactEffectDeleteClient", self.crate, self.currentImpactEffect);
end

-- This is a band-aid solution as low frame rates on level load seem to mean that the client's drop pod never
-- reaches ground before the server thinks no more updates are needed. this will force the device machine to 
-- "wake up" and update it's position, which would then force the client to follow. the frequency and duration
-- of these updates can be adjusted if there are any perf concerns.
function MPOrdnanceDrop:EnforceGroundPosition():void
	while (self.ensureGroundIdx < self.CONST.ensureGroundAttempts) do
		SleepSeconds(self.CONST.ensureGroundDelay);

		if (self.dropPod == nil) then
			return;	-- while sleeping, pod could have opened, been used and deleted
		end

		Device_SetDesiredPosition(self.dropPod, 0.99);
		SleepSeconds(self.CONST.ensureGroundDelay);

		if (self.dropPod == nil) then
			return;	-- while sleeping, pod could have opened, been used and deleted
		end

		Device_SetDesiredPosition(self.dropPod, 1);
		self.ensureGroundIdx = self.ensureGroundIdx + 1;
	end

	RunClientScript("EnableOrdnanceVisibilityWakeManager", self.dropPod, true);		-- now it's ok for pod to sleep if not visible to client
end

function MPOrdnanceDrop:OpenPod():void
	RunClientScript("DisableOrdnanceDropBeacon", self.crate, MPOrdnanceDropAssets.beaconEffectTag, MPOrdnanceDropAssets.beaconLightEffectTag);
	self.crateInstance:Destroy();
	Object_Detach(self.crate);
	RunClientScript("EnableOrdnanceVisibilityWakeManager", self.crate, true);		-- now it's ok for crate to sleep if not visible to client because we're unparented from pod mover
end

function MPOrdnanceDrop:HandleCrateDeleted(crateInstance:table):void
	if (crateInstance == self.crateInstance) then
		self.crateInstance:RemoveOnCrateDeleted(self, self.HandleCrateDeleted);
		self.complete = true;
	end
end

function MPOrdnanceDrop:GetCrate():object
	return self.crate;
end

function MPOrdnanceDrop:GetCargo():object
	return self.crateInstance:GetCargo();
end

function MPOrdnanceDrop:GetPod():object
	return self.dropPod;
end

--## CLIENT
function remoteClient.EnableOrdnanceDropBeacon(crate:object, effect:tag, lightEffect:tag)
	if (crate ~= nil) then
		for i = 1, OrdnanceDropShared.CONST.beaconMarkerCount do
			effect_new_on_object_marker(effect, crate, OrdnanceDropShared.CONST.beaconMarkerPrefix..i);
		end

		effect_new_on_object_marker(lightEffect, crate, OrdnanceDropShared.CONST.beaconLightMarker);
	end
end

function remoteClient.DisableOrdnanceDropBeacon(crate:object, effect:tag, lightEffect:tag)
	if (crate ~= nil) then
		for i = 1, OrdnanceDropShared.CONST.beaconMarkerCount do
			effect_kill_object_marker(effect, crate, OrdnanceDropShared.CONST.beaconMarkerPrefix..i);
		end

		effect_kill_object_marker(lightEffect, crate, OrdnanceDropShared.CONST.beaconLightMarker);
	end
end

function remoteClient.OrdnanceDropImpactEffectNewClient(crate:object, effect:tag)
	if (crate ~= nil) then
		effect_new_on_object_marker(effect, crate, OrdnanceDropShared.CONST.effectMarkerName);
	end
end

function remoteClient.OrdnanceDropImpactEffectDeleteClient(crate:object, effect:tag)
	if (crate ~= nil) then
		effect_stop_object_marker(effect, crate, OrdnanceDropShared.CONST.effectMarkerName);
	end
end

function remoteClient.EnableOrdnanceVisibilityWakeManager(obj:object, enable:boolean)
	Object_SetVisibilityWakeManagerEnabled(obj, enable);
end

function remoteClient.InitializeOrdnanceObjects(pod:object, crate:object)
	if (pod ~= nil) then
		Object_SetVisibilityWakeManagerSleepLocking(pod, true);
		Object_SetVisibilityWakeManagerEnabled(pod, false);
	end

	if (crate ~= nil) then
		Object_SetVisibilityWakeManagerSleepLocking(crate, true);
		Object_SetVisibilityWakeManagerEnabled(crate, false);
		effect_new_on_object_marker(MPOrdnanceDropAssets.entryEffectTag, crate, OrdnanceDropShared.CONST.effectMarkerName);
	end
end