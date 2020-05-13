// ======================================================================================================================
// ============================================ E6M2 MEZZANINE MISSION SCRIPT ========================================================
// ======================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e6m2_all_follow = FALSE;
global boolean e6m2_2ndflr_to_3rdflr = FALSE;
global boolean e6m2_phantom_is_here = FALSE;
global boolean e6m2_movetoyard = FALSE;
// ============================================	STARTUP SCRIPT	========================================================

script startup e6m2_mezzanine_startup()
	dprint( "e6m2_mezzanine startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e6m2_var_startup") ) then
		wake( e6m2_mezzanine_init);
	end
end


script dormant e6m2_mezzanine_init()
	print ("e6m2 Mezzanine Started");
	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e6_m2", e6m2_main, e6m2_ff_all, e6m2_spawn01, 50);
	dm_droppod_1 = e6m2_drop_01;
	dm_droppod_2 = e6m2_drop_02;
	dm_droppod_3 = e6m2_drop_03;
	dm_droppod_4 = e6m2_drop_04;
	dm_droppod_5 = e6m2_drop_05;
	e6m2_all_follow = FALSE;
	e6m2_2ndflr_to_3rdflr = FALSE;
	e6m2_narrative_is_on = FALSE;
	e6m2_movetoyard = FALSE;
	thread (e6m2_intro_start());
	//	//	//	FOLDER SPAWNING	\\	\\	\\
	//	add "Devices" folders
	f_add_crate_folder (e6m2_devicecontrols);
	f_add_crate_folder (e6m2_devicemachines);
	//	add "Vehicles" folders
	f_add_crate_folder (e6m2_turrets);
	//	add "Crates" folders
	f_add_crate_folder (cr_e6m2_props);
	f_add_crate_folder (cr_e6m2_tempdoor01);
	f_add_crate_folder (cr_e6m2_tempdoor02);
	f_add_crate_folder (cr_e6m2_tempdoor03);
	f_add_crate_folder (cr_e6m2_weaponcrates);
	f_add_crate_folder (cr_e6m2_unscprops);
	//	add Spawn point folders 
	firefight_mode_set_crate_folder_at( e6m2_spawn01, 50);
	firefight_mode_set_crate_folder_at( e6m2_spawn02, 49);
	firefight_mode_set_crate_folder_at( e6m2_spawn03, 48);
	//	add "Items" folders
	//	add "Enemy Squad" Templates
	//	add "Objective Items"
	firefight_mode_set_objective_name_at( e6m2_left_comm, 30);	//	
	firefight_mode_set_objective_name_at( e6m2_right_comm, 31);	//	
	//	add "LZ" areas
	f_spops_mission_setup_complete( TRUE );	
end
	
script static void e6m2_intro_start()
	print ("starting e6m2 Intro");
	sleep_until (f_spops_mission_ready_complete(), 1);
	//intro();
//	pup_disable_splitscreen(true);
//	pup_play_show ( );
	sleep (15);
//	sleep_until (f_narrativein_done == TRUE);
	thread (e6m2_thread_list());
	f_spops_mission_intro_complete (TRUE);
//	pup_disable_splitscreen(false);
	print ("waiting for mission start");
	sleep_until( f_spops_mission_start_complete(), 1 );
	ai_place (sq_e6m2_phanny);
	pup_play_show (e6m2_sleepinggrunt);
	sleep_s (0.5);
	fade_in (0,0,0,15);
	sleep (60);
	b_end_player_goal = TRUE;
end


// ============================================	MISSION SCRIPT	========================================================


									//*//*//*//*//*//*//*//*//*//*	Thread List	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e6m2_thread_list()
	thread (e6m2_enemy_start());
	thread (e6m2_unscgear_callout());
	thread (e6m2_object_destruction());
	thread (e6m2_killcovvies01());
	thread (e6m2_door01switch());
	thread (e6m2_covcpu01doorswitch());
	thread (e6m2_covcpu02_switch());
	thread (e6m2_covcpu03_switch());
	thread (e6m2_phantom_encounter());
	thread (e6m2_endmission());
	thread (e6m2_destroyedcommcallout());
	thread (e6m2_frontdoorreinforcements());
end


									//*//*//*//*//*//*//*//*//*//*	1.time_passed	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e6m2_enemy_start()
	print ("Hello world");
	ai_place (sq_e6m2_4gru_01);
	ai_place (sq_e6m2_4gru_02);
	ai_place (sq_e6m2_4jak_01);
	ai_place (sq_e6m2_1eli_01);
	ai_place (sq_e6m2_1eli_02);
	ai_place (sq_e6m2_mixed_01);
	ai_place (sq_e6m2_1gho_01);
	ai_place (sq_e6m2_1gho_02);
	print ("enemies spawned");
end						


script static void e6m2_unscgear_callout()
	sleep_until (volume_test_players (tv_e6m2_unsccallout), 1);
	if (e6m2_phantom_is_here == FALSE)	then
	thread (e6m2_vo_unscgear());
	end
end

									
script static void e6m2_killcovvies01()
	sleep_until (LevelEventStatus ("e6m2_clearout01"), 1);
	sleep (30);
	thread (e6m2_vo_killallcovies01());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_02);
	sleep (30);
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	b_end_player_goal = TRUE;
end


									//*//*//*//*//*//*//*//*//*//*		2. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e6m2_door01switch()
	sleep_until (LevelEventStatus ("e6m2_door01switch"), 1);
	sleep (30);
	thread (e6m2_vo_opendoor01());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_03);
	f_blip_object (e6m2_doorpanel_01, default);
	device_set_power (e6m2_door01_switch, 1);
	sleep_until (device_get_position (e6m2_door01_switch) > 0.0, 1);
	f_unblip_object (e6m2_doorpanel_01);
	ai_place (sq_e6m2_2gru_01);
	ai_place (sq_e6m2_2jak_01);
	ai_place (sq_e6m2_2eli_01);
	ai_place (sq_e6m2_turr_01);
	ai_place (sq_e6m2_2eli_02);
	sleep (30);
	object_destroy (e6m2_door01_switch);
	object_destroy (e6m2_doorpanel_01);
	object_destroy_folder (cr_e6m2_tempdoor01);
	sleep (30 * 1);
	thread (e6m2_vo_killallcovies02());
	sleep (30 * 1);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_02);
	b_end_player_goal = TRUE;
end
									
									//*//*//*//*//*//*//*//*//*//*		3. no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
									
									//*//*//*//*//*//*//*//*//*//*		4. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu01doorswitch()
	sleep_until (LevelEventStatus ("e6m2_covcpu01switch"), 1);
	ai_place_in_limbo (gr_e6m2_2ndflr_ext);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (f_dlc_load_drop_pod (e6m2_drop_04, gr_e6m2_2ndflr_ext, none, e6m2_droppod04));
	sleep (30);
	thread (e6m2_vo_patrolgroup01());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	thread (e6m2_vo_listeningdevice01());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object (e6m2_covcpu_01, default);
	device_set_power (e6m2_covcpu01_switch, 1);
	f_new_objective (e6m2_obj_04);
	sleep_until (device_get_position (e6m2_covcpu01_switch) > 0.0, 1);
	f_unblip_object (e6m2_covcpu_01);
	sleep (30);
	object_destroy (e6m2_covcpu01_switch);
	thread (e6m2_vo_opendoor02());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object (e6m2_doorpanel_02, default);
	device_set_power (e6m2_door02_switch, 1);
	sleep_until (device_get_position (e6m2_door02_switch) > 0.0, 1);
	sleep (30);
	f_unblip_object (e6m2_doorpanel_02);
	object_destroy (e6m2_door02_switch);
	object_destroy (e6m2_doorpanel_02);
	object_destroy_folder (cr_e6m2_tempdoor02);
	sleep (30 * 1);
	thread (e6m2_vo_listeningdevice02());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_04);
	b_end_player_goal = TRUE;
end

									
									//*//*//*//*//*//*//*//*//*//*		5. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu02_switch()
	sleep_until (LevelEventStatus ("e6m2_covcpu02switch"), 1);
	sleep (30);
	f_blip_object (e6m2_covcpu_02, default);
	device_set_power (e6m2_covcpu02_switch, 1);
	sleep_until (device_get_position (e6m2_covcpu02_switch) > 0.0, 1);
	f_unblip_object (e6m2_covcpu_02);
	sleep (30 * 1);
	object_destroy (e6m2_covcpu02_switch);
	ai_place_in_limbo (gr_e6m2_3rdflr);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (f_dlc_load_drop_pod (e6m2_drop_03, gr_e6m2_3rdflr, none, e6m2_droppod03));
	thread (e6m2_vo_patrolgroup02());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	b_end_player_goal = TRUE;
end
									
									//*//*//*//*//*//*//*//*//*//*		6. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu03_switch()
	sleep_until (LevelEventStatus ("e6m2_covcpu03switch"), 1);
	sleep (30);
	thread (e6m2_vo_listeningdevice03());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_04);
	f_blip_object (e6m2_covcpu_03, default);
	device_set_power (e6m2_covcpu03_switch, 1);
	sleep_until (device_get_position (e6m2_covcpu03_switch) > 0.0, 1);
	f_unblip_object (e6m2_covcpu_03);
	sleep (30 * 1);
	object_destroy (e6m2_covcpu03_switch);
	thread (e6m2_vo_alarmsetoff());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	if	(ai_living_count (e6m2_ff_all) > 12)	then
		f_new_objective (e6m2_obj_02);
		sleep_until (ai_living_count (e6m2_ff_all) <= 12, 1);
		sleep (30);
	end
	b_end_player_goal = TRUE;
end
									
									//*//*//*//*//*//*//*//*//*//*	7.object_destruction	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\


script static void e6m2_object_destruction()
	sleep_until (LevelEventStatus ("e6m2_commsobj"), 1);
	thread (e6m2_vo_destroycomms());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_01);
end


script static void e6m2_destroyedcommcallout()
	object_cannot_take_damage (e6m2_left_comm);
	object_cannot_take_damage (e6m2_right_comm);
	sleep_until (LevelEventStatus ("e6m2_commsobj"), 1);
	object_can_take_damage (e6m2_left_comm);
	object_can_take_damage (e6m2_right_comm);
	sleep_until (object_get_health (e6m2_left_comm) <= 0 or object_get_health (e6m2_right_comm) <= 0, 1);
	thread (e6m2_vo_returnpatrols());
end


script static void e6m2_phantom_encounter()
	sleep_until (LevelEventStatus ("e6m2_phantomstart"), 1);
	thread (e6m2_objects_respawn());
	ai_place_in_limbo (sq_e6m2_1ban_01);
	ai_place_in_limbo (sq_e6m2_1ban_02);
	ai_place_in_limbo (sq_e6m2_1phan_01);
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver), FALSE);
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_02.driver), FALSE);
	e6m2_phantom_is_here = TRUE;
	sleep (30 * 4);
	thread (e6m2_vo_patrolgroup03());
	sleep (30);
	thread (e6m2_phantom_unloads());
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver), "navpoint_healthbar_neutralize");
	f_new_objective (e6m2_obj_05);
	sleep (30);
	thread (e6m2_vo_useshadeturrets());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object_cui (e6m2_shade01, "navpoint_goto");
	f_blip_object_cui (e6m2_shade02, "navpoint_goto");
	f_blip_object_cui (e6m2_shade03, "navpoint_goto");
	f_blip_object_cui (e6m2_shade04, "navpoint_goto");
	thread (e6m2_vo_useunscgear());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object (e6m2_unscrack01, ammo);
	f_blip_object (e6m2_unscrack02, ammo);
	thread (e6m2_unblip());
	sleep_until (ai_living_count (sq_e6m2_1phan_01.driver) == 0, 1);
	if (ai_living_count (e6m2_ff_all) > 0)	then
		print ("kill all the dudes");
		thread (e6m2_vo_killallcovies04());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		f_blip_ai_cui (e6m2_ff_all, "navpoint_enemy");
		f_new_objective (e6m2_obj_02);
		e6m2_all_follow = TRUE;
	end
end


script static void e6m2_frontdoorreinforcements()
	sleep_until (LevelEventStatus ("e6m2_phantomstart"), 1);
	sleep (30);
	sleep_until (ai_living_count (e6m2_ff_all) <= 10, 1);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	ai_place (sq_e6m2_4eli_02);
	
	sleep (30);
end


script static void e6m2_phantom_unloads()
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver)) <= .50, 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6m2_1phan_01.driver ), "phantom_lc" );
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver));
	sleep (10);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver), "navpoint_enemy");
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver)) <= .25, 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6m2_1phan_01.driver ), "phantom_sc" );
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver));
	sleep (10);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver), "navpoint_enemy");
end


script static void e6m2_unblip()
	sleep (30 * 20);
	f_unblip_object_cui (e6m2_shade01);
	f_unblip_object_cui (e6m2_shade02);
	f_unblip_object_cui (e6m2_shade03);
	f_unblip_object_cui (e6m2_shade04);
	f_unblip_object_cui (e6m2_unscrack01);
	f_unblip_object_cui (e6m2_unscrack02);
end	
	
	
script static void e6m2_objects_respawn()
	repeat
		object_create_anew (e6m2_unscrack01);
		object_create_anew (e6m2_unscrack02);
		if	(object_get_health (e6m2_shade01) <= 25)	and (player_in_vehicle (e6m2_shade01) == FALSE)	then
			object_create_anew (e6m2_shade01);
		end
		if	(object_get_health (e6m2_shade02) <= 25)	and (player_in_vehicle (e6m2_shade02) == FALSE)	then
			object_create_anew (e6m2_shade02);
		end
		if	(object_get_health (e6m2_shade03) <= 25)	and (player_in_vehicle (e6m2_shade03) == FALSE)	then
			object_create_anew (e6m2_shade03);
		end
		if	(object_get_health (e6m2_shade04) <= 25)	and (player_in_vehicle (e6m2_shade04) == FALSE)	then
			object_create_anew (e6m2_shade04);
		end
		sleep (30 * 30);
	until (e6m2_all_follow == TRUE);
end

														
									//*//*//*//*//*//*//*//*//*//*		8. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e6m2_endmission()
	sleep_until (LevelEventStatus ("e6m2_endmission"), 1);
	if	(ai_living_count (e6m2_ff_all) > 0)	then
		thread (e6m2_vo_killallcovies03());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		f_new_objective (e6m2_obj_02);
	end
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	sleep (30);
	thread (e6m2_vo_goodworkgohome());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_06);
	f_blip_flag (fl_e6m2_endflag, default);
	sleep_until (volume_test_players (tv_e6m2_endtrigger), 1);
	sleep (30 * 2);
	f_unblip_flag (fl_e6m2_endflag);
	sleep (30 * 1);
	fade_out (0, 0, 0, 15);
	e6m2_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
end


script static void e6m2_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end								

// ============================================	PLACEMENT SCRIPT	========================================================

//	phan01
script command_script cs_e6m2_phantom01()
	f_load_phantom (sq_e6m2_1phan_01, right, sq_e6m2_1hun_03, sq_e6m2_1hun_04, sq_e6m2_1hun_05, sq_e6m2_1hun_06);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e6m2_1ban_01.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e6m2_1ban_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e6m2_1phan_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
	cs_fly_to_and_face (ps_e6m2_phantom01.p2, ps_e6m2_phantom01.p2);
	f_unload_phantom (sq_e6m2_1phan_01, right);
	sleep (30 * 5);
end


script command_script cs_e6m2_banshee()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
end


script command_script cs_e6m2_phanny()
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point ( sq_e6m2_phanny.driver ));
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e6m2_phanny.p0, ps_e6m2_phanny.p0);
	cs_fly_to_and_face (ps_e6m2_phanny.p1, ps_e6m2_phanny.p1);
	cs_fly_to_and_face (ps_e6m2_phanny.p2, ps_e6m2_phanny.p2);
	cs_fly_to_and_face (ps_e6m2_phanny.p3, ps_e6m2_phanny.p3);
	cs_fly_to_and_face (ps_e6m2_phanny.p4, ps_e6m2_phanny.p4);
	cs_fly_to_and_face (ps_e6m2_phanny.p5, ps_e6m2_phanny.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e6m2_phanny);
end