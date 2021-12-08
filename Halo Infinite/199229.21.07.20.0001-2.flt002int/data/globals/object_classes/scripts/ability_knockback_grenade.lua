-- object ability_knockback_grenade

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure ability_knockback_grenade
	meta:table
	instance:luserdata
	ownerPlayer:player
end

global g_knockbackNadeConst = table.makePermanent
{
	searchRadius = 6,
	damageAmount = 1,
	blastStrengthMod = 5.5,
}

function ability_knockback_grenade:init() : void 
	self.ownerPlayer = Object_GetDamageOwnerPlayer(self);
	SendGameEvent(self, "Audio_Knockback_Fire") -- play activate SFX
	
	RegisterEvent(g_eventTypes.objectDeletedEvent, FindKnockNadeTargetAtLookPosition, self, self);
end

function FindKnockNadeTargetAtLookPosition (eventData, self)
	local playerMPTeam:mp_team = Player_GetMultiplayerTeam(self.ownerPlayer);
	local playerCampaignTeam:team = Player_GetCampaignTeam(self.ownerPlayer);
	Object_SetMultiplayerTeam(self, playerMPTeam);
	Object_SetCampaignTeam(self, playerCampaignTeam);
	local startPoint:location = location(self, "fx_root");
	local objectsToBlast:table = {};

	-- Grab all objects around player and filter for allies in their field of view
	local allObjectsAroundMe:object_list = Object_GetObjectsInSphere(startPoint, g_knockbackNadeConst.searchRadius);
	for _, objectInSphere in hpairs(allObjectsAroundMe) do
		if GetMpDispositionObjectObject(objectInSphere, self) ~= DISPOSITION.Allied then
			local objLoc:location = location(objectInSphere, "fx_root");
			local objHead:location = location(objectInSphere, "head");
			local objFeet:location = location(objectInSphere, "pedestal");
			if (CheckKnockNadeLOSToPlayer(startPoint, objLoc) or CheckKnockNadeLOSToPlayer(startPoint, objHead) or CheckKnockNadeLOSToPlayer(startPoint, objFeet)) then
				table.insert(objectsToBlast, objectInSphere);
			end
		end
	end
	AttemptToKnockTarget(self, objectsToBlast)
	object_destroy(self);
end

function CheckKnockNadeLOSToPlayer (startpoint, endpoint): boolean
	local rayCastResult:table = Physics_RayCast(startpoint, endpoint, "environment_only");

	-- if we hit something between players, their view is obstructed (partially at least) and we don't have LOS
	if (rayCastResult ~= nil) then
		return false;
	else
		return true;
	end
end



function AttemptToKnockTarget (self, objectsToBlast:table)
	for _, thisObject in hpairs(objectsToBlast) do
		KnockNadePushProjectiles(self, thisObject)
		MPLuaCall("__OnArcBlastPersonalScore", self.ownerPlayer);-- Personal Score for Healing Done
	end
	
end

function KnockNadePushProjectiles (self, enemyToBlast:object)
	local ownerLoc:location = location(self.ownerPlayer, "fx_root");
	local objLoc:location = location(enemyToBlast, "fx_root");
	local objPositionVector:vector = objLoc.vector;
	local directionVector:vector =  objPositionVector - ownerLoc.vector;
	local directionVectorNormalized:vector = Object_GetForward(self);
	if (directionVector.length > 0.001) then
		directionVectorNormalized = directionVector / directionVector.length;
	end
	local blastStrength:number = g_knockbackNadeConst.blastStrengthMod; 
	local arcBlastVector = directionVectorNormalized * blastStrength;
	local blastedObjectType:object_type = Engine_GetObjectType(enemyToBlast);

	if blastedObjectType == OBJECT_TYPE._object_type_projectile then
		local projectileOwnerPlayer:player = Object_GetDamageOwnerPlayer(enemyToBlast)
		local projectileOwnerObject:object = Player_GetUnit(projectileOwnerPlayer);

		if projectileOwnerPlayer == self.ownerPlayer then
			directionVectorNormalized.z = directionVectorNormalized.z * 0.75;
			blastStrength = g_knockbackNadeConst.blastStrengthMod * 1.25; 
			arcBlastVector = directionVectorNormalized * blastStrength;
			Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
		elseif GetDispositionPlayerPlayer(projectileOwnerPlayer, self.ownerPlayer) ~= DISPOSITION.Allied then
			ownerLoc = location(projectileOwnerObject, "");
			objLoc = location(enemyToBlast, "");
			directionVector =  objLoc.vector - ownerLoc.vector;
			directionVectorNormalized = directionVector * -1/ directionVector.length;
			directionVectorNormalized.z = directionVectorNormalized.z * -0.75;
			blastStrength = g_knockbackNadeConst.blastStrengthMod * 1.25; 
			arcBlastVector = directionVectorNormalized * blastStrength;
			Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
		end
	else
		blastStrength = g_knockbackNadeConst.blastStrengthMod * 2; 
		directionVectorNormalized.z = 0.1;
		arcBlastVector = directionVectorNormalized * blastStrength;
		Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
	end


	sleep_s(0.1)

	ApplyBlastImpulse(enemyToBlast, arcBlastVector);

end

function ApplyBlastImpulse (enemyToBlast, arcBlastVector)
	object_set_velocity(enemyToBlast, 0, 0, 0);

	if Object_IsOrWasPlayer(enemyToBlast) then
		if (PlayerIsLocal(unit_get_player(enemyToBlast)) == false) then	
			return;
		end
	end
	Object_ApplyCenterOfMassAcceleration(enemyToBlast, arcBlastVector);
end