global short s_current_objective_display = 0;

global short s_obj_con = 0;



// =================================================================================================
// =================================================================================================
// OBJECTIVE TRACKING
// =================================================================================================
// =================================================================================================
//
//script static void f_objective_tracker()
//	sleep_until (b_mission_started == TRUE);
//	//dprint  ("><>< objectives start ><><");
//	
//	// start / cryo
//	if (s_current_objective_display == 0) then
//		objectives_show_up_to (0);
//		sleep_until(LevelEventStatus("cryo objective complete"), 1);
//		//dprint ("Objective 1 - Get Cortana ");
//		f_objective_display();
//		cinematic_set_title (obj_get_cortana);
//		s_current_objective_display = s_current_objective_display + 1;
//	end
//	
//	// lab insertion
//	if (s_current_objective_display == 1) then
//		objectives_finish_up_to (0);
//		objectives_show_up_to (1);	
//		sleep_until(LevelEventStatus("librarian moment"), 1);
//		//dprint ("Objective 2 - Turn On Power ");
//		f_objective_display();
//		cinematic_set_title (obj_activate_power);
//		s_current_objective_display = s_current_objective_display + 1;
//	end
//	
//	// observatory
//	if (s_current_objective_display == 2) then
//		objectives_finish_up_to (1);
//		objectives_show_up_to (2);
//		sleep_until(LevelEventStatus("activate power objective complete"), 1);
//		//dprint ("Objective 3 - Launch Beacon ");
//		f_objective_display();
//		cinematic_set_title (obj_launch_beacon);
//		s_current_objective_display = s_current_objective_display + 1;
//	end
//	
//	// flank and beacon
//	if (s_current_objective_display == 3) then
//		objectives_finish_up_to (2);
//		objectives_show_up_to (3);	
//		sleep_until(LevelEventStatus("launch beacon objective complete"), 1);
//		//dprint ("Objective 4 - Escape Ship ");
//		f_objective_display();
//		cinematic_set_title (obj_toescapepodbay);
//		s_current_objective_display = s_current_objective_display + 1;
//	end
//	
//	// escape
//	if (s_current_objective_display == 4) then
//		objectives_finish_up_to (3);
//		objectives_show_up_to (4);	
//		sleep_until(LevelEventStatus("escape ship objective complete"), 1);
//		objectives_finish_up_to (4);
//		s_current_objective_display = s_current_objective_display + 1;
//	end
//	
//end
//
//script static void f_objective_display()
//	sound_impulse_start ('sound\game_sfx\ui\transition_beeps', NONE, 1);
//	cinematic_set_title (obj_dashes);
//	sleep (30 * 1);
//	sound_impulse_start ('sound\game_sfx\ui\transition_beeps', NONE, 1);
//	cinematic_set_title (obj_dashes2);
//	sleep (30 * 1);
//	sound_impulse_start ('sound\game_sfx\ui\transition_beeps', NONE, 1);
//	cinematic_set_title (obj_new);
//	sleep (30 * 4);
//	sound_impulse_start ('sound\game_sfx\ui\transition_beeps', NONE, 1);
//end



/////////////////////
// ELITE SECTION
/////////////////////
/*
script static void f_elite_intro()	
	ai_place(sq_intro_elite);
	unit_doesnt_drop_items (ai_get_object (sq_intro_elite));
	ai_set_active_camo (sq_intro_elite, 1);
	sleep (30 * 1);
	ai_set_active_camo (sq_intro_elite, 0);
	
	// wait a bit for him to start uncloaking
	sleep (30 * 0.5);
		
	//Elite!
	sound_impulse_start ('sound\environments\solo\m010\vo\m_m10_cortana_01300', NONE, 1);
	sleep (30 * 0.5);
	//This- this cannot be!
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:shakefist', 1, temp_camera_hack2);
	sound_impulse_start ('sound\environments\solo\m010\vo\m_m10_angry_elite_01400', NONE, 1);
	sleep (30 * 3);
	//The cryotube’s still powering up!
	sound_impulse_start ('sound\environments\solo\m010\vo\m_m10_cortana_01500', NONE, 1);
	sleep (30 * 3);	
	
	// hit the tube elite
	cs_run_command_script (sq_intro_elite, cs_loop_elite_hit);	
	
	NotifyLevel("cryo elite spawned");	
end


script command_script cs_loop_elite_hit()
	//No Time.
	sound_impulse_start ('sound\environments\solo\m010\vo\m_m10_mc_01600', NONE, 1);
	
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	sleep (30 * 2);
	custom_animation_relative (sq_intro_elite, 'objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph', 'combat:rifle:melee', 1, temp_camera_hack2);
	unit_kill (player0);	
end

*/

	// launch the second beacon
	// device_group_set_immediate (beacon_power, 1);
	// f_blip_object (beacon_cortana_button, "activate");
	// sleep_until (device_get_position(beacon_cortana_button) != 0);
	// thread (f_beacon2_beacon_launch());
	// device_group_set_immediate (beacon_power, 0);
	// f_unblip_object (beacon_cortana_button);
	// sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_flush_core', NONE, 1);
	
	// device_set_position_immediate (beacon_cortana_button, 0);
	
	// sleep_until (LevelEventStatus("beacon2 away"), 1);
	// NotifyLevel("launch beacon objective complete");
		
	// get cortana
	// sleep_until (s_beacon_doors_removed > 1, 1);
	//sleep_until (LevelEventStatus("launch beacon objective complete"), 1);
//	device_group_set_immediate (beacon_power, 1);
	//f_blip_object (beacon_cortana_button, "activate");
	//sleep_until (device_get_position(beacon_cortana_button) != 0);
	//device_group_set_immediate (beacon_power, 0);
	//f_unblip_object (beacon_cortana_button);
	//sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_flush_core', NONE, 1);
	
	//device_set_position_immediate (beacon_cortana_button, 0);
	
// Beacon 2 Doors

//script static void f_beacon2_door1_open()
	//object_rotate_by_offset (bay2_door_1, 0, 20, 0, 0, -100, 0);
//	object_move_by_offset (bay2_door_1, 25, 6, 0, 0, 0);
//	object_destroy (bay2_door_1);
//end

//script static void f_beacon2_door2_open()
	//object_rotate_by_offset (bay2_door_2, 0, 0, 5, 0, 0, 10);
//	object_move_by_offset (bay2_door_2, 5, 0, -0.5, 0, 0);
//end

//script static void f_beacon2_door3_open()
	//object_rotate_by_offset (bay2_door_3, 0, 10, 0, 0, 15, 0);
//	object_move_by_offset (bay2_door_3, 5, 0, 0, 0, 0);
//end

//script static void f_beacon2_door4_open()
	//object_rotate_by_offset (bay2_door_4, 0, 0, 20, 0, 0, -104);
//	object_move_by_offset (bay2_door_4, 25, 0, 6, 0, 0);
//	object_destroy (bay2_door_4);
//end

// Cruiser and Droppods

//script static void f_wave_2_cruiser()

//object_create (beac_cruiser);
//object_set_scale (beac_cruiser, 0.01, 0);
//object_set_scale (beac_cruiser, 1.0, 120);
//sleep (30 * 2);
//thread(f_w2_launch_pods());
//thread(f_w2_cruiser_move());
//thread (cam_shake_players( 0.35, 0.15, 1, 1.5, FALSE ));
//sleep (30*5);
//object_set_scale (beac_cruiser, 0.05, 120);
//effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, beac_cruiser_boom );
//sleep (30 * 8);
//object_destroy (beac_cruiser);
//end

//script static void f_w2_launch_pods()
//sleep (30 * 3);
//thread(f_w2_beac_pod_1());
//sleep(30 * 0.5);
//thread(f_w2_beac_pod_2());
//sleep(30 * 0.5);
//thread(f_w2_beac_pod_3());
//sleep(30 * 2);
//ai_place(sq_w2_elite_1);
//ai_place(sq_w2_grunt_1);
//ai_place(sq_w2_jackal_1);
//ai_place(sq_w2_grunt_2);
//end

// script static void f_w2_beac_pod_1()
 //object_create(beac_pod_1);
 //effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, beac_pod_1_spawn );
 //thread(f_w2_beac_pod_1_move());
 //thread(f_w2_beac_pod_1_land_fx());
 //object_set_scale (beac_pod_1, 0.01, 0);
 //object_set_scale (beac_pod_1, 1.0, 30);
 //end

 //script static void f_w2_beac_pod_2()
 //object_create(beac_pod_2);
 //effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, beac_pod_2_spawn );
 //thread(f_w2_beac_pod_2_move());
 //thread(f_w2_beac_pod_2_land_fx());
 //object_set_scale (beac_pod_2, 0.01, 0);
 //object_set_scale (beac_pod_2, 1.0, 30);
 //end
 
  //script static void f_w2_beac_pod_3()
 //object_create(beac_pod_3);
 //effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, beac_pod_3_spawn );
 //thread(f_w2_beac_pod_3_move());
 //thread(f_w2_beac_pod_3_land_fx());
 //object_set_scale (beac_pod_3, 0.01, 0);
 //object_set_scale (beac_pod_3, 1.0, 30);
 //end

// Cruiser Move 
//script static void f_w2_cruiser_move()
//object_move_to_point (beac_cruiser, 8, ps_beac_cruiser.p0);
//end
//script static void f_w2_beac_pod_1_move()
//object_move_to_point (beac_pod_1, 2, ps_beac_pod_1.p0);
//end
//script static void f_w2_beac_pod_2_move()
//object_move_to_point (beac_pod_2, 2, ps_beac_pod_2.p0);
//end
//script static void f_w2_beac_pod_3_move()
//object_move_to_point (beac_pod_3, 2, ps_beac_pod_3.p0);
//end
// Cruiser Pod FX
//script static void f_w2_beac_pod_1_land_fx()
//sleep_until(objects_distance_to_flag (beac_pod_1, flag_pod1_end) < 2, 1);
//effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, flag_pod1_end );
//camera_shake_all_coop_players (0.65, 0.45, 1, 0.75);
//end
//script static void f_w2_beac_pod_2_land_fx()
//sleep_until(objects_distance_to_flag (beac_pod_2, flag_pod2_end) < 2, 1);
//effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, flag_pod2_end );
//camera_shake_all_coop_players (0.65, 0.45, 1, 0.75);
//end
//script static void f_w2_beac_pod_3_land_fx()
//sleep_until(objects_distance_to_flag (beac_pod_3, flag_pod3_end) < 2, 1);
//effect_new( fx\reach\test\chad\explosions\gritty_explosion_large.effect, flag_pod3_end );
//camera_shake_all_coop_players (0.65, 0.45, 1, 0.75);
//end

//script static void f_magic_sniper_sight()
//	sleep_until (ai_living_count (sq_w1_back_jackals_1) > 0);
//	ai_magically_see_object (sq_w1_back_jackals_1, player0);
//	sleep_until (ai_living_count (sq_w1_back_jackals_2) > 0);
//  ai_magically_see_object (sq_w1_back_jackals_2, player0);
//end

//script command_script cs_phantom_drop4()
	//(f_load_phantom ai_current_squad "double" sq_phantom1_attackers1);
//	//dprint ("stuff");
//end

//script static void f_beacon_reset()
//Destroy Beac 1 Doors
//object_destroy (bay1_door_1);
//object_destroy (bay1_door_2);
//object_destroy (bay1_door_3);
//object_destroy (bay1_door_4);
//sleep (30*1);
//Destroy Beac 2 Doors
//object_destroy (bay2_door_1);
//object_destroy (bay2_door_2);
//object_destroy (bay2_door_3);
//object_destroy (bay2_door_4);
//sleep (30*1);
//Destroy Beacons
//object_destroy (beacon1);
//object_destroy (beacon2);
//sleep (30*1);
//Create Beac 1 Doors
//object_create (bay1_door_1);
//object_create (bay1_door_2);
//object_create (bay1_door_3);
//object_create (bay1_door_4);
//sleep (30*1);
//Create Beac 2 Doors
//object_create (bay2_door_1);
//object_create (bay2_door_2);
//object_create (bay2_door_3);
//object_create (bay2_door_4);
//sleep (30*1);
//Create Beacons
//object_create (beacon1);
//object_create (beacon2);
//end

/*
script static void f_observatory_front_window_open()
	//object_move_to_point (cr_obs_front_windows, 10, ps_front_window_end.p0);
	object_move_by_offset (cr_obs_front_windows, 7, 0, 0, 7);
	object_destroy (cr_obs_front_windows);
end

script static void f_observatory_bottom_window_open()
	object_move_to_point (cr_obs_bottom_windows, 7, ps_bottom_window_end.p0);
end

script static void f_observatory_side_window_open()
	//object_move_to_point (cr_obs_side_windows, 12, ps_side_window_end.p0);
	object_move_by_offset (cr_obs_side_windows, 12, 0, 0, -7);
	object_destroy (cr_obs_side_windows);
end



script static void f_window_1_close()
	object_create (cr_obs_side_windows);
	object_move_to_flag (cr_obs_front_windows, 1.00, obs_window_close_test_1);
end

script static void f_window_2_close()
object_create (cr_obs_front_windows);
object_move_to_flag (cr_obs_bottom_windows, 1.00, obs_window_close_test_2);
end

script static void f_window_3_close()
object_move_to_flag (cr_obs_side_windows, 1.00, obs_window_close_test_3);
end

//windows open

script static void f_windows_open()
	thread (f_observatory_front_window_open());
	thread (f_observatory_bottom_window_open());
	thread (f_observatory_side_window_open());
end
*/


// Accept Button 
//script static void f_display_message_accept (player player_num, string_id	display_title)
//	chud_show_screen_training (player_num, display_title);
//	unit_action_test_reset (player_num);
//	sleep_until (unit_action_test_accept (player_num), 1);
//	chud_show_screen_training (player_num, "");
//end

//Ask for Input
//	f_display_invert_test (player_num, tr_look);

//Check Input
//	if player_action_test_lookstick_forward(player0) then
	//	//dprint ("Non-Invert");
	//	f_ask_to_confirm (player0);
		
//	elseif player_action_test_lookstick_backward(player0)	then
//		//dprint ("Invert");
//		f_training_look_rejected (player0);			
//	else
//		f_display_message_time (player_num, tr_start_menu_short, 100);
//	end
		
//	//dprint ("training look done");
//	NotifyLevel ("look training done");

// Test Initial Input
//script static void f_display_invert_test (player player_num, string_id display_title)
//	chud_show_screen_training (player_num, display_title);
	
//	unit_action_test_reset (player_num);
	
//	sleep_until (player_action_test_lookstick_backward(player0) or  player_action_test_lookstick_forward(player0), 1);
//	//dprint ("player has given input");
	
//	chud_show_screen_training (player_num, "");

//end