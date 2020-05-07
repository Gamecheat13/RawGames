//========== SNIPER ALLEY FIREFIGHT SCRIPT E4 M1========================================================
// =============================================================================================================================

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//========= MISSION SCRIPT ==================================================================
// =============================================================================================================================



script startup sniper_alley_e4_m1

//Start the intro
	sleep_until (LevelEventStatus("e4_m1"), 1);
	switch_zone_set (e4_m1);
	mission_is_e4_m1 = true;
	b_wait_for_narrative = true;
	ai_ff_all = e4_m1_gr_ff_all;
	thread(f_start_player_intro_e4_m1());
	thread(f_music_e4m1_start());
	thread (e4_m1_master_script());

	//destroy the old watchtower
	object_destroy (e2m4_base1);
	object_destroy (e1m4_base1);
	object_destroy(e1m4_pod1);
	print ("destroying base");

	//f_add_crate_folder(eq_e1_m4_unsc_ammo);
	f_add_crate_folder(cr_e4_m1_cov_props); 								// Cov Cover and fluff in the meadow
	f_add_crate_folder(cr_e4_m1_cov_props_1); 								// Cov Cover and fluff in the meadow
	f_add_crate_folder(dc_e4_m1); 								// Cov Cover and fluff on the back bridge
	f_add_crate_folder(cr_e4_m1_ammo);
	f_add_crate_folder(dm_e4_m1_drop_rails);
	f_add_crate_folder(cr_e4_m1_fore_objective);
	f_add_crate_folder(dm_e4_m1_objectives);
	f_add_crate_folder(cr_e1_m2_ammo);
	f_add_crate_folder(eq_e1_m2_unsc_ammo);
	
//f_add_crate_folder(dm_e1_m4_shields_1);						// ??
//f_add_crate_folder(dm_e1_m4_bridge_shields); // shields blocking the bridge
//  f_add_crate_folder(dm_e1_m4_drop_rails);
//f_add_crate_folder(wp_e1_m4_bridge_weapons);

//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
//	f_add_crate_folder(eq_defend_1_crates); //ammo crates in front middle area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
//	



//Switches
//	f_add_crate_folder(e2m2_objcoverswitches); //Switches for E2M2
	
//==SET OBJECTS
//set spawn folder names
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_1, 91); //SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_4, 94); //SA Spawn location: in valley, facing into canyon
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_5, 95); //SA Spawn location: in middle of the canyon, facing towards temple
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_6, 96); //SA Spawn location: back of temple, middle, as a group
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_7, 97); //SA Spawn location: near end of valley to cayon, facing into valley
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_8, 98); //SA Spawn location: middle of the valley, facing towards the canyon
	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_9, 99); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
//	firefight_mode_set_crate_folder_at(e4_m1_spawn_points_10, 100); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple	
	
//set objective names

	firefight_mode_set_objective_name_at(e4_m1_objective_switch_1, 	1); //SA switch location: in the middle, but the bridge
	firefight_mode_set_objective_name_at(e4_m1_objective_switch_2, 	2); //SA switch location: side square open platform, main level


	
	firefight_mode_set_objective_name_at(lz_e4_m1_0, 	50); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(lz_e4_m1_1, 	51); //SA objective location: front pad of temple
	firefight_mode_set_objective_name_at(lz_e4_m1_2, 	52); //SA objective location: near middle of temple
	firefight_mode_set_objective_name_at(lz_e4_m1_3, 	53); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(lz_e4_m1_4, 	54); //SA objective location: on lower platform by ramp to upper level, leading to back of canyon
	firefight_mode_set_objective_name_at(lz_e4_m1_5, 	55); //SA objective location: entrance to canyon from valley
	firefight_mode_set_objective_name_at(lz_e4_m1_6, 	56); //SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(lz_e4_m1_7, 	57); //SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(lz_e4_m1_8, 	58); //SA objective location: middle of the valley
	firefight_mode_set_objective_name_at(lz_e4_m1_9, 	59); //SA objective location: bottom of the ramp, towards the back of the temple
	firefight_mode_set_objective_name_at(lz_e4_m1_10, 60); //SA objective location: lower bend in the canyon
//	firefight_mode_set_objective_name_at(lz_e4_m1_11, 61); //SA objective location: upper bend in the canyon

//set squad group names
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_1, 				1);	//SA: back of temple
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_2, 				2);	//SA: mid level back of temple
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_3, 				3);	//SA: back of main level of temple
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_4, 				4); //SA: Side square platform
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_5, 				5); //SA: Upper level, front of platform
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_6, 				6); //SA: front of temple
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_7, 				7);	//SA: front entrance of temple before bridge
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_8, 				8);	//SA: Top of canyon
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_9, 				9); //SA: Middle of canyon
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_10, 				10); //SA: Bottom of temple
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_11, 				11); //SA: Top level right side
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_12, 				12); //SA: Top level left side
//	firefight_mode_set_squad_at(e4_m1_gr_ff_attack_squad_a, 	13); //Next to 11, special AI tied to it
//	firefight_mode_set_squad_at(e4_m1_gr_ff_attack_squad_b, 	14); //Next to 12, special AI tied to it
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_15, 				15); //SA: near entrance to canyon
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_16, 				16); //SA: canyon
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_17, 				17); //SA: canyon
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_18,			 	18); //SA: canyon, near tank, for destroy
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_19_tower, 	19); //SA: canyon, near tower 1, for destroy
//	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_20_tower,	20); //SA: canyon, near tower 2, for destroy
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_21, 				21); //SA: canyon, middle
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_22, 				22); //SA: middle of mid level, near back of temple
	firefight_mode_set_squad_at(e4_m1_gr_ff_guards_23, 				23); //SA: middle of mid level, near front of temple
	firefight_mode_set_squad_at(e4_m1_sq_ff_phantom_06, 			24); //SA: middle of mid level, near front of temple
	firefight_mode_set_squad_at(e4_m1_sq_ff_phantom_attack_2, 				25); //SA: middle of mid level, near front of temple	
	
	
//	firefight_mode_set_squad_at(gr_waves_1, 						51); //SA: middle of mid level, near front of temple

	firefight_mode_set_squad_at(e4_m1_gr_waves_1, 			80);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_1, 		81);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_2, 		82);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_3, 		83);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_4, 		84);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_5, 		85);
	firefight_mode_set_squad_at(e4_m1_gr_ff_waves_6, 		86);

	
//	firefight_mode_set_squad_at(gr_ff_allies_1, 71); //tunnel
//	firefight_mode_set_squad_at(gr_ff_allies_2,	72); //behind the dias

end

// ==============================================================================================================
//====== E1_M4_Sniperalley_Destroy==============================================================================
// ==============================================================================================================

global boolean b_wait_for_e4m1narrative = false;
global boolean e4m1_narrative_is_on = FALSE;

script static void e4_m1_master_script
	//thread all the objective scrips

	
	thread (f_e4_m1_starting_goal());
	print ("thread starting goal");
	
	thread (e4_m1_turrets_1());
	print ("threading end_e4_m1_1");
	
	thread (f_e4_m1_2_end());
	print ("thread f_e4_m1_2_end");

	thread (f_e4_m1_3_start());
	print ("thread f_e4_m1_3_start");
	
	thread (f_e4_m1_second_goal());
	print ("thread f_e4_m1_4_end");
	
	thread (f_e4_m1_third_goal());
	print ("thread e4_m1_5_start");
	
	thread (f_e4_m1_mid_goal());
	print ("thread e4_m1_6_start");
	
	thread (f_e4_m1_mid_goal_1());
	print ("thread e4_m1_d_2_1");
	
	thread (f_e4_m1_7_start());
	print ("thread e4_m1_7_start");
	
	thread (f_e4_m1_8_start());
	print ("thread f_e4_m1_8_start");
	
	thread (f_e4_m1_end_goal());
	print ("thread e4_m1_9_start");
	
	thread (f_e4_m1_final_goal());
	print ("thread final goal");
	
	dm_droppod_1 = dm_e4_m1_drop_1;
	dm_droppod_5 = dm_e4_m1_drop_5;

end

//==START INTRO
script static void f_start_player_intro_e4_m1
	firefight_mode_set_player_spawn_suppressed(true);
	
	if editor_mode() then
		//firefight_mode_set_player_spawn_suppressed(false);
		sleep_s (1);
		//f_e4_m1_intro_vignette();
		//b_wait_for_narrative = false;
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
		f_e4_m1_intro_vignette();
	end
	
	
	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	sleep_s (0.5);
	fade_in (0,0,0,15);
	//sleep_s (1);
end

script static void f_e4_m1_intro_vignette
	//start the vignette
	
	print ("_____________starting vignette__________________");
	//sleep_s (8);
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e4m1_vin_sfx_intro', NONE, 1);
	
	cinematic_start();

	ai_enter_limbo (e4_m1_gr_ff_all);
	print ("all ai placed in limbo for the puppeteer");
	
	thread(f_music_e4m1_start_vignette());
	object_create (veh_pup_shade_01);
	pup_play_show (e4m1_narrative_in);
	vo_e4m1_intro();
	//sleep_s (6);
	//thread (f_e4_m1_starting_goal());
	
	sleep_until (b_wait_for_narrative == false);
	
	//delete the puppetshow specific AI
	object_destroy (veh_pup_shade_01);
	ai_erase (sq_e4m1_grunts);
	
	thread(f_music_e4m1_finish_vignette());
	
	cinematic_stop();
	
	ai_exit_limbo (e4_m1_gr_ff_all);
	print ("all ai exiting limbo after the puppeteer");
	
	print ("_____________done with vignette---SPAWNING__________________");
	
	
end


//this script is called at the end of the puppeteer
script static void f_e4_m1_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end

// ========================================================================================
//== START OBJECTIVE SCRIPTS
// ========================================================================================


//the starting script
script static void f_e4_m1_starting_goal
	
	sleep_until (b_players_are_alive(), 1);
	print ("players are alive, starting thread");
	
	b_wait_for_narrative_hud = true;
		
	thread(f_music_e4m1_starting_goal());
	
	//start looking for the players to go through the trigger volume
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	thread (f_e4_m1_obj_tracker(flag_0, tv_e4_m1_loc_1));
		
	//place some AI
	//object_destroy (veh_pup_shade_01);
	ai_place (e4_m1_shade_2);
	ai_place (e4_m1_shade_3);
	ai_place (e4_m1_pelican_drop_off);
	ai_place (e4_m1_initial_grunts);
	thread (f_e4_m1_scale_object());
	
	print ("Player is alive, starting mission");
	
	sleep_s (1);
	thread(f_music_e4m1_playstart_vo());
	//hud_play_pip_from_tag (bink\spops\ep4_m1_1_60);
	vo_e4m1_playstart();
	//sleep_s (5);
	thread(f_music_e4m1_objective_1());
	
	f_new_objective (e4_m1_objective_1);
	//print ("Tap and listen.");
	
	b_wait_for_narrative_hud = false;
	
end



script static void e4_m1_turrets_1
	sleep_until (LevelEventStatus("e4_m1_1_end"), 1);
	print ("e4_m1_1_end");
	
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	thread (f_e4_m1_obj_tracker(flag_0, tv_e4_m1_loc_2));
	
	//ai_set_objective (e4_m1_guards_2, e4_m1_guards_1);
	
	vo_e4m1_turrets01();
	//sleep_s (1);
	//sleep_until (e4m1_narrative_is_on == FALSE);
end

script static void f_e4_m1_2_end
//	sleep_until (LevelEventStatus("e1_m4_d_5"), 1);
//	object_cannot_take_damage (obj_powercore);
	sleep_until (LevelEventStatus("e4_m1_2_end"), 1);
	print ("e4_m1_2_end");
	
	//sleep_until (ai_living_count (e4_m1_guards_3) > 0, 1);
	
	sleep_s (3);
	
	//tell the AI to go to new places -- this might screw up later AI
	ai_set_task (e4_m1_gr_ff_all, e4_m1_guards_7, retreat);
	ai_set_task (e4_m1_guards_3, e4_m1_guards_7, front_guard);
	ai_set_objective (e4_m1_shade_2, e4_m1_shade_magic);
	ai_set_task (e4_m1_shade_3, e4_m1_guards_7, retreat);
	thread(f_music_e4m1_power_up_switches());
	
	
	
//	sleep_until (LevelEventStatus("start_gennie"), 1);
//		print ("turning on gen");
//	device_set_power (objective_switch_4, 1);
	
end

//start no more waves - tells players about drop pods and blips enemies
script static void f_e4_m1_3_start
	sleep_until (LevelEventStatus("e4_m1_3_start"), 1);
	print ("e4_m1_3_start");
	
	//tell AI to go to around the player
	ai_set_task (e4_m1_shade_2, e4_m1_guards_7, retreat);
	ai_set_task (e4_m1_guards_3, e4_m1_guards_7, retreat);
	
	sleep_s (2);
	
	f_e4_m1_glo_vo (1);
	//vo_glo_stalling_02();
	
	//sleep until the enemies are in the drop pods
	sleep_until (ai_living_count (sq_ff_wave_01) > 0, 1);
	vo_e4m1_covdroppods();
	
	sleep_until (ai_living_count (sq_ff_wave_02) > 5, 1);
	sleep_until (ai_living_count (e4_m1_gr_ff_all) <= 5, 1);


	//ai_set_objective (e4_m1_gr_ff_all, e4_m1_follow_squad);
	f_e4_m1_glo_vo (2);
	//vo_glo_cleararea_01()
	
	f_blip_ai_cui(e4_m1_gr_ff_all, "navpoint_enemy");
	//call VO for no more waves
	
end

// ========================================================================================
//==TURN ON SWITCHES
// ========================================================================================


//tell the players to go to the switch
script static void f_e4_m1_second_goal
	sleep_until (LevelEventStatus("e4_m1_4_start"), 1);
	print ("e4_m1_4_start");
	print ("Here here.");
	
	b_wait_for_narrative_hud = true;
	thread(f_music_e4m1_second_goal());
	
	//nice work vo
	f_nice_work_callout();
	
	sleep_s (1);
	
	vo_e4m1_gotospire();
	sleep_s (3);

//this is a weird transition figure this out	

	//sleep_until (e4m1_narrative_is_on == FALSE);
	vo_e4m1_raisepylons();
	//sleep_s (1);
	//sleep_until (e4m1_narrative_is_on == FALSE);
	b_wait_for_narrative_hud = false;
	
	print ("turning on switch");
	thread (f_e4_m1_animate_comm());
	device_set_power (e4_m1_objective_switch_1, 1);
	print ("Activate array.");
	
	f_new_objective (e4_m1_objective_2);
	thread(f_music_e4m1_objective_2());

end

//moves the comm machine and de-rezzes when it's done
script static void f_e4_m1_animate_comm
	print ("animate comm machine");
	sleep_until (device_get_position (e4_m1_objective_switch_1) == 1, 1);
	
	print ("animating device");
	device_set_position (dm_e4_m1_comm, 1);

//animating -- total hack, delete when animation name is device position
//	device_set_position_track( dm_e4_m4_switch1, 'device:position', 1 );
//	device_animate_position (dm_e4_m4_switch1, 0, 2, 1, 0, 0);
	
	sleep_until (device_get_position (e4_m1_objective_switch_1) == 1, 1);
	
	sleep_s (1);
	
	object_dissolve_from_marker(dm_e4_m1_comm, phase_out, panel);
	//object_hide (device, true);
	print ("device derezzed");
	thread (f_e4_m1_move_pylons());
end

//animate the device machine for the listening control -- might not be needed
script static void f_e4_m1_animate_listen
	print ("animate comm machine");
	sleep_until (device_get_position (e4_m1_objective_switch_2) == 1, 1);
	
	print ("animating listen device");
	device_set_position (dm_e4_m1_listen, 1);

//animating -- total hack, delete when animation name is device position
//	device_set_position_track( dm_e4_m4_switch1, 'device:position', 1 );
//	device_animate_position (dm_e4_m4_switch1, 0, 2, 1, 0, 0);
	

end

script static void f_e4_m1_third_goal
	sleep_until (LevelEventStatus("e4_m1_5_start"), 1);
	print ("e4_m1_5_start");
	b_wait_for_narrative_hud = true;
	thread(f_music_e4m1_third_goal());
	print ("Listen in.");
	
	sleep_s (1);
	thread(f_music_e4m1_pylons_raised_vo());
	vo_e4m1_pylonsraised();
	//sleep_s (1);
	//sleep_until (e4m1_narrative_is_on == FALSE);

	thread(f_music_e4m1_go_to_pillars_vo());
	vo_e4m1_gotopillars();
	//sleep_s (1);
	//sleep_until (e4m1_narrative_is_on == FALSE);
	vo_e4m1_hackcomms();
	b_wait_for_narrative_hud = false;
	//sleep_s (1);
	//sleep_until (e4m1_narrative_is_on == FALSE);
	device_set_power (e4_m1_objective_switch_2, 1);
	f_e4_m1_animate_listen();
end

//this script moves the pylons after activating the comm array
script static void f_e4_m1_move_pylons
	print ("moving the pylons");
	object_move_by_offset (cr_e4_m1_tower_1, 3, 0, 0, 3);
	sleep_s (3);
	object_move_by_offset (cr_e4_m1_tower_2, 3, 0, 0, 3);
	sleep_s (3);
	object_move_by_offset (cr_e4_m1_tower_3, 3, 0, 0, 3);
	
end

// ========================================================================================
//==DONE WITH SWITCHES
// ========================================================================================



//location arrival across bridge
script static void f_e4_m1_mid_goal
	sleep_until (LevelEventStatus("e4_m1_6_start"), 1);
	print ("e4_m1_6_start");
	b_wait_for_narrative_hud = true;
	sleep_s (2);
	thread(f_music_e4m1_mid_goal());
	//print ("placing phantom");
	vo_e4m1_hearstuff();
	b_wait_for_narrative_hud = false;
//	sleep_s (3);
//	sleep_until (e4m1_narrative_is_on == FALSE);
	thread(f_music_e4m1_objective_3());
	f_new_objective (e4_m1_objective_3);
	
	ai_place (e4_m1_sq_ff_phantom_05);
	ai_place_in_limbo (e4_m1_sq_ff_phantom_attack_1); 
	
end

script static void f_e4_m1_7_start
	sleep_until (LevelEventStatus("e4_m1_7_start"), 1);
	print ("e4_m1_7_start");
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	thread (f_e4_m1_obj_tracker(flag_0, tv_e4_m1_loc_1));
	
end


script static void f_e4_m1_phantom_guards
	print ("spawning phantom guard squad");
	ai_place (e4_m1_guards_11);
	ai_place (e4_m1_guards_12);
end

//this starts in goal 5 wave 2 -- does nothing currently
script static void f_e4_m1_mid_goal_1
	sleep_until (LevelEventStatus("e4_m1_d_2_1"), 1);
	print ("e4_m1_blah1");
	thread(f_music_e4m1_mid_goal_1());
	
	//find out what this does
	//ai_place (e4_m1_sq_ff_phantom_05);
	
	//call this appropriately
	//vo_e4m1_covdroppods();
	//sleep_s (1);
	
end

script static void f_e4_m1_8_start
	sleep_until (LevelEventStatus("e4_m1_8_start"), 1);
	print ("e4_m1_8_start");
	dm_droppod_4 = dm_e1_m2_drop_4;
	ai_set_objective (e4_m1_gr_ff_all, e4_m1_follow_squad);
	
	f_e4_m1_glo_vo (3);
	//vo_glo_incoming_03()
	
	//sleep_until (ai_living_count (e4_m1_gr_ff_all) > 5, 1);
	//sleep_until (ai_living_count (e4_m1_sq_ff_phantom_06) > 0, 1);
	//sleep_until (ai_living_count (e4_m1_sq_ff_phantom_06) <= 0, 1);
	//sleep until the drop pod squad is alive
	sleep_until (ai_living_count (e4_m1_guards_22) > 0, 1);
	sleep_until (b_phantom_unloaded == true, 1);
	sleep_until (ai_living_count (e4_m1_gr_ff_all) <= 5, 1);
	
	f_e4_m1_glo_vo (4);
	//vo_glo_cleararea_01()
	f_blip_ai_cui(e4_m1_gr_ff_all, "navpoint_enemy");
	
	sleep_until (ai_living_count (e4_m1_gr_ff_all) <= 0, 1);
	
	//ends the goal
	b_end_player_goal = true;
	
	//pause for a beat, then play the VO
	sleep_s (2);
	
	f_e4_m1_glo_vo (5);
	//vo_glo_nicework_03()
	
	sleep_s (2);
	thread(f_music_e4m1_pelican_arrive_vo());
	//hud_play_pip_from_tag (bink\spops\ep4_m1_2_60);
	vo_e4m1_pelicanarrive();
	
end

script static void f_e4_m1_end_goal
	sleep_until (LevelEventStatus("e4_m1_9_start"), 1);
	print ("e4_m1_9_start");
	thread(f_music_e4m1_end_goal());
	print ("pelican inbound");
		
	//place pelican
	ai_place (sniper_pelican_1);
	object_cannot_take_damage (ai_vehicle_get (sniper_pelican_1.pelican_1));
	//unit_set_maximum_vitality (sniper_pelican_1, 20, 0);
	
//FIND BETTER TRIGGERS THAN SLEEP!!!	
	//sleep_s (3);
	//print ("lich what?");
//	ai_place (sniper_lich_1);
	//sleep_s (15);

	//b_wait_for_narrative_hud = false;
	//sleep_s (3);
	thread(f_music_e4m1_objective_4());
	//thread(f_new_objective (e4_m1_objective_4));
	sleep_until (b_pelican_done == true, 1);

	local short objectDistance = 5;
	local object_name flag_0 = lz_e4_m1_8;

	object_create (flag_0);
	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	
	//change the radius of detecting the players
	
	
	inspect (objectDistance);
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ), 1);	
	print ("------player(s) made it to the location------");
	
	//f_unblip_object (flag_0);
	f_unblip_object_cui (flag_0);
	b_end_player_goal = true;
	
	fade_out (0,0,0,60);
	//turn on the chapter complete screen_effect_new
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	
end


//this hits in the middle of goal 8 -- find a better place for it
//maybe add a good work VO here
script static void f_e4_m1_final_goal
	sleep_until (LevelEventStatus("e4_m1_d_1_8"), 1);
	print ("e4_m1_blah2");
	thread(f_music_e4m1_final_goal());
	b_wait_for_narrative_hud = true;
	print ("Way to go.");
	//cinematic_set_title (e4_m1_dl_8);
	b_wait_for_narrative_hud = false;

end

//


//script continuous pod_test
//	sleep_until (LevelEventStatus("set_drop"), 1);
//	print ("pod_test");
//	dm_droppod_1 = dm_e1_m4_drop_1;
//	inspect (dm_droppod_1);
//end
//
//script continuous e1_m4_intro
//	sleep_until (LevelEventStatus ("start_intro"), 1);
//
//	if editor_mode() then
//		firefight_mode_set_player_spawn_suppressed(false);
//	else
//	//ai_place (sq_e1_m4_shades);
//	sleep_s (8);
//	ex1();
//	firefight_mode_set_player_spawn_suppressed(false);
//	sleep_s (15);
//	//ai_erase (squads_0);
//	//ai_erase (squads_1);
//	end
//end

////blow the shields after the first object_destruction
//script continuous e1_m4_switch_1
//	sleep_until (LevelEventStatus ("e1_m4_d_10"), 1);
//	thread(start_camera_shake_loop ("heavy", "short"));
//	//b_wait_for_narrative_hud = true;
//		print ("blowing shields1");
//	//cinematic_set_title (shields_overloading);
//	sleep (30 * 2);
//
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield1_a);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield1_b);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield1_c);
//	
//	object_destroy_folder (dm_e1_m4_shields_1);
//	//cinematic_set_title (title_destroy_obj_2);
//	sleep (30 * 3);
//	stop_camera_shake_loop();
//end
//
//////blow the shields after the second object_destruction
//script continuous e1_m4_switch_2
//	sleep_until (LevelEventStatus ("e1_m4_d_12end"), 1);
//	thread(start_camera_shake_loop ("heavy", "short"));
//	//place bridge snipers
//	ai_place (e1_m4_br_snipers);
//	//b_wait_for_narrative_hud = true;
//	print ("blowing shields2");
//	//cinematic_set_title (shields_overloading);
//	sleep (30 * 2);
//
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield2_a);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield2_b);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield2_c);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, shield2_d);
//	
//	object_destroy_folder (dm_e1_m4_bridge_shields);
//	//cinematic_set_title (title_destroy_obj_2);
//	sleep (30 * 3);
//	stop_camera_shake_loop();
//end
//
//////turn the drop pods to new drop pods
//script continuous e1_m4_change_drop_pods
//	sleep_until (LevelEventStatus ("e1_m4_d_21"), 1);
//	print ("changing drop pod marker locations");
//	dm_droppod_1 = dm_e1_m4_drop_1;
//		inspect (dm_droppod_1);
//	dm_droppod_4 = dm_e1_m4_drop_4;
//		inspect (dm_droppod_4);
//	dm_droppod_5 = dm_e1_m4_drop_5;
//		inspect (dm_droppod_5);
//	ai_place (guards_snipers_1);
//	ai_place (guards_snipers_2);
//	print ("spawning snipers");	
//end
//
////drop in heavy weapons and blip them
//script continuous e1_m4_weapon_drop
//	sleep_until (LevelEventStatus ("e1_m4_d_22"), 1);
//	ordnance_drop (fl_weapon_drop_3, "storm_rail_gun");
////	f_blip_object_cui (fl_weapon_drop_3, "generic");
//	sleep_s (1);
//	ordnance_drop (fl_weapon_drop_1, "storm_sniper_rifle");
////	f_blip_object_cui (fl_weapon_drop_1, "generic");
//	sleep_s (3);
//	ordnance_drop (fl_weapon_drop_2, "storm_rocket_launcher");
////	f_blip_object_cui (fl_weapon_drop_2, "generic");
//end
//
////blow up the gennie
//script continuous f_blow_up_gennie
//	sleep_until (LevelEventStatus("blow_gennie"), 1);
//	cinematic_set_title (e1_m4_d_28);
//		sound_looping_start (fx_misc_warning, NONE, 1.0);
//	camera_shake_all_coop_players( .2, .2, 3, 1);
//	//sleep (30 * 5);
//	
//	//thread(start_camera_shake_loop ("medium", "long"));
//	camera_shake_all_coop_players( .4, .4, 3, 1);
//	sleep(30 * 2);
//	//stop_camera_shake_loop();
//	//sleep_s (1);
//	sound_looping_stop (fx_misc_warning);
//	cinematic_set_title (e1_m4_d_29);
//	// set some timer
//	print("_______________________________about to damage gennie");
//	// set the gennie to blow up
//	f_explode_gennie (ps_explosion_points.p0);
//	f_explode_gennie (ps_explosion_points.p1);
//	f_explode_gennie (ps_explosion_points.p2);
//	f_explode_gennie (ps_explosion_points.p3);
//	f_explode_gennie (ps_explosion_points.p4);
//	f_explode_gennie (ps_explosion_points.p5);
//	
//camera_shake_all_coop_players( 1, 1, 2, 1);
//	effect_new_on_object_marker (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, obj_powercore, device_control_loc);
//	print ("EXPLOSION CORE 1");
//	sleep_s (1);
//	effect_new_on_object_marker (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, obj_powercore, device_control_loc);
//	print ("EXPLOSION CORE 2");
//	object_can_take_damage (obj_powercore);
//	damage_object(obj_powercore, default, 10000);
//	sleep_s (1);
//
//	print("_______________________________game over");
////	stop_camera_shake_loop();
//end
//
//script static void f_explode_gennie (point_reference point)
//	print ("shake start");
//	camera_shake_all_coop_players( .1, .7, 1, 0.1);
//	effect_new_at_ai_point (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, point);
//	print ("EXPLOSION");
//	sleep_s(1);
//	print ("stop");
//end

//==============ENDING E1 M4==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//=============misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////

global object g_ics_player = none;

script static void f_push_fore_switch (object dev, unit player)
//script static void f_push_fore_switch (unit player)
	print ("pushing the forerunner switch");
	g_ics_player = player;
//	g_ics_player = player0;
	pup_play_show (pup_e4_m1_switch);

end

script static void f_e4_m1_scale_object
	print ("scale objects");
	sleep_until (object_valid (cr_e4_m1_fore_stand), 1);
	object_set_scale (cr_e4_m1_fore_stand, 0.6, 30);

end

script static void f_nice_work_callout
	print ("NICE WORK VO");
	
	sleep_until (e4m1_narrative_is_on == FALSE);
	e4m1_narrative_is_on = TRUE;

	begin_random_count (1)
		vo_glo_nicework_01();
		vo_glo_nicework_02();
		vo_glo_nicework_03();
		vo_glo_nicework_04();
		vo_glo_nicework_05();
		vo_glo_nicework_06();
		vo_glo_nicework_07();
		vo_glo_nicework_08();
		vo_glo_nicework_09();
		vo_glo_nicework_10();
	
	end
	
	e4m1_narrative_is_on = false;
		
end


script static void f_e4_m1_glo_vo (short vo_call)
	print ("global spops dialog call");
	sleep_until (e4m1_narrative_is_on == FALSE, 1);
	e4m1_narrative_is_on = TRUE;
	if vo_call == 1 then
		vo_glo_stalling_02();
	elseif vo_call == 2 then
		vo_glo_cleararea_01();
	elseif vo_call == 3 then
		vo_glo_incoming_03();
	elseif vo_call == 4 then
		vo_glo_cleararea_01();
	elseif vo_call == 5 then
		vo_glo_nicework_03();
	end
	e4m1_narrative_is_on = FALSE;
end

//this controls the ending of the TV goals.  The goal ends when the player(s) go through the first trigger volume, while also blipping the markers
script static void f_e4_m1_obj_tracker (object_name loc_marker, trigger_volume tv)
	print ("starting trigger volume tracker");	
	
	sleep_until (volume_test_players (tv), 1) or b_wait_for_narrative_hud == false;
		if b_wait_for_narrative_hud == TRUE then
			print ("player got to volume before end of VO, don't blip");
		else
			f_blip_object_cui (loc_marker, "navpoint_goto");
			sleep_until (volume_test_players (tv), 1);
			print ("players have entered trigger volume, ending goal");
			f_unblip_object_cui (loc_marker);
		end
	b_end_player_goal = true;
	
	
end


// ========================================================================================
//== COMMAND SCRIPTS
// ========================================================================================


script command_script cs_e4_m1_drop_pod
	sleep_s (5);
	ai_set_objective (ai_current_squad, e4_m1_follow_squad);

end

//add comments here
script command_script cs_ff_lich_attack_1()
	cs_ignore_obstacles (TRUE);
//	cs_shoot (true, sniper_pelican_1);
	sleep_s (1);
	print ("lich firing at pelicon");
	cs_fly_to (lich_end_0.p0);
	cs_fly_to (lich_end_0.p1);
	sleep_s (1);
	damage_object (sniper_pelican_1.pelican_1, default, 1600);
	print ("keep flying");
	cs_fly_to (lich_end_0.p2);
	cs_fly_to_and_face (lich_end_0.p3, lich_end_0.p3);
	cs_fly_by (lich_end_0.p4);
	ai_erase (ai_current_squad);

end

//script command_script cs_drop_pod
//	sleep_s (3);
//	ai_set_objective (ai_current_squad, obj_survival);
//end

// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

script command_script cs_ff_phantom_attack_1()
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
	
	//cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (ai_current_actor, true);
	cs_fly_by (ps_e4_m1_phantom_attack_1.p0);
	cs_enable_targeting (true);

	cs_fly_by (ps_e4_m1_phantom_attack_1.p1);
	cs_fly_by (ps_e4_m1_phantom_attack_1.p2);
	cs_fly_by (ps_e4_m1_phantom_attack_1.p3);
	cs_fly_by (ps_e4_m1_phantom_attack_1.p4);
	cs_fly_by (ps_e4_m1_phantom_attack_1.p5);
	cs_fly_by (ps_e4_m1_phantom_attack_1.erase);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (4);
	ai_erase (ai_current_squad);
	
end



// PHANTOM 01 E4_M1 =============================================================================================
 
 //change squad name to this actor
 //add comments here
script command_script cs_e4_m1_phantom_05() // phantom that drops a wraith, then dudes
	print ("1st phantom command script initiated");
//	ai_place_in_limbo (e4_m1_guards_11);
	cs_ignore_obstacles (false);
	//cs_vehicle_speed(1);
	//object_set_phantom_directional_multiplier(ai_get_unit(ai_current_actor), 10);
	//f_load_phantom (ai_current_actor, "right", e4_m1_guards_11, none, none, none);
	//ai_place_in_limbo (e4_m1_guards_11);
	//ai_place_in_limbo (e4_m1_guards_12);
	
	//spawn the ai that go in the phantom
	f_e4_m1_phantom_guards();
	
	f_load_dropship (ai_vehicle_get_from_spawn_point (e4_m1_sq_ff_phantom_05.phantom), e4_m1_guards_11);
	f_load_dropship (ai_vehicle_get_from_spawn_point (e4_m1_sq_ff_phantom_05.phantom), e4_m1_guards_12);
	//ai_exit_limbo (e4_m1_guards_11);
	//ai_exit_limbo (e4_m1_guards_12);
//	ai_exit_limbo (e4_m1_guards_11);
	cs_fly_to (e4_m1_ps_ff_phantom_05.p0);
	
//	ai_place_in_limbo (e4_m1_guards_11);
//	f_load_dropship (ai_vehicle_get_from_spawn_point (e4_m1_sq_ff_phantom_05.phantom), e4_m1_guards_11);
//	ai_exit_limbo (e4_m1_guards_11);
	
	thread (vo_e4m1_dropship01());
	
	cs_fly_to (e4_m1_ps_ff_phantom_05.p1);
	cs_fly_to (e4_m1_ps_ff_phantom_05.p2);
	
	sleep_s(2);
	
	f_unload_phantom (ai_current_actor, "dual");
	
	//thread (vo_e4m1_hunters01());
//	ai_place_in_limbo (e4_m1_guards_12);
	sleep_s(3);
	thread (vo_e4m1_afterhunters());
	
	//f_load_phantom (ai_current_actor, "right", e4_m1_guards_12, none, none, none);
//	ai_exit_limbo (e4_m1_guards_12);
	
	cs_fly_by (e4_m1_ps_ff_phantom_05.p3);
	
	cs_fly_to (e4_m1_ps_ff_phantom_05.p4);
	sleep_s(2);
	
	//f_unload_phantom (ai_current_actor, "right");
	
	//sleep_s(3);
	cs_fly_to (e4_m1_ps_ff_phantom_05.p5);
	cs_fly_to (e4_m1_ps_ff_phantom_05.erase);
		
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	
	sleep_s(4);
	
	ai_erase (ai_current_squad);
end

// PHANTOM 06 =================================================================================================== 

//boolean to tell the player the ai are out of the phantom
global boolean b_phantom_unloaded = false;

//change squad name to this actor
//add comments here
script command_script cs_ff_phantom_06()
	sleep (1);
	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (sq_ff_phantom_01.phantom, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (e4_m1_ps_ff_phantom_06.p0);
	cs_fly_by (e4_m1_ps_ff_phantom_06.p1);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	f_unload_phantom (ai_current_squad, "dual");
	b_phantom_unloaded = true;
		//======== DROP DUDES HERE ======================
		
	print ("phantom_06 unloaded");
	sleep (30 * 5);
	cs_fly_to (e4_m1_ps_ff_phantom_06.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	cs_fly_to (e4_m1_ps_ff_phantom_06.p3);
	ai_erase (ai_current_squad);
end


script command_script cs_ff_phantom_attack_2()
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
	
	//cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (ai_current_actor, true);
	cs_fly_by (ps_e4_m1_phantom_attack_2.p0);
	cs_enable_targeting (true);

	cs_fly_by (ps_e4_m1_phantom_attack_2.p1);
	cs_fly_by (ps_e4_m1_phantom_attack_2.p2);
	
	//======== DROP DUDES HERE ======================
	
	f_unload_phantom (ai_current_squad, "dual");
			
	//======== DROP DUDES HERE ======================
	
	cs_fly_by (ps_e4_m1_phantom_attack_1.p3);
	//cs_fly_by (ps_e4_m1_phantom_attack_1.p4);
	//cs_fly_by (ps_e4_m1_phantom_attack_1.p5);
	cs_fly_by (ps_e4_m1_phantom_attack_1.erase);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (4);
	ai_erase (ai_current_squad);
	
end

// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

// PELICAN 01 E4_M1 =============================================================================================
//add comments here

script command_script cs_ff_pelican_1()
	cs_ignore_obstacles (FALSE);
	print ("pelican 1 running command script");
	cs_fly_to (pelican_end_1.p0);
	cs_fly_to (pelican_end_1.p1);
	sleep_s (1);
	cs_fly_to_and_face (pelican_end_1.p3, pelican_end_1.p3);
	f_e4_m1_pelican_done();
//	print ("BOOM");
//	damage_object (sniper_pelican_1.pelican_1, default, 1600);
end

global boolean b_pelican_done = false;

script static void f_e4_m1_pelican_done
	print ("pelican done");
	b_pelican_done = true;

end

//add comments here
script command_script cs_ff_e4m1pelican_2()
	cs_ignore_obstacles (FALSE);
	print ("pelican 2 running command script");
	cs_fly_to (e4_m1_pelican_drop_off.p0);
	cs_fly_to (e4_m1_pelican_drop_off.p1);
	cs_fly_to (e4_m1_pelican_drop_off.p2);
	cs_fly_to_and_face (e4_m1_pelican_drop_off.p3, e4_m1_pelican_drop_off.p3);
	sleep_s (1);
	ai_erase (e4_m1_pelican_drop_off);
//	print ("BOOM");
//	damage_object (sniper_pelican_1.pelican_1, default, 1600);
end

//script continuous shipdisappear
//	sleep_until (LevelEventStatus("dissolvepelican"), 1);
//	object_dissolve_from_marker(e4_m1_pelican_drop_off, phase_out, cockpit_nose);
//	sleep_forever();
//end


script static void wv_test
	print ("wave test");
	inspect (firefight_mode_get_wave_squad());

end
