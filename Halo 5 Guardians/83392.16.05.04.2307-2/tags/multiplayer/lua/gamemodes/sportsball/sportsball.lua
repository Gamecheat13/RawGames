--
-- Sportsball event definitions
--

--
-- Sportsball Intro
--

__OnSportsballIntro = Delegate:new();

onSportsballIntro = root:AddCallback(
	__OnSportsballIntro
	);

sportsballIntroResponse = onSportsballIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_grifball_grifballteamroundstart'	
	});

--
-- Ball Arming
--

__OnBallArming = Delegate:new();

onBallArming = root:AddCallback(
	__OnBallArming,
	function (context, carryingPlayer, lastCarryingPlayer)
		if (carryingPlayer ~= nil) then
			context.TargetPlayer = carryingPlayer;
		else
			context.TargetPlayer = lastCarryingPlayer;
		end
	end
	);

onBallArmingCarrierResponse = onBallArming:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_armingloopstart'
	});

onBallArmingFriendlyTeamResonse = onBallArming:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_teamarmingloopstart'	
	});

onBallArmingHostileTeamResponse = onBallArming:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_enemyteamarmingloopstart'
	});

--
-- Ball Disarming
--

__OnBallDisarming = Delegate:new();

onBallDisarming = root:AddCallback(
	__OnBallDisarming,
	function (context, carryingPlayer, lastCarryingPlayer)
		if (carryingPlayer ~= nil) then
			context.TargetPlayer = carryingPlayer;
		else
			context.TargetPlayer = lastCarryingPlayer;
		end
	end
	);

onBallDisarmingCarrierResponse = onBallDisarming:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_armingloopstop'
	});

onBallDisarmingFriendlyTeamResponse = onBallDisarming:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_teamarmingloopstop'
	})

onBallDisarmingHostileTeamResponse = onBallDisarming:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_enemyteamarmingloopstop'
	})

__OnBallArmingStopped = Delegate:new();

onBallArmingStopped = root:AddCallback(
	__OnBallArmingStopped,
	function (context, carryingPlayer, lastCarryingPlayer)
		if (carryingPlayer ~= nil) then
			context.TargetPlayer = carryingPlayer;
		else
			context.TargetPlayer = lastCarryingPlayer;
		end
	end
	);

onBallArmingStoppedCarrierResponse = onBallArmingStopped:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_armingloopstop'
	});

onBallArmingStoppedFriendlyTeamResponse = onBallArmingStopped:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_teamarmingloopstop'
	});

onBallArmingStoppedHostileTeamResponse = onBallArmingStopped:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_enemyteamarmingloopstop'
	})
--
-- Score events
--

__OnSportsballScore = Delegate:new();

onSportsballScore = root:AddCallback(
	__OnSportsballScore,
	function (context, scoringPlayer, gainedLead, scoreLeftToWin, totalScoreToWin)
		context.TargetPlayer = scoringPlayer;
		context.GainedLead = gainedLead;
		context.ScoreLeftToWin = scoreLeftToWin;
		context.TotalScoreToWin = totalScoreToWin;
		context.Designator = scoringPlayer:GetTeamDesignator();
	end
	);

onSportsballScoredCarrierResponse = onSportsballScore:Target(TargetPlayer):Response(
	{
		Medal = 'ball_goal',
		Sound = 'multiplayer\audio\announcer\announcer_grifball_goal'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_teamscored'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcapture_team_pos'
	});

onSportsballScoredShelfResponse = onSportsballScore:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'sportsball_ball_scored',
		TeamDesignator = DesignatorProperty
	});

onSportsballScoredFriendlyResponse = onSportsballScore:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedteammatescored'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcapture_team_pos'
	});

onSportsballScoredHostileResponse = onSportsballScore:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedenemy'
	}):Response(
	{	
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_enemyteamscored'
	}):Response(
	{	
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcapture_team_neg'
	});


--
-- Track multiple captures on the same player
--
multipleScoresAccumulator = root:CreatePlayerAccumulator();
onMultipleCaptures = onSportsballScore:PlayerAccumulator(
	multipleScoresAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);

onRoundStart:ResetAccumulator(multipleScoresAccumulator);

--
-- Call the highest priority capture that qualifies
--

threeFlagCapturesResponse = onSportsballScore:Filter(
	function(context)
		return multipleScoresAccumulator:GetValue(context.TargetPlayer) == 3
	end
	):Target(TargetPlayer):Response(
	{
		Medal = 'ball_champion'
	});

twoFlagCapturesResponse = onSportsballScore:Filter(
	function(context)
		return multipleScoresAccumulator:GetValue(context.TargetPlayer) == 2
	end
	):Target(TargetPlayer):Response(
	{
		Medal = 'ball_runner'
	});

--
-- Sportsball Held Scoring
--

__OnSportsballHeldScore = Delegate:new();

onSportsballHeldScore = root:AddCallback(
	__OnSportsballHeldScore,
	function (context, scoringPlayer, gainedLead, scoreLeftToWin, totalScoreToWin)
		context.TargetPlayer = scoringPlayer;
		context.GainedLead = gainedLead;
		context.ScoreLeftToWin = scoreLeftToWin;
		context.TotalScoreToWin = totalScoreToWin;
		context.Designator = scoringPlayer:GetTeamDesignator();
	end
	);

__OnSportsballHeldForOneSecond = Delegate:new();

onSportsballHeldForOneSecond = root:AddCallback(
	__OnSportsballHeldForOneSecond,
	function (context, holdingPlayer)
		context.TargetPlayer = holdingPlayer;
	end
	);

onSportsballHeldImpulse = onSportsballHeldForOneSecond:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'impulse_ball_held'
	});

-- Gained lead
onGainedLead = onSportsballScore:Filter(
	function(context)
		return context.GainedLead;
	end
	);

onGainedLeadScorerResponse = onGainedLead:Target(TargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});

onGainedLeadFriendlyResponse = onGainedLead:Target(FriendlyToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});

onGainedLeadHostileResponse = onGainedLead:Target(HostileToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorelostlead'
	});

-- Neutral Responses

function BuildGainedLeadNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "GainedLeadNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamgainedlead'
		});
end

gainedLeadNeutralSelect = onGainedLead:Select();

GenerateTeamSpecificNeutralResponses(gainedLeadNeutralSelect, BuildGainedLeadNeutralResponse)

--
-- Progress to Victory events
--

scoreToWinSelect = onSportsballScore:Select();
oneScoreToWin = scoreToWinSelect:Add(OneScoreToWin);
halfwayToVictory = scoreToWinSelect:Add(ScoreHalfwayToVictory);

-- One Score to win

oneScoreToWinSelect = oneScoreToWin:Select();

oneScoreToWinTiedResponse = oneScoreToWinSelect:Add(GameIsTied):Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_suddendeath'
	});

oneScoreToWinNotTied = oneScoreToWinSelect:Add();

oneScoreToWinWinnersResponse = oneScoreToWinNotTied:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_nextscorewins'
	});

oneScoreToWinLosingResponse = oneScoreToWinNotTied:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_slayer_enemyscorestowin1'
	});

-- Halfway to victory

halfWayToVictoryWinnersResponse = halfwayToVictory:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorehalfwayself'
	});

halfWayToVictoryLosersResponse = halfwayToVictory:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorehalfwayenemy'
	});

-- Halfway to victory neutral responses

function BuildHalfwayVictoryNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "NearingVictoryNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamscorehalfway'
		});
end

halfwayToVictoryNeutralSelect = halfwayToVictory:Select();

GenerateTeamSpecificNeutralResponses(halfwayToVictoryNeutralSelect, BuildHalfwayVictoryNeutralResponse)


--
-- Ball Clear
--

__OnBallClear = Delegate:new();

onBallClear = root:AddCallback(
	__OnBallClear,
	function (context, clearingPlayer)
		context.TargetPlayer = clearingPlayer;
	end
	);

onBallClearResponse = onBallClear:Target(TargetPlayer):Response(
	{
		Medal = 'ball_clear',
		Sound = 'multiplayer\audio\announcer\announcer_ricochet_ballcleared'
	});

--
-- Sportsball Picked up
--

local sportsballPossession = nil;
local lastTimeBallHeld = 0;
local ballPickedUpAnnouncementCooldown = 5.0;

function IsFirstTouch(context)
	return context.IsFirstTouch;
end

__OnBallPickedUp = Delegate:new();

onSportsballPickedUp = root:AddCallback(
	__OnBallPickedUp,
	function (context, carryingPlayer, isFirstTouch)
		context.TargetPlayer = carryingPlayer;
		context.IsFirstTouch = isFirstTouch
		context.DesignatorProperty = context.TargetPlayer:GetTeamDesignator();
	end
	);

onSportsballPickedupCarrierMusicResponse = onSportsballPickedUp:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_loop'
	});

onSportsballChangedPossession = onSportsballPickedUp:Filter(
	function(context)

		local currentGameTime = GetGameTime();
		local playEvent = (context.DesignatorProperty ~= sportsballPossession) or (currentGameTime - lastTimeBallHeld >= ballPickedUpAnnouncementCooldown);

		sportsballPossession = context.DesignatorProperty;
		lastTimeBallHeld = currentGameTime;

		return playEvent;
	end
	);

carrierPossessionChangeResponseSelect = onSportsballChangedPossession:Select();

onFirstTouchResponse = carrierPossessionChangeResponseSelect:Add(IsFirstTouch):Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_firsttouch',
		Medal = 'first_touch'
	}):Response(
	{	
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_pos'
	});

onFirstTouchResponseMusicFriendlyTeam = onFirstTouchResponse:Target(FriendlyToTargetPlayer):Response(
	{	
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_pos'
	});

onFirstTouchResponseMusicHostileTeam = onFirstTouchResponse:Target(HostileToTargetPlayer):Response(
	{	
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_neg'
	});

onStandardSportsballPossessionChangeCarrierResponse = carrierPossessionChangeResponseSelect:Add():Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_youhavetheball'
	});

onSportsballPickedUpFriendlyResponse = onSportsballChangedPossession:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_wehavetheball'
	});

onSportsballPickedUpHostileResponse = onSportsballChangedPossession:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_enemyhastheball'	
		});

--
-- Play Ball
--

__OnBallOutOfBounds = Delegate:new();

onBallOutOfBounds = root:AddCallback(
	__OnBallOutOfBounds
	);

onBallOutOfBoundsResponse = onBallOutOfBounds:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ricochet_outofbounds'
	});

--
-- Sportsball Incoming
--

__OnSportsballIncoming = Delegate:new();

onBallIncoming = root:AddCallback(
	__OnSportsballIncoming
	);

onBallIncomingResponse = onBallIncoming:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballincoming'	
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_ballincoming'
	});

--
-- Sportsball Spawned
--

__OnSportsballSpawned = Delegate:new();

onBallSpawned = root:AddCallback(
	__OnSportsballSpawned,
	function (context)
		sportsballPossession = nil;
	end
	);

onBallSpawnedResponse = onBallSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ricochet_newball'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_sportball_ballready' 
	})

--
-- Sportsball Kill Select
--

onSportsballKillTypeSelect = onEnemyPlayerKill:Select();

-- Carrier Kill

onCarrierKilled = onSportsballKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:IsBallCarrier();
	end
	);

onCarrierKilledResponse = onCarrierKilled:Target(KillingPlayer):Response(
	{
		Medal = 'ball_carrier_kill',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_carrierkill'	
	});

onCarrierKilledResponseDeadTeamResponse = onCarrierKilled:Target(FriendlyToDeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_drop'
	});

-- Goal Offense

onGoalOffense = onSportsballKillTypeSelect:Add(
	function (context)
		return context.KillingPlayer:KillWouldBeGoalOffense(context.DeadPlayer);
	end
	);

onGoalOffenseResponse = onGoalOffense:Target(KillingPlayer):Response(
	{
		Medal = 'goal_offense'
	});

-- Goal Defense

onGoalDefense = onSportsballKillTypeSelect:Add(
	function (context)
		return context.KillingPlayer:KillWouldBeGoalDefense(context.DeadPlayer);
	end
	);

onGoalDefenseResponse = onGoalDefense:Target(KillingPlayer):Response(
	{
		Medal = 'goal_defense'
	});

--
-- Kill With Ball
--

onCarrierKillWithBallResponse = onBallKill:Target(KillingPlayer):Response(
	{
		Medal = 'ball_kill',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballkill'	
	});

--
-- Ballsassination
--

onBallsassinationResponse = onBallsassination:Target(KillingPlayer):Response(
	{
		Medal = 'ballsassination',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballsassination'	
	});

--
-- Flag Escort Kill
--

onBallCarrierProtectedResponse = onBallCarrierProtected:Target(KillingPlayer):Response(
	{
		Medal = 'ball_carrier_protected'
	});

--
-- Flag Carrier Spotted
--

__OnCarrierSpotted = Delegate:new();

onCarrierSpotted = root:AddCallback(
	__OnCarrierSpotted,
	function (context, carryingPlayer)
		context.TargetPlayer = carryingPlayer;
	end
	);

spottedAccumulator = root:CreatePlayerAccumulator();

carrierSpottedResponse = onCarrierSpotted:Target(TargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_carrierspotted'
	});


-- Tell enemy team you were spotted
enemyCarrierSpottedResponse = onCarrierSpotted:Target(HostileToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer/audio/teamleadermale01/teamleadermale01_shared_hostilecarrierspottedgeneric'
	});

onCarrierSpottedIncrement = onCarrierSpotted:PlayerAccumulator(
	spottedAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	spottedAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);

function BuildCarrierSpottedNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "CarrierSpottedNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamcarrierspotted'
		});
end

carrierSpottedNeutralSelect = onCarrierSpotted:Select();

GenerateTeamSpecificNeutralResponses(carrierSpottedNeutralSelect, BuildCarrierSpottedNeutralResponse)
