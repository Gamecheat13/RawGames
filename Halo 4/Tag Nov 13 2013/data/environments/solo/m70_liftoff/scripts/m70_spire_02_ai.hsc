//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
// =================================================================================================
// =================================================================================================
// spire_02_AI
// =================================================================================================
// =================================================================================================


//==================================
// SPIRE_02_AI_FUNCTIONS
//==================================

script dormant f_spire_02_AI_init()
	dprint( "::: f_spire_02_INT_AI_init :::" );
	// initialize modules
	sleep_until(f_spire_02_INT_Zone_Active(), 1);
	
	// initialize sub modules
	wake(f_spire_02_ai_main);

end

script dormant f_spire_02_AI_deinit()
	dprint( "::: f_spire_02_INT_AI_deinit :::" );

	sleep_forever( f_spire_02_AI_init );
	sleep_forever( f_spire_02_ai_main );


end

script dormant f_spire_02_ai_main()
	dprint("f_spire_02_ai_main");	
	if f_spire_state_complete(DEF_SPIRE_01) then
		wake(f_sp02_second_spire_spawn);
	end

	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_02_INT_B, 1);
	sleep_s(1);
	ai_place(sq_sp02_bishop_switch);
	
	wake(f_sp02_ai_core_01);
	wake(f_sp02_ai_core_02);
	wake(f_sp02_ai_core_03);
	
	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_TWO_CORE());
	
	wake(f_transition_01_02);
	wake(f_transition_01_03);
	wake(f_transition_02_03);
	
	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ZERO_CORE() and volume_test_players(tv_spire02_commander), 1);
	wake(f_sp02_ai_exit_spawn);

end



//==================================
// SPIRE_02_AI_CORE_SPAWN
//==================================

/////////////////
//core 01
/////////////////

script dormant f_sp02_ai_core_01()

	ai_place(sq_sp02_core_01_bishop_01);
	sleep_until(volume_test_players(tv_spire02_objective_start), 1);
	ai_place_with_shards(sq_sp02_core_01_pawn_01);
	ai_place_with_shards(sq_sp02_core_01_pawn_02);

	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_START(), 1);

	ai_place_with_shards(sq_sp02_core_01_pawn_03);

	sleep_until(volume_test_players(tv_spire02_core_01) or S_SP02_CORES_ACTIVE == 2, 1);

	
	thread(f_sp02_ai_core_01_knight_guard());

	if ai_living_count(sq_sp02_core_01_pawn_01) == 0 then
		ai_place_with_shards(sq_sp02_core_01_pawn_01);
		sleep_s(0.5);
	end
	
	if ai_living_count(sq_sp02_core_01_pawn_02) == 0 then
		ai_place_with_shards(sq_sp02_core_01_pawn_02);
		sleep_s(0.5);
	end
/*
	if ai_living_count(sg_core_01_bishops) == 1 then 
		ai_place(sq_sp02_core_01_bishop_02);
		sleep_s(2);
	end
	*/
	//check if antoher core is active
	sleep_until(S_SP02_CORES_ACTIVE == 2, 1);
	
	if ai_living_count(sq_sp02_core_01_pawn_03) == 0 and f_sp02_core_valid(DEF_SP02_CORE_01()) then
		ai_place_with_shards(sq_sp02_core_01_pawn_03);
		sleep_s(0.5);
	end

	sleep_until(S_SP02_CORES_ACTIVE == 3, 1);
	sleep_s(1);
	if f_sp02_core_valid(DEF_SP02_CORE_01()) then
	dprint("KNIGHT_02");
		ai_place_in_limbo(sq_sp02_core_01_knight_02);
		
	end

end

script static void f_sp02_ai_core_01_knight_guard()
	dprint("f_sp02_ai_core_knight_guard");
	repeat
	
	if volume_test_players_lookat(tv_spire02_core_01_core, 15, 15) then
		ai_place_in_limbo(sq_sp02_core_01_knight_01.spawn_points_0);
	elseif volume_test_players_lookat(tv_spire02_core_01_back, 20, 20) then
		ai_place_in_limbo(sq_sp02_core_01_knight_01.spawn_points_1);
	end
	
	until(ai_living_count(sg_core_01_knights) > 0, 1);
	
end

////////////////////////
//core 02
////////////////////////

script static void f_sp02_ai_core_pawn_spawn(ai squad)
		dprint("f_sp02_ai_core_pawn_spawn");
		if ai_living_count(squad) < 1 then
			ai_place_with_shards(squad);
			sleep_s(0.5);
		end
end


script dormant f_sp02_ai_core_02()

	ai_place(sq_sp02_core_02_bishop_01);
	sleep_until(volume_test_players(tv_spire02_objective_start), 1);
	ai_place_with_shards(sq_sp02_core_02_pawn_01);
	ai_place_with_shards(sq_sp02_core_02_pawn_02);

	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_START(), 1);

	ai_place_with_shards(sq_sp02_core_02_pawn_03);

	sleep_until(volume_test_players(tv_spire02_core_02) or S_SP02_CORES_ACTIVE == 2, 1);

	
	thread(f_sp02_ai_core_02_knight_guard());

//replenish if empty
	if ai_living_count(sq_sp02_core_02_pawn_01) == 0 then
		ai_place_with_shards(sq_sp02_core_02_pawn_01);
		sleep_s(0.5);
	end
	
	if ai_living_count(sq_sp02_core_02_pawn_02) == 0 then
		ai_place_with_shards(sq_sp02_core_02_pawn_02);
		sleep_s(0.5);
	end
/*
	if ai_living_count(sg_core_02_bishops) < 1 then 
		ai_place(sq_sp02_core_02_bishop_02);
		sleep_s(2);
	end
	*/
	//check if antoher core is active
	sleep_until(S_SP02_CORES_ACTIVE == 2, 1);
	
	if ai_living_count(sq_sp02_core_02_pawn_03) == 0 and f_sp02_core_valid(DEF_SP02_CORE_02()) then
		ai_place_with_shards(sq_sp02_core_02_pawn_03);
		sleep_s(0.5);
	end

	sleep_until(S_SP02_CORES_ACTIVE == 3, 1);
	sleep_s(1);
	if f_sp02_core_valid(DEF_SP02_CORE_02()) then
		dprint("KNIGHT_02");
		ai_place_in_limbo(sq_sp02_core_02_knight_02);
	end

end

script static void f_sp02_ai_core_02_knight_guard()
	dprint("f_sp02_ai_core_knight_guard");
	//local boolean knight_spawn = FALSE
	repeat
		if volume_test_players_lookat(tv_spire02_core_02_core, 15, 15) then
			ai_place_in_limbo(sq_sp02_core_02_knight_01.spawn_points_0);
		elseif volume_test_players_lookat(tv_spire02_core_02_back, 20, 20) then
			ai_place_in_limbo(sq_sp02_core_02_knight_01.spawn_points_1);
		end
	until(ai_living_count(sg_core_02_knights) > 0, 1);
	
end

/////////////////
//core 03
/////////////////

script dormant f_sp02_ai_core_03()

	ai_place(sq_sp02_core_03_bishop_01);
	sleep_until(volume_test_players(tv_spire02_objective_start), 1);
	ai_place_with_shards(sq_sp02_core_03_pawn_01);
	ai_place_with_shards(sq_sp02_core_03_pawn_02);

	sleep_until(S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_START(), 1);

	ai_place_with_shards(sq_sp02_core_03_pawn_03);

	sleep_until(volume_test_players(tv_spire02_core_03) or S_SP02_CORES_ACTIVE == 2, 1);

	
	thread(f_sp02_ai_core_03_knight_guard());

	if ai_living_count(sq_sp02_core_03_pawn_01) == 0 then
		ai_place_with_shards(sq_sp02_core_03_pawn_01);
		sleep_s(0.5);
	end
	
	if ai_living_count(sq_sp02_core_03_pawn_02) == 0 then
		sleep_s(1);
		ai_place_with_shards(sq_sp02_core_03_pawn_02);
		sleep_s(0.5);
	end

/*
	if ai_living_count(sg_core_03_bishops) < 1 then 
		ai_place(sq_sp02_core_03_bishop_02);
		sleep_s(2);
	end
*/	
	//check if antoher core is active
	sleep_until(S_SP02_CORES_ACTIVE == 2, 1);
	
	if ai_living_count(sq_sp02_core_03_pawn_03) == 0 and f_sp02_core_valid(DEF_SP02_CORE_03()) then
		ai_place_with_shards(sq_sp02_core_03_pawn_03);
		sleep_s(0.5);
	end

	sleep_until(S_SP02_CORES_ACTIVE == 3, 1);
	
	if f_sp02_core_valid(DEF_SP02_CORE_03()) then
		dprint("sq_sp02_core_03_knight_02");
		ai_place_in_limbo(sq_sp02_core_03_knight_02);
	end

end

script static void f_sp02_ai_core_03_knight_guard()
	dprint("f_sp02_ai_core_knight_guard");
	//local boolean knight_spawn = FALSE
	repeat
	
	if volume_test_players_lookat(tv_spire02_core_03_core, 15, 15) then
		ai_place_in_limbo(sq_sp02_core_03_knight_01.spawn_points_0);
	elseif volume_test_players_lookat(tv_spire02_core_03_back, 20, 20) then
		ai_place_in_limbo(sq_sp02_core_03_knight_01.spawn_points_1);
	end
	
	until(ai_living_count(sg_core_03_knights) > 0, 1);
	
end

//START
script dormant f_sp02_second_spire_spawn()
	sleep_until(volume_test_players(tv_sp02_spawn_pawn_enter), 1);
	dprint("f_sp02_second_spire_spawn");
		ai_place(sq_sp02_hall_bishop);	
		ai_place(sq_sp02_hall_pawns_01);
		ai_place(sq_sp02_hall_pawns_02);
	sleep_until(volume_test_players_all_lookat(tv_sp02_int_door_enter ,10, 10), 1);
		sleep_s(1);
		ai_place_with_shards(sq_sp02_hall_pawns_03);
end

//EXIT
script dormant f_sp02_ai_exit_spawn()
	dprint("f_sp02_ai_exit_spawn");
	sleep_s(1);
	ai_place_in_limbo(sq_sp02_hall_commander);
	ai_place(sq_sp02_hall_pawns_01);
	//ai_place(sq_end_pawns_02);
end

script dormant f_transition_01_02()
sleep_until(not f_sp02_core_valid(DEF_SP02_CORE_02()) or not f_sp02_core_valid(DEF_SP02_CORE_01()), 1);
		
		if not f_sp02_core_valid(DEF_SP02_CORE_02()) then
			ai_place(sq_sp02_01_02_pawns_core_01);
		elseif not f_sp02_core_valid(DEF_SP02_CORE_01()) then
			ai_place(sq_sp02_01_02_pawns_core_02);
		end
	
	wake(f_transition_01_02_knight);
	sleep_s(2.5);
	ai_place(sq_sp02_01_02_bishop);
	sleep_s(1);
	sleep_until( ai_living_count(sq_sp02_01_02_bishop) > 0 or ai_living_count(sq_sp02_01_02_knight) <= 0, 1);
	if S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE() then
		ai_place_with_shards(sq_sp02_01_02_turret);
	else
		ai_place_with_shards(sq_sp02_01_02_pawns);
	end
	
end

script dormant f_transition_01_03()
sleep_until(not f_sp02_core_valid(DEF_SP02_CORE_03()) or not f_sp02_core_valid(DEF_SP02_CORE_01()), 1);
		
		if not f_sp02_core_valid(DEF_SP02_CORE_03()) then
			ai_place(sq_sp02_01_03_pawns_core_01);
		elseif not f_sp02_core_valid(DEF_SP02_CORE_01()) then
			ai_place(sq_sp02_01_03_pawns_core_03);
		end
	
	wake(f_transition_01_03_knight);

	sleep_s(3);
	ai_place(sq_sp02_01_03_bishop);
	sleep_s(1.5);
	sleep_until( ai_living_count(sq_sp02_01_03_bishop) > 0 or ai_living_count(sq_sp02_01_03_knight) <= 0, 1);
	if S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE() then
		ai_place_with_shards(sq_sp02_01_03_turret);
		//sleep_s(1);
		//AutomatedTurretActivate(ai_vehicle_get (sq_sp02_01_03_turret.spawn_points_0) );
	else
		ai_place_with_shards(sq_sp02_01_03_pawns);
	end
	
end


script dormant f_transition_02_03()
sleep_until(not f_sp02_core_valid(DEF_SP02_CORE_02()) or not f_sp02_core_valid(DEF_SP02_CORE_03()), 1);

		if not f_sp02_core_valid(DEF_SP02_CORE_02()) then
			ai_place(sq_sp02_02_03_pawns_core_03);
		elseif not f_sp02_core_valid(DEF_SP02_CORE_03()) then
			ai_place(sq_sp02_02_03_pawns_core_02);
		end
	
	
	wake(f_transition_02_03_knight);

	sleep_s(3);
	ai_place(sq_sp02_02_03_bishop);
	sleep_s(1.25);
	sleep_until( ai_living_count(sq_sp02_02_03_bishop) > 0 or ai_living_count(sq_sp02_02_03_knight) <= 0, 1);
	if S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE() then
		ai_place_with_shards(sq_sp02_02_03_turret);
		//sleep_s(1);
		//AutomatedTurretActivate(ai_vehicle_get (sq_sp02_02_03_turret.spawn_points_0) );
		//RequestAutomatedTurretActivation(ai_vehicle_get (sq_sp02_02_03_turret.spawn_points_0) );
	end
	
end


//KNIGHTS
script dormant f_transition_01_02_knight()
	if not f_sp02_core_valid(DEF_SP02_CORE_02()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_02_knight_left,10 ,10) or volume_test_players_lookat( tv_spire02_trans_core_02_knight_lower,10, 10), 1);
		sleep_s(1);
		ai_place_in_limbo(sq_sp02_01_02_knight.spawn_points_0);
		sleep_s(2);
		cs_phase_to_point(sq_sp02_01_02_knight, true, ps_sp02_transition_phase.p0);
		
	elseif not f_sp02_core_valid(DEF_SP02_CORE_01()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_01_knight_left,15 ,15) or volume_test_players_lookat( tv_spire02_trans_core_01_knight_right,15, 15), 1);
		sleep_s(0.25);
		ai_place_in_limbo(sq_sp02_01_02_knight.spawn_points_1);
		sleep_s(2);
		cs_phase_to_point(sq_sp02_01_02_knight, true, ps_sp02_transition_phase.p1);
	end
end

script dormant f_transition_01_03_knight()
	if not f_sp02_core_valid(DEF_SP02_CORE_03()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_03_knight_right,10 ,10) or volume_test_players_lookat( tv_spire02_trans_core_03_knight_lower,10, 10), 1);
		sleep_s(1);
		ai_place_in_limbo(sq_sp02_01_03_knight.spawn_points_0);
		sleep_s(4.5);
		cs_phase_to_point(sq_sp02_01_03_knight, true, ps_sp02_transition_phase.p2);
		
	elseif not f_sp02_core_valid(DEF_SP02_CORE_01()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_01_knight_left,15 ,15) or volume_test_players_lookat( tv_spire02_trans_core_01_knight_right,15, 15), 1);
		sleep_s(0.25);
		ai_place_in_limbo(sq_sp02_01_03_knight.spawn_points_1);
		sleep_s(2);
		cs_phase_to_point(sq_sp02_01_03_knight, true, ps_sp02_transition_phase.p3);
	end

end

script dormant f_transition_02_03_knight()
	if not f_sp02_core_valid(DEF_SP02_CORE_03()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_03_knight_right,10 ,10) or volume_test_players_lookat( tv_spire02_trans_core_03_knight_lower,10, 10), 1);
		sleep_s(1.25);
		ai_place_in_limbo(sq_sp02_02_03_knight.core_03);
		sleep_s(4.5);
		cs_phase_to_point(sq_sp02_02_03_knight, true, ps_sp02_transition_phase.p4);
		
	elseif not f_sp02_core_valid(DEF_SP02_CORE_02()) then
		sleep_until(volume_test_players_lookat( tv_spire02_trans_core_02_knight_left,15 ,15) or volume_test_players_lookat( tv_spire02_trans_core_02_knight_lower,15, 15), 1);
		sleep_s(1.25);
		ai_place_in_limbo(sq_sp02_02_03_knight.core_02);
		sleep_s(4.5);
		cs_phase_to_point(sq_sp02_02_03_knight, true, ps_sp02_transition_phase.p4);
	end

end

//transistion gates
script static boolean f_sp02_ai_transition_01_03_valid()
	S_SP02_FIRST_CORE == DEF_SP02_CORE_01() or
	S_SP02_FIRST_CORE == DEF_SP02_CORE_03() or
	S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE();
end

script static boolean f_sp02_ai_transition_01_02_valid()
	S_SP02_FIRST_CORE == DEF_SP02_CORE_01() or
	S_SP02_FIRST_CORE == DEF_SP02_CORE_02() or
	S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE();
end

script static boolean f_sp02_ai_transition_02_03_valid()
	S_SP02_FIRST_CORE == DEF_SP02_CORE_02() or
	S_SP02_FIRST_CORE == DEF_SP02_CORE_03() or
	S_SP02_OBJ_CON >= S_DEF_OBJ_CON_SP02_ONE_CORE();
end

//===============================
//SPIRE_02_COMMAND_SCRITPS
//===============================

script command_script cs_bishop_spawn()
	print("bishop sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_m70, 0);
end

script static void OnCompleteProtoSpawn_m70()
	dprint("general protospawn script");
end

script command_script cs_phase_in_on_spawn()
	//cs_phase_in();
	cs_phase_in_blocking();
end

