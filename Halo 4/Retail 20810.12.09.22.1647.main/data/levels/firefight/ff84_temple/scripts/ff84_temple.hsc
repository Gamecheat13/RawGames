//=============================================================================================================================
//============================================ TEMPLE FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_go_to = lz_go_to;
//global cutscene_title title_objective_3 = objective_3;
//global cutscene_title title_destroy_1 = destroy_1;
//global cutscene_title title_destroy_2 = destroy_2;
//global cutscene_title title_destroy_obj_1 = destroy_obj_1;
//global cutscene_title title_destroy_obj_2 = destroy_obj_2;
//global cutscene_title title_destroy_obj_complete_1 = destroy_obj_complete_1;
//global cutscene_title title_lz_end = lz_end;
//global v_ff_phantom_02 = ff_phantom_02;

script startup temple
/*
//================================================== OBJECTS ==================================================================
//set crate names
	firefight_mode_set_crate_folder_at(cr_destroy_unsc_cover, 				1); //UNSC crates and barriers around the dias
	firefight_mode_set_crate_folder_at(cr_destroy_cov_cover, 					2); //cov crates all around the main area
	firefight_mode_set_crate_folder_at(dm_destroy_shields, 						3); //barriers that prevent getting behind the dias and to the large back middle area
	firefight_mode_set_crate_folder_at(cr_power_core, 								4); //crates that blow up behind the dias
	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 					5);  //UNSC barriers 
	firefight_mode_set_crate_folder_at(cr_capture, 										6); //Cov crates 
	firefight_mode_set_crate_folder_at(sc_destroy_unsc, 							7); //UNSC scenery 
	firefight_mode_set_crate_folder_at(sc_defend_unsc, 								8); //UNSC scenery 
	firefight_mode_set_crate_folder_at(wp_e5_m1_weapons, 							10); // Temple: turret for defend
	firefight_mode_set_crate_folder_at(eq_e5_m1_ammo_box, 						11); // Temple: ammo box for e5_m1
	firefight_mode_set_crate_folder_at(cr_barriers, 									12); // nothing at the moment
	firefight_mode_set_crate_folder_at(cr_destroy_shields, 						13); //barrier that prevent players from falling off the end of the large tunnel
	firefight_mode_set_crate_folder_at(cr_e2_m5_temple_take_props, 		14); // Temple: props for e2_m5_temple_escape
	firefight_mode_set_crate_folder_at(cr_e1_m2_escape_temple_props,	15); // Temple: props for the w1m2 escape the temple
	firefight_mode_set_crate_folder_at(cr_e5_m1_defend_props,					16); // Temple: props for the e5m1 defend
	firefight_mode_set_crate_folder_at(es_e1_m2_escape,								17); // Temple: star map effects
//	firefight_mode_set_crate_folder_at(dm_e1_m2_escape,								18); // Temple: star map in the back
	
	
//set ammo crate names
	firefight_mode_set_crate_folder_at(eq_destroy_crates, 	20); //ammo crates in main area
	firefight_mode_set_crate_folder_at(eq_defend_1_crates, 	21); //ammo crates in front right area
	firefight_mode_set_crate_folder_at(eq_capture_crates, 	22); //ammo crates in front left
	firefight_mode_set_crate_folder_at(eq_defend_2_crates, 	23); //ammo crates behind the dias
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 	90); //spawns behind the dias
	firefight_mode_set_crate_folder_at(spawn_points_1, 	91); //spawns by the large tunnel
	firefight_mode_set_crate_folder_at(spawn_points_2, 	92); //spawns in the front left
	firefight_mode_set_crate_folder_at(spawn_points_3, 	93); //spawns by the back left
	firefight_mode_set_crate_folder_at(spawn_points_4, 	94); //spawns by the back right
	firefight_mode_set_crate_folder_at(spawn_points_5, 	95); //middle
	firefight_mode_set_crate_folder_at(spawn_points_6, 	96); //entrance corridor
	firefight_mode_set_crate_folder_at(spawn_points_7,	97); //T: Rock side room, upper floor
	firefight_mode_set_crate_folder_at(spawn_points_8, 	98); //T: vine side room
	firefight_mode_set_crate_folder_at(spawn_points_9, 	99); //T: entry to vine side room
	firefight_mode_set_crate_folder_at(spawn_points_10, 80); //T: near the front of the temple, for e1_m2
	
//set objective names
	firefight_mode_set_objective_name_at(destroy_obj_1, 			1); //objective behind the dias
	firefight_mode_set_objective_name_at(defend_obj_1, 				2); //objective in the tunnel
	firefight_mode_set_objective_name_at(defend_obj_2, 				3); //objective in the tunnel
	firefight_mode_set_objective_name_at(capture_obj_0, 			4); //objective in the tunnel
	firefight_mode_set_objective_name_at(power_core, 					6); //on the dias
	firefight_mode_set_objective_name_at(destroy_obj_2, 			7);  //on the dias
	firefight_mode_set_objective_name_at(destroy_obj_3, 			8);  //in the tunnel
	firefight_mode_set_objective_name_at(capture_obj_1, 			9); //objective on the dias
	firefight_mode_set_objective_name_at(objective_switch_1, 	10); //touchscreen switch on the walkway
	firefight_mode_set_objective_name_at(defend_obj_3, 				11); //objective in the back, behind the dias
	firefight_mode_set_objective_name_at(defend_obj_4, 				12); //objective in the back, behind the dias
	firefight_mode_set_objective_name_at(destroy_obj_1b, 			13);
	firefight_mode_set_objective_name_at(objective_switch_3, 	14);
	firefight_mode_set_objective_name_at(objective_switch_2, 	19); //in the leftside room
	firefight_mode_set_objective_name_at(objective_switch_4, 	20); //in the leftside room
	
	firefight_mode_set_objective_name_at(lz_0, 	50); //T: altar room, upper landing
	firefight_mode_set_objective_name_at(lz_1, 	51); //T: entry door, in temple
	firefight_mode_set_objective_name_at(lz_2, 	52); //T: side entry, rock room
	firefight_mode_set_objective_name_at(lz_3, 	53); //T: right entry to altar room
	firefight_mode_set_objective_name_at(lz_4, 	54); //T: left entry to altar room
	firefight_mode_set_objective_name_at(lz_5, 	55); //T: back on entry hall
	firefight_mode_set_objective_name_at(lz_6, 	56); //T: bottom of main temple ramp
	firefight_mode_set_objective_name_at(lz_7, 	57); //t: bottom of main temple ramp, entry side.
	firefight_mode_set_objective_name_at(lz_8, 	58); //T: altar room, upper landing, altar area
	firefight_mode_set_objective_name_at(lz_9, 	59); //T: Center of the upper bridge.
	firefight_mode_set_objective_name_at(lz_10, 60); //T: back of the tree side room.
	firefight_mode_set_objective_name_at(lz_11, 61); //T: where tree side room meets main temple
	firefight_mode_set_objective_name_at(lz_12, 62); //T: middle of the tree side room
	firefight_mode_set_objective_name_at(lz_13, 63); //T: middle of the top tier, altar room
	firefight_mode_set_objective_name_at(lz_14, 64); //T: middle of the temple, ground floor
	firefight_mode_set_objective_name_at(lz_15, 65); //T: side corridor, for e1_m2
	
	firefight_mode_set_objective_name_at(capture_obj_2, 18); //objective on the walkway
		
//set squad group names
	firefight_mode_set_squad_at(gr_ff_guards_1, 	1);	//behind the dias
	firefight_mode_set_squad_at(gr_ff_guards_2, 	2);	//the dias
	firefight_mode_set_squad_at(gr_ff_guards_3, 	3);	//the tunnel
	firefight_mode_set_squad_at(gr_ff_guards_4, 	4); //right side
	firefight_mode_set_squad_at(gr_ff_guards_5, 	5); //left middle
	firefight_mode_set_squad_at(gr_ff_guards_6, 	6); //middle
	firefight_mode_set_squad_at(gr_ff_guards_7, 	7); //middle
	firefight_mode_set_squad_at(gr_ff_guards_8, 	8); //middle
	firefight_mode_set_squad_at(gr_ff_guards_9, 	9); //middle
	firefight_mode_set_squad_at(gr_ff_guards_10, 	10); //middle
	firefight_mode_set_squad_at(gr_ff_guards_11, 	11); //middle
	firefight_mode_set_squad_at(gr_ff_guards_12, 	12); //middle
	firefight_mode_set_squad_at(gr_ff_guards_13, 	13); //middle
	firefight_mode_set_squad_at(gr_ff_guards_14, 	14); //middle
	firefight_mode_set_squad_at(gr_ff_guards_15, 	15); //middle
	firefight_mode_set_squad_at(gr_ff_guards_16, 	16); //middle
	firefight_mode_set_squad_at(gr_ff_guards_17, 	17); //middle
	firefight_mode_set_squad_at(gr_ff_guards_18, 	18); //middle
	firefight_mode_set_squad_at(gr_ff_guards_19, 	19); //middle
	firefight_mode_set_squad_at(gr_ff_guards_20, 	20); //middle
	firefight_mode_set_squad_at(gr_ff_guards_21, 	21); //T: middle of bridge
	firefight_mode_set_squad_at(gr_ff_guards_22, 	22); //T: back landing pad of tree room
	
	firefight_mode_set_squad_at(gr_ff_waves, 					50);
	firefight_mode_set_squad_at(gr_ff_phantom_attack,	51); //phantoms -- doesn't seem to work
	firefight_mode_set_squad_at(gr_ff_allies_1, 			52); //tunnel
	firefight_mode_set_squad_at(gr_ff_allies_2, 			53); //behind the dias
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
//script continuous f_start_events_goals_switch_start_1
//	sleep_until (LevelEventStatus("start_switch_1"), 1);
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
//	//cinematic_set_title (title_switch_obj_1);
//end
//
//script continuous f_end_events_goals_switch_1
//	sleep_until (LevelEventStatus("end_switch_1"), 1);
//	sound_looping_stop (music_start);
//	//cinematic_set_title (title_destroy_obj_complete_1);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_start_events_goals_swarm_start_lz
//	sleep_until (LevelEventStatus("start_swarm_lz"), 1);
//	sleep (30 * 3);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	sound_impulse_start (vo_swarm_1, none, 1.0);
//	sleep (30 * 3);
//	//cinematic_set_title (title_swarm_1);
//end
//
//script continuous f_end_events_lz
//	sleep_until (LevelEventStatus("end_lz_1"), 1);
//	sound_looping_stop (music_start);
//	//cinematic_set_title (title_lz_end);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end

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
//	//cinematic_set_title (title_destroy_obj_2);
//end

//script continuous f_misc_crash_pelican
//	sleep_until (LevelEventStatus("crash_pelican"), 1);
//	print ("crash_pelican");
//	ai_place (sq_ff_pelican);
//	cs_run_command_script (sq_ff_pelican.pilot, cs_pelican_crash);
//end

//script continuous f_misc_aa_turrets
//	sleep_until (LevelEventStatus("aa_turrets"), 1);
//	print ("AA started");
//	ai_place (sq_aa_turrets);
//	//camera_test();
//	sleep (30);
//	sleep_until (LevelEventStatus("end_aa_1"), 1);
//	print ("TURRETS SHUT DOWN");
//	ai_braindead (sq_aa_turrets, true);
//end

//script continuous f_start_events_goals_aa_1
//	sleep_until (LevelEventStatus("start_aa_1"), 1);
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
////	cinematic_set_title (title_disable_aa_1);
//end
//
//script continuous f_end_events_goals_aa_1
//	sleep_until (LevelEventStatus("end_aa_1"), 1);
//	sound_looping_stop (music_start);
////	cinematic_set_title (title_aa_guns_disabled);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//end
//
//script continuous f_start_events_goals_switch_2
//	sleep_until (LevelEventStatus("objective_3"), 1);
//	sleep (30 * 8);
//	sound_looping_start (music_start, NONE, 1.0);
//	//cinematic_set_title (title_objective_3);
//end

// ==============================================================================================================
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//// PHANTOM 01 =================================================================================================== 
//script command_script cs_ff_phantom_01()
//	sleep (1);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_01.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_to (ps_ff_phantom_01.p2);
//	sleep (30 * 1);
//
//		//======== DROP DUDES HERE ======================
//	f_unload_phantom (ai_current_squad, "dual");
//	
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_01 unloaded");
//	sleep (30 * 5);
//	cs_fly_to (ps_ff_phantom_01.p1);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM 02 =================================================================================================== 
//script command_script cs_ff_phantom_02()
////	v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_02.phantom);
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
//	f_unload_phantom (ai_current_squad, "dual");
//			
//		//======== DROP DUDES HERE ======================
//	print ("ff_phantom_02 unloaded");
//	sleep (30 * 5);
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
//	cs_fly_by (ps_ff_phantom_03.p0);
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_force_combat_status (3);
//	sleep_until (b_game_ended == TRUE);
//	cs_fly_by (ps_ff_phantom_03.p1);
//	cs_fly_to (ps_ff_phantom_03.p0);
//	ai_erase (ai_current_squad);
//end

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
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	ai_vehicle_exit (ai_current_squad);
//	cs_pause(5);
//	ai_set_objective (ai_current_squad, obj_marines_follow);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_ff_pelican.pilot), "pelican_lc");
//	cs_pause(5);
//	cs_fly_to (ps_ff_pelican.p3);
//	cs_fly_to (ps_ff_pelican.p4);
//	ai_erase (ai_current_squad);
//end
//
//script static void f_pelican_outro
//	//start the pelican mini-vignette
//	print ("__pelican outro");
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
////	cinematic_set_title (title_pelican_crash);
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


/*
// ==============================================================================================================
// ====== WEAPON DROPS ===============================================================================
// ==============================================================================================================
script continuous f_start_events_waves_weapon_drop_d_1
	sleep_until (LevelEventStatus("weapon_drop_d_1"), 1);
	cinematic_set_title (weapon_drop);
	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
	thread (f_resupply_pod (dm_resupply_01, sc_resupply_01));
end

script continuous f_start_events_waves_weapon_drop_d_2
	sleep_until (LevelEventStatus("weapon_drop_d_2"), 1);
	cinematic_set_title (weapon_drop);
	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
	thread (f_resupply_pod (dm_resupply_04, sc_resupply_04));
end

script continuous f_start_events_waves_weapon_drop_c_1
	sleep_until (LevelEventStatus("weapon_drop_c_1"), 1);
	cinematic_set_title (weapon_drop);
	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
	thread (f_resupply_pod (dm_resupply_06, sc_resupply_06));
end

script continuous f_start_events_waves_weapon_drop_c_2
	sleep_until (LevelEventStatus("weapon_drop_c_2"), 1);
	cinematic_set_title (weapon_drop);
	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
	thread (f_resupply_pod (dm_resupply_07, sc_resupply_07));
end
*/

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================
/*script static void intro
	fade_out (0, 0, 0, 1);
	sleep (30);
	object_create (test);
	object_move_by_offset (test, 1, 0, 0, 30);
	teleport_players_into_vehicle (test);
	unit_open (test);
	fade_in (0, 0, 0, 3);
	player_effect_set_max_rotation (5, 5, 5);
	player_effect_set_max_rumble(5, .5);
	player_effect_start (5, 3);
	object_move_by_offset (test, 5, 0, 0, -29);
	fade_out (255, 255, 255, 1);
	player_effect_stop (1);
	sleep (30 * 1);
	object_teleport_to_object (player0, lz_0);
	sleep (1);
	object_destroy (test);
	fade_in (255, 255, 255, 90);
end

script static void camera_test
	print ("............camera test started............");
	object_cannot_take_damage (players());
	ai_disregard (players(), TRUE);
	player_camera_control (false);
	player_enable_input (FALSE);
	camera_control (true);
	camera_set (cam_0, 1);
	print ("camera0");
	sleep (1);
	camera_set (cam_1, 180);
	print ("camera1");
	sleep (240);
	object_can_take_damage (players());
	camera_control (false);
	ai_disregard (players(), false);
	player_camera_control (true);
	player_enable_input (true);
end
*/

// ==============================================================================================================
// ====== MOVING COVER STUFF ===============================================================================
// ==============================================================================================================

/*script static void f_device_move (device_name device)
	device_set_position_track( device, 'any:idle', 1 );
	device_animate_position( device, 1, 5, 1, 0, 0 );
end

script static void f_cover_move_1 (object_name column)
	object_move_by_offset (column, 13, 0, 0, 2);
	sleep_rand_s (2, 6);
	object_move_by_offset (column, 12, 0, 0, -2);
	sleep_rand_s (2, 6);
end

script continuous f_moving_cover
	sleep_until (LevelEventStatus("start_cover_c"), 1);
	begin_random_count (8)
		thread (f_cover_move_1 (column_a));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_b));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_c));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_d));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_e));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_f));
		sleep_rand_s (3, 5);
		thread (f_cover_move_1 (column_g));
		sleep_rand_s (3, 5);
	end
	sleep_rand_s (30, 45);
end

script continuous f_lower_cover_d
	sleep_until (LevelEventStatus("start_destroy_switch"), 1);
	sleep_until (device_get_position (objective_switch_3) > 0, 1);
	object_move_by_offset (d_column_c, 10, 0, 0, -1.5);
	object_move_by_offset (d_column_d, 10, 0, 0, -1.5);
	object_move_by_offset (d_column_e, 10, 0, 0, -1.5);
	object_move_by_offset (d_column_f, 10, 0, 0, -1.5);
	sleep_forever();
end
*/

// ==============================================================================================================
// ====== MISC STUFF ===============================================================================
// ==============================================================================================================


// ==============================================================================================================
// ====== E2_M5_TEMPLE_TAKE STUFF  ==============================================================================
// ==============================================================================================================


//script continuous f_e2_m5_start_true  //setting the mission 
//	sleep_until (LevelEventStatus("e2_m5_start_true"), 1);
//	mission_is_e2_m5 = true;
//end
//
//script continuous f_e2_m5_by_switch //pop the shields that block the door.
//	sleep_until (volume_test_players (e2_m5_by_switch), 1);
//	if (mission_is_e2_m5 == true) and (e2_m5_by_switch_now == true) then
//		e2_m5_by_switch_now = false;
//		//cinematic_set_title (e2_m5_d_8);
//		sleep(30 * 5);
//		//cinematic_set_title (e2_m5_d_9);
//		sleep_forever();
//	end	
//end


// cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
// cs_phase_in();
//cs_phase_to_point (ps_endknight_phase.p0);
// ai_place (sq_turret_2);
//effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ai_vehicle_get(turretPilot), "target_turret" );
//effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, sq_first_wave_pawn_3_p1);
