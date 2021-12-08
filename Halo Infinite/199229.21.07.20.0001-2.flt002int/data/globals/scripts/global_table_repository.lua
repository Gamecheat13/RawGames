
--## SERVER
global TableRepository = {};

--## CLIENT
global TableRepository = {};


--## COMMON

TableRepository = {
	registeredTables = nil,
	tableOwners = nil,

	-- -- -- -- -- -- -- --
	showDebugPrint = false,
	-- -- -- -- -- -- -- --
};

function TableRepository.DebugPrint(...):void
	if (TableRepository.showDebugPrint) then
		print(...);
	end
end

function TableRepository.GetRegisteredTables():table
	TableRepository.registeredTables = TableRepository.registeredTables or {};
	return TableRepository.registeredTables;
end

function TableRepository.GetTableOwners():table
	TableRepository.tableOwners = TableRepository.tableOwners or {};
	return TableRepository.tableOwners;
end

-- alias - String key to use for accessing the table after registration
-- table - Reference to the table to register
-- owner - (OPTIONAL) Reference to the object that is attempting to register table
function TableRepository.RegisterTable(alias:string, table:table, owner:any):table
	assert(alias ~= nil, "ERROR : Cannot use nil as key!");

	local tables = TableRepository.GetRegisteredTables();
	local owners = TableRepository.GetTableOwners();

	if (tables[alias]) then
		TableRepository.DebugPrint("WARNING : TableRepository.RegisterTable() - Attempting to register a table to alias", alias, "which is already in use.  STOMPING THE PREVIOUS TABLE AT", alias);
	end

	tables[alias] = table;
	owners[alias] = owner;

	return tables[alias];
end

-- alias - String key to use for the table to unregister
-- owner - (OPTIONAL) Reference to the object that is attempting to unregister the table stored at alias
function TableRepository.UnregisterTable(alias:string, owner:any):void
	assert(alias ~= nil, "ERROR : Cannot use nil as key!");

	if (TableRepository.registeredTables) then
		
		if (TableRepository.tableOwners and TableRepository.tableOwners[alias]) then
			if (owner and (TableRepository.tableOwners[alias] ~= owner)) then
				TableRepository.DebugPrint("WARNING : TableRepository.UnregisterTable() - Unregister a table at alias", alias, "which is currently registered to another owner.  - Current owner:", TableRepository.tableOwners[alias], "- Unregistering owner:", owner);
			end
			TableRepository.tableOwners[alias] = nil;
		end

		TableRepository.registeredTables[alias] = nil;
	end
end

-- alias - String key to use for accessing the registered table
function TableRepository.GetTable(alias:string):table
	assert(alias ~= nil, "ERROR : Cannot use nil as key!");

	return TableRepository.GetRegisteredTables()[alias];
end

-- alias - String key to use for the table to get or register
-- owner - (OPTIONAL) Reference to the object that is attempting to get or register the table stored at alias
function TableRepository.GetOrRegisterTable(alias:string, owner:any):table
	assert(alias ~= nil, "ERROR : Cannot use nil as key!");

	local table = TableRepository.GetTable(alias);

	if (not table) then
		table = TableRepository.RegisterTable(alias, {}, owner);
	end

	return table;
end
