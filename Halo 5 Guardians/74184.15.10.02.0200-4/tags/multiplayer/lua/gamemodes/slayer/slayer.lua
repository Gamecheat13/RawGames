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

-- Score events

__OnSlayerScore = Delegate:new();

onSlayerScore = root:AddCallback(
	__OnSlayerScore,
	function (context, scoringPlayer, deadPlayer, gainedLead, killsLeftToWin, totalKillsToWin, previousWinningPlayer)
		context.ScoringPlayer = scoringPlayer;
		context.TargetPlayer = scoringPlayer;
		context.DeadPlayer = deadPlayer;
		context.GainedLead = gainedLead;
		context.KillsLeftToWin = killsLeftToWin;
		context.TotalKillsToWin = totalKillsToWin;
		context.PreviousWinningPlayer = previousWinningPlayer;
	end
	);

onPositiveSlayerScore = onSlayerScore:Filter(
	function(context)
		return context.ScoringPlayer:IsHostile(context.DeadPlayer);
	end
	);

function AllPlayersFriendlyToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsFriendly(context.ScoringPlayer);
		end
		);

	return ret;
end

function AllPlayersHostileToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.ScoringPlayer);
		end
		);

	return ret;
end

function ScoringPlayer(context)
	return context.ScoringPlayer;
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

function NearingVictory(context)
	return FiveKillsToWin(context) or TenKillsToWin(context);
end

function FiveKillsToWin(context)
	return context.Engine:GetScoreToWinRound() < 30
	and context.KillsLeftToWin == 5;
end

function TenKillsToWin(context)
	return context.Engine:GetScoreToWinRound() >= 30
	and context.KillsLeftToWin == 10;
end

function HalfwayToVictory(context)
	if (context.Engine:GetScoreToWinRound() > 10) then
		if (context.TotalKillsToWin % 2 == 0) then
			return context.KillsLeftToWin == context.TotalKillsToWin / 2;
		else
			return context.KillsLeftToWin == (context.TotalKillsToWin - 1) / 2;
		end
	end
end

function RoundEndingByScore(context)
	if(context.TotalKillsToWin % 2 == 0) then
		return context.KillsLeftToWin == context.TotalKillsToWin / 10;
	else
		return context.KillsLeftToWin == (context.TotalKillsToWin - 1) / 10;
	end
end

function InClutchTime(context)
	return context.Engine:InClutchTime();
end
	
-- Clutch kill

clutchKillResponse = onPositiveSlayerScore:Filter(
	function (context)
		return InClutchTime(context) and (GameIsTied(context) or GainedLead(context));
	end
	):Target(ScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_clutchkill',
		Medal = 'clutch_kill'
	});

-- Gained lead

gainedLead = onSlayerScore:Filter(
	function (context)
		return GainedLead(context) and context.KillsLeftToWin > 0 and (context.TotalKillsToWin - context.KillsLeftToWin > 1);
	end
	);

gainedLeadWinningTeamResponse = gainedLead:Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});

gainedLeadLosingTeamResponse = gainedLead:Target(
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

-- Neutral Responses

function BuildGainedLeadNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "GainedLeadNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamgainedlead'
		});
end

gainedLeadNeutralSelect = gainedLead:Select();

GenerateTeamSpecificNeutralResponses(gainedLeadNeutralSelect, BuildGainedLeadNeutralResponse)

-- Kills to win

killsToWinSelect = onPositiveSlayerScore:Select();
oneKillToWin = killsToWinSelect:Add(OneKillToWin);
halfwayToVictory = killsToWinSelect:Add(HalfwayToVictory);
tenKillsToWin = killsToWinSelect:Add(TenKillsToWin); --only fire in high score to win games
fiveKillsToWin = killsToWinSelect:Add(FiveKillsToWin); --only fire in low score to win games

-- One Kill to win

oneKillToWinSelect = oneKillToWin:Select();

oneKillToWinTiedResponse = oneKillToWinSelect:Add(GameIsTied):Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_suddendeath'
	});

oneKillToWinNotTied = oneKillToWinSelect:Add();

oneKillToWinWinnersResponse = oneKillToWinNotTied:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorenextkillwins'
	});

oneKillToWinLosingResponse = oneKillToWinNotTied:Once():Target(AllPlayersHostileToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_slayer_enemykillstowin1'
	});

-- Enemy nearing victory responses

nearingVictoryEnemySelect = onPositiveSlayerScore:Filter(NearingVictory):Select();

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
		
-- 5 kills to win 

fiveKillsToWinWinnersResponse = fiveKillsToWin:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_5kills2win'
	});

-- 10 Kills to Win

tenKillsToWinWinnersResponse = tenKillsToWin:Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_score10killstowinself'
	});

-- 10 kills neutral response

function Build10KillsToWinNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "NearingVictoryNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamscorenearingvictory'
		});
end

tenKillsToWinNeutralSelect = tenKillsToWin:Select();

GenerateTeamSpecificNeutralResponses(tenKillsToWinNeutralSelect, Build10KillsToWinNeutralResponse)

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

-- Round Ending music, set to 80% of total score (10 kills to win in a normal slayer match)

roundEndingMusicWinnersResponse = onPositiveSlayerScore:Filter(RoundEndingByScore):Once():Target(AllPlayersFriendlyToScoringPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_winning_loop'
	});

roundEndingMusicLosersResponse = onPositiveSlayerScore:Filter(RoundEndingByScore):Once():Target(AllPlayersHostileToScoringPlayer):Response(
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
	Sound = 'multiplayer\audio\announcer\announcer_slayer_gameoverperfection',
	Medal = 'perfection',
	OutOfGameEvent = true
});

--
-- Game Saver
--

onGameSaver = onProtectorKill:Filter(
	function(context)
		return context.DeadPlayer:GetTeamScore() == context.Engine:GetScoreToWinRound() - 1;
	end
	);

gameSaverResponse = onGameSaver:Target(KillingPlayer):Response(
	{
		Medal = 'game_saver',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_gamesaverkill'
	});

--
-- Power Player 
--

powerPlayerAccumulator = root:CreatePlayerAccumulator();

onPowerPlayerKill = onEnemyPlayerKill:Filter(
	function(context)
		
		-- TODO: v-magro (5/28/15): HACK FOR CONAN to disable powerPlayer
		if disablePowerPlayer ~= nil and disablePowerPlayer then
			return false;
		end

		local killWithSword = table.any(SwordDamageSources,
			function(damageSource)
				return damageSource == context.DamageSource;
			end
			);

		if killWithSword == true then
			return true;
		end

		local killWithPowerWeapon = table.any(PowerWeaponDamageSources, 
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
		Medal = 'power_player',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_powerplayer'
	});

--
-- Top Gun
--

local TopGunScoreThreshold = 10;

topGunKillAccumulator = root:CreatePlayerAccumulator();

onTopGunKillCounter = onEnemyPlayerKill:PlayerAccumulator(
	topGunKillAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);

onTopGun = onTopGunKillCounter:Filter(
	function(context)

		if topGunKillAccumulator:GetValue(context.KillingPlayer) ~= TopGunScoreThreshold then
			return false;
		end 

		local allOtherPlayers = table.filter(context:GetAllPlayers(),
			function(player)
				return player ~= context.KillingPlayer;
			end
			);
		
		local allOtherPlayersBelowThreshold = table.all(allOtherPlayers,
			function(player)
				return topGunKillAccumulator:GetValue(player) < TopGunScoreThreshold;
			end
			);

		return allOtherPlayersBelowThreshold;
		
	end
	);

topGunResponse = onTopGun:Target(KillingPlayer):Response(
	{
		Medal = 'top_gun',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_topgun'
	});
