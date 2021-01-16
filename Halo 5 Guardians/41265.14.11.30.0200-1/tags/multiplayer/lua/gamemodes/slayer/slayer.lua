--
-- Slayer event definitions
--

--
-- Slayer Intro
--

__OnModeIntro = Delegate:new();

onModeIntro = root:AddCallback(
	__OnModeIntro
	);

modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_slayer'	
	});

slayerIntroChatter = onPlayerActivated:ObjectEvent(
	function (context)
		return context.ActivatedPlayer;
	end
	);

__OnModeDescription = Delegate:new();

onModeDescription = root:AddCallback(
	__OnModeDescription
	);

modeDescriptionResponse = onModeDescription:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_slayermodedescalternate'
	});

-- Score events

__OnSlayerScore = Delegate:new();

onSlayerScore = root:AddCallback(
	__OnSlayerScore,
	function (context, scoringPlayer, deadPlayer, gainedLead, killsLeftToWin, totalKillsToWin)
		context.ScoringPlayer = scoringPlayer;
		context.DeadPlayer = deadPlayer;
		context.GainedLead = gainedLead;
		context.KillsLeftToWin = killsLeftToWin;
		context.TotalKillsToWin = totalKillsToWin;
	end
	);

function AllPlayersFriendlyToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsFriendly(context.ScoringPlayer);
		end
		);

	Log("In AllPlayersFriendlyToScoringPlayer, ret: " .. tostring(ret));

	return ret;
end

function AllPlayersHostileToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.ScoringPlayer);
		end
		);

	Log("In AllPlayersHostileToScoringPlayer, ret: " .. tostring(ret));

	return ret;
end

function ScoringPlayer(context)
	return context.ScoringPlayer;
end

function WonRound(context)
	return context.Engine:WonRound();
end

function SmallGap(context)
	return context.Engine:SmallGap();
end

function MediumGap(context)
	return context.Engine:MediumGap();
end

function LargeGap(context)
	return context.Engine:LargeGap();
end

function GainedLead(context)
	return context.GainedLead;
end

function UpByOne(context)
	return context.ScoringPlayer:GetTeamScore() - context.DeadPlayer:GetTeamScore() == 1;
end

function GameIsTied(context)
	return context.Engine:GameIsTied();
end

function OneKillToWin(context)
	return context.KillsLeftToWin == 1;
end

function TenKillsToWin(context)
	return context.KillsLeftToWin == 10;
end

function HalfwayToVictory(context)
	if (context.TotalKillsToWin % 2 == 0) then
		return context.KillsLeftToWin == context.TotalKillsToWin / 2;
	else
		return context.KillsLeftToWin == (context.TotalKillsToWin + 1) / 2;
	end
end

function RoundEndingByScore(context)
	if(context.TotalKillsToWin % 2 == 0) then
		return context.KillsLeftToWin == context.TotalKillsToWin / 5;
	else
		return context.KillsLeftToWin == (context.TotalKillsToWin + 1) / 5;
	end
end

function InClutchTime(context)
	return context.Engine:InClutchTime();
end

wonRound = onSlayerScore:Filter(WonRound);
wonRoundChatter = wonRound:ObjectEvent(ScoringPlayer);

-- Chicken Dinner win 50-49

onChickenDinner = wonRound:Filter(UpByOne):Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_chicken_dinner',
		Medal = 'chicken_dinner'
	});
	
-- Clutch kill

onSlayerScore:Filter(
	function (context)
		return InClutchTime(context) and (GameIsTied(context) or GainedLead(context));
	end
	):Target(ScoringPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_clutchkill',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_killclutchkillgainlead',
		Medal = 'clutch_kill'
	});

-- Round won music
	
wonRoundGapSelect = wonRound:Select();
wonRoundSmallGap = wonRoundGapSelect:Add(SmallGap);
wonRoundMediumGap = wonRoundGapSelect:Add(MediumGap);
wonRoundLargeGap = wonRoundGapSelect:Add(LargeGap);

wonRoundSmallGap:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_win'
	});

wonRoundSmallGap:Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverclose_lose'
	});
	
wonRoundMediumGap:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});

wonRoundMediumGap:Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});
	
wonRoundLargeGap:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_win'
	});

wonRoundLargeGap:Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchoverbig_lose'
	});

-- Gained lead

gainedLead = onSlayerScore:Filter(
	function (context)
		return GainedLead(context) and context.KillsLeftToWin > 0 and (context.TotalKillsToWin - context.KillsLeftToWin > 1);
	end
	);

gainedLeadWinningTeamResponse = gainedLead:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});

gainedLeadLosingTeamResponse = gainedLead:Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorelostlead'
	});

-- Kills to win

killsToWinSelect = onSlayerScore:Select();
oneKillToWin = killsToWinSelect:Add(OneKillToWin);
halfwayToVictory = killsToWinSelect:Add(HalfwayToVictory);
tenKillsToWin = killsToWinSelect:Add(TenKillsToWin);

oneKillToWinSelect = oneKillToWin:Select();

oneKillToWinTiedResponse = oneKillToWinSelect:Add(GameIsTied):Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorenextkillwinsscoretied'
	});

oneKillToWinNotTied = oneKillToWinSelect:Add();

oneKillToWinWinnersResponse = oneKillToWinNotTied:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorenextkillwins'
	});

oneKillToWinLosingResponse = oneKillToWinNotTied:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_slayer_enemykillstowin1'
	});
		
-- 10 Kills to Win

tenKillsToWinWinnersResponse = tenKillsToWin:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_score10killstowinself'
	});

tenKillsToWinLosersResponse = tenKillsToWin:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_score10killstowinenemy'
	});

-- Halfway to victory

halfWayToVictoryWinnersResponse = halfwayToVictory:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorehalfwayself'
	});

halfWayToVictoryLosersResponse = halfwayToVictory:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorehalfwayenemy'
	});

-- Round Ending music, set to 80% of total score (10 kills to win in a normal slayer match)

roundEndingMusicWinnersResponse = onSlayerScore:Filter(RoundEndingByScore):Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_winning_loop'
	});

roundEndingMusicLosersResponse = onSlayerScore:Filter(RoundEndingByScore):Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_losing_loop'
	});

--
-- Perfection Medal
--

totalDeathsAccumulator = root:CreatePlayerAccumulator();

onPlayerDeathAccumulator = onPlayerDeath:PlayerAccumulator(
	totalDeathsAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);

perfectionBucket = onRoundEnd:Bucket(
	function (context)
		return context:GetAllPlayers();
	end,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
	
perfectionPostGameBucket = perfectionBucket:Add(
	function (context, player)
		return killsSinceDeathAccumulator:GetValue(player) >= 15
		and totalDeathsAccumulator:GetValue(player) == 0 
		and player:IsWinning() 
		and not player:IsTied();
	end
	);

perfectionResponse = perfectionPostGameBucket:Target(MatchingPlayers):Response(
{
	Fanfare = FanfareDefinitions.PersonalScore,
	FanfareText = 'flavor_perfection',
	Sound = 'multiplayer\audio\announcer\announcer_slayer_gameoverperfection',
	Medal = 'perfection'
});

--
-- Game Saver
--

onGameSaver = onProtectorKill:Filter(
	function(context)
		-- TODO: hack fix for preview until we get variant:GetScoreToWin() piped into lua
		return context.DeadPlayer:GetTeamScore() == 49;
	end
	);

gameSaverResponse = onGameSaver:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_game_saver',
		Medal = 'game_saver',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_gamesaverkill'
	});

--
-- Power Player 
--

powerPlayerAccumulator = root:CreatePlayerAccumulator();

onPowerPlayerKill = onEnemyPlayerKill:Filter(
	function(context)

		local killWithSword = table.any(swordDamageSources,
			function(damageSource)
				return damageSource == context.DamageSource;
			end
			);

		if killWithSword == true then
			return true;
		end

		local killWithPowerWeapon = table.any(powerWeaponDamageSources, 
			function(damageSource)
				return damageSource == context.DamageSource and context.DamageType ~= meleeDamageType;
			end
			);

		if not killWithPowerWeapon then
			return false;
		end

		return true;
	end
	);

onPowerPlayerCounter = onPowerPlayerKill:PlayerAccumulator(
	powerPlayerAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);

onPowerPlayer = onPowerPlayerCounter:Filter(
	function(context)
		return powerPlayerAccumulator:GetValue(context.KillingPlayer) % 10 == 0;
	end
	);

powerPlayerResponse = onPowerPlayer:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_power_player',
		Medal = 'power_player',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_powerplayer'
	});

--
-- Top Gun
--

local TopGunScoreThreshold = 10;

scoreAccumulator = root:CreatePlayerAccumulator();

onScoreCounter = onSlayerScore:PlayerAccumulator(
	scoreAccumulator,
	function(context)
		return context.ScoringPlayer;
	end
	);

onTopGun = onScoreCounter:Filter(
	function(context)

		if scoreAccumulator:GetValue(context.ScoringPlayer) ~= TopGunScoreThreshold then
			return false;
		end 

		local friendlyPlayers = table.filter(context:GetAllPlayers(),
			function(player)
				return player:IsFriendly(context.ScoringPlayer) and player ~= context.ScoringPlayer;
			end
			);
		
		local allFriendliesBelowThreshold = table.all(friendlyPlayers,
			function(player)
				return scoreAccumulator:GetValue(player) < TopGunScoreThreshold;
			end
			);

		if allFriendliesBelowThreshold ~= true then
			return false;
		end

		return true;
	end
	);

topGunResponse = onTopGun:Target(ScoringPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_top_gun',
		Medal = 'top_gun',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_topgun'
	});

--
-- Slayer Round Timeout
--

__OnSlayerRoundTimeout = Delegate:new();

onSlayerRoundTimeout = root:AddCallback(
	__OnSlayerRoundTimeout,
	function (context, winningPlayer)
		context.TargetPlayer = winningPlayer;
	end
	);

slayerRoundTimeoutSelect = onSlayerRoundTimeout:Select();

slayerRoundTimeoutTieResponse = slayerRoundTimeoutSelect:Add(GameIsTied):Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_neutral'
	});

slayerRoundTimeoutWinnerLoser = slayerRoundTimeoutSelect:Add();

slayerRoundTimeoutWinResponse = slayerRoundTimeoutWinnerLoser:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});
	
slayerRoundTimeoutWinTeamResponse = slayerRoundTimeoutWinnerLoser:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});
	
slayerRoundTimeoutLoseResponse = slayerRoundTimeoutWinnerLoser:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});
