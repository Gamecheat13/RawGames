// =================================================================================================
// =================================================================================================
// EPIC
// =================================================================================================
// =================================================================================================

global boolean b_player_in_vehicle_right = false;
global boolean b_portal_up = false;
global boolean b_player_in_vehicle_left = false;
global boolean epic_tank_ai_timeout = false;
global object g_player_left = NONE;
global object g_player_right = NONE;
global object p_tractor_target_player = NONE;

global short s_asteroid_hit = 0;
//global var the_player  = NONE; 


script dormant epic_obj_control()
	sleep_until (volume_test_players (tv_epic_01)	
	or
	volume_test_players (tv_epic_01a)
	, 1);
	epic_obj_state = 10;
	
	sleep_until (volume_test_players (tv_epic_01)	
	, 1);
	epic_obj_state = 12;	
	
	game_save_no_timeout();	
	
	
	sleep_until (volume_test_players (tv_epic_015)
	or
	volume_test_players (tv_epic_02)
	, 1);
	epic_obj_state = 15;
	
	
	sleep_until (volume_test_players (tv_epic_02)
	or
	volume_test_players (tv_epic_02a)
	, 1);
	epic_obj_state = 20;
	
	
	sleep_until (volume_test_players (tv_epic_03), 1);
	epic_obj_state = 30;
	game_save_no_timeout();
	
	
	sleep_until (volume_test_players (tv_epic_04)
	or
	volume_test_players (tv_epic_04b)
	, 1);
	epic_obj_state = 40;
	game_save_no_timeout();
	
	
	sleep_until (volume_test_players (tv_epic_05), 1);
	epic_obj_state = 50;
	game_save_no_timeout();
	
	
	sleep_until (volume_test_players (tv_epic_06), 1);
	epic_obj_state = 60;
	

	sleep_until (volume_test_players (tv_epic_07), 1);
	epic_obj_state = 70;
	
	
end

script dormant epic_main_script()

	sleep_until (current_zone_set_fully_active() == DEF_S_ZONESET_EPIC());

	effects_perf_armageddon = 1;

	sleep (5);

	zone_set_trigger_volume_enable("begin_zone_set:zone_set_epic_exit", FALSE);

	thread (fx_epic_skybox_lensflares());
	thread(f_mus_m40_e09_begin());
//	object_create_folder(epic_crates);
	object_create(epic_scorpion_01);
	thread (f_check_vehicle_left());
	thread (f_check_vehicle_right());
	wake (epic_vehicle_script);
	wake (epic_infantry_script);
	thread (stacker_dialogue());
	wake (flocking_flak_fx_5);
	
	thread (infinity_epic_entrance());
	//thread (tractor_swirling_rock_anims_01());
	//thread (tractor_swirling_rock_anims_02());
	effect_attached_to_camera_new (environments\solo\m40_invasion\fx\dust\particulates.effect);
	object_destroy (cannon_chopper);
	
	//fade_in (255,255,255, 60);
	ai_place (epic_ghost_front_right_sq);
	ai_place (epic_wraith_mid_guard_sq);
	ai_place (epic_wraith_mid_left);
	ai_place (epic_marines_tank_01);
	ai_place (epic_marines_tank_02);	
	
	sleep (1);

//	object_teleport(epic_tower_pod_01, fg_tp_top_epic);
	ai_place (epic_marines_convoy);
	ai_place (epic_ghost_front_right_02_sq);
	ai_place (epic_phantom_mid_guard_sq);
	ai_place (epic_wraith_rear_sq);
	sleep (5);
//	effect_new (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base );
	object_create_folder (epic_crates);
	sleep (5);
//	object_create_folder (epic_bubbles);	

	object_create (epic_bubble_2);	
	object_create (epic_bubble_module_2);	
	object_create (epic_bubble_1);	
	object_create (epic_bubble_module_1);	
	object_create (epic_shield_barrier);	
		
	effects_distortion_enabled = false;
	sleep (1);
	object_set_function_variable (epic_shield_barrier, shield_on, 1, 1);	
	object_set_function_variable (epic_shield_barrier, shield_color, 0, 0);
	
//	thread( f_insertion_zoneload(DEF_S_ZONESET_EPIC(), true) );

	ai_object_set_team (epic_bubble_module_1, covenant);
	ai_object_set_team (epic_bubble_module_2, covenant);

	ai_object_enable_targeting_from_vehicle (epic_bubble_module_1, true);
	ai_object_enable_targeting_from_vehicle (epic_bubble_module_1, true);

	data_mine_set_mission_segment ("m40_epic");
	
	garbage_collecting = true;
	thread (garbage_collect_me());
	
	thread (f_epic_blip_timer());

 	game_save_no_timeout();

 	
//	sleep_until (epic_obj_state > 29
//	and
//	ai_living_count (epic_phantom_01_sq) < 2
//	and
//	ai_living_count (epic_mortardom_vehicles) < 2
//	and
//	ai_living_count (epic_hill_infantry) < 3
//	);

	sleep(5);

	wake (epic_bubble_control);

	sleep_s(1);
	
	//f_chapter_title_2 (leadin_title_ord);
	thread(f_chapter_title(leadin_title_ord));
	
	sleep_until (epic_bubbles_burst == 2
	or
	volume_test_players (tv_epic_td_area)
	);
	
	
  thread(f_mus_m40_e09_finish());	
  
// 	wake (m40_target_gravity_well);
//	cinematic_set_title (epic_end_direction);
	wake (missile_prototype);
	
	f_blip_flag (epic_end_flag, "default");
	
	sleep_until (epic_obj_state > 49);
	
	f_unblip_flag (epic_end_flag);
	
	f_blip_object(target_laser, "default");
end

script dormant epic_vehicle_script()
	thread (epic_ghost_backup_01_sq_spawn());
	thread (epic_ghost_backup_03_sq_spawn());
	thread (epic_ghost_backup_04_sq_spawn());
	thread (epic_ghost_backup_07_sq_spawn());
	thread (epic_wraiths_rear_spawn());
	thread (epic_kill_front_row());
end

script static void stacker_dialogue()
	thread (stacker_initial());
	thread (stacker_first_line_clear());
	thread (stacker_first_line_tarry());
	thread (stacker_second_line_clear());
	thread (stacker_all_clear());
end

script static void stacker_initial()
	sleep_s (2);
	wake (f_dialog_m40_stacker_01);

	//Sgt. Stacker : I'm reading Sierra One One Seven on-sensor.
	//Sgt. Stacker : Everyone form up on the Chief!
end

script static void stacker_first_line_tarry()
	sleep_s (5);
//	wake (f_dialog_m40_stacker_02);

	//not sure if this is needed - jacob

	//Sgt. Stacker : Clear this area. Push up the hill, marines!	
	//Sgt. Stacker : You WILL prosecute these Covenant with extreme prejudice, soldier!
end

script static void stacker_first_line_clear()
	sleep_until (epic_obj_state < 12
	and
	ai_living_count (epic_ghost_front_right_02_sq) < 1
	and
	ai_living_count (epic_ghost_front_right_sq) < 1	
	and
	ai_living_count (epic_wraith_mid_left) < 1	
	and
	ai_living_count (epic_ghost_backup_01_sq) < 1	
	);
	sleep_s (1);	
	wake (f_dialog_m40_stacker_03);

	//Sgt. Stacker : First line clear, check it off. Push forward!
	//Sgt. Stacker : All eyes on the Chief, he's lead dog!
end

script static void stacker_second_line_clear()
	sleep_until (epic_obj_state < 20
	and
	ai_living_count (epic_wraith_mid_guard_sq) < 1
	and
	ai_living_count (epic_ghost_backup_03_sq) < 1	
	and
	ai_living_count (epic_wraith_rear_sq) < 1	
	and
	ai_living_count (epic_ghost_backup_04_sq) < 1	
	);
	sleep_s (1);	
	wake (f_dialog_m40_stacker_04);

	//Sgt. Stacker : Second line clear, this ain't a picnic. Let's move up!"
end

script static void stacker_all_clear()
	sleep_s (1);
	sleep_until(epic_obj_state < 50
	and	
	epic_bubbles_burst == 2
	and
	ai_living_count (epic_hill_infantry) < 1
	and
	ai_living_count (epic_wraith_backup_04_sq) < 1	
	and
	ai_living_count (epic_wraith_backup_05_sq) < 1	
	and
	ai_living_count (epic_wraith_backup_06_sq) < 1	
	and
	ai_living_count (epic_wraith_backup_07_sq) < 1	
	and
	ai_living_count (epic_wraith_backup_08_sq) < 1	
	and
	ai_living_count (epic_wraith_backup_09_sq) < 1	
	);
	//wake (f_dialog_m40_stacker_05);

	//Sgt. Stacker : All right, that's the last of 'em. No dessert, huh? Nothing left? Well done, marines.
	//Sgt. Stacker : Chief, we'll cover you from here.
end

script dormant epic_infantry_script()
	ai_place (epic_tower_left_01_sq);
	
	sleep_until (epic_obj_state > 9);
	
	ai_place (epic_mid_01_sq);
	thread (epic_mid_02_sq_spawn());
//	thread (epic_mid_03_sq_spawn());
	thread (epic_rear_01_sq_spawn());
	
	sleep_until (epic_obj_state > 29
	and
	ai_living_count (epic_mortardom_vehicles) < 2
	);
	
	ai_place (epic_phantom_01_sq);
end

script static void epic_ghost_backup_01_sq_spawn()
	sleep_until (ai_living_count (epic_small_vehicles) < 3
	and
	not (volume_test_players_lookat (tv_epic_ghost_backup_01_sq_spawn, 3000, 40)));
	ai_place (epic_ghost_backup_01_sq);
end

script static void epic_ghost_backup_03_sq_spawn()
	sleep_until (ai_living_count (epic_small_vehicles) < 2
	and
	epic_obj_state > 9
	and
	not (volume_test_players_lookat (tv_epic_mid_02_sq_spawn, 3000, 40)));
	ai_place (epic_ghost_backup_03_sq);	
end

script static void epic_ghost_backup_04_sq_spawn()
	sleep_until (ai_living_count (epic_small_vehicles) < 2
	and
	epic_obj_state > 9
	and
	not (volume_test_players_lookat (tv_epic_mid_02_sq_spawn, 3000, 40)));
	ai_place (epic_ghost_backup_04_sq);	
end

script static void epic_kill_front_row()
	sleep_until (epic_obj_state > 19);
	thread (epic_ghost_front_right_02_sq_kills_1());
	thread (epic_ghost_front_right_02_sq_kills_2());
	thread (epic_ghost_front_right_sq_kills_1());
	thread (epic_ghost_front_right_sq_kills_2());
	thread (epic_ghost_backup_01_sq_kills());
	thread (epic_ghost_backup_01b_sq_kills());
end

script static void epic_ghost_front_right_02_sq_kills_1()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_front_right_02_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_front_right_02_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_front_right_02_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_front_right_02_sq.spawn_points_1, 60))
	, 1);
	ai_kill (epic_ghost_front_right_02_sq.spawn_points_1);
end

script static void epic_ghost_front_right_02_sq_kills_2()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_front_right_02_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_front_right_02_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_front_right_02_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_front_right_02_sq.spawn_points_0, 60))
	, 1);
	ai_kill (epic_ghost_front_right_02_sq.spawn_points_0);
end

script static void epic_ghost_front_right_sq_kills_1()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_front_right_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_front_right_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_front_right_sq.spawn_points_0, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_front_right_sq.spawn_points_0, 60))
	, 1);
	ai_kill (epic_ghost_front_right_sq.spawn_points_0);
end

script static void epic_ghost_front_right_sq_kills_2()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_front_right_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_front_right_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_front_right_sq.spawn_points_1, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_front_right_sq.spawn_points_1, 60))
	, 1);
	ai_kill (epic_ghost_front_right_sq.spawn_points_1);
end

script static void epic_ghost_backup_01_sq_kills()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_backup_01_sq.driver, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_backup_01_sq.driver, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_backup_01_sq.driver, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_backup_01_sq.driver, 60))
	, 1);
	ai_kill (epic_ghost_backup_01_sq.driver);
end

script static void epic_ghost_backup_01b_sq_kills()
	sleep_until (not (objects_can_see_object (player0, epic_ghost_backup_01_sq.driver2, 60))
	and
	not (objects_can_see_object (player1, epic_ghost_backup_01_sq.driver2, 60))
	and
	not (objects_can_see_object (player2, epic_ghost_backup_01_sq.driver2, 60))
	and
	not (objects_can_see_object (player3, epic_ghost_backup_01_sq.driver2, 60))
	, 1);
	ai_kill (epic_ghost_backup_01_sq.driver2);
end

script static void epic_ghost_backup_07_sq_spawn()
	sleep_until (epic_obj_state > 19);
	sleep (30 * 3);
	ai_place (epic_ghost_backup_07a_sq);
//	sleep (30 * 3);
//	ai_place (epic_ghost_backup_07b_sq);		
 end
 
script static void tv_epic_tower_left_kills_sc()
	sleep_until (not (volume_test_players_lookat (tv_epic_tower_left_kills, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_epic_tower_left_kills));
	print ("tv_epic_tower_left_kills_sc");
end
 
script static void tv_epic_mid_inf_kills_sc()
	sleep_until (not (volume_test_players_lookat (tv_epic_mid_inf_kills, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_epic_mid_inf_kills));
	print ("tv_epic_mid_inf_kills");
end

script static void epic_wraiths_rear_spawn()
	sleep_until (
	(ai_living_count (epic_small_vehicles) < 4
	and
	epic_obj_state > 14
	and
	not (volume_test_players_lookat (tv_epic_mid_03_sq_spawn, 3000, 40))
	and
	not (volume_test_players_lookat (tv_epic_wraith_backup_04_sq_spawn, 3000, 40)))
	or
	(ai_living_count (epic_small_vehicles) < 5
	and
	epic_obj_state > 20
	and
	not (volume_test_players_lookat (tv_epic_mid_03_sq_spawn, 3000, 40))
	and
	not (volume_test_players_lookat (tv_epic_wraith_backup_04_sq_spawn, 3000, 40)))
	);
	
	thread (tv_epic_tower_left_kills_sc());
	thread (tv_epic_mid_inf_kills_sc());	
	
	//ai_place (epic_phantom_03_sq);
	ai_place (epic_wraith_backup_04_sq);	
	ai_place (epic_wraith_backup_07_sq);
	//ai_place (epic_wraith_backup_06_sq);
	//sleep (30 * 1);
	//ai_place (epic_wraith_backup_05_sq);
	
	/*sleep_until (ai_living_count (epic_mortardom_vehicles) < 4
	and
	epic_obj_state < 40);*/
	
	sleep_until( epic_obj_state < 40); 
	
	ai_place (epic_phantom_06_sq);
	ai_place (epic_wraith_backup_08_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (epic_phantom_06_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location (epic_wraith_backup_08_sq.driver));	


	sleep_s (5);
	//sleep_until (ai_living_count(epic_phantom_06_sq) < 1 and epic_obj_state < 40);

	thread (epic_wraith_09_placement());

	sleep_until (volume_test_players (tv_epic_top_of_hill)
	or
	(ai_living_count (epic_small_vehicles) < 2
	and
	ai_living_count (epic_mortardom_vehicles) < 2)
	or
	volume_test_players (tv_epic_04), 1);
	
	sleep_until(not (volume_test_players_lookat (tv_epic_wraith_high_shelling_01_sq_spawn, 3000, 40)));
	if
	not volume_test_players(tv_epic_top_of_hill)
	then
	ai_place (epic_wraith_high_shelling_01_sq);
	end

end

script static void epic_wraith_09_placement()
	sleep_s (3);

	sleep_until (ai_living_count (epic_mortardom_vehicles) < 3
	and
	epic_obj_state < 40	
	);
	
	ai_place (epic_phantom_07_sq);
	ai_place (epic_wraith_backup_09_sq);
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (epic_phantom_07_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location (epic_wraith_backup_09_sq.driver));
end

script static void epic_mid_02_sq_spawn()
	sleep_until (ai_living_count (epic_mid_01_sq) < 2
	and
	epic_obj_state > 14
	and
	epic_obj_state < 40
	and
	not (volume_test_players_lookat (tv_epic_mid_02_sq_spawn, 3000, 40)));
	ai_place (epic_mid_02_sq);
end

script static void epic_mid_03_sq_spawn()
	sleep_until (ai_living_count (epic_tower_left_01_sq) < 3
	and
	ai_living_count (epic_mid_01_sq) < 5
	and
	ai_living_count (epic_small_vehicles) < 2	
	and
	epic_obj_state < 30
	and
	not (volume_test_players_lookat (tv_epic_mid_03_sq_spawn, 3000, 40)));
	ai_place (epic_mid_03_sq);
end

script static void epic_rear_01_sq_spawn()
	sleep_until (ai_living_count (epic_mid_02_sq) < 2
	and
	ai_living_count (epic_mid_03_sq) < 2
	and
	epic_obj_state > 20
	and
	epic_obj_state < 40);
	ai_place (epic_rear_01_sq);
end

script dormant epic_marines_ins_temp()
	object_create (epic_ins_hog_01);
	ai_place (epic_marines_convoy);
	ai_vehicle_enter_immediate (epic_marines_convoy.chief_gunner, epic_ins_hog_01, "warthog_g");
	sleep_until (epic_insertion_state == true);
	teleport_players_into_vehicle (epic_ins_hog_01);
end

script dormant backup_ending_script()
	sleep_until (epic_ending_rdy == true
	and
	ai_living_count (epic_hill_infantry) < 3	
//	and
//	volume_test_players (tv_epic_05)
	);
	sleep (30 * 4);

end 

script static void test_end()
	object_create (missile_capsule);
	object_move_to_point (missile_capsule, .5, pod_effect.p1);
	effect_new_at_ai_point (fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect, pod_effect.p1);
	sleep (30 * 2);
	cinematic_set_title (m40_blurb_epic_2); 
	//fade_out (0,0,0,120);
	sleep (30 * 10);
	cinematic_set_title (m40_blurb_epic_3);
	sleep (30 * 15);
	cinematic_set_title (m40_blurb_epic_4);
	sleep (30 * 14);
end

script dormant epic_bubble_control()

		wake (epic_bubble_check_one);
		wake (epic_bubble_check_two);
		
		sleep_until(epic_bubbles_burst >= 1);
		
		wake (f_dialog_m40_cortana_shield_destroyed_one);
		
		object_set_function_variable (epic_shield_barrier, shield_color, 1, 0);
		
		sleep_until(epic_bubbles_burst >= 2);

		object_destroy (epic_shield_barrier);
		wake (m40_cortana_clearing_ravine);		
end

script dormant epic_bubble_check_one()

		sleep_until(object_get_health(epic_bubble_module_1) <= .3, 1);
		sleep (30 * 0.5);
		object_destroy (epic_bubble_1);
		epic_bubble_one_burst = true;
		epic_bubbles_burst = epic_bubbles_burst + 1;
		f_unblip_object(epic_bubble_module_1);
		game_save_no_timeout();

end

script dormant epic_bubble_check_two()

		sleep_until(object_get_health(epic_bubble_module_2) <= .3, 1);
		sleep (30 * 0.5);
		object_destroy (epic_bubble_2);
		epic_bubble_two_burst = true;
		epic_bubbles_burst = epic_bubbles_burst + 1;
		f_unblip_object(epic_bubble_module_2);
		game_save_no_timeout();

end


//--------------------epic command scripts-------------------

//script command_script epic_ghost_boosting_01()
//	sleep (30 * 1);
//	cs_vehicle_boost (epic_revenant_front_sq, true);
//	cs_go_to (epic_vehicle_pt.p0);
//end

script command_script epic_ghost_boosting_02()
	cs_vehicle_boost (true);
	cs_go_to (epic_vehicle_pt.p12);
	cs_vehicle_boost (false);
end

script command_script epic_ghost_front_boost_01()
	cs_vehicle_boost (true);
	cs_go_to (epic_vehicle_pt.p15);
	cs_go_to (epic_vehicle_pt.p19);
	cs_vehicle_boost (false);
end

script command_script epic_ghost_front_boost_02()
	cs_vehicle_boost (true);
	cs_go_to (epic_vehicle_pt.p14);
	cs_go_to (epic_vehicle_pt.p20);
	cs_vehicle_boost (false);
end

script command_script epic_marine_tank_02_cs()
	cs_go_to (epic_vehicle_pt.p16);
	cs_shoot_point (true, epic_vehicle_pt.p17);
	sleep (30 * 2);
end

script command_script epic_phantom_mid_guard_sq_control()
//	sleep_until (volume_test_players (tv_epic_015));
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_mid_guard_spawn', epic_phantom_mid_guard_sq, 1);
	
	cs_fly_to_and_face (epic_vehicle_pt.p2, epic_vehicle_pt.p1);
	sleep (30 * 2);
	vehicle_unload (ai_vehicle_get (epic_phantom_mid_guard_sq.driver), "phantom_sc01");
	vehicle_unload (ai_vehicle_get (epic_phantom_mid_guard_sq.driver), "phantom_sc02");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_mid_guard_takeoff', epic_phantom_mid_guard_sq, 1);
	cs_vehicle_speed (.5);
	cs_fly_to_and_face (epic_phantom_mid_guard_sq_pt.p0, epic_vehicle_pt.p0);
	cs_vehicle_speed (.5);
	cs_fly_to_and_face (epic_phantom_mid_guard_sq_pt.p1, epic_vehicle_pt.p0);
	cs_vehicle_speed (.9);
	cs_fly_to_and_face (epic_phantom_mid_guard_sq_pt.p0, epic_vehicle_pt.p0);
	cs_vehicle_speed (1);
	cs_fly_by (epic_phantom_mid_guard_sq_pt.p3);
	cs_fly_by (epic_phantom_mid_guard_sq_pt.p4);
	cs_fly_by (epic_phantom_mid_guard_sq_pt.p5);
	ai_erase (epic_phantom_mid_guard_sq);
end

script command_script epic_phantom_01_sq_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_01_spawn', epic_phantom_01_sq, 1);
	cs_vehicle_speed (1);
	f_load_phantom( epic_phantom_01_sq, "left", epic_rear_02_sq.guy1, epic_rear_02_sq.guy2, epic_rear_02_sq.guy3, epic_rear_02_sq.guy4);
	f_load_phantom (epic_phantom_01_sq, "right", epic_rear_03_sq.guy1, epic_rear_03_sq.guy2, epic_rear_03_sq.guy3, epic_rear_03_sq.guy4);
	f_load_phantom (epic_phantom_01_sq, "chute", epic_rear_04_sq.guy1, epic_rear_04_sq.guy2, epic_rear_04_sq.guy3, NONE);
	epic_ending_rdy = true;
	cs_fly_by (epic_phantom_01_sq_pt.p0);
	cs_fly_by (epic_phantom_01_sq_pt.p1);
	cs_fly_by (epic_phantom_01_sq_pt.p2);
	cs_fly_by (epic_phantom_01_sq_pt.p3);
	cs_fly_by (epic_phantom_01_sq_pt.p4);
	f_unload_phantom (epic_phantom_01_sq, "left");
	f_unload_phantom (epic_phantom_01_sq, "right");
	f_unload_phantom (epic_phantom_01_sq, "chute");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_01_takeoff', epic_phantom_01_sq, 1);
	cs_fly_by (epic_phantom_02_sq_pt.p8);
	cs_fly_by (epic_phantom_02_sq_pt.p9);	
	ai_erase (epic_phantom_01_sq);
end

script command_script epic_phantom_02_sq_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_02_spawn', epic_phantom_02_sq, 1);
	cs_vehicle_speed (1);
	f_load_phantom( epic_phantom_02_sq, "chute", epic_mid_04_sq.guy1, epic_mid_04_sq.guy2, epic_mid_04_sq.guy3, NONE);
	cs_fly_by (epic_phantom_02_sq_pt.p0);
	cs_fly_by (epic_phantom_02_sq_pt.p1);
	cs_fly_by (epic_phantom_02_sq_pt.p2);
	cs_fly_to_and_face (epic_phantom_02_sq_pt.p4, epic_phantom_02_sq_pt.p10);
	f_unload_phantom (epic_phantom_02_sq, "chute");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_02_takeoff', epic_phantom_02_sq, 1);
	cs_fly_by (epic_phantom_02_sq_pt.p5);
	cs_fly_by (epic_phantom_02_sq_pt.p6);
	cs_fly_by (epic_phantom_02_sq_pt.p7);
	cs_fly_by (epic_phantom_02_sq_pt.p8);
	cs_fly_by (epic_phantom_02_sq_pt.p9);	
	ai_erase (epic_phantom_02_sq);
end


script command_script epic_phantom_03_sq_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_03_spawn', epic_phantom_03_sq, 1);
	thread (phantom_hangout_sc());
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (epic_phantom_03_sq.driver), "phantom_lc", ai_vehicle_get_from_starting_location (epic_wraith_backup_04_sq.driver));	
	cs_vehicle_speed (1);
	cs_fly_by (epic_phantom_03_sq_pt.p0);
	cs_fly_by (epic_phantom_03_sq_pt.p1);
	cs_fly_by (epic_phantom_03_sq_pt.p2);
	cs_fly_to_and_face (epic_phantom_03_sq_pt.p3, epic_vehicle_pt.p7);
	vehicle_unload (ai_vehicle_get (epic_phantom_03_sq.driver), "phantom_lc");
	
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_03_takeoff', epic_phantom_03_sq, 1);
	cs_vehicle_speed (.6);
	repeat
		begin_random
			begin
				cs_fly_to_and_face (epic_phantom_03_sq_pt.p3, epic_vehicle_pt.p7);
			end
			begin
				cs_fly_to_and_face (epic_phantom_03_sq_pt.p4, epic_vehicle_pt.p7);
			end
			begin
				cs_fly_to_and_face (epic_phantom_03_sq_pt.p5, epic_vehicle_pt.p7);
			end
			begin
				cs_fly_to_and_face (epic_phantom_03_sq_pt.p6, epic_vehicle_pt.p7);
			end
		end
	until	(phantom_hang_out == false);
	cs_vehicle_speed (1);
	cs_fly_by (epic_phantom_03_sq_pt.p8);
	cs_fly_by (epic_phantom_03_sq_pt.p9);
	cs_fly_by (epic_phantom_03_sq_pt.p10);
	cs_fly_by (epic_phantom_03_sq_pt.p11);
	cs_fly_by (epic_phantom_03_sq_pt.p12);
	cs_fly_by (epic_phantom_03_sq_pt.p13);
	ai_erase (epic_phantom_03_sq);
end

script static void phantom_hangout_sc()
	phantom_hang_out = true;
	sleep (30 * 50);
	phantom_hang_out = false;
end

script command_script epic_phantom_04_sq_cs()
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_04_spawn', epic_phantom_04_sq, 1);
		cs_vehicle_speed (1);
		cs_fly_by (epic_phantom_04_sq_pt.p0);
		cs_fly_by (epic_phantom_04_sq_pt.p1);
		cs_fly_by (epic_phantom_04_sq_pt.p2);
		cs_fly_by (epic_phantom_04_sq_pt.p3);
		vehicle_unload (ai_vehicle_get (epic_phantom_04_sq.driver), "phantom_sc01");
		vehicle_unload (ai_vehicle_get (epic_phantom_04_sq.driver), "phantom_sc02");
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_04_takeoff', epic_phantom_04_sq, 1);
		cs_fly_by (epic_phantom_04_sq_pt.p4);
		cs_fly_by (epic_phantom_04_sq_pt.p5);
		cs_fly_by (epic_phantom_04_sq_pt.p6);
		cs_fly_by (epic_phantom_04_sq_pt.p7);
		cs_fly_by (epic_phantom_04_sq_pt.p8);
		cs_fly_by (epic_phantom_04_sq_pt.p9);
		ai_erase (epic_phantom_04_sq);
end

//script command_script epic_phantom_05_sq_cs()
//		cs_vehicle_speed (1);
//		cs_fly_by (epic_phantom_05_sq_pt.p0);
//		cs_fly_by (epic_phantom_05_sq_pt.p1);
//		cs_fly_by (epic_phantom_05_sq_pt.p2);
//		cs_fly_to_and_face (epic_phantom_05_sq_pt.p3, epic_phantom_05_sq_pt.p4);
//		vehicle_unload (ai_vehicle_get (epic_phantom_05_sq.driver), "phantom_lc");
//		sleep (30 *5);
//		vehicle_unload (ai_vehicle_get (epic_phantom_05_sq.driver), "phantom_sc01");
//		vehicle_unload (ai_vehicle_get (epic_phantom_05_sq.driver), "phantom_sc02");
//		cs_fly_by (epic_phantom_05_sq_pt.p5);
//		cs_fly_by (epic_phantom_05_sq_pt.p6);
//		cs_fly_by (epic_phantom_05_sq_pt.p7);
//		cs_fly_by (epic_phantom_05_sq_pt.p8);
//		ai_erase (epic_phantom_05_sq);
//end

script command_script epic_phantom_06_sq_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_06_spawn', epic_phantom_06_sq, 1);
	cs_fly_by (epic_phantom_06_pt.p1);
	cs_fly_by (epic_phantom_06_pt.p0);
	cs_fly_by (epic_phantom_06_pt.p2);
	
	vehicle_unload (ai_vehicle_get (epic_phantom_06_sq.driver), "phantom_lc");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_06_takeoff', epic_phantom_06_sq, 1);
	cs_fly_by (epic_phantom_06_pt.p3);
	cs_fly_by (epic_phantom_06_pt.p4);
	cs_fly_by (epic_phantom_06_pt.p5);
	ai_erase (epic_phantom_06_sq);
end

script command_script epic_phantom_07_sq_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_07_spawn', epic_phantom_07_sq, 1);
	cs_fly_by (epic_phantom_07_pt.p0);
	cs_fly_by (epic_phantom_07_pt.p1);
	cs_fly_by (epic_phantom_07_pt.p2);
	vehicle_unload (ai_vehicle_get (epic_phantom_07_sq.driver), "phantom_lc");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_epic_phantom_07_takeoff', epic_phantom_07_sq, 1);
	cs_fly_by (epic_phantom_06_pt.p3);
	cs_fly_by (epic_phantom_06_pt.p4);
	cs_fly_by (epic_phantom_06_pt.p5);
	ai_erase (epic_phantom_07_sq);
end

//script command_script pelican_backup_01_cs()
//		print ("UNSC reinforcements incoming");
//		thread (m40_marine_backup_dialogue());
// 		sleep (30 * 4);
//		ai_place (marines_backup_01);
//		vehicle_load_magic (ai_vehicle_get_from_spawn_point (pelican_backup_01.driver), "pelican_lc", ai_vehicle_get_from_starting_location  (marines_backup_01.hog_driver));
//		cs_vehicle_speed (1);
//		cs_fly_by (pelican_backup_01_pt.p0);
//		cs_fly_by (pelican_backup_01_pt.p1);
//		cs_fly_to_and_face (pelican_backup_01_pt.p2, pelican_backup_01_pt.p3);
//		sleep (30 * 1);
//		vehicle_unload (ai_vehicle_get (pelican_backup_01.driver), "pelican_lc");
//		f_blip_ai (marines_backup_01.hog_driver, "ordnance");	
//		thread (unblipping_epic_backup_01());
//		sleep (30 * 1);
//		cs_fly_to_and_face (pelican_backup_01_pt.p7, pelican_backup_01_pt.p8);
//		unit_open (pelican_backup_01);
//		sleep (30 * 1);
//		ai_place (mongoose_backup_01);
//		print ("mongoose_backup_01 placed");
//		cs_fly_by (pelican_backup_01_pt.p0);
//		cs_fly_by (pelican_backup_01_pt.p6);
//		cs_fly_by (pelican_backup_01_pt.p5);
//		cs_fly_by (pelican_backup_01_pt.p9);
//		ai_erase (pelican_backup_01);
//		sleep (30 * 10);
//end

//script static void unblipping_epic_backup_01()
//	sleep (30 * 15);
//	f_unblip_ai (marines_backup_01.hog_driver);
//	print ("marines_backup_01 unblipped");
//end
//
//script static void unblipping_epic_backup_02()
//	sleep (30 * 15);
//	f_unblip_ai (marines_backup_02.hog_driver);	
//	print ("marines_backup_02 unblipped");
//end	

//script command_script pelican_backup_02_cs()
//		print ("UNSC reinforcements incoming");
//		thread (m40_marine_backup_dialogue());
// 		sleep (30 * 4);
//		ai_place (marines_backup_02);
//		vehicle_load_magic (ai_vehicle_get_from_spawn_point (pelican_backup_02.driver), "pelican_lc", ai_vehicle_get_from_starting_location  (marines_backup_02.hog_driver));
//		cs_vehicle_speed (1);
//		cs_fly_by (pelican_backup_01_pt.p0);
//		cs_fly_by (pelican_backup_01_pt.p1);
//		cs_fly_to_and_face (pelican_backup_01_pt.p2, pelican_backup_01_pt.p3);
//		sleep (30 * 1);
//		vehicle_unload (ai_vehicle_get (pelican_backup_02.driver), "pelican_lc");
//		f_blip_ai (marines_backup_02.hog_driver, "ordnance");	
//		thread (unblipping_epic_backup_02());
//		sleep (30 * 1);
//		cs_fly_to_and_face (pelican_backup_01_pt.p7, pelican_backup_01_pt.p8);
//		unit_open (pelican_backup_02);
//		sleep (30 * 1);
//		ai_place (mongoose_backup_02);
//		cs_fly_by (pelican_backup_01_pt.p6);
//		cs_fly_by (pelican_backup_01_pt.p0);
//		cs_fly_by (pelican_backup_01_pt.p5);
//		ai_erase (pelican_backup_02);
//		sleep (30 * 10);
//end

//script static void test_scorpion_load_script()
//	ai_place (pelican_load_sq);
//	ai_place (scorpion_load_sq);
//	sleep (30 * 2);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (pelican_load_sq.driver), "pelican_lc", ai_vehicle_get_from_starting_location  (scorpion_load_sq.driver));
//end
		
script command_script m_test_99()
	cs_go_to (mtest.p14);
end

script command_script m_test_97()
	cs_go_to (mtest.p16);
end

script command_script m_test_98()
	cs_go_to (mtest.p17);
end

script static void epic_convoy_marines_enter_hog()
	sleep (30 * 1);
	ai_vehicle_enter_immediate (epic_marines_convoy.chief_gunner, epic_ins_hog_01, "warthog_g");
end


//script command_script mongoose_backup_01a_cs()
//		cs_ignore_obstacles (true);
//		cs_go_to (epic_vehicle_pt.p4);
//		cs_ignore_obstacles (false);
//end

script command_script lich_shoot_tortoise()
	cs_shoot_point (true, tort_top_patrol.p4);
end

script command_script epic_wraith_high_shelling_cs()
	cs_shoot_point (true, epic_wraith_high_shelling_pt.p0);
	sleep (30 *10);
	cs_shoot_point (true, epic_wraith_high_shelling_pt.p1);
	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p2);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p3);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p4);
//	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p5);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p6);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p7);
//	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p0);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p1);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p2);
//	sleep (30 *7);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p3);
//	sleep (30 *13);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p4);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p5);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p6);
//	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p7);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p0);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p1);
//	sleep (30 *12);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p2);
//	sleep (30 *12);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p3);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p4);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p5);
//	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p6);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p7);
//	sleep (30 *11);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p0);
//	sleep (30 *8);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p1);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p2);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p3);
//	sleep (30 *13);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p4);
//	sleep (30 *9);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p5);
//	sleep (30 *10);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p6);
//	sleep (30 *8);
//	cs_shoot_point (true, epic_wraith_high_shelling_pt.p7);
//	sleep (30 *10);
end

script command_script epic_wraith_low_shelling_cs()

	cs_shoot_point (true, epic_wraith_high_shelling_pt.p8);
	sleep (30 * 5);
	cs_shoot_point (true, epic_wraith_high_shelling_pt.p9);
	sleep (30 * 5);
	cs_shoot_point (true, epic_wraith_high_shelling_pt.p10);
	sleep (30 * 5);

end

script static void lib_teleport_start()
	object_destroy (cannon_chopper);
//	object_create (dm_portal_out);
//	object_hide (dm_portal_out, true);
//	sleep_until( current_zone_set() >= DEF_S_ZONESET_ELE_EPIC(), 1 );	
//	sleep_s(1);
//	object_hide (dm_portal_out, false);	
//	sleep_until(b_portal_up == true, 1);
	sleep_until( volume_test_players (tv_teleport_lib), 1 );

	// commit the zoneset transition that was started in elevator
	screen_effect_new(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_1);
	screen_effect_new(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_2);
	screen_effect_new(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_3);
	screen_effect_new(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_4);
	fade_out (255,255,255,5);
	switch_zone_set("zone_set_epic");
	object_teleport (player0, epic_teleport_flag_01);
	object_teleport (player1, epic_teleport_flag_02);
	object_teleport (player2, epic_teleport_flag_03);
	object_teleport (player3, epic_teleport_flag_04);

	wake (epic_main_script);
	wake (epic_obj_control);
	sleep(1);
		
	sleep_until (current_zone_set_fully_active() == DEF_S_ZONESET_EPIC());
	sleep(60);
	screen_effect_delete(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_1);
	screen_effect_delete(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_2);
	screen_effect_delete(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_3);
	screen_effect_delete(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, fg_tp_effect_4);
	fade_in (255,255,255,10);
//	thread (lib_teleport(player0(), epic_teleport_flag_01));
//	thread (lib_teleport(player1(), epic_teleport_flag_02));
//	thread (lib_teleport(player2(), epic_teleport_flag_03));
//	thread (lib_teleport(player3(), epic_teleport_flag_04));
end

script static void test_offset()
	object_move_by_offset ( sn_pcave_door_exit, 3, 0, -.6, 1.5 );
end

script command_script jetpack_goto_test()
	cs_go_to (chop_tortoise_pt.p13);
	cs_go_to (chop_tortoise_pt.p15);
//	cs_go_to (chop_tortoise_pt.p16);
end 

script static void lib_teleport (player p_player, cutscene_flag cf_flag)
	sleep_until (volume_test_object (tv_teleport_lib, p_player), 1);
	fade_out (255,255,255,5);
//	sleep (30 * .7);
//	object_teleport (p_player, cf_flag);
//	print ("TELEPORT!");
	//fade_out (255,255,255,5);
//	sleep (30 * .7);
	object_teleport (p_player, cf_flag);
	wake (epic_main_script);
	wake (epic_obj_control);
	sleep_s(2);
	fade_in (0,0,0,5);
end

script static void infinity_epic_entrance()
	pup_play_show(infinity_arrival);
	thread (test_pfly());
end

script static void infinity_epic_rotate()
	sleep (30 * 4);
	object_rotate_by_offset (infinity_2, 20, 20, 20, -40, 0, 0);
end

script command_script epic_tank_shoot_ghost()
//	sleep (30 * 2);
//	cs_shoot_point (true, epic_vehicle_pt.p7);
	sleep_until(object_valid(epic_scorpion_01));
	ai_vehicle_enter_immediate (epic_marines_tank_01, epic_scorpion_01, "scorpion_d");
	vehicle_set_player_interaction (epic_scorpion_01, "scorpion_g", false, false);
	cs_go_to (epic_vehicle_pt.p8);
	ai_vehicle_exit (epic_marines_tank_01);
	//sleep_s (3);
	//dprint("I'm getting in the gun!");
	//ai_vehicle_enter (epic_marines_tank_01, epic_scorpion_01, "scorpion_g");
	sleep (30 * 7);	
	vehicle_set_player_interaction (epic_scorpion_01, "scorpion_g", true, true);
//	sleep_s(3);
	sleep_until (player_in_vehicle(epic_scorpion_01)
	or
	epic_tank_ai_timeout == true);
//	dprint("player not in tank");
	if
		not (player_in_vehicle(epic_scorpion_01))
	then	
		cs_run_command_script(epic_marines_tank_01, cs_epic_tank_switch_seat);
	end
end

script static void epic_tank_ai_timeout_sc()
	sleep (30 * 10);
	epic_tank_ai_timeout = true;	
end

script command_script cs_epic_tank_switch_seat()
	dprint("I'm getting in tank now");
	ai_vehicle_exit (epic_marines_tank_01);
	sleep(1);
	ai_vehicle_enter (epic_marines_tank_01, epic_scorpion_01, "scorpion_d");
end

//script command_script epic_infinity_phantom_01_cs()
////	cs_shoot_point (true, epic_vehicle_pt.p7);
//	cs_vehicle_speed (.5);
//	cs_fly_by (epic_infinity_route.p5);
//	object_set_scale (ai_get_unit (epic_infinity_phantom_01.guy1, 0.1, 60 ));
//	cs_fly_by (epic_infinity_route.p4);
//end

script static void test_seats()
	vehicle_set_unit_interaction (unit_get_vehicle (epic_marines_tank_01), "scorpion_d", false, false);
	sleep_s (5);		
	vehicle_set_unit_interaction (ai_vehicle_get_from_spawn_point (epic_marines_tank_01), "scorpion_d", true, true);	
end

script command_script knight_phase_spawn()
	cs_phase_in();
end

script static void test_pfly()
	thread (test_pfly1());
	thread (test_pfly2());
	thread (test_pfly3());
	thread (test_cfly1());
	thread (test_cfly2());
	thread (test_cfly3());
	thread (test_cfly4());
	sleep (30 * 4);
	thread (test_flock());
end
	

script static void test_pfly1()
	object_set_scale (epic_infinity_phantom_01_obj, 0.1, 240 );
	object_move_to_point (epic_infinity_phantom_01_obj, 9, epic_infinity_route.p7);
//	sleep (30 * 15);
	object_set_scale (epic_infinity_phantom_01_obj, 0.01, 50 );
	object_move_to_point (epic_infinity_phantom_01_obj, 30, epic_infinity_route.p8);
end

script static void test_pfly2()
	object_set_scale (epic_infinity_phantom_02_obj, 0.1, 280 );
	object_move_to_point (epic_infinity_phantom_02_obj, 7, epic_infinity_route.p5);
	object_set_scale (epic_infinity_phantom_02_obj, 0.01, 50 );
	object_move_to_point (epic_infinity_phantom_02_obj, 30, epic_infinity_route.p8);
end

script static void test_pfly3()
	object_set_scale (epic_infinity_phantom_03_obj, 0.1, 220 );
	object_move_to_point (epic_infinity_phantom_03_obj, 15, epic_infinity_route.p6);
	object_set_scale (epic_infinity_phantom_03_obj, 0.01, 50 );
	object_move_to_point (epic_infinity_phantom_03_obj, 30, epic_infinity_route.p8);
end

script static void test_cfly1()
	object_move_to_point (epic_infinity_cruiser_01_obj, 20, epic_infinity_route.p9);
end

script static void test_cfly2()
	object_move_to_point (epic_infinity_cruiser_02_obj, 27, epic_infinity_route.p10);
end

script static void test_cfly3()
	object_move_to_point (epic_infinity_cruiser_03_obj, 20, epic_infinity_route.p1);
end

script static void test_cfly4()
	object_move_to_point (epic_infinity_cruiser_04_obj, 15, epic_infinity_route.p12);
end

script static void test_flock()
	flock_create (flocks_epic_banshee);
	flock_create (flocks_epic_pelicans);
	flock_create (flocks_epic_banshee_2);
	flock_create (flocks_epic_pelicans_2);
end


//script static void test_cfly5()
//	object_set_scale (epic_infinity_cruiser_05_obj, 0.1, 150 );
//	object_move_to_point (epic_infinity_cruiser_05_obj, 5, epic_infinity_route.p13);
//end


script command_script epic_hog_intro()
	cs_go_to (epic_vehicle_pt.p9);
//	sleep (30 * 5);
end

script command_script tester2_cs()
	cs_go_to (misc_veh_pt.p4);
	cs_go_to (misc_veh_pt.p5);
//	sleep (30 * 5);
end

script command_script epic_goose_intro()
	cs_go_to (epic_vehicle_pt.p10);
//	sleep (30 * 5);
end

script static void test_jump()
	sleep_until (ai_living_count (epic_ghost_front_right_02_sq) < 1
	and
	ai_living_count (epic_ghost_backup_01_sq) < 1	
	and
	epic_obj_state < 50
	and
	epic_obj_state > 19
	); 
	sleep (30 * 3);
	ai_place (epic_ghost_backup_07a_sq);
//	sleep (30 * 3);
//	ai_place (epic_ghost_backup_07b_sq);
end

script static void teleport_effect()
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, pts_teleport_lib.p0);
	sleep_s (5);	
	effect_new_at_ai_point (fx\reach\fx_library\cinematics\boneyard\040lb_cov_flee\02\shot_1\longsword_attack_explosion.effect, cannon_explosion.p1);
end

script static void tractor_swirling_rock_anims_01()
	repeat
		device_set_overlay_track( rock_swirl_01, 'any:rocca1' );
		device_animate_overlay( rock_swirl_01, 1, 33, .1, .1);
		sleep( 30 * 31.9 );
	until (1 == 0);
end

script static void tractor_swirling_rock_anims_02()
	repeat
		device_set_overlay_track( rock_swirl_02, 'any:rocca2' );
		device_animate_overlay( rock_swirl_02, 1, 33, .1, .1);
		sleep( 30 * 31.9);
	until (1 == 0);
end

//-------------final missile gameplay-------------//

global boolean g_enable_fade=true;

script dormant missile_prototype()
	
	// Begin loading epic exit.  This should get triggered once the second bubble is destroyed
	zone_set_trigger_volume_enable("begin_zone_set:zone_set_epic_exit", true );

	object_create (tractor_target);

	object_create (missile_capsule);
	
	object_move_to_point (missile_capsule, 1, pod_effect.p1);
	effect_new_at_ai_point (fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect, pod_effect.p1);
	object_create (target_laser);

  td_disabled = false;

	// wait until the zone has been loaded to start playing effects around the tractor beam
	sleep_until(current_zone_set_fully_active() == DEF_S_ZONESET_EPIC_EXIT(),1);

	effect_new (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base );

	local long orb_show = pup_play_show(pup_power_orbs);

  
	/// sleep until player has target designator

	sleep_until (unit_has_weapon (player0, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	or
	unit_has_weapon (player1, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	or
	unit_has_weapon (player2, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)	
	or
	unit_has_weapon (player3, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)	
	);

	f_unblip_object(target_laser);
	
	if
		unit_has_weapon (player0, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	then
		m_ics_player0 = true;
		td_user = player0;
	elseif
		unit_has_weapon (player1, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	then
		m_ics_player1 = true;
		td_user = player1;
	elseif
		unit_has_weapon (player2, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	then
		m_ics_player2 = true;
		td_user = player2;
	elseif
		unit_has_weapon (player3, objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon)
	then
		m_ics_player3 = true;
		td_user = player3;
	else
		print ("Who has the weapon?");
	end
	
	
	// Sleep until  Tractor Target is targetted
	
			print ("Waiting to Lock");
	//sleep_until (weapon_get_lockon_state(target_laser) == 2);
	//sleep_until (weapon_get_rounds_total(target_laser,0) == 1);
                          
	//sleep_until (weapon_get_lockon_target(target_laser) != "NONE");
  
  local boolean exit_end_td = 0;
  
  thread(target_designator_check_trigger_down_time_end());
	thread (target_designator_dpad_input_watch_epic());
	thread (target_designator_give_think_epic());
	thread (target_designator_swap_away_think_epic());

  
	weapon_set_current_amount (target_laser, 1);
	sleep_until (weapon_get_lockon_target(target_laser, true, false) == tractor_target and td_trigger_down_time_met); 
	
	wake (f_dialog_m40_epic_end_fired);
	//dialogue that plays when the player locks onto the tower... is this the right spot for this? - jacob

	object_destroy (tractor_target);
	sleep (10 * 3);
	fade_out (1,1,1, 5);
	sleep (30 * .5);

	object_destroy (infinity_2);
	object_destroy (cruiser_2);
	thread (camera_shake_long());
	
	pup_stop_show (orb_show);
	
	unit_exit_vehicle (player0);
	unit_exit_vehicle (player1);
	unit_exit_vehicle (player2);
	unit_exit_vehicle (player3);

	sleep_until (not (unit_in_vehicle (player0))
	and
	not (unit_in_vehicle (player1))
	and
	not (unit_in_vehicle (player2))
	and
	not (unit_in_vehicle (player3))
	);
	
	ending_1();

//	f_blip_flag (tractor_target_flag, "neutralize");
end

script static void no_lens_flares()
	// Tractor Beam - No Lens Flares
	print ("Tractor Beam - No Lens Flares - FX");
//	effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base);
//	effect_new (environments\solo\m40_invasion\fx\energy\tractor_beam_no_flares.effect, fx_tractor_base );
end

script static void target_designator_check_trigger_down_time_end()
	repeat
		if (unit_has_weapon_readied (td_user, "objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon") and td_tried_to_fire_input) then
			td_trigger_down_time = td_trigger_down_time + 1;
		else
			td_trigger_down_time = 0;
			td_trigger_down_time_met = false;
		end
		
		if (td_trigger_down_time > td_trigger_down_time_max) then
			td_trigger_down_time_met = true;
		end
		
		//inspect(td_trigger_down_time);
	until (1 == 0, 1);
end

script static void target_designator_give_think_epic()
	repeat
  	if (td_pulled_out_input) and (not td_is_out) then
			
			// make the laser exist
			object_create_anew(target_laser);
			
			if object_valid(target_laser) and player_count() > 0 then
				target_designator_give_ammo();
				
				// give the weapon
				unit_add_weapon(td_user, target_laser, 0);
				td_is_out	= true;
				print ("gave td");
								
				// give ammo if it's actually ready, take it away if its not
				if (target_designator_is_ready) then	
					target_designator_give_ammo();
				else
					target_designator_deplete_ammo();
				end
				sleep (30);
			end
		end
	until (1 == 0, 1);
end

// if the player swaps away, this handles what happens to the TD
script static void target_designator_swap_away_think_epic()
	repeat
		if (object_valid(target_laser) and player_count() > 0) then
			if (td_switched_weapons_input or object_get_parent(target_laser) == NONE) then      // swapped to another weapon OR object_get_parent(m40_lakeside_target_laser)==NONE) then    // or it was dropped
				object_destroy(target_laser);
					td_is_out = false;
					if td_switched_weapons_input then
						print ("switched away from TD");
					else
						print ("dropped TD!");
					end
				sleep (30);
			end
		else
			td_is_out = false;
//			print ("TD invalid/no players");                
			sleep (30);
		end
	until (1 == 0, 1);
end

script static void target_designator_dpad_input_watch_epic()
	repeat
		// reset these at the top of the loop
		td_pulled_out_input = false;
		td_switched_weapons_input = false;
		td_tried_to_fire_input = false;
			
		// this call allowes input to be checked every frame
		unit_action_test_reset(td_user);
		
		// check against various inputs and set global vars that other functions look at
		
		// pull the weapon out
		if (unit_action_test_dpad_up(td_user)) then
			td_pulled_out_input = true;
		end
		
		// swap weapons
		if (unit_action_test_primary_trigger(td_user)) then
			td_switched_weapons_input = true;
		end
		
		// pull trigger
		if (unit_action_test_primary_trigger(td_user)) then
			td_tried_to_fire_input = true;
		end

	until (1 == 0, 1);
end


script static void ending_1()

	// Begin streaming new zoneset.  This includes resources for the missile flight so we won't unload them.
	prepare_to_switch_to_zone_set( cin_m042_end );

	effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base);
	fade_in(1,1,1, 5);
	effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base);
	g_ics_player = player_get_first_alive();
	local long missile_show=pup_play_show(fake_missile);
	sleep_until(not pup_is_playing(missile_show),1);
	camera_shake_player (player0, 1, 1, 1, 3, epic_missile_camera_shake);
	sleep (30 * .9);

	
	sleep(1);
//	thread (turn_off_tractor_beam_sc());
	effects_distortion_enabled = true; 
	effects_perf_armageddon = 0;

	thread (tb_fx_delay());
	g_ics_player = player_get_first_alive();
	pup_play_show( "tractor_beam");

	sleep (249);
	//sleeping while vignette plays
	
	fade_out (0, 0, 0, 30);	
	//fade out for final part of vignette
	
	sleep (30);
	//fade_out isn't blocking, so sleeping until fade_out finishes

	//cinematic
	f_insertion_begin( "CINEMATIC" );
		
	cinematic_enter( cin_m042_end, true );
	cinematic_suppress_bsp_object_creation( true );
	switch_zone_set( cin_m042_end );
	cinematic_suppress_bsp_object_creation( false );
		
	f_start_mission( cin_m042_end );
	cinematic_exit_no_fade( cin_m042_end, true ); 

	game_won();	
end

script static void tb_fx_delay()
	sleep(1);
	thread (fx_tractor_fall_debris());
end

script static void turn_off_tractor_beam_sc()
	print ("turning off tractor beam FX and lighting for vignette");
//	effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\tractor_beam_no_flares.effect, fx_tractor_base);
	interpolator_start( turn_off_trator_beam );		
	effect_new (environments\solo\m40_invasion\fx\energy\tractor_beam_destruction.effect, fx_tractor_base );
	print ("turning off tractor beam FX and lighting for vignette DONE");
end

script static void f_check_vehicle_left()
g_player_left = NONE;
	repeat
		if (volume_test_objects(tv_left_bubble, player0)) then
			g_player_left = player0;
		elseif (volume_test_objects(tv_left_bubble, player1)) then
			g_player_left = player1;
		elseif (volume_test_objects(tv_left_bubble, player2)) then
			g_player_left = player2;
		elseif (volume_test_objects(tv_left_bubble, player3)) then
			g_player_left = player3;
		else g_player_left = NONE;
		end
		if g_player_left != NONE and unit_in_vehicle(unit(g_player_left)) then
			b_player_in_vehicle_left = true;
		else
			b_player_in_vehicle_left = false;
		end
	until
	(epic_bubble_one_burst == true);
end

script static void f_check_vehicle_right()
g_player_right = NONE;
	repeat
		if (volume_test_objects(tv_right_bubble, player0)) then
			g_player_right = player0;
		elseif (volume_test_objects(tv_right_bubble, player1)) then
			g_player_right = player1;
		elseif (volume_test_objects(tv_right_bubble, player2)) then
			g_player_right = player2;
		elseif (volume_test_objects(tv_right_bubble, player3)) then
			g_player_right = player3;
		else g_player_left = NONE;
		end
		if g_player_right != NONE and unit_in_vehicle(unit(g_player_right)) then
			b_player_in_vehicle_right = true;
		else
			b_player_in_vehicle_right = false;
		end
	until
	(epic_bubble_two_burst == true);
end


script static void get_pos(object the_thing)
                local real my_x = 0;
                local real my_y = 0;
                local real my_z = 0;          

                local real player_x = 0;
                local real player_y = 0;
                local real player_z = 0;    
                
                local real x_limit_max = 8;
                local real x_limit_min = -3;
                
                local real y_limit_max = 8;
                local real y_limit_min = -3;
                
                local real z_limit_max = 8;
                local real z_limit_min = -3;
                
                local boolean breakout_of_loop = 0;
                
                repeat
                my_x = object_get_x (the_thing);
                my_y = object_get_y (the_thing);
                my_z = object_get_z (the_thing);
                
               player_x = object_get_x (player_get_first_valid());
               player_y = object_get_y (player_get_first_valid());
               player_z = object_get_z (player_get_first_valid());

               if (((player_x - my_x) < x_limit_max) and ((player_x - my_x) > x_limit_min) and ((player_y - my_y) < y_limit_max) and ((player_y - my_y) > y_limit_min) and ((player_z - my_z) < z_limit_max) and ((player_z - my_z) > z_limit_min)) then
         
               play_animation_on_object( the_thing, "any:idle");
               sleep(29);
               object_destroy(the_thing);
               s_asteroid_hit = (s_asteroid_hit + 1);
               
               breakout_of_loop = 1;
               end
                until (breakout_of_loop == 1, 1);
end

script static void f_epic_blip_timer()
	sleep_until (volume_test_players (tv_epic_02a));
	print("timer has started");
	sleep_until(ai_living_count(epic_mortardom_vehicles) <= 0);
	print("everyone is dead");
	sleep_s(20);
	print("sleeping for 20 seconds");
	if
		epic_bubbles_burst == 0
	then
		f_blip_object(epic_bubble_module_1, "neutralize");
		f_blip_object(epic_bubble_module_2, "neutralize");
		sleep_until(epic_bubbles_burst >= 1);
		f_unblip_object(epic_bubble_module_2);
		f_unblip_object(epic_bubble_module_2);
	else
	print("bubbles are dead");
	end
end
	
	
script dormant flocking_flak_fx_5

	repeat
	
		begin_random_count(8)
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p0);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p1);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p2);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p3);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p4);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p5);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p6);
		sleep (random_range (15, 30));
		end
		
		begin
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p7);
		sleep (random_range (15, 30));
		end
	
	end
	
	until (1 == 0);

end
