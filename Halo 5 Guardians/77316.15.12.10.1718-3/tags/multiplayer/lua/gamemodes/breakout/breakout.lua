	
modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundstart'
	});
__OnOneOnOne = Delegate:new();
onOneOnOne = root:AddCallback(
	__OnOneOnOne
	);
oneOnOneAliveResponse = onOneOnOne:Target(AllAlivePlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v1'
	});
oneOnOneDeadResponse = onOneOnOne:Target(AllDeadPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v1'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_breakout\music_mp_breakout_oneonone_loop'
	});
__OnTwoOnOne = Delegate:new();
onTwoOnOne = root:AddCallback(
	__OnTwoOnOne,
	function (context, lastMan)
		context.TargetPlayer = lastMan;
	end
	);
twoOnOneWinnerAliveResponse = onTwoOnOne:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v1'
	});
twoOnOneWinnerDeadResponse = onTwoOnOne:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v1'
	});
twoOnOneLoserAliveResponse = onTwoOnOne:Target(FriendlyToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v2'
	});
twoOnOneLoserDeadResponse = onTwoOnOne:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v2'
	});
__OnTwoOnTwo = Delegate:new();
onTwoOnTwo = root:AddCallback(
	__OnTwoOnTwo
	);
twoOnTwoAliveResponse = onTwoOnTwo:Target(AllAlivePlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v2'
	});
twoOnTwoDeadResponse = onTwoOnTwo:Target(AllDeadPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v2'
	});
__OnThreeOnOne = Delegate:new();
onThreeOnOne = root:AddCallback(
	__OnThreeOnOne,
	function (context, lastMan)
		context.TargetPlayer = lastMan;
	end
	);
threeOnOneWinningAliveResponse = onThreeOnOne:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v1'
	});
threeOnOneWinningDeadResponse = onThreeOnOne:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v1'
	});
threeOnOneLosingAliveResponse = onThreeOnOne:Target(FriendlyToTargetAlive):Response(
	{		
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v3'
	});
threeOnOneLosingDeadResponse = onThreeOnOne:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v3'
	});	
__OnThreeOnTwo = Delegate:new();
onThreeOnTwo = root:AddCallback(
	__OnThreeOnTwo,
	function (context, teamTwo)
		context.TargetPlayer = teamTwo;
	end
	);
threeOnTwoWinnerAliveResponse = onThreeOnTwo:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v2'
	});
threeOnTwoWinnerDeadResponse = onThreeOnTwo:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v2'
	});
threeOnTwoLoserAliveResponse = onThreeOnTwo:Target(FriendlyToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v3'
	});
threeOnTwoLoserDeadResponse = onThreeOnTwo:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v3'
	});
__OnThreeOnThree = Delegate:new();
onThreeOnThree = root:AddCallback(
	__OnThreeOnThree
	);
threeOnThreeAliveResponse = onThreeOnThree:Target(AllAlivePlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v3'
	});
threeOnThreeDeadResponse = onThreeOnThree:Target(AllDeadPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v3'
	});
__OnFourOnTwo = Delegate:new();
onFourOnTwo = root:AddCallback(
	__OnFourOnTwo,
	function (context, teamTwo)
		context.TargetPlayer = teamTwo;
	end
	);
fourOnTwoWinnerAliveResponse = onFourOnTwo:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v2'
	});
fourOnTwoWinnerDeadResponse = onFourOnTwo:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v2'
	});
fourOnTwoLoserAliveResponse = onFourOnTwo:Target(FriendlyToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v4'
	});
fourOnTwoLoserDeadResponse = onFourOnTwo:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat2v4'
	});
__OnFourOnOne = Delegate:new();
onFourOnOne = root:AddCallback(
	__OnFourOnOne,
	function (context, lastMan)
		context.TargetPlayer = lastMan;
	end
	);
fourOnOneWinnerAliveResponse = onFourOnOne:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v1'
	});
fourOnOneWinnerDeadResponse = onFourOnOne:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v1'
	});
fourOnOneLoserDeadResponse = onFourOnOne:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v4'
	});	
__OnLastManStanding = Delegate:new();
onLastManStanding = root:AddCallback(
	__OnLastManStanding,
	function(context, lastMan)
		context.TargetPlayer = lastMan;
	end
	);
lastManStandingResponse = onLastManStanding:OnceUntil(nil, onRoundStart):Target(FriendlyToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat1v4'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_breakout\music_mp_breakout_oneonone_loop'
	});
__OnFourOnThree = Delegate:new();
onFourOnThree = root:AddCallback(
	__OnFourOnThree,
	function (context, teamThree)
		context.TargetPlayer = teamThree;
	end
	);
fourOnThreeWinnerAliveResponse = onFourOnThree:Target(HostileToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v3'
	});
fourOnThreeWinnerDeadResponse = onFourOnThree:Target(HostileToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat4v3'
	});
fourOnThreeLoserAliveResponse = onFourOnThree:Target(FriendlyToTargetAlive):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v4'
	});
fourOnThreeLoserDeadResponse = onFourOnThree:Target(FriendlyToTargetDead):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_rosterheartbeat3v4'
	});
function FilterSurvivedRound(context)
	return table.filtervalues(context:GetAllPlayers(),
		function (player)
			return PlayerIsAlive(player);
		end
		);
end
onRoundSurvived = onRoundEnd:Emit(
	function(context)
		context.TargetPlayer = FilterSurvivedRound(context);
	end
	):Filter(
	function(context)
		return context.TargetPlayer ~= nil;
	end
	):Target(TargetPlayer):Response(
		{
			ImpulseEvent = 'impulse_round_survived'
		});
survivalSpreeAccumulator = root:CreatePlayerAccumulator();
onConsecutiveRoundsSurvived = onRoundEnd:PlayerAccumulator(
	survivalSpreeAccumulator,
	FilterSurvivedRound
	);
onPlayerDeath:ResetPlayerAccumulator(
	survivalSpreeAccumulator,
	function (context)
	 	return context.DeadPlayer;
	end
	);
roundSurvivorBucket = onConsecutiveRoundsSurvived:Bucket(
	FilterSurvivedRound,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);	
surviveAllRoundsBucket = roundSurvivorBucket:Add(
	function (context, player)
		local variant = FindVariant(context);
		local scores = context:GetSortedTeamsRoundsWon();
		if scores == nil or scores[1] == nil then
			return false;
		end
		local winningTeamRoundsWon = scores[1];
		local roundsToWin = variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount();
		local survivalSpree = survivalSpreeAccumulator:GetValue(player);
		local currentRound = context.Engine:GetRound() + 1;
		return winningTeamRoundsWon == roundsToWin and survivalSpree == currentRound;
	end
	);
breakoutGameSurvivorResponse = surviveAllRoundsBucket:Target(MatchingPlayers):Response(
	{
		OutOfGameEvent = true,
		Medal = 'immortal'
	});	
survivorSpreeBucket = roundSurvivorBucket:Add(
	function (context, player)
		return survivalSpreeAccumulator:GetValue(player) % 3 == 0;
	end
	);
survivorSpreeResponse = survivorSpreeBucket:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundoversurvivorspree',
		Medal = 'survivor_spree'
	});	 
survivorBucket = roundSurvivorBucket:Add(
	);	
blindSideResponse = onBlindSide:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_finalassassinationalt2',
		Medal = 'blind_side'
	}); 
extinctionAccumulator = root:CreatePlayerAccumulator();
extinctionCounter = onEnemyPlayerKill:PlayerAccumulator(
	extinctionAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);
onExtinction = extinctionCounter:Filter(
	function(context)
		return extinctionAccumulator:GetValue(context.KillingPlayer) == 4;
	end
	);
onRoundStart:ResetAccumulator(extinctionAccumulator);
extinctionResponse = onExtinction:Target(KillingPlayer):Response(
	{
		Medal = 'extinction'
	});
function KillingPlayerHasNoAliveTeammates(context)
	return table.all(context:GetAllPlayers(),
		function(player)
			if player == context.KillingPlayer then
				return true;
			end
			return not PlayerIsAlive(player) or not player:IsFriendly(context.KillingPlayer);
		end);
end
onLastManKill = onKill:Filter(KillingPlayerHasNoAliveTeammates):Emit(
	function (context)
		context.LastManStanding = context.KillingPlayer;
	end
	);
function LastManStanding(context)
	return context.LastManStanding;
end
lastManKillAccumulator = root:CreatePlayerAccumulator();
onLastManKillCounter = onLastManKill:PlayerAccumulator(
	lastManKillAccumulator,
	function (context)
		return context.LastManStanding;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	lastManKillAccumulator,
	 function (context)
	 	return context.DeadPlayer;
	 end
	 );
onRoundStart:ResetAccumulator(lastManKillAccumulator);
onEndOfRoundForLastMan = onRoundEnd:Emit(
	function (context)
		context.LastManStanding = table.first(context:GetAllPlayers(),
				function (player)
					return lastManKillAccumulator:GetValue(player) > 0;
				end
				);
	end
	):Filter(
	function (context)
		return context.LastManStanding ~= nil;
	end
	);
lastManKillTypeSelect = onEndOfRoundForLastMan:Select();	
on1v4Kill = lastManKillTypeSelect:Add(
	function (context)
		return lastManKillAccumulator:GetValue(context.LastManStanding) == 4;
	end
	);
superfectaResponse = on1v4Kill:Target(LastManStanding):Response(
	{
		Medal = 'bk_one_on_four_win'
	});
on1v3Kill = lastManKillTypeSelect:Add(
	function (context)
		return lastManKillAccumulator:GetValue(context.LastManStanding) == 3;
	end
	);
trifectaResponse = on1v3Kill:Target(LastManStanding):Response(
	{
		Medal = 'bk_one_on_three_win'
	});
on1v2Kill = lastManKillTypeSelect:Add(
	function (context)
		return lastManKillAccumulator:GetValue(context.LastManStanding) == 2;
	end
	);
bifectaResponse = on1v2Kill:Target(LastManStanding):Response(
	{
		Medal = 'bk_one_on_two_win'
	});	
on1v1Kill = lastManKillTypeSelect:Add(
	function (context)
		return lastManKillAccumulator:GetValue(context.LastManStanding) == 1;
	end
	); 	
vanquisherResponse = on1v1Kill:Target(LastManStanding):Response(
	{
		Medal = 'bk_one_on_one_win'
	});
onLastManKill:Target(LastManStanding):Response(
	{
		ImpulseEvent = 'impulse_kill_as_last_man'
	});
tripleThreatGunAccumulator = root:CreatePlayerAccumulator();
tripleThreatGrenadeAccumulator = root:CreatePlayerAccumulator();
tripleThreatMeleeAccumulator = root:CreatePlayerAccumulator();
tripleThreatGunCounter = onEnemyPlayerKill:Filter(
	function(context)
		return context.DamageType == bulletDamageType;
	end
	):PlayerAccumulator(
		tripleThreatGunAccumulator,
		function(context)
			return context.KillingPlayer;
		end
		);
tripleThreatMeleeCounter = onEnemyPlayerKill:Filter(
	function(context)
		return context.DamageType == meleeDamageType;
	end
	):PlayerAccumulator(
		tripleThreatMeleeAccumulator,
		function(context)
			return context.KillingPlayer;
		end
		);
tripleThreatGrenadeCounter = onEnemyPlayerKill:Filter(
	function(context)
		return table.any(GrenadeDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	):PlayerAccumulator(
		tripleThreatGrenadeAccumulator,
		function(context)
			return context.KillingPlayer;
		end
		);
onRoundStart:ResetAccumulator(tripleThreatGunAccumulator);
onRoundStart:ResetAccumulator(tripleThreatGrenadeAccumulator);
onRoundStart:ResetAccumulator(tripleThreatMeleeAccumulator);
onTripleThreat = onEnemyPlayerKill:Filter(
	function(context)
		return tripleThreatGunAccumulator:GetValue(context.KillingPlayer) >= 1
		and tripleThreatGrenadeAccumulator:GetValue(context.KillingPlayer) >= 1
		and tripleThreatMeleeAccumulator:GetValue(context.KillingPlayer) >= 1
	end
	);
tripleThreatResponse = onTripleThreat:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_triplethreat',
		Medal = 'triple_threat'
	});
roundWonFlagCaptureAccumulator = root:CreateAccumulator();
onRoundStart:ResetAccumulator(roundWonFlagCaptureAccumulator);
roundWonFlagCaptureCounter = onFlagCapture:Accumulator(roundWonFlagCaptureAccumulator);
roundWonFlagCaptureResponse = onFlagCapture:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundover_win',
		ImpulseEvent = 'impulse_round_won'
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_roundwon'
	});
roundLostFlagCaptureResponse = onFlagCapture:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundover_lose'
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_breakout_roundoverroundlost'
	});
function HostileToWinningTeamOneWinFromVictory(context)
	if(context.WinningPlayers == nil) then
		return false;
	end
	local firstWinningPlayer = table.first(context.WinningPlayers, 
	function(player)
		return player;
	end
	);
	return firstWinningPlayer ~= nil and table.any(context:GetAllPlayers(),
		function(player)
			local variant = FindVariant(context);
			return player:IsHostile(firstWinningPlayer) and player:GetRoundsWonCount() == variant:GetMiscellaneousOptions():GetEarlyVictoryRoundCount() - 1;
		end
		);
end
onRoundWonAnnouncement:Filter(HostileToWinningTeamOneWinFromVictory):Target(WinningPlayers):Response(
	{
		ImpulseEvent = 'impulse_round_won_facing_elimination'
	});
onFlagCapture:Filter(HostileToWinningTeamOneWinFromVictory):Target(WinningPlayers):Response(
	{
		ImpulseEvent = 'impulse_round_won_facing_elimination'
	});
local fastBreakSeconds = 15.0; --10 seconds to the user (5 second round start buffer)
fastBreakAccumulator = root:CreateAccumulator(fastBreakSeconds);
onFastBreakRoundStart = onRoundStart:Accumulator(fastBreakAccumulator);
onFastBreak = onEnemyPlayerKill:Filter(
	function(context)
		return fastBreakAccumulator:GetValue() == 1
	end
	);
onRoundEndAnnouncement:ResetAccumulator(fastBreakAccumulator);
fastBreakResponse = onFastBreak:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_quickkill',
		Medal = 'fast_break'
	});
onRegularEnemyBreakoutKill = onEnemyPlayerKill:Filter(
	function (context)
		local aliveHostileBreakoutPlayers = table.filtervalues(context:GetAllPlayers(),
			function (player)
				return PlayerIsAlive(player) and player:IsHostile(context.KillingPlayer);
			end
			);
		return #aliveHostileBreakoutPlayers >= 2;
	end
	);
regularEnemyKillBreakoutKillerResponse = onRegularEnemyBreakoutKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_enemydie'
	});
regularEnemyKillBreakoutKillTeamResponse = onRegularEnemyBreakoutKill:Target(FriendlyToKillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_enemydie'
	});
regularEnemyKillBreakoutDeadTeamResponse = onRegularEnemyBreakoutKill:Target(HostileToKillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_teammatedie'
	});
onLastEnemyBreakoutKill = onEnemyPlayerKill:Filter(
	function (context)
		local aliveHostileBreakoutPlayers = table.filtervalues(context:GetAllPlayers(),
			function (player)
				return PlayerIsAlive(player) and player:IsHostile(context.KillingPlayer);
			end
			);
		return #aliveHostileBreakoutPlayers == 1;
	end
	);
lastEnemyKillBreakoutKillerResponse = onLastEnemyBreakoutKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_lastenemy'
	});
lastEnemyKillBreakoutKillTeamResponse = onLastEnemyBreakoutKill:Target(FriendlyToKillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_lastenemy'
	});
lastEnemyKillBreakoutDeadTeamResponse = onLastEnemyBreakoutKill:Target(HostileToKillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_breakout_lastteammate'
	});
roundWinningKillImpulse = onLastEnemyBreakoutKill:Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'impulse_round_winning_kill'
	});
onLastEnemyBreakoutKill:Filter(
	function(context)
		return context.DeadPlayer:IsFlagCarrier()
	end
	):Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'impulse_round_winning_carrier_kill'
	});
killsInBreakoutRoundAccumulator = root:CreateAccumulator();
onKillsInRound = onEnemyPlayerKill:Accumulator(killsInBreakoutRoundAccumulator);
onFirstKillInRound = onKillsInRound:Filter(
	function (context)
		return killsInBreakoutRoundAccumulator:GetValue() == 1;
	end
	);
onRoundStart:ResetAccumulator(killsInBreakoutRoundAccumulator);
firstEnemyBreakoutKillImpulse = onFirstKillInRound:Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'impulse_first_kill_in_round'
	});
	