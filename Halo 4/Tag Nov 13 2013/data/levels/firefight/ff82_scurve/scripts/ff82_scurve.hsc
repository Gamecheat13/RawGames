//// =============================================================================================================================
// ============================================ SCURVE FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
// ================================================== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
// ==================== GLOBALS ==================================================================
// =============================================================================================================================
// ======== TITLES ==================================================================
//	global cutscene_title title_destroy = destroy;
//	global cutscene_title title_destroy_1 = destroy_1;
//	global cutscene_title title_destroy_2 = destroy_2;
//	global cutscene_title title_destroy_obj_1 = destroy_obj_1;
//	global cutscene_title title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	global cutscene_title title_destroy_obj_complete_2 = power_core_destroyed;
//	global cutscene_title title_destroy_obj_2 = shields_down;
//	
//	// =================== CINEMATIC TITLES DEFEND ======================
//	
//	global cutscene_title title_defend = defend;
//	global cutscene_title title_defend_1 = defend_1;
//	global cutscene_title title_defend_2 = defend_2;
////	global cutscene_title title_defend_obj_1 = defend_obj_1;
//	global cutscene_title title_defend_obj_complete_1 = defend_obj_complete_1;
//	
//	// =================== CINEMATIC TITLES SWARM ======================
//	
//	global cutscene_title title_swarm = swarm;
//	global cutscene_title title_good_work = good_work;
//	global cutscene_title title_lz_clear = lz_clear;
//	global cutscene_title title_switch_obj_1 = switch_obj_1;
	global cutscene_title title_swarm_1 = swarm_1;
//	global cutscene_title title_lz_end = lz_end;
//	global cutscene_title title_lz_go_to = lz_go_to;
	global cutscene_title	title_more_enemies = more_enemies;
	global cutscene_title	title_not_many_left = not_many_left;
//	//global cutscene_title title_defend_base_safe = defend_base_safe;
//	global cutscene_title title_power_cut = power_cut;
//	global cutscene_title title_objective_3 = objective_3;
	global cutscene_title title_shut_down_comm = shut_down_comm;
//	global cutscene_title title_shut_down_comm_2 = shut_down_comm_2;
//	global cutscene_title title_first_tower_down = first_tower_down;
//	global cutscene_title title_both_tower_down = both_tower_down;
	global cutscene_title title_drop_shields = drop_shields;
	global cutscene_title title_shields_down = shields_down;
	global cutscene_title title_clear_base = clear_base;
	global cutscene_title title_clear_base_2 = clear_base_2;
	global cutscene_title title_get_artifact = get_artifact;
	global cutscene_title title_got_artifact = got_artifact;
	global cutscene_title title_secure = secure;
	global cutscene_title title_get_shard_1 = get_shard_1;
	global cutscene_title title_get_shard_2 = get_shard_2;
	global cutscene_title title_get_shard_3 = get_shard_3;
	global cutscene_title title_got_shard = got_shard;
	
	global ai ai_ff_allies_1 = gr_ff_allies_1;
	global ai ai_ff_allies_2 = gr_ff_allies_2;
	
	global boolean mission_is_e1_m5 = false;
	global boolean mission_is_e2_m2 = false;
	global boolean mission_is_e4_m4 = false;
	global boolean b_wait_for_narrative = false;
//player variables for puppeteer
//global object pup_player0 = player0;
//global object pup_player1 = player1;
//global object pup_player2 = player2;
//global object pup_player3 = player3;

script startup scurve
	//Start the intro
//	sleep_until (LevelEventStatus("e1_m5"), 1);
//	print ("******************STARTING E1 M5*********************");
//	designer_zone_activate (e1_m5_palette);
//	mission_is_e1_m5 = true;
//	b_wait_for_narrative = true;
//	ai_ff_all = e1_m5_gr_ff_all;
//	thread(f_start_player_intro());
//
//
////================================================== AI ==================================================================
//
////	ai_ff_phantom_01 = sq_ff_phantom_01;
////	ai_ff_phantom_02 = sq_ff_phantom_02;
////	ai_ff_sq_marines = sq_ff_marines_3;
//
//	
////================================================== OBJECTS ==================================================================
////set crate names
////	f_add_crate_folder(cr_destroy_unsc_cover); //UNSC crates and barriers around the main spawn area
//	f_add_crate_folder(cr_destroy_cov_cover); //cov crates all around the main area
//	//f_add_crate_folder(cr_destroy_shields); //barriers that prevent getting to the top of the ziggurat
//	f_add_crate_folder(dm_destroy_shields); //barriers that prevent getting to the very back
////	f_add_crate_folder(cr_power_core); //crates that blow up at the very back right
////	f_add_crate_folder(cr_defend_unsc_cover);  //UNSC barriers in and around the front middle base
//	f_add_crate_folder(cr_capture); //Cov crates at the very back on the right
////	f_add_crate_folder(sc_destroy_unsc); //UNSC scenery in the main starting area
////	f_add_crate_folder(sc_defend_unsc); //UNSC scenery in the front middle area
////	f_add_crate_folder(v_ff_mac_cannon, 9); //mac cannons in the very back on the right
////	f_add_crate_folder(wp_power_weapons); //power weapons spawns aroung the main front area
////	f_add_crate_folder(cr_base_shields, 11); //shield walls that block in the middle back area
////	f_add_crate_folder(cr_barriers, 12); //shield walls that block the left side walkway
////	f_add_crate_folder(cr_powercore_extras); //powercore fluff objects surrounding it
////	f_add_crate_folder(cr_meadow_cov_cover); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(sc_defend_unsc_2); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(cr_forerunner_cover); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_forerunner_cover_2); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(dm_cave_shields); //Cov Cover and fluff in the meadow
////	f_add_crate_folder(dm_bridge_shields); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_bridge_cov_cover); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_defend_junk); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(eq_defend_junk); //Cov Cover and fluff on the back bridge
////	f_add_crate_folder(v_ff_unsc_vehicles); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_bridge_cov_cover_2); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(dm_destroy_1); //prop objects like covenant computers
//	f_add_crate_folder(cr_unsc_intro_weapons); //gun racks by the intro
//	f_add_crate_folder(sc_cov_cover); //energy barrier shields
//	
//
//	//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
//	f_add_crate_folder(eq_defend_1_crates); //ammo crates in front middle area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
//	
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
//	firefight_mode_set_objective_name_at(fore_switch_1, 25); //touchscreen switch in the middle of the bridge
//	firefight_mode_set_objective_name_at(door_switch_1, 26); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(door_switch_2, 27); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(shield_switch_1, 28); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(inv_hack_panel, 29); //touchscreen switch on the overlooks of the bridge
//	
//	
//	firefight_mode_set_objective_name_at(lz_0, 50); //objective in the main spawn area
//	firefight_mode_set_objective_name_at(lz_1, 51); //objective in the middle front building
//	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(lz_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(lz_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(lz_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(lz_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(lz_7, 57); //objective right by the tunnel entrance
//	firefight_mode_set_objective_name_at(lz_8, 58); //objective right by the tunnel entrance
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
//	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
//	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge
//
//	
//	firefight_mode_set_squad_at(sq_ff_phantom_01, 20); //phantom 1
//	firefight_mode_set_squad_at(sq_ff_phantom_02, 21); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//============ MAIN SCRIPT STARTS ==================================================================
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

////////////////////////////////////////////////////////////////////////////////////////////////////////
//====misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////




//script continuous f_event_blow_shields_bridge_misc
//	sleep_until (LevelEventStatus("blow_shields_bridge_misc"), 1);
//	print ("_blow shields_bridge_");
//	thread(start_camera_shake_loop ("heavy", "short"));
//	sleep_until (ai_living_count (guards_8) > 0);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_bridge_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_bridge_2);
//	object_destroy_folder (dm_bridge_shields);
//	//cinematic_set_title (title_destroy_obj_2);
//	//sleep (30 * 2);
//	stop_camera_shake_loop();
//end

//script continuous f_misc_events_oyo_weapon_drop
//	sleep_until (LevelEventStatus("oyo_weapon_drop"), 1);
////	cinematic_set_title (weapon_drop);
//	m1_vo_weapon_drop_1();
////	f_resupply_pod (dm_target_02, sc_target_02);
//end

//script continuous f_misc_events_m5_weapon_drop_1
//	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 1");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_02, sc_resupply_02);
//	ordnance_drop(weapon_drop_1, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_2
//	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 2");
//	m2_vo_weapon_drop_2();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_01, sc_resupply_01);
//	ordnance_drop(weapon_drop_2, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_3
//	sleep_until (LevelEventStatus("m5_weapon_drop_3"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 3");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
//	ordnance_drop(weapon_drop_3, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_6
//	sleep_until (LevelEventStatus("m5_weapon_drop_6"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 3");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
//	ordnance_drop(weapon_drop_6, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_1
//	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
//	m5_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	f_resupply_pod (dm_target_01, sc_target_01);
//end
//
//script continuous f_misc_events_m5_weapon_drop_2
//	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	f_resupply_pod (dm_target_02, sc_target_02);
//end


//script continuous f_end_events_goals_powercore_destroy
//	sleep_until (LevelEventStatus("powercore_destroy"), 1);
//	m2_vo_powercore_destroy();
//	cinematic_set_title (objective_3);
//
//end
//
//script continuous f_end_events_goals_capture_artifact
//	sleep_until (LevelEventStatus("capture_artifact"), 1);
//	//m2_vo_powercore_destroy();
//	cinematic_set_title (capture_3);
//
//end


//script continuous f_change_spawn_points
//	sleep_until (LevelEventStatus("spawn_point_91"), 1);
//	print (":::changing spawn point to folder 91:::");
//	object_create_folder_anew(firefight_mode_get_crate_folder_at(91));
//	object_destroy_folder(firefight_mode_get_crate_folder_at(firefight_mode_get_start_location_folder(firefight_mode_goal_get() )));
//end

//script continuous f_more_enemies_1
//	sleep_until (LevelEventStatus("more_enemies"), 1);
//	print ("more enemies event");
//	f_e5_m4_vo();
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

//script continuous f_drop_pod_stare_01
//	sleep_until (LevelEventStatus("drop_pod_stare_01"), 1);
//	//cinematic_set_title (invading);
//	//sound_impulse_start (vo_misc_invading, none, 1.0);
//	m5_vo_hunters_incoming();
//
//	//f_hunter_drop();
//
//end

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
//
//script command_script cs_small_drop_pod
//	sleep_s (3);
//	ai_set_objective (ai_current_squad, obj_survival);
//end
//
//script continuous f_spawn_squad_4b
//	sleep_until (LevelEventStatus("spawn_4b"), 1);
//	print ("_squad 4b spawning_");
//	ai_place (guards_4b);
//
//end
//
//script continuous f_start_pelican_intro
//	sleep_until (levelEventStatus ("pelican_intro"), 1);
//	//watch the pelican fly down
//	ai_place (sq_ff_outro_pelican);
//	f_pelican_outro();
//end

//script continuous f_destroy_forerunner_cover
//	sleep_until (LevelEventStatus("destroy_fore_cover"), 1);
//	print ("___destroying forerunner cover___");
//	sleep_forever (f_moving_cover);
//	object_destroy_folder (cr_forerunner_cover);
//	object_destroy_folder (cr_moveable_cover);
//end

// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

// PHANTOM 01 =================================================================================================== 
script command_script cs_ff_phantom_01()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
	
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (sq_ff_phantom_01.phantom, TRUE);
	
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_ff_phantom_01.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_ff_phantom_01.p1);
//		(print "flew by point 1")
	cs_fly_by (ps_ff_phantom_01.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (sq_ff_phantom_01.phantom, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_ff_phantom_01.p4);
	cs_fly_to (ps_ff_phantom_01.p3);
//	(cs_fly_by ps_ff_phantom_01/erase 10)
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
//	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

//script command_script cs_ff_phantom_surprise_01()
//	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
//	sleep(30);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
//	sleep (1);
////	object_cannot_die (v_ff_phantom_01, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_phantom_surprise.phantom, TRUE);
////	ai_set_blind (ai_current_squad, TRUE);
//	cs_enable_targeting (true);
//	cs_fly_by (ps_phantom_surprise.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_phantom_surprise.p1);
////		(print "flew by point 1")
//	cs_fly_to (ps_phantom_surprise.p2);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 3);
//
//		//======== DROP DUDES HERE ======================
//			
//	f_unload_phantom (sq_phantom_surprise.phantom, "dual");
//	
//			
//		//======== DROP DUDES HERE ======================
//		
//	print ("ff_phantom_01 unloaded");
//	sleep (30 * 2);
//	//(cs_vehicle_speed 0.50)
//	//cs_fly_to (ps_phantom_surprise.p1);
//	cs_fly_to (ps_phantom_surprise.p3);
//	cs_fly_to (ps_phantom_surprise.erase);
////	(cs_fly_by ps_ff_phantom_01/erase 10)
//// erase squad 
//	sleep (30 * 15);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	sleep (30 * 3);
//	ai_erase (ai_current_squad);
//end

// PHANTOM 02 =================================================================================================== 
script command_script cs_ff_phantom_02()
	//v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_02.phantom);
	sleep (1);
//	object_cannot_die (v_ff_phantom_02, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (sq_ff_phantom_02.phantom, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_phantom_02.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_ff_phantom_02.p1);
//		(print "flew by point 1")
	cs_fly_by (ps_ff_phantom_02.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (sq_ff_phantom_02.phantom, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("ff_phantom_02 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_ff_phantom_02.p3);
	cs_fly_to (ps_ff_phantom_02.erase);
// erase squad 
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

script command_script cs_ff_phantom_03()
	//v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_03.phantom);
	sleep (1);
//	object_cannot_die (v_ff_phantom_02, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (sq_ff_phantom_03.phantom, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_phantom_03.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_ff_phantom_03.p1);
//		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_02.p2);
end

//script command_script cs_ff_phantom_04()
//	//v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_03.phantom);
//	sleep (1);
////	object_cannot_die (v_ff_phantom_02, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_04.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_04.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_ff_phantom_04.p1);
////		(print "flew by point 1")
////	cs_fly_by (ps_ff_phantom_02.p2);
//end





// ==============================================================================================================
//====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================

script command_script cs_drop_pod
	sleep_s (1);
	ai_set_objective (ai_current_squad, obj_survival);
end

//script static void f_small_drop_pod_0
//	print ("drop pod 0");
//	object_create (small_pod_0);
//	thread(small_pod_0->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p0, .85, DEFUALT ));
//end
//
//script static void f_small_drop_pod_1
//	print ("drop pod 1");
//	object_create (small_pod_1);
//	thread(small_pod_1->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p1, .85, DEFUALT ));
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
//	//cs_fly_to (ps_ff_pelican.p0);
//	//cs_fly_to (ps_ff_pelican.p1);
//	
//	//cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	//sleep (30 * 5);
//	cs_fly_to (ps_ff_pelican.p0);
//	cs_fly_to (ps_ff_pelican.p1);
//	cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
////	cs_fly_to (ps_ff_pelican.p3);
//	
//	ai_vehicle_exit (sq_ff_marines_1);
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
//	
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
//
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

//script static void f_phantom_outro_2
//	//start the pelican mini-vignette
//	print ("phantom outro_2");
//	ai_place (sq_ff_phantom_03);
//	ai_place (sq_ff_phantom_04);
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_phantom_04.p1, 60);
//	player_control_lock_gaze (player1, ps_ff_phantom_04.p1, 60);
//	player_control_lock_gaze (player2, ps_ff_phantom_04.p1, 60);
//	player_control_lock_gaze (player3, ps_ff_phantom_04.p1, 60);
//	sleep (30 * 12);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	//b_end_player_goal = true;
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end







// ==============================================================================================================
//====== OTHER SCRIPTS ===============================================================================
// ==============================================================================================================


script static void attach_fx_to_cam()
	print ("::: attaching ash FX to the Camera :::");
	effect_attached_to_camera_new( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
end

script static void detach_fx_from_cam()
	print ("::: remove ash FX attached to Camera :::");
	effect_attached_to_camera_stop( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
end


script static void f_failsafe (trigger_volume tv)
	sleep_until (volume_test_players (tv));
	print ("failsafe enabled--- killing a to b thread");
	sleep_forever (objective_atob);
	f_unblip_object_cui (flag_0);
	b_goal_ended = true;
	wake (objective_atob);
end

script static void f_hunter_drop
	//start the pelican mini-vignette
	print ("hunter drop");
	cinematic_show_letterbox (true);
	object_cannot_take_damage (players());
	ai_disregard (players(), TRUE);
	player_camera_control (false);
	player_enable_input (FALSE);
	player_control_lock_gaze (player0, ps_ff_pelican_outro.p2, 60);
	player_control_lock_gaze (player1, ps_ff_pelican_outro.p2, 60);
	player_control_lock_gaze (player2, ps_ff_pelican_outro.p2, 60);
	player_control_lock_gaze (player3, ps_ff_pelican_outro.p2, 60);
	sleep (30 * 6);
	player_control_unlock_gaze (player0);
	player_control_unlock_gaze (player1);
	player_control_unlock_gaze (player2);
	player_control_unlock_gaze (player3);
	cinematic_show_letterbox (false);
	object_can_take_damage (players());
	ai_disregard (players(), false);
	player_camera_control (true);
	player_enable_input (true);
end



script static void f_device_move (device_name device)
	print ("moving device");
	device_set_position_track( device, 'any:idle', 1 );
//	device_set_position_immediate (bishop_tower_2, 0);
	device_animate_position( device, 1, 5, 1, 0, 0 );
//	objects_attach (bishop_tower_2, "", objective_switch_2, "");
//	device_animate_position( bishop_tower_2, 1, 5, 1, 0, 0 );

end


script static void f_animate_device (device_name device, real time)
	print ("animating device");
	//device_set_position_transition_time (e1_m5_spire, 1);
	device_set_position_track( device, 'any:idle', 1 );
	device_animate_position (device, 1, time, 1, 0, 0);
end

script static void f_test_anim (device_name switch)
	device_set_position_track( switch, "any:idle", 0.0 );
	device_animate_position( switch, 1, 6.0, 1.0, 1.0, TRUE );
end

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


// =================TURRETS

//script command_script cs_stay_in_turret
//	cs_shoot (true);
//	cs_enable_targeting (true);
//	cs_enable_moving (true);
//	cs_enable_looking (true);
//	cs_abort_on_damage (FALSE);
//	cs_abort_on_alert (FALSE);
//	//(sleep_until (<= (ai_living_count ai_current_actor) 0))
//end

//end
//script continuous f_misc_spawn_turrets
//	sleep_until (LevelEventStatus ("spawn_turrets"), 1);
//	print ("::TURRETS::");
//	object_create_anew (turret_switch_0);
//	thread (f_turret_place (sq_ff_turrets.pilot_0, turret_switch_0, "a"));
//	sleep (1);
//	object_create_anew (turret_switch_1);
//	thread (f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b"));
//	NotifyLevel ("start_turrets");
//end
//
//script continuous f_misc_start_turrets
//	sleep_until (LevelEventStatus ("start_turrets"), 1);
//	//NotifyLevel("start_turrets");
//	cinematic_set_title (turret_active);
//	//m1_vo_start_turrets();
//end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================


//script continuous f_misc_m1_start_turrets
//	sleep_until (LevelEventStatus ("start_turrets"), 1);
//	//NotifyLevel("start_turrets");
//
//	m1_vo_start_turrets();
//end

// ===========STARTING E1 M3==============================


//script continuous f_start_events_e1_m3_1
//	sleep_until (LevelEventStatus("start_e1_m3_switch_1"), 1);
//	print ("STARTING start_e1_m3_switch_1");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_1_vo();
//	sleep_until (object_get_health(player0) > 0, 1);
//	cinematic_set_title (title_shut_down_comm);
//	sleep_until (device_get_power (objective_switch_2) == 1);
//	device_set_power (objective_switch_2, 0);
//	ai_place (sq_turret_2);
//end
//
//script continuous f_start_events_e1_m3_2
//	sleep_until (LevelEventStatus("start_e1_m3_switch_2"), 1);
//	print ("STARTING start_e1_m3_switch_2");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_2_vo();
//	cinematic_set_title (title_shut_down_comm);
//end
//
//script continuous f_end_events_e1_m3_2
//	sleep_until (LevelEventStatus("end_e1_m3_switch_2"), 1);
//	print ("ENDING start_e1_m3_switch_2");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	
//	thread(start_camera_shake_loop ("heavy", "short"));
//	
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0))));
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
//	
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_switch_2_vo();
//	sleep (30 * 2);
//	stop_camera_shake_loop();
//	cinematic_set_title (title_first_tower_down);
//end
//
//script continuous f_start_events_e1_m3_3
//	sleep_until (LevelEventStatus("start_e1_m3_switch_3"), 1);
//	print ("STARTING start_e1_m3_switch_3");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	sleep (30 * 7);
//	start_e1_m3_switch_3_vo();
//	cinematic_set_title (title_shut_down_comm_2);
//	device_set_power (objective_switch_2, 1);
//end
//
//script continuous f_end_events_e1_m3_3
//	sleep_until (LevelEventStatus("end_e1_m3_switch_3"), 1);
//	print ("ENDING start_e1_m3_switch_3");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	
//	thread(start_camera_shake_loop ("heavy", "short"));
//
//	//sleep (30 * 2);
//	
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0))));
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_switch_3_vo();
//	cinematic_set_title (title_both_tower_down);
//	sleep (30 * 2);
//	stop_camera_shake_loop();
//end
//
//script continuous f_start_events_e1_m3_4
//	sleep_until (LevelEventStatus("start_e1_m3_lz_1"), 1);
//	print ("STARTING start_e1_m3_lz_1");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	sleep (30 * 7);
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
//
//script continuous f_start_events_e1_m3_6
//	sleep_until (LevelEventStatus("start_e1_m3_lz_3"), 1);
//	print ("STARTING start_e1_m3_lz_3");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	f_blip_object_cui (lz_5, "navpoint_goto");
//	//sleep (30);
//	sleep (30 * 7);
//	start_e1_m3_lz_3_vo();
//	cinematic_set_title (title_swarm_1);
//end
//
//script continuous f_end_events_e1_m3_6
//	sleep_until (LevelEventStatus("end_e1_m3_lz_3"), 1);
//	print ("ENDING start_e1_m3_lz_3");
//	//sleep (30);
//	
//	f_unblip_object_cui (lz_5);
//
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e1_m3_lz_3_vo();
//	cinematic_set_title (title_lz_clear);
//	//watch the pelican fly down
//	ai_place (sq_ff_outro_pelican);
//	f_pelican_outro();
//end

// ============================ENDING E1 M3==============================


// ============================STARTING E1 M5==============================
//
//script continuous aaa_start_event_test
//	sleep_until (LevelEventStatus("test_test"), 1);
//	print ("testing testing testing");
//end
//
//script continuous f_start_events_e1_m5_1
//	sleep_until (LevelEventStatus("start_e1_m5_switch_1"), 1);
//	print ("STARTING start_e1_m5_switch_1");
//	switch_zone_set (e1_m5); 
//	//b_wait_for_narrative_hud = true;
//	print ("narrative hud true");
//	//sleep (30);
//	start_e1_m5_switch_1_vo();
//	ai_place (sq_turret);
//	
//	sleep_until (object_get_health(player0) > 0, 1);
//	sound_looping_start (music_start, NONE, 1.0);
//	//sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	//cinematic_set_title (title_drop_shields);
//	thread (f_ranger_drop());
//	sleep (30 * 5);
//	
//	//scaling the doors (replace once we get real geo)
////	object_create (e1_m5_door_1);
////	object_create (e1_m5_door_2);
////	print ("doors created");
////	
////	object_set_scale (e1_m5_door_1, 2, 1);
////	object_set_scale (e1_m5_door_2, 2, 1);
//	cinematic_set_title (turn_on_power);
//end
//
////script static void f_lava_damage
////
////end
//
//script static void f_ranger_drop
//	sleep_until (volume_test_players (vol_ranger_drop));
//	print ("ranger drop");
//	f_create_new_spawn_folder (96);
//	ai_place (sq_rangers_bridge);
//	
//
//end
//
//script continuous f_end_events_e1_m5_1
//	sleep_until (LevelEventStatus("end_e1_m5_switch_1"), 1);
//	print ("ENDING start_e1_m5_switch_1");
//	//sleep (30);
//	switch_move_1();
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//thread (tower_move_1());
//	//cinematic_set_title (power_restored);
//	end_e1_m5_switch_1_vo();
//	
//end
//
//script static void switch_move_1
//	print ("switch move 1");
////	object_destroy (e1_m5_tower_move_1);
//	b_wait_for_narrative_hud = true;
//	//tower_move_1();
//	f_animate_device (e1_m5_spire, 5);
//	sleep_s(1);
//	cinematic_set_title (power_restored);
//	sleep_s(1);
//	//object_create (e1_m5_switch_move_2);
//	//object_create (e1_m5_switch_move_1);
//	
////	sleep(5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_switch_move_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_switch_move_2);
//	//thread (f_move_crates_1 (e1_m5_switch_move_1));
//	//object_move_by_offset (e1_m5_switch_move_2, 3, -1, 0, 0);
//	thread (f_animate_device (e1_m5_doorswitch01, 3));
//	thread (f_animate_device (e1_m5_doorswitch02, 3));
//	
//	sleep(100);
//	//move the switches up
//	thread (f_move_crates_2 (door_switch_1));
//	object_move_by_offset (door_switch_2, 3, 0, 0, 1);
//	
//
//	sleep_s(1);
//	cinematic_set_title (title_drop_shields);
//	sleep_s(2);
//	
//	b_wait_for_narrative_hud = false;
//	//power up the controls
//	device_set_power (door_switch_1, 1);
//	device_set_power (door_switch_2, 1);
//	
//	sleep_s(2);
//	notifylevel ("pod_0");
//	//object_move_by_offset (e1_m5_tower_move_1, 5, 0.1, 0.1, -3);
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_tower_move_2);
//	//print ("effect on tower move 2");
//end
//
//script static void tower_move_1
//	print ("tower move 1");
////	object_destroy (e1_m5_tower_move_1);
//	object_create (e1_m5_tower_move_1);
//	object_set_scale (e1_m5_tower_move_1, 3, 1);
////	sleep(5);
//	object_move_by_offset (e1_m5_tower_move_1, 5, 0.1, 0.1, 3);
//	//sleep_s(3);
//	//object_move_by_offset (e1_m5_tower_move_1, 5, 0.1, 0.1, -3);
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, dm_resupply_02);
//	print ("effect on tower move 1");
//end
//
//script continuous f_start_events_e1_m5_1_5
//	sleep_until (LevelEventStatus("start_e1_m5_switch_2"), 1);
//	print ("STARTING start_e1_m5_switch_2");
//	//power up the controls
//	//device_set_power (door_switch_1, 1);
//	//device_set_power (door_switch_2, 1);
//	//b_wait_for_narrative_hud = true;
//	//sleep (30 * 7);
//	//cinematic_set_title (title_drop_shields);
//end
//
//
//
//script static void f_move_crates_1 (object_name crate)
//	object_move_by_offset (crate, 3, 1, 0, 0);
//end
//
//script static void f_move_crates_2 (object_name crate)
//	object_move_by_offset (crate, 3, 0, 0, 1);
//end
//
//script continuous f_end_events_e1_m5_1_5
//	sleep_until (LevelEventStatus("end_e1_m5_switch_2"), 1);
//	print ("ENDING start_e1_m5_switch_2");
//	//power off the controls if necessary
//		//blowing up the shields
//	NotifyLevel ("blow_shields_bridge");
//
//end
//
//script continuous f_event_blow_shields_bridge
//	sleep_until (LevelEventStatus("blow_shields_bridge"), 1);
//	print ("_blow shields_bridge_");
//	thread(start_camera_shake_loop ("heavy", "short"));
//	cinematic_set_title (doors_are_opening);
//	sleep_until (ai_living_count (guards_8) > 0);
//	f_move_bridge_doors();
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_door_1);
//	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_door_2);
//	//object_destroy_folder (dm_bridge_shields);
//	//cinematic_set_title (title_shields_down);
//	//cinematic_set_title (title_destroy_obj_2);
//	//sleep (30 * 2);
//	stop_camera_shake_loop();
//end
//
//script static void f_move_bridge_doors
//	print ("bridge doors moving");
//	
//	//thread (f_move_door(e1_m5_door_1));
//	//thread (f_move_door(e1_m5_door_2));
//	
//	f_animate_device (e1_m5_doors, 3);
//end
//
//script static void f_move_door (object_name door)
//	print ("___moving___doors___");
//	object_move_by_offset (door, 3, 0, -1, 3);
//	//object_move_by_offset (crate, 3, 1, 0, 0);
//end
//
//
//script continuous f_start_events_e1_m5_2
//	sleep_until (LevelEventStatus("start_e1_m5_clear_base_1"), 1);
//	print ("STARTING start_e1_m5_clear_base_1");
//
//	//sleep (30);
//	//thread (f_failsafe (failsafe_1));
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	ai_place (sq_base_turret);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	sleep (30 * 7);
//	start_e1_m5_clear_base_1_vo();
//	cinematic_set_title (title_clear_base);
//end
//
//script continuous f_start_events_e1_m5_3_5
//	sleep_until (LevelEventStatus("start_e1_m5_switch_3"), 1);
//	print ("STARTING start_e1_m5_switch_3");
//		//power up the controls
//	device_set_power (shield_switch_1, 1);
//	cinematic_set_title (drop_shields_2);
//	f_blip_object_cui (inv_hack_panel, "navpoint_activate");
//	f_hack_shields();
//end
//
//script static void f_hack_shields
//	print ("hack shields started");
//	sleep_until (device_get_position (shield_switch_1) == 1);
//	device_set_power (inv_hack_panel, 1);
//	cinematic_set_title (give_it_a_whack);
//	//add VO here
//	sleep_until (volume_test_players (vol_hack) and player_action_test_melee(),1);
//	print ("shields hacked");
//	device_set_power (inv_hack_panel, 0);
//	b_end_player_goal = true;
//	f_unblip_object_cui (inv_hack_panel);
//end
//
//script continuous f_end_events_e1_m5_3_5
//	sleep_until (LevelEventStatus("end_e1_m5_switch_3"), 1);
//	print ("ENDING start_e1_m5_switch_3");
//	notifyLevel ("blow_shields");
//	
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m5_clear_base_2_vo();
//
//	sleep_s (8);
//	
//end
//
//script continuous f_event_blow_up_shields_e1_m5
//	sleep_until (LevelEventStatus("blow_shields"), 1);
//	print ("_blow shields_");
//	thread(start_camera_shake_loop ("heavy", "short"));
//	b_wait_for_narrative_hud = true;
//	cinematic_set_title (shields_overloading);
//	//put this in the tag
//	//ai_place (sq_tunnel_fodder_2);
//	//spawning a drop pod -- replace this once the new firefight script gets checked in
//	//thread (f_load_drop_pod (dm_drop_05, sq_tunnel_fodder_2, drop_pod_lg_05));
//	
//	
//	//sleep until the last enemy is spawned
//	//sleep_until (ai_living_count (sq_tunnel_guards_2) > 0);
//	//sleep 3 seconds just for fun
//	sleep_s (3);
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
//	//sleep (30 * 5);
//	stop_camera_shake_loop();
//	cinematic_set_title (title_shields_down);
//	sleep_s (2);
//	b_wait_for_narrative_hud = false;
//	sleep_s (5);
//	cinematic_set_title (title_clear_base_2);
//	
//end
//
//script continuous f_start_events_e1_m5_3
//	sleep_until (LevelEventStatus("start_e1_m5_clear_base_2"), 1);
//	print ("STARTING start_e1_m5_clear_base_2");
//	//sleep (30);
//	
//	//notifyLevel ("blow_shields");
////	
////	sound_looping_start (music_start, NONE, 1.0);
////	sound_looping_start (music_mid_beat, NONE, 1.0);
////	//sound_looping_start (music_up_beat, NONE, 1.0);
////	ai_place (sq_sniper);
////	//sleep (30);
////	//sleep (30 * 7);
////	start_e1_m5_clear_base_2_vo();
////	cinematic_set_title (title_shields_down);
////	sleep_s (8);
////	cinematic_set_title (title_clear_base_2);
//end
//
//script continuous f_start_events_e1_m5_4
//	sleep_until (LevelEventStatus("start_e1_m5_get_artifact"), 1);
//	print ("STARTING start_e1_m5_get_artifact");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	ai_place (sq_sniper_left);
//	ai_place (sq_sniper_right);
//	f_phantom_surprise_01();
//	start_e1_m5_get_artifact_vo();
//	cinematic_set_title (title_get_artifact);
//end
//
//script static void f_phantom_surprise_01
//	print ("phantom surprise");
//	ai_place (sq_phantom_surprise);
//	cs_run_command_script (sq_phantom_surprise, cs_ff_phantom_surprise_01);
////	ai_place_in_vehicle (sq_phantom_fodder, sq_ff_phantom_01);
//	ai_place (sq_phantom_fodder);
//	f_load_dropship (ai_vehicle_get_from_spawn_point (sq_phantom_surprise.phantom), sq_phantom_fodder);
//end
//
//script continuous f_end_events_e1_m5_4
//	sleep_until (LevelEventStatus("end_e1_m5_get_artifact"), 1);
//	print ("ENDING start_e1_m5_get_artifact");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//thread (tower_move_2());
//	f_animate_device (e1_m5_artifact, 11);
//	end_e1_m5_get_artifact_vo();
//	cinematic_set_title (title_got_artifact);
//end
//
//script static void tower_move_2
//	print ("tower move 2");
////	object_destroy (e1_m5_tower_move_1);
//	object_create (e1_m5_tower_move_2);
//	object_create (e1_m5_floor_move_1);
//	object_create (e1_m5_floor_move_2);
////	sleep(5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_floor_move_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_floor_move_2);
//	object_move_by_offset (e1_m5_floor_move_1, 3, 1, 0, 0);
//	object_move_by_offset (e1_m5_floor_move_2, 3, -1, 0, 0);
//	//thread (tower_rotate_2());
//	object_move_by_offset (e1_m5_tower_move_2, 5, 0, 0, 1);
//	tower_rotate_2();
//	//sleep_s(3);
//	//object_move_by_offset (e1_m5_tower_move_1, 5, 0.1, 0.1, -3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_tower_move_2);
//	print ("effect on tower move 2");
//end
//
//script static void tower_rotate_2
//	print ("start tower rotate 2");
//	object_rotate_by_offset (e1_m5_tower_move_2, 3, 0, 0, 180, 0, 0);
//end
//
//script continuous f_start_events_e1_m5_5
//	sleep_until (LevelEventStatus("start_e1_m5_swarm"), 1);
//	print ("STARTING start_e1_m5_swarm");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m5_swarm_vo();
//	//cinematic_set_title (title_swarm);
//end
//
//script continuous f_end_events_e1_m5_5
//	sleep_until (LevelEventStatus("end_e1_m5_swarm"), 1);
//	print ("ENDING start_e1_m5_swarm");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//place the pelican
//	ai_place (squads_1);
//	end_e1_m5_swarm_vo();
//	//f_phantom_outro_2();
//	//ex2();
//	print ("wait until the pelican is parked");
//	sleep_until (f_ready_to_end(), 1);
//		f_unblip_object_cui (dc_pelican_parked);
//	navpoint_object_set_on_radar (dc_pelican_parked, false, false);
//	scene_narrative_out();
//	//cinematic_set_title (title_secure);
//		print ("DONE!");
//	b_end_player_goal = true;
//end
//
//script static boolean f_ready_to_end
//	sleep_until (b_pelican_done == true);
//		print ("pelican is parked");
//	object_create (dc_pelican_parked);
//
//	device_set_power(dc_pelican_parked, 1);
//	f_blip_object_cui (dc_pelican_parked, "navpoint_goto");
//	navpoint_object_set_on_radar (dc_pelican_parked, true, true);
//	sleep_until (device_get_position (dc_pelican_parked) == 1,1);
//
//end
//
////============================ENDING E1 M5==============================


//=========STARTING E6 M1==============================

//script continuous f_start_events_e6_m1_1
//	sleep_until (LevelEventStatus("start_e6_m1_get_shard_1"), 1);
//	print ("STARTING start_e6_m1_get_shard_1");
//	//sleep (30);
//	start_e6_m1_get_shard_1_vo();
//	//ai_place (sq_turret);
//	sleep_until (object_get_health(player0) > 0, 1);
//	sound_looping_start (music_start, NONE, 1.0);
//	//sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	cinematic_set_title (title_get_shard_1);
//	ai_place (sq_bridge_guards);
//end
//
//script continuous f_end_events_e6_m1_1
//	sleep_until (LevelEventStatus("end_e6_m1_get_shard_1"), 1);
//	print ("ENDING start_e6_m1_get_shard_1");
//	//sleep (30);
//	
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//end_e6_m1_switch_1_vo();
//	cinematic_set_title (title_got_shard);
//end
//
//script continuous f_start_events_e6_m1_2
//	sleep_until (LevelEventStatus("start_e6_m1_get_shard_2"), 1);
//	print ("STARTING start_e6_m1_get_shard_2");
//	//blowing up the shields
//	NotifyLevel ("blow_shields_bridge");
//	//sleep (30);
//	//thread (f_failsafe (failsafe_1));
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	sleep (30 * 7);
//	start_e6_m1_get_shard_2_vo();
//	cinematic_set_title (title_get_shard_2);
//end
//
//script continuous f_end_events_e6_m1_2
//	sleep_until (LevelEventStatus("end_e6_m1_get_shard_2"), 1);
//	print ("ENDING start_e6_m1_get_shard_1");
//	//sleep (30);
//	
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//end_e6_m1_switch_1_vo();
//	cinematic_set_title (title_got_shard);
//end
//
//script continuous f_start_events_e6_m1_3
//	sleep_until (LevelEventStatus("start_e6_m1_get_shard_3"), 1);
//	print ("STARTING start_e6_m1_get_shard_3");
//	//sleep (30);
//	
//	//notifyLevel ("blow_shields");
//	
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//ai_place (sq_sniper);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e6_m1_get_shard_3_vo();
//	//cinematic_set_title (title_shields_down);
//	sleep_s (8);
//	cinematic_set_title (title_get_shard_3);
//end
//
//script continuous f_end_events_e6_m1_3
//	sleep_until (LevelEventStatus("end_e6_m1_get_shard_3"), 1);
//	print ("ENDING start_e6_m1_get_shard_1");
//	//sleep (30);
//	
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	//end_e6_m1_switch_1_vo();
//	cinematic_set_title (title_got_shard);
//end
//
//script continuous f_start_events_e6_m1_4
//	sleep_until (LevelEventStatus("start_e6_m1_swarm"), 1);
//	print ("STARTING start_e6_m1_swarm");
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e6_m1_swarm_vo();
//	cinematic_set_title (title_swarm);
//end
//
//script continuous f_end_events_e6_m1_4
//	sleep_until (LevelEventStatus("end_e6_m1_swarm"), 1);
//	print ("ENDING start_e6_m1_swarm");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	//sleep (30);
//	//sleep (30 * 7);
//	end_e6_m1_swarm_vo();
//	cinematic_set_title (title_secure);
//end


//=================ENDING E6 M1==============================


// ============================STARTING E4 M3==============================
//
//script continuous f_start_events_e4_m3_1
//	sleep_until (LevelEventStatus("start_e4_m3_defend"), 1);
//
//		//turn on music
//	sound_looping_start (music_start, NONE, 1.0);
////	sound_looping_start (music_up_beat, NONE, 1.0);
//	//thread (f_create_turret_0());
//	object_create_anew (turret_switch_0);
//	thread (f_turret_place (sq_ff_turrets.pilot_0, turret_switch_0, "a"));
//	sleep (1);
//	//thread (f_create_turret_1());
//	object_create_anew (turret_switch_1);
//	thread (f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b"));
//	//start VO
//	thread (m1_vo_start_defend_1());
//	sleep_until (ai_living_count (sq_ff_marines_1) > 0);
//		ai_set_objective (sq_ff_marines_1, obj_marine_follow);
//	ai_place (sq_marine_heavy);
//	sleep (30 * 8);
//	cinematic_set_title (protect_brain);
////	cinematic_set_title (title_defend_obj_1);
//end
//
//script continuous f_start_events_e4_m3_2
//	sleep_until (LevelEventStatus("start_e4_m3_fight"), 1);
//	cinematic_set_title (title_defend_obj_1);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//end
//
//script continuous f_end_events_e4_m3_1
//	sleep_until (LevelEventStatus("end_e4_m3_defend"), 1);
//	cinematic_set_title (title_defend_base_safe);
//	m1_vo_end_defend_1();
//
//	sound_looping_stop (music_start);
//end

// ============================ENDING E4 M3==============================

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



//
//
//script static void f_start_player_intro
//	firefight_mode_set_player_spawn_suppressed(true);
//	if editor_mode() then
//		//firefight_mode_set_player_spawn_suppressed(false);
//		//sleep_s (1);
//		//intro_vignette();
//		b_wait_for_narrative = false;
//		firefight_mode_set_player_spawn_suppressed(false);
//	else
//		sleep_s (8);
//		intro_vignette();
//	end
//	//intro();
//	//firefight_mode_set_player_spawn_suppressed(false);
//	//sleep_until (goal_finished == true);
//end
//
//script static void intro_vignette
//	print ("_____________starting vignette__________________");
//	//sleep_s (8);
//	ex1();
//	sleep_until (b_wait_for_narrative == false);
//	print ("_____________done with vignette---SPAWNING__________________");
//	firefight_mode_set_player_spawn_suppressed(false);
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
//end
//
//script static void f_narrative_done
//	print ("narrative done");
//	b_wait_for_narrative = false;
//	print ("huh");
//end


//script static void intro
//	camera_set (cam_intro, 2);
//	
//	//object_create (intro_test);
//	//object_create (clouds);
//	//unit_open (intro_test);
//	object_create (intro_clouds);
//	object_create (pod);
//	//print ("moving object test");
////	thread (object_move_by_offset (intro_test, 60, 0, 0, 10));
//
//	print ("starting camera control test");
//	camera_control (true);
//	thread (pod->drop_pod_pve_animate_start());
////	repeat
////		camera_set (cam_0, 2);
////		print ("camera0");
////		sleep (2);
////		
////		camera_set (cam_1, 2);
////		print ("camera1");
////		sleep (2);
////		
////		camera_set (cam_2, 2);
////		print ("camera2");
////		sleep (2);
////		
////		camera_set (cam_3, 2);
////		print ("camera3");
////		sleep (2);
////		//sleep (240);
////	until (goal_finished == true, 1, 300);
//	sleep_s (15);
//	fade_out (255, 255, 255, 1);
//	print ("fadeing out");
//
//
//	object_destroy (pod);
//	object_destroy (intro_clouds);
//	camera_control (false);
//
//	sleep (15);
//
//	firefight_mode_set_player_spawn_suppressed(false);
//	print (":::spawning player...");
//	//camera_fov (78);
//	fade_in (255, 255, 255, 90);
//	print ("fading in");
//end
//
////script static void f_device_move (device_name device)
////	print ("device move");
////	device_set_position_track( device, 'any:idle', 1 );
//////	device_set_position_immediate (bishop_tower_2, 0);
////	device_animate_position( device, 1, 5, 1, 0, 0 );
//////	objects_attach (bishop_tower_2, "", objective_switch_2, "");
//////	device_animate_position( bishop_tower_2, 1, 5, 1, 0, 0 );
////
////end
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
//
//script command_script cs_knight_phase_spawn()
//	cs_phase_in();
//	print("that knight just came out of the ground!");
//end
//
//script static void tpl
//	ai_place (sq_bridge_guards);
//	ai_place (sq_ff_phantom_01);
//	
//	
//	ai_vehicle_enter_immediate (sq_bridge_guards, ai_vehicle_get_from_squad(firefight_mode_get_squad_at(firefight_mode_get_wave_type()), 0), "phantom_p_lf");
//	print ("ai placed in seat1");
//
//
//end

//script static void f_animate_device (device_name device, real time)
//	print ("animate small spire");
//	//device_set_position_transition_time (e1_m5_spire, 1);
//		device_set_position_track( device, 'any:idle', 1 );
//	device_animate_position (device, 1, time, 1, 0, 0);
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

//script static void test_stuff
//	if firefight_mode_get_wave_squad() == 6 then
//	print ("wave is grunts");
//	
//
//end
