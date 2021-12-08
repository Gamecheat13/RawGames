-- object ability_heal_totem_burst

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure ability_heal_totem_burst
	meta : table
	instance : luserdata
	ownerPlayer:player
	ownerUnit:object
	healthMaxVitality:number
	shieldMaxVitality:number
	myMpTeam:mp_team
	myCampaignTeam:team
end

global g_healTotemBurstConst =
{
	healRadius = 2;
	activatedDelay = 0.4;
	baseHealing = 0.1;
	damagePercentPerPulse = 0.11;
	postHealSleepTime = 0.75;
}

function ability_heal_totem_burst:init() : void 
	CreateObjectThread(self, self.CustomInitThread, self);
end

function ability_heal_totem_burst:CustomInitThread():void
	-- sleep until the projectile has left the unit's hand
	SleepUntilSeconds ([| object_get_parent(self) == nil ] , 0);
	self.ownerPlayer = Object_GetDamageOwnerPlayer(self);
	self.ownerUnit = object_get_parent(Object_GetSourceEquipment(self)); -- using this method in case the spawning unit is an AI character, can't guarantee what the ultime parent of the AI will be, but I can guarantee the parent of the equipment's parent
	self.healthMaxVitality = 60; -- Need a function that gets max body vitality
	self.shieldMaxVitality = 140; -- Need a function that gets max shield vitality
	self.myMpTeam = Object_SetMultiplayerTeam(self, Player_GetMultiplayerTeam(self.ownerUnit));
	self.myCampaignTeam = Object_SetCampaignTeam(self, Object_GetCampaignTeam(self.ownerUnit));
	SendGameEvent(self, "Audio_HealTotem_Deployed") -- play deployed SFX

	-- sleep while in the air
	SleepUntilSeconds ([| object_get_at_rest(self) ] , 0);

	HealTotemBurstActivate( self);
end

function HealTotemBurstActivate(self):void
	local activateTimerStart:time_point = Game_TimeGet();
	local loc:location = location(self,"fx_root");
	local myTeam:mp_team = Player_GetMultiplayerTeam(self.ownerUnit)
	local startPoint:location = location(self, "fx_root");
	local alliesEverHealed:table = {};
	local previousFrameList = {};
	local objectsInRange = {};
		
	object_set_function_variable(self, "TotemHealing", 1) -- play active SFX

	if object_index_valid(self) then
		local objectsAroundMe:object_list = Object_GetObjectsInSphere(loc, g_healTotemBurstConst.healRadius);
		for _, objectInSphere in hpairs(objectsAroundMe) do
			if (Object_IsUnit(objectInSphere) and object_get_health(objectInSphere) > 0) then		
				
				---local playerInSphere:player = unit_get_player(objectInSphere);
				local objLoc:location = location(objectInSphere, "fx_root");
				local objHead:location = location(objectInSphere, "head");
				local objFeet:location = location(objectInSphere, "pedestal");

				if (CheckHealTotemBurstLOSToPlayer(startPoint, objLoc) or CheckHealTotemBurstLOSToPlayer(startPoint, objHead) or CheckHealTotemBurstLOSToPlayer(startPoint, objFeet)) then
					if not table.contains(objectsInRange, objectInSphere) then
						table.insert(objectsInRange, objectInSphere)
					end
					if not table.contains(alliesEverHealed, objectInSphere) then
						table.insert(alliesEverHealed, objectInSphere)
					end
				end
			elseif Engine_GetObjectType(objectInSphere) == OBJECT_TYPE._object_type_vehicle then
				local objLoc:location = location(objectInSphere, "fx_root");
				if CheckHealTotemBurstLOSToPlayer(startPoint, objLoc) then
					local vehiclePassengers:table = Vehicle_GetPassengers(objectInSphere);
					if next(vehiclePassengers) ~= nil then
						for _, passenger in hpairs(vehiclePassengers) do
							if Object_IsPlayer(passenger) then
								--local playerInSphere:player = unit_get_player(passenger);
								if not table.contains(objectsInRange, objectInSphere) then 

									table.insert(objectsInRange, objectInSphere)
								end
								if not table.contains(alliesEverHealed, objectInSphere) then
									table.insert(alliesEverHealed, objectInSphere)
								end
							end
						end
					end
				end
			end
		end
	end
	-- Perform the heal
	HealTotemBurstHeal(self, objectsInRange);

	object_set_function_variable(self, "TotemHealing", 0) -- play active SFX

	sleep_s(g_healTotemBurstConst.postHealSleepTime)
	SendGameEvent(self, "Audio_HealTotem_Destroyed") -- play destroyed SFX
	Object_Detach(self)
	object_destroy(self);
end

function HealTotemBurstExpired(spawned:time_point, totemDuration:number) : boolean
	local timeNow:time_point = Game_TimeGet();
	return timeNow:ElapsedTime(spawned) >= totemDuration;
end

function CheckHealTotemBurstLOSToPlayer (startpoint, endpoint): boolean
	local rayCastResult:table = Physics_RayCast(startpoint, endpoint, "environment_only");

	-- if we hit something between players, their view is obstructed (partially at least) and we don't have LOS
	if (rayCastResult ~= nil) then
		return false;
	else
		return true;
	end
end

function HealTotemBurstHeal(self, unitsInRange:table):void
	local allyGroup:table = {};
	local nearbyUnitCount:number =  table.countKeys(unitsInRange);
	-- NOTE: it looks like currently based on how HealTotemBurstActivate() works, objectInSphere can be a vehicle (operated by a friendly). In this case, Player_GetMultiplayerTeam() will return nil,
	-- which in turn will cause Engine_GetMPTeamDisposition() to return DISPOSITION.Neutral, which would incorrectly add the vehicle to the enemy group. We should either properly allow the healing of vehicles,
	-- or better handle vehicle passengers in HealTotemBurstActivate().
	for _, objectInSphere in hpairs(unitsInRange) do
		if HealGrenadeEvaluateObjIsAlly(self, objectInSphere) then
			table.insert(allyGroup, objectInSphere)
		end
	end

	-- Heal Allies: more healing the more enemies you harmed
	for _, ally in hpairs(allyGroup) do
		if Object_IsPlayer(ally) then
			CreateThread(HealTotemApplyHeal, self, ally, self.healthMaxVitality, self.shieldMaxVitality, nearbyUnitCount)
		else
			CreateThread(HealTotemApplyHeal, self, ally, object_get_maximum_vitality(ally), 0, nearbyUnitCount)
		end
	end
end

function HealGrenadeEvaluateObjIsAlly(self, objectToCheck): boolean
	if Object_IsOrWasPlayer(self.ownerUnit) then
		return GetDispositionPlayerObject(self.ownerPlayer, objectToCheck) == DISPOSITION.Allied;
	else 

		return GetCampaignDispositionObjectObject(self.ownerUnit, objectToCheck) == DISPOSITION.Allied;
	end
end

function HealTotemApplyHeal(self, objectToHeal:object, maxHealth:number, maxShields:number, unitCount:number):void
	-- Play FX
	RunClientScript("PlayHealTotemBurstEffects", objectToHeal);

	-- Stun the shield so we can properly modify shield values
	Object_SetShieldStun(objectToHeal, 1);

	local healthVitalityHealed:number = 0;
	local shieldVitalityHealed:number = 0;
	local normalizedFullHealth:number = 1;
	local normalizedFullShields:number = 1;
	local normalizedTargetHealth:number = object_get_health(objectToHeal);
	local normalizedTargetShields:number = object_get_shield(objectToHeal);
	local recoverVitalityVal:number = (g_healTotemBurstConst.baseHealing * unitCount) * object_get_maximum_vitality(objectToHeal);
	-- Only heal players who have less than full health
	if (normalizedTargetHealth < normalizedFullHealth) then
		local oldHealthVitality:number = normalizedTargetHealth * maxHealth;

		-- Heal the target's health to their max health, or the specified heal amount, whichever is lower
		local newHealthVitality:number = math.min(oldHealthVitality + recoverVitalityVal, maxHealth);
		local newNormalizedHealth:number = newHealthVitality / maxHealth;
		object_set_health(objectToHeal, newNormalizedHealth);
		-- Record the amount of health we healed, and subtract that amount from our potential healing amount that we can potentially apply to shields next
		healthVitalityHealed = newHealthVitality - oldHealthVitality;
		recoverVitalityVal = recoverVitalityVal - healthVitalityHealed;
	end

	-- If the target isn't at full shields, and we still have some healing amount leftover, apply that amount towards the player's shields
	if (normalizedTargetShields < normalizedFullShields) and (recoverVitalityVal > 0) and (normalizedTargetShields < maxShields) then
		local oldShieldVitality:number = normalizedTargetShields * maxShields;
		local missingShieldVitality:number = maxShields - (maxShields * normalizedTargetShields);

		-- Heal the target's shields to their max shields, or the specified remaining heal amount, whichever is lower
		local newShieldVitality = math.min(oldShieldVitality + recoverVitalityVal, maxShields);
		local newNormalizedShields:number = newShieldVitality / maxShields;
		object_set_shield(objectToHeal, newNormalizedShields);
		
		-- Record the amount of shields we healed, and subtract that amount from our potential healing amount (which is now just un-used surplus potential.. may be useful at some point)
		shieldVitalityHealed = newShieldVitality - oldShieldVitality;
		recoverVitalityVal = recoverVitalityVal - shieldVitalityHealed;
	end	

	-- Fire eventing for the heal
	if Object_IsOrWasPlayer(self.ownerUnit) then
		local healedPlayer:player = Unit_GetPlayer(objectToHeal);
		
		MPLuaCall("__OnPlayerHealed", self.ownerPlayer, healedPlayer, normalizedTargetHealth, healthVitalityHealed, normalizedTargetShields, shieldVitalityHealed);
		FireTelemetryEvent("PlayerHealingDone", {Healer = Player_GetXuid(self.ownerPlayer), EquipmentObject = Telemetry_GetDescriptors(Object_GetSourceEquipment(self)), 
			HealthRecovered = healthVitalityHealed, ShieldsRecovered = shieldVitalityHealed, Target = Player_GetXuid(healedPlayer) });
	end
	-- Sleep for a frame and then reset the shield stun
	Sleep(1);
	Object_SetShieldStun(objectToHeal, 0);
end

--## CLIENT

function remoteClient.PlayHealTotemBurstEffects(objectHealed:object)
	local thisEffect = effect_new_on_object_marker(  TAG('fx\library_olympus\sandbox\abilities\master\healing_master.effect'), objectHealed, "fx_root");
end
