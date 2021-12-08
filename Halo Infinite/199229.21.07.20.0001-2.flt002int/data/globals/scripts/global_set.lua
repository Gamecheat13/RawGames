-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Set Implementation
-- ========================

-- Sets allow for quick insertion and removal. It is a collection of distinct objects (no duplicates).
global SetClass = table.makePermanent
	{
		list = {},
		count  = 0,
	};

function SetClass:New():table
	local newSet:table = table.addMetatableRecursive(self);
	
	newSet.list = {};
	return newSet;
end

function SetClass:Insert(val):boolean
	if self.list[val] == nil then
		self.list[val] = true;
		self.count = self.count + 1;
		return true;
	end

	return false;
end

function SetClass:Remove(val):boolean
	if self.list[val] ~= nil then
		self.list[val] = nil;
		self.count = self.count - 1;
		return true;
	end

	return false;
end

function SetClass:Contains(val):boolean
	return self.list[val] ~= nil;
end

function SetClass:Clear():void
	self.list = {};
	self.count = 0;
end

function SetClass:Count():number
	return self.count;
end


-- Use set_elements to do a for loop on a SetClass. The iterator just returns an element, not a pair.
-- e.g.: for e in set_elements(set) do
function set_elements(set:table)
	local currentKey = nil;
	return function ()
		if set ~= nil then
			local k, _ = next(set.list, currentKey);
			currentKey = k;
			return k;
		else
			return nil;
		end
	end
end

--## SERVER
function SetClass:__DebugImgui(item)
	imguiVars.standardTwoItemInfo("Count:", self.count);
	imguiVars.standardHeader("Objects", sys_DebugTable, self.list);

	if ImGui_CollapsingHeader("Show Set Class internal") == true then
		return;
	else
		return true;
	end
end