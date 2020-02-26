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


script startup valhalla_e3_m3

//Start the intro
	sleep_until (LevelEventStatus("e3_m3"), 1);
	switch_zone_set (e3_m3_intro);
	mission_is_e3_m3 = true;
	ai_ff_all = e3_m3_ff_all;
	thread(f_music_e3m3_start());
	thread(f_start_player_intro_e3_m3());
	thread(valhalla1_loadfriendlies());
	thread(e3_m3_master_script());
	
	
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
	f_add_crate_folder(cr_destroy_unsc_cover);										//UNSC crates and barriers around the dias
	f_add_crate_folder(unsc_ammo);		
	f_add_crate_folder(cr_destroy_cov_cover);										//cov crates all around the main area
	f_add_crate_folder(e3_m3_baseshields);		
//	firefight_mode_set_crate_folder_at(dm_destroy_shields, 				3); //barriers that prevent getting behind the dias and to the large back middle area
//	firefight_mode_set_crate_folder_at(cr_power_core, 						4); //crates that blow up behind the dias
//	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 			5);  //UNSC barriers 
//	firefight_mode_set_crate_folder_at(cr_capture, 								6); //Cov crates 
//	firefight_mode_set_crate_folder_at(v_e2_m4_pelican, 					7); //SA: pelican for the crash
	f_add_crate_folder(eq_e3_m3_unsc_ammo); 											//SA: e1_m4 ammo boxes
	f_add_crate_folder(wp_power_weapons);												//power weapons spawns in the main area
	f_add_crate_folder(wp_cov_weapons); 													//SA: covey props for e2_m4
//	firefight_mode_set_crate_folder_at(cr_barriers, 							12); // nothing at the moment
//	firefight_mode_set_crate_folder_at(cr_destroy_shields, 				13); //barrier that prevent players from falling off the end of the large tunnel\
//	//firefight_mode_set_crate_folder_at(v_ff_for_d_turrets, 			14); //forerunner turrets
//	//firefight_mode_set_crate_folder_at(cr_f_temple_props, 			15); //various forerunner props all over the temple
//	//firefight_mode_set_crate_folder_at(dm_temple_props, 				16); //the large forerunner towers in the temple
	f_add_crate_folder(dm_f_shields_2);													//shields blocking the exit for ESCAPE
	f_add_crate_folder(dm_drop_rails);	
  //firefight_mode_set_crate_folder_at(cr_destroy_temple_props,	19); //
	f_add_crate_folder(cr_e3_m3_temple_props);										// SA: props for snipper alley destroy, random forerunner spires and stuff
  f_add_crate_folder(e3_m3_forerunner_shield_switch);
 
//  firefight_mode_set_crate_folder_at(cr_e2_m4_temple_props, 		22); // SA: temple props for Run
  f_add_crate_folder(dc_capture_1);																// SA: temple props for Run
//  f_add_crate_folder(dm_e3_m3_shields_1);											// shields blocking the middle
//  f_add_crate_folder(dm_e3_m3_shields_2);											// shields blocking the bridge
  f_add_crate_folder(dm_e3_m3_drop_rails);
  f_add_crate_folder(v_ff_cov_ghosts);
	
//set ammo crate names
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e3_m3_spawn_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(e3_m3_spawn_1, 91); //SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(e3_m3_spawn_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(e3_m3_spawn_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(e3_m3_spawn_4, 94); //SA Spawn location: in valley, facing into canyon
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //SA Spawn location: in middle of the canyon, facing towards temple
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //SA Spawn location: back of temple, middle, as a group
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //SA Spawn location: near end of valley to cayon, facing into valley
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //SA Spawn location: middle of the valley, facing towards the canyon
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
	firefight_mode_set_crate_folder_at(spawn_points_10, 100); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple	
	
//set objective names
//	firefight_mode_set_objective_name_at(destroy_obj_1, 			1); //objective behind the dias
//	firefight_mode_set_objective_name_at(destroy_obj_2, 			2); //on the dias
//	firefight_mode_set_objective_name_at(destroy_obj_3, 			3); //in the tunnel
//	firefight_mode_set_objective_name_at(defend_obj_1, 				4); //objective in the tunnel
//	firefight_mode_set_objective_name_at(defend_obj_2, 				5); //objective in the tunnel
//	firefight_mode_set_objective_name_at(capture_obj_0, 			6); //objective in the tunnel
//	firefight_mode_set_objective_name_at(power_core, 					7); //on the dias
//	firefight_mode_set_objective_name_at(capture_obj_1, 			9); //objective on the dias
//	firefight_mode_set_objective_name_at(objective_switch_1, 	10); //SA switch location: in the middle, but the bridge
//	firefight_mode_set_objective_name_at(defend_obj_3, 				11); //objective in the back, behind the dias
//	firefight_mode_set_objective_name_at(defend_obj_4, 				12); //objective in the back, behind the dias
//	firefight_mode_set_objective_name_at(capture_obj_2, 			18); //objective on the walkway
//	firefight_mode_set_objective_name_at(objective_switch_2, 	19); //SA switch location: side square open platform, main level
	firefight_mode_set_objective_name_at(capture_obj_3, 			20); //in the leftside room
//	firefight_mode_set_objective_name_at(objective_switch_3, 	21); //SA switch location: upper front platform
	firefight_mode_set_objective_name_at(water_base_shield_switch0, 	22); //SA switch location: in the valley
	firefight_mode_set_objective_name_at(water_base_shield_switch, 	23); //VH switch location: water base shield switch
	firefight_mode_set_objective_name_at(cov_signal_jammer, 	24); //VH object destruction: cov signal jammer
	firefight_mode_set_objective_name_at(fore_water_base_thing, 	25); //VH switch location: water base shield switch
	firefight_mode_set_objective_name_at(cov_signal_jammer2, 	26); //VH object destruction: cov signal jammer

	
	firefight_mode_set_objective_name_at(lz_0, 	50); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(lz_1, 	51); //SA objective location: front pad of temple
	firefight_mode_set_objective_name_at(lz_2, 	52); //SA objective location: near middle of temple
	firefight_mode_set_objective_name_at(lz_3, 	53); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(lz_4, 	54); //SA objective location: on lower platform by ramp to upper level, leading to back of canyon
	firefight_mode_set_objective_name_at(lz_5, 	55); //SA objective location: entrance to canyon from valley
	firefight_mode_set_objective_name_at(lz_6, 	56); //SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(lz_7, 	57); //SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(lz_8, 	58); //SA objective location: middle of the valley
	firefight_mode_set_objective_name_at(lz_9, 	59); //SA objective location: bottom of the ramp, towards the back of the temple
	firefight_mode_set_objective_name_at(lz_10, 60); //SA objective location: lower bend in the canyon
	firefight_mode_set_objective_name_at(lz_11, 61); //SA objective location: upper bend in the canyon

//set squad group names
	firefight_mode_set_squad_at(gr_ff_guards_1, 				1);	//VA: Rock perch in the front of water base
	firefight_mode_set_squad_at(gr_ff_guards_2, 				2);	//SA: mid level back of temple
	firefight_mode_set_squad_at(gr_ff_guards_3, 				3);	//SA: back of main level of temple
	firefight_mode_set_squad_at(gr_ff_guards_4, 				4); //SA: Side square platform
	firefight_mode_set_squad_at(gr_ff_guards_5, 				5); //SA: Upper level, front of platform
	firefight_mode_set_squad_at(gr_ff_guards_6, 				6); //SA: front of temple
	firefight_mode_set_squad_at(gr_ff_guards_7, 				7);	//SA: front entrance of temple before bridge
	firefight_mode_set_squad_at(gr_ff_guards_8, 				8);	//SA: Top of canyon
	firefight_mode_set_squad_at(gr_ff_guards_9, 				9); //SA: Middle of canyon
	firefight_mode_set_squad_at(gr_ff_guards_10, 				10); //SA: Bottom of temple
	firefight_mode_set_squad_at(gr_ff_guards_11, 				11); //SA: Top level right side
	firefight_mode_set_squad_at(gr_ff_guards_12, 				12); //SA: Top level left side
	firefight_mode_set_squad_at(gr_ff_attack_squad_a, 	13); //Next to 11, special AI tied to it
	firefight_mode_set_squad_at(gr_ff_attack_squad_b, 	14); //Next to 12, special AI tied to it
	firefight_mode_set_squad_at(gr_ff_guards_15, 				15); //SA: near entrance to canyon
	firefight_mode_set_squad_at(gr_ff_guards_16, 				16); //SA: canyon
	firefight_mode_set_squad_at(gr_ff_guards_17, 				17); //SA: canyon
	firefight_mode_set_squad_at(gr_ff_guards_18_tank, 	18); //SA: canyon, near tank, for destroy
	firefight_mode_set_squad_at(gr_ff_guards_19_tower, 	19); //SA: canyon, near tower 1, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_01,				20); //SA: canyon, near tower 2, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_02, 			21); //SA: canyon, middle
	firefight_mode_set_squad_at(gr_ff_guards_22, 				22); //SA: middle of mid level, near back of temple
	firefight_mode_set_squad_at(gr_ff_guards_23, 				23); //SA: middle of mid level, near front of temple
	
	firefight_mode_set_squad_at(gr_waves_1, 						51); //SA: middle of mid level, near front of temple

	firefight_mode_set_squad_at(gr_ff_waves, 			80);
	firefight_mode_set_squad_at(gr_ff_waves_1, 		81);
	firefight_mode_set_squad_at(gr_ff_waves_2, 		82);
	firefight_mode_set_squad_at(gr_ff_waves_3, 		83);
	firefight_mode_set_squad_at(gr_ff_waves_4, 		84);
	firefight_mode_set_squad_at(gr_ff_waves_5, 		85);
	firefight_mode_set_squad_at(gr_ff_waves_6, 		86);

	
	firefight_mode_set_squad_at(gr_ff_allies_1, 71); //tunnel
	firefight_mode_set_squad_at(gr_ff_allies_2,	72); //behind the dias
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


//
//// ==============================================================================================================
//// ====== PELICAN COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================


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
// ====== E3_M3_Valhalla==============================================================================
// ==============================================================================================================

global boolean b_wait_for_narrative = false;
global boolean e3m3_narrative_is_on = FALSE;
global short e3_m3_last_objective = 0;

//script static void f_start_player_intro
//	print ("start player intro");
//	firefight_mode_set_player_spawn_suppressed(false);
////	f_e3_m3_start();
////	print ("guards_1 spawn");
//end

script static void f_start_player_intro_e3_m3
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
//		intro_vignette_e3_m3();
//		b_wait_for_narrative = false;
//		firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
		intro_vignette_e3_m3();
	end
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e3_m3
	print ("_____________starting vignette__________________");
	thread(f_music_e3m3_vignette_2_start());
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m3_vin_sfx_intro', NONE, 1);
	
	//sleep_s (8);
	b_wait_for_narrative = true;
	cinematic_start();
	pup_play_show (e3_m3_intro);
	wake (e3m3_vo_intro);
	sleep_s (15);
	cinematic_stop();
	sleep_s (0.5);
	switch_zone_set (e3_m3);
	fade_in (0,0,0,30);
	// start VO
//thread (vo_e3m3_intro());
	
// wait until the puppeteer is complete
//	sleep_until (b_wait_for_narrative == false);
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	thread(f_music_e3m3_vignette_2_finish());

end

script static void f_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end

//script static void f_e3_m3_start
//	sleep_until (ai_living_count (guards_1) > 0, 1);	
//	ai_place (guards_1);
//	print ("guards_1 spawn");
//end

script static void e3_m3_master_script
	
//	thread (valhalla1_loadfriendlies());
//	print ("initial mission spawns");
	
	thread (clear_crash_site());
	print ("Help save Mountain");
	
	thread (elitesattack());
	print ("Elites Attack");
	
	thread (drop_cov_jammer_shield());
	print ("Drop the shield");
	
	thread (f_e3_m3_switches());
	print ("Second Drop Pod inbound");
	
	thread (f_e3_m3_drop_3());
	print ("Finish Mountain's mission");
	
	thread (destroy_water_base_shield());
	print ("Finish Mountain's mission");
	
	thread (grab_fore_item());
	print ("Shields are down");
	
	thread (end_e3_m3_event());
	print ("Tower goes boom");
	
	thread (f_power_up_switches());
	print ("Switches work now");
	
	thread (e3m3_watchtower());
	print ("Turn off grav lift if blown up.");
	
	thread (f_cov_callouts());
	print ("Finish the Covies");
	
	thread (f_drop_pod_callouts());
	print ("Drop pods inbound");
	
end



script static void valhalla1_loadfriendlies
	sleep_until (LevelEventStatus ("loadfriendlies"), 1);
	thread(f_music_e3m3_loadfriendlies());
	ai_place (sq_ff_marines_1);
	sleep_until (ai_living_count (guards_1) > 0, 1);	
	ai_place (guards_1);
	ai_cannot_die (sq_ff_marines_1, TRUE); 
//	cinematic_set_title (objective_1);
	print ("objective_1");
	sleep_until (firefight_players_dead() == false);
	object_set_function_variable (covenant_jammer_shield, "shield_on", 1, 0.5);
	kill_volume_disable (kill_volumes_8);
	thread (cov_jammer_power());
		print ("Dont let us shoot our jammer.");
	object_set_scale (fore_tower_2, .5, 1);
	object_set_scale (fore_tower_1, .5, 1);
	object_cannot_take_damage (fore_tower_1);
	object_cannot_take_damage (fore_tower_2);
	object_create (lz_3);
	f_new_objective (e3_m3_objective_1);
	thread(f_music_e3m3_playstart_vo_start());

	wake (e3m3_vo_playstart);
//	hud_play_pip_from_tag (bink\PiP_SO_PALMER_EP1_1);
	sleep_s (3);
	navpoint_track_object_named(lz_3, "navpoint_goto");
	thread(f_music_e3m3_playstart_vo_finish());
	sleep_s (4);
	thread(f_music_e3m3_topelican_vo());
	wake (e3m3_vo_topelican);
	sleep_until (volume_test_players (e3_m3_trigger_0), 1); 
	b_end_player_goal = TRUE;
	object_destroy (lz_3);
	sleep_forever();
end

script static void clear_crash_site
	sleep_until (LevelEventStatus ("clear_crash_site"), 1);
	thread(f_music_e3m3_clear_crash_site());
	b_wait_for_narrative_hud = true;
	wake (e3m3_vo_atpelican);
	sleep_s (4);
		print ("objective_2");
	f_new_objective (e3_m3_objective_2);
//	wake (e3m3_vo_clearsite);
	//Clear the crash site of hostiles.
	sleep_until (ai_living_count (e3_m3_ff_all) <= 9);
	ai_place_in_limbo (guards_7);
	sleep_s (2);
	thread (f_load_drop_pod (dm_drop_03, guards_7, drop_pod_lg_01, false));
	sleep_s (6);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 7);
	thread(f_music_e3m3_savedmarines_vo());
	wake (e3m3_vo_savedmarines);
		sleep_s (1);
		sleep_until (e3m3_narrative_is_on == FALSE);
	thread(f_music_e3m3_getcovloot_vo());
	wake (e3m3_vo_getcovloot);
		sleep_s (1);
		sleep_until (e3m3_narrative_is_on == FALSE);
	
	sleep_until (ai_living_count (e3_m3_ff_all) <= 7);
	wake (e3m3_vo_targetshield);
		sleep_s (1);
		sleep_until (e3m3_narrative_is_on == FALSE);
	f_new_objective (e3_m3_objective_3);
	thread(f_music_e3m3_targetshield_vo());		
	b_wait_for_narrative_hud = false;
	sleep_s (4);
	notifylevel ("e3_m3_switch_1");
	ai_cannot_die (sq_ff_marines_1, FALSE);
	ai_set_objective (sq_ff_marines_1, obj_marines_follow);
	//Take down the Covenant shields and destroy the Communications Jammer.
end

script static void drop_cov_jammer_shield
	sleep_until (LevelEventStatus ("drop_cov_jammer_shield"), 1);
	print ("animating device");
	sleep_until (device_get_position (dm_e3_m3_cov_switch) == 1, 1);
	device_set_power (dm_e3_m3_cov_switch, 0);
	object_hide (dm_e3_m3_cov_switch, true);
	thread(f_music_e3m3_drop_cov_jammer_shield());
//	ai_place (guards_6);
	sleep_s (1);
//	ai_set_task (guards_6.spawn_points_0, obj_guards_5, sniper);
	thread(f_music_e3m3_shieldsdown_vo());
	wake (e3m3_vo_shieldsdown);
	object_set_function_variable (covenant_jammer_shield, "shield_on", 0, 0.5);
	sleep_s (.5);
	object_destroy (covenant_jammer_shield);
	print ("objective_4");
	f_new_objective (e3_m3_objective_4);
	thread(f_music_e3m3_destroyjammers_vo());
	wake (e3m3_vo_destroyjammers);
	ai_set_objective (e3_m3_ff_all, obj_guard_16);
	//Destroy the Jammer!

end


script static void f_e3_m3_switches
	sleep_until (LevelEventStatus ("f_e3_m3_switches"), 1);
	thread (f_music_e3m3_one_jammer_down());
	print ("one jammer down");
	sleep_s (7);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 5);
	ai_place_in_limbo (guards_17);
	
	thread (f_load_drop_pod (dm_drop_05, guards_17, drop_pod_lg_05, false));
	b_wait_for_narrative_hud = true;
	print ("objective_5");
	
	b_wait_for_narrative_hud = false;	
	
	//Figure out how to bring down the Forerunner Base defenses.
	sleep_forever();
end

script static void f_e3_m3_drop_3
	sleep_until (LevelEventStatus ("f_e3_m3_drop_3"), 1);
	sleep_s (1);
	ai_set_objective (e3_m3_ff_all, obj_guard_16);
	object_set_velocity (ai_get_object (squads_54.sniper_tower), 1, 1, 7);
	thread(f_music_e3m3_two_jammer_down());
	wake (e3m3_vo_2jammerdown);
	sleep_s (2);
	
		if (ai_living_count (sq_ff_marines_1) >= 1) then
			thread(f_music_e3m3_marinesalive_vo());
			wake (e3m3_vo_marinesalive);
			sleep_s (1);
			
		elseif (ai_living_count (sq_ff_marines_1) == 0) then
			thread(f_music_e3m3_marinesdead_vo());
			wake (e3m3_vo_marinesdead);
			sleep_s (1);
		end
	
	sleep_until (e3m3_narrative_is_on == FALSE);	
	thread(f_music_e3m3_findcontrols_vo());
	wake (e3m3_vo_findcontrols);
	print ("watch out");
	sleep_until (ai_living_count (e3_m3_ff_all) <= 5, 1);	 
	ai_place_in_limbo (e3_m3_drop_pod_3);
	sleep_s (1);
	thread (f_load_drop_pod (dm_drop_02, e3_m3_drop_pod_3, drop_pod_lg_03, false));
	sleep_s (10);
	b_end_player_goal = TRUE;
//	thread (one_down_vo());
end

script static void light_up_shields
	f_new_objective (e3_m3_objective_5);
	e3_m3_last_objective = 1;
	object_create (lz_5);
	navpoint_track_object_named(lz_5, "navpoint_goto");
	sleep_s (8);
	sleep_until (volume_test_players (e3_m3_waterfall_tower), 1);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 6, 1);
	sleep_s (2);
	object_destroy (lz_5);	
	kill_volume_enable (kill_volumes_8);
	sleep_s (5);
	kill_volume_disable (kill_volumes_8);
end

script static void drop_pod_test
	ai_place_in_limbo (e3_m3_drop_pod_3);
	sleep_s (1);
	f_load_drop_pod (dm_drop_02, e3_m3_drop_pod_3, drop_pod_lg_03, false);
	print ("Are they here?");
end

script static void one_down_vo
	sleep_until (s_all_objectives_count == 1);
	e3_m3_switch1();
end

script static void destroy_water_base_shield
	sleep_until (LevelEventStatus ("destroy_water_base_shield"), 1);
	print ("objective_6");
	sleep_s (1);
	object_dissolve_from_marker (waterfall_base_shield, phase_out, derrez);
	object_dissolve_from_marker (waterfall_mancannon_cap, phase_out, dissolve_mkr);
	sleep_s (.5);
	object_dissolve_from_marker (waterfall_base_glass, phase_out, dissolve_mkr);
	sleep_s (3);
	object_destroy (waterfall_base_shield);
	object_destroy (waterfall_base_glass);
	object_destroy (waterfall_mancannon_cap);
	sleep_s (1);
	ai_place (real_guards_50);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 6, 1);
	ai_place (sq_ff_phantom_12);
	//Flip the switch to power down the Forerunner shield.
	sleep_s(3);
	notifylevel ("more_phantoms");
end
	
script static void grab_fore_item
	sleep_until (LevelEventStatus ("grab_fore_item"), 1);
	thread(f_music_e3m3_shielddown2());
	sleep_s (2);
	wake (e3m3_vo_shielddown2);
	sleep_s (1);
	sleep_until (e3m3_narrative_is_on == FALSE);
	print ("objective_7");
	thread(f_music_e3m3_entertower_vo());
	wake (e3m3_vo_entertower);
	sleep_s (2);
	object_create (lz_6);
	navpoint_track_object_named(lz_6, "navpoint_goto");
	sleep_until (volume_test_players (e3_m3_back_base), 1);
	sleep_s (5);
	object_destroy (lz_6);
	thread(f_music_e3m3_halsey_vo());
	sleep_s (2);
	wake (e3m3_vo_halsey);
	b_end_player_goal = TRUE;
	b_wait_for_narrative_hud = true;
	sleep_s (1);
	sleep_until (e3m3_narrative_is_on == FALSE);
	thread(f_music_e3m3_activatetech_vo());
	wake (e3m3_vo_activatetech);
	sleep_s (1);
	sleep_until (e3m3_narrative_is_on == FALSE);
		//Grab the Forerunner doohickey.
end

script static void end_e3_m3_event
	sleep_until (LevelEventStatus ("end_e3_m3_event"), 1);
	thread(f_music_e3m3_end_event());
	print ("level_clear_1");
	wake (vo_e3m3_glo_powersource);
	sleep_s (1);
	sleep_until (e3m3_narrative_is_on == FALSE);
//	device_set_power (waterfall_base_activation, 1);
//	device_set_position (waterfall_base_activation, 1);
	thread(start_camera_shake_loop ("heavy", "short"));
	f_new_objective (e3_m3_level_clear_1);
	sleep_s (2);
	object_create (lz_7);
	object_create (lz_8);
	navpoint_track_object_named(lz_7, "navpoint_goto");
	navpoint_track_object_named(lz_8, "navpoint_goto");
	print ("This should stop shaking");
	sleep_until ((volume_test_players (e3_m3_exit_base)) or
		(volume_test_players (e3_m3_exit_base_2)) or
		(volume_test_players (e3_m3_exit_base_3)) or
		(volume_test_players (e3_m3_exit_base_4)), 1);
	print ("Am I shaking");
	object_destroy (lz_7);
	object_destroy (lz_8); 
	thread(f_music_e3m3_lightshow_vo());
	wake (e3m3_vo_lightshow);
	object_create_anew (lightshow);
	navpoint_track_object_named(lightshow, "navpoint_generic");
	thread (player_stare());
	sleep_s (2);
	effect_new (environments\multi\valhalla\fx\valhalla_tower_beam.effect, cutscene_flags_waterfall_tower_pulse);
	stop_camera_shake_loop();
	object_destroy (lightshow);
	sleep_until (LevelEventStatus ("ending_battle_over"), 1);
	object_create (lz_3);
	navpoint_track_object_named(lz_3, "navpoint_goto");
	sleep_until (volume_test_players (e3_m3_end_mission), 1);
	sleep_s (3);
	sleep_until (e3m3_narrative_is_on == FALSE);
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	b_end_player_goal = TRUE;
	//thread(f_music_e3m3_finish());
	f_e3_m3_end_mission();

	//You MUST hold out until we can get reinforcements to you.
end

script static void f_e3_m3_end_mission

	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.5);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end



script static void player_stare
	if volume_test_objects (e3_m3_exit_base, player0) and player_valid(player0) then
		player_control_lock_gaze(player0, e3_m3_look_tower.p0, 240);
		camera_control (player0, FALSE);
		player_disable_movement (player0, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base, player1) and player_valid(player1) then
		player_control_lock_gaze(player1, e3_m3_look_tower.p0, 240);
		camera_control (player1, FALSE);
		player_disable_movement (player1, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base, player2) and player_valid(player2) then
		player_control_lock_gaze(player2, e3_m3_look_tower.p0, 240);
		camera_control (player2, FALSE);
		player_disable_movement (player2, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base, player3) and player_valid(player3) then
		player_control_lock_gaze(player3, e3_m3_look_tower.p0, 240);
		camera_control (player3, FALSE);
		player_disable_movement (player3, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_2, player0) and player_valid(player0) then
		player_control_lock_gaze(player0, e3_m3_look_tower.p0, 240);
		camera_control (player0, FALSE);
		player_disable_movement (player0, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_2, player1) and player_valid(player1) then
		player_control_lock_gaze(player1, e3_m3_look_tower.p0, 240);
		camera_control (player1, FALSE);
		player_disable_movement (player1, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_2, player2) and player_valid(player2) then
		player_control_lock_gaze(player2, e3_m3_look_tower.p0, 240);
		camera_control (player2, FALSE);
		player_disable_movement (player2, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_2, player3) and player_valid(player3) then
		player_control_lock_gaze(player3, e3_m3_look_tower.p0, 240);
		camera_control (player3, FALSE);
		player_disable_movement (player3, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_3, player0) and player_valid(player0) then
		player_control_lock_gaze(player0, e3_m3_look_tower.p0, 240);
		camera_control (player0, FALSE);
		player_disable_movement (player0, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_3, player1) and player_valid(player1) then
		player_control_lock_gaze(player1, e3_m3_look_tower.p0, 240);
		camera_control (player1, FALSE);
		player_disable_movement (player1, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_3, player2) and player_valid(player2) then
		player_control_lock_gaze(player2, e3_m3_look_tower.p0, 240);
		camera_control (player2, FALSE);
		player_disable_movement (player2, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_3, player3) and player_valid(player3) then
		player_control_lock_gaze(player3, e3_m3_look_tower.p0, 240);
		camera_control (player3, FALSE);
		player_disable_movement (player3, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_4, player0) and player_valid(player0) then
		player_control_lock_gaze(player0, e3_m3_look_tower.p0, 240);
		camera_control (player0, FALSE);
		player_disable_movement (player0, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_4, player1) and player_valid(player1) then
		player_control_lock_gaze(player1, e3_m3_look_tower.p0, 240);
		camera_control (player1, FALSE);
		player_disable_movement (player1, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_4, player2) and player_valid(player2) then
		player_control_lock_gaze(player2, e3_m3_look_tower.p0, 240);
		camera_control (player2, FALSE);
		player_disable_movement (player2, TRUE);
	end
	if volume_test_objects (e3_m3_exit_base_4, player3) and player_valid(player3) then
		player_control_lock_gaze(player3, e3_m3_look_tower.p0, 240);
		camera_control (player3, FALSE);
		player_disable_movement (player3, TRUE);
	end
	sleep_s (2);
	if player_valid(player0) then
		player_control_unlock_gaze (player0);
		player_camera_control (TRUE);
		player_disable_movement (player0, FALSE);
	end
	if player_valid(player1) then
		player_control_unlock_gaze (player1);
		player_camera_control (true);
		player_disable_movement (player1, FALSE);
	end
	if player_valid(player2) then
		player_control_unlock_gaze (player2);
		player_camera_control (true);
		player_disable_movement (player2, FALSE);
	end
	if player_valid(player3) then
		player_control_unlock_gaze (player3);
		player_camera_control (true);
		player_disable_movement (player3, FALSE);
	end
end

//b_end_player_goal = TRUE;

script static void enemies_dead
	ai_place_in_limbo (guards_final);
	notifylevel ("drop_pods_yo");
	thread (f_load_drop_pod (dm_drop_01, guards_final, drop_pod_lg_05, false));
	navpoint_track_object_named(drop_pod_lg_05, "navpoint_enemy_vehicle");
	sleep_s (7);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 5, 1);
	f_blip_ai_cui(e3_m3_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e3_m3_ff_all) <= 0, 1);
	sleep_s (2);
	notifylevel ("ending_battle_over");	
end

script static void enemies_dead_1
	sleep_s (7);
	sleep_until (ai_living_count (e3_m3_ff_all) <= 5, 1);
	print ("Global VO Needed ");
	sleep_s (1);
	notifylevel ("last_covies1");
	f_blip_ai_cui(e3_m3_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e3_m3_ff_all) <= 0, 1);
	sleep_s (2);
end
	
script static void f_drop_pod_callouts
	repeat
		sleep_until (LevelEventStatus("drop_pods_yo"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
////			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_droppod_01();
			vo_glo_droppod_02();
			vo_glo_droppod_03();
			vo_glo_droppod_04();
			vo_glo_droppod_05();
			vo_glo_droppod_08();
			vo_glo_droppod_09();
			vo_glo_droppod_10();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end


script static void f_power_up_switches
	sleep_until (LevelEventStatus("e3_m3_switch_1"), 1);
	thread(f_music_e3m3_power_up_switch_1());
	device_set_power (capture_obj_3, 1);
	
	sleep_until (LevelEventStatus("e3_m3_switch_2"), 1);
	thread(f_music_e3m3_power_up_switch_2());

	device_set_power (water_base_shield_switch, 1);
	device_set_power (water_base_shield_switch0, 1);
	thread (e3_m3_water_base_thing_derez());
	thread (e3_m3_water_base_thing0_derez());
	sleep_until (LevelEventStatus("e3_m3_switch_3"), 1);
	thread(f_music_e3m3_power_up_switch_3());
	device_set_power (fore_water_base_thing, 1);
	sleep_forever();
end

script static void e3_m3_water_base_thing_derez
	waterfall_base_left_switch->SetDerezWhenActivated();
	sleep_until (device_get_position (water_base_shield_switch) == 1, 1);
	e3_m3_little_derez_switch_fore_2();
	sleep_s (2);
	object_destroy (waterfall_base_left_switch);
	object_destroy (fore_tower_2);
end

script static void e3_m3_water_base_thing0_derez
	waterfall_base_right_switch->SetDerezWhenActivated();
	sleep_until (device_get_position (water_base_shield_switch0) == 1, 1);
	e3_m3_little_derez_switch_fore_1();
	sleep_s (2);
	object_destroy (waterfall_base_right_switch);
	object_destroy (fore_tower_1);
end

script static void f_e3_m3_derez_switch (device switch)
	object_dissolve_from_marker(switch, phase_out, panel);
	//sleep_s (2);
	//object_hide (switch, true);
end

script static void e3_m3_little_derez_switch_fore_1
	object_dissolve_from_marker(fore_tower_1, phase_out, spawn_debris_04);
	//sleep_s (2);
	//object_hide (switch, true);
end

script static void e3_m3_little_derez_switch_fore_2
	object_dissolve_from_marker(fore_tower_2, phase_out, spawn_debris_04);
	//sleep_s (2);
	//object_hide (switch, true);
end

script command_script grunt_ghosts
	cs_pause (7);
//	ai_vehicle_enter (ai_current_actor, ghost_1);
	cs_go_to_vehicle (ghost_1);
	print ("grunt entering shost 1");
end

script command_script grunt_ghosts_2
	cs_pause (9);
//	ai_vehicle_enter (ai_current_actor, ghost_2);
	cs_go_to_vehicle (ghost_2);
	print ("grunt entering shost 2");
end

script command_script soldier_sleep
	cs_pause (24);
	print ("soldier_pause");
end

script command_script grunt_turret
	cs_pause (7);
//	ai_vehicle_enter (ai_current_actor, ghost_1);
	cs_go_to_vehicle (e3_m3_plasma_turret);
	print ("grunt entering turret");
end

script static void elitesattack
	sleep_until (firefight_players_dead() == false);
	sleep (30 * 6);
	print ("Fight Them");
	ai_set_task (guards_1, obj_capture, fight);
	sleep (30 * 20);
	print ("Advance");
	ai_set_task (guards_1, obj_capture, advance);
	sleep (30 * 6);
	print ("Fight Them");
	ai_set_task (guards_1, obj_capture, fight);
	sleep (30 * 10);
	print ("Advance");
	ai_set_task (guards_1, obj_capture, advance);
	sleep (30 * 10);
	print ("Fight Them");
	ai_set_task (guards_1, obj_capture, fight);
	sleep (30 * 20);
	print ("Advance");
	ai_set_task (guards_1, obj_capture, advance);
	sleep (30 * 6);
	print ("Fight Them");
	ai_set_task (guards_1, obj_capture, fight);
	sleep (30 * 10);
	print ("Advance");
	ai_set_task (guards_1, obj_capture, advance);
	sleep (30 * 10);
	print ("Fight Them");
	ai_set_task (guards_1, obj_capture, fight);
	sleep_until (ai_living_count (guards_1) <= 3, 1);
	print ("Retreat");
	ai_set_task (guards_1, obj_capture, guards1_retreat);
end

script static void e3m3_watchtower
	sleep_until(object_get_health(cov_watch_top) <= 0);
	object_set_phantom_power(cov_watch_base, false);
end

script static void cov_jammer_power
	ai_object_set_team (cov_signal_jammer2, covenant);
  object_set_allegiance (cov_signal_jammer2, covenant);
  object_immune_to_friendly_damage (cov_signal_jammer2, true);
end

script dormant vo_e3m3_glo_powersource()

	sleep_until (e3m3_narrative_is_on == FALSE);
	e3m3_narrative_is_on = TRUE;
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, do you see this?
	dprint ("Miller: Commander, do you see this?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00100'));
	
	end_radio_transmission();
	sleep (10);
	start_radio_transmission( "palmer_transmission_name" );
	
		// Palmer : Crimson! Look out!
	dprint ("Palmer: Crimson! Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_3_00100'));

	// Palmer : That's weird. Crimson, go get eyes on this point.
//	dprint ("Palmer: That's weird. Crimson, go get eyes on this point.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00200'));

	end_radio_transmission();

	e3m3_narrative_is_on = FALSE;
end



	