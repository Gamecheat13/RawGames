-- object mp_grenade_detonation

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure mp_grenade_detonation
	meta:table
	instance:luserdata
end

function mp_grenade_detonation:init() : void
	local mpMedalEvents:table = _G["MPMedalEvents"];
	if (mpMedalEvents ~= nil) then
		mpMedalEvents.TrackGrenadeForRemoteDetonation(self);
	end
end
