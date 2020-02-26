////=============================================================================================================================
//== COMPLEX FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//====== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
//==== GLOBALS ==================================================================
// =============================================================================================================================
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
global cutscene_title title_shut_down_comm_2 = shut_down_comm_2;
global cutscene_title title_lz_go_to = lz_go_to;
global cutscene_title title_drop_shields = drop_shields;
global cutscene_title title_shields_down = shields_down;
global cutscene_title title_clear_base = clear_base;
global cutscene_title title_clear_base_2 = clear_base_2;
global cutscene_title title_get_artifact = get_artifact;
global cutscene_title title_got_artifact = got_artifact;
global cutscene_title title_secure = secure;

// use this boolean to wait for puppeteer and intros
global boolean b_wait_for_narrative = false;
//global ai ai_ff_allies_1 = gr_ff_allies_1;
//global ai ai_ff_allies_2 = gr_ff_allies_2;

script startup complex

	//Start the intro
//	sleep_until (LevelEventStatus("test"), 1);
//	print ("******************STARTING TEST*********************");
//	switch_zone_set (destroy);
////	mission_is_e2_m2 = true;
////	b_wait_for_narrative = true;
//	ai_ff_all = gr_ff_all;
//
//	//start the drop pod intro -- this is causing trouble -- commenting out
//	thread(f_start_player_intro());
//
//
////================================================== AI ==================================================================
//
////	ai_ff_phantom_01 = sq_ff_phantom_01;
////	ai_ff_phantom_02 = sq_ff_phantom_02;
////	ai_ff_sq_marines = sq_ff_marines_1;
//
//	
////================================================== OBJECTS ==================================================================
////set crate names
//	f_add_crate_folder(cr_e3_m2_unsc_cover_1); //UNSC crates and barriers around the main spawn area
////	f_add_crate_folder(cr_destroy_cov_cover); //cov crates all around the main area
//	//f_add_crate_folder(cr_destroy_shields); //barriers that prevent getting to the top of the ziggurat
//	f_add_crate_folder(dm_destroy_shields); //barriers that prevent getting to the very back
//	f_add_crate_folder(cr_e3_m2_power_cores); //crates that blow up at the very back right
//	f_add_crate_folder(cr_e3_m2_unsc_cover_2);  //UNSC barriers in and around the front middle base
////	f_add_crate_folder(cr_capture); //Cov crates at the very back on the right
//	f_add_crate_folder(sc_e3_m2_unsc_1); //UNSC scenery in the main starting area
////	f_add_crate_folder(sc_defend_unsc, 8); //UNSC scenery in the front middle area
////	f_add_crate_folder(v_ff_mac_cannon, 9); //mac cannons in the very back on the right
////	f_add_crate_folder(wp_power_weapons, 10); //power weapons spawns aroung the main front area
////	f_add_crate_folder(cr_base_shields, 11); //shield walls that block in the middle back area
////	f_add_crate_folder(cr_barriers, 12); //shield walls that block the left side walkway
////	f_add_crate_folder(cr_powercore_extras, 13); //powercore fluff objects surrounding it
////	f_add_crate_folder(cr_meadow_cov_cover, 14); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(sc_defend_unsc_2, 15); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(cr_forerunner_cover); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(cr_forerunner_cover_2); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(v_e3_m2_unsc); //unsc vehicles
//	
////set ammo crate names
//	firefight_mode_set_crate_folder_at(eq_destroy_crates, 20); //ammo crates in main spawn area
//	firefight_mode_set_crate_folder_at(eq_defend_1_crates, 21); //ammo crates in front middle area
//	firefight_mode_set_crate_folder_at(eq_capture_crates, 22); //ammo crates in the very back right
//	firefight_mode_set_crate_folder_at(eq_defend_2_crates, 23); //ammo crates in back middle area
//	
////set spawn folder names
//	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns in the main starting area
//	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns in the front building
//	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the back building
//	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the left building
//	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //spawns in the back on the hill (facing the back)
//	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //spawns in the very back facing down the hill
//	
////set objective names
//	firefight_mode_set_objective_name_at(destroy_obj_1, 1); //objective in the left building
//	firefight_mode_set_objective_name_at(defend_obj_1, 2); //objective in the front building
//	firefight_mode_set_objective_name_at(defend_obj_2, 3); //objective in the front building
//	firefight_mode_set_objective_name_at(capture_obj_0, 4); //objective in the back middle building
////	firefight_mode_set_objective_name_at(v_mac_cannon_1, 5); //in right side in the WAY back
//	firefight_mode_set_objective_name_at(power_core, 6); //in right side in the WAY back
//	firefight_mode_set_objective_name_at(destroy_obj_2, 7);  //objective on the back middle building
//	firefight_mode_set_objective_name_at(destroy_obj_3, 8);  //objective in the front building
//	firefight_mode_set_objective_name_at(capture_obj_1, 9); //objective in the main starting area
//	firefight_mode_set_objective_name_at(objective_switch_1, 10); //touchscreen switch in the back middle base
//	firefight_mode_set_objective_name_at(defend_obj_3, 11); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_4, 12); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_5, 13); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_6, 14); //objective in the middle back building
//	firefight_mode_set_objective_name_at(power_core_meadow, 15); //objective in the meadow
//	firefight_mode_set_objective_name_at(dc_object_1, 16); //covenant computer terminal switch on the close end of the bridge
//	firefight_mode_set_objective_name_at(dm_object_1, 17); //covenant computer terminal on the close end of the bridge
//	
//	firefight_mode_set_objective_name_at(capture_obj_2, 18); //objective in the way back on the right
//	firefight_mode_set_objective_name_at(objective_switch_2, 19); //touchscreen switch in the left building
//	firefight_mode_set_objective_name_at(objective_switch_3, 20); //touchscreen switch in the front building
//	firefight_mode_set_objective_name_at(fore_switch_0, 21); //touchscreen switch in the very back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal, 22); //computer terminal in the very back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal_2, 23); //computer terminal in the  back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal_3, 24); //computer terminal in the left side building
//	
//	firefight_mode_set_objective_name_at(unsc_switch_1, 25); //computer terminal in the left side building
//	firefight_mode_set_objective_name_at(unsc_switch_2, 26); //computer terminal in the left side building
//	firefight_mode_set_objective_name_at(unsc_switch_3, 27); //computer terminal in the left side building
//			
//	firefight_mode_set_objective_name_at(lz_0, 50); //objective in the main spawn area
//	firefight_mode_set_objective_name_at(lz_1, 51); //objective in the middle front building
//	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(lz_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(lz_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(lz_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(lz_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(lz_7, 57); //objective right by the tunnel entrance
//	
////set squad group names
//
//	firefight_mode_set_squad_at(gr_ff_guards_1, 1);	//left building
//	firefight_mode_set_squad_at(gr_ff_guards_2, 2);	//front by the main start area
//	firefight_mode_set_squad_at(gr_ff_guards_3, 3);	//back middle building
//	firefight_mode_set_squad_at(gr_ff_guards_4, 4); //in the main start area
//	firefight_mode_set_squad_at(gr_ff_guards_5, 5); //right side in the back
//	firefight_mode_set_squad_at(gr_ff_guards_6, 6); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_ff_guards_7, 7); //middle building at the front
//	firefight_mode_set_squad_at(gr_ff_guards_8, 8); //on the bridge
//	firefight_mode_set_squad_at(gr_ff_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
//	firefight_mode_set_squad_at(gr_ff_waves, 11);
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
//	
//	firefight_mode_set_squad_at(gr_waves_1, 81);	//left building
//	firefight_mode_set_squad_at(gr_waves_2, 82);	//front by the main start area
//	firefight_mode_set_squad_at(gr_waves_3, 83);	//back middle building
//	firefight_mode_set_squad_at(gr_waves_4, 84); //in the main start area
//	firefight_mode_set_squad_at(gr_waves_5, 85); //right side in the back
//	firefight_mode_set_squad_at(gr_waves_6, 86); //right side in the back at the back structure

// ================================================== TITLES ==================================================================
	
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//========== MAIN SCRIPT STARTS ==================================================================
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);

	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	wake (start_waves);
end

script dormant start_waves
	wake (firefight_lost_game);
	wake (firefight_won_game);
	firefight_player_goals();
	print ("goals ended");
	print ("game won");
	//mp_round_end();
	b_game_won = true;

end

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

script static void setup_wait_for_trigger
	wake (objective_wait_for_trigger);
end

// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================

//script continuous terminal()
//	sleep_until (volume_test_players (terminal_volume), 1);
//	cinematic_set_title (terminal);
//	sleep_forever();
//
//end

//script continuous f_misc_m1_start_turrets
//	sleep_until (LevelEventStatus ("start_turrets"), 1);
//	//NotifyLevel("start_turrets");
//
//	m1_vo_start_turrets();
//end


//============================STARTING Ex Mx==============================


//script continuous f_start_events_e2_1
//	sleep_until (LevelEventStatus("start_e2_1"), 1);
//	print ("STARTING start_e2_1");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_1_vo();
//	//ai_place (sq_ff_marines_run_around);
//	cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_e2_1
//	sleep_until (LevelEventStatus("end_e2_1"), 1);
//	print ("STARTING end_e2_1");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//start_e1_m3_switch_1_vo();
//	//ai_place (sq_ff_marines_run_around);
//	//cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_start_events_e2_2
//	sleep_until (LevelEventStatus("start_e2_2"), 1);
//	print ("STARTING start_e2_2");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_2_vo();
//	cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_e2_2
//	sleep_until (LevelEventStatus("end_e2_2"), 1);
//	print ("ENDING start_e2_2");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_switch_2_vo();
//	//cinematic_set_title (title_first_tower_down);
//end
//
//script continuous f_start_events_e2_3
//	sleep_until (LevelEventStatus("start_e2_3"), 1);
//	print ("STARTING start_e2_3");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_3_vo();
//	cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_e2_3
//	sleep_until (LevelEventStatus("end_e2_3"), 1);
//	print ("ENDING start_e2_3");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_switch_3_vo();
//	//cinematic_set_title (title_both_tower_down);
//end

//script continuous f_start_events_e1_m3_4
//	sleep_until (LevelEventStatus("start_e1_m3_lz_1"), 1);
//	print ("STARTING start_e1_m3_lz_1");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_lz_1_vo();
//	cinematic_set_title (title_lz_go_to);
//end
//
//script continuous f_start_events_e1_m3_5
//	sleep_until (LevelEventStatus("start_e1_m3_lz_2"), 1);
//	print ("STARTING start_e1_m3_lz_2");
//	//sleep (30);
//	//sound_looping_start (music_start, NONE, 1.0);
//	//sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_lz_2_vo();
//	cinematic_set_title (title_lz_go_to);
//end
//
//script continuous f_end_events_e1_m3_5
//	sleep_until (LevelEventStatus("end_e1_m3_lz_2"), 1);
//	print ("ENDING start_e1_m3_lz_2");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_lz_2_vo();
//	cinematic_set_title (title_lz_end);
//end

//script continuous f_start_events_e2_4
//	sleep_until (LevelEventStatus("start_e2_4"), 1);
//	print ("STARTING start_e2_4");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_lz_3_vo();
//	cinematic_set_title (title_swarm_1);
//end
//
//script continuous f_end_events_e2_4
//	sleep_until (LevelEventStatus("end_e2_4"), 1);
//	print ("ENDING start_e2_4");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_lz_3_vo();
//	cinematic_set_title (title_secure);
//end
//
//
//
//script continuous f_start_events_goals_m5_atob_2
//	sleep_until (LevelEventStatus("start_atob_2"), 1);
//	m5_vo_start_atob_2();
//	cinematic_set_title (lz_go_to);
//end
//
////misc event scripts
//script continuous f_misc_events_oyo_weapon_drop
//	sleep_until (LevelEventStatus("oyo_weapon_drop"), 1);
////	cinematic_set_title (weapon_drop);
//	m1_vo_weapon_drop_1();
////	f_resupply_pod (dm_target_02, sc_target_02);
//end
//
//script continuous f_misc_events_m2_weapon_drop_1
//	sleep_until (LevelEventStatus("m2_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_resupply_02, sc_resupply_02);
//end
//
//script continuous f_misc_events_m2_weapon_drop_2
//	sleep_until (LevelEventStatus("m2_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
//	m2_vo_weapon_drop_2();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_resupply_01, sc_resupply_01);
//end
//
//script continuous f_misc_events_m2_weapon_drop_3
//	sleep_until (LevelEventStatus("m2_weapon_drop_3"), 1);
////	cinematic_set_title (weapon_drop);
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_resupply_03, sc_resupply_03);
//end
//
//script continuous f_misc_events_m5_weapon_drop_1
//	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
//	m5_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_target_01, sc_target_01);
//end
//
//script continuous f_misc_events_m5_weapon_drop_2
//	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_target_02, sc_target_02);
//end


//script continuous f_end_events_goals_powercore_destroy
//	sleep_until (LevelEventStatus("powercore_destroy"), 1);
//	m2_vo_powercore_destroy();
//	cinematic_set_title (title_objective_3);
//
//end

//script continuous f_end_events_goals_capture_artifact
//	sleep_until (LevelEventStatus("capture_artifact"), 1);
//	//m2_vo_powercore_destroy();
//	cinematic_set_title (title_capture_3);
//
//end



//script continuous f_more_enemies_1
//	sleep_until (LevelEventStatus("more_enemies"), 1);
//	print ("more enemies event");
//	cinematic_set_title (title_more_enemies);
//	m1_vo_more_enemies_1();
//
//end
//
//script continuous f_incoming_elites
//	sleep_until (LevelEventStatus("incoming_elites"), 1);
//	print ("incoming elites event");
//	m5_vo_elites_incoming();
//	
//end
//
//script continuous f_invading_hunters
//	sleep_until (LevelEventStatus("invading_hunters"), 1);
//	print ("invading hunters event");
//	cinematic_set_title (invading);
//	m1_vo_invading_1();
//	
//	sound_looping_start (fx_misc_warning, NONE, 1.0);
//	sleep (30 * 10);
//	sound_looping_stop (fx_misc_warning);
//end
//
//script continuous f_invading_zealots
//	sleep_until (LevelEventStatus("invading_zealots"), 1);
//	print ("invading zealots event");
//	cinematic_set_title (invading);
//	m1_vo_invading_2();
//
//	sound_looping_start (fx_misc_warning, NONE, 1.0);
//	sleep (30 * 10);
//	sound_looping_stop (fx_misc_warning);
//end
//
//script continuous f_oyo_reinforcements
//	sleep_until (LevelEventStatus("marine_drop"), 1);
//	m1_vo_reinforcements();
//end
//
//script continuous f_defend_message_2
//	sleep_until (LevelEventStatus("not_many_left"), 1);
//	cinematic_set_title (title_not_many_left);
//	m1_vo_not_many_left();
//end
//
//
//
//script continuous f_wait_for_small_pod_0
//	sleep_until (LevelEventStatus("pod_0"), 1);
//	print ("pod_0 launching");
//	cinematic_set_title (incoming);
//	m1_vo_enemy_drop_pod();
//	f_small_drop_pod_0();
//end
//
//script continuous f_wait_for_small_pod_1
//	sleep_until (LevelEventStatus("pod_1"), 1);
//	print ("pod_1 launching");
//	cinematic_set_title (incoming);
//	//sound_impulse_start (vo_misc_incoming, none, 1.0);
//	m2_vo_pod_1();
//	f_small_drop_pod_1();
//end



// ==============================================================================================================
// ====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================




//script command_script cs_drop_pod
//	sleep_s (5);
//	ai_set_objective (ai_current_squad, obj_survival);
//end

// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================



// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================



//script static void f_start_player_intro
//	firefight_mode_set_player_spawn_suppressed(true);
//	if editor_mode() then
//		firefight_mode_set_player_spawn_suppressed(false);
//	else
//		//intro();
//		firefight_mode_set_player_spawn_suppressed(false);
//	end
//	//intro();
//	//firefight_mode_set_player_spawn_suppressed(false);
//	//sleep_until (goal_finished == true);
//end

//
//script static void f_device_move (device_name device)
//	print ("device move");
//	device_set_position_track( device, 'any:idle', 1 );
////	device_set_position_immediate (bishop_tower_2, 0);
//	device_animate_position( device, 1, 5, 1, 0, 0 );
////	objects_attach (bishop_tower_2, "", objective_switch_2, "");
////	device_animate_position( bishop_tower_2, 1, 5, 1, 0, 0 );
//
//end
//
//script static void f_cover_move_1 (object_name column)
//	
//	object_move_by_offset (column, 6, 0, 0, 3);
//	//effect_new_on_ground (environments\solo\m10_crash\fx\steam_large_02.effect, column);
//	sleep_rand_s (2, 5);
//	//effect_stop_object_marker (environments\solo\m10_crash\fx\steam_large_02.effect, column, "");
//	object_move_by_offset (column, 12, 0, 0, -3);
//	sleep_rand_s (2, 5);
//end
//
//script static void f_cover_move_2 (object_name column)
//	
//	object_move_by_offset (column, 6, 0, 0, 1);
//	//effect_new_on_ground (environments\solo\m10_crash\fx\steam_large_02.effect, column);
//	sleep_rand_s (2, 5);
//	//effect_stop_object_marker (environments\solo\m10_crash\fx\steam_large_02.effect, column, "");
//	object_move_by_offset (column, 12, 0, 0, -1);
//	sleep_rand_s (2, 5);
//end

//script continuous f_moving_cover
//	print ("starting moving cover");
//	begin_random_count (3)
//		thread (f_cover_move_1 (column_a));
//		thread (f_cover_move_1 (column_b));
//		thread (f_cover_move_1 (column_c));
//		thread (f_cover_move_1 (column_d));
//		thread (f_cover_move_1 (column_e));
//		thread (f_cover_move_1 (column_f));
//	end
//	begin_random_count (3)
//		thread (f_cover_move_2 (column_g));
//		thread (f_cover_move_2 (column_h));
//		thread (f_cover_move_2 (column_i));
//		thread (f_cover_move_2 (column_j));
//		thread (f_cover_move_2 (column_k));
//		thread (f_cover_move_2 (column_l));
//		thread (f_cover_move_2 (column_m));
//	end
//
//	sleep_rand_s (30, 45);
//	
//end

//script static void skybox_move
//	repeat
//		object_rotate_by_offset (sky, 360, 0, 0, 45, 0, 0);
//	until (b_game_ended == true, 90);
//end

//script command_script cs_ff_pelican_test
//	cs_ignore_obstacles (TRUE);
//	object_create_anew (obj_ammo_crate0);
//  sleep (30);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point(test_pelican.pilot), "pelican_lc", ammo_crate0);
//	sleep (30);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	sleep (30 * 10);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (test_pelican.pilot), "pelican_lc");
//	sleep (30 * 10);
//	cs_fly_to (ps_ff_pelican.p3);
//
//end
