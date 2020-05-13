//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//===================================
// SPIRE_03_AI
//===================================
//FUNCTION INDEX
//===================================
// SPIRE_03_AI_VARIABLES
// :: SPIRE_03_AI_DEFINES
// SPIRE_03_AI_FUNCTIONS
// :: SPIRE_03_AI_INIT
// :: SPIRE_03_AI_DEINIT
// :: SPIRE_03_AI_OBJCON
// SPIRE_03_AI_BOTTOM
// :: SPIRE_03_AI_BOTTOM_TURRETS
// :: SPIRE_03_AI_BOTTOM_FALLBACK
// SPIRE_03_AI_TOP
// SPIRE_03_AI_TOP_COMMAND_SCRIPTS


//====================================
// SPIRE_03_AI_VARIABLES
//====================================
global short S_sp03_bot_p_side = 0;
global short S_OBJ_CON_SPIRE_03 = 0;

global boolean B_sp03_top_staging 				= TRUE;
global boolean B_sp03_top_sniper_fallback = FALSE;


// :: SPIRE_03_AI_DEFINES
script static short S_DEF_OBJ_CON_SPIRE_03_BOTTOM_START()				1; end
script static short S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID()					2; end
script static short S_DEF_OBJ_CON_SPIRE_03_BOTTOM_BACK()				3; end
script static short S_DEF_OBJ_CON_SPIRE_03_BOTTOM_HUNTER()			4; end
script static short S_DEF_OBJ_CON_SPIRE_03_TOP_START()					5; end
script static short S_DEF_OBJ_CON_SPIRE_03_TOP_MID()						6; end
script static short S_DEF_OBJ_CON_SPIRE_03_TOP_BACK()						7; end
script static short S_DEF_OBJ_CON_SPIRE_03_TOP_BRIDGE()					8; end

//====================================
// SPIRE_03_AI_FUNCTIONS
//====================================

// :: SPIRE_03_AI_INIT
script dormant f_spire_03_AI_init()
	dprint( "::: f_spire_03_INT_AI_init :::" );

	// initialize sub modules
	sleep_until(volume_test_players(tv_spire_03_bottom_start), 1);
	
	checkpoint_no_timeout( TRUE, "SPIRE_03_START_BOTTOM_ENCOUNTER" );

	wake( f_sp03_ai_bottom );
	wake(f_sp03_ai_objcon_bottom);
	
	sleep_until(volume_test_players(tv_spire_03_top_start), 1);
	ai_erase(sg_sp03_bot_all);
	checkpoint_no_timeout( TRUE, "SPIRE_03_START_TOP_ENCOUNTER" );

	wake(f_sp03_ai_top);
	
end

script static void test_bottom()
	dprint("f_sp03_ai_bottom");
	ai_place(sq_sp03_bot_front_01);
	ai_place(sq_sp03_bot_front_02);
	ai_place(sq_sp03_bot_mid_right_01);
	ai_place(sq_sp03_bot_mid_right_02);
	ai_place(sq_sp03_bot_mid_right_03);
	ai_place(sq_sp03_bot_mid_left_01);
	ai_place(sq_sp03_bot_mid_left_02);
	ai_place(sq_sp03_bot_back_02);
	
	sleep_until(volume_test_players(tv_spire_03_bottom_mid), 1);
	wake(f_sp03_ai_objecon_bottom_check_side);
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID();
	ai_place(sq_sp03_bot_back_01);
	ai_place(sq_sp03_bot_back_right);
	ai_place(sq_sp03_bot_back_left);
end

// :: SPIRE_03_AI_DEINIT
script dormant f_spire_03_AI_deinit()
	dprint( "::: f_spire_03_AI_deinit :::" );

	// kill functions
	sleep_forever( f_spire_03_AI_init );
	sleep_forever( f_sp03_ai_bottom );
	sleep_forever( f_sp03_ai_top );


end

// :: SPIRE_03_AI_OBJCON
script dormant f_sp03_ai_objcon_bottom()
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_START();
	f_blip_flag(flg_sp03_elevator_bottom, "recon");
	sleep_until(volume_test_players(tv_spire_03_bottom_mid), 1);
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID();
	wake(f_sp03_ai_objecon_bottom_check_side);
	sleep_until(volume_test_players(tv_spire_03_bottom_back), 1);
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_BACK();
	sleep_until(volume_test_players(tv_spire_03_bottom_hunter), 1);
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_HUNTER();
	sleep_until(volume_test_players(tv_grav_lift_02_start), 1);
	f_unblip_flag(flg_sp03_elevator_bottom);
end	

script dormant f_sp03_ai_objecon_bottom_check_side()
	if volume_test_players(tv_sp03_bottom_mid_left) then
		S_sp03_bot_p_side = 1;
	elseif volume_test_players(tv_sp03_bottom_mid_right) then
		S_sp03_bot_p_side = 2;
	end
end

//========================================
// SPIRE_03_AI_BOTTOM
//========================================

script dormant f_sp03_ai_bottom()
	dprint("f_sp03_ai_bottom");
	ai_place(sq_sp03_bot_front_01);
	ai_place(sq_sp03_bot_front_02);
	ai_place(sq_sp03_bot_mid_right_01);
	ai_place(sq_sp03_bot_mid_right_02);
	ai_place(sq_sp03_bot_mid_right_03);
	ai_place(sq_sp03_bot_mid_left_01);
	ai_place(sq_sp03_bot_mid_left_02);
	ai_place(sq_sp03_bot_back_02);
	
	sleep_until(volume_test_players(tv_spire_03_bottom_mid), 1);
	wake(f_sp03_ai_objecon_bottom_check_side);
	S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID();
	ai_place(sq_sp03_bot_back_01);
	ai_place(sq_sp03_bot_back_right);
	ai_place(sq_sp03_bot_back_left);
	
	wake(f_sp03_ai_bottom_spawn_hunter);
end

script dormant f_sp03_ai_bottom_spawn_hunter()
	dprint("f_sp03_ai_bottom_spawn_hunter");
	if object_valid(sp03_bottom_hunter_elevator) then
		object_destroy(sp03_bottom_hunter_elevator);
	end
	
	if object_valid(sp03_bottom_elevator_02) then 
		object_destroy(sp03_bottom_elevator_02);
	end
	
	sleep_until(volume_test_players(tv_spire_03_bottom_hunter), 1);
	wake(f_m70_cheevo);
	ai_place(sq_sp03_bot_hunter_01);
	sleep_s(2);
	object_destroy(sp03_bottom_hunter_elevator);
	sleep_s(1);
	object_create(sp03_bottom_hunter_elevator);
	sleep_s(1);
	ai_place(sq_sp03_bot_hunter_02);
	sleep_s(2.5);
	object_destroy(sp03_bottom_hunter_elevator);
	f_sp03_fx_grav_lift_disable();


	sleep_until( (ai_living_count(sq_sp03_bot_hunter_01) + ai_living_count(sq_sp03_bot_hunter_02)) == 0, 1);

	sleep_s(0.25);
	game_save_no_timeout();
	
	sleep_s(3);
	
	f_sp03_fx_grav_lift_enable();
	
	object_create(sp03_bottom_elevator_02);
	
	wake(f_sp03_set_transition_blocker);
end

script command_script cs_sp03_hunter_sidestep()
	cs_move_in_direction( 0.0, 3.0, 0.0);
end

script command_script cs_sp03_hunter_sidestep_2()
	cs_move_in_direction( 1.0, 0.0, 0.0);
end

script command_script cs_phantom_01_fly()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1, 30);
	f_load_phantom( ai_current_actor, "right", sq_sp03_bot_front_01, sq_sp03_bot_front_02, none, none );
	cs_fly_to_and_face(ps_bottom_phantom.p0, ps_bottom_phantom.p1);
	//cs_fly_to( ps_bottom_phantom.p0 );
	//cs_fly_to( ps_bottom_phantom.p2 );

	f_unload_phantom( ai_current_actor, "right" );
	
	cs_fly_to( ps_bottom_phantom.p4 );
	cs_fly_to( ps_bottom_phantom.p7 );
	cs_fly_to( ps_bottom_phantom.p6 );
//	ai_erase(sq_sp03_bot_phantom_01);
end

script command_script cs_phantom_02_fly()
	//f_load_phantom( ai_current_actor, "left", sq_sp03_bot_front_01, sq_sp03_bot_front_02, none, none );
	//cs_fly_to( ps_bottom_phantom.p0 );
	//cs_fly_to( ps_bottom_phantom.p2 );
	//cs_fly_to( ps_bottom_phantom.p4 );
	//cs_fly_to( ps_bottom_phantom.p3 );
	//cs_fly_to_and_face(ps_bottom_phantom.p2, ps_bottom_phantom.p5);
	//f_unload_phantom( ai_current_actor, "left" );
	cs_fly_to( ps_bottom_phantom.p5 );
	cs_fly_to( ps_bottom_phantom.p6 );
//	ai_erase(sq_sp03_bot_phantom_02);
end

// :: SPIRE_03_AI_BOTTOM_TURRETS
script static boolean f_sp03_bottom_turret_right_valid()
	ai_in_vehicle_count(sq_sp03_bot_mid_right_02) < 1 and
	ai_living_count(sq_sp03_bot_mid_right_02) != 0 and
	not volume_test_players(tv_sp03_bottom_mid_right);
end

script static boolean f_sp03_bottom_turret_left_valid()
	ai_in_vehicle_count(sq_sp03_bot_mid_left_02) < 1 and
	ai_living_count(sq_sp03_bot_mid_left_02) != 0 and
	not volume_test_players(tv_sp03_bottom_mid_left);
end

script dormant f_sp03_ai_bottom_turrets_right()
	
	local short s_random = 0;
	local short s_turret_count = 0;


	repeat 
		if f_sp03_bottom_turret_right_valid() and (s_turret_count < 2) then		
	
			if ai_living_count(sq_sp03_bot_mid_right_02.spawn_points_0) != 0 then	
				//cs_go_to_vehicle(sq_sp03_bot_mid_right_02.spawn_points_0, true, v_spire03_turret_plasma_01);
				s_turret_count = (s_turret_count + 1);
		
			elseif ai_living_count(sq_sp03_bot_mid_right_02.spawn_points_1) != 0 then 
				//cs_go_to_vehicle(sq_sp03_bot_mid_right_02.spawn_points_1, true, v_spire03_turret_plasma_01);
				s_turret_count = (s_turret_count + 1);
			end
		end	
		
		sleep_s(real_random_range(0.5,2.25));
		
	until(S_OBJ_CON_SPIRE_03 >= S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID() or s_turret_count == 2, 1);

end

script dormant f_sp03_ai_bottom_turrets_left()
	
	local short s_random = 0;
	local short s_turret_count = 0;

	repeat 
		if f_sp03_bottom_turret_right_valid() and (s_turret_count < 2) then		
	
			if ai_living_count(sq_sp03_bot_mid_left_02.spawn_points_0) != 0 then	
//				cs_go_to_vehicle(sq_sp03_bot_mid_left_02.spawn_points_0, true, v_spire03_turret_plasma_02);
				s_turret_count = (s_turret_count + 1);
		
			elseif ai_living_count(sq_sp03_bot_mid_left_02.spawn_points_1) != 0 then 
				//cs_go_to_vehicle(sq_sp03_bot_mid_left_02.spawn_points_1, true, v_spire03_turret_plasma_02);
				s_turret_count = (s_turret_count + 1);
			end	
		end
		sleep_s(real_random_range(0.5,2.25));
		
	until(S_OBJ_CON_SPIRE_03 >= S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID() or s_turret_count == 2);
	
end


// :: SPIRE_03_AI_BOTTOM_FALLBACK

script dormant f_sp03_ai_bottom_fallback()
sleep_until(S_OBJ_CON_SPIRE_03 == S_DEF_OBJ_CON_SPIRE_03_BOTTOM_MID(), 1);

	if not volume_test_players(tv_sp03_bottom_mid_left) then
		ai_set_task_condition(obj_sp03_bottom.gate_mid_left, false);
		
	elseif not volume_test_players(tv_sp03_bottom_mid_right) then
		ai_set_task_condition(obj_sp03_bottom.gate_mid_right, false);
		
	elseif volume_test_players(tv_sp03_bottom_mid_right) and volume_test_players(tv_sp03_bottom_mid_left) then
		dprint("add back push front for coop");
//		ai_set_task_condition(obj_sp03_bottom.gate_reinforcements, false);
	end
	
end


//========================================
// SPIRE_03_AI_TOP
//========================================

script dormant f_sp03_ai_top()
	dprint("f_sp03_ai_top");
	wake(f_sp03_objcon_top);
	wake(f_sp03_ai_top_start);

end

script dormant f_sp03_objcon_top()
dprint("f_sp03_objcon_top");
 S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_START();		
 
 sleep_until(volume_test_players(tv_sp03_top_front), 1);	
 dprint("S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_MID()");
 S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_MID();		
 
 sleep_until(volume_test_players(tv_sp03_top_mid), 1);	
 dprint("S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_BACK()");
 S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_BACK();
 
 sleep_until(volume_test_players(tv_sp03_top_back), 1);
 dprint("S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_BRIDGE()");
 S_OBJ_CON_SPIRE_03 = S_DEF_OBJ_CON_SPIRE_03_TOP_BRIDGE();
 
end
//wake(f_sp03_ai_top_start)
script dormant f_sp03_ai_top_start()
	ai_lod_full_detail_actors(25);
	dprint("f_sp03_ai_top_start");
	//air 
	ai_place(sq_sp03_top_bansh_front);
	ai_place(sq_sp03_top_bansh_start_01);	
	ai_place(sq_sp03_top_bansh_start_02);
	//inf front
	ai_place(sq_sp03_top_front_left_elite);
	//ai_place(sq_sp03_top_front_right_sniper);
	ai_place(sq_sp03_top_turret_front);
	ai_place(sq_sp03_top_turret_bridge_02);
	//inf mid
	ai_place(sq_sp03_top_mid);
	ai_place(sq_sp03_top_mid_right);
	ai_place(sq_sp03_top_mid_left);
	//inf back
	wake(f_sp03_ai_top_inf_back);
	

	//turrets
	wake(f_sp03_top_ai_mid_right_turret);
	wake(f_sp03_top_ai_mid_left_turret);
	ai_place(sq_sp03_top_turret_back);
	ai_place(sq_sp03_top_turret_bridge);
	
	//inf bridge
	//ai_place(sq_sp03_top_bridge_hunter_01);
	//ai_place(sq_sp03_top_bridge_hunter_02);	
	ai_place(sg_sp03_top_bridge);
	
	wake(f_sp03_ai_top_inf_reinforce);
	
	
end

script dormant f_sp03_ai_top_inf_back()
	dprint("f_sp03_ai_top_inf_back");
	sleep_until(S_OBJ_CON_SPIRE_03 >= S_DEF_OBJ_CON_SPIRE_03_TOP_BACK() and not volume_test_players_lookat (tv_sp03_back_spawn_lookat, 24, 24), 1);
	ai_place(sq_sp03_top_back);

end

script dormant f_sp03_ai_top_inf_reinforce()
	dprint("f_sp03_ai_top_inf_reinforce");
	sleep_until(ai_living_count(sg_sp_03_top_all) <= 18, 1);
		thread(f_sp03_ai_top_inf_reinforcements());
		sleep_s(5);
	sleep_until(ai_living_count(sg_sp_03_top_all) <= 18, 1);
		if vehicle_test_players() or game_is_cooperative() then
		thread(f_sp03_ai_top_inf_reinforcements());
		sleep_s(5);
		end
	sleep_until(ai_living_count(sg_sp_03_top_all) <= 18, 1);
		if vehicle_test_players() or game_is_cooperative() then
		thread(f_sp03_ai_top_inf_reinforcements());
		sleep_s(5);
		end
	sleep_until(ai_living_count(sg_sp_03_top_all) <= 18, 1);
		if game_is_cooperative() then
		thread(f_sp03_ai_top_inf_reinforcements());
		sleep_s(5);
		end


end

script static void f_sp03_ai_top_inf_reinforcements()
	dprint("f_sp03_ai_top_inf_reinforcements");
	if ai_living_count(sq_sp03_top_reinforce_aa_01) == 0 and vehicle_test_players() then
		sleep_until( not volume_test_players_lookat (tv_sp03_left_spawn_lookat, 24, 24) and not volume_test_players(tv_sp03_top_plat_back_left), 1);
		ai_place(sq_sp03_top_reinforce_aa_01);
	elseif ai_living_count(sq_sp03_top_reinforce_inf_01) == 0 then
	sleep_until( not volume_test_players_lookat (tv_sp03_right_spawn_lookat, 24, 24)and not volume_test_players(tv_sp03_top_plat_back_right), 1);
		ai_place(sq_sp03_top_reinforce_inf_01);
	elseif ai_living_count(sq_sp03_top_reinforce_aa_02) == 0 and vehicle_test_players() then
	sleep_until( not volume_test_players_lookat (tv_sp03_back_spawn_lookat, 24, 24) and not volume_test_players(tv_sp03_plat_back), 1);
		ai_place(sq_sp03_top_reinforce_aa_02);
	elseif ai_living_count(sq_sp03_top_reinforce_inf_02) == 0 then
	sleep_until( not volume_test_players_lookat (tv_sp03_bridge_spawn_lookat, 24, 24) and not volume_test_players(tv_sp03_bridge), 1);
		ai_place(sq_sp03_top_reinforce_inf_02);
	end

end

script dormant f_sp03_ai_top_air_reinforce()
	sleep_until(ai_living_count(sg_sp03_top_air) < 3 and vehicle_test_players(), 1);
	f_sp03_top_ai_place( sq_sp03_top_bansh_reinforce_01, 20);
	sleep_s(2);
	//xxx add co-op 4th banshee
end

script static void f_sp03_top_ai_place( ai squad, short living_count)
	dprint("squad in queued");
	sleep_until(ai_living_count(sg_sp_03_top_all) < living_count, 1);
	dprint("placing a squad");
	ai_place(squad);
end

//turrets
script static boolean f_sp03_top_ai_mid_right_shade_valid()
	object_get_health(v_sp03_shade_mid_right) > 0 and
	object_valid(v_sp03_shade_mid_right) and
	ai_living_count(sq_sp03_top_mid_right) != 0 and
	ai_in_vehicle_count(sq_sp03_top_mid_right) < 1;
end

script static boolean f_sp03_top_ai_mid_left_shade_valid()
	object_get_health(v_sp03_shade_mid_left) > 0 and
	object_valid(v_sp03_shade_mid_left) and
	ai_living_count(sq_sp03_top_mid_left) != 0;
	ai_in_vehicle_count(sq_sp03_top_mid_left) < 1;
end

script dormant f_sp03_top_ai_mid_right_turret()
	local short s_random_count = random_range(2,3);
	local short s_turret_count = 0;
	inspect(s_random_count);
	repeat 
	
		if f_sp03_top_ai_mid_right_shade_valid() and s_turret_count < s_random_count then		

			if ai_living_count(sq_sp03_top_mid_right.spawn_points_0) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_right.spawn_points_0, true, v_sp03_shade_mid_right);
				s_turret_count = (s_turret_count + 1);
			
			elseif ai_living_count(sq_sp03_top_mid_right.spawn_points_1) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_right.spawn_points_1, true, v_sp03_shade_mid_right);
				s_turret_count = (s_turret_count + 1);

			elseif ai_living_count(sq_sp03_top_mid_right.spawn_points_2) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_right.spawn_points_2, true, v_sp03_shade_mid_right);
				s_turret_count = (s_turret_count + 1);
			elseif ai_living_count(sq_sp03_top_mid_right.spawn_points_3) != 0 then
				s_turret_count = (s_turret_count + 1);
				
			end	
			
		end	
		sleep_s(real_random_range(3,7));

	until( ai_living_count(sq_sp03_top_mid_right) == 0 or s_turret_count == s_random_count, 1);

end

script dormant f_sp03_top_ai_mid_left_turret()
	local short s_random_count = random_range(2,3);
	local short s_turret_count = 0;

repeat 
		if f_sp03_top_ai_mid_left_shade_valid() and s_turret_count < s_random_count then		
	
			if ai_living_count(sq_sp03_top_mid_left.spawn_points_0) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_left.spawn_points_0, true, v_sp03_shade_mid_left);
				s_turret_count = (s_turret_count + 1);
			
			elseif ai_living_count(sq_sp03_top_mid_left.spawn_points_1) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_left.spawn_points_1, true, v_sp03_shade_mid_left);
				s_turret_count = (s_turret_count + 1);

			elseif ai_living_count(sq_sp03_top_mid_left.spawn_points_2) != 0 then	
				cs_go_to_vehicle(sq_sp03_top_mid_left.spawn_points_2, true, v_sp03_shade_mid_left);
				s_turret_count = (s_turret_count + 1);
			elseif ai_living_count(sq_sp03_top_mid_left.spawn_points_3) != 0 then
				s_turret_count = (s_turret_count + 1);
				
			end	
			
		end	
		
		sleep_s(real_random_range(3,7));
		
	until( ai_living_count(sq_sp03_top_mid_left) == 0 or s_turret_count == s_random_count, 1);
	
end





//========================================
// SPIRE_03_AI_TOP_COMMAND_SCRIPTS
//========================================
script command_script cs_sp03_top_bridge_berserk()
	ai_berserk(ai_current_actor, TRUE);
end

script command_script cs_sp03_go_to_banshee_01()
	dprint("banshee enter");
	cs_vehicle_speed(0.1);
	sleep_s(4);
	cs_vehicle_speed(1);
	sleep_s(1);
	//cs_go_to_vehicle( v_sp03_bansh_01 );
end

script command_script cs_sp03_go_to_banshee_02()
	dprint("banshee enter");
//	sleep_s(1);
//	cs_go_to_vehicle( v_sp03_bansh_02 );
end

script command_script cs_sp03_go_to_banshee_03()
	dprint("banshee enter");
	//cs_go_to_vehicle( v_sp03_bansh_03 );
end
