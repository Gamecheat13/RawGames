//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 02: Mission 03																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================

global boolean e2m3_phantom01_drophunters = FALSE;
global boolean e2m3_phantom01_drop1eli2jak = FALSE;
global boolean e2m3_alldead = FALSE;
global short e2m3_phantoms_killed = 0;
global boolean e2m3_marines_are_human = FALSE;
global boolean e2m3_phantomsswitch = FALSE;
global boolean e2m3_pelican_landed = FALSE;
global boolean e2m3_narrativein_done = FALSE;
global boolean e2m3_f1_2ndwave = FALSE;
global boolean e2m3_f2_2ndwave = FALSE;
global boolean e2m3_f3_2ndwave = FALSE;
global boolean e2m3_fort01_liberated = FALSE;
global boolean e2m3_fort02_liberated = FALSE;
global boolean e2m3_fort03_liberated = FALSE;
global boolean e2m3_huntersfollow = FALSE;
global boolean e2m3_timetofollow = FALSE;
//================================================== Startup ==================================================================

script startup e02_m03_variant
	sleep_until (LevelEventStatus ("e2m3_variant"), 1);
	ai_ff_all = e2m3_ff_all;
	print ("e2m3 variant started");
	switch_zone_set (e2_m3_fortsw);
	thread (f_music_e2m3_start());
	dm_droppod_1 = e2m3_drop_1;
	dm_droppod_2 = e2m3_drop_2;
	dm_droppod_3 = e2m3_drop_3;
	dm_droppod_4 = e2m3_drop_4;
	dm_droppod_5 = e2m3_drop_5;
	e2m3_narrativein_done = FALSE;
//	sleep (30 * 2);
	//	Set Enemy Squads
	firefight_mode_set_squad_at(gr_e2m3_forts01_template, 1); //	Enemies on Left Fort area
	firefight_mode_set_squad_at(gr_e2m3_forts02_template, 2); //	Enemies on Right Fort area
	firefight_mode_set_squad_at(gr_e2m3_forts03_template, 3); //	Enemies on Rear Fort area	
	//firefight_mode_set_squad_at(gr_e2m3_phantemplate_01, 4); //	Phantom 01 Template	
	firefight_mode_set_squad_at(sq_e2m3_template_phantom01, 4); //	Phantom 01 Template	
	firefight_mode_set_squad_at(sq_e2m3_template_phantom02, 5); //	Phantom 02 Template
	firefight_mode_set_squad_at(sq_e2m3_template_phantom03, 6); //	Phantom 03 Template
	firefight_mode_set_squad_at(sq_e2m3_template_phantom04, 7); //	Phantom 04 Template
	firefight_mode_set_squad_at(sq_e2m3_template_phantom05, 8); //	Phantom 05 Template
	firefight_mode_set_squad_at(gr_e2m3_phansquadtemp_01, 9); //	Phantom Squad Template 01
	firefight_mode_set_squad_at(gr_e2m3_phansquadtemp_02, 10); //	Phantom Squad Template 02
	firefight_mode_set_squad_at(gr_e2m3_phansquadtemp_03, 11); //	Phantom Squad Template 03
	firefight_mode_set_squad_at(gr_e2m3_phansquadtemp_04, 12); //	Phantom Squad Template 04
	firefight_mode_set_squad_at(gr_e2m3_phansquadtemp_05, 13); //	Phantom Squad Template 05
	//	Set Vehicles and Turrets
	f_add_crate_folder (e2m3_veh_cov); //	Spawns Cov Vehicles
	f_add_crate_folder (e2m3_turrets); //	Spawns All Turrets
	//	Set Crates
	f_add_crate_folder (e2m3_weapon_crates);	//	Spawns gun Racks, Equipment cases, etc.
	f_add_crate_folder (e2m3_barriers); //	Spawns Barrier props
	f_add_crate_folder (e2m3_props); //	Spawns decor props
	//	Set weapons, Ammo, and Grenades
	f_add_crate_folder (e2m3_weapons); //	Spawns weapons on map
	f_add_crate_folder (e2m3_equipment); //	Spawns Equipment
	//	Set Device Machine Folders
	f_add_crate_folder (e2m3_devicemachines);
	//	Set Spawn Points
	firefight_mode_set_crate_folder_at(e2m3_spawnpoints_01, 50); //	1st Spawn Point near SW area
	f_add_crate_folder (e2m3_spawnpoints_01); //	1st Spawn Point near SW area
	firefight_mode_set_crate_folder_at(e2m3_spawnpoints_02, 49); //	3rd Spawn Point On structure
		
	//	Set objective Points
	firefight_mode_set_objective_name_at (e2m3_lz04, 60); //	arrival point on top of main structure
		
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	firefight_mode_set_player_spawn_suppressed(TRUE);
	b_wait_for_narrative_hud = TRUE;
	f_create_new_spawn_folder (50);
	thread (e02_m03_start());
	//thread (e2m3_turnoffdevices());
	thread (e2m3_fort_marines());
	if editor_mode() then
		print("editor mode, not playing intro");
		e2m3_narrativein_done = TRUE;
		thread (e2m3_locationblips());
		thread (e2m3_goal01_narrative());
		firefight_mode_set_player_spawn_suppressed(FALSE);
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
		sleep (30 * 10);
	else
		sleep_until (LevelEventStatus ("loadout_screen_complete"), 1);
		cinematic_start();
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m3_vin_sfx_intro', NONE, 1);
		thread (f_music_e2m3_puppeteer_start());
		thread (e2m3_narrative_in());
		thread (e2m3_puppeteer_opening_tts());
		sleep_until (e2m3_narrativein_done == TRUE);
		cinematic_stop();
		thread (f_music_e2m3_puppeteer_stop());
		thread (e2m3_goal01_narrative());
		firefight_mode_set_player_spawn_suppressed(FALSE);	
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
		dprint ("variant for E2M3 loaded!");
	end
end


//	Mission Start //




//343++343==343++343==343++343//	E2M3 Goal 01 Scripts (0. time_passed)	//343++343==343++343==343++343//

// Starting goal scripts

script static void e02_m03_start()
		print ("Episode 2: Mission 3 is now starting up!");
end

script static void e2m3_fort_marines()
	sleep_until (e2m3_narrativein_done == TRUE);
	b_wait_for_narrative_hud = TRUE;
	ai_place (sq_e2m3_f1_2gru1eli_01);
	ai_place (sq_e2m3_f3_2jak3gru_01);
	ai_place (sq_e2m3_1grushade_01);
	ai_place (sq_e2m3_1grughost_01);
	ai_place (sq_e2m3_f2_4gru_01);
	ai_place (e2m3_marines_01);
	ai_place (e2m3_marines_02);
	ai_place (e2m3_marines_03);
	ai_place (sq_e2m3_1snijak_02);
	//ai_place (sq_e2m3_1snijak_03);
	ai_place (sq_e2m3_1snijak_04);
	ai_place (sq_e2m3_1hun_01);
	ai_place (sq_e2m3_1hun_02);
	ai_place (sq_e2m3_1gruturr_01);
	thread (e2m3_fort01_reinforce());
	thread (e2m3_fort02_reinforce());
	thread (e2m3_fort03_reinforce());
	thread (e2m3_objective_narrative_count_setup_01());
	thread (e2m3_objective_narrative_count_setup_02());
	thread (e2m3_objective_narrative_count_setup_03());
	thread (e2m3_Phantom01_spawn());
	thread (e2m3_goal02_threads());
//	object_set_melee_attack_inhibited (ai_actors (object_get_ai (sq_e2m3_f1_2gru1eli_01.elite_easy)), TRUE);
//	object_set_melee_attack_inhibited (ai_actors (object_get_ai (sq_e2m3_f1_2gru1eli_01.elite_normal_heroic)), TRUE);
//	object_set_melee_attack_inhibited (ai_actors (object_get_ai (sq_e2m3_f1_2gru1eli_01.elite_legendary)), TRUE);
//	object_set_melee_attack_inhibited (ai_actors (object_get_ai (sq_e2m3_f3_2jak3gru_01)), TRUE);
//	object_set_melee_attack_inhibited (ai_actors (object_get_ai (sq_e2m3_f2_4gru_01)), TRUE);
end


script static void e2m3_fort01_reinforce()
	sleep_until (ai_living_count (sq_e2m3_f1_2gru1eli_01) == 0);
	ai_place_in_limbo (sq_f1_3mixed_01);
	sleep (30 * 1);
	e2m3_f1_2ndwave = TRUE;
	thread (f_load_drop_pod (e2m3_drop_1, sq_f1_3mixed_01, e2m3_droppod_01, FALSE));
	print ("Drop Pod For Fort 01");
	thread (e2m3_tts_droppod01());
end


script static void e2m3_fort02_reinforce()
	sleep_until (ai_living_count (sq_e2m3_f2_4gru_01) == 0);
	ai_place_in_limbo (sq_f2_3mixed_02);
	sleep (30 * 1);
	e2m3_f2_2ndwave = TRUE;
	thread (f_load_drop_pod (e2m3_drop_2, sq_f2_3mixed_02, e2m3_droppod_02, FALSE));
	print ("Drop Pod For Fort 02");
	thread (e2m3_tts_droppod02());
end


script static void e2m3_fort03_reinforce()
	sleep_until (ai_living_count (sq_e2m3_f3_2jak3gru_01) == 0);
	ai_place_in_limbo (sq_f3_2mixed_01);
	sleep (30 * 1);
	e2m3_f3_2ndwave = TRUE;
	thread (f_load_drop_pod (e2m3_drop_3, sq_f3_2mixed_01, e2m3_droppod_03, FALSE));
	print ("Drop Pod For Fort 03");
	thread (e2m3_tts_droppod03());
end


//	Narrative scripts

script static void e2m3_goal01_narrative()
	f_new_objective (e2m3_obj01);
	sleep_until (e2m3_bases_saved == 1);
	print ("one base down");
	thread (f_music_e2m3_one_base_down());
	sleep (30 * 2);
	thread (e2m3_1_base_saved());
	sleep_until (e2m3_bases_saved == 2);
	print ("two bases down");
	thread (f_music_e2m3_two_bases_down());
	sleep (30 * 2);
	thread (e2m3_2_bases_saved());
	sleep_until (e2m3_bases_saved == 3);
	//cinematic_set_title (three_groups_rescued);
	print ("three bases down");
	thread (f_music_e2m3_three_bases_down());
	sleep (30 * 2);
	thread (e2m3_3_bases_saved());
	f_objective_complete();
	sleep (30 * 2);
	b_end_player_goal = TRUE;
	thread (f_music_e2m3_finish());
end


//	Goal 01 Misc scripts


	//	Counting number of bases saved
script static void e2m3_objective_narrative_count_setup_01()
	sleep_until (ai_living_count (sq_e2m3_f1_2gru1eli_01) == 0);
	sleep_until (e2m3_f1_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f1_3mixed_01) == 0);
	e2m3_fort01_liberated = TRUE;
	e2m3_bases_saved = e2m3_bases_saved + 1;
end
script static void e2m3_objective_narrative_count_setup_02
	sleep_until (ai_living_count (sq_e2m3_f2_4gru_01) == 0);
	sleep_until (e2m3_f2_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f2_3mixed_02) == 0);
	e2m3_fort02_liberated = TRUE;
	e2m3_bases_saved = e2m3_bases_saved + 1;
end
script static void e2m3_objective_narrative_count_setup_03
	sleep_until (ai_living_count (sq_e2m3_f3_2jak3gru_01) == 0);
	sleep_until (e2m3_f3_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f3_2mixed_01) == 0);
	e2m3_fort03_liberated = TRUE;
	e2m3_bases_saved = e2m3_bases_saved + 1;
end


	//	Fort location blips
script static void e2m3_locationblips()
	thread (e2m3_fort1_locationblip());
	thread (e2m3_fort2_locationblip());
	thread (e2m3_fort3_locationblip());
end
	
script static void e2m3_fort1_locationblip()
	f_blip_flag (e2m3_fort01_flag, default);
	sleep_until (volume_test_players (e2m3_fort01_trigger), 1);
	f_unblip_flag (e2m3_fort01_flag);
	if (e2m3_fort01_liberated == FALSE)	then
		thread (e2m3_tts_marine01arrive());
	end
end
script static void e2m3_fort2_locationblip()
	f_blip_flag (e2m3_fort02_flag, default);
	sleep_until (volume_test_players (e2m3_fort02_trigger), 1);
	f_unblip_flag (e2m3_fort02_flag);
	if (e2m3_fort02_liberated == FALSE)	then
		thread (e2m3_tts_marine02arrive());
	end
end

script static void e2m3_fort3_locationblip()
	f_blip_flag (e2m3_fort03_flag, default);
	sleep_until (volume_test_players (e2m3_fort03_trigger), 1);
	f_unblip_flag (e2m3_fort03_flag);
	if (e2m3_fort03_liberated == FALSE)	then
		thread (e2m3_tts_marine03arrive());
	end
end


//343++343==343++343==343++343//	E2M3 Goal 02 Scripts (1. no_more_waves)	//343++343==343++343==343++343//

script static void e2m3_goal02_threads()
	thread (e2m3_goal02_start());
	thread (e2m3_Phantom02_spawn());
	thread (e2m3_phantom03_spawn());
	thread (e2m3_phantom04_spawn());
	thread (e2m3_phantom05_spawn());
	thread (e2m3_locationarrival_start());
	thread (e2m3_phantomfendoff_start());
end

script static void e2m3_Phantom01_spawn()
	sleep_until (LevelEventStatus ("e2m3_phantom01"), 1);
	thread (f_music_e2m3_phantom01_spawn());
	ai_place (sq_e2m3_2eliwraith_01);
	ai_place_in_limbo (sq_e2m3_phantom01);
	sleep (30 * 2);
	ai_cannot_die (gr_e2m3_marines, FALSE);
	sleep (10);
	object_immune_to_friendly_damage ( ai_actors (gr_e2m3_marines), TRUE);
end

script static void e2m3_goal02_start()
	sleep_until (LevelEventStatus ("e2m3_goal02_start"), 1);
	thread (f_music_e2m3_goal02_start());
	sleep (30 * 2);
	thread (e2m3_tts_reinforcements());
	sleep (30 * 2);
	f_new_objective (e2m3_obj05);
end

script static void e2m3_Phantom02_spawn()
	sleep_until (LevelEventStatus ("e2m3_phantom02"), 1);
	thread (f_music_e2m3_phantom02_spawn());
	ai_place_in_limbo (sq_e2m3_phantom02);
	sleep (30 * 3);
	thread (e2m3_tts_phantomreinforcements());
end

script static void e2m3_phantom03_spawn()
	sleep_until (LevelEventStatus ("e2m3_phantom03"), 1);
	thread (f_music_e2m3_phantom03_spawn());
	ai_place_in_limbo (sq_e2m3_phantom03);
	sleep (30 * 3);
	thread (e2m3_tts_phantomreinforcements02());
end

script static void e2m3_phantom04_spawn()
	sleep_until (LevelEventStatus ("e2m3_phantom04"), 1);
	thread (f_music_e2m3_phantom04_spawn());
	ai_place_in_limbo (sq_e2m3_phantom04);
	e2m3_huntersfollow = TRUE;
	e2m3_timetofollow = TRUE;
	sleep (30 * 3);
	thread (e2m3_tts_phantomreinforcements03());
end

script static void e2m3_phantom05_spawn()
	sleep_until (LevelEventStatus ("e2m3_phantom05"), 1);
	thread (f_music_e2m3_phantom05_spawn());
	ai_place_in_limbo (sq_e2m3_phantom05);
	sleep (30 * 2);
	thread (e2m3_tts_phantom_arrival());
	sleep (30 * 2);
	sleep_until (ai_living_count (e2m3_ff_all) <= 3, 1);
	thread (e2m3_tts_stragglers());
end

//343++343==343++343==343++343//	E2M3 Goal 03 Scripts (2. location_arrival)	//343++343==343++343==343++343//

script static void e2m3_locationarrival_start()
	sleep_until (LevelEventStatus ("locationarrival_start"), 1);
	thread (f_music_e2m3_locationarrival_start());
	f_create_new_spawn_folder (49);
	sleep (30 * 2);
	thread (e2m3_tts_headtoevac01());
	sleep (30 * 2);
	f_objective_complete();
	sleep (30 * 2);
	f_new_objective (e2m3_obj02);
end

//343++343==343++343==343++343//	E2M3 Goal 04 Scripts (3. no_more_waves)	//343++343==343++343==343++343//

script static void e2m3_phantomfendoff_start()
	sleep_until (LevelEventStatus ("phantomfendoff_start"), 1);
	thread (e2m3_switching_phantomsides());
	thread (f_music_e2m3_phantomfendoff_start());
	thread (e2m3_tts_phantomfendoffstart());
	thread (e2m3_cleanup_squads());
	thread (e2m3_locationarrival02_start());
	thread (e2m3_waiting_time());
	ai_place_in_limbo (sq_e2m3_template_phantom04);
	ai_place_in_limbo (sq_e2m3_template_phantom05);
	e2m3_marines_are_human = TRUE;
	sleep (30 * 1);
	thread (e2m3_2phantoms_change_health());
	thread (e2m3_objective_phantomskilled_count_setup_01());
	thread (e2m3_objective_phantomskilled_count_setup_02());
	sleep (30 * 14);
	f_new_objective (e2m3_obj03);	
end

script static void e2m3_2phantoms_change_health()
	game_difficulty_get_real();
		if (game_difficulty_get_real() == legendary)	then
			print ("Legendary difficulty. No changes made.");
		elseif (game_difficulty_get_real() == heroic)	then
			object_set_health (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom05.driver), .75);
			print ("1 Phantom scaled down to .75 Health");
		elseif (game_difficulty_get_real() == normal)	then
			object_set_health (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom05.driver), .75);
			print ("1 Phantom scaled down to .75 Health");
		else
			object_set_health (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom04.driver), .50);
			object_set_health (ai_vehicle_get_from_spawn_point (sq_e2m3_template_phantom05.driver), .50);	
			print ("Phantoms scaled down to .50 Health");
	end
end

script static void e2m3_switching_phantomsides()
	repeat
		sleep (30 * 60);
		e2m3_phantomsswitch = TRUE;
		sleep (30 * 60);
		e2m3_phantomsswitch = FALSE;
	until (e2m3_phantoms_killed == 2);
end

script static void e2m3_cleanup_squads()
	sleep_until (e2m3_phantoms_killed == 2);
	sleep (30 * 1);
	if (ai_living_count (e2m3_ff_all) > 0)	then
		sleep (30 * 2);
		thread (e2m3_tts_stragglers02());
		print ("PHANTOMS ARE DEAD, GO CLEAN UP THE MESS");
	else (thread (e2m3_2phantoms_dead()));
	end
end

//	Counting number of phantoms destroyed

script static void e2m3_objective_phantomskilled_count_setup_01()
	print ("phantom counting script 01 activated");
	sleep_until (ai_living_count (sq_e2m3_template_phantom04) == 0);
	e2m3_phantoms_killed = e2m3_phantoms_killed + 1;
	print ("one phantom down");
end

script static void e2m3_objective_phantomskilled_count_setup_02()
	print ("phantom counting script 02 activated");
	sleep_until (ai_living_count (sq_e2m3_template_phantom05) == 0);
	e2m3_phantoms_killed = e2m3_phantoms_killed + 1;
	print ("one phantom down");
end

//	Respawning Ammo for rocket launchers
script static void e2m3_rocketammo_respawn()
	f_blip_flag (e2m3_ammoblip_01, ammo);
	f_blip_flag (e2m3_turretblip_01, default);
	f_blip_flag (e2m3_ammoblip_02, ammo);
	f_blip_flag (e2m3_ammoblip_03, ammo);
	f_blip_flag (e2m3_turretblip_03, default);
	f_blip_flag (e2m3_ammoblip_04, ammo);
	f_blip_flag (e2m3_turretblip_04, default);
	print ("everything is blipped");
	//	Respawning Ammo	
	repeat
		object_create_anew (e2m3_rocketlaunch_01);
		object_create_anew (e2m3_rocketlaunch_02);
		object_create_anew (e2m3_splaser_01);
		object_create_anew (e2m3_splaser_02);
		object_create_anew (e2m3_splaser_03);
		object_create_anew (e2m3_splaser_04);
		object_create_anew (e2m3_splaser_05);
		object_create_anew (e2m3_gunrack_01);
		object_create_anew (e2m3_gunrack_03);
		object_create_anew (e2m3_gunrack_04);
		object_create_anew (e2m3_gunrack_05);
		object_create_anew (e2m3_gunrack_06);
		object_create_anew (e2m3_gunrack_07);
		object_create_anew (e2m3_gunrack_08);
		object_create_anew (e2m3_gunrack_09);
		object_create_anew (e2m3_gunrack_10);
		object_create_anew (e2m3_gunrack_11);
		object_create_anew (e2m3_gunrack_12);
		sleep (30 * 20);
	until (e2m3_alldead == TRUE);
	sleep_forever();
end

//343++343==343++343==343++343//	E2M3 Goal 04.5 Scripts (4. time_passed)	//343++343==343++343==343++343//

script static void e2m3_waiting_time()
	sleep_until (LevelEventStatus ("e2m3_waitforabit"), 1);
	sleep_until (ai_living_count (e2m3_ff_all) <= 0, 1);
	prepare_to_switch_to_zone_set(e2m3_end);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e2m3_end);
	sleep (30);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E2M3 Goal 05 Scripts (5. time_passed)	//343++343==343++343==343++343//

script static void e2m3_locationarrival02_start()
	sleep_until (LevelEventStatus ("locationarrival02_start"), 1);
	thread (f_music_e2m3_locationarrival02_start());
	thread (e2m3_tts_locationarrival02start());
	thread (e2m3_ending_tts());
	thread (e2m3_unblipping());
	ai_place_in_limbo (sq_e2m3_pelican_01);
	f_objective_complete();
	sleep (30 * 4);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e2m3_pelican_01.driver), "navpoint_goto");
	f_new_objective (e2m3_obj02);
	sleep_until (e2m3_pelican_landed == TRUE, 1);
	sleep (30 * 1);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e2m3_pelican_01.driver));
	f_blip_object_cui (e2m3_lz04, "navpoint_goto");
	sleep (30 * 1);
	sleep_until (volume_test_players (e2m3_lz_volume), 1);
	f_unblip_object_cui (e2m3_lz04);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M3 Goal 06 Scripts (6. time_passed)	//343++343==343++343==343++343//

script static void e2m3_ending_tts()
	sleep_until (LevelEventStatus ("e2m3_ending"), 1);
	thread (e2m3_tts_alldone());
	sleep (30 * 2);
	sleep_until (e2m3_narrative_in_use == FALSE, 1);
	sleep (30 * 1);
	fade_out (0, 0, 0, 15);
	f_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
end

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

//343++343==343++343==343++343	E2M3 Placement Scripts	343++343==343++343==343++343//

script command_script e2m3_near_immortalenemies
	unit_only_takes_damage_from_players_team (ai_current_actor, TRUE);
	ai_kamikaze_disable (ai_current_actor, TRUE);
end

script command_script e2m3_fort1_marines
	ai_cannot_die (ai_current_actor, TRUE);
	print ("fort1 immortals are set");
	thread (e2m3_fort1_marines_follow());
end

script static void e2m3_fort1_marines_follow()
	sleep_until (ai_living_count (sq_e2m3_f1_2gru1eli_01) == 0);
	sleep_until (e2m3_f1_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f1_3mixed_01) == 0);
	f_unblip_flag (e2m3_fort01_flag);
	print ("fort 1 enemies dead, marines 01 following");
	sleep_until (LevelEventStatus ("e2m3_goal02_start"), 1);
	ai_cannot_die ( e2m3_marines_01, FALSE);
	print ("marines 01 are Mortal");
end

script command_script e2m3_fort2_marines
	ai_cannot_die (ai_current_actor, TRUE);
	print ("fort2 immortals are set");
	thread (e2m3_fort2_marines_follow());
end
	
script static void e2m3_fort2_marines_follow()
	sleep_until (ai_living_count (sq_e2m3_f2_4gru_01) == 0);
	sleep_until (e2m3_f2_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f2_3mixed_02) == 0);
	f_unblip_flag (e2m3_fort02_flag);
	print ("fort 2 enemies dead, marines 02 following");
	sleep_until (LevelEventStatus ("e2m3_goal02_start"), 1);
	ai_cannot_die (e2m3_marines_02, FALSE);
	print ("marines 02 are Mortal");
end

script command_script e2m3_fort3_marines
	ai_cannot_die (ai_current_actor, TRUE);
	print ("fort3 immortals are set");
	thread (e2m3_fort3_marines_follow());
end
	
script static void e2m3_fort3_marines_follow()
	sleep_until (ai_living_count (sq_e2m3_f3_2jak3gru_01) == 0);
	sleep_until (e2m3_f3_2ndwave == TRUE, 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (sq_f3_2mixed_01) == 0);
	f_unblip_flag (e2m3_fort03_flag);
	print ("fort 3 enemies dead, marines 03 following");
	sleep_until (LevelEventStatus ("e2m3_goal02_start"), 1);
	ai_cannot_die ( e2m3_marines_03, FALSE);
	print ("marines 03 are Mortal");
end

script command_script e2m3_gruturr_01
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e2m3_hall_turret);
end

script command_script e2m3_phantom_01
	print ("phantom command script initiated");
	f_load_phantom (sq_e2m3_phantom01, right, sq_e2m3_1eli2jak_01, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e2m3_phantom01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e2m3_2eliwraith_01.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_phantom01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_phantom01.p0, ps_e2m3_phantom01.p0);
	print ("moving to point 01");
	cs_fly_to_and_face (ps_e2m3_phantom01.p7, ps_e2m3_phantom01.p7);
	cs_fly_to_and_face (ps_e2m3_phantom01.p9, ps_e2m3_phantom01.p9);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e2m3_phantom01.driver ), "phantom_lc" );
	sleep (30 * 3);
	f_unload_phantom (sq_e2m3_phantom01, right);
	sleep (30 * 5);
	cs_fly_to (ps_e2m3_phantom01.p12);
	cs_fly_to_and_face (ps_e2m3_phantom01.p12, ps_e2m3_phantom01.p12);
	cs_fly_to (ps_e2m3_phantom01.p8);
	cs_face (ai_current_actor, TRUE, ps_e2m3_phantom01.p8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e2m3_phantom01);
end

script command_script e2m3_phantom02
	print ("phantom 02 command script initiated");
	f_load_phantom (sq_e2m3_phantom02, left, sq_e2m3_4gru_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_phantom02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	print ("moving to point 00");
	cs_fly_to (ps_e2m3_phantom02.p0);
	print ("moving to point 01");
	cs_fly_to (ps_e2m3_phantom02.p1);
	print ("moving to point 02");
	cs_fly_to_and_face (ps_e2m3_phantom02.p2, ps_e2m3_phantom02.p2);
	print ("cs_fly_to_and_face completed!");
	sleep (30 * 3);
	f_unload_phantom (sq_e2m3_phantom02, left);
	sleep (30 * 5);
	print ("moving to point 03");
	cs_fly_to_and_face (ps_e2m3_phantom02.p3, ps_e2m3_phantom02.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 5);
	ai_erase (sq_e2m3_phantom02);
end

script command_script cs_e2m3_phantom03
	f_load_phantom (sq_e2m3_phantom03, dual, sq_e2m3_4mixed_01, sq_e2m3_4mixed_02, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_phantom03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_phantom03.p0, ps_e2m3_phantom03.p0);
	f_unload_phantom (sq_e2m3_phantom03, dual);
	sleep (30 * 5);
	cs_fly_to (ps_e2m3_phantom03.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e2m3_phantom03);
end

script command_script cs_e2m3_phantom04
	f_load_phantom (sq_e2m3_phantom04, dual, sq_e2m3_4eli_02, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_phantom04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	cs_fly_to_and_face (ps_e2m3_phantom04.p0, ps_e2m3_phantom04.p0);
	f_unload_phantom (sq_e2m3_phantom04, dual);
	sleep (30 * 5);
	cs_fly_to (ps_e2m3_phantom04.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e2m3_phantom04);
end

script command_script cs_e2m3_phantom05
	f_load_phantom (sq_e2m3_phantom05, right, sq_e2m3_4mixed_03, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_phantom05);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep (30 * 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	cs_fly_to_and_face (ps_e2m3_phantom05.p0, ps_e2m3_phantom05.p0);
	f_unload_phantom (sq_e2m3_phantom05, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e2m3_phantom05.p1, ps_e2m3_phantom05.p1);
	sleep (30 * 10);
	cs_fly_to (ps_e2m3_phantom05.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e2m3_phantom05);
end

script command_script cs_e2m3_tempphantom01
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_template_phantom01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to (ps_e2m3_templatephantom01.p0);
	cs_fly_to_and_face (ps_e2m3_templatephantom01.p1, ps_e2m3_templatephantom01.p2);
	cs_fly_to_and_face (ps_e2m3_templatephantom01.p2, ps_e2m3_templatephantom01.p3);
	cs_fly_to_and_face (ps_e2m3_templatephantom01.p3, ps_e2m3_templatephantom01.p3);
	sleep (30 * 1);
	f_unload_phantom (sq_e2m3_template_phantom01, right);
	sleep (30 * 5);
	cs_fly_to (ps_e2m3_templatephantom01.p4);
	cs_fly_to (ps_e2m3_templatephantom01.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (sq_e2m3_template_phantom01);
end

script command_script cs_e2m3_tempphantom02
	f_load_phantom (sq_e2m3_template_phantom04, right, sq_e2m3_4eli_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_template_phantom04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_templatephantom02.p4, ps_e2m3_templatephantom02.p4);
	sleep (30 * 1);
	f_unload_phantom (sq_e2m3_template_phantom04, right);
	sleep (30 * 5);
	ai_set_objective (e2m3_phantomsquad_01, e2m3_followplayers);
	cs_fly_to (ps_e2m3_templatephantom04.p4);
end

script command_script cs_e2m3_tempphantom03
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_template_phantom03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to (ps_e2m3_templatephantom03.p0);
	cs_fly_to_and_face (ps_e2m3_templatephantom03.p1, ps_e2m3_templatephantom03.p2);
	cs_fly_to_and_face (ps_e2m3_templatephantom03.p2, ps_e2m3_templatephantom03.p2);
	sleep (30 * 1);
	f_unload_phantom (sq_e2m3_template_phantom03, right);
	sleep (30 * 5);
	cs_fly_to (ps_e2m3_templatephantom03.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (sq_e2m3_template_phantom03);
end

script command_script cs_e2m3_tempphantom04
	f_load_phantom (sq_e2m3_template_phantom04, left, sq_e2m3_4eli_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_template_phantom04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_templatephantom02.p4, ps_e2m3_templatephantom02.p4);
	sleep (30 * 1);
	f_unload_phantom (sq_e2m3_template_phantom04, left);
	sleep (30 * 5);
	ai_set_objective (e2m3_phantomsquad_01, e2m3_followplayers);
	cs_fly_to (ps_e2m3_templatephantom04.p4);
end

script command_script cs_e2m3_tempphantom05
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_template_phantom05);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_templatephantom05.p7, ps_e2m3_templatephantom05.p7);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 ); //Shrink size over time
	unit_set_current_vitality (ai_current_actor, 0.5, 1000);
	cs_fly_to (ps_e2m3_templatephantom05.p8);
end

script command_script cs_e2m3_pelican01
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e2m3_pelican_01.driver));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e2m3_pelican_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e2m3_pelican_01.p0, ps_e2m3_pelican_01.p0);
	cs_fly_to_and_face (ps_e2m3_pelican_01.p1, ps_e2m3_pelican_01.p1);
	cs_fly_to_and_face (ps_e2m3_pelican_01.p2, ps_e2m3_pelican_01.p2);
	e2m3_pelican_landed = TRUE;
	sleep_forever();
end

script command_script cs_e2m3_nokamikaze()
	ai_kamikaze_disable (ai_current_actor, TRUE);
end

//343++343==343++343==343++343	E2M3 Misc Scripts	343++343==343++343==343++343//


//	checks if Phantoms are ready to load
script continuous e2m3_phantom01_load01_checker
	sleep_until (LevelEventStatus ("e2m3_phntm1_1eli2jak"), 1);
	e2m3_phantom01_drop1eli2jak = TRUE;
	print ("e2m3_phantom01_drop1eli2jak = TRUE");
	sleep_forever();
end

script continuous e2m3_phantom01_load02_checker
	sleep_until (LevelEventStatus ("e2m3_phntm1_hunters"), 1);
	e2m3_phantom01_drophunters = TRUE;
	print ("e2m3_phantom01_drophunters = TRUE");
	sleep_forever();
end

//	objective change scripts
script continuous e2m3_changeobj_event
	sleep_until (LevelEventStatus ("e2m3_changeobj_all"), 1);
	wake (e2m3_changeobj_all);
end

script dormant e2m3_changeobj_all
	ai_set_objective (e2m3_ff_all, e2m3_followplayers);
	print ("objective for all squads changed");
end

script static void e2m3_changeobj_phansquads
//	ai_set_objective (gr_e2m3_phansquad_templates, e2m3_followplayers);
	print ("phantom template squads changed objectives");
end

//	Turn off device machines
script static void e2m3_turnoffdevices()
	print ("waiting til objects exist");
	sleep_until (object_valid (e2m3_dm_spire01), 1);
	sleep_until (object_valid (e2m3_dm_spire02), 1);
	sleep_until (object_valid (e2m3_dm_spire03a), 1);
	sleep_until (object_valid (e2m3_dm_spire03b), 1);
	print ("shutting down spires");
	device_set_position (e2m3_dm_spire01, 1);
	device_set_power (e2m3_dm_spire01, 0);
	device_set_position (e2m3_dm_spire02, 1);
	device_set_power (e2m3_dm_spire02, 0);
	device_set_position (e2m3_dm_spire03a, 1);
	device_set_power (e2m3_dm_spire03a, 0);
	device_set_position (e2m3_dm_spire03b, 1);
	device_set_power (e2m3_dm_spire03b, 0);
	print ("spires shut down");
end

//	Unblip all ammo/turrets
script static void e2m3_unblipping
	f_unblip_flag (e2m3_ammoblip_01);
	f_unblip_flag (e2m3_ammoblip_02);
	f_unblip_flag (e2m3_ammoblip_03);
	f_unblip_flag (e2m3_ammoblip_04);
	f_unblip_flag (e2m3_turretblip_01);
	f_unblip_flag (e2m3_turretblip_03);
	f_unblip_flag (e2m3_turretblip_04);
	print ("everything is unblipped");
end
