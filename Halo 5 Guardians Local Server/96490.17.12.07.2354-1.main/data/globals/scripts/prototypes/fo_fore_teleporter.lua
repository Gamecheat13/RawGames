-- object fo_fore_teleporter

-- Copyright (C) Microsoft. All rights reserved.

--## SERVER

function OnObjectTeleportEnterForerunner(teleportingObject:object, teleporter:object)
	RunClientScript("OnObjectTeleportEnterForerunnerClient", teleportingObject, teleporter);
end

function OnObjectTeleportExitForerunner(teleportingObject:object, teleporter:object)
	RunClientScript("OnObjectTeleportExitForerunnerClient", teleportingObject, teleporter);
end

--## CLIENT

function remoteClient.OnObjectTeleportEnterForerunnerClient(teleportingObject:object, teleporter:object)
	sound_playFromObject_overridePlayerness(TAG('sound/004_device_machine/004_dm/004_dm_sustain/004_dm_sustain_teleporter/004_dm_sustain_teleporter_forerunner_start.sound'), teleporter, teleportingObject);
	effect_new_on_object_marker(TAG('fx/sustain/restOfThePath.effect'), teleporter, "fx_base");
end

function remoteClient.OnObjectTeleportExitForerunnerClient(teleportingObject:object, teleporter:object)
	sound_playFromObject_overridePlayerness(TAG('sound/004_device_machine/004_dm/004_dm_sustain/004_dm_sustain_teleporter/004_dm_sustain_teleporter_forerunner_arrive.sound'), teleporter, teleportingObject);
	effect_new_on_object_marker(TAG('fx/sustain/restOfThePath.effect'), teleporter, "fx_base");
end
