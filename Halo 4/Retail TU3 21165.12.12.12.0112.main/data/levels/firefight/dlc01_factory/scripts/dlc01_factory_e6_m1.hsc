
////===========================================================================================================================
//============================================ FORERUNNER STRUCTURE e6_m1 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================
//startup the mission
global boolean b_e6_m1_Captives_free = FALSE;
global boolean b_e6_m1_Weapons_free = FALSE;
global boolean b_e6_m1_Marines_Pelican = FALSE;
global boolean b_e6_m1_pilot_follow = FALSE;
global boolean b_e6_m1_pilot_pelican = FALSE;
global boolean b_e6_m1_phantom4_dropveh = FALSE;
global boolean b_e6_m1_generator01 = FALSE;
global boolean b_e6_m1_generator02 = FALSE;
global boolean b_e6_m1_pelican_flyaway = FALSE;
global boolean b_e6_m1_stop_firing = FALSE;
global boolean b_all_pawns_spawned  = FALSE;
global boolean b_e6_m1_emp_fired  = FALSE;
global boolean b_e6_m1_fodder_done  = FALSE;
global boolean b_e6_m1_internal_suprise  = FALSE;
global boolean b_e6_m1_phantom_4_started = FALSE;
global boolean b_e6_m1_phantom_7_started = FALSE;
global boolean b_e6_m1_end_chapter = FALSE;
global boolean b_e6_m1_seen_player = FALSE;
global boolean b_e6_m1_end_phantom_1 = FALSE;
global boolean b_e6_m1_end_phantom_2 = FALSE;
global boolean b_e6_m1_end_phantom_3 = FALSE;
global boolean b_e6_m1_end_phantom_4 = FALSE;
global boolean b_e6_m1_end_phantom_5 = FALSE;
global boolean b_phantom_5_unloaded = false;
global boolean b_e6_m1_phantom_5_started = false;
global boolean b_phantom_4_unloaded = FALSE;
global boolean b_phantom_7_unloaded = FALSE;
//global boolean e6m1_narrative_is_on = FALSE;
global boolean b_donut_shield_reminder = true;
global boolean b_donut_shield_reminder_vo = false;
global boolean b_player_in_interior = false;
global boolean b_phantom_5_exit = false;
global boolean b_phantom_5_took_dmg = false;
global boolean b_interior_follow_player = false;
global boolean b_init_ai_blind = TRUE;
global boolean b_prison_player_in_center = FALSE;
global real r_final_seq_stage = 0; // GLOBAL STAGE VAR
global boolean b_marine_dialog_finished = FALSE;
global boolean b_marine_dialog_start = FALSE;
global boolean b_final_player_defend_pilot = FALSE;
global boolean b_e6_m1_phantom_6_started = false;
global boolean b_phantom_6_unloaded = false;
global boolean b_e6m1_blip_outside_interior = false;
global boolean b_e6_m1_prisioner_sheild_down = false;
global boolean b_e6_m1_gravfinished = false;
global boolean b_e6_m1_final_phantom_last_pos = false;
global boolean b_e6_m1_final_doors_open = false;
//global boolean b_e6_m1_stop_firing = false;

global boolean b_marine_1_ready_to_fight = FALSE;
global boolean b_marine_2_ready_to_fight = FALSE;
global boolean b_marine_3_ready_to_fight = FALSE;
global boolean b_marine_4_ready_to_fight = FALSE;

script startup dlc01_factory_e6_m1
	if(f_spops_mission_startup_wait("is_e6_m1") ) then
		wake( dlc01_factory_e6_m1_init );
	end
end

script dormant dlc01_factory_e6_m1_init
	print ("******************E6M1 Dec 1, 2012**********************");
	f_spops_mission_setup("is_e6_m1", e6_m1, gr_e6_m1_ff_alls, sc_e6_m1_spawn_points_0, 90);
	firefight_mode_set_player_spawn_suppressed(TRUE);	//prevents player spawn untill everything else is loaded
	player_enable_input(FALSE);
	fade_out(0, 0, 0, 0);
	ai_ff_all = gr_e6_m1_ff_alls;
	dm_droppod_1 = e6_m1_drop_pod_1;				
	dm_droppod_2 = e6_m1_drop_pod_2;
	dm_droppod_3 = e6_m1_drop_pod_3;
	thread(f_start_player_intro_e6_m1());
	thread(f_start_all_events_e6_m1());
	
//================================================== OBJECTS ===================================================================
//set crate names
	//f_add_crate_folder(sc_e6_m1_doors);										//place the plasma doors, To be replaced with Forerunner stuff
	f_add_crate_folder(dc_e6_m1_switches);
	f_add_crate_folder(we_e6_m1_factory);
	f_add_crate_folder(e6_m1_donut_scenery);
	f_add_crate_folder(cr_e6_m1_ammo);
	f_add_crate_folder(Veh_e6_m1);
	f_add_crate_folder(e6_m1_cov_crates);
	f_add_crate_folder(dm_e6_m1_cover);
	f_add_crate_folder(dm_e6_m1_switches);
//	f_add_crate_folder(dm_e6_m1_doors);																				//tjp
	f_add_crate_folder(dm_doors);																								//tjp
	f_add_crate_folder(sc_e6_m1_lz);
	f_add_crate_folder(eq_e6_m1_factory);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_0, 90);   					//initial player spawns, in donut prison<div style="text-align: justify"></div>
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_1, 91);   					//initial player spawns, in donut diamond area<div style="text-align: justify"></div>
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_2, 92);   					//initial player spawns, in diamond<div style="text-align: justify"></div>
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_3, 93);   					//initial player spawns, in hallway<div style="text-align: justify"></div>
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_4, 94);   					//initial player spawns, internal<div style="text-align: justify"></div>
	firefight_mode_set_crate_folder_at(sc_e6_m1_spawn_points_5, 95);   
//set objective index associations
	firefight_mode_set_objective_name_at(lz_10, 95); //objective escape to the runway
	//firefight_mode_set_objective_name_at(dc_e6_m1_switch1, 97); //objective Lower Fence
	firefight_mode_set_objective_name_at(dc_e6_m1_switch2, 98); //objective escape to runway LZ
	//firefight_mode_set_objective_name_at(lz_14, 99); //objective Runway unaccessable find an Alternate Escape route
	firefight_mode_set_objective_name_at(lz_15, 60); //objective Get to internal Garage and look for an escape route
	firefight_mode_set_objective_name_at(lz_18, 61);
	firefight_mode_set_objective_name_at(dc_e6_m1_switch3, 62); //objective Power magnetic Coupler to capture incoming Phantom to escape
	firefight_mode_set_objective_name_at(dc_e6_m1_switch4, 63); //objective Power magnetic Coupler to capture incoming Phantom to escape
	firefight_mode_set_objective_name_at(dc_e6_m1_switch8, 1); //destrucible Powercore
	//firefight_mode_set_objective_name_at(dc_e6_m1_switch7, 2); //destrucible Powercore	
	firefight_mode_set_objective_name_at(dc_e6_m1_switch5, 97); //touchscreen switch in the front building
	firefight_mode_set_objective_name_at(lz_17, 28); //touchscreen switch in the front building
	firefight_mode_set_objective_name_at(lz_iff_1, 64);
	firefight_mode_set_objective_name_at(lz_iff_2, 65);
	firefight_mode_set_objective_name_at(lz_iff_3, 66);
	firefight_mode_set_objective_name_at(lz_iff_4, 67);
	firefight_mode_set_objective_name_at(lz_iff_5, 68);
//Drop Ships
	firefight_mode_set_squad_at(sq_e6_m1_phantom_4, 23); //phantom 4
	firefight_mode_set_squad_at(sq_e6_m1_phantom_5, 24); //phantom 4
	firefight_mode_set_squad_at(sq_e6_m1_phantom_6, 25); //phantom 4
	firefight_mode_set_squad_at(sq_e6_m1_phantom_7, 27); //phantom 4
//set squad group names
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_1, 71);			// 1st wave Grunts donut
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_2, 72);			// 1st wave Elites donut
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_3, 75);		    // 1st wave elites Diamond
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_4, 74);			//  wave Grunts donut
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_5, 76);			//  wave grunts diamond
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_6, 77);			//  wave elites diamond
	firefight_mode_set_squad_at(sq_e6_m1_bishop_1, 78);			//  bishop
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_8, 79);			//phantom 1 d	firefight_mode_set_squad_at(gr_e6_m1_gaurds_6, 77);			//  wave elites diamond
	//firefight_mode_set_squad_at(gr_e6_m1_gaurds_9, 80);			//old phantom 1 dudes
	firefight_mode_set_squad_at(sq_e6_m1_bishop_2, 81);			//bishop2
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_11, 82);			//phantom 2 dudes
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_12, 83);		//old phantom 2 dudes
	firefight_mode_set_squad_at(sq_e6_m1_factory_13, 84); 			//Interior door Dudes
	firefight_mode_set_squad_at(gr_e6_m1_gaurds_14, 85); 	   		//Grunts interior backup
	firefight_mode_set_squad_at(sq_e6_m1_factory_15, 86); 		//Phantom 3 dudes
	firefight_mode_set_squad_at(gr_e6_m1_factory_16, 87); 		//Phantom 3 dudes
	firefight_mode_set_squad_at(gr_e6_m1_factory_17, 88); 		//Phantom 3 dudes
	firefight_mode_set_squad_at(gr_e6_m1_factory_ghosts1, 89);		//Ghosts
	firefight_mode_set_squad_at(sq_e6_m1_bishop_3, 51);			//interior foreunners
	firefight_mode_set_squad_at(sq_e6_m1_bishop_4, 53);			//interior foreunners
	firefight_mode_set_squad_at(gr_e6_m1_factory_21, 54);			//interior foreunners
	firefight_mode_set_squad_at(gr_e6_m1_factory_22, 55);			//interior foreunners
	firefight_mode_set_squad_at(sq_e6_m1_factory_dp1, 56);			//drop podders
	firefight_mode_set_squad_at(sq_e6_m1_factory_dp2, 40);			//drop podders
	firefight_mode_set_squad_at(sq_e6_m1_factory_dp3, 41);			//drop podders
	firefight_mode_set_squad_at(sq_e6_m1_factory_23, 57); 		//interior hallway backup
	firefight_mode_set_squad_at(sq_e6_m1_factory_24, 58); 		//Phantom 4 dudes
	firefight_mode_set_squad_at(sq_e6_m1_factory_25, 59); 		//Phantom 4 dudes
	firefight_mode_set_squad_at(sq_e6_m1_factory_26, 42); 		//Phantom 4 dudes
	firefight_mode_set_squad_at(sq_e6_m1_factory_27, 43); 		//grunts in donut at the shades in center
	//firefight_mode_set_squad_at(sq_e6_m1_marines_1, 44); 		//marines
	//firefight_mode_set_squad_at(sq_e6_m1_pilot, 45); 		//marines
	firefight_mode_set_squad_at(sq_e6_m1_factory_ghost2, 46); 		//marines
	firefight_mode_set_squad_at(sq_e6_m1_factory_29, 47); 		//marines
	//firefight_mode_set_squad_at(sq_e6_m1_factory_ghost3, 48); 		//marines
	firefight_mode_set_squad_at(sq_e6_m1_factory_30, 49); 		//marines
	firefight_mode_set_squad_at(sq_e6_m1_factory_31, 50); 		//marines

	firefight_mode_set_squad_at(sq_e6_m1_factory_33, 52); 		//marines
	firefight_mode_set_squad_at(sq_e6_m1_factory_inital1, 30); 		//initial elites
	//firefight_mode_set_squad_at(sq_e6_m1_factory_34, 31); 		//initial elites
	
	player_set_profile(e6_m1_after_ics_profile);
	
	f_spops_mission_setup_complete( TRUE );
end
//=========== MAIN SCRIPT STARTS ==================================================================
script static void f_start_all_events_e6_m1
		sleep_until (b_players_are_alive(), 1); 	
		thread(f_core1_door_c_e6_m1_1());		
		thread(f_core_door_c_e6_m1_1());	
		//thread (f_core1_door_b_e6_m1_1());		
		thread(f_end_mission_e6_m1());	
		thread(f_e6_m1_obj3_txt());
		//thread(f_e6_m1_obj4_txt());
		thread(f_e6_m1_obj5_txt());
		thread(f_e6_m1_obj6_txt());
		thread(f_e6_m1_detour_dialog());
		//thread(f_e6_m1_obj7_txt());
		thread(f_e6_m1_obj8_txt());
		thread(f_e6_m1_obj9_txt());
		thread(f_e6_m1_ob10_txt());
		thread(f_e6_m1_obj11_txt());
		thread(f_e6_m1_obj12_txt());
		thread(f_start_events_e6_m1_2());     //ZONE SWITCH
		thread(f_e6m1_dissolve_Switch05 ());     //internal switch activate
		//thread(f_e6_m1_interior_doors ());     //internal switch activate
		thread(f_e6_m1_internal_sw1 ());     //internal switch activate
		thread(f_e6_m1_interior_encounter ());     //internal switch activate	 
		thread(f_e6_m1_shard1 ());     //internal switch activate
		thread(f_e6_m1_shard2 ());     //internal switch activate
		thread(f_e6_m1_shard3 ());     //internal switch activate
		thread(f_e6_m1_door_diamond_c());
		//thread(f_e6_m1_door_donut_a2());
//		thread(f_e6_m1_fodder_bool());
		//thread(f_event_e6_m1_garage_dialog());
		thread(f_e6_m1_obj_captives_released());
		thread(f_e6_m1_prison_enc_control());
		thread(f_monitor_prison_center());
		//thread(f_init_prison_blind());
		thread(f_e6_m1_blip_enemies());
		thread(f_e6_m1_callout_phantom());
		thread(f_event_e6_m1_droppod_vo());
		thread(f_e6_m1_landingpad_phantoms());
		thread(f_init_button_setup());
		
		//thread(f_e6_m1_donut_enc_manager());
		object_create(factory_cov_shield_loop_mid);
		object_create(factory_cov_shield_loop_int);
		//object_destroy(dm_diamond_main_gate);
		object_destroy(dm_wedge_dogleg_door);
end

script static void f_init_button_setup
	sleep_until(object_valid(dm_power_switch), 1);
	object_dissolve_from_marker(dm_power_switch, phase_out, button_marker);
	
	sleep_until(object_valid(dm_power_switch1), 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', dm_power_switch1, 1 );
	object_dissolve_from_marker(dm_power_switch1, phase_out, button_marker);
end
//==============================================================================================================================
//================================================== MISSION START =============================================================
//==============================================================================================================================

script static void f_end_mission_e6_m1
	sleep_until (LevelEventStatus("e6_m1_mission_end"), 1);	
	player_control_fade_out_all_input( 0.1 );
	//fade_out(0, 0, 0, 90); 
	sleep(seconds_to_frames(2.0)); // prevents player from seeing phantom disappear before fade out
	ai_erase(gr_e6_m1_pilot); // erase friendlies just in case...
	ai_erase(gr_e6_m1_marines_left); // erase friendlies just in case...
	ai_erase(gr_e6_m1_marines_right); // erase friendlies just in case...
	ai_erase_all();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end
	
//'=====================INTRO===================================
	
script command_script cs_e6m1_pawn_spawn()
	sleep_rand_s (0.1, 0.8);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script static void f_start_player_intro_e6_m1
	print("INTRO STARTING");
	sleep_until (f_spops_mission_setup_complete(), 1);
	print("SLEEP INTRO DONE");

	thread(f_e6_m1_donut_enc_manager()); // Call Donut Encounter Manager
	
	firefight_mode_set_player_spawn_suppressed(false);
//	sleep(1);
//	NotifyLevel("loadout_screen_complete");
	if editor_mode() then
		sleep_until (b_players_are_alive(), 1);
		/*fade_in (0,0,0,120);
		player_enable_input(true);*/
		f_e6_m1_intro_vignette();
	else
		print("On Console");
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		print("Loadout Complete");
		f_e6_m1_intro_vignette();
	end
	
	sleep (20);
	f_spops_mission_intro_complete( TRUE );
end

//==PUPPETEER SCRIPTS
global object g_ics_player0 = none;
global object g_ics_player1 = none;
global object g_ics_player2 = none;
global object g_ics_player3 = none;

script static void f_e6_m1_intro_vignette
	pup_disable_splitscreen (true);
	g_ics_player0 = player0();
	g_ics_player1 = player1();
	g_ics_player2 = player2();
	g_ics_player3 = player3();

	thread(vo_e6m1_narrative_in());
	//player_set_profile(e6_m1_starting_profile);

	//sleep_s(1);
	fade_in (0,0,0,160);
	print("START Vignette");
	ai_place(sq_e6_m1_factory_inital2);
	thread(f_init_prison_blind());
	sleep_until(ai_living_count(sq_e6_m1_factory_inital2) > 0, 1);
	
	local long show = pup_play_show(e6_m1_intro);
	player_enable_input(true);
	sleep_until (not pup_is_playing(show), 1);
	
	//player_set_profile(e6_m1_after_ics_profile);
	f_new_objective(ch_e6_m1_1); //"Eliminate Guards"
	thread(f_music_e06m1_start());
	print("Vignette DONE!!!!!!!!!!!!!!!!!!!!!");
	thread(f_music_e06m1_narr_in());
	pup_disable_splitscreen (false);
	
	//sound_looping_start (sound\environments\multiplayer\factory\ambience\amb_factory_cov_alarms, NONE, 1);
		
 	sleep(10);
 	sleep_until(e6m1_narrative_is_on == false, 1);
 	vo_e6m1_elite_assassination();
 	sleep(10);
 	ai_place (sq_e6_m1_tracer);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_prison_break();
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 17, 1, 2);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_more_kills();
end

script command_script cs_init_elite_drop
	thread(f_init_elite_drop(ai_current_actor));
end

script static void f_init_elite_drop(ai ai_current_actor)
	sleep_until(unit_get_health(ai_get_unit(ai_current_actor)) <= 0.01, 1);
	object_create(eq_hardshield_1);
end

//======================================OBJECTIVES===================================================
//obj3
script static void f_e6_m1_obj3_txt																	
	sleep_until (LevelEventStatus("e6_m1_donut_locks"), 1);		
	print("OBJECTIVE 2");
	sleep_s(3);
	//vo_e6m1_more_kills();
	sleep_s(5);
	f_new_objective(e6_m1_disable_the_locks);
end

//obj5
script static void f_e6_m1_obj5_txt															 		
	sleep_until (LevelEventStatus("e6_m1_clear_diamond"), 1);		
	b_donut_shield_reminder = false;
	pup_play_show(ppt_e6_m1_donut_shield_gen);
	sleep_s(1);
	device_set_position(dm_power_switch4, 1);
	sleep_until(device_get_position(dm_power_switch4) == 1, 1);
	object_destroy(dm_power_switch4);
	object_destroy(dc_e6_m1_switch8);
	sleep_s(0.5);
	//sound_looping_stop (sound\environments\multiplayer\factory\ambience\amb_factory_cov_alarms);
	
	//*************************************************************
	///turn off donut shield here
//	thread(f_depower_donut_shield(e6_m1_sheild_donut));
	object_destroy(factory_cov_shield_loop_mid);
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\objects\amb_factory_shield_power_down_02', e6_m1_sheild_donut, 1);
	object_set_function_variable(e6_m1_sheild_donut, shield_alpha, 1, 2);
	device_set_position(dm_diamond_main_gate, 1);
	sleep_s(2);
	object_destroy (e6_m1_sheild_donut);
	thread(f_music_e06m1_shield_down());
	
	///turn off donut shield here
	//*************************************************************
		
	b_e6_m1_generator02 = true;
		
	//Start ghosts
	ai_place(sq_e6_m1_factory_ghosts1);
	sleep_s(1);
	//ai_place(sq_e6_m1_factory_3);
	thread(f_e6_m1_ghosts_to_diamond());
	sleep_s(2);
	ObjectOverrideNavMeshCutting(dm_diamond_main_gate, 0);
	device_set_position(dm_e6_m1_cover03, 0);
	device_set_position(dm_e6_m1_cover04, 0);
	
	thread(f_init_cruiser());
	sleep_until(object_valid(e6_m1_sheild_donut) == false and (b_donut_shield_reminder_vo == false), 1);
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_shield_down();
	object_create(lz_13);
	sleep(10);
	navpoint_track_object_named (lz_13, "navpoint_goto");
	sleep_s(1);
	f_new_objective(ch_e6_m1_3);
	
	sleep_until (LevelEventStatus("e6_m1_diamond_phantom")or
		(objects_distance_to_object ((player0), lz_13) <= 15 and objects_distance_to_object ((player0), lz_13) > 0 ) or
		(objects_distance_to_object ((player1), lz_13) <= 15 and objects_distance_to_object ((player1), lz_13) > 0 ) or
		(objects_distance_to_object ((player2), lz_13) <= 15 and objects_distance_to_object ((player2), lz_13) > 0 ) or
		(objects_distance_to_object ((player3), lz_13) <= 15 and objects_distance_to_object ((player3), lz_13) > 0 ), 1);	
	navpoint_track_object (lz_13, false);
end

script static void f_e6_m1_ghosts_to_diamond()
	sleep_until(volume_test_players(player_enter_diamond_vol), 1);
	ai_set_task(sq_e6_m1_factory_ghosts1, ai_diamond_ghosts, diamond);
end

script static void f_event_e6_m1_droppod_vo
	sleep_until(LevelEventStatus("e6_m1_droppod_vo"), 1);		
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	vo_glo_droppod_04();
	e6m1_narrative_is_on = false;
	navpoint_track_object (lz_13, false);
	sleep_until(LevelEventStatus("e6_m1_droppod_vo2"), 1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	vo_glo_incoming_01();
	e6m1_narrative_is_on = false;
end

script static void f_e6_m1_diamond_cleanup
	sleep_until (LevelEventStatus("e6_m1_diamond_cleanup"), 1);		
	sleep_until(e6m1_narrative_is_on == false, 1);
	f_blip_ai_cui (gr_e6_m1_ff_alls, "navpoint_enemy");
	vo_e6m1_clear_covenant();
end

script static void f_e6_m1_detour_dialog				 		
	sleep_until (LevelEventStatus("e6_m1_detour_dialog"), 1);		
	//thread(f_switch_zone_set_e6m1_a());
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_go_there();
	thread(f_music_e06m1_go_there());
	sleep_s(1);
	f_new_objective(ch_e6_m1_4);
	b_end_player_goal = true;
end

//obj5
script static void f_e6_m1_obj6_txt															 		
	sleep_until(LevelEventStatus("e6_m1_new_route"), 1);		
	device_set_power(dc_e6_m1_switch2, 1);
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dc_e6_m1_switch2, 1 );
	object_dissolve_from_marker(dm_power_switch, phase_in, button_marker);
end

//obj7
script static void f_e6_m1_obj8_txt																
	sleep_until (LevelEventStatus("e6_m1_release_captives"), 1);
	sleep_until (ai_living_count (gr_e6_m1_ff_alls) <= 0, 1);
	f_unblip_object_cui(lz_19);
	//thread(f_switch_zone_set_e6m1());
	thread(f_new_objective(e6_m1_release_captives));
end

script static void f_e6_m1_obj_captives_released
	sleep_until (LevelEventStatus("e6_m1_prison_door_lowered"), 1);
	sleep_s(2);
	sleep_until(b_e6_m1_prisioner_sheild_down == true, 1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_shield_disabled();
	thread(f_music_e06m1_first_generator());
	sleep(10);
	thread(f_music_e06m1_free_marines());
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_free_marines();
	//f_new_objective(e6_m1_release_captives);
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_take_off();
end

//obj8
script static void f_e6_m1_obj9_txt																
	sleep_until (LevelEventStatus("e6_m1_pilot"), 1);		
	//vo_e6m1_take_off();
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_fend_off();
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	f_new_objective(e6_m1_pilot);
	f_blip_ai_cui (sq_e6_m1_pilot, "navpoint_defend");
		
	sleep_until (LevelEventStatus("e6_m1_pilot"), 1);		
	f_unblip_object (sq_e6_m1_pilot);
end

//obj9
script static void f_e6_m1_ob10_txt																
	sleep_until (LevelEventStatus("e6_m1_phantom_capture"), 1);		
	sleep_s(3);
	f_new_objective(e6_m1_capture_a_phantom);
	sleep_s(3);
end

//obj9
script static void f_e6_m1_obj11_txt																
	sleep_until (r_final_seq_stage >= 8, 1);
	sleep_until (ai_living_count(gr_e6_m1_ff_alls) == 0, 1);
	thread(f_music_e06m1_take_off());
	sleep_s(2);
	sleep_until(e6m1_narrative_is_on == false, 1);
	sleep_s(1);
	effect_kill_object_marker("levels\firefight\dlc01_factory\fx\emp_drain.effect", ai_vehicle_get(sq_final_phantom_2.phantom), fx_hull_explosion);
	f_unblip_object(sq_e6_m1_pilot);
	sleep_s(2);
	vo_e6m1_ready_take();
	sleep_s(1);
	f_new_objective(ch_e6_m1_7);
end

script static void f_e6_m1_obj12_txt 
	sleep_until (LevelEventStatus("e6_m1_end_mission_vo"), 1);		
	//sleep_s(1);
	sleep_until (e6m1_narrative_is_on == false, 1);		
	vo_e6m1_narr_out();
	sleep_until (e6m1_narrative_is_on == false, 1);		
	f_blip_object_cui(lz_20, "navpoint_goto");
	thread(f_e6m1_faux_gravlift());
	thread(f_music_e06m1_finish());
	sleep_s(1);
	sleep_until(b_e6_m1_gravfinished == true, 1);
	b_end_player_goal = TRUE;
	f_objective_complete();
end
//======================================FLYING STUFF================================================
script command_script cs_e6_m1_pelican
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_to_and_face(e6_m1_pelican_pts.p0,e6_m1_pelican_pts.p1);						//			fly to the following point, then face the next one
	cs_fly_to(e6_m1_pelican_pts.p2);																							//			fly to points
	cs_fly_to(e6_m1_pelican_pts.p3);
	cs_fly_to(e6_m1_pelican_pts.p4);
	if b_e6_m1_pelican_flyaway == true then
		cs_fly_to(e6_m1_pelican_pts.p5);																							//			fly to points
		cs_fly_to(e6_m1_pelican_pts.p6);
		cs_fly_to(e6_m1_pelican_pts.p7);
		cs_fly_to(e6_m1_pelican_pts.p8);
	else
		cs_queue_command_script((ai_current_actor) (cs_e6_m1_pelican));
	end
end

//===================PHANTOM 1================================

script command_script cs_e6_m1_phantom_1()
	print ("PHANTOM 1: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to_and_face (ps_e6_m1_phantom_1.p0, ps_e6_m1_phantom_1.p1);
	cs_fly_to (ps_e6_m1_phantom_1.p2);	
	cs_fly_to (ps_e6_m1_phantom_1.p3);
	cs_fly_to (ps_e6_m1_phantom_1.p4);
	cs_vehicle_speed(0.5);
	cs_fly_to (ps_e6_m1_phantom_1.p5);

	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	sleep_until(b_e6_m1_end_phantom_1 == true) and (ai_living_count (gr_e6_m1_ff_alls) <= 6);
	
	f_unload_phantom (ai_current_actor, "right");
	b_e6_m1_end_phantom_2 = true;
		//======== DROP DUDES HERE ======================
		
	sleep_s(10);	
	cs_fly_to_and_face (ps_e6_m1_phantom_1.p6, ps_e6_m1_phantom_1.p7);
	cs_fly_to (ps_e6_m1_phantom_1.p8);
	cs_fly_to (ps_e6_m1_phantom_1.p9);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

//===================PHANTOM 2================================

script command_script cs_e6_m1_phantom_2()
	print("PHANTOM 2: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to_and_face (ps_e6_m1_phantom_2.p0, ps_e6_m1_phantom_2.p1);
	cs_fly_to (ps_e6_m1_phantom_2.p2);	
	cs_fly_to (ps_e6_m1_phantom_2.p3);
	cs_fly_to (ps_e6_m1_phantom_2.p4);
	cs_vehicle_speed(0.5);
	cs_fly_to (ps_e6_m1_phantom_2.p5);
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
	sleep_until(b_e6_m1_end_phantom_2 == true) and (ai_living_count (gr_e6_m1_ff_alls) <= 4);

	f_unload_phantom (ai_current_actor, "left");
	b_e6_m1_end_phantom_3 = true;
			
		//======== DROP DUDES HERE ======================
		
	sleep_s(10);	
	cs_fly_to_and_face (ps_e6_m1_phantom_2.p6, ps_e6_m1_phantom_2.p7);
	cs_fly_to (ps_e6_m1_phantom_2.p8);
	cs_fly_to (ps_e6_m1_phantom_2.p9);
	
	sleep (30 * 5);

	ai_erase (ai_current_squad);
end

//=========Phantom 4=============

script command_script cs_e6_m1_phantom_4()
	//cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	ai_place(sq_e6_m1_factory_ghost2);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e6_m1_phantom_4.phantom), "phantom_sc", ai_vehicle_get_from_spawn_point(sq_e6_m1_factory_ghost2.sp));
	thread (f_e6_m1_phantom_4_destroyed());
	b_e6_m1_phantom_4_started = true;
	print ("PHANTOM 4 MOVING TO POSITION!");
	cs_fly_to(ps_e6_m1_phantom_4.p0, 2);
	cs_fly_to_and_face(ps_e6_m1_phantom_4.p3, ps_e6_m1_phantom_4.p1);
	cs_vehicle_speed(.5);
//	cs_vehicle_speed_instantaneous(ai_current_actor, .4);
	//notifyLevel("e6_m1_callout_phantom_vo");
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	thread(vo_glo_phantom_09());
	e6m1_narrative_is_on = false;
	cs_fly_to_and_face(ps_e6_m1_phantom_4.p6, ps_e6_m1_phantom_4.p1, 2);
	
	sleep_s(2);
	
	print ("PHANTOM 4 UNLOADING GHOST");
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6_m1_phantom_4.phantom), "phantom_sc" );
	if (ai_living_count (gr_e6_m1_ff_alls) <= 9) then
		f_load_phantom(sq_e6_m1_phantom_4, left, sq_e6_m1_factory_26, none, none, none);
		f_unload_phantom (sq_e6_m1_phantom_4, "left");
	end
	
	cs_fly_to(ps_e6_m1_phantom_4.p10);
	cs_fly_to(ps_e6_m1_phantom_4.p11);
	cs_fly_to(ps_e6_m1_phantom_4.p12);
	cs_fly_to(ps_e6_m1_phantom_4.p13);
	cs_fly_to(ps_e6_m1_phantom_4.p2);
	cs_fly_to_and_face(ps_e6_m1_phantom_4.p17, ps_e6_m1_phantom_4.p18, 2);
	
	sleep_s(2);
	if (ai_living_count (gr_e6_m1_ff_alls) <= 9) then
		f_load_phantom(sq_e6_m1_phantom_4, left, sq_e6_m1_factory_24, none, none, none);
		f_unload_phantom (sq_e6_m1_phantom_4, "left");
	end
	sleep_s(3);
	
	cs_fly_to(ps_e6_m1_phantom_4.p4);
	cs_fly_to(ps_e6_m1_phantom_4.p5, 3);
	
//	cs_fly_to_and_face(ps_e6_m1_phantom_4.p6, ps_e6_m1_phantom_4.p1, 2);
//	sleep(1);
	sleep_until (ai_living_count (gr_e6_m1_ff_alls) <= 9, 1);
	print ("PHANTOM 4 TIME TO UNLOAD in front of shield");
	
	sleep_s(2);
	//cs_fly_to(ps_e6_m1_phantom_4.p10);
	cs_fly_to(ps_e6_m1_phantom_4.p11);
	if b_e6_m1_generator02 == false then
		sleep_until ((ai_living_count (gr_e6_m1_ff_alls) <= 3) or (unit_get_health(ai_current_actor)<= 0.4), 1, 30*30);
		print ("PHANTOM 4 TIME TO UNLOAD left of shield");
		f_load_phantom(sq_e6_m1_phantom_4, right, sq_e6_m1_factory_25, none, none, none);
		f_unload_phantom (sq_e6_m1_phantom_4, "right");
	end
	cs_vehicle_speed(1);
	b_phantom_4_unloaded = TRUE;
	cs_fly_to(ps_e6_m1_phantom_4.p12);
	cs_fly_to(ps_e6_m1_phantom_4.p13);
	cs_fly_to_and_face(ps_e6_m1_phantom_4.p15,ps_e6_m1_phantom_4.p16);
	cs_fly_to(ps_e6_m1_phantom_4.p7);
	cs_fly_to(ps_e6_m1_phantom_4.p8);
	ai_erase(sq_e6_m1_phantom_4);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_4));
end

script static void f_e6_m1_phantom_4_destroyed
	sleep_until (b_e6_m1_phantom_4_started == true);
	sleep_until (ai_living_count (sq_e6_m1_phantom_4) <= 0);
	//b_end_player_goal = TRUE;
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_4));	
	b_phantom_4_unloaded = TRUE;
end

script command_script cs_e6_m1_phantom_6()
	ai_place(sq_e6_m1_factory_ghost3);
	ai_place(sq_e6_m1_factory_ghost4);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e6_m1_phantom_6.phantom), "phantom_sc01", ai_vehicle_get_from_spawn_point(sq_e6_m1_factory_ghost3.sp1));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e6_m1_phantom_6.phantom), "phantom_sc02", ai_vehicle_get_from_spawn_point(sq_e6_m1_factory_ghost4.sp1));
	sleep(2);
	thread(f_e6_m1_phantom_6_destroyed());
	print ("PHANTOM 6 MOVING TO POSITION!");
	b_e6_m1_phantom_6_started = true;
	cs_fly_to(ps_e6_m1_phantom_6.p0);
	thread(f_callout_phantom_5());
	cs_fly_to(ps_e6_m1_phantom_6.p3);
	cs_fly_to(ps_e6_m1_phantom_6.p4);
	cs_vehicle_speed(.5);
	cs_fly_to_and_face(ps_e6_m1_phantom_6.p5, ps_e6_m1_phantom_6.p12);
	print ("PHANTOM 6 TIME TO UNLOAD!!!!!!");
	sleep_s(2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6_m1_phantom_6.phantom), "phantom_sc02" );
	cs_fly_to_and_face (ps_e6_m1_phantom_6.p11, ps_e6_m1_phantom_6.p14);
	sleep_s(2);
	f_unload_phantom (ai_current_actor, "dual");
	sleep_s(2);
	cs_fly_to_and_face(ps_e6_m1_phantom_6.p6, ps_e6_m1_phantom_6.p14);
	sleep_s(2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e6_m1_phantom_6.phantom), "phantom_sc01" );
  b_phantom_6_unloaded = TRUE;
	sleep_s(3);
	cs_vehicle_speed(1);
	cs_fly_to_and_face(ps_e6_m1_phantom_6.p7, ps_e6_m1_phantom_6.p8);
	cs_fly_to(ps_e6_m1_phantom_6.p8);
	cs_fly_to(ps_e6_m1_phantom_6.p9);
	cs_fly_to(ps_e6_m1_phantom_6.p10);
	ai_erase(sq_e6_m1_phantom_6);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_6));
end	

script static void f_callout_phantom_5()
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	vo_glo15_dalton_phantom_02();
	e6m1_narrative_is_on = false;
end

script static void f_e6_m1_phantom_6_destroyed
	sleep_until (b_e6_m1_phantom_6_started == true);
	sleep_until (ai_living_count (sq_e6_m1_phantom_6) <= 0);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_6));	
	b_phantom_6_unloaded = TRUE;
end

script command_script cs_e6_m1_phantom_7()
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	b_e6_m1_phantom_7_started = true;
	sleep(2);
	thread(f_e6_m1_phantom_7_destroyed());
	print ("PHANTOM 7 MOVING TO POSITION!");
	cs_fly_to(ps_e6_m1_phantom_7.p1);
	cs_fly_to(ps_e6_m1_phantom_7.p7);
	cs_vehicle_speed (0.5);	
	notifyLevel("e6_m1_callout_phantom_vo");
	cs_fly_to_and_face(ps_e6_m1_phantom_7.p2, ps_e6_m1_phantom_7.p9, 2);
	f_load_phantom(sq_e6_m1_phantom_7, left, sq_e6_m1_factory_4, none, none, none);
	sleep_s(1);
	f_unload_phantom (sq_e6_m1_phantom_7, "left");
	sleep_s(1);
		
	cs_fly_to(ps_e6_m1_phantom_7.p3);
	f_load_phantom(sq_e6_m1_phantom_7, left, sq_e6_m1_factory_34, none, none, none);
	cs_fly_to(ps_e6_m1_phantom_7.p4);
	sleep_s(1);
	f_unload_phantom(sq_e6_m1_phantom_7, "left");
	b_phantom_7_unloaded = TRUE;
	sleep_s(1);
	cs_vehicle_speed (1);
	cs_fly_to(ps_e6_m1_phantom_7.p5);
	cs_fly_to(ps_e6_m1_phantom_7.p6);
	cs_fly_to(ps_e6_m1_phantom_7.p7);
	cs_fly_to(ps_e6_m1_phantom_7.p8);
	sleep(30);
	ai_erase(sq_e6_m1_phantom_7);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_7));
end	

script static void f_e6_m1_phantom_7_destroyed
	sleep_until (b_e6_m1_phantom_7_started == true);
	sleep_until (ai_living_count (sq_e6_m1_phantom_7) <= 0);
	b_phantom_7_unloaded = TRUE;
	//b_end_player_goal = TRUE;
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_7));	
end

//===================PHANTOM 8================================

script command_script cs_e6_m1_phantom_8a()
	print ("PHANTOM 1: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to (ps_e6_m1_phantom_8.p1);	
	cs_fly_to (ps_e6_m1_phantom_8.p4);
	cs_fly_to (ps_e6_m1_phantom_8.p5);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end
		
script command_script cs_e6_m1_phantom_8b()
	print ("PHANTOM 1: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to (ps_e6_m1_phantom_8.p0);	
	cs_fly_to (ps_e6_m1_phantom_8.p2);
	cs_fly_to (ps_e6_m1_phantom_8.p3);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

script command_script cs_e6_m1_phantom_8c()
	print ("PHANTOM 1: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to (ps_e6_m1_phantom_8.p6);	
	cs_fly_to (ps_e6_m1_phantom_8.p8);
	cs_fly_to (ps_e6_m1_phantom_8.p10);
	cs_fly_to (ps_e6_m1_phantom_8.p12);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end

script command_script cs_e6_m1_phantom_8d()
	print ("PHANTOM 1: init");
	cs_ignore_obstacles (TRUE);
	thread(f_monitor_phantom_health(ai_current_actor));
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_to (ps_e6_m1_phantom_8.p7);	
	cs_fly_to (ps_e6_m1_phantom_8.p9);
	cs_fly_to (ps_e6_m1_phantom_8.p11);
	cs_fly_to (ps_e6_m1_phantom_8.p12);
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end
//=========================OTHER STUFF=======================================

script static void f_e6_m1_landingpad_phantoms
	sleep_until(volume_test_players (player_on_landing_pad) == true, 1);
	ai_place (sq_e6_m1_phantom_8.phantom3);
	ai_place (sq_e6_m1_phantom_8.phantom4);
end

script static void f_e6_m1_internal_sw1
	sleep_until (LevelEventStatus("e6_m1_internal_sw1"), 1);
	device_set_power("dc_e6_m1_switch5", 1);
	object_dissolve_from_marker(dm_power_switch1, phase_in, button_marker);
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dc_e6_m1_switch5, 1);
end


script static void f_init_cruiser
	print( "===============CRUSIER TIME================");
		object_create (e6_m1_cruiser);
		object_cinematic_collision(e6_m1_cruiser,false);
		sleep(5);
	
		object_set_scale ( e6_m1_cruiser, .6, 1000 ); //increase size over time
		sleep_s (3);
		
		object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p0); 

		object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p1);   // Open hallway to donut Door
		object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p2);   // Open hallway to donut Door
		repeat
			object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p3); 
			//sleep(6);
			object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p4);   // Open hallway to donut Door
			//sleep(6);
			object_move_to_point (e6_m1_cruiser, 3, ps_e6_m1_cruiser_pts.p2);
			//sleep(6);
		until (b_phantom_5_exit == true, 1);
	print ("===============CRUSIER FINISHED================");
end

//script static void f_depower_donut_shield(object sc_energy_shield)
//	object_destroy(factory_cov_shield_loop_mid);
//	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\amb_factory_shield_power_down_02', sc_energy_shield, 1);
//	object_set_scale ( sc_energy_shield, .001, 3 ); 
//	sleep_s(2);
//	object_destroy (sc_energy_shield);
//end

script static void f_core1_door_c_e6_m1_1	
	sleep_until (LevelEventStatus("e6_m1_core1_done"), 1);
	print("OBJECTIVE 2: Power up switches");
	sleep_s(2);
	device_set_power(dc_e6_m1_switch8, 1);

	repeat
		sleep_s(90);
		if (b_donut_shield_reminder == true) then
			b_donut_shield_reminder_vo = true;
			sleep_until(e6m1_narrative_is_on == false, 1);
			vo_e6m1_first_generator();
			sleep_s(1);
			sleep_until(e6m1_narrative_is_on == false, 1);
			
			b_donut_shield_reminder_vo = false;
		end
	until (b_donut_shield_reminder == false, 1);
end	
	
script static void f_core_door_c_e6_m1_1	
	sleep_until(LevelEventStatus("e6_m1_core_done"), 1);
	//object_move_to_point(e6_m1_door_donut_a, 3, ps_e6_m1_doorpoints.e6_m1_doorpoint_donut_a); 
end	
	
script static void f_e6_m1_door_diamond_c
	sleep_until(LevelEventStatus("e6_m1_door_diamond_c"), 1);
	device_set_position(dm_diamond_closet_door, 1 );
	sound_impulse_start_marker('sound\environments\multiplayer\factory\dm\spops_factory_dm_center_door_large_open_mnde10277', dm_diamond_closet_door, audio_center, 1 ); //AUDIO!
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_shield_drop_02();
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_pelican_retreat();
end	

script static void f_start_events_e6_m1_2
	sleep_until (LevelEventStatus("e6_m1_exit_diamond"), 1);
	thread(f_monitor_player_interior());
	object_destroy(dc_e6_m1_switch2);
	
	local long door_to_int_show = pup_play_show(ppt_e6_m1_door_to_interior);
	sleep_until(not pup_is_playing(door_to_int_show), 1);
	
	device_set_position(dm_power_switch, 1);
	sleep_until(device_get_position(dm_power_switch) == 1, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_power_switch, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_power_switch, phase_out, button_marker);

	sleep_s(3.5);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\factory\dm\spops_factory_dm_center_door_large_open_mnde10277', dm_diamond_dogleg_door, audio_center, 1 ); //AUDIO!
	device_set_position(dm_diamond_dogleg_door, 1);
	
	object_destroy(dm_power_switch);
	print("blipping first location");
	object_create(lz_15);
	object_create(lz_18);
	sleep(5);
	f_e6_m1_waypoint_breadcrumbs(10, lz_15);
	print("bliping second location");
	f_e6_m1_waypoint_breadcrumbs(10, lz_18);
	f_e6_m1_waypoint_breadcrumbs(10, lz_17);
	sleep_until(b_phantom_5_exit == true, 1);
	print("phantom 5 exited");
end

script static void f_monitor_player_interior()
	ai_place(sq_e6_m1_factory_23);
	sleep_s(1);
	ai_place(sq_e6_m1_factory_12);
	ai_place(sq_e6_m1_factory_13);
	ai_place(sq_e6_m1_factory_14);
	
	ai_place(sq_e6_m1_phantom_5);

	sleep_until(volume_test_players (tv_player_enter_interior_entrance) == true, 1);
	thread(f_music_e06m1_phantom_resistance());
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_phantom_resistance(); // Roland : Hey… I think maybe the Covenant are using this place as a prison center.
	
	sleep_until(volume_test_players (tv_player_enter_interior) == true, 1);

	sleep_until(e6m1_narrative_is_on == false, 1);
	
	b_player_in_interior = true; //move on phantom
	vo_e6m1_phantom_resistance_01(); // Dalton : Miller, Phantoms in the sky near Crimson's position.
	print(" resistance vo played");
	sleep_until((ai_living_count(gr_e6_m1_ff_alls) <= 3) or (b_phantom_5_took_dmg == true) or (volume_test_players(tv_player_on_landing_platform) == true), 1);
	print(" all boxes checked");
	b_phantom_5_exit = true;
	print(" phantom_5_exit_true");
	navpoint_track_object (lz_17, false);
	print("stop tracking 17");
	f_unblip_object_cui (lz_17);
	print("unblipped 17");
	//thread(f_blip_iff_tags());
	sleep_s(1);
	b_interior_follow_player = true;
	sleep_until(e6m1_narrative_is_on == false, 1);
	ai_place(sq_e6_m1_phantom_8.phantom1);
	ai_place(sq_e6_m1_phantom_8.phantom2);
	vo_e6m1_phantom_resistance_02(); // Roland : Oh! Hey! Icebreaker Squad's IFF tags just popped up.
	sleep(10);
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 3, 1);
	f_new_objective(ch_e6_m1_5); // Investigate the IFF Tags
	b_end_player_goal = TRUE;
end

script static void f_blip_iff_tags
	object_create(lz_iff_1);
	object_create(lz_iff_2);
	object_create(lz_iff_3);
	object_create(lz_iff_4);
	object_create(lz_iff_5);
	sleep(5);
	f_blip_object_cui (lz_iff_1, "navpoint_goto");
	sleep(15);
	f_blip_object_cui (lz_iff_2, "navpoint_goto");
	sleep(15);
	f_blip_object_cui (lz_iff_3, "navpoint_goto");
	sleep(15);
	f_blip_object_cui (lz_iff_4, "navpoint_goto");
	sleep(15);
	f_blip_object_cui (lz_iff_5, "navpoint_goto");
end
script static void f_unblip_iff_tags
	f_unblip_object_cui (lz_iff_1);
	f_unblip_object_cui (lz_iff_2);
	f_unblip_object_cui (lz_iff_3);
	f_unblip_object_cui (lz_iff_4);
	f_unblip_object_cui (lz_iff_5);
end

script command_script cs_e6_m1_phantom_5()
	print("PHANTOM 5: init");
	thread(f_monitor_phantom_health(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	b_e6_m1_phantom_5_started = true;
	sleep(2);
	thread(f_e6_m1_phantom_5_destroyed());
	cs_fly_to (ps_e6_m1_phantom_5.p3);
	cs_fly_to (ps_e6_m1_phantom_5.p4);
	cs_fly_to (ps_e6_m1_phantom_5.p5);
	sleep_until (b_player_in_interior == true, 1);
	b_e6_m1_end_phantom_1 = true;
	sleep_s(5);
	sleep_until((b_phantom_5_exit == true) or unit_get_health(unit_get_vehicle(ai_current_actor)) <= 0.5, 1);
	b_phantom_5_took_dmg = true;
	cs_fly_to (ps_e6_m1_phantom_5.p6);
	cs_fly_to (ps_e6_m1_phantom_5.p7);
	object_set_scale (ai_vehicle_get ( ai_current_actor ), .1, 90 ); //decrease size over time
	cs_fly_to (ps_e6_m1_phantom_5.p0);

	sleep (30 * 1);
	ai_erase(sq_e6_m1_phantom_5);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_5));
end

script static void f_e6_m1_phantom_5_destroyed
	sleep_until (b_e6_m1_phantom_5_started == true);
	sleep_until (ai_living_count (sq_e6_m1_phantom_5) <= 0);
	object_destroy(unit_get_vehicle (sq_e6_m1_phantom_5));	
	b_phantom_5_unloaded = true;
	b_e6_m1_end_phantom_1 = true;
	b_phantom_5_exit = true;
end

script static void f_e6m1_dissolve_Switch05()
	sleep_until (LevelEventStatus("start_e6_m1_interior_encounter"), 1);
	//sleep_until(device_get_position(dc_e6_m1_switch5) == 1, 1);
	//notifyLevel("start_e6_m1_interior_encounter"); // HACK REMOVE ONCE DONE
	
	local long interior_door2_show = pup_play_show(ppt_e6_m1_interior_door);
	device_set_power(dc_e6_m1_switch5, 0);
	sleep_until(not pup_is_playing(interior_door2_show), 1);
	
	device_set_position(dm_power_switch1, 1);
	sleep_until(device_get_position(dm_power_switch1) == 1, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dc_e6_m1_switch5, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_power_switch1, phase_out, button_marker);
	sleep_s(3.5);
	device_set_position(dm_wedge_center_door, 1);

	object_destroy(dm_power_switch1);
	sleep_s(1);
	ObjectOverrideNavMeshCutting(dm_wedge_center_door, 0);

	f_blip_object_cui(lz_19, "navpoint_goto");
	object_destroy(dc_e6_m1_switch5);
end

script static void f_e6_m1_shard1
	sleep_until (LevelEventStatus("e6_m1_shard1"), 1);
	print("SHARD !");
	sleep_s(2);
	ai_place_in_limbo(sq_e6_m1_factory_7);  
	sleep_s(5);
	ai_place_in_limbo(sq_e6_m1_factory_10);  
end

script static void f_e6_m1_shard2
	sleep_until (LevelEventStatus("e6_m1_shard2"), 1);
	print("SHARD !");
	sleep_s(3);
	ai_place_in_limbo(sq_e6_m1_factory_18);  
end

script static void f_e6_m1_shard3
	sleep_until (LevelEventStatus("e6_m1_shard3"), 1);
	print("SHARD !");
	sleep_s(3);
	ai_place_in_limbo(sq_e6_m1_factory_20);  
	b_all_pawns_spawned = true;  
end

script static void f_e6_m1_interior_encounter
	sleep_until(LevelEventStatus("start_e6_m1_interior_encounter"), 1);
	ai_place(sq_e6_m1_bishop_1);
	ai_place(sq_e6_m1_bishop_2);
	ai_place(sq_e6_m1_bishop_3);
	ai_place(sq_e6_m1_bishop_4);
	thread(f_enter_interior_prison_vo());
	sleep_until((ai_living_count (gr_e6_m1_ff_alls) <= 3) and (ai_living_count(gr_e6_m1_bishops) == 0), 1);
	sleep_until((ai_living_count (gr_e6_m1_ff_alls) == 0) and (b_marine_dialog_finished == TRUE), 1);
	sleep_s(2);
	sleep_until(e6m1_narrative_is_on == false, 1);
	thread(vo_e6m1_phantom_resistance_03b());
	sleep_s(1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	device_set_power(dc_e6_m1_switch4, 1);
	//b_end_player_goal = TRUE;  // moving ot narrative
end

script static void f_enter_interior_prison_vo()
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	vo_glo_heavyforces_03();
	e6m1_narrative_is_on = false;
	sleep_until (ai_living_count (gr_e6_m1_bishops) <= 3, 1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	vo_glo15_miller_crawlers_01();
	e6m1_narrative_is_on = false;
end

script command_script cs_interior_elite_lb
	thread (f_interior_elite_lb(ai_current_actor));
end
script static void f_interior_elite_lb(ai ai_current_actor)
	sleep_until(unit_get_health(ai_get_unit(ai_current_actor)) <= 0.1, 1);
	print("Elite LB Dead");
	if (ai_living_count(gr_e6_m1_ff_alls) <= 10) then
		ai_place(sq_e6_m1_factory_7);  
	end
	ai_kill (ai_current_actor);
end
script command_script cs_interior_elite_lf
	thread (f_interior_elite_lf(ai_current_actor));
end
script static void f_interior_elite_lf(ai ai_current_actor)
	sleep_until(unit_get_health(ai_get_unit(ai_current_actor)) <= 0.1, 1);
	print("Elite LF Dead");
	if (ai_living_count(gr_e6_m1_ff_alls) <= 10) then
		ai_place(sq_e6_m1_factory_10);
	end
	ai_kill (ai_current_actor);
end
script command_script cs_interior_elite_rb
	thread (f_interior_elite_rb(ai_current_actor));
end
script static void f_interior_elite_rb(ai ai_current_actor)
	sleep_until(unit_get_health(ai_get_unit(ai_current_actor)) <= 0.1, 1);
	print("Elite RB Dead");
	if (ai_living_count(gr_e6_m1_ff_alls) <= 10) then
		ai_place(sq_e6_m1_factory_18);
	end
	ai_kill (ai_current_actor);
end
script command_script cs_interior_elite_rf
	thread (f_interior_elite_rf(ai_current_actor));
end
script static void f_interior_elite_rf(ai ai_current_actor)
	sleep_until(unit_get_health(ai_get_unit(ai_current_actor)) <= 0.1, 1);
	print("Elite RF Dead");
	if (ai_living_count(gr_e6_m1_ff_alls) <= 10) then
		ai_place(sq_e6_m1_factory_20);
	end
	ai_kill (ai_current_actor);
end

//script static void f_e6_m1_fodder_bool
//	sleep_until (LevelEventStatus("e6_m1_fodder_bool"), 1);
//	sleep_until (ai_living_count (sq_e6_m1_factory_3) <= 3);
//	b_e6_m1_fodder_done = true;
//end

script command_script f_callout_droppod
	print("CALL OUT DROP POD");
end

//================== Enc Triggers: Donut ================//

script static void f_init_prison_blind
	//print("Testing for player volume");
	sleep_until(ai_living_count(sq_e6_m1_factory_inital2) > 0, 1);
	sleep_until(volume_test_players_all(tv_out_of_initial_area) or ai_living_count(sq_e6_m1_factory_inital2) == 0, 1);
	b_init_ai_blind = FALSE;
	sleep(30);
	player_set_profile(e6_m1_starting_profile);
	device_set_position(dm_e6_m1_cover01, 1);
	device_set_position(dm_e6_m1_cover02, 1);
	device_set_position(dm_e6_m1_cover03, 1);
	device_set_position(dm_e6_m1_cover04, 1);
	ai_set_task(gr_e6_m1_gaurds_1, obj_e6_m1_donut_1, guard_bridge);
	ai_set_task(gr_e6_m1_gaurds_2, obj_e6_m1_donut_1, guard_center);
	ai_set_task(sq_e6_m1_factory_27, obj_e6_m1_donut_1, guard_center);
	ai_set_task(sq_e6_m1_factory_31, obj_e6_m1_donut_1, guard_bridge);
end

script static void f_monitor_prison_center
	sleep_until (volume_test_players(tv_prison_center) == true, 1);
	repeat
		if (volume_test_players(tv_prison_center)) then
			b_prison_player_in_center = TRUE;
		else
			b_prison_player_in_center = FALSE;
		end
	until (LevelEventStatus("e6_m1_clear_diamond"), 5); // end of donut encounters
end

//================== Enc Control: Donut ================//
script static void f_e6_m1_donut_enc_manager		
	//sleep_until (LevelEventStatus("e6_m1_donut_locks"), 1);
	ai_place(sq_e6_m1_factory_inital1);
	ai_place(gr_e6_m1_gaurds_1);
	ai_place(gr_e6_m1_gaurds_2);  //guard center
	ai_place(sq_e6_m1_factory_27); //guard center
	ai_place(sq_e6_m1_factory_31); //guard bridge
	
	sleep_until(ai_living_count(gr_e6_m1_ff_alls)<= 9 , 1);
	print("Donut Enc Man: Spawn Phantom 4");
	ai_place(sq_e6_m1_phantom_4);
	
	sleep_until((b_phantom_4_unloaded == TRUE) and (ai_living_count(gr_e6_m1_ff_alls) <= 9) , 1);
	print("Donut Enc Man: Spawn Phantom 7");
	ai_place(sq_e6_m1_phantom_7);
	sleep_until(b_phantom_7_unloaded == TRUE, 1);
	print("Donut Enc Man: Phantom 7 Unloaded");
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 5 , 1);
	notifyLevel("e6_m1_blip_enemy_vo");
	
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) == 0 , 1);
	print("Donut Enc Man: Objective Cleared");

	sleep_s(1);
	thread(f_music_e06m1_have_a_plan());
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_evac_zone();
	sleep_s(1);
	f_new_objective(ch_e6_m1_2);
	b_end_player_goal = TRUE;
end


//===== Enc Triggers: Final =====//
script static void f_trigger_marine_stage_1
	sleep_until ((volume_test_players(tv_enter_marine_stage_1) == true) or (ai_living_count(gr_e6_m1_ff_alls) == 0), 1);
	sleep_s(2);
	r_final_seq_stage = 1;
	sleep_until(e6m1_narrative_is_on == false, 1);
	vo_e6m1_phantom_resistance_03();
	sleep(10);
	sleep_until(e6m1_narrative_is_on == false, 1);
	if (ai_living_count(gr_e6_m1_bishops) > 0) then
		e6m1_narrative_is_on = true;
		vo_glo15_miller_few_more_01();
		f_new_objective(e9_m5_defeat_attackers); //Eliminate hostiles
		e6m1_narrative_is_on = false;
	elseif (ai_living_count(gr_e6_m1_ff_alls) > 5) then
		e6m1_narrative_is_on = true;
		vo_glo15_miller_few_more_08();
		e6m1_narrative_is_on = false;
	elseif (ai_living_count(gr_e6_m1_ff_alls) > 0) then
		notifyLevel("e6_m1_blip_enemy_vo");
			print("+++++++MARINE_STAGE++++");
		sleep_until(e6m1_narrative_is_on == false, 1);
	end
	b_marine_dialog_finished = TRUE;
end

script static void f_monitor_pilot_hacking_zone
	sleep_until (volume_test_players(player_enter_pilot_vol) == true, 1);
	repeat
		if (volume_test_players(player_enter_pilot_vol)) then
			b_final_player_defend_pilot = TRUE;
		else
			b_final_player_defend_pilot = FALSE;
		end
	until (r_final_seq_stage == 8, 5); // end of donut encounters
end

//===== Encounter Control: Final =====//
script static void f_e6_m1_prison_enc_control
	sleep_until(device_get_position(dm_power_switch1) == 1, 1);
	object_create(sc_e6_m1_internal_prisoner_dr);
	print("A: Enc Control spawns marines");
	ai_place(gr_e6_m1_marines_left);
	ai_place(gr_e6_m1_marines_right);
	ai_place(gr_e6_m1_pilot);
	thread(f_trigger_marine_stage_1());
	sleep_until (LevelEventStatus("e6_m1_prison_door_lowered"), 1);
	
	pup_play_show(ppt_e6_m1_marine_shield);
	sleep_s(1);
	device_set_position( dm_power_switch0, 1);
	sleep_until(device_get_position(dm_power_switch0) == 1, 1);
	object_destroy(dm_power_switch0);
	object_destroy(dc_e6_m1_switch4);
	
	object_destroy(factory_cov_shield_loop_int);
	//f_depower_donut_shield(sc_e6_m1_internal_prisoner_dr);
	
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\objects\amb_factory_shield_power_down_02', sc_e6_m1_internal_prisoner_dr, 1);
	object_set_function_variable(sc_e6_m1_internal_prisoner_dr, shield_alpha, 1, 2);
	sleep_s(2);
	object_destroy (sc_e6_m1_internal_prisoner_dr);
	
	b_e6_m1_prisioner_sheild_down = true;
	
	b_e6_m1_pilot_follow = TRUE;	
	b_e6_m1_Captives_free = TRUE;
	r_final_seq_stage = 2;
	ai_place(sq_final_phantom_1);
	ai_place(sq_final_phantom_2);
	
	sleep_s(5);
	r_final_seq_stage = 3;
	
	print("B: Enc Control spawns phantoms");
	// 10 guys, sq1_left: [2elite, 3 jck], sq2_right: [4 jck, 1 elite captain - swd]
	navpoint_track_object (lz_16, false);
	object_destroy(lz_16);
	b_e6m1_blip_outside_interior = false;
	thread(f_monitor_pilot_hacking_zone());
	device_set_power(dm_hangar_door_1, 1.0);
	device_set_power(dm_hangar_door_2, 1.0);
	sleep(1);
	device_set_position( dm_hangar_door_1, 1);
	device_set_position( dm_hangar_door_2, 1);
	sleep_s(1);
	b_e6_m1_final_doors_open = true;
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true;
	thread(vo_glo_watchout_08());
	e6m1_narrative_is_on = false;
	sleep_s(1);
	thread(f_e6m1_marines_to_phantom());
	ObjectOverrideNavMeshCutting(dm_hangar_door_1, 0);
	ObjectOverrideNavMeshCutting(dm_hangar_door_2, 0);
	
	sleep_until(ai_living_count(gr_e6_m1_final_elites) <= 0, 1);
	
	r_final_seq_stage = 4;
	// can support more guys
	sleep_s(2);
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 4, 1);
	
	print("D1: Enc Ctrl - Phantoms2 moves to center");
	r_final_seq_stage = 5;
	
	sleep_s(5);
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 2, 1);
	
	print("D2: Enc Ctrl - Phantom1 leaves");
	r_final_seq_stage = 6;
	sleep_s(2);
	sleep_until(ai_living_count(gr_e6_m1_ff_alls) <= 0, 1);
	
	print("E: Enc Ctrl - Phantom hijacked");
	r_final_seq_stage = 7;

	print("OBJECTIVE COMPLETE: GO TO PHANTOM");
	f_unblip_object(sq_e6_m1_pilot);
	f_unblip_object(sq_e6_m1_marines_left);
	f_unblip_object(sq_e6_m1_marines_right);
	print("+++++++MONIOR COUNT++++");
	sleep_until(r_final_seq_stage == 8, 1);
	thread(f_prison_monitor_ai_count());
	sleep_until(r_final_seq_stage == 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1);
	b_end_player_goal = TRUE;
end

script static void f_prison_monitor_ai_count
	sleep_s(7);
	sleep_until(ai_living_count(gr_e6_m1_ff_alls)<= 5, 1);
	sleep_until(e6m1_narrative_is_on == false, 1);
	e6m1_narrative_is_on = true; 
	vo_glo_remainingcov_01();
	e6m1_narrative_is_on = false;
	f_blip_ai_cui (gr_e6_m1_ff_alls, "navpoint_enemy");
end

//*****************************************************************************//
//********************** COMMAND SCRIPTS ****************************//

script command_script cs_e6_m1_pilot
	ai_disregard(ai_current_actor, true);
	ai_cannot_die(ai_current_actor, true);
	//ai_playfight(ai_current_actor, true);
	cs_push_stance("flee");
	cs_stow(true);
	//cs_throttle_set(true, 1.0);
	print("Aaaaa0: Pilot before Player arrival");
	sleep_s(3);
	//cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:rifle:wave", TRUE);
	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE); // point?
	sleep_until (r_final_seq_stage >= 1, 1); // player is in visible sight
	
	print("A1: Pilot wait for Player to lower shield");
	unit_stop_custom_animation (ai_current_actor);
	sleep_s(0.5);
	//cs_go_to(ps_e6_m1_final_pilot.p0, 1);
	//cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:rifle:wave", TRUE);
	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var1", TRUE); // point?
	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
	
	print("A2: Pilot -  shield lowered, go get a weapon");
	unit_stop_custom_animation (ai_current_actor);
	cs_go_to(ps_e6_m1_final_pilot.p1, 1);
	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var1", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	cs_push_stance(-1);
	cs_stow(false);
	
	print("A3: Pilot Go to door");
	sleep_s(0.8);
	cs_go_to(ps_e6_m1_final_pilot.p2);
	
	if(b_e6m1_blip_outside_interior) then
		object_create(lz_16);
		navpoint_track_object_named (lz_16, "navpoint_goto");
	end
	print("A3a: Pilot at door");
	sleep_until (r_final_seq_stage >= 3, 1);
		
	print("A5: Pilot takes cover");
	cs_go_to(ps_e6_m1_final_pilot.p3);
	
	print("B0a: pilot fighting");
	
	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
	print("B1a: pilot tell player about controls, moves to ramp");
	notifyLevel("e6_m1_pilot");
	cs_go_to(ps_e6_m1_final_pilot.p4); // move to position and wait for player to reduce enemy numbers
	// spawn more waves
	
	/** Wave 2 **/
	sleep_until (r_final_seq_stage >= 5, 1);// player clears balcony
	print("B2a: pilot moves up to controls");
	cs_go_to_and_face(ps_e6_m1_final_pilot.p5, ps_e6_m1_final_pilot.p7); // move up to controls
	
//	cs_crouch(TRUE);
//	cs_stow(FALSE);
	cs_push_stance("flee");
	ai_set_blind(ai_current_actor, true);
	local boolean b_loop_anim = true;
	sleep_s(1);
	cs_crouch(FALSE);
	cs_stow(TRUE);
	repeat
		print("random anim");
		begin_random_count (1)
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1a", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1b", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1c", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1d", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1e", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "vin_marine_work_at_wall_terminal_loop_v1f", TRUE);
			cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
		end
		sleep(15);
	until (r_final_seq_stage == 8, 1);
	// spawn in more guys
	unit_stop_custom_animation (ai_current_actor);
	cs_stow(FALSE);
	cs_push_stance(-1);
	ai_set_blind(ai_current_actor, false);
	
	/** Wave 3 **/
	sleep_until (r_final_seq_stage == 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
	print("B3a: pilot moves to captured phantom");
	cs_crouch(false);
	cs_go_to(ps_e6_m1_final_pilot.p6);
end
//** Pilot AI logic moved out to static void so he can fight as normal while in sleep **//

script static void f_e6m1_marines_to_phantom()
	sleep_until (r_final_seq_stage == 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1);
	cs_run_command_script(sq_e6_m1_marines_left.spawn_points_0, cs_e6m1_marine1_to_phantom);
	cs_run_command_script(sq_e6_m1_marines_left.spawn_points_1, cs_e6m1_marine2_to_phantom);
	cs_run_command_script(sq_e6_m1_marines_right.spawn_points_2, cs_e6m1_marine3_to_phantom);
	cs_run_command_script(sq_e6_m1_marines_right.spawn_points_3, cs_e6m1_marine4_to_phantom);
end
	
	
script command_script cs_e6_m1_marine_1
	//ai_cannot_die(ai_current_actor, true);
	//ai_playfight(ai_current_actor, true);
	cs_push_stance("flee");
	cs_stow(true);
	
	print("A0: marine_1 before Player arrival");
	sleep_s(3);
	cs_crouch(true);
		
	sleep_until (r_final_seq_stage >= 1, 1); // player is in visible sight
	print("A1: marine_1 wait for Player to lower shield");
	cs_crouch(false);
	sleep_s(0.5);
	//cs_go_to(ps_e6_m1_final_marine_1.p0, 1);
	//cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:rifle:wave", TRUE);
	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var1", TRUE); // point?
		
	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
	print("A2: marine_1 -  shield lowered, go get a weapon");
	unit_stop_custom_animation (ai_current_actor);
	cs_go_to(ps_e6_m1_final_marine_1.p1, 1);
	cs_push_stance(-1);
	cs_stow(false);
	
	print("A3: marine_1 Go to door");
	sleep_s(0.8);
	cs_go_to(ps_e6_m1_final_marine_1.p2);
	
	b_marine_1_ready_to_fight = TRUE;
	sleep_until(b_marine_1_ready_to_fight == TRUE and b_marine_2_ready_to_fight == TRUE, 1);	
	ai_set_task(sq_e6_m1_marines_left, obj_defend_marines, doorway_left);
	
//	sleep_until (r_final_seq_stage >= 3, 1);
//	
//	print("A4: marine_1 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_1 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_1.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	//cs_crouch(true);
//	cs_e6_m1_marine_1_cont(ai_current_actor);
	
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_1 move to phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p6);
end

script command_script cs_e6m1_marine1_to_phantom
	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p6);
end

//script static void cs_e6_m1_marine_1_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_1 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_1 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	print("B2: marine_1 move up");
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 6, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_1)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p5); // move up to controls
//	// spawn in more guys
//	print("B3: marine_1 move outside");
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_1 move to phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p6);
//end

script command_script cs_e6_m1_marine_2
	//ai_cannot_die(ai_current_actor, true);
	//ai_playfight(ai_current_actor, true);
	cs_push_stance("flee");
	cs_stow(true);
	
	print("A0: marine_2 before Player arrival");
	repeat
		sleep_s(3);
		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
		unit_stop_custom_animation (ai_current_actor);
	until(r_final_seq_stage >= 1, 1); // player is in visible sight
	
	print("A1: marine_2 wait for Player to lower shield");
	sleep_s(0.5);
	//cs_go_to(ps_e6_m1_final_marine_2.p0, 1);	
	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
	
	print("A2: marine_2 -  shield lowered, go get a weapon");
	cs_go_to(ps_e6_m1_final_marine_2.p1, 1);
	cs_push_stance(-1);
	cs_stow(false);
	
	print("A3: marine_2 Go to door");
	sleep_s(0.8);
	cs_go_to(ps_e6_m1_final_marine_2.p2);
	sleep_until (r_final_seq_stage >= 3, 1);
	
	b_marine_2_ready_to_fight = TRUE;
	//sleep_until(b_marine_1_ready_to_fight == TRUE and b_marine_2_ready_to_fight == TRUE);	
	//ai_set_objective(sq_e6_m1_marines_left, obj_defend_marines);
	
	
//	print("A4: marine_2 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_2 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_2.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	//cs_crouch(true);
//	cs_e6_m1_marine_2_cont(ai_current_actor);

//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_1 move to phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p6);
end

script command_script cs_e6m1_marine2_to_phantom
	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p6);
end

//script static void cs_e6_m1_marine_2_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_2 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_2 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 6, 1);
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_1)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p5); // move outside
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p6);
//end

script command_script cs_e6_m1_marine_3
	//ai_cannot_die(ai_current_actor, true);
	//ai_playfight(ai_current_actor, true);
	cs_push_stance("flee");
	cs_stow(true);
	
	print("A0: marine_3 before Player arrival");
	repeat
		sleep_s(3);
		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
		unit_stop_custom_animation (ai_current_actor);
	until(r_final_seq_stage >= 1, 1); // player is in visible sight
	
	print("A1: marine_3 wait for Player to lower shield");
	sleep_s(0.5);
	//cs_go_to(ps_e6_m1_final_marine_3.p0, 1);	
	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
	
	print("A2: marine_3 -  shield lowered, go get a weapon");
	cs_go_to(ps_e6_m1_final_marine_3.p1, 1);
	cs_push_stance(-1);
	cs_stow(false);
	
	print("A3: marine_3 Go to door");
	sleep_s(0.8);
	cs_go_to(ps_e6_m1_final_marine_3.p2);
	sleep_until (r_final_seq_stage >= 3, 1);
	
	b_marine_3_ready_to_fight = TRUE;
	sleep_until(b_marine_3_ready_to_fight == TRUE and b_marine_4_ready_to_fight == TRUE, 1);	
	ai_set_task(sq_e6_m1_marines_right, obj_defend_marines, doorway_right);
	
//	print("A4: marine_3 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_3 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_3.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	cs_crouch(true);
//	cs_e6_m1_marine_3_cont(ai_current_actor);

//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p6);

end

script command_script cs_e6m1_marine3_to_phantom
	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p6);
end

//script static void cs_e6_m1_marine_3_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_3 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_3 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 5, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_2)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_crouch(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p5); // move up to controls
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p6);
//end

script command_script cs_e6_m1_marine_4
	ai_cannot_die(ai_current_actor, true);
	//ai_playfight(ai_current_actor, true);
	cs_push_stance("flee");
	cs_stow(true);
	
	print("A0: marine_4 before Player arrival");
	repeat
		sleep_s(3);
		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
		unit_stop_custom_animation (ai_current_actor);
	until(r_final_seq_stage >= 1, 1); // player is in visible sight
	
	print("A1: marine_4 wait for Player to lower shield");
	sleep_s(0.5);
	//cs_go_to(ps_e6_m1_final_marine_4.p0, 1);	
	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
	
	print("A2: marine_4 -  shield lowered, go get a weapon");
	cs_go_to(ps_e6_m1_final_marine_4.p1, 1);
	cs_push_stance(-1);
	cs_stow(false);
	
	print("A3: marine_4 Go to door");
	sleep_s(0.8);
	cs_go_to(ps_e6_m1_final_marine_4.p2);
	sleep_until (r_final_seq_stage >= 3, 1);
	
	b_marine_3_ready_to_fight = TRUE;
	
//	print("A4: marine_4 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_4 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_4.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	cs_crouch(true);
//	cs_e6_m1_marine_4_cont(ai_current_actor);
//
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_4 moves towards captured phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p6);
end

script command_script cs_e6m1_marine4_to_phantom
	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p6);
end

//script static void cs_e6_m1_marine_4_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_4 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_4 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 5, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_2)<= 2, 1);
//	print("B2: marine_4 moves out of interior");
//	ai_cannot_die(ai_current_actor, false);
//	cs_crouch(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p5); // move up to controls
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_4 moves towards captured phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p6);
//end

script command_script cs_e6_m1_final_phantom_1
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .5, 1);
	cs_ignore_obstacles (true);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	ai_cannot_die(ai_current_actor, true);
	thread(f_monitor_phantom_health(ai_current_actor));
	print("Ph1_0: Flying to ambush posdfsd");
	object_set_scale (ai_vehicle_get ( ai_current_actor ), 1, 90 ); //increase size over time
	cs_fly_to(ps_e6_m1_final_phantom_1.p7);
	cs_vehicle_speed(.5);
	cs_fly_to_and_face(ps_e6_m1_final_phantom_1.p0, ps_e6_m1_final_phantom_1.p11, 3);
	cs_fly_to_and_dock(ps_e6_m1_final_phantom_1.p0, ps_e6_m1_final_phantom_1.p11, 3);
	
	f_load_phantom(sq_final_phantom_1, left, sq_e6_m1_final_7_left, none, none, none);
	sleep_until(b_e6_m1_final_doors_open == true, 1);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_1, "left");
	sleep_s(2);
	sleep_until(ai_living_count(sq_e6_m1_final_7_left) == 0, 1);
	
	sleep_until(r_final_seq_stage >= 4, 1);
	
	f_load_phantom(sq_final_phantom_1, left, sq_e6_m1_final_1, none, none, none);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_1, "left");
	sleep_s(2);
	sleep_until(ai_living_count(sq_e6_m1_final_1) == 0, 1);
	
	sleep_until(r_final_seq_stage >= 6, 1);
	sleep_s(3);
	f_load_phantom(sq_final_phantom_1, left, none, sq_e6_m1_final_1, none, none);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_1, "left");
	sleep_s(2);
	sleep_until(ai_living_count(sq_e6_m1_final_1) == 0, 1);
	
	sleep_s(3);
	
	print("Ph1_2: Flying away");
	cs_vehicle_speed(1);
	vehicle_hover(ai_current_actor, false);
	cs_fly_to(ps_e6_m1_final_phantom_1.p5);
	cs_fly_to(ps_e6_m1_final_phantom_1.p4);
	object_set_scale (ai_vehicle_get(ai_current_actor ), .1, 90 ); //decrease size over time
	cs_fly_to(ps_e6_m1_final_phantom_1.p6);
	
	ai_erase(ai_current_squad);
end

//** Last Phantom to Capture **//
script command_script cs_e6_m1_final_phantom_2
	object_set_scale(ai_vehicle_get ( ai_current_actor ), 0.5, 1);
	cs_ignore_obstacles (true);
	cs_enable_targeting (true);
	cs_enable_looking(false);
	object_set_shadowless (ai_current_actor, TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	
	ai_cannot_die(ai_current_actor, true);
	thread(f_monitor_phantom_health(ai_current_actor));
	
	local ai ai_chin_gun = object_get_ai(object_at_marker(unit_get_vehicle(ai_current_actor), "chin_gun"));
	ai_cannot_die(ai_chin_gun, true);
	
	print("Ph2_0: Flying  to ambush pos");
	object_set_scale (ai_vehicle_get ( ai_current_actor ), 1, 90 ); //increase size over time
	cs_fly_to(ps_e6_m1_final_phantom_2.p15);
	cs_vehicle_speed(.5);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p0, ps_e6_m1_final_phantom_2.p18, 2);
	cs_fly_to_and_dock (ps_e6_m1_final_phantom_2.p0, ps_e6_m1_final_phantom_2.p18, 2);
	sleep_s(1);
	
	f_load_phantom(sq_final_phantom_2, right, sq_e6_m1_final_8_right, none, none, none);
	sleep_until(b_e6_m1_final_doors_open == true, 1);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_2, "right");
	sleep_s(2);
	sleep_until(ai_living_count(sq_e6_m1_final_8_right) == 0, 1);
	
	sleep_s(1);
		sleep_until(r_final_seq_stage >= 4, 1);
	f_load_phantom(sq_final_phantom_2, right, sq_e6_m1_final_2, none, none, none);
	sleep_s(1);
	f_unload_phantom(sq_final_phantom_2, "right");
	sleep_s(2);
	sleep_until(ai_living_count(sq_e6_m1_final_2) == 0, 1);
	
	print("Ph2_1: Spawn2 and parking front balcony");
	//sleep_s(1);
	sleep_until(r_final_seq_stage >= 5, 1);
	sleep_s(4);
	
	f_load_phantom(sq_final_phantom_2, right, none, sq_e6_m1_final_2, none, none);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_2, "right");
	sleep_s(3);
	
	cs_vehicle_speed(.4);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p2, ps_e6_m1_final_phantom_2.p3);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p4, ps_e6_m1_final_phantom_2.p18);
	sleep(10);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p19, ps_e6_m1_final_phantom_2.p10, 2);
	cs_fly_to_and_dock (ps_e6_m1_final_phantom_2.p19, ps_e6_m1_final_phantom_2.p10, 2);
	
	sleep_until(r_final_seq_stage >= 7, 1);
	sleep_s(2);
	local real r_player_count = list_count(players());
	
	f_load_phantom(sq_final_phantom_2, dual, sq_e6_m1_final_4, sq_e6_m1_final_6, none, none);
	sleep_s(1);
	f_unload_phantom (sq_final_phantom_2, "dual");
		
	if (r_player_count > 2) then
		f_load_phantom(sq_final_phantom_2, dual, none, none, sq_e6_m1_final_3, sq_e6_m1_final_5);
	end
		
	print("Phantom 2 spinning out of control");
	cs_vehicle_speed(0.5);
	ai_set_blind(ai_current_actor, true);
	effect_new_on_object_marker_loop( "levels\firefight\dlc01_factory\fx\emp_drain.effect", unit_get_vehicle(ai_current_actor), fx_hull_explosion);
	
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\events\factory_platform_emp_activate_in', sq_final_phantom_2, 1);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p5, ps_e6_m1_final_phantom_2.p10);
	sleep(10);
	ai_kill(sq_final_phantom_2.spawn_points_2);
	sleep(10);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p6, ps_e6_m1_final_phantom_2.p10);
	sleep(10);
	ai_kill(sq_final_phantom_2.spawn_points_1);
	sleep(30);
	cs_fly_to_and_face (ps_e6_m1_final_phantom_2.p19, ps_e6_m1_final_phantom_2.p10, 2);
	sleep(30);
	cs_fly_to_and_dock (ps_e6_m1_final_phantom_2.p19, ps_e6_m1_final_phantom_2.p10, 1.75);
	sleep(10);
	f_unload_phantom(ai_current_actor, "dual");
	
	ai_set_team (sq_final_phantom_2, human);
	ai_disregard(ai_actors(ai_current_actor), true);
	ai_disregard(ai_actors(ai_chin_gun), true);
	
	cs_enable_targeting (false);
	ai_braindead(sq_final_phantom_2, true);
	r_final_seq_stage = 8;
end

script static void f_e6m1_faux_gravlift
	if not object_valid( lz_20 ) then
		object_create( lz_20 );
	end

	effect_new_on_object_marker(objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect, ai_vehicle_get_from_spawn_point(sq_final_phantom_2.phantom), "lift_direction" );
	sound_looping_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_lich_grav_lift_loop', lz_20, 1); //LOOPING AUDIO!
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_grav_lift_activate_in', ai_vehicle_get_from_spawn_point(sq_final_phantom_2.phantom), 1); //AUDIO!	
	repeat
		if(volume_test_object(tv_e6_m1_gravlift, player0) == true)then
			thread(f_e6m4_faux_levitate(player0));
			navpoint_track_object (lz_17, false);
			print("stop tracking 17");
			f_unblip_object_cui (lz_17);
		end
		if(volume_test_object(tv_e6_m1_gravlift, player1) == true)then
			thread(f_e6m4_faux_levitate(player1));
			navpoint_track_object (lz_17, false);
			print("stop tracking 17");
			f_unblip_object_cui (lz_17);
		end
		if(volume_test_object(tv_e6_m1_gravlift, player2) == true)then
			thread(f_e6m4_faux_levitate(player2));
			navpoint_track_object (lz_17, false);
			print("stop tracking 17");
			f_unblip_object_cui (lz_17);
		end
		if(volume_test_object(tv_e6_m1_gravlift, player3) == true)then
			thread(f_e6m4_faux_levitate(player3));
			navpoint_track_object (lz_17, false);
			print("stop tracking 17");
			f_unblip_object_cui (lz_17);
		end
	until(volume_test_players(tv_e6_m1_fadeout) == true, 1);
end

script static void f_e6m4_faux_levitate(object o_player)
	pup_exit_vehicle_immediate(o_player, true, false);
	sleep(6);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_lift_in_mnde8298', o_player, body, 1 ); //AUDIO!
	repeat
		object_set_velocity(o_player, 0, 0, 2);
	until(volume_test_players(tv_e6_m1_fadeout) == true, 1);
	fade_out(0, 0, 0, 10); 
	b_e6_m1_gravfinished = true; 
end

script command_script cs_final_elite
	local real r_shield_disable_time = real_random_range(0, 2);
	sleep_s(r_shield_disable_time);
	print("Final Elite shield down");
	effect_new_on_object_marker( "objects\characters\storm_elite\fx\shield\shield_collapse.effect", ai_get_object(ai_current_actor), fx_shield_down_chest);
	object_set_shield(ai_get_object(ai_current_actor), 0);
end

script command_script cs_final_fodder
	local real r_chance_of_death = real_random_range(0, 100);
	if (r_chance_of_death >= 80) then
		object_set_health(ai_get_object(ai_current_actor), 0.01);
	end
end

global object g_ics_player = none;
script static void f_e6_m1_disable_shield(object control, unit player)
	g_ics_player = player;
	
	
	if control == dc_e6_m1_switch4 then
		print("notifying the level of prison shield");
		//notifyLevel("e6_m1_prison_door_lowered");
	end
	
	/*if (control == dc_e6_m1_switch7 or control == dc_e6_m1_switch8) and (b_donut_shield_switch_dialog == FALSE) then
	thread(f_music_e06m1_first_generator());
		vo_e6m1_first_generator_down();
		b_donut_shield_switch_dialog = TRUE;
	end*/
end

script static void f_e6_m1_door_hold(object control, unit player)
	g_ics_player = player;
	if control == dc_e6_m1_switch2 then
		notifyLevel("e6_m1_exit_diamond");
	end
end
//"patrol:unarmed:posing:var1" - adjusting helmet
//"crouch:pistol:idle" - crouching pistol
//"crouch:pistol:throw_grenade" - tell squad to move forward?
//"combat:pistol:surprise_front" - surprised when door opens
//"combat:pistol:brace" - duck for cover
//"patrol:unarmed:posing:var2" - picking up stone

script static void fx_activate_restraints()
	// Turns on the restraint effects for the e6_m1_intro vignette
	// Note: the way the octopus bones are setup is not consistent between players. Here is how they are setup:
	// Player		Hand		Octopus name			Marker for the wrist		Marker for the wall
	//   1			Left		e6m1_oct1				marker2						marker6
	//   1			Right		e6m1_oct1				marker1						marker5
	//   2			Left		e6m1_oct1				marker4						marker8
	//   2			Right		e6m1_oct1				marker3						marker7
	//   3			Left		e6m1_oct2				marker7						marker8
	//   3			Right		e6m1_oct2				marker5						marker6
	//   4			Left		e6m1_oct2				marker3						marker4
	//   4			Right		e6m1_oct2				marker2						marker1
	
	if player_valid(player0()) then
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p1.effect, e6m1_oct1, marker1); // Beams and flares
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker1); // Right wrist		
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker2); // Left wrist
		sleep(10); // To prevent overloading the gpu particle load limit
	end
	
	if player_valid(player1()) then
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p2.effect, e6m1_oct1, marker3); // Beams and flares
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker3); // Right wrist		
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker4); // Left wrist
		sleep(10);
	end
	
	if player_valid(player2()) then
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p3.effect, e6m1_oct2, marker7); // Beams and flares
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker5); // Right wrist
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker7); // Left wrist
		sleep(10);
	end
	
	if player_valid(player3()) then
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p4.effect, e6m1_oct2, marker4); // Beams and flares
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker2); // Right wrist
		effect_new_on_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker3); // Left wrist
	end
end

script static void fx_deactivate_restraints()
	// Turns off the restraint effects for the e6_m1_intro vignette
	if player_valid(player0()) then
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p1.effect, e6m1_oct1, marker1); // Beams and flares
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker1); // Right wrist
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker2); // Left wrist
	end
	
	sleep(30*4);
	
	if player_valid(player1()) then
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p2.effect, e6m1_oct1, marker3); // Beams and flares
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker3); // Right wrist
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct1, marker4); // Left wrist
	end
	
	if player_valid(player2()) then
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p3.effect, e6m1_oct2, marker7); // Beams and flares
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker5); // Right wrist
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker7); // Left wrist
	end
	
	if player_valid(player3()) then
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint_beam_p4.effect, e6m1_oct2, marker4); // Beams and flares
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker2); // Right wrist
		effect_stop_object_marker(levels\firefight\dlc01_factory\fx\hardlight_restraint.effect, e6m1_oct2, marker3); // Left wrist
	end
end

// function to blind initial elite until you walk in front of him or shoot him is now cut
// if you want it back, just put this command script on sq_e6_m1_factory_inital2.spawn_points_1
script command_script cs_init_elite 
	ai_set_blind(ai_current_actor, true);
	sleep_until ((b_init_ai_blind == false) or (unit_get_shield(ai_current_actor) < 1), 1, 1);
	ai_set_blind(ai_current_actor, false);
end

script static void f_e6_m1_waypoint_breadcrumbs (real objectdistance, object flag)
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
	//object_destroy (flag);
end

script static void f_e6_m1_callout_phantom
	repeat
		sleep_until (LevelEventStatus("e6_m1_callout_phantom_vo"), 1);
		print ("CALLOUT PHANTOM");
		sleep_until(e6m1_narrative_is_on == false, 1);
		e6m1_narrative_is_on = true;
		
		begin_random_count (1)
			//vo_glo_phantom_02();
			//vo_glo_phantom_03();
			vo_glo_phantom_07();
			vo_glo_phantom_08();
			vo_glo_phantom_09();
		end
		e6m1_narrative_is_on = false;
	until (b_game_ended == true);
end

script static void f_e6_m1_blip_enemies
	repeat
		sleep_until (LevelEventStatus("e6_m1_blip_enemy_vo"), 1);
		print ("blip enemies and VO");
		sleep_until(e6m1_narrative_is_on == false, 1);
		e6m1_narrative_is_on = true;
		
		if editor_mode() then
			print ("calling random blip vo");
		end
		begin_random_count (1)
			vo_glo_remainingcov_01();
			vo_glo_remainingcov_02();
			vo_glo_remainingcov_03();
			vo_glo_remainingcov_04();
			vo_glo_cleararea_01();
			vo_glo_cleararea_02();
			vo_glo_cleararea_03();
		end
		print("+++++++BLIP ENEMIES++++");
		f_blip_ai_cui (gr_e6_m1_ff_alls, "navpoint_enemy");
		ai_set_objective(gr_e6_m1_ff_alls, follow_player);
		e6m1_narrative_is_on = false;
	until (b_game_ended == true);
end

script static void f_monitor_phantom_health(ai ai_current_actor)
	local unit u_phantom_monitored = unit_get_vehicle(ai_current_actor);
	sleep_until(unit_get_health(u_phantom_monitored) <= 0.1, 1);
	object_cannot_take_damage(u_phantom_monitored);
	print("Phantom no longer takes damage");
end

script command_script cs_kamikaze_grunts
	thread(f_kamikaze_grunts(ai_current_actor));
end

script static void f_kamikaze_grunts (ai ai_current_actor)
	sleep_until(volume_test_players(tv_donut_1) == true, 1);
	sleep_rand_s (0.5, 1.5);
	ai_grunt_kamikaze(ai_current_actor);
end

//================================TURRETS+++++++++++++++++++++++++++++++++++

script command_script cs_e6m1_turret_1  
	ai_set_blind (sq_e6_m1_tracer.sp0 , true);
	//ai_disregard (sq_e6_m1_tracer , true);
	f_unblip_object_cui(sq_e6_m1_tracer);
	//object_hide(ai_vehicle_get ( ai_current_actor ), true);
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .5, 1);
	//object_cannot_take_damage(ai_get_object(sq_e6_m1_null_pelican_driver2));
	//object_cannot_take_damage(ai_get_object(sq_e6_m1_null_pelican_driver3));
	//object_cannot_take_damage(ai_get_object(sq_e6_m1_phantom_4));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)   
	cs_shoot_point(true, e6_m1_fire_points.p1);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p0);
	sleep_s(1);;
	cs_shoot_point(true, e6_m1_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p2);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p10);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p5);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p10);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p5);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p0);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points.p10);
	sleep_s(1);
	
	repeat
	  	begin_random
	    	begin
	      	cs_shoot_point(true, e6_m1_fire_points.p1);
	    	sleep_s(1);
	     	cs_shoot_point(true, e6_m1_fire_points.p1);
	     	sleep_s(1);
	     	cs_shoot_point(true, e6_m1_fire_points.p3);
	      	sleep_s(0.25);
	     	cs_shoot_point(true, e6_m1_fire_points.p4);
	     	sleep_s(0.25);
	     	cs_shoot_point(true, e6_m1_fire_points.p4);
	     	sleep_rand_s(3.0,5);
	     end
                                                
    	begin
    	cs_shoot_point(true, e6_m1_fire_points.p2);
     	sleep_s(0.25);
     	cs_shoot_point(true, e6_m1_fire_points.p1);
     	sleep_s(0.25);
    	 cs_shoot_point(true, e6_m1_fire_points.p4);
     	 sleep_rand_s(3.0,5);
    	 end
	end
		until( b_e6_m1_stop_firing == TRUE);
	 ai_erase(sq_e6_m1_tracer.sp0);
end

script command_script cs_e6m1_turret_2  
	ai_set_blind ( sq_e6_m1_tracer.sp1 , true);
	f_unblip_object_cui(sq_e6_m1_tracer);
	//object_hide(ai_vehicle_get ( ai_current_actor ), true);
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .5, 1);
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	cs_shoot_point(true, e6_m1_fire_points2.p1);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p0);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p1);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p2);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p10);
	sleep(30 * 4);
	cs_shoot_point(true, e6_m1_fire_points2.p5);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p2);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p5);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p4);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p0);
	sleep_s(1);
	cs_shoot_point(true, e6_m1_fire_points2.p4);
	sleep(30 * 4);
	cs_shoot_point(true, e6_m1_fire_points2.p10);
	sleep_s(1);
	
	 repeat
	 	begin_random
	  	begin
	     	cs_shoot_point(true, e6_m1_fire_points2.p1);
	      	sleep_s(1);
	     	sleep_rand_s(3.0,5);
	     	cs_shoot_point(true, e6_m1_fire_points2.p2);
	    	sleep_s(0.25);
	     	cs_shoot_point(true, e6_m1_fire_points2.p4);
	    	sleep_s(0.25);
	   	cs_shoot_point(true, e6_m1_fire_points2.p5);
	   	sleep_rand_s(3.0,5);
	  end
	                                               
     begin
	   	cs_shoot_point(true, e6_m1_fire_points2.p2);
	    sleep_s(0.25);
        cs_shoot_point(true, e6_m1_fire_points2.p1);
	   sleep_s(1);
	    cs_shoot_point(true, e6_m1_fire_points2.p5);
	    sleep_rand_s(3.0,5);
	   end
	end
	until( b_e6_m1_stop_firing == TRUE);
//	//s_e6_m1_aa_powerdown_count = s_e6_m1_aa_powerdown_count + 1;
	 ai_erase(sq_e6_m1_tracer.sp1);
	//object_destroy(unit_get_vehicle (sq_e6_m1_null_pelican_driver4));
end





//script command_script cs_e6_m1_marine_1
//	//ai_cannot_die(ai_current_actor, true);
//	//ai_playfight(ai_current_actor, true);
//	cs_push_stance("flee");
//	cs_stow(true);
//	
//	print("A0: marine_1 before Player arrival");
//	sleep_s(3);
//	cs_crouch(true);
//		
//	sleep_until (r_final_seq_stage >= 1, 1); // player is in visible sight
//	print("A1: marine_1 wait for Player to lower shield");
//	cs_crouch(false);
//	sleep_s(0.5);
//	//cs_go_to(ps_e6_m1_final_marine_1.p0, 1);
//	//cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:rifle:wave", TRUE);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var1", TRUE); // point?
//		
//	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
//	print("A2: marine_1 -  shield lowered, go get a weapon");
//	unit_stop_custom_animation (ai_current_actor);
//	cs_go_to(ps_e6_m1_final_marine_1.p1, 1);
//	cs_push_stance(-1);
//	cs_stow(false);
//	
//	print("A3: marine_1 Go to door");
//	sleep_s(0.8);
//	cs_go_to(ps_e6_m1_final_marine_1.p2);
//	sleep_until (r_final_seq_stage >= 3, 1);
//	
//	print("A4: marine_1 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_1 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_1.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	//cs_crouch(true);
//	cs_e6_m1_marine_1_cont(ai_current_actor);
//end
//
//script static void cs_e6_m1_marine_1_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_1 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_1 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	print("B2: marine_1 move up");
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 6, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_1)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p5); // move up to controls
//	// spawn in more guys
//	print("B3: marine_1 move outside");
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_1 move to phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_1.p6);
//end
//
//script command_script cs_e6_m1_marine_2
//	//ai_cannot_die(ai_current_actor, true);
//	//ai_playfight(ai_current_actor, true);
//	cs_push_stance("flee");
//	cs_stow(true);
//	
//	print("A0: marine_2 before Player arrival");
//	repeat
//		sleep_s(3);
//		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
//		unit_stop_custom_animation (ai_current_actor);
//	until(r_final_seq_stage >= 1, 1); // player is in visible sight
//	
//	print("A1: marine_2 wait for Player to lower shield");
//	sleep_s(0.5);
//	//cs_go_to(ps_e6_m1_final_marine_2.p0, 1);	
//	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
//	
//	print("A2: marine_2 -  shield lowered, go get a weapon");
//	cs_go_to(ps_e6_m1_final_marine_2.p1, 1);
//	cs_push_stance(-1);
//	cs_stow(false);
//	
//	print("A3: marine_2 Go to door");
//	sleep_s(0.8);
//	cs_go_to(ps_e6_m1_final_marine_2.p2);
//	sleep_until (r_final_seq_stage >= 3, 1);
//	
//	print("A4: marine_2 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_2 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_2.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	//cs_crouch(true);
//	cs_e6_m1_marine_2_cont(ai_current_actor);
//end
//
//script static void cs_e6_m1_marine_2_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_2 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_2 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 6, 1);
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_1)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p5); // move outside
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_2.p6);
//end
//
//script command_script cs_e6_m1_marine_3
//	//ai_cannot_die(ai_current_actor, true);
//	//ai_playfight(ai_current_actor, true);
//	cs_push_stance("flee");
//	cs_stow(true);
//	
//	print("A0: marine_3 before Player arrival");
//	repeat
//		sleep_s(3);
//		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
//		unit_stop_custom_animation (ai_current_actor);
//	until(r_final_seq_stage >= 1, 1); // player is in visible sight
//	
//	print("A1: marine_3 wait for Player to lower shield");
//	sleep_s(0.5);
//	//cs_go_to(ps_e6_m1_final_marine_3.p0, 1);	
//	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
//	
//	print("A2: marine_3 -  shield lowered, go get a weapon");
//	cs_go_to(ps_e6_m1_final_marine_3.p1, 1);
//	cs_push_stance(-1);
//	cs_stow(false);
//	
//	print("A3: marine_3 Go to door");
//	sleep_s(0.8);
//	cs_go_to(ps_e6_m1_final_marine_3.p2);
//	sleep_until (r_final_seq_stage >= 3, 1);
//	
//	print("A4: marine_3 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_3 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_3.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	cs_crouch(true);
//	cs_e6_m1_marine_3_cont(ai_current_actor);
//end
//
//script static void cs_e6_m1_marine_3_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_3 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_3 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 5, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_2)<= 2, 1);
//	ai_cannot_die(ai_current_actor, false);
//	cs_crouch(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p5); // move up to controls
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_3.p6);
//end
//
//script command_script cs_e6_m1_marine_4
//	ai_cannot_die(ai_current_actor, true);
//	//ai_playfight(ai_current_actor, true);
//	cs_push_stance("flee");
//	cs_stow(true);
//	
//	print("A0: marine_4 before Player arrival");
//	repeat
//		sleep_s(3);
//		cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "patrol:unarmed:posing:var2", TRUE);
//		unit_stop_custom_animation (ai_current_actor);
//	until(r_final_seq_stage >= 1, 1); // player is in visible sight
//	
//	print("A1: marine_4 wait for Player to lower shield");
//	sleep_s(0.5);
//	//cs_go_to(ps_e6_m1_final_marine_4.p0, 1);	
//	sleep_until (r_final_seq_stage >= 2, 1); // player lowered shields
//	
//	print("A2: marine_4 -  shield lowered, go get a weapon");
//	cs_go_to(ps_e6_m1_final_marine_4.p1, 1);
//	cs_push_stance(-1);
//	cs_stow(false);
//	
//	print("A3: marine_4 Go to door");
//	sleep_s(0.8);
//	cs_go_to(ps_e6_m1_final_marine_4.p2);
//	sleep_until (r_final_seq_stage >= 3, 1);
//	
//	print("A4: marine_4 react to door opening");
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:surprise_front", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	
//	print("A5: marine_4 takes cover");
//	cs_go_to(ps_e6_m1_final_marine_4.p3);
//	cs_custom_animation (objects\characters\storm_marine\storm_marine.model_animation_graph, "combat:pistol:brace", TRUE);
//	unit_stop_custom_animation (ai_current_actor);
//	cs_crouch(true);
//	cs_e6_m1_marine_4_cont(ai_current_actor);
//end
//
//script static void cs_e6_m1_marine_4_cont(ai ai_current_actor)
//	/** Wave 1 **/
//	print("B0: marine_4 func2");
//	
//	sleep_until (r_final_seq_stage >= 4, 1); // player has killed some baddies
//	print("B1: marine_4 fighting");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p4); // move to position and wait for player to reduce enemy numbers
//	// spawn more waves
//	
//	/** Wave 2 **/
//	sleep_until (r_final_seq_stage >= 5, 1);// player clears balcony
//	sleep_s(2);
//	sleep_until(ai_living_count(sq_e6_m1_final_2)<= 2, 1);
//	print("B2: marine_4 moves out of interior");
//	ai_cannot_die(ai_current_actor, false);
//	cs_crouch(ai_current_actor, false);
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p5); // move up to controls
//	// spawn in more guys
//	
//	/** Wave 3 **/
//	sleep_until (r_final_seq_stage >= 8 and ai_living_count(gr_e6_m1_ff_alls)<= 0, 1); // defend the top while the pilot is hacking the phantom
//	print("B3: marine_4 moves towards captured phantom");
//	cs_go_to(ai_current_actor, true, ps_e6_m1_final_marine_4.p6);
//end