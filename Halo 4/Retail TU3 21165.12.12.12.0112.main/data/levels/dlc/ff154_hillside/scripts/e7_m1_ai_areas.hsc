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
global real DEF_E7M1_AI_AREA_POOL_INDEX_UNIT_MIN = 						1.000;
global real DEF_E7M1_AI_AREA_POOL_INDEX_UNIT_LIGHT = 					1.250;
global real DEF_E7M1_AI_AREA_POOL_INDEX_UNIT_MEDIUM = 				1.500;
global real DEF_E7M1_AI_AREA_POOL_INDEX_UNIT_HEAVY = 					1.750;
global real DEF_E7M1_AI_AREA_POOL_INDEX_UNIT_MAX = 						1.999;
global real DEF_E7M1_AI_AREA_POOL_INDEX_VEHICLE_MIN = 				2.000;
global real DEF_E7M1_AI_AREA_POOL_INDEX_VEHICLE_LIGHT = 			2.250;
global real DEF_E7M1_AI_AREA_POOL_INDEX_VEHICLE_HEAVY = 			2.750;
global real DEF_E7M1_AI_AREA_POOL_INDEX_VEHICLE_MAX = 				2.999;

global team DEF_E7M1_AI_AREA_CLEANUP_TEAM = 									mule;

global real DEF_E7M1_AI_AREA_PLACE_SCALE_TIME =								1.0;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_areas_init::: Init
script dormant f_e7m1_ai_areas_init()
	//dprint( "f_e7m1_ai_areas_init" );

	// allign teams to retreat team
	ai_allegiance( covenant, DEF_E7M1_AI_AREA_CLEANUP_TEAM );
	ai_allegiance( DEF_E7M1_AI_AREA_CLEANUP_TEAM, covenant );

	ai_allegiance( forerunner, DEF_E7M1_AI_AREA_CLEANUP_TEAM );
	ai_allegiance( DEF_E7M1_AI_AREA_CLEANUP_TEAM, forerunner );
	spops_ai_garbage_delay_unit_default(10);
	spops_ai_garbage_delay_squad_default(10);
	// setup areas
	wake( f_e7m1_area_1A_place_trigger );
	wake( f_e7m1_area_2A_place_trigger );
	wake( f_e7m1_area_2B_place_trigger );
	wake( f_e7m1_area_2C_place_trigger );
	wake( f_e7m1_area_2D_place_trigger );
	wake( f_e7m1_area_3A_place_trigger );
	wake( f_e7m1_area_3B_place_trigger );
	wake( f_e7m1_area_3C_place_trigger );
	wake( f_e7m1_area_4A_place_trigger );
	wake( f_e7m1_area_4B_place_trigger );
	wake( f_e7m1_area_4C_place_trigger );
	wake( f_e7m1_area_4D_place_trigger );
	wake( f_e7m1_area_4E_place_trigger );
	wake( f_e7m1_area_4F_place_trigger );
	wake( f_e7m1_area_5A_place_trigger );
	wake( f_e7m1_area_5B_place_trigger );
	wake( f_e7m1_area_5C_place_trigger );
	wake( f_e7m1_area_6A_place_trigger );
	wake( f_e7m1_area_6B_place_trigger );
	wake( f_e7m1_area_6C_place_trigger );
	wake( f_e7m1_area_7A_place_trigger );
	wake( f_e7m1_area_7B_place_trigger );
	wake( f_e7m1_area_7C_place_trigger );
	wake( f_e7m1_area_8A_place_trigger );

end

// === f_e7m1_ai_area_move_update_cnt::: XXX
script static short f_e7m1_ai_area_move_update_cnt( ai ai_move, short s_cnt )
	//dprint( "f_e7m1_ai_area_move_update_cnt" );
	//inspect( s_cnt );

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
	//inspect( s_cnt );
	s_cnt;
end

// === f_e7m1_ai_area_set_objective::: Sets the objective for an ai to move to an area
script static void f_e7m1_ai_area_objective_set( ai ai_move, string_id sid_objective )
	
	ai_set_objective( ai_get_squad_safe(ai_move), sid_objective );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: OVERFLOW ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_area_overflow_from::: General overflow from function
script static void f_e7m1_ai_area_overflow_from( ai ai_move, string_id sid_objective )

	//if ( ai_get_objective(ai_move) == sid_objective ) then
		//dprint( "f_e7m1_ai_area_overflow_from" );
	//end

end

// === f_e7m1_ai_area_overflow_to::: General overflow from function
script static void f_e7m1_ai_area_overflow_to( ai ai_move, string_id sid_objective )

	//dprint( "f_e7m1_ai_area_overflow_to" );
	f_e7m1_ai_area_objective_set( ai_move, sid_objective );

end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: ADVANCE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_area_advance_from::: General advance from function
script static short f_e7m1_ai_area_advance_from( ai ai_move, string_id sid_objective, sound_event se_area_music, string str_area_debug, sound_event se_level_music, string str_level_debug, short s_cnt )

	if ( ai_get_objective(ai_move) == sid_objective ) then
		//dprint( "f_e7m1_ai_area_advance_from" );
		spops_audio_music_event( se_area_music, str_area_debug );
		spops_audio_music_event( se_level_music, str_level_debug );
		if ( s_cnt >= 0 ) then
			s_cnt = f_e7m1_ai_area_move_update_cnt( ai_move, s_cnt );
			if ( s_cnt < 0 ) then
				s_cnt = 0;
			end
		end
	end
	
	// return
	s_cnt;
end
script static short f_e7m1_ai_area_advance_from( ai ai_move, string_id sid_objective, sound_event se_area_music, string str_area_debug, sound_event se_level_music, string str_level_debug )
	f_e7m1_ai_area_advance_from( ai_move, sid_objective, se_area_music, str_area_debug, se_level_music, str_level_debug, 0 );
end

// === f_e7m1_ai_area_advance_to::: General advance to function
script static short f_e7m1_ai_area_advance_to( ai ai_move, string_id sid_objective, short s_cnt )

	if ( ai_get_objective(ai_move) != sid_objective ) then
		//dprint( "f_e7m1_ai_area_advance_to" );
	
		// get count adjustment
		s_cnt = f_e7m1_ai_area_move_update_cnt( ai_get_squad_safe(ai_move), s_cnt );

		// set objective again
		f_e7m1_ai_area_objective_set( ai_move, sid_objective );

	end

	// return
	s_cnt;
end
script static short f_e7m1_ai_area_advance_to( ai ai_move, string_id sid_objective )
	f_e7m1_ai_area_advance_to( ai_move, sid_objective, 0 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: RETREAT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_area_retreat_from::: General retreat from function
script static short f_e7m1_ai_area_retreat_from( ai ai_move, string_id sid_objective, sound_event se_area_music, string str_area_debug, sound_event se_level_music, string str_level_debug, short s_cnt )

	if ( ai_get_objective(ai_move) == sid_objective ) then
		//dprint( "f_e7m1_ai_area_retreat_from" );
		s_cnt = f_e7m1_ai_area_move_update_cnt( ai_move, s_cnt );
		spops_audio_music_event( se_area_music, str_area_debug );
		spops_audio_music_event( se_level_music, str_level_debug );
	end
	
	// return
	s_cnt;

end
script static short f_e7m1_ai_area_retreat_from( ai ai_move, string_id sid_objective, sound_event se_area_music, string str_area_debug, sound_event se_level_music, string str_level_debug )
	f_e7m1_ai_area_retreat_from( ai_move, sid_objective, se_area_music, str_area_debug, se_level_music, str_level_debug, 0 );
end

// === f_e7m1_ai_area_retreat_to::: General retreat to function
script static short f_e7m1_ai_area_retreat_to( ai ai_move, string_id sid_objective, short s_cnt )

	if ( ai_get_objective(ai_move) != sid_objective ) then
		//dprint( "f_e7m1_ai_area_retreat_to" );
	
		// get count adjustment
		s_cnt = f_e7m1_ai_area_move_update_cnt( ai_get_squad_safe(ai_move), s_cnt );

		// set objective
		f_e7m1_ai_area_objective_set( ai_move, sid_objective );

	end

	// return
	s_cnt;
end
script static short f_e7m1_ai_area_retreat_to( ai ai_move, string_id sid_objective )
	f_e7m1_ai_area_retreat_to( ai_move, sid_objective, 0 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: CLEANUP ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e7m1_ai_area_cleanup()
local ai ai_squad = ai_get_squad( ai_current_actor );

	if ( ai_living_count(ai_squad) <= 0 ) then
		ai_squad = ai_current_actor;
	end

	spops_ai_garbage_erase( ai_squad );
	ai_vehicle_exit( ai_squad );
	ai_set_team( ai_squad, DEF_E7M1_AI_AREA_CLEANUP_TEAM );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: AREAS: 8A ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean f_e7m1_ai_area_8a_zone_open( trigger_volume tv_zone, ai ai_zone_task )
	( ai_task_count(ai_zone_task) >= volume_count_players(tv_zone) ) or (ai_task_count(objectives_e7m1_area_8a.enemy_combat_location_x_gate) >= 10);
end

script static short volume_count_players( trigger_volume tv_volume )
local short s_cnt = 0;

	if ( volume_test_object(tv_volume,player0) ) then s_cnt = s_cnt + 1;	end
	if ( volume_test_object(tv_volume,player1) ) then s_cnt = s_cnt + 1;	end
	if ( volume_test_object(tv_volume,player2) ) then s_cnt = s_cnt + 1;	end
	if ( volume_test_object(tv_volume,player3) ) then s_cnt = s_cnt + 1;	end

	// return
	s_cnt;
end
