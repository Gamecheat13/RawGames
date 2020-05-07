//============================================ VALHALLA FIREFIGHT SCRIPT E4 M2========================================================
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


script startup valhalla_e4_m2

//Start the intro
	sleep_until (LevelEventStatus("e4_m2"), 1);
	print ("STARTING E4M2");
	thread(f_music_e4m2_mission_start());  
	
	switch_zone_set (e4_m2);
	mission_is_e4_m2 = true;
	ai_ff_all = e4_m2_ff_all;
	thread (f_start_player_intro_e4_m2());	
	thread (e4m2foreplace01());
	thread (destroystuff());
	thread (e4_m2_master_script());
	
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================

//================================================== AI ==================================================================
//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_phantom_03 = sq_ff_phantom_03;
//	ai_ff_sq_marines = sq_ff_marines_1;
//	
//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e4_m2_shard_spawn);										//UNSC crates and barriers around the dias
	f_add_crate_folder(e4_m2_unsc_center);										//cov crates all around the main area
	f_add_crate_folder(e4_m2_unsc_center_wall); 				//barriers that prevent getting behind the dias and to the large back middle area
	f_add_crate_folder(e4_m2_vehicles); 						//crates that blow up behind the dias
	f_add_crate_folder(e4_m2_man_cannons); 	
	f_add_crate_folder(e4_m2_tower_dm); 	
						//crates that blow up behind the dias
//	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 			5);  //UNSC barriers 
//	firefight_mode_set_crate_folder_at(cr_capture, 								6); //Cov crates 
//	firefight_mode_set_crate_folder_at(v_e2_m4_pelican, 					7); //SA: pelican for the crash
//f_add_crate_folder(eq_e3_m3_unsc_ammo); 											//SA: e1_m4 ammo boxes
	f_add_crate_folder(wp_power_weapons);												//power weapons spawns in the main area
	f_add_crate_folder(e4_m2_unsc_dec);												//power weapons spawns in the main area
	f_add_crate_folder(e4_m2_ammo);
	f_add_crate_folder(e3_m4_unsc_ammo);
	f_add_crate_folder(e4_m2_ammo_equipment);
	f_add_crate_folder(e4_m2_tower_controls);
//f_add_crate_folder(wp_cov_weapons); 													//SA: covey props for e2_m4
//	firefight_mode_set_crate_folder_at(cr_barriers, 							12); // nothing at the moment
//	firefight_mode_set_crate_folder_at(cr_destroy_shields, 				13); //barrier that prevent players from falling off the end of the large tunnel\
//	//firefight_mode_set_crate_folder_at(v_ff_for_d_turrets, 			14); //forerunner turrets
//	//firefight_mode_set_crate_folder_at(cr_f_temple_props, 			15); //various forerunner props all over the temple
//	//firefight_mode_set_crate_folder_at(dm_temple_props, 				16); //the large forerunner towers in the temple
//f_add_crate_folder(dm_f_shields_2);													//shields blocking the exit for ESCAPE
  //firefight_mode_set_crate_folder_at(cr_destroy_temple_props,	19); //
//	f_add_crate_folder(cr_e3_m3_temple_props);										// SA: props for snipper alley destroy, random forerunner spires and stuff
	f_add_crate_folder(e3_m3_forerunner_shield_switch);												// SA: Cov props placed around sniper alley 
//  firefight_mode_set_crate_folder_at(cr_e2_m4_temple_props, 		22); // SA: temple props for Run
  f_add_crate_folder(dc_capture_2);																// SA: temple props for Run
//f_add_crate_folder(e3_m4_ammo_boxes);											// shields blocking the middle
//f_add_crate_folder(cr_e3_m3_cov_props_1);										// SA: Cov props placed around sniper alley 
//f_add_crate_folder(dm_e3_m3_shields_2);											// shields blocking the bridge
//f_add_crate_folder(v_ff_cov_ghosts);
	
//set ammo crate names

	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e4_m2_spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(e4_m2_spawn_points_1, 91); //SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(e4_m2_spawn_points_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //SA Spawn location: in valley, facing into canyon
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //SA Spawn location: in middle of the canyon, facing towards temple
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //SA Spawn location: back of temple, middle, as a group
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //SA Spawn location: near end of valley to cayon, facing into valley
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //SA Spawn location: middle of the valley, facing towards the canyon
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
	firefight_mode_set_crate_folder_at(spawn_points_10, 100); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple	
	
//set objective names
	firefight_mode_set_objective_name_at(water_control, 			1); //objective behind the dias
	firefight_mode_set_objective_name_at(e4_m2_fore_water_base_thing, 			2); //on the dias
	firefight_mode_set_objective_name_at(e4_m2_fore_water_base_thing0, 			3); //in the tunnel
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
//	firefight_mode_set_objective_name_at(capture_obj_3, 			20); //in the leftside room
//	firefight_mode_set_objective_name_at(objective_switch_3, 	21); //SA switch location: upper front platform
//	firefight_mode_set_objective_name_at(objective_switch_4, 	22); //SA switch location: in the valley
//	firefight_mode_set_objective_name_at(water_base_shield_switch, 	23); //VH switch location: water base shield switch
//	firefight_mode_set_objective_name_at(cov_signal_jammer, 	24); //VH object destruction: cov signal jammer
//	firefight_mode_set_objective_name_at(fore_water_base_thing, 	25); //VH switch location: water base shield switch
//	firefight_mode_set_objective_name_at(cov_signal_jammer2, 	26); //VH object destruction: cov signal jammer
//	firefight_mode_set_objective_name_at(turret_switch_0, 	27); //VH object destruction: cov signal jammer
//	firefight_mode_set_objective_name_at(turret_switch_1, 	28); //VH object destruction: cov signal jammer
//	firefight_mode_set_objective_name_at(turret_switch_2, 	29); //VH object destruction: cov signal jammer

	
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
	firefight_mode_set_objective_name_at(lz_12, 62); //SA objective location: upper bend in the canyon



//set squad group names
	firefight_mode_set_squad_at(gr_ff_for_e4_m2_01, 		1);	//VA: Rock perch in the front of water base
	firefight_mode_set_squad_at(gr_ff_for_e4_m2_02, 			2);	//SA: mid level back of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_3, 		3);	//SA: back of main level of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_4, 		4); //SA: Side square platform
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_5,			5); //SA: Upper level, front of platform
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_6, 		6); //SA: front of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_7, 		7);	//SA: front entrance of temple before bridge
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_8, 		8);	//SA: Top of canyon
	firefight_mode_set_squad_at(sq_ff_marines_3, 					9); //SA: Middle of canyon
	firefight_mode_set_squad_at(gr_ff_e4m2_phantom, 					10); //SA: Bottom of temple
	firefight_mode_set_squad_at(gr_ff_e4m2_phantom_1, 				11); //SA: Top level right side
	firefight_mode_set_squad_at(gr_ff_e4m2_phantom_2, 				12); //SA: Top level left side
	firefight_mode_set_squad_at(gr_ff_e4m2_phantom_3, 	13); //Next to 11, special AI tied to it
	firefight_mode_set_squad_at(ff_crawler_squads_5, 	14); //Next to 12, special AI tied to it
//	firefight_mode_set_squad_at(gr_ff_guards_15, 				15); //SA: near entrance to canyon
//	firefight_mode_set_squad_at(gr_ff_guards_16, 				16); //SA: canyon
//	firefight_mode_set_squad_at(gr_ff_guards_17, 				17); //SA: canyon
//	firefight_mode_set_squad_at(gr_ff_guards_18_tank, 	18); //SA: canyon, near tank, for destroy
//	firefight_mode_set_squad_at(gr_ff_guards_19_tower, 	19); //SA: canyon, near tower 1, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_01,				20); //SA: canyon, near tower 2, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_02, 			21); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_03, 			22); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_05, 			23); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_banshee_01, 			24); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_banshee_02, 			25); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_06, 			26); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_07, 			27); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_08, 			28); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_09, 			29); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_10, 			30); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_11, 			31); //SA: middle of mid level, near back of temple
//	firefight_mode_set_squad_at(gr_ff_guards_23, 				24); //SA: middle of mid level, near front of temple
//	
//	firefight_mode_set_squad_at(gr_waves_1, 						51); //SA: middle of mid level, near front of temple
//
//	firefight_mode_set_squad_at(gr_ff_waves, 			80);
//	firefight_mode_set_squad_at(gr_ff_waves_1, 		81);
//	firefight_mode_set_squad_at(gr_ff_waves_2, 		82);
//	firefight_mode_set_squad_at(gr_ff_waves_3, 		83);
//	firefight_mode_set_squad_at(gr_ff_waves_4, 		84);
//	firefight_mode_set_squad_at(gr_ff_waves_5, 		85);
//	firefight_mode_set_squad_at(gr_ff_waves_6, 		86);
//
//	
//	firefight_mode_set_squad_at(gr_ff_allies_1, 71); //tunnel
//	firefight_mode_set_squad_at(gr_ff_allies_2,	72); //behind the dias
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

global short e4_m2_valhalla_part = 0;
global short mancannonend = 0;


script command_script cs_ff_e4m2_phantom_11()
	print ("phantom command script initiated");
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	ai_place (sq_ff_wraith_02);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_11.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_ff_wraith_02.driver ) );
	cs_fly_to (ps_ff_phantom_e4m2_2.p0);
//	cs_fly_to (ps_ff_phantom_e4m2_2.p1);
	cs_fly_to (ps_ff_phantom_e4m2_2.p2);
	cs_fly_to_and_face (ps_ff_phantom_e4m2_2.p3, ps_ff_phantom_e4m2_2.p4);
//	
//	cs_fly_to (ps_ship_phantom_01.p3);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_11.phantom ), "phantom_lc" );
	cs_force_combat_status (3);
	sleep (30 * 1);
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	//======== DROP DUDES HERE ======================
	sleep (30 * 3);
	ai_set_objective (cov_guard_23, ai_objectives_18);
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	cs_fly_to (ps_ff_phantom_e4m2_2.p5);
	cs_fly_by (ps_ff_phantom_09.p1);
	cs_fly_by (ps_ff_phantom_09.p0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (2);
	ai_erase (sq_ff_phantom_11);
end

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
// ====== E4_M2_Valhalla==============================================================================
// ==============================================================================================================

global boolean b_wait_for_e4m2narrative = false;
global boolean e4m2_narrative_is_on = FALSE;
global boolean b_rvb_interact = false;


script static void f_start_player_intro_e4_m2
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s (1);
		//intro_vignette_e3_m4();
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1);
		fade_out (0,0,0,15);
		sleep_s (1);
		b_wait_for_e4m2narrative = true;
		intro_vignette_e4_m2();
	end
	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until (b_players_are_alive(), 1);
	e4_m2_valhalla_part = 1;
	print ("player is alive");
//	sleep_s (0.5);
//	fade_in (0,0,0,15);
//	sleep_s (1);
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e4_m2
	print ("_____________starting vignette__________________");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e4m2_vin_sfx_intro', NONE, 1);
	thread(f_music_e4m2_intro_vignette_start());
	cinematic_start();
	pup_play_show (e4_m2_intro_v2);
	fade_in (0,0,0,15);
	wake (e4m2_vo_intro);
	sleep_s (15);
	cinematic_stop();
	fade_in (0,0,0,15);
// start VO
//thread (vo_e3m3_intro());
	
// wait until the puppeteer is complete
	print ("_____________done with vignette---SPAWNING__________________");
	thread(f_music_e4m2_intro_vignette_finish());  

//	firefight_mode_set_player_spawn_suppressed(false);
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
end

script static void e4_m2_master_script
	
//	thread (valhalla1_loadfriendlies());
//	print ("initial mission spawns");
	
//	thread (f_power_up_switches_e3_m4());
//	print ("Turret ready for activation");
	
	thread (e4m2foreplace02());
	print ("Shard Spawn");
	
//	thread (e3_m4_ord_drop_1());
//	print ("Drop the shield");
	
	thread (e4m2obj3());
	print ("Get to the tower");
	
	thread (e4m2foreplace03());
	print ("Get to the tower");	
	
	thread (e4m2obj4());
	print ("Ending sequence prepped");
	
	thread (e4m2objective5());
	print ("Turn on the portal");
	
	thread (portalspawn());
	print ("It's...beautiful");
	
	thread (objectiveover());
	print ("Ending sequence prepped");
	
	thread (f_callouts());
	print ("Finish the Prometheans");
	
	thread (f_cov_callouts());
	print ("Finish the Covies");
	
	thread (f_cov_callouts2());
	print ("Finish the Covies");
	
	thread (f_phantom_callouts());
	print ("Here's a Phantom");
	
	thread (f_rvb_interact());
	print ("You ever wonder why we're here?");
	
	
end

script static void destroystuff
	object_destroy (waterfall_base_left_switch);
	object_destroy (waterfall_base_right_switch);
	object_destroy (cov_watch_base);
	object_destroy (cov_watch_top);
	object_destroy (fore_tower_2);
	object_destroy (fore_tower_1);
end
	

script static void e4m2foreplace01
	sleep_until (LevelEventStatus ("placefore"), 1);
	effect_new (levels\firefight\ff92_valhalla\fx\energy\valhalla_launchpad_energy_rt.effect, cutscene_flags_lakeside_center_man_cannon);
	effect_new (levels\firefight\ff92_valhalla\fx\energy\valhalla_launchpad_energy_rt.effect, cutscene_flags_lakeside_right_man_cannon);
	
	thread(f_music_e4m2_first_encounter_start());  
	print ("Marines!");
	thread (objective02());

	ai_place (ff_allies_marines_1);
	ai_cannot_die (ff_allies_marines_1, TRUE);

//	cinematic_set_title (e4_m2_d_1);
	sleep_until (firefight_players_dead() == false);

		
	print ("Hello Pawns");
	ai_place (gr_ff_for_e4_m2_02);
	sleep_s (2);
	
	print ("Hello Bishop and Knights");
	ai_place (gr_ff_for_e4_m2_01);
	
	thread(bishop01respawn());
	thread(f_music_e4m2_waterfront_vo());  
	wake (e4m2_vo_waterfronttower);
		sleep_s (1);
		sleep_until (e4m2_narrative_is_on == FALSE);
//	ai_place (sq_ff_pelican_intro);

	f_new_objective (e4_m2_obj_1);
	object_create (lz_2);
	thread(f_music_e4m2_navpoint_1_set());  
	navpoint_track_object_named(lz_2, "navpoint_goto");
	
	thread(f_music_e4m2_magestic_report_vo()); 
	
	wake (e4m2_vo_majesticreport);
		sleep_s (1);
		sleep_until (e4m2_narrative_is_on == FALSE);

	sleep_until (volume_test_players (e4_m2_water_base_trigger), 1); 
	thread(f_music_e4m2_navpoint_1_reached());  
	object_destroy (lz_2);
	ai_place_with_shards (ff_bishop_turrets_1);
	print ("Hello Turrets");
	notifylevel ("HelloTurrets");
	effect_new (environments\multi\valhalla\fx\valhalla_tower_beam.effect, cutscene_flags_lakeside_tower_pulse);
	sleep_s (1);
	thread(f_music_e4m2_julportal_vo());  
	wake (e4m2_vo_julportal);
		sleep_s (1);
		sleep_until (e4m2_narrative_is_on == FALSE);
	//Activates forerunner turrets on the water base.
	
	sleep_until (ai_living_count (gr_ff_for_e4_m2_02) <= 6);
	
	ai_place (ff_crawler_squads_1_1);
	
//	sleep_until (ai_living_count (e4_m2_ff_all) <= 5);
//	ai_set_objective (ff_bishop_1, ai_crawler_follow_02);
//	ai_set_objective (gr_ff_for_e4_m2_02, ai_crawler_follow_02);

	sleep_until (ai_living_count (gr_ff_first_encounter) <= 6);
	ai_set_objective (gr_ff_for_e4_m2_02, ai_crawler_follow_02);
	ai_place (ff_crawler_squads_1_1);
	ai_place_with_birth (ff_bishop_back_knight_1);
//	sleep_s (1);
//	ai_place_with_birth (ff_bishop_back_knight_2);
	ai_place_in_limbo (ff_knight_back_attack_1);
	
	sleep_until (ai_living_count (gr_ff_first_encounter) <= 5);
//	wake (vo_glo_lasttargets_08);
	notifylevel ("last_covies1");
	sleep_s (1);
	sleep_until (b_dialog_playing == false, 1);
	f_blip_ai_cui(e4_m2_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (gr_ff_first_encounter) <= 0);
	print ("Wait until enemies die.");
	thread(f_music_e4m2_first_encounter_finish());  
	
//	thread (objective02());
	sleep_s (5);
	vo_glo_powersource_02();
	f_new_objective (e4_m2_obj_1);
	object_create (lz_2);
	thread(f_music_e4m2_navpoint_2_set());  
	navpoint_track_object_named(lz_2, "navpoint_goto");
	
	sleep_until (volume_test_players (trigger_volumes_7), 1);
	thread(f_music_e4m2_navpoint_2_reached());  
	object_destroy (lz_2);
	
	wake (e4m2_vo_checkportal);
		sleep_s (1);
		sleep_until (e4m2_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;
	sleep_forever();
end

script static void bishop01respawn
	repeat
		sleep_until (ai_living_count (ff_bishop_1) == 0);
			print ("no more bishop");
			ai_place_with_birth (ff_bishop_1);
			sleep_until (ai_living_count (ff_bishop_1) > 0);
			sleep_until (ai_living_count (ff_bishop_1) == 0);
//		end
	until (ai_living_count (gr_ff_for_e4_m2_02) <= 6);
	print ("no more reinforcements");
end


script static void objective02
	sleep_until (LevelEventStatus ("obj02"), 1);
	sleep_s (1);
//	f_new_objective (e4_m2_obj_1);
//	b_wait_for_narrative_hud = false;
	b_end_player_goal = TRUE;
	sleep_s (1);
//	device_set_power (water_control, 1);
//	sleep_forever();
end
	

script static void e4m2foreplace02
	sleep_until (LevelEventStatus ("pawnshard"), 1);
	sleep_s (1);
	thread (shard_test());
	thread(f_music_e4m2_placeoffline_vo());  
	wake (e4m2_vo_placeoffline);
	
	sleep_s (1);
	sleep_until (e4m2_narrative_is_on == FALSE);
	sleep_s (2);
	e4_m2_valhalla_part = 2;
	e4m2_rvb_switch();
	object_cannot_take_damage (e4_m2_rvb);
	thread(f_music_e4m2_magestic_find_vo());  
//	wake (e4m2_vo_majesticfind);
	sleep_s (1);
	sleep_until (e4m2_narrative_is_on == FALSE);
	
	print ("Portal bad, second tower.");
//	cinematic_set_title (e4_m2_d_2);
	sleep_s (3);
	
	thread(f_music_e4m2_othertower_vo());  
	wake (e4m2_vo_othertower);
	
	sleep_s (1);
	sleep_until (e4m2_narrative_is_on == FALSE);
	
	f_new_objective (e4_m2_obj_2);
	
	thread(f_music_e4m2_navpoint_3_set());  
	object_create_anew (lz_14);
	navpoint_track_object_named(lz_14, "navpoint_goto");
	object_create_anew (lz_13);
	navpoint_track_object_named(lz_13, "navpoint_goto");
	
	sleep_until (volume_test_players (trigger_volumes_8), 1);
	
	thread(f_music_e4m2_navpoint_3_reached());  
	object_destroy (lz_13);
	object_destroy (lz_14);
	
	sleep_until (ai_living_count (gr_ff_mid_battle_squads) <= 5);


	sleep_until (ai_living_count (gr_ff_mid_battle_squads) <= 3);
	
	thread(f_music_e4m2_enemies_destroyed());  
	
//	b_end_player_goal = TRUE;
	f_new_objective (e4_m2_obj_2);
	object_create_anew (lz_5);
	navpoint_track_object_named(lz_5, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_8), 1);
	object_destroy (lz_5);
end

script static void e4m2obj3
	sleep_until (LevelEventStatus ("gettothetower"), 1);
	sleep_s (1);
	print ("Ow, that hurt!!!");
	
	thread(f_music_e4m2_tower_objective_set()); 
	f_new_objective (e4_m2_d_4);
	ai_set_objective (ff_bishop_2, ai_objectives_10);
	ai_set_objective (ff_bishop_3, ai_objectives_10);
	ai_set_objective (gr_ff_mid_knight_squad_1, e4m2_obj_tower_attack_2);
	ai_cannot_die (ff_allies_marines_1, FALSE);
	sleep_forever();
end

script static void objectiveover
	sleep_until (LevelEventStatus ("objover"), 1);
	sleep_s (1);
	b_end_player_goal = TRUE;
	e4_m2_valhalla_part = 3;
end

script static void e4m2obj4
	sleep_until (LevelEventStatus ("winnarwinnar"), 1);
	b_wait_for_narrative_hud = true;
	sleep_until (ai_living_count (e4_m2_ff_all) <= 10);
	print ("Thanks Crimson!");
//	f_blip_object_cui (e4_m2_ff_all, "squad");
	sleep_until (ai_living_count (e4_m2_ff_all) == 0);
	
	sleep_s (3);
	thread(f_music_e4m2_sillon_vo()); 
	wake (e4m2_vo_stillon);
		sleep_s (1);
		sleep_until (e4m2_narrative_is_on == FALSE);
	f_new_objective (e4_m2_obj_3);
	b_wait_for_narrative_hud = false;
	device_set_power (e4_m2_fore_water_base_thing, 1);
	device_set_power (e4_m2_fore_water_base_thing0, 1);
	thread (water_base_thing_derez());
	thread (water_base_thing0_derez());
//	f_blip_object_cui (fore_water_base_thing, "navpoint");
//	sleep_until (s_all_objectives_count == 1);
////	f_unblip_object_cui (fore_water_base_thing, "navpoint");
//	f_blip_object_cui (water_base_shield_switch, "navpoint");
////	sleep_until (s_all_objectives_count == 0);
////	f_unblip_object_cui (water_base_shield_switch, "navpoint");
	sleep_forever();
end

script static void water_base_thing_derez
	portal_switch_2->SetDerezWhenActivated();
end

script static void water_base_thing0_derez
	portal_switch_1->SetDerezWhenActivated();
end

script static void e4m2foreplace03
	sleep_until (LevelEventStatus ("placeforeback"), 1);
	sleep_until (ai_living_count (e4_m2_ff_all) <= 4);
	print ("knights!");
	sleep_s (4);
	ai_place_with_birth (ff_bishop_4);
	ai_place_with_birth (ff_bishop_4);
	ai_place_in_limbo (knight_squad_back_base_1);
	print ("Hello Pawns");
//	ai_place (ff_bishop_4);
//	ai_set_objective (ff_bishop_back_knight_1, ai_crawler_follow_02);
	sleep_s (4);
	thread (shard_back_base());
	print ("We're here to help!!!!");
end
	
script static void e4m2objective5
	sleep_until (LevelEventStatus ("e4m2obj5end"), 1);
	
	
//	device_set_power (e4_m2_portal, 1);
	
	thread(f_music_e4m2_getinthere_vo());
	wake (e4m2_vo_getinthere);
	
	sleep_s (1);
	sleep_until (e4m2_narrative_is_on == FALSE);
	b_wait_for_narrative_hud = true;
	// set objective
	f_new_objective (e4_m2_obj_4);
	thread(f_music_e4m2_navpoint_4_set()); 
	object_create (lz_0);
	navpoint_track_object_named(lz_0, "navpoint_goto");
	b_wait_for_narrative_hud = false;
	f_add_crate_folder(e4_m2_waterfall_man_cannons);
	effect_new (levels\firefight\ff92_valhalla\fx\energy\valhalla_launchpad_energy_rt.effect, cutscene_flags_waterfall_left_man_cannon);
	effect_new (levels\firefight\ff92_valhalla\fx\energy\valhalla_launchpad_energy_rt.effect, cutscene_flags_waterfall_center_man_cannon);
	// reach objective
	thread (mancannonlaunch());
	sleep_until (volume_test_players (trigger_volumes_12), 1);
	mancannonend = 1;
	thread(f_music_e4m2_navpoint_4_reached()); 
	object_destroy (lz_0);
	
	fade_out (255, 255, 255, 3);

	

	sleep_s (2);

	wake (e4m3opening);
	sleep_s (1);
	sleep_until (e4m2_narrative_is_on == FALSE);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	b_end_player_goal = TRUE;
end

script static void mancannonlaunch
	repeat
	sleep_until (volume_test_players (trigger_volumes_6), 1);
	ai_disregard (players(), TRUE);
	player_camera_control (false);
	player_enable_input (FALSE);
	object_cannot_take_damage (players());
	sleep_s (2);
		if mancannonend == 0 then
		player_camera_control (TRUE);
		player_enable_input (TRUE);
		elseif mancannonend == 1 then
		sleep (1);
		end	
	sleep_s (2);
	object_can_take_damage (players());
	until (mancannonend == 1);
end

script static void portalspawn
	sleep_until (LevelEventStatus ("iseeit"), 1);
	object_create_anew (e4_m2_portal);
	object_hide (e4_m2_portal, true);	
	object_dissolve_from_marker (e4_m2_portal, phase_in, dissolve_mkr);
	object_hide (e4_m2_portal, false);
	device_set_power (e4_m2_portal, 1);
	device_set_position (e4_m2_portal, 1);
	sleep_s (4);
	thread(portaleffects()); 
end
	

script static void nomorewaveswhat
	sleep_until (LevelEventStatus ("weover"), 1);
	print ("Are we done?");
	sleep_until (LevelEventStatus ("yaover"), 1);
	print ("Yeah, we're done.");
	sleep_forever();
end


//script continuous placeshard
//	
//	print ("You rang");
//	thread (shard_test);
//end

script static void shard_test
	sleep_until (volume_test_players (e4_m2_mid_trigger), 1); 
	print("AI SHARD TEST START");
	ai_place(ff_bishop_2);
	print("Placed bishop");
	sleep_s(1);
	ai_place_with_shards (ff_crawler_squads_3, 4);
	print("Placing pawns with shards");
	ai_place(ff_bishop_3);
	print("Placed bishop 3");
	sleep_s(1);
	ai_place_with_shards(ff_crawler_squads_4, 4);
	print("Placing pawns with shards");
	sleep_s (8);
	sleep_until (ai_living_count (gr_ff_mid_battle_squads) <= 4);
	thread (mid_knight_spawn());
	thread (bishop_respawn());
	ai_place_with_shards (ff_crawler_squads_3, 4);
	print("Placing reinforcement pawns");
	sleep_s (2);
	ai_place_with_shards (ff_crawler_squads_4, 4);
	print("Placing reinforcement pawns");
	sleep_s (10);
	sleep_until (ai_living_count (gr_ff_for_e4_m2_03) <= 4);
	thread (bishop_respawn());
	thread (mid_knight_spawn());
	sleep_s (1);
	ai_place_with_shards (ff_crawler_squads_3, 4);
	sleep_s (3);	
	sleep_until (ai_living_count (e4_m2_ff_all) <= 5);
	notifylevel ("more_enemies1");
	sleep_s (2);
	f_blip_ai_cui(e4_m2_ff_all, "navpoint_enemy");
	b_end_player_goal = TRUE;
	print("Placing reinforcement pawns");
	sleep_forever();
end

script static void f_cov_callouts
	repeat
		sleep_until (LevelEventStatus("last_covies1"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
////			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_cleararea_01();
			vo_glo_cleararea_02();
			vo_glo_cleararea_03();
			vo_glo_cleararea_04();
			vo_glo_cleararea_05();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end

script static void f_cov_callouts2
	repeat
		sleep_until (LevelEventStatus("last_covies2"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		sleep_until (ai_living_count (e4_m2_ff_all) <= 5);
		
//		if editor_mode() then
////			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_cleararea_01();
			vo_glo_cleararea_02();
			vo_glo_cleararea_03();
			vo_glo_cleararea_04();
			vo_glo_cleararea_05();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end

script static void f_callouts
	repeat
		sleep_until (LevelEventStatus("more_enemies1"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
////			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_remainingproms_01();
			vo_glo_remainingproms_02();
			vo_glo_remainingproms_03();
			vo_glo_remainingproms_04();
			vo_glo_remainingproms_05();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end

script static void bishop_respawn
	if (ai_living_count (ff_bishop_2) <= 0) or (ai_living_count (ff_bishop_3) <= 0) then
		ai_place(ff_bishop_3);
		ai_place(ff_bishop_2);
	end
end	



script static void mid_knight_spawn
	if (ai_living_count (gr_ff_for_e4_m2_03) <= 4) and (volume_test_players (location_e4_m2_mid_knight_spawn_1)) then
	 ai_place_in_limbo (ff_mid_knight_1);
	elseif (ai_living_count (gr_ff_for_e4_m2_03) <= 4) and (volume_test_players (location_e4_m2_mid_knight_spawn_2)) then
		ai_place_in_limbo (ff_mid_knight_2);
	elseif (ai_living_count (gr_ff_for_e4_m2_03) <= 4) and (volume_test_players (location_e4_m2_mid_knight_spawn_4)) then
		ai_place_in_limbo (ff_mid_knight_3);
	elseif (ai_living_count (gr_ff_for_e4_m2_03) <= 4) and (volume_test_players (location_e4_m2_mid_knight_spawn_3)) then
		ai_place_in_limbo (ff_mid_knight_4);
	end
	sleep_forever();
end


script static void shard_back_base
	sleep_until (ai_living_count (e4_m2_ff_all) <= 4);
	print("BACK SHARD START");
	ai_place(ff_bishop_4);
	print("Placed bishop");
	sleep_s(1);
	ai_place (ff_crawler_squads_5);
	print("Placing pawns with shards");
	sleep_s (10);
	sleep_until (ai_living_count (e4_m2_ff_all) <= 4);
	ai_place (ff_crawler_squads_5);
	print("Placing reinforcement pawns");
end

script static void f_phantom_callouts
	repeat
		sleep_until (LevelEventStatus("more_phantoms"), 1);
		print ("more enemies event");
		
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;

		begin_random_count (1)
			vo_glo_phantom_04();
			vo_glo_phantom_05();
			vo_glo_phantom_06();
			vo_glo_phantom_07();
			vo_glo_phantom_08();
			vo_glo_phantom_09();
			vo_glo_phantom_10();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end

script dormant e4m3opening
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	// Palmer : So where the hell did Crimson go?
	dprint ("Palmer: So where the hell did Crimson go?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00100'));
	
	// Miller : No idea, Commander. I'm working on it.
	dprint ("Miller: No idea, Commander. I'm working on it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_03\e4m3_intro_00200'));
	
	e4m2_narrative_is_on = FALSE;
end

script static void f_derez_switch (device switch)
	object_dissolve_from_marker(switch, phase_out, panel);
	//sleep_s (2);
	//object_hide (switch, true);
end

script static void portaleffects
	print ("placing sm portal start effect");
	effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal.effect, cutscene_flags_tower_portal);
	sleep_s (3);
//	print ("placing sm portal effect");
//	effect_new (environments\solo\m30_cryptum\fx\portal\teleport_sm_portal.effect, cutscene_flags_tower_portal);
	print ("Do you see anything?");
end

global object g_ics_player = none;


script static void f_cov_switch_activate (object control, unit player)
//script static void f_push_fore_switch (unit player)
print ("pushing the forerunner switch");

	g_ics_player = player;
// g_ics_player = player0;
	if control == e4_m2_fore_water_base_thing0 then
	print ("play left portal switch puppetshow");
	pup_play_show (e4m2_button_press);
// elseif dev == power_switch_temp then
// pup_play_show (e1_m5_push_power_button);

	elseif control == e4_m2_fore_water_base_thing then
	print ("play button 2 puppetshow");
	pup_play_show (e4m2_port_right_press);
	end
end



// ==============================================================================================================
// ====== EASTER EGGS ===============================================================================
// ==============================================================================================================



script static void f_rvb_interact
                print ("start RVB");
                object_create_anew (e4_m2_rvb);
                sleep_until (object_get_health (e4_m2_rvb) < 1, 1);
                print ("rvb interacted");
                object_cannot_take_damage (e4_m2_rvb);                
                // f_new_objective (rvb_confirm);
                b_rvb_interact = true;
                inspect (b_rvb_interact);
                f_achievement_spops_1();
                //play stinger
                sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
								sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme'));

end

script static void e4m2_rvb_switch
//	repeat
		if b_rvb_interact == true then
			wake (e4m2_rvb);
		else
			wake (e4m2_vo_majesticfind);
		end
//	until (b_game_ended == true);
end

script dormant e4m2_rvb()
	sleep_until (e4m2_narrative_is_on == FALSE);
	e4m2_narrative_is_on = TRUE;

	// RvB_Vic : Hello, hello? Commander Palmer, hello? Do you read me?
	dprint ("RvB_Vic: Hello, hello? Commander Palmer, hello? Do you read me?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00100'));
	
	sleep_s (5);

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : What are you even doing?
	dprint ("Palmer: What are you even doing?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200'));
	
	end_radio_transmission();
	
	sleep_s (2);

	// RvB_Vic : Oh come on, dude, I thought you saved my number at the party last night. You were really killin’ it on the karaoke, if you know what I’m sayin', dude.
	dprint ("RvB_Vic: Oh come on, dude, I thought you saved my number at the party last night. You were really killin’ it on the karaoke, if you know what I’m sayin', dude.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00300'));
	
	start_radio_transmission( "palmer_transmission_name" );
	sleep_s (8);
	
	// Palmer : Miller? Status?
	dprint ("Palmer: Miller? Status?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00100'));
	
	end_radio_transmission();
	sleep (10);
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Working on it, Commander.
	dprint ("Miller: Working on it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200'));
	
	end_radio_transmission();
	sleep_s (4);

	// RvB_Vic : Yeesh, easy there, Commander Buzzkill. Look, I’m going to 80s night tomorrow, so gimme a buzz after you save the universe, and all that. Hasta la huego , la huego bye bye.
	dprint ("RvB_Vic: Yeesh, easy there, Commander Buzzkill. Look, I’m going to 80s night tomorrow, so gimme a buzz after you save the universe, and all that. Hasta la huego , la huego bye bye.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_02\e4m2_rvb_vic_00500'));
	sleep_s (8);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller! What's taking so long?
	dprint ("Palmer: Miller! What's taking so long?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00100'));
	
	end_radio_transmission();
	sleep (10);


	e4m2_narrative_is_on = FALSE;
end