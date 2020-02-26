// =============================================================================================================================
//========= SCURVE FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish
//NO GENERAL SCRIPTS should be copy and pasted into the map scripts

// =============================================================================================================================
// ===========LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
//========= GLOBALS===================================================================

//global string_id	title_e7_m2_0 = ch_e7_m2_0;
//global string_id	title_e7_m2_1 = ch_e7_m2_1;
//global string_id	title_e7_m2_2 = ch_e7_m2_2;
//global string_id	title_e7_m2_3 = ch_e7_m2_3;
//global string_id	title_e7_m2_4 = ch_e7_m2_4;
//global string_id	title_e7_m2_5 = ch_e7_m2_5;
//global string_id	title_e7_m2_6 = ch_e7_m2_6;
//global string_id	title_e7_m2_7 = ch_e7_m2_7;
//global string_id	title_e7_m2_8 = ch_e7_m2_8;
//global cutscene_title	title_e7_m2_9 = ch_e7_m2_9;
global boolean b_e7_m2_hallway_door_open = FALSE;
global boolean b_e7_m2_hallway_backtrack = FALSE;
global boolean e7m2_reardudesmoveup = FALSE;

// =============================================================================================================================
// ================================================== TITLES ==================================================================
script startup dlc01_engine_e7_m2
	//dprint( "dlc01_engine_e7_m2_init" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e7_m2") ) then
		wake( dlc01_engine_e7_m2_init );
	end

end

script dormant dlc01_engine_e7_m2_init
	//Start the intro
	print ("******************STARTING E7 M2: Nov 29v3, 2012*********************");
	
	f_spops_mission_setup( "e7_m2", e7_m2, e7_m2_gr_ff_all, sc_e7_m2_spawn_points_0, 90 );
	//firefight_mode_set_player_spawn_suppressed(true);	//prevents player spawn untill everything else is loaded
	thread(f_start_player_intro_e7_m2());

//start the first starting event
	thread (f_start_events_e7_m2_0());
	print ("starting e7_m2_1");

//thread the rest of the event threads
	thread (f_start_all_events_e7_m2());

//======= OBJECTS ==================================================================
//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_0, 90); //spawns in the Hanger
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_1, 91); //spawns in the Hallways
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_2, 92); //spawns in the AI Room
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_3, 93); //spawns in the AI Room
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_4, 94); //spawns in the AI Room
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_5, 95); //spawns in the AI Room
	firefight_mode_set_crate_folder_at(sc_e7_m2_spawn_points_6, 96); //spawns in the AI Room

// ==Drop Ships==
	firefight_mode_set_squad_at(sq_e7_m2_phantom_1, 20); //phantom 1
	//	firefight_mode_set_squad_at(sq_e7_m2_phantom_2, 21); //phantom 2
	firefight_mode_set_squad_at(sq_e7_m2_phantom_3, 22); //phantom 3
	firefight_mode_set_squad_at(sq_e7_m2_phantom_4, 23); //phantom 4
	firefight_mode_set_squad_at(sq_e7_m2_phantom_5, 26); //phantom 4
	
//set objective names
	firefight_mode_set_objective_name_at(power_switch, 41); //Fist switch in the Hanger room
	firefight_mode_set_objective_name_at(hanger_01, 42); //This is a duel objective switch with #3
	firefight_mode_set_objective_name_at(hanger_02, 43); //Maintance Hall Button
	firefight_mode_set_objective_name_at(server_activate, 44); //point in the AI room
	firefight_mode_set_objective_name_at(ai_activate, 45); //Activate the room
	firefight_mode_set_objective_name_at(ai_room_door_01, 46);
	firefight_mode_set_objective_name_at(power_switch_2, 47);
	
//set LZ spots	
	firefight_mode_set_objective_name_at(lz_0, 50); //objective in the main spawn area
	firefight_mode_set_objective_name_at(lz_1, 51); //objective in the main spawn area
		
//set squad group names
//	firefight_mode_set_squad_at(gr_e7_m2_guards_1, 1); //Hanger, Left ground area in the back
//	firefight_mode_set_squad_at(gr_e7_m2_guards_2, 2); //Hanger, Left ground area in the front
//	firefight_mode_set_squad_at(gr_e7_m2_guards_3, 3); //Hanger Monster Closet: left top
//	firefight_mode_set_squad_at(gr_e7_m2_guards_4, 4); //Hanger, Monster Closet: left bottom back
//	firefight_mode_set_squad_at(gr_e7_m2_guards_5, 5); //Hanger, Monster Closet: left bottom front
//	firefight_mode_set_squad_at(gr_e7_m2_guards_6, 6); //Hanger, Monster Closet: right top back
//	firefight_mode_set_squad_at(gr_e7_m2_guards_7, 7); //Hanger, Hallway: Left top back
//	firefight_mode_set_squad_at(gr_e7_m2_guards_8, 8); //Phantom Left Side Hanger
//	firefight_mode_set_squad_at(gr_e7_m2_guards_9, 9); //Phantom Right Side Hanger
//	firefight_mode_set_squad_at(gr_e7_m2_hallway_front, 10); //AI hallway: Left H section
	//firefight_mode_set_squad_at(gr_e7_m2_hallway_mid_right, 11); //AI hallway: Right H section
	//firefight_mode_set_squad_at(gr_e7_m2_hallway_mid_left, 122); //AI hallway: Right H section
	//firefight_mode_set_squad_at(gr_e7_m2_hallway_rear, 123); //AI hallway: Right H section
	//firefight_mode_set_squad_at(gr_e7_m2_hallway_reinforcements, 124); //AI hallway: Right H section
	//firefight_mode_set_squad_at(gr_e7_m2_guards_12, 12); //AI hallway: Monster Closet
//	firefight_mode_set_squad_at(gr_e7_m2_guards_13, 13); //AI room: Right side main AI structure
//	firefight_mode_set_squad_at(gr_e7_m2_guards_14, 14); //AI room: Right lower enterence
//	firefight_mode_set_squad_at(gr_e7_m2_guards_15, 15); //AI room: Left lower ramp
//	firefight_mode_set_squad_at(gr_e7_m2_guards_16, 16); //AI room: Left northern ramp
	firefight_mode_set_squad_at(gr_e7_m2_guards_17, 17); //Hanger Jackels
//	firefight_mode_set_squad_at(gr_e7_m2_guards_18, 18); //Phantom: Left Side Hanger
//	firefight_mode_set_squad_at(gr_e7_m2_guards_19, 19); //Phantom Right Side Hanger
	firefight_mode_set_squad_at(gr_e7_m2_guards_20, 120); //Phantom Right Side Hanger
	firefight_mode_set_squad_at(gr_e7_m2_guards_21, 121); //Phantom Right Side Hanger
	firefight_mode_set_squad_at(gr_e7_m2_ai_grunts, 27); 
	firefight_mode_set_squad_at(gr_e7_m2_ai_rangers, 28); 
	//firefight_mode_set_squad_at(gr_e7_m2_guards_31, 29); 
	firefight_mode_set_squad_at(gr_e7_m2_rtn_hallway_w1, 24); 
	firefight_mode_set_squad_at(gr_e7_m2_rtn_hallway_w2, 25); 
	firefight_mode_set_squad_at(gr_e7_m2_final_grunts, 30); 
	firefight_mode_set_squad_at(sq_e7_m2_ai_knight_intro, 31); 
	firefight_mode_set_squad_at(sq_e7_m2_hangar_exit, 32); 
	firefight_mode_set_squad_at(sq_e7_m2_hangar_phantom_3a, 33);
	firefight_mode_set_squad_at(sq_e7_m2_hangar_phantom_3b, 34);
	
	
//set crate folder names to create
	//f_add_crate_folder(cr_e7_m2_unsc_gun_racks); //Ammo Crates
	f_add_crate_folder(cr_e7_m2_unsc_ammo); //Ammo Crates
	f_add_crate_folder(cr_e7_m2_cov_cover); 
	f_add_crate_folder(cr_e7_m2_unsc_cover); 
//	f_add_crate_folder(cr_e7_m2_props); 
	f_add_crate_folder(e7_m2_controls); //All MA CONTROLS
	f_add_crate_folder(e7_m2_doors_closed); //Doors that are always closed
	f_add_crate_folder(e7_m2_doors); //Doors as progression blockers and device machines
	f_add_crate_folder(e7_m2_switches);
	f_add_crate_folder(sc_e7_m2_props);
	f_add_crate_folder(e7_m2_servers);
	//f_add_crate_folder(dm_dummy_lifts);
	f_add_crate_folder(e7_m2_lifts);
	f_add_crate_folder(eq_e7_m2_unsc_ammo);
	f_add_crate_folder(wp_e7_m2_weapons);
	f_add_crate_folder(tv_e7_m2_volumes);
	//f_add_crate_folder(dm_dummy_lifts);
	firefight_mode_set_squad_at(gr_e7_m2_allies_1, 51);
	firefight_mode_set_squad_at(gr_e7_m2_allies_3, 52);
	object_create(engine_shield_loop_01);
	object_create(engine_shield_loop_02);
//	firefight_mode_set_squad_at(gr_e7_m2_allies_2, 52);
	effect_kill_from_flag(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
  f_spops_mission_setup_complete( TRUE );
end

//==== MAIN SCRIPT STARTS ==================================================================
//threading all the event scripts that are called through the gameenginevarianttag
script static void f_start_all_events_e7_m2
	thread (e7m2_init_fight());
	thread (f_start_events_e7_m2_1());
	thread (f_start_events_e7_m2_2());
	thread (f_start_events_e7_m2_3());
	//thread (f_start_events_e7_m2_4());
	thread (f_start_events_e7_m2_5());
	thread (f_start_events_e7_m2_6());
	thread (f_start_events_e7_m2_7());
	thread (f_event_e7_m2_ai_knight1());
	thread (f_start_events_e7_m2_9());
	thread (f_e7_m2_lift());
	thread (f_e7_m2_servers());
	thread (f_start_events_e7_m2_ai_door());
	thread (f_end_events_e7_m2_ai_door());
	thread (e7m2_use_lift());
	//thread (f_obj_update_1());
	thread (f_end_mission_e7_m2());
	thread (e7_m2_open_mc1());
	thread (e7_m2_open_mc2());
	thread (e7_m2_open_mc3());
	thread (e7_m2_open_mc4());
	thread (e7_m2_open_mc5());
	thread (e7_m2_open_mc7());
	thread (e7_m2_open_mc13());
	print ("343434343333433434343434 ALL THE DOORS ARE THREADED YAAAAAAAAAAAAY");  
	//thread(hide_dummy_nav_lifts());
	//thread(f_camera_shake_random_timer(TRUE));
	thread(f_event_e7_m2_back_to_hanger());
	thread(f_start_events_e7_m2_hanger_door());
	thread(f_init_hangar_door_open());
	thread(f_e7_m2_mark_server());
	thread(f_init_destroy_server_props());
	thread(f_event_e7_m2_blip_ai_door());
	//thread(f_audio_shield());
	thread(f_audio_shield(sq_e7_m2_phantom_1.phantom));
	thread(f_audio_shield(sq_e7_m2_phantom_2.phantom_2));
	thread(f_audio_shield(sq_e7_m2_phantom_3.phantom_3));
	thread(f_audio_shield(sq_e7_m2_phantom_5.phantom_2));
end

script static void f_init_destroy_server_props
	sleep_until(object_valid(server01), 1);
	object_destroy(server01);
	sleep_until(object_valid(server02), 1);
	object_destroy(server02);
	sleep_until(object_valid(server03), 1);
	object_destroy(server03);
	sleep_until(object_valid(server04), 1);
	object_destroy(server04);
	sleep_until(object_valid(server05), 1);
	object_destroy(server05);
	sleep_until(object_valid(server06), 1);
	object_destroy(server06);
	object_destroy(engine_server_hum_01);
	object_destroy(engine_server_hum_02);
	object_destroy(engine_server_hum_03);
	object_destroy(engine_server_hum_04);
	object_destroy(engine_server_hum_05);
	object_destroy(engine_server_hum_06);
end
script static void f_init_hangar_door_open
	sleep_until(object_valid(hangardoor1), 1);
	device_set_position_track( hangardoor1, "any:idle", 1 );
	device_animate_position( hangardoor1, 1, 1, 1.0, 1.0, TRUE );
	
	sleep_until(object_valid(hangardoor2), 1);
	device_set_position_track( hangardoor2, "any:idle", 1 );
	device_animate_position( hangardoor2, 1, 1, 1.0, 1.0, TRUE );
	
	/*sleep_until(object_valid(dm_e7_m2_railing2), 1);
	device_set_position_track( dm_e7_m2_railing2, "any:idle", 1 );
	device_animate_position( dm_e7_m2_railing2, 1, 1, 1.0, 1.0, TRUE );*/
	
	sleep_until(object_valid(dm_railing1), 1);
	device_set_position_track( dm_railing1, "any:idle", 1 );
	device_animate_position( dm_railing1, 1, 1, 1.0, 1.0, TRUE );
	
	sleep_until(object_valid(dm_railing2), 1);
	device_set_position_track( dm_railing2, "any:idle", 1 );
	device_animate_position( dm_railing2, 1, 1, 1.0, 1.0, TRUE );
	print("lowering railings");
	object_move_to_point(block_nav1, 1, ps_lift.p0);
end

//====== INTRO ===============================================================================
script static void f_start_player_intro_e7_m2
	//firefight_mode_set_player_spawn_suppressed(true);           
	sleep_until (f_spops_mission_setup_complete(), 1);
	//intro();
	if editor_mode() then
		sleep_until (b_players_are_alive(), 1);
		//intro_vignette_e7_m2();
	else
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		intro_vignette_e7_m2();
	end
	//f_switch_zone_set_e7m2();
	//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e7m2_vin_sfx_intro', NONE, 1);
	f_spops_mission_intro_complete( TRUE );
end

script static void intro_vignette_e7_m2
	print("Starting Vignette e7m2");
	ai_enter_limbo (e7_m2_gr_ff_all);																				//tjp
	pup_disable_splitscreen (true);																					//tjp
	local long show = pup_play_show(e7_m2_intro);														//tjp
	thread (f_music_e7m2_vignette_start());																	//tjp
	print("music");
	sleep_until (not pup_is_playing(show), 1);															//tjp

	pup_disable_splitscreen (false);																				//tjp
	ai_exit_limbo (e7_m2_gr_ff_all);																				//tjp

	
//	b_wait_for_narrative = true;
		//pup_play_show(e7_m2_intro);
//	vo_e7m2_intro();
	thread (f_music_e7m2_vignette_finish());
	sleep_s(2);
	//firefight_mode_set_player_spawn_suppressed(false);
	fade_in (0,0,0,90);
//	sleep_until (b_wait_for_narrative == false);
	//cinematic_stop();
end

script static void f_narrative_done_e7_m2
	print ("narrative done");
//	b_wait_for_narrative = false;
end

//===========STARTING E7 M2==============================
global boolean b_hangar_init_wave = TRUE;

script static void f_start_events_e7_m2_0
	sleep_until (LevelEventStatus("start_e7_m2_0"), 1);	
	print("1");
	sleep_until( f_spops_mission_intro_complete(), 1 );
	print("2");
	sleep_until (b_players_are_alive(), 1);
	print("3"); 
	//f_objective_complete();
	b_end_player_goal = TRUE;

end

script static void e7m2_init_fight()
	sleep_until (LevelEventStatus ("e7m2_initfight"), 1);
	ai_place (sq_e7m2_covmix_03);
	ai_place (sq_e7m2_covmix_04);
end




script static void f_start_events_e7_m2_1
	thread(f_music_e07m2_start());
	sleep_until (LevelEventStatus("start_e7_m2_1"), 1);	
	//sleep_until( f_spops_mission_intro_complete(), 1 );
	thread(f_music_e07m2_intro());
	ai_place (gr_e7_m2_allies_1);
	vo_e7m2_playstart();
	sleep_s(2);
	thread(f_new_objective(ch_e7_m2_clear));
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 10, 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_murphy();
	sleep_rand_s(2, 5);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_infinity_01();
end

script static void f_obj_update_1
	sleep_s(3);
	sleep_until (LevelEventStatus("obj_update_1"), 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	b_hangar_init_wave = FALSE;
	//vo_e7m2_hangarphantom();
end

global boolean b_e7_m2_allies_guard_balcony  = FALSE;


script static void f_start_events_e7_m2_2
	sleep_until (LevelEventStatus("start_e7_m2_2"), 1);
	b_e7_m2_allies_guard_balcony = TRUE;
	sleep_s(1);
	thread(f_music_e07m2_hitcontrols());
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_hitcontrols();
	sleep_s(1);
	thread(f_new_objective(ch_e7_m2_2));
	device_set_power(power_switch, 1);
	f_blip_object_cui (power_switch, "navpoint_activate");
	sleep_until (device_get_position (power_switch) > 0.0, 1);
	pup_play_show(ppt_hanger_door_main);
	f_unblip_object_cui (power_switch);
	b_end_player_goal = TRUE;
end

/* Objective Event Triggered: Hanger door fail. Camera Shake and sound */
global boolean b_e7_m2_phantom_2_unloaded = false;
global boolean b_e7_m2_phantom_5_unloaded = false;

script static void f_start_events_e7_m2_3
	sleep_until (LevelEventStatus("start_e7_m2_3"), 1);
	thread(f_start_events_e7_m2_3_vo());
	sleep (90);
	ai_place(sq_e7_m2_phantom_2);
	print ("3434343434343334343434343 SLEEPING MISSION SCRIPT UNTIL PHANTOM 2 IS EITHER DEAD OR UNLOADED");
	sleep_until ( b_e7_m2_phantom_2_unloaded == TRUE or ai_living_count(sq_e7_m2_phantom_2) == 0, 1);
	print ("3434343434343334343434343 CONTINUING MISSION, PHANTOM 2 IS EITHER DEAD OR UNLOADED");
	sleep_until (ai_living_count (e7_m2_gr_ff_all) <= 8, 1);
	print ("Phantom 5 Incoming");
	ai_place(sq_e7_m2_phantom_5);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_glo15_miller_phantom_01();
	print ("3434343434343334343434343 SLEEPING MISSION SCRIPT UNTIL PHANTOM 5 IS EITHER DEAD OR UNLOADED");
	sleep_until ( b_e7_m2_phantom_5_unloaded == TRUE or ai_living_count(sq_e7_m2_phantom_5) == 0, 1);
	print ("3434343434343334343434343 CONTINUING MISSION, PHANTOM 5 IS EITHER DEAD OR UNLOADED");
	sleep_until (ai_living_count (e7_m2_gr_ff_all) <= 8, 1);
	ai_place(sq_e7_m2_hangar_exit);
	NotifyLevel("open_mc7");
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_palmerone();
	sleep_s(2);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_gettoserver();
	sleep_until(ai_living_count(e7_m2_gr_ff_all) == 0);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_serverarrive();
	b_end_player_goal = TRUE;
end

script static void e7m2_use_lift()
	sleep_until (LevelEventStatus("e7m2_uselift"), 1);
	device_set_power(hanger_01, 1);
	object_create(cr_e7_m2_hangar_lift_screen);
	thread(f_new_objective(ch_e7_m2_lift));
	f_blip_object_cui (hanger_01, "navpoint_activate");
	sleep_until (device_get_position (hanger_01) > 0.0, 1);
	f_unblip_object_cui (hanger_01);
	b_end_player_goal = TRUE;
end


script static void f_start_events_e7_m2_3_vo
	device_set_power(power_switch, 0);
	thread(f_music_e07m2_control_activate());
	
	sleep_s(1);
	//object_create(cr_e7_m2_hanger_screen_left);
	//f_audio_hanger_screen_activate_left();
	
	sleep_s(1);
	//object_create(cr_e7_m2_hanger_screen_right);
	//f_audio_hanger_screen_activate_right();
	device_animate_position( hangardoor2, 0.6, 1, 1.0, 1.0, TRUE ); // door jam 1
	device_animate_position( hangardoor1, 0.5, 1, 1.0, 1.0, TRUE ); // door jam 2
	thread(camera_shake_all_coop_players( .1, .7, 1, 0.1));
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_power_explosion_in', none, 1);
	sleep_s(0.5);
	//object_destroy(cr_e7_m2_hanger_screen_right);
	//f_audio_hanger_screen_deactivate_left();
	sleep_s(0.5);
	//object_destroy(cr_e7_m2_hanger_screen_left);
	device_animate_position( hangardoor2, 1, 1, 1.0, 1.0, TRUE ); // door jam 1
	sleep_s(1);
	device_animate_position( hangardoor1, 1, 1, 1.0, 1.0, TRUE ); // door jam 2
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_dontwork();
	// wait for dontwork dialog to finish
	//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_02\e07m2_dontwork_00100')); 
	sleep_s(1); // additional pause
	//thread(f_new_objective(ch_e7_m2_power));
	thread(f_new_objective(ch_e7_m2_defend));
	thread(f_music_e07m2_dontwork());
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_moreincoming();	
end


/* Objective Event Triggered: Raise Lift */
script static void f_e7_m2_lift
	sleep_until (LevelEventStatus("e7_m2_lift"), 1);
	device_set_power(hanger_01, 0);
	//pup_play_show(ppt_hanger_lift);
	sleep_s(3);	
	object_destroy (cr_e7_m2_hangar_lift_screen);
	object_move_to_point(block_nav1, 0, ps_lift.p3);
	device_set_position_track( dm_e7_m2_launchpad2, 'any:idle', 1 );
	sleep_s(2);
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_inf_lift', dm_e7_m2_launchpad2, 1 ); //AUDIO!
	device_animate_position(dm_e7_m2_launchpad2, 1, 10, 0.1, 0.1, TRUE);
	sleep_s(4);
	device_animate_position(dm_railing2, 0, 1, 0.1, 0.1, TRUE);
	sleep_until(device_get_position(dm_e7_m2_launchpad2) >= 1, 1);
	
	//device_set_position_track( dm_e7_m2_ramp_platform, 'any:idle', 1 );
	device_animate_position(dm_e7_m2_launchpad2, 1, 2, 0.1, 0.1, TRUE);
	
	sleep_until (LevelEventStatus("open_mc1"), 1);
	thread(f_new_objective(ch_e7_m5_1));
	sleep_rand_s(2, 5);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_infinity_02();
end


script static void f_e7_m2_mark_server
	sleep_until (LevelEventStatus("e7_m2_mark_server"), 1);
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 4);
	if (ai_living_count(e7_m2_gr_ff_all) > 0) then
		sleep_until (b_e7m2_narrative_is_on == false, 1);
		vo_glo_remainingcov_02();
		f_blip_ai_cui(e7_m2_gr_ff_all, "navpoint_enemy");
		sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 0, 1);
		f_unblip_ai_cui(e7_m2_gr_ff_all);
	end
	sleep_until (ai_living_count(e7_m2_gr_ff_all) == 0);
	thread(f_music_e07m2_liftraised());
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_liftraised();
	thread(f_new_objective(ch_e7_m2_power));
	//thread(f_new_objective(ch_e7_m2_goto_ai));
end


script static void f_start_events_e7_m2_hanger_door
	sleep_until (LevelEventStatus("start_e7_m2_hanger_door"), 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	sleep (30);
	sleep_until (e7m2_leavehangardudes == TRUE, 1);
	sleep_until (volume_test_players (tv_e7m2_openhangardoor), 1);
	ai_place (sq_e7m2_kaze_gru);
	ai_place (sq_e7m2_marines_3);
	ai_place (sq_e7m2_kazegru_2);
	ai_place (sq_e7m2_4eli_01);
	ai_place (sq_e7m2_covmix_05);
	ai_place (sq_e7m2_covmix_06);
	f_unblip_object (mc_6);
	device_set_power(hanger_02, 1);
	device_set_position_track(dm_door_switch_hanger, "device:position", 0);
	device_animate_position (dm_door_switch_hanger, 1, 0.25, 1, 0, 0);
	b_end_player_goal = TRUE;
end

script static void f_start_events_e7_m2_5
	sleep_until (LevelEventStatus("start_e7_m2_5"), 1);
	//pup_play_show(ppt_hanger_door_exit);
	device_set_position_track( mc_6, 'any:idle', 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', mc_6, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', mc_6, 1);
	device_animate_position( mc_6, 1, 3.5, 1.0, 1.0, TRUE );
	sleep_until( (device_get_position(mc_6) >= 0.6), 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', mc_6, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	print ("Hangar door should have opened!!! 34343434343434343434343434343434343434343434343434343");
	//thread(f_engine_open_door(hanger_02, mc_6, dm_door_switch_hanger));
	sleep_s(1.5);
	//thread(f_music_e07m2_morebadguys());
	//sleep_until (b_e7m2_narrative_is_on == false, 1);
	//vo_e7m2_morebadguys();	
	sleep_until (LevelEventStatus("open_mc13"), 1);
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_palmertwo();
end



/* Objective Event Triggered: Open AI Door */
script static void f_start_events_e7_m2_ai_door
	print ("SERVER ROOM DOOR THREADED, WAITING FOR MAGIC WORDS");
	sleep_until (LevelEventStatus("start_e7_m2_ai_door"), 1);
	//device_set_power(ai_room_door_01, 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	sleep (30);
	f_blip_object (mc_14, default);
	ai_place (sq_e7_m2_ai_grunts);
	ai_place (sq_e7_m2_ai_rangers);
	sleep_until (volume_test_players (tv_e7m2_serverroomdoor), 1);
	f_unblip_object (mc_14);
	device_set_power(dm_door_switch_ai, 1);
	device_set_position_track(dm_door_switch_ai, "device:position", 0);
	device_animate_position (dm_door_switch_ai, 1, 0.25, 1, 0, 0);
	effect_kill_from_flag(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
	b_end_player_goal = TRUE;
end


script static void f_end_events_e7_m2_ai_door
	sleep_until (LevelEventStatus("end_e7_m2_ai_door"), 1);
	//thread(f_engine_open_door(ai_room_door_01, mc_14, dm_door_switch_ai));
	thread(f_music_e07m2_gettoserver());	
	//pup_play_show(ppt_ai_door);	
	print ("SERVER ROOM DOOR SHOULD BE OPENING NOW 343434343434343434343434343");
	device_set_position_track( mc_14, 'any:idle', 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', mc_14, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', mc_14, 1);
	device_animate_position( mc_14, 1, 3.5, 1.0, 1.0, TRUE );
	sleep_until( (device_get_position(mc_14) >= 0.6), 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', mc_14, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	print ("Server Room door should have opened!!! 34343434343434343434343434343434343434343434343434343");
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_secureroom();
	sleep_s(1);
	thread(f_new_objective(ch_e7_m2_6));
end

/* Event Triggered: Raise Servers in AI room slowly over time */
global boolean b_server_complete = false;

script static void f_start_events_e7_m2_6
	sleep_until (LevelEventStatus("start_e7_m2_6"), 1);
	sleep_s(1);
	thread(f_switch_zone_set_e7m2_b());
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_roomclear(); // 5 secs.
	sleep_s(1);
	thread(f_new_objective(ch_e7_m2_7)); 
	device_set_power(server_activate, 1);
end

script static void f_e7_m2_servers
	sleep_until (LevelEventStatus("e7_m2_servers"), 1);
	device_set_power(server_activate, 0);
	thread(f_music_e07m2_silence());
	thread(f_e7_m2_ai_phaseoff(sq_e7_m2_ai_knight_2.bw));
	thread(f_e7_m2_ai_phaseoff(sq_e7m2_guards_31.bw2));
	pup_play_show(ppt_ai_raise_server);
	sleep_s(1);
	thread(f_server_progress_vo());
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_activate', NONE, 1);
	
	thread(f_audio_dm_server_large_1());
	device_set_position_track( dm_server_large_1, 'any:idle', 1 );
	device_animate_position( dm_server_large_1, 1, 30, 1.0, 1.0, TRUE );
	
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_cyclebegun();
	thread(f_music_e07m2_cyclebegun());
	sleep_s(5);

	thread(f_audio_dm_server_small_1());
	device_set_position_track( dm_server_small_1, "any:idle", 1 );
	device_animate_position( dm_server_small_1, 1, 20, 1.0, 1.0, TRUE );

	sleep_s(6);
	
	thread(f_audio_dm_server_small_2());
	device_set_position_track( dm_server_small_2, 'any:idle', 1 );
	device_animate_position( dm_server_small_2, 1, 20, 1.0, 1.0, TRUE );

	sleep_s(6);

	thread(f_audio_dm_server_small_3());
	device_set_position_track( dm_server_small_3, 'any:idle', 1 );
	device_animate_position( dm_server_small_3, 1, 20, 1.0, 1.0, TRUE );

	sleep_s(6);

	thread(f_audio_dm_server_small_4());
	device_set_position_track( dm_server_small_4, 'any:idle', 1 );
	device_animate_position( dm_server_small_4, 1, 20, 1.0, 1.0, TRUE );

	sleep_s(6);

	thread(f_audio_dm_server_large_2());
	device_set_position_track( dm_server_large_2, 'any:idle', 1 );
	device_animate_position( dm_server_large_2, 1, 30, 1.0, 1.0, TRUE );
	
	
	//sleep_s(1);
	//device_set_position_track( dm_server_small_5, 'any:idle', 1 );
	//device_animate_position( dm_server_small_5, 1, 10, 1.0, 1.0, TRUE );
	//sleep_s(1);
	//device_set_position_track( dm_server_small_6, 'any:idle', 1 );
	//device_animate_position( dm_server_small_6, 1, 10, 1.0, 1.0, TRUE );
	//sleep_s(1);
	sleep_until(device_get_position(dm_server_large_2) == 1, 1);
	b_server_complete = true;
end
script static void f_server_progress_vo
	sleep_s(15);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_serverprogress1();
	sleep_s(15);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_serverprogress2();
	sleep_s(15);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_serverprogress3();
	sleep_s(15);
	sleep_until(device_get_position(dm_server_large_2) == 1, 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_serverprogress4();
end
script static void f_event_e7_m2_ai_knight1
	sleep_until (LevelEventStatus("e7_m2_ai_knight1"), 1);
	sleep_s(5);
	ai_place_in_limbo(sq_e7_m2_ai_knight_intro); // +1
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_knightsappear();
	sleep_s(2);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_defendroom();
	sleep_s(2);
	
	ai_place_in_limbo(sq_e7m2_squads_13); // +8
	sleep_s(1);
	//ai_place_in_limbo(gr_e7_m2_guards_14); // +8
	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 4, 1);
	ai_place_in_limbo(sq_e7m2_guards_31); // +1
	//sleep_s(1);
	//ai_place_in_limbo(gr_e7_m2_ai_knight_2); // +1
	
//	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 4, 1);
//	//ai_place_in_limbo(sq_e7m2_squads_13); // +8
//	if (list_count(players()) > 2) then
//		sleep_s(1.5);
//		ai_place_in_limbo(gr_e7_m2_guards_14); // +8
//	end
//	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 8, 1);
	ai_place_in_limbo(gr_e7_m2_ai_knight_2); // +1
	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 3 and ai_living_count(sq_e7m2_guards_31) == 0, 1);
	//ai_place_in_limbo(sq_e7m2_squads_13); // +8
	sleep_s(0.5);
	ai_place_in_limbo(sq_e7m2_guards_31); // +1
	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 3, 1);
	//ai_place_in_limbo(sq_e7m2_squads_13); // +8
	if (list_count(players()) > 2) then
		sleep_s(0.5);
		ai_place_in_limbo(gr_e7_m2_guards_14); // +8
	end
	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 14 and ai_living_count(sq_e7m2_guards_31) == 0, 1);
	ai_place_in_limbo(sq_e7m2_guards_31); // +1
	sleep_s(1);
	sleep_until(ai_living_count(gr_e7_m2_ai_knight_2) == 0, 1);
	ai_place_in_limbo(gr_e7_m2_ai_knight_2); // +1
	
	sleep_until(ai_living_count(e7_m2_gr_ff_all) <= 4, 1);
	if (ai_living_count(e7_m2_gr_ff_all) > 0) then		
		sleep_until (b_e7m2_narrative_is_on == false, 1);
		vo_glo_remainingproms_04();
		f_blip_ai_cui(e7_m2_gr_ff_all, "navpoint_enemy");	
		sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 0, 1);
		f_unblip_ai_cui(e7_m2_gr_ff_all);
	end
	sleep_until(ai_living_count(e7_m2_gr_ff_all) == 0 and b_server_complete == true, 1);
	sleep (30);
	NotifyLevel("start_e7_m2_7");
end

script static void f_start_events_e7_m2_7
	sleep_until (LevelEventStatus("start_e7_m2_7"), 1);
	sleep_s(1);
	thread(f_switch_zone_set_e7m2());
	object_create(cr_e7_m2_ai_console_screen);
	sleep_s(1);
	thread(f_music_e07m2_datalink());
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_datalink();
	device_set_power(ai_activate, 1);
	b_end_player_goal = TRUE;	
	sleep_s(2);
	thread(f_new_objective(ch_e7_m2_8));
	sleep_rand_s(2, 5);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_infinity_03();
end

script static void f_event_e7_m2_back_to_hanger
	sleep_until(LevelEventStatus("start_e7_m2_backtrack"), 1);
	device_set_power(ai_activate, 0);
	pup_play_show(ppt_ai_activate_power);
	sleep (60);
	effect_new(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
	f_fx_ai_server_start(); // start AI effect
	f_audio_ai_activate();
	thread(f_engine_open_monster_door(mc_9));
	sleep_s(3);
	thread(camera_shake_all_coop_players( .1, .7, 1, 0.1));
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_linkactive();
	thread (f_start_events_e7_m2_8());
	thread(f_new_objective(ch_e7_m2_9));
	thread(f_music_e07m2_hangarreturn());
end

// if player runs ahead of h-hallway fight, start hangar fight
script static void f_start_events_e7_m2_8
	sleep_until(b_e7m2_narrative_is_on == false, 1);
	dprint("monitoring player backtrack");
	if (volume_test_players (tv_e7m2_backtrack_1) != true) then
		object_create(lz_1);
		f_e7_m2_breadcrumbs(5, lz_1);
	end
	//sleep_until (b_e7m2_narrative_is_on == false, 1);
	//thread(vo_e7m2_hangarreturn());
	if (volume_test_players (tv_e7m2_backtrack_2) != true) then
		object_create(lz_0);
		f_e7_m2_breadcrumbs(8, lz_0);
	end
	dprint("player hit backtrack");	
	b_end_player_goal = TRUE;	
	sleep_until(volume_test_players(tv_e7m2_backtrack_2) == true, 1);
	b_e7_m2_hallway_backtrack = true;
end

script static void f_start_events_e7_m2_9
	sleep_until (LevelEventStatus("start_e7_m2_9"), 1);
	ai_place(sq_e7m2_covmix_10);
	ai_place(sq_e7_m2_phantom_4);
	NotifyLevel("open_mc5");
	sleep_until (volume_test_players (tv_e7m2_enddialoguetrigger), 1);
	sleep_s(2);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_hangarreturn();
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_backtohangar();
	sleep_until(ai_living_count(e7_m2_gr_ff_all) == 0, 1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_gettoengine();
	device_set_power(power_switch_2, 1);
	f_blip_object_cui(power_switch_2, "navpoint_activate");
	thread(f_new_objective(ch_e7_m2_10));	
	sleep_until(device_get_position(power_switch_2) == 1, 1);
	f_unblip_object_cui(power_switch_2);
	pup_play_show(ppt_hanger_door_main);
	thread(f_music_e07m2_control_activate());
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_glo15_miller_attaboy_01();
			// Miller : Good work, Crimson.
	thread(f_audio_hanger_door_close(hangardoor1));
	device_animate_position( hangardoor1, 0, 5, 1.0, 1.0, TRUE ); // door open 2
	sleep_s(3);
	thread(f_audio_hanger_door_close(hangardoor2));
	device_animate_position( hangardoor2, 0, 5, 1.0, 1.0, TRUE ); // door open 2
	sleep_until (ai_living_count(e7_m2_gr_ff_all) <= 5, 1);
	if (ai_living_count(e7_m2_gr_ff_all) > 0) then
		sleep_until (b_e7m2_narrative_is_on == false, 1);
		vo_glo_remainingcov_01();
		thread(f_new_objective (ch_e7_m3_clear_room));		
		f_blip_ai_cui(e7_m2_gr_ff_all, "navpoint_enemy");	
		sleep_until (ai_living_count(e7_m2_gr_ff_all) == 0, 1);
		f_unblip_ai_cui(e7_m2_gr_ff_all);	
	end	
	sleep_s(5);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_endpip();
	sleep_s(2);
	b_end_player_goal = TRUE;
end

/** Final Phantom **/
global boolean b_no_phantom_in_hangar = FALSE;

script command_script cs_e7_m2_phantom_4()
	f_load_phantom (sq_e7_m2_phantom_4, right, sq_e7m2_covmix_08, sq_e7m2_covmix_08_5, none, none);
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p0, ps_e7_m2_phantom_4.p1);
	cs_fly_to(ps_e7_m2_phantom_4.p8);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p2, ps_e7_m2_phantom_4.p3);
	sleep_s(1);
	//ai_place(sq_e7_m2_final_phantom_1);
	//ai_vehicle_enter_immediate(sq_e7_m2_final_phantom_1, sq_e7_m2_phantom_4, "phantom_p_rf");
	f_unload_phantom (ai_current_actor, "right");
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p4, ps_e7_m2_phantom_4.p5);
	sleep_s(1);
//	sleep_until (b_e7m2_narrative_is_on == false, 1);
//	vo_e7m2_phanton_hanger_01();
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 9, 1);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p4, ps_e7_m2_phantom_4.p2);
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p5, ps_e7_m2_phantom_4.p3);
	f_load_phantom (sq_e7_m2_phantom_4, left, sq_e7m2_covmix_09, sq_e7m2_covmix_09_5, none, none);
	sleep_s(1);
	f_unload_phantom (ai_current_actor, "left");
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p8, ps_e7_m2_phantom_4.p0);
	cs_fly_to_and_face (ps_e7_m2_phantom_4.p1, ps_e7_m2_phantom_4.p0);
	b_no_phantom_in_hangar = TRUE;
	cs_fly_to(ps_e7_m2_phantom_4.p7);
	ai_erase (ai_current_squad);
end

//======================== Door Events ====================================
script static void e7_m2_open_mc1
	sleep_until (LevelEventStatus("open_mc1"), 1);  
	f_engine_open_monster_door(mc_1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_glo_incoming_03();
	sleep_s(1);
	//thread(f_new_objective(ch_e7_m2_defend));
	thread(f_new_objective(ch_7_5_1));
	sleep_forever();
end

script static void e7_m2_open_mc2
	sleep_until (LevelEventStatus("open_mc2"), 1);  
	f_engine_open_monster_door(mc_2);
	sleep_forever();
end

script static void e7_m2_open_mc3
	sleep_until (LevelEventStatus("open_mc3"), 1);  
	f_engine_open_monster_door(mc_3);
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 4);
	if (ai_living_count(e7_m2_gr_ff_all) > 0) then
		sleep_until (b_e7m2_narrative_is_on == false, 1);
		vo_glo_remainingcov_01();
		f_blip_ai_cui(e7_m2_gr_ff_all, "navpoint_enemy");	
		sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 0, 1);
		f_unblip_ai_cui(e7_m2_gr_ff_all);
	end
	sleep_forever();
end

script static void e7_m2_open_mc4
	sleep_until (LevelEventStatus("open_mc4"), 1);  
	thread(f_engine_open_monster_door(mc_4));
	sleep_until(device_get_position(mc_4) == 1);
	object_destroy(mc_4);
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 4);
	if (ai_living_count(e7_m2_gr_ff_all) > 0) then
		sleep_until (b_e7m2_narrative_is_on == false, 1);
		vo_glo_remainingcov_02();
		f_blip_ai_cui(e7_m2_gr_ff_all, "navpoint_enemy");	
		sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 0, 1);
		f_unblip_ai_cui(e7_m2_gr_ff_all);
	end
	sleep_forever();
end

script static void e7_m2_open_mc5
	print ("343434343333433434343434 MC5 DOOR WAITING FOR THE MAGIC WORDS TO OPEN UP AND SPILL BAD GUYS ALL OVER");  
	sleep_until (LevelEventStatus("open_mc5"), 1);
	print ("343434343333433434343434 MC5 DOOR IS SOOOOOOOOO ABOUT TO OPEN RIGHT NOW, IT'S TOTES CRAY CRAY");  
	f_engine_open_monster_door(mc_5);
	sleep_forever();
end


script static void e7_m2_open_mc7
	sleep_until (LevelEventStatus("open_mc7"), 1);  
	f_engine_open_monster_door(mc_7);
	sleep_forever();
end


script static void e7_m2_open_mc13
	sleep_until (LevelEventStatus("open_mc13"), 1);  
	ai_place (sq_e7m2_covmix_07);
	f_engine_open_monster_door(mc_13);
	sleep (90);
	e7m2_reardudesmoveup = TRUE;
end

global boolean b_end_mission = FALSE;
//===========ENDING E7 M2==============================
script static void f_end_mission_e7_m2
	sleep_until (LevelEventStatus("e7_m2_mission_end"), 1);
	thread(f_music_e7m2_finish());
	fade_out (0, 0, 0, 15);
	e7m2_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
	b_game_won = TRUE;
end


script static void e7m2_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end								

//===================== AI COMMAND SCRIPTS =======================
/* PHANTOM 1 */
script command_script cs_e7_m2_phantom_1()
	print("phantom 1");
	f_load_phantom (sq_e7_m2_phantom_1, left, sq_e7m2_covmix_01, sq_e7m2_covmix_02, none, none);
	cs_ignore_obstacles (true);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	b_hangar_init_wave = FALSE;
	cs_fly_to_and_face (ps_e7_m2_phantom_1.p0, ps_e7_m2_phantom_1.p1);
	sleep_s(1);
	print("phantom 2");
	cs_vehicle_speed (0.7);	
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	thread(vo_e7m2_hangarphantom());
	cs_fly_to_and_face (ps_e7_m2_phantom_1.p8, ps_e7_m2_phantom_1.p9);
	//sleep_s(3);
	print("phantom 2a");
	cs_fly_to (ps_e7_m2_phantom_1.p2);
	//sleep_s(3);
	print("phantom 3");
	cs_vehicle_speed (0.4);	
	cs_fly_to_and_face (ps_e7_m2_phantom_1.p2, ps_e7_m2_phantom_1.p3);
	//sleep_s (3);
	print("phantom 4");
	f_unload_phantom (sq_e7_m2_phantom_1, "left");
	//sleep_s(3);
	//f_load_phantom (sq_e6_m1_phantom_4, dual, sq_e6_m1_factory_25, sq_e6_m1_factory_28, none, none);

	//cs_fly_to_and_face (ps_e7_m2_phantom_1.p3, ps_e7_m2_phantom_1.p4);
	print("phantom 5");
	cs_fly_to_and_face (ps_e7_m2_phantom_1.p2, ps_e7_m2_phantom_1.p6);
	cs_fly_to (ps_e7_m2_phantom_1.p6);
	cs_fly_to_and_face (ps_e7_m2_phantom_1.p4, ps_e7_m2_phantom_1.p7);
	//sleep_s(10);
	//cs_fly_to_and_face (ps_e7_m2_phantom_1.p4, ps_e7_m2_phantom_1.p7);
	//sleep_s(2);
	cs_fly_to (ps_e7_m2_phantom_1.p5);

	ai_erase (ai_current_squad);
end

/* PHANTOM 2 */
script command_script cs_e7_m2_phantom_2()
	f_load_phantom (sq_e7_m2_phantom_2, left, sq_e7m2_4gru_01, sq_e7m2_4jak_01, none, none);
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p0, ps_e7_m2_phantom_2.p1);
	sleep_s(0.5);
	cs_vehicle_speed (0.4);	
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p2, ps_e7_m2_phantom_2.p3);
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p4, ps_e7_m2_phantom_2.p5);
	sleep_s(0.5);
	f_unload_phantom (ai_current_actor, "left");
	sleep_s(0.5);
	cs_vehicle_speed (0.2);	
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p4, ps_e7_m2_phantom_2.p6);
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p8, ps_e7_m2_phantom_2.p9);
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p10, ps_e7_m2_phantom_2.p11);
	f_load_phantom (sq_e7_m2_phantom_2, left, sq_e7_m2_hangar_phantom_3c, none, none, none);
	sleep_s(0.5);
	f_unload_phantom (ai_current_actor, "left");
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_2.p7, ps_e7_m2_phantom_2.p11);
	sleep_s(0.5);
	cs_vehicle_speed (0.7);	
	cs_fly_to (ps_e7_m2_phantom_2.p12);
	b_e7_m2_phantom_2_unloaded = true;
	sleep (30 * 5);
	
	ai_erase (ai_current_squad);
end


/* Phantom 3 */
script command_script cs_e7_m2_phantom_3()

	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 10);
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p0, ps_e7_m2_phantom_3.p1);

	
	cs_vehicle_speed (0.3);	
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p0, ps_e7_m2_phantom_3.p7);
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p8, ps_e7_m2_phantom_3.p9);
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p2, ps_e7_m2_phantom_3.p3);
	sleep_s(3);
	f_unload_phantom (ai_current_actor, "dual");
	//sleep_s(2);
	//cs_fly_to_and_face (ps_e7_m2_phantom_3.p3, ps_e7_m2_phantom_3.p4);
	//sleep_s(3);
	//f_unload_phantom (ai_current_actor, "left");
	sleep_s(2);
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p8, ps_e7_m2_phantom_3.p2);
	sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_3.p5, ps_e7_m2_phantom_3.p8);
	sleep_s(2);
	cs_fly_to(ps_e7_m2_phantom_3.p6);
	sleep_s (4);
	f_unload_phantom (ai_current_actor, "dual");
	sleep_s(3);
	
	
	ai_erase (ai_current_squad);
end



script command_script cs_e7_m2_phantom_5()
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_fly_to(ps_e7_m2_phantom_5.p7);
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_5.p1, ps_e7_m2_phantom_5.p0);
	sleep_s(0.5);
	ai_place(sq_e7_m2_hangar_phantom_3a);
	ai_vehicle_enter_immediate(sq_e7_m2_hangar_phantom_3a, ai_current_actor, "phantom_p_rf");
	ai_place(sq_e7_m2_hangar_phantom_3b);
	ai_vehicle_enter_immediate(sq_e7_m2_hangar_phantom_3b, ai_current_actor, "phantom_p_rb");
	
	cs_fly_to_and_face (ps_e7_m2_phantom_5.p3, ps_e7_m2_phantom_5.p2);
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_5.p5, ps_e7_m2_phantom_5.p4);
	sleep_s(0.5);
	f_unload_phantom (ai_current_actor, "dual");
	b_e7_m2_phantom_5_unloaded = true;
	sleep_s(0.5);
	cs_fly_to_and_face (ps_e7_m2_phantom_5.p5, ps_e7_m2_phantom_5.p7);
	//sleep_s(1);
	cs_fly_to_and_face (ps_e7_m2_phantom_5.p6, ps_e7_m2_phantom_5.p7);
	sleep_s(0.5);
	cs_fly_to(ps_e7_m2_phantom_5.p7);
	cs_fly_to(ps_e7_m2_phantom_5.p8);
	ai_erase (ai_current_squad);
	
end



script command_script cs_kamikaze_grunt
	ai_grunt_kamikaze (ai_current_actor);
end
//=============== AI ROOM BATTLE WAGON PHASE =================
script static void f_e7_m2_ai_phaseoff(ai knightname)
repeat
	if (volume_test_object(tv_e7m2_phaseoff1, ai_get_unit(knightname)) == TRUE) then
	cs_phase_to_point(knightname, 1, ps_e7_m2_server.p3);
	end
	sleep_s(5);
until (b_e7_m2_hallway_backtrack == true);
end
//=============== AI ROOM SURPRISE TIMER =====================
global boolean b_wake_ai_enemies = FALSE;
script command_script cs_e7_m2_ai_ambush
	thread(f_ai_wakeup_timer());
	sleep_until((unit_get_health(ai_current_actor) <= 0.99) or (b_wake_ai_enemies == TRUE) , 1);
	if(b_wake_ai_enemies == FALSE) then
		print("Wake all AI Room enemies");
		b_wake_ai_enemies = TRUE;
	end
end

script command_script cs_ai_knight_intro
	//ai_enter_limbo (ai_current_actor);
	sleep_s(0.5);
	cs_phase_in ();
	sleep(10);
	//cs_custom_animation(e9_m1_cov_interior_2.spawn_points_1, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "any:any:melee_tackle", FALSE);
	sleep_s(2);
	cs_phase_to_point(ps_e7_m2_ai_knight_intro.p0);
end
script static void f_ai_wakeup_timer
	sleep_s(5);
	b_wake_ai_enemies = TRUE;
end

//======== UTILITY FUNCTIONS =============================
script static void f_e7_m2_switch_push(object control, unit player)
	g_ics_player = player;
	
	if control == dc_test then
		print("Test Button Hit");
		device_animate_position(dm_railing2, 0, 1, 0.1, 0.1, TRUE);
	object_move_to_point(block_nav1, 0, ps_lift.p3);
	device_set_position_track( dm_e7_m2_launchpad2, 'any:idle', 1 );
	sleep_s(2);
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_inf_lift', dm_e7_m2_launchpad2, 1 ); //AUDIO!
	device_animate_position(dm_e7_m2_launchpad2, 1, 10, 0.1, 0.1, TRUE);
	sleep_until(device_get_position(dm_e7_m2_launchpad2) >= 1, 1);
	
	//device_set_position_track( dm_e7_m2_ramp_platform, 'any:idle', 1 );
	device_animate_position(dm_e7_m2_launchpad2, 1, 2, 0.1, 0.1, TRUE);
	end
end

script static void f_e7_m2_breadcrumbs (real objectdistance, object flag)
	navpoint_track_object_named (flag, "navpoint_goto");
	
	print ("The radius of the marker is...");
	inspect (objectDistance);
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag) <= objectDistance and objects_distance_to_object ((player0), flag) > 0 ) or
		(objects_distance_to_object ((player1), flag) <= objectDistance and objects_distance_to_object ((player1), flag) > 0 ) or
		(objects_distance_to_object ((player2), flag) <= objectDistance and objects_distance_to_object ((player2), flag) > 0 ) or
		(objects_distance_to_object ((player3), flag) <= objectDistance and objects_distance_to_object ((player3), flag) > 0 ), 1);	
	print ("------player(s) made it to the location------");

	navpoint_track_object (flag, false);
	object_destroy (flag);

end

/*
script static void hide_dummy_nav_lifts
	sleep_until(object_valid(dm_dummy_nav_lift_1), 1);
	object_hide(dm_dummy_nav_lift_1, TRUE);
	sleep_until(object_valid(dm_dummy_nav_lift_2), 1);
	object_hide(dm_dummy_nav_lift_2, TRUE);
end
*/
script command_script cs_hangar_exit_jump_0
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p0, ps_e7_m3_hangar_exit_jump.p6);
	//sleep_s(0.5);
	cs_jump(45, 3);
end
script command_script cs_hangar_exit_jump_1
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p1, ps_e7_m3_hangar_exit_jump.p7);
	//sleep_s(0.5);
	cs_jump(45, 3);
end
script command_script cs_hangar_exit_jump_2
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p2, ps_e7_m3_hangar_exit_jump.p8);
	//sleep_s(0.5);
	cs_jump(45, 3);
end
script command_script cs_hangar_exit_jump_3
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p3, ps_e7_m3_hangar_exit_jump.p9);
	//sleep_s(0.5);
	cs_jump(45, 3);
end
script command_script cs_hangar_exit_jump_4
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p4, ps_e7_m3_hangar_exit_jump.p10);
	//sleep_s(0.5);
	cs_jump(45, 3);
end
script command_script cs_hangar_exit_jump_5
	cs_go_to_and_face(ps_e7_m3_hangar_exit_jump.p5, ps_e7_m3_hangar_exit_jump.p11);
	//sleep_s(0.5);
	cs_jump(45, 3);
end


script static void f_switch_zone_set_e7m2 // unload knights, load in elites
	//sleep_until (LevelEventStatus("switch_zoneset_e7_m2"), 1);
	print("preparing to switch zone set to e7_m2");
	sleep_until (ai_living_count(e7_m2_gr_ff_all)<= 0, 1);
	sleep (150);
	prepare_to_switch_to_zone_set (e7_m2);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print("prep complete");
	print("switching zone set to e7_m2");
	switch_zone_set (e7_m2);
	thread(f_init_navmesh_prop());
	thread(f_init_destroy_server_props());
end


script static void f_switch_zone_set_e7m2_b // unload elites, load in knights
	//sleep_until (LevelEventStatus("switch_zoneset_e7_m2_b"), 1);
	print("preparing to switch zone set to e7_m2_b");
	sleep (90);
	prepare_to_switch_to_zone_set (e7_m2_b);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print("prep complete");
	
	print("switching zone set to e7_m2_b");
	switch_zone_set (e7_m2_b);
	thread(f_init_navmesh_prop());
	thread(f_init_destroy_server_props());
end

script command_script cs_e7_m2_forerunner_phase_in
	ai_enter_limbo (ai_current_actor);
	sleep_s(0.5);
	cs_phase_in ();
end

script command_script cs_e7_m2_pawn_phase_in
	ai_enter_limbo (ai_current_actor);
	sleep_rand_s (0.1, 0.6);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script static void f_event_e7_m2_blip_ai_door
	sleep_until (LevelEventStatus("event_e7_m2_blip_ai_door"), 1);  
	sleep_s(1);
	sleep_until (b_e7m2_narrative_is_on == false, 1);
	vo_e7m2_enter_serverroom();
end

//======== PHANTOM FUNCTIONS =============================



	////////////////////////////////////////////////
	




script static void f_audio_shield(ai phantomname)
		// Phantom 1
	dprint("waiting for phantom******************"); 
	f_play_shieldsound_in(phantomname);
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(phantomname)) == false, 1);
	f_play_shieldsound_out(phantomname);
end	
	
script static void f_play_shieldsound_in(ai phantomname)
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(phantomname)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(phantomname), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);
end

script static void f_play_shieldsound_out(ai phantomname)
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(phantomname)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(phantomname), 1); 
end

	/*
	////////////////////////////////////////////////
	//THIS IS CRAZY SCRIPT STUFF TO HELP SHOW HOW MODULAR STUFF CAN BE:
	/*script static void f_play_shieldsound(trigger_volume volumename, sound soundname1, sound soundname2, ai phantomname)
	sleep_until(volume_test_objects(volumename, unit_get_vehicle(phantomname)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( soundname1, unit_get_vehicle(phantomname), 1); 
	sound_impulse_start ( soundname2, NONE, 1);
end
thread(f_play_shieldsound(tv_audio_shield,
													'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01',
													'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff',
												  sq_e7_m2_phantom_1.phantom));
	*/
	
	
	///////////
	// DATA FOR YOU:
	
	/*
	
		// Phantom 1
	dprint("waiting for phantom******************"); 
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_1.phantom)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_1.phantom), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);	
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_1.phantom)) == false, 1);	
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_1.phantom)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_1.phantom), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);
	
	
	
	
	
		//Phantom 2
	dprint("waiting for phantom******************"); 
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_2.phantom_2)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_2.phantom_2), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);		
		//Phantom 3
	dprint("waiting for phantom******************"); 
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_3.phantom_3)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_3.phantom_3), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);
		//Phantom 4
	dprint("waiting for phantom******************"); 
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_4.phantom_2)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_4.phantom_2), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);
		//Phantom 5
	dprint("waiting for phantom******************"); 
	sleep_until(volume_test_objects(tv_audio_shield, unit_get_vehicle(sq_e7_m2_phantom_5.phantom_2)) == true, 1);
	dprint("phantom_recongnized-------------------"); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_phantom_break_shield_01', unit_get_vehicle(sq_e7_m2_phantom_5.phantom_2), 1); 
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_hanger_alarm_oneoff', NONE, 1);
end

*/