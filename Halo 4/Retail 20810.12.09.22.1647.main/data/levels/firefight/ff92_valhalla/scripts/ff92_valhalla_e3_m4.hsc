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


script startup valhalla_e3_m4

//Start the intro
	sleep_until (LevelEventStatus("e3_m4"), 1);
	print ("STARTING E3M4");
	switch_zone_set (e3_m4);
	mission_is_e3_m4 = true;
	ai_ff_all = e3_m4_ff_all;
	thread(f_music_e3m4_start());
	thread(f_start_player_intro_e3_m4());
	thread (mid_vignette_mantis());
//	thread (intro_vignette_e3_m4());
	thread (e3_m4_ord_drop_1());
	thread(e3_m4_master_script());
	
	
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
	f_add_crate_folder(cr_destroy_unsc_cover);										//UNSC crates and barriers around the dias
	f_add_crate_folder(cr_e3_m4_destroy_cov_cover);			
	f_add_crate_folder(unsc_ammo);			
	f_add_crate_folder(e3_m4_baseshields);	
	f_add_crate_folder(e3_m4_turret_bases);					//cov crates all around the main area
//	firefight_mode_set_crate_folder_at(dm_destroy_shields, 				3); //barriers that prevent getting behind the dias and to the large back middle area
//	firefight_mode_set_crate_folder_at(cr_power_core, 						4); //crates that blow up behind the dias
//	firefight_mode_set_crate_folder_at(cr_defend_unsc_cover, 			5);  //UNSC barriers 
//	firefight_mode_set_crate_folder_at(cr_capture, 								6); //Cov crates 
//	firefight_mode_set_crate_folder_at(v_e2_m4_pelican, 					7); //SA: pelican for the crash
										//SA: e1_m4 ammo boxes
	f_add_crate_folder(wp_power_weapons);												//power weapons spawns in the main area
	f_add_crate_folder(wp_cov_weapons); 													//SA: covey props for e2_m4
//	firefight_mode_set_crate_folder_at(cr_barriers, 							12); // nothing at the moment
//	firefight_mode_set_crate_folder_at(cr_destroy_shields, 				13); //barrier that prevent players from falling off the end of the large tunnel\
//	//firefight_mode_set_crate_folder_at(v_ff_for_d_turrets, 			14); //forerunner turrets
//	//firefight_mode_set_crate_folder_at(cr_f_temple_props, 			15); //various forerunner props all over the temple
//	//firefight_mode_set_crate_folder_at(dm_temple_props, 				16); //the large forerunner towers in the temple
	f_add_crate_folder(e3_m4_ammo_boxes);		
	f_add_crate_folder(e3_m4_unsc_ammo);												//shields blocking the exit for ESCAPE
  //firefight_mode_set_crate_folder_at(cr_destroy_temple_props,	19); //
	f_add_crate_folder(cr_e3_m3_temple_props);										// SA: props for snipper alley destroy, random forerunner spires and stuff
	f_add_crate_folder(e3_m3_forerunner_shield_switch);
	
  f_add_crate_folder(dc_capture_1);																// SA: temple props for Run
  f_add_crate_folder(dm_f_shields_3);											// shields blocking the bridge
  f_add_crate_folder(dm_e3_m3_drop_rails);
  f_add_crate_folder(v_ff_cov_ghosts);
  f_add_crate_folder(dc_turrets);
  
//set ammo crate names

	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e3_m4_spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(e3_m4_spawn_points_1, 91); //SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //SA Spawn location: in valley, facing into canyon
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
//	firefight_mode_set_objective_name_at(capture_obj_3, 			20); //in the leftside room
//	firefight_mode_set_objective_name_at(objective_switch_3, 	21); //SA switch location: upper front platform
//	firefight_mode_set_objective_name_at(objective_switch_4, 	22); //SA switch location: in the valley
	firefight_mode_set_objective_name_at(water_base_shield_switch, 	23); //VH switch location: water base shield switch
	firefight_mode_set_objective_name_at(cov_signal_jammer, 	24); //VH object destruction: cov signal jammer
	firefight_mode_set_objective_name_at(fore_water_base_thing, 	25); //VH switch location: water base shield switch
	firefight_mode_set_objective_name_at(cov_signal_jammer2, 	26); //VH object destruction: cov signal jammer
	firefight_mode_set_objective_name_at(turret_switch_0, 	27); //VH object destruction: cov signal jammer
	firefight_mode_set_objective_name_at(turret_switch_1, 	28); //VH object destruction: cov signal jammer
	firefight_mode_set_objective_name_at(turret_switch_2, 	29); //VH object destruction: cov signal jammer

	
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
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_1, 		1);	//VA: Rock perch in the front of water base
	firefight_mode_set_squad_at(gr_ff_cov_wraith_01, 			2);	//SA: mid level back of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_3, 		3);	//SA: back of main level of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_4, 		4); //SA: Side square platform
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_5,			5); //SA: Upper level, front of platform
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_6, 		6); //SA: front of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_7, 		7);	//SA: front entrance of temple before bridge
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_8, 		8);	//SA: Top of canyon
	firefight_mode_set_squad_at(sq_ff_marines_3, 					9); //SA: Middle of canyon
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_10, 		10); //SA: Bottom of temple
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_11, 		11); //SA: Top level right side
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_12, 		12); //SA: Top level left side
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_13,		13); //Next to 11, special AI tied to it
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_14, 		14); //Next to 12, special AI tied to it
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_15, 		15); //SA: near entrance to canyon
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_16, 		16); //SA: canyon
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_17, 		17); //SA: canyon
	firefight_mode_set_squad_at(gr_ff_e3_m4_guards_18, 	18); //SA: canyon, near tank, for destroy
//	firefight_mode_set_squad_at(gr_ff_guards_19_tower, 	19); //SA: canyon, near tower 1, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_01,				20); //SA: canyon, near tower 2, for destroy
	firefight_mode_set_squad_at(sq_ff_phantom_e3_m4_02, 			21); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_e3_m4_03, 			22); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_05, 			23); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_banshee_01, 			24); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_banshee_02, 			25); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_06, 			26); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_07, 			27); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_08, 			28); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_09, 			29); //SA: canyon, middle
	firefight_mode_set_squad_at(sq_ff_phantom_10, 			30); //SA: canyon, middle
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

global short covblowup = 0;

script command_script cs_ff_phantom_e3_m4_02()
	print ("phantom command script initiated");
	ai_place (cov_wraith_01);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep (30 * 1);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_ff_phantom_e3_m4_02.phantom ), "phantom_lc", ai_vehicle_get_from_spawn_point( cov_wraith_01.driver ) );
	cs_fly_to_and_face (ps_ff_phantom_02.p0, ps_ff_phantom_02.p1);
	cs_fly_to_and_face (ps_ff_phantom_02.p2, ps_ff_phantom_02.p3);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_ff_phantom_e3_m4_02.phantom ), "phantom_lc" );
	wake (e3m4_vo_phantomwraith);
	sleep (30 * 3);
//	cs_fly_to_and_face (ps_ff_phantom_02.p6, ps_ff_phantom_02.p8);
	cs_fly_to_and_face (ps_ff_phantom_02.p7, ps_ff_phantom_02.p6);
	sleep (30 * 1);
	
	//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	
	//======== DROP DUDES HERE ======================
	print ("ff_phantom_02 unloaded");
	cs_force_combat_status (3);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_ff_phantom_02.p4, ps_ff_phantom_02.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (ai_current_squad);
end

script command_script cs_phantom_e3m4_06()
	print ("phantom command script initiated");
	cs_ignore_obstacles (TRUE);
	print ("am i ingoring?");
	object_set_shadowless (ai_current_actor, TRUE);
	print ("am i shadowless?");
	ai_set_blind (ai_current_squad, TRUE);
	print ("am i blind?");
	cs_fly_by (ps_9.p1);
	print ("am i flying to my first point?");
	cs_fly_by (ps_9.p2);
	print ("am i flying to my second point?");
	cs_fly_by (ps_ff_phantom_01.p2);
	print ("am i flying to my third point?");
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
			
		//======== DROP DUDES HERE ======================
	print ("ff_phantom_01 unloaded");
	cs_force_combat_status (3);
	sleep (30 * 5);
	cs_fly_to (ps_ff_phantom_01.p3);
	cs_fly_to (ps_ff_phantom_01.p4);
	cs_fly_by (ps_ff_phantom_01.p5);
	cs_fly_to (ps_ff_phantom_01.erase);
	ai_erase (ai_current_squad);
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
// ====== E3_M4_Valhalla==============================================================================
// ==============================================================================================================

global boolean b_wait_for_e3m4narrative = false;
global boolean e3m4_narrative_is_on = FALSE;
global boolean b_dialog_playing = false;
global boolean b_objective_2 = false;



script static void f_start_player_intro_e3_m4
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s (1);
		//intro_vignette_e3_m4();
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
		fade_out (0,0,0,15);
		sleep_s (1);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m4_vin_sfx_intro', NONE, 1);
//		b_wait_for_e3m4narrative = true;
//		intro_vignette_e3_m4();
	end
	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until (b_players_are_alive(), 1);
	kill_volume_disable (kill_volumes_8);
	print ("player is alive");
	sleep_s (0.5);
	fade_in (0,0,0,15);
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e3_m4
	print ("_____________starting vignette__________________");
	//sleep_s (8);
//	b_wait_for_narrative = true;
//	e3m4_narrative_in();
	
// start VO
//thread (vo_e3m3_intro());
	
// wait until the puppeteer is complete
	print ("_____________done with vignette---SPAWNING__________________");
	thread(f_music_e3m4_vignette_finish());

//	firefight_mode_set_player_spawn_suppressed(false);
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
end

//script static void f_narrative_done
//	print ("narrative done");
//	b_wait_for_e3m4narrative = false;
//	print ("huh");
//end



script static void e3_m4_master_script
	
	thread (f_stragglers());
	print ("light em up.");
	
	thread (f_phantoms());
	print ("phantoms.");
	
	
	thread (f_misc_spawn_turrets());
	print ("Turret spawned in");
	
//	thread (e3_m4_ord_drop_1());
//	print ("Drop the shield");
	
	thread (e3m4_obj_01_end());
	print ("Second Drop Pod inbound");
	
	
	thread (e3m4_obj_02_end());
	print ("Second Drop Pod inbound");
	
	
	thread (e3m4_obj_03_end());
	print ("Finish Mountain's mission");
	
	thread (e3m4_obj_04_end());
	print ("Finish Mountain's mission");
	
	thread (mantiswave01());
	print ("Shit is about to get real");
	
	thread (e3m4_obj_05_end());
	print ("Shields are down");
	
	thread (e3m4_obj_06_end());
	print ("Tower goes boom");

	thread (e3m3_watchtower());
	print ("Turn off grav lift if blown up.");
	
	thread (f_heavyforces());
	print ("Big air battle at the end.");
	
	thread (f_e3_m4_interact());
	print ("You ever wonder why we're here?");
	
	
end

script static void f_power_up_switches_e3_m4
//	sleep_until (LevelEventStatus("e3_m4_t"), 1);
//	notifylevel ("ordnance01");
	device_set_power (turret_switch_0, 1);
	device_set_power (turret_switch_1, 1);
	device_set_power (turret_switch_2, 1);
end



script static void e3_m4_ord_drop_1
//	print ("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
	sleep_until (LevelEventStatus ("ordnance01"), 1);
	thread(f_music_e3m4_ord_drop_1());
	sleep_until (b_players_are_alive(), 1);
	object_destroy (fore_tower_1);
	object_destroy (fore_tower_2);
	object_destroy (waterfall_base_left_switch);
	object_destroy (waterfall_base_right_switch);
	b_wait_for_narrative_hud = true;
	sleep_s (2);
	print ("Defend the area.");
	thread(f_music_e3m4_playstart_vo());
	wake (e3m4_vo_playstart);
		sleep_s (1);
		sleep_until (e3m4_narrative_is_on == FALSE);
	thread(f_music_e3m4_marinereveal_vo());
	wake (e3m4_vo_marinereveal);
		sleep_s (1);
		sleep_until (e3m4_narrative_is_on == FALSE);
	thread(f_music_e3m4_hellbreaks_vo());
	wake (e3m4_vo_hellbreaks);
		sleep_s (1);
		sleep_until (e3m4_narrative_is_on == FALSE);
	sleep_until (s_all_objectives_count == 1);
//	sleep_s (3);
//	thread(f_music_e3m4_turret_1_online_vo());
//	wake (e3m4_vo_turret1online);
//		sleep_s (1);
//		sleep_until (e3m4_narrative_is_on == FALSE);
	thread(turretvo());
	sleep_until (s_all_objectives_count == 2);
	thread(turretvo());
//	sleep_s (2);
//	thread(f_music_e3m4_turret_2_online_vo());
//	wake (e3m4_vo_turret2online);
//		sleep_s (1);
//		sleep_until (e3m4_narrative_is_on == FALSE);
	sleep_until (ai_living_count (e3_m4_ff_all) <= 5);
		ai_place (sq_ff_phantom_09);
	
	sleep_forever();
end

script static void turretvo
	sleep_s (3);
	if s_all_objectives_count == 1 then 
	thread(f_music_e3m4_turret_1_online_vo());
	wake (e3m4_vo_turret1online);
	sleep_until (e3m4_narrative_is_on == FALSE);
	elseif s_all_objectives_count == 2 then
	thread(f_music_e3m4_turret_2_online_vo());
	wake (e3m4_vo_turret2online);
	sleep_until (e3m4_narrative_is_on == FALSE);
	end
end


script static void e3m4_obj_01_end
	sleep_until (LevelEventStatus ("obj1end"), 1);
	print ("good work crimson");
	sleep_s (2);
	thread(f_music_e3m4_turret3online_vo());
	wake (e3m4_vo_turret3online);
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	thread(f_music_e3m4_objective_d_6());
	f_new_objective (e3_m4_d_6);
	b_objective_2 = true;
end


script static void e3m4_obj_02_end
	sleep_until (LevelEventStatus ("obj2end"), 1);
	sleep_s (8);
	sleep_until (ai_living_count (e3_m4_ff_all) <= 5);
	f_new_objective (e3_m4_d_4);
	thread(f_music_e3m4_objective_d_4());
	ai_reset_objective (e3_m4_ff_all);
	ai_set_objective (e3_m4_ff_all, ai_objectives_2);
	sleep_until (ai_living_count (e3_m4_ff_all) <= 0);
	sleep_s (2);	
	object_create (lz_11);
	navpoint_track_object_named(lz_11, "navpoint_goto");
	print ("good work crimson");
	//	thread(f_music_e3m4_drop_vo());
	wake (e3m4_vo_mantisdrop);
	f_new_objective (e3_m4_d_5);
	thread(f_music_e3m4_objective_d_5());
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;
end
	
script static void f_stragglers
	repeat
		sleep_until (LevelEventStatus("finishthem"), 1);
		print ("more enemies event");
				
		sleep_until (ai_living_count (e3_m3_ff_all) <= 5);
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_lasttargets_01();
			vo_glo_lasttargets_02();
			vo_glo_lasttargets_03();
			vo_glo_lasttargets_04();
			vo_glo_lasttargets_05();
			vo_glo_lasttargets_06();
			vo_glo_lasttargets_07();
			vo_glo_lasttargets_08();
			vo_glo_lasttargets_09();
			vo_glo_lasttargets_10();
		
		end
		
		b_dialog_playing = false;
	ai_reset_objective (e3_m4_ff_all);
	ai_set_objective (e3_m4_ff_all, ai_objectives_2);
	f_blip_ai_cui(e3_m4_ff_all, "navpoint_enemy");	
	until (b_game_ended == true);
end

script static void f_stragglers_2
		print ("more enemies event");
				
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_lasttargets_01();
			vo_glo_lasttargets_02();
			vo_glo_lasttargets_03();
			vo_glo_lasttargets_04();
			vo_glo_lasttargets_05();
			vo_glo_lasttargets_06();
			vo_glo_lasttargets_07();
			vo_glo_lasttargets_08();
			vo_glo_lasttargets_09();
			vo_glo_lasttargets_10();
		
		end
		
		b_dialog_playing = false;

	f_blip_ai_cui(e3_m4_ff_all, "navpoint_enemy");	
end

script static void f_phantoms
	repeat
		sleep_until (LevelEventStatus("skykillers"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
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

script static void e3m4_obj_03_end
	sleep_until (LevelEventStatus ("obj3end"), 1);
	print ("good work crimson");
	f_new_objective (e3_m4_d_10);
	thread(f_music_e3m4_objective_d_10());
	
end

script static void e3m4_obj_04_end
	sleep_until (LevelEventStatus ("obj4end"), 1);
	print ("good work crimson");
	f_new_objective (e3_m4_d_6);
	thread(f_music_e3m4_objective_d_6());
end

script static void e3m4_obj_05_end
	sleep_until (LevelEventStatus ("obj5end"), 1);
	print ("good work crimson");
	f_new_objective (e3_m4_d_7);
	thread(f_music_e3m4_objective_d_7());
end

script static void e3m4_obj_06_end
	sleep_until (LevelEventStatus ("obj6end"), 1);
	
	
	thread	(shipboom01());
	print ("good work crimson");
	
end

script static void f_heavyforces
	repeat
		sleep_until (LevelEventStatus("itcamefromthesky"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
		begin_random_count (1)
			vo_glo_heavyforces_01();
			vo_glo_heavyforces_02();
			vo_glo_heavyforces_03();
			vo_glo_heavyforces_04();
			vo_glo_heavyforces_05();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end


script static void mid_vignette_mantis
	sleep_until (LevelEventStatus ("mantisdrop"), 1);
//player fozen and matis dropped
	print ("mantis incoming");
//cinematic_show_letterbox (true);
	object_cannot_take_damage (players());
	ai_disregard (players(), TRUE);
	player_camera_control (false);
	player_enable_input (FALSE);
	
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m4_vin_sfx_midtro', NONE, 1);
	cinematic_start();
	pup_play_show (e3_m4_mantis);
	print ("new puppeteer");
	thread (e3m4_rvb_switch());
	sleep_s (19);
	object_cannot_take_damage (e3_m4_rvb);
	player_mantis();
end



script static void player_mantis
//player can move again
	f_add_crate_folder(e3_m4_ff_mantis); 	
	print ("grab that mantis");
	sleep_s (1);
	cinematic_stop();
//cinematic_show_letterbox (false);
	object_can_take_damage (players());
	ai_disregard (players(), false);
	player_camera_control (true);
	player_enable_input (true);
	thread (e3m4_mantishealthblip(mantis_1));
	thread (e3m4_mantishealthblip(mantis_2));
	thread (e3m4_mantishealthblip(mantis_3));
	thread (e3m4_mantishealthblip(mantis_4));
end 

script static void banshee_01
	sleep_until (LevelEventStatus ("banshee1"), 1);
	thread(f_music_e3m4_banshee_01());
	print ("banshees inbound");
	ai_place (sq_ff_banshee_01);
	sleep_s (5);
	ai_place (sq_ff_banshee_02);
	sleep_s (4);
	thread(f_music_e3m4_airincoming_vo());
	wake (e3m4_vo_airincoming);
	ai_place (sq_ff_phantom_14);
	thread (banshee_02());
end

script static void banshee_02
	sleep_until (LevelEventStatus ("banshee2"), 1);
	thread(f_music_e3m4_banshee_02());
	print ("banshees inbound");
	ai_place (sq_ff_banshee_01);
	sleep_until (ai_living_count (sq_ff_phantom_14) == 0);
	ai_place (sq_ff_phantom_14);
	thread(f_music_e3m4_covcruiser());
	wake (e3m4_vo_covcruiser);
	sleep_s (1);
		sleep_until (e3m4_narrative_is_on == FALSE);
	thread(f_music_e3m4_extractask());
	wake (e3m4_vo_extractask);
	sleep_s (1);
		sleep_until (e3m4_narrative_is_on == FALSE);
end	


// ===================================================================================
//=====================================TURRETS=======================================
// ===================================================================================

//currently when called turrets will be around forever
script command_script cs_stay_in_turret
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (FALSE);
	cs_abort_on_alert (FALSE);
end

script static void InspectDevice(device object)
	inspect(object);
end
/*
script static void f_create_turret_1
	//object_create_anew (turret_switch_1);
	
//	f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b");
end
*/
script static void f_misc_spawn_turrets
	ai_place (sq_ff_marines_3);
	print ("::TURRETS::");
	sleep_until (object_valid (turret_switch_0));
	object_set_scale (turret_switch_0, 2, 1);
//print("Turret Status");
	InspectDevice(turret_switch_0);
//	InspectObject(turret_switch_1);
	thread (f_turret_place (turret_1.pilot_0, turret_switch_0));
	sleep_until (object_valid (turret_switch_1));
	object_set_scale (turret_switch_1, 2, 1);
	InspectDevice(turret_switch_1);
	thread (f_turret_place (turret_1.pilot_1, turret_switch_1));
	//NotifyLevel ("start_turrets");
	sleep_until (object_valid (turret_switch_2));
	object_set_scale (turret_switch_2, 2, 1);
	InspectDevice(turret_switch_2);
	thread (f_turret_place (turret_1.pilot_2, turret_switch_2));
//	NotifyLevel ("start_turrets");
end



script static void f_turret_place (ai turret_spawn, device dm_switch)
	ai_place (turret_spawn);
	print ("placing turret");
	//set up the turret so it waits until it's ready to be activated
	
	local unit turret_object = ai_vehicle_get(turret_spawn);

	ai_cannot_die (turret_spawn, true);
	object_cannot_take_damage(turret_object);
	ai_disregard (ai_actors (turret_spawn), true);
	ai_braindead (turret_spawn, TRUE);
	sentry_deactivate(turret_object);
	sentry_deactivate_barrel(turret_object, 0);
	sentry_deactivate_barrel(turret_object, 1);
	print ("testing turret");
	sleep_until (LevelEventStatus("start_turrets"), 1);
	//turret is now ready to be turned powered on by the player flipping the switch
	print ("powering up turrets");
	//sleep(1);
	inspect (dm_switch);
	device_set_power (dm_switch, 1);
	inspect (device_get_power (dm_switch));
	//device_set_position_immediate (dm_switch, 0);
	sleep_until (device_get_position (dm_switch) != 0);
	//the switch is flipped and is now activing shooting at fools
	f_turret_ai (turret_spawn, dm_switch);
end

script static void f_turret_ai (ai turret_ai, device switch)
	print ("turret online!");

//
// Associate the turret AI with the player.
//
	ai_object_set_team (turret_ai, player);
// Turn of the navpoint marker.
	f_unblip_object_cui (ai_get_object (turret_ai));

//Get the actual turret object.
	local unit turret_object = ai_vehicle_get(turret_ai);
	ai_object_set_team (turret_object, player);

// Activate the sentry and its barrels.
	sentry_activate(turret_object);
	sentry_activate_barrel(turret_object, 0);
	sentry_activate_barrel(turret_object, 1);

// Restore the sentry turrets health.
	object_set_health (turret_object, 1);

// Prevent the turret from being destroyed.
	object_cannot_die(turret_object, true); 
	object_can_take_damage(turret_object);

// Wake up the turret AI so that it can be attacked.
	ai_braindead_by_unit (turret_object, false);
	ai_disregard (ai_actors (turret_ai), false);
	ai_disregard(turret_object, false);

// Sleep until the turret is destroyed.
	sleep_until(object_get_health(turret_object) <= 0.01);

	print ("turret is damaged – closing");

// Prevent AI from targeting the turret.
	ai_braindead_by_unit (turret_object, true);
	ai_disregard (ai_actors (turret_ai), true);
	ai_disregard(turret_object, true);

// Deactivate the turret.
	sentry_deactivate(turret_object);
	sentry_deactivate_barrel(turret_object, 0);
	sentry_deactivate_barrel(turret_object, 1);

// Sleep until the turret is available again.
//	sleep (300); 

// Prevent more damage on the turret.
	object_cannot_take_damage (turret_object); 

// Reset the turret switch so it can be reactivated.
//device_set_position_immediate (switch, 0);
//	until (b_objective_2 == true); 
end




/* 
	Plays the external explosions on the covenant cruisers in the Maw vignette. This particular function is for the "fx_explode_XX" markers
	that are located on the surface of the ship, as opposed to the fx_cov_cruiser_explosions2() function that is for the "fx_ship_explodeXX" markers that
	are for the internal explosions of the ship.
	
	inputs:
		oCruiser 	The name of the device machine that is getting the effect
		nMarker		The marker number (1-8) that gets the explosion
*/

script static void fx_cov_cruiser_explosions( object oCruiser, short nMarker )
	dprint("Cruiser external explosion");	
	if (1 == nMarker) then
		//effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship, fx_explode_01);
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_01);
	elseif (2 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_02);
	elseif (3 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_03);
	elseif (4 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_04);
	elseif (5 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_05);
	elseif (6 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_06);
	elseif (7 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_07);
	elseif (8 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_08);
	end
end

/* 
	Plays the internal explosions on the covenant cruisers in the Maw vignette.	
	inputs:
		oCruiser 	The name of the device machine that is getting the effect
		nMarker		The marker number (1-11) that gets the explosion
*/

script static void fx_cov_cruiser_explosions2( object oCruiser, short nMarker )
	dprint("Cruiser internal explosion");	
	if (1 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode01);
	elseif (2 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode02);
	elseif (3 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode03);
	elseif (4 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode04);
	elseif (5 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode05);
	elseif (6 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode06);
	elseif (7 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode07);
	elseif (8 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode08);
	elseif (9 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode09);
	elseif (10 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode10);
	elseif (11 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode11);
	end
end


script static void shipboom01
	print ("Hello cov ship");
	object_create_anew (beacon_cruiser);

	pup_play_show (e3_m4_shotdown);
//	object_create_anew (valhalla_octopus_4);
//	object_create_anew (start_cruiser);
//	object_hide (valhalla_octopus_4, true);
//	object_hide (start_cruiser, true);
//	object_set_scale ((valhalla_octopus_4), 0.01, 1 ); //Shrink size over time
//	sleep_s(1);
//	print ("You can see me now");
//	object_hide (valhalla_octopus_4, false);
//	object_hide (start_cruiser, false);
//	print ("Are you sure you can see me");
//	object_set_scale ((valhalla_octopus_4), 0.50, 160 ); //Shrink size over time
//	sleep_s (5);
//	object_rotate_by_offset (valhalla_octopus_4, 5, 5, 5, 20.28, 11.15, -8.3);
//	sleep_s(5);
//	shipboom02();
	//object_set_scale ((beacon_cruiser), 0.25, 20 ); //Shrink size over time
end

script static void shipboom02
	thread(f_music_e3m4_shipboom01_puppeteer());
//	object_destroy (valhalla_octopus_4);
//	object_create_anew (beacon_cruiser);
//
//	pup_play_show (e3_m4_shotdown);
	covblowup = 1;
	sleep_s (1);
	navpoint_track_object_named(beacon_cruiser, "navpoint_enemy");
	object_create_anew (e3m4_blowup_missile);
	sleep_s (9);

	thread(f_music_e3m4_wrapup_vo());
	wake (e3m4_vo_wrapup);
	
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	thread(f_music_e3m4_finish());
	sleep_s (4);
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//  sleep (90);
	f_e3_m4_end_mission();
  b_end_player_goal = TRUE;
end

script static void f_e3_m4_end_mission

	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end



script static void shipwave01
//	f_add_crate_folder(e3_m4_ff_mantis);
	f_new_objective (e3_m4_d_7);
	object_create (lz_e3m4);
	navpoint_track_object_named(lz_e3m4, "navpoint_goto");
//	object_create_anew (beacon_cruiser);
//	object_hide (beacon_cruiser, true);
//	object_set_scale ((beacon_cruiser), 0.01, 1 ); //Shrink size over time
//	sleep_s(1);
//	print ("You can see me now");
//	object_hide(beacon_cruiser, false);
//	print ("Are you sure you can see me");
//	object_set_scale ((beacon_cruiser), 0.30, 160 ); //Shrink size over time
	sleep_s (2);
	sleep_until (volume_test_players (location_e3_m4_beach), 1);
	object_destroy (lz_e3m4);
	sleep_s (2);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	notifylevel("itcamefromthesky");
	f_music_e3m4_banshee_02();
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (2);
	ai_place_in_limbo (sq_ff_phantom_e3m4_01);
	sleep_s (2);
	ai_place_in_limbo (sq_ff_phantom_e3m4_02);
	sleep_s (1);
	sleep_until (ai_living_count (e3_m4_cruiser_attack) <= 2, 1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
//	ai_place_in_limbo (sq_ff_phantom_e3m4_02);
	sleep_s (2);
	ai_place_in_limbo (sq_ff_phantom_e3m4_01);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (15);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	sleep_until (ai_living_count (e3_m4_cruiser_attack) <= 3, 1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_01);
	sleep_until (ai_living_count (sq_ff_phantom_e3m4_01) <= 1, 1);

	
	ai_place_in_limbo (sq_ff_phantom_e3m4_01);
	sleep_s (4);
	ai_place_in_limbo (sq_ff_phantom_e3m4_02);
	vo_glo_lasttargets_05();
	sleep(2);
	f_blip_ai_cui(e3_m4_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e3_m4_ff_all) <= 0, 1);
	sleep_s (2);
	thread(f_music_e3m4_frigate_vo());
	wake (e3m4_vo_frigate);
	sleep_s (1);
	thread (shipboom02());
	sleep_until (e3m4_narrative_is_on == FALSE);
	
end


script static void mantiswave01
	sleep_until (LevelEventStatus ("mantisrun"), 1);
//	f_add_crate_folder(e3_m4_ff_mantis);
//	navpoint_track_object_named (obj, type);
	f_new_objective (e3_m4_d_10);
	thread(f_music_e3m4_objective_d_10());
	navpoint_track_object_named(mantis_1, "navpoint_driver");
	navpoint_track_object_named(mantis_2, "navpoint_driver");
	navpoint_track_object_named(mantis_3, "navpoint_driver");
	navpoint_track_object_named(mantis_4, "navpoint_driver");
	ai_place (sq_ff_phantom_16);
	sleep_s (1);
	ai_place (sq_ff_phantom_15);
	
	sleep_until (volume_test_players (location_mantis_drop), 1);
	f_unblip_object_cui(mantis_1);
	f_unblip_object_cui(mantis_2);
	f_unblip_object_cui(mantis_3);
	f_unblip_object_cui(mantis_4);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	wake (e3m4_vo_airincoming);
	f_music_e3m4_airincoming_vo();
	thread (mantiswavebansheeloop());
	sleep_until (ai_living_count (e3_m4_ff_all) <= 10, 1);
	f_stragglers_2();
	sleep_until (ai_living_count (e3_m4_mantis_phantom_01) <= 0, 1);
		print ("Phantoms Dead");
		sleep_until (ai_living_count (e3_m4_ff_all) <= 0, 1);
		print ("Everyone Dead");
		
		sleep_s (15);
		ai_place_in_limbo (cov_guard_21);
		thread (f_load_drop_pod (dm_drop_03, cov_guard_21, drop_pod_lg_01, false));
		navpoint_track_object_named(drop_pod_lg_01, "navpoint_enemy_vehicle");
		
		sleep_s (20);
		ai_place_in_limbo (cov_guard_19);
		thread (f_load_drop_pod (dm_drop_02, cov_guard_19, drop_pod_lg_02, false));
		navpoint_track_object_named(drop_pod_lg_02, "navpoint_enemy_vehicle");
	thread (mantiswave02());
end
	
script static void mantiswavebansheeloop
	sleep_until (ai_living_count (sq_ff_banshee_e3_m4_02) <= 1, 1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	sleep_s (0.5);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	sleep_until (ai_living_count (sq_ff_banshee_e3_m4_02) <= 1, 1);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	sleep_s (1);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
	sleep_s (0.5);
	ai_place_in_limbo (sq_ff_banshee_e3_m4_02);
end

script static void mantiswave02
	sleep_until (ai_living_count (e3_m4_ff_all) <= 3, 1);
	f_new_objective (e3_m4_d_6);
	ai_place_in_limbo (cov_guard_22);
	sleep_s (5);
	thread (f_load_drop_pod (dm_drop_01, cov_guard_22, drop_pod_lg_02, false));
	navpoint_track_object_named(drop_pod_lg_02, "navpoint_enemy_vehicle");
	sleep_s (2);
	sleep_until (ai_living_count (e3_m4_ff_all) <= 5, 1);
	ai_reset_objective (cov_wraith_01);
	ai_set_objective (cov_wraith_01, ai_objectives_wraith_1);
		sleep_s (1);
	ai_place (sq_ff_phantom_17);


	sleep_s (9);
	sleep_until (ai_living_count (e3_m4_ff_all) <= 5, 1);
	ai_place_in_limbo (cov_guard_19);
	sleep_s (1);
	thread (f_load_drop_pod (dm_drop_05, cov_guard_19, drop_pod_lg_02, false));
	navpoint_track_object_named(drop_pod_lg_02, "navpoint_enemy_vehicle");
	thread (mantiswavebansheeloop());
	wake (e3m4_vo_covcruiser);
	f_music_e3m4_covcruiser();
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	sleep_until (ai_living_count (sq_ff_banshee_e3_m4_02) <= 2, 1);
	ai_set_objective (sq_ff_banshee_e3_m4_02, ai_objectives_14);
	sleep_until (ai_living_count (e3_m4_mantis_phantom_01) <= 0, 1);
	sleep_s (5);
	thread(f_music_e3m4_extractask());
	wake (e3m4_vo_extractask);
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	ai_place_in_limbo (cov_guard_23);
	ai_reset_objective (cov_guard_23);
	ai_set_objective (cov_guard_23, ai_objectives_19);
	sleep_s (1);
	thread (f_load_drop_pod (dm_drop_03, cov_guard_23, drop_pod_lg_02, false));
	navpoint_track_object_named(drop_pod_lg_02, "navpoint_enemy_vehicle");
	wake (e3m4_vo_wayout);
	sleep_s (1);
	sleep_until (e3m4_narrative_is_on == FALSE);
	sleep_s (3);

	thread (shipwave01());
end

script static void e3m4_watchtower
	sleep_until(object_get_health(cov_watch_top) <= 0);
	object_set_phantom_power(cov_watch_base, false);
end

script static void e3m4_mantishealthblip (object_name veh)
	repeat
	sleep_until (object_get_health (veh) <= 0, 1);
	sleep_s (5);
	object_create_anew (veh);
	navpoint_track_object_named(veh, "navpoint_driver");
	sleep_until ((vehicle_test_seat (unit(veh), mantis_d) == 1) or (object_get_health (veh) <= 0), 1);
	f_unblip_object_cui(veh);

//	elseif object_get_health (mantis_2) == 0 then
//	sleep_s (5);
//	object_create_anew (mantis_2);
//	navpoint_track_object_named(mantis_2, "navpoint_driver");
//	elseif object_get_health (mantis_3) == 0 then
//	sleep_s (5);
//	object_create_anew (mantis_3);
//	navpoint_track_object_named(mantis_3, "navpoint_driver");
//	elseif object_get_health (mantis_4) == 0 then
//	sleep_s (5);
//	object_create_anew (mantis_4);
//	navpoint_track_object_named(mantis_4, "navpoint_driver");

	until (b_game_ended == true);	
end




// ==============================================================================================================
// ====== EASTER EGGS ===============================================================================
// ==============================================================================================================



script static void f_e3_m4_interact
                print ("start RVB");
                object_create_anew (e3_m4_rvb);
                sleep_until (object_get_health (e3_m4_rvb) < 1, 1);
                print ("rvb interacted");
                object_cannot_take_damage (e3_m4_rvb);
                // f_new_objective (rvb_confirm);
                b_rvb_interact = true;
                inspect (b_rvb_interact);
                f_achievement_spops_1();
                //play stinger
                sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
								sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme'));

end

script static void e3m4_rvb_switch
//	repeat
		if b_rvb_interact == true then
			wake (e3m4_rvb);
		end
//	until (b_game_ended == true);
end


script dormant e3m4_rvb

	sleep_until (e3m4_narrative_is_on == FALSE);
	e3m4_narrative_is_on = TRUE;

	// RvB_Simmons : Hold tight ground forces.  We are inbound with reinforcements.
	dprint ("RvB_Simmons: Hold tight ground forces.  We are inbound with reinforcements.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00100'));
	
	// RvB_Simmons : Don't want to say exactly what, but you'll like 'em.
	dprint ("RvB_Simmons: Don't want to say exactly what, but you'll like 'em.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00200'));
	
	// RvB_Grif : It's giant robots.
	dprint ("RvB_Grif: It's giant robots.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00300'));
	
	// RvB_Simmons : What?  Grif!  You ruined the surprise!  You have no flair for the dramatic!
	dprint ("RvB_Simmons: What?  Grif!  You ruined the surprise!  You have no flair for the dramatic!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00400'));
	
	// RvB_Grif : They're in battle, idiot!  How dramatic do you want it to get?
	dprint ("RvB_Grif: They're in battle, idiot!  How dramatic do you want it to get?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_04\rvb_e3m4_mantisdrop_00500'));
	
	e3m4_narrative_is_on = FALSE;
end
	

script command_script cs_e4_m3_banshee

                thread (f_e4_m3_kill_banshees(ai_current_actor));
                print ("cs_banshee");
                cs_ignore_obstacles (false);
                cs_enable_pathfinding_failsafe (TRUE);
                cs_force_combat_status (3);
                object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
                sleep_s (.5);
                ai_exit_limbo (ai_current_squad);
                object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
                
end

script static void f_e4_m3_kill_banshees (ai banshee_actor)
                print ("kill banshee after 5 minutes");
                //sleep (5 * 60 * 30);
                sleep_until(ai_living_count(banshee_actor) <= 0,1,5*60 * 30);
                unit_kill (ai_vehicle_get(banshee_actor));
                print ("kill this banshee");
end
	
	