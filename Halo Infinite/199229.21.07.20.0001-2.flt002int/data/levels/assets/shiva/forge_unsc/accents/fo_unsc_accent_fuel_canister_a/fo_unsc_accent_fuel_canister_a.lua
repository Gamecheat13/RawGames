-- object fo_unsc_accent_fuel_canister_a
-- Copyright (c) Microsoft. All rights reserved.
-- Author: Turner Sinopoli 
--## SERVER
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');
REQUIRES('globals\scripts\global_hstructs.lua');

hstructure fo_unsc_accent_fuel_canister_a
	meta				:table;		-- required, must be first
	instance			:luserdata; -- required, must be second
	components			:userdata;	--required slot for kits
	broken_hose			:object 
end

function fo_unsc_accent_fuel_canister_a:init()
	self:RegisterEventOnceOnSelf(g_eventTypes.deathEvent, self.OnDestruction, self);

	self.broken_hose = Object_GetObjectAtMarker(self, "fx_root");

	if self.broken_hose ~= nil then 
		object_hide(self.broken_hose, true);
	end
end

function fo_unsc_accent_fuel_canister_a:OnDestruction()
	object_hide(self.broken_hose, false);
end