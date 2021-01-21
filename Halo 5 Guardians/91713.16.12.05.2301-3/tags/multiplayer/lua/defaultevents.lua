
root = RootDefinition:new();
DefinitionRuntime:RegisterRoot(root);
onUpdate = root:AddCallback(
	__OnUpdate
	);
onRoundStart = root:AddCallback(
	__OnRoundStart
	);
onRoundEnd = root:AddCallback(
	__OnRoundEnd
	);	
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
function ActivatedPlayer(context)
	return context.ActivatedPlayer
end
onPlayerActivated = root:AddCallback(
	__OnPlayerActivated,
	function (context, activatedPlayer)
		context.TargetPlayer = activatedPlayer;
	end
	);
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
function AssistingPlayersFriendlyToKillingPlayer(context)
	return table.filter(context.AssistingPlayers,
		function(player)
			return player:IsFriendly(context.KillingPlayer);
		end
		);
end
function IsPlayerKill(context)
	return (context.KillingPlayer ~= nil) and (context.DeadPlayer ~= nil) and (context.KillingPlayer ~= context.DeadPlayer) and context.DeadPlayer:GetUnit() ~= nil;
end
function IsEnemyPlayerKill(context)
	return IsPlayerKill(context) and context.KillingPlayer:IsHostile(context.DeadPlayer);
end
onPlayerSuicide = onKill:Filter(
	function (context)
		return (context.KillingPlayer) ~= nil and (context.DeadPlayer ~= nil) and (context.KillingPlayer == context.DeadPlayer) and context.DeadPlayer:GetUnit() ~= nil;
	end
	);
onEnemyPlayerKill = onKill:Filter(
	function (context)
		return IsEnemyPlayerKill(context);
	end
	);
function IsValidAI(context)
	if (context.DeadObject == nil or context.DeadObject.GetCampaignMetagameType == nil or context.DeadObject.IsAI == nil) then
		return false;
	end
	metagameObjectType = context.DeadObject:GetCampaignMetagameType();
	return (context.DeadObject:IsAI() == true and (
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
onEnemyAIKill = onKill:Filter(
	function (context)
		if (context.DeadPlayer ~= nil) then
			return false;
		end
		return IsValidAI(context);
	end
	);
onFriendlyPlayerKill = onKill:Filter(
	function (context)
		return IsPlayerKill(context) and context.KillingPlayer:IsFriendly(context.DeadPlayer);
	end
	);
onPlayerDeath = onKill:Filter(
	function (context)
		return context.DeadPlayer ~= nil;
	end	
	);
local AllVehicleNamesAndTypes = 
{
	{ "banshee", 	BansheeType },
	{ "ghost", 		GhostType },
	{ "mantis", 	MantisType },
	{ "mongoose",	MongooseType },
	{ "wasp",		WaspType },
	{ "vtol", 		PhaetonType },
	{ "scorpion", 	ScorpionType },
	{ "warthog", 	WarthogType },
	{ "wraith", 	WraithType },
}
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
	globals[vehicleName .. "DestroyedAssistResponse"] = source:Target(AssistingPlayersFriendlyToKillingPlayer):Response(
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
function FindWheelman(context)
	if context.DeadObject == nil or context.AssistingPlayers == nil then
		return nil;
	end
	if context.KillingPlayerUnit == nil or context.KillingPlayerUnit:IsDrivingVehicle() then
		return nil;
	end
	local killingPlayerVehicle = context.KillingPlayerUnit:GetVehicle();
	if killingPlayerVehicle == nil then
		return nil;
	end
	return table.filter(context.AssistingPlayers,
		function(player)
			local playerUnit = player:GetUnit();
			return playerUnit ~= nil 
			and playerUnit:GetVehicle() == killingPlayerVehicle
			and playerUnit:IsDrivingVehicle()
			and playerUnit:IsHostile(context.DeadObject);
		end
		);
end
function IsWheelman(context)
	local wheelmanPlayers = FindWheelman(context);
	if wheelmanPlayers == nil then
		return false;
	end
	context.WheelmanPlayers = wheelmanPlayers;
	return #wheelmanPlayers > 0;
end
function WheelmanAssistPlayers(context)
	return context.WheelmanPlayers;
end
function NonWheelmanAssistPlayers(context)
	return table.filter(context.AssistingPlayers,
		function(player)
			return not table.contains(context.WheelmanPlayers, player);
		end
		);
end
assistSelect = onPlayerAssist:Select();
if (disableTeamTakedownMedal == nil) then
	onTeamTakedownAssist = assistSelect:Add(IsTeamTakedown);
end
onPoundTownAssist = assistSelect:Add(IsPoundTown);
onEmpAssist = assistSelect:Add(IsEmpAssist);
onWheelmanAssist = assistSelect:Add(IsWheelman);
if (enableKillMedals) then
	onGenericAssist = assistSelect:Add();
end
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
if (resetAssistsSinceDeathOnRoundStart == nil or resetAssistsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(assistsSinceDeathAccumulator);
end 
onEnterCombat = root:AddCallback(
	__OnPlayerEnterCombat,
	function (context, player)
		context.TargetPlayer = player;
	end
	);
onExitCombat = root:AddCallback(
	__OnPlayerExitCombat,
	function (context, player)
		context.TargetPlayer = player;
	end
	);
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
onPlayerPickedUpWeapon = root:AddCallback(
	__OnPlayerPickedUpWeapon,
	function (context, player, weapon)
		context.TargetPlayer = player;
		context.PickedUpWeapon = weapon;
	end
	);
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
onTenShieldsRechargedSinceDeath = onShieldsRechargedSinceDeath:Filter(
	function(context)
		return shieldsRechargedSinceDeathAccumulator:GetValue(context.TargetPlayer) % 10 == 0;
	end
	);
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
local damageDealtFromDeadPlayerThreshold = 0.25;
function FindProtectedPlayer(context)
	local deadPlayerUnit = context.DeadPlayer:GetUnit();
	if deadPlayerUnit == nil then
		return false;
	end
	local protectedPlayers = table.filtervalues(context:GetAllPlayers(),
		function(player)
			if player == context.KillingPlayer or context.KillingPlayer:IsHostile(player) then
				return false;
			end
			local playerUnit = player:GetUnit();
			if playerUnit == nil then
				return false;
			end
			if playerUnit:IsDead() then
				return false;
			end
			local hostileToDeadPlayerDamageHistory = context:GetPlayerDamageHistory(player);
			local hostileToDeadPlayerDamageFromDeadPlayer = table.first(hostileToDeadPlayerDamageHistory,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);
			if hostileToDeadPlayerDamageFromDeadPlayer == nil then
				return false;
			end
			if hostileToDeadPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() < damageDealtFromDeadPlayerThreshold then
				return false;
			end
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
__OnServerShutdown = Delegate:new();
onServerShutdown = root:AddCallback(
	__OnServerShutdown
	);
genericServerShutdownWarningResponse = onServerShutdown:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_warning',
	});
__OnForgeSoundScriptTriggered = Delegate:new();
onForgeSoundScriptTriggered = root:AddCallback(
	__OnForgeSoundScriptTriggered,
	function (context, targetPlayer, soundReference)
		context.TargetPlayer = targetPlayer;
		context.SoundReference = soundReference;
	end
	);
onForgeSoundScriptTriggeredResponse = onForgeSoundScriptTriggered:Target(TargetPlayer):Response(
	{
		SoundGlobalId = function (context)
			return context.SoundReference;
		end,
	});
