-- object mp_weapon_classic_placement:mp_weapon_full_placement
--## SERVER

REQUIRES('globals\object_classes\scripts\mp_weapon_full_placement_kit.lua');
REQUIRES('scripts\ParcelLibrary\parcel_mp_weapon_placement.lua');

hstructure mp_weapon_classic_placement:mp_weapon_full_placement
	dummy:boolean				-- need something in hstructure to derive
end

function mp_weapon_classic_placement:init()
	if (self.mpWeaponPlacementParcel ~= nil) then
		-- don't want derived classes double calling init()
		return;
	end
	
	if (self:AssignParcel() == nil) then
		return;
	end
	
	self:Initialize();
	self.isInvisible = true;
	self.previewAsHologram = false;
	self.itemShouldRotate = false;
	self.pingMessaging = false;
end
