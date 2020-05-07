//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 04: Mission 05																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//

//343++343==343++343==343++343//	E4M5 Globals	//343++343==343++343==343++343//
global boolean e4m5_goal01startingenemies = FALSE;
global boolean e4m5_phan01dropoff01 = FALSE;
global boolean e4m5_phan02dropoff02 = FALSE;
global boolean e4m5_phan03dropoff03 = FALSE;
global boolean forerunners_have_arrived = FALSE;
global boolean e4m5_reactor_powered = FALSE;
global boolean e4m5_timetofollow = FALSE;
global boolean e4m5_fore_timetofollow = FALSE;
global boolean e4m5_hunters_deployed = FALSE;
global boolean e4m5_narrativein_done = FALSE;
global boolean e4m5_narrativeout_done = FALSE;
global boolean e4m5_allphantomsdeadnow = FALSE;


//343++343==343++343==343++343//	E4M5 Startup (variant) Script	//343++343==343++343==343++343//

script startup e4m5_variant
	sleep_until (LevelEventStatus ("e4m5_var_startup"), 1);
	thread (f_music_e4m5_start());
	ai_ff_all = e4m5_ff_all;
	print ("e2m5 variant started");
	switch_zone_set (e4_m5_holdout_00);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	e4m5_narrativein_done = FALSE;
	e4m5_narrativeout_done = FALSE;
	//	add "Devices" folders
		f_add_crate_folder (e4m5_spawners);															//	Spawners for E4M5
		f_add_crate_folder (e4m5_dm);
		f_add_crate_folder (e4m5_touchscreens);
	//	add "Vehicles" folders
		f_add_crate_folder (e4m5_veh_unsc);															//	UNSC Vehicles for E4M5
		f_add_crate_folder (e4m5_veh_cov);															//	Cov Vehicles for E4M5
		f_add_crate_folder (e4m5_turrets);															//	Turrets for E4M5
	//	add "Crates" folders
		f_add_crate_folder (e4m5_barriers);															//	Barrier Crates for E4M5
		f_add_crate_folder (e4m5_props);																//	Prop Crates for E4M5
		f_add_crate_folder (e4m5_weaponcrates);													//	Weapon Racks and Crates for E4M5
	//	add "Scenery" folders
		firefight_mode_set_crate_folder_at(e4m5_spawnpoints_01, 50);		//	Initial Spawn Area for E4M5	
		firefight_mode_set_crate_folder_at(e4m5_spawnpoints_02, 49);		//	2nd Spawn Area for E4M5	
	//	add "Items" folders
	//	add "Enemy Squad" Templates
	//	add "Objectives"
		firefight_mode_set_objective_name_at(e4m5_touchscreen01, 30); 				//	Objective Switch In Main Building for E4M5
		firefight_mode_set_objective_name_at(e4m5_touchscreen02, 31); 				//	Objective Switch In Back Building for E4M5
	//	add "LZ" areas
	f_create_new_spawn_folder (50);
	firefight_mode_set_player_spawn_suppressed(TRUE);
	object_cannot_take_damage (e4m5_base_defense_01);
	object_cannot_take_damage (e4m5_base_defense_02);
	object_cannot_take_damage (e4m5_base_defense_03);
	object_cannot_take_damage (e4m5_base_defense_04);
	if editor_mode() then
		print("editor mode, not playing intro");
		e4m5_narrativein_done = TRUE;
		prepare_to_switch_to_zone_set(E4M5_holdout_01);
		sleep_until(not PreparingToSwitchZoneSet(), 1);
		switch_zone_set (E4M5_holdout_01);
		firefight_mode_set_player_spawn_suppressed(FALSE);
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		thread (e4m5_firstenemies());
		sleep_s (0.5);
		fade_in (0,0,0,15);
		sleep (30 * 10);
		b_end_player_goal = TRUE;
	else
		sleep_until (LevelEventStatus ("loadout_screen_complete"), 1);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e4m5_vin_sfx_intro', NONE, 1);
		cinematic_start();
		thread (e4_m5_pup_intro());
		thread (vo_e4m5_intro());
		sleep_until (e4m5_narrativein_done == TRUE);
		cinematic_stop();
		prepare_to_switch_to_zone_set(E4M5_holdout_01);
		sleep_until(not PreparingToSwitchZoneSet(), 1);
		switch_zone_set (E4M5_holdout_01);
		firefight_mode_set_player_spawn_suppressed(FALSE);
		sleep_until (b_players_are_alive(), 1);
		thread (e4m5_firstenemies());
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
		sleep (30 * 1);
		b_end_player_goal = TRUE;
	end
end


//343++343==343++343==343++343//	E4M5 "Clear all Cov" Goal Script (1. no_more_waves)	//343++343==343++343==343++343//

script static void e4m5_firstenemies()
	print ("Placing first set of enemies");
	ai_place (sq_e4m5_1ghost_01);
	ai_place (sq_e4m5_phantom_01);
	ai_place (sq_e4m5_fluffphantom_01);
	ai_place (sq_e4m5_fluffphantom_02);
	ai_place (sq_e4m5_fluffphantom_03);
	//ai_place (sq_e4m5_phantom_05);
	//ai_place (sq_e4m5_marines_01);
	//ai_place (sq_e4m5_marines_02);
	print ("First set of enemies placed");
	thread (e4m5_phantom02spawn());
	thread (e4m5_phantom03spawn());
	thread (e4m5_phantom04spawn());
	thread (e4m5_vo_waitasec());
	thread (e4m5_phantom06spawn());
	thread (vo_e4m5_eggheads());
	thread (e4m5_phantom07spawn());
	thread (e4m5_phantom08spawn());
	thread (e4m5_phantom09spawn());
	thread (e4m5_turnaaon_narrative());
	thread (e4m5_weaponcrates_respawn());
	f_new_objective (e4m5_obj_stopcov01);
	thread (f_music_e4m5_firstenemies());
	sleep_until (b_players_are_alive(), 1);
	sleep (30 * 2);
	thread (e4m5_callout_01());
end

script static void e4m5_phantom02spawn()
	sleep_until (LevelEventStatus ("spawnphantom02"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_02);
	thread (vo_e4m5_phantoms01());
	thread (f_music_e4m5_phantom02spawn());
end

script static void e4m5_phantom03spawn()
	sleep_until (LevelEventStatus ("spawnphantom03"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_03);
	thread (vo_e4m5_phantoms02());
	thread (f_music_e4m5_phantom03spawn());
end

script static void e4m5_phantom04spawn()
	sleep_until (LevelEventStatus ("spawnphantom04"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_04);
	thread (vo_e4m5_phantoms07());
	thread (f_music_e4m5_phantom04spawn());
end

script static void e4m5_vo_waitasec()
	sleep_until (LevelEventStatus ("e4m5_waitasec"), 1);
	print ("phantom 6 incoming");
end

script static void e4m5_phantom06spawn()
	sleep_until (LevelEventStatus ("spawnphantom06"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_06);
	thread (vo_e4m5_phantoms03());
	thread (f_music_e4m5_phantom06spawn());
end

script static void vo_e4m5_eggheads()
	sleep_until (LevelEventStatus ("e4m5_eggheads"), 1);
	print ("phantom 07 incoming");
end

script static void e4m5_phantom07spawn()
	sleep_until (LevelEventStatus ("spawnphantom07"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_07);
	thread (vo_e4m5_phantoms04());
	thread (f_music_e4m5_phantom07spawn());
end

script static void e4m5_phantom08spawn()
	sleep_until (LevelEventStatus ("spawnphantom08"), 1);
	ai_place (sq_e4m5_1ghost_02);
	ai_place_in_limbo (sq_e4m5_phantom_08);
	sleep (30 * 3);
	thread (vo_e4m5_phantoms05());
	thread (f_music_e4m5_phantom08spawn());
end

script static void e4m5_phantom09spawn()
	sleep_until (LevelEventStatus ("spawnphantom09"), 1);
	ai_place_in_limbo (sq_e4m5_phantom_09);
	thread (f_music_e4m5_phantom09spawn());
	thread (vo_e4m5_phantoms06());
end

//343++343==343++343==343++343//	E4M5 "AA's are off - Narrative" Goal Script (2. time_passed)	//343++343==343++343==343++343//

script static void e4m5_turnaaon_narrative
	sleep_until (LevelEventStatus ("e4m5_switch01goal_narr"), 1);
	thread (e4m5_turnaaon_objective());
	thread (f_music_e4m5_turnaaon_narrative());
	thread (vo_e4m5_gotoswitch());
	thread (f_music_e4m5_turnaaon_narrative_title());
	e4m5_timetofollow = TRUE;
	sleep (30 * 2);
	sleep_until (e4m5_narrative_is_on == FALSE);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E4M5 "AA's are off - Objective" Goal Script (3. time_passed)	//343++343==343++343==343++343//

script static void e4m5_turnaaon_objective()
	sleep_until (LevelEventStatus ("e4m5_switch01goal_obj"), 1);
	b_wait_for_narrative_hud = TRUE;
	thread (vo_e4m5_seeswitch());
	thread (e4m5_goal03_narrative());
	sleep (30 * 2);
	sleep_until (e4m5_narrative_is_on == FALSE);
	device_set_power (e4m5_touchscreen01, 1);
	sleep (5);
	thread (e4m5_switch01_kill());
	navpoint_track_flag_named (fl_e4m5_screenblip01, "navpoint_activate");
	f_new_objective (e4m5_obj_turnonaa);
	thread (f_music_e4m5_turnaaon_objective());
end

script static void e4m5_switch01_kill()
	sleep_until (device_get_position (e4m5_touchscreen01) > 0.0, 1);
	device_set_power (e4m5_touchscreen01, 0.0);
	sleep (15);
	object_destroy (e4m5_touchscreen01);
	object_destroy (e4m5_terminalscreen01);
	navpoint_track_flag (fl_e4m5_screenblip01, FALSE);
	thread (f_music_e4m5_switch01_kill());
	sleep_until (e4m5_narrative_is_on == FALSE);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E4M5 "Clear Remaining Cov/Turn AA's Off - Narrative" Goal Script (4. time_passed)	//343++343==343++343==343++343//

script static void e4m5_goal03_narrative()
	sleep_until (LevelEventStatus ("e4m5_aaison"), 1);
	thread (f_music_e4m5_goal03_narrative());
	thread (e4m5_make_turrets_dumb());
	thread (e4m5_killthesephantoms());
	f_objective_complete();
	thread (e4m5_switch02_start());
	thread (f_music_e4m5_turrets_are_on_title());
	sleep (30 * 3);
		if (ai_living_count (e4m5_ff_all) > 0)	then
			sleep (30 * 1);
			thread (vo_e4m5_turretsup());
			f_new_objective (e4m5_obj_finishoffenemies);
			sleep_until (e4m5_allphantomsdeadnow == TRUE);
			sleep_until (ai_living_count (e4m5_ff_all) == 0);
			f_objective_complete();
			sleep (30 * 3);
			prepare_to_switch_to_zone_set(E4M5_holdout_02);
			sleep_until(not PreparingToSwitchZoneSet(), 1);
			switch_zone_set (E4M5_holdout_02);
			sleep (30 * 2);
			thread (vo_e4m5_anaside());
			sleep (30 * 3);
			sleep_until (e4m5_narrative_is_on == FALSE);
			sleep (30 * 2);
			thread (f_music_e4m5_turn_turrets_off());
			b_end_player_goal = TRUE;
		else
			sleep (30 * 1);
			thread (vo_e4m5_turretsup());
			sleep_until (e4m5_allphantomsdeadnow == TRUE);
			sleep (30 * 2);
			prepare_to_switch_to_zone_set(E4M5_holdout_02);
			sleep_until(not PreparingToSwitchZoneSet(), 1);
			switch_zone_set (E4M5_holdout_02);
			sleep (30 * 2);
			thread (vo_e4m5_anaside());
			sleep (30 * 3);
			sleep_until (e4m5_narrative_is_on == FALSE);
			sleep (30 * 2);
			thread (f_music_e4m5_turn_turrets_off());
			b_end_player_goal = TRUE;
		end
end

script static void e4m5_make_turrets_dumb
	ai_place (sq_e4m5_nullturrets_01);
	sleep (2);
	ai_cannot_die (sq_e4m5_nullturrets_01, TRUE);
	sleep_until (LevelEventStatus ("e4m5_forerunner_start"), 1);
	ai_braindead (sq_e4m5_nullturrets_01, TRUE);
	ai_kill (sq_e4m5_nullturrets_01);
end

script static void e4m5_killthesephantoms()
	f_blip_ai_cui (e4m5_ff_all, "navpoint_enemy");
	sleep (30 * 1);
	ai_place_in_limbo (sq_e4m5_phantom_10);
	ai_place_in_limbo (sq_e4m5_phantom_11);
	sleep (30 * 1);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_10.driver), .25);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_11.driver), .25);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_10.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_10, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_10) == 0);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_11.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_11, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_11) == 0);
	sleep (30 * 1);
	ai_place_in_limbo (sq_e4m5_phantom_12);
	ai_place_in_limbo (sq_e4m5_phantom_13);
	sleep (30 * 1);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_12.driver), .25);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_13.driver), .25);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_12.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_12, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_12) == 0);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_13.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_13, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_13) == 0);
	sleep (30 * 1);
	ai_place_in_limbo (sq_e4m5_phantom_14);
	ai_place_in_limbo (sq_e4m5_phantom_15);
	sleep (30 * 1);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_14.driver), .25);
	object_set_health (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_15.driver), .25);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_14.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_14, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_14) == 0);
	ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point (sq_e4m5_phantom_15.driver), 1);
	ai_prefer_target_ai (sq_e4m5_nullturrets_01, sq_e4m5_phantom_15, TRUE);
	sleep_until (ai_living_count (sq_e4m5_phantom_15) == 0);
	sleep (15);
	e4m5_allphantomsdeadnow = TRUE;
	sleep (30 * 1);
end
//343++343==343++343==343++343//	E4M5 "Turn Off AAs" Goal Script (5. time_passed)	//343++343==343++343==343++343//

script static void e4m5_switch02_start()
	sleep_until (LevelEventStatus ("e4m5_switch02"), 1);
	thread (e4m5_kill_switch02());
	thread (f_music_e4m5_switch02_start());
	thread (e4m5_countdown());
	thread (e4m5_forerunner_start());
	f_new_objective(e4m5_obj_turnoffaa);
	sleep_until (volume_test_players (tv_e4m5_switcharea), 1);
	ai_place_in_limbo (sq_e4m5_1kni_01);
	ai_place (sq_e4m5_3paw_01);
	ai_place (sq_e4m5_3paw_02);
	sleep (30 * 2);
	thread (f_music_e4m5_promethians_title());
	thread (vo_e4m5_enterroom());
end

script static void e4m5_kill_switch02()
	device_set_power (e4m5_touchscreen02, 1);
	sleep (5);
	navpoint_track_flag_named (fl_e4m5_screenblip02, "navpoint_activate");
	sleep_until (device_get_position (e4m5_touchscreen02) > 0.0, 1);
	thread (f_music_e4m5_reactor_switch_activated());
	e4m5_reactor_powered = TRUE;
	device_set_power (e4m5_touchscreen02, 0.0);
	sleep (15);
	object_destroy (e4m5_touchscreen02);
	navpoint_track_flag (fl_e4m5_screenblip02, FALSE);
	object_destroy (e4m5_terminalscreen02);
	sleep_until (e4m5_narrative_is_on == FALSE);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end


script static void e4m5_countdown()
	thread (f_music_e4m5_countdown_1());
	sleep (30 * 45);
	//	It takes 45 seconds to hit switch
		if (e4m5_reactor_powered == FALSE)	then
			thread (vo_e4m5_hurryup());
			else (sleep_forever());
		end
	thread (f_music_e4m5_countdown_2());
	sleep (30 * 75);
	//	It takes 2:00 to hit switch
		if (e4m5_reactor_powered == FALSE)	then
			thread (vo_e4m5_almostdead());
			else (sleep_forever());
		end
	thread (f_music_e4m5_countdown_3());
	sleep (30 * 120);
	//	FAILED - Takes 4 minutes to hit switch.
		if (e4m5_reactor_powered == FALSE)	then
			thread (f_music_e4m5_reactor_death());
			thread (vo_e4m5_toolate());
			firefight_mode_set_player_spawn_suppressed(TRUE);
			firefight_mode_lives_set (0);
			sleep (30 * 4);
			camera_shake_all_coop_players (10, 2, 1, 1);
			fade_out (255, 255, 255, 3);
			unit_set_current_vitality (player0, 0, 0);
			unit_set_current_vitality (player1, 0, 0);
			unit_set_current_vitality (player2, 0, 0);
			unit_set_current_vitality (player3, 0, 0);
			unit_set_maximum_vitality (player0, 0, 0);
			unit_set_maximum_vitality (player1, 0, 0);
			unit_set_maximum_vitality (player2, 0, 0);
			unit_set_maximum_vitality (player3, 0, 0);
			volume_teleport_players_not_inside (tv_e4m5_safe_zone, fl_e4m5_deathflag);
			sleep (30 * 3);
			player_disable_movement (FALSE);
			fade_out (0, 0, 0, 3);
			sleep (30 * 3);
			b_game_lost = TRUE;
			else (sleep_forever());
		end
end
	

//343++343==343++343==343++343//	E4M5 "Clear all Forerunner" Goal Script (6. no_more_waves)	//343++343==343++343==343++343//

script static void e4m5_forerunner_start()
	sleep_until (LevelEventStatus ("e4m5_forerunner_start"), 1);
	thread (f_music_e4m5_forerunner_start());
	thread (e4m5_fore_clearing());
	thread (e4m5_fore_yard());
	thread (e4m5_fore_mainbldgbot());
	thread (e4m5_fore_mainbldgtop());
	thread (e4m5_fore_vehiclebay());
	thread (e4m5_fore_clearing02());
	thread (e4m5_endmission_start());
	forerunners_have_arrived = TRUE;
	f_objective_complete();
	sleep (30 * 2);
	thread (f_music_e4m5_forerunner_start_title());
	thread (vo_e4m5_killforerunners());
	sleep (30 * 3);
	f_new_objective (e4m5_obj_stopfore01);
end

script static void e4m5_fore_clearing()
	ai_place_with_birth (sq_e4m5_1bish_01);
	ai_place_in_limbo (sq_e4m5_1kni_02);
	ai_place (sq_e4m5_3paw_03);
	ai_place (sq_e4m5_5paw_01);
end

script static void e4m5_fore_yard
	sleep_until (LevelEventStatus ("fore_yard_enemies"), 1);
	ai_place_with_birth (sq_e4m5_1bish_02);
	ai_place_in_limbo (sq_e4m5_1kni_03);
	ai_place (sq_e4m5_5paw_02);
	thread (f_music_e4m5_fore_yard());
end

script static void e4m5_fore_mainbldgbot()
	sleep_until (LevelEventStatus ("fore_mainbldg_bottom"), 1);
	ai_place (sq_e4m5_5paw_03);
	ai_place (sq_e4m5_3paw_04);
	ai_place_in_limbo (sq_e4m5_1kni_04);
	thread (f_music_e4m5_fore_mainbldgbot());
end

script static void e4m5_fore_mainbldgtop()
	sleep_until (LevelEventStatus ("fore_mainbldg_top"), 1);
	thread (vo_e4m5_pelican());
	ai_place_in_limbo (sq_e4m5_1kni_05);
	ai_place (sq_e4m5_5bish_01);
	thread (f_music_e4m5_fore_mainbldgtop());
end

script static void e4m5_fore_vehiclebay()
	sleep_until (LevelEventStatus ("fore_vehiclebay"), 1);
	e4m5_fore_timetofollow = TRUE;
	ai_place (sq_e4m5_1paw_01);
	ai_place_in_limbo (sq_e4m5_2kni_01);
	ai_place (sq_e4m5_1paw_02);
	ai_place (sq_e4m5_2bish_01);
	ai_place (sq_e4m5_1paw_03);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_04);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_05);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_06);
	thread (vo_e4m5_fore_veh_callout());
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_07);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_08);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_09);
	sleep (30 * 1);
	ai_place (sq_e4m5_1paw_10);
	thread (f_music_e4m5_fore_vehiclebay());
	sleep (30 * 1);
	sleep_until (ai_living_count (e4m5_ff_all) < 10);
	sleep (30 * 1);
	thread (vo_e4m5_cleanupfore());
	sleep (30 * 2);
	f_blip_ai_cui (e4m5_ff_all, "navpoint_enemy");
end

//343++343==343++343==343++343//	E4M5 "All Clear" Goal Script (7. no_more_waves)	//343++343==343++343==343++343//

script static void e4m5_fore_clearing02
	sleep_until (LevelEventStatus ("fore_clearing02"), 1);
	sleep (30 * 4);
	ai_place_in_limbo (sq_e4m5_1kni_06);
	ai_place_in_limbo (sq_e4m5_1kni_07);
	ai_place_in_limbo (sq_e4m5_1kni_08);
	thread (e4m5_end_bishop());
	thread (f_music_e4m5_fore_clearing02());
	sleep (30 * 3);
	ai_place (sq_e4m5_5paw_04);
	thread (vo_e4m5_forestragglers());
	sleep (30 * 1);
	f_blip_ai (e4m5_ff_all, neutralize);
end


script static void e4m5_end_bishop()
	if (game_difficulty_get_real() == legendary)	then
		ai_place_with_birth (sq_e4m5_1bish_03);
		print ("last bishop placed with birth!");
	else	(sleep (30 * 1));
		print ("last bishop not placed. Play on Legendary!");		
	end
end
//343++343==343++343==343++343//	E4M5 "All Clear" Goal Script (8. time_passed)	//343++343==343++343==343++343//

script static void e4m5_endmission_start()
	sleep_until (LevelEventStatus ("e4m5_endmission"), 1);
	thread (f_music_e4m5_endmission_start());
	sleep (30 * 2);
	thread (f_music_e4m5_endmission_arrived_title());
	f_objective_complete();          
	
	// start the outro
	// hide the players for the outro
	sleep (30 * 2);
	prepare_to_switch_to_zone_set(e4_m5_holdout_00);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	fade_out (0,0,0, 15);
	e4m5_hide_players_outro();
	sleep (15);
	switch_zone_set (e4_m5_holdout_00);
	sleep (15);
	
	// play outro vignette
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e4m5_vin_sfx_outro', NONE, 1);
	cinematic_start();
	pup_play_show (e4_m5_out);
	thread (vo_e4m5_outro());
	
	fade_in (0,0,0, 15);
	print ("Pup playing");
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
	sleep_until (e4m5_narrative_is_on == FALSE, 1);
	sleep_until (e4m5_narrativeout_done == TRUE, 1);
	sleep (30 * 2);
	cinematic_stop();
	b_end_player_goal = true;
	thread (f_music_e4m5_stop());
	print ("DONE!");
end

script static void e4m5_hide_players_outro
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


//343++343==343++343==343++343//	E2M5 Placement Scripts	//343++343==343++343==343++343//	

script command_script e4m5_cs_phantom01
	f_load_phantom (sq_e4m5_phantom_01, left, sq_e4m5_1eli3gru_01, sq_e4m5_1eli3jak_01, sq_e4m5_1eli1jak2gru_01, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e4m5_phantom_01.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e4m5_1ghost_01.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e4m5_phantom_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e4m5_1ghost_01.empty ) );
	ai_set_blind (sq_e4m5_phantom_01, TRUE);
	cs_fly_to (ps_e4m5_phantom01.p3, 2);
	cs_fly_to (ps_e4m5_phantom01.p0, 2);
	cs_fly_to_and_face (ps_e4m5_phantom01.p0, ps_e4m5_phantom01.p0, 1.0);
	sleep (30 * 3);
	ai_set_blind (sq_e4m5_phantom_01, FALSE);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e4m5_phantom_01.driver ), "phantom_sc" );
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom01.p4, ps_e4m5_phantom01.p4, 1.0);
	sleep (30 * 1);
	f_unload_phantom (sq_e4m5_phantom_01, left);
	sleep (30 * 10);
	cs_fly_to_and_face (ps_e4m5_phantom01.p0, ps_e4m5_phantom01.p0, 1.0);
	sleep (30 * 3);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e4m5_phantom_01.driver ), "phantom_lc" );
	sleep (30 * 1);
	cs_fly_to_and_face (ps_e4m5_phantom01.p2,ps_e4m5_phantom01.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_01);
end

script command_script e4m5_cs_phantom02
	f_load_phantom (sq_e4m5_phantom_02, right, sq_e4m5_1eli1jak2gru_02, sq_e4m5_2eli1jak1gru, sq_e4m5_3jak1gru_01, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom02.p1,ps_e4m5_phantom02.p1);
	cs_fly_to_and_face (ps_e4m5_phantom02.p2,ps_e4m5_phantom02.p2);
	sleep (30 * 8);
	f_unload_phantom (sq_e4m5_phantom_02, right);
	sleep (30 * 8);
	print ("phantom 02 dropped off load");
	cs_fly_to_and_face (ps_e4m5_phantom02.p3,ps_e4m5_phantom02.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_02);
end

script command_script e4m5_cs_phantom03
	f_load_phantom (sq_e4m5_phantom_03, left, sq_e4m5_4mixed_02, none, sq_e4m5_4mixed_01, sq_e4m5_1eli1jak2gru_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom03.p1, ps_e4m5_phantom03.p1, 1.0);
	cs_fly_to_and_face (ps_e4m5_phantom03.p3, ps_e4m5_phantom03.p3, 1.0);
	cs_fly_to_and_face (ps_e4m5_phantom03.p0, ps_e4m5_phantom03.p0, 1.0);
	sleep (30 * 8);
	f_unload_phantom (sq_e4m5_phantom_03, left);
	sleep (30 * 8);
	cs_fly_to_and_face (ps_e4m5_phantom03.p2,ps_e4m5_phantom03.p2, 2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_03);
end

script command_script e4m5_cs_phantom04
	f_load_phantom (sq_e4m5_phantom_04, right, sq_e4m5_4jak_01, sq_e4m5_4jak_03, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom04.p0, ps_e4m5_phantom04.p0, 2);
	cs_fly_to_and_face (ps_e4m5_phantom04.p1, ps_e4m5_phantom04.p1, 2);
	cs_fly_to_and_face (ps_e4m5_phantom04.p2, ps_e4m5_phantom04.p2, 2);
	sleep (30 * 4);
	f_unload_phantom (sq_e4m5_phantom_04, right);
	sleep (30 * 8);
	f_load_phantom (sq_e4m5_phantom_04, right, sq_e4m5_4mixed_03, sq_e4m5_4jak_02, none, none);
	cs_fly_to_and_face (ps_e4m5_phantom04.p3,ps_e4m5_phantom04.p3, 2);
	sleep (30 * 4);
	f_unload_phantom (sq_e4m5_phantom_04, right);
	sleep (30 * 8);
	cs_fly_to_and_face (ps_e4m5_phantom04.p4,ps_e4m5_phantom04.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_04);
end

script command_script e4m5_cs_phantom06
	f_load_phantom (sq_e4m5_phantom_06, right, sq_e4m5_3eli_01, sq_e4m5_4jak_04, sq_e4m5_4gru_01, sq_e4m5_4gru_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_06);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom06.p0, ps_e4m5_phantom06.p0, 2);
	cs_fly_to_and_face (ps_e4m5_phantom06.p1, ps_e4m5_phantom06.p1, 2);
	sleep (30 * 8);
	cs_fly_to_and_face (ps_e4m5_phantom06.p2,ps_e4m5_phantom06.p2, 2);
	f_unload_phantom (sq_e4m5_phantom_06, right);
	sleep (30 * 8);
	cs_fly_to_and_face (ps_e4m5_phantom06.p3,ps_e4m5_phantom06.p3, 2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_06);
end

script command_script e4m5_cs_phantom07
	f_load_phantom (sq_e4m5_phantom_07, left, sq_e4m5_4mixed_04, sq_e4m5_4mixed_05, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_07);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom07.p0, ps_e4m5_phantom07.p0);
	cs_fly_to_and_face (ps_e4m5_phantom07.p1, ps_e4m5_phantom07.p1);
	cs_fly_to_and_face (ps_e4m5_phantom07.p3, ps_e4m5_phantom07.p3);
	sleep (30 * 4);
	f_unload_phantom (sq_e4m5_phantom_07, left);
	sleep (30 * 4);
	cs_fly_to_and_face (ps_e4m5_phantom07.p3, ps_e4m5_phantom07.p3);
	f_load_phantom (sq_e4m5_phantom_07, right, sq_e4m5_4mixed_06, sq_e4m5_4mixed_07, none, none);
	sleep (30 * 3);
	f_unload_phantom (sq_e4m5_phantom_07, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e4m5_phantom07.p4, ps_e4m5_phantom07.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_07);
end

script command_script e4m5_cs_phantom08
	f_load_phantom (sq_e4m5_phantom_08, right, sq_e4m5_4gru_03, sq_e4m5_4eli_01, sq_e4m5_4gru_04, sq_e4m5_4jak_05);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e4m5_phantom_08.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e4m5_1ghost_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_08);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom08.p0, ps_e4m5_phantom08.p0, 2);
	cs_fly_to (ps_e4m5_phantom08.p1, 2);
	sleep (30 * 1);
	cs_fly_to_and_face (ps_e4m5_phantom08.p1, ps_e4m5_phantom08.p1, 2);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e4m5_phantom_08.driver ), "phantom_sc" );
	sleep (30 * 8);
	f_unload_phantom (sq_e4m5_phantom_08, right);
	sleep (30 * 5);
	
	cs_fly_to_and_face (ps_e4m5_phantom08.p2, ps_e4m5_phantom08.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_08);
end

script command_script e4m5_cs_phantom09
	f_load_phantom (sq_e4m5_phantom_09, left, sq_e4m5_1hun_01, sq_e4m5_4gru_05, sq_e4m5_1hun_02, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_phantom_09);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_phantom09.p0, ps_e4m5_phantom09.p0, 1);
	sleep (30 * 1);
	cs_fly_to_and_face (ps_e4m5_phantom09.p1, ps_e4m5_phantom09.p1, 1);
	sleep (30 * 8);
	f_unload_phantom (sq_e4m5_phantom_09, left);
	sleep (30 * 5);
	thread (vo_e4m5_hunters01());
	cs_fly_to_and_face (ps_e4m5_phantom09.p2, ps_e4m5_phantom09.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_phantom_09);
end

script command_script e4m5_cs_killphantoms()
	ai_set_blind (ai_current_actor, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
end


script command_script e4m5_cs_fluffphantom01()
	ai_set_blind (ai_current_actor, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_fluffphantom_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_fluffphantoms.p0, ps_e4m5_fluffphantoms.p0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_fluffphantom_01);
end


script command_script e4m5_cs_fluffphantom02()
	ai_set_blind (ai_current_actor, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_fluffphantom_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_fluffphantoms.p1, ps_e4m5_fluffphantoms.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_fluffphantom_02);
end


script command_script e4m5_cs_fluffphantom03()
	ai_set_blind (ai_current_actor, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e4m5_fluffphantom_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e4m5_fluffphantoms.p2, ps_e4m5_fluffphantoms.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e4m5_fluffphantom_03);
end


//	Turrets Command Script

script command_script cs_e4m5_basedefense01
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e4m5_base_defense_01);
end

script command_script cs_e4m5_basedefense02
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e4m5_base_defense_02);
end

script command_script cs_e4m5_basedefense03
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e4m5_base_defense_03);
end

script command_script cs_e4m5_basedefense04
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e4m5_base_defense_04);
end

//	Forerunner Spawn Scripts

script command_script cs_e4m5_knights_phasein
	cs_phase_in();
end

script command_script cs_e4m5_1knight06_phasein
	cs_phase_in();
	sleep (30 * 3);
	cs_phase_to_point (ps_e4m5_knightsphase.p0);
end

script command_script cs_e4m5_1knight07_phasein
	cs_phase_in();
	sleep (30 * 3);
	cs_phase_to_point (ps_e4m5_knightsphase.p1);
end

script command_script cs_e4m5_1knight08_phasein
	cs_phase_in();
	sleep (30 * 3);
	cs_phase_to_point (ps_e4m5_knightsphase.p2);
end

script command_script cs_e4m5_pawn_spawn
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e4m5_bishop_spawn_bishop01()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e4m5_OnCompleteBishopBirth, 0);
	thread (e4m5_bishop01_killlimbo());
end 

script static void e4m5_bishop01_killlimbo
	sleep (30 * 15);
	if (ai_in_limbo_count (sq_e4m5_1bish_01) > 0)	then
		sleep_until (ai_not_in_limbo_count (sq_e4m5_1bish_01) == 0);
		ai_erase (sq_e4m5_1bish_01);
		print ("Killed Bishop in Limbo!");
		else (sleep (30 * 1));
	end
end

script command_script cs_e4m5_bishop_spawn_bishop02()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e4m5_OnCompleteBishopBirth, 0);
	thread (e4m5_bishop02_killlimbo());
end 

script static void e4m5_bishop02_killlimbo
	sleep (30 * 20);
	if (ai_in_limbo_count (sq_e4m5_1bish_02) > 0)	then
		sleep_until (ai_not_in_limbo_count (sq_e4m5_1bish_02) == 0);
		ai_erase (sq_e4m5_1bish_02);
		print ("Killed Bishop in Limbo!");
		else (sleep (30 * 1));
	end
end

script command_script cs_e4m5_bishop_spawn_5bishops()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e4m5_OnCompleteBishopBirth, 0);
	thread (e4m5_5bishops_killlimbo());
end 

script static void e4m5_5bishops_killlimbo
	sleep (30 * 30);
	if (ai_in_limbo_count (sq_e4m5_5bish_01) > 0)	then
		sleep_until (ai_not_in_limbo_count (sq_e4m5_5bish_01) == 0);
		ai_erase (sq_e4m5_5bish_01);
		print ("Killed Bishop in Limbo!");
		else (sleep (30 * 1));
	end
end

script command_script cs_e4m5_bishop_spawn_2bishops()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e4m5_OnCompleteBishopBirth, 0);
	thread (e4m5_2bishop01_killlimbo());
end 

script static void e4m5_2bishop01_killlimbo
	sleep (30 * 30);
	if (ai_in_limbo_count (sq_e4m5_2bish_01) > 0)	then
		sleep_until (ai_not_in_limbo_count (sq_e4m5_2bish_01) == 0);
		ai_erase (sq_e4m5_2bish_01);
		print ("Killed Bishop in Limbo!");
		else (sleep (30 * 1));
	end
end

script static void e4m5_OnCompleteBishopBirth()
	sleep (30 * 1);
	print ("Bishop spawned");
end

script command_script cs_e4m5_pawn_birth
	print("pawn sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), e4m5_OnCompleteProtoSpawn, 1.5);
	if (ai_in_limbo_count (ai_current_actor) > 0)	then
		ai_erase (ai_current_actor);
		else (sleep (30 * 1));
	end
end

script static void e4m5_OnCompleteProtoSpawn()
print ("Pawn Birthed");
end

//343++343==343++343==343++343//	E2M5 Misc. Scripts	//343++343==343++343==343++343//	

//	Weapon Respawns

script static void e4m5_weaponcrates_respawn()
	repeat
		sleep_s (300);
		object_create_folder_anew (e4m5_weaponcrates);
	until (forerunners_have_arrived == TRUE);
end