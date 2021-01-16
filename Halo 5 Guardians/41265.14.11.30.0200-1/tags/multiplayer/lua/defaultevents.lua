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
-- Generic Kill Feed Functions
--

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

--
-- Data definitions
--

FanfareDefinitions = 
{
	PersonalScore = 'multiplayer\fanfare\personal_score',
	GameScore = 'multiplayer\fanfare\game_score',
	GameState = 'multiplayer\fanfare\game_state',
	Highlights = 'multiplayer\fanfare\highlights',
	KillFeed = 'multiplayer\fanfare\kill_feed',
	QuestFeed = 'multiplayer\fanfare\quest_feed'
};

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
		Sound = 'multiplayer\audio\announcer\announcer_shared_gametied'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_matchover_neutral'
	});


--
-- Player activated
--

function ActivatedPlayer(context)
	return context.ActivatedPlayer
end

onPlayerActivated = root:AddCallback(
	__OnPlayerActivated,
	function (context, activatedPlayer)
		context.ActivatedPlayer = activatedPlayer;
	end
	);

--
-- Player Joined/Rejoined
--

onPlayerJoined = root:AddCallback(
	__OnPlayerAdded,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

onPlayerJoinedFriendlyResponse = onPlayerJoined:Target(FriendlyToTargetPlayer):Response(
	{	
		Sound = 'multiplayer\audio\announcer\announcer_shared_teammatejoined'
	});

onPlayerJoinedGeneralResponse = onPlayerJoined:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = function (context)
			return FormatText('player_joined', context.TargetPlayer);
		end
	});

onPlayerRejoined = root:AddCallback(
	__OnPlayerRejoined,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

onPlayerRejoinedFriendlyResponse = onPlayerRejoined:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_teammatejoined'
	});

onPlayerRejoinedGeneralResponse = onPlayerRejoined:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = function (context)
			return FormatText('player_rejoined', context.TargetPlayer);
		end
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
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = function (context)
			return FormatText('player_left', context.TargetPlayer);
		end
	});

--
-- Kill events
--

onKill = root:AddCallback(
	__OnKill,
	function (context, killingPlayer, killingObject, deadPlayer, deadObject, source, type, modifier)

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
-- Player Death
--

DeathResponse = onPlayerDeath:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_death'
	});

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
-- Assist events
--

onAssist = root:AddCallback(
	__OnAssist,
	function (context, assistingPlayer, deadPlayer, killingPlayer)
		context.AssistingPlayer = assistingPlayer;
		context.DeadPlayer = deadPlayer;
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
			and (context.DeadPlayer ~= nil) 
			and (context.AssistingPlayer ~= context.DeadPlayer)
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
		return context.DamageSource == fallingDamageSource
	end
	);

--
-- Sword kill
--

--
-- Gladiator
--

if(enableGladiatorMedal) then

	onGladiator = killTypeSelect:Add(
		function(context)
			return context.DeadPlayer:InAnyStronghold()
			and table.any(swordDamageSources,
				function(damageSource)
					return context.DamageSource == damageSource;
				end
				);
		end
		);
end

onSwordKill = killTypeSelect:Add(
	function (context)
		return table.any(swordDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);

--
-- Gunpunch (2 shots then melee)
--

function GunpunchKill(context, maximumNumberOfMissedShots, maximumNumberOfLandedShots)

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

	local deadPlayerOnlyTookBrAndMeleeDamage = table.all(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == meleeDamageType or breakdown:GetDamageSource() == battleRifleDamageSource
		end
		);

	--dead player should only take damage that was melee or br
	if not deadPlayerOnlyTookBrAndMeleeDamage then 
		return false;
	end

	local meleeDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == meleeDamageType;
		end
		);

	--dead player should only be hit with 1 melee
	if #meleeDamageBreakdowns ~= 1 then
		return false;
	end

	local brDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == bulletDamageType and breakdown:GetDamageSource() == battleRifleDamageSource;
		end
		);

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
		return context.DamageType == meleeDamageType
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and GunpunchKill(context, 1, 6);
	end
	);

--
-- Brawler (melee kill while enemy is shooting you)
--

local brawlerTimeDamageTakenThreshold = 1.5;

onBrawlerKill = killTypeSelect:Add(
	function(context)
		if context.DamageType ~= meleeDamageType then
			return false;
		end

		local killingPlayerDamageHistories = context:GetPlayerDamageHistory(context.KillingPlayer);

		local killingPlayerDamageHistoryFromDeadPlayer = table.first(killingPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
			end
			);

		if killingPlayerDamageHistoryFromDeadPlayer == nil then
			return false;
		end

		local damageBreakdowns = context:GetDamageHistoryBreakdowns(killingPlayerDamageHistoryFromDeadPlayer);

		--dead player should not have dealt melee damage
		local deadPlayerDealtMeleeDamage = table.any(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == meleeDamageType;
			end
			);

		if deadPlayerDealtMeleeDamage == true then
			return false;
		end

		-- killing player should be constantly taking damage while trying to close for a melee attack
		local killingPlayerConstantlyTookDamage = table.any(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageTime() + brawlerTimeDamageTakenThreshold >= GetGameTime();
			end
			);

		if killingPlayerConstantlyTookDamage == false then
			return false;
		end

		return true;
	end
	);

--
-- Beat down (melee attack from behind)
--

onMeleeFromBehind = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.SilentMelee and context.DamageType == meleeDamageType;
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
-- Ambush - Stronghold Only
--

if(enableAmbushMedal) then
	onAmbush = killTypeSelect:Add(
		function (context)
			return context.DamageReportingModifier == DamageReportingModifier.Assassination 
			and context.KillingPlayer:InAnyStronghold();
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
		return context.DamageType == meleeDamageType;
	end
	);

--
-- Ground Pound
--

onGroundPoundKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == groundPoundDamageType;
	end
	);

--
-- Shoulder Bash
--

onShoulderBashKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == shoulderBashDamageType;
	end
	);

--
-- Hydra
--

onHydraKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == hydraDamageSource;
	end
	);

--
-- Tomahawk
--
	
function IsTomahawk (context)
	local deadPlayerUnit = context.DeadPlayer:GetUnit();
	return context.DamageSource == rocketLauncherDamageSource 
		and context.DamageType == bulletDamageType
		and deadPlayerUnit:IsAirborne();
end

onTomahawkKill = onEnemyPlayerKill:Filter(
	IsTomahawk
	);

--
-- Rocket Mary
--

function IsRocketMaryKill (context)
	return context.DamageSource == rocketLauncherDamageSource
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
end

onRocketMary = onEnemyPlayerKill:Filter(
	IsRocketMaryKill
	);

--
-- Target Practice
--

function IsTargetPractice(context)
	return context.DamageSource == rocketLauncherDamageSource
	and context.DeadObject ~= nil
	and context.KillingObject ~= nil
	and context.DeadPlayer:InAnyStronghold();
end

if(enableTargetPracticeMedal) then
	onTargetPractice = onEnemyPlayerKill:Filter(
		IsTargetPractice
		);

	onRareRocketKill = killTypeSelect:Add(
	function (context)
		return IsRocketMaryKill(context) or IsTomahawk(context) or IsTargetPractice(context);
	end
	);
else 
	onRareRocketKill = killTypeSelect:Add(
	function (context)
		return IsRocketMaryKill(context) or IsTomahawk(context);
	end
	);
end

--
-- Rocket launcher kill
--

onRocketLaucherKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == rocketLauncherDamageSource;
	end
	);

--
-- Shotgun kill
--

onShotgunKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == shotgunDamageSource;
	end
	);
	
--
-- Airborne Snapshot
--

onAirborneSnapshot = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();
		return context.DamageSource == sniperDamageSource
		and context.DamageType == bulletDamageType
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

		return context.DamageSource == sniperDamageSource
		and context.DamageType == bulletDamageType
		and killingPlayerUnit ~= nil
		and not killingPlayerUnit:IsZoomed();
	end
	);

--
-- Sniper Headshot
--

onSniperHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == sniperDamageSource 
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
		and context.DamageSource == sniperDamageSource 
		and context.DamageType == bulletDamageType;
	end
	);

--
-- All Sniper Kills
--

onAllSniperKills = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == sniperDamageSource
		and context.DamageType == bulletDamageType 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil;
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

		-- killing player should be the only damage source
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end

		local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);

		--check that all shots were correct damage type (BR or melee)

		local allShotsCorrectDamageType = table.all(damageBreakdowns,
			function (breakdown)
				return breakdown:GetDamageSource() == battleRifleDamageSource or breakdown:GetDamageType() == meleeDamageType;
			end
			);

		if allShotsCorrectDamageType == false then
			return false;
		end

		--only one melee attack
		local meleeDamage = table.filtervalues(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == meleeDamageType;
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
-- Perfect Kills
--

function PerfectKill (context, damageSource, maximumNumberOfMissedShots, maximumNumberOfLandedShots, maximumNumberOfShots, maximumEngagementDuration)

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
			return (breakdown:GetDamageSource() == damageSource and breakdown:GetDamageType() == bulletDamageType)
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

	if #shotsOnDeadPlayer > maximumNumberOfLandedShots then
		return false;
	end

	return true;

end

onBattleRifleFourShot = killTypeSelect:Add(
	function (context)
		return context.DamageSource == battleRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, battleRifleDamageSource, 2, 12, 12, 4);
	end
	);

onLightRifleThreeShot = killTypeSelect:Add(
	function (context)
		return context.DamageSource == lightRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, lightRifleDamageSource, 0, 3, 3, 3);
	end
	);

onDMRFiveShot = killTypeSelect:Add(
	function (context)
		return context.DamageSource == dmrDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, dmrDamageSource, 0, 5, 5, 5);
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
	return table.any(grenadeDamageSources, 
			function(damageSource)
				return context.DamageType == explosionDamageType
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
		return context.DamageSource == magnumDamageSource;
	end
	);
	
--
-- Headshots in a row
--

consecutiveHeadshotsAccumulator = root:CreatePlayerAccumulator();

-- Count headshots
onConsecutiveHeadshots = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	):PlayerAccumulator(
	consecutiveHeadshotsAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);

-- Reset accumulator on death
onPlayerDeath:ResetPlayerAccumulator(
	consecutiveHeadshotsAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );

-- Was the kill a headshot?
onNonHeadshotKill = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageReportingModifier ~= DamageReportingModifier.Headshot;
	end
	);

-- Reset accumulator on non-headshot kill
onNonHeadshotKill:ResetPlayerAccumulator(
	consecutiveHeadshotsAccumulator,
		function (context)
			return context.KillingPlayer;
		end
		);
		
-- Reset accumulator on Round Start
	 
if (resetConsecutiveHeadshotsOnRoundStart == nil or resetConsecutiveHeadshotsOnRoundStart) then
	onRoundStart:ResetAccumulator(consecutiveHeadshotsAccumulator);
end

-- Trigger on 3 consecutive headshots	
onThreeConsecutiveHeadshots = onConsecutiveHeadshots:Filter(
	function (context)
		return consecutiveHeadshotsAccumulator:GetValue(context.KillingPlayer) % 3 == 0;
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

onExtermination = onKillsInARow:Filter(
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
	);

--
-- Team Extermination
--

onTeamExtermination = onPlayerDeath:Filter(
	function (context)

		if context.Engine:TeamsEnabled() then

				local friendlyPlayers = table.filter(context:GetAllPlayers(), 
					function (player)
						return player:IsFriendly(context.DeadPlayer);
					end
					);
				if table.getn(friendlyPlayers) >= 4 then
					return table.all(friendlyPlayers,
						function (player)
							return PlayerIsDead(player) or player == context.DeadPlayer;
						end
						);
				end

				return false;				
		end
		return false;
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
-- Avenger
--

local avengerSeconds = 2.0;

function FindAvengedPlayer(context) 
	local killingPlayerUnit = context.KillingPlayer:GetUnit();

	if killingPlayerUnit ~= nil and killingPlayerUnit:IsAlive() then
		context.AvengedPlayer = table.first(context:GetAllPlayers(), 
			function (player)
				return player ~= context.KillingPlayer
				and player:IsFriendly(context.KillingPlayer)
				and player:GetLastKillingPlayer() == context.DeadPlayer
				and player:GetSecondsSinceDeath() > 0
				and player:GetSecondsSinceDeath() <= avengerSeconds;
			end
			);
	end
end

onAvenger = onEnemyPlayerKill:Emit(FindAvengedPlayer):Filter(
	function(context)
		return context.AvengedPlayer ~= nil
	end
	);

--
-- Protector (save a teammate by killing his attacker)
--

local damageDealtFromDeadPlayerThreshold = 0.3;

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
		return protectorAccumulator:GetValue(context.KillingPlayer) == 3;
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
-- Longshot - Battle Rifle
--

onBattleRifleLongshot = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == battleRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 26;
	end
	);
	
--
-- Longshot - DMR
--

onDMRLongshot = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == dmrDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 45;
	end
	);
	
--
-- Longshot - Magnum
--

onMagnumLongshot = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == magnumDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 20;
	end
	);
		
--
-- Spray and Pray - Assault Rifle
--

onAssaultRifleSprayPray = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == assaultRifleDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
	end
	);
	
onSMGSprayPray = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == smgDamageSource 
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

onSniperLongshot = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == sniperDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 75;
	end
	);

--
-- Bulltrue
--

onBulltrue = onEnemyPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsLunging() and deadPlayerUnit:GetPrimaryWeapon():GetClassName() == swordWeaponClassName;
	end
	);

--
-- Armageddon
--

onAllRocketKills = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageSource == rocketLauncherDamageSource;
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
-- Reversal (Kill an enemy that shot you first)
--

local reversalEngagementTimeBuffer = 1.0;
local deadPlayerDamageDealtBeforeTakingDamageThreshold = 0.3;

onReversal = onEnemyPlayerKill:Filter(
	function(context)
		
		local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);

		local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
			function(damageHistory)
				return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
			end
			);

		-- killing player should be the only damage source
		if deadPlayerDamageHistoryFromKillingPlayer == nil or deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end

		-- Killing player should not have used a power weapon
		local deadPlayerDamageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer)

		local dealtDamageWithPowerWeapon = table.any(deadPlayerDamageBreakdowns, 
			function(breakdown)

				local breakdownDamageSource = breakdown:GetDamageSource();

				for _ , value in pairs(powerWeaponDamageSources) do
					if (breakdownDamageSource == value) then
						return true;
					end
				end

				return false;
			end
			);

		if dealtDamageWithPowerWeapon == true then
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
-- Deadshot (kill an enemy with the last bullet in a clip)
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
-- Distraction
--

local distractingPlayerDamageTakenThreshold = 0.3;
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

onPlayerRegeneratedShields:ResetPlayerAccumulator(
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
		local deadPlayerUnit = context.DeadPlayer:GetUnit();

		if deadPlayerUnit == nil then
			return false;
		end

		local deadPlayerPrimaryWeapon = deadPlayerUnit:GetPrimaryWeapon();

		if deadPlayerPrimaryWeapon == nil then
			return false;
		end

		for index, weaponName in ipairs(powerWeaponNames) do
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
		return bigGameHunterAccumulator:GetValue(context.KillingPlayer) == 2;
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
