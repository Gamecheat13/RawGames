
__OnInitialAssaultCompleted = Delegate:new();
onInitialAssaultCompleted = root:AddCallback(
	__OnInitialAssaultCompleted,
	function(context, teamDesignator)
		context.Designator = teamDesignator;		
	end
	);
onInitialAssaultCompletedResponse = onInitialAssaultCompleted:Target(PlayersWithDesignator):Response(
	{
	});
__OnQuestProgressKillGrunt = Delegate:new();
onQuestProgressKillGrunt = root:AddCallback(
	__OnQuestProgressKillGrunt,
	QuestProgressEmit
	);
killGruntQuestProgress = onQuestProgressKillGrunt:Target(TargetPlayer):Response(
	{
		Medal = 'grunt_kill',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillWatcher = Delegate:new();
onQuestProgressKillWatcher = root:AddCallback(
	__OnQuestProgressKillWatcher,
	QuestProgressEmit
	);
killWatcherQuestProgress = onQuestProgressKillWatcher:Target(TargetPlayer):Response(
	{
		Medal = 'watcher_kill',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillJackal = Delegate:new();
onQuestProgressKillJackal = root:AddCallback(
	__OnQuestProgressKillJackal,
	QuestProgressEmit
	);
killJackalQuestProgress = onQuestProgressKillJackal:Target(TargetPlayer):Response(
	{
		Medal = 'jackal_kill',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillElite = Delegate:new();
onQuestProgressKillElite = root:AddCallback(
	__OnQuestProgressKillElite,
	QuestProgressEmit
	);
killEliteQuestProgress = onQuestProgressKillElite:Target(TargetPlayer):Response(
	{
		Medal = 'elite_kill',
		Score = GetScoreVal(100),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressAssistKillElites = Delegate:new();
onQuestProgressAssistKillElites = root:AddCallback(
	__OnQuestProgressAssistKillElites,
	QuestProgressEmit
	);
assistKillEliteQuestProgressResponse = onQuestProgressAssistKillElites:Target(TargetPlayer):Response(
	{
		Medal = 'elite_assist',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillHunter = Delegate:new();
onQuestProgressKillHunter = root:AddCallback(
	__OnQuestProgressKillHunter,
	QuestProgressEmit
	);
killHunterQuestProgress = onQuestProgressKillHunter:Target(TargetPlayer):Response(
	{
		Medal = 'hunter_kill',
		Score = GetScoreVal(200),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressAssistKillHunter = Delegate:new();
onQuestProgressAssistKillHunter = root:AddCallback(
	__OnQuestProgressAssistKillHunter,
	QuestProgressEmit
	);
assistKillHunterQuestProgressResponse = onQuestProgressAssistKillHunter:Target(TargetPlayer):Response(
	{
		Medal = 'hunter_assist',
		Score = GetScoreVal(100),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillCrawler = Delegate:new();
onQuestProgressKillCrawler = root:AddCallback(
	__OnQuestProgressKillCrawler,
	QuestProgressEmit
	);
killCrawlerQuestProgress = onQuestProgressKillCrawler:Target(TargetPlayer):Response(
	{
		Medal = 'crawler_kill',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillSoldier = Delegate:new();
onQuestProgressKillSoldier = root:AddCallback(
	__OnQuestProgressKillSoldier,
	QuestProgressEmit
	);
killSoldierQuestProgress = onQuestProgressKillSoldier:Target(TargetPlayer):Response(
	{
		Medal = 'soldier_kill',
		Score = GetScoreVal(100),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressAssistKillSoldier = Delegate:new();
onQuestProgressAssistKillSoldier = root:AddCallback(
	__OnQuestProgressAssistKillSoldier,
	QuestProgressEmit
	);
assistKillSoldierQuestProgressResponse = onQuestProgressAssistKillSoldier:Target(TargetPlayer):Response(
	{
		Medal = 'soldier_assist',
		Score = GetScoreVal(50),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillKnight = Delegate:new();
onQuestProgressKillKnight = root:AddCallback(
	__OnQuestProgressKillKnight,
	QuestProgressEmit
	);
killKnightQuestProgress = onQuestProgressKillKnight:Target(TargetPlayer):Response(
	{
		Medal = 'knight_kill',
		Score = GetScoreVal(200),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressAssistKillKnight = Delegate:new();
onQuestProgressAssistKillKnight = root:AddCallback(
	__OnQuestProgressAssistKillKnight,
	QuestProgressEmit
	);
assistKillKnightQuestProgressResponse = onQuestProgressAssistKillKnight:Target(TargetPlayer):Response(
	{
		Medal = 'knight_assist',
		Score = GetScoreVal(100),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressKillWarden = Delegate:new();
onQuestProgressKillWarden = root:AddCallback(
	__OnQuestProgressKillWarden,
	QuestProgressEmit
	);
killWardenQuestProgress = onQuestProgressKillWarden:Target(TargetPlayer):Response(
	{
		Medal = 'warden_kill',
		Score = GetScoreVal(500),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnQuestProgressAssistKillWarden = Delegate:new();
onQuestProgressAssistKillWarden = root:AddCallback(
	__OnQuestProgressAssistKillWarden,
	QuestProgressEmit
	);
assistKillWardenQuestProgressResponse = onQuestProgressAssistKillWarden:Target(TargetPlayer):Response(
	{
		Medal = 'warden_assist',
		Score = GetScoreVal(250),
		Fanfare = FanfareDefinitions.PersonalScore,
	});
__OnWarzoneMatchEnd = Delegate:new();
onWarzoneMatchEnd = root:AddCallback(
	__OnWarzoneMatchEnd
	);
warzoneMatchOverPlayersResponse = onWarzoneMatchEnd:Target(TargetAllPlayers):Response(
	{
		OutOfGameEvent = true
	});
__OnGenericPvERoundStart = Delegate:new();
onPvERoundStart = root:AddCallback(
	__OnGenericPvERoundStart,
		function (context, currentRound)
			context.CurrentRound = currentRound;
		end
	);
pveRoundStartResponse = onPvERoundStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_warzone_objective',
	}):Response(
	{
		CustomStat = CustomStats.PvERoundSpeedBonus,
		CustomStatSet = 0
	}):Response(
	{
		CustomStat = CustomStats.PvERoundSurviveBonus,
		CustomStatSet = 0
	}):Response(
	{
		CustomStat = CustomStats.PvERoundKillBonus,
		CustomStatSet = 0
	}):Response(
	{
		CustomStat = CustomStats.PvERoundAssistBonus,
		CustomStatSet = 0
	});
__OnGenericPvERoundEnd = Delegate:new();
onPvERoundEnd = root:AddCallback(
	__OnGenericPvERoundEnd,
		function (context, completedRound)
			context.CompletedRound = completedRound;
		end
	);
pveRoundEndResponse = onPvERoundEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundcomplete',
		Fanfare = FanfareDefinitions.GameScore,
		FanfareText = 'warzone_pve_round_complete_shelf',
		Score = function(context)
			return GetScoreVal(1000 * context.CompletedRound)
		end,
		ImpulseEvent = 'PvERoundComplete'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_basecaptured_pos',
	});
__OnRoundOneStart = Delegate:new();
onPvERoundOneStart = root:AddCallback(
	__OnRoundOneStart
	);
pveRoundOneStartResponse = onPvERoundOneStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundstart1', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundstart_round01',
	});
__OnRoundEnd = Delegate:new();
onPvERoundOneEnd = root:AddCallback(
	__OnRoundEnd
	);
pveRoundOneEndResponse = onPvERoundOneEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_intermission_round01',
	});
__OnRoundTwoStart = Delegate:new();
onPvERoundTwoStart = root:AddCallback(
	__OnRoundTwoStart
	);
pveRoundTwoStartResponse = onPvERoundTwoStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundstart2',
	}):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightrespawnincreased',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_respawn_increase',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundstart_round02',
	});
__OnRoundTwoEnd = Delegate:new();
onPvERoundTwoEnd = root:AddCallback(
	__OnRoundTwoEnd
	);
pveRoundTwoEndResponse = onPvERoundTwoEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_intermission_round02',
	});
__OnRoundThreeStart = Delegate:new();
onPvERoundThreeStart = root:AddCallback(
	__OnRoundThreeStart
	);
pveRoundThreeStartResponse = onPvERoundThreeStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundstart3',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_respawn_increase',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundstart_round03',
	});
__OnRoundThreeEnd = Delegate:new();
onPvERoundThreeEnd = root:AddCallback(
	__OnRoundThreeEnd
	);
pveRoundThreeEndResponse = onPvERoundThreeEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_intermission_round03',
	});
__OnRoundFourStart = Delegate:new();
onPvERoundFourStart = root:AddCallback(
	__OnRoundFourStart
	);
pveRoundFourStartResponse = onPvERoundFourStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundstart4',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_respawn_increase',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundstart_round04',
	});
__OnRoundFourEnd = Delegate:new();
onPvERoundFourEnd = root:AddCallback(
	__OnRoundFourEnd
	);
pveRoundFourEndResponse = onPvERoundFourEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_intermission_round04',
	});
__OnRoundFiveStart = Delegate:new();
onPvERoundFiveStart = root:AddCallback(
	__OnRoundFiveStart
	);
pveRoundFiveStartResponse = onPvERoundFiveStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundstartfinal',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_respawn_increase',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundstart_round05',
	});
__OnPvEIntermissionStart = Delegate:new();
onPvEIntermissionStart = root:AddCallback(
	__OnPvEIntermissionStart
	);
pveIntermissionStartResponse = onPvEIntermissionStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_intermission',
	});
__OnPvEGenericEliminateEnd = Delegate:new();
onPvEGenericEliminateEnd = root:AddCallback(
	__OnPvEGenericEliminateEnd
	);
pveGenericEliminateEndResponse = onPvEGenericEliminateEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatecomplete1',
	});
__OnPvEGarageBaseDefenseEndSuccessful = Delegate:new();
onPvEGarageBaseDefenseEndSuccessful = root:AddCallback(
	__OnPvEGarageBaseDefenseEndSuccessful
	);
pveGarageBaseDefenseEndSuccessfulResponse = onPvEGarageBaseDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_genericbasedefended',
	});
__OnPvEGarageBaseDefenseEndFailure = Delegate:new();
onPvEGarageBaseDefenseEndFailure = root:AddCallback(
	__OnPvEGarageBaseDefenseEndFailure
	);
pveGarageBaseDefenseEndFailureResponse = onPvEGarageBaseDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasegaragelost',
	});
__OnPvEArmoryBaseDefenseEndSuccessful = Delegate:new();
onPvEArmoryBaseDefenseEndSuccessful = root:AddCallback(
	__OnPvEArmoryBaseDefenseEndSuccessful
	);
pveArmoryBaseDefenseEndSuccessfulResponse = onPvEArmoryBaseDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_genericbasedefended',
	});
__OnPvEArmoryBaseDefenseEndFailure = Delegate:new();
onPvEArmoryBaseDefenseEndFailure = root:AddCallback(
	__OnPvEArmoryBaseDefenseEndFailure
	);
pveArmoryBaseDefenseEndFailureResponse = onPvEArmoryBaseDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearmorylost',
	});
__OnPvESpireDefenseEndSuccessful = Delegate:new();
onPvESpireDefenseEndSuccessful = root:AddCallback(
	__OnPvESpireDefenseEndSuccessful
	);
pveSpireDefenseEndSuccessfulResponse = onPvESpireDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_spiredefensesuccess',
	});
__OnPvESpireDefenseEndFailure = Delegate:new();
onPvESpireDefenseEndFailure = root:AddCallback(
	__OnPvESpireDefenseEndFailure
	);
pveSpireDefenseEndFailureResponse = onPvESpireDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasespirelost',
	});
__OnPvEFortDefenseEndSuccessful = Delegate:new();
onPvEFortDefenseEndSuccessful = root:AddCallback(
	__OnPvEFortDefenseEndSuccessful
	);
pveFortDefenseEndSuccessfulResponse = onPvEFortDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_fortressdefensesuccess',
	});
__OnPvEFortDefenseEndFailure = Delegate:new();
onPvEFortDefenseEndFailure = root:AddCallback(
	__OnPvEFortDefenseEndFailure
	);
pveFortDefenseEndFailureResponse = onPvEFortDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedhostile',
	});
__OnPvEHBCoreBaseDefenseEndSuccessful = Delegate:new();
onPvEHBCoreBaseDefenseEndSuccessful = root:AddCallback(
	__OnPvEHBCoreBaseDefenseEndSuccessful
	);
pveHBCoreBaseDefenseEndSuccessfulResponse = onPvEHBCoreBaseDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasedefensewindef',
	});
__OnPvEHBCoreBaseDefenseEndFailure = Delegate:new();
onPvEHBCoreBaseDefenseEndFailure = root:AddCallback(
	__OnPvEHBCoreBaseDefenseEndFailure
	);
pveHBCoreBaseDefenseEndFailureResponse = onPvEHBCoreBaseDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_genericbaselost',
	});
__OnPvEDefGenEndSuccessful = Delegate:new();
onPvEDefGenEndSuccessful = root:AddCallback(
	__OnPvEDefGenEndSuccessful
	);
pveDefGenEndSuccessfulResponse = onPvEDefGenEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectwingenerator',
	});
__OnPvEDefGenEndFailure = Delegate:new();
onPvEDefGenEndFailure = root:AddCallback(
	__OnPvEDefGenEndFailure
	);
pveDefGenEndFailureResponse = onPvEDefGenEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectfailgenerator',
	});
__OnPvEDefForCoreEndSuccessful = Delegate:new();
onPvEDefForCoreEndSuccessful = root:AddCallback(
	__OnPvEDefForCoreEndSuccessful
	);
pveDefForCoreEndSuccessful = onPvEDefForCoreEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectwinforerunner',
	});
__OnPvEDefForCoreEndFailure = Delegate:new();
onPvEDefForCoreEndFailure = root:AddCallback(
	__OnPvEDefForCoreEndFailure
	);
pveDefForCoreEndFailureResponse = onPvEDefForCoreEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectfailforerunner',
	});
__OnBaseNearingCapture = Delegate:new();
onBaseNearingCapture = root:AddCallback(
	__OnBaseNearingCapture,
	function(context, baseName)
		context.BaseName = baseName;
	end
	);
onBaseNearingCaptureResponse = onBaseNearingCapture:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_basenearingcapture',
	});
__OnDefenseObjectiveNearingDefeat = Delegate:new();
OnDefenseObjectiveNearingDefeat = root:AddCallback(
	__OnDefenseObjectiveNearingDefeat
	);
onDefenseObjectiveNearingDefeatResponse = OnDefenseObjectiveNearingDefeat:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_basenearingcapture',
	});
timeRemaining = onUpdate:Filter(
	function (context)
		return context.Engine:InRound() and
			context.Engine:IsRoundTimerCountingDown();
	end
	):Emit(
	function (context)
		if context.Engine:IsRoundTimerCountingDown() then
			context.TimeRemaining = context.Engine:GetRoundTimeRemaining();
		end
	end	
	);
twoMinutesRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 120; 
	end
	);
twoMinutesRemainingResponse = twoMinutesRemaining:Target(TargetAllPlayers):Response(	
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timetwominutesremaining'
	});
sixtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 60; 
	end
	);
sixtySecondsRemainingResponse = sixtySecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_timeoneminuteremaining', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_roundending'
	});
thirtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining < 30;
	end
	);
thirtySecondsRemainingResponse = thirtySecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time30secondsleft'
	});
tenSecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining < 10;
	end
	);
tenSecondsRemainingResponse = tenSecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_time10secondsleft'
	});
pveDeathsInRoundAccumulator = root:CreatePlayerAccumulator();
onPlayerDeathsInPvERoundAccumulator = onPlayerDeath:PlayerAccumulator(
	pveDeathsInRoundAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
onPvERoundStart:ResetAccumulator(pveDeathsInRoundAccumulator);
pveRoundEndPlayerBucketSurviveBonus = onPvERoundEnd:Bucket(
	function (context)
		return context:GetAllPlayers();
	end,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
survivedPvERoundBucket = pveRoundEndPlayerBucketSurviveBonus:Add(
	function (context, player)
		return pveDeathsInRoundAccumulator:GetValue(player) == 0; 
	end
	);
function GetSurviveBonusImpulseString(context)
	return ("PvESurviveBonus_R" .. context.CompletedRound);
end
survivedPvERoundResponse = survivedPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_survived_shelf',
	Score = function(context)
		return GetScoreVal(250 * context.CompletedRound)
	end,
	ImpulseEvent = 'PvESurvivedRound',
	CustomStat = CustomStats.PvERoundSurviveBonus,
	CustomStatSet = function(context)
		return GetScoreVal(250 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSurviveBonusImpulseString
});
pveKillsInRoundAccumulator = root:CreatePlayerAccumulator();
onKillsInPvERoundAccumulator = onEnemyAIKill:PlayerAccumulator(
	pveKillsInRoundAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);
onPvERoundStart:ResetAccumulator(pveKillsInRoundAccumulator);
pveRoundEndPlayerBucketKillBonus = onPvERoundEnd:Bucket(
	function (context)
		return context:GetAllPlayers();
	end,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
fiftyKillsInPvERoundBucket = pveRoundEndPlayerBucketKillBonus:Add(
	function (context, player)
		return pveKillsInRoundAccumulator:GetValue(player) >= 25; 
	end
	);
function GetKillBonusImpulseString(context)
	return ("PvEKillBonus_R" .. context.CompletedRound);
end
fiftyKillsInRoundPvEResponse = fiftyKillsInPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_kills_50_shelf',
	Score = function(context)
		return GetScoreVal(400 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundKillBonus,
	CustomStatSet = function(context)
		return GetScoreVal(400 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
});
fortyKillsInPvERoundBucket = pveRoundEndPlayerBucketKillBonus:Add(
	function (context, player)
		return pveKillsInRoundAccumulator:GetValue(player) >= 20; 
	end
	);
fortyKillsInRoundPvEResponse = fortyKillsInPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_kills_40_shelf',
	Score = function(context)
		return GetScoreVal(300 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundKillBonus,
	CustomStatSet = function(context)
		return GetScoreVal(300 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
});
thirtyKillsInPvERoundBucket = pveRoundEndPlayerBucketKillBonus:Add(
	function (context, player)
		return pveKillsInRoundAccumulator:GetValue(player) >= 15; 
	end
	);
thirtyKillsInRoundPvEResponse = thirtyKillsInPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_kills_30_shelf', 
	Score = function(context)
		return GetScoreVal(200 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundKillBonus,
	CustomStatSet = function(context)
		return GetScoreVal(200 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
});
twentyKillsInPvERoundBucket = pveRoundEndPlayerBucketKillBonus:Add(
	function (context, player)
		return pveKillsInRoundAccumulator:GetValue(player) >= 10; 
	end
	);
twentyKillsInRoundPvEResponse = twentyKillsInPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_kills_20_shelf', 
	Score = function(context)
		return GetScoreVal(100 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundKillBonus,
	CustomStatSet = function(context)
		return GetScoreVal(100 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
});
tenKillsInPvERoundBucket = pveRoundEndPlayerBucketKillBonus:Add(
	function (context, player)
		return pveKillsInRoundAccumulator:GetValue(player) >= 5; 
	end
	);
tenKillsInRoundPvEResponse = tenKillsInPvERoundBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_kills_10_shelf', 
	Score = function(context)
		return GetScoreVal(50 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundKillBonus,
	CustomStatSet = function(context)
		return GetScoreVal(50 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetKillBonusImpulseString
});
pveAssistsInRoundAccumulator = root:CreatePlayerAccumulator();
onAssistsInPvERoundAccumulator = onEnemyAIKill:PlayerAccumulator(
	pveAssistsInRoundAccumulator,
	function (context)
		return context.AssistingPlayers;
	end
	);
onPvERoundStart:ResetAccumulator(pveAssistsInRoundAccumulator);
pveRoundEndPlayerBucketAssistBonus = onPvERoundEnd:Bucket(
	function (context)
		return context:GetAllPlayers();
	end,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
assistsInPvERoundTier5Bucket = pveRoundEndPlayerBucketAssistBonus:Add(
	function (context, player)
		return pveAssistsInRoundAccumulator:GetValue(player) >= 25; 
	end
	);
function GetAssistBonusImpulseString(context)
	return ("PvEAssistBonus_R" .. context.CompletedRound);
end
assistsInRoundPvETier5Response = assistsInPvERoundTier5Bucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_assists_5_shelf',
	Score = function(context)
		return GetScoreVal(400 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundAssistBonus,
	CustomStatSet = function(context)
		return GetScoreVal(400 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
});
assistsInPvERoundTier4Bucket = pveRoundEndPlayerBucketAssistBonus:Add(
	function (context, player)
		return pveAssistsInRoundAccumulator:GetValue(player) >= 20; 
	end
	);
assistsInRoundPvETier4Response = assistsInPvERoundTier4Bucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_assists_4_shelf', 
	Score = function(context)
		return GetScoreVal(300 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundAssistBonus,
	CustomStatSet = function(context)
		return GetScoreVal(300 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
});
assistsInPvERoundTier3Bucket = pveRoundEndPlayerBucketAssistBonus:Add(
	function (context, player)
		return pveAssistsInRoundAccumulator:GetValue(player) >= 15; 
	end
	);
assistsInRoundPvETier3Response = assistsInPvERoundTier3Bucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_assists_3_shelf', 
	Score = function(context)
		return GetScoreVal(200 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundAssistBonus,
	CustomStatSet = function(context)
		return GetScoreVal(200 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
});
assistsInPvERoundTier2Bucket = pveRoundEndPlayerBucketAssistBonus:Add(
	function (context, player)
		return pveAssistsInRoundAccumulator:GetValue(player) >= 10; 
	end
	);
assistsInRoundPvETier2Response = assistsInPvERoundTier2Bucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_assists_2_shelf', 
	Score = function(context)
		return GetScoreVal(100 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundAssistBonus,
	CustomStatSet = function(context)
		return GetScoreVal(100 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
});
assistsInPvERoundTier1Bucket = pveRoundEndPlayerBucketAssistBonus:Add(
	function (context, player)
		return pveAssistsInRoundAccumulator:GetValue(player) >= 5; 
	end
	);
assistsInRoundPvETier1Response = assistsInPvERoundTier1Bucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_assists_1_shelf', 
	Score = function(context)
		return GetScoreVal(50 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundAssistBonus,
	CustomStatSet = function(context)
		return GetScoreVal(50 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetAssistBonusImpulseString
});
local speedRoundSeconds = 120.0;
speedRoundAccumulator = root:CreateAccumulator(speedRoundSeconds);
onSpeedRoundStart = onPvERoundStart:Accumulator(speedRoundAccumulator);
onSpeedRound = onPvERoundEnd:Filter(
	function(context)
		return speedRoundAccumulator:GetValue() == 1
	end
	);
function GetSpeedBonusImpulseString(context)
	return ("PvESpeedBonus_R" .. context.CompletedRound);
end
speedRoundResponse = onSpeedRound:Target(TargetAllPlayers):Response(
{
	Fanfare = FanfareDefinitions.GameScore,
	FanfareText = 'warzone_pve_round_speed_shelf', 
	Score = function(context)
		return GetScoreVal(250 * context.CompletedRound)
	end,
	CustomStat = CustomStats.PvERoundSpeedBonus,
	CustomStatSet = function(context)
		return GetScoreVal(250 * context.CompletedRound)
	end,
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
}):Response(
{
	ImpulseEvent = GetSpeedBonusImpulseString
});
onPvERoundEnd:ResetAccumulator(speedRoundAccumulator);
__OnPvEDefendGarageStart = Delegate:new();
onPvEDefendGarageStart = root:AddCallback(
	__OnPvEDefendGarageStart
	);
pveDefendGarageStartResponse = onPvEDefendGarageStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturegaragedef',
	});
__OnPvEDefendArmoryStart = Delegate:new();
onPvEDefendArmoryStart = root:AddCallback(
	__OnPvEDefendArmoryStart
	);
pveDefendArmoryStartResponse = onPvEDefendArmoryStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackfinalbasearmory',
	});
__OnPvEDefendHBCoreStart = Delegate:new();
onPvEDefendHBCoreStart = root:AddCallback(
	__OnPvEDefendHBCoreStart
	);
pveDefendHBCoreStartResponse = onPvEDefendHBCoreStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase',
	});
__OnPvEDefendSpireStart = Delegate:new();
onPvEDefendSpireStart = root:AddCallback(
	__OnPvEDefendSpireStart
	);
pveDefendSpireStartResponse = onPvEDefendSpireStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackfinalbasespire',
	});
__OnPvEDefendFortressStart = Delegate:new();
onPvEDefendFortressStart = root:AddCallback(
	__OnPvEDefendFortressStart
	);
pveDefendFortressStart = onPvEDefendFortressStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseszstartdef',
	});
__OnPvEDefendGeneratorStart = Delegate:new();
onPvEDefendGeneratorStart = root:AddCallback(
	__OnPvEDefendGeneratorStart
	);
pveDefendGeneratorStart = onPvEDefendGeneratorStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectgenerator',
	});
__OnPvEDefendGeneratorPluralStart = Delegate:new();
onPvEDefendGeneratorPluralStart = root:AddCallback(
	__OnPvEDefendGeneratorPluralStart
	);
pveDefendGeneratorPluralStart = onPvEDefendGeneratorPluralStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectgeneratorplural',
	});
__OnPvEDefendForCoreStart = Delegate:new();
onPvEDefendForCoreStart = root:AddCallback(
	__OnPvEDefendForCoreStart
	);
pveDefendForCoreStart = onPvEDefendForCoreStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectForerunner',
	});
__OnPvEDefendForCorePluralStart = Delegate:new();
onPvEDefendForCorePluralStart = root:AddCallback(
	__OnPvEDefendForCorePluralStart
	);
pvePvEDefendForCorePluralStart = onPvEDefendForCorePluralStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightdefendobjectforerunnerPlural',
	});
__OnObjectDamaged = Delegate:new();
onObjectDefenseDamaged = root:AddCallback(
	__OnObjectDamaged
	);
friendlyObjectDamaged = onObjectDefenseDamaged:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectHostileDamage'
	});
__OnObjectDamaged75 = Delegate:new();
onObjectDefenseDamaged75 = root:AddCallback(
	__OnObjectDamaged75
	);
friendlyObjectDamaged75 = onObjectDefenseDamaged75:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectHealth75'
	});
__OnObjectDamaged50 = Delegate:new();
onObjectDefenseDamaged50 = root:AddCallback(
	__OnObjectDamaged50
	);
friendlyObjectDamaged50 = onObjectDefenseDamaged50:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectHealth50'
	});
__OnObjectDamaged25 = Delegate:new();
onObjectDefenseDamaged25 = root:AddCallback(
	__OnObjectDamaged25
	);
friendlyObjectDamaged25 = onObjectDefenseDamaged25:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectHealth25'
	});
__OnObjectDamaged10 = Delegate:new();
onObjectDefenseDamaged10 = root:AddCallback(
	__OnObjectDamaged10
	);
friendlyObjectDamaged10 = onObjectDefenseDamaged10:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectImminentTarget'
	});
__OnTwoObjectsLeft = Delegate:new();
onTwoObjectsLeft = root:AddCallback(
	__OnTwoObjectsLeft
	);
twoFriendlyObjectsLeft = onTwoObjectsLeft:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectTwoRemain'
	});
__OnOneObjectLeft = Delegate:new();
onOneObjectLeft = root:AddCallback(
	__OnOneObjectLeft
	);
oneFriendlyObjectsLeft = onOneObjectLeft:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectOneRemains'
	});
__OnPvECrawlerEliminateStart = Delegate:new();
onPvECrawlerEliminateStart = root:AddCallback(
	__OnPvECrawlerEliminateStart
	);
pveCrawlerEliminateStartResponse = onPvECrawlerEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatecrawler',
	});
__OnPvEWatcherEliminateStart = Delegate:new();
onPvEWatcherEliminateStart = root:AddCallback(
	__OnPvEWatcherEliminateStart
	);
pveWatcherEliminateStartResponse = onPvEWatcherEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatewatcher',
	});
__OnPvESoldierEliminateStart = Delegate:new();
onPvESoldierEliminateStart = root:AddCallback(
	__OnPvESoldierEliminateStart
	);
pveSoldierEliminateStartResponse = onPvESoldierEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatesoldier',
	});
__OnPvEKnightEliminateStart = Delegate:new();
onPvEKnightEliminateStart = root:AddCallback(
	__OnPvEKnightEliminateStart
	);
pveKnightEliminateStartResponse = onPvEKnightEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminateknight',
	});
__OnPvEWardenEliminateStart = Delegate:new();
onPvEWardenEliminateStart = root:AddCallback(
	__OnPvEWardenEliminateStart
	);
pveWardenEliminateStartResponse = onPvEWardenEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_warzonebossszwardenwinrangefriendly',
	});
__OnPvEGruntEliminateStart = Delegate:new();
onPvEGruntEliminateStart = root:AddCallback(
	__OnPvEGruntEliminateStart
	);
pveGruntEliminateStartResponse = onPvEGruntEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminategrunt',
	});
__OnPvEJackalEliminateStart = Delegate:new();
onPvEJackalEliminateStart = root:AddCallback(
	__OnPvEJackalEliminateStart
	);
pveJackalEliminateStartResponse = onPvEJackalEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatejackal',
	});
__OnPvEEliteEliminateStart = Delegate:new();
onPvEEliteEliminateStart = root:AddCallback(
	__OnPvEEliteEliminateStart
	);
pveEliteEliminateStartResponse = onPvEEliteEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminateelite',
	});
__OnPvEHunterEliminateStart = Delegate:new();
onPvEHunterEliminateStart = root:AddCallback(
	__OnPvEHunterEliminateStart
	);
pveHunterEliminateStartResponse = onPvEHunterEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatehunter',
	});
__OnPvEGhostEliminateStart = Delegate:new();
onPvEGhostEliminateStart = root:AddCallback(
	__OnPvEGhostEliminateStart
	);
pveGhostEliminateStartResponse = onPvEGhostEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminateghost',
	});
__OnPvEWraithEliminateStart = Delegate:new();
onPvEWraithEliminateStart = root:AddCallback(
	__OnPvEWraithEliminateStart
	);
pveWraithEliminateStartResponse = onPvEWraithEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatewraith',
	});
__OnPvEBansheeEliminateStart = Delegate:new();
onPvEBansheeEliminateStart = root:AddCallback(
	__OnPvEBansheeEliminateStart
	);
pveBansheeEliminateStartResponse = onPvEBansheeEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionelimiantecov',
	});
__OnPvEPhaetonsEliminateStart = Delegate:new();
onPvEPhaetonsEliminateStart = root:AddCallback(
	__OnPvEPhaetonsEliminateStart
	);
pvePhaetonsEliminateStartResponse = onPvEPhaetonsEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionEliminatePhaeton',
	});
__OnPvEPrometheansEliminateStart = Delegate:new();
onPvEPrometheansEliminateStart = root:AddCallback(
	__OnPvEPrometheansEliminateStart
	);
pvePrometheansEliminateStartResponse = onPvEPrometheansEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatepro',
	});
__OnPvECovenantEliminateStart = Delegate:new();
onPvECovenantEliminateStart = root:AddCallback(
	__OnPvECovenantEliminateStart
	);
pveCovenantEliminateStartResponse = onPvECovenantEliminateStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionElimianteCov',
	});
__OnRoundFiveEnd = Delegate:new();
onPvERoundFiveEnd = root:AddCallback(
	__OnRoundFiveEnd
	);
pveRoundFiveEndResponse = onPvERoundFiveEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionmatchcomplete1',
		ImpulseEvent = 'PvEMatchComplete',
		PlatformImpulse = 'PvEMatchWin',
		OutOfGameEvent = true
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_matchover_win',
		OutOfGameEvent = true
	});	
__OnPvERoundFail = Delegate:new();
onPvERoundFail = root:AddCallback(
	__OnPvERoundFail
	);
pveRoundFailResponse = onPvERoundFail:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionroundlost2', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_matchover_lose',
		OutOfGameEvent = true
	});	
__OnSlayCountRemainingEnemiesBlipped = Delegate:new();
onPvERemainingEnemiesBlipped = root:AddCallback(
	__OnSlayCountRemainingEnemiesBlipped
	);
pveEnemiesBlippedResponse = onPvERemainingEnemiesBlipped:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursioneliminatecouple1',
	});	
onMythicBossKilled = OnMiniBossKilled:Filter(
	function (context)
		return context.BossType == MinibossType.Mythicboss;
	end
	);
mythicBossKillInFirefightResponse = onMythicBossKilled:Target(ContributingPlayersTarget):Response(
	{
		PlatformImpulse = 'MythicKillFF',
	});