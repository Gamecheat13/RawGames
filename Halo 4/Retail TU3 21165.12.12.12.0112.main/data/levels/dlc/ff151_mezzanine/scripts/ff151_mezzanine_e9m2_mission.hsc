// =============================================================================================================================
// ============================================ E9M2 MEZZANINE MISISON SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean b_hunters_are_dead = FALSE;
global boolean b_92_blip_first_computer = FALSE;
global boolean b_force_second_wing = FALSE;
global boolean b_blip_second_terminal = FALSE;
global boolean b_explosions_done = FALSE;
global boolean b_92_switch_first_terminal = FALSE;
global boolean b_progress_finale = FALSE;
global boolean b_explosions_started = FALSE;

global short 	 s_finale_timer = 0;
global short   s_bring_in_explosions = 0;

// ============================================	STARTUP SCRIPT	========================================================

script startup e9m2_mezzanine_startup

	print( "mezzanine_e9_m2 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e9_m2") ) then
		wake( mezzanine_e9_m2_init );
	end

end

script dormant mezzanine_e9_m2_init
//	sleep_until (LevelEventStatus ("e9m2_var_startup"), 1);

	print ("************STARTING E9 M2*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e9_m2", e9m2_main, gr_e9m2_ff_all, sc_e9_m2_spawnpoints_0, 90 );
	
	

	
	//start all the rest of the event scripts
	//thread (f_start_all_events_e9_m2());
	f_start_all_events_e9_m2();
	print ("starting e9_m2 all events thread");

//======== OBJECTS ==================================================================


//	//	//	//	FOLDER SPAWNING	\\	\\	\\
//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	//f_add_crate_folder(sc_e9_m2_objectives); 
	f_add_crate_folder(cr_e9_m2_cov_cover); 
	f_add_crate_folder(cr_e9_m2_objectives); 
	f_add_crate_folder(wp_e9_m2_weapons); 
	f_add_crate_folder(cr_e9_m2_cov_ammo); 
	f_add_crate_folder(cr_e9_m2_unsc_ammo); 
	f_add_crate_folder(cr_e9_m2_oni);
	
	//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e9_m2_spawnpoints_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e9_m2_spawnpoints_1, 91); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e9_m2_spawnpoints_2, 92); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e9_m2_spawnpoints_3, 93); //spawns in the main starting area

//set objective names
	
	firefight_mode_set_objective_name_at(dc_e9_m2_map1,			1); //iff tag 1
	firefight_mode_set_objective_name_at(dc_e9_m2_map2,			2); //iff tag 2
	firefight_mode_set_objective_name_at(dc_e9_m2_map3,			3); //iff tag 3

	firefight_mode_set_objective_name_at(sc_e9_m2_lz1,			11); //ONI terminal 1
	firefight_mode_set_objective_name_at(sc_e9_m2_lz2,			12); //ONI terminal 2
	//firefight_mode_set_objective_name_at(sc_e9_m2_lz3,			13); //ONI terminal 3
	firefight_mode_set_objective_name_at(sc_e9_m2_lz4,			14); //Evac zone

//==== DECLARE AI ====
//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
//set squad group names
//guards
	firefight_mode_set_squad_at(sq_e9_m2_guards1, 1);	//left building
	firefight_mode_set_squad_at(sq_e9_m2_guards2, 2);	//front by the main start area
	firefight_mode_set_squad_at(sq_e9_m2_guards3, 3);	//back middle building
	firefight_mode_set_squad_at(sq_e9_m2_guards4, 4); //in the main start area
	firefight_mode_set_squad_at(sg_e9m2_left_wing, 5); //in the main start area
//	firefight_mode_set_squad_at(sq_e9_m2_guards5, 5); //right side in the back
//	firefight_mode_set_squad_at(sq_e9_m2_guards6, 6); //right side in the back at the back structure
//	firefight_mode_set_squad_at(sq_e9_m2_guards7, 7); //middle building at the front
//	firefight_mode_set_squad_at(sq_e9_m2_guards8, 8); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_hunters, 30);	//back middle building
	firefight_mode_set_squad_at(gr_e9m2_shades, 41);
	firefight_mode_set_squad_at(sq_e9_m2_marines, 42);	//

		
	//forerunner guards
	firefight_mode_set_squad_at(gr_e9m2_foreguards_a, 31); //on the bridge
	firefight_mode_set_squad_at(gr_e9m2_foreguards_b, 32); //on the bridge
	firefight_mode_set_squad_at(gr_e9m2_foreguards_c, 32); //on the bridge
	firefight_mode_set_squad_at(gr_e9m2_foreguards_d, 33); //on the bridge
	firefight_mode_set_squad_at(gr_e9m2_foreguards_e, 34); //on the bridge

//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sg_e9m2_cov_wave_1, 81);
	firefight_mode_set_squad_at(sq_e9_m2_waves2, 82);
	firefight_mode_set_squad_at(sg_e9m2_cov_wave_2, 83);
	firefight_mode_set_squad_at(sq_e9_m2_waves4, 84);	
	firefight_mode_set_squad_at(sg_e9m2_cov_wave_3, 85);		
	
//phantoms
	firefight_mode_set_squad_at( sq_e9m2_phantom_left_wing, 10);
	
	//drop rails
	dm_droppod_1 = dm_e9_m2_rail1;
	dm_droppod_2 = dm_e9_m2_rail2;
	dm_droppod_3 = dm_e9_m2_rail3;
	dm_droppod_4 = dm_e9_m2_rail4;
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );
	
end

//thread out all the start and end event watchers
script static void f_start_all_events_e9_m2
	
//start all the event scripts	
	print ("starting all events");

	//start the intro thread
	thread(f_start_player_intro_e9_m2());
	print ("starting player intro");

	//start the first starting event
	thread (f_start_events_e9_m2_1());
	print ("starting e9_m2_1");

	thread (f_start_events_e9_m2_2());
	print ("starting e9_m2_2");
	
	thread (f_start_events_e9_m2_3());
	print ("starting e9_m2_3");

	thread (f_start_events_e9_m2_4());
	print ("starting e9_m2_4");
	
	thread (f_start_events_e9_m2_5());
	print ("starting e9_m2_5");
	
	thread (f_start_events_e9_m2_6());
	print ("starting e9_m2_6");

	thread (f_start_events_e9_m2_7());
	print ("starting e9_m2_7");
	
//	thread (f_end_events_e9_m2_6());
//	print ("ending e9_m2_6");

	thread (f_start_events_e9_m2_8());
	print ("starting e9_m2_8");
	
	thread (f_start_events_e9_m2_9());
	print ("starting e9_m2_9");
	
	thread (f_end_events_e9_m2_9());
	
	thread(f_going_to_terminal_2());
		
end


//========STARTING E9 M2==============================
// here's where the scripts that control the mission go linearly and chronologically


//===== DODGE HUNTERS, CLEAR THEM OUT
//players spawn and must defeat the hunters, then the switches turn on
script static void f_start_events_e9_m2_1
	sleep_until (LevelEventStatus("start_e9_m2_1"), 1);
	print ("started e9_m2_1");

	b_wait_for_narrative_hud = true;
	
	//sleep until intro is done
	sleep_until( f_spops_mission_start_complete(), 1 );
	thread(f_e9m2_music_start());
	
	//thread out the functions that control the 2 map destruction objectives	
	thread (f_map_watch_e9_m2 (dc_e9_m2_map1, cr_e9_m2_map1, fl_e9_m2_map1, 91));
	thread (f_map_watch_e9_m2 (dc_e9_m2_map2, cr_e9_m2_map2, fl_e9_m2_map2, 92));
	thread (f_e9_m2_towers());
	
	device_set_position(mezz_tower_left, 1);
	device_set_position(mezz_tower_right, 1);
	
	//place replacements for the intro AI
	ai_place (sq_e9_m2_hunters);
	ai_place (sq_e9_m2_intro);
	ai_erase (sq_e9m2_covenant);
	ai_erase (sq_intro);
	
	thread(f_e9m2_kill_marines());
	
	b_no_pod_blips = TRUE;
	
	device_set_position(mezzanine_frontdoor, 1);
	sleep_s (0.5);
	fade_in (0,0,0,15);

	//tell players to kill Hunters, blip hunters (turn this into it's own function)
	sleep_s (2);
	vo_e9m2_clear_area();
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	f_new_objective (ch_9_2_1);
	//cinematic_set_title (ch_9_2_1);

	sleep_s (3);
	
	//f_blip_ai_cui (sq_e9_m2_hunters, "navpoint_healthbar_neutralize");
	sleep_until(ai_living_count (sq_e9_m2_hunters) <= 0, 1);
	b_hunters_are_dead = TRUE;
	sleep_s(1);
	
	//after hunters are dead, turn on the terminals and blip them (turn this into it's own function)
//========= TAKE DOWN THE 1st AND 2nd TERMINAL=========
	
	//Place phantom, wait till guys are dropped off.
	//f_e9_m2_phantom1();
	print("WAITING. . . ");
	sleep_until(ai_living_count(gr_e9m2_ff_all) <= 10);
	sleep_s(1);
	print("DROP POD");
	ai_place_in_limbo(sg_e9m2_re_beg);
	f_dlc_load_drop_pod (dm_e9_m2_rail2, sg_e9m2_re_beg, NONE, drop_pod_lg_01);
	print("WAITING. . . ");
	sleep_until(ai_living_count(gr_e9m2_ff_all) <= 12);
	sleep_s(1);
	ai_place(sq_e9m2_phantom_left_wing);
	
	print("WAITING ON COMPUTER");
	sleep_until(b_92_blip_first_computer == TRUE);
	print("WAITING ON TALKERS");
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	//sleep_s(2);
	thread(vo_e9m2_covie_data());
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	object_create_anew(sc_e9_m2_lz1);
	navpoint_track_object_named(sc_e9_m2_lz1, "navpoint_goto");
	wake(f_move_defend_left);
	
	sleep_until(volume_test_players(t_e9m2_terminal_1), 1);
	
	vo_e9m2_save_it();
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	//thread(vo_e9m2_blow_up());
	sleep_until(b_92_switch_first_terminal == TRUE, 1);
	object_destroy(sc_e9_m2_lz1);

	//turn on the power to the map device 1 control after the VO and HUD are on
	//device_set_power (dc_e9_m2_map1, 1); // <---- Moving to Narrative
	//set new objective and VO
	//f_new_objective (ch_9_2_2);
	//cinematic_set_title (ch_9_2_2);
	wake(f_place_second_wing_ai);
	b_wait_for_narrative_hud = false;	

end

script dormant f_move_defend_left()
	sleep_until(volume_test_players(tv_92_move_fallback));
	sleep_s(3);
	ai_set_objective(sg_e9m2_move, obj_e9_m2_defend_left);
end

script dormant f_place_second_wing_ai()
	sleep_until(ai_living_count(gr_e9m2_ff_all) <= 12);
	sleep_s(1);
	ai_place(sq_e9m2_phantom_right_wing);
end

script static void f_going_to_terminal_2()
	print("triggered going to terminal 2");
	sleep_until(LevelEventStatus("start_e9_m2_1_5"), 1);
	print("start_e9_m2_1_5");
	thread(f_e9m2_music_console_1());
	sleep_s(1);
	//b_force_second_wing = TRUE;
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);	
	thread(vo_e9m2_another_archive_new());
	sleep_s(3);
	f_new_objective(ch_9_2_2_2_2);
	object_create_anew(sc_e9_m2_lz2);
	navpoint_track_object_named(sc_e9_m2_lz2, "navpoint_goto");
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	thread(f_e9m2_music_second_begin());	
	sleep_s(3);
	ai_set_objective(sg_e9m2_move, obj_e9_m2_defend_right);	
	sleep_until(volume_test_players(t_e9m2_terminal_2), 1);
	object_destroy(sc_e9_m2_lz2);
	
	vo_e9m2_blow_up_another();
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	b_end_player_goal = TRUE;
	thread(f_e9m2_music_second_end());
	device_set_power (dc_e9_m2_map2, 2);
end


//NOT USED CURRENTLY
script static void f_start_events_e9_m2_2
	sleep_until (LevelEventStatus("start_e9_m2_2"), 1);
	print ("starting e9_m2_2");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_2);
	//cinematic_set_title (ch_9_2_2);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e9_m2_map1, 1);
	device_set_power (dc_e9_m2_map2, 2);
end


//========= GET TO THE THIRD TERMINAL =========
script static void f_start_events_e9_m2_3
	sleep_until (LevelEventStatus("start_e9_m2_3"), 1);
	print ("starting e9_m2_3");
	thread(f_e9m2_music_console_2());
	b_wait_for_narrative_hud = true;
	thread(f_switch_to_defense(sg_e9m2_cov_wave_1));
	thread(f_switch_to_defense(sg_e9m2_cov_wave_2));
	thread(f_switch_to_defense(sg_e9m2_cov_wave_3));
	thread(vo_e9m2_two_down());
	sleep_s(3);
	b_wait_for_narrative_hud = false;
	//tell players to get to the third terminal
	f_new_objective (ch_9_2_3);
	thread(f_e9m2_music_console_3_arrival());

end


//======= KILL THE REMAINING COVENANT =========
script static void f_start_events_e9_m2_4
	sleep_until (LevelEventStatus("start_e9_m2_4"), 1);
	print ("starting e9_m2_4");

	b_wait_for_narrative_hud = true;
	
	ai_set_objective (sg_e9m2_all_begin, obj_e9_m2_right_wave_defend);
	sleep_until(b_third_is_ready == TRUE, 1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	sleep(15);
	vo_e9m2_third_archive();
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	f_blip_object(dc_e9_m2_map3, "activate");
	
	device_set_power (dc_e9_m2_map3, 1);
	sleep_until (device_get_position (dc_e9_m2_map3) > 0, 1);
	device_set_power (dc_e9_m2_map3, 0);
	
	//tell the players to kill the remaining enemies
	f_new_objective (ch_9_2_4);
	//cinematic_set_title (ch_9_2_4);
	sleep_s(1);
	f_blip_object(dc_e9_m2_map3, "defend");
	sleep_s (2);
	b_wait_for_narrative_hud = false;
	thread(f_e9m2_music_final_covies());

end


//======= KILL THE SURPRISE FORERUNNERS =========
//switch zone sets
script static void f_start_events_e9_m2_5
	sleep_until (LevelEventStatus("start_e9_m2_5"), 1);
	print ("starting e9_m2_5");
	
	//preparing to switch zone set, look for bad popping
	print ("preparing to switch zone set");
	sleep_s(3);
	prepare_to_switch_to_zone_set (e9m2_fore);
	
	//CHANGING THE ZONE SET TO SUPPORT FORERUNNERS
	print ("sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print ("switching zone set");
	switch_zone_set (e9m2_fore);
	current_zone_set_fully_active();
	
	b_end_player_goal = true;

end

//==defeat the forerunners
script static void f_start_events_e9_m2_6
	sleep_until (LevelEventStatus("start_e9_m2_6"), 1);
	print ("starting e9_m2_6");
	thread(f_switch_to_defense(gr_e9m2_foreguards_a));
	thread(f_switch_to_defense(gr_e9m2_foreguards_b));
	thread(f_switch_to_defense(gr_e9m2_foreguards_c));
	thread(f_switch_to_defense(gr_e9m2_foreguards_d));
	thread(f_switch_to_defense(gr_e9m2_foreguards_e));
	thread(f_e9m2_hold_position_1());
	thread(f_e9m2_hold_position_2());
	sleep_until (ai_living_count (ai_ff_all) > 0);
	thread(f_e9m2_music_final_forerunners());

end

script static void f_e9m2_hold_position_1()
	sleep_until (LevelEventStatus("e9m2_hold_position_1"), 1);
	vo_e9m2_hold_position();
end

script static void f_e9m2_hold_position_2()
	sleep_until (LevelEventStatus("e9m2_hold_position_2"), 1);
	vo_e9m2_done_yet();
	sleep_until(ai_living_count(gr_e9m2_ff_all) <= 3, 1);
		if b_e9m2_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
		then vo_glo15_miller_few_more_08();
		end
	f_blip_ai_cui(gr_e9m2_ff_all, "navpoint_enemy");
end

script static void f_e9m2_blip_event
	sleep_until(LevelEventStatus("blip_event_1"), 1);
		sleep_until(ai_living_count(gr_e9m2_ff_all) <= 5, 1);
		if b_e9m2_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
		then vo_glo15_miller_few_more_06();
		end
	f_blip_ai_cui(gr_e9m2_ff_all, "navpoint_enemy");
end

//==blow the last map terminal
script static void f_start_events_e9_m2_7
	sleep_until (LevelEventStatus("start_e9_m2_7"), 1);
	print ("starting e9_m2_7");

	vo_e9m2_all_clear();
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	
	b_wait_for_narrative_hud = true;

	sleep_s (1);
	
	//tell player to blow the last terminal
	f_new_objective (ch_9_2_5);
	//cinematic_set_title (ch_9_2_5);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	
	//turn on the device to switch
	device_set_power (dc_e9_m2_map3, 3);
end

script static void f_escalating_knights()
	ai_place_in_limbo(sq_e9m2_finale_mid_2, 1);
	thread(f_92_knight_co());
	sleep_until(ai_living_count(sg_92_escalation) < 1, 1);
	sleep(15);
	ai_place_in_limbo(sq_e9m2_finale_mid_2a, 2);
	thread(f_finale_timer_1());
	sleep_until(ai_living_count(sg_92_escalation) <= 1 OR s_finale_timer >= 10, 1);
	sleep(15);
	ai_place_in_limbo(sq_e9m2_finale_mid_2b);
	sleep_until(b_e9m2_narrative_is_on == FALSE);
	vo_e9m2_help_me();
	sleep_s(1);
	b_progress_finale = TRUE;
	sleep_until(ai_living_count(sg_92_escalation) < 5, 1);
	sleep(15);
	ai_place_in_limbo(sq_e9m2_finale_mid_2c, 1);	
end

script static void f_92_knight_co
	sleep(30);
	if b_e9m2_narrative_is_on == FALSE
	
		then		
			start_radio_transmission( "miller_transmission_name" );
			
			// Miller : Look out! Knights!
			dprint ("Miller: Look out! Knights!");
			sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_3_00100', NONE, 1);
			sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_3_00100'));
			
			end_radio_transmission();
		end
		
end

script static void f_finale_timer_1
	repeat
		sleep_s(1);
		s_finale_timer = (s_finale_timer + 1);
	until
		(s_finale_timer >= 15);
end

script static void f_finale_timer_2
	repeat
		sleep_s(1);
		s_bring_in_explosions = (s_bring_in_explosions + 1);
	until
		(s_bring_in_explosions >= 15);
end

//==get to the rally point -- BIG EXPLOSIONS
script static void f_start_events_e9_m2_8
	sleep_until (LevelEventStatus("start_e9_m2_8"), 1);
	print ("starting e9_m2_8");
	
	thread(f_escalating_knights());
	
	thread(f_e9m2_music_console_3_accessed());
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	sleep_until(b_progress_finale == TRUE, 1);
	
	b_wait_for_narrative_hud = true;
	
	sleep_until(b_e9m2_narrative_is_on == FALSE);
	thread(vo_e9m2_get_out());
	
	sleep(45);
	object_create(sc_e9_m2_lz4);
	b_wait_for_narrative_hud = false;
	sleep(1);
	f_blip_object_cui(sc_e9_m2_lz4, "navpoint_goto");
	
	//tell players to get OUT of the WAY!!
	//cinematic_set_title (ch_9_2_6);
	
	//sleep for a bit then call the explosions
	thread(f_finale_timer_2());
	sleep_until(volume_test_players(tv_92_finale) OR s_bring_in_explosions >= 10, 1);
	sleep_s (1);

	//explosions
	f_e9_m2_final_explosions();
end

//==end of mission
script static void f_start_events_e9_m2_9
	sleep_until (LevelEventStatus("start_e9_m2_9"), 1);
	print ("starting e9_m2_9");
	thread(f_e9m2_music_stop());
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	b_wait_for_narrative_hud = true;
	
	//tell players "nice work"
	//f_new_objective (ch_9_2_7);
	//cinematic_set_title (ch_9_2_7);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

	b_end_player_goal = true;
end

script static void f_end_events_e9_m2_9
	sleep_until (LevelEventStatus("end_e9_m2_9"), 1);
	print ("end e9_m2_9");
	f_end_mission();
end
	
// ======= END OF MISSION SCRIPTS =========


//====== MISC SCRIPTS =====================

script static void f_end_mission
	print ("ending the mission with fadeout and chapter complete");
  fade_out (0,0,0,60);
	player_control_fade_out_all_input (.5);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

//	sleep_until (object_valid (switch) and object_valid (map), 1);
//	print ("both objects valid in f_power_map_watch_e3_m2");

global short s_map_exploded = 0;

script static void f_map_watch_e9_m2 (device_name switch, object_name map, cutscene_flag flag, short spawn_folder)
	//waits until the switch is flipped then damages the map 1/3 at a time so the players can see the damage states of the map
	print ("map watch thread started");

	object_cannot_take_damage (map);
	
	sleep_until (device_get_position (switch) > 0, 1);
	device_set_power(switch, 0);
	/*print ("map explodes in 6 seconds!");

//create a new spawn folder at the location of the map
	if firefight_mode_goal_get() == 0 then
		f_create_new_spawn_folder (spawn_folder);
	end
	
	//start beeping countdown
	sleep_s (6);

	//call effects
	effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag); 

	object_destroy (map);
	
	s_map_exploded = s_map_exploded + 1;*/
end

//global boolean b_done_with_map_VO = false;
//
//script static void f_e3_m2_objective_vo
//	print ("objective vo started");
//	
//	//sleep until the first objective is done, then play VO
//	sleep_until (s_map_exploded == 1, 1);
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target1down_vo());
//	e3m2_vo_target1down();
//	
//	//sleep until another map is exploded, if the third one is exploded by the time this hits then skip the second one and only play the third one
//	sleep_until (s_map_exploded > 1, 1);
//	
//	if s_map_exploded == 2 then
//		print ("playing second map exploded");
//		sleep_s (1);
//		thread(f_music_e3m2_objective_target2down_vo());
//		e3m2_vo_target2down();
//	end
//	
//	sleep_until (s_map_exploded == 3, 1);
//	
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target3down_vo());
//	e3m2_vo_target3down();
//	b_done_with_map_VO = true;
//
//end

//final explosions are called randomly
script static void f_e9_m2_final_explosions
	print ("final explosions!");
	thread(f_e9m2_music_overwhelm());
	f_unblip_object(sc_e9_m2_lz4);
	ai_place_in_limbo(sq_e9m2_finale_upper);
	sleep(random_range(15, 30));
	b_explosions_started = TRUE;
	
	if ai_living_count(sg_92_escalation) < 3
	then ai_place_in_limbo(sq_e9m2_finale_mid_2d);
			 sleep(random_range(15, 30));
	end

	ai_place_in_limbo(sq_e9m2_finale_mid);
	sleep(random_range(15, 30));
	ai_place_in_limbo(sq_e9m2_finale_front);	
	sleep(random_range(15, 30));
	ai_place_in_limbo(sq_e9m2_finale_front_2);
	sleep(random_range(15, 30));
	ai_place_in_limbo(sq_e9m2_finale_front_3);
	sleep(random_range(15, 30));
	ai_place_in_limbo(sq_e9m2_bw_1);
	//sleep(random_range(15, 30));
	//ai_place_in_limbo(sq_e9m2_finale_top);
	//sleep_until(ai_not_in_limbo_count(sg_e9m2_fore_finale) == 12);
	sleep(random_range(30, 45));
	thread(f_e9m2_music_air_strike());
	thread(f_e9m2_bs1());
	f_e9m2_bomb_front();
	thread(f_e9m2_bs2());
	//sleep(random_range(15, 30));
	f_e9m2_bomb_mid();
	//sleep(random_range(15, 30));
	thread(f_e9m2_bomb_upper());
	sleep_s(3);
	vo_e9m2_so();
	sleep_s(1);
	sleep_until(b_e9m2_narrative_is_on == FALSE, 1);
	sleep_s(1);
	b_end_player_goal = true;
end

script static void f_e9m2_bomb_front
	sleep(20);
	camera_shake_all_coop_players ( 1, 1, 1, 1);
	print("plane 1 overhead");
	sleep(10);
	f_e9_m2_explosion(exp_1_1);
	cs_run_command_script(sq_e9m2_finale_front_3, cs_e9_m2_kill_knights);
	sleep(random_range(15, 30));
	f_e9_m2_explosion(exp_1_2);
	sleep(random_range(15, 30));
	f_e9_m2_explosion(exp_1_3);
	cs_run_command_script(sq_e9m2_bw_1, cs_e9_m2_kill_knights);
	sleep(random_range(15, 30));
	cs_run_command_script(sq_e9m2_finale_front_2, cs_e9_m2_kill_knights);
	//cs_run_command_script(sq_e9m2_finale_front, cs_e9_m2_kill_knights);
	f_e9_m2_explosion(exp_1_4);
	sleep(random_range(15, 30));
	f_e9_m2_explosion(exp_1_5);
	cs_run_command_script(sq_e9m2_finale_front, cs_e9_m2_kill_knights);
end

script static void f_e9m2_bomb_mid
	sleep(20);
	camera_shake_all_coop_players ( 1, 1, 1, 1);
	sleep(10);
	f_e9_m2_explosion(exp_2_1);
	sleep(random_range(7, 15));
	f_e9_m2_explosion(exp_2_4);
	cs_run_command_script(sq_e9m2_finale_mid, cs_e9_m2_kill_knights);
	sleep(random_range(7, 15));
	thread(f_e9m2_bs3());
	f_e9_m2_explosion(exp_2_3);
	sleep(random_range(7, 15));
	f_e9_m2_explosion(exp_2_2);
	cs_run_command_script(sg_92_escalation, cs_e9_m2_kill_knights);
	sleep(random_range(7, 15));
	f_e9_m2_explosion(exp_2_5);
end

script static void f_e9m2_bomb_upper
	sleep(20);
	camera_shake_all_coop_players ( 1, 1, 1, 1);
	sleep(10);
	f_e9_m2_explosion(exp_3_4);
	sleep(random_range(15, 30));
	f_e9_m2_explosion(exp_3_3);
	cs_run_command_script(sq_e9m2_finale_upper, cs_e9_m2_kill_knights);
	sleep(random_range(15, 30));
	f_e9_m2_explosion(exp_3_2);
end

script static void f_e9_m2_explosion (cutscene_flag flag)
	//pause for a random time then call bif explosion FX and Damage
	inspect (flag);
	print ("explosion");
	effect_new(objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	damage_new('objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
	sleep(1);
end

//call in the phantom
script static void f_e9_m2_phantom1
	print ("phantom 1 started");
	ai_place_in_limbo (sq_e9_m2_phantom1);
	
end

//temp raise the device_machines
script static void f_e9_m2_towers
	print ("raising the towers temp script started");
	if device_get_position (mezz_tower_left) == 0 then
		device_set_position_immediate (mezz_tower_left, 1);
		print ("raising left tower");
	end
	
	if device_get_position (mezz_tower_right) == 0 then
		device_set_position_immediate (mezz_tower_right, 1);
		print ("raising left tower");
	end
end

script static void f_e9m2_bs1
	object_create(e9m2_bs_1);
	object_set_scale(e9m2_bs_1, .1, 0);
	sleep(1);
	object_cinematic_visibility(e9m2_bs_1, TRUE);
	object_teleport(e9m2_bs_1, e9m2_flg_bs1);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_engines.effect, e9m2_bs_1, fx_main_engine);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_wings.effect, e9m2_bs_1, fx_boost_engine);
	object_set_scale(e9m2_bs_1, 1, 15);
	//sleep(10);
	object_move_to_point(e9m2_bs_1, 4, ps_e9m2_bs.p0);
	object_set_scale(e9m2_bs_1, .1, 5);
	sleep(5);
	object_destroy(e9m2_bs_1);
end

script static void f_e9m2_bs2
	object_create(e9m2_bs_2);
	object_set_scale(e9m2_bs_2, .1, 0);
	sleep(1);
	object_cinematic_visibility(e9m2_bs_2, TRUE);
	object_teleport(e9m2_bs_2, e9m2_flg_bs2);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_engines.effect, e9m2_bs_2, fx_main_engine);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_wings.effect, e9m2_bs_2, fx_boost_engine);
	object_set_scale(e9m2_bs_2, 1, 15);
	//sleep(10);
	object_move_to_point(e9m2_bs_2, 4, ps_e9m2_bs.p1);
	object_set_scale(e9m2_bs_2, .1, 5);
	sleep(5);
	object_destroy(e9m2_bs_2);
end

script static void f_e9m2_bs3
	object_create(e9m2_bs_3);
	object_set_scale(e9m2_bs_3, .1, 0);
	sleep(1);
	object_cinematic_visibility(e9m2_bs_3, TRUE);
	object_teleport(e9m2_bs_3, e9m2_flg_bs3);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_engines.effect, e9m2_bs_3, fx_main_engine);
	effect_new_on_object_marker(objects\vehicles\human\storm_broadsword\fx\running\boost_wings.effect, e9m2_bs_3, fx_boost_engine);
	object_set_scale(e9m2_bs_3, 1, 15);
	//sleep(10);
	object_move_to_point(e9m2_bs_3, 4, ps_e9m2_bs.p2);
	object_set_scale(e9m2_bs_3, .1, 5);
	sleep(5);
	object_destroy(e9m2_bs_3);
end

// ==============================================================================================================
//====== COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

script command_script cs_e9_m2_hunters
	print ("hunter command script started");
	
	//this will probably need to be a puppeteer
	//shoot at point for 3 seconds, then jump down and fight normal
	//sleep_until( f_spops_mission_start_complete(), 1 );
	//cs_aim (true, ps_e9_m2_hunter.p0);
	//print ("shooting");
	cs_crouch (true);
	
	repeat
		
		sleep (5);
		cs_shoot_point (true, ps_e9_m2_hunter.p0);
		print ("shooting");
		//sleep_s (3);
		
	until (false, 1, 30 * 30);
	
	cs_crouch (false);
	//print ("shooting");
	//cs_approach_player (2, 20, 200);
	//sleep_s (10);
	//cs_approach_stop ();
end

script command_script cs_e9_m2_drop_pod
	print ("drop pod command script started");
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_e9_m2_survival);
end

script static void f_e9m2_kill_marines()
	sleep_until(object_get_recent_shield_damage(e9m2_damage_b_1) > 0 or object_get_recent_shield_damage(e9m2_damage_b_2) > 0, 1);
	print("_________________ damaged shield");
	sleep_s(0.5);
	effect_new(environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, fl_e9_m2_exp_m_1);
	ai_kill(sq_e9_m2_marines.marine1);
	sleep_s(0.5);
	effect_new(environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, fl_e9_m2_exp_m_2);
	effect_new(environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, fl_e9_m2_exp_m_3);
	sleep_s(0.75);
	effect_new(environments\solo\m90_sacrifice\fx\explosion\human_explosion_medium.effect, fl_e9_m2_exp_m_4);
	ai_kill(sq_e9_m2_marines.marine2);
end

script command_script cs_e9_m2_phantom1
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1); //Shrink size
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 60); //Shrink size
	
	object_set_shadowless (ai_current_actor, TRUE);
	cs_enable_targeting (true);
	//ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_e9_m2_phantom1.p0);
//		(print "flew by point 0")
	cs_fly_to (ps_e9_m2_phantom1.p1);
//		(print "flew by point 1")
	sleep (30 * 1);

		// ======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		// ======== DROP DUDES HERE ======================
		
	print ("phantom sleeping");
	sleep_until (device_get_position (dc_e9_m2_map1) == 1 and device_get_position (dc_e9_m2_map2) == 1, 1);
	
	//sleep (30 * 50);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_e9_m2_phantom1.p2);
	cs_fly_to (ps_e9_m2_phantom1.erase);
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end

script command_script cs_e9m2_phantom_left_wing()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	
	//ai_place_in_limbo(sg_e9m2_left_wing);
	f_load_phantom(sq_e9m2_phantom_left_wing, "left", sq_e9m2_left_wing_lead, sq_e9m2_left_wing_front, sq_e9m2_left_wing_mid, NONE);

	cs_fly_to( e8m5_phantom_4_ps.p0 );
	wake(f_phantom_callout_e9m2_1);
	cs_fly_to( e8m5_phantom_4_ps.p1 );
	cs_fly_to_and_face( e8m5_phantom_4_ps.p2, e8m5_phantom_4_ps.p8 );
	cs_fly_to_and_face( e8m5_phantom_4_ps.p3, e8m5_phantom_4_ps.p7 );
	
	f_unload_phantom( sq_e9m2_phantom_left_wing, "left" );
	print("BLIP IS GTG");
	b_92_blip_first_computer = TRUE;

	print ("unload phantom_4");
	
	cs_fly_to( e8m5_phantom_4_ps.p4 );
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	cs_fly_to( e8m5_phantom_4_ps.p5 );
	cs_fly_to( e8m5_phantom_4_ps.p6 );

	ai_erase (sq_e9m2_phantom_left_wing);
	
end

script dormant f_phantom_callout_e9m2_1()
	if b_e9m2_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_miller_contacts_06();
	end
end

script dormant f_phantom_callout_e9m2_2()
	if b_e9m2_narrative_is_on == FALSE AND global_narrative_is_on == FALSE
	then vo_glo15_miller_phantom_01();
	end
end

script command_script cs_e9m2_phantom_right_wing()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	object_cannot_die(unit_get_vehicle(ai_current_actor), TRUE);
	
	if ai_living_count(gr_e9m2_ff_all) + ai_living_count(sq_e9_m2_marines) <= 10 then
	print("DROPPING XTRAS");
	//ai_place_in_limbo(sg_e9m2_right_wing);
	f_load_phantom(sq_e9m2_phantom_right_wing, "right", sq_e9m2_right_wing_lead, sq_e9m2_right_wing_front, sq_e9m2_right_wing_mid, sq_e9m2_right_wing_extras);
	else
	print("DROPPING LESS");
	//ai_place_in_limbo(sg_e9m2_right_wing);
	f_load_phantom(sq_e9m2_phantom_right_wing, "right", sq_e9m2_right_wing_lead, sq_e9m2_right_wing_front, sq_e9m2_right_wing_mid, NONE);
	end

	cs_fly_to( e8m5_phantom_wave_3_ps.p0 );
	wake(f_phantom_callout_e9m2_2);
	cs_fly_to( e8m5_phantom_wave_3_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p2 );
	cs_fly_to_and_face( e8m5_phantom_wave_3_ps.p3, e8m5_phantom_wave_3_ps.p7 );
	
	f_unload_phantom( sq_e9m2_phantom_right_wing, "right" );
	b_blip_second_terminal = TRUE;

	print ("unload phantom_3");
	cs_fly_to( e8m5_phantom_wave_3_ps.p4 );
	object_cannot_die(unit_get_vehicle(ai_current_actor), FALSE);
	cs_fly_to( e8m5_phantom_wave_3_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p6 );

	ai_erase (sq_e9m2_phantom_right_wing);
	
end

script command_script cs_e9_m2_knight_phase
	print ("knight phase in");
//	print_cs();
	sleep (random_range(1, 15));
	cs_phase_in();
end

script command_script cs_e9_m2_wagglebatton_finale
	print ("rawr");
	//ai_cannot_die(ai_current_actor, TRUE);
//	print_cs();
	cs_phase_in_blocking();
	cs_abort_on_damage(TRUE);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
end

script command_script cs_e9_m2_generic_finale
	print ("knight phase in");
	//ai_cannot_die(ai_current_actor, TRUE);
//	print_cs();
	sleep (random_range(1, 30));
	cs_phase_in();
	sleep(60);
	cs_abort_on_damage(TRUE);
	begin_random_count (1)
		cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
		cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:sword_flick", TRUE);
		cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var1", TRUE);
		cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var2", TRUE);
		print("lol, I'm just standing here not giving a fuuuuuuuu-");
		print("lol, I'm just standing here not giving a fuuuuuuuu-");
	end
		
end

script command_script cs_e9_m2_kill_knights
	print ("knight phase in");
	//ai_cannot_die(ai_current_actor, FALSE);
//	print_cs();
	sleep (random_range(1, 14));
	ai_kill(ai_current_actor);
end


script command_script cs_e9_m2_pawn_spawn
	print ("pawns phase in");
	sleep_rand_s (0.1, 0.6);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

//This scripts waits until the AI has taken the defend position from the player and then switches their logic.
script static void f_switch_to_defense(ai ai_squad)
	sleep_until(ai_living_count(ai_squad) > 0);
	sleep_until((volume_test_players(tv_92_mid) == FALSE AND volume_test_objects(tv_92_mid, ai_actors(ai_squad)) == TRUE) OR ai_living_count(ai_squad) <= 0, 1);
	if ai_living_count(ai_squad) > 0 then
		 ai_set_objective(ai_squad, obj_e9_m2_fight_back);
		 print("NOW WE'RE FIGHTING WITH LAZEEERS");
	else
		 print("HOW SAD WE'RE ALL DEAD");
	end
end


// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

global boolean b_e9_m2_wait_for_narrative = false;

script static void f_start_player_intro_e9_m2
	
	sleep_until (f_spops_mission_ready_complete(), 1);
	
	//intro();
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s(4);
		print ("all ai exiting limbo after the puppeteer");
		ai_exit_limbo (gr_e9m2_ff_all);
		ai_exit_limbo (gr_e9m2_marines);
		ai_place(gr_e9m2_shades);
		//f_e9_m2_intro_vignette();
	else
		print ("NOT editor mode play the intro");
		f_e9_m2_intro_vignette();
		print ("all ai exiting limbo after the puppeteer");
		ai_exit_limbo (gr_e9m2_ff_all);
		ai_exit_limbo (gr_e9m2_marines);
		ai_place(gr_e9m2_shades);
	end
		
	//tell engine the intro is complete
	f_spops_mission_intro_complete( TRUE );
	
end

script static void f_e9_m2_intro_vignette
	//set up, play the intro and clean up
	print ("playing intro");
		
	//ai_enter_limbo (gr_e9m2_ff_all);
	//ai_enter_limbo (gr_e9m2_marines);
	pup_disable_splitscreen (true);
	
	//play the puppeteer intro, sleep until it's done	
	local long show = pup_play_show(e9_m2_intro);
	sleep_until (not pup_is_playing(show), 1);
	
	pup_disable_splitscreen (false);
	
end

//tells the script when the narrative is done -- called from within puppeteer
//script static void f_e9_m2_narrative_done
//	print ("narrative done");
//	b_e9_m2_wait_for_narrative = false;
//
//end
