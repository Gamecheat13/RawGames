//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT_MIN()					1.000; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT_LIGHT()				1.250; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT_MEDIUM()			1.500; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT_HEAVY()				1.750; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT_MAX()					1.999; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE_MIN()			2.000; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE_LIGHT()		2.250; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE_HEAVY()		2.750; 	end
script static real 			DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE_MAX()			2.999; 	end

script static team 			DEF_E7_M1_AI_AREA_RETREAT_TEAM()								mule; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_areas_init::: Init
script dormant f_e7_m1_ai_areas_init()
	dprint( "f_e7_m1_ai_areas_init" );

	// allign teams to retreat team
	ai_allegiance( covenant, DEF_E7_M1_AI_AREA_RETREAT_TEAM() );
	ai_allegiance( DEF_E7_M1_AI_AREA_RETREAT_TEAM(), covenant );

	ai_allegiance( forerunner, DEF_E7_M1_AI_AREA_RETREAT_TEAM() );
	ai_allegiance( DEF_E7_M1_AI_AREA_RETREAT_TEAM(), forerunner );

	// setup areas
	// XXX

end

// === f_e7_m1_ai_area_move_update_cnt::: XXX
script static short f_e7_m1_ai_area_move_update_cnt( ai ai_move, short s_cnt )

	// get squad
	ai_move = ai_get_squad_safe( ai_move );

	if ( ai_living_count(ai_move) > 0 ) then
		
		// adjust count
		if ( s_cnt >= 0 ) then

			s_cnt = s_cnt - ai_living_count( ai_move );
			
			// clamp at 0
			if ( s_cnt < 0 ) then
				s_cnt = 0;
			end
			
		end

	end
	
	// return
	s_cnt;
end

// === f_e7_m1_ai_area_advance_from::: General advance from function
script static short f_e7_m1_ai_area_advance_from( ai ai_move, string_id sid_objective_from, short s_cnt )

	if ( ai_get_objective(ai_move) == sid_objective_from ) then
		dprint( "f_e7_m1_ai_area_advance_from" );
		s_cnt = f_e7_m1_ai_area_move_update_cnt( ai_move, s_cnt );
	end
	
	// return
	s_cnt;
end

// === f_e7_m1_ai_area_advance_to::: General advance to function
script static short f_e7_m1_ai_area_advance_to( ai ai_move, string_id sid_objective_to, short s_cnt )

	if ( ai_get_objective(ai_move) != sid_objective ) then
		dprint( "f_e7_m1_ai_area_advance_to" );
	
		// get full squad
		ai_move = ai_get_squad_safe( ai_move );
	
		// get count adjustment
		s_cnt = f_e7_m1_ai_area_move_update_cnt( ai_move, s_cnt );

		// set objective
		ai_set_objective( ai_move, sid_objective );

	end

	// return
	s_cnt;
end

// === f_e7_m1_ai_area_retreat_from::: General retreat from function
script static short f_e7_m1_ai_area_retreat_from( ai ai_move, string_id sid_objective, short s_cnt )

	if ( ai_get_objective(ai_move) == sid_objective_from ) then
		dprint( "f_e7_m1_ai_area_retreat_from" );
		s_cnt = f_e7_m1_ai_area_move_update_cnt( ai_move, s_cnt );
	end
	
	// return
	s_cnt;

end

// === f_e7_m1_ai_area_retreat_to::: General retreat to function
script static short f_e7_m1_ai_area_retreat_to( ai ai_move, string_id sid_objective_to, short s_cnt )

	if ( ai_get_objective(ai_move) != sid_objective ) then
		dprint( "f_e7_m1_ai_area_retreat_to" );

		// get full squad
		ai_move = ai_get_squad_safe( ai_move );
	
		// get count adjustment
		s_cnt = f_e7_m1_ai_area_move_update_cnt( ai_move, s_cnt );

		// XXX ignore team switch if in vehicle or knight?
		ai_set_team( ai_move, DEF_E7_M1_AI_AREA_RETREAT_TEAM() );

		// XXX ignore garbage if in vehicle or knight?
		f_ai_garbage_kill( ai_move );

		// set objective
		ai_set_objective( ai_move, sid_objective );

	end

	// return
	s_cnt;
end

// === f_e7_m1_ai_area_overflow_from::: General overflow from function
script static void f_e7_m1_ai_area_overflow_from( ai ai_move, string_id sid_objective )

	if ( ai_get_objective(ai_move) == sid_objective_from ) then
		dprint( "f_e7_m1_ai_area_overflow_from" );
	end

end

// === f_e7_m1_ai_area_overflow_to::: General overflow from function
script static void f_e7_m1_ai_area_overflow_to( ai ai_move, string_id sid_objective )

	if ( ai_get_objective(ai_move) != sid_objective_to ) then
		dprint( "f_e7_m1_ai_area_overflow_to" );
		ai_set_objective( ai_move, sid_objective );
	end

end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e7_m1_ai_area_cleanup()
local ai ai_squad = ai_get_squad( ai_current_actor );

	ai_set_team( ai_squad, DEF_E7_M1_AI_AREA_RETREAT_TEAM() );
	f_ai_garbage_kill( ai_squad );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 01 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 01: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_01_A_UNITS_MAX()								2; 																				end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_START(); 							end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_01_A() - 0.001; 			end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_02_B(); 							end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_ALL(); 						end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_01() + 0.01;					end
script static real 			DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03(); 								end
script static string_id DEF_E7_M1_AI_AREA_01_A_OBJECTIVE()								'objectives_e7_m1_area_01_a'; 						end
script static ai 				DEF_E7_M1_AI_AREA_01_A_ENEMY_TASK()								'objectives_e7_m1_area_01_a.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
//static short S_e7_m1_ai_area_01_a_advance_to_cnt =										0;
//static short S_e7_m1_ai_area_01_a_retreat_to_cnt =										0;
//static short S_e7_m1_ai_area_01_a_advance_from_cnt =									0;
static short S_e7_m1_ai_area_01_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_01_a_init::: Init
script dormant f_e7_m1_ai_area_01_a_init()
	dprint( "f_e7_m1_ai_area_01_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_01_a_trigger );

end

// === f_e7_m1_ai_area_01_a_props::: Props
script dormant f_e7_m1_ai_area_01_a_props()
	dprint( "f_e7_m1_ai_area_01_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_01_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_01_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_01_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_01_a_trigger: START" );
	
	// hand place initial dudes
	ai_place( gr_e7_m1_area_00_a );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_01_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_01_a_trigger: END" );

end

// === f_e7_m1_ai_area_01_a_advance_to_check::: Checks if it is OK to advance to this area
/*
script static boolean f_e7_m1_ai_area_01_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_01_a_advance_to_cnt != 0 );
end
*/

/*
// === f_e7_m1_ai_area_01_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_01_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_01_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_01_a_advance_from_cnt != 0 );
end
*/

/*
// === f_e7_m1_ai_area_01_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_01_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE(), S_e7_m1_ai_area_01_a_advance_to_cnt );
end
*/

/*
// === f_e7_m1_ai_area_01_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_01_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE(), S_e7_m1_ai_area_01_a_advance_from_cnt );
end
*/

/*
// === f_e7_m1_ai_area_01_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_01_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_01_a_retreat_to_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_01_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_01_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_01_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_01_a_retreat_from_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_01_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_01_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE(), S_e7_m1_ai_area_01_a_retreat_to_cnt );
end
*/

// === f_e7_m1_ai_area_01_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_01_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE(), S_e7_m1_ai_area_01_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_01_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_01_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_01_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_01_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_01_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_01_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_01_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_01_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e7_m1_ai_area_01_a_retreat_to_02_a()
	f_e7_m1_ai_area_01_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_02_a_retreat_to_action( ai_current_actor );
end
script command_script cs_e7_m1_ai_area_01_a_retreat_to_03_b()
	f_e7_m1_ai_area_01_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_03_b_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_01_a_overflow_to_02_a()
	f_e7_m1_ai_area_01_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_02_a_overflow_to_action( ai_current_actor );
end
script command_script cs_e7_m1_ai_area_01_a_overflow_to_03_b()
	f_e7_m1_ai_area_01_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_03_b_overflow_to_action( ai_current_actor );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 02 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 02: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_02_A_UNITS_MAX()								3; 																					end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_START(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_01(); 									end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_02_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_01_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_02_A(); 								end
//script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_FROM_MIN()	XXX; 																			end
//script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_FROM_MAX()	XXX; 																			end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_A() + 0.01;					end
script static real 			DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_02_C(); 								end
script static string_id DEF_E7_M1_AI_AREA_02_A_OBJECTIVE()								'objectives_e7_m1_area_02_a'; 							end
script static ai 				DEF_E7_M1_AI_AREA_02_A_ENEMY_TASK()								'objectives_e7_m1_area_02_a.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_02_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_02_a_retreat_to_cnt =										-1;
//static short S_e7_m1_ai_area_02_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_02_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_02_a_init::: Init
script dormant f_e7_m1_ai_area_02_a_init()
	dprint( "f_e7_m1_ai_area_02_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_02_a_trigger );

end

// === f_e7_m1_ai_area_02_a_props::: Props
script dormant f_e7_m1_ai_area_02_a_props()
	dprint( "f_e7_m1_ai_area_02_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_02_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_02_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_02_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_02_a_trigger: END" );

end

// === f_e7_m1_ai_area_02_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_02_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_a_advance_to_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_02_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_02_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_02_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_a_advance_from_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_02_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE(), S_e7_m1_ai_area_02_a_advance_to_cnt );
end

/*
// === f_e7_m1_ai_area_02_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE(), S_e7_m1_ai_area_02_a_advance_from_cnt );
end
*/

// === f_e7_m1_ai_area_02_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_02_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_02_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_02_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_02_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_02_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE(), S_e7_m1_ai_area_02_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_02_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE(), S_e7_m1_ai_area_02_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_02_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_02_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_02_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_02_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_02_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_02_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_02_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_02_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_02_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_02_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 02: B ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_02_B_UNITS_MAX()								7; 																					end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_START(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_02_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_02_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_02_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_02_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_B() + 0.01;					end
script static real 			DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03(); 									end
script static string_id DEF_E7_M1_AI_AREA_02_B_OBJECTIVE()								'objectives_e7_m1_area_02_b'; 							end
script static ai 				DEF_E7_M1_AI_AREA_02_B_ENEMY_TASK()								'objectives_e7_m1_area_02_b.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_02_b_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_02_b_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_02_b_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_02_b_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_02_b_init::: Init
script dormant f_e7_m1_ai_area_02_b_init()
	dprint( "f_e7_m1_ai_area_02_b_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_02_b_trigger );

end

// === f_e7_m1_ai_area_02_b_props::: Props
script dormant f_e7_m1_ai_area_02_b_props()
	dprint( "f_e7_m1_ai_area_02_b_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_02_b_trigger::: Trigger
script dormant f_e7_m1_ai_area_02_b_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_B_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_02_b_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_B_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_02_b_trigger: END" );

end

// === f_e7_m1_ai_area_02_b_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_02_b_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_b_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_02_b_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_02_b_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_02_B_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_b_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_02_b_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_b_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE(), S_e7_m1_ai_area_02_b_advance_to_cnt );
end

// === f_e7_m1_ai_area_02_b_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_b_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE(), S_e7_m1_ai_area_02_b_advance_from_cnt );
end

// === f_e7_m1_ai_area_02_b_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_02_b_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_b_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_02_b_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_02_b_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_02_B_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_b_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_02_b_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_b_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE(), S_e7_m1_ai_area_02_b_retreat_to_cnt );
end

// === f_e7_m1_ai_area_02_b_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_b_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE(), S_e7_m1_ai_area_02_b_retreat_from_cnt );
end

// === f_e7_m1_ai_area_02_b_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_02_b_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_B_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_02_B_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_02_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE() );
end

// === f_e7_m1_ai_area_02_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_b_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_02_B_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_02_b_advance_to_0$_zzz()
	f_e7_m1_ai_area_02_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_b_retreat_to_0$_zzz()
	f_e7_m1_ai_area_02_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_b_overflow_to_0$_zzz()
	f_e7_m1_ai_area_02_b_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 02: C ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_02_C_UNITS_MAX()								5; 																				end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_01(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_02_C() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_03(); 								end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
//script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_TO_MIN()		XXX; 																		end
//script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_TO_MAX()		XXX; 																		end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_B(); 							end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_02_B(); 							end
//script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 						end
//script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_TO_MAX()		XXX; 																		end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_C() + 0.01;				end
script static real 			DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_04(); 								end
script static string_id DEF_E7_M1_AI_AREA_02_C_OBJECTIVE()								'objectives_e7_m1_area_02_c'; 						end
script static ai 				DEF_E7_M1_AI_AREA_02_C_ENEMY_TASK()								'objectives_e7_m1_area_02_c.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_02_c_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_02_c_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_02_c_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_02_c_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_02_c_init::: Init
script dormant f_e7_m1_ai_area_02_c_init()
	dprint( "f_e7_m1_ai_area_02_c_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_02_c_trigger );

end

// === f_e7_m1_ai_area_02_c_props::: Props
script dormant f_e7_m1_ai_area_02_c_props()
	dprint( "f_e7_m1_ai_area_02_c_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_02_c_trigger::: Trigger
script dormant f_e7_m1_ai_area_02_c_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_C_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_02_c_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_02_C_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_02_c_trigger: END" );

end

/*
// === f_e7_m1_ai_area_02_c_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_02_c_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_c_advance_to_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_02_c_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_02_c_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_02_C_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_c_advance_from_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_02_c_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_c_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE(), S_e7_m1_ai_area_02_c_advance_to_cnt );
end
*/

// === f_e7_m1_ai_area_02_c_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_c_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE(), S_e7_m1_ai_area_02_c_advance_from_cnt );
end

/*
// === f_e7_m1_ai_area_02_c_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_02_c_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_02_c_retreat_to_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_02_c_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_02_c_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_02_C_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_02_c_retreat_from_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_02_c_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_02_c_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE(), S_e7_m1_ai_area_02_c_retreat_to_cnt );
end
*/

// === f_e7_m1_ai_area_02_c_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_02_c_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE(), S_e7_m1_ai_area_02_c_retreat_from_cnt );
end

// === f_e7_m1_ai_area_02_c_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_02_c_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_02_C_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_02_C_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_02_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE() );
end

// === f_e7_m1_ai_area_02_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_02_c_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_02_C_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_02_c_advance_to_0$_zzz()
	f_e7_m1_ai_area_02_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_c_retreat_to_0$_zzz()
	f_e7_m1_ai_area_02_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_02_c_overflow_to_0$_zzz()
	f_e7_m1_ai_area_02_c_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 03 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 03: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_03_A_UNITS_MAX()								5; 																					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_START(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_03_A() - 0.01;					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_03_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_03_A() + 0.01;					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_02_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_03_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_04(); 									end
script static string_id DEF_E7_M1_AI_AREA_03_A_OBJECTIVE()								'objectives_e7_m1_area_03_a'; 							end
script static ai 				DEF_E7_M1_AI_AREA_03_A_ENEMY_TASK()								'objectives_e7_m1_area_03_a.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_03_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_03_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_03_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_03_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_03_a_init::: Init
script dormant f_e7_m1_ai_area_03_a_init()
	dprint( "f_e7_m1_ai_area_03_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_03_a_trigger );

end

// === f_e7_m1_ai_area_03_a_props::: Props
script dormant f_e7_m1_ai_area_03_a_props()
	dprint( "f_e7_m1_ai_area_03_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_03_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_03_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_03_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_03_a_trigger: END" );

end

// === f_e7_m1_ai_area_03_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_03_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_a_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_03_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_03_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_a_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE(), S_e7_m1_ai_area_03_a_advance_to_cnt );
end

// === f_e7_m1_ai_area_03_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE(), S_e7_m1_ai_area_03_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_03_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_03_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_03_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_03_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE(), S_e7_m1_ai_area_03_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_03_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE(), S_e7_m1_ai_area_03_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_03_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_03_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_03_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_03_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_03_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_03_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_03_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_03_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_03_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_03_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 03: B ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_03_B_UNITS_MAX()								4; 																					end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_START(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_03_B() - 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_04(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_03_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_05(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_B() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static string_id DEF_E7_M1_AI_AREA_03_B_OBJECTIVE()								'objectives_e7_m1_area_03_b'; 							end
script static ai 				DEF_E7_M1_AI_AREA_03_B_ENEMY_TASK()								'objectives_e7_m1_area_03_b.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_03_b_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_03_b_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_03_b_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_03_b_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_03_b_init::: Init
script dormant f_e7_m1_ai_area_03_b_init()
	dprint( "f_e7_m1_ai_area_03_b_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_03_b_trigger );

end

// === f_e7_m1_ai_area_03_b_props::: Props
script dormant f_e7_m1_ai_area_03_b_props()
	dprint( "f_e7_m1_ai_area_03_b_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_03_b_trigger::: Trigger
script dormant f_e7_m1_ai_area_03_b_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_B_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_03_b_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_B_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_03_b_trigger: END" );

end

// === f_e7_m1_ai_area_03_b_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_03_b_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_b_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_b_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_03_b_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_03_B_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_b_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_b_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_b_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE(), S_e7_m1_ai_area_03_b_advance_to_cnt );
end

// === f_e7_m1_ai_area_03_b_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_b_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE(), S_e7_m1_ai_area_03_b_advance_from_cnt );
end

// === f_e7_m1_ai_area_03_b_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_03_b_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_b_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_b_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_03_b_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_03_B_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_b_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_b_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_b_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE(), S_e7_m1_ai_area_03_b_retreat_to_cnt );
end

// === f_e7_m1_ai_area_03_b_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_b_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE(), S_e7_m1_ai_area_03_b_retreat_from_cnt );
end

// === f_e7_m1_ai_area_03_b_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_03_b_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_B_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_03_B_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_03_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE() );
end

// === f_e7_m1_ai_area_03_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_b_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_03_B_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_03_b_advance_to_0$_zzz()
	f_e7_m1_ai_area_03_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_b_retreat_to_0$_zzz()
	f_e7_m1_ai_area_03_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_b_overflow_to_0$_zzz()
	f_e7_m1_ai_area_03_b_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 03: C ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_03_C_UNITS_MAX()								4; 																					end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_02(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_03_C() - 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_03_C() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_03_C(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_03_C() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_C() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_04_C(); 								end
script static string_id DEF_E7_M1_AI_AREA_03_C_OBJECTIVE()								'objectives_e7_m1_area_03_c'; 							end
script static ai 				DEF_E7_M1_AI_AREA_03_C_ENEMY_TASK()								'objectives_e7_m1_area_03_c.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_03_c_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_03_c_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_03_c_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_03_c_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_03_c_init::: Init
script dormant f_e7_m1_ai_area_03_c_init()
	dprint( "f_e7_m1_ai_area_03_c_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_03_c_trigger );

end

// === f_e7_m1_ai_area_03_c_props::: Props
script dormant f_e7_m1_ai_area_03_c_props()
	dprint( "f_e7_m1_ai_area_03_c_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_03_c_trigger::: Trigger
script dormant f_e7_m1_ai_area_03_c_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_C_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_03_c_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_03_C_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_03_c_trigger: END" );

end

// === f_e7_m1_ai_area_03_c_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_03_c_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_c_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_c_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_03_c_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_03_C_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_c_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_c_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_c_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE(), S_e7_m1_ai_area_03_c_advance_to_cnt );
end

// === f_e7_m1_ai_area_03_c_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_c_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE(), S_e7_m1_ai_area_03_c_advance_from_cnt );
end

// === f_e7_m1_ai_area_03_c_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_03_c_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_03_c_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_03_c_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_03_c_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_03_C_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_03_c_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_03_c_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_03_c_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE(), S_e7_m1_ai_area_03_c_retreat_to_cnt );
end

// === f_e7_m1_ai_area_03_c_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_03_c_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE(), S_e7_m1_ai_area_03_c_retreat_from_cnt );
end

// === f_e7_m1_ai_area_03_c_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_03_c_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_03_C_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_03_C_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_03_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE() );
end

// === f_e7_m1_ai_area_03_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_03_c_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_03_C_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_03_c_advance_to_0$_zzz()
	f_e7_m1_ai_area_03_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_c_retreat_to_0$_zzz()
	f_e7_m1_ai_area_03_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_03_c_overflow_to_0$_zzz()
	f_e7_m1_ai_area_03_c_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 04 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 04: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_04_A_UNITS_MAX()								3; 																					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_04_A() - 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_04_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_03_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_03_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_04_A(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_A() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_05(); 									end
script static string_id DEF_E7_M1_AI_AREA_04_A_OBJECTIVE()								'objectives_e7_m1_area_04_a'; 							end
script static ai 				DEF_E7_M1_AI_AREA_04_A_ENEMY_TASK()								'objectives_e7_m1_area_04_a.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_04_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_04_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_04_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_04_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_04_a_init::: Init
script dormant f_e7_m1_ai_area_04_a_init()
	dprint( "f_e7_m1_ai_area_04_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_04_a_trigger );

end

// === f_e7_m1_ai_area_04_a_props::: Props
script dormant f_e7_m1_ai_area_04_a_props()
	dprint( "f_e7_m1_ai_area_04_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_04_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_04_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_04_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_04_a_trigger: END" );

end

// === f_e7_m1_ai_area_04_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_04_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_a_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_04_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_04_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_a_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE(), S_e7_m1_ai_area_04_a_advance_to_cnt );
end

// === f_e7_m1_ai_area_04_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE(), S_e7_m1_ai_area_04_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_04_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_04_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_04_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_04_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE(), S_e7_m1_ai_area_04_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_04_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE(), S_e7_m1_ai_area_04_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_04_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_04_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_04_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_04_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_04_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_04_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_04_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_04_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_04_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_04_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 04: B ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_04_B_UNITS_MAX()								5; 																					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_03(); 									end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_04_B() - 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_04_B() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_03_C(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_B() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_B(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_03_C(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_B() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_B() + 0.01; 					end
script static real 			DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_06(); 									end
script static string_id DEF_E7_M1_AI_AREA_04_B_OBJECTIVE()								'objectives_e7_m1_area_04_b'; 							end
script static ai 				DEF_E7_M1_AI_AREA_04_B_ENEMY_TASK()								'objectives_e7_m1_area_04_b.enemy_gate'; 		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_04_b_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_04_b_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_04_b_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_04_b_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_04_b_init::: Init
script dormant f_e7_m1_ai_area_04_b_init()
	dprint( "f_e7_m1_ai_area_04_b_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_04_b_trigger );

end

// === f_e7_m1_ai_area_04_b_props::: Props
script dormant f_e7_m1_ai_area_04_b_props()
	dprint( "f_e7_m1_ai_area_04_b_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_04_b_trigger::: Trigger
script dormant f_e7_m1_ai_area_04_b_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_B_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_04_b_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_B_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_04_b_trigger: END" );

end

// === f_e7_m1_ai_area_04_b_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_04_b_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_b_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_b_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_04_b_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_04_B_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_b_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_b_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_b_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE(), S_e7_m1_ai_area_04_b_advance_to_cnt );
end

// === f_e7_m1_ai_area_04_b_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_b_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE(), S_e7_m1_ai_area_04_b_advance_from_cnt );
end

// === f_e7_m1_ai_area_04_b_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_04_b_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_b_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_b_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_04_b_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_04_B_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_b_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_b_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_b_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE(), S_e7_m1_ai_area_04_b_retreat_to_cnt );
end

// === f_e7_m1_ai_area_04_b_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_b_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE(), S_e7_m1_ai_area_04_b_retreat_from_cnt );
end

// === f_e7_m1_ai_area_04_b_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_04_b_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_B_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_04_B_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_04_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE() );
end

// === f_e7_m1_ai_area_04_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_b_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_04_B_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_04_b_advance_to_0$_zzz()
	f_e7_m1_ai_area_04_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_b_retreat_to_0$_zzz()
	f_e7_m1_ai_area_04_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_b_overflow_to_0$_zzz()
	f_e7_m1_ai_area_04_b_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 04: C ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_04_C_UNITS_MAX()								7; 																				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_03(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_04_C() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_04_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_04_B(); 							end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_04_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_06(); 								end
script static string_id DEF_E7_M1_AI_AREA_04_C_OBJECTIVE()								'objectives_e7_m1_area_04_c'; 						end
script static ai 				DEF_E7_M1_AI_AREA_04_C_ENEMY_TASK()								'objectives_e7_m1_area_04_c.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_04_c_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_04_c_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_04_c_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_04_c_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_04_c_init::: Init
script dormant f_e7_m1_ai_area_04_c_init()
	dprint( "f_e7_m1_ai_area_04_c_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_04_c_trigger );

end

// === f_e7_m1_ai_area_04_c_props::: Props
script dormant f_e7_m1_ai_area_04_c_props()
	dprint( "f_e7_m1_ai_area_04_c_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_04_c_trigger::: Trigger
script dormant f_e7_m1_ai_area_04_c_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_C_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_04_c_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_04_C_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_04_c_trigger: END" );

end

// === f_e7_m1_ai_area_04_c_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_04_c_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_c_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_c_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_04_c_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_04_C_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_c_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_c_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_c_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE(), S_e7_m1_ai_area_04_c_advance_to_cnt );
end

// === f_e7_m1_ai_area_04_c_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_c_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE(), S_e7_m1_ai_area_04_c_advance_from_cnt );
end

// === f_e7_m1_ai_area_04_c_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_04_c_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_04_c_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_04_c_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_04_c_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_04_C_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_04_c_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_04_c_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_04_c_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE(), S_e7_m1_ai_area_04_c_retreat_to_cnt );
end

// === f_e7_m1_ai_area_04_c_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_04_c_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE(), S_e7_m1_ai_area_04_c_retreat_from_cnt );
end

// === f_e7_m1_ai_area_04_c_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_04_c_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_04_C_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_04_C_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_04_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE() );
end

// === f_e7_m1_ai_area_04_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_04_c_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_04_C_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_04_c_advance_to_0$_zzz()
	f_e7_m1_ai_area_04_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_c_retreat_to_0$_zzz()
	f_e7_m1_ai_area_04_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_04_c_overflow_to_0$_zzz()
	f_e7_m1_ai_area_04_c_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 05 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 05: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_05_A_UNITS_MAX()								7; 																				end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_05_A() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_05_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_05_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_C(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_05_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_06(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_05_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_ALL(); 																			end
script static string_id DEF_E7_M1_AI_AREA_05_A_OBJECTIVE()								'objectives_e7_m1_area_05_a'; 						end
script static ai 				DEF_E7_M1_AI_AREA_05_A_ENEMY_TASK()								'objectives_e7_m1_area_05_a.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_05_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_05_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_05_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_05_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_05_a_init::: Init
script dormant f_e7_m1_ai_area_05_a_init()
	dprint( "f_e7_m1_ai_area_05_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_05_a_trigger );

end

// === f_e7_m1_ai_area_05_a_props::: Props
script dormant f_e7_m1_ai_area_05_a_props()
	dprint( "f_e7_m1_ai_area_05_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_05_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_05_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_05_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_05_a_trigger: END" );

end

// === f_e7_m1_ai_area_05_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_05_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_a_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_05_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_05_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_a_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE(), S_e7_m1_ai_area_05_a_advance_to_cnt );
end

// === f_e7_m1_ai_area_05_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE(), S_e7_m1_ai_area_05_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_05_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_05_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_05_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_05_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE(), S_e7_m1_ai_area_05_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_05_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE(), S_e7_m1_ai_area_05_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_05_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_05_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_05_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_05_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_05_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_05_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_05_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_05_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_05_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_05_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 05: B ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_05_B_UNITS_MAX()								4; 																				end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_05_B() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_05_B() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_05_B() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_04_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_05_B(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_05_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_05_B() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_06(); 								end
script static string_id DEF_E7_M1_AI_AREA_05_B_OBJECTIVE()								'objectives_e7_m1_area_05_b'; 						end
script static ai 				DEF_E7_M1_AI_AREA_05_B_ENEMY_TASK()								'objectives_e7_m1_area_05_b.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_05_b_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_05_b_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_05_b_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_05_b_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_05_b_init::: Init
script dormant f_e7_m1_ai_area_05_b_init()
	dprint( "f_e7_m1_ai_area_05_b_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_05_b_trigger );

end

// === f_e7_m1_ai_area_05_b_props::: Props
script dormant f_e7_m1_ai_area_05_b_props()
	dprint( "f_e7_m1_ai_area_05_b_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_05_b_trigger::: Trigger
script dormant f_e7_m1_ai_area_05_b_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_B_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_05_b_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_B_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_05_b_trigger: END" );

end

// === f_e7_m1_ai_area_05_b_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_05_b_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_b_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_b_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_05_b_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_05_B_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_b_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_b_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_b_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE(), S_e7_m1_ai_area_05_b_advance_to_cnt );
end

// === f_e7_m1_ai_area_05_b_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_b_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE(), S_e7_m1_ai_area_05_b_advance_from_cnt );
end

// === f_e7_m1_ai_area_05_b_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_05_b_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_b_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_b_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_05_b_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_05_B_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_b_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_b_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_b_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE(), S_e7_m1_ai_area_05_b_retreat_to_cnt );
end

// === f_e7_m1_ai_area_05_b_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_b_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE(), S_e7_m1_ai_area_05_b_retreat_from_cnt );
end

// === f_e7_m1_ai_area_05_b_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_05_b_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_B_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_05_B_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_05_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE() );
end

// === f_e7_m1_ai_area_05_b_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_b_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_05_B_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_05_b_advance_to_0$_zzz()
	f_e7_m1_ai_area_05_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_b_retreat_to_0$_zzz()
	f_e7_m1_ai_area_05_b_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_b_overflow_to_0$_zzz()
	f_e7_m1_ai_area_05_b_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 05: C ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_05_C_UNITS_MAX()								10; 																			end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_05_C() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_05_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_04(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_05_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_05_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_05_C(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_07(); 								end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_05_C() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_08(); 								end
script static string_id DEF_E7_M1_AI_AREA_05_C_OBJECTIVE()								'objectives_e7_m1_area_05_c'; 						end
script static ai 				DEF_E7_M1_AI_AREA_05_C_ENEMY_TASK()								'objectives_e7_m1_area_05_c.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_05_c_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_05_c_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_05_c_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_05_c_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_05_c_init::: Init
script dormant f_e7_m1_ai_area_05_c_init()
	dprint( "f_e7_m1_ai_area_05_c_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_05_c_trigger );

end

// === f_e7_m1_ai_area_05_c_props::: Props
script dormant f_e7_m1_ai_area_05_c_props()
	dprint( "f_e7_m1_ai_area_05_c_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_05_c_trigger::: Trigger
script dormant f_e7_m1_ai_area_05_c_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_C_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_05_c_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_05_C_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_05_c_trigger: END" );

end

// === f_e7_m1_ai_area_05_c_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_05_c_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_c_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_c_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_05_c_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_05_C_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_c_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_c_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_c_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE(), S_e7_m1_ai_area_05_c_advance_to_cnt );
end

// === f_e7_m1_ai_area_05_c_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_c_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE(), S_e7_m1_ai_area_05_c_advance_from_cnt );
end

// === f_e7_m1_ai_area_05_c_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_05_c_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_05_c_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_05_c_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_05_c_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_05_C_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_05_c_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_05_c_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_05_c_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE(), S_e7_m1_ai_area_05_c_retreat_to_cnt );
end

// === f_e7_m1_ai_area_05_c_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_05_c_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE(), S_e7_m1_ai_area_05_c_retreat_from_cnt );
end

// === f_e7_m1_ai_area_05_c_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_05_c_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_05_C_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_05_C_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_05_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE() );
end

// === f_e7_m1_ai_area_05_c_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_05_c_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_05_C_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_05_c_advance_to_0$_zzz()
	f_e7_m1_ai_area_05_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_c_retreat_to_0$_zzz()
	f_e7_m1_ai_area_05_c_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_05_c_overflow_to_0$_zzz()
	f_e7_m1_ai_area_05_c_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 06 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 06: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_06_A_UNITS_MAX()								10; 																			end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_05(); 								end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_06_A() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_06_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_05(); 								end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_06_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_05(); 								end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_06_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_07(); 								end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_06_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static string_id DEF_E7_M1_AI_AREA_06_A_OBJECTIVE()								'objectives_e7_m1_area_06_a'; 						end
script static ai 				DEF_E7_M1_AI_AREA_06_A_ENEMY_TASK()								'objectives_e7_m1_area_06_a.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_06_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_06_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_06_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_06_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_06_a_init::: Init
script dormant f_e7_m1_ai_area_06_a_init()
	dprint( "f_e7_m1_ai_area_06_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_06_a_trigger );

end

// === f_e7_m1_ai_area_06_a_props::: Props
script dormant f_e7_m1_ai_area_06_a_props()
	dprint( "f_e7_m1_ai_area_06_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_06_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_06_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_06_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_06_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_06_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_06_a_trigger: END" );

end

// === f_e7_m1_ai_area_06_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_06_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_06_a_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_06_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_06_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_06_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_06_a_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_06_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_06_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE(), S_e7_m1_ai_area_06_a_advance_to_cnt );
end

// === f_e7_m1_ai_area_06_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_06_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE(), S_e7_m1_ai_area_06_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_06_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_06_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_06_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_06_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_06_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_06_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_06_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_06_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_06_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE(), S_e7_m1_ai_area_06_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_06_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_06_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE(), S_e7_m1_ai_area_06_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_06_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_06_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_06_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_06_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_06_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_06_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_06_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_06_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_06_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_06_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_06_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_06_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_06_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_06_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 07 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 07: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_07_A_UNITS_MAX()								7; 																				end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_07_A() - 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_07_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_TO_MAX()		DEF_E7_M1_AI_OBJCON_07_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_07_A(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_05_C(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_07_A() + 0.01; 				end
script static real 			DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_FROM_MAX()	DEF_E7_M1_AI_OBJCON_ALL(); 							end
script static string_id DEF_E7_M1_AI_AREA_07_A_OBJECTIVE()								'objectives_e7_m1_area_07_a'; 						end
script static ai 				DEF_E7_M1_AI_AREA_07_A_ENEMY_TASK()								'objectives_e7_m1_area_07_a.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_07_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_07_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_07_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_07_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_07_a_init::: Init
script dormant f_e7_m1_ai_area_07_a_init()
	dprint( "f_e7_m1_ai_area_07_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_07_a_trigger );

end

// === f_e7_m1_ai_area_07_a_props::: Props
script dormant f_e7_m1_ai_area_07_a_props()
	dprint( "f_e7_m1_ai_area_07_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_07_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_07_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_07_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_07_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_07_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_07_a_trigger: END" );

end

// === f_e7_m1_ai_area_07_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_07_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_07_a_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_07_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_07_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_07_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_07_a_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_07_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_07_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE(), S_e7_m1_ai_area_07_a_advance_to_cnt );
end

// === f_e7_m1_ai_area_07_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_07_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE(), S_e7_m1_ai_area_07_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_07_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_07_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_07_a_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_07_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_07_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_07_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_07_a_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_07_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_07_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE(), S_e7_m1_ai_area_07_a_retreat_to_cnt );
end

// === f_e7_m1_ai_area_07_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_07_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE(), S_e7_m1_ai_area_07_a_retreat_from_cnt );
end

// === f_e7_m1_ai_area_07_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_07_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_07_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_07_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_07_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_07_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_07_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_07_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_07_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_07_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_07_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_07_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_07_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_07_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 08 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 08: A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_08_A_UNITS_MAX()								20; 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_PLACE_MIN()					DEF_E7_M1_AI_OBJCON_05_C(); 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_PLACE_MAX()					DEF_E7_M1_AI_OBJCON_08_A(); 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_CLEANUP_MIN()				DEF_E7_M1_AI_OBJCON_NONE(); 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_NONE(); 								end
//script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_TO_MIN()		XXX; 																				end
//script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_TO_MAX()		XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_FROM_MIN()	DEF_E7_M1_AI_OBJCON_07_A(); 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_FROM_MAX()	DEF_E7_M1_AI_OBJCON_08_A(); 																				end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_TO_MAX()		DEF_E7_M1_AI_OBJCON_ALL(); 																				end
//script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_FROM_MIN()	DEF_E7_M1_AI_OBJCON_08_A() + 0.01; 																				end
//script static real 			DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_FROM_MAX()	XXX; 																				end
script static string_id DEF_E7_M1_AI_AREA_08_A_OBJECTIVE()								'objectives_e7_m1_area_08_a'; 						end
script static ai 				DEF_E7_M1_AI_AREA_08_A_ENEMY_TASK()								'objectives_e7_m1_area_08_a.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_08_a_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_08_a_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_08_a_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_08_a_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_08_a_init::: Init
script dormant f_e7_m1_ai_area_08_a_init()
	dprint( "f_e7_m1_ai_area_08_a_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_08_a_trigger );

end

// === f_e7_m1_ai_area_08_a_props::: Props
script dormant f_e7_m1_ai_area_08_a_props()
	dprint( "f_e7_m1_ai_area_08_a_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_08_a_trigger::: Trigger
script dormant f_e7_m1_ai_area_08_a_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_08_A_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_08_a_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_08_A_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_08_a_trigger: END" );

end

/*
// === f_e7_m1_ai_area_08_a_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_08_a_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_08_a_advance_to_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_08_a_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_08_a_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_08_A_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_08_a_advance_from_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_08_a_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_08_a_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE(), S_e7_m1_ai_area_08_a_advance_to_cnt );
end
*/

// === f_e7_m1_ai_area_08_a_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_08_a_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE(), S_e7_m1_ai_area_08_a_advance_from_cnt );
end

// === f_e7_m1_ai_area_08_a_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_08_a_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_08_a_retreat_to_cnt != 0 );
end

/*
// === f_e7_m1_ai_area_08_a_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_08_a_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_08_A_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_08_a_retreat_from_cnt != 0 );
end
*/

// === f_e7_m1_ai_area_08_a_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_08_a_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE(), S_e7_m1_ai_area_08_a_retreat_to_cnt );
end

/*
// === f_e7_m1_ai_area_08_a_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_08_a_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE(), S_e7_m1_ai_area_08_a_retreat_from_cnt );
end
*/

// === f_e7_m1_ai_area_08_a_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_08_a_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_08_A_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_08_A_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_08_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE() );
end

// === f_e7_m1_ai_area_08_a_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_08_a_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_08_A_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
/*
script command_script cs_e7_m1_ai_area_08_a_advance_to_0$_zzz()
	f_e7_m1_ai_area_08_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_08_a_retreat_to_0$_zzz()
	f_e7_m1_ai_area_08_a_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_08_a_overflow_to_0$_zzz()
	f_e7_m1_ai_area_08_a_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/














/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 0#: VVV ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short 		DEF_E7_M1_AI_AREA_0#_VVV_UNITS_MAX()								XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_CLEANUP_MIN()				XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_CLEANUP_MAX()				DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_PLACE_MIN()					XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_PLACE_MAX()					XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_TO_MIN()		XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_TO_MAX()		XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_FROM_MIN()	XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_FROM_MAX()	XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_TO_MIN()		DEF_E7_M1_AI_OBJCON_ALL(); 								end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_TO_MAX()		XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_FROM_MIN()	XXX; 																				end
script static real 			DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_FROM_MAX()	XXX; 																				end
script static string_id DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE()								'objectives_e7_m1_area_0#_vvv'; 						end
script static ai 				DEF_E7_M1_AI_AREA_0#_VVV_ENEMY_TASK()								'objectives_e7_m1_area_0#_vvv.enemy_gate'; 	end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_area_0#_vvv_advance_to_cnt =										-1;
static short S_e7_m1_ai_area_0#_vvv_retreat_to_cnt =										-1;
static short S_e7_m1_ai_area_0#_vvv_advance_from_cnt =									-1;
static short S_e7_m1_ai_area_0#_vvv_retreat_from_cnt =									-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_area_0#_vvv_init::: Init
script dormant f_e7_m1_ai_area_0#_vvv_init()
	dprint( "f_e7_m1_ai_area_0#_vvv_init" );

	// setup trigger
	wake( f_e7_m1_ai_area_0#_vvv_trigger );

end

// === f_e7_m1_ai_area_0#_vvv_props::: Props
script dormant f_e7_m1_ai_area_0#_vvv_props()
	dprint( "f_e7_m1_ai_area_0#_vvv_props" );

	//object_create_folder( xxx );

end

// === f_e7_m1_ai_area_0#_vvv_trigger::: Trigger
script dormant f_e7_m1_ai_area_0#_vvv_trigger()

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_PLACE_MIN(), 1 );
	dprint( "f_e7_m1_ai_area_0#_vvv_trigger: START" );
	
	// XXX setup placements
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), DEF_E7_M1_AI_AREA_POOL_INDEX_UNIT(), r_chance, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE()) );
	//thread( spops_ai_pool_place_loc(GetCurrentThreadId(), flg_spawn_loc, r_priority, r_weight_place_max, DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), DEF_E7_M1_AI_AREA_POOL_INDEX_VEHICLE(), r_chance, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE()) );

	sleep_until( f_e7_m1_ai_objcon() >= DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_PLACE_MAX(), 1 );
	dprint( "f_e7_m1_ai_area_0#_vvv_trigger: END" );

end

// === f_e7_m1_ai_area_0#_vvv_advance_to_check::: Checks if it is OK to advance to this area
script static boolean f_e7_m1_ai_area_0#_vvv_advance_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_TO_MIN(), DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_TO_MAX() )
	and
	( S_e7_m1_ai_area_0#_vvv_advance_to_cnt != 0 );
end

// === f_e7_m1_ai_area_0#_vvv_advance_from_check::: Checks if it is OK to advance FROM this area
script static boolean f_e7_m1_ai_area_0#_vvv_advance_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_FROM_MIN(), DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_ADVANCE_FROM_MAX() )
	and
	( S_e7_m1_ai_area_0#_vvv_advance_from_cnt != 0 );
end

// === f_e7_m1_ai_area_0#_vvv_advance_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_advance_to_action( ai ai_unit )
	S_e7_m1_ai_area_0#_vvv_advance_to_cnt = f_e7_m1_ai_area_advance_to( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE(), S_e7_m1_ai_area_0#_vvv_advance_to_cnt );
end

// === f_e7_m1_ai_area_0#_vvv_advance_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_advance_from_action( ai ai_unit )
	S_e7_m1_ai_area_0#_vvv_advance_from_cnt = f_e7_m1_ai_area_advance_from( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE(), S_e7_m1_ai_area_0#_vvv_advance_from_cnt );
end

// === f_e7_m1_ai_area_0#_vvv_retreat_to_check::: Checks if it is OK to retreat to this area
script static boolean f_e7_m1_ai_area_0#_vvv_retreat_to_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_TO_MIN(), DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_TO_MAX() )
	and
	( S_e7_m1_ai_area_0#_vvv_retreat_to_cnt != 0 );
end

// === f_e7_m1_ai_area_0#_vvv_retreat_from_check::: Checks if it is OK to retreat FROM this area
script static boolean f_e7_m1_ai_area_0#_vvv_retreat_from_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_FROM_MIN(), DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_RETREAT_FROM_MAX() )
	and
	( S_e7_m1_ai_area_0#_vvv_retreat_from_cnt != 0 );
end

// === f_e7_m1_ai_area_0#_vvv_retreat_to_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_retreat_to_action( ai ai_unit )
	S_e7_m1_ai_area_0#_vvv_retreat_to_cnt = f_e7_m1_ai_area_retreat_to( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE(), S_e7_m1_ai_area_0#_vvv_retreat_to_cnt );
end

// === f_e7_m1_ai_area_0#_vvv_retreat_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_retreat_from_action( ai ai_unit )
	S_e7_m1_ai_area_0#_vvv_retreat_from_cnt = f_e7_m1_ai_area_retreat_from( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE(), S_e7_m1_ai_area_0#_vvv_retreat_from_cnt );
end

// === f_e7_m1_ai_area_0#_vvv_cleanup_check::: Checks if the area should be cleaned up
script static boolean f_e7_m1_ai_area_0#_vvv_cleanup_check()
	f_e7_m1_ai_objcon_range_check( DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_CLEANUP_MIN(), DEF_E7_M1_AI_AREA_0#_VVV_OBJCON_CLEANUP_MIN() );
end

// === f_e7_m1_ai_area_0#_vvv_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_overflow_from_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_from( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE() );
end

// === f_e7_m1_ai_area_0#_vvv_overflow_from_action::: Switches objectives FROM this area
script static void f_e7_m1_ai_area_0#_vvv_overflow_to_action( ai ai_unit )
	f_e7_m1_ai_area_overflow_to( ai_unit, DEF_E7_M1_AI_AREA_0#_VVV_OBJECTIVE() );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e7_m1_ai_area_0#_vvv_advance_to_0$_zzz()
	f_e7_m1_ai_area_0#_vvv_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_0#_vvv_retreat_to_0$_zzz()
	f_e7_m1_ai_area_0#_vvv_retreat_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_retreat_to_action( ai_current_actor );
end

script command_script cs_e7_m1_ai_area_0#_vvv_overflow_to_0$_zzz()
	f_e7_m1_ai_area_0#_vvv_overflow_from_action( ai_current_actor );
	f_e7_m1_ai_area_0$_zzz_overflow_to_action( ai_current_actor );
end
*/

/*
script static real DEF_E7_M1_AI_OBJCON_01_A()						100.0; end

script static real DEF_E7_M1_AI_OBJCON_02_A()						200.0; end
script static real DEF_E7_M1_AI_OBJCON_02_B()						225.0; end
script static real DEF_E7_M1_AI_OBJCON_02_C()						250.0; end

script static real DEF_E7_M1_AI_OBJCON_03_A()						300.0; end
script static real DEF_E7_M1_AI_OBJCON_03_B()						350.0; end
script static real DEF_E7_M1_AI_OBJCON_03_C()						350.0; end

script static real DEF_E7_M1_AI_OBJCON_04_A()						400.0; end
script static real DEF_E7_M1_AI_OBJCON_04_B()						400.0; end
script static real DEF_E7_M1_AI_OBJCON_04_C()						450.0; end

script static real DEF_E7_M1_AI_OBJCON_05_A()						500.0; end
script static real DEF_E7_M1_AI_OBJCON_05_B()						525.0; end
script static real DEF_E7_M1_AI_OBJCON_05_C()						550.0; end

script static real DEF_E7_M1_AI_OBJCON_06_A()						600.0; end

script static real DEF_E7_M1_AI_OBJCON_07_B()						700.0; end

script static real DEF_E7_M1_AI_OBJCON_08_C()						800.0; end
*/