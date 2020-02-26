
-- Campaign medals

function CalculateDynamicScore(baseScore)
	return function(context)
		--Log("CalculateDynamicScore");
        local points = baseScore * context.Engine:GetScoreMultiplier();

		if(points < 0) then
			local currentScore = context.KillingPlayer:GetBigScore();
			if(currentScore + points < 0) then
				points = (-1 * currentScore);
			end
		end

		return points;
    end
end

function CalculateDynamicScoreDifficultyOnly(baseScore)
	return function(context)
        local points = baseScore * context.Engine:GetDifficultyScoreMultiplier();

		if(points < 0) then
			local currentScore = context.KillingPlayer:GetBigScore();
			if(currentScore + points < 0) then
				points = (-1 * currentScore);
			end
		end

		return points;
    end
end

function CalculateDynamicScoreForDeadPlayer(baseScore)
	return function(context)
        local points = baseScore * context.Engine:GetScoreMultiplier();

		if(points < 0) then
			local currentScore = context.DeadPlayer:GetBigScore();
			if(currentScore + points < 0) then
				points = (-1 * currentScore);
			end
		end

		return points;
    end
end

function CalculateDynamicScoreNumber(multiplier, baseScore)
	--Log("CalculateDynamicScore");
	local points = baseScore * multiplier;
	return points;
end


--KILL RESPONSE FOR PLAYER
		
		
GruntKillResponse = onGruntKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'grunt_kill',	
	Score = CalculateDynamicScore(150),	
});		
		
JackalKillResponse = onJackalKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,	
	Medal = 'jackal_kill',	
	Score = CalculateDynamicScore(300),	
});		
		
HunterKillResponse = onHunterKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'hunter_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
SentinelKillResponse = onSentinelKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'crawler_kill',	
	Score = CalculateDynamicScore(75),	
});		
		
EliteKillResponse = onEliteKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'elite_kill',	
	Score = CalculateDynamicScore(750),	
});		
		
TurretKillResponse = onTurretKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(450),	
});		
		
MongooseKillResponse = onMongooseKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'mongoose_destruction',	
	Score = CalculateDynamicScore(450),	
});		
		
WarthogKillResponse = onWarthogKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'warthog_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
ScorpionKillResponse = onScorpionKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'scorpion_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
RevenantKillResponse = onRevenantKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'ghost_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
SeraphKillResponse = onSeraphKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(1500),	
});		
		
		
		
		
		
		
		
		
		
		
WatchtowerKillResponse = onWatchtowerKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'jackal_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
GhostKillResponse = onGhostKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'ghost_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
WraithKillResponse = onWraithKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wraith_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
BansheeKillResponse = onBansheeKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),3750) ); end,	
	Medal = 'banshee_destruction',	
	Score = CalculateDynamicScore(3750),	
});		
		
PhantomKillResponse = onPhantomKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'phantom_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
GunTowerKillResponse = onGunTowerKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(7500),	
});		
		
TuningForkKillResponse = onTuningForkKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(7500),	
});		
		
MantisKillResponse = onMantisKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'mantis_destruction',	
	Score = CalculateDynamicScore(7500),	
});

WaspKillResponse = onWaspKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wasp_destruction',	
	Score = CalculateDynamicScore(7500),	
});
		
PhaetonKillResponse = onPhaetonKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vtol_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
BishopKillResponse = onBishopKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'watcher_kill',	
	Score = CalculateDynamicScore(150),	
});		
		
KnightKillResponse = onKnightKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'knight_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
PawnKillResponse = onPawnKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'crawler_kill',	
	Score = CalculateDynamicScore(75),	
});		
		
SoldierKillResponse = onSoldierKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'soldier_kill',	
	Score = CalculateDynamicScore(750),	
});		
		
wardenKillResponse = onWardenKillByPlayer:Target(KillingPlayer):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),10000) ); end,	
	Medal = 'warden_kill',	
	Score = CalculateDynamicScore(10000),	
});		



--MUSKETEERS
	
GruntKillResponse = onGruntKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'grunt_kill',	
	Score = CalculateDynamicScore(150),	
});		
		
JackalKillResponse = onJackalKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,	
	Medal = 'jackal_kill',	
	Score = CalculateDynamicScore(300),	
});		
		
HunterKillResponse = onHunterKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'hunter_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
SentinelKillResponse = onSentinelKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'crawler_kill',	
	Score = CalculateDynamicScore(75),	
});		
		
EliteKillResponse = onEliteKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'elite_kill',	
	Score = CalculateDynamicScore(750),	
});		
		
TurretKillResponse = onTurretKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(450),	
});		
		
MongooseKillResponse = onMongooseKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'mongoose_destruction',	
	Score = CalculateDynamicScore(450),	
});		
		
WarthogKillResponse = onWarthogKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'warthog_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
ScorpionKillResponse = onScorpionKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'scorpion_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
RevenantKillResponse = onRevenantKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'ghost_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
SeraphKillResponse = onSeraphKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(1500),	
});		
		
		
		
		
		
		
		
		
		
		
WatchtowerKillResponse = onWatchtowerKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'jackal_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
GhostKillResponse = onGhostKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'ghost_destruction',	
	Score = CalculateDynamicScore(1500),	
});		
		
WraithKillResponse = onWraithKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wraith_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
BansheeKillResponse = onBansheeKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),3750) ); end,	
	Medal = 'banshee_destruction',	
	Score = CalculateDynamicScore(3750),	
});		
		
PhantomKillResponse = onPhantomKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'phantom_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
GunTowerKillResponse = onGunTowerKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(7500),	
});		
		
TuningForkKillResponse = onTuningForkKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vehicle_destroyed',	
	Score = CalculateDynamicScore(7500),	
});		
		
MantisKillResponse = onMantisKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'mantis_destruction',	
	Score = CalculateDynamicScore(7500),	
});		

WaspKillResponse = onWaspKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wasp_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
PhaetonKillResponse = onPhaetonKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'vtol_destruction',	
	Score = CalculateDynamicScore(7500),	
});		
		
BishopKillResponse = onBishopKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'watcher_kill',	
	Score = CalculateDynamicScore(150),	
});		
		
KnightKillResponse = onKnightKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'knight_kill',	
	Score = CalculateDynamicScore(1500),	
});		
		
PawnKillResponse = onPawnKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'crawler_kill',	
	Score = CalculateDynamicScore(75),	
});		
		
SoldierKillResponse = onSoldierKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'soldier_kill',	
	Score = CalculateDynamicScore(750),	
});		
		
wardenKillResponse = onWardenKillByMusketeer:Target(TargetAllPlayers):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),10000) ); end,	
	Medal = 'warden_kill',	
	Score = CalculateDynamicScore(10000),	
});		



--SCORING MULTIKILL (PLAYERS)
		
		
		
doubleKillResponse = onTwoKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'double_kill',
		Score = CalculateDynamicScore(300),
	});	
		
tripleKillResponse = onThreeKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),400) ); end,
		Medal = 'triple_kill',
		Score = CalculateDynamicScore(400),
	});	
		
overkillResponse = onFourKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),500) ); end,
		Medal = 'overkill',
		Score = CalculateDynamicScore(500),
	});	
		
killtacularResponse = onFiveKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),700) ); end,
		Medal = 'killtacular',
		Score = CalculateDynamicScore(700),
	});	
		
killtrocityResponse = onSixKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),900) ); end,
		Medal = 'killtrocity',
		Score = CalculateDynamicScore(900),
	});	
		
killimanjaroResponse = onSevenKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1100) ); end,
		Medal = 'killamanjaro',
		Score = CalculateDynamicScore(1100),
	});	
		
killtastropheResponse = onEightKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,
		Medal = 'killtastrophe',
		Score = CalculateDynamicScore(1500),
	});	
		
killpocalypseResponse = onNineKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),2000) ); end,
		Medal = 'killpocalypse',
		Score = CalculateDynamicScore(2000),
	});	
		
killionaireResponse = onTenKillsInARow:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),2500) ); end,
		Medal = 'killionaire',
		Score = CalculateDynamicScore(2500),
	});	
		



--SCORING KILLTYPES (PLAYERS)
		
		
		
		
		
		
		
		
friendlyAIKillResponse = onFriendlyAIKillFromPlayer:Target(KillingPlayer):Response(	
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function(context)
		return FormatText('campaign_negative_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),-500) ); end,
		--
		Score = CalculateDynamicScore(-500),
	});	
		
betrayalCauseResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function(context)
		return FormatText('campaign_negative_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),-1500) ); end,
		--
		Score = CalculateDynamicScore(-1500),
	});	
		

playerDeathResponse = onPlayerDied:Target(DeadPlayer):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function(context)
		return FormatText('campaign_negative_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),-750) ); end,
		--
		Score = CalculateDynamicScoreForDeadPlayer(-750),
	});	
	

		
assistResponse = onPlayerAssist:Target(AssistingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,
		Medal = 'assist',
		Score = CalculateDynamicScore(75),
	});	
		
wingmanResponse = onFiveAssistsSinceDeath:Target(AssistingPlayer):Response(		
	 {	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,
		Medal = 'wingman',
		Score = CalculateDynamicScore(75),
	 });	
		
sayonaraResponse = onFallingKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
		
		Medal = 'sayonara',
		Score = CalculateDynamicScore(750),
		});
		
airsassinationResponse = onAirAssassination:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,
		Medal = 'airsassination_kill',
		Score = CalculateDynamicScore(1500),
	});	
		
assassinationResponse = onAssassination:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
		Medal = 'assassination_kill',
		Score = CalculateDynamicScore(750),
	});	
		
rocketKillResponse = onRocketLaucherKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'rocket_kill',
		Score = CalculateDynamicScore(300),
	});	
		
shotgunKillResponse = onShotgunKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'shotgunkill',
		Score = CalculateDynamicScore(300),
	});	
		
airborneSnapshotResponse = onAirborneSnapshot:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
		Medal = 'airborne_snapshot',
		Score = CalculateDynamicScore(750),
	});	
		
snapshotResponse = onSnapshot:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),600) ); end,
		Medal = 'snapshot',
		Score = CalculateDynamicScore(600),
	});	
		
sniperHeadshotKillResponse = onSniperHeadshotKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),600) ); end,
		Medal = 'sniper_headshot',
		Score = CalculateDynamicScore(600),
		
	});	
		
sniperKillResponse = onSniperKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'sniper_kill',
		Score = CalculateDynamicScore(300),
	});	
		
headshotKillResponse = onHeadshotKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'headshot_kill',
		Score = CalculateDynamicScore(300),
		
	});	
		
stuckResponse = onStuck:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),600) ); end,
		Medal = 'stuck',
		Score = CalculateDynamicScore(600),
	});	
		
grenadeKillResponse = onGrenadeKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'grenade_kill',
		Score = CalculateDynamicScore(300),
	});	
		
swordKillResponse = onSwordKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'sword_kill',
		Score = CalculateDynamicScore(300),
	});

hammerKillResponse = onHammerKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'hammer_kill',
		Score = CalculateDynamicScore(300),
	});
		
beatdownResponse = onMeleeFromBehind:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'beatdown_kill',
		Score = CalculateDynamicScore(300),
		
	});	
		
meleeKillResponse = onMeleeKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'melee_kill',
		Score = CalculateDynamicScore(300),
	});	
		
groundPoundKillResponse = onGroundPoundKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'ground_pound_kill',
		Score = CalculateDynamicScore(300),
	});	
		
shoulderBashKillResponse = onShoulderBashKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'shoulder_bash_kill',
		Score = CalculateDynamicScore(300),
	});	
		
needlerKillMedalResponse = onNeedlerKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'supercombine_kill',
		Score = CalculateDynamicScore(300),
	});	

hydraKillResponse = onHydraKill:Target(KillingPlayer):Response(		
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'hydra_kill',
		Score = CalculateDynamicScore(300),
	});	

beamRifleKillMedalResponse = onBeamRifleKill:Target(KillingPlayer):Response(	
	{	
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'beam_rifle_kill',
		Score = CalculateDynamicScore(300),
	});	

binaryRifleKillMedalResponse = onBinaryRifleKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'binary_rifle_kill',		
		Score = CalculateDynamicScore(300),
	});	

incinerationKillMedalResponse = onIncinerationKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'incineration_kill',
		Score = CalculateDynamicScore(300),	
	});


plasmaCasterMedalResponse = onPlasmaCasterKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'plasma_caster_kill',
		Score = CalculateDynamicScore(300),
	});


railgunMedalResponse = onRailgunKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'railgun_kill',
		Score = CalculateDynamicScore(300),
	});
	
	
sawKillMedalResponse = onSawKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'saw_kill',
		Score = CalculateDynamicScore(300),
	});
	

scattershotKillMedalResponse = onScattershotKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'scattershot_kill',
		Score = CalculateDynamicScore(300),	
	});


splaserKillMedalResponse = onSplaserKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
		Medal = 'splaser_kill',
		Score = CalculateDynamicScore(300),
	});


--SCORING SPREE (PLAYERS)

hatTrickResponse = onThreeConsecutiveHeadshots:Target(KillingPlayer):Response(		
	{	
		Medal = 'hat_trick',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
killingSpreeResponse = onFiveKillsSinceDeath:Target(KillingPlayer):Response(		
 {		
		Medal = 'killing_spree',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
killingFrenzyResponse = onTenKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'killing_frenzy',
		Score = CalculateDynamicScore(450),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,
	});	
		
runningRiotResponse = onFifteenKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'running_riot',
		Score = CalculateDynamicScore(600),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),600) ); end,
	});	
		
rampageResponse = onTwentyKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'rampage',
		Score = CalculateDynamicScore(750),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
	});	
		
untouchableResponse = onTwentyFiveKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'untouchable',
		Score = CalculateDynamicScore(900),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),900) ); end,
	});	
		
invincibleResponse = onThirtyKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'invicible',
		Score = CalculateDynamicScore(1050),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1050) ); end,
	});	
		
inconceivableResponse = onThirtyFiveKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'inconceivable',
		Score = CalculateDynamicScore(1200),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1200) ); end,
	});	
		
unfrigginbelievResponse = onFourtyKillsSinceDeath:Target(KillingPlayer):Response(		
	{	
		Medal = 'unfrigginbelievable',
		Score = CalculateDynamicScore(1350),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1350) ); end,
	});	




--SCORING OTHER
retributionResponse = onRetribution:Target(KillingPlayer):Response(		
	 {	
		Medal = 'retribution',
		Score = CalculateDynamicScore(1500),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,
	 });	
		
killFromTheGraveResponse = onKillFromTheGrave:Target(KillingPlayer):Response(		
	{	
		Medal = 'kill_from_the_grave',
		Score = CalculateDynamicScore(1500),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,
	});	
		
showstopperResponse = onShowStopper:Target(KillingPlayer):Response(		
	{	
		Medal = 'showstopper',
		Score = CalculateDynamicScore(75),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),showstopper) ); end,
	});	
		
cliffhangerResponse = onCliffhanger:Target(KillingPlayer):Response(		
	{	
		Medal = 'cliffhanger',
		Score = CalculateDynamicScore(750),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
	});	
		
battleRifleLongshotResponse = onBattleRifleLongshot:Target(KillingPlayer):Response(		
	{	
		Medal = 'longshot',
		Score = CalculateDynamicScore(150),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,
	});	
		
dmrLongshotResponse = onDMRLongshot:Target(KillingPlayer):Response(		
	{	
		Medal = 'longshot',
		Score = CalculateDynamicScore(150),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,
	});	
		
magnumLongshotResponse = onMagnumLongshot:Target(KillingPlayer):Response(		
	{	
		Medal = 'longshot',
		Score = CalculateDynamicScore(150),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,
	});	
		
sniperLongshotResponse = onSniperLongshot:Target(KillingPlayer):Response(		
	{	
		Medal = 'longshot',
		Score = CalculateDynamicScore(150),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,
	});	
		
rocketMaryResponse = onRocketMary:Target(KillingPlayer):Response(		
	{	
		Medal = 'rocket_mary',
		Score = CalculateDynamicScore(750),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,
	});	
		
hailMaryResponse = onHailMary:Target(KillingPlayer):Response(		
	{	
		Medal = 'hail_mary',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
sprayPrayResponse = onSprayPray:Target(KillingPlayer):Response(		
	{	
		Medal = 'spray_and_pray',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
clusterLuckResponse = onClusterLuck:Target(KillingPlayer):Response(		
	{	
		Medal = 'clusterluck',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
bulltrueResponse = onBulltrue:Target(KillingPlayer):Response(		
	{	
		Medal = 'bulltrue',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
twoKillsOneShotResponse = onTwoKillsOneShot:Target(KillingPlayer):Response(		
	{	
		Medal = 'sniperdoubleshot',
		Score = CalculateDynamicScore(1000),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1000) ); end,
	});	
		
hardTargetResponse = onTenShieldsRechargedSinceDeath:Target(TargetPlayer):Response(		
	{	
		Medal = 'hard_target',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	
		
splatterResponse = onGenericSplatter:Target(KillingPlayer):Response(		
	{	
		Medal = 'splatter_kill',
		Score = CalculateDynamicScore(300),
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText =function(context)
		return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,
	});	

	
	
	
	
WheelmanGruntKillResponse = onGruntKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(150),	
});		
		
WheelmanJackalKillResponse = onJackalKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),300) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(300),	
});		
		
WheelmanHunterKillResponse = onHunterKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanSentinelKillResponse = onSentinelKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(75),	
});		
		
WheelmanEliteKillResponse = onEliteKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(750),	
});		
		
WheelmanTurretKillResponse = onTurretKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(450),	
});		
		
WheelmanMongooseKillResponse = onMongooseKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),450) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(450),	
});		
		
WheelmanWarthogKillResponse = onWarthogKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanScorpionKillResponse = onScorpionKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanRevenantKillResponse = onRevenantKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanSeraphKillResponse = onSeraphKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
	
WheelmanWatchtowerKillResponse = onWatchtowerKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanGhostKillResponse = onGhostKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanWraithKillResponse = onWraithKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanBansheeKillResponse = onBansheeKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),3750) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(3750),	
});		
		
WheelmanPhantomKillResponse = onPhantomKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanGunTowerKillResponse = onGunTowerKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanTuningForkKillResponse = onTuningForkKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanMantisKillResponse = onMantisKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});

WheelmanWaspKillResponse = onWaspKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});
		
WheelmanPhaetonKillResponse = onPhaetonKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),7500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(7500),	
});		
		
WheelmanBishopKillResponse = onBishopKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),150) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(150),	
});		
		
WheelmanKnightKillResponse = onKnightKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),1500) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(1500),	
});		
		
WheelmanPawnKillResponse = onPawnKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),75) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(75),	
});		
		
WheelmanSoldierKillResponse = onSoldierKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),750) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(750),	
});		
		
WheelmanwardenKillResponse = onWardenKillByPlayer:Target(FindWheelman):Response(		
{		
	Fanfare = FanfareDefinitions.PersonalScore,	
	FanfareText = function(context)	
	return FormatText('campaign_score_shelf', CalculateDynamicScoreNumber(context.Engine:GetScoreMultiplier(),10000) ); end,	
	Medal = 'wheelman',	
	Score = CalculateDynamicScore(10000),	
});		
