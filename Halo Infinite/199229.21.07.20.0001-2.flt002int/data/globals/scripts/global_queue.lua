-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Queue Implementation
-- ========================

global QueueClass = table.makePermanent
{
	first = 1,
	last = 0,
	list = {},
};

function QueueClass:New():table
	local newQueue:table = table.addMetatableRecursive(self);

	newQueue.list = {};
	return newQueue;
end

function QueueClass:NewFromArray(array:table):table
	local newQueue:table = table.addMetatableRecursive(self);
	newQueue.list = {};
	
	for _, v in ipairs(array) do
		newQueue.Push(v);
	end

	return newQueue;
end

function QueueClass:Push(val):void
	self.last = self.last + 1;
	self.list[self.last] = val;
end

function QueueClass:PushElems(array:table):void
	for _, val in ipairs(array) do
		self:Push(val);
	end
end

function QueueClass:Pop()
	if (self.last >= self.first) then
		local val = self.list[self.first];
		self.list[self.first] = nil;
		self.first = self.first + 1;
		return val;
	end
	
	return nil;
end

function QueueClass:Peek()
	return self.list[self.first];
end

-- peek at the last item (newest item).
function QueueClass:PeekLast()
	return self.list[self.last];
end

function QueueClass:Clear():void
	self.list = {};
	self.first = 1;
	self.last = 0;
end

function QueueClass:Count():number
	return self.last - self.first + 1;
end

function QueueClass:NotEmpty():boolean
	return self.last >= self.first;
end

function QueueClass:IsEmpty():boolean
	return self.last < self.first;
end

function QueueClass:ForEach(func:ifunction):void
	for _, val in hpairs(self.list) do
		func(val);
	end
end

function queue_elements(queue:table)
	local i = queue.first-1;
	local last = queue.last;
	return function ()
		i = i + 1;
		if i <= last then
			return queue.list[i];
		end
	end
end