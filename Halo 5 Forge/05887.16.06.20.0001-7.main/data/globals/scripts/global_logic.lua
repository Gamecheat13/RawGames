
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- MATH/NUMBER/LOGIC HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- Absolute Value - returns the absolute value of a variable
-- -------------------------------------------------------------------------------------------------
function abs_r( r_val:number ):number
	if r_val < 0 then
		return -r_val;
	else
		return r_val;
	end
end

function abs_l( l_val:number ):number
	if l_val < 0 then
		return -l_val;
	else
		return l_val;
	end
end

function abs_s( s_val:number ):number
	if s_val < 0 then
		return -s_val;
	else
		return s_val;
	end
end

-- -------------------------------------------------------------------------------------------------
-- bound - returns the value bounded by a min and max
--	r_val = value you want to bound
--	r_min = maximum value it can be
--	r_max = minimum value it can be
-- -------------------------------------------------------------------------------------------------
function bound_r( r_val:number, r_min:number, r_max:number ):number
	if r_val >= r_max then
		return r_max;
	elseif r_val <= r_min then
		return r_min;
	else
		return r_val;
	end
end

function bound_l( l_val:number, l_min:number, l_max:number ):number
	if l_val >= l_max then
		return l_max;
	elseif l_val <= l_min then
		return l_min;
	else
		return l_val;
	end
end

function bound_s( s_val:number, s_min:number, s_max:number ):number
	if s_val >= s_max then
		return s_max;
	elseif s_val <= s_min then
		return s_min;
	else
		return s_val;
	end
end

-- -------------------------------------------------------------------------------------------------
-- Greater - returns the greatest valued variable
--	r_a = variable a
--	r_b = variable b
-- -------------------------------------------------------------------------------------------------
function greater_r( r_a:number, r_b:number ):number
	if r_a >= r_b then
		return r_a;
	else
		return r_b;
	end
end

function greater_l( l_a:number, l_b:number ):number
	if l_a >= l_b then
		return l_a;
	else
		return l_b;
	end
end

function greater_s( s_a:number, s_b:number ):number
	if s_a >= s_b then
		return s_a;
	else
		return s_b;
	end
end

-- -------------------------------------------------------------------------------------------------
-- Lower - returns the lowest valued variable
--	r_a = variable a
--	r_b = variable b
-- -------------------------------------------------------------------------------------------------
function lower_r( r_a:number, r_b:number ):number
	if r_a <= r_b then
		return r_a;
	else
		return r_b;
	end
end

function lower_l( l_a:number, l_b:number ):number
	if l_a <= l_b then
		return l_a;
	else
		return l_b;
	end
end

function lower_s( s_a:number, s_b:number ):number
	if s_a <= s_b then
		return s_a;
	else
		return s_b;
	end
end

-- -------------------------------------------------------------------------------------------------
-- if_else_# - returns the first parameter if the condition is true and the second if not
--	b_condition = condition to check
--	<type>_if = variable to return if true
--	<type>_else = variable to return if true
-- -------------------------------------------------------------------------------------------------
function if_else_r( b_condition:boolean, r_if:number, r_else:number ):number
	if b_condition then
		return r_if;
	else
		return r_else;
	end
end

function if_else_s( b_condition:boolean, s_if:number, s_else:number ):number
	if b_condition then
		return s_if;
	else
		return s_else;
	end
end

function if_else_l( b_condition:boolean, l_if:number, l_else:number ):number
	if b_condition then
		return l_if;
	else
		return l_else;
	end
end

function if_else_obj( b_condition:boolean, obj_if:object, obj_else:object ):object
	if b_condition then
		return obj_if;
	else
		return obj_else;
	end
end

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
function range_check( r_x:number, r_min:number, r_max:number ):boolean
	if r_min <= r_max then
		return r_min <= r_x and r_x <= r_max;
	else
		return range_check(r_x, r_max, r_min);
	end
end



-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
function math.round( n, mult )
    mult = mult or 1;
    return math.floor( (n + mult/2)/mult) * mult;
end

-- Will run functionName with the given parameter on the server and every client.
function RunOnServerAndAllClients(functionName:string, ...)
	if (IsServer()) then
--## SERVER
		_G.RunClientScript(functionName, ...);
--## COMMON
        -- No local player? Probably dedicated server, so we need to run the function
        -- locally. Here we are trying to not run 'functionName' twice. This isn't
        -- perfect.
        if (PLAYERS.local0 == nil) then		
	        _G[functionName](...);
        end
	else
--## CLIENT
		RunServerScript("RunOnServerAndAllClients", functionName, ...);
--## COMMON
	end
end

--## SERVER

remoteServer["RunOnServerAndAllClients"] = RunOnServerAndAllClients
