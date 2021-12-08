-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

--  ______     ______     ______     ______        __    __     ______     __   __     __     ______   ______     ______    
-- /\  __ \   /\  == \   /\  ___\   /\  __ \      /\ "-./  \   /\  __ \   /\ "-.\ \   /\ \   /\__  _\ /\  __ \   /\  == \   
-- \ \  __ \  \ \  __<   \ \  __\   \ \  __ \     \ \ \-./\ \  \ \ \/\ \  \ \ \-.  \  \ \ \  \/_/\ \/ \ \ \/\ \  \ \  __<   
--  \ \_\ \_\  \ \_\ \_\  \ \_____\  \ \_\ \_\     \ \_\ \ \_\  \ \_____\  \ \_\\"\_\  \ \_\    \ \_\  \ \_____\  \ \_\ \_\ 
--   \/_/\/_/   \/_/ /_/   \/_____/   \/_/\/_/      \/_/  \/_/   \/_____/   \/_/ \/_/   \/_/     \/_/   \/_____/   \/_/ /_/ 
																														

-- The AreaVolume table represents the area type we want to use for monitoring objects,
-- such as TriggerVolumes or Spheres.
global AreaVolume = table.makePermanent
{
	TypeEnum = table.makeEnum
	{
		TriggerVolume = 0,
		Sphere = 1,
		MPBoundaryObject = 2, -- Use an MP Boundary Object specified by object_name
		MPBoundaryObjectByObject = 3, -- Use an MP Boundary Object given by an actual object instance

		k_Count = 4,
	},

	typeEnum = nil,

	---------------------------------------------------------
	-- [[ Type-specific members (here for explicitness) ]] --
	---------------------------------------------------------

	--TypeEnum.TriggerVolume
	triggerVolumes = nil,

	--TypeEnum.Sphere
	location = nil,
	radius = nil,

	--TypeEnum.MPBoundaryObject
	MPBoundaryObjectName = nil,

	--TypeEnum.MPBoundaryObjectByObject
	MPBoundaryObject = nil,
};

-- TriggerVolume
function AreaVolume:NewTriggerVolumes(argTriggerVolumes:table):table
	local newAreaVolume:table = CreateParcelInstance(self);
	newAreaVolume.triggerVolumes = argTriggerVolumes;
	newAreaVolume.typeEnum = AreaVolume.TypeEnum.TriggerVolume;
	return newAreaVolume;
end

-- Sphere
function AreaVolume:NewSphere(argLocation:location, argRadius:number):table
	local newAreaVolume:table = CreateParcelInstance(self);
	newAreaVolume.location = argLocation;
	newAreaVolume.radius= argRadius;
	newAreaVolume.typeEnum = AreaVolume.TypeEnum.Sphere;
	return newAreaVolume;
end

function AreaVolume:UpdateSphereLocation(newLocation:location):void
	assert(self.typeEnum == AreaVolume.TypeEnum.Sphere,
		"Attempted to update the Sphere location for an AreaMonitor that was not of type Sphere!");
		
	self.location = newLocation;
end

-- MP Boundary (by object_name)
function AreaVolume:NewMultiplayerBoundary(MPBoundaryObjectName:object_name):table
	local newAreaVolume:table = CreateParcelInstance(self);
	newAreaVolume.MPBoundaryObjectName = MPBoundaryObjectName;
	newAreaVolume.typeEnum = AreaVolume.TypeEnum.MPBoundaryObject;
	return newAreaVolume;
end

-- MP Boundary (by object instance)
function AreaVolume:NewMultiplayerBoundaryByObject(MPBoundaryObject:object):table
	local newAreaVolume:table = CreateParcelInstance(self);
	newAreaVolume.MPBoundaryObject = MPBoundaryObject;
	newAreaVolume.typeEnum = AreaVolume.TypeEnum.MPBoundaryObjectByObject;
	return newAreaVolume;
end

function AreaVolume:UpdateMultiplayerBoundaryObject(newBoundaryObject:object):void
	assert(self.typeEnum == AreaVolume.TypeEnum.MPBoundaryObjectByObject,
		"Attempted to update the MP Boundary Object for an AreaMonitor that was not of type MPBoundaryObjectByObject!");
		
	self.MPBoundaryObject = newBoundaryObject;
end


global AreaMonitor = Parcel.MakeParcel
{
	instanceName = "AreaMonitor",
	complete = false,
	
	previousFrameObjects = {}, 		-- compared against the list of objects gathered in the current frame to figure out who has left and who has arrived
	
	MonitorTypeEnum = table.makeEnum		-- this is an enum used to set the type of objects this monitor is watching for
	{
		AllObjects = 0,						-- ALL objects
		OnFootBipeds = 1,					-- bipeds not in vehicles
		OnFootParticipants = 2,				-- participants (unit bipeds that are players/bots) not in vehicles
		OnFootAndInVehicleBipeds = 3, 		-- bipeds on foot and in vehicles
		OnFootAndInVehicleParticipants = 4,	-- participants (unit bipeds that are players/bots) on foot and in vehicles
		VehicleOnly = 5,					-- vehicles only				
		BipedAndVehicle = 6,				-- bipeds and vehicles
		Unit = 7,							-- all units, i.e. bipeds, vehicles, and giants
	},
	
	monitorType = nil,				-- what type of object this monitor is looking for.  BipedAndVehicle is set by default in New()
	areaVolume = nil,				-- what volume of space (such as a trigger volume, defined at the top of this file, or sphere) that is used in the monitor calculations
	objectCacheData = {},
	
	CONFIG = 
	{
		enableDebugPrint = false,
		updateDeltaSeconds = 0.1, 	-- the length of real time in between checks for objects in the area

		includeDeadObjects = false,
		includeHolograms = false,
	},

	EVENTS =
	{
		onObjectEnter = "OnObjectEnter",
		onObjectExit = "OnObjectExit",

		-- "Simple" version of the OnObjectEnter event that still offers the legacy interface of just the entering object
		-- Note that we don't have one for OnObjectExit, because it is likely to create bugs (since deleted objects will fire that event)
		onObjectEnterSimple = "OnObjectEnterSimple",

		onEnterExitEventsFired = "OnEnterExitEventsFired",
	},
};

global MonitorTypeToObjectTypeMask = {};
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.AllObjects] = ObjectTypeMask.AllObjects;
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.OnFootBipeds] = ObjectTypeMask.Biped;
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.OnFootParticipants] = ObjectTypeMask.Biped;
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleBipeds] = ObjectTypeMask.BipedAndVehicle;	
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleParticipants] = ObjectTypeMask.BipedAndVehicle;	
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.VehicleOnly] = ObjectTypeMask.Vehicle;
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.BipedAndVehicle] = ObjectTypeMask.BipedAndVehicle;
MonitorTypeToObjectTypeMask[AreaMonitor.MonitorTypeEnum.Unit] = ObjectTypeMask.Unit;

hstructure ObjectDataCache
	objectMultiplayerTeam 		:mp_team;
	unitPlayer 					:player;
	unitLastPlayer 				:player;
end

-- NOTE: AreaMonitorObjectEnteredEventArgs and AreaMonitorObjectExitedEventArgs are defined in global_hstructs.lua

function AreaMonitor:New(argName:string, argAreaVolume:table, argMonitorType:number):table
	self:DebugPrint("AreaMonitor:New ", argName);

	local newAreaMonitor:table = self:CreateParcelInstance();
	newAreaMonitor.instanceName = argName or newAreaMonitor.instanceName;
	newAreaMonitor.monitorType = argMonitorType or AreaMonitor.MonitorTypeEnum.BipedAndVehicle;

	assert(argAreaVolume.typeEnum ~= nil and argAreaVolume.typeEnum >= 0 and argAreaVolume.typeEnum < AreaVolume.TypeEnum.k_Count,
		"ERROR: Invalid typeEnum encountered for the argAreaVolume arg in AreaMonitor:New()!");
	newAreaMonitor.areaVolume = argAreaVolume;
	
	return newAreaMonitor;		
end

function AreaMonitor:Run():void
	self:CreateThread(self.AreaStateMonitorRoutine);
end

function AreaMonitor:shouldEnd():boolean
	return self.complete;
end

function AreaMonitor:EndParcel():void
	self.complete = true;
end

-- OnObjectEnter
function AreaMonitor:AddOnObjectEnter(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onObjectEnter, callbackFunc, callbackOwner);
end

function AreaMonitor:RemoveOnObjectEnter(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onObjectEnter, callbackFunc, callbackOwner);
end

-- OnObjectExit
function AreaMonitor:AddOnObjectExit(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onObjectExit, callbackFunc, callbackOwner);
end

function AreaMonitor:RemoveOnObjectExit(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onObjectExit, callbackFunc, callbackOwner);
end

-- OnObjectEnterSimple
function AreaMonitor:AddOnObjectEnterSimple(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onObjectEnterSimple, callbackFunc, callbackOwner);
end

function AreaMonitor:RemoveOnObjectEnterSimple(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onObjectEnterSimple, callbackFunc, callbackOwner);
end

-- OnEnterExitEventsFired
function AreaMonitor:AddOnEnterExitEventsFired(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onEnterExitEventsFired, callbackFunc, callbackOwner);
end

function AreaMonitor:RemoveOnEnterExitEventsFired(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onEnterExitEventsFired, callbackFunc, callbackOwner);
end

--
-- Core object monitoring script
--

function AreaMonitor:ShouldConsiderObjectForCurrentFrameList(objectToConsider, currentFrameHash:table):boolean
	if ((currentFrameHash[objectToConsider] == nil) and
	    Object_IsUnit(objectToConsider) and 
	    (self.CONFIG.includeDeadObjects or not Object_IsDead(objectToConsider)) and
	    (self.CONFIG.includeHolograms or not Unit_IsHologram(objectToConsider))
	   ) then

		return true;
	end

	return false;
end

function AreaMonitor:ConsiderVehiclePassengers(vehicleObject, visitedObjectHash:table, foundObjects:object_list):void
	self:DebugPrint("Considering vehicle passengers...");

	visitedObjectHash[vehicleObject] = true;
	
	local passengers = Vehicle_GetPassengers(vehicleObject);
	if (#passengers > 0) then
		for _, thisPassenger in hpairs(passengers) do
			if (visitedObjectHash[thisPassenger] == nil) then
				if (Unit_GetTreatAsVehicle(thisPassenger)) then
					self:ConsiderVehiclePassengers(thisPassenger, visitedObjectHash, foundObjects);
				else 
					foundObjects[#foundObjects + 1] = thisPassenger;
				end
			end
		end
	end
end

function AreaMonitor:CaptureCurrentFrameObjects(currentFrameObjects:table, currentFrameHash:table, objects:object_list):void
	-- Lots of cached locals here for performance.. AreaMonitor is used everywhere
	local monitorType:number = self.monitorType;
	local filterVehiclesToPassengers:boolean =
		(monitorType == AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleBipeds) or (monitorType == AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleParticipants);
	local restrictToParticipants:boolean =
		(monitorType == AreaMonitor.MonitorTypeEnum.OnFootParticipants) or (monitorType == AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleParticipants);

	local shouldAdd:boolean = nil;
	for _, thisObject in ipairs(objects) do
		if self:ShouldConsiderObjectForCurrentFrameList(thisObject, currentFrameHash) then
			shouldAdd = true;

			-- Eliminate any vehicles from the list, after recursively adding any of their passengers to the end of the object list we are currently iterating
			if filterVehiclesToPassengers and Unit_GetTreatAsVehicle(thisObject) then
				shouldAdd = false;

				-- This function will add passengers to the 'objects' object_list which we're currently iterating for further consideration; this is okay because we're using ipairs
				self:ConsiderVehiclePassengers(thisObject, currentFrameHash, objects);
			end

			-- Do one last filtering pass if we're configured to restrict to Participant units only
			if shouldAdd and restrictToParticipants and not Object_IsOrWasPlayer(thisObject) then
				shouldAdd = false;
			end

			-- Finally add our object to the list of current frame objects if it passed all of our filters
			if shouldAdd then
				currentFrameObjects[#currentFrameObjects + 1] = thisObject;
				currentFrameHash[thisObject] = true;

				self:UpdateObjectCachedData(thisObject);
			end
		end
	end
end

-- This could be 'cleaner' but we're optimizing for as few new allocations as possible, re-using the existing struct where possible
function AreaMonitor:UpdateObjectCachedData(currentObject:object):void
	local currentUnitPlayer:player = Unit_GetPlayer(currentObject);
	local lastUnitPlayer:player = nil;
	if (currentUnitPlayer == nil) then
		lastUnitPlayer = Unit_GetLastPlayer(currentObject);
	end

	local existingCache:ObjectDataCache = self.objectCacheData[currentObject]; -- note this local is a reference
	if (existingCache ~= nil) then
		existingCache.objectMultiplayerTeam = Object_GetMultiplayerTeam(currentObject);
		existingCache.unitPlayer = currentUnitPlayer;
		existingCache.unitLastPlayer = lastUnitPlayer;
	else
		self.objectCacheData[currentObject] = hmake ObjectDataCache
		{
			objectMultiplayerTeam = Object_GetMultiplayerTeam(currentObject),
			unitPlayer = currentUnitPlayer,
			unitLastPlayer = lastUnitPlayer,
		};
	end
end

function AreaMonitor:GenerateObjectExitedArgs(exitingObject:object):AreaMonitorObjectExitedEventArgs
	-- If the object exists, we'll just update the cache and use those newly polled values for the args
	if (Engine_ObjectExists(exitingObject)) then
		self:UpdateObjectCachedData(exitingObject);
		local cachedData:ObjectDataCache = self.objectCacheData[exitingObject];

		return hmake AreaMonitorObjectExitedEventArgs
		{
			exitingObject = exitingObject,
			objectExists = true,
			objectMultiplayerTeam = cachedData.objectMultiplayerTeam,
			unitPlayer = cachedData.unitPlayer,
			unitLastPlayer = cachedData.unitLastPlayer
		};
	-- Otherwise, we'll have to use our (now-stale) cache to give the best info we can
	else
		local cachedData:ObjectDataCache = self.objectCacheData[exitingObject];

		return hmake AreaMonitorObjectExitedEventArgs
		{
			exitingObject = exitingObject,
			objectExists = false,
			objectMultiplayerTeam = cachedData.objectMultiplayerTeam,
			unitPlayer = nil, -- if the object doesn't exist, there's no way we can have a valid attached player..
			unitLastPlayer = cachedData.unitPlayer or cachedData.unitLastPlayer
		};
	end
end

function AreaMonitor:AreaStateMonitorRoutine():void
	self:DebugPrint("AreaMonitor:AreaStateMonitorRoutine started.");

	-- Caching these for performance
	local areaVolumeType:number = self.areaVolume.typeEnum;
	local objectTypeMask:wholenum = MonitorTypeToObjectTypeMask[self.monitorType];

	repeat
		local currentFrameObjects:table = {};
		local currentFrameHash:table = {};
		
		if areaVolumeType == AreaVolume.TypeEnum.MPBoundaryObject then
			local boundaryObject:object = ObjectFromName(self.areaVolume.MPBoundaryObjectName);
			if boundaryObject ~= nil then
				self:CaptureCurrentFrameObjects(currentFrameObjects, currentFrameHash, 
					Object_GetWithinMPBoundaryWithMask(boundaryObject, objectTypeMask));
			end

		elseif areaVolumeType == AreaVolume.TypeEnum.MPBoundaryObjectByObject then
			local boundaryObject:object = self.areaVolume.MPBoundaryObject;
			if boundaryObject ~= nil then
				-- First check to see if our object has been deleted; if so then we'll invalidate the reference and 
				-- effectively report zero contained objects every frame until someone updates self.areaVolume.MPBoundaryObject
				if (object_index_valid(boundaryObject)) then
					self:CaptureCurrentFrameObjects(currentFrameObjects, currentFrameHash, 
						Object_GetWithinMPBoundaryWithMask(boundaryObject, objectTypeMask));
				else
					self.areaVolume.MPBoundaryObject = nil;
				end
			end
			
		elseif areaVolumeType == AreaVolume.TypeEnum.TriggerVolume then
			for _, captureVolume in hpairs(self.areaVolume.triggerVolumes) do
				self:CaptureCurrentFrameObjects(currentFrameObjects, currentFrameHash, 
					-- TODO: replace the call below with VolumeReturnObjectsByObjectTypeMask(captureVolume, objectTypeMask) once the new binding makes it into a green
					volume_return_objects_by_type(captureVolume, MonitorTypeToObjectTypeMask[self.monitorType]));
			end

		elseif areaVolumeType == AreaVolume.TypeEnum.Sphere then
			self:CaptureCurrentFrameObjects(currentFrameObjects, currentFrameHash, 
				Object_GetObjectsInSphere(self.areaVolume.location, self.areaVolume.radius, objectTypeMask));
		end
		
		-- create a new list that contains all objects found this frame, and all objects found last frame.
		local combinedObjects:table = table.combine(currentFrameObjects, self.previousFrameObjects);
		-- the difference between the current frame objects, and the combined objects results in a list of objects 
		-- that were here last frame, but are not here this frame.  AKA the objects who have exited.
		local leavingObjects:table = table.dif(currentFrameObjects, combinedObjects);
		-- the difference between the previous frame objects, and the combined objects results in a list of objects 
		-- that were not here last frame, but are here this frame.  AKA the objects who have entered.
		local enteringObjects:table = table.dif(self.previousFrameObjects, combinedObjects);

		local anyEventsFired:boolean = false;
		
		-- fire the event for each object who has left
		for _, leavingObject in hpairs(leavingObjects) do
			anyEventsFired = true;
			self:DebugPrint("Triggering OnObjectExit; obj=", leavingObject);
			self:TriggerEvent(self.EVENTS.onObjectExit, self:GenerateObjectExitedArgs(leavingObject), self);

			-- Clear our object data cache when an object leaves so we don't bloat memory
			self.objectCacheData[leavingObject] = nil;
		end
		
		-- fire the event for each object who has entered
		for _, enteringObject in hpairs(enteringObjects) do
			anyEventsFired = true;
			self:DebugPrint("Triggering OnObjectEnter; obj=", enteringObject);

			-- We can just use the object cache for ObjectEntered events since it was freshly built this frame in CaptureCurrentFrameObjects()
			local cacheData:ObjectDataCache = self.objectCacheData[enteringObject];
			local eventArgs:AreaMonitorObjectEnteredEventArgs = hmake AreaMonitorObjectEnteredEventArgs
			{
				enteringObject = enteringObject,
				objectMultiplayerTeam = cacheData.objectMultiplayerTeam,
				unitPlayer = cacheData.unitPlayer,
				unitLastPlayer = cacheData.unitLastPlayer
			};
			self:TriggerEvent(self.EVENTS.onObjectEnter, eventArgs, self);
			self:TriggerEvent(self.EVENTS.onObjectEnterSimple, enteringObject, self);
		end
		
		-- hold on to the list of objects found in the trigger volume for comparisons next frame.
		self.previousFrameObjects = currentFrameObjects;

		-- if we fired any events this frame, then let subscribing parcels know we are done for this frame.
		if anyEventsFired then
			self:TriggerEvent(self.EVENTS.onEnterExitEventsFired, self);
		end
	
		SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self:shouldEnd();
end

--
-- External accessors
--

function AreaMonitor:GetMPBoundaryObject():object
	if self.areaVolume.typeEnum == AreaVolume.TypeEnum.MPBoundaryObject then
		return ObjectFromName(self.areaVolume.MPBoundaryObjectName);
	elseif self.areaVolume.typeEnum == AreaVolume.TypeEnum.MPBoundaryObjectByObject then
		return self.areaVolume.MPBoundaryObject;
	elseif self.areaVolume.typeEnum == AreaVolume.TypeEnum.Sphere then
		return self.areaVolume.location;
	end

	return nil;
end

function AreaMonitor:ContainsObject(argObject):boolean
	return table.contains(self.previousFrameObjects, argObject);	
end

function AreaMonitor:GetPreviousFrameContainedObjects():table
	return self.previousFrameObjects;
end

--
-- Debug
--

function AreaMonitor:DebugPrint(...):void
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	if (self.CONFIG.enableDebugPrint) then
		print(self.instanceName .. ":", unpack(arg));
	end	
end

function AreaMonitor:EnableDebugPrint(enable:boolean):void
	self.CONFIG.enableDebugPrint = enable;
end
