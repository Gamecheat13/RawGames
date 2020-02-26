// ======================================================================================================================
// ============================================ E6M2 MEZZANINE MISSION SCRIPT ========================================================
// ======================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e6m2_all_follow = FALSE;
global boolean e6m2_2ndflr_to_3rdflr = FALSE;
global boolean e6m2_phantom_is_here = FALSE;
global boolean e6m2_movetoyard = FALSE;
global boolean e6m2_phanny_has_landed = FALSE;
global boolean e6m2_narrativein_done = FALSE;
global object g_ics_player = none;
global boolean e6m2_moveto3rdfloor = FALSE;
global boolean e6m2_stopwiththedoors = FALSE;
global boolean e6m2_bansheedrop = FALSE;
global boolean e6m2_unscgear_found = FALSE;
global boolean e6m2_backdoor_closed = FALSE;
global boolean e6m2_firstobjover = FALSE;
global boolean e6m2_partytime = FALSE;
global boolean e6m2_missedthebus = TRUE;
global boolean e6m2_hitthemusic = FALSE;
global short e6m2_huntersdead = 0;

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
	e6m2_narrativein_done = FALSE;
	e6m2_firstobjover = FALSE;
	thread (e6m2_intro_start());
	//	//	//	FOLDER SPAWNING	\\	\\	\\
	//	add "Devices" folders
	f_add_crate_folder (e6m2_devicecontrols);
	f_add_crate_folder (e6m2_devicemachines);
	//	add "Vehicles" folders
	f_add_crate_folder (e6m2_turrets);
	//	add "Crates" folders
	f_add_crate_folder (cr_e6m2_props);
	f_add_crate_folder (cr_e6m2_weaponcrates);
	f_add_crate_folder (cr_e6m2_unscprops);
	//	add Spawn point folders 
	firefight_mode_set_crate_folder_at( e6m2_spawn01, 50);
	firefight_mode_set_crate_folder_at( e6m2_spawn02, 49);
	firefight_mode_set_crate_folder_at( e6m2_spawn03, 48);
	firefight_mode_set_crate_folder_at( e6m2_spawn04, 47);
	//	add "Items" folders
	f_add_crate_folder (e6m2_equipment);
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
	if editor_mode() then
		e6m2_narrativein_done = TRUE;
		thread (aud_e6m2_music_start());
		print ("Narrative in finished. Spawning players");
		thread (e6m2_thread_list());
		sleep_s (1);
		f_spops_mission_intro_complete (TRUE);
		print ("waiting for mission start");
		sleep_until( f_spops_mission_start_complete(), 1 );
		ai_place (sq_e6m2_phanny);
		ai_object_set_targeting_bias (sq_e6m2_phanny, 0);
		ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point ( sq_e6m2_phanny_02.driver ), 0);
		sleep_s (0.5);
		fade_in (0,0,0,15);
		thread (e6m2_theyknowwerehere());
		thread (e6m2_speaker_check());
		sleep (60);
		thread (aud_e6m2_player_start());
		b_end_player_goal = TRUE;
	else
		//intro();
		pup_disable_splitscreen(true);
		pup_play_show (e6m2_intro);
		thread (aud_e6m2_music_start());
		sleep (15);
		print ("Puppeteer playing, waiting until it's finished.");
		thread (vo_e6m2_requiem_exterior());
		sleep_until (e6m2_narrativein_done == TRUE);
		print ("Narrative in finished. Spawning players");
		thread (e6m2_thread_list());
		sleep_s (1);
		f_spops_mission_intro_complete (TRUE);
		pup_disable_splitscreen(false);
		print ("waiting for mission start");
		sleep_until( f_spops_mission_start_complete(), 1 );
		ai_place (sq_e6m2_phanny);
		ai_object_set_targeting_bias (sq_e6m2_phanny, 0);
		ai_object_set_targeting_bias (ai_vehicle_get_from_spawn_point ( sq_e6m2_phanny_02.driver ), 0);
		sleep_s (0.5);
		fade_in (0,0,0,15);
		thread (e6m2_theyknowwerehere());
		thread (e6m2_speaker_check());
		sleep (60);
		thread (aud_e6m2_player_start());
		b_end_player_goal = TRUE;
	end
end


// ============================================	MISSION SCRIPT	========================================================


									//*//*//*//*//*//*//*//*//*//*	Thread List	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e6m2_thread_list()
	thread (e6m2_enemy_start());
	thread (e6m2_unscgear_callout());
	thread (e6m2_killcovvies01());
	thread (e6m2_door01switch());
	thread (e6m2_covcpu01doorswitch());
	thread (e6m2_covcpu02_switch());
	thread (e6m2_covcpu03_switch());
	thread (e6m2_endmission());
	thread (e6m2_destroyedcommcallout());
	thread (e6m2_frontdoorreinforcements());
	thread (e6m2_snipercallout());
	thread (e6m2_fightsandrights());
end

//	 
script static void e6m2_speaker_check()
	sleep (30);
	if (game_coop_player_count() == 1 and game_difficulty_get_real() == legendary)	then
		print ("worthy to party");
		object_create (e6m2_speaker);
		sleep (30);
		sleep_until (object_get_health (e6m2_speaker) <= .30, 1);
		e6m2_partytime = TRUE;
		print ("party on");
	else (print ("Not worthy to party"));
	end
end


script static void e6m2_fightsandrights()
	sleep_until (e6m2_partytime == TRUE, 1);
	sleep_until (e6m2_missedthebus == FALSE, 1);
	print ("Let's get it started quickly");
	e6m2_hitthemusic = TRUE;
end


script static void e6m2_playthepupsboy()
	//	play pups for awesome party times
	object_destroy (e6m2_nodancing01);
	object_destroy (e6m2_nodancing02);
	object_create (e6m2_getupngetdown);
	object_create (e6m2_speaker02);
	object_create (e6m2_speaker03);
	object_create (e6m2_speaker04);
	print ("music makes the people go KRAZY");
	pup_play_show (p_e6m2_gru01);
	pup_play_show (p_e6m2_gru02);
	pup_play_show (p_e6m2_gru03);
	pup_play_show (p_e6m2_gru04);
	pup_play_show (p_e6m2_gru05);
	pup_play_show (p_e6m2_gru06);
	pup_play_show (p_e6m2_gru07);
	pup_play_show (p_e6m2_gru08);
	skull_enable (skull_birthday_party, TRUE);
	object_cannot_take_damage (e6m2_speaker02);
	object_cannot_take_damage (e6m2_speaker03);
	object_cannot_take_damage (e6m2_speaker04);
	print ("it's so party in here");
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
	thread (vo_e6m2_gets_close());
	e6m2_unscgear_found = TRUE;
	end
end

									
script static void e6m2_killcovvies01()
	sleep_until (LevelEventStatus ("e6m2_clearout01"), 1);
	sleep (30);
	sleep_until (ai_living_count (e6m2_ff_all) <= 5, 1);
	thread (vo_e6m2_global_palmer_fewmore_08());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	thread (aud_e6m2_init_enemies_dead());
	if (e6m2_partytime == TRUE)	then
		e6m2_missedthebus = FALSE;
		sleep (30);
	end
	if (object_valid (e6m2_speaker))	then
		object_hide (e6m2_speaker, TRUE);
	end
	e6m2_firstobjover = TRUE;
	b_end_player_goal = TRUE;
end


script static void e6m2_theyknowwerehere()
	player_action_test_reset();
	sleep_until (player_action_test_primary_trigger() == TRUE OR player_action_test_secondary_trigger() == TRUE OR ai_living_count (e6m2_ff_all) < 20, 1); 
	sleep (15);
	if (e6m2_firstobjover == FALSE)	then
		sleep (30);
		thread (vo_e6m2_begin_attack());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		sleep (30);
		f_new_objective (e6m2_obj_01);
	else
		sleep (15);
	end
end


script static void e6m2_snipercallout()
	sleep_until (volume_test_players (tv_e6m2_snipercallout), 1);
	if (unit_get_health (sq_e6m2_mixed_01.sniper) > 0)	then
		thread (vo_e6m2_global_miller_sniper());
		sleep (30);
//		sleep_until (e6m2_narrative_is_on == FALSE, 1);
//		f_blip_ai_cui (sq_e6m2_mixed_01.sniper, "neutralize");
	end
end


									//*//*//*//*//*//*//*//*//*//*		2. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e6m2_door01switch()
	sleep_until (LevelEventStatus ("e6m2_door01switch"), 1);
	sleep (75);
	thread (vo_e6m2_covenant_cleanedout());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	sleep (30);
	f_new_objective (e6m2_obj_02);
	sleep (30);
	f_blip_object_cui (e6m2_doorpanel_01, "navpoint_activate");
	device_set_power (e6m2_doorpanel_01, 1);
	device_set_power (e6m2_door01_switch, 1);
	sleep_until (device_get_position (e6m2_door01_switch) > 0.0, 1);
	device_set_power (e6m2_door01_switch, 0);
	f_unblip_object_cui (e6m2_doorpanel_01);
	if	(e6m2_hitthemusic == FALSE)	then
		ai_place (sq_e6m2_2gru_01);
		ai_place (sq_e6m2_2jak_01);
		ai_place (sq_e6m2_2eli_01);
		ai_place (sq_e6m2_turr_01);
		ai_place (sq_e6m2_2eli_02);
	else (thread (e6m2_playthepupsboy()));
	end
	sleep (30);
	device_set_position (e6m2_doorpanel_01, 1);
	object_destroy (e6m2_door01_switch);
	sleep (30);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_crate_door_console_derez_mnde941', e6m2_doorpanel_01, 1 ); //AUDIO!
	object_dissolve_from_marker(e6m2_doorpanel_01, phase_out, "button_marker");
	sleep (60);
	device_set_power (e6m2_1stflrdoor, 1);
	sleep (10);
	device_set_position (e6m2_1stflrdoor, 1);
	sleep (60);
	object_destroy (e6m2_doorpanel_01);
	sleep (60);
	thread (aud_e6m2_structure_enter());
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_comm);
	b_end_player_goal = TRUE;
end

									//*//*//*//*//*//*//*//*//*//*		3. no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
									
									//*//*//*//*//*//*//*//*//*//*		4. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu01doorswitch()
	sleep_until (LevelEventStatus ("e6m2_covcpu01switch"), 1);
	thread (aud_e6m2_structure_cleared());
	if (object_valid (e6m2_getupngetdown))	then
		object_destroy (e6m2_getupngetdown);
		print ("Kill the music!");
	end
	ai_place_in_limbo (sq_e6m2_1phan_03);
	sleep (60);
	thread (vo_e6m2_stragglers_cleared());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object_cui (e6m2_covcpu_01, "navpoint_activate");
	device_set_power (e6m2_covcpu_hologram01, 1);
	device_set_power (e6m2_covcpu01_switch, 1);
	sleep (30);
	f_new_objective (e6m2_obj_03);
	sleep_until (device_get_position (e6m2_covcpu01_switch) > 0.0, 1);
	device_set_power (e6m2_covcpu01_switch, 0);
	f_unblip_object_cui (e6m2_covcpu_01);
	sleep (30);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', e6m2_covcpu_hologram01, 1 ); //AUDIO!
	device_set_position (e6m2_covcpu_hologram01, 1);
	sleep_until (device_get_position (e6m2_covcpu_hologram01) == 1, 1);
	thread (aud_e6m2_cpu01_hit());
	object_hide (e6m2_covcpu_hologram01, true);
	object_destroy (e6m2_covcpu01_switch);
	sleep (30);
	object_destroy (e6m2_covcpu_hologram01);
	thread (vo_e6m2_showing_data());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	thread (vo_e6m2_special_door());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_object_cui (e6m2_doorpanel_02, "navpoint_activate");
	f_new_objective (e6m2_obj_02);
	device_set_power (e6m2_doorpanel_02, 1);
	device_set_power (e6m2_door02_switch, 1);
	sleep_until (device_get_position (e6m2_door02_switch) > 0.0 or volume_test_players (tv_e6m2_1stflrporch), 1);
	device_set_power (e6m2_door02_switch, 0);
	sleep (30);
	device_set_position (e6m2_doorpanel_02, 1);
	f_unblip_object_cui (e6m2_doorpanel_02);
	object_destroy (e6m2_door02_switch);
	sleep (30);
	thread (vo_e6m2_reinforcements_inbound());
	thread (aud_e6m2_reinforcements01());
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_crate_door_console_derez_mnde941', e6m2_doorpanel_02, 1 ); //AUDIO!
	object_dissolve_from_marker(e6m2_doorpanel_02, phase_out, "button_marker");
	sleep (60);
	device_set_power (e6m2_2ndflrdoor, 1);
	sleep (10);
	device_set_position (e6m2_2ndflrdoor, 1);
	sleep (60);
	object_destroy (e6m2_doorpanel_02);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	sleep (30);
	b_end_player_goal = TRUE;
end


									//*//*//*//*//*//*//*//*//*//*		5. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu02_switch()
	sleep_until (LevelEventStatus ("e6m2_covcpu02switch"), 1);
	thread (vo_e6m2_second_computer());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_04);
	device_set_power (e6m2_covcpu_hologram02, 1);
	device_set_power (e6m2_covcpu02_switch, 1);
	sleep_until (device_get_position (e6m2_covcpu02_switch) > 0.0, 1);
	device_set_power (e6m2_covcpu02_switch, 0);
	f_unblip_object_cui (e6m2_covcpu_02);
	sleep (30);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', e6m2_covcpu_hologram02, 1 ); //AUDIO!
	device_set_position (e6m2_covcpu_hologram02, 1);
	sleep_until (device_get_position (e6m2_covcpu_hologram02) == 1, 1);
	thread (aud_e6m2_cpu02_hit());
	object_hide (e6m2_covcpu_hologram02, true);
	thread (vo_e6m2_second_computer_opened());
	object_destroy (e6m2_covcpu02_switch);
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	object_destroy (e6m2_covcpu_hologram02);
	thread (e6m2_2nd_reinforcement());
	//	thread (vo_e6m2_second_patrol());
	thread (aud_e6m2_reinforcements02());
	e6m2_moveto3rdfloor = TRUE;
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	b_end_player_goal = TRUE;
end


script static void e6m2_2nd_reinforcement()
	ai_place (sq_e6m2_4eli_01);
	ai_place (sq_e6m2_2jak_02);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_door_small_spawning_area_mnde938', mezzanine_backdoor, 1 ); //AUDIO!
	device_set_position (mezzanine_backdoor, 1);
	sleep (10);
	sleep_until (not volume_test_objects (tv_e6m2_backroom, ai_actors (e6m2_ff_all)), 1);
	sleep (30 * 1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e06m2_spawning_room_door_close_mnde938', mezzanine_backdoor, 1 ); //AUDIO!
	device_set_position (mezzanine_backdoor, 0);
	thread (e6m2_backdoor_open());
end


script static void e6m2_backdoor_open()
	repeat
		sleep_until (volume_test_players (tv_e6m2_backroom), 1);
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_door_small_spawning_area_mnde938', mezzanine_backdoor, 1 ); //AUDIO!
		device_set_position (mezzanine_backdoor, 1);
		sleep_until (not volume_test_players (tv_e6m2_backroom), 1);
		if e6m2_backdoor_closed == FALSE then
			print ("back door should close now");
			sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e06m2_spawning_room_door_close_mnde938', mezzanine_backdoor, 1 ); //AUDIO!
			device_set_position (mezzanine_backdoor, 0);
		end
	until (e6m2_backdoor_closed == TRUE);
end


									//*//*//*//*//*//*//*//*//*//*		6. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
								
script static void e6m2_covcpu03_switch()
	sleep_until (LevelEventStatus ("e6m2_covcpu03switch"), 1);
	sleep (30);
	thread (vo_e6m2_third_computer());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_05);
	sleep (30);
	device_set_power (e6m2_covcpu_hologram03, 1);
	device_set_power (e6m2_covcpu03_switch, 1);
	sleep_until (device_get_position (e6m2_covcpu03_switch) > 0.0, 1);
	device_set_power (e6m2_covcpu03_switch, 0);
	thread (aud_e6m2_cpu03_hit());
	f_unblip_object_cui (e6m2_covcpu_03);
	sleep (30);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', e6m2_covcpu_hologram03, 1 ); //AUDIO!
	device_set_position (e6m2_covcpu_hologram03, 1);
	sleep_until (device_get_position (e6m2_covcpu_hologram03) == 1, 1);
	object_hide (e6m2_covcpu_hologram03, true);
	object_destroy (e6m2_covcpu03_switch);
	thread (vo_e6m2_button_pushed());
	sleep (30);
	object_destroy (e6m2_covcpu_hologram03);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_01a);
	sleep_until (ai_living_count (e6m2_ff_all) <= 12, 1);
	if	(device_get_position (mezzanine_backdoor) == 1)	then
		device_set_position (mezzanine_backdoor, 0);
		sleep_until (device_get_position (mezzanine_backdoor) == 0.0, 1);
		e6m2_backdoor_closed = TRUE;
		sleep (30);
		volume_teleport_players_not_inside (tv_e6m2_supertriggervolume, fl_e6m2_teleportflag);
		sleep (30);
	end
	ai_place (sq_e6m2_2gru_04);
	ai_place (sq_e6m2_2jak_03);
	ai_place (sq_e6m2_2eli_04);
	sleep (30);
	e6m2_backdoor_closed = TRUE;
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_door_small_spawning_area_mnde938', mezzanine_backdoor, 1 ); //AUDIO!
	device_set_position (mezzanine_backdoor, 1);
	sleep_until (device_get_position (mezzanine_backdoor) == 1.0, 1);
	device_set_power (mezzanine_backdoor, 0);
	print ("door will stay open now");
	sleep (30);
	thread (aud_e6m2_reinforcements03());
	sleep_until (ai_living_count (e6m2_ff_all) <= 6, 1);
	ai_place_in_limbo (sq_e6m2_1phan_02);
	sleep (30);
	sleep_until (ai_living_count (e6m2_ff_all) <= 5, 1);
	thread (vo_e6m2_global_palmer_fewmore_03());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	sleep (30 * 3);
	prepare_to_switch_to_zone_set(e6m2_secondary);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e6m2_secondary);
	sleep (60);	
	thread (vo_e6m2_destroy_terminals());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	sleep (30);
	f_new_objective (e6m2_obj_06);
	b_end_player_goal = TRUE;
end
									
									//*//*//*//*//*//*//*//*//*//*	7.object_destruction	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e6m2_destroyedcommcallout()
	print ("starting immortal comms script");
	sleep_until (object_valid (e6m2_left_comm), 1);
	object_cannot_take_damage (e6m2_left_comm);
	sleep_until (object_valid (e6m2_right_comm), 1);
	object_cannot_take_damage (e6m2_right_comm);
	sleep_until (LevelEventStatus ("e6m2_commsobj"), 1);
	object_can_take_damage (e6m2_left_comm);
	object_can_take_damage (e6m2_right_comm);
	print ("comms are now mortal");
	sleep_until (object_get_health (e6m2_left_comm) <= 0 or object_get_health (e6m2_right_comm) <= 0, 1);
	thread (vo_e6m2_comm_down());
	sleep (30);
	thread (aud_e6m2_takedown_comms());
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	thread (vo_e6m2_drop_forces());
	thread (e6m2_phantom_encounter());
end


script static void e6m2_phantom_encounter()
	sleep_until (ai_living_count (e6m2_ff_all) <= 12, 1);
	thread (e6m2_objects_respawn());
	thread (e6m2_hunter_callout());
	ai_place_in_limbo (sq_e6m2_1ban_01);
	ai_place_in_limbo (sq_e6m2_1ban_02);
	ai_place_in_limbo (sq_e6m2_1phan_01);
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_01.driver), FALSE);
	unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point (sq_e6m2_1ban_02.driver), FALSE);
	e6m2_phantom_is_here = TRUE;
	sleep (120);
	thread (aud_e6m2_phantomhunters());
	thread (e6m2_phantom_unloads());
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	sleep (30);
	if	(e6m2_unscgear_found == FALSE)	then
		thread (vo_e6m2_never_got_gear());
	else	(thread (vo_e6m2_remind_gear()));
	end
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	sleep_until (e6m2_bansheedrop == TRUE, 1);
	thread (e6m2_huntercounter());
end


script static void e6m2_frontdoorreinforcements()
	sleep_until (LevelEventStatus ("e6m2_phantomstart"), 1);
	sleep (40);
	ai_place_in_limbo (sq_e6m2_mixed_04);
	ai_place_in_limbo (sq_e6m2_mixed_05);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (f_dlc_load_drop_pod (e6m2_drop_05, sq_e6m2_mixed_04, sq_e6m2_mixed_05, e6m2_droppod05));
	thread (aud_e6m2_droppod());
	thread (vo_e6m2_global_miller_droppod_01());
	sleep (30);
	sleep_until (e6m2_bansheedrop == TRUE, 1);
	sleep_until (ai_living_count (e6m2_ff_all) <= 8, 1);
	ai_place_in_limbo (sq_e6m2_5eli_01);
	sleep (30);
	ai_place_in_limbo (sq_e6m2_5eli_02);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (f_dlc_load_drop_pod (e6m2_drop_01, sq_e6m2_5eli_01, sq_e6m2_5eli_02, e6m2_droppod01));
	sleep (30);
	thread (vo_e6m2_global_palmer_droppod_01());
	sleep_until (ai_living_count (e6m2_ff_all) <= 7, 1);	
	sleep (30);
	ai_place (sq_e6m2_1gru_02);
	ai_place (sq_e6m2_2gru_05);
	ai_place (sq_e6m2_2eli_05);
	ai_place (sq_e6m2_2eli_06);
	sleep (30);
	device_set_position (mezzanine_frontdoor, 1);
	sleep (90);
	thread (vo_e6m2_global_miller_reinforcements_01());
end


script static void e6m2_phantom_unloads()
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver)) <= .75 or e6m2_huntersdead == 2, 1);
	sleep_until (e6m2_bansheedrop == TRUE, 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6m2_1phan_01.driver ), "phantom_lc" );
	thread (vo_e6m2_drops_banshee_1());
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver)) <= .50 or e6m2_huntersdead == 4, 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6m2_1phan_01.driver ), "phantom_sc" );
	thread (vo_e6m2_drops_banshee_2());
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_1phan_01.driver));
	unit_set_current_vitality (sq_e6m2_1phan_01.driver, 0.1, 0.1);
	unit_set_maximum_vitality (sq_e6m2_1phan_01.driver, 0.1, 0.1);
	object_set_shield_stun_infinite (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ));
	damage_object (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "hull", .15);
	cs_fly_to_and_face (sq_e6m2_1phan_01, TRUE, ps_e6m2_phantom01.p0, ps_e6m2_phantom01.p0);
	object_set_scale ( ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e6m2_1phan_01);
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	if (object_get_health (e6m2_left_comm) > 0 or object_get_health (e6m2_right_comm) > 0)	then
		sleep (30);
		thread (vo_e6m2_before_terminals());
	else (print ("Comms are gone, AI are killed."));
	end
end

script static void e6m2_hunter_callout()
	sleep_until (e6m2_bansheedrop == TRUE, 1);
	thread (vo_e6m2_global_palmer_hunters_01());
end


script static void e6m2_huntercounter()
	thread (e6m2_huntercounter01());
	thread (e6m2_huntercounter02());
	thread (e6m2_huntercounter03());
	thread (e6m2_huntercounter04());
end


script static void e6m2_huntercounter01()
	sleep_until	(ai_living_count (sq_e6m2_1hun_03) <= 0, 1);
	sleep (30);
	e6m2_huntersdead = e6m2_huntersdead + 1;
	print ("1 Hunter is dead");
end

script static void e6m2_huntercounter02()
	sleep_until	(ai_living_count (sq_e6m2_1hun_04) <= 0, 1);
	sleep (30);
	e6m2_huntersdead = e6m2_huntersdead + 1;
	print ("1 Hunter is dead");
end

script static void e6m2_huntercounter03()
	sleep_until (ai_living_count (sq_e6m2_1hun_05) <= 0, 1);
	sleep (30);
	e6m2_huntersdead = e6m2_huntersdead + 1;
	print ("1 Hunter is dead");
end

script static void e6m2_huntercounter04()
	sleep_until (ai_living_count (sq_e6m2_1hun_06) <= 0, 1);
	sleep (30);
	e6m2_huntersdead = e6m2_huntersdead + 1;
	print ("1 Hunter is dead");
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
	print ("e6m2_final script loaded");
	sleep (30);
	thread (vo_e6m2_terminals_destroyed());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	if	((ai_living_count (e6m2_ff_all) > 0) and (ai_living_count (e6m2_ff_all) <= 6))	then
		print ("AI still alive, less than 6, kill them dead.");
		thread (vo_e6m2_following_destruction());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		f_new_objective (e6m2_obj_01b);
		f_blip_ai_cui (e6m2_ff_all, "navpoint_enemy");
	elseif	(ai_living_count (e6m2_ff_all) > 6)	then
		print ("AI still alive, less than 5, kill them dead.");
		thread (vo_e6m2_following_destruction());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		f_new_objective (e6m2_obj_01b);
		sleep_until (ai_living_count (e6m2_ff_all) <= 5, 1);
		thread (vo_e6m2_global_miller_few_more_07());
		sleep (30);
		sleep_until (e6m2_narrative_is_on == FALSE, 1);
		f_blip_ai_cui (e6m2_ff_all, "navpoint_enemy");
	end
	print ("Waiting until AI is all dead like");
	sleep_until (ai_living_count (e6m2_ff_all) <= 0, 1);
	thread (aud_e6m2_allclear());
	f_unblip_flag (fl_e6m2_unscrack01);
	print ("All AI is dead, moving on");
	sleep (60);
	thread (vo_e6m2_finally_dead());
	sleep (30);
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	ai_place_in_limbo (sq_e6m2_phanny_02);
	sleep (60);
	thread (vo_e6m2_excellent());
	f_unblip_flag (fl_e6m2_unscrack01);
	sleep (60);
	f_blip_object (ai_vehicle_get_from_spawn_point (sq_e6m2_phanny_02.driver), default);
	sleep_until (e6m2_phanny_has_landed == TRUE, 1);
	thread (aud_e6m2_rideishere());
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	f_new_objective (e6m2_obj_07);
	thread (e6m2_phantomlift_attach());
	sleep_until( object_valid(e6m2_phantomlift) ,1 );
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e6m2_phanny_02.driver));
	spops_blip_object( e6m2_phantomlift, TRUE, "default" );
	sleep_until( objects_distance_to_object(Players(),e6m2_phantomlift) <= 0.45 and objects_distance_to_object(Players(),e6m2_phantomlift) >= 0.1 or volume_test_players (tv_e6m2_endmission), 1);
	thread (aud_e6m2_stop_music());
	fade_out (0, 0, 0, 15);
	e6m2_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
	b_game_won = TRUE;
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


script static void e6m2_phantomlift_attach()
	effect_new_on_object_marker ( objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect, ai_vehicle_get_from_spawn_point (sq_e6m2_phanny_02.driver), "lift_direction" );
	object_create( e6m2_phantomlift );
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_init_mnde8298', e6m2_phantomlift, m_sound, 1 ); //AUDIO!
	sleep_until(object_valid(e6m2_phantomlift),1);
	sleep(2);
	objects_attach(ai_vehicle_get_from_spawn_point (sq_e6m2_phanny_02.driver) ,"lift_direction", e6m2_phantomlift,"m_end" );
end

// ============================================	PLACEMENT SCRIPT	========================================================

//	phan01
script command_script cs_e6m2_phantom01()
	f_load_phantom (sq_e6m2_1phan_01, dual, sq_e6m2_1hun_03, sq_e6m2_1hun_04, sq_e6m2_1hun_05, sq_e6m2_1hun_06);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e6m2_1ban_01.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e6m2_1ban_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e6m2_1phan_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	f_blip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ), "navpoint_enemy");
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
	cs_fly_to_and_face (ps_e6m2_phantom01.p2, ps_e6m2_phantom01.p2);
	f_unload_phantom (sq_e6m2_1phan_01, dual);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_01.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_01);
	e6m2_bansheedrop = TRUE;
end


script command_script cs_e6m2_banshee()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
end


script command_script cs_e6m2_phantom02()
	f_load_phantom (sq_e6m2_1phan_02, right, sq_e6m2_4eli_02, sq_e6m2_4jak_02, sq_e6m2_4gru_03, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e6m2_1phan_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
	thread (vo_e6m2_global_palmer_phantom_01());
	cs_fly_to_and_face (ps_e6m2_phantom01.p3, ps_e6m2_phantom01.p3);
	cs_fly_to_and_face (ps_e6m2_phantom01.p4, ps_e6m2_phantom01.p4);
	cs_fly_to_and_face (ps_e6m2_phantom01.p9, ps_e6m2_phantom01.p9);
	f_unload_phantom (sq_e6m2_1phan_02, right);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_02.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_02);
	sleep (30 * 15);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_02.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_02);
	cs_fly_to_and_face (ps_e6m2_phantom01.p5, ps_e6m2_phantom01.p5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_02.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_02);
	cs_fly_to_and_face (ps_e6m2_phantom01.p0, ps_e6m2_phantom01.p0);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_02.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e6m2_1phan_02);
end


script command_script cs_e6m2_phantom03()
	f_load_phantom (sq_e6m2_1phan_03, left, sq_e6m2_mixed_02, sq_e6m2_mixed_03, sq_e6m2_mixed_06, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e6m2_1phan_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e6m2_phantom01.p1, ps_e6m2_phantom01.p1);
	cs_fly_to_and_face (ps_e6m2_phantom01.p8, ps_e6m2_phantom01.p8);
	cs_fly_to_and_face (ps_e6m2_phantom01.p6, ps_e6m2_phantom01.p6, 1);
	f_unload_phantom (sq_e6m2_1phan_03, left);
	sleep (30 * 45);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point ( sq_e6m2_1phan_03.driver ));
	f_unblip_ai_cui (sq_e6m2_1phan_03);
	cs_fly_to_and_face (ps_e6m2_phantom01.p7, ps_e6m2_phantom01.p7);
	cs_fly_to_and_face (ps_e6m2_phantom01.p0, ps_e6m2_phantom01.p0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e6m2_1phan_03);
end


script command_script cs_e6m2_phanny()
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point ( sq_e6m2_phanny.driver ));
	ai_set_blind (sq_e6m2_phanny, TRUE);
	ai_set_deaf (sq_e6m2_phanny, TRUE);
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


script command_script cs_e6m2_phanny02()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e6m2_1phan_01);
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point ( sq_e6m2_phanny_02.driver ));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Shrink size over time
	sleep (30 * 4);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e6m2_phanny.p7, ps_e6m2_phanny.p7);
	cs_fly_to_and_face (ps_e6m2_phanny.p8, ps_e6m2_phanny.p8);
	ai_braindead (sq_e6m2_phanny_02, TRUE);
	e6m2_phanny_has_landed = TRUE;
end


// ============================================	1st Person Button presses	========================================================


script static void e6m2_door01_buttonpup (object dev, unit player)
	print ("playing door switch puppeteer");
	g_ics_player = player;
	if	(dev == e6m2_door01_switch)	then
		local long show = pup_play_show(p_e6m2_door01_button);
		sleep_until (not pup_is_playing(show), 1);
		print ("door one switch hit");
	elseif	(dev == e6m2_door02_switch)	then
		local long show = pup_play_show(p_e6m2_door02_button);
		sleep_until (not pup_is_playing(show), 1);
		print ("door two switch hit");
	elseif	(dev == e6m2_covcpu01_switch)	then
		local long show = pup_play_show(p_e6m2_covcpu1_button);
		sleep_until (not pup_is_playing(show), 1);
		print ("Cov Cpu 1 switch hit");
	elseif	(dev == e6m2_covcpu02_switch)	and	(ai_living_count (e6m2_ff_all) <= 0)	then
		local long show = pup_play_show(p_e6m2_covcpu2_button);
		sleep_until (not pup_is_playing(show), 1);
		print ("Cov Cpu 2 switch hit");
	elseif	(dev == e6m2_covcpu03_switch)	and	(ai_living_count (e6m2_ff_all) <= 0)	then
		local long show = pup_play_show(p_e6m2_covcpu3_button);
		sleep_until (not pup_is_playing(show), 1);
		print ("Cov Cpu 3 switch hit");
	else	(print ("AI present. Aborting anim"));
	end
end