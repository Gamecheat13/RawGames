-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Map Implementation
-- ========================

-- Maps allow for quick insertion and removal. It is a collection of distinct key-value mappings (no duplicate keys).
global MapClass = table.makePermanent
{
	list = {},
	count = 0,
};

function MapClass:New():table
	local newMap:table = table.addMetatableRecursive(self);

	newMap.list = {};
	return newMap;
end

function MapClass:Insert(key, val):boolean

	assert(val ~= nil, "Attempting to insert a nil value into the collection");

	if self.list[key] == nil then
		self.count = self.count + 1;
		self.list[key] = val;
		return true;
	end
	self.list[key] = val;
	return false;
end

function MapClass:Remove(key):boolean
	if self.list[key] ~= nil then
		self.list[key] = nil;
		self.count = self.count - 1;
		return true;
	end

	return false;
end

function MapClass:Contains(key):boolean
	return self.list[key] ~= nil;
end

function MapClass:Get(key):any
	return self.list[key];
end

function MapClass:Clear():void
	self.list = {};
	self.count = 0;
end

function MapClass:Count():number
	return self.count;
end

-- Use map_keys to do a for loop on a MapClass. The iterator just returns a key, not a pair.
-- e.g.: for key in map_keys(map) do
function map_keys(map:table)
	local currentKey = nil;
	return function ()
		if map ~= nil then
			local k, v = next(map.list, currentKey);
			currentKey = k;
			return k, v;
		else
			return nil;
		end
	end
end