-- object nseq_gaze
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
-- ====================================================================================================== --
-- the server side of this kit is to:
-- -- 1) toggling fields for input to the gaze kit modes
-- -- 2) kit state such as enabled, initialized, etc.
-- -- 3) provide external API such as start/stop to level scripts and other uses
-- ====================================================================================================== --

REQUIRES('globals\scripts\callbacks\GlobalWeaponCallbacks.lua');

hstructure nseq_gaze
	meta : table;
	instance : luserdata;
	components : userdata;

	-- KIT STATE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	-- basic flags -- TODO -- move to narrative base kit
	initialized: boolean;
	enabled: boolean;					--$$ METADATA { "visible": true, "tooltip": "If false, will wait until true." }
	triggered: boolean;
	disableOnCompletion: boolean;		--$$ METADATA { "visible": true, "tooltip": "If true, will only work on first trigger entry." }
	disableOnEnter: boolean;			--$$ METADATA { "visible": true, "tooltip": "If true, will disable the kit after entering the activation volume." }
	disableOnExit: boolean;				--$$ METADATA { "visible": true, "tooltip": "If true, will disable the kit after exiting the activation volume." }
	completed: boolean;
	interrupted: boolean;
	ignoreVolume: boolean;				--$$ METADATA { "visible": true, "tooltip": "If true, will ignore the trigger volume to start gaze." }
	ignoreVolumeEnter: boolean;			--$$ METADATA { "visible": true, "tooltip": "If true, will ignore the trigger volume is entered." }
	ignoreVolumeExit: boolean;			--$$ METADATA { "visible": true, "tooltip": "If true, will ignore the trigger volume is exited." }


	-- gaze type drop down
	gazeType: string;					--$$ METADATA { "visible": true, "source": ["autolock", "cage", "endpickup", "gameplay", "objectlock", "pickup", "quicklook", "quicklooksmooth", "softlock"], "tooltip": "Default is autolock.  Quicklook forces look at all points in set.  Softlock returns to point of interest after specified input delay.  Object lock uses an external object for autolock." }

	-- SHARED CAGE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	-- cage vars (set in SetupFOV)
	thirdPerson: boolean;				--$$ METADATA { "visible": true, "tooltip": "If true uses a third person camera.  If false, uses a first person cage." }
	thirdFov: number;					--$$ METADATA { "visible": true,  "min": 45, "max": 85, "tooltip": "FOV override." }
	blendTimeIn: number;				--$$ METADATA { "visible": true, "tooltip": "Blend time into cage." }
	blendTimeOut: number;				--$$ METADATA { "visible": true, "tooltip": "Blend time out of cage." }
	cageWeight: number;
	preserveProperties: boolean;		--$$ METADATA { "visible": true, "tooltip": "Uses the current camera properties on the cage stack instead of the given camera poperties (if possible)." }

	-- poi vars (set in SetupGazePOI)
	breakawayAngle: number;				--$$ METADATA { "visible": true, "min": 0, "max": 90, "tooltip": "Breakaway from POI angle." }
	breakawayVelocity: number;			--$$ METADATA { "visible": true, "tooltip": "POI look at velocity in degrees per second." }
	breakawayDistance: number;			--$$ METADATA { "visible": true, "tooltip": "Max distance to require breakaway restrictions for the POI." }
	breakawayInnerAngle: number;		--$$ METADATA { "visible": true, "tooltip": "Radius around the POI we pull the player's gaze to. Once we are inside this radius, we stop controllilng the player's gaze." }

	-- cage offset (constructed in kit init)
	cageOrbitCenterHeight: number;		--$$ METADATA { "visible": true, "tooltip": "Third person only.  Center height from player root to offset from." }
	cageOrbitOffsetX: number;			--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera offset X." }
	cageOrbitOffsetY: number;			--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera offset Y." }
	cageOrbitOffsetZ: number;			--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera offset Z." }
	cageOrbitOffset: vector;

	cageOrbitRotationYaw: number;		--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera Rotation X." }
	cageOrbitRotationPitch: number;		--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera Rotation Y." }
	cageOrbitRotationRoll: number;		--$$ METADATA { "visible": true, "tooltip": "Third person only.  Orbit Camera Rotation Z." }
	cageOrbitRotation: vector;

	gazeLocation: location;

	-- animation modes
	shouldPlayerLookAt: boolean;		--$$ METADATA { "visible": true, "tooltip": "Should the player look at static marker." }
	animationMode: string;				--$$ METADATA { "visible": true, "prettyName":"animationMode (DEPRECATED)", "tooltip": "Deprecated, do not use." }

	-- back to gameplay vars
	toGameplayOnEnter: boolean;			--$$ METADATA { "visible": true, "tooltip": "Return back to gameplay cameras on activation volume enter." }
	toGameplayOnExit: boolean;			--$$ METADATA { "visible": true, "tooltip": "Return back to gameplay cameras on activation volume exit." }
	toGameplayOnFinish: boolean;		--$$ METADATA { "visible": true, "tooltip": "Return back to gameplay cameras when the gaze kits finishes." }

	-- gaze vars
	clearGazeOnEnter: boolean;			--$$ METADATA { "visible": true, "tooltip": "Clears all gaze points when we enter the activation volume." }
	clearGazeOnExit: boolean;			--$$ METADATA { "visible": true, "tooltip": "Clears all gaze points when we enter the activation volume." }

	-- SPECIFIC MODE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	-- quick look vars
	quickLookSeconds: number;				--$$ METADATA { "visible": true, "tooltip": "Time in seconds to look at each quick look point.  Used in quicklook only." }
	quickLookInitialDelay: number;			--$$ METADATA { "visible": true, "tooltip": "Initial delay before quicklook points start.  Used in quicklook only." }
	quickLookSmoothTransitionTime: number	--$$ METADATA { "visible": true, "tooltip": "The time a smooth transition takes.  Used in quicklook only." }
	quickLookExternalProgress: boolean;		--$$ METADATA { "visible": true, "tooltip": "Quick look points progression is externally triggered.  Used in quicklook only." }
	quickLookClearGaze: boolean;			--$$ METADATA { "visible": true, "tooltip": "Clears the gaze targets when finished.  Used in quicklook only." }
	clamped: boolean;						--$$ METADATA { "visible": true, "tooltip": "Quicklook only - clamp player gaze within certain angle of look at." }
	clampedAngle: number;					--$$ METADATA { "visible": true, "min": 0, "max": 90, "tooltip": "Quicklook only - If clamping gaze, sets max angle of clamp." }

	-- pickup vars
	pickupObjectTag: tag;				--$$ METADATA { "visible": true, "tooltip": "The object type we are waiting to be picked up.", "allowedExtensions": ["weapon"] }
	pickupCount: number;				--$$ METADATA { "visible": true, "tooltip": "The number of times we activate on pickup before completing." }
	pickupHideHUD: boolean;				--$$ METADATA { "visible": true, "tooltip": "Hide's the HUD when the object is picked up." }

	-- soft lock vars
	softLockStartSeconds: number;		--$$ METADATA { "visible": true, "tooltip": "Time in seconds without look input before soft lock engages.  Used in softlock gazeType." }

	-- biped narrative mode vars
	playerUnitEnterNarrativeMode: boolean;			--$$ METADATA { "visible": true, "tooltip": "Whether or not the player should enter narrative mode when this is activated." }
	playerUnitNarrativeModeKeepWeapons: boolean;	--$$ METADATA { "visible": true, "tooltip": "If the player unit enters narrative mode, should we keep weapons or go unarmed?" }
	playerUnitNarrativeModeSpeedScale: number;		--$$ METADATA { "visible": true,  "min": 0.2, "max": 1, "tooltip": "Movement speed scale in this narrative moment. Sprint is always disabled." }

	-- object lock vars
	lockObject: object;

	-- helpers
	quickLookThread: thread;
	softLockThread: thread;

	quickLookPointIndex: number;

	pickupObjectsAlreadyGrabbed: table;

	combatMonitors: table;
end

global g_pickupCallbacks: table = ArrayClass:New();

-- ====================================================================================================== --
-- INIT
-- ====================================================================================================== --
function nseq_gaze:init():void
	CageInterface.SetDebugPrint(true);

	if self.initialized == true then
		return; -- don't init twice
	end

	CageInterface.DebugPrint("nseq_gaze init -", self.components.NAME);

	-- KIT STATE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	self.initialized = true;
	self.enabled = (self.enabled ~= false); -- this defaults to true
	if self.enabled == false then
		CageInterface.DebugPrint("nseq_gaze init -", self.components.NAME, "not enabled");
	end

	-- TODO -- state needs to move to client responsibility -- recap with Jason on this note
	self.triggered = false;
	self.disableOnCompletion = self.disableOnCompletion or false;
	self.disableOnEnter = self.disableOnEnter or false;
	self.disableOnExit = self.disableOnExit or false;
	self.completed = false;
	self.interrupted = false;
	self.ignoreVolume = self.ignoreVolume or false;

	self.ignoreVolumeEnter = self.ignoreVolumeEnter or false;
	self.ignoreVolumeExit = self.ignoreVolumeExit or false;

	self.gazeType = self.gazeType or "autolock";

	-- SHARED CAGE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	self.thirdPerson = (self.thirdPerson ~= false); -- this defaults to true
	self.thirdFov = self.thirdFov or 54;
	self.blendTimeIn = self.blendTimeIn or 2;
	self.blendTimeOut = self.blendTimeOut or 2;
	self.cageWeight = self.cageWeight or 1;
	self.preserveProperties = self.preserveProperties or false;

	if self.gazeType == "softlock" then
		self.breakawayAngle = 360;
	else
		self.breakawayAngle = self.breakawayAngle or 45;
	end

	self.breakawayDistance = self.breakawayDistance or 10;
	self.breakawayVelocity = self.breakawayVelocity or 80;
	self.breakawayInnerAngle = self.breakawayInnerAngle or 0;

	self.cageOrbitCenterHeight = self.cageOrbitCenterHeight or .65;
	self.cageOrbitOffsetX = self.cageOrbitOffsetX or -.55;
	self.cageOrbitOffsetY = self.cageOrbitOffsetY or -.3;
	self.cageOrbitOffsetZ = self.cageOrbitOffsetZ or -.13;
	self.cageOrbitOffset = vector(self.cageOrbitOffsetX, self.cageOrbitOffsetY, self.cageOrbitOffsetZ);

	self.cageOrbitRotationYaw = self.cageOrbitRotationYaw or 0;
	self.cageOrbitRotationPitch = self.cageOrbitRotationPitch or 0;
	self.cageOrbitRotationRoll = self.cageOrbitRotationRoll or 0;
	self.cageOrbitRotation = vector(self.cageOrbitRotationYaw, self.cageOrbitRotationPitch, self.cageOrbitRotationRoll);

	self.gazeLocation = self.gazeLocation or ToLocation(self.components.gaze_static_marker); -- send over as object or as XYZ

	self.shouldPlayerLookAt = (self.shouldPlayerLookAt ~= false); -- this defaults to true
	self.animationMode = self.animationMode;

	self.toGameplayOnEnter = self.toGameplayOnEnter or false;
	self.toGameplayOnExit = self.toGameplayOnExit or false;
	self.toGameplayOnFinish = (self.toGameplayOnFinish ~= false); -- this defaults to true

	self.clearGazeOnEnter = self.clearGazeOnEnter or false;

	-- SPECIFIC MODE PROPERTIES ----------------------------------------------------------------------------------------------------------------------

	self.quickLookSeconds = self.quickLookSeconds or 1;
	if self.quickLookSeconds <= 0 then
		self.quickLookSeconds = 0.5;
	end
	self.quickLookInitialDelay = self.quickLookInitialDelay or 0;
	self.quickLookSmoothTransitionTime = self.quickLookSmoothTransitionTime or 1;
	self.quickLookExternalProgress = self.quickLookExternalProgress or false;
	self.quickLookClearGaze = self.quickLookClearGaze or false;

	self.clamped = (self.clamped ~= false); -- this defaults to true
	self.clampedAngle = self.clampedAngle or 30;

	if self.gazeType == "pickup" or self.gazeType == "endpickup" then
		if g_pickupCallbacks.count == 0 then
			RegisterGlobalEvent(g_eventTypes.weaponPickupEvent, GazeKit_PickedUpObject);
		end

		self.disableOnCompletion = true;
		g_pickupCallbacks:Add(self);

		if self.gazeType == "endpickup" then
			self:EndOnPickupStart();
		end
	end

	self.pickupCount = self.pickupCount or 1;
	self.pickupHideHUD = self.pickupHideHUD or false;

	self.softLockStartSeconds = self.softLockStartSeconds or 1;

	self.lockObject = nil;

	self.playerUnitEnterNarrativeMode = self.playerUnitEnterNarrativeMode or false;
	self.playerUnitNarrativeModeKeepWeapons = self.playerUnitNarrativeModeKeepWeapons or false;
	self.playerUnitNarrativeModeSpeedScale = self.playerUnitNarrativeModeSpeedScale or 0.2;

	-- helpers
	self.quickLookThread = nil;
	self.softLockThread = nil;

	self.quickLookPointIndex = 0;

	self.pickupObjectsAlreadyGrabbed = ArrayClass:New();

	self.combatMonitors = {};
end

-- what's expected to be called elsewhere on the kit
-- ====================================================================================================== --
-- GAZE KIT API
-- ====================================================================================================== --
function nseq_gaze:ExternalStartAll():void
	for _, player in hpairs(PLAYERS.active) do
		self:ExternalStart(player);
	end
end

function nseq_gaze:ExternalStart(player:player):void
	self:StartGaze(player);
end

function nseq_gaze:ExternalStopAll():void
	for _, player in hpairs(PLAYERS.active) do
		self:ExternalStop(player);
	end
end

function nseq_gaze:ExternalStop(player:player):void
	self:ExitGaze(player);
end

function nseq_gaze:ExternalQuickLookProgressAll(overrideTransitionTime:number):void
	for _, player in hpairs(PLAYERS.active) do
		self:ExternalQuickLookProgress(player, overrideTransitionTime);
	end
end

function nseq_gaze:ExternalQuickLookProgress(player:player, overrideTransitionTime:number):void
	if self.gazeType ~= "quicklooksmooth" or self.quickLookExternalProgress == false then
		return;
	end

	local pointSet:point_set = self.components.quicklook_points;
	local pointSetSize:number = Spline_GetPointCount(pointSet);

	if self.quickLookPointIndex > (pointSetSize - 1) then
		return;
	end

	local pointN:point = ai_point_set_get_point(pointSet, self.quickLookPointIndex);

	if overrideTransitionTime == nil then
		overrideTransitionTime = self.quickLookSmoothTransitionTime;
	end

	CageInterface.DebugPrint("Quicklooksmooth at pointset index", self.quickLookPointIndex);

	RunClientScript(
		"GazeKit_QuickLookAtPointSmooth",
		player,
		pointN,
		self.quickLookPointIndex,
		overrideTransitionTime,
		self.quickLookPointIndex >= (pointSetSize - 1));

	self.quickLookPointIndex = self.quickLookPointIndex + 1;

	if self.quickLookPointIndex > (pointSetSize - 1) then
		SleepSeconds(overrideTransitionTime);

		if self.toGameplayOnFinish == true then
			self:ExitGaze(player);
		end

		if self.quickLookClearGaze == true then
			self:ClearGazePoints(player);
		end
	end
end

function nseq_gaze:StartGaze(player:player): void
	-- don't run if:
	-- kit is not enabled
	-- I was interrupted
	-- I haven't finished, but disable on complete is true
	-- OR I don't care if I'm finished or not, play anyway
	if self.enabled == true and
		self.interrupted == false and
		(self.disableOnCompletion == false or self.completed == false) and
		(Player_IsValid(player)) and
		(not IsPlayerInCombat(player)) then

		self.triggered = true;

		-- make a table if this is externally started before init.
		if self.combatMonitors == nil then 
			self.combatMonitors = {};
		end
		
		self.combatMonitors[player] = CreateKitThread(self, self.CombatMonitor, self, player);

		if self.gazeType == "autolock" then
			self:AutoLock(player);
		elseif self.gazeType == "cage" then
			self:GoToCage(player);
			CageInterface.SwitchToCageCamera(player);
			self:PlayerEnterNarrativeMode(player);
		elseif self.gazeType == "gameplay" then
			self:ExitGaze(player);
		elseif self.gazeType == "objectlock" then
			self:ObjectLock(player);
		elseif self.gazeType == "pickup" then
			self:GoToCage(player);
			CageInterface.SwitchToCageCamera(player);

			self.pickupCount = self.pickupCount - 1;
			self.completed = self.pickupCount <= 0;
			--hud_disable = self.pickupHideHUD;
			-- hud_show(not self.pickupHideHUD);

			if self.completed == true then
				CageInterface.DebugPrint("Gaze Kit -- Pickup Count Reached", self.components.NAME);
				self:terminate();
			end

		elseif self.gazeType == "endpickup" then
			self:GoToCage(player);
			CageInterface.SwitchToCageCamera(player);

		elseif self.gazeType == "quicklook" then
			self.quickLookThread = CreateKitThread(self, self.QuickLook, self, player);
		elseif self.gazeType == "quicklooksmooth" then
			self.quickLookThread = CreateKitThread(self, self.QuickLookSmooth, self, player);
		elseif self.gazeType == "softlock" then
			self.softLockThread = CreateKitThread(self, self.SoftLock, self, player);
		end
	end
end

function nseq_gaze:ExitGaze(player:player):void
	CageInterface.SwitchToGameplayCamera(player, self.blendTimeOut);
	-- hud_disable = false;
	-- hud_show(true);

	if(player) then
		KillThread(self.combatMonitors[player]);
		self.combatMonitors[player] = nil;
	end

	self:PlayerExitNarrativeMode(player);

	self.completed = true;
	self:terminate();
end

function nseq_gaze:CombatMonitor(player:player):void
	SleepUntil([|IsSpartanInCombat(Player_GetUnit(player))],1);
	--print("player in combat, break out of gaze");
	self:ExitGaze(player);
	if(player) then
		KillThread(self.combatMonitors[player]);
		self.combatMonitors[player] = nil;
	end
end

function nseq_gaze:SetObjectToLookAt(lockObj:object):void
	if lockObj == nil then
		CageInterface.DebugPrint("nseq_gaze -- Gaze passed a nil object for ObjectLock --", self.components.NAME);
	end

	self.lockObject = lockObj;
end

-- TODO -- could be useful to enforce internal use with namespace if the issue comes up
-- ====================================================================================================== --
-- SPECIFIC MODES
-- ====================================================================================================== --
function nseq_gaze:GoToCage(player:player):void
	RunClientScript(
		"GazeKit_SetupCage",
		player,
		self.thirdPerson,
		self.thirdFov,
		self.blendTimeIn,
		self.cageOrbitCenterHeight,
		self.cageOrbitOffset,
		self.cageOrbitRotation,
		self.preserveProperties,
		self.gazeType == "pickup");

	RunClientScript(
		"GazeKit_SetupPOI",
		player,
		self.breakawayAngle,
		self.breakawayVelocity,
		self.breakawayDistance,
		self.breakawayInnerAngle,
		self.shouldPlayerLookAt);
end

function nseq_gaze:AutoLock(player:player):void
	self:GoToCage(player);

	RunClientScript("GazeKit_AutoLock", player, "", ToLocation(self.components.gaze_static_marker).vector);

	CageInterface.SwitchToCageCamera(player);
	self:PlayerEnterNarrativeMode(player);
end

function nseq_gaze:QuickLookSmooth(player:player):void
	self:GoToCage(player);

	self:PlayerEnterNarrativeMode(player);
	CageInterface.SwitchToCageCamera(player);

	if self.quickLookInitialDelay > 0 then
		SleepSeconds(self.quickLookInitialDelay);
	end

		-- for each point
	local pointSet:point_set = self.components.quicklook_points;
	local pointSetSize:number = Spline_GetPointCount(pointSet);
	for i = 0, (pointSetSize - 1) do
		CageInterface.DebugPrint("Quicklook at pointset index", i);

		local pointN:point = ai_point_set_get_point(pointSet, i);

		RunClientScript(
			"GazeKit_QuickLookAtPointSmooth",
			player,
			pointN,
			i,
			self.quickLookSmoothTransitionTime,
			i >= (pointSetSize - 1));

		if self.quickLookExternalProgress == true then
			self.quickLookPointIndex = 1;
			return;
		end

		-- look for set seconds
		if self.quickLookSeconds > 0 and i < (pointSetSize - 1) then
			SleepSeconds(self.quickLookSeconds);
		end
	end

	if self.toGameplayOnFinish == true then
		self:ExitGaze(player);
	end

	if self.quickLookClearGaze == true then
		self:ClearGazePoints(player);
	end
end

function nseq_gaze:QuickLook(player:player):void
	self:GoToCage(player);

	self:PlayerEnterNarrativeMode(player);
	CageInterface.SwitchToCageCamera(player);

	if self.quickLookInitialDelay > 0 then
		SleepSeconds(self.quickLookInitialDelay);
	end

	-- for each point
	local gazeVector:vector = ToLocation(self.components.gaze_static_marker).vector;
	local pointSet:point_set = self.components.quicklook_points;
	local pointSetSize:number = Spline_GetPointCount(pointSet);

	for i = 0, (pointSetSize - 1) do
		CageInterface.DebugPrint("Quicklook at pointset index", i);

		local pointN:point = ai_point_set_get_point(pointSet, i);

		-- add point of interest, autolock, clamp gaze (or not)
		RunClientScript(
			"GazeKit_QuickLookAtPoint",
			player,
			pointN,
			i,
			self.clamped,
			self.clampedAngle,
			gazeVector);

		-- look for set seconds
		if self.quickLookSeconds > 0 then
			SleepSeconds(self.quickLookSeconds);
		end

		-- remove point of interest and unlock gaze
		RunClientScript(
			"GazeKit_QuickSwitchPoint",
			player,
			pointN,
			i);
	end

	if self.toGameplayOnFinish == true then
		self:ExitGaze(player);
	end

	if self.quickLookClearGaze == true then
		self:ClearGazePoints(player);
	end
end

function nseq_gaze:EndOnPickupStart():void
	self:ExternalStartAll();
end

function GazeKit_PickedUpObject(eventArgs:WeaponPickupEventStruct):void
	for _,kit in apairs(g_pickupCallbacks) do
		if kit.enabled == true and kit.gazeType == "pickup" or kit.gazeType == "endpickup" then
			-- Since we don't go back to gameplay, we don't need to re-activate if we drop and re-pickup an object again.
			if kit.pickupObjectTag == Object_GetDefinition(eventArgs.weapon) and kit.pickupObjectsAlreadyGrabbed:Contains(eventArgs.weapon) == false then
				kit.pickupObjectsAlreadyGrabbed:Add(eventArgs.weapon);
				kit:StartGaze(eventArgs.player);
			end

			if kit.gazeType == "endpickup" then
				kit:ExitGaze(eventArgs.player);
			end
		end
	end
end

function nseq_gaze:ObjectLock(player:player):void
	if self.lockObject == nil then
		CageInterface.DebugPrint("nseq_gaze -- No object set to gaze at --", self.components.NAME);
		return;
	end

	-- NOTE: GazeKit_ObjectLock does it's own GoToCage replacement to cage the object instead of the player
	-- NOTE: this will be more dynamic when we better understand what this mode is for
	local objectName:string = "object";
	local objectVector:vector = location(self.lockObject, "").vector;
	RunClientScript(
		"GazeKit_ObjectLock",
		player,
		self.thirdFov,
		self.lockObject,
		objectName,
		objectVector,
		self.blendTimeIn);

	CageInterface.SwitchToCageCamera(player);
	self:PlayerEnterNarrativeMode(player);
end

function nseq_gaze:SoftLock(player:player):void
	self:GoToCage(player);

	local softLockID:string = (self.components.NAME .. "_softlockpoint");
	local gazeVector:vector = ToLocation(self.components.gaze_static_marker).vector;
	RunClientScript(
		"GazeKit_SoftLock",
		player,
		softLockID,
		gazeVector,
		self.softLockStartSeconds);

	CageInterface.SwitchToCageCamera(player);
	self:PlayerEnterNarrativeMode(player);
end

-- TODO -- move to narrative base kit
-- ====================================================================================================== --
-- HELPERS
-- ====================================================================================================== --
function nseq_gaze:PlayerEnterNarrativeMode(player:player):void
	if (self.thirdPerson == true) then
		if self.playerUnitEnterNarrativeMode then
			PlayerUnitEnterNarrativeMode(player, not self.playerUnitNarrativeModeKeepWeapons, self.playerUnitNarrativeModeSpeedScale);
		elseif (self.animationMode ~= nil) and (self.animationMode ~= "") then
			CageInterface.DebugPrint("nseq_gaze -", self.components.NAME, "setting animation mode to", self.animationMode);
			unit_set_animation_mode(player, self.animationMode);
		end
	end
end

function nseq_gaze:PlayerExitNarrativeMode(player:player):void
	if (self.thirdPerson == true) then
		if self.playerUnitEnterNarrativeMode then
			PlayerUnitExitNarrativeMode(player);
		end
		if self.animationMode ~= nil or self.gazeType == "gameplay" then
			unit_set_animation_mode(player, nil);
		end
	end
end

function nseq_gaze:UseVolumes():boolean
	 -- currently ActivationVolumes will trigger even if kits are disabled, so guard with initialized
	return self.ignoreVolume == false and self.initialized == true;
end

function nseq_gaze:ClearGazePointsAll():void
	for _, player in hpairs(PLAYERS.active) do
		self:ClearGazePoints(player);
	end
end

function nseq_gaze:ClearGazePoints(player:player):void
	CageInterface.DebugPrint("Gaze Kit -- Clearing Gaze Points", self.components.NAME);

	local blendTime:number = self.blendTimeIn;
	self.blendTimeIn = 0;

	self:GoToCage(player);

	self.blendTimeIn = blendTime;
end

-- ====================================================================================================== --
-- ACTIVATION VOLUMES
-- ====================================================================================================== --
function nseq_gaze:ActivationVolumeEntered(activationVolume:activation_volume):void
	if self:UseVolumes() == false or self.enabled == false or self.completed == true or self.ignoreVolumeEnter == true then
		return;
	end

	if self.triggered == false then
		if self.gazeType == "gameplay" then
			if self.toGameplayOnEnter == true then
				self:ExternalStartAll();
			end
		else
			self:ExternalStartAll();
		end
	end

	if self.clearGazeOnEnter == true then
		self:ClearGazePointsAll();
	end

	if self.disableOnEnter == true then
		self.enabled = false;
	end
end

function nseq_gaze:ActivationVolumeExited(activationVolume:activation_volume):void
	if self:UseVolumes() == false or self.enabled == false or self.completed == true or self.ignoreVolumeExit == true then
		return;
	end

	if self.triggered == true then
		if self.gazeType == "gameplay" then
			if self.toGameplayOnExit == true then
				self:ExternalStopAll();
			end
		else
			self:ExternalStopAll();
		end
	end

	if self.clearGazeOnExit == true then
		self:ClearGazePointsAll();
	end

	if self.disableOnExit == true then
		self.enabled = false;
	end
end

function nseq_gaze.ActivationVolumePlayerEntered(self, activationVolume:activation_volume, player:player):void
	if self:UseVolumes() == false or self.enabled == false or self.completed == true or self.ignoreVolumeEnter == true then
		return;
	end

	if self.triggered == false then
		if self.gazeType == "gameplay" then
			if self.toGameplayOnEnter == true then
				self:StartGaze(player);
			end
		else
			self:StartGaze(player);
		end
	end

	if self.clearGazeOnEnter == true then
		self:ClearGazePoints(player);
	end

	if self.disableOnEnter == true then
		self.enabled = false;
	end
end

function nseq_gaze.ActivationVolumePlayerExited(self, activationVolume:activation_volume, player:player):void
	if self:UseVolumes() == false or self.enabled == false or self.completed == true or self.ignoreVolumeExit == true then
		return;
	end

	if self.triggered == true then
		if self.gazeType == "gameplay" then
			if self.toGameplayOnExit == true then
				self:ExitGaze(player);
			end
		else
			self:ExitGaze(player);
		end
	end

	if self.clearGazeOnExit == true then
		self:ClearGazePoints(player);
	end

	if self.disableOnExit == true then
		self.enabled = false;
	end
end

-- ====================================================================================================== --
-- TERMINATE
-- ====================================================================================================== --
function nseq_gaze:terminate():void
	-- shut down the sequence and clean up, or restart
	CageInterface.DebugPrint("nseq_gaze terminated -", self.components.NAME);

	if self.gazeType == "pickup" then
		g_pickupCallbacks:RemoveFirst(self);

		if g_pickupCallbacks.count == 0 then
			UnregisterGlobalEvent(g_eventTypes.weaponPickupEvent, GazeKit_PickedUpObject);
		end
	end

	-- thread clean up
	if self.quickLookThread ~= nil then
		KillThread(self.quickLookThread);
		self.quickLookThread = nil;
	end

	if self.softLockThread ~= nil then
		KillThread(self.softLockThread);
		self.softLockThread = nil;
	end

	if (self.completed == false) or (self.completed == true and self.disableOnCompletion == false) then
		self.initialized = false;
		self:init();
	end
end

--## CLIENT
-- ====================================================================================================== --
-- the client side of this kit is responsible for:
-- -- 1) client compatible cage blending using API and globals
-- -- 2) gaze mode specific functionality
-- ====================================================================================================== --

REQUIRES('globals\scripts\global_cage.lua');

-- internal namespace
global GazeKit = {};

-- ====================================================================================================== --
-- SHARED CAGE
-- ====================================================================================================== --
function remoteClient.GazeKit_SetupCage(
	player:player,
	thirdPerson:boolean,
	thirdFov:number,
	blendTimeIn:number,
	cageOrbitCenterHeight:number,
	cageOrbitOffset:vector,
	cageOrbitRotation:vector,
	preserveProperties:boolean,
	isPickup:boolean):void

	CageInterface.DebugPrint("GazeKit -- SetupCage");

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	local properties:cage_properties_provider = nil;

	if thirdPerson == true then
		if isPickup == true then
			-- Do first person provider in case the weapon we are picking up pulls us into third.
			local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
			local transform:cage_transform_provider = Cage_TransformCreateFirstPersonProvider(playerCam.playerObject);
			local properties:cage_properties_provider = Cage_PropertiesCreateCameraProvider(78); -- remove camera_fov when camera provider changes get in.
			Cage_StackBlendTo(playerCam.stack, transform, properties, 0);
		end

		if preserveProperties == true and Cage_StackGetDepth(playerCam.stack) > 0 then
			local tform:matrix = GetObjectTransform(playerCam.playerObject);

			local centerOffset:vector = vector(0, 0, cageOrbitCenterHeight);
			local pos:vector = Cage_StackGetPosition(playerCam.stack);
			local offset:vector = tform.inverse:transform(pos) - centerOffset;

			local offsetRotation:quaternion = quaternion();
			-- offsetRotation.angles = cageOrbitRotation;

			playerCam.transform = Cage_TransformCreateOrbitProvider(playerCam.playerObject, centerOffset, offset, offsetRotation);
			properties = Cage_PropertiesClone(Cage_StackGetProperties(playerCam.stack));
		else
			local offsetRotation:quaternion = quaternion();
			offsetRotation.angles = cageOrbitRotation;

			playerCam.transform = Cage_TransformCreateOrbitProvider(playerCam.playerObject, vector(0, 0, cageOrbitCenterHeight), cageOrbitOffset, offsetRotation);
			properties = Cage_PropertiesCreateCameraProvider(thirdFov);
		end

		Cage_StackBlendTo(playerCam.stack, playerCam.transform, properties, blendTimeIn);
	else
		-- figure out the actual defaults for providing to the cage properties provider.  first person poi not supported yet.
		properties = Cage_PropertiesCreateCameraProvider(78); -- note, this is hardcoded temporarily because camera_fov doesn't exist as a global variable.anymore
		playerCam.transform = Cage_TransformCreateFirstPersonProvider(playerCam.playerObject)
		Cage_StackBlendTo(playerCam.stack, playerCam.transform, properties, blendTimeIn);
	end

	Cage_TransformSetDampingSpringConstant(playerCam.transform, Cage_CalculateDampingSpringConstant(0.9, 0.15));
end

function remoteClient.GazeKit_SetupPOI(
	player:player,
	breakawayAngle:number,
	breakawayVelocity:number,
	breakawayDistance:number,
	breakawayInnerAngle:number,
	shouldPlayerLookAt:boolean):void

	CageInterface.DebugPrint("GazeKit -- SetupPOI");

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);

	if shouldPlayerLookAt == true then
		Cage_TransformSetGazeOuterAngle(playerCam.transform, breakawayAngle);
		Cage_TransformSetGazeDistance(playerCam.transform, breakawayDistance);
		Cage_TransformSetGazeVelocity(playerCam.transform, breakawayVelocity);
		Cage_TransformSetGazeInnerAngle(playerCam.transform, breakawayInnerAngle);
	else
		Cage_TransformSetGazeOuterAngle(playerCam.transform, -1);
		Cage_TransformSetGazeDistance(playerCam.transform, -1);
	end
end

-- ====================================================================================================== --
-- SPECIFIC MODES
-- ====================================================================================================== --

function remoteClient.GazeKit_AutoLock(player:player, poiName:string, gazeVector:vector):void
	GazeKit.AutoLock(player, poiName, gazeVector);
end

function GazeKit.TransitionThread(transform:cage_transform_provider, fromPoint:string_id, toPoint:string_id, transitionTime:number):void
	local weight:number = 0;

	while weight < 1 do
		Sleep(1);

		weight = weight + (Game_TimeGetDelta() / transitionTime);
		weight = math.min(1, weight);

		Cage_TransformSetGazeWeight(transform, fromPoint, 1 - weight);
		Cage_TransformSetGazeWeight(transform, toPoint, weight);
	end

	Cage_TransformRemoveGaze(transform, fromPoint);
end

function GazeKit.AutoLock(player:player, poiName:string_id, gazeVector:vector):void
	CageInterface.DebugPrint("GazeKit -- AutoLock");

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	local gazeLocation:location = ToLocation(gazeVector);
	Cage_TransformAddGaze(playerCam.transform, poiName, gazeLocation, 1);
end

function remoteClient.GazeKit_QuickLookAtPointSmooth(
	player:player,
	pointN:point,
	pointIndex:number,
	transitionTime:number,
	isFinalPoint:boolean):void

	CageInterface.DebugPrint("GazeKit -- QuickLook Smooth");

	local pointName:string_id = tostring("quicklookpoint" .. pointIndex);
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	local gazeLocation:location = ToLocation(pointN);
	local weight:number = 1;

	if pointIndex > 0 then
		local prevPointName:string_id = tostring("quicklookpoint" .. (pointIndex - 1));
		CreateThread(GazeKit.TransitionThread, playerCam.transform, prevPointName, pointName, transitionTime);

		weight = 0;
	end

	Cage_TransformAddGaze(playerCam.transform, pointName, gazeLocation, weight);
end

function remoteClient.GazeKit_QuickLookAtPoint(
	player:player,
	pointN:point,
	pointIndex:number,
	clamped:boolean,
	clampedAngle:number,
	gazeVector:vector):void

	CageInterface.DebugPrint("GazeKit -- QuickLook");

	local pointName:string_id = tostring("quicklookpoint" .. pointIndex);
	GazeKit.AutoLock(player, pointName, ToLocation(pointN).vector);

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	Cage_TransformSetGazeClamped(playerCam.transform, clamped);
end

function remoteClient.GazeKit_QuickSwitchPoint(
	player:player,
	pointN:point,
	pointIndex:number):void

	CageInterface.DebugPrint("GazeKit -- QuickSwitchPoint");

	local pointName:string_id = tostring("quicklookpoint" .. pointIndex);
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	Cage_TransformRemoveGaze(playerCam.transform, pointName);
end

function remoteClient.GazeKit_ObjectLock(
	player:player,
	thirdFov:number,
	lockObject:object,
	objectName:string,
	objectVector:vector,
	blendTimeIn:number):void

	CageInterface.DebugPrint("GazeKit -- ObjectLock");

	-- instead of GoToCage on the player, we are going to cage the given lock object
	local properties: cage_properties_provider = Cage_PropertiesCreateCameraProvider(thirdFov);
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	playerCam.transform = Cage_TransformCreateCageProvider();

	Cage_TransformSetCenterPoint(playerCam.transform, cage_point_reference(playerCam.playerObject));

	Cage_StackBlendTo(playerCam.stack, playerCam.transform, properties, blendTimeIn);

	local objectLocation:location = ToLocation(objectVector);
	Cage_TransformAddPositionPoint(playerCam.transform, objectName, objectLocation, 1);
	Cage_TransformAddGaze(playerCam.transform, objectName, objectLocation, 1);

	-- NOTE: magic numbers for now while we gather requirements for framing
	Cage_TransformSetPositionPointOffset(playerCam.transform, objectName, vector(2, 0, 1));
	Cage_TransformSetGazeOffset(playerCam.transform, objectName, vector(0, 0, 0.5));
end

function remoteClient.GazeKit_SoftLock(
	player:player,
	softLockID:string,
	gazeVector:vector,
	startSeconds:number):void

	CageInterface.DebugPrint("GazeKit -- SoftLock");

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	local gazeLocation:location = ToLocation(gazeVector);
	Cage_TransformAddGaze(playerCam.transform, softLockID, gazeLocation, 1);
end
