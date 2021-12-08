-- object death_volume
-- Copyright (c) Microsoft. All rights reserved. 

--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalEngineCallbacks.lua');

hstructure death_volume
	meta		:table				-- required
	instance	:luserdata			-- required (must be first slot after meta to prevent crash)
	components	:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
end