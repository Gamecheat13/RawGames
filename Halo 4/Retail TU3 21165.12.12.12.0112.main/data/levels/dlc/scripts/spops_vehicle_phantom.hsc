//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_turrets_occupied_cnt::: Counts the number of occupied turrets on a phantom
// XXX document params
script static short spops_phantom_turrets_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	s_cnt = 0;
	if ( object_at_marker(vh_phantom,"chin_gun") != NONE ) then
		s_cnt = s_cnt + 1;
	end
	if ( (object_at_marker(vh_phantom,"turret_l") != NONE) and vehicle_test_seat(vehicle(object_at_marker(vh_phantom,"turret_l")),"") ) then
		s_cnt = s_cnt + 1;
	end
	if ( (object_at_marker(vh_phantom,"turret_r") != NONE) and vehicle_test_seat(vehicle(object_at_marker(vh_phantom,"turret_r")),"") ) then
		s_cnt = s_cnt + 1;
	end

	s_cnt;
end

script static void spops_phantom_destroy( object obj_phantom )

	if ( obj_phantom != NONE ) then
	
		damage_object( obj_phantom, "engine_right", 10000.0 );
		damage_object( obj_phantom, "engine_left", 10000.0 );
		damage_object( obj_phantom, "hull", 10000.0 );
		
	end
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: SEATS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: SEATS: CNT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_seat_cnt::: XXX
// XXX document params
script static short spops_phantom_locs_cnt( boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute, boolean b_cargo_small, boolean b_cargo_large )
static short s_cnt = 0;

	s_cnt = 0;

	// front
	if ( b_front_left ) then
		s_cnt = s_cnt + 4;
	end
	if ( b_front_right ) then
		s_cnt = s_cnt + 4;
	end

	// back
	if ( b_back_left ) then
		s_cnt = s_cnt + 4;
	end
	if ( b_back_right ) then
		s_cnt = s_cnt + 4;
	end

	// mid
	if ( b_mid_left ) then
		s_cnt = s_cnt + 4;
	end
	if ( b_mid_right ) then
		s_cnt = s_cnt + 4;
	end
	
	// chute
	if ( b_chute ) then
		s_cnt = s_cnt + 4;
	end

	// cargo
	if ( b_cargo_small ) then
		s_cnt = s_cnt + 2;
	end
	if ( b_cargo_large ) then
		s_cnt = s_cnt + 1;
	end

	// return
	s_cnt;

end
script static short spops_phantom_seat_cnt()
static short s_cnt = spops_phantom_locs_cnt( TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE );
	s_cnt;
end
script static short spops_phantom_cargo_cnt()
static short s_cnt = spops_phantom_locs_cnt( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE );
	s_cnt;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: SEATS: OCCUPIED ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_occupied_cnt::: XXX
// XXX document params
script static boolean spops_phantom_occupied( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute, boolean b_cargo_small, boolean b_cargo_large )
	spops_phantom_seat_occupied( vh_phantom, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute ) or
	spops_phantom_cargo_occupied( vh_phantom, b_cargo_small, b_cargo_large );
end
script static boolean spops_phantom_occupied( vehicle vh_phantom )
	spops_phantom_seat_occupied( vh_phantom ) or
	spops_phantom_cargo_occupied( vh_phantom );
end

// === spops_phantom_seat_occupied::: XXX
// XXX document params
script static boolean spops_phantom_seat_occupied( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute )
	( b_front_left and (vehicle_test_seat(vh_phantom, "phantom_p_lf_")) ) or
	( b_front_right and (vehicle_test_seat(vh_phantom, "phantom_p_rf_")) ) or
	( b_back_left and (vehicle_test_seat(vh_phantom, "phantom_p_lb_")) ) or
	( b_back_right and (vehicle_test_seat(vh_phantom, "phantom_p_rb_")) ) or
	( b_mid_left and (vehicle_test_seat(vh_phantom, "phantom_p_ml_")) ) or
	( b_mid_right and (vehicle_test_seat(vh_phantom, "phantom_p_mr_")) ) or
	( b_chute and (vehicle_test_seat(vh_phantom, "phantom_pc_")) );
end
script static boolean spops_phantom_seat_occupied( vehicle vh_phantom )
	( vehicle_test_seat(vh_phantom, "phantom_p_") ) or
	( vehicle_test_seat(vh_phantom, "phantom_pc_") );
end

// === spops_phantom_cargo_occupied::: XXX
// XXX document params
script static boolean spops_phantom_cargo_occupied( vehicle vh_phantom, boolean b_cargo_small, boolean b_cargo_large )
	( b_cargo_small and spops_phantom_cargo_small_occupied(vh_phantom) ) or
	( b_cargo_large and spops_phantom_cargo_large_occupied(vh_phantom) );
end
script static boolean spops_phantom_cargo_occupied( vehicle vh_phantom )
	spops_phantom_cargo_occupied( vh_phantom, TRUE, TRUE );
end

// === spops_phantom_cargo_small_occupied::: XXX
// XXX document params
script static boolean spops_phantom_cargo_small_occupied( vehicle vh_phantom )
	( (object_at_marker(vh_phantom, "small_cargo01") != NONE) or (object_at_marker(vh_phantom, "small_cargo02") != NONE) );
end

// === spops_phantom_cargo_large_occupied::: XXX
// XXX document params
script static boolean spops_phantom_cargo_large_occupied( vehicle vh_phantom )
	( object_at_marker(vh_phantom, "large_cargo") != NONE );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: SEATS: OCCUPIED: CNT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_occupied_cnt( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute, boolean b_cargo_small, boolean b_cargo_large )
	spops_phantom_seat_occupied_cnt( vh_phantom, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute ) +
	spops_phantom_cargo_occupied_cnt( vh_phantom, b_cargo_small, b_cargo_large );
end
script static short spops_phantom_occupied_cnt( vehicle vh_phantom )
	spops_phantom_seat_occupied_cnt( vh_phantom ) + spops_phantom_cargo_occupied_cnt( vh_phantom );
end

// === spops_phantom_seat_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_occupied_cnt( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p") ) then
		s_cnt = 0;

		if ( vehicle_test_seat(vh_phantom, "phantom_p_") ) then
		
			if ( b_front_left and vehicle_test_seat(vh_phantom, "phantom_p_lf_") ) then
				s_cnt = s_cnt + spops_phantom_seat_front_left_occupied_cnt( vh_phantom );
			end
			if ( b_front_right ) then
				s_cnt = s_cnt + spops_phantom_seat_front_right_occupied_cnt( vh_phantom );
			end
		
			if ( b_back_left ) then
				s_cnt = s_cnt + spops_phantom_seat_back_left_occupied_cnt( vh_phantom );
			end
			if ( b_back_right ) then
				s_cnt = s_cnt + spops_phantom_seat_back_right_occupied_cnt( vh_phantom );
			end
		
			if ( b_mid_left ) then
				s_cnt = s_cnt + spops_phantom_seat_mid_left_occupied_cnt( vh_phantom );
			end
			if ( b_mid_right ) then
				s_cnt = s_cnt + spops_phantom_seat_mid_right_occupied_cnt( vh_phantom );
			end
			
		end
			
		if ( b_chute ) then
			s_cnt = s_cnt + spops_phantom_seat_chute_occupied_cnt( vh_phantom );
		end
	
		// return
		s_cnt;
	else
		0;
	end

end
script static short spops_phantom_seat_occupied_cnt( vehicle vh_phantom )
static short s_cnt_all = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p") ) then
		s_cnt_all = 0;

		if ( vehicle_test_seat(vh_phantom, "phantom_p_") ) then
			s_cnt_all = s_cnt_all + spops_phantom_seat_front_left_occupied_cnt( vh_phantom ) + 
															spops_phantom_seat_front_right_occupied_cnt( vh_phantom ) + 
															spops_phantom_seat_back_left_occupied_cnt( vh_phantom ) + 
															spops_phantom_seat_back_right_occupied_cnt( vh_phantom ) + 
															spops_phantom_seat_mid_left_occupied_cnt( vh_phantom ) + 
															spops_phantom_seat_mid_right_occupied_cnt( vh_phantom );
		end
		s_cnt_all = s_cnt_all + spops_phantom_seat_chute_occupied_cnt( vh_phantom );
	
		// return
		s_cnt_all;
	else
		0;
	end

end

// === spops_phantom_seat_front_left_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_front_left_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_") ) then
		s_cnt = 0;
		
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;
	end

end

// === spops_phantom_seat_front_right_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_front_right_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_") ) then
		s_cnt = 0;
	
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end

end

// === spops_phantom_seat_back_left_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_back_left_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_") ) then
		s_cnt = 0;
		
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end

end

// === spops_phantom_seat_back_right_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_back_right_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_") ) then
		s_cnt = 0;
		
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end

end

// === spops_phantom_seat_mid_left_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_mid_left_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_") ) then
		s_cnt = 0;
		
		if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end

end

// === spops_phantom_seat_mid_right_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_mid_right_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_") ) then
		s_cnt = 0;
		
		if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_main") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_3") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end

end

// === spops_phantom_seat_chute_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_chute_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	if ( vehicle_test_seat(vh_phantom, "phantom_pc_") ) then
		s_cnt = 0;
	
		if ( vehicle_test_seat(vh_phantom, "phantom_pc_1") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_pc_2") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_pc_3") ) then
			s_cnt = s_cnt + 1;
		end
		if ( vehicle_test_seat(vh_phantom, "phantom_pc_4") ) then
			s_cnt = s_cnt + 1;
		end

		// return
		s_cnt;
	else
		0;	
	end
	
end

// === spops_phantom_cargo_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_cargo_occupied_cnt( vehicle vh_phantom, boolean b_cargo_small, boolean b_cargo_large )
static short s_cnt = 0;

	s_cnt = 0;
	if ( b_cargo_small ) then
		s_cnt = s_cnt + spops_phantom_cargo_small_occupied_cnt( vh_phantom );
	end
	if ( b_cargo_large ) then
		s_cnt = s_cnt + spops_phantom_cargo_large_occupied_cnt( vh_phantom );
	end

	// return
	s_cnt;
end
script static short spops_phantom_cargo_occupied_cnt( vehicle vh_phantom )
	spops_phantom_cargo_small_occupied_cnt( vh_phantom ) + 
	spops_phantom_cargo_large_occupied_cnt( vh_phantom );
end

// === spops_phantom_cargo_small_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_cargo_small_occupied_cnt( vehicle vh_phantom )
static short s_cnt = 0;

	s_cnt = 0;
	if ( object_at_marker(vh_phantom, "small_cargo01") != NONE ) then
		s_cnt = s_cnt + 1;
	end
	if ( object_at_marker(vh_phantom, "small_cargo02") != NONE ) then
		s_cnt = s_cnt + 1;
	end

	// return
	s_cnt;
end

// === spops_phantom_cargo_large_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_cargo_large_occupied_cnt( vehicle vh_phantom )
	if ( object_at_marker(vh_phantom, "large_cargo") != NONE ) then
		1;
	else
		0;
	end
end

// === spops_phantom_occupied_cnt_check::: XXX
// XXX document params
script static boolean spops_phantom_occupied_cnt_check( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
static short s_cnt = 0;
	s_cnt = spops_phantom_occupied_cnt( vh_phantom );
	(
		( (s_min < 0)	or (s_cnt >= s_min) )
		and
		(	(s_max < 0)	or (s_cnt <= s_max) )
	) == b_condition;
end

// === spops_phantom_occupied_cnt_wait::: XXX
// XXX document params
script static boolean spops_phantom_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition, short s_delay )
	sleep_until( spops_phantom_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), s_delay );
end
script static boolean spops_phantom_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
	sleep_until( spops_phantom_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), 1 );
end

// === spops_phantom_seat_occupied_cnt_check::: XXX
// XXX document params
script static boolean spops_phantom_seat_occupied_cnt_check( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
static short s_cnt = 0;
	s_cnt = spops_phantom_seat_occupied_cnt( vh_phantom );
	(
		( (s_min < 0)	or (s_cnt >= s_min) )
		and
		(	(s_max < 0)	or (s_cnt <= s_max) )
	) == b_condition;
end

// === spops_phantom_occupied_cnt_wait::: XXX
// XXX document params
script static boolean spops_phantom_seat_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition, short s_delay )
	sleep_until( spops_phantom_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), s_delay );
end
script static boolean spops_phantom_seat_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
	sleep_until( spops_phantom_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), 1 );
end

// === spops_phantom_cargo_occupied_cnt_check::: XXX
// XXX document params
script static boolean spops_phantom_cargo_occupied_cnt_check( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
static short s_cnt = 0;
	s_cnt = spops_phantom_cargo_occupied_cnt( vh_phantom );
	(
		( (s_min < 0)	or (s_cnt >= s_min) )
		and
		(	(s_max < 0)	or (s_cnt <= s_max) )
	) == b_condition;
end

// === spops_phantom_cargo_occupied_cnt_wait::: XXX
// XXX document params
script static boolean spops_phantom_cargo_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition, short s_delay )
	sleep_until( spops_phantom_cargo_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), s_delay );
end
script static boolean spops_phantom_cargo_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
	sleep_until( spops_phantom_cargo_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), 1 );
end

// === spops_phantom_cargo_small_occupied_cnt_check::: XXX
// XXX document params
script static boolean spops_phantom_cargo_small_occupied_cnt_check( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
static short s_cnt = 0;
	s_cnt = spops_phantom_cargo_small_occupied_cnt( vh_phantom );
	(
		( (s_min < 0)	or (s_cnt >= s_min) )
		and
		(	(s_max < 0)	or (s_cnt <= s_max) )
	) == b_condition;
end

// === spops_phantom_cargo_small_occupied_cnt_wait::: XXX
// XXX document params
script static boolean spops_phantom_cargo_small_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition, short s_delay )
	sleep_until( spops_phantom_cargo_small_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), s_delay );
end
script static boolean spops_phantom_cargo_small_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
	sleep_until( spops_phantom_cargo_small_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), 1 );
end

// === spops_phantom_cargo_large_occupied_cnt_check::: XXX
// XXX document params
script static boolean spops_phantom_cargo_large_occupied_cnt_check( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
static short s_cnt = 0;
	s_cnt = spops_phantom_cargo_large_occupied_cnt( vh_phantom );
	(
		( (s_min < 0)	or (s_cnt >= s_min) )
		and
		(	(s_max < 0)	or (s_cnt <= s_max) )
	) == b_condition;
end

// === spops_phantom_cargo_large_occupied_cnt_wait::: XXX
// XXX document params
script static boolean spops_phantom_cargo_large_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition, short s_delay )
	sleep_until( spops_phantom_cargo_large_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), s_delay );
end
script static boolean spops_phantom_cargo_large_occupied_cnt_wait( vehicle vh_phantom, short s_min, short s_max, boolean b_condition )
	sleep_until( spops_phantom_cargo_large_occupied_cnt_check(vh_phantom, s_min, s_max, b_condition), 1 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: LOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_load_ai::: XXX
// XXX document params
script static short spops_phantom_load_ai( vehicle vh_phantom, ai ai_squad, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute, boolean b_cargo_small, boolean b_cargo_large )
static short s_cnt = 0;

	if ( (vh_phantom != NONE) and (ai_squad != NONE) ) then
		static boolean b_placed = FALSE;

		s_cnt = 0;
		// place if not placed
		b_placed = FALSE;
		if ( ai_living_count(ai_squad) <= 0 ) then
			dprint( "spops_phantom_load_ai: PLACE" );
			ai_place_in_limbo( ai_squad );
			b_placed = TRUE;
		end

		// get a list of the actors
		local object_list ol_actors = ai_actors( ai_squad );
		s_cnt = list_count( ol_actors );
		local short s_index = s_cnt - 1;

		// main
		if ( (s_index >= 0) and b_front_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lf_main") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_front_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rf_main") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lb_main") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rb_main") ) then
			s_index = s_index - 1;
		end
		
		// 1
		if ( (s_index >= 0) and b_front_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lf_small_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_front_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rf_small_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lb_small_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rb_small_1") ) then
			s_index = s_index - 1;
		end
		
		// 2
		if ( (s_index >= 0) and b_front_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lf_small_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_front_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rf_small_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lb_small_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rb_small_2") ) then
			s_index = s_index - 1;
		end
			
		// 3
		if ( (s_index >= 0) and b_front_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lf_small_3") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_front_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rf_small_3") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_lb_small_3") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_back_right and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_rb_small_3") ) then
			s_index = s_index - 1;
		end
	
		// mid
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_ml_f_main") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_mr_f_main") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_ml_f_small_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_mr_f_small_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_ml_f_small_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_mr_f_small_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_ml_f_small_3") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_mid_left and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_p_mr_f_small_3") ) then
			s_index = s_index - 1;
		end
		
		// chute
		if ( (s_index >= 0) and b_chute and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_pc_1") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_chute and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_pc_2") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_chute and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_pc_3") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_chute and spops_vehicle_load_seat(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "phantom_pc_4") ) then
			s_index = s_index - 1;
		end

		// cargo small
		if ( (s_index >= 0) and b_cargo_small and spops_vehicle_load_marker(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "small_cargo01") ) then
			s_index = s_index - 1;
		end
		if ( (s_index >= 0) and b_cargo_small and spops_vehicle_load_marker(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "small_cargo02") ) then
			s_index = s_index - 1;
		end

		// cargo large
		if ( (s_index >= 0) and b_cargo_large and spops_vehicle_load_marker(vh_phantom, object_get_ai(list_get(ol_actors, s_index)), "large_cargo") ) then
			s_index = s_index - 1;
		end
	
		// check if any need to be cleaned up
		if ( b_placed and (s_index >= 0) ) then

			repeat

				ai_erase( object_get_ai(list_get(ol_actors, s_index)) );
				s_index = s_index - 1;
				s_cnt = s_cnt - 1;
				
			until( s_index < 0, 1 );

		end
	
	end

	// return
	s_cnt;
end

script static short spops_phantom_load_ai( vehicle vh_phantom, ai ai_squad )
	spops_phantom_load_ai( vh_phantom, ai_squad, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE );
end

script static short spops_phantom_load_ai_chute( vehicle vh_phantom, ai ai_squad )
	spops_phantom_load_ai( vh_phantom, ai_squad, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE );
end

script static short spops_phantom_load_ai_cargo( vehicle vh_phantom, ai ai_squad )
	spops_phantom_load_ai( vh_phantom, ai_squad, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE );
end
script static short spops_phantom_load_ai_cargo_small( vehicle vh_phantom, ai ai_squad )
	spops_phantom_load_ai( vh_phantom, ai_squad, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE );
end
script static short spops_phantom_load_ai_cargo_large( vehicle vh_phantom, ai ai_squad )
	spops_phantom_load_ai( vh_phantom, ai_squad, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE );
end

// === spops_phantom_load_cargo_large::: XXX
// XXX document params
script static boolean spops_phantom_load_cargo_large( vehicle vh_phantom, object obj_load )
	spops_vehicle_load_marker( vh_phantom, obj_load, "large_cargo" );
end

// === spops_phantom_load_cargo_small::: XXX
// XXX document params
script static boolean spops_phantom_load_cargo_small( vehicle vh_phantom, object obj_load )
static boolean b_loaded = FALSE;

	b_loaded = (not b_loaded) and spops_vehicle_load_marker( vh_phantom, obj_load, "small_cargo01" );
	b_loaded = (not b_loaded) and spops_vehicle_load_marker( vh_phantom, obj_load, "small_cargo02" );
	
	// return
	b_loaded;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: UNLOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global long DEF_VAR_INDEX_L_PHANTOM_DOORS = 										1;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_phantom_unload_door_open_delay = 						2.0;
static real R_spops_phantom_unload_door_close_delay = 					0.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_unload::: XXX
// XXX document params
script static void spops_phantom_unload( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute, boolean b_cargo_small, boolean b_cargo_large )
local long l_thread_seat = thread( spops_phantom_unload_seat(vh_phantom, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute) );
local long l_thread_cargo = thread( spops_phantom_unload_cargo(vh_phantom, b_cargo_small, b_cargo_large) );
	sleep_until( (not isthreadvalid(l_thread_seat)) and (not isthreadvalid(l_thread_cargo)), 1 );
end
script static void spops_phantom_unload( vehicle vh_phantom )
	spops_phantom_unload( vh_phantom, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE );
end

// === spops_phantom_unload_seat::: XXX
// XXX document params
script static void spops_phantom_unload_seat( vehicle vh_phantom, boolean b_front_left, boolean b_front_right, boolean b_back_left, boolean b_back_right, boolean b_mid_left, boolean b_mid_right, boolean b_chute )
local long l_thread_front_left = 0;
local long l_thread_front_right = 0;
local long l_thread_back_left = 0;
local long l_thread_back_right = 0;
local long l_thread_mid_left = 0;
local long l_thread_mid_right = 0;
local long l_thread_chute = 0;

	// unload
	if ( b_front_left ) then
		l_thread_front_left = thread( spops_phantom_unload_front_left(vh_phantom) );
	end
	if ( b_front_right ) then
		l_thread_front_right = thread( spops_phantom_unload_front_right(vh_phantom) );
	end
	if ( b_back_left ) then
		l_thread_back_left = thread( spops_phantom_unload_back_left(vh_phantom) );
	end
	if ( b_back_right ) then
		l_thread_back_right = thread( spops_phantom_unload_back_right(vh_phantom) );
	end
	if ( b_mid_left ) then
		l_thread_mid_left = thread( spops_phantom_unload_mid_left(vh_phantom) );
	end
	if ( b_mid_right ) then
		l_thread_mid_right = thread( spops_phantom_unload_mid_right(vh_phantom) );
	end
	if ( b_chute ) then
		l_thread_chute = thread( spops_phantom_unload_chute(vh_phantom) );
	end

	// wait for unload to finish
	sleep_until( 
		( not isthreadvalid(l_thread_front_left) )
		and
		( not isthreadvalid(l_thread_front_right) )
		and
		( not isthreadvalid(l_thread_back_left) )
		and
		( not isthreadvalid(l_thread_back_right) )
		and
		( not isthreadvalid(l_thread_mid_left) )
		and
		( not isthreadvalid(l_thread_mid_right) )
		and
		( not isthreadvalid(l_thread_chute) )
	, 1 );
	
end
script static void spops_phantom_unload_seat( vehicle vh_phantom )
	spops_phantom_unload_seat( vh_phantom, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE );
end

// === spops_phantom_unload_cargo::: XXX
// XXX document params
script static void spops_phantom_unload_cargo( vehicle vh_phantom, boolean b_cargo_small, boolean b_cargo_large )
local long l_thread_small = 0;
local long l_thread_large = 0;
	
	if ( b_cargo_small ) then
		l_thread_small = thread( spops_phantom_unload_cargo_small(vh_phantom) );
	end
	if ( b_cargo_large ) then
		l_thread_large = thread( spops_phantom_unload_cargo_large(vh_phantom) );
	end
	sleep_until( (not isthreadvalid(l_thread_small)) and (not isthreadvalid(l_thread_large)), 1 );
	
end
script static void spops_phantom_unload_cargo( vehicle vh_phantom )
	spops_phantom_unload_cargo( vh_phantom, TRUE, TRUE );
end

// === spops_phantom_unload_front_left::: XXX
// XXX document params
script static void spops_phantom_unload_front_left( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_lf_", r_delay, TRUE );
end
script static void spops_phantom_unload_front_left( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_lf_", R_spops_phantom_unload_front_delay_default, TRUE );
end

// === spops_phantom_unload_front_right::: XXX
// XXX document params
script static void spops_phantom_unload_front_right( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_rf_", r_delay, TRUE );
end
script static void spops_phantom_unload_front_right( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_rf_", R_spops_phantom_unload_front_delay_default, TRUE );
end

// === spops_phantom_unload_back_left::: XXX
// XXX document params
script static void spops_phantom_unload_back_left( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_lb_", r_delay, TRUE );
end
script static void spops_phantom_unload_back_left( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_lb_", R_spops_phantom_unload_back_delay_default, TRUE );
end

// === spops_phantom_unload_back_right::: XXX
// XXX document params
script static void spops_phantom_unload_back_right( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_rb_", r_delay, TRUE );
end
script static void spops_phantom_unload_back_right( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_rb_", R_spops_phantom_unload_back_delay_default, TRUE );
end

// === spops_phantom_unload_mid_left::: XXX
// XXX document params
script static void spops_phantom_unload_mid_left( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_ml_", r_delay, TRUE );
end
script static void spops_phantom_unload_mid_left( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_ml_", R_spops_phantom_unload_mid_delay_default, TRUE );
end

// === spops_phantom_unload_mid_right::: XXX
// XXX document params
script static void spops_phantom_unload_mid_right( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_mr_", r_delay, TRUE );
end
script static void spops_phantom_unload_mid_right( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_p_mr_", R_spops_phantom_unload_mid_delay_default, TRUE );
end

// === spops_phantom_unload_chute::: XXX
// XXX document params
script static void spops_phantom_unload_chute( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_pc_", r_delay, FALSE );
end
script static void spops_phantom_unload_chute( vehicle vh_phantom )
	sys_spops_phantom_unload_seat( vh_phantom, "phantom_pc_", R_spops_phantom_unload_chute_delay_default, FALSE );
end

// === spops_phantom_unload_cargo_small::: XXX
// XXX document params
script static void spops_phantom_unload_cargo_small( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_marker( vh_phantom,  "small_cargo01", r_delay );
	sys_spops_phantom_unload_marker( vh_phantom,  "small_cargo02", r_delay );
end
script static void spops_phantom_unload_cargo_small( vehicle vh_phantom )
	sys_spops_phantom_unload_marker( vh_phantom,  "small_cargo01", R_spops_phantom_unload_cargo_small_delay_default );
	sys_spops_phantom_unload_marker( vh_phantom,  "small_cargo02", R_spops_phantom_unload_cargo_small_delay_default );
end

// === xxx::: XXX
// XXX document params
script static void spops_phantom_unload_cargo_large( vehicle vh_phantom, real r_delay )
	sys_spops_phantom_unload_marker( vh_phantom, "large_cargo", r_delay );
end
script static void spops_phantom_unload_cargo_large( vehicle vh_phantom )
	sys_spops_phantom_unload_marker( vh_phantom, "large_cargo", R_spops_phantom_unload_cargo_large_delay_default );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static boolean sys_spops_phantom_unload_seat( vehicle vh_phantom, unit_seat_mapping usm_seat, real r_delay, boolean b_doors )
local boolean b_unloaded = FALSE;

	if ( vehicle_test_seat(vh_phantom, usm_seat) ) then
		
		// open doors
		if ( b_doors ) then
			sys_spops_phantom_doors_open( vh_phantom, -1.0 );
		end

		// unload the seats
		vehicle_unload( vh_phantom, usm_seat );
		sleep_until( not vehicle_test_seat(vh_phantom, usm_seat) );

		// delay
		sleep_s( r_delay );

		// close doors
		if ( b_doors ) then
			sys_spops_phantom_doors_close( vh_phantom, -1.0 );
		end
	
		b_unloaded = TRUE;
	end

	// return
	b_unloaded;
end

script static boolean sys_spops_phantom_unload_marker( vehicle vh_phantom, string_id sid_marker, real r_delay )
local boolean b_unloaded = FALSE;

	if ( object_at_marker(vh_phantom, sid_marker) != NONE ) then
	
		// unload the marker
		objects_detach( vh_phantom, object_at_marker(vh_phantom, sid_marker) );
		sleep_until( object_at_marker(vh_phantom, sid_marker) == NONE, 1 );

		// delay
		sleep_s( r_delay );
		
		b_unloaded = TRUE;
	end

	// return
	b_unloaded;
end

script static void sys_spops_phantom_doors_open( vehicle vh_phantom, real r_delay )

	SetObjectLongVariable( vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS, GetObjectLongVariable(vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS) + 1 );
	if ( GetObjectLongVariable(vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS) == 1 ) then
		unit_open( vh_phantom );
	end
	
	if ( r_delay < 0.0 ) then
		r_delay = R_spops_phantom_unload_door_open_delay;
	end
	sleep_s( r_delay );

end
script static void sys_spops_phantom_doors_close( vehicle vh_phantom, real r_delay )

	SetObjectLongVariable( vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS, GetObjectLongVariable(vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS) - 1 );
	if ( GetObjectLongVariable(vh_phantom, DEF_VAR_INDEX_L_PHANTOM_DOORS) == 0 ) then
		unit_close( vh_phantom );
	end
	
	if ( r_delay < 0.0 ) then
		r_delay = R_spops_phantom_unload_door_close_delay;
	end
	sleep_s( r_delay );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PHANTOM: UNLOAD: DELAYS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_phantom_unload_front_delay_default = 				0.25;
static real R_spops_phantom_unload_back_delay_default = 				0.25;
static real R_spops_phantom_unload_mid_delay_default = 					0.25;
static real R_spops_phantom_unload_chute_delay_default = 				0.25;
static real R_spops_phantom_unload_cargo_small_delay_default = 	0.50;
static real R_spops_phantom_unload_cargo_large_delay_default = 	1.00;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_phantom_unload_front_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_front_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_front_delay_default ) then

		//dprint( "spops_phantom_unload_front_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_front_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_front_delay_default()
	R_spops_phantom_unload_front_delay_default;
end

// === spops_phantom_unload_back_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_back_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_back_delay_default ) then

		//dprint( "spops_phantom_unload_back_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_back_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_back_delay_default()
	R_spops_phantom_unload_back_delay_default;
end

// === spops_phantom_unload_mid_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_mid_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_mid_delay_default ) then

		//dprint( "spops_phantom_unload_mid_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_mid_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_mid_delay_default()
	R_spops_phantom_unload_mid_delay_default;
end

// === spops_phantom_unload_chute_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_chute_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_chute_delay_default ) then

		//dprint( "spops_phantom_unload_chute_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_chute_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_chute_delay_default()
	R_spops_phantom_unload_chute_delay_default;
end

// === spops_phantom_unload_cargo_small_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_cargo_small_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_cargo_small_delay_default ) then

		//dprint( "spops_phantom_unload_cargo_small_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_cargo_small_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_cargo_small_delay_default()
	R_spops_phantom_unload_cargo_small_delay_default;
end

// === spops_phantom_unload_cargo_large_delay_default::: Gets/sets the default delay
// XXX document params
script static void spops_phantom_unload_cargo_large_delay_default( real r_delay )

	if ( r_delay != R_spops_phantom_unload_cargo_large_delay_default ) then

		//dprint( "spops_phantom_unload_cargo_large_delay_default:" );
		//inspect( r_delay );
		R_spops_phantom_unload_cargo_large_delay_default = r_delay;

	end

end
script static real spops_phantom_unload_cargo_large_delay_default()
	R_spops_phantom_unload_cargo_large_delay_default;
end


/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: PHANTOM ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_phantom::: Places AI based on priority and POPULATIONs
// XXX document params
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, ai ai_parent, short s_parent_limit )
local short s_id = sys_spops_ai_pool_id_get();
local boolean b_priority_sub_distance = ( r_priority < 0.0 );
local ai ai_placed = DEF_SPOPS_AI_GLOBAL_AI_NONE;
local long l_thread_load = 0;

local boolean b_front_left = 	( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "FRONT_LEFT" ) or ( str_type == "FRONT" ) or ( str_type == "LEFT" );
local boolean b_front_right = ( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "FRONT_RIGHT" ) or ( str_type == "FRONT" ) or ( str_type == "RIGHT" );
local boolean b_back_left = 	( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "BACK_LEFT" ) or ( str_type == "BACK" ) or ( str_type == "LEFT" );
local boolean b_back_right = 	( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "BACK_RIGHT" ) or ( str_type == "BACK" ) or ( str_type == "RIGHT" );
local boolean b_mid_left = 		( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "MID_LEFT" ) or ( str_type == "MID" ) or ( str_type == "LEFT" );
local boolean b_mid_right = 	( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "MID_RIGHT" ) or ( str_type == "MID" ) or ( str_type == "RIGHT" );
local boolean b_chute = 			( str_type == "ALL" ) or ( str_type == "SEAT" ) or ( str_type == "CHUTE" );
local boolean b_cargo_small = ( str_type == "ALL" ) or ( str_type == "CARGO" ) or ( str_type == "CARGO_SMALL" );
local boolean b_cargo_large = ( str_type == "ALL" ) or ( str_type == "CARGO" ) or ( str_type == "CARGO_LARGE" );

	// inc pool counter
	sys_spops_ai_pool_place_phantom_cnt_inc( 1 );

	// wait for the all group to be != DEF_SPOPS_AI_GLOBAL_AI_NONE
	if ( ai_ff_all == DEF_SPOPS_AI_GLOBAL_AI_NONE ) then
		sleep_until( ai_ff_all != DEF_SPOPS_AI_GLOBAL_AI_NONE, 1 );
	end
	//dprint( "spops_ai_pool_place_phantom: START" );

	// make sure the priority is possitive
	r_priority = abs_r( r_priority );

	repeat

		if ( S_spops_ai_pool_queue_request_id == s_id ) then
			//dprint( "spops_ai_pool_place_phantom: MATCH" );

			// reset request
			sys_spops_ai_pool_queue_request_reset();

			if ( (AI_spops_ai_pool_queue_claimed_place != DEF_SPOPS_AI_GLOBAL_AI_RESET) and spops_ai_pool_place_phantom_population_limit_check(S_spops_ai_pool_queue_claimed_cost) ) then
				//dprint( "spops_ai_pool_place_phantom: SUCCESS" );
				//inspect( s_id );
				//inspect( S_spops_ai_pool_queue_claimed_id );
	
				// notify placed				
				NotifyLevel( DEF_SPOPS_AI_POOL_NOTIFY_PLACED );
				
				// weight
				//dprint( "spops_ai_pool_place_phantom: WEIGHT" );
				//inspect( R_spops_ai_pool_queue_claimed_weight );
				if ( r_weight_place > 0.0 ) then
					r_weight_place = r_weight_place - R_spops_ai_pool_queue_claimed_weight;
					if ( r_weight_place < 0.0 ) then
						r_weight_place = 0.0;
					end
				end
				//inspect( r_weight_place );

				// grab the ai to place
				//dprint( "spops_ai_pool_place_phantom: AI" );
				ai_placed = AI_spops_ai_pool_queue_claimed_place;

				// set the current id as placed
				//dprint( "spops_ai_pool_place_phantom: PLACED ID" );
				sys_spops_ai_pool_queue_placed_id( S_spops_ai_pool_queue_claimed_id );
				
				// pre-place the ai
				//dprint( "spops_ai_pool_place_phantom: PLACE PRE" );
				sys_spops_ai_place_pre( ai_placed, 1.0, 0.0 );

				// set objective
				if ( sid_objective != NONE ) then
					//dprint( "spops_ai_pool_place_phantom: OBJECTIVE" );
					ai_set_objective( ai_get_squad_safe(ai_placed), sid_objective );
				end

				l_thread_load = 0;
				// place in phantom
				l_thread_load = thread( spops_phantom_load_ai(vh_phantom, ai_placed, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute, b_cargo_small, b_cargo_large) );
				sleep_until( not isthreadvalid(l_thread_load), 1 );
			
			else

				//dprint( "spops_ai_pool_place_phantom: FAIL" );
				sys_spops_ai_pool_queue_request_fail_wait( l_thread );
				//dprint( "spops_ai_pool_place_phantom: FAIL: COMPLETE" );
			
			end
		
		end

		// wait
		//dprint( "spops_ai_pool_place_phantom: WATCH" );
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
						( spops_ai_population() < spops_ai_pool_place_phantom_population_limit() )
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
										( objects_distance_to_object(Players(), vh_phantom) < R_spops_ai_pool_queue_request_distance )
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
						and
						(
							( ai_parent == DEF_SPOPS_AI_GLOBAL_AI_NONE )
							or
							( s_parent_limit < 0 )
							or
							( greater_l(ai_task_count(ai_parent), ai_living_count(ai_parent)) < s_parent_limit )
						)
					)
					or
					sys_spops_ai_pool_queue_request_fail_check()
				)
			)
		, 1 );

		// place check
		if ( isthreadvalid(l_thread) and (r_weight_place != 0.0) ) then
		
			//dprint( "spops_ai_pool_place_phantom: SET" );
			//inspect( s_id );
			sys_spops_ai_pool_queue_request_set( s_id, r_priority, objects_distance_to_object(Players(), vh_phantom), r_pool_index_min, r_pool_index_max, spops_ai_pool_place_phantom_population_limit() );

		end

	until( (r_weight_place == 0.0) or (not isthreadvalid(l_thread)), 1 );
	//dprint( "spops_ai_pool_place_phantom: EXIT" );
	
	// decrement active cnt
	sys_spops_ai_pool_place_phantom_cnt_inc( -1 );
	
	// returns the last spawned dude
	ai_placed;

end
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "ALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "ALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "ALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "ALL", r_priority, r_weight_place, r_pool_index, r_pool_index, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end

script static ai spops_ai_pool_place_phantom_seat( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, ai ai_parent, short s_parent_limit )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "SEAT", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, ai_parent, s_parent_limit );
end
script static ai spops_ai_pool_place_phantom_seat( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "SEAT", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_seat( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "SEAT", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_seat( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "SEAT", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_seat( long l_thread, vehicle vh_phantom, string str_type, real r_priority, real r_weight_place, real r_pool_index )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "SEAT", r_priority, r_weight_place, r_pool_index, r_pool_index, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end

script static ai spops_ai_pool_place_phantom_cargo_small( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, ai ai_parent, short s_parent_limit )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_SMALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, ai_parent, s_parent_limit );
end
script static ai spops_ai_pool_place_phantom_cargo_small( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_SMALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_small( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_SMALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_small( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_SMALL", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_small( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_SMALL", r_priority, r_weight_place, r_pool_index, r_pool_index, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end

script static ai spops_ai_pool_place_phantom_cargo_large( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective, ai ai_parent, short s_parent_limit )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_LARGE", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, ai_parent, s_parent_limit );
end
script static ai spops_ai_pool_place_phantom_cargo_large( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance, string_id sid_objective )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_LARGE", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, sid_objective, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_large( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max, real r_chance )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_LARGE", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, r_chance, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_large( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index_min, real r_pool_index_max )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_LARGE", r_priority, r_weight_place, r_pool_index_min, r_pool_index_max, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end
script static ai spops_ai_pool_place_phantom_cargo_large( long l_thread, vehicle vh_phantom, real r_priority, real r_weight_place, real r_pool_index )
	spops_ai_pool_place_phantom( l_thread, vh_phantom, "CARGO_LARGE", r_priority, r_weight_place, r_pool_index, r_pool_index, 100.0, NONE, DEF_SPOPS_AI_GLOBAL_AI_NONE, -1 );
end

// === spops_ai_pool_place_phantom_cnt::: Returns the count of active spawn pools
// XXX document params
script static short spops_ai_pool_place_phantom_cnt()
	S_spops_ai_pool_place_phantom_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_ai_pool_place_phantom_cnt( short s_cnt )

	if ( S_spops_ai_pool_place_phantom_cnt != s_cnt ) then
		//dprint( "sys_spops_ai_pool_place_phantom_cnt:" );
		S_spops_ai_pool_place_phantom_cnt = s_cnt;
		//inspect( S_spops_ai_pool_place_phantom_cnt );
	end

end
script static void sys_spops_ai_pool_place_phantom_cnt_inc( short s_inc )
	sys_spops_ai_pool_place_phantom_cnt( spops_ai_pool_place_phantom_cnt() + s_inc );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: phantom: POPULATION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short 		S_spops_ai_pool_place_phantom_population_limit = 						20;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_phantom_population_limit::: Set/Get the POPULATION
// XXX document params
script static void spops_ai_pool_place_phantom_population_limit( short s_limit )

	if ( s_limit != S_spops_ai_pool_place_phantom_population_limit ) then
		//dprint( "spops_ai_pool_place_phantom_population_limit:" );
		//inspect( s_limit );
		S_spops_ai_pool_place_phantom_population_limit = s_limit;
		//if ( s_limit > 20 ) then
		//	//dprint( "spops_ai_pool_place_phantom_population_limit: WARNING!!! POPULATION set over 20, not reccomended" );
		//end
	end

end
script static short spops_ai_pool_place_phantom_population_limit()
local short s_limit = S_spops_ai_pool_place_phantom_population_limit;

	// make sure contained by main population limit
	if ( s_limit > S_spops_ai_population_limit ) then
		s_limit = S_spops_ai_population_limit;
	end
	
	// make sure limit is contained by pool limit
	if ( s_limit > spops_ai_pool_population_limit() ) then
		s_limit = spops_ai_pool_population_limit();
	end
	
	// return
	s_limit;
end

// === spops_ai_pool_place_phantom_population_limit_check::: XXX
script static boolean spops_ai_pool_place_phantom_population_limit_check( short s_cnt )
	( spops_ai_population() + s_cnt ) <= spops_ai_pool_place_phantom_population_limit();
end
*/



/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AI: POOL: PLACE: phantom: PRIORITY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_ai_pool_place_phantom_priority_range_min =					-1.0;
static real R_spops_ai_pool_place_phantom_priority_range_max =					-1.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_ai_pool_place_phantom_priority_range::: Sets the safe priority range_min and max
// XXX document params
script static void spops_ai_pool_place_phantom_priority_range( real r_priority_min, real r_priority_max )
	spops_ai_pool_place_phantom_priority_range_min( r_priority_min );
	spops_ai_pool_place_phantom_priority_range_max( r_priority_max );
end

// === spops_ai_pool_place_phantom_priority_range_min::: Sets/Gets the safe priority range_min
// XXX document params
script static void spops_ai_pool_place_phantom_priority_range_min( real r_val )

	if ( R_spops_ai_pool_place_phantom_priority_range_min != r_val ) then
		R_spops_ai_pool_place_phantom_priority_range_min = r_val;
	end

end
script static real spops_ai_pool_place_phantom_priority_range_min()
	R_spops_ai_pool_place_phantom_priority_range_min;
end

// === spops_ai_pool_place_phantom_priority_range_max::: Sets/Gets the safe priority range_max
// XXX document params
script static void spops_ai_pool_place_phantom_priority_range_max( real r_val )

	if ( R_spops_ai_pool_place_phantom_priority_range_max != r_val ) then
		R_spops_ai_pool_place_phantom_priority_range_max = r_val;
	end

end
script static real spops_ai_pool_place_phantom_priority_range_max()
	R_spops_ai_pool_place_phantom_priority_range_max;
end

// === spops_ai_pool_place_phantom_priority_range_check::: Checks if a priority value is within the priority ranges
// XXX document params
script static boolean spops_ai_pool_place_phantom_priority_range_check( real r_priority )
	(
		( R_spops_ai_pool_place_phantom_priority_range_min < 0.0 )
		or
		( r_priority >= R_spops_ai_pool_place_phantom_priority_range_min )
	)
	and
	(
		( R_spops_ai_pool_place_phantom_priority_range_max < 0.0 )
		or
		( r_priority <= R_spops_ai_pool_place_phantom_priority_range_max )
	);
end
*/



/*
// === spops_phantom_type_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_type_occupied_cnt( vehicle vh_phantom, string str_type )
static string str_type_last = "";
static boolean b_front_left = FALSE;
static boolean b_front_right = FALSE;
static boolean b_back_left = FALSE;
static boolean b_back_right = FALSE;
static boolean b_mid_left = FALSE;
static boolean b_mid_right = FALSE;
static boolean b_chute = FALSE;
static boolean b_cargo_small = FALSE;
static boolean b_cargo_large = FALSE;

	if ( str_type_last != str_type ) then
		str_type_last = str_type;
		
		b_front_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "LEFT");
		b_front_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "RIGHT");
		b_back_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "LEFT");
		b_back_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "RIGHT");
		b_mid_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_MID_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "MID") or (str_type == "LEFT");
		b_mid_right = (str_type == "ALL") or (str_type == "UNITS_MID_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "UNITS") or (str_type == "MID") or (str_type == "RIGHT");
		b_chute = (str_type == "ALL") or (str_type == "UNITS_CHUTE") or (str_type == "UNITS") or (str_type == "CHUTE") or (str_type == "TOGGLE_UNITS");
		b_cargo_small = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_LARGE");
		b_cargo_large = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_SMALL");
		
	end

	// return
	spops_phantom_seat_cnt( vh_phantom, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute, b_cargo_small, b_cargo_large );
end

// === spops_phantom_unit_type_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_unit_type_occupied_cnt( vehicle vh_phantom, string str_type )
static string str_type_last = "";
static boolean b_front_left = FALSE;
static boolean b_front_right = FALSE;
static boolean b_back_left = FALSE;
static boolean b_back_right = FALSE;
static boolean b_mid_left = FALSE;
static boolean b_mid_right = FALSE;
static boolean b_chute = FALSE;

	if ( str_type_last != str_type ) then
		str_type_last = str_type;
		
		b_front_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "LEFT");
		b_front_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "RIGHT");
		b_back_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "LEFT");
		b_back_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "RIGHT");
		b_mid_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_MID_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "MID") or (str_type == "LEFT");
		b_mid_right = (str_type == "ALL") or (str_type == "UNITS_MID_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "UNITS") or (str_type == "MID") or (str_type == "RIGHT");
		b_chute = (str_type == "ALL") or (str_type == "UNITS_CHUTE") or (str_type == "UNITS") or (str_type == "CHUTE") or (str_type == "TOGGLE_UNITS");
		
	end

	// return
	spops_phantom_seat_cnt( vh_phantom, b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute, b_cargo_small, b_cargo_large );
end

// === spops_phantom_unit_type_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_cargo_type_occupied_cnt( vehicle vh_phantom, string str_type )
static string str_type_last = "";
static boolean b_cargo_small = FALSE;
static boolean b_cargo_large = FALSE;

	if ( str_type_last != str_type ) then
		str_type_last = str_type;
		
		b_cargo_small = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_LARGE");
		b_cargo_large = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_SMALL");
		
	end

	// return
	spops_phantom_cargo_cnt( vh_phantom, b_cargo_small, b_cargo_large );
end
*/

/*
// === spops_phantom_seat_cnt::: XXX
// XXX document params
script static short spops_phantom_seat_type_cnt( string str_type )
static string str_type_last = "";
static boolean b_front_left = FALSE;
static boolean b_front_right = FALSE;
static boolean b_back_left = FALSE;
static boolean b_back_right = FALSE;
static boolean b_mid_left = FALSE;
static boolean b_mid_right = FALSE;
static boolean b_chute = FALSE;
static boolean b_cargo_small = FALSE;
static boolean b_cargo_large = FALSE;
static short s_cnt = 0;

	if ( str_type_last != str_type ) then
		str_type_last = str_type;
		
		b_front_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "LEFT");
		b_front_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_FRONT_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_FRONT") or (str_type == "FRONT") or (str_type == "RIGHT");
		b_back_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "LEFT");
		b_back_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_BACK_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_BACK") or (str_type == "BACK") or (str_type == "RIGHT");
		b_mid_left = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_MID_LEFT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_LEFT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "MID") or (str_type == "LEFT");
		b_mid_right = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_MID_RIGHT") or (str_type == "TOGGLE_UNITS") or (str_type == "TOGGLE_UNITS_RIGHT") or (str_type == "TOGGLE_UNITS_MID") or (str_type == "MID") or (str_type == "RIGHT");
		b_chute = (str_type == "ALL") or (str_type == "UNITS") or (str_type == "UNITS_CHUTE") or (str_type == "CHUTE") or (str_type == "TOGGLE_UNITS");
		b_cargo_small = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_SMALL");
		b_cargo_large = (str_type == "ALL") or (str_type == "CARGO") or (str_type == "CARGO_LARGE");
		
		s_cnt = spops_phantom_seat_cnt( b_front_left, b_front_right, b_back_left, b_back_right, b_mid_left, b_mid_right, b_chute, b_cargo_small, b_cargo_large );
	end

	// return
	s_cnt;

end
*/





