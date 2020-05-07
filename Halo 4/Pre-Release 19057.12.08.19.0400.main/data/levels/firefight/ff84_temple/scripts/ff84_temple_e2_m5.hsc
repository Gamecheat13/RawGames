//=============================================================================================================================
//============================================ TEMPLE E2_M5 SPARTAN OPS SCRIPT ==================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
global short e2m5_switchesdown = 0;
global short e2m5_4bridgeswitches_hit = 0;
global boolean e2m5_followtime = FALSE;
global boolean e2m5_jungletime = FALSE;
global boolean e2m5_narrativein_done = FALSE;
global boolean e2m5_narrativeout_done = FALSE;
global boolean e2m5_playersintheback = FALSE;
global boolean e2m5_rvb_is_on = FALSE;
global boolean e2m5_leavebackroom = FALSE;
global boolean e2m5_whatssciencesay = FALSE;
global boolean e2m5_leave_backroom = FALSE;

//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 02: Mission 05																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//






//343++343==343++343==343++343//	E2M5 Startup Script	//343++343==343++343==343++343//

script startup temple_e2_m5_variant()
	sleep_until (LevelEventStatus ("e2m5_variant"), 1);
	e2m5_narrativein_done = FALSE;
	thread(f_music_e2m5_start());
	ai_ff_all = e2m5_ff_all;
	print ("e2m5 variant started");
	switch_zone_set (e2_m5_temple);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	kill_volume_disable(kill_e4_m1_kill_players_door);
	kill_volume_disable(kill_v1);												// tjp 8-18-12
	effects_distortion_enabled = 0;
	e2m5_rvb_is_on = FALSE;
	e2m5_leavebackroom = FALSE;
	thread (e2m5_rvb_checker());
	//	add "Devices" folders
		f_add_crate_folder (e2m5_dogtags);															//	Device Controls for E2M5
	//	add "Vehicles" folders
		f_add_crate_folder (e2m5_turrets);															//	Vehicles for E2M5
	//	add "Crates" folders
		f_add_crate_folder (e2m5_props);																//	Prop Crates for E2M5
		f_add_crate_folder (e2m5_weaponcrates);													//	Weapon Racks and Crates for E2M5
		f_add_crate_folder (e2m5_dm_env);																//	Environment Device Machines
	//	add "Scenery" folders
		firefight_mode_set_crate_folder_at(e2m5_respawnzone_01, 50);		//	Initial Spawn Area for E2M5
		firefight_mode_set_crate_folder_at(e2m5_respawnzone_02, 51);		//	Second spawn area for E2M5
		firefight_mode_set_crate_folder_at(e2m5_respawnzone_03, 52);		//	Second spawn area for E2M5
	//	add "Items" folders
	
	//	add "Enemy Squad" Templates
		firefight_mode_set_squad_at(sq_e2m5_interior_01, 5); 						//	Interior Squad Template 01
		firefight_mode_set_squad_at(sq_e2m5_interior_02, 6); 						//	Interior Squad Template 02
		firefight_mode_set_squad_at(sq_e2m5_exterior_01, 7); 						//	Exterior Squad Template 01
		firefight_mode_set_squad_at(sq_e2m5_exterior_02, 8); 						//	Exterior Squad Template 02
		firefight_mode_set_squad_at(sq_e2m5_exterior_03, 9); 						//	Exterior Squad Template 03
	//	add "Objectives"
		firefight_mode_set_objective_name_at(e2m5_maproom_l_switch, 30);		//	Left interior switch
		firefight_mode_set_objective_name_at(e2m5_maproom_r_switch, 31);		//	Right interior switch
		firefight_mode_set_objective_name_at(e2m5_bridge_switch04, 32);	//	Exterior switch 01
		firefight_mode_set_objective_name_at(e2m5_bridge_switch03, 33);	//	Exterior switch 02
		firefight_mode_set_objective_name_at(e2m5_bridge_switch01, 34);	//	Exterior switch 03
		firefight_mode_set_objective_name_at(e2m5_bridge_switch02, 35);	//	Exterior switch 04
		firefight_mode_set_objective_name_at(e2m5_rockroom_switch, 36);	//	Exterior switch 05
	//	add "LZ" areas
		f_add_crate_folder (e2m5_lz01);						 											//	LZ's for E2M5
		firefight_mode_set_objective_name_at(e2m5_lz_01, 40);						//	Evac point
	thread (e2m5_dogtag_goal());
	firefight_mode_set_player_spawn_suppressed(TRUE);
	f_create_new_spawn_folder (50);
	sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
	
	// play intro vignette
	cinematic_start();
	thread(f_music_e2m5_vignette_start());
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m5_vin_sfx_intro', NONE, 1);
	thread (e2m5_pup_narrative_in());
	pup_play_show (e5m2_shell_anims);
	sleep_until (e2m5_narrativein_done == TRUE);
	cinematic_stop();
	thread(f_music_e2m5_vignette_finish());
	
	// start mission
	firefight_mode_set_player_spawn_suppressed(FALSE);
	//b_end_player_goal = TRUE;
	b_wait_for_narrative_hud = TRUE;
	//sleep_until (object_get_health (player0) > 0, 1);
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	sleep_s (0.5);
	fade_in (0,0,0,15);
end

script static void e2m5_rvb_checker()
	sleep_until (b_players_are_alive(), 1);
	sleep_until (object_valid (e2m5_rvb));
	print ("RVB object is now valid");
	sleep_until (object_get_health (e2m5_rvb) < 1, 1);
	object_cannot_take_damage (e2m5_rvb);
	// f_new_objective (rvb_confirm);
	e2m5_rvb_is_on = TRUE;
	inspect (e2m5_rvb_is_on);
	f_achievement_spops_1();
	print ("RVB TIIIIIIIIIIIIIMMMMMMMEEEEEEEEEEEE");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme'));
	print ("RVB audio done playing");
end

//343++343==343++343==343++343//	E2M5 Goal 01 Scripts (0. time_passed)	//343++343==343++343==343++343//

script static void e2m5_dogtag_goal
	sleep_until (LevelEventStatus ("e2m5_dogtaggoal_start"), 1);
	sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
	thread(f_music_e2m5_dogtag_goal_1_start());
	sleep (30 * 4);
	thread(f_music_e2m5_dogtag_goal_1_start_vo());
	thread (e2m5_tts_playstart());
	sleep (30 * 1);
	sleep_until (e2m5_narrative_is_on == FALSE);
	sleep_until (volume_test_players(e2m5_tv_dogtagvo), 1);
	e2m5_playersintheback = TRUE;
	thread(f_music_e2m5_dogtag_obtained_vo());
	f_unblip_flag (e2m5_fl_backroom);
	sleep (30 * 3);
	thread (e2m5_tts_1stcpucallout());
	sleep (30 * 1);
	sleep_until (e2m5_narrative_is_on == FALSE);
	sleep_until (device_get_position (e2m5_dogtag_01) > 0.0, 1);
	thread(f_music_e2m5_dogtag_obtained());
	device_set_power (e2m5_dogtag_01, 0.0);
	f_unblip_flag (e2m5_fl_dogtag);
	object_destroy (e2m5_dogtag_01);
	object_destroy (e2m5_terminal01screen);
	sleep (30 * 1);
	thread(f_music_e2m5_dogtag_playback_vo());
	thread (e2m5_tts_iff01playback());
	sleep (30 * 1);
	sleep_until (e2m5_narrative_is_on == FALSE);
	thread (e2m5_shutdown_01());
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end
	
script static void e2m5_afklolz()
	sleep (30 * 120);
	if	(e2m5_playersintheback == FALSE)	then
		thread (e2m5_takingtoolong01());
	else (sleep (30 * 1));
	end
end

//343++343==343++343==343++343//	E2M5 Goal 02 Scripts (1. object_destruction)	//343++343==343++343==343++343//	

script static void e2m5_shutdown_01()
	sleep_until (LevelEventStatus ("e2m5_shutdown01_start"), 1);
	sleep (30 * 1);
	b_wait_for_narrative_hud = FALSE;
	device_set_power (e2m5_maproom_l_switch, 1);
	device_set_power (e2m5_maproom_r_switch, 1);
	thread(f_music_e2m5_shutdown_01());
	thread (e2m5_switch01checker());
	thread (e2m5_switch02checker());
	thread (e2m5_firstenemies());
	thread (e2m5_dogtag2_goal());
	thread (e2m5_maproom_l_dmplay());
	thread (e2m5_maproom_r_dmplay());
	thread (e2m5_goal02_5_start());
	sleep (30 * 60);
	print ("switch check 01");
	if	(e2m5_switchesdown < 2)	then
		thread (e2m5_tts_hurryup01());
	end
	sleep (30 * 30);
	print ("switch check 02");
	if (e2m5_switchesdown < 2)	then
		thread (e2m5_tts_hurryup02());
	end
	//sleep_forever();
end

script static void e2m5_firstenemies
	sleep_until (e2m5_switchesdown == 1);
	thread(f_music_e2m5_firstenemies());
	sleep (30 * 3);
	ai_place (sq_e2m5_3paw_01);
	ai_place_in_limbo (sq_e2m5_1kni_01);
	sleep (30 * 2);
	thread (e2m5_tts_badguys01());
end

script static void e2m5_maproom_l_dmplay()
	sleep_until (device_get_position (e2m5_maproom_l_switch) > 0.0, 1);
	device_set_position ( e2m5_maproom_dm_l, 1);
	thread(f_music_e2m5_kill_switch01());
end

script static void e2m5_maproom_r_dmplay()
	sleep_until (device_get_position (e2m5_maproom_r_switch) > 0.0, 1);
	device_set_position ( e2m5_maproom_dm_r, 1);
	thread(f_music_e2m5_kill_switch02());
end

//	Switch Counter
script static void e2m5_switch01checker
	sleep_until (device_get_position (e2m5_maproom_l_switch) > 0.0, 1);
	e2m5_switchesdown = e2m5_switchesdown + 1;
	sleep (90);
	e2m5_maproom_dmswitch_l->SetDerezWhenActivated();
	print ("dm_left derezzing");
end

script static void e2m5_switch02checker
	sleep_until (device_get_position (e2m5_maproom_r_switch) > 0.0, 1);
	e2m5_switchesdown = e2m5_switchesdown + 1;
	sleep (90);
	e2m5_maproom_dmswitch_r->SetDerezWhenActivated();
	print ("dm_right derezzing");
end


//343++343==343++343==343++343//	E2M5 Goal 02.5 Scripts (2. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_goal02_5_start()
	sleep_until (LevelEventStatus ("e2m5_goal2_5_start"), 1);
	thread (e2m5_goal02_5_firstwave());
	thread (e2m5_2_5_endgoal());
	thread (e2m5_tts_2switcheson());
end

script static void e2m5_goal02_5_firstwave()
	sleep (30 * 3);
	thread(f_music_e2m5_goal03_firstwave());
	sleep_until (e2m5_narrative_is_on == FALSE);
	ai_place (sq_e2m5_3paw_02);
	ai_place (sq_e2m5_3paw_03);
	ai_place (sq_e2m5_4paw_01);
end

script static void e2m5_2_5_endgoal()
	sleep_until (LevelEventStatus ("e2m5_goal2_5_end"), 1);
	sleep_until (e2m5_whatssciencesay == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (e2m5_ff_all) <= 7, 1);
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M5 Goal 03 Scripts (3. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_dogtag2_goal()
	sleep_until (LevelEventStatus ("e2m5_dogtag2_goal_start"), 1);
	thread(f_music_e2m5_dogtag_goal_2_start());
	thread (e2m5_goal2_end());
	thread (e2m5_terminal02_playback());
	thread (e2m5_dogtag2_playback());
	thread (e2m5_goal03_firstwave());
	thread (e2m5_goal03_2ndgroup());
	thread (e2m5_goal03_3rdgroup());
	thread (e2m5_goal03_2paw01());
	thread (e2m5_goal03_1kni05());
	thread (e2m5_goal03_3paw05());
	thread (e2m5_goal03_3paw06());
	thread (e2m5_goal03_3paw07());
	thread (e2m5_goal03_3paw08());
	thread (e2m5_goal03_3paw14());
	thread (e2m5_goal03_3paw15());
	thread (e2m5_goal03_1kni07_2bish03());
	thread (e2m5_goal03_5_end());
	thread (e2m5_goal03_5_second());
	e2m5_leave_backroom = TRUE;
end

script static void e2m5_goal2_end()
	sleep_until (LevelEventStatus ("e2m5_findterminal02"), 1);
	sleep (30 * 1);
	thread (e2m5_tts_anothertag());
	sleep (30 * 2);
	sleep_until (e2m5_narrative_is_on == FALSE);
	sleep_until (device_get_position (e2m5_dogtag_02) > 0.0, 1);
	device_set_power (e2m5_dogtag_02, 0.0);
	f_unblip_flag (e2m5_fl_dogtag02);
	object_destroy (e2m5_dogtag_02);
	object_destroy (e2m5_terminal02screen);
	b_end_player_goal = TRUE;
end

script static void e2m5_goal03_firstwave
	sleep (30 * 3);
	thread(f_music_e2m5_goal03_firstwave());
	ai_place (sq_e2m5_3paw_12);
	ai_place_in_limbo (sq_e2m5_1kni_06);
	ai_place_with_birth (sq_e2m5_1bish_04);
	sleep (30 * 1);
	thread (e2m5_tts_enemycallout_01());
end

script static void e2m5_goal03_2ndgroup
	sleep_until (LevelEventStatus ("e2m5_goal03_2nd_enemies"), 1);
	thread(f_music_e2m5_goal03_2ndgroup());
	ai_place_in_limbo (sq_e2m5_1kni_02);
	ai_place_with_birth (sq_e2m5_3bish_01);
end

script static void e2m5_goal03_3rdgroup()
	sleep_until (LevelEventStatus ("e2m5_goal03_3rd_enemies"), 1);
	ai_place (sq_e2m5_3paw_13);
end



//343++343==343++343==343++343//	E2M5 Goal 03.5 Scripts (4. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_terminal02_playback()
	sleep_until (LevelEventStatus ("e2m5_termnial02playback"), 1);
	sleep (30 * 1);
	thread(f_music_e2m5_dogtag2_playback());
	thread (e2m5_tts_iff02());
	sleep (30 * 2);
	sleep_until (e2m5_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E2M5 Goal 03.5(2) Scripts (5. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_dogtag2_playback()
	sleep_until (LevelEventStatus ("e2m5_iff2playback"), 1);
	ai_set_task (sq_e2m5_1bish_01, obj_e2m5_bish_ext, bish_ext);
	ai_set_task (sq_e2m5_1kni_01, obj_e2m5_knight_ext, hall_exit_defend);
	ai_set_task (sq_e2m5_3paw_01, obj_e2m5_paw_ext, main_ext_defend);
	ai_set_task (sq_e2m5_3paw_02, obj_e2m5_paw_ext, main_ext_defend);
	ai_set_task (sq_e2m5_3paw_03, obj_e2m5_paw_ext, main_ext_defend);
	ai_set_task (sq_e2m5_4paw_01, obj_e2m5_paw_ext, main_ext_defend);
	sleep_until (e2m5_narrative_is_on == FALSE);
	thread (e2m5_goal04_kill_switch());
	thread (e2m5_goal04_1switchdefenders());
	sleep (30 * 2);
end

script static void e2m5_goal03_2paw01()
	sleep_until (LevelEventStatus ("e2m5_2paw01"), 1);
	ai_place (sq_e2m5_2paw_01);
	thread(f_music_e2m5_goal03_2paw01());
	sleep (30 * 3);
	thread (e2m5_tts_badguys02());
end

script static void e2m5_goal03_1kni05()
	sleep_until (LevelEventStatus ("e2m5_1kni05"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_05);
	thread(f_music_e2m5_goal03_1kni05());
end

script static void e2m5_goal03_3paw05()
	sleep_until (LevelEventStatus ("e2m5_3paw05"), 1);
	ai_place (sq_e2m5_3paw_05);
	thread(f_music_e2m5_goal03_3paw05());
end

script static void e2m5_goal03_3paw06()
	sleep_until (LevelEventStatus ("e2m5_3paw06"), 1);
	ai_place (sq_e2m5_3paw_06);
	thread(f_music_e2m5_goal03_3paw06());
end

script static void e2m5_goal03_3paw07()
	sleep_until (LevelEventStatus ("e2m5_3paw07"), 1);
	ai_place (sq_e2m5_3paw_07);
	thread(f_music_e2m5_goal03_3paw07());
end

script static void e2m5_goal03_3paw08()
	sleep_until (LevelEventStatus ("e2m5_3paw08"), 1);
	ai_place (sq_e2m5_3paw_08);
	thread(f_music_e2m5_goal03_3paw08());
end

script static void e2m5_goal03_3paw14()
	sleep_until (LevelEventStatus ("e2m5_3paw14"), 1);
	ai_place (sq_e2m5_3paw_14);
end

script static void e2m5_goal03_1kni07_2bish03()
	sleep_until (LevelEventStatus ("e2m5_1kni2bish_spawn"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_07);
	ai_place_with_birth (sq_e2m5_2bish_03);
end

script static void e2m5_goal03_3paw15()
	sleep_until (LevelEventStatus ("e2m5_3paw15"), 1);
	ai_place (sq_e2m5_3paw_15);
end

script static void e2m5_goal03_5_end()
	sleep_until (LevelEventStatus ("e2m5_goal03_5_end"), 1);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M5 Goal 03.5(3) Scripts (6. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_goal03_5_second()
	thread (e2m5_2kni01_spawn());
	thread (e2m5_5paw01_spawn());
	thread (e2m5_1kni08_spawn());
	thread (e2m5_3paw16_spawn());
	thread (e2m5_otherthancrimson());
end

script static void e2m5_2kni01_spawn()
	sleep_until (LevelEventStatus ("e2m5_2kni01_spawn"), 1);
	ai_place_in_limbo (sq_e2m5_2kni_01);
end

script static void e2m5_5paw01_spawn()
	sleep_until (LevelEventStatus ("e2m5_5paw01_spawn"), 1);
	ai_place (sq_e2m5_5paw_01);
end

script static void e2m5_1kni08_spawn()
	sleep_until (LevelEventStatus ("e2m5_1kni08_spawn"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_08);
	ai_place_with_birth (sq_e2m5_1bish_05);
end

script static void e2m5_3paw16_spawn()
	sleep_until (LevelEventStatus ("e2m5_3paw16_spawn"), 1);
	ai_place (sq_e2m5_3paw_16);
end

script static void e2m5_otherthancrimson()
	sleep_until (LevelEventStatus ("e2m5_otherthancrimson"), 1);
	sleep (30 * 1);
	thread (e2m5_tts_anythingelse());
	sleep (30 * 2);
	sleep_until (e2m5_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M5 Goal 04 Scripts (7. object_destruction)	//343++343==343++343==343++343//	

script static void e2m5_goal04_kill_switch
	sleep_until (LevelEventStatus ("e2m5_singleswitch"), 1);
	b_wait_for_narrative_hud = TRUE;
	sleep (30);
	b_wait_for_narrative_hud = FALSE;
	device_set_power (e2m5_rockroom_switch, 1);
	thread (e2m5_goal05_start());
	thread (e2m5_rockroom_dmplay());
	f_new_objective (e2m5_shutdown1);
end
	
script static void e2m5_rockroom_dmplay()
	sleep_until (device_get_position (e2m5_rockroom_switch) > 0.0, 1);
	device_set_position ( e2m5_rockroom_dm, 1);
	thread(f_music_e2m5_goal04_kill_switch());
	sleep (30 * 3);
	thread (e2m5_tts_nicework());
end	
	
script static void e2m5_goal04_1switchdefenders
	sleep_until (LevelEventStatus ("e2m5_goal04_defenders"), 1);
	sleep (30 * 4);
	ai_place_in_limbo (sq_e2m5_1kni_03);
	ai_place (sq_e2m5_3paw_04);
end


//343++343==343++343==343++343//	E2M5 Goal 05 Scripts (8. time_passed)	//343++343==343++343==343++343//

script static void e2m5_goal05_start
	sleep_until (LevelEventStatus ("e2m5_goal05_starting"), 1);
	e2m5_rockroom_switchdm->SetDerezWhenActivated();
	thread(f_music_e2m5_goal05_start());
	thread (e2m5_goal05_3paw09());
	thread (e2m5_goal05_3paw10());
	thread (e2m5_goal05_3paw11());
	thread (e2m5_goal05_4paw03());
	thread (e2m5_goal05_1kni08());
	thread (e2m5_goal05_3paw17());
	thread (e2m5_shutdown_04sources());
	thread (e2m5_goal04_2paw02());
	thread (e2m5_goal04_2paw03());
	thread (e2m5_goal04_2paw04());
	thread (e2m5_goal06_4kni_2bish());
	thread (e2m5_kill_switch03());
	thread (e2m5_kill_switch04());
	thread (e2m5_kill_switch05());
	thread (e2m5_kill_switch06());
	thread (e2m5_goal05_end());
	e2m5_leavebackroom = TRUE;
	ai_set_task (sq_e2m5_1kni_03, obj_e2m5_knight_ext, int_1kni03_fallback);
	ai_set_task (sq_e2m5_1kni_03, obj_e2m5_paw_ext, int_3paw04_fallback);
end

script static void e2m5_goal05_3paw09()
	sleep_until (LevelEventStatus ("e2m5_3paw09"), 1);
	ai_place (sq_e2m5_3paw_09);
	thread(f_music_e2m5_goal05_3paw09());
	thread (e2m5_tts_moreenemiescallout());
end

script static void e2m5_goal05_3paw10()
	sleep_until (LevelEventStatus ("e2m5_3paw10"), 1);
	ai_place (sq_e2m5_3paw_10);
	thread(f_music_e2m5_goal05_3paw10());
end

script static void e2m5_goal05_3paw11()
	sleep_until (LevelEventStatus ("e2m5_3paw11"), 1);
	ai_place (sq_e2m5_3paw_11);
	thread(f_music_e2m5_goal05_3paw11());
end

script static void e2m5_goal05_4paw03()
	sleep_until (LevelEventStatus ("e2m5_4paw03"), 1);
	ai_place (sq_e2m5_4paw_03);
end

script static void e2m5_goal05_1kni08()
	sleep_until (LevelEventStatus ("e2m5_1kni08"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_08);
end

script static void e2m5_goal05_3paw17()
	sleep_until (LevelEventStatus ("e2m5_3paw17"), 1);
	ai_place (sq_e2m5_3paw_17);
	ai_place (sq_e2m5_3paw_18);
	f_blip_ai_cui (e2m5_ff_all, "navpoint_enemy");
end

script static void e2m5_goal05_end()
	sleep_until (LevelEventStatus ("e2m5_goal05_end"), 1);
	thread(f_music_e2m5_second_switch_hit_vo());
	thread (e2m5_tts_iff03seen());
	sleep (30 * 1);
	sleep_until (e2m5_narrative_is_on == FALSE);
	sleep_until (device_get_position (e2m5_dogtag_03) > 0.0, 1);
	thread(f_music_e2m5_dogtag_2_obtained());
	device_set_power (e2m5_dogtag_03, 0.0);
	f_unblip_flag (e2m5_fl_dogtag03);
	object_destroy (e2m5_dogtag_03);
	object_destroy (e2m5_terminal03screen);
	sleep (30 * 1);
	thread (f_music_e2m5_dogtag_2_obtained_vo());
	thread (e2m5_tts_iff03());
	f_objective_complete();
	sleep (30 * 2);
	sleep_until (e2m5_narrative_is_on == FALSE);
	thread (e2m5_tts_switchesping02());
	sleep (30 * 2);
	sleep_until (e2m5_narrative_is_on == FALSE);
	object_cannot_take_damage (e2m5_rvb);
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M5 Goal 06 Scripts (9. object_destruction)	//343++343==343++343==343++343//	

script static void e2m5_shutdown_04sources
	sleep_until (LevelEventStatus ("e2m5_4sources_start"), 1);
	thread(f_music_e2m5_shutdown_04sources());
	b_wait_for_narrative_hud = TRUE;
	sleep (30);
	b_wait_for_narrative_hud = FALSE;
	device_set_power (e2m5_bridge_switch04, 1);
	device_set_power (e2m5_bridge_switch03, 1);
	device_set_power (e2m5_bridge_switch01, 1);
	device_set_power (e2m5_bridge_switch02, 1);
	thread (e2m5_evac_coming());
	thread (e2m5_bridgeswitch_counter());
end

script static void e2m5_goal04_2paw02
	sleep_until (LevelEventStatus ("e2m5_2paw02"), 1);
	sleep (30 * 3);
	ai_place (sq_e2m5_2paw_02);
	thread(f_music_e2m5_goal04_2paw02());
end

script static void e2m5_goal04_2paw03
	sleep_until (LevelEventStatus ("e2m5_2paw03"), 1);
	ai_place (sq_e2m5_2paw_03);
	thread(f_music_e2m5_goal04_2paw03());
end

script static void e2m5_goal04_2paw04
	sleep_until (LevelEventStatus ("e2m5_2paw04"), 1);
	sleep (30 * 1);
	ai_place (sq_e2m5_2paw_04);
	thread(f_music_e2m5_goal04_2paw04());
end

script static void e2m5_goal06_4kni_2bish
	sleep_until (LevelEventStatus ("e2m5_goal06_4knights"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_10);
	ai_place_in_limbo (sq_e2m5_1kni_11);
	ai_place_in_limbo (sq_e2m5_1kni_12);
	ai_place_in_limbo (sq_e2m5_1kni_13);
	ai_place_with_birth (sq_e2m5_2bish_01);
	thread(f_music_e2m5_goal06_4kni_2bish());
end

script static void e2m5_kill_switch03
	sleep_until (LevelEventStatus ("e2m5_4sources_start"), 1);
	sleep (30 * 2);
	sleep_until (device_get_position (e2m5_bridge_switch04) > 0.0, 1);
	device_set_power (e2m5_bridge_switch04, 0.0);
	thread(f_music_e2m5_kill_switch03());
	e2m5_bridge_dmswitch04->SetDerezWhenActivated();
	e2m5_4bridgeswitches_hit = e2m5_4bridgeswitches_hit + 1;
end

script static void e2m5_kill_switch04
	sleep_until (LevelEventStatus ("e2m5_4sources_start"), 1);
	sleep (30 * 2);
	sleep_until (device_get_position (e2m5_bridge_switch03) > 0.0, 1);
	device_set_power (e2m5_bridge_switch03, 0.0);
	thread(f_music_e2m5_kill_switch04());
	e2m5_bridge_dmswitch03->SetDerezWhenActivated();
	e2m5_4bridgeswitches_hit = e2m5_4bridgeswitches_hit + 1;
end

script static void e2m5_kill_switch05
	sleep_until (LevelEventStatus ("e2m5_4sources_start"), 1);
	sleep (30 * 2);
	sleep_until (device_get_position (e2m5_bridge_switch01) > 0.0, 1);
	device_set_power (e2m5_bridge_switch01, 0.0);
	thread(f_music_e2m5_kill_switch05());
	e2m5_bridge_dmswitch01->SetDerezWhenActivated();
	e2m5_4bridgeswitches_hit = e2m5_4bridgeswitches_hit + 1;
end

script static void e2m5_kill_switch06
	sleep_until (LevelEventStatus ("e2m5_4sources_start"), 1);
	sleep (30 * 2);
	sleep_until (device_get_position (e2m5_bridge_switch02) > 0.0, 1);
	device_set_power (e2m5_bridge_switch02, 0.0);
	thread(f_music_e2m5_kill_switch06());
	e2m5_bridge_dmswitch02->SetDerezWhenActivated();
	e2m5_4bridgeswitches_hit = e2m5_4bridgeswitches_hit + 1;
end

script static void e2m5_bridgeswitch_counter()
	sleep_until (e2m5_4bridgeswitches_hit == 2, 1);
	thread (e2m5_tts_almostthere());
end
//343++343==343++343==343++343//	E2M5 Goal 07 Scripts (10. no_more_waves)	//343++343==343++343==343++343//	

script static void e2m5_evac_coming()
	sleep_until (LevelEventStatus ("e2m5_evac"), 1);
	thread(f_music_e2m5_evac_coming());
	e2m5_followtime = TRUE;
	thread (e2m5_goal07_firstwave());
	thread (e2m5_goal07_4paw2bish());
	thread (e2m5_goal07_3knights());
	thread (e2m5_goal07_finalwave());
	thread (e2m5_lz());
	sleep (30 * 2);
	thread (e2m5_tts_clearallenemies());
end

script static void e2m5_goal07_firstwave
	sleep_until (LevelEventStatus ("e2m5_goal07_10paw"), 1);
	ai_place (sq_e2m5_2paw_05);
	ai_place (sq_e2m5_2paw_06);
	ai_place (sq_e2m5_2paw_07);
	ai_place (sq_e2m5_2paw_08);
	ai_place (sq_e2m5_2paw_09);
	thread(f_music_e2m5_goal07_firstwave());
end

script static void e2m5_goal07_4paw2bish
	sleep_until (LevelEventStatus ("e2m5_goal07_4paw2bish"), 1);
	ai_place (sq_e2m5_4paw_02);
	thread(f_music_e2m5_goal07_4paw2bish());
end

script static void e2m5_goal07_3knights
	sleep_until (LevelEventStatus ("3knights_spawn"), 1);
	ai_place_in_limbo (sq_e2m5_3kni_01);
	ai_place_with_birth (sq_e2m5_2bish_02);
	thread(f_music_e2m5_goal07_3knights());
end

script static void e2m5_goal07_finalwave
	sleep_until (LevelEventStatus ("e2m5_goal07_junglewave"), 1);
	ai_place_in_limbo (sq_e2m5_1kni_04);
	sleep (30 * 3);
	//ai_place (sq_e2m5_1bish_03);
	sleep (30 * 3);
	ai_place (sq_e2m5_10paw_02);
	thread(f_music_e2m5_goal07_finalwave());
	sleep (30 * 1);
	thread (e2m5_tts_lastenemiescallout());
end

//343++343==343++343==343++343//	E2M5 Goal 08 Scripts (11. location_arrival)	//343++343==343++343==343++343//	

script static void e2m5_lz
	sleep_until (LevelEventStatus ("e2m5_lz_start"), 1);
	b_wait_for_narrative_hud = TRUE;
	thread (f_music_e2m5_lz());
	thread (e2m5_end());
	sleep (30 * 1);
	thread (f_music_e2m5_get_to_lz_vo());
	thread (e2m5_tts_gettolz());
end

//343++343==343++343==343++343//	E2M5 Goal 09 Scripts (12. time_passed)	//343++343==343++343==343++343//	

script static void e2m5_end
	sleep_until (LevelEventStatus ("e2m5_end"), 1);
	sleep_until (e2m5_narrative_is_on == FALSE);
	print ("Starting zoneset switch");
	prepare_to_switch_to_zone_set(e2m5_end);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e2m5_end);	
	// play outro
	fade_out (0, 0, 0, 15);
	print ("Switching zone set");
	print ("Zone set switched");
	sleep (30);
	e2m5_narrativeout_done = FALSE;
	f_hide_players_outro();
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m5_vin_sfx_outro', NONE, 1);
	cinematic_start();
	thread (f_music_e2m5_end_vo());
	pup_play_show (e2m5_narrative_out);
	thread (e2m5_tts_out());             
	print ("DONE!");
	sleep (30 * 2);
	sleep_until (e2m5_narrativeout_done == TRUE, 1);
	sleep_until (e2m5_narrative_is_on == FALSE, 1);
	cinematic_stop();
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
	sleep (30 * 3);
	thread (f_music_e2m5_finish());
	b_end_player_goal = TRUE;
end

//	hide all HUD and remove player input for the outro
script static void f_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	if game_coop_player_count() == 4 then
		object_hide (player0, true);
		object_hide (player1, true);
		object_hide (player2, true);
		object_hide (player3, true);
	elseif game_coop_player_count() == 3 then
		object_hide (player0, true);
		object_hide (player1, true);
		object_hide (player2, true);
	elseif game_coop_player_count() == 2 then
		object_hide (player0, true);
		object_hide (player1, true);
	else
		object_hide (player0, true);
	end
end


//343++343==343++343==343++343//	E2M5 Misc Scripts	//343++343==343++343==343++343//	

//	e2m5 Forerunner Spawn Scripts

script command_script cs_e2m5_knights_phasein
	cs_phase_in();
end

script command_script cs_e2m5_pawn_spawn
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e2m5_bishop_spawn()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e2m5_OnCompleteBishopBirth, 0);
	sleep (30 * 30);
	if (ai_in_limbo_count (ai_current_actor) > 0)	then
		ai_erase (ai_current_actor);
		else (sleep (30 * 1));
	end
end 

script static void e2m5_OnCompleteBishopBirth()
	print ("Bishop spawned");
end

script command_script cs_e2m5_pawn_birth
	print("pawn sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), e2m5_OnCompleteProtoSpawn, 1.5);
	if (ai_in_limbo_count (ai_current_actor) > 0)	then
		ai_erase (ai_current_actor);
		else (sleep (30 * 1));
	end
end

script static void e2m5_OnCompleteProtoSpawn()
	print ("Pawn Birthed");
end

//Turn Off Switch Powers
script static void e2m5_turnoffpower()
	device_set_power (e2m5_maproom_l_switch, 0);
	device_set_power (e2m5_maproom_r_switch, 0);
	device_set_power (e2m5_bridge_switch04, 0);
	device_set_power (e2m5_bridge_switch03, 0);
	device_set_power (e2m5_bridge_switch01, 0);
	device_set_power (e2m5_bridge_switch02, 0);
	device_set_power (e2m5_rockroom_switch, 0);
	device_set_power (e2m5_dogtag_01, 0);
	device_set_power (e2m5_dogtag_02, 0);
	device_set_power (e2m5_dogtag_03, 0);
end



script static void e2m5_objcomplete_threaded()
	f_objective_complete();
end

script static void e2m5_obj_gettoiff_threaded()
	f_new_objective (e2m5_gettoiff);
end

script static void e2m5_obj_shutdown2_threaded()
	f_new_objective (e2m5_shutdown1);
end

script static void e2m5_obj_lz_threaded()
	f_new_objective (e2m5_lz);
end