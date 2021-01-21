--
-- Arena Shared Events
--

onMatchEnd = root:AddCallback(
	__OnMatchEnd
	);

-- Round won music and announcer
	
onMatchEndGapSelect = onMatchEnd:Select();
matchEndSmallGap = onMatchEndGapSelect:Add(SmallGap);
matchEndMediumGap = onMatchEndGapSelect:Add(MediumGap);
matchEndLargeGap = onMatchEndGapSelect:Add(LargeGap);

--
-- Respawn Timer Countdown
--

onRespawnTimerTick = root:AddCallback(
	__OnRespawnTick,
	function(context, player, secondsRemaining)
		context.TargetPlayer = player;
		context.SecondsRemaining = secondsRemaining;
	end
	);

onCountdownHit321 = onRespawnTimerTick:Filter(
	function(context)
		return (context.Engine:IsRoundTimerStopped() == false or context.Engine:IsOvertimeTimerStopped() == false)
		and context.SecondsRemaining >= 1 
		and context.SecondsRemaining <= 3
	end
	);

countdownHit321Response = onCountdownHit321:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_countdown321'
	});

onCountdownHitZero = onRespawnTimerTick:Filter(
	function(context)
		return context.SecondsRemaining == 0;
	end
	);

countdownHitZeroResponse = onCountdownHitZero:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_countdown0'
	});

-- Small Gap
matchEndSmallGapWinnerResponse = matchEndSmallGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win'
	});

matchEndSmallGapLoserResponse = matchEndSmallGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_lose'
	});
	
-- Small Gap neutral response

function BuildSmallGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "SmallGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory'
		}):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win'
		});
end

matchEndSmallGapNeutralSelect = matchEndSmallGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();

GenerateTeamSpecificNeutralResponses(matchEndSmallGapNeutralSelect, BuildSmallGapNeutralResponse)

-- Medium Gap
matchEndMediumGapWinnerResponse = matchEndMediumGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});

matchEndMediumGapLoserResponse = matchEndMediumGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});

-- Medium Gap neutral response

function BuildMediumGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "MediumGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory'
		}):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
		});
end

matchEndMediumGapNeutralSelect = matchEndMediumGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();

GenerateTeamSpecificNeutralResponses(matchEndMediumGapNeutralSelect, BuildMediumGapNeutralResponse)
	
-- Large Gap
matchEndLargeGapWinnerResponse = matchEndLargeGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
	});

matchEndLargeGapLoserResponse = matchEndLargeGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat'
	}):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose'
	});

-- Large Gap neutral response

function BuildLargeGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "LargeGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory'
		}):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
		});
end

matchEndLargeGapNeutralSelect = matchEndLargeGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();

GenerateTeamSpecificNeutralResponses(matchEndLargeGapNeutralSelect, BuildLargeGapNeutralResponse)

-- Match End Tied Response

matchEndTiedResponse = onMatchEnd:Target(TiedTarget):Response(
	{
		OutOfGameEvent = true,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gametied'
	}):Response(
	{
		OutOfGameEvent = true,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_neutral'
	});

--
-- Server Shutdown Messaging
--

__OnServerShutdownLastRound = Delegate:new();

onServerShutdownLastRound = root:AddCallback(
	__OnServerShutdownLastRound
	);

serverShutdownLastRoundResponse = onServerShutdownLastRound:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_last_round_arena'		
	});