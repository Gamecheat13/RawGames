
--## SERVER

global PersistenceInterface = {


};

-- General Methods
--===============================================
function PersistenceInterface.GetLowestByteValue(persistentKeyList:table):number
	local lowest:number = nil;
	for _,key in hpairs(persistentKeyList) do
		local keyValue = Persistence_GetByteKey(key);
		if (not lowest) then
			lowest = keyValue;
		elseif (lowest > keyValue) then
			lowest = keyValue;
		end
	end

	return lowest;
end

function PersistenceInterface.GetLowestLongValue(persistentKeyList:table):number
	local lowest:number = nil;
	for _,key in hpairs(persistentKeyList) do
		local keyValue = Persistence_GetLongKey(key);
		if (not lowest) then
			lowest = keyValue;
		elseif (lowest > keyValue) then
			lowest = keyValue;
		end
	end

	return lowest;
end

function PersistenceInterface.GetHighestByteValue(persistentKeyList:table):number
	local highest:number = nil;
	for _,key in hpairs(persistentKeyList) do
		local keyValue = Persistence_GetByteKey(key);
		if (not highest) then
			highest = keyValue;
		elseif (highest < keyValue) then
			highest = keyValue;
		end
	end

	return highest;
end

function PersistenceInterface.GetHighestLongValue(persistentKeyList:table):number
	local highest:number = nil;
	for _,key in hpairs(persistentKeyList) do
		local keyValue = Persistence_GetLongKey(key);
		if (not highest) then
			highest = keyValue;
		elseif (highest < keyValue) then
			highest = keyValue;
		end
	end

	return highest;
end

function PersistenceInterface.GetTrueCount(persistentKeyList:table):number
	local trueCount:number = 0;
	for _,key in hpairs(persistentKeyList) do
		local keyValue = Persistence_GetBoolKey(key);
		if (keyValue == true) then
			trueCount = trueCount + 1;
		end
	end

	return trueCount;
end

function PersistenceInterface.ResetAllKeys()
	local boolKeys:table = {};
	local boolValues:table = {};

	local byteKeys:table = {};
	local byteValues:table = {};

	local longKeys:table = {};
	local longValues:table = {};
	for _,entry in hpairs(PersistenceKeys) do
		local name = entry.name;
		local type = entry.type;
		local key = Persistence_TryCreateKeyFromString(name);
		if type == PERSISTENCE_KEY_TYPE.Bool then
			table.insert(boolKeys, key);
			table.insert(boolValues, false);
		elseif type == PERSISTENCE_KEY_TYPE.Byte then
			table.insert(byteKeys, key);
			table.insert(byteValues, 0);
		elseif type == PERSISTENCE_KEY_TYPE.Long then
			table.insert(longKeys, key);
			table.insert(longValues, 0);
		end
	end
	Persistence_BatchSetBoolKeys(boolKeys, boolValues);
	
	Persistence_BatchSetByteKeys(byteKeys, byteValues);
	
	Persistence_BatchSetLongKeys(longKeys, longValues);
end

-- Refinery Base POI
--===============================================

PersistenceInterface.Refinery = table.makePermanent({});
function PersistenceInterface.Refinery.GetAllPoiKeyNames():table
	return {
		Persistence_TryCreateKeyFromString("poi_base_ref_green"),
		Persistence_TryCreateKeyFromString("poi_base_ref_yellow"),
	};
end

-- Ever activated any Control Room console at a Refinery
function PersistenceInterface.Refinery.HasActivatedControlRoomConsole():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_control_room_console_activated"));
end

function PersistenceInterface.Refinery.SetHasActivatedControlRoomConsole():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_control_room_console_activated"), true);
end

-- Ever learned about the purpose of an extractor at a Refinery
function PersistenceInterface.Refinery.HasSeenExtractor():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_extractor_seen"));
end

function PersistenceInterface.Refinery.SetHasSeenExtractor():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_extractor_seen"), true);
end

-- Ever activated an extractor console at a Refinery
function PersistenceInterface.Refinery.HasActivatedExtractorConsole():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_extractor_console_activated"));
end

function PersistenceInterface.Refinery.SetHasActivatedExtractorConsole():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_extractor_console_activated"), true);
end

-- Ever destroyed a pylon at a Refinery
function PersistenceInterface.Refinery.HasDestroyedPylon():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_destroyed_pylon_any_base"));
end

function PersistenceInterface.Refinery.SetHasDestroyedPylon():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_destroyed_pylon_any_base"), true);
end

-- Ever destroyed all pylons of an extractor at a Refinery
function PersistenceInterface.Refinery.HasDestroyedAllPylons():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_destroyed_all_plyons_any_base"));
end

function PersistenceInterface.Refinery.SetHasDestroyedAllPylons():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_destroyed_all_plyons_any_base"), true);
end

-- Ever seen pylon venting reset at a Refinery
function PersistenceInterface.Refinery.HasSeenPylonsReset():boolean
	return Persistence_GetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_venting_reset"));
end

function PersistenceInterface.Refinery.SetHasSeenPylonsReset():void
	Persistence_SetBoolKey(Persistence_TryCreateKeyFromString("nar_ref_venting_reset"), true);
end


-- Prison Base POI
--===============================================

--0 not active/discovered, 2 is active, 9 is completed.
PersistenceInterface.Prison = table.makePermanent({});
function PersistenceInterface.Prison.GetAllPoiKeyNames():table
	return {
		Persistence_TryCreateKeyFromString("poi_green_prison"),
		Persistence_TryCreateKeyFromString("pris_investigate"),
		Persistence_TryCreateKeyFromString("pris_enter_prison"),
		Persistence_TryCreateKeyFromString("pris_end_lockdown"),
		Persistence_TryCreateKeyFromString("pris_end_lockdown_hidden"),
		Persistence_TryCreateKeyFromString("pris_power_gravlift"),
		Persistence_TryCreateKeyFromString("pris_loc_sensor"),
		Persistence_TryCreateKeyFromString("pris_rescue_spartan"),
		Persistence_TryCreateKeyFromString("pris_defeat_chak_lok"),
		Persistence_TryCreateKeyFromString("pris_release_spartan"),
		Persistence_TryCreateKeyFromString("prison_bridge"),
	};
end

-- Reset all prison persistence
function PersistenceInterface.Prison.ResetPersistence():void
	local keys:table = PersistenceInterface.Prison.GetAllPoiKeyNames();

	for _, key in hpairs(keys) do
		Persistence_SetByteKey(key, missionStateEnum.undiscovered);
	end
end

-- Lockdown State.  0 not active/discovered, 2 is active, 9 is completed. 
function PersistenceInterface.Prison.InLockdown():boolean
	local state:number = Persistence_GetByteKey(Persistence_TryCreateKeyFromString("pris_end_lockdown"))
	
	if state == missionStateEnum.intelReceived then 
		return true;
	else
		return false;
	end
end

-- Lockdown State.  0 not active/discovered, 2 is active, 9 is completed. 
function PersistenceInterface.Prison.GravliftOpen():boolean
	local state:number = Persistence_GetByteKey(Persistence_TryCreateKeyFromString("pris_power_gravlift"))
	
	if state == missionStateEnum.intelReceived then 
		return true;
	else
		return false;
	end
end

-- Released Spartan State.  0 not active/discovered, 2 is active, 9 is completed. 
function PersistenceInterface.Prison.SpartanReleased():boolean
	return IsMissionCompleted(Persistence_TryCreateKeyFromString("pris_release_spartan"));
end

-- Dead Spartan POIs
--===============================================

PersistenceInterface.DeadSpartans = table.makePermanent({});
function PersistenceInterface.DeadSpartans.GetAllPoiKeyNames():table
	return {
		Persistence_TryCreateKeyFromString("schematic_wall"),
		Persistence_TryCreateKeyFromString("Schematic-Stim"),
		Persistence_TryCreateKeyFromString("Schematic-Knockback"),
		Persistence_TryCreateKeyFromString("Schematic-Camo"),
		Persistence_TryCreateKeyFromString("schematic_sensor"),
		Persistence_TryCreateKeyFromString("schematic_evade"),
	};
end
