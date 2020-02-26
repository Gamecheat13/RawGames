// =============================================================================================================================
// ============================================ E8M5 MEZZANINE MISSION SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================
	global boolean b_loc_1_done = FALSE;
	global boolean b_loc_2_done = FALSE;
	global boolean b_loc_3_done = FALSE;
	global boolean b_loc_4_done = FALSE;
	global boolean b_loc_5_done = FALSE;
	global boolean b_loc_6_done = FALSE;
	global boolean b_loc_7_done = FALSE;
	global boolean b_loc_8_done = FALSE;
	
	global boolean b_any_loc_active = FALSE;
	global boolean b_pelican_landed = FALSE;
	global boolean b_phantom_three_dropped = FALSE;
	global boolean b_last_wraith_killed = FALSE;
	global boolean b_spire_explained = FALSE;
	global boolean b_stop_shooting = FALSE;
	global boolean b_front_guys_down = FALSE;
	
	global boolean b_loc_1_active = FALSE;
	global boolean b_loc_2_active = FALSE;
	global boolean b_loc_3_active = FALSE;
	global boolean b_loc_4_active = FALSE;
	global boolean b_loc_5_active= FALSE;
	global boolean b_loc_6_active = FALSE;
	global boolean b_loc_7_active = FALSE;
	global boolean b_loc_8_active = FALSE;
	global boolean b_player_arrival_4 = FALSE;
	global boolean b_first_turret_in = FALSE;
	global boolean b_cover_narr = FALSE;
	global boolean b_event_4_dropped_off = FALSE;
	global boolean b_85_middle_completed = FALSE;
	global boolean b_85_wings_completed = FALSE;
	global boolean b_85_blip_final = FALSE;
	
	global short s_special_1 = 0;
	global short s_special_2 = 0;
	global short s_special_3 = 0;
	global short s_special_4 = 0;
	global short s_special_5 = 0;
	global short s_special_6 = 0;
	global short s_special_7 = 0;
	global short s_special_8 = 0;
	
	global short s_track_location = 0;
	
	global object g_fx_player0 = NONE;
	global object g_fx_player1 = NONE;
	global object g_fx_player2 = NONE;
	global object g_fx_player3 = NONE;
	
// ============================================	STARTUP SCRIPT	========================================================

script startup e8m5_caverns_startup

	print( "e8m5 caverns startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m5") ) then
		wake( e8m5_mezzanine_init );
	end

end

script dormant e8m5_mezzanine_init()
		//sleep_until (LevelEventStatus ("e8_m5"), 1);

		f_spops_mission_setup( "e8_m5", e8m5_main, e8m5_ff_all, e8_m5_spawn_init, 90 );
		//ai_ff_all = e8m5_ff_all;
		print ("e8m5 variant started");
		//switch_zone_set (e8m5_main);
		//ai_allegiance (human, player);
		//ai_allegiance (player, human);
		ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery", "objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect" );
		ai_allegiance (player, forerunner);
		ai_allegiance (player, mule);
		ai_allegiance (mule, forerunner);
		ai_allegiance (mule, covenant);
		
//	//	//	//	FOLDER SPAWNING	\\	\\	\\
		wake(f_e8m5_destroy);
//  "Devices" folders
		f_add_crate_folder (e8m5_device_machines);
		f_add_crate_folder (e8m5_device_controls);		
		
//	add "Vehicles" folders
//		f_add_crate_folder ( );

//	add "Crates" folders
		f_add_crate_folder (e8m5_cov_crates);
		object_destroy_folder(cr_e6m2_weaponcrates);

//  Spawn point folders 
		f_add_crate_folder (e8_m5_spawn_init);

		firefight_mode_set_crate_folder_at( e8_m5_spawn_init, 90);					//	Initial Spawn Area for E8M5	
	
//	//	add "Items" folders

//	//	add "Enemy Squad" Templates

//  "Objective Items"
		firefight_mode_set_objective_name_at( e8m5_insert_map_dc, 50);	//	Test Starting Obj
		
//  "Squad Declaration"
		firefight_mode_set_squad_at( e8m5_ff_init_all, 1);	//	Starting Squad
		firefight_mode_set_squad_at( e8m5_ff_wave_1, 2);	//	First Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_2, 3);	//	Second Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_3, 4);	//	Third Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_4_spec, 5);	//	Fourth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_5, 6); // Fifth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_6, 7); // Sixth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_7, 8); // Seventh Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_8_spec, 9); // Eigth Wave
		firefight_mode_set_squad_at( e8m5_ff_wraiths_1, 10); // Wraith Wave 1
		firefight_mode_set_squad_at( e8m5_ff_wraiths_2, 11); // Wraith Wave 2
		firefight_mode_set_squad_at( e8m5_ff_hunters, 12); // Hunters
		firefight_mode_set_squad_at( e8m5_ff_wave_3_re, 13); // 3rd Wave Xtras
		firefight_mode_set_squad_at( e8m5_ff_wave_4_spec_2, 14); // 4th Wave Xtras
		firefight_mode_set_squad_at( e8m5_ff_wave_4_spec_3, 15); // 4th Wave Xtras
		firefight_mode_set_squad_at( e8m5_ff_wave_top, 16); // Final Wave Xtras
		
// "Phantom Declaration"
		firefight_mode_set_squad_at( e8m5_phantom_wave_1, 13);
		firefight_mode_set_squad_at( e8m5_phantom_wave_2, 14);
		firefight_mode_set_squad_at( e8m5_phantom_wave_3, 15);
		firefight_mode_set_squad_at( e8m5_phantom_4, 16);
		firefight_mode_set_squad_at( e8m5_phantom_hunters, 17);
		
//	"LZ" areas
	firefight_mode_set_objective_name_at( e8_m5_lz_0, 51);
	firefight_mode_set_objective_name_at( e8_m5_cover_loc, 52);
	firefight_mode_set_objective_name_at( e8_m5_turret_loc, 53);		
	firefight_mode_set_objective_name_at( e8_m5_1st_loc, 54);
		
// call the setup complete
 	 f_spops_mission_setup_complete( TRUE );
 	 
	 	sleep_until (f_spops_mission_ready_complete(), 1);
		
		thread(f_start_player_intro_e8_m5());

//	firefight_mode_set_player_spawn_suppressed(TRUE);
		//sleep_until (LevelEventStatus ("loadout_screen_complete"), 1); 
//	cinematic_start();
//	pup_play_show ( );
//	sleep (15);
//	sleep_until (f_narrativein_done == TRUE);
//	cinematic_stop();
//	firefight_mode_set_player_spawn_suppressed(FALSE);
		//sleep_until (b_players_are_alive(), 1);
		sleep_until( f_spops_mission_start_complete(), 1 );
		fade_in (0,0,0,30);
		thread(f_e8m5_music());
		sleep_s (0.5);
		//fade_in (0,0,0,15);
		//ordnance_drop(flg_e8m5_ord_1, "storm_rocket_launcher");
// Event Script Threading
		thread(f_start_event_e8m5_0());
		thread(f_start_event_e8m5_1());
		thread(f_end_event_e8m5_1());
		thread(f_start_event_e8m5_2());
		thread(f_end_event_e8m5_2());
		thread(f_start_event_e8m5_3());
		thread(f_end_event_e8m5_3());
		thread(f_start_event_e8m5_4());
		thread(f_end_event_e8m5_4());
		thread(f_start_event_e8m5_5());
		thread(f_end_event_e8m5_5());
		thread(f_start_event_e8m5_6());
		thread(f_end_event_e8m5_6());
		thread(f_start_event_e8m5_7());
		thread(f_end_event_e8m5_7());
		sleep(1);
		thread(f_start_event_e8m5_8());
		thread(f_end_event_e8m5_8());
		thread(f_start_event_e8m5_8_1());
		thread(f_start_event_e8m5_8_2());
		thread(f_end_event_e8m5_9_1());
		thread(f_e8_m5_end_mission());
		thread(f_fx_location_1());
		thread(f_fx_location_2());
		thread(f_fx_location_3());
		thread(f_start_event_e8m5_11());
		thread(f_player0_respawn_check());
		thread(f_player1_respawn_check());
		thread(f_player2_respawn_check());
		thread(f_player3_respawn_check());
		thread(f_kill_scan_effect());

end

script dormant f_e8m5_destroy()
		sleep_until(object_valid(mezzanine_backdoor));
		object_destroy(mezzanine_backdoor);
end

script static void f_start_player_intro_e8_m5
	
	sleep_until (f_spops_mission_ready_complete(), 1);
	
	//intro();
	if editor_mode() then
		print ("editor mode, no intro playing");
		thread(vo_e8m5_narrative_in());
		sleep_s(2);
		print("ai exiting limbo");
		ai_exit_limbo(e8m5_ff_init_all);
	else
		print ("NOT editor mode play the intro");
		pup_disable_splitscreen (TRUE);
		local long intro = pup_play_show(e8_m5_intro);
		thread(vo_e8m5_narrative_in());
		sleep_until(not pup_is_playing(intro), 1);
		pup_disable_splitscreen (FALSE);
		ai_exit_limbo(e8m5_ff_init_all);
	end
		
	//tell engine the intro is complete
	f_spops_mission_intro_complete( TRUE );

	
end

// ============================================	MISSION SCRIPT	========================================================

script static void f_start_event_e8m5_0()

		print("STARTING EVENT 0");
		sleep(1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		thread(vo_e8m5_first_location());
		sleep_until(b_blip_loc_1 == TRUE, 1);
		sleep_s(1);
		b_end_player_goal = TRUE;

end

script static void f_start_event_e8m5_1()

		sleep_until(LevelEventStatus("start_event_1"), 1);
		print("STARTING EVENT 1");
		print("starting timer");
		f_objective_complete_e8m5(e8m5_objective_1);
		f_setup_loc_fx(flg_e8m5_area_fx_1, TRUE, TRUE);
		b_any_loc_active = TRUE;
		b_loc_1_active = TRUE;
		sleep_until(volume_test_players(tv_e8m3_1), 1);
		b_entered_scan_1 = TRUE;
		sleep_until(b_scan_1 == TRUE);
		thread(f_location_timer_1());
		thread(f_player_scan_check(tv_e8m3_1));
		sleep_s(4);
		sleep_until(s_special_1 == 3);
		b_any_loc_active = FALSE;
		b_loc_1_active = FALSE;
		b_loc_1_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_1, TRUE, e8m5_area_sfx_1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		thread(vo_e8m5_suit_scans());
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		//sleep_s(1);
		b_end_player_goal = TRUE;	
		
end

script static void f_end_event_e8m5_1()

		sleep_until(LevelEventStatus("end_event_1"), 1);
		print("ENDING EVENT 1");	

end

script static void f_fx_location_1()

	sleep_until(LevelEventStatus("fx_loc_1"), 1);
	
end

script static void f_start_event_e8m5_2()

		sleep_until(LevelEventStatus("start_event_2"), 1);
		print("STARTING EVENT 2");
		f_setup_loc_fx(flg_e8m5_area_fx_2, FALSE, TRUE);
		thread(f_first_phantom_dialog());
		sleep_until(b_any_loc_active == FALSE);
		b_any_loc_active = TRUE;
		b_loc_2_active = TRUE;
		sleep(1);
		f_objective_complete_e8m5(e8m5_objective_2);
		sleep_until(volume_test_players(tv_e8m3_2), 1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		thread(vo_e8m5_second_location());
		sleep_until(b_scan_loc_2 == TRUE, 1);
		thread(f_player_scan_check(tv_e8m3_2));
		print("starting timer");
		thread(f_location_timer_2());
		sleep_until((s_special_2 >= 3) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_2, tv_e8m3_2);
		wake(f_defense_spires_up);
		b_any_loc_active = FALSE;
		b_loc_2_active = FALSE;
		b_loc_2_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_2, FALSE, e8m5_area_sfx_2);
		sleep_until(ai_living_count(e8m5_blippable) <= 4);
		//f_blip_remaining();
		sleep_until(b_spire_explained == TRUE, 1);
		b_end_player_goal = TRUE;	
		f_unblip_ai_cui(e8m5_blippable);
		
end

script static void f_first_phantom_dialog()

	sleep_until(LevelEventStatus("first_dropship_dialog"), 1);
	print("START DROPSHIP DIALOG EVENT");
	thread(f_e8m5_music_second_begin());
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_scout_ships());
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_pip_on());
	sleep_until(ai_living_count(e8m5_ff_wave_1) > 0, 1);
	sleep(1);
	sleep_until(ai_living_count(e8m5_ff_wave_1) <= 0);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_combat_complete());
	
end

script dormant f_defense_spires_up()

	sleep_s(1);
	local long show = pup_play_show(e8m5_defense_spires_up);
	sleep_until(not pup_is_playing(show), 1);
	sleep_s(1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_two_machines());
	sleep(1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	b_spire_explained = TRUE;
	
end

script static void f_end_event_e8m5_2()

		sleep_until(LevelEventStatus("end_event_2"), 1);
		print("ENDING EVENT 2");
		thread(f_e8m5_music_second_end());
		
end

script static void f_fx_location_2()

	sleep_until(LevelEventStatus("fx_loc_2"), 1);
	sleep_until(b_any_loc_active == FALSE);
	sleep(1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_location());
	sleep_until(b_blip_cover == TRUE, 1);
	f_setup_loc_fx(flg_e8m5_area_fx_3, TRUE, TRUE);
	b_any_loc_active = TRUE;
	b_loc_3_active = TRUE;
	f_objective_complete_e8m5(e8m5_objective_3);
	thread(f_player_scan_check(tv_e8m3_3));
	sleep_until(volume_test_players(tv_e8m3_3));
	b_end_player_goal = TRUE;
	
end

script static void f_start_event_e8m5_3()

		sleep_until(LevelEventStatus("start_event_3"), 1);
		print("STARTING EVENT 3");
		sleep_s(5);
		print("starting timer");
		thread(f_location_timer_3());
		sleep_until((s_special_3 >= 25) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_3, tv_e8m3_3);
		sleep(1);
		b_any_loc_active = FALSE;
		sleep(1);
		b_loc_3_active = FALSE;
		sleep(1);
		b_loc_3_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_3, TRUE, e8m5_area_sfx_3);
		sleep_until(b_front_guys_down == TRUE);
		sleep_until(ai_living_count(e8m5_blippable) <= 4);
		//f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_blippable);
		
end

script static void f_end_event_e8m5_3()

		sleep_until(LevelEventStatus("end_event_3"), 1);
		print("ENDING EVENT 3");	
		
end

script static void f_fx_location_3()

	sleep_until(LevelEventStatus("fx_loc_3"), 1);
	sleep_until(b_any_loc_active == FALSE);
	sleep(1);
	b_turret_narr = TRUE;
	sleep_until(b_blip_turrets == TRUE);
	f_setup_loc_fx(flg_e8m5_area_fx_4, TRUE, TRUE);
	b_any_loc_active = TRUE;
	b_loc_4_active = TRUE;
	f_objective_complete_e8m5(e8m5_objective_4);
	thread(f_player_scan_check(tv_e8m3_4));
	sleep_until(volume_test_players(tv_e8m3_4));
	b_player_arrival_4 = TRUE;
	b_end_player_goal = TRUE;
	
end

script static void f_start_event_e8m5_4()

		sleep_until(LevelEventStatus("start_event_4"), 1);
		print("STARTING EVENT 4");
		print("starting timer");
		wake(f_check_4_dropoff);
		thread(f_e8m5_music_major_begin());
		thread(f_location_timer_4());
		sleep_until((s_special_4 >= 25) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_4, tv_e8m3_4);
		b_any_loc_active = FALSE;
		b_loc_4_active = FALSE;
		b_loc_4_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_4, TRUE, e8m5_area_sfx_4);
		sleep_until(b_event_4_dropped_off == TRUE);
		sleep_until(ai_living_count(e8m5_blippable) <= 4);
		//f_blip_remaining();
		b_end_player_goal = TRUE;	
		f_unblip_ai_cui(e8m5_blippable);
		
end

script dormant f_check_4_dropoff
	//sets a boolean that keeps the event from progressing prematurely.
	sleep_s(30);
	b_event_4_dropped_off = TRUE;
end

script static void f_end_event_e8m5_4()

		sleep_until(LevelEventStatus("end_event_4"), 1);
		print("ENDING EVENT 4");	
		
end

script static void f_start_event_e8m5_5()

		sleep_until(LevelEventStatus("start_event_5"), 1);
		print("STARTING EVENT 5");
		sleep_s(3);
		sleep_until(b_any_loc_active == FALSE);
		sleep(1);
		f_setup_loc_fx(flg_e8m5_area_fx_5, TRUE, TRUE);
		b_any_loc_active = TRUE;
		b_loc_5_active = TRUE;
		print("starting timer");
		thread(f_location_timer_5());
		thread(f_player_scan_check(tv_e8m3_5));
		sleep_until((s_special_5 >= 30) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_5, tv_e8m3_5);
		b_any_loc_active = FALSE;
		b_loc_5_active = FALSE;
		b_loc_5_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_5, TRUE, e8m5_area_sfx_5);
		sleep_until(ai_living_count(e8m5_blippable) <= 4);
		//f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_blippable);
		
end

script static void f_end_event_e8m5_5()

		sleep_until(LevelEventStatus("end_event_5"), 1);
		print("ENDING EVENT 5");	
		
end

script static void f_start_event_e8m5_6()

		sleep_until(LevelEventStatus("start_event_6"), 1);
		print("STARTING EVENT 6");
		thread(f_85_mid_combat());
		sleep_s(1);
		sleep_until(b_any_loc_active == FALSE);
		sleep(1);;
		b_weapon_narr = TRUE;
		sleep_until(b_blip_weapons == TRUE);
		f_setup_loc_fx(flg_e8m5_area_fx_6, TRUE, TRUE);
		b_any_loc_active = TRUE;
		b_loc_6_active = TRUE;
		f_objective_complete_e8m5(e8m5_objective_5);
		print("starting timer");
		thread(f_location_timer_6());
		thread(f_player_scan_check(tv_e8m3_6));
		sleep_until(s_special_6 > 3);
		sleep_until((s_special_6 >= 25) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_6, tv_e8m3_6);
		b_any_loc_active = FALSE;
		b_loc_6_active = FALSE;
		b_loc_6_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_6, TRUE, e8m5_area_sfx_6);
		//f_blip_remaining();
		sleep_until(b_85_middle_completed == TRUE);
		b_end_player_goal = TRUE;
		
end

script static void f_85_mid_combat()
	sleep_s(4);
	ai_place_in_limbo(e8m5_ff_wave_3_re);
	f_dlc_load_drop_pod (dm_drop_05, e8m5_ff_wave_3_re, NONE, drop_pod_lg_01);
	sleep_until(s_special_6 > 1);
	sleep_until(ai_living_count(e8m5_blippable) < 10);
	sleep_s(1);
	ai_place_in_limbo(e8m5_ff_wave_4_spec_2);
	f_dlc_load_drop_pod (dm_drop_02, e8m5_ff_wave_4_spec_2, NONE, drop_pod_lg_01);
	sleep_until(ai_living_count(e8m5_blippable) < 4);
	sleep_s(1);
	ai_place_in_limbo(e8m5_ff_wave_4_spec);
	f_dlc_load_drop_pod (dm_drop_04, e8m5_ff_wave_4_spec, NONE, drop_pod_lg_01);
	sleep_until(ai_living_count(e8m5_blippable) <= 4);
	b_85_middle_completed = TRUE;
end
	

script static void f_end_event_e8m5_6()

		sleep_until(LevelEventStatus("end_event_6"), 1);
		print("ENDING EVENT 6");	
		
end

script static void f_start_event_e8m5_7()

		sleep_until(LevelEventStatus("start_event_7"), 1);
		print("STARTING EVENT 7");
		sleep_until(b_any_loc_active == FALSE);
		sleep(1);
		sleep_until(b_phantom_three_dropped == TRUE);
		thread(f_85_wings_combat());
		f_unblip_ai_cui(e8m5_blippable);
		b_aa1_narr = TRUE;
		sleep_until(b_blip_aa1 == TRUE);
		f_setup_loc_fx(flg_e8m5_area_fx_7, FALSE, TRUE);
		b_any_loc_active = TRUE;
		b_loc_7_active = TRUE;
		f_objective_complete_e8m5(e8m5_objective_6);
		print("starting timer");
		thread(f_location_timer_7());
		thread(f_player_scan_check(tv_e8m3_7));
		sleep_until((s_special_7 >= 3) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_7, tv_e8m3_7);
		effect_new("objects\characters\storm_pawn\fx\pawn_phase_in.effect", flg_aa_fx_1a);
		effect_new("objects\characters\storm_pawn\fx\pawn_phase_in.effect", flg_aa_fx_1b);
		ai_place_in_limbo(e8m5_air_turret_1);
		b_any_loc_active = FALSE;
		b_loc_7_active = FALSE;
		b_loc_7_done = TRUE;
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_7, FALSE, e8m5_area_sfx_7);
		//f_blip_remaining();
		b_end_player_goal = TRUE;
		
end

script static void f_end_event_e8m5_7()

		sleep_until(LevelEventStatus("end_event_7"), 1);
		print("ENDING EVENT 7");

end

script static void f_start_event_e8m5_8()

		sleep_until(LevelEventStatus("start_event_8"), 1);
		print("STARTING EVENT 8");
		sleep_until(b_any_loc_active == FALSE);
		sleep(1);
		f_unblip_ai_cui(e8m5_blippable);
		b_aa2_narr = TRUE;
		sleep_until(b_blip_aa2 == TRUE);
		f_setup_loc_fx(flg_e8m5_area_fx_8, FALSE, TRUE);
		b_any_loc_active = TRUE;
		b_loc_8_active = TRUE;
		f_objective_complete_e8m5(e8m5_objective_7);
		print("starting timer");
		thread(f_location_timer_8());
		thread(f_player_scan_check(tv_e8m3_8));
		sleep_until((s_special_8 >= 3) or (ai_living_count(e8m5_ff_all) <= 0));
		f_sleep_check_special(s_special_8, tv_e8m3_8);
		effect_new("objects\characters\storm_pawn\fx\pawn_phase_in.effect", flg_aa_fx_2a);
		effect_new("objects\characters\storm_pawn\fx\pawn_phase_in.effect", flg_aa_fx_2b);
		ai_place_in_limbo(e8m5_air_turret_2);
		b_any_loc_active = FALSE;
		b_loc_8_active = FALSE;
		b_loc_8_done = TRUE;
		thread(f_e8m5_music_major_end());
		sleep(10);
		f_remove_loc_fx(flg_e8m5_area_fx_8, FALSE, e8m5_area_sfx_8);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		thread(vo_e8m5_locations_activated());
		sleep(1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		sleep_until(b_85_wings_completed == TRUE);
		//f_blip_remaining();
		b_end_player_goal = TRUE;
		//f_unblip_ai_cui(e8m5_blippable);
		
end

script static void f_85_wings_combat()
	sleep_until(s_special_7 > 1);
	sleep_until(ai_living_count(e8m5_blippable) <= 8);
	sleep_s(1);
	ai_place_in_limbo(e8m5_ff_wave_top);
	f_dlc_load_drop_pod (dm_drop_05, e8m5_ff_wave_top, NONE, drop_pod_lg_01);
	sleep_until(ai_living_count(e8m5_blippable) <= 6);
	sleep_s(1);
	ai_place(e8m5_phantom_4);
	f_load_phantom(e8m5_phantom_4, "dual", e8m5_ff_wv_7_1, e8m5_ff_wv_7_2, e8m5_ff_wv_7_elites_3, none);
	sleep_s(20);
	sleep_until(ai_living_count(e8m5_blippable) <= 4);
	b_85_wings_completed = TRUE;
end

script static void f_start_event_e8m5_11()

		sleep_until(LevelEventStatus("start_event_11"), 1);
		print("STARTING EVENT 11");
		thread(f_e8m5_music_2());
		sleep_s(3);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		f_objective_complete_e8m5(scurve_objective_h);
		thread(vo_e8m5_clear_base());
		sleep_s(12);
		wake(f_almost_done_dialog);
		sleep_until(b_85_blip_final == TRUE, 1);
		f_blip_remaining();

end

script static void f_end_event_e8m5_8()

		sleep_until(LevelEventStatus("end_event_8"), 1);
		print("ENDING EVENT 8");
		
end

script static void f_start_event_e8m5_8_1()

		sleep_until(LevelEventStatus("start_event_8_1"), 1);
		print("STARTING EVENT 8_1");
		ai_place(e8m5_phantom_wraith_front);
		f_phantom_load_playload(e8m5_phantom_wraith_front, e8m5_ff_wraith_1);
		thread(f_blip_wraiths(e8m5_ff_wraith_1));
		sleep(1);
		thread(f_wraith_hijack_check(e8m5_ff_wraith_1.driver));
		ai_place(e8m5_phantom_wraith_right);
		f_phantom_load_playload(e8m5_phantom_wraith_right, e8m5_ff_wraith_2);
		thread(f_blip_wraiths(e8m5_ff_wraith_2));
		sleep(1);
		thread(f_wraith_hijack_check(e8m5_ff_wraith_2.driver));

end

script static void f_start_event_e8m5_8_2()

		sleep_until(LevelEventStatus("start_event_8_2"), 1);
		print("STARTING EVENT 8_2");
		sleep_until((ai_living_count(e8m5_blippable) <= 0), 1);
		sleep_s(1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		thread(vo_glo15_palmer_reinforcements_03());
		ai_place(e8m5_phantom_wraith_right_d);
		f_e8m5_music_phantoms();
		sleep(1);
		f_blip_object_cui (unit_get_vehicle(e8m5_phantom_wraith_right_d.driver), "navpoint_enemy");
		sleep_s(random_range(1, 3));
		ai_place(e8m5_phantom_wraith_left);
		sleep(1);
		f_blip_object_cui (unit_get_vehicle(e8m5_phantom_wraith_left.driver), "navpoint_enemy");
		wake(f_take_down_setup);
		f_phantom_load_playload(e8m5_phantom_wraith_left, e8m5_ff_wraith_3);
		sleep_s(random_range(2, 5));
		ai_place(e8m5_phantom_wraith_back_d);
		sleep(1);
		f_blip_object_cui (unit_get_vehicle(e8m5_phantom_wraith_back_d.driver), "navpoint_enemy");
		sleep_s(random_range(1, 3));
		sleep_until(ai_living_count(e8m5_phantom_wraith_back_d) <= 0);
		ai_place(e8m5_phantom_wraith_front);
		f_phantom_load_playload(e8m5_phantom_wraith_front, e8m5_ff_wraith_4);
		sleep_s(random_range(2, 5));
		sleep_until(ai_living_count(e8m5_phantom_wraith_left) <= 0);
		ai_place(e8m5_phantom_wraith_left_d);
		sleep_s(random_range(1, 3));
		sleep_until(ai_living_count(e8m5_phantom_wraith_right_d) <= 0);
		ai_place(e8m5_phantom_wraith_right);
		f_phantom_load_playload(e8m5_phantom_wraith_right, e8m5_ff_wraith_5);
		
		sleep_until(ai_living_count(e8m5_ff_all) <= 0);
		b_last_wraith_killed = TRUE;
		f_e8m5_music_final_wraiths_destroyed();

end

script dormant f_take_down_setup()

	sleep(1);
	sleep_until(ai_living_count(e8m5_phantom_wraith_left) <= 0);
	sleep_until(global_narrative_is_on == FALSE, 1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	thread(vo_e8m5_take_down());
	sleep(1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	f_objective_complete_e8m5(e8m5_objective_8);
	f_e8m5_music_wraiths();

end


script dormant f_almost_done_dialog()

	sleep_until(ai_living_count(e8m5_ff_all) <= 5);
	sleep_s(1);
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	vo_e8m5_covenant_left();
	b_85_blip_final = TRUE;
	
end

script static void f_end_event_e8m5_9_1()

		sleep_until(LevelEventStatus("end_event_9_1"), 1);
		print("ENDING EVENT 9_1");
		sleep_until(b_last_wraith_killed == TRUE);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		sleep_s(3);
		thread(vo_e8m5_board_pelican());
		f_objective_complete_e8m5(e8m5_objective_9);
		sleep_s(2);
		b_stop_shooting = TRUE;
		ai_set_blind( e8m5_air_turret_2, TRUE);
		ai_set_blind( e8m5_air_turret_1, TRUE);
		ai_place(e8m5_pelican);
		sleep_s(3);
		f_blip_object_cui (unit_get_vehicle(e8m5_pelican.driver), "navpoint_goto");
		//b_end_player_goal = TRUE;
		
end

script static void f_e8_m5_end_mission

		sleep_until (LevelEventStatus ("e8_m5_ending"), 1);
		sleep_until(b_pelican_landed == TRUE);
		sleep_until(volume_test_players(tv_e8m5_end));
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		f_e8m5_music_stop();
		thread(vo_e8m5_narrative_out());
		local long show = pup_play_show(e8_m5_out);
		hud_show(false);
		ai_erase(e8m5_pelican);
		player_enable_input(FALSE);
		sleep_until(not pup_is_playing(show), 1);
		sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
		cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
		b_end_player_goal = TRUE;
		
end

script static void f_blip_wraiths(ai wraith)

	sleep_until ( volume_test_objects ( tv_mezz_floor, (ai_actors (wraith))) );
	spops_blip_object(ai_vehicle_get_from_squad(wraith, 0), TRUE, "neutralize_health");
	
end

script static void f_wraith_hijack_check(unit u_driver)

	sleep_s(15);
	local vehicle o_vehicle = unit_get_vehicle(u_driver);
	print("TESTING THE SEATS");
	sleep_until(unit_in_vehicle(u_driver) == FALSE, 1);
	print("NO ONE IS IN ME");
	f_unblip_object_cui(o_vehicle);
	
end

script static void f_objective_complete_e8m5(string_id objective_text)

	f_objective_complete();
	sleep_s(2);
	f_new_objective(objective_text);
	
end

// ============================================	PLACEMENT SCRIPT	========================================================

// PHANTOM SCRIPTING

script command_script cs_e8m5_phantom_1()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	
	sleep_s(2);	
		
	cs_fly_to( e8m5_phantom_wave_1_ps.p0 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p2 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p3 );

	f_unload_phantom( e8m5_phantom_wave_1, "dual" );

	print ("unload phantom_1");
	
	cs_fly_to( e8m5_phantom_wave_1_ps.p4 );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	cs_fly_to( e8m5_phantom_wave_1_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p6 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p7 );

	ai_erase (e8m5_phantom_wave_1);
	
end

script command_script cs_e8m5_phantom_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);

	sleep_s(2);	

	cs_fly_to( e8m5_phantom_wave_2_ps.p0 );
	wake(f_incoming_phantom_1);
	cs_fly_to( e8m5_phantom_wave_2_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p9 );
	cs_fly_to_and_face( e8m5_phantom_wave_2_ps.p2, e8m5_phantom_wave_2_ps.p8 );

	f_unload_phantom( e8m5_phantom_wave_2, "dual" );

	print ("unload phantom_2");
	
	cs_fly_to_and_face( e8m5_phantom_wave_2_ps.p3, e8m5_phantom_wave_2_ps.p8 );
	b_front_guys_down = TRUE;
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	cs_fly_to( e8m5_phantom_wave_2_ps.p4 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p6 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p7 );

	ai_erase (e8m5_phantom_wave_2);
	
end

script dormant f_incoming_phantom_1()
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	vo_glo15_palmer_phantom_01();
end

script dormant f_incoming_phantom_2()
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	vo_glo15_miller_contacts_04();
end

script dormant f_incoming_phantom_3()
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	vo_glo15_miller_phantom_01();
end

script command_script cs_e8m5_phantom_3()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);

	cs_fly_to( e8m5_phantom_wave_3_ps.p0 );
	wake(f_incoming_phantom_2);
	cs_fly_to( e8m5_phantom_wave_3_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p2 );
	cs_fly_to_and_face( e8m5_phantom_wave_3_ps.p3, e8m5_phantom_wave_3_ps.p7 );
	
	f_unload_phantom( e8m5_phantom_wave_3, "dual" );

	print ("unload phantom_3");
	b_phantom_three_dropped = TRUE;
	cs_fly_to( e8m5_phantom_wave_3_ps.p4 );
	object_cannot_die(unit_get_vehicle(ai_current_actor), FALSE);
	cs_fly_to( e8m5_phantom_wave_3_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p6 );

	ai_erase (e8m5_phantom_wave_3);
	
end

script command_script cs_e8m5_phantom_4()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);

	cs_fly_to( e8m5_phantom_4_ps.p0 );
	wake(f_incoming_phantom_3);
	cs_fly_to( e8m5_phantom_4_ps.p1 );
	cs_fly_to_and_face( e8m5_phantom_4_ps.p2, e8m5_phantom_4_ps.p8 );
	cs_fly_to_and_face( e8m5_phantom_4_ps.p3, e8m5_phantom_4_ps.p7 );
	
	f_unload_phantom( e8m5_phantom_4, "dual" );

	print ("unload phantom_4");
	
	cs_fly_to( e8m5_phantom_4_ps.p4 );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	cs_fly_to( e8m5_phantom_4_ps.p5 );
	cs_fly_to( e8m5_phantom_4_ps.p6 );

	ai_erase (e8m5_phantom_4);
	
end

script command_script cs_e8m5_phantom_w_f()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
		
	cs_fly_to( e8m5_phantom_w_f_ps.p0 );
	cs_fly_to( e8m5_phantom_w_f_ps.p1 );
	cs_fly_to( e8m5_phantom_w_f_ps.p2 );
	cs_fly_to_and_face( e8m5_phantom_w_f_ps.p3, e8m5_phantom_w_f_ps.p8  );

	vehicle_unload( unit_get_vehicle( e8m5_phantom_wraith_front.driver ), "phantom_lc" );

	print ("unload wraith front");
	
	cs_fly_to_and_face( e8m5_phantom_w_f_ps.p3, e8m5_phantom_w_f_ps.p4 );
	cs_fly_to( e8m5_phantom_w_f_ps.p4 );
	cs_run_command_script(e8m5_air_turret_2.spawn_points_1, cs_shoot_down_front);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_front.driver ), .1);
	cs_fly_to( e8m5_phantom_w_f_ps.p5 );
	cs_fly_to_and_face( e8m5_phantom_w_f_ps.p5, e8m5_phantom_w_f_ps.p9 );
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_mid, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_front) <= 0);
	
end

script command_script cs_e8m5_phantom_w_b()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
		
	cs_fly_to( e8m5_phantom_w_f_ps.p0 );
	cs_fly_to( e8m5_phantom_w_f_ps.p10 );
	cs_fly_to( e8m5_phantom_w_f_ps.p11 );
	cs_run_command_script(e8m5_air_turret_1.spawn_points_1, cs_shoot_down_back);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_back_d.driver ), .1);
	cs_fly_to_and_face( e8m5_phantom_w_f_ps.p5, e8m5_phantom_w_f_ps.p4 );
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_mid, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_back_d) <= 0);
	
end

script command_script cs_e8m5_phantom_w_r()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_w_r_ps.p0 );
	cs_fly_to( e8m5_phantom_w_r_ps.p1 );
	cs_fly_to (e8m5_phantom_w_r_ps.p2 );

	vehicle_unload( unit_get_vehicle( e8m5_phantom_wraith_right.driver ), "phantom_lc" );
	cs_run_command_script(e8m5_air_turret_1.spawn_points_0, cs_shoot_down_right);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_right.driver ), .1);
	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m5_phantom_w_r_ps.p3, e8m5_phantom_w_r_ps.p5);
	
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_1, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_right) <= 0);
	
end

script command_script cs_e8m5_phantom_w_r_d()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_w_r_ps.p0 );
	cs_fly_to( e8m5_phantom_w_r_ps.p1 );
	cs_run_command_script(e8m5_air_turret_1.spawn_points_0, cs_shoot_down_right_2);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_right_d.driver ), .1);
	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m5_phantom_w_r_ps.p3, e8m5_phantom_w_r_ps.p5);
	
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_1, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_right) <= 0);
	
end

script command_script cs_e8m5_phantom_hunters()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_hunters_ps.p0 );
	cs_fly_to( e8m5_phantom_hunters_ps.p1 );
	cs_fly_to( e8m5_phantom_hunters_ps.p9 );
	cs_fly_to_and_face( e8m5_phantom_hunters_ps.p2, e8m5_phantom_hunters_ps.p8 );

	f_unload_phantom( e8m5_phantom_hunters, "dual" );

	print ("unload phantom_2");
	
	cs_fly_to_and_face( e8m5_phantom_hunters_ps.p3, e8m5_phantom_hunters_ps.p8 );
	cs_fly_to( e8m5_phantom_hunters_ps.p4 );
	cs_fly_to( e8m5_phantom_hunters_ps.p5 );
	cs_fly_to( e8m5_phantom_hunters_ps.p6 );
	cs_fly_to( e8m5_phantom_hunters_ps.p7 );

	ai_erase (e8m5_phantom_hunters);
	
end

script command_script cs_e8m5_phantom_w_l()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_w_l_ps.p0 );
	cs_fly_to( e8m5_phantom_w_l_ps.p1 );
	cs_fly_to( e8m5_phantom_w_l_ps.p2);
	cs_fly_to( e8m5_phantom_w_l_ps.p3);
	
	vehicle_unload( unit_get_vehicle( e8m5_phantom_wraith_left.driver ), "phantom_lc" );
	print ("unload phantom_4");
	
	cs_run_command_script(e8m5_air_turret_2.spawn_points_0, cs_shoot_down_left);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_left.driver ), .1);
	cs_fly_to_and_face(e8m5_phantom_w_l_ps.p4, e8m5_phantom_w_l_ps.p8);
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_2, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_left) <= 0);
	
end

script command_script cs_e8m5_phantom_w_l_d()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_w_l_ps.p0 );
	cs_fly_to( e8m5_phantom_w_l_ps.p1 );
	cs_fly_to( e8m5_phantom_w_l_ps.p2);
	
	cs_run_command_script(e8m5_air_turret_2.spawn_points_0, cs_shoot_down_left_2);
	object_set_health(unit_get_vehicle( e8m5_phantom_wraith_left_d.driver ), .1);
	cs_fly_to_and_face(e8m5_phantom_w_l_ps.p4, e8m5_phantom_w_l_ps.p8);
	repeat
		cs_shoot_point(TRUE, ai_point_set_get_point(ps_aa_turrets_2, random_range(0, 1)));
	until(ai_living_count(e8m5_phantom_wraith_left) <= 0);
	
end

script static void f_phantom_load_playload (ai dropship, ai squad1)

	print ("spawning payload");
	ai_place_in_limbo  (squad1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_lc", ai_vehicle_get_from_squad(squad1, 0));
	print ("payload attached");
	ai_exit_limbo (squad1);
	
end

// AIR TURRETS

script command_script cs_air_turrets() 

	object_set_scale(ai_vehicle_get ( ai_current_actor ), .20, 0);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_in", "fx_life_source");
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor)); 
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_m8e5_pelican()

	cs_ignore_obstacles( ai_current_actor, TRUE );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	ai_cannot_die(ai_current_actor, TRUE);
	cs_fly_by(e8m5_pelican_ps.p0);
	cs_fly_by(e8m5_pelican_ps.p1);
	cs_fly_by(e8m5_pelican_ps.p2);
  cs_fly_to_and_face(e8m5_pelican_ps.p3, e8m5_pelican_ps.p4);
  b_pelican_landed = TRUE;
  
end

script command_script cs_turret_phase_in()

	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_in", "shade_d");
	
end

script command_script cs_random_shooting()

	print("I'M GONNA SHOOT IT!");
	repeat
		cs_face(TRUE, ai_point_set_get_point(ps_shoot_at, random_range(0, 13)));
		sleep_s(random_range(2, 5));
	until
		(b_stop_shooting == TRUE);

end

script command_script cs_shoot_down_left()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_left);
	until(ai_living_count(e8m5_phantom_wraith_left) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_shoot_down_right()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_right);
	until(ai_living_count(e8m5_phantom_wraith_right) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_shoot_down_front()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_front);
	until(ai_living_count(e8m5_phantom_wraith_front) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_shoot_down_back()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_back_d);
	until(ai_living_count(e8m5_phantom_wraith_back_d) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_shoot_down_left_2()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_left_d);
	until(ai_living_count(e8m5_phantom_wraith_left_d) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

script command_script cs_shoot_down_right_2()

	repeat
		cs_shoot(TRUE, e8m5_phantom_wraith_right_d);
	until(ai_living_count(e8m5_phantom_wraith_right_d) <= 0);
	
	cs_run_command_script(ai_current_actor, cs_random_shooting);
	
end

// ============================================ LOCATION TIMERS ==========================================================

script static void f_location_timer_1()

	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_1) == TRUE, 1);
		s_special_1 = (s_special_1 + 1);
	until
		(b_loc_1_done == TRUE);
		
end
	
script static void f_location_timer_2()

	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_2) == TRUE, 1);
		s_special_2 = (s_special_2 + 1);
	until
		(b_loc_2_done == TRUE);
		
end
	
script static void f_location_timer_3()

	thread(f_active_defenses_3());
	
	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_3) == TRUE, 1);
		s_special_3 = (s_special_3 + 1);
	until
		(b_loc_3_done == TRUE);
		
end
	
script static void f_location_timer_4()

	thread(f_active_defenses_4());
	
	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_4) == TRUE, 1);
		s_special_4 = (s_special_4 + 1);
	until
		(b_loc_4_done == TRUE);
		
end
	
script static void f_location_timer_5()

	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_5) == TRUE, 1);
		s_special_5 = (s_special_5 + 1);
	until
		(b_loc_5_done == TRUE);
		
end
	
script static void f_location_timer_6()

	thread(f_active_defenses_6());
	
	repeat
		sleep(5);
		sleep_until(volume_test_players(tv_e8m3_6) == TRUE, 1);
		s_special_6 = (s_special_6 + 1);
	until
		(b_loc_6_done == TRUE);
		
end
	
script static void f_location_timer_7()

	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_7) == TRUE, 1);
		s_special_7 = (s_special_7 + 1);
	until
		(b_loc_7_done == TRUE);
		
end
	
script static void f_location_timer_8()

	repeat
		sleep(10);
		sleep_until(volume_test_players(tv_e8m3_8) == TRUE, 1);
		s_special_8 = (s_special_8 + 1);
	until
		(b_loc_8_done == TRUE);
		
end
	
script static void f_location_timer_missed(trigger_volume tv_loc)

	local short s_time = 0;
	print("player missed bonus");
	
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_loc) == TRUE, 1);
		s_time = (s_time + 1);
	until
		(s_time == 3);
		
end
	
// ============================================ ACTIVE DEFENSES ==========================================================

script static void f_active_defenses_2()

	print("FULL BONUS OBTAINED");
	
end

script static void f_active_defenses_3()

	sleep_until(s_special_3 >= 1);
	device_set_power(e8m5_cvr_1a, 1);
	device_set_power(e8m5_cvr_1b, 1);
	device_set_power(e8m5_cvr_2a, 1);
	device_set_power(e8m5_cvr_2b, 1);
	device_set_power(e8m5_cvr_3a, 1);
	device_set_power(e8m5_cvr_3b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_4a, 1);
	device_set_power(e8m5_cvr_4b, 1);
	b_cover_narr = TRUE;
	sleep(10);
	device_set_power(e8m5_cvr_5a, 1);
	device_set_power(e8m5_cvr_5b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_6a, 1);
	device_set_power(e8m5_cvr_6b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_9a, 1);
	device_set_power(e8m5_cvr_9b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_10a, 1);
	device_set_power(e8m5_cvr_10b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_11, 1);
	sleep(10);
	device_set_power(e8m5_cvr_12, 1);
	sleep(10);
	device_set_power(e8m5_cvr_13, 1);
	sleep(10);
	device_set_power(e8m5_cvr_14, 1);
	sleep(10);
	device_set_power(e8m5_cvr_15, 1);
	sleep(10);
	device_set_power(e8m5_cvr_16, 1);
	sleep(10);
	device_set_power(e8m5_cvr_17a, 1);
	device_set_power(e8m5_cvr_17b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_18a, 1);
	device_set_power(e8m5_cvr_18b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_19a, 1);
	device_set_power(e8m5_cvr_19b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_20a, 1);
	device_set_power(e8m5_cvr_20b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_21a, 1);
	device_set_power(e8m5_cvr_21b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_22a, 1);
	device_set_power(e8m5_cvr_22b, 1);
	sleep(10);
	device_set_power(e8m5_cvr_23a, 1);
	device_set_power(e8m5_cvr_23b, 1);
	s_special_3 = 100;
	print("FULL BONUS OBTAINED");
	
end

script static void f_active_defenses_4()

	sleep_until(s_special_4 >= 1);
	ai_place(e8m5_turrets_1);
	wake(f_first_turret_in_dialogue);
	sleep_until(s_special_4 >= 2);
	ai_place(e8m5_turrets_3.a);
	sleep_until(s_special_4 >= 3);
	ai_place(e8m5_turrets_3.b);
	sleep_until(s_special_4 >= 4);
	ai_place(e8m5_turrets_5.a);
	sleep_until(s_special_4 >= 5);
	ai_place(e8m5_turrets_5.b);
	sleep_until(s_special_4 >= 6);
	ai_place(e8m5_turrets_7);
	s_special_4 = 100;
	print("FULL BONUS OBTAINED");
	sleep_until(b_e8m5_narrative_is_on == FALSE, 1);
	sleep_until(global_narrative_is_on == FALSE, 1);
	vo_e8m5_turrets_operational();
	
end

script dormant f_first_turret_in_dialogue()
	sleep_s(1);
	b_first_turret_in = TRUE;
end

script static void f_active_defenses_5()

	print("FULL BONUS OBTAINED");
	
end

script static void f_active_defenses_6()

	sleep_until(s_special_6 >= 1);
	object_create(e8m3_fore_rack_13);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_13, "powers_incin02");
	b_first_weapons_in = TRUE;
	sleep_until(s_special_6 >= 2);
	object_create(e8m3_fore_rack_1);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_1, "powers_incin02");
	sleep_until(s_special_6 >= 3);
	object_create(e8m3_fore_rack_2);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_2, "powers_incin02");
	sleep_until(s_special_6 >= 4);
	object_create(e8m3_fore_rack_3);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_3, "powers_incin02");
	sleep_until(s_special_6 >= 5);
	object_create(e8m3_fore_rack_4);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_4, "powers_incin02");
	sleep_until(s_special_6 >= 6);
	object_create(e8m3_fore_rack_5);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_5, "powers_incin02");
	sleep_until(s_special_6 >= 7);
	object_create(e8m3_fore_rack_6);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_6, "powers_incin02");
	sleep_until(s_special_6 >= 8);
	object_create(e8m3_fore_rack_7);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_7, "powers_incin02");
	sleep_until(s_special_6 >= 9);
	object_create(e8m3_fore_rack_8);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_8, "powers_incin02");
	sleep_until(s_special_6 >= 10);
	object_create(e8m3_fore_rack_9);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_9, "powers_incin02");
	sleep_until(s_special_6 >= 11);
	object_create(e8m3_fore_rack_10);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_10, "powers_incin02");
	sleep_until(s_special_6 >= 12);
	object_create(e8m3_fore_rack_11);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_11, "powers_incin02");
	sleep_until(s_special_6 >= 13);
	object_create(e8m3_fore_rack_12);
	effect_new_on_object_marker("objects\characters\storm_pawn\fx\pawn_phase_in.effect", e8m3_fore_rack_12, "powers_incin02");
	s_special_6 = 100;
	print("FULL BONUS OBTAINED");
	
end

script static void f_active_defenses_7()

	print("FULL BONUS OBTAINED");
	
end

script static void f_active_defenses_8()

	print("FULL BONUS OBTAINED");
	
end

script static void f_setup_loc_fx(cutscene_flag flg_blip, boolean b_mid, boolean b_blip)

	if b_blip == TRUE
		then f_blip_flag(flg_blip, "defend");
	end

	if b_mid == TRUE
		then effect_new( levels\dlc\ff151_mezzanine\fx\area_pulse_medium.effect, flg_blip);
		else effect_new( levels\dlc\ff151_mezzanine\fx\area_pulse_large.effect, flg_blip);
	end
end

script static void f_remove_loc_fx(cutscene_flag flg_blip, boolean b_mid, object o_sound)

	//thread(f_kill_scan_effect());

	sound_impulse_start ("sound\environments\multiplayer\dlc1_mezzanine\fx\spops_dm_scanning_orange_to_blue_mnde1843", o_sound, 1 );
	f_unblip_flag(flg_blip);
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player0, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player1, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player2, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player3, "pedestal");
	
	if b_mid == TRUE
		then effect_kill_from_flag( levels\dlc\ff151_mezzanine\fx\area_pulse_medium.effect, flg_blip);
				 effect_new(levels\dlc\ff152_vortex\fx\unsc_area_pulse_medium.effect, flg_blip);
		else effect_kill_from_flag( levels\dlc\ff151_mezzanine\fx\area_pulse_large.effect, flg_blip);
				 effect_new(levels\dlc\ff152_vortex\fx\unsc_area_pulse_medium.effect, flg_blip);
	end
	
end

script static void f_sleep_check_special( short s_special, trigger_volume tv_loc)

		if s_special < 3
			then f_location_timer_missed(tv_loc);
		end
end

script static void f_blip_remaining()

	if ai_living_count(e8m5_blippable) > 4
		then sleep_until((ai_living_count(e8m5_blippable) <= 5), 1);
				 f_blip_ai_cui(e8m5_blippable, "navpoint_enemy");
	end
	
	sleep_until(ai_living_count(e8m5_blippable) <= 4);
	
end

script static void f_player0_respawn_check()
	
	g_fx_player0 = player0;
	
	repeat
		sleep_until(biped_is_alive(unit(player0)) == FALSE, 1);
		sleep_until(biped_is_alive(unit(player0)) == TRUE, 1);
		g_fx_player0 = player0;
	until(0 == 1);
end

script static void f_player1_respawn_check()

	g_fx_player1 = player1;

	repeat
		sleep_until(biped_is_alive(unit(player1)) == FALSE, 1);
		sleep_until(biped_is_alive(unit(player1)) == TRUE, 1);
		g_fx_player1 = player1;
	until(0 == 1);
end

script static void f_player2_respawn_check()

	g_fx_player2 = player2;

	repeat
		sleep_until(biped_is_alive(unit(player2)) == FALSE, 1);
		sleep_until(biped_is_alive(unit(player2)) == TRUE, 1);
		g_fx_player2 = player2;
	until(0 == 1);
end

script static void f_player3_respawn_check()

	g_fx_player3 = player3;

	repeat
		sleep_until(biped_is_alive(unit(player3)) == FALSE, 1);
		sleep_until(biped_is_alive(unit(player3)) == TRUE, 1);
		g_fx_player3 = player3;
	until(0 == 1);
end

script static void f_scan_hud_pip(trigger_volume tv_area)

	sleep_until(volume_test_players(tv_area) == TRUE);
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G01_60" );

end
	

script static void f_player_scan_check(trigger_volume tv_area)

	thread(f_scan_hud_pip(tv_area));

	sleep(1);
	
	if player_valid(player0)
		then thread(f_player_scan(g_fx_player0, tv_area));
	end
	
	if player_valid(player1)
		then thread(f_player_scan(g_fx_player1, tv_area));
	end
	
	if player_valid(player2)
		then thread(f_player_scan(g_fx_player2, tv_area));
	end
	
	if player_valid(player3)
		then thread(f_player_scan(g_fx_player3, tv_area));
	end
	
end
	
script static void f_player_scan(object o_player, trigger_volume tv_area)

	sleep(1);
	print("scan effect on");
	
	if b_loc_1_active == TRUE then
		thread(f_player_scan_1(o_player, tv_area));
		print("Scan 1 is ACTIVE");
	
		else if b_loc_2_active == TRUE then
			thread(f_player_scan_2(o_player, tv_area));
			print("Scan 2 is ACTIVE");
		
			else if b_loc_3_active == TRUE then
				thread(f_player_scan_3(o_player, tv_area));
				print("Scan 3 is ACTIVE");
		
				else if b_loc_4_active == TRUE then
					thread(f_player_scan_4(o_player, tv_area));
					print("Scan 4 is ACTIVE");
		
					else if b_loc_6_active == TRUE then
						thread(f_player_scan_6(o_player, tv_area));
						print("Scan 6 is ACTIVE");
		
						else if b_loc_7_active == TRUE then
							thread(f_player_scan_7(o_player, tv_area));
							print("Scan 7 is ACTIVE");
		
							else if b_loc_8_active == TRUE then
									thread(f_player_scan_8(o_player, tv_area));
									print("Scan 8 is ACTIVE");
		
								else
									print("SOMETHING BROOOOOOOOOKE");		
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
	
script static void f_player_scan_1(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_1_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_1_done == TRUE, 1);
		
		print("scan 1 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_1_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_1_done == TRUE, 1);
		
			print("scan 1 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_1_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_1_done == TRUE, 1);
		
				print("scan 1 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_1_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_1_done == TRUE, 1);
		
					print("scan 1 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_2(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_2_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_2_done == TRUE, 1);
		
		print("scan 2 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_2_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_2_done == TRUE, 1);
		
			print("scan 2 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_2_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_2_done == TRUE, 1);
		
				print("scan 2 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_2_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_2_done == TRUE, 1);
		
					print("scan 2 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_3(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_3_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_3_done == TRUE, 1);
		
		print("scan 3 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_3_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_3_done == TRUE, 1);
		
			print("scan 3 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_3_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_3_done == TRUE, 1);
		
				print("scan 3 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_3_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_3_done == TRUE, 1);
		
					print("scan 3 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_4(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_4_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_4_done == TRUE, 1);
		
		print("scan 4 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_4_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_4_done == TRUE, 1);
		
			print("scan 4 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_4_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_4_done == TRUE, 1);
		
				print("scan 4 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_4_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_4_done == TRUE, 1);
		
					print("scan 4 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_6(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_6_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_6_done == TRUE, 1);
		
		print("scan 6 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_6_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_6_done == TRUE, 1);
		
			print("scan 6 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_6_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_6_done == TRUE, 1);
		
				print("scan 6 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_6_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_6_done == TRUE, 1);
		
					print("scan 6 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_7(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_7_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_7_done == TRUE, 1);
		
		print("scan 7 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_7_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_7_done == TRUE, 1);
		
			print("scan 7 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_7_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_7_done == TRUE, 1);
		
				print("scan 7 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_7_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_7_done == TRUE, 1);
		
					print("scan 7 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player_scan_8(object o_player, trigger_volume tv_area)

	if o_player == g_fx_player0 then
		repeat
			sleep_until(volume_test_object(tv_area, g_fx_player0) AND object_get_health(g_fx_player0) > 0 AND b_loc_8_active == TRUE, 1);
			f_player0_scan_fx(tv_area);
		until(b_loc_8_done == TRUE, 1);
		
		print("scan 8 off");
		
		else if o_player == g_fx_player1 then
			repeat
				sleep_until(volume_test_object(tv_area, g_fx_player1) AND object_get_health(g_fx_player1) > 0 AND b_loc_8_active == TRUE, 1);
				f_player1_scan_fx(tv_area);
			until(b_loc_8_done == TRUE, 1);
		
			print("scan 8 off");
			
			else if o_player == g_fx_player2 then
				repeat
					sleep_until(volume_test_object(tv_area, g_fx_player2) AND object_get_health(g_fx_player2) > 0 AND b_loc_8_active == TRUE, 1);
					f_player2_scan_fx(tv_area);
				until(b_loc_8_done == TRUE, 1);
		
				print("scan 8 off");
			
				else if o_player == g_fx_player3 then
					repeat
						sleep_until(volume_test_object(tv_area, g_fx_player3) AND object_get_health(g_fx_player3) > 0 AND b_loc_8_active == TRUE, 1);
						f_player3_scan_fx(tv_area);
					until(b_loc_8_done == TRUE, 1);
		
					print("scan 8 off");
					
				end
				
			end
			
		end
		
	end
	
end

script static void f_player0_scan_fx(trigger_volume tv_area)

	effect_new_on_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player0, "pedestal");
	print("player0 in volume, start effect");
	sleep(1);
	sleep_until(volume_test_object(tv_area, g_fx_player0) == FALSE or object_get_health(g_fx_player0) <= 0 or b_any_loc_active == FALSE, 1);
	sleep(1);
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player0, "pedestal");
	print("player0 out of volume, kill effect");
	sleep(5);
			
end

script static void f_player1_scan_fx(trigger_volume tv_area)

	effect_new_on_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player1, "pedestal");
	print("player1 in volume, start effect");
	sleep(1);
	sleep_until(volume_test_object(tv_area, g_fx_player1) == FALSE or object_get_health(g_fx_player1) <= 0 or b_any_loc_active == FALSE, 1);
	sleep(1);
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player1, "pedestal");
	print("player1 out of volume, kill effect");
	sleep(5);
			
end

script static void f_player2_scan_fx(trigger_volume tv_area)

	effect_new_on_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player0, "pedestal");
	print("player2 in volume, start effect");
	sleep(1);
	sleep_until(volume_test_object(tv_area, g_fx_player2) == FALSE or object_get_health(g_fx_player2) <= 0 or b_any_loc_active == FALSE, 1);
	sleep(1);
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player2, "pedestal");
	print("player2 out of volume, kill effect");
	sleep(5);
			
end

script static void f_player3_scan_fx(trigger_volume tv_area)

	effect_new_on_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player3, "pedestal");
	print("player3 in volume, start effect");
	sleep(1);
	sleep_until(volume_test_object(tv_area, g_fx_player3) == FALSE or object_get_health(g_fx_player3) <= 0 or b_any_loc_active == FALSE, 1);
	sleep(1);
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, g_fx_player3, "pedestal");
	print("player3 out of volume, kill effect");
	sleep(5);
			
end

script static void f_kill_scan_effect()

repeat
	if b_any_loc_active == FALSE
	then
		effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player0, "pedestal");
		effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player1, "pedestal");
		effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player2, "pedestal");
		effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player3, "pedestal");
	end
	sleep(5);
	until(1 == 0);
	
end

// ============================================ ACTIVE CAMO SCRIPT =======================================================
script command_script cs_active_camo_use()

  if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
  	dprint( "cs_active_camo_use: ENABLED" );
  	thread( f_active_camo_manager(ai_current_actor) );
  end
  
end

script static void f_active_camo_manager( ai ai_actor )

	local long l_timer = 0;
	local object obj_actor = ai_get_object( ai_actor );

  repeat
                
  // activate camo
  if ( unit_get_health(ai_actor) > 0.0 ) then
    ai_set_active_camo( ai_actor, TRUE );
    dprint( "f_active_camo_manager: ACTIVE" ); 
  end
                                
  // disable camo
  sleep_until( (unit_get_health(ai_actor) <= 0.0) or (objects_distance_to_object(Players(),obj_actor) <= 3.00) or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 1 );
   if ( unit_get_health(ai_actor) > 0.0 ) then
   	ai_set_active_camo( ai_actor, FALSE );
    dprint( "f_active_camo_manager: DISABLED" ); 
   end
                                
	// manage resetting
   if ( unit_get_health(ai_actor) > 0.0 ) then
     l_timer = timer_stamp( 5.0, 10.0 );
     sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
   end
   if ( unit_get_health(ai_actor) > 0.0 ) then
     dprint( "f_active_camo_manager: RESET" ); 
   end
                
   until ( unit_get_health(ai_actor) <= 0.0, 1 );

end

//////MUSIC SCRIPTING//////
//Note: Final 4 are in the script.

script static void f_e8m5_music()
	thread(f_e8m5_music_start());
	sleep_until(ai_living_count(e8m5_ff_init_all) <= 16 OR volume_test_players(tv_e8m5_music_start), 1);
	thread(f_e8m5_music_first_begin());
	sleep_until(ai_living_count(e8m5_ff_init_all) == 0, 1);
	thread(f_e8m5_music_first_end());
end

script static void f_e8m5_music_2()
	sleep_until(ai_living_count(e8m5_ff_wave_8_spec) > 0, 1);
	thread(f_e8m5_music_final_begin());
	sleep_until(ai_living_count(e8m5_ff_wave_8_spec) == 0, 1);
	thread(f_e8m5_music_final_end());
end