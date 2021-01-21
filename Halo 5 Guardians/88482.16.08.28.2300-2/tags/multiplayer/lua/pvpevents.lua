
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
onEnemyUnitKill = onKill:Filter(
	function (context)
		if IsEnemyPlayerKill(context) then
			return true;
		end
		if (allowAIMedalContribution) then
			if (context.DeadPlayer ~= nil) then
				return false;
			end
			return IsValidAI(context);
		else
			return false;
		end
	end
	);
killTypeSelect = onEnemyUnitKill:Select();
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
onFallingKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == fallingDamageSource
	end
	);
function GunpunchKill(context, maximumNumberOfMissedShots, maximumNumberOfLandedShots, weaponDamageSource)
	local deadPlayerDamageHistories = context:GetPlayerDamageHistory(context.DeadPlayer);
	local deadPlayerDamageHistoryFromKillingPlayer = table.first(deadPlayerDamageHistories,
		function(damageHistory)
			return damageHistory:GetAttackingPlayer() == context.KillingPlayer;
		end
		);
	if deadPlayerDamageHistoryFromKillingPlayer == nil  or deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then 
		return false;
	end
	local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);
	local deadPlayerOnlyTookCorrectDamage = table.all(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == MeleeDamageType or breakdown:GetDamageSource() == weaponDamageSource
		end
		);
	if not deadPlayerOnlyTookCorrectDamage then 
		return false;
	end
	local meleeDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageType() == MeleeDamageType;
		end
		);
	if #meleeDamageBreakdowns ~= 1 then
		return false;
	end
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
		and (GunpunchKill(context, 1, 6, BattleRifleDamageSource) or GunpunchKill(context, 1, 6, H2BattleRifleDamageSource));
	end
	);
onSnipunchKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == MeleeDamageType
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and table.any(SniperDamageSources,
			function(damageSource)
				return GunpunchKill(context, 0, 1, damageSource);
			end
		);
	end
	);
if (enableStalkerMedal) then
	onStalkerKill = killTypeSelect:Add(
		function(context)
			return context.DamageReportingModifier == DamageReportingModifier.Assassination 
			and context.KillingPlayer:IsHuman() 
			and context.DeadPlayer:IsInfected();
		end
		);
end
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
if (enableBallKillTypeMedals) then
	onBallsassination = killTypeSelect:Add(
		function(context)
			return context.DamageReportingModifier == DamageReportingModifier.Assassination
				and context.KillingPlayer:IsBallCarrier();
		end
		);
	onBallKill = killTypeSelect:Add(
		function (context)
			return context.DamageType == BallDamageType
				and context.KillingPlayer:IsBallCarrier();
		end
		);
end
onAirAssassination = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination
		and context.KillingPlayer:IsAirborneAssassinating();
	end
	);
onAssassination = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination;
	end
	);
onBrawlerKill = killTypeSelect:Add(
	function(context)
		if context.DamageType ~= MeleeDamageType then
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
onMeleeFromBehind = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.SilentMelee and context.DamageType == MeleeDamageType;
	end
	);
onSwordKill = killTypeSelect:Add(
	function (context)
		return table.any(SwordDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);
onHammerKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == GravityHammerDamageSource;
	end
	);
onMeleeKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == MeleeDamageType;
	end
	);
onGroundPoundKill = killTypeSelect:Add(
	function (context)
		return context.DamageType == GroundPoundDamageType;
	end
	);
groundPoundKillSelect = onGroundPoundKill:Select();
onPoundTown = groundPoundKillSelect:Add(IsPoundTown);
onGenericGroundPoundKill = groundPoundKillSelect:Add();
onShoulderBashKill = killTypeSelect:Add(
	function(context)
		return context.DamageType == ShoulderBashDamageType;
	end
	);
onHydraKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == HydraDamageSource;
	end
	);
onSplaserKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == SpartanLaserDamageSource;
	end
	);
onNeedlerKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == NeedlerDamageSource;
	end
	);
onSawKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == SawDamageSource;
	end
	);
onRailgunKill = killTypeSelect:Add(
	function(context)
		return context.DamageSource == RailGunDamageSource;
	end
	);
onPlasmaCasterKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == PlasmaCasterDamageSource;
	end
	);
function IsRocketMaryKill (context)
	return 
		table.any(RocketWeaponDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
		)
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and context.DeadObject:GetDistance(context.KillingObject) >= 18;
end
onRocketMary = onEnemyUnitKill:Filter(
	IsRocketMaryKill
	);
onIncinerationKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == IncinerationCannonDamageSource;
	end
	);
onBinaryRifleKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == BinaryRifleDamageSource;
	end
	);
onRocketLaucherKill = killTypeSelect:Add(
	function (context)
		return 
			table.any(RocketWeaponDamageSources,
				function(damageSource)
					return context.DamageSource == damageSource;
				end
			);
	end
	);
onScattershotKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == ScattershotDamageSource;
	end
	);
onShotgunKill = killTypeSelect:Add(
	function (context)
		return context.DamageSource == ShotgunDamageSource;
	end
	);
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
onBeamRifleKill = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();
		return killingPlayerUnit ~= nil 
		and killingPlayerUnit:IsZoomed()
		and context.DamageType == BulletDamageType
		and table.any(BeamRifleDamageSources,
			function(damageSource)
				return context.DamageSource == damageSource;
			end
			);
	end
	);
onSniperKill = killTypeSelect:Add(
	function (context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();
		return killingPlayerUnit ~= nil 
		and killingPlayerUnit:IsZoomed() 
		and context.DamageType == BulletDamageType
		and context.DamageSource == SniperDamageSource;
	end
	);
onAllSniperKills = onEnemyUnitKill:Filter(
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
function IsNoobCombo(context)
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
	local chargedPlasmaPistolDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return breakdown:GetDamageSource() == PlasmaPistolDamageSource 
			and (breakdown:GetDamageType() == ChargedPlasmaDamageType or breakdown:GetDamageType() == ExplosionDamageType);
		end
		);
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
local maximumNumberOfMissedShots = 1;
local maximumNumberOfLandedShots = 3;
onBxrKill = killTypeSelect:Add(
	function(context)
		if not IsEnemyPlayerKill(context) then
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
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end
		local damageBreakdowns = context:GetDamageHistoryBreakdowns(deadPlayerDamageHistoryFromKillingPlayer);
		local allShotsCorrectDamageType = table.all(damageBreakdowns,
			function (breakdown)
				return breakdown:GetDamageSource() == BattleRifleDamageSource 
					or breakdown:GetDamageSource() == H2BattleRifleDamageSource
					or breakdown:GetDamageType() == MeleeDamageType;
			end
			);
		if allShotsCorrectDamageType == false then
			return false;
		end
		local meleeDamage = table.filtervalues(damageBreakdowns,
			function(breakdown)
				return breakdown:GetDamageType() == MeleeDamageType;
			end
			);
		if #meleeDamage ~= 1 then
			return false;
		end
		if meleeDamage[1]:GetDamageTime() > deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() then
			return false;
		end
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
local grenadeDamageTimeWindow = 1;
function IsNadeshot(context)
	if context.DamageReportingModifier ~= DamageReportingModifier.Headshot then
		return false;
	end
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
	local grenadeDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return table.any(GrenadeDamageSources,
				function(damageSource)
					return breakdown:GetDamageSource() == damageSource;
				end
				);
		end
		);
	local headshotWeaponDamageBreakdowns = table.filtervalues(damageBreakdowns,
		function(breakdown)
			return table.any(HeadshotWeaponDamageSources,
				function(damageSource)
					return breakdown:GetDamageSource() == damageSource and breakdown:GetDamageType() == BulletDamageType;
				end
				);
		end
		);
	if #grenadeDamageBreakdowns == 0 or #headshotWeaponDamageBreakdowns == 0 then
		return false;
	end
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
	local selectedWeaponDamageSource = headshotWeaponDamageBreakdowns[1]:GetDamageSource();
	local allGunDamageFromSameWeapon = table.all(headshotWeaponDamageBreakdowns,
		function(weaponDamageBreakdown)
			return weaponDamageBreakdown:GetDamageSource() == selectedWeaponDamageSource;
		end
		);
	if not allGunDamageFromSameWeapon then
		return false;
	end
	local tookGrenadeDamageOutsideOfTimeWindow = table.any(grenadeDamageBreakdowns, 
		function(breakdown)
			return breakdown:GetDamageTime() > deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() + grenadeDamageTimeWindow;
		end
		);
	if tookGrenadeDamageOutsideOfTimeWindow then
		return false;
	end
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
	local firstEngagementTime = deadPlayerDamageHistoryFromKillingPlayer:GetFirstDamageTime() - 0.25;
	local allShotsSinceEngagingPlayer = table.filtervalues(context:GetPlayerShotRecord(context.KillingPlayer),
		function (shotInfo)
			return shotInfo:GetShotTime() >= firstEngagementTime;
		end
		);
	if #allShotsSinceEngagingPlayer > 1 then 
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
function IsQuickdraw(context)
	if context.DamageSource ~= MagnumDamageSource or context.DamageReportingModifier ~= DamageReportingModifier.Headshot then
		return false;
	end
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
	if GetGameTime() - killingPlayersDamageHistory:GetFirstDamageTime() > maximumEngagementDuration then
		return false;
	end
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
	return (context.DamageSource == BattleRifleDamageSource or context.DamageSource == H2BattleRifleDamageSource)
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and (PerfectKill(context, BattleRifleDamageSource, 2, 11, 12, 12, 3.2) or PerfectKill(context, H2BattleRifleDamageSource, 2, 11, 12, 12, 3.2));
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
	local shotCount = 5;
	local shotTime = 3.2;
	if (useBreakoutTuningForMagnumPerfect) then
		shotCount = 3;
		shotTime = 1.92;
	end
	return context.DamageSource == MagnumDamageSource 
		and context.DeadObject ~= nil 
		and context.KillingObject ~= nil 
		and PerfectKill(context, MagnumDamageSource, 0, shotCount, shotCount, shotCount, shotTime);
end
function H1MagnumPerfectKill(context)
	return context.DamageSource == H1MagnumDamageSource
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and PerfectKill(context, H1MagnumDamageSource, 0, 3, 3, 3, 2.5);
end
function FlagnumPerfectKill(context)
	local shotCount = 5;
	local shotTime = 3.2;
	if (useBreakoutTuningForMagnumPerfect) then
		shotCount = 3;
		shotTime = 1.92;
	end
	return context.DamageSource == FlagnumDamageSource
		and context.DeadObject ~= nil
		and context.KillingObject ~= nil
		and PerfectKill(context, FlagnumDamageSource, 0, shotCount, shotCount, shotCount, shotTime);
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
onH1MagnumThreeShot = killTypeSelect:Add(H1MagnumPerfectKill);
onHeadshotKill = killTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);
function IsGrenadeImpactKill(context)
	return table.any(GrenadeDamageSources,
		function(damageSource)
			return context.DamageType == GrenadeImpactDamageType
			and context.DamageSource == damageSource;
		end
		);
end
onGrenadeImpactKill = killTypeSelect:Add(IsGrenadeImpactKill);
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
onHailMary = onEnemyUnitKill:Filter(
	IsHailMary
	);
onStuck = onEnemyUnitKill:Filter(
	IsStuck
	);
onPineappleExpress = onEnemyUnitKill:Filter(
	IsGrenadeKillInVehicle
	);
onGrenadeKill = killTypeSelect:Add(
	IsGrenadeKill
	);
onGenericKill = killTypeSelect:Add(
	IsEnemyPlayerKill
	);
consecutiveSniperHeadshotsAccumulator = root:CreatePlayerAccumulator();
onConsecutiveSniperHeadshots = onEnemyUnitKill:Filter(
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
onPlayerDeath:ResetPlayerAccumulator(
	consecutiveSniperHeadshotsAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
onNonHeadshotKill = onEnemyUnitKill:Filter(
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
onNonHeadshotKill:ResetPlayerAccumulator(
	consecutiveSniperHeadshotsAccumulator,
		function (context)
			return context.KillingPlayer;
		end
		);
if (resetConsecutiveHeadshotsOnRoundStart == nil or resetConsecutiveHeadshotsOnRoundStart) then
	onRoundStart:ResetAccumulator(consecutiveSniperHeadshotsAccumulator);
end
onThreeConsecutiveHeadshots = onConsecutiveSniperHeadshots:Filter(
	function (context)
		return consecutiveSniperHeadshotsAccumulator:GetValue(context.KillingPlayer) % 3 == 0;
	end
	);
killsSinceDeathAccumulator = root:CreatePlayerAccumulator();
onKillsSinceDeath = onEnemyUnitKill:PlayerAccumulator(
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
if (resetKillsSinceDeathOnRoundStart == nil or resetKillsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(killsSinceDeathAccumulator);
end
onOneKillSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 1;
	end
	);
onFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 5;
	end
	);
onTenKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 10;
	end
	);
onFifteenKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 15;
	end
	);
onTwentyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 20;
	end
	);
onTwentyFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 25;
	end
	);
onThirtyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 30;
	end
	);
onThirtyFiveKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 35;
	end
	);
onFourtyKillsSinceDeath = onKillsSinceDeath:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 40;
	end
	);
onKilljoy = onEnemyPlayerKill:Filter(
	function (context)
		return killsSinceDeathAccumulator:GetValue(context.DeadPlayer) >= 5;
	end
	);
function GetMultiKillSeconds()
	if allowAIMedalContribution then
		return 1.0;
	else
		return 5.0;
	end
end
killsInARowAccumulator = root:CreatePlayerAccumulator(GetMultiKillSeconds());
onKillsInARow = onEnemyUnitKill:PlayerAccumulator(
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
onTwoKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 2
	end
	);
onThreeKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 3
	end
	);
onFourKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 4
	end
	);
onFiveKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 5
	end
	);
onSixKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 6
	end
	);
onSevenKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 7
	end
	);
onEightKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 8
	end
	);
onNineKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 9
	end
	);
onTenKillsInARow = onKillsInARow:Filter(
	function (context)
		return killsInARowAccumulator:GetValue(context.KillingPlayer) == 10
	end
	);
deathsSinceKillAccumulator = root:CreatePlayerAccumulator();
onDeathsSinceKill = onPlayerDeath:PlayerAccumulator(
	deathsSinceKillAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
onEnemyUnitKill:ResetPlayerAccumulator(
	deathsSinceKillAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);
if (resetDeathsSinceKillOnRoundStart == nil or resetDeathsSinceKillOnRoundStart) then
	onRoundStart:ResetAccumulator(deathsSinceKillAccumulator);
end
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
		return exterminationAccumulator:GetValue(context.KillingPlayer) == 1;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	exterminationAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
killsInRoundAccumulator = root:CreateAccumulator();
onKillsInRound = onEnemyUnitKill:Accumulator(killsInRoundAccumulator);
onFirstKill = onKillsInRound:Filter(
	function (context)
		return killsInRoundAccumulator:GetValue() == 1;
	end
	);
if (resetKillsInRoundOnRoundStart == nil or resetKillsInRoundOnRoundStart) then
	onRoundStart:ResetAccumulator(killsInRoundAccumulator);
end
protectorSelect = onProtectorKill:Select();
if enableFlagCarrierProtectedMedal then
	onFlagCarrierProtected = protectorSelect:Add(
		function(context)
			return context.ProtectedPlayer:IsFlagCarrier();
		end
		);
end
if enableBallKillTypeMedals then
	onBallCarrierProtected = protectorSelect:Add(
		function(context)
			return context.ProtectedPlayer:IsBallCarrier();
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
if (resetKillsSinceDeathOnRoundStart == nil or resetKillsSinceDeathOnRoundStart) then
	onRoundStart:ResetAccumulator(protectorAccumulator);
end
revengeTypeSelect = onOneKillSinceDeath:Filter(
	function (context)
		return context.KillingPlayer:GetLastKillingPlayer() == context.DeadPlayer;
	end
	):Select();
onRetribution = revengeTypeSelect:Add(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Assassination;
	end
	);
onRevenge = revengeTypeSelect:Add(
	);
onKillFromTheGrave = onEnemyUnitKill:Filter(
	function (context)
		return PlayerIsDead(context.KillingPlayer) 
			and context.KillingPlayer:GetSecondsSinceDeath() > 0.25;
	end
	);
onShowStopper = onEnemyPlayerKill:Filter(
	function (context)
		return context.DeadPlayer:IsAssassinating();
	end
	);
onCliffhanger = onEnemyPlayerKill:Filter(
	function (context)
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsClambering();
	end
	);
local LongshotDistanceForPrecisionWeapons = 30;
onLongshot = onEnemyUnitKill:Filter(
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
local SprayAndPrayDistanceForAutoWeapons = 16;
onSprayAndPray = onEnemyUnitKill:Filter(
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
onSniperLongshot = onEnemyUnitKill:Filter(
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
onBulltrue = onEnemyPlayerKill:Filter(
	function (context)
		if disableMedalsForGrifball then
			return false;
		end
		if disableBulltrue then
			return false;
		end
		local deadPlayerUnit = context.DeadPlayer:GetUnit();
		return deadPlayerUnit:IsLunging() and deadPlayerUnit:GetPrimaryWeapon():GetClassName() == SwordObjectClassName;
	end
	);
onStarkiller = onEnemyPlayerKill:Filter(
	function(context)
		local deadPlayerBiped = context.DeadPlayer:GetBiped();
		return deadPlayerBiped ~= nil 
		and deadPlayerBiped:IsGroundPoundLaunched();
	end
	);
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
if (disableTeamTakedownMedal == nil or disableTeamTakedownMedal == false) then
	onTeamTakedown = onEnemyPlayerKill:Filter(IsTeamTakedown);
end
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
		if deadPlayerDamageHistoryFromKillingPlayer:GetTotalNormalizedDamage() < 0.95 then
			return false;
		end
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
local distractingPlayerDamageTakenThreshold = 0.2;
local killingPlayerDamageTakenThreshold = 0.3;
local deadPlayerDamageTakenFromDistractingPlayerThreshold = 0.05;
function DistractingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(distractingPlayer)
			if distractingPlayer == context.KillingPlayer or distractingPlayer:IsFriendly(context.DeadPlayer) or PlayerIsDead(distractingPlayer) then
				return false;
			end
			local distractingPlayerDamageHistories = context:GetPlayerDamageHistory(distractingPlayer);
			local distractingPlayerDamageFromDeadPlayer = table.first(distractingPlayerDamageHistories,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);
			if distractingPlayerDamageFromDeadPlayer == nil or distractingPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() < distractingPlayerDamageTakenThreshold then
				return false;
			end
			local killingPlayerDamageHistories = context:GetPlayerDamageHistory(context.KillingPlayer);
			local killingPlayerDamageFromDeadPlayer = table.first(killingPlayerDamageHistories,
				function(damageHistory)
					return damageHistory:GetAttackingPlayer() == context.DeadPlayer;
				end
				);
			if killingPlayerDamageFromDeadPlayer ~= nil and killingPlayerDamageFromDeadPlayer:GetTotalNormalizedDamage() > killingPlayerDamageTakenThreshold then 
				return false;
			end
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
tripleDoublePlayers = { };
tripleDoubleHeadshotAccumulator = root:CreatePlayerAccumulator();
tripleDoubleAssistAccumulator = root:CreatePlayerAccumulator();
tripleDoubleKillAccumulator = root:CreatePlayerAccumulator();
tripleDoubleHeadshot = onEnemyUnitKill:Filter(
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
tripleDoubleAssistCounter = onEnemyUnitKill:PlayerAccumulator(
	tripleDoubleAssistAccumulator,
	function(context)
		return context.AssistingPlayers;
	end
	);
tripleDoubleKillCounter = onEnemyUnitKill:PlayerAccumulator(
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
onBusted = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadPlayerUnit ~= nil
		and context.DeadPlayerUnit:IsBoardingVehicle();
	end
	);
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
bigGameHunterAccumulator = root:CreatePlayerAccumulator();
onBigGameKill = onEnemyPlayerKill:Filter(
	function(context)
		if disableBigGameHunter or disableMedalsForGrifball then
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