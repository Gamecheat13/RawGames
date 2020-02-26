-- object fo_unsc_teleporter

-- Copyright (C) Microsoft. All rights reserved.

--## SERVER

function OnObjectTeleportEnterUnsc(teleportingObject:object, teleporter:object)
	RunClientScript("OnObjectTeleportEnterUnscClient", teleportingObject, teleporter);
end

function OnObjectTeleportExitUnsc(teleportingObject:object, teleporter:object)
	RunClientScript("OnObjectTeleportExitUnscClient", teleportingObject, teleporter);
end

--## CLIENT

function remoteClient.OnObjectTeleportEnterUnscClient(teleportingObject:object, teleporter:object)
	sound_playFromObject_overridePlayerness(TAG('sound/004_device_machine/004_dm/004_dm_sustain/004_dm_sustain_teleporter/004_dm_sustain_teleporter_unsc_start.sound'), teleporter, teleportingObject);
	-- Jason: effect_new_on_object_marker(TAG('fx/sustain/restOfThePath.effect'), teleporter, "fx_base");
end

function remoteClient.OnObjectTeleportExitUnscClient(teleportingObject:object, teleporter:object)
	sound_playFromObject_overridePlayerness(TAG('sound/004_device_machine/004_dm/004_dm_sustain/004_dm_sustain_teleporter/004_dm_sustain_teleporter_unsc_arrive.sound'), teleporter, teleportingObject);
	-- Jason: effect_new_on_object_marker(TAG('fx/sustain/restOfThePath.effect'), teleporter, "fx_base");
end
