// =================================================================================================
// =================================================================================================
// =================================================================================================
// MATH/NUMBER/LOGIC HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// Absolute Value - returns the absolute value of a variable
// -------------------------------------------------------------------------------------------------
script static real abs_r( real r_val )
	if ( r_val < 0 ) then
		-r_val;
	else
		r_val;
	end
end

script static long abs_l( long l_val )
	if ( l_val < 0 ) then
		-l_val;
	else
		l_val;
	end
end

script static short abs_s( short s_val )
	if ( s_val < 0 ) then
		-s_val;
	else
		s_val;
	end
end

// -------------------------------------------------------------------------------------------------
// bound - returns the value bounded by a min and max
//	r_val = value you want to bound
//	r_min = maximum value it can be
//	r_max = minimum value it can be
// -------------------------------------------------------------------------------------------------
script static real bound_r( real r_val, real r_min, real r_max )
	if ( r_val >= r_max ) then
		r_max;
	elseif ( r_val <= r_min ) then
		r_min;
	else
		r_val;
	end
end

script static real bound_l( real l_val, real l_min, real l_max )
	if ( l_val >= l_max ) then
		l_max;
	elseif ( l_val <= l_min ) then
		l_min;
	else
		l_val;
	end
end

script static real bound_s( real s_val, real s_min, real s_max )
	if ( s_val >= s_max ) then
		s_max;
	elseif ( s_val <= s_min ) then
		s_min;
	else
		s_val;
	end
end

// -------------------------------------------------------------------------------------------------
// Greater - returns the greatest valued variable
//	r_a = variable a
//	r_b = variable b
// -------------------------------------------------------------------------------------------------
script static real greater_r( real r_a, real r_b )
	if ( r_a >= r_b ) then
		r_a;
	else
		r_b;
	end
end

script static real greater_l( real l_a, real l_b )
	if ( l_a >= l_b ) then
		l_a;
	else
		l_b;
	end
end

script static real greater_s( real s_a, real s_b )
	if ( s_a >= s_b ) then
		s_a;
	else
		s_b;
	end
end

// -------------------------------------------------------------------------------------------------
// Lower - returns the lowest valued variable
//	r_a = variable a
//	r_b = variable b
// -------------------------------------------------------------------------------------------------
script static real lower_r( real r_a, real r_b )
	if ( r_a <= r_b ) then
		r_a;
	else
		r_b;
	end
end
script static real lower_l( real l_a, real l_b )
	if ( l_a <= l_b ) then
		l_a;
	else
		l_b;
	end
end
script static real lower_s( real s_a, real s_b )
	if ( s_a <= s_b ) then
		s_a;
	else
		s_b;
	end
end

// -------------------------------------------------------------------------------------------------
// if_else_# - returns the first parameter if the condition is true and the second if not
//	b_condition = condition to check
//	<type>_if = variable to return if true
//	<type>_else = variable to return if true
// -------------------------------------------------------------------------------------------------
script static real if_else_r( boolean b_condition, real r_if, real r_else )
	if ( b_condition ) then
		r_if;
	else
		r_else;
	end
end
script static short if_else_s( boolean b_condition, short s_if, short s_else )
	if ( b_condition ) then
		s_if;
	else
		s_else;
	end
end
script static long if_else_l( boolean b_condition, long l_if, long l_else )
	if ( b_condition ) then
		l_if;
	else
		l_else;
	end
end
script static object if_else_obj( boolean b_condition, object obj_if, object obj_else )
	if ( b_condition ) then
		obj_if;
	else
		obj_else;
	end
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
script static boolean range_check( real r_X, real r_min, real r_max )
	if ( r_min <= r_max ) then
		( r_min <= r_X ) and ( r_X <= r_max );
	else
		range_check( r_X, r_max, r_min );
	end
end
