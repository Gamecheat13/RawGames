// =============================================================================================================================
//============================================ BREACH FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//Scenario scripts should only be used for setting up the scenario for ALL missions on the map, not for individual mission scripts



script startup breach

	print( "Breach_startup" );
	
	// setup defaults
	f_spops_mission_startup_defaults();
	
	// track mission flow
	f_spops_mission_flow();
	
end

//
//	ai_allegiance (human, player);
//	ai_allegiance (player, human);
//	ai_lod_full_detail_actors (20);
//
//	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
//	wake (start_waves);
//end
//
//script dormant start_waves
//	wake (firefight_lost_game);
//	wake (firefight_won_game);
//	firefight_player_goals();
//	print ("goals ended");
//	print ("game won");
//	//mp_round_end();
//	b_game_won = true;
//
//end
//
//script static void setup_destroy
//	//set any variables and start the main objective script from the global firefight script
//
//	wake (objective_destroy);
//
//end
//
//
//script static void setup_defend
//	//set any variables and start the main objective script from the global firefight script
//	wake (objective_defend);
//
//end
//
//script static void setup_swarm
//	//set any variables and start the main objective script from the global firefight script
//	wake (objective_swarm);
//
//end
//
//script static void setup_capture
//	//set any variables and start the main objective script from the global firefight script
//	wake (objective_capture);
//end
//
//script static void setup_take
//	//set any variables and start the main objective script from the global firefight script
//	wake (objective_take);
//end
//
//script static void setup_atob
//	wake (objective_atob);
//end
//
//script static void setup_boss
//	wake (objective_kill_boss);
//end
//
//script static void setup_wait_for_trigger
//	wake (objective_wait_for_trigger);
//end

// ====== EXAMPLE SCRIPTS ===============================================================================
//script continuous terminal()
//	sleep_until (volume_test_players (terminal_volume), 1);
//	cinematic_set_title (terminal);
//	sleep_forever();
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
//	//turn on music
//	sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	sound_impulse_start (vo_swarm_1, none, 1.0);
//	sleep (30 * 3);
//	cinematic_set_title (title_swarm_1);
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
//	object_destroy_folder (dm_destroy_shields);
//	cinematic_set_title (title_destroy_obj_2);
//	sleep_s (3);
//	stop_camera_shake_loop();
//end
//
//script continuous f_misc_crash_pelican
//	sleep_until (LevelEventStatus("crash_pelican"), 1);
//	print("crashing the pelican now...........CRASH");
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

// ==============================================================================================================
// ====== END MISSION SCRIPTS ===============================================================================
// ==============================================================================================================
//script continuous f_end_game_total  //ends the whole level
//	sleep_until (LevelEventStatus("end_level_total"), 1);
//	print ("Ending the level now.........................................");
//	sound_looping_stop (music_start);
//	cinematic_set_title (title_destroy_obj_complete_1);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//	b_game_ended == TRUE;
//	print ("goals ended");
//	mp_round_end();
//end
//
//script continuous f_defend_fail_breach	sleep_until (LevelEventStatus("check_defend_objects"), 1);
//		sleep_until  ((object_get_health(obj_defend_1) + object_get_health(obj_defend_2) <= 0));
//		print ("both generators destroyed___________________________________");
//		f_unblip_object (obj_defend_1);
//		f_unblip_object (obj_defend_2);
//		b_game_ended == TRUE;
//end

// ==============================================================================================================
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

// PHANTOM 01 =================================================================================================== 
//script command_script cs_ff_phantom_01()
//	sleep (1);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_01.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_to (ps_ff_phantom_01.p2);
//	sleep (30 * 1);
//		//======== DROP DUDES HERE ======================
//	f_unload_phantom (v_ff_phantom_01, "dual");
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_01 unloaded");
//	sleep (30 * 5);
//	cs_fly_to (ps_ff_phantom_01.p3);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM 02 =================================================================================================== 
//script command_script cs_ff_phantom_02()
//	v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_02.phantom);
//	sleep (1);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_02.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_02.p0);
//	cs_fly_by (ps_ff_phantom_02.p1);
//	cs_fly_by (ps_ff_phantom_02.p2);
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================	
//	f_unload_phantom (v_ff_phantom_02, "dual");
//		
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_02 unloaded");
//	sleep (30 * 5);
//	cs_fly_to (ps_ff_phantom_02.p3);
//	cs_fly_to (ps_ff_phantom_02.erase);
//	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end
//
//script command_script cs_ff_phantom_03()
//	v_ff_phantom_03 = ai_vehicle_get_from_starting_location (sq_ff_phantom_03.phantom);
//	sleep (1);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_03.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_03.p0);
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_fly_by (ps_ff_phantom_03.p2);
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================		
//	f_unload_phantom (v_ff_phantom_03, "dual");
//			
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_03 unloaded");
//	sleep (30 * 5);
//	cs_fly_to (ps_ff_phantom_03.p3);
//	cs_fly_to (ps_ff_phantom_03.erase);
//	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end
//
//script command_script cs_ff_phantom_04()
//	v_ff_phantom_04 = ai_vehicle_get_from_starting_location (sq_ff_phantom_04.phantom);
//	sleep (1);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_04.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_04.p0);
//	cs_fly_by (ps_ff_phantom_04.p1);
//	cs_fly_by (ps_ff_phantom_04.p2);
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================
//	f_unload_phantom (v_ff_phantom_04, "dual");
//			
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_04 unloaded");
//	sleep (30 * 5);
//	cs_fly_to (ps_ff_phantom_04.p3);
//	cs_fly_to (ps_ff_phantom_04.erase);
//	sleep (30 * 5);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_1()
//	cs_ignore_obstacles (false);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_fly_by (ps_ff_phantom_03.p0);
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_force_combat_status (3);
//	sleep_until (b_game_ended == TRUE);
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_fly_to (ps_ff_phantom_03.p0);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_ff_phantom_attack_2()
//	cs_ignore_obstacles (TRUE);
//	cs_fly_by (ps_ff_phantom_04.p0);
//	cs_fly_by (ps_ff_phantom_04.p1);
//	cs_fly_to (ps_ff_phantom_04.p2);
//	cs_force_combat_status (3);
//	sleep_until (b_game_ended == TRUE);	
//	cs_fly_by (ps_ff_phantom_04.p3);
//	cs_fly_to (ps_ff_phantom_04.erase);
//	ai_erase (ai_current_squad);
//end
//
//// ==============================================================================================================
//// ====== PELICAN COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================
//script command_script cs_ff_pelican_marines
//	cs_ignore_obstacles (TRUE);
//	ai_cannot_die (ai_current_squad, TRUE);
//	sleep (1);
//  sleep (1);
//	sleep (1);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	ai_vehicle_exit (ai_ff_sq_marines);
//	cs_pause(5);
//	ai_set_objective (ai_ff_sq_marines, obj_marines_follow);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_ff_pelican.pilot), "pelican_lc");
//	cs_pause(5);
//	cs_fly_to (ps_ff_pelican.p3);
//	cs_fly_to (ps_ff_pelican.p4);
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
//end
//
//script command_script cs_pelican_crash
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_pelican_crash.p0);
//	cs_fly_to (ps_pelican_crash.p1);
//	cinematic_set_title (title_pelican_crash);
//	cs_fly_to (ps_pelican_crash.p2);
//	cs_fly_to (ps_pelican_crash.p3);
//	cs_fly_to (ps_pelican_crash.p4);
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
// ====== TEST ===============================================================================
// ==============================================================================================================
//script static void intro
//	fade_out (0, 0, 0, 1);
//	sleep (30);
//	object_create (test);
//	object_move_by_offset (test, 1, 0, 0, 30);
//	teleport_players_into_vehicle (test);
//	unit_open (test);
//	fade_in (0, 0, 0, 3);
//	player_effect_set_max_rotation (5, 5, 5);
//	player_effect_set_max_rumble(5, .5);
//	player_effect_start (5, 3);
//	object_move_by_offset (test, 5, 0, 0, -29);
//	fade_out (255, 255, 255, 1);
//	player_effect_stop (1);
//	sleep (30 * 1);
//	object_teleport_to_object (player0, lz_0);
//	sleep (1);
//	object_destroy (test);
//	fade_in (255, 255, 255, 90);
//end
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
//end
//
//script continuous f_start_events_waves_weapon_drop_d_1
//	sleep_until (LevelEventStatus("weapon_drop_d_1"), 1);
//	cinematic_set_title (weapon_drop);
//	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
//	thread (f_resupply_pod (dm_resupply_04, sc_resupply_04));
//end
//
//script continuous f_start_events_waves_weapon_drop_d_2
//	sleep_until (LevelEventStatus("weapon_drop_d_2"), 1);
//	cinematic_set_title (weapon_drop);
//	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
//	thread (f_resupply_pod (dm_resupply_05, sc_resupply_05));
//end
//
//script continuous f_get_to_location
//	sleep_until (LevelEventStatus("get_to_location_1"), 1);
//	sound_impulse_start ("sound\dialog\firefight\m17\vo_firefight_m17_28.sound", none, 1.0);
//end
//
//script continuous f_kill_marines
//	sleep_until (LevelEventStatus("kill_the_marines"), 1);
//	sleep (30 * 4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_1);
//	sleep (30 * .3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_2);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_3);
//	sleep (30 * .4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_6);
//	sleep (30 * .2);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cr_e_prop_tank_7);
//end
//
//script continuous f_unblip_gennies
//	sleep_until (LevelEventStatus("unblip_gennies"), 1);
//	f_unblip_object (obj_defend_1);
//	f_unblip_object (obj_defend_2);
//end
//
//script continuous f_blip_lz_1
//	sleep_until (LevelEventStatus("blip_lz"), 1);
//	f_blip_object (lz_5, "LZ");
//end
//
//script continuous f_unblip_lz_1
//	sleep_until (LevelEventStatus("unblip_lz"), 1);
//	f_unblip_object (lz_5);
//end
//
//script continuous f_escape_pelican_outro
//	sleep_until (LevelEventStatus("escape_pelican_outro"), 1);
//	ai_place (v_ff_sq_outro_pelican);
//	cs_run_command_script (sq_ff_outro_pelican.pilot, cs_escape_outro_pelican);
//end
//
//script command_script cs_escape_outro_pelican
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to (ps_ff_pelican.p2);
//end




// Breach FX

// Digger Firing Sequence
script static void fx_digger_fire()
	print ("Breach - Digger Firing");
	effect_new( levels\dlc\ff155_breach\fx\energy\bre_digger_chargeup.effect, fx_dig_charge_center );
	sleep(95);
	effect_new( levels\dlc\ff155_breach\fx\beams\bre_digger_laser.effect, fx_dig_charge_center );
	effect_new( levels\dlc\ff155_breach\fx\beams\bre_digger_laser_impact.effect, fx_dig_laser_impact );
end
