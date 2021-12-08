-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

-- requires
REQUIRES('scripts\ParcelLibrary\parcel_mp_seedsequence.lua');
REQUIRES('scripts\ParcelLibrary\parcel_seedsequence.lua');

--[[

 ███▄ ▄███▓ ██▓███      ██▓▄▄▄█████▓▓█████  ███▄ ▄███▓     ██████ ▓█████ ▓█████ ▓█████▄   ██████ ▓█████   █████   █    ██ ▓█████  ███▄    █  ▄████▄  ▓█████ 
▓██▒▀█▀ ██▒▓██░  ██▒   ▓██▒▓  ██▒ ▓▒▓█   ▀ ▓██▒▀█▀ ██▒   ▒██    ▒ ▓█   ▀ ▓█   ▀ ▒██▀ ██▌▒██    ▒ ▓█   ▀ ▒██▓  ██▒ ██  ▓██▒▓█   ▀  ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ 
▓██    ▓██░▓██░ ██▓▒   ▒██▒▒ ▓██░ ▒░▒███   ▓██    ▓██░   ░ ▓██▄   ▒███   ▒███   ░██   █▌░ ▓██▄   ▒███   ▒██▒  ██░▓██  ▒██░▒███   ▓██  ▀█ ██▒▒▓█    ▄ ▒███   
▒██    ▒██ ▒██▄█▓▒ ▒   ░██░░ ▓██▓ ░ ▒▓█  ▄ ▒██    ▒██      ▒   ██▒▒▓█  ▄ ▒▓█  ▄ ░▓█▄   ▌  ▒   ██▒▒▓█  ▄ ░██  █▀ ░▓▓█  ░██░▒▓█  ▄ ▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ 
▒██▒   ░██▒▒██▒ ░  ░   ░██░  ▒██▒ ░ ░▒████▒▒██▒   ░██▒   ▒██████▒▒░▒████▒░▒████▒░▒████▓ ▒██████▒▒░▒████▒░▒███▒█▄ ▒▒█████▓ ░▒████▒▒██░   ▓██░▒ ▓███▀ ░░▒████▒
░ ▒░   ░  ░▒▓▒░ ░  ░   ░▓    ▒ ░░   ░░ ▒░ ░░ ▒░   ░  ░   ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒░ ░ ▒▒▓  ▒ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒▒░ ▒ ░▒▓▒ ▒ ▒ ░░ ▒░ ░░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░
░  ░      ░░▒ ░         ▒ ░    ░     ░ ░  ░░  ░      ░   ░ ░▒  ░ ░ ░ ░  ░ ░ ░  ░ ░ ▒  ▒ ░ ░▒  ░ ░ ░ ░  ░ ░ ▒░  ░ ░░▒░ ░ ░  ░ ░  ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░
░      ░   ░░           ▒ ░  ░         ░   ░      ░      ░  ░  ░     ░      ░    ░ ░  ░ ░  ░  ░     ░      ░   ░  ░░░ ░ ░    ░      ░   ░ ░ ░           ░   
       ░                ░              ░  ░       ░            ░     ░  ░   ░  ░   ░          ░     ░  ░    ░       ░        ░  ░         ░ ░ ░         ░  ░
                                                                                 ░                                                          ░               

]]--


global s_mpSeedSequenceKeyTable:table = nil;

function GetGeneralMPItemGameVariantSeedSequenceKeyArgs():table 
	if (s_mpSeedSequenceKeyTable == nil) then
		local seqTable:table = {};

		seqTable['GeneralPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "GeneralPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['WeaponRackPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "WeaponRackPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['WeaponTrunkPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "WeaponTrunkPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['PowerWeaponPadPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "PowerWeaponPadPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['GrenadePadPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "GrenadePadPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['EquipmentPadPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "EquipmentPadPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['PowerUpPadPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "PowerUpPadPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['OrdnancePodPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "OrdnancePodPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['VehiclePadPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "VehiclePadPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};

		seqTable['VehicleDropPlacementKey'] = hmake MPItemGameVariantSeedSequenceKeyArgs
		{
			instanceName = "VehicleDropPlacementKey",
			seed = "{RANDOM}",
			roundReset = true,
		};
			
		s_mpSeedSequenceKeyTable = seqTable;
	end

	return s_mpSeedSequenceKeyTable;
end

