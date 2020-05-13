//=============================================================================================================================
//============================================ CHOPPER BOWL FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
global cutscene_title title_switch_obj_1 = switch_obj_1;
global cutscene_title title_swarm_1 = swarm_1;
global cutscene_title title_lz_end = lz_end;
global cutscene_title	title_more_enemies = more_enemies;
global cutscene_title	title_not_many_left = not_many_left;
global cutscene_title title_defend_base_safe = defend_base_safe;
global cutscene_title title_power_cut = power_cut;
global cutscene_title title_objective_3 = objective_3;
global cutscene_title title_shut_down_comm = shut_down_comm;
global cutscene_title title_first_tower_down = first_tower_down;
global cutscene_title title_both_tower_down = both_tower_down;
global boolean endbliploop = FALSE;
global boolean e1m1_phantom02_unload = FALSE;
global boolean e1m1_phantom03_unload = FALSE;
global boolean e1m1_droppods_follow = FALSE;
global boolean e1m1_marineveh_bowl = FALSE;
global boolean e1m1_marineveh_hill = FALSE;
global boolean f_narrativein_done = FALSE;
global boolean e1m1_loadout_done = FALSE;
global boolean e1m1_leaveplateau = FALSE;
global boolean e1m1_move_to_hill = FALSE;
global boolean mission_is_e1_m1 = FALSE;
global boolean e1m1_add_objblips = FALSE;
global boolean e1m1_coresdestroyed = FALSE;
global boolean e1m1_stoprespawningvehicles = FALSE;
global short e1m1_objectives_still_alive = 0;
global ai ai_ff_allies_1 = gr_ff_allies_1;
global ai ai_ff_allies_2 = gr_ff_allies_2;
global short e1m1_player_in_vehicle = 0;


script startup chopper_bowl
	thread (e1m1_zoneset());
	title_lz_end = lz_end;
	title_switch_obj_1 = switch_obj_1;
//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	wake (firefight_lost_game);
	wake (firefight_won_game);
	firefight_player_goals();
	print ("goals ended");
	print ("game won");
	//mp_round_end();
  b_game_won = true;
end

//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 01: Mission 01																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//

script static void e1m1_zoneset()
	sleep_until (LevelEventStatus ("e1m1_zoneset"), 1);
	f_narrativein_done = FALSE;
	e1m1_loadout_done = FALSE;
	thread(f_music_e1m1_start());
	ai_ff_all = gr_ff_all;
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	switch_zone_set (e1m1);
	thread (e1m1_towerbase_destroy());
	dm_droppod_1 = dm_drop_01;
	dm_droppod_2 = dm_drop_02;
	dm_droppod_3 = dm_drop_03;
	dm_droppod_4 = dm_drop_04;
	dm_droppod_5 = dm_drop_05;
	e1m1_leaveplateau = FALSE;
	e1m1_coresdestroyed = FALSE;
	kill_volume_disable (kill_soft_e3_m1_vip);
	kill_volume_disable (kill_e3_m1_tower_1);
	kill_volume_disable (kill_e3_m1_tower_2);
	effects_perf_armageddon = TRUE;
	// set crate folder names
	f_add_crate_folder(v_cov_e1m1); //Covenant vehicles on the mesa
	f_add_crate_folder(v_unsc_e1m1); //UNSC vehicles on the mesa
	f_add_crate_folder(v_turret_e1m1); //UNSC vehicles on the mesa
	f_add_crate_folder(e1m1_towers); //e1m1 - towers (base and floating part).
	f_add_crate_folder(e1m1_weaponcrates); //e1m1 - weapon crates (cov)
	f_add_crate_folder(e1m1_props); //e1m1 - antennae, storage crates, etc.
	f_add_crate_folder(e1m1_barriers); //e1m1 - barriers and blockades.	
	
	// Set Spawn Folders	
	firefight_mode_set_crate_folder_at(spawn_points_0, 90);					//	2nd Spawn Area for E1M1	
	firefight_mode_set_crate_folder_at(e1m1_second_spawn, 91);					//	2nd Spawn Area for E1M1	
	firefight_mode_set_crate_folder_at(e1m1_third_spawn, 92);					//	3rd Spawn Area for E1M1	
	
	// Set objective names
	firefight_mode_set_objective_name_at(e1m1_covpowercore_01, 1); //objective in the left building
	firefight_mode_set_objective_name_at(e1m1_covpowercore_02, 13); //objective in the middle back building
	firefight_mode_set_objective_name_at(e1m1_covpowercore_03, 14); //objective in the middle back building
	firefight_mode_set_objective_name_at(e1m1_covpowercore_04, 30); //objective on the left side of the bowl
	
	// Set Location Names	
	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the middle back building
	mission_is_e1_m1 = true;
	
	sound_impulse_start (vo_swarm_1, none, 1.0);
	
	thread (e1_m1_intro());
	thread (e1m1_towerpower());
	thread (e1m1_plateaucore());
	thread (e1m1_respawnvehicles());
	thread (e1m1_phantom02_dropoff());
	thread (e1m1_phantom02_5_dropoff());
	thread (e1m1_phantom01_dropoff());
	thread (cont_e1m1_phantom02_unload());
	thread (cont_e1m1_phantom03_unload());
	
	firefight_mode_set_player_spawn_suppressed(TRUE);
	if editor_mode() then
		thread (e1m1_chokepoint_enemies());
		NotifyLevel ("start_intro");
		e1m1_loadout_done = TRUE;
		f_narrativein_done = TRUE;
		thread(f_music_e1m1_cinematic_finish());
		ai_erase (sq_e1m1_warthog);
		firefight_mode_set_player_spawn_suppressed(FALSE);
		b_wait_for_narrative_hud = TRUE;
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
		b_end_player_goal = TRUE;
		NotifyLevel ("e1m1_pelican_should_leave");
		thread (e1m1_objective01_title());
		thread (e1m1_marines_destroy_object_01());
	else
		thread (e1m1_chokepoint_enemies());
		sleep_until (LevelEventStatus ("loadout_screen_complete"), 1);
		NotifyLevel ("start_intro");
		e1m1_loadout_done = TRUE;
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e1m1_vin_sfx_intro', NONE, 1);
		cinematic_start();
		thread(f_music_e1m1_cinematic_start());
		thread (e1m1_pup_in());
		sleep_until (f_narrativein_done == TRUE);
		cinematic_stop();
		thread(f_music_e1m1_cinematic_finish());
		ai_erase (sq_e1m1_warthog);
		firefight_mode_set_player_spawn_suppressed(FALSE);
		b_end_player_goal = TRUE;
		b_wait_for_narrative_hud = TRUE;
		object_destroy (e1m1_starttower01);
		object_destroy (e1m1_towerbase_06);
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
		NotifyLevel ("e1m1_pelican_should_leave");
		thread (e1m1_objective01_title());
		thread (e1m1_marines_destroy_object_01());
	end
end

script static void e1m1_towerbase_destroy()
	print ("CRATE ERASE WAITING UNTIL LOADOUT DONE");
	sleep_until (e1m1_loadout_done == TRUE, 1);
	print ("LOADOUT IS DONE, PREPPING TO DELETE EXTRA TOWERS");
	sleep_until (object_valid (e3_m1_base1_pod), 1);
	object_destroy (e3_m1_base1_pod);
	sleep_until (object_valid (e3_m1_base2), 1);
	object_destroy (e3_m1_base2);
	sleep_until (object_valid (e3_m1_base2_pod), 1);
	object_destroy (e3_m1_base2_pod);
	sleep_until (object_valid (e3_m1_base3), 1);
	object_destroy (e3_m1_base3);
	sleep_until (object_valid (e3_m1_base3_pod), 1);
	object_destroy (e3_m1_base3_pod);
	sleep_until (object_valid (e3_m1_base4), 1);
	object_destroy (e3_m1_base4);
	sleep_until (object_valid (e3_m1_base4_pod), 1);
	object_destroy (e3_m1_base4_pod);
	print ("EXTRA TOWERS DELETED");
	sleep_until (object_valid (e3_m1_base1), 1);
	object_destroy (e3_m1_base1);
	sleep_until (object_valid (e3_m1_small_bridge), 1);
	object_destroy (e3_m1_small_bridge);
	object_destroy (e3_m1_bridge_cache_base1);
	object_destroy (e3_m1_bridge_cache_base2);
	object_destroy (e1m1_starttower01);
	object_destroy (e1m1_towerbase_06);
end

script static void e1m1_marines_destroy_object_01()
	repeat
		if (volume_test_players (tv_e1m1_core01) and (object_get_health (e1m1_covpowercore_01) > 0))	then
			ai_object_set_team (e1m1_covpowercore_01, covenant);
			object_set_allegiance (e1m1_covpowercore_01, covenant);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_01, TRUE);
			ai_object_set_targeting_bias (e1m1_covpowercore_01, .75);
			//cs_shoot (e01m01_marines, TRUE, e1m1_covpowercore_01);
			print ("Marines targeting Core 01");
			sleep_until (not volume_test_players (tv_e1m1_core01), 1);
			ai_object_set_targeting_bias (e1m1_covpowercore_01, 0);
			//cs_shoot (e01m01_marines, FALSE, e1m1_covpowercore_01);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_01, FALSE);
			print ("Marines NOT targeting Core 01");
			
		elseif	(volume_test_players (tv_e1m1_core02) and (object_get_health (e1m1_covpowercore_02) > 0))	then
			ai_object_set_team (e1m1_covpowercore_02, covenant);
			object_set_allegiance (e1m1_covpowercore_02, covenant);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_02, TRUE);
			ai_object_set_targeting_bias (e1m1_covpowercore_02, .75);
			//cs_shoot (e01m01_marines, TRUE, e1m1_covpowercore_02);
			print ("Marines targeting Core 02");
			sleep_until (not volume_test_players (tv_e1m1_core02), 1);
			ai_object_set_targeting_bias (e1m1_covpowercore_02, 0);
			//cs_shoot (e01m01_marines, FALSE, e1m1_covpowercore_02);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_02, FALSE);
			print ("Marines NOT targeting Core 02");
			
		elseif	(volume_test_players (tv_e1m1_core03) and (object_get_health (e1m1_covpowercore_03) > 0))	then
			ai_object_set_team (e1m1_covpowercore_03, covenant);
			object_set_allegiance (e1m1_covpowercore_03, covenant);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_03, TRUE);
			ai_object_set_targeting_bias (e1m1_covpowercore_03, .75);
			//cs_shoot (e01m01_marines, TRUE, e1m1_covpowercore_03);
			print ("Marines targeting Core 03");
			sleep_until (not volume_test_players (tv_e1m1_core03), 1);
			ai_object_set_targeting_bias (e1m1_covpowercore_03, 0);
			//cs_shoot (e01m01_marines, FALSE, e1m1_covpowercore_03);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_03, FALSE);
			print ("Marines NOT targeting Core 03");
			
		elseif	(volume_test_players (tv_e1m1_core04) and (object_get_health (e1m1_covpowercore_04) > 0))	then
			ai_object_set_team (e1m1_covpowercore_04, covenant);
			object_set_allegiance (e1m1_covpowercore_04, covenant);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_04, TRUE);
			ai_object_set_targeting_bias (e1m1_covpowercore_04, .75);
			//cs_shoot (e01m01_marines, TRUE, e1m1_covpowercore_04);
			print ("Marines targeting Core 04");
			sleep_until (not volume_test_players (tv_e1m1_core04), 1);
			ai_object_set_targeting_bias (e1m1_covpowercore_04, 0);
			//cs_shoot (e01m01_marines, FALSE, e1m1_covpowercore_04);
			ai_object_enable_targeting_from_vehicle (e1m1_covpowercore_04, FALSE);
			print ("Marines NOT targeting Core 04");
		
		else (sleep (30 * 1));
		end
		sleep (5);
	until (e1m1_objectives_still_alive == 4);
end


script static void e1_m1_intro()
	sleep_until (LevelEventStatus ("start_intro"), 1);
	thread(f_music_e1m1_intro());
	ai_set_objective (squads_0,obj_marines);
	ai_set_objective (squads_1,obj_marines);
end

script static void e1m1_respawnvehicles()
	repeat
		object_create_anew (e1m1_startghost03);
		object_create_anew (e1m1_startghost04);
		object_create_anew (e1m1_startghost01);
		object_create_anew (e1m1_startghost02);
		object_create_anew (e1m1_ghost23);
		object_create_anew (e1m1_ghost24);
		object_create_anew (e1m1_ghost13);
		object_create_anew (e1m1_ghost14);
		object_create_anew (e1m1_wraith01);
		object_create_anew (e1m1_wraith02);
		object_create_anew (e1m1_startwraith02);
		object_create_anew (e1m1_startwraith03);
		sleep (30 * 120);
	until (e1m1_stoprespawningvehicles == TRUE);
end

//343++343==343++343==343++343//	E5M5 Goal 01 Scripts (1. object_destruction)	//343++343==343++343==343++343//

script static void e1m1_chokepoint_enemies
	sleep_until (f_narrativein_done == TRUE);
	sleep_until (b_players_are_alive(), 1);
	thread(f_music_e1m1_chokepoint_enemies());
	thread (e1m1_waking_vo());
	thread (e1m1_players_enter_vehicle_vo());
	thread (e1m1_respawn_obj_01());
	thread (e1m1_marines_vehicles_obj());
	ai_place (e01m01_marines);
	ai_place (sq_1eli_wraith);
	ai_place (sq_e1m1_1ghost_01);
	ai_place (sq_e1m1_gruntshade_03);
	ai_place (sq_e1m1_gruntshade_04);
	ai_place (sq_e1m1_gruntshade_05);
	ai_place (sq_e1m1_gruntturret_01);
	ai_place (sq_e1m1_2eli_01);
	ai_place (sq_e1m1_gruntsghosts_01);
	ai_place (sq_e1m1_gruntshade_01);
	ai_place (sq_e1m1_gruntshade_02);
	ai_place (sq_e1m1_eliteshade_02);
	ai_place (sq_e1m1_gruntturret_02);
	ai_place (sq_e1m1_gruntturret_03);
	ai_place (sq_e1m1_gruntturret_04);
	ai_place (sq_e1m1_gruntturret_05);
	ai_place (sq_e1m1_eliteshade_01);
	ai_place (sq_e1m1_pelican_02);
	thread (e1m1_no_more_waves_01());
end

script static void e1m1_phantom02_dropoff
	print ("phantom02_dropoff script is on and waiting");
	sleep_until (LevelEventStatus ("e1m1_phan03_drop"), 1);
	ai_place (sq_e1m1_1eliwraith_02);
	ai_place_in_limbo (sq_e1m1_phantom_02);
	print ("phantom02_dropoff phantom has spawned and is bringing a wraith.");
	thread (vo_e1m1_phantom());
	thread(f_music_e1m1_phantom02_dropoff());
end

script static void e1m1_phantom02_5_dropoff
	sleep_until (LevelEventStatus ("e1m1_phantom02_5_start"), 1);
	ai_place (sq_e1m1_1gru_02);
	ai_place (sq_e1m1_1gru_03);
	ai_place_in_limbo (sq_e1m1_phantom_02_5);
end

script static void e1m1_phantom01_dropoff
	sleep_until (LevelEventStatus ("e1m1_phan01_drop"), 1);
	ai_place (sq_e1m1_1eliwraith_03);
	ai_place_in_limbo (sq_e1m1_phantom_01);
	thread (vo_e1m1_phantom_2());
	thread(f_music_e1m1_phantom01_dropoff());
end

script static void cont_e1m1_phantom02_unload
	sleep_until (LevelEventStatus ("e1m1_phan02_drop"), 1);
	e1m1_phantom02_unload = TRUE;
	print ("e1m1_phantom02_unload = TRUE");
	thread(f_music_e1m1_phantom02_unload());
end

script static void cont_e1m1_phantom03_unload
	sleep_until (LevelEventStatus ("e1m1_phan03_drop"), 1);
	e1m1_phantom03_unload = TRUE;
	print ("e1m1_phantom03_unload = TRUE");
	thread(f_music_e1m1_phantom03_unload());
end

script static void e1m1_respawn_obj_01
	sleep_until (e1m1_objectives_still_alive > 0);
	f_create_new_spawn_folder (91);
	dprint ("second spawn area is active");
end

//	For Power Cores
script static void e1m1_plateaucore()
	sleep_until (object_valid (e1m1_covpowercore_01));
	print ("Powercore 01 ready and waiting. To die.");
	sleep (15);
	sleep_until (object_get_health (e1m1_covpowercore_01) <= 0);
	print ("plateau core destroyed, moving troops");
	e1m1_leaveplateau = TRUE;
end

script static void e1m1_waking_vo()
	thread (e1m1_objective_narrative_count_setup_01());
	thread (e1m1_objective_narrative_count_setup_02());
	thread (e1m1_objective_narrative_count_setup_03());
	thread (e1m1_objective_narrative_count_setup_04());
	thread (e1m1_1_obj_destroyed());
	thread (e1m1_2_obj_destroyed());
	thread (e1m1_3_obj_destroyed());
	thread (e1m1_4_obj_destroyed());
end

script static void e1m1_objective_narrative_count_setup_01
	sleep_until (object_get_health (e1m1_covpowercore_01) == 0);
	e1m1_objectives_still_alive = e1m1_objectives_still_alive + 1;
end

script static void e1m1_objective_narrative_count_setup_02
	sleep_until (object_get_health (e1m1_covpowercore_02) == 0);
	e1m1_objectives_still_alive = e1m1_objectives_still_alive + 1;
end

script static void e1m1_objective_narrative_count_setup_03
	sleep_until (object_get_health (e1m1_covpowercore_03) == 0);
	e1m1_objectives_still_alive = e1m1_objectives_still_alive + 1;
end

script static void e1m1_objective_narrative_count_setup_04
	sleep_until (object_get_health (e1m1_covpowercore_04) == 0);
	e1m1_objectives_still_alive = e1m1_objectives_still_alive + 1;
end

script static void e1m1_1_obj_destroyed
	sleep_until (e1m1_objectives_still_alive == 1);
	thread (vo_e1m1_firstcore());
	thread(f_music_e1m1_first_core_destroyed());
end

script static void e1m1_2_obj_destroyed
	sleep_until (e1m1_objectives_still_alive == 2);
	thread (vo_e1m1_secondcore());
	thread(f_music_e1m1_second_core_destroyed());
	thread (e1m1_marinesmademortal());
end

script static void e1m1_3_obj_destroyed
	sleep_until (e1m1_objectives_still_alive == 3);
	thread (vo_e1m1_thirdcore());
	thread(f_music_e1m1_third_core_destroyed());
end

script static void e1m1_4_obj_destroyed
	sleep_until (e1m1_objectives_still_alive == 4);
	thread (vo_e1m1_lastcore());
	thread(f_music_e1m1_fourth_core_destroyed());
end

//	When a player gets in a vehicle for the first time
script static void e1m1_players_enter_vehicle_vo()
	sleep_until (player_in_vehicle (e1m1_startwraith01) == TRUE or
							 player_in_vehicle (e1m1_startwraith02) == TRUE or 
							 player_in_vehicle (e1m1_startwraith03) == TRUE or 
							 player_in_vehicle (e1m1_startghost01) == TRUE or 
							 player_in_vehicle (e1m1_startghost02) == TRUE or 
							 player_in_vehicle (e1m1_startghost03) == TRUE or 
							 player_in_vehicle (e1m1_startghost04) == TRUE or 
							 player_in_vehicle (e1m1_ghost24) == TRUE, 1);
	sleep (30 * 2);
	thread(f_music_e1m1_enter_vehicle_vo());
	thread (vo_e1m1_entervehicle());
	print ("enter vehicle VO time");
end

//	Objectives VO
script static void e1m1_objective01_title
	sleep_until (b_wait_for_narrative_hud == FALSE);
	f_new_objective (e1m1_objective01);
	thread(f_music_e1m1_objective01_title());
end



//343++343==343++343==343++343//	E5M5 Goal 02 Scripts (2. no_more_waves)	//343++343==343++343==343++343//

script static void e1m1_no_more_waves_01()
	sleep_until (LevelEventStatus ("e1m1_nomorewaves01"), 1);
	thread (e1m1_locationarrival());
	thread (e1m1_lz_arrival());
	thread (e1m1_phantom04());
	thread (e1m1_phantom05());
	thread (e1m1_droppod01());
	thread (e1m1_droppod02());
	thread (e1m1_droppod03());
	thread (e1m1_droppod04());
	thread (e1m1_droppod05());
	thread (e1m1_phantom06());
	thread (e1m1_phantom07());
	thread (vo_e1m1_securearea());
	e1m1_coresdestroyed = TRUE;
	sleep (30 * 3);
	f_objective_complete();
	thread (f_music_e1m1_no_more_waves_01_vo());
	sleep (30 * 3);
end

script static void e1m1_marinesmademortal
	sleep (30 * 1);
	ai_cannot_die (e01m01_marines, FALSE);
	sleep (30 * 1);
	object_immune_to_friendly_damage ( ai_actors (e01m01_marines), TRUE);
end	

script static void e1m1_phantom04()
	sleep_until (LevelEventStatus ("e1m1_phan04"), 1);
	ai_place (sq_e1m1_1ghost_02);
	ai_place (sq_e1m1_1ghost_03);
	ai_place_in_limbo (sq_e1m1_phantom_04);
	thread (f_music_e1m1_phantom04());
	thread (vo_e1m1_covenant_04());
end

script static void e1m1_phantom05
	sleep_until (LevelEventStatus ("e1m1_phan05"), 1);
	ai_place (sq_e1m1_wraithgunner_01);
	ai_place_in_limbo (sq_e1m1_phantom_05);
	thread (f_music_e1m1_phantom05());
end

script static void e1m1_droppod01
	sleep_until (LevelEventStatus ("e1m1_pod01"), 1);
	thread (vo_e1m1_droppodcallout_01());
	ai_place_in_limbo (sq_e1m1_4eliranger_01);
	thread (f_load_drop_pod (dm_drop_01, sq_e1m1_4eliranger_01, e1m1_droppod_01, FALSE));
	thread(f_music_e1m1_droppod_01());
	ai_set_task (gr_e1m1_gruntturrets, obj_e1m1_followplayer, followplayer_gruntturrets);
	sleep_until (ai_living_count (sq_e1m1_4eliranger_01) <= 0, 1);
	sleep (30 * 2);
	thread (vo_e1m1_congrats01());
end

script static void e1m1_droppod02
	sleep_until (LevelEventStatus ("e1m1_pod02"), 1);
	ai_place_in_limbo (sq_e1m1_6grunts_01);
	thread (f_load_drop_pod (dm_drop_02, sq_e1m1_6grunts_01, e1m1_droppod_02, FALSE));
	thread(f_music_e1m1_droppod_02());
end

script static void e1m1_droppod03
	sleep_until (LevelEventStatus ("e1m1_pod03"), 1);
	thread (vo_e1m1_droppodcallout_02());
	ai_place_in_limbo (sq_e1m1_4grunts_02);
	thread (f_load_drop_pod (dm_drop_03, sq_e1m1_4grunts_02, e1m1_droppod_03, FALSE));
	thread(f_music_e1m1_droppod_03());
	f_blip_ai_cui (gr_ff_all, "navpoint_enemy");
	f_new_objective (e1m1_objective02);
end

script static void e1m1_droppod04
	sleep_until (LevelEventStatus ("e1m1_pod04"), 1);
	ai_place_in_limbo (sq_e1m1_4eliac_02);
	thread (f_load_drop_pod (dm_drop_04, sq_e1m1_4eliac_02, e1m1_droppod_04, FALSE));
	thread(f_music_e1m1_droppod_04());
end

script static void e1m1_droppod05
	sleep_until (LevelEventStatus ("e1m1_pod05"), 1);
	thread (vo_e1m1_droppodcallout_03());
	ai_place_in_limbo (sq_e1m1_6grunts_02);
	thread (f_load_drop_pod (dm_drop_05, sq_e1m1_6grunts_02, e1m1_droppod_05, FALSE));
	thread(f_music_e1m1_droppod_05());
end

script static void e1m1_phantom07
	sleep_until (LevelEventStatus ("e1m1_phan07"), 1);
	thread (vo_e1m1_phantom_3());
	ai_place (sq_e1m1_wraithgunner_02);
	ai_place_in_limbo (sq_e1m1_phantom_07);
	e1m1_move_to_hill = TRUE;
	//thread (e1m1_killtowers());
end

script static void e1m1_phantom06
	sleep_until (LevelEventStatus ("e1m1_phan06"), 1);
	thread (vo_e1m1_covenant_02());
	ai_place_in_limbo (sq_e1m1_phantom_06);
	thread(f_music_e1m1_phantom06());
	thread (e1m1_gettohill_end());
	f_create_new_spawn_folder (90);
	//thread (e1m1_killtowers());
end

script static void e1m1_gettohill_end()
	ai_set_task ( sq_e1m1_4eliranger_01, obj_e1m1_hillbattle, gettohill_defend);
	ai_set_task ( sq_e1m1_6grunts_01, obj_e1m1_hillbattle, gettohill_defend);
	ai_set_task ( sq_e1m1_4grunts_02, obj_e1m1_hillbattle, gettohill_defend);
	ai_set_task ( sq_e1m1_4eliac_02, obj_e1m1_hillbattle, gettohill_defend);
	ai_set_task ( sq_e1m1_6grunts_02, obj_e1m1_hillbattle, gettohill_defend);
	ai_set_task ( sq_e1m1_1eliwraith_02, obj_e1m1_rightside_vehicle, follow_player);
	sleep_until (ai_living_count (gr_ff_all) <= 16);
	f_blip_ai_cui (gr_ff_all, "navpoint_enemy");
	e1m1_droppods_follow = TRUE;
	//thread (e1m1_killtowers());
	ai_set_task (gr_e1m1_gruntturrets, obj_e1m1_followplayer, followplayer_gruntturrets);
	ai_set_task ( sq_e1m1_1eliwraith_02, obj_e1m1_rightside_vehicle, follow_player);
	sleep_until (ai_living_count (gr_ff_all) <= 5);
	thread (vo_e1m1_justafewleft());
	sleep (30 * 2);
	//thread (e1m1_killtowers());
	sleep_until (e1m1_narrative_is_on == FALSE);
	//thread (e1m1_killtowers());
	f_blip_ai (gr_ff_all, neutralize);
	ai_set_task ( sq_e1m1_1eliwraith_02, obj_e1m1_rightside_vehicle, follow_player);
	sleep_until (ai_living_count (gr_ff_all) <= 3);
	//thread (e1m1_killtowers());
	ai_set_task (gr_ff_all, obj_e1m1_followplayer, followplayer);
	sleep (10);
	ai_set_task ( sq_e1m1_1eliwraith_02, obj_e1m1_rightside_vehicle, follow_player);
end

//343++343==343++343==343++343//	E5M5 Goal 03 Scripts (3. location_arrival)	//343++343==343++343==343++343//

script static void e1m1_locationarrival
	sleep_until (LevelEventStatus ("e1m1_locationarrival"), 1);
	thread(f_music_e1m1_locationarrival());
	thread (e1m1_pelican_returns());
	b_wait_for_narrative_hud = TRUE;
	sleep (30 * 3);
	thread (vo_e1m1_gettolz());
	f_objective_complete();
	thread(f_music_e1m1_gettolz_vo());
	sleep (30 * 3);
	f_new_objective (e1m1_objective03);
	e1m1_stoprespawningvehicles = TRUE;
end

script static void e1m1_pelican_returns()
	ai_place_in_limbo (sq_e1m1_pelican_01);
end

//343++343==343++343==343++343//	E5M5 Goal 02 Scripts (4. time_passed)	//343++343==343++343==343++343//

script static void e1m1_lz_arrival()
	sleep_until (LevelEventStatus ("e1m1_atthelz"), 1);
	sleep_until (e1m1_narrative_is_on == FALSE);
	thread(f_music_e1m1_lzcomplete());
	sleep (30 * 4);
	vo_e1m1_arrivelz();
	sleep (30 * 1);
	f_objective_complete();
	sleep_until (e1m1_narrative_is_on == FALSE);
	sleep (30 * 2);
	thread(f_music_e1m1_finish());
	//turn on the chapter complete screen_effect_new
	fade_out (0, 0, 0, 15);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	f_hide_players_outro();
	print ("DONE!");
	sleep (30 * 2);
	b_end_player_goal = true;
end

script static void f_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end

//343++343==343++343==343++343	E1M1 Placement Scripts	343++343==343++343==343++343//


//	New Grav Tower Scripts

script command_script cs_e1m1_gruturr01
	//vehicle (e1m1_chokepoint_tower);
	//sleep (15);
	//ai_vehicle_enter_immediate (sq_e1m1_gruntturret_01, object_at_marker (e1m1_chokepoint_tower, plasma_turret_01));
	sleep( 30 * 1);
	//vehicle_load_magic (object_at_marker (e1m1_chokepoint_tower, plasma_turret_01), turret_g, ai_get_unit (sq_e1m1_gruntturret_01.gunner));
	ai_vehicle_enter (sq_e1m1_gruntturret_01, (object_get_turret (e1m1_chokepoint_tower, 2)));

end

script command_script cs_e1m1_gruturr02
	sleep( 30 * 1);
	ai_vehicle_enter (sq_e1m1_gruntturret_02, (object_get_turret (e1m1_bowl_tower, 2)));
end

script command_script cs_e1m1_gruturr03
	sleep( 30 * 1);
	ai_vehicle_enter (sq_e1m1_gruntturret_03, (object_get_turret (e1m1_bowl_tower, 1)));
end

script command_script cs_e1m1_gruturr04
	sleep( 30 * 1);
	ai_vehicle_enter (sq_e1m1_gruntturret_04, (object_get_turret (e1m1_bowlflats_tower, 2)));
end

script command_script cs_e1m1_gruturr05
	sleep( 30 * 1);
	ai_vehicle_enter_immediate (sq_e1m1_gruntturret_05, (object_get_turret (e1m1_bowlright_tower, 1)));
end

//	sq_e1m1_gruntturret_04	e1m1_bowlflats_tower
//	sq_e1m1_gruntturret_03	e1m1_bowl_tower
//	sq_e1m1_gruntturret_02	e1m1_bowl_tower
//	sq_e1m1_gruntturret_05	e1m1_bowlright_tower

script command_script cs_immortal_marines
	sleep (30 * 1);
	ai_cannot_die (ai_current_actor, TRUE);
end

script command_script cs_e1m1_shadegrunt01
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade01);
	dprint ("Shadegrunt 01 moving to vehicle");
end

script command_script cs_e1m1_shadegrunt02
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade02);
	dprint ("Shadegrunt 02 moving to vehicle");
end

script command_script cs_e1m1_shadegrunt03
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade03);
	dprint ("Shadegrunt 03 moving to vehicle");
end

script command_script cs_e1m1_shadegrunt04
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade04);
	dprint ("Shadegrunt 04 moving to vehicle");
end

script command_script cs_e1m1_shadegrunt05
	sleep (30 * 1);
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade05);
	dprint ("Shadegrunt 05 moving to vehicle");
end

script command_script cs_e1m1_shadeelite01
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade06);
	dprint ("Shade Elite 01 moving to vehicle");
end

script command_script cs_e1m1_shadeelite02
	ai_vehicle_enter_immediate (ai_current_actor, e1m1_shade07);
	dprint ("Shade Elite 02 moving to vehicle");
end

script command_script cs_e1m1_gruntghost_04
	sleep (30 * 5);
	//cs_go_to_vehicle (e1m1_gruntghost);
	//ai_vehicle_enter (ai_current_actor, e1m1_gruntghost);
	dprint ("grunt 04 in ghost 04");
end

//	Phantom Scripts

script command_script cs_e1m1_phantom01
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_1eliwraith_03.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e1m1_phantom01.p0, ps_e1m1_phantom01.p0);
	cs_fly_to_and_face (ps_e1m1_phantom01.p1, ps_e1m1_phantom01.p1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_01.driver ), "phantom_lc" );
	sleep (30 * 3);
	sleep_until (e1m1_phantom02_unload == TRUE);
	print ("PHANTOM 1, e1m1_phantom02_unload == TRUE");
	f_load_phantom (sq_e1m1_phantom_01, right, sq_e1m1_2gru_02, none, none, none);
	dprint ("phantom 01 loaded. preparing to unload.");
	sleep (30 * 1);
	f_unload_phantom (sq_e1m1_phantom_01, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e1m1_phantom01.p2, ps_e1m1_phantom01.p2);
	cs_fly_to_and_face (ps_e1m1_phantom01.p3, ps_e1m1_phantom01.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e1m1_phantom_01);
end


script command_script cs_e1m1_phantom02
	f_load_phantom (sq_e1m1_phantom_02, left, none, none, sq_e1m1_1eli_01, sq_e1m1_1eli_02);
	//f_load_phantom (sq_e1m1_phantom_02, right, sq_e1m1_1gru_04, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_02.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_1eliwraith_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom02.p1, ps_e1m1_phantom02.p1);
	cs_fly_to_and_face (ps_e1m1_phantom02.p2, ps_e1m1_phantom02.p2);
	print ("Phantom moved to first stop");
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_02.driver ), "phantom_lc" );
	//	VO FOR WRAITH
	thread (vo_e1m1_wraith());
	sleep (30 * 1);
	//f_unload_phantom (sq_e1m1_phantom_02, right);
	sleep (30 * 5);
	NotifyLevel ("e1m1_phantom02_5_start");
	cs_fly_to_and_face (ps_e1m1_phantom02.p3, ps_e1m1_phantom02.p3, 1);
	cs_fly_to_and_face (ps_e1m1_phantom02.p4, ps_e1m1_phantom02.p4, 1);
	cs_fly_to_and_face (ps_e1m1_phantom02.p5, ps_e1m1_phantom02.p5, 1);
	sleep( 30 * 1);
	f_unload_phantom (sq_e1m1_phantom_02, left);
	//	VO FOR FIRST COVENANT REINFORCEMENTS
	thread (vo_e1m1_covenant_01());
	sleep (30 * 5);
	print ("Phantom going bye-bye now");
	cs_fly_to_and_face (ps_e1m1_phantom02.p7, ps_e1m1_phantom02.p7);
	cs_fly_to_and_face (ps_e1m1_phantom02.p8, ps_e1m1_phantom02.p8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_02);
end

script command_script cs_e1m1_phantom02_5
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_02_5.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_1gru_02.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_02_5.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e1m1_1gru_03.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_02_5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom02_5.p0, ps_e1m1_phantom02_5.p0);
	cs_fly_to_and_face (ps_e1m1_phantom02_5.p1, ps_e1m1_phantom02_5.p1);
	cs_fly_to_and_face (ps_e1m1_phantom02_5.p2, ps_e1m1_phantom02_5.p2);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_02_5.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_02_5.driver ), "phantom_sc" );
	f_blip_ai_cui (sq_e1m1_1gru_02, "navpoint_enemy");
	f_blip_ai_cui (sq_e1m1_1gru_03, "navpoint_enemy");
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e1m1_phantom02_5.p3, ps_e1m1_phantom02_5.p3);
	cs_fly_to_and_face (ps_e1m1_phantom02_5.p4, ps_e1m1_phantom02_5.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_02_5);
end

script command_script cs_e1m1_phantom_03
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_03.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_1eli_wraith.driver ) );
	ai_set_blind (sq_e1m1_phantom_03, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom03.p0, ps_e1m1_phantom03.p0);
	cs_fly_to_and_face (ps_e1m1_phantom03.p1, ps_e1m1_phantom03.p1);
	cs_fly_to_and_face (ps_e1m1_phantom03.p2, ps_e1m1_phantom03.p2);
	NotifyLevel ("eaglehaslanded");
	print ("Eagle has landed. Loading the rest of the enemies");
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_03.driver ), "phantom_lc" );
	cs_fly_to_and_face (ps_e1m1_phantom03.p3, ps_e1m1_phantom03.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_03);
end


script command_script cs_e1m1_phantom04
	f_load_phantom (sq_e1m1_phantom_04, right, sq_e1m1_4eliac_01, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_04.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_1ghost_02.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_04.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e1m1_1ghost_03.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom04.p1, ps_e1m1_phantom04.p1);
	cs_fly_to_and_face (ps_e1m1_phantom04.p2, ps_e1m1_phantom04.p2);
	cs_fly_to_and_face (ps_e1m1_phantom04.p3, ps_e1m1_phantom04.p3);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_04.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_04.driver ), "phantom_sc" );
	sleep (30);
	f_unload_phantom (sq_e1m1_phantom_04, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e1m1_phantom04.p2, ps_e1m1_phantom04.p2);
	cs_fly_to_and_face (ps_e1m1_phantom04.p6, ps_e1m1_phantom04.p6);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_04);
end

script command_script cs_e1m1_phantom05
	f_load_phantom (sq_e1m1_phantom_05, right, sq_e1m1_4grunts_01, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_05.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_wraithgunner_01.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_05);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom05.p1, ps_e1m1_phantom05.p1);
	cs_fly_to_and_face (ps_e1m1_phantom05.p2, ps_e1m1_phantom05.p2);
	cs_fly_to_and_face (ps_e1m1_phantom05.p3, ps_e1m1_phantom05.p3);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_05.driver ), "phantom_lc" );
	sleep (30 * 2);
	f_unload_phantom (sq_e1m1_phantom_05, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e1m1_phantom05.p4, ps_e1m1_phantom05.p4);
	cs_fly_to_and_face (ps_e1m1_phantom05.p5, ps_e1m1_phantom05.p5);
	cs_fly_to_and_face (ps_e1m1_phantom05.p6, ps_e1m1_phantom05.p6);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_05);
end

script command_script cs_e1m1_phantom06
	f_load_phantom (sq_e1m1_phantom_06, left, sq_e1m1_3eli_01, sq_e1m1_3gru_01, sq_e1m1_2eli_02, sq_e1m1_2gru_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_06);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	f_blip_object (ai_vehicle_get_from_spawn_point (sq_e1m1_phantom_06.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e1m1_phantom06.p1, ps_e1m1_phantom06.p1);
	cs_fly_to_and_face (ps_e1m1_phantom06.p2, ps_e1m1_phantom06.p2);
	f_unload_phantom (sq_e1m1_phantom_06, left);
	sleep (30 * 5);
	sleep_until (ai_living_count (gr_ff_all) <= 17, 1);
	f_load_phantom (sq_e1m1_phantom_06, left, sq_e1m1_1hun_01, sq_e1m1_1hun_02, none, none);
	sleep (30 * 1);
	f_unload_phantom (sq_e1m1_phantom_06, left);
	sleep (50 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e1m1_phantom_06.driver));
	cs_fly_to_and_face (ps_e1m1_phantom06.p3, ps_e1m1_phantom06.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_06);
end

script command_script cs_e1m1_phantom07
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e1m1_phantom_07.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e1m1_wraithgunner_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_phantom_07);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e1m1_phantom07.p0, ps_e1m1_phantom07.p0);
	cs_fly_to_and_face (ps_e1m1_phantom07.p1, ps_e1m1_phantom07.p1);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e1m1_phantom_07.driver ), "phantom_lc" );
	sleep (30 * 2);
	cs_fly_to_and_face (ps_e1m1_phantom07.p2, ps_e1m1_phantom07.p2);
	cs_fly_to_and_face (ps_e1m1_phantom07.p3, ps_e1m1_phantom07.p3);
	cs_fly_to_and_face (ps_e1m1_phantom07.p4, ps_e1m1_phantom07.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_phantom_07);
end


script command_script cs_e1m1_pelican_01
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.driver));
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.driver), FALSE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e1m1_pelican_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	f_blip_object (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.driver), default);
	cs_fly_to_and_face (ps_e1m1_pelican.p0, ps_e1m1_pelican.p0);
	cs_fly_to_and_face (ps_e1m1_pelican.p1, ps_e1m1_pelican.p1);
	cs_fly_to_and_face (ps_e1m1_pelican.p2, ps_e1m1_pelican.p2);
	sleep_forever();
end


script command_script cs_e1m1_pelican_02
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_02.driver));
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_02.driver), FALSE);
	cs_fly_to_and_face (ps_e1m1_pelican02.p0, ps_e1m1_pelican02.p0);
	cs_fly_to_and_face (ps_e1m1_pelican02.p1, ps_e1m1_pelican02.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e1m1_pelican_02);
end


script static void e1m1_marines_vehicles_obj()
	sleep_until (ai_vehicle_count (e01m01_marines) > 0);
	ai_set_task (e01m01_marines, obj_e1m1_marine_veh, hill);
	repeat
		sleep_until (ai_vehicle_count (e01m01_marines) > 0);
		ai_set_task (e01m01_marines, obj_e1m1_marine_veh, hill);
		sleep_until (ai_vehicle_count (e01m01_marines) == 0);
		ai_set_task (e01m01_marines, obj_e1m1_followplayer, follow_player);
		sleep (30 * 1);
	until (ai_living_count (e01m01_marines) == 0);	
end

			
script static void e1m1_towerpower()
	thread (e1m1_turnoff_towerbase01());
	thread (e1m1_turnoff_towerbase02());
	thread (e1m1_turnoff_towerbase03());
	thread (e1m1_turnoff_towerbase04());
	thread (e1m1_turnoff_towerbase05());
	thread (e1m1_turnoff_towerbase07());
end


script static void e1m1_turnoff_towerbase01()
	sleep_until (object_get_health (e1m1_hilltower) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_01, FALSE);
end

script static void e1m1_turnoff_towerbase02()
	sleep_until (object_get_health (e1m1_chokepoint_tower) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_02, FALSE);
end

script static void e1m1_turnoff_towerbase03()
	sleep_until (object_get_health (e1m1_bowlflats_tower) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_03, FALSE);
end

script static void e1m1_turnoff_towerbase04()
	sleep_until (object_get_health (e1m1_bowlright_tower) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_04, FALSE);
end

script static void e1m1_turnoff_towerbase05()
	sleep_until (object_get_health (e1m1_bowl_tower) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_05, FALSE);
end

script static void e1m1_turnoff_towerbase07()
	sleep_until (object_get_health (e1m1_starttower02) <= 0, 1);
	object_set_phantom_power (e1m1_towerbase_07, FALSE);
end

//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																			Root Scenario Scripts																//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//

script static void setup_destroy
	//set any variables and start the main objective script from the global firefight script
	wake (objective_destroy);
end

script static void setup_defend
	//set any variables and start the main objective script from the global firefight script
	wake (objective_defend);
end

script static void setup_swarm
	//set any variables and start the main objective script from the global firefight script
	wake (objective_swarm);
end

script static void setup_wait_for_trigger
	wake (objective_wait_for_trigger);
end

script static void setup_capture
	//set any variables and start the main objective script from the global firefight script
	wake (objective_capture);
end

script static void setup_take
	//set any variables and start the main objective script from the global firefight script
	wake (objective_take);
end

script static void setup_atob
	wake (objective_atob);
end

script static void setup_boss
	wake (objective_kill_boss);
end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================