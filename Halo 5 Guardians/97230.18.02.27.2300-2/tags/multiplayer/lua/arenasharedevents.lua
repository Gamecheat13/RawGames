
__OnModeIntro = Delegate:new();
onModeIntro = root:AddCallback(
	__OnModeIntro
	);
onMatchEnd = root:AddCallback(
	__OnMatchEnd
	);
onRunningStartFinished = root:AddCallback(
	__OnPlayerFinishedRunningStart, 
	function(context, player)
		context.TargetPlayer = player;
	end
	);
onRunningStartFinishedFirstRound = onRunningStartFinished:Filter(
	function(context)
		return context.Engine:GetRound() == 0;
	end
	);
runningStartFinishedFirstRoundResponse = onRunningStartFinishedFirstRound:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_matchstart'
	});
runningStartFinishedSelect = onRunningStartFinished:Select();
runningStartFinishedEnemyFacingElimination = runningStartFinishedSelect:Add(
	function(context)
		local variant = FindVariant(context);
		return context.TargetPlayer:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
	end
	);
runningStartFinishedEnemyFacingEliminationResponse = runningStartFinishedEnemyFacingElimination:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_breakout_breakoutstartenemyelim'
	});
runningStartFinishedFacingElimination = runningStartFinishedSelect:Add(
	function (context)
		return table.any(context:GetAllPlayers(),
			function (player)
				local variant = FindVariant(context);
				return variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() > 1 
				and player:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
			end
		);
	end
	);
runningStartFinishedFacingEliminationResponse = runningStartFinishedFacingElimination:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_breakout_breakoutstartfaceelim'
	});
runningStartFinishedGeneric = runningStartFinishedSelect:Add();
runningStartFinishedGenericResponse = runningStartFinishedGeneric:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_breakout_breakoutstart'
	});
__OnCheckFacingElimination = Delegate:new();
onCheckFacingElimination = root:AddCallback(
	__OnCheckFacingElimination
	);
roundsWonBucket = onCheckFacingElimination:Bucket(
	function (context)
		return context:GetAllPlayers();
	end,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
nextRoundWinsBucket = roundsWonBucket:Add(
	function (context, player)
		return table.all(context:GetAllPlayers(),
			function (player)
				local variant = FindVariant(context);
				return player:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
			end
			);
	end
	);
nextRoundWinsResponse = nextRoundWinsBucket:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundstartnextroundwins', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_breakout\music_mp_breakout_matchpoint_neutral_loop'
	});
enemyFacingEliminationBucket = roundsWonBucket:Add(
	function (context, player)
		local variant = FindVariant(context);
		return player:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
	end
	);
enemyFacingEliminationResponse = enemyFacingEliminationBucket:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundstartenemyfacingelimination', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_breakout\music_mp_breakout_matchpoint_winning_loop'
	});
facingEliminationBucket = roundsWonBucket:Add(
	function (context, player)
		return table.any(context:GetAllPlayers(),
			function (player)
				local variant = FindVariant(context);
				return player:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
			end
			);
	end
	);
facingEliminationResponse = facingEliminationBucket:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundstartfacingelimination', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_breakout\music_mp_breakout_matchpoint_losing_loop'
	});
__OnRoundAnnouncement = Delegate:new();
onRoundAnnouncement = root:AddCallback(
	__OnRoundAnnouncement
	);
roundNumberSelect = onRoundAnnouncement:Select()
for roundNumber = 1, 26 do
	local globals = _G;
	globals["onRoundStartRound" .. tostring(roundNumber)] = roundNumberSelect:Add(
		function(context)
			if context.Engine:GetRoundLimit() == 1 then
				return false;
			end
			return context.Engine:GetRound() == roundNumber - 1;
		end
		):Target(TargetAllPlayers):Response(
			{
				Sound = 'multiplayer\audio\announcer\announcer_breakout_roundstartround' .. tostring(roundNumber);
			});
end
--	
__OnRoundEndAnnouncement = Delegate:new();
onRoundEndAnnouncement = root:AddCallback(
	__OnRoundEndAnnouncement
	);	
roundEndFindWinningPlayers = onRoundEndAnnouncement:Emit(
	function(context)
		context.WinningPlayers = FindWinningPlayers(context);
	end
	);
roundEndSelect = roundEndFindWinningPlayers:Select();
onRoundWonAnnouncement = roundEndSelect:Add(
	function(context)
		return context.WinningPlayers ~= nil;
	end
	);
roundWonSelect = onRoundWonAnnouncement:Select();
roundWonInfection = roundWonSelect:Add(
	function(context)
		if disableRoundLostVO then
			return true;
		else
			return false;
		end
	end
	);
roundWonBigWin = roundWonSelect:Add(
	function(context)
		if (enableBreakoutRoundAnnouncements ~= nil and enableBreakoutRoundAnnouncements) then
			return table.all(context.WinningPlayers, 
				function(player)
					local playerUnit = player:GetUnit();
					return playerUnit ~= nil and playerUnit:IsAlive();
				end
				);
		else
			return false;
		end
	end
	);
roundWonCloseWin = roundWonSelect:Add(
	function(context)
		if (enableBreakoutRoundAnnouncements ~= nil and enableBreakoutRoundAnnouncements) then
			local indexedAlivePlayers = table.filtervalues(context.WinningPlayers,
				function(player)
					local playerUnit = player:GetUnit();
					return playerUnit ~= nil and playerUnit:IsAlive(); 
				end
				);
			return #indexedAlivePlayers <= 1;
		else
			return context.Engine:SmallGap();
		end
	end
	);
roundWonStandard = roundWonSelect:Add();
roundWonInfectionWinnersResponse = roundWonInfection:Target(WinningPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_roundwon',
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverclose_win'
	});
roundWonInfectionLosersResponse = roundWonInfection:Target(LosingPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverclose_lose'
	});	
roundWonBigWinWinnersResponse = roundWonBigWin:Target(WinningPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundwonnodeaths', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverbig_win'
	});
roundWonBigWinLosersResponse = roundWonBigWin:Target(LosingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundoverroundlost', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverbig_lose'
	});	
roundWonCloseWinWinnersResponse = roundWonCloseWin:Target(WinningPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_roundwon', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverclose_win'
	});
roundWonCloseWinLosersResponse = roundWonCloseWin:Target(LosingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundoverroundlost', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundoverclose_lose'
	});	
roundWonStandardWinnersResponse = roundWonStandard:Target(WinningPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_roundwon', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundover_win'
	});
roundWonStandardLosersResponse = roundWonStandard:Target(LosingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundoverroundlost', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundover_lose'
	});	
roundWonImpulse = onRoundWonAnnouncement:Target(WinningPlayers):Response(
	{
		ImpulseEvent = 'impulse_round_won'
	});
onRoundTieAnnouncement = roundEndSelect:Add(
	function(context)
		return roundWonFlagCaptureAccumulator:GetValue() < 1;
	end
	);
roundTiedBreakoutResponse = onRoundTieAnnouncement:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundtied', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundover_neutral'
	});	
onMatchEndGapSelect = onMatchEnd:Select();
matchEndSmallGap = onMatchEndGapSelect:Add(SmallGap);
matchEndMediumGap = onMatchEndGapSelect:Add(MediumGap);
matchEndLargeGap = onMatchEndGapSelect:Add(LargeGap);
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
matchEndSmallGapWinnerResponse = matchEndSmallGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win'
	});
if alwaysPlayNeutralVOForMatchLoss then
matchEndSmallGapLoserResponse = matchEndSmallGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameover', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_lose'
	});
else
matchEndSmallGapLoserResponse = matchEndSmallGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_lose'
	});
end
function BuildSmallGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "SmallGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory', 
			Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win'
		});
end
matchEndSmallGapNeutralSelect = matchEndSmallGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();
GenerateTeamSpecificNeutralResponses(matchEndSmallGapNeutralSelect, BuildSmallGapNeutralResponse)
matchEndMediumGapWinnerResponse = matchEndMediumGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});
if alwaysPlayNeutralVOForMatchLoss then
matchEndMediumGapLoserResponse = matchEndMediumGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameover', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});
else
matchEndMediumGapLoserResponse = matchEndMediumGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});
end
function BuildMediumGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "MediumGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory', 
			Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
		});
end
matchEndMediumGapNeutralSelect = matchEndMediumGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();
GenerateTeamSpecificNeutralResponses(matchEndMediumGapNeutralSelect, BuildMediumGapNeutralResponse)
matchEndLargeGapWinnerResponse = matchEndLargeGap:Target(WinnersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
	});
if alwaysPlayNeutralVOForMatchLoss then
matchEndLargeGapLoserResponse = matchEndLargeGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameover', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose'
	});
else
matchEndLargeGapLoserResponse = matchEndLargeGap:Target(LosersTarget):Response(
	{
		OutOfGameEvent = true,
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose'
	});
end
function BuildLargeGapNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "LargeGapNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			OutOfGameEvent = true,
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamvictory', 
			Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
		});
end
matchEndLargeGapNeutralSelect = matchEndLargeGap:Emit(
	function(context)
		context.MatchingPlayers = WinnersTarget(context);
		return true;
	end
	):Select();
GenerateTeamSpecificNeutralResponses(matchEndLargeGapNeutralSelect, BuildLargeGapNeutralResponse)
matchEndTiedResponse = onMatchEnd:Target(TiedTarget):Response(
	{
		OutOfGameEvent = true,
		Sound = 'multiplayer\audio\announcer\announcer_shared_gametied', 
		Sound2 = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_neutral'
	});
__OnServerShutdownLastRound = Delegate:new();
onServerShutdownLastRound = root:AddCallback(
	__OnServerShutdownLastRound
	);
serverShutdownLastRoundResponse = onServerShutdownLastRound:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_last_round_arena'		
	});