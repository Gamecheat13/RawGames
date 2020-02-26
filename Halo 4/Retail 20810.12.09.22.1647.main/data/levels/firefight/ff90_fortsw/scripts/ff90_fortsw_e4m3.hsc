////===========================================================================================================================
//============================================ FORTSW E4_M3 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================
global short e4_m3_random_switch = 0;
global boolean e4_m3_power_up_hub_pod_1 = FALSE;
global boolean e4_m3_power_up_hub_pod_2 = FALSE;
global boolean e4_m3_comm_base_pod_1 = FALSE;
global boolean b_e4_m3_1st_solo_pods_down = FALSE;
global boolean b_e4_m3_ready_for_surge = FALSE;
global boolean b_e4_m3_comms_are_up = FALSE;
global boolean b_e4_m3_drop_pod_line = FALSE;
global boolean b_e4_m3_switch_1_thrown = FALSE;
global boolean b_e4_m3_switch_2_thrown = FALSE;
global boolean b_e4_m3_surge_area_1_happened = FALSE;
global boolean b_e4_m3_surge_area_3_happened = FALSE;
global boolean b_e4_m3_dropping_drop_pod_at_coms = FALSE;

script startup e4_m3_start
	sleep_until (LevelEventStatus("is_e4_m3"), 1);
	firefight_mode_set_player_spawn_suppressed(true);
	switch_zone_set(e4_m3_dz);
	ai_ff_all = e4_m3_gr_ff_all;
	thread(f_music_e4m3_start());

//----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS -----------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------	
//set crate names
	f_add_crate_folder(dm_e4_m3_towers);
	f_add_crate_folder(dc_e4_m3);
	f_add_crate_folder(cr_e4_m3_activate);
	f_add_crate_folder(cr_e4_m3_cov_props);
	
	f_add_crate_folder(cr_e4_m3_unsc_props);
	f_add_crate_folder(cr_e4_m3_unsc_side_base);
	f_add_crate_folder(w_e4_m3_unsc_stuff);
	f_add_crate_folder(e_e4_m3_ammo);
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e4_m3_spawn_00, 90);
	firefight_mode_set_crate_folder_at(e4_m3_spawn_01, 91);
	firefight_mode_set_crate_folder_at(e4_m3_spawn_02, 92);
	firefight_mode_set_crate_folder_at(e4_m3_spawn_03, 93);
	firefight_mode_set_crate_folder_at(e4_m3_spawn_04, 94);
	
//set objective names
	firefight_mode_set_objective_name_at(e4_m3_switch_1, 1); 
	firefight_mode_set_objective_name_at(e4_m3_switch_2, 2); 
	firefight_mode_set_objective_name_at(e4_m3_switch_3, 3);
	firefight_mode_set_objective_name_at(e4_m3_switch_4, 4);
	
	firefight_mode_set_objective_name_at(e4_m3_lz_00, 50);
	firefight_mode_set_objective_name_at(e4_m3_lz_01, 51);
		
//set squad group names
	firefight_mode_set_squad_at(gr_e4_m3_guards1, 1);
	firefight_mode_set_squad_at(gr_e4_m3_guards2, 2);
	firefight_mode_set_squad_at(gr_e4_m3_guards3, 3);
	firefight_mode_set_squad_at(gr_e4_m3_guards4, 4);
	sleep_s(1);
	
	object_create_anew(e4_m3_base1_front_crate_1);
	object_create_anew(e4_m3_base1_front_crate_2);
	object_create_anew(e4_m3_base1_front_crate_3);
	
	object_create_anew(e4_m3_base1_back_crate_1);
	object_create_anew(e4_m3_base1_back_crate_2);
	object_create_anew(e4_m3_base1_back_crate_3);
	
	object_create_anew(e4_m3_base3_front_crate_1);
	object_create_anew(e4_m3_base3_front_crate_2);
	object_create_anew(e4_m3_base3_front_crate_3);
	
	object_create_anew(e4_m3_base3_back_crate_1);
	object_create_anew(e4_m3_base3_back_crate_2);
	object_create_anew(e4_m3_base3_back_crate_3);
	
	object_destroy(e4_m3_base_1_ammo_refill);
	object_destroy(e4_m3_base_3_ammo_refill);
	object_destroy(e4_m3_base_1_gun_rack);
	object_destroy(e4_m3_base_3_gun_rack);
	
	sleep_s(1);
	thread(f_e4_m3_starting_off());
	thread(f_e4_m3_hide_mcs());
	object_hide(f_e4_m3_portal_1, TRUE);
	object_cannot_take_damage(e4_m3_comm_tower);
	effects_perf_armageddon = 1;
end
//----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS END -------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------	

//-----------------------------------------------------------------------
//--------- Starting Mission stuff --------------------------------------
//-----------------------------------------------------------------------
script static void f_e4_m3_starting_off
	thread(f_music_e4m3_starting_off());
	sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
	player_enable_input(FALSE);
	fade_out(255,255,255,1);
	
	// insert intro stuff here..?
	
	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until(b_players_are_alive(), 1);
	ai_place(sq_ex_base2_hunter);
	ai_place(sq_ex_base1_snipers_1);
	ai_place(sq_ex_base1_snipers_2);
	ai_place(sq_ex_base1_snipers_3);
	sleep_s(4);
	ai_place(e4_m3_guards4);
	sleep_s(5);
	thread(f_music_e4m3_starting_off_cinematic_title_1());
	wake(vo_e4m3_intro);
	sleep_s(1);
	sleep_until (e4m3_narrative_is_on == FALSE);
	sleep_s(3);
	wake(vo_e4m3_playstart);
	sleep_s(1);
	sleep_until (e4m3_narrative_is_on == FALSE);
	thread(f_music_e4m3_starting_off_cinematic_title_2());
	sleep_s(4);
	wake(vo_e4m3_boxedin);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	//sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 15);
	//f_blip_ai_cui(e4_m3_gr_1st_wave, "navpoint_enemy");
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 4);
	b_e4_m3_ready_for_surge = TRUE;
	sleep_s(2);
	wake(vo_e4m3_commrelay);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	f_unblip_ai_cui(e4_m3_gr_1st_wave);
	f_new_objective(e4m3_obj_01);
	b_end_player_goal = TRUE;
	thread(f_e4_m3_call_unsc());
	sleep_s(1);
	device_set_power(e4_m3_switch_4, 1);
	ai_set_objective(e4_m3_gr_ff_all, obj_guard_comm_base);
end

script static void f_e4_m3_hide_mcs
	sleep_until(b_players_are_alive(), 1);
	thread(f_music_e4m3_hide_mcs());
	sleep_s(0.5);
	fade_in(255,255,255,60);
	thread(f_e4_m3_player0_portal());
	thread(f_e4_m3_player1_portal());
	thread(f_e4_m3_player2_portal());
	thread(f_e4_m3_player3_portal());
	
	//gmu 8/31/2012 -- for fix for bug 96993
	//adding 1 instance of creating new spawn folder here and deleting this from being called by every valid player
	f_create_new_spawn_folder (90);
	sleep_s(1);
	thread(f_e4_m3_area_1_surge());
	thread(f_e4_m3_area_3_surge());
	object_hide(e4_m3_mc_01, TRUE);
	object_hide(e4_m3_mc_02, TRUE);
	object_hide(e4_m3_mc_03, TRUE);
	object_hide(e4_m3_mc_04, TRUE);
	sleep_s(2);
	object_destroy(e4_m3_mc_01);
	object_destroy(e4_m3_mc_02);
	object_destroy(e4_m3_mc_03);
	object_destroy(e4_m3_mc_04);
end

script static void f_e4_m3_player0_portal
	if(player_valid(player0)) then
		//commenting out -- gmu 8/31/2012 -- for fix for bug 96993, too many instances of f_create_new_spawn_folder being called and making no spawn folders
		//f_create_new_spawn_folder (90);
		player_control_lock_gaze(player0, e4_m3_look.p0, 60);
		object_cannot_take_damage(player0);
		sleep_s(2);
		player_control_unlock_gaze(player0);
		player_enable_input(TRUE);
		sleep_s(8);
		object_can_take_damage(player0);
	end
end

script static void f_e4_m3_player1_portal
	if(player_valid(player1)) then
	 	//commenting out -- gmu 8/31/2012 -- for fix for bug 96993, too many instances of f_create_new_spawn_folder being called and making no spawn folders
		//f_create_new_spawn_folder (90);
		player_control_lock_gaze(player1, e4_m3_look.p0, 60);
		object_cannot_take_damage (player1);
		sleep_s(2);
		player_control_unlock_gaze(player1);
		player_enable_input(TRUE);
		sleep_s(8);
		object_can_take_damage(player1);
	end
end

script static void f_e4_m3_player2_portal
	if(player_valid(player2)) then
		//commenting out -- gmu 8/31/2012 -- for fix for bug 96993, too many instances of f_create_new_spawn_folder being called and making no spawn folders
		//f_create_new_spawn_folder (90);
		player_control_lock_gaze(player2, e4_m3_look.p0, 60);
		object_cannot_take_damage(player2);
		sleep_s(2);
		player_control_unlock_gaze(player2);
		player_enable_input(TRUE);
		sleep_s(8);
		object_can_take_damage(player2);
	end
end

script static void f_e4_m3_player3_portal
	if(player_valid(player3)) then
		//commenting out -- gmu 8/31/2012 -- for fix for bug 96993, too many instances of f_create_new_spawn_folder being called and making no spawn folders
		//f_create_new_spawn_folder (90);
		player_control_lock_gaze(player3, e4_m3_look.p0, 60);
		object_cannot_take_damage (player3);
		sleep_s(2);
		player_control_unlock_gaze(player3);
		player_enable_input(TRUE);
		sleep_s(8);
		object_can_take_damage(player3);
	end
end

script static void f_e4_m3_blow_crate (object_name obj_object, real prop_x, real prop_y, real prop_z)
	object_set_physics(obj_object, TRUE);
	object_set_velocity(obj_object, prop_x, prop_y, prop_z);
	sleep_rand_s(1,3);
	effect_new_on_ground(objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, obj_object);
	object_destroy(obj_object);
end

script static void f_e4_m3_area_1_surge
	sleep_until(b_e4_m3_ready_for_surge == TRUE);
	sleep_until(volume_test_players(e4_m3_trigger_1), 1);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 10, 1);
	thread(f_music_e4m3_area_1_surge());
	ai_place(sq_ex_base1_hunter);
	ai_place(sq_ex_base1_grunts);
	b_e4_m3_surge_area_1_happened = TRUE;
	object_create_anew(e4_m3_base_1_ammo_refill);
	object_create_anew(e4_m3_base_1_gun_rack);
	thread(f_e4_m3_blow_crate_1_1());
	thread(f_e4_m3_blow_crate(e4_m3_base1_front_crate_2, 0, 2, 3));
	thread(f_e4_m3_blow_crate(e4_m3_base1_front_crate_3, -4, 0, 5));
	thread(f_e4_m3_blow_crate(e4_m3_base1_back_crate_1, 4, 0, -5));
	thread(f_e4_m3_blow_crate(e4_m3_base1_back_crate_2, 0, 2, -3));
	thread(f_e4_m3_blow_crate(e4_m3_base1_back_crate_3, -4, 0, -5));
	sleep_s(2);
	f_e4_m3_watch_out_global_vo();
	ai_grunt_kamikaze(sq_ex_base1_grunts.k_1);
	sleep_s(2);
	ai_grunt_kamikaze(sq_ex_base1_grunts.k_2);
end

script static void f_e4_m3_blow_crate_1_1
	object_destroy(e4_m3_base1_front_door_1);
	object_destroy(e4_m3_base1_front_door_2);
	object_destroy(e4_m3_base1_back_door_1);
	object_destroy(e4_m3_base1_back_door_2);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_base1_bd_1);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_base1_fd_1);
	f_e4_m3_blow_crate(e4_m3_base1_front_crate_1, 4, 0, 5);
end
	
script static void f_e4_m3_area_3_surge
	sleep_until(b_e4_m3_ready_for_surge == TRUE);
	sleep_until (volume_test_players(e4_m3_trigger_3), 1);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 10, 1);
	thread(f_music_e4m3_area_3_surge());
	ai_place(sq_ex_base3_hunter);
	ai_place(sq_ex_base3_grunts);
	b_e4_m3_surge_area_3_happened = TRUE;
	object_create_anew(e4_m3_base_3_ammo_refill);
	object_create_anew(e4_m3_base_3_gun_rack);
	thread(f_e4_m3_blow_crate_2_1());
	thread(f_e4_m3_blow_crate(e4_m3_base3_front_crate_2, 0, 2, 3));
	thread(f_e4_m3_blow_crate(e4_m3_base3_front_crate_3, 4, 0, 5));
	thread(f_e4_m3_blow_crate(e4_m3_base3_back_crate_1, 6, 1, -7));
	thread(f_e4_m3_blow_crate(e4_m3_base3_back_crate_2, -2, 3, -12));
	thread(f_e4_m3_blow_crate(e4_m3_base3_back_crate_3, -5, 1, -5));
	sleep_s(2);
	f_e4_m3_watch_out_global_vo();
	ai_grunt_kamikaze(sq_ex_base3_grunts.k_1);
	sleep_s(2);
	ai_grunt_kamikaze(sq_ex_base3_grunts.k_2);
end

script static void f_e4_m3_blow_crate_2_1
	object_destroy(e4_m3_base3_front_door_1);
	object_destroy(e4_m3_base3_front_door_2);
	object_destroy(e4_m3_base3_back_door_1);
	object_destroy(e4_m3_base3_back_door_2);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_base3_bd_1);
	effect_new(fx\library\explosion\explosion_crate_destruction_major.effect, fl_base3_fd_1);
	f_e4_m3_blow_crate(e4_m3_base3_front_crate_1, -4, 0, 5);
end

script static void f_e4_m3_call_unsc
	sleep_until(LevelEventStatus("e4_m3_call_unsc"), 1);
	thread(f_music_e4m3_call_unsc());
	if b_e4_m3_surge_area_1_happened == TRUE then
		ai_set_objective(sq_ex_base1_hunter, obj_guard_comm_base);
		ai_set_objective(sq_ex_base1_grunts, obj_guard_comm_base);
	end
	if b_e4_m3_surge_area_3_happened == TRUE then 
		ai_set_objective(sq_ex_base3_hunter, obj_guard_comm_base);
		ai_set_objective(sq_ex_base3_grunts, obj_guard_comm_base);
	end
	thread(f_e4_m3_population_control_1());
	sleep_s(1);
	vo_glo_gotit_03();
	sleep_s(1);
	b_end_player_goal = TRUE;
	thread(f_e4_m3_coms_are_up());
end

script static void f_e4_m3_population_control_1()
	if b_e4_m3_dropping_drop_pod_at_coms == FALSE then
		repeat
			ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
			if ai_living_count(e4_m3_gr_ff_all) >= 8 then
				begin_random_count (1)
					ai_kill(sq_ex_base1_grunts.e1);
					ai_kill(sq_ex_base1_grunts.elite);
					ai_kill(sq_ex_base1_grunts.g_i_1);
					ai_kill(sq_ex_base1_grunts.g_i_2);
					ai_kill(sq_ex_base1_grunts.spawn_points_7);
					ai_kill(sq_ex_base1_grunts.l1);
					ai_kill(sq_ex_base3_grunts.e1);
					ai_kill(sq_ex_base3_grunts.elite);
					ai_kill(sq_ex_base3_grunts.g_i_1);
					ai_kill(sq_ex_base3_grunts.g_i_2);
					ai_kill(sq_ex_base3_grunts.spawn_points_4);
					ai_kill(sq_ex_base3_grunts.l1);
				end
				sleep_s(1);
			end
		until (b_e4_m3_dropping_drop_pod_at_coms == TRUE or ai_living_count(e4_m3_gr_ff_all) <= 8);
	end
end

script static void f_e4_m3_coms_are_up()
	sleep_until(device_get_position(e4_m3_switch_4) > 0, 1);
	if b_e4_m3_surge_area_1_happened == FALSE then
		kill_script(f_e4_m3_area_1_surge);
	end
	if b_e4_m3_surge_area_3_happened == FALSE then
		kill_script(f_e4_m3_area_3_surge);
	end
	device_set_power(e4_m3_switch_4, 0);
	object_destroy(e4_m3_switch_4);
	sleep_until(device_get_position(dm_e4_m3_com_panel) == 1);
	thread(f_object_rotate_bounce_y(e4_m3_comm_tower, 60.0, 6.00, 2.5, 3.0, 0, f_e4m3_sfx_unsc_comm_tower_rotate_start(), f_e4m3_sfx_unsc_comm_tower_rotate_stop()) );
	thread(f_e4_m3_going_to_power_up_hub());
	thread(f_music_e4m3_coms_are_up_title_1());
	wake(vo_e4m3_clearedup);
	sleep_s(1);
	sleep_until (e4m3_narrative_is_on == FALSE);
	thread(f_music_e4m3_coms_are_up_title_2());
	sleep_s(2);
	vo_glo_droppod_01();
	sleep_s(3);
	b_e4_m3_dropping_drop_pod_at_coms = TRUE;
	kill_script(f_e4_m3_population_control_1);
	thread(f_e4_m3_drop_pod_1());
	thread(f_music_e4m3_drop_on_com_station());
	sleep_until(e4_m3_comm_base_pod_1 == TRUE);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(gr_e4_m3_sq_comm_base) <= 8);
	sleep_s(1);
	vo_glo_stalling_04();
	sleep_s(3);
	sleep_until(ai_living_count(gr_e4_m3_sq_comm_base) <= 2);
	sleep_s(2);
	wake(vo_e4m3_fortsinfo);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	thread(f_music_e4m3_coms_are_up_title_3());
	wake(vo_e4m3_activateportal);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	thread(f_music_e4m3_coms_are_up_title_4());
	f_new_objective(e4m3_obj_02);
	b_e4_m3_comms_are_up = TRUE;
	
	//b_end_player_goal = TRUE; // <---moving this to narrative for timing
	
	device_set_power(e4_m3_switch_3, 1);
	thread(f_e4_m3_solo_pods_1());
	thread(f_e4_m3_switch01_c());
	thread(f_e4_m3_lower_portals());
	if b_e4_m3_surge_area_1_happened == FALSE then
		thread(f_e4_m3_area_1_surge());
	end
	if b_e4_m3_surge_area_3_happened == FALSE then
		thread(f_e4_m3_area_3_surge());
	end
end

script static void f_e4_m3_solo_pods_1  /// pods that drop after you turn on the comms
	//sleep_until(volume_test_players(e4_m3_solo_pod_trig_1));
	if ai_living_count(e4_m3_gr_ff_all) <= 18 then
		b_e4_m3_1st_solo_pods_down = TRUE;
		sleep_until(b_e4_m3_comms_are_up == TRUE, 1);
		f_e4_m3_drop_pods_vo();
		sleep_s(2);
		thread(f_music_e4m3_solo_pods_1());
		object_create(e4_m3_pod_1);
		thread(e4_m3_pod_1->drop_to_point(e4_m3_solo_pod_1, e4_m3_pod_1_drop.p0, .85, DEFUALT ));
		sleep_s(1);
		object_create(e4_m3_pod_2);
		thread(e4_m3_pod_2->drop_to_point(e4_m3_solo_pod_2, e4_m3_pod_2_drop.p0, .85, DEFUALT ));
	end
end

script static void f_e4_m3_going_to_power_up_hub
	sleep_until(volume_test_players(e4_m3_power_up_hub_1));
	sleep_until(b_e4_m3_comms_are_up == TRUE, 1);
	if b_e4_m3_1st_solo_pods_down == FALSE then
		f_e4_m3_solo_pods_1();
		b_e4_m3_drop_pod_line = TRUE;
	end
	sleep_s(1);
	thread(f_e4_m3_power_up_hub_pod_1());
	sleep_until(e4_m3_power_up_hub_pod_1 == TRUE);
	sleep_s(3);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 3);
	sleep_s(1);
	if b_e4_m3_drop_pod_line == FALSE then
		f_e4_m3_drop_pods_vo();
	end
	sleep_s(2);
	thread(f_e4_m3_power_up_hub_pod_2());
	sleep_until(e4_m3_power_up_hub_pod_2 == TRUE);
	sleep_s(5);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 15);
	thread(f_e4_m3_power_up_hub_pod_3());
end

script static void f_e4_m3_switch01_c
	sleep_until(object_valid(e4_m3_switch_3) and (device_get_position(e4_m3_switch_3) > 0), 1);
	ai_set_objective(gr_e4_m3_power_up_hub_2, obj_guard_2);
	ai_set_objective(gr_e4_m3_power_up_hub_3, obj_guard_3);
	device_set_power(e4_m3_switch_3, 0);
	device_set_position(e4_m3_glow_switch3, 0);
	thread(f_music_e4m3_switch01_c());
	sleep_s(1);
	device_set_position(dm_forts_e4_m3_03, 0);
	device_set_position(dm_forts_e4_m3_04, 0);
	sleep_s(5);
	effect_new(levels\firefight\ff90_fortsw\fx\energycore\composer_shield.effect, arch_center_mkr_01);
	ai_set_objective(e4_m3_gr_ff_all, obj_survival);
	thread(f_e4_m3_guard_switch_2());
	thread(f_e4_m3_guard_switch_3());
	object_destroy(e4_m3_switch_3);
end

script static void f_e4_m3_lower_portals
	sleep_until(LevelEventStatus("e4_m3_lower_portals"), 1);
	sleep_s(5);
	thread(f_music_e4m3_lower_portals_title());
	wake(vo_e4m3_2portalsopen);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	e4_m3_random_switch = random_range(1,2);
	
//	navpoint_track_object_named(e4_m3_switch_1, "navpoint_activate"); //<-- moving all this to narrative
//	navpoint_track_object_named(e4_m3_switch_2, "navpoint_activate");

	thread(f_e4_m3_switch_1());
	thread(f_e4_m3_switch_2());
	device_set_power(e4_m3_switch_1, 1);
	device_set_power(e4_m3_switch_2, 1);
end
	
script static void f_e4_m3_switch_1 // script that controls the 50/50 switch.
	if e4_m3_random_switch == 1 then //correct tower
		sleep_until( object_valid(e4_m3_switch_1) and (device_get_position(e4_m3_switch_1) > 0), 1 );
		b_e4_m3_switch_1_thrown = TRUE;
		device_set_power(e4_m3_switch_1, 0);
		device_set_power(e4_m3_switch_2, 0);
		thread(f_music_e4m3_switch_1_correct_tower());
		navpoint_track_object(e4_m3_switch_1, FALSE);
		navpoint_track_object(e4_m3_switch_2, FALSE);
		device_set_position(e4_m3_glow_switch1, 0);
		sleep_s(1);
		device_set_position(dm_forts_e4_m3_01, 0);
		sleep_until(device_get_position(dm_forts_e4_m3_01) == 0);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_top_mkr_01, pylon02_topArch_mkr_01);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_bottom_mkr_01, pylon02_bottom_mkr_02);
		thread(f_music_e4m3_switch_1_correct_tower_title_1());
		wake(vo_e4m3_analyzeportal);
		sleep_s(1);
		sleep_until (e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		wake(vo_e4m3_portalsuccess);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		thread(f_music_e4m3_switch_1_correct_tower_title_3());
		sleep_s(3);
		wake(vo_e4m3_gotoportal1);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		// Miller : Almost got it.
		wake(vo_e4m3_slmost_got_it);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100', NONE, 1);
		sleep_s(3);
		e4m3_narrative_is_on = FALSE;
		f_e4_m3_drop_pods_vo();
		sleep_s(1);
		thread(f_e4_m3_end_pods());
	else //wrong tower
		sleep_until( object_valid(e4_m3_switch_1) and (device_get_position(e4_m3_switch_1) > 0), 1 );
		b_e4_m3_switch_1_thrown = TRUE;
		device_set_power(e4_m3_switch_1, 0);
		device_set_power(e4_m3_switch_2, 0);
		thread(f_music_e4m3_switch_1_wrong_tower());
		navpoint_track_object(e4_m3_switch_1, FALSE);
		navpoint_track_object(e4_m3_switch_2, FALSE);
		device_set_position(e4_m3_glow_switch1, 0);
		sleep_s(1);
		device_set_position(dm_forts_e4_m3_01, 0);
		sleep_until(device_get_position(dm_forts_e4_m3_01) == 0);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_top_mkr_01, pylon02_topArch_mkr_01);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon02_bottom_mkr_01, pylon02_bottom_mkr_02);
		thread(f_music_e4m3_switch_1_wrong_tower_title_1());
		wake(vo_e4m3_analyzeportal);
		sleep_s(1);
		sleep_until (e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		thread(f_music_e4m3_switch_1_wrong_tower_title_2());
		wake(vo_e4m3_portalfail);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		navpoint_track_object_named(e4_m3_switch_2, "navpoint_activate");
		device_set_power(e4_m3_switch_2, 1);
	end
end

script static void f_e4_m3_switch_2  // script that controls the 50/50 switch.
	if e4_m3_random_switch == 2 then //right tower
		sleep_until( object_valid(e4_m3_switch_2) and (device_get_position(e4_m3_switch_2) > 0), 1 );
		b_e4_m3_switch_2_thrown = TRUE;
		device_set_power(e4_m3_switch_1, 0);
		device_set_power(e4_m3_switch_2, 0);
		thread(f_music_e4m3_switch_2_correct_tower());
		navpoint_track_object(e4_m3_switch_1, FALSE);
		navpoint_track_object(e4_m3_switch_2, FALSE);
		device_set_position(e4_m3_glow_switch2, 0);
		sleep_s(1);
		device_set_position(dm_forts_e4_m3_02, 0);
		sleep_until(device_get_position(dm_forts_e4_m3_02) == 0);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_top_mkr_01, pylon01_topArch_mkr_01);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_bottom_mkr_01, pylon01_bottom_mkr_02);
		thread(f_music_e4m3_switch_2_correct_tower_title_2());
		wake(vo_e4m3_analyzeportal);
		sleep_s(1);
		sleep_until (e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		wake(vo_e4m3_portalsuccess);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		thread(f_music_e4m3_switch_1_correct_tower_title_3());
		sleep_s(3);
		wake(vo_e4m3_gotoportal1);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		// Miller : Almost got it.
		wake(vo_e4m3_slmost_got_it);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100', NONE, 1);
		sleep_s(3);
		e4m3_narrative_is_on = FALSE;
		f_e4_m3_drop_pods_vo();
		sleep_s(1);
		thread(f_e4_m3_end_pods());
	else //wrong tower
		sleep_until( object_valid(e4_m3_switch_2) and (device_get_position(e4_m3_switch_2) > 0), 1 );
		b_e4_m3_switch_2_thrown = TRUE;
		device_set_power(e4_m3_switch_1, 0);
		device_set_power(e4_m3_switch_2, 0);
		thread(f_music_e4m3_switch_2_wrong_tower());
		navpoint_track_object(e4_m3_switch_1, FALSE);
		navpoint_track_object(e4_m3_switch_2, FALSE);
		device_set_position(e4_m3_glow_switch2, 0);
		sleep_s(1);
		device_set_position(dm_forts_e4_m3_02, 0);
		sleep_until(device_get_position(dm_forts_e4_m3_02) == 0);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_top_mkr_01, pylon01_topArch_mkr_01);
		effect_new_between_points(levels\firefight\ff90_fortsw\fx\energycore\spartops_energycore_beam.effect, pylon01_bottom_mkr_01, pylon01_bottom_mkr_02);
		thread(f_music_e4m3_switch_2_title_1());
		wake(vo_e4m3_analyzeportal);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		thread(f_music_e4m3_switch_2_title_2());
		wake(vo_e4m3_portalfail);
		sleep_s(1);
		sleep_until(e4m3_narrative_is_on == FALSE);
		sleep_s(3);
		navpoint_track_object_named(e4_m3_switch_1, "navpoint_activate");
		device_set_power(e4_m3_switch_1, 1);
	end
end

script static void f_e4_m3_portal_line
	sleep_until(volume_test_players(e4_m3_portal_trig), 1);
	wake(vo_e4m3_getinportal);
end

script static void f_e4_m3_drop_pod_1  /// pod that drops by the comms station
	ai_place_in_limbo(e4_m3_sq_comm_base);
	f_load_drop_pod(dm_e4m3_rail_01, e4_m3_sq_comm_base, v_e4m3_pod_01, FALSE);
	sleep_s(5);
	e4_m3_comm_base_pod_1 = TRUE;
end

script static void f_e4_m3_power_up_hub_pod_1  /// pod that drops by front ramp to middle base
	thread(f_music_e4m3_power_up_hub_pod_1());
	ai_place_in_limbo(e4_m3_power_up_hub_1);
	f_load_drop_pod(dm_e4m3_rail_04, e4_m3_power_up_hub_1, v_e4m3_pod_04, FALSE);
	sleep_s(5);
	e4_m3_power_up_hub_pod_1 = TRUE;
end

script static void f_e4_m3_power_up_hub_pod_2  /// pod that drops on mid level
	thread(f_music_e4m3_power_up_hub_pod_2());
	ai_place_in_limbo(e4_m3_power_up_hub_2);
	f_load_drop_pod(dm_e4m3_rail_07, e4_m3_power_up_hub_2, v_e4m3_pod_07, FALSE);
	sleep_s(5);
	e4_m3_power_up_hub_pod_2 = TRUE;
end

script static void f_e4_m3_power_up_hub_pod_3  /// pod that drops on top level
	thread(f_music_e4m3_power_up_hub_pod_3());
	ai_place_in_limbo(e4_m3_power_up_hub_3);
	f_load_drop_pod(dm_e4m3_rail_02, e4_m3_power_up_hub_3, v_e4m3_pod_02, FALSE);
end

script static void f_e4_m3_guard_switch_2
	sleep_until(volume_test_players(e4_m3_trigger_2), 1);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 10, 1);
	if b_e4_m3_switch_1_thrown == FALSE then
		thread(f_e4_m3_switch2_big_pod());
		thread(f_e4_m3_solo_pods_5_6());
		thread(f_music_e4m3_guard_switch_2());
	end
end

script static void f_e4_m3_switch2_big_pod  /// pod that drops by switch 3
	ai_place_in_limbo(e4_m3_switch_2);
	f_load_drop_pod(dm_e4m3_rail_06, e4_m3_switch_2, v_e4m3_pod_06, FALSE);
end

script static void f_e4_m3_solo_pods_5_6  /// pods that drop after you turn on the comms
	object_create (e4_m3_pod_5);
	thread(e4_m3_pod_5->drop_to_point(e4_m3_solo_pod_5, e4_m3_pod_5_drop.p0, .85, DEFUALT ));
	sleep_s(2);
	object_create (e4_m3_pod_6);
	thread(e4_m3_pod_6->drop_to_point(e4_m3_solo_pod_6, e4_m3_pod_6_drop.p0, .85, DEFUALT ));
end

script static void f_e4_m3_guard_switch_3
	sleep_until(volume_test_players(e4_m3_trigger_3), 1);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 10, 1);
	if b_e4_m3_switch_2_thrown == FALSE then
		thread(f_e4_m3_switch3_big_pod());
		thread(f_e4_m3_solo_pods_3_4());
		thread(f_music_e4m3_guard_switch_3());
	end
end

script static void f_e4_m3_switch3_big_pod  /// pod that drops by switch 3
	ai_place_in_limbo(e4_m3_switch_3);
	f_load_drop_pod(dm_e4m3_rail_05, e4_m3_switch_3, v_e4m3_pod_05, FALSE);
end

script static void f_e4_m3_solo_pods_3_4  /// pods that drop after you turn on the comms
	object_create (e4_m3_pod_3);
	thread(e4_m3_pod_3->drop_to_point(e4_m3_solo_pod_3, e4_m3_pod_3_drop.p0, .85, DEFUALT ));
	sleep_s(2);
	object_create (e4_m3_pod_4);
	thread(e4_m3_pod_4->drop_to_point(e4_m3_solo_pod_4, e4_m3_pod_4_drop.p0, .85, DEFUALT ));
end

script static void f_e4_m3_end_pods
	thread(f_music_e4m3_end_pods());
	sleep_s(1);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 19, 1);
	object_create (e4_m3_pod_7);
	thread(e4_m3_pod_7->drop_to_point(e4_m3_solo_pod_7, e4_m3_pod_7_drop.p0, .85, DEFUALT ));
	sleep_s(1);
	//f_blip_ai_cui(e4_m3_gr_ff_all, "navpoint_enemy");
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 19, 1);
	object_create (e4_m3_pod_8);
	thread(e4_m3_pod_8->drop_to_point(e4_m3_solo_pod_8, e4_m3_pod_8_drop.p0, .85, DEFUALT ));
	sleep_s(1);
	//f_blip_ai_cui(e4_m3_gr_ff_all, "navpoint_enemy");
ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 19, 1);
	object_create (e4_m3_pod_9);
	thread(e4_m3_pod_9->drop_to_point(e4_m3_solo_pod_9, e4_m3_pod_9_drop.p0, .85, DEFUALT ));
	sleep_s(1);
	//f_blip_ai_cui(e4_m3_gr_ff_all, "navpoint_enemy");
	thread(f_music_e4m3_final_large_pod());
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 10, 1);
	ai_place_in_limbo(e4_m3_final_pod);
	f_load_drop_pod(dm_e4m3_rail_08, e4_m3_final_pod, v_e4m3_pod_08, FALSE);
	sleep_s(3);
	vo_glo_remainingcov_05();
	sleep_s(2);
	f_new_objective(e4m3_obj_03);
	b_end_player_goal = TRUE;
	f_blip_ai_cui(e4_m3_gr_ff_all, "navpoint_enemy");
	object_destroy(e4_m3_switch_1);
	object_destroy(e4_m3_switch_2);
	ai_survival_cleanup(e4_m3_gr_ff_all, TRUE, TRUE);
	//sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 5, 1);
	//f_blip_ai_cui(e4_m3_gr_ff_all, "navpoint_enemy");
	ai_set_objective(e4_m3_gr_ff_all, obj_survival);
	sleep_until(ai_living_count(e4_m3_gr_ff_all) <= 5, 1);
	kill_script(f_e4_m3_area_1_surge);
	kill_script(f_e4_m3_area_3_surge);
	kill_script(f_e4_m3_going_to_power_up_hub);
	thread(f_music_e4m3_final_guys_to_kill());
	sleep_s(2);
	vo_glo_gotit_01();
	object_dissolve_from_marker(f_e4_m3_portal_1, phase_in, fx_portal_center);
	object_hide(f_e4_m3_portal_1, FALSE);
	device_set_position_track(f_e4_m3_portal_1, "open:portal", 0.0 );
	sound_looping_start(sound\environments\multiplayer\scurve\scurve_machines\new_machines\ambience\machine_59_fore_portal_pve_loop, f_e4_m3_portal_1, 1);
	device_animate_position(f_e4_m3_portal_1, 1, 2, 1.0, 1.0, TRUE );
	thread(f_e4_m3_portal_line());
	thread(f_e4_m3_end_level());
	wake(vo_e4m3_gotoportal2);
	sleep_s(1);
	sleep_until(e4m3_narrative_is_on == FALSE);
	f_new_objective (e4m3_obj_04);
	
	//b_end_player_goal = TRUE;  //<-- moving to narrative
	
	thread(f_music_e4m3_finish());
end

script static void f_e4_m3_end_level
	sleep_until(LevelEventStatus("e4_m3_end_level"), 1);
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(255,255,255,15);
	ai_disregard(players(), TRUE);
	player_camera_control(FALSE);
	player_enable_input(FALSE);
	b_end_player_goal = TRUE;
end

script static void f_e4_m3_watch_out_global_vo
	sleep_until(e4m3_narrative_is_on == FALSE, 1);
	e4m3_narrative_is_on = TRUE;
	begin_random_count(1)
		vo_glo_watchout_01();
		vo_glo_watchout_02();
		vo_glo_watchout_03();
		vo_glo_watchout_04();
		vo_glo_watchout_05();
		vo_glo_watchout_06();
		vo_glo_watchout_07();
		vo_glo_watchout_08();
		vo_glo_watchout_09();
		vo_glo_watchout_10();
	end
	e4m3_narrative_is_on = FALSE;
end

script static void f_e4_m3_drop_pods_vo
	sleep_until(e4m3_narrative_is_on == FALSE, 1);
	e4m3_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_droppod_02();
		vo_glo_droppod_03();
		vo_glo_droppod_04();
		vo_glo_droppod_05();
		vo_glo_droppod_08();
		vo_glo_droppod_09();
		vo_glo_droppod_10();
	end
	e4m3_narrative_is_on = FALSE;
end

script static void f_object_rotate_bounce_y( object_name obj_object, real r_y_rot, real r_time, real r_pause_min, real r_pause_max, short s_direction, sound snd_start, sound snd_stop )
	// randomize start direction
	if ( s_direction == 0 ) then
		begin_random_count( 1 )
			s_direction = 1;
			s_direction = -1;
		end
	end
	sleep_until( object_valid(obj_object), 1 );
	object_rotate_by_offset( obj_object, r_time * 0.5, 0.0, 0.0, (r_y_rot * 0.5) * s_direction, 0.0, 0.0 );
	s_direction = -s_direction;
	repeat
		sound_impulse_start( snd_start, obj_object, 1.0 );
		object_rotate_by_offset( obj_object, r_time, 0.0, 0.0, r_y_rot * s_direction, 0.0, 0.0 );
		sleep_rand_s( r_pause_min, r_pause_max );
		sound_impulse_start( snd_stop, obj_object, 1.0 );
		s_direction = -s_direction;
	until( not object_valid(obj_object) or (object_get_health(obj_object) <= 0.0), 1 );
	// stop it if it's dead
	if(object_valid(obj_object)) then
		object_rotate_by_offset( obj_object, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	end
end	

script static sound f_e4m3_sfx_unsc_comm_tower_rotate_start()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_in.sound';
end

script static sound f_e4m3_sfx_unsc_comm_tower_rotate_stop()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_out.sound';
end
