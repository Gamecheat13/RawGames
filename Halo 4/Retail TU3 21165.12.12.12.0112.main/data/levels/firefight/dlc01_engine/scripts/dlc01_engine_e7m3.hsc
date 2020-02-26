// =============================================================================================================================
//========= ENGINE E7M3 FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================
global object g_ics_player = none;

global boolean b_e7_m3_nuke1_defused = FALSE;
global boolean b_e7_m3_game_lost = FALSE;
global long l_nukes_remaining = 6;

global boolean e7m2_gotoengineroom = FALSE;
global short e7m3_nukeactive = 0;

global boolean e7m3_activate3rdnuke = FALSE;
global boolean b_e7_m3_nuke2_defused = FALSE;
global boolean b_e7_m3_nuke3_defused = FALSE;
global boolean b_e7_m3_nuke4_defused = FALSE;
global boolean b_e7_m3_nuke5_defused = FALSE;
global boolean b_e7_m3_nuke6_defused = FALSE;
global boolean b_e7_m3_nuke7_defused = FALSE;
global boolean b_e7_m3_all_nukes_defused = FALSE;

global boolean b_e7_m3_elite1_killed = FALSE;
global boolean b_e7_m3_elite2_killed = FALSE;
global boolean b_e7_m3_elite3_killed = FALSE;
global boolean b_e7_m3_elite4_killed = FALSE;
global boolean b_e7_m3_elite5_killed = FALSE;

global real r_time_given_engine = 900;
global real r_time_given_ai = 120;

script startup dlc01_engine_e7_m3
	if ( f_spops_mission_startup_wait("is_e7_m3") ) then
		wake( dlc01_engine_e7_m3_init );
	end
end

script dormant dlc01_engine_e7_m3_init
	dprint ("Dec 6 | 10:00PM");	
	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup("e7_m3", e7_m3, gr_e7_m3_ff_all, sc_e7_m3_spawn_points_0, 90);
	//switch_zone_set (e7_m3);
	//ai_ff_all = gr_e7_m3_ff_all;
	
	thread (f_start_player_intro_e7_m3());
	thread (f_events_e7_m3_1()); // first event must be called from startup function
	thread (f_start_all_events_e7_m3());
	thread (f_music_e07m3_start());
	
//======= OBJECTS ==================================================================
	//f_add_crate_folder(sc_e7_m3_props);
	f_add_crate_folder(eq_e7_m3_ammo);
	f_add_crate_folder(wp_e7_m3_weapons);
	//f_add_crate_folder(e7_m3_doors);
	f_add_crate_folder(dm_e7_m3_doors);
	f_add_crate_folder(dm_e7_m3_doors_inactive);
	f_add_crate_folder(dm_e7_m3_switches);
	f_add_crate_folder(dm_e7_m3_hangar_props);
	f_add_crate_folder(dm_e7_m3_nukes);
	//f_add_crate_folder(dm_e7_m3_lifts);
	//f_add_crate_folder(dc_e7_m3_door_switches);
	f_add_crate_folder(dc_e7_m3_objective_switches);	
	//f_add_crate_folder(sc_e7_m3_objective_nukes);	
	f_add_crate_folder(v_turrets);
	f_add_crate_folder(sc_wp);
	f_add_crate_folder(sc_e7_m3_frames);
	f_add_crate_folder(cr_e7_m3_unsc_ammo); //Ammo Crates
	f_add_crate_folder(cr_e7_m3_cov_cover); 
	f_add_crate_folder(cr_e7_m3_unsc_cover);
	//f_add_crate_folder(cr_e7_m3_unsc_props); 
	object_create(engine_server_hum_01);
	object_create(engine_server_hum_02);
	object_create(engine_server_hum_03);
	object_create(engine_server_hum_04);
	object_create(engine_server_hum_05);
	object_create(engine_server_hum_06);
	

	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_0, 90); //spawns in the Hanger
	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_1, 91); //spawns at end of H HAll
	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_2, 92); //spawns in hallway before AI
	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_3, 93); //spawns before engine room
	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_4, 94); //spawns outside hangar
	firefight_mode_set_crate_folder_at(sc_e7_m3_spawn_points_5, 95); //spawns in engine room
	//firefight_mode_set_objective_name_at(dc_door_switch_1, 1); //switch on first door
	firefight_mode_set_objective_name_at(wp_1, 2); //objective marker in first room
	firefight_mode_set_objective_name_at(sc_nuke_1, 3); //nuke 1 in first room
	firefight_mode_set_objective_name_at(wp_2, 4); //objective marker at end of first room
	firefight_mode_set_objective_name_at(wp_3, 5); //objective marker in second room
	firefight_mode_set_objective_name_at(wp_4, 8); //objective marker in second room
	firefight_mode_set_objective_name_at(wp_5, 9); //objective marker in second room
	//firefight_mode_set_objective_name_at(dc_door_switch_3, 6); // Door Switch to AI room
	//firefight_mode_set_objective_name_at(dc_door_switch_2, 7); //nuke 3 in second room 
	firefight_mode_set_objective_name_at(dc_nuke_2, 10);
	//firefight_mode_set_objective_name_at(nuke_5, 8);
	//firefight_mode_set_objective_name_at(nuke_6, 9);
	//firefight_mode_set_objective_name_at(nuke_6, 12);
	//firefight_mode_set_objective_name_at(test_nuke, 11);
	
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w1_grunt, 40); 
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w1a_grunt, 41); 
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w1b_grunt, 42); 
	firefight_mode_set_squad_at(sq_e7_m3_hallway_w1c_grunt, 47); 
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w2_pawn_left, 43);
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w2_pawn_right, 44); 
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_knight, 45); //AI Room Hallway
	//firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_bishops, 46); //AI Room Hallway
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_pawns, 47);
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_pawns2, 63);
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_pawns3, 70);
	firefight_mode_set_squad_at(gr_e7_m3_hallway_w3_pawns_init, 69);
	
	firefight_mode_set_squad_at(gr_e7_m3_ai_w1_knight, 48);
	firefight_mode_set_squad_at(sq_e7_m3_ai_w2_init, 71);
	firefight_mode_set_squad_at(gr_e7_m3_ai_w2_cov1, 49);
	firefight_mode_set_squad_at(gr_e7_m3_ai_w2_cov2, 66);
	firefight_mode_set_squad_at(gr_e7_m3_ai_w2_exit1, 67);
	firefight_mode_set_squad_at(gr_e7_m3_ai_w2_exit2, 68);
	
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_center_grunt, 50); //Engine Room Squad 
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_center_jump, 51);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_left, 52);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_right, 53);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_balc_left, 54);
	firefight_mode_set_squad_at(gr_e7_m3_ff_unsc, 55);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w1_balc_right, 56);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w2_balc_center1, 57);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w2_balc_center2, 58);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w2_ctrl_left, 59);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w2_ctrl_right, 60);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w3_balc_center, 61);
	//firefight_mode_set_squad_at(gr_e7_m3_engine_w3_air_center, 62);
	//firefight_mode_set_squad_at(gr_e7_m3_engine_w4_knight, 63);
	firefight_mode_set_squad_at(gr_e7_m3_engine_w4_snipers, 64);
	firefight_mode_set_squad_at(gr_e7_m3_engine_nuke_elite_all, 65);
	
	//	Disable Kill volumes from E7M4
	kill_volume_disable(kill_tv_e7_m4_engine1);							
	//kill_volume_disable(kill_tv_e7_m4_engine2a);							
	//kill_volume_disable(kill_tv_e7_m4_engine2b);							
	kill_volume_disable(kill_tv_e7_m4_engine3);
	f_spops_mission_setup_complete( TRUE );
end
//==== MAIN SCRIPT STARTS ==================================================================
script static void f_start_all_events_e7_m3
	thread(f_hangar_lift());
	sleep_until (b_players_are_alive(), 1); 
	thread (f_events_e7_m3_2());
	thread (f_events_e7_m3_3());
	thread (f_events_e7_m3_4());
	thread (f_event_e7_m3_4a());
	thread (f_end_mission_e7_m3());
	thread (e7m3_nuke_anims());
	thread (e7m3_nuke_hide());
	//thread(f_event_nuke_1_control_script());
	//thread (f_event_nuke_1_deactivated());
	//thread (f_mission_failed());
	thread (f_hallway_encounter_manager());
	//thread (f_events_e7_m3_hallway_knights());
	thread (f_events_e7_m3_engine_room());
	thread (f_dialog_e7_m3_engine_room());
	//thread (f_engine_room_enemies_complete());
	thread (f_e7_m3_engine_w1_cleared());
	//thread (f_e7_m3_init_servers());
	thread (f_nuke1_ai_waves());
	thread(f_switch_zone_set_e7m3_b());
	thread(f_e7m3_rvb_interact());
	
	thread(f_ai_switch_start());
	thread(f_fx_ai_server_start());
	
end


//=========== NEW NUKE SCRIPT ====================================

script static void e7m3_nuke_hide()
	sleep_until (object_valid (dm_e7m3_nuke02), 1);
	object_hide (dm_e7m3_nuke02, TRUE);
	sleep_until (object_valid (dm_e7m3_nuke03), 1);
	object_hide (dm_e7m3_nuke03, TRUE);
	sleep_until (object_valid (dm_e7m3_nuke04), 1);
	object_hide (dm_e7m3_nuke04, TRUE);
	sleep_until (object_valid (dm_e7m3_nuke05), 1);
	object_hide (dm_e7m3_nuke05, TRUE);
	sleep_until (object_valid (dm_e7m3_nuke06), 1);
	object_hide (dm_e7m3_nuke06, TRUE);
	sleep_until (object_valid (dm_e7m3_nuke07), 1);
	object_hide (dm_e7m3_nuke07, TRUE);
end


script static void e7m3_nuke_anims()
	print ("Waiting for 1st Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_1) > 0.0, 1);
	print ("1st Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke01, 1);
	print ("Waiting for 2nd Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_2) > 0.0, 1);
	print ("2nd Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke02, 1);
	print ("Waiting for 3rd Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_3) > 0.0, 1);
	print ("3rd Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke03, 1);
	print ("Waiting for 4th Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_4) > 0.0, 1);
	print ("4th Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke04, 1);
	print ("Waiting for 5th Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_5) > 0.0, 1);
	print ("5th Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke05, 1);
	print ("Waiting for 6th Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_6) > 0.0, 1);
	print ("6th Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke06, 1);
	print ("Waiting for 7th Nuke switch to be pressed");
	sleep_until (device_get_position (dc_nuke_7) > 0.0, 1);
	print ("7th Nuke switch pressed, animating now");
	//sleep (30);
	device_set_position (dm_e7m3_nuke07, 1);
end

//=========== INTRO ====================================
script static void f_start_player_intro_e7_m3
	sleep_until(f_spops_mission_setup_complete(), 1);
	if editor_mode() then
		sleep_s (1);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e7m2_vin_sfx_intro', NONE, 1);
		//intro_vignette_e7_m3();
	end
	f_spops_mission_intro_complete( TRUE );
	/*firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
//		intro_vignette_e7_m3();
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e7m2_vin_sfx_intro', NONE, 1);
		intro_vignette_e7_m3();
	end
	switch_zone_set (e7_m3);

	print ("_____________done with vignette---SPAWNING__________________");

	firefight_mode_set_player_spawn_suppressed(false);
	sleep_until (b_players_are_alive(), 1);
	fade_in (0,0,0,15);
	sleep (15);*/
	sleep_until (object_valid (dm_e7_m2_launchpad1), 1);
	object_destroy (dm_e7_m2_launchpad1);
	sleep_until (object_valid (dm_e7_m2_launchpad2), 1);
	object_destroy (dm_e7_m2_launchpad2);
end

script static void intro_vignette_e7_m3
	dprint ("_____________starting vignette__________________");
	//sleep_s (8);
	cinematic_start();
	ai_enter_limbo (gr_e7_m3_ff_all);
//	thread (f_music_e9m5_vignette_start());
//	b_wait_for_narrative = true;
//		ai_exit_limbo(gr_e7_m3_marines_1);			
//	ai_exit_limbo (gr_e7_m3_ai_all); 			//remove ai enemies from limbo state
//	sleep(1);																
	pup_play_show(e7_m3_intro);
//	vo_e7m2_intro();
//	thread (f_music_e9m4_vignette_finish());
//	sleep_until (b_wait_for_narrative == false);
	ai_exit_limbo (gr_e7_m3_ff_all);
	cinematic_stop();
end

//=================================== BUTTON CALLOUT FUNCTIONS ===============================
script static void f_e7_m3_switch_push(object control, unit player)
	g_ics_player = player;
	
	if control == dc_door_switch_1 then
		//pup_play_show(ppt_e7_m3_door_1);		
		//f_engine_open_door(dc_door_switch_1, dm_door_5, dm_door_switch_1);
		//f_unblip_object_cui (dc_door_switch_1);
		sleep (30);
	elseif control == dc_door_switch_2 then
		pup_play_show(ppt_e7_m3_door_2);		
		f_engine_open_door(dc_door_switch_2, dm_door_6, dm_door_switch_2);
	elseif control == dc_door_switch_3	 then
//		pup_play_show(ppt_e7_m3_door_3);		
//		f_engine_open_door(dc_door_switch_3, dm_door_4, dm_door_switch_3);
//		f_unblip_object_cui (dc_door_switch_3);
		sleep (30);
	elseif control == dc_door_switch_4 then
		f_engine_open_door(dc_door_switch_4, dm_door_2, dm_door_switch_4);
		f_unblip_object_cui (dc_door_switch_4);
		sleep_s(3);
		f_engine_open_monster_door(dm_door_3);
	elseif control == dc_test_door_switch then
		vo_e7m3_enterserver();
		vo_e7m3_disarmbomb();	
	end
end


//==================== END BUTTON CALLOUT FUNCTIONS ===============================


//=========== MISSION PROGRESSION ======================
/** EVENT: Clear hallway to AI Room **/
script static void f_events_e7_m3_1
	thread(f_music_e07m3_playstart());
	sleep_until (LevelEventStatus("e7_m3_clear_hallway"), 1);
	sleep_until (b_players_are_alive(), 1); 
	sleep_s(0.5);
	vo_e7m3_playstart();
	f_blip_object (dm_door_5, default);
	//device_set_power(dc_door_switch_1, 1);
	//device_set_position_track(dm_door_switch_1, "device:position", 0);
	//device_animate_position (dm_door_switch_1, 1, 0.25, 1, 0, 0);
	thread(f_new_objective (ch_e7_m3_investigate));
	sleep_until (volume_test_players (tv_e7m3_openhangardoor), 1);
	f_unblip_object (dm_door_5);
	device_set_power(dm_door_switch_1, 1);
	device_set_position_track(dm_door_switch_1, "device:position", 0);
	device_animate_position (dm_door_switch_1, 1, 0.25, 1, 0, 0);
	sleep (30);
	device_set_position_track( dm_door_5, 'any:idle', 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door_5, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door_5, 1);
	device_animate_position( dm_door_5, 1, 3.5, 1.0, 1.0, TRUE );
	sleep_until( (device_get_position(dm_door_5) >= 0.6), 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door_5, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	b_end_player_goal = TRUE;
	sleep_rand_s(2, 5);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_infinity_01();
end


script static void f_events_e7_m3_2
	sleep_until (LevelEventStatus("e7_m3_clear_hallway_complete"), 1);
	f_engine_open_monster_door(dm_door_10);
	f_create_new_spawn_folder(94);
end


script static void f_events_e7_m3_hallway_knights
	sleep_until (LevelEventStatus("e7_m3_hallway_knights"), 1);
	sleep_s(1);
	ai_place(sq_e7_m3_hallway_w2_knight);
	sleep_until((ai_living_count(sq_e7_m3_hallway_w2_knight) == 0) or ((ai_living_count(gr_e7_m3_hallway_w2_pawn_left) + ai_living_count(gr_e7_m3_hallway_w2_pawn_right)) == 0));
	ai_place(sq_e7_m3_hallway_w2_knight);
	sleep_until((ai_living_count(gr_e7_m3_hallway_w2_pawn_left) + ai_living_count(gr_e7_m3_hallway_w2_pawn_right)) == 0);
	dprint("*********** RESETTING AI OBJECTIVES ***********");
	//ai_reset_objective(gr_e7_m3_hallway_w2_knight);
end

/* Objective Event Triggered: AI ROOM NUKE */
global boolean b_ai_room_knight_teleport = FALSE;
script static void f_events_e7_m3_3
	sleep_until (LevelEventStatus("e7_m3_nuke1_script"), 1);
	f_unblip_object_cui (wp_2);
	//object_create(sc_nuke_1);
	ai_place(sq_e7_m3_ai_w1_elites); //combat:pistol:ne:reload_1
	ai_place(sq_e7_m3_ai_w2_init); //combat:pistol:ne:reload_1
	ai_place(sq_e7_m3_ai_w2_cov1); //combat:pistol:ne:reload_1	
	//effect_new_on_object_marker(levels\firefight\dlc01_engine\fx\warhead_collided.effect, sc_nuke_1, attach_point);
	f_engine_open_monster_door(dm_door_4);
	//thread(f_ai_nuke_timer());
	thread(f_music_e07m3_enterserver());
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_enterserver();
	b_ai_room_knight_teleport = TRUE;

			// Enemies Clear - Play VO and blip bomb
	sleep_until(ai_living_count(gr_e7_m3_ff_all) <= 0, 1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_disarmbomb();
	sleep_s(1);
	object_create(dc_nuke_1);
	device_set_power(dc_nuke_1, 1);
	f_blip_object_cui (dc_nuke_1, "navpoint_deactivate");
	sleep_until(b_e7_m3_nuke1_defused == true, 1);
	b_end_player_goal = TRUE;	
end

script static void f_nuke1_ai_waves
	sleep_until (LevelEventStatus("e7_m3_ai_to_engine"), 1);
	thread(f_check_ai_player_at_door());
	f_engine_open_monster_door(dm_door_2);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_duringfight(); 
		// Roland : Spartan Miller, I've got all the security feeds on the ship.
		// Roland : It worries me I couldn't see they had this nuke.	
	sleep_s(5);
			// Get to Engine VO
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);	
	if (b_e7m3_rvb_interact == true) then
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e7m3_fightending_RVBALT(); // Red VS Blue dialog
	else
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e7m3_fightending(); //Sargent Velasco to all channels! 
	end
	thread(f_new_objective (ch_e7_m3_secure_engine));
end

script static void f_events_e7_m3_4
	sleep_until (LevelEventStatus("e7_m3_ai_complete"), 1);
	thread(f_music_e07m3_fightending());
	sleep_s(1);

	if (volume_test_players (tv_e7m3_breadcrumb1) != true) then
		object_create(wp_4);
		f_waypoint_breadcrumbs(5, wp_4);
	end
	object_create(wp_3);
	f_waypoint_breadcrumbs(5, wp_3);
	b_end_player_goal = TRUE;	
	f_engine_open_monster_door(dm_door_3);
end

// May be obsolete. Commented out thread
global boolean b_ai_to_engine_spawned = FALSE;
script static void f_event_nuke_1_deactivated
	sleep_s(1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_disarmed(); 
			// Miller : Did it work?  Are we okay?
			// Roland : Everything in the area wasn't reduced to its component molecules, so I'm gonna say…yes?
			// Miller : Back on the road to the engine room then.  Let's go, Spartan!
	
end

global boolean b_ai_player_at_door = FALSE;
script static void f_check_ai_player_at_door
	repeat
		if (volume_test_players(tv_ai_player_at_door)) then
			b_ai_player_at_door = TRUE;
		else
			b_ai_player_at_door = FALSE;
		end
	until (LevelEventStatus("e7_m3_engine_w1_start"), 5);
end
script static void f_event_e7_m3_4a
	sleep_until (LevelEventStatus("e7_m3_engine_w1_start"), 1);
	f_engine_open_monster_door(dm_door_3);
	sleep_s(5);
	thread(f_music_e07m3_fightending());
end

script static void f_event_e7_m3_engine_nuke2_dialog(unit ai_elite)	
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_2ndbombfight();
			// Roland : Spartan Miller, I'm sincerely concerned about my inability to spot these threats.
			// Roland : I see everything on the ship at all times.  Why can't I see this?	
	sleep_until ((unit_get_health(ai_elite) <= 0), 1);	
	object_hide (dm_e7m3_nuke02, FALSE);
	
	//gmurphy 12-19-2012 -- unhiding next nuke because VO line mentions marking the next NUKE
	object_hide (dm_e7m3_nuke03, FALSE);
	
	//object_create(sc_nuke_2);
	//effect_new_on_object_marker(levels\firefight\dlc01_engine\fx\warhead_collided.effect, sc_nuke_2, attach_point);
	sleep_s(1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_2ndbomb1();
			// Miller : There's a weird power reading nearby...
	thread(f_music_e07m3_2nddisarmed());
	sleep_until(ai_living_count(gr_e7_m3_ff_all) <= 5, 1);
	if (ai_living_count(gr_e7_m3_ff_all) > 0) then
		f_blip_ai_cui(gr_e7_m3_ff_all, "navpoint_enemy");
		sleep_until(ai_living_count(gr_e7_m3_ff_all) <= 0, 1);
		f_unblip_ai_cui(gr_e7_m3_ff_all);
	end	
	b_end_player_goal = TRUE;
end


/** ENGINE ROOM: Move Marines to Center **/
global boolean b_e7_m3_engine_ally_entrance = TRUE;
script static void f_e7_m3_engine_w1_cleared
	sleep_until (LevelEventStatus("e7_m3_engine_w1_clear"), 1);	
	dprint("engine w1 cleared");
	b_e7_m3_engine_ally_entrance = FALSE;
end

/** Objective Triggered Event: Defused Nuke2 in center. Start MAIN Engine Encounter  **/
script static void f_events_e7_m3_engine_room
	sleep_until (LevelEventStatus("e7_m3_engine_room_script"), 1);	
	thread(f_engine_nuke_elite_wave());
	e7m2_gotoengineroom = TRUE;
	//thread(f_engine_nuke_timer());
end

script static void f_dialog_e7_m3_engine_room
	sleep_until (LevelEventStatus("e7_m3_engine_nuke2_dialog"), 1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_2ndbomb2();
			// Roland : Another nuke!  Why didn't I see it before?
			// Miller : Crimson, same drill.  Disarm that explosive!	
	thread(f_new_objective(ch_e7_m3_disarm));	
	object_create(dc_nuke_2);
	thread(f_blip_object_cui (dc_nuke_2, "navpoint_deactivate"));	
	device_set_power(dc_nuke_2, 1);	
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_2ndbomb3();	
			// Roland : Make it quick, okay?  There's a timer on this one, and it's primed.
	sleep_until (device_get_power(device(dc_nuke_2)) < 1 or device_get_position(device(dc_nuke_2)) > 0, 1);	
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_2nddisarmed();
			// Miller : That did it!  Excellent work, Crimson.
			// Roland : Spartan Miller, I know why I couldn't see the bombs.
			// Roland : They've been outfitted with active camouflage.
			// Miller : How can you tell?
			// Roland : Because when Crimson killed the Elite holding the remote, they appeared on my sensors.			
			// Miller : Crimson!  Move!
	sleep_s(1);
	thread(f_new_objective (ch_e7_m3_search));
	e7m3_activate3rdnuke = TRUE;		//jadiaz - Added boolean to make mission wait until correct time to reveal nuke
	b_end_player_goal = TRUE;
end

//=========== ENDING ===================================
script static void f_end_mission_e7_m3
	sleep_until (LevelEventStatus("e7_m3_mission_end"), 1);
	fade_out (0, 0, 0, 15);
	e7m3_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	ai_erase(gr_e7_m3_ff_unsc); // erase friendlies just in case...
	sleep (30 * 1);
	b_end_player_goal = true;
	b_game_won = TRUE;
end


script static void e7m3_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end

//======================= H Hallway Encounter Manager ====================/
global boolean b_player_in_hallway = FALSE;

script static void f_hallway_encounter_manager
	sleep_until(LevelEventStatus("e7_m3_clear_hallway_complete"), 1);
	dprint("triggered time passed");
	ai_place(gr_e7_m3_hallway_w1a_grunt);
	ai_place(gr_e7_m3_hallway_w1b_grunt);
	b_player_in_hallway = TRUE;
	sleep_until(ai_living_count(gr_e7_m3_ff_all)<= 7, 1);
	dprint("spawning pawns");
	//	NEW SPAWN POINT
	ai_place_in_limbo (gr_e7_m3_hallway_w2_pawn_left);
	sleep_s(0.5);
	ai_place_in_limbo (gr_e7_m3_hallway_w2_pawn_right);
	sleep_s(0.5);
	dprint("spawning knight");
	ai_place_in_limbo(sq_e7_m3_hallway_w2_knight);
	//	sleep_until((ai_living_count(sq_e7_m3_hallway_w2_knight) == 0) or (ai_living_count(gr_e7_m3_hallway_w2_pawn_parent)  <= 3));
	//	dprint("spawning second knight");
	//	ai_place_in_limbo(sq_e7_m3_hallway_w2_knight_2);
	//	sleep_until(ai_living_count(gr_e7_m3_ff_all) <= 5, 1);
	//	if (ai_living_count(gr_e7_m3_ff_all) > 0) then
	//		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	//		vo_glo_cleararea_03();		
	//		f_blip_ai_cui(gr_e7_m3_ff_all, "navpoint_enemy");
	//	end
	sleep_until(ai_living_count(gr_e7_m3_ff_all) <= 3, 1);
	f_unblip_object_cui (wp_1);
	sleep_s(1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_firstalert();
	thread(f_hallway_breadcrumb());
	thread(f_new_objective (ch_e7_m3_secure_ai));
	//object_create(dc_door_switch_2);
	b_end_player_goal = TRUE;	
	sleep_until (e7m3_blipdoor01 == TRUE, 1);
	sleep_until (volume_test_players (tv_2ndhallway_trigger), 1);
	print ("trigger for 2nd hallway door hit");
	f_unblip_object (dm_door_6);
	device_set_power(dc_door_switch_2, 1);
	device_set_position_track( dm_door_switch_2, "device:position", 0 );
	device_animate_position (dm_door_switch_2, 1, 0.25, 1, 0, 0);
	sleep (30);
	device_set_position_track( dm_door_6, 'any:idle', 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door_6, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door_6, 1);
	device_animate_position( dm_door_6, 1, 3.5, 1.0, 1.0, TRUE );
	sleep_until( (device_get_position(dm_door_6) >= 0.6), 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door_6, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	device_set_power(dc_door_switch_2, 0);
	b_end_player_goal = TRUE;
end


script static void f_hallway_breadcrumb
	sleep_until(LevelEventStatus("e7_m3_hallway_breadcrumb"), 1);
	sleep_s(0.5);
	thread(f_hallway_breadcrumb_wp());
	sleep_rand_s(2, 5);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_infinity_02();
end

script static void f_hallway_breadcrumb_wp
	//object_create(wp_5);
	//object_create(wp_2);
	//f_waypoint_breadcrumbs(5, wp_5);
	//f_waypoint_breadcrumbs(10, wp_2);
	sleep (30);
end

global real r_streaming_state = 0;
script static void f_switch_zone_set_e7m3_b // unload knights, load in elites
	sleep_until (LevelEventStatus("switch_zoneset_e7_m3_b"), 1);
	//sleep_until (object_valid(wp_2) != true, 1);
	dprint("waypoint hit, start stream");
	f_engine_close_monster_door(dm_door_5);
	sleep_s(3);
	dprint("preparing to switch zone set to e7_m3_b");
	b_e7_m3_rvb_valid = false;
	prepare_to_switch_to_zone_set (e7_m3_b);
	volume_teleport_players_inside(tv_player_in_hangar, cf_teleport_to_ai);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	dprint("prep complete");
	dprint("switching zone set to e7_m3_b");	
	switch_zone_set (e7_m3_b);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	thread(vo_e7m3_getintheserver());
		// Miller : Server room is right there.
		// Miller : Roland, the server room’s locked down from the inside.
		// Roland : Not much I can do about it. The same power cycle that will fix the hangar doors will fix that.
		// Miller : Spartans, give me a second here and I’ll see what I can do for you. There has to be some sort of emergency release...
		// Miller : Okay, got it. The emergency override on the door locks is located right there. Hit that and you’re in.
	
	sleep_until (b_e7m3_narrative_is_on == FALSE, 1);
	effect_new(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
	f_blip_object (dm_door_4, default);
	b_end_player_goal = TRUE;
end

script static void f_ai_switch_start
	sleep_until (LevelEventStatus("e7_m3_ai_switch"), 1);
	sleep_until (volume_test_players (tv_serverdoor_trigger), 1);
	print ("trigger for 2nd hallway door hit");
	f_unblip_object (dm_door_4);
	b_end_player_goal = TRUE;
	device_set_power(dc_door_switch_3, 1);
	device_set_position_track( dm_door_switch_3, "device:position", 0 );
	device_animate_position (dm_door_switch_3, 1, 0.25, 1, 0, 0);
	sleep (30);
	device_set_position_track( dm_door_4, 'any:idle', 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door_4, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door_4, 1);
	device_animate_position( dm_door_4, 1, 3.5, 1.0, 1.0, TRUE );
	sleep_until( (device_get_position(dm_door_4) >= 0.6), 1 );
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door_4, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	device_set_power(dc_door_switch_3, 0);
end

script static void f_prepare_engine_load
	sleep_until(volume_test_players(tv_player_in_hangar) == true, 1);
	f_engine_close_monster_door(dm_door_5);
	//device_animate_position (dm_door_5, 0, 2, 1, 0, 0);
	switch_zone_set (e7_m3_b);
	r_streaming_state = 1; // use if you need to check for all players in an area
end
//=======================================================================================
//===================================== AI ROOM =========================================
script static void f_mission_failed
	sleep_until (b_e7_m3_game_lost == TRUE);
	dprint("LOST THE MATCH");
	b_game_lost = TRUE;
	ai_erase(gr_e7_m3_ff_unsc);
	ai_erase_all();
	cui_load_screen (ui\in_game\pve_outro\mission_failed.cui_screen);
	fade_out(0, 0, 0, 90); 
	//game_lost(true); // does nothing...	
end

script static void f_ai_nuke_timer
	local long l_timer_start = 0;
	local real r_time_passed = 0.0;
	local real r_time_left = 0.0;
	local boolean b_e7_m3_nuke1_timeout = FALSE;
	local boolean b_e7_m3_timer_warning_ai = TRUE;
	local boolean b_show_obj = TRUE;
	l_timer_start = game_tick_get();
	
	repeat
		// calculate the time passed since the core auto damage started
		r_time_passed = frames_to_seconds(game_tick_get() - l_timer_start);
		r_time_left = r_time_given_ai - r_time_passed;
		//dprint(string (r_time_left));
		
		if (ai_living_count(gr_e7_m3_ff_all) == 0 and b_show_obj) then
			thread(f_new_objective (ch_e7_m3_disarm));
			b_show_obj = FALSE;
		end
		if (r_time_left <= 30.0 and b_e7_m3_timer_warning_ai) then
			b_e7_m3_timer_warning_ai = FALSE;
			//cinematic_set_title_delayed(ch_e7_m3_warning_last, 3);
		end
		if (r_time_left <= 0.0) then
			b_e7_m3_nuke1_timeout = TRUE;
		end 
	until( b_e7_m3_nuke1_defused or b_e7_m3_nuke1_timeout , 1 );
	
	// check if bomb defused or if time ran out
	if (b_e7_m3_nuke1_timeout) then
		b_e7_m3_game_lost = TRUE; 
		sleep_forever();
	end

	f_objective_complete();
	b_end_player_goal = TRUE;
end
//================================= END AI ROOM =========================================

//=================================== ENGINE ROOM ==================================
/** Engine Room Timer **/
script static void f_engine_nuke_timer
	local long l_timer_start = 0;
	local real r_time_passed = 0.0;
	local real r_time_left = 0.0;
	local boolean b_e7_m3_engine_nuke_timeout = FALSE;
	
	local boolean b_e7_m3_timer_warning_10 = TRUE;
	local boolean b_e7_m3_timer_warning_5 = TRUE;
	local boolean b_e7_m3_timer_warning_1 = TRUE;
	local boolean b_e7_m3_timer_warning_last = TRUE;
	
	l_timer_start = game_tick_get();
	
	repeat
		// calculate the time passed since the core auto damage started
		r_time_passed = frames_to_seconds(game_tick_get() - l_timer_start);
		r_time_left = r_time_given_engine - r_time_passed;
		
		//dprint(string (r_time_left));
		
		if (r_time_left <= 600.0 and b_e7_m3_timer_warning_10) then
			b_e7_m3_timer_warning_10 = FALSE;
			//cinematic_set_title_delayed(ch_e7_m3_warning_10, 3);
		end
		if (r_time_left <= 300.0 and b_e7_m3_timer_warning_5) then
			b_e7_m3_timer_warning_5 = FALSE;
			//cinematic_set_title_delayed(ch_e7_m3_warning_5, 3);
		end
		if (r_time_left <= 60.0 and b_e7_m3_timer_warning_1) then
			b_e7_m3_timer_warning_1 = FALSE;
			//cinematic_set_title_delayed(ch_e7_m3_warning_1, 3);
		end
		if (r_time_left <= 30.0 and b_e7_m3_timer_warning_last) then
			b_e7_m3_timer_warning_last = FALSE;
			//cinematic_set_title_delayed(ch_e7_m3_warning_last, 3);
		end
		// LOSE: Time ran out 
		if (r_time_left <= 0.0) then
			b_e7_m3_engine_nuke_timeout = TRUE;
		end 
		
		// WIN: All nukes were DEFUSED
		if (b_e7_m3_nuke3_defused and b_e7_m3_nuke4_defused and b_e7_m3_nuke5_defused and b_e7_m3_nuke6_defused and b_e7_m3_nuke7_defused) then
			b_e7_m3_all_nukes_defused = TRUE;
		end
	until( b_e7_m3_all_nukes_defused or b_e7_m3_engine_nuke_timeout , 1 );
	
	// check if bomb defused or if time ran out
	if (b_e7_m3_engine_nuke_timeout) then
		b_e7_m3_game_lost = TRUE; 
		sleep_forever();
	end
	
	if ai_living_count(gr_e7_m3_ff_all) > 0 then
		thread(f_new_objective (ch_e7_m3_clear_room));
		f_blip_ai_cui(gr_e7_m3_ff_all, "navpoint_enemy");	
		sleep_until (ai_living_count(gr_e7_m3_ff_all) <= 0, 1);
		f_unblip_ai_cui(gr_e7_m3_ff_all);	
	end
end

/** On ELITE Death, Reveal and Blip Nuke **/
script static void f_engine_reveal_nuke(object_name nuke_scene, object_name nuke_control)
	//object_create(nuke_scene);
	object_create(nuke_control);
	device_set_power(device(nuke_control), 1);
	//effect_new_on_object_marker(levels\firefight\dlc01_engine\fx\warhead_collided.effect, nuke_scene, attach_point);
	local real r_dialog_index = random_range(0, 3);
	f_blip_object_cui (nuke_control, "navpoint_deactivate");
	if (r_dialog_index == 0) then
		dprint ("Roland: Picking up another nuke on sensors.");
	elseif (r_dialog_index == 1) then
		dprint ("Roland: Marking another one now.");
	elseif (r_dialog_index == 2) then
		dprint("Roland: Locking onto another one.");
	else
		dprint ("Roland: Marking the next one now.");
	end
	sleep_s(0.5);
		
end
/* Engine Room Encounter Manager */
script static void f_engine_nuke_elite_wave
	ai_place (gr_e7_m3_engine_w2_balc_center1); // balcony left
	ai_place (gr_e7_m3_engine_w2_balc_center2); // balcony right
	ai_place (gr_e7_m3_engine_nuke_elite_1); // balcony center elite with fuel rod
	print ("Elite for Nuke 3 is spawned! 3434343343434343434343433434343434343");
	
	//gmurphy 12-18-2012 -- uncommenting out this sleep to wait until the elite is dead before revealing the nuke
	//bug 10747
	//gmurphy 12-19-2012 -- commenting out again because the VO says it is marking the next nuke
	//sleep_until (ai_living_count(gr_e7_m3_engine_nuke_elite_1) < 1, 1);
			// Marking Nuke 3
	//object_hide (dm_e7m3_nuke03, FALSE);
	
	sleep_until (e7m3_activate3rdnuke == TRUE, 1);		//jadiaz - Added boolean to make mission wait until correct time to reveal nuke
	f_engine_reveal_nuke(sc_nuke_3, dc_nuke_3); // reveal left control room
	print ("Nuke Revealed! 34343434343434343434343434343");
	b_e7_m3_elite1_killed = TRUE; // move remaining guys to door of room
	e7m3_nukeactive = 3;
	//if (ai_living_count(gr_e7_m3_ff_all) <= 10) then
		ai_place(gr_e7_m3_engine_w2_ctrl_left); // spawn inside control room
	//end	
	
	sleep_until(b_e7_m3_nuke3_defused == TRUE);
	ai_place (gr_e7_m3_engine_nuke_elite_2); // balcony left elite by nuke
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place (gr_e7_m3_engine_w2_balc_center1); // balcony left
	end
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place (gr_e7_m3_engine_w3_balc_center); // balcony center
	end
	
	sleep_until (ai_living_count(gr_e7_m3_engine_nuke_elite_2) < 1, 1);
			// Marking Nuke 4
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e07m3_2ndnuke();
				// Roland : There’s another nuke.
				// Miller : Shut it down, Crimson.
	object_hide (dm_e7m3_nuke04, FALSE);
	f_engine_reveal_nuke(sc_nuke_4, dc_nuke_4); // nuke on balcony left
	b_e7_m3_elite2_killed = TRUE;
	e7m3_nukeactive = 4;
	print ("Nuke Revealed! 34343434343434343434343434343");
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(sq_e7_m3_engine_left_reinf); // hunt the player
	end
	sleep_rand_s(2, 5);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e7m3_infinity_03();
	sleep_until(b_e7_m3_nuke4_defused == TRUE);
	ai_place (gr_e7_m3_engine_nuke_elite_3); // balcony right elite by nuke
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place (gr_e7_m3_engine_w2_balc_center2); // balcony right
	end
	
	sleep_until (ai_living_count(gr_e7_m3_engine_nuke_elite_3) < 1, 1);
			// Marking Nuke 5
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
	vo_e07m3_3rdnuke1();
				// Roland : Another havoc located. Marking it.
	object_hide (dm_e7m3_nuke05, FALSE);
	f_engine_reveal_nuke(sc_nuke_5, dc_nuke_5);
	e7m3_nukeactive = 5;
	print ("Nuke Revealed! 34343434343434343434343434343");
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(sq_e7_m3_engine_right_reinf);
	end
	
	sleep_until(b_e7_m3_nuke5_defused == TRUE);
	ai_place (gr_e7_m3_engine_nuke_elite_4); // elite in right control room, turret or sniper, w/ sword, retreats into room
	f_engine_open_monster_door(dm_door_8);
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(gr_e7_m3_engine_w1_balc_right); // right control room fodder
		f_engine_open_monster_door(dm_door_9);		
	end
	
	sleep_until (ai_living_count(gr_e7_m3_engine_nuke_elite_4) < 1, 1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
			// Marking Nuke 6
	vo_e07m3_4thnuke1();
				// Roland : Spartan Miller, there’s another nuke.
				// Miller : Get it, Crimson.
	object_hide (dm_e7m3_nuke06, FALSE);
	f_engine_reveal_nuke(sc_nuke_6, dc_nuke_6);
	e7m3_nukeactive = 6;
	print ("Nuke Revealed! 34343434343434343434343434343");
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(gr_e7_m3_engine_w2_ctrl_right); // right control room fodder
	end
	f_engine_open_monster_door(dm_door_7);
	
	sleep_until(b_e7_m3_nuke6_defused == TRUE);
	f_create_new_spawn_folder(95);
	ai_place (gr_e7_m3_engine_nuke_elite_5);
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(gr_e7_m3_engine_w4_snipers);
	end
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(sq_e7_m3_engine_right_reinf); 
	end
	
	sleep_until (ai_living_count(gr_e7_m3_engine_nuke_elite_5) < 1, 1);
	sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
			// Marking Nuke 7
	vo_e07m3_3rdnuke1();
				// Roland : Another havoc located. Marking it.
	object_hide (dm_e7m3_nuke07, FALSE);
	f_engine_reveal_nuke(sc_nuke_7, dc_nuke_7);
	e7m3_nukeactive = 7;
	print ("Nuke Revealed! 34343434343434343434343434343");
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(sq_e7_m3_engine_rear_right_rein);
	end
	if (ai_living_count(gr_e7_m3_ff_all) <= 16) then
		ai_place(sq_e7_m3_engine_rear_left_rein);
	end
end

script static void f_e7_m3_nuke_defused(object control, unit player)
	g_ics_player = player;
	
	if control == dc_nuke_1 then
		// AI ROOM
		b_e7_m3_nuke1_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_1);
		//object_destroy(sc_nuke_1);
		//object_destroy(dc_nuke_1);
		thread(f_event_nuke_1_deactivated());
		sleep (60);
		f_unblip_object_cui (dc_nuke_1);
	elseif control == dc_nuke_2 then
		b_e7_m3_nuke2_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_2);
		l_nukes_remaining = 5;
		//sleep_s(1);
		//object_destroy(sc_nuke_2);
		//object_destroy(dc_nuke_2);
		//ai_place(sq_e7_m3_engine_w2_left_reinf);
		sleep (60);
		f_unblip_object_cui (dc_nuke_2);
	elseif control == dc_nuke_3 then
		// ENGINE_6 BALCONY REAR
		b_e7_m3_nuke3_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_3);
		l_nukes_remaining = 4;
		//object_destroy(sc_nuke_3);
		//object_destroy(dc_nuke_3);
		e7m3_nukeactive = 1;
		sleep (60);
		f_unblip_object_cui (dc_nuke_3);
	elseif control == dc_nuke_4 then
		// ENGINE_1 GROUND CENTER
		b_e7_m3_nuke4_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_4);
		l_nukes_remaining = 3;
		//object_destroy(sc_nuke_4);
		//object_destroy(dc_nuke_4);		
		e7m3_nukeactive = 1;
		sleep (60);
		f_unblip_object_cui (dc_nuke_4);
	elseif control == dc_nuke_5 then
		// ENGINE_2 CONTROL ROOM LEFT
		b_e7_m3_nuke5_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_5);
		l_nukes_remaining = 2;
		//object_destroy(sc_nuke_5);
		//object_destroy(dc_nuke_5);
		e7m3_nukeactive = 1;
		//ai_place(sq_e7_m3_engine_w2_right_reinf);
		if l_nukes_remaining > 0 then
			ai_place(sq_e7_m3_engine_left_reinf);
		end
		sleep (60);
		f_unblip_object_cui (dc_nuke_5);
	elseif control == dc_nuke_6 then
		// ENGINE_4 CONTROL ROOM RIGHT
		b_e7_m3_nuke6_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_nuke_disarm', NONE, 1);
		f_unblip_object_cui (dc_nuke_6);
		l_nukes_remaining = 1;
		//object_destroy(sc_nuke_6);
		//object_destroy(dc_nuke_6);
		e7m3_nukeactive = 1;
		if l_nukes_remaining > 0 then
			ai_place(sq_e7_m3_engine_right_reinf);
		end
		//ai_place(sq_e7_m3_engine_w2_left_reinf);
		sleep (60);
		f_unblip_object_cui (dc_nuke_6);
	elseif control == dc_nuke_7 then
		// ENGINE_3 FAR LEFT BACK CORNER
		b_e7_m3_nuke7_defused = TRUE;
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\specifics\engine_final_nuke_disarm', NONE, 1);
		l_nukes_remaining = 0;
		sleep_s(1);
		//object_destroy(sc_nuke_7);
		//object_destroy(dc_nuke_7);
		e7m3_nukeactive = 0;
		if l_nukes_remaining > 0 then
			ai_place(sq_e7_m3_engine_rear_left_rein);
		end
		sleep (60);
		f_unblip_object_cui (dc_nuke_7);
		//ai_place(sq_e7_m3_engine_w2_left_reinf);
	//elseif control == reveal_nuke then
		//object_create(sc_test_nuke);
		//effect_new_on_object_marker_loop(levels\firefight\dlc01_engine\fx\warhead_collided.effect, sc_test_nuke, attach_point);
		//effect_new_on_object_marker(objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, sc_test_nuke, attach_point);
		//effect_new_on_object_marker(levels\firefight\dlc01_engine\fx\warhead_collided.effect, v_test_warthog, fx_body_burning_hood);
		//sleep_s(3);
		//effect_stop_object_marker(levels\firefight\dlc01_engine\fx\warhead_collided.effect, sc_test_nuke, attach_point);
	end
	
	if l_nukes_remaining == 5 then		
		dprint("first engine nuke defused");		
			// Defused Nuke 2 (VO setup)
			
	elseif l_nukes_remaining == 4 then		
		sleep_s(1);		
			// Defused Nuke 3
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e07m3_1stnuke();
				// Miller : Nuke’s disarmed.
				// Miller : Keep looking, Crimson.
				// Roland : It’s possible there’s others.	
	elseif l_nukes_remaining == 3 then
		sleep_s(1);
			// Defused Nuke 4
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e7m3_nukeprogress_2();
				// Miller : Good work, Crimson.  Keep going.
	elseif l_nukes_remaining == 2 then
		sleep_s(1);
			// Defused Nuke 5
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e07m3_3rdnuke2();
				// Miller : Nuke’s disarmed.
	elseif l_nukes_remaining == 1 then
		sleep_s(1);
			// Defused Nuke 6
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e07m3_4thnuke2();
				// Roland : That’s it. Nuke disarmed.
				// Miller : Excellent work!
	elseif l_nukes_remaining == 0 then
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
			// Defused Nuke 7
		vo_e7m3_nukeprogress_5();
				// Miller : That's it!
		if ai_living_count(gr_e7_m3_ff_all) > 0 then
			sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
			vo_e7m3_clearroom();
				// Miller : Secure the room, Crimson.
			thread(f_new_objective (ch_e7_m3_clear_room));
			sleep_until (ai_living_count(gr_e7_m3_ff_all) <= 5, 1);
			sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
			vo_glo_remainingcov_01();
			f_blip_ai_cui(gr_e7_m3_ff_all, "navpoint_enemy");	
			sleep_until (ai_living_count(gr_e7_m3_ff_all) == 0, 1);
			f_unblip_ai_cui(gr_e7_m3_ff_all);	
		end
		thread(f_music_e07m3_finish());
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e7m3_nukeprogress_6();
				// Roland : Confirmed.  All warheads disarmed!
		sleep(10);
		sleep_until(b_e7m3_narrative_is_on == FALSE, 1);
		vo_e7m3_ending();
				// Miller : Roland, engine room's secured.  Who else could use Crimson's help?
				// Roland : Actually, the engine room could.  It's secure, but there's reinforcements en route.
				// Miller : Hear that, Spartans?  Fortify positions as quickly as possible.  More bad guys headed your way.
		f_objective_complete();
		b_end_player_goal = TRUE;
	end
end
//======================== END ENGINE ROOM FUNCTIONALITY ===========================

//============================ AI COMMAND SCRIPTS ================================
global short s_knight_phase = 0;
script command_script cs_e7_m3_hallway_corner
	thread(f_monitor_knight_shields(ai_current_actor));
	s_knight_phase = 0;
end
script static void f_monitor_knight_shields(unit knight)
	sleep_until(unit_get_shield(knight) <= 0);
	s_knight_phase = 1;
	sleep_until(unit_get_shield(knight) >= 0.75);
	sleep_until(unit_get_shield(knight) <= 0.25);
	s_knight_phase = 2;
end

script command_script cs_e7_m3_forerunner_phase_in
	sleep_rand_s (0.1, 0.6);
	cs_phase_in();
end

script command_script cs_e7_m3_pawn_phase_in
	sleep_rand_s (0.1, 0.6);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

global boolean b_break_bomb_animation = false;
script command_script cs_e7_m3_elite_plant_bomb
	dprint("spawned elite planting bomb");
	ai_set_blind(ai_current_actor, true);
	cs_stow(true);
	thread(f_e7_m3_elite_plant_bomb(ai_current_actor));
	repeat
		dprint("anim loop***************************");
		cs_custom_animation (objects\characters\storm_elite\storm_elite.model_animation_graph, "combat:pistol:spr:reload_1", TRUE);
		sleep_s(2);
	until (b_break_bomb_animation == true, 1);
	dprint("anim loop broken");
	cs_stow(false);
	ai_set_blind(ai_current_actor, false);
	dprint("elite return to normal behavior");
end

script static void f_e7_m3_elite_plant_bomb(ai ai_current_actor)
	sleep_until(volume_test_players(tv_hallway_to_ai) == true or unit_get_shield(ai_current_actor) < 1, 1);
	dprint("stop animation on elite planting bomb");
	unit_stop_custom_animation (ai_current_actor);
	b_break_bomb_animation = true;
end

script command_script cs_e7_m3_engine_jackal_jump
	sleep_s(real_random_range(1.5, 3));
	//cs_go_to_and_face(west_goon.p0,west_goon.p1);
	cs_jump(60, 6);
end
script command_script cs_e7_m3_engine_elite_jump
	thread(f_event_e7_m3_engine_nuke2_dialog(ai_current_actor));
	sleep_s(3.5);
	cs_jump(60, 6);
end
script command_script cs_e7_m3_nuke_elite_1
	sleep(2);
	cs_go_to_and_face(ps_e7_m3_engine_spawn_jump.p0,ps_e7_m3_engine_spawn_jump.p0);
	cs_jump(45, 3);
end

script command_script cs_e7_m3_nuke_elite_2
	sleep(2);
	cs_go_to_and_face(ps_e7_m3_engine_spawn_jump.p3,ps_e7_m3_engine_spawn_jump.p3);
	cs_jump(30, 4);
end

script command_script cs_e7_m3_nuke_elite_3
	sleep(2);
	cs_go_to_and_face(ps_e7_m3_engine_spawn_jump.p4,ps_e7_m3_engine_spawn_jump.p4);
	cs_jump(30, 4);
end

script command_script cs_e7_m3_nuke_elite_5
	sleep(2);
	cs_go_to_and_face(ps_e7_m3_engine_spawn_jump.p1,ps_e7_m3_engine_spawn_jump.p1);
	cs_jump(45, 4);
end

script command_script cs_e7_m3_engine_w1_back_1
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end
script command_script cs_e7_m3_engine_w1_back_2
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end
script command_script cs_e7_m3_engine_w1_back_3
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end
script command_script cs_e7_m3_engine_w1_back_4
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end
script command_script cs_e7_m3_engine_w1_back_5
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end
script command_script cs_e7_m3_engine_w1_back_6
	ai_cannot_die(ai_current_actor, true);
	sleep_s(real_random_range(0.5, 2));
	cs_jump(75, 8);
	sleep_s(1);
	ai_cannot_die(ai_current_actor, false);
end

//ai_playfight(ai, boolean);
//cs_phase_in

/******************************** 
	Spawn Commands for Engine Room 
	Balcony Jump Spawns
*********************************/


script command_script cs_e7_m3_engine_jump_lf_1
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_01,ps_e7_m3_engine_top_spawn.lf_01);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_2
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_02,ps_e7_m3_engine_top_spawn.lf_02);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_3
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_03,ps_e7_m3_engine_top_spawn.lf_03);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_4
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_04,ps_e7_m3_engine_top_spawn.lf_04);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_5
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_05,ps_e7_m3_engine_top_spawn.lf_05);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_6
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_06,ps_e7_m3_engine_top_spawn.lf_06);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_7
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_07,ps_e7_m3_engine_top_spawn.lf_07);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_8
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_08,ps_e7_m3_engine_top_spawn.lf_08);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_9
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_09,ps_e7_m3_engine_top_spawn.lf_09);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_10
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_10,ps_e7_m3_engine_top_spawn.lf_10);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_11
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_11,ps_e7_m3_engine_top_spawn.lf_11);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_12
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_12,ps_e7_m3_engine_top_spawn.lf_12);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_13
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_13,ps_e7_m3_engine_top_spawn.lf_13);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_14
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_14,ps_e7_m3_engine_top_spawn.lf_14);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_lf_15
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_15,ps_e7_m3_engine_top_spawn.lf_15);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_16
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_16,ps_e7_m3_engine_top_spawn.lf_16);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_lf_17
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.lf_17,ps_e7_m3_engine_top_spawn.lf_17);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_1
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_01,ps_e7_m3_engine_top_spawn.r_01);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_2
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_02,ps_e7_m3_engine_top_spawn.r_02);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_3
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_03,ps_e7_m3_engine_top_spawn.r_03);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_4
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_04,ps_e7_m3_engine_top_spawn.r_04);
	cs_jump(60, 3);
end
script command_script cs_e7_m3_engine_jump_r_5
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_05,ps_e7_m3_engine_top_spawn.r_05);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_6
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_06,ps_e7_m3_engine_top_spawn.r_06);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_7
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_07,ps_e7_m3_engine_top_spawn.r_07);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_8
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_08,ps_e7_m3_engine_top_spawn.r_08);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_9
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_09,ps_e7_m3_engine_top_spawn.r_09);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_10
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_10,ps_e7_m3_engine_top_spawn.r_10);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_11
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_11,ps_e7_m3_engine_top_spawn.r_11);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_12
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_12,ps_e7_m3_engine_top_spawn.r_12);
	cs_jump(65, 4);
end
script command_script cs_e7_m3_engine_jump_r_13
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_13,ps_e7_m3_engine_top_spawn.r_13);
	cs_jump(45, 4);
end
script command_script cs_e7_m3_engine_jump_r_14
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_14,ps_e7_m3_engine_top_spawn.r_14);
	cs_jump(60, 4);
end
script command_script cs_e7_m3_engine_jump_r_15
	cs_go_to_and_face(ps_e7_m3_engine_top_spawn.r_15,ps_e7_m3_engine_top_spawn.r_15);
	cs_jump(60, 4);
end

script command_script cs_e7_m3_ai_playfight
	ai_playfight(ai_current_actor, true);
end

global boolean b_e7m3_rvb_interact = false;
global boolean b_e7_m3_rvb_valid = true;
script static void f_e7m3_rvb_interact
	dprint ("start RVB");
	object_create (cr_e7_m3_rvb);
	object_create (cr_e7_m3_hangar_lift_screen);  
	sleep_until (object_get_health (cr_e7_m3_rvb) < 1 and (b_e7_m3_rvb_valid == true), 1);
	dprint ("rvb interacted");
	object_cannot_take_damage (cr_e7_m3_rvb);
	//play stinger
	print ("Playing RVB Stinger Audio");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
  sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme'));
  print ("RVB Stinger Audio Played");
	b_e7m3_rvb_interact = true;
	inspect (b_e7m3_rvb_interact);
	f_achievement_spops_1();
end


script static void f_hangar_lift
	sleep_until(object_valid(dm_railing1), 1);
	device_set_position_track( dm_railing1, "any:idle", 1 );
	device_animate_position( dm_railing1, 1, 1, 1.0, 1.0, TRUE );
	
	/*sleep_until(object_valid(dm_railing2), 1);
	device_set_position_track( dm_railing2, "any:idle", 1 );
	device_animate_position( dm_railing2, 1, 1, 1.0, 1.0, TRUE );
	object_move_to_point(block_nav1, 1, ps_lift.p0);*/
	
	sleep_until(object_valid(dm_e7_m3_launchpad2), 1);
	device_set_position_track( dm_e7_m3_launchpad2, 'any:idle', 1 );
	device_animate_position(dm_e7_m3_launchpad2, 1, 1, 0.1, 0.1, TRUE);
	object_create(dc_lift_switch);
	sleep_until(device_get_position(dc_lift_switch) == 1, 1);
	pup_play_show(ppt_hangar_lift);
	sleep_s(3);
	object_destroy(cr_e7_m3_hangar_lift_screen);
	//object_move_to_point(block_nav1, 0, ps_lift.p2);
	
	device_set_position_track( dm_e7_m3_launchpad1, 'any:idle', 1 );	
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_inf_lift', dm_e7_m2_launchpad2, 1 ); //AUDIO!
	thread(hangar_lift_railing());
	device_animate_position(dm_e7_m3_launchpad1, 1, 10, 0.1, 0.1, TRUE);
	sleep_until(device_get_position(dm_e7_m3_launchpad2) >= 1, 1);
	
	//device_set_position_track( dm_e7_m2_ramp_platform, 'any:idle', 1 );
	//device_animate_position(dm_e7_m2_launchpad2, 1, 2, 0.1, 0.1, TRUE);
end

script static void hangar_lift_railing
	sleep_s(2);
	device_animate_position(dm_railing1, 0, 1, 0.1, 0.1, TRUE);	
end