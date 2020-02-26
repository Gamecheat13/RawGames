////=============================================================================================================================
////============================================ E10_M1 BREACH INTEL SCRIPT ==================================================
////=============================================================================================================================
global boolean b_e10_m1_stop_firing_1 = FALSE;
global boolean b_e10_m1_stop_firing_2 = FALSE;
global boolean b_e10_m1_stop_firing_3 = FALSE;
global boolean b_e10_m1_gun1_2_down = FALSE;
global boolean b_e10m1_gun_3_stop_firing = FALSE;
global boolean b_e10m1_all_guns_down = FALSE;
global boolean b_e10m1_shield_blow = FALSE;
global boolean b_e10m1_pelican_at_l = FALSE;
global boolean b_e10m1_jail_switch_1_flipped = FALSE;
global boolean b_e10m1_jail_switch_2_flipped = FALSE;
global boolean b_e10m1_ready_for_shield_aa_3 = TRUE;
global object g_ics_player_e10_m1 = NONE;

script startup f_brach_e10_m1
	//Wait for the variant event
	if (f_spops_mission_startup_wait("e10_m1") ) then
		wake(f_breach_e10_m1_placement);
	end
end

script dormant f_breach_e10_m1_placement()
	f_spops_mission_setup( "e10_m1", e10_m1_dz_intro, gr_ff_e10_m1_all, sp_e10_m1_start_pos, 80 );
	print("___________________________________running e10 m1");
	//fade_out(0,0,0,0);
	sleep_s(0.5);
	
//set crate names
	f_add_crate_folder(e10m1_right_side_crates);
	f_add_crate_folder(e10m1_middle_crates);
	f_add_crate_folder(e10m1_left_side_crates);
	f_add_crate_folder(e10m1_digger_crates);
	f_add_crate_folder(e10m1_e_ammo);
	f_add_crate_folder(e10m1_cov_turrets);
	f_add_crate_folder(e10m1_dcs);
	f_add_crate_folder(e10_m1_machines);
	f_add_crate_folder(e10m1_weapons);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sp_e10_m1_start_pos, 80);
	firefight_mode_set_crate_folder_at(sp_e10_m1_01, 81);
	firefight_mode_set_crate_folder_at(sp_e10_m1_02, 82);
	firefight_mode_set_crate_folder_at(sp_e10_m1_03, 83);
	firefight_mode_set_crate_folder_at(sp_e10_m1_04, 84);
	firefight_mode_set_crate_folder_at(sp_e10_m1_05, 85);
	firefight_mode_set_crate_folder_at(sp_e10_m1_06, 86);	

//set locations
	firefight_mode_set_objective_name_at(e10_m1_lz_00, 50);
	firefight_mode_set_objective_name_at(e10_m1_lz_01, 51);
	firefight_mode_set_objective_name_at(e10_m1_lz_02, 52);
	firefight_mode_set_objective_name_at(e10_m1_lz_03, 53);
	firefight_mode_set_objective_name_at(e10_m1_lz_04, 54);
	firefight_mode_set_objective_name_at(e10_m1_lz_05, 55);
	firefight_mode_set_objective_name_at(e10_m1_lz_06, 56);
	firefight_mode_set_objective_name_at(e10_m1_lz_07, 57);
	firefight_mode_set_objective_name_at(e10_m1_lz_08, 58);
	firefight_mode_set_objective_name_at(e10_m1_lz_09, 59);
	firefight_mode_set_objective_name_at(e10_m1_lz_10, 60);
	firefight_mode_set_objective_name_at(e10_m1_lz_11, 61);
	firefight_mode_set_objective_name_at(e10_m1_lz_12, 62);
	firefight_mode_set_objective_name_at(e10_m1_lz_13, 63);
	firefight_mode_set_objective_name_at(e10_m1_lz_14, 64);
		
//set squad group names
	firefight_mode_set_squad_at(sq_e10m1_guard_1, 1);
	firefight_mode_set_squad_at(sq_e10m1_guard_2, 2);
	firefight_mode_set_squad_at(sq_e10m1_guard_3, 3);
	
	thread(f_e10_m1_intro());
	
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );
end

//////-------------------------------------- OBJECTS END -------------------------------------------------------------------------

//////--------- Starting Mission stuff --------------------------------------
//////-----------------------------------------------------------------------
script static void f_e10_m1_intro()
// starts the mission and sends the grunts and hunters running towards the player.
	sleep_until (f_spops_mission_ready_complete(), 1);
	sleep_s(0.5);
	
	if editor_mode() then
		print ("editor mode, no intro playing");
	else
		//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m1_vin_sfx_intro', NONE, 1);
		pup_disable_splitscreen (TRUE);
		//pining textures on intro vignette
		streamer_pin_tag("levels\dlc\shared\textures\nature\mp_breach\mp_breach_rock_01_diff.bitmap");
		streamer_pin_tag("levels\dlc\shared\textures\nature\mp_breach\mp_breach_rockpile_tile_normal.bitmap");
		streamer_pin_tag("levels\dlc\shared\textures\nature\mp_breach\mp_breach_rock_01_normal.bitmap");
		//
		ai_enter_limbo(gr_ff_e10_m1_all);
		local long show = pup_play_show(e10_m1_intro);
		f_e10_m1_intro_vo_call();
		sleep_until(not pup_is_playing(show), 1);
		pup_disable_splitscreen (FALSE);
		streamer_clear_all_pinned_tags();
	end

	f_spops_mission_intro_complete(TRUE);
	sleep_until(f_spops_mission_start_complete(), 1);
	thread(f_e10_m1_music_start());
	thread(f_e10_m1_event0_start());
	thread(f_e10_m1_intro_ord_drop());
	sleep_s(1);
	ai_place(e10m1_pelican_intro);
	//thread(f_e10_m1_player_on_pelican_dead());
	fade_in(0,0,0,45);
	
	ai_exit_limbo(gr_ff_e10_m1_all);
	thread(f_e10m1_at_blocked_tunnel());
	thread(f_e10m1_tunnel_guard());
	thread(f_e10m1_tunnel_guard_2());
	thread(f_e10m1_backup_hunters_1());
	object_create_anew(dm_maw);
	device_set_position(dm_maw, 1);
	
	object_cannot_take_damage(e10m1_shield);
			
	sleep_s(7);
	vo_e10m1_covenant();
	sleep_s(20);
	b_end_player_goal = TRUE;
	f_new_objective(e10_m1_obj_1);
end

script static void f_e10_m1_intro_vo_call()
	thread(vo_e10m1_narr_in());
end

script static void f_e10_m1_intro_ord_drop()
	sleep_s(20);
	ordnance_drop(f_e10_m1_pod_6, "storm_rocket_launcher");
	sleep_s(9);
	ordnance_drop(f_e10_m1_pod_7, "storm_rocket_launcher");
end

script static void f_e10m1_backup_hunters_1()
	sleep_until(ai_living_count(sq_e10m1_guard_1) <= 0 or ai_living_count(sq_e10m1_guard_2) <= 0, 1);
	if not volume_test_players(t_e10m1_hunter_backup) then
		ai_place(sq_e10m1_guard_1_2);
	end
end
	
script static void f_e10m1_tunnel_guard()
//group at the end of the tunnel as you make your way down from the starting area.
	sleep_until(volume_test_players(t_e10m1_tunnel_guard), 1);
	cs_run_command_script(e10m1_pelican_intro, cs_e10m1_pelican_in_kill);
	kill_script(f_e10m1_backup_hunters_1);
	ai_place(e10m1_tunnel_guard_1);
	ai_place(e10m1_tunnel_guard_gunner);
	if ai_living_count(gr_ff_e10_m1_all) <= 12 then
		ai_place(e10m1_tunnel_guard_2);
	end
end

script static void f_e10m1_tunnel_guard_2()
//group that backs up 1, spawns by mid shade turret
	sleep_until(volume_test_players(t_e10m1_tunnel_guard_2), 1);
	f_create_new_spawn_folder(81);
	print("prepping zone set switch");
	prepare_to_switch_to_zone_set(e10_m1_dz);
	if ai_living_count(gr_ff_e10_m1_all) <= 12 then
		ai_place(e10m1_tunnel_guard_2);
	end
	ordnance_show_nav_markers(FALSE);
	if ai_living_count(sq_e10m1_guard_1) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_1.grunt_1);
	end
	sleep_s(3);
	if ai_living_count(sq_e10m1_guard_1) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_1.grunt_2);
	end
	sleep_s(3);
	if ai_living_count(sq_e10m1_guard_1) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_1.grunt_3);
	end
	if ai_living_count(sq_e10m1_guard_2) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_2.grunt_1);
	end
	sleep_s(3);
	if ai_living_count(sq_e10m1_guard_2) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_2.grunt_2);
	end
	sleep_s(3);
	if ai_living_count(sq_e10m1_guard_2) >= 1 then
		ai_grunt_kamikaze(sq_e10m1_guard_2.grunt_3);
	end
end

script static void f_e10m1_at_blocked_tunnel()
//crimson reaches the covered hole and sees that it is blocked. Miller says get inside digger
	sleep_until(LevelEventStatus ("e10m1_at_blocked_tunnel"), 1);
	thread(f_e10_m1_event0_stop());
	ai_set_objective(gr_ff_e10_m1_all_bipeds, e10m1_survival_middle);
	
	//-------------------------------
	switch_zone_set(e10_m1_dz);
	//-------------------------------
	
	sleep_s(1);
		
	ai_place_in_limbo(e10m1_turret_1);
	ai_place_in_limbo(e10m1_turret_2);
	ai_place_in_limbo(e10m1_turret_3);
	//sleep_s(1);
	effect_new_on_object_marker_loop(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_1.turret), fx_life_source);
	effect_new_on_object_marker_loop(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_2.turret), fx_life_source);
	effect_new_on_object_marker_loop(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_3.turret), fx_life_source);
	
	thread(f_e10m1_ready_for_pelican());
	
	vo_e10m1_big_rock();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	f_new_objective(e10_m1_obj_3);
	ai_set_objective(gr_ff_e10_m1_all_bipeds, e10m1_survival_middle);
	sleep_until(ai_living_count(gr_ff_e10_m1_all_bipeds) <= 8, 1);
	
	sleep_s(1);
	thread(vo_glo_droppod_02());
	sleep_s(2);
	thread(f_e10_m1_event1_start());
	ai_place_in_limbo(e10m1_pod_1);
	sleep_s(1);
	f_dlc_load_drop_pod(e10m1_drop_rail_1, none, e10m1_pod_1, e10m1_drop_pod_1);
	sleep_s(2);
//	vo_e10m1_pelican_shield();
//	sleep_s(1);
//	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	ai_place_in_limbo(e10m1_pod_2);
	sleep_s(1);
	f_dlc_load_drop_pod(e10m1_drop_rail_2, none, e10m1_pod_2, e10m1_drop_pod_2);
	
	sleep_s(3);
	vo_e10m1_get_inside();
	sleep_s(1);	
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	b_end_player_goal = TRUE;
end

script static void f_e10m1_ready_for_pelican()
	sleep_until(LevelEventStatus ("e10m1_ready_for_pelican"), 1);
	sleep_until(ai_living_count(gr_ff_e10_m1_all_bipeds) <= 4, 1);
	thread(f_e10_m1_event1_stop());
	sleep_s(1.5);	
	vo_e10m1_shield();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	
//	ai_place(e10m1_phantom_1); <--- moving to narrative
	
	f_new_objective(e10_m1_obj_4);
	thread(f_e10_m1_event2_start());
	
	object_create_anew(e10_m1_lz_10);
	navpoint_track_object_named(e10_m1_lz_10, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10m1_going_to_aa_1), 1);
	f_create_new_spawn_folder(82);
	f_unblip_object_cui(e10_m1_lz_10);
	object_create_anew(e10_m1_lz_11);
	navpoint_track_object_named(e10_m1_lz_11, "navpoint_goto");
		
	sleep_until(volume_test_players(t_e10m1_going_to_aa_2), 1);
	f_unblip_object_cui(e10_m1_lz_11);
	thread(f_e10_m1_event2_stop());
	vo_e10m1_guns_no_damage();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	thread(f_e10_m1_event3_start());
	sleep_s(1);
	
	thread(f_e10_m1_2nd_gun_defense());
	sleep_s(1);
	sleep_until(ai_living_count(gr_ff_e10_m1_all_bipeds) <= 5, 1);
	sleep_s(2);
	vo_e10m1_guns_no_damage2();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	
	sleep_s(3);
	vo_e10m1_hey_dalton();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	
	sleep_until(ai_living_count(gr_sq_e10m1_aa_turret_1) <= 0 and ai_living_count(gr_sq_e10m1_aa_turret_2) <= 0, 1);
	b_e10_m1_gun1_2_down = TRUE;
	
	sleep_s(0.5);
	vo_e10m1_nice_work();
	thread(f_e10_m1_event3_stop());
	thread(f_e10_m1_stop_firing_again());
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	//sleep_s(5);
	f_create_new_spawn_folder(83);
	thread(f_e10_m1_event4_start());
	
	if ai_living_count(gr_sq_e10m1_pod_3) >= 1 then
		ai_set_task(gr_sq_e10m1_pod_3, e10m1_left_side, guard_pad);
	end
	
	object_create_anew(e10_m1_lz_13);
	navpoint_track_object_named(e10_m1_lz_13, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10m1_gun3_arrive), 1);
	b_e10m1_gun_3_stop_firing = TRUE;
	object_destroy(e10_m1_lz_13);
	sleep_s(1);
	vo_e10m1_shields_up();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	ai_set_task(gr_ff_e10_m1_all_bipeds, e10m1_left_side, guard_pad);
	ai_place(e10m1_phantom_2);
	sleep_s(2);
	vo_e10_m2_miller_reinforcements_01();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	thread(f_e10_m1_stinger_hunters());
	sleep_until(b_e10m1_ready_for_shield_aa_3 == FALSE, 1);
	sleep_s(2);
	sleep_until(ai_living_count(gr_sq_e10m1_ph2_sq_1) <= 0, 1);
	
	sleep_s(1.5);
	object_set_function_variable(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret), shield_alpha, 1, 2);
	sleep_s(2);
	effect_kill_object_marker(levels\dlc\shared\effects\fr_turret_shield.effect, ai_vehicle_get(e10m1_turret_3.turret), fx_life_source);
	sleep_s(0.5);
	vo_e10_m2_roland_shield();
	
	object_can_take_damage(ai_vehicle_get(e10m1_turret_3.turret));
	f_blip_object_cui(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret), "navpoint_healthbar_neutralize");
	thread(f_e10m1_turret_3_dead());
	
	vo_glo15_miller_one_more_04();
	sleep_s(2);
	
	ordnance_show_nav_markers(TRUE);
	ordnance_drop(f_e10_m1_pod_4, "storm_rocket_launcher");
	sleep_s(1);
	ordnance_drop(f_e10_m1_pod_5, "storm_rocket_launcher");
	
	sleep_until(ai_living_count(gr_sq_e10m1_aa_turret_3) <= 0, 1);
	thread(f_e10_m1_event4_stop());
	b_e10m1_all_guns_down = TRUE;
	sleep_s(2);
	vo_e10m1_back_to_digger();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);	
	thread(f_e10_m1_event5_start());
	f_new_objective(e10_m1_obj_2);
	ordnance_show_nav_markers(FALSE);
	f_create_new_spawn_folder(84);
	
	prepare_to_switch_to_zone_set(e10_m1_dz_digger);
	
	object_create_anew(e10_m1_lz_02);
	navpoint_track_object_named(e10_m1_lz_02, "navpoint_goto");
	
	thread(f_e10m1_pod_4());
	thread(f_e10m1_pod_5());
	
	sleep_until(volume_test_players(t_e10m1_final_zone_switch), 1);
	
	//-------------------------------
	switch_zone_set(e10_m1_dz_digger);
	//-------------------------------
	
	sleep_s(2);
	object_create_folder_anew(e10m1_digger_crates);
	object_create_folder_anew(e10m1_dcs);
	object_create_folder_anew(e10_m1_machines);
	
	object_cannot_take_damage(e10m1_in_shield_1);
	object_cannot_take_damage(e10m1_in_shield_2);
	
	sleep_until(volume_test_players(t_e10m1_back_at_digger), 1);
	f_unblip_object_cui(e10_m1_lz_02);
	sleep_s(1);
	
	if ai_living_count(gr_ff_e10_m1_all) > 0 then  // checking to see if there any more dudes in the area.
		print("_________________________ MILLER: Clear that LZ");
		ai_set_objective(gr_ff_e10_m1_all_bipeds, e10m1_survival_middle);
		f_new_objective(e10_m1_obj_3);
		sleep_until(ai_living_count(gr_ff_e10_m1_all) <= 6, 1);
		f_blip_ai_cui(gr_ff_e10_m1_all, "navpoint_enemy");
		sleep_until(ai_living_count(gr_ff_e10_m1_all) <= 0, 1);
		sleep_s(1);
	end	
	
	thread(f_e10_m1_event5_stop());
	
	vo_e10m1_call_in_pelican();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	thread(f_e10_m1_event6_start());
	
	sleep_s(5);
	sleep_until(b_e10m1_shield_blow == TRUE, 1);
	thread(f_e10_m1_stinger_door());
	object_destroy(e10m1_shield);
	b_end_player_goal = TRUE;
	object_move_by_offset(e10m1_shield, 0, 0, 0, -20);
	//sleep_s(1);
	thread(f_e10_m1_music_stop());
	vo_e10m1_pelican_blasts();
//	sleep_s(1);
//	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	
	thread(f_e10_m1_event7_start());
	//moving to narrative
//	b_end_player_goal = TRUE;
//	f_new_objective(e10_m1_obj_2);
//	ai_place(sq_e10m1_guard_inside_5);
//	ai_place(sq_e10m1_guard_inside_6);
end

script static void f_e10_m1_stop_firing_again()
	sleep_until(volume_test_players(t_e10m1_pod_4), 1);
	b_e10m1_gun_3_stop_firing = TRUE;
end

script static void f_e10m1_pod_4()
	sleep_until(volume_test_players(t_e10m1_pod_4), 1);
	if b_e10m1_all_guns_down == TRUE and ai_living_count(gr_ff_e10_m1_all) <= 12 then
		vo_glo_droppod_03();
		sleep_s(1);
		ai_place_in_limbo(e10m1_pod_4);
		f_dlc_load_drop_pod(e10m1_drop_rail_4, none, e10m1_pod_4, e10m1_drop_pod_4);
	end
end

script static void f_e10m1_pod_5()
	sleep_until(volume_test_players(t_e10m1_pod_5), 1);
	ai_set_objective(gr_sq_e10m1_pod_4, e10m1_survival_middle);
	if b_e10m1_all_guns_down == TRUE and ai_living_count(gr_ff_e10_m1_all) <= 4 then
		ai_place_in_limbo(e10m1_pod_5);
		f_dlc_load_drop_pod(e10m1_drop_rail_5, none, e10m1_pod_5, e10m1_drop_pod_5);
		sleep_until(b_drop_pod_complete == TRUE, 1);
		ai_set_objective(gr_ff_e10_m1_all_bipeds, e10m1_survival_middle);
	end
	sleep_s(3);
	ai_set_objective(gr_ff_e10_m1_all_bipeds, e10m1_survival_middle);
	sleep_s(2);
	ai_place_in_limbo(e10m1_pod_6);
	f_dlc_load_drop_pod(e10m1_drop_rail_2, none, e10m1_pod_6, e10m1_drop_pod_2);
end

script static void f_e10_m1_2nd_gun_defense()
	vo_glo_droppod_01();
	sleep_until(ai_living_count(gr_ff_e10_m1_all) <= 7, 1);
	sleep_s(1);
	if b_e10_m1_gun1_2_down == FALSE then
		ai_place_in_limbo(e10m1_pod_3);
		f_dlc_load_drop_pod(e10m1_drop_rail_3, none, e10m1_pod_3, e10m1_drop_pod_3);
	end
end

script static void f_e10_m1_inside_digger()
	sleep_until(LevelEventStatus ("e10_m1_inside_digger"), 1);
	//f_create_new_spawn_folder(85);
	
	//sleep_s(1);
	
	object_create_anew(e10_m1_lz_07);
	navpoint_track_object_named(e10_m1_lz_07, "navpoint_goto");
	object_create_anew(e10_m1_lz_15);
	navpoint_track_object_named(e10_m1_lz_15, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10m1_dx_digger_2), 1);
	prepare_to_switch_to_zone_set(e10_m1_dz_digger_2);
	object_destroy(e10m1_shield);
	
	sleep_until(volume_test_players(t_e10m1_at_hostages), 1);
	
	//-------------------------------
	switch_zone_set(e10_m1_dz_digger_2);
	object_destroy(e10m1_shield);
	//-------------------------------
	
	sleep_s(0.25);
	ai_place(e10m1_scientists);
	
	f_unblip_object_cui(e10_m1_lz_07);
	f_unblip_object_cui(e10_m1_lz_15);
	sleep_s(2);
	vo_e10m1_crimson_digger();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	sleep_s(1);
	f_new_objective(e10_m1_obj_3);
	sleep_until(ai_living_count(gr_sq_e10m1_inside) <= 5, 1);
	sleep_s(1);
	f_blip_ai_cui(gr_ff_e10_m1_all_bipeds, "navpoint_enemy");
	thread(vo_glo_lasttargets_04());
	sleep_until(ai_living_count(gr_sq_e10m1_inside) <= 0, 1);
	f_create_new_spawn_folder(86);
	sleep_s(2);
	thread(f_e10_m1_event7_stop());
	vo_e10m1_scientists_free();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	f_new_objective(e10_m1_obj_5);
	thread(f_e10_m1_event8_start());
	
	navpoint_track_object_named(e10m1_jail_control_1, "navpoint_deactivate");
	navpoint_track_object_named(e10m1_jail_control_2, "navpoint_deactivate");
	thread(f_e10_m1_at_jail_controls());
	thread(f_e10m1_jail_door_1());
	thread(f_e10m1_jail_door_2());
	device_set_power(e10m1_jail_control_1, 1);
	device_set_power(e10m1_jail_control_2, 1);
	thread(f_e10m1_one_shield_down());
end

script static void f_e10m1_jail_door_1()
	sleep_until((device_get_position(e10m1_jail_control_1) > 0), 1);
	local long jail_button_1_show = pup_play_show(pup_e10_m1_shields_1);    
	device_set_power(e10m1_jail_control_1, 0);
	navpoint_track_object(e10m1_jail_control_1, FALSE);
 	sleep_until(not pup_is_playing(jail_button_1_show), 1);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', e10m1_prison_switch_1, 1 ); //AUDIO!
	device_set_position(e10m1_prison_switch_1, 1);
	b_e10m1_jail_switch_1_flipped = TRUE;
	sleep_until(device_get_position(e10m1_prison_switch_1) == 1, 1);
	object_hide(e10m1_prison_switch_1, TRUE);
end

script static void f_e10m1_jail_door_2()
	sleep_until((device_get_position(e10m1_jail_control_2) > 0), 1);
	local long jail_button_2_show = pup_play_show(pup_e10_m1_shields_2);    
	device_set_power(e10m1_jail_control_2, 0);
	navpoint_track_object(e10m1_jail_control_2, FALSE);
 	sleep_until(not pup_is_playing(jail_button_2_show), 1);
 	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', e10m1_prison_switch_2, 1 ); //AUDIO!
	device_set_position(e10m1_prison_switch_2, 1);
	b_e10m1_jail_switch_2_flipped = TRUE;
	sleep_until(device_get_position(e10m1_prison_switch_2) == 1, 1);
	object_hide(e10m1_prison_switch_2, TRUE);
end

script static void f_e10m1_one_shield_down()
	sleep_until(b_e10m1_jail_switch_1_flipped == TRUE or b_e10m1_jail_switch_2_flipped == TRUE, 1);
	sleep_s(1);
	vo_e10m1_one_down();
end

script static void f_e10_m1_at_jail_controls
	sleep_until(b_e10m1_jail_switch_1_flipped == TRUE and b_e10m1_jail_switch_2_flipped == TRUE, 1);
	sleep_s(1);
	object_destroy(e10m1_in_shield_1);
	object_destroy(e10m1_in_shield_2);
	ai_set_task(gr_ff_e10_m1_all, e10_m1_for_science, follow);
	sleep_s(3);
	vo_e10m1_free();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	b_end_player_goal = TRUE;
	f_new_objective(e10_m1_obj_1);
	thread(f_e10_m1_at_power_source());
	ai_set_task(gr_ff_e10_m1_all, e10_m1_for_science, power_supply);
end

script static void f_e10_m1_at_power_source
	sleep_until(LevelEventStatus ("e10_m1_at_power_source"), 1);
	print("__________________________MILLER: Ok power this thing up.");
	sleep_s(3);
	device_set_power(e10m1_jail_control_3, 1);
	navpoint_track_object_named(e10m1_jail_control_3, "navpoint_activate");
	sleep_until(device_get_position(e10m1_jail_control_3) > 0, 1);
	
	local long power_button_show = pup_play_show(pup_e10_m1_power_on);    
	device_set_power(e10m1_jail_control_3, 0);
	navpoint_track_object(e10m1_jail_control_3, FALSE);
 	sleep_until(not pup_is_playing(power_button_show), 1);
 	
	//print("__________________________ CRAZY SOUND EFFECT HERE!");
//	sleep_s(1);
//	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_2);
//	sleep_s(0.25);
//	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_1);
//	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_3);
//	sleep_s(0.3);
//	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_2);
		
	sleep_s(2);
	vo_e10m1_look_at_power();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	sleep_s(1);
	vo_e10m1_clearing_lz();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	ai_set_objective(gr_ff_e10_m1_all, e10_m1_for_science);
	thread(f_e10_m1_at_end());
	b_end_player_goal = TRUE;
	f_new_objective(e10_m1_obj_6);
	//ai_place(e10m1_pelican_end);
	thread(f_e10_m1_pelican_at_lz());
end

script static void f_e10_m1_power_spark1()
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_1);
end

script static void f_e10_m1_power_spark2()
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_2);
end

script static void f_e10_m1_power_spark3()
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_spark_3);
end

script static void f_e10_m1_at_end
	sleep_until(LevelEventStatus ("e10_m1_at_end"), 1);
	sleep_s(3);
	thread(f_e10_m1_event8_stop());
	f_blip_object(e10m1_pelican_end, "navpoint_goto");
	thread(f_e10_m1_music_stop());
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	vo_e10m1_load_up();
	sleep_s(1);
	sleep_until((e10m1_narrative_is_on == FALSE), 1);
	f_end_mission();
	b_end_player_goal = TRUE;
end


////=============================================================================================================================
////  TURRET STUFF
////=============================================================================================================================

script command_script cs_e10_m1_turret_1
	object_set_scale(ai_vehicle_get(ai_current_actor ), .20, 0);
	ai_exit_limbo(ai_current_actor);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t1_fx_1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t1_fx_2);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t1_fx_3);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
	repeat
  	begin_random
  	
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p0);
			sleep_rand_s(1,4);
			cs_shoot_point(true, e10_m1_fake_ships_1.p0);
			sleep_rand_s(1,5);
			cs_shoot_point(false, e10_m1_fake_ships_1.p0);
			sleep_rand_s(5,8);
		end
                               
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p1);
			sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p1);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p1);
      sleep_rand_s(1,3);
      cs_shoot_point(false, e10_m1_fake_ships_1.p1);
      sleep_rand_s(5,8);
    end
                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
			sleep_rand_s(1,4);
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
      sleep_rand_s(1,5);
      cs_shoot_point(false, e10_m1_fake_ships_1.p2);
      sleep_rand_s(5,8);
		end
                                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(false, e10_m1_fake_ships_1.p3);
  		sleep_rand_s(5,8);
		end
                                                
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p4);
			sleep_rand_s(1,4);
			cs_shoot_point(true, e10_m1_fake_ships_1.p4);
			sleep_rand_s(1,5);
			cs_shoot_point(false, e10_m1_fake_ships_1.p4);
			sleep_rand_s(5,8);
		end
                                                
    begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p5);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p5);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p5);
      sleep_rand_s(1,3);
      cs_shoot_point(false, e10_m1_fake_ships_1.p5);
			sleep_rand_s(5,8);
		end
		                                   
	end
	until( b_e10_m1_stop_firing_1 == TRUE);
end

script command_script cs_e10_m1_turret_2
	object_set_scale(ai_vehicle_get(ai_current_actor ), .20, 0);
	ai_exit_limbo(ai_current_actor);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t2_fx_1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t2_fx_2);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t2_fx_3);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
	repeat
  	begin_random
  	
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p6);
			sleep_rand_s(1,4);
			cs_shoot_point(true, e10_m1_fake_ships_1.p6);
			sleep_rand_s(1,5);
			cs_shoot_point(false, e10_m1_fake_ships_1.p6);
			sleep_rand_s(5,8);
		end
                               
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p7);
			sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p7);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p7);
      sleep_rand_s(1,3);
      cs_shoot_point(false, e10_m1_fake_ships_1.p7);
      sleep_rand_s(5,8);
    end
                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p8);
			sleep_rand_s(1,4);
      cs_shoot_point(true, e10_m1_fake_ships_1.p8);
      sleep_rand_s(1,5);
      cs_shoot_point(false, e10_m1_fake_ships_1.p8);
      sleep_rand_s(5,8);
		end
                                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p9);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p9);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p9);
     	sleep_rand_s(1,3);
     	cs_shoot_point(false, e10_m1_fake_ships_1.p9);
  		sleep_rand_s(5,8);
		end
                                                
		begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p10);
			sleep_rand_s(1,4);
			cs_shoot_point(true, e10_m1_fake_ships_1.p10);
			sleep_rand_s(1,5);
			cs_shoot_point(false, e10_m1_fake_ships_1.p10);
			sleep_rand_s(5,8);
		end
                                                
    begin
			cs_shoot_point(true, e10_m1_fake_ships_1.p11);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p11);
      sleep_rand_s(1,3);
      cs_shoot_point(true, e10_m1_fake_ships_1.p11);
      sleep_rand_s(1,3);
      cs_shoot_point(false, e10_m1_fake_ships_1.p11);
			sleep_rand_s(5,8);
		end
		                                   
	end
	until( b_e10_m1_stop_firing_2 == TRUE);
end

script command_script cs_e10_m1_turret_3
	object_set_scale(ai_vehicle_get(ai_current_actor ), .20, 0);
	ai_exit_limbo(ai_current_actor);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t3_fx_1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t3_fx_2);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m1_fake_ships_1.t3_fx_3);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
	repeat
  	begin_random
  	if b_e10m1_gun_3_stop_firing == FALSE then
			begin
				cs_shoot_point(true, e10_m1_fake_ships_1.p12);
				sleep_rand_s(1,4);
				cs_shoot_point(true, e10_m1_fake_ships_1.p12);
				sleep_rand_s(1,5);
				cs_shoot_point(false, e10_m1_fake_ships_1.p12);
				sleep_rand_s(2,5);
			end
                               
			begin
				cs_shoot_point(true, e10_m1_fake_ships_1.p13);
				sleep_rand_s(1,3);
     	 	cs_shoot_point(true, e10_m1_fake_ships_1.p13);
     	 	sleep_rand_s(1,3);
      	cs_shoot_point(true, e10_m1_fake_ships_1.p13);
      	sleep_rand_s(1,3);
      	cs_shoot_point(false, e10_m1_fake_ships_1.p13);
      	sleep_rand_s(2,5);
   		end
                                
			begin
      	cs_shoot_point(true, e10_m1_fake_ships_1.p14);
				sleep_rand_s(1,4);
      	cs_shoot_point(true, e10_m1_fake_ships_1.p14);
      	sleep_rand_s(1,5);
      	cs_shoot_point(false, e10_m1_fake_ships_1.p14);
      	sleep_rand_s(2,5);
			end
                                                
			begin
      	cs_shoot_point(true, e10_m1_fake_ships_1.p15);
     		sleep_rand_s(1,3);
     		cs_shoot_point(true, e10_m1_fake_ships_1.p15);
     		sleep_rand_s(1,3);
     		cs_shoot_point(true, e10_m1_fake_ships_1.p15);
     		sleep_rand_s(1,3);
     		cs_shoot_point(false, e10_m1_fake_ships_1.p15);
  			sleep_rand_s(2,5);
			end
                                                
			begin
				cs_shoot_point(true, e10_m1_fake_ships_1.p16);
				sleep_rand_s(1,4);
				cs_shoot_point(true, e10_m1_fake_ships_1.p16);
				sleep_rand_s(1,5);
				cs_shoot_point(false, e10_m1_fake_ships_1.p16);
				sleep_rand_s(2,5);
			end
                                                
    	begin
				cs_shoot_point(true, e10_m1_fake_ships_1.p17);
      	sleep_rand_s(1,3);
      	cs_shoot_point(true, e10_m1_fake_ships_1.p17);
      	sleep_rand_s(1,3);
      	cs_shoot_point(true, e10_m1_fake_ships_1.p17);
      	sleep_rand_s(1,3);
      	cs_shoot_point(false, e10_m1_fake_ships_1.p17);
				sleep_rand_s(2,5);
			end
		end                             
	end
	until( b_e10_m1_stop_firing_3 == TRUE);
end

script static void f_e10m1_turret_1_dead()
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret)) <= 0.95, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t1_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t1_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret), .60);
	
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret)) <= 0.55, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t1_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t1_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret), .25);
		
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret)) <= 0.20, 1);
	object_cannot_take_damage(ai_vehicle_get(e10m1_turret_1.turret));
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t1_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t1_2);
	b_e10_m1_stop_firing_1 = TRUE;
	cs_run_command_script(gr_sq_e10m1_aa_turret_1, cs_e10_m1_kill_turret_1);
end

script command_script cs_e10_m1_kill_turret_1()
	f_unblip_object_cui(ai_vehicle_get(ai_current_actor));
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_out", "primary_trigger");
	sleep_s(2);
	object_destroy(ai_vehicle_get(ai_current_actor));
end

script static void f_e10m1_turret_2_dead()
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret)) <= 0.95, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t2_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t2_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret), .60);
	
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret)) <= 0.55, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t2_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t2_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret), .25);
	
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret)) <= 0.20, 1);
	object_cannot_take_damage(ai_vehicle_get(e10m1_turret_2.turret));
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t2_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t2_2);
	b_e10_m1_stop_firing_2 = TRUE;
	cs_run_command_script(gr_sq_e10m1_aa_turret_2, cs_e10_m1_kill_turret_1);
end

script static void f_e10m1_turret_3_dead()
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret)) <= 0.95, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t3_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t3_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret), .60);
	
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret)) <= 0.55, 1);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t3_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t3_2);
	object_set_health(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret), .25);
	
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_3.turret)) <= 0.20, 1);
	object_cannot_take_damage(ai_vehicle_get(e10m1_turret_3.turret));
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, f_t3_1);
	effect_new (environments\shared\crates\fore\fore_fusion_coil_destructable\effect\fore_fusion_coil_explosion.effect , f_t3_2);
	b_e10_m1_stop_firing_3 = TRUE;
	cs_run_command_script(gr_sq_e10m1_aa_turret_3, cs_e10_m1_kill_turret_1);
end

////=============================================================================================================================
////   COMMAND SCRIPTS
////=============================================================================================================================

script command_script cs_e10m1_pelican_in()
// Pelican at the  beginning of the level, drops Crimson off.
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(.5);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(6);
	cs_fly_to_and_face (e10_m1_pelican_intro.p0, e10_m1_pelican_intro.p4, 2);
	sleep_s(1);
	cs_fly_to_and_face (e10_m1_pelican_intro.p3, e10_m1_pelican_intro.p4);
	sleep_s(1);
	cs_fly_to_and_face (e10_m1_pelican_intro.p1, e10_m1_pelican_intro.p4, 1);
	sleep_s(4);
	cs_fly_to_and_face (e10_m1_pelican_intro.p2, e10_m1_pelican_intro.p4, 1);
	sleep_s(4);
	cs_fly_to_and_face (e10_m1_pelican_intro.p1, e10_m1_pelican_intro.p4, 1);
	sleep_s(3);
	cs_vehicle_speed(1);
	cs_fly_to_and_face (e10_m1_pelican_intro.p5, e10_m1_pelican_intro.p6);
	cs_fly_to_and_face (e10_m1_pelican_intro.p6, e10_m1_pelican_intro.p8);
	cs_fly_to_and_face (e10_m1_pelican_intro.p7, e10_m1_pelican_intro.p7);
	ai_erase(e10m1_pelican_intro);
//	kill_script(f_e10_m1_player_on_pelican_dead);
end

script command_script cs_e10m1_pelican_in_kill()
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_vehicle_speed(1);
	cs_fly_to_and_face (e10_m1_pelican_intro.p6, e10_m1_pelican_intro.p8);
	cs_fly_to_and_face (e10_m1_pelican_intro.p7, e10_m1_pelican_intro.p7);
	ai_erase(e10m1_pelican_intro);
end

//script continuous f_e10_m1_player_on_pelican_dead()
//	repeat
//		if volume_return_objects(t_pelican_1_kill_player) == player0 then
//			unit_kill(player0);
//		end
//		if volume_return_objects(t_pelican_1_kill_player) == player1 then
//			unit_kill(player1);
//		end
//		if volume_return_objects(t_pelican_1_kill_player) == player2 then
//			unit_kill(player2);
//		end
//		if volume_return_objects(t_pelican_1_kill_player) == player3 then
//			unit_kill(player3);
//		end
//	until ()
//end

script static void f_e10m1_pelican_door()
	ai_place(e10m1_s_p_driver);
	ai_vehicle_enter_immediate(e10m1_s_p_driver, e10_m1_pup_pelican, "pelican_d");
	cs_run_command_script(e10m1_s_p_driver, cs_e10m1_pelican_door);
end

script command_script cs_e10m1_pelican_door()
// Pelican at the digger - for animated puppet show
	f_blip_object(e10_m1_pup_pelican, "navpoint_goto");
	sleep_s(3);
	object_set_function_variable(e10m1_shield, shield_color, 1, 5);
	cs_shoot_point(TRUE, e10_m1_fake_ships_1.p_e10m1_shield1);
	sleep_s(0.75);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_1);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_1);
	sleep_s(1);
	cs_shoot_point(TRUE, e10_m1_fake_ships_1.p_e10m1_shield2);
	sleep_s(0.75);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_2);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_2);
	sleep_s(1);
	cs_shoot_point(TRUE, e10_m1_fake_ships_1.p_e10m1_shield3);
	sleep_s(0.75);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_3);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_3);
	sleep_s(1);
	cs_shoot_point(FALSE, e10_m1_fake_ships_1.p_e10m1_shield1);
	cs_shoot_point(FALSE, e10_m1_fake_ships_1.p_e10m1_shield2);
	cs_shoot_point(FALSE, e10_m1_fake_ships_1.p_e10m1_shield3);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_1);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_1);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_2);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_1);
	effect_new(levels\dlc\shared\effects\covenant_shield_impact_energy.effect , f_e10m1_shield_xplo_3);
	effect_new(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, f_e10m1_shield_xplo_3);
	b_e10m1_shield_blow = TRUE;
	f_unblip_object_cui(ai_vehicle_get(ai_current_actor));
end


script command_script cs_e10m1_pelican_end()
// Pelican that picks them up at the end
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	//cs_fly_to_and_face (e10_m1_pelican_door.p0, e10_m1_pelican_door.p1);
	cs_fly_to_and_face (e10_m1_pelican_door.p1, e10_m1_pelican_door.p2);
	cs_fly_to_and_face (e10_m1_pelican_door.p2, e10_m1_pelican_door.p3);
	cs_vehicle_speed(0.75);
	cs_fly_to_and_face (e10_m1_pelican_door.p8, e10_m1_pelican_door.p5);
	b_e10m1_pelican_at_l = TRUE;
	sleep_s(50);
end

script static void f_e10_m1_pelican_at_lz()
	sleep_until(b_e10m1_pelican_at_l == TRUE, 1);
	if e10m1_narrative_is_on == FALSE then
		vo_e10m1_pickup();
	end
end

script command_script cs_e10_m1_phantom_1()
// phantom that drops dudes on the left side as you go up to AA guns
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	f_load_phantom(e10m1_phantom_1, dual, e10m1_ph_sq_1, e10m1_ph_sq_2, e10m1_ph_sq_3, e10m1_ph_sq_4);
	cs_fly_to_and_face (e10_m1_phantom_1.p0, e10_m1_phantom_1.p1);
	cs_fly_to_and_face (e10_m1_phantom_1.p1, e10_m1_phantom_1.p2);
	cs_fly_to_and_face (e10_m1_phantom_1.p2, e10_m1_phantom_1.p3, 1);
	sleep_s(1);
	f_unload_phantom(e10m1_phantom_1, dual);
	//spops_phantom_unload( vh_phantom, "ALL", -1.0, TRUE );
	sleep_s(3);
	cs_fly_to_and_face (e10_m1_phantom_1.p4, e10_m1_phantom_1.p3);
	cs_fly_to_and_face (e10_m1_phantom_1.p4, e10_m1_phantom_1.p5, 1);
	cs_fly_to_and_face (e10_m1_phantom_1.p5, e10_m1_phantom_1.p11);
	cs_fly_to_and_face (e10_m1_phantom_1.p6, e10_m1_phantom_1.p11);
	cs_fly_to_and_face (e10_m1_phantom_1.p7, e10_m1_phantom_1.p8);
	cs_fly_to_and_face (e10_m1_phantom_1.p8, e10_m1_phantom_1.p9);
	cs_fly_to_and_face (e10_m1_phantom_1.p9, e10_m1_phantom_1.p10);
	cs_fly_to_and_face (e10_m1_phantom_1.p10, e10_m1_phantom_1.p10);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120); //Shrink size over time
	ai_erase(e10m1_phantom_1);
end

script command_script cs_e10_m1_phantom_2()
//phantom that delivers the hunters by the 3rd AA gun
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	f_load_phantom(e10m1_phantom_2, right, e10m1_ph2_sq_1, e10m1_ph2_sq_2, none, none);
	cs_fly_to_and_face (e10_m1_phantom_2.p1, e10_m1_phantom_2.p0, 1);
	sleep_s(2);
	cs_fly_to_and_face (e10_m1_phantom_2.p2, e10_m1_phantom_2.p0, 1);
	sleep_s(1);
	cs_fly_to_and_face (e10_m1_phantom_2.p3, e10_m1_phantom_2.p9, 1);
	sleep_s(1);
	f_unload_phantom(e10m1_phantom_2, right);
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	b_e10m1_ready_for_shield_aa_3 = FALSE;
	sleep_s(3);
	cs_fly_to_and_face (e10_m1_phantom_2.p8, e10_m1_phantom_2.p9);
	cs_fly_to_and_face (e10_m1_phantom_2.p4, e10_m1_phantom_2.p5);
	cs_fly_to_and_face (e10_m1_phantom_2.p5, e10_m1_phantom_2.p6, 1);
	b_e10m1_gun_3_stop_firing = FALSE;
	cs_fly_to_and_face (e10_m1_phantom_2.p6, e10_m1_phantom_2.p7);
	cs_fly_to_and_face (e10_m1_phantom_2.p7, e10_m1_phantom_2.p7);
	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120); //Shrink size over time
	sleep_s(2);
	ai_erase(e10m1_phantom_2);
end

script static void f_end_mission()
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

script static void f_activator_get_e10_m1( object trigger, unit activator )
	g_ics_player_e10_m1 = activator;
end

script command_script cs_e10_m1_science_idles()
			cs_custom_animation (objects\characters\civilian_male\civilian_male.model_animation_graph, "panic:duck_and_cover_idle:var1", TRUE);
//			sleep_s(5);
//			cs_custom_animation (cinematics\cin_m083_encryption_a\objects\cin_m083_encryption_a_000\male_scientist01.model_animation_graph, "male_scientist01_13", TRUE);
//			sleep_s(5);
//			cs_custom_animation (cinematics\cin_m083_encryption_a\objects\cin_m083_encryption_a_000\male_scientist01.model_animation_graph, "male_scientist01_14", TRUE);
//			sleep_s(5);
//			cs_custom_animation (cinematics\cin_m083_encryption_a\objects\cin_m083_encryption_a_000\male_scientist01.model_animation_graph, "male_scientist01_15", TRUE);
//			sleep_s(5);
//			cs_custom_animation (cinematics\cin_m083_encryption_a\objects\cin_m083_encryption_a_000\male_scientist01.model_animation_graph, "male_scientist01_2", TRUE);
end