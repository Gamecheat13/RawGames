-- Copyright (c) Microsoft. All rights reserved.

--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--
-- table
--
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

-- This is a bit hacky way to load global default tags.
-- We may be able to add some specialized engine code to make sure these tags are included later on.
global g_globalDefaultTags = 
{
	TAG('GlobalDefaults\globalDefault.sound'),
	TAG('GlobalDefaults\globalDefault.Conversation')
}

-- =================================================================================================
-- TABLE POINTERS
-- =================================================================================================
global TablePointer =
{
	Get = nil;
};

function TablePointer:New(argTable:table):table
	local newPointer = {};
	newPointer.Get = [|argTable];
	return newPointer;
end

function TablePointer:IsValid():boolean
	return self.Get ~= nil;
end

function TablePointer:Set(argTable:table):void
	self:Invalidate();
	self.Get = [|argTable];
end

function TablePointer:Invalidate():void
	self.Get = nil;
end


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table:copy
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === table.copy: allows a table's values to be copied into a new table, replicating the metatable structure
--		deep [optional; true] - true = deep copy all the sub tables as well; false = only copy the initial level, setting values by reference
--		target [optional; {}] - optional target table to copy to. This will stomp values in the the target table with values from the copy one
-- RETURN: target table
-- Example: table2 = table.copy(table1);
function table.copy(tab:table, deep:boolean, target:table):table

	function copyHelper(tab:table, target:table, map:table): table
		if (map[tab] ~= nil) then
			return map[tab];
		end

		map[tab] = target;

		-- store and remove metatable
		local mt = getmetatable( tab );
		setmetatable( tab, nil );

		for key, value in hpairs(tab) do
			dprint ("copying...", deep, key, value);
			if type(value) == "table" and deep then
				map[value] = copyHelper(value, target[key] or {}, map);
				value = map[value];
			end

			target[key] = value;
		end

		-- restore metatable on tab and set on target
		setmetatable( tab, mt );
		setmetatable( target, mt );

		return target;
	end

	deep = param_default(deep, true);
	return copyHelper(tab, target or {}, {});
end

-- === table.simpleCopy: makes a new table from a shallow, no-metatable copy of the source table; returns the new table
-- RETURN: new table containing all of the [key, value] pairs returned by iterating hpairs(sourceTable)
-- Example: table2 = table.simpleCopy(table1);

function table.simpleCopy(sourceTable:table):table
	local returnTable:table = {};
	if (sourceTable ~= nil) then
		for k, v in hpairs(sourceTable) do
			returnTable[k] = v;
		end
	end

	return returnTable;
end

-- === table.simpleDeepCopy: makes a new table from a deep, no-metatable copy of the source table; child tables are copied recursively
--		the goal of this is to return a facsimile of the source table, with no "ref" links back to the original table or any of its elements or metatables.
-- RETURN: new table containing all of the [key, value] pairs returned by recursively iterating hpairs on the sourceTable and child tables
-- Example: table2 = table.simpleDeepCopy(table1);

function table.simpleDeepCopy(sourceTable:table):table
	local returnTable:table = {};
	if (sourceTable ~= nil) then
		for k, v in hpairs(sourceTable) do
			if (type(v) == "table") then
				returnTable[k] = table.simpleDeepCopy(v);
			else
				returnTable[k] = v;
			end
		end
	end

	return returnTable;
end

-- === table.simpleDeepCopyWithHstructs: makes a new table from a deep, no-metatable copy of the source table OR hstruct; child tables and hstructs are copied recursively
--		the goal of this is to return a facsimile of the source table/hstruct, with no "ref" links back to the original table/hstruct or any of its elements or metatables.
--		note that hstructs will be instantiated anew and copied field-by-field in order to achieve this behavior.
-- RETURN: new table/hstruct matching the type of src containing all of the [key, value] pairs returned by recursively iterating hpairs on src and child tables/hstructs
-- Example 1:  table2 = table.simpleDeepCopyWithHstructs(table1);
-- Example 2:  local hstructCopy:MyHstructType = table.simpleDeepCopyWithHstructs(instanceOfMyHstructType);

function table.simpleDeepCopyWithHstructs(src)
	assert (type(src) == "struct" or type(src) == "table");

	local returnVal = nil;

	-- If our src object is an hstruct, then we'll need to instantiate a local copy of it
	if (type(src) == "struct") then
		local structTypeName = struct.name(src);
		returnVal = struct.create(structTypeName);
	else -- table
		returnVal = {};
	end

	-- Perform the copy, recursing if necessary
	for key, value in hpairs(src) do
		if (type(value) == "struct" or type(value) == "table") then
			returnVal[key] = table.simpleDeepCopyWithHstructs(value);
		else
			returnVal[key] = value;
		end
	end

	return returnVal;
end

-- === table.simpleCopyToArray: returns all of the values in the supplied table as a new array; ordering of elements is non-deterministic
-- RETURN: an arbitrarily-ordered array containing the elements of the sourceTable
-- Example: newArray = table.simpleCopyToArray(table1);
-- NOTE: this function uses the "local index counter" method as it is far more performant than table.insert(t, v) and t[#t+1]=v

function table.simpleCopyToArray(sourceTable:table):table
	local returnArray:table = {};
	if (sourceTable ~= nil) then
		local idx:number = 1;
		for _, value in hpairs(sourceTable) do
			returnArray[idx] = value;
			idx = idx + 1;
		end
	end

	return returnArray;
end

-- === table.collapseSparseArray: accepts an (optionally) sparse array (i.e. a table whose keys are all positive, non-zero integers which are *optionally* contiguous)
-- RETURN: an array containing the elements of sourceTable, ordered by their key(:number) in the sourceTable
-- Example: newArray = table.collapseSparseArray(table1);
-- Suggested use case: compressing a sparse array with unknown nil keys into a contiguous output array, preserving integer-key-order
-- NOTE: this function uses the "local index counter" method as it is far more performant than table.insert(t, v) and t[#t+1]=v

function table.collapseSparseArray(sourceTable:table):table
	if sourceTable == nil then
		return {};
	end

	-- First determine the bounds of our iteration
	local minKey:number = math.huge;
	local maxKey:number = 0;
	for key, _ in hpairs(sourceTable) do
		minKey = math.min(minKey, key);
		maxKey = math.max(maxKey, key);
	end
	assert(minKey ~= math.huge and maxKey ~= 0 and minKey <= maxKey);

	-- Now iterate over our key range, inserting any values we encounter into our return array
	local returnArray:table = {};
	local idx:number = 1;

	for k = minKey, maxKey do
		local currentValue = sourceTable[k];
		if (currentValue ~= nil) then
			returnArray[idx] = currentValue;
			idx = idx + 1;
		end
	end

	return returnArray;
end

-- === table.reverseArray(array): allows an array to be reversed (useful in some recursions)
--		array - the array that is to be reversed
-- RETURN: reversed array
-- Example: table.reverseArray({"a", "b", "c"}) returns a table that looks like this: {"c", "b", "a"}
-- NOTE: leaving this untyped because the array could be a table or object_list
-- NOTE: this function is destructive to make it lightweight
function table.reverseArray(array)
	local k1, k2 = 1, #array;

	while k1 < k2 do
		array[k1], array[k2] = array[k2], array[k1];
		k1 = k1 + 1;
		k2 = k2 - 1;
	end
	return array;
end

-- === table.randomEntryInArray(array): selects a random entry in a table, or nil for edge cases
--		array - the table that a random entry will be selected from
-- RETURN: a random entry or nil
-- Example: table.randomEntryInArray({"correct","horse","battery","staple"}) will return one of the elements of the list
function table.randomEntryInArray(array:table)
	if array ~= nil then
		local count = #array;
		if count ~= 0 then
			return array[random_range(1, count)];
		end
	end
	return nil;
end

-- === table.getKeysAsArray(tab): returns all of the keys in the table as an array; order is non-deterministic.
--		tab - the table whose keys will constitute the returned array's elements
-- RETURN: an array containing all keys present in the input table, or an empty table if tab was nil
function table.getKeysAsArray(tab:table):table
	local returnArray:table = {};
	
	if (tab ~= nil) then
		for k, _ in hpairs(tab) do
			returnArray[#returnArray+1] = k;
		end
	end

	return returnArray;
end

-- === table.subArray(array, beginIdx, endIdx): returns a new array created from the subrange of elements specified; the input array is not modified
--		array - the input table from which elements will be selected (will not be modified)
--		beginIdx - the index of the first element that will be selected
--		endIdx - the index of the last element that will be selected
-- RETURN: a NON-sparse array created from the non-nil elements of 'array' keyed by the inclusive range [beginIdx, endIdx]
function table.subArray(array:table, beginIdx:number, endIdx:number):table
	if (array == nil or beginIdx == nil or endIdx == nil or beginIdx > endIdx) then
		return {};
	end

	local ret:table = {};
	for i = beginIdx, endIdx do
		local elem = array[i];
		if (elem ~= nil) then
			table.insert(ret, elem);
		end
	end

	return ret;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.dprint
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.dprint: dprints an entire table to the output window
--		deep [optional; true] - Will dprint the sub tables as well
--		indent_new [optional; "     "] - In a deep dprint it will append this much spacing for each sub table and it's children
--		indent_current [optional; ""] - Current indent spacing
--  Example: table:dprint(table1);
function table.dprint( tab, deep:boolean, indent_new:string, indent_current:string )
	sys_table_dprint( tab, deep, indent_new, indent_current, "" );
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.JSON
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.JSON: returns a JSON formatted string of the table contents
--  Example: table:JSON(table1);
function table.JSON( tab )
	return SysTableGetJSON( tab );
end

-- === table.append: appends the elements of the second array to first array; if either table is nil, no operations will be performed
--		tab1 	-- the array which will be modified with additional elements
--		tab2 	-- the array that will be appended to tab1
--  Example: table.append(tab1, tab2);
--	RETURNS: a reference to tab1 (which was modified in-place)
function table.append(tab1, tab2)
	if (tab1 ~= nil and tab2 ~= nil) then
		local index:number = #tab1 + 1;
		for _, val in ipairs(tab2) do
			tab1[index] = val;
			index = index + 1;
		end
	end

	return tab1;
end

-- === table.combine: returns a new array consisting of the concatenated elements of tab1, tab2
--		tab1	- the array whose values will appear first in the new array
--		tab2	- the array whose values will appear second in the new array
--  Example: table.combine(table1, table2);
--	This only works for tables that are 1 table deep and don't have metatables
--*leaving these untyped so that object_lists can be used
function table.combine(tab1, tab2)
	local tab3 ={};
	local index:number = 1;
	for _, val in ipairs(tab1) do
		tab3[index] = val
		index = index + 1;
	end
	for _, val in ipairs(tab2) do
		tab3[index] = val
		index = index + 1;
	end
	return tab3;
end

-- === table.combineUniqueValues: combines the values in two arrays into a new merged array, removing duplicate values (incl. duplicates within a single source array)
--		tab1	- the first array you want included in the merge
--		tab2	- the second array you want included in the merge
--  Example: table.combineUniqueValues(table1, table2);
--	This only works for tables that are 1 table deep and don't have metatables
--*leaving these untyped so that object_lists can be used
function table.combineUniqueValues(tab1, tab2):table
	local encounteredValues:table = {};

	local returnTable:table = {};
	for _, val in ipairs(tab1) do
		if (not encounteredValues[val]) then
			returnTable[#returnTable + 1] = val;
			encounteredValues[val] = true;
		end
	end
	for _, val in ipairs(tab2) do
		if (not encounteredValues[val]) then
			returnTable[#returnTable + 1] = val;
			encounteredValues[val] = true;
		end
	end
	return returnTable;
end

-- === table.merge: adds the second tables keys into a copy of the first tables and returns a table with the new keys/values
--		tab1	- the table you wanted added to
--		tab2	- the table you want to add to the first table
--		if tab1 has keys that are in tab2 it will overwrite them in the returned table (this is by design)
--	This only works for tables that are 1 table deep and don't have metatables
--		RETURNS - a table that is the product of the merging
--*leaving these untyped so that object_lists can be used
function table.merge(tab1, tab2)
	local tab3 = {};
	for k, val in hpairs(tab1) do
		tab3[k] = val;
	end
	for k, val in hpairs(tab2) do
		tab3[k] = val;
	end
	return tab3;
end

-- === table.merge_recursive: adds the second table's keys into a copy of the first table and returns a table with the new keys/values
--		default	- the table you wanted added to
--		override	- the table you want to add to the first table
--		if default has keys that are in override it will overwrite them in the returned table (this is by design)
--		RETURNS - a table that is the product of the merging
-- If the override has a metatable, it's assigned to the result
-- Otherwise, if the default has a metatable, it's assigned to the result
function table.merge_recursive(default, override):table

	if(default == nil) then
		return override;
	end

	if(override == nil) then
		return default;
	end

	local result = {};

	for key, value in hpairs(default) do
		if(type(value) == "table" and type(override[key]) == "table") then
			result[key] = table.merge_recursive(default[key], override[key]);
		else
			result[key] = value;
		end
	end

	for key, value in hpairs(override) do
		if(type(value) ~= "table" or result[key] == nil) then
			result[key] = value;
		end
	end

	if(getmetatable(override) ~= nil) then
		setmetatable(result, getmetatable(override));
	else
		setmetatable(result, getmetatable(default));
	end

	return result;
end

local s_metaTableCache = setmetatable({}, {__mode = "k"});

-- Sets parent as the metatable of child so keys not found in the child will be looked for in the parent.
-- This function caches the parent metatable so if you need to modify your metatable per instance don't use this.
function table.addCachedBaseClassMetatable(parent, child):table
	if parent == nil then
		return child;
	end

	child = child or {};
	if s_metaTableCache[parent] == nil then
		s_metaTableCache[parent] = {__index = parent};
	end
	return setmetatable(child, s_metaTableCache[parent]);
end

-- === table.addMetatable: points a table to a metatable which will give inheritance to the table (if the table doesn't have a key it will look in the metatable for it)
--		tab1						- the table you want to become a metatable (the parent)
--		tab2 [optional] - the table you want to add the metatable to (the child)
--		RETURNS - a table that has a metable applied
--  Example: myTab = table.addMetatable(yourTab);
--  Example: table.addMetatable(yourTab, myTab);
function table.addMetatable(parent, child):table
	if parent == nil then
		return child;
	end

	child = child or {};
	return setmetatable(child, {__index = parent});
end


--=== table.addMetatableRecursive: this will go through all the nested tables of the parent and apply metatables to the corresponding child tables
--		parent						- the table you want to become a metatable (the parent)
--		child [optional] - the table you want to add the metatable to (the child)
--		cacheParent [optional] - if we can cache the parent metatable instead of creating a new one. Use this unless you need to modify the metatable.
--		RETURNS - a table (with all its nested tables) that has the parent table as a metatable
function table.addMetatableRecursive(parent, child, cacheParent)
	child = child or {};

	--set the metatable on a table called "parentTable" so that there is always a clean version of the parent
	child.parentTable = {};
	if cacheParent then
		table.addCachedBaseClassMetatable(parent, child);
	else
		table.addMetatable(parent, child.parentTable);
	end
	--loop through the tables in the parent and create them on the child (and make a metatable of them linked to the parent table)
	--so that a table doesn't accidentally get created on the parent when attempting to access a nested table on the child
	local function LoopTables(parent, child)
		child = child or {};
		if cacheParent then
			table.addCachedBaseClassMetatable(parent, child);
		else
			table.addMetatable(parent, child);
		end
		for k,v in hpairs (parent) do
			if type(v) == 'table' then
				child[k] = LoopTables(v, rawget(child,k));
			end
		end
		return child;
	end

	child = LoopTables(parent, child);

	return child;
end


--=== table.makeTableReadOnly: makes a table that returns a print when a key is added to the table (the key won't be added to the table)
--		tab						- the table you want to make read only
--		RETURNS - the entered table table that returns a print when a key is added to the table
function table.makeTableReadOnly(tab):table
	local newMetaTable = getmetatable(tab) or {};

	newMetaTable.__newindex = function (t,k,v) assert(false, "ERROR: table is read only, (" .. tostring(k) .. ", " .. tostring(v) .. ") can't be added to this table") end;
	setmetatable(tab, newMetaTable);
	return tab;
end

--=== table.makeTableReadOnlyRecursive: this will go through all the nested tables of the parent and make them read only as well
--		tab		- the table you want to make read only
--		RETURNS - the entered table table that returns a print when a key is added to the table or nested table
function table.makeTableReadOnlyRecursive(tab):table
	local function LoopTables(loopTab)
		table.makeTableReadOnly(loopTab);
		for _,v in hpairs (loopTab) do
			if type(v) == 'table' then
				LoopTables (v);
			end
		end
	end
	LoopTables(tab);
	return tab;
end

local s_enumMetaTable =
{
	__index = function(t, k) assert(k == "__viz", "Cannot find " .. tostring(k)) end,
	__newindex = function(t, k, v) assert(false, "Cannot modify an enum") end,
	__metatable = false
};

--=== table.makeEnum: Creates a pseudo enum. Accessing uninitialized values or setting keys in the table will assert.
function table.makeEnum(tab):table
	return setmetatable(tab, s_enumMetaTable);
end

--=== table.makeAutoEnum: Creates a pseudo enum and auto fills in values.
--		Accessing uninitialized values or setting keys in the table will assert.
--		tab must be an array.
function table.makeAutoEnum(tab:table):table
	local newEnum:table = {};
	for index, name in ipairs(tab) do
		newEnum[name] = index;
	end
	newEnum.count = #tab;

	return setmetatable(newEnum, s_enumMetaTable);
end

--=== table.getEnumValueAsString: Takes in an integer value and returns the string key that
--		corresponds to that integer value in the supplied table.
--		Behavior is undefined if the supplied table is not an enum consisting strictly of string keys mapping to unique integer value entries
function table.getEnumValueAsString(tab:table, enumVal:number):string
	-- We can just forward to table.getUntypedEnumValueAsString since the logic is the same;
	-- we maintain separate functions in order to support parameter type validation
	return table.getUntypedEnumValueAsString(tab, enumVal);
end

--=== table.getUntypedEnumValueAsString: Takes in a value and returns the string key that
--		corresponds to the specified value in the supplied table.
--		Behavior is undefined if the supplied table is not an enum consisting strictly of string keys mapping to unique value entries
function table.getUntypedEnumValueAsString(tab:table, enumVal):string
	for k, v in hpairs(tab) do
		if v == enumVal and k ~= "count" then
			return k;
		end
	end

	dprint("ERROR: Nonexistent enum value supplied to table.getUntypedEnumValueAsString! returning nil for the string key.");
	return nil;
end

--=== table.anyVal: returns any value in a table; useful for retrieving
--		an arbitrary entry in a non-array table
--		RETURNS - any - any value contained in the passed in table; returns nil if the supplied table is nil or empty
function table.anyVal(tab)
	if (tab ~= nil) then
		for _, val in hpairs(tab) do
			return val;
		end
	end
	return nil;
end

--=== table.countKeys: this will count all the keys in a table
--		tab		= the table whose keys are counted
--		RETURNS - the number of keys in the table
-- NOTES:
--	Is not recursive. It only checks the top table, not any nested tables
--	use with caution: this could give unexpected results if used with true parcels or metatable enabled tables
--	unneccessary for object_lists, just use #
function table.countKeys(tab):number
	local keyCount = 0;
	for k, _ in hpairs(tab) do
		keyCount = keyCount + 1;
	end
	return keyCount;
end

--=== table.IsEmpty: returns whether the table has no keys
--		tab		= the table whose keys are checked
--		RETURNS - boolean - table has keys (or not)
-- NOTES:
--	Is not recursive. It only checks the top table, not any nested tables
function table.IsEmpty(tab):boolean
	--double check array and table
	return next(tab) == nil;
end

--=== table.makePermanent: this will make this table and all sub-tables read only and not saved in persist calls
--		tab		= the table to be made read only and permanent
function table.makePermanent(tab:table):table
	assert(tab ~= nil, "can't make a nil table permanent");

	--this is no longer necessary so returning the same table
	return tab;
end

--=== table.makeSubTable: implements similar behavior to ParcelParent(), returning an empty table with full nested table structure,
--							with metatables set recursively to supplied parentTable
function table.makeSubTable(parentTable:table):table
	local child:table = {};
	
	-- Loop through the tables in the parent and create them on the child (and make a metatable of them linking them to the corresponding tables in the parent table)
	local function LoopTables(parent, child)
		child = child or {};
		table.addMetatable(parent, child);
		for k,v in pairs(parent) do
			if type(v) == 'table' then
				child[k] = LoopTables(v, rawget(child, k));
			end
		end
		return child;
	end
	
	child = LoopTables(parentTable, child);
  
	return child;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.enabled
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.enabled: A generic system for using tables more like structures.  This creates an enabled flag (enabled by default) and checks _parent tabels
--						to make sure they are enabled as well.
--		t - table to check if it's enabled
--		val	- the value to assign to enabled; nil will just check the value
--  Example: table.enabled(t, true); - sets enabled to true
function table.enabled(t:table, val:boolean):boolean
	if (t ~= nil) then
		if (type(t.enabled) == "function") then
			val = t.enabled(val);
		elseif (val ~= nil) then
			t.enabled = val;
		else
			val = t.enabled;
		end
		return (val ~= false) and ((type(t._parent) ~= "table") or table.enabled(t._parent));
	end
	return false;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.contains
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.contains: checks whether a value is included in a table array and returns true if included, false if not
--		tab - table to check the value
--		val	- the value to check if it is included in the table
--  Example: table.contains (t_SpartansInVolume, SPARTAN.buck) -- checks to see if Buck is in the table "t_SpartansInVolume" and returns true if he is
function table.contains(tab:table, val):boolean
	for _, v in hpairs (tab) do
		if v == val then
			return true;
		end
	end
	return false;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.compare
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.compare: checks whether 2 tables contain the same values and returns true if they do, false if not
-- === NOTE - this function doesn't care about the order of the values in the table
--		tab1 - first table to compare
--		tab2 - second table to compare
--  Example: table.compare (t_SpartansInVolume1, t_SpartansInVolume2)
-- checks to see if the values of "t_SpartansInVolume1" match the values of "t_SpartansInVolume2" and returns true if they do
function table.compare(tab1:table, tab2:table):boolean
	local tab1temp = {};
	local tab2temp = {};

	if #tab1 ~= #tab2 then
		return false;
	end

	for _, v in hpairs(tab1) do
		tab1temp[v] = true;
	end

	for _, v in hpairs(tab2) do
		tab2temp[v] = true;
	end

	for i, _ in hpairs(tab1temp) do
		if not tab2temp[i] then
			--print (i);
			return false;
		end
	end

	return true;
end

-- === table.dif: checks whether 2 tables contain the same values and returns a table of items they do not have in common
-- === NOTE - this function doesn't care about the order of the values in the table
--		tab1 - first table to compare
--		tab2 - second table to compare
--  Example: table.dif ({OBJECTS.crate1, OBJECTS.crate2}, {OBJECTS.crate2, OBJECTS.crate3)
-- returns a table of the non-similar values of "t_SpartansInVolume1" and "t_SpartansInVolume2" which is {OBJECTS.crate1, OBJECTS.crate3}
function table.dif(tab1:table, tab2:table):table
	local tabgreatertemp = {};
	local tablessertemp = {};
	local tabgreater = {};
	local tablesser = {};
	local tabdif = {};

	--compare the sizes before making the temp tabs because we can't get the size of the tables when the keys aren't numerical
	if #tab1 >= #tab2 then
		tabgreatertemp = tab1;
		tablessertemp = tab2;
	else
		tabgreatertemp = tab2;
		tablessertemp = tab1;
	end

	--turn the arrays into tables with the values as keys and true as the values (ie. {AI.sq_example = true}
	for _,v in pairs (tabgreatertemp) do
		tabgreater[v] = true;
	end

	for _,v in pairs (tablessertemp) do
		tablesser[v] = true;
	end
	--table.dprint (tablesser);

	--compare all the keys in the larger table to the smaller table, add the non similar keys to the table tabdif and remove similar keys from the smaller table
	for i,_ in pairs (tabgreater) do
		--print (i);
		if not tablesser[i] then
			--print (i);
			tabdif[#tabdif + 1] = i;
		else
			tablesser[i] = nil;
		end

	end

	--add the remaining keys from tab lesser to tabdif
	for i,_ in pairs (tablesser) do
		tabdif[#tabdif + 1] = i;
	end

	return tabdif;
end


-- === table.removeValue: removes a value from an array and shifts down the rest
--		tab		- the table to remove the value
--		value	- the value to remove from the table
function table.removeValue(tab:table, val):table
	local count:number = #tab;
	local foundIdx:number = nil;
	-- Look for the first occurrence of the value
	for i = 1, count do
		if tab[i] == val then
			foundIdx = i;
			break;
		end
	end

	-- If it exists, remove it and then shift the remaining elements up one element
	if foundIdx ~= nil then
		for i = foundIdx, count do
			tab[i] = tab[i+1];
		end
	end

	return tab;
end

-- === table.removeValueByReplace: removes a value from an array, and swaps the last element into the vacated slot. Note that this is a much faster
--								   operation than table.removeValue's shift logic and should be used if element-ordering is irrelevant
--		tab:		-- the table to have the specified element removed from
--		value:		-- the value to remove from the table
--		RETURNS: a reference to the original table (which was modified in-place)
function table.removeValueByReplace(tab:table, removeVal):table
	if (tab == nil or removeVal == nil) then
		return tab;
	end

	local count:number = #tab;

	for i = 1, (count-1) do
		if (tab[i] == removeVal) then
			tab[i] = tab[count];
			tab[count] = nil;
			return tab;
		end
	end

	-- We can special-case for when the Nth elem is the one to remove and avoid an unnecessary tab[i]=tab[count] statement
	if (tab[count] == removeVal) then
		tab[count] = nil;
	end

	return tab;
end

-- === sortFunc_ByValue: a sorting function that simply compairs the values in the table for each given index
--		tab			- the table with the values to be sorted
--		indexA 		- the index into the table for the first entry to be compared
--		indexB 		- the index into the table for the second entry to be compared

function table.sortFunc_ByValue(tab:table, indexA, indexB):boolean
	return tab[indexB] < tab[indexA];
end

-- === spairs: returns an iterator function that traverses the values of the table in the order determined by the passed in function
--		tab			- the table to iterate over
--		orderFunc 	- Optional.   The function used to determine the order of the table
function table.spairs(tab, orderFunc)
	-- collect the keys
	local keys = {}
	for k, v in hpairs(tab) do
		keys[#keys+1] = k;
	end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if orderFunc then
		table.sort(keys, function(a,b) return orderFunc(tab, a, b) end);
	else
		table.sort(keys);
	end

	-- return the iterator function
	local i = 0;
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], tab[keys[i]]
		end
	end
end

-- === enum_pairs: returns an iterator function that traverses the enum values of an makeAutoEnum table in ascending order
--		tab			- the enum table to iterate over
function enum_pairs(tab:table)
	-- collect the enum and string values so they can be sorted
	local enumStrings:table = {}
	for s, e in hpairs(tab) do
		if type(s) == "string" and type(e) == "number" then
			if s ~= "count" then
				enumStrings[e] = s;
			end
		end
	end

	local i = 0;
	return function()
		i = i + 1
		return enumStrings[i], i;
	end
end

-- === shuffle: creates a random permutation of the given array in place
--		tab			- the table to shuffle
function table.shuffle(tab:table):table
	assert(tab ~= nil, "A nil table was supplied to table.shuffle!");

	return table.shuffleRange(tab, 1, #tab);
end

-- === shuffleRange: randomly shuffles the elements [firstIdx, lastIdx] of the given array in place
--		tab			- the table to shuffle
--		firstIdx 	- the first index of the range to be shuffled
-- 		lastIdx		- the last index of the range to be shuffled
function table.shuffleRange(tab:table, firstIdx:number, lastIdx:number):table
	assert(tab ~= nil and firstIdx ~= nil and lastIdx ~= nil, "A nil argument was supplied to table.shuffleRange!");
	assert(firstIdx <= lastIdx, "The firstIdx arg was greater than the lastIdx arg to table.shuffleRange!");

	-- Passing a range of [n, n] is allowed, but we don't need to shuffle in that case
	if (firstIdx ~= lastIdx) then
		for i = lastIdx, firstIdx, -1 do
			local rand:number = math.random(firstIdx, i); -- random number in the range [firstIdx, i]
			if (rand ~= i) then
				tab[i], tab[rand] = tab[rand], tab[i];
			end
		end
	end

	return tab;
end

-- === firstindex: returns the first value in the table that predicate returns true for.
--		table		- the table to shuffle
--		predicate	- the function to check against
function table.firstindex(table, predicate:any)
	for index, value in hpairs(table) do
		if predicate == nil or predicate(value) then
			return index, value
		end
	end

	return nil;
end

-- === filtervalues: returns a subset of the table with every entry that predicate returns true for.
--		table		- the table to filter
--		predicate	- the function to check against
function table.filtervalues(table, predicate:any):table
	local output = { };
 
	for key, value in hpairs(table) do
		if predicate(value) then
			output[#output + 1] = value;
		end
	end
 
	return output;
end

-- === filternil: takes a table, and returns a table with all the nil values removed.
--		table		- the table to filter
function table.filternil(tab: table):table
	return table.filtervalues(tab, [(v)| v ~= nil]);
end

-- === count: returns the number of entries in the table that predicate returns true for.
--		table		- the table to filter
--		predicate	- the function to check against.  If nil, we will return the total number of entries in the table (covers dictionary-style and array-style indices).
function table.count(table, predicate:any)
	local result = 0;

	for _, value in hpairs(table) do
		if (predicate == nil) or predicate(value) then
			result = result + 1;
		end
	end

	return result;
end

-- === table.mergevalues: iterates through all tables passed to it and adds them to one table.
--		...		- this function takes an unlimited number of tables as arguments, and merges them together.
--		RETURNS - a table that is the product of the merging
--		EXAMPLE:
--        local one = { "a", "b" };
--        local two = { "c", "d" };
--        local three = { "e", "f" };
--        table.dprint(table.mergevalues(one, two, three)); -- returns { "a", "b", "c", "d", "e", "f" };
function table.mergevalues(...):table
	local output = {};
	for _, input in ipairs(arg) do
		for _, v in ipairs(input) do
			table.insert(output, v)
		end
	end
	return output
end

-- === table.mapvalues: iterates through a table and applies a function to each value in it
--		tab	- a table you want to map through
--		callable - the function you want to apply
--		RETURNS - a table that is the result of all the applied functions
--*table is untyped because object lists are a thing, and callable is untyped because ifunction prevents using cfunctions and callable tables
function table.mapvalues(tab, callable):table
	local output = {};
	for _, v in ipairs(tab) do
		table.insert(output, callable(v))
	end
	return output;
end

-- === table.flatmapvalues: iterates through a table, and applies a function to each value in it, consolodating all the lists returned into one
--		tab	- a table you want to map through
--		callable - the function you want to apply
--		RETURNS - a table that is the merged result of all the applied functions
--*table is untyped because object lists are a thing, and callable is untyped because ifunction prevents using cfunctions and callable tables
function table.flatmapvalues(tab, callable):table
	return table.mergevalues(unpack(table.mapvalues(tab, callable)))
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM FUNCTIONS; GENERALLY YOU SHOULD IGNORE THESE
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- system function that manages the dprint
function sys_table_dprint(tab, deep:boolean, indent_new:string, indent_current:string, indent_old:string)
	if tab == nil then
		print("table is nil");
		return;
	end

	if deep == nil then
		deep = true;					
	end										-- DEFAULTS
	indent_new = indent_new or "     ";		-- DEFAULTS
	indent_current = indent_current or "";	-- DEFAULTS

	-- indent
	indent_old = indent_current;

	-- loop through and dprint
	print(indent_old, "{" );
	for key, value in hpairs(tab) do
		if ( (not deep) or (type(value) ~= 'table') ) then
			print(indent_current, indent_new, key, " = ", value, ",");
		else
			print(indent_current, indent_new, key, " = ");
			sys_table_dprint( value, deep, indent_new, indent_current .. indent_new, indent_old );
		end

	end
	print(indent_old, "}");
end

global escapeCharMap:table = table.makePermanent
{
	['\b'] = "\\b",
	['\f'] = "\\f",
	['\r'] = "\\r",
	['\n'] = "\\n",
	['\t'] = "\\t",
	['\"'] = "\\\"",
	['\\'] = "\\\\"
};

function escapeChar( char:string ):string
	local mappedChar:string = escapeCharMap[char];
	if (mappedChar) then
		return mappedChar;
	end

	local charIndex:number = char:byte();
	if (charIndex <= 31) then
		return string.format("\\u%04x", charIndex);
	end

	return char;
end

function encodeString ( str:string ):string
	return '"' .. str:gsub(".", escapeChar) .. '"';
end

function SysGetJSON( value ):string
	local newValue:string;
	local longMax:number  =  9223372036854775807;
	local ulongMax:number = 36893488147419103231;
	if (type(value) == 'number') then
		-- Set inf/-inf and NaN to null
		if (value == math.huge or value == -math.huge or value ~= value) then
			newValue = "null";
		else
			if (math.fmod(value,1) ~= 0) then
				-- real number
				newValue = string.format("%.9g",value);
			else
				-- whole
				if (value > longMax and value <= ulongMax) then
					newValue = Telemetry_ConvertPointersForJSON(value);
				else
					newValue = string.format("%.0f",value);
				end
			end
		end
	elseif (type(value) == 'boolean') then
		newValue = tostring(value);
	elseif (type(value) == 'nil') then
		newValue = "null";
	elseif (type(value)) == "userdata" then
		newValue = Telemetry_ConvertPointersForJSON(value);
	elseif (type(value)) == "luserdata" then
		newValue = Telemetry_ConvertPointersForJSON(value);
	elseif (type(value)) == "ui64" then
		newValue = Telemetry_ConvertPointersForJSON(value);
	else -- includes strings
		newValue = encodeString(tostring(value));
	end

	return newValue;
end

-- system function that manages the json formatting
function SysTableGetJSON( tab:table, deep:boolean, indentNew:string, indentCurrent:string, indentOld:string ):string

	deep = param_default( deep, true );						-- DEFAULT
	indentNew = param_default( indentNew, "  " );			-- DEFAULT
	indentCurrent = param_default( indentCurrent, "" );		-- DEFAULT

	local myResult = {};

	-- indent
	indentOld = indentCurrent;

	local terminator:string = "]";
	local initiator:string = "[";
	local isArray:boolean = true;
	local rowCount:number = 0;
	-- Determine if this is an array
	-- This will fall back to dictionary if the array is sparse.
	for key, value in table.spairs(tab) do
		rowCount = rowCount + 1;
		if ( rowCount ~= key ) then
			isArray = false;
			initiator = "{";
			terminator = "}";
			break;
		end
	end

	table.insert(myResult, initiator);
	table.insert(myResult, "\n");


	-- for json, we probably want sorted
	for key, value in table.spairs(tab) do

		local newKey:string = encodeString(tostring(key));
		local newValue:string;

		if ((not deep) or (type(value) ~= 'table' and type(value) ~= 'struct')) then
			newValue = SysGetJSON ( value );
		else
			newValue = SysTableGetJSON( (type(value) == 'struct' and struct.totable(value) or value), deep, indentNew, indentCurrent .. indentNew, indentOld );
		end

		if ( isArray ) then
			table.insert(myResult, indentCurrent .. indentNew .. newValue);
		else
			table.insert(myResult, indentCurrent .. indentNew .. newKey .. ": " .. newValue);
		end
		table.insert(myResult, ",\n");

	end

	-- remove the final entry of the result table, which is the final comma and newline
	-- unless it was an empty table, which it would just be a newline
	table.remove(myResult);

	-- and then add back a carriage return
	table.insert(myResult, "\n" .. indentOld .. terminator);

	return table.concat(myResult);
end



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table:GetDescendant
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === table.GetDescendant: walks down a specified chain of container children and returns the value at the specified path
--		rootParent [<any container type>] - An instance of any container type (table, kit, parcel, etc) to start parsing through children and grandchildren
--		arg [list of strings] - A variable length list of string parameters that represent the path of descendants to parse through
-- RETURN ON SUCCESS (2 values): true, target value (any type)
-- RETURN ON FAILURE (2 values): false, string message describing the nature of the failure
-- Example: local myVal = table.GetDescendant(KITS.my_kit, "child_kit", "grandchild_kit", "great_grandchild_kit", "some_table", "foo");
--   Results in : return KITS.my_kit.components.child_kit.components.grandchild_kit.components.great_grandchild_kit.some_table.foo;
--   Reports error if at any point along the way, one of the dereferenced values is 'nil', and specifies exactly which one that is.
function table.GetDescendant(rootParent, ...)
	local current = rootParent;
	local assertString = "[rootParent]";
	
	-- Descend through the children of each container in the chain
	for _,descendant in ipairs(arg) do
		-- Error-checking
		--assert(current ~= nil, "Error: Attempting to dereference a nil value at " .. assertString);
		if (current ~= nil) then
			local status = pcall(function() local test = current.components; end);

		--assert(status, "Error: Attempting to dereference a non-container variable of type " .. GetEngineType(current) .. "(" .. type(current) .. ")");
			if (not status) then
				print("::: path: " .. assertString);
				return false, "Attempting to dereference a non-container variable of type " .. GetEngineType(current) .. "(" .. type(current) .. ")";
			end
		else
			return false, "Attempting to dereference a nil value at " .. assertString;
		end

		-- Always use a descendant directly attached to the current container if available
		if (current[descendant]) then
			current = current[descendant];
			assertString = assertString .. "." .. tostring(descendant);
		-- If not, and the current container is a kit, check its 'components' table for the next descendant
		elseif (GetEngineType(current) == "folder") then
			if (current.components) then
				current = current.components[descendant];
				assertString = assertString .. ".components." .. tostring(descendant);
			else
				current = nil;
				assertString = assertString .. ".(components.)" .. tostring(descendant);
			end
		-- It is valid for this function to return a nil leaf node
		else
			current = nil;
			assertString = assertString .. "." .. tostring(descendant);
		end	
	end
	
	return true, current;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table:makeWeakTagTable
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === table.makeWeakTagTable: creates a table of "weak" tags, which will behave as if unresolved until they are referenced. as soon as one
--							   is used anywhere, this table will attempt to convert it to a strong tag if it has been loaded into memory. this works 
--							   by overriding the index method of the table's metatable to do the conversions under the hood. if the tag had not been
--							   loaded, it will return as an invalid tag and an assert will occur
--		tab - An instance of the table to embue with this metatable capability
-- Example: local myWeakTable = table.makeWeakTagTable {
--				tagKey1	= WEAK_TAG('path\tag1'),
--				tagKey2 = WEAK_TAG('path\tag2'),
--			}

function table.makeWeakTagTable(tab:table):table
	-- Recursively run this function on all subtables first
	for _, v in hpairs(tab) do
		if (type(v) == "table") then
			-- no need to assign, we're passing a reference here
			table.makeWeakTagTable(v);
		end
	end

	local function weakTagConvert(t)
		if (t ~= nil and GetEngineType(t) == "weak_tag") then
			local strongTag:tag = Tag_TryResolveFromWeak(t);
			assert(strongTag ~= nil and IsValidTag(strongTag), "Failed to resolve a weak_tag which is being referenced by script: " .. tostring(t));
			return strongTag;
		else
			return t;
		end
	end

	tab.data = {};
	
	for k, v in hpairs(tab) do
		if (type(v) ~= "table") then
			tab.data[k] = v;
			tab[k] = nil;
		end
	end
	
	-- Finally, set up the metatable for our __index method
	return setmetatable(tab,
		{
			__newindex = 
				function(t, k, v)
					t.data[k] = v;
				end,
	
			__index =
				function(t, k)
					local v = weakTagConvert(t.data[k]);
					t.data[k] = v;
					return v;
				end,
	
			__metatable = false
		});
end

----------------------------------------
-- Table Debugger
----------------------------------------
--## SERVER
global g_tableDebuggerShown = false;
global g_tableDebuggerReference = nil;
global g_tableDebuggerButtonTracker = {};

function DebugTable(item)
	if g_tableDebuggerShown == true then
		ImGui_DeactivateCallback("OnDebugTables");
		g_tableDebuggerReference = nil;
		g_tableDebuggerShown = false;
		g_tableDebuggerFilterTracker = {};
	else
		ImGui_ActivateCallback("OnDebugTables");
		g_tableDebuggerShown = true;
		g_tableDebuggerReference = item;
	end
end

function OnDebugTables(item)
	item = item or g_tableDebuggerReference;
	local red = color_rgba(1, 0, 0, 1);
	local green = color_rgba(0, 1, 0, 1);
	local blue = color_rgba(0, 0, 1, 1);

	if ImGui_Begin("Table Debugger") == true then
		ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Button, imguiVars.blue);
		ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonHovered, imguiVars.green);
		ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonActive, imguiVars.red);
		
		if ImGui_Button("  Close Table Debugger  ") == true then
			DebugTable();
		end
		
		ImGui_PopStyleColor();
		ImGui_PopStyleColor();
		ImGui_PopStyleColor();

		sys_DebugTable(item);
	end
	ImGui_End();
end


global g_tableDebuggerFilterTracker = {};

-- === sys_DebugTable: Is used in other imGUI debug functions for showing tables, and objects recursively
--		item		is anything that is needed to show
--		(optional)	enumTable is a table created with the auto enum functions in this file
--			if there is an optional enum table then each key and value will be shown as the enum name if not nil
--  Example: sys_DebugTable(myTable, missionStateEnum)

function sys_DebugTable(item, enumTable:table)	
	--if the item reference is a table, then indent and show contents of the table
	local engineTypeItem = GetEngineType(item);
	
	if engineTypeItem == "player" then
		item = Player_GetUnit(item);
		engineTypeItem = GetEngineType(item);
	end

	if engineTypeItem == "folder" and type(item) ~= "struct" then
		item = Kits_GetComponentsOfType(item);
		engineTypeItem = GetEngineType(item);
	elseif engineTypeItem == "object" then
		sys_DebugObject(item);
	end

	if engineTypeItem == "table" or type(item) == "struct" then
		--if item is a kit or object then show name
		if engineTypeItem == "folder" then
			imguiVars.multiText(item, " = ");
		end

		if type(item) == "struct" then
			imguiVars.standardTwoItemInfo("Struct Name is:", struct.name(item));
		end

		--if custom debug is on the item then run it
		--can this be done with custom metatables?
		--should this move to above the if?
		if sys_CallCustomTableDebugFunc(item) == true then
			return;
		end
		g_tableDebuggerFilterTracker[item] = ImGui_InputText("FILTER CONTENTS: ", g_tableDebuggerFilterTracker[item] or "");
		for key, value in hpairs(item) do
			ImGui_PushStringID(tostring(key)..tostring(value)..tostring(math.random));

			if sys_CallCustomTableDebugPairFunc(item, key, value) == true then
				return;
			end
			
			local engineTypeKey = GetEngineType(key);
			local engineTypeValue = GetEngineType(value);
			
			ImGui_Indent();
			--fix up the names of key and v
			if enumTable ~= nil then
				if type(key) == "number" then
					key = table.getEnumValueAsString(enumTable, key) or key;
				end
				if type(value) == "number" then
					value = table.getEnumValueAsString(enumTable, value) or value;
				end
			end
			
			if type(key) == "function" then
				key = imguiVars.GetDebugStringForFunction(key);
			end

			--if the key or value is a thread, then show the name
			if engineTypeKey == "thread" then
				key = "Thread: "..GetThreadName(key);
			end

			if engineTypeValue == "thread" then
				value = "Thread: "..GetThreadName(value);
			end
			
			--if value is a function then show verbose function information
			if type(value) == "function" then
				value = imguiVars.GetDebugStringForFunction(value);
			end

			local formattedKey = imguiVars.GetFormattedString(key):lower();
			local formattedValue = imguiVars.GetFormattedString(value):lower();
			if string.find(formattedKey, g_tableDebuggerFilterTracker[item]) ~= nil or string.find(formattedValue, g_tableDebuggerFilterTracker[item]) ~= nil then
				--show the formatted key and the value on the same line
				sys_DebugFormatKey(engineTypeKey, key);
				ImGui_SameLine();
				ImGui_Text(" = ");
				ImGui_SameLine();
				sys_DebugFormatValue(engineTypeValue, value);
			end

			ImGui_Unindent();
			ImGui_PopID();
		end
		--end of hpairs

		--if it has a metatable then show that
		local metaTable = getmetatable(item);
		if metaTable ~= nil then
			ImGui_PushStringID(tostring(metaTable)..tostring(math.random));
			ImGui_Indent();
			imguiVars.standardHeader(imguiVars.getString("Metatable:", metaTable, "= "), sys_DebugTable, metaTable);
			ImGui_Unindent();
			ImGui_PopID();
		end
	elseif engineTypeItem == "squad_spawner" then
		imguiVars.ShowSpawnerInformation(item);
	elseif engineTypeItem == "volume" then
		imguiVars.standardHeader(item, sys_DebugVolume, item);
	elseif engineTypeItem == "activation_volume" then
		imguiVars.standardHeader(item, sys_DebugActivationVolume, item);
	elseif engineTypeItem == "persistence_key" then
		ImGui_SameLine();
		local currentState, enum =  sys_GetKeyState(item);
		
		imguiVars.multiTextWithColor(imguiVars.yellow, item, currentState, " (", enum, ")");
	--if the item reference isn't a table, then simply display it on the same line
	else
		ImGui_SameLine();
		imguiVars.standardText(item, imguiVars.yellow);
		ImGui_SameLine();
		ImGui_Text(",");
	end
end

-- === DEBUG_GetKitHierarchyForItemFromAllKits: iterates through a table of kits (default is all kits) to find the kit path and name that an item is in
-- item	- an item to find the path (usually an object or biped)
-- kits - table of kits to search (defaults to all kits)
-- RETURNS - kit reference, path of kit hierarchy as a string, root kit reference
-- NOTE: this is mainly used in the imGui debugger to show the path of an item
-- NOTE: use DebugLookedAtObject as an easy way to see this in debug
function DEBUG_GetKitHierarchyForItemFromAllKits(item, kits:table)
	kits = kits or KITS.active;

	for _, rootKit in ipairs(kits) do
		local name, kit = DEBUG_GetKitHierarchyForItemFromKit(rootKit, "KITS.", item)
		if kit then
			return kit, name, rootKit;
		end
	end

	return nil, nil, nil
end

-- === DEBUG_GetKitHierarchyForItemFromKit: iterates recursively through a kit to find the kit path and name that an item is in
-- kit  - kit to search
-- name - prefix of kit name
-- item	- an item to find the path (usually an object or biped)
-- RETURNS - path of kit hierarchy as a string, kit reference
-- NOTE: this is mainly used in the imGui debugger to show the path of an item
-- NOTE: use DebugLookedAtObject as an easy way to see this in debug
function DEBUG_GetKitHierarchyForItemFromKit(kit, name, item)
	--concat the name
	local newName = imguiVars.getString(name, kit.NAME or kit.components.NAME);
	local comps = kit:GetComponents();
	for _, comp in ipairs(comps) do
		if comp == item then
			--print("found test comp", newName);
			return newName, kit;
		end
	end
		
	local nestedKits = Kits_GetNestedKits(kit);
	local kitReference = nil;
	for _, childKit in ipairs(nestedKits) do
		--use only the name
		name, kitReference = DEBUG_GetKitHierarchyForItemFromKit(childKit, newName, item);
		if kitReference then
			return name, kitReference;
		end
	end

	return name, kitReference;
end
function sys_DebugFormatKey(engineTypeKey, key)
	--if the value is a table or struct, then show a drop down of the contents
	if engineTypeKey == "table" or type(key) == "struct" then
		sys_DebugShowKeyTable(key);
	elseif engineTypeKey == "folder" then
		sys_DebugShowKeyTable(Kits_GetComponents(key));
	elseif engineTypeKey == "object" then
		sys_DebugShowKeyTable(key);
	elseif engineTypeKey == "volume" then
		sys_DebugShowKeyTable(key);
	elseif engineTypeKey == "activation_volume" then
		sys_DebugShowKeyTable(key);
	else
		imguiVars.multiText(key);
	end
end

function sys_DebugFormatValue(engineTypeValue, value)
	--if the value is a table or struct, then show a drop down of the contents
	if engineTypeValue == "table" or type(value) == "struct" then
		imguiVars.standardHeader(imguiVars.getString(value), sys_DebugTable, value);
	elseif engineTypeValue == "folder" then
		imguiVars.standardHeader(imguiVars.getString(value), sys_DebugTable, Kits_GetComponents(value));
	--else show key = the value
	elseif engineTypeValue == "object" then
		imguiVars.standardHeader(imguiVars.getString(value), sys_DebugTable, value);
	elseif engineTypeValue == "volume" then
		imguiVars.standardHeader(imguiVars.getString(value), sys_DebugVolume, value);
	elseif engineTypeValue == "activation_volume" then
		imguiVars.standardHeader(imguiVars.getString(value), sys_DebugActivationVolume, value);
	else
		sys_DebugTable(value);
		ImGui_Spacing();
	end
end

function sys_GetKeyState(key:persistence_key)
	local keyType = Persistence_GetKeyType(key);

	if keyType == PERSISTENCE_KEY_TYPE.Byte then
		local keyNum:number = Persistence_GetByteKey(key);
		return keyNum, table.getEnumValueAsString(missionStateEnum, keyNum);
	else
		return Persistence_GetBoolKey(key), "";
	end
end

function sys_CallCustomTableDebugFunc(item)
	if item.__DebugImgui ~= nil and type(item.__DebugImgui) == "function" then
		--if the custom debug returns true then don't display more debug
		local pcallReturn, returnValue = pcall(item.__DebugImgui, item);
		if pcallReturn == true then
			return returnValue;
		end
	end
end

function sys_CallCustomTableDebugPairFunc(item, k, v)
	if item.__DebugImguiPair ~= nil and type(item.__DebugImguiPair) == "function" then
	--if the custom debug returns true then don't display more debug
		local pcallReturn, returnValue = pcall(item.__DebugImguiPair, item, k, v);
		if pcallReturn == true then
			return returnValue;
		end
	end
end

function sys_DebugShowTypeFolder(k, folder:folder)
	local folderName = imguiVars.GetFormattedString(folder);
	local first = string.find(folderName, "%s%(", 1);
	folderName = string.sub(folderName, 1, first-1);
	if ImGui_CollapsingHeader(imguiVars.getString(k, ": ",folderName, " = ")) == true then
		ImGui_Indent();
		imguiVars.standardTwoItemInfo("Full Name:", folder);
		sys_DebugTable(Kits_GetComponents(folder));
		ImGui_Unindent();
	end
end

function sys_DebugShowKeyTable(k)
	--show a button to open a new window with the key
	imguiVars.standardButton(imguiVars.getString(k), function()
		g_tableDebuggerButtonTracker[k] = true;
		ImGui_ActivateCallback("Imgui_AddNewTableDebugWindow");
	end);
end

function Imgui_AddNewTableDebugWindow()
	for entry, bool in hpairs(g_tableDebuggerButtonTracker) do
		ImGui_PushStringID(tostring(math.random));
		if ImGui_Begin("Debug Item"..tostring(entry)) == true then
			imguiVars.standardButton("  Close Imgui Window  ", function()
				g_tableDebuggerButtonTracker[entry] = nil;
			end);
			imguiVars.multiText("Showing: ", entry);
			sys_DebugTable(entry);
		end
		ImGui_End();
		ImGui_PopID();
	end

	if table.countKeys(g_tableDebuggerButtonTracker) == 0 then
		ImGui_DeactivateCallback("Imgui_AddNewTableDebugWindow");
	end
end

global DebugObject = DebugTable;

function sys_DebugObject(item)
	if object_index_valid(item) == false then
		imguiVars.standardText("OBJECT IS INVALID", imguiVars.red)
		return;
	end
	--print a friendly name of the object
	local objName:string = imguiVars.GetFormattedString(Object_GetName(item));
	--if there is extra debug naming in the name then simplify
	if objName:find("]") then
		objName = objName:sub(objName:find("]") + 2, objName:len())
	end

	imguiVars.standardTwoItemInfo("Object Name is:", objName);
	imguiVars.standardTwoItemInfo("Index is:", item);
	local type, subtype = GetEngineType(item, true)
	imguiVars.standardTwoItemInfo("Type is:", type, subtype);
	--variant
	imguiVars.standardTwoItemInfo("Variant is:", ObjectGetVariant(item));
	--tag
	imguiVars.standardTwoItemInfo("Tag is:", Object_GetDefinition(item));

	--position and power
	if subtype == "control" or subtype == "machine" then
		ImGui_Separator();
		ImGui_Columns(2);
		ImGui_SetColumnWidth(-1, 200);
		imguiVars.standardTwoItemInfo("Position is:", Device_GetPosition(item));
		--ImGui_SameLine();
		local notPosition = Device_GetPosition(item) < 1 and 1 or 0;
		ImGui_NextColumn();
		ImGui_SetColumnWidth(-1, 200);
		imguiVars.standardButton("Set Position to "..tostring(notPosition), function() Device_SetPosition(item, notPosition) end);
		ImGui_NextColumn();
		imguiVars.standardTwoItemInfo("Power is:   ", Device_GetPower(item));
		--ImGui_SameLine();
		ImGui_NextColumn();
		local notPosition = Device_GetPower(item) < 1 and 1 or 0;
		imguiVars.standardButton("Set Power to "..tostring(notPosition), function() Device_SetPower(item, notPosition) end);
		ImGui_Separator();
		ImGui_Columns(1);
	end

	--health
	imguiVars.standardTwoItemInfo("Health and Shield is:", Object_GetHealth(item), object_get_shield(item));
	--team
	imguiVars.standardTwoItemInfo("Team is:", Object_GetCampaignTeam(item), Object_GetMultiplayerTeam(item), Object_GetTeamDesignator(item));
				
	--location
	imguiVars.standardTwoItemInfo("Location Volume is:", Object_GetLocationName(item));
	imguiVars.standardTwoItemInfo("Location is:", Object_GetPosition(item));
	imguiVars.standardTwoItemInfo("BSP is:", object_get_bsp(item));

	--buttons to show nav, destroy, hide
	imguiVars.standardButton("Show Navpoint on Object", NavpointShowObject, item);
	imguiVars.standardButton("Destroy", function() Object_Delete(item) end);
	ImGui_SameLine();
	local hidden:boolean = Object_GetIsHidden(item);
	imguiVars.standardButton(hidden and "Unhide" or "Hide", function() object_hide(item, not hidden) end);
	--show parents in dropdown
	local parent = Object_GetParent(item);
	if parent then
		ImGui_Indent();
		ImGui_PushStringID(tostring(item)..tostring(math.random));
		
		imguiVars.standardHeader(imguiVars.getString("Parent Object:", parent), sys_DebugTable, parent);
		ImGui_PopID();
		ImGui_Unindent();
	end
			
	--show children in dropdown
	local children = object_list_children(item);
	if #children > 0 then
		imguiVars.standardTwoItemInfo("Child Objects:", #children);
		ImGui_Indent();
		for _, childObject in ipairs(children) do
			imguiVars.standardHeader(imguiVars.getString("Child Object:", childObject), sys_DebugObject, childObject);
		end
		ImGui_Unindent();
	end

	--show any AI information
	if Actor_GetActorFromObject(item) then
		imguiVars.standardHeader("Debug Actor Information", imguiVars.ShowUnitInformation, item);
	end

	local aiHandle = AI_GetSquadInstanceFromAISquad(Object_GetSquad(item))
	if Handle_IsNotNone(aiHandle) then
		imguiVars.standardHeader("Show Kit Hierarchy of Spawner", imguiVars.displayKitHierarchyFromItem, AI_GetSquadSpawnerFromSquadInstance(aiHandle));
	else
		imguiVars.standardHeader("Show Kit Hierarchy", imguiVars.displayKitHierarchyFromItem, item);
	end
end

--debug trigger volumes
function sys_DebugVolume(vol:volume)
	--show friendly name (if possible) TriggerVolume_GetName
	imguiVars.standardTwoItemInfo("Volume Name is:", TriggerVolume_GetName(vol));
	imguiVars.standardHeader("Players in Volume:", sys_DebugTable, volume_return_players(vol));
	imguiVars.standardHeader("AI in Volume:", sys_DebugTable, ai_get_all_in_trigger_volume(vol));
	imguiVars.standardHeader("Objects in Volume:", sys_DebugTable, volume_return_objects(vol));

	--volume get center, extents, lengths, rotation
	imguiVars.standardHeader("Volume Loc Data:", sys_ShowVolumeLocationProperties, vol);
end

--debug activation volumes
function sys_DebugActivationVolume(vol:activation_volume)
	imguiVars.standardTwoItemInfo("Center is:", ActivationVolume_GetCenter(vol));
	imguiVars.standardHeader("Players in Volume:", sys_DebugTable, ActivationVolume_GetPlayers(vol));
	--button to show center
	imguiVars.standardButton("Navpoint the Center", NavpointShowAtLocation, ActivationVolume_GetCenter(vol));
	imguiVars.standardButton("Navpoint Node Closest Player0", NavpointShowAtLocation, ActivationVolume_FindClosestVolumePoint(vol, ToLocation(PLAYERS.player0).vector));
end

function sys_ShowVolumeLocationProperties(vol:volume)
	imguiVars.standardTwoItemInfo("Center is:", volume_get_center(vol));
	imguiVars.standardTwoItemInfo("Extents are:", volume_get_extents(vol));
	imguiVars.standardTwoItemInfo("Lengths are:", volume_get_lengths(vol));
	imguiVars.standardTwoItemInfo("Rotation:", volume_get_rotation(vol));
	imguiVars.standardButton("Navpoint the Center", NavpointShowAtLocation, volume_get_center(vol));
end