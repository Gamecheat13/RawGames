//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_population_limit = 						20;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_population_limit ) then
		dprint( "spops_ai_population_limit:" );
		inspect( s_limit );
		S_spops_ai_population_limit = s_limit;
		if ( s_limit > 20 ) then
			dprint( "spops_ai_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		end
	end

end
script static short spops_ai_population_limit()
	S_spops_ai_population_limit;
end

// === spops_ai_population_limit_check::: xxx
script static boolean spops_ai_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= spops_ai_population_limit() );
end

// === spops_ai_population::: Gets the current population (including guys on phantoms, etc.)
// XXX support cnt for guys in phantoms, etc.
script static short spops_ai_population()
	ai_living_count( ai_ff_all );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: GLOBAL: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() 				9999.9999;	end
script static real DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET() 				8888.8888;	end
script static real DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE() 			7777.7777;	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real 		R_spops_ai_global_priority_range_min =			-1.0;
static real 		R_spops_ai_global_priority_range_max =			-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_global_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_global_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_global_priority_range_min( r_priority_min );
	spops_ai_global_priority_range_max( r_priority_max );
end

// === spops_ai_global_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_global_priority_range_min( real r_priority )

	if ( r_priority != R_spops_ai_global_priority_range_min ) then

		if ( (r_priority < 0.0) or (r_priority <= spops_ai_global_priority_range_max()) ) then

			dprint( "spops_ai_global_priority_range_min:" );
			inspect( r_priority );
			R_spops_ai_global_priority_range_min = r_priority;

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_global_priority_range_min( spops_ai_global_priority_range_max() );
			spops_ai_global_priority_range_max( r_priority_temp );
			
		end

	end

end
script static real spops_ai_global_priority_range_min()
	R_spops_ai_global_priority_range_min;
end

// === spops_ai_global_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_global_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_global_priority_range_max ) then

		if ( (r_priority < 0.0) or (spops_ai_global_priority_range_min() <= r_priority) ) then

			dprint( "spops_ai_global_priority_range_max:" );
			inspect( r_priority );
			R_spops_ai_global_priority_range_max = r_priority;

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_global_priority_range_max( spops_ai_global_priority_range_min() );
			spops_ai_global_priority_range_min( r_priority_temp );
			
		end

	end

end
script static real spops_ai_global_priority_range_max()
	R_spops_ai_global_priority_range_max;
end

// === spops_ai_global_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_global_priority_range_check( real r_priority )
	(
		( spops_ai_global_priority_range_min() < 0.0 )
		or
		( r_priority >= spops_ai_global_priority_range_min() )
	)
	and
	(
		( spops_ai_global_priority_range_max() < 0.0 )
		or
		( r_priority <= spops_ai_global_priority_range_max() )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_spops_ai_place_pre::: XXX
// XXX document params
script static ai sys_spops_ai_place_pre( ai ai_target )

	// place
	ai_place_in_limbo( ai_target, 1 );

	// set the spawn delay
	f_ai_spawn_delay_start();

	dprint( "sys_spops_ai_place_pre: CURRENT" );
	inspect( spops_ai_population() );
			
	// get the character that was spawned		
	ai_target = object_get_ai( list_get(ai_actors(ai_target), list_count(ai_actors(ai_target)) - 1) );
	
	// start scale small
	object_set_scale( ai_get_object(ai_target), 0.0001, 0 );

	// return
	ai_target;
end

// === sys_spops_ai_place_loc::: XXX
// XXX document params
script static void sys_spops_ai_place_post_loc( ai ai_target, cutscene_flag flg_loc, boolean b_limbo_exit, string_id sid_objective, real r_scale_target, real r_scale_time )

	// defaults
	if ( r_scale_target < 0.0 ) then
		r_scale_target = 1.0;
	end
	if ( r_scale_time < 0.0 ) then
		r_scale_time = 0.0;
	end
				
	// move the character to the flag
	object_move_to_flag( ai_get_object(ai_target), 0.0, flg_loc );
	sleep( 1 );

	// set objective
	if ( sid_objective != NONE ) then
		ai_set_objective( ai_get_squad(ai_target), sid_objective );
	end

	// check if needed to exit limbo					
	if ( b_limbo_exit and (ai_in_limbo_count(ai_target) > 0) ) then
		ai_exit_limbo( ai_target );
	end
	
	// scale
	object_set_scale( ai_get_object(ai_target), r_scale_target, seconds_to_frames(r_scale_time) );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: DISTANCES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_place_distance_min_default = 		22.5;
static real  		R_spops_ai_place_distance_max_default = 		35.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_distance_defaults::: Sets the min and max safe distances defaults
// XXX document params
script static void spops_ai_place_distance_defaults( real r_distance_min, real r_distance_max )
	spops_ai_place_distance_min_default( r_distance_min );
	spops_ai_place_distance_max_default( r_distance_max );
end

// === spops_ai_place_distance_min_default::: Sets/Gets the min safe distances default
// XXX document params
script static void spops_ai_place_distance_min_default( real r_distance )

	if ( r_distance != R_spops_ai_place_distance_min_default ) then
		dprint( "spops_ai_place_distance_min_default:" );
		inspect( r_distance );
		R_spops_ai_place_distance_min_default = r_distance;
	end

end
script static short spops_ai_place_distance_min_default()
	R_spops_ai_place_distance_min_default;
end

// === spops_ai_place_distance_max_default::: Sets/Gets the max safe distances default
// XXX document params
script static short spops_ai_place_distance_max_default()
	R_spops_ai_place_distance_max_default;
end
script static void spops_ai_place_distance_max_default( real r_distance )

	if ( r_distance != R_spops_ai_place_distance_max_default ) then
		dprint( "spops_ai_place_distance_max_default:" );
		inspect( r_distance );
		R_spops_ai_place_distance_max_default = r_distance;
	end

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: ANGLE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_place_angle_default = 					30.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_angle_default::: Sets/Gets the safe angle default
// XXX document params
script static void spops_ai_place_angle_default( real r_angle )

	if ( r_angle != R_spops_ai_place_angle_default ) then
		dprint( "spops_ai_place_angle_default:" );
		inspect( r_angle );
		R_spops_ai_place_angle_default = r_angle;
	end

end
script static short spops_ai_place_angle_default()
	R_spops_ai_place_angle_default;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe::: Places AI based on priority and POPULATIONs
// XXX document params
// XXX support spops_ai_place_safe_queue_ticket_enabled
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance_min, real r_distance_max, real r_safe_angle )
static short s_active_cnt = 0;
static real r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local object obj_spawned = NONE;
local ai ai_spawned = NONE;

	// defaults
	if ( r_distance_min < 0.0 ) then
		r_distance_min = spops_ai_place_distance_min_default();
	end
	if ( r_distance_max < 0.0 ) then
		r_distance_max = spops_ai_place_distance_max_default();
	end
	if ( r_safe_angle < 0.0 ) then
		r_safe_angle = spops_ai_place_angle_default();
	end
	
	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != NONE
	if ( ai_ff_all == NONE ) then
		sleep_until( ai_ff_all != NONE, 1 );
	end

	dprint( "spops_ai_place_safe: START" );
	s_active_cnt = s_active_cnt + 1;
	inspect( s_active_cnt );

	repeat
	
		// wait
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			(
				f_ai_spawn_delay_check()
				and
				spops_ai_place_safe_population_limit_check( s_spawn_cost )
				and
				(
					spops_ai_place_safe_priority_range_check( spops_ai_place_safe_priority(r_priority, flg_spawn_loc) )
					and
					(
						( spops_ai_place_safe_priority(r_priority, flg_spawn_loc) < spops_ai_place_safe_priority_current() )
						or
						(
							b_priority_sub_distance
							and
							( spops_ai_place_safe_priority(r_priority, flg_spawn_loc) == spops_ai_place_safe_priority_current() )
							and
							( objects_distance_to_flag(Players(), flg_spawn_loc) < r_distance_sub )
						)
					)
				)
				and
				(
					( s_squad_limit < 0 )
					or
					( ai_living_count(ai_spawn) < s_squad_limit )
				)
				and
				(
					( player_living_count() <= 0 )
					or
					(
						( objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_min )
						and
						(
							( objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_max )
							or
							( not objects_can_see_flag(Players(), flg_spawn_loc, r_safe_angle) )
						)
					)
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) ) then

			// store priority values
			local real r_priority_temp = spops_ai_place_safe_priority( r_priority, flg_spawn_loc );
			local real r_distance_sub_temp = objects_distance_to_flag( Players(), flg_spawn_loc );
			
			// share global priority settings
			sys_spops_ai_place_safe_priority_current( r_priority_temp );
			r_distance_sub = r_distance_sub_temp;
			sleep( 1 );

			// check if this is the current priority target
			if ( (r_priority_temp == spops_ai_place_safe_priority_current()) and (r_distance_sub == r_distance_sub_temp) ) then

				// place
				if ( f_chance(r_chance) and ((spops_ai_population() + s_spawn_cost) <= spops_ai_population_limit()) ) then
		
					ai_spawned = sys_spops_ai_place_pre( ai_spawn );
					//obj_spawned = ai_get_object( ai_spawned );

					if ( r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE() ) then
						dprint( "spops_ai_place_safe: DISTANCE" );
						inspect( r_priority_temp );
					else
						dprint( "spops_ai_place_safe: PRIORITY" );
						inspect( r_priority );
					end

					sys_spops_ai_place_post_loc( ai_spawned, flg_spawn_loc, not b_limbo, NONE, r_scale_target, r_scale_time );

					// decerement spawn cnt
					s_spawn_cnt = s_spawn_cnt - 1;
		
				end

				// reset current priority
				spops_ai_place_safe_priority_current_reset();
				r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
			end

		end
	
	until( (s_spawn_cnt == 0) or (not isthreadvalid(l_thread)), 1 );
	dprint( "spops_ai_place_safe: EXIT" );
	
	// decrement active cnt
	s_active_cnt = s_active_cnt - 1;
	inspect( s_active_cnt );

	// returns the last spawned dude
	object_get_ai( obj_spawned );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance_min, real r_distance_max )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, r_distance_min, r_distance_max, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance_min )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, r_distance_min, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, FALSE, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, 1.0, 0.0, FALSE, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, 100.0, 1.0, 0.0, FALSE, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, -1, 100.0, 1.0, 0.0, FALSE, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, 1, -1, 100.0, 1.0, 0.0, FALSE, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, 1, 1, -1, 100.0, 1.0, 0.0, FALSE, -1.0, -1.0, -1.0 );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_place_safe_population_limit = 						-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_place_safe_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_place_safe_population_limit ) then
		dprint( "spops_ai_place_safe_population_limit:" );
		inspect( s_limit );
		S_spops_ai_place_safe_population_limit = s_limit;
		if ( s_limit > 20 ) then
			dprint( "spops_ai_place_safe_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		end
	end

end
script static short spops_ai_place_safe_population_limit()
	if ( S_spops_ai_place_safe_population_limit >= 0 ) then
		S_spops_ai_place_safe_population_limit;
	else
		spops_ai_population_limit();
	end
end

// === spops_ai_place_safe_population_limit_check::: XXX
script static boolean spops_ai_place_safe_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= spops_ai_place_safe_population_limit() ) and spops_ai_population_limit_check( s_cnt );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_place_safe_priority_current = 				DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe_priority_current::: Gets the safe priority the system is using
script static real spops_ai_place_safe_priority_current()
	R_spops_ai_place_safe_priority_current;
end

// === spops_ai_place_safe_priority_current_reset::: Reset the safe priority default
script static void spops_ai_place_safe_priority_current_reset()

	if ( R_spops_ai_place_safe_priority_current != DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET() ) then
	
		dprint( "spops_ai_place_safe_priority_current_reset" );
		R_spops_ai_place_safe_priority_current = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
		
	end
	
end

// === spops_ai_place_safe_priority_current_reset::: Checks if the current priority needs to reset
script static void spops_ai_place_safe_priority_current_reset_check()
	
	if ( not spops_ai_place_safe_priority_range_check(spops_ai_place_safe_priority_current()) ) then
	
		dprint( "spops_ai_place_safe_priority_current_reset_check" );
		spops_ai_place_safe_priority_current_reset();
		
	end
	
end

// === spops_ai_place_safe_priority_current_reset::: Checks if the
script static real spops_ai_place_safe_priority( real r_priority, cutscene_flag flg_spawn_loc )
	if ( (r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE()) and (player_living_count() > 0) ) then
		r_priority = objects_distance_to_flag( Players(), flg_spawn_loc );
	end
	
	// return
	r_priority;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_place_safe_priority_current( real r_priority )

	if ( (r_priority != R_spops_ai_place_safe_priority_current) and spops_ai_place_safe_priority_range_check(r_priority) ) then
		
		dprint( "sys_spops_ai_place_safe_priority_current:" );
		inspect( r_priority );
		R_spops_ai_place_safe_priority_current = r_priority;
		
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE: PRIORITY: RANGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real 		R_spops_ai_place_safe_priority_range_min =			-1.0;
static real 		R_spops_ai_place_safe_priority_range_max =			-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_place_safe_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_place_safe_priority_range_min( r_priority_min );
	spops_ai_place_safe_priority_range_max( r_priority_max );
end

// === spops_ai_place_safe_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_place_safe_priority_range_min( real r_priority )

	if ( r_priority != R_spops_ai_place_safe_priority_range_min ) then

		if ( (r_priority < 0.0) or (r_priority <= spops_ai_place_safe_priority_range_max()) ) then

			dprint( "spops_ai_place_safe_priority_range_min:" );
			inspect( r_priority );
			R_spops_ai_place_safe_priority_range_min = r_priority;
			
			// check reset current based on range update
			spops_ai_place_safe_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_place_safe_priority_range_min( spops_ai_place_safe_priority_range_max() );
			spops_ai_place_safe_priority_range_max( r_priority_temp );
			
		end

	end

end
script static real spops_ai_place_safe_priority_range_min()
	if ( R_spops_ai_place_safe_priority_range_min != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_place_safe_priority_range_min;
	else
		spops_ai_global_priority_range_min();
	end
end

// === spops_ai_place_safe_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_place_safe_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_place_safe_priority_range_max ) then

		if ( (r_priority < 0.0) or (spops_ai_place_safe_priority_range_min() <= r_priority) ) then

			dprint( "spops_ai_place_safe_priority_range_max:" );
			inspect( r_priority );
			R_spops_ai_place_safe_priority_range_max = r_priority;
	
			// check reset current based on range update
			spops_ai_place_safe_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_place_safe_priority_range_max( spops_ai_place_safe_priority_range_min() );
			spops_ai_place_safe_priority_range_min( r_priority_temp );
			
		end

	end

end
script static real spops_ai_place_safe_priority_range_max()
	if ( R_spops_ai_place_safe_priority_range_max != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_place_safe_priority_range_max;
	else
		spops_ai_global_priority_range_max();
	end
end

// === spops_ai_place_safe_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_place_safe_priority_range_check( real r_priority )
	(
		( spops_ai_place_safe_priority_range_min() < 0.0 )
		or
		( r_priority >= spops_ai_place_safe_priority_range_min() )
	)
	and
	(
		( spops_ai_place_safe_priority_range_max() < 0.0 )
		or
		( r_priority <= spops_ai_place_safe_priority_range_max() )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static ai 	 DEF_SPOPS_AI_POOL_AI_RESET() 					NONE;	end
script static real DEF_SPOPS_AI_POOL_INDEX_RESET() 				-1.0;	end
script static real DEF_SPOPS_AI_POOL_WEIGHT_RESET() 			-1.0;	end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool::: XXX
// XXX document params
// XXX defaults
script static ai spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight, real r_chance, real r_timeout )
static short s_active_cnt = 0;
local object obj_spawned = NONE;
local ai ai_spawned = NONE;
static short s_id_cnt = 0;
local short s_id = s_id_cnt;
static short s_id_current = -1;

	// increment id counter
	s_id_cnt = s_id_cnt + 1;

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != NONE
	if ( ai_ff_all == NONE ) then
		sleep_until( ai_ff_all != NONE, 1 );
	end

	dprint( "spops_ai_pool: START" );
	s_active_cnt = s_active_cnt + 1;
	inspect( s_active_cnt );
	inspect( s_id );

	repeat

		// wait
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			(
				f_ai_spawn_delay_check()
				and
				spops_ai_pool_population_limit_check( s_spawn_cost )
				and
				(
					spops_ai_pool_priority_range_check( r_priority )
					and
					( r_priority < spops_ai_pool_priority_current() )
				)
				and
				(
					( s_squad_limit < 0 )
					or
					( ai_living_count(ai_spawn) < s_squad_limit )
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) ) then

			// share global priority settings
			if ( spops_ai_pool_priority_current() != r_priority ) then
				sys_spops_ai_pool_priority_current( r_priority );
				s_id_current = -1;
			end
			if ( f_chance(r_chance) or (s_id_current == -1) ) then
				s_id_current = s_id;
				sleep( 1 );
			end

			if ( (r_priority == spops_ai_pool_priority_current()) and (s_id_current == s_id) ) then

				// place
				if ( (spops_ai_population() + s_spawn_cost) <= spops_ai_population_limit() ) then

					// place
					ai_place_in_limbo( ai_spawn, 1 );
					dprint( "spops_ai_pool: CURRENT" );
					inspect( spops_ai_population() );
					dprint( "spops_ai_pool: PRIORITY" );
					inspect( r_priority );

					// set the spawn delay
					f_ai_spawn_delay_start();

					// get the character that was spawned		
					obj_spawned = list_get( ai_actors(ai_spawn), list_count(ai_actors(ai_spawn)) - 1 );
					ai_spawned = object_get_ai( obj_spawned );
					
					if ( spops_ai_pool_add(l_thread, ai_spawned, r_pool_index, r_weight, r_timeout) ) then
						dprint( "spops_ai_pool: SUCCESS" );
						s_spawn_cnt = s_spawn_cnt - 1;
					else
						dprint( "spops_ai_pool: FAILED" );
						if ( ai_vehicle_get(ai_spawned) != NONE ) then
							object_destroy( ai_vehicle_get(ai_spawned) );
						end
						ai_erase( ai_spawned );
					end
				
				end

				// reset current priority
				spops_ai_pool_priority_current_reset();
				s_id_current = -1;

			end
		end
	
	until( (s_spawn_cnt == 0) or (not isthreadvalid(l_thread)), 1 );
	dprint( "spops_ai_pool: EXIT" );
	
	// decrement active cnt
	s_active_cnt = s_active_cnt - 1;
	inspect( s_active_cnt );

	// returns the last spawned dude
	ai_spawned;
end
script static ai spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight, real r_chance )
	spops_ai_pool( l_thread, ai_spawn, r_priority, r_pool_index, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_weight, r_chance, -1.0 );
end

// === spops_ai_pool_add::: XXX
// XXX document params
script static boolean spops_ai_pool_add( long l_thread, ai ai_pool, real r_index, real r_weight, real r_timeout )
local boolean b_placed = FALSE;
local long l_timer = timer_stamp( r_timeout );
	dprint( "spops_ai_pool_add" );
	
	// if timer value isn't valid, timer never expires
	if ( r_timeout < 0.0 ) then
		l_timer = -1;
	end
	
	repeat
		
		// wait for turn in pool
		sleep_until( (spops_ai_pool_queue_ai() == DEF_SPOPS_AI_POOL_AI_RESET()) or (not isthreadvalid(l_thread)) or (ai_living_count(ai_pool) <= 0) or timer_expired(l_timer), 1 );

		// give turn in pool
		if ( (spops_ai_pool_queue_ai() == DEF_SPOPS_AI_POOL_AI_RESET()) and isthreadvalid(l_thread) and (ai_living_count(ai_pool) > 0) and (not timer_expired(l_timer)) ) then
		
			sys_spops_ai_pool_queue( ai_pool, r_index, r_weight );
			sleep( 1 );
			
			// check if the pool ai was placed
			b_placed = ( spops_ai_pool_queue_ai() != ai_pool );
			
			// make sure the current is reset to give others a turn
			if ( spops_ai_pool_queue_ai() == ai_pool ) then
				spops_ai_pool_queue_reset();
			end
			
		end
	
	until( b_placed or (not isthreadvalid(l_thread)) or (ai_living_count(ai_pool) <= 0) or timer_expired(l_timer), 1 );
	
	// return
	b_placed;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: QUEUE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static ai AI_spops_ai_pool_queue =								DEF_SPOPS_AI_POOL_AI_RESET();
static real R_spops_ai_pool_queue_index =					DEF_SPOPS_AI_POOL_INDEX_RESET();
static real R_spops_ai_pool_queue_weight =				DEF_SPOPS_AI_POOL_WEIGHT_RESET();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_ai::: xxx
script static ai spops_ai_pool_queue_ai()
	AI_spops_ai_pool_queue;
end

// === spops_ai_pool_queue_index::: xxx
script static real spops_ai_pool_queue_index()
	R_spops_ai_pool_queue_index;
end

// === spops_ai_pool_queue_weight::: xxx
script static real spops_ai_pool_queue_weight()
	R_spops_ai_pool_queue_weight;
end

// === spops_ai_pool_queue_reset::: Reset the safe priority default
script static void spops_ai_pool_queue_reset()

	if ( R_spops_ai_pool_queue_index != DEF_SPOPS_AI_POOL_INDEX_RESET() ) then
		dprint( "spops_ai_pool_queue_reset" );
		sys_spops_ai_pool_queue( DEF_SPOPS_AI_POOL_AI_RESET(), DEF_SPOPS_AI_POOL_INDEX_RESET(), DEF_SPOPS_AI_POOL_WEIGHT_RESET() );
	end
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue( ai ai_current, real r_index, real r_weight )

	if ( AI_spops_ai_pool_queue != ai_current ) then
		dprint( "spops_ai_pool_queue_reset: AI" );
		AI_spops_ai_pool_queue = ai_current;
	end
	if ( R_spops_ai_pool_queue_index != r_index ) then
		dprint( "spops_ai_pool_queue_reset: INDEX" );
		R_spops_ai_pool_queue_index = r_index;
	end
	if ( R_spops_ai_pool_queue_weight != r_weight ) then
		dprint( "spops_ai_pool_queue_reset: WEIGHT" );
		R_spops_ai_pool_queue_weight = r_weight;
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: ACTIVE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static ai AI_spops_ai_pool_active =									DEF_SPOPS_AI_POOL_AI_RESET();
static real R_spops_ai_pool_active_index =					DEF_SPOPS_AI_POOL_INDEX_RESET();
static real R_spops_ai_pool_active_weight =					DEF_SPOPS_AI_POOL_WEIGHT_RESET();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_active_ai::: xxx
script static ai spops_ai_pool_active_ai()
	AI_spops_ai_pool_active;
end

// === spops_ai_pool_active_index::: xxx
script static real spops_ai_pool_active_index()
	R_spops_ai_pool_active_index;
end

// === spops_ai_pool_active_weight::: xxx
script static real spops_ai_pool_active_weight()
	R_spops_ai_pool_active_weight;
end

// === spops_ai_pool_active_reset::: Reset the safe priority default
script static void spops_ai_pool_active_reset()

	if ( R_spops_ai_pool_active_index != DEF_SPOPS_AI_POOL_INDEX_RESET() ) then
		dprint( "spops_ai_pool_active_reset" );
		sys_spops_ai_pool_active( DEF_SPOPS_AI_POOL_AI_RESET(), DEF_SPOPS_AI_POOL_INDEX_RESET(), DEF_SPOPS_AI_POOL_WEIGHT_RESET() );
	end
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_active( ai ai_current, real r_index, real r_weight )

	if ( AI_spops_ai_pool_active != ai_current ) then
		dprint( "spops_ai_pool_active_reset: AI" );
		AI_spops_ai_pool_active = ai_current;
	end
	if ( R_spops_ai_pool_active_index != r_index ) then
		dprint( "spops_ai_pool_active_reset: INDEX" );
		R_spops_ai_pool_active_index = r_index;
	end
	if ( R_spops_ai_pool_active_weight != r_weight ) then
		dprint( "spops_ai_pool_active_reset: WEIGHT" );
		R_spops_ai_pool_active_weight = r_weight;
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: current ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_current_ai::: xxx
script static ai spops_ai_pool_current_ai()
	if ( spops_ai_pool_active_ai() == NONE ) then
		spops_ai_pool_queue_ai();
	else
		spops_ai_pool_active_ai();
	end
end

// === spops_ai_pool_current_index::: xxx
script static real spops_ai_pool_current_index()
	if ( spops_ai_pool_active_ai() == NONE ) then
		spops_ai_pool_queue_index();
	else
		spops_ai_pool_active_index();
	end
end

// === spops_ai_pool_current_weight::: xxx
script static real spops_ai_pool_current_weight()
	if ( spops_ai_pool_active_ai() == NONE ) then
		spops_ai_pool_queue_weight();
	else
		spops_ai_pool_active_weight();
	end
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_pool_population_limit = 						-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_pool_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_pool_population_limit ) then
		dprint( "spops_ai_pool_population_limit:" );
		inspect( s_limit );
		S_spops_ai_pool_population_limit = s_limit;
		if ( s_limit > 20 ) then
			dprint( "spops_ai_pool_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		end
	end

end
script static short spops_ai_pool_population_limit()
	if ( S_spops_ai_pool_population_limit >= 0 ) then
		S_spops_ai_pool_population_limit;
	else
		spops_ai_population_limit();
	end
end

// === spops_ai_pool_population_limit_check::: XXX
script static boolean spops_ai_pool_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= spops_ai_pool_population_limit() ) and spops_ai_population_limit_check( s_cnt );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_pool_priority_current = 				DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_priority_current::: Gets the safe priority the system is using
script static real spops_ai_pool_priority_current()
	R_spops_ai_pool_priority_current;
end

// === spops_ai_pool_priority_current_reset::: Reset the safe priority default
script static void spops_ai_pool_priority_current_reset()

	if ( R_spops_ai_pool_priority_current != DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET() ) then
	
		dprint( "spops_ai_pool_priority_current_reset" );
		R_spops_ai_pool_priority_current = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
		
	end
	
end

// === spops_ai_pool_priority_current_reset::: Checks if the current priority needs to reset
script static void spops_ai_pool_priority_current_reset_check()
	
	if ( not spops_ai_pool_priority_range_check(spops_ai_pool_priority_current()) ) then
	
		dprint( "spops_ai_pool_priority_current_reset_check" );
		spops_ai_pool_priority_current_reset();
		
	end
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_priority_current( real r_priority )

	if ( (r_priority != R_spops_ai_pool_priority_current) and spops_ai_pool_priority_range_check(r_priority) ) then
		
		dprint( "sys_spops_ai_pool_priority_current:" );
		inspect( r_priority );
		R_spops_ai_pool_priority_current = r_priority;
		
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PRIORITY: RANGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real 		R_spops_ai_pool_priority_range_min =			-1.0;
static real 		R_spops_ai_pool_priority_range_max =			-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_pool_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_pool_priority_range_min( r_priority_min );
	spops_ai_pool_priority_range_max( r_priority_max );
end

// === spops_ai_pool_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_pool_priority_range_min( real r_priority )

	if ( r_priority != R_spops_ai_pool_priority_range_min ) then

		if ( (r_priority < 0.0) or (spops_ai_pool_priority_range_max() >= r_priority) ) then

			dprint( "spops_ai_pool_priority_range_min:" );
			inspect( r_priority );
			R_spops_ai_pool_priority_range_min = r_priority;
			
			// check reset current based on range update
			spops_ai_pool_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_pool_priority_range_min( spops_ai_pool_priority_range_max() );
			spops_ai_pool_priority_range_max( r_priority_temp );
			
		end

	end

end
script static real spops_ai_pool_priority_range_min()
	if ( R_spops_ai_pool_priority_range_min != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_pool_priority_range_min;
	else
		spops_ai_place_safe_priority_range_min();
	end
end

// === spops_ai_pool_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_pool_priority_range_max ) then

		if ( (r_priority < 0.0) or (spops_ai_pool_priority_range_min() <= r_priority) ) then

			dprint( "spops_ai_pool_priority_range_max:" );
			inspect( r_priority );
			R_spops_ai_pool_priority_range_max = r_priority;
	
			// check reset current based on range update
			spops_ai_pool_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_pool_priority_range_max( spops_ai_pool_priority_range_min() );
			spops_ai_pool_priority_range_min( r_priority_temp );
			
		end

	end

end
script static real spops_ai_pool_priority_range_max()
	if ( R_spops_ai_pool_priority_range_max != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_pool_priority_range_max;
	else
		spops_ai_place_safe_priority_range_max();
	end
end

// === spops_ai_pool_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_pool_priority_range_check( real r_priority )
	(
		( spops_ai_pool_priority_range_min() < 0.0 )
		or
		( r_priority >= spops_ai_pool_priority_range_min() )
	)
	and
	(
		( spops_ai_pool_priority_range_max() < 0.0 )
		or
		( r_priority <= spops_ai_pool_priority_range_max() )
	);
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: LOC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_loc::: Places AI pool characters at a location
// XXX document params
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_min, real r_distance_max, real r_safe_angle )
static short s_active_cnt = 0;
static real r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local ai ai_placed = NONE;
local real r_weight_placed = 0.0;

	dprint( "spops_ai_pool_place_loc: START" );
	s_active_cnt = s_active_cnt + 1;
	inspect( s_active_cnt );

	// defaults
	if ( r_distance_min < 0.0 ) then
		r_distance_min = spops_ai_place_distance_min_default();
	end
	if ( r_distance_max < 0.0 ) then
		r_distance_max = spops_ai_place_distance_max_default();
	end
	if ( r_safe_angle < 0.0 ) then
		r_safe_angle = spops_ai_place_angle_default();
	end

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != NONE
	if ( ai_ff_all == NONE ) then
		sleep_until( ai_ff_all != NONE, 1 );
	end

	repeat

		// wait
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			(
				f_ai_spawn_delay_check()
				and
				(
					( spops_ai_pool_current_ai() != NONE )
					and
					(
						(
							( r_pool_index_min < 0.0 )
							or
							( r_pool_index_min <= spops_ai_pool_current_index() )
						)
						and
						(
							( r_pool_index_max < 0.0 )
							or
							( r_pool_index_max >= spops_ai_pool_current_index() )
						)
					)
				)
				and
				(
					spops_ai_pool_place_priority_range_check( spops_ai_pool_place_priority(r_priority, flg_spawn_loc) )
					and
					(
						( spops_ai_pool_place_priority(r_priority, flg_spawn_loc) <= spops_ai_pool_place_priority_current() )
						or
						(
							b_priority_sub_distance
							and
							( spops_ai_pool_place_priority(r_priority, flg_spawn_loc) == spops_ai_pool_place_priority_current() )
							and
							( objects_distance_to_flag(Players(), flg_spawn_loc) < r_distance_sub )
						)
					)
				)
				and
				(
					( player_living_count() <= 0 )
					or
					(
						( objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_min )
						and
						(
							( objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_max )
							or
							( not objects_can_see_flag(Players(), flg_spawn_loc, r_safe_angle) )
						)
					)
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) ) then

			// store priority values
			local real r_priority_temp = spops_ai_pool_place_priority( r_priority, flg_spawn_loc );
			local real r_distance_sub_temp = objects_distance_to_flag( Players(), flg_spawn_loc );

			// share global priority settings and check if someone else should take over
			if ( (spops_ai_pool_active_ai() == NONE) or (r_priority_temp < spops_ai_pool_place_priority_current()) or f_chance(r_chance) ) then

				sys_spops_ai_pool_place_priority_current( r_priority_temp );
				r_distance_sub = r_distance_sub_temp;

				// grab the AI, he's getting spawned
				if ( spops_ai_pool_active_ai() == NONE ) then
					sys_spops_ai_pool_active( spops_ai_pool_queue_ai(), spops_ai_pool_queue_index(), spops_ai_pool_queue_weight() );
					spops_ai_pool_queue_reset();
				end

				// wait a frame to give everyone a chance to take over
				sleep( 1 );
			end

			// check if this is the current priority target
			if ( (r_priority_temp == spops_ai_pool_place_priority_current()) and (r_distance_sub == r_distance_sub_temp) ) then

				if ( ai_living_count(spops_ai_pool_active_ai()) > 0 ) then
				
					// place
					sys_spops_ai_place_post_loc( spops_ai_pool_active_ai(), flg_spawn_loc, TRUE, sid_objective, r_scale_target, r_scale_time );
					if ( r_weight_place_max >= 0.0 ) then
						r_weight_placed = r_weight_placed + spops_ai_pool_active_weight();
					end

					if ( r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE() ) then
						dprint( "spops_ai_pool_place_loc: DISTANCE" );
						inspect( r_priority_temp );
					else
						dprint( "spops_ai_pool_place_loc: PRIORITY" );
						inspect( r_priority );
					end
					
				end
				
				// reset placing
				spops_ai_pool_place_priority_current_reset();
				spops_ai_pool_active_reset();
				r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();

			end

		end

	until( ((r_weight_place_max > 0.0) and (r_weight_placed >= r_weight_place_max)) or (not isthreadvalid(l_thread)), 1 );
	dprint( "spops_ai_pool_place_loc: EXIT" );
	
	// decrement active cnt
	s_active_cnt = s_active_cnt - 1;
	inspect( s_active_cnt );

	// returns the last spawned dude
	ai_placed;
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_min, real r_distance_max )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, r_distance_min, r_distance_max, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, 1.0, 0.0, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, r_chance, NONE, 1.0, 0.0, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, 100.0, NONE, 1.0, 0.0, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max, real r_pool_index )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, r_pool_index, r_pool_index, 100.0, NONE, 1.0, 0.0, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place_max )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place_max, -1.0, -1.0, 100.0, NONE, 1.0, 0.0, -1.0, -1.0, -1.0 );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, -1.0, -1.0, -1.0, 100.0, NONE, 1.0, 0.0, -1.0, -1.0, -1.0 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: PHANTOM ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_phantom::: Places AI based on priority and POPULATIONs
// XXX document params
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place_max, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
static short s_active_cnt = 0;
static real r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local ai ai_placed = NONE;
local real r_weight_placed = 0.0;

	dprint( "spops_ai_pool_place_phantom: START" );
	
	s_active_cnt = s_active_cnt + 1;
	inspect( s_active_cnt );

	// defaults

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != NONE
	if ( ai_ff_all == NONE ) then
		sleep_until( ai_ff_all != NONE, 1 );
	end
/*	

	repeat

		// wait
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			(
				f_ai_spawn_delay_check()
				and
				(
					( spops_ai_pool_current_ai() != NONE )
					and
					(
						(
							( r_pool_index_min < 0.0 )
							or
							( r_pool_index_min <= spops_ai_pool_current_index() )
						)
						and
						(
							( r_pool_index_max < 0.0 )
							or
							( r_pool_index_max >= spops_ai_pool_current_index() )
						)
					)
				)
				and
				(
					spops_ai_pool_place_priority_range_check( spops_ai_pool_place_priority(r_priority, flg_spawn_phantom) )
					and
					(
						( spops_ai_pool_place_priority(r_priority, flg_spawn_phantom) <= spops_ai_pool_place_priority_current() )
						or
						(
							b_priority_sub_distance
							and
							( spops_ai_pool_place_priority(r_priority, flg_spawn_phantom) == spops_ai_pool_place_priority_current() )
							and
							( objects_distance_to_flag(Players(), flg_spawn_phantom) < r_distance_sub )
						)
					)
				)
				and
				(
					( player_living_count() <= 0 )
					or
					(
						( objects_distance_to_flag(Players(), flg_spawn_phantom) >= r_distance_min )
						and
						(
							( objects_distance_to_flag(Players(), flg_spawn_phantom) >= r_distance_max )
							or
							( not objects_can_see_flag(Players(), flg_spawn_phantom, r_safe_angle) )
						)
					)
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) ) then

			// store priority values
			local real r_priority_temp = spops_ai_pool_place_priority( r_priority, flg_spawn_phantom );
			local real r_distance_sub_temp = objects_distance_to_flag( Players(), flg_spawn_phantom );

			// share global priority settings and check if someone else should take over
			if ( (spops_ai_pool_active_ai() == NONE) or (r_priority_temp < spops_ai_pool_place_priority_current()) or f_chance(r_chance) ) then

				sys_spops_ai_pool_place_priority_current( r_priority_temp );
				r_distance_sub = r_distance_sub_temp;

				// grab the AI, he's getting spawned
				if ( spops_ai_pool_active_ai() == NONE ) then
					sys_spops_ai_pool_active( spops_ai_pool_queue_ai(), spops_ai_pool_queue_index(), spops_ai_pool_queue_weight() );
					spops_ai_pool_queue_reset();
				end

				// wait a frame to give everyone a chance to take over
				sleep( 1 );
			end

			// check if this is the current priority target
			if ( (r_priority_temp == spops_ai_pool_place_priority_current()) and (r_distance_sub == r_distance_sub_temp) ) then

				if ( ai_living_count(spops_ai_pool_active_ai()) > 0 ) then
				
					// place
					sys_spops_ai_place_post_phantom( spops_ai_pool_active_ai(), flg_spawn_phantom, TRUE, sid_objective, r_scale_target, r_scale_time );
					if ( r_weight_place_max >= 0.0 ) then
						r_weight_placed = r_weight_placed + spops_ai_pool_active_weight();
					end

					if ( r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE() ) then
						dprint( "spops_ai_pool_place_phantom: DISTANCE" );
						inspect( r_priority_temp );
					else
						dprint( "spops_ai_pool_place_phantom: PRIORITY" );
						inspect( r_priority );
					end
					
				end
				
				// reset placing
				spops_ai_pool_place_priority_current_reset();
				spops_ai_pool_active_reset();
				r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();

			end

		end

	until( ((r_weight_place_max > 0.0) and (r_weight_placed >= r_weight_place_max)) or (not isthreadvalid(l_thread)), 1 );
*/
	dprint( "spops_ai_pool_place_phantom: EXIT" );

	
	// decrement active cnt
	s_active_cnt = s_active_cnt - 1;
	inspect( s_active_cnt );

	// returns the last placed dude
	ai_placed;
end


























// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_pool_place_priority_current = 				DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_priority_current::: Gets the safe priority the system is using
script static real spops_ai_pool_place_priority_current()
	R_spops_ai_pool_place_priority_current;
end

// === spops_ai_pool_place_priority_current_reset::: Reset the safe priority default
script static void spops_ai_pool_place_priority_current_reset()

	if ( R_spops_ai_pool_place_priority_current != DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET() ) then
	
		dprint( "spops_ai_pool_place_priority_current_reset" );
		R_spops_ai_pool_place_priority_current = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET();
		
	end
	
end

// === spops_ai_pool_place_priority_current_reset::: Checks if the current priority needs to reset
script static void spops_ai_pool_place_priority_current_reset_check()
	
	if ( not spops_ai_pool_place_priority_range_check(spops_ai_pool_place_priority_current()) ) then
	
		dprint( "spops_ai_pool_place_priority_current_reset_check" );
		spops_ai_pool_place_priority_current_reset();
		
	end
	
end

// === spops_ai_pool_place_priority_current_reset::: Checks if the
script static real spops_ai_pool_place_priority( real r_priority, cutscene_flag flg_spawn_loc )
	if ( (r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE()) and (player_living_count() > 0) ) then
		r_priority = objects_distance_to_flag( Players(), flg_spawn_loc );
	end
	
	// return
	r_priority;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_place_priority_current( real r_priority )

	if ( (r_priority != R_spops_ai_pool_place_priority_current) and spops_ai_pool_place_priority_range_check(r_priority) ) then
		
		dprint( "sys_spops_ai_pool_place_priority_current:" );
		inspect( r_priority );
		R_spops_ai_pool_place_priority_current = r_priority;
		
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: PRIORITY: RANGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real 		R_spops_ai_pool_place_priority_range_min =			-1.0;
static real 		R_spops_ai_pool_place_priority_range_max =			-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_pool_place_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_pool_place_priority_range_min( r_priority_min );
	spops_ai_pool_place_priority_range_max( r_priority_max );
end

// === spops_ai_pool_place_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_pool_place_priority_range_min( real r_priority )

	if ( r_priority != R_spops_ai_pool_place_priority_range_min ) then

		if ( (r_priority < 0.0) or (r_priority <= spops_ai_pool_place_priority_range_max()) ) then

			dprint( "spops_ai_pool_place_priority_range_min:" );
			inspect( r_priority );
			R_spops_ai_pool_place_priority_range_min = r_priority;
			
			// check reset current based on range update
			spops_ai_pool_place_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_pool_place_priority_range_min( spops_ai_pool_place_priority_range_max() );
			spops_ai_pool_place_priority_range_max( r_priority_temp );
			
		end

	end

end
script static real spops_ai_pool_place_priority_range_min()
	if ( R_spops_ai_pool_place_priority_range_min != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_pool_place_priority_range_min;
	else
		spops_ai_global_priority_range_min();
	end
end

// === spops_ai_pool_place_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_place_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_pool_place_priority_range_max ) then

		if ( (r_priority < 0.0) or (spops_ai_pool_place_priority_range_min() <= r_priority) ) then

			dprint( "spops_ai_pool_place_priority_range_max:" );
			inspect( r_priority );
			R_spops_ai_pool_place_priority_range_max = r_priority;
	
			// check reset current based on range update
			spops_ai_pool_place_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_pool_place_priority_range_max( spops_ai_pool_place_priority_range_min() );
			spops_ai_pool_place_priority_range_min( r_priority_temp );
			
		end

	end

end
script static real spops_ai_pool_place_priority_range_max()
	if ( R_spops_ai_pool_place_priority_range_max != DEF_SPOPS_AI_GLOBAL_PRIORITY_GLOBAL() ) then
		R_spops_ai_pool_place_priority_range_max;
	else
		spops_ai_global_priority_range_max();
	end
end

// === spops_ai_pool_place_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_pool_place_priority_range_check( real r_priority )
	(
		( spops_ai_pool_place_priority_range_min() < 0.0 )
		or
		( r_priority >= spops_ai_pool_place_priority_range_min() )
	)
	and
	(
		( spops_ai_pool_place_priority_range_max() < 0.0 )
		or
		( r_priority <= spops_ai_pool_place_priority_range_max() )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short DEF_SPOPS_AI_MORALE_ALLY() 			1;	end
script static short DEF_SPOPS_AI_MORALE_TIED() 			0;	end
script static short DEF_SPOPS_AI_MORALE_ENEMY() 		-1;	end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale::: Compares weighted morale values of two sets of AI
// XXX document params
script static short spops_ai_morale( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player, real r_weight_ally, real r_weight_enemy, real r_weight_ally_leader, real r_weight_enemy_leader )

	// calculate weights
	r_weight_ally = spops_ai_morale_weight_ally( ai_ally, r_weight_ally, r_weight_ally_leader, r_distance_ally_player, r_weight_ally_player );
	r_weight_enemy = spops_ai_morale_weight_enemy( ai_enemy, r_weight_enemy, r_weight_enemy_leader, r_distance_enemy_player, r_weight_enemy_player );

	/*
	dprint( "------------------" );
	dprint( "spops_ai_morale" );
	inspect( r_weight_ally );
	inspect( r_weight_enemy );
	*/	
	// return
	if ( r_weight_ally > r_weight_enemy ) then
		DEF_SPOPS_AI_MORALE_ALLY();
	elseif ( r_weight_enemy > r_weight_ally ) then
		DEF_SPOPS_AI_MORALE_ENEMY();
	else
		DEF_SPOPS_AI_MORALE_TIED();
	end
end
script static short spops_ai_morale( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player, real r_weight_ally, real r_weight_enemy )
	spops_ai_morale( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, r_weight_ally_player, r_weight_enemy_player, r_weight_ally, r_weight_enemy, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static short spops_ai_morale( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player )
	spops_ai_morale( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, r_weight_ally_player, r_weight_enemy_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static short spops_ai_morale( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player )
	spops_ai_morale( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static short spops_ai_morale( ai ai_ally, ai ai_enemy )
	spops_ai_morale( ai_ally, ai_enemy, -1.0, -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end

// === spops_ai_morale_weight_ally::: Calculates the morale weight of an ai ally of player
// XXX document params
script static real spops_ai_morale_weight_ally( ai ai_morale, real r_weight_base, real r_weight_leader, real r_distance_player, real r_weight_player )

	// defaults
	if ( r_weight_base == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_base = spops_ai_morale_ally_weight_default();
	end
	if ( r_weight_player == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_player = spops_ai_morale_ally_player_weight_default();
	end
	if ( r_weight_leader == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_leader = spops_ai_morale_ally_leader_weight_default();
	end
	if ( r_distance_player < 0.0 ) then
		r_distance_player = spops_ai_morale_ally_player_distance_default();
	end

	// calculate weight
	spops_ai_morale_weight( ai_morale, r_weight_base, r_weight_leader, r_distance_player, r_weight_player );
end
script static real spops_ai_morale_weight_ally( ai ai_morale, real r_weight_base, real r_weight_leader, real r_distance_player )
	spops_ai_morale_weight_ally( ai_morale, r_weight_base, r_weight_leader, r_distance_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_ally( ai ai_morale, real r_weight_base, real r_weight_leader )
	spops_ai_morale_weight_ally( ai_morale, r_weight_base, r_weight_leader, -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_ally( ai ai_morale, real r_weight_base )
	spops_ai_morale_weight_ally( ai_morale, r_weight_base, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_ally( ai ai_morale )
	spops_ai_morale_weight_ally( ai_morale, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end

// === spops_ai_morale_weight_enemy::: Calculates the morale weight of an ai enemy of player
// XXX document params
script static real spops_ai_morale_weight_enemy( ai ai_morale, real r_weight_base, real r_weight_leader, real r_distance_player, real r_weight_player )

	// defaults
	if ( r_weight_base == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_base = spops_ai_morale_enemy_weight_default();
	end
	if ( r_weight_player == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_player = spops_ai_morale_enemy_player_weight_default();
	end
	if ( r_weight_leader == DEF_SPOPS_AI_MORALE_DEFAULT_USE() ) then
		r_weight_leader = spops_ai_morale_enemy_leader_weight_default();
	end
	if ( r_distance_player < 0.0 ) then
		r_distance_player = spops_ai_morale_enemy_player_distance_default();
	end

	// calculate weight
	spops_ai_morale_weight( ai_morale, r_weight_base, r_weight_leader, r_distance_player, r_weight_player );
end
script static real spops_ai_morale_weight_enemy( ai ai_morale, real r_weight_base, real r_weight_leader, real r_distance_player )
	spops_ai_morale_weight_enemy( ai_morale, r_weight_base, r_weight_leader, r_distance_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_enemy( ai ai_morale, real r_weight_base, real r_weight_leader )
	spops_ai_morale_weight_enemy( ai_morale, r_weight_base, r_weight_leader, -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_enemy( ai ai_morale, real r_weight_base )
	spops_ai_morale_weight_enemy( ai_morale, r_weight_base, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight_enemy( ai ai_morale )
	spops_ai_morale_weight_enemy( ai_morale, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end

// === spops_ai_morale_weight::: Calculates the morale weight of an ai
// XXX document params
// NOTE: DOES NOT SUPPORT DEFAULT VALUES BECAUSE THERE IS NO FACTION
script static real spops_ai_morale_weight( ai ai_morale, real r_weight_base, real r_weight_leader, real r_distance_player, real r_weight_player )
local real r_weight = ( ai_task_count(ai_morale) + ai_living_count(ai_morale) ) * r_weight_base;;

	if ( ai_leadership_all(ai_morale) ) then
		r_weight = r_weight + r_weight_leader;
	end

	if ( ((ai_task_count(ai_morale) + ai_living_count(ai_morale)) > 0) and (r_distance_player > 0.0) and (r_weight_player != 0.0) and (player_living_count() > 0) ) then
		r_weight = r_weight + ( players_in_object_list_range(ai_actors(ai_morale), r_distance_player, TRUE) * r_weight_player );
	end

	// return
	r_weight;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE: WEIGHTS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real 	DEF_SPOPS_AI_MORALE_DEFAULT_USE() 	-9999.9999;	end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE: WEIGHTS: AI ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_morale_ally_weight_default = 		1.0;
static real R_spops_ai_morale_enemy_weight_default = 		1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale_ally_weight_default::: Sets/Gets the morale ally weight default
// XXX document params
script static void spops_ai_morale_ally_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_ally_weight_default ) then
		
		dprint( "spops_ai_morale_ally_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_ally_weight_default = r_priority;

	end

end
script static real spops_ai_morale_ally_weight_default()
	R_spops_ai_morale_ally_weight_default;
end

// === spops_ai_morale_enemy_weight_default::: Sets/Gets the morale enemy weight default
// XXX document params
script static void spops_ai_morale_enemy_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_enemy_weight_default ) then

		dprint( "spops_ai_morale_enemy_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_enemy_weight_default = r_priority;

	end

end
script static real spops_ai_morale_enemy_weight_default()
	R_spops_ai_morale_enemy_weight_default;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE: WEIGHTS: LEADER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_morale_ally_leader_weight_default = 		5.0;
static real R_spops_ai_morale_enemy_leader_weight_default = 	5.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale_ally_leader_weight_default::: Sets/Gets the leader vs. ally weight default
// XXX document params
script static void spops_ai_morale_ally_leader_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_ally_leader_weight_default ) then

		dprint( "spops_ai_morale_ally_leader_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_ally_leader_weight_default = r_priority;

	end

end
script static real spops_ai_morale_ally_leader_weight_default()
	R_spops_ai_morale_ally_leader_weight_default;
end

// === spops_ai_morale_enemy_leader_weight_default::: Sets/Gets the leader vs. enemy weight default
// XXX document params
script static void spops_ai_morale_enemy_leader_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_enemy_leader_weight_default ) then

		dprint( "spops_ai_morale_enemy_leader_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_enemy_leader_weight_default = r_priority;

	end

end
script static real spops_ai_morale_enemy_leader_weight_default()
	R_spops_ai_morale_enemy_leader_weight_default;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE: WEIGHTS: PLAYER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_morale_ally_player_weight_default = 		5.0;
static real R_spops_ai_morale_enemy_player_weight_default = 	-0.50;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale_ally_player_weight_default::: Sets/Gets the player vs. ally weight default
// XXX document params
script static void spops_ai_morale_ally_player_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_ally_player_weight_default ) then

		dprint( "spops_ai_morale_ally_player_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_ally_player_weight_default = r_priority;

	end

end
script static real spops_ai_morale_ally_player_weight_default()
	R_spops_ai_morale_ally_player_weight_default;
end

// === spops_ai_morale_enemy_player_weight_default::: Sets/Gets the player vs. enemy weight default
// XXX document params
script static void spops_ai_morale_enemy_player_weight_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_enemy_player_weight_default ) then

		dprint( "spops_ai_morale_enemy_player_weight_default:" );
		inspect( r_priority );
		R_spops_ai_morale_enemy_player_weight_default = r_priority;

	end

end
script static real spops_ai_morale_enemy_player_weight_default()
	R_spops_ai_morale_enemy_player_weight_default;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE: RANGES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_morale_ally_player_distance_default = 		5.0;
static real R_spops_ai_morale_enemy_player_distance_default = 	2.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale_ally_player_distance_default::: Sets/Gets the morale ally vs. player range default
// XXX document params
script static void spops_ai_morale_ally_player_distance_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_ally_player_distance_default ) then

		dprint( "spops_ai_morale_ally_player_distance_default:" );
		inspect( r_priority );
		R_spops_ai_morale_ally_player_distance_default = r_priority;

	end

end
script static real spops_ai_morale_ally_player_distance_default()
	R_spops_ai_morale_ally_player_distance_default;
end

// === spops_ai_morale_enemy_player_distance_default::: Sets/Gets the morale enemy vs. player range default
// XXX document params
script static void spops_ai_morale_enemy_player_distance_default( real r_priority )

	if ( r_priority != R_spops_ai_morale_enemy_player_distance_default ) then

		dprint( "spops_ai_morale_enemy_player_distance_default:" );
		inspect( r_priority );
		R_spops_ai_morale_enemy_player_distance_default = r_priority;

	end

end
script static real spops_ai_morale_enemy_player_distance_default()
	R_spops_ai_morale_enemy_player_distance_default;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: ACTIVE CAMO MANAGER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_spops_ai_active_camo_manager_activate_status_min_default = 				ai_combat_status_active;
static short S_spops_ai_active_camo_manager_activate_status_max_default = 				ai_combat_status_dangerous;
static real R_spops_ai_active_camo_manager_activate_distance_min_default = 				5.0;
static real R_spops_ai_active_camo_manager_activate_distance_max_default = 				10.0;
static real R_spops_ai_active_camo_manager_activate_see_angle_default = 					25.0;
static real R_spops_ai_active_camo_manager_deactivate_distance_default = 					3.00;
static real R_spops_ai_active_camo_manager_deactivate_damage_recent_default = 		0.125;
static real R_spops_ai_active_camo_manager_reset_time_min_default = 							5.0;
static real R_spops_ai_active_camo_manager_reset_time_max_default = 							10.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_active_camo_manager::: Manages active camo on an AI
//			ai_squad [ai] = AI to manage active camo on
//				NOTE: This supports squads, squad groups, and spawn points but will only return the thread for the last ai
//			b_equipment_required [boolean; TRUE] = TRUE; check if the ai has active camo before enabling the functionality. FALSE; ignore this check
//			l_thread_valid [long; 0] = Checks if this thread is valid for active camo manager to work
//				NOTE: 0 will disable this check
//				NOTE: Note if this thread goes invalid, the whole manager will shut down
//			str_notify_use [string; ""] = Notification message to start active camo
//				NOTE: If you are using this functionality you will need to continue to rebroadcast this message for the ai to restart the active camo after it becomes deactivates
//			s_activate_status_min [short; default] = Minimum combat status of the AI to enable active camo
//			s_activate_status_max [short; default] = Maximum combat status of the AI to enable active camo
//				NOTE: If camo is enabled and the ai falls out of the activate_status range it will deactivate camo
//			r_activate_distance_min [real; default] = Minimum distance for AI to activate active camo
//				NOTE: This requires the r_activate_see_angle check to pass
//			r_activate_distance_max [real; default/r_activate_distance_min] = Maximum distance for AI to automatically activate active camo
//				NOTE: This must be > r_activate_distance_min for it to work
//			r_activate_see_angle [real; default] = See angle check for players that disables active camo activation for r_activate_distance_min
//			od_activate_readied_required [object_definition; NONE] = Weapon definition to check if readied before activating active camo
//				NOTE: NONE will ignore this check
//			r_deactivate_distance [real; default] = Distance from nearest player that will automatically decloak the AI
//				NOTE: Setting this to 0.0 will disable this check
//			r_deactivate_damage_recent [real; default] = Amount of recent shield+health damage that must happen to automatically decloak the AI
//				NOTE: Setting this to 0.0 will disable this check
//			r_reset_time_min [real; default] = Minimum time (seconds) after decloaking that the AI will wait before recloaking
//			r_reset_time_max [real; default/r_reset_time_min] = Maximum time (seconds) after decloaking that the AI will wait before recloaking
//	RETURNS:  [long] the thread id of the (last setup) manager
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time_min, real r_reset_time_max )
local object_list ol_actors = ai_actors( ai_squad );
local short s_index = list_count( ol_actors ) - 1;
local long l_return = 0;

	if ( s_index >= 0 ) then

		// defaults
		if ( s_activate_status_min < 0 ) then
			s_activate_status_min = spops_ai_active_camo_manager_activate_status_min_default();
		end
		if ( s_activate_status_max < 0 ) then
			s_activate_status_max = spops_ai_active_camo_manager_activate_status_max_default();
		end
		if ( r_activate_distance_min < 0.0 ) then
			r_activate_distance_min = spops_ai_active_camo_manager_activate_distance_min_default();
		end
		if ( r_activate_distance_max < 0.0 ) then
			r_activate_distance_max = spops_ai_active_camo_manager_activate_distance_max_default();
		end
		if ( r_activate_see_angle < 0.0 ) then
			r_activate_see_angle = spops_ai_active_camo_manager_activate_see_angle_default();
		end
		if ( r_deactivate_distance < 0.0 ) then
			r_deactivate_distance = spops_ai_active_camo_manager_deactivate_distance_default();
		end
		if ( r_deactivate_damage_recent < 0.0 ) then
			r_deactivate_damage_recent = spops_ai_active_camo_manager_deactivate_damage_recent_default();
		end
		if ( r_reset_time_min < 0.0 ) then
			r_reset_time_min = spops_ai_active_camo_manager_reset_time_min_default();
		end
		if ( r_reset_time_max < 0.0 ) then
			r_reset_time_max = spops_ai_active_camo_manager_reset_time_max_default();
		end

		// loop through the actors and setup the manager
		repeat

			l_return = thread( sys_spops_ai_active_camo_manager(object_get_ai(list_get(ol_actors,s_index)), b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, r_reset_time_min, r_reset_time_max) );
			s_index = s_index - 1;

		until ( s_index < 0, 1 );

	end

	// return
	l_return;

end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, r_reset_time, r_reset_time );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, od_activate_readied_required, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, r_activate_see_angle, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_min, r_activate_distance_max, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance, r_activate_distance, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, -1, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, -1, -1, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, "", -1, -1, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, 0, "", -1, -1, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad )
	spops_ai_active_camo_manager( ai_squad, TRUE, 0, "", -1, -1, -1.0, -1.0, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
end

// === spops_ai_active_camo_manager_activate_status_min_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_status_min_default( real r_val )
	if ( S_spops_ai_active_camo_manager_activate_status_min_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_activate_status_min_default: SET" );
		inspect( r_val );
		S_spops_ai_active_camo_manager_activate_status_min_default = r_val;
	end
end
script static short spops_ai_active_camo_manager_activate_status_min_default()
	S_spops_ai_active_camo_manager_activate_status_min_default;
end

// === spops_ai_active_camo_manager_activate_status_max_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_status_max_default( real r_val )
	if ( S_spops_ai_active_camo_manager_activate_status_max_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_activate_status_max_default: SET" );
		inspect( r_val );
		S_spops_ai_active_camo_manager_activate_status_max_default = r_val;
	end
end
script static short spops_ai_active_camo_manager_activate_status_max_default()
	S_spops_ai_active_camo_manager_activate_status_max_default;
end

// === spops_ai_active_camo_manager_activate_distance_min_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_distance_min_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_distance_min_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_activate_distance_min_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_activate_distance_min_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_distance_min_default()
	R_spops_ai_active_camo_manager_activate_distance_min_default;
end

// === spops_ai_active_camo_manager_activate_distance_max_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_distance_max_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_distance_max_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_activate_distance_max_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_activate_distance_max_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_distance_max_default()
	R_spops_ai_active_camo_manager_activate_distance_max_default;
end

// === spops_ai_active_camo_manager_activate_see_angle_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_see_angle_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_see_angle_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_activate_see_angle_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_activate_see_angle_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_see_angle_default()
	R_spops_ai_active_camo_manager_activate_see_angle_default;
end

// === spops_ai_active_camo_manager_deactivate_distance_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_deactivate_distance_default( real r_val )
	if ( R_spops_ai_active_camo_manager_deactivate_distance_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_deactivate_distance_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_deactivate_distance_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_deactivate_distance_default()
	R_spops_ai_active_camo_manager_deactivate_distance_default;
end

// === spops_ai_active_camo_manager_deactivate_damage_recent_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_deactivate_damage_recent_default( real r_val )
	if ( R_spops_ai_active_camo_manager_deactivate_damage_recent_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_deactivate_damage_recent_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_deactivate_damage_recent_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_deactivate_damage_recent_default()
	R_spops_ai_active_camo_manager_deactivate_damage_recent_default;
end

// === spops_ai_active_camo_manager_reset_time_min_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_reset_time_min_default( real r_val )
	if ( R_spops_ai_active_camo_manager_reset_time_min_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_reset_time_min_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_reset_time_min_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_reset_time_min_default()
	R_spops_ai_active_camo_manager_reset_time_min_default;
end

// === spops_ai_active_camo_manager_reset_time_max_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_reset_time_max_default( real r_val )
	if ( R_spops_ai_active_camo_manager_reset_time_max_default != r_val ) then
		dprint( "spops_ai_active_camo_manager_reset_time_max_default: SET" );
		inspect( r_val );
		R_spops_ai_active_camo_manager_reset_time_max_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_reset_time_max_default()
	R_spops_ai_active_camo_manager_reset_time_max_default;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_active_camo_manager( ai ai_actor, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_min, real r_activate_distance_max, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time_min, real r_reset_time_max )
	
	if ( (not b_equipment_required) or unit_has_equipment(ai_actor, 'objects\equipment\storm_active_camo\storm_active_camo.equipment') and ((l_thread_valid == 0) or isthreadvalid(l_thread_valid)) ) then
		local long l_timer = 0;
		local object obj_actor = ai_get_object( ai_actor );
		dprint( "sys_spops_ai_active_camo_manager: SETUP" ); 

		repeat
	
			//wait to activate
			sleep_until( 
				( unit_get_health(ai_actor) <= 0.0 )
				or
				(
					( l_thread_valid != 0 )
					and
					( not isthreadvalid(l_thread_valid) )
				)
				or
				(
					timer_expired( l_timer )
					and
					( (str_notify_use == "") or LevelEventStatus(str_notify_use) )
					and
					range_check( ai_combat_status(ai_actor), s_activate_status_min, s_activate_status_max )
					and
					(
						(
							( r_activate_distance_max > r_activate_distance_min )
							and
							( objects_distance_to_object(Players(), obj_actor) >= r_activate_distance_max )
						)
						or
						(
							( objects_distance_to_object(Players(), obj_actor) >= r_activate_distance_min )
							and
							( not objects_can_see_object(Players(), obj_actor, r_activate_see_angle) )
						)
					)
					and
					(
						( od_activate_readied_required == NONE )
						or
						unit_has_weapon_readied( ai_actor, od_activate_readied_required )
					)
				)
			, 1 );

			// activate camo
			if ( (unit_get_health(ai_actor) > 0.0) and ((l_thread_valid == 0) or isthreadvalid(l_thread_valid)) ) then
				ai_set_active_camo( ai_actor, TRUE );
				dprint( "sys_spops_ai_active_camo_manager: ACTIVE" ); 
				sleep_until( 
					( unit_get_health(ai_actor) <= 0.0 )
					or
					(
						( l_thread_valid != 0 )
						and
						( not isthreadvalid(l_thread_valid) )
					)
					or
					( not range_check(ai_combat_status(ai_actor), s_activate_status_min, s_activate_status_max) )
					or
					(
						( r_deactivate_distance != 0.0 )
						and
						( objects_distance_to_object(Players(),obj_actor) <= r_deactivate_distance )
					)
					or
					(
						( r_deactivate_damage_recent != 0.0 )
						and
						( (object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) >= r_deactivate_damage_recent )
					)
				, 1 );
			end

			// disable camo
			if ( unit_get_health(ai_actor) > 0.0 ) then
				ai_set_active_camo( ai_actor, FALSE );
				dprint( "sys_spops_ai_active_camo_manager: DISABLED" );
				if ( range_check(ai_combat_status(ai_actor), s_activate_status_min, s_activate_status_max) ) then
					l_timer = timer_stamp( r_reset_time_min, r_reset_time_max );
				end
			end

		until ( (unit_get_health(ai_actor) <= 0.0) or ((l_thread_valid != 0) and (not isthreadvalid(l_thread_valid))), 1 );

		dprint( "sys_spops_ai_active_camo_manager: SHUTDOWN" ); 
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MISC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static short players_in_object_list_range( object_list ol_list, real r_range, boolean b_range_in )
local short s_cnt = 0;

	if ( (unit_get_health(player0) > 0) and ((objects_distance_to_object(ol_list,player0) <= r_range) == b_range_in) ) then
		s_cnt = s_cnt + 1;
	end
	if ( (unit_get_health(player1) > 0) and ((objects_distance_to_object(ol_list,player1) <= r_range) == b_range_in) ) then
		s_cnt = s_cnt + 1;
	end
	if ( (unit_get_health(player2) > 0) and ((objects_distance_to_object(ol_list,player2) <= r_range) == b_range_in) ) then
		s_cnt = s_cnt + 1;
	end
	if ( (unit_get_health(player3) > 0) and ((objects_distance_to_object(ol_list,player3) <= r_range) == b_range_in) ) then
		s_cnt = s_cnt + 1;
	end

	s_cnt;
end

script static ai ai_get_squad_safe( ai ai_squad )
	if ( ai_get_squad(ai_squad) != NONE ) then
		ai_squad = ai_get_squad( ai_squad );
	end

	// return
	ai_squad;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN: LOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_pelican_load_ai::: XXX
// XXX document params
script static void spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad, string str_location, string str_location_toggle_override )
static string s_location_toggle = "RIGHT";
	spops_pelican_dprint( "spops_pelican_load" );
	spops_pelican_dprint( str_side );
	
	// place
	if ( (ai_squad != NONE) and (ai_living_count(ai_squad) <= 0)) then
		ai_place( ai_squad );
		sleep( 1 );
	end

	// check if it's toggle and... toggle
	if ( str_location == "TOGGLE" ) then
		spops_pelican_dprint( "spops_pelican_load: TOGGLE" );
		if ( str_location_toggle_override != "" ) then
			s_location_toggle = "str_location_toggle_override";
		elseif ( s_location_toggle == "RIGHT" ) then
			s_location_toggle = "LEFT";
		else
			s_location_toggle = "RIGHT";
		end
		str_location = s_location_toggle;
		spops_pelican_dprint( str_location );
	end

	// load
	if ( str_location == "LEFT" ) then
		spops_pelican_dprint( "spops_pelican_load: LEFT" );
		ai_vehicle_enter_immediate( ai_squad, vh_pelican, 'pelican_p_l' );
	end
	if ( str_location == "RIGHT" ) then
		spops_pelican_dprint( "spops_pelican_load: RIGHT" );
		ai_vehicle_enter_immediate( ai_squad, vh_pelican, 'pelican_p_r' );
	end
	if ( str_location == "VEHICLE" ) then
		spops_pelican_dprint( "spops_pelican_load: VEHICLE" );
		spops_pelican_load_cargo( vh_pelican, ai_vehicle_get_from_squad(ai_squad, 0) );
	end
				
end
script static void spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad, string str_location )
	spops_pelican_load_ai( vh_pelican, ai_squad, str_location, "" );
end
script static void spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad )
	spops_pelican_load_ai( vh_pelican, ai_squad, "TOGGLE", "" );
end

// === spops_pelican_load_cargo::: XXX
// XXX document params
script static void spops_pelican_load_cargo( vehicle vh_pelican, object obj_cargo )
	vehicle_load_magic( vh_pelican, 'pelican_lc', obj_cargo );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN: UNLOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_pelican_unload::: XXX
// XXX document params
script static void spops_pelican_unload( vehicle vh_pelican, string str_location, real r_delay )

	if ( str_location != "CARGO" ) then
		unit_open( vh_pelican );
		sleep_s( 2.0 );
		begin_random
			spops_pelican_unload_seat( vh_pelican, "pelican_p_l01", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_l02", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_l03", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_l04", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_l05", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_r01", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_r02", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_r03", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_r04", r_delay );
			spops_pelican_unload_seat( vh_pelican, "pelican_p_r05", r_delay );
		end

	end

	if ( str_location != "UNITS" ) then
		spops_pelican_unload_seat( vh_pelican, "pelican_lc", r_delay );
	end

	if ( str_location != "CARGO" ) then
		sleep_s( 2.0 );
		unit_close( vh_pelican );
	end

end
script static void spops_pelican_unload( vehicle vh_pelican, string str_location )
	spops_pelican_unload( vh_pelican, str_location, 0.25 );
end
script static void spops_pelican_unload( vehicle vh_pelican )
	spops_pelican_unload( vh_pelican, "ALL", 0.25 );
end

// === spops_pelican_unload_seat::: XXX
// XXX document params
script static void spops_pelican_unload_seat( vehicle vh_pelican, unit_seat_mapping usm_seat, real r_delay )
	vehicle_unload( vh_pelican, usm_seat );
	sleep_s( r_delay );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN: DEBUG ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean b_spops_pelican_dprint = TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void spops_pelican_dprint( string str_debug )
	if ( b_spops_pelican_dprint ) then
		dprint( str_debug );
	end
end

// JUNK/TEMP

/*
global long test_thread = 0;
script static void test_ai_pool()
local real r_priority = 1.0;
local real r_pool_index = 1.0;
local real r_pool_index_min = -1.0;
local real r_pool_index_max = -1.0;
local real r_timeout = 1.0;
local real r_weight_place_max = 10.0;
local real r_chance = 100.0;
local short s_spawn_cnt = 5;
local short s_squad_limit = 5;

	kill_thread( test_thread );
	test_thread = GetCurrentThreadId();
	dprint( "test_ai_pool" );
	ai_ff_all = gr_e8_m2_all;
	thread( spops_ai_pool(test_thread, test_unit_01, r_priority, r_pool_index, s_spawn_cnt, 1, s_squad_limit, 2.0, r_chance, r_timeout) );
	thread( spops_ai_pool(test_thread, test_unit_02, r_priority, r_pool_index, s_spawn_cnt, 1, s_squad_limit, 1.0, r_chance, r_timeout) );
	thread( spops_ai_pool_place_loc(test_thread, flg_test_01, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, 50.0) );
	thread( spops_ai_pool_place_loc(test_thread, flg_test_02, r_priority, r_weight_place_max, r_pool_index_min, r_pool_index_max, 50.0) );
	sleep_until( FALSE, 1 );

end
*/





/*

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: ELITE: SWORD & GUN ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_elite_sword_and_gun_sword_distance_min_default = 			3.50;
static real R_spops_ai_elite_sword_and_gun_sword_shield_min_default = 				0.50;
static real R_spops_ai_elite_sword_and_gun_face_distance_min_default = 				2.25;
static real R_spops_ai_elite_sword_and_gun_face_time_min_default = 						0.50;
static real R_spops_ai_elite_sword_and_gun_face_time_max_default = 						0.75;
static real R_spops_ai_elite_sword_and_gun_berzerk_timeout_default = 					2.00;
static real R_spops_ai_elite_sword_and_gun_reset_delay_min_default = 					5.00;
static real R_spops_ai_elite_sword_and_gun_reset_delay_max_default = 					7.50;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout, real r_reset_delay_min, real r_reset_delay_max )
	
	if ( unit_has_weapon(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') ) then
		dprint( "spops_ai_elite_sword_and_gun" );
		local long l_timer = 0;
		local object obj_elite = ai_get_object( ai_elite );

		// defaults
		if ( r_sword_distance_min < 0.0 ) then
			r_sword_distance_min = spops_ai_elite_sword_and_gun_sword_distance_min_default();
		end
		if ( r_sword_shield_min < 0.0 ) then
			r_sword_shield_min = spops_ai_elite_sword_and_gun_sword_shield_min_default();
		end
		if ( r_face_distance_min < 0.0 ) then
			r_face_distance_min = spops_ai_elite_sword_and_gun_face_distance_min_default();
		end
		if ( r_face_time_min < 0.0 ) then
			r_face_time_min = spops_ai_elite_sword_and_gun_face_time_min_default();
		end
		if ( r_face_time_max < 0.0 ) then
			r_face_time_max = spops_ai_elite_sword_and_gun_face_time_max_default();
		end
		if ( r_berzerk_timeout < 0.0 ) then
			r_berzerk_timeout = spops_ai_elite_sword_and_gun_berzerk_timeout_default();
		end
		if ( r_reset_delay_min < 0.0 ) then
			r_reset_delay_min = spops_ai_elite_sword_and_gun_reset_delay_min_default();
		end
		if ( r_reset_delay_max < 0.0 ) then
			r_reset_delay_max = spops_ai_elite_sword_and_gun_reset_delay_max_default();
		end

		if ( str_notify_start != "" ) then
			sleep_until( LevelEventStatus(str_notify_start), 1 );
		end

		repeat

			// wait for conditions to equip the sword
			sleep_until( (unit_get_health(ai_elite) <= 0.0) or ((not unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon')) and timer_expired(l_timer) and ((objects_distance_to_object(Players(),obj_elite) >= r_sword_distance_min) or (unit_get_shield(ai_elite) >= r_sword_shield_min))), 1 );

			// Face the player
			if ( (unit_get_health(ai_elite) > 0.0) and (object_get_recent_body_damage(obj_elite) <= 0.0) and (objects_distance_to_object(Players(),obj_elite) >= r_face_distance_min) ) then
				dprint( "spops_ai_elite_sword_and_gun: FACE" );
				cs_face_player( ai_elite, TRUE );
				l_timer = timer_stamp( r_face_time_min, r_face_time_max );
				sleep_until( timer_expired(l_timer) or (object_get_recent_body_damage(obj_elite) > 0.0) or (objects_distance_to_object(Players(),obj_elite) < r_face_distance_min), 1 );
				cs_face_player( ai_elite, FALSE );
			end

			// go berzerk!!!
			if ( unit_get_health(ai_elite) > 0.0 ) then
				dprint( "spops_ai_elite_sword_and_gun: BERZERK" );
				ai_berserk( ai_elite, TRUE );
				l_timer = timer_stamp( r_berzerk_timeout );
				sleep_until( (unit_get_health(ai_elite) <= 0.0) or unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') or timer_expired(l_timer), 1 );
			end

			// wait for need to reset sword
			if ( unit_get_health(ai_elite) > 0.0 ) then
				sleep_until( (unit_get_health(ai_elite) <= 0.0) or (not unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon')), 1 );
				dprint( "spops_ai_elite_sword_and_gun: RESET" );
				l_timer = timer_stamp( r_reset_delay_min, r_reset_delay_max );
			end

		until ( unit_get_health(ai_elite) <= 0.0, 1 );

	end
	
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout, real r_reset_delay )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, r_face_distance_min, r_face_time_min, r_face_time_max, r_berzerk_timeout, r_reset_delay, r_reset_delay );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, r_face_distance_min, r_face_time_min, r_face_time_max, r_berzerk_timeout, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min, real r_face_time_min, real r_face_time_max )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, r_face_distance_min, r_face_time_min, r_face_time_max, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min, real r_face_time )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, r_face_distance_min, r_face_time, r_face_time, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min, real r_face_distance_min )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, r_face_distance_min, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min, real r_sword_shield_min )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, r_sword_shield_min, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_min )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_min, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite )
	spops_ai_elite_sword_and_gun( ai_elite, "", -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_sword_distance_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_sword_distance_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_sword_distance_min_default()
	R_spops_ai_elite_sword_and_gun_sword_distance_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_sword_shield_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_sword_shield_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_sword_shield_min_default()
	R_spops_ai_elite_sword_and_gun_sword_shield_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_face_distance_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_face_distance_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_face_distance_min_default()
	R_spops_ai_elite_sword_and_gun_face_distance_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_face_time_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_face_time_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_face_time_min_default()
	R_spops_ai_elite_sword_and_gun_face_time_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_face_time_max_default( real r_val )
	R_spops_ai_elite_sword_and_gun_face_time_max_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_face_time_max_default()
	R_spops_ai_elite_sword_and_gun_face_time_max_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_berzerk_timeout_default( real r_val )
	R_spops_ai_elite_sword_and_gun_berzerk_timeout_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_berzerk_timeout_default()
	R_spops_ai_elite_sword_and_gun_berzerk_timeout_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_reset_delay_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_reset_delay_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_reset_delay_min_default()
	R_spops_ai_elite_sword_and_gun_reset_delay_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_reset_delay_max_default( real r_val )
	R_spops_ai_elite_sword_and_gun_reset_delay_max_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_reset_delay_max_default()
	R_spops_ai_elite_sword_and_gun_reset_delay_max_default;
end
*/
