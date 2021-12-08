-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER

global RegistrationTable:table = table.makePermanent
{
	dataTable = {};
}

function RegistrationTable.New():table
	local regTable = setmetatable({}, {__index = RegistrationTable});
	regTable.dataTable = {};
	return regTable;
end

function RegistrationTable:Register(key:ifunction):boolean
	if (self.dataTable[key] == nil) then
		self.dataTable[key] = key();
		return true;
	end
	return false;
end

function RegistrationTable:Request(key:ifunction)
	if self.dataTable[key] ~= nil then
		return self.dataTable[key];
	else
		local data = key();
		self.dataTable[key] = data;
		return data;
	end
end