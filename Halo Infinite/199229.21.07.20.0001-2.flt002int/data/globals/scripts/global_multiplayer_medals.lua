--Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('multiplayer\lua\weaponconstants.lua');

hstructure OffTheRackStruct
	weapon:         object;
	timeout:        time_point;
end

hstructure WeaponAirborneStruct
	weapon:         object;
	airborne:       boolean;
	caught:         boolean;
end

hstructure MountUpStruct
	driverPlayer:   player;
	vehicle:        object;
	timeout:        time_point;
end

hstructure DelayedMedalStruct
	medalEvent:     MedalAwardedEventStruct;
	timeout:		time_point;
end

hstructure ShieldWallBlockStruct
	ownerPlayer:    player;
	timeout:        time_point;
end

hstructure RideshareStruct
	driverUnit:        object;
	carrierUnit:       object;
	mount:             object;
	pickupLocation:    location;
	deliveryLocations: table;
end

global equipmentNameByTag = nil;

--|===============================|--
--|==== Register event stubs =====|--
--|===============================|--

function startup.CreateMedalEventsOnStartup():void
	-- aliasing "self" to be MPMedalEvents here for familiar syntax
	local self:table = MPMedalEvents;

	equipmentNameByTag = {};
	for name, tag in hpairs(EquipmentAbilityData) do
		if tag ~= nil then
			equipmentNameByTag[tag] = name;
		end
	end

	-- create a lookup table for the damage sources that can detonate grenades for quick lookup during object damage events
	for _, v in hpairs(RemoteDetonationDamageSources) do
		self.remoteDetonationDamageSourceMap[v] = true;
	end

	MedalManager_SetInterlinkedDamageSources(ShockDamageSources);
	
	MedalManager_GrappleJackTimeout = 2.5;
	MedalManager_DeadlyCatchTimeout = 3.0;
	MedalManager_HoldThisTimeout = 2.0;
	MedalManager_DeathRaceThreshold = 2;
	MedalManager_360MedalTimeout = 2.5;		-- how far back we look for a 360 after a kill is made
	MedalManager_360MedalThreshold = 0.8	-- the threshold is how much of a full 360* circle they need to do. so 0.9 is 90% of that circle
	
	self.CONST.harpoonDistanceSquared = self.CONST.harpoonMinimumDistance * self.CONST.harpoonMinimumDistance;
	self.CONST.grappleMinimumDistanceSquared = self.CONST.grappleMinimumDistance * self.CONST.grappleMinimumDistance;
	self.CONST.hailMaryDistanceSquared = self.CONST.hailMaryMinimumDistance * self.CONST.hailMaryMinimumDistance;
	self.CONST.ballistaDistanceSquared = self.CONST.ballistaMinimumDistance * self.CONST.ballistaMinimumDistance;
	self.CONST.fireAndForgetDistanceSquared = self.CONST.fireAndForgetMinimumDistance * self.CONST.fireAndForgetMinimumDistance;

	-- wait for green build after CL 4843585 
	-- MedalManager_LongDistanceMedalMinimum = math.min(math.min(self.CONST.fireAndForgetMinimumDistance, self.CONST.hailMaryMinimumDistance), self.CONST.ballistaMinimumDistance);

	RegisterGlobalEventOnce(g_eventTypes.roundStartGameplayEvent, self.HandleGameplayStartEvent, self);
	RegisterGlobalEventOnce(g_eventTypes.gameplayCompleteEvent, self.HandleMatchEnd, self);

	RegisterGlobalEvent(g_eventTypes.triggerMedalEvent, self.TriggerMedalEvent, self);
	RegisterGlobalEvent(g_eventTypes.medalAwardedEvent, self.HandleMedalAwarded, self);
	
	RegisterGlobalEvent(g_eventTypes.equipmentAbilityActivateEvent, self.HandlePlayerUsedEquipment);
	RegisterGlobalEvent(g_eventTypes.spartanAbilityStateChangedCallback, self.HandleSpartanAbilityStateChanged);
	RegisterGlobalEvent(g_eventTypes.grappleHookImpactEvent, self.HandleGrappleHookImpactEvent);

	RegisterGlobalEvent(g_eventTypes.playerShieldsLowEvent, self.HandlePlayerShieldsLow);
	RegisterGlobalEvent(g_eventTypes.equipmentPickupEvent, self.HandleEquipmentPickup);
	RegisterGlobalEvent(g_eventTypes.grenadePickupEvent, self.HandleGrenadePickup);

	-- WeaponPickup, WeaponPickupAtPad, and WeaponPickupForAmmoRefill are mutually exclusive.
	RegisterGlobalEvent(g_eventTypes.weaponPickupEvent, self.HandleWeaponPickup, self);
	RegisterGlobalEvent(g_eventTypes.weaponPickupAtPadEvent, self.HandleWeaponPickupAtPad);

	RegisterGlobalEvent(g_eventTypes.weaponOutOfAmmoEvent, self.HandleWeaponOutOfAmmo);
	RegisterGlobalEvent(g_eventTypes.weaponLowAmmoEvent, self.HandleWeaponLowAmmo);

	RegisterGlobalEvent(g_eventTypes.deathEvent, self.HandleDeathEvent, self);
	RegisterGlobalEvent(g_eventTypes.mountEnteredEvent, self.HandleMountEntered, self);
	RegisterGlobalEvent(g_eventTypes.mountExitedEvent, self.HandleMountExited, self);
end

--|===============================|--
--|== Runtime state + functions ==|--
--|===============================|--

global MPMedalEvents = table.makePermanent
{
	offTheRackCandidates = {},		 -- player -> OffTheRackStruct
	mountUpVehicles = {},            -- mount -> MountUpStruct			
	thrownFusionCoils = {},			 -- coil -> throwing player
	physicsBlastedWeapons = {},		 -- weapon -> WeaponAirborneStruct
	personalAIMedalResponseMap = {},	 -- player -> PersonalAI DelayedMedalStruct
	commanderMedalResponseMap = {},		-- play -> Commander DelayedMedalStruct
	boomBlockDropWalls = {},         -- map of shield wall object to ShieldWallBlockStruct
	rideshareTracking = {},          -- carrier -> RideshareStruct
	rideshareMountRefCount = {},     -- mount -> reference count
	remoteDetonationGrenades = {},   -- grenade object -> sniper player unit
	remoteDetonationDamageSourceMap = {},	-- lookup table for valid remote detonation damage sources
	immortalMedalEligiblePlayers = {},		-- player -> bool

	CONFIG =
	{
		immortalMedalEnabled = false,	-- medal is disabled by default, only enabled for Elimination modes
	},

	CONST = 
	{
		commanderMedalTimeout = 1.5,
		personalAIMedalTimeout = 4,

		offTheRackTimeout = 2.75,
		mountUpTimeout = 10.0,
		mountUpExtension = 5.0,
		boomBlockTimeout = 1,

		rideshareDeliveryDistance = 10.0,	-- maximum distance from the delivery location to be counted as a successful drop off
		rideshareDistanceTraveled = 40.0,	-- minumum distance between where the carrier enters the vehicle and exits the vehicle

		harpoonMinimumDistance = 3.0,		-- minimum distance between the two players for the harpoon medal to fire
		harpoonDistanceSquared = nil,		-- initialized in CreateMedalEventsOnStartup

		grappleMinimumDistance = 6.5,		-- minimum distance for grapple to trigger Personal AI line

		hailMaryMinimumDistance = 18.0,		-- minimum distance the killer has to be from the victim for the medal to fire
		hailMaryDistanceSquared = nil,		-- initialized in CreateMedalEventsOnStartup
		ballistaMinimumDistance = 25.0,		
		ballistaDistanceSquared = nil,		
		fireAndForgetMinimumDistance = 25.0,
		fireAndForgetDistanceSquared = nil,	

		nuclearFootballMedalName	= "__OnNuclearFootballMedal",
		mountUpMedalName			= "__OnMountUpMedal",
		offTheRackMedalName			= "__OnOffTheRackMedal",
		combatEvolvedMedalName		= "__OnCombatEvolvedMedal",
		boomBlockMedalName			= "__OnBoomBlockMedal",
		rideshareMedalName			= "__OnRideshareMedal",
		remoteDetonationMedalName	= "__OnRemoteDetonationMedal",
		immortalMedalName			= "__OnImmortalMedal",
		kongMedalName				= "__OnKongMedal",
		harpoonMedalName			= "__OnHarpoonMedal",
		hailMaryMedalName			= "__OnHailMaryMedal",
		ballistaMedalName			= "__OnBallistaMedal",
		fireAndForgetMedalName		= "__OnFireAndForgetMedal",
	},
};

function MPMedalEvents.HandleGameplayStartEvent(eventArgs:RoundStartGameplayEventStruct, self:table):void
	if eventArgs.roundIndex == 0 then
		local getAllWeaponPlacementsFunc = _G["GetAllWeaponPlacements"];
		if getAllWeaponPlacementsFunc ~= nil then
			local allWeaponSpawners:table = getAllWeaponPlacementsFunc();
			for i, placement in hpairs(allWeaponSpawners) do
				placement:AddOnWeaponPickedUp(self, self.HandleWeaponPickedUpFromPad);
				placement:AddOnWeaponBlastDetach(self, self.HandleWeaponBlastedFromPad);
			end
		end

		-- only players present at the start of the game are eligible for Immortal Medal
		for _, player in hpairs(PLAYERS.active) do
			if (Player_IsFullyConnectedToGame(player)) then
				self.immortalMedalEligiblePlayers[player] = true;
			end
		end
	end

	-- cleanup previous round's grenade tracking
	self.remoteDetonationGrenades = {};
end

function MPMedalEvents.HandleMatchEnd(self:table):void
	-- this needs to be checking a CONFIG or something instead
	if (self.CONFIG.immortalMedalEnabled) then
		for player, value in hpairs(self.immortalMedalEligiblePlayers) do
			if (value) then
				MPLuaCall(self.CONST.immortalMedalName, player);
			end
		end
	end
end

-- this is called from the native side Medal Event Manager to avoid calling into response lua directly from C++ as events happen
-- pass them through to response lua here
function MPMedalEvents.TriggerMedalEvent(eventArgs:TriggerMedalEventStruct, self:table):void
	MPLuaCall(eventArgs.mpLuaEventName, eventArgs.targetPlayer, eventArgs.damageSource, eventArgs.damageType, eventArgs.deadPlayer);
end

-- this is called from the engine when the medal has been awarded to the player
function MPMedalEvents.HandleMedalAwarded(eventArgs:MedalAwardedEventStruct, self:table):void
    MPLuaCall("__OnMedalAwarded", eventArgs.player, eventArgs.medalId, eventArgs.difficulty);    
    MPMedalEvents.AddOrExtendMedalAwardedResponse(eventArgs, self.personalAIMedalResponseMap, self.CONST.personalAIMedalTimeout, "__OnPersonalAIMedalResponse");
    MPMedalEvents.AddOrExtendMedalAwardedResponse(eventArgs, self.commanderMedalResponseMap, self.CONST.commanderMedalTimeout, "__OnCommanderMedalResponse");
end

function MPMedalEvents.AddOrExtendMedalAwardedResponse(eventArgs:MedalAwardedEventStruct, responseMap:table, timeout:number, mpLuaCallFuncName:string):void
    local newTimeout:time_point = Game_TimeGet():Offset(timeout);
    if responseMap[eventArgs.player] == nil then
        local medalResponse:DelayedMedalStruct = hmake DelayedMedalStruct
        {
            medalEvent = eventArgs,
            timeout = newTimeout,
        };
        responseMap[eventArgs.player] = medalResponse;
        CreateThread(MPMedalEvents.DelayedMedalThreadFunction, medalResponse, responseMap, mpLuaCallFuncName);
    else
        local responseData:DelayedMedalStruct = responseMap[eventArgs.player];
        -- 0 is Normal Medal
        local normalMedalValue:number = 0;
        -- extend the timer to see if we get a better medal
        if eventArgs.difficulty > normalMedalValue then
            responseData.timeout = newTimeout;
        end
        --Store off any medal that is higher than is already stored.
        if eventArgs.difficulty >= responseData.medalEvent.difficulty then
            responseData.medalEvent = eventArgs;
        end
    end
end

function MPMedalEvents.DelayedMedalThreadFunction(response:DelayedMedalStruct, responseMap:table, mpLuaCallFuncName:string):void
    local currentTime:time_point = nil;
    repeat
        SleepSeconds(0.1);
        currentTime = Game_TimeGet();
    until (currentTime > response.timeout);
    responseMap[response.medalEvent.player] = nil;
    MPLuaCall(mpLuaCallFuncName, response.medalEvent.player, response.medalEvent.medalId, response.medalEvent.difficulty, response.medalEvent.category);
end

function MPMedalEvents.HandlePlayerUsedEquipment(eventArgs:EquipmentAbilityActivateEventStruct)
	MPMedalEvents:PlayerUsedEquipmentTag(Unit_GetPlayer(eventArgs.owner), Object_GetDefinition(eventArgs.equipment));
end

function MPMedalEvents.HandleSpartanAbilityStateChanged(eventArgs:SpartanAbilityStateChangedEventStruct)
	if eventArgs.activated then
		MPMedalEvents:PlayerUsedEquipmentTag(Unit_GetPlayer(eventArgs.unit), eventArgs.abilityTag);
	end
end

function MPMedalEvents.HandleGrappleHookImpactEvent(eventArgs:GrappleHookImpactEventStruct)
	local ownerPlayer:player = Unit_GetPlayer(eventArgs.playerUnit);
	MPMedalEvents:PlayerUsedEquipmentTag(ownerPlayer, nil, 'grapple');

	if Object_IsOrWasPlayer(eventArgs.attachedObject) then
		if Engine_GetPlayerDisposition(ownerPlayer, Unit_GetCurrentOrLastPlayer(eventArgs.attachedObject)) == DISPOSITION.Enemy then
			local grappleDistanceSq:number = Object_GetDistanceSquaredToObject(eventArgs.playerUnit, eventArgs.attachedObject);
			if grappleDistanceSq > MPMedalEvents.CONST.harpoonDistanceSquared then
				MPLuaCall(MPMedalEvents.CONST.harpoonMedalName, ownerPlayer);
			end
		end
	elseif eventArgs.distanceSquared >= MPMedalEvents.CONST.grappleMinimumDistanceSquared then 
		MPLuaCall("__PersonalAIGrapple", ownerPlayer);
	end
end

function MPMedalEvents:PlayerUsedEquipmentTag(player:player, tag:tag, equipmentNameOverride:string)
	if player ~= nil then
		local equipmentName:string = '';
		
		if equipmentNameOverride ~= nil then
			equipmentName = equipmentNameOverride;
		elseif tag ~= nil then 
			equipmentName = equipmentNameByTag[tag];
		end

		PlayerUsedEquipmentCallback(player, tag, equipmentName);
		MPLuaCall("__OnPlayerEquipmentUse", player, equipmentName);
	end
end

function MPMedalEvents.HandleEquipmentPickup(eventArgs:EquipmentPickupEventStruct)
	if not Player_IsInCombat(eventArgs.player) then
		MPLuaCall("__OnPlayerEquipmentPickup", eventArgs.player, eventArgs.equipment);
	end
end

function MPMedalEvents.HandleGrenadePickup(eventArgs:GrenadePickupEventStruct)
	if not Player_IsInCombat(eventArgs.player) then
		MPLuaCall("__OnPlayerGrenadePickup", eventArgs.player, eventArgs.grenadeType);
	end
end

function MPMedalEvents.HandleWeaponPickup(eventArgs:WeaponPickupEventStruct, self:table):void
	local coilThrowingPlayer:player = self.thrownFusionCoils[eventArgs.weapon];
	if coilThrowingPlayer ~= nil then
		if Engine_GetPlayerDisposition(eventArgs.player, coilThrowingPlayer) == DISPOSITION.Enemy then
			MPLuaCall(self.CONST.nuclearFootballMedalName, eventArgs.player);
			self.thrownFusionCoils[eventArgs.weapon] = nil;
		end
	end
	
	local blastedInfo:WeaponAirborneStruct = self.physicsBlastedWeapons[eventArgs.weapon];
	if blastedInfo ~= nil then
		if blastedInfo.airborne then 
			blastedInfo.caught = true;
			MPLuaCall(self.CONST.combatEvolvedMedalName, eventArgs.player);
		end
		self.physicsBlastedWeapons[eventArgs.weapon] = nil;
	end

	local isInCombat = Player_IsInCombat(eventArgs.player)
	MPLuaCall("__OnPlayerWeaponPickup", eventArgs.player, eventArgs.weapon, isInCombat);
end

function MPMedalEvents.HandleWeaponPickupAtPad(eventArgs:WeaponPickupAtPadEventStruct)
	local isInCombat = Player_IsInCombat(eventArgs.player)
	MPLuaCall("__OnPlayerWeaponPickup", eventArgs.player, eventArgs.weapon, isInCombat);
end

function MPMedalEvents.HandleWeaponOutOfAmmo(eventArgs:WeaponOutOfAmmoEventStruct)
	local player:player = Unit_GetPlayer(eventArgs.unit);
	if (player ~= nil) then
		MPLuaCall("__OnPlayerWeaponOutOfAmmo", player, eventArgs.weapon);
	end
end

function MPMedalEvents.HandleWeaponLowAmmo(eventArgs:WeaponLowAmmoEventStruct)
	local player:player = Unit_GetPlayer(eventArgs.unit);
	if (player ~= nil) then
		MPLuaCall("__OnPlayerWeaponLowAmmo", player, eventArgs.weapon);
	end
end

function MPMedalEvents.HandlePlayerShieldsLow(eventArgs:PlayerShieldsLowEventStruct)
	-- Commenting out for now as we want to test without it to see if we want to remove completely. 
	--MPLuaCall("__OnPlayerShieldsLow", eventArgs.player);
end

function MPMedalEvents.HandleDeathEvent(eventArgs:DeathEventStruct, self:table):void
	-- Dying at any point in the match disqualifies a player from obtaining the Immortal medal
	if (eventArgs.deadPlayer ~= nil) then
		self.immortalMedalEligiblePlayers[eventArgs.deadPlayer] = false;
	end

	if not DeathEventIsEnemyPlayerKill(eventArgs) then
		return;
	end
	
	self:CheckForOffTheRackMedal(eventArgs);

	-- Kong medal
	local fusionCoilThrower:player = self.thrownFusionCoils[eventArgs.damageSourceObject];
	if fusionCoilThrower ~= nil and eventArgs.killingPlayer == fusionCoilThrower then
		MPLuaCall(self.CONST.kongMedalName, fusionCoilThrower);
	end

	-- Remote Detonation medal
	local detonationPlayer:player = self:GetRemoteDetonationPlayer(eventArgs.damageSourceObject, eventArgs.killingWeaponObject);
	if detonationPlayer ~= nil and Engine_GetPlayerDisposition(eventArgs.deadPlayer, detonationPlayer) == DISPOSITION.Enemy then
		MPLuaCall(self.CONST.remoteDetonationMedalName, detonationPlayer);
	end

end

function MPMedalEvents:GetRemoteDetonationPlayer(damageSourceObject:object, killingWeaponObject:object):player
	local remoteDetonationAttackerUnit:object = nil;

	if damageSourceObject ~= nil then
		remoteDetonationAttackerUnit = self.remoteDetonationGrenades[damageSourceObject];
	end

	if remoteDetonationAttackerUnit == nil and killingWeaponObject ~= nil then 
		remoteDetonationAttackerUnit = self.remoteDetonationGrenades[killingWeaponObject];
	end

	if remoteDetonationAttackerUnit ~= nil then
		return Unit_GetCurrentOrLastPlayer(remoteDetonationAttackerUnit);
	end
	
	return nil;
end


function MPMedalEvents:CheckForOffTheRackMedal(eventArgs:DeathEventStruct):void
	if eventArgs.killingPlayer == nil then
		return;
	end

	local trackingInfo:OffTheRackStruct = self.offTheRackCandidates[eventArgs.killingPlayer];
	if trackingInfo == nil then
		return;
	end

	if Game_TimeGet() > trackingInfo.timeout then
		self.offTheRackCandidates[eventArgs.killingPlayer] = nil;

	elseif trackingInfo.weapon == eventArgs.killingWeaponObject and self:LimitMeleeKillsToMeleeWeapons(eventArgs) then
		MPLuaCall(self.CONST.offTheRackMedalName, eventArgs.killingPlayer);
		self.offTheRackCandidates[eventArgs.killingPlayer] = nil;
	end
end

function MPMedalEvents:LimitMeleeKillsToMeleeWeapons(eventArgs:DeathEventStruct):boolean
	-- only melee weapons can use a melee kill to trigger this event
	if (eventArgs.damageType == MeleeDamageType) then
		return table.contains(MeleeWeaponRoleDamageSources, eventArgs.damageSource);
	end
	return true;
end

function MPMedalEvents.HandleWeaponPickedUpFromPad(self:table, eventArgs:WeaponPickupEventStruct):void
	local weaponInfo:OffTheRackStruct = hmake OffTheRackStruct
	{
		weapon = eventArgs.weapon,
		timeout = Game_TimeGet():Offset(self.CONST.offTheRackTimeout),
	};
	self.offTheRackCandidates[eventArgs.player] = weaponInfo;
end

function MPMedalEvents.HandleWeaponBlastedFromPad(self:table, weapon:object):void
	local weaponInfo:WeaponAirborneStruct = hmake WeaponAirborneStruct
	{
		weapon = weapon, -- needed for the TrackAirborneWeapon thread
		airborne = true,
		caught = false,
	};
	self.physicsBlastedWeapons[weapon] = weaponInfo;

	CreateThread(self.TrackAirborneWeapon, self, weaponInfo);
end

function MPMedalEvents.TrackAirborneWeapon(self:table, weaponInfo:WeaponAirborneStruct):void
	local lastPosition:vector = Object_GetPosition(weaponInfo.weapon).vector;
	repeat
		SleepSeconds(0.1);
		local currentPosition:vector = Object_GetPosition(weaponInfo.weapon).vector;
		weaponInfo.airborne = not Vector_NearEqual(lastPosition, currentPosition);
		lastPosition = currentPosition;
	until (not weaponInfo.airborne or weaponInfo.caught)
end

function MPMedalEvents.TrackVehicleHonked(driver:object, vehicle:object):void
	local self:table = MPMedalEvents;

	local passengerCount = Vehicle_GetPassengerCount(vehicle, "", VEHICLE_SEAT.AnyNonDriver);
	if passengerCount > 0 then
		return;
	end

	local mountUpData:MountUpStruct = self.mountUpVehicles[vehicle];
	if mountUpData ~= nil then
		-- already exists. refresh timer.
		mountUpData.timeout = Game_TimeGet():Offset(self.CONST.mountUpTimeout);
	else
		local driverPlayer:player = Unit_GetPlayer(driver);
		if driverPlayer ~= nil then 
			mountUpData = hmake MountUpStruct
			{
				driverPlayer = driverPlayer,
				vehicle = vehicle,
				timeout = Game_TimeGet():Offset(self.CONST.mountUpTimeout),
			};
			self.mountUpVehicles[vehicle] = mountUpData;
		end
	end
end

function MPMedalEvents.HandleMountEntered(eventArgs:MountEnteredEventStruct, self:table):void
	local currentTime:time_point = Game_TimeGet();

	local mountUpData:MountUpStruct = self.mountUpVehicles[eventArgs.mount];
	if mountUpData ~= nil then
		if currentTime > mountUpData.timeout or 
			Engine_GetPlayerDisposition(Unit_GetPlayer(eventArgs.instigator), mountUpData.driverPlayer) == DISPOSITION.Enemy then
			self.mountUpVehicles[eventArgs.mount] = nil;
		else
			if Vehicle_GetEmptyPlayerSeatCount(mountUpData.vehicle, false) > 0 then
				-- extend the timer for each new passenger
				mountUpData.timeout = mountUpData.timeout:Offset(self.CONST.mountUpExtension);
			else
				self.mountUpVehicles[eventArgs.mount] = nil;
				if (Vehicle_GetTotalPlayerSeatCount(mountUpData.vehicle, false) >= 3) then
					MPLuaCall(self.CONST.mountUpMedalName, mountUpData.driverPlayer);
				end
			end
		end
	end
end
function MPMedalEvents.HandleMountExited(eventArgs:MountExitedEventStruct, self:table):void
	local mountUpInfo:MountUpStruct = self.mountUpVehicles[eventArgs.mount];
	-- if driver left stop tracking
	if mountUpInfo ~= nil and mountUpInfo.driverPlayer == Unit_GetPlayer(eventArgs.instigator) then
		self.mountUpVehicles[eventArgs.mount] = nil;
	end
end

function MPMedalEvents.TrackFusionCoil(fusionCoilObject):void
	RegisterEvent(g_eventTypes.weaponThrowEvent, MPMedalEvents.FusionCoilThrow, fusionCoilObject)
	RegisterEvent(g_eventTypes.objectDeletedEvent, MPMedalEvents.FusionCoilDeleted, fusionCoilObject);
end

function MPMedalEvents.FusionCoilThrow(eventArgs:WeaponThrownEventStruct):void
	MPMedalEvents.thrownFusionCoils[eventArgs.thrownWeapon] = eventArgs.player;
end

function MPMedalEvents.FusionCoilDeleted(eventArgs:ObjectDeletedStruct):void
	UnregisterEvent(g_eventTypes.weaponThrowEvent, MPMedalEvents.FusionCoilThrow, eventArgs.deletedObject);
	UnregisterEvent(g_eventTypes.objectDeletedEvent, MPMedalEvents.FusionCoilDeleted, eventArgs.deletedObject);

	MPMedalEvents.thrownFusionCoils[eventArgs.deletedObject] = nil;
end

--
-- Boom Block Medal tracking
--
function MPMedalEvents.TrackDropWallShield(shieldWallObject):void
	RegisterEvent(g_eventTypes.objectDamagedEvent, MPMedalEvents.DropWallShieldDamaged, shieldWallObject);
	RegisterEvent(g_eventTypes.objectDeletedEvent, MPMedalEvents.DropWallShieldDeleted, shieldWallObject);

	local ownerPlayer:player = Object_GetDamageOwnerPlayer( Object_GetParent( shieldWallObject ) );
	
	local shieldBlockData:ShieldWallBlockStruct = hmake ShieldWallBlockStruct
	{
		ownerPlayer = ownerPlayer,
		timeout = Game_TimeGet():Offset(MPMedalEvents.CONST.boomBlockTimeout),
	};
	MPMedalEvents.boomBlockDropWalls[shieldWallObject] = shieldBlockData;
end

function MPMedalEvents.CheckDamageForBoomBlockMedal(eventArgs:ObjectDamagedEventStruct):boolean
	if table.contains(LauncherWeaponRoleDamageSources, eventArgs.damageSource) then
		-- ignore melee damage for this medal from all guns
		return eventArgs.damageType ~= MeleeDamageType;
	end

	-- Gun Goose
	if eventArgs.damageSource == MongooseDamageSource and eventArgs.damageType == BulletDamageType then
		return true;
	end

	if eventArgs.damageSource == RocketHogDamageSource then
		return true;
	end

	-- Wasp (rockets only)
	if eventArgs.damageSource == WaspDamageSource and eventArgs.damageType == ExplosionDamageType then
		return true;
	end

	if eventArgs.damageType == GrenadeImpactDamageType then
		return true;
	end

	return false;
end

function MPMedalEvents.DropWallShieldDamaged(eventArgs:ObjectDamagedEventStruct):void
	if not MPMedalEvents.CheckDamageForBoomBlockMedal(eventArgs) then
		return;
	end

	local self:table = MPMedalEvents;
	local shieldBlockData:ShieldWallBlockStruct = self.boomBlockDropWalls[eventArgs.defender];

	if shieldBlockData ~= nil then
		if Game_TimeGet() > shieldBlockData.timeout then 
			self.DisposeWallShieldTracking(eventArgs.defender);
		else
			local isValidAttacker:boolean = false;
			if Object_IsOrWasPlayer(eventArgs.attacker) then
				local attackerPlayer:player = Unit_GetCurrentOrLastPlayer(eventArgs.attacker);
				isValidAttacker = Engine_GetPlayerDisposition(attackerPlayer, shieldBlockData.ownerPlayer) == DISPOSITION.Enemy;
			end
			if isValidAttacker then
				MPLuaCall(self.CONST.boomBlockMedalName, shieldBlockData.ownerPlayer);
				self.DisposeWallShieldTracking(eventArgs.defender);
			end
		end
	end
end

function MPMedalEvents.DropWallShieldDeleted(eventArgs:ObjectDeletedStruct):void
	MPMedalEvents.DisposeWallShieldTracking(eventArgs.deletedObject);
end

function MPMedalEvents.DisposeWallShieldTracking(wallShieldObject:object):void
	UnregisterEvent(g_eventTypes.objectDamagedEvent, MPMedalEvents.DropWallShieldDamaged, wallShieldObject);
	UnregisterEvent(g_eventTypes.objectDeletedEvent, MPMedalEvents.DropWallShieldDeleted, wallShieldObject);

	MPMedalEvents.boomBlockDropWalls[wallShieldObject] = nil;
end

--
-- Rideshare 
-- 
-- MPMedalEvents.HandleObjectivePickedUp - Call this from mode script to begin tracking the objective carrier for this medal 
--                                       - use MPMedalEvents.HandleObjectivePickedUp to stop tracking this objective carrier
-- carrierUnit:object      - The playerUnit with the objective
-- deliveryLocations:table - One or more :location variable types for this objective to be delivered
function MPMedalEvents.HandleObjectivePickedUp(carrierUnit:object, deliveryLocations:table):void
	RegisterEvent(g_eventTypes.seatEnteredEvent, MPMedalEvents.HandleObjectiveCarrierEnteredSeat, carrierUnit);
	
	local rideStruct:RideshareStruct = hmake RideshareStruct
	{
		driverUnit = nil,
		carrierUnit = carrierUnit,
		mount = nil,
		pickupLocation = nil,
		deliveryLocations = deliveryLocations,
	};
	MPMedalEvents.rideshareTracking[carrierUnit] = rideStruct;
end

-- MPMedalEvents.HandleObjectiveDropped - Call this from mode script to stop tracking the objective carrier
function MPMedalEvents.HandleObjectiveDropped(carrierPlayer:player):void
	local carrierUnit:object = Player_GetUnit(carrierPlayer) or Player_GetDeadUnit(carrierPlayer);
	MPMedalEvents.StopTrackingRideshare(carrierUnit);
end

function MPMedalEvents.HandleObjectiveCarrierEnteredSeat(eventArgs:SeatEnteredEventStruct):void
	local carrierUnit = eventArgs.instigator;
	MPMedalEvents.rideshareTracking[carrierUnit].pickupLocation = Object_GetPosition(carrierUnit);
	MPMedalEvents.rideshareTracking[carrierUnit].mount = eventArgs.mount;

	MPMedalEvents.rideshareTracking[carrierUnit].driverUnit = Vehicle_GetDriver(eventArgs.mount);

	-- register for any changes in this mount so we can track driver changes
	if MPMedalEvents.rideshareMountRefCount[eventArgs.mount] == nil then
		RegisterEvent(g_eventTypes.seatEnteredEvent, MPMedalEvents.HandleRideshareSeatEntered, eventArgs.mount);
		RegisterEvent(g_eventTypes.seatExitedEvent, MPMedalEvents.HandleRideshareSeatExited, eventArgs.mount);
		-- this is the first time we're tracking this mount 
		MPMedalEvents.rideshareMountRefCount[eventArgs.mount] = 1;
	else
		-- increment reference count so we don't double-register or call UnregisterEvent when escorting multiple carriers
		MPMedalEvents.rideshareMountRefCount[eventArgs.mount] = MPMedalEvents.rideshareMountRefCount[eventArgs.mount] + 1;
	end
end

function MPMedalEvents.HandleRideshareSeatEntered(eventArgs:SeatEnteredEventStruct):void
	-- we only care about changes in the driver seat
	if eventArgs.instigator ~= Vehicle_GetDriver(eventArgs.mount) then
		return;
	end

	for _, rideStruct in hpairs(MPMedalEvents.rideshareTracking) do
		if rideStruct.mount == eventArgs.mount then
			-- reset pickup location for distance tracking if we changed drivers
			if rideStruct.driverUnit ~= eventArgs.instigator then
				rideStruct.driverUnit = eventArgs.instigator;
				rideStruct.pickupLocation = Object_GetPosition(eventArgs.instigator);
			end
		end
	end
end

function MPMedalEvents.IsRideshareComplete(rideInfo:RideshareStruct, dropoffLocation:location):boolean
	local drivenDistance:number = DistanceBetweenLocations(dropoffLocation, rideInfo.pickupLocation);
	
	-- did we escort over a far enough distance
	if drivenDistance >= MPMedalEvents.CONST.rideshareDistanceTraveled then
		-- are we close enough to any of our delivery locations
		for _, deliveryLocation in hpairs(rideInfo.deliveryLocations) do
			local deliveryDelta:number = DistanceBetweenLocations(dropoffLocation, deliveryLocation); 
			if deliveryDelta <= MPMedalEvents.CONST.rideshareDeliveryDistance then
				return true;
			end
		end
	else
		print("Rideshare distance driven was: "..tostring(drivenDistance).." - Needed "..tostring(MPMedalEvents.CONST.rideshareDistanceTraveled));
	end
	return false;
end

function MPMedalEvents.HandleRideshareSeatExited(eventArgs:SeatExitedEventStruct):void
	local dropoffLocation:location = Object_GetPosition(eventArgs.instigator);

	-- don't cleanup if we lost the driver because we may get a new one
	-- but let the driver bail after getting the carrier close enough 
	-- without waiting on the carrier to leave the vehicle

	-- Carrier left
	if MPMedalEvents.rideshareTracking[eventArgs.instigator] ~= nil then	
		local rideStruct:RideshareStruct = MPMedalEvents.rideshareTracking[eventArgs.instigator];
		if MPMedalEvents.IsRideshareComplete(rideStruct, dropoffLocation) then
			MPMedalEvents.AwardRideshareMedalToDriver(rideStruct.driverUnit, rideStruct.carrierUnit);
		end
		-- carrier left so clean up regardless of success
		MPMedalEvents.StopTrackingRideshare(eventArgs.instigator);
	else
		-- Check if the driver left
		for _, rideStruct in hpairs(MPMedalEvents.rideshareTracking) do
			if rideStruct.mount == eventArgs.mount and eventArgs.instigator == rideStruct.driverUnit then 
				if MPMedalEvents.IsRideshareComplete(rideStruct, dropoffLocation) then
					MPMedalEvents.AwardRideshareMedalToDriver(rideStruct.driverUnit, rideStruct.carrierUnit);
					MPMedalEvents.StopTrackingRideshare(rideStruct.carrierUnit);
				end
			end
		end
	end
end

function MPMedalEvents.AwardRideshareMedalToDriver(driverUnit:object, carrierUnit:object):void
	local driverPlayer:player = Unit_GetCurrentOrLastPlayer(driverUnit);
	local carrierPlayer:player = Unit_GetCurrentOrLastPlayer(carrierUnit);
		
	if (driverPlayer ~= nil 
		and carrierPlayer ~= nil 
		and Engine_GetPlayerDisposition(driverPlayer, carrierPlayer) ~= DISPOSITION.Enemy) then
			MPLuaCall(MPMedalEvents.CONST.rideshareMedalName, driverPlayer);
	end
end

function MPMedalEvents.StopTrackingRideshare(carrierUnit:object):void
	if MPMedalEvents.rideshareTracking[carrierUnit] ~= nil then
		UnregisterEvent(g_eventTypes.seatEnteredEvent, MPMedalEvents.HandleObjectiveCarrierEnteredSeat, carrierUnit);

		local mount:object = MPMedalEvents.rideshareTracking[carrierUnit].mount;
		if mount ~= nil then
			-- remove reference
			MPMedalEvents.rideshareMountRefCount[mount] = MPMedalEvents.rideshareMountRefCount[mount] - 1;
			-- unregister if no one else is being tracked in this same mount
			if MPMedalEvents.rideshareMountRefCount[mount] == 0 then
				UnregisterEvent(g_eventTypes.seatEnteredEvent, MPMedalEvents.HandleRideshareSeatEntered, mount);
				UnregisterEvent(g_eventTypes.seatExitedEvent, MPMedalEvents.HandleRideshareSeatExited, mount);
				MPMedalEvents.rideshareMountRefCount[mount] = nil;
			end
		end

		MPMedalEvents.rideshareTracking[carrierUnit] = nil;
	end
end

--
-- Remote Detonation
--
function MPMedalEvents.TrackGrenadeForRemoteDetonation(grenadeObject):void
	RegisterEvent(g_eventTypes.objectDamagedEvent, MPMedalEvents.GrenadeDamaged, grenadeObject);
end

function MPMedalEvents.GrenadeDamaged(eventArgs:ObjectDamagedEventStruct):void
	if MPMedalEvents.remoteDetonationGrenades[eventArgs.defender] ~= nil then
		-- already tracking
		return;
	end

	local validWeaponAttack:boolean = MPMedalEvents.remoteDetonationDamageSourceMap[eventArgs.damageSource] and 
		eventArgs.damageType ~= MeleeDamageType;

	if (validWeaponAttack or 
	   (eventArgs.damageSourceObject ~= nil and MPMedalEvents.remoteDetonationGrenades[eventArgs.damageSourceObject] ~= nil) or 
	   (eventArgs.damageSourceObjectWeapon ~= nil and MPMedalEvents.remoteDetonationGrenades[eventArgs.damageSourceObjectWeapon] ~= nil)) then

		MPMedalEvents.remoteDetonationGrenades[eventArgs.defender] = eventArgs.attacker;
	end
end	

-- Callback from C++
function LongDistanceMedalEvent(killingPlayer:player, damageSource:string_id, damageType:string_id, damageSourceObject:object, killingWeaponObject:object, distanceSquared:number):void
	if damageSource == SkewerDamageSource and distanceSquared > MPMedalEvents.CONST.ballistaDistanceSquared then
		MPLuaCall(MPMedalEvents.CONST.ballistaMedalName, killingPlayer);
	
	elseif damageSource == M41SPNKrDamageSource and distanceSquared > MPMedalEvents.CONST.fireAndForgetDistanceSquared then
		MPLuaCall(MPMedalEvents.CONST.fireAndForgetMedalName, killingPlayer);

	elseif damageSourceObject ~= nil and distanceSquared > MPMedalEvents.CONST.hailMaryDistanceSquared and table.contains(GrenadeDamageSources, damageSource) then
		local isGrenadeTracked:boolean = MPMedalEvents:GetRemoteDetonationPlayer(damageSourceObject, killingWeaponObject) ~= nil;
		if not isGrenadeTracked then
			MPLuaCall(MPMedalEvents.CONST.hailMaryMedalName, killingPlayer);
		end
	end
end
