-- object winning_team_outro
-- Copyright (c) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_hstructs.lua');

hstructure winning_team_outro
	meta:table;				-- required
	instance:luserdata;		-- required (must be first slot after meta to prevent crash)
	components:userdata;	-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	rootPosition:location;
end

--## SERVER
function winning_team_outro:init()
	self.rootPosition = Object_GetPosition(self.components.root);
end

function winning_team_outro:GetPosition():location
	return self.rootPosition;
end

--## CLIENT
function winning_team_outro:PlayComposition(data:table):number
	return composer_play_show_handle(self.components.outro_composition, data, false);
end