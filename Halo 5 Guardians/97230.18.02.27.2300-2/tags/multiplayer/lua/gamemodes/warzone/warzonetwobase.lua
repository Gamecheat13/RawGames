
__OnInitialAssaultCompleted = Delegate:new();
onInitialAssaultCompleted = root:AddCallback(
	__OnInitialAssaultCompleted,
	function(context, teamDesignator)
		context.Designator = teamDesignator;		
	end
	);
onInitialAssaultCompletedResponse = onInitialAssaultCompleted:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialbaseassaultcompleted6'
	});
__OnQuestProgressKillGrunt = Delegate:new();
onQuestProgressKillGrunt = root:AddCallback(
	__OnQuestProgressKillGrunt,
	QuestProgressEmit
	);
killGruntQuestProgress = onQuestProgressKillGrunt:Target(TargetPlayer):Response(
	{
		Medal = 'grunt_kill',
		PersonalScore = 5,
	});
__OnQuestProgressKillWatcher = Delegate:new();
onQuestProgressKillWatcher = root:AddCallback(
	__OnQuestProgressKillWatcher,
	QuestProgressEmit
	);
killWatcherQuestProgress = onQuestProgressKillWatcher:Target(TargetPlayer):Response(
	{
		Medal = 'watcher_kill',
		PersonalScore = 5,
	});
-- 
__OnQuestProgressKillJackal = Delegate:new();
onQuestProgressKillJackal = root:AddCallback(
	__OnQuestProgressKillJackal,
	QuestProgressEmit
	);
killJackalQuestProgress = onQuestProgressKillJackal:Target(TargetPlayer):Response(
	{
		Medal = 'jackal_kill',
		PersonalScore = 5,
	});
__OnQuestProgressKillElite = Delegate:new();
onQuestProgressKillElite = root:AddCallback(
	__OnQuestProgressKillElite,
	QuestProgressEmit
	);
killEliteQuestProgress = onQuestProgressKillElite:Target(TargetPlayer):Response(
	{
		Medal = 'elite_kill',
		PersonalScore = 10,
	});
__OnQuestProgressAssistKillElites = Delegate:new();
onQuestProgressAssistKillElites = root:AddCallback(
	__OnQuestProgressAssistKillElites,
	QuestProgressEmit
	);
assistKillEliteQuestProgressResponse = onQuestProgressAssistKillElites:Target(TargetPlayer):Response(
	{
		Medal = 'elite_assist',
		PersonalScore = 5,
	});
__OnQuestProgressKillHunter = Delegate:new();
onQuestProgressKillHunter = root:AddCallback(
	__OnQuestProgressKillHunter,
	QuestProgressEmit
	);
killHunterQuestProgress = onQuestProgressKillHunter:Target(TargetPlayer):Response(
	{
		Medal = 'hunter_kill',
		PersonalScore = 50,
	});
__OnQuestProgressAssistKillHunter = Delegate:new();
onQuestProgressAssistKillHunter = root:AddCallback(
	__OnQuestProgressAssistKillHunter,
	QuestProgressEmit
	);
assistKillHunterQuestProgressResponse = onQuestProgressAssistKillHunter:Target(TargetPlayer):Response(
	{
		Medal = 'hunter_assist',
		PersonalScore = 25,
	});
__OnQuestProgressKillCrawler = Delegate:new();
onQuestProgressKillCrawler = root:AddCallback(
	__OnQuestProgressKillCrawler,
	QuestProgressEmit
	);
killCrawlerQuestProgress = onQuestProgressKillCrawler:Target(TargetPlayer):Response(
	{
		Medal = 'crawler_kill',
		PersonalScore = 5,
	});
__OnQuestProgressKillSoldier = Delegate:new();
onQuestProgressKillSoldier = root:AddCallback(
	__OnQuestProgressKillSoldier,
	QuestProgressEmit
	);
killSoldierQuestProgress = onQuestProgressKillSoldier:Target(TargetPlayer):Response(
	{
		Medal = 'soldier_kill',
		PersonalScore = 10,
	});
__OnQuestProgressAssistKillSoldier = Delegate:new();
onQuestProgressAssistKillSoldier = root:AddCallback(
	__OnQuestProgressAssistKillSoldier,
	QuestProgressEmit
	);
assistKillSoldierQuestProgressResponse = onQuestProgressAssistKillSoldier:Target(TargetPlayer):Response(
	{
		Medal = 'soldier_assist',
		PersonalScore = 5,
	});
__OnQuestProgressKillKnight = Delegate:new();
onQuestProgressKillKnight = root:AddCallback(
	__OnQuestProgressKillKnight,
	QuestProgressEmit
	);
killKnightQuestProgress = onQuestProgressKillKnight:Target(TargetPlayer):Response(
	{
		Medal = 'knight_kill',
		PersonalScore = 50,
	});
__OnQuestProgressAssistKillKnight = Delegate:new();
onQuestProgressAssistKillKnight = root:AddCallback(
	__OnQuestProgressAssistKillKnight,
	QuestProgressEmit
	);
assistKillKnightQuestProgressResponse = onQuestProgressAssistKillKnight:Target(TargetPlayer):Response(
	{
		Medal = 'knight_assist',
		PersonalScore = 25,
	});
__OnQuestProgressKillWarden = Delegate:new();
onQuestProgressKillWarden = root:AddCallback(
	__OnQuestProgressKillWarden,
	QuestProgressEmit
	);
killWardenQuestProgress = onQuestProgressKillWarden:Target(TargetPlayer):Response(
	{
		Medal = 'warden_kill',
	});
__OnQuestProgressAssistKillWarden = Delegate:new();
onQuestProgressAssistKillWarden = root:AddCallback(
	__OnQuestProgressAssistKillWarden,
	QuestProgressEmit
	);
assistKillWardenQuestProgressResponse = onQuestProgressAssistKillWarden:Target(TargetPlayer):Response(
	{
		Medal = 'warden_assist',
	});
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
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_controlallbasesfriendlysustain'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shielddown_pos',
	});
onFriendlyShieldDoorsDown = onShieldDoorsDown:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_friendly_shield_doors_down',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_controlallbaseshostile'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shielddown_neg',
	});
__OnShieldDoorsUp = Delegate:new();
onShieldDoorsUp = root:AddCallback(
	__OnShieldDoorsUp,
	function(context, controllingTeamDesignator)
		context.Designator = controllingTeamDesignator;
	end
	);
onFriendlyShieldDoorsUp = onShieldDoorsUp:Target(PlayersWithDesignator):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_friendly_shield_doors_up',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_lostthirdbasehostile'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shieldloops_stop',
	});
onEnemyShieldDoorsUp = onShieldDoorsUp:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_enemy_shield_doors_up',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_lostthirdbasefriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_shieldloops_stop',
	});
--	
__OnWarzoneGainedLead = Delegate:new();
onWarzoneGainedLead = root:AddCallback(
	__OnWarzoneGainedLead,
	function(context, winningPlayers)
		context.WinningPlayers = winningPlayers;
	end
	);
onWarzoneGainedLeadFriendlyResponse = onWarzoneGainedLead:Target(WinningPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_gainedlead',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gainedlead'
	});
onWarzoneGainedLeadHostileResponse = onWarzoneGainedLead:Target(LosingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_lostlead',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_lostlead'
	});
__OnWarzoneHalfwayToVictory = Delegate:new();
onWarzoneHalfwayToVictory = root:AddCallback(
	__OnWarzoneHalfwayToVictory,
	function(context, winningPlayers)
		context.WinningPlayers = winningPlayers;
	end
	);
onWarzoneHalfwayToVictoryWinningResonse = onWarzoneHalfwayToVictory:Target(WinningPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_scoring_halfway_winning',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_halfwaytovictoryfriendly'
	});
onWarzoneHalfwayToVictoryLosingResponse = onWarzoneHalfwayToVictory:Target(LosingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_scoring_halfway_losing',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_halfwaytovictoryhostile'
	});
__OnWarzoneWinningTeamFourFifthsToVictory = Delegate:new();
onWarzoneWinningTeamFourFifthsToVictory = root:AddCallback(
	__OnWarzoneWinningTeamFourFifthsToVictory,
	function(context, winningPlayers)
		context.WinningPlayers = winningPlayers;
	end
	);
onWarzoneWinningTeamFourFifthsToVictoryWinning = onWarzoneWinningTeamFourFifthsToVictory:Target(WinningPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_scoring_nearing_winning',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_nearingvictorynoscore'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_nearingvictorygenericboss',
	});
onWarzoneWinningTeamFourFifthsToVictoryLosing = onWarzoneWinningTeamFourFifthsToVictory:Target(LosingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'warzone_scoring_nearing_losing',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemynearingvictorynoscore'
	});
nearingVictoryGapSelect = onWarzoneWinningTeamFourFifthsToVictory:Select();
nearingVictorySmallGap = nearingVictoryGapSelect:Add(SmallGap);
nearingVictoryMediumGap = nearingVictoryGapSelect:Add(MediumGap);
nearingVictoryLargeGap = nearingVictoryGapSelect:Add(LargeGap);
nearingVictorySmallGap:Target(WinningPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_contested_loop'
	});
nearingVictorySmallGap:Target(LosingPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_contested_loop'
	});
nearingVictoryMediumGap:Target(WinningPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_winning_loop'
	});
nearingVictoryMediumGap:Target(LosingPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_losing_loop'
	});
nearingVictoryLargeGap:Target(WinningPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_winning_loop'
	});
nearingVictoryLargeGap:Target(LosingPlayers):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_losing_loop'
	});
__OnWarzoneBothTeamsFourFifthsToVictory = Delegate:new();
onWarzoneBothTeamsFourFifthsToVictory = root:AddCallback(
	__OnWarzoneBothTeamsFourFifthsToVictory,
	function(context, winningPlayers)
		context.WinningPlayers = winningPlayers;
	end
	);
onWarzoneBothTeamsFourFifthsToVictoryWinning = onWarzoneBothTeamsFourFifthsToVictory:Target(WinningPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_contested_loop'
	});
onWarzoneBothTeamsFourFifthsToVictoryLosing = onWarzoneBothTeamsFourFifthsToVictory:Target(LosingPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_matchending_points_contested_loop'
	});
__OnWarzoneMatchEnd = Delegate:new();
onWarzoneMatchEnd = root:AddCallback(
	__OnWarzoneMatchEnd
	);
warzoneMatchOverWinnersResponse = onWarzoneMatchEnd:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gameovervictory2',
		ImpulseEvent = 'impulse_wz_point_victory',
		OutOfGameEvent = true
	});
warzoneMatchOverLosersResponse = onWarzoneMatchEnd:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gameoverdefeat2',
		OutOfGameEvent = true
	});
warzoneMatchOverTiedResponse = onWarzoneMatchEnd:Target(TiedTarget):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_gameoverdefeatpelican',
		OutOfGameEvent = true
	}):Response(
    {
        Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_win',
        OutOfGameEvent = true
    });
gameOverGapSelect = onWarzoneMatchEnd:Select();
gameOverSmallGap = gameOverGapSelect:Add(SmallGap);
gameOverMediumGap = gameOverGapSelect:Add(MediumGap);
gameOverLargeGap = gameOverGapSelect:Add(LargeGap);
gameOverSmallGap:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_win',
		OutOfGameEvent = true
	});
gameOverSmallGap:Target(LosersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_lose',
		OutOfGameEvent = true
	});
gameOverMediumGap:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_win',
		OutOfGameEvent = true
	});
gameOverMediumGap:Target(LosersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_lose',
		OutOfGameEvent = true
	});
gameOverLargeGap:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_win',
		OutOfGameEvent = true
	});
gameOverLargeGap:Target(LosersTarget):Response(	
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_matchover_lose',
		OutOfGameEvent = true
	});
__OnAllBaseCoresDestroyed = Delegate:new();
onAllBaseCoresDestroyed = root:AddCallback(
	__OnAllBaseCoresDestroyed,
	function(context, designator, baseDestroyVpReward)
		context.Designator = designator;
		context.BaseDestroyVpReward = baseDestroyVpReward;
	end
	);
allBaseCoresDestroyedFriendly = onAllBaseCoresDestroyed:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'warzone_core_destroyed_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemydestroypowercoresection',
		TeamDesignator = DesignatorProperty
	}):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_core_destroyed_hostile'
	});
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
		FanfareText = 'warzone_core_destroyed_friendly'
	});
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
