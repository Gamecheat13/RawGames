// =============================================================================================================================
//========ISLAND FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//===============LEVEL SCRIPT ==================================================================
// =============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_end = lz_end;
//global cutscene_title title_pelican_crash = pelican_crash;
//global cutscene_title title_aa_guns_disabled = aa_guns_disabled;
//global cutscene_title title_disable_aa_1 = disable_aa_guns;
//global cutscene_title title_use_vehicles = use_vehicles;
//global ai ai_ff_allies_1 = gr_ff_allies_1;
//global ai ai_ff_allies_2 = gr_ff_allies_2;

script startup island

//commenting out the drop pod intro because it is causing out of sync errors
//	thread(f_start_player_intro());

// =============================================================================================================================
//===========GLOBALS ==================================================================
// =============================================================================================================================

// ================================================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_1;

	
//======== OBJECTS ==================================================================
//set crate names
//	firefight_mode_set_crate_folder_at(cr_destroy_unsc_cover, 1); //UNSC crates and barriers around the dias
//	firefight_mode_set_crate_folder_at(cr_destroy_cov_cover, 2); //cov crates all around the main area
//	firefight_mode_set_crate_folder_at(dm_destroy_shields, 3); //barriers that prevent getting behind the dias and to the large back middle area
//	firefight_mode_set_crate_folder_at(cr_power_core, 4); //crates that blow up behind the dias
//	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 5);  //UNSC barriers 
//	firefight_mode_set_crate_folder_at(cr_capture, 6); //Cov crates 
//	firefight_mode_set_crate_folder_at(sc_destroy_unsc, 7); //UNSC scenery 
//	firefight_mode_set_crate_folder_at(sc_defend_unsc, 8); //UNSC scenery 
////	firefight_mode_set_crate_folder_at(v_ff_mac_cannon, 9); //mac cannons in the middle (thinking about deleting these)
//	firefight_mode_set_crate_folder_at(wp_power_weapons, 10); //power weapons spawns in the main area
//	firefight_mode_set_crate_folder_at(cr_base_shields, 11); //shield walls that currently cover a hole in the floor
//	firefight_mode_set_crate_folder_at(cr_barriers, 12); // nothing at the moment
//	firefight_mode_set_crate_folder_at(cr_destroy_shields, 13); //barrier that prevent players from falling off the end of the large tunnel
//	firefight_mode_set_crate_folder_at(v_ff_unsc, 14); //unsc vehicles
//	firefight_mode_set_crate_folder_at(cr_unsc_lz_3, 15); //unsc crates at LZ 3
	
//set ammo crate names
//	firefight_mode_set_crate_folder_at(eq_destroy_crates, 20); //ammo crates in main area
//	firefight_mode_set_crate_folder_at(eq_defend_1_crates, 21); //ammo crates in front right area
//	firefight_mode_set_crate_folder_at(eq_capture_crates, 22); //ammo crates in front left
//	firefight_mode_set_crate_folder_at(eq_defend_2_crates, 23); //ammo crates behind the dias
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns behind the dias
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns by the large tunnel
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the front left
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the back left
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns by the back right
	
//set objective names
//	firefight_mode_set_objective_name_at(destroy_obj_1, 1); //objective behind the dias
//	firefight_mode_set_objective_name_at(defend_obj_1, 2); //objective in the tunnel
//	firefight_mode_set_objective_name_at(defend_obj_2, 3); //objective in the tunnel
//	firefight_mode_set_objective_name_at(capture_obj_0, 4); //objective in the tunnel
////	firefight_mode_set_objective_name_at(v_mac_cannon_1, 5); //on the walkway
//	firefight_mode_set_objective_name_at(power_core, 6); //on the dias
//	firefight_mode_set_objective_name_at(destroy_obj_2, 7);  //on the dias
//	firefight_mode_set_objective_name_at(destroy_obj_3, 8);  //in the tunnel
//	firefight_mode_set_objective_name_at(capture_obj_1, 9); //objective on the dias
//	firefight_mode_set_objective_name_at(objective_switch_1, 10); //touchscreen switch on the walkway
//	firefight_mode_set_objective_name_at(defend_obj_3, 11); //objective in the back, behind the dias
//	firefight_mode_set_objective_name_at(defend_obj_4, 12); //objective in the back, behind the dias
//	firefight_mode_set_objective_name_at(objective_switch_2, 19); //in the leftside room
	
	firefight_mode_set_objective_name_at(lz_0, 50); //objective behind the dias
	firefight_mode_set_objective_name_at(lz_1, 51); //objective by the large tunnel
	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the front left
	firefight_mode_set_objective_name_at(lz_3, 53); //objective in the back left
	firefight_mode_set_objective_name_at(lz_4, 54); //objective in the back right
	
	firefight_mode_set_objective_name_at(capture_obj_2, 18); //objective on the walkway
	
//	firefight_mode_set_objective_name_at(ai_get_object(squads_18.test), 20);

//set squad group names

	firefight_mode_set_squad_at(gr_ff_guards_1, 1);	//behind the dias
	firefight_mode_set_squad_at(gr_ff_guards_2, 2);	//the dias
	firefight_mode_set_squad_at(gr_ff_guards_3, 3);	//the tunnel
	firefight_mode_set_squad_at(gr_ff_guards_4, 4); //right side
	firefight_mode_set_squad_at(gr_ff_guards_5, 5); //left middle
	firefight_mode_set_squad_at(gr_ff_guards_6, 6); //middle
	firefight_mode_set_squad_at(gr_ff_guards_7, 7);	//the dias
	firefight_mode_set_squad_at(gr_ff_guards_8, 8);	//the tunnel
	firefight_mode_set_squad_at(gr_ff_guards_9, 9); //right side
	firefight_mode_set_squad_at(gr_ff_guards_10, 10); //left middle
	firefight_mode_set_squad_at(gr_ff_guards_11, 11); //middle
	
	firefight_mode_set_squad_at(gr_ff_waves, 12);
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 50); //phantoms -- doesn't seem to work
	firefight_mode_set_squad_at(gr_ff_allies_1, 21); //tunnel
	firefight_mode_set_squad_at(gr_ff_allies_2, 22); //behind the dias
	firefight_mode_set_squad_at(gr_ff_wraith, 15); //behind the dias
	firefight_mode_set_squad_at(gr_ff_boss, 20); //the boss

// ================================================== TITLES ==================================================================
	
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	
//	title_switch_obj_1 = switch_obj_1;

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
	wake (objective_wait_for_trigger);
end

// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================
//
//script continuous terminal()
//	sleep_until (volume_test_players (terminal_volume), 1);
//	cinematic_set_title (terminal);
//	sleep_forever();
//
//end
//
//script continuous f_start_events_goals_switch_start_1
//	sleep_until (LevelEventStatus("start_switch_1"), 1);
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
//	cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_goals_switch_1
//	sleep_until (LevelEventStatus("end_switch_1"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_destroy_obj_complete_1);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_start_events_goals_swarm_start_lz
//	sleep_until (LevelEventStatus("start_swarm_lz"), 1);
//	//NotifyLevel ("crash_pelican");
//	//turn on music
//	cinematic_set_title (title_swarm_1);
//	sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	sound_impulse_start (vo_swarm_1, none, 1.0);
////	sleep (30 * 3);
//	
//
//end
//
//script continuous f_end_events_lz
//	sleep_until (LevelEventStatus("end_lz_1"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_lz_end);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_misc_event_blow_up_shields
//	sleep_until (LevelEventStatus("blow_shields"), 1);
//	thread(start_camera_shake_loop ("heavy", "low"));
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_2);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_6);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_7);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_8);
//	object_destroy_folder (dm_destroy_shields);
//	cinematic_set_title (title_destroy_obj_2);
//end
//
//script continuous f_misc_crash_pelican
//	sleep_until (LevelEventStatus("crash_pelican"), 1);
//	print ("crash_pelican");
//	ai_place (sq_ff_pelican);
//	cs_run_command_script (sq_ff_pelican.pilot, cs_pelican_crash);
//end
//
//script continuous f_misc_aa_turrets
//	sleep_until (LevelEventStatus("aa_turrets"), 1);
//	print ("AA started");
//	ai_place (sq_aa_turrets);
//	camera_test();
//	sleep (30);
//	sleep_until (LevelEventStatus("end_aa_1"), 1);
//	print ("TURRETS SHUT DOWN");
//	//cinematic_set_title (title_aa_guns_disabled);
//	ai_braindead (sq_aa_turrets, true);
//end
//
//script continuous f_start_events_goals_aa_1
//	sleep_until (LevelEventStatus("start_aa_1"), 1);
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
//	cinematic_set_title (title_disable_aa_1);
//end
//
//script continuous f_end_events_goals_aa_1
//	sleep_until (LevelEventStatus("end_aa_1"), 1);
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_aa_guns_disabled);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_misc_events_use_vehicles
//	sleep_until (LevelEventStatus("use_vehicles"), 1);
//	print ("use vehicles now running");
//	cinematic_set_title (title_use_vehicles);
//end
//script continuous f_start_events_goals_defend_2
//	sleep_until (LevelEventStatus("start_defend_2"), 1);
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
//	sleep (30 * 8);
//	cinematic_set_title (title_defend_obj_1);
//end

// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
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
//	f_unload_phantom (v_ff_phantom_01, "dual");
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
////	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM 02 =================================================================================================== 
//script command_script cs_ff_phantom_02()
//	v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_02.phantom);
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
//	f_unload_phantom (v_ff_phantom_02, "dual");
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
//
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_1()
//	cs_ignore_obstacles (false);
//	cs_enable_pathfinding_failsafe (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_fly_by (ps_ff_phantom_03.p0);
////	cs_fly_by (ps_ff_phantom_02.p3);
//	cs_fly_by (ps_ff_phantom_03.p1);
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
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_fly_to (ps_ff_phantom_03.p0);
//	ai_erase (ai_current_squad);
//	
//end
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_2()
//	cs_ignore_obstacles (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_fly_by (ps_ff_phantom_04.p0);
//	cs_fly_by (ps_ff_phantom_04.p1);
//	cs_fly_to (ps_ff_phantom_04.p2);
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
//	cs_fly_by (ps_ff_phantom_04.p3);
//	cs_fly_to (ps_ff_phantom_04.erase);
//	ai_erase (ai_current_squad);
//	
//end


// ==============================================================================================================
//====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//script command_script cs_ff_pelican_marines
//	cs_ignore_obstacles (TRUE);
//	ai_cannot_die (ai_current_squad, TRUE);
//	sleep (1);
//	object_create_anew (pelican_ammo);
//  sleep (1);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point(sq_ff_pelican.pilot), "pelican_lc", pelican_ammo);
//	sleep (1);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	//sleep (30 * 5);
//	ai_vehicle_exit (ai_ff_sq_marines);
//	cs_pause(5);
//	ai_set_objective (ai_ff_sq_marines, obj_marines_follow);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_ff_pelican.pilot), "pelican_lc");
////	sleep (30 * 5);
//	cs_pause(5);
//	cs_fly_to (ps_ff_pelican.p3);
//	cs_fly_to (ps_ff_pelican.p4);
////	sleep (30 * 20);
//	ai_erase (ai_current_squad);
//end
//
//script static void f_pelican_outro
//	//start the pelican mini-vignette
//	print ("pelican outro");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican.p1, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican.p1, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican.p1, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican.p1, 60);
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
//
//script command_script cs_outro_pelican
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to (ps_ff_pelican.p2);
//
//end
//
//script command_script cs_pelican_crash
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_pelican_crash.p0);
//	cs_fly_to (ps_pelican_crash.p1);
//	cinematic_set_title (title_pelican_crash);
//	cs_fly_to (ps_pelican_crash.p2);
//	//cs_fly_to (ps_ff_pelican.p3);
//	effect_new_at_point_set_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_pelican_crash, 2);
//	thread(start_camera_shake_loop ("heavy", "low"));
//	sleep_s (1);
//	stop_camera_shake_loop();
//	print ("pelican destroyed");
//	ai_erase (ai_current_squad);
//end
//
//script command_script cs_turret_1()
//	repeat
//		cs_shoot_point (TRUE, ps_ff_phantom_02.p0);
//		sleep (random_range (15, 90));
//		cs_shoot_point (TRUE, ps_ff_phantom_02.p1);
//		sleep (random_range (15, 90));	
//		cs_shoot_point (TRUE, ps_ff_phantom_02.p2);
//		sleep (random_range (15, 90));
//	until (b_game_ended == TRUE, 1);
//end

// ==============================================================================================================
//====== TEST ===============================================================================
// ==============================================================================================================

//script static void f_ordnance_call_in_box
//	print ("::: ordnance call in box starting :::");
//	object_create (dc_ordnance_switch);
//	repeat
//		print ("ordnance call in box ready");
//		f_blip_object_cui (dc_ordnance_switch, "navpoint_ally");
//		sleep_until (device_get_position(dc_ordnance_switch) > 0, 1);
//		f_unblip_object_cui (dc_ordnance_switch);
//		device_set_power (dc_ordnance_switch, 0);
//		cinematic_set_title (weapon_drop);
//		sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
//		thread (f_resupply_pod (dm_resupply_01, sc_resupply_01));
//		sleep_s (30);
//		device_set_position_immediate (dc_ordnance_switch, 0);
//		device_set_power (dc_ordnance_switch, 1);
//	until (b_game_ended == true, 1);
//end
//
//script static void f_start_player_intro
//	firefight_mode_set_player_spawn_suppressed(true);
//	intro();
//	//firefight_mode_set_player_spawn_suppressed(false);
//	//sleep_until (goal_finished == true);
//end
//
//script static void intro
////	sleep (30 * 3);	
////	fade_out (0, 0, 0, 1);
////	print ("fade out");
////	sleep (30 * 3);
////	thread (start_camera_shake_loop (heavy, long));
////	//sleep (30);
////	object_create (test);
////	//object_move_by_offset (test, 1, 0, 0, 30);
////	//teleport_players_into_vehicle (test);
////	//unit_open (test);
////	fade_in (0, 0, 0, 90);
////	print ("fade in");
//
//	camera_set (cam_0, 2);
//	
//	object_create (intro_test);
//	object_create (clouds);
//	unit_open (intro_test);
//	print ("moving object test");
////	thread (object_move_by_offset (intro_test, 60, 0, 0, 10));
//	
//	
//
//	
//	print ("starting camera control test");
//	camera_control (true);
//	repeat
//		camera_set (cam_0, 2);
//		print ("camera0");
//		sleep (2);
//		
//		camera_set (cam_1, 2);
//		print ("camera1");
//		sleep (2);
//		
//		camera_set (cam_2, 2);
//		print ("camera2");
//		sleep (2);
//		
//		camera_set (cam_3, 2);
//		print ("camera3");
//		sleep (2);
//		//sleep (240);
//	until (goal_finished == true, 1, 300);
//	
////
//////	player_effect_set_max_rotation (5, 5, 5);
//////	player_effect_set_max_rumble(5, .5);
//////	player_effect_start (5, 3);
////	print ("start effects");
////	//object_move_by_offset (test, 5, 0, 0, -29);
//
//	fade_out (255, 255, 255, 1);
//	print ("fadeing out");
//
//
//	object_destroy (intro_test);
//	object_destroy (clouds);
//	camera_control (false);
////	player_effect_stop (1);
////	print ("stop effects");
////	sleep (30 * 10);
////	print ("sleeping....");
////	//object_teleport_to_object (player0, lz_0);
////	sleep_until (object_get_health(player0) > 0);
//
//	sleep (15);
//
//	firefight_mode_set_player_spawn_suppressed(false);
//	print (":::spawning player...");
//
//	fade_in (255, 255, 255, 90);
//	print ("fading in");
//end
//
//
//
//script static void camera_test
//	print ("............camera test started............");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	camera_control (true);
//	camera_set (cam_0, 1);
//	print ("camera0");
//	sleep (1);
//	camera_set (cam_1, 180);
//	print ("camera1");
//	sleep (240);
//	object_can_take_damage (players());
//	camera_control (false);
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//
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
