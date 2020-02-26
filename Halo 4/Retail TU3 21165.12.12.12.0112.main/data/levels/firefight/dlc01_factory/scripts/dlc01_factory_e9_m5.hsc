//==============================================================================================================
//======= FORERUNNER STRUCTURE E9_M5 FIREFIGHT SCRIPT ==========================================================
//==============================================================================================================

/*global short s_scenario_state = 0;
	// 10 - hilltop reached
	// 20 - hilltop core destroyed
	// 30 - camp complete
	// 40 - door reached
	// 50 - second core destroyed
	// 60 - third core destroyed
	// 70 - west structure open
	// 80 - central structure open
	// 90 - all AI dead
	// 100 - nukes found
*/

global boolean b_swarm_fended = FALSE;
global boolean b_players_approached_door = FALSE;
global boolean b_players_entered_center = FALSE;
global boolean b_players_interior = FALSE;
global boolean b_players_interior_hall = FALSE;
global boolean b_players_left_donut = FALSE;
global boolean b_players_uptop = FALSE;
global boolean b_players_explored = FALSE;
global object obj_target = none;
global boolean b_players_in_donut = FALSE;
global boolean b_interior_dialogue_finished = FALSE;
global boolean b_interior_combat_started = FALSE;
global boolean b_interior_combat_finished = FALSE;
global boolean b_players_started_hall = FALSE;
global boolean b_interior_combat_update = FALSE;
global short s_bishops_spawned = 0;
global short s_knights_spawned = 0;
global boolean b_toppawn_combat_finished = FALSE;
global boolean b_top_dialogue_finished = FALSE;
global boolean b_top_battle_half_complete = FALSE;
global boolean b_e9_m5_artifact2_activated = FALSE;
global boolean b_top_battle_complete = FALSE;
global boolean b_interior_final = FALSE;
global boolean b_garden_clear = FALSE;
global boolean b_time_to_go = FALSE;
global boolean b_okay_go_on = FALSE;
global boolean b_doors_open = FALSE;
global short villain_fight_stage = 0;
global boolean b_villain_fight_birds_flyaway = FALSE;
global boolean b_players_entering_interior = FALSE;
global boolean b_e9_m5_players_inside_interior = FALSE;
global boolean b_breakout = FALSE;
global boolean b_open_garage_now = FALSE;
global boolean b_e9_m5_callout_was_just_called = FALSE;
global real r_e9_m5_countdowns_in_progress = 0;
global boolean b_pawns_shardspawned1 = FALSE;
global boolean b_pawns_shardspawned2 = FALSE;
global real r_bishops_birthed = 0;
global boolean b_popcover = FALSE;
global boolean b_all_ready = FALSE;
global boolean b_script_ready = FALSE;
global boolean b_combat_ready = FALSE;
global boolean b_villain_needs_replacing = FALSE;
global boolean b_okay_to_callout_watchers = FALSE;
global boolean b_pawns1_spawned = FALSE;
global boolean b_pawns2_spawned = FALSE;
global boolean b_pawns3_spawned = FALSE;
global boolean b_rounding_up = FALSE;
global boolean b_wayup_init = FALSE;
global real r_move_it_times = 0;
global boolean b_poker_go_now = FALSE;
global boolean b_rushtime = FALSE;
global boolean b_let_me_grats_first_bro = FALSE;
global boolean b_rvb_interact = FALSE;
global real r_interact_pup_finished = 0;
global boolean b_will_never_be_true = FALSE;
global boolean b_e9_m5_mission_over = FALSE;
global boolean b_talk_now = FALSE;
global boolean b_phantom_4_skip = FALSE;
global boolean b_phantom_4_skip2 = FALSE;
global boolean b_Phantom_5_skip = FALSE;
global boolean b_phantom_5_skip2 = FALSE;
global boolean b_neveragain = FALSE;
global boolean b_player_ready = FALSE;
global boolean b_player0_alive = FALSE;
global boolean b_player1_alive = FALSE;
global boolean b_player2_alive = FALSE;
global boolean b_player3_alive = FALSE;
global boolean b_map_examined = FALSE;
global boolean b_its_ok_to_grats_players = FALSE;

script startup dlc01_factory_e9_m5
	if (f_spops_mission_startup_wait("is_e9_m5")) then
		wake(f_e9_m5_mission_setup);
	end
end

script dormant f_e9_m5_mission_setup
	//fade_out (0,0,0,1);
	//sleep_until (LevelEventStatus("is_e9_m5"), 1);
	//firefight_mode_set_player_spawn_suppressed(true);
	//b_wait_for_narrative_hud = true;
	//fade_out (0,0,0,1);
	
	f_spops_mission_setup("is_e9_m5", e9_m5, gr_e9_m5_ai_all, ff_e9_m5_spawn_0_94, 94);
	dprint ("*********E9_M5 SCRIPT STARTING - LAST UPDATED DATE*********Dec 7, 2012*********");		
	thread(f_e9_m5_mission_intro());									
	thread(f_e9_m5_mission_start());		
	thread(f_music_e09m5_start());
	thread(f_audio_gravlift());
	
//==============================================================================================
//================================================== OBJECTS ===================================
//==============================================================================================
	
	f_add_crate_folder(dm_doors);																					//tjp
	
	f_add_crate_folder(v_e9_m5_unsc);	
	f_add_crate_folder(e9_m5_garden_crates);
	f_add_crate_folder(e9_m5_garden_scenery);
	f_add_crate_folder(e9_m5_machines_2);
	f_add_crate_folder(e9_m5_cover_wave1);
	f_add_crate_folder(e9_m5_controls);
	f_add_crate_folder(e9_m5_guns);
	f_add_crate_folder(e9_m5_pts);
	f_add_crate_folder(eq_e9_m5_ammo);
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_0_94, 94);		//initial player spawns, on landing pad in garden
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_1_25, 25);    //garden garage, at Donut Door. (for donut fight)
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_2_96, 96);    // donut outside rampdoor hall
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_3_97, 97);    //interior
	
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_5_99, 99);    // upper, by gravlift exit hole
	firefight_mode_set_crate_folder_at(ff_e9_m5_spawn_hall_93, 93);   // in the hall
	firefight_mode_set_crate_folder_at(ff_e9_m5_villain_1_spawn_92, 92);  // on the near side of interior exterior
	//firefight_mode_set_objective_name_at(dc_e9_m5_core_button, 53); //switch in lower interior room to power up the grav lift
	object_create(factory_cov_shield_loop_up_01);
	object_create(factory_cov_shield_loop_up_02);
	object_create(factory_cov_shield_loop_up_03);
	object_create(factory_cov_shield_loop_up_04);
	f_spops_mission_setup_complete( TRUE );
end

//===============================================================================================
//========= INTRO SCRIPTS =======================================================================
//===============================================================================================
script static void f_e9_m5_mission_intro
	sleep_until(f_spops_mission_ready_complete(), 1);
	//if editor_mode() then	
	//	sleep_s(1);
	//else
	//	sleep_until(LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
	//	//firefight_mode_set_player_spawn_suppressed(true);
	//end
	thread(f_start_stuff());
	f_spops_mission_intro_complete( true );
	/*
	thread(f_initial_placed_holdstill(gr_e9_m5_marines_1));
	thread(f_initial_placed_holdstill(sq_e9_m5_pelican_1));
	thread(f_initial_placed_holdstill(sq_e9_m5_pelican_2));
	thread(f_initial_placed_holdstill(sq_e9_m5_phantom_2));
	thread(f_initial_placed_holdstill(sq_e9_m5_phantom_3));
	thread(f_initial_placed_holdstill(sq_e9_m5_phantom_3b));*/
end	  

script static void f_player0_sleep_until_alive
	sleep_until(player_valid(player0), 1);
	sleep_until((object_get_health (player0) > 0), 1);
	b_player0_alive = true;
end
script static void f_player1_sleep_until_alive
	sleep_until(player_valid(player1), 1);
	sleep_until((object_get_health (player1) > 0), 1);
	b_player1_alive = true;
end
script static void f_player2_sleep_until_alive
	sleep_until(player_valid(player2), 1);
	sleep_until((object_get_health (player2) > 0), 1);
	b_player2_alive = true;
end
script static void f_player3_sleep_until_alive
	sleep_until(player_valid(player3), 1);
	sleep_until((object_get_health (player3) > 0), 1);
	b_player3_alive = true;
end

script static void f_start_stuff
	thread(f_player0_sleep_until_alive());
	thread(f_player1_sleep_until_alive());
	thread(f_player2_sleep_until_alive());
	thread(f_player3_sleep_until_alive());
	sleep_until((b_player0_alive == true) or
							(b_player1_alive == true) or
							(b_player2_alive == true) or
							(b_player3_alive == true), 1);
	kill_script(f_player0_sleep_until_alive);
	kill_script(f_player1_sleep_until_alive);
	kill_script(f_player2_sleep_until_alive);
	kill_script(f_player3_sleep_until_alive);
	ai_place(gr_e9_m5_marines_1);
	ai_place(sq_e9_m5_pelican_1);
	ai_place(sq_e9_m5_pelican_2);
	ai_place(sq_e9_m5_phantom_2);
	ai_place(sq_e9_m5_phantom_3);
	ai_place(sq_e9_m5_phantom_3b);
	ai_place(sq_e9_m5_marines_hog_1);
	ai_place(sq_e9_m5_marines_hog_2);
end

//===============================================================================================
//========= MISSION START =======================================================================
//===============================================================================================
script static void f_e9_m5_mission_start
	sleep_until (LevelEventStatus("e9_m5_garden_attack"), 1);
	sleep_until(f_spops_mission_start_complete(), 1);
	thread(vo_e9m5_narrative_in());					 ////////////////////////////////////////////////////////////////
	// Miller : Crimson, hope you caught your breath. Because here come the bad guys.	
	//sleep(1);
	//b_player_ready = true;
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_warthog_explosion', sq_e9_m5_marines_hog_1, 1);
	thread(f_music_e09m5_narr_in());
	//dprint ("Players Spawned!");
	sleep(1);
	thread(f_e9_m5_obj1_txt());	
	sleep(1);
	//fade_in(0,0,0,30);
	player_control_fade_in_all_input(120);
end	
	
script static void f_e9_m5_obj1_txt
	sleep(52);
	thread(f_e9m5_INTRO_HOG_SPLOSION());
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	thread(f_e9_m5_watchout_miller_callouts());					 ////////////////////////////////////////////////////////////////
	// Miller : Oh no!.	
	sleep(48);
	thread(vo_e9m5_phantoms());					 ////////////////////////////////////////////////////////////////
	//Miller : Phantoms! Get to cover!  ---TO--- Miller : Prometheans! Take 'em out
	sleep(15);
	thread(f_closedoor(dm_garden_door, 2));    // shut the door! You shall not pass!
	sleep_s(7);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	//sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(1);
	thread(f_garden_combat()); 	
	thread(f_e9_m5_one_more());
	thread(f_new_objective(e9_m5_defeat_attackers));     //KILL ALL HOSTILES
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(9);
	else
		sleep_s(1);
	end
	sleep_until (LevelEventStatus("e9_m5_garden_quarter"), 1);	
	thread(vo_e9m5_garden1());//////////////////////////////////////////////////////////////////////////////
	//Miller : Poker Squad, how ---TO--- Miller : Be with you soon
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_until (LevelEventStatus("e9_m5_garden_half"), 1);	
	f_add_crate_folder(cr_e9_m5_garden_garage_crates);
	b_open_garage_now = true;
	sleep_s(1);			
 	f_opendoor(dm_garden_door, 5);   	//Opening Garage for Final Garden Fight  
	sleep(41); 
	thread(f_e9_m5_incoming_immediate_callouts());    // Miller : More bad guys!
 	//sound_impulse_start ('sound\environments\multiplayer\factory\ambience\objects\factory_garden_door_open_in', dm_garden_door, 1);
	b_swarm_fended = true;					//all ai can retreat to final door
	sleep_s(1);
 	f_opendoor(dm_garden_cover1a, 5); 
 	f_opendoor(dm_garden_cover1b, 5); 
 	sleep_s(1);
 	f_opendoor(dm_garden_cover2, 5); 
 	sleep_s(1);
	if (ai_living_count (gr_e9_m5_ai_all) > 0) then
		thread(vo_e9m5_garden2());    ///////////////////////////////////////////////////////////////////
		//9-5 Marine 1 : Poker to Spartans  ---TO--- Miller : Crimson, move a little
		sleep_s(1);
		sleep_until(b_e9m5_narrative_is_on == false, 1);
	end
	sleep(25);		
	notifylevel ("e9_m5_garden_door_opened");
	thread(f_e9_m5_roundup());
	sleep(1);	
	//if (ai_living_count(gr_e9_m5_ai_all) > 0 and ai_living_count(gr_e9_m5_garden_bishops)<= 0 and ai_living_count(gr_e9_m5_garden_knights)<= 0) then // still ai up but no bish, knight
	sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	sleep(2);
	notifylevel("roundup");
	//kill_script(f_e9_m5_birth);
	//------------------one left---------------------------
	thread(f_lastone_check_loop());
	//-----------------------------------------------------
	sleep_until(LevelEventStatus("allclear"), 1);
	/*else  // bishops and knights rez/birth eachother which totally screws up last remaining calls, b/c they can spawn a huge number of dudes, so we check a few times.
		// for example, if we call 'roundup' (blip last), then a ton more dudes spawn, they wont be blipped! (Bad!)
		//kill_script(f_e9_m5_birth);
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 3, 1);
		sleep(5);
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 3, 1);
		sleep(5);
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 3, 1);
		sleep(9);
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 3, 1);
		sleep(9);
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
		sleep(9);
		notifylevel("roundup");
		//kill_script(f_e9_m5_birth);
		sleep_until(LevelEventStatus("allclear"), 1);
	end*/
	sleep(42);
	thread(f_e9_m5_grats_callouts());
	thread(f_players_approached_doortrigger());  // wait for players to approach door trigger to donut, which progresses gameplay, melts away the door, meet poker squad!         
	sleep(1);
	notifylevel("grats");
	notifylevel("e9_m5_garden_full_clear");
	b_garden_clear = true;
	thread(f_music_e09m5_garden3());
	notifylevel("e9_m5_garden_swarms_fended");	
	ai_place(sq_e9_m5_marines_2_poker);
	sleep(1);
	ai_place(sq_e9_m5_donut_knights_1);
	sleep_s(1);
	f_create_new_spawn_folder (25); // spawn plyrs in room before donut, at the 1st dissolve door
	sleep(15);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	thread(vo_e9m5_garden3());   ///////////////////////////////////////////////////////////////////
	//Miller : Area secured? Nice.  ---TO--- 9-5 Marine 1 : Understood, Spartan.
	sleep(1);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_s(2);	
	sleep(1);
	thread(f_new_objective(e9_m5_door_open));										//e9_m5_door_open = "Rendezvous with Poker Squad"
	sleep_s(1);		
	object_create(lz_04);
	sleep(4);
	//f_add_crate_folder(dm_e9_m5_donut_machines);							//tjp
	sleep(4);
	thread(f_e9_m5_move_it());
	thread(f_e9_m5_move_it_periodic_reminder());
	f_blip_object_cui(lz_04, "navpoint_goto");
	thread(f_e9_m5_obj4_txt());	
	sleep(1);
	sleep_until (b_players_approached_door == true, 1);	
	kill_script(f_e9_m5_move_it_periodic_reminder);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e9_m5_switch_side_door1, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(dm_e9_m5_switch_side_door1, phase_out, "button_marker");
	//thread(f_e9_m5_dissolve_out_no_destroy(dm_donut_ramp_door, "button_marker"));  // hide the far button
	r_move_it_times = 2;
	b_poker_go_now = true;
	object_destroy(lz_04);
	notifylevel("e9_m5_center_opened");
	object_create(cr_e9_m5_ammo_crate_1);
	object_create(cr_e9_m5_ammo_crate_2);
	sleep(1);
	f_add_crate_folder(sc_e9_m5_donut_scenery);
	f_add_crate_folder(wp_e9_m5_donut_unsc_weaps);
	sleep(1);		
	//object_create(dm_donut_ramp_door);   //hide the far button
	sleep(1);
	sleep_s(1);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\factory\dm\spops_factory_dm_center_door_large_open_mnde10277', dm_donut_garden_upper, audio_center, 1 ); //AUDIO!
	device_set_position(dm_donut_garden_upper, 1);
	thread(f_music_e09m5_donut());
	sleep_s(1);
	thread(vo_e9m5_poker_squad_greeting());         /////////////////////////////////////////////////////////////////////////////
	// Poker Squad Leader : Good to see you, Spartans! Welcome to the fun!
	b_talk_now = true;
end

script static void f_e9_m5_obj4_txt								//"INVESTIGATE CENTRAL AREA"
		sleep_until (LevelEventStatus("e9_m5_center_opened"), 1);	
		f_create_new_spawn_folder (25); //spawn plyrs in room before donut, at the 1st dissolve door
		notifylevel("e9_m5_time");
		b_players_entered_center = true;
		notifylevel("un-limbo");
		ai_place_in_limbo(sq_e9_m5_donut_pawns_1);
		sleep(1);
		//cs_phase_in(sq_e9_m5_donut_pawns_1, true);
		sleep(1);
		notifylevel("un-limbo");
		//object_destroy(dc_e9_m5_switch_side_door2);
		notifylevel("un-limbo");
		//thread(f_e9m5_dissolve_door(dm_donut_garden_upper));
		//object_move_to_point (e9_m5_door_garden_to_donut, 9, e9_m5_door_pts.p2);
		notifylevel("un-limbo");
		thread(f_pokermoveout());
		sleep_s(4);
		sleep(1);
		sleep_until(b_e9m5_narrative_is_on == false and b_talk_now == true, 1);
		thread(vo_e9m5_donut());         /////////////////////////////////////////////////////////////////////////////
		//Roland : Spartan Miller  ---TO--- Roland : I got nothing
		thread(f_sensible_wait_time_after_badnews_before_gratzing_players());
		sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
		ai_place_in_limbo(sq_e9_m5_donut_pawns_4);
		//ai_place_in_limbo(sq_e9_m5_donut_pawns_5);
		sleep(1);
		//cs_phase_in(sq_e9_m5_donut_pawns_4, true);
		//cs_phase_in(sq_e9_m5_donut_pawns_5, true);
		sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 5, 5);
		sleep(1);
		sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 4, 1);
		ai_place_in_limbo(sq_e9_m5_donut_pawns_1);
		sleep(1);
		sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 4, 1);
		//sleep_until(b_e9m5_narrative_is_on == false, 1);
		if (ai_living_count(gr_e9_m5_ai_all) > 0) then
			notifylevel("roundup");

	//------------------one left---------------------------
	thread(f_lastone_check_loop());
	//-----------------------------------------------------
			sleep_until(LevelEventStatus("allclear"), 1);  
		end
		sleep(45);
		if b_e9m5_narrative_is_on == false then        // if dialogue is being given dont queue up a grats!
			if b_its_ok_to_grats_players == true then
				notifylevel("grats");
			else
				dprint("*********JUST GOT BAD NEWS ABOUT HAWK, NOT APPROPRIATE TO GRATS PLAYERS!**********");
			end
		end
		sleep(1);
		b_let_me_grats_first_bro = true;
		sleep(68);
		thread(f_e9_m5_obj4a_txt());
end

script static void f_e9_m5_obj4a_txt						//"get to door to interior hall" 	
		sleep_until(b_let_me_grats_first_bro == true, 1);
		sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 3, 1);
		sleep(15);	
		sleep_until(b_let_me_grats_first_bro == true, 1);
		sleep(1);
		thread(f_music_e09m5_donut_end());
		thread(vo_e9m5_donut_end());         //////////////////////////////////////////////////////////////////////////
		//Miller : Poker Squad, you  ---TO--- Miller : Crimson, fall out
		sleep(69);
		//sleep_until(b_e9m5_narrative_is_on == false, 1);
		sleep(1);
		f_create_new_spawn_folder (96);   // respawn players outside door to rampdown hallway		
		sleep(1);  
		thread(f_new_objective(e9_m5_door_c_open));	//   e9_m5_door_c_open = "Locate Hawk Squad"
		sleep(1);
		thread(f_e9_m5_obj5_txt());
		//object_create(dc_e9_m5_switch_side_door1);  // door created in folder e9_m5_controls, at start
		sleep(135);		
		thread(f_e9_m5_move_it_periodic_reminder2());		
		//ok lets try this new way				
		//USAGE//f_e9_m5_blip_button( device control for button, device machine for button, device machine(artifacts), button derez string, scenery door mesh, additional machine)	
		
		dprint("REZZING IN BUTTON");
		object_hide(dm_e9_m5_switch_side_door1, FALSE);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dm_e9_m5_switch_side_door1, 1 ); //REZ IN AUDIO!
		object_dissolve_from_marker(dm_e9_m5_switch_side_door1, phase_in, "button_marker");
		sleep(15);
		f_blip_object_cui (dc_e9_m5_switch_side_door1, "navpoint_activate");
		sleep(1);
 		device_set_power(dc_e9_m5_switch_side_door1, 1); 	
		dprint("SLEEPING TIL BUTTON PUSHED");	
		sleep_until(object_valid(dc_e9_m5_switch_side_door1) and (device_get_position(dc_e9_m5_switch_side_door1) == 1), 1);
		f_unblip_object(dc_e9_m5_switch_side_door1);
		local long p_press = pup_play_show(pup_e9_m5_doorswitch1);
		sleep_until(not pup_is_playing(p_press));
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e9_m5_switch_side_door1, 1 ); //DEREZ AUDIO!
		object_dissolve_from_marker(dm_e9_m5_switch_side_door1, phase_out, "button_marker");
		sleep_s(4);
		object_destroy(dm_e9_m5_switch_side_door1);
		sound_impulse_start_marker ( 'sound\environments\multiplayer\factory\dm\spops_factory_dm_center_door_large_open_mnde10277', dm_donut_ramp_door, audio_center, 1 ); //AUDIO!
		device_set_position(dm_donut_ramp_door, 1);
		object_destroy (dm_wedge_ramp_door);												//tjp
		object_destroy (dm_interior_lift_door);											//tjp
		//thread(f_e9_m5_blip_button(dc_e9_m5_switch_side_door1, dm_donut_ramp_door, NONE, "button_marker", dm_donut_ramp_door, NONE));		// INTERACT SCRIPT		
		
		//thread(f_e9_m5_blip_button(dc_e9_m5_core_button, dm_e9_m5_core_button, core_door, "dissolve_mkr", NONE, NONE));		
		//old way
		//thread(f_e9_m5_dissolve_door(dc_e9_m5_switch_side_door1, dm_donut_ramp_door, dm_donut_ramp_door, "leaving_donut"));
		//sleep_until (LevelEventStatus("leaving_donut"), 1);	
		thread(f_rvb_interact());		
		kill_script(f_e9_m5_move_it_periodic_reminder2);
		r_move_it_times = 4;
		b_players_left_donut = true;  //for ai task control, consider players out of donut
		//object_move_to_point (e9_m5_door_donut_to_interior, 5, e9_m5_door_pts.p4); 
		notifylevel("TimeForHall");
		thread(f_e9_m5_spawnpoint_unlockers());
		f_add_crate_folder(cr_e9_m5_interior_crates);
		f_add_crate_folder(dm_e9_m5_interior_machines);
		sleep(15);
		thread(f_e9_m5_dissolve_out_no_destroy(dm_e9_m5_core_button, "dissolve_mkr"));
end

script static void f_e9_m5_obj5_txt		      //Going down Hall 
	sleep_until	(LevelEventStatus("TimeForHall"),1);		
	thread(f_popcover());
	//thread(f_all_ready_checker());
	//thread(f_e9_m5_pawns_hall_tease_callouts());
	thread(f_e9_m5_players_entering_interior());		
	ai_place_in_limbo(sq_e9_m5_Villain_knight);		
	sleep_until (volume_test_players(e9_m5_players_started_hall) == true, 1, 30 * 2);
	b_players_started_hall = true;
	f_create_new_spawn_folder (93);          // spawn players in hall if they die	
	ai_place_in_limbo(sq_e9_m5_hall_pawns_1);			//spawn the hall-dogs to lead players
	thread(f_music_e09m5_way_up());
	sleep(92);
	thread(f_e9_m5_pawns_hall_tease_callouts());
	//notifylevel("pawns2");
	b_players_interior_hall = true;
	sleep_until (volume_test_players(e9_m5_players_down_hall) == true, 1);	
	thread(vo_e9m5_interior1()); /////////////////////////////////////////////////////////////////////////////////
	//Miller : A moment, Crimson.  ---TO--- Miller : Trying to figure
	thread(f_music_e09m5_bishop());
	b_players_interior = true;				
	sleep(15);
	cs_phase_in(sq_e9_m5_Villain_knight, true);	
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.interior_knights_p1);
	thread(f_villain_replacer());                          // give us a replacement if we need one, incase knight1 dies before he gets to pt4
	villain_fight_stage = 1;
	dprint("------------------FIGHT STAGE 2-----------------");
	sleep(10);
	//thread(f_e9_m5_watchercallout_watcher());
	sleep_until(LevelEventStatus("spawnhealers") or ai_living_count (sq_e9_m5_Villain_knight) <= 0, 1);	
	thread(f_e9_m5_bishop_spawn_vortex_if_needed(fl_e9_m5_bishop_spawn_vortex_1, 1));
	///// OPEN THE VORTEX
	/////  SPAWN healer, healer2
	thread(f_bishop_rush_countdown());
	thread(f_new_objective(e9_m5_defeat_attackers));   // KILL ALL HOSTILES  
	sleep_s(1);
	//thread(f_if_pawns1_spawns_start_VO());    // if pawns successfully spawn // Miller : Watchers!
	//thread(f_if_pawns2_spawns_start_VO());
	//thread(f_if_pawns3_spawns_start_VO());
	sleep(2);
	//thread(f_healer_watch());
	sleep_until(ai_living_count (sq_e9_m5_Villain_knight) <= 0, 1, 30 * 5);
	sleep_until (volume_test_players(players_really_inside_interior) == true, 1);	
	f_create_new_spawn_folder (92);     // spawn players inside the normal area   
	//thread(f_e9_m5_snipers_callouts());
	//thread(f_watcher_callout_loop());
	thread(f_villain_shard_manager());
	sleep(35);
	if (ai_living_count(gr_e9_m5_Villain_knights) > 0) then
		thread(f_e9_m5_snipers_callouts());
	end
	//notifylevel("snipers");	  	// Miller : Sniper!
	sleep(35);	
	sleep_s(5);
	sleep_until((ai_living_count(sq_e9_m5_Villain_knight) + ai_living_count(sq_e9_m5_Villain_knightX)) <= 0, 1);
	sleep_s(2);
	sleep_until((ai_living_count(sq_e9_m5_Villain_knight) + ai_living_count(sq_e9_m5_Villain_knightX)) <= 0, 1);
	thread(f_e9_m5_keep_it_up());	
	thread(f_e9_m5_bishop_spawn_vortex_if_needed(fl_e9_m5_bishop_spawn_vortex_2, 2));
	///// OPEN THE VORTEX
	/////  CHECK healer totals
	/////  Find how many replacements are needed to restore total birds to SIX
	/////  SPAWN healer3, healer4 if necessary to replenish 
	villain_fight_stage = 2;
	dprint("------------------FIGHT STAGE 2-----------------");
	sleep(10);
	if not (ai_living_count(gr_e9_m5_villain_healers) <= 2) then     // if there arent less than 2 healers alive, wait for a few seconds
		sleep_s(4);
	end	
	//kill_script(f_watcher_callout_loop);
	ai_place_in_limbo(sq_e9_m5_Villain_knight2);	
	sleep(1);
	cs_phase_in(sq_e9_m5_Villain_knight2, true);
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.interior_knights_p2);
	sleep(75);	
	sleep_s(4);
	if (ai_living_count(gr_e9_m5_villain_knights) > 0) then
		ai_place_with_birth(sq_e9_m5_Villain_healers_spare); 
	end
	sleep_s(4);
	if (ai_living_count(sq_e9_m5_Villain_healers_spare) <= 0) then
		ai_place_with_birth(sq_e9_m5_Villain_healers_spare); 
	end
	sleep_until(ai_living_count (sq_e9_m5_Villain_knight2) <= 0, 1);	
	thread(f_e9_m5_bishop_spawn_vortex_if_needed(fl_e9_m5_bishop_spawn_vortex_3, 3));	
	///// OPEN THE VORTEX
	/////  CHECK healer totals
	/////  Find how many replacements are needed to restore total birds to SIX
	/////  SPAWN healer5, healer6 if necessary to replenish 	
	villain_fight_stage = 3;
	dprint("------------------FIGHT STAGE 3-----------------");
	sleep(10);
	if not (ai_living_count(gr_e9_m5_villain_healers) <= 2) then 
		sleep_s(4);
		sleep_s(5);
	end	
	ai_place_in_limbo(sq_e9_m5_Villain_knight3);	
	sleep(1);
	cs_phase_in(sq_e9_m5_Villain_knight3, true);	
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.interior_knights_p3);
	sleep(75);		
	if (ai_living_count(gr_e9_m5_villain_knights) > 0) then
		ai_place_with_birth(sq_e9_m5_Villain_healers_spare); 
	end
	b_breakout = true;
	sleep_until((ai_living_count(sq_e9_m5_Villain_knight) + ai_living_count(sq_e9_m5_Villain_knight2) + ai_living_count(sq_e9_m5_Villain_knight3)) <= 0, 1);	
	sleep_s(1);
	if (ai_living_count(sq_e9_m5_Villain_healers_spare) <= 0) then
		ai_place_with_birth(sq_e9_m5_Villain_healers_spare); 
	end
	sleep_until((ai_living_count(sq_e9_m5_Villain_knight) + ai_living_count(sq_e9_m5_Villain_knight2) + ai_living_count(sq_e9_m5_Villain_knight3)) <= 0, 1);	
	sleep_s(5);
	sleep_until((ai_living_count(sq_e9_m5_Villain_knight) + ai_living_count(sq_e9_m5_Villain_knight2) + ai_living_count(sq_e9_m5_Villain_knight3)) <= 0, 1);	
	f_create_new_spawn_folder(93);  // spawn players in hall if they die	
	
	sleep_s(1);
	sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 4, 1);
	if (ai_living_count(gr_e9_m5_villain_knights) > 0) then
		ai_place_with_birth(sq_e9_m5_Villain_healers_spare); 
	end
	notifylevel("roundup");

	//------------------one left---------------------------
	thread(f_lastone_check_loop());
	//-----------------------------------------------------
	thread(f_e9_m5_miller_finish_cleaning_up_if_you_havent_forgotten());
	sleep(1);
	sleep_until(LevelEventStatus("allclear"), 1);
	kill_script(f_e9_m5_miller_finish_cleaning_up_if_you_havent_forgotten);
	f_unblip_ai_cui(gr_e9_m5_ai_all);	
	//ai_place_in_limbo(sq_e9_m5_Villain_knight4);	
	sleep(1);
	f_unblip_ai_cui(gr_e9_m5_ai_all);	
	//thread(f_e9_m5_watchout_miller_callouts());
	//sleep_s(2);
	//cs_phase_in(sq_e9_m5_Villain_knight4, true);     // the big show	
	//sleep(2);
	/*if (volume_test_players(tv_e9_m5_watchout_knights) == true and (ai_living_count(sq_e9_m5_Villain_knight4) > 0) ) then
		notifylevel("watchout");
	else
		notifylevel("knights");
	end*/
	sleep(45);
	///////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////MAKE DOORS TO INTERIOR OPEN NOW///////////
	///////////////////////////////////////////////////////////////////////////////////	
	b_doors_open = TRUE;
	//object_create(dm_e9_m5_core_button);   // added via the folder 'interior machines'
	sleep_s(3); 		
	villain_fight_stage = 4;
	dprint("------------------FIGHT STAGE 4-----------------");			
	thread(e9_m5_open_interior_doors());	
	object_destroy_folder(interior_spawns_1);
	object_destroy_folder(interior_spawns_2);
	sleep_s(2); 
	thread(f_e9_m5_players_inside_interior());		
	ai_place_in_limbo(sq_e9_m5_interior_pawns_1);		
	villain_fight_stage == 5;      			  // PAWNS RUSH OUT!!!!  (on follow)
	dprint("------------------FIGHT STAGE 5-----------------");
	f_create_new_spawn_folder (97); // spawn plyrs in room now theyre familiar with this area.
	sleep_s(2);	
	thread(f_e9_m5_incoming_callouts());
	//notifylevel("incoming");
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1, 30 * 5);	
	sleep_s(4);
	ai_place_in_limbo(sq_e9_m5_interior_pawns_2);
	thread(vo_e9m5_interior2_PIP());        //////////////////////////////////////////////
	//Miller : Okay. I think I've got it.  ---TO--- Roland : For you, sure. 
	dprint("SLEEP LINE 1");
	sleep(55);		
	navpoint_track_flag_named(fl_e9_m5_core, "navpoint_goto");
	sleep(1);
	thread(f_e9_m5_unblip_core_waypoint_on_encroach());	
	sleep_until((ai_living_count(sq_e9_m5_interior_pawns_1) + ai_living_count(sq_e9_m5_interior_pawns_2)) <= 3, 1);
	villain_fight_stage == 6;							// PAWNS RETREAT INSIDE!!!!  (clamped inside interior)   sets stage for solo knight battlewagon inside to spawn in middle and stay.
	dprint("------------------FIGHT STAGE 6-----------------");
		sleep_until(b_e9m5_narrative_is_on == false, 1);
	dprint("SLEEP LINE 2");
	sleep_until(((ai_living_count(sq_e9_m5_interior_pawns_1) + ai_living_count(sq_e9_m5_interior_pawns_2)) <= 2) or (b_players_entering_interior == true), 1);
	//sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 6, 1);		
	ai_place_in_limbo(sq_e9_m5_interior_knights_1);
	sleep(1);
	cs_phase_in(sq_e9_m5_interior_knights_1, true);
	sleep(1);
	villain_fight_stage == 8;							// INTERIOR FINAL PEDESTAL!!!!  (clamped inside interior)  
	dprint("------------------FIGHT STAGE 8-----------------");
	dprint("SLEEP LINE 3");
	sleep_until(((ai_living_count(sq_e9_m5_interior_pawns_1) + ai_living_count(sq_e9_m5_interior_pawns_2)) <= 3) or ai_living_count(sq_e9_m5_interior_knights_1) <= 0, 1);
	sleep_s(3);
	ai_place_in_limbo(sq_e9_m5_interior_pawns_3);
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1, 30 * 20);	
	ai_place_in_limbo(sq_e9_m5_interior_pawns_4);
	notifylevel("pawns1");
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);		
	ai_place_in_limbo(sq_e9_m5_interior_knights_2);		
	sleep_s(1);
	dprint("SLEEP LINE 4");
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);		
	sleep(random_range(30,74));
	cs_phase_in(sq_e9_m5_interior_knights_2, true);
	sleep(45);
	notifylevel("roundup");
	dprint("SLEEP LINE 5");
	sleep_until(ai_living_count(sq_e9_m5_interior_knights_1) <= 1, 30 * 9);
	villain_fight_stage == 9;							// INTERIOR FINAL HUNT!!!!  (follow dat player(s)!!!) 
	dprint("------------------FIGHT STAGE 9-----------------");
	sleep(45);	
	if (ai_living_count(gr_e9_m5_ai_all) == 1) then
		notifylevel("oneleft");
	end
	b_interior_final = true;	
	dprint("SLEEP LINE 6");		
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 0, 1);	                  
	sleep(45);
	notifylevel ("grats");
	thread(f_music_e09m5_interior3());
	sleep_s(4);
	b_breakout = false;
	b_interior_combat_finished = true;	
	sleep(7);
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dm_e9_m5_core_button, 1 );
	dprint("REZZING IN BUTTON");	
	object_dissolve_from_marker(dm_e9_m5_core_button, phase_in, "dissolve_mkr");	
	thread(vo_e9m5_interior3());        //////////////////////////////////////////////
	//Miller : Crimson, fire it up. 
	sleep_s(1);	
	dprint("SLEEP LINE 7");
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_s(1);
	thread(f_new_objective(e9_m5_activate_gravlift));
	sleep(11);
	thread(f_e9_m5_obj6_txt());
	sleep(1);
	//f_e9_m5_blip_button(device_name dc_button, device_name dm_button, device_name machine, string_id stringy)		// INTERACT SCRIPT	
	thread(f_e9_m5_blip_button(dc_e9_m5_core_button, dm_e9_m5_core_button, core_door, "panel", NONE, NONE));		
	sleep(1);
 	//sleep_until (device_get_position(dc_e9_m5_core_button) == 1, 1); 	
 	sleep_until(LevelEventStatus("core_pup_finished"), 1); 	
	prepare_to_switch_to_zone_set (e9_m5_2); 
	dprint("SLEEPING UNTIL ZONE IS READY TO SWITCH");
	sleep_until (not PreparingToSwitchZoneSet(),1);
	switch_zone_set (e9_m5_2); 				 // starting zone switch -----------------------------------------------------Z O N E S E T S W I T C H -	
	current_zone_set_fully_active(); 	
	sleep(3);	
	f_create_new_spawn_folder (97); // reset respawn location incase there is non specified somehow after this
	sleep(1);	
	f_add_crate_folder(sc_e9_m5_light_bridge);
	object_create(gravlift_loop_e9m5); 	
	//sound_impulse_start ('sound\environments\multiplayer\factory\ambience\objects\factory_bridge_door_open_in', core_door, 1);
	object_create(lightbridge_lz);
	notifylevel("e9_m5_gravlift_activated");
	thread(f_e9_m5_dissolve_out(floor_hatchnew1));
	thread(f_e9_m5_dissolve_out(floor_hatchnew2));
end

script static void f_e9_m5_obj6_txt								//"USED GRAV-LIFT" 
	sleep_until (LevelEventStatus("e9_m5_gravlift_activated"), 1);
	sleep_s(2);	
	object_create(dm_requiem_map);                 // Prepare the requiem map on the top floor by placing it then hiding it (when nobody is looking)
	//object_create(dm_e9_m5_artifact4_switch);
	sleep(1);
	thread(f_e9_m5_dissolve_out_no_destroy(dm_requiem_map, "dissolve_mkr"));	
	//thread(f_e9_m5_dissolve_out_no_destroy(dm_e9_m5_artifact4_switch, "dissolve_mkr"));
	f_add_crate_folder(dm_e9_m5_upper_machines);   // add the top floor objects now, while nobody is there yet!
	f_add_crate_folder(cr_e9_m5_upper_crates);
	f_add_crate_folder(v_e9_m5_upper_vehicles);
	
	thread(f_new_objective(e9_m5_use_gravlift));
	thread(f_music_e09m5_up_the_gravlift());
	sleep(1);		
	thread(f_e9_m5_move_it_periodic_reminder3());
	f_blip_object_cui(lightbridge_lz, "navpoint_goto");
	object_create(e9_m5_gravlift9000);
	
	
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	//play fx here
	// copy pasting this effect from Dan's email
	// quote "The marker is in 04_interior.structure_meta, and is called "fx_mkr_factory_power_energy""

	// this is how the explosion FX are done at the start, they show up:
	//effect_new (fx\reach\fx_library\explosions\covenant_explosion_large\covenant_explosion_large.effect , flag);
	
	effect_new (levels\firefight\dlc01_factory\fx\factory_antigrav_energy.effect, fx_mkr_antigrav_energy);
	effect_new (levels\firefight\dlc01_factory\fx\factory_power_energy.effect, fl_fx_mkr_gravlift);   // i put a cutscene_flag in the level called fl_fx_mkr_gravlift, 2 feet below donut
	
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	///////////////////////////////////////////////////  G R A V L I F T  A C T I V A T E D   ////////////////////////////////////
	
	
	
	thread(f_e9m5_spin_gravlift());
	thread(f_e9_m5_obj7_txt());
	sleep_s(3);
	thread(vo_e9m5_up_the_gravlift());        ////////////////////////////////////////////////////////////////////
	//Roland : Hawk's definitely  ---TO--- Miller : Climb aboard, 
	sleep(1);
	sleep_until(b_e9m5_narrative_is_on == false, 1);	
	//thread(f_e9m5_gravlift());
	//thread(f_e9m5_h_gravlift());
	//thread(f_e9m5_freeme());	
	sleep_until(volume_test_players(tv_e9_m5_faux_gravlift_v_impulsor) == true, 1);
	//thread(f_animate(dm_e9_m5_artifact1));
	//thread(f_animate(dm_e9_m5_artifact2));
	//thread(f_animate(dm_e9_m5_artifact3));	
	kill_script(f_e9_m5_move_it_periodic_reminder3);	
end

script static void f_e9_m5_obj7_txt						 	//"ARRIVED ON TOP FLOOR" 
	sleep_until (volume_test_players(tv_e9_m5_faux_gravlift_v_impulsor_and_spin) == true, 1);
	f_unblip_object_cui(lightbridge_lz);
	sleep(1);
	object_destroy(lightbridge_lz);
	f_create_new_spawn_folder (99); // spawn plyrs up top
	sleep_s(5);
	thread(teleport_players_uptop());	
	prepare_to_switch_to_zone_set (e9_m5_3); 
	dprint("SLEEPING UNTIL ZONE IS READY TO SWITCH");
	sleep_until (not PreparingToSwitchZoneSet(),1);
	switch_zone_set (e9_m5_3); 				 // starting zone switch -----------------------------------------------------Z O N E S E T S W I T C H -	
	current_zone_set_fully_active();	
	sleep(3);  	
	object_create(hawk_iff_1);
	object_create(hawk_iff_2);
	object_create(hawk_iff_3);
	object_create(hawk_iff_4);
	object_create(hawk_iff_5);
	object_create(hawk_iff_6);
	sleep(3);
	f_create_new_spawn_folder (99); // spawn plyrs up top	
	object_create(dm_e9_m5_artifact1_switch);
	object_create(dm_e9_m5_artifact2_switch);
	object_create(dm_e9_m5_artifact3_switch);
	f_add_crate_folder(e9_m5_top_controls);
	sleep(1);
	thread(f_e9_m5_dissolve_out_no_destroy(dm_e9_m5_artifact1_switch, "dissolve_mkr"));
	thread(f_e9_m5_dissolve_out_no_destroy(dm_e9_m5_artifact2_switch, "dissolve_mkr"));
	thread(f_e9_m5_dissolve_out_no_destroy(dm_e9_m5_artifact3_switch, "dissolve_mkr"));	
	b_players_uptop = true;	
	thread(f_music_e09m5_top_of_lift());
	thread(vo_e9m5_toptags1());        ////////////////////////////////////////////////////////////////////////////////
	//ROLAND - 'Triangulating Hawk's IFF  ---TO--- Miller : Crimson, double check.
	sleep(35);
	navpoint_track_flag_named(fl_e9_m5_iff1, "navpoint_goto");
	sleep(7);
	navpoint_track_flag_named(fl_e9_m5_iff2, "navpoint_goto");
	sleep(4);
	navpoint_track_flag_named(fl_e9_m5_iff3, "navpoint_goto");
	sleep(5);
	navpoint_track_flag_named(fl_e9_m5_iff4, "navpoint_goto");
	sleep(9);
	navpoint_track_flag_named(fl_e9_m5_iff5, "navpoint_goto");		 
	sleep(4);
	navpoint_track_flag_named(fl_e9_m5_iff_main, "navpoint_goto");			        
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_s(1);
	thread(f_new_objective(e9_m5_investigate_iff_tags)); 
	navpoint_track_flag_named(fl_e9_m5_iff1, false);
	navpoint_track_flag_named(fl_e9_m5_iff2, false);
	navpoint_track_flag_named(fl_e9_m5_iff3, false);
	navpoint_track_flag_named(fl_e9_m5_iff4, false);
	navpoint_track_flag_named(fl_e9_m5_iff5, false);		
	thread(f_e9_m5_blip_simple_button(dc_e9_m5_top_iff_tag));
	navpoint_track_flag_named(fl_e9_m5_iff_main, false);
	sleep(5);
  sleep_until ((device_get_position(dc_e9_m5_top_iff_tag) == 1), 1);	 
  object_hide(hawk_iff_1,true);
	object_destroy(hawk_iff_1);
	object_destroy(hawk_iff_2);
	object_destroy(hawk_iff_3);
	object_destroy(hawk_iff_4);
	object_destroy(hawk_iff_5);
	object_destroy(hawk_iff_6);
	
	if b_rvb_interact == false then
		vo_e9m5_activate_easter_egg_tag();                  /////////////////////////////////////////////////
		//Miller : Okay, got access to ---TO--- Miller : Running through
	else
		vo_e9m5_as_you_fight_RRVBALT();
		// Church and Elite LOLz ensue.
	end	
	sleep(5);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(5);				
	thread(f_players_explored_top());				//check if players have walked out
	sleep_until (b_players_explored == true, 1);
	sleep_s(1);
	thread(f_top_pawn_combat());
	sleep(15);
	thread(f_music_e09m5_crawlers());
	//thread(vo_e9m5_crawlers());           //////////////////////////////////////////////////////////////////////////
	//Roland : Crawlers! ---TO--- Miller : Crimson, deal with them.
	sleep(15);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(15);
	sleep_until ((b_toppawn_combat_finished == true), 1);
	sleep_s(3);
	thread(f_music_e09m5_first_panel());
	thread(vo_e9m5_1stBlip());         /////////////////////////////////////////////////////////////////////////////
	//Miller : Roland, mark one of the panels 
	sleep(15);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	thread(f_e9_m5_phant_callouts());
	sleep_s(1);		
	thread(f_new_objective(e9_m5_activate_artifacts));   // Persistant 'Activate all podiums' goal.
  sleep_s(1);
  //////////////////////
	//////TRANSFORM CENTER OBJECT, STAGE 1
	//////////////////////
  
////NEW WAY:
////USE: f_e9_m5_final_device_blip_and_animate(real devicenumber, device_name dc_button, device_name dm_button, device_name machine, device_name walldevice)
  thread(f_e9_m5_final_device_blip_and_animate(3, dc_e9_m5_artifact1, dm_e9_m5_artifact1_switch, dm_upper_wall_device_1));
 
 
////OLD WAY:
////thread(f_e9_m5_blip_button(dc_e9_m5_artifact1, dm_e9_m5_artifact1_switch, dm_e9_m5_artifact1, "dissolve_mkr", NONE, dm_upper_wall_device_1));		// INTERACT SCRIPT
  
  
  //sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', dm_e9_m5_artifact1, 1); 
  sleep_until ((device_get_position(dc_e9_m5_artifact1) == 1), 1);	
 	sleep_s(3); 
	thread(vo_e9m5_1stActivation());       /////////////////////////////////////////////////////////////////////////////
 	//Roland : It worked. That  ---TO--- Roland : Nope. But it upset
	sleep_s(1);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(1);
	thread(f_top_main_combat());        	///////// BEGIN FINAL BATTLE: Elites, Bishops	
	thread(f_e9_m5_miller_neutralize_targets_if_you_havent_forgotten());
	sleep_until (b_top_battle_half_complete == true, 1);   // FIRST WAVE IS OVER. BLIP SECOND PANEL NOW.
	sleep_s(2);
	thread(f_music_e09m5_second_panel());
	thread(vo_e9m5_2ndBlip());       //////////////////////////////////////////////////////////////////////////////////////
 	//Miller : Try the others.  ---TO--- Roland : There's another panel
	sleep(15);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(15);
  //////////////////////
	//////TRANSFORM CENTER OBJECT, STAGE 2
	//////////////////////
	
////NEW WAY:
////USE: f_e9_m5_final_device_blip_and_animate(real devicenumber, device_name dc_button, device_name dm_button, device_name machine, device_name walldevice)
  thread(f_e9_m5_final_device_blip_and_animate(4, dc_e9_m5_artifact3, dm_e9_m5_artifact3_switch, dm_upper_wall_device_3));
 
 
////OLD WAY:
////thread(f_e9_m5_blip_button(dc_e9_m5_artifact3, dm_e9_m5_artifact3_switch, dm_e9_m5_artifact3, "dissolve_mkr", NONE, dm_upper_wall_device_3));    		// INTERACT SCRIPT
  
  
  //sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', dm_e9_m5_artifact3, 1);
  sleep_until ((device_get_position(dc_e9_m5_artifact3) == 1), 1);
  sleep(45);
	thread(vo_e9m5_2ndActivation());     /////////////////////////////////////////////////////////////////////////////////
	//Miller : That should do it	
  b_e9_m5_artifact2_activated = true;     // SECOND WAVE BEGINS (top_main_combat thread is listening for this event)
	sleep_s(3); 
	sleep_until (b_top_battle_complete == true, 1);     ///////FINAL BATTLE IS COMPLETE
	b_breakout = true;	
	sleep(45);
	notifylevel ("grats");
	sleep_s(3);
	thread(f_music_e09m5_third_panel());
	thread(vo_e9m5_3rdBlip());     /////////////////////////////////////////////////////////////////////////////////
	//Roland : A final panel located.
	sleep(35);
	//////////////////////
	//////TRANSFORM CENTER OBJECT, STAGE 3
	//////////////////////		
	
////NEW WAY:
////USE: f_e9_m5_final_device_blip_and_animate(real devicenumber, device_name dc_button, device_name dm_button, device_name machine, device_name walldevice)
  thread(f_e9_m5_final_device_blip_and_animate(5, dc_e9_m5_artifact2, dm_e9_m5_artifact2_switch, dm_upper_wall_device_2));
 
 
////OLD WAY:	
////thread(f_e9_m5_blip_button(dc_e9_m5_artifact2, dm_e9_m5_artifact2_switch, dm_e9_m5_artifact2, "dissolve_mkr", NONE, dm_upper_wall_device_2));    		// INTERACT SCRIPT
 	
 	
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_s(1);
	thread(vo_e9m5_MapBlip());     /////////////////////////////////////////////////////////////////////////////////
	//Miller : What the hell. Let's Do This
	sleep(15);
	sleep_until ((device_get_position(dc_e9_m5_artifact2) == 1), 1);
	//sleep(45);		
  //sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', dm_e9_m5_artifact2, 1);
  //sleep_until ((device_get_position(dc_e9_m5_artifact2) == 1), 1);
	//sleep(1);
	//f_opendoor(dm_upper_wall_device_2, 5);
	//f_opendoor(dc_e9_m5_artifact4, 8);
	//sleep(45);		
	thread(f_music_e09m5_map());
	sleep_s(1);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	thread(vo_e9m5_3rdActivation());     /////////////////////////////////////////////////////////////////////////////////
	//Roland : Um... something's happening.  
	//sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep_s(2);		
	//////////////////////
	//////MAKE MAP OF REQUIEM APPEAR
	//////////////////////		
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_requiem_map, 1 ); //AUDIO!	      
	object_dissolve_from_marker(dm_requiem_map, phase_in, "dissolve_mkr");
	//object_dissolve_from_marker(dm_e9_m5_artifact4_switch, phase_in, "dissolve_mkr");
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_map_activate', dm_requiem_map, 1 );
  sound_looping_start ( 'sound\environments\multiplayer\factory\ambience\amb_factory_map_hologram_loop', dm_requiem_map, 1); 
  thread(f_e9_m5_map_examine_checker()); 	  
	sleep_s(3);		
	if b_map_examined == false then
		thread(f_new_objective(e9_m5_examine_map));    // FINAL "ACTIVATE THE MAP OF REQUIEM" STEP
		navpoint_track_flag_named(fl_e9_m5_map, "navpoint_goto");
  	sleep_s(3);
  	sleep_until((b_map_examined == true), 1);
		navpoint_track_flag_named(fl_e9_m5_map, false);
	end  
	thread(f_end_mission_e9_m5());
	sleep_s(1);
	thread(vo_e9m5_outro());           /////////////////////////////////////////////////////////////////////////////
	//Miller : Roland... what is this?  ---TO--- Roland : Well, if you combine
	sleep(15);
	sleep_until(b_e9m5_narrative_is_on == false, 1);
	sleep(15);
	notifylevel("e9_m5_mission_complete");
	b_e9_m5_mission_over = true;
	kill_script(f_e9_m5_miller_neutralize_targets_if_you_havent_forgotten);
	kill_script(f_e9_m5_move_it);
	kill_script(f_e9_m5_knights_callouts);
	kill_script(f_e9_m5_watchers_callouts);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_e9_m5_lasttargets_callouts);
	kill_script(f_e9_m5_roundup);
	kill_script(f_e9_m5_lasttargets_callouts);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_rvb_interact);
	//kill_script(f_if_pawns1_spawns_start_vo);
	kill_script(f_e9_m5_pawns_hall_tease_callouts);
	kill_script(f_e9m5_spin_gravlift_functionality);
	//kill_script(f_if_pawns2_spawns_start_vo);
	//kill_script(f_if_pawns3_spawns_start_vo);
	//kill_script(f_e9_m5_incoming_callouts);
	kill_script(f_e9_m5_watchout_miller_callouts);
	kill_script(f_e9_m5_snipers_callouts);
	kill_script(f_audio_gravlift);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_e9_m5_spawn_unlocker_watchb);
	kill_script(f_e9_m5_lasttargets_callouts);
	kill_script(f_e9_m5_lasttargets_callouts);
	kill_script(f_e9_m5_lasttargets_callouts);
	kill_script(f_e9_m5_lasttargets_callouts);
end

//===========ENDING E9 M5==============================
script static void f_end_mission_e9_m5
	sleep_until (b_e9_m5_mission_over == true, 1);
	//pup_play_show(ppt_hanger_door_main);
	//fade_out(0, 0, 0, 45); 
  player_control_fade_out_all_input (1);	
  thread(f_music_e09m5_finish());			
	pup_disable_splitscreen (true);
	//players_unzoom_all(); 																				
	ai_erase_all();
	object_hide(player0, true);
	object_hide(player1, true);
	object_hide(player2, true);
	object_hide(player3, true);
	hud_show(false);
	local long show = pup_play_show("95_m5_outro");
	sleep_until (not pup_is_playing(show), 1);												
	//fade_out(0, 0, 0, 30); 
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
	b_end_player_goal = true;
	sleep_s(2);
	//kill_active_scripts();
  thread(f_goal_ender());  
end
	
script static void f_goal_ender
	local real times = 0;
	repeat
		b_end_player_goal = true;
		sleep_s(1);
		times = times + 1;
	until (b_will_never_be_true == true or times == 10, 1);
	dprint("==========================================================  I TRIED 10 TIMES TO END THE PLAYER GOAL  =========================");
end
	
//================================================================================================
//========= MISC SCRIPTS =========================================================================
//================================================================================================
script static void f_e9m5_INTRO_HOG_SPLOSION
	//print("-----init fingers explosion");
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "mainhull", 96);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "fronthull", 40.999);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "hood", 50);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "bumper", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "tailgate", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "windshield", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "rr_fender", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "lr_fender", 50);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "lf_fender", 50);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "rf_fender", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "mainhull", 96);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "fronthull", 40.999);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "hood", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "bumper", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "tailgate", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "windshield", 50);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "rr_fender", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "lr_fender", 48);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "lf_fender", 50);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "rf_fender", 50);   
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	f_e9m5_spark_explosion(e9_m5_shootme1);
	sleep(2);
	f_e9m5_spark_explosion(e9_m5_shootme2);
	//effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, e9_m5_shootme3);
	//effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_destroyed.effect, flag_fingers_);
	sleep(2);
	f_e9m5_plasma_explosion(e9_m5_shootme3);
  ai_kill_silent(sq_e9_m5_marines_hog_1);
  ai_kill_silent(sq_e9_m5_marines_hog_2);  
end	
	
script static void f_e9m5_spark_explosion ( cutscene_flag flag )
	//thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	//ordnance_drop (flag, "default");
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_huge\covenant_explosion_huge.effect , flag);
	sleep(1);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
	sleep(7);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_large\covenant_explosion_large.effect , flag);
	sleep(1);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);

end

script static void f_e9m5_plasma_explosion ( cutscene_flag flag )
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, flag);
	//damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
	sleep_until (b_players_are_alive(), 1);
  object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_2.sp2), "mainhull", 99);
  sleep(6);  
	object_damage_damage_section(ai_vehicle_get_from_spawn_point(sq_e9_m5_marines_hog_1.sp2), "mainhull", 99);
end

script static void f_lastone_check_loop
 local boolean b_oneleft_called_out = false;
	repeat
		sleep_until(ai_living_count(gr_e9_m5_ai_all) == 1, 1);
		sleep(100);
		if (ai_living_count(gr_e9_m5_ai_all) == 1 and b_rounding_up == true) then
			notifylevel("oneleft");
			b_oneleft_called_out = true;
		end
	until (((b_e9_m5_mission_over == true) or (b_rounding_up == false) or (b_oneleft_called_out == true)), 1);
end

script static void f_e9_m5_unblip_core_waypoint_on_encroach
	if b_players_entering_interior == false then
		sleep_until(b_players_entering_interior == true, 1);
		dprint("UNBLIPPING CORE WAYPOINT");
		navpoint_track_flag_named(fl_e9_m5_core, false);
	else
		dprint("UNBLIPPING CORE WAYPOINT");
		navpoint_track_flag_named(fl_e9_m5_core, false);
	end
end

script static void f_sensible_wait_time_after_badnews_before_gratzing_players
	sleep(4);
	sleep_until(b_e9m5_narrative_is_on == false, 1);   // Miller and Roland finished talking about depressing news, Hawk squad isnt responding!
	sleep_s(6);
	b_its_ok_to_grats_players = true;  // okay six seconds after the bad news, its fine to grats players now and play COD guitar riffs. 
end

script static void f_e9_m5_map_examine_checker  	
  sleep_until(volume_test_players(tv_e9_m5_map_examine_radius) == true, 1);
  b_map_examined = true;
end

 script static void f_rvb_interact
	dprint ("start RVB");
	object_create (cr_e9_m5_rvb);
	sleep_until (object_get_health (cr_e9_m5_rvb) < 1, 1);
	sleep(1);
	if object_valid(cr_e9_m5_rvb) then
		dprint ("=-========================================>>>>>   rvb interacted     <-----------==================-%$@(*%)$*@%()$@");
		object_cannot_take_damage (cr_e9_m5_rvb);
		//play stinger
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
		b_rvb_interact = true;
	  inspect (b_rvb_interact);
	  f_achievement_spops_1();
	end
end

script static void f_bishop_rush_countdown
	repeat
		sleep_s(15);
		b_rushtime = true;   // watchers rush in!
		sleep_s(21);
		b_rushtime = false;   // watchers fall back!
		sleep_s(7);
	until (villain_fight_stage >= 4, 1);
	b_rushtime = true;   // watchers always rush in now!
end
/*
script static void f_e9_m5_watchercallout_watcher
	sleep_until(volume_test_players_lookat(tv_e9_m5_int_watchers_lookat, 40, 40), 1);
	b_okay_to_callout_watchers = true;
end*/
script static void f_villain_replacer
	sleep_until(ai_living_count(sq_e9_m5_Villain_knight) <= 0, 1);
	sleep_s(2);
	if (ai_living_count(sq_e9_m5_Villain_knight) <= 0) then
		ai_place_in_limbo(sq_e9_m5_Villain_knightX);
		sleep(1);
		cs_phase_in(sq_e9_m5_Villain_knightX, true);
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.interior_knights_pX);
	else
		sleep(1);
		dprint("DONT NEED ANOTHER VILLAIN SO WE WONT SPAWN ONE!!!!");
	end
end

script static void f_PrepareToSwitchZoneSet(zone_set zoneset)
	prepare_to_switch_to_zone_set (zoneset); 
	sleep_until (not PreparingToSwitchZoneSet(),1);
	//notifylevel("readytozonesetswitch");
	sleep_until(LevelEventStatus("doitnow"),1);
	switch_zone_set (zoneset);
	sleep(1);
	current_zone_set_fully_active();
	notifylevel("zonesetswitched");
end
	
script static void f_all_ready_checker
	sleep_until((b_script_ready == true and b_combat_ready == true), 1);	
	b_all_ready = true;
	dprint("ALL READY LETS GO INSIDE!");
end		
	
script static void f_nomore_rezzing(ai noMoreRezzingOfThisSquad)
	ai_allow_resurrect(noMoreRezzingOfThisSquad, false);
end

script static void f_e9_m5_spawnpoint_unlockers
	//thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_gard_sp_1,garden_spawns_1a,garden_spawns_1b, garden_spawns_1c, garden_spawns_1d));
	//thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_gard_sp_2,garden_spawns_2a,garden_spawns_2b, garden_spawns_2c, garden_spawns_2d));
	//thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_gard_sp_4,garden_spawns_4a,garden_spawns_4b, garden_spawns_4c, garden_spawns_4d));
	thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_int_sp_1,interior_spawns_1a,interior_spawns_1b, interior_spawns_1c, interior_spawns_1d));
	thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_int_sp_2,interior_spawns_2a,interior_spawns_2b, interior_spawns_2c, interior_spawns_2d));
	thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_uppr_sp_1,upper_spawns_1a,upper_spawns_1b, upper_spawns_1c, upper_spawns_1d));
	thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_uppr_sp_2,upper_spawns_2a,upper_spawns_2b, upper_spawns_2c, upper_spawns_2d));
	thread(f_e9_m5_spawn_unlocker_watchb(tv_e9_m5_uppr_sp_3,upper_spawns_3a,upper_spawns_3b, upper_spawns_3c, upper_spawns_3d));	
end
	
script static void f_e9_m5_spawn_unlocker_watch(trigger_volume teevee, folder folderz)
	sleep_until (volume_test_players(teevee) == true, 1);
	//sleep(1);
	//object_destroy(teevee);
	f_add_crate_folder(folderz);
end

	
script static void f_e9_m5_spawn_unlocker_watchb(trigger_volume teevee, object_name zobject1, object_name zobject2, object_name zobject3, object_name zobject4)
	sleep_until (volume_test_players(teevee) == true or b_e9_m5_mission_over == true, 1);
	//sleep(1);
	//object_destroy(teevee);
	if b_e9_m5_mission_over == true then
		sleep(1);
	else
		object_create(zobject1);
		object_create(zobject2);
		object_create(zobject3);
		object_create(zobject4);
		//f_add_crate_folder(folderz);
	end
end


script static void teleport_players_uptop		
	volume_teleport_players_not_inside (tv_e9_m5_teleport_players_uptop, fl_e9_m5_teleport_uptop);
end


script static void f_healer_watch
	sleep_until(villain_fight_stage == 2, 1); // if fight is in stage 2, then spawn healers 2.
	repeat
		if ai_living_count(sq_e9_m5_Villain_healers) <= 2 then
			ai_place_in_limbo(sq_e9_m5_Villain_healers2);
		else
			sleep(1);
			dprint("not gonna spawn healer group 2 since too many healers are alive!");
		end	
	until ((ai_living_count(sq_e9_m5_Villain_healers2) > 0) or (villain_fight_stage > 2));
		sleep_until(villain_fight_stage == 3, 1); // if fight is in stage 3, then spawn healers 3.
	repeat
		if (ai_living_count(sq_e9_m5_Villain_healers2) + ai_living_count(sq_e9_m5_Villain_healers)) <= 2 then
			ai_place_in_limbo(sq_e9_m5_Villain_healers3);
		else
			sleep(1);
			dprint("not gonna spawn healer group 3 since too many healers are alive!");
		end	
	until ((ai_living_count(sq_e9_m5_Villain_healers3) > 0) or (villain_fight_stage > 3));
end
	
script static void f_pokermoveout										// make Poker Squad move up
	sleep_until (volume_test_players(e9_m5_players_in_donut) == true, 1, 30 * 7);
	b_players_in_donut = true;
end		
		
script static void f_players_explored_top
	sleep_until(volume_test_players (e9_m5_players_explored) == true, 1, 30 * 8);
	b_players_explored = true;
end

script static void f_e9_m5_blip_simple_button(device_name dc_button)
	object_create(dc_button);
	sleep(10);
	f_blip_object_cui (dc_button, "navpoint_activate");
	sleep(1);
 	device_set_power(dc_button, 1);
 	sleep_until ((device_get_position(dc_button) == 1), 1);
	sleep(1);			
	object_destroy(dc_button);
end


script static void f_factory_switch_pushed(object control, unit player)	
	g_ics_player = player;
	if control == dc_e9_m5_switch_side_door1 then			
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then                     // if there are no badguys alive, do the pup. otherwise skip it and say 'pup finished'
			dprint("PUPSHOW 1 STARTED");
			local long show = pup_play_show("pup_e9_m5_doorswitch1");
			sleep_until (not pup_is_playing(show), 1);
		else
			dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
		end
		r_interact_pup_finished = r_interact_pup_finished + 1;   // should be now == 1
		dprint("r_interact_pup_finished is now");
		inspect(r_interact_pup_finished);
	elseif control == dc_e9_m5_core_button then
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
			dprint("PUPSHOW 2 STARTED");	
			local long show = pup_play_show("pup_e9_m5_doorswitch_core");	
			sleep_until (not pup_is_playing(show), 1);	
		else
			dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
		end
		r_interact_pup_finished = r_interact_pup_finished + 1;   // should be now == 2
		dprint("r_interact_pup_finished is now");
		inspect(r_interact_pup_finished);
	elseif control == dc_e9_m5_artifact1 then
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
			dprint("PUPSHOW 3 STARTED");	
			local long show = pup_play_show("pup_e9_m5_artifactswitch_1");	
			sleep_until (not pup_is_playing(show), 1);	
		else
			dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
		end
		r_interact_pup_finished = r_interact_pup_finished + 1;   // should be now == 3
		dprint("r_interact_pup_finished is now");
		inspect(r_interact_pup_finished);
	elseif control == dc_e9_m5_artifact3 then
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
			dprint("PUPSHOW 4 STARTED");	
			local long show = pup_play_show("pup_e9_m5_artifactswitch_3");	
			sleep_until (not pup_is_playing(show), 1);	
		else
			dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
		end
		r_interact_pup_finished = r_interact_pup_finished + 1;   // should be now == 4
		dprint("r_interact_pup_finished is now");
		inspect(r_interact_pup_finished);
	elseif control == dc_e9_m5_artifact2 then
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
			dprint("PUPSHOW 5 STARTED");	
			local long show = pup_play_show("pup_e9_m5_artifactswitch_2");	
			sleep_until (not pup_is_playing(show), 1);
		else
			dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
		end
		r_interact_pup_finished = r_interact_pup_finished + 1;	   // should be now == 5
		dprint("r_interact_pup_finished is now");
		inspect(r_interact_pup_finished);
	end	
end 

//USAGE: f_e9_m5_final_device_animate(real devicenumber, device_name dc_button, device_name dm_button, device_name machine, device_name walldevice)
script static void f_e9_m5_final_device_blip_and_animate(real devicenumber, device_name dc_button, device_name dm_button, device_name walldevice)
	// REZ IN THE BUTTON
	dprint("REZZING IN BUTTON");
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dm_button, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_button, phase_in, "dissolve_mkr");
	sleep(15);
	// BLIP THE BUTTON
	f_blip_object_cui (dc_button, "navpoint_activate");
	sleep(1);
 	device_set_power(dc_button, 1);
 	device_set_power(dm_button, 1);	
 	// WAIT FOR BUTTON PUSH
	sleep_until(object_valid(dc_button) and (device_get_position(dc_button) == 1), 1);	
	sleep(1);
	object_destroy(dc_button);
	// ANIMATE THE BUTTON
	thread(f_opendoor(dm_button, 3));
	device_set_position(dm_button, 1);
	//device numbers & pup shows
	// 3 is dc_e9_m5_artifact1
	// 4 is dc_e9_m5_artifact3
	// 5 is dc_e9_m5_artifact2
	sleep_until (r_interact_pup_finished == devicenumber, 1);   
	sleep_until((device_get_position(dm_button) == 1), 1);	
	dprint("BUTTON IS DONE ANIMATING");
	// WAIT UNTIL BUTTON IS FINISHED ANIMATING W PUP SHOW
	// DISSOLVE BUTTON AWAY
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dm_button, 1 );
	object_dissolve_from_marker(dm_button, phase_out, "dissolve_mkr");
	sleep(1);
	
	// ANIMATE THE TELESCOPING WALL THINGY IN FRONT OF DEVICE
	//f_opendoor(walldevice, 5);
	device_set_power(walldevice, 1.0);
	sleep(1);
	device_set_position(walldevice, 1);
	//device_set_position_track( walldevice, "device:position", 1 );
	//device_animate_position( walldevice, 1, 2.5, 1, 1, TRUE );	 // go to pos1 (end) over 8 seconds. First and last 2 seconds are ramp up/down time.
	sleep(15);
	dprint("JUST TOLD THE WALL DEVICE TO ANIMATE");
	/*
	device_set_position_track( dm_e9_m5_artifact1, "device:position", 1 );  
	device_set_position_track( dm_e9_m5_artifact2, "device:position", 1 );
	device_set_position_track( dm_e9_m5_artifact3, "device:position", 1 );
	device_set_position_track( dm_e9_m5_artifact4, "device:position", 1 );
		*/
	// ANIMATE THE DEVICES TO 1ST POSITION
	if devicenumber == 3 then
		dprint("DEVICE NUMBER 3 ANIMATING THE DEVICE N STUFF");
		// 24%
		device_set_position(dm_e9_m5_artifact1, 0.27); // 3 prongs open
		device_set_position(dm_e9_m5_artifact2, 0.27);
		device_set_position(dm_e9_m5_artifact3, 0.27);	
	elseif devicenumber == 4 then
		dprint("DEVICE NUMBER 4 ANIMATING THE DEVICE N STUFF");
		// 53%
		device_set_position(dm_e9_m5_artifact1, 0.54); // 3 prongs open more
		device_set_position(dm_e9_m5_artifact2, 0.54);
		device_set_position(dm_e9_m5_artifact3, 0.54);
		device_set_position(dm_e9_m5_artifact4, 0.5);   // inner rings half lowered
	elseif devicenumber == 5 then
		dprint("DEVICE NUMBER 5 ANIMATING THE DEVICE N STUFF");
		// 100%
		device_set_position(dm_e9_m5_artifact1, 1); // 3 prongs open even more
		device_set_position(dm_e9_m5_artifact2, 1);
		device_set_position(dm_e9_m5_artifact3, 1);
		device_set_position(dm_e9_m5_artifact4, 1);   // inner rings fully lowered
	else
		dprint("DEVICE NUMBER EITHER LOWER THAN 3 OR HIGHER THAN 5");
	end
	//thread(f_opendoor(machine, 5));	  
	sleep_s(1);
	object_destroy(dm_button);
end
		
	
	

script static void f_e9_m5_blip_button(device_name dc_button, device_name dm_button, device_name machine, string_id stringy, object_name scenerydoor, device_name tertiary_machine)		     		// INTERACT SCRIPT
	local boolean b_imadoor = false;
			local boolean b_imacore = false;
			if machine == NONE then
				dprint("NO MACHINE, THIS IS A DOOR");
			end
	if scenerydoor == NONE then
		dprint("NO DOOR, THIS IS A MACHINE");
	end
			if dm_button != dm_e9_m5_core_button then
				sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dm_button, 1 );
				dprint("REZZING IN BUTTON");	
				object_dissolve_from_marker(dm_button, phase_in, stringy);
			end
	sleep(15);
	f_blip_object_cui (dc_button, "navpoint_activate");
	sleep(1);
 	device_set_power(dc_button, 1);
 	device_set_power(dm_button, 1);		 	
	dprint("SLEEPING TIL BUTTON PUSHED");	
	sleep_until(object_valid(dc_button) and (device_get_position(dc_button) == 1), 1);
	dprint("BUTTON PUSHED");	
	sleep(1);
	object_destroy(dc_button);	
	//if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
		if dc_button == dc_e9_m5_switch_side_door1 then
			b_imadoor = true;
			sleep(10);
			thread(f_opendoor(dm_button, 2));                  // animate the button
			sleep_until (r_interact_pup_finished == 1, 1);  
 			sleep_until((device_get_position(dm_button) == 1), 1);
		elseif dc_button == dc_e9_m5_core_button then
			b_imacore = true;
			thread(f_opendoor(dm_button, 3));
 			//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', machine, 1);
 			device_set_position(dm_button, 1);
			sleep_until (r_interact_pup_finished == 2, 1);  
 			sleep_until((device_get_position(dm_button) == 1), 1);
 			// 3 is dc_e9_m5_artifact1
 			// 4 is dc_e9_m5_artifact3
 			// 5 is dc_e9_m5_artifact2
		elseif dc_button == dc_e9_m5_artifact1 then
			thread(f_opendoor(dm_button, 3));
 			//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', machine, 1);
 			device_set_position(dm_button, 1);
			sleep_until (r_interact_pup_finished == 3, 1);  
 			sleep_until((device_get_position(dm_button) == 1), 1);
		elseif dc_button == dc_e9_m5_artifact3 then
			thread(f_opendoor(dm_button, 3));
 			//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', machine, 1);
 			device_set_position(dm_button, 1);
			sleep_until (r_interact_pup_finished == 4, 1);  
	 		sleep_until((device_get_position(dm_button) == 1), 1);
		elseif dc_button == dc_e9_m5_artifact2 then
			thread(f_opendoor(dm_button, 3));
 			//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_artifact_activate_in', machine, 1);
 			device_set_position(dm_button, 1);
			sleep_until (r_interact_pup_finished == 5, 1);  
 			sleep_until((device_get_position(dm_button) == 1), 1);
		end
	//else
		//sleep_s(1);
		//dprint("BADGUYS STILL ALIVE, NO PUPSHOW FOR JOO");
	//end	
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_button, 1 );    // MELT THE BUTTON
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', dm_button, 1 );
	dprint("MELTING THE BUTTON!!");
	object_dissolve_from_marker(dm_button, phase_out, stringy);	
	if (b_imadoor == true) then   	 // DEREZ THE DOOR, IF ITS A DOOR	
		sleep(20);
		thread(f_e9_m5_dissolve_out(scenerydoor)); 
		dprint("MELTING THE DOOR!!");
		sleep_s(4.5);   // Mike J says 4.5 is a good delay time to try
 		object_destroy(dm_button);  	
 		notifylevel("leaving_donut");
 	else 																							   // OPEN IF ITS A TERMINAL/CONSOLE
		sleep(20);
		if (tertiary_machine != NONE) then
			dprint("OPENING THE TERTIARY DEVICE!");
			f_opendoor(tertiary_machine, 5);
			sleep(40);
		end
		dprint("OPENING THE DEVICE SINCE IM NOT A DOOR!");
		thread(f_opendoor(machine, 5));	
		sleep_s(1);
 		object_destroy(dm_button);  	
	end
	if (b_imacore == true) then
 		notifylevel("core_pup_finished");
	end
end

script static void f_e9_m5_dissolve_door(device_name dc_buttonz, device_name dm_buttonz, device_name machinez, string stringz)		  // BLIP SCRIPT FOR DOORS W/ FORE BUTTONS.
	object_create(dc_buttonz);
	sleep(1);
	thread(f_e9_m5_dissolve_in(dm_buttonz)); //, "button_marker"))
	sleep(15);
	f_blip_object_cui (dc_buttonz, "navpoint_activate");
	sleep(1);
 	device_set_power(dc_buttonz, 1);		 	
	sleep_until(object_valid(dc_buttonz) and (device_get_position(dc_buttonz) == 1), 1);
	sleep(1);				
	object_dissolve_from_marker(dm_buttonz, phase_out, button_marker);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dc_buttonz, 1 );	
	sleep_s(1);	
end

script static void f_e9_m5_dissolve_out(object doorzz)
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', doorzz, 1 );
	object_dissolve_from_marker(doorzz, phase_out, "dissolve_mkr");
	sleep_s(8);
	object_destroy(doorzz);
end

script static void f_e9_m5_dissolve_out_no_destroy(object thingyz, string_id dissolve_markerzx)  // only good for doors using door marker "dissolve_mkr" NOT MRK!!);
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', thingyz, 1 );
	//object_hide(thingyz, true);
	if thingyz == dm_donut_ramp_door then
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', thingyz, 1 ); //AUDIO!
		object_dissolve_from_marker(thingyz, phase_out, "button_marker");
	else
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', thingyz, 1 ); //AUDIO!
		object_dissolve_from_marker(thingyz, phase_out, "dissolve_mkr");
	end
end

script static void f_e9_m5_dissolve_in(object thingy)  //, string_id dissolve_markerze);  // only good for dm_factory_Forerunner buttons!
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', thingy, 1 );
	object_dissolve_from_marker(thingy, phase_in, "button_marker");
	//object_dissolve_from_marker(thingy, phase_in, dissolve_markerze);
end

script static void f_garden_combat	
local boolean b_normal_spawn = true;
	if volume_test_players(tv_e9_m5_initial_pawn_disabler) == false then
		sleep(1);
		ai_place_in_limbo (sq_e9_m5_garden_pawns_1);
		ai_place_in_limbo (sq_e9_m5_garden_pawns_2);	
		b_normal_spawn = true;
	else
		sleep(1);
		ai_place_in_limbo (sq_e9_m5_garden_pawns_1);
		ai_place_in_limbo (sq_e9_m5_garden_pawns_3c);	 
		b_normal_spawn = false;
	end
	sleep(5);	
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(5);
	else
		sleep_s(1);
	end	
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	ai_place_in_limbo(sq_e9_m5_garden_knights_1);
	ai_place_in_limbo(sq_e9_m5_garden_knights_1b);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(3);
	else
		sleep_s(1);
	end
	if (ai_living_count(gr_e9_m5_garden_knights) > 0) then
		thread(f_e9_m5_knights_callouts());
	end
	sleep_s(2);
	cs_phase_in(sq_e9_m5_garden_knights_1b, true);
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.garden_knights_p1);
	sleep(1);
	ai_place_in_limbo(sq_e9_m5_garden_knights_2);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(3);
	else
		sleep_s(1);
	end
	cs_phase_in(sq_e9_m5_garden_knights_2, true);
	effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.garden_knights_p2);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(5);
	else
		sleep_s(1);
	end
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(5);
	else
		sleep_s(1);
	end
	ai_place_in_limbo(sq_e9_m5_garden_pawns_3b);
	thread(f_e9_m5_pawns_mid_battle_callouts());
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(3);
	else
		sleep_s(1);
	end
	if (ai_living_count(gr_e9_m5_garden_pawns) > 4) then
		notifylevel("pawns1");
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep(126);
		else
			sleep_s(1);
		end
		thread(vo_miller_shoot_03());
	end
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	//ai_place_in_limbo (sq_e9_m5_garden_bishops_1);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(5);
	else
		sleep_s(1);
	end
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	ai_place_in_limbo (sq_e9_m5_garden_pawns_3);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e9_m5_effects_pts.garden_pawns_p0);
	//cs_custom_animation(sq_e9_m5_garden_pawns_3.spawn_points_0, TRUE, objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e9_m5_effects_pts.garden_pawns_p1);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e9_m5_effects_pts.garden_pawns_p2);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e9_m5_effects_pts.garden_pawns_p3);
	//ai_place_in_limbo (sq_e9_m5_garden_bishops_2);
	notifylevel("e9_m5_garden_quarter");	
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);	
	if b_normal_spawn == true then
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep_s(5);
		else
			sleep_s(1);
		end
		ai_place_in_limbo (sq_e9_m5_garden_pawns_2); 
	else
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep_s(5);
		else
			sleep_s(1);
		end
		ai_place_in_limbo (sq_e9_m5_garden_pawns_3c);    
	end 	
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	ai_place_in_limbo(sq_e9_m5_garden_knights_3);
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(5);
	else
		sleep_s(1);
	end
	//cs_phase_in(sq_e9_m5_garden_knights_3, true);
	//effect_new_at_ai_point(objects\characters\storm_knight\fx\spawn\knight_spawn.effect, e9_m5_effects_pts.garden_knights_p3);
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep_s(4);
		else
			sleep_s(1);
		end
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 2, 1);
	sleep(1);
	sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 1, 1, 30 * 11);
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep_s(3);
		else
			sleep_s(1);
		end
	notifylevel("e9_m5_garden_half");
		if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
			sleep_s(2);
		else
			sleep_s(1);
		end
	ai_place_in_limbo(sq_e9_m5_garden_knights_4);
	sleep_s(1);
	cs_phase_in(sq_e9_m5_garden_knights_4, true);
	sleep(24);////////////////////////////////////////////////////////////////////////////////////////
	thread(f_e9_m5_bishop_spawn_vortex(fl_e9_m5_bishop_spawn_vortex_g, sq_e9_m5_garden_bishops_4, 1));
	//////////////////////////////////////////////////////////////////////////////////////////////////
	thread(f_e9_m5_watchers_callouts());
	sleep(5);     
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   
		thread(f_e9_m5_shard1());	
		ai_place_with_birth(sq_e9_m5_garden_2bishops_1); 
		sleep_s(1);
		sleep_until((r_bishops_birthed > 0), 1);			
		sleep_s(3);				
		if  ai_living_count(gr_e9_m5_garden_bishops) > 0 then   // if bishops are alive...
			notifylevel("watchers");
		end
	end
	if ai_living_count(gr_e9_m5_ai_all) > 0 then   // if no ai alive, dont pause for so long!
		sleep_s(2);
	else
		sleep_s(1);
	end
	if ai_living_count(gr_e9_m5_ai_all) > 0 then
		thread(f_e9_m5_shard2());	
	end
end

script static void e9_m5_open_garage_now
	//sleep_until(LevelEventStatus("e9_m5_open_garage"), 1);
	b_open_garage_now = true;
end

script static void e9_m5_phantom_despawn_hack(ai phantom)
	sleep(30);
	dprint("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
		dprint("----=-=-=-=-----phantom alive, trying to erase");
		ai_erase (phantom);
		dprint("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		e9_m5_phantom_despawn_hack(phantom);
	else
		dprint("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end
/*
script static void f_watcher_callout_loop
	repeat
		if b_okay_to_callout_watchers == true then
			sleep_s(1);
			notifylevel("watchers");
		end
		sleep(3);
	until ((b_okay_to_callout_watchers == true or ai_living_count(gr_e9_m5_ai_all) <= 0), 1);
end	*/

script static void f_villain_shard_manager
	sleep_s(12);
	if villain_fight_stage <= 1 then
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 11, 1, 30 * 10);
		//thread(f_e9_m5_shard3());
	end
	sleep_until(ai_living_count(sq_e9_m5_Villain_knight) <= 0, 1, 30 * 25);
	if (villain_fight_stage <= 1 and b_pawns1_spawned == false) then
		if ai_living_count(gr_e9_m5_ai_all) <= 11 then
			sleep(1);
			//thread(f_e9_m5_shard3());
		end
	end
	sleep_s(12);	
	sleep_until(villain_fight_stage >= 2, 1);	
	sleep_s(12);
	if villain_fight_stage <= 2 then
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 6, 1, 30 * 10);
		if ai_living_count(gr_e9_m5_ai_all) <= 6 then
			thread(f_e9_m5_shard4());
		end
	end
	sleep_until(ai_living_count(sq_e9_m5_Villain_knight2) <= 0, 1, 30 * 25);
	if (villain_fight_stage <= 2 and b_pawns2_spawned == false) then
		if ai_living_count(gr_e9_m5_ai_all) <= 6 then
			thread(f_e9_m5_shard4());
		end
	end
	sleep_s(12);	
	sleep_until(villain_fight_stage >= 3, 1);	
	sleep_s(12);
	if villain_fight_stage <= 3 then
		sleep_until(ai_living_count(gr_e9_m5_ai_all) <= 6, 1, 30 * 10);
		if ai_living_count(gr_e9_m5_ai_all) <= 6 then
			thread(f_e9_m5_shard5());
		end
	end
	sleep_until(ai_living_count(sq_e9_m5_Villain_knight3) <= 0, 1, 30 * 25);
	if (villain_fight_stage <= 2 and b_pawns3_spawned == false) then
		if ai_living_count(gr_e9_m5_ai_all) <= 6 then
			thread(f_e9_m5_shard5());
		end
	end
end

script static void f_e9_m5_shard1
	//repeat
		dprint("---------lets spawn some pawns!-----------");
		if (ai_living_count(sq_e9_m5_garden_pawns_4) <= 0) then 
			ai_place_with_shards(sq_e9_m5_garden_pawns_4); 
		end
		//if (ai_living_count(sq_e9_m5_garden_pawns_4) <= 0) then 
		//	sleep_s(11);
		//end
	//until(ai_living_count(sq_e9_m5_garden_pawns_4) > 0 or b_garden_clear == true);
end

script static void f_e9_m5_shard2
	//repeat
		dprint("---------lets spawn some pawns!-----------");
		if (ai_living_count(sq_e9_m5_garden_pawns_5) <= 0) then 
			ai_place_with_shards(sq_e9_m5_garden_pawns_5); 
		end
		//if (ai_living_count(sq_e9_m5_garden_pawns_5) <= 0) then 
		//	sleep_s(11);
		//end
	//until(ai_living_count(sq_e9_m5_garden_pawns_5) > 0 or b_garden_clear == true);
end

script static void f_e9_m5_shard3
		dprint("---------lets spawn some pawns!-----------");
		if (ai_living_count(sq_e9_m5_villain_pawns_1) <= 0) then 
			ai_place_with_shards(sq_e9_m5_villain_pawns_1); 
		end
end
script static void f_e9_m5_shard4
		dprint("---------lets spawn some pawns!-----------");
		if (ai_living_count(sq_e9_m5_villain_pawns_2) <= 0) then 
			ai_place_with_shards(sq_e9_m5_villain_pawns_2); 
		end
end	
script static void f_e9_m5_shard5
		dprint("---------lets spawn some pawns!-----------");
		if (ai_living_count(sq_e9_m5_villain_pawns_3) <= 0) then 
			ai_place_with_shards(sq_e9_m5_villain_pawns_3); 
		end
end
/*
script static void f_e9_m5_birth(ai bishop_squad, real numBishopsToSpawn, boolean abortBool3)
	dprint("---------lets spawn some bishops!-----------");
	if r_bishops_birthed != numBishopsToSpawn then 
			ai_place_with_birth(bishop_squad); 
	end
	ai_place_with_birth(bishop_squad); 
	sleep_s(1);
	if r_bishops_birthed > 0 then
		notifylevel("watchers");
	end
end*/

script static void f_closedoor(device_name doora,real closingspeed)
	sleep(1);
	device_set_power(doora, 1.0);
	sleep(1);
	device_set_position_immediate(doora, 1);    //pop door open
	sleep(1);
	device_set_position(doora, 0);	            //close it
	//device_set_position_track( doora, "device:position", 1 );                     // Use this line if the device machine has an animation (looping?) we want to manipulate
	//device_animate_position( doora, 0, closingspeed, 1.0, 1.0, TRUE );
end

script static void f_opendoor(device_name doorxx,real openingspeed)
	device_set_power(doorxx, 1.0);
	sleep(1);
	device_set_position_track( doorxx, "device:position", 1 );                     // Use this line if the device machine has an animation (looping?) we want to manipulate
	device_animate_position( doorxx, 1, openingspeed, 1.0, 1.0, TRUE );
	notifylevel("opened");
end

script static void e9_m5_open_interior_doors
	thread(f_opendoor(dm_hangar_door_1, 4));	
	//sound_impulse_start( 'sound\environments\multiplayer\factory\ambience\objects\factory_large_int_door_open_in', dm_hangar_door_1, 1);
	thread(f_opendoor(dm_hangar_door_2, 4));		
	//sound_impulse_start( 'sound\environments\multiplayer\factory\ambience\objects\factory_large_int_door_open_in', dm_hangar_door_2, 1);
	device_set_position(dm_wedge_center_door, 1);
	//thread(f_e9_m5_dissolve_out(dm_wedge_center_door));
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', dm_wedge_center_door, 1);
end

script static void f_garden_clear_listener
	sleep_until (LevelEventStatus("garden_clear"),1);
	b_garden_clear = true;
end
		
script static void f_top_pawn_combat
	ai_place_in_limbo(sq_e9_m5_top_pawns_1);	
	sleep_s(5);
  sleep_until ((ai_living_count(gr_e9_m5_ai_all)) <= 3, 1);
	sleep_s(3);			
	ai_place_in_limbo(sq_e9_m5_top_pawns_2);	
	sleep_s(5);			
  sleep_until ((ai_living_count(gr_e9_m5_ai_all)) <= 0, 1);
  sleep_s(1);
	b_toppawn_combat_finished = true;
end 
			 	 
script static void f_top_main_combat
	sleep_s(1);
	thread(f_e9_m5_bishop_spawn_vortex_simple(fl_e9_m5_bishop_spawn_vortex_4, sq_e9_m5_top_bishops_1));
	sleep_s(2);
	thread(f_e9_m5_bishop_spawn_vortex_simple(fl_e9_m5_bishop_spawn_vortex_5, sq_e9_m5_top_bishops_1));
	sleep(15);
  ai_place(sq_e9_m5_phantom_4);
  sleep_s(4);
 	notifylevel("VO_Phantom");
	sleep_until(LevelEventStatus("elitephantunloaded1") or ai_living_count(sq_e9_m5_phantom_4) <= 0, 1);
  sleep_until ((ai_living_count(sq_e9_m5_top_elites_2) + ai_living_count(sq_e9_m5_top_elites_3) + ai_living_count(sq_e9_m5_top_elites_4) + ai_living_count(sq_e9_m5_top_elites_5)) <= 3, 1);
 	sleep_s(5);	
	sleep_until ((ai_living_count(gr_e9_m5_ai_all)) <= 0, 1);
	sleep(1);
	b_top_battle_half_complete = true;
	sleep(1);
	sleep_until(b_e9_m5_artifact2_activated == true, 1);
	sleep(1);	
	thread(f_e9_m5_bishop_spawn_vortex_simple(fl_e9_m5_bishop_spawn_vortex_4, sq_e9_m5_top_bishops_2));
	sleep_s(2);
	thread(f_e9_m5_bishop_spawn_vortex_simple(fl_e9_m5_bishop_spawn_vortex_5, sq_e9_m5_top_bishops_2));
	sleep(15);
  ai_place(sq_e9_m5_phantom_5);
  sleep_s(4);
 	notifylevel("VO_Phantom");
	sleep_until(LevelEventStatus("elitephantunloaded2") or ai_living_count(sq_e9_m5_phantom_5) <= 0, 1);
  sleep_until ((ai_living_count(gr_e9_m5_ai_all)) <= 3, 1);
	notifylevel("roundup");	
	//------------------one left---------------------------
	thread(f_lastone_check_loop());
	//-----------------------------------------------------
			
			
	//sleep(120);
	//sleep_until(b_e9m5_narrative_is_on == false, 1);
	//notifylevel("neutralizethem");
  sleep_until ((ai_living_count(gr_e9_m5_ai_all)) <= 0, 1);
  b_top_battle_complete = true;
end

script static void f_players_approached_doortrigger
	sleep(1);
	sleep_until(volume_test_players (e9_m5_trigger_players_leaving_garden) == true, 1);
	b_players_approached_door = true;
end

script static void f_e9_m5_shoot_me(object target)
	obj_target = target;
	ai_object_set_targeting_bias(obj_target,1);
end

script static void f_e9_m5_shoot_me_kinda(object target)
	obj_target = target;
	ai_object_set_targeting_bias(obj_target,0.5);
end

script static void f_destroyvehicle(ai destroythisvehicle)
	object_destroy(unit_get_vehicle(destroythisvehicle));
	ai_erase(destroythisvehicle);
end

script static void f_e9_m5_roundup
	dprint("roundup SCRIPT LOADED ---- LISTENING FOR ROUNDUP CALL!----------------------------------");	
	//local real r_times_roundedup = 0;	
	thread(f_e9_m5_lasttargets_callouts());
	repeat
		sleep_until (LevelEventStatus("roundup"),1);
		if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
			sleep(1);
			dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
		else
			if b_e9m5_narrative_is_on == FALSE then		
				if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
					dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
					sleep(1);
				else
					b_rounding_up = true;
					notifylevel("lasttargets");	
					sleep_s(1);
					f_blip_ai_cui(gr_e9_m5_ai_all, "navpoint_enemy");
					sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 0, 1);
					f_unblip_ai_cui(gr_e9_m5_ai_all);
				end
			else
				dprint("-----------SOMEONE ELSE IS TALKING STILL!, I WILL WAIT BEFORE BLIPPING LAST GUYS!");
				sleep_until(b_e9m5_narrative_is_on == false, 1);
				if (ai_living_count(gr_e9_m5_ai_all) <= 0) then
					dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
					sleep(1);
				else
					b_rounding_up = true;
					notifylevel("lasttargets");	
					sleep_s(1);
					f_blip_ai_cui(gr_e9_m5_ai_all, "navpoint_enemy");
					sleep_until (ai_living_count(gr_e9_m5_ai_all) <= 0, 1);
					f_unblip_ai_cui(gr_e9_m5_ai_all);	
				end
			end
		end
		notifylevel("allclear");
		b_rounding_up = false;
		//r_times_roundedup = r_times_roundedup + 1;
		sleep(1);
	//until (r_times_roundedup == 4 or b_e9_m5_mission_over == true, 1);
	until (b_e9_m5_mission_over == true, 1);
	dprint("THAT WAS THE FINAL ROUNDUP CALL, WHERE WE BLIP RED ARROWS OVER DUDES FOR THE LAST TIME!");
end
  
script static void f_e9_m5_interior_combat_dialogue
	sleep_s(12);
	b_interior_dialogue_finished = true;
end

script static void f_e9_m5_players_entering_interior
	sleep_until (volume_test_players(e9_m5_players_entering_interior) == true, 1);		
	b_players_entering_interior = true;
end

script static void f_e9_m5_players_inside_interior
	sleep_until(volume_test_players(e9_m5_players_inside_interior) == true, 1, 30 * 20);    // wait 10 seconds after doors open or if players enter, before birds flyaway
	sleep_until((ai_living_count(sq_e9_m5_interior_pawns_1) + ai_living_count(sq_e9_m5_interior_pawns_2)) <= 5, 1);
	b_e9_m5_players_inside_interior = true;
end

script static void f_popcover	
	sleep_until(volume_test_players(players_into_interior), 1, 30 * 8);	
	thread(f_opendoor(dm_e9_m5_cover1b, 4));
	sleep(random_range(1,14));
	thread(f_opendoor(dm_e9_m5_cover1d, 4));
	sleep(random_range(1,14));
	thread(f_opendoor(dm_e9_m5_cover2z, 3));
	sleep(random_range(1,5));
	thread(f_opendoor(dm_e9_m5_cover2b, 3));
	sleep(random_range(1,7));
	thread(f_opendoor(dm_e9_m5_cover2c, 4));
	sleep(random_range(1,8));
	thread(f_opendoor(dm_e9_m5_cover2d, 4));
	sleep(random_range(1,11));
	thread(f_opendoor(dm_e9_m5_cover1, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover1a, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover1c, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover1e, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover1f, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover1g, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover2, 5));
	sleep(random_range(2,34));
	thread(f_opendoor(dm_e9_m5_cover2a, 5));
	sleep(random_range(2,34));		
end



script static void f_e9m5_freeme																												// called from dc
	repeat
		if(player_valid(player0))then
			sleep_until(volume_test_object(tv_e9_m5_freeme, player0) == true, 1);
			player_control_unlock_gaze (player0);
			player_disable_movement (player0, FALSE);
			sleep(1);
		end
			sleep(1);
		if(player_valid(player1))then
			sleep_until(volume_test_object(tv_e9_m5_freeme, player1) == true, 1);
			player_control_unlock_gaze (player1);
			player_disable_movement (player0, FALSE);
			sleep(1);
		end
			sleep(1);
		if(player_valid(player2))then
			sleep_until(volume_test_object(tv_e9_m5_freeme, player2) == true, 1);
			player_control_unlock_gaze (player2);
			player_disable_movement (player2, FALSE);
			sleep(1);
		end
			sleep(1);
		if(player_valid(player3))then
			sleep_until(volume_test_object(tv_e9_m5_freeme, player3) == true, 1);
			player_control_unlock_gaze (player3);
			player_disable_movement (player3, FALSE);
			sleep(1);
		end
			sleep(1);
	until (b_e9_m5_mission_over == true, 1);
end


script static void f_e9m5_h_gravlift																												// called from dc
	repeat
		if(player_valid(player0))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_h_impulsor, player0) == true, 1);
			thread(f_e9m5_h_levitate(player0));
		end
		if(player_valid(player1))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_h_impulsor, player1) == true, 1);
			thread(f_e9m5_h_levitate(player1));
		end
		if(player_valid(player2))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_h_impulsor, player2) == true, 1);
			thread(f_e9m5_h_levitate(player2));
		end
		if(player_valid(player3))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_h_impulsor, player3) == true, 1);
			thread(f_e9m5_h_levitate(player3));
		end
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9m5_gravlift																												// called from dc
	repeat
		if(player_valid(player0))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor, player0) == true, 1);
			thread(f_e9m5_levitate(player0));
		end
		if(player_valid(player1))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor, player1) == true, 1);
			thread(f_e9m5_levitate(player1));
		end
		if(player_valid(player2))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor, player2) == true, 1);
			thread(f_e9m5_levitate(player2));
		end
		if(player_valid(player3))then
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor, player3) == true, 1);
			thread(f_e9m5_levitate(player3));
		end
	until (b_e9_m5_mission_over == true, 1);
end

		
script static void f_e9m5_spin_gravlift																											// called from dc
	thread(f_e9m5_spin_gravlift_functionality(player0)); // Some of these threads will spin off and exit right away.  
	thread(f_e9m5_spin_gravlift_functionality(player1));
	thread(f_e9m5_spin_gravlift_functionality(player2));
	thread(f_e9m5_spin_gravlift_functionality(player3));
end

script static void f_e9m5_spin_gravlift_functionality(player o_player)																											// called from dc
	if(player_valid(o_player))then
		repeat
			sleep_until(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor_and_spin, o_player) == true, 3);
			player_disable_movement (o_player, TRUE);
			player_control_lock_gaze(o_player, e9_m5_door_pts.p22x, 60);            // turn at 50 degrees/sec to face target.  (3.6 second full turn)
			sleep_until((b_e9_m5_mission_over == true) or (volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor_and_spin, o_player) == false), 1);
			player_control_unlock_gaze (o_player);
			player_disable_movement (o_player, FALSE);
		until (b_e9_m5_mission_over == true, 1);
	end
end
		

script static void f_e9m5_h_levitate(object o_player)
		repeat
			object_set_velocity(o_player, 12, 0, 0);      //levitation speed in  x, y, z
			sleep(1);
		until	((volume_test_object(tv_e9_m5_faux_gravlift_h_impulsor, o_player) == false),1);
end


script static void f_e9m5_levitate(object o_player)
	sleep(15);
	repeat
		object_set_velocity(o_player, 0, 0, 6);      //levitation speed in  x, y, z
		sleep(1);
	until	(volume_test_object(tv_e9_m5_faux_gravlift_v_impulsor, o_player) == false,1);
end

script static void f_e9_m5_bishop_spawn_vortex_if_needed(cutscene_flag flag, real vortex_number)
	local real numHealersNeeded = (6 - (ai_living_count(gr_e9_m5_villain_healers)));  //keep 6 healers up. 3 per squad. so the num needed is 6 - current num alive	
	if numHealersNeeded > 0 then   // if we actually need more healers...
		if effects_perf_armageddon == 0 then
			effects_perf_armageddon = 1;                    //--- if this value is 1, distortion effects etc are culled, reduced. Set to 0 to ensure we see the coolness	
		end
		if effects_distortion_enabled == 1 then
			effects_distortion_enabled = 0;
		end
		effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, flag); 
		sleep_s(0.5);
		effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
		sleep_s(3);		
		if vortex_number == 1 then                                         
			ai_place_in_limbo(sq_e9_m5_Villain_healers);
			sleep_s(0.25);
			ai_place_in_limbo(sq_e9_m5_Villain_healers2);
			sleep_s(0.45);
		elseif vortex_number == 2 then
			if numHealersNeeded <= 3 then
				ai_place_in_limbo(sq_e9_m5_Villain_healers3, numHealersNeeded);
			elseif numHealersNeeded > 3 then
				ai_place_in_limbo(sq_e9_m5_Villain_healers3);
				sleep_s(0.25);
				ai_place_in_limbo(sq_e9_m5_Villain_healers4, (numHealersNeeded - 3));
				sleep_s(0.45);
			end
		elseif vortex_number == 3 then
			if numHealersNeeded <= 3 then
				ai_place_in_limbo(sq_e9_m5_Villain_healers5, numHealersNeeded);
			elseif numHealersNeeded > 3 then
				ai_place_in_limbo(sq_e9_m5_Villain_healers5);
				sleep_s(0.25);
				ai_place_in_limbo(sq_e9_m5_Villain_healers6, (numHealersNeeded - 3));
			end
		end				
		//notifylevel("watchers");
		sleep_s(2);
		effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_close_pve.effect, flag);
		sleep_s(.5);
		effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
		effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
		sleep_s(2);
		if effects_perf_armageddon == 1 then
			effects_perf_armageddon = 0;                 	
		end
		if effects_distortion_enabled == 0 then
			effects_distortion_enabled = 1;
		end                               //--- turn back on the perf-saving reduction of effects. (now that we are done with the expensive distortion effect)    
	end
end

	//ai_place_in_limbo(sq_e9_m5_garden_bishops_4);

script static void f_e9_m5_bishop_spawn_vortex(cutscene_flag flag, ai squad, real numtospawn)
	effects_perf_armageddon = 0;                    //--- if this value is 1, distortion effects etc are culled, reduced. Set to 0 to ensure we see the coolness	
	effects_distortion_enabled = 1;
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, flag); 
	sleep_s(0.5);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	sleep_s(3);		                                
		ai_place_in_limbo(squad, numtospawn);
		sleep_s(0.25);
		ai_place_in_limbo(squad, numtospawn);
		sleep_s(0.45);
	//notifylevel("watchers");
	sleep_s(2);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_close_pve.effect, flag);
	sleep_s(.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	sleep_s(2);
	effects_perf_armageddon = 1;          //--- turn back on the perf-saving reduction of effects. (now that we are done with the expensive distortion effect)    
end

script static void f_e9_m5_bishop_spawn_vortex_simple(cutscene_flag flag, ai squad)
	effects_perf_armageddon = 0;                    //--- if this value is 1, distortion effects etc are culled, reduced. Set to 0 to ensure we see the coolness	
	effects_distortion_enabled = 1;
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, flag); 
	sleep_s(0.5);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	sleep_s(3);		                                
		ai_place_in_limbo(squad);
	//notifylevel("watchers");
	sleep_s(2);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_close_pve.effect, flag);
	sleep_s(.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, flag);
	sleep_s(2);
	effects_perf_armageddon = 1;          //--- turn back on the perf-saving reduction of effects. (now that we are done with the expensive distortion effect)    
end





script static void f_animate(device_name dm_name)
	print("Starting UP");
	repeat
  //object_rotate_by_offset <object name> <yaw time> <pitch time> <roll time> <yaw degrees> <pitch degrees> <roll degrees>
	object_rotate_by_offset(dm_name, 5, 0, 0, 360, 0, 0 );
	until(0,0);
end 

//===============================================================================================
//======== COMMAND SCRIPTS ======================================================================
//===============================================================================================

script static void f_initial_placed_holdstill(ai actor)	
	ai_set_blind (actor, true);
	cs_abort_on_alert(actor, false);
	cs_abort_on_damage(actor, false);
	cs_enable_targeting(actor, false);
	cs_enable_looking(actor, false);
	cs_enable_moving(actor, false);
	cs_shoot(actor, false);
	sleep_until(b_player_ready == true, 1);
	ai_set_blind (actor, false);
	cs_abort_on_alert(actor, true);
	cs_abort_on_damage(actor, true);
	cs_enable_targeting(actor, true);
	cs_enable_looking(actor, true);
	cs_enable_moving(actor, true);
	cs_shoot(actor, true);
end

script command_script cs_poker_squad
	ai_cannot_die(ai_current_actor, true);
	//ai_set_blind (ai_current_actor, true);
	sleep_until(b_players_in_donut == true or b_poker_go_now == true, 1);
	cs_force_combat_status(3);
end

script command_script cs_e9_m5_Villain_healers
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1); 		//Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	object_set_velocity(ai_current_actor, 3, 0, 0);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);			 //grow size over time
	//cs_force_combat_status(3);
end

script command_script cs_e9_m5_bishop_rez_in
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e9_m5_bishop_rez_inb
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1); 		//Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);			 //grow size over time
end

script command_script cs_e9_m5_birthed_bishops1
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	sleep(1);
	r_bishops_birthed = r_bishops_birthed + 1;
	//cs_force_combat_status(3);
end

script command_script cs_e9_m5_shardspawned_pawns1
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	//cs_force_combat_status(3);
	b_pawns_shardspawned1 = true;
	kill_script(f_e9_m5_shard1);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep(1);
end

script command_script cs_e9_m5_shardspawned_pawns2
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	b_pawns_shardspawned2 = true;
	kill_script(f_e9_m5_shard2);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep(1);
end

script command_script cs_e9_m5_Villain_knight
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_allow_resurrect(ai_current_actor, false);
	ai_set_blind (ai_current_actor, true);
	cs_abort_on_alert(false);
	cs_abort_on_damage(false);
	cs_enable_targeting(false);
	cs_enable_looking(false);
	cs_shoot(false);
	sleep(15);
	cs_face(ai_current_actor, true, e9_m5_phase_pts.p8);
	sound_impulse_start('sound\environments\multiplayer\factory\ambience\specifics\factory_knight_distant_howl_01', NONE, 1);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var1", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	sound_impulse_start('sound\storm\characters\knight\foley\npc_storm_knight_foley_qbr_surprise', NONE, 1);
	sleep(15);
	cs_phase_to_point(e9_m5_phase_pts.p3);
	notifylevel("spawnhealers");
	sleep(1);
	sleep_s(1);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var2", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	sleep(15);
	cs_phase_to_point(e9_m5_phase_pts.p4);
	//b_dont_need_replacer = true;
	sleep(1);
	kill_script(f_villain_replacer);              // dont need a replacement anymore, so stop waiting
	sleep_s(1);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var3", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	//sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_knight_scream_for_crawler_retreat', NONE, 1);	
	cs_enable_looking(true);
	ai_set_blind (ai_current_actor, false);	
	cs_enable_targeting(true);
	cs_shoot(true);
	cs_abort_on_alert(true);
	cs_abort_on_damage(true);
end

script command_script cs_e9_m5_Villain_knight2
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_allow_resurrect(ai_current_actor, false);
	ai_set_blind (ai_current_actor, true);
	cs_abort_on_alert(false);
	cs_abort_on_damage(false);
	cs_enable_targeting(false);
	cs_enable_looking(false);
	cs_shoot(false);
	sleep (random_range (1, 3));
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_global_solo_give_command", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	sound_impulse_start('sound\storm\characters\knight\foley\npc_storm_knight_foley_qbr_surprise', NONE, 1);
	cs_phase_to_point(e9_m5_phase_pts.p11);
	sleep(1);
	cs_face(ai_current_actor, true, e9_m5_phase_pts.p4);
	sleep (random_range (1, 5));
	cs_phase_to_point(e9_m5_phase_pts.p12);
	ai_erase (ai_current_actor);
end

script command_script cs_e9_m5_Villain_knight3
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_allow_resurrect(ai_current_actor, false);
	ai_set_blind (ai_current_actor, true);
	cs_abort_on_alert(false);
	cs_abort_on_damage(false);
	cs_enable_targeting(false);
	cs_enable_looking(false);
	cs_shoot(false);
	sound_impulse_start('sound\storm\characters\knight\foley\npc_storm_knight_foley_qbr_surprise', NONE, 1);
	sleep_s(3);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var2", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	sleep(35);
	cs_phase_to_point(e9_m5_phase_pts.p10);
	sleep(1);
	cs_face(ai_current_actor, true, e9_m5_phase_pts.p4);
	sleep (random_range (35, 45));
	sleep(1);
	cs_phase_to_point(e9_m5_phase_pts.p13);
	ai_erase (ai_current_actor);
end

script command_script cs_e9_m5_Villain_knight4
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_set_blind (ai_current_actor, true);
	cs_abort_on_alert(false);
	cs_abort_on_damage(false);
	cs_enable_targeting(false);
	cs_enable_looking(false);
	cs_shoot(false);
	sleep_s(3);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	sleep(31);
	cs_phase_to_point(e9_m5_phase_pts.p9);
	sleep(1);
	cs_face(ai_current_actor, true, e9_m5_phase_pts.p4);
	sleep (random_range (45, 55));
	sleep (random_range (35, 45));
	cs_phase_to_point(e9_m5_phase_pts.p14);
	ai_erase (ai_current_actor);
end

script command_script cs_pawn_pf_roar_6	
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	sleep (random_range (25, 40));
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var6", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	ai_erase (ai_current_actor);
end

script command_script cs_e9_m5_pawn_spawn()
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e9_m5_pawn_spawn_1
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	b_pawns1_spawned == true;
end
/*
script static void f_if_pawns1_spawns_start_VO
	sleep_until(b_pawns1_spawned == true, 1);	
	thread(f_e9_m5_watchers_callouts2());  // Miller : Watchers!
end

script static void f_if_pawns2_spawns_start_VO
	sleep_until(b_pawns2_spawned == true, 1);	
	thread(f_e9_m5_watchers_callouts3());
end
script static void f_if_pawns3_spawns_start_VO
	sleep_until(b_pawns3_spawned == true, 1);	
	thread(f_e9_m5_watchers_callouts4());
end*/

script command_script cs_e9_m5_pawn_spawn_2
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	b_pawns2_spawned == true;
end

script command_script cs_e9_m5_pawn_spawn_3
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	b_pawns3_spawned == true;
end
		
			
script command_script cs_e9_m5_knight_phasein
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	cs_phase_in();
end

script command_script cs_arrogant_crawlers_just_go_please
	if b_rounding_up == true then
		f_blip_ai_cui(ai_current_actor, "navpoint_enemy");
	end
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	ai_set_blind (ai_current_actor, true);
	cs_abort_on_alert(false);
	cs_abort_on_damage(false);
	cs_enable_targeting(false);
	cs_shoot(false);
	cs_go_to(e9_m5_crawler_pts.p1);
	cs_go_to(e9_m5_crawler_pts.p2);
	ai_set_blind (ai_current_actor, false);
	cs_abort_on_alert(true);
	cs_abort_on_damage(true);
	cs_enable_targeting(true);
	cs_shoot(true);
end

script command_script cs_limbo
	//cs_enable_looking(false);
	//cs_enable_targeting(false);
	//cs_enable_targeting(false);
	//ai_set_blind (ai_current_actor, true);
	sleep(1);
	sleep_until(LevelEventStatus("un-limbo"), 1);
	cs_enable_looking(true);
	cs_enable_targeting(true);
	cs_shoot(true);
	//ai_set_blind (ai_current_actor, true);
end

script command_script cs_e9_m5_pelican_drop_1
	vehicle_ignore_damage_knockback(sq_e9_m5_pelican_1,true); 
	object_immune_to_friendly_damage (ai_vehicle_get_from_spawn_point (sq_e9_m5_pelican_1.sp), true);
	cs_vehicle_speed (3.32);	
	cs_ignore_obstacles(false);
	cs_enable_looking(false);
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 7);
	cs_fly_to_and_face(e9_m5_pelican_1_pts.p5,e9_m5_pelican_1_pts.p6);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 370 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, -4);
	cs_vehicle_speed (5);	
	cs_enable_looking(false);
	cs_fly_by(e9_m5_pelican_1_pts.p7);
	thread(f_destroyvehicle(sq_e9_m5_pelican_1));
end
	
script command_script cs_e9_m5_pelican_drop_2
	vehicle_ignore_damage_knockback(sq_e9_m5_pelican_2,true); 
	object_immune_to_friendly_damage (ai_vehicle_get_from_spawn_point (sq_e9_m5_pelican_2.sp), true);
	cs_vehicle_speed (2.95);	
	cs_ignore_obstacles(false);
	cs_enable_looking(false);
	cs_fly_by(e9_m5_pelican_2_pts.p5);
	cs_enable_looking(false);
	cs_vehicle_speed (5);	
	cs_fly_to_and_face(e9_m5_pelican_2_pts.p6,e9_m5_pelican_2_pts.p7);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 370 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, -4);
	cs_fly_by(e9_m5_pelican_2_pts.p1);
	thread(f_destroyvehicle(sq_e9_m5_pelican_2));
end

script command_script cs_e9_m5_fake_phantom_1
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_ignore_obstacles(true);
	cs_enable_looking(false);
	cs_vehicle_speed (1);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 52, 0, 0);
	cs_vehicle_speed (2);	
	cs_fly_to(e9_m5_phantom_1_pts.p7);
	cs_fly_to_and_face(e9_m5_phantom_1_pts.p7,e9_m5_phantom_1_pts.p8);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 280 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 0);
	cs_fly_by(e9_m5_phantom_1_pts.p8);
	thread(f_destroyvehicle(ai_current_actor));
end	

script command_script cs_e9_m5_fake_phantom_2
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_ignore_obstacles(true);
	cs_enable_looking(false);
	cs_vehicle_speed (1);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 50, 0, 0);
	cs_fly_by(e9_m5_phantom_2_pts.p2);
	cs_vehicle_speed (2);	
	cs_fly_by(e9_m5_phantom_2_pts.p6);
	cs_vehicle_speed (3);	
	cs_fly_by(e9_m5_phantom_2_pts.p7);
	cs_fly_by(e9_m5_phantom_2_pts.p8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 280 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 0);
	cs_fly_by(e9_m5_phantom_2_pts.p0);
	thread(f_destroyvehicle(ai_current_actor));
end	

script command_script cs_e9_m5_fake_phantom_3
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_ignore_obstacles(true);
	cs_enable_looking(false);
	cs_vehicle_speed (3);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 46, 0, 0);
	cs_fly_by(e9_m5_phantom_3_pts.p2);
	cs_vehicle_speed (3);	
	cs_fly_to(e9_m5_phantom_3_pts.p7);
	cs_fly_to_and_face(e9_m5_phantom_3_pts.p7,e9_m5_phantom_3_pts.p8);	
	cs_vehicle_speed (3);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 280 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 0);
	cs_fly_by(e9_m5_phantom_3_pts.p8);
	thread(f_destroyvehicle(ai_current_actor));
end	

script command_script cs_e9_m5_fake_phantom_3b
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_ignore_obstacles(true);
	cs_enable_looking(false);
	cs_vehicle_speed (1);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 16, 0, 0);
	cs_fly_by(e9_m5_phantom_3_pts.p2);
	cs_vehicle_speed (2);	
	cs_fly_to(e9_m5_phantom_3_pts.p7);
	cs_fly_to_and_face(e9_m5_phantom_3_pts.p7,e9_m5_phantom_3_pts.p8);	
	cs_vehicle_speed (3);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 280 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 0);
	cs_fly_by(e9_m5_phantom_3_pts.p8);
	thread(f_destroyvehicle(ai_current_actor));
end	
/*script static void cs_e9_m5_phantom_4_breakout_from_float
	sleep_until ((ai_living_count(sq_e9_m5_top_elites_2) + ai_living_count(sq_e9_m5_top_elites_3) <= 0), 1);
	b_phantom_4_skip2 = true;
end
	
script static void cs_e9_m5_phantom_4_unload
	sleep_until ((ai_living_count(sq_e9_m5_top_elites_2) + ai_living_count(sq_e9_m5_top_elites_3) <= 1), 1);
	b_phantom_4_skip = true;
	cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p2,e9_m5_phantom_4_pts.p1);		
	sleep_s(4);	
	f_unload_phantom (sq_e9_m5_phantom_4, "right");
	notifylevel("elitephantunloaded1");
end

script static void cs_e9_m5_phantom_4_floataround(boolean abortBool)
	repeat
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p7,e9_m5_phantom_4_pts.p8);
			sleep_s(3);
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p9,e9_m5_phantom_4_pts.p10);
			sleep_s(3);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p11,e9_m5_phantom_4_pts.p12);
			sleep_s(3);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p13,e9_m5_phantom_4_pts.p14);
			sleep_s(3);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_4, true, e9_m5_phantom_4_pts.p1,e9_m5_phantom_4_pts.p2);
			sleep_s(3);	
		end	
	until (abortBool == true, 1);
end*/

script command_script cs_e9_m5_phantom_4
	vehicle_ignore_damage_knockback(sq_e9_m5_phantom_4,true); 
	cs_ignore_obstacles(false);
	//cs_enable_looking(false);
	//cs_shoot(false); 
	unit_set_maximum_vitality(ai_current_actor, 15000, 15000);     // needs testing, is this too much? o.O
	unit_set_current_vitality(ai_current_actor, 15000, 15000);
	ai_place(sq_e9_m5_top_elites_2);
	ai_place(sq_e9_m5_top_elites_3);
	ai_place(sq_e9_m5_top_elites_4);
	ai_place(sq_e9_m5_top_elites_5);
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_2, sq_e9_m5_phantom_4, "phantom_p_lf");	
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_3, sq_e9_m5_phantom_4, "phantom_p_lb");
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_4, sq_e9_m5_phantom_4, "phantom_p_rb");	
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_5, sq_e9_m5_phantom_4, "phantom_p_rf");
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	cs_vehicle_speed(3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.00, 190 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 1, 0, 0);
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m5_phantom_4), "navpoint_enemy_vehicle");
	//cs_shoot(true);
	cs_fly_by(e9_m5_phantom_4_pts.p1);
	cs_vehicle_speed(0.85);
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p1,e9_m5_phantom_4_pts.p2);	
	cs_ignore_obstacles(true);
	///////////DROP OFF GUYS
	f_unload_phantom (ai_current_squad, "left");
	sleep_s(4);	
	cs_vehicle_speed(0.2);
	cs_fly_by(e9_m5_phantom_4_pts.p11);
	sleep_s(3);	
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p7,e9_m5_phantom_4_pts.p8);
	sleep(45);	
	f_unload_phantom (sq_e9_m5_phantom_4, "right");
	notifylevel("elitephantunloaded1");	
	sleep_s(4);	
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p10,e9_m5_phantom_4_pts.p14);
	sleep_s(6);	
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p13,e9_m5_phantom_4_pts.p14);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p6,e9_m5_phantom_4_pts.p3);	
	sleep(135);
	cs_vehicle_speed(1.15);
	cs_fly_to_and_face(e9_m5_phantom_4_pts.p3,e9_m5_phantom_4_pts.p4);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 190 ); //Shrink size over time
	cs_fly_to(e9_m5_phantom_4_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m5_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m5_phantom_5
	vehicle_ignore_damage_knockback(sq_e9_m5_phantom_5,true); 
	cs_ignore_obstacles(false);
	//cs_enable_looking(false);
	//cs_shoot(false);
	unit_set_maximum_vitality(ai_current_actor, 15000, 15000);     // needs testing, is this too much? o.O
	unit_set_current_vitality(ai_current_actor, 15000, 15000);
	ai_place(sq_e9_m5_top_elites_6);
	//ai_place(sq_e9_m5_top_elites_7);
	ai_place(sq_e9_m5_top_elites_9);
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_6, sq_e9_m5_phantom_5, "phantom_p_lf");	
	//ai_vehicle_enter_immediate(sq_e9_m5_top_elites_7, sq_e9_m5_phantom_5, "phantom_p_lb");
	ai_vehicle_enter_immediate(sq_e9_m5_top_elites_9, sq_e9_m5_phantom_5, "phantom_p_rf");
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	cs_vehicle_speed(3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.00, 190 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 3, 0, 0);
	//cs_shoot(true);
	//cs_enable_targeting(true);	
	cs_vehicle_speed(2.25);
	cs_fly_by(e9_m5_phantom_5_pts.p6);
	cs_vehicle_speed(0.35);
	cs_fly_to_and_face(e9_m5_phantom_5_pts.p1,e9_m5_phantom_5_pts.p2);	
	cs_ignore_obstacles(true);
	///////////DROP OFF GUYS
	f_unload_phantom (ai_current_squad, "left");
	sleep_s(4);
	cs_vehicle_speed(0.20);
	cs_fly_by(e9_m5_phantom_5_pts.p11);
	sleep_s(6);	
	cs_fly_to_and_face(e9_m5_phantom_5_pts.p8,e9_m5_phantom_5_pts.p7);
	sleep(45);	
	f_unload_phantom (sq_e9_m5_phantom_5, "right");
	notifylevel("elitephantunloaded2");
	sleep_s(4);	
	cs_fly_to_and_face(e9_m5_phantom_5_pts.p10,e9_m5_phantom_5_pts.p9);	
	sleep_s(6);	
	cs_fly_by(e9_m5_phantom_5_pts.p11);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m5_phantom_5_pts.p12,e9_m5_phantom_5_pts.p13);	
	sleep(1);	
	cs_fly_to_and_face(e9_m5_phantom_5_pts.p6,e9_m5_phantom_5_pts.p3);
	sleep(135);
	cs_vehicle_speed(1.15);
	cs_fly_by(e9_m5_phantom_5_pts.p3);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 190 ); //Shrink size over time
	cs_fly_to(e9_m5_phantom_5_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m5_phantom_despawn_hack(ai_current_squad);
end	
/*
script static void cs_e9_m5_phantom_5_breakout_from_float
	sleep_until ((ai_living_count(sq_e9_m5_top_elites_9) <= 0), 1);
	b_phantom_5_skip2 = true;
end
	
script static void cs_e9_m5_phantom_5_unload
	sleep_until ((ai_living_count(sq_e9_m5_top_elites_6) + ai_living_count(sq_e9_m5_top_elites_7) <= 2), 1);
	b_phantom_5_skip = true;
	cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_5_pts.p1,e9_m5_phantom_5_pts.p2);		
	sleep_s(4);	
	f_unload_phantom (sq_e9_m5_phantom_5, "right");
	notifylevel("elitephantunloaded2");
end

script static void cs_e9_m5_phantom_5_floataround(boolean abortBool)
	repeat
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p8,e9_m5_phantom_4_pts.p7);
			sleep_s(4);
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p10,e9_m5_phantom_4_pts.p9);
			sleep_s(4);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p11,e9_m5_phantom_4_pts.p13);
			sleep_s(4);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p1,e9_m5_phantom_4_pts.p2);
			sleep_s(4);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p12,e9_m5_phantom_4_pts.p13);
			sleep_s(4);	
		end	
		if abortBool == false then
			cs_fly_to_and_face(sq_e9_m5_phantom_5, true, e9_m5_phantom_4_pts.p11,e9_m5_phantom_4_pts.p13);
			sleep_s(4);	
		end	
	until (abortBool == true, 1);
end*/

//===============================================================================================
//======== CALLOUT SCRIPTS ======================================================================
//===============================================================================================

script static void vo_miller_move_04()
global_narrative_is_on = TRUE;
// Miller : Let's move.
dprint ("Miller: Let's move.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_04'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_move_05()
global_narrative_is_on = TRUE;
// Miller : Get moving.
dprint ("Miller: Get moving.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05'));	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_move_08()
global_narrative_is_on = TRUE;
// Miller : We're on a clock here, folks.
dprint ("Miller: We're on a clock here, folks.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_08'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_move_07()
global_narrative_is_on = TRUE;
// Miller : Crimson, what's the hold up?
dprint ("Miller: Crimson, what's the hold up?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_07'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_one_more_01()
global_narrative_is_on = TRUE;
// Miller : One left.
dprint ("Miller: One left.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_01'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_one_more_03()
global_narrative_is_on = TRUE;
// Miller : Only one more to go.
dprint ("Miller: Only one more to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_03'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_one_more_04()
global_narrative_is_on = TRUE;
// Miller : Get that last one, Crimson.
dprint ("Miller: Get that last one, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_04'));	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_miller_not_done_05()
	global_narrative_is_on = TRUE;
	// Miller : Let's go, Crimson.
	dprint ("Miller: Let's go, Crimson.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_05', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_05'));
	end_radio_transmission();
	global_narrative_is_on = FALSE;
end

script static void vo_miller_move_06()
	global_narrative_is_on = TRUE;
	// Miller : Get a move on.
	dprint ("Miller: Get a move on.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_06', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_06'));
	end_radio_transmission();
	global_narrative_is_on = FALSE;
end

script static void f_e9_m5_miller_neutralize_targets_if_you_havent_forgotten
	if (ai_living_count(gr_e9_m5_ai_all) > 1) then
		thread(f_e9_m5_neutralize_all_targets());
		sleep_until(LevelEventStatus("neutralizethem"), 1);
		if (ai_living_count(gr_e9_m5_ai_all) > 1) then
			notifylevel("neutralize");
		end
	end
end
	
script static void f_e9_m5_miller_finish_cleaning_up_if_you_havent_forgotten
	//thread(f_e9_m5_finish_cleaning_up());
	sleep_s(38);
	if (ai_living_count(gr_e9_m5_ai_all) > 0) then
		if (ai_living_count(gr_e9_m5_ai_all) == 1) then			
			notifylevel("oneleft");
		else
			thread(f_e9_m5_finish_cleaning_up());
		end
	end
	sleep_s(44);
	if (ai_living_count(gr_e9_m5_ai_all) > 0) then
		if (ai_living_count(gr_e9_m5_ai_all) == 1) then			
			notifylevel("oneleft");
		else
			notifylevel("finish_cleaning_up");
		end
	end
end

script static void f_e9_m5_move_it_periodic_reminder
	sleep_s(30);
	if (object_valid(lz_04) and b_players_approached_door == false) then
		r_move_it_times = 0;
		notifylevel("moveit");
	end
	sleep_s(34);
	if (object_valid(lz_04) and b_players_approached_door == false) then
		r_move_it_times = 1;
		notifylevel("moveit");
	end
end

script static void f_e9_m5_move_it_periodic_reminder2
	sleep_s(35);
	if (b_players_left_donut == false) then
		r_move_it_times = 2;
		notifylevel("moveit");
	end
	sleep_s(40);
	if (b_players_left_donut == false) then
		r_move_it_times = 3;
		notifylevel("moveit");
	end
end

script static void f_e9_m5_move_it_periodic_reminder3
	sleep_s(44);
	if (object_valid(lightbridge_lz) and b_players_uptop == false) then
		r_move_it_times = 4;
		notifylevel("moveit");
	end
	sleep_s(44);
	if (object_valid(lightbridge_lz) and b_players_uptop == false) then
		r_move_it_times = 5;
		notifylevel("moveit");
	end
end

script static void vo_miller_keepitup_02()
global_narrative_is_on = TRUE;
// Miller : Keep it up.
dprint ("Miller: Keep it up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end
	   
script static void vo_miller_contacts_04()
global_narrative_is_on = TRUE;
// Miller : Here they come.
dprint ("Miller: Here they come.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_04'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_walls_01()
global_narrative_is_on = TRUE;
// Miller : On the walls!
dprint ("Miller: On the walls!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_01'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_shoot_03()
global_narrative_is_on = TRUE;
// Miller : Light 'em up.
dprint ("Miller: Light 'em up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03'));	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void f_e9_m5_phant_callouts
local real times = 0;
	repeat	
	sleep_until (LevelEventStatus("VO_Phantom"), 1);	
	if b_e9_m5_callout_was_just_called == false then
		sleep_until (b_e9m5_narrative_is_on == false, 1);
		b_e9m5_narrative_is_on = true;
		thread(f_e9_m5_calloutcooldowntimer(5));
		if editor_mode() then
			sleep(1);
			//dprint("PHANTOMS!");
		end
		if times == 0 then
			vo_miller_contacts_04();
		elseif times == 1 then
			print("ignore me");
		elseif times == 2 then
			vo_glo_phantom_07();
		elseif times == 3 then
			vo_glo_phantom_08();
		elseif times == 4 then
			vo_glo_phantom_09();
		else
			vo_glo_phantom_10();
		end
		sleep_s(8);		
		b_e9m5_narrative_is_on = false;
	else
		dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
		sleep(1);
	end
	sleep(1);
	//sleep_until (LevelEventStatus("VO_Phantom") or b_e9_m5_mission_over == true, 1);	
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_droppod_callouts
	repeat
	sleep_until (LevelEventStatus("VO_droppod"), 1);		
	dprint ("----------------------------drop pod inc VO called");	
	if b_e9_m5_callout_was_just_called == false then
		sleep_until (b_e9m5_narrative_is_on == false, 1);
		b_e9m5_narrative_is_on = true;
		thread(f_e9_m5_calloutcooldowntimer(12));
		if editor_mode() then
			sleep(1);
			//dprint("DROP POD!");
		end
		begin_random_count (1)		
		vo_glo_droppod_01();
		vo_glo_droppod_02();
		vo_glo_droppod_03();
		vo_glo_droppod_04();
		vo_glo_droppod_05();
		end
		sleep_s(8);		
		b_e9m5_narrative_is_on = false;
	else
		dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
		sleep(1);
	end
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_lasttargets_callouts	
	local real times = 0;
	repeat
	sleep_until (LevelEventStatus("lasttargets") or b_e9_m5_mission_over == true, 1);	
		if b_e9_m5_mission_over == true then
			sleep(1);
			dprint("MISSION OVER NO MORE CALLOUTS!");
		else	
			if b_e9_m5_callout_was_just_called == false then
				sleep_until (b_e9m5_narrative_is_on == false, 1);
				if (ai_living_count(gr_e9_m5_ai_all) > 0) then
					b_e9m5_narrative_is_on = true;
					thread(f_e9_m5_calloutcooldowntimer(1));
					if editor_mode() then
						sleep(1);
						//dprint("LAST REMAINING GUYS!");
					end			
					//f_unblip_ai_cui(gr_e9_m5_ai_all);
					//begin_random_count (1)		
						//if times == 0 and b_neveragain == false then
						if times == 0 then
							vo_glo_lasttargets_01();  // Miller : Painting the last targets for you now.
							//b_neveragain = true;
						elseif times == 1 then
							vo_glo_lasttargets_02();  // Miller : Just a few stragglers, Crimson.
						elseif times == 2 then
							vo_glo_lasttargets_03();  // Miller : Crimson, got a few left.
						elseif times == 3 then
							vo_glo_lasttargets_04();  // Miller : Here's the last of them.
						elseif times == 4 then
							vo_glo_lasttargets_01();  // Miller : Painting the last targets for you now.
						elseif times == 5 then
							vo_glo_lasttargets_02();  // Miller : Just a few stragglers, Crimson.
						else
							vo_glo_lasttargets_03();  // Miller : Crimson, got a few left.
						end
					//end
					sleep(67);  // sleep for just over 2 secs cos longest vo callout is like 1.735 secs long
					b_e9m5_narrative_is_on = false;	
				else
					dprint ("OH SNAP NO BADGUYS LEFT TO BLIP!!! (ABORTING BLIP CALL)!!");
					sleep(1);
				end			
			else
			 dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
			 sleep(1);
			end		
			times = times + 1;
		end
	until (b_e9_m5_mission_over == true, 1);
end
/*
script static void f_e9_m5_watchout_callouts
	local real times = 0;
	repeat
	if b_e9_m5_callout_was_just_called == false then
		sleep_until (b_e9m5_narrative_is_on == false, 1);
		b_e9m5_narrative_is_on = true;
		thread(f_e9_m5_calloutcooldowntimer(1));
		if editor_mode() then
			sleep(1);
			//dprint("WATCH OUT!");
		end
		begin_random_count (1)
			vo_glo_watchout_06();
			vo_glo_watchout_07();
			vo_glo_watchout_08();
			vo_glo_watchout_09();
			vo_glo_watchout_10();
		end
		sleep_s(8);
		b_e9m5_narrative_is_on = false;	
	else
	 dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
	 sleep(1);
	end
	times = times + 1;
	sleep(35);
	until ((times == 2), 1);
end*/

script static void f_e9_m5_grats_callouts
local real times = 0;
	repeat
		sleep_until (LevelEventStatus("grats"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1, 30 * 3);  // wait for 3 seconds for ppl to stop yammering before gratsing
			if b_e9m5_narrative_is_on == false then
				b_e9m5_narrative_is_on = true;
				thread(f_e9_m5_calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
					//dprint("GRATS!!!!!!!!");
				end
				if times == 0 then
					vo_glo15_miller_attaboy_06();
				elseif times == 1 then
					vo_glo15_miller_attaboy_08();
				elseif times == 2 then
					vo_glo15_miller_attaboy_07();
				elseif times == 3 then
					vo_glo15_miller_attaboy_05();
				elseif times == 4 then
					vo_glo15_miller_attaboy_06();
				else
					vo_glo15_miller_attaboy_08();
				end				
				b_e9m5_narrative_is_on = false;
			else
				dprint("-----------SOMEONE ELSE IS TALKING STILL!, I WONT GRATS AFTERALL!");
			end
		else
			dprint("I TRIED TO SAY GRATS BUT SOMEONE TALKED TOO SOON!");
			sleep(1);
		end
		times = times + 1;
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_incoming_callouts
	//repeat
		//sleep_until (LevelEventStatus("incoming"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("INCOMING!!!!");
			end
			begin_random_count (1)	
				vo_glo_incoming_01();
				vo_glo_incoming_02();
				vo_glo_incoming_04();
				vo_glo_incoming_05();
			end
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
	//until ((villain_fight_stage == 6), 1);
end

script static void f_e9_m5_knights_callouts
	//repeat
		//if ((ai_living_count(sq_e9_m5_Villain_knight4) > 0) or (ai_living_count(gr_e9_m5_garden_knights) > 0)) then
		if (ai_living_count(gr_e9_m5_garden_knights) > 0) then
			if b_callout_was_just_called == false then
				sleep_until (b_e9m5_narrative_is_on == false, 1);
				if (ai_living_count(gr_e9_m5_garden_knights) > 0) then
				//if ((ai_living_count(sq_e9_m5_Villain_knight4) > 0) or (ai_living_count(gr_e9_m5_garden_knights) > 0)) then
					b_e9m5_narrative_is_on = true;
					thread(f_e9_m5_calloutcooldowntimer(1));
					if editor_mode() then
						sleep(1);
						//dprint("KNIGHTS!!!!!!!");
					end
					begin_random_count (1)		
						vo_glo_knights_01();
						vo_glo_knights_02();
						vo_glo_knights_03();
						vo_glo_knights_04();
						vo_glo_knights_05();
					end
					b_e9m5_narrative_is_on = false;
				else
					dprint("-----------NO KNIGHTS LEFT TO TALK ABOUT!");
				end
			else
				dprint("-----------TOO SOON SINCE LAST RANDOM CALLOUT, ABORTING!");
				sleep(1);
			end
		end
		//sleep_until (LevelEventStatus("knights"), 1);
	//until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_pawns_mid_battle_callouts
	local real times = 0;
	repeat
		sleep_until (LevelEventStatus("pawns1"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				//dprint("PAWNS ARE EVERYWHERE!");
				sleep(1);
			end
			if times == 0 then
				vo_glo_crawlers_04();
			elseif times == 1 then
				vo_glo_crawlers_05();
			end
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
		times = times + 1;
	until (b_e9_m5_mission_over == true or (times == 1), 1);
end


script static void f_e9_m5_pawns_hall_tease_callouts
	//repeat
		//sleep_until (LevelEventStatus("pawns2"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(2));
			if editor_mode() then
				sleep(1);
			end
				vo_miller_walls_01();   //Miller : On the Walls!
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
	//until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_watchers_callouts
	repeat
		sleep_until (LevelEventStatus("watchers"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("======================================================================WATCHERS!");
			end
			begin_random_count (1)		
				vo_glo_watchers_01();
				vo_glo_watchers_02();
			end
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
	until (b_e9_m5_mission_over == true, 1);
end
/*
script static void f_e9_m5_watchers_callouts2
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("===============================================================STILL HAVE=======WATCHERS!");
			end
				vo_glo_watchers_03();  // Miller : Watchers!
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
end*/
/*
script static void f_e9_m5_watchers_callouts3
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);	
				//dprint("===============================================================STILL HAVE=======WATCHERS!");
			end	
				vo_glo_watchers_04();
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
end*/
/*
script static void f_e9_m5_watchers_callouts4
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false or b_e9_m5_mission_over == true, 1);	
			if (ai_living_count(gr_e9_m5_ai_all) > 1) then
				b_e9m5_narrative_is_on = true;
				thread(f_e9_m5_calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);	
					//dprint("===============================================================STILL HAVE=======WATCHERS!");
				end
					vo_glo_watchers_05();
				b_e9m5_narrative_is_on = false;
			end
		else
			sleep(1);
		end
end
*/
script static void f_e9_m5_move_it
	repeat
		sleep_until (LevelEventStatus("moveit"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("MOVE IT LETS GO!!");
			end
			if r_move_it_times == 0 then
				vo_miller_move_05();  // Miller : Get moving.
			elseif r_move_it_times == 1 then
				vo_miller_move_08();  // Miller : We're on a clock here, folks.
			elseif r_move_it_times == 2 then
				vo_miller_not_done_05();  // Miller : Let's go, Crimson.
			elseif r_move_it_times == 3 then
				vo_miller_move_06();  // Miller : Get a move on.
			elseif r_move_it_times == 4 then
				vo_miller_move_07();  // Miller : Crimson, what's the hold up?
			elseif r_move_it_times == 5 then
				vo_miller_move_04();  // Miller : Let's move.
			end
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
		//times = times + 1;
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_one_more
	local real times = 0;
	repeat
		sleep_until (LevelEventStatus("oneleft"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false or b_e9_m5_mission_over == true, 1);	
			if (ai_living_count(gr_e9_m5_ai_all) == 1) then
				b_e9m5_narrative_is_on = true;
				thread(f_e9_m5_calloutcooldowntimer(2));
				if editor_mode() then
					sleep(1);
					//dprint("ONE MORE!");
				end
				if times == 0 then
					vo_one_more_04();  // Miller : Get that last one, Crimson.
				elseif times == 1 then
					vo_miller_one_more_01(); // Miller : One left.
				elseif times == 2 then
					vo_glo15_miller_one_more_02(); // Miller : One to go.
				elseif times == 3 then
					vo_miller_one_more_03(); // Miller : Only one more to go.
				elseif times == 4 then
					vo_one_more_04();  // Miller : Get that last one, Crimson.
				elseif times == 5 then
					vo_miller_one_more_01(); // Miller : One left.
				else
					vo_glo15_miller_one_more_02(); // Miller : One to go.
				end
				b_e9m5_narrative_is_on = false;
			end
		else
			sleep(1);
		end
		times = times + 1;
	until (b_e9_m5_mission_over == true, 1);
end

script static void f_e9_m5_keep_it_up
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false or b_e9_m5_mission_over == true, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("KEEP IT UP!");
			end
				vo_miller_keepitup_02();   // Miller : Keep it up.
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
end


script static void f_e9_m5_neutralize_all_targets
	local real times = 0;
	repeat
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);		
			if (ai_living_count(gr_e9_m5_ai_all) > 1) then
				b_e9m5_narrative_is_on = true;
				thread(f_e9_m5_calloutcooldowntimer(3));
				if editor_mode() then
					sleep(1);
					//dprint("NEUTRALIZE ALL TARGETS");
				end
					if times == 0 then
						vo_glo15_miller_few_more_04();   // Miller : Neutralize all targets.
					elseif times == 1 then
						vo_glo15_miller_few_more_06();   // Miller : Take them out.
					else 
						dprint("TRIED TO CALL NEUTRALIZE TARGETS TOO MANY TIMES!");
					end				
				b_e9m5_narrative_is_on = false;
			end
		else
			sleep(1);
		end
		times = times + 1;
		sleep_until (LevelEventStatus("neutralize"), 1);
	until (b_e9_m5_mission_over == true, 1);
end


 //or b_e9_m5_mission_over == true



script static void f_e9_m5_finish_cleaning_up
	local real times = 0;
	repeat
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			if b_rounding_up == true then				
				b_e9m5_narrative_is_on = true;
				thread(f_e9_m5_calloutcooldowntimer(2));
				if editor_mode() then
					sleep(1);
					//dprint("FINISH CLEANING UP");
				end
					if times == 0 then
						vo_glo15_miller_few_more_02();   // Miller : Clean 'em up.
					elseif times == 1 then
						vo_glo15_miller_few_more_08();   // Miller : I'm still seeing targets down there.
					end				
				b_e9m5_narrative_is_on = false;
			end
		else
			sleep(1);
		end
		times = times + 1;		
		sleep_until (LevelEventStatus("finish_cleaning_up"), 1);
	until (b_e9_m5_mission_over == true or (times == 1), 1);
end

script static void f_e9_m5_snipers_callouts
//	repeat
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(3));
			if editor_mode() then				
				sleep(1);
				//dprint("SNIPERS!!!!!!!!!");
			end
			begin_random_count (1)		
				vo_glo_snipers_01();
				vo_glo_snipers_02();
			end
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
	//	sleep_until (LevelEventStatus("snipers"), 1);
//	until ((b_e9_m5_mission_over == true or villain_fight_stage >= 5), 1);
end


script static void f_e9_m5_watchout_miller_callouts   // for when phants blow up warthogs at the very start, precedes Miller's 'Phantoms!'
		if (ai_living_count(sq_e9_m5_pelican_1) > 0) then    // is the criteria we need to watch out for still relevant?
			if b_callout_was_just_called == false then
				sleep_until (b_e9m5_narrative_is_on == false, 1);
				if (ai_living_count(sq_e9_m5_pelican_1) > 0) then   // is the criteria we need to watch out for still relevant?
					b_e9m5_narrative_is_on = true;
					thread(f_e9_m5_calloutcooldowntimer(1));
					if editor_mode() then
						//dprint("Miller:-----------------------Oh NO!");
						sleep(1);
					end
						vo_glo_watchout_06();   // Miller : Oh no!
					b_e9m5_narrative_is_on = false;
				else
					sleep(1);
					dprint("NOTHING LEFT TO WATCH OUT FOR, I GUESS, cos Pelican_1 isnt there!");
				end
			else
				sleep(1);
				dprint("SUPPRESSING CALLOUT, WE JUST CALLED OUT RANDOM STUFF TOO RECENTLY!");
			end
		else
			sleep(1);
			dprint("NOTHING LEFT TO WATCH OUT FOR, I GUESS, cos Pelican_1 isnt there!");
		end
end



script static void f_e9_m5_incoming_immediate_callouts    // MORE OF THEM! (etc)
	//local real times = 0;
	//repeat
		//sleep_until ((LevelEventStatus("incomingimmediate") or b_e9_m5_mission_over == true), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m5_narrative_is_on == false, 1);
			b_e9m5_narrative_is_on = true;
			thread(f_e9_m5_calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("MORE OF THEM!!!!");
			end
			//if times == 0 then
				vo_glo_incoming_01();   // Miller : More bad guys!
			//elseif times == 1 then
			//	vo_glo_incoming_08();
			//end
			//sleep_s(8);		
			b_e9m5_narrative_is_on = false;
		else
			sleep(1);
		end
	//	times = times + 1;
	//until (b_e9_m5_mission_over == true or (times == 1), 1);
end

script static void f_e9_m5_calloutcooldowntimer(real countdown)
	r_e9_m5_countdowns_in_progress = r_e9_m5_countdowns_in_progress + 1;
	if r_e9_m5_countdowns_in_progress == 1 then
		b_e9_m5_callout_was_just_called = true;
		sleep_s(countdown);
		//dprint("---- ITS OKAY TO MAKE ANOTHER CALLOUT!!!");
		b_e9_m5_callout_was_just_called = false;
	end
	r_e9_m5_countdowns_in_progress = r_e9_m5_countdowns_in_progress - 1;
end

