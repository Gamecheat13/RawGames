--Copyright (c) Microsoft Corporation.  All rights reserved.

-- Base class for pointers for our primitive types.
global Primitive = table.makePermanent
	{
		data = nil,
	};

function Primitive:CreateSubclass():table
	return table.addMetatableRecursive(self);
end

function Primitive:New(init):table
	init = init or self:DefaultValue();
	local newVal:table = table.addMetatableRecursive(self);

	newVal:Set(init);
	return newVal;
end

function Primitive:Get()
	return self.data;
end

function Primitive:Set(val):void
	assert(type(val) == self:GetType(), "Expected type " .. self:GetType() .. " but got " .. type(val));
	self.data = val;
end

function Primitive:GetType():string
	return "nil";
end

function Primitive:DefaultValue()
	return nil;
end

----------------
---- Number ----
----------------

global Number = Primitive:CreateSubclass();

function Number:GetType():string
	return "number";
end

function Number:DefaultValue()
	return 0;
end

function Number:Add(amount:number):void
	self.data = self.data + amount;
end

----------------
--- Boolean ----
----------------

global Boolean = Primitive:CreateSubclass();

function Boolean:GetType():string
	return "boolean";
end

function Boolean:DefaultValue()
	return false;
end