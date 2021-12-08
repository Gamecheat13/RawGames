-- Copyright (c) Microsoft. All rights reserved.

-- ========================
-- Circular Buffer Implementation
-- ========================

-- circular buffers allow a fixed size LIFO or FIFO-ish queue, that overwrites the oldest entries when full
-- FIFO-ish because the first entry in could have been overwritten
global CircularBuffer = table.makePermanent
	{
		list = {},
		head = 0, -- sticking with zero based indexing to make internal operations easier
		tail = 0,
		numEntries = 0,
		capacity = 0,
	};

-- the size of the buffer must be provided
function CircularBuffer:New(size:number):table
	local newBuffer:table = table.addMetatableRecursive(self);

	newBuffer.head = 0;
	newBuffer.tail = 0;
	newBuffer.numEntries = 0;
	newBuffer.capacity = size;

	return newBuffer;
end

-- add an entry into the buffer, will overwrite oldest entry if full
function CircularBuffer:Add(value):void
	if self.numEntries < self.capacity then
		if self.numEntries > 0 then
			self:IncrementTail();
		end
		
		self.list[self.tail] = value;
		self.numEntries = self.numEntries + 1;
	else
		self.tail = self.head;
		self.list[self.head] = value;
		self:IncrementHead();
	end
end

-- get the oldest entry, at the front of the queue
function CircularBuffer:Front():any
	return self.list[self.head];
end

-- get the newest entry, at the back of the queue
function CircularBuffer:Back():any
	return self.list[self.tail];
end

-- remove the oldest entry from the front of the queue
function CircularBuffer:PopFront():void
	if self.numEntries > 0 then
		self.list[self.head] = nil;
		self.numEntries = self.numEntries - 1;

		-- only need to change head index if not empty
		if self.numEntries > 0 then
			self:IncrementHead();
		end
	end;
end

-- remove the newest entry from the end of the queue
function CircularBuffer:PopBack():void
	if self.numEntries > 0 then
		self.list[self.tail] = nil;
		self.numEntries = self.numEntries - 1;

		-- only need to change tail index if not empty
		if self.numEntries > 0 then
			self:DecrementTail();
		end
	end
end

function CircularBuffer:Capacity():number
	return self.capacity;
end

function CircularBuffer:Count():number
	return self.numEntries;
end

function CircularBuffer:Clear():void
	-- just nil out every entry
	for i = 0, self.capacity - 1, 1 do
		self.list[i] = nil;
	end

	self.head = 0;
	self.tail = 0;
	self.numEntries = 0;
end

function CircularBuffer:IncrementTail():void
	-- increment the tail, wrap around if needed
	self.tail = (self.tail + 1) % self.capacity;
end

function CircularBuffer:DecrementTail():void
	self.tail = self.tail - 1;

	-- wrap back around if needed
	if self.tail < 0 then
		self.tail = self.capacity - 1;
	end
end

function CircularBuffer:IncrementHead():void
	self.head = (self.head + 1) % self.capacity;
end

function CircularBuffer:Print():void
	-- just make an array of the entries, so we can print them contiguously AND in order
	local inOrder:table = ArrayClass:New();
	for value in buffer_entries(self) do
		inOrder:Add(value);
	end

	inOrder:Print();
end

-- loop over the entries in the buffer, from oldest to newest
function buffer_entries(buffer:table):any
	local currentIndex:number = nil;
	if buffer ~= nil then
		currentIndex = buffer.head;
	end

	return function ()
		if buffer ~= nil then
			if currentIndex == nil then
				return nil;
			end

			local value:any = buffer.list[currentIndex];

			currentIndex = (currentIndex + 1) % buffer.capacity;

			if currentIndex == buffer.tail then
				currentIndex = nil;
			end
			
			return value;
		else
			return nil;
		end
	end
end