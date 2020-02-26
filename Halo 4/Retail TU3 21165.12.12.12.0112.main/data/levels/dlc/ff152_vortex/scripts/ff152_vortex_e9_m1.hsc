//============================================ VORTEX FIREFIGHT SCRIPT E9 M1========================================================
//=============================================================================================================================

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== LEVEL SCRIPT ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_e9m1_lz_end = e9m1_lz_end;
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

//	fade_out (0,0,0,1);

	// set standard mission init
	f_spops_mission_setup( "e9_m1", e9_m1, e9_m1_ff_all, e9m1_spawn_start, 90 );
	

	
	//switch_zone_set (e6_m4);		// THFRENCH - Hangled by f_spops_mission_setup
//	mission_is_e6_m4 = true;		// THFRENCH - Hangled by f_spops_mission_setup
//	b_wait_for_narrative = true;
	//ai_ff_all = e6m4_all_foes;		// THFRENCH - Hangled by f_spops_mission_setup
//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e9_m1_cov);
	f_add_crate_folder(e9_m1_fore);
	f_add_crate_folder(e9_m1_unsc_ammo);	
	f_add_crate_folder(e9_m1_buttons);
	f_add_crate_folder(e9_m1_ammo_equipment);
	f_add_crate_folder(e9m1_fore_turret_switch);
	f_add_crate_folder(vortex_doors);								// ==== TJP - adding doors to west structure
	f_add_crate_folder(e9_m1_hunter_doors);			// === DLE - Marked door_1 and door_2 as not automatically to ensure navmesh is created correctly.
	
	
//set spawn folder names
//	firefight_mode_set_crate_folder_at(e9m1_spawn_start, 90); //SA Spawn location: back of temple, split up 2 per side near doors

//f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy")
	// set objective names
//	firefight_mode_set_objective_name_at(c_e6m4_core_1, 80);
//	firefight_mode_set_objective_name_at(e9m1_lz_hilltop, 81);
//	firefight_mode_set_objective_name_at(dc_e6m4_scan, 82);
//	firefight_mode_set_objective_name_at(e9m1_lz_east_door, 83);
//	firefight_mode_set_objective_name_at(c_e6m4_core_2, 84);
//	firefight_mode_set_objective_name_at(c_e6m4_core_3, 85);
//	firefight_mode_set_objective_name_at(dc_e6m4_door_switch, 86);
	
	// set e9m1_lz spots
	firefight_mode_set_objective_name_at(dc_trace_1, 50);
	firefight_mode_set_objective_name_at(dc_power_source_2, 51);
	firefight_mode_set_objective_name_at(e9m1_lz_5, 52);
////== set squad group names
	firefight_mode_set_squad_at(e9m1_phantom_01, 20);
//	firefight_mode_set_squad_at(e9m1_phantom_01, 2);
	firefight_mode_set_crate_folder_at(e9m1_spawn_start, 90);
	firefight_mode_set_crate_folder_at(e9_m1_spawn_2, 91);
	firefight_mode_set_crate_folder_at(e9_m1_spawn_3, 92);
//		
// THFRENCH - This will now allow everything to start spawning
	f_spops_mission_setup_complete( TRUE );	
	//firefight_mode_set_player_spawn_suppressed(false);	// THFRENCH - Not needed, now managed by above
	
	thread (f_start_events_e9_m1());

end

script static void f_start_events_e9_m1
	print ("***********************************STARTING start_e9_m1*************");

	sleep(30);
	pup_play_show (e9_m1_floaters);
	if not object_valid(vortex_machine_audio) then 
		object_create(vortex_machine_audio);
	end
	thread(f_e9m1_start_player_intro());
	
	thread(e9_m1_master_story());
	thread(e9_m1_all_cov_dead());
	thread(e9_m1_objective_2_trace());
	thread(e9_m1_objective_3_defense_1());
	thread(e9m1_objective_4_final_activation());
	thread(f_e9_m1_end_mission());
	thread(e9m1_switch_zone());
	thread(e9_m1_covenant_spawn());
	thread(f_last_cov_callouts());

	
//	ai_place(sq_e6m4_mouth);
	print ("sleeping till mission start complete");
	sleep_until( f_spops_mission_start_complete(), 1 );
	print ("fading in");
	fade_in (0,0,0,30);
	print ("did i fade in");
//		thread(e6m4_());
//		kill_volume_disable(kill_);
end

	

//================================================== TITLES ==================================================================
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_e9m1_lz_end = e9m1_lz_end;
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
	f_load_phantom (e9m1_phantom_01, "dual", e9_m1_cov_phan_1, e9_m1_cov_phan_2, none, none);
	object_set_shadowless (ai_current_actor, TRUE);
	print ("am i shadowless?");
//	ai_set_blind (ai_current_squad, TRUE);
	print ("am i blind?");
//	cs_fly_by (e9m1_phantom_01.p0);
//	print ("am i flying to my first point?");
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
	f_unload_phantom (ai_current_actor, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_02 unloaded");
	cs_force_combat_status (3);
	sleep (30 * 5);
	cs_fly_by (e9m1_phantom_01.p4);
	if ai_living_count (e9_m1_ff_all) <= 12 then
	f_load_phantom (e9m1_phantom_01, "left", e9_m1_cov_phan_3, e9_m1_cov_phan_4, none, none);
	cs_fly_to_and_face (e9m1_phantom_01.p5, e9m1_phantom_01.p6);
	
			//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_actor, "left");
			
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

script command_script cs_ff_e9_m1_pelican01
	object_set_physics (squads_33, true);
	cs_ignore_obstacles (TRUE);
	ai_cannot_die (ai_current_squad, TRUE);
	sleep (1);
	cs_fly_to (e9m1_pelican_01.p0);
	cs_fly_by (e9m1_pelican_01.p1); 
	cs_fly_by (e9m1_pelican_01.p2); 
	cs_fly_by (e9m1_pelican_01.p3);
	cs_fly_to_and_face (e9m1_pelican_01.p4, e9m1_pelican_01.p5);
	sleep_s (2);
	b_end_player_goal = TRUE;
//	sleep_until (volume_test_players (trigger_volumes_0), 1);
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//  sleep (90);
//	b_end_player_goal = TRUE;
//	player_camera_control (false);
//	player_enable_input (FALSE);
end

//// ==============================================================================================================
//// ====== AI COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

global short sent_1 = 0;
global short sent_2 = 0;
global short pawns_shot = 0;

script command_script sentinel_1
	cs_fly_by (e9m1_sentinel_01.p0);
//	cs_fly_by (e9m1_sentinel_01.p1);
//	cs_fly_by (e9m1_sentinel_01.p2);
//	cs_fly_by (e9m1_sentinel_01.p3);
	cs_fly_by (e9m1_sentinel_01.p4);
	cs_fly_by (e9m1_sentinel_01.p1);
end

script command_script forerunner_squads_0
//	cs_phase_in();
	sleep_rand_s (0.1, 0.6); 
	cs_phase_in();
	ai_exit_limbo(ai_current_actor); 
end

script command_script cs_fore_turret_e9m1
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "resurrect", "control_marker");
end

script command_script cs_friend_fore_turret_e9m1
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "resurrect", "control_marker");
	unit_set_maximum_vitality (ai_vehicle_get(ai_current_actor), 400, 400);
end

script command_script cs_pawn_spawn_e9m1
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script first_pawn_moves_01
	cs_go_to (point_sets_2.p0);
	cs_leap_to_point (point_sets_2.p1);

end

script command_script secondarysentinel
	cs_shoot_secondary_trigger (e9_m1_sent_1, true);
end

script command_script e9m1_sent_fire
	cs_shoot_secondary_trigger (true);
	repeat
//	sleep_until (LevelEventStatus ("sentfly"), 1);
//	cs_shoot_point (e9_m1_sent_2.spawn_points_0, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_0, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_2.spawn_points_8, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_1, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_2.spawn_points_2, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_2, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_2.spawn_points_3, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_3, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_4, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_5, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_6, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_7, true, e9m1_end_beam.p0);
//	cs_shoot_point (e9_m1_sent_1.spawn_points_8, true, e9m1_end_beam.p0);
	cs_shoot_point (true, e9m1_end_beam.p0);
	print ("did i shoot?");
	until (pawns_shot == 1);
end	
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

script static void f_e9m1_start_player_intro
	sleep_until (f_spops_mission_ready_complete(), 1);
	if editor_mode() then
	sleep_s (1);
	else
	print ("start player intro");
	thread (f_e9_m1_music_start());
	intro_vignette_e9_m1();
	end
//	 THFRENCH - Because I don't see an intro hook i'm putting this here to let the mission flow continue.  Eventually if/when you have one you can just set this after the intro is complete
	f_spops_mission_intro_complete( TRUE );
end

script static void intro_vignette_e9_m1
	print ("_____________starting vignette__________________");

	
	//sleep_s (8);
//	sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
	pup_disable_splitscreen (true);
	local long show = pup_play_show(e9_m1_intro);
	thread (vo_e9m1_narr_in());
	sleep_until (not pup_is_playing(show), 1);

//	pup_play_show (e9_m1_intro);
//	wake (e3m3_vo_intro);
//	sleep_s (14);
	pup_disable_splitscreen (false);
	


	
// wait until the puppeteer is complete
	print ("_____________done with vignette---SPAWNING__________________");



end
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

	b_end_player_goal = TRUE;
	print ("block the doors");
	object_create (dm_turret_left);
	object_create (dm_turret_left_inside);
	object_create (dm_turret_right_inside);
	object_create (dm_turret_right);

//	object_set_scale (door_1, 3, 1);
//	object_set_scale (door_2, 3, 1);
//	object_set_scale (door_3, 3, 1);
//	object_set_scale (door_5, 3, 1);
//	object_set_scale (door_6, 3, 1);
	ai_place (e9_m1_cov_encounter_1);
	sleep_s (2);
	f_new_objective (e9_m1_obj_1);

	thread (vo_e9m1_comms());
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	sleep_s (1);
	thread (vo_e9m1_start_there());
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	object_create (e9m1_lz_0);
	navpoint_track_object_named(e9m1_lz_0, "navpoint_goto");
	sleep_until (ai_living_count (e9_m1_ff_all) <= 17, 1);
	sleep_s (2);
	thread (f_e9_m1_event0_start());
	vo_e9m1_badguys();
	f_new_objective (e9_m1_obj_2);
		object_destroy (e9m1_lz_0);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 5, 1);
	sleep_s (1);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 5, 1);
	notifylevel ("lastcovies");	

end

script static void e9_m1_covenant_spawn
	sleep_until (LevelEventStatus ("phantomsinbound"), 1);
	thread (f_e9_m1_event0_stop());
	thread (f_e9_m1_event1_start());
	vo_e9m1_more_badguys();
end

script static void e9_m1_all_cov_dead
	sleep_until (LevelEventStatus ("lastcovwave"), 1);
	sleep_s (2);
	thread (f_e9_m1_event1_stop());
	vo_e9m1_locked();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	f_new_objective (e9_m1_obj_2_1);
//	b_wait_for_narrative_hud = true;
	object_create (e9m1_lz_1);
	object_create (e9m1_lz_2);

	navpoint_track_object_named(e9m1_lz_1, "navpoint_goto");
	navpoint_track_object_named(e9m1_lz_2, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_5) or volume_test_players (trigger_volumes_4), 1);
	object_destroy (e9m1_lz_1);
	object_destroy (e9m1_lz_2);
	ai_place (e9_m1_cov_interior_2);
	sleep (30);
	thread (f_e9_m1_event2_start());
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_doorderez_small_mnde943', door_1, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(door_1, phase_out, fx_derez);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_doorderez_small_mnde943', door_2, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(door_2, phase_out, fx_derez);
	thread (vo_e9m1_door_derez());
	sleep_s (1);
	object_set_physics (door_1, false);
	object_set_physics (door_2, false);
	e9_m1_hunter_smash();
	sleep (25);
	object_destroy (door_1);
	object_destroy (door_2);

	ai_place (gr_e9_m1_interior_1);

	sleep_until (ai_living_count (e9_m1_ff_all) <= 5, 1);
	notifylevel ("lastcovies");
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	thread (f_e9_m1_event2_stop());
	sleep_s (4);
	vo_e9m1_listen_comms();
	b_end_player_goal = true;
end

script static void e9m1_switch_zone
	sleep_until (LevelEventStatus ("e9m1switchzones"), 1);
	thread (f_e9_m1_event3_start());

	sleep_s (2);
	b_wait_for_narrative_hud = true;
	object_create_anew (weapon_1);
	object_create_anew (weapon_2);

	vo_e9m1_listeng_in();
	sleep(2);
	thread (ammo_blip_1());
	thread (ammo_blip_2());
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	vo_e9m1_kill_time();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	sleep_until (not volume_test_players (trigger_volumes_8), 1, 4*30);
	print ("preparing to switch zone sets");
	prepare_to_switch_to_zone_set(e9_m1_defense);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e9_m1_defense);
	current_zone_set_fully_active();
	object_destroy (door_1);
	object_destroy (door_2);
	notifylevel ("switchedzonesets");
	f_unblip_object (weapon_1);
	f_unblip_object (weapon_2);
		thread (f_e9_m1_event3_stop());
end

script static void ammo_blip_1
	navpoint_track_object_named(weapon_1, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_11), 1);
	f_unblip_object (weapon_1);
end
	
script static void ammo_blip_2	
	navpoint_track_object_named(weapon_2, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_10), 1);
	f_unblip_object (weapon_2);
end	


script static void e9_m1_hunter_smash
	if (volume_test_players (trigger_volumes_2)) then
	cs_pause (e9_m1_cov_interior_2.spawn_points_1, true, 1);
	cs_custom_animation(e9_m1_cov_interior_2.spawn_points_1, TRUE, objects\characters\storm_hunter\storm_hunter.model_animation_graph, "any:any:melee_tackle", FALSE);
	elseif (volume_test_players (trigger_volumes_1)) then
	cs_pause (e9_m1_cov_interior_2.spawn_points_0, true, 1);
	cs_custom_animation(e9_m1_cov_interior_2.spawn_points_0, TRUE, objects\characters\storm_hunter\storm_hunter.model_animation_graph, "any:any:melee_tackle", FALSE);
	end
	print ("hunter smash");
	ai_set_objective (e9_m1_cov_interior_2, ai_e9m1_cov_2);
end

script static void f_e9_m1_switch_activate (object control, unit player)
//script static void f_push_fore_switch (unit player)
print ("pushing the forerunner switch");

	g_ics_player = player;
// g_ics_player = player0;
	if control == dc_trace_1 then
	print ("play comms switch puppetshow");
	pup_play_show (trace_button_press_1);
// elseif dev == power_switch_temp then
// pup_play_show (e1_m5_push_power_button);

//	elseif control == e4_m2_fore_water_base_thing then
//	print ("play button 2 puppetshow");
//	pup_play_show (e4m2_port_right_press);
	end
end

script static void e9_m1_objective_2_trace
	sleep_until (LevelEventStatus ("e9m1tracecomms"), 1);
	b_wait_for_narrative_hud = true;
	object_create_anew (dc_trace_1);
	sleep_s (2);

	f_new_objective (e9_m1_obj_3);
	b_wait_for_narrative_hud = false;
	device_set_power (dc_trace_1, 1);
	sleep_until (device_get_position (dc_trace_1) != 0);
		device_set_power (dc_trace_1, 0);
	print ("play comms switch puppetshow");
	local long show = pup_play_show (trace_button_press_1);
	sleep_until (not pup_is_playing(show), 1);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_activate.sound', dm_trace_2, 1 ); //CONTROL PANEL AUDIO!
	device_set_position (dm_trace_2, 1);
//	dm_trace_2->SetDerezWhenActivated();
	sleep_s(1);
	object_dissolve_from_marker(dm_trace_2, phase_out, panel);
	sleep_s(1);
	device_set_position (dm_trace_1, 1);
	object_create_folder (e9_m1_spawn_2);
	sleep_s (1);
	object_destroy_folder (e9m1_spawn_start);
	object_destroy (dm_trace_2);
end

script static void e9_m1_objective_3_defense_1
	sleep_until (LevelEventStatus ("e9_m1_defense_first"), 1);
	b_wait_for_narrative_hud = true;
	sleep_until (LevelEventStatus ("switchedzonesets"), 1);
	b_wait_for_narrative_hud = false;
	sleep_s (3);
	vo_e9m1_power_source();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	f_new_objective (e9_m1_obj_4);
	object_create (e9m1_lz_3);
	navpoint_track_object_named(e9m1_lz_3, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_7) or volume_test_players (trigger_volumes_6), 1);
	object_destroy (e9m1_lz_3);
	sleep_s (1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_doorderez_large_mnde943', door_4, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(door_4, phase_out, fx_derez);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_tower_wall_door_med_derez_mnde943', door_5, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(door_5, phase_out, fx_derez);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_tower_wall_door_med_derez_mnde943', door_6, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(door_6, phase_out, fx_derez);
	object_set_physics (door_4, false);
	object_set_physics (door_5, false);
	object_set_physics (door_6, false);
	thread (f_e9_m1_event4_start());
	e9m1_objective_3_first_wave();
	
end

script static void e9m1_objective_3_first_wave
	if (volume_test_players (trigger_volumes_6)) then
	ai_place_in_limbo (e9m1_fore_knight_1);
	elseif (volume_test_players (trigger_volumes_7)) then
	ai_place_in_limbo (e9m1_fore_knight_2);
	end
	ai_place_with_birth (e9m1_fore_bishop_1);
	vo_glo15_miller_prometheans_01();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	f_new_objective (e9_m1_obj_4_1);
	sleep_s (2);
	ai_place (enemy_turrets);
	sleep_s (2);
	ai_place (e9m1_fore_pawn_1, 5);
	thread (e9m1_objective_3_pawn_reinforce());
	thread (e9m1_objective_3_knight_reinforce());
end

script static void e9m1_objective_3_pawn_reinforce
	sleep_until (ai_living_count (e9m1_fore_pawn_1) <= 3, 1);
	ai_place (e9m1_fore_pawn_1, 4);
	sleep_until (ai_living_count (e9m1_fore_pawn_1) <= 2, 1);
	ai_place (e9m1_fore_pawn_1, 6);
	sleep_until (ai_living_count (e9m1_fore_pawn_1) <= 2, 1);
	print ("bringing in last pawns");
	ai_place (e9m1_fore_pawn_2, 5);
end

script static void e9m1_objective_3_knight_reinforce
	sleep_until (ai_living_count (gr_e9m1_fore_knights) <= 1, 1);
	print ("bringing in more knights");
	ai_place_in_limbo (e9m1_fore_knight_2);
	sleep_until (ai_living_count (gr_e9m1_fore_knights) <= 1, 1);
	print ("bringing in last knights");
	ai_place_in_limbo (e9m1_fore_knight_3);
	e9m1_defend();
end

script static void e9m1_defend
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	thread (f_e9_m1_event4_stop());
	b_end_player_goal = TRUE;

	object_create_folder (e9_m1_spawn_3);
	sleep_s (1);
	thread (vo_e9m1_closer_look());
	sleep(1);
	thread (f_new_objective (e9_m1_obj_4));
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	object_destroy_folder (e9_m1_spawn_2);
	sleep_s (3);



//	thread (power_up_turret_switches (dc_turret_left_switch));
//	thread (power_up_turret_switches (dc_turret_left_inside_switch));
//	thread (power_up_turret_switches (dc_turret_right_switch));
//	thread (power_up_turret_switches (dc_turret_right_inside_switch));
	thread (e9m1_defend_wave_1());
	sleep_until (LevelEventStatus ("heretheycome"), 1);
	defense_turret();
	vo_e9m1_turrets();
	thread (reactivateturrets());
end

script static void reactivateturrets
	sleep_until (ai_living_count (friendly_turrets) <= 3, 1);
	print ("you can reactivate them if you want");
	vo_e9m1_extradialog_04();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
end

script static void markpowersource_1
	object_create_anew (dc_power_source_1);
	navpoint_track_object_named(dc_power_source_1, "navpoint_goto");
end

script static void e9m1_defend_wave_1
	ai_place (e9m1_fore_pawn_def_3);
	sleep_s (7);
	ai_place (e9m1_fore_pawn_def_wall_1);
	vo_e9m1_prometheans();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	ai_place (e9m1_fore_pawn_def_1, 5);
	thread (f_e9_m1_event5_start());
	sleep_s (1);
	ai_place (e9m1_fore_pawn_def_2);

	notifylevel ("heretheycome");
	f_new_objective (e9_m1_obj_5);
	object_create_anew (dc_power_source_1);
	navpoint_track_object_named(dc_power_source_1, "navpoint_defend");
	sleep_until (ai_living_count (gr_e9m1_fore_pawns) <= 5, 1);
	thread (e9m1_knight_defend_wave_1());
	thread (e9_m1_pawn_respawn_loop());

end
	
script static void e9_m1_defend_end
	thread (f_e9_m1_event5_stop());
	object_destroy (dc_power_source_1);
	object_create_anew (dc_power_source_2);
	device_set_position (dc_power_source_2, 0);
	device_set_power (dc_power_source_2, 1);
	object_destroy_folder  (e9m1_fore_turret_switch);
	thread (f_e9_m1_event5_stop());
	b_defense_ended = true;
	vo_e9m1_power_up();
	b_end_player_goal = TRUE;
	f_new_objective (e9_m1_obj_6);
end

script static void e9m1_knight_defend_wave_1
	ai_place_in_limbo (e9m1_fore_knight_4);
	ai_place_with_birth (e9m1_fore_bishop_2);
	sleep_until (ai_living_count (e9m1_fore_knight_4) <= 0, 1);
	sleep_s (2);
	thread (vo_e9m1_hold_them_off());
	ai_place_in_limbo (e9m1_fore_knight_5);
	sleep_until (ai_living_count (e9m1_fore_knight_5) <= 0, 1);
	sleep_s (5);
	ai_place (e9m1_fore_bishop_flock);
	thread (vo_e9m1_weird());
	sleep_until (ai_living_count (e9m1_fore_bishop_flock) <= 2, 1);
	ai_place_in_limbo (e9m1_fore_knight_defend_final);
	ai_place (e9m1_fore_bishop_flock, 5);
	sleep_s (4);
	ai_place (e9m1_fore_pawn_def_3);
	sleep_s (8);
	ai_place (e9_m1_sent_1);
	sleep_s (6);
	thread (f_e9_m1_stinger_sentinel());
//	vo_e9m1_sentinels();
//	sleep(1);
//	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	vo_e9m1_allies();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	sleep_until (ai_living_count (e9_m1_ff_all) <= 0, 1);
	sleep_s (3);
	e9_m1_defend_end();
end

script static void e9_m1_pawn_flank_vo
	sleep_until (ai_living_count (e9m1_fore_pawn_def_wall_1) >= 1, 1);
	print ("pawns behind you");
	vo_e9m1_extradialog_02();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
end


script static void e9_m1_pawn_respawn_loop
	thread (e9_m1_pawn_flank_vo());
	local short pawns_spawned_e9m1 = 0;
	repeat
		if (ai_living_count (gr_e9m1_fore_pawns) <= 4) then
			begin_random_count (1)
				ai_place(e9m1_fore_pawn_def_1, 5);
				ai_place(e9m1_fore_pawn_def_2, 5);
				ai_place(e9m1_fore_pawn_def_wall_1, 5);
				ai_place(e9m1_fore_pawn_def_3, 5);
			end
			if game_difficulty_get_real() == "normal" then pawns_spawned_e9m1 = pawns_spawned_e9m1 + 3;
			elseif game_difficulty_get_real() == "easy" then pawns_spawned_e9m1 = pawns_spawned_e9m1 + 3;
			elseif game_difficulty_get_real() == "heroic" then pawns_spawned_e9m1 = pawns_spawned_e9m1 + 2;
			elseif game_difficulty_get_real() == "legendary" then pawns_spawned_e9m1 = pawns_spawned_e9m1 + 2;
			print ("counting pawn spawns");
			end
		end
	until (pawns_spawned_e9m1 == 6);
end
	

script static void e9m1_objective_4_final_activation
	sleep_until (LevelEventStatus ("e9_m1_final_activation"), 1);
//	sleep_until (device_get_position (dc_power_source_2) != 0);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_activate', dm_power_source, 1 ); //CONTROL PANEL AUDIO!
	device_set_position (dm_power_source, 1);
	object_dissolve_from_marker(dm_power_source, phase_out, panel);
	checksentinelcount();
	ai_place (e9_m1_sent_2);
//	cs_shoot_secondary_trigger (e9_m1_sentinels, true);
	object_destroy (dc_power_source_1);
	object_destroy (dc_power_source_2);
	sent_1 = 1;
	sent_2 = 1;
	sleep_s (1);
	vo_e9m1_follow_sentinels();
	thread (f_e9_m1_event6_start());
	f_blip_ai_cui (e9_m1_sentinels, "navpoint_generic");
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_beam_activate_mnde947', vortex_floaters, audio_center, 1 ); //AUDIO!
	sleep_s (11);
	commandscriptactivate();
	f_unblip_ai_cui (e9_m1_sentinels);
	object_create (e9m1_lz_4);
	navpoint_track_object_named(e9m1_lz_4, "navpoint_goto");
	sleep_s (8);
	pawns_shot = 1;
	sleep_s (4);
	thread (f_e9_m1_stinger_beam());
//	effect_new (environments\solo\m020\fx\beams\datacore_beam_on.effect, cutscene_flags_0);
	effect_new_on_object_marker (levels\dlc\ff152_vortex\fx\beams\datacore_beam_on.effect, beam_turbine, fx_beam);
	sleep_s (1);
//	effect_new (environments\solo\m020\fx\beams\cathedral_beam_on.effect, cutscene_flags_0);
	effect_new_on_object_marker  (levels\dlc\ff152_vortex\fx\beams\cathedral_beam_on.effect, beam_turbine, fx_beam);
	object_destroy (e9m1_lz_4);
	vo_Librarian_transmission();
	sleep(1);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	vo_e9m1_beam_on();
	sleep_s (2);
	sleep_until(b_e9m1_narrative_is_on == FALSE, 1);
	vo_e9m1_backup();
	f_new_objective (e9_m1_obj_7);
	thread (f_e9_m1_event6_stop());
	ai_place (squads_33);
	ai_cannot_die (squads_33, true);
	object_cannot_take_damage (ai_vehicle_get (squads_33.spawn_points_0));
	f_blip_ai_cui (squads_33, "navpoint_goto");	
	b_end_player_goal = TRUE;
	f_e9_m1_end_mission();
end

script static void testbeam_1
	print ("here comes the beam");
//	sleep_until (LevelEventStatus ("beam1"), 1);
//	effect_new_on_object_marker  (environments\solo\m020\fx\beams\cathedral_beam_on.effect, beam_turbine, fx_beam);
//	print ("do you see the beam?");
//
//	sleep_until (LevelEventStatus ("beam2"), 1);
//	effect_new_on_object_marker (environments\solo\m020\fx\beams\datacore_beam_on.effect, beam_turbine, fx_beam);
//	print ("do you see the beam 2?");
//
	sleep_until (LevelEventStatus ("beam3"), 1);
	effect_new (environments\solo\m020\fx\beams\datacore_beam_on.effect, cutscene_flags_0);
	print ("do you see the beam 3?");
	
	sleep_until (LevelEventStatus ("beam4"), 1);
	effect_new (levels\dlc\ff152_vortex\fx\beams\datacore_beam_on.effect, cutscene_flags_0);
	print ("do you see the beam 4?");

end

script static void checksentinelcount
	print ("checking sentinel count");
	ai_living_count (e9_m1_sent_1);
	if (ai_living_count (e9_m1_sent_1) == 0) then
	ai_place (e9_m1_sent_1, 4);
	elseif (ai_living_count (e9_m1_sent_1) == 1) then
	ai_place (e9_m1_sent_1, 3);
	elseif (ai_living_count (e9_m1_sent_1) == 2) then
	ai_place (e9_m1_sent_1, 2);
	elseif (ai_living_count (e9_m1_sent_1) == 3) then
	ai_place (e9_m1_sent_1, 1);
	elseif (ai_living_count (e9_m1_sent_1) >= 4) then
	print ("sentinel count and respawn complete");
	end
	print ("sentinel count and respawn complete");
end

script static void f_e9_m1_end_mission
	sleep_until (LevelEventStatus ("e9_m1_ending"), 1);
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.5);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end





script static void f_fore_turret_place (ai turret_spawn, device dc_switch, device dm_switch)
	ai_place (turret_spawn);
	repeat
	sleep_until(object_get_health(turret_spawn) <= 0.01);
	print ("defenses activating");	
	navpoint_track_object_named(dc_switch, "navpoint_activate");
	inspect (device_get_position (dc_switch));
	print ("what is my inition position");
	inspect (device_get_power (dc_switch));
	device_set_position (dm_switch, 0);
	device_set_power(dc_switch, 1);
	inspect (device_get_position (dc_switch));
	sleep_until (device_get_position (dc_switch) != 0);
	print ("position not 1");
	device_set_power(dc_switch, 0);
	device_set_position (dc_switch, 0);
	device_set_position (dm_switch, 1);
	f_unblip_object_cui(dc_switch);
	ai_place (turret_spawn);
	ai_set_team (turret_spawn, player);
	unit_set_maximum_vitality (turret_spawn, 400, 400);

//	local unit turret_object = ai_vehicle_get(turret_ai);
//	ai_object_set_team (turret_object, player);
	sleep_until(object_get_health(turret_spawn) <= 0.01);
	print ("turret destroyed – need to reactivate");
	sleep_s (5);

//	f_blip_object (dc_switch);s
	until (b_defense_ended == true, 1);
end

script static void power_up_turret_switches (device dc_switch)
	device_set_power (dc_switch, 1);
end

script static void defense_turret
	thread (f_fore_turret_place (friendly_turrets.turret_left, dc_turret_left_switch, dm_turret_left));
	thread (f_fore_turret_place (friendly_turrets.turret_right, dc_turret_right_switch, dm_turret_right));
	thread (f_fore_turret_place (friendly_turrets.turret_middle, dc_turret_right_inside_switch, dm_turret_right_inside));
	thread (f_fore_turret_place (friendly_turrets.turret_left_inside, dc_turret_left_inside_switch, dm_turret_left_inside));
end

script static void f_last_cov_callouts
	repeat
		print ("more enemies event");
		sleep_until (LevelEventStatus ("lastcovies"), 1);
		sleep_until (b_e9m1_narrative_is_on == FALSE, 1);
		b_e9m1_narrative_is_on = true;
		
//		if editor_mode() then
////			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo15_miller_few_more_01();
			vo_glo15_miller_few_more_02();
			vo_glo15_miller_few_more_03();
			vo_glo15_miller_few_more_04();
			vo_glo15_miller_few_more_05();
			vo_glo15_miller_few_more_06();
			vo_glo15_miller_few_more_07();
			vo_glo15_miller_few_more_08();
			vo_glo15_miller_few_more_09();
		end
		
		b_e9m1_narrative_is_on = false;
		f_blip_ai_cui (e9_m1_ff_all, "navpoint_enemy");
		
	until (b_game_ended == true);
end

script static void commandscriptactivate

	cs_run_command_script (e9_m1_sent_2.spawn_points_0, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_0, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_2.spawn_points_8, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_1, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_2.spawn_points_2, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_2, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_2.spawn_points_3, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_3, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_4, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_5, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_6, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_7, e9m1_sent_fire);
	cs_run_command_script (e9_m1_sent_1.spawn_points_8, e9m1_sent_fire);

end


	

	