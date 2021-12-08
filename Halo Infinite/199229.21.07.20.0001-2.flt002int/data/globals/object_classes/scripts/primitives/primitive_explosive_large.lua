-- object primitive_explosive_large

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure primitive_explosive_large
	meta : table
	instance : luserdata
end

function primitive_explosive_large:init()
	-- fusion coils are never on a team, else friendly-fire settings can render them un-damageable by a team.
	set_object_campaign_and_mp_team(self, TEAM.neutral, nil, true);
end