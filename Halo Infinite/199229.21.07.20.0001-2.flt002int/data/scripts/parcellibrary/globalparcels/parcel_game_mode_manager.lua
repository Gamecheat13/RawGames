-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

--------------------------------------
------ Game Mode Manager Parcel ------
--------------------------------------

-- This parcel manages basic functionality for a game mode, including:
--   + Round Timer and round flow
-----------------------------------------------------------------------

global GlobalEventManager = nil;

global GameModeManagerParcel = Parcel.MakeParcel
{
	--||
	--|| General Data
	--||

	-- Reference to the parcel table for the primary parent parcel (i.e. the main Game Mode) currently running
	gameModeParcelReference = nil,

	-- Current round state; type is enum: self.CONST.roundStates
	currentRoundState = nil,

	-- Timers
	roundTimer = nil,
	overtimeTimer = nil,
	gracePeriodTimer = nil,
	lastChanceTimer = nil,
	lastChanceRespawnPenalty = nil,
	lastChanceRespawnPenaltySeconds = 0,

	extraTimeEverActive = false,
	roundTimedOut = false,

	-- If the current primary timer is pausable, this will point at it; if nil, pausing the primary timer is currently disallowed
	pausablePrimaryTimer = nil,
	pausablePrimaryTimerUnpauseRate = nil,

	-- Callback that is set as part of InitializePrimaryRoundTimer(), which we invoke upon the GameplayStart event
	startPrimaryRoundTimerFunc = nil,

	-- Overriding Round Time Limits; set via SetOverrideRoundTimeLimit(..)
	overrideRoundTimeLimits = {},

	-- Overriding Scores To Win Round; set via SetOverrideScoreToWinRound(..)
	overrideScoresToWinRound = {},

	-- Overriding seconds remaining event markers; set via SetOverrideSecondsRemainingEvents(..)
	overrideSecondsRemainingEvents = nil,
	-- map of [timeToTriggerSec] -> [predicate:ifunction], e.g. [30] -> [function() return false; end];  set via SetPredicateForSecondsRemainingEvent(..)
	secondsRemainingPredicates = {},	

	-- Worker threads
	roundFlowMonitorThread = nil,
	scoreToWinMonitorThread = nil,
	roundSecondsRemainingMonitorThread = nil,
	lastChanceUpdateThread = nil,

	--||
	--|| Last Chance state
	--||

	lastChanceIsActive = false,
	lastChanceEverActive = false,
	shouldTriggerLastChance = false,
	lastChanceStateObjective = nil,

	-- Mandatory for LastChance modes; predicate function that returns true if conditions for triggering Last Chance are met
	lastChancePredicateFunction = nil,

	--||
	--|| Match Flow overriding functionality
	--||

	-- Functions that will be called on Last Chance begin/end instead of the standard MP Lua Responses (if non-nil)
	lastChanceBeginResponseOverrideFunc = nil,
	lastChanceEndResponseOverrideFunc = nil,

	-- Optional; a function that will be called at the end of regulation time to determine whether or not Overtime should be triggered. If not specified, we will just check if the game is tied.
	shouldTriggerOTRoundOverridePredicateFunc = nil,

	-- Optional; a function that will be called on Round End by the Mode Manager parcel; if this function returns true then the Mode Manager parcel will end the game as well as the round.
	shouldEndGameOnRoundEndPredicateFunc = nil,

	-- Allows for force-disabling side-switching at runtime
	roundSideSwitchingForceDisabled = false,

	lastChanceSoundHasPlayed = false,

	--||
	--|| Overtime Bonus Round
	--||

	-- Predicate function that returns true if Overtime victory has been achieved, and the Overtime Round should end
	-- If not supplied (or if it never returns true), then standard round scoring will be used once the Overtime Round ends on time
	overtimeVictoryConditionsMetPredicateFunc = nil,

	-- Optional; an alternate predicate function that will be called during Overtime Last Chance
	overtimeOverrideLastChancePredicateFunc = nil,

	--||
	--|| Round Results UI
	--||

	winnerRoundResultsNP = nil,
	loserRoundResultsNP = nil,
	tieRoundResultsNP = nil,

	--||
	--|| CONFIG/CONST
	--||

	CONFIG = 
	{
		enableDebugPrint = false,

		-- Sets the time-remaining window for when we flip the switch on last chance triggering when time-up
		lastChanceTriggerWindow = 1.0,

		lastChanceTimerRate = 1.0,
		resettingLastChanceTimer = false,

		suppressLastChanceMusic = false,

		-- Suppresses the enablement of Last Chance if the current round time limit (regulation/OT) is unlimited
		lastChanceAllowedWithUnlimitedRoundTimer = false,
	},

	CONST = 
	{
		--
		-- Variant parameters
		--

		halftimeSwitchRoundThreshold = nil, -- overrides the "switch every round" behavior to instead be "switch permanently on round X"
		roundSideSwitchingEnabled = false,
		gameModeIsAsymmetric = false,

		overtimeDurationSeconds = 0,
		overtimeMode = nil,

		lastChanceDurationSeconds = 0,
		lastChanceEnabledForRegulation = false,
		lastChanceEnabledForOvertime = false,

		roundLimit = 0,
		regulationRoundLimit = 0,
		roundsToWin = 0,

		teamScoringEnabled = false,
		gameModeControlsVictory = false,
		roundStartBannersEnabled = true,

		-- Constant value for "unlimited" round time limit
		k_roundTimeLimitUnlimited = 0,
		-- Constant value for "unlimited" score to win round
		k_scoreToWinRoundUnlimited = 0,
		-- The default value we set as the score to win round when running in Faber without a variant
		k_defaultRoundTimeLimitFaber = 600,

		-- Round state enum; initialized in InitializeImmediate()
		roundStates = {},

		-- Overtime Mode enum; initialized in InitializeImmediate(); MUST BE KEPT IN SYNC with the OvertimeMode enum defined in GameEngineMatchFlowOptions.bond
		overtimeModes = {},

		-- Last Chance
		suddenDeathStringID = "objective_sudden_death_notimer",
		lastChanceUpdateDeltaSeconds = .07,

		-- Round Start splash banner
		regulationRoundStartID = "mp_round_start",
		overtimeRoundStartID = "mp_overtime_round_start",
		roundStartSplashDurationSec = 4,

		secondsRemainingEvents = { 300, 60, 30, 10 },
		-- Suppress Time Remaining Events for 60 seconds and up, if the round time is less than or equal to this var
		minimumTimeLimitForMinutesRemaining = 180,

		-- Objective types
		gameStateIndicatorType = "objective_type_game_state_indicator",
		objectiveBannerType = "objective_message",

		-- round Results
		roundResultWinStringId = "round_result_reason_win",
		roundResultLoseStringId = "round_result_reason_lose",
		roundResultTieStringId = "round_result_reason_tie",
	},

	EVENTS =
	{
		onLastChanceActivated = "OnLastChanceActivated",
		onLastChanceDeactivated = "OnLastChanceDeactivated",

		onRegulationRoundTimeExpired = "OnRegulationRoundTimeExpired",
		onOvertimeRoundTimeExpired = "OnOvertimeRoundTimeExpired",
		onOvertimeTimeExtensionExpired = "OnOvertimeTimeExtensionExpired",
		onRoundEndingDueToTimeExpired = "OnRoundEndingDueToTimeExpired",	-- generic event that fires if a round is being ended due to timeout

		onThirtySecondsRemaining = "OnThirtySecondsRemaining",
		onSixtySecondsRemaining = "OnSixtySecondsRemaining",
	}
};


function GameModeManagerParcel:New():table
	local newGameModeManager:table = self:CreateParcelInstance();
	return newGameModeManager;
end

function GameModeManagerParcel:Run():void

end

function GameModeManagerParcel:shouldEnd():boolean
	-- This parcel should never end since it's intended to be alive at the very start of a match, all the way until the last round has finished.
	-- At that point Lua state will soon be torn down.. we leave this parcel alive though so that it continues to emit events as expected
	return false;
end

function GameModeManagerParcel:EndShutdown():void
	-- Nothing should go in this function, since this parcel never ends (see GameModeManagerParcel:shouldEnd())
	-- All networked properties, navpoints, timers, etc. will be torn down by the native engine once the match is over, so we are okay with "leaking" them here
end

function GameModeManagerParcel:InitializeImmediate():void
	-- Initialize roundStates enum and the current round state
	self.CONST.roundStates = table.makeAutoEnum
	{
		"PreGame",
		"RegulationTime",
		"Overtime", -- Can either mean "standard" clock time for an OT round, or the OT time extension in a normal round
		"PostRound",
		-- Note that LastChance is a supplemental state that can be applied to either RegulationTime or Overtime, and is not part of the round "state machine"
	};

	self.currentRoundState = self.CONST.roundStates.PreGame;

	-- Initialize OvertimeMode enum
	-- NOTE: this should be kept in sync with Microsoft.Halo.GameOptions.OvertimeMode, which is defined in GameEngineMatchFlowOptions.bond; should eventually be made into a Lua enum
	self.CONST.overtimeModes = table.makeEnum
	{
		Disabled = 0,
		RegulationTimeExtension = 1,
		OvertimeBonusRound = 2,
	};

	-- By default, if the game mode doesn't provide a predicate for enabling Last Chance then we will return false
	self.lastChancePredicateFunction = returnFalse;
end

function GameModeManagerParcel:Initialize():void
	--Start Up Global Event Manager if it doesn't already exist.
	if GlobalEventManager == nil then
		GlobalEventManager = GlobalEventManagerParcel:New();
		self:StartChildParcel(GlobalEventManager, "GlobalEventManagerParcel");
	end

	if (not editor_mode()) then
		if Variant_DoesPropertyExist("HalftimeSwitchRoundThreshold") then
			-- Get the threshold, accounting for floating point precision errors
			local sideSwitchThreshold:number = Variant_GetFloatProperty("HalftimeSwitchRoundThreshold");
			sideSwitchThreshold = math.floor(sideSwitchThreshold + 0.1);

			if sideSwitchThreshold > 0 then
				self.CONST.halftimeSwitchRoundThreshold = sideSwitchThreshold;
			end
		end

		if (Variant_DoesPropertyExist("RoundStartBannersForceDisabled")) then
			if (Variant_GetBoolProperty("RoundStartBannersForceDisabled")) then
				self.CONST.roundStartBannersEnabled = false;
			end
		end

		self.winnerRoundResultsNP = Engine_CreateNetworkedProperty(Variant_GetWinningRoundReasonNetworkedPropertyName());
		NetworkedProperty_SetStringIdProperty(self.winnerRoundResultsNP, Engine_ResolveStringId(self.CONST.roundResultWinStringId));

		self.loserRoundResultsNP = Engine_CreateNetworkedProperty(Variant_GetLosingRoundReasonNetworkedPropertyName());
		NetworkedProperty_SetStringIdProperty(self.loserRoundResultsNP, Engine_ResolveStringId(self.CONST.roundResultLoseStringId));

		self.tieRoundResultsNP = Engine_CreateNetworkedProperty(Variant_GetTieRoundReasonNetworkedPropertyName());
		NetworkedProperty_SetStringIdProperty(self.tieRoundResultsNP, Engine_ResolveStringId(self.CONST.roundResultTieStringId));

		self.CONST.roundSideSwitchingEnabled = Variant_GetRoundSideSwitchingEnabled();
		self.CONST.gameModeIsAsymmetric = Variant_GetGameModeIsAsymmetric();

		self.CONST.overtimeMode = Variant_GetOvertimeMode();
		self.CONST.overtimeDurationSeconds = Variant_GetOvertimeDurationSeconds();
		
		self.CONST.lastChanceEnabledForRegulation = Variant_GetLastChanceEnabledInRegulation();
		self.CONST.lastChanceEnabledForOvertime = Variant_GetLastChanceEnabledInOvertime();
		self.CONST.lastChanceDurationSeconds = Variant_GetLastChanceDurationSeconds();

		-- If we have a LC duration of 0, then there is no point in allowing a grace period window for satisfying conditions
		-- since the round will end immediately if the timer hits 0 and the conditions aren't actively being met
		if (self.CONST.lastChanceDurationSeconds == 0) then
			self.CONFIG.lastChanceTriggerWindow = 0;
		end

		self.CONST.roundLimit = Variant_GetRoundLimit();
		self.CONST.regulationRoundLimit = Variant_GetRegulationRoundLimit();
		self.CONST.roundsToWin = Variant_GetEarlyVictoryRoundCount();

		self.CONST.teamScoringEnabled = Variant_GetTeamScoringEnabled();
		self.CONST.gameModeControlsVictory = Variant_GetGameModeControlsVictory();

		-- Validate values
		assert(self.CONST.overtimeDurationSeconds >= 0, "Error: a negative OvertimeDuration was specified by the game variant!");
		assert(self.CONST.lastChanceDurationSeconds >= 0, "Error: a negative LastChanceDuration was specified by the game variant!");
		assert(self.CONST.roundLimit >= 0, "Error: a negative RoundLimit was specified by the game variant!");
		assert(self.CONST.roundsToWin >= 0, "Error: a negative EarlyVictoryRoundCount was specified by the game variant!");
	else -- We have to initialize the above params with default values since there is no Variant in Faber
		self.CONST.roundSideSwitchingEnabled = false;
		self.CONST.gameModeIsAsymmetric = false;

		self.CONST.overtimeDurationSeconds = 180;
		self.CONST.overtimeMode = self.CONST.overtimeModes.RegulationTimeExtension;

		self.CONST.lastChanceDurationSeconds = 10;
		self.CONST.lastChanceEnabledForRegulation = false;
		self.CONST.lastChanceEnabledForOvertime = false;

		self.CONST.roundLimit = 1;
		self.CONST.regulationRoundLimit = 1;
		self.CONST.roundsToWin = 0;

		self.CONST.teamScoringEnabled = true;
		self.CONST.gameModeControlsVictory = false;
	end

	-- Register handlers
	-- Register for All Rounds
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundStartEvent, self.HandleRoundStart);
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundStartGameplayEvent, self.HandleRoundGameplayStart);
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundOutcomeRecordedEventImmediate, self.HandleRoundOutcomeRecordedImmediate);
	self:RegisterGlobalEventOnSelf(g_eventTypes.roundEndEvent, self.HandleRoundEnd);
	self:RegisterGlobalEventOnSelf(g_eventTypes.enteredBetweenRoundStateEvent, self.HandleBetweenRoundsState);
	self:RegisterGlobalEventOnSelf(g_eventTypes.matchFlowIntroEndedEvent, self.HandleMatchFlowIntroEnd);

	-- Get handles to round timers; note these are statically indexed so it's safe to just grab them once
	self.roundTimer = Engine_GetRoundTimer();
	self.overtimeTimer = Engine_GetOvertimeTimer();
	self.gracePeriodTimer = Engine_GetGracePeriodTimer();

	GlobalEventManager:RegisterParcelGlobalEvent("ModeParcelsInitialized");
end

function GameModeManagerParcel:HandleRoundStart(eventArgs:RoundStartEventStruct):void
	self:DebugPrint("*** HandleRoundStart hit! ***");

	self.lastChanceSoundHasPlayed = false;
	self.extraTimeEverActive = false;
	self.lastChanceEverActive = false;
	self.roundTimedOut = false;

	-- If there is an override score to win round supplied, then set that now
	local overrideScoreToWin:number = self.overrideScoresToWinRound[eventArgs.roundIndex];
	if (overrideScoreToWin ~= nil) then
		VariantOverrides_SetScoreToWinRound(overrideScoreToWin);
	end

	-- If there is an override time limit supplied, then set that now
	local overrideRoundTimeLimit:number = self.overrideRoundTimeLimits[eventArgs.roundIndex];
	if (overrideRoundTimeLimit ~= nil) then
		VariantOverrides_SetRoundTimeLimit(overrideRoundTimeLimit);
	end

	-- Switch spawns if configured to do so
	if (self:GetRoundSideSwitchingEnabledForRoundIndex(eventArgs.roundIndex)) then
		self:CreateThread(function()
			-- The RoundStart processes before kits finish processing their BeginRound calls
			--	so swap in a thread to delay it a frame for all kits to be ready.
			-- v-tystap's upcoming changes to how builtin kit functions are called should fix this issue
			Engine_SwapSpawnPointDesignators(MP_TEAM_DESIGNATOR.First, MP_TEAM_DESIGNATOR.Second);
			Engine_SwapSpawnZoneDesignators(MP_TEAM_DESIGNATOR.First, MP_TEAM_DESIGNATOR.Second);
		end);
	end

	if (eventArgs.isOvertimeRound) then
		--
		-- Overtime Bonus Round Flow
		--
		assert(self.CONST.overtimeMode == self.CONST.overtimeModes.OvertimeBonusRound,
			"An OvertimeRound was just triggered by the engine but the OvertimeMode in the game_mode_manager parcel was not set to OvertimeBonusRound!");

		self.currentRoundState = self.CONST.roundStates.Overtime;
		self:InitializePrimaryRoundTimer(self.overtimeTimer, self.CONST.overtimeDurationSeconds);
		self:InitializeLastChance();

		-- Create thread to monitor OT timer if needed, and to poll if Overtime Bonus Round victory conditions are met
		debug_assert(self.roundFlowMonitorThread == nil, "There was already a roundFlowMonitorThread running when attempting to create one for the OvertimeBonusRoundMonitor!");
		self.roundFlowMonitorThread = self:CreateThread(self.OvertimeBonusRoundMonitor);
		
	else
		--
		-- Normal Round Flow
		--
		local roundTimeLimit:number = self:GetCurrentRoundTimeLimitSeconds();

		self.currentRoundState = self.CONST.roundStates.RegulationTime;
		self:InitializePrimaryRoundTimer(self.roundTimer, roundTimeLimit);
		self:InitializeLastChance();

		-- We only need to monitor the RoundTimer for RoundEnd, Overtime, and Last Chance if there's an actual time limit (i.e. and not Unlimited Time)
		if (roundTimeLimit ~= self.CONST.k_roundTimeLimitUnlimited) then
			debug_assert(self.roundFlowMonitorThread == nil, "There was already a roundFlowMonitorThread running when attempting to create one for the RoundTimeMonitor!");
			self.roundFlowMonitorThread = self:CreateThread(self.RoundTimeMonitor);
		end

		-- If GameModeControlsVictory is true (and there is a limited score to win), then this parcel is responsible for ending the game when the ScoreToWin is reached.
		-- Note this is only done for normal (i.e. non-Overtime) rounds
		if (self:GetCurrentScoreToWinRound() ~= self.CONST.k_scoreToWinRoundUnlimited and self.CONST.gameModeControlsVictory == true) then
			self.scoreToWinMonitorThread = self:CreateThread(self.ScoreToWinMonitor);
		end
	end
end

function GameModeManagerParcel:HandleRoundGameplayStart(eventArgs:RoundStartGameplayEventStruct):void
	self:DebugPrint("*** HandleRoundGameplayStart hit! ***");

	if (self.CONST.roundStartBannersEnabled) then
		if (Engine_GetCurrentRoundIsOvertimeRound()) then
			Splash_PushToAllPlayers(self.CONST.roundStartSplashDurationSec, self.CONST.overtimeRoundStartID);
		elseif (self.CONST.roundLimit ~= 1 and self.CONST.regulationRoundLimit ~= 1) then
			Splash_PushToAllPlayers(self.CONST.roundStartSplashDurationSec, self.CONST.regulationRoundStartID, eventArgs.roundIndex + 1);
		end
	end

	self:StartPrimaryRoundTimerInternal();
end

-- NOTE: This function call is NOT deferred until the end of the frame by the Engine, but rather is called with
--       inline execution from its callsite inside of GameEngineEndRoundInternal. This allows us to flag the next round
--       as an OT Round before it starts in time for our C++ round end logic to know if the entire game should end or not
function GameModeManagerParcel:HandleRoundOutcomeRecordedImmediate(eventArgs:RoundOutcomeRecordedEventStruct):void
	-- Overtime bonus round checks:
	--   1) OT Bonus Round enabled
	--   2) There is a RegulationRoundLimit defined, and we have met/exceeded that limit
	--   3) The custom predicate is defined and returns true [OR] there is no custom predicate and the top two teams are tied for RoundsWon

	if ((self.CONST.overtimeMode == self.CONST.overtimeModes.OvertimeBonusRound) and
	    (self.CONST.regulationRoundLimit > 0) and
	    ((eventArgs.finalizedRoundIndex + 1) >= self.CONST.regulationRoundLimit)
	    ) then
	   	
	   	if (self.shouldTriggerOTRoundOverridePredicateFunc ~= nil) then
			if (self.shouldTriggerOTRoundOverridePredicateFunc(self.gameModeParcelReference)) then
				Engine_SetNextRoundIsOvertimeRound(true);
			end
		else
			if (Engine_MatchIsTiedForRoundsWon()) then
				Engine_SetNextRoundIsOvertimeRound(true);
			end
		end
	end
end

function GameModeManagerParcel:HandleRoundEnd():void
	self:DebugPrint("*** HandleRoundEnd hit! ***");

	self.currentRoundState = self.CONST.roundStates.PostRound;

	-- Tell the Last Chance thread to end (so it doesn't interfere with later Round Timers)
	self:DisposeLastChance();

	-- Kill any remaining round monitor threads (they can still be alive if the round was ended external to the parcel)
	if (self.roundFlowMonitorThread ~= nil) then
		self:KillThread(self.roundFlowMonitorThread);
		self.roundFlowMonitorThread = nil;
	end

	if (self.roundSecondsRemainingMonitorThread ~= nil) then
		self:KillThread(self.roundSecondsRemainingMonitorThread);
		self.roundSecondsRemainingMonitorThread = nil;
	end

	if (self.scoreToWinMonitorThread ~= nil) then
		self:KillThread(self.scoreToWinMonitorThread);
		self.scoreToWinMonitorThread = nil;
	end

	-- Reset our pausable primary timer state just to be sure
	self:DisallowPausingPrimaryTimerInternal();

	-- The game mode parcels will need to re-register their params every round (most of them only have the lifetime of a single round by design)
	self:ClearModeManagerInitArgs();
end

function GameModeManagerParcel:SetRoundEndReason(winnerReason:string, loserReason:string, ignoreTimeOut:boolean):void
	local tieReason:string = "round_result_reason_tie";

	-- Use generic Time-Out message if applicable
	if (self.roundTimedOut and (ignoreTimeOut ~= true)) then
		winnerReason = "round_result_reason_time";
		loserReason = "round_result_reason_time";
	end
	-- Append Overtime if applicable
	if Engine_GetCurrentRoundIsOvertimeRound() then
		winnerReason = winnerReason .. "_overtime";
		loserReason = loserReason .. "_overtime";
		tieReason = tieReason .. "_overtime";
	end
	-- Append Sudden Death if applicable
	if self:GetLastChanceIsEverActive() then
		winnerReason = winnerReason .. "_sd";
		loserReason = loserReason .. "_sd";
		tieReason = tieReason .. "_sd";
	end

	self:SetWinnerRoundEndReasonStringId(winnerReason);
	self:SetLoserRoundEndReasonStringId(loserReason);
	self:SetTieRoundEndReasonStringId(tieReason);
end

function GameModeManagerParcel:HandleBetweenRoundsState():void
	self:DebugPrint("*** HandleBetweenRoundsState hit! ***");
	
	-- Clear any overrides from the previous round
	local previousRoundIndex:number = Engine_GetRoundIndex() - 1;

	if (self.overrideScoresToWinRound[previousRoundIndex] ~= nil) then
		VariantOverrides_ClearScoreToWinRound();
	end
	
	if (self.overrideRoundTimeLimits[previousRoundIndex] ~= nil) then
		VariantOverrides_ClearRoundTimeLimit();
	end
end

function GameModeManagerParcel:HandleMatchFlowIntroEnd():void
	self:DebugPrint("*** HandleMatchFlowIntroEnd hit! ***");
end

function GameModeManagerParcel:ScoreToWinMonitor():void
	repeat
		if self:ScoreToWinMet() then
			self:TriggerRoundEnd(false);
		end

		Sleep(1);
	until self.currentRoundState == self.CONST.roundStates.PostRound;

	self.scoreToWinMonitorThread = nil;
end

function GameModeManagerParcel:OvertimeVictoryConditionMet():boolean
	if (self.overtimeVictoryConditionsMetPredicateFunc ~= nil) then
		return self.overtimeVictoryConditionsMetPredicateFunc(self.gameModeParcelReference);
	else
		return self:ScoreToWinMet();
	end
end

function GameModeManagerParcel:RoundSecondsRemainingMonitor(activeTimer:timer, secondEventTable:table):void
	secondEventTable = secondEventTable or self.overrideSecondsRemainingEvents or self.CONST.secondsRemainingEvents
	table.sort(secondEventTable, [(a, b)| a > b]);

	local eventIndex = 1;
	local nextSecondEvent = secondEventTable[eventIndex];

	-- Skip past any events that occur before the round starts.
	-- If the round is only 2 minutes we don't want to fire a 5 minutes remaining event at the start.
	-- Use < instead of <= because if a round is 60 seconds long we want the 60 seconds remaining event to fire.
	while (nextSecondEvent ~= nil and Timer_GetSecondsLeft(activeTimer) < nextSecondEvent) do
		eventIndex = eventIndex + 1;
		nextSecondEvent = secondEventTable[eventIndex];
	end

	while nextSecondEvent ~= nil and not Timer_IsExpired(activeTimer) do
		SleepUntil([| Timer_IsCountingDown(activeTimer) and Timer_GetSecondsLeft(activeTimer) <= nextSecondEvent], 1);

		-- Fire the MP Response Lua event if we pass the predicate (or none is defined)
		local eventPredicate:ifunction = self.secondsRemainingPredicates[nextSecondEvent];
	
		-- Do not fire minutes remaining events in game modes with short rounds
		-- But ALWAYS fire in overtime
		-- Don't fire if the round time limit is equal to the event (prevents playing at start of game)
		if ((nextSecondEvent < 60 or 
			(Variant_GetRoundTimeLimitSeconds() > self.CONST.minimumTimeLimitForMinutesRemaining) or 
			Engine_GetCurrentRoundIsOvertimeRound()) and
			(Variant_GetRoundTimeLimitSeconds() ~= nextSecondEvent)) then
			if (eventPredicate == nil or eventPredicate(self.gameModeParcelReference) == true) then
				MPLuaCall("__OnSecondsRemaining", nextSecondEvent);
			end
			MPLuaCall("__OnSecondsRemainingAnnouncer", nextSecondEvent);
		end
		
		eventIndex = eventIndex + 1;
		nextSecondEvent = secondEventTable[eventIndex];
	end

	self.roundSecondsRemainingMonitorThread = nil;
end

function GameModeManagerParcel:StartRoundSecondsRemainingMonitor(activeTimer:timer, secondEventTable:table):void
	-- Kill any previous monitor thread if one exists, there should only be one running at a time
	if (self.roundSecondsRemainingMonitorThread ~= nil) then
		self:KillThread(self.roundSecondsRemainingMonitorThread);
	end

	self.roundSecondsRemainingMonitorThread = self:CreateThread(self.RoundSecondsRemainingMonitor, activeTimer, secondEventTable);
end

function GameModeManagerParcel:SleepUntilLastChanceExpired(currentGameTimer:timer):void
	self:DebugPrint("SleepUntilLastChanceExpired() hit!");

	local currentRoundTimeLimit:number = self:GetCurrentRoundTimeLimitSeconds();
	self:UpdateLastChanceState(currentRoundTimeLimit);

	local lastChanceHasExpired:ifunction = 
		function():boolean
			if (self.lastChanceEverActive) then
				if (self.lastChanceTimer == nil) then
					return (self.lastChanceIsActive == false);
				else
					return Timer_IsExpired(self.lastChanceTimer);
				end
			else
				-- If LC was never active, we'll consider LC to have expired for our case here
				return true;
			end
		end

	if (not lastChanceHasExpired()) then
		-- **HACK**: If this is a time-limited mode and we are newly activating LC, then
		-- we set the round timer to 0.15 to signal to the UI (RoundTimer.cpp) that we are in a "Last Chance"/"Sudden Death" state
		if (currentRoundTimeLimit ~= self.CONST.k_roundTimeLimitUnlimited) then
			assert(Timer_IsExpired(currentGameTimer), "The currentGameTimer passed into SleepUntilLastChanceExpired() was not expired! This function should only be called on timer transitions");
			Timer_SetSecondsLeft(currentGameTimer, 0.15);
		end

		self:DebugPrint("Sleeping until Last Chance expires..");
		SleepUntil([| lastChanceHasExpired()], 1);
		self:DebugPrint("Last Chance expired!");

		-- **HACK 2**: Now change the timer back to 0 tidy up state
		Timer_SetSecondsLeft(currentGameTimer, 0);
	else
		self:DebugPrint("Last chance was never activated (self.lastChanceEverActive=", self.lastChanceEverActive, ")!  continuing on...");
	end
end

function GameModeManagerParcel:OvertimeBonusRoundMonitor():void
	MPLuaCall("__OnOvertimeStart");

	--
	-- OVERTIME BONUS ROUND
	-- 		(NOTE: StartPrimaryRoundTimerInternal called by HandleRoundGameplayStart)
	--

	-- Sleep routines
	if (self.CONST.overtimeDurationSeconds > 0) then
		SleepUntil([|Timer_IsExpired(self.overtimeTimer) or self:OvertimeVictoryConditionMet()], 1);

		-- If we broke out of the sleep due to time expiration, then fire our time expired event for this OT round
		if Timer_IsExpired(self.overtimeTimer) then
			self.roundTimedOut = true;
		end
	elseif (self.CONST.overtimeDurationSeconds == 0) then
		SleepUntil([|self:OvertimeVictoryConditionMet()], 1);
	else
		assert(false, "Negative overtimeDurationSeconds encountered in parcel_game_mode_manager.lua!");
	end

	self:DisallowPausingPrimaryTimerInternal();
	
	-- If we timed out, then we must make sure we aren't blocked by Last Chance to end the round
	if (self.roundTimedOut) then
		if (self.CONST.lastChanceEnabledForOvertime) then
			self:SleepUntilLastChanceExpired(self.overtimeTimer);
		end

		self:TriggerEventImmediate(self.EVENTS.onOvertimeRoundTimeExpired);
		self:TriggerEventImmediate(self.EVENTS.onRoundEndingDueToTimeExpired);
	end

	self:TriggerRoundEnd(false);
end

function GameModeManagerParcel:RoundTimeMonitor():void
	-- If using Time Extension, go ahead and initialize our OT timer so that the HUD doesn't flicker when we roll over to the OT clock
	if (self.CONST.overtimeMode == self.CONST.overtimeModes.RegulationTimeExtension) then
		Timer_SetSecondsLeft(self.overtimeTimer, self.CONST.overtimeDurationSeconds);
	end

	--
	-- STANDARD REGULATION TIME
	--		(NOTE: StartPrimaryRoundTimerInternal called by HandleRoundGameplayStart)
	--

	-- Wait until the primary round timer expires; note that this will be an infinite sleep if the RoundTimeLimit is unlimited (== 0)
	-- In the unlimited case, this thread will be killed by HandleRoundEnd
	local thirtySecondsEventFired:boolean = false;
	local sixtySecondsEventFired:boolean = false;
	repeat
		-- Once we hit 30 seconds remaining, fire our event for it
		if (not thirtySecondsEventFired and Timer_IsCountingDown(self.roundTimer) and Timer_GetSecondsLeft(self.roundTimer) <= 30) then
			self:TriggerEvent(self.EVENTS.onThirtySecondsRemaining);
			thirtySecondsEventFired = true;
		end

		-- Once we hit 30 seconds remaining, fire our event for it
		if (not sixtySecondsEventFired and Timer_IsCountingDown(self.roundTimer) and Timer_GetSecondsLeft(self.roundTimer) <= 60) then
			self:TriggerEvent(self.EVENTS.onSixtySecondsRemaining);
			sixtySecondsEventFired = true;
		end

		Sleep(1);
	until Timer_IsExpired(self.roundTimer);

	-- Disallow pausing of timer and block on Last Chance if necessary
	self:DisallowPausingPrimaryTimerInternal();

	if (self.CONST.lastChanceEnabledForRegulation) then
		self:SleepUntilLastChanceExpired(self.roundTimer);
	end

	-- Regulation time is now expired
	self:TriggerEventImmediate(self.EVENTS.onRegulationRoundTimeExpired);
	

	--
	-- OVERTIME TIME EXTENSION
	--

	if (self.CONST.overtimeMode == self.CONST.overtimeModes.RegulationTimeExtension and Engine_CurrentRoundScoreIsTied()) then
		-- Transition state and fire MP Lua Response
		self.currentRoundState = self.CONST.roundStates.Overtime;
		self.extraTimeEverActive = true;
		MPLuaCall("__OnOvertimeStart");

		-- Re-initialize LC and timer state since this new time extension is a fresh start
		self:InitializePrimaryRoundTimer(self.overtimeTimer, self.CONST.overtimeDurationSeconds);
		self:InitializeLastChance();

		-- If we have a positive duration, start the timer and sleep until expired
		if (self.CONST.overtimeDurationSeconds > 0) then
			self:StartPrimaryRoundTimerInternal();
			
			SleepUntil([|Timer_IsExpired(self.overtimeTimer)], 1);

			-- Disallow pausing of timer and block on Last Chance if necessary
			self:DisallowPausingPrimaryTimerInternal();

			if (self.CONST.lastChanceEnabledForOvertime) then
				self:SleepUntilLastChanceExpired(self.overtimeTimer);
			end

			self:TriggerEventImmediate(self.EVENTS.onOvertimeTimeExtensionExpired);

		-- Otherwise if we have an unlimited duration specified, then start the timer with a negative rate and sleep until expired (which should be never, we're basically waiting for the game to end on score)
		elseif (self.CONST.overtimeDurationSeconds == self.CONST.k_roundTimeLimitUnlimited) then
			Timer_StartWithRate(self.overtimeTimer, -1.0);
			SleepUntil([|Timer_IsExpired(self.overtimeTimer)], 1); -- this will pretty much sleep forever unless someone slams this timer to 0 (since we're counting up)
		else
			assert(false, "Negative overtimeDurationSeconds encountered in parcel_game_mode_manager.lua!");
		end
	end

	--
	-- END OF REGULATION ROUND
	--

	self.roundTimedOut = true;
	self:TriggerEventImmediate(self.EVENTS.onRoundEndingDueToTimeExpired);

	self:TriggerRoundEnd(false);
end

-- This function will initialize timer state such that the specified round timer (self.roundTimer or self.overtimeTimer) is set to the given time limit,
-- and that the other timer is properly stopped before this new round begins. If MatchFlow intros are disabled, then we will start the timer now.
function GameModeManagerParcel:InitializePrimaryRoundTimer(primaryRoundTimer:timer, roundTimeLimit:number):void
	assert(roundTimeLimit >= 0, "Error: Invalid roundTimeLimit (" .. tostring(roundTimeLimit) .. ") supplied to GameModeManagerParcel:InitializePrimaryRoundTimer!");
	assert(primaryRoundTimer == self.roundTimer or primaryRoundTimer == self.overtimeTimer,
		"Error: Invalid timer (" .. tostring(primaryRoundTimer) .. ") supplied to GameModeManagerParcel:InitializePrimaryRoundTimer! Only the roundTimer and overtimeTimer are acceptable values.");

	Timer_Stop(self.roundTimer);
	Timer_Stop(self.overtimeTimer);

	Timer_SetSecondsLeft(primaryRoundTimer, roundTimeLimit);
	local timerRate:number = self:GetStandardRoundTimerRateForTimeLimit(roundTimeLimit);
	local isTimeLimited:boolean = (roundTimeLimit ~= self.CONST.k_roundTimeLimitUnlimited);

	-- This will be invoked (and nil'd out) upon RoundGameplayStart
	self.startPrimaryRoundTimerFunc =
		function(self:table):void
			Timer_StartWithRate(primaryRoundTimer, timerRate);

			if (isTimeLimited) then
				self:StartRoundSecondsRemainingMonitor(primaryRoundTimer);

				self.pausablePrimaryTimer = primaryRoundTimer;
				self.pausablePrimaryTimerUnpauseRate = timerRate;
			else
				self:DisallowPausingPrimaryTimerInternal();
			end
		end
end

function GameModeManagerParcel:StartPrimaryRoundTimerInternal():void
	assert(self.startPrimaryRoundTimerFunc ~= nil, "Error: self.startPrimaryRoundTimerFunc was nil when GameModeManagerParcel:StartPrimaryRoundTimerInternal was hit!");
	self.startPrimaryRoundTimerFunc(self);
	self.startPrimaryRoundTimerFunc = nil;
end

function GameModeManagerParcel:DisallowPausingPrimaryTimerInternal():void
	self.pausablePrimaryTimer = nil;
	self.pausablePrimaryTimerUnpauseRate = nil;
end

function GameModeManagerParcel:TriggerRoundEnd(shouldEndGame:boolean):void
	-- If the game mode supplied overriding logic for whether or not to end the game on RoundEnd, respect that here (if we haven't already been told to end the game by the callsite of this function)
	if (not shouldEndGame) then
		if (self.shouldEndGameOnRoundEndPredicateFunc ~= nil) then
			shouldEndGame = self.shouldEndGameOnRoundEndPredicateFunc(self.gameModeParcelReference);
		end
	end

	-- Make sure we didn't end up with a nil value for shouldEndGame
	shouldEndGame = shouldEndGame or false;

	-- End the round (and potentially the game if specified by shouldEndGame)
	if (self.CONST.teamScoringEnabled) then
		Engine_EndRoundWithTeamScoring(shouldEndGame);
	else
		Engine_EndRoundWithPlayerScoring(shouldEndGame);
	end
end

function GameModeManagerParcel:LastChanceConditionsMet():boolean
	-- If we're in Overtime and an override predicate was supplied for Last Chance, then defer to that
	if (self.currentRoundState == self.CONST.roundStates.Overtime and self.overtimeOverrideLastChancePredicateFunc ~= nil) then
		return self.overtimeOverrideLastChancePredicateFunc(self.gameModeParcelReference);
	else
		return self.lastChancePredicateFunction(self.gameModeParcelReference);
	end
end

function GameModeManagerParcel:ModeParcelIsActive():boolean
	return
		(self.gameModeParcelReference ~= nil) and
		(not self.gameModeParcelReference:shouldEnd()) and
		ParcelIsActive(self.gameModeParcelReference);
end

function GameModeManagerParcel:LastChanceMonitor():void
	-- Wait for game mode parcel to become active and register itself with this parcel
	SleepUntilSeconds([| self:ModeParcelIsActive() ], self.CONST.lastChanceUpdateDeltaSeconds);

	local currentRoundTimeLimit:number = self:GetCurrentRoundTimeLimitSeconds();
	local lastChanceStartedAndExpired:ifunction = 
		function():boolean
			if (self.lastChanceEverActive) then
				if (self.lastChanceTimer == nil) then
					return (self.lastChanceIsActive == false);
				else
					return Timer_IsExpired(self.lastChanceTimer);
				end
			end
			return false;
		end


	-- Main loop
	repeat
		-- Check if we should break out of LastChance due to round states
		if (self.currentRoundState == self.CONST.roundStates.Overtime) then
			if (not self.CONST.lastChanceEnabledForOvertime) then
				break;
			end
		elseif (self.currentRoundState == self.CONST.roundStates.PostRound) then
			break;
		elseif (self.currentRoundState ~= self.CONST.roundStates.RegulationTime) then
			print("Unexpected RoundState encountered in GameModeManagerParcel.LastChanceMonitor(), disabling Last Chance!");
			break;
		end

		self:UpdateLastChanceState(currentRoundTimeLimit);
		if (lastChanceStartedAndExpired()) then
			break;
		end

		SleepSeconds(self.CONST.lastChanceUpdateDeltaSeconds);
	until (not self:ModeParcelIsActive());

	-- Clear our own thread handle so we don't kill ourselves + dispose state
	self.lastChanceUpdateThread = nil;
	self:DisposeLastChance();
end

-- Sort of awkward, but we accept currentRoundTimeLimit as a param here so that we can cache the value at callsites
function GameModeManagerParcel:UpdateLastChanceState(currentRoundTimeLimit:number):void
	-- If we've already triggered LastChance, then continue to check conditions and enable/disable accordingly
	if self.lastChanceEverActive then
		if self:LastChanceConditionsMet() then
			self:EnableLastChance();
		else
			self:DisableLastChance();
		end

	-- Otherwise run checks to see if we should trigger Last Chance (now or at some point when the timer runs out)
	else
		-- Obtain time remaining
		-- Note that a final value of nil here means we're a time-unlimited round; also, we explicitly check for Timer_IsExpired because Timer_GetSecondsLeft(..)==0 will fail due to FPP issues
		local timeRemaining:number = nil;
		if (currentRoundTimeLimit ~= self.CONST.k_roundTimeLimitUnlimited) then
			if (self.currentRoundState == self.CONST.roundStates.RegulationTime) then
				timeRemaining = (Timer_IsExpired(self.roundTimer) and 0) or Timer_GetSecondsLeft(self.roundTimer);
			elseif (self.currentRoundState == self.CONST.roundStates.Overtime) then
				timeRemaining = (Timer_IsExpired(self.overtimeTimer) and 0) or Timer_GetSecondsLeft(self.overtimeTimer);
			end
		end

		-- If we are <= the trigger window (or have no time limit) and we've hit trigger condition set by the game mode, then flag shouldTriggerLastChance
		-- which will guarantee we enter Last Chance at least once when the round timer runs out
		if (not self.shouldTriggerLastChance) then
			if (timeRemaining == nil) or (timeRemaining <= self.CONFIG.lastChanceTriggerWindow) then
				if self:LastChanceConditionsMet() then
					self:DebugPrint(
						"Last Chance conditions met within the lastChanceTriggerWindow (" .. tostring(self.CONFIG.lastChanceTriggerWindow) ..
						" sec), with timeRemaining = " .. tostring(timeRemaining) ..
						";  Setting self.shouldTriggerLastChance = true");

					self.shouldTriggerLastChance = true;
				end
			end
		end

		if (self.shouldTriggerLastChance) then
			-- We only activate LC as the current timer expires (or whenever, if we're time-unlimited)
			if (timeRemaining == nil or timeRemaining == 0) then
				self:EnableLastChance();
			end
		end
	end
end

function GameModeManagerParcel:InitializeLastChance():void
	-- Dispose old state if we still had an old version of LC running
	if (self.lastChanceUpdateThread ~= nil) then 
		self:DisposeLastChance();
	end
	assert(self.lastChanceUpdateThread == nil, "DisposeLastChance() failed to clean up the lastChanceUpdateThread!");

	-- Early out if LC is disabled for this phase of the round/match
	if not self:LastChanceEnabledForCurrentGameModeState() then
		return;
	end

	-- Create the Last Chance Objective and disable it initially
	self.lastChanceStateObjective = Engine_CreateObjective(self.CONST.gameStateIndicatorType);
	Objective_SetFormattedText(self.lastChanceStateObjective, self.CONST.suddenDeathStringID);
	Objective_SetPriority(self.lastChanceStateObjective, 255);
	Objective_SetEnabled(self.lastChanceStateObjective, false);

	-- Create the LastChance timer if a time limit is specified for it
	if (self.CONST.lastChanceDurationSeconds ~= 0) then
		debug_assert(self.lastChanceTimer == nil, "A lastChanceTimer already existed when InitializeLastChance was called! DisposeLastChance() should have nil'd out this member!");
		self.lastChanceTimer = self.gracePeriodTimer;
		assert(self.lastChanceTimer ~= nil, "Failed to create lastChanceTimer in InitializeLastChance! LastChance will not function correctly without this!");

		Timer_SetSecondsLeft(self.lastChanceTimer, self.CONST.lastChanceDurationSeconds);
	end

	self.lastChanceIsActive = false;
	self.lastChanceEverActive = false;
	self.shouldTriggerLastChance = false;

	-- Start new monitor thread
	self.lastChanceUpdateThread = self:CreateThread(self.LastChanceMonitor);
end

function GameModeManagerParcel:DisposeLastChance():void
	-- Kill the update thread if it's still running
	if (self.lastChanceUpdateThread ~= nil) then
		self:KillThread(self.lastChanceUpdateThread);
		self.lastChanceUpdateThread = nil;
	end

	if (self.lastChanceRespawnPenalty ~= nil) then
		RespawnPenalty_RemovePenalty(self.lastChanceRespawnPenalty);
		self.lastChanceRespawnPenalty = nil;
	end

	-- Clean up the Last Chance Objective and other state
	if (self.lastChanceStateObjective ~= nil) then
		Objective_Delete(self.lastChanceStateObjective);
		self.lastChanceStateObjective = nil;
	end

	self.lastChanceTimer = nil; -- note that we don't delete this timer since it's the engine's grace period timer
	self.lastChanceIsActive = false;
	self.lastChanceEverActive = false;
	self.shouldTriggerLastChance = false;
end

function GameModeManagerParcel:EnableLastChance():void
	-- Handle special cases if this is the first time Last Chance is becoming active
	if (not self.lastChanceEverActive) then
		self.lastChanceEverActive = true;

		MPLuaCall('__OnGenericLastChanceBegin');
		if (ThisMightBeTheFinalRound() and (self.CONFIG.suppressLastChanceMusic == false)) then
			MPLuaCall('__OnGenericLastChanceBeginMusic');
		end
	end

    -- Toggle Last Chance on if it isn't already
    if (self.lastChanceIsActive == false) then
        self.lastChanceIsActive = true;
        -- Pause the Last Chance timer (our time buffer for the LC state)
        if (self.lastChanceTimer ~= nil) then
			Timer_Stop(self.lastChanceTimer);
			-- Reset timer in addition to pausing it, if the config is enabled.
			if (self.CONFIG.resettingLastChanceTimer == true) then
				Timer_SetSecondsLeft(self.lastChanceTimer, self.CONST.lastChanceDurationSeconds);
			end
		end

		-- Apply respawn penalty for Last Chance phase 
		if (self.lastChanceRespawnPenaltySeconds > 0 and self.lastChanceRespawnPenalty == nil) then
			self.lastChanceRespawnPenalty = RespawnPenalty_AddPenalty(self.lastChanceRespawnPenaltySeconds);
		end

		Objective_SetEnabled(self.lastChanceStateObjective, true);
        
        self:TriggerEvent(self.EVENTS.onLastChanceActivated);
        self:TriggerLastChanceBeginMPLuaResponse();
    end
end

function GameModeManagerParcel:TriggerLastChanceBeginMPLuaResponse():void
	if (self.lastChanceBeginResponseOverrideFunc ~= nil) then
		self.lastChanceBeginResponseOverrideFunc(self.gameModeParcelReference);
	else
		if (self.lastChanceSoundHasPlayed == false) then
			self.lastChanceSoundHasPlayed = true;
			MPLuaCall('__OnGenericLastChance');
		end
	end
end

function GameModeManagerParcel:DisableLastChance():void
	-- No need to run Disable logic if we never enabled in the first place
	if (self.lastChanceEverActive) then
		if (self.lastChanceIsActive == true) then
			self.lastChanceIsActive = false;

			self:TriggerEvent(self.EVENTS.onLastChanceDeactivated);
			self:TriggerLastChanceEndMPLuaResponse();

			-- Re-start the Last Chance buffer timer if we're using one
			if (self.lastChanceTimer ~= nil) then
				Timer_StartWithRate(self.lastChanceTimer, self.CONFIG.lastChanceTimerRate);
			end
		end
	end
end

function GameModeManagerParcel:TriggerLastChanceEndMPLuaResponse():void
	if (self.lastChanceEndResponseOverrideFunc ~= nil) then
		self.lastChanceEndResponseOverrideFunc(self.gameModeParcelReference);
	else
		MPLuaCall("__OnGenericLastChanceEnd");
	end
end


--
-- HELPERS
--

function returnFalse(unused:table):boolean
	return false;
end

function GameModeManagerParcel:IsRoundInExtraTime():boolean
	if ((self.currentRoundState == self.CONST.roundStates.Overtime) and (Engine_GetCurrentRoundIsOvertimeRound() == false)) then
		return true;
	end
	return false;
end

-- returns nil if the game is tied
function GameModeManagerParcel:GetWinningTeam():mp_team
	local bestScore:number = nil;
	local winningTeam:mp_team = nil;

	local teamCountWithScore:table = {};
	for _, team in hpairs(TEAMS.active) do
		local teamScore:number = Team_GetScore(team);
		teamCountWithScore[teamScore] = (teamCountWithScore[teamScore] or 0) + 1;

		if (bestScore == nil or teamScore > bestScore) then
			winningTeam = team;
			bestScore = teamScore;
		end
	end

	if (teamCountWithScore[bestScore] > 1) then
		return nil;
	end
	return winningTeam;
end

function GameModeManagerParcel:TopTwoAreWithinPointDelta(pointDelta:number):boolean
	local scores:table = {};
	if (self.CONST.teamScoringEnabled) then
		for _, team in hpairs(TEAMS.active) do
			table.insert(scores, Team_GetScore(team));
		end
	else
		for _, player in hpairs(PLAYERS.active) do
			table.insert(scores, Player_GetScore(player));
		end
	end

	if (#scores <= 1) then
		return false;
	end

	table.sort(scores, DescendingNumericalOrderPred);
	return (scores[2] + pointDelta) >= scores[1];
end

function GameModeManagerParcel:ScoreToWinMet():boolean
	return Engine_AnyCurrentRoundScoreIsGreaterThan(self:GetCurrentScoreToWinRound() - 1);
end

function GameModeManagerParcel:LastChanceEnabledForCurrentGameModeState():boolean
	-- This can mean either OT Bonus Round or Time Extension (in both cases, self.CONST.overtimeDurationSeconds is the applicable duration)
	if (self.currentRoundState == self.CONST.roundStates.Overtime) then
		return self.CONST.lastChanceEnabledForOvertime and
			(self.CONST.overtimeDurationSeconds ~= self.CONST.k_roundTimeLimitUnlimited or self.CONFIG.lastChanceAllowedWithUnlimitedRoundTimer == true);
	
	elseif (self.currentRoundState == self.CONST.roundStates.RegulationTime) then
		return self.CONST.lastChanceEnabledForRegulation and
			(Variant_GetRoundTimeLimitSeconds() ~= self.CONST.k_roundTimeLimitUnlimited or self.CONFIG.lastChanceAllowedWithUnlimitedRoundTimer == true);
	end
	
	return false;
end

function GameModeManagerParcel:GetRoundSideSwitchingEnabledForRoundIndex(roundIndex:number):boolean
	if (self.CONST.roundSideSwitchingEnabled and (not self.roundSideSwitchingForceDisabled)) then
		-- Spawns are flipped on odd-numbered rounds (unless we have an overriding behavior)
		if (self.CONST.halftimeSwitchRoundThreshold ~= nil) then
			return ((roundIndex + 1) >= self.CONST.halftimeSwitchRoundThreshold);
		else
			return (roundIndex % 2 == 1);
		end
	end

	return false;
end

function GameModeManagerParcel:GetCurrentRoundTimeLimitSeconds():number
	local roundTimeLimit:number = nil;

	if (editor_mode()) then
		roundTimeLimit = self.CONST.k_defaultRoundTimeLimitFaber;
	elseif (Engine_GetCurrentRoundIsOvertimeRound()) then
		roundTimeLimit = self.CONST.overtimeDurationSeconds;
	else
		-- Otherwise just use the time limit specified by the variant
		-- NOTE: We are polling this every time it's asked for because this paramater can be overridden at runtime!
		roundTimeLimit = Variant_GetRoundTimeLimitSeconds();
	end

	assert(roundTimeLimit >= 0, "Error: a negative RoundTimeLimit was specified by the game variant!");
	return roundTimeLimit;
end

-- Returns the timer rate that should be used for the given round time limit (counts up for time-unlimited rounds)
function GameModeManagerParcel:GetStandardRoundTimerRateForTimeLimit(roundTimeLimitSec:number):number
	if (roundTimeLimitSec == self.CONST.k_roundTimeLimitUnlimited) then
		return -1.0;
	end

	return 1.0;
end

function GameModeManagerParcel:GetCurrentScoreToWinRound():number
	-- In Faber there's no variant, so we'll just return unlimited score
	if (editor_mode()) then
		return self.CONST.k_scoreToWinRoundUnlimited;
	end


	-- Otherwise just use the score to win specified by the variant
	-- NOTE: We are polling this every time it's asked for because this paramater can be overridden at runtime!
	local scoreToWinRound:number = Variant_GetScoreToWinRound();
	assert(scoreToWinRound >= 0, "Error: a negative ScoreToWinRound was specified by the game variant!");

	return scoreToWinRound;
end

--
-- EXTERNAL CALLS
--

function GameModeManagerParcel:SetPrimaryRoundTimerActive(desiredActive:boolean):void
	if (self.pausablePrimaryTimer ~= nil) then
		assert(self.pausablePrimaryTimerUnpauseRate ~= nil, "Attempted to call GameModeManagerParcel:SetPrimaryRoundTimerActive() when self.pausablePrimaryTimerUnpauseRate was nil!");

		if (desiredActive) then
			Timer_StartWithRate(self.pausablePrimaryTimer, self.pausablePrimaryTimerUnpauseRate);
		else
			Timer_Stop(self.pausablePrimaryTimer);
		end
	else
		self:DebugPrint("Warning: attempted to call GameModeManagerParcel:SetPrimaryRoundTimerActive when self.pausablePrimaryTimer was nil!");
	end
end

function GameModeManagerParcel:SetOverrideRoundTimeLimit(roundIndex:number, overrideRoundTimeLimitSeconds:number):void
	-- Validate inputs
	assert(roundIndex >= 0, "Error: invalid roundIndex (" .. tostring(roundIndex) .. ") supplied to GameModeManagerParcel:SetOverrideRoundTimeLimit()");
	assert(overrideRoundTimeLimitSeconds >= 0, "Error: invalid overrideRoundTimeLimitSeconds (" .. tostring(overrideRoundTimeLimitSeconds) .. ") supplied to GameModeManagerParcel:SetOverrideRoundTimeLimit()");

	-- Return out in the case of bad inputs for release builds
	if (roundIndex < 0 or overrideRoundTimeLimitSeconds < 0) then
		return;
	end

	-- Set override; if the override is for the current round, then set that override now, otherwise we'll set it at the beginning of each round
	self.overrideRoundTimeLimits[roundIndex] = overrideRoundTimeLimitSeconds;
	if (roundIndex == Engine_GetRoundIndex()) then
		VariantOverrides_SetRoundTimeLimit(overrideRoundTimeLimitSeconds);
	end
end

function GameModeManagerParcel:SetOverrideScoreToWinRound(roundIndex:number, overrideScoreToWinRound:number):void
	-- Validate inputs
	assert(roundIndex >= 0, "Error: invalid roundIndex (" .. tostring(roundIndex) .. ") supplied to GameModeManagerParcel:SetOverrideScoreToWinRound()");
	assert(overrideScoreToWinRound >= 0, "Error: invalid overrideScoreToWinRound (" .. tostring(overrideScoreToWinRound) .. ") supplied to GameModeManagerParcel:SetOverrideScoreToWinRound()");

	-- Return out in the case of bad inputs for release builds
	if (roundIndex < 0 or overrideScoreToWinRound < 0) then
		return;
	end

	-- Set override; if the override is for the current round, then set that override now, otherwise we'll set it at the beginning of each round
	self.overrideScoresToWinRound[roundIndex] = overrideScoreToWinRound;
	if (roundIndex == Engine_GetRoundIndex()) then
		VariantOverrides_SetScoreToWinRound(overrideScoreToWinRound);
	end
end

function GameModeManagerParcel:SetOverrideSecondsRemainingEvents(secondsRemainingEvents:table)
	for _, seconds in ipairs(secondsRemainingEvents) do
		assert(type(seconds) == "number");
	end

	self.overrideSecondsRemainingEvents = secondsRemainingEvents;
end

function GameModeManagerParcel:OverrideResettingLastChanceTimer(useResettingTimer:boolean):void
	self.CONFIG.resettingLastChanceTimer = useResettingTimer;
end

function GameModeManagerParcel:OverrideLastChanceTimerRate(timerRate:number):void
    self.CONFIG.lastChanceTimerRate = timerRate;
	if (self.lastChanceTimer ~= nil and Timer_IsCountingDown(self.lastChanceTimer)) then
		Timer_Stop(self.lastChanceTimer);
		Timer_StartWithRate(self.lastChanceTimer, self.CONFIG.lastChanceTimerRate);
	end
end

-- The param "secondsRemainingEventThreshold" should be e.g. (30) for the thirty seconds remaining event
-- The param "eventPredicate" should be a function (accepting no explicit params) that returns a bool, which can be invoked
--		when X seconds are remaining to determine if the event should be fired or not.
--		*NOTE*   the : function definition notation is acceptable if the owning parcel is set up to call RegisterModeManagerInitArgs on initialization.
function GameModeManagerParcel:SetPredicateForSecondsRemainingEvent(secondsRemainingEventThreshold:number, eventPredicate:ifunction):void
	self.secondsRemainingPredicates[secondsRemainingEventThreshold] = eventPredicate;
end

function GameModeManagerParcel:ForceDisableRoundSideSwitching():void
	self.roundSideSwitchingForceDisabled = true;
end

-- This is intended to be called from exterior parcels, to notify the Mode Manager that LastChance should be ended
function GameModeManagerParcel:LastChanceEndingEventOccurred()
	-- If SD has already been activated, then we should Dispose it for good; otherwise, make sure that we clear
	-- SD eligibility that may have been satisfied during the lastChanceTriggerWindow
	if (self.lastChanceEverActive == true) then
		self:DebugPrint("LastChanceEndingEventOccurred called when self.lastChanceEverActive was true!  Disposing last chance..");
		self:DisposeLastChance();
	else
		self:DebugPrint("LastChanceEndingEventOccurred called when self.shouldTriggerLastChance was", self.shouldTriggerLastChance, "!  Explicitly setting it to false..");
		self.shouldTriggerLastChance = false;
	end
end

function GameModeManagerParcel:GetLastChanceIsEverActive():boolean
	return (self.lastChanceEverActive == true);
end

function GameModeManagerParcel:GetExtraTimeIsEverActive():boolean
	return (self.extraTimeEverActive == true);
end

function GameModeManagerParcel:GetRoundTimedOut():boolean
	return (self.roundTimedOut == true);
end

function GameModeManagerParcel:ShouldTriggerLastChance():boolean
	return (self.shouldTriggerLastChance == true);
end

function GameModeManagerParcel:IsRoundIntroComplete():boolean
	return Multiplayer_IsRoundIntroComplete();
end

function GameModeManagerParcel:RegisterModeManagerInitArgs(modeManagerInitArgs:GameModeManagerInitArgs):void
	-- GameModeManagerInitArgs.gameModeParcelReference
	self.gameModeParcelReference = modeManagerInitArgs.gameModeParcelReference;
	assert(self.gameModeParcelReference ~= nil, "Error: the gameModeParcelReference field was nil in the supplied GameModeManagerInitArgs!");

	-- GameModeManagerInitArgs.lastChancePredicateFunc
	self.lastChancePredicateFunction = modeManagerInitArgs.lastChancePredicateFunc;
	if self.CONST.lastChanceEnabledForRegulation then
		debug_assert(self.lastChancePredicateFunction ~= nil,
			"Error: Last Chance was enabled for regulation, but the lastChancePredicateFunc field was nil in the supplied GameModeManagerInitArgs!");
	end

	-- GameModeManagerInitArgs.overtimeLastChancePredicateFunc
	self.overtimeOverrideLastChancePredicateFunc = modeManagerInitArgs.overtimeLastChancePredicateFunc;
	if self.CONST.lastChanceEnabledForOvertime then
		debug_assert(self.lastChancePredicateFunction ~= nil or self.overtimeOverrideLastChancePredicateFunc ~= nil,
			"Error: Last Chance was enabled for Overtime, but both the lastChancePredicateFunc and overtimeLastChancePredicateFunc fields were nil in the supplied GameModeManagerInitArgs!");
	end

	-- GameModeManagerInitArgs.lastChanceBeginResponseOverrideFunc / lastChanceEndResponseOverrideFunc
	self.lastChanceBeginResponseOverrideFunc = modeManagerInitArgs.lastChanceBeginResponseOverrideFunc;
	self.lastChanceEndResponseOverrideFunc = modeManagerInitArgs.lastChanceEndResponseOverrideFunc;

	-- GameModeManagerInitArgs.lastChanceRespawnPenaltySeconds
	self.lastChanceRespawnPenaltySeconds = modeManagerInitArgs.lastChanceRespawnPenaltySeconds or 0;

	-- GameModeManagerInitArgs.shouldTriggerOTRoundOverridePredicateFunc
	self.shouldTriggerOTRoundOverridePredicateFunc = modeManagerInitArgs.shouldTriggerOTRoundOverridePredicateFunc;

	-- GameModeManagerInitArgs.shouldEndGameOnRoundEndPredicateFunc
	self.shouldEndGameOnRoundEndPredicateFunc = modeManagerInitArgs.shouldEndGameOnRoundEndPredicateFunc;

	-- GameModeManagerInitArgs.overtimeVictoryConditionsMetPredicateFunc
	self.overtimeVictoryConditionsMetPredicateFunc = modeManagerInitArgs.overtimeVictoryConditionsMetPredicateFunc;
end

function GameModeManagerParcel:ClearModeManagerInitArgs():void
	self.gameModeParcelReference = nil;
	self.lastChancePredicateFunction = nil;
	self.overtimeOverrideLastChancePredicateFunc = nil;
	self.lastChanceBeginResponseOverrideFunc = nil;
	self.lastChanceEndResponseOverrideFunc = nil;
	self.shouldTriggerOTRoundOverridePredicateFunc = nil;
	self.shouldEndGameOnRoundEndPredicateFunc = nil;
	self.overtimeVictoryConditionsMetPredicateFunc = nil;
end

function GameModeManagerParcel:SetWinnerRoundEndReasonStringId(value:string_id):void
	NetworkedProperty_SetStringIdProperty(self.winnerRoundResultsNP, value);
end

function GameModeManagerParcel:SetLoserRoundEndReasonStringId(value:string_id):void
	NetworkedProperty_SetStringIdProperty(self.loserRoundResultsNP, value);
end

function GameModeManagerParcel:SetTieRoundEndReasonStringId(value:string_id):void
	NetworkedProperty_SetStringIdProperty(self.tieRoundResultsNP, value);
end

--
-- Event Interface
--

-- OnLastChanceActivated
function GameModeManagerParcel:AddLastOnChanceActivatedCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onLastChanceActivated, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnLastChanceActivatedCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onLastChanceActivated, callbackFunc, callbackOwner);
end

-- OnLastChanceDeactivated
function GameModeManagerParcel:AddOnLastChanceDeactivatedCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onLastChanceDeactivated, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnLastChanceDeactivatedCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onLastChanceDeactivated, callbackFunc, callbackOwner);
end

-- OnRegulationRoundTimeExpired
function GameModeManagerParcel:AddOnRegulationRoundTimeExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onRegulationRoundTimeExpired, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnRegulationRoundTimeExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onRegulationRoundTimeExpired, callbackFunc, callbackOwner);
end

-- OnOvertimeRoundTimeExpired
function GameModeManagerParcel:AddOnOvertimeRoundTimeExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onOvertimeRoundTimeExpired, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnOvertimeRoundTimeExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onOvertimeRoundTimeExpired, callbackFunc, callbackOwner);
end

-- OnOvertimeTimeExtensionExpired
function GameModeManagerParcel:AddOnOvertimeTimeExtensionExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onOvertimeTimeExtensionExpired, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnOvertimeTimeExtensionExpiredCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onOvertimeTimeExtensionExpired, callbackFunc, callbackOwner);
end

-- OnRoundEndingDueToTimeExpired
function GameModeManagerParcel:AddOnRoundEndingDueToTimeExpired(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onRoundEndingDueToTimeExpired, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnRoundEndingDueToTimeExpired(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onRoundEndingDueToTimeExpired, callbackFunc, callbackOwner);
end

-- OnThirtySecondsRemaining
function GameModeManagerParcel:AddOnThirtySecondsRemainingCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onThirtySecondsRemaining, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnThirtySecondsRemainingCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onThirtySecondsRemaining, callbackFunc, callbackOwner);
end

-- OnSixtySecondsRemaining
function GameModeManagerParcel:AddOnSixtySecondsRemainingCallback(callbackOwner, callbackFunc:ifunction):void
	self:RegisterCallback(self.EVENTS.onSixtySecondsRemaining, callbackFunc, callbackOwner);
end

function GameModeManagerParcel:RemoveOnSixtySecondsRemainingCallback(callbackOwner, callbackFunc:ifunction):void
	self:UnregisterCallback(self.EVENTS.onSixtySecondsRemaining, callbackFunc, callbackOwner);
end


--
-- Debug
--

function GameModeManagerParcel:DebugPrint(...):void
	if (self.CONFIG.enableDebugPrint) then
		print(self.instanceName .. ":", ...);
	end	
end

function GameModeManagerParcel:EnableDebugPrint(enable:boolean):void
	self.CONFIG.enableDebugPrint = enable;
end

