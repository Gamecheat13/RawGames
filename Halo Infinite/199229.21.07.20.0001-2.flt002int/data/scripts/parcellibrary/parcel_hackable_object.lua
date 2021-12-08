-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('scripts\ParcelLibrary\parcel_area_monitor.lua');

--[[												
 _    _            _         _     _         ____  _     _           _   
 | |  | |          | |       | |   | |       / __ \| |   (_)         | |  
 | |__| | __ _  ___| | ____ _| |__ | | ___  | |  | | |__  _  ___  ___| |_ 
 |  __  |/ _` |/ __| |/ / _` | '_ \| |/ _ \ | |  | | '_ \| |/ _ \/ __| __|
 | |  | | (_| | (__|   < (_| | |_) | |  __/ | |__| | |_) | |  __/ (__| |_ 
 |_|  |_|\__,_|\___|_|\_\__,_|_.__/|_|\___|  \____/|_.__/| |\___|\___|\__|
                                                        _/ |              
                                                       |__/                                               
--]] 

global HackableObject:table = Parcel.MakeParcel
{
	--Parcel Variables
	--Place all the variables your parcel needs here.

	--//////
	-- Parcel
	--//////
	--Whether the parcel is ready to start.  Used by the parcel manager
	canStart = false,  				
	--Whether the parcel has had it's completion requirements met.  The parcel ends when this is true
	complete = false,
	--Ideally each instance of this parcel would have a unique name.  Set via the New() function
	instanceName = "HackableObject",

	hackableObject = nil,
	storedPlayer = nil,
	initialTeam = nil,
	storedDesignator = nil,

	areaMonitorParcel = nil,
	areaMonitor = nil,

	hackableObjectBoundary = nil,
	hackableBoundaryType = nil,
	originalBoundarySize = 0,
	originalBoundaryHeight = 0,

	hackInProgress = false,
	hackingTimer = 0,
	hackingNormalizedProgress = 0,
	brokenConnection = false,

	onCooldown = false,
	cooldownTimer = nil,
	
	togglePower = false,
	toggleControl = false,

	hackDesignatorInteractionFilter = nil,
	hackPlayerInteractionFilter = nil,

	ownershipStateGroup = nil,
	progressStateGroup = nil,
	textStateGroup = nil,
	timerStateGroup = nil,
	iconStateGroup = nil,
	friendlyFiltersByStateGroup = {},
	enemyFiltersByStateGroup = {},


	CONFIG = 
	{
		--CONFIG variables are for variables you want to edit for variants and use in New.

		--//////
		--// Parcel
		--//////
		--use for sleep	
		updateDeltaSeconds = 0.1,
		--A debug variable used to enable/disable debug prints in the parcel.
		enableDebugPrint = false, 

		--How much time the interact hold time with the device control is.
		interactTime = 1,
		
		--How much time it takes for the AI to hack something once it is on the hacking object,
		hackingTimeDuration = 10,
		decayRate = 1,

		initialTeamAffiliation = MP_TEAM_DESIGNATOR.Neutral,
		initialTeamCanInteract = false,

		-- Initial Power State of 
		powerState = 1,

		-- Personal AI Tether Properties
		tetherDistance = -1,					-- This is set from the object script. If it is never modified by the object the script is attached to, no tethering will ever occur.
		tetherPercentageCheck = 0.6,
	
		--Should there be a cooldown between uses
		useCooldown = false,
		cooldownTimeInSeconds = 30,

		--Should a successful hack only trigger once?
		triggerOnce = false,

		--Interact String Overrides
		overrideInteractString = false,
		newInteractString = "forwardbase_hack",
		newSecondaryString = "hackzone_disable",

		chosenInteractType = 1,

		initialNavpointOn = false,

		--CHANNELS
		alwaysPower = false,
		powerChannel = "",
		controlChannel = "",
		incomingPowerChannel = "",

		navpointParamCooldown = "navpoint_olympus_cooldown",
		navpointParam = "mp_control_area",

		neutral = "generic_hack",
		friendly = "generic_protect",
		hostile = "generic_hack",
		cooldown = "generic_reboot ",

		NeutralColor = color_rgba(0.8, 0.8, 0.8, 1.0),

	},
	
	CONST = 
	{
		--Marker to parent Navpoint
		navMarker = "nav_mkr",

		--Enum to set functionality
		InteractionTypeEnum = table.makeEnum
		{
			switch = 1,
			hold = 2,
		},

		-- State Group names
		ownershipStateGroupName = "ownership_state",
		progressStateGroupName = "has_progress",
		textStateGroupName = "has_text",
		iconStateGroupName = "control_point",
		timerStateGroupName = "timer",

		--
		-- State names
		--

		-- Ownership states
		ownershipStateDefault = "neutral",
		ownershipStateFriendly = "friendly",
		ownershipStateEnemy = "enemy",

		-- Text states
		textStateNone = "none",
		textStateDisrupt = "disrupt",
		textStateGuard = "guard",
		textStateCooldown = "cooldown",

		-- Progress states
		progressStateDefault = "none",
		progressStateFriendly = "friendly",
		progressStateEnemy = "enemy",

		-- Icon states
		iconStateDefault = "hacking",

		-- Timer States
		timerStateDefault = "off",
		timerStateOn = "on",

		-- Sounds
		hackableObjectHackingLoop = nil,
		hackableObjectResettingLoop = nil,
	},

	EVENTS =
	{
		onInteractStart = "OnInteractStart",		
		onInteractComplete = "OnInteractComplete",
		onInteractReleased = "OnInteractReleased",
		onHackingBegin = "OnHackingBegin",
		onHackingComplete = "OnHackingComplete",
		onHackingCancelled = "OnHackingCancelled",
		onNavpointsCreated = "OnNavpointsCreated",
	},
};

function HackableObject:New(initArgs:HackableObjectInitArgs):table
	local newHackableObject = self:CreateParcelInstance();

	newHackableObject.instanceName = initArgs.instanceName;
	newHackableObject.hackableObject = initArgs.hackableObject;
	newHackableObject.navpointParamNeutral = initArgs.navpointParam;
	newHackableObject.CONFIG.chosenInteractType = initArgs.interactType;
	newHackableObject.CONFIG.overrideInteractString = initArgs.overrideInteractString;
	newHackableObject.CONFIG.newInteractString = initArgs.interactString;
	newHackableObject.CONFIG.newSecondaryString = initArgs.secondaryString;
	newHackableObject.initialTeam = initArgs.initialTeam;

	
	return newHackableObject;
end

function HackableObject:Initialize():void
	-- Everyone passes a team filter of Neutral; we can negate the filter later to disallow anyone from interacting
	self.hackDesignatorInteractionFilter = Object_Filter_CreateTeamDesignatorFilter(self.hackableObject);
	Object_Filter_SetTeamDesignator(self.hackableObject, self.hackDesignatorInteractionFilter, self.CONFIG.initialTeamAffiliation);
	
	--Player Filter will turn on and off for individual players
	self.hackPlayerInteractionFilter = Object_Filter_CreatePlayerMaskFilter(self.hackableObject);

	-- Both Team Designator and Player Filters need to pass.
	Object_Filter_SetType(self.hackableObject, FILTER_TYPE.PassesAll); 

	-- Override Interaction Strings
	if self.CONFIG.overrideInteractString then
		Device_SetPrimaryActionStringOverride(self.hackableObject, self.CONFIG.newInteractString);
		Device_SetSecondaryActionStringOverride(self.hackableObject, self.CONFIG.newSecondaryString);
	end

	--Set Initial Owning Team for attack/defend
	if self.initialTeam ~= nil and not self.CONFIG.initialTeamCanInteract then
		self.CONFIG.initialTeamAffiliation = Team_GetTeamDesignator(self.initialTeam);
		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, false);
	else
	-- Neutral or owning team can interact
		self.storedDesignator = self.CONFIG.initialTeamAffiliation;
		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, false);
	end

	self.hackableObjectBoundary = Object_GetBoundary(self.hackableObject);
	self.hackableBoundaryType = Boundary_GetType(self.hackableObjectBoundary);
	self.originalBoundarySize = self.hackableObjectBoundary.widthOrRadius;
	self.originalBoundaryHeight = self.hackableObjectBoundary.positiveHeight;
end

function HackableObject:InitializeImmediate():void
    self.CONST.hackableObjectHackingLoop = GameModeTagReferences.Universal.HackableObjectHackingLoop;
    self.CONST.hackableObjectResettingLoop = GameModeTagReferences.Universal.HackableObjectResettingLoop;
end

function HackableObject:Run():void
	self:CreateNavpoints();
	--Run is used once the Parcel is officially kicked off.
	--sleep until players are valid
	self:SleepUntilValid();

	-- Register for Message Event to enable disable power on the hackable object.
	if self.CONFIG.incomingPowerChannel ~= "" then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectPowerUpdated, self.PowerMessageReceived, self.CONFIG.incomingPowerChannel);
	end

	self:RegisterEventOnSelf(g_eventTypes.deviceInteractionStartedEvent, self.BeginInteract, self.hackableObject);
	self:RegisterEventOnSelf(g_eventTypes.deviceInteractionFinishedEvent, self.InteractCompleted, self.hackableObject);

	device_set_power(self.hackableObject, self.CONFIG.powerState);
	PersonalAI_SetTetherDistanceLimit(self.CONFIG.tetherDistance);

	--Set initial value for hacking routine
	if self.CONFIG.chosenInteractType == self.CONST.InteractionTypeEnum.switch then
		self.hackingTimer = 0;
		self:SetRadialBarProgress(0);
		self.hackingNormalizedProgress = 0;
	end

	if self.CONFIG.initialNavpointOn then 
		Navpoint_SetEnabled(self.navpoint, true);
	else
		Navpoint_SetEnabled(self.navpoint, false);
	end

	if self.CONFIG.powerChannel == "" then
		self.togglePower = true;
	end

	-- Set Up Area Monitor
	self.areaMonitor = AreaMonitor:New(self.instanceName .. "AreaMonitor", AreaVolume:NewMultiplayerBoundaryByObject(self.hackableObject),
						AreaMonitor.MonitorTypeEnum.OnFootAndInVehicleParticipants);

	self.areaMonitor:AddOnObjectEnter(self, self.HandleUnitEnteredHackRadius);
	self.areaMonitor:AddOnObjectExit(self, self.HandleUnitExitedHackRadius);	

	self:StartChildParcel(self.areaMonitor, self.areaMonitor.instanceName);
end

function HackableObject:SleepUntilValid():void
	--Used to wait for all players to be loaded in the game.
	SleepUntil ([| player_valid_count() > 0 ], 1);
end

function HackableObject:IsComplete():boolean
	--Check to see if the parcel is complete.
	return self:shouldEnd();
end

function HackableObject:shouldEnd():boolean
	--Check to see what complete is set to.
	return self.complete;
end

function HackableObject:EndShutdown():void

	device_set_power(self.hackableObject, 0);

	Object_Filter_RemoveAllFilters(self.hackableObject);

	Navpoint_Delete(self.navpoint);
	self.storedPlayer = nil;
end

--
--	PARCEL LOGIC
--

function HackableObject:SetTeamInteractionNegate(owningTeamDesignator:mp_team_designator, negate:boolean):void
	Object_Filter_SetTeamDesignator(self.hackableObject, self.hackDesignatorInteractionFilter, owningTeamDesignator);
	Object_Filter_SetNegate(self.hackableObject, self.hackDesignatorInteractionFilter, negate);
end

--Area Monitor LOGIC
function HackableObject:HandleUnitEnteredHackRadius(eventArgs:AreaMonitorObjectEnteredEventArgs):void
	local enteringPlayer:player = eventArgs.unitPlayer;

	-- Check to see if the player has an AI onhand to use for hacking.
	if not PersonalAI_IsDeployed(enteringPlayer) then
		if self.onCooldown == false and enteringPlayer ~= nil then
			Object_Filter_SetPlayer(self.hackableObject, self.hackPlayerInteractionFilter, enteringPlayer, true);
		end
	elseif PersonalAI_IsDeployed(enteringPlayer) and enteringPlayer ~= self.storedPlayer then
		MPLuaCall("__OnHackingInProgress", enteringPlayer);
	end
end

function HackableObject:HandleUnitExitedHackRadius(eventArgs:AreaMonitorObjectExitedEventArgs):void
	local exitingPlayer:player = eventArgs.unitPlayer or eventArgs.unitLastPlayer;
	if (exitingPlayer ~= nil) then
		Object_Filter_SetPlayer(self.hackableObject, self.hackPlayerInteractionFilter, exitingPlayer, false);
	end
end

--Device Control Logic

function HackableObject:BeginInteract(eventArgs:DeviceInteractionStartedEventStruct):void
	self:RegisterEventOnSelf(g_eventTypes.deviceInteractionReleasedEvent, self.InteractReleased, self.hackableObject);

	-- Animate Object Effects
	self:AnimateEffects(0);

	local player:player = eventArgs.interactingPlayer;
	if self.hackInProgress == false then
		if (PersonalAI_TryAndPlaceAtObject(player, self.hackableObject)) then
			PersonalAI_SetScale(player, 0.75);
			PersonalAI_PlayAnimation(player, PERSONAL_AI_ANIMATION_TYPE.Idle);
		end
	else
		PersonalAI_PlayAnimation(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.EmotePanic);
	end

	self:TriggerEvent(self.EVENTS.onInteractStart, eventArgs.interactingPlayer, self.hackableObject);
end

function HackableObject:InteractCompleted(eventArgs:DeviceInteractionFinishedEventStruct):void
	local playerTeam:mp_team = Player_GetMultiplayerTeam(eventArgs.interactingPlayer)
	self.storedDesignator =  Player_GetTeamDesignator(eventArgs.interactingPlayer);

	-- Animate Object Effects
	self:AnimateEffects(1);

	self:UnregisterEventOnSelf(g_eventTypes.deviceInteractionReleasedEvent, self.InteractReleased, self.hackableObject);
	
	-- Begin Hacking Process if a Hack isn't in Progress
	if self.hackInProgress == false then
		self.storedPlayer = eventArgs.interactingPlayer;
		Object_Filter_SetPlayer(self.hackableObject, self.hackPlayerInteractionFilter, eventArgs.interactingPlayer, false);
		device_control_set_use_secondary_strings(self.hackableObject, true);

		self:SetFriendlyFilterTeam(self.ownershipStateGroup, playerTeam);
		self:SetFriendlyFilterTeam(self.progressStateGroup, playerTeam);
		self:SetFriendlyFilterTeam(self.textStateGroup, playerTeam);

		if Navpoint_GetEnabled(self.navpoint) == false then
			Navpoint_SetEnabled(self.navpoint, true);
		end

		if self.CONFIG.initialTeamCanInteract and self.initialTeam then
			if self.storedDesignator == self.CONFIG.initialTeamAffiliation then
				--We want the owning team to just interact and have the result happen.
				self:AIHackComplete();
			end
		else
			self:SetTeamInteractionNegate(self.storedDesignator, true);
		
			self:BeginAIHack();
		end

	-- IF a Hack is Already in Progress, interact results in interrupting the hack.
	else
		PersonalAI_Despawn(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.DespawnSad);

		--Hack is Interrupted self:AIHackInterrupted();
		self.hackInProgress = false;

		if self.CONFIG.chosenInteractType == self.CONST.InteractionTypeEnum.hold then
			self:AIHackInterrupted();
		end

	end

	self:TriggerEvent(self.EVENTS.onInteractComplete, eventArgs.interactingPlayer, self.hackInProgress);
end

function HackableObject:InteractReleased(eventArgs):void
	self:AnimateEffects(1);

	self:TriggerEvent(self.EVENTS.onInteractReleased, eventArgs.interactingPlayer);

	if self.hackInProgress then
		PersonalAI_PlayAnimationList(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.EmoteCelebration, PERSONAL_AI_ANIMATION_TYPE.HackingLoop);
	else
		PersonalAI_Despawn( eventArgs.interactingPlayer, PERSONAL_AI_ANIMATION_TYPE.Despawn);
	end

	self:UnregisterEventOnSelf(g_eventTypes.deviceInteractionReleasedEvent, self.InteractReleased, self.hackableObject);
end

-- AI Hacking LOGIC
function HackableObject:BeginAIHack():void
	self.hackInProgress = true;
	
	if PersonalAI_IsTetheringEnabled() then
		local diameter:number = self.CONFIG.tetherDistance * 2;

		self:SetNewBoundary(diameter, self.originalBoundaryHeight, true);
		self:CreateThread(self.CheckTetherDistance);
		self:RegisterEventOnSelf(g_eventTypes.personalAIRecalled, self.AITetherBroken, self.storedPlayer);
	end

	if self.CONFIG.chosenInteractType == self.CONST.InteractionTypeEnum.switch then
		self:CreateThread(self.HackingRoutine);
	elseif self.CONFIG.chosenInteractType == self.CONST.InteractionTypeEnum.hold then
		--Placeholder for now. Deciding if we will add this functionality back in
	end

	PersonalAI_PlayAnimationList(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.HackingEnter, PERSONAL_AI_ANIMATION_TYPE.HackingLoop);
	Object_StopLoopingSounds(self.hackableObject);
	MPLuaCall("__OnHackingStart", self.storedPlayer, self.hackableObject);
	Object_SetEnemyLoopingSound(self.hackableObject, self.CONST.hackableObjectHackingLoop);
	Object_SetFriendlyLoopingSound(self.hackableObject, self.CONST.hackableObjectHackingLoop);
	
	local storedPlayerUnit:object = Player_GetUnit(self.storedPlayer);
	if (storedPlayerUnit ~= nil) then
		self:RegisterEventOnSelf(g_eventTypes.deathEvent, self.DeployedPlayerDeathEvent, storedPlayerUnit);
	end

	self:TriggerEvent(self.EVENTS.onHackingBegin, self.storedPlayer);
end

function HackableObject:AIHackComplete():void
	device_control_set_use_secondary_strings(self.hackableObject, false);

	if PersonalAI_IsTetheringEnabled() then
		self:SetNewBoundary(self.originalBoundarySize, self.originalBoundaryHeight, false);
	end

	self.hackInProgress = false;
	self.brokenConnection = false;

	--Trigger Events
	self:TriggerEvent(self.EVENTS.onHackingComplete, self.storedPlayer, self);

	--Send Broadcast Message
	if self.CONFIG.powerChannel ~= "" then
		if self.togglePower and not self.CONFIG.alwaysPower then
			self.togglePower = false;
		else
			self.togglePower = true;
		end
		self:TriggerPowerEvent(self.CONFIG.powerChannel, self.togglePower);
	end

	--Send Broadcast Message
	if self.CONFIG.controlChannel ~= "" and self.togglePower == true then
		if self.toggleControl then
			self.toggleControl = false;
		else
			self.toggleControl = true;
		end
		self:TriggerControlEvent(self.CONFIG.controlChannel, self.toggleControl);
	end

	if self.initialTeam and not self.CONFIG.initialTeamCanInteract then
		-- Set back to initial attack/defend style terminal.
		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, true);
	else
		-- Set back to initial neutral interaction terminal.
		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, false);
	end

	MPLuaCall("__OnHackingComplete", self.storedPlayer, self.hackableObject);
	Object_StopLoopingSounds(self.hackableObject);

	self.storedDesignator = self.CONFIG.initialTeamAffiliation;

	self:SetFriendlyFilterTeam(self.progressStateGroup, nil);
	self:SetFriendlyFilterTeam(self.ownershipStateGroup, nil);

	local hackingUnit:object = Player_GetUnit(self.storedPlayer);

	PersonalAI_PlayAnimationList(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.HackingSuccess, PERSONAL_AI_ANIMATION_TYPE.Despawn);

	if self.storedPlayer ~= nil then
		if (hackingUnit ~= nil) then
			self:UnregisterEventOnSelf(g_eventTypes.deathEvent, self.DeployedPlayerDeathEvent, hackingUnit);
		end

		self.storedPlayer = nil;
	end

	if self.CONFIG.triggerOnce then
		device_set_power(self.hackableObject, 0);
		Navpoint_SetEnabled(self.navpoint, false);

		self:AnimateEffects(0);
	elseif self.CONFIG.useCooldown then
		self:CreateThread(self.CooldownRoutine);
		
		self:AnimateEffects(0);
	else
		if self.CONFIG.initialNavpointOn then 
			Navpoint_SetEnabled(self.navpoint, true);
		else
			Navpoint_SetEnabled(self.navpoint, false);
		end
	end
end

function HackableObject:AIHackInterrupted(deadHackingPlayerUnit:object):void
	self.hackInProgress = false;
	device_control_set_use_secondary_strings(self.hackableObject, false);

	if PersonalAI_IsTetheringEnabled() then
		self:SetNewBoundary(self.originalBoundarySize, self.originalBoundaryHeight, false);
	end

	if self.initialTeam and not self.CONFIG.initialTeamCanInteract  then
		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, true);
	else
		self:SetFriendlyFilterTeam(self.ownershipStateGroup, nil);
		self:SetFriendlyFilterTeam(self.textStateGroup, nil);

		self:SetTeamInteractionNegate(self.CONFIG.initialTeamAffiliation, false);
	end

	self.storedDesignator = self.CONFIG.initialTeamAffiliation;

	self:TriggerEvent(self.EVENTS.onHackingCancelled, self.storedPlayer);

	if self.brokenConnection then 
		MPLuaCall("__OnHackConnectionLost", self.storedPlayer, self.hackableObject);
	else
		MPLuaCall("__OnHackingInterrupted", self.storedPlayer, self.hackableObject);
	end
	Object_StopLoopingSounds(self.hackableObject);

	-- Use the overriding unit passed in if non-nil
	local hackingUnit:object = deadHackingPlayerUnit or Player_GetUnit(self.storedPlayer);

	PersonalAI_PlayAnimationList(self.storedPlayer, PERSONAL_AI_ANIMATION_TYPE.HackingFailure, PERSONAL_AI_ANIMATION_TYPE.Despawn);

	if (hackingUnit ~= nil) then
		self:UnregisterEventOnSelf(g_eventTypes.deathEvent, self.DeployedPlayerDeathEvent, hackingUnit);
	end

	self.brokenConnection = false;
	self.storedPlayer = nil;
end

function HackableObject:DeployedPlayerDeathEvent(eventStruct:DeathEventStruct):void
	self:AIHackInterrupted(eventStruct.deadObject);
end

function HackableObject:AnimateEffects(objectState:number):void
	--Animate Effect on Control
	object_set_function_variable(self.hackableObject, "isenabled", objectState, 0.2);
	object_set_function_variable(self.hackableObject, "isactive_ban_hacking_terminal", objectState, 0.2);
end

function HackableObject:CheckTetherDistance():void
	local firedNearingTetherDistance = false;

	repeat
		--Check if player is nearing the tether length of an AI hack. Boolean makes sure it doesn't constantly fire VO call if outside this range.
		if ((PersonalAI_GetCurrentTetherDistance(self.storedPlayer)/self.CONFIG.tetherDistance) >= self.CONFIG.tetherPercentageCheck) then
			if firedNearingTetherDistance == false then
				firedNearingTetherDistance = true;
				MPLuaCall("__OnLeavingHackzone", self.storedPlayer, self.hackableObject);
			end
		else
			firedNearingTetherDistance = false;
		end
	SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self.hackInProgress == false;
end

function HackableObject:AITetherBroken(eventStruct:PersonalAIRecalledEventStruct):void
	if eventStruct.reason == PERSONAL_AI_RECALL_REASON.BrokenTether then
		self.brokenConnection = true;
		self.hackInProgress = false;
	end
end

function HackableObject:SetNewBoundary(radius:number, height:number, visible:boolean):void
	local newBoundary:mp_object_boundary = CreateNewBoundary(self.hackableBoundaryType, radius, height);
	Object_SetBoundary(self.hackableObject, newBoundary);

	local mpTeam:mp_team = Player_GetMultiplayerTeam(self.storedPlayer);

	local teamColor:color_rgba = UI_GetBitmapColorForTeam(self.storedPlayer, mpTeam);

	Object_SetBoundaryColorForPlayer(self.hackableObject, self.storedPlayer, teamColor);

	Object_SetBoundaryVisibility(self.hackableObject, self.storedPlayer, visible);
end
-- NAVPOINTS

function HackableObject:CreateNavpoints()
	-- Create and start timer we will pass to the navpoint
	self.cooldownTimer = Engine_CreateTimer();

	self.navpoint = Navpoint_Create(self.CONFIG.navpointParam);
	self.navpointDockingFilter = Navpoint_DockingFilter_CreatePlayerMaskFilter(self.navpoint);
	Navpoint_SetBarDrawMode(self.navpoint, NAVPOINT_BAR.Radial, NAVPOINT_DRAW.Always);
	Navpoint_SetObjectParent(self.navpoint, self.hackableObject);
	Navpoint_SetObjectMarker(self.navpoint, self.CONST.navMarker);
	Navpoint_SetCanBeOccluded(self.navpoint, true);
	Navpoint_SetVisibleOffscreen(self.navpoint, false);
	Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.navpoint, true);

	local visualStateFilter:visual_state_filter = nil;

	--|[ Ownership State Group ]|--
	-------------------------------
	self.ownershipStateGroup = Navpoint_VisualStates_CreateState(self.navpoint);
	Navpoint_VisualStates_SetStateGroupName(self.navpoint, self.ownershipStateGroup, self.CONST.ownershipStateGroupName);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.ownershipStateGroup, self.CONST.ownershipStateDefault);
	
	-- friendly filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.ownershipStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.ownershipStateGroup, visualStateFilter, self.CONST.ownershipStateFriendly);
	Navpoint_VisualStateFilter_SetTeamDesignatorToNone(self.navpoint, self.ownershipStateGroup, visualStateFilter);
	self.friendlyFiltersByStateGroup[self.ownershipStateGroup] = visualStateFilter;

	-- enemy filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.ownershipStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.ownershipStateGroup, visualStateFilter, self.CONST.ownershipStateEnemy);
	Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, self.ownershipStateGroup, visualStateFilter, MP_TEAM_DESIGNATOR.Neutral);
	Navpoint_VisualStateFilter_SetNegate(self.navpoint, self.ownershipStateGroup, visualStateFilter, true);
	self.enemyFiltersByStateGroup[self.ownershipStateGroup] = visualStateFilter;

	-- |[ Text State Group ]| --
	----------------------------
	self.textStateGroup = Navpoint_VisualStates_CreateState(self.navpoint);
	Navpoint_VisualStates_SetStateGroupName(self.navpoint, self.textStateGroup, self.CONST.textStateGroupName);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.textStateGroup, self.CONST.textStateNone);
	
	-- friendly filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.textStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.textStateGroup, visualStateFilter, self.CONST.textStateGuard);
	Navpoint_VisualStateFilter_SetTeamDesignatorToNone(self.navpoint, self.textStateGroup, visualStateFilter);
	self.friendlyFiltersByStateGroup[self.textStateGroup] = visualStateFilter;

	-- enemy filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.textStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.textStateGroup, visualStateFilter, self.CONST.textStateDisrupt);
	Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, self.textStateGroup, visualStateFilter, MP_TEAM_DESIGNATOR.Neutral);
	Navpoint_VisualStateFilter_SetNegate(self.navpoint, self.textStateGroup, visualStateFilter, true);
	self.enemyFiltersByStateGroup[self.textStateGroup] = visualStateFilter;

	-- |[ Progress State Group ]| --
	-------------------------------
	self.progressStateGroup = Navpoint_VisualStates_CreateState(self.navpoint);
	Navpoint_VisualStates_SetStateGroupName(self.navpoint, self.progressStateGroup, self.CONST.progressStateGroupName);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.progressStateGroup, self.CONST.progressStateDefault);

	-- friendly filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.progressStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.progressStateGroup, visualStateFilter, self.CONST.progressStateFriendly);
	Navpoint_VisualStateFilter_SetTeamDesignatorToNone(self.navpoint, self.progressStateGroup, visualStateFilter);
	self.friendlyFiltersByStateGroup[self.progressStateGroup] = visualStateFilter;

	-- enemy filter
	visualStateFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(self.navpoint, self.progressStateGroup);
	Navpoint_VisualStateFilter_SetStateFilteredName(self.navpoint, self.progressStateGroup, visualStateFilter, self.CONST.progressStateEnemy);
	Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, self.progressStateGroup, visualStateFilter, MP_TEAM_DESIGNATOR.Neutral);
	Navpoint_VisualStateFilter_SetNegate(self.navpoint, self.progressStateGroup, visualStateFilter, true);
	self.enemyFiltersByStateGroup[self.progressStateGroup] = visualStateFilter;

		-- |[ Icon State Group ]| --
	-----------------------------
	self.iconStateGroup = Navpoint_VisualStates_CreateState(self.navpoint);
	Navpoint_VisualStates_SetStateGroupName(self.navpoint, self.iconStateGroup, self.CONST.iconStateGroupName);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.iconStateGroup, self.CONST.iconStateDefault);

	
	-- |[ Timer State Group ]| --
	-------------------------------
	self.timerStateGroup = Navpoint_VisualStates_CreateState(self.navpoint);
	Navpoint_VisualStates_SetStateGroupName(self.navpoint, self.timerStateGroup, self.CONST.timerStateGroupName);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.timerStateGroup, self.CONST.timerStateDefault);

	self:TriggerEvent(self.EVENTS.onNavpointsCreated, self);
end

-- -- Temporary shim until Navpoint_VisualStateFilter_SetTeamDesignatorToNone makes it into a green build
-- function HackableObject:Navpoint_VisualStateFilter_SetTeamDesignatorToNone_TEMP(arg1, arg2, arg3)
-- 	local setNoneFunc:cfunction = _G["Navpoint_VisualStateFilter_SetTeamDesignatorToNone"];
-- 	if (setNoneFunc ~= nil) then
-- 		setNoneFunc(arg1, arg2, arg3);
-- 	else
-- 		Navpoint_VisualStateFilter_SetTeamDesignator(arg1, arg2, arg3, MP_TEAM_DESIGNATOR.Eighth);
-- 	end
-- end


function HackableObject:SetFriendlyFilterTeam(stateGroup:visual_state_group, friendlyTeam:mp_team):void
	if (stateGroup == nil) then
		return;
	end

	local friendlyFilter:visual_state_filter = self.friendlyFiltersByStateGroup[stateGroup];
	local enemyFilter:visual_state_filter = self.enemyFiltersByStateGroup[stateGroup];

	if (friendlyTeam ~= nil) then
		local friendlyTeamDesignator:mp_team_designator = Team_GetTeamDesignator(friendlyTeam);
		if (friendlyFilter ~= nil) then
			Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, stateGroup, friendlyFilter, friendlyTeamDesignator);
		end

		if (enemyFilter ~= nil) then
			Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, stateGroup, enemyFilter, friendlyTeamDesignator);
		end
	-- If the friendlyTeam is nil then we are in a Neutral state, which means we want all players to fail both the friendly and enemy filters
	else
		if (friendlyFilter ~= nil) then
			Navpoint_VisualStateFilter_SetTeamDesignatorToNone(self.navpoint, stateGroup, friendlyFilter);
		end

		if (enemyFilter ~= nil) then
			-- Since the enemy filters are negated, we set the designator to Neutral so that "everyone passes" becomes "nobody passes"
			Navpoint_VisualStateFilter_SetTeamDesignator(self.navpoint, stateGroup, enemyFilter, MP_TEAM_DESIGNATOR.Neutral);
		end
	end
end

function HackableObject:GetNormalizedHackingProgressForTeam(team:mp_team):number
	if (self.storedPlayer == nil) then
		return 0;
	end

	local hackingTeam:mp_team = Player_GetMultiplayerTeam(self.storedPlayer);
	if (team == hackingTeam) then
		return self.hackingNormalizedProgress;
	end

	return 0;
end

--ROUTINES

function HackableObject:HackingRoutine():void
	if self.hackingTimer == self.CONFIG.hackingTimeDuration then
		self.hackingTimer = 0;
		self:SetRadialBarProgress(0);
		self.hackingNormalizedProgress = 0;
	end

	local hackSuccessful = false;
	repeat
		self.hackingTimer = math.min(self.hackingTimer + self.CONFIG.updateDeltaSeconds, self.CONFIG.hackingTimeDuration);
		self.hackingNormalizedProgress = self.hackingTimer / self.CONFIG.hackingTimeDuration;
		self:SetRadialBarProgress(self.hackingNormalizedProgress);
		
		if self.hackingTimer >= self.CONFIG.hackingTimeDuration then
			hackSuccessful = true;
		end

		SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self.hackInProgress == false or hackSuccessful;

	if hackSuccessful then
		self:AIHackComplete();
	else
		self:CreateThread(self.DecayRoutine);
		self:AIHackInterrupted();
	end
end

function HackableObject:DecayRoutine():void
	Object_SetEnemyLoopingSound(self.hackableObject, self.CONST.hackableObjectResettingLoop);
	Object_SetFriendlyLoopingSound(self.hackableObject, self.CONST.hackableObjectResettingLoop);

	repeat
		self.hackingTimer = math.max(self.hackingTimer - (self.CONFIG.updateDeltaSeconds * self.CONFIG.decayRate), 0);
		self.hackingNormalizedProgress = self.hackingTimer / self.CONFIG.hackingTimeDuration;
		self:SetRadialBarProgress(self.hackingNormalizedProgress);

		SleepSeconds(self.CONFIG.updateDeltaSeconds);
	until self.hackingTimer == 0 or self.hackInProgress == true;

	if self.CONFIG.initialNavpointOn then 
		Navpoint_SetEnabled(self.navpoint, true);
	elseif self.hackInProgress == false then
		Navpoint_SetEnabled(self.navpoint, false);
	end

	-- Make sure we 0 out the data for the navpoint
	if self.hackingTimer == 0 then
		self:SetRadialBarProgress(0);
		self.hackingNormalizedProgress = 0;
		Object_StopLoopingSounds(self.hackableObject);
	end
	
	MPLuaCall("__OnHackReset", self.hackableObject);
end

function HackableObject:CooldownRoutine():void
	self.onCooldown = true;

	self:SetFriendlyFilterTeam(self.textStateGroup, nil);
	self:SetFriendlyFilterTeam(self.ownershipStateGroup, nil);

	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.timerStateGroup, self.CONST.timerStateOn);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.textStateGroup, self.CONST.textStateCooldown);
	
	Timer_SetSecondsLeft(self.cooldownTimer, self.CONFIG.cooldownTimeInSeconds);
	Timer_StartWithRate(self.cooldownTimer, 1);
	Navpoint_SetTimer(self.navpoint, TIMER_SLOT.Primary, self.cooldownTimer);

	repeat
		sleep_s(self.CONFIG.updateDeltaSeconds);
	until Timer_IsExpired(self.cooldownTimer);

	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.timerStateGroup, self.CONST.timerStateDefault);
	Navpoint_VisualStates_SetStateUnfilteredName(self.navpoint, self.textStateGroup, self.CONST.textStateNone);

	if not self.CONFIG.initialNavpointOn then 
		Navpoint_SetEnabled(self.navpoint, false);
	end

	-- NOTE: in the future we will need to add handling for players that are currently in the zone when the cooldown expires; 
	--as-is those players will not get messaging that the hack is now available unless the leave and re-enter the hackzone
	self.onCooldown = false;

	self:AnimateEffects(1);
end

function HackableObject:SetRadialBarProgress(progressPercentage:number):void
	Navpoint_SetBarProgress(self.navpoint, NAVPOINT_BAR.Radial, progressPercentage);
end

--
-- Object Message System
--
function HackableObject:PowerMessageReceived(eventStruct:CommunicationObjectPowerUpdateEventStruct):void
	if eventStruct.isPowered then
		self.CONFIG.powerState = 1;
	else
		self.CONFIG.powerState = 0;
	end
end

--
-- Event Interface
--

--OnInteractStart
function HackableObject:AddOnInteractStart(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onInteractStart, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnInteractStart(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onInteractStart, callbackFunc, callbackOwner);
end

--OnInteractComplete
function HackableObject:AddOnInteractComplete(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onInteractComplete, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnInteractComplete(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onInteractComplete, callbackFunc, callbackOwner);
end

--OnInteractReleased
function HackableObject:AddOnInteractReleased(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onInteractReleased, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnInteractReleased(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onInteractReleased, callbackFunc, callbackOwner);
end

--OnHackingBegin
function HackableObject:AddOnHackingBegin(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onHackingBegin, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnHackingBegin(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onHackingBegin, callbackFunc, callbackOwner);
end

--OnHackingComplete
function HackableObject:AddOnHackingComplete(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onHackingComplete, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnHackingComplete(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onHackingComplete, callbackFunc, callbackOwner);
end

--OnHackingCancelled
function HackableObject:AddOnHackingCancelled(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onHackingCancelled, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnHackingCancelled(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onHackingCancelled, callbackFunc, callbackOwner);
end

--OnNavpointsCreated
function HackableObject:AddOnNavpointsCreated(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onNavpointsCreated, callbackFunc, callbackOwner);
end

function HackableObject:RemoveOnNavpointsCreated(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onNavpointsCreated, callbackFunc, callbackOwner);
end
