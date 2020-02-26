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

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global ai DEF_SPOPS_AI_GLOBAL_AI_NONE =  											object_get_ai( NONE );

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
//the variable for tracking blips and a couple other things
global ai ai_ff_all = 																				DEF_SPOPS_AI_GLOBAL_AI_NONE;

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short 		S_spops_ai_population_limit = 						20;
static short 		S_spops_ai_population_extra_cnt = 				0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_population_limit ) then
		//dprint( "spops_ai_population_limit:" );
		//inspect( s_limit );
		S_spops_ai_population_limit = s_limit;
		//if ( s_limit > 20 ) then
		//	//dprint( "spops_ai_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		//end
	end

end
script static short spops_ai_population_limit()
	S_spops_ai_population_limit;
end

// === spops_ai_population_limit_check::: xxx
script static boolean spops_ai_population_limit_check( short s_cnt )
	( (spops_ai_population() + s_cnt) <= S_spops_ai_population_limit );
end

// === spops_ai_population::: Gets the current population (including guys on phantoms, etc.)
// XXX support cnt for guys in phantoms, etc.
script static short spops_ai_population()
	ai_living_count( ai_ff_all ) + S_spops_ai_population_extra_cnt;
end

// === sys_spops_ai_population_extra_cnt::: Gets the population extra cnt
// XXX document params
script static short spops_ai_population_extra_cnt()
	S_spops_ai_population_extra_cnt;
end

// === sys_spops_ai_population_extra_cnt::: Increments the population extra cnt
// XXX document params
script static void spops_ai_population_extra_cnt_inc( short s_cnt )
	sys_spops_ai_population_extra_cnt( S_spops_ai_population_extra_cnt + s_cnt );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_population_extra_cnt( short s_cnt )

	if ( S_spops_ai_population_extra_cnt != s_cnt ) then
		//dprint( "sys_spops_ai_population_extra_cnt:" );
		S_spops_ai_population_extra_cnt = s_cnt;
		//inspect( S_spops_ai_population_extra_cnt );
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MOP UP ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_spops_ai_mop_up_cnt =														5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_mop_up_cnt::: Sets/Gets the mop up cnt
// XXX document params
script static void spops_ai_mop_up_cnt( short s_val )

	if ( s_val != S_spops_ai_mop_up_cnt ) then
		//dprint( "spops_ai_mop_up_cnt:" );
		//inspect( s_val );
		S_spops_ai_mop_up_cnt = s_val;
	end

end
script static short spops_ai_mop_up_cnt()
	S_spops_ai_mop_up_cnt;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MISC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === players_in_object_range::: XXX
script static short players_in_object_range( object obj_object, real r_range, boolean b_range_in )
local short s_cnt = 0;

	if ( obj_object != NONE ) then

		if ( (unit_get_health(player0) > 0) and ((objects_distance_to_object(obj_object,player0) <= r_range) == b_range_in) ) then
			s_cnt = s_cnt + 1;
		end
		if ( (unit_get_health(player1) > 0) and ((objects_distance_to_object(obj_object,player1) <= r_range) == b_range_in) ) then
			s_cnt = s_cnt + 1;
		end
		if ( (unit_get_health(player2) > 0) and ((objects_distance_to_object(obj_object,player2) <= r_range) == b_range_in) ) then
			s_cnt = s_cnt + 1;
		end
		if ( (unit_get_health(player3) > 0) and ((objects_distance_to_object(obj_object,player3) <= r_range) == b_range_in) ) then
			s_cnt = s_cnt + 1;
		end

	end

	s_cnt;
end
script static short players_in_object_range( object obj_object, real r_range )
	players_in_object_range( obj_object, r_range, TRUE );
end

// === players_in_object_list_range::: XXX
script static short players_in_object_list_range( object_list ol_list, real r_range, boolean b_range_in )
local short s_cnt = 0;

	if ( list_count(ol_list) > 0 ) then

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

	end

	s_cnt;
end
script static short players_in_object_list_range( object_list ol_list, real r_range )
	players_in_object_list_range( ol_list, r_range, TRUE );
end

// === ai_get_squad_safe::: Safely returns a valid squad from an ai
script static ai ai_get_squad_safe( ai ai_squad )
	if ( ai_living_count(ai_get_squad(ai_squad)) > 0 ) then
		ai_squad = ai_get_squad( ai_squad );
	end

	// return
	ai_squad;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: VEHICLE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_get_vehicle::: Will try every type of function for getting a vehicle
// XXX document params
script static vehicle spops_ai_get_vehicle( ai ai_any )
	local vehicle vh_return = NONE;
	
	if ( vh_return == NONE ) then
		vh_return = unit_get_vehicle( ai_any );
	end
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get( ai_any );
	end
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get_from_spawn_point( ai_any );
	end
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get_from_squad( ai_any, 0 );
	end
	
	// return
	vh_return;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: JACKAL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_jackal_shield_hide::: Hides/unhides a jackal shield
// XXX document params
script static void spops_ai_jackal_shield_hide( object obj_jackal, boolean b_hide )
	if ( b_hide ) then
		//dprint( "spops_ai_jackal_shield_hide: TRUE" );
		object_set_shield_stun( obj_jackal, 1000.0 );
		object_set_shield( obj_jackal, 0.0 );
	end
	if ( not b_hide ) then
		//dprint( "spops_ai_jackal_shield_hide: FALSE" );
		object_set_shield( obj_jackal, 1.0 );
		object_set_shield_stun( obj_jackal, 0.0 );
	end
end
script static void spops_ai_jackal_shield_hide( object obj_jackal )
	spops_ai_jackal_shield_hide( obj_jackal, TRUE );
end

script static void spops_ai_jackal_shield_unhide( object obj_jackal )
	spops_ai_jackal_shield_hide( obj_jackal, FALSE );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: GARBAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_SPOPS_AI_GARBAGE_TYPE_ERASE =												00;
global short DEF_SPOPS_AI_GARBAGE_TYPE_KILL =													01;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_garbage_distance_conditional_default = 				17.5;
static real R_spops_ai_garbage_distance_force_default = 							40.0;
static real R_spops_ai_garbage_see_degrees_player_default = 					90.0;
static real R_spops_ai_garbage_see_degrees_ai_default = 							0.0;
static short S_spops_ai_garbage_combat_status_min_default = 					ai_combat_status_asleep;
static short S_spops_ai_garbage_combat_status_max_default = 					ai_combat_status_uninspected;
static short S_spops_ai_garbage_delay_squad_default = 								1;
static short S_spops_ai_garbage_delay_unit_default = 									1;

// debug
static string STR_spops_ai_garbage_debug_blip = 											"";

// === spops_ai_garbage: "Cleans up" AI based on parameters provided and stops once there is no longer any living AI in the squad
// XXX UPDATE PARAM DESCRIPTIONS
//			ai_squad = Squad to cleanup
//			s_type = Type of action to perform on the AI
//				NOTE: SEE TYPE DEFINITIONS ABOVE
//			[optional] r_distance_conditional = Minimum distance the AI must be from a player
//				DEFAULT = XXX
//				[ < 0; Default tuned distance ]
//			[optional] r_see_degrees = Number of degrees from player LOS to make sure the AI is not within 
//				DEFAULT = XXX
//				[ < 0; Default tuned degrees ]
//			[optional] l_delay_squad = Delay (ticks) between looping back on the squad again
//				DEFAULT = XXX
//				[ < 0; Default delay between squad loops ]
//			[optional] l_delay_unit = Delay (ticks) between each unit
//				DEFAULT = XXX
//				[ < 0; Default delay between unit loops ]
//			[optional] b_garbage_squad = TRUE; will automatically garbage collect after each squad loop
//				DEFAULT = FALSE
//	RETURNS:  long; thread id of the cleanup event
script static long spops_ai_garbage( ai ai_squad, short s_type, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad, boolean b_garbage_squad )
	thread( sys_spops_ai_garbage(ai_squad, s_type, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad, b_garbage_squad) );
end

script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad, boolean b_garbage_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad, b_garbage_squad );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad, FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, r_player_see_degrees, spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional, real r_distance_force )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, r_distance_force, spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad, real r_distance_conditional )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, r_distance_conditional, spops_ai_garbage_distance_force_default(), spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_erase( ai ai_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, spops_ai_garbage_distance_conditional_default(), spops_ai_garbage_distance_force_default(), spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end

script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad, boolean b_garbage_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad, b_garbage_squad );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad, FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force, real r_player_see_degrees )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, r_player_see_degrees, spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional, real r_distance_force )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, r_distance_force, spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad, real r_distance_conditional )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, r_distance_conditional, spops_ai_garbage_distance_force_default(), spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end
script static long spops_ai_garbage_kill( ai ai_squad )
	spops_ai_garbage( ai_squad, DEF_SPOPS_AI_GARBAGE_TYPE_KILL, spops_ai_garbage_distance_conditional_default(), spops_ai_garbage_distance_force_default(), spops_ai_garbage_see_degrees_player_default(), spops_ai_garbage_see_degrees_ai_default(), spops_ai_garbage_combat_status_min_default(), spops_ai_garbage_combat_status_max_default(), spops_ai_garbage_delay_unit_default(), spops_ai_garbage_delay_squad_default(), FALSE );
end

// === sys_spops_ai_garbage: Manages spops_ai_garbage
//			NOTE: DO NOT USE!!!
script static void sys_spops_ai_garbage( ai ai_squad, short s_type, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad, boolean b_garbage_squad )

	repeat

		if ( ai_living_count(ai_squad) > 0 ) then
			sys_spops_ai_garbage_objlist( ai_actors(ai_squad), s_type, r_distance_conditional, r_distance_force, r_player_see_degrees, r_ai_see_degrees, s_combat_status_min, s_combat_status_max, l_delay_unit, l_delay_squad );
		end
		
		if ( b_garbage_squad ) then
			garbage_collect_now();
		end
		
	until( ai_living_count(ai_squad) <= 0, l_delay_squad );

end
 
// === sys_spops_ai_garbage_objlist: Manages list of actors from sys_spops_ai_garbage
//			NOTE: DO NOT USE!!!
script static void sys_spops_ai_garbage_objlist( object_list ol_list, short s_type, real r_distance_conditional, real r_distance_force, real r_player_see_degrees, real r_ai_see_degrees, short s_combat_status_min, short s_combat_status_max, long l_delay_unit, long l_delay_squad )
local short s_index = list_count( ol_list );
local object obj_object = NONE;
local boolean b_force_distance_check = ( r_distance_force > 0.0 );
local boolean b_conditional_distance_check = ( r_distance_conditional > 0.0 );
local boolean b_conditional_player_see_check = ( r_player_see_degrees > 0.0 );
local boolean b_conditional_ai_see_check = ( r_ai_see_degrees > 0.0 );

	// absolute values
	r_distance_force = abs_r( r_distance_force );
	r_distance_conditional = abs_r( r_distance_conditional );
	r_player_see_degrees = abs_r( r_player_see_degrees );
	r_ai_see_degrees = abs_r( r_ai_see_degrees );

	// loop through all the units in the squad
	repeat
		s_index = s_index - 1;
		obj_object = list_get( ol_list, s_index );
		
		if ( (STR_spops_ai_garbage_debug_blip != "") and editor_mode() ) then
			spops_blip_object( obj_object, TRUE, STR_spops_ai_garbage_debug_blip );
		end
		
		// check to make sure the object meets the criteria
		if (
			( obj_object != NONE )
			and
			(
				( 
					( r_distance_force != 0.0 )
					and
					( (objects_distance_to_object(Players(), obj_object) >= r_distance_force) == b_force_distance_check )
				)
				or
				(
					(
						( s_combat_status_min < 0 )
						or
						( ai_combat_status(object_get_ai(obj_object)) >= s_combat_status_min )
					)
					and
					(
						( s_combat_status_max < 0 )
						or
						( ai_combat_status(object_get_ai(obj_object)) <= s_combat_status_max )
					)
					and
					(
						( r_distance_conditional == 0.0 )
						or
						( (objects_distance_to_object(Players(), obj_object) >= r_distance_conditional) == b_conditional_distance_check )
					)
					and
					(
						( r_player_see_degrees == 0.0 )
						or
						( objects_can_see_object(Players(), obj_object, r_player_see_degrees) == b_conditional_player_see_check )
					)
					and
					(
						( r_ai_see_degrees == 0.0 )
						or
						( objects_can_see_object(Players(), obj_object, r_ai_see_degrees) == b_conditional_ai_see_check )
					)
				)
			)
		) then
		
			// apply unit garbage type
			if ( s_type == DEF_SPOPS_AI_GARBAGE_TYPE_ERASE ) then
				//dprint( "sys_spops_ai_garbage_objlist: ERASE" );
				ai_erase( object_get_ai(obj_object) );
			elseif ( s_type == DEF_SPOPS_AI_GARBAGE_TYPE_KILL ) then
				//dprint( "sys_spops_ai_garbage_objlist: KILLED" );
				ai_kill_no_statistics( object_get_ai(obj_object) );
			else
				breakpoint( "sys_spops_ai_garbage_objlist: TYPE UNKNOWN" );
				//inspect( s_type );
				sleep( 1 );
			end
			
		end

		if ( (STR_spops_ai_garbage_debug_blip != "") and editor_mode() ) then
			spops_unblip_object( obj_object );
		end
		
	until( s_index <= 0, l_delay_unit );

end

script static void spops_ai_garbage_distance_conditional_default( real r_val )
	R_spops_ai_garbage_distance_conditional_default = r_val;
end
script static real spops_ai_garbage_distance_conditional_default()
	R_spops_ai_garbage_distance_conditional_default;
end

script static void spops_ai_garbage_distance_force_default( real r_val )
	R_spops_ai_garbage_distance_force_default = r_val;
end
script static real spops_ai_garbage_distance_force_default()
	R_spops_ai_garbage_distance_force_default;
end

script static void spops_ai_garbage_see_degrees_player_default( real r_val )
	R_spops_ai_garbage_see_degrees_player_default = r_val;
end
script static real spops_ai_garbage_see_degrees_player_default()
	R_spops_ai_garbage_see_degrees_player_default;
end

script static void spops_ai_garbage_see_degrees_ai_default( real r_val )
	R_spops_ai_garbage_see_degrees_ai_default = r_val;
end
script static real spops_ai_garbage_see_degrees_ai_default()
	R_spops_ai_garbage_see_degrees_ai_default;
end

script static void spops_ai_garbage_combat_status_min_default( short s_val )
	S_spops_ai_garbage_combat_status_min_default = s_val;
end
script static short spops_ai_garbage_combat_status_min_default()
	S_spops_ai_garbage_combat_status_min_default;
end

script static void spops_ai_garbage_combat_status_max_default( short s_val )
	S_spops_ai_garbage_combat_status_max_default = s_val;
end
script static short spops_ai_garbage_combat_status_max_default()
	S_spops_ai_garbage_combat_status_max_default;
end

script static void spops_ai_garbage_delay_unit_default( short s_val )
	S_spops_ai_garbage_delay_unit_default = s_val;
end
script static short spops_ai_garbage_delay_unit_default()
	S_spops_ai_garbage_delay_unit_default;
end

script static void spops_ai_garbage_delay_squad_default( short s_val )
	S_spops_ai_garbage_delay_squad_default = s_val;
end
script static short spops_ai_garbage_delay_squad_default()
	S_spops_ai_garbage_delay_squad_default;
end

script static void spops_ai_garbage_debug_blip( string str_blip )
	STR_spops_ai_garbage_debug_blip = str_blip;
end
script static string spops_ai_garbage_debug_blip()
	STR_spops_ai_garbage_debug_blip;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: ACTIVE CAMO MANAGER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global long DEF_VAR_INDEX_L_ACTIVE_CAMO = 																						1;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_spops_ai_active_camo_manager_activate_status_min_default = 						ai_combat_status_active;
static short S_spops_ai_active_camo_manager_activate_status_max_default = 						ai_combat_status_dangerous;
static real R_spops_ai_active_camo_manager_activate_distance_conditional_default = 		5.0;
static real R_spops_ai_active_camo_manager_activate_distance_force_default = 					10.0;
static real R_spops_ai_active_camo_manager_activate_see_angle_default = 							25.0;
static real R_spops_ai_active_camo_manager_deactivate_distance_default = 							3.00;
static real R_spops_ai_active_camo_manager_deactivate_damage_recent_default = 				0.125;
static real R_spops_ai_active_camo_manager_reset_time_min_default = 									5.0;
static real R_spops_ai_active_camo_manager_reset_time_max_default = 									10.0;

static boolean B_spops_ai_active_camo_manager_editor_debug = 													TRUE;

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
//			r_activate_distance_conditional [real; default] = Minimum distance for AI to activate active camo
//				NOTE: This requires the r_activate_see_angle check to pass
//			r_activate_distance_force [real; default/r_activate_distance_conditional] = Maximum distance for AI to automatically activate active camo
//				NOTE: This must be > r_activate_distance_conditional for it to work
//			r_activate_see_angle [real; default] = See angle check for players that disables active camo activation for r_activate_distance_conditional
//			od_activate_readied_required [object_definition; NONE] = Weapon definition to check if readied before activating active camo
//				NOTE: NONE will ignore this check
//			r_deactivate_distance [real; default] = Distance from nearest player that will automatically decloak the AI
//				NOTE: Setting this to 0.0 will disable this check
//			r_deactivate_damage_recent [real; default] = Amount of recent shield+health damage that must happen to automatically decloak the AI
//				NOTE: Setting this to 0.0 will disable this check
//			r_reset_time_min [real; default] = Minimum time (seconds) after decloaking that the AI will wait before recloaking
//			r_reset_time_max [real; default/r_reset_time_min] = Maximum time (seconds) after decloaking that the AI will wait before recloaking
//	RETURNS:  [long] the thread id of the (last setup) manager
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time_min, real r_reset_time_max )
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
		if ( r_activate_distance_conditional < 0.0 ) then
			r_activate_distance_conditional = spops_ai_active_camo_manager_activate_distance_conditional_default();
		end
		if ( r_activate_distance_force < 0.0 ) then
			r_activate_distance_force = spops_ai_active_camo_manager_activate_distance_force_default();
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

			l_return = thread( sys_spops_ai_active_camo_manager(object_get_ai(list_get(ol_actors,s_index)), b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, r_reset_time_min, r_reset_time_max) );
			s_index = s_index - 1;

		until ( s_index < 0, 1 );

	end

	// return
	l_return;

end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, r_reset_time, r_reset_time );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, r_deactivate_damage_recent, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, od_activate_readied_required, r_deactivate_distance, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, od_activate_readied_required, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, r_activate_see_angle, NONE, -1.0, -1.0, -1.0, -1.0 );
end
script static long spops_ai_active_camo_manager( ai ai_squad, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force )
	spops_ai_active_camo_manager( ai_squad, b_equipment_required, l_thread_valid, str_notify_use, s_activate_status_min, s_activate_status_max, r_activate_distance_conditional, r_activate_distance_force, -1.0, NONE, -1.0, -1.0, -1.0, -1.0 );
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
		//dprint( "spops_ai_active_camo_manager_activate_status_min_default: SET" );
		//inspect( r_val );
		S_spops_ai_active_camo_manager_activate_status_min_default = r_val;
	end
end
script static short spops_ai_active_camo_manager_activate_status_min_default()
	S_spops_ai_active_camo_manager_activate_status_min_default;
end

// === spops_ai_active_camo_manager_activate_status_max_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_status_max_default( real r_val )
	if ( S_spops_ai_active_camo_manager_activate_status_max_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_activate_status_max_default: SET" );
		//inspect( r_val );
		S_spops_ai_active_camo_manager_activate_status_max_default = r_val;
	end
end
script static short spops_ai_active_camo_manager_activate_status_max_default()
	S_spops_ai_active_camo_manager_activate_status_max_default;
end

// === spops_ai_active_camo_manager_activate_distance_conditional_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_distance_conditional_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_distance_conditional_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_activate_distance_conditional_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_activate_distance_conditional_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_distance_conditional_default()
	R_spops_ai_active_camo_manager_activate_distance_conditional_default;
end

// === spops_ai_active_camo_manager_activate_distance_force_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_distance_force_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_distance_force_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_activate_distance_force_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_activate_distance_force_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_distance_force_default()
	R_spops_ai_active_camo_manager_activate_distance_force_default;
end

// === spops_ai_active_camo_manager_activate_see_angle_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_activate_see_angle_default( real r_val )
	if ( R_spops_ai_active_camo_manager_activate_see_angle_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_activate_see_angle_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_activate_see_angle_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_activate_see_angle_default()
	R_spops_ai_active_camo_manager_activate_see_angle_default;
end

// === spops_ai_active_camo_manager_deactivate_distance_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_deactivate_distance_default( real r_val )
	if ( R_spops_ai_active_camo_manager_deactivate_distance_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_deactivate_distance_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_deactivate_distance_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_deactivate_distance_default()
	R_spops_ai_active_camo_manager_deactivate_distance_default;
end

// === spops_ai_active_camo_manager_deactivate_damage_recent_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_deactivate_damage_recent_default( real r_val )
	if ( R_spops_ai_active_camo_manager_deactivate_damage_recent_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_deactivate_damage_recent_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_deactivate_damage_recent_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_deactivate_damage_recent_default()
	R_spops_ai_active_camo_manager_deactivate_damage_recent_default;
end

// === spops_ai_active_camo_manager_reset_time_min_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_reset_time_min_default( real r_val )
	if ( R_spops_ai_active_camo_manager_reset_time_min_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_reset_time_min_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_reset_time_min_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_reset_time_min_default()
	R_spops_ai_active_camo_manager_reset_time_min_default;
end

// === spops_ai_active_camo_manager_reset_time_max_default::: Get/set active camo manager default
script static void spops_ai_active_camo_manager_reset_time_max_default( real r_val )
	if ( R_spops_ai_active_camo_manager_reset_time_max_default != r_val ) then
		//dprint( "spops_ai_active_camo_manager_reset_time_max_default: SET" );
		//inspect( r_val );
		R_spops_ai_active_camo_manager_reset_time_max_default = r_val;
	end
end
script static real spops_ai_active_camo_manager_reset_time_max_default()
	R_spops_ai_active_camo_manager_reset_time_max_default;
end

// === spops_ai_active_camo_manager_editor_debug::: Get/set active camo manager editor debug
script static void spops_ai_active_camo_manager_editor_debug( boolean b_val )
	if ( B_spops_ai_active_camo_manager_editor_debug != b_val ) then
		//dprint( "spops_ai_active_camo_manager_editor_debug: SET" );
		//inspect( b_val );
		B_spops_ai_active_camo_manager_editor_debug = b_val;
	end
end
script static boolean spops_ai_active_camo_manager_editor_debug()
	B_spops_ai_active_camo_manager_editor_debug and editor_mode();
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_active_camo_manager( ai ai_actor, boolean b_equipment_required, long l_thread_valid, string str_notify_use, short s_activate_status_min, short s_activate_status_max, real r_activate_distance_conditional, real r_activate_distance_force, real r_activate_see_angle, object_definition od_activate_readied_required, real r_deactivate_distance, real r_deactivate_damage_recent, real r_reset_time_min, real r_reset_time_max )
	
	if ( (not b_equipment_required) or unit_has_equipment(ai_actor, 'objects\equipment\storm_active_camo\storm_active_camo.equipment') and ((l_thread_valid == 0) or isthreadvalid(l_thread_valid)) ) then
		local long l_timer = 0;
		local object obj_actor = ai_get_object( ai_actor );
		//dprint( "sys_spops_ai_active_camo_manager: SETUP" ); 

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
						( spops_player_living_cnt() <= 0 )
						or
						(
							(
								( r_activate_distance_force != 0.0 )
								and
								( objects_distance_to_object(Players(), obj_actor) >= abs_r(r_activate_distance_force) == (r_activate_distance_force >= 0.0) )
							)
							or
							(
								( r_activate_distance_conditional != 0.0 )
								and
								(
									( objects_distance_to_object(Players(), obj_actor) >= abs_r(r_activate_distance_conditional) == (r_activate_distance_conditional >= 0.0) )
									and
									(
										( r_activate_see_angle == 0.0 )
										or
										( objects_can_see_object(Players(), obj_actor, abs_r(r_activate_see_angle)) != (r_activate_see_angle >= 0.0) )
									)
								)
							)
							or
							(
								( r_activate_distance_conditional == 0.0 )
								and
								( r_activate_distance_force == 0.0 )
							)
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
				sys_spops_object_active_camo_inc( obj_actor, 1 );
				//dprint( "sys_spops_ai_active_camo_manager: ACTIVE" ); 
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
				sys_spops_object_active_camo_inc( obj_actor, -1 );
				//dprint( "sys_spops_ai_active_camo_manager: DISABLED" );
				if ( range_check(ai_combat_status(ai_actor), s_activate_status_min, s_activate_status_max) ) then
					l_timer = timer_stamp( r_reset_time_min, r_reset_time_max );
				end
			end

		until ( (unit_get_health(ai_actor) <= 0.0) or ((l_thread_valid != 0) and (not isthreadvalid(l_thread_valid))), 1 );

		//dprint( "sys_spops_ai_active_camo_manager: SHUTDOWN" ); 
	end

end

script static void sys_spops_object_active_camo_inc( object obj_object, long l_inc )
	sys_spops_object_active_camo( obj_object, sys_spops_object_active_camo(obj_object) + l_inc );
end
script static void sys_spops_object_active_camo( object obj_object, long l_val )

	if ( l_val != sys_spops_object_active_camo(obj_object) ) then

		dprint( "sys_spops_object_active_camo" ); 
		//inspect( l_val );
		
		// activate
		if ( l_val == 1 ) then
			dprint( "sys_spops_object_active_camo: ACTIVATE" ); 
			//unit_set_active_camo( unit(obj_object), TRUE, 0.5 );
			ai_set_active_camo( object_get_ai(obj_object), TRUE );
			if ( spops_ai_active_camo_manager_editor_debug() ) then
				navpoint_track_object_named( obj_object, 'navpoint_activecamo' );
			end
		end
		// deactivate
		if ( l_val == 0 ) then
			dprint( "sys_spops_object_active_camo: DEACTIVATE" ); 
			//unit_set_active_camo( unit(obj_object), FALSE, 0.5 );
			ai_set_active_camo( object_get_ai(obj_object), FALSE );
			if ( spops_ai_active_camo_manager_editor_debug() ) then
				navpoint_track_object( obj_object, FALSE );
			end
		end
		//repair
		if ( l_val <= 0 ) then
			dprint( "sys_spops_object_active_camo: REPAIR" ); 
			
		end
	
		// set the variable	
		SetObjectLongVariable( obj_object, DEF_VAR_INDEX_L_ACTIVE_CAMO, l_val );

	end
	
end
script static long sys_spops_object_active_camo( object obj_object )
	GetObjectLongVariable( obj_object, DEF_VAR_INDEX_L_ACTIVE_CAMO );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: MORALE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_SPOPS_AI_MORALE_ALLY = 			1;
global short DEF_SPOPS_AI_MORALE_TIED = 			0;
global short DEF_SPOPS_AI_MORALE_ENEMY = 			-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_morale_weight::: Compares weighted morale values of two sets of AI
// XXX document params
script static real spops_ai_morale_weight( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player, real r_weight_ally, real r_weight_enemy, real r_weight_ally_leader, real r_weight_enemy_leader )
	spops_ai_morale_weight_ally( ai_ally, r_weight_ally, r_weight_ally_leader, r_distance_ally_player, r_weight_ally_player ) - spops_ai_morale_weight_enemy( ai_enemy, r_weight_enemy, r_weight_enemy_leader, r_distance_enemy_player, r_weight_enemy_player );
end
script static real spops_ai_morale_weight( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player, real r_weight_ally, real r_weight_enemy )
	spops_ai_morale_weight( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, r_weight_ally_player, r_weight_enemy_player, r_weight_ally, r_weight_enemy, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player )
	spops_ai_morale_weight( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, r_weight_ally_player, r_weight_enemy_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player )
	spops_ai_morale_weight( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end
script static real spops_ai_morale_weight( ai ai_ally, ai ai_enemy )
	spops_ai_morale_weight( ai_ally, ai_enemy, -1.0, -1.0, DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE(), DEF_SPOPS_AI_MORALE_DEFAULT_USE() );
end

// === spops_ai_morale::: Compares weighted morale values of two sets of AI
// XXX document params
script static short spops_ai_morale( ai ai_ally, ai ai_enemy, real r_distance_ally_player, real r_distance_enemy_player, real r_weight_ally_player, real r_weight_enemy_player, real r_weight_ally, real r_weight_enemy, real r_weight_ally_leader, real r_weight_enemy_leader )
local real r_weight = spops_ai_morale_weight( ai_ally, ai_enemy, r_distance_ally_player, r_distance_enemy_player, r_weight_ally_player, r_weight_enemy_player, r_weight_ally, r_weight_enemy, r_weight_ally_leader, r_weight_enemy_leader );

	// return
	if ( r_weight > 0.0 ) then
		DEF_SPOPS_AI_MORALE_ALLY;
	elseif ( r_weight < 0.0 ) then
		DEF_SPOPS_AI_MORALE_ENEMY;
	else
		DEF_SPOPS_AI_MORALE_TIED;
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
local real r_weight = ( ai_task_count(ai_morale) + ai_living_count(ai_morale) ) * r_weight_base;

	if ( ai_leadership_all(ai_morale) ) then
		r_weight = r_weight + r_weight_leader;
	end

	if ( ((ai_task_count(ai_morale) + ai_living_count(ai_morale)) > 0) and (r_distance_player > 0.0) and (r_weight_player != 0.0) and (spops_player_living_cnt() > 0) ) then
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
		
		//dprint( "spops_ai_morale_ally_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_enemy_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_ally_leader_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_enemy_leader_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_ally_player_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_enemy_player_weight_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_ally_player_distance_default:" );
		//inspect( r_priority );
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

		//dprint( "spops_ai_morale_enemy_player_distance_default:" );
		//inspect( r_priority );
		R_spops_ai_morale_enemy_player_distance_default = r_priority;

	end

end
script static real spops_ai_morale_enemy_player_distance_default()
	R_spops_ai_morale_enemy_player_distance_default;
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
local real r_weight_place = 10.0;
local real r_chance = 100.0;
local short s_spawn_cnt = 5;
local short s_squad_limit = 5;

	kill_thread( test_thread );
	test_thread = GetCurrentThreadId();
	//dprint( "test_ai_pool" );
	ai_ff_all = gr_e8_m2_all;
	thread( spops_ai_pool(test_thread, test_unit_01, r_priority, r_pool_index, s_spawn_cnt, 1, s_squad_limit, 2.0, r_chance, r_timeout) );
	thread( spops_ai_pool(test_thread, test_unit_02, r_priority, r_pool_index, s_spawn_cnt, 1, s_squad_limit, 1.0, r_chance, r_timeout) );
	thread( spops_ai_pool_place_loc(test_thread, flg_test_01, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 50.0) );
	thread( spops_ai_pool_place_loc(test_thread, flg_test_02, r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 50.0) );
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
static real R_spops_ai_elite_sword_and_gun_sword_distance_conditional_default = 			3.50;
static real R_spops_ai_elite_sword_and_gun_sword_shield_min_default = 				0.50;
static real R_spops_ai_elite_sword_and_gun_face_distance_conditional_default = 				2.25;
static real R_spops_ai_elite_sword_and_gun_face_time_min_default = 						0.50;
static real R_spops_ai_elite_sword_and_gun_face_time_max_default = 						0.75;
static real R_spops_ai_elite_sword_and_gun_berzerk_timeout_default = 					2.00;
static real R_spops_ai_elite_sword_and_gun_reset_delay_min_default = 					5.00;
static real R_spops_ai_elite_sword_and_gun_reset_delay_max_default = 					7.50;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout, real r_reset_delay_min, real r_reset_delay_max )
	
	if ( unit_has_weapon(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') ) then
		//dprint( "spops_ai_elite_sword_and_gun" );
		local long l_timer = 0;
		local object obj_elite = ai_get_object( ai_elite );

		// defaults
		if ( r_sword_distance_conditional < 0.0 ) then
			r_sword_distance_conditional = spops_ai_elite_sword_and_gun_sword_distance_conditional_default();
		end
		if ( r_sword_shield_min < 0.0 ) then
			r_sword_shield_min = spops_ai_elite_sword_and_gun_sword_shield_min_default();
		end
		if ( r_face_distance_conditional < 0.0 ) then
			r_face_distance_conditional = spops_ai_elite_sword_and_gun_face_distance_conditional_default();
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
			sleep_until( (unit_get_health(ai_elite) <= 0.0) or ((not unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon')) and timer_expired(l_timer) and ((objects_distance_to_object(Players(),obj_elite) >= r_sword_distance_conditional) or (unit_get_shield(ai_elite) >= r_sword_shield_min))), 1 );

			// Face the player
			if ( (unit_get_health(ai_elite) > 0.0) and (object_get_recent_body_damage(obj_elite) <= 0.0) and (objects_distance_to_object(Players(),obj_elite) >= r_face_distance_conditional) ) then
				//dprint( "spops_ai_elite_sword_and_gun: FACE" );
				cs_face_player( ai_elite, TRUE );
				l_timer = timer_stamp( r_face_time_min, r_face_time_max );
				sleep_until( timer_expired(l_timer) or (object_get_recent_body_damage(obj_elite) > 0.0) or (objects_distance_to_object(Players(),obj_elite) < r_face_distance_conditional), 1 );
				cs_face_player( ai_elite, FALSE );
			end

			// go berzerk!!!
			if ( unit_get_health(ai_elite) > 0.0 ) then
				//dprint( "spops_ai_elite_sword_and_gun: BERZERK" );
				ai_berserk( ai_elite, TRUE );
				l_timer = timer_stamp( r_berzerk_timeout );
				sleep_until( (unit_get_health(ai_elite) <= 0.0) or unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') or timer_expired(l_timer), 1 );
			end

			// wait for need to reset sword
			if ( unit_get_health(ai_elite) > 0.0 ) then
				sleep_until( (unit_get_health(ai_elite) <= 0.0) or (not unit_has_weapon_readied(ai_elite, 'objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon')), 1 );
				//dprint( "spops_ai_elite_sword_and_gun: RESET" );
				l_timer = timer_stamp( r_reset_delay_min, r_reset_delay_max );
			end

		until ( unit_get_health(ai_elite) <= 0.0, 1 );

	end
	
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout, real r_reset_delay )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, r_face_distance_conditional, r_face_time_min, r_face_time_max, r_berzerk_timeout, r_reset_delay, r_reset_delay );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional, real r_face_time_min, real r_face_time_max, real r_berzerk_timeout )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, r_face_distance_conditional, r_face_time_min, r_face_time_max, r_berzerk_timeout, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional, real r_face_time_min, real r_face_time_max )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, r_face_distance_conditional, r_face_time_min, r_face_time_max, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional, real r_face_time )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, r_face_distance_conditional, r_face_time, r_face_time, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min, real r_face_distance_conditional )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, r_face_distance_conditional, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional, real r_sword_shield_min )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, r_sword_shield_min, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start, real r_sword_distance_conditional )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, r_sword_distance_conditional, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite, string str_notify_start )
	spops_ai_elite_sword_and_gun( ai_elite, str_notify_start, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end
script static void spops_ai_elite_sword_and_gun( ai ai_elite )
	spops_ai_elite_sword_and_gun( ai_elite, "", -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0 );
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_sword_distance_conditional_default( real r_val )
	R_spops_ai_elite_sword_and_gun_sword_distance_conditional_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_sword_distance_conditional_default()
	R_spops_ai_elite_sword_and_gun_sword_distance_conditional_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_sword_shield_min_default( real r_val )
	R_spops_ai_elite_sword_and_gun_sword_shield_min_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_sword_shield_min_default()
	R_spops_ai_elite_sword_and_gun_sword_shield_min_default;
end

// === xxx::: xxx
script static void spops_ai_elite_sword_and_gun_face_distance_conditional_default( real r_val )
	R_spops_ai_elite_sword_and_gun_face_distance_conditional_default = r_val;
end
script static real spops_ai_elite_sword_and_gun_face_distance_conditional_default()
	R_spops_ai_elite_sword_and_gun_face_distance_conditional_default;
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









/*
static ai AI_spops_ai_pool_queue_claimed =							DEF_SPOPS_AI_GLOBAL_AI_RESET;
static real R_spops_ai_pool_queue_request_index =					DEF_SPOPS_AI_GLOBAL_INDEX_RESET;
static real R_spops_ai_pool_queue_request_weight =				DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET;
static real S_spops_ai_pool_queue_request_cnt =						0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_queue_request::: Adds an already placed character into the pool queue
// XXX document params
script static boolean spops_ai_pool_queue_request( long l_thread, ai ai_pool, real r_index, real r_weight, real r_timeout )
local boolean b_placed = FALSE;
local long l_timer = timer_stamp( r_timeout );
	//dprint( "spops_ai_pool_queue_request" );
	
	// if timer value isn't valid, timer never expires
	if ( r_timeout < 0.0 ) then
		l_timer = -1;
	end

	// increment count	
	sys_spops_ai_pool_queue_request_cnt_inc( 1 );
	
	repeat
		
		// wait for turn in pool
		sleep_until( (spops_ai_pool_queue_claimed() == DEF_SPOPS_AI_GLOBAL_AI_RESET) or (not isthreadvalid(l_thread)) or timer_expired(l_timer), 1 );

		// give turn in pool
		if ( (spops_ai_pool_queue_claimed() == DEF_SPOPS_AI_GLOBAL_AI_RESET) and isthreadvalid(l_thread) and (not timer_expired(l_timer)) ) then
		
			sys_spops_ai_pool_queue_request( ai_pool, r_index, r_weight );
			sleep( 1 );
			
			// check if the pool ai was placed
			b_placed = ( spops_ai_pool_queue_claimed() != ai_pool );
			
			// make sure the current is reset to give others a turn
			if ( spops_ai_pool_queue_claimed() == ai_pool ) then
				spops_ai_pool_queue_request_reset();
			end
			
		end
	
	until( b_placed or (not isthreadvalid(l_thread)) or timer_expired(l_timer), 1 );

	// increment count	
	sys_spops_ai_pool_queue_request_cnt_inc( -1 );
	
	// return
	b_placed;
end

// === spops_ai_pool_queue_claimed::: xxx
script static ai spops_ai_pool_queue_claimed()
	AI_spops_ai_pool_queue_claimed;
end

// === spops_ai_pool_queue_request_index::: xxx
script static real spops_ai_pool_queue_request_index()
	R_spops_ai_pool_queue_request_index;
end

// === spops_ai_pool_queue_request_weight::: xxx
script static real spops_ai_pool_queue_request_weight()
	R_spops_ai_pool_queue_request_weight;
end

// === spops_ai_pool_queue_request_reset::: Reset the safe priority default
script static void spops_ai_pool_queue_request_reset()

	if ( R_spops_ai_pool_queue_request_index != DEF_SPOPS_AI_GLOBAL_INDEX_RESET ) then
		//dprint( "spops_ai_pool_queue_request_reset" );
		sys_spops_ai_pool_queue_request( DEF_SPOPS_AI_GLOBAL_AI_RESET, DEF_SPOPS_AI_GLOBAL_INDEX_RESET, DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET );
	end
	
end

// === spops_ai_pool_queue_request_cnt::: xxx
script static short spops_ai_pool_queue_request_cnt()
	S_spops_ai_pool_queue_request_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_queue_request( ai ai_current, real r_index, real r_weight )

	if ( AI_spops_ai_pool_queue_claimed != ai_current ) then
		//dprint( "sys_spops_ai_pool_queue_request: AI" );
		AI_spops_ai_pool_queue_claimed = ai_current;
	end
	if ( R_spops_ai_pool_queue_request_index != r_index ) then
		//dprint( "sys_spops_ai_pool_queue_request: INDEX" );
		R_spops_ai_pool_queue_request_index = r_index;
		//inspect( r_index );
	end
	if ( R_spops_ai_pool_queue_request_weight != r_weight ) then
		//dprint( "sys_spops_ai_pool_queue_request: WEIGHT" );
		R_spops_ai_pool_queue_request_weight = r_weight;
		//inspect( r_weight );
	end
	
end

script static void sys_spops_ai_pool_queue_request_cnt( short s_val )
	if ( S_spops_ai_pool_queue_request_cnt != s_val ) then
		//dprint( "sys_spops_ai_pool_queue_request_cnt:" );
		S_spops_ai_pool_queue_request_cnt = s_val;
		//inspect( s_val );
	end
end

script static void sys_spops_ai_pool_queue_request_cnt_inc( short s_val )
	sys_spops_ai_pool_queue_request_cnt( spops_ai_pool_queue_request_cnt() + s_val );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: ACTIVE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static ai AI_spops_ai_pool_active =									DEF_SPOPS_AI_GLOBAL_AI_RESET;
static real R_spops_ai_pool_active_index =					DEF_SPOPS_AI_GLOBAL_INDEX_RESET;
static real R_spops_ai_pool_active_weight =					DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET;

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

	if ( R_spops_ai_pool_active_index != DEF_SPOPS_AI_GLOBAL_INDEX_RESET ) then
		//dprint( "spops_ai_pool_active_reset" );
		sys_spops_ai_pool_active( DEF_SPOPS_AI_GLOBAL_AI_RESET, DEF_SPOPS_AI_GLOBAL_INDEX_RESET, DEF_SPOPS_AI_GLOBAL_WEIGHT_RESET );
	end
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_active( ai ai_current, real r_index, real r_weight )

	if ( AI_spops_ai_pool_active != ai_current ) then
		//dprint( "spops_ai_pool_active_reset: AI" );
		AI_spops_ai_pool_active = ai_current;
	end
	if ( R_spops_ai_pool_active_index != r_index ) then
		//dprint( "spops_ai_pool_active_reset: INDEX" );
		R_spops_ai_pool_active_index = r_index;
	end
	if ( R_spops_ai_pool_active_weight != r_weight ) then
		//dprint( "spops_ai_pool_active_reset: WEIGHT" );
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
		spops_ai_pool_queue_claimed();
	else
		spops_ai_pool_active_ai();
	end
end

// === spops_ai_pool_current_index::: xxx
script static real spops_ai_pool_current_index()
	if ( spops_ai_pool_active_ai() == NONE ) then
		spops_ai_pool_queue_request_index();
	else
		spops_ai_pool_active_index();
	end
end

// === spops_ai_pool_current_weight::: xxx
script static real spops_ai_pool_current_weight()
	if ( spops_ai_pool_active_ai() == NONE ) then
		spops_ai_pool_queue_request_weight();
	else
		spops_ai_pool_active_weight();
	end
end







// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real  		R_spops_ai_pool_place_priority_current = 				DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_priority_current::: Gets the safe priority the system is using
script static real spops_ai_pool_place_priority_current()
	R_spops_ai_pool_place_priority_current;
end

// === spops_ai_pool_place_priority_current_reset::: Reset the safe priority default
script static void spops_ai_pool_place_priority_current_reset()

	if ( R_spops_ai_pool_place_priority_current != DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET ) then
	
		//dprint( "spops_ai_pool_place_priority_current_reset" );
		R_spops_ai_pool_place_priority_current = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
		
	end
	
end

// === spops_ai_pool_place_priority_current_reset::: Checks if the current priority needs to reset
script static void spops_ai_pool_place_priority_current_reset_check()
	
	if ( not spops_ai_pool_place_priority_range_check(spops_ai_pool_place_priority_current()) ) then
	
		//dprint( "spops_ai_pool_place_priority_current_reset_check" );
		spops_ai_pool_place_priority_current_reset();
		
	end
	
end

// === spops_ai_pool_place_priority_current_reset::: Checks if the
script static real spops_ai_pool_place_priority_flag( real r_priority, cutscene_flag flg_place )
	if ( (r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE()) and (spops_player_living_cnt() > 0) ) then
		r_priority = objects_distance_to_flag( Players(), flg_place );
	end
	
	// return
	r_priority;
end

// === spops_ai_pool_place_priority_object::: Checks if the
script static real spops_ai_pool_place_priority_object( real r_priority, object obj_place )
	if ( (r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE()) and (spops_player_living_cnt() > 0) ) then
		r_priority = objects_distance_to_object( Players(), obj_place );
	end
	
	// return
	r_priority;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_place_priority_current( real r_priority )

	if ( (r_priority != R_spops_ai_pool_place_priority_current) and spops_ai_pool_place_priority_range_check(r_priority) ) then
		
		//dprint( "sys_spops_ai_pool_place_priority_current:" );
		//inspect( r_priority );
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

			//dprint( "spops_ai_pool_place_priority_range_min:" );
			//inspect( r_priority );
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
		R_spops_ai_pool_place_priority_range_min;
end

// === spops_ai_pool_place_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_place_priority_range_max( real r_priority )

	if ( r_priority != R_spops_ai_pool_place_priority_range_max ) then

		if ( (r_priority < 0.0) or (spops_ai_pool_place_priority_range_min() <= r_priority) ) then

			//dprint( "spops_ai_pool_place_priority_range_max:" );
			//inspect( r_priority );
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
		spops_ai_global_priority_range_max();
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
*/


/*
static real r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local real r_weight_placed = 0.0;

	
	sys_spops_ai_pool_place_phantom_cnt_inc( 1 );
	//inspect( spops_ai_pool_place_phantom_cnt() );

	// defaults

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
					spops_ai_pool_place_priority_range_check( spops_ai_pool_place_priority_object(r_priority, vh_phantom) )
					and
					(
						( spops_ai_pool_place_priority_object(r_priority, vh_phantom) <= spops_ai_pool_place_priority_current() )
						or
						(
							b_priority_sub_distance
							and
							( spops_ai_pool_place_priority_object(r_priority, vh_phantom) == spops_ai_pool_place_priority_current() )
							and
							( objects_distance_to_object(Players(), vh_phantom) < r_distance_sub )
						)
					)
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) ) then
			//dprint( "spops_ai_pool_place_phantom: VALID" );

			// store priority values
			local real r_priority_temp = spops_ai_pool_place_priority_object( r_priority, vh_phantom );
			local real r_distance_sub_temp = objects_distance_to_object( Players(), vh_phantom );

			// share global priority settings and check if someone else should take over
			if ( (spops_ai_pool_active_ai() == NONE) or (r_priority_temp < spops_ai_pool_place_priority_current()) or f_chance(r_chance) ) then
				//dprint( "spops_ai_pool_place_phantom: GRAB A" );

				sys_spops_ai_pool_place_priority_current( r_priority_temp );
				r_distance_sub = r_distance_sub_temp;

				// grab the AI, he's getting spawned
				if ( spops_ai_pool_active_ai() == NONE ) then
					//dprint( "spops_ai_pool_place_phantom: GRAB: B" );
					sys_spops_ai_pool_active( spops_ai_pool_queue_claimed(), spops_ai_pool_queue_request_index(), spops_ai_pool_queue_request_weight() );
					spops_ai_pool_queue_request_reset();
				end

				// wait a frame to give everyone a chance to take over
				sleep( 1 );
			end

			// check if this is the current priority target
			if ( (r_priority_temp == spops_ai_pool_place_priority_current()) and (r_distance_sub == r_distance_sub_temp) ) then
				//dprint( "spops_ai_pool_place_phantom: PRIORITY TARGET" );

				ai_placed = sys_spops_ai_place_pre( spops_ai_pool_active_ai() );
				
				// increment weight
				if ( r_weight_place >= 0.0 ) then
					//dprint( "spops_ai_pool_place_phantom: WEIGHT" );
					r_weight_placed = r_weight_placed + spops_ai_pool_active_weight();
					//inspect( r_weight_placed );
					//inspect( r_weight_place );
				end
			
				if ( r_priority == DEF_SPOPS_AI_GLOBAL_PRIORITY_DISTANCE() ) then
					//dprint( "spops_ai_pool_place_phantom: DISTANCE" );
					//inspect( r_priority_temp );
				else
					//dprint( "spops_ai_pool_place_phantom: PRIORITY" );
					//inspect( r_priority );
				end

				// reset placing
				spops_ai_pool_place_priority_current_reset();
				spops_ai_pool_active_reset();
				r_distance_sub = DEF_SPOPS_AI_GLOBAL_PRIORITY_RESET;

			end

		end

	until( ((r_weight_place >= 0.0) and (r_weight_placed >= r_weight_place)) or (not isthreadvalid(l_thread)), 1 );
	//dprint( "spops_ai_pool_place_phantom: EXIT" );
	
	// decrement active cnt
	sys_spops_ai_pool_place_phantom_cnt_inc( -1 );
	//inspect( spops_ai_pool_place_phantom_cnt() );
*/