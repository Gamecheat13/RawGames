//============================================ VORTEX FIREFIGHT SCRIPT E9 M1========================================================
//=============================================================================================================================

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== LEVEL SCRIPT ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_end = lz_end;
//global cutscene_title title_pelican_crash = pelican_crash;
//global cutscene_title title_aa_guns_disabled = aa_guns_disabled;
//global cutscene_title title_disable_aa_1 = disable_aa_guns;
//global cutscene_title title_use_vehicles = use_vehicles;
//global ai ai_ff_allies_1 = gr_ff_allies_1;
//global ai ai_ff_allies_2 = gr_ff_allies_2;
//global ai ai_ff_all = gr_ff_all;

script startup vortex_e9_m1()
	print ("testing startup");
	sleep_until (LevelEventStatus("e9_m1"), 1);
	print ("well this worked");
	dprint( "vortex_e9_m1: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	// THFRENCH - Moved your intilization into it's own function and hooked this stuff into here
	//Wait for start
	if ( f_spops_mission_startup_wait("e9_m1") ) then
		wake( vortex_e9_m1_init );
	end

end


script dormant vortex_e9_m1_init()
	// THFRENCH - Basically inserted the new mission flow stuff into your stuff and removed unnecessary scripting that is automatically handled by the mission flow

	//firefight_mode_set_player_spawn_suppressed(true);
	print ("************************************************STARTING E9 M1*********************");

	fade_out (0,0,0,1);

	// set standard mission init
	f_spops_mission_setup( "e9_m1", e9_m1, e9_m1_ff_all, e9m1_spawn_start, 90 );
	
	// THFRENCH - Because I don't see an intro hook i'm putting this here to let the mission flow continue.  Eventually if/when you have one you can just set this after the intro is complete
	f_spops_mission_intro_complete( TRUE );
	
	//switch_zone_set (e6_m4);		// THFRENCH - Hangled by f_spops_mission_setup
//	mission_is_e6_m4 = true;		// THFRENCH - Hangled by f_spops_mission_setup
//	b_wait_for_narrative = true;
	//ai_ff_all = e6m4_all_foes;		// THFRENCH - Hangled by f_spops_mission_setup
//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e9_m1_cov);
	f_add_crate_folder(e9_m1_fore);	
	f_add_crate_folder(e9_m1_buttons);	
	
//set spawn folder names
//	firefight_mode_set_crate_folder_at(e9m1_spawn_start, 90); //SA Spawn location: back of temple, split up 2 per side near doors

//f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy")
	// set objective names
//	firefight_mode_set_objective_name_at(c_e6m4_core_1, 80);
//	firefight_mode_set_objective_name_at(lz_hilltop, 81);
//	firefight_mode_set_objective_name_at(dc_e6m4_scan, 82);
//	firefight_mode_set_objective_name_at(lz_east_door, 83);
//	firefight_mode_set_objective_name_at(c_e6m4_core_2, 84);
//	firefight_mode_set_objective_name_at(c_e6m4_core_3, 85);
//	firefight_mode_set_objective_name_at(dc_e6m4_door_switch, 86);
	
	// set LZ spots
	firefight_mode_set_objective_name_at(dm_trace_1, 50);
	firefight_mode_set_objective_name_at(dc_power_source_1, 51);
	firefight_mode_set_objective_name_at(lz_5, 52);
////== set squad group names
	firefight_mode_set_squad_at(e9m1_phantom_01, 20);
//	firefight_mode_set_squad_at(e9m1_phantom_01, 2);
//		
// THFRENCH - This will now allow everything to start spawning
	f_spops_mission_setup_complete( TRUE );	
	//firefight_mode_set_player_spawn_suppressed(false);	// THFRENCH - Not needed, now managed by above
	
	thread (f_start_events_e9_m1());

end

script static void f_start_events_e9_m1
	print ("***********************************STARTING start_e9_m1*************");

	sleep(30);
	thread(e9_m1_master_story());
	thread(e9_m1_all_cov_dead());
	thread(e9_m1_objective_2_trace());
	thread(e9_m1_objective_3_defense_1());
	thread(e9m1_objective_4_final_activation());
	thread(f_e9_m1_end_mission());
//	thread(f_e6m4_hilltop_done());
////	thread(f_e6m4_wraiths());
//	thread(f_e6m4_camp());
//	thread(f_e6m4_camp_done());
//	thread(f_e6m4_door_reached());
//	thread(f_e6m4_second_destroy_complete());
//	thread(f_e6m4_pit_breach());
//	thread(f_e6m4_prespawn_trench());
//	thread(f_e6m4_fingers_breach());
//	thread(f_e6m4_allcores_clean_up_stragglers());
//	thread(f_e6m4_allcores_blown());
//	thread(f_e6m4_terminal_interface_sequence());
//	thread(f_e6m4_west_structure_init());
//	thread(f_e6m4_directive_investigate_console());
//	thread(f_e6m4_structure_cleanup());
//	thread(f_e6m4_nukes());
//	thread(f_e6m4_splatter_wind_down());
//	thread(f_e6m4_central_structure_init());
//	ai_place(sq_e6m4_cannoneers);
//	ai_place(sq_e6m4_ghostrider_1);
//	ai_place(sq_e6m4_ghostrider_2);
//	ai_place(squads_40);
//	ai_place(squads_41);
	
//	ai_place(sq_e6m4_mouth);
	sleep_until( f_spops_mission_start_complete(), 1 );
	fade_in (0,0,0,30);
//		thread(e6m4_());
//		kill_volume_disable(kill_);
end

	

//================================================== TITLES ==================================================================
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//================================================== MAIN SCRIPT STARTS ==================================================================
//	ai_allegiance (human, player);
//	ai_allegiance (player, human);
//	ai_lod_full_detail_actors (20);
	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	
// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================

//script static void t1
//	object_create_anew (test_pod);
//	ai_place (squads_17);
//	ai_vehicle_enter_immediate (squads_17, test_pod);
//	unit_open (test_pod);
////	sleep (30);
////	sleep (60);
//	print ("kicking ai out of pod...");
//	vehicle_unload (test_pod, "");
//
//end
//
//script static void t2
//	object_destroy (test_pod);
//
//end
// ==============================================================================================================
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

script command_script cs_phantom_e9m1_01()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
	print ("am i ingoring?");
	f_load_phantom (e9m1_phantom_01, "chute", e9_m1_cov_phan_1, e9_m1_cov_phan_2, none, none);
	object_set_shadowless (ai_current_actor, TRUE);
	print ("am i shadowless?");
//	ai_set_blind (ai_current_squad, TRUE);
	print ("am i blind?");
	cs_fly_by (e9m1_phantom_01.p0);
	print ("am i flying to my first point?");
	cs_fly_to (e9m1_phantom_01.p1);
	cs_force_combat_status (3);
	print ("am i flying to my second point?");
	cs_fly_to (e9m1_phantom_01.p2);
//	cs_fly_to_and_face (e9m1_phantom_01.p2, e9m1_phantom_01.p3);
	cs_face (true, e9m1_phantom_01.p3);
	print ("am i flying to my third point?");
	sleep (30 * 1);
	cs_face (false, e9m1_phantom_01.p3);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_actor, "chute");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_02 unloaded");
	cs_force_combat_status (3);
	sleep (30 * 5);
	cs_fly_by (e9m1_phantom_01.p4);
	if ai_living_count (e9_m1_ff_all) <= 12 then
	f_load_phantom (e9m1_phantom_01, "dual", e9_m1_cov_phan_3, e9_m1_cov_phan_4, none, none);
	cs_fly_to_and_face (e9m1_phantom_01.p5, e9m1_phantom_01.p6);
	
			//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_actor, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_02 unloaded");
	cs_force_combat_status (3);
	sleep (30 * 5);
	elseif ai_living_count (e9_m1_ff_all) >= 13 then
	cs_fly_to_and_face (e9m1_phantom_01.p5, e9m1_phantom_01.p6);
	end
	cs_fly_by (e9m1_phantom_01.p0);
	cs_fly_by (e9m1_phantom_01.p7);
	ai_erase (ai_current_squad);
end


//// ==============================================================================================================
//// ====== PELICAN COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

//script command_script cs_ff_e9_m1_pelican01
//	cs_ignore_obstacles (TRUE);
//	ai_cannot_die (ai_current_squad, TRUE);
//	sleep (1);
////	cs_fly_to (pelican_01.p0);
//	cs_fly_by (pelican_01.p1); 
//	cs_fly_by (pelican_01.p2); 
//	cs_fly_by (pelican_01.p3);
//	cs_fly_to_and_face (pelican_01.p4, pelican_01.p5);
//	sleep_until (volume_test_players (trigger_volumes_0), 1);
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//  sleep (90);
//	b_end_player_goal = TRUE;
//	player_camera_control (false);
//	player_enable_input (FALSE);
//end

//// ==============================================================================================================
//// ====== AI COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

script command_script sentinel_1
	cs_fly_by (e9m1_sentinel_01.p0);
//	cs_fly_by (e9m1_sentinel_01.p1);
//	cs_fly_by (e9m1_sentinel_01.p2);
//	cs_fly_by (e9m1_sentinel_01.p3);
	cs_fly_by (e9m1_sentinel_01.p4);
	cs_fly_by (e9m1_sentinel_01.p1);
end

script command_script forerunner_squads_0
	cs_phase_in();
end

script command_script cs_fore_turret_e9m1
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "resurrect", "control_marker");
end

script command_script cs_pawn_spawn_e9m1
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

//script static void first_sentinel_moves_01()
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_0, TRUE, ps_first_sentinel_01.p0);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_0, TRUE, ps_first_sentinel_01.p1);
//
//end
//
//script static void first_sentinel_moves_02()
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_1, TRUE, ps_first_sentinel_02.p0);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_1, TRUE, ps_first_sentinel_02.p1);
//
//end
//
//script static void first_sentinel_moves_03()
//	sleep (30*1);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_2, TRUE, ps_first_sentinel_03.p0);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_2, TRUE, ps_first_sentinel_03.p1);
//
//end
//
//script static void first_sentinel_moves_04()
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_3, TRUE, ps_first_sentinel_04.p0);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_3, TRUE, ps_first_sentinel_04.p1);
//
//end
//
//script static void first_sentinel_moves_05()
//	sleep (30*1);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_4, TRUE, ps_first_sentinel_05.p0);
//	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_4, TRUE, ps_first_sentinel_05.p1);
//
//end
//
//
//
////if one sentinel is killed, warp out the rest in a cascade
//script dormant f_sentinels_warp_01()
//	sleep_until (ai_living_count (sq_gpi_first_sentinels_01) < 5);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_3);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_4);
//
//end
//
//script dormant f_sentinels_warp_left()
//	sleep_until (ai_living_count (sq_sentinel_core_left_01) < 3);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);
//
//end
//
//script dormant f_sentinels_warp_right()
//	sleep_until (ai_living_count (sq_sentinel_core_right_01) < 3);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
//	sleep (30);
//	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);
//
//end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================

//script command_script cs_follow_player
//	sleep_until (ai_vehicle_count(ai_current_squad) == 0, 1);
//	print ("no longer in vehicle")
//	ai_set_objective (ai_current_squad, obj_survival);
//end

//script static void camera_test
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

// ==============================================================================================================
// ====== E9_M1_VORTEX==============================================================================
// ==============================================================================================================

global boolean b_wait_for_narrative = false;
global boolean e9m1_narrative_is_on = FALSE;
global boolean b_defense_ended = false;

//script static void f_start_player_intro
//	print ("start player intro");
//	firefight_mode_set_player_spawn_suppressed(false);
////	f_e3_m3_start();
////	print ("guards_1 spawn");
//end

//script static void f_start_player_intro_e9_m1
//	firefight_mode_set_player_spawn_suppressed(true);
//	if editor_mode() then
//		sleep_s (1);
////		intro_vignette_e3_m3();
////		b_wait_for_narrative = false;
////		firefight_mode_set_player_spawn_suppressed(false);
//	else
//		sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
////		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
//		intro_vignette_e9_m1();
//	end
//	//intro();
//	//firefight_mode_set_player_spawn_suppressed(false);
//	//sleep_until (goal_finished == true);
//end
//
//script static void intro_vignette_e9_m1
//	print ("_____________starting vignette__________________");
////
////	
////	//sleep_s (8);
////	b_wait_for_narrative = true;
////	cinematic_start();
////	pup_play_show (e3_m3_intro);
////	wake (e3m3_vo_intro);
////	sleep_s (15);
////	cinematic_stop();
////	sleep_s (0.5);
////	switch_zone_set (e3_m3);
////	fade_in (0,0,0,30);
//	// start VO
////thread (vo_e3m3_intro());
//	
//// wait until the puppeteer is complete
////	sleep_until (b_wait_for_narrative == false);
//	print ("_____________done with vignette---SPAWNING__________________");
//	firefight_mode_set_player_spawn_suppressed(false);
//
//
//end
//
//script static void f_narrative_done
//	print ("narrative done");
//	b_wait_for_narrative = false;
//	print ("huh");
//end
//
//
//
//script static void e9_m1_master_script
////
////	thread (e9_m1_master_story());
////	print ("Hello. Here is our story.");
////	
////	thread (e9_m1_covenant_spawn());
////	print ("digger exterior and interior spawns");
////	
////	thread (e9_m1_all_cov_dead());
////	print ("hide button till all dead");
////	
////	thread (e9_m1_zone_switch());
////	print ("prepped for switching zone sets");
////	
////	thread (e9_m1_promethean_01());
////	print ("uh oh, you woke up prometheans");
////	
////	thread (e9_m1_all_prom_dead());
////	print ("uh oh, you woke up prometheans");
////	
////	thread (e9_m1_powerupdoor());
////	print ("need to open the door");
////	
////	thread (e9_m1_doorisopen());
////	print ("door is open, now kick open the artifact");
////	
////	thread (e9_m1_gettotheplane());
//	print ("spartans, leave");
//	
//end

script static void e9_m1_master_story
	sleep_until (b_players_are_alive(), 1);
	print ("block the doors");
	object_create (dm_turret_left);
	object_create (dm_turret_left_inside);
	object_create (dm_turret_right_inside);
	object_create (dm_turret_right);

	object_set_scale (door_1, 3, 1);
	object_set_scale (door_2, 3, 1);
	object_set_scale (door_3, 3, 1);
	object_set_scale (door_5, 3, 1);
	object_set_scale (door_6, 3, 1);
	ai_place (e9_m1_cov_encounter_1);
	f_new_objective (e9_m1_obj_1);
	object_create (lz_0);
	navpoint_track_object_named(lz_0, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_3), 1);
	object_destroy (lz_0);
	sleep_s (2);
	f_new_objective (e9_m1_obj_2);
	
//	f_new_objective (e9_m1_objective_1);
//	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
//	f_digger_hole_damage();
//	f_new_objective (e9_m1_objective_4);
end

script static void e9_m1_covenant_spawn
	sleep_until (ai_living_count (e9_m1_ff_all) >= 7, 1);
//	sleep_until (ai_living_count (e9_m1_ff_all) <= 15, 1);
//	ai_place (e10m5_cov_05);
//	sleep_until (ai_living_count (e9_m1_ff_all) <= 13, 1);
//	ai_place (e10m5_hunter_left);
//	ai_place (e10m5_hunter_right);
//	ai_place (e10m5_elites_digger);
end

script static void e9_m1_all_cov_dead
	sleep_until (LevelEventStatus ("lastcovwave"), 1);
	sleep_s (3);
//	b_wait_for_narrative_hud = true;
	object_create (lz_1);
	object_create (lz_2);

	navpoint_track_object_named(lz_1, "navpoint_goto");
	navpoint_track_object_named(lz_2, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_5) or volume_test_players (trigger_volumes_4), 1);
	object_destroy (lz_1);
	object_destroy (lz_2);
	ai_place (e9_m1_cov_interior_2);
	sleep_s (1);
	object_destroy (door_1);
	object_destroy (door_2);
	e9_m1_hunter_smash();
	ai_place (gr_e9_m1_interior_1);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 5, 1);
	
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	sleep_s (2);
	prepare_to_switch_to_zone_set(e9_m1_defense);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e9_m1_defense);
	current_zone_set_fully_active();
	print ("switched zone sets");
	sleep_s (2);
	b_end_player_goal = true;
end

script static void e9_m1_hunter_smash
	if (volume_test_players (trigger_volumes_2)) then
	cs_custom_animation(e9_m1_cov_interior_2.spawn_points_1, TRUE, objects\characters\storm_hunter\storm_hunter.model_animation_graph, "any:any:melee_tackle", FALSE);
	elseif (volume_test_players (trigger_volumes_1)) then
	cs_custom_animation(e9_m1_cov_interior_2.spawn_points_0, TRUE, objects\characters\storm_hunter\storm_hunter.model_animation_graph, "any:any:melee_tackle", FALSE);
	end
	print ("hunter smash");
	ai_set_objective (e9_m1_cov_interior_2, ai_e9m1_cov_2);
end

script static void e9_m1_objective_2_trace
	sleep_until (LevelEventStatus ("e9m1tracecomms"), 1);
	b_wait_for_narrative_hud = true;
	thread (f_new_objective (e9_m1_obj_3));
	b_wait_for_narrative_hud = false;
	device_set_power (dc_trace_1, 1);
	sleep_until (device_get_position (dc_power_source_1) != 0);
	object_dissolve_from_marker (dc_power_source_1, phase_out, button_marker);
end

script static void e9_m1_objective_3_defense_1
	sleep_until (LevelEventStatus ("e9_m1_defense_first"), 1);
	f_new_objective (e9_m1_obj_4);
	object_create (lz_3);
	navpoint_track_object_named(lz_3, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_7) or volume_test_players (trigger_volumes_6), 1);
	object_destroy (lz_3);
	sleep_s (1);
	object_destroy (door_5);
	object_destroy (door_6);
	e9m1_objective_3_first_wave();
	
end

script static void e9m1_objective_3_first_wave
	if (volume_test_players (trigger_volumes_6)) then
	ai_place (e9m1_fore_knight_1);
	elseif (volume_test_players (trigger_volumes_7)) then
	ai_place (e9m1_fore_knight_2);
	end
	ai_place_with_birth (e9m1_fore_bishop_1);
	sleep_s (2);
	ai_place (enemy_turrets);
	sleep_s (2);
	ai_place (e9m1_fore_pawn_1);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	object_create (dc_power_source_1);
	navpoint_track_object_named(dc_power_source_1, "navpoint_goto");
	device_set_power (dc_power_source_1, 1);
	sleep_until (device_get_position (dc_power_source_1) != 0);
	object_dissolve_from_marker (dc_power_source_1, phase_out, button_marker);
	object_destroy (dc_power_source_1);
	sleep_s (4);
	thread (power_up_turret_switches (dc_turret_left_switch));
	thread (power_up_turret_switches (dc_turret_left_inside_switch));
	thread (power_up_turret_switches (dc_turret_right_switch));
	thread (power_up_turret_switches (dc_turret_right_inside_switch));

	f_new_objective (e9_m1_obj_5);
	defense_turret();
	
	sleep_s (15);
	ai_place (e9m1_fore_knight_1);
	sleep_s (4);
	ai_place (e9m1_fore_knight_2);
	sleep_s (4);
	ai_place_with_birth (e9m1_fore_bishop_1);
	ai_place_with_birth (e9m1_fore_bishop_1);
	sleep_s (6);
	ai_place (e9m1_fore_pawn_1);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	sleep_s (3);
	object_create_anew (dc_power_source_1);
	device_set_position (dc_power_source_1, 0);
	device_set_power (dc_power_source_1, 1);
	object_destroy_folder  (e9m1_fore_turret_switch);
	b_defense_ended = true;
	b_end_player_goal = TRUE;
	f_new_objective (e9_m1_obj_6);
end

script static void e9m1_objective_4_final_activation
	sleep_until (LevelEventStatus ("e9_m1_final_activation"), 1);
	sleep_s (2);
	ai_place (e9_m1_sent_1);
	object_create (lz_4);
	navpoint_track_object_named(lz_4, "navpoint_goto");
	sleep_s (25);
	f_new_objective (e9_m1_obj_7);
	f_e9_m1_end_mission();
end

script static void f_e9_m1_end_mission
	sleep_until (LevelEventStatus ("e9_m1_ending"), 1);
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.5);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end
	

//script static void e9_m1_zone_switch
//	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
//	prepare_to_switch_to_zone_set(e9_m1_interior);
//	sleep_until(not PreparingToSwitchZoneSet(), 1);
//	switch_zone_set(e9_m1_interior);
//	current_zone_set_fully_active();
//	print ("switched zone sets");
//end

//script static void e9_m1_promethean_01
//	sleep_until (volume_test_players (trigger_volumes_3), 1);
//	ai_place_in_limbo (knight_guard01);
//	sleep_until (volume_test_players (trigger_volumes_4), 1);
//	ai_place_in_limbo (crawler_guard02);
//	sleep_until (ai_living_count (crawler_guard02) <= 3, 1);
//	ai_place_in_limbo (crawler_guard02);
//	sleep_until (volume_test_players (trigger_volumes_5), 1);
//	ai_place (knight_guard02);
//end

//script static void e9_m1_all_prom_dead
//	sleep_until (LevelEventStatus ("allpromdead"), 1);
//		f_new_objective (e9_m1_objective_5);
//	
//	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
//	object_create (e10m5_obj5);
//	navpoint_track_object_named(e10m5_obj5, "navpoint_goto");
//	sleep_until (volume_test_players (trigger_volumes_6), 1); 
//	object_destroy (e10m5_obj5);
//
//	f_new_objective (e9_m1_objective_6);
//	b_end_player_goal = TRUE;
//	b_wait_for_narrative_hud = false;
//end

//script static void e9_m1_powerupdoor
//	sleep_until (LevelEventStatus ("openthedoorboss"), 1);
//	object_create (e10m5_obj6);
//	navpoint_track_object_named(e10m5_obj6, "navpoint_goto");
//	sleep_until (volume_test_players (trigger_volumes_7), 1); 
//	object_destroy (e10m5_obj6);
//	object_create (e10m5_obj6_1);
//	navpoint_track_object_named(e10m5_obj6_1, "navpoint_goto");
//	sleep_until (volume_test_players (trigger_volumes_8), 1); 
//	object_destroy (e10m5_obj6_1);
//	ai_place (knight_guard_3);
//	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
//	b_end_player_goal = TRUE;
//	sleep_s (2);
//	b_wait_for_narrative_hud = false;
//	device_set_power (door_control, 1);
//end
//
//script static void e9_m1_doorisopen
//	sleep_until (LevelEventStatus ("doorisopenboss"), 1);
//	object_create (e10m5_obj7);
//	navpoint_track_object_named(e10m5_obj7, "navpoint_goto");
//	sleep_until (volume_test_players (trigger_volumes_6), 1); 
//	object_destroy (e10m5_obj7);
//	sleep_s (1);
//	f_new_objective(e9_m1_objective_7);
//	b_end_player_goal = TRUE;
//	device_set_power (fore_artifact, 1);
//end
//
//
//script static void e9_m1_gettotheplane
//	sleep_until (LevelEventStatus ("gettheheckoutofdodge"), 1);
//	f_new_objective(e9_m1_objective_8);
//	camera_shake_all_coop_players (.8, .8, 6, 1.8);
//	sleep_until (volume_test_players (trigger_volumes_3), 1);
//	ai_place (squads_13);
//end

script static void f_fore_turret_place (ai turret_spawn, device dm_switch)
	
	repeat
	print ("defenses activating");
	navpoint_track_object_named(dm_switch, "navpoint_goto");
	inspect (device_get_power (dm_switch));
	sleep_until (device_get_position (dm_switch) != 0);
	f_unblip_object_cui(dm_switch);
	ai_place (turret_spawn);
	ai_set_team (turret_spawn, player);
//	local unit turret_object = ai_vehicle_get(turret_ai);
//	ai_object_set_team (turret_object, player);
	sleep_until(object_get_health(turret_spawn) <= 0.01);
	print ("turret destroyed – need to reactivate");
	sleep_s (5);
	device_set_position (dm_switch, 0);
//	f_blip_object (dm_switch);s
	until (b_defense_ended == true, 1);
end

script static void power_up_turret_switches (device dm_switch)
	device_set_power (dm_switch, 1);
end

script static void defense_turret
	thread (f_fore_turret_place (friendly_turrets.turret_left, dc_turret_left_switch));
	thread (f_fore_turret_place (friendly_turrets.turret_right, dc_turret_right_switch));
	thread (f_fore_turret_place (friendly_turrets.turret_middle, dc_turret_right_inside_switch));
	thread (f_fore_turret_place (friendly_turrets.turret_left_inside, dc_turret_left_inside_switch));
end


	

	