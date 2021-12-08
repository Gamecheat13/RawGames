-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Array Implementation
-- ========================

-- Arrays allow for a list of items.
global ArrayClass = table.makePermanent
	{
		list = {},
		count = 0,
	};

-- the argument oldList needs to be an object_list OR an array-type table
function ArrayClass:New(oldList):table
	local newArray:table = table.addMetatableRecursive(self);

	if oldList ~= nil then
		for k, v in ipairs(oldList) do
			newArray.list[k] = v;
		end
		newArray.count = #oldList;
	end
	return newArray;
end

function ArrayClass:Add(val):void
	self.count = self.count + 1;
	self.list[self.count] = val;
end

-- the argument list needs to be an object_list OR an array-type table
function ArrayClass:AppendList(list):void
	for _, v in ipairs(list) do
		self:Add(v);
	end
end

function ArrayClass:Insert(val, position:number):void
	if position == nil then
		return self:Add(val);
	end
	assert(position >= 1, "trying to insert a value that is nil or less than 1 into an array ");
	assert(position <= (self.count + 1), "trying to insert invalid position "..position.." into size "..self.count.." array");
	local count:number = self.count;
	for i = count, position, -1 do
		self.list[i + 1] = self.list[i];
	end
	self.count = self.count + 1;
	self.list[position] = val;
end

function ArrayClass:Remove(position:number):void
	assert(position >= 1 and position <= self.count, "can't remove a position in an array greater than the count");
	
	local initialCount:number = self:Count();
	self.list[position] = self.list[initialCount];
	
	self.count = self.count - 1;
end

function ArrayClass:RemoveOrdered(position:number):void
	assert(position >= 1 and position <= self.count, "can't remove a position in an array greater than the count");
	local initialCount:number = self:Count();
	for i = position, initialCount do
		--in lua getting an index that is not set, returns nil
		--so setting the final index of list to nil effectively shrinks the array by one
		self.list[i] = self.list[i+1];
	end
	self.count = self.count - 1;
end

function ArrayClass:RemoveFirst(val):number
	local initialCount:number = self:Count();

	-- Look for the first occurrence of the value
	local foundIdx:number = nil;
	for i = 1, initialCount do
		if self.list[i] == val then
			foundIdx = i;
			break;
		end
	end

	-- If it exists, remove it and then shift the remaining elements up one element
	if foundIdx ~= nil then
		for i = foundIdx, initialCount do
			--in lua getting an index that is not set, returns nil
			--so setting the final index of list to nil effectively shrinks the array by one
			self.list[i] = self.list[i+1];
		end
		self.count = self.count - 1;
	end

	return foundIdx
end

function ArrayClass:Contains(val):boolean
	for _, v in ipairs(self.list) do
		if v == val then
			return true
		end
	end
	return false;
end

function ArrayClass:Get(index:number):any
	assert(index >= 1 and index <= self.count, "can't get an index in an array greater than the count");
	return self.list[index];
end

function ArrayClass:Clear():void
	self.list = {};
	self.count = 0;
end

function ArrayClass:Count():number
	return self.count;
end

--compare
function ArrayClass:Compare(array:table):boolean
	assert(array.list ~= nil, "trying to use Compare on a table that is not an ArrayClass");
	return table.compare(self.list, array.list);
end

-- === ArrayClass:Dif: checks whether 2 arrays contain the same values and returns an array of items they do not have in common
-- === NOTE - this function doesn't care about the order of the values in the array
--		array - array to compare to the current array

-- Array a = {OBJECTS.crate1, OBJECTS.crate2}
-- Array b = {OBJECTS.crate2, OBJECTS.crate3}

-- a:Dif(b);
-- returns an array of the non-similar values of "a" and "b" which is {OBJECTS.crate1, OBJECTS.crate3}
function ArrayClass:Dif(array:table):table
	assert(array.list ~= nil, "trying to use Dif on a table that is not an ArrayClass");
	return ArrayClass:New(table.dif(self.list, array.list));
end

-- SORT
-- === NOTE - orderFunc needs to be written to return a boolean and take 2 arguments (the key and the value)
-- for array of type e, the function signature of orderFunc should be (x:e, y:e):boolean
-- example that sorts an array in ascending order:
--		myArrayClass:Sort(function(a,b) return a < b end)

function ArrayClass:Sort(orderFunc):void
	if orderFunc ~= nil then
		table.sort(self.list, orderFunc);
	else
		table.sort(self.list);
	end
end

--print
function ArrayClass:Print():void
	table.dprint(self.list);
end

-- Use apairs to do a for loop on an ArrayClass. The iterator returns the pair from .list
-- e.g.: for k, v in apairs(array) do
function apairs(array:table)
	local currentKey = nil;
	return function ()
		if array ~= nil then
			local k, v = next(array.list, currentKey);
			currentKey = k;
			return k, v;
		else
			return nil;
		end
	end
end