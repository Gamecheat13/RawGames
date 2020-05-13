////===========================================================================================================================
//============================================ FORTSW E1_M3 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================
global boolean switch1_thrown = FALSE;
global boolean switch2_thrown = FALSE;
global boolean e1m3_switch_line_1_played = FALSE;
global boolean b_e1m3_narrative_in_over = FALSE;
global boolean b_e1m3_mid_guards = FALSE;
global boolean b_e1m3_turret1 = FALSE;
global boolean b_e1m3_empty_guards = FALSE;
global boolean b_e1m3_turret1_up = FALSE;
global boolean b_e1m3_turret2_up = FALSE;
global boolean b_e1_m3_final_wave = FALSE;

script startup e1_m3_start
	sleep_until (LevelEventStatus("is_e1_m3"), 1);
	thread(f_music_e1m3_start());
	switch_zone_set(e1_m3);
	ai_ff_all = gr_ff_all;
	firefight_mode_set_player_spawn_suppressed(true);
//;----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS -----------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------	
//set crate names
	f_add_crate_folder(cr_e1_m3_shutdown);
	f_add_crate_folder(dm_e1_m3);
	f_add_crate_folder(w_e1_m3_weapons);
	f_add_crate_folder(cr_e1_m3_doors);
	f_add_crate_folder(cr_e1_m3_comm_stuff);
	f_add_crate_folder(cr_e1_m3_mission_stuff);
	f_add_crate_folder(cr_e1_m3_weapon_racks);

//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //FORTS: Top right corner. Start for E1_M3
	
//set objective names
	firefight_mode_set_objective_name_at(dc_switch01, 5); 	//e1_m3_shutdown: 1st sub switch
	firefight_mode_set_objective_name_at(dc_switch02, 29); 	//e1_m3_shutdown: 2nd sub switch
	firefight_mode_set_objective_name_at(dc_switch03, 30); 	//e1_m3_shutdown: main switch
	firefight_mode_set_objective_name_at(dc_switch04, 31); 	//e1_m3_shutdown: main switch
	firefight_mode_set_objective_name_at(lz_0, 50); //e1_m3_shutdown: LZ near 1st comm tower
	firefight_mode_set_objective_name_at(lz_2, 52); //e1_m3_shutdown: LZ at top of center tower
	firefight_mode_set_objective_name_at(lz_6, 56); //e1_m3_shutdown: LZ at corner, extraction for mission
	
	sleep_s(1);
	thread(f_start_mission_e1_m3());
	effects_perf_armageddon = 1;
	
	effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_top_mkr_01, pylon01_topArch_mkr_01);
	effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_top_mkr_01, pylon02_topArch_mkr_01);
	effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_bottom_mkr_01, pylon01_bottom_mkr_02);
	effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_bottom_mkr_01, pylon02_bottom_mkr_02);
	effect_new(levels\firefight\ff90_fortsw\fx\energycore\composer_shield.effect, arch_center_mkr_01);
	
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
end
//----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS END -------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------	

//-----------------------------------------------------------------------
//--------- Generic E1_M3 stuff -----------------------------------------
//-----------------------------------------------------------------------
script static void f_end_narrative
	b_wait_for_narrative_e1_m3 = FALSE;
end

script static void f_e1m3_narrative_in_over
	b_e1m3_narrative_in_over = TRUE;
end

script command_script cs_pawn_spawn_e1m3
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_bishop_spawn_e1_m3
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1); 		//Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	sleep(40);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);			 //grow size over time
end
//-----------------------------------------------------------------------
//--------- Generic E1_M3 stuff END -------------------------------------
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//--------- Starting Mission stuff --------------------------------------
//-----------------------------------------------------------------------
script static void f_start_mission_e1_m3
	sleep_s(1);
	if editor_mode() then 
		print("editor mode, no intro playing");
  	sleep_s(1);
  	b_e1m3_narrative_in_over = TRUE;
  else
		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
		thread(f_music_e1m3_vignette_start());
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e1m3_vin_sfx_intro', NONE, 1);
		ai_enter_limbo(gr_ff_all);
		wake(vo_e1m3_intro);
		cinematic_start();
		pup_play_show(e1_m3_narrative_in_v2);
	end
	sleep_until((b_e1m3_narrative_in_over == TRUE), 1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	cinematic_stop();	
	firefight_mode_set_player_spawn_suppressed(FALSE);
	sleep_s(1);
	sleep_until(b_players_are_alive(), 1);
		sleep_s(0.5);
	fade_in(0,0,0,15);
	ai_place(sq_e1_m3_intro_pawns);
	ai_exit_limbo(gr_ff_all);
	thread(f_music_e1m3_vignette_stop());
	thread(f_e1_m3_gen_guards1_spawn());
	wake(vo_e1m3_hitjammer);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	b_end_player_goal = TRUE;
	f_new_objective(e1m3_obj01a);
end

script static void f_e1_m3_gen_guards1_spawn
	sleep_until(volume_test_players(t_spawn_gen_guards), 1);
	thread(f_music_e1m3_guards_spawn());
	object_cannot_take_damage(e1_m3_tower);
	ai_erase(squads_0);
	thread(f_hold_for_1st_point());
	thread(f_2nd_wave());
	thread(f_e1m3_arrived_at_low_jammer());
end

script static void f_2nd_wave
	sleep_until(volume_test_players(t_2nd_Wave), 1);
	thread(f_music_e1m3_second_wave());
	ai_set_objective(gr_ff_all, obj_survival);
	ai_place_in_limbo(sq_e1_m3_gen_guards1);
	ai_place_in_limbo(sq_e1_m3_gen_guards2);
	ai_place_with_shards(sq_e1_m3_gen_guards3, 2);
	sleep_s(5);
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(sq_e1_m3_gen_guards4, 2);
	else
		ai_place_with_shards(sq_e1_m3_gen_guards4, 3);
	end
end

script static void f_e1m3_arrived_at_low_jammer
	sleep_until(LevelEventStatus("e1m3_arrived_at_jammer"), 1);
	thread(f_music_e1m3_destroy_comm());
	wake(vo_e1m3_nearjammer);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	sleep_s(1);
	sleep_until(ai_living_count(gr_ff_all) <= 5, 1);
	sleep_s(1);
	ai_set_objective(gr_ff_all, obj_survival);
	f_new_objective(e1m3_obj01);
	b_end_player_goal = TRUE;
	device_set_power(dc_switch04, 1);
end

script static void f_hold_for_1st_point
	sleep_until(device_get_position(dc_switch04) > 0, 1);
	device_set_power(dc_switch04, 0);
	e1m3_panel_switch04->SetDerezWhenActivated();
	sleep_until(device_get_position(e1m3_panel_switch04) == 1, 1);
	sound_impulse_start('sound\storm\objects\spartan_ops_shared\machine_19_spire_base_terminal_derez', e1m3_panel_switch04, 1 ); //AUDIO!
	object_dissolve_from_marker(e1m3_panel_switch04, phase_out, panel);
	sleep_s(1);
	sound_impulse_start ('sound\environments\multiplayer\forts\machines\new_machines\machine_18_fore_communication_tower_derez', e1_m3_tower, 1 ); //AUDIO!
	object_dissolve_from_marker(e1_m3_tower, "phase_out", "spawn_debris_04");
	sleep_s(1);
	thread(f_music_e1m3_hold_for_first_point());
	wake(vo_e1m3_jammerdown);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	object_destroy(dc_switch04);
	object_destroy(e1m3_panel_switch04);
	object_destroy(e1_m3_tower);
	thread(f_music_e1m3_first_tower());
	thread(f_move_switch_towers());
	wake(vo_e1m3_go1sttower);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	
	//b_end_player_goal = TRUE;  //<--- moved this to narrative
	
	f_new_objective(e1m3_obj02);
	sleep_s(1);
	ai_place_in_limbo(sq_e1_m3_entry_pawns1);
	ai_place_in_limbo(sq_e1_m3_entry_pawns2);
	sleep_s(5);
	wake(vo_e1m3_prometheans);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
end

script static void f_move_switch_towers // moving and setting up switches
	sleep_until(LevelEventStatus("activate_sub_switch"), 1);
	thread(f_music_e1m3_move_switch_towers());
	device_set_power(dc_switch01, 1);
	device_set_power(dc_switch02, 1);
	thread(f_switch1_guards());
	thread(f_switch2_guards());
	thread(f_empty_guards());
	thread(e1m3_switch01_a());
	thread(e1m3_switch01_b());
	thread(e1m3_switch01_c());
	thread(f_switch_3_ready());
	thread(f_e1_m3_mid_bishop_attack());
	ai_jump_cost_scale(1.5);
end
//-----------------------------------------------------------------------
//-------- Starting Mission stuff END -----------------------------------
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//-------- Switch 1 area BEGIN ------------------------------------------
//-----------------------------------------------------------------------
script static void f_switch1_guards  //guards spawned at the 1st switch
	sleep_until(volume_test_players(t_e1_m3_switch1), 1);
	thread(f_music_e1m3_switch1_guards());
	thread(f_switch1_guards_bishop_loop());
	thread(f_switch1_guards_pawn_loop());
	sleep_s(8);
		
	if b_e1m3_turret1 == FALSE then
		thread(f_e1_m3_turret1_online1());
	else
		thread(f_e1_m3_turret1_online2());
	end
	sleep_s(40);
	if switch1_thrown == FALSE then
		wake(vo_e1m3_1sttowerhalf);
	end
	sleep_s(2);
	ai_place_with_shards(sq_turret_switch1);
	ai_kill(e1m3_pawn_starters);
	ai_kill(sq_e1_m3_intro_pawns);
end

script static void f_switch1_guards_bishop_loop()
	effects_perf_armageddon = 0;
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area1_1); 
	sleep_s(0.5);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_1);
	sleep_s(3);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops1);
	sleep_s(0.45);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops1);
//	sleep_s(0.25);
//	ai_place_in_limbo(sq_e1_m3_switch1_bishops1);
	f_e1_m3_watcher_global1();
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area1_1);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_1);
	
	sleep_until(ai_living_count(sq_e1_m3_switch1_bishops) <= 0, 1);
	sleep_rand_s(2,4);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area1_2); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_2);
	sleep_s(3);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops2);
	sleep_s(0.25);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops2);
	sleep_s(0.45);
	ai_place_in_limbo(sq_e1_m3_switch1_bishops2);
//	sleep_s(0.25);
//	ai_place_in_limbo(sq_e1_m3_switch1_bishops2);
	sleep_s(3);
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area1_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_2);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area1_2);
	effects_perf_armageddon = 1;
end

script static void f_switch1_guards_pawn_loop()
  begin_random_count(2)
		ai_place_with_shards(sq_e1_m3_switch1_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns4, 3);
	end
	sleep_until(ai_living_count(sq_e1_m3_switch1_guards_pawns) >= 1, 1);
	sleep_until(ai_living_count(sq_e1_m3_switch1_guards_pawns) <= 0, 1);
  begin_random_count(2)
		ai_place_with_shards(sq_e1_m3_switch1_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns4, 3);
	end
	sleep_until(ai_living_count(sq_e1_m3_switch1_guards_pawns) >= 1, 1);
	sleep_until(ai_living_count(sq_e1_m3_switch1_guards_pawns) <= 0, 1);
	begin_random_count(1)
		ai_place_with_shards(sq_e1_m3_switch1_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch1_pawns4, 3);
	end
end

script static void f_e1_m3_turret1_online1
	b_e1m3_turret1 = TRUE;
	sleep_until(ai_not_in_limbo_count(sq_turret_switch1) >= 1, 1);
	b_e1m3_turret1_up = TRUE;
	wake(vo_e1m3_turretdeploy);
end

script static void f_e1_m3_turret1_online2
	b_e1m3_turret1 = TRUE;
	sleep_until(ai_not_in_limbo_count(sq_turret_switch1) >= 1, 1);
	b_e1m3_turret1_up = TRUE;
	wake(vo_e1m3_2ndturretwarn);
end
//-----------------------------------------------------------------------
//--------  Switch 1 area END -------------------------------------------
//-----------------------------------------------------------------------


//-----------------------------------------------------------------------
//--------  Switch 2 area BEGIN -----------------------------------------
//-----------------------------------------------------------------------
script static void f_switch2_guards  //guards spawned at the 2nd switch
	sleep_until(volume_test_players(t_e1_m3_switch2), 1);
	thread(f_music_e1m3_switch2_guards());
	thread(f_switch2_guards_bishop_loop());
	thread(f_switch2_guards_pawn_loop());
	thread(f_break_switch2_upper_guards());
	sleep_s(3);
	if b_e1m3_turret1 == FALSE then
		thread(f_e1_m3_turret2_online1());
	else
		thread(f_e1_m3_turret2_online2());
	end
	sleep_s(2);
	ai_place_with_shards(sq_turret_switch2);
	ai_kill(e1m3_pawn_starters);
	ai_kill(sq_e1_m3_intro_pawns);
end

script static void f_switch2_guards_bishop_loop()
	effects_perf_armageddon = 0;
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area2_1); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_1);
	sleep_s(3);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops1);
	sleep_s(0.45);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops1);
//	sleep_s(0.25);
//	ai_place_in_limbo(sq_e1_m3_switch2_bishops1);
	f_e1_m3_watcher_global2();
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area2_1);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_1);
	effects_perf_armageddon = 1;
	sleep_until(ai_living_count(sq_e1_m3_switch2_bishops) <= 0, 1);
	effects_perf_armageddon = 0;
	sleep_rand_s(2,4);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area2_2); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_2);
	sleep_s(3);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops2);
	sleep_s(0.25);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops2);
	sleep_s(0.45);
	ai_place_in_limbo(sq_e1_m3_switch2_bishops2);
//	sleep_s(0.25);
//	ai_place_in_limbo(sq_e1_m3_switch2_bishops2);
	sleep_s(3);
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area2_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_2);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area2_2);
	effects_perf_armageddon = 1;
end

script static void f_switch2_guards_pawn_loop()
  begin_random_count(2)
		ai_place_with_shards(sq_e1_m3_switch2_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns4, 3);
	end
	sleep_until(ai_living_count(sq_e1_m3_switch2_guards_pawns) >= 1, 1);
	sleep_until(ai_living_count(sq_e1_m3_switch2_guards_pawns) <= 0, 1);
  begin_random_count(2)
		ai_place_with_shards(sq_e1_m3_switch2_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns4, 3);
	end
	sleep_until(ai_living_count(sq_e1_m3_switch2_guards_pawns) >= 1, 1);
	sleep_until(ai_living_count(sq_e1_m3_switch2_guards_pawns) <= 0, 1);
	begin_random_count(1)
		ai_place_with_shards(sq_e1_m3_switch2_pawns1, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns2, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns3, 3);
		ai_place_with_shards(sq_e1_m3_switch2_pawns4, 3);
	end
end

script static void f_e1_m3_turret2_online1
	b_e1m3_turret1 = TRUE;
	sleep_until(ai_not_in_limbo_count(sq_turret_switch2) >= 1, 1);
	b_e1m3_turret2_up = TRUE;
	wake(vo_e1m3_turretdeploy);
end

script static void f_e1_m3_turret2_online2
	b_e1m3_turret1 = TRUE;
	sleep_until(ai_not_in_limbo_count(sq_turret_switch2) >= 1, 1);
	b_e1m3_turret2_up = TRUE;
	wake(vo_e1m3_2ndturretwarn);
end

script static void f_break_switch2_upper_guards
	sleep_until (volume_test_players(t_switch_2_release), 1);
	thread(f_music_e1m3_switch2_upper_guards());
	wake(vo_e1m3_2ndtowerhalf);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
end
//-----------------------------------------------------------------------
//--------  Switch 2 area END -------------------------------------------
//-----------------------------------------------------------------------


//-----------------------------------------------------------------------
//--------  EMPTY area BEGIN --------------------------------------------
//-----------------------------------------------------------------------
script static void f_empty_guards()  //guards spawned at the empty area with no switch
	sleep_until(switch1_thrown == TRUE or switch2_thrown == TRUE, 1);
	repeat
		sleep_until(volume_test_players(t_e1_m3_3rdarea), 1);
		if sleep_until(ai_living_count(gr_ff_all) <= 10, 1) and b_e1_m3_final_wave == FALSE then
			thread (f_music_e1m3_empty_area_guards());
				effects_perf_armageddon = 0;
				effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area3_1); 
				sleep_s(0.5);
				effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area3_1);
				sleep_s(3);
				ai_place_in_limbo(sq_e1_m3_empty_bishops);
				sleep_s(0.25);
				ai_place_in_limbo(sq_e1_m3_empty_bishops);
				sleep_s(0.45);
				ai_place_in_limbo(sq_e1_m3_empty_bishops);
//				sleep_s(0.25);
//				ai_place_in_limbo(sq_e1_m3_empty_bishops);
				sleep_s(3);
				effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_portal_area3_1);
				sleep_s(1.5);
				effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area3_1);
				effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_portal_area3_1);
			b_e1m3_empty_guards = TRUE;
			effects_perf_armageddon = 1;
			begin_random_count(2)
				ai_place_with_shards(sq_e1_m3_empty_lower1, 3);
				ai_place_with_shards(sq_e1_m3_empty_lower2, 3);
				ai_place_with_shards(sq_e1_m3_empty_lower3, 3);
			end
		end
	until(b_e1m3_empty_guards == TRUE);
end

//-----------------------------------------------------------------------
//--------  Empty area END ----------------------------------------------
//-----------------------------------------------------------------------
script static void f_e1_m3_mid_bishop_attack()
	sleep_until(switch1_thrown == TRUE or switch2_thrown == TRUE, 1);
	repeat
		sleep_until(volume_test_players(t_e1_m3_mid_bishop_launch), 1);
		if sleep_until(ai_living_count(gr_ff_all) <= 10, 1) then
			if b_e1m3_mid_guards == FALSE then
				effects_perf_armageddon = 0;
				effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_mid_bishop_1); 
				sleep_s(0.5);
				effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_mid_bishop_1);
				sleep_s(3);
				ai_place_in_limbo(sq_e1_m3_mid_bishop);
				sleep_s(0.25);
				ai_place_in_limbo(sq_e1_m3_mid_bishop);
//				sleep_s(0.45);
//				ai_place_in_limbo(sq_e1_m3_mid_bishop);
//				sleep_s(0.25);
//				ai_place_in_limbo(sq_e1_m3_mid_bishop);
				f_e1_m3_watcher_global3();
				sleep_s(3);
				effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_mid_bishop_1);
				sleep_s(1.5);
				effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_mid_bishop_1);
				effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_mid_bishop_1);
				effects_perf_armageddon = 1;
				b_e1m3_mid_guards = TRUE;
				sleep_s(1);
				if ai_living_count(gr_ff_all) <= 8 then
					if game_difficulty_get_real() <= normal then
						ai_place_with_shards(sq_e1_m3_mid_pawns, 3);
					else
						ai_place_with_shards(sq_e1_m3_mid_pawns, 4);
					end
				end
			end
		end
	until(switch1_thrown == TRUE and switch2_thrown == TRUE);
end	

//-----------------------------------------------------------------------
//--------  Switch stuff ------------------------------------------------
//-----------------------------------------------------------------------
//	//	//	Switch E1 M3 01 -----------------------------------------------------------------------------
script static void  e1m3_switch01_a()
	sleep_until(object_valid(dc_switch01) and (device_get_position(dc_switch01) > 0.0), 1 );
	device_set_power(dc_switch01, 0);
	sound_impulse_start ( 'sound\environments\multiplayer\forts\machines\new_machines\machine_19_forts_energy_core_beam_deactivate', dm_forts_e3_01, 1 ); //AUDIO!
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_top_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_topArch_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_bottom_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_bottom_mkr_02);
	thread(f_e1m3_dissolve_Switch01());
	thread(f_music_e1m3_switch1_thrown());
	sleep_until(device_get_position(dm_forts_e3_01) == 1, 1);
	switch1_thrown = TRUE;
	kill_script(f_switch1_guards_pawn_loop);
	f_create_new_spawn_folder(97);
	if e1m3_switch_line_1_played == FALSE then
		wake(vo_e1m3_1sttowerclear);
		e1m3_switch_line_1_played = TRUE;
		sleep_s(1);
		sleep_until((e1m3_narrative_is_on == FALSE), 1);
	else
		wake(vo_e1m3_2ndtowerdeactivate);
		sleep_s(1);
		sleep_until((e1m3_narrative_is_on == FALSE), 1);
		f_new_objective(e1m3_obj03);
		b_end_player_goal = TRUE;
		thread(f_e1m3_at_top_switch());
		sleep_s(20);
		wake(vo_e1m3_target3enroute);
	end
end

script static void f_e1m3_dissolve_Switch01()
	e1m3_panel_switch01->SetDerezWhenActivated();
	sleep_until(device_get_position(e1m3_panel_switch01) == 1, 1);
	sound_impulse_start ( 'sound\storm\objects\spartan_ops_shared\machine_19_spire_base_terminal_derez', e1m3_panel_switch01, 1 ); //AUDIO!
	object_dissolve_from_marker(e1m3_panel_switch01, phase_out, panel);
	sleep_s(4);
	object_destroy(dc_switch01);
	object_destroy(e1m3_panel_switch01);
end

script static void f_e1m3_at_top_switch()
	sleep_until(LevelEventStatus("e1m3_at_top_switch"), 1);
	device_set_power(dc_switch03, 1);
	wake(vo_e1m3_target3arrive);
end

//	//	//	Switch E1 M3 02 -----------------------------------------------------------------------------
script static void e1m3_switch01_b()
	sleep_until(object_valid(dc_switch02) and (device_get_position(dc_switch02) > 0.0), 1);
	device_set_power(dc_switch02, 0);
	sound_impulse_start ( 'sound\environments\multiplayer\forts\machines\new_machines\machine_19_forts_energy_core_beam_deactivate', dm_forts_e3_02, 1 ); //AUDIO!
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_top_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_topArch_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_bottom_mkr_01);
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_bottom_mkr_02);
	thread(f_e1m3_dissolve_Switch02());
	thread(f_music_e1m3_switch2_thrown());
	sleep_until(device_get_position(dm_forts_e3_02) == 1, 1);
	switch2_thrown = TRUE;
	kill_script(f_switch2_guards_pawn_loop);
	f_create_new_spawn_folder(97);
	thread(f_e1_m3_mid_bishop_attack());
	if e1m3_switch_line_1_played == FALSE then
		wake(vo_e1m3_1sttowerclear);
		e1m3_switch_line_1_played = TRUE;
		sleep_s(1);
		sleep_until((e1m3_narrative_is_on == FALSE), 1);
	else
		wake(vo_e1m3_2ndtowerdeactivate);
		sleep_s(1);
		sleep_until((e1m3_narrative_is_on == FALSE), 1);
		f_new_objective(e1m3_obj03);
		b_end_player_goal = TRUE;
		thread(f_e1m3_at_top_switch());
		sleep_s(20);
		wake(vo_e1m3_target3enroute);
	end
end

script static void f_e1m3_dissolve_Switch02()
	e1m3_panel_switch02->SetDerezWhenActivated();
	sleep_until(device_get_position(e1m3_panel_switch02) == 1, 1);
	sound_impulse_start('sound\storm\objects\spartan_ops_shared\machine_19_spire_base_terminal_derez', e1m3_panel_switch02, 1 ); //AUDIO!
	object_dissolve_from_marker(e1m3_panel_switch02, phase_out, panel);
	sleep_s(4);
	object_destroy(dc_switch02);
	object_destroy(e1m3_panel_switch02);
end

//	//	//	Switch E1 M3 03 -----------------------------------------------------------------------------
script static void e1m3_switch01_c()
	sleep_until(object_valid(dc_switch03) and (device_get_position(dc_switch03) > 0.0), 1);
	device_set_power(dc_switch03, 0);
	thread(f_e1m3_dissolve_Switch03());
	device_set_position(dm_forts_e3_03a, 1);
	sleep_s(5);
	sound_impulse_start('sound\environments\multiplayer\forts\machines\new_machines\machine_19_forts_energy_core_beam_deactivate', e1_m3_composer_sfx, 1 ); //TEMP AUDIO!
	effect_kill_from_flag(levels\firefight\ff90_fortsw\fx\energycore\composer_shield.effect, arch_center_mkr_01);
	sleep_s(2);
	wake(vo_e1m3_3rdtowerdeactivate);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	
//	b_end_player_goal = TRUE; //<-- moved to narrative
//	f_new_objective(e1m4_obj03);

	thread(f_e1m3_clear_evac());
end

script static void f_e1m3_dissolve_Switch03()
	e1m3_panel_switch03->SetDerezWhenActivated();
	sleep_until(device_get_position(e1m3_panel_switch03) == 1, 1);
	sound_impulse_start ( 'sound\storm\objects\spartan_ops_shared\machine_19_spire_base_terminal_derez', e1m3_panel_switch03, 1 ); //AUDIO!	
	object_dissolve_from_marker(e1m3_panel_switch03, phase_out, panel);
	sleep_s(4);
	object_destroy(dc_switch03);
	object_destroy(e1m3_panel_switch03);
end

script static void f_e1m3_clear_evac
	sleep_until(LevelEventStatus("e1m3_clear_evac_now"), 1);
	wake(vo_e1m3_secureevac);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	f_new_objective(e1m3_obj05);
end
//-----------------------------------------------------------------------
//--------  Switch stuff END --------------------------------------------
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//--------  Switch 3 stuff ----------------------------------------------
//-----------------------------------------------------------------------
script static void f_switch_3_ready
	sleep_until((switch1_thrown == TRUE) and (switch2_thrown == TRUE), 1);
	thread(f_music_e1m3_switch_3_ready());
	thread(f_central_base_spawn1());
	thread(f_central_base_spawn2());
	ai_set_objective(gr_ff_all, obj_survival);
end
//-----------------------------------------------------------------------
//--------  Switch 3 stuff END ------------------------------------------
//-----------------------------------------------------------------------


//-----------------------------------------------------------------------
//--------  Central Base stuff ------------------------------------------
//-----------------------------------------------------------------------
script static void f_central_base_spawn1
	sleep_until((volume_test_players(t_base_1) or volume_test_players(t_base_3)), 1);
	if ai_living_count(gr_ff_all) <= 18 then
		thread(f_music_e1m3_central_base_spawn1());
		ai_place_in_limbo(sq_e1_m3_cb_1);
	end
end

script static void f_central_base_spawn2
	sleep_until((volume_test_players(t_base_2) or volume_test_players(t_base_3)), 1);
	thread (f_music_e1m3_central_base_spawn2());
	if ai_living_count(gr_ff_all) <= 16 then
		ai_place_in_limbo(sq_e1_m3_cb_2);
		sleep_until(ai_not_in_limbo_count(sq_e1_m3_cb_2) >= 1, 1);
		cs_custom_animation(sq_e1_m3_cb_2.pp1, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
		cs_custom_animation(sq_e1_m3_cb_2.pp2, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	else
		ai_set_objective(gr_ff_all, obj_cb_top_level);
	end
	sleep_s(1);
	if ai_living_count(gr_ff_all) <= 14 then
		effects_perf_armageddon = 0;
		effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_knight_dad_1); 
		sleep_s(0.5);
		effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_knight_dad_1);
		sleep_s(3);
		ai_place_in_limbo(sq_knight_dad);
		sleep_s(3);
		effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_knight_dad_1);
		sleep_s(1.5);
		effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_knight_dad_1);
		effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_knight_dad_1);
		effects_perf_armageddon = 1;
	else
		ai_set_objective(gr_ff_all, obj_cb_top_level);
	end
	sleep_s(2);
	if ai_living_count(gr_ff_all) <= 14 then
		if game_difficulty_get_real() <= normal then
			ai_place_with_shards(sq_base_mid_pawns, 3);
		else
			ai_place_with_shards(sq_base_mid_pawns, 4);
		end
	end
	thread(f_top_knights());
	thread(f_get_to_wave());
	thread(f_last_stand_wave());
end

script static void f_top_knights
	sleep_until(volume_test_players(t_base_4), 1);
	thread(f_music_e1m3_top_knights());
	if ai_living_count(gr_ff_all) <= 17 then
		effects_perf_armageddon = 0;
		effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_top_level_bishop_1); 
		sleep_s(0.5);
		effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_top_level_bishop_1);
		sleep_s(3);
		ai_place_in_limbo(sq_top_level_bishops);
		sleep_s(0.25);
		ai_place_in_limbo(sq_top_level_bishops);
//		sleep_s(0.45);
//		ai_place_in_limbo(sq_top_level_bishops);
		f_e1_m3_watcher_global4();
		sleep_s(3);
		effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_top_level_bishop_1);
		sleep_s(1.5);
		effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_top_level_bishop_1);
		effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_top_level_bishop_1);
		effects_perf_armageddon = 1;
	else
		ai_set_objective(gr_ff_all, obj_top_level);
	end
	if ai_living_count(gr_ff_all) <= 14 then
		if game_difficulty_get_real() <= normal then
			ai_place_with_shards(sq_top_level_pawns, 3);
		else
			ai_place_with_shards(sq_top_level_pawns, 5);
		end
	end
end

//-----------------------------------------------------------------------
//--------  Central Base stuff END --------------------------------------
//-----------------------------------------------------------------------


//-----------------------------------------------------------------------
//--------  Last few Objective stuff  -----------------------------------
//-----------------------------------------------------------------------
script static void f_get_to_wave
	sleep_until(LevelEventStatus("e1_m3_4th_wave"), 1);
	b_e1_m3_final_wave = TRUE;
	thread (f_music_e1m3_4th_wave());
	//f_new_objective(e1m3_obj04);
	ai_set_objective(gr_ff_all, obj_survival);
	if ai_living_count(gr_ff_all) <= 18 then
		ai_place_in_limbo(sq_bottom_knight_1);
		sleep_until(ai_not_in_limbo_count(sq_bottom_knight_1) >= 1, 1);
		cs_custom_animation(sq_bottom_knight_1.pp1, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
		cs_custom_animation(sq_bottom_knight_1.pp2, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	end
	sleep_rand_s (0.5, 4);
	if ai_living_count(gr_ff_all) <= 18 then
		ai_place_in_limbo(sq_bottom_pawns_1);
	end
	sleep_rand_s (0.5, 4);
	if ai_living_count(gr_ff_all) <= 17 then
		ai_place_in_limbo(sq_bottom_pawns_2);
	end
end

script static void f_last_stand_wave()
	sleep_until(LevelEventStatus("e1_m3_last_stand"), 1);
	ai_set_objective(gr_ff_all, obj_survival);
	thread(f_music_e1m3_last_stand());
	//ai_kill(sq_turret_switch1);
	unit_kill(ai_vehicle_get(sq_turret_switch1.turret1));
	//ai_kill(sq_turret_switch2);
	unit_kill(ai_vehicle_get(sq_turret_switch2.turret2));
	kill_script(f_switch1_guards_bishop_loop);
	kill_script(f_switch2_guards_bishop_loop);
	kill_script(f_e1_m3_mid_bishop_attack);
	kill_script(f_empty_guards);
	sleep_s(3);
	if ai_living_count(gr_ff_all) <= 17 then
		ai_place_in_limbo(sq_last_stand_knight_1);
		ai_place_in_limbo(sq_last_stand_knight_2);
		ai_place_in_limbo(sq_last_stand_knight_3);
	end
	sleep_s(3);
	ai_set_objective(gr_ff_all, obj_survival);
	vo_glo_remainingproms_05();
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_ff_all) <= 10, 1);
	//f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	effects_perf_armageddon = 0;
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_1); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_1);
	sleep_s(3);
	ai_place_in_limbo(sq_last_stand_bishop_1.b1_1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_last_stand_bishop_1.b1_2);
	sleep_s(0.45);
	ai_place_in_limbo(sq_last_stand_bishop_1.b1_3);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_1);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_1);
	effects_perf_armageddon = 1;
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(sq_last_stand_pawn_1, 4);
		ai_place_with_shards(sq_last_stand_knight_1);
	else
		ai_place_with_shards(sq_last_stand_pawn_1, 6);
		ai_place_with_shards(sq_last_stand_knight_1);
	end
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_s(6);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_until(ai_living_count(sq_last_stand_bishop_1) <= 0, 1);
	sleep_until(ai_living_count(gr_ff_all) <= 10, 1);
	sleep_s(1);
	effects_perf_armageddon = 0;
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_2); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_2);
	sleep_s(3);
	ai_place_in_limbo(sq_last_stand_bishop_1.b2_1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_last_stand_bishop_1.b2_2);
//	sleep_s(0.45);
//	ai_place_in_limbo(sq_last_stand_bishop_1.b2_3);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_2);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_2);
	effects_perf_armageddon = 1;
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(sq_last_stand_pawn_2, 4);
		ai_place_with_shards(sq_last_stand_knight_2);
	else
		ai_place_with_shards(sq_last_stand_pawn_2, 6);
		ai_place_with_shards(sq_last_stand_knight_2);
	end
	f_e1_m3_ordnance_global_vo11();
	sleep_s(2);
	ordnance_drop(f_e1_m3_ord_1, "storm_rocket_launcher");  //<------------dropping ord, line needed
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_s(1);
	vo_glo_gotit_01();
	sleep_s(6);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_until(ai_living_count(sq_last_stand_bishop_1) <= 0, 1);
	sleep_until(ai_living_count(gr_ff_all) <= 10, 1);
	sleep_s(1);
	effects_perf_armageddon = 0;
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_3); 
	sleep_s(0.5);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_3);
	sleep_s(3);
	ai_place_in_limbo(sq_last_stand_bishop_1.b3_1);
	sleep_s(0.25);
	ai_place_in_limbo(sq_last_stand_bishop_1.b3_2);
	sleep_s(0.45);
	ai_place_in_limbo(sq_last_stand_bishop_1.b3_3);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, f_e1_m3_last_stand_3);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_3);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, f_e1_m3_last_stand_3);
	effects_perf_armageddon = 1;
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(sq_last_stand_pawn_3, 4);
		ai_place_with_shards(sq_last_stand_knight_3);
	else
		ai_place_with_shards(sq_last_stand_pawn_3, 6);
		ai_place_with_shards(sq_last_stand_knight_3);
	end
	f_e1_m3_ordnance_global_vo12();
	sleep_s(2);
	ordnance_drop(f_e1_m3_ord_2, "storm_rocket_launcher");  //<------------dropping ord, line needed
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_s(1);
	vo_glo_gotit_03();
	sleep_s(6);
	sleep_until(ai_living_count(gr_ff_all) <= 12, 1);
	ai_place_in_limbo(sq_last_stand_pawn_2);
	sleep_s(2);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_s(1);
	sleep_until(ai_living_count(gr_ff_all) <= 0, 1);
	thread(f_music_e1m3_pelican_fly_in());
	ai_place(sq_pelican_e1_m3);
	sleep_s(2);
	f_blip_object(sq_pelican_e1_m3, "navpoint_goto");
	wake(vo_e1m3_evacsecured);
	sleep_s(1);
	sleep_until((e1m3_narrative_is_on == FALSE), 1);
	sleep_s(6);
	thread(f_e1_m3_pelican_trigger());
end

script static void f_e1_m3_pelican_trigger
	sleep_until(volume_test_players(t_e1_m3_pelican), 1);
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	sleep_s(1);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	sleep_s(1);
	b_end_player_goal = TRUE;
	thread (f_music_e1m3_finish());
end

//-----------------------------------------------------------------------
//--------  Last few Objective stuff END --------------------------------
//-----------------------------------------------------------------------



//-----------------------------------------------------------------------
//--------  Global call outs --------------------------------
//-----------------------------------------------------------------------
script static void f_e1_m3_ordnance_global_vo11()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_ordnance_01();
		vo_glo_ordnance_02();
	end
	e1m3_narrative_is_on = FALSE;
end

script static void f_e1_m3_ordnance_global_vo12()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_ordnance_04();
		vo_glo_ordnance_05();
	end
	e1m3_narrative_is_on = FALSE;
end

script static void f_e1_m3_watcher_global1()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_watchers_01();
		vo_glo_watchers_02();
		vo_glo_watchers_03();
	end
	e1m3_narrative_is_on = FALSE;
end

script static void f_e1_m3_watcher_global2()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_watchers_04();
		vo_glo_watchers_05();
		vo_glo_watchers_06();
	end
	e1m3_narrative_is_on = FALSE;
end

script static void f_e1_m3_watcher_global3()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_watchers_07();
		vo_glo_watchers_08();
	end
	e1m3_narrative_is_on = FALSE;
end

script static void f_e1_m3_watcher_global4()
	sleep_until(e1m3_narrative_is_on == FALSE, 1);
	e1m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_watchers_09();
		vo_glo_watchers_10();
	end
	e1m3_narrative_is_on = FALSE;
end

script command_script cs_e1_m3_pelican()
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE); 
 	cs_fly_by (ps_e1m3_evac.p0);
 	cs_fly_by (ps_e1m3_evac.p1);
  cs_vehicle_speed (.6); 
	sleep_s (1.5);
  cs_fly_to_and_face (ps_e1m3_evac.p2, ps_e1m3_evac.p3);
end