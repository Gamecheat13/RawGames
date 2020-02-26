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
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) <= ai_combat_status_idle );
end

// === f_ai_is_noncombat: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_noncombat( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) <= ai_combat_status_alert );
end

// === f_ai_is_aggressive: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_aggressive( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) > ai_combat_status_alert );
end

// === f_ai_is_definate: Checks if an ai has a definate combat status
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_definate( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) >= ai_combat_status_definite );
end

// === f_ai_is_hunting: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_hunting( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) >= ai_combat_status_active ) and ( ai_combat_status(ai_test) <= ai_combat_status_certain );
end

// === f_ai_sees_enemy: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_sees_enemy( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) >= ai_combat_status_visible );
end

// === f_ai_is_dangerous: Checks if an AI is in a state
//			ai_test = AI to check
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static boolean f_ai_is_dangerous( ai ai_test )
	( ai_spawn_count (ai_test) > 0 ) and ( ai_combat_status(ai_test) == ai_combat_status_dangerous );
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
	( ai_spawn_count (ai_test) > 0 ) and ( ai_living_count (ai_test) <= 0 );
end

// === f_ai_is_partially_defeated: Checks if a squad or group has ever spawned AND has a specified number of living members
//			ai_test = AI to give magic sight to
//			s_count = Specific number of AI to test if still living
//	RETURNS:  boolean; TRUE; if group is partially defeated, FALSE; if not partially defeated
script static boolean f_ai_is_partially_defeated( ai ai_test, short s_count )
	( ai_spawn_count (ai_test) >= s_count ) and ( ai_living_count (ai_test) <= s_count );
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
// TYPE CONVERSTION
// -------------------------------------------------------------------------------------------------
// === f_object_get_squad: Gets the squad of an object
//			ai_obj = Object to get squad from
//	RETURNS:  ai; squad from the object
script static ai f_object_get_squad( object ai_obj )
	ai_get_squad( object_get_ai(ai_obj) );
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



// -------------------------------------------------------------------------------------------------
// MISC
// -------------------------------------------------------------------------------------------------
// === f_ai_magically_see_players: Gives a squad magic sight on ALL players
//			ai_test = AI to give magic sight to
//	RETURNS:  TRUE; if AI is in the state, FALSE; if not
script static void f_ai_magically_see_players( ai ai_test )
	ai_magically_see_object( ai_test, player0() );
	ai_magically_see_object( ai_test, player1() );
	ai_magically_see_object( ai_test, player2() );
	ai_magically_see_object( ai_test, player3() );
end
