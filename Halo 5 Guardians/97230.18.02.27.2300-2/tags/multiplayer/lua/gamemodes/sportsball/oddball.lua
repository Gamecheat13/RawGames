
modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_oddballmodename'	
	});
__OnSportsballHeldScore = Delegate:new();
onSportsballHeldScore = root:AddCallback(
	__OnSportsballHeldScore,
	function (context, scoringPlayer, gainedLead, scoreLeftToWin, totalScoreToWin, previousWinningPlayer)
		context.TargetPlayer = scoringPlayer; 
		context.ScoringPlayer = scoringPlayer;
		context.GainedLead = gainedLead;
		context.ScoreLeftToWin = scoreLeftToWin;
		context.TotalScoreToWin = totalScoreToWin;
		context.Designator = scoringPlayer:GetTeamDesignator();
		context.PreviousWinningPlayer = previousWinningPlayer;
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
__OnBallDropped = Delegate:new();
onOddballDropped = root:AddCallback(
	__OnBallDropped,
	function (context, carryingPlayer)
		context.CarryingPlayer = carryingPlayer;
	end
	);
ballHeldSecondsInARowAccumulator = root:CreatePlayerAccumulator();
onBallHeldSecondsInARow = onSportsballHeldForOneSecond:PlayerAccumulator(
	ballHeldSecondsInARowAccumulator,
	function (context)
		return context.TargetPlayer;
	end
	);
onOddballDroppedAfterHoldingForAtLeastFiveSeconds = onOddballDropped:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.CarryingPlayer) >= 5;
	end
	);
onOddballDropped:ResetPlayerAccumulator(
	ballHeldSecondsInARowAccumulator,
	function (context)
		return context.CarryingPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	ballHeldSecondsInARowAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
onRoundStart:ResetAccumulator(ballHeldSecondsInARowAccumulator);
onTenSecInARow = onBallHeldSecondsInARow:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.TargetPlayer) == 10
	end
	);
ballHolderResponse = onTenSecInARow:Target(TargetPlayer):Response(
	{
		Medal = 'ball_holder',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ball10seconds'
	});
onTwentySecInARow = onBallHeldSecondsInARow:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.TargetPlayer) == 20
	end
	);
ballKeeperResponse = onTwentySecInARow:Target(TargetPlayer):Response(
	{
		Medal = 'ball_keeper',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ball20seconds'
	});
onThirtySecInARow = onBallHeldSecondsInARow:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.TargetPlayer) == 30
	end
	);
ballMasterResponse = onThirtySecInARow:Target(TargetPlayer):Response(
	{
		Medal = 'ball_master',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ball30seconds'
	});
onFourtyFiveSecInARow = onBallHeldSecondsInARow:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.TargetPlayer) == 45
	end
	);
ballHogResponse = onFourtyFiveSecInARow:Target(TargetPlayer):Response(
	{
		Medal = 'ball_hog',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ball45seconds'
	});
onSixtySecInARow = onBallHeldSecondsInARow:Filter(
	function (context)
		return ballHeldSecondsInARowAccumulator:GetValue(context.TargetPlayer) == 60
	end
	);
magicHandsResponse = onSixtySecInARow:Target(TargetPlayer):Response(
	{
		Medal = 'magic_hands',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ball60seconds'
	});
onOddballDroppedResponse = onOddballDroppedAfterHoldingForAtLeastFiveSeconds:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_balldropped'	
	});
onGainedLead = onSportsballHeldScore:Filter(
	function(context)
		return context.GainedLead == true and context.ScoreLeftToWin > 0 and (context.TotalScoreToWin - context.ScoreLeftToWin > 1);
	end
	);
onGainedLeadWinningTeamResponse = onGainedLead:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});
onGainedLeadLosingTeamResponse = onGainedLead:Target(
	function (context)
		if context.PreviousWinningPlayer ~= nil then
			return context.PreviousWinningPlayer;
		end
		return AllPlayersHostileToScoringPlayer(context);
	end
	):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorelostlead'
	});
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
function NearingVictory(context)
	return context.ScoreLeftToWin <= (0.2 * context.TotalScoreToWin);
end
halfwayToVictory = onSportsballHeldScore:Filter(ScoreAtLeastHalfwayToVictory);
nearingVictory = onSportsballHeldScore:Filter(NearingVictory);
nearingVictoryEnemySelect = nearingVictory:Select();
teamNearingVictory = nearingVictoryEnemySelect:Add(
	function(context)
		return context.Engine:TeamsEnabled();
	end
	);
ffaNearingVictory = nearingVictoryEnemySelect:Add();
enemyNearingVictoryTeamResponse = teamNearingVictory:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorenearingvictoryenemy'
	});
enemyNearingVictoryFFAResponse = ffaNearingVictory:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorenearingvictoryffa'
	});
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
function BuildHalfwayVictoryNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "NearingVictoryNeutralResponse"] = sourceEvent:Once():Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamscorehalfway'
		});
end
halfwayToVictoryNeutralSelect = halfwayToVictory:Select();
GenerateTeamSpecificNeutralResponses(halfwayToVictoryNeutralSelect, BuildHalfwayVictoryNeutralResponse)
roundEndingMusicWinnersResponse = nearingVictory:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_winning_loop'
	});
roundEndingMusicLosersResponse = nearingVictory:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_losing_loop'
	});
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
		Medal = 'oddball_first_touch'
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
__OnBallOutOfBounds = Delegate:new();
onBallOutOfBounds = root:AddCallback(
	__OnBallOutOfBounds
	);
onBallOutOfBoundsResponse = onBallOutOfBounds:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ricochet_outofbounds'
	});
__OnSportsballIncoming = Delegate:new();
onBallIncoming = root:AddCallback(
	__OnSportsballIncoming
	);
onBallIncomingResponse = onBallIncoming:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballincoming', 
		Sound2 = 'multiplayer\audio\sound_effects\sound_effects_sportball_ballincoming'
	});
__OnSportsballSpawned = Delegate:new();
onBallSpawned = root:AddCallback(
	__OnSportsballSpawned,
	function (context)
		sportsballPossession = nil;
	end
	);
onBallSpawnedResponse = onBallSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ricochet_newball', 
		Sound2 = 'multiplayer\audio\sound_effects\sound_effects_sportball_ballready' 
	})
onSportsballKillTypeSelect = onEnemyPlayerKill:Select();
onCarrierKilled = onSportsballKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:IsBallCarrier();
	end
	);
onCarrierKilledResponse = onCarrierKilled:Target(KillingPlayer):Response(
	{
		Medal = 'oddball_carrier_kill',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_carrierkill',
		CustomStat = 'CarrierKills',
		CustomStatChange = 1
	});
onCarrierKilledResponseDeadTeamResponse = onCarrierKilled:Target(FriendlyToDeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_drop'
	});
onCarrierKillWithBallResponse = onBallKill:Target(KillingPlayer):Response(
	{
		Medal = 'oddball_kill',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballkill'	
	});
onBallsassinationResponse = onBallsassination:Target(KillingPlayer):Response(
	{
		Medal = 'oddball_ballsassination',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_ballsassination'	
	});
onThreeBallKillsInARowResponse = onThreeBallKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'oddball_smooth_moves',
		Sound = 'multiplayer\audio\announcer\announcer_oddball_balltriplekill'
	});
onBallCarrierProtectedResponse = onBallCarrierProtected:Target(KillingPlayer):Response(
	{
		Medal = 'oddball_carrier_protected'
	});
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
