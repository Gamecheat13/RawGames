//=============================================================================================================================
//============================================ VALHALLA BASE FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== LEVEL SCRIPT ==================================================================
//=============================================================================================================================
global cutscene_title title_switch_obj_1 = switch_obj_1;
global cutscene_title title_swarm_1 = swarm_1;
global cutscene_title title_lz_end = lz_end;
global cutscene_title title_pelican_crash = pelican_crash;
global cutscene_title title_aa_guns_disabled = aa_guns_disabled;
global cutscene_title title_disable_aa_1 = disable_aa_guns;
global cutscene_title title_use_vehicles = use_vehicles;
global ai ai_ff_allies_1 = gr_ff_allies_1;
global ai ai_ff_allies_2 = gr_ff_allies_2;

global boolean drop_ord = FALSE;

global boolean mission_is_e3_m3 = FALSE;
global boolean mission_is_e3_m4 = FALSE;
global boolean mission_is_e4_m2 = TRUE;

script startup valhalla

//Start the intro - this is now handled in the mission scripts
//	thread(f_start_player_intro());
	
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================

//================================================== AI ==================================================================
//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_1;
//	

//this is now handled in the mission scripts
//================================================== OBJECTS ==================================================================
//set crate names
//	firefight_mode_set_crate_folder_at(cr_destroy_unsc_cover, 		1); //UNSC crates and barriers around the dias
//	firefight_mode_set_crate_folder_at(cr_destroy_cov_cover, 			2); //cov crates all around the main area
//	firefight_mode_set_crate_folder_at(dm_destroy_shields, 				3); //barriers that prevent getting behind the dias and to the large back middle area
//	firefight_mode_set_crate_folder_at(cr_power_core, 						4); //crates that blow up behind the dias
//	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 			5);  //UNSC barriers 
//	firefight_mode_set_crate_folder_at(cr_capture, 								6); //Cov crates 
//	firefight_mode_set_crate_folder_at(v_e2_m4_pelican, 					7); //SA: pelican for the crash
//	firefight_mode_set_crate_folder_at(eq_e1_m4_unsc_ammo, 				8); //SA: e1_m4 ammo boxes
//	firefight_mode_set_crate_folder_at(wp_power_weapons, 					10); //power weapons spawns in the main area
//	firefight_mode_set_crate_folder_at(cr_e2_m4_cov_props, 				11); //SA: covey props for e2_m4
//	firefight_mode_set_crate_folder_at(cr_barriers, 							12); // nothing at the moment
//	firefight_mode_set_crate_folder_at(cr_destroy_shields, 				13); //barrier that prevent players from falling off the end of the large tunnel\
//	//firefight_mode_set_crate_folder_at(v_ff_for_d_turrets, 			14); //forerunner turrets
//	//firefight_mode_set_crate_folder_at(cr_f_temple_props, 			15); //various forerunner props all over the temple
//	//firefight_mode_set_crate_folder_at(dm_temple_props, 				16); //the large forerunner towers in the temple
//	firefight_mode_set_crate_folder_at(dm_f_shields_2, 						17); //shields blocking the exit for ESCAPE
//  //firefight_mode_set_crate_folder_at(cr_destroy_temple_props,	19); //
//  firefight_mode_set_crate_folder_at(cr_e1_m4_temple_props, 		20); // SA: props for snipper alley destroy, random forerunner spires and stuff
//  firefight_mode_set_crate_folder_at(cr_e1_m4_cov_props, 				21); // SA: Cov props placed around sniper alley
//  firefight_mode_set_crate_folder_at(cr_e2_m4_temple_props, 		22); // SA: temple props for Run
//  firefight_mode_set_crate_folder_at(dm_e1_m4, 									23); // SA: temple props for Run
//	
////set ammo crate names
//	firefight_mode_set_crate_folder_at(eq_destroy_crates, 	80); //ammo crates in main area
//	firefight_mode_set_crate_folder_at(eq_defend_1_crates, 	81); //ammo crates in front right area
//	firefight_mode_set_crate_folder_at(eq_capture_crates, 	82); //ammo crates in front left
//	firefight_mode_set_crate_folder_at(eq_defend_2_crates, 	83); //ammo crates behind the dias
//	
////set spawn folder names
//	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
//	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //SA Spawn location: middle of temple, facing out of temple
//	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
//	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
//	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //SA Spawn location: in valley, facing into canyon
//	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //SA Spawn location: in middle of the canyon, facing towards temple
//	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //SA Spawn location: back of temple, middle, as a group
//	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //SA Spawn location: near end of valley to cayon, facing into valley
//	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //SA Spawn location: middle of the valley, facing towards the canyon
//	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
//	
////set objective names
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
//	firefight_mode_set_objective_name_at(capture_obj_3, 			20); //in the leftside room
//	firefight_mode_set_objective_name_at(objective_switch_3, 	21); //SA switch location: upper front platform
//	firefight_mode_set_objective_name_at(objective_switch_4, 	22); //SA switch location: in the valley
//	
//	firefight_mode_set_objective_name_at(lz_0, 	50); //SA objective location: back of temple
//	firefight_mode_set_objective_name_at(lz_1, 	51); //SA objective location: front pad of temple
//	firefight_mode_set_objective_name_at(lz_2, 	52); //SA objective location: near middle of temple
//	firefight_mode_set_objective_name_at(lz_3, 	53); //SA objective location: middle of switchback canyon
//	firefight_mode_set_objective_name_at(lz_4, 	54); //SA objective location: on lower platform by ramp to upper level, leading to back of canyon
//	firefight_mode_set_objective_name_at(lz_5, 	55); //SA objective location: entrance to canyon from valley
//	firefight_mode_set_objective_name_at(lz_6, 	56); //SA objective location: front of temple, front of canyon
//	firefight_mode_set_objective_name_at(lz_7, 	57); //SA objective location: front of cayon into valley
//	firefight_mode_set_objective_name_at(lz_8, 	58); //SA objective location: middle of the valley
//	firefight_mode_set_objective_name_at(lz_9, 	59); //SA objective location: bottom of the ramp, towards the back of the temple
//	firefight_mode_set_objective_name_at(lz_10, 60); //SA objective location: lower bend in the canyon
//	firefight_mode_set_objective_name_at(lz_11, 61); //SA objective location: upper bend in the canyon
//
////set squad group names
//	firefight_mode_set_squad_at(gr_ff_guards_1, 				1);	//SA: back of temple
//	firefight_mode_set_squad_at(gr_ff_guards_2, 				2);	//SA: mid level back of temple
//	firefight_mode_set_squad_at(gr_ff_guards_3, 				3);	//SA: back of main level of temple
//	firefight_mode_set_squad_at(gr_ff_guards_4, 				4); //SA: Side square platform
//	firefight_mode_set_squad_at(gr_ff_guards_5, 				5); //SA: Upper level, front of platform
//	firefight_mode_set_squad_at(gr_ff_guards_6, 				6); //SA: front of temple
//	firefight_mode_set_squad_at(gr_ff_guards_7, 				7);	//SA: front entrance of temple before bridge
//	firefight_mode_set_squad_at(gr_ff_guards_8, 				8);	//SA: Top of canyon
//	firefight_mode_set_squad_at(gr_ff_guards_9, 				9); //SA: Middle of canyon
//	firefight_mode_set_squad_at(gr_ff_guards_10, 				10); //SA: Bottom of temple
//	firefight_mode_set_squad_at(gr_ff_guards_11, 				11); //SA: Top level right side
//	firefight_mode_set_squad_at(gr_ff_guards_12, 				12); //SA: Top level left side
//	firefight_mode_set_squad_at(gr_ff_attack_squad_a, 	13); //Next to 11, special AI tied to it
//	firefight_mode_set_squad_at(gr_ff_attack_squad_b, 	14); //Next to 12, special AI tied to it
//	firefight_mode_set_squad_at(gr_ff_guards_15, 				15); //SA: near entrance to canyon
//	firefight_mode_set_squad_at(gr_ff_guards_16, 				16); //SA: canyon
//	firefight_mode_set_squad_at(gr_ff_guards_17, 				17); //SA: canyon
//	firefight_mode_set_squad_at(gr_ff_guards_18_tank, 	18); //SA: canyon, near tank, for destroy
//	firefight_mode_set_squad_at(gr_ff_guards_19_tower, 	19); //SA: canyon, near tower 1, for destroy
//	firefight_mode_set_squad_at(gr_ff_guards_20_tower,	20); //SA: canyon, near tower 2, for destroy
//	firefight_mode_set_squad_at(gr_ff_guards_21, 				21); //SA: canyon, middle
//	firefight_mode_set_squad_at(gr_ff_guards_22, 				22); //SA: middle of mid level, near back of temple
//	firefight_mode_set_squad_at(gr_ff_guards_23, 				23); //SA: middle of mid level, near front of temple
//
//	firefight_mode_set_squad_at(gr_ff_waves, 		80);
//	firefight_mode_set_squad_at(gr_ff_allies_1, 81); //tunnel
//	firefight_mode_set_squad_at(gr_ff_allies_2,	82); //behind the dias

//================================================== TITLES ==================================================================
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
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
	b_game_v_defend = true;
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

script continuous f_start_events_goals_switch_start_1
	sleep_until (LevelEventStatus("start_switch_1"), 1);
	sleep (30 * 8);
	cinematic_set_title (title_switch_obj_1);
end

script continuous f_end_events_goals_switch_1
	sleep_until (LevelEventStatus("end_switch_1"), 1);
	cinematic_set_title (destroy_obj_complete_1);
	sound_impulse_start (vo_destroy_19, none, 1.0);
end

script continuous f_start_events_goals_swarm_start_lz
	sleep_until (LevelEventStatus("start_swarm_lz"), 1);
	cinematic_set_title (title_swarm_1);
	sleep (30 * 3);
	sound_impulse_start (vo_swarm_1, none, 1.0);
end

script continuous f_end_events_lz
	sleep_until (LevelEventStatus("end_lz_1"), 1);
	cinematic_set_title (title_lz_end);
	sound_impulse_start (vo_destroy_19, none, 1.0);
end


//script continuous f_misc_crash_pelican
//	sleep_until (LevelEventStatus("crash_pelican"), 1);
//	print ("crash_pelican");
//	ai_place (sq_ff_pelican);
//	cs_run_command_script (sq_ff_pelican.pilot, cs_pelican_crash);
//end

script continuous f_misc_aa_turrets
	sleep_until (LevelEventStatus("aa_turrets"), 1);
	print ("AA started");
	ai_place (sq_aa_turrets);
	camera_test();
	sleep (30);
	sleep_until (LevelEventStatus("end_aa_1"), 1);
	print ("TURRETS SHUT DOWN");
	ai_braindead (sq_aa_turrets, true);
end

script continuous f_start_events_goals_aa_1
	sleep_until (LevelEventStatus("start_aa_1"), 1);
	sleep (30 * 8);
	cinematic_set_title (title_disable_aa_1);
end

script continuous f_end_events_goals_aa_1
	sleep_until (LevelEventStatus("end_aa_1"), 1);
	cinematic_set_title (title_aa_guns_disabled);
	sound_impulse_start (vo_destroy_19, none, 1.0);
end

script continuous f_misc_events_use_vehicles
	sleep_until (LevelEventStatus("use_vehicles"), 1);
	print ("use vehicles now running");
	cinematic_set_title (title_use_vehicles);
end

//script continuous f_start_events_goals_defend_2
//	sleep_until (LevelEventStatus("start_defend_2"), 1);
//
//		//turn on music
//	sound_looping_start (music_start, NONE, 1.0);
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
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

// PHANTOM 01 =================================================================================================== 
script command_script cs_ff_phantom_01()
	sleep (1);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_phantom_01.p0);
	cs_fly_by (ps_ff_phantom_01.p1);
	cs_fly_by (ps_ff_phantom_01.p2);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	cs_fly_to (ps_ff_phantom_01.p3);
	cs_fly_to (ps_ff_phantom_01.p4);
	cs_fly_by (ps_ff_phantom_01.p5);
	cs_fly_to (ps_ff_phantom_01.erase);
	ai_erase (ai_current_squad);
end

// PHANTOM 02 =================================================================================================== 
script command_script cs_ff_phantom_03()
	//v_ff_phantom_02 = ai_vehicle_get_from_starting_location (sq_ff_phantom_03.phantom);
	sleep (1);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (sq_ff_phantom_03.phantom, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_to (ps_ff_phantom_03.p0);
	cs_fly_to (ps_ff_phantom_03.p1);
	cs_fly_to (ps_ff_phantom_03.p2);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_03 unloaded");
	sleep (30 * 5);
	cs_fly_to (ps_ff_phantom_03.p3);
	cs_fly_to (ps_ff_phantom_03.p4);
	cs_fly_to (ps_ff_phantom_03.p5);
	cs_fly_to (ps_ff_phantom_03.p6);
	cs_fly_to (ps_ff_phantom_03.erase);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

script command_script cs_ff_phantom_02()
	print ("phantom command script initiated");
	ai_place (sq_ff_wraith_01);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_02.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_ff_wraith_01.driver ) );
	cs_fly_to_and_face (ps_ff_phantom_02.p0, ps_ff_phantom_02.p1);
	cs_fly_to_and_face (ps_ff_phantom_02.p2, ps_ff_phantom_02.p3);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_02.phantom ), "phantom_lc" );
	wake (e3m4_vo_phantomwraith);
	sleep (30 * 3);
//	cs_fly_to_and_face (ps_ff_phantom_02.p6, ps_ff_phantom_02.p8);
	cs_fly_to_and_face (ps_ff_phantom_02.p7, ps_ff_phantom_02.p6);
	sleep (30 * 1);
	
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	
	//======== DROP DUDES HERE ======================
	print ("ff_phantom_02 unloaded");
	sleep (30 * 5);
	cs_fly_to_and_face (ps_ff_phantom_02.p4, ps_ff_phantom_02.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_ff_phantom_02);
end

script command_script cs_ff_phantom_04()
	sleep (1);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_phantom_01.p0);
	cs_fly_by (ps_ff_phantom_01.p1);
	cs_fly_by (ps_ff_phantom_01.p2);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	cs_fly_to (ps_ff_phantom_01.p3);
	cs_fly_to (ps_ff_phantom_01.p4);
	cs_fly_by (ps_ff_phantom_01.p5);
	cs_fly_to (ps_ff_phantom_01.erase);
	ai_erase (ai_current_squad);
end

script command_script cs_ff_phantom_05()
	sleep (1);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_end_phantom_01.p0);
	cs_fly_by (ps_ff_end_phantom_01.p1);
	cs_fly_by (ps_ff_end_phantom_01.p2);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	cs_ignore_obstacles (FALSE);
	cs_force_combat_status (3);
end	

script command_script cs_ff_phantom_6()
	print ("phantom command script initiated");
	ai_place (sq_ff_wraith_02);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_10.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_ff_wraith_02.driver ) );
	cs_fly_to (ps_ff_phantom_e4m2_1.p1);
	notifylevel ("more_phantoms");
	f_unblip_ai_cui(e4_m2_ff_all);
	cs_fly_to (ps_ff_phantom_e4m2_1.p5);
	cs_fly_to_and_face (ps_ff_phantom_e4m2_1.p2, ps_ff_phantom_e4m2_1.p3);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_10.phantom ), "phantom_lc" );
	sleep (30 * 1);
		wake (e4m2_vo_underattack);
//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_squad, "dual");
			
//======== DROP DUDES HERE ======================

	sleep (30 * 3);
	cs_fly_to (ps_ff_phantom_e4m2_1.p5);
	cs_fly_to (ps_ff_phantom_e4m2_1.p1);
	cs_fly_to_and_face (ps_ff_phantom_e4m2_1.p8, ps_ff_phantom_e4m2_1.p8);
	ai_erase (sq_ff_phantom_10);
end

script command_script cs_ff_phantom_8()
	print ("phantom command script initiated");
	ai_place (sq_ff_wraith_01);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_13.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_ff_wraith_01.driver ) );
	cs_fly_to (ps_ff_phantom_10.p0);
	cs_fly_to (ps_ff_phantom_10.p1);
	cs_fly_to_and_face (ps_ff_phantom_10.p6, ps_ff_phantom_10.p2);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_13.phantom ), "phantom_lc" );
	sleep (30 * 1);
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	//======== DROP DUDES HERE ======================
	sleep (30 * 3);
	cs_fly_by (ps_ff_phantom_10.p3);
	cs_fly_by (ps_ff_phantom_10.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	cs_fly_by (ps_ff_phantom_10.p5);
	ai_erase (sq_ff_phantom_13 );
end

script command_script cs_ff_phantom_7()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (ai_current_actor, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
	f_load_phantom (sq_ff_phantom_12, "dual", guards_19_tower, guards_19_tower, guards_19_tower, guards_19_tower);
	cs_fly_to (ps_ff_phantom_e4m2_1.p1);
//	cs_fly_to (ps_ff_phantom_e4m2_1.p2);
	cs_fly_to (ps_ff_phantom_e4m2_1.p4);
	
		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (sq_ff_phantom_12, "dual");
			
		//======== DROP DUDES HERE ======================
	
	cs_fly_to (ps_ff_phantom_e4m2_1.p5);
//	cs_fly_to (ps_ff_phantom_e4m2_1.p6);
	cs_fly_to (ps_ff_phantom_e4m2_1.p7);
	cs_fly_to (ps_ff_phantom_e4m2_1.p8);
	ai_erase (sq_ff_phantom_12);
end

script command_script cs_ff_phantom_09()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
	f_load_phantom (sq_ff_phantom_09.phantom, "dual", cov_guard_17, cov_guard_18, none, none);
	sleep (30 * 1);
	cs_fly_to (ps_ff_phantom_09.p0);
	cs_fly_to (ps_ff_phantom_09.p1);
	cs_fly_to_and_face (ps_ff_phantom_09.p2, ps_ff_phantom_09.p3);
	sleep (30 * 1);
	
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	
	//======== DROP DUDES HERE ======================
	print ("ff_phantom_09 unloaded");
	sleep (30 * 5);
	cs_fly_to (ps_ff_phantom_09.p4);
	cs_fly_to (ps_ff_phantom_09.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	cs_fly_to (ps_ff_phantom_09.p6);
	sleep (30 * 4);
	ai_erase (sq_ff_phantom_09);
end

script command_script cs_ff_phantom_10()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	f_load_phantom (sq_ff_phantom_15.phantom, "dual", cov_guard_19, cov_guard_20, cov_guard_20, none);
	sleep (30 * 1);
	cs_fly_to (ps_ff_phantom_09.p0);
	cs_fly_to (ps_ff_phantom_09.p1);
	cs_fly_to_and_face (ps_ff_phantom_09.p2, ps_ff_phantom_09.p3);
	sleep (30 * 1);
	
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	
	//======== DROP DUDES HERE ======================
	print ("ff_phantom_09 unloaded");
	sleep (30 * 5);
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	cs_force_combat_status (3);
//	cs_fly_to (ps_ff_phantom_09.p4);
//	cs_fly_to (ps_ff_phantom_09.p5);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	cs_fly_to (ps_ff_phantom_09.p6);
//	sleep (30 * 4);
//	ai_erase (sq_ff_phantom_09);
end

script command_script cs_ff_phantom_11()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep (30 * 1);
	cs_fly_to (ps_ff_phantom_11.p0);
	cs_fly_to (ps_ff_phantom_11.p1);
	cs_fly_to (ps_ff_phantom_11.p2);
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	cs_force_combat_status (3);
end

script command_script cs_ff_phantom_12()
	print ("phantom command script initiated");
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	ai_place (squads_49);
	f_load_phantom (sq_ff_phantom_17.phantom, "dual", cov_guard_23, cov_guard_23, cov_guard_23, none);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_17.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( squads_49.driver ) );
	cs_fly_to (ps_ship_phantom_01.p0);
	cs_fly_to (ps_ship_phantom_01.p1);
	cs_fly_to_and_face (ps_ship_phantom_01.p2, ps_ship_phantom_01.p4);
	cs_fly_to (ps_ship_phantom_01.p5);
	cs_fly_to (ps_ship_phantom_01.p3);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_17.phantom ), "phantom_lc" );
	sleep (30 * 1);
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	//======== DROP DUDES HERE ======================
	sleep (30 * 3);
	ai_set_objective (cov_guard_23, ai_objectives_18);
	object_can_take_damage(ai_vehicle_get(ai_current_actor));
	cs_fly_by (ps_ff_phantom_09.p1);
	cs_fly_by (ps_ff_phantom_09.p0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (2);
	ai_erase (sq_ff_phantom_17 );
end


// PHANTOM ATTACK 1 =================================================================================================== 
script command_script cs_ff_ship_phantom_attack_1()
	cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
	cs_force_combat_status (3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep_s (.5);
	ai_exit_limbo (ai_current_squad);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
//	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.ship_phantom_01));
//	print ("can't shoot phantom_01")
//	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.ship_phantom_02));
//	print ("can't shoot phantom_02")
//	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.ship_phantom_03));
//	print ("can't shoot phantom_03")
//	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_e1m1_pelican_01.ship_phantom_04));
//	print ("can't shoot phantom_04")
//	object_cannot_take_damage (ai_vehicle_get_from_spawn_point (sq_ff_banshee_e3_m4_01.ship_phantom_04));
//	print ("can't shoot phantom_04")
	
end

// PHANTOM ATTACK 1 =================================================================================================== 
script command_script cs_ff_phantom_attack_2()
	cs_ignore_obstacles (TRUE);
	cs_fly_by (ps_ff_phantom_04.p0);
	cs_fly_by (ps_ff_phantom_04.p1);
	cs_fly_to (ps_ff_phantom_04.p2);
	cs_force_combat_status (3);
	sleep_until (b_game_ended == TRUE);	
	cs_fly_by (ps_ff_phantom_04.p3);
	cs_fly_to (ps_ff_phantom_04.erase);
	ai_erase (ai_current_squad);
end

script command_script cs_ff_phantom_attack_3()
	cs_ignore_obstacles (TRUE);
	cs_fly_by (ps_ff_phantom_04.p0);
	cs_fly_by (ps_ff_phantom_04.p1);
	cs_fly_to (ps_ff_phantom_04.p2);
	cs_force_combat_status (2);
end

script command_script cs_ff_banshee_attack_1()
	cs_fly_by (ps_ff_e3m4banshee_01.p1);
	cs_fly_by (ps_ff_e3m4banshee_01.p2);
	cs_fly_by (ps_ff_e3m4banshee_01.p3);
	cs_fly_by (ps_ff_e3m4banshee_01.p4);
	cs_fly_by (ps_ff_e3m4banshee_01.p5);
	cs_fly_by (ps_ff_e3m4banshee_01.p6);
	cs_force_combat_status (2);
end

// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================
script command_script cs_ff_pelican
	cs_ignore_obstacles (TRUE);
	ai_cannot_die (ai_current_squad, TRUE);
	sleep (1);
	cs_fly_to_and_face (ps_ff_pelican.p0, ps_ff_pelican.p1);
//	cs_shoot_point (TRUE, ps_ff_pelican.p7);
//	sleep (random_range (15, 90));
	cs_fly_by (ps_ff_pelican.p2);
	cs_fly_by (ps_ff_pelican.p5); 
	cs_fly_by (ps_ff_pelican.p6); 
	cs_fly_by (ps_ff_pelican.p3);
	cs_fly_by (ps_ff_pelican.p4);
	ai_erase (ai_current_squad);
end

script static void f_pelican_outro
	//start the pelican mini-vignette
	print ("pelican outro");
	object_cannot_take_damage (players());
	ai_disregard (players(), TRUE);
	player_camera_control (false);
	player_enable_input (FALSE);
	player_control_lock_gaze (player0, ps_ff_pelican.p1, 60);
	player_control_lock_gaze (player1, ps_ff_pelican.p1, 60);
	player_control_lock_gaze (player2, ps_ff_pelican.p1, 60);
	player_control_lock_gaze (player3, ps_ff_pelican.p1, 60);
	sleep (30 * 12);
	player_control_unlock_gaze (player0);
	player_control_unlock_gaze (player1);
	player_control_unlock_gaze (player2);
	player_control_unlock_gaze (player3);
	object_can_take_damage (players());
	ai_disregard (players(), false);
	player_camera_control (true);
	player_enable_input (true);
end

script command_script cs_outro_pelican
	ai_cannot_die (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_fly_to (ps_ff_pelican.p0);
	cs_fly_to_and_face (ps_ff_pelican.p1, ps_ff_pelican.p1);
	cs_pause(5);
	cs_fly_to (ps_ff_pelican.p2);
	ai_erase (ai_current_squad);
end

//script command_script cs_pelican_crash
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_pelican_crash.p0);
//	cs_fly_to_and_f (ps_pelican_crash.p1);
//	cinematic_set_title (title_pelican_crash);
//	cs_fly_to (ps_pelican_crash.p2);
//	effect_new_at_point_set_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_pelican_crash, 2);
//	thread(start_camera_shake_loop ("heavy", "low"));
//	sleep_s (1);
//	stop_camera_shake_loop();
//	print ("pelican destroyed");
//	ai_erase (ai_current_squad);
//end

script command_script cs_turret_1()
	repeat
		cs_shoot_point (TRUE, ps_ff_phantom_02.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_ff_phantom_02.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_ff_phantom_02.p2);
		sleep (random_range (15, 90));
	until (b_game_ended == TRUE, 1);
end

script continuous f_keep_marines_alive
	sleep_until (LevelEventStatus("marines_invul"), 1);
	ai_cannot_die (gr_ff_allies_1, true);
end

//script continuous f_invul_gennie
//	sleep_until (LevelEventStatus("m4_gennie_invul"), 1);
//	object_set_allegiance (destroy_obj_1, player);
//	object_immune_to_friendly_damage (destroy_obj_1, TRUE);
//	object_cannot_die (destroy_obj_1, TRUE);
//	object_cannot_take_damage (destroy_obj_1);
//end

//script continuous f_gennie_die
//	sleep_until (LevelEventStatus("m4_kill_genie"), 1);
//	object_immune_to_friendly_damage (destroy_obj_1, FALSE);
//	object_cannot_die (destroy_obj_1, FALSE);
//	object_can_take_damage (destroy_obj_1);
//end

script continuous f_start_events_goals_get_to_marines
	sleep_until (LevelEventStatus("goal_get_to_marines"), 1);
	sleep (30 * 4);
	sound_looping_start (music_start, NONE, 1.0);
	cinematic_set_title (get_to_marines);
end



// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================
script static void camera_test
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

// ==============================================================================================================
// ====== E1_M4_Sniperalley_Destroy==============================================================================
// ==============================================================================================================

//script static void f_start_player_intro
//	print ("start player intro");
//	firefight_mode_set_player_spawn_suppressed(true);
//end
//
//script continuous e1_m4_intro
//	sleep_until (LevelEventStatus ("start_intro"), 1);
//	sleep_s (8);
//	ex1();
//	firefight_mode_set_player_spawn_suppressed(false);
//	sleep_s (15);
//	ai_erase (squads_0);
//	ai_erase (squads_1);
//end

// ==============================================================================================================
// ====== FORERUNNER PAWN COMMAND SCRIPTS =======================================================================
// ==============================================================================================================

script command_script cs_pawn_spawn_e4m2
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end
//

script command_script cs_fore_turret_e4m2
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "resurrect", "control_marker");
end

script command_script forerunner_squads_0
	cs_phase_in();
end

//script command_script cs_bishop_spawn_end1()
//	ai_enter_limbo (ai_current_actor);
//	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ff_knight_back_attack_1.spawn_points_0), OnCompleteBishopBirth_end1, 0);
//cs_pause (1.0);
//end
//
//
//script command_script cs_bishop_spawn_end2()
//	ai_enter_limbo (ai_current_actor);
//	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ff_knight_back_attack_1.spawn_points_1), OnCompleteBishopBirth_end1, 0);
//cs_pause (1.0);
//end

script static void OnCompleteBishopBirth_end1()
print ("Bishop spawned");
end
