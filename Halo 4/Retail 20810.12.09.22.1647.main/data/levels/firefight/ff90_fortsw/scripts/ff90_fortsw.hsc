////=============================================================================================================================
//============================================ SCURVE FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_end = lz_end;
//global cutscene_title title_lz_go_to = lz_go_to;
//global cutscene_title	title_more_enemies = more_enemies;
//global cutscene_title	title_not_many_left = not_many_left;
//global cutscene_title title_defend_base_safe = defend_base_safe;
//global cutscene_title title_power_cut = power_cut;
//global cutscene_title title_objective_3 = objective_3;
//global cutscene_title title_shut_down_comm = shut_down_comm;
//global cutscene_title title_shut_down_comm_2 = shut_down_comm_2;
//global cutscene_title title_first_tower_down = first_tower_down;
//global cutscene_title title_both_tower_down = both_tower_down;
//global cutscene_title title_drop_shields = drop_shields;
//global cutscene_title title_shields_down = shields_down;
//global cutscene_title title_clear_base = clear_base;
//global cutscene_title title_clear_base_2 = clear_base_2;
//global cutscene_title title_get_artifact = get_artifact;
//global cutscene_title title_got_artifact = got_artifact;
//global cutscene_title title_secure = secure;
//global cutscene_title title_get_shard_1 = get_shard_1;
//global cutscene_title title_get_shard_2 = get_shard_2;
//global cutscene_title title_get_shard_3 = get_shard_3;
//global cutscene_title title_got_shard = got_shard;
//global cutscene_title title_destroy_1 = destroy_1;
//global cutscene_title title_destroy_2 = destroy_2;
//global cutscene_title title_destroy_obj_1 = destroy_obj_1;
//global cutscene_title title_destroy_obj_complete_1 = destroy_obj_complete_1;

script startup fortsw

/*	
//================================================== OBJECTS ==================================================================
//set crate names
	firefight_mode_set_crate_folder_at(cr_destroy_unsc_cover, 1); //UNSC crates and barriers around the main spawn area
	firefight_mode_set_crate_folder_at(cr_destroy_cov_cover, 	2); //cov crates all around the main area
	//firefight_mode_set_crate_folder_at(cr_destroy_shields, 	3); //barriers that prevent getting to the top of the ziggurat
	firefight_mode_set_crate_folder_at(dm_destroy_shields, 		3); //barriers that prevent getting to the very back
	firefight_mode_set_crate_folder_at(cr_power_core, 				4); //crates that blow up at the very back right
	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 	5);  //UNSC barriers in and around the front middle base
	firefight_mode_set_crate_folder_at(cr_capture, 						6); //Cov crates at the very back on the right
	firefight_mode_set_crate_folder_at(sc_destroy_unsc, 			7); //UNSC scenery in the main starting area
	firefight_mode_set_crate_folder_at(sc_defend_unsc, 				8); //UNSC scenery in the front middle area
//	firefight_mode_set_crate_folder_at(v_ff_mac_cannon, 		9); //mac cannons in the very back on the right
	firefight_mode_set_crate_folder_at(wp_power_weapons, 			10); //power weapons spawns aroung the main front area
//	firefight_mode_set_crate_folder_at(cr_base_shields, 		11); //shield walls that block in the middle back area
//	firefight_mode_set_crate_folder_at(cr_barriers, 				12); //shield walls that block the left side walkway
	firefight_mode_set_crate_folder_at(cr_powercore_extras, 	13); //powercore fluff objects surrounding it
	firefight_mode_set_crate_folder_at(cr_meadow_cov_cover, 	14); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(sc_defend_unsc_2, 			15); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(cr_forerunner_cover, 	16); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(cr_forerunner_cover_2, 17); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(dm_cave_shields, 			18); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(dm_bridge_shields, 		19); //Cov Cover and fluff in the meadow
	firefight_mode_set_crate_folder_at(cr_bridge_cov_cover, 	24); //Cov Cover and fluff on the back bridge

//set ammo crate names
	firefight_mode_set_crate_folder_at(eq_destroy_crates, 		20); //ammo crates in main spawn area
	firefight_mode_set_crate_folder_at(eq_defend_1_crates, 		21); //ammo crates in front middle area
	firefight_mode_set_crate_folder_at(eq_capture_crates, 		22); //ammo crates in the very back right
	firefight_mode_set_crate_folder_at(eq_defend_2_crates, 		23); //ammo crates in back middle area
	
//Switches
	firefight_mode_set_crate_folder_at(e2m2_objcoverswitches, 29); //Switches for E2M2
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //FORTS: Top right corner. Start for E1_M3
	
//set objective names
	firefight_mode_set_objective_name_at(destroy_obj_1, 			1); 	//e1_m3_shutdown: Covey generator
	firefight_mode_set_objective_name_at(defend_obj_1, 				2); 	//
	firefight_mode_set_objective_name_at(defend_obj_2, 				3); 	//
	firefight_mode_set_objective_name_at(capture_obj_0, 			4); 	//
	firefight_mode_set_objective_name_at(dc_switch01, 				5); 	//e1_m3_shutdown: 1st sub switch
	firefight_mode_set_objective_name_at(power_core, 					6); 	//
	firefight_mode_set_objective_name_at(destroy_obj_2, 			7); 	//
	firefight_mode_set_objective_name_at(destroy_obj_3, 			8); 	//
	firefight_mode_set_objective_name_at(capture_obj_1, 			9); 	//
	firefight_mode_set_objective_name_at(objective_switch_1, 	10);	//
	firefight_mode_set_objective_name_at(defend_obj_3, 				11);	//
	firefight_mode_set_objective_name_at(defend_obj_4, 				12);	//
	firefight_mode_set_objective_name_at(defend_obj_5, 				13);	//
	firefight_mode_set_objective_name_at(defend_obj_6, 				14);	//
	firefight_mode_set_objective_name_at(power_core_meadow, 	15);	//
	firefight_mode_set_objective_name_at(dc_object_1, 				16);	//
	firefight_mode_set_objective_name_at(dm_object_1, 				17);	//
	firefight_mode_set_objective_name_at(capture_obj_2, 			18); 	//
	firefight_mode_set_objective_name_at(objective_switch_2, 	19); 	//
	firefight_mode_set_objective_name_at(objective_switch_3, 	20); 	//
	firefight_mode_set_objective_name_at(fore_switch_0, 			21);	//
	firefight_mode_set_objective_name_at(fore_cpu_terminal, 	22);	//
	firefight_mode_set_objective_name_at(fore_cpu_terminal_2, 23);	//
	firefight_mode_set_objective_name_at(fore_cpu_terminal_3, 24); 	//
	firefight_mode_set_objective_name_at(fore_switch_1, 			25);	//
	firefight_mode_set_objective_name_at(destroy_obj_4, 			26);  //
	firefight_mode_set_objective_name_at(destroy_obj_5, 			27);  //
	firefight_mode_set_objective_name_at(destroy_obj_6, 			28);  //
	firefight_mode_set_objective_name_at(dc_switch02, 				29); 	//e1_m3_shutdown: 2nd sub switch
	firefight_mode_set_objective_name_at(dc_switch03, 				30); 	//e1_m3_shutdown: main switch
	
	
	firefight_mode_set_objective_name_at(lz_0, 50); //e1_m3_shutdown: LZ near 1st comm tower
	firefight_mode_set_objective_name_at(lz_1, 51); //e1_m3_shutdown: LZ at covey gennie
	firefight_mode_set_objective_name_at(lz_2, 52); //e1_m3_shutdown: LZ at top of center tower
	firefight_mode_set_objective_name_at(lz_3, 53); //
	firefight_mode_set_objective_name_at(lz_4, 54); //
	firefight_mode_set_objective_name_at(lz_5, 55); //
	firefight_mode_set_objective_name_at(lz_6, 56); //e1_m3_shutdown: LZ at corner, extraction for mission
	firefight_mode_set_objective_name_at(lz_7, 57); //
	firefight_mode_set_objective_name_at(lz_8, 58); //
		
//set squad group names

	firefight_mode_set_squad_at(gr_ff_guards_1, 1);	//left building
	firefight_mode_set_squad_at(gr_ff_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(gr_ff_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(gr_ff_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(gr_ff_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(gr_ff_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(gr_ff_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(gr_ff_guards_8, 8); //on the bridge
	firefight_mode_set_squad_at(gr_ff_guards_9, 13); //on the bridge
	firefight_mode_set_squad_at(gr_ff_guards_10,14); //on the bridge
	firefight_mode_set_squad_at(gr_ff_allies_1, 9); //front building
	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
	firefight_mode_set_squad_at(gr_ff_waves, 		11);
	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
	*/

//================================================== MAIN SCRIPT STARTS ==================================================================
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
	wake(objective_wait_for_trigger);
end

// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================

//script continuous terminal()
//	sleep_until (volume_test_players (terminal_volume), 1);
//	//cinematic_set_title (terminal);
//	sleep_forever();
//end
//
//script continuous f_misc_m1_start_turrets
//	sleep_until (LevelEventStatus ("start_turrets"), 1);
//	//NotifyLevel("start_turrets");
////	m1_vo_start_turrets();
//end


/*
//============================STARTING E4 M3==============================

script continuous f_start_events_e4_m3_1
	sleep_until (LevelEventStatus("start_e4_m3_defend"), 1);

	//thread (f_create_turret_0());
	object_create_anew (turret_switch_0);
	thread (f_turret_place (sq_ff_turrets.pilot_0, turret_switch_0, "a"));
	sleep (1);
	//thread (f_create_turret_1());
	object_create_anew (turret_switch_1);
	thread (f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b"));
	//start VO
	thread (m1_vo_start_defend_1());
	
	sleep (30 * 8);
//	cinematic_set_title (title_defend_obj_1);
end

script continuous f_end_events_e4_m3_1
	sleep_until (LevelEventStatus("end_e4_m3_defend"), 1);
	cinematic_set_title (title_defend_base_safe);
	m1_vo_end_defend_1();
end
*/

//============================ENDING E4 M3==============================

//script continuous f_start_events_goals_switch_start_1
//	sleep_until (LevelEventStatus("start_switch_1"), 1);
//	m2_vo_start_switch();
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
//	cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_goals_switch_1
//	sleep_until (LevelEventStatus("end_switch_1"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_power_cut);
//	//sound_impulse_start (vo_destroy_19, none, 1.0);
//	m2_vo_end_switch_1();
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	sleep (30 * 3);
//	cinematic_set_title (title_objective_3);
//end
//
//script continuous f_start_events_scurve_start_destroy_2
//	sleep_until (LevelEventStatus("start_destroy_2"), 1);
//	//m2_vo_end_destroy_2
//end
//
//script continuous f_end_events_goals_m2_destroy
//	sleep_until (LevelEventStatus("end_destroy_2"), 1);
//	m2_vo_end_destroy_2();
//end
//
//script continuous f_start_events_goals_swarm_start_m2
//	sleep_until (LevelEventStatus("start_swarm_m2"), 1);
//
//	//turn on music
//	sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sound_impulse_start (vo_swarm_1, none, 1.0);
//	m2_vo_start_swarm_1();
//
//	sleep (30 * 3);
//	cinematic_set_title (title_swarm);
//
//end
//
//script continuous f_end_events_goals_swarm_m2
//	sleep_until (LevelEventStatus("end_swarm_m2"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (good_work);
////	sound_impulse_start (vo_misc_good_work, none, 1.0);
//	m2_vo_end_swarm_1();
//end
//
//
//script continuous f_start_events_goals_switch_start_2
//	sleep_until (LevelEventStatus("start_switch_2"), 1);
//	print ("start switch 2");
//	m5_vo_start_switch();
//
//	//sleep (30 * 5);
//	sound_looping_start (music_start, NONE, 1.0);
//	cinematic_set_title (title_shut_down_comm);
//	
//end
//
//script continuous f_start_events_goals_switch_start_2a
//	sleep_until (LevelEventStatus("start_switch_2a"), 1);
//	print ("start switch 2");
//	sleep (30 * 9);
//	m5_vo_start_switch_2();
//
//	//sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	cinematic_set_title (title_shut_down_comm);
//end
//
//
//script continuous f_end_events_goals_switch_2
//	sleep_until (LevelEventStatus("end_switch_2"), 1);
//	print ("end switch 2");
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_first_tower_down);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, bishop_tower);
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, bishop_tower);
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
//	f_device_move (bishop_tower);
//	m5_vo_end_switch();
//
////	sound_impulse_start (vo_destroy_19, none, 1.0);
//	
//end
//
//script continuous f_end_events_goals_switch_2a
//	sleep_until (LevelEventStatus("end_switch_2a"), 1);
//	print ("end switch 2a");
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_both_tower_down);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, bishop_tower_2);
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, bishop_tower_2);
//	//object_destroy (bishop_tower);
//	f_device_move (bishop_tower_2);
//	m5_vo_end_switch_2();
//
//	//sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_start_events_m5_swarm_start_lz
//	sleep_until (LevelEventStatus("start_swarm_lz"), 1);
//	print ("_start swarm lz_");
//	//turn on music
//	sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sound_impulse_start (vo_swarm_1, none, 1.0);
//	sleep (30 * 3);
//	m5_vo_start_swarm_lz();
//
//	//sleep (30 * 3);
//	cinematic_set_title (title_swarm_1);
//
//end
//
//script continuous f_end_events_lz
//	sleep_until (LevelEventStatus("end_lz_1"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_lz_end);
////	sound_impulse_start (vo_destroy_19, none, 1.0);
//	m5_vo_end_lz();
//
//end



//script continuous f_start_events_goals_defend_3
//	sleep_until (LevelEventStatus("start_defend_3"), 1);
//
//		//turn on music
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//thread (f_create_turret_0());
//	object_create_anew (turret_switch_2);
//	thread (f_turret_place (sq_ff_turrets.pilot_2, turret_switch_2, "a"));
//	sleep (1);
//	//thread (f_create_turret_1());
//	object_create_anew (turret_switch_3);
//	thread (f_turret_place (sq_ff_turrets.pilot_3, turret_switch_3, "b"));
//	//start VO
//	thread (m1_vo_start_defend_1());
//	
//	sleep (30 * 8);
//	cinematic_set_title (title_defend_obj_1);
//end
//
//script continuous f_start_events_goals_defend_4
//	sleep_until (LevelEventStatus("start_defend_4"), 1);
//	print ("start defend 4");
//		//turn on music
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//thread (f_create_turret_0());
//	object_create_anew (turret_switch_0);
//	thread (f_turret_place (sq_ff_turrets.pilot_0, turret_switch_0, "a"));
//	sleep (1);
//	//thread (f_create_turret_1());
//	object_create_anew (turret_switch_1);
//	thread (f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b"));
//	//start VO
//	thread (m1_vo_start_defend_1());
//	
//	sleep (30 * 8);
//	cinematic_set_title (title_defend_obj_1);
//end
//
//script continuous f_end_events_goals_defend_3
//	sleep_until (LevelEventStatus("end_defend_3"), 1);
//	cinematic_set_title (title_defend_base_safe);
//	m1_vo_end_defend_1();
//
//	sound_looping_stop (music_start);
//end
//
//script continuous f_end_events_m5_swarm_lz
//	sleep_until (LevelEventStatus("end_m5"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_lz_clear);
//	m5_vo_end_swarm_lz();
//
//	//sound_impulse_start (vo_misc_good_work, none, 1.0);
//	//watch the pelican fly down
//	ai_place (v_ff_sq_outro_pelican);
//	f_pelican_outro();
//end
//
//script continuous f_end_events_goals_swarm_lz_2
//	sleep_until (LevelEventStatus("end_swarm_lz_2"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_lz_clear);
//	sound_impulse_start (vo_misc_good_work, none, 1.0);
//	//watch the pelican fly down
//	ai_place (sq_ff_outro_pelican_2);
//	f_pelican_outro_2();
//end
//
//script continuous f_start_events_goals_m5_atob_1
//	sleep_until (LevelEventStatus("start_atob_m5_1"), 1);
//	sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	sleep (30 * 7);
//	m5_vo_start_atob_1();
//	cinematic_set_title (title_get_to_lz);
//end
//
//
//script continuous f_start_events_goals_m5_atob_2
//	sleep_until (LevelEventStatus("start_atob_2"), 1);
//	m5_vo_start_atob_2();
//	cinematic_set_title (title_get_to_lz);
//end


// ==============================================================================================================
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

// PHANTOM 01 =================================================================================================== 
//script command_script cs_ff_phantom_01()
//	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
//	sleep (1);
////	object_cannot_die (v_ff_phantom_01, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_01.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//
//	cs_fly_by (ps_ff_phantom_01.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_ff_phantom_01.p1);
////		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_01.p2);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================
//			
//	f_unload_phantom (ai_current_squad, "dual");
//	
//			
//		//======== DROP DUDES HERE ======================
//		
//	print ("ff_phantom_01 unloaded");
//	sleep (30 * 5);
//	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_ff_phantom_01.p1);
//	cs_fly_to (ps_ff_phantom_01.p3);
////	(cs_fly_by ps_ff_phantom_01/erase 10)
//// erase squad 
//	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end

// PHANTOM 02 =================================================================================================== 
//script command_script cs_ff_phantom_02()
////	v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_02.phantom);
//	sleep (1);
////	object_cannot_die (v_ff_phantom_02, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_02.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_02.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_ff_phantom_02.p1);
////		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_02.p2);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================
//			
//	f_unload_phantom (ai_current_squad, "dual");
//	
//			
//		//======== DROP DUDES HERE ======================
//		
//	print ("ff_phantom_02 unloaded");
//	sleep (30 * 5);
//	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_ff_phantom_02.p3);
//	cs_fly_to (ps_ff_phantom_02.erase);
//// erase squad 
//	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end


// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_1()
//	cs_ignore_obstacles (false);
//	cs_enable_pathfinding_failsafe (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_fly_by (ps_ff_phantom_04.p0);
////	cs_fly_by (ps_ff_phantom_02.p3);
//	cs_fly_by (ps_ff_phantom_04.p1);
////	cs_fly_to (ps_ff_phantom_02.p4);
//	//cs_shoot (true, v_mac_cannon_1);
//	//sleep until the players are dead
//	cs_force_combat_status (3);
////	sleep_until (
////		object_get_health (player0) <= 0 and
////		object_get_health (player1) <= 0 and
////		object_get_health (player2) <= 0 and
////		object_get_health (player3) <= 0);
////	
//	sleep_until (b_game_ended == TRUE);
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_04.p1);
//	cs_fly_to (ps_ff_phantom_04.p0);
//	ai_erase (ai_current_squad);
//	
//end

// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_2()
//	cs_ignore_obstacles (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_fly_by (ps_ff_phantom_01.p0);
//	cs_fly_by (ps_ff_phantom_01.p1);
//	cs_fly_to (ps_ff_phantom_01.p4);
//	//cs_shoot (true, v_mac_cannon_1);
//		//sleep until the players are dead
//	cs_force_combat_status (3);
////	sleep_until (
////		object_get_health (player0) <= 0 and
////		object_get_health (player1) <= 0 and
////		object_get_health (player2) <= 0 and
////		object_get_health (player3) <= 0);
//	sleep_until (b_game_ended == TRUE);	
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_01.p5);
//	cs_fly_to (ps_ff_phantom_01.erase);
//	ai_erase (ai_current_squad);
//	
//end

// ==============================================================================================================
// ====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================
//script static void f_small_drop_pod_0
//	print ("drop pod 0");
//	object_create (small_pod_0);
//	thread(small_pod_0->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p0, .85, DEFUALT ));
//end
//
//script static void f_small_drop_pod_1
//	print ("drop pod 0");
//	object_create (small_pod_1);
//	thread(small_pod_1->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p1, .85, DEFUALT ));
//end

// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================
//script command_script cs_ff_pelican_marines
//	cs_ignore_obstacles (TRUE);
//	ai_cannot_die (ai_current_squad, TRUE);
//	sleep (1);
//	object_create_anew (pelican_ammo);
//  sleep (1);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point(sq_ff_pelican.pilot), "pelican_lc", pelican_ammo);
//	sleep (1);
//	//cs_fly_to (ps_ff_pelican.p0);
//	//cs_fly_to (ps_ff_pelican.p1);
//	//cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	//sleep (30 * 5);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
////	cs_fly_to (ps_ff_pelican.p3);
//	ai_vehicle_exit (ai_current_squad);
//	cs_pause(5);
////	ai_set_objective (ai_ff_sq_marines, obj_survival);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_ff_pelican.pilot), "pelican_lc");
////	sleep (30 * 5);
//	cs_pause(5);
//	//cs_fly_to (ps_ff_pelican.p3);
//	//cs_fly_to (ps_ff_pelican.p4);
////	sleep (30 * 20);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to (ps_ff_pelican.p0);
//	//cs_fly_to (ps_ff_pelican_outro.p2);
//	ai_erase (ai_current_squad);
//end
//
//// ==OUTRO PELICAN 1
//script command_script cs_outro_pelican
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican_outro.p0);
//	cs_fly_to (ps_ff_pelican_outro.p1);
//	cs_fly_to (ps_ff_pelican_outro.p2);
//end
//
//script static void f_pelican_outro
//	//start the pelican mini-vignette
//	print ("pelican outro");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro.p1, 60);
//	sleep (30 * 4);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro.p2, 60);
//	sleep (30 * 5);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end
//
//// ==OUTRO PELICAN 2
//
//script command_script cs_outro_pelican_2
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican_outro_2.p0);
//	cs_fly_to (ps_ff_pelican_outro_2.p1);
////	cs_fly_to (ps_ff_pelican_outro_2.p2);
//end

//script static void f_pelican_outro_2
//	//start the pelican mini-vignette
//	print ("pelican outro_2");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro_2.p2, 60);
//	sleep (30 * 12);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end

// ==============================================================================================================
// ====== OTHER SCRIPTS ===============================================================================
// ==============================================================================================================
//script static void f_failsafe (trigger_volume tv)
//	sleep_until (volume_test_players (tv));
//	print ("failsafe enabled--- killing a to b thread");
//	sleep_forever (objective_atob);
//	f_unblip_object_cui (flag_0);
//	b_goal_ended = true;
//	wake (objective_atob);
//end

//script static void f_hunter_drop
//	//start the pelican mini-vignette
//	print ("hunter drop");
//	cinematic_show_letterbox (true);
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro.p2, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro.p2, 60);
//	sleep (30 * 6);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	cinematic_show_letterbox (false);
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end

//script static void pelican_intro
//	fade_out (0, 0, 0, 1);
//	sleep (30);
//	object_create (test);
//	object_move_by_offset (test, 1, 0, 0, 500);
//	teleport_players_into_vehicle (test);
//	unit_open (test);
//	fade_in (0, 0, 0, 3);
//	player_effect_set_max_rotation (5, 5, 5);
//	player_effect_set_max_rumble(5, .5);
//	player_effect_start (5, 3);
//	object_move_by_offset (test, 5, 0, 0, -500);
//	fade_out (255, 255, 255, 1);
//	player_effect_stop (1);
//	sleep (30 * 1);
//	object_destroy (test);
//	object_teleport_to_object (player0, spartan_respawn_0);
//	fade_in (255, 255, 255, 90);
//
//end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================

//script continuous f_event_blow_up_shields
//	sleep_until (LevelEventStatus("blow_shields"), 1);
//	print ("_blow shields_");
//	thread(start_camera_shake_loop ("heavy", "short"));
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_2);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_6);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_7);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_8);
//	object_destroy_folder (dm_destroy_shields);
//	//cinematic_set_title (title_destroy_obj_2);
//	sleep (30 * 5);
//	stop_camera_shake_loop();
//end
//
//script continuous f_misc_events_m2_weapon_drop_1
//	sleep_until (LevelEventStatus("m2_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
////	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_02, sc_resupply_02);
//end
//
//script continuous f_misc_events_m2_weapon_drop_2
//	sleep_until (LevelEventStatus("m2_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
////	m2_vo_weapon_drop_2();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
////	f_resupply_pod (dm_resupply_01, sc_resupply_01);
//end
//
//script continuous f_misc_events_m2_weapon_drop_3
//	sleep_until (LevelEventStatus("m2_weapon_drop_3"), 1);
////	m2_vo_weapon_drop_1();
////	f_resupply_pod (dm_resupply_03, sc_resupply_03);
//end
//
//script continuous f_misc_events_m5_weapon_drop_1
//	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
////	m5_vo_weapon_drop_1();
////	f_resupply_pod (dm_target_01, sc_target_01);
//end
//
//script continuous f_misc_events_m5_weapon_drop_2
//	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
////	m2_vo_weapon_drop_1();
//	//f_resupply_pod (dm_target_02, sc_target_02);
//end
//
//script continuous f_end_events_goals_capture_artifact
//	sleep_until (LevelEventStatus("capture_artifact"), 1);
////	cinematic_set_title (title_capture_3);
//end
//
//script continuous f_change_spawn_points
//	sleep_until (LevelEventStatus("spawn_point_91"), 1);
//	print (":::changing spawn point to folder 91:::");
//	object_create_folder_anew(firefight_mode_get_crate_folder_at(91));
//	object_destroy_folder(firefight_mode_get_crate_folder_at(firefight_mode_get_start_location_folder(firefight_mode_goal_get() )));
//end
//
//script continuous f_more_enemies_1
//	sleep_until (LevelEventStatus("more_enemies"), 1);
//	print ("more enemies event");
//	cinematic_set_title (title_more_enemies);
////	m1_vo_more_enemies_1();
//end
//
//script continuous f_incoming_elites
//	sleep_until (LevelEventStatus("incoming_elites"), 1);
//	print ("incoming elites event");
////	m5_vo_elites_incoming();
//end
//
//script continuous f_invading_hunters
//	sleep_until (LevelEventStatus("invading_hunters"), 1);
//	print ("invading hunters event");
//	cinematic_set_title (invading);
////	m1_vo_invading_1();
//	sound_looping_start (fx_misc_warning, NONE, 1.0);
//	sleep (30 * 10);
//	sound_looping_stop (fx_misc_warning);
//end
//
//script continuous f_invading_zealots
//	sleep_until (LevelEventStatus("invading_zealots"), 1);
//	print ("invading zealots event");
//	cinematic_set_title (invading);
////	m1_vo_invading_2();
//	sound_looping_start (fx_misc_warning, NONE, 1.0);
//	sleep (30 * 10);
//	sound_looping_stop (fx_misc_warning);
//end



