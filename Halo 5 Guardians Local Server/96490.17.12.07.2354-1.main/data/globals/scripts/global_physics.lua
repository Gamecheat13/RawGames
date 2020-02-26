
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- PHYSICS HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- SET VELOCITY
-- -------------------------------------------------------------------------------------------------
-- === objlist_setvelocity_rand: Sets a random X, Y, & Z velocity for each object in the object list
--			ol_list = object list to apply velocity to
--			r_x_min = x velocity minimum
--			r_x_max = x velocity maximum
--			r_y_min = y velocity minimum
--			r_y_max = y velocity maximum
--			r_z_min = z velocity minimum
--			r_z_max = z velocity maximum
--	RETURNS:  short; the number of objects velocity was applied to
function objlist_setvelocity_rand( ol_list:object_list, r_x_min:number, r_x_max:number, r_y_min:number, r_y_max:number, r_z_min:number, r_z_max:number ):number
	local s_index:number=0;
	local s_cnt:number=0;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(1);
			s_index = s_index - 1;
			if list_get(ol_list, s_index)~=nil then
				object_wake_physics(list_get(ol_list, s_index));
				object_set_velocity(list_get(ol_list, s_index), real_random_range(r_x_min, r_x_max), real_random_range(r_y_min, r_y_max), real_random_range(r_z_min, r_z_max));
				s_cnt = s_cnt + 1;
			end
		until s_index <= 0;
	end
	return s_cnt;
end

-- RETURN
-- === objlist_setvelocity: Sets a X, Y, & Z velocity for each object in the object list
--			ol_list = object list to apply velocity to
--			r_x = x velocity
--			r_y = y velocity
--			r_z = z velocity
--	RETURNS:  short; the number of objects velocity was applied to
function objlist_setvelocity( ol_list:object_list, r_x:number, r_y:number, r_z:number ):number
	return objlist_setvelocity_rand(ol_list, r_x, r_x, r_y, r_y, r_z, r_z);
end

-- === triggerobjs_setvelocity_rand: Sets a random X, Y, & Z velocity for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_x_min = x velocity minimum
--			r_x_max = x velocity maximum
--			r_y_min = y velocity minimum
--			r_y_max = y velocity maximum
--			r_z_min = z velocity minimum
--			r_z_max = z velocity maximum
--	RETURNS:  short; the number of objects velocity was applied to
function triggerobjs_setvelocity_rand( tv_volume:volume, i_objtypes:number, r_x_min:number, r_x_max:number, r_y_min:number, r_y_max:number, r_z_min:number, r_z_max:number ):number
	return objlist_setvelocity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_x_min, r_x_max, r_y_min, r_y_max, r_z_min, r_z_max);
end

-- === triggerobjs_setvelocity: Sets a X, Y, & Z velocity for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_x = x velocity
--			r_y = y velocity
--			r_z = z velocity
--	RETURNS:  short; the number of objects velocity was applied to
function triggerobjs_setvelocity( tv_volume:volume, i_objtypes:number, r_x:number, r_y:number, r_z:number ):number
	return objlist_setvelocity(volume_return_objects_by_type(tv_volume, i_objtypes), r_x, r_y, r_z);
end

-- -------------------------------------------------------------------------------------------------
-- WAKE PHYSICS
-- -------------------------------------------------------------------------------------------------
-- === objlist_wakephysics: Wakes physics on all objects in an object list
--			ol_list = object list to wake physics
--	RETURNS:  short; the number of objects physics were woken up on
function objlist_wakephysics( ol_list:object_list ):number
	local s_index:number=0;
	local s_cnt:number=0;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if list_get(ol_list, s_index)~=nil then
				object_wake_physics(list_get(ol_list, s_index));
				s_cnt = s_cnt + 1;
			end
		until s_index <= 0;
	end
	return s_cnt;
end

-- RETURN
-- === triggerobjs_wakephysics: Wake physics for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--	RETURNS:  short; the number of objects physics were woken up on
function triggerobjs_wakephysics( tv_volume:volume, i_objtypes:number ):number
	return objlist_wakephysics(volume_return_objects_by_type(tv_volume, i_objtypes));
end
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- GRAVITY
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- TRANSITION GRAVITY
-- -------------------------------------------------------------------------------------------------
-- variables
global def_gravity_current:number=-666;

-- functions
-- === transition_gravity: Transitions gravity over time
--			r_gravity_start = starting gravity value; currently there is no way to get your current gravity value
--				[r_gravity_start == DEF_GRAVITY_CURRENT] Sets the starting gravity to the current gravity
--			r_gravity_end = final gravity value
--				[r_gravity_end == DEF_GRAVITY_CURRENT] Sets the ending gravity to the current gravity
--			r_seconds = number of seconds the gravity transition should take place
--			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
--	RETURNS:  void
function transition_gravity( r_gravity_start:number, r_gravity_end:number, r_seconds:number, s_refresh:number ):void
	if l_sys_transition_gravity_14875722~=nil then
		KillThread(l_sys_transition_gravity_14875722);
	end
	l_sys_transition_gravity_14875722 = CreateThread(sys_transition_gravity, r_gravity_start, r_gravity_end, r_seconds, s_refresh);
end
global l_sys_transition_gravity_14875722:thread=nil;

-- === sys_transition_gravity: System function for transition_gravity
--			NOTE: DO NOT USE THIS FUNCTION
function sys_transition_gravity( r_gravity_start:number, r_gravity_end:number, r_seconds:number, s_refresh:number ):void
	-- defaults
	if r_gravity_start == def_gravity_current then
		r_gravity_start = physics_get_gravity();
	end
	if r_gravity_end == def_gravity_current then
		r_gravity_end = physics_get_gravity();
	end
	-- get start time	
	l_time_start_55df5b94 = game_tick_get();
	-- get end time	
	l_time_end_55df5b94 = l_time_start_55df5b94 + seconds_to_frames(r_seconds);
	-- setup variables
	r_gravity_range_55df5b94 = r_gravity_end - r_gravity_start;
	r_time_range_55df5b94 = l_time_end_55df5b94 - l_time_start_55df5b94;
	if r_gravity_range_55df5b94 > 0.001 and r_time_range_55df5b94 > 0.001 then
		repeat
			Sleep(s_refresh);
			r_gravity_delta_55df5b94 = (game_tick_get() - l_time_start_55df5b94) / r_time_range_55df5b94;
			-- set gravity to the current % of time progress
			physics_set_gravity(r_gravity_start + r_gravity_range_55df5b94 * r_gravity_delta_55df5b94);
		until game_tick_get() >= l_time_end_55df5b94;
	end
	physics_set_gravity(r_gravity_end);
end
global l_time_start_55df5b94:number=0;
global l_time_end_55df5b94:number=0;
global r_gravity_range_55df5b94:number=0.0;
global r_gravity_delta_55df5b94:number=0.0;
global r_time_range_55df5b94:number=0.0;

-- -------------------------------------------------------------------------------------------------
-- OBJECT SET GRAVITY
-- -------------------------------------------------------------------------------------------------
-- === objlist_setgravity_rand: Applies random gravity on all objects in an object list
--			ol_list = object list to apply gravity
--			r_gravity_min = Minimum gravity to set on the object
--			r_gravity_max = Maximum gravity to set on the object
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function objlist_setgravity_rand( ol_list:object_list, r_gravity_min:number, r_gravity_max:number, b_inherit:boolean ):number
	local s_index:number=0;
	local s_cnt:number=0;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if list_get(ol_list, s_index)~=nil then
				object_set_gravity(list_get(ol_list, s_index), real_random_range(r_gravity_min, r_gravity_max), b_inherit);
				s_cnt = s_cnt + 1;
			end
		until s_index <= 0;
	end
	return s_cnt;
end

-- RETURN
-- === objlist_setgravity: Applies gravity on all objects in an object list
--			ol_list = object list to apply gravity
--			r_gravity = Gravity to set on the objects
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function objlist_setgravity( ol_list:object_list, r_gravity:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(ol_list, r_gravity, r_gravity, b_inherit);
end

-- === triggerobjs_setgravity_rand: Applies random gravity on all objects inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_gravity_min = Minimum gravity to set on the object
--			r_gravity_max = Maximum gravity to set on the object
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function triggerobjs_setgravity_rand( tv_volume:volume, i_objtypes:number, r_gravity_min:number, r_gravity_max:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity_min, r_gravity_max, b_inherit);
end

-- === triggerobjs_setgravity: Applies gravity on all objects inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_gravity = Gravity to set on the objects
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function triggerobjs_setgravity( tv_volume:volume, i_objtypes:number, r_gravity:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity, r_gravity, b_inherit);
end
