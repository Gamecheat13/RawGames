--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
-- FILE: 		global_data_cache
-- DESCRIPTION:	This system allows designers to cache the data returned by a funciton and control how often (number of frames) it is evaluated.  This allows
--				them to re-use the same piece of data in several functions without having to re-evaluate the (possibly expensive) function multiple times in
--				the same cycle.
--				Caches can be parented to other caches which will automatically force them to re-evaluate if the parent cache data changes or the parent
--				data has expired it will re-evaluate before the children do.
--
-- STEPS:		1) Create a data cache variable
--					global/local cache_var = G_data_cache.new();
--					This makes a new data cache variable where your cache data is stored
--				2) Register cache_ids that are associated with functions that generates the data to cache.  You can use whatever name you want for the cache
--				   id's but know if you use the same it will stomp the old one.
--					cache_var:register( "cache_01", test_data_cache_eval_01, 10 );
--					cache_var:register( "cache_02", test_data_cache_eval_01, 60, "cache_01" );
--				3) When you need to get the data, call the cache get function
--					var = cache_var:data("cache_01");
--
-- EXAMPLE:		see test_data_cache() below
--					Notice that even though the function to get the cache for test_03 is called first, in the debug output test_01 is called first because
--					it's cache expires before the others which forces it's children to re-evaluate.
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
--34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- *** GLOBAL: DATA CACHE ***
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global G_data_cache = {
	_caches = {
	},
	_template_cache = {
		_delay = 0,
		_eval = nil,
		_parent = nil,
		_users = {
		},
		_param_data = nil,
		_filter_list = nil,
		_filter_default = nil,
	},
	_template_user = {
		_data = nil,
		_stamp = 0,
		_parent_data = nil
	},
	_defaults = {
		global_user = "*global*",
		filter_deliniator = ".",
		default_delay = nil,
	}
};

-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache.new():table
	return table.copy( G_data_cache, true );
end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:register( id_cache, f_eval, param_data, n_delay, id_parent:string ):boolean

	-- validate id
	id_cache = self:validate_id( id_cache );

	if ( (id_cache ~= nil) and (type(f_eval) == "function") and ((n_delay ~= nil) or ((id_parent ~= nil) and (self._caches[id_parent] ~= nil))) ) then
		-- make new global cache
		local t_cache = table.copy( self._template_cache, true );

		-- set cache settings
		t_cache._eval = f_eval;
		t_cache._delay = n_delay or self:default_delay();
		t_cache._param_data = param_data;
		t_cache._parent = id_parent;

		-- store new cache
		self._caches[ id_cache ] = t_cache;

		-- return
		return true;
	else
		if ( id_cache == nil ) then
			dprint( "ERROR: G_data_cache:register(" ..  tostring(id_cache) .. ") - NIL cache ID" );
		end
		if ( type(f_eval) ~= "function" ) then
			dprint( "ERROR: G_data_cache:register(" ..  tostring(id_cache) .. ") - Cache evaluate function invalid: " .. tostring(f_eval) );
		end
		if ( (id_parent == nil) and (self._caches[id_parent] == nil) ) then
			dprint( "ERROR: G_data_cache:register(" ..  tostring(id_cache) .. ") - NIL parent ID: " .. tostring(id_parent) );
		elseif ( n_delay == nil ) then
			dprint( "ERROR: G_data_cache:register(" ..  tostring(id_cache) .. ") - NIL delay: " .. tostring(n_delay) );
		end
		return false;
	end

end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:exists( id_cache, id_user ):boolean

	-- validate id
	id_cache = self:validate_id( id_cache );

	return ( (id_cache ~= nil) and (self._caches[id_cache] ~= nil) ) and ((id_user == nil) or (self._caches[id_cache]._users[id_user] ~= nil));

end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:data( id_cache, id_user )

	-- validate id
	id_cache = self:validate_id( id_cache );

	local v_data = nil;
	if ( id_cache ~= nil ) then
		-- get cache for id
		local t_cache = self._caches[ id_cache ];

		if ( t_cache ~= nil ) then
			-- default user id
			id_user = id_user or G_data_cache._defaults.global_user;

			-- get user cache
			local t_user = t_cache._users[ id_user ];

			-- setup new user cache
			if ( t_user == nil ) then
				t_user = table.copy( G_data_cache._template_user, true );
				t_cache._users[ id_user ] = t_user;
			end

			-- evaluate
			if ( ((t_cache._delay ~= nil) and (game_tick_get() >= t_user._stamp)) or ((t_cache._parent ~= nil) and (self:data(t_cache._parent,id_user) ~= t_user._parent_data)) ) then
				-- store parent data
				if ( t_cache._parent ~=nil ) then
					t_user._parent_data = self:data( t_cache._parent, id_user );
				end

				-- store cached data
				t_user._data = t_cache._eval( id_user, t_cache._param_data, t_user._data, t_user._parent_data );

				-- setup delay
				if ( t_cache._delay ~= nil ) then

					if ( type(t_cache._delay) ~= "function" ) then
						t_user._stamp = game_tick_get() + t_cache._delay;
					else
						t_user._stamp = game_tick_get() + t_cache._delay( id_user, t_user._data, t_user._parent_data );
					end
					
				end
			end

			v_data = t_user._data;
		else
			dprint( "ERROR: G_data_cache:data - Attempted to access data from a missing cache id: " .. tostring(id_cache) );
		end
	end

	--- return
	return v_data;
end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:id_list():table
	local t = {};
	for id, data in pairs( self._caches ) do
		table.insert( t, id );
	end
	return t;
end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:filter( list, default )

	if ( type(list) == "table" ) then
		self._filter_list = list;
	end

	if ( type(default) == "function" ) then
		self._filter_default = default;
	end

	return self._filter_list, self._filter_default;

end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:filter_clear( list, default )
	if ( list ) then
		self._filter_list = nil;
	end
	if ( default ) then
		self._filter_default = nil;
	end
end


-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:default_delay( val ):number

	if ( val ~= nil ) then
		self._defaults.default_delay = val;
	end

	return self._defaults.default_delay;

end

-- === XXX: XXX
--		XXX - XXX
-- RETURN: XXX = XXX
function G_data_cache:validate_id( id_cache )
	
	if ( type(id_cache) == "table" ) then
		local id_new = nil;
		if ( #id_cache > 0 ) then
			id_new = id_cache[ 1 ];

			if ( #id_cache > 1 ) then
				local id_temp = nil;
				
				for i = 2, #id_cache do
					id_temp = id_new .. G_data_cache._defaults.filter_deliniator .. id_cache[i];

					-- build filters if id does not exist
					if ( (self._caches[id_temp] == nil) and (self._caches[id_new] ~= nil) ) then

						if ( type(self._filter_list[id_cache[i]]) == "function" ) then

							-- register filter function as child with new id; nil for param
							self:register( id_temp, self._filter_list[id_cache[i]], nil, nil, id_new );

						elseif ( self._filter_default ~= nil ) then

							-- register default function as child with new id; table index for param
							self:register( id_temp, self._filter_default, id_cache[i], nil, id_new );

						end

					end

					id_new = id_temp;
				end

			end

		end

		id_cache = id_new;
	end

	return id_cache;

end


-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- SYSTEM FUNCTION: DO NOT USE OUTSIDE OF THIS SCRIPT
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
-- SYSTEM FUNCTION: DO NOT USE OUTSIDE OF THIS SCRIPT
-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
-- ŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤŤ
--[[
function test_data_cache()
	local test_cache = G_data_cache.new();

	test_cache:register( "test_01", test_data_cache_eval_01, 15 );
	test_cache:register( "test_02", test_data_cache_eval_02, nil, "test_01" );
	test_cache:register( "test_03", test_data_cache_eval_03, nil, "test_02" );

	local test_01 = nil;
	local test_02 = nil;
	local test_03 = nil;

	repeat
		test_01 = test_cache:data("test_01" );
		test_02 = test_cache:data("test_02" );
		test_03 = test_cache:data("test_03" );
		print( "A", test_01, " | ", test_02, " | ", test_03 );

		test_01 = test_cache:data("test_01", PLAYERS.player0 );
		test_02 = test_cache:data("test_02", PLAYERS.player0 );
		test_03 = test_cache:data("test_03", PLAYERS.player0 );
		print( "B", test_01, " | ", test_02, " | ", test_03 );
--		print( test_cache:data("test_01"), " | ", test_cache:data("test_02") );
		Sleep( 1 );
	until( false );

end

function test_data_cache_eval_01( id_user, data )
	print( "test_data_cache_eval_01", id_user);
	return random_range(1, 100);
end

function test_data_cache_eval_02( id_user, data )
	print( "test_data_cache_eval_02", id_user );
	return random_range(1, 100);
end

function test_data_cache_eval_03( id_user, data )
	print( "test_data_cache_eval_03", id_user );
	return random_range(1, 100);
end
]]--