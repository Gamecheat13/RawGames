-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

--------------------------------------------------------------------------------
-- PersistenceKeyToType
-- Temporary lua solution, this can be removed once the C++ binding is live
global PersistenceKeyToType:table = table.makePermanent
{
	map = nil
};

function PersistenceKeyToType:New():table

	if(not _G.PersistenceKeys) then
		return {};
	end

	local newPersistenceKeyToType:table = {};
	setmetatable(newPersistenceKeyToType, {__index = self});
	newPersistenceKeyToType.permanentTableFlag = false;

	newPersistenceKeyToType.map = {};
	for _,entry in hpairs(_G.PersistenceKeys) do
		if (not entry.deprecated) then
			local key:persistence_key = PERSISTENCE_KEY(entry.name);
			local type:persistence_key_type = entry.type;

			newPersistenceKeyToType.map[key] = type;
		end
	end

	return newPersistenceKeyToType;
end

function PersistenceKeyToType:GetType(key:persistence_key):persistence_key_type
	return self.map[key];
end

--------------------------------------------------------------------------------
-- PersistenceSnapshot
global PersistenceSnapshot:table = table.makePermanent
{
	state = nil
};

function PersistenceSnapshot:New():table

	local newPersistenceSnapshot:table = {};
	setmetatable(newPersistenceSnapshot, {__index = self});
	newPersistenceSnapshot.permanentTableFlag = false;

	newPersistenceSnapshot.state = {};

	return newPersistenceSnapshot;
end

function PersistenceSnapshot:Compose(state:table):table
	if(not state)then
		print("PersistenceSnapshot:Compose Invalid table given to compose");
		return self;
	end

	-- Aggregate the passed state table into the current state table
	for _, entry in hpairs(state) do
		self.state[entry.key] = entry.value;
	end

	return self;
end

function PersistenceSnapshot:Apply():void
	local boolKeys:table = {};
	local boolValues:table = {};

	local byteKeys:table = {};
	local byteValues:table = {};

	local longKeys:table = {};
	local longValues:table = {};

	-- Apply this state to the game
	for key, value in hpairs(self.state) do
		local type:persistence_key_type = Persistence_GetKeyType(key);

		if (type == PERSISTENCE_KEY_TYPE.Bool) then
			table.insert(boolKeys, key);
			table.insert(boolValues, value);
		elseif (type == PERSISTENCE_KEY_TYPE.Short or type == PERSISTENCE_KEY_TYPE.Byte) then
			table.insert(byteKeys, key);
			table.insert(byteValues, value);
		elseif (type == PERSISTENCE_KEY_TYPE.Long) then
			table.insert(longKeys, key);
			table.insert(longValues, value);
		else
			print("PersistenceSnapshot: Invalid type encountered while applying persistent state for key");
			print(key);
		end
	end

	Persistence_BatchSetBoolKeys(boolKeys, boolValues);
	
	Persistence_BatchSetByteKeys(byteKeys, byteValues);
	
	Persistence_BatchSetLongKeys(longKeys, longValues);
	
end

function PersistenceSnapshot:ApplyForParticipant(targetPlayer:player):void
	
	local boolKeys:table = {};
	local boolValues:table = {};

	local byteKeys:table = {};
	local byteValues:table = {};

	local longKeys:table = {};
	local longValues:table = {};

	-- Apply this state to the game
	for key, value in hpairs(self.state) do
		local type:persistence_key_type = Persistence_GetKeyType(key);

		if (type == PERSISTENCE_KEY_TYPE.Bool) then
			table.insert(boolKeys, key);
			table.insert(boolValues, value);
		elseif (type == PERSISTENCE_KEY_TYPE.Short or type == PERSISTENCE_KEY_TYPE.Byte) then
			table.insert(byteKeys, key);
			table.insert(byteValues, value);
		elseif (type == PERSISTENCE_KEY_TYPE.Long) then
			table.insert(longKeys, key);
			table.insert(longValues, value);
		else
			print("PersistenceSnapshot: Invalid type encountered while applying persistent state for key");
			print(key);
		end
	end

	Persistence_BatchSetBoolKeysForParticipant(targetPlayer, boolKeys, boolValues);
	
	Persistence_BatchSetByteKeysForParticipant(targetPlayer, byteKeys, byteValues);
	
	Persistence_BatchSetLongKeysForParticipant(targetPlayer, longKeys, longValues);
end

--------------------------------------------------------------------------------
-- Global Functions

-- Allows the composition of multiple tables before their application
function PersistenceSnapshot_ComposeTable(
		compositionTableName:string, 
		snapshotTableName:string
	):void

	if(_G[compositionTableName] == nil) then
		_G[compositionTableName] = PersistenceSnapshot:New();
	end

	if(not _G[snapshotTableName])then
		print("PersistenceSnapshot_ComposeTable Invalid table " .. snapshotTableName .. " given to compose");
		return;
	end

	_G[compositionTableName]:Compose(_G[snapshotTableName]);
end

-- Applies the composed tables stored in the given global table
function PersistenceSnapshot_ApplyComposedTables(
		compositionTableName:string,
		clearComposedTable:boolean
	):void

	if(_G[compositionTableName] == nil) then
		print("PersistenceSnapshot_ApplyComposedTables: Invalid compositionTableName " .. compositionTableName);
		return;
	end
	
	_G[compositionTableName]:Apply();

	if(clearComposedTable) then
		_G[compositionTableName] = nil;
	end
end

function PersistenceSnapshot_ApplyComposedTablesForParticipant(
		targetPlayer:player, 
		compositionTableName:string, 
		clearComposedTable:boolean
	):void

	if(_G[compositionTableName] == nil) then
		print("PersistenceSnapshot_ApplyComposedTablesForParticipant: Invalid compositionTableName " .. compositionTableName);
		return;
	end

	_G[compositionTableName]:ApplyForParticipant(targetPlayer);

	if(clearComposedTable) then
		_G[compositionTableName] = nil;
	end
end

function PersistenceSnapshot_GetTable(snapshotTable):table
	local snapshot = {};
	local snapshotTableName = nil;
	if type(snapshotTable) == "string" then
		snapshot = PersistenceSnapshot_LoadTable(snapshotTable);
		snapshotTableName = snapshotTable;
	elseif type(snapshotTable) == "table" then
		snapshot = snapshotTable;
	end
	return snapshot, snapshotTableName;
end

function UnregisterMissionManager():void
	local missionManager = _G["g_currentMissionManager"];
	local missionsArray = _G["orderOfMissionsArray"];
	if missionManager ~= nil then
		for _, missionName in ipairs(missionsArray) do
			ParcelUnregisterEvent(missionManager, g_eventTypes.playerShortStateChanged, missionManager.OnPoiKeyUpdated, missionName);
		end
		SleepOneFrame();
	end
end

function RegisterMissionManager():void
	local missionManager = _G["g_currentMissionManager"];
	local missionsArray = _G["orderOfMissionsArray"];
	if missionManager ~= nil then
		SleepOneFrame();
		for _, missionName in ipairs(missionsArray) do
			missionManager:RegisterEventOnSelf(g_eventTypes.playerShortStateChanged, missionManager.OnPoiKeyUpdated, missionName);
		end
	end
end

function PersistenceSnapshot_ThreadApplyTable(snapshotTable:table):void
	UnregisterMissionManager();

	PersistenceSnapshot:New():Compose(snapshotTable):Apply();

	RegisterMissionManager();
end

function PersistenceSnapshot_ThreadApplyTableForParticipant(targetPlayer:player, snapshotTable:table):void
	UnregisterMissionManager();

	PersistenceSnapshot:New():Compose(snapshotTable):ApplyForParticipant(targetPlayer);

	RegisterMissionManager();
end


function PersistenceSnapshot_ThreadLoadAndApplyTable(targetPlayer:player, snapshotTable)
	local snapshotTableName = nil;
	if targetPlayer == nil then
		local toApply, tableName = PersistenceSnapshot_GetTable(snapshotTable);
		snapshotTableName = tableName;
		PersistenceSnapshot_ThreadApplyTable(toApply);
	else
		local toApply, tableName = PersistenceSnapshot_GetTable(snapshotTable);
		snapshotTableName = tableName;
		PersistenceSnapshot_ThreadApplyTableForParticipant(targetPlayer, toApply);
	end

	-- Clear the table from globals so it can be unloaded now that it's applied.
	-- If we don't do this these snapshots will consume a lot of lua memory and likely cause us to oom.
	if snapshotTableName ~= nil then
		_G[snapshotTableName] = nil;
		collectgarbage("collect");
	end
end

-- Applies the given table immediately
function PersistenceSnapshot_ApplyTable(snapshotTable):void
	CreateThread(PersistenceSnapshot_ThreadLoadAndApplyTable, nil, snapshotTable);
end

function PersistenceSnapshot_ApplyTableForParticipant(targetPlayer:player, snapshotTable):void
	CreateThread(PersistenceSnapshot_ThreadLoadAndApplyTable, targetPlayer, snapshotTable);
end
