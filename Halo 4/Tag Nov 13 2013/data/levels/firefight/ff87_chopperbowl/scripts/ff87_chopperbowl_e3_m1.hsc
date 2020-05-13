//=============================================================================================================================
//============================================ CB E3_M1 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================

//global boolean e3m1_phantom1_done = FALSE;
//global boolean e3m1_phantom2_done = FALSE;
//global boolean e3m1_phantom3_done = FALSE;
global boolean e3m1_phantom4_done = FALSE;
global boolean e3m1_drop_pod1_done = FALSE;
global boolean e3m1_drop_pod2_done = FALSE;
global boolean e3m1_drop_pod3_done = FALSE;
global boolean e3m1_drop_pod4_done = FALSE;
global boolean e3m1_drop_pod5_done = FALSE;
global boolean e3m1_drop_pod6_done = FALSE;
global boolean b_e3m1_narrative_in_over = FALSE;

script startup chopperbowl_e3_m1()
	sleep_until(LevelEventStatus ("e3_m1_startup"), 1);
	fade_out(0,0,0,0);
	thread(f_music_e3m1_start());
	print("___________________________________running e3 m1");
	switch_zone_set(e3_m1_dz);
	firefight_mode_set_player_spawn_suppressed(TRUE);
	ai_ff_all = gr_ff_e3_m1_all;

//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(v_e3_m1_unsc_cache);
	f_add_crate_folder(v_e3_m1_cov_vehicles);
	f_add_crate_folder(cr_e3_m1_unsc_small_base_props);
	f_add_crate_folder(cr_e3_m1_unsc_cache_base);
	f_add_crate_folder(cr_e3_m1_cov_plateau_props);
	f_add_crate_folder(cr_e3_m1_cov_bowl_props);
	f_add_crate_folder(dm_e3_m1_drop_rails);
	f_add_crate_folder(e_e3_m1_ammo);
	f_add_crate_folder(cr_e3_m1_path_crates);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sp_e3_m1_00, 80);
	firefight_mode_set_crate_folder_at(sp_e3_m1_01, 81);
	firefight_mode_set_crate_folder_at(sp_e3_m1_02, 82);
	firefight_mode_set_crate_folder_at(sp_e3_m1_03, 83);
	firefight_mode_set_crate_folder_at(sp_e3_m1_04, 84);
	firefight_mode_set_crate_folder_at(sp_e3_m1_05, 85);
	firefight_mode_set_crate_folder_at(sp_e3_m1_06, 86);
	
//set objective names
	firefight_mode_set_objective_name_at(e3_m1_lz_00, 50);
	firefight_mode_set_objective_name_at(e3_m1_lz_01, 51);
	firefight_mode_set_objective_name_at(e3_m1_lz_02, 52);
	firefight_mode_set_objective_name_at(e3_m1_lz_03, 53);
		
//set squad group names
	firefight_mode_set_squad_at(gr_ff_e3_m1_guards_1, 1);
	firefight_mode_set_squad_at(gr_ff_e3_m1_guards_2, 2);
	firefight_mode_set_squad_at(gr_ff_e3_m1_guards_3, 3);

	firefight_mode_set_squad_at(gr_ff_waves, 50);
	firefight_mode_set_squad_at(gr_ff_phantom_attack, 51); //phantoms -- doesn't seem to work
	firefight_mode_set_squad_at(gr_ff_allies_1, 52);
	firefight_mode_set_squad_at(gr_ff_allies_2, 53);
	sleep_s(1);
	thread(f_e3_m1_intro());
	object_destroy(e1m1_towerbase_01);
	object_destroy(e1m1_hilltower);
	object_destroy(e1m1_towerbase_02);
	object_destroy(e1m1_chokepoint_tower);
	object_destroy(e1m1_towerbase_03);
	object_destroy(e1m1_bowlflats_tower);
	object_destroy(e1m1_towerbase_04);
	object_destroy(e1m1_bowlright_tower);
	object_destroy(e1m1_towerbase_05);
	object_destroy(e1m1_bowl_tower);
	object_destroy(e1m1_towerbase_06);
	object_destroy(e1m1_starttower01);
	object_destroy(e1m1_towerbase_07);
	object_destroy(e1m1_starttower02);
	sleep_s(0.5);
	fade_in(0,0,0,30);
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e3_m1.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	thread(f_e3_m1_shut_down_tower_1());
	thread(f_e3_m1_shut_down_tower_2());
	thread(f_e3_m1_shut_down_tower_3());
	thread(f_e3_m1_shut_down_tower_4());
	kill_volume_disable(kill_e3_m1_tower_1);
	kill_volume_disable(kill_e3_m1_tower_2);
	object_cannot_take_damage(e3_m1_base1_pod);
	object_cannot_take_damage(e3_m1_base2_pod);
end

script static void f_e3_m1_shut_down_tower_1()
	sleep_until(object_get_health(e3_m1_base1_pod) <= 0, 1);
	object_set_phantom_power(e3_m1_base1, FALSE);
end

script static void f_e3_m1_shut_down_tower_2()
	sleep_until(object_get_health(e3_m1_base2_pod) <= 0, 1);
	object_set_phantom_power(e3_m1_base2, FALSE);
end

script static void f_e3_m1_shut_down_tower_3()
	sleep_until(object_get_health(e3_m1_base3_pod) <= 0, 1);
	object_set_phantom_power(e3_m1_base3, FALSE);
end

script static void f_e3_m1_shut_down_tower_4()
	sleep_until(object_get_health(e3_m1_base4_pod) <= 0, 1);
	object_set_phantom_power(e3_m1_base4, FALSE);
end

script static void f_e3m1_narrative_in_over()
	b_e3m1_narrative_in_over = TRUE;
end

script static void f_e3_m1_intro()
	sleep_s(1);
	if editor_mode() then
		print ("editor mode, no intro playing");
		b_e3m1_narrative_in_over = TRUE;
	else
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m1_vin_sfx_intro', NONE, 1);
		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
		ai_enter_limbo(gr_ff_e3_m1_all);
		thread(f_music_e3m1_vignette_start());
		cinematic_start();
		e3_m1_intro();
		thread(f_music_e3m1_vignette_finish());
	end
	sleep_until(b_e3m1_narrative_in_over == TRUE);
	cinematic_stop();	
	firefight_mode_set_player_spawn_suppressed(FALSE);
	sleep_s(1);
	sleep_until(b_players_are_alive(), 1);
	ai_erase(sq_e3m1_elites);
	ai_erase(sq_e3m1_lessers);
	sleep_s(0.5);
	thread(f_music_e3m1_initial_fade_in());
	fade_in(0,0,0,15);
	ai_exit_limbo(gr_ff_e3_m1_all);
	thread(f_1st_grunts_to_ghosts());
	thread(f_set_up_1st_wave());
end

script static void f_set_up_1st_wave()
	ai_place(camp_guards_elite);
	ai_place(camp_guards_grunts);
	ai_place(e3_m1_guards_1);
	ai_place(e3_m1_guards_2);
	ai_place(e3_m1_guards_5);
	ai_place(e3_m1_cliff_turret);
	ai_place(fw_e3_m1_escape_phantom);
	ai_suppress_combat(fw_e3_m1_escape_phantom, TRUE);
	ai_set_blind(fw_e3_m1_escape_phantom, TRUE);
	ai_set_deaf(fw_e3_m1_escape_phantom, TRUE);
	thread(f_music_e3m1_targetid_vo());
	sleep_s(3);
	wake(e3m1_vo_targetid);
	sleep_s(1);
	sleep_until((e3m1_narrative_is_on == FALSE), 1);
	thread(f_music_e3m1_objective_1());
	sleep_s(1);
	b_end_player_goal = TRUE;
	sleep_s(1);
	f_new_objective(e3_m1_objective_1);
end

script static void f_e3_m1_move_up_chokepoint()
	sleep_until(ai_living_count(chokepoint_guards) <= 5, 1);
	ai_set_task(chokepoint_guards, obj_chokepoint, guard_front);
	ai_grunt_kamikaze(chokepoint_guards.g_g_1);
	sleep_s(2);
	ai_grunt_kamikaze(chokepoint_guards.g_g_2);
end

script static void f_1st_grunts_to_ghosts()
	sleep_until(volume_test_players(first_grunts_to_ghosts), 1);
	thread(f_e3_m1_camp_grunt_kamikaze());
	ai_set_objective(camp_guards_elite, obj_e3_m1_survival);
	ai_set_objective(camp_guards_grunts, obj_e3_m1_survival);
	thread(f_music_e3m1_first_grunts_to_ghosts());
	ai_place(cliff_snipers);
	ai_place(turret_grunts1);
	thread(f_e3_m1_cliff_snipers2());
	thread(f_target_vip());
	sleep_s(4);
	f_e3_m1_sniper_global_vo();
	sleep_s(1);
	sleep_until((e3m1_narrative_is_on == FALSE), 1);
	sleep_s(3);
	vo_glo_ordnance_01();
	sleep_s(2);
	ordnance_drop(f_e3m1_d2, "storm_sniper_rifle");
	sleep_s(0.5);
	ordnance_drop(f_e3m1_d1, "storm_rail_gun");
	sleep_s(0.25);
	ordnance_drop(f_e3m1_d3, "storm_sniper_rifle");
	sleep_s(2.5);
	thread(vo_glo_gotit_02());
	ai_place(turret_grunts2);
end

script static void f_e3_m1_camp_grunt_kamikaze()
	if ai_living_count(sq_ex_camp_guards) >= 1 then
		ai_grunt_kamikaze(camp_guards_grunts.spawn_points_0);
	end
	sleep_s(3);
	if ai_living_count(sq_ex_camp_guards) >= 1 then
		ai_grunt_kamikaze(camp_guards_grunts.spawn_points_2);
	end
	sleep_s(3);
	if ai_living_count(sq_ex_camp_guards) >= 1 then
		ai_grunt_kamikaze(camp_guards_grunts.spawn_points_3);
	end
end

script static void f_e3_m1_cliff_snipers2()
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 16, 1);
	ai_place(cliff_snipers2);
end

script static void f_target_vip()
	sleep_until(LevelEventStatus("target_vip"), 1);
	kill_script(f_e3_m1_cliff_snipers2);
	ai_set_objective(turret_grunts1, obj_e3_m1_survival);
	ai_set_objective(turret_grunts2, obj_e3_m1_survival);
	ai_set_objective(e3_m1_guards_1, obj_e3_m1_survival);
	ai_set_objective(e3_m1_guards_2, obj_e3_m1_survival);
	ai_set_objective(e3_m1_guards_5, obj_e3_m1_survival);
	ai_place(vip);
	if ai_living_count(gr_sq_ff_top_all) <= 16 then
		ai_place(vip2);
		ai_grunt_kamikaze(vip2.spawn_points_3);
	end
	thread(f_music_e3m1_target_vip());
	ai_suppress_combat(fw_e3_m1_escape_phantom, FALSE);
	ai_set_blind(fw_e3_m1_escape_phantom, FALSE);
	ai_set_deaf(fw_e3_m1_escape_phantom, FALSE);
	NotifyLevel("start_e3_m1_escape_phantom");
	sleep_s(7);
	thread(f_music_e3m1_vip2_title());
	wake(e3m1_vo_gettingaway);
	sleep_s(1);
	ai_set_objective(cliff_snipers, obj_e3_m1_survival);
	if ai_living_count(cliff_snipers2) >= 1 then
		ai_set_objective(cliff_snipers2, obj_e3_m1_survival);
	end
	ai_set_objective(e3_m1_cliff_turret, obj_e3_m1_survival);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	sleep_s(5);
	//sleep_until(ai_living_count(sq_e3m1_plateau_group) <= 6, 1);
	if ai_living_count(gr_sq_ff_top_all) <= 10 then
		thread(vo_glo_incoming_02());
		sleep_s(1);
		thread(f_drop_pod_6());
		sleep_until(e3m1_drop_pod6_done == TRUE, 1);
	end
	sleep_s(3);
	ai_set_objective(gr_sq_ff_top_all, obj_e3_m1_survival);
	wake(e3m1_clean_up_cronnies);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 20, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 15, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 5, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 0, 1);
	sleep_s(3);
	vo_glo_nicework_01();
	sleep_s(2);
	thread(f_music_e3m1_unsctoys());
	wake(e3m1_vo_unsctoys);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	//sleep_s(1);
	b_end_player_goal = TRUE;
	ai_set_objective(vip, obj_e3_m1_survival);
	thread(f_music_e3m1_objective_2());
	f_new_objective (e3_m1_objective_2);
	thread(f_e3m1_spawn_chokepoint());
	thread(f_chokepoint_check());
	thread(f_e3_m1_getting_ready_for_bowl());
end

script static void f_e3m1_spawn_chokepoint()
	sleep_until(volume_test_players(t_e3_m1_chokepoint_spawn), 1);
	kill_volume_disable(kill_soft_e3_m1_vip);
	ai_place(chokepoint_turret_1);
	ai_place(chokepoint_turret_2);
	sleep_s(0.5);
	ai_place(chokepoint_guards);
	object_can_take_damage(e3_m1_base1_pod);
	object_can_take_damage(e3_m1_base2_pod);
	thread(f_e3_m1_move_up_chokepoint());
	sleep_s(6);
	ai_set_task(chokepoint_guards, obj_chokepoint, guard);
end

script static void f_chokepoint_check()
	sleep_until(volume_test_players(t_e3_m1_early_trig_warning), 1);
	ai_set_objective(chokepoint_guards, obj_scorpion_guards);
	ai_place(back_tower_turret);
	ai_place(back_tower_guards);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(back_tower_guards) >= 1, 1);
	ai_place(scorpion_guards);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(scorpion_guards) >= 1, 1);
	if ai_living_count(gr_sq_ff_top_all) <= 14 then
		ai_place(front_tower_guards);
		ai_place(front_tower_turret);
	end
	ai_grunt_kamikaze(chokepoint_guards.g_g_1);
	sleep_s(2);
	ai_grunt_kamikaze(chokepoint_guards.g_g_2);
	vo_glo_heavyforces_04();
	thread(f_e1_m3_at_cache_base());
	ai_set_objective(turret_grunts1, obj_scorpion_guards);
	ai_set_objective(turret_grunts2, obj_scorpion_guards);
	ai_set_objective(e3_m1_guards_1, obj_scorpion_guards);
	ai_set_objective(e3_m1_guards_2, obj_scorpion_guards);
	ai_set_objective(e3_m1_guards_5, obj_scorpion_guards);
end

script static void f_e3_m1_getting_ready_for_bowl()
	sleep_until(LevelEventStatus("e3_m1_location_arrival_2"), 1);
	object_create_anew(e3_m1_lz_02);
	navpoint_track_object_named(e3_m1_lz_02, "navpoint_goto");
end

//=============================================================================================================================
//================================================== BIG END SCRIPT ===========================================================
//=============================================================================================================================
script static void f_e1_m3_at_cache_base()
	sleep_until(volume_test_players(t_e3_m1_activate_bowl), 1);
	sleep_s(1);
	b_end_player_goal = TRUE;
	//sleep_until(LevelEventStatus("e1_m3_at_cache_base"), 1);
	object_destroy(e3_m1_lz_02);
	f_create_new_spawn_folder(86);
	thread(f_music_e3m1_at_cache_base());
	ai_set_objective(gr_sq_ff_top_all, obj_e3_m1_survival);
	sleep_s(3);
	kill_volume_enable(kill_e3_m1_tower_1);
	kill_volume_enable(kill_e3_m1_tower_2);
	wake(e3m1_tech_stolen);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	kill_volume_disable(kill_e3_m1_tower_1);
	kill_volume_disable(kill_e3_m1_tower_2);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 20, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 15, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 5, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 0, 1);
	sleep_s(3);
	thread(f_music_e3m1_toysget_vo());
	wake(e3m1_vo_toysget);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	sleep_s(5);
	thread(f_music_e3m1_hornetsnest_vo());
	wake(e3m1_vo_hornetsnest);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	thread(f_e3_m1_scorpion_respawn());
	sleep_s(3);
	ai_place(fw_phantom_5);
	ai_place(fw_phantom_6);
	ai_place(fw_phantom_1);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	object_create_anew(e3_m1_lz_03);
	thread(f_music_e3m1_objective_3());
	f_new_objective(e3_m1_objective_3);
	navpoint_track_object_named(e3_m1_lz_03, "navpoint_defend");
	sleep_s(7);
	ai_place(fw_phantom_2);
	thread(f_music_e3m1_badsarrive_vo());
	wake(e3m1_vo_badsarrive);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 2, 1);
	sleep_s(3);
	vo_glo_droppod_05();
	thread(f_drop_pod_1());
	sleep_until(e3m1_drop_pod1_done == TRUE, 1);
	vo_glo_ordnance_02();
	sleep_s(3);
	ordnance_drop(f_e3m1_d4, "storm_rail_gun");
	sleep_s(2.5);
	vo_glo_gotit_02();
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 3, 1);
	sleep_s(3);
	vo_glo_droppod_04();
	thread(f_drop_pod_3());
	sleep_s(5);
	thread(f_drop_pod_2());
	sleep_until(e3m1_drop_pod2_done == TRUE, 1);
	sleep_s(8);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 15, 1);
	vo_glo_ordnance_04();
	sleep_s(3);
	ordnance_drop(f_e3m1_d5, "storm_rocket_launcher");
	sleep_s(2.5);
	vo_glo_gotit_03();
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	vo_glo_phantom_05();
	ai_place(fw_phantom_4);
	sleep_until(e3m1_phantom4_done == TRUE, 1);
	sleep_s(2);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	sleep_s(2);
	vo_glo_droppod_10();
	thread(f_drop_pod_4());
	sleep_s(3);
	vo_glo_ordnance_05();
	sleep_s(3);
	ordnance_drop(f_e3m1_d6, "storm_rail_gun");
	sleep_s(2.5);
	vo_glo_gotit_01();
	sleep_s(1);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 15, 1);
	ai_place(fw_phantom_3);
	sleep_s(1);
	vo_glo_phantom_09();
	sleep_s(3);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	vo_glo_droppod_02();
	thread(f_drop_pod_5());
	sleep_until(e3m1_drop_pod5_done == TRUE, 1);
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 10, 1);
	sleep_s(2);
	wake(e3m1_vo_scorched_earth);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	sleep_s(1);
	f_e3_m1_last_targets_global_vo();
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	f_blip_ai_cui(gr_sq_ff_top_all, "navpoint_enemy");
	ai_survival_cleanup(gr_sq_ff_top_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_sq_ff_top_all) <= 0, 1);
	sleep_s(4);
	object_destroy(e3_m1_lz_03);
	thread(f_music_e3m1_alldone_vo());
	kill_script(f_e3_m1_scorpion_respawn);
	wake(e3m1_vo_alldone);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	sleep_s(2);
	ai_place(e1_m3_pelican);
	sleep_s(2);
	f_blip_object(e1_m3_pelican, "navpoint_goto");
	sleep_s(5);
	thread(f_music_e3m1_doctorowen_vo());
	wake(e3m1_vo_doctorowen);
	sleep_s(1);
	sleep_until(e3m1_narrative_is_on == FALSE, 1);
	sleep_s(5);
	thread(f_music_e3m1_finish());
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	sleep_s(3);
	b_end_player_goal = TRUE;
end

//=============================================================================================================================
//================================================== BIG END SCRIPT END =======================================================
//=============================================================================================================================
script command_script cs_e3_m1_phantom_01() // phantom that drops a wraith, then dudes
	cs_ignore_obstacles (TRUE);
	ai_place(fw_wraith_1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point (fw_phantom_1.phantom_1 ), "phantom_lc", ai_vehicle_get_from_spawn_point(fw_wraith_1.wraith_1));
	f_load_phantom(fw_phantom_1, dual, fw_phantom_1_sq_1, fw_phantom_1_sq_2, fw_phantom_1_sq_3, fw_phantom_1_sq_4);
	cs_fly_to_and_face (fw_phantom_1.p0, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p1, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p2, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p3, fw_phantom_1.p9);
	sleep_s(2);
	vehicle_unload( ai_vehicle_get_from_spawn_point(fw_phantom_1.phantom_1 ), "phantom_lc" );
	sleep_s(3);
	cs_fly_to_and_face (fw_phantom_1.p9, fw_phantom_1.p14);
	cs_fly_to_and_face (fw_phantom_1.p6, fw_phantom_1.p3);
//	cs_fly_to_and_face (fw_phantom_1.p6, fw_phantom_1.p3);
	sleep_s(1);
	f_unload_phantom(fw_phantom_1, dual);
	sleep_s(3);
	//e3m1_phantom1_done = TRUE;
	sleep_s(2);
	cs_fly_to_and_face (fw_phantom_1.p7, fw_phantom_1.p8);
	cs_fly_to_and_face (fw_phantom_1.p8, fw_phantom_1.p11);
	cs_fly_to_and_face (fw_phantom_1.p10, fw_phantom_1.p11);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	ai_erase (fw_phantom_1);
end

script command_script cs_e3_m1_phantom_02() //phantom that drops a wraith
	cs_ignore_obstacles (TRUE);
	ai_place (fw_wraith_2);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point (fw_phantom_2.phantom), "phantom_lc", ai_vehicle_get_from_spawn_point(fw_wraith_2.wraith) );
	cs_fly_to_and_face (fw_phantom_1.p0, fw_phantom_1.p1);
	cs_fly_to_and_face (fw_phantom_1.p1, fw_phantom_1.p2);
	cs_vehicle_speed(.9);
	cs_fly_to_and_face (fw_phantom_1.p2, fw_phantom_1.p3);
	cs_vehicle_speed(.75);
	cs_fly_to_and_face (fw_phantom_1.p3, fw_phantom_1.p4);
	vehicle_unload( ai_vehicle_get_from_spawn_point(fw_phantom_2.phantom), "phantom_lc" );
	cs_fly_to_and_face (fw_phantom_1.p4, fw_phantom_1.p5);
	//e3m1_phantom2_done = TRUE;
	cs_fly_to_and_face (fw_phantom_1.p5, fw_phantom_1.p13);
	cs_fly_to_and_face (fw_phantom_1.p12, fw_phantom_1.p13);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120 ); //Shrink size over time
	sleep_s(5);
	ai_erase (fw_phantom_2);
end

script command_script cs_e3_m1_phantom_03() // phantom that drops a wraith by the entrance
	cs_ignore_obstacles (TRUE);
	ai_place(fw_wraith_3);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point (fw_phantom_3.phantom_1 ), "phantom_lc", ai_vehicle_get_from_spawn_point(fw_wraith_3.wraith_1));
	cs_fly_to_and_face (fw_phantom_1.p0, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p1, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p2, fw_phantom_1.p3);
	cs_fly_to_and_face (fw_phantom_1.p3, fw_phantom_1.p9);
	cs_fly_to_and_face (fw_phantom_1.p9, fw_phantom_1.p14);
	cs_fly_to_and_face (fw_phantom_1.p6, fw_phantom_1.p3);
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point(fw_phantom_3.phantom_1 ), "phantom_lc" );
	sleep_s(5);
	//e3m1_phantom3_done = TRUE;
	cs_fly_to_and_face(fw_phantom_1.p7, fw_phantom_1.p8);
	cs_fly_to_and_face(fw_phantom_1.p8, fw_phantom_1.p11);
	cs_fly_to_and_face(fw_phantom_1.p10, fw_phantom_1.p11);
	object_set_scale(ai_vehicle_get( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	ai_erase (fw_phantom_3);
end

script command_script cs_e3_m1_phantom_04() //phantom that drops a wraith
	//print("______________________________spawning the one that matters");
	cs_ignore_obstacles (TRUE);
	ai_place(fw_wraith_4);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point (fw_phantom_4.phantom_1), "phantom_lc", ai_vehicle_get_from_spawn_point(fw_wraith_4.wraith_1) );
	cs_fly_to_and_face(fw_phantom_1.p0, fw_phantom_1.p1);
	cs_fly_to_and_face(fw_phantom_1.p1, fw_phantom_1.p2);
	cs_vehicle_speed(.9);
	cs_fly_to_and_face(fw_phantom_1.p2, fw_phantom_1.p3);
	cs_vehicle_speed(.75);
	cs_fly_to_and_face(fw_phantom_1.p3, fw_phantom_1.p4);
	vehicle_unload(ai_vehicle_get_from_spawn_point(fw_phantom_4.phantom_1), "phantom_lc" );
	e3m1_phantom4_done = TRUE;
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	object_set_health(ai_vehicle_get(ai_current_actor), 0.25);
	cs_fly_to_and_face(fw_phantom_1.p4, fw_phantom_1.p6);
	cs_fly_to_and_face(fw_phantom_1.p5, fw_phantom_1.p13);
	cs_fly_to_and_face(fw_phantom_1.p12, fw_phantom_1.p13);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120); //Shrink size over time
	sleep_s(4);
	ai_erase(fw_phantom_4);
end

script command_script cs_e3_m1_phantom_05()
	cs_ignore_obstacles(TRUE);
	cs_fly_to_and_face (e3_m1_phan_5.p0, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p1, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p2, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p3, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p4, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p5, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p6, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p7, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p8, e3_m1_phan_5.p12);
	cs_fly_to_and_face (e3_m1_phan_5.p9, e3_m1_phan_5.p11);
	cs_fly_to_and_face (e3_m1_phan_5.p10, e3_m1_phan_5.p11);
	cs_fly_to_and_face (e3_m1_phan_5.p11, e3_m1_phan_5.p11);
	sleep_s(5);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120 ); //Shrink size over time
	ai_erase (fw_phantom_5);
end

script command_script cs_e3_m1_phantom_06()
	cs_ignore_obstacles(TRUE);
	cs_vehicle_speed(0.6);
	cs_fly_to_and_face(e3_m1_phan_6.p0, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p1, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p2, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p3, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p4, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p5, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p6, e3_m1_phan_6.p11);
	cs_fly_to_and_face(e3_m1_phan_6.p7, e3_m1_phan_6.p10);
	cs_vehicle_speed(1);
	cs_fly_to_and_face(e3_m1_phan_6.p8, e3_m1_phan_6.p10);
	cs_fly_to_and_face(e3_m1_phan_6.p9, e3_m1_phan_6.p10);
	cs_fly_to_and_face(e3_m1_phan_6.p10, e3_m1_phan_6.p10);
	sleep_s(5);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120);
	ai_erase(fw_phantom_6);
end

script command_script cs_e3_m1_escape_phantom()
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_until(LevelEventStatus("start_e3_m1_escape_phantom"), 1);
	navpoint_track_object_named((ai_vehicle_get(ai_current_actor)), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (e3_m1_escape_phantom.p0, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p2, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p3, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p4, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p5, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p6, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p7, e3_m1_escape_phantom.p1);
	cs_fly_to_and_face (e3_m1_escape_phantom.p8, e3_m1_escape_phantom.p10);
	f_unblip_object_cui(ai_vehicle_get(ai_current_actor));
	cs_fly_to_and_face (e3_m1_escape_phantom.p9, e3_m1_escape_phantom.p10);
	cs_fly_to_and_face (e3_m1_escape_phantom.p10, e3_m1_escape_phantom.p11);
	cs_fly_to_and_face (e3_m1_escape_phantom.p11, e3_m1_escape_phantom.p12);
	//cs_fly_to_and_face (e3_m1_escape_phantom.p12, e3_m1_escape_phantom.p13);
	//cs_fly_to_and_face (e3_m1_escape_phantom.p13, e3_m1_escape_phantom.p13);
	//sleep_s(5);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 30); //Shrink size over time
	ai_erase(fw_e3_m1_escape_phantom);
	ai_kill(fw_e3_m1_escape_phantom);
	//object_destroy(ai_vehicle_get(ai_current_actor));
end

script static void f_drop_pod_1()
	thread(f_music_e3m1_drop_pod_1());
	ai_place_in_limbo(sq_drop_pod_1);
	f_load_drop_pod(dm_e3_m1_drop_rail_01, sq_drop_pod_1, e3m1_drop_pod_lg_01, FALSE);
	sleep_s(5);
	e3m1_drop_pod1_done = TRUE;
end

script static void f_drop_pod_2()
	thread(f_music_e3m1_drop_pod_2());
	ai_place_in_limbo(sq_drop_pod_2);
	f_load_drop_pod(dm_e3_m1_drop_rail_02, sq_drop_pod_2, e3m1_drop_pod_lg_02, FALSE);
	sleep_s(5);
	e3m1_drop_pod2_done = TRUE;
end

script static void f_drop_pod_3()
	thread(f_music_e3m1_drop_pod_3());
	ai_place_in_limbo(sq_drop_pod_3);
	f_load_drop_pod(dm_e3_m1_drop_rail_03, sq_drop_pod_3, e3m1_drop_pod_lg_03, FALSE);
	sleep_s(5);
	e3m1_drop_pod3_done = TRUE;
end

script static void f_drop_pod_4()
	thread(f_music_e3m1_drop_pod_4());
	ai_place_in_limbo(sq_drop_pod_4);
	f_load_drop_pod(dm_e3_m1_drop_rail_04, sq_drop_pod_4, e3m1_drop_pod_lg_04, FALSE);
	sleep_s(5);
	e3m1_drop_pod4_done = TRUE;
end

script static void f_drop_pod_5()
	thread(f_music_e3m1_drop_pod_5());
	ai_place_in_limbo(sq_drop_pod_5);
	f_load_drop_pod(dm_e3_m1_drop_rail_05, sq_drop_pod_5, e3m1_drop_pod_lg_05, FALSE);
	sleep_s(5);
	e3m1_drop_pod5_done = TRUE;
end

script static void f_drop_pod_6()
	thread(f_music_e3m1_drop_pod_5());
	ai_place_in_limbo(sq_drop_pod_6);
	f_load_drop_pod(dm_e3_m1_drop_rail_06, sq_drop_pod_6, e3m1_drop_pod_lg_06, TRUE);
	sleep_s(5);
	e3m1_drop_pod6_done = TRUE;
end

script command_script cs_e3_m1_tower1_grunt1()
	sleep_s(4);
	ai_vehicle_enter(chokepoint_turret_1.grunt_1, (object_get_turret(e3_m1_base1_pod, 2)));
end

script command_script cs_e3_m1_tower2_grunt1()
	sleep_s(4);
	ai_vehicle_enter(chokepoint_turret_2.grunt_2, (object_get_turret(e3_m1_base2_pod, 1)));
end

script command_script cs_e3_m1_tower3_grunt1()
	ai_vehicle_enter(back_tower_turret.grunt_1, (object_get_turret(e3_m1_base3_pod, 2)));
end

script command_script cs_e3_m1_tower4_grunt1()
	ai_vehicle_enter(front_tower_turret.grunt_1, (object_get_turret(e3_m1_base4_pod, 1)));
end

script static void f_e3_m1_sniper_global_vo()
	sleep_until (e3m1_narrative_is_on == FALSE, 1);
	e3m1_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_snipers_01();
		vo_glo_snipers_02();
		vo_glo_snipers_03();
		vo_glo_snipers_04();
		vo_glo_snipers_05();
	end
	e3m1_narrative_is_on = FALSE;
end

script static void f_e3_m1_last_targets_global_vo()
	sleep_until (e3m1_narrative_is_on == FALSE, 1);
	e3m1_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_lasttargets_01();
		vo_glo_lasttargets_02();
		vo_glo_lasttargets_03();
		vo_glo_lasttargets_04();
		vo_glo_lasttargets_05();
		vo_glo_lasttargets_06();
		vo_glo_lasttargets_07();
		vo_glo_lasttargets_08();
		vo_glo_lasttargets_09();
		vo_glo_lasttargets_10();
	end
	e3m1_narrative_is_on = FALSE;
end

script command_script cs_e3_m1_pelican()
	cs_ignore_obstacles(TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_fly_to_and_face (e3_m1_pelican.p0, e3_m1_pelican.p1);
	cs_fly_to_and_face (e3_m1_pelican.p1, e3_m1_pelican.p2);
	cs_fly_to_and_face (e3_m1_pelican.p2, e3_m1_pelican.p3);
	cs_fly_to_and_face (e3_m1_pelican.p3, e3_m1_pelican.p4);
	cs_fly_to_and_face (e3_m1_pelican.p4, e3_m1_pelican.p5);
	cs_fly_to_and_face (e3_m1_pelican.p5, e3_m1_pelican.p6);
	cs_vehicle_speed(.7);
	cs_fly_to_and_face (e3_m1_pelican.p6, e3_m1_pelican.p9);
	cs_fly_to_and_face (e3_m1_pelican.p7, e3_m1_pelican.p9);
	cs_vehicle_speed(.5);
	cs_fly_to_and_face (e3_m1_pelican.p8, e3_m1_pelican.p9);
	sleep_s(100);
end

script static void f_e3_m1_scorpion_respawn()
	repeat
		if object_get_health(e3_m1_scorpion_1) <= 0 then
			object_create_anew(e3_m1_scorpion_1);
		end
		if object_get_health(e3_m1_scorpion_2) <= 0 then
			object_create_anew(e3_m1_scorpion_2);
		end
		if object_get_health(e3_m1_scorpion_3) <= 0 then
			object_create_anew(e3_m1_scorpion_3);
		end
		object_create_anew(e3_m1_aa_1);
		object_create_anew(e3_m1_aa_2);
		object_create_anew(e3_m1_aa_3);
		object_create_anew(e3_m1_aa_4);
		object_create_anew(e3_m1_aa_5);
		object_create_anew(e3_m1_aa_6);
		object_create_anew(e3_m1_aa_7);
		object_create_anew(e3_m1_aa_8);
		object_create_anew(e3_m1_aa_9);
		object_create_anew(e3_m1_aa_10);
		sleep_s(110);
	until (b_end_player_goal == TRUE);
	sleep_forever();
end