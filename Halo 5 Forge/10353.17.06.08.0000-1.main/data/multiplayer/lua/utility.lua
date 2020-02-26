--
-- Utility functions
--

function table.filter(table, predicate)

	local output = { };

	for key, value in pairs(table) do

		if predicate(value) then

			output[key] = value;

		end

	end

	return output;

end

function table.filtervalues(table, predicate)

	local output = { };

	for key, value in pairs(table) do

		if predicate(value) then

			output[#output + 1] = value;

		end

	end

	return output;

end

function table.any(table, predicate)

	for _, value in pairs(table) do

		if predicate(value) then

			return true;

		end

	end

	return false;

end

function table.all(table, predicate)

	for _, value in pairs(table) do

		if not predicate(value) then

			return false;

		end

	end

	return true;

end

function table.contains(table, val)

	for _, value in pairs(table) do

		if value == val then

			return true;

		end

	end

	return false;

end

function table.first(table, predicate)

	for _, value in pairs(table) do

		if predicate == nil or predicate(value) then

			return value
		end

	end

	return nil;

end

function table.map(table, func)

	local output = { };

	for key, value in pairs(table) do

		output[value] = func(value);

	end

	return output;

end

function table.copy(table)

	local output = {};

	for key, value in pairs(table) do

		output[key] = value;

	end

	return setmetatable(output, getmetatable(table));

end

function NotFilter(predicate)

	return function(...)

		return not predicate(...);
		
	end

end
