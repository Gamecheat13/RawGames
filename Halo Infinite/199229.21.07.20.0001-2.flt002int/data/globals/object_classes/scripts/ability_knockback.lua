-- object ability_knockback

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure ability_knockback
	meta:table
	instance:luserdata
	ownerPlayer:player
	ownerUnit:object
	playerMPTeam:mp_team
	playerCampaignTeam:team
	blastedObjects:table
end

global g_knockbackConst = table.makePermanent
{
	cosSearchAngle = 6.5,
	cosPlayerAngle = 75,
	searchRadius = 4,
	originXOffset = 6,
	blastStrengthMod = 6,
	unnetworkedGameModifier = 0.65,
	projectileBlastModifier = 2,
	nonPlayerUnitBlastModifier = 2,
	airborneDriverBlastModifier = 2.5,
	vehicleStunDuration = 1.5,
	zAxisBoost = 0.3,
	ownerBlastStrengthMod = 4.6,
	variableDamageToDeal = 70;
	knockbackWindow = 0.25,
	knockbackMonitorWindow = 4,
	landedMonitorTime = 0.07,
	velocityDeltaThreshold = 0.5,
	aiVelocDeltaThreshold = 0.2,
	bigDamageDist = 0.8,
	medDamageDist = 3.25,
	----------------------------------------
	-- flattened until "Hold to" comes in --
	----------------------------------------
	bigDamage = 50,
	medDamage = 50,

	-- When the ability attempts to "redirect" projectiles, it has to destroy the existing one (owned by the enemy player)
	-- and create a new one that will belong to the knockback user. thus awarding kills from those projectiles to him/her
	-- This is a list of projectiles the ability should NOT destroy and re-create, but instead just knock away. Destroying 
	-- these typically breaks the game as they have scripts assocaited with them that may break the game if created again.
	projectilesToIgnoreByTagDefinition = 
	{
		[TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook.projectile')] = true,
		[TAG('objects\armor\attachments\attachment_abilities\ability_medic_dart\medic_dart_projectile.projectile')] = true,
		[TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\ability_location_sensor_sticky.projectile')] = true,
		[TAG('objects\armor\attachments\attachment_abilities\ability_explosive_charge\explosive_charge.projectile')] = true,
		[TAG('objects\armor\attachments\attachment_abilities\ability_heal_toss\heal_fountain.projectile')] = true,
		[TAG(nil)] = true,
		[TAG(nil)] = true,
		[TAG('objects\armor\attachments\proto_abilities\proto_equipment_stasis_grenade_mp\equipment_stasis_field_mp.projectile')] = true,
	},
	airborneVehicleCheck = 
	{
		[TAG('objects\vehicles\human\wasp\wasp.vehicle')] = true,
		[TAG('objects\vehicles\covenant\banshee\banshee.vehicle')] = true,
		[TAG('objects\vehicles\covenant\ghost\ghost.vehicle')] = true,
	};
}

function ability_knockback:init() : void 
	self.ownerPlayer = Object_GetDamageOwnerPlayer(self);
	Object_AttachObjectToMarker(self.ownerPlayer, "ics_camera", self, "");
	self.ownerUnit = Player_GetUnit(self.ownerPlayer);
	self.playerMPTeam  = Player_GetMultiplayerTeam(self.ownerPlayer);
	self.playerCampaignTeam  = Player_GetCampaignTeam(self.ownerPlayer);
	self.blastedObjects = {} 
	Object_SetMultiplayerTeam(self, self.playerMPTeam);
	Object_SetCampaignTeam(self, self.playerCampaignTeam);
	CreateObjectThread(self, self.CustomInitThread, self);
end

function ability_knockback:CustomInitThread():void
	Sleep(1)
	RunClientScript("KnockbackFiredSoundFX", self)
	CreateThread(KnockbackTheOwner, self)
	FindArcBlastTargetAtLookPosition(self);
end

function FindArcBlastTargetAtLookPosition (self):void
	local activateTimerStart:time_point = Game_TimeGet();
	
	-- Asserts if ownerUnit dies while looping
	while not KnockbackExpired(activateTimerStart, g_knockbackConst.knockbackWindow) and object_get_health(self.ownerUnit) > 0 do
		KnockbackGetObjectsToPush(self); 
		SleepSeconds(0)
	end
	object_destroy(self);
end

function KnockbackTheOwner(self)
	local forwardVecNormalized = Unit_GetAimingVector(self.ownerUnit);

	-- Fudge the value so the player doesn't need to be looking directly down to get full upward push. 
	-- Help them maintain forward velocity while kicking them upward.
	-- Also, it's impossible for the player to look straight down, anyway.  
	if forwardVecNormalized.z < -0.7 then
		forwardVecNormalized = vector(0,0,-1);
	end 
	forwardVecNormalized = forwardVecNormalized * -1
	local ownerArcBlastVector:vector = forwardVecNormalized * g_knockbackConst.ownerBlastStrengthMod;
		if GameIsNetworked() then -- I've found that when checking for networked, the impact on the unit is inconsistent between server and client
			ApplyBlastImpulse(self.ownerUnit, ownerArcBlastVector);
		else
			ownerArcBlastVector = forwardVecNormalized * g_knockbackConst.ownerBlastStrengthMod;
		end
		Object_ApplyCenterOfMassAcceleration(self.ownerUnit, ownerArcBlastVector);
end

function KnockbackGetObjectsToPush(self) : table
	local cosSearchAngle:number = math.cos(math.rad(g_knockbackConst.cosSearchAngle)); --Start looking for objects that fall within the angle of the origin point
	local cosPlayerAngle:number = math.cos(math.rad(g_knockbackConst.cosPlayerAngle)); --Filter out all objects not within cosPlayerAngle of the player (roughly anything in front of the player)
	local userCameraPt:location = location(self.ownerUnit, "ics_camera")
	local forwardVec:vector = Unit_GetAimingVector(self.ownerUnit);
	-- changed the location to a matrix so I can manipulate the origin
	local startPtMatrix:matrix = userCameraPt.matrix
	startPtMatrix.pos =  startPtMatrix.pos - (forwardVec * g_knockbackConst.originXOffset);
	local objectsToBlast:table = {};
	local newObjectsAroundPlayer:object_list = Object_GetObjectsInSphere(userCameraPt, g_knockbackConst.searchRadius);
	for _, objectInSphere in hpairs(newObjectsAroundPlayer) do
		if GetMpDispositionObjectObject(objectInSphere, self.ownerUnit) ~= DISPOSITION.Allied and objectInSphere ~= self and not table.contains(self.blastedObjects, objectInSphere) then
			-- only doing this because lua has poor raycast support. Ideally the native version will push the object if any part of it falls within range.
			local objPoints:table = {location(objectInSphere, "fx_root"), location(objectInSphere, "head"), location(objectInSphere, "pedestal"), location(objectInSphere, "target_canopy"), location(objectInSphere, "fx_headlights")}
			for _, point in hpairs(objPoints) do
				local directionVector:vector = Vector_Normalize(point.vector - startPtMatrix.pos);
				local directionVectorFromPlayer:vector = Vector_Normalize(point.vector - userCameraPt.vector);
				-- Verify the object falls within the cone of the origin point and is in front of the player
				local objDot = forwardVec ^ directionVector;
				local objDotPlayer = forwardVec ^ directionVectorFromPlayer;
				if object_index_valid(objectInSphere) then -- Was hitting an assert where the projectile would get deleted below while the LOS check was still attempting to evaluate its location
					if objDot > cosSearchAngle and objDotPlayer > cosPlayerAngle and not table.contains(self.blastedObjects, objectInSphere) then
						-- For some reason I can't see vehicles' markers, but if they're in front of you, odds are good you can see them (prototype hacking)
						if Engine_GetObjectType(objectInSphere) == OBJECT_TYPE._object_type_vehicle then
							table.insert(objectsToBlast, objectInSphere);
							table.insert(self.blastedObjects, objectInSphere);
							CreateThread(KnockbackPushEnemies, self, objectInSphere)
						elseif CheckArcBlastLOSToPlayer(userCameraPt, point) then
							table.insert(objectsToBlast, objectInSphere);
							table.insert(self.blastedObjects, objectInSphere);

							CreateThread(KnockbackPushEnemies, self, objectInSphere)
						end
					end
				end
			end
		end
	end
	return objectsToBlast;
end

function KnockbackPushEnemies (self, enemyToBlast:object)
	local ownerLoc:location = location(self.ownerUnit, "ics_camera");
	local myMat:matrix = GetLookPosition(self.ownerUnit, 50)
	local endLocation:location = location(myMat)
	local objLoc:location = location(enemyToBlast, "fx_root");
	local result:table = Physics_RayCast(ownerLoc, endLocation, "zero_extent")

	-- The idea here is to fudge the projectiles toward where the player is looking, as long as that point is beyond the range of the knockback. 
	-- Otherwise, if it's closer than the range of the knockback, just push the projectiles toward some point 50wu away.
	if result then
		local resultDistVec:vector = result.position.vector - ownerLoc.vector;
		if resultDistVec.length > g_knockbackConst.searchRadius then
			endLocation = ToLocation(result.position)
			myMat = GetLookPosition(self.ownerUnit, resultDistVec.length)
		end
	end

	local directionVectorNormalized:vector = Vector_Normalize(Unit_GetAimingVector(self.ownerUnit))
	directionVectorNormalized.z = directionVectorNormalized.z + g_knockbackConst.zAxisBoost

	-- Testing allowing players to punt objects upward, but still force some upward movement if the target is below the player (our ground is VERY sticky and pushed objects need some Z assistance)
	if directionVectorNormalized.z < 0.1 then
		directionVectorNormalized.z = 0.1
	elseif directionVectorNormalized.z > 1 then
		directionVectorNormalized.z = 1
	end

	local blastStrength:number = g_knockbackConst.blastStrengthMod; 
	if not GameIsNetworked() then
		blastStrength = blastStrength * g_knockbackConst.unnetworkedGameModifier;
	end
	local arcBlastVector = directionVectorNormalized * blastStrength;
	local blastedObjectType:object_type = Engine_GetObjectType(enemyToBlast);
	local usedObjTransform:boolean = false
	if Object_IsUnit(enemyToBlast) then
		SleepSeconds(0)
		if blastedObjectType == OBJECT_TYPE._object_type_vehicle then
			usedObjTransform = true
			local vehicleDef:tag = Object_GetDefinition(enemyToBlast);
			local airborneVehicle:boolean = g_knockbackConst.airborneVehicleCheck[vehicleDef];
			-- Players driving flying vehicles are harder to push due to code that is trying to simulate flight and maintain their movement. 
			if airborneVehicle and IsPlayer(Vehicle_GetDriver(enemyToBlast)) then
				blastStrength = blastStrength * g_knockbackConst.airborneDriverBlastModifier;
			end
			arcBlastVector = directionVectorNormalized * blastStrength;

			local stunVehId:number = AddObjectTimedMalleablePropertyModifier("unit_locomotion_power_capacity", g_knockbackConst.vehicleStunDuration, 0, enemyToBlast)
			RunClientScript("KnockbackVehiclePushFX", enemyToBlast, arcBlastVector) -- play triggered SFX on the Vehicle
			ObjectSetWorldVelocity(enemyToBlast, arcBlastVector);
		elseif not IsPlayer(enemyToBlast) then
			blastStrength = blastStrength * g_knockbackConst.nonPlayerUnitBlastModifier;
			-- Brutes are heavier than normal bipeds and need some extra love
			if Unit_GetMetagameType(enemyToBlast) == Engine_ResolveStringId("brute") then
				blastStrength = blastStrength * 2; 
			end
		else	
			RunClientScript("KnockbackHitPlayerFX", self.ownerUnit)
			-- When checking if the object is a unit, this will see if the unit is grappling to the knockback player.
			-- To avoid rubberbanding the grapple hooking enemy, this section will simply break the grapple hook tether
			-- and allow the rest of the knockback script to push the enemy away. 
			local grappleHookList:object_list = object_list_children(self.ownerUnit, TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook.projectile'))
			if grappleHookList ~= nil then
				for _, grappleHook in hpairs(grappleHookList) do
					if enemyToBlast == Player_GetUnit(Object_GetDamageOwnerPlayer(grappleHook)) then
						Object_Detach( grappleHook )
						object_destroy( grappleHook )
					end
				end
			end
		end
		arcBlastVector = directionVectorNormalized * blastStrength;

	-- There are a LOT of checks for projectiles to make sure the player gets the credit for killing the enemy with their own projectiles
	elseif blastedObjectType == OBJECT_TYPE._object_type_projectile then
		blastStrength = blastStrength * g_knockbackConst.projectileBlastModifier; 
		arcBlastVector = directionVectorNormalized * blastStrength;
		
		RunClientScript("KnockbackProjectilePushFX", enemyToBlast) -- play triggered SFX on the Projectile
		local newProjectile:object = nil
		usedObjTransform = true
		local projectileMat:matrix = GetObjectTransform(enemyToBlast)
		local projectileOwnerPlayer:player = Object_GetDamageOwnerPlayer(enemyToBlast)
		projectileMat.angles = myMat.angles;
		if projectileOwnerPlayer == self.ownerPlayer then
			newProjectile = enemyToBlast
			SetObjectTransform(newProjectile, projectileMat)
			object_set_velocity(newProjectile, 0, 0, 0);
		elseif GetDispositionPlayerPlayer(projectileOwnerPlayer, self.ownerPlayer) ~= DISPOSITION.Allied and object_index_valid(enemyToBlast) then
			local newProjectileTag:tag = Object_GetDefinition(enemyToBlast)
			local projectileToIgnore:boolean = g_knockbackConst.projectilesToIgnoreByTagDefinition[newProjectileTag];
			if not projectileToIgnore and not object_get_at_rest(enemyToBlast) then
				newProjectile = Engine_CreateObject(newProjectileTag, objLoc)
				object_destroy(enemyToBlast)
			elseif not projectileToIgnore and object_get_at_rest(enemyToBlast) then
				newProjectile = Engine_CreateObject(newProjectileTag, objLoc)
				CreateThread(KnockbackKickUp, self, newProjectile, blastStrength, arcBlastVector, directionVectorNormalized, projectileMat, enemyToBlast)
			elseif projectileToIgnore and object_get_at_rest(enemyToBlast) then
				newProjectile = enemyToBlast
				SetObjectTransform(newProjectile, projectileMat)
				--CreateThread(KnockbackKickUp, self, newProjectile, blastStrength, arcBlastVector, directionVectorNormalized, projectileMat)
				-- ^^ Ideally projectiles that the ability must not destroy and re-create will still get pushed away.
				-- Until that ideal functionality is possible, simply kill the projectile
				object_destroy(newProjectile)
			else
				newProjectile = enemyToBlast
			end
			SetObjectTransform(newProjectile, projectileMat)
			object_set_velocity(newProjectile, 0, 0, 0);
		end
		ObjectSetWorldVelocity(newProjectile, arcBlastVector);
		ApplyBlastTransform(newProjectile, projectileMat, arcBlastVector);
	elseif object_index_valid(enemyToBlast) then
		arcBlastVector = directionVectorNormalized * blastStrength;
	end

	if not usedObjTransform then
		object_set_velocity(enemyToBlast, 0, 0, 0);
		Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
		if GameIsNetworked() then
			ApplyBlastImpulse(enemyToBlast, arcBlastVector);
		end

		local knockedTimerStart:time_point = Game_TimeGet();
		KnockbackMonitorKnockedObj(self, enemyToBlast, knockedTimerStart, blastedObjectType)
	end

end


function KnockbackMonitorKnockedObj(self, knockedObject:object, knockedTimerStart:time_point, blastedObjectType:object_type)
	local maxTime:number = g_knockbackConst.knockbackMonitorWindow + g_knockbackConst.landedMonitorTime;
	local targetTookDamage:boolean = false
	HSDamageObjectEffectWithDamageInfo(TAG('objects\armor\attachments\attachment_abilities\ability_knockback\fx\knockback_impact.damage_effect'), knockedObject, self.ownerUnit, "knockback");
	-- Deal base damage now to give kill credit to the user if the enemy is knocked off the edge of a map. 
	SleepSeconds(0) -- give AI a frame to begin their H-ping

	-- don't want to risk weird behavior from projectiles, but I do want to catch the fusion coils and blow them up when they hit something
	if blastedObjectType ~= OBJECT_TYPE._object_type_projectile then
		local startLoc:location = location(knockedObject, "fx_root")
		local startLocVec:vector = startLoc.vector
		if Object_IsOrWasPlayer(knockedObject)  then
			-- wait till the object is airborne from the push
			-- Note: AI don't seem to properly know when they're airborne
			SleepUntilSeconds ([| Unit_IsAirborne(knockedObject) or KnockbackExpired(knockedTimerStart, maxTime) ] , 0);
		end
		local objVelocity:vector = ObjectGetVelocity(knockedObject)
		local objectLoc:location = location(knockedObject, "fx_root")
		local prevVelocity:vector = objVelocity
		local prevLoc:location = location(self, "")
		local passOne:boolean = true
		while targetTookDamage == false and not KnockbackExpired(knockedTimerStart, maxTime) and object_index_valid(knockedObject) and object_get_health(self.ownerUnit) > 0 do
			objVelocity = ObjectGetVelocity(knockedObject)
			
			if passOne == true then
				prevVelocity.x = objVelocity.x - 0.01; 
				prevVelocity.y = objVelocity.y - 0.01; 
				passOne = false
			end
			objectLoc = location(knockedObject, "fx_root")
			targetTookDamage = KnockbackDamageCheck(self, knockedObject, objVelocity, prevVelocity, objectLoc.vector, prevLoc.vector, startLocVec)
			-- I'm not seeing AI ever go "airborne" so for now, I just need to run the script on them for the maxTime
			if Object_IsOrWasPlayer(knockedObject) then
				-- Prevent edge cases of players escaping damage simply because they skipped off the ground, but are still under the influenced by the momentum of the push.
				if not Unit_IsAirborne(knockedObject) then
					maxTime = g_knockbackConst.landedMonitorTime
				else
					maxTime = g_knockbackConst.knockbackMonitorWindow + g_knockbackConst.landedMonitorTime
				end
			else
				maxTime = g_knockbackConst.knockbackMonitorWindow + g_knockbackConst.landedMonitorTime
			end
			prevVelocity = objVelocity; 
			prevLoc = objectLoc; 
			SleepSeconds(0) -- Let object velocity update beyond previous
		end
	end
end

function KnockbackDamageCheck(self, knockedObject:object, objVelocity:vector, prevVelocity:vector, objectLoc:vector, prevLoc:vector, startLocVec:vector):boolean
	local maxTime:number = g_knockbackConst.knockbackMonitorWindow + g_knockbackConst.landedMonitorTime;
	local dealTheDamage:boolean = false;
	local deltaVelocity:vector = (objVelocity - prevVelocity);
	-- if your velocity is lower than 0.0001, you're probably running against a wall so... you've collided with something. Take that damage. Also, make sure they player isn't just back-peddling into a wall to avoid taking damage
	local absVelocityX:number = math.abs(deltaVelocity.x)
	local absVelocityY:number = math.abs(deltaVelocity.y)
	local wallHuggingCheck:boolean = (absVelocityX < 0.0001) or (absVelocityY < 0.0001);
	local objLocModZ:vector = vector(objectLoc.x, objectLoc.y, 0)
	local prevLocModZ:vector = vector(prevLoc.x, prevLoc.y, 0)
	local deltaObjLocLength:number = (objLocModZ - prevLocModZ).length;
	if Object_IsUnit(knockedObject) and Object_IsOrWasPlayer(knockedObject) then 
		-- Did the velocity change drastically from colliding with something?
		if Unit_IsAirborne(knockedObject) and (absVelocityX > g_knockbackConst.velocityDeltaThreshold or absVelocityY > g_knockbackConst.velocityDeltaThreshold) then
			dealTheDamage = true;
	
		-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Nativization Note: This is to check if the player was in corner or up against a wall, but this also triggers if the player is pushed directly along any axis (test in Firing Range along the walls). Need to solve for that :(
		-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		elseif wallHuggingCheck then
			dealTheDamage = true;
		end
	elseif Object_IsUnit(knockedObject) then
		if (deltaVelocity.x > g_knockbackConst.aiVelocDeltaThreshold or deltaVelocity.y > g_knockbackConst.aiVelocDeltaThreshold) then
				dealTheDamage = true;
		elseif deltaObjLocLength == 0 and wallHuggingCheck then
				dealTheDamage = true;
		end
	end
	if dealTheDamage == true then
		HSDamageObjectWithDamageInfo(knockedObject, self.ownerUnit, "knockback", "body", g_knockbackConst.bigDamage);
		RunClientScript("KnockbackBigDamageAudio", knockedObject) -- play triggered SFX for big damage
		if Object_IsUnit(knockedObject) and object_get_health(knockedObject) > 0 then
			RunClientScript("KnockedObjectDamageImpactFX", knockedObject)
			damage_object_effect( TAG('objects\armor\attachments\attachment_abilities\ability_leap_pound\leap_pound_rumble.damage_effect'), knockedObject);
		end
		return true;
	end
	return false;
end

function KnockbackKickUp(self, projectileToKick, blastStrength, arcBlastVector, directionVectorNormalized, projectileMat, oldProjectile)
	Object_Detach(oldProjectile)
	object_destroy(oldProjectile)
	local zAxisProjectileBoost = 0.25
	directionVectorNormalized.z = zAxisProjectileBoost;
	blastStrength = blastStrength * g_knockbackConst.projectileBlastModifier; 
	arcBlastVector = directionVectorNormalized * blastStrength;
	projectileMat.pos.z = projectileMat.pos.z + 0.2
	ObjectSetWorldVelocity(projectileToKick, arcBlastVector);
	if GameIsNetworked() then
		ApplyBlastImpulse(projectileToKick, arcBlastVector);
	end
end

function CheckArcBlastLOSToPlayer (userCameraPt:location, endpoint:location): boolean
	if endpoint ~= nil and userCameraPt ~= nil then
		local rayCastResult:table = Physics_RayCast(userCameraPt, endpoint, "zero_extent");

		-- if we hit something between players, their view is obstructed (partially at least) and we don't have LOS
		if (rayCastResult ~= nil) then
			return false;
		else
			return true;
		end
	end
	return false
end

function KnockbackExpired(startTime:time_point, knockDuration:number) : boolean
	local timeNow:time_point = Game_TimeGet();
	return timeNow:ElapsedTime(startTime) >= knockDuration;
end

function ApplyBlastTransform (enemyToBlast, projectileMat:matrix, arcBlastVector:vector)
	SetObjectTransform(enemyToBlast, projectileMat)
	object_set_velocity(enemyToBlast, 0, 0, 0);
	ObjectSetWorldVelocity(enemyToBlast, arcBlastVector);
end

function ApplyBlastImpulse (enemyToBlast, arcBlastVector)
	if Object_IsPlayer(enemyToBlast) then
		if (PlayerIsLocal(unit_get_player(enemyToBlast)) == true) then 
			-- don't zero out the forward momemntum if it's the owner
			Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
		else	
			object_set_velocity(enemyToBlast, 0, 0, 0);
			Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
		end
	end
end

--## CLIENT

function remoteClient.KnockbackFiredSoundFX (self)
	SendGameEvent(self, "Audio_Knockback_Fire") -- play activate SFX
end

--We requested support for node graphs to play audio at an object's location, but until then we'll spawn FX at that location with audio attached to it
function remoteClient.KnockbackVehiclePushFX (knockedObject:object, arcBlastVector:vector)
	local fxLocation = ""
	effect_new_on_object_marker( TAG('objects\armor\attachments\attachment_abilities\ability_knockback\fx\knockback_status_effect_vehicle.effect'), knockedObject, fxLocation);
--	SendGameEvent(ownerUnit, "Knockback_VehiclePush", atvehicleLocation) -- play vehicle pushed SFX
end

function remoteClient.KnockbackProjectilePushFX (knockedObject:object)
	local fxLocation = ""
	effect_new_on_object_marker( TAG('objects\armor\attachments\attachment_abilities\ability_knockback\fx\knockback_status_effect_projectile.effect'), knockedObject, fxLocation);
--	SendGameEvent(ownerUnit, "Knockback_ProjectilePush", atProjectileLocation) -- play projectile pushed SFX
end

function remoteClient.KnockbackHitPlayerFX (ownerUnit:object)
	SendGameEvent(ownerUnit, "Audio_Knockback_Hit_Target") -- play impact SFX
end

function remoteClient.KnockbackBigDamageAudio (enemyToBlast:object)
	SendGameEvent(enemyToBlast, "Knockback_WallSlam_Hard") -- play projectile Big Damage SFX
end

function remoteClient.KnockbackMedDamageAudio (enemyToBlast:object)
	SendGameEvent(enemyToBlast, "Knockback_WallSlam_Hard") -- play projectile Med Damage SFX
end

function remoteClient.KnockedObjectDamageImpactFX (knockedObject)
	local fxLocation = ""
	if Object_IsPlayer(knockedObject) then
		fxLocation = "fx_root"
	else
		fxLocation = "pedestal"
	end

	effect_new_on_object_marker( TAG('objects\armor\attachments\attachment_abilities\ability_knockback\fx\knockback_impact_lg.effect'), knockedObject, fxLocation);

end

