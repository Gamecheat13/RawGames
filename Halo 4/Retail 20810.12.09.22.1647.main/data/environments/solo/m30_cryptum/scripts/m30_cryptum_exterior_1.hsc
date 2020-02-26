//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			exterior1
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short s_objcon_checker = 1;
global boolean rear_fight_spawn = FALSE;
global boolean b_right_side_bishop_born = FALSE;
global boolean b_left_side_bishop_born = FALSE;
global boolean b_endfight_bishop_born = FALSE;
global boolean b_left_side_knight_2_dead = FALSE;



// =================================================================================================
// EXTERIOR 1 SETUP ================================================================================
// =================================================================================================


script dormant m30_cryptum_exterior_1()	
	sleep_until (b_mission_started == TRUE);
	//	Waits until the insertion point trigger has been hit, inside m30_design scenario layer. 
	sleep_until (volume_test_players (tv_insertion_wake_py1_ext), 1); 

	effects_perf_armageddon = 1;

	// Stop the pylon effects from the 1_start zoneset (pyelectric_02) and start the next one (pyelectric_03)
	pup_stop_show(id_for_pylon_pups);
	
	dprint ("Starting puppet pyelectric_03");
	id_for_pylon_pups = pup_play_show(pyelectric_03);
	
	game_save_no_timeout(); 	
	dprint  ("::: Canyons 1 start :::");
	
	wake (knight_firstwave_spawn);
	//wake (ext1_left_mid_spawn_from_right);
	wake (ext1_rear_fight_pawn_spawn);
	wake (ext1_rear_fight_spawn);
	wake (bishop_towers_step1);
	wake (bishop_towers_step3);
	wake (bishop_towers_step4);
	wake (front_knight_pup);
	wake (left_front_knight_pup);
	wake (f_ext1_repeating_gc);
	thread (ext1_hovering_cover_start (ext1_wall_cover));
	thread (ext1_front_cleanup());
	player_set_profile (default_FR);
	dprint ("starting profile changed");
	data_mine_set_mission_segment ("m30_exterior_1");
	
	game_insertion_point_unlock (2);
	dprint ("you unlocked the Exterior 1 Insertion Point!");
	effects_distortion_enabled = FALSE;
	
end

// ====================================================================
// GARBAGE COLLECTION =================================================
// ====================================================================

script dormant f_ext1_repeating_gc()
	sleep_until (volume_test_players (tv_ext1_garbage), 1);
		
		repeat
		
			sleep( 30 * 30 );
			dprint( "Garbage collecting..." );
			add_recycling_volume_by_type (tv_ext1_garbage, 1, 10, 1 + 2 + 1024);
		
		until (not volume_test_players (tv_ext1_garbage), 1);	

end

// ====================================================================
// EXTERIOR 1 =================================================
// ====================================================================

script dormant front_knight_pup
	sleep_until (volume_test_players (tv_ext1_part1), 1);
	thread (f_mus_m30_e03_start());
	pup_play_show ("pup_front_knight");
	
	sleep (30);
	
	wake (ext1_right_mid_spawn);
	
end

script dormant left_front_knight_pup
	sleep_until (volume_test_players (tv_ext1_part2_left), 1);
	
	pup_play_show ("pup_front_left_knight");
	
	sleep (30);
	
	wake (ext1_left_mid_spawn_from_front);
	
	sleep_until (ai_living_count (sq_ext1_knight_2) == 0);
	
	b_left_side_knight_2_dead = TRUE;
	
end

script command_script ambient_bishop1_go
	cs_fly_to (ps_ambient_bishop1.p0);
	cs_fly_to (ps_ambient_bishop1.p1);
	cs_fly_to (ps_ambient_bishop1.p2);
	cs_fly_to (ps_ambient_bishop1.p3);
	cs_fly_to (ps_ambient_bishop1.p4);
	cs_fly_to (ps_ambient_bishop1.p5);
	cs_fly_to (ps_ambient_bishop1.p6);
	ai_erase (ai_current_actor);
end

script command_script ambient_bishop2_go
	cs_pause (1.0);
	cs_fly_to (ps_ambient_bishop2.p0);
	cs_fly_to (ps_ambient_bishop2.p1);
	cs_fly_to (ps_ambient_bishop2.p2);
	cs_fly_to (ps_ambient_bishop2.p3);
	cs_fly_to (ps_ambient_bishop2.p4);
	cs_fly_to (ps_ambient_bishop2.p5);
	cs_fly_to (ps_ambient_bishop2.p6);
	cs_fly_to (ps_ambient_bishop2.p7);
	cs_fly_to (ps_ambient_bishop1.p5);
	cs_fly_to (ps_ambient_bishop1.p6);
	ai_erase (ai_current_actor);
end

script dormant knight_firstwave_spawn
	sleep_until (volume_test_players (tv_canyons1_entry), 1);

	dprint ("Old function, clean up!");

end

script dormant bishop_towers_step1()
	sleep_until (volume_test_players (tv_ext1_combat_start), 1);
	sleep (30);
	ext1_bishop_tower_1->start_animating();
	sleep (4 * 30);
	ext1_bishop_tower_2->start_animating();
	sleep (4 * 30);
	thread (bishop_tower_3());
	sleep (random_range (15, 30));
	thread (bishop_tower_4());

end

script dormant bishop_towers_step3()
	sleep_until (volume_test_players (tv_right_mid_spawn), 1);
	
	ext1_bishop_tower_5->start_animating();
end

script dormant bishop_towers_step4()
	sleep_until (volume_test_players (tv_right_bishoptower), 1);
	
	ext1_bishop_tower_6->start_animating();
end

script static void bishop_tower_3()
	ext1_bishop_tower_3->start_animating();
end

script static void bishop_tower_4()
	ext1_bishop_tower_4->start_animating();
end

script command_script cs_ext1_knight1
	sleep_until (volume_test_players (tv_ext1_combat_start), 1);
	
	cs_phase_to_point (ps_ext1_knightphase.p0);
	
end

script command_script cs_ext1_knight2
	sleep_until (volume_test_players (tv_ext1_combat_start), 1);
	cs_phase_to_point (ps_ext1_knightphase.p1);
	
end

script dormant ext1_left_mid_spawn_from_front()

	dprint ("mid left encounter spawning from front");
	ai_place (sq_ext1_pawns_3_v3);
	ai_place (sq_ext1_pawns_3_v4);
	ai_place (sq_ext1_pawns_3);

	sleep_forever (ext1_left_mid_spawn_from_right);

	//sleep_until (volume_test_players (tv_left_mid_spawn_front), 1);

	ai_place (sq_ext1_pawns_3_v2);
	
end	
	
script dormant ext1_left_mid_spawn_from_right()
	sleep_until (volume_test_players (tv_left_mid_spawn_right), 1);

	dprint ("mid left encounter spawning from right");
	ai_place (sq_ext1_pawns_3);
	ai_place (sq_ext1_pawns_3_v2);
	ai_place (sq_ext1_pawns_3_v5);
	ai_place (sq_ext1_pawns_3_v6);

	sleep_forever (ext1_left_mid_spawn_from_front);
end	
	
script command_script cs_ext1_knight3
	
	cs_phase_to_point (ps_ext1_knightphase.p2);
	
end	

script dormant ext1_right_mid_spawn()
	sleep_until (volume_test_players (tv_right_mid_spawn), 1) or (ai_living_count (sg_right_front) == 0);
	
	ai_place (sq_ext1_bishop_4);
	ai_place (sq_ext1_pawns_4);
	ai_place (sq_ext1_pawns_4v2);
	ai_place (sq_ext1_bishop_4v2);
	//ai_place (sq_ext1_pawns_4v3);
	sleep (5);
	ai_place (sq_ext1_knight_4);

end

script command_script cs_bishop_spawn_ext1_right()
	print("gh bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_ext1_right, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_ext1_right()

	b_right_side_bishop_born = TRUE;

end

script command_script cs_ext1_knight4
	
	cs_phase_to_point (ps_ext1_knightphase.p3);
	
end

script dormant ext1_rear_fight_pawn_spawn()

	sleep_until (volume_test_players (tv_ext1_rear_pawns) or (volume_test_players (tv_left_mid_spawn_front)), 1);
	dprint ("rear pawns incoming!");
	game_save_no_timeout();
	ai_place (sq_ext1_wall_pawns_1);
	//ai_place (sq_ext1_wall_pawns_2);

	sleep_until (volume_test_players (tv_ext1_rear_pawns), 1);

	ai_place (sq_ext1_pawns_5);
	ai_place (sq_ext1_pawns_6);
	ai_place (sq_ext1_pawns_7);
	ai_place (sq_ext1_pawns_8);


end

script dormant ext1_rear_fight_spawn()
	sleep_until (volume_test_players (tv_ext1_end), 1);
	dprint ("rear battlewagon incoming!");
	//ai_place (sq_ext1_turret_bishop);
	ai_place (sq_ext1_bishop_5);
	//ai_place (sq_ext1_turret_1);
	ai_place (sq_ext1_knight_5);


	//wake (ext1_rear_battlewagon_backup);

	sleep_until (rear_fight_spawn == TRUE);
	
	wake (m30_pylonone_hallwaytwo_enter);
	
	thread (f_door_hallway_2_in_open());
	thread (f_door_hallway_2_out_open());
	wake (m30_ext1_final_fight_check);
	wake (ext1_rear_fight_over);
	
	sleep (30);
	
	ai_allow_resurrect(sq_ext1_knight_5, FALSE);

	
	//RequestAutomatedTurretActivation (ai_vehicle_get (sq_ext1_turret_1.spawn_points_0));
	//dprint ("turret requesting activation");
	
end

script static void ext1_front_cleanup()

	sleep_until (volume_test_players (tv_ext1_rear_pawns), 1);

		dprint ("attempting to clean up ext1, front side");
		f_ai_garbage_erase (sq_ext1_knight_1, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_knight_2, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_knight_3, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_bishop_3, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_3, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_3_v2, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_3_v3, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_3_v4, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_knight_4, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_bishop_4, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_4, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_4v2, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_pawns_4v3, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_bishop_4v2, 1, -1, -1, -1, TRUE);
		f_ai_garbage_erase (sq_ext1_right_knight_1, 1, -1, -1, -1, TRUE);
		
end

script dormant rear_encounter_test
	dprint ("rear encounter ready for testing");
	wake (ext1_rear_fight_pawn_spawn);
	wake (ext1_rear_fight_spawn);
end

script dormant ext1_rear_battlewagon_backup
	sleep_until (rear_fight_spawn == TRUE);
	
	dprint ("battlewagon reinforcements are waiting to arrive");
	sleep (1);
	
	sleep_until (volume_test_players (tv_ext1_pawn_frenzy) or (ai_living_count (sq_ext1_bishop_5) == 0) or (ai_living_count (sq_ext1_turret_1) == 0), 1);
	
	dprint ("battlewagon reinforcements incoming!");
	
	sleep (45);
	
	ai_place (sq_ext1_knight_6);
	
end

script static boolean is_rear_fight_depleted()
	(ai_living_count (sq_ext1_bishop_5) == 0 and ai_living_count (sq_ext1_turret_1) == 0);
end

script command_script cs_bishop_spawn_ext1_rearfight()
	print("gh bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_ext1_rearfight, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_ext1_rearfight()
	b_endfight_bishop_born = TRUE;
	rear_fight_spawn = TRUE;	
end

script command_script cs_ext1_knight5
	sleep_until (rear_fight_spawn == TRUE);
	cs_phase_to_point (ps_ext1_knightphase.p4);
	
end	

script command_script cs_ext1_knight6
	sleep_until (rear_fight_spawn == TRUE);
	cs_pause (1.0);
	cs_phase_to_point (ps_ext1_knightphase.p5);
	
end	

script dormant ext1_rear_fight_over
	sleep_until (volume_test_players (tv_ext1_music_end) or (b_ext1_final_fight_over  == TRUE), 1);
	
	thread (f_mus_m30_e03_finish());
	
	// turn effects back on, the fight is over
	effects_perf_armageddon = 0;

	game_save();
	
end

script static void ext1_hovering_cover_start (object_name shieldwall)
	repeat
    object_move_by_offset(shieldwall, 3, 0.0, 0.0, -0.03);
    sleep (20);
    object_move_by_offset(shieldwall, 3, 0.0, 0.0, 0.03);
  until(1 == 0);
end


