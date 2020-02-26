// =================================================================================================
// =================================================================================================
// =================================================================================================
// PHYSICS HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// SET VELOCITY
// -------------------------------------------------------------------------------------------------
// === objlist_setvelocity_rand: Sets a random X, Y, & Z velocity for each object in the object list
//			ol_list = object list to apply velocity to
//			r_x_min = x velocity minimum
//			r_x_max = x velocity maximum
//			r_y_min = y velocity minimum
//			r_y_max = y velocity maximum
//			r_z_min = z velocity minimum
//			r_z_max = z velocity maximum
//	RETURNS:  short; the number of objects velocity was applied to
script static short objlist_setvelocity_rand( object_list ol_list, real r_x_min, real r_x_max, real r_y_min, real r_y_max, real r_z_min, real r_z_max )
local long s_index = 0;									// index
local long s_cnt = 0;										// count

	s_index = list_count( ol_list );
	if ( s_index > 0 ) then
	
		repeat
			s_index = s_index - 1;
			if ( list_get(ol_list, s_index) != NONE ) then
				object_wake_physics( list_get(ol_list, s_index) );
				object_set_velocity( list_get(ol_list, s_index), real_random_range(r_x_min,r_x_max), real_random_range(r_y_min,r_y_max), real_random_range(r_z_min,r_z_max) );
				s_cnt = s_cnt + 1;
			end
		until ( s_index <= 0, 1 );
	
	end

	// RETURN
	s_cnt;

end

// === objlist_setvelocity: Sets a X, Y, & Z velocity for each object in the object list
//			ol_list = object list to apply velocity to
//			r_x = x velocity
//			r_y = y velocity
//			r_z = z velocity
//	RETURNS:  short; the number of objects velocity was applied to
script static short objlist_setvelocity( object_list ol_list, real r_x, real r_y, real r_z )
	objlist_setvelocity_rand( ol_list, r_x, r_x, r_y, r_y, r_z, r_z );
end

// === triggerobjs_setvelocity_rand: Sets a random X, Y, & Z velocity for each object inside the trigger volume of the specified type
//			tv_volume = Trigger volume to collect objects in
//			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
//				[i_objtypes == 0] = All types
//			r_x_min = x velocity minimum
//			r_x_max = x velocity maximum
//			r_y_min = y velocity minimum
//			r_y_max = y velocity maximum
//			r_z_min = z velocity minimum
//			r_z_max = z velocity maximum
//	RETURNS:  short; the number of objects velocity was applied to
script static short triggerobjs_setvelocity_rand( trigger_volume tv_volume, short i_objtypes, real r_x_min, real r_x_max, real r_y_min, real r_y_max, real r_z_min, real r_z_max )
	objlist_setvelocity_rand( volume_return_objects_by_type(tv_volume, i_objtypes), r_x_min, r_x_max, r_y_min, r_y_max, r_z_min, r_z_max );
end

// === triggerobjs_setvelocity: Sets a X, Y, & Z velocity for each object inside the trigger volume of the specified type
//			tv_volume = Trigger volume to collect objects in
//			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
//				[i_objtypes == 0] = All types
//			r_x = x velocity
//			r_y = y velocity
//			r_z = z velocity
//	RETURNS:  short; the number of objects velocity was applied to
script static short triggerobjs_setvelocity( trigger_volume tv_volume, short i_objtypes, real r_x, real r_y, real r_z )
	objlist_setvelocity( volume_return_objects_by_type(tv_volume, i_objtypes), r_x, r_y, r_z );
end



// -------------------------------------------------------------------------------------------------
// WAKE PHYSICS
// -------------------------------------------------------------------------------------------------
// === objlist_wakephysics: Wakes physics on all objects in an object list
//			ol_list = object list to wake physics
//	RETURNS:  short; the number of objects physics were woken up on
script static short objlist_wakephysics( object_list ol_list )
local short s_index = 0;									// index
local long s_cnt = 0;											// count

	s_index = list_count( ol_list );
	if ( s_index > 0 ) then

		repeat
			s_index = s_index - 1;
			if ( list_get(ol_list, s_index) != NONE ) then
				object_wake_physics( list_get(ol_list, s_index) );
				s_cnt = s_cnt + 1;
			end
		until ( s_index <= 0, 0 );

	end
	
	// RETURN
	s_cnt;

end

// === triggerobjs_wakephysics: Wake physics for each object inside the trigger volume of the specified type
//			tv_volume = Trigger volume to collect objects in
//			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
//				[i_objtypes == 0] = All types
//	RETURNS:  short; the number of objects physics were woken up on
script static short triggerobjs_wakephysics( trigger_volume tv_volume, short i_objtypes )
	objlist_wakephysics( volume_return_objects_by_type(tv_volume, i_objtypes) );
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// GRAVITY
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// TRANSITION GRAVITY
// -------------------------------------------------------------------------------------------------
// variables
global real	DEF_GRAVITY_CURRENT			= -666.0;

// functions
// === transition_gravity: Transitions gravity over time
//			r_gravity_start = starting gravity value; currently there is no way to get your current gravity value
//				[r_gravity_start == DEF_GRAVITY_CURRENT] Sets the starting gravity to the current gravity
//			r_gravity_end = final gravity value
//				[r_gravity_end == DEF_GRAVITY_CURRENT] Sets the ending gravity to the current gravity
//			r_seconds = number of seconds the gravity transition should take place
//			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
//	RETURNS:  void
script static void transition_gravity( real r_gravity_start, real r_gravity_end, real r_seconds, short s_refresh )
static long l_sys_transition_gravity = 0;

	if ( l_sys_transition_gravity != 0 ) then
		kill_thread( l_sys_transition_gravity );
	end
	
	l_sys_transition_gravity = thread( sys_transition_gravity(r_gravity_start, r_gravity_end, r_seconds, s_refresh) );

end
// === sys_transition_gravity: System function for transition_gravity
//			NOTE: DO NOT USE THIS FUNCTION
script static void sys_transition_gravity( real r_gravity_start, real r_gravity_end, real r_seconds, short s_refresh )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_gravity_range = 0.0;
static real r_gravity_delta = 0.0;
static real r_time_range = 0.0;

	// defaults
	if ( r_gravity_start == DEF_GRAVITY_CURRENT ) then
		r_gravity_start = physics_get_gravity();
	end
	if ( r_gravity_end == DEF_GRAVITY_CURRENT ) then
		r_gravity_end = physics_get_gravity();
	end

	// get start time	
	l_time_start = game_tick_get();

	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_seconds );

	// setup variables
	r_gravity_range = r_gravity_end - r_gravity_start;
	r_time_range = l_time_end - l_time_start;
	
	if ( (r_gravity_range > 0.001) and (r_time_range > 0.001) ) then
		repeat
			r_gravity_delta = real( game_tick_get()-l_time_start ) / r_time_range;
			// set gravity to the current % of time progress
			physics_set_gravity( r_gravity_start + (r_gravity_range * r_gravity_delta) );
		until ( game_tick_get() >= l_time_end, s_refresh );
	end
	physics_set_gravity( r_gravity_end );

end

// -------------------------------------------------------------------------------------------------
// OBJECT SET GRAVITY
// -------------------------------------------------------------------------------------------------
// === objlist_setgravity_rand: Applies random gravity on all objects in an object list
//			ol_list = object list to apply gravity
//			r_gravity_min = Minimum gravity to set on the object
//			r_gravity_max = Maximum gravity to set on the object
//			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
//	RETURNS:  short; the number of objects gravity was changed on
script static short objlist_setgravity_rand( object_list ol_list, real r_gravity_min, real r_gravity_max, boolean b_inherit )
local short s_index = 0;									// index
local long s_cnt = 0;											// count

	s_index = list_count( ol_list );
	if ( s_index > 0 ) then

		repeat
			s_index = s_index - 1;
			if ( list_get(ol_list, s_index) != NONE ) then
				object_set_gravity( list_get(ol_list, s_index), real_random_range(r_gravity_min,r_gravity_max), b_inherit );
				s_cnt = s_cnt + 1;
			end
		until ( s_index <= 0, 0 );

	end
	
	// RETURN
	s_cnt;

end

// === objlist_setgravity: Applies gravity on all objects in an object list
//			ol_list = object list to apply gravity
//			r_gravity = Gravity to set on the objects
//			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
//	RETURNS:  short; the number of objects gravity was changed on
script static short objlist_setgravity( object_list ol_list, real r_gravity, boolean b_inherit )
	objlist_setgravity_rand( ol_list, r_gravity, r_gravity, b_inherit );
end

// === triggerobjs_setgravity_rand: Applies random gravity on all objects inside the trigger volume of the specified type
//			tv_volume = Trigger volume to collect objects in
//			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
//				[i_objtypes == 0] = All types
//			r_gravity_min = Minimum gravity to set on the object
//			r_gravity_max = Maximum gravity to set on the object
//			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
//	RETURNS:  short; the number of objects gravity was changed on
script static short triggerobjs_setgravity_rand( trigger_volume tv_volume, short i_objtypes, real r_gravity_min, real r_gravity_max, boolean b_inherit )
	objlist_setgravity_rand( volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity_min, r_gravity_max, b_inherit );
end

// === triggerobjs_setgravity: Applies gravity on all objects inside the trigger volume of the specified type
//			tv_volume = Trigger volume to collect objects in
//			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
//				[i_objtypes == 0] = All types
//			r_gravity = Gravity to set on the objects
//			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
//	RETURNS:  short; the number of objects gravity was changed on
script static short triggerobjs_setgravity( trigger_volume tv_volume, short i_objtypes, real r_gravity, boolean b_inherit )
	objlist_setgravity_rand( volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity, r_gravity, b_inherit );
end
