//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue
//	Insertion Points:	start (or icl)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short obj_follow = 0;
global short obj_thicket = 0;
global short cutscene_over = 0;
global short obj_trails_1 = 0;
global short rally_drop = 0;
global short cave_spot = 0;

global boolean bw_spawn = false;
global boolean puppet_show_tree = false;

// =================================================================================================
// =================================================================================================
// CAVE - C FROM B
// =================================================================================================
// =================================================================================================

script dormant f_caves_main()
	
	//zone_set_trigger_volume_enable ("zone_set:boulders", FALSE);
	//zone_set_trigger_volume_enable ("begin_zone_set:boulders", FALSE);
	
	if
		m60_achievement_complete == true
	then
		print (":  : M60 Achievement Get :  :");
		submit_incident_with_cause_player (m60_special, player0);
		submit_incident_with_cause_player (m60_special, player1);
		submit_incident_with_cause_player (m60_special, player2);
		submit_incident_with_cause_player (m60_special, player3);
	else
		print (":  : Marines Died / Difficulty too low :  :");
	end
	
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

	sleep_until (volume_test_players (tv_cave_lb), 1);
	
	dprint  (" - caves start - ");
	
//	thread (cave_letter());
	
	//Encounter 4 Music End
	
	thread (f_mus_m60_e04_finish());
	
	wake (cave_spawn);
	game_save();
	
end

script dormant cave_spawn
	sleep_until (volume_test_players (tv_cave_spawn), 1);
	print (":  : Cave Spawn :  :");
	ai_place (sg_cave);
	wake (cave_enc);
	
end

script dormant cave_enc
	
	//Encounter 5 Music Start
	
	thread (f_mus_m60_e05_begin());
	
	ai_set_blind (sg_cave, FALSE);
	
	ai_place (sq_fore_cave_b_1);
	
	sleep_until (ai_strength (sg_cave) < .3);
	
	wake (covenant_forerun_coop_2);
	
	ai_place (sq_cave_phantom);
	
	game_save_no_timeout();
	
	sleep (30);
	
	sleep_until (
		
		bw_spawn == true
		
			OR
		
		ai_living_count (sq_cave_phantom) < 1);
	
//	sleep_until (ai_living_count (sq_cave_cov_hunter) < 1);

//	sleep_until (unit_get_shield (player0) == 1);
	
	game_save_no_timeout();

	sleep (30 * 10);

	ai_place_in_limbo (sq_cave_bw_1);

	wake (f_dialog_m60_callout_knights);
	print (" :  : Cortana : Knights! :  :");
	
	sleep_until	(ai_living_count (sq_cave_bw_1) < 1
		AND
	ai_living_count (sg_cave_drop) < 4);
	
	game_save_no_timeout();
	
	sleep_until (ai_living_count (sq_cave_bw_1) < 1
	
		AND
		
							ai_living_count (sg_cave_drop) < 1);
	
	sleep (30 * 3);
	
	wake (Cortana_cave_cleared);

	//Encounter 5 Music End

	thread (f_mus_m60_e05_finish());

	objectives_finish (1);

	sleep (30 * 4);
	
	print (":  : Pelican Inc :  :");
	
	wake (rally_teleport);

	thread (lz_obj_2());
	
end

script static void lz_obj_2()

	cui_hud_set_objective_complete (chtitlemarsh2);
	sleep (30 * 3);

	cui_hud_set_new_objective(chtitlemarshend);

end

script static void cave_letter()

	/*hud_play_global_animtion (screen_fade_out);
	
	sleep (15);
	
	cinematic_show_letterbox (TRUE);
	
	hud_stop_global_animtion (screen_fade_out);
	
	sleep (30 * 2);
	
	cinematic_set_title (caveletterbox);
	
	sleep (30 * 11);
	
	cinematic_show_letterbox (FALSE);

	sleep (15);

	hud_play_global_animtion (screen_fade_in);
	
	hud_stop_global_animtion (screen_fade_in);

	sleep (15);*/

	f_chapter_title (caveletterbox, TRUE);

end	


// =================================================================================================
// =================================================================================================
// CAVE COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

script command_script cave_phantom

	print (":  : Cave Phantom Inc :  :");
	
	cs_ignore_obstacles (TRUE);
	
	f_load_phantom (sq_cave_phantom, "right", sq_cave_drop_1, none, none, none);
	f_load_phantom (sq_cave_phantom, "left", sq_cave_drop_2, none, none, none);
//	f_load_phantom (sq_cave_phantom, "chute", sq_cave_cov_hunter.h1, sq_cave_cov_hunter.h2, none, none);
	
	cs_vehicle_speed (.75);
	
	cs_fly_by (ps_cave_phantom.p1);
	cs_fly_by (ps_cave_phantom.p2);
	cs_fly_by (ps_cave_phantom.p3);
	
	sleep (45);
	
	cs_vehicle_speed (.25);
	
	cs_fly_to_and_face (ps_cave_phantom.p4, ps_cave_phantom.p5);
	
	sleep (30 * 3);
	
	print (":  : Unloading Side L :  :");
	
	f_unload_phantom (sq_cave_phantom, "left");
	
	sleep (30);
	
	print (":  : Unloading Side R :  :");
	
	f_unload_phantom (sq_cave_phantom, "right");	
	
	sleep (30 * 2);
	
//	f_unload_phantom (sq_cave_phantom, "chute");	
	
	bw_spawn = true;
	
	sleep (30 * 2);
	
	cs_fly_to_and_face (ps_cave_phantom.p3, ps_cave_phantom.p4);
	
	cs_vehicle_speed (.75);
	
	cs_fly_by (ps_cave_phantom.p7);
	cs_fly_by (ps_cave_phantom.p8);
	
	ai_erase (sq_cave_phantom);
end

script command_script cs_soul_fusion()
	cs_phase_in();
end

script command_script cs_bishop_spawn
	print("bishop sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script static void OnCompleteProtoSpawn()
	print("I LIVE. RUN COWARD!");
	bish_born = 1;
end


script command_script cs_knight_boss

	cs_abort_on_alert (1);
	cs_abort_on_damage (1);
	
	cs_walk (1);

	cs_force_combat_status (1);
	
	cs_go_to (ps_cave_grunt_1.p0);
	
	sleep (15);
	
	cs_face (TRUE, ps_cave_grunt_1.p3);
	
	sleep (15);
	
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_global_solo_give_command", TRUE);

end

script command_script cave_grunt_1
	
	cs_abort_on_alert (1);
	cs_walk (1);
	cs_force_combat_status (1);
	cs_go_to (ps_cave_grunt_1.p1);
	
	sleep (30 * 6);
	
end

script command_script cave_grunt_2

	cs_abort_on_alert (1);
	cs_walk (1);
	cs_force_combat_status (1);
	cs_go_to (ps_cave_grunt_1.p2);

	sleep (30 * 6);

end

script command_script cave_grunt_3

	cs_abort_on_alert (1);
	cs_walk (1);
	cs_force_combat_status (1);
	cs_go_to (ps_cave_grunt_1.p3);

	sleep (30 * 6);

end

script command_script cave_grunt_4

	cs_abort_on_alert (1);
	cs_walk (1);
	cs_force_combat_status (1);
	cs_go_to (ps_cave_grunt_1.p7);

	sleep (30 * 6);

end

script command_script cave_grunt_5

	cs_abort_on_alert (1);
	cs_walk (1);
	cs_force_combat_status (1);
	cs_go_to (ps_cave_grunt_1.p8);

	sleep (30 * 6);

end

script static void test_cave_pup()
	
	object_create (pelepupp);
	ai_place (sq_cave_null_pilot);
	ai_vehicle_enter_immediate (sq_cave_null_pilot, pelepupp, pelican_d);
	
	pup_play_show (cave_pelican);
	
end

script command_script cave_pup_sleep
	cs_vehicle_speed_instantaneous (0);
end

// =================================================================================================
// =================================================================================================
// RALLY - this uses insertion point "irp"
// =================================================================================================
// =================================================================================================

script dormant f_rally_main()
	
	fade_out (0, 0, 0, 0);
	
		effects_distortion_enabled = 0;

	objectives_show (3);

	wake (ral_14_co_op);
	wake (ral_15_co_op);

	ai_lod_full_detail_actors (50);
//	sleep_until (b_mission_started == TRUE);
	dprint  (" - rally start - ");
	gpu_throttle_max_allowed_value = .8;
	wake (f_first_rally_infantry);
	dprint (" - woke the infantry - ");
	wake (f_initial_spawn);
	dprint (" - woke the infantry - ");
	wake (f_bowl_setup);
	//wake (f_ghost_hog);
	wake (obj_follow_start);
	wake (obj_follow_1);
	wake (obj_follow_2);
	wake (obj_follow_3);
	wake (obj_follow_35);
	wake (obj_follow_4);
	wake (obj_follow_5);
	wake (obj_follow_6);
	wake (obj_follow_7);
	wake (obj_follow_8);
	
	if
		m60_tank_rally_debug == TRUE
	then
		thread (b_b_debug_check(player0));
		thread (b_b_debug_check(player1));
		thread (b_b_debug_check(player2));
		thread (b_b_debug_check(player3));
	end
	
	game_insertion_point_unlock(6);
	
	thread (f_do_fire_damage_on_trigger (rally_fire_1));
	thread (f_do_fire_damage_on_trigger (rally_fire_2));
	thread (f_do_fire_damage_on_trigger (rally_fire_3));
	thread (f_do_fire_damage_on_trigger (rally_fire_4));
	thread (f_do_fire_damage_on_trigger (rally_fire_5));
	thread (f_do_fire_damage_on_trigger (rally_fire_6));
	thread (f_do_fire_damage_on_trigger (rally_fire_7));
	thread (f_do_fire_damage_on_trigger (rally_fire_8));
	thread (f_do_fire_damage_on_trigger (rally_fire_9));
	thread (f_do_fire_damage_on_trigger (rally_fire_10));
	thread (f_do_fire_damage_on_trigger (rally_fire_11));
	thread (f_do_fire_damage_on_trigger (rally_fire_12));
	thread (f_do_fire_damage_on_trigger (rally_fire_13));
	thread (f_do_fire_damage_on_trigger (rally_fire_14));
	thread (f_do_fire_damage_on_trigger (rally_fire_15));
	thread (f_do_fire_damage_on_trigger (rally_fire_16));
	thread (f_do_fire_damage_on_trigger (rally_fire_17));
	thread (f_do_fire_damage_on_trigger (rally_fire_18));
	thread (f_do_fire_damage_on_trigger (rally_fire_19));
	thread (f_do_fire_damage_on_trigger (rally_fire_20));
	thread (f_do_fire_damage_on_trigger (rally_fire_21));
	
	effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );
	
	print ("TELEPORT!");
	
	data_mine_set_mission_segment("m60_rally");

	//ai_place (sq_rally_pel_2);
	
//	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_l05", player0);
//	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_l04", player1);
//	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_r05", player2);
//	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_r04", player3);
	
//	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), 1);
	
	//ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), TRUE);
		
	//ai_disregard ((ai_actors (sq_rally_pel_2)), TRUE);

	pup_play_show (rally_pelican);

	ai_vehicle_enter_immediate (sq_rally_pel_2, rally_pelepup);

	fade_in (0, 0, 0, 120);
	
	sleep (30 * 3);
	
/*	hud_play_global_animtion (screen_fade_out);
  cinematic_show_letterbox (TRUE);
  sleep_s (1.5);
  cinematic_set_title (rallyletterbox);
  hud_stop_global_animtion (screen_fade_out);
  sleep_s (3.5);     
  hud_play_global_animtion (screen_fade_in);
  hud_stop_global_animtion (screen_fade_in);
  cinematic_show_letterbox (FALSE);*/
  
	f_chapter_title (rallyletterbox, TRUE);
	
	if
		game_coop_player_count() > 2
	then
		object_create (rally_hog);
	end
	
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

end

script static void b_b_debug_check(player p_player)
	
	repeat
	
			sleep_until (vehicle_test_seat_unit (ve_rally_scorpion, "scorpion_d", p_player) == TRUE
			
									OR
									
									vehicle_test_seat_unit (debug_rally_2, "scorpion_d", p_player) == TRUE
									
									OR
									
									vehicle_test_seat_unit (debug_rally_3, "scorpion_d", p_player) == TRUE
									
									OR
									
									vehicle_test_seat_unit (debug_rally_4, "scorpion_d", p_player) == TRUE);
								
			unit_action_test_reset (p_player);
			
			if 
				unit_action_test_primary_trigger (p_player)
			then
				f_play_b_b_1(p_player);
				sleep (120);
			end
			
		until (m60_tank_rally_debug == false);
		
end
		
script static void f_play_b_b_1(player p_player)
	
	print (":  : S1 :  :");
	sound_looping_start ( "sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping", p_player, 1);
	sleep (10);
	sound_looping_stop ("sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping");
	print (":  : S2 :  :");
	sound_looping_start ( "sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping", p_player, 1);
	sleep (45);
	sound_looping_stop ("sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping");

end

script static void act_2_cleanup()
	repeat
		sleep (30 * 15);
		garbage_collect_now();
		print (" :  : Garbage Collection :  : ");
	until (1 == 0);
end

script static void rally_intro_ghost()
	
	sleep_until (volume_test_players (tv_0), 3);
	sleep_until (ai_living_count (sg_rally_intro) < 8);
							
	print (":  : Rally Ghost Spawn :  :");
	ai_place (sq_cov_rally_intro_gh_2);
	//sleep (30 * 5);
	ai_place (sq_cov_rally_intro_gh_1);
	
end

script static void rally_pelican_hog()

	sleep_until (ai_living_count (sq_cov_rally_intro_ph) < 1 
		OR 
		(ai_living_count (sq_cov_rally_intro_inf) + ai_living_count (sq_cov_rally_intro_pawn) < 3));
	
	ai_place (sq_rally_pel_1);	

end

script dormant f_initial_spawn()
	
	object_create (ve_rally_scorpion);
	
	//ai_lod_full_detail_actors (40);
	sleep_until (current_zone_set_fully_active() == zs_caves_rally, 1);
	
	// Encounter 6 Music Start
	
	thread (f_mus_m60_e06_begin());
	
	ai_place (sg_rally_intro);
	game_save_immediate();
	thread (act_2_cleanup());

	thread (rally_intro_ghost());

	ai_place (sq_cov_rally_intro_ph);
	
	thread (rally_pelican_hog());
	
//	print (":  : Player in Scorpion :  :");
	
	sleep_until (volume_test_players (tv_0)
	
	OR
	
	player_in_vehicle (ai_vehicle_get (sq_hum_rally_warthog_1)) == 1);
		
	if
	
		player_in_vehicle (ve_rally_scorpion) == 0
	
	OR
	
		player_in_vehicle (ai_vehicle_get (sq_hum_rally_warthog_1)) == 1
	
	then
		
		thread (spartan_scorpion_enter());
	
	else

		ai_set_task (sq_hum_rally_infantry, obj_hum_vehicle, start);
	
	end
	
	print (":  : Changing warthog obj :  :");

	thread	(rally_intro_obj_change());

	sleep_until (volume_test_players (tv_1), 1);
	
	game_save_no_timeout();
	
	if
		ai_living_count (sg_rally_intro) >= 8
	then
		ai_erase (sq_cov_rally_intro_inf);
		ai_erase (sq_cov_rally_intro_gh_1);
		ai_erase (sq_cov_rally_intro_gh_2);
	end
	
	if
		ai_living_count (sq_rally_pel_1) == 1
	then
		ai_erase (sq_rally_pel_1);
	end
	
	if
		ai_living_count (sg_intro_bowl_drop) >= 4
	then
		ai_erase (sg_intro_bowl_drop);
	end
	
	if
		ai_living_count (sq_cov_rally_intro_ph) >= 1
	then
		ai_erase (sq_cov_rally_intro_ph);
	end
	
	ai_place (sq_cov_rally_s1_pawn);
	ai_place (sq_cov_rally_bend_turret_1);
	ai_place (sq_cov_rally_turret_def_1);

	//object_create_folder (rally_towers);
	
	thread (rally_tower_move_1());

	game_save();
	
	print (":  : Spawning S1 Pawns :  :");
	
	sleep_until (volume_test_players (tv_drop_pod), 1);

	ai_place (sq_cov_bend_1_gh);
	ai_place (sq_cov_bend_15_gh);
	
	sleep_until (volume_test_players (tv_3), 1);
	
	ai_place (sg_rally_bend_1);
	
	//sleep_until (volume_test_players (tv_marine_doom), 1);
	
	//ai_place (sq_hum_bend_doom);
	
	sleep_until (volume_test_players (tv_rally_bend), 1);
	
	ai_place (sq_cov_bend_wr);
	
	sleep_until (volume_test_players (tv_rally_bend_objcon), 1);
	
	//ai_place (sq_cov_bend_wr_2);
	
	//ai_place (sq_cov_bend_wr_gh_1);
		
	//ai_place (sq_cov_bend_wr_gh_2);
	
	sleep_until (volume_test_players (tv_35), 1);
	
	thread (rally_tower_move_2());

	sleep (5);

	ai_place (sg_rally_s2);
	
	print (":  : Tower Move :  :");
	
	ai_place (sq_cov_rally_s2_pawn);
	
	sleep_until (volume_test_players (tv_turret_wall_spawn), 1);
	
	ai_place (sq_cov_rally_gh_s3);
	
	print (":  : Ghost S3 :  :");
	
	sleep_until (volume_test_players (tv_ghost_jump), 1);
	
	ai_place (sg_rally_s3);
	
	if
		ai_living_count (sg_rally_bend_1) >= 10
	then
		ai_erase (sg_rally_bend_1);
	end

	if
		ai_living_count (sq_cov_rally_s1_pawn) >= 3
	then
		ai_erase (sq_cov_rally_s1_pawn);
	end
	
	if
		ai_living_count (sq_cov_rally_s2_pawn) >= 3
	then
		ai_erase (sq_cov_rally_s1_pawn);
	end
			
end

script static void rally_tower_move_1()

	object_move_to_point (pod_1, 0, tower_pod.p0);

	object_rotate_to_point (pod_1, 0, 0, 0, tower_pod.p0);

	object_move_to_point (pod_2, 0, tower_pod.p1);

	object_rotate_to_point (pod_2, 0, 0, 0, tower_pod.p1);

	object_move_to_point (pod_3, 0, tower_pod.p2);
	
	object_rotate_to_point (pod_3, 0, 0, 0, tower_pod.p2);

	object_move_to_point (pod_4, 0, tower_pod.p3);

	object_rotate_to_point (pod_4, 0, 0, 0, tower_pod.p3);

	object_move_to_point (pod_5, 0, tower_pod.p4);

	object_rotate_to_point (pod_5, 0, 0, 0, tower_pod.p4);

end

script static void rally_tower_move_2()

	object_move_to_point (pod_6, 0, tower_pod.p5);
	
	object_rotate_to_point (pod_6, 0, 0, 0, tower_pod.p5);
	
	object_move_to_point (pod_7, 0, tower_pod.p6);

	object_rotate_to_point (pod_7, 0, 0, 0, tower_pod.p6);

end

script static void spartan_scorpion_enter()

	print (":  : Spartans Entering Scorpion :  :");
		
		repeat
		
			ai_vehicle_enter (sq_hum_rally_infantry, ve_rally_scorpion);
		
		until
		
		(vehicle_test_seat (ve_rally_scorpion, "scorpion_d") == TRUE);
		
		sleep (30 * 5);
	
		ai_set_task (sq_hum_rally_infantry, obj_hum_vehicle, start);

end

script static void rally_intro_obj_change()

//	sleep_until (ai_living_count (sq_hum_rally_warthog_1) > 1);
	
	sleep_until (volume_test_players (tv_0), 1);
	
	ai_set_objective (sq_hum_rally_warthog_1, obj_hum_vehicle);
	ai_set_objective (sq_hum_rally_infantry, obj_hum_vehicle);
	print (" :  : Warthog Idiots Should Be In Main Vehicle Objective! IDIOTS! :  :");

end

script dormant f_first_rally_infantry()
	sleep_until (volume_test_players (tv_1st_rally_infantry), 1);
	ai_place (sq_phantom_destroy);
	ai_disregard ((ai_actors (sq_phantom_destroy)), TRUE);
	print (":  : Phantom Drop :  :");
	garbage_collect_now();
end

script dormant f_bowl_setup()
	sleep_until (volume_test_players (tv_bowl_start), 1);
	print ("Bowl Encounter Spawning");
	
	garbage_collect_now();
	
	ai_place (sg_bowl_all);
	ai_place (sq_bowl_hum_mid);
	
	//sleep_until (current_zone_set_fully_active() == s_infinity_ins_idx, 1);
	
	wake (f_door_open);
	
	zone_set_trigger_volume_enable ("zone_set:infinity_berth:*", FALSE);
	zone_set_trigger_volume_enable ("begin_zone_set:infinity_berth:*", FALSE);
	
	sleep (30 * 2);
	
	print (":  : Inf Berth Awake :  :");
		
	garbage_collect_now();
	
end

script dormant f_door_open()

//	thread (m60_infinity_ext_cleared());

	sleep (30 * 2);
	
	f_blip_flag (infinity_door_right, "recon");
	
	sleep_until (volume_test_players (tv_berth_enter), 1);

	infinity_rock_fall->f_animate();

	sleep (30 * 5);

	zone_set_trigger_volume_enable ("begin_zone_set:infinity_berth:*", TRUE);
	
	if (not editor_mode()) then
		sleep_until(current_zone_set() == zs_infinity_berth, 1); // Wait a tick until the volume becomes triggered.
	end
	
	print (" :  : Begin zone set enabled :  :");

//	switch_zone_set (infinity_berth);
	
	print (":  : Temp Berth Teleport :  :");
	
	f_unblip_flag (infinity_door_right);
	
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	
	print (" :  : Trigger volume enabled :  :");
	
	zone_set_trigger_volume_enable ("zone_set:infinity_berth:*", TRUE);
	
	infinity_tank_lift->f_animate();
	
	volume_teleport_players_not_inside_with_vehicles (tv_berth_enter, tank_lift_teleport);
	
	wake (inf_berth);
	
		if
			(ai_living_count (sq_hum_rally_infantry) == 4)
		AND
			(ai_living_count (sq_hum_rally_warthog_1) == 2)
		then
			print (":  : Rally Marines Are Alive :  :");
			m60_achievement_rally = true;
		else
			print (":  : Rally Marines Are Dead! You Monster! :  :");
		end
	
	thread (m60_infinity_run_03());
	
	sleep (30 * 10);
	
	volume_teleport_players_not_inside (trig_inf_berth_mid, f_teleport_berth_safety);
	
end

script dormant f_rally_obj()
	cui_hud_set_new_objective (chtitlerally);
end	

// =================================================================================================
// =================================================================================================
// RALLY MARINE AI
// =================================================================================================
// =================================================================================================

script dormant rally_overturned()
	
	repeat
		
		if
			vehicle_overturned (ai_vehicle_get_from_spawn_point (sq_hum_rally_warthog_1.p0)) == TRUE
		then		
			print (":  : Rally Warthog Tipped!! :  :");
			
			sleep_until (ai_in_vehicle_count (sq_hum_rally_warthog_1) == 0);
			ai_vehicle_enter (sq_hum_rally_warthog_1, (ai_vehicle_get_from_spawn_point (sq_hum_rally_warthog_1.p0)));
			
		end
		
	until (1 == 0);
	
end
	
script dormant obj_follow_start()
	sleep_until (volume_test_players (tv_0), 1);
	obj_follow = 1;
	print ("obj_follow 1 - marines moving up");
end

script dormant obj_follow_1()
	sleep_until (volume_test_players (tv_1), 1);
	obj_follow = 5;
	print ("obj_follow 5 - marines moving up");
end

script dormant obj_follow_2()
	sleep_until (volume_test_players (tv_2), 1);
	obj_follow = 10; 
	print ("obj_follow 10 - marines moving up");
end

script dormant obj_follow_3()
	sleep_until (volume_test_players (tv_3), 1);
	obj_follow = 15; 
	print ("obj_follow 15 - marines moving up");
end

script dormant obj_follow_35()
	sleep_until (volume_test_players (tv_35), 1);
	obj_follow = 32;
	print ("obj_follow 40 - marines moving up"); 
end

script dormant obj_follow_4()
	sleep_until (volume_test_players (tv_4), 1);
	obj_follow = 20;
	print ("obj_follow 20 - marines moving up"); 
end

script dormant obj_follow_5()
	sleep_until (volume_test_players (tv_5), 1);
	obj_follow = 25;
	print ("obj_follow 25 - marines moving up"); 
	game_save_no_timeout();
end

script dormant obj_follow_6()
	sleep_until (volume_test_players (tv_6), 1);
	obj_follow = 30; 
	print ("obj_follow 30 - marines moving up");
end

script dormant obj_follow_7()
	sleep_until (volume_test_players (tv_7), 1);
	obj_follow = 35;
	print ("obj_follow 35 - marines moving up");
end

script dormant obj_follow_8()
	sleep_until (volume_test_players (tv_8), 1);
	obj_follow = 40;
	print ("obj_follow 40 - marines moving up"); 
end

/*
script command_script gausshog_go_1()
	cs_enable_targeting (TRUE);
	cs_enable_looking (TRUE);
	cs_enable_moving (TRUE);
	
	sleep_until (volume_test_players (tv_1));
	print ("tv_1 hit, moving gausshog");
	cs_go_to (ps_gausshog.p0);
	cs_go_to (ps_gausshog.p1);
	cs_go_to (ps_gausshog.p2);
	cs_go_to (ps_gausshog.p3);
//	cs_go_to_and_face (ps_gausshog.p2, ps_gausshog.p3);
//	cs_go_to_and_face (ps_gausshog.p3, ps_gausshog.p4);
	
	print ("test");
	sleep_until (volume_test_players (tv_2));
	print ("tv_2 hit, moving gausshog");
	cs_go_to (ps_gausshog.p4);
	cs_go_to_and_face (ps_gausshog.p5, ps_gausshog.p6);
	cs_go_to_and_face (ps_gausshog.p6, ps_gausshog.p7);
	cs_go_to_and_face (ps_gausshog.p8, ps_gausshog.p9);
	
	sleep_until (volume_test_players (tv_3));
	print ("tv_3 hit, moving gausshog");
	cs_go_to (ps_gausshog.p9);
	cs_go_to_and_face (ps_gausshog.p10, ps_gausshog.p11);
end	
*/

// =================================================================================================
// =================================================================================================
// RALLY COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

script command_script cs_rally_intro_phantom

	f_load_phantom (sq_cov_rally_intro_ph, "left", sq_cov_rally_intro_drop_l, none, none, none);
	f_load_phantom (sq_cov_rally_intro_ph, "right", sq_cov_rally_intro_drop_r, none, none, none);

	ai_braindead ((ai_get_turret_ai(ai_current_actor, 0)), TRUE);

	cs_fly_by (ps_phantom_ral_1.p6);
	cs_fly_by (ps_phantom_ral_1.p5);
	cs_fly_by (ps_phantom_ral_1.p0);
	cs_fly_by (ps_phantom_ral_1.p1);
	//ai_braindead ((ai_get_turret_ai(ai_current_actor, 0)), FALSE);
	cs_vehicle_speed (.75);
	cs_fly_by (ps_phantom_ral_1.p8);
	cs_fly_to_and_face (ps_phantom_ral_1.p2, ps_phantom_ral_1.p3);
	sleep (30 * 2);
	f_unload_phantom (sq_cov_rally_intro_ph, "right");
	f_unload_phantom (sq_cov_rally_intro_ph, "left");
	sleep (30 * 2);
	cs_fly_by (ps_phantom_ral_1.p4);
	cs_fly_by (ps_phantom_ral_1.p8);
	//ai_braindead ((ai_get_turret_ai(ai_current_actor, 0)), TRUE);
	cs_fly_by (ps_phantom_ral_1.p1);
	cs_fly_by (ps_phantom_ral_1.p0);
	cs_fly_by (ps_phantom_ral_1.p5);
	cs_fly_by (ps_phantom_ral_1.p6);
	cs_fly_by (ps_phantom_ral_1.p7);
	ai_erase (sq_cov_rally_intro_ph);

end

script command_script cs_rally_pelican_1

	print ("HEY");
	//cs_ignore_obstacles (TRUE);
	ai_place (sq_hum_rally_warthog_1);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_rally_pel_1.driver), "pelican_lc", (ai_vehicle_get_from_spawn_point (sq_hum_rally_warthog_1.p0))); 
	cs_vehicle_speed (.75);
	cs_fly_by (ral_pel_1.p0);
	cs_fly_by (ral_pel_1.p5);
	cs_vehicle_speed (.5);
	cs_fly_to_and_face (ral_pel_1.p4, ral_pel_1.p3);
	sleep (30 * 2);
	sleep_until 
	(
	 (volume_test_players (tv_ral_pel_drop) == 0)
	AND
	 (
	  (ai_living_count (sq_hum_rally_infantry) == 0)
	   OR 
	  (volume_test_objects_all (tv_ral_pel_drop, (ai_actors (sq_hum_rally_infantry))) == FALSE)
	 )
	);
	
	vehicle_unload	((ai_vehicle_get_from_spawn_point (sq_rally_pel_1.driver)), "pelican_lc");
	sleep (30 * 2);
	cs_vehicle_speed (.3);
	cs_fly_by (ral_pel_1.p6);
	cs_vehicle_speed (1);
	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_rally_pel_1.driver)), .01, 210);
	cs_fly_by (ral_pel_1.p7);
	ai_erase (sq_rally_pel_1);
	
end

script command_script cs_rally_flyin

	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_l01", 1, 0);	
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_l02", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_l03", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_l04", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_l05", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_r01", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_r02", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_r03", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_r04", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get (ai_current_actor), "pelican_p_r05", 1, 0);

	ai_disregard (ai_vehicle_get_from_spawn_point (sq_rally_pel_2), TRUE);

	sleep (30 * 3);
	
	unit_exit_vehicle (player0, 0);
	unit_exit_vehicle (player1, 0);
	unit_exit_vehicle (player2, 0);
	unit_exit_vehicle (player3, 0);

	sleep_until (player_in_vehicle (ai_vehicle_get (ai_current_actor)) == 0);

	//thread (pelican_door_anim_rally());
	
	print (":  : Pelican Exited :  :");
	
	//cs_vehicle_speed (.5);
	
	//sleep (30 * 2);

	ai_disregard (ai_vehicle_get_from_spawn_point (sq_rally_pel_2), FALSE);
	
	//sleep (10);

	//cs_vehicle_speed (.3);

	//sleep (10);
	
	//object_set_scale (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), .5, 150);
		

end

script static void pelican_door_anim_rally()
	custom_animation_hold_last_frame (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", false);
//	sleep_until (volume_test_players (tv_pelican_out), 1);
	sleep (30 * 5);
	unit_stop_custom_animation (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver));
end

script command_script wraith_shoot
	cs_shoot (TRUE, player0);
	sleep (30 * 10);
end

script command_script f_rally_ghost_jump()
	cs_abort_on_damage (TRUE);
	cs_vehicle_boost (TRUE);
	cs_enable_targeting (TRUE);
	cs_move_towards_point (ps_ghost_jump.p0, 0.25);
	cs_move_towards_point (ps_ghost_jump.p1, .25);
	cs_vehicle_boost (FALSE);
	cs_move_towards_point (ps_ghost_jump.p2, 25);
end	

script command_script bowl_ghost_surprise()
	cs_abort_on_damage (TRUE);
	cs_vehicle_boost (TRUE);
	cs_move_towards_point (ps_bowl_ghosts.p0, 0.5);
	cs_move_towards_point (ps_bowl_ghosts.p1, 0.5);
end

script command_script bowl_ghost_surprise_2()
	cs_abort_on_damage (TRUE);
	cs_vehicle_boost (TRUE);
	cs_move_towards_point (ps_bowl_ghosts_2.p0, 0.5);
	cs_move_towards_point (ps_bowl_ghosts_2.p1, 0.5);
	cs_face (TRUE, ps_bowl_ghosts_2.p2);
	cs_vehicle_boost (FALSE);
	cs_move_towards_point (ps_bowl_ghosts_2.p2, 0.5);
	cs_face (FALSE, ps_bowl_ghosts_2.p2);
	cs_face (TRUE, ps_bowl_ghosts_2.p3);
	cs_move_towards_point (ps_bowl_ghosts_2.p3, 0.5);
end

script command_script rally_ghost_3_a
	cs_vehicle_boost (TRUE);
	cs_ignore_obstacles (TRUE);
	cs_move_towards_point (ps_ghost_attack_1.p0, 0.5);
end

script command_script rally_ghost_3_b
	cs_vehicle_boost (TRUE);
	//cs_ignore_obstacles (TRUE);
	cs_move_towards_point (ps_rally_ghost_boost.p0, 0.5);
end

script command_script bowl_rear_wraith()
	cs_abort_on_damage (TRUE);
	cs_move_towards_point (ps_rear_wraith.p0, 1);
	cs_face (TRUE, ps_rear_wraith.p2);
	cs_move_towards_point (ps_rear_wraith.p1, 1);
end

script command_script phantom_destroy()
	print ("place ghost 1");
	ai_place (sq_cov_rally_2);
	print ("place ghost 2");
	ai_place (sq_cov_rally_3);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_phantom_destroy.driver), "phantom_sc02", ai_vehicle_get_from_starting_location (sq_cov_rally_2.driver));
	print ("load ghost 1");
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_phantom_destroy.driver), "phantom_sc01", ai_vehicle_get_from_starting_location (sq_cov_rally_3.driver));
	print ("load ghost 2");
	cs_vehicle_speed (2);
	cs_fly_by (ps_phantom_destroy.p4);
	cs_fly_by (ps_phantom_destroy.p8);
	cs_fly_to_and_face (ps_phantom_destroy.p6, ps_phantom_destroy.p7);
	sleep (30 * 2);
			vehicle_unload	((ai_vehicle_get_from_spawn_point (sq_phantom_destroy.driver)), "phantom_sc02");
			print ("unload ghost 1");
	cs_fly_to_and_face (ps_phantom_destroy.p5, ps_phantom_destroy.p1);
	sleep (30 * 2);
			vehicle_unload	((ai_vehicle_get_from_spawn_point (sq_phantom_destroy.driver)), "phantom_sc01");
			print ("unload ghost 2");
	sleep (30 * 2);
		cs_vehicle_speed (.5);
	//cs_fly_by (ps_phantom_destroy.p2);
	cs_fly_by (ps_phantom_destroy.p3);
	ai_erase (sq_phantom_destroy);
	
end

script dormant phantom_garbage_collect()
	sleep_until (ai_living_count (sq_phantom_destroy) == 0) or (volume_test_players (tv_watchtower_spawn));
	garbage_collect_now();
end

script command_script startup_attack_infinity_1()
cs_abort_on_damage (TRUE);
repeat 
cs_shoot_point (true, ps_infinity_points.p0);
until (volume_test_players (tv_abort_shooting_infinity), 1);
end

script command_script startup_attack_infinity_2()
cs_abort_on_damage (TRUE);
repeat 
cs_shoot_point (true, ps_infinity_points.p1);
until (volume_test_players (tv_abort_shooting_infinity), 1);
end

// =================================================================================================
// =================================================================================================
// RALLY PAWN INTRO
// =================================================================================================
// =================================================================================================

script command_script cs_rally_pawn_1

	cs_abort_on_damage (TRUE);
	cs_go_to (ps_rally_pawn.p0);
	cs_go_to (ps_rally_pawn.p1);
	cs_go_to (ps_rally_pawn.p2);
	cs_go_to (ps_rally_pawn.p3);
	
end

script command_script cs_rally_pawn_2

	cs_abort_on_damage (TRUE);
	cs_go_to (ps_rally_pawn.p7);
	cs_go_to (ps_rally_pawn.p8);
	cs_go_to (ps_rally_pawn.p9);
	
end

script command_script cs_rally_pawn_3

	cs_abort_on_damage (TRUE);
	cs_go_to (ps_rally_pawn.p4);
	cs_go_to (ps_rally_pawn.p5);
	cs_go_to (ps_rally_pawn.p6);
	
end

// =================================================================================================
// =================================================================================================
// TRAILS
// =================================================================================================
// =================================================================================================

script dormant f_thicket_main()

	sleep_until (b_mission_started == TRUE);
	dprint  (" - trails start - ");
	wake (f_thicket_tv_check_1);
	wake (f_thicket_tv_check_2);
	wake (f_thicket_tv_check_3);
	wake (f_thicket_tv_check_4);
	wake (f_thicket_tv_check_5);
	wake (f_chtitletrails);
	wake (f_trails_1_enc_1);
	wake (f_trails_1_enc_2);
	//wake (f_spawn_intro_knights);
	
end


script dormant f_thicket_tv_check_1()
	sleep_until (volume_test_players (tv_spawn_2), 1);
	print ("obj_thicket = 1");
	obj_thicket = 1;
	game_save_no_timeout();
	garbage_collect_now();
end

script dormant f_thicket_tv_check_2()
	sleep_until (volume_test_players (tv_spawn_3), 1);
	print ("obj_thicket = 2");
	obj_thicket = 2;
	game_save_no_timeout();
	garbage_collect_now();
end

script dormant f_thicket_tv_check_3()
	sleep_until (volume_test_players (tv_spawn_4), 1);
	print ("obj_thicket = 3");
	obj_thicket = 3;
	game_save();
	game_save_no_timeout();
	garbage_collect_now();
end

script dormant f_thicket_tv_check_4()
	sleep_until (volume_test_players (tv_spawn_5), 1);
	print ("obj_thicket = 4");
	obj_thicket = 4;
	game_save_no_timeout();
	garbage_collect_now();
end

script dormant f_thicket_tv_check_5()
	sleep_until (volume_test_players (tv_spawn_6), 1);
	print ("obj_thicket = 5");
	obj_thicket = 5;
	game_save_no_timeout();
end

script dormant f_chtitletrails()
	sleep_until (volume_test_players (tv_chtitletrails), 1);
	
	//cui_hud_set_new_objective (chtitletrails);
	
	//wake (f_chtitletrails_end);
	
	garbage_collect_now();
end
	
script dormant f_chtitletrails_end()	
	cui_hud_set_objective_complete (obj_complete);
	sleep (30 * 3);
	garbage_collect_now();
end

script dormant f_laskytemp()

	fade_out (0, 0, 0, 0);

	objectives_finish (0);
	
	switch_zone_set (trail_boulders);
	sleep_until (current_zone_set_fully_active() == zs_trail_boulders, 2);
	object_teleport_to_ai_point (player0, ps_laskytemp.p0);
	object_teleport_to_ai_point (player1, ps_laskytemp.p1);
	object_teleport_to_ai_point (player2, ps_laskytemp.p2);
	object_teleport_to_ai_point (player3, ps_laskytemp.p3);
	cutscene_over = 1;
	thread (trails3lb());
	
	hud_play_global_animtion (screen_fade_out);
	
	sleep (15);
	
	cinematic_show_letterbox (TRUE);
	
	hud_stop_global_animtion (screen_fade_out);
	
	fade_in (0, 0, 0, 90);
	game_save_immediate();
	
	wake (trail_2);
	
end


script static void trails3lb()

	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (t3letterbox);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);     
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
	
	cui_hud_set_new_objective (chtitleintro);
	
	garbage_collect_now();
	
end

script static void f_delrio_speaks()
	// 204 : This is Del Rio of the Infinity. I'm transmitting on an open frequency! Infinity is under attack! All ground forces are ordered to return to Infinity immediately! Anyone reading this, respond to Comm on... what frequency? (doesn’t get an answer) What frequency, damnit?!? (gets his answer) 1
	//sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Del_Rio03300', NONE, 1);
	//	sleep (30 * 20);
	// 405 : Transmitting on an open frequency! Infinity is under attack!
	sound_impulse_start ('sound\environments\solo\m060\vo\m_m60_del_rio_03100', NONE, 1);
	sleep (30 * 6.507);

end

////////----------------------///////
// KNIGHT BIRTHING BISHOP //
////////----------------------///////

script command_script cs_bishop_spawn1()
        print("bishop sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn1, 0);
end

script static void OnCompleteProtoSpawn1()
print("I LIVE. RUN COWARD!");
end

////////----------------------///////
// ENCOUNTER 1 //
////////----------------------///////

script static void rock_pawn_sound()

	sleep (110);
	if
		ai_living_count (sq_e3_rock_pawn) == 1
	then
		sound_impulse_start (sound\storm\characters\pawn\vo\npc_pawn_any_beserk_vox_temp, sq_e3_rock_pawn, 1 );
		print("bark sound");
	else
		print (":  : Rock Pawn's Dead :  :");
	end
	
end

script dormant f_trails_1_enc_1()

	sleep_until (volume_test_players (tv_spawn_enc_1), 1);
	
	object_wake_physics (trail_a_dead_1);
	object_wake_physics (trail_a_dead_2);
	object_wake_physics (trail_a_dead_3);
	object_wake_physics (trail_a_dead_5);
	object_wake_physics (trail_a_dead_6);
	object_wake_physics (trail_a_dead_7);
	
	//First Encounter Music Start
	thread(f_mus_m60_e01_begin());
	
	print ("spawning first encounter");
	ai_lod_full_detail_actors (9);
	ai_place (sg_enc_1);
	//pup_play_show (rock_pawn_early);
	sleep_until (volume_test_players (tv_birth_babby), 1);
	print (":  : Pawn Hero XP! :  :");
	//ai_place (sq_enc_1_knight_1);
	game_save_no_timeout();
	pup_play_show (hero_pawn_xp);
	sleep_until (volume_test_players (trig_pawn_obj), 1);
	pup_play_show (wall_pawn);
	wake (pup_tree_kill);
	garbage_collect_now();
	sleep_until (volume_test_players (tv_pawn_rock), 1);
	pup_play_show (rock_pawn);
	thread (rock_pawn_sound());
	sleep_until (volume_test_players (trig_trail1_spawn2), 1);
	sleep_until (current_zone_set_fully_active() == zs_trail_a, 1);
	print (":  : Spawn Trail 1-B :  :");
	ai_place (sg_enc_1_b);
	sleep_until (volume_test_players (trig_trail1_knight_surprise), 1);
	ai_place (sq_enc_1_bi);
	unit_doesnt_drop_items (ai_actors (sq_enc_1_bi));
	ai_place (sq_enc_1_pawn_2_d);
end

script dormant pup_tree_kill
	
	sleep_until (puppet_show_tree == TRUE);
	
	sleep_until(volume_test_players_lookat(trig_trails_vig_lookat, 40, 40) == FALSE);
	print (" :  : Not looking at puppet :  :");
	ai_erase (sq_pawn_wall_animated);

end


/*script dormant f_spawn_intro_knights

	sleep_until (volume_test_players (spawn_intro_knights_1), 1);
	ai_place (sq_knight_intro_1);
	ai_place (sq_knight_intro_4);
	ai_place (sq_knight_intro_5);
	object_wake_physics (dm_thicket_1);
	object_wake_physics (dm_thicket_2);
	object_wake_physics (dm_thicket_3);
	object_wake_physics (dm_thicket_4);

end*/

script command_script cs_knight_enc_1_phase_1()
	sleep_until (volume_test_players (tv_birth_babby), 1);
	cs_phase_to_point(ps_enc_1_knight_phase.p0);
end

script command_script cs_trail_1_kn_phase
	cs_phase_to_point(ps_enc_1_knight_phase.p2);
end

script command_script cs_trail_1_kn_phase_2
	cs_phase_to_point(ps_enc_1_knight_phase.p3);
end

/////====================///////////
//// KNIGHT INTRO PHASING ////
////=====================/////////

script static void xray_fx_play(ai the_guy)
	effect_new_on_object_marker ("objects\equipment\storm_forerunner_vision\fx\storm_forerunner_vision.effect", the_guy, "fx_head");
	print ("played xray fx");
end

script static void xray_fx_stop(ai the_guy)
	effect_stop_object_marker ("objects\equipment\storm_forerunner_vision\fx\storm_forerunner_vision.effect", the_guy, "fx_head");
	print ("stopped xray fx");
end

script command_script cs_knight_intro_phase_1()
sleep_until 
(
	volume_test_players (tv_intro_phase_1)
	OR
	ai_strength (ai_current_actor) < 1
);
thread (xray_fx_play(ai_current_actor));
sleep (30 * 2);
cs_phase_to_point(ps_enc_1_knight_phase.p1);
ai_erase (sq_knight_intro_1);
end

script command_script cs_knight_intro_phase_4()
sleep_until 
(
	volume_test_players (tv_intro_phase_4)
	OR
	ai_strength (ai_current_actor) < 1
);
thread (xray_fx_play(ai_current_actor));
sleep (30 * 2);
cs_phase_to_point(ps_enc_1_knight_phase.p1);
ai_erase (sq_knight_intro_4);
end

script command_script cs_knight_intro_phase_5()
sleep_until 
(
	volume_test_players (tv_intro_phase_5)
	OR
	ai_strength (ai_current_actor) < 1
);
thread (xray_fx_play(ai_current_actor));
sleep (30 * 2);
cs_phase_to_point(ps_enc_1_knight_phase.p1);
ai_erase (sq_knight_intro_5);
end

script command_script knight_intro_anim_1
	
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "Vin_e3_sync_knight_overwhelm_bw1", FALSE);
	sleep (60);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "Vin_e3_sync_knight_overwhelm_ranger1", FALSE);
	sleep (60);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "Vin_e3_sync_knight_overwhelm_ranger2", FALSE);
	sleep (60);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "Vin_e3_sync_knight_overwhelm_ranger3", FALSE);
//	sleep (60);
//	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "Vin_e3_sync_knight_overwhelm_ranger4", FALSE);
end

/////====================///////////
//// ENCOUNTER 2 ////
////=====================/////////

script dormant f_trails_1_enc_2

	sleep_until (volume_test_players (tv_spawn_enc_2), 1);
	
	object_wake_physics (trail_a_dead_4);
	object_wake_physics (trail_a_dead_2);
	object_wake_physics (trail_a_dead_3);
	
	ai_place (sg_enc_2);
	//wake (f_dialog_m60_watchers_callout);
	//print (" :  : Cortana: Watchers! :  :");
	sleep_until (volume_test_players (trig_enc_2_int), 1);
	ai_place_with_shards (sq_enc_2_pawn_2);
	ai_place (sq_enc_2_pawn_snack_1_a);
	ai_place (sq_enc_2_pawn_snack_2_a);
	ai_place (sq_enc_2_pawn_snipe);
	//sleep_until (volume_test_players (trig_trail_vig), 1);
	
	sleep_until (current_zone_set_fully_active() == 15);
	
	ai_place (sq_xray_vig_ma);
	ai_disregard (ai_actors(sq_xray_vig_ma), TRUE);
	
	//First Encounter Music Stop
	thread (f_mus_m60_e01_finish());

	wake (f_t2_ledge);

end

script dormant xray_training
	
sleep_until 
		(unit_has_equipment (player0, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player1, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player2, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player3, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
		);
		
	if
	
		(unit_has_equipment (player0, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)) == TRUE
	
	then
		
		chud_show_screen_training (player0, training_promethean);
		
		player_action_test_reset();
	
		sleep_until (player_action_test_equipment()
		
			OR
			
								volume_test_players (trig_xray_int));
		
		chud_show_screen_training (player0, "");
		
	elseif
		(unit_has_equipment (player1, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)) == TRUE
	then
		chud_show_screen_training (player1, training_promethean);
		
		player_action_test_reset();
	
		sleep_until (player_action_test_equipment()
		
			OR
			
								volume_test_players (trig_xray_int));
		
		chud_show_screen_training (player1, "");
		
	elseif
		(unit_has_equipment (player2, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)) == TRUE
	then
		chud_show_screen_training (player2, training_promethean);
		
		player_action_test_reset();
	
		sleep_until (player_action_test_equipment()
		
			OR
			
								volume_test_players (trig_xray_int));
		
		chud_show_screen_training (player2, "");
		
	elseif
		(unit_has_equipment (player3, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)) == TRUE
	then
		chud_show_screen_training (player3, training_promethean);
		player_action_test_reset();
	
		sleep_until (player_action_test_equipment()
		
			OR
			
								volume_test_players (trig_xray_int));
		
		chud_show_screen_training (player3, "");
	end

end	
		
script dormant f_t2_ledge

	thread (pit_aware());
	
	sleep_until (volume_test_players_lookat (trig_trails_lookat, 35, 35)
							
							or
							
							ai_strength (sq_xray_vig_ma) < 1
						
							or
							
							volume_test_players (trig_trail_vig), 1);
	
	print (":  : PLAYING SHOW CUZ YOU LOOKED AT THE THING :  :");

	object_wake_physics (trail_b_dead_1);
	object_wake_physics (trail_b_dead_2);
	
	ai_place (sg_t2_ledge);
	
	pup_play_show (suicide);
	
	soft_ceiling_enable ("softwall_blocker_trail_c", FALSE);

	sleep (30);
	
	ai_disregard ((ai_actors (sq_xray_vig_kn)), TRUE);
	ai_disregard ((ai_actors (sq_xray_vig_ma)), TRUE);
		
	sleep (30 * 8);
	
	wake (m60_xray_intro);
	
	f_unblip_object (crumb_dogtag_02);
	
	wake (xray_training);
	
	thread (xray_unblip());
	
	wake (f_trailstwo_main);

	sleep_until (volume_test_players (tv_xray_vo_1), 1);
	
	pup_play_show (head_fake);
	
//	pup_play_show (pawn_over);
	
	sleep_until (volume_test_players (tv_fog_6), 1);
	
	ai_place (sq_kn_xr_exit_p);
	
	ai_place_in_limbo (sq_kn_xr_exit_k);
	
	sleep_until (volume_test_players (tv_t2_rockies), 1);
	
	object_wake_physics (dead_marine_2);
	
end

script static void pit_aware()

	print (":  : Shark Pit's Dumb! :  :");

	ai_set_blind (sg_t2_ledge, TRUE);
	ai_set_deaf (sg_t2_ledge, TRUE);
	
	sleep_until (volume_test_players (tv_t2_ledge), 1);
	
	ai_set_deaf (sg_t2_ledge, FALSE);
	
	sleep_until (ai_living_count (sg_t2_ledge) < 10
								OR
							ai_combat_status (sg_t2_ledge) > 1
								OR
							volume_test_players (trig_xray_int));
	
	print (":  : Not dumb! :  :");
	
	ai_set_blind (sg_t2_ledge, FALSE);

end

script static void xray_unblip()

	sleep (30 * 2);
	
	f_blip_object (xray_drop, "navpoint_xray");

	sleep_until 
		(unit_has_equipment (player0, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player1, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player2, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		unit_has_equipment (player3, objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment)
	OR
		volume_test_players (tv_fog_pit)
		);
	
	f_unblip_object (xray_drop);

end
// =================================================================================================
// =================================================================================================
// TRAILS COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

//X-Ray Vignette

script command_script cs_vig_mar
	cs_custom_animation_loop (objects\characters\storm_marine\storm_marine.model_animation_graph, "global_injured:unarmed:gut_lyingdown:var1", true);
	sleep (30 * 10);
end

script command_script cs_vig_fore
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", false);
	cs_melee_direction (0);
end

//Jumping Pawns


