-- object mp_grenade_classic_placement:mp_grenade_placement_base
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_grenade_placement_base_kit.lua');

hstructure mp_grenade_classic_placement:mp_grenade_placement_base
	dummy:boolean				-- need something in hstructure to derive
end

function mp_grenade_classic_placement:init()
	if (self.mpGrenadePlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end

	self:Initialize();
	self.isInvisible = true;
	self.groupCountStringBase = "1";
	self.spawnCyclicallyBase = false;
	self.pingMessaging = false;
end
