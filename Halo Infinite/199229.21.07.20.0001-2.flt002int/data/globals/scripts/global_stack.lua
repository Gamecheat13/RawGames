-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Stack Implementation
-- ========================

global StackClass = table.makePermanent
{
	count = 0,
	list = {},
};

function StackClass:New():table
	local newStack:table = table.addMetatableRecursive(self);

	newStack.list = {};
	return newStack;
end

function StackClass:Push(val):void
	self.count = self.count + 1;
	self.list[self.count] = val;
end

function StackClass:Pop()
	if (self.count == 0) then
		return nil;
	else
		local val = self.list[self.count];
		self.list[self.count] = nil;
		self.count = self.count - 1;
		return val;
	end
end

function StackClass:Peek()
	return self.list[self.count];
end

function StackClass:Count():number
	return self.count;
end

function stack_elements(stack:table)
	local i = 0;
	return function()
		i = i + 1;
		if i <= stack.count then
			return stack.list[i];
		end
	end
end

function StackClass:Print()
	table.dprint (self.list);
end