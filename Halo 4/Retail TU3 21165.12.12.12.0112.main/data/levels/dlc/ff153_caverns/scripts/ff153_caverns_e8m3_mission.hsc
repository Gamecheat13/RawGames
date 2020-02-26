// =============================================================================================================================
// ============================================ E8M3 CAVERNS MISSION SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

global real r_units_in_squad_1 = 0;
global real r_units_in_squad_2 = 0;
global boolean b_beach_adds_entered = FALSE;
global boolean b_player_entered_cave = FALSE;
global boolean b_player_is_in_cave = FALSE;
global boolean b_shield_on = TRUE;
global boolean b_trigger_forest_adds = FALSE;
global boolean b_shield_1_down = FALSE;
global boolean b_finale = FALSE;
global boolean b_phantom_stay = FALSE;
global boolean b_turret_move_up = FALSE;
global boolean b_blip_leader = FALSE;
global boolean b_switch_1_hit = FALSE;
global boolean b_switch_2_hit = FALSE;
global boolean b_door_switch_hit = FALSE;
global boolean b_marine_show_done = FALSE;
global boolean b_spartans_storm_structure = FALSE;
global boolean b_generators_revealed = FALSE;
global boolean b_beach_enemies_dead = FALSE;
global boolean b_bring_in_murphy = FALSE;
global boolean b_spartans_move_up = FALSE;

// ============================================	STARTUP SCRIPT	========================================================
script startup e8m3_caverns_startup

	print( "e8m3 caverns startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m3") ) then
		wake( e8m3_caverns_init );
	end

end

script dormant e8m3_caverns_init
//	sleep_until (LevelEventStatus ("e9m2_var_startup"), 1);

	print ("************STARTING E8 M3*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e8_m3", e8_m3_int, sg_e8m3_all, e8_m3_spawn_init, 90 );

		//sleep_until (LevelEventStatus ("e8_m3"), 1);
		//ai_ff_all = sg_e8m3_all;
		print ("e8m3 variant started");
		//switch_zone_set (e8_m3_ext);
		//ai_allegiance (human, player);
		//ai_allegiance (player, human);
		ai_allegiance (covenant, forerunner);
		//b_end_player_goal = FALSE;
		//ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery", "objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect" );
		
//	//	//	//	FOLDER SpawnING	\\	\\	\\

//  "Devices" folders
		//f_add_crate_folder (e8m5_device_machines);
		//f_add_crate_folder (e8m5_device_controls);
		
		dm_droppod_1 = e10m2_drop_rail_01;
		
		thread(f_e8m3_intro());
		
//	add "Vehicles" folders
		f_add_crate_folder (e8m3_hogs_1);

//	//	add "Crates" folders
		f_add_crate_folder ( e8m3_shield_1);
		f_add_crate_folder ( e8m3_grass_crates);
		object_destroy_folder ( e10m2_outside_crates);
		//object_destroy_folder ( e10m2_towers);
		object_destroy_folder ( e10_m2_cov_turrets);
		object_hide(e8m3_pod_1, false);
		object_create_anew(e8m3_base_1);
		object_hide(cr_e6_m3_pod_top_1, false);
		object_hide(cr_e6_m3_pod_top_2, false);
		object_create(e6_m3_cov_base_01);
		object_create(e6_m3_cov_base_02);
		object_create( cr_e6_m3_light_bridge_1 );
		object_create( cr_e6_m3_light_bridge_2 );

//  Spawn point folders 
		f_add_crate_folder (e8_m3_spawn_init);
		//f_add_crate_folder (e8m3_spawn_beach);
		//f_add_crate_folder (e8m3_spawn_cave);

		firefight_mode_set_crate_folder_at( e8_m3_spawn_init, 90);					//	Initial Spawn Area for E8M5	
		firefight_mode_set_crate_folder_at( e8m3_spawn_beach, 91);					//	Beach Spawn
		firefight_mode_set_crate_folder_at( e8m3_spawn_cave, 92);						//	Cave Spawn
		firefight_mode_set_crate_folder_at( e8m3_spawn_forest, 93);
		
//	//	add "Items" folders

//	//	add "Enemy Squad" Templates

//  "Objective Items"
		firefight_mode_set_objective_name_at( e8m3_core_1, 50);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_core_2, 51);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_core_3, 52);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_beach_door, 53); // Foredoor on Beach
		firefight_mode_set_objective_name_at( e8m3_shield_location, 54); // Button to release marines
		//firefight_mode_set_objective_name_at( e8m3_release_marines, 55); // Button to release marines
		firefight_mode_set_objective_name_at( m8e3_lz_final, 56); // Escape LZ m8e3_lz_final
		firefight_mode_set_objective_name_at( e10m2_switch_back_door, 57); // Back Door
		firefight_mode_set_objective_name_at( e8m3_release_invis, 58); // Button to release marines
		
//  "Squad Declaration"

		firefight_mode_set_squad_at( sg_e8m3_grass_init, 1);	//	Starting Squad
		firefight_mode_set_squad_at( e8m3_ghosts_g_1, 2);	//	Starting Squad 2
		firefight_mode_set_squad_at( sg_e8m3_beach_init, 3);	//	Beach Squads
		firefight_mode_set_squad_at( sg_e8m3_beach_adds, 4);	//	Beach Adds
		firefight_mode_set_squad_at( sg_e8m3_cavern_init, 5);	//	Starting Squad Cavern
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_1, 6);	//	Cavern Adds 1
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_2, 7);	//	Cavern Adds 2
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_3, 8);	//	Cavern Adds 3
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_4, 9);	//	Cavern Adds 4
		firefight_mode_set_squad_at( sg_e8m3_forest_init, 10);	//	Forest Start
		firefight_mode_set_squad_at( sg_e8m3_forest_adds, 11);	//	Forest Adds
		firefight_mode_set_squad_at( sg_e8m3_finale, 12);	//	Finale
		firefight_mode_set_squad_at( e8m3_forest_Adds_4, 13);//  New Forest Adds

// "Phantom Declaration"
		firefight_mode_set_squad_at( e8m3_phantom_fore, 16);
		firefight_mode_set_squad_at( e8m3_phantom_cave, 14);
		firefight_mode_set_squad_at( e8m3_phantom_cave_2, 15);

end

script static void f_e8m3_intro()

		f_spops_mission_setup_complete( TRUE );

	if editor_mode() then
		sleep_until (f_spops_mission_ready_complete(), 1);
		thread(vo_e8m3_assist_marines());
		sleep(1);
		f_spops_mission_intro_complete (TRUE);
		thread(f_e8m3_threads());
		object_create(editorhog1);
		object_create(editorhog2);

	else  
	  sleep_until (f_spops_mission_ready_complete(), 1);
	  pup_disable_splitscreen (TRUE);
		local long intro = pup_play_show (e8_m3_intro);
		sleep(15);
		thread(vo_e8m3_assist_marines());
		sleep_until (not pup_is_playing(intro), 1);
		pup_disable_splitscreen (FALSE);
		f_spops_mission_intro_complete (TRUE);
		thread(f_e8m3_threads());
		//print ("waiting for mission start");
	end
		
end

script static void f_e8m3_threads()

		sleep_until( f_spops_mission_start_complete(), 1 );
		
		thread(f_main_friendly_setup());
		
		object_cannot_take_damage(e8m3_core_1);
		object_cannot_take_damage(e8m3_core_2);
		object_cannot_take_damage(e8m3_core_3);
		object_hide(e8m3_core_1, true);
		object_hide(e8m3_core_2, true);
		object_hide(e8m3_core_3, true);


// Event Script Threading
		thread(f_objective_track_grass());
		thread(f_start_event_e8m3_1());
		thread(f_end_event_e8m3_1());
		thread(f_start_event_e8m3_3());
		
		object_create(e8m3_release_marines_2);
		object_create(e8m3_release_invis);
		sleep_s(1);
		device_set_power(e8m3_release_invis, 0);
		sleep(1);
		//object_hide(e8m3_release_marines_2, true);
		
		//sleep_until( f_spops_mission_start_complete(), 1 );
		
end

script dormant f_objectives_pt_2()
		thread(f_start_event_e8m3_5());
		thread(f_start_event_e8m3_5_1());
		thread(f_start_event_e8m3_5_4());
		thread(f_start_event_e8m3_6());
		thread(f_start_event_e8m3_8());
		thread(f_start_event_e8m3_8_b());
		thread(f_end_event_e8m3_8_b());
		thread(f_end_event_e8m3_8());
		thread(f_start_event_e8m3_10());
		thread(f_end_event_e8m3_10());
		thread(f_start_event_e8m3_10_1());
		thread(f_start_event_e8m3_14());
		thread(f_end_event_e8m3_12());
		thread(f_start_event_e8m3_12());
		thread(f_foreshadow_dialogue());
		thread(f_end_event_e8m3_6());
		thread(f_extend_forest());
		thread(f_forerunner_structure_music());
		thread(f_forerunner_structure_music_2());
end

// ============================================	MISSION SCRIPT	========================================================

script static void f_main_friendly_setup()
	ai_place(e8_m3_marines_1);
	ai_vehicle_reserve_seat(war1, warthog_p, TRUE);
	ai_vehicle_reserve_seat(war2, warthog_p, TRUE);
	e8m3_base_1 -> top_object(e8m3_pod_1 );
end

script static void f_objective_track_grass()

	thread(f_e8m3_music_start());
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_cloaking_down());
	thread(f_new_objective(e8_m3_obj_01));
	sleep_until(volume_test_players(e8m3_tv_grass_enter) or ai_living_count(e8m3_ghosts_g_1) <= 0);
	prepare_to_switch_to_zone_set (e8_m3_ext);
	sleep(1);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e8_m3_ext);
	
	if game_is_cooperative() == TRUE
		then b_spartans_move_up = TRUE;
	end
	
	thread(f_e8m3_music_first_bowl());
	//sleep_s(random_range(1, 5));
	thread(f_phantom_load_playload_ghost_2(e8m3_phantom_g_g_2, e8m3_ghosts_g_2.1));
	ai_place(e8m3_phantom_g_g_2);
	sleep_until(ai_living_count(sg_e8m3_grass_vehicles) <= 1);
	//sleep_s(random_range(1, 5));
	thread(f_phantom_load_playload_ghost_2(e8m3_phantom_g_g_3, e8m3_ghosts_g_3.1));
	ai_place(e8m3_phantom_g_g_3);
	sleep(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_while_fighting());
	sleep_until(ai_living_count(sg_e8m3_grass_vehicles) <= 1 or ai_living_count(sg_e8m3_grass_init) <= 4);
	//sleep_s(random_range(1, 5));
	if game_is_cooperative() == TRUE
		then
			thread(f_phantom_load_playload(e8m3_phantom_g_w_2, e8m3_wraith_g_2));
			ai_place(e8m3_phantom_g_w_2);
			sleep_s(random_range(7, 12));
		end
	thread(f_phantom_load_playload(e8m3_phantom_g_w_1, e8m3_wraith_g_1));
	ai_place(e8m3_phantom_g_w_1);
	r_units_in_squad_1 = ai_living_count(sg_e8m3_grass_vehicles);
	r_units_in_squad_2 = ai_living_count(sg_e8m3_grass_init);
	sleep_until((ai_living_count(sg_e8m3_grass_vehicles) == r_units_in_squad_1 - 1) or (ai_living_count(sg_e8m3_grass_init) == r_units_in_squad_2 - 1));
	sleep(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_take_down_generators());
	sleep(1);
	sleep_until(b_blip_leader == TRUE);
	thread(f_objective_complete_e8m3(e8_m3_obj_02));
	f_blip_leader();
	sleep(random_range(45, 90));
	b_end_player_goal = TRUE;	
end

script static void f_start_event_e8m3_1()
		sleep_until(LevelEventStatus("start_event_1"), 1);
		b_wait_for_narrative_hud = true; 
		sleep(1);
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(vo_e8m3_target_down());
		thread(f_objective_complete_e8m3(e8_m3_obj_03));
		print("START EVENT 1");
		thread(f_e8m3_music_generators());
		object_can_take_damage(e8m3_core_1);
		object_can_take_damage(e8m3_core_2);
		object_can_take_damage(e8m3_core_3);
		ai_object_set_team(e8m3_core_1, "covenant");
		ai_object_set_team(e8m3_core_2, "covenant");
		ai_object_set_team(e8m3_core_3, "covenant");
		ai_object_enable_targeting_from_vehicle(e8m3_core_1, true);
		ai_object_enable_targeting_from_vehicle(e8m3_core_2, true);
		ai_object_enable_targeting_from_vehicle(e8m3_core_3, true);
		object_hide(e8m3_core_1, false);
		object_hide(e8m3_core_2, false);
		object_hide(e8m3_core_3, false);
		object_dissolve_from_marker(e8m3_core_1, "phase_in", "fx_intersect");
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_generator_dissolve_mnde873', e8m3_core_1, 1 ); //AUDIO!
		object_dissolve_from_marker(e8m3_core_2, "phase_in", "fx_intersect");
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_generator_dissolve_mnde873', e8m3_core_2, 1 ); //AUDIO!
		object_dissolve_from_marker(e8m3_core_3, "phase_in", "fx_intersect");
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_generator_dissolve_mnde873', e8m3_core_3, 1 ); //AUDIO!
		sleep_s(2);
		b_wait_for_narrative_hud = false; 
		b_generators_revealed = TRUE;
end

script static void f_end_event_e8m3_1()
		sleep_until(LevelEventStatus("end_event_1"), 1);
		print("END EVENT 1");
		thread(f_e8m3_music_enter_beach());
		sleep(random_range(45, 90));
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_cov_shield_off_mnde875', e8m3_cov_shield_rock, 1 ); //AUDIO!
		object_set_function_variable(e8m3_cov_shield_rock, shield_alpha, 1, 5);
		sleep_s(3);
		object_destroy_folder(e8m3_shield_1);
		object_create_folder(e8m3_beach_crates);
		object_create_folder(e8m3_beach_vehicles);
		b_shield_1_down = TRUE;
		sleep(1);
		thread(f_spartans_take_hogs());
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(vo_e8m3_the_beach());
		thread(f_beach_blip());
		sleep_until(volume_test_players(tv_on_beach) OR ai_living_count(sg_e8m3_beach_init) <= 6);
		thread(f_e8m3_music_beach_encounter());
		sleep(1);
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(vo_e8m3_make_noise());
		sleep(1);
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(f_objective_complete_e8m3(e8_m3_obj_04));
end

script static void f_beach_blip()
	sleep(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
		if volume_test_players(tv_e8m3_beach) == FALSE
		then f_blip_flag(e8m3_flg_beach, "default");
				 sleep_until(volume_test_players(tv_e8m3_beach));
				 f_unblip_flag(e8m3_flg_beach);
		else print("Players are on the beach");
		end
end

script static void f_start_event_e8m3_3()
		sleep_until(LevelEventStatus("start_event_3"), 1);
		print("START EVENT 3");
		thread(f_objective_complete_e8m3(e8_m3_obj_05 ));
		sleep_s(2);
		thread(f_e8m3_music_cavern_door_open());
		device_set_power(cavern_front_door, 1);
		sleep(1);
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_cavern_door_open_mnde9186', cavern_front_door, 1 ); //AUDIO!
		device_set_position(cavern_front_door, 1);
		sleep(1);
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(vo_e8m3_covenant_beach());
		b_beach_adds_entered = TRUE;
		sleep_until(volume_test_players(e8m3_tv_cave_enter_1) or ai_living_count(sg_e8m3_beach_all) <= 0, 1);
		sleep(1);
		b_beach_enemies_dead = TRUE;
		if b_player_is_in_cave == FALSE
			then
			sleep(1);
			sleep_until(e8m3_narrative_is_on == FALSE);
			thread(vo_e8m3_into_cavern());
			f_blip_flag(e8m3_flg_caverns_enter_1, "default");
			sleep_until(volume_test_players(e8m3_tv_cave_enter_1), 1);
			f_unblip_flag(e8m3_flg_caverns_enter_1);
			sleep(1);
			f_blip_flag(e8m3_flg_caverns_enter_2, "default");
			sleep_until(volume_test_players(e8m3_tv_cave_enter_2), 1);
			f_unblip_flag(e8m3_flg_caverns_enter_2);
		end
		thread(f_e8m3_music_enter_cavern());
		wake(f_objectives_pt_2);
		b_end_player_goal = TRUE;
		object_create_folder(e8m3_cavern_crates);
		object_create_folder(e8m3_shield_2);
		object_create_folder(e8m3_shield_3);
		object_create_folder(e8m3_cavern_vehicles);
		object_create_folder(e8m3_weapons);
		object_create(e10m2_switch_back_door);
		b_player_entered_cave = TRUE;
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(vo_e8m3_sos_again());
		sleep(1);
		sleep_until(e8m3_narrative_is_on == FALSE);
		thread(f_e8m3_music_bowl_encounter_begin());

end

script static void f_enter_cave_check()
	sleep_until(volume_test_players(e8m3_tv_cave_enter_1), 1);
	b_player_is_in_cave = TRUE;	
end

script static void f_close_beach_door()
	print("WERE YOU BORN IN A BARN OR SOMETHING?");
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_cavern_door_close_mnde9186', cavern_front_door, 1 ); //AUDIO!
	device_set_position(cavern_front_door, 0);
	f_ai_garbage_kill( sg_e8m3_before_door, 15, 45, -1, -1, FALSE );
end

script static void f_start_event_e8m3_5()
	sleep_until(LevelEventStatus("start_event_5"), 1);
	print("START EVENT 5");
	thread(f_objective_complete_e8m3(e8_m3_obj_06 ));
	sleep_until(ai_living_count(sg_e8m3_forest_init) <= 5);
	b_trigger_forest_adds = TRUE;
end

script static void f_start_event_e8m3_5_1()
	sleep_until(LevelEventStatus("start_event_5_1"), 1);
	print("START EVENT 5 1");
	thread(f_phantom_load_playload_ghost(e8m3_phantom_fore_ghost, e8m3_ghosts_c_adds.1, e8m3_ghosts_c_adds.2));
	ai_place(e8m3_phantom_fore_ghost);
end

script static void f_start_event_e8m3_5_4()
	sleep_until(LevelEventStatus("start_event_5_4"), 1);
	print("START EVENT 5 4");
	thread(f_phantom_load_playload(e8m3_phantom_fore_wraith, e8m3_wraith_c_1));
	ai_place(e8m3_phantom_fore_wraith);
	sleep_s(random_range(10, 15));
	thread(f_phantom_load_playload(e8m3_phantom_cave_wraith, e8m3_wraith_c_2));
	ai_place(e8m3_phantom_cave_wraith);
	b_phantom_stay = TRUE;
	thread(f_e8m3_blip_last_cave_enemies());
end

script static void f_end_event_e8m3_6()
	sleep_until(LevelEventStatus("end_event_6"), 1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	pup_play_show(e8_m3_marines);
	thread(f_e8m3_music_switchback());
	thread(vo_e8m3_found_spartans());
	sleep_s(5);
	thread(f_objective_complete_e8m3(e8_m3_obj_06b));
end
	

script static void f_start_event_e8m3_6()
	sleep_until(LevelEventStatus("start_event_6"), 1);
	print("START EVENT 6");
	//sleep_until(b_trigger_forest_adds == TRUE);
	//b_end_player_goal = TRUE;
	//device_set_power(cavern_back_door, 1);
	//sleep(1);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_retexturedtempledoor_open_mnde845', cavern_back_door, 1 );
	//device_set_position(cavern_back_door, 1);
end

script static void f_start_event_e8m3_8()
	sleep_until(LevelEventStatus("start_event_8"), 1);
	print("START EVENT 8");
	//device_set_power(e8m3_release_marines, 1);
end

script static void f_end_event_e8m3_8()
	sleep_until(LevelEventStatus("end_event_8"), 1);
	print("END EVENT 8");
	local long front_button_show = pup_play_show(release_marines_show_down);
	sleep_until (not pup_is_playing(front_button_show), 1);
	//device_set_power(e8m3_release_marines, 0);
end

script static void f_start_event_e8m3_8_b()
	sleep_until(LevelEventStatus("start_event_8_b"), 1);
	print("START EVENT 8 B");
	b_wait_for_narrative_hud = true; 
	//sleep_until(e8m3_narrative_is_on == FALSE);
	//thread(vo_e8m3_detect_power_backwall());
	//sleep(1);
	//sleep_until(e8m3_narrative_is_on == FALSE);
	//f_blip_object(e8m3_release_marines, "default");
	//sleep_s(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	sleep(1);
	device_set_power(e10m2_switch_back_door, 1);
	b_wait_for_narrative_hud = false; 	
	thread(vo_e8m3_flips_switch());
	sleep(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	//f_unblip_object(e8m3_release_marines);
	//b_wait_for_narrative_hud = false; 
	//thread(f_objective_complete_e8m3(e8_m3_obj_06b));

end

script static void f_end_event_e8m3_8_b()
	sleep_until(LevelEventStatus("end_event_8_b"), 1);
	print("END EVENT 8 B");
	thread(f_e8m3_music_back_door_open());
	local long button_show = pup_play_show(e8m3_back_door_switch);
	sleep_until (not pup_is_playing(button_show), 1);
	device_set_power(e10m2_switch_back_door, 0);
	device_set_power(cavern_back_door, 1);
	sleep(1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_retexturedtempledoor_open_mnde845', cavern_back_door, 1 ); //AUDIO!
	device_set_position(cavern_back_door, 1);
	ai_place(e8_m3_marines_2);
	sleep(1);
	ai_cannot_die(e8_m3_marines_2, TRUE);
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_covenant_prometheans());
	sleep(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(f_e8m3_music_forerunner_structure_2_begin());
end

script static void f_start_event_e8m3_10()
	sleep_until(LevelEventStatus("start_event_10"), 1);
	print("START EVENT 10");
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_dropships());
	//sleep(1);
	//sleep_until(e8m3_narrative_is_on == FALSE);
	//thread(f_objective_complete_e8m3(e8_m3_obj_07));
	//f_blip_flag(e8m3_flg_caverns_exit, "default");
	//sleep_until(volume_test_players_lookat(e8m3_tv_exit_look, 40, 40));
	//sleep_s(1);
	//f_unblip_flag(e8m3_flg_caverns_exit);
end

script static void f_start_event_e8m3_10_1()
	sleep_until(LevelEventStatus("start_event_10_1"), 1);
	print("START EVENT 10");
	thread(f_objective_complete_e8m3(e8_m3_obj_08 ));
	sleep_until(ai_living_count(e8m3_pelican_save) <= 0);
	ai_place(e8m3_pelican);
end

script static void f_end_event_e8m3_10()
	sleep_until(LevelEventStatus("end_event_10"), 1);
	print("END EVENT 10");
	print ("ending the mission with fadeout and chapter complete");
end

script static void f_start_event_e8m3_12()
	sleep_until(LevelEventStatus("start_event_12"), 1);
	print("START EVENT 12");
	b_wait_for_narrative_hud = true;
	sleep_s(1);
	sleep_until(e8m3_narrative_is_on == FALSE);
	print("no narrative playing");
	//object_hide(e8m3_release_marines_2, false);
	//object_dissolve_from_marker(e8m3_release_marines_2, "phase_in", "button_marker");	
	//pup_play_show(release_marines_2_show_up);
	//sleep_until(e8m3_narrative_is_on == FALSE);
	//thread(vo_e8m3_power_location());
	//sleep(1);
  //sleep_until(e8m3_narrative_is_on == FALSE);
	b_wait_for_narrative_hud = false;
	print("blip it kid");
	f_blip_flag(e8m3_flg_blip_release, "activate");
	device_set_power(e8m3_release_invis, 1);
	print("button active");
end

script static void f_end_event_e8m3_12()
	sleep_until(LevelEventStatus("end_event_12"), 1);
	print("END EVENT 12");
	f_unblip_flag(e8m3_flg_blip_release);
	device_set_power(e8m3_release_invis, 0);
	local long back_button_show = pup_play_show(release_marines_2_show_down);
	sleep_until (not pup_is_playing(back_button_show), 1);
	thread ( f_end_event_e8m3_12_sfx() );
	object_set_function_variable(e8m3_fore_shield_1, shield_alpha, 1, 5);
	sleep_s(5);
	object_destroy_folder(e8m3_shield_2);
	b_shield_on = FALSE;
	effects_distortion_enabled = 0;
	thread(f_marines_get_weapons());
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_shut_down_power());
	sleep(1);
	ai_set_objective(e8_m3_marines_1, m8e3_marines_2);
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(f_e8m3_evac_blips());
	thread(f_e8m3_music_extraction_begin());
	ai_vehicle_reserve(e8m3_spartan_hog_2, FALSE);
	ai_vehicle_reserve(e8m3_spartan_hog_1, FALSE);
	ai_vehicle_reserve(war1, FALSE);
	ai_vehicle_reserve(war2, FALSE);
	
end

script static void f_end_event_e8m3_12_sfx()
	sleep_s (4);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_caverns_small_door_hardlight_001_off', e8m3_fore_shield_1, 1 ); //AUDIO!
end

script static void f_e8m3_evac_blips
	if volume_test_players(tv_e8m3_bc_exit_1) == FALSE
	then f_blip_flag(flg_e8m3_caverns_exit_1, "default");
	end
	sleep_until(volume_test_players(tv_e8m3_bc_exit_1), 1);
	f_unblip_flag(flg_e8m3_caverns_exit_1);
	if volume_test_players(tv_e8m3_bc_exit_2) == FALSE
	then f_blip_flag(flg_e8m3_caverns_exit_2, "default");
	end
	sleep_until(volume_test_players(tv_e8m3_bc_exit_2), 1);
	f_unblip_flag(flg_e8m3_caverns_exit_2);
end

script static void f_start_event_e8m3_14()
	sleep_until(LevelEventStatus("start_event_14"), 1);
	print("START EVENT 14");
	thread(f_e8m3_music_extraction_end());
	f_blip_object_cui (unit_get_vehicle(e8m3_pelican.driver), "navpoint_goto");
	sleep_until(volume_test_players(e8m3_tv_end), 1);
	thread(f_e8m3_music_stop());
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_switchback_home());
  fade_out (0,0,0,60);
	player_control_fade_out_all_input (.5);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	sleep_until(e8m3_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;	
end

script static void f_blip_leader()
	local object_list l_blipList = ai_actors(sg_e8m3_before_door);
	local short s_living = list_count_not_dead(l_blipList);
	local short s_leader = random_range(0, s_living - 1);
	if s_living > 0
		then
			f_blip_ai_cui(object_get_ai(list_get(l_blipList, s_leader)), "navpoint_healthbar_neutralize");
			sleep_until(ai_living_count(object_get_ai(list_get(l_blipList, s_leader))) <= 0, 1);
			print("leader DEAD");
		else
			print("No one is alive");
		end
end

script static void f_objective_complete_e8m3(string_id objective_text)
	f_objective_complete();
	sleep_s(2);
	f_new_objective(objective_text);
end

script static void f_foreshadow_dialogue
	sleep_until(LevelEventStatus("foreshadow_dialog"), 1);
	thread(f_e8m3_music_bowl_encounter_end());
	sleep_until(e8m3_narrative_is_on == FALSE);
	thread(vo_e8m3_power_source());
end

script static void f_extend_forest

	sleep_until(LevelEventStatus("bring_in_forest_2"), 1);
	
	ai_place(e8m3_forest_Adds_4);
	
	sleep_s(0.5);
	thread ( f_extend_forest_sfx() );
	object_set_function_variable(e8m3_fore_shield_2, shield_alpha, 1, 5);
	sleep_s(5);
	object_destroy_folder(e8m3_shield_3);
	effects_perf_armageddon = 0;
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, e8m3_bishops_2);
	sleep_s(0.5);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, e8m3_bishops_2);
	sleep_s(3);
	ai_place_in_limbo(e8m3_forest_Adds_3);
	sleep_s(3);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, e8m3_bishops_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, e8m3_bishops_2);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, e8m3_bishops_2);
	effects_perf_armageddon = 1;
	sleep_until(ai_living_count(sg_e8m3_all) <= 3, 1);
	if ai_living_count(sg_e8m3_all) > 0
	then if e8m3_narrative_is_on == FALSE
			then vo_glo15_palmer_fewmore_02();
			end
			 		f_blip_ai_cui(sg_e8m3_all, "navpoint_enemy");
	end
end

script static void f_extend_forest_sfx()
	sleep_s (4);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_caverns_small_door_hardlight_001_off', e8m3_fore_shield_2, 1 ); //AUDIO!
end

script static void f_forerunner_structure_music
	sleep_until(LevelEventStatus("forerunner_music_1_begin"), 1);
	thread(f_e8m3_music_forerunner_structure_begin());
	sleep_until(LevelEventStatus("forerunner_music_1_end"), 1);
	thread(f_e8m3_music_forerunner_structure_end());
end

script static void f_forerunner_structure_music_2
	sleep_until(LevelEventStatus("forerunner_music_2_end"), 1);
	thread(f_e8m3_music_forerunner_structure_2_end());
end

script static void f_e8m3_blip_last_cave_enemies
	sleep_until(ai_living_count(sg_e8m3_all) <= 5, 1);
	if e8m3_narrative_is_on == FALSE 
	then vo_glo15_miller_few_more_06();
	end
	f_blip_ai_cui(sg_e8m3_cavern_adds_2, "navpoint_enemy");
	f_blip_ai_cui(sg_e8m3_cavern_adds_3, "navpoint_enemy");
	f_blip_ai_cui(sg_e8m3_cavern_adds_1, "navpoint_enemy");
	f_blip_ai_cui(sg_e8m3_cavern_init, "navpoint_enemy");
	if unit_in_vehicle(e8m3_wraith_c_1.driver) == TRUE then
		spops_blip_object(ai_vehicle_get_from_squad(e8m3_wraith_c_1, 0), TRUE, "neutralize_health");
		thread(f_wraith_hijack_check(e8m3_wraith_c_1.driver));
	end
	if unit_in_vehicle(e8m3_wraith_c_2.driver) == TRUE then
		spops_blip_object(ai_vehicle_get_from_squad(e8m3_wraith_c_2, 0), TRUE, "neutralize_health");	
		thread(f_wraith_hijack_check(e8m3_wraith_c_2.driver));
	end
end

script static void f_wraith_hijack_check(unit u_driver)

	local vehicle o_vehicle = unit_get_vehicle(u_driver);
	print("TESTING THE SEATS");
	sleep_until(unit_in_vehicle(u_driver) == FALSE, 1);
	print("NO ONE IS IN ME");
	f_unblip_object_cui(o_vehicle);
	
end
	
// ============================================	PLACEMENT SCRIPT	========================================================
// CALLOUTS

script dormant f_83_phantom_wraith_co_1()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_miller_wraith_01();
	end
end

script dormant f_83_phantom_wraith_co_2()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_palmer_phantom_01();
	end
end

script dormant f_83_phantom_wraith_co_3()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE AND volume_test_players(tv_83_vo_back)
	then vo_glo15_palmer_wraiths_01();
	end
end

script dormant f_83_phantom_ghost_co_1()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_miller_ghosts_01();
	end
end

script dormant f_83_phantom_ghost_co_2()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_miller_reinforcements_03();
	end
end

script dormant f_83_phantom_ghost_co_3()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE AND volume_test_players(tv_83_vo_back)
	then vo_glo15_miller_ghosts_01();
	end
end

script dormant f_83_phantom_re_co_1()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE AND volume_test_players(tv_83_vo_front)
	then vo_glo15_palmer_reinforcements_01();
	end
end

script dormant f_83_phantom_re_co_2()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE AND volume_test_players(tv_83_vo_front)
	then vo_glo15_miller_reinforcements_02();
	end
end

script dormant f_83_phantom_re_co_3()
	if e8m3_narrative_is_on == FALSE AND global_narrative_is_on == FALSE AND volume_test_players(tv_83_vo_front)
	then vo_glo15_miller_phantom_01();
	end
end

// PHANTOM SCRIPTING

script command_script cs_e8m3_phantom_g_w_1()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_w_1_ps.p0 );
	cs_fly_to( e8m3_p_w_1_ps.p1 );
	cs_fly_to (e8m3_p_w_1_ps.p2 );
	//wake(f_83_phantom_wraith_co_1);
	cs_fly_to_and_face (e8m3_p_w_1_ps.p3, e8m3_p_w_1_ps.p5 );

	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_w_1.driver ), "phantom_lc" );
	
	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m3_p_w_1_ps.p2, e8m3_p_w_1_ps.p5);
	cs_fly_to( e8m3_p_w_1_ps.p1 );
	cs_fly_to( e8m3_p_w_1_ps.p0 );
	cs_fly_to( e8m3_p_w_1_ps.p4 );

	ai_erase (e8m3_phantom_g_w_1);
end


script command_script cs_e8m3_phantom_g_g_3()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_g_3_ps.p0 );
	cs_fly_to( e8m3_p_g_3_ps.p1 );
	cs_fly_to( e8m3_p_g_3_ps.p6 );
	cs_fly_to (e8m3_p_g_3_ps.p2 );
	//wake(f_83_phantom_ghost_co_1);
	cs_fly_to_and_face (e8m3_p_g_3_ps.p3, e8m3_p_g_3_ps.p5 );

	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_g_3.driver ), "phantom_sc01" );
	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_g_3.driver ), "phantom_sc02" );

	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m3_p_g_3_ps.p2, e8m3_p_g_3_ps.p5);
	cs_fly_to( e8m3_p_g_3_ps.p6 );
	cs_fly_to( e8m3_p_g_3_ps.p1 );
	cs_fly_to( e8m3_p_g_3_ps.p0 );
	cs_fly_to( e8m3_p_g_3_ps.p4 );

	ai_erase (e8m3_phantom_g_g_3);
end

script command_script cs_e8m3_phantom_g_g_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_g_2_ps.p0 );
	wake(f_83_phantom_ghost_co_2);
	cs_fly_to( e8m3_p_g_2_ps.p1 );
	cs_fly_to (e8m3_p_g_2_ps.p2 );
	//cs_throttle_set( ai_current_actor, TRUE, .1);
	cs_fly_to_and_face (e8m3_p_g_2_ps.p3, e8m3_p_g_2_ps.p5 );

	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_g_2.driver ), "phantom_sc01" );
	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_g_2.driver ), "phantom_sc02" );

	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m3_p_g_2_ps.p2, e8m3_p_g_2_ps.p5);
	cs_fly_to( e8m3_p_g_2_ps.p1 );
	cs_fly_to( e8m3_p_g_2_ps.p0 );
	cs_fly_to( e8m3_p_g_2_ps.p4 );

	ai_erase (e8m3_phantom_g_g_2);
end

script command_script cs_e8m3_phantom_g_w_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_w_2_ps.p0 );
	wake(f_83_phantom_wraith_co_2);
	cs_fly_to( e8m3_p_w_2_ps.p1 );
	cs_fly_to (e8m3_p_w_2_ps.p2 );
	cs_fly_to_and_face (e8m3_p_w_2_ps.p3, e8m3_p_w_2_ps.p5 );

	vehicle_unload( unit_get_vehicle( e8m3_phantom_g_w_2.driver ), "phantom_lc" );

	print ("unload wraith right");
	
	cs_fly_to_and_face( e8m3_p_w_2_ps.p2, e8m3_p_w_2_ps.p5);
	cs_fly_to( e8m3_p_w_2_ps.p1 );
	cs_fly_to( e8m3_p_w_2_ps.p0 );
	cs_fly_to( e8m3_p_w_2_ps.p4 );

	ai_erase (e8m3_phantom_g_w_2);
end

script command_script cs_e8m3_phantom_forest()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	//cs_fly_to( E8M3_P_Fore_Ps.p0 );
	cs_fly_to_and_face( e8m3_p_fore_ps.p1,  e8m3_p_fore_ps.p9);
	//cs_fly_to (e8m3_p_fore_ps.p2 );
	cs_fly_to_and_face (e8m3_p_fore_ps.p3, e8m3_p_fore_ps.p9);
	cs_fly_to_and_face (e8m3_p_fore_ps.p8, e8m3_p_fore_ps.p9);

	f_unload_phantom( e8m3_phantom_fore, "dual" );
	b_spartans_storm_structure = TRUE;
	ai_vehicle_exit(e8_m3_marines_1);
	ai_vehicle_reserve(e8m3_spartan_hog_2, TRUE);
	ai_vehicle_reserve(e8m3_spartan_hog_1, TRUE);
	ai_vehicle_reserve(war1, TRUE);
	ai_vehicle_reserve(war2, TRUE);


	print ("unload wraith right");
	
	cs_fly_to_and_face (e8m3_p_fore_ps.p3, e8m3_p_fore_ps.p9);
	cs_fly_to_and_face( e8m3_p_fore_ps.p2, e8m3_p_fore_ps.p9 );
	cs_fly_to_and_face( e8m3_p_fore_ps.p1, e8m3_p_fore_ps.p9 );
	cs_fly_to_and_face( e8m3_p_fore_ps.p0, e8m3_p_fore_ps.p9 );

	ai_erase (e8m3_phantom_fore);
end

script command_script cs_e8m3_phantom_forest_ghost()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	//cs_fly_to( e8m3_p_fore_v_ps.p0 );
	cs_fly_to_and_face( e8m3_p_fore_v_ps.p1, e8m3_p_fore_v_ps.p2 );
	cs_fly_to (e8m3_p_fore_v_ps.p2 );
	cs_fly_to (e8m3_p_fore_v_ps.p11 );
	cs_fly_to (e8m3_p_fore_v_ps.p3);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p10, e8m3_p_fore_v_ps.p9);
	wake(f_83_phantom_ghost_co_3);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p8, e8m3_p_fore_v_ps.p9);

	vehicle_unload( unit_get_vehicle( e8m3_phantom_fore_ghost.driver ), "phantom_sc01" );
	vehicle_unload( unit_get_vehicle( e8m3_phantom_fore_ghost.driver ), "phantom_sc02" );

	print ("unload wraith right");
	
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p8, e8m3_p_fore_v_ps.p9);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p10, e8m3_p_fore_v_ps.p9);
	cs_fly_to( e8m3_p_fore_v_ps.p4);
	cs_fly_to( e8m3_p_fore_v_ps.p5 );
	cs_fly_to( e8m3_p_fore_v_ps.p6 );
	cs_fly_to( e8m3_p_fore_v_ps.p7 );

	ai_erase (e8m3_phantom_fore_ghost);
end

script command_script cs_e8m3_phantom_forest_wraith()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	//cs_fly_to( e8m3_p_fore_v_ps.p0 );
	cs_fly_to( e8m3_p_fore_v_ps.p1 );
	cs_fly_to (e8m3_p_fore_v_ps.p2 );
	cs_fly_to (e8m3_p_fore_v_ps.p3);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p10, e8m3_p_fore_v_ps.p9);
	wake(f_83_phantom_wraith_co_3);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p8, e8m3_p_fore_v_ps.p9);

	vehicle_unload( unit_get_vehicle( e8m3_phantom_fore_wraith.driver ), "phantom_lc" );

	print ("unload wraith right");
	
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p8, e8m3_p_fore_v_ps.p9);
	cs_fly_to_and_face (e8m3_p_fore_v_ps.p10, e8m3_p_fore_v_ps.p9);
	cs_fly_to( e8m3_p_fore_v_ps.p4);
	cs_fly_to( e8m3_p_fore_v_ps.p5 );
	cs_fly_to( e8m3_p_fore_v_ps.p6 );
	cs_fly_to( e8m3_p_fore_v_ps.p7 );

	ai_erase (e8m3_phantom_fore_wraith);
end

script command_script cs_e8m3_phantom_cave()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_cave_ps.p0 );
	cs_fly_to( e8m3_p_cave_ps.p1 );
	cs_fly_to (e8m3_p_cave_ps.p2 );
	cs_fly_to (e8m3_p_cave_ps.p3);

	f_unload_phantom(e8m3_phantom_cave, "dual");

	print ("unload wraith right");
	
	if b_phantom_stay == TRUE then
		prepare_to_switch_to_zone_set (e8_m3_int);
		sleep(1);
		sleep_until (not PreparingToSwitchZoneSet(), 1);
		switch_zone_set (e8_m3_int);
		cs_fly_to_and_face (e8m3_p_cave_ps.p10, e8m3_p_cave_ps.p11);
		cs_fly_to_and_dock (e8m3_p_cave_ps.p10, e8m3_p_cave_ps.p11, 45);
		sleep_until(volume_test_players_lookat(tv_see_phantom, 40, 40) OR ai_living_count(sg_e8m3_finale) <= 5, 1);
		ai_place(e8m3_pelican_save);
		sleep_s(1);
		b_bring_in_murphy = TRUE;
		
	else
		wake(f_83_phantom_re_co_1);
		cs_fly_to( e8m3_p_cave_ps.p2);
		cs_fly_to( e8m3_p_cave_ps.p1 );
		cs_fly_to( e8m3_p_cave_ps.p0 );
		cs_fly_to( e8m3_p_cave_ps.p4 );

		ai_erase (e8m3_phantom_cave);
	end
end

script command_script cs_e8m3_phantom_cave_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_cave_ps.p0 );
	wake(f_83_phantom_re_co_3);
	cs_fly_to( e8m3_p_cave_ps.p1 );
	cs_fly_to (e8m3_p_cave_ps.p2 );
	cs_fly_to (e8m3_p_cave_ps.p6);
	cs_fly_to (e8m3_p_cave_ps.p7);

	f_unload_phantom(e8m3_phantom_cave_2, "dual");

	print ("unload wraith right");

	cs_fly_to( e8m3_p_cave_ps.p8);
	cs_fly_to( e8m3_p_cave_ps.p9 );
	cs_fly_to( e8m3_p_cave_ps.p4 );

	ai_erase (e8m3_phantom_cave_2);

end

script command_script cs_e8m3_phantom_cave_wraith()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m3_p_cave_v_ps.p0 );
	cs_fly_to( e8m3_p_cave_v_ps.p1 );
	cs_fly_to (e8m3_p_cave_v_ps.p2 );
	cs_fly_to_and_face (e8m3_p_cave_v_ps.p3, e8m3_p_cave_v_ps.p5);
	wake(f_83_phantom_re_co_2);
	cs_fly_to_and_face (e8m3_p_cave_v_ps.p3, e8m3_p_cave_v_ps.p6);

	vehicle_unload( unit_get_vehicle( e8m3_phantom_cave_wraith.driver ), "phantom_lc" );

	print ("unload wraith right");
	
	cs_fly_to( e8m3_p_cave_v_ps.p2);
	cs_fly_to( e8m3_p_cave_v_ps.p1 );
	cs_fly_to( e8m3_p_cave_v_ps.p0 );
	cs_fly_to( e8m3_p_cave_v_ps.p4 );

	ai_erase (e8m3_phantom_cave_wraith);
end

script command_script cs_e8m3_pelican()

	cs_ignore_obstacles( ai_current_actor, TRUE );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	ai_cannot_die(ai_current_actor, TRUE);

	cs_fly_by( e8m3_pelican_ps.p0 );
	cs_fly_by( e8m3_pelican_ps.p1 );
	cs_fly_to_and_face (e8m3_pelican_ps.p2, e8m3_pelican_ps.p3);
	
end

script command_script cs_e8m3_pelican_save()
	
	local short s_leave = 0;
	
	cs_ignore_obstacles( ai_current_actor, TRUE );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	ai_cannot_die(ai_current_actor, TRUE);	

	cs_fly_by( e8m3_pelican_save_ps.p0 );
	cs_fly_by( e8m3_pelican_save_ps.p1 );
	//cs_fly_by(e8m3_pelican_save_ps.p5);
	cs_fly_to (e8m3_pelican_save_ps.p3);
	sleep_s(1);
	repeat
	 cs_shoot(TRUE, ai_vehicle_get_from_spawn_point(e8m3_phantom_cave.driver));
	 s_leave = s_leave + 1;
	until(s_leave == 5);
	damage_objects(ai_vehicle_get_from_spawn_point(e8m3_phantom_cave.driver), "hull",5000);
	sleep_s(1);
	cs_fly_by( e8m3_pelican_save_ps.p1 );
	cs_fly_by( e8m3_pelican_save_ps.p0 );
	cs_fly_to( e8m3_pelican_save_ps.p4 );
	ai_erase(e8m3_pelican_save);
	
end

script static void f_phantom_load_playload (ai dropship, ai squad1)
	print ("spawning payload");
	ai_place_in_limbo  (squad1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_lc", ai_vehicle_get_from_squad(squad1, 0));
	print ("payload attached");
	ai_exit_limbo (squad1);
end

script static void f_phantom_load_playload_ghost (ai dropship, ai unit1, ai unit2)
	print ("spawning payload");
	ai_place_in_limbo  (unit1);
	ai_place_in_limbo  (unit2);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc01", unit_get_vehicle(unit1));
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc02", unit_get_vehicle(unit2));
	print ("payload attached");
	ai_exit_limbo (unit1);
	ai_exit_limbo (unit2);
end

script static void f_phantom_load_playload_ghost_2 (ai dropship, ai unit1)
	print ("spawning payload");
	ai_place_in_limbo  (unit1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc01", unit_get_vehicle(unit1));
	print ("payload attached");
	ai_exit_limbo (unit1);
end

script static void f_phantom_test()
	ai_place(e8m3_phantom_fore);
	f_load_phantom(e8m3_phantom_fore, "dual", e8m3_forest_init_1, e8m3_forest_init_2, e8m3_forest_init_3, e8m3_forest_init_4);
end

script dormant f_check_turrets()
	sleep_until ( volume_test_objects ( tv_turret_travel, (ai_actors (sg_e8m3_forest_init))) OR volume_test_objects ( tv_e8m3_forest_platform, (ai_actors (sg_e8m3_forest_init))));
	b_turret_move_up = TRUE;
end

script command_script cs_e8_m3_bishop_spawn()
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1);                          //Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	sleep(40);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);                                           //grow size over time
end

script static void f_marines_get_weapons()
	cs_run_command_script(e8_m3_marines_2.spartan_1, cs_marines_get_guns_1);
	sleep(5);
	cs_run_command_script(e8_m3_marines_2.spartan_2, cs_marines_get_guns_2);
	sleep(5);
	cs_run_command_script(e8_m3_marines_2.spartan_3, cs_marines_get_guns_3);
	sleep(5);
	cs_run_command_script(e8_m3_marines_2.spartan_4, cs_marines_get_guns_4);
	sleep(5);
end


script command_script cs_marines_get_guns_1()
	sleep(random_range(1, 20));
	cs_go_to(e8m3_weapon_rack.p7);
	cs_face(TRUE, e8m3_weapon_rack.p3);
	//object_create_anew(e8m3_wr1);
	//sleep(1);
	unit_add_weapon(ai_get_unit(ai_current_actor), e8m3_ac1, 4);
end

script command_script cs_marines_get_guns_2()
	sleep(random_range(1, 20));
	cs_go_to(e8m3_weapon_rack.p6);
	cs_face(TRUE, e8m3_weapon_rack.p2);
	//object_create_anew(e8m3_wr1);
	//sleep(1);
	unit_add_weapon(ai_get_unit(ai_current_actor), e8m3_ne1, 4);
end

script command_script cs_marines_get_guns_3()
	sleep(random_range(1, 20));
	cs_go_to(e8m3_weapon_rack.p4);
	cs_face(TRUE, e8m3_weapon_rack.p1);
	//object_create_anew(e8m3_wr2);
	//sleep(1);
	unit_add_weapon(ai_get_unit(ai_current_actor), e8m3_ne2, 4);
end

script command_script cs_marines_get_guns_4()
	sleep(random_range(1, 20));
	cs_go_to(e8m3_weapon_rack.p5);
	cs_face(TRUE, e8m3_weapon_rack.p0);
	//object_create_anew(e8m3_wr2);
	//sleep(1);
	unit_add_weapon(ai_get_unit(ai_current_actor), e8m3_ac2, 4);
end

script static void f_spartans_take_hogs()
	local short s_marines_left = ai_living_count(e8_m3_marines_1);
	
	if ai_in_vehicle_count(e8_m3_marines_1) < s_marines_left
	then
		if volume_test_object(e8m3_start_zone, e8m3_spartan_hog_1) == TRUE
		then 
			repeat cs_run_command_script(e8_m3_marines_1, cs_hog_1_enter);
						 sleep(15);
			until(ai_in_vehicle_count(e8_m3_marines_1) > s_marines_left);
			else if volume_test_object(e8m3_start_zone, e8m3_spartan_hog_2) == TRUE
			then
				repeat cs_run_command_script(e8_m3_marines_1, cs_hog_2_enter);
							 sleep(15);
				until(ai_in_vehicle_count(e8_m3_marines_1) > s_marines_left);
			end
		end
	end
end

script command_script cs_hog_1_enter
	if unit_in_vehicle(ai_current_actor) == FALSE
	then ai_vehicle_enter(ai_current_actor, e8m3_spartan_hog_1);
	end
end

script command_script cs_hog_2_enter
	if unit_in_vehicle(ai_current_actor) == FALSE
	then ai_vehicle_enter(ai_current_actor, e8m3_spartan_hog_2);
	end
end
	

// ============================================ ACTIVE CAMO SCRIPT =======================================================
script command_script cs_active_camo_use_e8m3()
  if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
  	dprint( "cs_active_camo_use: ENABLED" );
  	thread( f_active_camo_manager_e8m3(ai_current_actor) );
  end
end

script static void f_active_camo_manager_e8m3( ai ai_actor )
	local long l_timer = 0;
	local object obj_actor = ai_get_object( ai_actor );
	//dprint( "cs_active_camo_use: ENABLED" );

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