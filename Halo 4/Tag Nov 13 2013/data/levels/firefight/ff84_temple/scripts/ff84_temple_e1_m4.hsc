//=============================================================================================================================
//============================================ TEMPLE e1_m4 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================
global boolean b_wait_for_narrative_e1_m4 = TRUE;
global boolean b_e1m4_narrative_out_over = FALSE;
global boolean b_e1m4_intro_the_knight = FALSE;

script startup temple_e1_m4
	sleep_until(LevelEventStatus("e1_m4_startup"), 1);
	switch_zone_set(e1_m4);
	ai_ff_all = gr_ff_all;
	thread(f_music_e1_m4_start());

//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(cr_e1_m4_crates);
	f_add_crate_folder(cr_e1_m4_weapon_crates);
	f_add_crate_folder(cr_e1_m4_temp_door);
	//f_add_crate_folder(es_e1_m4_escape);
	f_add_crate_folder(dm_e1_m4_escape);
//	object_create_anew(e1m4_shell);
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns behind the dias
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns by the large tunnel
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the front left
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the back left
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns by the back right
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //middle
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //T: Rock side room, upper floor
	firefight_mode_set_crate_folder_at(spawn_points_10, 80); //T: near the front of the temple, for e1_m4
	firefight_mode_set_crate_folder_at(spawn_points_e1_m4_start, 81); //T: start points
	
//set objective names
	firefight_mode_set_objective_name_at(objective_switch_3, 14); //TEMPLE: e1_m4: Star Map Scan switch
	firefight_mode_set_objective_name_at(objective_switch_2, 19); //TEMPLE: e1_m4: door switch
	
	firefight_mode_set_objective_name_at(lz_0, 50); //T: entry door, in temple
	firefight_mode_set_objective_name_at(lz_1, 51); //T: entry door, in temple
	firefight_mode_set_objective_name_at(lz_4, 54); //T: left entry to altar room
	firefight_mode_set_objective_name_at(lz_5, 55); //T: back on entry hall
	firefight_mode_set_objective_name_at(lz_8, 58); //T: altar room, upper landing, altar area
	firefight_mode_set_objective_name_at(lz_15, 65); //T: side corridor, for e1_m4
		
//set squad group names
	firefight_mode_set_squad_at(gr_ff_guards_2, 2);	//the dias
	firefight_mode_set_squad_at(gr_ff_guards_3, 3);	//the tunnel
	firefight_mode_set_squad_at(gr_ff_guards_4, 4); //right side
	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //middle
	firefight_mode_set_squad_at(gr_ff_guards_15, 15); //middle
	firefight_mode_set_squad_at(gr_ff_guards_19, 19); //middle
	
	sleep_s(0.5);
	pup_play_show(e1m4_sphere);
	effect_new(levels\firefight\ff84_temple\fx\spartanops_starmap.effect, fl_e1_m4_starmap);
	effects_perf_armageddon = 1;
	
	//print("__________________________________2:52");

//================================================== OBJECTS END ==================================================================

	firefight_mode_set_player_spawn_suppressed(true);
	kill_volume_disable(kill_e4_m1_kill_players_door);
	kill_volume_disable(kill_v1);	
	effects_distortion_enabled = 0;
	if editor_mode() then
		//print("editor mode, not playing intro");
		b_wait_for_narrative_e1_m4 = FALSE;
	else
		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
		ai_enter_limbo(gr_ff_all);
		cinematic_start();
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e1m4_vin_sfx_intro', NONE, 1);
		e1m4_narrative_in();
	end
	sleep_s(1);
	sleep_until(b_wait_for_narrative_e1_m4 == FALSE);
	cinematic_stop();
	thread(f_music_e1_m4_intro_end());
	sleep_s(1);
	thread(f_music_e1_m4_intro_begin());
	firefight_mode_set_player_spawn_suppressed(false);
	thread(f_e1_m4_move_intro_knight_2());
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	sleep_until(b_players_are_alive(), 1);
	sleep_s(0.5);
	fade_in(0,0,0,15);
	ai_exit_limbo(gr_ff_all);
	thread(f_music_e1_m4_vo_begin());
	wake(vo_e1m4_begin);
	ai_jump_cost_scale(1.5);
//	sleep_s(2);
//	sleep_until((e1m4_narrative_is_on == FALSE), 1);
//	b_end_player_goal = TRUE;
//	f_new_objective(e1_m4_objective_01);	
end

// ==============================================================================================================
// ====== e1_m4_TEMPLE_ESCAPE STUFF==============================================================================
// ==============================================================================================================
script command_script cs_e1_m4_pawn_spawn()
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e1_m4_knight_spawn()
	cs_phase_in_blocking();
end

script command_script cs_e1_m4_knight_spawn_short()
	cs_phase_in();
end

script static void f_e1_m4_move_intro_knight_2 //move the intro knight
	sleep_until(volume_test_players(t_e1_m4_knight_move_2), 1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.ghost_point);
	thread(f_e1_m4_move_intro_knight_3());
	thread(f_music_e1_m4_move_intro_knight_2());
end

script static void f_e1_m4_move_intro_knight_3 //move the intro knight
	sleep_until(volume_test_players(t_e1_m4_knight_move_3), 1);
	thread(f_music_e1_m4_move_intro_knight_3());
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_first_wave_pawn_1_p1);
	ai_place_in_limbo(sq_first_wave_pawn_1);
	sleep_s(1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_first_wave_pawn_3_p1);
	ai_place_in_limbo(sq_first_wave_pawn_3);
	sleep_s(1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_first_wave_pawn_2_p1);
	ai_place_in_limbo(sq_first_wave_pawn_2);
	thread(f_e1_m4_scan());
	thread(f_e1_m4_pop_shields());
	thread(f_e1_m4_phase_knight_wave_4_2());
	thread(f_e1_m4_orders_to_activate_map());
	sleep_s(1);
	thread(f_music_e1_m4_vo_crawlers());
	wake(vo_e1m4_crawlers);
	thread(f_e1_m4_starmap_spawn());
end

script static void f_e1_m4_starmap_spawn
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 2, 1);
	thread(f_music_e1_m4_starmap_spawn());
	ai_place_in_limbo(sq_starmap);
end

script static void f_e1_m4_orders_to_activate_map
	sleep_until(LevelEventStatus("e1_m4_activate_the_map"), 1);
	thread(f_music_e1_m4_orders_to_activate_map());
	thread(f_music_e1_m4_vo_reachstarmap());
	wake(vo_e1m4_reachstarmap);
	sleep_s(1);
	sleep_until(e1m4_narrative_is_on == FALSE);
	sleep_s(1);
	f_new_objective(e1_m4_objective_02);
	b_end_player_goal = TRUE;
	sleep_s(1);
	device_set_power(objective_switch_3, 1);
end

script static void f_e1_m4_scan //starts the scan after spartans activate switch
	sleep_until(LevelEventStatus("e1_m4_scan_now"), 1);
	kill_script(f_e1_m4_starmap_spawn);
	thread(f_e1_m4_destroy_map_switch());
	thread(f_music_e1_m4_scan());
	thread(f_music_e1_m4_vo_usestarmap());
	sleep_until(device_get_position(e1_m4_panel_switch_3) == 1);
	wake(vo_e1m4_usestarmap);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	//effect_new(environments\solo\m10_crash\fx\scan\didact_scan.effect, fx_arm_didact_scan );
	thread(f_e1_m4_intro_the_knight());
	thread(f_e1_m4_map_room_spawn());
	sleep_s(3);
	thread(f_e1_m4_sq_wave_3_knight_0());
	thread(f_e1_m4_sq_wave_3_knight_1());
	thread(f_e1_m4_sq_wave_3_knight_2());
	thread(f_e1_m4_sq_wave_3_knight_3());
	thread(f_e1_m4_sq_wave_3_knight_4());
	ai_place_in_limbo(sq_wave_3_knight);
	sleep_s(1);
	thread(f_music_e1_m4_vo_knightspawn());
	wake(vo_e1m4_knightspawn);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	sleep_s(1);
	thread(f_music_e1_m4_vo_returntoextract());
	wake(vo_e1m4_returntoextract);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	
	//b_end_player_goal = TRUE; //<--- moving to narrative
	
	f_new_objective(e1_m4_objective_03);
	ai_set_objective(sq_starmap, obj_survival);
	ai_set_objective(sq_wave_3_knight, obj_survival);
	ai_set_objective(guards_15, obj_survival);
end

script static void f_e1_m4_sq_wave_3_knight_0
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_wave_3_knight_p0);
	cs_custom_animation(sq_wave_3_knight.spawn_points_0, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
end

script static void f_e1_m4_sq_wave_3_knight_1
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_wave_3_knight_p1);
end

script static void f_e1_m4_sq_wave_3_knight_2
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_wave_3_knight_p2);
end

script static void f_e1_m4_sq_wave_3_knight_3
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_wave_3_knight_p3);
end

script static void f_e1_m4_sq_wave_3_knight_4
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e1_m4_pawn_effects.sq_wave_3_knight_p4);
end

script static void f_e1_m4_destroy_map_switch
	device_set_position(e1_m4_panel_switch_3, 1);
	sleep_until(device_get_position(e1_m4_panel_switch_3) == 1);
	e1_m4_panel_switch_3->SetDerezWhenActivated();
	sleep_s(4);
	object_destroy(objective_switch_3);
	object_destroy(e1_m4_panel_switch_3);
end

script static void f_e1_m4_pop_shields	//saying its ok to pop the shields that block the door.
	sleep_until(LevelEventStatus("e1_m4_pop_shield"), 1);
	thread(f_e1_m4_shield_up());
end

script static void f_e1_m4_map_room_spawn
	sleep_until(volume_test_players(t_e1_m4_map_room_spawn), 1);
	b_e1m4_intro_the_knight = TRUE;
	thread(f_music_e1_m4_map_room_spawn());
	if ai_living_count(gr_ff_all) <= 9 then
		ai_place_in_limbo(sq_maprm_wave_1);
		sleep_s(1);
		ai_place_in_limbo(sq_maprm_wave_2);
		sleep_s(1);
		ai_place_in_limbo(sq_maprm_wave_3);
		sleep_s(1);
		ai_place_in_limbo(sq_maprm_wave_4);
		sleep_s(1);
		ai_place_in_limbo(sq_maprm_wave_5);
	end
end

script static void f_e1_m4_intro_the_knight
	sleep_until(b_e1m4_intro_the_knight == TRUE, 1);
	sleep_until(volume_test_players(t_e1_m4_knight_intro_1), 1);
	ai_place_in_limbo(sq_first_knight);
	sleep_until(ai_not_in_limbo_count(sq_first_knight) >= 1);
	//sleep_s(0.5);
	thread(f_e1_m4_intro_knight_line());
	cs_custom_animation(sq_first_knight.p_knight_1, TRUE,objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	thread(f_music_e1_m4_intro_the_knight());
end

script static void f_e1_m4_intro_knight_line
	wake(vo_e1m4_intro_knightspawn);
end

script static void f_e1_m4_phase_knight_wave_4_2
	sleep_until(LevelEventStatus("spawn_wave_4_knight_2"), 1);
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 18, 1);
	thread(f_music_e1_m4_phase_knight_wave_4_2());
	sleep_s(7);
	ai_place_in_limbo(sq_wave_4_knight_2_5);
	sleep_s(2);
	ai_place_in_limbo(sq_wave_4_knight_2);
	sleep_s(7);
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 15, 1);
	thread (f_music_e1_m4_wave_6_3());
	ai_place_in_limbo(sq_wave_6_3);
end

script static void f_e1_m4_shield_up() //pop the shields that block the door.
	sleep_until(LevelEventStatus("e1_m4_door_up_switch"), 1);
	sound_impulse_start ( 'sound\environments\multiplayer\temple\machines\new_machines\machine_23_temple_door_shield_door_close', e1_m4_shield_door, 1 ); //AUDIO!
	device_set_position(e1_m4_shield_door, 0);
	kill_volume_enable(kill_e4_m1_kill_players_door);
	thread(f_music_e1_m4_phase_knight_wave_4());
	sleep_s(3);
	ai_place_in_limbo(sq_w4_knight);
	sleep_s(1);
	if ai_living_count(gr_ff_all) <= 15 then
		ai_place_in_limbo(sq_w4_pawn);
	end
	cs_face_player(sq_w4_knight.knight, TRUE);
	cs_custom_animation(sq_w4_knight.knight, TRUE,objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	sleep_s(2);
	ai_set_objective(gr_ff_all, obj_guard_main_floor);
	ai_place_with_birth(sq_w4_bishop);
	thread(f_music_e1_m4_vo_extractblocked());
	sleep_s(1);
	wake(vo_e1m4_extractblocked);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	thread(f_e1_m4_kill_pawns());
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 2, 1);
	wake(vo_e1m4_extractblocked_2);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	ai_place_in_limbo(sq_wave_6_1_k);
	ai_place_in_limbo(sq_wave_6_1_p);
	
	//b_end_player_goal = TRUE;  //moving to narrative
	
	f_new_objective(e1_m4_objective_04);
	device_set_power(objective_switch_2, 1);
	thread(f_e1m4_escape_shields_down());
	thread(f_music_e1_m4_power_on_switch());
	sleep_s(2);
	ai_place_in_limbo(sq_wave_6_2_k);
	ai_place_in_limbo(sq_wave_6_2_p);
	thread(f_music_e1_m4_shield_up());
end

script static void f_e1_m4_kill_pawns()
	if ai_living_count(gr_e4_m1_cloister_pawns) >= 1 then
		repeat 
			if ai_living_count(gr_e4_m1_cloister_pawns) >= 1 then
			//print("________________________________________killing again");
				begin_random_count (4)
					ai_kill(sq_first_wave_pawn_1.spawn_points_0);
					ai_kill(sq_first_wave_pawn_2.spawn_points_1);
					ai_kill(sq_first_wave_pawn_3.spawn_points_2);
					ai_kill(sq_starmap.spawn_points_0);
					ai_kill(sq_starmap.spawn_points_1);
					ai_kill(sq_wave_3_knight.spawn_points_0);
					ai_kill(sq_wave_3_knight.spawn_points_1);
					ai_kill(sq_wave_3_knight.spawn_points_2);
					ai_kill(sq_wave_3_knight.spawn_points_3);
					ai_kill(sq_wave_3_knight.spawn_points_4);
					ai_kill(sq_maprm_wave_1.spawn_points_4);
					ai_kill(sq_maprm_wave_2.spawn_points_3);
					ai_kill(sq_maprm_wave_3.spawn_points_2);
					ai_kill(sq_maprm_wave_4.spawn_points_0);
					ai_kill(sq_maprm_wave_5.spawn_points_1);
					ai_kill(guards_15.spawn_points_0);
					ai_kill(guards_15.spawn_points_1);
				end
				sleep_s(1);
			end
		until (ai_living_count(gr_e4_m1_cloister_pawns) <= 0);
		//print("________________________________________done killing");
	end
end
	
script static void f_e1m4_escape_shields_down //destroy the shields after hitting the switch, watch for enemies to be 0, end mission
	sleep_until(LevelEventStatus("e1m4_shield_down"), 1);
	thread(f_music_e1_m4_escape_shields_down());
	object_destroy(objective_switch_2);
	kill_volume_disable(kill_e4_m1_kill_players_door);											// tjp 8-18-12
	device_set_position(e1_m4_panel_switch_2, 1); 
	thread(f_e1_m4_kill_switch());
	sound_impulse_start ( 'sound\environments\multiplayer\temple\machines\new_machines\machine_24_temple_switch01_transform', e1_m4_switch_spire, 1 ); //AUDIO!
	device_set_position(e1_m4_switch_spire, 1);
	//sleep_until(device_get_position(e1_m4_panel_switch_2) == 1);
	sleep_s(2);
	thread(f_music_e1_m4_vo_switchflipped());
	sound_impulse_start ( 'sound\environments\multiplayer\temple\machines\dm_temple_door01', e1_m4_switch_door, 1 ); //AUDIO!
	device_set_position(e1_m4_switch_door, 1);
	if ai_living_count(gr_ff_all) <= 15 then
		ai_place_in_limbo(sq_end_pawn_primes);
	end
	sleep_s(2);
	sound_impulse_start ( 'sound\environments\multiplayer\temple\machines\new_machines\machine_26_temple_door_shield_door_open', e1_m4_shield_door, 1 ); //AUDIO!
	device_set_position(e1_m4_shield_door, 1);
	sleep_s(2);
	if ai_living_count(gr_ff_all) <= 13 then
		ai_place_in_limbo(sq_end_pawn_2);
	end
	wake(vo_e1m4_clean_area_out);
	sleep_s(1); 
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	thread(f_music_e1_m4_cinematic_title_1());
	thread(f_music_e1_m4_cinematic_title_2());
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	thread(f_music_e1_m4_cinematic_title_3());
	f_new_objective(e1_m4_objective_05);
	sleep_s(1);
	ai_set_objective(gr_ff_all, obj_guard_main_floor);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 2, 1);
	ai_place_in_limbo(sq_end_knights);
	sleep_s(1);
	ai_place_with_birth(sq_end_bishops); 
	thread(f_e1_m4_bishop_alive());     
	sleep_s(1);
	ai_set_objective(gr_ff_all, obj_guard_main_floor);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	sleep_s(2);
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 2, 1);
	ai_place_in_limbo(sq_e1m4_e_hall_k);
	ai_place_in_limbo(sq_e1m4_e_hall_p);
	sleep_s(1);
	cs_custom_animation(sq_e1m4_e_hall_k.knight_1, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_custom_animation(sq_e1m4_e_hall_k.knight_2, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_custom_animation(sq_e1m4_e_hall_p.pawn_1, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	ai_place_with_birth(sq_e1m4_e_hall_b);
	sleep_s(2);
	f_blip_ai_cui(gr_ff_all, "navpoint_enemy");
	ai_survival_cleanup(gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_ff_all) <= 3, 1);
	ai_set_objective(gr_ff_all, obj_guard_main_floor);
	sleep_until(ai_living_count(gr_ff_all) <= 0, 1);
	sleep_s(3);
	thread(f_music_e1_m4_cinematic_title_4());
	thread(f_e1_m4_end_mission());
	wake(vo_e1m4_exit_temple);
	thread(f_music_e1_m4_cinematic_title_5());
	
	// PIP
	wake(vo_e1m4_outro);
	
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
	f_new_objective(e1_m4_objective_06);
	thread(f_e1_m4_open_final_doors());
	b_end_player_goal = TRUE;
end

script static void f_e1_m4_bishop_alive
	sleep_until(ai_not_in_limbo_count(sq_end_bishops) >= 1);
	sleep_s(3);
	wake(vo_e1m4_watcherwarning);
	sleep_s(1);
	sleep_until((e1m4_narrative_is_on == FALSE), 1);
end
	
script static void f_e1_m4_open_final_doors
	sleep_until(volume_test_players(t_e1_m4_open_final_door), 1);
	sound_impulse_start('sound\environments\multiplayer\temple\machines\new_machines\machine_25_temple_door_end_door', e1_m4_end_door_1, 1 ); //AUDIO!
	device_set_position(e1_m4_end_door_1, 1);
	device_set_position(e1_m4_end_door_2, 1);
end

script static void f_e1_m4_kill_switch
	sleep_until(device_get_position(e1_m4_panel_switch_2) == 1);
	e1_m4_panel_switch_2->SetDerezWhenActivated();
	sleep_s(4);
	object_destroy(e1_m4_panel_switch_2);
end

script static void f_e1_m4_end_mission  //ending the mission
	sleep_until(LevelEventStatus("end_mission_e1_m4"), 1);
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	//thread (f_music_e1_m4_finish());
	//f_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	sleep_s(1);
	//ai_place_in_limbo(squads_knight_out);
	//pup_play_show(e1m4_narrative_out);
	//sleep_until (b_e1m4_narrative_out_over == TRUE);
	b_end_player_goal = TRUE;
end

script static void f_e1m4_narrative_out_over
	b_e1m4_narrative_out_over = TRUE;
end

