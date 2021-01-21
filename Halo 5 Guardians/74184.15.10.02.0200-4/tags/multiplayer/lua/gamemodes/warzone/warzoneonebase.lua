
--
-- Shield doors up/down events
--

__OnShieldDoorsDown = Delegate:new();

onShieldDoorsDown = root:AddCallback(
	__OnShieldDoorsDown,
	function(context, controllingTeamDesignator)
		context.Designator = controllingTeamDesignator;
	end
	);

onEnemyShieldDoorsDown = onShieldDoorsDown:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_enemy_shield_doors_down',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemycorevulnerable'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shielddown_pos_onebase',
	});

onFriendlyShieldDoorsDown = onShieldDoorsDown:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_friendly_shield_doors_down',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_powercorevulnerable'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shielddown_neg_onebase',
	});


--
-- Time Extended (One Base)
--
__OnTimeAddedToRound = Delegate:new();

onTimeAddedToRound = root:AddCallback(
	__OnTimeAddedToRound,
	function(context, teamDesignator, secondsAdded)
		context.Designator = teamDesignator;		
		context.secondsAdded = secondsAdded;
	end
	);

onTimeAddedToRoundResponse = onTimeAddedToRound:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = "onebase_time_added",
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearctimeaddatt'
	});

onTimeAddedToRoundResponseHostile = onTimeAddedToRound:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = "onebase_time_added",
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearctimeadddef'
	});


--
-- Time Reset (One Base))
--

__OnTimeReset = Delegate:new();

onTimeReset = root:AddCallback(
	__OnTimeReset,
	function(context, teamDesignator)
		context.Designator = teamDesignator;
	end
	);

onTimeResetResponseAtt = onTimeReset:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = "onebase_time_added",
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasetimeaddatt2'
	});


onTimeResetResponseDef = onTimeReset:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = "onebase_time_added",
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasetimeaddatt2'
	});


--
-- Match End
--

__OnWarzoneMatchEnd = Delegate:new();

onWarzoneMatchEnd = root:AddCallback(
	__OnWarzoneMatchEnd
	);

warzoneMatchOverWinnersResponse = onWarzoneMatchEnd:Target(WinnersTarget):Response(
	{
		--Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gameovervictory2'
	});
	
warzoneMatchOverLosersResponse = onWarzoneMatchEnd:Target(LosersTarget):Response(
	{
		--Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gameoverdefeat2'
	});

warzoneMatchOverTiedResponse = onWarzoneMatchEnd:Target(TiedTarget):Response(
	{
		--Sound = 'multiplayer\audio\announcer\announcer_shared_gameover'
	});

--Core has NOT been destroyed and time has NOT run out = one whole team has quit
wholeTeamQuits = onWarzoneMatchEnd:Filter(
	function(context)
		return context.Engine:GetBasesCaptured() < 3 and context.Engine:GetTimeHasExpired() ~= true
	end
	);

wholeTeamQuitsResponse = wholeTeamQuits:Target(WinnersTarget):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win',
	OutOfGameEvent = true
});


--
-- Time remaining
--

timeRemaining = onUpdate:Filter(
	function (context)
		return context.Engine:InRound() and
			(context.Engine:IsRoundTimerCountingDown() or context.Engine:IsOvertimeTimerCountingDown());
	end
	):Emit(
	function (context)
		if context.Engine:IsRoundTimerCountingDown() then
			context.TimeRemaining = context.Engine:GetRoundTimeRemaining();
		else
			context.TimeRemaining = context.Engine:GetOvertimeTimeRemaining();
		end
	end	
	);

--
-- 5 minutes remaining
--

fiveMinutesRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 300; 
	end
	);
	
fiveMinutesRemainingWinningResponse = fiveMinutesRemaining:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timefiveminutesremaining'
	});

fiveMinutesRemainingNeutralResponse = fiveMinutesRemaining:Target(NotWinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timefiveminutesremaining'
	});
	
--
-- 2 minutes remaining
--

twoMinutesRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 120; 
	end
	);
	
twoMinutesRemainingWinningResponse = twoMinutesRemaining:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timetwominutesremaining'
	});

twoMinutesRemainingNeutralResponse = twoMinutesRemaining:Target(NotWinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timetwominutesremaining'
	});
		
--
-- 60 seconds remaining
--

sixtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 60; 
	end
	);

sixtySecondsRemainWinningResponse = sixtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_sixtysecondsremaining_onebase_loop'
	});
	
sixtySecondsRemainLosersResponse = sixtySecondsRemaining:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_sixtysecondsremaining_onebase_loop'
	});

sixtySecondsRemainTiedResponse = sixtySecondsRemaining:Target(TiedTarget):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_sixtysecondsremaining_onebase_loop'
	});
	


sixtySecondsRemainingSelect = sixtySecondsRemaining:Select();

--time running out - capture a base
onSixtySecondsCaptureNeeded = sixtySecondsRemainingSelect:Add(
	function(context)
		return context.Engine:GetBasesCaptured() <= 1;
	end
	);


onSixtySecondsCaptureNeededResponseAtt = onSixtySecondsCaptureNeeded:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseminuteremainingbaseatt'
	});

onSixtySecondsCaptureNeededResponseDef = onSixtySecondsCaptureNeeded:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseminuteremainingbasedef'
	});

--time running out - destroy the core
onSixtySecondsCoreNeeded = sixtySecondsRemainingSelect:Add(
	function(context)
		return context.Engine:GetBasesCaptured() == 2;
	end
	);

onSixtySecondsCoreNeededResponseAtt = onSixtySecondsCoreNeeded:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseminuteremainingcoreatt'
	});

onSixtySecondsCoreNeededResponseDef = onSixtySecondsCoreNeeded:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseminuteremainingcoredef'
	});

--
-- 30 seconds remaining
--

thirtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining < 30;
	end
	);

thirtySecondsRemainWinningResponse = thirtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time30secondsleft'
	});

thirtySecondsRemainLosersResponse = thirtySecondsRemaining:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time30secondsleft'
	});

thirtySecondsRemainTiedResponse = thirtySecondsRemaining:Target(TiedTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time30secondsleft'
	});
	
--
-- 10 seconds remaining
--

tenSecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining < 10;
	end
	);

tenSecondsRemainWinningResponse = tenSecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time10secondsleft'
	});



--
-- Bases Nearing Capture
--

__OnBaseNearingCapture = Delegate:new()

onBaseNearingCapture = root:AddCallback(
	__OnBaseNearingCapture,
	function(context, baseName)
		context.BaseName = baseName;
	end
	);

BaseNearingCaptureSelect = onBaseNearingCapture:Select();

-- Arc Bases Nearing Capture
onArcGarageNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('arc_onebase_garage'));
onArcArmoryNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('arc_onebase_armory'));

onArcGargeNearingCaptureResponseAtt = onArcGarageNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_garage_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneargarageatt'
	});

onArcGargeNearingCaptureResponseDef = onArcGarageNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_garage_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneargaragedef'
	});

onArcArmoryNearingCaptureResponseAtt = onArcArmoryNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmoryatt'
	});

onArcArmoryNearingCaptureResponseDef = onArcArmoryNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmorydef'
	});

-- Ring Bases Nearing Capture
onRingSpireNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('ring_onebase_fortress'));
onRingArmoryNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('ring_onebase_armory'));

onRingSpireNearingCaptureResponseAtt = onRingSpireNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_spire_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecapturenearspireatt'
	});

onRingSpireNearingCaptureResponseDef = onRingSpireNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_spire_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecapturenearspiredef'
	});

onRingArmoryNearingCaptureResponseAtt = onRingArmoryNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmoryatt'
	});

onRingArmoryNearingCaptureResponseDef = onRingArmoryNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmorydef'
	});

onUrbanGarageNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('urban_onebase_garage'));
onUrbanArmoryNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('urban_onebase_armory'));

onUrbanGarageNearingCaptureResponseAtt = onUrbanGarageNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_garage_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneargarageatt'
	});

onUrbanGarageNearingCaptureResponseDef = onUrbanGarageNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_garage_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneargaragedef'
	});

onUrbanArmoryNearingCaptureResponseAtt = onUrbanArmoryNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmoryatt'
	});

onUrbanArmoryNearingCaptureResponseDef = onUrbanArmoryNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmorydef'
	});


onSnowFortressNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('snowzone_onebase_fortress'));
onSnowArmoryNearingCapture = BaseNearingCaptureSelect:Add(BaseIsNamed('snowzone_oneBase_armory'));

onSnowFortressNearingCaptureResponseAtt = onSnowFortressNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_fortress_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecapturenearfortressatt'
	});

onSnowFortressNearingCaptureResponseDef = onSnowFortressNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_fortress_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecapturenearfortressdef'
	});

onSnowArmoryNearingCaptureResponseAtt = onSnowArmoryNearingCapture:Target(PlayersOnAttackingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmoryatt'
	});

onSnowArmoryNearingCaptureResponseDef = onSnowArmoryNearingCapture:Target(PlayersOnDefendingTeam):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'onebase_armory_nearing_capture',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasecaptureneararmorydef'
	});



--
-- Win States For Defenders
--

__OnDefendersWin = Delegate:new()

onDefendersWin = root:AddCallback(
	__OnDefendersWin,
	function(context, totalBasesCapturedByAttackers)
		context.TotalBasesCapturedByAttackers = totalBasesCapturedByAttackers;
	end
	);

DefendersWinSelect = onDefendersWin:Select();


-- attackers held at first base
onNoBasesCaptured = DefendersWinSelect:Add(
	function(context)
		return context.TotalBasesCapturedByAttackers == 0;
	end
	);

noBasesCapturedResponseAtt = onNoBasesCaptured:Target(PlayersOnAttackingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewinperfectatt',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose',
	OutOfGameEvent = true
});


noBasesCapturedResponseDef = onNoBasesCaptured:Target(PlayersOnDefendingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewinperfectdef',
	ImpulseEvent = 'impulse_assault_defense_shutout',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win',
	OutOfGameEvent = true
});


-- attackers held at second base
onSingleBaseCaptured = DefendersWinSelect:Add(
	function(context)
		return context.TotalBasesCapturedByAttackers == 1;
	end
	);

singleBaseCapturedResponseAtt = onSingleBaseCaptured:Target(PlayersOnAttackingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewinsingleatt',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose',
	OutOfGameEvent = true
});


singleBaseCapturedResponseDef = onSingleBaseCaptured:Target(PlayersOnDefendingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewinsingledef',
	ImpulseEvent = 'impulse_assault_defense_win',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win',
	OutOfGameEvent = true
});


-- attackers held at core
onDoubleBaseCaptured = DefendersWinSelect:Add(
	function(context)
		return context.TotalBasesCapturedByAttackers == 2;
	end
	);

doubleBaseCapturedResponseAtt = onDoubleBaseCaptured:Target(PlayersOnAttackingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewinatt',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win',
	OutOfGameEvent = true
});


doubleBaseCapturedResponseDef = onDoubleBaseCaptured:Target(PlayersOnDefendingTeam):Response(
{
	Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewindef',
	ImpulseEvent = 'impulse_assault_defense_win',
	OutOfGameEvent = true
}):Response(
{
	Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_lose',
	OutOfGameEvent = true
});


--
-- Core Destroyed
--

__OnAllBaseCoresDestroyed = Delegate:new();

onAllBaseCoresDestroyed = root:AddCallback(
	__OnAllBaseCoresDestroyed,
	function(context, designator, baseDestroyVpReward)
		context.Designator = designator;
		context.BaseDestroyVpReward = baseDestroyVpReward;
	end
	);

--Friendly Core Destroyed	
allBaseCoresDestroyedFriendly = onAllBaseCoresDestroyed:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'warzone_core_destroyed_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemydestroypowercoresection',
		TeamDesignator = DesignatorProperty
	}):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_core_destroyed_friendly',
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose'
	});

--Enemy Core Destroyed
allBaseCoresDestroyedHostile = onAllBaseCoresDestroyed:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'warzone_core_destroyed_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_friendlydestroypowercoresection',
		ImpulseEvent = 'impulse_core_destroyed',
		TeamDesignator = DesignatorProperty
	}):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_core_destroyed_hostile',
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
	});
