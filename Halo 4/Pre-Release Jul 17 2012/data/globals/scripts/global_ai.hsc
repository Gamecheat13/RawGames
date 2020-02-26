// =================================================================================================
// =================================================================================================
// =================================================================================================
// AI HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// COMBAT STATUS
// -------------------------------------------------------------------------------------------------
/*
ai_combat_status_asleep				= 0;	asleep, braindead, etc.
ai_combat_status_idle					= 1;	no action
ai_combat_status_alert				= 2;	disregarded all orphans, or have none (postcombat)
ai_combat_status_active				= 3;	orphans in the area OR scripted to belive so
ai_combat_status_un//inspected	= 4;	we have an orphan that we have not yet //inspected
ai_combat_status_definite			= 5;	enemy whose location is definitely known (maybe not by us though)
ai_combat_status_certain			= 6;	enemy whose location we are certain about
ai_combat_status_visible			= 7;	enemy that we can see
ai_combat_status_clear_los		= 8;	enemy that we have a clear line-of-sight to
ai_combat_status_dangerous		= 9;	enemy who poses a threat to us
*/

// === f_ai_is_idle: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_idle( ai ai_test )
	( ai_combat_status(ai_test) <= ai_combat_status_idle ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_is_noncombat: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_noncombat( ai ai_test )
	( ai_combat_status(ai_test) <= ai_combat_status_alert ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_is_aggressive: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_aggressive( ai ai_test )
	( ai_combat_status(ai_test) > ai_combat_status_alert ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_is_definate: Checks if an ai has a definate combat status
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_definate( ai ai_test )
	( ai_combat_status(ai_test) >= ai_combat_status_definite ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_is_hunting: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_hunting( ai ai_test )
	( ai_combat_status(ai_test) >= ai_combat_status_active ) and ( ai_combat_status(ai_test) <= ai_combat_status_certain ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_sees_enemy: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_sees_enemy( ai ai_test )
	( ai_combat_status(ai_test) >= ai_combat_status_visible ) and ( ai_spawn_count (ai_test) > 0 );
end

// === f_ai_is_dangerous: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_dangerous( ai ai_test )
	( ai_combat_status(ai_test) == ai_combat_status_dangerous ) and ( ai_spawn_count (ai_test) > 0 );
end



// -------------------------------------------------------------------------------------------------
// SQUAD STATUS
// -------------------------------------------------------------------------------------------------
// === f_ai_has_spawned: Checks to see if an ai group has spawned
//			ai_test = AI group to test
//	RETURNS:  boolean; TRUE; if group has spawned, FALSE; if group has not spawned
script static boolean f_ai_has_spawned( ai ai_test )
	ai_spawn_count( ai_test ) > 0;
end

// === f_ai_is_defeated: Checks if a squad or group has ever spawned AND has no living members left
//			ai_test = AI group to test
//	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
script static boolean f_ai_is_defeated( ai ai_test )
	( ai_living_count(ai_test) <= 0 ) and ( ai_spawn_count(ai_test) > 0 );
end

// === f_ai_is_partially_defeated: Checks if a squad or group has ever spawned AND has a specified number of living members
//			ai_test = AI to give magic sight to
//			s_count = Specific number of AI to test if still living
//	RETURNS:  boolean; TRUE; if group is partially defeated, FALSE; if not partially defeated
script static boolean f_ai_is_partially_defeated( ai ai_test, short s_count )
	( ai_living_count(ai_test) <= s_count ) and ( ai_spawn_count(ai_test) >= s_count );
end

// === f_ai_killed_cnt: Gets the count of AI that has been killed in the task
//			ai_test = AI group to test
//	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
script static short f_ai_killed_cnt( ai ai_test )
	ai_spawn_count( ai_test ) - ai_living_count( ai_test );
end


// -------------------------------------------------------------------------------------------------
// TASK
// -------------------------------------------------------------------------------------------------
// === f_task_is_empty: Checks if if a task is empty or not
//			ai_task = task to check
//	RETURNS:  boolean; TRUE; if task is empty, FALSE; if the task is not
script static boolean f_task_is_empty( ai ai_task )
	ai_task_count( ai_task ) <= 0;
end

// === f_task_has_actors: Checks if a task has anyone in it
//			ai_task = task to check
//	RETURNS:  boolean; TRUE, if the task has actors, FALSE; task is empty
script static boolean f_task_has_actors( ai ai_task )
	ai_task_count( ai_task ) > 0;
end



// -------------------------------------------------------------------------------------------------
// TYPE CONVERSION
// -------------------------------------------------------------------------------------------------
// === f_object_get_squad: Gets the squad of an object
//			ai_obj = Object to get squad from
//	RETURNS:  ai; squad from the object
script static ai f_object_get_squad( object ai_obj )
	ai_get_squad( object_get_ai(ai_obj) );
end


// -------------------------------------------------------------------------------------------------
// GARBAGE
// -------------------------------------------------------------------------------------------------

// TYPES
script static short DEF_AI_CLEANUP_TYPE_ERASE()									00;		end
script static short DEF_AI_CLEANUP_TYPE_KILL()									01;		end

static real R_ai_garbage_distance_min_default = 								22.5;
static real R_ai_garbage_see_degrees_default = 									100.0;
static short S_ai_garbage_delay_squad_default = 								30;
static short S_ai_garbage_delay_unit_default = 									1;

// === f_ai_garbage: "Cleans up" AI based on parameters provided and stops once there is no longer any living AI in the squad
//			ai_squad = Squad to cleanup
//			s_type = Type of action to perform on the AI
//				NOTE: SEE TYPE DEFINITIONS ABOVE
//			r_distance_min = Minimum distance the AI must be from a player
//				[ < 0; Default tuned distance ]
//			r_see_degrees = Number of degrees from player LOS to make sure the AI is not within 
//				[ < 0; Default tuned degrees ]
//			l_delay_squad = Delay (ticks) between looping back on the squad again
//				[ < 0; Default delay between squad loops ]
//			l_delay_unit = Delay (ticks) between each unit
//				[ < 0; Default delay between unit loops ]
//			b_garbage_squad = TRUE; will automatically garbage collect after each squad loop
//	RETURNS:  long; thread id of the cleanup event
script static long f_ai_garbage( ai ai_squad, short s_type, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )

	// defaults
	if ( r_distance_min < 0 ) then
		r_distance_min = ai_garbage_distance_min_default_get();
	end
	if ( r_see_degrees < 0 ) then 
		r_see_degrees = ai_garbage_see_degrees_default_get();
	end
	if ( l_delay_squad < 0 ) then
		l_delay_squad = ai_garbage_delay_squad_default_get();
	end
	if ( l_delay_unit < 0 ) then
		l_delay_unit = ai_garbage_delay_unit_default_get();
	end

	thread( sys_ai_garbage(ai_squad, s_type, r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad) );
end

script static long f_ai_garbage_erase( ai ai_squad, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad );
end
script static long f_ai_garbage_kill( ai ai_squad, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_KILL(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad );
end


// === sys_ai_garbage: Manages f_ai_garbage
//			NOTE: DO NOT USE!!!
script static void sys_ai_garbage( ai ai_squad, short s_type, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )

	repeat

		if ( ai_living_count(ai_squad) > 0 ) then
			sys_ai_garbage_objlist( ai_actors(ai_squad), s_type, r_distance_min, r_see_degrees, l_delay_unit );
		end
		
		if ( b_garbage_squad ) then
			garbage_collect_now();
		end
		
	until( ai_living_count(ai_squad) <= 0, l_delay_squad );

end
// === sys_ai_garbage_objlist: Manages list of actors from sys_ai_garbage
//			NOTE: DO NOT USE!!!
script static void sys_ai_garbage_objlist( object_list ol_list, short s_type, real r_distance_min, real r_see_degrees, long l_delay_unit )
local short s_index = list_count( ol_list );
local object obj_object = NONE;

	// loop through all the units in the squad
	repeat
		s_index = s_index - 1;
		obj_object = list_get( ol_list, s_index );
		
		// check to make sure the object meets the criteria
		if ( (obj_object != NONE) and (object_get_health(obj_object) > 0.0) and (objects_distance_to_object(Players(), obj_object) >= r_distance_min) and (not objects_can_see_object(Players(), obj_object, r_see_degrees)) and (not objects_can_see_object(obj_object, Player0(), r_see_degrees))and (not objects_can_see_object(obj_object, Player1(), r_see_degrees))and (not objects_can_see_object(obj_object, Player2(), r_see_degrees))and (not objects_can_see_object(obj_object, Player3(), r_see_degrees)) ) then
		
			// apply unit garbage type
			if ( s_type == DEF_AI_CLEANUP_TYPE_ERASE() ) then
				//dprint( "sys_ai_garbage_objlist: ERASE" );
				ai_erase( object_get_ai(obj_object) );
			elseif ( s_type == DEF_AI_CLEANUP_TYPE_KILL() ) then
				//dprint( "sys_ai_garbage_objlist: KILLED" );
				ai_kill_no_statistics( object_get_ai(obj_object) );
			else
				breakpoint( "sys_ai_cleanup: TYPE UNKNOWN" );
				inspect( s_type );
				sleep( 1 );
			end
			
		end
		
	until( s_index <= 0, l_delay_unit );

end

script static void ai_garbage_distance_min_default_set( real r_val )
	R_ai_garbage_distance_min_default = r_val;
end
script static real ai_garbage_distance_min_default_get()
	R_ai_garbage_distance_min_default;
end

script static void ai_garbage_see_degrees_default_set( real r_val )
	R_ai_garbage_see_degrees_default = r_val;
end
script static real ai_garbage_see_degrees_default_get()
	R_ai_garbage_see_degrees_default;
end

script static void ai_garbage_delay_squad_default_set( short s_val )
	S_ai_garbage_delay_squad_default = s_val;
end
script static short ai_garbage_delay_squad_default_get()
	S_ai_garbage_delay_squad_default;
end

script static void ai_garbage_delay_unit_default_set( short s_val )
	S_ai_garbage_delay_unit_default = s_val;
end
script static short ai_garbage_delay_unit_default_get()
	S_ai_garbage_delay_unit_default;
end



// -------------------------------------------------------------------------------------------------
// ObjList Kill AI
// -------------------------------------------------------------------------------------------------
script static short objlist_kill_ai( object_list ol_list, boolean b_count_kill_stats )
local short s_index = list_count( ol_list );
local object obj_object = NONE;
local short s_applied = 0;

	if ( s_index > 0 ) then
	
		repeat
		
			s_index = s_index - 1;
			obj_object = list_get( ol_list, s_index );
		
			if ( (obj_object != NONE) and (object_get_health(obj_object) > 0.0) ) then
				if ( b_count_kill_stats ) then
					ai_kill( object_get_ai(obj_object) );
				else
					ai_kill_no_statistics( object_get_ai(obj_object) );
				end
				s_applied = s_applied + 1;
			end
			
		until( s_index <= 0, 1 );
		
	end

	// return
	s_applied;
	
end
	
script static short triggerobjs_kill_ai( trigger_volume tv_volume, boolean b_count_kill_stats )
	objlist_kill_ai( volume_return_objects_by_type(tv_volume, s_objtype_biped), b_count_kill_stats );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AI: SPAWN DELAY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long 	L_ai_spawn_timer = 										0;
global short 	L_ai_spawn_delay_default = 						5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_ai_spawn_delay_start::: Starts the spawn delay timer
script static void f_ai_spawn_delay_start( short s_delay )
	//dprint( "::: f_ai_spawn_delay_start :::" );

	// defaults
	if ( s_delay < 0 ) then
		s_delay = f_ai_spawn_delay_default_get();
	end

	// set the timer
	L_ai_spawn_timer = game_tick_get() + s_delay;

end

// === f_ai_spawn_delay_default_get::: Gets the default spawn delay timer value
script static short f_ai_spawn_delay_default_get()
	L_ai_spawn_delay_default;
end

// === f_ai_spawn_delay_default_set::: Sets the default spawn delay timer value
script static void f_ai_spawn_delay_default_set( short s_val )
	//dprint( "::: f_ai_spawn_delay_default_set :::" );
	L_ai_spawn_delay_default = s_val;
end

// === f_ai_spawn_delay_check::: Checks the spawn delay timer
script static boolean f_ai_spawn_delay_check()
	L_ai_spawn_timer <= game_tick_get();
end

// === f_ai_spawn_delay_wait::: Waits for spawn delay and can reset
script static void f_ai_spawn_delay_wait( boolean b_reset, short s_reset_delay )

	//dprint( "::: f_ai_spawn_delay_wait :::" );
	sleep_until( f_ai_spawn_delay_check(), 1 );
	//dprint( "::: f_ai_spawn_delay_wait: TRIGGERED :::" );
	if ( b_reset ) then
		//dprint( "::: f_ai_spawn_delay_wait: RESET :::" );
		f_ai_spawn_delay_start( s_reset_delay );
	end
	
end


// -------------------------------------------------------------------------------------------------
// MISC
// -------------------------------------------------------------------------------------------------
// === f_ai_magically_see_players: Gives a squad magic sight on ALL players
//			ai_test = AI to give magic sight to
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static void f_ai_magically_see_players( ai ai_test )
	ai_magically_see_object( ai_test, player0 );
	ai_magically_see_object( ai_test, player1 );
	ai_magically_see_object( ai_test, player2 );
	ai_magically_see_object( ai_test, player3 );
end

// === f_ai_sees_player: Checks if an AI can see a player
//			ai_test = AI to check
//			r_angle = Angle of sight check
//	RETURNS:  TRUE; if AI sees a player
script static boolean f_ai_sees_player( ai ai_test, real r_angle )
	objects_can_see_object( ai_get_object(ai_test), Player0, r_angle ) or objects_can_see_object( ai_get_object(ai_test), Player1, r_angle ) or objects_can_see_object( ai_get_object(ai_test), Player2, r_angle ) or objects_can_see_object( ai_get_object(ai_test), Player3, r_angle );
end