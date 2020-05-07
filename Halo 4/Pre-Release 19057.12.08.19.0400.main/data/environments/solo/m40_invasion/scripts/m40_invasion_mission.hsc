//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion
//	Insertion Points:	start (or ica)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global ai squad_main_marines = NONE;
global ai marines_main_hog_01_dr = NONE;
global ai marines_main_hog_01_gunner = NONE;
global ai marines_main_hog_01_pass = NONE;
global ai marines_main_hog_02_dr = NONE;
global ai marines_main_hog_02_gunner = NONE;
global ai marines_main_hog_02_pass = NONE;
global ai marines_main_goose_01_dr = NONE;
global ai marines_main_goose_01_pass = NONE;
global object g_ics_player = NONE;
global object my_first_aa = NONE;

global object aa_right_01 = NONE;
global object aa_right_02 = NONE;

global object aa_left_01 = NONE;
global object aa_left_02 = NONE;

global short TST_faraway_dist = 0;
global short TST_closeup_dist = 0;

global real TST_upper_speed = 0;
global real TST_norm_speed = 0;

global short TDT_dist = 0;

global long lich_blip_var = 0;

global short obj_state = 0;
global short cavern_obj_state = 0; 
global short lakeside_obj_state = 0;
global short cliffside_obj_state = 0;
global short prechopper_obj_state = 0; 
global short chop_obj_state = 0;  
global short lich_interior_obj_state = 0;
global short waterfall_obj_state = 0;
global short epic_obj_state = 0;
global short epic_backup_obj_state = 0; 
global short lich_rest_state = 0; 
global short lich_pilot_state = 0;
global short chop_marine_backup_op = 0;
global short cliffside_phantom_roulette_short = 0;
global short epic_bubbles_burst = 0;

global long lasky_first_show = 0;
global long	tort_marine_biped_right_long_pup = 0;
global long	tort_marine_biped_left_long_pup = 0;
global long	tort_marine_bottom_long_pup = 0;
global long lasky_final_pup = 0;
global long pelican_and_cannon_pup = 0;
global long lakeside_cannon_initial_pup = 0;
global long chopper_cannon_pup_full = 0;


global boolean dm_mode1 = false;

global boolean lakeside_backup_ghosts_3_bool = false;

global boolean player_exited_caverns = false;
global boolean epic_insertion_state = FALSE;
global boolean cliffside_tort_floor_test_bl = FALSE;
global boolean lakeside_ending_state = FALSE;
global boolean prechopper_arrival = FALSE;
global boolean pelican_dies = FALSE;
global boolean tort_stopped = FALSE;
global boolean tort_stopped_for_five_seconds = FALSE;
global boolean target_laser_pickup = FALSE;
global boolean cav_started = FALSE;
global boolean phantom_hang_out = TRUE;
global boolean player_equipped_jetpack = FALSE;
global boolean player_equipped_locator = FALSE;
global boolean lakeside_target_laser_acquired = FALSE;
global boolean alt_tortoise	= true;
global boolean tort_bay_doors_opened	= false;
global boolean cav_rollout_rdy	= false;
global boolean lakeside_rollout_rdy	= false;
global boolean chopper_rollout_rdy	= false;
global boolean waterfall_rollout_rdy	= false;
global boolean tort_top_lakeside	= false;
global boolean lich_alive_state	= true;
global boolean lakeside_phantom_escape_repeat = FALSE;
global boolean cannon_death_state	= true;
global boolean cannon_2_death_state	= true;
global boolean garbage_collecting	= false;
global boolean tort_global_interior	= false;
global boolean tort_top	= true;
global boolean tort_middle	= false;
global boolean tort_bottom	= false;
global boolean epic_ending_rdy = FALSE;
global boolean target_des_ready = FALSE;
global boolean lakeside_phantom_hang_out = TRUE;
global boolean player_in_lakeside_enc = FALSE;
global boolean waterfall_phantom_01_hang_out = TRUE;
global boolean waterfall_phantom_02_hang_out = TRUE;
global boolean ics_over_bool = FALSE;
global boolean player_left_caverns_early = FALSE;
global boolean lakeside_phantom_07_hangout_bool = TRUE;
global boolean lakeside_wraith_shell_bool = TRUE;
global boolean first_time_charged = TRUE;
global boolean lakeside_cannon_alive = TRUE;
global boolean chopper_cannon_alive = TRUE;
global boolean epic_bubble_one_burst = false;
global boolean epic_bubble_two_burst = false;
global boolean lakeside_pelican_airlift_bool = false;
global boolean palmer_vignette = false;
global boolean lich_boarded_state = false;
global boolean rail_gun_prompt_bool = false;
global boolean lakeside_enc_ending = false;
global boolean player_in_lich = false;
global boolean prechop_recording_loaded = false;
global boolean prechop_recording_loaded_2 = false;
global boolean m_ics_player0 = false;
global boolean m_ics_player1 = false;
global boolean m_ics_player2 = false;
global boolean m_ics_player3 = false;
global boolean firing_on_cannon = false;
global boolean lakeside_phantom_hanging_out = false;
global boolean lich_exploded = false;
global boolean lakeside_warthog_deploy = true;
global boolean player_done_with_opening_pups = false;
global boolean palmer_pup_breakout_bool = false;
global boolean tort_high_speed = false;
global boolean tort_done_in_mission = false;
global boolean cav_pelican_dies = false;
global boolean jetpacks_revealed = false;
global boolean rgt_bool = false;
global boolean player_approaching_hilltop = false;
global boolean lich_landed_at_chopper = false;
global boolean player_at_lich_mound = false;

global boolean 	p0_on_waterfall_tort = false;
global boolean 	p1_on_waterfall_tort = false;
global boolean 	p2_on_waterfall_tort = false;
global boolean 	p3_on_waterfall_tort = false;

global boolean lich_dead_early = false;

global boolean target_designator_disabled = FALSE;

global boolean tort_speed_test = false;

global boolean tort_speed_test_active = false;

//used for seeing where the player is while the tortoise is moving
global boolean player0_tort_far_ahead = false;
global boolean player0_tort_far_behind = false;

global boolean player1_tort_far_ahead = false;
global boolean player1_tort_far_behind = false;

global boolean player2_tort_far_ahead = false;
global boolean player2_tort_far_behind = false;

global boolean player3_tort_far_ahead = false;
global boolean player3_tort_far_behind = false;


global boolean player0_on_tortoise = false;
global boolean player0_near_tortoise = false;

global boolean player1_on_tortoise = false;
global boolean player1_near_tortoise = false;

global boolean player2_on_tortoise = false;
global boolean player2_near_tortoise = false;

global boolean player3_on_tortoise = false;
global boolean player3_near_tortoise = false;

global boolean player0_valid_and_on_tortoise_or_not_valid = false;
global boolean player1_valid_and_on_tortoise_or_not_valid = false;
global boolean player2_valid_and_on_tortoise_or_not_valid = false;
global boolean player3_valid_and_on_tortoise_or_not_valid = false;

//used for seeing where the player is while the tortoise is stopped
global boolean player0_valid_and_far_from_tortoise_or_not_valid = false;
global boolean player1_valid_and_far_from_tortoise_or_not_valid = false;
global boolean player2_valid_and_far_from_tortoise_or_not_valid = false;
global boolean player3_valid_and_far_from_tortoise_or_not_valid = false;

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m40_invasion()

	dprint( "::: M40 - INVASION :::" );

	if ( b_game_emulate or (not editor_mode()) ) then
		fade_out( 0, 0, 0, 0 );
	end

	if ( b_game_emulate or (not editor_mode()) ) then
	
		// in editor mode make sure the players are there to start
		if ( editor_mode() ) then
			f_insertion_playerwait();
		end

		// run start function
		start();

		sleep_until( b_mission_started, 1);
		fade_in( 0, 0, 0, (0.50 * 30) );

	end

	// wait for the game to start
	sleep_until( b_mission_started, 1 );

	if b_encounters then

	// display difficulty
	print_difficulty(); 
	
	end
	
	/*
	//f_loadout_set ("default");
	

	// ============================================================================================
	// STARTING THE GAME

	// ============================================================================================
	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then
		// if true, start the game
		start();
		// else just fade in, we're in edit mode
	elseif b_debug then
				print (":::  editor mode  :::");
				fade_in (0, 0, 0, 0);
	end
	*/
	
end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()
	//dprint( "::: start :::" );

	f_insertion_index_load( game_insertion_point_get() );
	
	objectives_set_string (0, m40_pause_screen_1);
	objectives_set_string (1, m40_pause_screen_2);
	objectives_set_string (2, m40_pause_screen_3);
	//pause screen objectives

	/*
	// Figure out what insertion point to use
	// Set these in init.txt or editor_init.txt to work on various areas quickly
	if (game_insertion_point_get() == 0) then
		ins_cavern();
	elseif (game_insertion_point_get() == 1) then
		ins_fodder();
	elseif (game_insertion_point_get() == 2) then
		ins_lakeside();
	elseif (game_insertion_point_get() == 12) then
		ins_cliffside();
	elseif (game_insertion_point_get() == 3) then
		ins_prechopper();
	elseif (game_insertion_point_get() == 4) then
		ins_chopper();
	elseif (game_insertion_point_get() == 11) then
		ins_waterfall();
	elseif (game_insertion_point_get() == 5) then
		ins_jackal();
	elseif (game_insertion_point_get() == 6) then
		ins_citadel();
	elseif (game_insertion_point_get() == 7) then
		ins_powercave();
	elseif (game_insertion_point_get() == 8) then
		ins_librarian();
	elseif (game_insertion_point_get() == 9) then
		ins_ordnance();
	elseif (game_insertion_point_get() == 10) then
		ins_epic();
	end
	*/
end

// =================================================================================================
// =================================================================================================
// CAVERN
// =================================================================================================
// =================================================================================================

//script static void tort_no()
//	vehicle_set_unit_interaction (big_tort, "mac_d", false, false);
//	print ("mac gun closed");
//end
//

script dormant f_landing_main()
	sleep_until (b_mission_started == TRUE);
	dprint  ("::: landing start :::");
end

script static void 	cav_started_sc()
	cav_started = true;
	print ("cav_started was set to TRUE");
end

script dormant cavern_cutscene_control()
//	sleep_until (volume_test_players (tv_player_start_spawn), 1);
	wake (cavern_obj_control);
	object_create_folder (caverns_crates);
	wake (m40_lasky_radio_contact);
//	ai_place (cav_dropoff_pelican_driver);
	object_create (pelican_dropoff_octopus_veh);
	pup_play_show (pelican_dropoff_octopus_pup);
	fade_in (0,0,0,0);
	wake (convoy_rollout);
	wake (cavern_gun_approach_vo);
	wake (dialogue_convoy_approach);
//	thread (m40_caves_vo_marines());
	thread (M40_cave_VO_mammoth_reveal());
	thread (m40_caves_tort_VO_delrio_radio());
end

script dormant cavern_obj_control()
	print ("cavern objective control is running. marines placed.");
	data_mine_set_mission_segment ("m40_cavern");
	ai_vehicle_reserve (pelican_dropoff_octopus_veh, true);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_l01", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_l02", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_l03", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_l04", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_l05", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_r01", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_r02", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_r03", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_r04", false, false);
	vehicle_set_player_interaction (pelican_dropoff_octopus_veh, "pelican_p_r05", false, false);
	print ("unit_recorder_load");
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_a);
	unit_recorder_play (main_mammoth);
	print ("unit_recorder_play_on_unit");
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	thread (m40_caves_tort_meet_palmer());
	thread (test_attach());
	thread (jetpack_profile_control());
	ai_place (marines_misc_sq);
	ai_place (marines_main_hog_01b_sq);
	ai_place (tortoise_jetpacker_01);
	ai_place (tortoise_jetpacker_02);
	pup_play_show(marines_misc_pup);	
	local long palmer_show = -1;
	ai_place (Marines_lasky);	
	sleep(1);
	ai_cannot_die (Marines_lasky, true);
	objects_physically_attach (main_mammoth, "lasky_first_position", Marines_lasky, "");
	lasky_first_show = pup_play_show (palmer_lasky_pup);
	thread (palmer_pup_breakout());
	pup_play_show (marine_ramp);
	print ("palmer pup show playing");
	thread (open_tort_doors_caverns());
	tort_bay_doors_opened = true;
	thread(cannon_lakeside_motion_new());
	object_cannot_take_damage (cannon_lakeside_new);
	print ("tort doors lowering");
	wake (cavern_chapter_title);
	sleep_until (volume_test_players (tv_cavern_01), 1);
	cavern_obj_state=10;
	print ("obj_state=10");
 	game_save_no_timeout();
// 	object_create (cavrockcrush);
	object_create (marines_main_hog_01_veh);
	object_create (marines_main_hog_02_veh);	
	wake (test_early_warthog_seating);	
	ai_vehicle_reserve (marines_main_hog_01_veh, true);
	ai_vehicle_reserve (marines_main_hog_02_veh, true);
	vehicle_set_player_interaction ((main_mammoth), "mac_d", false, false);
	sleep_until (volume_test_players (tv_don_demo), 1);
	ai_place (tort_marines);
	pup_play_show (tort_marines_pup);
	thread (tort_bipeds());

	wake (close_bay_doors_Hal);
	wake (firing_inside_mammoth_check);
	cavern_obj_state=20; 
	print ("obj_state=20");
	f_blip_flag (lasky_palmer_flag, "recon");
	sleep_until (volume_test_players (tv_palmer)
	or
	volume_test_players (tv_cavern_03)
	, 1
	);
		if
			volume_test_players (tv_palmer)
		then
			sleep (30 * 1);	
			thread (palmer_vignette_hack());
			sleep_until (player_equipped_jetpack == true);
		else
			f_unblip_flag (lasky_palmer_flag);
				if
					palmer_vignette == false
					then
					pup_stop_show (lasky_first_show);
				end
		end
	
	wake (cavern_tort_ready);
	
	sleep (30 * 1);	
	
	cs_run_command_script (Marines_lasky, lasky_safety_position);

	sleep_until (volume_test_players (tv_cavern_03), 1);
	cavern_obj_state=30; 
	print ("obj_state=30");
	
	player_done_with_opening_pups = true;
	thread (display_chapter_02());
	
	sleep_until (volume_test_players (tv_cavern_04), 1);
	cavern_obj_state=40; 
	print ("obj_state=40");
	
//	thread (pelican_dialogue_sc());
	
	sleep_until (volume_test_players (tv_cavern_05), 1);
	cavern_obj_state=50; 
	print ("obj_state=50");
	
	sleep_until (volume_test_players (tv_cavern_55), 1);
	cavern_obj_state=55; 
	print ("obj_state=55");
	
	f_unblip_object (jetpack_lower_left);		
	f_unblip_object (jetpack_lower_right);
	
	thread (tort_underneath_cleanup());
	
//	sleep_until (volume_test_players (tv_spawn_fod_crates), 1);

	sleep_until( current_zone_set_fully_active() >= DEF_S_ZONESET_GUN_FODDER(), 1 );

	object_create_folder (fodder_crates);
	object_destroy_folder (caverns_crates);

	print ("fodder crates created");

	sleep (30 * 1);	
	
	object_teleport_to_ai_point (fod_pod_01, pts_fod.tower_location);
	
// 	game_save_no_timeout();
	ai_erase (marines_misc_sq);
	sleep_forever (m40_caves_tort_meet_palmer);
	sleep_forever (m40_target_designator_callout);
//	print ("erased marines_misc_sq");
	
	sleep_until (volume_test_players (tv_cavern_06), 1);
	cavern_obj_state=60; 
	print ("obj_state=60");

	f_unblip_object (jetpack_lower_left);		
	f_unblip_object (jetpack_lower_right);	
// 	game_save_no_timeout();
end	

script static void pelican_dialogue_sc()
//	sleep_until (volume_test_object (tv_cavern_55, animated_pelican_s), 1);
//	print ("M40_gun_fodder_pelican_down");
	wake (M40_gun_fodder_pelican_down);
end

script static void palmer_pup_breakout()
	sleep_until	(player_equipped_jetpack == true)
	or
	(player_done_with_opening_pups == true);
	palmer_pup_breakout_bool = true;
end

script static void testrr()
	cs_run_command_script (Marines_lasky, lasky_safety_position);
end

script dormant firing_inside_mammoth_check()
	print ("firing_inside_mammoth_check");
	thread (action_test_reset());
	wake (test_tort_global_interior);
	print ("firing_inside_mammoth_check sleep 1");
	sleep_until (
	tort_global_interior == true
	and
	player_action_test_primary_trigger()
	);
	if
		vehicle_test_seat (marines_main_hog_01_veh, "warthog_g")
		or
		vehicle_test_seat (marines_main_hog_02_veh, "warthog_g")		
		then
		b_warthog_gun_in_mammoth = TRUE;
		print ("player definitely shooting WARTHOG TURRET inside mammoth");
		else
		b_gun_in_mammoth = TRUE;
		print ("player definitely shooting regular gun inside mammoth");
	end
	player_action_test_reset();
	sleep_s(5);	
	sleep_until (
	tort_global_interior == true
	and
	player_action_test_primary_trigger()
	);
	if
		vehicle_test_seat (marines_main_hog_01_veh, "warthog_g")
		or
		vehicle_test_seat (marines_main_hog_02_veh, "warthog_g")		
		then
		b_warthog_gun_in_mammoth = TRUE;
		print ("STAGE 2 player definitely shooting WARTHOG TURRET inside mammoth");
		else
		b_gun_in_mammoth = TRUE;
		print ("STAGE 2 player definitely shooting regular gun inside mammoth");
	end
	player_action_test_reset();
	sleep_s(5);		
	sleep_until (
	tort_global_interior == true
	and
	player_action_test_primary_trigger()
	);
	if
		vehicle_test_seat (marines_main_hog_01_veh, "warthog_g")
		or
		vehicle_test_seat (marines_main_hog_02_veh, "warthog_g")		
		then
		b_warthog_gun_in_mammoth = TRUE;
		print ("STAGE 3 player definitely shooting WARTHOG TURRET inside mammoth");
		else
		b_gun_in_mammoth = TRUE;
		print ("STAGE 3 player definitely shooting regular gun inside mammoth");
	end
	player_action_test_reset();
end

script static void action_test_reset()
	repeat
	sleep_until (
		(tort_global_interior == false
		and
		player_action_test_primary_trigger())
		or
		volume_test_players (tv_cavern_03), 1
		);
		
		player_action_test_reset();
		print ("player_action_test_resetted");
		sleep (30 * 2);	
	until (volume_test_players (tv_cavern_03), 1);
	print ("player_action_test_resetted DONE!");
end

script command_script lasky_safety_position()
	objects_detach (main_mammoth, Marines_lasky);
	cs_go_to (tort_pup_pt.lasky_rear);
	print ("LASKY ORDERED TO WALK");
	cs_face (true, mtest2.p16);
	sleep (30 * 1);
//	objects_physically_attach (main_mammoth, "2fl_rear_terminal", Marines_lasky, "");	
	print ("lasky attached");
	lasky_final_pup = pup_play_show (lasky_alt_pup);
	thread (lasky_pup_test());
	sleep (30 * 5);
	thread (lasky_disappear());
//	pup_play_show(lasky_pup);
end

script dormant test_early_warthog_seating()
	sleep_until (player_in_vehicle (marines_main_hog_01_veh)
	or
	player_in_vehicle (marines_main_hog_02_veh));
		if
		lakeside_obj_state < 10
		then
		wake (M40_marine_warthog);
		print ("player trying to drive warthog or mongoose early");
		else
		print ("player is OK to drive warthog now");
		end
end

script dormant close_bay_doors_Hal()
//	sleep_until (volume_test_players (tv_tortoise_bottom_01), 1);
	sleep_until (palmer_vignette == true
	or
	player_in_vehicle (marines_main_hog_01_veh)
	or
	player_in_vehicle (marines_main_hog_02_veh));	
	wake (M40_tortoise_enter_first_time);
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:closing", false);
	if
		tort_bay_doors_opened == TRUE
	then
		thread (close_tort_doors_caverns());
		tort_bay_doors_opened = false;
	end
end

script static void test_doors()
	object_set_physics (main_mammoth, false);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
end

script dormant convoy_rollout()
	sleep_until (volume_test_players (tv_cavern_01), 1);
	sleep_until 
	(
	cav_rollout_rdy	== true
	or
	(volume_test_players (tv_cavern_03)
	)
	, 1);
	
	if 
		(tort_bay_doors_opened == true)
	then
		thread (close_tort_doors_caverns());
		print ("player skipped ahead, manually closing tortoise bay doors");
	end
	
	if
		(player_equipped_jetpack == false)
	then
		wake (convoy_rollout_player_ahead);
	end

	if
		jetpacks_revealed == false
	then
		thread (reveal_jetpack_lower_left());
	end

	print ("tortoise prepping for roll out");
	cs_stow (tort_marines, false);
	cs_enable_moving (tort_marines, true);
	wake (f_dialog_m40_del_rio_radio);
	sleep (30 * 4);
	wake (m40_caves_tort_VO_breakout);
	sleep (30 * 2);
 	print ("tortoise objective requirements met");
	unit_recorder_pause_smooth (main_mammoth, false, 12);
	tort_stopped = FALSE;
	
	// this music cue needs to trigger when the mammoth first start moving
	thread(f_music_m40_v13_mammoth_start());
	
	thread (mam_dust_on());
// 	wake (cav_rock_crush);
	thread (camera_shake_6sleep());
	sleep_forever (firing_inside_mammoth_check);
//	sleep (30 * 14);
//	unit_recorder_set_playback_rate_smooth (main_mammoth, 1.5, 3);	
// 	print ("TORTOISE AT 1.5 SPEED");
//	sleep (30 * 4);	
//	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 3);	
// 	print ("TORTOISE AT .7 SPEED");
//	sleep (30 * 2);
	thread (new_tort_caverns_speed_test());
	if
		player_left_caverns_early == FALSE
	then
		wake (tortoise_main_cs_on_recording_v2);
 	end
 	wake (f_fodder_main);
 	print ("tortoise objectives set");
 	game_save_no_timeout();
end

script static void test_attach()
	objects_attach (main_mammoth,  "device_button_03", tortoise_device_button_01, "");
	objects_attach (main_mammoth,  "device_button_04", tortoise_device_button_02, "");
	objects_attach (main_mammoth,  "device_button_05", tortoise_device_button_03, "");
	objects_attach (main_mammoth,  "device_button_06", tortoise_device_button_04, "");
	objects_attach (main_mammoth,  "device_button_07", tortoise_device_button_05, "");
	objects_attach (main_mammoth,  "device_button_attachment_01", tort_button_01_attachment, "");
	objects_attach (main_mammoth,  "device_button_attachment_02", tort_button_02_attachment, "");
	objects_attach (main_mammoth,  "device_button_attachment_03", tort_button_03_attachment, "");
	objects_attach (main_mammoth,  "device_button_attachment_04", tort_button_04_attachment, "");
	objects_attach (main_mammoth,  "crate_bottom_jetpack_left", jetpack_lower_left_empty, "");
	objects_attach (main_mammoth,  "crate_bottom_jetpack_right", jetpack_lower_right_empty, "");
end

script static void palmer_vignette_hack()
	f_unblip_flag (lasky_palmer_flag);
	palmer_vignette = true;
	print ("PALMER LASKY VIGNETTE STARTING");
	f_unblip_flag (lasky_palmer_flag);
	sleep_s (13);
	thread (display_chapter_02a());
	sleep_s (2);
	thread (reveal_jetpack_lower_left());
	print ("palmer_vignette_hack triggered jetpack blip");
end

script static void jetpack_profile_control()
	sleep_until (
	unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player3, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment));
	player_set_profile (jetpack_profile);
	print ("at least one player picked up the jetpack, so setting the jetpack profile for all");
end

script static void lasky_disappear()
	sleep_until (not (objects_can_see_object (player0, marines_lasky.lasky, 60))
	and
	not (objects_can_see_object (player1, marines_lasky.lasky, 60))
	and
	not (objects_can_see_object (player2, marines_lasky.lasky, 60))
	and
	not (objects_can_see_object (player3, marines_lasky.lasky, 60))
	, 1);
	ai_erase (marines_lasky.lasky);
end

script static void unblip_jetpack_by_singles_1()
	sleep_until (objects_distance_to_object (jetpack_left_01, jetpack_lower_left) > .2
	and
	objects_distance_to_object (jetpack_left_02, jetpack_lower_left) > .2);

	f_unblip_object (jetpack_lower_left);
end

script static void unblip_jetpack_by_singles_2()
	sleep_until (objects_distance_to_object (jetpack_right_01, jetpack_lower_right) > .2
	and
	objects_distance_to_object (jetpack_right_02, jetpack_lower_right) > .2);

	f_unblip_object (jetpack_lower_right);
end

script static void attach_jetpacks_to_crate()
//		sleep(15);

		object_create (jetpack_left_01);
		object_create (jetpack_left_02);
		object_create (jetpack_right_01);
		object_create (jetpack_right_02);
			
		objects_attach (jetpack_lower_left,  "mkr_jetpack1", jetpack_left_01, ""); 
		objects_attach (jetpack_lower_left,  "mkr_jetpack2", jetpack_left_02, ""); 	
		objects_attach (jetpack_lower_right,  "mkr_jetpack1", jetpack_right_01, ""); 	
		objects_attach (jetpack_lower_right,  "mkr_jetpack2", jetpack_right_02, ""); 
end


script static void reveal_jetpack_lower_left()
	if
		jetpacks_revealed == false
	then
		jetpacks_revealed = true;
		print ("jetpackz revealed equals true");

		thread (reveal_jetpack_lower_right());
		
		object_create (jetpack_lower_left);
		object_destroy (jetpack_lower_left_empty);
		objects_attach (main_mammoth,  "crate_bottom_jetpack_left", jetpack_lower_left, "");
			
		sleep_s (2);
	
		thread (attach_jetpacks_to_crate());

		jetpack_lower_left->open_default();

		f_blip_object (jetpack_lower_right, "recon");
		f_blip_object (jetpack_lower_left, "recon");
		
		thread (unblip_jetpack_by_singles_1());
		thread (unblip_jetpack_by_singles_2());

		if 
			game_coop_player_count() == 1
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or		
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 2
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			game_coop_player_count() < 2
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 3
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			game_coop_player_count() < 3
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 4
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player3, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			game_coop_player_count() < 4
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if
			not (volume_test_players (tv_cavern_03))
		then
			thread (display_chapter_02a_complete());
		end
		
		f_unblip_object (jetpack_lower_left);		
		f_unblip_object (jetpack_lower_right);
		
		player_equipped_jetpack = true;
	
		object_create (garbage_btn_01);
	 	thread (garbage_btn_01_sc());
	 	print ("dmmode");
	 	
	end
end

script static void reveal_jetpack_lower_right()

		object_create (jetpack_lower_right);
		object_destroy (jetpack_lower_right_empty);
		objects_attach (main_mammoth,  "crate_bottom_jetpack_right", jetpack_lower_right, "");
		
		sleep_s (1);
		
		jetpack_lower_right->open_default();
		print ("jetpackz revealed");
			
		if 
			game_coop_player_count() == 1
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 2
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 3
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
		if 
			game_coop_player_count() == 4
		then
			sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
			and
			unit_has_equipment (player3, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
		or
			volume_test_players (tv_cavern_03), 1);
		end
		
end

script dormant convoy_rollout_player_ahead()
	if
		unit_in_vehicle (player0)
		or
		unit_in_vehicle (player1)
		or
		unit_in_vehicle (player2)
		or
		unit_in_vehicle (player3)
	then
		print ("Player leaving caverns IN WARTHOG without being equipped");	
		player_left_caverns_early = true;

		cs_stow (tort_marines, false);
		cs_enable_moving (tort_marines, true);
		unit_recorder_pause (main_mammoth, false);
		tort_stopped = FALSE;	
		thread (mam_dust_on());
		sleep_forever (firing_inside_mammoth_check);
		wake (tortoise_main_cs_on_recording_v2);
		unit_recorder_set_playback_rate_smooth (main_mammoth, 2.1, 2);	
		print ("TORT SPEED = 2.1");
	 	wake (f_fodder_main);		
		f_unblip_object (jetpack_lower_left);		
		f_unblip_object (jetpack_lower_right);
//	 	game_save_no_timeout();
	 	
 	else
 		print ("Player leaving caverns on foot without being equipped");
		cs_stow (tort_marines, false);
		cs_enable_moving (tort_marines, true);
		unit_recorder_pause_smooth (main_mammoth, false, 5);
		tort_stopped = FALSE;	
		thread (mam_dust_on());
		sleep_forever (firing_inside_mammoth_check);
		wake (tortoise_main_cs_on_recording_v2);
	 	wake (f_fodder_main);		
		f_unblip_object (jetpack_lower_left);		
		f_unblip_object (jetpack_lower_right);
//	 	game_save_no_timeout(); 	
	end	
end

script dormant cavern_tort_ready()
//	sleep (30 * 5);
	print ("tort starting rollout count from here, needs three seconds");
	static short player_in_tort_for_awhile = 0;
	static real num_seconds = 3;
	repeat 
		if (volume_test_players (tv_tortoise_top_01) == 1
		or
		volume_test_players (tv_tortoise_middle_01) == 1
		or
		volume_test_players (tv_tortoise_bottom_01) == 1
		) then
			player_in_tort_for_awhile = player_in_tort_for_awhile + 1;
		end
		until (player_in_tort_for_awhile == (30 * num_seconds), 1);
	print ("player was in tort for awhile");
	cav_rollout_rdy	= true;
end

script dormant cav_rock_crush()
	sleep_until (volume_test_object (tv_rock_crush, main_mammoth), 1);
	thread (fx_pup());
end

script static void fx_pup()
	pup_play_show ("rock_crush_pup");
	print ("ROCK PUP PLAYED"); 
	thread (camera_shake_now_short());
end

script static void fx_solo()
//	effect_new_at_ai_point (environments\solo\m40_invasion\fx\rockwall_burst\rockwall_burst.effect, convoy_tracking_pt.p22); 
	print ("ROCK FX"); 
end

script static void test_rock_crush()
	object_create (cavrockcrush);
//	effect_new_at_ai_point (environments\solo\m40_invasion\fx\rockwall_burst\rockwall_burst.effect, convoy_tracking_pt.p22); 
	sleep( 30 * 6 );
	device_set_overlay_track( cavrockcrush, 'any:rockcrush' );
	device_animate_overlay( cavrockcrush, 1.4, 1.4, 0, 0 );
end

//--------------------cavern command scripts-------------------

script command_script pelican_flyoff_01_cs()
	cs_vehicle_speed (.7);
	cs_fly_by (pelican_flyoff_01_pt.p0);
	cs_fly_by (pelican_flyoff_01_pt.p1); 
	cs_fly_by (pelican_flyoff_01_pt.p2);
	cs_fly_by (pelican_flyoff_01_pt.p3);
	print ("pelican_flyoff_01_pt.p3");
	cs_fly_by (pelican_flyoff_01_pt.p4);
	print ("pelican_flyoff_01_pt.p4");
	ai_erase (pelican_flyoff_sq_01);
	print ("erased guy1");
end

//script command_script pelican_flyoff_02_cs()
//	cs_vehicle_speed (.5);
//	cs_fly_by (pelican_flyoff_01_pt.p5);
//	cs_fly_by (pelican_flyoff_01_pt.p6); 
//	cs_fly_by (pelican_flyoff_01_pt.p7);
//	ai_erase (pelican_flyoff_sq.guy2);
//end

script command_script pelican_flyoff_03_cs()
	cs_vehicle_speed (.7);
	cs_fly_by (pelican_flyoff_01_pt.p2);
	cs_fly_by (pelican_flyoff_01_pt.p3);
	cs_fly_by (pelican_flyoff_01_pt.p4);
	ai_erase (pelican_flyoff_sq_02);
end

script dormant cavern_chapter_title()
	sleep_until (volume_test_players (tv_mammoth_chapter), 1);
//	sleep (30 * 6);
	cinematic_show_letterbox (TRUE);
	ai_place (pelican_flyoff_sq_02);
//	ai_place (pelican_flyoff_sq.guy3);
	sleep (30 * 1);
//	thread(storyblurb_display(leadin_title_cav, 8, FALSE, FALSE));
	f_chapter_title (leadin_title_cav);
	sleep (30 * 1);
	ai_place (pelican_flyoff_sq_01);
	sleep (30 * 5);
	cinematic_show_letterbox (FALSE);
end

script static void f_chapter_title (cutscene_title chapter_title)
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (chapter_title);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);     
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
end



//script command_script cavern_marines_enter_hog01()
//	cs_go_to_vehicle (marines_main_hog_01_veh);
//end
//
//script command_script cavern_marines_enter_hog02()
//	cs_go_to_vehicle (marines_main_hog_02_veh);
//end

script static void tort_dr()
	
	print ("TORT DR.!");
	
	kill_volume_disable (kill_soft_lakeside_backtrack);
	kill_volume_disable (kill_soft_post_lakeside);
	kill_volume_disable (kill_soft_post_chopper);

//	ai_place (Marines_lasky);	
//	ai_cannot_die (Marines_lasky, true);
////	objects_physically_attach (main_mammoth, "lasky_first_position", Marines_lasky, "");
//	lasky_first_show = pup_play_show (palmer_lasky_pup);	
	
		
//	object_create (main_mammoth);
//	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p10);
	
	sleep (1);
		
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_a);
	unit_recorder_play (main_mammoth);
//	unit_recorder_set_time_position (main_mammoth, 112);
	unit_recorder_pause (main_mammoth, true);

//	sleep_s (3);
//	
//	thread (tort_bipeds());
		
//	thread (open_tort_doors_chopper());
//	sleep_s (12);	
//	thread (close_tort_doors_chopper());
end

script static void lask_dr()
	
	print ("TORT DR.!");
	
//	kill_volume_disable (kill_soft_lakeside_backtrack);
//	kill_volume_disable (kill_soft_post_lakeside);
//	kill_volume_disable (kill_soft_post_chopper);

	ai_place (Marines_lasky);	
	ai_cannot_die (Marines_lasky, true);
//	objects_physically_attach (main_mammoth, "lasky_first_position", Marines_lasky, "");
	lasky_first_show = pup_play_show (palmer_lasky_pup);	
	
//	objects_physically_attach (main_mammoth, "lasky_first_position", Marines_lasky, "");
	
//	sleep_s (8);	
	
//	objects_detach (main_mammoth, marines_lasky);
//	cs_run_command_script (Marines_lasky, lasky_safety_position);
	
//	palmer_vignette = true;
//	palmer_pup_breakout_bool = true;
	
		
//	object_create (main_mammoth);
//	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p10);
	
//	sleep (1);
//	
//	palmer_vignette = true;
//	palmer_pup_breakout_bool = true;
//		
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_a);
//	unit_recorder_play (main_mammoth);
////	unit_recorder_set_time_position (main_mammoth, 112);
//	unit_recorder_pause (main_mammoth, true);

//	sleep_s (3);
//	
//	thread (tort_bipeds());
		
//	thread (open_tort_doors_chopper());
//	sleep_s (12);	
//	thread (close_tort_doors_chopper());
end

script dormant tortoise_main_cs_on_recording_v2()
	print ("Tortoise running complex recorded scripts");

	sleep_until (volume_test_object (tv_cavern_04, main_mammoth));
	
	TDT_dist = 20;
	thread (tort_stop_check_player_location());

	sleep_s (1);
	
	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cavern_obj_state < 40)
			
	then
	
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = All players are behind, Tortoise is stopping");
				
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cavern_obj_state > 39, 1);
		
		print ("TDT = Tort Distance Test = At least one player is caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end

	sleep_until (volume_test_object (tv_cavern_05, main_mammoth));

	TDT_dist = 20;
	thread (tort_stop_check_player_location());

	sleep_s (1);
	
	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cavern_obj_state < 50)
		
	then
	
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cavern_obj_state > 49, 1);

		print ("tv_cavern_05: Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
	sleep_until (volume_test_object (tv_cavern_06, main_mammoth));		

	TDT_dist = 20;
	thread (tort_stop_check_player_location());

	sleep_s (1);
	
	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cavern_obj_state < 60)
		
	then
	
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("tv_cavern_06: Player is behind, Tortoise is stopping");
		
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cavern_obj_state > 59, 1);
		
		print ("tv_cavern_06: Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
end

script static void garbage_btn_01_sc()
	sleep_until (device_get_position(garbage_btn_01) != 0, 1);
	print ("dmaj2");
	object_create (garbage_btn_02);
	thread (garbage_btn_02_sc());
end

script static void garbage_btn_02_sc()
	sleep_until (device_get_position(garbage_btn_02) != 0, 1);
	print ("done 3");
	object_destroy (marines_main_hog_01_veh);
	object_destroy (marines_main_hog_02_veh);
	sleep (1);
	object_create (tort_hog_01_g);
	object_create (tort_hog_02_g);
	
	dm_mode1 = true;
end

////------------------CAVERN VO--------------------------//
script dormant dialogue_convoy_approach()
	sleep_until (volume_test_players (tv_cavern_dialogue_start), 1);
	f_music_m40_drama_a_start();
	NotifyLevel("Music Drama A Start");
end

script dormant cavern_gun_approach_vo()
	sleep_until (volume_test_players (tv_cavern_pelican_dies), 1);
	f_music_m40_drama_a_stop();
	f_music_m40_battle_a_start();
	NotifyLevel("Music Battle A Start");
end

// =================================================================================================
// =================================================================================================
// LAKESIDE
// =================================================================================================
// =================================================================================================

script dormant f_lakeside_enc() 
	sleep_until (volume_test_players (tv_fod_objcon_37), 1);
	
	wake (M40_mammoth_in_range);
	
	thread(lakeside_tar_pit_damaging());
	
	data_mine_set_mission_segment ("m40_lakeside");

	thread (fodder_ai_kill());

	effects_perf_armageddon = 1;

	object_teleport_to_ai_point (lakeside_pod, lakeside_teleport_pt.lakeside_pod_location);

	sleep(1);
	
	ai_place (front_jackal_sq); 
	ai_place (rock_sq); 
	ai_place (high_cave_sq); 
	ai_place (high_bridge_sq);
	ai_place (mid_rock_sq);
	ai_place (front_barricade_guard);
	ai_place (front_barricade_guard_rear);
	ai_place (front_grunts_sq);
	
	ai_prefer_target_team (lakeside_wraith_01, player);

	thread(f_mus_m40_e01_finish()); 
	
	wake (pelican_marines_fight);
	wake (M40_fodder_armor_appear);
	wake (tort_top_lakeside_true);
	wake (rock_sq_bonus_spawn);
//	wake (lakeside_fill_bonus);
	wake (lakeside_fill_bonus_2);
	wake (lakeside_sq_bonus);
	
	if
		game_coop_player_count() > 2	
	or
		game_difficulty_get_real() == legendary
	then
		ai_erase (front_barricade_guard_rear.guy1);
		ai_erase (rock_sq.guy1);
		ai_place (lakeside_wraith_03);
	end
		
	sleep (30 * 1);

	object_create (lakeside_cov_barrier_01);
	object_create (lakeside_cov_crate_01);
	object_create (lakeside_cov_crate_02);
	
	sleep_until (volume_test_players (tv_lakeside_02), 1);

	game_save_no_timeout();
	
	first_time_charged = FALSE;
	td_ready_for_mission_use = TRUE;
		
	garbage_collecting = true;
	thread (garbage_collect_me());	

	ai_place (ghosts_initial_1); 
	ai_place (lakeside_phantom_intro);

	sleep (30 * 2);

	wake (lakeside_ghost_backup_2_spawn);
	wake (prechopper_shield_barrier_spawn);

	wake (lakeside_obj_con);

	ai_allegiance (player, human);
	
	sleep_until (volume_test_players (tv_lakeside_03), 1); 
	thread(f_mus_m40_e02_begin()); 
	
	sleep_until (volume_test_players (tv_lakeside_035), 1); 
	wake (lakeside_tort_catchup);
//	wake (lakeside_objective_prompt);

	sleep_until (lakeside_obj_state > 29);	

	sleep (30 * 3);
	
	thread(f_mus_m40_e02_finish());
	sleep_forever (lakeside_hog_blip_timer);
	sleep (30 * 5);
	wake (lakeside_end_marine_refill);
	
  object_create (prechopper_ant_01);
  object_create (prechopper_space_crate_01);
  object_create (prechopper_space_crate_02);
  object_create (prechopper_cov_barrier_01);
  object_create (prechopper_cov_barrier_02);
  wake (cliffside_enc_main);
 	wake (cliffside_obj_states);
  thread (M40_chopper_lich_warning());

	sleep_until (volume_test_players (tv_lakeside_04), 1);

	object_damage_damage_section (downed_pelican, "hull_front", 2000);
	
	garbage_collecting = false;

	object_destroy_folder( fodder_crates );
	object_destroy (lakeside_crate_01);
	object_destroy (lakeside_crate_02);
	print ("destroyed a ton of old stuff");
	
	effects_perf_armageddon = 0;

end

script dormant lakeside_obj_con()

	lakeside_obj_state = 10; 
	print ("lakeside_obj_state = 10");

	sleep (30 * 2);
	
	thread (lakeside_player_leave_dialogue());

	sleep_until (lakeside_cannon_alive == FALSE
	or
	ai_living_count (lakeside_phantom_intro) < 1
	or
	ai_living_count (ghosts_initial_1) > 1);

	sleep_until (ai_living_count (ghosts_initial_1) < 1
	or
	lakeside_cannon_alive == FALSE
	);

	lakeside_obj_state = 20; 
	print ("lakeside_obj_state = 20");

	game_save_no_timeout();

	sleep (30 * 4);

	sleep_until (lakeside_cannon_alive == FALSE
	or
	ai_living_count (lakeside_phantom_05) < 1
	or
	ai_living_count (lakeside_backup_ghosts_2) > 1);

	lakeside_obj_state = 22; 
	print ("lakeside_obj_state = 22");

	sleep (30 * 3);

//	game_save_no_timeout();
//
//	sleep_until (ai_living_count (lakeside_wraith_01) > 0);
//
//	sleep_until (ai_living_count (lakeside_wraith_01) < 1
//	and
//	ai_living_count (lakeside_ghosts) < 1
//	);
//	lakeside_obj_state = 25; 
//	print ("lakeside_obj_state = 25");

	game_save_no_timeout();
	
	sleep_until (lakeside_cannon_alive == FALSE);
	lakeside_obj_state = 30; 
	print ("lakeside_obj_state = 30");
	
	wake (f_dialog_m40_tutorial_3);
	
	sleep_until (
	ai_living_count (lakeside_ghosts) < 1
	and
	ai_living_count (lakeside_wraith_01) < 1	
	and	
	ai_living_count (lakeside_wraith_03) < 1
	or
	volume_test_players (tv_lakeside_04)
	);
	
//	if
//		volume_test_players (tv_lakeside_entire)
//	then
//		wake (f_dialog_m40_lakeside_end_nudge);
//	end
	
	sleep_until (volume_test_players (tv_lakeside_04), 1);
	print ("obj state 40");
	lakeside_obj_state = 40; 

	ai_set_objective (marine_convoy, cliffside_marines_obj);
	ai_set_objective (marine_convoy_02, cliffside_marines_obj);
	print ("Lakeside AI handed off to Cliffside");
	
	object_create_folder (cliffside_crates);
	object_create (cliffside_ghost_01);
	object_destroy_folder (lakeside_crates);

end

script static void lakeside_player_leave_dialogue()
	sleep_until (volume_test_players (kill_soft_post_lakeside)
	or
	volume_test_players (tv_spawn_tort)
	or
	lakeside_cannon_alive == false);
	if 
		lakeside_cannon_alive == true
	then
		thread (m40_palmer_off_map_nudge());
	end
end

script dormant lakeside_objective_prompt()
	sleep (30 * 5);
	thread (display_chapter_03b());
	//sleep (30 * 5);
	//this happens in the dialogue script so we can get the timing right
	//f_blip_object (m40_lakeside_target_laser, "recover");
	sleep (30 * 4);
	sleep_until (ai_living_count (lakeside_tort_assault_2_grp) < 2
	or
	player_in_lakeside_enc == TRUE
	);	

	thread (award_td_to_player());

	sleep_until (player_equipped_locator == TRUE, 1);
	
	thread (check_td_user_valid_state());

	f_unblip_object (m40_lakeside_target_laser);
	thread (m40_target_designator_main());
	thread (lakeside_cannon_swap());
	object_can_take_damage (cannon_lakeside_new);
	sleep(1);
	thread (target_designator_unlock());
	sleep(5);	
	ai_disregard(ai_actors(chop_lich), TRUE);
	if
		lakeside_phantom_hanging_out == true
		and
		ai_living_count (lakeside_phantom_intro) > 0
	then
		sleep (30 * 1);	
		
		wake (f_dialog_40_target_those_phantoms);

		sleep (30 * 2);			
	
		thread (display_chapter_03g());
		
		sleep (30 * 2);
		
		f_blip_ai (lakeside_phantom_intro.driver, "neutralize");
		
		sleep_until (ai_living_count (lakeside_phantom_intro) < 1
		or
		lakeside_cannon_alive == FALSE
		);
		sleep (30 * 2);
		thread (display_chapter_03g_complete());
		f_unblip_ai (lakeside_phantom_intro);
		sleep (30 * 5);
	end

	thread (area_clear_diag());

	if
		lakeside_cannon_alive == TRUE
	then

		f_unblip_ai (lakeside_phantom_intro);
		f_blip_object (cannon_lakeside_new, "neutralize");
		thread (display_chapter_03c());
		sleep_until (lakeside_cannon_alive == FALSE);
		thread (display_chapter_03c_complete());
	end

	if
		volume_test_object (tv_lakeside_combat_area, marines_main_lakeside_hog_01)
	then
		ai_vehicle_enter (pelican_marines.guy1, marines_main_lakeside_hog_01);
		ai_vehicle_enter (pelican_marines.guy4, marines_main_lakeside_hog_01);
		ai_vehicle_enter (pelican_marines.guy5, marines_main_lakeside_hog_01);
		ai_vehicle_enter (pelican_marines_2.guy1, marines_main_lakeside_hog_01);
	end

	if
		volume_test_object (tv_lakeside_combat_area, marines_main_hog_01_veh)
	then
		ai_vehicle_enter (pelican_marines.guy1, marines_main_hog_01_veh);
		ai_vehicle_enter (pelican_marines.guy4, marines_main_hog_01_veh);
		ai_vehicle_enter (pelican_marines.guy5, marines_main_hog_01_veh);
		ai_vehicle_enter (pelican_marines_2.guy1, marines_main_hog_01_veh);
	end
	
	if
		volume_test_object (tv_lakeside_combat_area, marines_main_hog_02_veh)
	then
		ai_vehicle_enter (pelican_marines.guy1, marines_main_hog_02_veh);
		ai_vehicle_enter (pelican_marines.guy4, marines_main_hog_02_veh);
		ai_vehicle_enter (pelican_marines.guy5, marines_main_hog_02_veh);
		ai_vehicle_enter (pelican_marines_2.guy1, marines_main_hog_02_veh);
	end
	
end

script static void area_clear_diag()
	sleep_until (
		ai_living_count (lakeside_wraith_01) < 1
		and
		ai_living_count (lakeside_wraith_03) < 1
		and
		ai_living_count (lakeside_ghosts) < 1);
	if
		lakeside_cannon_alive == TRUE
	then
		wake (M40_lakeside_all_clear);
	end
end

script static void award_td_to_player()

	sleep_until (
	
	(not (unit_in_vehicle (player0))
	and
	objects_distance_to_object (player0, m40_lakeside_target_laser) < 1)
	
	or
	
	(not (unit_in_vehicle (player1))
	and
	player_valid (player1)
	and
	objects_distance_to_object (player1, m40_lakeside_target_laser) < 1)
	
	or
	
	(not (unit_in_vehicle (player2))
	and
	player_valid (player2)
	and
	objects_distance_to_object (player2, m40_lakeside_target_laser) < 1)
	
	or
	
	(not (unit_in_vehicle (player3))
	and
	player_valid (player3)
	and
	objects_distance_to_object (player3, m40_lakeside_target_laser) < 1)
		
	, 1);

	print ("!!!!!!!!!!!AWARDING TD!!!!!!!!!!");
	
	if
		objects_distance_to_object (player0, m40_lakeside_target_laser) < 1
	then
		unit_add_weapon(player0, m40_lakeside_target_laser, 0);
		player_equipped_locator = TRUE;
		td_user = player0;
		
		thread (start_td_HUD_p0());

		print ("player0 is TD user");
			
	elseif
		objects_distance_to_object (player1, m40_lakeside_target_laser) < 1
	then
		unit_add_weapon(player1, m40_lakeside_target_laser, 0);
		player_equipped_locator = TRUE;	
		td_user = player1;

		thread (start_td_HUD_p1());

		print ("player1 is TD user");
					
	elseif
		objects_distance_to_object (player2, m40_lakeside_target_laser) < 1
	then
		unit_add_weapon(player2, m40_lakeside_target_laser, 0);
		player_equipped_locator = TRUE;
		td_user = player2;

		thread (start_td_HUD_p2());

		print ("player2 is TD user");
						
	elseif
		objects_distance_to_object (player3, m40_lakeside_target_laser) < 1
	then
		unit_add_weapon(player3, m40_lakeside_target_laser, 0);
		player_equipped_locator = TRUE;
		td_user = player3;

		thread (start_td_HUD_p3());

		print ("player3 is TD user");
		
	end

end

script static void start_td_HUD_p0()
		sleep (30 * 1);

		weapon_target_designator_show_hud (player0);

		chud_show_screen_training (player0, training_m40_td);
	
		sleep (30 * 4);
	
		chud_show_screen_training (player0, "");

end

script static void start_td_HUD_p1()
		sleep (30 * 1);

		weapon_target_designator_show_hud (player1);
		
		chud_show_screen_training (player1, training_m40_td);
	
		sleep (30 * 4);
	
		chud_show_screen_training (player1, "");
		
end

script static void start_td_HUD_p2()
		sleep (30 * 1);

		weapon_target_designator_show_hud (player2);

		chud_show_screen_training (player2, training_m40_td);
	
		sleep (30 * 4);
	
		chud_show_screen_training (player2, "");
		
end

script static void start_td_HUD_p3()
		sleep (30 * 1);

		weapon_target_designator_show_hud (player3);

		chud_show_screen_training (player3, training_m40_td);
	
		sleep (30 * 4);
	
		chud_show_screen_training (player3, "");
		
end	

script static void check_td_user_valid_state()
	repeat

	if
		game_coop_player_count() == 1
	then
		sleep_until (1 == 0);
	end

	if
		game_coop_player_count() == 2
	then
		sleep_until (game_coop_player_count() < 2);
	end
	
	if
		game_coop_player_count() == 3
	then
		sleep_until (game_coop_player_count() < 3);
	end

	if
		game_coop_player_count() == 4
	then
		sleep_until (game_coop_player_count() < 4);
	end
		
	if
		not (player_valid(td_user))
	then
		print ("Need a new TD user");	
		unit_add_weapon(player_get_first_valid(), m40_lakeside_target_laser, 0);
		weapon_target_designator_show_hud (player_get_first_valid());
		td_user = player_get_first_valid();
		print ("Found a new TD user, printing at next line");
		inspect (td_user);
	else
		print ("td user still valid");
	end

	until (td_disabled == true, 1);
end

script static void f_detach_lasky()
	objects_detach(main_mammoth,Marines_lasky);
	cs_run_command_script (Marines_lasky, lasky_safety_position);
end


script static void display_jetpack_tut()
	if
		volume_test_object (tv_lich_entire, player0)
		or
		volume_test_object (tv_lich_entire, player1)
		or
		volume_test_object (tv_lich_entire, player2)
		or
		volume_test_object (tv_lich_entire, player3)
	then
		wake (f_dialog_m40_lich_going_to_blow);
	end

	if 
		volume_test_object (tv_lich_entire, player0)
	then
		chud_show_screen_training (player0, equipment_jet_pack_use);
		sleep (30 * 6);
		chud_show_screen_training (player0, "");	
	end

	if 
		volume_test_object (tv_lich_entire, player1)
	then
		chud_show_screen_training (player1, equipment_jet_pack_use);
		sleep (30 * 6);
		chud_show_screen_training (player1, "");	
	end
	
	if 
		volume_test_object (tv_lich_entire, player2)
	then
		chud_show_screen_training (player2, equipment_jet_pack_use);
		sleep (30 * 6);
		chud_show_screen_training (player2, "");	
	end
	
	if 
		volume_test_object (tv_lich_entire, player3)
	then
		chud_show_screen_training (player3, equipment_jet_pack_use);
		sleep (30 * 6);
		chud_show_screen_training (player3, "");	
	end

end

script dormant lakeside_ghost_backup_2_spawn()
	sleep (30 * 5);
	sleep_until	(ai_living_count (ghosts_initial_1) < 1
	and
	ai_living_count (lakeside_infantry) < 6
	);

	wake (lakeside_wraith_backup_spawn);
	wake (lakeside_backup_ghosts_3_spawn);

	ai_place (lakeside_phantom_07);
	if
		game_coop_player_count() > 2
	or
		game_difficulty_get_real() == legendary
	then
		ai_place (lakeside_backup_ghosts_2);
	end
	
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_07.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (lakeside_backup_ghosts_2.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_07.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (lakeside_backup_ghosts_2.driver2));

	print ("!!!!LAKESIDE BACKUP GHOSTS INCOMING!!!!"); 

	game_save_no_timeout();
end

script dormant lakeside_backup_ghosts_3_spawn()
	sleep_until	(ai_living_count (lakeside_ghosts) < 1);

	lakeside_backup_ghosts_3_bool = true;
	
	ai_place (lakeside_backup_ghosts_3); 
	ai_place (lakeside_phantom_intro);

end

script dormant lakeside_wraith_backup_spawn()
//	sleep_until (ai_living_count (lakeside_backup_ghosts_2) < 2
//	and
//	player_in_lakeside_enc ==  TRUE);
	sleep (30 * 23);

	sleep_until	(ai_living_count (lakeside_wraith_03) < 1);
	
	ai_place (lakeside_wraith_01);
	ai_place (lakeside_phantom_01);

	sleep (30 * 10);
	
	lakeside_enc_ending = true;
end

script dormant rock_sq_bonus_spawn()
	sleep (30 * 3);
	wake (rock_sq_bonus_spawn_too_late);
	sleep_until	(ai_living_count (lakeside_phantom_intro) < 1);
	sleep_until (not (volume_test_players_all_lookat (tv_lakeside_rear_rock, 3000, 40)));
	sleep_until	(player_in_lakeside_enc == false);
	ai_place (rock_sq.guy1);
	print ("rock_sq bonus guy made it in"); 
end

script dormant lakeside_sq_bonus()
	sleep (30 * 3);
//	wake (rock_sq_bonus_spawn_too_late);
	sleep_until	(ai_living_count (lakeside_phantom_intro) < 1);
	sleep_until (not (volume_test_players_all_lookat (tv_lakeside_rear_rock, 3000, 40)));
	sleep_until	(player_in_lakeside_enc == false);
	ai_place (lakeside_sq);
	print ("rock_sq bonus guy made it in"); 
end

script dormant rock_sq_bonus_spawn_too_late()
	sleep_until (volume_test_players (tv_lakeside_combat_area), 1);
	player_in_lakeside_enc = true;
end

script dormant lakeside_fill_bonus()
	sleep_until	(ai_living_count (lakeside_infantry) < 3
	and
	(ai_living_count (lakeside_phantom_01) < 1
	or
	ai_living_count (lakeside_phantom_intro) < 1)
	);
	sleep_until (not (volume_test_players_all_lookat (tv_lakeside_fill_01_sq, 3000, 40)));
	if
		(not (volume_test_players (tv_lakeside_combat_area)))
	then
		ai_place (lakeside_fill_01_sq);
		print ("lakeside_fill_bonus made it in");	
	else
	print ("lakeside_fill_bonus didn't make it in");
	end
	sleep (30 * 10);	
	wake (lakeside_fill_bonus_2);
end

script dormant lakeside_fill_bonus_2()
	sleep_until	(ai_living_count (lakeside_infantry) < 4
//	and
//	ai_living_count (ghosts_initial_1) < 1
//	and
//	lakeside_obj_state < 25
	);
	if
		lakeside_enc_ending != TRUE
	then
		ai_place (lakeside_phantom_04);
		print ("LAKESIDE INFANTRY PHANTOM INCOMING");
		wake (lakeside_fill_bonus_3);
	else
		print ("LAKESIDE INFANTRY PHANTOM NOT COMING. Encounter is almost over");
	end
end

script dormant lakeside_fill_bonus_3()
	sleep (30 * 30);
	sleep_until	(ai_living_count (lakeside_infantry) < 5
	and
	ai_living_count (ghosts_initial_1) < 1
	);
	if
		lakeside_enc_ending != TRUE
		and
		ai_living_count (lakeside_phantom_04) < 1
	then
		ai_place (lakeside_phantom_06);
		print ("LAKESIDE INFANTRY PHANTOM 2 INCOMING");
	else
		print ("LAKESIDE INFANTRY PHANTOM 2 NOT COMING. Encounter is almost over");
	end
end

script dormant lakeside_ins_1_marines_spawn()
	sleep (30 * 15);
	ai_place (lakeside_ins_1_marines);
	ai_vehicle_enter_immediate (lakeside_ins_1_marines.guy1, lakeside_insertion_hog_01, "warthog_d"); 
	ai_vehicle_enter_immediate (lakeside_ins_1_marines.guy2, lakeside_insertion_hog_01, "warthog_g");
end

script dormant pelican_marines_fight()
	ai_place (pelican_marines);
//	ai_place (pelican_marines_2);
//	pup_play_show ("lakeside_wounded_marine_pup" );
	sleep (30 * 1);
	unit_only_takes_damage_from_players_team (ai_get_unit (pelican_marines.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (pelican_marines_2.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy3), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy4), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lakeside_sq.guy1), true);
	sleep_until (volume_test_players (tv_near_marines), 1);	
	sleep (30 * 3);

	unit_only_takes_damage_from_players_team (ai_get_unit (pelican_marines.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (pelican_marines_2.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy3), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (rock_sq.guy4), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lakeside_sq.guy1), false);
	ai_renew (pelican_marines);
	ai_renew (pelican_marines_2);
end

script dormant pelican_marines_airlift_sc()
	if (ai_living_count (pelican_marines) > 0
	and
	(not (unit_in_vehicle (pelican_marines.guy1))
	or
	not (unit_in_vehicle (pelican_marines_2.guy1))))
	then
	ai_place (lakeside_pelican_airlift_sq);
	print ("Marines getting airlifted out");
	else
	print ("Marines don't need airlift");
	end
end

script static void lakeside_tar_pit_damaging()
	f_m40_damage_volume_players (tv_lakeside_tar_main_path, 20, 1, 18);
end

script dormant lakeside_tort_ready()
	print ("tort starting rollout count from here, needs eight seconds");
	static short player_in_tort_for_awhile = 0;
	static real num_seconds = 8;
	repeat 
		if (volume_test_players_all (tv_lakeside_river_all) == 1
		or
		volume_test_players (tv_lakeside_river_all_rear) == 1
//		if (volume_test_players (tv_tortoise_top_01) == 1
//		or
//		volume_test_players (tv_tortoise_middle_01) == 1
		) then
			player_in_tort_for_awhile = player_in_tort_for_awhile + 1;
//		else
//			player_in_tort_for_awhile = 0;
		end
		until (player_in_tort_for_awhile == (30 * num_seconds), 1);
	print ("player was in tort for awhile");
	lakeside_rollout_rdy	= true;
end

script dormant lakeside_end_marine_refill()
	if

		(ai_living_count (marine_convoy) < 5
		
		and
		
		not (volume_test_players_all_lookat (tv_lakeside_hog_end_spawn, 3000, 40))
		
		and
		
		(object_valid (marines_main_hog_02_veh) == FALSE
		or
		object_valid (marines_main_hog_02_veh) == FALSE))
		
	then
		object_create (marines_main_lakeside_hog_01);
		ai_place (lakeside_hog_end_sq);
		ai_vehicle_enter_immediate (lakeside_hog_end_sq.guy1, marines_main_lakeside_hog_01);
		ai_vehicle_enter_immediate (lakeside_hog_end_sq.guy2, marines_main_lakeside_hog_01);
		print ("Lakeside_marines refilled");
	else
		print ("Lakeside_marines NOT refilled");
	end
end
 
script static void test_fx2()
	effect_attached_to_camera_new ("environments\solo\m40_invasion\fx\missile_strike\missile_strike_m40.effect");
	print ("fx on");
end

//--------------------lakeside command scripts-------------------

script command_script warthogs_through_mammoth()
	cs_vehicle_speed (.6);
	cs_go_to (lakeside_misc.p8);
	ai_path_ignore_object_obstacle (lakeside_hog_end_sq, main_mammoth);
	cs_go_to (lakeside_misc.p12);
	print ("lakeside_misc.p12");
	ai_path_clear_ignore_object_obstacle (lakeside_hog_end_sq);
	ai_vehicle_exit (ai_current_actor);
	thread (reserve_mammoth_vehicles());
	print ("marines went through mammoth");
end

script command_script warthogs_through_mammoth_abort()
	print ("Tortoise left without Lakeside AI, aborting their script");
	cs_go_to (lakeside_misc.p5);
end

script static void vol_test()
	wake (tort_top_lakeside_true);
	print ("tort lakeside scripts on");
end

script dormant tort_top_lakeside_true()
	repeat
		sleep_until (volume_test_players (tv_tortoise_top_01), 1);
		tort_top_lakeside = true;
		print ("tort_top_lakeside = true");
		sleep_until (not (volume_test_players (tv_tortoise_top_01)), 1); 
		tort_top_lakeside = false;
		print ("tort_top_lakeside = false");
	until (0 == 1);
end

script dormant lakeside_tort_catchup()
	sleep_until (volume_test_object (tv_spawn_tort, main_mammoth));	
	print ("player's in lakeside, hurry up tort!");
	wake (tortoise_lakeside_recorded);
	sleep_forever (f_fodder_mammoth_playback);
	sleep (30 * 1); 
	unit_recorder_set_playback_rate (main_mammoth, 1);
	print ("tortoise at 1 speed");
	sleep_until (volume_test_object (tv_tort_rec_lakeside_pt1, main_mammoth));
	unit_recorder_set_playback_rate_smooth (main_mammoth, .6, 2);
	print ("tortoise at 1 speed");
end

//script static void tortspeed()
//	unit_recorder_set_playback_rate (main_mammoth, 2.5);
//	print ("TORT SPEED = 2.5");
//end

//script command_script lakeside_ghost_retreat()
//	cs_vehicle_boost (true);
//	cs_go_to (lakeside_ghost_retreat_pt.p1);
//	cs_go_to (lakeside_ghost_retreat_pt.p0);
//	cs_vehicle_boost (false);
//end

//script command_script lakeside_wraith_01_cs()
//	print ("Lakeside wraith normal");
//end

script command_script lakeside_phantom_intro_cs()

	if
		lakeside_backup_ghosts_3_bool == false
	then
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_intro_spawn', lakeside_phantom_intro, 1);
			
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (ghosts_initial_1.driver)); 
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (ghosts_initial_1.driver2));
			
		cs_ignore_obstacles (TRUE);
		print ("flying to drop off enemies");
		cs_fly_by (lakeside_phantom_intro2_pt.p0);
		wake (M40_fodder_dropship_appear);
		cs_fly_by (lakeside_phantom_intro2_pt.p2);
		cs_fly_by (lakeside_phantom_intro2_pt.p3);
		cs_fly_by (lakeside_phantom_intro2_pt.p4);
		cs_fly_to_and_face (lakeside_phantom_intro2_pt.p13, lakeside_phantom_intro2_pt.p14);
	
		vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc01");	
		vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc02");
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_intro_takeoff', lakeside_phantom_intro, 1);
		lakeside_phantom_hanging_out = true;
	
	
		cs_fly_by (lakeside_phantom_06_pt.p3);
		cs_vehicle_speed (.4);
		repeat
			begin_random
				begin
					cs_fly_to_and_face (lakeside_phantom_06_pt.p3, lakeside_phantom_06_pt.p7);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_06_pt.p5, lakeside_phantom_06_pt.p7);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_06_pt.p4, lakeside_phantom_06_pt.p7);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_06_pt.p6, lakeside_phantom_06_pt.p7);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_06_pt.p12, lakeside_phantom_06_pt.p7);
				end
			end
//		until	(lakeside_cannon_alive == false);
		until	(unit_has_weapon (td_user, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon));
		cs_vehicle_speed (1);
		cs_fly_by (lakeside_phantom_07_pt.p21);
		cs_fly_by (lakeside_phantom_07_pt.p4);
		lakeside_phantom_hanging_out = false;
		cs_fly_by (lakeside_phantom_07_pt.p5);
		cs_fly_by (lakeside_phantom_07_pt.p6);
		ai_erase (ai_current_actor);
		
	else
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (lakeside_backup_ghosts_3.guy1)); 
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (lakeside_backup_ghosts_3.guy2));
		
		cs_ignore_obstacles (TRUE);
		print ("flying to drop off enemies");
		cs_fly_by (lakeside_phantom_intro2_pt.p0);
		cs_fly_by (lakeside_phantom_intro2_pt.p2);
		cs_fly_by (lakeside_phantom_intro2_pt.p3);
		cs_fly_by (lakeside_phantom_intro2_pt.p4);
		cs_fly_to_and_face (lakeside_phantom_intro2_pt.p13, lakeside_phantom_intro2_pt.p14);
		
		vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc01");	
		vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_intro.driver), "phantom_sc02");
		
		cs_fly_by (lakeside_phantom_07_pt.p4);
		cs_fly_by (lakeside_phantom_07_pt.p5);
		cs_fly_by (lakeside_phantom_07_pt.p6);
		ai_erase (ai_current_actor);
	end	
	
end

script command_script lakeside_phantom_01_cs()
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_1_spawn', lakeside_phantom_01, 1);
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (lakeside_phantom_01.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (lakeside_wraith_01.driver)); 
		cs_vehicle_speed (1);
		cs_fly_by (lakeside_phantom_01_pt.p0);
		cs_fly_by (lakeside_phantom_01_pt.p1);
		cs_fly_by (lakeside_phantom_01_pt.p2);
		vehicle_unload ((ai_vehicle_get_from_spawn_point (lakeside_phantom_01.driver)), "phantom_lc");		
		print ("flying to last points");
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_1_takeoff', lakeside_phantom_01, 1);
		cs_fly_by (lakeside_phantom_01_pt.p11);
		cs_fly_by (lakeside_phantom_01_pt.p12);
		cs_fly_by (lakeside_phantom_01_pt.p13);
		ai_erase (lakeside_phantom_01);
end

script command_script lakeside_phantom_04_cs()
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_4_spawn', lakeside_phantom_04, 1);
		f_load_phantom( lakeside_phantom_04, "chute", lakeside_fill_02_sq.guy1, lakeside_fill_02_sq.guy2, lakeside_fill_02_sq.guy3, lakeside_fill_02_sq.guy4);
		f_load_phantom( lakeside_phantom_04, "left", lakeside_fill_01_sq.guy1, lakeside_fill_01_sq.guy2, lakeside_fill_01_sq.guy3, NONE);		

		cs_ignore_obstacles (true);	

		cs_fly_by (lakeside_phantom_04_pt.p22);
		cs_fly_by (lakeside_phantom_intro_pt.p1);
		cs_fly_by (lakeside_phantom_04_pt.p26);

		cs_fly_to_and_face (lakeside_phantom_07_pt.p2, lakeside_phantom_07_pt.p3);

		thread (lakeside_phantom_04_unload_1());
		f_unload_phantom( lakeside_phantom_04, "chute" );
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_4_takeoff', lakeside_phantom_04, 1);
		cs_fly_by (lakeside_phantom_04_pt.p29);
		cs_fly_by (lakeside_phantom_04_pt.p30);
		cs_fly_by (lakeside_phantom_04_pt.p31);
		
		ai_erase (lakeside_phantom_04);
end

script command_script lakeside_phantom_07_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_7_spawn', lakeside_phantom_07, 1);
	cs_fly_by (lakeside_phantom_07_pt.p0);
	cs_fly_by (lakeside_phantom_07_pt.p1);
	cs_fly_by (lakeside_phantom_07_pt.p19);
	
	vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_07.driver), "phantom_sc01");	
	vehicle_unload (ai_vehicle_get_from_spawn_point (lakeside_phantom_07.driver), "phantom_sc02");
	
	sleep (30 * 2);

	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_7_takeoff', lakeside_phantom_07, 1);

	if
		volume_test_players (tv_tortoise_top_01)
	then
		wake (lakeside_phantom_07_hangout);
		ai_prefer_target_team (lakeside_phantom_intro, player);
		repeat
			begin_random
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p7, lakeside_phantom_07_pt.p12);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p8, lakeside_phantom_07_pt.p12);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p9, lakeside_phantom_07_pt.p12);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p10, lakeside_phantom_07_pt.p12);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p11, lakeside_phantom_07_pt.p12);
				end
				begin
					cs_fly_to_and_face (lakeside_phantom_07_pt.p14, lakeside_phantom_07_pt.p12);
				end
				begin
						cs_fly_to_and_face (lakeside_phantom_07_pt.p15, lakeside_phantom_07_pt.p12);
				end
			end
		until	(lakeside_phantom_07_hangout_bool == false);
	end


	cs_fly_by (lakeside_phantom_07_pt.p11);
	cs_fly_by (lakeside_phantom_07_pt.p10);
	cs_fly_by (lakeside_phantom_07_pt.p13);
	cs_fly_by (lakeside_phantom_07_pt.p4);
	cs_fly_by (lakeside_phantom_07_pt.p5);
	cs_fly_by (lakeside_phantom_07_pt.p6);
	cs_fly_by (lakeside_phantom_07_pt.p0);

		ai_erase (lakeside_phantom_07);
end

script static void lakeside_phantom_04_unload_1()
	f_unload_phantom( lakeside_phantom_04, "left" );
end

script dormant lakeside_phantom_07_hangout()
	print ("lakeside_phantom_07 hanging out, needs eight seconds of player off tortoise");
	static short player_off_tort_for_awhile = 0;
	static real num_seconds = 8;
	repeat 
		if (not(volume_test_players (tv_tortoise_top_01)) == 1
		and
		not (volume_test_players (tv_tortoise_middle_01)) == 1
		and
		not (volume_test_players (tv_tortoise_bottom_01)) == 1) 
		then
			player_off_tort_for_awhile = player_off_tort_for_awhile + 1;
//		else
//			player_in_tort_for_awhile = 0;
		end
		until (player_off_tort_for_awhile == (30 * num_seconds), 1);
	print ("player was off tort for awhile");
	lakeside_phantom_07_hangout_bool	= false;
end

script command_script lakeside_phantom_05_cs()
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_5_spawn', lakeside_phantom_05, 1);
		cs_ignore_obstacles (true);	
		cs_fly_by (lakeside_phantom_05_pt.p10);
		cs_fly_by (lakeside_phantom_05_pt.p9);
		cs_fly_by (lakeside_phantom_05_pt.p8);
		cs_fly_to_and_face (lakeside_phantom_05_pt.p13, lakeside_phantom_05_pt.p14);
		sleep (15 * 1);
		vehicle_unload (ai_vehicle_get (lakeside_phantom_05.driver), "phantom_lc");
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_5_takeoff', lakeside_phantom_05, 1);
		cs_fly_by (lakeside_phantom_06_pt.p8);
		cs_fly_by (lakeside_phantom_06_pt.p9);
		cs_fly_by (lakeside_phantom_06_pt.p10);
		cs_fly_by (lakeside_phantom_06_pt.p11);
		ai_erase (lakeside_phantom_05);
//	end
end

script command_script lakeside_phantom_05_B_cs()
		cs_ignore_obstacles (true);	
		cs_fly_by (lakeside_phantom_05_pt.p15);
		cs_fly_by (lakeside_phantom_05_pt.p16);
		cs_fly_to_and_face (lakeside_phantom_05_pt.p17, lakeside_phantom_05_pt.p18);
		sleep (30 * 2);
		vehicle_unload (ai_vehicle_get (lakeside_phantom_05.driver), "phantom_lc");
		cs_fly_by (lakeside_phantom_05_pt.p15);
		cs_fly_by (lakeside_phantom_05_pt.p19);
		ai_erase (lakeside_phantom_05);
//	end
end

script command_script lakeside_phantom_06_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_6_spawn', lakeside_phantom_06, 1);
	f_load_phantom( lakeside_phantom_06, "left", lakeside_fill_03_sq.guy1, lakeside_fill_03_sq.guy2, lakeside_fill_03_sq.guy3, NONE);	
	f_load_phantom( lakeside_phantom_06, "chute", lakeside_fill_04_sq.guy1, lakeside_fill_04_sq.guy2, NONE, NONE);
	f_load_phantom( lakeside_phantom_06, "right", lakeside_fill_05_sq.guy1, lakeside_fill_05_sq.guy2, NONE, NONE);	
	cs_fly_by (lakeside_phantom_06_pt.p0);
	cs_fly_by (lakeside_phantom_06_pt.p1);
	cs_fly_by (lakeside_phantom_06_pt.p2);
	cs_fly_to_and_face (lakeside_phantom_06_pt.p15, lakeside_phantom_06_pt.p16);
	thread (lakeside_phantom_06_unload_1());
	f_unload_phantom( lakeside_phantom_06, "chute" );
	cs_fly_by (lakeside_phantom_06_pt.p17);	
	cs_fly_to_and_face (lakeside_phantom_06_pt.p18, lakeside_phantom_06_pt.p19);
	f_unload_phantom( lakeside_phantom_06, "right" );
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_lakeside_phantom_6_takeoff', lakeside_phantom_06, 1);
	cs_fly_by (lakeside_phantom_06_pt.p8);
	cs_fly_by (lakeside_phantom_06_pt.p9);
	cs_fly_by (lakeside_phantom_06_pt.p10);
	cs_fly_by (lakeside_phantom_06_pt.p11);
	ai_erase (lakeside_phantom_06);
end

script static void lakeside_phantom_06_unload_1()
	f_unload_phantom( lakeside_phantom_06, "left" );
end

script command_script lakeside_pelican_airlift_cs()
	cs_vehicle_speed (1);
	cs_fly_by (lakeside_pelican_airlift_pt.p0);
	cs_fly_by (lakeside_pelican_airlift_pt.p1);
	cs_fly_by (lakeside_pelican_airlift_pt.p2);
	cs_fly_to_and_face (lakeside_pelican_airlift_pt.p3, lakeside_pelican_airlift_pt.p4);
	cs_ignore_obstacles (true);	
	cs_fly_to_and_face (lakeside_pelican_airlift_pt.p8, lakeside_pelican_airlift_pt.p9);
	lakeside_pelican_airlift_bool = true;	
	ai_vehicle_enter_immediate (pelican_marines.guy4, ai_get_unit(lakeside_pelican_airlift_sq));
	ai_vehicle_enter_immediate (pelican_marines.guy5, ai_get_unit(lakeside_pelican_airlift_sq));
		if
			not (unit_in_vehicle (pelican_marines.guy1))
			then
			ai_vehicle_enter_immediate (pelican_marines.guy1, ai_get_unit(lakeside_pelican_airlift_sq));
		end
		if
			not (unit_in_vehicle (pelican_marines_2.guy1))
			then
			ai_vehicle_enter_immediate (pelican_marines_2.guy1, ai_get_unit(lakeside_pelican_airlift_sq));
		end
	sleep (30 * 10);
	// FIXME - needs to be uncommented when unit_in_vehicle works for new pelican (always returns false right now)
//		sleep_until (unit_in_vehicle (pelican_marines.guy1)
//		and
//		unit_in_vehicle (pelican_marines.guy2)
//		);
	cs_fly_by (lakeside_pelican_airlift_pt.p5);
	cs_ignore_obstacles (false);	
	cs_fly_by (lakeside_pelican_airlift_pt.p6);
	cs_fly_by (lakeside_pelican_airlift_pt.p7);
	ai_erase (lakeside_pelican_airlift_sq);
end

script command_script lakeside_pelican_marines_kill()
	ai_kill_silent (pelican_marines.guy3);
//	ai_kill_silent (pelican_marines.guy4);
//	ai_kill_silent (pelican_marines.guy5);
end

script dormant tortoise_lakeside_recorded()
	print ("tortoise lakeside animation scripts are prepped");
	
	sleep_until (volume_test_object (tv_tort_rec_lakeside_pt1, main_mammoth));
	wake (prechopper_tortoise_recorded);
	sleep_forever (lakeside_tort_catchup);
	sleep_forever (f_fodder_mammoth_playback);
	thread (test_lakeside_hog_setup());
	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 2);		
	print ("TORT SPEED = .7");
	unit_recorder_pause_smooth (main_mammoth, false, 3);
	tort_stopped = FALSE;
	thread (mam_dust_on());
	
	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 100, 1);

	print ("HIT!");
	
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_b);
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("tortoise_0716_b has been set up");

//	sleep (30 * 3);

	wake (M40_lakeside_vehicles_deploy);

	thread (open_tort_doors_lakeside());

	sleep_until (
//	lakeside_obj_state > 29
//	and
	(lakeside_cannon_alive == FALSE)
	);
	
	f_unblip_object (marines_main_hog_02_veh);
	f_unblip_object (marines_main_hog_01_veh);
	
	object_create (cliffside_ghost_01);
	
	thread (display_chapter_03d_complete());

	thread (display_chapter_13());

	wake (lakeside_bridge_dialogue);
	
	object_create (cliffside_barrier_01);	
	object_create (cliffside_barrier_02);	
	object_create (cliffside_antennae_01);		

	sleep_until (tort_bay_doors_opened == true);

	thread (close_tort_doors_lakeside());

	sleep_until (tort_bay_doors_opened == false);
	
	wake (M40_lakeside_rollout);
	unit_recorder_pause (main_mammoth, false);
	tort_stopped = FALSE;

	sleep (30 * 2);

//	thread (new_tort_lakeside_speed_test());
	thread (new_tort_short_speed_test());
	thread (mam_dust_on());

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 12, 1);
	
	kill_volume_disable (kill_soft_post_lakeside);
	kill_volume_disable (kill_soft_prechop_backtrack);	
	
	unit_recorder_set_playback_rate (main_mammoth, .7);
	print ("TORT SPEED = .7");
	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 15, 1);

	print ("HIT!");
	
	thread (mam_dust_off());

//	sleep (30 * 2);	
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	print ("Paused");
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_c);
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("tortoise_0526_c loaded");
	sleep_s (2);
	
	if
		volume_test_players (tv_cliffside_entire)
	then
		print ("player is ahead, tortoise not opening doors");
		unit_recorder_set_playback_rate_smooth (main_mammoth, 1.5, 1);	
		print ("TORT SPEED = 1.5");
	else
		thread (open_tort_doors_river());
		wake (lakeside_tort_ready);
		wake (marines_cross_mammoth_sc);
		sleep_until (volume_test_players (tv_cliffside_entire)
		or
		lakeside_rollout_rdy	== true, 1
		);
	
		thread (close_tort_doors_river());
	end
	
	
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;
	thread (mam_dust_on());
	print ("lakeside tortoise skipped past the p7 across the river");
	thread (cliffside_tort_floor_test());
	

	sleep_until (
	
	(objects_distance_to_object (player0, main_mammoth) < 20 
	and
	objects_distance_to_object (player0, main_mammoth) > 0)
	or
	(objects_distance_to_object (player1, main_mammoth) < 20 
	and
	objects_distance_to_object (player1, main_mammoth) > 0)	
	or
	(objects_distance_to_object (player2, main_mammoth) < 20 
	and
	objects_distance_to_object (player2, main_mammoth) > 0)
	or
	(objects_distance_to_object (player3, main_mammoth) < 20 
	and
	objects_distance_to_object (player3, main_mammoth) > 0)
	
	or
	lakeside_obj_state > 39, 1);
	
	
	print ("CLIFFSIDE JUST CHECKED PLAYER LOCATION FOR GHOST ASSAULT OR TORT ASSAULT");
	wake (cliffside_phantom_placement);
	unit_recorder_pause (main_mammoth, false);
	tort_stopped = FALSE;
	thread (mam_dust_on());
	sleep (30 * 2);
	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 1);	
	print ("TORT SPEED = 1");

	thread (new_tort_cliffside_part_1_speed_test());

	sleep_until (volume_test_object (tv_cliffside_01b, main_mammoth));
		if
			volume_test_players (tv_tortoise_top_01)
			or
			volume_test_players (tv_tortoise_middle_01)
			or
			volume_test_players (tv_tortoise_bottom_01)
		then
			print ("cliffside_phantom_02 tortoise assault");
			sleep (30 * 3);	
			unit_recorder_set_playback_rate_smooth (main_mammoth, .3, 3);	
			print ("TORT SPEED = .3");
			sleep (30 * 7);
			unit_recorder_set_playback_rate_smooth (main_mammoth, .13, 3);	
			print ("TORT SPEED = .13");
			sleep (30 * 7);
		end
	print ("threading tort repeating speed test");

	sleep_until (volume_test_object (tv_cliffside_01b, main_mammoth));

	TDT_dist = 15;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cliffside_obj_state < 20)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = All players are behind, Tortoise is stopping");		

	//Checked to see if the player doesnt have a jetpack and got left behind so we can teleport him

	if
		game_coop_player_count() == 1
		and
		volume_test_players (tv_lakeside_entire)
	then
		object_teleport (player0, lakeside_left_behind_flag);
	end
						
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cliffside_obj_state > 19, 1);

		print ("TDT = Tort Distance Test = At least one player is caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
	unit_kill_list_silent (volume_return_objects (tv_lakeside_entire));
	
	sleep_until (volume_test_object (tv_cliffside_03, main_mammoth));

	TDT_dist = 15;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cliffside_obj_state < 30)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = All players are behind, Tortoise is stopping");		
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cliffside_obj_state > 29, 1);

		print ("TDT = Tort Distance Test = At least one player is caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end

	sleep_until (volume_test_object (tv_cliffside_07, main_mammoth));

	TDT_dist = 15;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cliffside_obj_state < 70)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = All players are behind, Tortoise is stopping");		
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cliffside_obj_state > 69, 1);

		print ("TDT = Tort Distance Test = At least one player has caught up, Tortoise is continuing");		
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
end

script dormant lakeside_bridge_dialogue()
	sleep (30 * 15);
		if
			not (volume_test_players (tv_tortoise_top_01))
			and
			not (volume_test_players (tv_tortoise_middle_01))
			and
			not (volume_test_players (tv_tortoise_bottom_01))
		then
	wake (M40_lakeside_prep_rollout );
		end
end

script dormant cliffside_phantom_placement()
	ai_place (cliffside_phantom_02);
	sleep (30 * 3);
	ai_place (cliffside_phantom_01);
  wake (cliffside_phantom_roulette);
end

script dormant cliffside_ins_tortoise_recording()
	print ("lakeside tortoise skipped past the p7 across the river");
	thread (cliffside_tort_floor_test());
	
	sleep_until (
	
	(objects_distance_to_object (player0, main_mammoth) < 20 
	and
	objects_distance_to_object (player0, main_mammoth) > 0)
	or
	(objects_distance_to_object (player1, main_mammoth) < 20 
	and
	objects_distance_to_object (player1, main_mammoth) > 0)	
	or
	(objects_distance_to_object (player2, main_mammoth) < 20 
	and
	objects_distance_to_object (player2, main_mammoth) > 0)
	or
	(objects_distance_to_object (player3, main_mammoth) < 20 
	and
	objects_distance_to_object (player3, main_mammoth) > 0)
	
	or
	lakeside_obj_state > 39, 1);
	
	print ("CLIFFSIDE JUST CHECKED PLAYER LOCATION FOR GHOST ASSAULT OR TORT ASSAULT");
	wake (cliffside_phantom_placement);
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;
	thread (mam_dust_on());
	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 1);	
	print ("TORT SPEED = 1");
	print ("threading tort repeating speed test");
	thread (new_tort_cliffside_part_1_speed_test());

	sleep_until (volume_test_object (tv_cliffside_07, main_mammoth));

	TDT_dist = 15;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		cliffside_obj_state < 70)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = Player is behind, Tortoise is stopping");
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		cliffside_obj_state > 69, 1);

		print ("TDT = Tort Distance Test = Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
end

script dormant marines_cross_mammoth_sc()
//	sleep (30 * 15);	
	if
		not (volume_test_object (tv_tortoise_bottom_01, lakeside_hog_end_sq.guy1))
		and
		vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", lakeside_hog_end_sq.guy1)
		or
		vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", lakeside_hog_end_sq.guy1)
		or
		vehicle_test_seat_unit (marines_main_lakeside_hog_01, "warthog_d", lakeside_hog_end_sq.guy1)		
	then
		cs_run_command_script (lakeside_hog_end_sq.guy1, warthogs_through_mammoth);
		print ("lakeside_hog_end_sq.guy1 GOES THROUGH MAMMOTH");
		sleep_until (tort_stopped == false);
		cs_run_command_script (lakeside_hog_end_sq.guy1, warthogs_through_mammoth_abort);
			
	elseif
		not (volume_test_object (tv_tortoise_bottom_01, lakeside_hog_end_sq.guy2))
		and
		vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", lakeside_hog_end_sq.guy2)
		or
		vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", lakeside_hog_end_sq.guy2)
		or
		vehicle_test_seat_unit (marines_main_lakeside_hog_01, "warthog_d", lakeside_hog_end_sq.guy2)	
	then
		cs_run_command_script (lakeside_hog_end_sq.guy2, warthogs_through_mammoth);	
		print ("lakeside_hog_end_sq.guy2 GOES THROUGH MAMMOTH");
		sleep_until (tort_stopped == false);
		cs_run_command_script (lakeside_hog_end_sq.guy2, warthogs_through_mammoth_abort);
	
	elseif
		not (volume_test_object (tv_tortoise_bottom_01, tortoise_jetpacker_01.billy))
		and
		vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", tortoise_jetpacker_01.billy)
		or
		vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", tortoise_jetpacker_01.billy)
		or
		vehicle_test_seat_unit (marines_main_lakeside_hog_01, "warthog_d", tortoise_jetpacker_01.billy)	
	then
		cs_run_command_script (tortoise_jetpacker_01.billy, warthogs_through_mammoth);	
		print ("tortoise_jetpacker_01.billy GOES THROUGH MAMMOTH");
		sleep_until (tort_stopped == false);
		cs_run_command_script (tortoise_jetpacker_01.billy, warthogs_through_mammoth_abort);	
				
	elseif
		not (volume_test_object (tv_tortoise_bottom_01, tortoise_jetpacker_02.cliff))
		and
		vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", tortoise_jetpacker_02.cliff)
		or
		vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", tortoise_jetpacker_02.cliff)
		or
		vehicle_test_seat_unit (marines_main_lakeside_hog_01, "warthog_d", tortoise_jetpacker_02.cliff)	
	then
		cs_run_command_script (tortoise_jetpacker_02.cliff, warthogs_through_mammoth);	
		print ("tortoise_jetpacker_02.cliff GOES THROUGH MAMMOTH");
		sleep_until (tort_stopped == false);
		cs_run_command_script (tortoise_jetpacker_02.cliff, warthogs_through_mammoth_abort);		
		
	elseif
		not (volume_test_object (tv_tortoise_bottom_01, marines_main_hog_01b_sq.hog_01_gunner))
		and
		(vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", marines_main_hog_01b_sq.hog_01_gunner)
		or
		vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", marines_main_hog_01b_sq.hog_01_gunner)
		or
		vehicle_test_seat_unit (marines_main_lakeside_hog_01, "warthog_d", marines_main_hog_01b_sq.hog_01_gunner))
	then
		cs_run_command_script (marines_main_hog_01b_sq.hog_01_gunner, warthogs_through_mammoth);	
		print ("marines_main_hog_01b_sq.hog_01_gunner GOES THROUGH MAMMOTH");
		sleep_until (tort_stopped == false);
		cs_run_command_script (marines_main_hog_01b_sq.hog_01_gunner, warthogs_through_mammoth_abort);
	end
end


script static void phantom_load_test1()
	ai_place (cliffside_phantom_02);
	ai_place (cliffside_ghosts_01);
//	f_load_phantom_cargo (cliffside_phantom_02, "double", cliffside_ghosts_01, NONE);
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_02.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver)); 
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_02.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver2));
end

script static void cliffside_tort_floor_test()
	sleep_until (
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01), 1);
cliffside_tort_floor_test_bl = TRUE;
end

script dormant detect_players_after_cliffside()
	sleep_until (volume_test_object (tv_cliffside_entire, main_mammoth) and prechopper_obj_state > 31, 1);
	print ("Player already in Prechopper! Tortoise full speed to Prechopper");
	sleep (30 * 10);
	unit_recorder_set_playback_rate (main_mammoth, 1);
	print ("TORT SPEED = 1");
	sleep_forever (tortoise_lakeside_recorded);
	sleep_forever (cliffside_ins_tortoise_recording);
end


// =================================================================================================
// =================================================================================================
// CLIFFSIDE
// =================================================================================================
// =================================================================================================

script dormant prechopper_shield_barrier_spawn()
	sleep_until (volume_test_players (tv_cliffside_06), 1);
	object_create (prechopper_shield_barrier);	
	print ("prechopper_shield_barrier created"); 
end

script dormant cliffside_enc_main()


	sleep_until (volume_test_players (tv_cliffside_01), 1);
	thread(f_mus_m40_e03_begin());
	print ("cliffside script playing"); 
	ai_place (cliffside_edge_sq_01);
	ai_place (cliffside_edge_sq_02);
	ai_place (cliffside_edge_sq_03);		
	
	wake (cliffside_ghost_retreat);
	wake (spawn_prechopper);
	wake (prechopper_obj_states);
	wake (prechopper_convoy_prep);
  wake (cliffside_banshee_control);

	sleep_until (volume_test_players (tv_cliffside_07));	
	
	object_create_folder (prechopper_crates);
	
	kill_volume_enable (kill_soft_lakeside_backtrack);

	thread (prechopper_bubble_creation());
	
	if 
		object_valid (prechopper_shield_barrier)
	then 
		print ("prechop shield barrier already exists");
	else
		object_create (prechopper_shield_barrier);
		print ("prechop shield barrier created");
	end
				
//	sleep_until (volume_test_players (tv_cliffside_07));	
	
	game_save_no_timeout();
	
	thread(f_mus_m40_e03_finish());
end

script dormant cliffside_banshee_control()
	sleep_until (volume_test_players (tv_cliffside_02));
	if
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01)		
	then
	ai_place (cliffside_banshee_strafe_01);
	
	thread (banshee_dialogue());
	
	unit_set_enterable_by_player (ai_get_unit (cliffside_banshee_strafe_01.guy1), false);
	unit_set_enterable_by_player (ai_get_unit (cliffside_banshee_strafe_01.guy2), false);
	
	sleep_until (volume_test_players (tv_cliffside_07));
	cs_run_command_script (cliffside_banshee_strafe_01.guy1, banshee_strafe_01_leave_cs);
	cs_run_command_script (cliffside_banshee_strafe_01.guy2, banshee_strafe_02_leave_cs);
	else
	print ("player isn't on Mammoth");
	end
end

script static void banshee_dialogue()
	sleep_s (6);
	
	wake (f_dialog_m40_banshees);
end

script dormant prechopper_arrival_test()
//	sleep_until (volume_test_players (tv_cliffside_retreat), 1);
	sleep_until (volume_test_object (tv_cliffside_retreat, main_mammoth), 1);
	prechopper_arrival = true;
//	sleep_forever (tort_cliffside_repeating_speed_test);
end

script dormant cliffside_obj_states()
	sleep_until (volume_test_players (tv_cliffside_01), 1);
	cliffside_obj_state = 10;
	print ("cliffside_obj_state = 10");
	
	if
		volume_test_object (tv_lakeside_entire, player0)
	then
		if 
			unit_in_vehicle (player0)
		then
			object_teleport (unit_get_vehicle (player0), lakeside_teleport_01);
		else
			object_teleport (player0, lakeside_teleport_01);
		end
	end
	
	if
		volume_test_object (tv_lakeside_entire, player1)
	then
		if 
			unit_in_vehicle (player1)
		then
			object_teleport (unit_get_vehicle (player1), lakeside_teleport_02);
		else
			object_teleport (player1, lakeside_teleport_02);
		end
	end
	
	if
		volume_test_object (tv_lakeside_entire, player2)
	then
		if 
			unit_in_vehicle (player2)
		then
			object_teleport (unit_get_vehicle (player2), lakeside_teleport_03);
		else
			object_teleport (player2, lakeside_teleport_03);
		end
	end

	if
		volume_test_object (tv_lakeside_entire, player3)
	then
		if 
			unit_in_vehicle (player3)
		then
			object_teleport (unit_get_vehicle (player3), lakeside_teleport_04);
		else
			object_teleport (player3, lakeside_teleport_04);
		end
	end

	ai_kill_silent (front_jackal_sq); 
	ai_kill_silent (rock_sq); 
	ai_kill_silent (high_cave_sq); 
	ai_kill_silent (high_bridge_sq);
	ai_kill_silent (mid_rock_sq);
	ai_kill_silent (front_barricade_guard);
	ai_kill_silent (front_barricade_guard_rear);
	ai_kill_silent (front_grunts_sq);
	
	ai_kill_silent (lakeside_fill_01_sq);
	ai_kill_silent (lakeside_fill_02_sq);	

	ai_kill_silent (lakeside_sq);

	ai_kill_silent (ghosts_initial_1);
	ai_kill_silent (lakeside_backup_ghosts_2);
	ai_kill_silent (lakeside_backup_ghosts_3);
	ai_kill_silent (lakeside_wraith_01);
	ai_kill_silent (lakeside_wraith_03);		
	
	ai_set_objective (marine_convoy, cliffside_marines_obj);
	ai_set_objective (marine_convoy_02, cliffside_marines_obj);
	
	sleep_until (volume_test_players (tv_cliffside_02), 1);
	cliffside_obj_state = 20;
	print ("cliffside_obj_state = 20");
	
	sleep_until (volume_test_players (tv_cliffside_03), 1);
	cliffside_obj_state = 30;
	print ("cliffside_obj_state = 30");
	
	sleep_until (volume_test_players (tv_cliffside_04), 1);
	cliffside_obj_state = 40;
	print ("cliffside_obj_state = 40");
	
	sleep_until (volume_test_players (tv_cliffside_05), 1);
	cliffside_obj_state = 50;
	print ("cliffside_obj_state = 50");
	
	sleep_until (volume_test_players (tv_cliffside_06), 1);
	cliffside_obj_state = 60;
	print ("cliffside_obj_state = 60");
	
	sleep_until (volume_test_players (tv_prechopper_01), 1);
	cliffside_obj_state = 70;
	print ("cliffside_obj_state = 70");
	
	sleep_until (volume_test_players (tv_cliffside_retreat), 1);
	cliffside_obj_state = 80;
	print ("cliffside_obj_state = 80");	
	
	thread (honey_i_shrunk_the_forerunner_cannon_again());	
	
	object_teleport_to_ai_point (prechopper_tower_pod, chopper_smash.pod_location);	
	
	ai_set_objective (marine_convoy, obj_prechopper_unsc);
	ai_set_objective (marine_convoy_02, obj_prechopper_unsc);
	print ("Cliffside AI handed off to Prechopper");
end

script dormant cliffside_ghost_retreat()
	sleep_until (volume_test_players (tv_prechopper_015), 1);
	print ("cliffside ghosts running away");	
	ai_set_objective (cliffside_ghosts_01, cliffside_cov_ghosts_end);
	ai_set_objective (cliffside_ghosts_02, cliffside_cov_ghosts_end);
//	ai_set_objective (cliffside_ghosts_03, cliffside_cov_ghosts_end);
end

//script dormant cliffside_tort_assault_test_speed()
//	sleep_until (ai_living_count (cliffside_tortoise_assault_grp) < 1);
//	unit_recorder_set_playback_rate_smooth (main_mammoth, 1, 3);
//	print ("TORT SPEED = 1");
//	sleep_forever (cliffside_ins_tortoise_recording);
//end

script static void version_check()
	print ("07.26.11.12");
end

//--------------------cliffside command scripts-------------------



script command_script cliffside_phantom_01_A_cs()
	print ("cliffside_phantom_01 spawned A");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_1a_spawn', cliffside_phantom_01, 1);
	unit_open (cliffside_phantom_01);
//	cs_fly_by (cliffside_phantom_01_pt.p0);
	cs_fly_by (cliffside_phantom_01_pt.p1);
//	print ("cliffside_phantom_01_A_cs flew to p1");
	cs_fly_to_and_face (cliffside_phantom_01_pt.p2, cliffside_phantom_01_pt.p15); 
	sleep_until (volume_test_object (tv_cliffside_mam_trigger, main_mammoth), 1);	
	
	wake (f_dialog_m40_more_covenant);
	
	if
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01)
	then
//		print ("cliffside_phantom_01 tortoise strafe");
		cs_ignore_obstacles (true);			
		cs_vehicle_speed (.4);
		
		cs_fly_to_and_face (cliffside_run_pt.p3, cliffside_run_pt.p2);
		
		cs_fly_by (cliffside_run_pt.p0);
		cs_fly_by (cliffside_run_pt.p1);
		cs_fly_by (cliffside_run_pt.p2);		

		cs_vehicle_speed (1);

		cs_fly_by (cliffside_phantom_01_pt.p7);
		cs_fly_by (cliffside_phantom_01_pt.p8);
		
		ai_erase (cliffside_phantom_01);
		
		//for boarding the Mammoth
//		print ("cliffside_phantom_01 going to p3");
//		cs_fly_to_and_face (cliffside_phantom_01_pt.p3, cliffside_phantom_01_pt.p4);
//		wake (M40_lakeside_tort_assault_dialogue); 
//		print ("cliffside_phantom_01 reached p3");
//		cs_vehicle_speed (.11);
//		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_p_rb");
//		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_p_rf");
//		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_p_mr_f");
//		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_p_mr_b");
//		print ("cliffside_phantom_01 has deployed squads");
//		print ("cliffside_phantom_01 going to p4");
//		cs_fly_to_and_face (cliffside_phantom_01_pt.p4, cliffside_phantom_01_pt.p5);
//		print ("cliffside_phantom_01 reached p4");
//		wake (m40_boarding_party);
//		print ("m40_boarding_party");
////		cs_fly_by (cliffside_phantom_01_pt.p11);
//		cs_vehicle_speed (1);
//		cs_fly_by (cliffside_phantom_01_pt.p7);
//		cs_fly_by (cliffside_phantom_01_pt.p8);
//		ai_erase (cliffside_phantom_01);


	else
		cs_vehicle_speed (1);
		cs_fly_by (cliffside_phantom_01_pt.p7);
		cs_fly_by (cliffside_phantom_01_pt.p8);
		cs_vehicle_speed (1);
		print ("cliffside_phantom_01 about to erase");
		ai_erase (cliffside_phantom_01);
	end
//	print ("cliffside_phantom_01 erased");
end

script command_script cliffside_phantom_01_B_cs()
	print ("cliffside_phantom_01 spawned B");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_1b_spawn', cliffside_phantom_01, 1);
	ai_place (cliffside_ghosts_01);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_01.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_01.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver2));
//	cs_fly_by (cliffside_phantom_01_pt.p0);
//	print ("cliffside_phantom_01_B_cs loaded AI");
	cs_fly_by (cliffside_phantom_01_pt.p1);
//	print ("cliffside_phantom_01_B_cs flew to p1");
	cs_fly_to_and_face (cliffside_phantom_01_pt.p2, cliffside_phantom_01_pt.p15); 
	sleep_until (volume_test_object (tv_cliffside_mam_trigger, main_mammoth)
	or
	volume_test_players (tv_cliffside_mam_trigger)
	, 1);	
	if
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01)		
	then
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p15, cliffside_phantom_02_pt.p16); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		cs_fly_by (cliffside_phantom_02_pt.p8);
		cs_fly_by (cliffside_phantom_02_pt.p9);
		
		ai_erase (cliffside_phantom_01);
//		print ("cliffside_phantom_01 erased");
	else	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p5, cliffside_phantom_02_pt.p6);
		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_sc01");
		vehicle_unload (ai_vehicle_get (cliffside_phantom_01.driver), "phantom_sc02");
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_1b_takeoff', cliffside_phantom_01, 1);
		cs_fly_by (cliffside_phantom_02_pt.p7);
		cs_fly_by (cliffside_phantom_02_pt.p8);
		cs_fly_by (cliffside_phantom_02_pt.p9);
		ai_erase (cliffside_phantom_01);
//		print ("cliffside_phantom_01 erased");
	end
end

script command_script cliffside_phantom_02_B_cs()
	print ("cliffside_phantom_02 spawned B");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_2b_spawn', cliffside_phantom_02, 1);
	cs_fly_by (cliffside_phantom_02_pt.p4);
	print ("cliffside_phantom_02 flew to p1");
	cs_fly_to_and_face (cliffside_phantom_01_pt.p12, cliffside_phantom_01_pt.p15);
	sleep_until (volume_test_object (tv_cliffside_mam_trigger, main_mammoth), 1);
	if
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
	then
	
//		print ("cliffside_phantom_02 tortoise strafe");
		cs_ignore_obstacles (true);			
		cs_vehicle_speed (.4);
		
			cs_fly_to_and_face (cliffside_run_pt.p4, cliffside_run_pt.p2);
		
		cs_fly_by (cliffside_run_pt.p0);
		cs_fly_by (cliffside_run_pt.p1);
		cs_fly_by (cliffside_run_pt.p2);		

		cs_vehicle_speed (1);

		cs_fly_by (cliffside_phantom_01_pt.p7);
		cs_fly_by (cliffside_phantom_01_pt.p8);
		
		ai_erase (cliffside_phantom_02);
	
	else
		cs_fly_by (cliffside_phantom_01_pt.p7);
		cs_fly_by (cliffside_phantom_01_pt.p8);
		ai_erase (cliffside_phantom_02);
	end
//	print ("cliffside_phantom_01 erased");
end

script command_script cliffside_phantom_02_A_cs()
	print ("cliffside_phantom_02 spawned A");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_2a_spawn', cliffside_phantom_02, 1);
	
	ai_place (cliffside_ghosts_01);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_02.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (cliffside_phantom_02.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (cliffside_ghosts_01.driver2));
//	print ("cliffside_phantom_02_A_cs loaded AI");
	cs_fly_by (cliffside_phantom_02_pt.p4);
	cs_fly_to_and_face (cliffside_phantom_01_pt.p12, cliffside_phantom_01_pt.p15);
	sleep_until (volume_test_object (tv_cliffside_mam_trigger, main_mammoth)
	or
	volume_test_players (tv_cliffside_mam_trigger)
	, 1);	
	if
		volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01)		
	then
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p15, cliffside_phantom_02_pt.p16); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		sleep (30 * 1);	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p11, cliffside_phantom_02_pt.p12); 
		cs_fly_by (cliffside_phantom_02_pt.p8);
		cs_fly_by (cliffside_phantom_02_pt.p9);
		ai_erase (cliffside_phantom_02);
//		print ("cliffside_phantom_02 erased");
	else	
		cs_fly_to_and_face (cliffside_phantom_02_pt.p5, cliffside_phantom_02_pt.p6);
		vehicle_unload (ai_vehicle_get (cliffside_phantom_02.driver), "phantom_sc01");
		vehicle_unload (ai_vehicle_get (cliffside_phantom_02.driver), "phantom_sc02");
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_cliffside_phantom_2a_takeoff', cliffside_phantom_02, 1);
		cs_fly_by (cliffside_phantom_02_pt.p7);
		cs_fly_by (cliffside_phantom_02_pt.p8);
		cs_fly_by (cliffside_phantom_02_pt.p9);
		ai_erase (cliffside_phantom_02);
//		print ("cliffside_phantom_02 erased");
	end
end

script command_script banshee_strafe_01_cs()
	cs_fly_by (cliffside_run_pt.p5);
//	cs_fly_by (cliffside_run_pt.p7);
	cs_fly_by (cliffside_run_pt.p14);
end

script command_script banshee_strafe_02_cs()
	cs_fly_by (cliffside_run_pt.p6);
//	cs_fly_by (cliffside_run_pt.p8);
	cs_fly_by (cliffside_run_pt.p15);
end

script command_script banshee_strafe_01_leave_cs()
	cs_fly_by (cliffside_run_pt.p9);
	cs_fly_by (cliffside_run_pt.p10);
	cs_fly_by (cliffside_run_pt.p11);
	ai_erase (cliffside_banshee_strafe_01.guy1);
end

script command_script banshee_strafe_02_leave_cs()
	cs_fly_by (cliffside_run_pt.p12);
	cs_fly_by (cliffside_run_pt.p13);
	cs_fly_by (cliffside_run_pt.p11);
	ai_erase (cliffside_banshee_strafe_01.guy2);
end

script dormant cliffside_phantom_roulette()
	begin_random_count(1)

		begin
			cs_run_command_script (cliffside_phantom_01.driver, cliffside_phantom_01_A_cs);
			cs_run_command_script (cliffside_phantom_02.driver, cliffside_phantom_02_A_cs);
			print ("Right Phantom drops Ghosts");		
		end

		begin
			cs_run_command_script (cliffside_phantom_01.driver, cliffside_phantom_01_B_cs);
			cs_run_command_script (cliffside_phantom_02.driver, cliffside_phantom_02_B_cs);	
			print ("Left Phantom drops Ghosts");		
		end
		
	end	
end


// =================================================================================================
// =================================================================================================
// CHOPPER
// =================================================================================================
// =================================================================================================

script dormant chopper_main_script()
	sleep_until (chop_obj_state > 9
	and
	s_bubbles_burst == 3
	);	
	
	ai_lod_full_detail_actors (25);
	
	thread (check_early_lich_kill());
	
	wake (blip_chopper_gun);
	
	object_hide (lichy, true);
	object_set_physics (lichy, false);
	
 	data_mine_set_mission_segment ("m40_chopper");

	sleep_until (volume_test_players (tv_chopper_03), 1);

	wake (M40_waterfalls_warning);
	thread (chopper_marine_backup());

	object_create (chop_hilltop_crate_01);
	object_create (chop_hilltop_crate_02);
	ai_vehicle_reserve (chop_reserved_ghost_01, true);

	sleep_until (chopper_cannon_alive == FALSE);

	effects_perf_armageddon = 1;
	
	game_save_no_timeout();
	thread (prechopper_ai_kills());

 	thread(f_mus_m40_e05_begin());
	wake (M40_chopper_Rail_gun);

	thread (blip_chop_gauss());

	print ("CHOP WAVE 1 OF 5");


	ai_place (chop_phantom_02_sq);
	ai_place (chop_ghost_06_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_02_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_02_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver2));

	object_set_physics (lichy, true);
	object_hide (lichy, false);
	ai_place (chop_lich);
	
	ai_disregard(ai_actors(chop_lich), TRUE);
	
	thread (end_td_use());
	
	thread (chopper_player_leave_dialogue());
	
	garbage_collecting = true;

	sleep (1);
	
	thread (garbage_collect_me());
	
	ai_place (chop_phantom_09_sq);
	ai_place (chop_wraith_02_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_09_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_02_sq.driver));	

	sleep_s (4);

	f_blip_ai (chop_lich, "navpoint_enemy_vehicle");
	print ("Blip The Lich");
	
	thread (unblip_chop_lich_sc());
	
	sleep_until (player_in_vehicle (chop_gauss_waiting)
	or
	ai_living_count (chop_ghosts) < 2);

	ai_place (chop_phantom_06_sq);
	ai_place (chop_ghost_03_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_06_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_03_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_06_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_03_sq.driver));

	wake (M40_chopper_lich_reveal);
	vehicle_set_player_interaction (lichy, "pelican_p_l05", false, false);
	print ("lich spawned");
	
	sleep (1);
	
	sleep_until (player_in_vehicle (chop_gauss_waiting)
	or
	ai_living_count (chop_ghosts) < 3);
	
	ai_place (chop_phantom_05_sq);
	ai_place (chop_ghost_05_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver));

	sleep (30 * 7);	

	if
		player_in_vehicle (chop_gauss_waiting)
		or
		volume_test_players (tv_tortoise_top_01)
	then
	sleep_until	
		(ai_living_count (chop_wraith_02_sq) < 1
		or
		ai_living_count (chop_ghosts) < 4
		);
	else
	sleep_until	
		(ai_living_count (chop_wraith_02_sq) < 2
		and
		ai_living_count (chop_ghosts) < 3
		);
	end
			
	chop_obj_state = 62;
	print ("chop objective state 62");
	print ("CHOP WAVE 2 OF 5");
	
	wake (f_dialog_m40_hold_the_hill);
	
	game_save_no_timeout();
	
	ai_place (chop_phantom_03_sq);
	ai_place (chop_wraith_01_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_01_sq.driver));	
		
	thread (garbage_collect_chop());
	
	if
		lich_dead_early == TRUE
		and
		dm_mode1 == TRUE
	then
		thread (rail_gun_sp_sc());
		rgt_bool = true;
		print ("RGT");
	end
		
	if
		player_in_vehicle (chop_gauss_waiting)
		or
		volume_test_players (tv_tortoise_top_01)
	then
	sleep_until	
		(ai_living_count (chop_ghosts) < 4);
	else
	sleep_until	
		(ai_living_count (chop_ghosts) < 3);
	end
		
	chop_obj_state = 63;
	print ("chop objective state 63");
	print ("CHOP WAVE 3 OF 5");
	
	game_save_no_timeout();

	if
		lich_dead_early == TRUE
		and
		dm_mode1 == TRUE
		and
		rgt_bool ==  false
	then
		thread (rail_gun_sp_sc());
		rgt_bool = true;
		print ("RGT");
	end
		
	ai_place (chop_phantom_04_sq);
	ai_place (chop_ghost_04_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_04_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_04_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver));

 	game_save_no_timeout();

	sleep_s(1);

	if
		player_in_vehicle (chop_gauss_waiting)
		or
		volume_test_players (tv_tortoise_top_01)
	then
	sleep_until	
		(ai_living_count (chop_ghosts) < 4);
	else
	sleep_until	
		(ai_living_count (chop_ghosts) < 3);
	end
	
	chop_obj_state = 64;
	print ("chop objective state 64");
	print ("CHOP WAVE 4 OF 5");
	
	wake (f_dialog_m40_hold_them_off);
	
	game_save_no_timeout();
		
	ai_place (chop_phantom_05_sq);
	ai_place (chop_ghost_05_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver));

 	game_save_no_timeout();

	sleep_s(1);

		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 1
		and
		ai_living_count (chop_wraith_02_sq) < 1)
		);
			
	ai_place (chop_phantom_07_sq);
	ai_place (chop_wraith_02_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_07_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_02_sq.driver));
	
	chop_obj_state = 65;
	print ("chop objective state 65");
	print ("CHOP WAVE 5 OF 5");
	
		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 1
		or
		ai_living_count (chop_wraith_02_sq) < 1)
		);	
	
	ai_place (chop_phantom_03_sq);
	ai_place (chop_ghost_06_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver2));
	
		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 2
		and
		ai_living_count (chop_wraith_02_sq) < 2)
		);	


	if
		game_coop_player_count() > 2	
	or
		game_difficulty_get_real() == legendary
	or
		lich_dead_early == true
	then
	
	
	//------------------- LEGENDARY AND 3P/4P CO-OP EXTENDED BATTLE-------------------------//

	thread (chop_leg_backup());
	
	ai_place (chop_phantom_06_sq);
	ai_place (chop_ghost_03_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_06_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_03_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_06_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_03_sq.driver));

	sleep_until (player_in_vehicle (chop_gauss_waiting)
	or
	ai_living_count (chop_ghosts) < 3);
	
	ai_place (chop_phantom_05_sq);
	ai_place (chop_ghost_05_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver));

	sleep (30 * 7);	

	sleep_until	
		(ai_living_count (chop_wraith_02_sq) < 1
		or
		ai_living_count (chop_ghosts) < 4
		);

	game_save_no_timeout();
	
	ai_place (chop_phantom_03_sq);
	ai_place (chop_wraith_01_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_01_sq.driver));	
		
	thread (garbage_collect_chop());
			
	sleep_until	
		(ai_living_count (chop_ghosts) < 4);

		
	ai_place (chop_phantom_04_sq);
	ai_place (chop_ghost_04_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_04_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_04_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver));

	sleep_until	
		(ai_living_count (chop_ghosts) < 4);

	game_save_no_timeout();
		
	ai_place (chop_phantom_05_sq);
	ai_place (chop_ghost_05_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver2));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_05_sq.driver));

		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 1
		and
		ai_living_count (chop_wraith_02_sq) < 1)
		);
			
	ai_place (chop_phantom_07_sq);
	ai_place (chop_wraith_02_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_07_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_02_sq.driver));
	
		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 1
		or
		ai_living_count (chop_wraith_02_sq) < 1)
		);	
	
	ai_place (chop_phantom_03_sq);
	ai_place (chop_ghost_06_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver));
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_03_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_06_sq.driver2));
	
		sleep_until	
		(ai_living_count (chop_ghosts) < 4	
		or
		(ai_living_count (chop_wraith_01_sq) < 2
		and
		ai_living_count (chop_wraith_02_sq) < 2)
		);	
	
	//--------------------------------------------------------------------------------------//
	
	
	end

	chop_obj_state = 66;

	print ("CHOP WAVES DEAD");

	game_save_no_timeout();
	
	sleep_s (10);
	
	thread (marines_exit_chop_vehicles());

end

script static void marines_exit_chop_vehicles()
	print ("******************* MARINES ORDERED TO EXIT CHOPPER VEHICLES *******************");
	
	ai_vehicle_exit (marine_convoy);
	ai_vehicle_exit (marine_convoy_02);
	ai_vehicle_exit (chop_marines_backup_grp);
	ai_vehicle_exit (prechopper_convoy);
	ai_vehicle_exit (chop_marines_convoy);

	ai_vehicle_reserve (unit_get_vehicle (player0), true);
	ai_vehicle_reserve (unit_get_vehicle (player0), true);

	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_chop_lower_marines_full, 18), 0)), true);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_chop_lower_marines_full, 18), 1)), true);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_chop_lower_marines_full, 18), 2)), true);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_chop_lower_marines_full, 18), 3)), true);
	
	ai_set_objective (marine_convoy, chop_marines_lich_obj);
	ai_set_objective (marine_convoy_02, chop_marines_lich_obj);
	ai_set_objective (chop_marines_backup_grp, chop_marines_lich_obj);
	ai_set_objective (prechopper_convoy, chop_marines_lich_obj);
end

script static void lich_dying_scripts()
	wake (lich_escape);
	garbage_collecting = false;
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, lichy, "power_core" );
	thread (tort_chopper_cleanup());
	sleep (30 * 4);
	thread (display_chapter_075());
	f_unblip_flag (jetpack_help_flag);
	f_unblip_flag (jetpack_help_flag_lich);

	lich_alive_state = false;

	game_save_no_timeout();
end

script static void rail_gun_sp_sc()
	f_blip_flag (tort_rail_gun_flag, "ordnance");
	thread (unblip_tort_rg_flag());
	sleep_until (volume_test_players (tv_cav_target_laser_pickup), 1);
	ai_kill_silent (bt_sq);
	td_disabled = true;
	unit_drop_weapon(td_user, m40_lakeside_target_laser, 1);
	weapon_target_designator_hide_hud();
	sleep (1);
	if
		objects_distance_to_object (player0, m40_lakeside_target_laser) < 5
	then
		unit_enter_vehicle_immediate (player0, main_mammoth, "mac_d");
	elseif
		objects_distance_to_object (player1, m40_lakeside_target_laser) < 5
	then
		unit_enter_vehicle_immediate (player1, main_mammoth, "mac_d");
	elseif
		objects_distance_to_object (player2, m40_lakeside_target_laser) < 5
	then
		unit_enter_vehicle_immediate (player2, main_mammoth, "mac_d");
	elseif
		objects_distance_to_object (player3, m40_lakeside_target_laser) < 5
	then
		unit_enter_vehicle_immediate (player3, main_mammoth, "mac_d");		
	end
	sleep_until (chop_obj_state > 65);
	if
		unit_get_vehicle (player0) == main_mammoth
	then
		unit_exit_vehicle (player0);
	elseif
		unit_get_vehicle (player1) == main_mammoth
	then
		unit_exit_vehicle (player1);
	elseif
		unit_get_vehicle (player2) == main_mammoth
	then
		unit_exit_vehicle (player2);
	elseif
		unit_get_vehicle (player3) == main_mammoth
	then
		unit_exit_vehicle (player3);
	end
	f_unblip_flag (tort_rail_gun_flag);
end

script static void unblip_tort_rg_flag()
	sleep_s (30);
	f_unblip_flag (tort_rail_gun_flag);
end

script static void chop_leg_backup()
	sleep_until (not (volume_test_players_all_lookat (tv_chopper_marine_spawn, 3000, 40)));
	ai_place (chop_marine_backup_04);
end

script static void unblip_chop_lich_sc()
	sleep (30 * 8);
	print ("Unblipping Chop Lich");
	f_unblip_ai (chop_lich);
end

script static void check_early_lich_kill()
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) == 0.0);
	if
		lich_landed_at_chopper == false
	then
		print ("player has boarded and killed lich early");
		cs_run_command_script (chop_lich, it_is_a_good_day_to_die_cs);
		thread (camera_shake_now_lich());
		thread (lich_dying_scripts());
		lich_dead_early = true;
//	ai_place (chop_marine_backup_02);
//	ai_place (chop_marine_backup_03);
	end
end

script static void blip_chop_gauss()
	if
		not (unit_in_vehicle (chop_dead_marines.guy3))
		and
		not (player_in_vehicle (chop_gauss_waiting))
	then
		ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_d", true);
		ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_p", true);
		ai_vehicle_reserve_seat (unit_get_vehicle(player0), "warthog_p", true);
		ai_vehicle_reserve_seat (unit_get_vehicle(player1), "warthog_p", true);
		ai_vehicle_reserve_seat (unit_get_vehicle(player2), "warthog_p", true);
		ai_vehicle_reserve_seat (unit_get_vehicle(player3), "warthog_p", true);
	end
	sleep (30 * 5);
	if
		not (unit_in_vehicle (chop_dead_marines.guy3))
		and
		not (player_in_vehicle (chop_gauss_waiting))
	then
		ai_vehicle_enter (chop_dead_marines.guy3, chop_gauss_waiting, "warthog_g");
		sleep (30 * 7);
		f_blip_object (chop_gauss_waiting, "ordnance");
		sleep (30 * 2);			
		wake (f_dialog_40_gauss_hog_02);
		sleep (30 * 2);		
		//wake (f_dialog_m40_come_in_handy);
		sleep_until (player_in_vehicle (chop_gauss_waiting));
		ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_d", false);
		ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_p", false);
		ai_vehicle_reserve_seat (unit_get_vehicle(player0), "warthog_p", false);
		ai_vehicle_reserve_seat (unit_get_vehicle(player1), "warthog_p", false);
		ai_vehicle_reserve_seat (unit_get_vehicle(player2), "warthog_p", false);
		ai_vehicle_reserve_seat (unit_get_vehicle(player3), "warthog_p", false);
		f_unblip_object (chop_gauss_waiting);
	end
	thread (unblip_chop_gauss());
	thread (unreserve_chop_gauss());
end

script static void unreserve_chop_gauss()
	sleep (30 * 40);
	ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_d", false);
	ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_p", false);
end

script static void unblip_chop_gauss()
	sleep (30 * 15);
	ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_d", false);
	ai_vehicle_reserve_seat (chop_gauss_waiting, "warthog_p", false);
	ai_vehicle_reserve_seat (unit_get_vehicle(player0), "warthog_p", false);
	ai_vehicle_reserve_seat (unit_get_vehicle(player1), "warthog_p", false);
	ai_vehicle_reserve_seat (unit_get_vehicle(player2), "warthog_p", false);
	ai_vehicle_reserve_seat (unit_get_vehicle(player3), "warthog_p", false);
	sleep (30 * 30);
	f_unblip_object (chop_gauss_waiting);
end

script static void end_td_use()
	sleep (30 * 10);
	if
		dm_mode1 == false
	then
		ai_kill_silent (bt_sq);
		td_disabled = true;
		unit_drop_weapon(td_user, m40_lakeside_target_laser, 1);
		weapon_target_designator_hide_hud();
		print ("TD USE ENDED");
	end	
end

script static void prechopper_ai_kills()
	thread (tv_prechopper_04_kills());
	thread (tv_prechopper_02_kills());
	thread (prechopper_crate_destroys_01());
	ai_erase (sq_ridge_re);
end

script static void prechopper_crate_destroys_01()
	sleep_until (not (volume_test_players (tv_prechopper_safe_re))
	and
	not (volume_test_players (tv_prechopper_04))
	and
	not (volume_test_players_all_lookat (tv_prechopper_safe_re, 3000, 40))
	and
	not (volume_test_players_all_lookat (tv_prechopper_04, 3000, 40)));
	object_destroy_folder (prechopper_crates);
end

script static void tv_prechopper_04_kills()
	sleep_until (not (volume_test_players_all_lookat (tv_prechopper_04, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_prechopper_04));
	print ("tv_prechopper_04 killed");
end

script static void tv_prechopper_02_kills()
	sleep_until (not (volume_test_players_all_lookat (tv_prechopper_02, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_prechopper_02));
	print ("tv_prechopper_02 killed");
end

script dormant lich_pre_attack_scripts()
	sleep_until (volume_test_players (tv_jetpack_help), 1);
	game_save_no_timeout();
end

script dormant player_onboard_lich_flight_loop()
	sleep_until (volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);
	player_in_lich = true;
	wake (player_onboard_lich_killswitch);
	sleep_s(10);
	print ("onboard lich flight loop"); 
	lich_boarded_state = true;
	
	sound_looping_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\ambience\amb_m40_lich_int', NONE, 1);
	
	lichy->grav_lift_up_active (false);
	print ("grav lift off");
	ai_braindead (chop_lich, false);
	cs_run_command_script (chop_lich.driver, player_onboard_lich_flight_loop_cs);
	sleep_forever (jetpack_into_lich_guy1);
	sleep_forever (jetpack_into_lich_guy2);
end

script command_script player_onboard_lich_flight_loop_cs()
	lichy->grav_lift_up_active (true);
	lichy->grav_lift_door_state_open_set (true);
	print ("GRAV LIFT GOING UP");
	repeat
		cs_vehicle_speed (.2);

		if
			lich_alive_state == TRUE
		then	
			if
				volume_test_players (tv_lich_entire)
			then
				cs_fly_by (lich_entrance_pt.p23);
				print ("in loop, p23"); 
			else
				print ("player fell out, landing");
				cs_vehicle_speed (.5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);	
				lichy->grav_lift_up_active (true);
				lichy->grav_lift_door_state_open_set (true);
				print ("GRAV LIFT GOING UP");
				sleep_until (1 == 0
				or
				lich_alive_state == false
				);	
			end
		else
			print ("do nothing");
		end

		if
			lich_alive_state == TRUE
		then			
			if
				volume_test_players (tv_lich_entire)
			then
				cs_fly_by (lich_entrance_pt.p18);
				print ("in loop, p18"); 
			else
				print ("player fell out, landing");
				cs_vehicle_speed (.5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);	
				lichy->grav_lift_up_active (true);
				lichy->grav_lift_door_state_open_set (true);
				print ("GRAV LIFT GOING UP");
				sleep_until (1 == 0
				or
				lich_alive_state == false
				);	
			end
		else
			print ("do nothing");
		end
		
		if
			lich_alive_state == TRUE
		then					
			if
				volume_test_players (tv_lich_entire)
			then
				cs_fly_by (lich_entrance_pt.p15);
				print ("in loop, p15"); 
			else
				print ("player fell out, landing");
				cs_vehicle_speed (.5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);	
				lichy->grav_lift_up_active (true);
				lichy->grav_lift_door_state_open_set (true);
				print ("GRAV LIFT GOING UP");
				sleep_until (1 == 0
				or
				lich_alive_state == false
				);	
			end
		else
			print ("do nothing");
		end
		
		if
			lich_alive_state == TRUE
		then			
			if
				volume_test_players (tv_lich_entire)
			then
				cs_fly_by (lich_entrance_pt.p9);
				print ("in loop, p9"); 
			else
				print ("player fell out, landing");
				cs_vehicle_speed (.5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
				cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);	
				lichy->grav_lift_up_active (true);
				lichy->grav_lift_door_state_open_set (true);
				print ("GRAV LIFT GOING UP");
				sleep_until (1 == 0
				or
				lich_alive_state == false
				);	
			end	
		else
			print ("do nothing");
		end
			
	until (lich_alive_state == false);
end

script dormant player_onboard_lich_killswitch()
	sleep_until (lich_alive_state == false);
	sleep_forever (player_onboard_lich_flight_loop);
	ai_braindead (chop_lich, true);
	sleep_s(1);	
	ai_braindead (chop_lich, false);
	print ("lich about to be told to blow up");
	lichy->grav_lift_down_active (true);
	lichy->grav_lift_door_state_open_set (true);
	print ("GRAV LIFT GOING DOWN FOR PLAYER ESCAPE");	
	sleep_s(2);	
	cs_run_command_script (chop_lich.driver, it_is_a_good_day_to_die_cs);
end

script static void chopper_player_leave_dialogue()
	sleep_until (volume_test_players (kill_soft_post_chopper)
	or
	lich_alive_state == false);
	if 
		lich_alive_state == true
	then
		thread (m40_palmer_off_map_nudge());
	end
end

script command_script it_is_a_good_day_to_die_cs()
	print ("lich going to blow up");
	cs_vehicle_speed (.5);

	thread (lich_time_for_pup_sc());

	cs_fly_to_and_face (lich_entrance_pt.p29, lich_entrance_pt.p24);

	print ("lich arrived at final point in explosion path");
	cs_vehicle_speed (.7);

	cs_fly_to_and_face (lich_entrance_pt.p24, lich_entrance_pt.p30);
	
	print ("lich arrived at final point in explosion path");

	lichy->grav_lift_down_active (false);
	lichy->grav_lift_door_state_open_set (false);
	print ("GRAV LIFT OFF FROM PLAYER ESCAPE");	

end

script static void lich_time_for_pup_sc()
	sleep_until (volume_test_object (tv_lich_time_for_pup, lichy), 1);

	objects_attach (lichy, "", lich_octopus, "");

//	sleep(1);

	objects_detach (lichy, lich_octopus);
	
	pup_play_show (lich_crash_pup);

	print ("************** LICH PUPPETEER CRASH **************");	

	sleep_s (8);

	unit_kill_list_silent (volume_return_objects (tv_lich_entire));
	
	sleep (1);	
	thread (lich_explosion_debris());
//	thread (erase_chop_lich_sc());
//	print ("lich erased");
	ai_kill (upper_patrol_left);
	ai_kill (core_guard);
	ai_kill (lower_side_defense);
	ai_kill (lich_stairwell_guard);
	ai_kill (lower_patrol);
	ai_kill (lich_pilot_sq);
//	print ("lich patrols were killed");
	lich_exploded = true;
//	sleep (30 * 5);	
//	wake (M40_chopper_go_to_citadel);	
end

script static void erase_chop_lich_sc()
	ai_erase (chop_lich);
end

script static void lich_explosion_debris()
	thread (camera_shake_one());
	
	sound_impulse_start( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_lich_ride_power_core_ship_explode', chop_lich, 1);
	
//	effect_new (environments\solo\m10_crash\fx\designer_effects\emergency_light_red.effect, flag_lich03_explo_02 );
//	effect_new (environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect, chop_lich_explo_01 );
//	effect_new (environments\solo\m10_crash\fx\fire\fire_calmly_burning.effect, flag_lich03_explo_02 );
//	sleep (30 * .5 );
//	effect_new (environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect, chop_lich_explo_02 );
//	object_create (lich_debris_phantom_01);
//	object_create (lich_debris_phantom_02);
//	object_create (lich_debris_phantom_03);
//	object_create (lich_debris_phantom_04);
//	object_damage_damage_section (lich_debris_phantom_01, "body", 5000);
//	object_damage_damage_section (lich_debris_phantom_02, "body", 5000);
//	object_damage_damage_section (lich_debris_phantom_03, "body", 5000);
//	object_damage_damage_section (lich_debris_phantom_04, "body", 5000);
//	effect_new (environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect, chop_lich_explo_03 );
//	sleep (30 * .5 );
//	effect_new (environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect, chop_lich_explo_04 );
//	sleep (30 * .5 );
//	effect_new (environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect, chop_lich_explo_05 );
//	unit_kill_list_silent (volume_return_objects (tv_lich_entire));

	effect_new_on_object_marker(objects\vehicles\covenant\storm_lich\fx\lich_explosion\lich_explode_large.effect, lichy, "power_core" );
	if
		object_valid (lichy)
	then
		print ("lich still valid");
	end
	print ("Phantom debris EXPLOSION created");
end

script dormant lich_escape()
	sleep (30 * 5);
	wake (m40_lich_going_to_blow);
	sleep (30 * 10);
end

script static void lich_grav_lift()
	sleep_s(5);
	
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then			
//		sleep_s(5);
//		sleep_until (ai_living_count (hilltop_defense) < 6);
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//		then		
//			lichy->grav_lift_down_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			
//			ai_place (lich_hill_backup_01.spawn_points_1);
//			ai_place (lich_hill_backup_01.spawn_points_2);
//			sleep_s (3);
//			print ("3");
//			ai_place (lich_hill_backup_02);
//			sleep_s (8);
//			print ("8");
//			
//			lichy->grav_lift_up_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			print ("GRAV LIFT GOING UP");
//			sleep_s (8);
//			print ("8");
//		end
//	end
//
//
//		sleep_s(20);
//		sleep_until (ai_living_count (lich_hilltop_backup) < 3);
//
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then		
//			lichy->grav_lift_up_active (false);
//			lichy->grav_lift_down_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			
//			ai_place (lich_hill_backup_01.spawn_points_1);
//			ai_place (lich_hill_backup_01.spawn_points_2);
//			sleep_s (3);
//			print ("3");
//			ai_place (lich_hill_backup_02);
//			sleep_s (8);
//			print ("8");
//			
//			lichy->grav_lift_up_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			print ("GRAV LIFT GOING UP");
//			sleep_s (8);
//			print ("8");
//			print ("GRAV LIFT OFF");
//			lichy->grav_lift_up_active (false);
//			lichy->grav_lift_door_state_open_set (false);
//		end
//		
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then	
//			sleep_s(20);
//			sleep_until (ai_living_count (lich_hilltop_backup) < 3);
//		end
//
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then		
//			lichy->grav_lift_up_active (false);
//			lichy->grav_lift_down_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			
//			ai_place (lich_hill_backup_01);
//			sleep_s (3);
//			print ("3");
//			ai_place (lich_hill_backup_02);
//			sleep_s (8);
//			print ("8");
//			
//			lichy->grav_lift_up_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			print ("GRAV LIFT GOING UP");
//			sleep_s (8);
//			print ("8");
//			print ("GRAV LIFT OFF");
//			lichy->grav_lift_up_active (false);
//			lichy->grav_lift_door_state_open_set (false);
//		end
//
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then	
//			sleep_s(25);
//			sleep_until (ai_living_count (lich_hilltop_backup) < 3);
//		end
//		
//		if
//			lich_alive_state == TRUE	
//			and
//			lich_boarded_state == FALSE
//			and
//			player_at_lich_mound == FALSE
//		then		
//			lichy->grav_lift_up_active (false);
//			lichy->grav_lift_down_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			
//			ai_place (lich_hill_backup_01);
//			sleep_s (3);
//			print ("3");
//			ai_place (lich_hill_backup_02);
//			sleep_s (8);
//			print ("8");
//			
//			lichy->grav_lift_up_active (true);
//			lichy->grav_lift_door_state_open_set (true);
//			print ("GRAV LIFT GOING UP");
//		end
		
//		sleep_until (lich_boarded_state == true);

		lichy->grav_lift_up_active (true);
		lichy->grav_lift_door_state_open_set (true);
		print ("*************!!!!!!!!!!!GRAV LIFT GOING UP FOREVER!!!!!!!!!!!*************");
end

script static void tv_chop_side_entire_kills()
	sleep_until (not (volume_test_players_all_lookat (tv_chop_side_entire, 3000, 40))
	and
	not (volume_test_players (tv_chop_side_entire)));
	unit_kill_list_silent (volume_return_objects (tv_chop_side_entire));
	print ("tv_lich_hilltop_kills killed");
end

script static void tv_lich_hilltop_kills()
	sleep_until (not (volume_test_players_all_lookat (tv_hilltop_front_entire, 3000, 40))
	and
	not (volume_test_players (tv_hilltop_front_entire)));
	unit_kill_list_silent (volume_return_objects (tv_hilltop_front_entire));
	print ("tv_lich_hilltop_kills killed");
end

script static void tv_chop_lower_entire_kills()
	sleep_until (not (volume_test_players_all_lookat (tv_chop_lower_entire, 3000, 40))
	and
	not (volume_test_players (tv_chop_lower_entire)));
	unit_kill_list_silent (volume_return_objects (tv_chop_lower_entire));
	print ("tv_lich_hilltop_kills killed");
end


//script static void my_lich_fx()
//	repeat
//		print ("GRAV LIFT GOING UP");
//		lichy->grav_lift_down_active (false);
//		lichy->grav_lift_up_active (true);
//		sleep_s (10);
//		print ("GRAV LIFT GOING DOWN");
//		lichy->grav_lift_up_active (false);
//		lichy->grav_lift_down_active (true);
//	until (1 == 0);
//end

script static void my_lich_explode_fx()
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) == 0.0);

	f_unblip_object (chop_gauss_waiting);

	//call klaxon sound here
	
	// stop the regular looping sound and switch to the damaged version
	sound_looping_stop ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\ambience\amb_m40_lich_int');
	sound_looping_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\ambience\amb_m40_lich_int_damaged', NONE, 1);
	
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, lichy, "power_core" );

	sleep_until (not (object_valid (lichy)));
	
	//call klaxon out here
	
end

script dormant blip_chopper_gun()
	sleep_until (volume_test_players (tv_chopper_blip_gun)
	or
	volume_test_players (tv_chopper_05)
	, 1);
	if
		chopper_cannon_alive == true
	then
		f_blip_object (cannon_chopper_new, "neutralize");
	end
end

script dormant complex_sleep_until_part2()

	sleep_s(4);
	
	cs_shoot (chop_lich, false);
	
	cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p27, lich_entrance_pt.p28);

	cs_vehicle_speed (chop_lich, .01);
	repeat
		begin_random
		
			begin
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p1, lich_new_flight_pt.p4);
					sleep_s(3);
					print ("in loop, p1,4"); 
				else
					print ("rushing to land"); 
				end
			end
			
			begin		
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p1, lich_new_flight_pt.p0);
					sleep_s(4);	
					print ("in loop, p1,0");
				else
					print ("rushing to land"); 
				end
			end

			begin					
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p2, lich_new_flight_pt.p0);
					sleep_s(3);	
					print ("in loop, p2,0");
				else
					print ("rushing to land"); 
				end
			end

			begin					
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p2, lich_new_flight_pt.p4);
					sleep_s(3);	
					print ("in loop, p2,4");
				else
					print ("rushing to land"); 
				end
			end

			begin					
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p3, lich_new_flight_pt.p0);
					sleep_s(4);	
					print ("in loop, p3,0");
				else
					print ("rushing to land"); 
				end
			end

			begin					
				if 
					chop_obj_state < 66
				then
					cs_fly_to_and_face (chop_lich.driver, 1, lich_new_flight_pt.p0, lich_new_flight_pt.p4);
					sleep_s(5);	
					print ("in loop, p0,4");
				else
					print ("rushing to land"); 
				end
			end
				
		end
	until (chop_obj_state > 65);
	
	f_unblip_object (chop_gauss_waiting);

	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_chopper_lich_hover', chop_lich, 1);
	cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_pelican_intro_flyaway, pelican_dropoff_octopus', 1);
//	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_lich_ride_power_core_shield_down', object_at_marker( lichy, "power_core" ), 1);

	cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);
	
	ai_braindead(chop_lich, true);
	wake (lich_interior_obj_state_sc); // watch location of player in lich
	wake (lich_interior_sound_state);
	lichy->grav_lift_down_active (true);
	lichy->grav_lift_door_state_open_set (true);
	print ("old complex sleep until is sleeping forever"); 


	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_01);
		sleep (30 * 3);
	end

	if
		not (volume_test_players (tv_lich_entire))
	then	
		thread (spawn_hilltop_defense_02());
	end	
	
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_turret_01);
		sleep (30 * 3);
	end
	
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_turret_02);
		sleep (30 * 3);
	end	

	if
		not (volume_test_players (tv_lich_entire))
	then	
		ai_place (hilltop_defense_03);
		sleep (30 * 3);
	end	

	if
		not (volume_test_players (tv_lich_entire))
	then
		thread (spawn_hilltop_central());
		ai_place (hilltop_defense_elite);
		sleep (30 * 3);
	end	
	
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_03_elite);
		thread (spawn_onboard_lich_sq());
		print ("lich squads placed"); 
	end
	
	thread (lich_grav_lift());
	
	lich_rest_state = 10;

	game_save_no_timeout();

	lich_rest_state = 20;

	sleep (30 * 2);

//	wake (M40_chopper_mammoth_boarding_done);	

	wake (M40_chopper_lich_over_mound);
	thread (blip_lich());
//	print ("lich blipped"); 
	
	wake (chop_marine_jetpackers_spawn);
	
	wake (chopper_hilltop_checkpoint);
	
//	sleep_until	
//		(ai_living_count (chop_ghost_04_sq) < 2
//		and
//		ai_living_count (chop_wraith_01_sq) < 1		
//		and
//		ai_living_count (chop_wraith_02_sq) < 2
//		or
//		ai_living_count (hilltop_defense) > 2	
//		and
//		volume_test_players (tv_hilltop_defense)
//		or
//		volume_test_players (tv_chopper_hilltop)			
//		);

end

script static void spawn_hilltop_central()
	sleep_until (not (volume_test_players_all_lookat (tv_spawn_chop_central_hill, 3000, 40)));
	if
		player_in_lich == FALSE
	then
		ai_place (hilltop_central);
		print ("hilltop_central guys made it in"); 
	else
		print ("hilltop_central guys did NOT MAKE IT IN"); 
	end
end

script static void spawn_hilltop_defense_02()
	sleep_until (not (volume_test_players_all_lookat (tv_spawn_chop_hilltop_defense_02, 3000, 40)));
	if
		player_in_lich == FALSE
	then
		ai_place (hilltop_defense_02);
		print ("hilltop_defense_02 guys made it in"); 
	else
		print ("hilltop_defense_02 guys did NOT MAKE IT IN"); 
	end
end

script dormant chop_marine_jetpackers_spawn()
	sleep_until (not (volume_test_players_all_lookat (tv_spawn_lich_jetpackers, 3000, 60)));
	ai_place (chop_marine_jetpackers);
	object_create (chopper_jetpackers_mongoose);
	ai_vehicle_enter_immediate (chop_marine_jetpackers.guy1, chopper_jetpackers_mongoose, "warthog_d");
	ai_vehicle_enter_immediate (chop_marine_jetpackers.guy2, chopper_jetpackers_mongoose, "warthog_g");
//	ai_allegiance (player, human);
//	ai_allegiance (brute, human);
	print ("MARINES ARE GOING TO JETPACK INTO THE LICH!"); 
end

script dormant chopper_hilltop_checkpoint()
	sleep_until (volume_test_players (tv_chopper_hilltop), 1);
	game_save_no_timeout();
end

script static void blip_lich()
	sleep_until (unit_has_equipment (player0, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player1, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player2, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	or
	unit_has_equipment (player3, objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment)
	, 1);

	f_blip_object (object_at_marker (lichy, "power_core"), "neutralize");
	
	//f_blip_auto_object_trigger(object_at_marker (lichy, "power_core"), "neutralize", tv_lich_entire, true);

	//lich_blip_var = f_blip_auto_object_trigger(object_at_marker (lichy, "power_core"), "neutralize", tv_lich_entire, true);
	
	//f_blip_auto_object_trigger(object_at_marker (lichy, "power_core"), "default", tv_lich_entire, false, lich_blip_var);
	
	print ("Lich blipped because at least one player has jetpack"); 		
end

script static void spawn_onboard_lich_sq()
	sleep_until (volume_test_players (tv_below_lich), 1);
	
	thread (tv_lich_hilltop_kills());
	thread (tv_chop_side_entire_kills());
	thread (tv_chop_lower_entire_kills());

	ai_braindead (chop_lich, true);
	ai_place(lich_pilot_sq);	
	ai_place(upper_patrol_left);
	ai_place(core_guard);
	ai_place(lower_side_defense);
	ai_place(lich_stairwell_guard);
	thread (lower_patrol_spawn());

//	object_create_folder (lich_crates);
end
	
script static void lower_patrol_spawn()
	sleep_until	(ai_living_count (hilltop_central) < 2);
	ai_place(lower_patrol);
end

script static void garbage_collect_chop()
	repeat
		sleep_until (volume_test_players (tv_tortoise_bottom_01), 1);
		garbage_collect_now();
		game_save_no_timeout();
		print ("garbage collected and saved"); 
		sleep_until (not (volume_test_players (tv_tortoise_bottom_01)), 1);
	until (1 == 0);
end

script dormant blip_sniper_rifles()
  sleep_until( volume_test_players(tv_waterfall_dialogue_03), 1);  
  game_insertion_point_unlock (7);
	sleep (30 * 8);
	if 
	(
	(not (unit_has_weapon (player0, objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon))
	and
	player_valid (player0))
		
	or
	
	(not (unit_has_weapon (player1, objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon))
	and
	player_valid (player1))	
	
	or
	
	(not (unit_has_weapon (player2, objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon))
	and
	player_valid (player2))
		
	or
	
	(not (unit_has_weapon (player3, objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon))
	and
	player_valid (player3))
	
	)
	then
		thread (refresh_snipers());
		sleep (30 * 1);
		f_blip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_right")), "ordnance");
		f_blip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_left")), "ordnance");
		print ("At least one player didn't have a sniper, so blipping them for a bit"); 
		
	if 
		game_coop_player_count() > 1
	then		
		thread (unblip_tort_snipers());
		sleep_until (volume_test_players (tv_careful_chief), 1);
	else
		sleep_until (unit_has_weapon (player_get_first_valid(), objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon)
		or
		volume_test_players (tv_careful_chief), 1);
	end	
		f_unblip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_left")));
		f_unblip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_right")));
		wake (f_valley_blip);	
	else
		wake (f_valley_blip);	
		sleep_forever();
	end
end

script static void unblip_tort_snipers()
		sleep (30 * 10);
		f_unblip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_left")));
		f_unblip_object ((object_at_marker ( main_mammoth, "crate_3fl_sniper_right")));
end

script static void refresh_snipers()
	object_destroy ((object_at_marker ( main_mammoth, "crate_3fl_sniper_right")));
	object_create (sniper_refresh_01);
	objects_attach (main_mammoth,  "crate_3fl_sniper_right", sniper_refresh_01, "");
	
	object_destroy ((object_at_marker ( main_mammoth, "crate_3fl_sniper_left")));
	object_create (sniper_refresh_02);
	objects_attach (main_mammoth,  "crate_3fl_sniper_left", sniper_refresh_02, ""); 
end

script dormant chopper_bypass_check()
	print ("CHOPPER BYPASS TEST IS RUNNING"); 
	sleep_until (prechop_recording_loaded == true
	and
	volume_test_players (tv_chopper_03), 1);
	if (volume_test_object (tv_prechopper_entire, main_mammoth))
		then 
		print ("player skipped ahead to chopper and tortoise is still in prechop, speeding it up");
		sleep_forever (prechopper_tortoise_recorded);
		sleep_forever (chopper_tort_ready);
		chopper_rollout_rdy	= true;
		print ("prechopper_tortoise_recorded SLEEP FOREVER");
		sleep(1);
		sleep_forever (prechopper_tortoise_recorded_insertion);
		if
			tort_bay_doors_opened == true
		then
			thread (close_tort_doors_prechopper_end());
		end	
		unit_recorder_pause (main_mammoth, false);
		sleep_s(1);
		unit_recorder_set_playback_rate (main_mammoth, 1.9);
		print ("TORT SPEED = 1.9");
				
//		sleep_until (volume_test_object (tv_tort_prechop_last_stop, main_mammoth));
	
		sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 36, 1);
	
		print ("HIT!");
		
		unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_e);
		print ("tortoise_0716_e loaded in fast mode");
		prechop_recording_loaded_2 = true;
		unit_recorder_play_and_blend (main_mammoth, 2);
		unit_recorder_pause (main_mammoth, true);
		tort_stopped = TRUE;
		
		wake (chop_tortoise_recorded);

		sleep_forever (chopper_bypass_check);
		else
		print ("player and tortoise are nearby in chopper, all is well with the world");
		sleep_forever (chopper_bypass_check);		
		end
end

script dormant chopper_obj_control_01()
	sleep_until (volume_test_players (tv_chopper_01), 1);
	chop_obj_state = 10;
	print ("chop_obj_state=10");
	
	sleep_until (volume_test_players (tv_chopper_02), 1);
	chop_obj_state = 20;
	print ("chop_obj_state=20");
	
	sleep_until (volume_test_players (tv_chopper_03), 1);
	chop_obj_state = 30;
	print ("chop_obj_state=30");
	
	sleep_until (volume_test_players (tv_chopper_04)
	or
	volume_test_players (tv_chopper_05)
	, 1
	);
	chop_obj_state = 60;
	print ("chop_obj_state=60");	
	
	sleep_until (volume_test_players (tv_lich_entire), 1);
	chop_obj_state = 80;
	print ("chop_obj_state=80");	

//	if
//		lich_landed_at_chopper == TRUE
//		and
//		rgt_bool == false
//	then
		kill_script (chopper_main_script);
		sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) <= 0, 1
		);
		chop_obj_state = 90;
		print ("chop_obj_state=90");
		print ("++++++++++************ IF YOU SEE ME BEFORE YOU'VE SHOT THE LICH CORE THEN BUG NOW RIGHT NOW!!!!!+++++********");
		kill_volume_disable (kill_soft_post_chopper);
		wake (leave_chopper);
		wake (waterfall_pre_sq);
		wake (waterfall_tortoise_recorded);
		wake (M40_citadel_investigate);
		wake (blip_sniper_rifles);
		sleep (30 * 5);
	 	thread(f_mus_m40_e05_finish());
	
end

script static void chopper_marine_backup()
	sleep_until (
	(ai_living_count (marine_convoy) + 
	ai_living_count (marine_convoy_02) + 
	ai_living_count (prechopper_marines_fill) < 3)
	and
	ai_living_count (chop_lich) > 0
	and
	(not (volume_test_players_all_lookat (tv_chopper_marine_spawn, 3000, 40)))
	);
 	sleep (30 * 2);
//	begin_random_count(1)
//		begin
			ai_place (chop_marine_backup_01);
			print ("placed marine backup option 1");
//		 	sleep (30 * 9);
//			f_blip_ai (chop_marine_backup_01.hog_01_driver, "ordnance");
//			sleep (30 * 7);
//			f_unblip_ai (chop_marine_backup_01.hog_01_driver);
//		end
//		begin
//			ai_place (chop_marine_backup_02);
//			print ("placed marine backup option 2");
//			sleep (30 * 6);
//			f_blip_ai (chop_marine_backup_02.goose_01_driver, "ordnance");
//			sleep (30 * 7);
//			f_unblip_ai (chop_marine_backup_02.goose_01_driver);
//		end
//		begin
//			ai_place (chop_marine_backup_03);
//			print ("placed marine backup option 3");
//		 	sleep (30 * 9);
//			f_blip_ai (chop_marine_backup_03.hog_01_driver, "ordnance");
//			sleep (30 * 7);
//			f_unblip_ai (chop_marine_backup_03.hog_01_driver);
//		end
//		begin
//			ai_place (chop_marine_backup_04);
//			print ("placed marine backup option 4");
//			f_blip_ai (chop_marine_backup_04.hog_01_driver, "ordnance");
//			sleep (30 *20);
//			f_unblip_ai (chop_marine_backup_04.hog_01_driver);
//		end
//	end
//	thread (chopper_marine_backup_02());
end

script command_script chopper_backup_go_here_first()
	cs_go_to (chop_marines_pelican_01_pt.p3);
end

script command_script chopper_backup_go_here_first_2()
	cs_go_to (chop_marines_pelican_01_pt.p12);
end

script command_script chopper_backup_go_here_first_3()
	cs_go_to (chop_marines_pelican_01_pt.p13);
end

script static void blip_the_lich()
	f_blip_object (object_at_marker (lichy, "power_core"), "neutralize");
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) < 1);

	// sound for shield disappearing
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_lich_ride_power_core_shield_down', object_at_marker( lichy, "power_core" ), 1);
	print ("lich power core health is less than 1");
	
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) > 1);
	
	print ("lich power core health is greater than 1???");
end

//--------------------chopper bowl command scripts-------------------

script command_script chop_dead_marine_setup()
	ai_kill_silent (chop_dead_marines.guy1);
	ai_kill_silent (chop_dead_marines.guy2);
	pup_play_show ("chop_marine_bunker_pup");	
end

script command_script lich_shoot_tortoise2()
	cs_shoot_point (true, tort_top_patrol.p12);
	sleep_s(4);
	print ("lich fired at tortoise");
	target_designator_disabled = true;
	thread (tort_health_low());
end

script static void tort_health_low()
	sleep_s(5);
	unit_set_current_vitality (main_mammoth, .1, .1);
end

script command_script lich_shoot_tortoise3()
	cs_shoot_point (true, chop_tortoise_pt.p17);
	sleep_s(4);
	print ("lich fired at tortoise2");
end

script command_script lich_entrance_with_complex_dormant()
	print ("lich entrance!");
	cs_vehicle_speed (1);
	cs_fly_to_and_face (misc_veh_pt.p12, misc_veh_pt.p14);
//	cs_shoot_point (true, tort_top_patrol.p12);
	cs_shoot_point (true, misc_veh_pt.p15);
	print ("lich fired at tortoise step 1");
	sleep_s(5);
	print ("lich fired at tortoise step 2");
	cs_shoot (false);
	target_designator_disabled = true;
	cs_fly_to_and_face (lich_entrance_pt.p0, misc_veh_pt.p13);
	cs_vehicle_speed (1);
	print ("lich entrance p1");
	print ("lich fired at tortoise");
//	wake (complex_sleep_until_loop);
//	wake (complex_sleep_until_part2);
	cs_run_command_script (chop_lich, complex_sleep_until_part3);
	wake (player_onboard_lich_flight_loop);
end

script static void chop_hilltop_control()

	sleep_until (volume_test_players (tv_chopper_hilltop)
	or
	volume_test_players (tv_hilltop_defense)
	or
	volume_test_players (tv_lich_entire)
	or
	chop_obj_state > 65);
	
	thread (tv_lich_hilltop_kills());
	
	player_approaching_hilltop = true;
	
	thread (player_at_lich_mound_sc());
	
	wake (chop_marine_jetpackers_spawn);

	wake (lich_pre_attack_scripts);
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) <= 0, 1
	);
		
	wake (m40_lich_head_out);

	thread (lich_spartans_escape_1());	
	thread (lich_spartans_escape_2());	
		
	thread (camera_shake_now_lich());

 	sleep (30 * 11);
	
	thread (display_jetpack_tut());
	
	thread (lich_dying_scripts());

end

script static void player_at_lich_mound_sc()
	sleep_until (volume_test_players (tv_chopper_hilltop));
	player_at_lich_mound = true;
end

script command_script complex_sleep_until_part3()
	print ("lich hover!");
	thread (chop_hilltop_control());
	cs_shoot (false);
	cs_vehicle_speed (.5);
	
	cs_fly_to (chop_lich.driver, 1, lich_new_entrance_pt.p0);
//	cs_fly_to (chop_lich.driver, 1, lich_new_entrance_pt.p1);

	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_chopper_lich_hover', chop_lich, 1);
	cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p26, lich_entrance_pt.p5);
	cs_vehicle_speed (.2);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_pelican_intro_flyaway, pelican_dropoff_octopus', 1);
	cs_fly_to_and_face (chop_lich.driver, 1, lich_entrance_pt.p4, lich_entrance_pt.p5);
	cs_vehicle_speed (.5);
		
	lich_landed_at_chopper = true;
	
	ai_braindead(chop_lich, true);
	wake (lich_interior_obj_state_sc); // watch location of player in lich
	wake (lich_interior_sound_state);

//	sleep_until (chop_obj_state > 65);
//	sleep_until (player_approaching_hilltop == true);

	lichy->grav_lift_down_active (true);
	lichy->grav_lift_door_state_open_set (true);
	print ("old complex3 sleep until is sleeping forever"); 


	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_01);
		sleep (30 * 3);
	end

	if
		chop_obj_state > 65
		and
		not (volume_test_players (tv_lich_entire))
	then	
		thread (spawn_hilltop_defense_02());
	end	
	
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_turret_01);
		sleep (30 * 3);
	end
	
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_turret_02);
		sleep (30 * 3);
	end	

	if
		not (volume_test_players (tv_lich_entire))
	then	
		ai_place (hilltop_defense_03);
		sleep (30 * 3);
	end	

	if
		not (volume_test_players (tv_lich_entire))
	then
		thread (spawn_hilltop_central());
		sleep (30 * 3);
	end	

	if
		chop_obj_state > 65
		and
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_elite);
		sleep (30 * 3);
	end	
		
	if
		not (volume_test_players (tv_lich_entire))
	then
		ai_place (hilltop_defense_03_elite);
		thread (spawn_onboard_lich_sq());
		print ("lich squads placed"); 
	end
	
	thread (lich_grav_lift());
	
	lich_rest_state = 10;

	game_save_no_timeout();

	lich_rest_state = 20;

	sleep_until (volume_test_players (tv_chopper_hilltop)
	or
	volume_test_players (tv_hilltop_defense)
	or
	volume_test_players (tv_lich_entire)
	or
	chop_obj_state > 65);

	wake (M40_chopper_lich_over_mound);

	sleep (30 * 2);

	thread (blip_lich());
	
	wake (chopper_hilltop_checkpoint);
end

//script command_script lich_entrance_with_complex_dormant2()
//	print ("lich_entrance_with_complex_dormant2");
//	cs_fly_to_and_face (lich_test.p0, lich_test.p1);
//	print ("flew to point 0");
//end
//
//script command_script lich_shoot_test()
//	cs_shoot_point (true, misc_veh_pt.p15);
//	print ("1");
//	sleep_s(10);
//	print ("2");
//end

//script command_script chop_marines_backup_01_cs()
//	print ("chop_marines_backup_01 spawned");
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_marine_pelican.driver), "pelican_lc", ai_vehicle_get_from_spawn_point  (chop_marine_gauss.hog_01_driver));
//	ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point  (chop_marine_gauss.hog_01_driver), "warthog_d", true);
//	wake (unreserve_chopper_gauss);
//	sleep_s(5);
//	cs_fly_by (chop_marines_pelican_01_pt.p8); 
//	cs_fly_by (chop_marines_pelican_01_pt.p9); 
//	f_blip_ai (chop_marine_gauss.hog_01_driver, "ordnance");
//	cs_fly_to_and_face (chop_marines_pelican_01_pt.p10, chop_marines_pelican_01_pt.p11); 
//	sleep_s(1);
//	vehicle_unload (ai_vehicle_get (chop_marine_pelican.driver), "pelican_lc");
//	sleep_s(1);
//	wake (unblip_chop_gauss_get_in);
//	wake (unblip_chop_gauss_time);
//	cs_fly_by (chop_marines_pelican_01_pt.p7);
//	cs_fly_by (chop_marines_pelican_01_pt.p1);
//	cs_fly_by (chop_marines_pelican_01_pt.p0); 
//	cs_fly_by (chop_marines_pelican_01_pt.p5);
//	cs_fly_by (chop_marines_pelican_01_pt.p6);
//	ai_erase (chop_marine_pelican);
//end

script dormant unreserve_chopper_gauss()
	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point  (chop_marine_gauss.hog_01_driver)));
	ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point  (chop_marine_gauss.hog_01_driver), "warthog_d", false);
	print ("chopper gauss hog unreserved");
	sleep (30 * 10);	
end

script dormant unblip_chop_gauss_get_in()
	sleep_until (player_in_vehicle (ai_vehicle_get_from_starting_location (chop_marine_gauss.hog_01_driver))
	or
	ai_in_vehicle_count (chop_marine_gauss) < 1
	);
	f_unblip_ai (chop_marine_gauss.hog_01_driver);
end

script dormant unblip_chop_gauss_time()
	sleep_s(20);
	f_unblip_ai (chop_marine_gauss.hog_01_driver);
end

script command_script chop_phantom_01_cs()
	print ("phantom spawned");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom1_spawn', chop_phantom_01_sq, 1);
//	cs_vehicle_speed (1);
	cs_fly_by (chop_phantom_01_pt.p0); 
	cs_fly_by (chop_phantom_01_pt.p1); 
	
	cs_fly_to_and_face (chop_phantom_01_pt.p2, chop_phantom_01_pt.p3); 
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom1_takeoff', chop_phantom_01_sq, 1);
	cs_fly_by (chop_phantom_01_pt.p4);
	cs_fly_by (chop_phantom_01_pt.p5); 
	cs_fly_by (chop_phantom_01_pt.p6);
	cs_fly_by (chop_phantom_01_pt.p7);
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_02_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom2_spawn', chop_phantom_02_sq, 1);
	cs_fly_by (chop_phantom_02_pt.p10);
//	cs_fly_to_and_face (chop_phantom_02_pt.p0, chop_phantom_02_pt.p1); 
	cs_fly_by (chop_phantom_02_pt.p3);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom2_takeoff', chop_phantom_02_sq, 1);
	cs_fly_by (chop_phantom_02_pt.p8);
	cs_fly_by (chop_phantom_02_pt.p9);
	cs_fly_by (chop_phantom_02_pt.p5); 
	cs_fly_by (chop_phantom_02_pt.p6);
	cs_fly_by (chop_phantom_02_pt.p7);
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_03_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom3_spawn', chop_phantom_03_sq, 1);
	cs_vehicle_speed (1);
	cs_vehicle_boost (true);
	cs_fly_by (chop_phantom_03_pt.p1); 
	cs_fly_by (chop_phantom_03_pt.p2);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_lc");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom3_takeoff', chop_phantom_03_sq, 1);
	cs_fly_by (chop_phantom_03_pt.p3); 
	cs_fly_by (chop_phantom_03_pt.p4);
	cs_fly_by (chop_phantom_03_pt.p5);
	cs_fly_by (chop_phantom_03_pt.p6);
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_04_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom4_spawn', chop_phantom_04_sq, 1);
	cs_vehicle_speed (1);
	cs_vehicle_boost (true);
	cs_fly_by (chop_phantom_04_pt.p1); 
	cs_fly_by (chop_phantom_04_pt.p2);
	cs_fly_by (chop_phantom_04_pt.p3); 
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom4_takeoff', chop_phantom_04_sq, 1);
	cs_fly_by (chop_phantom_04_pt.p4);
	cs_fly_by (chop_phantom_04_pt.p5);
	cs_fly_by (chop_phantom_04_pt.p6);
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_05_cs()
	print ("phantom 5 spawned");
//	cs_vehicle_speed (1);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom5_spawn', chop_phantom_05_sq, 1);
	cs_fly_by (chop_phantom_05_pt.p0);
	cs_fly_by (chop_phantom_05_pt.p1);
	cs_fly_by (chop_phantom_05_pt.p2);
	cs_fly_by (chop_phantom_05_pt.p10);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom5_takeoff', chop_phantom_05_sq, 1);
	print ("phantom 5 unloaded vehicles");
	cs_fly_by (chop_phantom_05_pt.p11);
	cs_fly_by (chop_phantom_05_pt.p6);
	cs_fly_by (chop_phantom_05_pt.p7); 
	cs_fly_by (chop_phantom_05_pt.p8);
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_06_cs()
	print ("phantom 6 spawned");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom6_spawn', chop_phantom_06_sq, 1);
	cs_fly_by (chop_phantom_06_pt.p0);
	cs_fly_by (chop_phantom_06_pt.p1);
	cs_fly_by (chop_phantom_06_pt.p2);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	cs_fly_to_and_face (chop_phantom_07_pt.p3, chop_phantom_07_pt.p4);
	f_unload_phantom( chop_phantom_06_sq, "left" );	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom6_takeoff', chop_phantom_06_sq, 1);
	cs_fly_by (chop_phantom_06_pt.p3);
	cs_fly_by (chop_phantom_06_pt.p4);
	cs_fly_by (chop_phantom_06_pt.p5); 
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_07_cs()
	print ("phantom 7 spawned");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom7_spawn', chop_phantom_07_sq, 1);
	cs_fly_by (chop_phantom_07_pt.p0);
	cs_fly_by (chop_phantom_07_pt.p1);
	cs_fly_by (chop_phantom_07_pt.p2);
	cs_fly_by (chop_phantom_07_pt.p5); 
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_lc");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom7_takeoff', chop_phantom_07_sq, 1);
	cs_fly_by (chop_phantom_04_pt.p2); 
	cs_fly_by (chop_phantom_04_pt.p1); 
	cs_fly_by (chop_phantom_04_pt.p0); 
	cs_fly_by (chop_phantom_04_pt.p7); 
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_08_cs()
	print ("phantom 8 spawned");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom8_spawn', chop_phantom_08_sq, 1);
	cs_fly_by (chop_phantom_06_pt.p0);
	cs_fly_by (chop_phantom_06_pt.p1);
	cs_fly_by (chop_phantom_06_pt.p2);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_sc02");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom8_takeoff', chop_phantom_08_sq, 1);
	cs_fly_by (chop_phantom_06_pt.p3);
	cs_fly_by (chop_phantom_06_pt.p4);
	cs_fly_by (chop_phantom_06_pt.p5); 
	ai_erase (ai_current_actor);
end

script command_script chop_phantom_09_cs()
	print ("phantom 9 spawned");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom9_spawn', chop_phantom_09_sq, 1);
	cs_fly_by (chop_phantom_09_pt.p0);
	cs_fly_by (chop_phantom_09_pt.p1);
	cs_fly_by (chop_phantom_09_pt.p2);
	vehicle_unload (ai_vehicle_get (ai_current_actor), "phantom_lc");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom9_takeoff', chop_phantom_09_sq, 1);
	cs_fly_by (chop_phantom_04_pt.p2); 
	cs_fly_by (chop_phantom_04_pt.p1); 
	cs_fly_by (chop_phantom_04_pt.p0); 
	cs_fly_by (chop_phantom_04_pt.p7); 
	ai_erase (ai_current_actor);
end

//script command_script chop_phantom_10_cs()
//	print ("phantom 10 spawned");
//	
//	ai_place (chop_marine_backup_02);
//	ai_place (chop_marine_backup_03);
//
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_10_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_marine_backup_02.driver));
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_10_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_marine_backup_03.hog_01_driver));
//
//	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom9_spawn', chop_phantom_09_sq, 1);
//	cs_fly_by (chop_phantom_10_pt.p0);
//	cs_fly_by (chop_phantom_10_pt.p8);
//	cs_fly_by (chop_phantom_10_pt.p9);
//	vehicle_unload (ai_vehicle_get (chop_phantom_10_sq.driver), "phantom_sc01");
//	vehicle_unload (ai_vehicle_get (chop_phantom_10_sq.driver), "phantom_sc02");
//	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantom9_takeoff', chop_phantom_09_sq, 1);
//	cs_fly_by (chop_phantom_10_pt.p6); 
//	cs_fly_by (chop_phantom_10_pt.p10); 
//	ai_erase (chop_phantom_10_sq);
//end

script command_script lich_jetpackers_1()
	cs_go_to (misc_veh_pt.p6);
	ai_vehicle_exit (chop_marine_jetpackers.guy1);
	ai_vehicle_exit (chop_marine_jetpackers.guy2);
	ai_vehicle_reserve (chopper_jetpackers_mongoose, true);
	wake (jetpack_into_lich_sc);
end

script command_script lich_jetpackers_2()
	cs_go_to (misc_veh_pt.p6);
end

script dormant jetpack_into_lich_sc()
	sleep_s (6);
	sleep_until (ai_task_count (chopper_cov_inf_obj.top_center) < 1
	and
	volume_test_players (tv_chopper_hilltop), 1);
	print ("LICH MARINES MAKING THEIR JUMPS!");
	cs_run_command_script (chop_marine_jetpackers.guy1, jetpack_into_lich_guy1);
	cs_run_command_script (chop_marine_jetpackers.guy2, jetpack_into_lich_guy2);
end

script command_script jetpack_into_lich_guy1()
	cs_go_to (misc_veh_pt.p7);
	sleep_until (volume_test_players_all_lookat (tv_jetpack_help_lower, 500, 40)
	or
	volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);	
	print ("Player is looking at jetpacking Marines JUMP 1");	
	cs_go_to (misc_veh_pt.p9);
	sleep_until (volume_test_players_all_lookat (tv_jetpack_help, 500, 40)
	or
	volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);
	print ("Player is looking at jetpacking Marines JUMP 2");	
	ai_set_objective (chop_marine_jetpackers, chop_marines_lich_interior);
	cs_go_to (misc_veh_pt.p10);
end

script command_script jetpack_into_lich_guy2()
	cs_go_to (misc_veh_pt.p8);
	sleep_until (volume_test_players_all_lookat (tv_jetpack_help_lower, 500, 40)
	or
	volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);	
	print ("Player is looking at jetpacking Marines JUMP 1");		
	cs_go_to (misc_veh_pt.p5);
	sleep_until (volume_test_players_all_lookat (tv_jetpack_help, 500, 40)
	or
	volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);
	print ("Player is looking at jetpacking Marines JUMP 2");	
	ai_set_objective (chop_marine_jetpackers, chop_marines_lich_interior);
	cs_go_to (misc_veh_pt.p11);
	wake (lich_marines_fight);
end

script dormant lich_marines_fight()
	sleep_s (15);
	unit_only_takes_damage_from_players_team (ai_get_unit (chop_marine_jetpackers.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (chop_marine_jetpackers.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lich_stairwell_guard.guy1), true);
//	unit_only_takes_damage_from_players_team (ai_get_unit (lich_stairwell_guard.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_side_defense.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_side_defense.guy3), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy3), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (upper_patrol_right.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (upper_patrol_left.guy1), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (core_guard.guy2), true);
	unit_only_takes_damage_from_players_team (ai_get_unit (core_guard.guy3), true);
	print ("Marines playfighting in Lich");	
	sleep_until (volume_test_players (tv_lich_bottom)
	or
	volume_test_players (tv_lich_middle_01)
	or
	volume_test_players (tv_lich_middle_02)
	);	
	unit_only_takes_damage_from_players_team (ai_get_unit (chop_marine_jetpackers.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (chop_marine_jetpackers.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lich_stairwell_guard.guy1), false);
//	unit_only_takes_damage_from_players_team (ai_get_unit (lich_stairwell_guard.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_side_defense.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_side_defense.guy3), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (lower_patrol.guy3), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (upper_patrol_right.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (upper_patrol_left.guy1), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (core_guard.guy2), false);
	unit_only_takes_damage_from_players_team (ai_get_unit (core_guard.guy3), false);
	ai_renew (chop_marine_jetpackers);
	ai_renew (lich_stairwell_guard);
	ai_renew (lower_side_defense);
	ai_renew (lower_patrol);
	ai_renew (upper_patrol_right);
	ai_renew (upper_patrol_left);
	ai_renew (core_guard);
	print ("Marines playtime is over");	
end

script static void lich_spartans_escape_1()
	sleep_until (not (objects_can_see_object (player0, chop_marine_jetpackers.guy1, 40))
	and
	not (objects_can_see_object (player1, chop_marine_jetpackers.guy1, 40))
	and
	not (objects_can_see_object (player2, chop_marine_jetpackers.guy1, 40))
	and
	not (objects_can_see_object (player3, chop_marine_jetpackers.guy1, 40))
	, 1);
	ai_erase (chop_marine_jetpackers.guy1);
end

script static void lich_spartans_escape_2()
	sleep_until (not (objects_can_see_object (player0, chop_marine_jetpackers.guy2, 40))
	and
	not (objects_can_see_object (player1, chop_marine_jetpackers.guy2, 40))
	and
	not (objects_can_see_object (player2, chop_marine_jetpackers.guy2, 40))
	and
	not (objects_can_see_object (player3, chop_marine_jetpackers.guy2, 40))
	, 1);
	ai_erase (chop_marine_jetpackers.guy2);
end

script dormant lich_interior_obj_state_sc()
	sleep_until (volume_test_players (tv_lich_bottom), 1);
	lich_interior_obj_state = 10;
	
	sleep_until (volume_test_players (tv_lich_middle_01), 1);
	lich_interior_obj_state = 20;
	
	sleep_until (volume_test_players (tv_lich_middle_02), 1);
	lich_interior_obj_state = 30;
end

script dormant lich_interior_sound_state()
	sound_set_state ('Set_state_player_outside_lich');

	// wait for the player to enter the first time
	sleep_until (volume_test_players (tv_lich_bottom), 1);
	
	// once the player enters the lich they can only go back and forth between the levels until they exit the lich entirely
	repeat
		if (volume_test_players (tv_lich_bottom)) then 
			sound_set_state ('Set_state_player_in_lich_bottom');
			sleep_until (not volume_test_players (tv_lich_bottom), 1);
		elseif (volume_test_players (tv_lich_middle_01) or volume_test_players (tv_lich_middle_02)) then
			sound_set_state ('Set_state_player_in_lich_middle');
			sleep_until (not (volume_test_players (tv_lich_middle_01) or volume_test_players (tv_lich_middle_02)), 1);
		end
		sleep (1);
		
	until (not volume_test_players (tv_lich_entire));
	sound_looping_stop( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\ambience\amb_m40_lich_int_damaged');
	sound_set_state ('Set_state_player_outside_lich');
end

script command_script lich_entrance_ghost_run_sc()
	cs_vehicle_boost (true);
	cs_go_to (lich_entrance_pt.p7);
	cs_vehicle_boost (false);
end

script command_script lich_entrance_grunt_run_sc()
	cs_go_to (lich_entrance_pt.p8);
end

//script static void test_doors()
//	object_create (main_mammoth);
//	object_set_physics (main_mammoth, true);
//	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
//end

script static void test_doors2()
	ai_place (chop_lich);
	ai_braindead (chop_lich, true);
	sleep_until (object_get_health( object_at_marker( lichy, "power_core" ) ) == 0.0);
	object_destroy (lichy);
end

script dormant chop_tortoise_recorded()
	print ("tortoise on chopper new recorded scripts");
//	sleep_until (volume_test_object (tv_tort_rec_chopper_pt0, main_mammoth));
	unit_recorder_set_playback_rate (main_mammoth, 1.2);	
	print ("TORT SPEED = 1.2");
//	unit_recorder_pause_smooth (main_mammoth, true, 2);
//	tort_stopped = TRUE;
	wake (prechop_tort_stop_timer);
	sleep_until (chop_obj_state > 19
	or
	volume_test_players (tv_tortoise_top_01)
	or
	volume_test_players (tv_tortoise_bottom_01)
	or
	volume_test_players (tv_tortoise_middle_01)
	);
	wake (m40_prechopper_done);
	sleep (30 * 3);
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;
	thread (mam_dust_on());
//	sleep (30 * 2);
//	unit_recorder_set_playback_rate (main_mammoth, .7);	
//	print ("TORT SPEED = .7");
//	sleep_until (volume_test_object (tv_tort_rec_chopper_pt12, main_mammoth), 1);
//	print ("HIT!");
//	sleep (30 * 7);
//	sleep (30 * 3);	

	sleep_until (prechop_recording_loaded_2 == true);

//	sleep_until (not (volume_test_object (trigger_volumes_28, main_mammoth))
//	and
//	not (volume_test_object (tv_tort_rec_chopper_pt0, main_mammoth)), 1);

	sleep_until (volume_test_object (tv_chopper_blip_gun, main_mammoth), 1);

	unit_recorder_set_playback_rate (main_mammoth, .6);	
	print ("TORT SPEED = .6");

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 28, 1);

	print ("HIT!!");

	unit_recorder_pause_smooth (main_mammoth, true, 2);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("Paused");

	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_f);
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("Next recording loaded");
	sleep_s (2);
	thread (open_tort_doors_chopper());
//	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
//	
//	object_override_physics_motion_type(main_mammoth, 1);

	sleep_until (
	(volume_test_players (tv_chopper_hilltop)
	and
	lich_landed_at_chopper == true)
//	or
//	volume_test_players (tv_lich_entire)
	or
	chop_obj_state > 65);
		
//	object_override_physics_motion_type(main_mammoth, 2);

	sleep_until (tort_bay_doors_opened == true);

	thread (close_tort_doors_chopper());
	
	sleep_until (tort_bay_doors_opened == false);

	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;
	thread (mam_dust_on());
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:closing", false);

	unit_recorder_set_playback_rate_smooth (main_mammoth, .2, 2);		
	print ("TORT SPEED = .2");
	
	thread (new_tort_short_speed_test_2());

	sleep_s (2);

	thread (display_chapter_07());
	print ("chapter_07 displayed"); 
	
	f_unblip_object (chop_gauss_waiting);
	
	game_save_no_timeout();
	
	sleep_until (volume_test_object (tv_tort_rec_chopper_pt5, main_mammoth));

	ObjectOverrideNavMeshCutting(main_mammoth, true);
	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	unit_recorder_pause_smooth (main_mammoth, true, 2);
	tort_stopped = TRUE;
	thread (mam_dust_off());

	sleep_until (lich_exploded == TRUE
	and
	chop_obj_state > 65
	);

	wake (M40_chopper_go_to_citadel);
	
	sleep (30 * 15);

	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);
		
//schlerf wanted this moved to waterfalls
//	thread (display_chapter_08());
	
	wake (waterfall_obj_state_sc);
	
		sleep_until	(
		(volume_test_players (tv_tortoise_top_01)
		or
		volume_test_players (tv_tortoise_middle_01)
		or
		volume_test_players (tv_tortoise_bottom_01)
		or
		volume_test_players (tv_chopper_06)
		), 1
		);
		thread (end_td_use_2());
		thread (new_tort_waterfalls_speed_test());
		unit_recorder_pause_smooth (main_mammoth, false, 2);
		tort_stopped = FALSE;
		thread (mam_dust_on());
			
//	ai_set_objective (marine_convoy, waterfall_unsc_obj);
//	ai_set_objective (marine_convoy_02, waterfall_unsc_obj);
//	ai_set_objective (prechopper_marines, waterfall_unsc_obj);
//	ai_set_objective (chop_marines_backup_grp, waterfall_unsc_obj);
end

script static void end_td_use_2()
	if
		dm_mode1 == true
	then
		ai_kill_silent (bt_sq);
		td_disabled = true;
		unit_drop_weapon(td_user, m40_lakeside_target_laser, 1);
		weapon_target_designator_hide_hud();
	end	
end

script dormant chop_tortoise_recorded_ins()
//	print ("tortoise on chopper new recorded scripts");
	sleep_until (volume_test_players (tv_tort_rec_chopper_pt0), 1);
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
	tort_stopped = FALSE;
	thread (mam_dust_on());
	wake (chop_tortoise_recorded);
end

////-----------------chopper VO--------------------//
//
script dormant chopper_dialogue()
	sleep_until (volume_test_players (tv_chopper_02	), 1);
	if
		chopper_cannon_alive == TRUE
	then
		firing_on_cannon = false;
	end
	f_music_m40_battle_b_start();
	NotifyLevel("Music Battle B Start");
end

script dormant leave_chopper()
	sleep_until (volume_test_players (tv_chopper_06), 1);	
	wake (spawn_waterfall_01);
	sleep_until (volume_test_players (tv_waterfall_dialogue_03), 1);		
	wake (el_citadel);	
end

//script dormant chopper_cd_revenant_mortar()
//	sleep (30 * 14);
//	// 9 : Those Revenant mortars are deadly, Chief! Don’t slow down!
//	sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_01000', NONE, 1);
//	sleep (30 * 2);
//end

//script static void lich_flying()
//	print ("squads_30");
////	object_create (secret_lich);
//	ai_place (lich_rail_gun);
////	cs_run_command_script (lich_rail_gun, lich_rail_gun_cs);
////	ai_vehicle_enter_immediate (lich_rail_gun, secret_lich, "phantom_d");
//	sleep_until (object_get_health (ai_get_object (lich_rail_gun.driver)) < 1);
//	ai_erase (lich_rail_gun);
//	print ("squads_30 passed");
//end

// =================================================================================================
// =================================================================================================
// WATERFALLS
// =================================================================================================
// =================================================================================================

script dormant spawn_waterfall_01()
	sleep_until (volume_test_players (tv_waterfall_01), 1);
	thread (toms_tar_pit_damaging());
	data_mine_set_mission_segment ("m40_waterfalls");
 	game_save_no_timeout();
end

script dormant waterfall_obj_state_sc()
//	print ("waterfall_obj_state_sc");
	
	sleep_until (volume_test_players (tv_waterfall_03), 1);
	waterfall_obj_state = 10;
//	print ("waterfall_obj_state = 10");

	effects_perf_armageddon = 0;

	thread (destroy_waterfall_vehicles());
	
	sleep_until (volume_test_players (tv_waterfall_04), 1);
	waterfall_obj_state = 20;
//	print ("waterfall_obj_state = 20");

	kill_volume_disable (soft_kill_backtrack_sniper_alley);
	
	sleep_until (volume_test_players (tv_waterfall_05), 1);
	waterfall_obj_state = 30;
//	print ("waterfall_obj_state = 30");
end

script dormant waterfall_pre_sq()
	sleep_until (volume_test_players (tv_waterfall_01), 1); 
	
end

script static void waterfalls_obj()
	sleep_s (7);
	thread (display_chapter_08());
end

//--------------------waterfall command scripts--------------

script dormant waterfall_tortoise_recorded()
	print ("tortoise on waterfall recorded scripts");
//	sleep_until (volume_test_object (tv_waterfall_02, main_mammoth), 1);	

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 52, 1);
	
	unit_recorder_pause_smooth (main_mammoth, true, 2);
	tort_stopped = TRUE;
	thread (mam_dust_off());

	wake (waterfall_tort_ready);
	sleep_until 
	(
	waterfall_rollout_rdy	== true
	or
	(waterfall_obj_state > 9
	)
	, 1);
	wake (M40_waterfalls_ready);
	
	sleep_s(4);
	
	print ("M40_waterfalls_ready, tortoise passed waterfall conditions");
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;
	thread (mam_dust_on());
	sleep (30 * 2);	
	
	sleep_until (volume_test_object (tv_waterfall_03, main_mammoth), 1);	

	TDT_dist = 35;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		waterfall_obj_state < 10)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = Player is behind, Tortoise is stopping");
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		waterfall_obj_state > 9, 1);

		print ("TDT = Tort Distance Test = Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
	sleep_until (volume_test_object (tv_waterfall_04, main_mammoth), 1);	
	print ("tv_waterfall_03 passed");	

	TDT_dist = 35;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		waterfall_obj_state < 20)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = Player is behind, Tortoise is stopping");
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		waterfall_obj_state > 19, 1);

		print ("TDT = Tort Distance Test = Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
	sleep_until (volume_test_object (tv_waterfall_mammoth_slowdown, main_mammoth), 1);	
	print ("tv_waterfall_03 passed");	

	TDT_dist = 35;
	thread (tort_stop_check_player_location());

	sleep_s (1);

	if 
		(player0_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player1_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player2_valid_and_far_from_tortoise_or_not_valid == TRUE
		and
		player3_valid_and_far_from_tortoise_or_not_valid == TRUE
		and 
		waterfall_obj_state < 30)
			
	then
		unit_recorder_pause_smooth (main_mammoth, true, 3);	
		tort_stopped = TRUE;
		thread (mam_dust_off());
		print ("TDT = Tort Distance Test = Player is behind, Tortoise is stopping");
					
		sleep_until (
				
		(objects_distance_to_object (player0, main_mammoth) < 20 
		and
		objects_distance_to_object (player0, main_mammoth) > 0)
		or
		(objects_distance_to_object (player1, main_mammoth) < 20 
		and
		objects_distance_to_object (player1, main_mammoth) > 0)	
		or
		(objects_distance_to_object (player2, main_mammoth) < 20 
		and
		objects_distance_to_object (player2, main_mammoth) > 0)
		or
		(objects_distance_to_object (player3, main_mammoth) < 20 
		and
		objects_distance_to_object (player3, main_mammoth) > 0)
		
		or
		waterfall_obj_state > 29, 1);

		print ("TDT = Tort Distance Test = Player caught up, Tortoise is continuing");
		unit_recorder_pause_smooth (main_mammoth, false, 2);	
		tort_stopped = FALSE;
		thread (mam_dust_on());
	end
	
	sleep_until (volume_test_object (tv_tort_jackal_stop, main_mammoth));
	print ("HIT!");
	
	sleep (30 * 1);
	tort_done_in_mission = true;
	unit_recorder_pause (main_mammoth, true);	
	print ("PAUSED!");
end

script static void destroy_waterfall_vehicles()

	sleep (30 * 1);

	thread (backup_p_can_die());

	if
		unit_in_vehicle_type (player0, 18)
		or
		unit_in_vehicle_type (player0, 26)	
	then
		unit_exit_vehicle (player0);
	end
	
	if
		unit_in_vehicle_type (player1, 18)
		or
		unit_in_vehicle_type (player1, 26)	
	then
		unit_exit_vehicle (player1);
	end
	
	if
		unit_in_vehicle_type (player2, 18)
		or
		unit_in_vehicle_type (player2, 26)	
	then
		unit_exit_vehicle (player2);
	end
	
	if
		unit_in_vehicle_type (player3, 18)
		or
		unit_in_vehicle_type (player3, 26)	
	then
		unit_exit_vehicle (player3);
	end
	
	sleep_until (not (unit_in_vehicle (player0))
	and
	not (unit_in_vehicle (player1))
	and
	not (unit_in_vehicle (player2))
	and
	not (unit_in_vehicle (player3))
	);

	sleep (10);

	local short waterfalls_list_all = 0; 
	local short waterfalls_list_ind = 0;
	
	waterfalls_list_all = (
	list_count (volume_return_objects_by_campaign_type (tv_waterfalls_entire, 26)) + 
	list_count (volume_return_objects_by_campaign_type (tv_waterfalls_entire, 18)) + 
	list_count (volume_return_objects_by_campaign_type (tv_waterfalls_entire, 29))	
	);

	repeat

	object_cannot_die (player0, true);
	object_cannot_die (player1, true);
	object_cannot_die (player2, true);
	object_cannot_die (player3, true);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 26), waterfalls_list_ind), "hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 26), waterfalls_list_ind), "wing_right", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 26), waterfalls_list_ind), "wing_left", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 18), waterfalls_list_ind), "front_hull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 18), waterfalls_list_ind), "windshield", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 18), waterfalls_list_ind), "mainhull", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 29), waterfalls_list_ind), "hull_rear", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 29), waterfalls_list_ind), "hull_front", 500);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_waterfalls_entire, 29), waterfalls_list_ind), "hatch", 500);

	object_cannot_die (player0, false);
	object_cannot_die (player1, false);
	object_cannot_die (player2, false);
	object_cannot_die (player3, false);
	
	waterfalls_list_ind = waterfalls_list_ind + 1;
	waterfalls_list_all = waterfalls_list_all - 1;

	print ("Destroying Waterfall vehicles");

	until (volume_test_players (tv_waterfall_05)
	or
	waterfalls_list_all == 0, 1);

	print ("ALL vehicles DESTROYED");
	
	inspect (waterfalls_list_all);

end

script static void backup_p_can_die()
	sleep_s (3);
	object_cannot_die (player0, false);
	object_cannot_die (player1, false);
	object_cannot_die (player2, false);
	object_cannot_die (player3, false);
end

script dormant waterfall_tort_ready()
	thread (waterfall_player_tort_test_p0());
	thread (waterfall_player_tort_test_p1());
	thread (waterfall_player_tort_test_p2());
	thread (waterfall_player_tort_test_p3());
//	print ("tort starting rollout count from here, needs four seconds");
//	static short player_in_tort_for_awhile = 0;
//	static real num_seconds = 4;
//	repeat 
//	
//		if 
//			(volume_test_players_all (tv_waterfall_tort_all) == 1) 
//		then
//			player_in_tort_for_awhile = player_in_tort_for_awhile + 1;
//		end
//		
//	until (player_in_tort_for_awhile == (30 * num_seconds), 1);
//		
//	print ("player was in tort for awhile");

	sleep_until (
	p0_on_waterfall_tort == true
	and
	p1_on_waterfall_tort == true
	and
	p2_on_waterfall_tort == true
	and
	p3_on_waterfall_tort == true
	);	
	
	waterfall_rollout_rdy	= true;
end

script static void waterfall_player_tort_test_p0()

	if
		player_valid(player0)
	then
	
		sleep_until (volume_test_object_bounding_sphere_center (tv_waterfall_tort_all, player0));
		print ("player0 valid and on tortoise");
		p0_on_waterfall_tort = true;
	
	else
		print ("player0 not valid");
		p0_on_waterfall_tort = true;
	end		
	
end

script static void waterfall_player_tort_test_p1()

	if
		player_valid(player1)
	then
	
		sleep_until (volume_test_object_bounding_sphere_center (tv_waterfall_tort_all, player1));
		print ("player1 valid and on tortoise");
		p1_on_waterfall_tort = true;
	
	else
		print ("player1 not valid");
		p1_on_waterfall_tort = true;
	end		
	
end

script static void waterfall_player_tort_test_p2()

	if
		player_valid(player2)
	then
	
		sleep_until (volume_test_object_bounding_sphere_center (tv_waterfall_tort_all, player2));
		print ("player2 valid and on tortoise");
		p2_on_waterfall_tort = true;
	
	else
		print ("player2 not valid");
		p2_on_waterfall_tort = true;
	end		
	
end

script static void waterfall_player_tort_test_p3()

	if
		player_valid(player3)
	then
	
		sleep_until (volume_test_object_bounding_sphere_center (tv_waterfall_tort_all, player3));
		print ("player3 valid and on tortoise");
		p3_on_waterfall_tort = true;
	
	else
		print ("player3 not valid");
		p3_on_waterfall_tort = true;
	end		
	
end

//f_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks )

script static void toms_tar_pit_damaging()
	thread (f_m40_damage_volume_players (tv_waterfall_tar_01, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_02, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_03, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_04, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_05, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_06, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_07, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_08, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_09, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_10, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_11, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_12, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_13, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_14, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_15, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_16, 40, 1.5, 10));

	thread (f_m40_damage_volume_players (tv_waterfall_tar_17, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_18, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_19, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_20, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_21, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_22, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_23, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_24, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_25, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_26, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_27, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_28, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_29, 40, 1.5, 10));
	thread (f_m40_damage_volume_players (tv_waterfall_tar_30, 40, 1.5, 10));

end

// =================================================================================================
// =================================================================================================
// DEBUG
// =================================================================================================
// =================================================================================================

script static void dprint (string s)
	if b_debug then
		print (s);
	end
end

// =================================================================================================
// =================================================================================================
// COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

//---------forerunner gun stuff-----------//



//NEW++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//LAKESIDE CANNON SCRIPTS

//this is the cannon's first idle state
script static void cannon_lakeside_motion_new()
//	object_create (cannon_lakeside_new);
	print ("created cannon");
	
	pelican_and_cannon_pup = pup_play_show (pelican_pup);

//	sleep_s(1);

//	object_set_scale (cannon_lakeside_new, .4, 1);

	print ("LAKESIDE CANNON IS SCALED");
	
//	lakeside_cannon_initial_pup = pup_play_show (lakeside_cannon_first_pup);
	
//	repeat
//		device_set_overlay_track( cannon_lakeside_new, 'device:power' );
//		device_animate_overlay( cannon_lakeside_new, 1, 10, .1, .1 );
//		sleep( 30 * 8.9 );
//		print ("done 2");
//	until (cav_pelican_dies == true);
end

//this is the cannon's firing animation which is triggered in the pelicans' puppeteer show
//script static void cannon_lakeside_fire_new()
//	thread (cannon_lakeside_rotate_new());	
//	thread (cannon_lakeside_rotate_side_new());
//	print ("SLEEPING");
//	sleep_s (3);
//	print ("WAKING");
//	thread (test_fx_3());
//	thread (camera_shake_two());
//	device_set_overlay_track( cannon_lakeside_new, 'device:position' );
//	device_animate_overlay( cannon_lakeside_new, 282, 6.6, 0, 0);
//	print ("GUN FIRED");
//	sleep( 30 * 7.6 );
//	object_destroy (animated_pelican_s_02);
//	object_destroy (animated_pelican_s_03);
//	wake (f_dialog_m40_pelican_shot_down);
//	print ("done 1");
//	sleep( 30 * .5 );
//	thread (cannon_lakeside_rotate_new_2());
//	thread (cannon_lakeside_rotate_side_new_2());
//	repeat
//	device_set_overlay_track( cannon_lakeside_new, 'device:power' );
//	device_animate_overlay( cannon_lakeside_new, 1, 10, .1, .1 );
//		sleep( 30 * 9.9 );
//	print ("done 2");
//	until (1 == 0);
//	sleep( 30 * 2 );
//end

script static void honey_i_shrunk_the_forerunner_cannon()
	object_set_scale (cannon_lakeside_new, .4, 1);
	device_set_overlay_track( cannon_lakeside_new, 'device:power' );
	device_animate_overlay( cannon_lakeside_new, 1, 1, .1, .1 );
end

//turning to face the pelicans
script static void cannon_lakeside_face_pelicans()
	print ("cannon_lakeside_face_pelicans");
	thread (cannon_lakeside_rotate_new());
	thread (cannon_lakeside_rotate_side_new());
end

script static void cannon_lakeside_rotate_new()
	object_rotate_to_flag (cannon_lakeside_new, 8, 8, 8, cav_gun_rotate_flag);
end

script static void cannon_lakeside_rotate_side_new()
	object_rotate_by_offset (cannon_lakeside_new, 4, 4, 4, 0, 0, -15);
end

script static void test_pv_out()
	sleep_until (not(volume_test_players (tv_caverns_entire)), 1);
	print ("player left caverns volume");
	player_exited_caverns = true;
end

script static void attach_cannon_to_octopus()
	objects_attach (pelican_octopus, "marker5", cannon_lakeside_new, "");
end

script static void detach_cannon_to_octopus()
	objects_detach (pelican_octopus, cannon_lakeside_new);
end


//turning away after pelicans are dead
script static void cannon_lakeside_face_back()
//	print ("cannon_lakeside_face_back");
	sleep( 30 * 2 );
	thread (cannon_lakeside_rotate_new_2());
	thread (cannon_lakeside_rotate_side_new_2());
end

script static void cannon_lakeside_rotate_new_2()
		sleep( 30 * 5 );
	object_rotate_to_flag (cannon_lakeside_new, 6, 6, 6, cav_gun_rotate_flag_2);
end

script static void cannon_lakeside_rotate_side_new_2()
	object_rotate_by_offset (cannon_lakeside_new, 12, 12, 12, 0, 0, 15);
end

script static void lakeside_cannon_swap()
	object_cannot_die (cannon_lakeside_new, true);
	sleep_until (object_get_health (cannon_lakeside_new) < .2, 1);
	f_unblip_object (cannon_lakeside_new);
//	print ("Lakeside cannon health is low, switching to destroyed cannon!");
	effect_new_at_ai_point (fx\reach\fx_library\cinematics\boneyard\040lb_cov_flee\02\shot_1\longsword_attack_explosion.effect, cannon_explosion.p0);
	pup_stop_show (pelican_and_cannon_pup);	
	pup_play_show (lakeside_cannon_destroy_pup);
	lakeside_cannon_alive = FALSE;
//	f_unblip_object (cannon_lakeside_new);

	sleep_s (5);	
	wake ( f_dialog_m40_tutorial_3);
end

//CHOPPER CANNON SCRIPTS

script static void honey_i_shrunk_the_forerunner_cannon_again()
	object_create (cannon_chopper_new);
	object_set_scale (cannon_chopper_new, .5, 1);
	chopper_cannon_pup_full = pup_play_show (chopper_cannon_pup);	
	thread (chopper_cannon_swap());
end

script static void chopper_cannon_swap()
	object_cannot_die (cannon_chopper_new, true);
	sleep_until (object_get_health (cannon_chopper_new) < .2, 1);
//	print ("Chopper cannon health is low, switching to destroyed cannon!");
	pup_stop_show (chopper_cannon_pup_full);	
	pup_play_show (chopper_cannon_destroyed_pup);
	f_unblip_object (cannon_chopper_new);
	chopper_cannon_alive = FALSE;

end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//script static void cannon_lakeside_fire()
////	sleep_until (pelican_dies == true);
//	thread (test_fx_3());
//	thread (camera_shake_two());
//	device_set_overlay_track( cannon_lakeside, 'any:pew' );
//	device_animate_overlay( cannon_lakeside, 282, 9.4, 0, 0);
//	print ("GUN FIRED");
//	sleep( 30 * 7.6 );
//	object_destroy (animated_pelican_s_02);
//	object_destroy (animated_pelican_s_03);
//	wake (f_dialog_m40_pelican_shot_down);
//	print ("done 1");
//	sleep( 30 * .5 );
//	thread (cannon_lakeside_fire_c());
//	repeat
//	device_set_overlay_track( cannon_lakeside, 'any:idle' );
//	device_animate_overlay( cannon_lakeside, 1, 5.2, .1, .1 );
//	sleep( 30 * 3.8 );
//	print ("done 2");
//	until (1 == 0);
//	sleep( 30 * 2 );
//end

//script static void cannon_lakeside_fire_c()	
//	object_rotate_by_offset (cannon_lakeside, 7 , 7 , 7 , -20, 0, 0);
//	print ("ROTATED 3");
//end

//script dormant cannon_1_health()
//	print ("cannon 1 health running");	
//	wake (M40_fodder_railgun_automated);
//	sleep( 30 * 5 );
//	cannon_death_state = false;
// 	game_save_no_timeout();
//end

//script dormant object1_take_damage_please()
//	sleep( 30 * 4 );
//	object_can_take_damage (cannon_lakeside);
//	print ("cannon can definitely take damage");
//end
//
//script dormant object2_take_damage_please()
//	sleep( 30 * 4 );
//	object_can_take_damage (cannon_lakeside);
//	print ("cannon 2 can definitely take damage");
//end

script dormant chopper_tort_ready()
	print ("tort starting rollout count from here, needs eight seconds");
	static short player_in_tort_for_awhile = 0;
	static real num_seconds = 8;
	repeat 
		if (volume_test_players (tv_tortoise_top_01) == 1
		or
		volume_test_players (tv_tortoise_middle_01) == 1
		or
		volume_test_players (tv_tortoise_bottom_01) == 1
		) then
			player_in_tort_for_awhile = player_in_tort_for_awhile + 1;
//		else
//			player_in_tort_for_awhile = 0;
		end
		until (player_in_tort_for_awhile == (30 * num_seconds), 1);
	print ("player was in tort for awhile");
	chopper_rollout_rdy	= true;
end

script static void gun2()
	object_create (cannon_lakeside);
	sleep( 30 * 2 );
//	object_rotate_by_offset (cannon_lakeside, 9, 9, 9, -35, 0, -20);
end

script static void test_fx_3()
	print ("test_fx running");

//	effect_new_on_object_marker (environments\solo\m40_invasion\fx\cannon\fr_cannon_firing.effect, cannon_lakeside_new,"cannon_source_");

	effect_new_between_object_markers (environments\solo\m40_invasion\fx\cannon\fr_cannon_firing.effect, cannon_lakeside_new, "cannon_source_", animated_pelican_s, "tailend");
	
	print ("Cannon FX have Fired");
	
	sleep_s (1.5);

	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, animated_pelican_s, "machinegun_turret");	

	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, animated_pelican_s_02, "machinegun_turret");	

	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, animated_pelican_s_03, "machinegun_turret");		

	effect_new_on_object_marker (fx\library\smoke\smoke_billow\smoke_billow.effect, animated_pelican_s, "tailend");
	effect_new_on_object_marker (fx\library\smoke\smoke_billow\smoke_billow.effect, animated_pelican_s_02, "tailend");
	effect_new_on_object_marker (fx\library\smoke\smoke_billow\smoke_billow.effect, animated_pelican_s_03, "tailend");


	print ("Pelican FX have Fired");

end

//effect_new_on_object_marker (environments\solo\m40_invasion\fx\cannon\fr_cannon_warmup.effect.effect, cannon_lakeside_new,"cannon_source_");


//script static void rotate_pelican()
//	object_set_physics (porkins_pely_03, false);
//	object_rotate_by_offset (porkins_pely_03, 0, 2, 2, 0, 50, 30);
//	print ("rotated");
//end

//---------UTILITY-----------//

script dormant prechop_tort_stop_timer()
	print ("tort starting rollout count from here, needs eight seconds");
	static short tort_stopped_for_awhile = 0;
	static real num__tort_stop_seconds = 5;
	repeat 
		if (tort_stopped == true) 
		then
			tort_stopped_for_awhile = tort_stopped_for_awhile + 1;
		end
	until (tort_stopped_for_awhile == (30 * num__tort_stop_seconds), 1);
	print ("tort was stopped for five seconds");
	wake (m40_prechopper_waiting);
	tort_stopped_for_five_seconds	= true;
end

script static void test_tort_volumes()
	wake (test_tort_volume_bottom);
	wake (test_tort_volume_middle);
	wake (test_tort_volume_top);
end

script dormant test_tort_volume_bottom()
	repeat 
	sleep_until (not (volume_test_players (tv_tortoise_bottom_01)), 1);
	print ("player left bottom of tortoise");
	tort_bottom = false;
	sleep_until (volume_test_players (tv_tortoise_bottom_01), 1);
	print ("player in bottom of tortoise");
	sound_set_state('Set_state_player_in_mammoth_bottom');
	tort_bottom = true;
	until (1 == 0);
end

script dormant test_tort_volume_middle()
	repeat 
	sleep_until (not (volume_test_players (tv_tortoise_middle_01)), 1);
	print ("player left middle of tortoise");
	tort_middle = false;
	sleep_until (volume_test_players (tv_tortoise_middle_01), 1);
	print ("player in middle of tortoise");
	sound_set_state('Set_state_player_in_mammoth_middle');
	tort_middle = true;
	until (1 == 0);
end

script dormant test_tort_volume_top()
	repeat 
	sleep_until (not (volume_test_players (tv_tortoise_top_01)), 1);
	print ("player left top of tortoise");
	tort_top = false;
	sleep_until (volume_test_players (tv_tortoise_top_01), 1);
	print ("player in top of tortoise");
	sound_set_state('Set_state_player_in_mammoth_top');
	tort_top = true;
	until (1 == 0);
end

script dormant test_tort_global_interior()
	wake (test_tort_volume_bottom);
	wake (test_tort_volume_middle);
	wake (test_tort_volume_top);	
	repeat 
		if 
			tort_middle == TRUE
			or
			tort_bottom == TRUE
		then 
			tort_global_interior = true;
			print ("tort_global_interior is TRUE");
		else
			tort_global_interior = false;
			if tort_top != TRUE then
				sound_set_state('Set_state_player_outside_mammoth');
			end
		end
	until (1 == 0);
end

//script command_script cs_tort_pathing()
//	print ("about to go to");
//	cs_ignore_obstacles (true);
//	cs_go_to (mtest.p5);
//	cs_go_to (mtest.p6);
//	cs_go_to (mtest.p4);
//	cs_go_to (mtest.p9);
//	cs_go_to (mtest.p8);
//	print ("here come the bullfrogs");
//end

script static void cs_cav_jetpack_test0_pre()
	sleep_until (palmer_vignette == true
	or
	volume_test_players (tv_tortoise_bottom_01), 1
	);
	sleep_s (2);
	cs_run_command_script (marines_main_hog_01b_sq, cs_cav_jetpack_test0);
	ai_set_objective (marines_main_hog_01b_sq, mammoth_top_obj);
end

script command_script cs_cav_jetpack_test0()
	print ("about to go to 1");
	cs_ignore_obstacles (true);
	cs_go_to (mtest2.p3);
	cs_go_to (mtest2.p18);
	cs_go_to (mtest2.p19);
	cs_go_to (mtest2.p20);
	cs_go_to (mtest2.p21);
	print ("here come the bullfrogs 2");
end
//
//script command_script cs_cav_jetpack_test()
//	print ("about to go to 1");
//	cs_ignore_obstacles (true);
//	cs_go_to (mtest.p7);
//	cs_go_to (mtest.p8);
//	cs_go_to (mtest.p9);
//	cs_go_to (mtest.p10);
//	cs_go_to (mtest.p11);
//	cs_go_to (mtest.p12);
//	print ("here come the bullfrogs 2");
//end

script command_script cs_cav_jetpack_test2()
	print ("about to go to 2");
	cs_ignore_obstacles (true);
//	cs_go_to (mtest.p7);
//	cs_go_to (mtest.p8);
//	cs_go_to (mtest.p9);
	cs_go_to (mtest.p10);
	cs_go_to (mtest.p21);
	cs_go_to (mtest.p11);
	cs_go_to (mtest.p20);
//	ai_set_objective (marines_main_hog_01_sq, mammoth_top_obj);
	print ("here come the bullfrogs 2");
end

script command_script cs_cav_jetpack_test3()

	print ("about to go to 3 after waiting");
	cs_ignore_obstacles (true);
	cs_go_to (mtest.p10);
	cs_go_to (mtest.p11);
	cs_go_to (mtest.p12);
	ai_activity_set (marines_main_hog_01b_sq, "patrol");
//	ai_set_objective (marines_main_hog_01b_sq, mammoth_top_obj);
	print ("here come the bullfrogs 3");
end

script command_script cs_cav_jetpack_test4()
	print ("about to go to");
	cs_go_to (mtest2.p2);
	print ("here come the bullfrogs 5");
end

script command_script cs_cav_jetpack_test5()
	sleep(30 * 3);	
	print ("cs_cav_jetpack_test5 tortoise_jetpakcer_02.cliff");
	cs_go_to (mtest2.p3);
	cs_go_to (mtest2.p4);
	cs_go_to (mtest2.p22);
	print ("here come the bullfrogs");
end

//script command_script cs_tort_pathing_4()
//	print ("about to go to");
//	cs_ignore_obstacles (true);
//	cs_go_to (mtest.p9);
//	cs_go_to (mtest.p10);
//	cs_go_to (mtest.p8);
//	print ("here come the bullfrogs");
//end

script command_script lower_weapon_lich_pilot()
	cs_face (true, lich_test.p4);
	cs_stow (true);
	sleep (30 * 2);
	ai_braindead (lich_pilot_sq, true);
	objects_physically_attach (lichy, "lich_plinth_player", lich_pilot_sq.spawn_points_1, "");
	print ("stowed!");
	sleep (30 * 2);
	pup_play_show( "lich_pilot_pup" );
end

script static void mid_lich_pilot()
	ai_braindead (lich_pilot_sq, false);
end

script static void raise_weapon_lich_pilot()
	cs_stow (lich_pilot_sq, false);
end

script command_script cs_tort_lakeside_exit()
//	print ("about to go to 1");
	cs_ignore_obstacles (true);
	cs_go_to (tortoise_lakeside_test_pt.p19);
//	print ("here come the bullfrogs 1");
end

script command_script cs_tort_lakeside_exit2()
	sleep (30 * 5);
//	print ("about to go to 2");
	cs_ignore_obstacles (true);
	cs_go_to (tortoise_lakeside_test_pt.p19);
//	print ("here come the bullfrogs 2");
end

script command_script cs_tort_lakeside_exit3()
	sleep (30 * 10);
//	print ("about to go to 3");
	cs_ignore_obstacles (true);
	cs_go_to (tortoise_lakeside_test_pt.p19);
//	print ("here come the bullfrogs 3");
end

script static void test_lakeside_hog_setup()

	ai_vehicle_reserve (marines_main_hog_01_veh, false);
	ai_vehicle_reserve (marines_main_hog_02_veh, false);
//	ai_vehicle_reserve (marines_main_mongoose_veh, false);
	
	thread (lakeside_ai_hog_enter());
	thread (lakeside_player_hog_enter());	

//	ai_path_ignore_object_obstacle
//	ai_path_clear_ignore_object_obstacle
 
end

script static void lakeside_ai_hog_enter()
		if
			volume_test_object (tv_tortoise_bottom_01, marines_main_hog_01_veh)
		then		

			if
				dm_mode1 == true
			then
				ai_vehicle_enter (tortoise_jetpacker_01, tort_hog_01_g, "warthog_g");
				ai_vehicle_enter (tortoise_jetpacker_02, tort_hog_01_g, "warthog_d");
				print ("Lakeside Marines entering THEIR vehicle");
				sleep_until (
				tort_stopped == true);
				ai_vehicle_enter (tortoise_jetpacker_02, tort_hog_01_g, "warthog_d");
				print ("Lakeside Marines entering THEIR vehicle 2");
				sleep (30 * 5);
				sleep (1);
				thread (tort_driveout2());
			else
				ai_vehicle_enter (tortoise_jetpacker_01, marines_main_hog_01_veh, "warthog_g");
				ai_vehicle_enter (tortoise_jetpacker_02, marines_main_hog_01_veh, "warthog_d");
				print ("Lakeside Marines entering THEIR vehicle");
				sleep_until (
				tort_stopped == true);
				ai_vehicle_enter (tortoise_jetpacker_02, marines_main_hog_01_veh, "warthog_d");
				print ("Lakeside Marines entering THEIR vehicle 2");
				sleep (30 * 5);
				sleep (1);
				thread (tort_driveout2());
			end
		else
			print ("Lakeside Marines' Hog isn't in the Mammoth... :(");
			lakeside_warthog_deploy = false;
		end
end

script command_script tort_driveout()
	print ("Cliff driving out of Mammoth");
	cs_vehicle_speed_instantaneous (1);
	ai_path_ignore_object_obstacle (tortoise_jetpacker_02.cliff, main_mammoth);
	cs_go_to (tortoise_jetpacker_02, true, lakeside_misc.p11);
	ai_path_clear_ignore_object_obstacle (tortoise_jetpacker_02);
	print ("Cliff drove out of Mammoth");
end

script static void lakeside_player_hog_enter()
		if
			volume_test_object (tv_tortoise_bottom_01, marines_main_hog_02_veh)
		then

			if
				dm_mode1 == true
			then

				ai_vehicle_reserve_seat (tort_hog_02_g, "warthog_d", true);
				ai_vehicle_reserve_seat (tort_hog_02_g, "warthog_p", true);
				ai_vehicle_enter (marines_main_hog_01b_sq, tort_hog_02_g, "warthog_g");
				wake (unreserve_lakeside_hog);			
				wake (lakeside_hog_blip_timer);
				print ("Lakeside Marines entering Player's vehicle");
				sleep (30 * 9);
				ai_set_objective (marines_main_hog_01b_sq, lakeside_mar_obj);
			
			else

				ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_d", true);
				ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_p", true);
				ai_vehicle_enter (marines_main_hog_01b_sq, marines_main_hog_02_veh, "warthog_g");
				wake (unreserve_lakeside_hog);			
				wake (lakeside_hog_blip_timer);
				print ("Lakeside Marines entering Player's vehicle");
				sleep (30 * 9);
				ai_set_objective (marines_main_hog_01b_sq, lakeside_mar_obj);
		
		end
		
		else
			print ("Lakeside Player's Hog isn't in the Mammoth!!!");
			lakeside_warthog_deploy = false;
		end
end

script static void tort_driveout2()
	cs_ignore_obstacles (tortoise_jetpacker_01, TRUE);
	ai_path_ignore_object_obstacle (tortoise_jetpacker_01, main_mammoth);
	ai_set_objective (tortoise_jetpacker_01, lakeside_mar_obj);
	
	cs_ignore_obstacles (tortoise_jetpacker_02, TRUE);
	ai_path_ignore_object_obstacle (tortoise_jetpacker_02, main_mammoth);
	ai_set_objective (tortoise_jetpacker_02, lakeside_mar_obj);
	
	thread (set_marine_veh_obj_01());
	thread (set_marine_veh_obj_02());
	thread (set_marine_veh_obj_03());
	
	sleep (30 * 2);
	ai_path_clear_ignore_object_obstacle (tortoise_jetpacker_01);
	ai_path_clear_ignore_object_obstacle (tortoise_jetpacker_02);
	
	print ("Marines are no longer ignoring Mammoth");
	
	sleep (30 * 30);		
			
	ObjectOverrideNavMeshCutting(main_mammoth, true);
	ObjectOverrideNavMeshObstacle(main_mammoth, false);
	
	print ("Mammoth is stable object");
	
	ai_set_objective (marine_convoy, lakeside_mar_obj);
end

script static void set_marine_veh_obj_01()
	sleep_until (unit_in_vehicle_type (marines_main_hog_01b_sq, 18));
	cs_ignore_obstacles (marines_main_hog_01b_sq, TRUE);
	ai_path_ignore_object_obstacle (marines_main_hog_01b_sq, main_mammoth);
	ai_set_objective (marines_main_hog_01b_sq, lakeside_mar_obj);	
	print ("marines_main_hog_01b_sq SET TO LAKESIDE OBJECTIVES");
end

script static void set_marine_veh_obj_02()
	sleep_until (unit_in_vehicle_type (tort_marines.randall, 18));
	cs_ignore_obstacles (tort_marines.randall, TRUE);
	ai_path_ignore_object_obstacle (tort_marines.randall, main_mammoth);
	ai_set_objective (tort_marines.randall, lakeside_mar_obj);	
	print ("tort_marines.randall SET TO LAKESIDE OBJECTIVES");
end

script static void set_marine_veh_obj_03()
	sleep_until (unit_in_vehicle_type (tort_marines.aaron, 18));
	cs_ignore_obstacles (tort_marines.aaron, TRUE);
	ai_path_ignore_object_obstacle (tort_marines.aaron, main_mammoth);
	ai_set_objective (tort_marines.aaron, lakeside_mar_obj);	
	print ("tort_marines.aaron SET TO LAKESIDE OBJECTIVES");
end

//script static void test_marine_getin()
//	ai_vehicle_enter (marines_main_hog_01b_sq, marines_main_hog_02_veh, "warthog_g");
//end

//script static void unres()
//	ai_vehicle_reserve_seat (marines_main_hog_01_veh, "warthog_d", false);
//	ai_vehicle_reserve_seat (marines_main_hog_01_veh, "warthog_g", false);
//	ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_d", false);
//	ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_g", false);
//end

script dormant unreserve_lakeside_hog()
	sleep_until (
	player_in_vehicle (marines_main_hog_02_veh)
	or
	player_in_vehicle (marines_main_hog_01_veh)
	);
	ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_d", false);
	print ("lakeside hog unreserved");
	sleep (30 * 10);	
	ai_vehicle_reserve_seat (marines_main_hog_02_veh, "warthog_p", false);
end

script dormant lakeside_hog_blip_timer()
	sleep_until (ai_living_count (lakeside_tort_assault_2_grp) < 3
	);
	wake (lakeside_hog_unblip);
	game_save_no_timeout();
	f_blip_object (marines_main_hog_02_veh, "ordnance");
	print ("lakeside_hog_blip_timer");
	sleep (30 * 35);
	print ("lakeside_hog_blip_timer notify achieved");
	NotifyLevel ("lakeside_hog_blip_timer time passed");
	wake (lakeside_hog_2_unblip);
	if
		volume_test_players (tv_tortoise_top_01)
	then
		sleep_until (volume_test_object (tv_lakeside_warthog_hangout, marines_main_hog_01_veh)
//		and
//		volume_test_players (tv_tortoise_top_01)
		);
		f_blip_object (marines_main_hog_01_veh, "ordnance");
		print ("Player still on Tortoise, blipping Marine Hog");
	end
	sleep_until (
		LevelEventStatus("lakeside_hog_2_blip_timer time passed")
		or
		player_in_vehicle (marines_main_hog_02_veh)
		or
		player_in_vehicle (marines_main_hog_01_veh)
		, 1);
	f_unblip_object (marines_main_hog_02_veh);	
	f_unblip_object (marines_main_hog_01_veh);
end

//-------------------START OF TEMP FOR INSERTION POINT----------------------------------------

//script dormant lakeside_insertion_hog_blip_timer()
//	wake (lakeside_hog_unblip);
//	sleep (30 * 20);
//	f_blip_object (lakeside_insertion_hog_02, "ordnance");
//	print ("lakeside_insertion_hog_blip_timer");
//	sleep (30 * 35);
//	print ("lakeside_insertion_hog_blip_timer notify achieved");
//	NotifyLevel ("lakeside_insertion_hog_blip_timer time passed");
//	if
//		volume_test_players (tv_tortoise_top_01)
//	then
//		sleep_until (volume_test_object (tv_lakeside_warthog_hangout, lakeside_insertion_hog_01)
////		and
////		volume_test_players (tv_tortoise_top_01)
//		);
//		f_blip_object (lakeside_insertion_hog_01, "ordnance");
////		wake (lakeside_insertion_hog_2_unblip);
//		print ("Player still on Tortoise, blipping Marine Hog");
//	end
//	sleep_until (
//		LevelEventStatus("lakeside_insertion_hog_2_blip_timer time passed")
//		or
//		player_in_vehicle (lakeside_insertion_hog_01)
//		or
//		player_in_vehicle (lakeside_insertion_hog_02)
//		, 1);
//	f_unblip_object (lakeside_insertion_hog_01);	
//	f_unblip_object (lakeside_insertion_hog_02);
//end
//
//script dormant lakeside_insertion_hog_unblip()
//	sleep_until (
//		LevelEventStatus("lakeside_insertion_hog_blip_timer time passed")
//		or
//		player_in_vehicle (lakeside_insertion_hog_01)
//		or
//		player_in_vehicle (lakeside_insertion_hog_02)
//		, 1);
//	f_unblip_object (lakeside_insertion_hog_02);
//end
//
//script dormant lakeside_insertion_hog_2_unblip()
//	sleep (30 * 30);
//
////	if
////		not (unit_in_vehicle (player0))
////	then
////		print ("Player not in vehicle, checking to see if player is doing encounter on foot");
////		if
////			(player_in_lakeside_enc == false)
////		then

////		else
////			print ("Player not in vehicle, but already in encounter");
////		end
////	else
////		print ("Player in vehicle");
////	end
//	
//	sleep (30 * 30);
//	
////	if
////		not (unit_in_vehicle (player0))
////	then
////		print ("Player not in vehicle, checking to see if player is doing encounter on foot");
////		if
////			(player_in_lakeside_enc == false)
////		then

////		else
////			print ("Player not in vehicle, but already in encounter");
////		end
////	else
////		print ("Player in vehicle");
////	end
//	
//	sleep (30 * 20);
//	print ("lakeside_insertion_hog_2_blip_timer notify achieved");
//	NotifyLevel ("lakeside_insertion_hog_2_blip_timer time passed");
//end

//-------------------END OF TEMP FOR INSERTION POINT----------------------------------------

script dormant lakeside_hog_unblip()
	sleep_until (
		LevelEventStatus("lakeside_hog_blip_timer time passed")
		or
		player_in_vehicle (marines_main_hog_02_veh)
		, 1);
	f_unblip_object (marines_main_hog_02_veh);
end

script dormant lakeside_hog_2_unblip()
	sleep (30 * 20);
//	if
//		not (unit_in_vehicle (player0))
//	then

//	end
	sleep (30 * 30);
//	if
//		not (unit_in_vehicle (player0))
//	then
	
//	end
	sleep (30 * 20);
	print ("lakeside_hog_2_blip_timer notify achieved");
	NotifyLevel ("lakeside_hog_2_blip_timer time passed");
end

//cavern_marines_enter_hog02

//script command_script cs_test_teleport()
//	print ("about to go to");
//	cs_go_to (tortoise_main_pt.p1);
//	print ("here come the bullfrogs");
//end
//
//script static void squad_test (ai squad_name, ai squad_name2)
//	marines_main_hog_01_dr = squad_name;
//	marines_main_hog_01_gunner = squad_name2;
////	marines_main_hog_01_pass = squad_name3;
//end
//
//script static void squad_2_test (ai squad_name, ai squad_name2)
//	marines_main_hog_02_dr = squad_name;
//	marines_main_hog_02_gunner = squad_name2;
////	marines_main_hog_02_pass = squad_name3;
//end
//
//script static void squad_3_test (ai squad_name, ai squad_name2)
//	marines_main_goose_01_dr = squad_name;
//	marines_main_goose_01_pass = squad_name2;
//end
//
//script static void seat_tester()
//	print ("seat_tester");
//	sleep_until (vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_g", player0));
//	print ("success");
//end

//script static void test_chop_mam()
//	object_create (main_mammoth);
//	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p10);
//	object_cannot_take_damage (main_mammoth);
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0203c);
//	unit_recorder_play_and_blend (main_mammoth, 2);
//	unit_recorder_set_time_position (main_mammoth, 70);
//	unit_recorder_set_playback_rate (main_mammoth, .7);
//end

//script static void test_door_anims()
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "rear:bay:door:opening", true);
//	sleep (30 * 5);
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "front:bay:door:opening", true);
////	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "suspension:idle:2:vehicle:idle", true);	
//	end

script static void camera_shake_now_lich()
	repeat
	print ("Lich rumble GO");
		camera_shake_all_coop_players (0.7, 0.4, 6, 2 );
	until (not (volume_test_players (tv_lich_entire))
	);
end

script static void camera_shake_now()
	camera_shake_all_coop_players (0.7, 0.4, 6, 2 );
end

script static void camera_shake_now_short()
	camera_shake_all_coop_players (0.7, 0.4, 3, 2 );
end

script static void camera_shake_one()
	sleep (30 * 1);
	camera_shake_all_coop_players (0.7, 0.4, 6, 2 );
end

script static void camera_shake_two()
	sleep (30 * 1);
	camera_shake_all_coop_players (0.7, 0.4, 9, 2 );
end

script static void camera_shake_6sleep()
	sleep (30 * 5);
	if
		objects_distance_to_object (player0, main_mammoth) < 25
	then 
		camera_shake_player (player0, 0.7, 0.4, 6, 2 );
		print ("Camera Shake Player0");
	end

	if
		objects_distance_to_object (player1, main_mammoth) < 25
	then 
		camera_shake_player (player1, 0.7, 0.4, 6, 2 );
		print ("Camera Shake Player1");
	end
	
	if
		objects_distance_to_object (player2, main_mammoth) < 25
	then 
		camera_shake_player (player2, 0.7, 0.4, 6, 2 );
		print ("Camera Shake Player2");
	end
	
	if
		objects_distance_to_object (player3, main_mammoth) < 25
	then 
		camera_shake_player (player3, 0.7, 0.4, 6, 2 );
		print ("Camera Shake Player3");
	end
end

script static void camera_shake_long()
	sleep (30 * 1);
//	camera_shake_all_coop_players (0.7, 0.4, 15, 2 );
	if
		objects_distance_to_object (player0, main_mammoth) < 25
	then 
		camera_shake_player (player0, 0.7, 0.4, 15, 2 );
		print ("Camera Shake Player0");
	end

	if
		objects_distance_to_object (player1, main_mammoth) < 25
	then 
		camera_shake_player (player1, 0.7, 0.4, 15, 2 );
		print ("Camera Shake Player1");
	end
	
	if
		objects_distance_to_object (player2, main_mammoth) < 25
	then 
		camera_shake_player (player2, 0.7, 0.4, 15, 2 );
		print ("Camera Shake Player2");
	end
	
	if
		objects_distance_to_object (player3, main_mammoth) < 25
	then 
		camera_shake_player (player3, 0.7, 0.4, 15, 2 );
		print ("Camera Shake Player3");
	end
end

//script static void fore_small_door_open (device small_door)
//	device_set_position_track ( small_door, 'any:small', 0.0 );
//	device_animate_position ( small_door, .83, 2, 0, 0, true );
//	sleep (30 * 5);
//	device_animate_position ( small_door, 0, 1, 0, 0, true );
////	thread (lib_teleport_start())
//end

//script static void closec()
//	tort_target_designator_crate->close();
//end


//script static void test_playz()
////	object_create (main_mammoth);
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0505a);
//	unit_recorder_play (main_mammoth);
//end


//------killing the fodder guys once player is at lakeside------//

script static void fodder_ai_kill()
	thread (tv_fodder_front_left_aikill());
	thread (tv_fodder_mid_left_aikill());
	thread (tv_fodder_left_tower_aikill());
	thread (tv_fodder_rear_left_aikill());
//	thread (tv_fodder_front_right_aikill());
//	thread (tv_fodder_mid_01_right_aikill());
//	thread (tv_fodder_mid_02_right_aikill());
//	thread (tv_fodder_mid_03_right_aikill());
//	thread (tv_fodder_rear_right_aikill());
	thread (tv_fodder_ground_aikill());
end
//LEFT

script static void tv_fodder_front_left_aikill()
	sleep_until (not (volume_test_players (tv_fodder_front_left))	
	and
	not (volume_test_players_all_lookat (tv_fodder_front_left, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_fodder_front_left));
	print ("tv_fodder_front_left_aikill");
end

script static void tv_fodder_mid_left_aikill()
	sleep_until (not (volume_test_players (tv_fodder_mid_left))	
	and
	not (volume_test_players_all_lookat (tv_fodder_mid_left, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_fodder_mid_left));
	print ("tv_fodder_mid_left_aikill");
end

script static void tv_fodder_left_tower_aikill()
	sleep_until (not (volume_test_players (tv_fodder_left_tower))	
	and
	not (volume_test_players_all_lookat (tv_fodder_left_tower, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_fodder_left_tower));
	print ("tv_fodder_left_tower_aikill");
end

script static void tv_fodder_rear_left_aikill()
	sleep_until (not (volume_test_players (tv_fodder_rear_left))	
	and
	not (volume_test_players_all_lookat (tv_fodder_rear_left, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_fodder_rear_left));
	print ("tv_fodder_rear_left_aikill");
end

//RIGHT

//script static void tv_fodder_front_right_aikill()
//	sleep_until (not (volume_test_players_all_lookat (tv_fodder_front_right, 3000, 40)));
//	unit_kill_list_silent (volume_return_objects (tv_fodder_front_right));
//	print ("tv_fodder_front_right_aikill");
//end
//
//script static void tv_fodder_mid_01_right_aikill()
//	sleep_until (not (volume_test_players_all_lookat (tv_fodder_mid_01_right, 3000, 40)));
//	unit_kill_list_silent (volume_return_objects (tv_fodder_mid_01_right));
//	print ("tv_fodder_mid_01_right_aikill");
//end
//
//script static void tv_fodder_mid_02_right_aikill()
//	sleep_until (not (volume_test_players_all_lookat (tv_fodder_mid_02_right, 3000, 40)));
//	unit_kill_list_silent (volume_return_objects (tv_fodder_mid_02_right));
//	print ("tv_fodder_mid_02_right_aikill");
//end
//
//script static void tv_fodder_mid_03_right_aikill()
//	sleep_until (not (volume_test_players_all_lookat (tv_fodder_mid_03_right, 3000, 40)));
//	unit_kill_list_silent (volume_return_objects (tv_fodder_mid_03_right));
//	print ("tv_fodder_mid_03_right_aikill");
//end
//
//script static void tv_fodder_rear_right_aikill()
//	sleep_until (not (volume_test_players_all_lookat (tv_fodder_rear_right, 3000, 40)));
//	unit_kill_list_silent (volume_return_objects (tv_fodder_rear_right));
//	print ("tv_fodder_rear_right_aikill");
//end

//GROUND

script static void tv_fodder_ground_aikill()
	sleep_until (not (volume_test_players_all_lookat (tv_fodder_ground, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_fodder_ground));
	print ("tv_fodder_ground_aikill");
end

//script static void cht()
//	ai_place (chop_phantom_07_sq);
//	ai_place (chop_wraith_02_sq);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_07_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location  (chop_wraith_02_sq.driver));	
//end
//
//script static void cht2()
//	ai_place (chop_phantom_05_sq);
//	ai_place (chop_ghost_04_sq);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc02", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver2));
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (chop_phantom_05_sq.driver), "phantom_sc01", ai_vehicle_get_from_starting_location  (chop_ghost_04_sq.driver));
//end

script static void display_chapter_01()
	cui_hud_set_new_objective ("chapter_01");
end

script static void display_chapter_02a()
	cui_hud_set_new_objective ("chapter_02a");
end

script static void display_chapter_02a_complete()
	cui_hud_set_objective_complete ("chapter_02a");
end

script static void display_chapter_02()
	cui_hud_set_new_objective ("chapter_02");
end

script static void display_chapter_03()
	cui_hud_set_new_objective ("chapter_03");
end

script static void display_chapter_03b()
	cui_hud_set_new_objective ("chapter_03b");
end

script static void display_chapter_03c()
	cui_hud_set_new_objective ("chapter_03c");
end

script static void display_chapter_03c_complete()
	cui_hud_set_objective_complete ("chapter_03c");
end

script static void display_chapter_03g()
	cui_hud_set_new_objective ("chapter_03g");
end

script static void display_chapter_03g_complete()
	cui_hud_set_objective_complete ("chapter_03g");
end

script static void display_chapter_03d()
	cui_hud_set_new_objective ("chapter_03d");
end

script static void display_chapter_03d_complete()
	cui_hud_set_objective_complete ("chapter_03d");
end

script static void display_chapter_04()
	cui_hud_set_new_objective ("chapter_04");
end

script static void display_chapter_05()
	cui_hud_set_new_objective ("chapter_05");
end

script static void display_chapter_06()
	cui_hud_set_new_objective ("chapter_06");
end

script static void display_chapter_07()
	cui_hud_set_new_objective ("chapter_07");
end

script static void display_chapter_08()
	cui_hud_set_new_objective ("chapter_08");
end

script static void display_chapter_09()
	cui_hud_set_new_objective ("chapter_09");
	
	objectives_finish (0);
	objectives_show (1);
end

script static void display_chapter_10()
	cui_hud_set_new_objective ("chapter_10");
end

script static void display_chapter_11()
	cui_hud_set_new_objective ("chapter_11");
end

script static void display_chapter_12()
	cui_hud_set_new_objective ("chapter_12");
end

script static void display_chapter_13()
	cui_hud_set_new_objective ("chapter_13");
end

script static void display_chapter_075()
	cui_hud_set_new_objective ("chapter_075");
end

script static void display_chapter_obj_complete()
	sleep_s (5);
end

script static void f_hud_boot_up()
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	weapon_target_designator_hide_hud();
end

script static void cinematic_test_1()
	print ("CINEMATIC NOW");

	f_insertion_begin( "CINEMATIC" );
	
	cinematic_enter( cin_m040_intro, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	switch_zone_set( cin_intro );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
		
	f_start_mission( cin_m040_intro );
	cinematic_exit_no_fade( cin_m040_intro, TRUE ); 
	dprint( "Cinematic exited!" );

end

script static void cinematic_test_2()
	print ("CINEMATIC NOW");

	//f_insertion_begin( "CINEMATIC" );
	
	//cinematic_enter( cin_m041_librarian, TRUE );
	//cinematic_suppress_bsp_object_creation( TRUE );
	//switch_zone_set( cin_m041_librarian );
	//cinematic_suppress_bsp_object_creation( FALSE );
	
	//hud_play_global_animtion (screen_fade_out);
		
	//f_play_cinematic_chain( cin_m041_librarian, cin_m041b_librarian , cin_m041c_librarian );
	//cinematic_exit_no_fade( cin_m041_librarian, TRUE ); 
	//dprint( "Cinematic exited!" );

end

script static void cinematic_test_3()
	print ("CINEMATIC NOW");

	f_insertion_begin( "CINEMATIC" );
	
	cinematic_enter( cin_m042_end, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	switch_zone_set( cin_m042_end );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
		
	f_start_mission( cin_m042_end );
	cinematic_exit_no_fade( cin_m042_end, TRUE ); 
	dprint( "Cinematic exited!" );

end

global short VAR_OBJ_LOCAL_A = 0;

script static void mam_dust_off()
	SetObjectRealVariable (main_mammoth, VAR_OBJ_LOCAL_A, 0.0); 
	object_function_set (0, 0);
	print ("SetObjectRealVariable 0");
end

script static void mam_dust_on()
	sleep_s (3);	
	SetObjectRealVariable (main_mammoth, VAR_OBJ_LOCAL_A, 1.0); 
	object_function_set (0, 1);
	print ("SetObjectRealVariable 1");
end

script static void test_door_bug()
	object_set_physics (main_mammoth, false);
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);	
	sleep (30 * 6);
	object_override_physics_motion_type(main_mammoth, 1);
end

script static void covenant_river_barrier_destroy_01()
	sleep_until (not (objects_can_see_object (player0, cov_river_barrier_01, 60))
	and
	not (objects_can_see_object (player1, cov_river_barrier_01, 60))
	and
	not (objects_can_see_object (player2, cov_river_barrier_01, 60))
	and
	not (objects_can_see_object (player3, cov_river_barrier_01, 60))
	, 1);
	object_destroy (cov_river_barrier_01);
end

script static void covenant_river_barrier_destroy_02()
	sleep_until (not (objects_can_see_object (player0, cov_river_barrier_02, 60))
	and
	not (objects_can_see_object (player1, cov_river_barrier_02, 60))
	and
	not (objects_can_see_object (player2, cov_river_barrier_02, 60))
	and
	not (objects_can_see_object (player3, cov_river_barrier_02, 60))
	, 1);
	object_destroy (cov_river_barrier_02);
end

script static void prechopper_bubble_creation()
	sleep (30 * 2);
	object_create (uplink_bubble_1);
	object_create (uplink_bubble_2);
	object_create (uplink_bubble_3);
	object_create (uplink_base_1);
	object_create (uplink_base_2);
	object_create (uplink_base_3);
	
	ai_object_set_team (uplink_base_1, covenant);
//	thread (base_1_target_bias());
	ai_object_set_team (uplink_base_2, covenant);
//	thread (base_2_target_bias());
	ai_object_set_team (uplink_base_3, covenant);
//	thread (base_3_target_bias());

	ai_object_enable_targeting_from_vehicle (uplink_base_1, true);
	ai_object_enable_targeting_from_vehicle (uplink_base_2, true);
	ai_object_enable_targeting_from_vehicle (uplink_base_3, true);

	object_create (prechopper_shield_barrier);
	
	object_set_function_variable (prechopper_shield_barrier, shield_on, 1, 1);
	
	print ("Bubbles really created!");
	
	wake (f_bubble_control);
end

script static void 	base_1_target_bias()
	sleep_until (ai_living_count (sq_bubble_1) > 0);

	sleep_until (ai_living_count (sq_bubble_1) < 1);
	ai_object_set_targeting_bias (uplink_base_1, 1);
	print ("Marines now prefer to shoot bubble 1");
end

script static void 	base_2_target_bias()
	sleep_until (ai_living_count (sq_bubble_2) > 0);

	sleep_until (ai_living_count (sq_bubble_2) < 1);
	ai_object_set_targeting_bias (uplink_base_2, 1);
	print ("Marines now prefer to shoot bubble 2");
end

script static void 	base_3_target_bias()
	sleep_until (ai_living_count (sq_bubble_3_mid_re) > 0);

	sleep_until (ai_living_count (sq_bubble_3_mid_re) < 1);
	ai_object_set_targeting_bias (uplink_base_3, 1);
	print ("Marines now prefer to shoot bubble 2");
end

//script static void test_doorz()
//	object_create (main_mammoth);
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_c);
//	unit_recorder_play (main_mammoth);
//	sleep (1);	
//	unit_recorder_pause (main_mammoth, true);
//	thread (open_tort_doors_river());
////	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var5", false);	
//end

//Caverns anims
script static void open_tort_doors_caverns()
	sleep_s(2);
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);
	sleep_s(9);
	tort_bay_doors_opened = true;
	object_override_physics_motion_type(main_mammoth, 1);

//	ObjectOverrideNavMeshCutting(main_mammoth, true);
//	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	print ("Tort Doors Opened");
end

script static void close_tort_doors_caverns()
//	ObjectOverrideNavMeshCutting(main_mammoth, false);
//	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

//Lakeside anims
script static void open_tort_doors_lakeside()
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var2", false);
	sleep_s(9);
	tort_bay_doors_opened = true;
	object_override_physics_motion_type(main_mammoth, 1);

//	ObjectOverrideNavMeshCutting(main_mammoth, true);
//	ObjectOverrideNavMeshObstacle(main_mammoth, false);
//  This happens in the AI driveout2 script

	print ("Tort Doors Opened");
end

script static void close_tort_doors_lakeside()
	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing_var2", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

//Lakeside River anims
script static void open_tort_doors_river()
	thread (covenant_river_barrier_destroy_01());
	thread (covenant_river_barrier_destroy_02());
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var3", false);
	sleep_s(9);
	object_override_physics_motion_type(main_mammoth, 1);
	tort_bay_doors_opened = true;

//	ObjectOverrideNavMeshCutting(main_mammoth, true);
//	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	print ("Tort Doors Opened");
end

script static void close_tort_doors_river()
	sleep_until (tort_bay_doors_opened == true);

//	ObjectOverrideNavMeshCutting(main_mammoth, false);
//	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing_var3", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

//Prechopper anims
script static void open_tort_doors_prechopper_start()
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var4", false);
	sleep_s(9);
	tort_bay_doors_opened = true;
	object_override_physics_motion_type(main_mammoth, 1);

	ObjectOverrideNavMeshCutting(main_mammoth, true);
	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	print ("Tort Doors Opened");
end

script static void close_tort_doors_prechopper_start()
	sleep_until (tort_bay_doors_opened == true);

	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing_var4", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

//Prechopper ending anims
script static void open_tort_doors_prechopper_end()
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var4", false);
	sleep_s(9);
	tort_bay_doors_opened = true;
	object_override_physics_motion_type(main_mammoth, 1);

	ObjectOverrideNavMeshCutting(main_mammoth, true);
	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	print ("Tort Doors Opened");
end

script static void close_tort_doors_prechopper_end()
	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing_var4", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

//Chopper anims
script static void open_tort_doors_chopper()
	tort_speed_test = false;
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_opening_var5", false);
	sleep_s(9);
	tort_bay_doors_opened = true;
	object_override_physics_motion_type(main_mammoth, 1);

	ObjectOverrideNavMeshCutting(main_mammoth, true);
	ObjectOverrideNavMeshObstacle(main_mammoth, false);

	print ("Tort Doors Opened");
end

script static void close_tort_doors_chopper()
	ObjectOverrideNavMeshCutting(main_mammoth, false);
	ObjectOverrideNavMeshObstacle(main_mammoth, true);

	object_override_physics_motion_type(main_mammoth, 2);
	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors_closing_var5", false);
	tort_bay_doors_opened = false;
	print ("Tort Doors Closed");
end

script static void tort_underneath_cleanup()

	repeat

	sleep_until (tort_stopped == false
	and
	not (volume_test_players_all_lookat (tv_tortoise_underneath_01, 3000, 40))
	and
	not (volume_test_players (tv_tortoise_underneath_01))
	);
	unit_kill_list_silent (volume_return_objects (tv_tortoise_underneath_01));
	sleep(1);
	garbage_collect_now();
	print ("tort_underneath_cleanup");

	sleep_s (5);
	
	until (tort_done_in_mission == true);
end

//script static void tort_underneath_cleanup2()
//	kill_volume_disable (kill_soft_lakeside_backtrack);
//	sleep_until (not (volume_test_players_all_lookat (tv_tort_rec_lakeside_pt2, 3000, 40))
//	and
//	not (volume_test_players (tv_tort_rec_lakeside_pt2))
//	);
//	unit_kill_list_silent (volume_return_objects (tv_tort_rec_lakeside_pt2));
//	sleep(1);
//	garbage_collect_now();
//	print ("tort_underneath_cleanup2");
//end

script static void tort_chopper_cleanup()

	sleep_until (not (volume_test_players_all_lookat (tv_tortoise_bottom_01, 3000, 40))
	and
	not (volume_test_players (tv_tortoise_bottom_01))
	);
	unit_kill_list_silent (volume_return_objects (tv_tortoise_bottom_01));
	sleep(1);
	garbage_collect_now();
	print ("tort bdunn chopper cleanup");
end

script command_script fod_enter_pod_cs()
	ai_vehicle_enter (tower_jak.guy2, (object_get_turret (fod_pod_01, 2)));
	print ("entered pod"); 
end

script static void garbage_collect_me()
	repeat
		garbage_collect_now();
		print ("garbage collected");
		sleep (30 * 15);
	until (garbage_collecting == false);
end

script static void lakeside_phantom_blipping()
		print ("lakeside_phantom_blipping!");
end

//script static void tort_directional_test()
//	if
//		objects_distance_to_point (player0, tort_top_patrol.rear) > objects_distance_to_point (player0, tort_top_patrol.front)
//	then
//		print ("player in FRONT of tortoise");
//	elseif
//		objects_distance_to_point (player0, tort_top_patrol.rear) < objects_distance_to_point (player0, tort_top_patrol.front)
//	then
//		print ("player BEHIND tortoise");
//	else
//		print ("player is both behind tortoise and in front at the same time, the universe has collapsed");	
//	end
//end

script static void lasky_pup_test()
	static short Marines_lasky_health = 0;
	Marines_lasky_health = unit_get_health (Marines_lasky);

	repeat
		Marines_lasky_health = unit_get_health (Marines_lasky);
		sleep_until (object_get_recent_body_damage (Marines_lasky) > .01, 1);
		pup_stop_show (lasky_final_pup);
		sleep_s (3);	
		print ("Marines_lasky_pup restarting");
		cs_go_to (Marines_lasky, true, tort_pup_pt.lasky_rear);
		print ("LASKY ORDERED TO WALK");
		cs_face (Marines_lasky, true, mtest2.p16);
		sleep (30 * 1);
		sleep_until (object_get_recent_body_damage (tort_marine_biped_right) == 0);	
		lasky_final_pup = pup_play_show (lasky_alt_pup);
		ai_renew (Marines_lasky);
	until	(object_get_health (Marines_lasky) <= 0);
	
end

script static void tort_bipeds()
	object_create (tort_marine_biped_right);
	object_create (tort_marine_biped_left);
	object_create (tort_marine_biped_bottom);
	ai_object_set_team (tort_marine_biped_right, player);
	ai_object_set_team (tort_marine_biped_left, player);
	ai_object_set_team (tort_marine_biped_bottom, player);
	
	objects_physically_attach (main_mammoth, "crate_1fl_target_laser", tort_marine_biped_bottom, "");
	objects_physically_attach (main_mammoth, "crate_2fl_terminal_passenger", tort_marine_biped_right, "");
	objects_physically_attach (main_mammoth, "crate_2fl_terminal_driver", tort_marine_biped_left, "");
	
	tort_marine_biped_right_long_pup = pup_play_show (tort_marine_biped_right_pup);
	tort_marine_biped_left_long_pup = pup_play_show (tort_marine_biped_left_pup);
	tort_marine_bottom_long_pup = pup_play_show (tort_marine_bottom_pup);
		
	thread (tort_marine_biped_right_pup_test());
	thread (tort_marine_biped_left_pup_test());
	thread (tort_marine_bottom_pup_test());
end

script static void tort_marine_biped_right_pup_test()

	repeat
	
		sleep_until (object_get_recent_body_damage (tort_marine_biped_right) > .01, 1);
		pup_stop_show (tort_marine_biped_right_long_pup);
		sleep_until (object_get_recent_body_damage (tort_marine_biped_right) == 0);	
		tort_marine_biped_right_long_pup = pup_play_show (tort_marine_biped_right_pup);
		
	until	(object_get_health (tort_marine_biped_right) <= 0);
	
end

script static void tort_marine_biped_left_pup_test()

	repeat
	
		sleep_until (object_get_recent_body_damage (tort_marine_biped_left) > .01, 1);
		pup_stop_show (tort_marine_biped_left_long_pup);
		sleep_until (object_get_recent_body_damage (tort_marine_biped_left) == 0);	
		tort_marine_biped_left_long_pup = pup_play_show (tort_marine_biped_left_pup);
		
	until	(object_get_health (tort_marine_biped_right) <= 0);
	
end

script static void tort_marine_bottom_pup_test()

	repeat
	
		sleep_until (object_get_recent_body_damage (tort_marine_biped_bottom) > .01, 1);
		pup_stop_show (tort_marine_bottom_long_pup);
		sleep_until (object_get_recent_body_damage (tort_marine_biped_bottom) == 0);	
		tort_marine_bottom_long_pup = pup_play_show (tort_marine_bottom_pup);
		
	until	(object_get_health (tort_marine_biped_bottom) <= 0);
	
end

script static void tort_runover_kills()
	thread (tort_runover_kill_p1());
//	thread (tort_runover_kill_p2());
//	thread (tort_runover_kill_p3());
//	thread (tort_runover_kill_p4());
	thread (tort_runover_damaging());
	thread (tort_runover_garbage_collect());
end

script static void tort_runover_kill_p1()
	repeat
		sleep_until (object_get_velocity (main_mammoth) > 3);
		print ("Mammoth is fast, WILL KILL");
			repeat
					damage_objects (volume_return_objects (tv_tortoise_underneath_01), "body", 30);		
					damage_objects (volume_return_objects (trigger_volumes_35), "body", 30);		
					damage_objects (volume_return_objects (trigger_volumes_34), "body", 30);	
					damage_objects (volume_return_objects (tv_tortoise_underneath_01), "hull", 30);		
					damage_objects (volume_return_objects (trigger_volumes_35), "hull_rear", 30);		
					damage_objects (volume_return_objects (trigger_volumes_34), "hull_front", 30);		
			until (object_get_velocity (main_mammoth) < 3);
			print ("Mammoth slowed, WILL NOT KILL");
	until (tort_done_in_mission == true);		
end

script static void tort_runover_damaging()
	repeat
		sleep_until (tort_stopped == FALSE
		and
		object_get_velocity (main_mammoth) > 0
		and
		object_get_velocity (main_mammoth) < 3		
		);
		print ("Mammoth is slow, WILL DAMAGE");
			repeat
			
				if
					volume_test_players (tv_tortoise_underneath_01)
					or
					volume_test_players (trigger_volumes_35)					
					or
					volume_test_players (trigger_volumes_34)					
				then
					damage_objects (volume_return_objects (tv_tortoise_underneath_01), "body", 30);		
					damage_objects (volume_return_objects (trigger_volumes_35), "body", 30);		
					damage_objects (volume_return_objects (trigger_volumes_34), "body", 30);	
					damage_objects (volume_return_objects (tv_tortoise_underneath_01), "hull", 30);		
					damage_objects (volume_return_objects (trigger_volumes_35), "hull_rear", 30);		
					damage_objects (volume_return_objects (trigger_volumes_34), "hull_front", 30);	
				else
					unit_kill_list_silent (volume_return_objects (tv_tortoise_underneath_01));
					unit_kill_list_silent (volume_return_objects (trigger_volumes_35));
					unit_kill_list_silent (volume_return_objects (trigger_volumes_34));	
				end				
				
				sleep (15);		
			until (object_get_velocity (main_mammoth) < 3);
//			print ("Mammoth speeding up, WILL NOT DAMAGE, WILL KILL");
	until (tort_done_in_mission == true);		
end

script static void tort_runover_garbage_collect()
	repeat
		sleep_until (object_get_velocity (main_mammoth) > 3
		and
		not (volume_test_players_all_lookat (tv_tortoise_underneath_01, 3000, 40))
		and
		not (volume_test_players (tv_tortoise_underneath_01))
		);
		sleep_s(5);
		garbage_collect_now();
		print ("tort_underneath_cleanup");
	until (tort_done_in_mission == true);	
end

script dormant main_mammoth_invincible()
//	ai_allegiance (brute, covenant);
//	ai_allegiance (brute, player);
//	ai_allegiance (brute, human);
	ai_allegiance (player, human);
//	ai_allegiance (covenant, mule);
//	sleep_s(2);
	object_cannot_die (main_mammoth, true);
	print ("Tortoise cannot take damage");
end

script static void dg_check_1()

	sleep_until (
		unit_in_vehicle_type (player0, 18)
		or
		unit_in_vehicle_type (player0, 26)
		);
		print ("done!");
end

script static void m40_dg_check()
	print ("M40 DG PRINT");
	
		if 
			game_coop_player_count() == 1
		then
			thread (m40_dg_check_1());
		end
		
		if 
			game_coop_player_count() == 2
		then
			thread (m40_dg_check_1());
			thread (m40_dg_check_2());
		end
		
		if 
			game_coop_player_count() == 3
		then
			thread (m40_dg_check_1());
			thread (m40_dg_check_2());
			thread (m40_dg_check_3());
		end
		
		if 
			game_coop_player_count() == 4
		then
			thread (m40_dg_check_1());
			thread (m40_dg_check_2());
			thread (m40_dg_check_3());
			thread (m40_dg_check_4());
		end
			
end

script static void m40_dg_check_1()
	repeat
		sleep_until (object_get_health (unit_get_vehicle (player0)) < .250, 1);
		if 
			unit_in_vehicle_type (player0, 18)
			or
			unit_in_vehicle_type (player0, 26)
		then
			unit_set_current_vitality (unit_get_vehicle (player0), 375, 1);
		end
	until (1 == 0);
end

script static void m40_dg_check_2()
	repeat
		sleep_until (object_get_health (unit_get_vehicle (player1)) < .250, 1);
		if 
			unit_in_vehicle_type (player1, 18)
			or
			unit_in_vehicle_type (player1, 26)
		then
			unit_set_current_vitality (unit_get_vehicle (player1), 375, 1);
		end
	until (1 == 0);
end

script static void m40_dg_check_3()
	repeat
		sleep_until (object_get_health (unit_get_vehicle (player2)) < .250, 1);
		if 
			unit_in_vehicle_type (player2, 18)
			or
			unit_in_vehicle_type (player2, 26)
		then
			unit_set_current_vitality (unit_get_vehicle (player2), 375, 1);
		end
	until (1 == 0);
end

script static void m40_dg_check_4()
	repeat
		sleep_until (object_get_health (unit_get_vehicle (player3)) < .250, 1);
		if 
			unit_in_vehicle_type (player3, 18)
			or
			unit_in_vehicle_type (player3, 26)
		then
			unit_set_current_vitality (unit_get_vehicle (player3), 375, 1);
		end
	until (1 == 0);
end


//---------------THESE SCRIPTS HANDLE THE TORTOISE SPEED AT VARIOUS TIMES---------------------

script static void new_tort_caverns_speed_test()

	print ("**************** Caverns Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 59;
	TST_closeup_dist = 20;
	
	TST_norm_speed = 1.0;
	TST_upper_speed = 1.8;
	
	thread (tortoise_master_speed_test());

	sleep_until (volume_test_object (tv_fod_mammoth_10, main_mammoth), 1);

	tort_speed_test = false;

	unit_recorder_set_playback_rate_smooth (main_mammoth, .5, 4);
	print ("TORT SPEED REPEATING");
	wake ( f_fodder_mammoth_playback );

end

//script static void new_tort_lakeside_speed_test()
//
//	print ("**************** Lakeside Tortoise Speed Test ****************");	
//
//	tort_speed_test = true;
//
//	TST_faraway_dist = 100;
//	TST_closeup_dist = 15;
//	
//	TST_norm_speed = .7;
//	TST_upper_speed = .7;
//	
//	thread (tortoise_master_speed_test());
//
//	sleep_until (volume_test_object (tv_tort_lakeside_river, main_mammoth), 1);
//
//	tort_speed_test = false;
//
//end

script static void new_tort_cliffside_part_1_speed_test()

	print ("**************** Cliffside Part 1 Tortoise Speed Test ****************");	

	wake (prechopper_arrival_test);

	tort_speed_test = true;

	TST_faraway_dist = 59;
	TST_closeup_dist = 20;

	TST_norm_speed = .7;
	TST_upper_speed = 1.5;
	
	thread (tortoise_master_speed_test());

	sleep_until (volume_test_object (tv_cliffside_01b, main_mammoth), 1);	

	tort_speed_test = false;

	sleep_until (tort_speed_test_active == false);
	
	thread (new_tort_cliffside_part_2_speed_test());

end

script static void new_tort_cliffside_part_2_speed_test()

	print ("**************** Cliffside Part 2 Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 59;
	TST_closeup_dist = 40;

	TST_norm_speed = .6;
	TST_upper_speed = 1.4;
	
	thread (tortoise_master_speed_test());

	sleep_until (prechopper_arrival == true);

	tort_speed_test = false;

	sleep_until (tort_speed_test_active == false);

	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 4);
	print ("TORT SPEED REPEATING = .7");

end

script static void new_tort_chopper_part_1_speed_test()

	print ("**************** Chopper Part 1 Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 19;
	TST_closeup_dist = 20;

	TST_norm_speed = 1;
	TST_upper_speed = 1.2;
	
	thread (tortoise_master_speed_test());

	sleep_until (volume_test_object (tv_chopper_blip_gun, main_mammoth));	

	tort_speed_test = false;
	
	thread (new_tort_chopper_part_2_speed_test());

end

script static void new_tort_chopper_part_2_speed_test()

	print ("**************** Chopper Part 2 Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 19;
	TST_closeup_dist = 20;

	TST_norm_speed = .5;
	TST_upper_speed = .52;
	
	thread (tortoise_master_speed_test());

	sleep_until (volume_test_object (tv_tort_rec_chopper_pt12, main_mammoth));

	tort_speed_test = false;
	
	unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 3);	
	print ("TORT SPEED REPEATING = .7");

end

script static void new_tort_waterfalls_speed_test()

	print ("**************** Waterfalls Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 40;
	TST_closeup_dist = 20;

	TST_norm_speed = 1.1;
	TST_upper_speed = 1.1;
	
	thread (tortoise_master_speed_test());

	sleep_until (current_zone_set_fully_active() == DEF_S_ZONESET_PRE_VALE());	

	tort_speed_test = false;

end

script static void new_tort_short_speed_test()

	print ("**************** Short Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 60;
	TST_closeup_dist = 15;

	TST_norm_speed = .7;
	TST_upper_speed = .9;
	
	thread (tortoise_master_speed_test());

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 15, 1)
	or
	(volume_test_object (tv_tort_rec_chopper_pt5, main_mammoth));	

	tort_speed_test = false;

end

script static void new_tort_short_speed_test_2()

	print ("**************** Short Chopper Tortoise Speed Test ****************");	

	tort_speed_test = true;

	TST_faraway_dist = 40;
	TST_closeup_dist = 25;

	TST_norm_speed = .7;
	TST_upper_speed = .9;
	
	thread (tortoise_master_speed_test());

	sleep_until (volume_test_object (tv_tort_rec_chopper_pt5, main_mammoth));	

	tort_speed_test = false;

end

script static void tortoise_master_speed_test()
	print ("NEW SPEED TEST");		
	
	tort_speed_test_active = true;

	repeat

//	Starting the check again, resetting all of the variables

		player0_tort_far_ahead = false;
		player0_tort_far_behind = false;
		
		player1_tort_far_ahead = false;
		player1_tort_far_behind = false;
		
		player2_tort_far_ahead = false;
		player2_tort_far_behind = false;
		
		player3_tort_far_ahead = false;
		player3_tort_far_behind = false;
		
		player0_on_tortoise = false;
		player0_near_tortoise = false;
		
		player1_on_tortoise = false;
		player1_near_tortoise = false;
		
		player2_on_tortoise = false;
		player2_near_tortoise = false;
		
		player3_on_tortoise = false;
		player3_near_tortoise = false;

//	Determining where players are in relation to the Tortoise

//	player0

		if
			player_valid (player0)
		then

			if
				objects_distance_to_object (player0, main_mammoth) > TST_faraway_dist
			then
				if
					objects_distance_to_point (player0, tort_top_patrol.rear) > objects_distance_to_point (player0, tort_top_patrol.front)
				then
					player0_tort_far_ahead = true;	
					print ("Player0 really far ahead of Tortoise...");
				elseif
					objects_distance_to_point (player0, tort_top_patrol.rear) < objects_distance_to_point (player0, tort_top_patrol.front)
				then
					player0_tort_far_behind = true;	
					print ("Player0 really far behind of Tortoise...");
				end
				
			elseif
				(not (volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player0))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player0))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player0))
				and
				objects_distance_to_object (player0, main_mammoth) < TST_closeup_dist)		
			then
				player0_near_tortoise = true;					
				print ("Player0 is on the ground near the Tortoise...");						
	
			elseif
				volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player0)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player0)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player0)
			then
				player0_on_tortoise = true;	
				print ("Player0 is on the Tortoise...");
			
			end

		end

//	player1

		if
			player_valid (player1)
		then

			if
				objects_distance_to_object (player1, main_mammoth) > TST_faraway_dist
			then
				if
					objects_distance_to_point (player1, tort_top_patrol.rear) > objects_distance_to_point (player1, tort_top_patrol.front)
				then
					player1_tort_far_ahead = true;	
					print ("player1 really far ahead of Tortoise...");
				elseif
					objects_distance_to_point (player1, tort_top_patrol.rear) < objects_distance_to_point (player1, tort_top_patrol.front)
				then
					player1_tort_far_behind = true;	
					print ("player1 really far behind of Tortoise...");
				end
				
			elseif
				(not (volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player1))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player1))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player1))
				and
				objects_distance_to_object (player1, main_mammoth) < TST_closeup_dist)		
			then
				player1_near_tortoise = true;					
				print ("player1 is on the ground near the Tortoise...");						
	
			elseif
				volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player1)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player1)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player1)
			then
				player1_on_tortoise = true;	
				print ("player1 is on the Tortoise...");

			end

		end

//	player2

		if
			player_valid (player2)
		then

			if
				objects_distance_to_object (player2, main_mammoth) > TST_faraway_dist
			then
				if
					objects_distance_to_point (player2, tort_top_patrol.rear) > objects_distance_to_point (player2, tort_top_patrol.front)
				then
					player2_tort_far_ahead = true;	
					print ("player2 really far ahead of Tortoise...");
				elseif
					objects_distance_to_point (player2, tort_top_patrol.rear) < objects_distance_to_point (player2, tort_top_patrol.front)
				then
					player2_tort_far_behind = true;	
					print ("player2 really far behind of Tortoise...");
				end
				
			elseif
				(not (volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player2))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player2))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player2))
				and
				objects_distance_to_object (player2, main_mammoth) < TST_closeup_dist)		
			then
				player2_near_tortoise = true;					
				print ("player2 is on the ground near the Tortoise...");						
	
			elseif
				volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player2)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player2)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player2)
			then
				player2_on_tortoise = true;	
				print ("player2 is on the Tortoise...");

			end
	
		end

//	player3

		if
			player_valid (player3)
		then

			if
				objects_distance_to_object (player3, main_mammoth) > TST_faraway_dist
			then
				if
					objects_distance_to_point (player3, tort_top_patrol.rear) > objects_distance_to_point (player3, tort_top_patrol.front)
				then
					player3_tort_far_ahead = true;	
					print ("player3 really far ahead of Tortoise...");
				elseif
					objects_distance_to_point (player3, tort_top_patrol.rear) < objects_distance_to_point (player3, tort_top_patrol.front)
				then
					player3_tort_far_behind = true;	
					print ("player3 really far behind of Tortoise...");
				end
				
			elseif
				(not (volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player3))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player3))
				and
				not (volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player3))
				and
				objects_distance_to_object (player3, main_mammoth) < TST_closeup_dist)		
			then
				player3_near_tortoise = true;					
				print ("player3 is on the ground near the Tortoise...");						
	
			elseif
				volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player3)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_middle_01, player3)
				or
				volume_test_object_bounding_sphere_center (tv_tortoise_bottom_01, player3)
			then
				player3_on_tortoise = true;	
				print ("player3 is on the Tortoise...");

			end

		end

//	 Now that we know where the players are, we will set the speed of the Tortoise...

		thread (all_players_on_tort());

//	1/5 IS A PLAYER AHEAD OF TORTOISE?

		if
			(player0_tort_far_ahead == true
			and
			player_valid (player0))
			or
			(player1_tort_far_ahead == true
			and
			player_valid (player1))
			or
			(player2_tort_far_ahead == true
			and
			player_valid (player2))
			or
			(player3_tort_far_ahead == true
			and
			player_valid (player3))
		then	
			print ("At least one player is really far ahead of the Tortoise...");
			unit_recorder_set_playback_rate_smooth (main_mammoth, TST_upper_speed, 3);	
			print ("TORT SPEED REPEATING =");
			inspect (TST_upper_speed);

//	2/5 IS A PLAYER BEHIND TORTOISE?
		
		elseif
			(player0_tort_far_behind == true
			and
			player_valid (player0))
			or
			(player1_tort_far_behind == true
			and
			player_valid (player1))
			or
			(player2_tort_far_behind == true
			and
			player_valid (player2))
			or
			(player3_tort_far_behind == true
			and
			player_valid (player3))
		then	
			print ("At least one player is really far behind the Tortoise...");
			unit_recorder_set_playback_rate_smooth (main_mammoth, .1, 3);	
			print ("TORT SPEED REPEATING = .1");
		
//	3/5 IS A PLAYER ON GROUND NEARBY TORTOISE?

		elseif
			(player0_near_tortoise == true
			and
			player_valid (player0))
			or
			(player1_near_tortoise == true
			and
			player_valid (player1))
			or
			(player2_near_tortoise == true
			and
			player_valid (player2))
			or
			(player3_near_tortoise == true
			and
			player_valid (player3))
		then	
			print ("At least one player is on the ground near the Tortoise...");
			unit_recorder_set_playback_rate_smooth (main_mammoth, .1, 3);		
			print ("TORT SPEED REPEATING = .1");
	
//	4/5 IS ANY PLAYER NOT ON THE TORTOISE?

		elseif
			(player0_on_tortoise == false
			and
			player_valid (player0))
			or
			(player1_on_tortoise == false
			and
			player_valid (player1))
			or
			(player2_on_tortoise == false
			and
			player_valid (player2))
			or
			(player3_on_tortoise == false
			and
			player_valid (player3))
		then	
			print ("At least one player is on ground but not directly near the Tortoise...");
			unit_recorder_set_playback_rate_smooth (main_mammoth, .5, 3);		
			print ("TORT SPEED REPEATING = .5");

//	5/5 ARE ALL PLAYERS ON THE TORTOISE?

		elseif
			player0_valid_and_on_tortoise_or_not_valid == TRUE
			and
			player1_valid_and_on_tortoise_or_not_valid == TRUE
			and
			player2_valid_and_on_tortoise_or_not_valid == TRUE
			and
			player3_valid_and_on_tortoise_or_not_valid == TRUE					
		then	
			print ("All players are on the Tortoise...");
			unit_recorder_set_playback_rate_smooth (main_mammoth, TST_norm_speed, 3);		
			print ("TORT SPEED REPEATING =");
			inspect (TST_norm_speed);

		end	

	sleep_s (4);

	until (tort_speed_test == false);
	
	print ("**************** Master Tortoise Speed Test FINISHED ****************");	

	tort_speed_test_active = false;

end

script static void all_players_on_tort()

	print ("all_players_on_tort");

	player0_valid_and_on_tortoise_or_not_valid = false;
	player1_valid_and_on_tortoise_or_not_valid = false;
	player2_valid_and_on_tortoise_or_not_valid = false;
	player3_valid_and_on_tortoise_or_not_valid = false;

	if
		player_valid (player0)
	then
		if
			player0_on_tortoise == true
		then
			print ("player0 valid and on the tortoise");
			player0_valid_and_on_tortoise_or_not_valid = true;
		else
			print ("player0 valid but not on the tortoise");
		end
	else
		print ("player0 not valid");
		player0_valid_and_on_tortoise_or_not_valid = true;
	end

	if
		player_valid (player1)
	then
		if
			player1_on_tortoise == true
		then
			print ("player1 valid and on the tortoise");
		player1_valid_and_on_tortoise_or_not_valid = true;
		else
			print ("player1 valid but not on the tortoise");
		end
	else
		print ("player1 not valid");
		player1_valid_and_on_tortoise_or_not_valid = true;
	end
	
	if
		player_valid (player2)
	then
		if
			player2_on_tortoise == true
		then
			print ("player2 valid and on the tortoise");
			player2_valid_and_on_tortoise_or_not_valid = true;
		else
			print ("player2 valid but not on the tortoise");
		end
	else
		print ("player2 not valid");
		player2_valid_and_on_tortoise_or_not_valid = true;	
	end
	
	if
		player_valid (player3)
	then
		if
			player3_on_tortoise == true
		then
			print ("player3 valid and on the tortoise");
			player3_valid_and_on_tortoise_or_not_valid = true;	
		else
			print ("player3 valid but not on the tortoise");
		end
	else
		print ("player3 not valid");
		player3_valid_and_on_tortoise_or_not_valid = true;	
	end

end

// TORTOISE STOPS FOR DISTANCE DISTANCE


script static void tort_stop_check_player_location()

	player0_valid_and_far_from_tortoise_or_not_valid = false;
	player1_valid_and_far_from_tortoise_or_not_valid = false;
	player2_valid_and_far_from_tortoise_or_not_valid = false;
	player3_valid_and_far_from_tortoise_or_not_valid = false;

	if
		player_valid (player0)
	then
		if 
			objects_distance_to_object (player0, main_mammoth) > TDT_dist	
		then
			print ("player0 is valid and is far away from tortoise");	
			player0_valid_and_far_from_tortoise_or_not_valid = true;
		else
			print ("player0 is valid but is not far away from tortoise");	
		end
	else
		print ("player0 is not valid so who cares about his distance from the tortoise");	
		player0_valid_and_far_from_tortoise_or_not_valid = true;
	end
	
	if
		player_valid (player1)
	then
		if 
			objects_distance_to_object (player1, main_mammoth) > TDT_dist	
		then
			print ("player1 is valid and is far away from tortoise");	
			player1_valid_and_far_from_tortoise_or_not_valid = true;
		else
			print ("player1 is valid but is not far away from tortoise");	
		end
	else
		print ("player1 is not valid so who cares about his distance from the tortoise");	
		player1_valid_and_far_from_tortoise_or_not_valid = true;
	end
	
	if
		player_valid (player2)
	then
		if 
			objects_distance_to_object (player2, main_mammoth) > TDT_dist	
		then
			print ("player2 is valid and is far away from tortoise");	
			player2_valid_and_far_from_tortoise_or_not_valid = true;
		else
			print ("player2 is valid but is not far away from tortoise");	
		end
	else
		print ("player2 is not valid so who cares about his distance from the tortoise");	
		player2_valid_and_far_from_tortoise_or_not_valid = true;
	end
	
	if
		player_valid (player3)
	then
		if 
			objects_distance_to_object (player3, main_mammoth) > TDT_dist	
		then
			print ("player3 is valid and is far away from tortoise");	
			player3_valid_and_far_from_tortoise_or_not_valid = true;
		else
			print ("player3 is valid but is not far away from tortoise");	
		end
	else
		print ("player3 is not valid so who cares about his distance from the tortoise");	
		player3_valid_and_far_from_tortoise_or_not_valid = true;
	end
	
end

//tar pit damaging

script static void f_m40_damage_volume_players( trigger_volume tv_damage, real r_damage_initial, real r_damage_mod, short s_ticks )
	local real r_p0_damage = 0.0;
	local real r_p1_damage = 0.0;
	local real r_p2_damage = 0.0;
	local real r_p3_damage = 0.0;
	//dprint( "::: f_damage_volume_players :::" );

	repeat

		if ( not volume_test_players(tv_damage) ) then
			r_p0_damage = 0.0;
			r_p1_damage = 0.0;
			r_p2_damage = 0.0;
			r_p3_damage = 0.0;
			sleep_until( volume_test_players(tv_damage), 1 );
		end
		
		// damage players
		r_p0_damage = sys_damage_volume_player( tv_damage, Player0(), r_damage_initial, r_damage_mod, r_p0_damage );
		r_p1_damage = sys_damage_volume_player( tv_damage, Player1(), r_damage_initial, r_damage_mod, r_p1_damage );
		r_p2_damage = sys_damage_volume_player( tv_damage, Player2(), r_damage_initial, r_damage_mod, r_p2_damage );
		r_p3_damage = sys_damage_volume_player( tv_damage, Player3(), r_damage_initial, r_damage_mod, r_p3_damage );
		
	until( FALSE, s_ticks );

end

script static real sys_damage_volume_player( trigger_volume tv_damage, unit obj_player, real r_damage_initial, real r_damage_mod, real r_damage_current )
	//dprint( "::: sys_damage_volume_player :::" );

	if ( not volume_test_object(tv_damage, obj_player) ) then
		r_damage_current = 0.0;
	elseif ( r_damage_current != 0.0 ) then
		r_damage_current = r_damage_current * r_damage_mod;
	else
		r_damage_current = r_damage_initial;
	end
	
	if ( r_damage_current != 0.0 ) then
		damage_object( obj_player, "body", r_damage_current );
	end
	//inspect( r_damage_current );  
	
	// return
	r_damage_current;
end

script static void fx_epic_skybox_lensflares()
	print ("fx_epic_skybox_lensflares");
	effect_new(environments\solo\m40_invasion\fx\lens_flare\skylensflare1.effect, fx_water_epic);
	effect_new(environments\solo\m40_invasion\fx\lens_flare\skylensflare2.effect, fx_sun_epic);
end

script static void reserve_mammoth_vehicles()
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 0)), true);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 1)), true);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 2)), true);
end

script static void unreserve_mammoth_vehicles()
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 0)), false);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 1)), false);
	ai_vehicle_reserve (vehicle(list_get (volume_return_objects_by_campaign_type (tv_tortoise_bottom_01, 18), 2)), false);
end

//script static void exit_mammoth_vehicles()
//
//	ai_vehicle_exit
//
////	ai_vehicle_exit (list_get (volume_return_objects_by_type (tv_tortoise_bottom_01, 2), 0));
////	ai_vehicle_exit (object_get_ai (list_get (volume_return_objects_by_type (tv_tortoise_bottom_01, 2), 1)));
////	ai_vehicle_exit (object_get_ai (list_get (volume_return_objects_by_type (tv_tortoise_bottom_01, 2), 2)));
////	ai_vehicle_exit (object_get_ai (list_get (volume_return_objects_by_type (tv_tortoise_bottom_01, 2), 3)));
////	ai_vehicle_exit (object_get_ai (list_get (volume_return_objects_by_type (tv_tortoise_bottom_01, 2), 4)));
//
////	if
////		not (vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_d", player0))
////	then
////		ai_vehicle_exit (vehicle_driver (marines_main_hog_01_veh));
////	end
////	
////	if
////		not (vehicle_test_seat_unit (marines_main_hog_01_veh, "warthog_g", player0))
////	then
////		unit_exit_vehicle (vehicle_gunner (marines_main_hog_01_veh));
////	end
////
////	if
////		not (vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_d", player0))
////	then
////		unit_exit_vehicle (vehicle_driver (marines_main_hog_02_veh));
////	end
////	
////	if
////		not (vehicle_test_seat_unit (marines_main_hog_02_veh, "warthog_g", player0))
////	then
////		unit_exit_vehicle (vehicle_gunner (marines_main_hog_02_veh));
////	end
//
//end