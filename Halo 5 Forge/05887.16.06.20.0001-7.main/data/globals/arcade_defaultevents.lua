--
-- Default Arcade Event Definitions, used only for arcade campaign
--

function NearbyFriendlyImpl(distance, sourceFunc)

	return function(context)

		local source = sourceFunc(context);

		if source ~= nil then

			return table.first(context:GetAllRemotePlayers(),
				function (player)
					local playerUnit = player:GetUnit();

					return playerUnit ~= nil 
						and playerUnit:IsFriendly(source)
						and playerUnit:GetDistance(source) <= distance;
				end
				);

		end

		return nil;

	end

end

function NearbyFriendlyToSource(distance)

	return NearbyFriendlyImpl(distance, 
		function (context)
			return context.Source;
		end
		);

end

function NearbyFriendlyToLocalPlayer(distance)

	return NearbyFriendlyImpl(distance, 
		function (context)
			local firstPlayer = table.first(context:GetAllLocalPlayers(),
				function (player)
					return player:GetUnit() ~= nil;
				end
				);

			if firstPlayer ~= nil then
				return firstPlayer:GetUnit();
			end

			return nil;
		end
		);

end

function EventSourceIsLocal(context)

	return table.any(context:GetAllLocalPlayers(),
		function (player)
			local playerUnit = player:GetUnit();

			return playerUnit ~= nil and playerUnit == context.Source;
		end
		);

end

function EventSourceIsHostileToAllLocal(context)

	return table.all(context:GetAllLocalPlayers(),
		function (player)
			local playerUnit = player:GetUnit();

			return playerUnit ~= nil and playerUnit:IsHostile(context.Source);
		end
		);

end

function EventSourceIsFriendlyToAllLocal(context)

	return table.all(context:GetAllLocalPlayers(),
		function (player)
			local playerUnit = player:GetUnit();

			return playerUnit ~= nil and playerUnit:IsFriendly(context.Source);
		end
		);

end

--
-- Generic Kill Feed Functions
--
--[[
function GenericKillFeedKillPlayer(context)
	return FormatText('score_fanfare_killfeed_generic_killplayer', context.DeadPlayer);
end

function GenericKillFeedKillTeam(context)
	return FormatText('score_fanfare_killfeed_generic_killteam', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedDeadPlayer(context)
	return FormatText('score_fanfare_killfeed_generic_deadplayer', context.KillingPlayer);
end
	
function GenericKillFeedDeadTeam(context)
	return FormatText('score_fanfare_killfeed_generic_deadteam', context.DeadPlayer, context.KillingPlayer);
end
--]]

--
-- Update event
--

onUpdate = root:AddCallback(
	__OnUpdate
	);

--
-- Round start
--

onRoundStart = root:AddCallback(
	__OnRoundStart
	);
	
--
-- Player Spawn
--

onPlayerSpawn = root:AddCallback(
	__OnPlayerSpawn,
	function (context, player)
		context.TargetPlayer = player;
	end
	);
	
SpawnResponse = onPlayerSpawn:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_respawn'
	});

--
-- Round end
--

onRoundEnd = root:AddCallback(
	__OnRoundEnd
	);

--
-- Match End
--

onMatchEnd = root:AddCallback(
	__OnMatchEnd
	);

matchOverWinnersResponse = onMatchEnd:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameovervictory'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_win'
	});
	
matchOverLosersResponse = onMatchEnd:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameoverdefeat'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_lose'
	});


matchOverTiedResponse = onMatchEnd:Target(TiedTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gameover'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_neutral'
	});

--
-- Kill events
--

onKill = root:AddCallback(
	__OnKill,
	function (context, killingPlayer, killingObject, deadPlayer, deadObject, source, type, modifier, assistingPlayers)
		context.KillingPlayer = killingPlayer
		context.KillingObject = killingObject;

		context.DeadPlayer = deadPlayer;
		context.DeadObject = deadObject;

		context.DamageSource = source;
		context.DamageType = type;
		context.DamageReportingModifier = modifier;
	end
	):Filter(
	function (context)
		return context.Engine:InRound();
	end
	);
	
function KillingPlayer(context)
	return context.KillingPlayer;
end

function DeadPlayer(context)
	return context.DeadPlayer;
end	

onPlayerKill = onKill:Filter(
	function(context)
		return (context.DeadPlayer ~= nil);
	end
);

onAIKill = onKill:Filter(
	function(context)
		if(context.DeadObject == nil or context.DeadPlayer ~= nil or context.DeadObject.GetCampaignMetagameType == nil or context.DeadObject.IsAI == nil) then
				return false;
		end
		metagameObjectType = context.DeadObject:GetCampaignMetagameType();
		return (context.DeadObject:IsAI() == true and(
	   metagameObjectType == CampaignMetagameType.Grunt or
	   metagameObjectType == CampaignMetagameType.Elite or
	   metagameObjectType == CampaignMetagameType.Jackal or
	   metagameObjectType == CampaignMetagameType.Soldier or
	   metagameObjectType == CampaignMetagameType.Hunter or
	   metagameObjectType == CampaignMetagameType.Pawn or
	   metagameObjectType == CampaignMetagameType.Jackal or
	   metagameObjectType == CampaignMetagameType.Knight or
	   metagameObjectType == CampaignMetagameType.Cavalier or
	   metagameObjectType == CampaignMetagameType.Sentinel or
	   metagameObjectType == CampaignMetagameType.Bishop
		));
	end

);

onEnemyAIKill = onAIKill:Filter(
	function (context)
		return (context.DeadObject:IsHostile(context.KillingObject) == true);
	end
	);

onEnemyAIKillFromPlayer = onEnemyAIKill:Filter(
	function (context)
		return (context.KillingPlayer ~= nil);
	end
);

onEnemyAIKillFromMusketeer = onEnemyAIKill:Filter(
	function (context)
		return (context.KillingObject ~= nil and context.KillingObject:IsMusketeer() == true);
	end
);

-- on friendly AI kill
onFriendlyAIKillFromPlayer = onKill:Filter(
	function (context)
		return (context.DeadObject ~= nil and context.KillingObject ~= nil and context.DeadObject.IsAI ~= nil and context.DeadObject:IsAI() == true and context.DeadObject:IsFriendly(context.KillingObject) == true and context.KillingPlayer ~= nil);
	end
	);


--
-- Vehicle Kill Player
--
onVehicleKillFromPlayer = onKill:Filter(
	function (context)
		----Log("onVehicleKillFromPlayer");
		if (context.DeadObject == nil or context.KillingPlayer == nil or context.DeadObject.GetCampaignMetagameType == nil or context.DeadObject:IsHostileCampaign(context.KillingObject) == false) then
			return false;
		else
			metagameObjectType = context.DeadObject:GetCampaignMetagameType();
			return (metagameObjectType == CampaignMetagameType.Turret or
		   metagameObjectType == CampaignMetagameType.Mongoose or
		   metagameObjectType == CampaignMetagameType.Warthog or
		   metagameObjectType == CampaignMetagameType.Scorpion or
		   metagameObjectType == CampaignMetagameType.Pelican or
		   metagameObjectType == CampaignMetagameType.Revenant or
		   metagameObjectType == CampaignMetagameType.Seraph or
		   metagameObjectType == CampaignMetagameType.Shade or
		   metagameObjectType == CampaignMetagameType.Watchtower or
		   metagameObjectType == CampaignMetagameType.Ghost or
		   metagameObjectType == CampaignMetagameType.Wraith or
		   metagameObjectType == CampaignMetagameType.Banshee or
		   metagameObjectType == CampaignMetagameType.Phantom or
		   metagameObjectType == CampaignMetagameType.GunTower or
		   metagameObjectType == CampaignMetagameType.Mantis or
		   metagameObjectType == CampaignMetagameType.Phaeton)
		end
	end
);


--
-- Vehicle Kill
--
onVehicleKillFromMusketeer = onKill:Filter(
	function (context)
		----Log("onVehicleKillFromMusketeer");
		if (context.DeadObject == nil or context.KillingPlayer ~= nil or context.KillingObject == nil or context.DeadObject.GetCampaignMetagameType == nil or context.DeadObject:IsHostileCampaign(context.KillingObject) == false) then
			----Log ("*********VEHICLE KILL********");
			return false;
		else
			if(context.KillingObject.GetCampaignMetagameType == nil or context.KillingObject.IsAI == nil or context.KillingObject:IsMusketeer() ~= true) then
				return false;
			end
			metagameObjectType = context.DeadObject:GetCampaignMetagameType();
			return (metagameObjectType == CampaignMetagameType.Turret or
			metagameObjectType == CampaignMetagameType.Mongoose or
			metagameObjectType == CampaignMetagameType.Warthog or
			metagameObjectType == CampaignMetagameType.Scorpion or
			metagameObjectType == CampaignMetagameType.Pelican or
			metagameObjectType == CampaignMetagameType.Revenant or
			metagameObjectType == CampaignMetagameType.Seraph or
			metagameObjectType == CampaignMetagameType.Shade or
			metagameObjectType == CampaignMetagameType.Watchtower or
			metagameObjectType == CampaignMetagameType.Ghost or
			metagameObjectType == CampaignMetagameType.Wraith or
			metagameObjectType == CampaignMetagameType.Banshee or
			metagameObjectType == CampaignMetagameType.Phantom or
			metagameObjectType == CampaignMetagameType.GunTower or
			metagameObjectType == CampaignMetagameType.Mantis or
			metagameObjectType == CampaignMetagameType.Phaeton)
		end
	end
);
      

--ENEMY KILLS BY PLAYER

-- Grunt kill		
onGruntKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onGruntKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Grunt);
	end	
);		
		
-- Jackal kill		
onJackalKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onJackalKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Jackal);
	end	
);		
-- Hunter kill		
onHunterKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onHunterKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Hunter);
	end	
);		
		
-- Sentinel kill		
onSentinelKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onSentinelKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Sentinel);
	end	
);		
-- Elite kill		
onEliteKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onEliteKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Elite);
	end	
);		
		
-- Turret kill		
onTurretKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onTurretKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Turret);
	end	
);		
-- Mongoose kill		
onMongooseKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onMongooseKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Mongoose);
	end	
);		
		
-- Warthog kill		
onWarthogKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onWarthogKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Warthog);
	end	
);		
-- Scorpion kill		
onScorpionKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onScorpionKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Scorpion);
	end	
);		
		
-- Revenant kill		
onRevenantKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onRevenantKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Revenant);
	end	
);		
		
-- Seraph kill		
onSeraphKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onSeraphKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Seraph);
	end	
);		
		
-- Shade kill		
onShadeKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onShadeKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Shade);
	end	
);		
		
-- Watchtower kill		
onWatchtowerKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onWatchtowerKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Watchtower);
	end	
);		
		
-- Ghost kill		
onGhostKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onGhostKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Ghost);
	end	
);		
		
-- Wraith kill		
onWraithKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onWraithKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Wraith);
	end	
);		
		
-- Banshee kill		
onBansheeKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onBansheeKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Banshee);
	end	
);		
		
-- Phantom kill		
onPhantomKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onPhantomKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Phantom);
	end	
);		
		
-- GunTower kill		
onGunTowerKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onGunTowerKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.GunTower);
	end	
);		
		
-- TuningFork kill		
onTuningForkKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onTuningForkKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.TuningFork);
	end	
);		
		
-- Mantis kill		
onMantisKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onMantisKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Mantis);
	end	
);		
		
-- Phaeton kill		
onPhaetonKillByPlayer = onVehicleKillFromPlayer:Filter(		
	function (context)	
	--Log("onPhaetonKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Phaeton);
	end	
);		
		
-- Bishop kill		
onBishopKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onBishopKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Bishop);
	end	
);		
		
-- Knight kill		
onKnightKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onKnightKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Knight);
	end	
);		
		
-- Pawn kill		
onPawnKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onPawnKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Pawn);
	end	
);		

-- Solder kill		
onSoldierKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onSoldierKillByPlayer");	
		if (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Soldier) then
			--Log ("*********KILLED THE SOLDIER**********");
			return true;
		else
			return false;
		end
	end	
);	

-- Cavalier kill		
onWardenKillByPlayer = onEnemyAIKillFromPlayer:Filter(		
	function (context)	
	--Log("onCavalierKillByPlayer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Cavalier);
	end	
);		

--MUSKETEER KILLS
--onGruntKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(
--	function (context)
--		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Grunt);
--	end
--);

-- Grunt kill		
onGruntKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onGruntKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Grunt);
	end	
);		
		
-- Jackal kill		
onJackalKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onJackalKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Jackal);
	end	
);		
-- Hunter kill		
onHunterKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onHunterKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Hunter);
	end	
);		
		
-- Sentinel kill		
onSentinelKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onSentinelKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Sentinel);
	end	
);		
-- Elite kill		
onEliteKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onEliteKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Elite);
	end	
);		
		
-- Turret kill		
onTurretKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onTurretKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Turret);
	end	
);		
-- Mongoose kill		
onMongooseKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onMongooseKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Mongoose);
	end	
);		
		
-- Warthog kill		
onWarthogKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onWarthogKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Warthog);
	end	
);		
-- Scorpion kill		
onScorpionKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onScorpionKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Scorpion);
	end	
);		
		
-- Revenant kill		
onRevenantKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onRevenantKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Revenant);
	end	
);		
		
-- Seraph kill		
onSeraphKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onSeraphKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Seraph);
	end	
);		
		
-- Shade kill		
onShadeKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onShadeKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Shade);
	end	
);		
		
-- Watchtower kill		
onWatchtowerKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onWatchtowerKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Watchtower);
	end	
);		
		
-- Ghost kill		
onGhostKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onGhostKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Ghost);
	end	
);		
		
-- Wraith kill		
onWraithKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onWraithKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Wraith);
	end	
);		
		
-- Banshee kill		
onBansheeKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onBansheeKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Banshee);
	end	
);		
		
-- Phantom kill		
onPhantomKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onPhantomKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Phantom);
	end	
);		
		
-- GunTower kill		
onGunTowerKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onGunTowerKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.GunTower);
	end	
);		
		
-- TuningFork kill		
onTuningForkKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onTuningForkKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.TuningFork);
	end	
);		
		
-- Mantis kill		
onMantisKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onMantisKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Mantis);
	end	
);		
		
-- Phaeton kill		
onPhaetonKillByMusketeer = onVehicleKillFromMusketeer:Filter(		
	function (context)	
	--Log("onPhaetonKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Phaeton);
	end	
);		
		
-- Bishop kill		
onBishopKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onBishopKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Bishop);
	end	
);		
		
-- Knight kill		
onKnightKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onKnightKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Knight);
	end	
);		
		
-- Pawn kill		
onPawnKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onPawnKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Pawn);
	end	
);		

-- Solder kill		
onSoldierKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onSoldierKillByMusketeer");	
		if (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Soldier) then
			--Log ("*********Musketeer KILLED THE SOLDIER**********");
			return true;
		else
			return false;
		end
	end	
);	

-- Cavalier kill		
onWardenKillByMusketeer = onEnemyAIKillFromMusketeer:Filter(		
	function (context)	
	--Log("onCavalierKillByMusketeer");	
		return (context.DeadObject:GetCampaignMetagameType() == CampaignMetagameType.Cavalier);
	end	
);	



--OTHER
onPlayerSuicide = onKill:Filter(
	function (context)
		return (context.KillingPlayer) ~= nil and (context.DeadPlayer ~= nil) and (context.KillingPlayer == context.DeadPlayer) and context.DeadPlayer:GetUnit() ~= nil;
	end
	);

onFriendlyPlayerKill = onPlayerKill:Filter(
	function (context)
		return (context.KillingPlayer ~= nil and context.DeadPlayer ~= nil and context.KillingPlayer:IsFriendly(context.DeadPlayer));
	end
	);

onPlayerDeath = onKill:Filter(
	function (context)
		return context.DeadPlayer ~= nil;
	end	
	);

--
-- Enemy kill type handlers
--


-- TODO @Gabe/Greg: In order for this to work, we need to get damage histories from AI, not just players, and refactor the bajillion medals conditions down below.
-- "GetPlayerDamageHistory
killTypeSelect = onEnemyAIKillFromPlayer:Select();

function GetHeadshotScore(context)

	if context.Engine.GetHeadshotScore ~= nil then

		return context.Engine:GetHeadshotScore();

	end

	return GetKillScore(context);

end

function GetKillScore(context)

	if context.Engine.GetKillScore ~= nil then

		return context.Engine:GetKillScore();

	end

	return 0;

end

-- TODO GABE
--
-- Assist events
--

onAssist = root:AddCallback(
	__OnAssist,
	function (context, assistingPlayer, deadObject, killingPlayer)
		context.AssistingPlayer = assistingPlayer;
		context.DeadObject = deadObject;
		context.KillingPlayer = killingPlayer;
	end
	);

function AssistingPlayer(context)
	return context.AssistingPlayer;
end

playerAssistSelect = onAssist:Select();

onPlayerAssist = playerAssistSelect:Add(
	function (context)
		return (context.AssistingPlayer ~= nil) 
			and (context.DeadObject ~= nil) 
			and (context.AssistingPlayer ~= context.DeadObject)
			and (context.AssistingPlayer ~= context.KillingPlayer)
			and context.AssistingPlayer:IsFriendly(context.KillingPlayer);
	end
	);
	
--
-- Assist Spree Events
--

assistsSinceDeathAccumulator = root:CreatePlayerAccumulator();

onAssistsSinceDeath = onPlayerAssist:PlayerAccumulator(
	assistsSinceDeathAccumulator,
	function (context)
		return context.AssistingPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	assistsSinceDeathAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
	
onFiveAssistsSinceDeath = onAssistsSinceDeath:Filter(
	function (context)
		return assistsSinceDeathAccumulator:GetValue(context.AssistingPlayer) == 5;
	end
	);

-- Reset accumulator on Round Start
	 
if (resetAssistsSinceDeathOnRoundStart == nil or resetAssistsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(assistsSinceDeathAccumulator);
end 

--
-- Sayonara - falling kill
--
onFallingKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == FallingDamageSource
	end
	);

--
-- Sword kill
--

onSwordKill = killTypeSelect:Add(
	function (context)
		return table.any(SwordDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);



--
-- Beat down (melee attack from behind)
--

onMeleeFromBehind = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.SilentMelee and context.DamageType == MeleeDamageType;
	end
	);



--
-- Hitman - Breakout Only
--

if (enableBlindSideMedal) then
	onBlindSide = killTypeSelect:Add(
		function (context)
			if context.DamageReportingModifier == DamageReportingModifier.Assassination then		
				local aliveHostilePlayers = table.filtervalues(context:GetAllPlayers(),
					function (player)
						return PlayerIsAlive(player) and player:IsHostile(context.KillingPlayer)
					end
					);
					return #aliveHostilePlayers == 1;
			end
			return false;
		end
		);
end

--
-- Animated air assassination kill.
--

onAirAssassination = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination
		and context.KillingPlayer:IsAirborneAssassinating();
	end
	);
	
	
--
-- Animated assassination kill.
--

onAssassination = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination;
	end
	);
	
--
-- Melee kill
--

onMeleeKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == MeleeDamageType;
	end
	);

--
-- Ground Pound
--

onGroundPoundKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == GroundPoundDamageType;
	end
	);

--
-- Shoulder Bash
--

onShoulderBashKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == ShoulderBashDamageType;
	end
	);

--
-- Supercombine kill
--
onNeedlerKill = killTypeSelect:Add(
	function(context)
		--Log("onSupercombineKill");	
		return context.DamageSource == NeedlerDamageSource
	end
);

  


--
-- Hydra
--

onHydraKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == HydraDamageSource;
	end
	);

	-- TODO GABE: Could convert to to AI
	--[[
--
-- Tomahawk
--
	
function IsTomahawk (context)
	local deadObjectUnit = context.DeadObject:GetUnit();
	return context.DamageSource == rocketLauncherDamageSource 
		and context.DamageType == bulletDamageType
		and deadObjectUnit:IsAirborne();
end

-- TODO Player -> AI
onTomahawkKill = onEnemyAIKillFromPlayer:Filter(
	IsTomahawk
	);
--]]
--
-- Rocket Mary
--

function IsRocketMaryKill (context)
	return context.DamageSource == RocketLauncherDamageSource
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
end

onRocketMary = onEnemyAIKillFromPlayer:Filter(
	IsRocketMaryKill
	);

--
-- Rocket launcher kill
--

onRocketLaucherKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == RocketLauncherDamageSource;
	end
	);

--
-- Shotgun kill
--

onShotgunKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == ShotgunDamageSource;
	end
	);
	
--
-- Airborne Snapshot
--

onAirborneSnapshot = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();
		return context.DamageSource == SniperDamageSource
		and context.DamageType == BulletDamageType
		and killingPlayerUnit ~= nil
		and killingPlayerUnit:IsAirborne()
		and not killingPlayerUnit:IsZoomed();
	end
	);
	
--
-- Snapshot 
--

onSnapshot = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();

		return context.DamageSource == SniperDamageSource
		and context.DamageType == BulletDamageType
		and killingPlayerUnit ~= nil
		and not killingPlayerUnit:IsZoomed();
	end
	);

--
-- Sniper Headshot
--

onSniperHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == SniperDamageSource 
		and context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);
				
--
-- Sniper kill
--

onSniperKill = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();

		return killingPlayerUnit ~= nil 
		and killingPlayerUnit:IsZoomed() 
		and context.DamageSource == SniperDamageSource 
		and context.DamageType == BulletDamageType;
	end
	);

--
-- All Sniper Kills
--

onAllSniperKills = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == SniperDamageSource
		and context.DamageType == BulletDamageType 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil;
	end
	);






--
-- Headshot
--

onHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);
	
--
-- Grenade Kill functions
--

function IsGrenadeKill (context)
	return table.any(GrenadeDamageSources, 
		function(damageSource)
			return context.DamageType == ExplosionDamageType
			and context.DamageSource == damageSource;
		end
		);
end

function IsHailMary (context)
	return context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 16
		and IsGrenadeKill(context);
end

function IsStuck (context)
	return context.DamageReportingModifier == DamageReportingModifier.AttachedDamage
	and IsGrenadeKill(context);
end

--
-- Hail Mary
--

onHailMary = onEnemyAIKillFromPlayer:Filter(
	IsHailMary
	);
	
--
-- Stuck
--

onStuck = onEnemyAIKillFromPlayer:Filter(
	IsStuck
	);

--
-- Rare Grenade Kill
--

onRareGrenadeKill = killTypeSelect:Add(
	function (context)
		return IsStuck(context) or IsHailMary(context);
	end
	);
	
--
-- Grenade kill
--

onGrenadeKill = killTypeSelect:Add(
	IsGrenadeKill
	);

--
-- Generic kill
--
	
onGenericKill = killTypeSelect:Add(
	);

--
-- Magnum Generic Kill
--

onMagnumKill = onGenericKill:Filter(
	function (context)
		return context.DamageSource == MagnumDamageSource;
	end
	);
	
	

--
-- Splatter kill
--

onSplatterKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == CollisionDamageType
		and table.any(AllVehicleDamageSources, 
			function(vehicleDamageSource)
				return context.DamageSource == vehicleDamageSource;
			end
			);
	end
	);
--onSplatterSelect = killTypeSelect:Add(
--	function(context)
--		return context.DamageType == CollisionDamageType
--		and table.any(AllVehicleDamageSources, 
--			function(vehicleDamageSource)
--				return context.DamageSource == vehicleDamageSource;
--			end
--			);
--	end
-- ):Select();



--
-- Sniper Headshots in a row
--

consecutiveSniperHeadshotsAccumulator = root:CreatePlayerAccumulator();

-- Count headshots
onConsecutiveSniperHeadshots = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot
		and context.DamageSource == SniperDamageSource
		and context.DamageType == BulletDamageType;
	end
	):PlayerAccumulator(
	consecutiveSniperHeadshotsAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

-- Reset accumulator on death
onPlayerDeath:ResetPlayerAccumulator(
	consecutiveSniperHeadshotsAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );

-- Was the kill a sniper headshot?
onNonHeadshotKill = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageReportingModifier ~= DamageReportingModifier.Headshot
		or context.DamageSource ~= SniperDamageSource
		or context.DamageType ~= BulletDamageType;
	end
	);

-- Reset accumulator on non-headshot kill
onNonHeadshotKill:ResetPlayerAccumulator(
	consecutiveSniperHeadshotsAccumulator,
		function (context)
			return context.KillingPlayer;
		end
		);
		
-- Reset accumulator on Round Start
	 
if (resetConsecutiveHeadshotsOnRoundStart == nil or resetConsecutiveHeadshotsOnRoundStart) then
	onRoundStart:ResetAccumulator(consecutiveSniperHeadshotsAccumulator);
end

-- Trigger on 3 consecutive headshots	
onThreeConsecutiveHeadshots = onConsecutiveSniperHeadshots:Filter(
	function (context)
		return consecutiveSniperHeadshotsAccumulator:GetValue(context.KillingPlayer) % 3 == 0;
	end
	);
	
--
-- Player kills since death.
--

killsSinceDeathAccumulator = root:CreatePlayerAccumulator();

-- TODO Gabe/Greg, need to rejigger revenge --Logic to work with downed and other things
onKillsSinceDeath = onPlayerKill:PlayerAccumulator(
	killsSinceDeathAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	killsSinceDeathAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );

-- Reset Accumulator on Round Start
	 	 
if (resetKillsSinceDeathOnRoundStart == nil or resetKillsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(killsSinceDeathAccumulator);
end
	 
onOneKillSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 1;
	end
	);

--Killing Spree

onFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 5;
	end
	);
	
--Killing Frenzy
onTenKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 10;
	end
	);
	
--Running Riot
onFifteenKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 15;
	end
	);

--Rampage
onTwentyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 20;
	end
	);

--Untouchable
onTwentyFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 25;
	end
	);

--Invincible	
onThirtyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 30;
	end
	);
	
--Inconceivable
onThirtyFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 35;
	end
	);

--Unfriggenbelievable
onFourtyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 40;
	end
	);
		
--
-- Player kills in a row.
--

local multikillSeconds = 1.0;

killsInARowAccumulator = root:CreatePlayerAccumulator(multikillSeconds);

onKillsInARow = onEnemyAIKillFromPlayer:PlayerAccumulator(
	killsInARowAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	killsInARowAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);

onRoundStart:ResetAccumulator(killsInARowAccumulator);

--Double Kill
onTwoKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 2
	end
	);
		
--Triple Kill
onThreeKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 3
	end
	);
		
--Overkill
onFourKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 4
	end
	);

--Killtacular
onFiveKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 5
	end
	);

--Killtrocity
onSixKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 6
	end
	);
	
--Killimanjaro
onSevenKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 7
	end
	);
	
--Killtastrophe
onEightKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 8
	end
	);
	
--Killpocalypse
onNineKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 9
	end
	);
	
--Killionaire
onTenKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 10
	end
	);
	
--
-- Deaths in a row
--

deathsSinceKillAccumulator = root:CreatePlayerAccumulator();

onDeathsSinceKill = onPlayerDeath:PlayerAccumulator(
	deathsSinceKillAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);

-- Reset events for deaths in a row.
--

onEnemyAIKillFromPlayer:ResetPlayerAccumulator(
	deathsSinceKillAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);
	
-- Reset Accumulator on Round Start	
	 
if (resetDeathsSinceKillOnRoundStart == nil or resetDeathsSinceKillOnRoundStart) then
	onRoundStart:ResetAccumulator(deathsSinceKillAccumulator);
end

--
-- Kills per round.
--

killsInRoundAccumulator = root:CreateAccumulator();

onKillsInRound = onEnemyAIKillFromPlayer:Accumulator(killsInRoundAccumulator);

onFirstKill = onKillsInRound:Filter(
	function (context)
		--Log("First kill");
		return killsInRoundAccumulator:GetValue() == 1;
	end
	);

--
-- Kills per Round Reset
--
	 
if (resetKillsInRoundOnRoundStart == nil or resetKillsInRoundOnRoundStart) then
	onRoundStart:ResetAccumulator(killsInRoundAccumulator);
end
	

onPlayerDeath:ResetPlayerAccumulator(
	protectorAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );

-- Reset Accumulator on Round Start
	 	 
if (resetKillsSinceDeathOnRoundStart == nil or resetKillsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(protectorAccumulator);
end
	 
--
-- Revenge types.
--

revengeTypeSelect = onOneKillSinceDeath:Filter(
	function (context)
		return context.KillingPlayer:GetLastKillingPlayer() == context.DeadPlayer;
	end
	):Select();

--
-- Retribution (assassinate the last person to kill you)
--

onRetribution = revengeTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination;
	end
	);

--
-- Revenge (kill the last player who killed you as the first kill since spawning)
--

onRevenge = revengeTypeSelect:Add(
	);
	
--
-- Kill from the grave (killed player while dead, not in same tick).
--

onKillFromTheGrave = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return PlayerIsDead(context.KillingPlayer) 
			and context.KillingPlayer:GetSecondsSinceDeath() > 0.25;--TODO gabe/greg or downed?
	end
	);

--
-- Showstopper
--

onShowStopper = onPlayerKill:Filter(
	function (context)
		return context.DeadPlayer:IsAssassinating();
	end
	);
		
--
-- Cliffhanger
--

onCliffhanger = onPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsClambering();
	end
	);

--
-- Longshot - Battle Rifle
--

onBattleRifleLongshot = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == BattleRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 26;
	end
	);
	
--
-- Longshot - DMR
--

onDMRLongshot = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == DmrDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 45;
	end
	);
	
--
-- Longshot - Magnum
--

onMagnumLongshot = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == MagnumDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 20;
	end
	);
		
--
-- Spray and Pray - Assault Rifle
--

onAssaultRifleSprayPray = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == AssaultRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
	end
	);
	
onSMGSprayPray = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == SmgDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 15;
	end
	);
--
-- Cluster Luck
--

local clusterLuckSeconds = 0.1;

grenadeKillAccumulator = root:CreatePlayerAccumulator(clusterLuckSeconds);

onGrenadeKillCounter = onGrenadeKill:PlayerAccumulator(
	grenadeKillAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onRoundStart:ResetAccumulator(grenadeKillAccumulator);

onClusterLuck = onGrenadeKillCounter:Filter(
	function (context)
		return grenadeKillAccumulator:GetValue(context.KillingPlayer) == 2
	end
	);
	
--
-- Longshot - Sniper Rifle
--

onSniperLongshot = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == SniperDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 75;
	end
	);

--
-- Bulltrue
--

onBulltrue = onPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsLunging() and deadPlayerUnit:GetPrimaryWeapon():GetClassName() == swordWeaponClassName;
	end
	);

--
-- Armageddon
--

onAllRocketKills = onEnemyAIKillFromPlayer:Filter(
	function (context)
		return context.DamageSource == RocketLauncherDamageSource;
	end
	);

rocketKillsSinceDeathAccumulator = root:CreatePlayerAccumulator();

onRocketKillsSinceDeath = onAllRocketKills:PlayerAccumulator(
	rocketKillsSinceDeathAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	rocketKillsSinceDeathAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
	
onFourRocketKillsSinceDeath = onRocketKillsSinceDeath:Filter(
	function (context)
		return rocketKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) % 4 == 0;
	end
	);

--
-- Snipeltaneous!
--

local sniperShotSeconds = 0.1;

killsInOneSniperShotAccumulator = root:CreatePlayerAccumulator(sniperShotSeconds);

onSniperKillsInOneShotCounter = onAllSniperKills:PlayerAccumulator(
	killsInOneSniperShotAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onRoundStart:ResetAccumulator(killsInOneSniperShotAccumulator);

onTwoKillsOneShot = onSniperKillsInOneShotCounter:Filter(
	function (context)
		return killsInOneSniperShotAccumulator:GetValue(context.KillingPlayer) == 2
	end
	);



--
-- Deadshot (kill an enemy with the last bullet in a clip)
--

onEnemyAIKillFromPlayerWithLastBullet = onEnemyAIKillFromPlayer:Filter(
	function(context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();

		if killingPlayerUnit == nil then
			return false;
		end

		local killingPlayerPrimaryWeapon = killingPlayerUnit:GetPrimaryWeapon();

		if killingPlayerPrimaryWeapon == nil then
			return false;
		end

		if killingPlayerPrimaryWeapon:GetRoundsLoaded() ~= 0 then
			return false;
		end

		for index, value in ipairs(powerWeaponNames) do
			if killingPlayerPrimaryWeapon:GetName() == value then
				return false;
			end
		end

		if context.DamageType ~= bulletDamageType then
			return false;
		end

		return true;
	end
	);
 
--
-- TODO: MOVE TO COMBAT HEARTBEATS
--

--
-- Enter combat
--

onEnterCombat = root:AddCallback(
	__OnPlayerEnterCombat,
	function (context, player)
		context.TargetPlayer = player;
	end
	);

--
-- Exit combat
--

onExitCombat = root:AddCallback(
	__OnPlayerExitCombat,
	function (context, player)
		context.TargetPlayer = player;
	end
	);

--
-- Vehicle Jacked
--

onVehicleJacked = root:AddCallback(
	__OnVehicleJacked,
	function (context, vehicle, enteringPlayer, exitingPlayer)
		context.TargetVehicle = vehicle;
		context.EnteringPlayer = enteringPlayer;
		context.ExitingPlayer = exitingPlayer;
	end
	);

onGhostJack = onVehicleJacked:Filter(
	function (context)
		return context.TargetVehicle:GetCampaignMetagameType() == CampaignMetagameType.Ghost;
	end
	);


--
-- Player Picked Up Weapon
--

onPlayerPickedUpWeapon = root:AddCallback(
	__OnPlayerPickedUpWeapon,
	function (context, player, weapon)
		context.TargetPlayer = player;
		context.PickedUpWeapon = weapon;
	end
	);

onSniperPickedUpWeapon = onPlayerPickedUpWeapon:Filter(
	function (context)
		local weaponName = context.PickedUpWeapon:GetName();

		if weaponName ~= sniperWeaponName then
			return false;
		end

		return true;
	end
	);
	
--
-- Player Grenade Thrown
--

onPlayerGrenadeThrown = root:AddCallback(
	__OnPlayerGrenadeThrown,
	function (context, player, thrownObject)
		context.TargetPlayer = player;
		context.ThrownObject = thrownObject;
	end
	);
	
grenadeThrowResponse = onPlayerGrenadeThrown:Target(TargetPlayer):Response(
	{
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("throwing_grenade"),
				 SubjectUnit = context.TargetPlayer:GetUnit(),
				}
			end			
	});


--
-- Player Revive
--

onUnitRevivedUnit = root:AddCallback(
	__OnUnitRevivedUnit,
	function (context, reviverPlayer, reviverUnit, targetPlayer, targetUnit)
		context.ReviverPlayer = reviverPlayer;
		context.ReviverUnit = reviverUnit;
		context.TargetPlayer = targetPlayer;
		context.TargetUnit = targetUnit;
	end
	);


onPlayerWasRevived= onUnitRevivedUnit:Filter(
 function (context)
  return (context.ReviverUnit ~= nil) and (context.TargetPlayer ~= nil);
 end
 );

 onPlayerRevivedSomone = onUnitRevivedUnit:Filter(
 function (context)
   return (context.TargetUnit ~= nil) and (context.ReviverPlayer ~= nil);
 end
 );

 function ReviverPlayer(context)
	return context.ReviverPlayer;
end

onPlayerWasRevivedResponse = onPlayerWasRevived:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'was_revived',
	});

onPlayerRevivedSomoneResponse = onPlayerRevivedSomone:Target(ReviverPlayer):Response(
	{
		Medal = 'revived_someone',
	});
	
--
-- Player Shields Regenerated
--

onPlayerRegeneratedShields = root:AddCallback(
	__OnPlayerRegeneratedShields,
	function (context, player)
		context.TargetPlayer = player;
	end
	);
	
--
-- Immortal (player regenerated shields 5 times)
--

shieldsRechargedSinceDeathAccumulator = root:CreatePlayerAccumulator();

onShieldsRechargedSinceDeath = onPlayerRegeneratedShields:PlayerAccumulator(
	shieldsRechargedSinceDeathAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	shieldsRechargedSinceDeathAccumulator,
	function(context)
		return context.DeadPlayer;
	end
	);

-- 10 recharges

onTenShieldsRechargedSinceDeath = onShieldsRechargedSinceDeath:Filter(
	function(context)
		return shieldsRechargedSinceDeathAccumulator:GetValue(context.TargetPlayer) == 10;
	end
	);

--
-- Player Shields Starting Regeneration
--

onPlayerStartingShieldRegeneration = root:AddCallback(
	__OnPlayerStartingShieldRegeneration,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

closeCallKillAccumulator = root:CreatePlayerAccumulator();

onCloseCallKill = onEnemyAIKillFromPlayer:PlayerAccumulator(
	closeCallKillAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	closeCallKillAccumulator,
	function(context)
		return context.DeadPlayer;
	end
	);

onPlayerRegeneratedShields:ResetPlayerAccumulator(
	closeCallKillAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);


onPlayerDeath:ResetPlayerAccumulator(
	bigGameHunterAccumulator,
	function(context)
		return context.DeadPlayer;
	end
	);

if (resetKillsSinceDeathOnRoundStart == nil or resetKillsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(bigGameHunterAccumulator);
end
