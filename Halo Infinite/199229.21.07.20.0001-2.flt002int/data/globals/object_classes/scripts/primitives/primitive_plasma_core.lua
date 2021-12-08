-- object primitive_plasma_core

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure primitive_plasma_core
	meta : table
	instance : luserdata
end

function primitive_plasma_core:init()
	-- fusion coils are never on a team, else friendly-fire settings can render them un-damageable by a team.
	set_object_campaign_and_mp_team(self, TEAM.neutral, nil, true);
	
	self:CreateThread(self.CheckRestingThread, self);
end

function primitive_plasma_core:CheckRestingThread()
	while self ~= nil do
		SleepSeconds(1);
		if ObjectGetSpeed(self) < 1 then
			Object_SetSelfDestructTime(self, 6);
			object_set_permutation(self, "default", "damage_on");
			return;
		end
	end
end