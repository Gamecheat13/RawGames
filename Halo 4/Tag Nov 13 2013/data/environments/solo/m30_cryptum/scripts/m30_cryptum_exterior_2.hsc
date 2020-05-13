//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			exterior2
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short loop_check = 0;
global short obj_check = 0;
global short rear_obj_check = 0;

// =================================================================================================
// =================================================================================================
// *** EXTERIOR 2 ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_exterior_2()	
	sleep_until (volume_test_players (tv_insertion_wake_exterior2), 1);
	dprint  ("::: ext 2 start :::");
	wake (f_canyon_2_setup);
	wake (f_drop_pods);
	wake (f_phantom_flyby);
	wake (f_ramp_forerunners);
	wake (ramp_check);
	wake (ramp_check_2);
	wake (overhead_fleet);

	wake (f_canyon_part_2);
	wake (M30_plylontwo_arrival); //narrative scripts
	wake (M30_canyons_ramp_enter); //narrative scripts
	wake (M30_start_ramp_enter); //narrative scripts
	wake (M30_pylontwo_hallway_1_enter); //narrative scripts
	wake (f_ext2_repeating_gc);

	// Controls setting the right effects state on the cryptum shield
	wake (cryptshield_2_start_to_2_canyon);
	wake (cryptshield_2_canyon);
	wake (cryptshield_2_elevator);
	wake (cryptshield_2_pylon);
	wake (cryptshield_obsdeck3);
	wake (cryptshieldstate);
	
	data_mine_set_mission_segment ("m30_exterior_2");
	
	effects_distortion_enabled = FALSE;
	
	game_insertion_point_unlock (5);
	dprint ("you unlocked the Exterior 2 Insertion Point!");
	
	zone_set_trigger_volume_enable ("zone_set:2_elevator:*", FALSE);
	
end

// ====================================================================
// PLAYFIGHTING STUFF =================================================
// ====================================================================

script command_script ext2_playfighting
	unit_only_takes_damage_from_players_team (ai_current_actor, TRUE);
end

// ====================================================================
// GARBAGE COLLECTION =================================================
// ====================================================================

script dormant f_ext2_repeating_gc()
	sleep_until (volume_test_players (tv_ext2_garbage), 1);
		
		repeat
		
			sleep( 30 * 30 );
			dprint( "Garbage collecting..." );
			add_recycling_volume_by_type (tv_ext2_garbage, 1, 10, 1 + 2 + 1024);
		
		until (not volume_test_players (tv_ext2_garbage), 1);	

end

// ====================================================================
// EXTERIOR 2 STUFF ===================================================
// ====================================================================

script dormant cryptshield_2_start_to_2_canyon()
	sleep_until (volume_test_players ("begin_zone_set:2_start_to_2_canyon"), 1);
	dprint("cryptshield_2_start_to_2_canyon_1");
	thread(set_cryptum_shield_stage(3, 2, FALSE));
	sleep_until (volume_test_players ("zone_set:2_start_to_2_canyon"), 1);
	dprint("cryptshield_2_start_to_2_canyon_2");
	thread(set_cryptum_shield_stage(3, 2, TRUE));
end

script dormant cryptshield_2_canyon()
	sleep_until (volume_test_players ("begin_zone_set:2_canyon"), 1);
	dprint("cryptshield_2_canyon_1");
	thread(set_cryptum_shield_stage(3, 2, FALSE));
	sleep_until (volume_test_players ("zone_set:2_canyon"), 1);
	dprint("cryptshield_2_canyon_2");
	thread(set_cryptum_shield_stage(3, 2, TRUE));
end

script dormant cryptshield_2_elevator()
	sleep_until (volume_test_players ("zone_set:2_elevator:*"), 1);
	dprint("cryptshield_2_elevator");
	thread(set_cryptum_shield_stage(3, 2, TRUE));
end

script dormant cryptshield_2_pylon()
	sleep_until (volume_test_players ("zone_set:2_pylon"), 1);
	dprint("cryptshield_2_pylon");
	thread(set_cryptum_shield_stage(3, 2, TRUE));
end

script dormant cryptshield_obsdeck3()
	sleep_until (volume_test_players ("begin_zone_set:3_donut"), 1);
	dprint("cryptshield_obsdeck3");
	thread(set_cryptum_shield_stage(1, 3, FALSE));
end

// Controls setting the right effects state on the cryptum shield bsp markers
script dormant cryptshieldstate()
	sleep_until (volume_test_players (tv_fx_cryptshield22), 1);
	dprint("cryptshieldstate");
	thread(set_cryptum_shield_stage(3, 2, FALSE));
end

script dormant ramp_check()
	sleep_until (volume_test_players (tv_ramp_check), 1);
	obj_check == 5;
	ai_place (sq_ext2_vignette_elite_1);
	print ("obj_check = 5");
	game_save_no_timeout();
end

script command_script elite_cs_test
	cs_shoot (TRUE);
end

script dormant ramp_check_2()
	sleep_until (volume_test_players (tv_ramp_check_2), 1);
	obj_check == 10;
	print ("obj_check = 10");
		
end

script dormant f_midfightsave2()
	//trying to save if players are under the overhang and are safe
	sleep_until (volume_test_players (tv_midfight_save), 1);
	game_save_no_timeout();
end

script dormant f_midfightsave3()
	//trying to save once the lower bowl is weakened sufficiently
	sleep_until (ai_living_count (sg_ramp) <= 2 and (ai_living_count (sg_canyon_cov_1) <= 2), 1);
	game_save_no_timeout();
end

script dormant f_phantom_flyby()
	sleep_until (volume_test_players (tv_phantom_flyby), 1);
	ai_place (sq_phantom_1);
	game_save_no_timeout ();
	sleep (30);
	ai_place (sq_phantom_2);
end

script dormant f_canyon_2_setup()
	sleep_until (volume_test_players (tv_canyon_turrets), 1);

	ai_place (sq_knight_1);
	unit_only_takes_damage_from_players_team (sq_knight_1, TRUE);
	ai_place (sq_bishop_1);
	unit_only_takes_damage_from_players_team (sq_bishop_1, TRUE);
	ai_place (sq_pawns_1);
	//unit_only_takes_damage_from_players_team (sq_pawns_1, TRUE);
	sleep (30 * 3);
end

script command_script cs_phantom_1()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 60);
	cs_fly_to (ps_phantom_1.p0);
	cs_fly_to_and_face (ps_phantom_1.p1, ps_phantom_1.p2);
	cs_fly_to (ps_phantom_1.p2);
	cs_fly_to (ps_phantom_1.p3);
	cs_fly_to (ps_phantom_1.p4);
	cs_fly_to (ps_phantom_1.p5);
	ai_erase (sq_phantom_1);
end

script command_script cs_phantom_2()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 60);
	cs_fly_to (ps_phantom_2.p0);
	cs_fly_to (ps_phantom_2.p1);
	cs_fly_to (ps_phantom_2.p2);
	cs_fly_to (ps_phantom_2.p3);
	ai_erase (sq_phantom_2);
end

script dormant f_drop_pods()
	sleep_until (volume_test_players (tv_spawn_1), 1);
	
	thread (f_mus_m30_e05_start());
	
	ai_place (sq_fore_pawn_attack);
	ai_place (sq_fore_pawn_attack_2);
	
	//first drop pod incoming
	
	thread(new_drop_pod_1->drop_to_point(sq_cov_canyon_5, ps_drop_pod_1.p1, .65, 0));

	wake (M30_plyontwo_drop_pods);
	object_hide (fake_drop_pod, FALSE);
	unit_open (fake_drop_pod);
	
	ai_place (sq_fore_knight_3);
	unit_only_takes_damage_from_players_team (sq_fore_knight_3.p0, TRUE);
	sleep (20);
	ai_place (sq_fore_knight_4);
	unit_only_takes_damage_from_players_team (sq_fore_knight_4.p0, TRUE);
	
	//second drop pod incoming

	thread(new_drop_pod_2->drop_to_point(sq_cov_canyon_4, ps_drop_pod_1.p0, .65, 0));
		
	//third drop pod incoming
	
	thread(new_drop_pod_3->drop_to_point(sq_cov_canyon_6, ps_drop_pod_1.p2, .65, 0));	

	wake (e2_ramp_phase1);
	wake (e2_ramp_phase2);
	
end

script command_script e2_knight_phase1()
	cs_phase_to_point (ps_canyon2_knights.p0);
end

script command_script e2_knight_phase2()
	cs_phase_to_point (ps_canyon2_knights.p1);
end

script dormant e2_ramp_phase1()
	sleep_until ((ai_living_count (sg_cov_canyon2_part1) <= 1) or (volume_test_players (tv_ramp_check)), 1);
	dprint ("fore_knight_3 retreat!");
	cs_run_command_script (sq_fore_knight_3, e2_knight_phase3);
end

script dormant e2_ramp_phase2()
	sleep_until ((ai_living_count (sg_cov_canyon2_part1) <= 1) or (volume_test_players (tv_ramp_check)), 1);
	dprint ("fore_knight_4 retreat!");
	cs_run_command_script (sq_fore_knight_4, e2_knight_phase4);
end


script command_script e2_knight_phase3()
	cs_phase_to_point (ps_canyon2_knights.p4);
	ai_erase (sq_fore_knight_3);
end

script command_script e2_knight_phase4()
	cs_phase_to_point (ps_canyon2_knights.p4);
	ai_erase (sq_fore_knight_4);
end

script static void drop_pod_1_landing()
	effect_new_at_ai_point (objects\props\covenant\cov_squad_drop_pod\fx\dp_squad_impact.effect, ps_drop_pod_1.p0);
	ai_place (sq_cov_canyon_4);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.60, exterior_2_camera_shake);
end

script static void drop_pod_2_landing()
	effect_new_at_ai_point (objects\props\covenant\cov_squad_drop_pod\fx\dp_squad_impact.effect, ps_drop_pod_1.p1);
	ai_place (sq_cov_canyon_5);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.60, exterior_2_camera_shake);
end

script static void drop_pod_3_landing()
	effect_new_at_ai_point (objects\props\covenant\cov_squad_drop_pod\fx\dp_squad_impact.effect, ps_drop_pod_1.p2);
	ai_place (sq_cov_canyon_6);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.60, exterior_2_camera_shake);
end

script dormant f_ramp_forerunners()
	sleep_until (volume_test_players (tv_ramp_spawn), 1);

	pup_play_show ("knight_elite");
	wake (ghost_moment);
	sleep (30);
	
	thread (ghost_boost_help (player0));
	thread (ghost_boost_help (player1));
	thread (ghost_boost_help (player2));
	thread (ghost_boost_help (player3));
		
	ai_place (sq_bishop_2);
	
	sleep (90);
	
	ai_place_with_shards(sq_turret_1); 
	
	sleep (5);
		
end

script command_script knight_jump()
	cs_abort_on_damage (TRUE);
	cs_move_towards_point (ps_knight_jump.p0, 0.1);
end


script dormant ghost_moment()
	sleep_until (volume_test_players (tv_ghost_spawn), 1);
	thread (f_mus_m30_e05_finish());
	game_save_no_timeout();
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_phantom_fires.p0);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_small.effect, ps_crashed_phantom_fires.p1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_phantom_fires.p2);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_small.effect, ps_crashed_phantom_fires.p3);

	pup_play_show(ggggghosts);
	player_set_profile (default_BOTH);
	dprint ("palyer profiles set to both COV and FR weapons");
	thread (f_mus_m30_e06_start());
	
	//sleep (30 * 3);
	
	thread (ext2_area1_cleanup());
	
end

script static void ext2_area1_cleanup()
	dprint ("attempting to clean up ext2, area1");
	f_ai_garbage_erase (sq_bishop_1, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_knight_1, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_pawns_1, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_fore_pawn_attack, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_cov_canyon_4, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_cov_canyon_5, 3, -1, -1, -1, TRUE);
	f_ai_garbage_erase (sq_cov_canyon_6, 3, -1, -1, -1, TRUE);
end

script static void ghost_boost_help (player p_player)
	sleep_until (unit_in_vehicle_type (p_player, 26));
	sleep (15);
	chud_show_screen_training (p_player, "training_ghostboost");
	sleep (30 * 6);
	chud_show_screen_training (p_player, "");
end

script dormant f_canyon_part_2()
	sleep_until (volume_test_players (tv_spawn_2), 1);

	thread (canyon2_forerunners());
	//thread (drop_pod_4_landing());
	
	thread(new_drop_pod_4->drop_to_point(sq_cov_canyon_8, ps_drop_pod_1.p4, .65, 0));
	
	sleep (15);
	//thread (drop_pod_5_landing());
	
	thread(new_drop_pod_5->drop_to_point(sq_cov_canyon_7, ps_drop_pod_1.p3, .65, 0));
	
	sleep (15);
	//thread (drop_pod_6_landing());
	
	thread(new_drop_pod_6->drop_to_point(sq_cov_canyon_9, ps_drop_pod_1.p5, .65, 0));
	
	sleep (15);
	//thread (drop_pod_7_landing());
	
	thread(new_drop_pod_7->drop_to_point(sq_cov_canyon_10, ps_drop_pod_1.p6, .65, 0));
	
	sleep (15);
	//thread (drop_pod_8_landing());
	
	thread(new_drop_pod_8->dead_drop_to_point(ps_drop_pod_1.p7, .65, 0));
	
	wake (tunnel_spawns);
	
	unit_open (new_drop_pod_8);
	
	if game_difficulty_get_real() == "legendary" then		
		wake (ext2_rear_spawn_go);
	else	
		sleep (1);
	end
	
end

script static void canyon2_forerunners()
	ai_place (sq_fore_squad_1);
//	ai_place (sq_fore_squad_2);
	ai_place (sq_fore_squad_3);
end

script static void drop_pod_4_landing()
	object_create (drop_pod_4);
	object_set_scale (drop_pod_4, 0.01, 0);
	object_set_scale (drop_pod_4, 1.0, 15);
	object_move_to_point (drop_pod_4, 0.75, ps_drop_pod_1.p3);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_drop_pod_1.p3);
	ai_place (sq_cov_canyon_7);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.75, exterior_2_camera_shake);
end

script static void drop_pod_5_landing()
	object_create (drop_pod_5);
	object_set_scale (drop_pod_5, 0.01, 0);
	object_set_scale (drop_pod_5, 1.0, 15);
	object_move_to_point (drop_pod_5, 0.75, ps_drop_pod_1.p4);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_drop_pod_1.p4);
	ai_place (sq_cov_canyon_8);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.75, exterior_2_camera_shake);
end

script static void drop_pod_6_landing()
	object_create (drop_pod_6);
	object_set_scale (drop_pod_6, 0.01, 0);
	object_set_scale (drop_pod_6, 1.0, 15);
	object_move_to_point (drop_pod_6, 0.75, ps_drop_pod_1.p5);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_drop_pod_1.p5);
	ai_place (sq_cov_canyon_9);
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.75, exterior_2_camera_shake);
end

script static void drop_pod_7_landing()
	object_create (drop_pod_7);
	object_set_scale (drop_pod_7, 0.01, 0);
	object_set_scale (drop_pod_7, 1.0, 15);
	object_move_to_point (drop_pod_7, 0.75, ps_drop_pod_1.p6);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_drop_pod_1.p6);
	ai_place (sq_cov_canyon_10);	
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.75, exterior_2_camera_shake);
end

script static void drop_pod_8_landing()
	object_create (drop_pod_8);
	object_set_scale (drop_pod_8, 0.01, 0);
	object_set_scale (drop_pod_8, 1.0, 15);
	object_move_to_point (drop_pod_8, 0.75, ps_drop_pod_1.p7);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_drop_pod_1.p7);	
	camera_shake_all_coop_players (0.65, 0.45, 1, 0.75, exterior_2_camera_shake);
end

script dormant tunnel_spawns()
	sleep_until (volume_test_players (tv_tunnel_advance), 1);
	
	dprint ("changing ai combat preferences in the lower bowl");
	
	ai_prefer_target_team (sq_fore_squad_1, covenant);
	ai_prefer_target_team (sq_fore_squad_2, covenant);
	ai_prefer_target_team (sq_fore_squad_3, covenant);
	
	ai_prefer_target_team (sq_cov_canyon_7, forerunner);
	ai_prefer_target_team (sq_cov_canyon_8, forerunner);
	ai_prefer_target_team (sq_cov_canyon_9, forerunner);
	ai_prefer_target_team (sq_cov_canyon_10, forerunner);
	
	thread (f_door_hallway_3_in_open());
	thread (f_door_hallway_3_out_open());
	wake (tunnel_spawns_2);
	
	game_save_no_timeout();
end

script dormant tunnel_spawns_2()
	sleep_until (volume_test_players (tv_tunnel_advance_2), 1);
	ai_place (sq_fore_squad_5);
	ai_place (sq_cov_canyon_11);

end

script dormant overhead_fleet()
	sleep_until (volume_test_players (tv_canyon_turrets), 1);
	
	pup_play_show ("pup_cruiser_flyby");
end

script static void cruiser_1_move()
	object_set_scale (cruiser_1, 0.01, 0);
	object_set_scale (cruiser_1, 0.20, 60);
	object_move_to_point (cruiser_1, 10, ps_fleet.p0);
	object_set_scale (cruiser_1, 0.01, 720);
	sleep (1120);
	object_destroy (cruiser_1);
end
	
script dormant ext2_rear_spawn_go()
	sleep_until (volume_test_players (tv_ext2_rear_spawn), 1);
	
	rear_obj_check = 5;
	
	thread (ext2_rear_bw_spawn());

end

script static void ext2_rear_bw_spawn()
	repeat
		sleep_until (volume_test_players (tv_ext2_rear_spawn2), 1);
	
		sleep (30 * 5);
		
		if
			volume_test_players (tv_ext2_rear_spawn2)
		then
			
			sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
			ai_place (sq_fore_battlewagon_5);
			sleep (30);
			wake (ext2_rear_spawn_cleanup);
			
		end
	
	until (ai_living_count (sq_fore_battlewagon_5) > 0 or volume_test_players (tv_ext2_garbage), 1);

end

script dormant ext2_rear_spawn_cleanup()

	sleep_until (ai_living_count (sq_fore_battlewagon_5) == 0);
	
	sleep (30);
	
	sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
	
	sleep_until (volume_test_players (tv_ghost_spawn), 1);
	
	object_create (old_delete_1);
	object_create (old_delete_2);
	object_create (old_delete_3);
	object_create (old_delete_4);
	object_create (old_delete_5);
	object_create (old_delete_6);
	object_create (old_delete_7);
	object_create (old_delete_8);
	object_create (old_delete_9);
	
end