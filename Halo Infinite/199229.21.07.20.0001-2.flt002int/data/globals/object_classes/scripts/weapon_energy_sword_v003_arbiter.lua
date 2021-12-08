-- object weapon_energy_sword_v003_arbiter

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
hstructure weapon_energy_sword_v003_arbiter
	meta:table
	instance:luserdata
end

global g_weaponEnergySwordArbiterConstants = table.makePermanent
{
	weaponAgePercent = 0.002,		-- weapon age percent per sec while in primary slot/not stowed
}

function weapon_energy_sword_v003_arbiter:init() : void
	if WeaponIsArbiterSword(self) then	
		CreateThread(WeaponEnergySwordCamoSearching, self)
	end
end

function WeaponIsArbiterSword(self) : boolean
	return (get_string_id_from_string("arbiter") == ObjectGetVariant(self));
end

function WeaponEnergySwordCamoSearching(self) : void
	while object_index_valid(self) do
		local swordUltimateParent:object = object_get_parent(self);
		if (Object_IsPlayer(swordUltimateParent)) and (unit_get_primary_weapon(swordUltimateParent) == self) then
			-- Turn on the Sword Again
			self:AgingUpdate();
		end
		SleepSeconds(10/60); -- give it a frame to update
	end
end

function weapon_energy_sword_v003_arbiter:AgingUpdate() : void
	local currentAge = weapon_get_age(self)
	if currentAge < 1.0 then
		local swordNewAge = math.min(currentAge + g_weaponEnergySwordArbiterConstants.weaponAgePercent, 1);
		weapon_set_age(self, swordNewAge);
	end
end