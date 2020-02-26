--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- AI HELPERS

--- == places AI and returns the ai that is spawned
-- RETURNS: the ai that is placed
function ai_place_return(ai_var:ai):ai
	ai_place (ai_var);
	return ai_var;
end
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- COMBAT STATUS
-- -------------------------------------------------------------------------------------------------
--[[
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
]]
-- === f_ai_is_idle: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_idle( ai_test:ai ):boolean
	return ai_combat_status(ai_test) <= ai_combat_status_idle and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_noncombat: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_noncombat( ai_test:ai ):boolean
	return ai_combat_status(ai_test) <= ai_combat_status_alert and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_aggressive: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_aggressive( ai_test:ai ):boolean
	return ai_combat_status(ai_test) > ai_combat_status_alert and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_definate: Checks if an ai has a definate combat status
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_definate( ai_test:ai ):boolean
	return ai_combat_status(ai_test) >= ai_combat_status_definite and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_hunting: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_hunting( ai_test:ai ):boolean
	return ai_combat_status(ai_test) >= ai_combat_status_active and ai_combat_status(ai_test) <= ai_combat_status_certain and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_sees_enemy: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_sees_enemy( ai_test:ai ):boolean
	return ai_combat_status(ai_test) >= ai_combat_status_visible and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_dangerous: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_is_dangerous( ai_test:ai ):boolean
	return ai_combat_status(ai_test) == ai_combat_status_dangerous and ai_spawn_count(ai_test) > 0;
end

-- -------------------------------------------------------------------------------------------------
-- SQUAD STATUS
-- -------------------------------------------------------------------------------------------------
-- === f_ai_has_spawned: Checks to see if an ai group has spawned
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group has spawned, FALSE; if group has not spawned
function f_ai_has_spawned( ai_test:ai ):boolean
	return ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_defeated: Checks if a squad or group has ever spawned AND has no living members left
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
function f_ai_is_defeated( ai_test:ai ):boolean
	return ai_living_count(ai_test) <= 0 and ai_spawn_count(ai_test) > 0;
end

-- === f_ai_is_partially_defeated: Checks if a squad or group has ever spawned AND has a specified number of living members
--			ai_test = AI to give magic sight to
--			s_count = Specific number of AI to test if still living
--	RETURNS:  boolean; TRUE; if group is partially defeated, FALSE; if not partially defeated
function f_ai_is_partially_defeated( ai_test:ai, s_count:number ):boolean
	return ai_living_count(ai_test) <= s_count and ai_spawn_count(ai_test) >= s_count;
end

-- === f_ai_killed_cnt: Gets the count of AI that has been killed in the task
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
function f_ai_killed_cnt( ai_test:ai ):number
	return ai_spawn_count(ai_test) - ai_living_count(ai_test);
end

-- -------------------------------------------------------------------------------------------------
-- TASK
-- -------------------------------------------------------------------------------------------------
-- === f_task_is_empty: Checks if if a task is empty or not
--			ai_task = task to check
--	RETURNS:  boolean; TRUE; if task is empty, FALSE; if the task is not
function f_task_is_empty( ai_task:ai ):boolean
	return ai_task_count(ai_task) <= 0;
end

-- === f_task_has_actors: Checks if a task has anyone in it
--			ai_task = task to check
--	RETURNS:  boolean; TRUE, if the task has actors, FALSE; task is empty
function f_task_has_actors( ai_task:ai ):boolean
	return ai_task_count(ai_task) > 0;
end

-- -------------------------------------------------------------------------------------------------
-- TYPE CONVERSION
-- -------------------------------------------------------------------------------------------------
-- === f_object_get_squad: Gets the squad of an object
--			ai_obj = Object to get squad from
--	RETURNS:  ai; squad from the object
function f_object_get_squad( ai_obj:object ):ai
	return ai_get_squad(object_get_ai(ai_obj));
end

-- -------------------------------------------------------------------------------------------------
-- GARBAGE
-- -------------------------------------------------------------------------------------------------
-- TYPES
function def_ai_cleanup_type_erase():number
	return 00;
end

function def_ai_cleanup_type_kill():number
	return 01;
end
global r_ai_garbage_distance_min_default_7dbae004:number=22.5;
global r_ai_garbage_see_degrees_default_7dbae004:number=100.0;
global s_ai_garbage_delay_squad_default_7dbae004:number=30;
global s_ai_garbage_delay_unit_default_7dbae004:number=1;

-- === f_ai_garbage: "Cleans up" AI based on parameters provided and stops once there is no longer any living AI in the squad
--			ai_squad = Squad to cleanup
--			s_type = Type of action to perform on the AI
--				NOTE: SEE TYPE DEFINITIONS ABOVE
--			[optional] r_distance_min = Minimum distance the AI must be from a player
--				DEFAULT = -1.0
--				[ < 0; Default tuned distance ]
--			[optional] r_see_degrees = Number of degrees from player LOS to make sure the AI is not within 
--				DEFAULT = -1.0
--				[ < 0; Default tuned degrees ]
--			[optional] l_delay_squad = Delay (ticks) between looping back on the squad again
--				DEFAULT = -1
--				[ < 0; Default delay between squad loops ]
--			[optional] l_delay_unit = Delay (ticks) between each unit
--				DEFAULT = -1
--				[ < 0; Default delay between unit loops ]
--			[optional] b_garbage_squad = TRUE; will automatically garbage collect after each squad loop
--				DEFAULT = FALSE
--			[optional] b_check_player_los = TRUE; will check if the player has LOS on the ai and not garbage them if they do
--				DEFAULT = FALSE
--			[optional] b_check_ai_los = TRUE; will check if the ai has LOS on the player and not garbage them if they do
--				DEFAULT = FALSE
--	RETURNS:  long; thread id of the cleanup event
function f_ai_garbage( ai_squad:ai, s_type:number, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number, b_garbage_squad:boolean, b_check_player_los:boolean, b_check_ai_los:boolean ):thread
	-- defaults
	if r_distance_min < 0 then
		r_distance_min = ai_garbage_distance_min_default_get();
	end
	if r_see_degrees < 0 then
		r_see_degrees = ai_garbage_see_degrees_default_get();
	end
	if l_delay_squad < 0 then
		l_delay_squad = ai_garbage_delay_squad_default_get();
	end
	if l_delay_unit < 0 then
		l_delay_unit = ai_garbage_delay_unit_default_get();
	end
	return CreateThread(sys_ai_garbage, ai_squad, s_type, r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad, b_check_player_los, b_check_ai_los);
end

function f_ai_garbage_erase( ai_squad:ai, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number, b_garbage_squad:boolean, b_check_player_los:boolean, b_check_ai_los:boolean ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_erase(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad, b_check_player_los, b_check_ai_los);
end

--[[
script static long f_ai_garbage_erase( ai ai_squad, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit, boolean b_garbage_squad )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad, TRUE, TRUE );
end
script static long f_ai_garbage_erase( ai ai_squad, real r_distance_min, real r_see_degrees, long l_delay_squad, long l_delay_unit )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, FALSE, TRUE, TRUE );
end
script static long f_ai_garbage_erase( ai ai_squad, real r_distance_min, real r_see_degrees )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), r_distance_min, r_see_degrees, -1, -1, FALSE, TRUE, TRUE );
end
script static long f_ai_garbage_erase( ai ai_squad, real r_distance_min )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), r_distance_min, -1.0, -1, -1, FALSE, TRUE, TRUE );
end
script static long f_ai_garbage_erase( ai ai_squad )
	f_ai_garbage( ai_squad, DEF_AI_CLEANUP_TYPE_ERASE(), -1.0, -1.0, -1, -1, FALSE, TRUE, TRUE );
end
]]
function f_ai_garbage_kill8( ai_squad:ai, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number, b_garbage_squad:boolean, b_check_player_los:boolean, b_check_ai_los:boolean ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad, b_check_player_los, b_check_ai_los);
end

function f_ai_garbage_kill6( ai_squad:ai, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number, b_garbage_squad:boolean ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, b_garbage_squad, true, true);
end

function f_ai_garbage_kill5( ai_squad:ai, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), r_distance_min, r_see_degrees, l_delay_squad, l_delay_unit, false, true, true);
end

function f_ai_garbage_kill4( ai_squad:ai, r_distance_min:number, r_see_degrees:number ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), r_distance_min, r_see_degrees, -1, -1, false, true, true);
end

function f_ai_garbage_kill2( ai_squad:ai, r_distance_min:number ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), r_distance_min, -1, -1, -1, false, true, true);
end

function f_ai_garbage_kill( ai_squad:ai ):thread
	return f_ai_garbage(ai_squad, def_ai_cleanup_type_kill(), -1, -1, -1, -1, false, true, true);
end

-- === sys_ai_garbage: Manages f_ai_garbage
--			NOTE: DO NOT USE!!!
function sys_ai_garbage( ai_squad:ai, s_type:number, r_distance_min:number, r_see_degrees:number, l_delay_squad:number, l_delay_unit:number, b_garbage_squad:boolean, b_check_player_los:boolean, b_check_ai_los:boolean ):void
	repeat
		Sleep(l_delay_squad);
		if ai_living_count(ai_squad) > 0 then
			sys_ai_garbage_objlist(ai_actors(ai_squad), s_type, r_distance_min, r_see_degrees, l_delay_unit, b_check_player_los, b_check_ai_los);
		end
		if b_garbage_squad then
			garbage_collect_now();
		end
	until ai_living_count(ai_squad) <= 0;
end

-- === sys_ai_garbage_objlist: Manages list of actors from sys_ai_garbage
--			NOTE: DO NOT USE!!!
function sys_ai_garbage_objlist( ol_list:object_list, s_type:number, r_distance_min:number, r_see_degrees:number, l_delay_unit:number, b_check_player_los:boolean, b_check_ai_los:boolean ):void
	local s_index:number=list_count(ol_list);
	local obj_object:object=nil;
	repeat
		Sleep(l_delay_unit);
		-- loop through all the units in the squad
		s_index = s_index - 1;
		obj_object = list_get(ol_list, s_index);
		-- check to make sure the object meets the criteria
		if obj_object~=nil and object_get_health(obj_object) > 0.0 and objects_distance_to_object(players(), obj_object) >= r_distance_min and ( not b_check_player_los or  not objects_can_see_object(players(), obj_object, r_see_degrees)) and ( not b_check_ai_los or  not objects_can_see_player(obj_object, r_see_degrees)) then
			-- apply unit garbage type
			if s_type == def_ai_cleanup_type_erase() then
				--dprint( "sys_ai_garbage_objlist: ERASE" );
				ai_erase(object_get_ai(obj_object));
			elseif s_type == def_ai_cleanup_type_kill() then
				--dprint( "sys_ai_garbage_objlist: KILLED" );
				ai_kill_no_statistics(object_get_ai(obj_object));
			else
				Breakpoint("sys_ai_cleanup: TYPE UNKNOWN");
				print(s_type);
				Sleep(1);
			end
		end
	until s_index <= 0;
end

function ai_garbage_distance_min_default_set( r_val:number ):void
	r_ai_garbage_distance_min_default_7dbae004 = r_val;
end

function ai_garbage_distance_min_default_get():number
	return r_ai_garbage_distance_min_default_7dbae004;
end

function ai_garbage_see_degrees_default_set( r_val:number ):void
	r_ai_garbage_see_degrees_default_7dbae004 = r_val;
end

function ai_garbage_see_degrees_default_get():number
	return r_ai_garbage_see_degrees_default_7dbae004;
end

function ai_garbage_delay_squad_default_set( s_val:number ):void
	s_ai_garbage_delay_squad_default_7dbae004 = s_val;
end

function ai_garbage_delay_squad_default_get():number
	return s_ai_garbage_delay_squad_default_7dbae004;
end

function ai_garbage_delay_unit_default_set( s_val:number ):void
	s_ai_garbage_delay_unit_default_7dbae004 = s_val;
end

function ai_garbage_delay_unit_default_get():number
	return s_ai_garbage_delay_unit_default_7dbae004;
end

-- -------------------------------------------------------------------------------------------------
-- ObjList Kill AI
-- -------------------------------------------------------------------------------------------------
function objlist_kill_ai( ol_list:object_list, b_count_kill_stats:boolean ):number
	local s_index:number=list_count(ol_list);
	local obj_object:object=nil;
	local s_applied:number=0;
	if s_index > 0 then
		repeat
			Sleep(1);
			s_index = s_index - 1;
			obj_object = list_get(ol_list, s_index);
			if obj_object~=nil and object_get_health(obj_object) > 0.0 then
				if b_count_kill_stats then
					ai_kill(object_get_ai(obj_object));
				else
					ai_kill_no_statistics(object_get_ai(obj_object));
				end
				s_applied = s_applied + 1;
			end
		until s_index <= 0;
	end
	return s_applied;
end

-- return
function triggerobjs_kill_ai( tv_volume:volume, b_count_kill_stats:boolean ):number
	return objlist_kill_ai(volume_return_objects_by_type(tv_volume, s_objtype_biped), b_count_kill_stats);
end
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- AI: SPAWN DELAY
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global l_ai_spawn_timer_7dbae004:number=0;
global l_ai_spawn_delay_default:number=5;

-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === f_ai_spawn_delay_start::: Starts the spawn delay timer
function f_ai_spawn_delay_start( s_delay:number ):void
	--dprint( "::: f_ai_spawn_delay_start :::" );
	-- defaults
	if s_delay < 0 then
		s_delay = f_ai_spawn_delay_default_get();
	end
	-- set the timer
	l_ai_spawn_timer_7dbae004 = game_tick_get() + s_delay;
end

--[[
script static void f_ai_spawn_delay_start()
	f_ai_spawn_delay_start( f_ai_spawn_delay_default_get() );
end
]]
-- === f_ai_spawn_delay_default_get::: Gets the default spawn delay timer value
function f_ai_spawn_delay_default_get():number
	return l_ai_spawn_delay_default;
end

-- === f_ai_spawn_delay_default_set::: Sets the default spawn delay timer value
function f_ai_spawn_delay_default_set( s_val:number ):void
	--dprint( "::: f_ai_spawn_delay_default_set :::" );
	l_ai_spawn_delay_default = s_val;
end

-- === f_ai_spawn_delay_check::: Checks the spawn delay timer
function f_ai_spawn_delay_check():boolean
	return l_ai_spawn_timer_7dbae004 <= game_tick_get();
end

-- === f_ai_spawn_delay_wait::: Waits for spawn delay and can reset
function f_ai_spawn_delay_wait( b_reset:boolean, s_reset_delay:number ):void
	--dprint( "::: f_ai_spawn_delay_wait :::" );
	SleepUntil([| f_ai_spawn_delay_check() ], 1);
	--dprint( "::: f_ai_spawn_delay_wait: TRIGGERED :::" );
	if b_reset then
		--dprint( "::: f_ai_spawn_delay_wait: RESET :::" );
		f_ai_spawn_delay_start(s_reset_delay);
	end
end

-- -------------------------------------------------------------------------------------------------
-- MISC
-- -------------------------------------------------------------------------------------------------
-- === f_ai_magically_see_players: Gives a squad magic sight on ALL players
--			ai_test = AI to give magic sight to
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function f_ai_magically_see_players( ai_test:ai ):void
	ai_magically_see_object(ai_test, PLAYERS.player0);
	ai_magically_see_object(ai_test, PLAYERS.player1);
	ai_magically_see_object(ai_test, PLAYERS.player2);
	ai_magically_see_object(ai_test, PLAYERS.player3);
end

-- === f_ai_sees_player: Checks if an AI can see a player
--			ai_test = AI to check
--			r_angle = Angle of sight check
--	RETURNS:  TRUE; if AI sees a player
function f_ai_sees_player( ai_test:ai, r_angle:number ):boolean
	return objects_can_see_object(ai_get_object(ai_test), PLAYERS.player0, r_angle) or objects_can_see_object(ai_get_object(ai_test), PLAYERS.player1, r_angle) or objects_can_see_object(ai_get_object(ai_test), PLAYERS.player2, r_angle) or objects_can_see_object(ai_get_object(ai_test), PLAYERS.player3, r_angle);
end



--function f_ai_active_camo_manager( ai_actor:ai ):void
-- local l_timer:number = 0;
-- local obj_actor:object  = ai_get_object( ai_actor );
--	--print( "cs_active_camo_use: ENABLED" );
--
--	repeat
--	
--		-- activate camo
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			ai_set_active_camo( ai_actor, true );
--			--print( "f_active_camo_manager: ACTIVE" ); 
--		end
--		
--		-- disable camo
--		SleepUntil( [| (unit_get_health(ai_actor) <= 0.0) or   objects_distance_to_object(players(),obj_actor) <= 5.5  or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.2) ], 3 );
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			ai_set_active_camo( ai_actor, false );
--			--print( "f_active_camo_manager: DISABLED" ); 
--		end
--		
--		-- manage resetting
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			l_timer = timer_stamp( 2.5, 5.0 ); -- unit_has_weapon_readied(ai_actor, TAG('objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') )
--			SleepUntil( [| (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and ( objects_distance_to_object( players(),obj_actor) >= 4.0 ) and ( not objects_can_see_object( players(),obj_actor,25.0 ))) ], 1 );
--			
--			
--			if not unit_has_weapon_readied(ai_actor, TAG('objects\weapons\melee\energy_sword\energy_sword.weapon') ) then
--				--print("ai switching back to sword");
--				ai_swap_weapons( ai_current_actor);
--			end
--		
--		end
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			--print( "f_active_camo_manager: RESET" ); 
--			Sleep(1);
--		end
--		Sleep(1);
--	until ( unit_get_health(ai_actor) <= 0.0 );
--
--
--end