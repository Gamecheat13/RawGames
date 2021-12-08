-- object primitive_fusion_coil

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure primitive_fusion_coil
	meta : table
	instance : luserdata
	collisionDmgSource : ui64
end

global g_plasmaFusionCoilParams = table.makePermanent
{
	coreVelocityScalar = 0.25;
}


function primitive_fusion_coil:init()
	-- fusion coils are never on a team, else friendly-fire settings can render them un-damageable by a team.
	self.collisionDmgSource =  get_string_id_from_string("collision");
	set_object_campaign_and_mp_team(self, TEAM.neutral, nil, true);
	RegisterEvent(g_eventTypes.weaponThrowEvent, self.WeaponThrow, self);
	RegisterEvent(g_eventTypes.objectDeletedEvent, self.OnDestroyed, self);
	if (ObjectGetVariant(self) == Engine_ResolveStringId("banished_plasma")) then
		RegisterEvent(g_eventTypes.deathEvent, self.OnDeath, self, self);
	end

	local mpMedalEvents:table = _G["MPMedalEvents"];
	if (mpMedalEvents ~= nil) then
		mpMedalEvents.TrackFusionCoil(self);
	end
end

function primitive_fusion_coil.WeaponThrow(eventArgs)
	local persistenceKey = Persistence_TryCreateKeyFromString("StatFusionCoilsThrown");
	if persistenceKey ~= nil and eventArgs.player ~= nil then
		local persistenceValue = Persistence_GetLongKeyForParticipant(eventArgs.player, persistenceKey);
		Persistence_SetLongKeyForParticipant(eventArgs.player, persistenceKey, persistenceValue+1);
	end

	Object_SetDamageOwnerObject(eventArgs.thrownWeapon, eventArgs.throwingUnit);

	RegisterEventOnce(g_eventTypes.objectDamagedEvent, eventArgs.thrownWeapon.OnDamage, eventArgs.thrownWeapon, eventArgs.thrownWeapon);
end

function primitive_fusion_coil.OnDamage(eventArgs, thrownWeapon:object)
	if eventArgs.damageType == thrownWeapon.collisionDmgSource then
		UnregisterEvent(g_eventTypes.objectDamagedEvent, thrownWeapon.OnDamage, thrownWeapon);
		Object_Kill(Object_GetIndex(thrownWeapon), false, true, eventArgs.damageSource, eventArgs.damageType, eventArgs.damageModifier);
	end
end

function primitive_fusion_coil.OnDeath(eventArgs, thisObject:object)
	if thisObject ~= nil then
		local fusionPlasmaCore = Engine_CreateObject(TAG('objects\primitives\explosive_large\garbage\core\core_plasma_fragment\core_plasma_fragment.crate'), location(thisObject, "garbage_spawn"));
		local coilVelocity = ObjectGetVelocity(thisObject) * g_plasmaFusionCoilParams.coreVelocityScalar;
		if fusionPlasmaCore ~= nil then
				object_set_velocity(fusionPlasmaCore, coilVelocity.x, coilVelocity.y, coilVelocity.z);
		end
	end
end

function primitive_fusion_coil.OnDestroyed(eventArgs)
	UnregisterEvent(g_eventTypes.objectDamagedEvent, eventArgs.deletedObject.OnDamage, eventArgs.deletedObject);
	UnregisterEvent(g_eventTypes.weaponThrowEvent, eventArgs.deletedObject.WeaponThrow, eventArgs.deletedObject);
	UnregisterEvent(g_eventTypes.objectDeletedEvent, eventArgs.deletedObject.OnDestroyed, eventArgs.deletedObject);
	UnregisterEvent(g_eventTypes.deathEvent, eventArgs.deletedObject.OnDeath, eventArgs.deletedObject);
end

