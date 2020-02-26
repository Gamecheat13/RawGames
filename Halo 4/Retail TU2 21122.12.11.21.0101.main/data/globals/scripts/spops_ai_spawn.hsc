//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: GLOBAL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: GLOBAL: RESET ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global real DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET =  						8888.8888;
global real DEF_SPOPS_AI_GLOBAL_DISTANCE_RESET =  						9999.9999;
global ai DEF_SPOPS_AI_GLOBAL_AI_RESET =  										DEF_SPOPS_AI_GLOBAL_AI_NONE;
global real DEF_SPOPS_AI_GLOBAL_INDEX_RESET =  								-1.0;
global real DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET =  							-1.0;
global short DEF_SPOPS_AI_GLOBAL_ID_RESET = 									0;
global short DEF_SPOPS_AI_GLOBAL_COST_RESET =  								0;
global short DEF_SPOPS_AI_GLOBAL_POPULATION_LIMIT_RESET =  		0;

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: GLOBAL: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global real DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE = 					7777.7777;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real 		R_spops_ai_global_priority_range_min =				-1.0;
static real 		R_spops_ai_global_priority_range_max =				-1.0;

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

			//dprint( "spops_ai_global_priority_range_min:" );
			//inspect( r_priority );
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

			//dprint( "spops_ai_global_priority_range_max:" );
			//inspect( r_priority );
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
// *** SPOPS: AI: PLACE: DISTANCES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_place_distance_conditional_default = 		20.0;
static real  		R_spops_ai_place_distance_force_default = 					35.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_distance_defaults::: Sets the min and max safe distances defaults
// XXX document params
script static void spops_ai_place_distance_defaults( real r_distance_conditional, real r_distance_force )
	spops_ai_place_distance_conditional_default( r_distance_conditional );
	spops_ai_place_distance_force_default( r_distance_force );
end

// === spops_ai_place_distance_conditional_default::: Sets/Gets the min safe distances default
// XXX document params
script static void spops_ai_place_distance_conditional_default( real r_distance )

	if ( r_distance != R_spops_ai_place_distance_conditional_default ) then
		//dprint( "spops_ai_place_distance_conditional_default:" );
		//inspect( r_distance );
		R_spops_ai_place_distance_conditional_default = r_distance;
	end

end
script static short spops_ai_place_distance_conditional_default()
	R_spops_ai_place_distance_conditional_default;
end

// === spops_ai_place_distance_force_default::: Sets/Gets the max safe distances default
// XXX document params
script static short spops_ai_place_distance_force_default()
	R_spops_ai_place_distance_force_default;
end
script static void spops_ai_place_distance_force_default( real r_distance )

	if ( r_distance != R_spops_ai_place_distance_force_default ) then
		//dprint( "spops_ai_place_distance_force_default:" );
		//inspect( r_distance );
		R_spops_ai_place_distance_force_default = r_distance;
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
		//dprint( "spops_ai_place_angle_default:" );
		//inspect( r_angle );
		R_spops_ai_place_angle_default = r_angle;
	end

end
script static short spops_ai_place_angle_default()
	R_spops_ai_place_angle_default;
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
script static ai sys_spops_ai_place_pre( ai ai_target, real r_scale_target, real r_scale_time )

	// place
	ai_place_in_limbo( ai_target );

	// set the spawn delay
	f_ai_spawn_delay_start();

	//dprint( "sys_spops_ai_place_pre: CURRENT" );
	//inspect( spops_ai_population() );
			
	// get the character that was spawned		
	//ai_target = object_get_ai( list_get(ai_actors(ai_target), list_count(ai_actors(ai_target)) - 1) );
	
	// start scale small
	if ( (r_scale_target != 1.0) or (r_scale_time != 0.0) ) then
		object_set_scale( ai_get_object(ai_target), 0.0001, 0 );
	end

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
	if ( spops_ai_get_vehicle(ai_target) == DEF_SPOPS_AI_GLOBAL_AI_NONE ) then
		//dprint( "sys_spops_ai_place_pre: LOC" );
		object_move_to_flag( ai_get_object(ai_target), 0.0, flg_loc );
	else
		//dprint( "sys_spops_ai_place_pre: VEHICLE" );
		object_move_to_flag( spops_ai_get_vehicle(ai_target), 0.0, flg_loc );
	end
	sleep( 1 );

	// set objective
	if ( sid_objective != NONE ) then
		ai_set_objective( ai_get_squad_safe(ai_target), sid_objective );
		ai_set_objective( ai_target, sid_objective );
	end

	// check if needed to exit limbo					
	if ( b_limbo_exit and (ai_in_limbo_count(ai_target) > 0) ) then
		ai_exit_limbo( ai_target );
	end
	
	// scale
	if ( (r_scale_target != 1.0) or (r_scale_time != 0.0) ) then
		object_set_scale( ai_get_object(ai_target), r_scale_target, seconds_to_frames(r_scale_time) );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global string DEF_SPOPS_AI_POOL_NOTIFY_PLACED =						"SPOPS_AI_POOL_NOTIFY_PLACED";

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_spops_ai_pool_cnt = 												0;
global short S_spops_ai_pool_place_phantom_cnt =					0;
global short S_spops_ai_pool_place_loc_cnt =							0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool::: XXX
// XXX document params
// XXX defaults
script static ai spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight, real r_chance, real r_timeout, ai ai_parent, short s_parent_limit )
local short s_id = sys_spops_ai_pool_id_get();
local ai ai_spawned = DEF_SPOPS_AI_GLOBAL_AI_NONE;

	sys_spops_ai_pool_cnt_inc( 1 );

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != DEF_SPOPS_AI_GLOBAL_AI_NONE
	if ( ai_ff_all == DEF_SPOPS_AI_GLOBAL_AI_NONE ) then
		sleep_until( ai_ff_all != DEF_SPOPS_AI_GLOBAL_AI_NONE, 1 );
	end
	//dprint( "spops_ai_pool: START" );
	//inspect( s_id );
	//inspect( r_priority );
	//inspect( r_pool_index );
	//inspect( l_thread );
	//inspect( getcurrentthreadid() );

//script static real R_spops_ai_pool_queue_request_index_min
//script static real R_spops_ai_pool_queue_request_index_max

	repeat
		
		// success
		if ( S_spops_ai_pool_queue_placed_id == s_id ) then
			//dprint( "spops_ai_pool: SUCCESS" );
			//inspect( s_id );
			//inspect( r_priority );
			
			// reset placed id
			sys_spops_ai_pool_queue_placed_id_reset();
			
			// store spawned
			ai_spawned = ai_spawn;
			
			// decrement count
			if ( s_spawn_cnt > 0 ) then
				s_spawn_cnt = s_spawn_cnt - 1;
			end
			
		end
		
		// failed
		if ( S_spops_ai_pool_queue_claimed_id == s_id ) then
			//dprint( "spops_ai_pool: FAILED" );
			//inspect( s_id );
			//inspect( r_priority );
			sys_spops_ai_pool_queue_claimed_reset();
		end

		// wait
		//dprint( "spops_ai_pool: WAIT" );
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			( s_spawn_cnt == 0 )
			or
			(
				( S_spops_ai_pool_queue_request_id != DEF_SPOPS_AI_GLOBAL_ID_RESET )
				and
				( S_spops_ai_pool_queue_placed_id == DEF_SPOPS_AI_GLOBAL_ID_RESET )
				and
				(	// population checks
					spops_ai_pool_population_limit_check( s_spawn_cost )
					and
					( (spops_ai_population() + s_spawn_cost) <= spops_ai_pool_queue_request_population_limit() )			
				)
				and
				(	// priority checks
					spops_ai_pool_priority_range_check( r_priority )
					and
					(
						( r_priority < R_spops_ai_pool_queue_claimed_priority )
						or
						(
							( r_priority == R_spops_ai_pool_queue_claimed_priority )
							and
							f_chance( r_chance )
						)
					)
				)
				and
				( // index checks
					spops_ai_pool_index_range_check( r_pool_index )
					and
					(
						(
							( R_spops_ai_pool_queue_request_index_min < 0.0 )
							or
							( r_pool_index >= R_spops_ai_pool_queue_request_index_min )
						)
						and
						(
							( R_spops_ai_pool_queue_request_index_max < 0.0 )
							or
							( r_pool_index <= R_spops_ai_pool_queue_request_index_max )
						)
					)
				)
				and
				(	// squad limit checks
					( s_squad_limit < 0 )
					or
					( ai_living_count(ai_spawn) < s_squad_limit )
				)
				and
				( // parent limit checks
					( ai_parent == DEF_SPOPS_AI_GLOBAL_AI_NONE )
					or
					(
						( s_parent_limit < 0 )
						or
						(
							( ai_task_count(ai_parent) < s_parent_limit )
							and
							( ai_living_count(ai_parent) < s_parent_limit )
						)
					)
				)
			)
		, 1 );

		// add to ai queue
		if ( isthreadvalid(l_thread) and (s_spawn_cnt != 0) ) then

			//dprint( "spops_ai_pool: CLAIMED" );
			//inspect( s_id );
			//inspect( r_priority );
			//inspect( spops_ai_pool_queue_request_id() );
			
			sys_spops_ai_pool_queue_claimed_set( s_id, r_pool_index, r_priority, ai_spawn, r_weight, s_spawn_cost );

		end

	until( (s_spawn_cnt == 0) or (not isthreadvalid(l_thread)), 1 );
	//dprint( "spops_ai_pool: EXIT" );
	//inspect( s_spawn_cnt );
	//inspect( isthreadvalid(l_thread) );

	//inspect( s_id );
	//inspect( r_priority );
	//inspect( r_pool_index );
	//inspect( l_thread );
	//inspect( getcurrentthreadid() );
	
	// decrement active cnt
	sys_spops_ai_pool_cnt_inc( -1 );

	// returns the last spawned dude
	ai_spawned;
end
script static void spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight, real r_chance, real r_timeout )
	spops_ai_pool( l_thread, ai_spawn, r_priority, r_pool_index, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_weight, r_chance, r_timeout, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static void spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight, real r_chance )
	spops_ai_pool( l_thread, ai_spawn, r_priority, r_pool_index, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_weight, r_chance, -1.0, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static void spops_ai_pool( long l_thread, ai ai_spawn, real r_priority, real r_pool_index, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_weight )
	spops_ai_pool( l_thread, ai_spawn, r_priority, r_pool_index, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_weight, 100.0, -1.0, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end

// === spops_ai_pool_cnt::: Returns the count of active spawn pools
// XXX document params
script static short spops_ai_pool_cnt()
	S_spops_ai_pool_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_cnt( short s_cnt )

	if ( S_spops_ai_pool_cnt != s_cnt ) then
	
		//dprint( "sys_spops_ai_pool_cnt:" );
		S_spops_ai_pool_cnt = s_cnt;
		//inspect( S_spops_ai_pool_cnt );
		
	end

end
script static void sys_spops_ai_pool_cnt_inc( short s_inc )
	sys_spops_ai_pool_cnt( S_spops_ai_pool_cnt + s_inc );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: ID ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static short sys_spops_ai_pool_id_get()
static short s_id = 1;
	s_id = s_id + 1;
	s_id - 1;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_pool_population_limit = 						20;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_pool_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_pool_population_limit ) then
		//dprint( "spops_ai_pool_population_limit:" );
		//inspect( s_limit );
		S_spops_ai_pool_population_limit = s_limit;
		//if ( s_limit > 20 ) then
		//	//dprint( "spops_ai_pool_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		//end
	end

end
script static short spops_ai_pool_population_limit()
	S_spops_ai_pool_population_limit;
end

// === spops_ai_pool_population_limit_check::: XXX
script static boolean spops_ai_pool_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= S_spops_ai_pool_population_limit );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: REQUEST ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_spops_ai_pool_queue_request_id = 											DEF_SPOPS_AI_GLOBAL_ID_RESET;
global real R_spops_ai_pool_queue_request_priority = 									DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
global real R_spops_ai_pool_queue_request_distance = 									DEF_SPOPS_AI_GLOBAL_DISTANCE_RESET;
global real R_spops_ai_pool_queue_request_index_min = 								DEF_SPOPS_AI_GLOBAL_INDEX_RESET;
global real R_spops_ai_pool_queue_request_index_max = 								DEF_SPOPS_AI_GLOBAL_INDEX_RESET;
static short S_spops_ai_pool_queue_request_population_limit = 				DEF_SPOPS_AI_GLOBAL_POPULATION_LIMIT_RESET;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_request_id::: XXX
script static short spops_ai_pool_queue_request_id()
	S_spops_ai_pool_queue_request_id;
end
// === spops_ai_pool_queue_request_priority::: XXX
script static real spops_ai_pool_queue_request_priority()
	R_spops_ai_pool_queue_request_priority;
end
// === spops_ai_pool_queue_request_distance::: XXX
script static real spops_ai_pool_queue_request_distance()
	R_spops_ai_pool_queue_request_distance;
end
// === spops_ai_pool_queue_request_index_min::: XXX
script static real spops_ai_pool_queue_request_index_min()
	R_spops_ai_pool_queue_request_index_min;
end
// === spops_ai_pool_queue_request_index_max::: XXX
script static real spops_ai_pool_queue_request_index_max()
	R_spops_ai_pool_queue_request_index_max;
end
// === spops_ai_pool_queue_request_population_limit::: XXX
script static short spops_ai_pool_queue_request_population_limit()
	S_spops_ai_pool_queue_request_population_limit;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue_request_set( short s_id, real r_priority, real r_distance, real r_index_min, real r_index_max, short s_limit )
	//dprint( "sys_spops_ai_pool_queue_request_set" );
	
	if ( (S_spops_ai_pool_queue_claimed_id != DEF_SPOPS_AI_GLOBAL_ID_RESET) and (((r_index_min >= 0.0) and (R_spops_ai_pool_queue_claimed_index < r_index_min)) or ((r_index_max >= 0.0) and (R_spops_ai_pool_queue_claimed_index > r_index_max))) ) then
		sys_spops_ai_pool_queue_claimed_reset();
	end
	sys_spops_ai_pool_queue_request_id( s_id );
	sys_spops_ai_pool_queue_request_priority( r_priority );
	sys_spops_ai_pool_queue_request_distance( r_distance );
	sys_spops_ai_pool_queue_request_index_min( r_index_min );
	sys_spops_ai_pool_queue_request_index_max( r_index_max );
	sys_spops_ai_pool_queue_request_population_limit( s_limit );
	/*
	//inspect( s_id );
	//inspect( r_priority );
	//inspect( r_distance );
	//inspect( r_index_min );
	//inspect( r_index_max );
	//inspect( s_limit );
	*/
end
script static void sys_spops_ai_pool_queue_request_reset()
	//dprint( "sys_spops_ai_pool_queue_request_reset" );
	
	sys_spops_ai_pool_queue_request_id( DEF_SPOPS_AI_GLOBAL_ID_RESET );
	sys_spops_ai_pool_queue_request_priority( DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET );
	sys_spops_ai_pool_queue_request_distance( DEF_SPOPS_AI_GLOBAL_DISTANCE_RESET );
	sys_spops_ai_pool_queue_request_index_min( DEF_SPOPS_AI_GLOBAL_INDEX_RESET );
	sys_spops_ai_pool_queue_request_index_max( DEF_SPOPS_AI_GLOBAL_INDEX_RESET );
	sys_spops_ai_pool_queue_request_population_limit( DEF_SPOPS_AI_GLOBAL_POPULATION_LIMIT_RESET );
	
end
script static void sys_spops_ai_pool_queue_request_id( short s_val )

	if ( S_spops_ai_pool_queue_request_id != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_id" );
		S_spops_ai_pool_queue_request_id = s_val;
		//inspect( S_spops_ai_pool_queue_request_id );
	end
	
end
script static void sys_spops_ai_pool_queue_request_priority( real r_val )

	if ( R_spops_ai_pool_queue_request_priority != r_val ) then
		//dprint( "spops_ai_pool_queue_request_priority" );
		R_spops_ai_pool_queue_request_priority = r_val;
		//inspect( R_spops_ai_pool_queue_request_priority );
	end
	
end
script static void sys_spops_ai_pool_queue_request_distance( real r_val )

	if ( R_spops_ai_pool_queue_request_distance != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_distance" );
		R_spops_ai_pool_queue_request_distance = r_val;
		//inspect( R_spops_ai_pool_queue_request_distance );
	end
	
end
script static void sys_spops_ai_pool_queue_request_index_min( real r_val )

	if ( R_spops_ai_pool_queue_request_index_min != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_index_min" );
		R_spops_ai_pool_queue_request_index_min = r_val;
		//inspect( R_spops_ai_pool_queue_request_index_min );
	end
	
end
script static void sys_spops_ai_pool_queue_request_index_max( real r_val )

	if ( R_spops_ai_pool_queue_request_index_max != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_index_max" );
		R_spops_ai_pool_queue_request_index_max = r_val;
		//inspect( R_spops_ai_pool_queue_request_index_max );
	end
	
end
script static void sys_spops_ai_pool_queue_request_population_limit( short s_val )

	if ( S_spops_ai_pool_queue_request_population_limit != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_population_limit" );
		S_spops_ai_pool_queue_request_population_limit = s_val;
		//inspect( S_spops_ai_pool_queue_request_population_limit );
	end
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: QUEUE: CLAIMED ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_spops_ai_pool_queue_claimed_id = 										DEF_SPOPS_AI_GLOBAL_ID_RESET;
global ai AI_spops_ai_pool_queue_claimed_place = 									DEF_SPOPS_AI_GLOBAL_AI_RESET;
global real R_spops_ai_pool_queue_claimed_index = 									DEF_SPOPS_AI_GLOBAL_INDEX_RESET;
global real R_spops_ai_pool_queue_claimed_priority = 							DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
global real R_spops_ai_pool_queue_claimed_weight = 								DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET;
global short S_spops_ai_pool_queue_claimed_cost = 									DEF_SPOPS_AI_GLOBAL_COST_RESET;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_claimed_id::: XXX
script static short spops_ai_pool_queue_claimed_id()
	S_spops_ai_pool_queue_claimed_id;
end
// === spops_ai_pool_queue_claimed_place::: XXX
script static ai spops_ai_pool_queue_claimed_place()
	AI_spops_ai_pool_queue_claimed_place;
end
// === spops_ai_pool_queue_claimed_index::: XXX
script static real spops_ai_pool_queue_claimed_index()
	R_spops_ai_pool_queue_claimed_index;
end
// === spops_ai_pool_queue_claimed_priority::: XXX
script static real spops_ai_pool_queue_claimed_priority()
	R_spops_ai_pool_queue_claimed_priority;
end
// === spops_ai_pool_queue_claimed_weight::: XXX
script static real spops_ai_pool_queue_claimed_weight()
	R_spops_ai_pool_queue_claimed_weight;
end
// === spops_ai_pool_queue_claimed_cost::: XXX
script static short spops_ai_pool_queue_claimed_cost()
	S_spops_ai_pool_queue_claimed_cost;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue_claimed_set( short s_id, real r_index, real r_priority, ai ai_spawn, real r_weight, short s_cost )
	//dprint( "sys_spops_ai_pool_queue_claimed_set" );
	sys_spops_ai_pool_queue_claimed_id( s_id );
	sys_spops_ai_pool_queue_claimed_index( r_index );
	sys_spops_ai_pool_queue_claimed_priority( r_priority );
	sys_spops_ai_pool_queue_claimed_place( ai_spawn );
	sys_spops_ai_pool_queue_claimed_weight( r_weight );
	sys_spops_ai_pool_queue_claimed_cost( s_cost );
	/*
	//inspect( s_id );
	//inspect( r_index );
	//inspect( r_priority );
	//inspect( r_weight );
	//inspect( s_cost );
	*/
end
script static void sys_spops_ai_pool_queue_claimed_reset()
	//dprint( "sys_spops_ai_pool_queue_claimed_reset" );
	sys_spops_ai_pool_queue_claimed_id( DEF_SPOPS_AI_GLOBAL_ID_RESET );
	sys_spops_ai_pool_queue_claimed_index( DEF_SPOPS_AI_GLOBAL_INDEX_RESET );
	sys_spops_ai_pool_queue_claimed_priority( DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET );
	sys_spops_ai_pool_queue_claimed_place( DEF_SPOPS_AI_GLOBAL_AI_RESET );
	sys_spops_ai_pool_queue_claimed_weight( DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET );
	sys_spops_ai_pool_queue_claimed_cost( DEF_SPOPS_AI_GLOBAL_COST_RESET );
end
script static void sys_spops_ai_pool_queue_claimed_id( short s_val )

	if ( S_spops_ai_pool_queue_claimed_id != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_id" );
		S_spops_ai_pool_queue_claimed_id = s_val;
		//inspect( S_spops_ai_pool_queue_claimed_id );
	end
	
end
script static void sys_spops_ai_pool_queue_claimed_place( ai ai_val )

	if ( AI_spops_ai_pool_queue_claimed_place != ai_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_place" );
		AI_spops_ai_pool_queue_claimed_place = ai_val;
		//inspect( AI_spops_ai_pool_queue_claimed_place );
	end
	
end
script static void sys_spops_ai_pool_queue_claimed_index( real r_val )

	if ( R_spops_ai_pool_queue_claimed_index != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_index" );
		R_spops_ai_pool_queue_claimed_index = r_val;
		//inspect( R_spops_ai_pool_queue_claimed_index );
	end
	
end
script static void sys_spops_ai_pool_queue_claimed_priority( real r_val )

	if ( R_spops_ai_pool_queue_claimed_priority != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_priority" );
		R_spops_ai_pool_queue_claimed_priority = r_val;
		//inspect( R_spops_ai_pool_queue_claimed_priority );
	end
	
end
script static void sys_spops_ai_pool_queue_claimed_weight( real r_val )

	if ( R_spops_ai_pool_queue_claimed_weight != r_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_weight" );
		R_spops_ai_pool_queue_claimed_weight = r_val;
		//inspect( R_spops_ai_pool_queue_claimed_weight );
	end
	
end
script static void sys_spops_ai_pool_queue_claimed_cost( short s_val )

	if ( S_spops_ai_pool_queue_claimed_cost != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_claimed_cost" );
		S_spops_ai_pool_queue_claimed_cost = s_val;
		//inspect( S_spops_ai_pool_queue_claimed_cost );
	end
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: QUEUE: PLACED ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_spops_ai_pool_queue_placed_id = 						DEF_SPOPS_AI_GLOBAL_ID_RESET;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_placed_id::: XXX
script static short spops_ai_pool_queue_placed_id()
	S_spops_ai_pool_queue_placed_id;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue_placed_id( short s_val )

	if ( S_spops_ai_pool_queue_placed_id != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_placed_id" );
		//inspect( s_val );
		S_spops_ai_pool_queue_placed_id = s_val;
		
		// reset the claimed pool
		sys_spops_ai_pool_queue_claimed_reset();
	end
	
end
script static void sys_spops_ai_pool_queue_placed_id_reset()
	//dprint( "sys_spops_ai_pool_queue_placed_id_reset" );
	S_spops_ai_pool_queue_placed_id = DEF_SPOPS_AI_GLOBAL_ID_RESET;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: QUEUE: FAIL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_spops_ai_pool_queue_request_fail_wait_cnt = 						0;
static short S_spops_ai_pool_queue_request_fail_check_cnt = 					0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_request_fail_wait_cnt::: XXX
script static short spops_ai_pool_queue_request_fail_wait_cnt()
	S_spops_ai_pool_queue_request_fail_wait_cnt;
end
// === spops_ai_pool_queue_request_fail_check_cnt::: XXX
script static short spops_ai_pool_queue_request_fail_check_cnt()
	S_spops_ai_pool_queue_request_fail_check_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue_request_fail_check_reset()
	S_spops_ai_pool_queue_request_fail_check_cnt = 0;
end
script static void sys_spops_ai_pool_queue_request_fail_wait( long l_thread )
	sys_spops_ai_pool_queue_request_fail_check_reset();
	S_spops_ai_pool_queue_request_fail_wait_cnt = S_spops_ai_pool_queue_request_fail_wait_cnt + 1;
/*	
	//dprint( "sys_spops_ai_pool_queue_request_fail_wait: START" );
	//inspect( isthreadvalid(l_thread) );
	//inspect( S_spops_ai_pool_queue_request_fail_wait_cnt );
	//inspect( S_spops_ai_pool_queue_request_fail_check_cnt );
	//inspect( spops_ai_pool_place_cnt() );
	//inspect( S_spops_ai_pool_cnt );
*/
	sleep_until( (not isthreadvalid(l_thread)) or LevelEventStatus(DEF_SPOPS_AI_POOL_NOTIFY_PLACED) or ((S_spops_ai_pool_queue_request_fail_wait_cnt + S_spops_ai_pool_queue_request_fail_check_cnt) > spops_ai_pool_place_cnt()) or (S_spops_ai_pool_cnt <= 0), 1 );
/*	
	//dprint( "sys_spops_ai_pool_queue_request_fail_wait: COMPLETE" );
	//inspect( isthreadvalid(l_thread) );
	//inspect( LevelEventStatus(DEF_SPOPS_AI_POOL_NOTIFY_PLACED) );
	//inspect( S_spops_ai_pool_queue_request_fail_wait_cnt );
	//inspect( S_spops_ai_pool_queue_request_fail_check_cnt );
	//inspect( spops_ai_pool_place_cnt() );
	//inspect( S_spops_ai_pool_cnt );
*/
	if ( S_spops_ai_pool_queue_request_fail_wait_cnt > 0 ) then
		S_spops_ai_pool_queue_request_fail_wait_cnt = S_spops_ai_pool_queue_request_fail_wait_cnt - 1;
	end
end
script static boolean sys_spops_ai_pool_queue_request_fail_check()
	if ( S_spops_ai_pool_queue_request_fail_wait_cnt != 0 ) then
		S_spops_ai_pool_queue_request_fail_check_cnt = S_spops_ai_pool_queue_request_fail_check_cnt + 1;
	end
	FALSE;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: CNT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static short spops_ai_pool_place_cnt()
	S_spops_ai_pool_place_loc_cnt + S_spops_ai_pool_place_phantom_cnt;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_pool_priority_range_min =					-1.0;
static real R_spops_ai_pool_priority_range_max =					-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_pool_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_pool_priority_range_min( r_priority_min );
	spops_ai_pool_priority_range_max( r_priority_max );
end

// === spops_ai_pool_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_pool_priority_range_min( real r_val )

	if ( R_spops_ai_pool_priority_range_min != r_val ) then
		R_spops_ai_pool_priority_range_min = r_val;
	end

end
script static real spops_ai_pool_priority_range_min()
	R_spops_ai_pool_priority_range_min;
end

// === spops_ai_pool_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_priority_range_max( real r_val )

	if ( R_spops_ai_pool_priority_range_max != r_val ) then
		R_spops_ai_pool_priority_range_max = r_val;
	end

end
script static real spops_ai_pool_priority_range_max()
	R_spops_ai_pool_priority_range_max;
end

// === spops_ai_pool_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_pool_priority_range_check( real r_priority )
	(
		( R_spops_ai_pool_priority_range_min < 0.0 )
		or
		( r_priority >= R_spops_ai_pool_priority_range_min )
	)
	and
	(
		( R_spops_ai_pool_priority_range_max < 0.0 )
		or
		( r_priority <= R_spops_ai_pool_priority_range_max )
	);
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: INDEX ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_pool_index_range_min =					-1.0;
static real R_spops_ai_pool_index_range_max =					-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_index_range::: Sets the safe index range_min and max
// XXX document params
script static void spops_ai_pool_index_range( real r_index_min, real r_index_max )
	spops_ai_pool_index_range_min( r_index_min );
	spops_ai_pool_index_range_max( r_index_max );
end

// === spops_ai_pool_index_range_min::: Sets/Gets the safe index range_min
// XXX document params
script static void spops_ai_pool_index_range_min( real r_val )

	if ( R_spops_ai_pool_index_range_min != r_val ) then
		R_spops_ai_pool_index_range_min = r_val;
	end

end
script static real spops_ai_pool_index_range_min()
	R_spops_ai_pool_index_range_min;
end

// === spops_ai_pool_index_range_max::: Sets/Gets the safe index range_max
// XXX document params
script static void spops_ai_pool_index_range_max( real r_val )

	if ( R_spops_ai_pool_index_range_max != r_val ) then
		R_spops_ai_pool_index_range_max = r_val;
	end

end
script static real spops_ai_pool_index_range_max()
	R_spops_ai_pool_index_range_max;
end

// === spops_ai_pool_index_range_check::: Checks if a index value is within the index ranges
// XXX document params
script static boolean spops_ai_pool_index_range_check( real r_index )
	(
		( R_spops_ai_pool_index_range_min < 0.0 )
		or
		( r_index >= R_spops_ai_pool_index_range_min )
	)
	and
	(
		( R_spops_ai_pool_index_range_max < 0.0 )
		or
		( r_index <= R_spops_ai_pool_index_range_max )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: LOC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

script static boolean inspect_inline_str( string str_val, boolean b_return )
	//dprint( str_val );
	b_return;
end
script static boolean inspect_inline_s( short s_val, boolean b_return )
	//inspect( s_val );
	b_return;
end
script static boolean inspect_inline_l( long l_val, boolean b_return )
	//inspect( l_val );
	b_return;
end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_loc::: Places AI pool characters at a location
// XXX document params
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_conditional, real r_distance_force, real r_safe_angle, ai ai_parent, short s_parent_limit, boolean b_limbo )
local short s_id = sys_spops_ai_pool_id_get();
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local boolean b_distance_force_check = ( r_distance_force >= 0.0 );
local boolean b_distance_conditional_check = ( r_distance_conditional >= 0.0 );
local boolean b_angle_conditional_check = ( r_safe_angle >= 0.0 );
local ai ai_placed = DEF_SPOPS_AI_GLOBAL_AI_NONE;
local boolean b_place_attempt = FALSE;

	// inc pool counter
	sys_spops_ai_pool_place_loc_cnt_inc( 1 );
	
	// force abs values
	r_distance_force = abs_r( r_distance_force );
	r_distance_conditional = abs_r( r_distance_conditional );
	r_safe_angle = abs_r( r_safe_angle );

	// wait for the all group to be != DEF_SPOPS_AI_GLOBAL_AI_NONE
	if ( ai_ff_all == DEF_SPOPS_AI_GLOBAL_AI_NONE ) then
		sleep_until( ai_ff_all != DEF_SPOPS_AI_GLOBAL_AI_NONE, 1 );
	end
	//dprint( "spops_ai_pool_place_loc: START" );
	/*
	//inspect( l_thread );
	//inspect( r_priority );
	//inspect( r_weight_place );
	//inspect( r_pool_index_min );
	//inspect( r_pool_index_max );
	//inspect( r_chance );
	//inspect( sid_objective );
	//inspect( r_scale_target );
	//inspect( r_scale_time );
	//inspect( r_distance_conditional );
	//inspect( r_distance_force );
	//inspect( r_safe_angle );
	//inspect( s_parent_limit );
	*/

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );
	//inspect( r_priority );
	//inspect( s_parent_limit );

	repeat

		// wait
		//dprint( "spops_ai_pool_place_loc: WATCH" );
		
		sleep_until(
			( not isthreadvalid(l_thread) )
			or
			( r_weight_place == 0.0 )
			or
			(
				( S_spops_ai_pool_cnt > 0 )
				and
				f_ai_spawn_delay_check()
				and
				( S_spops_ai_pool_queue_placed_id == DEF_SPOPS_AI_GLOBAL_ID_RESET )
				and
				(
					(
						( spops_ai_population() < S_spops_ai_pool_place_loc_population_limit )
						and
						(
							spops_ai_pool_place_loc_priority_range_check( r_priority )
							and
							(
								( r_priority < R_spops_ai_pool_queue_request_priority )
								or
								(
									( r_priority == R_spops_ai_pool_queue_request_priority )
									and
									(
										(
											b_priority_sub_distance
											and
											( objects_distance_to_flag(Players(), flg_spawn_loc) < R_spops_ai_pool_queue_request_distance )
										)
										or
										(
											( not b_priority_sub_distance )
											and
											f_chance( r_chance )
										)
									)
								)
							)
						)
						and
						(
							( ai_parent == DEF_SPOPS_AI_GLOBAL_AI_NONE )
							or
							( s_parent_limit <= 0 )
							or
							(
								( ai_task_count(ai_parent) < s_parent_limit )
								and
								( ai_living_count(ai_parent) < s_parent_limit )
							)
						)
						and
						(
							( spops_player_living_cnt() > 0)
							or
							(
								( r_distance_force == 0.0 )
								and
								( r_distance_conditional == 0.0 )
							)
						)
						and
						(
							(
								( r_distance_force != 0.0 )
								and
								( (objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_force) == b_distance_force_check )
							)
							or
							(
								(
									( r_distance_conditional == 0.0 )
									or
									( (objects_distance_to_flag(Players(), flg_spawn_loc) >= r_distance_conditional) == b_distance_conditional_check )
								)
								or
								(
									( r_safe_angle == 0.0 )
									or
									( objects_can_see_flag(Players(), flg_spawn_loc, r_safe_angle) != b_angle_conditional_check )
								)
							)
						)
					)
					or
					sys_spops_ai_pool_queue_request_fail_check()
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) and (r_weight_place != 0.0) ) then
		
			//dprint( "spops_ai_pool_place_loc: SET" );
			//inspect( s_id );
			//inspect( r_priority );
			b_place_attempt = TRUE;
			sys_spops_ai_pool_queue_request_set( s_id, r_priority, objects_distance_to_flag(Players(), flg_spawn_loc), r_pool_index_min, r_pool_index_max, S_spops_ai_pool_place_loc_population_limit );
			sleep( 1 );

			if ( S_spops_ai_pool_queue_request_id == s_id ) then
				//dprint( "spops_ai_pool_place_loc: MATCH" );
	
				// reset request
				sys_spops_ai_pool_queue_request_reset();
	
				if ( (AI_spops_ai_pool_queue_claimed_place != DEF_SPOPS_AI_GLOBAL_AI_RESET) and spops_ai_pool_place_loc_population_limit_check(S_spops_ai_pool_queue_claimed_cost) ) then
					//dprint( "spops_ai_pool_place_loc: SUCCESS" );
					//inspect( s_id );
					//inspect( S_spops_ai_pool_queue_claimed_id );
		
					// notify placed				
					NotifyLevel( DEF_SPOPS_AI_POOL_NOTIFY_PLACED );
					
					// weight
					//dprint( "spops_ai_pool_place_loc: WEIGHT" );
					//inspect( R_spops_ai_pool_queue_claimed_weight );
					if ( r_weight_place > 0.0 ) then
						r_weight_place = r_weight_place - R_spops_ai_pool_queue_claimed_weight;
						if ( r_weight_place < 0.0 ) then
							r_weight_place = 0.0;
						end
					end
					//inspect( r_weight_place );
	
					// grab the ai to place
					//dprint( "spops_ai_pool_place_loc: AI" );
					ai_placed = AI_spops_ai_pool_queue_claimed_place;
	
					// set the current id as placed
					//dprint( "spops_ai_pool_place_loc: PLACED ID" );
					sys_spops_ai_pool_queue_placed_id( S_spops_ai_pool_queue_claimed_id );
					
					// pre-place the ai
					//dprint( "spops_ai_pool_place_loc: PLACE PRE" );
					sys_spops_ai_place_pre( ai_placed, r_scale_target, r_scale_time );
	
					// finalize the ai placement						
					//dprint( "spops_ai_pool_place_loc: PLACE POST" );
					sys_spops_ai_place_post_loc( ai_placed, flg_spawn_loc, not b_limbo, sid_objective, r_scale_target, r_scale_time );
					//dprint( "spops_ai_pool_place_loc: DONE" );
				
				else
	
					//dprint( "spops_ai_pool_place_loc: FAIL" );
					sys_spops_ai_pool_queue_request_fail_wait( l_thread );
					//dprint( "spops_ai_pool_place_loc: FAIL: COMPLETE" );
				
				end
			
			elseif ( r_priority == R_spops_ai_pool_queue_request_priority ) then
				sleep( 1 );
			end

		end

	until( (r_weight_place == 0.0) or (not isthreadvalid(l_thread)), 1 );
	//dprint( "spops_ai_pool_place_loc: EXIT" );
	
	// decrement active cnt
	sys_spops_ai_pool_place_loc_cnt_inc( -1 );
	// returns the last spawned dude
	ai_placed;
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_conditional, real r_distance_force, real r_safe_angle, ai ai_parent, short s_parent_limit )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, r_distance_conditional, r_distance_force, r_safe_angle, ai_parent, s_parent_limit, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_conditional, real r_distance_force, real r_safe_angle )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, r_distance_conditional, r_distance_force, spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time, real r_distance_conditional, real r_distance_force )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, r_distance_conditional, r_distance_force, spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, real r_scale_target, real r_scale_time )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, r_scale_target, r_scale_time, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, NONE, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 100.0, NONE, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place, real r_pool_index )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, r_pool_index, r_pool_index, 100.0, NONE, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority, real r_weight_place )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, r_weight_place, -1.0, -1.0, 100.0, NONE, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end
script static ai spops_ai_pool_place_loc( long l_thread, cutscene_flag flg_spawn_loc, real r_priority )
	spops_ai_pool_place_loc( l_thread, flg_spawn_loc, r_priority, -1.0, -1.0, -1.0, 100.0, NONE, 1.0, 0.0, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default(), DEF_SPOPS_AI_GLOBAL_AI_NONE, -1, FALSE );
end

// === spops_ai_pool_place_loc_cnt::: Returns the count of active spawn pools
// XXX document params
script static short spops_ai_pool_place_loc_cnt()
	S_spops_ai_pool_place_loc_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_place_loc_cnt( short s_cnt )

	if ( S_spops_ai_pool_place_loc_cnt != s_cnt ) then
		//dprint( "sys_spops_ai_pool_place_loc_cnt:" );
		S_spops_ai_pool_place_loc_cnt = s_cnt;
		//inspect( S_spops_ai_pool_place_loc_cnt );
	end

end
script static void sys_spops_ai_pool_place_loc_cnt_inc( short s_inc )
	sys_spops_ai_pool_place_loc_cnt( spops_ai_pool_place_loc_cnt() + s_inc );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: LOC: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_pool_place_loc_population_limit = 						20;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_loc_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_pool_place_loc_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_pool_place_loc_population_limit ) then
		//dprint( "spops_ai_pool_place_loc_population_limit:" );
		//inspect( s_limit );
		S_spops_ai_pool_place_loc_population_limit = s_limit;
		//if ( s_limit > 20 ) then
		//	//dprint( "spops_ai_pool_place_loc_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		//end
	end

end
script static short spops_ai_pool_place_loc_population_limit()
	S_spops_ai_pool_place_loc_population_limit;
end

// === spops_ai_pool_place_loc_population_limit_check::: XXX
script static boolean spops_ai_pool_place_loc_population_limit_check( short s_cnt )
	( spops_ai_population() + s_cnt ) <= S_spops_ai_pool_place_loc_population_limit;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: LOC: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_pool_place_loc_priority_range_min =					-1.0;
static real R_spops_ai_pool_place_loc_priority_range_max =					-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_loc_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_pool_place_loc_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_pool_place_loc_priority_range_min( r_priority_min );
	spops_ai_pool_place_loc_priority_range_max( r_priority_max );
end

// === spops_ai_pool_place_loc_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_pool_place_loc_priority_range_min( real r_val )

	if ( R_spops_ai_pool_place_loc_priority_range_min != r_val ) then
		R_spops_ai_pool_place_loc_priority_range_min = r_val;
	end

end
script static real spops_ai_pool_place_loc_priority_range_min()
	R_spops_ai_pool_place_loc_priority_range_min;
end

// === spops_ai_pool_place_loc_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_place_loc_priority_range_max( real r_val )

	if ( R_spops_ai_pool_place_loc_priority_range_max != r_val ) then
		R_spops_ai_pool_place_loc_priority_range_max = r_val;
	end

end
script static real spops_ai_pool_place_loc_priority_range_max()
	R_spops_ai_pool_place_loc_priority_range_max;
end

// === spops_ai_pool_place_loc_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_pool_place_loc_priority_range_check( real r_priority )
	(
		( R_spops_ai_pool_place_loc_priority_range_min < 0.0 )
		or
		( r_priority >= R_spops_ai_pool_place_loc_priority_range_min )
	)
	and
	(
		( R_spops_ai_pool_place_loc_priority_range_max < 0.0 )
		or
		( r_priority <= R_spops_ai_pool_place_loc_priority_range_max )
	);
end




// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe::: Places AI based on priority and POPULATIONs
// XXX document params
// XXX support spops_ai_place_safe_queue_ticket_enabled
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance_conditional, real r_distance_force, real r_safe_angle )
static short s_active_cnt = 0;
static real r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local object obj_spawned = DEF_SPOPS_AI_GLOBAL_AI_NONE;
local ai ai_spawned = DEF_SPOPS_AI_GLOBAL_AI_NONE;
	
	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	// wait for the all group to be != DEF_SPOPS_AI_GLOBAL_AI_NONE
	if ( ai_ff_all == DEF_SPOPS_AI_GLOBAL_AI_NONE ) then
		sleep_until( ai_ff_all != DEF_SPOPS_AI_GLOBAL_AI_NONE, 1 );
	end

	//dprint( "spops_ai_place_safe: START" );
	s_active_cnt = s_active_cnt + 1;
	//inspect( s_active_cnt );

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
					( spops_player_living_cnt() <= 0 )
					or
					(
						(
							( r_distance_force != 0.0 )
							and
							( objects_distance_to_flag(Players(), flg_spawn_loc) >= abs_r(r_distance_force) == (r_distance_force >= 0.0) )
						)
						or
						(
							( r_distance_conditional != 0.0 )
							and
							(
								( objects_distance_to_flag(Players(), flg_spawn_loc) >= abs_r(r_distance_conditional) == (r_distance_conditional >= 0.0) )
								and
								(
									( r_safe_angle == 0.0 )
									or
									( objects_can_see_flag(Players(), flg_spawn_loc, abs_r(r_safe_angle)) != (r_safe_angle >= 0.0) )
								)
							)
						)
						or
						(
							( r_distance_conditional == 0.0 )
							and
							( r_distance_force == 0.0 )
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
				if ( f_chance(r_chance) and ((spops_ai_population() + s_spawn_cost) <= S_spops_ai_population_limit) ) then
		
					ai_spawned = sys_spops_ai_place_pre( ai_spawn, r_scale_target, r_scale_time );
					//obj_spawned = ai_get_object( ai_spawned );

					//if ( r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE ) then
						//dprint( "spops_ai_place_safe: DISTANCE" );
						//inspect( r_priority_temp );
					//else
						//dprint( "spops_ai_place_safe: PRIORITY" );
						//inspect( r_priority );
					//end

					sys_spops_ai_place_post_loc( ai_spawned, flg_spawn_loc, not b_limbo, NONE, r_scale_target, r_scale_time );

					// decerement spawn cnt
					s_spawn_cnt = s_spawn_cnt - 1;
		
				end

				// reset current priority
				spops_ai_place_safe_priority_current_reset();
				r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
			end

		end
	
	until( (s_spawn_cnt == 0) or (not isthreadvalid(l_thread)), 1 );
	//dprint( "spops_ai_place_safe: EXIT" );
	
	// decrement active cnt
	s_active_cnt = s_active_cnt - 1;
	//inspect( s_active_cnt );

	// returns the last spawned dude
	object_get_ai( obj_spawned );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance_conditional, real r_distance_force )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, r_distance_conditional, r_distance_force, spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo, real r_distance )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, r_distance, r_distance, spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time, boolean b_limbo )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, b_limbo, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance, real r_scale_target, real r_scale_time )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, r_scale_target, r_scale_time, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit, real r_chance )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, r_chance, 1.0, 0.0, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost, short s_squad_limit )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, s_squad_limit, 100.0, 1.0, 0.0, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt, short s_spawn_cost )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, s_spawn_cost, -1, 100.0, 1.0, 0.0, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority, short s_spawn_cnt )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, s_spawn_cnt, 1, -1, 100.0, 1.0, 0.0, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end
script static ai spops_ai_place_safe( long l_thread, ai ai_spawn, cutscene_flag flg_spawn_loc, real r_priority )
	spops_ai_place_safe( l_thread, ai_spawn, flg_spawn_loc, r_priority, 1, 1, -1, 100.0, 1.0, 0.0, FALSE, spops_ai_place_distance_conditional_default(), spops_ai_place_distance_force_default(), spops_ai_place_angle_default() );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_place_safe_population_limit = 						20;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_place_safe_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_place_safe_population_limit ) then
		//dprint( "spops_ai_place_safe_population_limit:" );
		//inspect( s_limit );
		S_spops_ai_place_safe_population_limit = s_limit;
		//if ( s_limit > 20 ) then
		//	//dprint( "spops_ai_place_safe_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		//end
	end

end
script static short spops_ai_place_safe_population_limit()
	S_spops_ai_place_safe_population_limit;
end

// === spops_ai_place_safe_population_limit_check::: XXX
script static boolean spops_ai_place_safe_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= S_spops_ai_place_safe_population_limit ) and spops_ai_population_limit_check( s_cnt );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: PLACE: SAFE: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_place_safe_priority_current = 				DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_place_safe_priority_current::: Gets the safe priority the system is using
script static real spops_ai_place_safe_priority_current()
	R_spops_ai_place_safe_priority_current;
end

// === spops_ai_place_safe_priority_current_reset::: Reset the safe priority default
script static void spops_ai_place_safe_priority_current_reset()

	if ( R_spops_ai_place_safe_priority_current != DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET ) then
	
		//dprint( "spops_ai_place_safe_priority_current_reset" );
		R_spops_ai_place_safe_priority_current = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
		
	end
	
end

// === spops_ai_place_safe_priority_current_reset::: Checks if the current priority needs to reset
script static void spops_ai_place_safe_priority_current_reset_check()
	
	if ( not spops_ai_place_safe_priority_range_check(spops_ai_place_safe_priority_current()) ) then
	
		//dprint( "spops_ai_place_safe_priority_current_reset_check" );
		spops_ai_place_safe_priority_current_reset();
		
	end
	
end

// === spops_ai_place_safe_priority_current_reset::: Checks if the
script static real spops_ai_place_safe_priority( real r_priority, cutscene_flag flg_spawn_loc )
	if ( (r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE) and (spops_player_living_cnt() > 0) ) then
		r_priority = objects_distance_to_flag( Players(), flg_spawn_loc );
	end
	
	// return
	r_priority;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_place_safe_priority_current( real r_priority )

	if ( (r_priority != R_spops_ai_place_safe_priority_current) and spops_ai_place_safe_priority_range_check(r_priority) ) then
		
		//dprint( "sys_spops_ai_place_safe_priority_current:" );
		//inspect( r_priority );
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

		if ( (r_priority < 0.0) or (r_priority <= R_spops_ai_place_safe_priority_range_max) ) then

			//dprint( "spops_ai_place_safe_priority_range_min:" );
			//inspect( r_priority );
			R_spops_ai_place_safe_priority_range_min = r_priority;
			
			// check reset current based on range update
			spops_ai_place_safe_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_place_safe_priority_range_min( R_spops_ai_place_safe_priority_range_max );
			spops_ai_place_safe_priority_range_max( r_priority_temp );
			
		end

	end

end
script static real spops_ai_place_safe_priority_range_min()
	R_spops_ai_place_safe_priority_range_min;
end

// === spops_ai_place_safe_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_place_safe_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_place_safe_priority_range_max ) then

		if ( (r_priority < 0.0) or (R_spops_ai_place_safe_priority_range_min <= r_priority) ) then

			//dprint( "spops_ai_place_safe_priority_range_max:" );
			//inspect( r_priority );
			R_spops_ai_place_safe_priority_range_max = r_priority;
	
			// check reset current based on range update
			spops_ai_place_safe_priority_current_reset_check();

		else
		
			local real r_priority_temp = r_priority;
			spops_ai_place_safe_priority_range_max( R_spops_ai_place_safe_priority_range_min );
			spops_ai_place_safe_priority_range_min( r_priority_temp );
			
		end

	end

end
script static real spops_ai_place_safe_priority_range_max()
	R_spops_ai_place_safe_priority_range_max;
end

// === spops_ai_place_safe_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_place_safe_priority_range_check( real r_priority )
	(
		( R_spops_ai_place_safe_priority_range_min < 0.0 )
		or
		( r_priority >= R_spops_ai_place_safe_priority_range_min )
	)
	and
	(
		( R_spops_ai_place_safe_priority_range_max < 0.0 )
		or
		( r_priority <= R_spops_ai_place_safe_priority_range_max )
	);
end
