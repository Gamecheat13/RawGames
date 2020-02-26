--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--
-- table
--										
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table:copy
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === table.copy: allows a tables values to be copied
--		deep [optional; true] - true = deep copy all the sub tables as well; false = only copy the initial level, setting values by reference
--		target [optional; {}] - optional target table to copy to.  This will stomp values in the the target table with values from the copy one
--		WARNING: Currently this does not support players tables that reference other tables within itself or the main table; this will create infinite loops.
--			NOTE: This will get fixed when I have a minute to sort it out [TF]
-- RETURN: target table
-- Example: table2=table.copy(table1);
function table.copy( tab:table, deep:boolean, target:table ):table
	target = param_default( target, {} );								-- DEFAULTS
	deep = param_default( deep, true );									-- DEFAULTS

	return sys_table_copy( tab, deep, target );
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
function table.dprint( tab:table, deep:boolean, indent_new:string, indent_current:string )
	-- initial table dprint
	sys_table_dprint( tab, deep, indent_new, indent_current, "" );

end


-- === table.combine: adds two tables into the first table
--		tab1	- the table you wanted added to
--		tab2	- the table you want to add to the first table
--  Example: table.combine(table1, table2);
function table.combine (tab1:table, tab2:table):void
	for _,val in ipairs(tab2) do
		tab1[#tab1 + 1] = val
	end
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
--		t - table to cehck if it's enabled
--		val	- the value to assign to enabled; nil will just check the value
--  Example: table.enabled(t, true); - sets enabled to true
function table.enabled( t:table, val:boolean ):boolean
	
	if ( t ~= nil ) then

		if ( type(t.enabled) == "function" ) then

			val = t.enabled( val );

		elseif ( val ~= nil ) then

			t.enabled = val;

		else

			val = t.enabled;

		end

		return ( val ~= false ) and ( (type(t._parent) ~= "table") or table.enabled(t._parent) );

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
function table.contains (tab:table, val):boolean
	for _,v in pairs (tab) do
		if v == val then
			return true
		end
	end
	return false;
end

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- table.compare
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- === table.compare: checks whether 2 tables contain the same values and returns true if they do, false if not
-- === NOTE - this function doesn't care aobut the order of the values in the table
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
	
	for _,v in pairs (tab1) do
		tab1temp[v] = true;
	end
	
	for _,v in pairs (tab2) do
		tab2temp[v] = true;
	end

	for i,_ in pairs (tab1temp) do
		if not tab2temp[i] then
			--print (i);
			return false;
		end
	end

	return true;
end


function table.dif(tab1:table, tab2:table):table
	local tab1temp = {};
	local tab2temp = {};
	local tabgreater = {};
	local tablesser = {};
	local tabdif = {}
		
	for _,v in pairs (tab1) do
		tab1temp[v] = true;
	end
	
	for _,v in pairs (tab2) do
		tab2temp[v] = true;
	end

	if #tab1temp > #tab2temp then
		tabgreater = tab1temp;
		tablesser = tab2temp;
	else
		tabgreater = tab2temp;
		tablesser = tab1temp;
	end

	for i,_ in pairs (tabgreater) do
		if not tablesser[i] then
			--print (i);
			tabdif[#tabdif + 1] = i;
		end
	end

	table.dprint (tabdif);

	return tabdif;
end
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM FUNCTIONS; GENERALLY YOU SHOULD IGNORE THESE
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

function sys_table_copy( tab:table, deep:boolean, target:table ): table

	-- store and remove metatable
	local mt = getmetatable( tab );
	setmetatable( tab, nil );

	for key, value in pairs(tab) do
		if ( type(value) == 'table' ) then
			if ( type(key) ~= "string" or key:sub(1,2) ~= "__" ) then
				if ( deep ) then
					if ( type(target[key]) == "table" ) then
						value = sys_table_copy( value, deep, target[key] );
					else
						value = sys_table_copy( value, deep, {} );
					end
				end
			elseif ( value == tab ) then
				value = target;
			end
		end

		target[key] = value;

	end

	-- restore metatable on tab and set on target
	setmetatable( tab, mt );
	setmetatable( target, mt );

	return target;
end

-- system function that manages the dprint
function sys_table_dprint( tab:table, deep:boolean, indent_new:string, indent_current:string, indent_old:string )

	deep = param_default( deep, true );								-- DEFAULTS
	indent_new = param_default( indent_new, "     " );		-- DEFAULTS
	indent_current = param_default( indent_current, "" );	-- DEFAULTS

	-- indent
	indent_old = indent_current;

	-- loop through and dprint
	dprint( indent_old .. "{" );
	for key, value in pairs(tab) do
		if ( (not deep) or (type(value) ~= 'table') ) then
			dprint( indent_current .. indent_new .. tostring(key) .. " = " .. tostring(value) );
		else
			dprint( indent_current .. indent_new .. tostring(key) .. " = " );
			sys_table_dprint( value, deep, indent_new, indent_current .. indent_new, indent_old );
		end

	end
	dprint( indent_old .. "}" );
end
