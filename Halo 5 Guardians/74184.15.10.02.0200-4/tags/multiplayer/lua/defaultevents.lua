--
-- Default Event Definitions
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
-- Default event definitions
--

root = RootDefinition:new();

DefinitionRuntime:RegisterRoot(root);

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
-- Round end
--

onRoundEnd = root:AddCallback(
	__OnRoundEnd
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

__OnRoundEndAnnouncement = Delegate:new() 

onRoundEndAnnouncement = root:AddCallback(
	__OnRoundEndAnnouncement
	);

--
-- Player activated
--

function ActivatedPlayer(context)
	return context.ActivatedPlayer
end

onPlayerActivated = root:AddCallback(
	__OnPlayerActivated,
	function (context, activatedPlayer)
		context.TargetPlayer = activatedPlayer;
	end
	);

--
-- Player added
--

onPlayerAdded = root:AddCallback(
	__OnPlayerAdded,
	function (context, activatedPlayer, joinInProgress)
		context.TargetPlayer = activatedPlayer;
		context.JoinInProgress = joinInProgress;
	end
	);

onPlayerAddedGeneralResponse = onPlayerAdded:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'player_joined'
	});

--
-- Player Left
--

onPlayerLeft = root:AddCallback(
	__OnPlayerLeft,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

onPlayerLeftResponse = onPlayerLeft:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'player_left'
	});

--
-- Kill events
--

onKill = root:AddCallback(
	__OnKill,
	function (context, killingPlayer, killingObject, deadPlayer, deadObject, source, type, modifier, assistingPlayers)

		context.KillingPlayer = killingPlayer
		context.KillingObject = killingObject;

		if context.KillingPlayer ~= nil then
			local killingPlayerUnit = context.KillingPlayer:GetUnit();
			if killingPlayerUnit ~= nil then
				context.KillingPlayerUnit = killingPlayerUnit;
			end
		end

		context.DeadPlayer = deadPlayer;
		context.DeadObject = deadObject;

		if context.DeadPlayer ~= nil then
			local deadPlayerUnit = context.DeadPlayer:GetUnit();
			if deadPlayerUnit ~= nil then
				context.DeadPlayerUnit = deadPlayerUnit;
			end
		end

		context.DamageSource = source;
		context.DamageType = type;
		context.DamageReportingModifier = modifier;
		
		context.AssistingPlayers = assistingPlayers;

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

function AssistingPlayers(context)
	return context.AssistingPlayers;
end

onPlayerKill = onKill:Filter(
	function (context)
		return (context.KillingPlayer ~= nil) and (context.DeadPlayer ~= nil) and (context.KillingPlayer ~= context.DeadPlayer) and context.DeadPlayer:GetUnit() ~= nil;
	end
	);

onPlayerSuicide = onKill:Filter(
	function (context)
		return (context.KillingPlayer) ~= nil and (context.DeadPlayer ~= nil) and (context.KillingPlayer == context.DeadPlayer) and context.DeadPlayer:GetUnit() ~= nil;
	end
	);

onEnemyPlayerKill = onPlayerKill:Filter(
	function (context)
		return context.KillingPlayer:IsHostile(context.DeadPlayer);
	end
	);

onFriendlyPlayerKill = onPlayerKill:Filter(
	function (context)
		return context.KillingPlayer:IsFriendly(context.DeadPlayer);
	end
	);

onPlayerDeath = onKill:Filter(
	function (context)
		return context.DeadPlayer ~= nil;
	end	
	);

--
-- Vehicle Destroyed Events
--

local AllVehicleNamesAndTypes = 
{
	{ "banshee", 	BansheeType },
	{ "ghost", 		GhostType },
	{ "mantis", 	MantisType },
	{ "mongoose",	MongooseType },
	{ "vtol", 		PhaetonType },
	{ "scorpion", 	ScorpionType },
	{ "warthog", 	WarthogType },
	{ "wraith", 	WraithType },
}

-- ToDo: v-evfor add IsHostile to DeadObject
onVehicleDestroyed = onKill:Filter(
	function(context)		
		if context.DeadObject == nil or 
			context.KillingPlayer == nil or 
			context.DeadObject:HasValidTeam() == false or
			context.KillingPlayer:IsHostileToObject(context.DeadObject) == false or
			(context.DeadObject.IsBossVehicleUnit ~= nil and context.DeadObject:IsBossVehicleUnit() == true) then 

			return false;
		end

		return table.any(AllVehicleTypes,
			function(vehicleType)
				return context.DeadObject.GetCampaignMetagameType ~= nil and
					context.DeadObject:GetCampaignMetagameType() == vehicleType;
			end
			);
	end
	);

onVehicleDestroyedSelect = onVehicleDestroyed:Select();
onVehicleDestroyedAssistSelect = onVehicleDestroyed:Select();

onPhantomDestroyed = onVehicleDestroyedSelect:Add(
	function(context)
		return context.DeadObject:GetCampaignMetagameType() == PhantomType;
	end
	);

function BuildVehicleDestroyedResponses(vehicleName, source)

	local globals = _G;

	globals[vehicleName .. "DestroyedResponse"] = source:Target(KillingPlayer):Response(
	{
		Medal = vehicleName .. "_destruction"
	});
end

function BuildVehicleDestroyedAssistResponses(vehicleName, source)

	local globals = _G;

	globals[vehicleName .. "DestroyedAssistResponse"] = source:Target(AssistingPlayers):Response(
	{
		Medal = vehicleName .. "_assist"
	});
end

for index, vehicle in ipairs(AllVehicleNamesAndTypes) do
	
	local vehicleNameIndex = 1;
	local vehicleTypeIndex = 2;

	local vehicleName = vehicle[vehicleNameIndex];


	local sourceEvent = onVehicleDestroyedSelect:Add(
		function(context)
			return context.DeadObject:GetCampaignMetagameType() == vehicle[vehicleTypeIndex];
		end
		);

	local assistSourceEvent = onVehicleDestroyedAssistSelect:Add(
		function(context)
			return context.DeadObject:GetCampaignMetagameType() == vehicle[vehicleTypeIndex];
		end	
		);

	BuildVehicleDestroyedResponses(vehicleName, sourceEvent);
	BuildVehicleDestroyedAssistResponses(vehicleName, assistSourceEvent);
end

--
-- Enemy kill type handlers
--

killTypeSelect = onEnemyPlayerKill:Select();

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

--
-- Splatter
--

onSplatterSelect = killTypeSelect:Add(
	function(context)
		return context.DamageType == CollisionDamageType
		and table.any(AllVehicleDamageSources, 
			function(vehicleDamageSource)
				return context.DamageSource == vehicleDamageSource;
			end
			);
	end
	):Select();

onRoadTrip = onSplatterSelect:Add(
	function(context)
		if context.KillingObject.GetVehicle ~= nil then
			local vehicle = context.KillingObject:GetVehicle();
			if vehicle ~= nil and vehicle.GetCampaignMetagameType ~= nil then
				local vehicleType = vehicle:GetCampaignMetagameType();
				if vehicleType == WarthogType or vehicleType == MongooseType then
					if vehicle.HasEmptyNonBoardingSeat ~= nil and not vehicle:HasEmptyNonBoardingSeat() then
						local playersInVehicle = { };

						for _ , player in pairs(context:GetAllPlayers()) do
							local playerUnit = player:GetUnit();
							if playerUnit ~= nil then
								local playerVehicle = playerUnit:GetVehicle();
								if playerVehicle ~= nil then
									if playerVehicle == vehicle then
										table.insert(playersInVehicle, player);
									end
								end
							end
						end

						context.MatchingPlayers = playersInVehicle;
						return true;
					end
				end
			end
		end

		return false;
	end
	);

onGenericSplatter = onSplatterSelect:Add();

--
-- Flying High
--

onVehicleLandedOnGround = root:AddCallback(
	__OnVehicleLandedOnGround,
	function(context, targetVehicle, secondsInAir)
		context.TargetVehicle = targetVehicle;
		context.SecondsInAir = secondsInAir;
	end
	);

local flyingHighSecondsThreshold = 1.2;

function FindFlyingHighPlayers(context)

	if context.TargetVehicle == nil
	or (context.TargetVehicle:GetCampaignMetagameType() ~= WarthogType and context.TargetVehicle:GetCampaignMetagameType() ~= MongooseType)
	or (context.TargetVehicle.HasEmptyNonBoardingSeat ~= nil and context.TargetVehicle:HasEmptyNonBoardingSeat() )
	or context.SecondsInAir < flyingHighSecondsThreshold then
		return nil;
	end

	local playersInVehicle = { };

	for _ , player in pairs(context:GetAllPlayers()) do
		local playerUnit = player:GetUnit();
		if playerUnit ~= nil then
			local playerVehicle = playerUnit:GetVehicle();
			if playerVehicle ~= nil then
				if playerVehicle == context.TargetVehicle then
					table.insert(playersInVehicle, player);
				end
			end
		end
	end

	return playersInVehicle;
end


--
-- Sayonara - falling kill
--
onFallingKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == fallingDamageSource
	end
	);

--
-- Gunpunch (2 shots then melee)
--

function GunpunchKill(context, maximumNumberOfMissedShots, maximumNumberOfLandedShots, weaponDamageSource)

	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
		function(damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);

	--killing player should deal almost all of the damage
	if deadPlayerDamageHistoryFromKillingPlayer == nil  or deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then 
		return false;
	end

	local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

	local deadPlayerOnlyTookCorrectDamage = table.all(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == MeleeDamageType or breakdown:GetDamageSource() == weaponDamageSource
		end
		);

	--dead player should only take damage that was melee or br
	if not deadPlayerOnlyTookCorrectDamage then 
		return false;
	end

	local meleeDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == MeleeDamageType;
		end
		);

	--dead player should only be hit with 1 melee
	if #meleeDamageBreakdowns ~= 1 then
		return false;
	end

	-- go back in time 1/4 a second so that we can see if the last few bullets of the br burst missed.
	local firstEngagementTime = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() - 0.25;

	local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
		function (shotInfo)
			return shotInfo:GetShotTime() >= firstEngagementTime;
		end
		);

	if #allShotsSinceEngagingPlayer == 0 then
		return false;
	end

	local missedShots = table.filtervalues(allShotsSinceEngagingPlayer,
		function (shotInfo)
			return shotInfo:DealtPlayerDamage() == false;
		end
		);

	if #missedShots > maximumNumberOfMissedShots then
		return false;
	end

	local shotsOnDeadPlayer = table.filtervalues(allShotsSinceEngagingPlayer,
		function (shotInfo)
			return shotInfo:GetDamagedPlayer() == context.DeadPlayer;
		end
		);

	if #shotsOnDeadPlayer > maximumNumberOfLandedShots then
		return false;
	end

	-- all br damage must occur before melee damage
	local meleeDamageBreakdown = table.first(meleeDamageBreakdowns,
		function(breakdown)
			return breakdown;
		end
		);

	for _ , value in pairs(allShotsSinceEngagingPlayer) do
		if value:GetShotTime() > meleeDamageBreakdown:GetDamageTime() then
			return false;
		end
	end

	return true;
end

onGunpunchKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == MeleeDamageType
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and GunpunchKill(context, 1, 6, BattleRifleDamageSource);
	end
	);

onSnipunchKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == MeleeDamageType
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and (GunpunchKill(context, 0, 1, SniperDamageSource) or GunpunchKill(context, 0, 1, BeamRifleDamageSource));
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

if (enableFlagsassinationMedal) then
	onFlagAssassination = killTypeSelect:Add(
		function(context)
			return context.DamageReportingModifier == DamageReportingModifier.Assassination
				and context.KillingPlayer:IsFlagCarrier();
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
-- Brawler (double melee)
--

onBrawlerKill = killTypeSelect:Add(
	function(context)
		if context.DamageType ~= MeleeDamageType then
			return false;
		end

		-- killing player should only deal melee damage

		local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

		local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
			end
			);

		if deadPlayerDamageHistoryFromKillingPlayer == nil then
			return false;
		end

		-- killing player should be the only damage source
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end

		local killingPlayerDamageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

		local meleeDamageBreakdowns = table.filtervalues(killingPlayerDamageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == MeleeDamageType;
			end
			);

		return #meleeDamageBreakdowns >= 2;
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

function FindPoundTownAssistPlayers(context)

	if context.DamageType ~= GroundPoundDamageType then
		return nil;
	end

	local poundTownAssistingPlayers = { };

	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	for _ , player in pairs(context.AssistingPlayers) do

		local deadPlayerDamageHistoryFromAssistingPlayer = table.first(deadPlayerDamageHistories,
			function (damageHistory)
				return damageHistory:GetAttackingPlayer() == player;
			end
			);


		local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromAssistingPlayer);

		local dealtGroundPoundDamage = table.any(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == GroundPoundDamageType;
			end
			);

		if dealtGroundPoundDamage then
			table.insert(poundTownAssistingPlayers, player);
		end
	end

	return poundTownAssistingPlayers;
end


function FindNonPoundTownAssistPlayers(context)
	local poundTownAssistPlayers = FindPoundTownAssistPlayers(context);
	local nonPoundTownAssistPlayers = { };
	
	for _ , assistPlayer in pairs(context.AssistingPlayers) do
		local playerIsPoundTownAssisting = table.any(poundTownAssistPlayers,
			function(groundPoundAssistPlayer)
				return assistPlayer == groundPoundAssistPlayer;
			end
			);
			if not playerIsPoundTownAssisting then
			table.insert(nonPoundTownAssistPlayers, assistPlayer);
		end
	end
	
		return nonPoundTownAssistPlayers;
end

function IsPoundTown(context)
	if context.AssistingPlayers == nil then
		return false;
	end

	local poundTownAssistPlayers = FindPoundTownAssistPlayers(context);

	if poundTownAssistPlayers == nil then
		return false;
	end

	return #poundTownAssistPlayers > 0;
end

onGroundPoundKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == GroundPoundDamageType;
	end
	);

groundPoundKillSelect = onGroundPoundKill:Select();

onPoundTown = groundPoundKillSelect:Add(IsPoundTown);

onGenericGroundPoundKill = groundPoundKillSelect:Add();

--
-- Shoulder Bash
--

onShoulderBashKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == ShoulderBashDamageType;
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
	
--
-- Splaser
--

onSplaserKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == SpartanLaserDamageSource;
	end
	);
	
--
-- Needler
--

onNeedlerKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == NeedlerDamageSource;
	end
	);
	
	
--
-- SAW
--

onSawKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == SawDamageSource;
	end
	);
	
--
-- Railgun
--

onRailgunKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == RailGunDamageSource;
	end
	);

--
-- Plasma Caster
--

onPlasmaCasterKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == PlasmaCasterDamageSource;
	end
	);
	
--
-- Rocket Mary
--

function IsRocketMaryKill (context)
	return context.DamageSource == RocketLauncherDamageSource
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
end

onRocketMary = onEnemyPlayerKill:Filter(
	IsRocketMaryKill
	);

--
-- Incineration Cannon Kill
--

onIncinerationKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == IncinerationCannonDamageSource;
	end
	);

--
-- Binary Kill
--

onBinaryRifleKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == BinaryRifleDamageSource;
	end
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
-- Scattershot kill
--

onScattershotKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == ScattershotDamageSource;
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

		return context.DamageType == BulletDamageType
		and killingPlayerUnit ~= nil
		and killingPlayerUnit:IsAirborne()
		and not killingPlayerUnit:IsZoomed()
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);
	
--
-- Snapshot 
--

onSnapshot = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();

		return context.DamageType == BulletDamageType
		and killingPlayerUnit ~= nil
		and not killingPlayerUnit:IsZoomed()
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Sniper Headshot
--

onSniperHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Beam kill
--

onBeamRifleKill = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();

		return killingPlayerUnit ~= nil 
		and killingPlayerUnit:IsZoomed()
		and context.DamageType == BulletDamageType
		and context.DamageSource == BeamRifleDamageSource;
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
		and context.DamageType == BulletDamageType
		and context.DamageSource == SniperDamageSource;
	end
	);

--
-- All Sniper Kills
--

onAllSniperKills = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageType == BulletDamageType 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Noob Combo
--

function IsNoobCombo(context)

	--get damage histories and breakdowns.
	--ensure that killing player did essentially all damage
	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
		function (damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);

	if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
		return false;
	end

	local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);


	-- find all charged plasma pistol damage
	local chargedPlasmaPistolDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageSource() == PlasmaPistolDamageSource 
			and (breakdown:GetDamageType() == ChargedPlasmaDamageType or breakdown:GetDamageType() == ExplosionDamageType);
		end
		);

	-- find all BR damage
	local headshotWeaponDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == BulletDamageType
			and table.any(NonSniperHeadshotDamageSoures,
				function(damageSource)
					return damageSource == breakdown:GetDamageSource();
				end
				);
		end
		);

	--all damage needs to be from charged plasma shots or the battlerifle
	local allDamageCorrectDamageSources = table.all(damageBreakdowns,
		function(breakdown)
			return table.any(chargedPlasmaPistolDamageBreakdowns,
				function(plasmaDamageBreakdown)
					return breakdown:GetDamageSource() == plasmaDamageBreakdown:GetDamageSource() 
					and breakdown:GetDamageType() == plasmaDamageBreakdown:GetDamageType();
				end
				)
			or table.any(headshotWeaponDamageBreakdowns,
				function(battleRifleDamageBreakdown)
					return breakdown:GetDamageSource() == battleRifleDamageBreakdown:GetDamageSource() 
					and breakdown:GetDamageType() == battleRifleDamageBreakdown:GetDamageType();
				end
				);
		end
		);

	if not allDamageCorrectDamageSources then
		return false;
	end

	if #chargedPlasmaPistolDamageBreakdowns > 2  or #chargedPlasmaPistolDamageBreakdowns < 1 or #headshotWeaponDamageBreakdowns < 1 then
		return false;
	end

	-- add a small time window to account for the aoe explosion
	local chargedPlasmaWasFirstDamage = table.all(chargedPlasmaPistolDamageBreakdowns,
		function(plasmaDamageBreakdown)
			return plasmaDamageBreakdown:GetDamageTime() <= deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() + 0.02;
		end
		);


	if not chargedPlasmaWasFirstDamage then
		return false;
	end

	local allBRDamageAfterPlasma = table.all(headshotWeaponDamageBreakdowns,
		function(battleRifleDamage)
			return battleRifleDamage:GetDamageTime() > chargedPlasmaPistolDamageBreakdowns[1]:GetDamageTime();
		end
		);

	if not allBRDamageAfterPlasma then
		return false;
	end

	return true;
end

onNoobCombo = killTypeSelect:Add(
	function(context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot 
		and context.KillingPlayerUnit ~= nil
		and context.DeadPlayerUnit ~= nil
		and IsNoobCombo(context);
	end
	);

--
-- BXR (melee a player and then kill them with a single shot)
--

local maximumNumberOfMissedShots = 1;
local maximumNumberOfLandedShots = 3;

onBxrKill = killTypeSelect:Add(
	function(context)
		local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);
		
		local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
			end
			);

		if deadPlayerDamageHistoryFromKillingPlayer == nil then
			return false;
		end

		-- killing player should be the only damage source
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end

		local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

		--check that all shots were correct damage type (BR or melee)

		local allShotsCorrectDamageType = table.all(damageBreakdowns,
			function (breakdown)
				return breakdown:GetDamageSource() == BattleRifleDamageSource or breakdown:GetDamageType() == MeleeDamageType;
			end
			);

		if allShotsCorrectDamageType == false then
			return false;
		end

		--only one melee attack
		local meleeDamage = table.filtervalues(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == MeleeDamageType;
			end
			);

		if #meleeDamage ~= 1 then
			return false;
		end

		--melee damage should be first damage taken
		if meleeDamage[1]:GetDamageTime() > deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() then
			return false;
		end

		-- go back in time 1/4 a second so that we can see if the last few bullets of the br burst missed.
		local firstEngagementTime = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() - 0.25;

		local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
			function (shotInfo)
				return shotInfo:GetShotTime() >= firstEngagementTime;
			end
			);

		local missedShots = table.filtervalues(allShotsSinceEngagingPlayer,
			function (shotInfo)
				return shotInfo:DealtPlayerDamage() == false;
			end
			);

		if #missedShots > maximumNumberOfMissedShots then
			return false;
		end

		local shotsOnDeadPlayer = table.filtervalues(allShotsSinceEngagingPlayer,
			function (shotInfo)
				return shotInfo:GetDamagedPlayer() == context.DeadPlayer;
			end
			);

		if #shotsOnDeadPlayer > maximumNumberOfLandedShots then
			return false;
		end

		return true;
	end
	);

--
-- Nadeshot - grenade followed by quick headshot
--

local grenadeDamageTimeWindow = 1;

function IsNadeshot(context)

	--player has to die from a headshot
	if context.DamageReportingModifier ~= DamageReportingModifier.Headshot then
		return false;
	end

	--get damage histories and breakdowns.
	--ensure that killing player did essentially all damage
	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
		function (damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);

	if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
		return false;
	end

	local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

	-- find all grenade damage
	local grenadeDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return table.any(GrenadeDamageSources,
				function(damageSource)
					return breakdown:GetDamageSource() == damageSource;
				end
				);
		end
		);

	-- find all gun damage
	local headshotWeaponDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return table.any(HeadshotWeaponDamageSources,
				function(damageSource)
					return breakdown:GetDamageSource() == damageSource and breakdown:GetDamageType() == BulletDamageType;
				end
				);
		end
		);

	-- took at least one damage from gun and grenade
	if #grenadeDamageBreakdowns == 0 or #headshotWeaponDamageBreakdowns == 0 then
		return false;
	end

	--all damage needs to be from grenade explosions or headshot weapon bullets
	local allDamageCorrectDamageSources = table.all(damageBreakdowns,
		function(breakdown)
			return table.any(grenadeDamageBreakdowns,
				function(grenadeDamageBreakdown)
					return breakdown == grenadeDamageBreakdown;
				end
				)
			or table.any(headshotWeaponDamageBreakdowns,
				function(weaponDamageBreakdown)
					return breakdown == weaponDamageBreakdown;
				end
				);
		end
		);

	if not allDamageCorrectDamageSources then
		return false;
	end

	-- all gun damage needs to be from the same gun
	local selectedWeaponDamageSource = headshotWeaponDamageBreakdowns[1]:GetDamageSource();

	local allGunDamageFromSameWeapon = table.all(headshotWeaponDamageBreakdowns,
		function(weaponDamageBreakdown)
			return weaponDamageBreakdown:GetDamageSource() == selectedWeaponDamageSource;
		end
		);

	if not allGunDamageFromSameWeapon then
		return false;
	end

	-- all grenade damage needs to happen within moments of each other
	-- this is specifically to allow this to work with forerunner grenades
	local tookGrenadeDamageOutsideOfTimeWindow = table.any(grenadeDamageBreakdowns, 
		function(breakdown)
			return breakdown:GetDamageTime() > deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() + grenadeDamageTimeWindow;
		end
		);
	if tookGrenadeDamageOutsideOfTimeWindow then
		return false;
	end

	-- all weapon damage has to come after grenade damage
	local weaponDamageOccuredAfterGrenadeDamage = table.all(headshotWeaponDamageBreakdowns,
		function(weaponDamageBreakdown)
			return table.all(grenadeDamageBreakdowns,
				function(grenadeDamageBreakdown)
					return grenadeDamageBreakdown:GetDamageTime() < weaponDamageBreakdown:GetDamageTime();
				end
				);
		end
		);

	if not weaponDamageOccuredAfterGrenadeDamage then
		return false;
	end


	-- go back in time 1/4 a second so that we can see if the last few shots missed.
	local firstEngagementTime = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() - 0.25;

	local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
		function (shotInfo)
			return shotInfo:GetShotTime() >= firstEngagementTime;
		end
		);

	if #allShotsSinceEngagingPlayer > 1 then 
		-- check if BR
		-- if not br, return false.  if it is a BR, if the gun has fired more than a single burst, return false
		if selectedWeaponDamageSource ~= BattleRifleDamageSource or #allShotsSinceEngagingPlayer > 3 then
			return false;
		end
	end	

	return true;	
end

onNadeshotKill = killTypeSelect:Add(
	function(context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot
		and context.KillingObject ~= nil
		and context.DeadObject ~= nil
		and IsNadeshot(context);
	end
	);

--
-- Quickdraw
--

function IsQuickdraw(context)

	--player has to die from a magnum headshot
	if context.DamageSource ~= MagnumDamageSource or context.DamageReportingModifier ~= DamageReportingModifier.Headshot then
		return false;
	end

	--get damage histories and breakdowns.
	--ensure that killing player did essentially all damage
	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
		function (damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);

	if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
		return false;
	end

	local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

	-- Make sure that we took damage from the magnum as well as another non-power weapon 
	local tookMagnumDamage = table.any(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageSource() == MagnumDamageSource 
			and breakdown:GetDamageType() == BulletDamageType;
		end
		);

	local tookOtherWeaponDamage = table.any(damageBreakdowns,
		function(breakdown)
			return table.any(NonPowerWeaponDamageSources,
				function(source)
					return breakdown:GetDamageSource() ~= MagnumDamageSource 
					and breakdown:GetDamageSource() == source 
					and breakdown:GetDamageType() == BulletDamageType;
				end
				);
		end
		);

	if not tookMagnumDamage or not tookOtherWeaponDamage then
		return false;
	end

	-- go back in time 1/4 a second so that we can see if the last few shots missed.
	local firstEngagementTime = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() - 0.5;

	local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
		function (shotInfo)
			return shotInfo:GetShotTime() >= firstEngagementTime;
		end
		);

	local magnumShots = table.filtervalues(allShotsSinceEngagingPlayer, 
		function(shotInfo)
			if not shotInfo:DealtPlayerDamage() then
				return false;
			end

			return shotInfo:GetDamageSource() == MagnumDamageSource;
		end
		);

	if #magnumShots ~= 1 then
		return false;
	end

	return true;
end

onQuickdraw = killTypeSelect:Add(
	function(context)
		return context.KillingObject ~= nil
		and context.DeadObject ~= nil
		and IsQuickdraw(context);
	end
	);

--
-- Perfect Kills
--

function PerfectKill (context, damageSource, maximumNumberOfMissedShots, minimumNumberOfLandedShots, maximumNumberOfLandedShots, maximumNumberOfShots, maximumEngagementDuration)

	if not PlayerHasFullBodyAndShieldMaxVitality(context.DeadPlayer) then
		return false;
	end

	local damageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	local killingPlayersDamageHistory = table.first(damageHistories,
		function (damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);

	if killingPlayersDamageHistory:GetTotalNormalizedDamage() < 0.95 then
		return false;
	end

	local damageBreakdowns = context:GetDamageHistoryBreakdowns(killingPlayersDamageHistory);

	local allShotsCorrectDamageType = table.all(damageBreakdowns,
		function (breakdown)
			return (breakdown:GetDamageSource() == damageSource and breakdown:GetDamageType() == BulletDamageType)
			or breakdown:GetNormalizedDamageAmount() < 0.1;
		end
		);

	if allShotsCorrectDamageType == false then
		return false;
	end

	-- check total engagement time
	if GetGameTime() - killingPlayersDamageHistory:GetFirstDamageTime() > maximumEngagementDuration then
		return false;
	end

	-- go back in time 1/4 a second so that we can see if the last few bullets of the br burst missed.
	local firstEngagementTime = killingPlayersDamageHistory:GetFirstDamageTime() - 0.25;

	local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
		function (shotInfo)
			return shotInfo:GetShotTime() >= firstEngagementTime;
		end
		);

	if #allShotsSinceEngagingPlayer > maximumNumberOfShots then
		return false;
	end

	local missedShots = table.filtervalues(allShotsSinceEngagingPlayer,
		function (shotInfo)
			return shotInfo:DealtPlayerDamage() == false;
		end
		);

	if #missedShots > maximumNumberOfMissedShots then
		return false;
	end

	local shotsOnDeadPlayer = table.filtervalues(allShotsSinceEngagingPlayer,
		function (shotInfo)
			return shotInfo:GetDamagedPlayer() == context.DeadPlayer;
		end
		);

	if #shotsOnDeadPlayer > maximumNumberOfLandedShots 
	or #shotsOnDeadPlayer < minimumNumberOfLandedShots then
		return false;
	end

	return true;

end

function BattleRiflePerfectKill(context)
	return context.DamageSource == BattleRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, BattleRifleDamageSource, 2, 11, 12, 12, 3.2);
end

function LightRiflePerfectKill(context)
	return context.DamageSource == LightRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, LightRifleDamageSource, 0, 3, 3, 3, 3.2);
end

function DMRPerfectKill(context)
	return context.DamageSource == DmrDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, DmrDamageSource, 0, 5, 5, 5, 3.2);
end

function MagnumPerfectKill(context)
	return context.DamageSource == MagnumDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, MagnumDamageSource, 0, 5, 5, 5, 3.2);
end

function FlagnumPerfectKill(context)
	return context.DamageSource == FlagnumDamageSource
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and PerfectKill(context, FlagnumDamageSource, 0, 5, 5, 5, 3.2);
end

function CarbinePerfectKill(context)
	return context.DamageSource == CarbineDamageSource
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and PerfectKill(context, CarbineDamageSource, 0, 7, 7, 7, 3.2);
end

onBattleRifleFourShot = killTypeSelect:Add(BattleRiflePerfectKill);

onLightRifleThreeShot = killTypeSelect:Add(LightRiflePerfectKill);

onDMRFiveShot = killTypeSelect:Add(DMRPerfectKill);

onMagnumFiveShot = killTypeSelect:Add(MagnumPerfectKill);

onFlagnumFiveShot = killTypeSelect:Add(FlagnumPerfectKill);

onCarbineSevenShot = killTypeSelect:Add(CarbinePerfectKill);
--
-- Headshot
--

onHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);

--
-- Grenade impact event
--

function IsGrenadeImpactKill(context)
	return table.any(GrenadeDamageSources,
		function(damageSource)
			return context.DamageType == GrenadeImpactDamageType
			and context.DamageSource == damageSource;
		end
		);
end

onGrenadeImpactKill = killTypeSelect:Add(IsGrenadeImpactKill);

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

function IsGrenadeKillInVehicle (context)
	return context.KillingPlayerUnit ~= nil
	and context.KillingPlayerUnit:GetVehicle() ~= nil
	and not context.KillingPlayerUnit:IsDrivingVehicle()
	and not context.KillingPlayerUnit:IsGunnerInVehicle()
	and not context.KillingPlayerUnit:IsBoardingVehicle()
	and IsGrenadeKill(context);
end

--
-- Hail Mary
--

onHailMary = onEnemyPlayerKill:Filter(
	IsHailMary
	);
	
--
-- Stuck
--

onStuck = onEnemyPlayerKill:Filter(
	IsStuck
	);

--
-- Pineapple Express
--

onPineappleExpress = onEnemyPlayerKill:Filter(
	IsGrenadeKillInVehicle
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
-- Sniper Headshots in a row
--

consecutiveSniperHeadshotsAccumulator = root:CreatePlayerAccumulator();

-- Count headshots
onConsecutiveSniperHeadshots = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot
		and context.DamageType == BulletDamageType
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
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
onNonHeadshotKill = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageReportingModifier ~= DamageReportingModifier.Headshot
		or context.DamageType ~= BulletDamageType
		or not table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			)
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

onKillsSinceDeath = onEnemyPlayerKill:PlayerAccumulator(
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
-- Killjoy
--
	
onKilljoy = onEnemyPlayerKill:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.DeadPlayer) >= 5;
	end
	);
	
--
-- Player kills in a row.
--

local multikillSeconds = 5.0;

killsInARowAccumulator = root:CreatePlayerAccumulator(multikillSeconds);

onKillsInARow = onEnemyPlayerKill:PlayerAccumulator(
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

onEnemyPlayerKill:ResetPlayerAccumulator(
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
-- Extermination
--

exterminationAccumulator = root:CreatePlayerAccumulator();

onExterminationCounter = onKillsInARow:Filter(
	function (context)

		if context.Engine:TeamsEnabled() then

			if killsInARowAccumulator:GetValue(context.KillingPlayer) >= 4 then

				local hostilePlayers = table.filtervalues(context:GetAllPlayers(), 
					function (player)
						return player:IsHostile(context.KillingPlayer);
					end
					);
				
				return table.all(hostilePlayers,
					function (player)
						return player == context.DeadPlayer or player:GetLastKillingPlayer() == context.KillingPlayer;
					end
					);
		
			end
		end
		return false;
	end
	):PlayerAccumulator(
		exterminationAccumulator,
		function(context)
			return context.KillingPlayer;
		end
		);

onExtermination = onExterminationCounter:Filter(
	function(context)
		return exterminationAccumulator:GetValue(context.KillingPlayer) < 1;
	end
	);

--
-- Kills per round.
--

killsInRoundAccumulator = root:CreateAccumulator();

onKillsInRound = onEnemyPlayerKill:Accumulator(killsInRoundAccumulator);

onFirstKill = onKillsInRound:Filter(
	function (context)
		return killsInRoundAccumulator:GetValue() == 1;
	end
	);

--
-- Kills per Round Reset
--
	 
if (resetKillsInRoundOnRoundStart == nil or resetKillsInRoundOnRoundStart) then
	onRoundStart:ResetAccumulator(killsInRoundAccumulator);
end
	
--
-- Protector (save a teammate by killing his attacker)
--

local damageDealtFromDeadPlayerThreshold = 0.25;

function FindProtectedPlayer(context)
	local deadPlayerUnit = context.DeadPlayer:GetUnit();

	if deadPlayerUnit == nil then
		return false;
	end

	local protectedPlayers = table.filtervalues(context:GetAllPlayers(),
		function(player)

			--remove hostile players
			if player == context.KillingPlayer or context.KillingPlayer:IsHostile(player) then
				return false;
			end

			local playerUnit = player:GetUnit();

			if playerUnit == nil then
				return false;
			end

			--remove dead players
			if playerUnit:IsDead() then
				return false;
			end

			local hostileToDeadPlayerDamageHistory = context:GetPlayerDamageHistory(player);

			local hostileToDeadPlayerDamageFromDeadPlayer = table.first(hostileToDeadPlayerDamageHistory,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);

			--remove players that didn't take damage from the dead player
			if hostileToDeadPlayerDamageFromDeadPlayer == nil then
				return false;
			end

			if hostileToDeadPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() < damageDealtFromDeadPlayerThreshold then
				return false;
			end

			--player has to have no shields and taken some health damage in order to be protected
			if playerUnit:GetShield() > 0 then
				return false;
			end

			return true;
		end
		);

	if #protectedPlayers > 0 then
		context.ProtectedPlayer = protectedPlayers[1];
	end
end

function ProtectedPlayer(context)
	return context.ProtectedPlayer;
end

onProtectorKill = onEnemyPlayerKill:Emit(FindProtectedPlayer):Filter(
	function(context)
		return context.ProtectedPlayer ~= nil;
	end
	);

--
-- Guardian Angel (protector from long range)
--

protectorSelect = onProtectorKill:Select();

if enableFlagCarrierProtectedMedal then

	onFlagCarrierProtected = protectorSelect:Add(
		function(context)
			return context.ProtectedPlayer:IsFlagCarrier();
		end
		);
end

onLongRangeProtectorKill = protectorSelect:Add(
	function(context)
		return context.DeadObject:GetDistance(context.KillingObject) >= 14;
	end
	);

onShortRangeProtectorKill = protectorSelect:Add(
	);

--
-- Bodyguard (3 protector medals before death)
--

protectorAccumulator = root:CreatePlayerAccumulator();

onProtectorSinceDeath = onProtectorKill:PlayerAccumulator(
	protectorAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

onThreeProtectorSinceDeath = onProtectorSinceDeath:Filter(
	function (context)
		return protectorAccumulator:GetValue(context.KillingPlayer) % 3 == 0;
	end
	);

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

onKillFromTheGrave = onEnemyPlayerKill:Filter(
	function (context)
		return PlayerIsDead(context.KillingPlayer) 
			and context.KillingPlayer:GetSecondsSinceDeath() > 0.25;
	end
	);

--
-- Showstopper
--

onShowStopper = onEnemyPlayerKill:Filter(
	function (context)
		return context.DeadPlayer:IsAssassinating();
	end
	);
		
--
-- Cliffhanger
--

onCliffhanger = onEnemyPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsClambering();
	end
	);

--
-- Longshot
--

local LongshotDistanceForPrecisionWeapons = 30;

onLongshot = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadObject ~= nil 
		and context.KillingObject ~= nil
		and context.DeadObject:GetDistance(context.KillingObject) >= LongshotDistanceForPrecisionWeapons
		and table.any(NonSniperHeadshotDamageSoures,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Spray and Pray - Assault Rifle
--

local SprayAndPrayDistanceForAutoWeapons = 16;

onSprayAndPray = onEnemyPlayerKill:Filter(
	function (context)
		return context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= SprayAndPrayDistanceForAutoWeapons
		and table.any(AutomaticWeaponDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
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

onSniperLongshot = onEnemyPlayerKill:Filter(
	function (context)
		return context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 75
		and table.any(SniperDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Bulltrue
--

onBulltrue = onEnemyPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsLunging() and deadPlayerUnit:GetPrimaryWeapon():GetClassName() == SwordObjectClassName;
	end
	);

--
-- Starkiller
--

onStarkiller = onEnemyPlayerKill:Filter(
	function(context)
		local deadPlayerBiped = context.DeadPlayer:GetBiped();

		return deadPlayerBiped ~= nil 
		and deadPlayerBiped:IsGroundPoundLaunched();
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
-- Team Takedown
--

function IsTeamTakedown(context)
	local friendlyAssistingPlayers = table.filtervalues(context.AssistingPlayers,
		function(player)
			return context.KillingPlayer:IsFriendly(player);
		end
		);

	if #friendlyAssistingPlayers < 3 then
		return false;
	end
		
	return true;
end

if (disableTeamTakedownMedal == nil) then
	onTeamTakedown = onEnemyPlayerKill:Filter(IsTeamTakedown);
end

--
-- Reversal (Kill an enemy that shot you first)
--

local reversalEngagementTimeBuffer = 0.9;
local deadPlayerDamageDealtBeforeTakingDamageThreshold = 0.25;

onReversal = onEnemyPlayerKill:Filter(
	function(context)
		
		if PlayerIsDead(context.KillingPlayer) then
			return false;
		end

		local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

		local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
			end
			);

		if deadPlayerDamageHistoryFromKillingPlayer == nil then
			return false;
		end
		
		-- killing player should be the only damage source
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end

		-- Killing player should not have used a power weapon
		local deadPlayerDamageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer)

		local dealtDamageWithPowerWeaponOrVehicle = table.any(deadPlayerDamageBreakdowns, 
			function(breakdown)

				local breakdownDamageSource = breakdown:GetDamageSource();

				for _ , value in pairs(PowerWeaponDamageSources) do
					if (breakdownDamageSource == value) then
						return true;
					end
				end

				for _ , value in pairs(AllVehicleDamageSources) do
					if(breakdownDamageSource == value) then
						return true;
					end
				end

				for _ , value in pairs(AllTurretDamageSources) do
					if(breakdownDamageSource == value) then
						return true;
					end
				end

				return false;
			end
			);

		if dealtDamageWithPowerWeaponOrVehicle == true then
			return false;
		end

		-- the dead player needs to first take damage after the killing player first took damage
		local killingPlayerDamageHistories = context:GetPlayerDamageHistory(context.KillingPlayer);

		if killingPlayerDamageHistories == nil then
			return false;
		end

		local killingPlayerDamageHistoryFromDeadPlayer = table.first(killingPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
			end
			);

		if killingPlayerDamageHistoryFromDeadPlayer == nil then
			return false;
		end

		local timeDeadPlayerTookFirstDamage = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime();

		local timeKillingPlayerTookFirstDamage = killingPlayerDamageHistoryFromDeadPlayer:GetFirstDamageTime();

		if timeDeadPlayerTookFirstDamage + reversalEngagementTimeBuffer < timeKillingPlayerTookFirstDamage then
			return false;
		end

		-- the dead player needs to have dealt enough damage to the killing player before the killing player attacks
		local killingPlayerDamageBreakdownBeforeEngaging = table.filtervalues(context:GetDamageHistoryBreakdowns(killingPlayerDamageHistoryFromDeadPlayer),
			function(breakdown)
				return breakdown:GetDamageTime() < timeDeadPlayerTookFirstDamage;
			end
			);

		local damageDealtBeforeKillingPlayerEngaged = 0;

		for _ , value in ipairs(killingPlayerDamageBreakdownBeforeEngaging) do

			damageDealtBeforeKillingPlayerEngaged = damageDealtBeforeKillingPlayerEngaged + value:GetNormalizedDamageAmount();
		end

		if damageDealtBeforeKillingPlayerEngaged < deadPlayerDamageDealtBeforeTakingDamageThreshold then
			return false;
		end

		return true;
	end
	);

--
-- Last Shot (kill an enemy with the last bullet in a clip)
--

onEnemyPlayerKillWithLastBullet = onEnemyPlayerKill:Filter(
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

		local killedByPowerWeapon = table.any(PowerWeaponDamageSources,
			function(powerWeaponDamageSource)
				return context.DamageSource == powerWeaponDamageSource;
			end
			);

		local killedByEnergyWeapon = table.any(EnergyWeaponDamageSources,
			function(energyWeaponDamageSource)
				return context.DamageSource == energyWeaponDamageSource;
			end
			);

		if killedByPowerWeapon or killedByEnergyWeapon then
			return false;
		end

		if context.DamageType ~= BulletDamageType then
			return false;
		end

		return true;
	end
	);

--
-- Distraction
--

local distractingPlayerDamageTakenThreshold = 0.2;
local killingPlayerDamageTakenThreshold = 0.3;
local deadPlayerDamageTakenFromDistractingPlayerThreshold = 0.05;

function DistractingPlayers(context)

	return table.filter(context:GetAllPlayers(),
		function(distractingPlayer)

			if distractingPlayer == context.KillingPlayer or distractingPlayer:IsFriendly(context.DeadPlayer) or PlayerIsDead(distractingPlayer) then
				return false;
			end

			-- dead player dealt damage to the distracting player
			local distractingPlayerDamageHistories = context:GetPlayerDamageHistory(distractingPlayer);

			local distractingPlayerDamageFromDeadPlayer = table.first(distractingPlayerDamageHistories,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);

			if distractingPlayerDamageFromDeadPlayer == nil or distractingPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() < distractingPlayerDamageTakenThreshold then
				return false;
			end

			-- dead player did very little damage to the killing player

			local killingPlayerDamageHistories = context:GetPlayerDamageHistory(context.KillingPlayer);

			local killingPlayerDamageFromDeadPlayer = table.first(killingPlayerDamageHistories,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);

			if killingPlayerDamageFromDeadPlayer ~= nil and killingPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() > killingPlayerDamageTakenThreshold then 
				
				return false;
			end

			-- distracting player didn't deal damage to dead player
			local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

			local deadPlayerDamageFromDistractingPlayer = table.first(deadPlayerDamageHistories,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == distractingPlayer;
				end
				);

			if deadPlayerDamageFromDistractingPlayer ~= nil and deadPlayerDamageFromDistractingPlayer:GetTotalNormalizedDamage() > deadPlayerDamageTakenFromDistractingPlayerThreshold then
				return false;
			end 

			return true;
		end
		);
end

onDistraction = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadObject ~= nil
		and context.KillingObject ~= nil
	end
	);

--
-- Assist events
--
function FindEmpAssistPlayers(context)

	local empAssistPlayers = { };

	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

	for _ , assistingPlayer in pairs(context.AssistingPlayers) do

		local deadPlayerDamageHistoryFromAssistingPlayer = table.first(deadPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == assistingPlayer;
			end
			);

		if deadPlayerDamageHistoryFromAssistingPlayer ~= nil then

			local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromAssistingPlayer);

			local dealtEmpDamage = table.any(damageBreakdowns,
				function(breakdown)
					return breakdown:GetDamageSource() == PlasmaPistolDamageSource
					and (breakdown:GetDamageType() == ChargedPlasmaDamageType or breakdown:GetDamageType() == ExplosionDamageType);
				end
				);

			if dealtEmpDamage then
				table.insert(empAssistPlayers, assistingPlayer);
			end
		end
	end

	return empAssistPlayers;
end

function FindNonEmpAssistPlayers(context)
	local empAssistPlayers = FindEmpAssistPlayers(context);
	local nonEMPAssistPlayers = { };

	for _ , assistPlayer in pairs(context.AssistingPlayers) do
		local playerIsEmpAssisting = table.any(empAssistPlayers,
			function(empAssistPlayer)
				return assistPlayer == empAssistPlayer;
			end
			);

		if not playerIsEmpAssisting then
			table.insert(nonEMPAssistPlayers, assistPlayer);
		end
	end

	return nonEMPAssistPlayers;
end

function IsEmpAssist(context)
	if context.AssistingPlayers == nil then
		return false;
	end

	local empAssistPlayers = FindEmpAssistPlayers(context);

	return #empAssistPlayers > 0;
end

onPlayerAssist = onEnemyPlayerKill:Filter(
	function(context)
		return context.AssistingPlayers ~= nil
		and #context.AssistingPlayers > 0;
	end
	);

-- Assist Select

assistSelect = onPlayerAssist:Select();

if (disableTeamTakedownMedal == nil) then
	onTeamTakedownAssist = assistSelect:Add(IsTeamTakedown);
end

onPoundTownAssist = assistSelect:Add(IsPoundTown);

onEmpAssist = assistSelect:Add(IsEmpAssist);

if (enableKillMedals) then
	onGenericAssist = assistSelect:Add();
end
	
--
-- Assist Spree Events
--

assistsSinceDeathAccumulator = root:CreatePlayerAccumulator();

onAssistsSinceDeath = onPlayerAssist:PlayerAccumulator(
	assistsSinceDeathAccumulator,
	function (context)
		return context.AssistingPlayers;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	assistsSinceDeathAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
	
function PlayersWithFiveAssists(context)
	if(context.AssistingPlayers ~= nil) then

		return table.filter(context.AssistingPlayers,
			function(player)
				return assistsSinceDeathAccumulator:GetValue(player) % 5 == 0;
			end
			);
	else
		return nil;
	end
end

-- Reset accumulator on Round Start
	 
if (resetAssistsSinceDeathOnRoundStart == nil or resetAssistsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(assistsSinceDeathAccumulator);
end 

function FindWheelman(context)
	if context.KillingPlayerUnit == nil then
		return nil;
	end

	local killingPlayerDrivingVehicle = context.KillingPlayerUnit:IsDrivingVehicle() ;

	if context.KillingPlayerUnit == nil or context.KillingPlayerUnit:IsDrivingVehicle() then
		return nil;
	end

	local killingPlayerVehicle = context.KillingPlayerUnit:GetVehicle();

	if killingPlayerVehicle == nil then
		return nil;
	end

	return table.filter(context:GetAllPlayers(),
		function(player)
			local playerUnit = player:GetUnit();

			return playerUnit ~= nil 
			and playerUnit:GetVehicle() == killingPlayerVehicle
			and playerUnit:IsDrivingVehicle()
			and playerUnit:IsFriendly(context.KillingPlayerUnit);
		end
		);
end

--
-- Triple Double
--

tripleDoublePlayers = { };

tripleDoubleHeadshotAccumulator = root:CreatePlayerAccumulator();

tripleDoubleAssistAccumulator = root:CreatePlayerAccumulator();

tripleDoubleKillAccumulator = root:CreatePlayerAccumulator();

tripleDoubleHeadshot = onEnemyPlayerKill:Filter(
	function(context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);

tripleDoubleHeadshotCounter = tripleDoubleHeadshot:PlayerAccumulator(
		tripleDoubleHeadshotAccumulator,
		function(context)
			return context.KillingPlayer;
		end
		);	

tripleDoubleAssistCounter = onEnemyPlayerKill:PlayerAccumulator(
	tripleDoubleAssistAccumulator,
	function(context)
		return context.AssistingPlayers;
	end
	);

tripleDoubleKillCounter = onEnemyPlayerKill:PlayerAccumulator(
	tripleDoubleKillAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);

function FindNewPlayersWithTripleDouble(context)
	local playersParticipatingInRecentKill = {[1] = context.KillingPlayer};
	local newTripleDoublePlayers = { };

	if context.AssistingPlayers ~= nil then
		for _ , player in pairs(context.AssistingPlayers) do
			if player ~= nil then
				table.insert(playersParticipatingInRecentKill, player);
			end
		end
	end

	for _ , player in pairs(playersParticipatingInRecentKill) do
		if not table.contains(tripleDoublePlayers, player) 
		and tripleDoubleHeadshotAccumulator:GetValue(player) >= 10
		and tripleDoubleKillAccumulator:GetValue(player) >= 10
		and tripleDoubleAssistAccumulator:GetValue(player) >= 10 then
			table.insert(newTripleDoublePlayers, player);
			table.insert(tripleDoublePlayers, player);
		end
	end

	return newTripleDoublePlayers;
end
 
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

function EnteringPlayer(context)
	return context.EnteringPlayer;
end

function ExitingPlayer(context)
	return context.ExitingPlayer;
end

onLandVehicleJacked = onVehicleJacked:Filter(
	function (context)

		if context.TargetVehicle == nil or context.EnteringPlayer == nil then
			return false;
		end

		return table.any(LandVehicleTypes, 
			function(vehicleType)
				return context.TargetVehicle:GetCampaignMetagameType() == vehicleType;
			end
			);
	end
	);

onAirVehicleJacked = onVehicleJacked:Filter(
	function(context)

		if context.TargetVehicle == nil or context.EnteringPlayer == nil then
			return false;
		end

		return table.any(AirVehicleTypes, 
			function(vehicleType)
				return context.TargetVehicle:GetCampaignMetagameType() == vehicleType;
			end
			);
	end
	);

--
-- Busted
--

onBusted = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadPlayerUnit ~= nil
		and context.DeadPlayerUnit:IsBoardingVehicle();
	end
	);

--
-- Buckle Up - snipe an enemy out of a moving vehicle
--

onBuckleUp = onAllSniperKills:Filter(
	function(context)
		if context.DeadPlayerUnit == nil or context.DeadPlayerUnit:IsBoardingVehicle() then
			return false;
		end

		local deadPlayerVehicle = context.DeadPlayerUnit:GetVehicle();

		if deadPlayerVehicle == nil then
			return false;
		end

		local deadPlayerVehicleType = deadPlayerVehicle:GetCampaignMetagameType();
				
		return table.contains(AllVehicleTypes, deadPlayerVehicleType); 
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
-- Player Shields Regenerated
--

onPlayerRegeneratedShields = root:AddCallback(
	__OnPlayerRegeneratedShields,
	function (context, player)
		context.TargetPlayer = player;
	end
	);

onValidPlayerShieldRegen = onPlayerRegeneratedShields:Filter(
	function(context)
		local targetUnit = context.TargetPlayer:GetUnit();
		return (targetUnit ~= nil and targetUnit:GetVehicle() == nil); 
	end
	);
	
--
-- Hard Target (player regenerated shields 10 times)
--

shieldsRechargedSinceDeathAccumulator = root:CreatePlayerAccumulator();

onShieldsRechargedSinceDeath = onValidPlayerShieldRegen:PlayerAccumulator(
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
		return shieldsRechargedSinceDeathAccumulator:GetValue(context.TargetPlayer) % 10 == 0;
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

onCloseCallKill = onEnemyPlayerKill:PlayerAccumulator(
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

onValidPlayerShieldRegen:ResetPlayerAccumulator(
	closeCallKillAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);

-- Close Call

local closeCallDamageThreshold = 0.8;

onCloseCall = onPlayerStartingShieldRegeneration:Filter(
	function(context)
		local targetPlayerDamageHistories = context:GetPlayerDamageHistory(context.TargetPlayer);

		local totalDamageTaken = 0;

		for key, value in pairs(targetPlayerDamageHistories) do
			if value == nil then
				return false;
			end

			local attackingPlayer = value:GetAttackingPlayer();

			if attackingPlayer ~= nil and attackingPlayer:IsHostile(context.TargetPlayer) then
				totalDamageTaken = totalDamageTaken + value:GetTotalNormalizedDamage();
			end
		end

		if totalDamageTaken < closeCallDamageThreshold then
			return false;
		end

		if closeCallKillAccumulator:GetValue(context.TargetPlayer) < 1 then
			return false;
		end

		return true;
	end
	);

--
-- Big Game Hunter (kill 2 enemies that have power weapons before dying)
--

bigGameHunterAccumulator = root:CreatePlayerAccumulator();

onBigGameKill = onEnemyPlayerKill:Filter(
	function(context)
		
		-- TODO: v-magro (5/28/15): HACK FOR CONAN to disable powerPlayer
		if disableBigGameHunter ~= nil and disableBigGameHunter then
			return false;
		end

		local deadPlayerUnit = context.DeadPlayer:GetUnit();

		if deadPlayerUnit == nil then
			return false;
		end

		local deadPlayerPrimaryWeapon = deadPlayerUnit:GetPrimaryWeapon();

		if deadPlayerPrimaryWeapon == nil then
			return false;
		end

		for index, weaponName in ipairs(PowerWeaponNames) do
			if deadPlayerPrimaryWeapon:GetName() == weaponName then
				return true;
			end
		end
		return false;
	end
	);

onBigGameKillAccumulate = onBigGameKill:PlayerAccumulator(
	bigGameHunterAccumulator,
	function(context)
		return context.KillingPlayer;
	end
	);

onBigGameHunter = onBigGameKillAccumulate:Filter(
	function(context)
		return bigGameHunterAccumulator:GetValue(context.KillingPlayer) % 3 == 0;
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

--
-- Server Shutdown
--

__OnServerShutdown = Delegate:new();

onServerShutdown = root:AddCallback(
	__OnServerShutdown
	);
	
genericServerShutdownWarningResponse = onServerShutdown:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_warning',
	});
