//============================================ VALHALLA FIREFIGHT SCRIPT E3 M3========================================================
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


script startup breach_e10_m5

//Start the intro
	sleep_until (LevelEventStatus("e10_m5"), 1);
	switch_zone_set (e10_m5);
	ai_ff_all = e10_m5_ff_all;
	e10_m5_master_script();
	f_start_player_intro_e10_m5();
	
	
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================

//================================================== AI ==================================================================
//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_1;
//	
//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(dm_e10m5_scarab);										//UNSC crates and barriers around the dias
	f_add_crate_folder(dc_e10m5_scarab);										//UNSC crates and barriers around the dias
	f_add_crate_folder(e10m5_cov_encounter_1);										//UNSC crates and barriers around the dias
	
//set ammo crate names
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors

	
//set objective names
//	firefight_mode_set_objective_name_at(destroy_obj_1, 			1); //objective behind the dias


	
	firefight_mode_set_objective_name_at(e10m5_obj1, 	50); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(scarab_activation, 	51); //SA objective location: front pad of temple
	firefight_mode_set_objective_name_at(e10m5_obj3, 	52); //SA objective location: near middle of temple
	firefight_mode_set_objective_name_at(e10m5_obj4, 	53); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(e10m5_obj5, 	54); //SA objective location: on lower platform by ramp to upper level, leading to back of canyon
	firefight_mode_set_objective_name_at(door_activation, 	55); //SA objective location: entrance to canyon from valley
	firefight_mode_set_objective_name_at(fore_artifact, 	56); //SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(e10m5_obj8, 	57); //SA objective location: front of cayon into valley


//set squad group names
	firefight_mode_set_squad_at(e10_m5_cov_attack_1, 				1);	//BR: First Covenant encounter on the way to excavator.
//
//	
//	firefight_mode_set_squad_at(gr_waves_1, 						51); //SA: middle of mid level, near front of temple
//
//	firefight_mode_set_squad_at(gr_ff_waves, 			80);

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



//// ==============================================================================================================
//// ====== PELICAN COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

script command_script cs_ff_e10_m5_pelican01
	cs_ignore_obstacles (TRUE);
	ai_cannot_die (ai_current_squad, TRUE);
	sleep (1);
//	cs_fly_to (pelican_01.p0);
	cs_fly_by (pelican_01.p1); 
	cs_fly_by (pelican_01.p2); 
	cs_fly_by (pelican_01.p3);
	cs_fly_to_and_face (pelican_01.p4, pelican_01.p5);
	sleep_until (volume_test_players (trigger_volumes_0), 1);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
  sleep (90);
	b_end_player_goal = TRUE;
	player_camera_control (false);
	player_enable_input (FALSE);
end

//// ==============================================================================================================
//// ====== AI COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

script command_script cs_ff_e10m5_hunter_1()
	sleep_until (volume_test_players (trigger_volumes_1), 1);
	cs_shoot_point (true, hunter_shoot.p0);
	ai_set_objective (e10m5_hunter_right, e10m5_cov_2);
end

script command_script cs_ff_e10m5_hunter_2()
	sleep_until (volume_test_players (trigger_volumes_1), 1);
	cs_shoot_point (true, hunter_shoot.p1);
	ai_set_objective (e10m5_hunter_left, e10m5_cov_2);
end

script command_script forerunner_squads_0
	cs_phase_in();
end

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
// ====== E10_M5_BREACH==============================================================================
// ==============================================================================================================

global boolean b_wait_for_narrative = false;
global boolean e10m5_narrative_is_on = FALSE;

//script static void f_start_player_intro
//	print ("start player intro");
//	firefight_mode_set_player_spawn_suppressed(false);
////	f_e3_m3_start();
////	print ("guards_1 spawn");
//end

script static void f_start_player_intro_e10_m5
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
//		intro_vignette_e3_m3();
//		b_wait_for_narrative = false;
//		firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
		intro_vignette_e10_m5();
	end
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e10_m5
	print ("_____________starting vignette__________________");
//
//	
//	//sleep_s (8);
//	b_wait_for_narrative = true;
//	cinematic_start();
//	pup_play_show (e3_m3_intro);
//	wake (e3m3_vo_intro);
//	sleep_s (15);
//	cinematic_stop();
//	sleep_s (0.5);
//	switch_zone_set (e3_m3);
//	fade_in (0,0,0,30);
	// start VO
//thread (vo_e3m3_intro());
	
// wait until the puppeteer is complete
//	sleep_until (b_wait_for_narrative == false);
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);


end

script static void f_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end



script static void e10_m5_master_script

	thread (e10_m5_master_story());
	print ("Hello. Here is our story.");
	
	thread (e10_m5_covenant_spawn());
	print ("digger exterior and interior spawns");
	
	thread (e10_m5_all_cov_dead());
	print ("hide button till all dead");
	
	thread (e10_m5_zone_switch());
	print ("prepped for switching zone sets");
	
	thread (e10_m5_promethean_01());
	print ("uh oh, you woke up prometheans");
	
	thread (e10_m5_all_prom_dead());
	print ("uh oh, you woke up prometheans");
	
	thread (e10_m5_powerupdoor());
	print ("need to open the door");
	
	thread (e10_m5_doorisopen());
	print ("door is open, now kick open the artifact");
	
	thread (e10_m5_gettotheplane());
	print ("spartans, leave");
	
end

script static void e10_m5_master_story
	sleep_until (b_players_are_alive(), 1);
	print ("Get to the Digger");
	f_new_objective (e10_m5_objective_1);
	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
	f_digger_hole_damage();
	f_new_objective (e10_m5_objective_4);
end

script static void e10_m5_covenant_spawn
	sleep_until (ai_living_count (e10_m5_ff_all) >= 15, 1);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 15, 1);
	ai_place (e10m5_cov_05);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 13, 1);
	ai_place (e10m5_hunter_left);
	ai_place (e10m5_hunter_right);
	ai_place (e10m5_elites_digger);
end

script static void e10_m5_all_cov_dead
	sleep_until (LevelEventStatus ("alldead"), 1);
	b_wait_for_narrative_hud = true;
	object_create (e10m5_obj2);
	navpoint_track_object_named(e10m5_obj2, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_2), 1); 
	object_destroy (e10m5_obj2);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	f_new_objective (e10_m5_objective_2);
	b_wait_for_narrative_hud = false;
	device_set_power (scarab_control, 1);

end

script static void f_digger_hole_damage
	print ("prepare damage");
	damage_object (hole_1, default, 1000);
	
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_2);
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_1);
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_0);
	print ("damage unleashed");
end

script static void e10_m5_zone_switch
	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
	prepare_to_switch_to_zone_set(e10_m5_interior);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e10_m5_interior);
	current_zone_set_fully_active();
	print ("switched zone sets");
end

script static void e10_m5_promethean_01
	sleep_until (volume_test_players (trigger_volumes_3), 1);
	ai_place_in_limbo (knight_guard01);
	sleep_until (volume_test_players (trigger_volumes_4), 1);
	ai_place_in_limbo (crawler_guard02);
	sleep_until (ai_living_count (crawler_guard02) <= 3, 1);
	ai_place_in_limbo (crawler_guard02);
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	ai_place (knight_guard02);
end

script static void e10_m5_all_prom_dead
	sleep_until (LevelEventStatus ("allpromdead"), 1);
		f_new_objective (e10_m5_objective_5);
	
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	object_create (e10m5_obj5);
	navpoint_track_object_named(e10m5_obj5, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_6), 1); 
	object_destroy (e10m5_obj5);

	f_new_objective (e10_m5_objective_6);
	b_end_player_goal = TRUE;
	b_wait_for_narrative_hud = false;
end

script static void e10_m5_powerupdoor
	sleep_until (LevelEventStatus ("openthedoorboss"), 1);
	object_create (e10m5_obj6);
	navpoint_track_object_named(e10m5_obj6, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_7), 1); 
	object_destroy (e10m5_obj6);
	object_create (e10m5_obj6_1);
	navpoint_track_object_named(e10m5_obj6_1, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_8), 1); 
	object_destroy (e10m5_obj6_1);
	ai_place (knight_guard_3);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	b_end_player_goal = TRUE;
	sleep_s (2);
	b_wait_for_narrative_hud = false;
	device_set_power (door_control, 1);
end

script static void e10_m5_doorisopen
	sleep_until (LevelEventStatus ("doorisopenboss"), 1);
	object_create (e10m5_obj7);
	navpoint_track_object_named(e10m5_obj7, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_6), 1); 
	object_destroy (e10m5_obj7);
	sleep_s (1);
	f_new_objective(e10_m5_objective_7);
	b_end_player_goal = TRUE;
	device_set_power (fore_artifact, 1);
end


script static void e10_m5_gettotheplane
	sleep_until (LevelEventStatus ("gettheheckoutofdodge"), 1);
	f_new_objective(e10_m5_objective_8);
	camera_shake_all_coop_players (.8, .8, 6, 1.8);
	sleep_until (volume_test_players (trigger_volumes_3), 1);
	ai_place (squads_13);
end

	