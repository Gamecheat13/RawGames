// =============================================================================================================================
//========= CATHEDRAL FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================
// =============================================================================================================================
// This is E5 M2 in game: "Nothing Can Go Wrong"

//========= GLOBAL===================================================================
global boolean e5_m1_jammer_is_up_so_stop = FALSE;
global boolean b_e5m1_narrative_in_over = FALSE;
global boolean b_e5m1_sensors_defended = FALSE;
global boolean b_e5m1_sensors_destroyed = FALSE;
global short e5_m1_knight_wave_count = 1;

// =============================================================================================================================
// ================================================== TITLES ==================================================================
//== startup
script startup courtyard_e5_m1
	sleep_until(LevelEventStatus("is_e5_m1"), 1);
	fade_out(0,0,0,0);
	switch_zone_set(e5_m1);
	thread(f_music_e5m1_mission_start()); 
	firefight_mode_set_player_spawn_suppressed(TRUE);
	ai_ff_all = e5m1_all;
	ai_defend_all = e5_m1_defend_all;
	local ai obj_survival = e5_m1_survival;

//== load objects ==================================================================
	sleep_s(1);																										//tjp
	object_destroy(e3m5_tower_base);															//tjp
	object_destroy(e3m5_watchtower_pod);													//tjp
	f_add_crate_folder(e5_m1_unsc_stuff);
	f_add_crate_folder(e5_m1_mission_stuff);
	f_add_crate_folder(e5_m1_weapon_crates);
	f_add_crate_folder(e5_m1_vehicles);
	f_add_crate_folder(e5_m1_defend_base_1);
	f_add_crate_folder(e5_m1_defend_base_2);
	f_add_crate_folder(e5_m1_jammer_stuff);
	f_add_crate_folder(e5_m1_controls);
	f_add_crate_folder(e5_m1_dms);
	f_add_crate_folder(e_e5_m1_ammmo_crate);
	
	firefight_mode_set_crate_folder_at(e5_m1_spawn_points_0, 90);
	firefight_mode_set_crate_folder_at(e5_m1_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(e5_m1_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(e5_m1_spawn_points_3, 93);
	
	firefight_mode_set_objective_name_at(e5_m1_tower_1, 1);
	firefight_mode_set_objective_name_at(e5_m1_tower_2, 2);
	firefight_mode_set_objective_name_at(e5_m1_scanner_switch_1, 11);
	firefight_mode_set_objective_name_at(e5_m1_scanner_switch_2, 12);
	firefight_mode_set_objective_name_at(e5_m1_scanner_switch_3, 13);

	firefight_mode_set_objective_name_at(e5_m1_lz_0, 50);
	firefight_mode_set_objective_name_at(e5_m1_lz_1, 51);

	thread (f_start_events_e5_m1_1());
	sleep_s(1);
	fade_in(0,0,0,30);

	ai_jump_cost_scale(2.75);
	kill_volume_disable(kill_air);
	kill_volume_disable(kill_air_2);
	kill_volume_disable(kill_megazon_a);
	kill_volume_disable(kill_megazon_b);
	kill_volume_disable(kill_megazon_c);
	kill_volume_disable(kill_megazon_d);
	kill_volume_disable(kill_megazon_e);
	kill_volume_disable(kill_megazon_f);
end

script command_script cs_pawn_spawn_e5_m1
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script f_knight_spawn_e5_m1
	cs_phase_in_blocking();
end

script command_script cs_bishop_spawn_e5_m1
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1); 		//Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	sleep(40);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);			 //grow size over time
end

script static void f_start_events_e5_m1_1
	if editor_mode() then
		//print("editor mode, not playing intro");
		b_e5m1_narrative_in_over = TRUE;
	else
		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
		ai_enter_limbo(e5m1_all);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m1_vin_sfx_intro', NONE, 1);
		cinematic_start();
		e5_m1_intro();
	end
	sleep_s(1);
	sleep_until(b_e5m1_narrative_in_over == TRUE, 1);
	cinematic_stop();
	firefight_mode_set_player_spawn_suppressed(FALSE);
	sleep_s(0.5);
	sleep_until((e5m1_narrative_is_on == FALSE), 1);
	sleep_until(b_players_are_alive(), 1);
	sleep_s(0.5);
	fade_in (0,0,0,15);
	ai_exit_limbo(e5m1_all);
	device_set_power(e5_m1_scanner_switch_1, 0);
	device_set_power(e5_m1_scanner_switch_2, 0);
	device_set_power(e5_m1_scanner_switch_3, 0);
	object_cannot_take_damage(e5_m1_jammer_1);
	object_cannot_take_damage(e5_m1_jammer_2);
	object_cannot_take_damage(e5_m1_tower_1);
	object_cannot_take_damage(e5_m1_tower_2);
	object_destroy(e5_m1_portal_blocker1);
	object_destroy(e5_m1_portal_blocker2);
	object_destroy(e5_m1_portal_blocker3);
	object_destroy(e5_m1_portal_blocker4);
	sleep_s(1);
	thread(f_music_e5m1_playstart_vo()); 
	wake(e5m1_vo_playstart);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_set_objective_1_set()); 
	f_new_objective(e5_m1_obj_01);
	b_end_player_goal = TRUE;
	thread(f_e5_m1_prometheans_attack());
end
	
script static void f_e5_m1_prometheans_attack
	sleep_until(LevelEventStatus("e5_m1_at_point"), 1);
	
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal1); 
	sleep_s(0.5);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal1);
	sleep_s(1);
	ai_place_in_limbo(e5m1_intro_bishops_1);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal1);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal1);
	
	thread(f_e5_m1_fly_bishop_fly());
	thread(f_e5_m1_prometheans_attack_2());
	sleep_s(1);
	wake(e5m1_vo_noboyhere);
	thread(f_music_e5m1_prometheans_vo());
end

script static void f_e5_m1_fly_bishop_fly
	cs_fly_to(e5m1_intro_bishops_1.intro_bishop_1, TRUE, intro_bishop_points.p0);
	wake(e5m1_vo_prometheans1);
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(e5_m1_pawn_1, 4);
	else
		ai_place_with_shards(e5_m1_pawn_1, 5);
	end
	sleep_s(3);
	thread(f_music_e5m1_set_objective_2_set()); 
	f_new_objective(e5_m1_obj_02);
end

script static void f_e5_m1_prometheans_attack_2
	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
	sleep_until(ai_living_count(e5m1_bishop_1) >= 0, 1);
	sleep_until(ai_living_count(e5m1_bishop_1) <= 0, 1);
	thread(f_music_e5m1_prometheans_encounter_start());
	
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal2_1);
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal2_2);
	sleep_s(0.5);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_1);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_2);
	sleep_s(2);
	ai_place_in_limbo(e5m1_intro_bishops_2);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal2_1);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal2_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_1);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_2);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal2_2);
	
	sleep_s(1);
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(e5_m1_pawn_2, 4);
	else
		ai_place_with_shards(e5_m1_pawn_2, 5);
	end
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(e5_m1_pawn_3, 4);
	else
		ai_place_with_shards(e5_m1_pawn_3, 5);
	end
	sleep_s(2);
	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
	sleep_until(ai_living_count(e5m1_all) <= 3, 1);
	thread(f_music_e5m1_prometheans_encounter_spawn_more());
	
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal3_1);
	effect_new(levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal3_2);
	sleep_s(0.5);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_1);
	effect_new(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_2);
	sleep_s(2);
	ai_place_in_limbo(e5m1_intro_bishops_3);
	sleep_s(3);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal3_1);
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_e5_m1_portal3_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_1);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_2);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_1);
	effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5_m1_portal3_2);
	
	sleep_s(1);
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(e5_m1_pawn_4, 4);
	else
		ai_place_with_shards(e5_m1_pawn_4, 5);
	end
	if game_difficulty_get_real() <= normal then
		ai_place_with_shards(e5_m1_pawn_5, 4);
	else
		ai_place_with_shards(e5_m1_pawn_5, 5);
	end
	sleep_s(4);
	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
	sleep_until(ai_living_count(e5m1_all) <= 4, 1);
	sleep_s(2);
	vo_glo_remainingproms_02();
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	f_blip_ai_cui(e5m1_all, "navpoint_enemy");
	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
	sleep_until(ai_living_count(e5m1_all) <= 0, 1);
	sleep_s(3);
	thread(f_music_e5m1_sitrep_vo()); 
	wake(e5m1_vo_sitrep);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_turnongear_vo()); 
	wake(e5m1_vo_turnongear);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_objective_3_set()); 
	f_new_objective(e5_m1_obj_03);
	
	//b_end_player_goal = TRUE; //<-- moving to narrative
	
	device_set_power(e5_m1_scanner_switch_1, 1);
	device_set_power(e5_m1_scanner_switch_2, 1);
	thread(f_e5_m1_sensors_activated());
	thread(f_e5_m1_one_sensor_on());
	thread(f_spawn_knights_near_scanners());
	thread(f_e5_m1_sensor_1());
	thread(f_e5_m1_sensor_2());
end
	
script static void f_spawn_knights_near_scanners
	sleep_until(volume_test_players(t_e5_m1_near_dishes), 1);
	ai_place_in_limbo(e5_m1_knights_02);
end

script static void f_e5_m1_sensor_1()
	sleep_until(device_get_position(e5_m1_scanner_switch_1) > 0, 1);
	device_set_power(e5_m1_scanner_switch_1, 0);
	thread( f_object_rotate_bounce_y(e5_m1_tower_1, 60.0, 6.00, 2.5, 3.0, 0, f_e5m1_sfx_unsc_comm_tower_rotate_start(), f_e5m1_sfx_unsc_comm_tower_rotate_stop()) );
end

script static void f_e5_m1_sensor_2()
	sleep_until(device_get_position(e5_m1_scanner_switch_2) > 0, 1);
	device_set_power(e5_m1_scanner_switch_2, 0);
	thread( f_object_rotate_bounce_y(e5_m1_tower_2, 60.0, 6.00, 2.5, 3.0, 0, f_e5m1_sfx_unsc_comm_tower_rotate_start(), f_e5m1_sfx_unsc_comm_tower_rotate_stop()) );
end
	
script static void f_e5_m1_one_sensor_on()
	sleep_until((device_get_position(e5_m1_button1_1) == 1) or (device_get_position(e5_m1_button1_2) == 1), 1);
	wake(e5m1_vo_gear1on);
	sleep_s(2);
	ai_place_in_limbo(e5_m1_knights_01);
end

script static void f_e5_m1_sensors_activated()
	sleep_until(LevelEventStatus("e5_m1_sensors_active"), 1);
	sleep_s(2);
	thread(f_music_e5m1_gearalon_vo()); 
	thread(f_e5_m1_scanner_health_diff());
	wake(e5m1_vo_gearallon);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_badguys_vo());
	thread(f_e5_m1_1st_defend_wave());
	sleep_s(5);
	wake(e5m1_vo_badguys1);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	sleep_s(4);
	thread(f_music_e5m1_defendgear_vo()); 
	wake(e5m1_vo_defendgear);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_objective_4_set()); 
	f_new_objective(e5_m1_obj_04);
	b_end_player_goal = TRUE;
	thread(f_e5_m1_defense_lines());
	thread(f_e5_m1_sensors_defended());
	thread(f_e5_m1_lose_condition());
	thread(f_e5_m1_10_wave_forerunners());
	sleep_s(1);
	f_blip_ai_cui(e5m1_all, "navpoint_enemy");
end

script static void f_e5_m1_population_control_1()
	repeat 
		if ai_living_count(e5_m1_knight_01) >= 1 then
			begin_random_count(2)
				ai_kill(e5_m1_knights_01.spawn_points_0);
				ai_kill(e5_m1_knights_01.spawn_points_1);
				ai_kill(e5_m1_knights_01.spawn_points_2);
				ai_kill(e5_m1_knights_01.spawn_points_3);
				ai_kill(e5_m1_knights_01.spawn_points_4);
				ai_kill(e5_m1_knights_01.spawn_points_5);
				ai_kill(e5_m1_knights_02.spawn_points_0);
				ai_kill(e5_m1_knights_02.spawn_points_1);
				ai_kill(e5_m1_knights_02.spawn_points_2);
				ai_kill(e5_m1_knights_02.spawn_points_3);
				ai_kill(e5_m1_knights_02.spawn_points_4);
				ai_kill(e5_m1_knights_02.spawn_points_5);
				ai_kill(e5_m1_knights_02.spawn_points_6);
				ai_kill(e5_m1_knights_02.spawn_points_7);
				ai_kill(e5_m1_knights_02.spawn_points_8);
			end
			sleep_s(1);
		end
	until (ai_living_count(e5_m1_knight_01) == 0);
end

script static void f_e5_m1_defense_lines()
	sleep_s(60);
	if b_e5m1_sensors_destroyed == FALSE then
		wake(e5m1_vo_defend_pause_1);
	end
	
	sleep_s(80);
	
	if b_e5m1_sensors_destroyed == FALSE then
		wake(e5m1_vo_defend_pause_2);
	end
	
	sleep_s(80);
	
	if b_e5m1_sensors_destroyed == FALSE then
		wake(e5m1_vo_defend_pause_3);
	end
	
	sleep_s(80);
	
	if b_e5m1_sensors_destroyed == FALSE then
		wake(e5m1_vo_defend_pause_4);
	end
end

script static void f_e5_m1_sensors_defended()
	sleep_until(LevelEventStatus("e5_m1_sensor_defense_done"), 1);
	b_e5m1_sensors_defended = TRUE;
	ai_prefer_target_team(e5_m1_defend_all, player);
	ai_prefer_target_team(e5m1_all, player);
	ai_object_set_team(obj_defend_1, forerunner);
	object_set_allegiance(obj_defend_1, forerunner);
	ai_object_set_team(obj_defend_2, forerunner);
	object_set_allegiance(obj_defend_2, forerunner);
	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
	ai_set_objective(e5m1_all_knights, e5_m1_survival);
	ai_set_objective(e5_m1_defend_all, e5_m1_survival);
	thread(f_music_e5m1_sensors_defended()); 
	object_cannot_take_damage(e5_m1_tower_1);
	object_cannot_take_damage(e5_m1_tower_2);
	kill_script(f_e5_m1_sensor_1_dead);
	kill_script(f_e5_m1_sensor_2_dead);
	kill_script(f_e5_m1_ammo_respawn);
	wake(e5m1_vo_nice_work);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	sleep_s(4);
	thread(f_music_e5m1_turnondevice_vo()); 
	wake(e5m1_vo_turnondevice);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_objective_5_set()); 
	f_new_objective(e5_m1_obj_05);
	b_end_player_goal = TRUE;
	thread(f_e5_m1_jammer_up());
	thread(f_e5_m1_jammer_on());
	device_set_power(e5_m1_scanner_switch_3, 1);
end

script static void f_e5_m1_jammer_up()
	sleep_until(LeveLEventStatus("e5_m1_jammer_up"), 1);
	sleep_until((e5_m1_jammer_is_up_so_stop == TRUE), 1);
	sleep_s(2);
	if ai_living_count(e5m1_all) >= 0 then
		ai_set_objective(e5m1_all, e5_m1_survival);
		sleep_s(1);
		ai_set_objective(e5m1_all_bishop, e5_m1_obj_bishops);
		if ai_living_count(e5m1_all) <= 15 then
			ai_place_in_limbo(e5_m1_final_commander);
			thread(f_e5_m1_break_commanders());
		end
		thread(f_music_e5m1_blip_enemies_optional()); 
		f_new_objective(e5_m1_obj_06);
		f_blip_ai_cui(e5m1_all, "navpoint_enemy");
		ai_survival_cleanup(e5m1_all, TRUE, TRUE);
		sleep_until(ai_living_count(e5m1_all) <= 0, 1);
	end
	sleep_s(3);
	thread(f_music_e5m1_baddiesdead_vo()); 
	wake(e5m1_vo_baddiesdead);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_portalopen_vo()); 
	wake(e5m1_vo_portalopen);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_objective_7_set()); 
	f_new_objective(e5_m1_obj_07);
	b_end_player_goal = TRUE;
	thread(f_e5_m1_at_portal());
end

script static void f_e5_m1_break_commanders
	sleep_until(volume_test_players(t_e5_m1_break_command), 1);
	ai_set_task(e5m1_knight_commanders, e5_m1_obj_pawn_1, guard);
end

script static void f_e5_m1_jammer_on()
	sleep_until(device_get_position(e5_m1_scanner_switch_3) > 0, 1);
	device_set_power(e5_m1_scanner_switch_3, 0);
	e5_m1_jammer_is_up_so_stop = TRUE;
	thread(f_e5_m1_kill_portal_blockers());
end

script static void f_e5_m1_at_portal()
	sleep_until(LeveLEventStatus("e5_m1_at_portal"), 1);
	sleep_s(1);
	thread(f_music_e5m1_arrive_at_portal());
	device_set_position_track(e5_m1_f_portal, "open:portal", 0.0 );
	device_animate_position(e5_m1_f_portal, 1, 2, 1.0, 1.0, TRUE );
	sleep_s(3);
	thread(f_music_e5m1_getinportal_vo()); 
	wake(e5m1_vo_getinportal);
	sleep_s(1);
	sleep_until(e5m1_narrative_is_on == FALSE, 1);
	thread(f_music_e5m1_objective_8_set()); 
	f_new_objective(e5_m1_obj_08);
	thread(f_e5_m1_in_portal_now());
	b_end_player_goal = TRUE;
	object_destroy(e5_m1_portal_blocker1);
	object_destroy(e5_m1_portal_blocker2);
	object_destroy(e5_m1_portal_blocker3);
	object_destroy(e5_m1_portal_blocker4);
end

script static void f_e5_m1_in_portal_now()
	sleep_until(LeveLEventStatus("e5_m1_in_portal"), 1);
	thread(f_music_e5m1_mission_end()); 
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(255,255,255,5);
	ai_disregard(players(), TRUE);
	player_camera_control(FALSE);
	player_enable_input(FALSE);
	b_end_player_goal = TRUE;
end

script static void f_e5_m1_1st_defend_wave()
	sleep_rand_s(2,4);
	ai_place_in_limbo(e5_m1_defend_1_pawn);
	sleep_until(ai_not_in_limbo_count(e5_m1_defend_1_pawn) >= 1, 1);
	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
	sleep_rand_s(1,3);
	ai_place_in_limbo(e5_m1_defend_1_knight);
	sleep_until(ai_not_in_limbo_count(e5_m1_defend_1_knight) >= 1, 1);
	ai_set_objective(e5_m1_defend_all, e5_m1_survival);
end

script static void f_e5_m1_10_wave_forerunners()
	thread(f_music_e5m1_wave_encounter_start());
	//sleep_s(1);
	object_can_take_damage(e5_m1_tower_1);
	object_can_take_damage(e5_m1_tower_2);
	thread(f_e5_m1_sensor_1_dead());
	thread(f_e5_m1_sensor_2_dead());
	thread(f_e5_m1_ammo_respawn());
	
	sleep_forever(defend_ai);
	kill_script(defend_ai);
	ai_allegiance(player, spare);
	ai_object_set_team(obj_defend_1, spare);
	object_set_allegiance(obj_defend_1, spare);
	object_immune_to_friendly_damage(obj_defend_1, TRUE);
	ai_object_set_team(obj_defend_2, spare);
	object_set_allegiance(obj_defend_2, spare);
	object_immune_to_friendly_damage(obj_defend_2, TRUE);
	
	ai_prefer_target_team(e5_m1_defend_all, spare);
	
	//portal blocker stuff
	object_create_anew(e5_m1_portal_blocker1);
	object_create_anew(e5_m1_portal_blocker2);
	object_dissolve_from_marker(e5_m1_portal_blocker1, phase_out, default);
	object_dissolve_from_marker(e5_m1_portal_blocker2, phase_out, default);
	
	repeat
    	begin
    	if ((e5_m1_knight_wave_count == 1) or (e5_m1_knight_wave_count == 2) and (e5_m1_jammer_is_up_so_stop == FALSE)) then
      	sleep_rand_s(1,4);
      	thread(f_e5_m1_population_control_1());
      	ai_place_in_limbo(e5_m1_defend_1_pawn);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_1_pawn) >= 1, 1);
      	ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
      	sleep_rand_s(1,3);
      	ai_place_in_limbo(e5_m1_defend_1_knight);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_1_knight) >= 1, 1);
      	ai_set_objective(e5_m1_defend_all, objective_defend);
      	sleep_s(1);
      	ai_place_with_birth(e5_m1_defend_1_bishop);
      	sleep_s(1);
      	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) >= 0, 1);
        sleep_s(2);
        f_blip_ai_cui(e5m1_all, "navpoint_enemy");
        if b_e5m1_sensors_defended == TRUE then
        	ai_prefer_target_team(e5_m1_defend_all, player);
					ai_prefer_target_team(e5m1_all, player);
        	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
					ai_set_objective(e5m1_all_knights, e5_m1_survival);
					ai_set_objective(e5_m1_defend_all, e5_m1_survival);
        end
        ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) <= 1, 1);
        e5_m1_knight_wave_count = (e5_m1_knight_wave_count + 1);
                               
    	elseif ((e5_m1_knight_wave_count == 3) or (e5_m1_knight_wave_count == 4) and (e5_m1_jammer_is_up_so_stop == FALSE)) then
      	sleep_rand_s(4,6);
      	ai_place_in_limbo(e5_m1_defend_2_pawn);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_2_pawn) >= 1, 1);
      	ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
      	sleep_rand_s(1,3);
      	ai_place_in_limbo(e5_m1_defend_2_knight);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_2_knight) >= 1, 1);
      	ai_set_objective(e5_m1_defend_all, objective_defend);
      	sleep_s(1);
      	ai_place_with_birth(e5_m1_defend_2_bishop);
      	sleep_s(1);
      	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) >= 0, 1);
        sleep_s(2);
        f_blip_ai_cui(e5m1_all, "navpoint_enemy");
        if b_e5m1_sensors_defended == TRUE then
        	ai_prefer_target_team(e5_m1_defend_all, player);
					ai_prefer_target_team(e5m1_all, player);
        	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
					ai_set_objective(e5m1_all_knights, e5_m1_survival);
					ai_set_objective(e5_m1_defend_all, e5_m1_survival);
        end
        ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) <= 1, 1);
        e5_m1_knight_wave_count = (e5_m1_knight_wave_count + 1);
                                
    	elseif ((e5_m1_knight_wave_count == 5) or (e5_m1_knight_wave_count == 6) and (e5_m1_jammer_is_up_so_stop == FALSE)) then
      	sleep_rand_s(4,6);
      	ai_place_in_limbo(e5_m1_defend_3_pawn);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_3_pawn) >= 1, 1);
      	ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
      	sleep_rand_s(1,3);
      	ai_place_in_limbo(e5_m1_defend_3_knight);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_3_knight) >= 1, 1);
      	ai_set_objective(e5_m1_defend_all, objective_defend);
      	sleep_s(1);
      	ai_place_with_birth(e5_m1_defend_3_bishop);
      	sleep_s(1);
      	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) >= 0, 1);
        sleep_s(2);
        f_blip_ai_cui(e5m1_all, "navpoint_enemy");
        if b_e5m1_sensors_defended == TRUE then
        	ai_prefer_target_team(e5_m1_defend_all, player);
					ai_prefer_target_team(e5m1_all, player);
        	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
					ai_set_objective(e5m1_all_knights, e5_m1_survival);
					ai_set_objective(e5_m1_defend_all, e5_m1_survival);
        end
        ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) <= 1, 1);
        e5_m1_knight_wave_count = (e5_m1_knight_wave_count + 1);
                                                
    	elseif ((e5_m1_knight_wave_count == 7) or (e5_m1_knight_wave_count == 8) and (e5_m1_jammer_is_up_so_stop == FALSE)) then
      	sleep_rand_s(4,6);
      	ai_place_in_limbo(e5_m1_defend_4_pawn);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_4_pawn) >= 1, 1);
      	ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
      	sleep_rand_s(1,3);
      	ai_place_in_limbo(e5_m1_defend_4_knight);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_4_knight) >= 1, 1);
      	ai_set_objective(e5_m1_defend_all, objective_defend);
      	sleep_s(1);
      	ai_place_with_birth(e5_m1_defend_4_bishop);
      	sleep_s(1);
      	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) >= 0, 1);
        sleep_s(2);
        f_blip_ai_cui(e5m1_all, "navpoint_enemy");
        if b_e5m1_sensors_defended == TRUE then
        	ai_prefer_target_team(e5_m1_defend_all, player);
					ai_prefer_target_team(e5m1_all, player);
        	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
					ai_set_objective(e5m1_all_knights, e5_m1_survival);
					ai_set_objective(e5_m1_defend_all, e5_m1_survival);
        end
        ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) <= 1, 1);
        e5_m1_knight_wave_count = (e5_m1_knight_wave_count + 1);
                                                
    	elseif ((e5_m1_knight_wave_count == 9) or (e5_m1_knight_wave_count == 10) and (e5_m1_jammer_is_up_so_stop == FALSE)) then
      	sleep_rand_s(4,6);
      	ai_place_in_limbo(e5_m1_defend_5_pawn);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_5_pawn) >= 1, 1);
      	ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
      	sleep_rand_s(1,3);
      	ai_place_in_limbo(e5_m1_defend_5_knight);
      	sleep_until(ai_not_in_limbo_count(e5_m1_defend_5_knight) >= 1, 1);
      	ai_set_objective(e5_m1_defend_all, objective_defend);
      	sleep_s(1);
      	ai_place_with_birth(e5_m1_defend_5_bishop);
      	sleep_s(1);
      	ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) >= 0, 1);
        sleep_s(2);
        f_blip_ai_cui(e5m1_all, "navpoint_enemy");
        if b_e5m1_sensors_defended == TRUE then
        	ai_prefer_target_team(e5_m1_defend_all, player);
					ai_prefer_target_team(e5m1_all, player);
        	ai_set_objective(e5m1_all_pawn, e5_m1_survival);
					ai_set_objective(e5m1_all_knights, e5_m1_survival);
					ai_set_objective(e5_m1_defend_all, e5_m1_survival);
        end
        ai_survival_cleanup(e5m1_all, TRUE, TRUE);
        sleep_until(ai_living_count(e5m1_all) <= 1, 1);
        e5_m1_knight_wave_count = (e5_m1_knight_wave_count + 1);
     	end                                     
	end
	until(e5_m1_knight_wave_count == 11);
	thread(f_music_e5m1_wave_encounter_end()); 
	//print("____________________________________defend waves all done");
	f_achievement_spops_5();
end

script static void f_e5_m1_pawn_ai_loop()
	repeat 
		ai_set_objective(e5m1_all_pawn, e5_m1_obj_sensors);
		sleep_s(6);
	until(b_e5m1_sensors_defended == TRUE);
end

script static void f_object_rotate_bounce_y( object_name obj_object, real r_y_rot, real r_time, real r_pause_min, real r_pause_max, short s_direction, sound snd_start, sound snd_stop )
	// randomize start direction
	if ( s_direction == 0 ) then
		begin_random_count( 1 )
			s_direction = 1;
			s_direction = -1;
		end
	end
	sleep_until(object_valid(obj_object), 1);
	object_rotate_by_offset( obj_object, r_time * 0.5, 0.0, 0.0, (r_y_rot * 0.5) * s_direction, 0.0, 0.0 );
	s_direction = -s_direction;
	repeat
		sound_impulse_start( snd_start, obj_object, 2.0 );
		object_rotate_by_offset( obj_object, r_time, 0.0, 0.0, r_y_rot * s_direction, 0.0, 0.0 );
		sleep_rand_s( r_pause_min, r_pause_max );
		sound_impulse_start( snd_stop, obj_object, 2.0 );
		s_direction = -s_direction;
	until( not object_valid(obj_object) or (object_get_health(obj_object) <= 0.0), 1 );
	
	// stop it if it's dead
	if ( object_valid(obj_object) ) then
		object_rotate_by_offset( obj_object, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	end
end

script static sound f_e5m1_sfx_unsc_comm_tower_rotate_start()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_in.sound';
end

script static sound f_e5m1_sfx_unsc_comm_tower_rotate_stop()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_out.sound';
end

script static void f_e5_m1_scanner_health_diff()
	//change the health of the scanners based on game difficulty
	if game_difficulty_get_real() == "easy" then
		//print ("game is normal, times 4 generator health");
		f_e5_m1_scanner_health (4);
	end
	
	if game_difficulty_get_real() == "normal" then
		//print ("game is normal, times 4 generator health");
		f_e5_m1_scanner_health (4);
	end
	
	if game_difficulty_get_real() == "heroic" then
		//print ("game is heroic, times 4 generator health");
		f_e5_m1_scanner_health (6);
	end
	
	if game_difficulty_get_real() == "legendary" then
		//print("game is legendary, times 9 generator health");
		f_e5_m1_scanner_health (9);
	end
end

global short player_multiplier = 1;

script static short f_e5_m1_player_multiplier()
	//print ("player multiplier");
	if game_coop_player_count() == 1 then player_multiplier = 1;
	end
	
	if game_coop_player_count() == 2 then player_multiplier = 1;
	end
	
	if game_coop_player_count() == 3 then player_multiplier = 2;
	end
	
	if game_coop_player_count() == 4 then player_multiplier = 2;
	end
	
	player_multiplier;
end

script static void f_e5_m1_scanner_health (short multiplier)
	//print("cores health multiplied by");
	inspect(multiplier);
	object_set_maximum_vitality(e5_m1_tower_1, object_get_maximum_vitality (e5_m1_tower_1, false) * multiplier / f_e5_m1_player_multiplier(), 0);
	object_set_maximum_vitality(e5_m1_tower_2, object_get_maximum_vitality (e5_m1_tower_2, false) * multiplier / f_e5_m1_player_multiplier(), 0);
end

script static void f_e5_m1_lose_condition()
	//sleep until one sensor is destroyed then play the one down VO
	//lose the game if both the generators are destroyed
	sleep_until(s_defend_obj_destroyed == 1, 1); 
	wake(e5m1_vo_lose_one);
	sleep_until(s_defend_obj_destroyed == 2, 1);
	
	b_e5m1_sensors_destroyed = TRUE;
	sleep_forever(f_e5_m1_defense_lines);
	kill_script(f_e5_m1_defense_lines);
	
	sleep_forever(f_e5_m1_10_wave_forerunners);
	kill_script(f_e5_m1_10_wave_forerunners);
	
	sleep_forever(f_e5_m1_sensors_defended);
	kill_script(f_e5_m1_sensors_defended);
	
	//replace this with chapter lost when one is made.
	cui_load_screen(ui\in_game\pve_outro\mission_failed.cui_screen);
	fade_out(0,0,0,5);
	ai_disregard(players(), TRUE);
	
	b_game_lost = true;
	
	wake(e5m1_vo_lose_two);
end

script static void f_e5_m1_kill_portal_blockers()
	sleep_until(volume_test_players(t_e5_m1_kill_portal_blockers), 1);
	object_create_anew(e5_m1_portal_blocker1);
	object_create_anew(e5_m1_portal_blocker2);
	object_create_anew(e5_m1_portal_blocker3);
	object_create_anew(e5_m1_portal_blocker4);
	object_dissolve_from_marker(e5_m1_portal_blocker1, phase_out, default);
	object_dissolve_from_marker(e5_m1_portal_blocker2, phase_out, default);
	object_dissolve_from_marker(e5_m1_portal_blocker3, phase_out, default);
	object_dissolve_from_marker(e5_m1_portal_blocker4, phase_out, default);
end

script static void f_e5_m1_ammo_respawn()
	repeat
		object_create_anew (cr_e5_m1_weapon_crate_1);
		object_create_anew (cr_e5_m1_weapon_crate_2);
		object_create_anew (cr_e5_m1_weapon_crate_3);
		object_create_anew (cr_e5_m1_weapon_crate_4);
		object_create_anew (cr_e5_m1_weapon_crate_5);
		object_create_anew (cr_e5_m1_weapon_crate_6);
		object_create_anew (cr_e5_m1_weapon_crate_7);
		sleep_s(45);
	until (b_e5m1_sensors_defended == TRUE);
	sleep_forever();
end

script static void f_e5_m1_sensor_1_dead()
	sleep_until(object_get_health(e5_m1_tower_1) <= 0.75, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_1) <= 0.50, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_1) <= 0.25, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_1) <= 0, 1);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_e5_m1_tower_1);
end

script static void f_e5_m1_sensor_2_dead()
	sleep_until(object_get_health(e5_m1_tower_2) <= 0.75, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_2) <= 0.50, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_2) <= 0.25, 1);
	cui_hud_set_new_objective(e5_m1_obj_04);
	sleep_until(object_get_health(e5_m1_tower_2) <= 0, 1);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_e5_m1_tower_2);
end