-- object health_pack_mp
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure health_pack_mp
	meta : table
	instance : luserdata
end

global g_healthPackMpGlobals =
{
	pickupRadius = 0.1;
	healthAmount = 1;
}

function health_pack_mp:init() : void 
	CreateObjectThread(self, self.CustomInitThread, self);
end

function health_pack_mp:CustomInitThread():void
	SleepSeconds(0.5)
	CreateThread(HealthPackMpMonitorForPickup, self);
end

function HealthPackMpMonitorForPickup(self)
	local loc:location = location(self,"");

	while(object_index_valid(self)) do
		local objectsAroundPlayer:object_list = Object_GetObjectsInSphere(loc, g_healthPackMpGlobals.pickupRadius);

		for _, objectInSphere in hpairs(objectsAroundPlayer) do
			local objectHealth:number = Object_GetHealth(objectInSphere)
			local objectShields:number = object_get_shield(objectInSphere)
			if (Object_IsUnit(objectInSphere) and objectHealth > 0 and Object_IsPlayer(objectInSphere) and (objectHealth < 1 or objectShields < 1))  then
				ApplyMpHealPackToPlayer(self, objectInSphere);
				break;
			end
		end
		SleepSeconds(0.1)
	end
end

function ApplyMpHealPackToPlayer(self, objectInSphere) : void
	local currentTargetHealth:number = object_get_health(objectInSphere);
	local healingAmount:number = g_healthPackMpGlobals.healthAmount;
	local newHealth:number = math.min(currentTargetHealth + healingAmount, 1)
	
	RunClientScript("PlayMpHealthPickupEffects", self, objectInSphere);
	Object_SetHealth(objectInSphere, newHealth);
	
	Object_SetShieldStun(objectInSphere, 0);
	SleepSeconds(0.05)
	object_destroy(self);
end

--## CLIENT

function remoteClient.PlayMpHealthPickupEffects(self, healedPlayer)
	local HealthPackloc = location(self, "");
	local HealedPlayerLoc = location(healedPlayer, "");
	effect_new( TAG('objects\characters\test_spartan_armor\socket_prototypes\fx\melee_heal_hit.effect'), HealthPackloc);
	effect_new( TAG('objects\characters\test_spartan_armor\socket_prototypes\fx\area_heal_pulse.effect'), HealedPlayerLoc);
end
