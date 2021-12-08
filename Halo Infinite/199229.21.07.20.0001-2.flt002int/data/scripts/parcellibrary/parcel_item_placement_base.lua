-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');


global DeploymentState:table = table.makeAutoEnum
{
	"Dormant",
	"Incoming",
	"Restricted",
	"Spawned",
};

global ItemPlacementBase:table = Parcel.MakeParcel
{
	canStart = false,
	complete = false,

	itemTag = nil,
	itemConfig = nil,
	itemStringId = "",
	itemScale = 1,
	spawnedItemObject = nil,
	containerObject = nil,
	hasInvisibleDispenser = false,
	itemShouldRotate = false,
	loadingPlayrateRange = 0,

	hasDoneInitialSpawn = false,
	deploymentState = DeploymentState.Dormant,

	childMarker = "",
	spawnMarker = "",

	CONFIG = 
	{
		enableDebugPrint = false,	-- A debug variable used to enable/disable debug prints in the parcel.
		debugPrintInstance = nil,	-- If not nil, printing will be limited to just this instance

		updateDeltaSeconds = 0.1,
		
		stockAnimDelay = 0,
		scaleFudgeFactor = 0.01,
	},

	CONST =
	{
		inactiveColor = 0.5,
		activeColor = 1,
		restrictedColor = 0,
		colorLerpTime = 0.2,
		statusBarColorName = "emissive_on",
		loadingAnimateName = "is_loading",
		openingAnimateName = "is_opening",
		closingAnimateName = "is_closing",
		rotatingAnimateName = "is_rotating",
		loadingSpeedName = "loading_playrate",
		loadingAnimationRawDuration = 30,	-- at default speed, animation takes 30 seconds
		loadingAnimationMaxRate = 30,	-- 1 sec is the minimum for incoming state
		loadingAnimationMinRate = 0.05,	-- 10 minutes (600 secs) is our absolute maximum for incoming state
	},

	EVENTS = 
	{
		onItemPickedUp = "onItemPickedUp",
		onItemBlastDetach = "onItemBlastDetach",
	},
}

function ItemPlacementBase:CreateSubclass():table
	local subClass = ParcelParent(self);
	return table.makePermanent(subClass);				-- subclass definitions should also be static/permanent
end

function ItemPlacementBase:SleepUntilValid():void		-- virtual
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function ItemPlacementBase:IsComplete():boolean
	return self.complete;
end

function ItemPlacementBase:shouldEnd():boolean
	return self:IsComplete();
end

function ItemPlacementBase:EndShutdownBase():void
	if (self.spawnedItemObject ~= nil) then 
		Object_Delete(self.spawnedItemObject);
		self.spawnedItemObject = nil;
	end
end

function ItemPlacementBase:EndShutdown():void	-- virtual
	self:EndShutdownBase();
end

--
--	INTERNAL PARCEL LOGIC
--

function ItemPlacementBase:NewItemPlacementBase(initArgs:ItemPlacementBaseInitArgs):table
	local newItemPlacementBase = self:CreateParcelInstance();

	assert(initArgs ~= nil);

	newItemPlacementBase.instanceName = initArgs.instanceName;
	newItemPlacementBase.containerObject = initArgs.containerObject;

	if (initArgs.hasInvisibleDispenser ~= nil) then
		newItemPlacementBase.hasInvisibleDispenser = initArgs.hasInvisibleDispenser;
	end

	if (initArgs.stockAnimDelay ~= nil) then
		newItemPlacementBase.CONFIG.stockAnimDelay = initArgs.stockAnimDelay;
	end

	if (initArgs.itemShouldRotate ~= nil) then
		newItemPlacementBase.itemShouldRotate = initArgs.itemShouldRotate;
	end

	newItemPlacementBase.loadingPlayrateRange = newItemPlacementBase.CONST.loadingAnimationMaxRate - newItemPlacementBase.CONST.loadingAnimationMinRate;
	debug_assert(newItemPlacementBase.loadingPlayrateRange > 0, "Loading playrate range must be greater than zero");

	return newItemPlacementBase;
end

function ItemPlacementBase:InitializeContainer():void		-- virtual
	self.deploymentState = DeploymentState.Dormant;

	if (self.hasInvisibleDispenser) then
		-- just hide the asset but still function as usual
		object_hide(self.containerObject, true);
	else
		self:SetStatusBarColor(self.CONST.inactiveColor, 0);
	end
end

function ItemPlacementBase:CanTriggerExternally():boolean	-- virtual
	return true;
end

function ItemPlacementBase:TriggerItemSpawn():boolean		-- virtual
	if (not ParcelIsValid(self)) then
		print("ItemPlacementBase: Cannot attempt to externally trigger item spawn until parcel has been initialized");
		return false;
	end

	if (self.spawnedItemObject == nil and self:CanTriggerExternally()) then
		self:StartSpawningState();
		return true;
	end

	return false;
end

function ItemPlacementBase:StartSpawningState():void	-- virtual
	self:DebugPrint("ItemPlacementBase:StartSpawningState()");

	self:PlayOpenAnimation();
	self:StockContainer();
end

function ItemPlacementBase:GotoLoadingAnimState():void	-- virtual
	self:GotoLoadingAnimStateBase();
end

function ItemPlacementBase:GotoLoadingAnimStateBase():void
	self:EnableClientVisibilityWakeManager(false);

	Object_SetFunctionValue(self.containerObject, self.CONST.loadingAnimateName, 1, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.closingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.rotatingAnimateName, 0, 0);

	SleepSeconds(0.1);	-- wait a bit here because close anim has bar at 100% (to allow for unavailable) and loading starts at 0%, but we get a small blue flash during blend, so leave black until blend is over
	self:SetStatusBarColor(self.CONST.activeColor, self.CONST.colorLerpTime);
end

function ItemPlacementBase:GotoOpeningAnimState():void	-- virtual
	self:GotoOpeningAnimStateBase();
end

function ItemPlacementBase:GotoOpeningAnimStateBase():void
	self:EnableClientVisibilityWakeManager(false);

	Object_SetFunctionValue(self.containerObject, self.CONST.loadingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 1, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.closingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.rotatingAnimateName, 0, 0);

	if (self.itemShouldRotate) then
		self:CreateThread(self.WaitForRotation);
	end
end

function ItemPlacementBase:GotoClosingAnimState():void	-- virtual
	self:GotoClosingAnimStateBase();
end

function ItemPlacementBase:GotoClosingAnimStateBase():void
	self:EnableClientVisibilityWakeManager(false);

	Object_SetFunctionValue(self.containerObject, self.CONST.loadingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.closingAnimateName, 1, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.rotatingAnimateName, 0, 0);
end

function ItemPlacementBase:GotoRotatingAnimState():void	-- virtual
	self:GotoRotatingAnimStateBase();
end

function ItemPlacementBase:GotoRotatingAnimStateBase():void
	Object_SetFunctionValue(self.containerObject, self.CONST.loadingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.openingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.closingAnimateName, 0, 0);
	Object_SetFunctionValue(self.containerObject, self.CONST.rotatingAnimateName, 1, 0);

	SleepSeconds(0.1);
	self:EnableClientVisibilityWakeManager(true);
end

function ItemPlacementBase:WaitForRotation():void		-- virtual
end

function ItemPlacementBase:SetLoadingAnimationPlayRate(duration:number):void
	if (self.hasInvisibleDispenser) then
		return;
	end

	local playRate:number = self.CONST.loadingAnimationRawDuration / math.max(1, duration);

	-- numbers here seem backwards because we're talking rate, not duration. the valid range for rate = 0.05 (600 secs) to 30 (1 sec)
	debug_assert(playRate >= 0.05, "Item spawner play rate is outside of the valid range. Respawn times over 10 minutes are not supported");

	local playRateFn:number = (playRate - self.CONST.loadingAnimationMinRate) / self.loadingPlayrateRange;

	self:DebugPrint("ItemPlacementBase:SetLoadingAnimationPlayRate()", duration, playRateFn);
	Object_SetFunctionValue(self.containerObject, self.CONST.loadingSpeedName, playRateFn, 0);
end

function ItemPlacementBase:PlayOpenAnimation():void
	if (self.hasInvisibleDispenser) then
		return;
	end

	self:GotoOpeningAnimState();
	self:SetStatusBarColor(self.CONST.activeColor, self.CONST.colorLerpTime);

	SleepSeconds(self.CONFIG.stockAnimDelay);
end

function ItemPlacementBase:PlayCloseAnimation():void
	if (self.hasInvisibleDispenser) then
		return;
	end

	self:SetStatusBarColor(self.CONST.inactiveColor, self.CONST.colorLerpTime);
	self:GotoClosingAnimState();
end

function ItemPlacementBase:SetStatusBarColor(colorVal:number, lerpTime:number):void
	if (self.hasInvisibleDispenser) then
		return;
	end

	Object_SetFunctionValue(self.containerObject, self.CONST.statusBarColorName, colorVal, lerpTime);
end

function ItemPlacementBase:EnableClientVisibilityWakeManager(enable:boolean):void
	self:DebugPrint("ItemPlacementBase:EnableClientVisibilityWakeManager()", enable);
	RunClientScript("EnableVisibilityWakeManager", self.containerObject, enable);
end

function ItemPlacementBase:StockContainer():void		-- virtual
	if (self.spawnedItemObject == nil) then
		self:CreateItemObject();
	end

	if (self:SpawnWasSuccessful()) then
		self:OnSuccessfulSpawn();
	end
end

function ItemPlacementBase:SpawnWasSuccessful():boolean	-- virtual
	return self.spawnedItemObject ~= nil;
end

function ItemPlacementBase:OnSuccessfulSpawn():void		-- virtual
	self:DebugPrint("ItemPlacementBase:OnSuccessfulSpawn()");
	self:OnSuccessfulSpawnBase();
end

function ItemPlacementBase:OnSuccessfulSpawnBase():void
	self:SetPostSpawnState();
	self:CreateThread(self.ForceScaleUpdateRoutine);
	Object_RegisterForCandyMonitorGarbageCollection(self.spawnedItemObject);
end

function ItemPlacementBase:SetPostSpawnState():void		-- virtual
	self.deploymentState = DeploymentState.Spawned;
end

function ItemPlacementBase:ForceScaleUpdateRoutine():void
	-- This is some serious hackery because clients assume items are "on ground" and use that scale upon creation
	-- Prior to attachment to container, item was scaled slightly larger so setting to correct scale here will
	-- force server to update client scale
	if (self.hasDoneInitialSpawn) then
		Sleep(1);
	else
		SleepSeconds(1);
		self.hasDoneInitialSpawn = true;
	end

	self:ForceItemToCorrectScale();
end

function ItemPlacementBase:ForceItemToCorrectScale():void		-- virtual
	Object_SetScale(self.spawnedItemObject, self.itemScale, 0);
end

function ItemPlacementBase:CreateItemObject():void	-- virtual
	self:DebugPrint("ItemPlacementBase:CreateItemObject():", self.itemTag);

	if (self.containerObject == nil) then
		print("FATAL ERROR: No container object found in", self.instanceName, "This is very bad.");
		return;
	end

	if (self.itemConfig ~= nil) then
		self.spawnedItemObject = Object_CreateFromTagWithConfiguration(self.itemTag, self.itemConfig);	-- position will either be handled by marker, or by setting transform below
	else
		self.spawnedItemObject = Engine_CreateObject(self.itemTag, Object_GetPosition(self.containerObject));
	end

	if (self.spawnedItemObject ~= nil) then
		Object_SetScale(self.spawnedItemObject, self.itemScale + self.CONFIG.scaleFudgeFactor, 0);

		if (not self.hasInvisibleDispenser) then
			self:AttachItemToParent(self.containerObject, self.spawnMarker, self.spawnedItemObject, self.childMarker);
		else
			SetObjectTransform(self.spawnedItemObject, GetObjectTransform(self.containerObject));
		end
	end
end

function ItemPlacementBase:AttachItemToParent(parent:object, parentMarker:string, item:object, childMarker:string):void
	Item_SetRetainScaleOnHierarchyChange(item, true);
	Object_AttachScaledObjectToMarker(parent, parentMarker, item, childMarker);
	Item_SetRetainScaleOnHierarchyChange(item, false);
end

function ItemPlacementBase:GoToDormantState():void		-- virtual
	self.deploymentState = DeploymentState.Dormant;
	self:SetStatusBarColor(self.CONST.inactiveColor, self.CONST.colorLerpTime);
end

function ItemPlacementBase:IsDormant():boolean
	return self.deploymentState == DeploymentState.Dormant;
end

function ItemPlacementBase:GoToRestrictedState():void	-- virtual
	self:GoToRestrictedStateBase();
end

function ItemPlacementBase:GoToRestrictedStateBase():void
	self.deploymentState = DeploymentState.Restricted;
	self:SetStatusBarColor(self.CONST.restrictedColor, self.CONST.colorLerpTime);
end

-- UTILITY

-- This function is SUPER hacky, but necessary as Lua's PushObject normally returns a 'ui64', but will return a 'struct' type
-- if the object has a script on it. In this case, the object's handle is placed as userdata inside the struct. Equality check 
-- fails because of the type mismatch, hence the string compare. A long term solution for this would be advisable (v-darsc)
function ItemPlacementBase:AreObjectsEqual(obj1:object, obj2:object):boolean
	if (obj1 == obj2) then
		return true;
	elseif (type(obj1) == "struct" or type(obj2) == "struct") then
		self:DebugPrint("Object equality type mismatch: Type1", type(obj1), "Type2", type(obj2))
		local str1, str2;
		if (type(obj1) == "struct") then
			str1 = tostring(obj1.instance);
		else
			str1 = tostring(obj1);
		end

		if (type(obj2) == "struct") then
			str2 = tostring(obj2.instance);
		else
			str2 = tostring(obj2);
		end

		str1 = string.upper(string.sub(str1, #str1 - 7));
		str2 = string.upper(string.sub(str2, #str2 - 7));

		return str1 == str2;
	end

	return false;
end

-- DEBUGGING

function ItemPlacementBase:EnableDebugPrint(enable:boolean):void
	self.CONFIG.enableDebugPrint = enable;
end

function ItemPlacementBase:SetDebugPrintInstance(instanceName:string):void
	self.CONFIG.debugPrintInstance = instanceName;
end

function ItemPlacementBase:DebugPrint(...):void		-- virtual
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	if (self.CONFIG.enableDebugPrint and (self.CONFIG.debugPrintInstance == nil or self.CONFIG.debugPrintInstance == self.instanceName)) then
		print(...);
	end	
end

function ItemPlacementBase:GetDeploymentStateName():string
	return table.getEnumValueAsString(DeploymentState, self.deploymentState);
end

--## CLIENT

function remoteClient.SetVisibilityWakeManagerSleepLocking(container:object, enable:boolean)
	Object_SetVisibilityWakeManagerSleepLocking(container, enable);
end

function remoteClient.EnableVisibilityWakeManager(container:object, enable:boolean)
	Object_SetVisibilityWakeManagerEnabled(container, enable);
end
