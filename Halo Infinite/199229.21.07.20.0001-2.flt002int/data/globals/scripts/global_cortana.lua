-- Copyright (c) Microsoft Corporation.  All rights reserved.

--## SERVER

global CortanaUnlockTable:table = table.makePermanent
{
	default		= true;
	sentinel_1	= false,
	sentinel_2	= false,
	sentinel_3	= false,
	plinth_1	= false,
	plinth_2	= false,
	plinth_3	= false,
	visor_1		= false,
	visor_2		= false,
	visor_3		= false,
	shield_1	= false,
	shield_2	= false,
	shield_3	= false;
};

-- Check if a variant is an unlock, otherwise return default
function ValidateHackingSkill(variant:string): string
	if CortanaUnlockTable[variant] ~= nil then
		return variant;
	end
	return "default";
end