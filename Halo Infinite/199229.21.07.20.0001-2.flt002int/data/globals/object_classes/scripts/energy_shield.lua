-- object energy_shield

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');

hstructure energy_shield
	meta:table;
	instance:luserdata;
end

function energy_shield:init()
	Object_SetFunctionValue(self, "body_vitality", object_get_health(self), 0.1);

	RegisterEvent(g_eventTypes.objectDamagedEvent, self.OnShieldDamaged, self, self);
	RegisterEvent(g_eventTypes.objectDeletedEvent, self.OnSelfDies, self, self);
end

function energy_shield.OnSelfDies(selfDestroyed, self)
	UnregisterEvent(g_eventTypes.objectDeletedEvent, self.OnSelfDies, self);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, self.OnShieldDamaged, self);
end

function energy_shield.OnShieldDamaged(eventArgs:ObjectDamagedEventStruct, self)
	Object_SetFunctionValue(self, "body_vitality", object_get_health(self), 0.1);
end


--## CLIENT