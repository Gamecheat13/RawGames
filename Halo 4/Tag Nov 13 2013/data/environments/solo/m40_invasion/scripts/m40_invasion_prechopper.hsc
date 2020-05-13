// =================================================================================================
// =================================================================================================
// PRECHOPPER
// =================================================================================================
// =================================================================================================

global short s_bubbles_burst = 0;
global boolean b_player_in_bubble_two = false;
global boolean b_bubble_one_burst = false;
global boolean b_bubble_two_burst = false;
global boolean b_bubble_three_burst = false;
global boolean prechop_battle_enter_bool = false;
global boolean player_at_end_of_prechop = false;

script dormant f_bubble_control
	print ("Bubble Control");

		wake (f_bubble_check_one);
		wake (f_bubble_check_two);
		wake (f_bubble_check_three);
		
		sleep_until(s_bubbles_burst >= 1);
		print ("One Bubble Destroyed");
		wake (f_dialog_m40_pre_chopper_one_down);
		thread (prechopper_player_leave_dialogue());
		
		thread (wraith_dialogue_warning());
				
		sleep_s (1);
		
		sleep_until(s_bubbles_burst >= 2);
		print ("Two Bubble Destroyed");
		wake (f_dialog_m40_pre_chopper_two_down);

		object_set_function_variable (prechopper_shield_barrier, shield_color, 1, 0);

		sleep_s (1);
		
		sleep_until(s_bubbles_burst >= 3);
		print ("Three Bubble Destroyed");
		wake (f_dialog_m40_pre_chopper_all_down);	

		ai_place (chop_dead_marines);
		
		thread (prechop_backtrack_soft_wall());
		
		object_destroy (prechopper_shield_barrier);
		thread (keep_prechop_shield_destroyed());
		object_can_take_damage (cannon_chopper_new);
		soft_ceiling_enable ("prechop_chop_divider", false);
		
		sleep_s (2);
		
		wake (f_dialog_m40_prechopper_waiting);

		sleep_s (2);
				
		f_blip_flag (prechopper_leave_flag, "default");
		
		sleep_until (chop_obj_state >= 20
		or
		volume_test_players (tv_tort_rec_chopper_pt0), 1);

		f_unblip_flag (prechopper_leave_flag);
		
end

script static void keep_prechop_shield_destroyed()
	repeat
		sleep_until (object_valid (prechopper_shield_barrier));
		object_destroy (prechopper_shield_barrier);
	until (tort_done_in_mission == true);
end

script static void wraith_dialogue_warning()
	sleep_s (4);
	if
		ai_living_count (sq_wraith) > 0
	then
		wake (f_dialog_40_wraith);
	end
end

script dormant f_bubble_check_one
		wake (bubble_1_checkpoint);
		print ("Bubble 1 check is running");	
		sleep_until(object_get_health(uplink_base_1) <= .3, 1);
		f_unblip_object(uplink_base_1);
		sleep (30 * 0.5);
		object_destroy (uplink_bubble_1);
		b_bubble_one_burst = true;
		s_bubbles_burst = s_bubbles_burst + 1;
		f_unblip_object(uplink_base_1);
		sleep (30 * 1);	
		f_unblip_object(uplink_base_1);		

end

script dormant bubble_1_checkpoint()
	sleep_until (volume_test_players (tv_bubble_1)
	and
	ai_living_count (sq_bubble_1) < 1);
	print ("Bubble 1 wants to checkpoint");	
	game_save_no_timeout();	
end

script dormant f_bubble_check_two
		wake (bubble_2_checkpoint);
		sleep_until(object_get_health(uplink_base_2) <= .3, 1);
		f_unblip_object(uplink_base_2);
		sleep (30 * 0.5);
		object_destroy (uplink_bubble_2);
		b_bubble_two_burst = true;
		s_bubbles_burst = s_bubbles_burst + 1;
		f_unblip_object(uplink_base_2);
		sleep (30 * 1);	
		f_unblip_object(uplink_base_2);			
end

script dormant bubble_2_checkpoint()
	sleep_until (volume_test_players (tv_bubble_2)
	and
	ai_living_count (sq_bubble_2) < 1);
	print ("Bubble 2 wants to checkpoint");		
	game_save_no_timeout();	
end

script dormant f_bubble_check_three

		sleep_until(object_get_health(uplink_base_3) <= .3, 1);
		f_unblip_object(uplink_base_3);
		sleep (30 * 0.5);
		object_destroy (uplink_bubble_3);
		b_bubble_three_burst = true;
		s_bubbles_burst = s_bubbles_burst + 1;
		f_unblip_object(uplink_base_3);
		sleep (30 * 1);	
		f_unblip_object(uplink_base_3);	
		game_save_no_timeout();

end


script dormant f_blip_bubbles

	sleep_until (volume_test_players (tv_prechopper_03), 1);
	
	prechop_battle_enter_bool = true;
	
	f_blip_object( uplink_base_1, "neutralize_a" );
	f_blip_object( uplink_base_2, "neutralize_b" );
	
	sleep_until (b_bubble_one_burst == true and b_bubble_two_burst == true, 1 );
	sleep (30 * 1);
	
	f_blip_object( uplink_base_3, "neutralize_c" );
		
end

script dormant f_bubble_2_player_check

	sleep_until (volume_test_players (tv_bubble_2), 1);
	b_player_in_bubble_two = true;
	
end

script dormant prechopper_convoy_prep()
	sleep_until (volume_test_players (tv_prechopper_015), 1);
//	ai_set_objective (post_lakeside_sq, prechopper_marines_obj);

	thread (display_chapter_05());

 	game_save_no_timeout();
	sleep_until (volume_test_players (tv_prechopper_03)
	or
	volume_test_players (tv_prechopper_entire), 1);
	f_unblip_flag (prechopper_direction_flag);
end

script command_script enter_pod_cs()
	ai_vehicle_enter (sq_bubble_3_shade, (object_get_turret (prechopper_tower_pod, 2)));
	print ("entered pod"); 
end

script static void prechopper_player_leave_dialogue()
	sleep_until (volume_test_players (tv_lakeside_04)
	or
	s_bubbles_burst == 3);
	if 
		s_bubbles_burst < 3
	then
		thread (m40_palmer_off_map_nudge());
	end
end

script dormant spawn_prechopper()
	sleep_until (volume_test_players (tv_cliffside_retreat), 1);

	thread (cliffside_ai_kills ());

	sleep_until (volume_test_players (tv_prechopper_01), 1);
	wake (chopper_bypass_check);
	wake (unsc_prechopper_to_chopper_handoff);
	data_mine_set_mission_segment ("m40_prechopper");
	prechopper_obj_state=2; 
	ai_erase (lakeside_phantom_01);
	object_destroy (lakeside_cov_barrier_01);
	object_destroy (lakeside_cov_crate_01);
	object_destroy (lakeside_cov_crate_02);
	print ("spawning prechopper"); 
	sleep (30 * 1);
	garbage_collect_now();
	
	ai_place (sg_prechopper_starter);	
	ai_place (sq_prechopper_ghost_2_1);
	
	wake (prechopper_marine_fill);
	wake (f_bubble_2_player_check);
	wake (f_ghost_re);
	wake (f_infantry_re);
	wake (f_ridge_phantom_re);
	wake (f_blip_bubbles);

	object_create (prechopper_tower_base);
	object_create (prechopper_tower_pod);
	object_create (prechopper_barrier_01);
	object_create (prechopper_barrier_03);
	object_create (prechopper_barrier_04);
	object_create (prechopper_barrier_06);
	object_create (prechop_reserved_ghost_01);
	object_create_folder (prechopper_vehicles);
	sleep (30 * 1);
	
	object_set_persistent (sq_prechopper_ghost_1_1_veh, false);
	object_set_persistent (sq_prechopper_ghost_1_2_veh, false);
	object_set_persistent (sq_prechopper_ghost_2_1_veh, false);
	object_set_persistent (prechop_reserved_ghost_01, false);
	
 	thread(f_mus_m40_e04_begin());
 	thread (prechop_ending());
 	wake (m40_pre_chopper_01);

 	sleep_until (volume_test_players (tv_tort_rec_chopper_pt0), 1);	
 	thread(f_mus_m40_e04_finish());
end

script command_script sq_prechopper_ghost_1_1_cs()
	ai_vehicle_enter_immediate (sq_prechopper_ghost_1_1, sq_prechopper_ghost_1_1_veh);
	wake (reserve_sq_prechopper_ghost_1_1);
end

script command_script sq_prechopper_ghost_1_2_cs()
	ai_vehicle_enter_immediate (sq_prechopper_ghost_1_2, sq_prechopper_ghost_1_2_veh);
	wake (reserve_sq_prechopper_ghost_1_2);
end

script command_script sq_prechopper_ghost_2_1_cs()
	ai_vehicle_enter_immediate (sq_prechopper_ghost_2_1, sq_prechopper_ghost_2_1_veh);
	wake (reserve_sq_prechopper_ghost_2_1);
end

script command_script sq_prechopper_ghost_2_2_cs()
//	ai_vehicle_enter_immediate (sq_prechopper_ghost_2_2, sq_prechopper_ghost_2_2_veh);
	wake (reserve_sq_prechopper_ghost_2_2);
end

script command_script sq_prechopper_ghost_2_3_cs()
//	ai_vehicle_enter_immediate (sq_prechopper_ghost_2_3, sq_prechopper_ghost_2_3_veh);
	wake (reserve_sq_prechopper_ghost_2_3);
end



script dormant reserve_sq_prechopper_ghost_1_1()
	sleep_until (ai_living_count (sq_prechopper_ghost_1_1) < 1);
	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_prechopper_ghost_1_1), true);
end

script dormant reserve_sq_prechopper_ghost_1_2()
	sleep_until (ai_living_count (sq_prechopper_ghost_1_2) < 1);
	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_prechopper_ghost_1_2), true);
end

script dormant reserve_sq_prechopper_ghost_2_1()
	sleep_until (ai_living_count (sq_prechopper_ghost_2_1) < 1);
	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_prechopper_ghost_2_1), true);
end

script dormant reserve_sq_prechopper_ghost_2_2()
	sleep_until (ai_living_count (sq_prechopper_ghost_2_2) < 1);
	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_prechopper_ghost_2_2), true);
end

script dormant reserve_sq_prechopper_ghost_2_3()
	sleep_until (ai_living_count (sq_prechopper_ghost_2_3) < 1);
	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_prechopper_ghost_2_3), true);
end



script dormant f_ghost_re
	
	sleep_until ( ai_living_count (sg_prechopper_ghosts_1) < 2 and (not volume_test_players( tv_prechopper_safe_re )), 1 );
	ai_place (sq_prechopper_ghost_2_2);
	
	sleep_until ( ai_living_count (sg_prechopper_ghosts_1) < 1 and (not volume_test_players( tv_prechopper_safe_re )), 1 );
	ai_place (sq_prechopper_ghost_2_3);

end

script dormant f_infantry_re
	
	sleep_until ( ai_living_count (sg_prechopper_starter) < 9 and (not volume_test_players( tv_prechopper_safe_re )), 1 );
	sleep_until (	not (volume_test_players_all_lookat (tv_rear_sq_spawn, 3000, 40))	);
	print ("Bubble 3 Mid Re SPAWN");
	ai_place (sq_bubble_3_mid_re);
end

script dormant f_infantry_re_2
	sleep_until ( ai_living_count (sg_prechopper_starter) < 5 and (not volume_test_players( tv_prechopper_safe_2_re )), 1 );
	if
		s_bubbles_burst < 3
	then
		if
			not (volume_test_players_all_lookat (tv_rear_sq_spawn, 3000, 40))	
		then
			ai_place (sq_bubble_3_re_grunts);
		end
//		sleep_until ( ai_living_count (sq_stage) < 2
//		and
//		ai_living_count (sq_bubble_2) < 2
//		and
//		ai_living_count (sq_phantom_ridge) < 2
//		and
//		ai_living_count (sq_phantom_ridge_02) < 1	
//		);
//		if
//			s_bubbles_burst < 3
//		then
//			ai_place (sq_phantom_ridge_03);
//			print ("Bubble 3 Mid Re SPAWN");
//		end
	end
end

script dormant f_ridge_phantom_re
	
	sleep_until (ai_living_count (sg_starter_first) < 3);
	if
		chop_obj_state < 10
	then
		if
			game_coop_player_count() < 3
		then
			ai_place (sq_phantom_ridge);
			sleep( 30 * 5 );
			wake (prechopper_covenant_backup_01);
		end
	end
	
end


script command_script cs_phantom_ridge()
	print ("Phantom Ridge 1 BACKUP!");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_spawn', sq_phantom_ridge, 1);
	
	f_load_phantom( sq_phantom_ridge, "right", sq_ridge_re.guy1, NONE, sq_ridge_re.guy3, sq_ridge_re.guy4 );
	cs_fly_to (ps_phantom_ridge.p0);
	cs_fly_to (ps_phantom_ridge.p1);
	
	cs_fly_to_and_face (ps_phantom_ridge.p2, ps_phantom_ridge.face);
	f_unload_phantom (sq_phantom_ridge, right);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_takeoff', sq_phantom_ridge, 1);
	cs_fly_to (ps_phantom_ridge.p3);
	//object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120);
	cs_fly_to (ps_phantom_ridge.p4);
	cs_fly_by (ps_phantom_ridge.p8);
//	sleep( 30 * 3.0 );
	ai_erase(sq_phantom_ridge);		
	
end


script command_script phantom_ridge_02_cs()
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_2_spawn', sq_phantom_ridge_02, 1);
	print ("Phantom Ridge 2 BACKUP!");
	f_load_phantom( sq_phantom_ridge_02, "left", sq_ridge_re_02.guy1, sq_ridge_re_02.guy2, sq_ridge_re_02.guy3, sq_ridge_re_02.guy4 );
	cs_fly_by (ps_phantom_ridge.p5);
	cs_fly_to_and_face (ps_phantom_ridge.p6, ps_phantom_ridge.p7);
	f_unload_phantom (sq_phantom_ridge_02, left);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_2_takeoff', sq_phantom_ridge_02, 1);
	cs_fly_by (ps_phantom_ridge.p3);
	cs_fly_by (ps_phantom_ridge.p4);
	cs_fly_by (ps_phantom_ridge.p8);
	ai_erase(sq_phantom_ridge_02);		
	
end
script command_script phantom_ridge_03_cs()
	print ("Phantom Ridge 3 (BUBBLE) BACKUP!");
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_3_spawn', sq_phantom_ridge_03, 1);
	f_load_phantom( sq_phantom_ridge_03, "right", sq_bubble_3_re_inside.guy1, sq_bubble_3_re_inside.guy2, sq_bubble_3_re_inside.guy3, none );
	cs_fly_by (ps_phantom_ridge_03.p0);
	cs_fly_by (ps_phantom_ridge_03.p1);
	cs_fly_by (ps_phantom_ridge_03.p2);
	cs_fly_by (ps_phantom_ridge_03.p3);
	cs_fly_to_and_face (ps_phantom_ridge_03.p4, ps_phantom_ridge_03.p8);
	f_unload_phantom (sq_phantom_ridge_03, right);
	sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_phantmo_ridge_3_takeoff', sq_phantom_ridge_03, 1);
	cs_fly_by (ps_phantom_ridge_03.p5);
	cs_fly_by (ps_phantom_ridge_03.p6);
	cs_fly_by (ps_phantom_ridge_03.p7);
	ai_erase(sq_phantom_ridge_03);	
end

script dormant prechopper_all_enemies_killed()
	//sleep_until (ai_living_count (prechop_master_grp) < 1);
	if
	chop_obj_state < 60
	then
//	wake (m40_prechopper_done);
	print ("m40_prechopper_done");
	else
	sleep(1);
	end
end

script static void prechop_ending()
	sleep_until (volume_test_players (tv_prechopper_safe_re), 1);
	player_at_end_of_prechop = true;
end

script dormant prechop_marine_obj_handoff()
//	sleep_until (ai_living_count (prechop_master_grp) < 1
	//and
	//volume_test_players (tv_prechopper_05), 1);
	
	sleep_until (volume_test_players (tv_prechopper_05), 1);
	ai_set_objective (prechopper_marines_fill, chop_marines_convoy_obj);
	ai_set_objective (insertion_marines, chop_marines_convoy_obj);	
end


script dormant prechopper_marine_fill()
	if
		unit_in_vehicle_type (player0, 18)
		or
		unit_in_vehicle_type (player1, 18)		
		or
		unit_in_vehicle_type (player2, 18)		
		or
		unit_in_vehicle_type (player3, 18)		
		or
		ai_living_count (marine_convoy) < 3
		or
		volume_test_object (tv_tortoise_bottom_01, marines_main_hog_01_veh)
		or
		volume_test_object (tv_tortoise_bottom_01, marines_main_hog_02_veh)
	then
		print ("Prechopper_marines NOT placed");
	else
		sleep_until (not (volume_test_players_all_lookat (tv_prechopper_fill_spawn, 3000, 50)));
		ai_place (prechopper_marines_fill);
		print ("Prechopper_marines placed");
	end
end

script dormant prechopper_covenant_backup_01()
	sleep_until (ai_living_count (sq_ridge_re) < 2
	and
	(ai_living_count (sg_prechopper_ghosts_1) + ai_living_count (sg_prechopper_ghosts_2) < 2)
	and
	s_bubbles_burst < 3
	and
	ai_living_count (sq_phantom_ridge) < 1
	and
	player_at_end_of_prechop == FALSE	
	);
	if
		chop_obj_state < 10
	then
		ai_place (sq_phantom_ridge_02);
		wake (f_infantry_re_2);
	end	
end

script static void test_big()
	object_set_scale (test5, 50, 50);
end

script dormant prechopper_obj_states()
	sleep_until (volume_test_players (tv_prechopper_015), 1);
	prechopper_obj_state = 31;
	print ("set obj state 31"); 
	
	sleep_until (volume_test_players (tv_prechopper_03), 1);
	prechopper_obj_state = 32;
	print ("set obj state 32");
	
	sleep_until (volume_test_players (tv_prechopper_02)
	or
	volume_test_players (tv_prechopper_05), 1);
	prechopper_obj_state = 33; 
	print ("set obj state 33");
	
	sleep_until (volume_test_players (tv_prechopper_05), 1);
	prechopper_obj_state = 34; 
	print ("set obj state 34"); 

	f_unblip_flag (prechopper_direction_flag);
 	game_save_no_timeout();
 	wake (chopper_main_script);
	wake (chopper_obj_control_01);

end

script dormant f_temp

	ai_erase (lakeside_phantom_01);
	object_destroy (lakeside_cov_barrier_01);
	object_destroy (lakeside_cov_crate_01);
	object_destroy (lakeside_cov_crate_02);
	print ("spawning prechopper"); 
	sleep (30 * 1);
	garbage_collect_now();
	
	
	ai_place (sg_prechopper_starter);	
	ai_place (sq_prechopper_ghost_2_1);
	
	wake (f_bubble_control);
	wake (f_bubble_2_player_check);
	wake (f_ghost_re);
	wake (f_infantry_re);
	wake (f_ridge_phantom_re);
	wake (f_blip_bubbles);

end

script dormant unsc_prechopper_to_chopper_handoff()
	sleep_until(s_bubbles_burst == 3);
	ai_set_objective (marine_convoy, chop_marines_convoy_obj);
	ai_set_objective (marine_convoy_02, chop_marines_convoy_obj);
	ai_set_objective (prechopper_marines, chop_marines_convoy_obj);
	print ("Prechopper AI handed off to Chopper");
	
	object_create_folder (chop_crates);
	object_create_folder (chop_weapons);
end

script static void cliffside_ai_kills()

//EJECTS PLAYERS FROM MAMMOTH TURRETS SO THEY CAN BE TELEPORTED-----------------------
	if
		volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player0)
		and
		unit_in_vehicle (player0)
	then
		unit_exit_vehicle (player0);
		sleep_until (not (unit_in_vehicle (player0)));
	end
	
	if
		volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player1)
		and
		unit_in_vehicle (player1)
	then
		unit_exit_vehicle (player1);
		sleep_until (not (unit_in_vehicle (player1)));
	end

	if
		volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player2)
		and
		unit_in_vehicle (player2)
	then
		unit_exit_vehicle (player2);
		sleep_until (not (unit_in_vehicle (player2)));
	end
	
	if
		volume_test_object_bounding_sphere_center (tv_tortoise_top_01, player3)
		and
		unit_in_vehicle (player3)
	then
		unit_exit_vehicle (player3);
		sleep_until (not (unit_in_vehicle (player3)));
	end

//-------------------------------------------------------------------------------------------

	if
		volume_test_object (tv_cliffside_entire, player0)
	then
		if 
			unit_in_vehicle (player0)
		then
			object_teleport (unit_get_vehicle (player0), prechop_teleport_01);
		else
			object_teleport (player0, prechop_teleport_01);
		end
	end
	
	if
		volume_test_object (tv_cliffside_entire, player1)
	then
		if 
			unit_in_vehicle (player1)
		then
			object_teleport (unit_get_vehicle (player1), prechop_teleport_02);
		else
			object_teleport (player1, prechop_teleport_02);
		end
	end
	
	if
		volume_test_object (tv_cliffside_entire, player2)
	then
		if 
			unit_in_vehicle (player2)
		then
			object_teleport (unit_get_vehicle (player2), prechop_teleport_03);
		else
			object_teleport (player2, prechop_teleport_03);
		end
	end
	
	if
		volume_test_object (tv_cliffside_entire, player3)
	then
		if 
			unit_in_vehicle (player3)
		then
			object_teleport (unit_get_vehicle (player3), prechop_teleport_04);
		else
			object_teleport (player3, prechop_teleport_04);
		end
	end

	kill_volume_enable (playerkill_soft_prechop_backtrack);	

	thread (cliffside_01_kills());
	thread (cliffside_02_kills());
	thread (cliffside_03_kills());
	thread (cliffside_04_kills());
	thread (ai_kills_cliffside_ghosts_01());
	thread (ai_kills_cliffside_ghosts_02());
	
	thread (cliffside_master_cleanup());

	thread (objects_destroy_all_in_volume(tv_cliffside_entire));	

end

script static void cliffside_master_cleanup()
	sleep_until (not (volume_test_players_lookat (tv_cliffside_entire, 3000, 40))
	and
	not (volume_test_players (tv_cliffside_entire)));
	unit_kill_list_silent (volume_return_objects (tv_cliffside_entire));
	object_destroy_folder( cliffside_crates );
	thread (cliffside_destroy_test());
end

script static void cliffside_01_kills()
	sleep_until (not (volume_test_players (tv_cliffside_ai_kills_1))	
	and
	not (volume_test_players_all_lookat (tv_cliffside_ai_kills_1, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_cliffside_ai_kills_1));
	print ("tv_cliffside_ai_kills_1 killed");
end

script static void cliffside_02_kills()
	sleep_until (not (volume_test_players (tv_cliffside_ai_kills_2))	
	and
	not (volume_test_players_all_lookat (tv_cliffside_ai_kills_2, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_cliffside_ai_kills_2));
	print ("tv_cliffside_ai_kills_2 killed");
end

script static void cliffside_03_kills()
	sleep_until (not (volume_test_players (tv_cliffside_ai_kills_3))	
	and
	not (volume_test_players_all_lookat (tv_cliffside_ai_kills_3, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_cliffside_ai_kills_3));
	print ("tv_cliffside_ai_kills_3 killed");
end 

script static void cliffside_04_kills()
	sleep_until (not (volume_test_players (tv_cliffside_ai_kills_4))	
	and
	not (volume_test_players_all_lookat (tv_cliffside_ai_kills_4, 3000, 40)));
	unit_kill_list_silent (volume_return_objects (tv_cliffside_ai_kills_4));
	ai_erase (cliffside_phantom_01);
	ai_erase (cliffside_phantom_02);
	ai_kill_silent (cliffside_ghosts_01);
	ai_kill_silent (cliffside_ghosts_02);
	ai_kill_silent (cliffside_edge_sq_01);
	ai_kill_silent (cliffside_edge_sq_02);
	ai_kill_silent (cliffside_edge_sq_03);
	print ("tv_cliffside_ai_kills_4 killed and phantoms erased");
end

script static void ai_kills_cliffside_ghosts_01()
	if
		volume_test_object (tv_cliffside_ai_kills_4, ai_get_object (cliffside_ghosts_01.driver))
		and
		ai_in_vehicle_count (cliffside_ghosts_01.driver) > 0
	then
		print ("cliffside_ghosts_01 in volume, waiting for player to look away");
		sleep_until (not (volume_test_players_all_lookat (tv_cliffside_ai_kills_4, 3000, 40)));
		print ("player not looking, killing cliffside_ghosts_01");
		damage_object (ai_vehicle_get_from_spawn_point (cliffside_ghosts_01.driver), "hull", 1000);
		sleep_s (4);	
		garbage_collect_now();
		print ("garbage collected!");
	else
		print ("cliffside_ghosts_01 not in volume!");
	end
end

script static void ai_kills_cliffside_ghosts_02()
	if
		volume_test_object (tv_cliffside_ai_kills_4, ai_get_object (cliffside_ghosts_01.driver2))
		and
		ai_in_vehicle_count (cliffside_ghosts_01.driver2) > 0
	then
		print ("cliffside_ghosts_02 in volume, waiting for player to look away");
		sleep_until (not (volume_test_players_all_lookat (tv_cliffside_ai_kills_4, 3000, 40)));
		print ("player not looking, killing cliffside_ghosts_02");
		damage_object (ai_vehicle_get_from_spawn_point (cliffside_ghosts_01.driver2), "hull", 1000);
		sleep_s (4);	
		garbage_collect_now();
		print ("garbage collected!");
	else
		print ("cliffside_ghosts_02 not in volume!");
	end
end

script static void cliffside_UR_kills()
	ai_kill_silent (cliffside_ghosts_01);
	ai_kill_silent (cliffside_ghosts_02);
	ai_kill_silent (cliffside_edge_sq_01);
	ai_kill_silent (cliffside_edge_sq_02);
	ai_kill_silent (cliffside_edge_sq_03);
	print ("Cliffside AI Killed in messy way... don't use this for ship");
end

//--------------------prechopper command scripts-------------------


script command_script prechopper_tortoise_sc()
	cs_go_to (prechopper_tortoise_route_pt.p2);
	sleep_until (volume_test_players (tv_prechopper_02), 1);
	cs_go_to (prechopper_tortoise_route_pt.p3);
	sleep_until (prechopper_obj_state > 33);
	cs_go_to (prechopper_tortoise_route_pt.p3);
	sleep_until	
		(ai_living_count (prechopper_ghosts_backup) < 1
//		and
//		ai_living_count (prechopper_wraith_backup) < 1
		);
	cs_go_to (prechopper_tortoise_route_pt.p4);
end

script command_script prechopper_marines_fill_cs()
	print ("prechopper_marines_fill_cs");
	ai_vehicle_enter_immediate (prechopper_marines_fill.driver, prechopper_marines_fill_hog, "warthog_d");
	ai_vehicle_enter_immediate (prechopper_marines_fill.gunner, prechopper_marines_fill_hog, "warthog_g");
	cs_go_to (chopper_smash.p7);
end

script dormant prechopper_tortoise_recorded()
	print ("tortoise is on prechopper scripts");
	sleep_until (volume_test_object (tv_prechopper_01, main_mammoth)
	or
	volume_test_players (tv_prechopper_01_temp)
	, 1);

  thread (M40_chopper_lich_warning());

	f_blip_flag (prechopper_direction_flag, "default");
	
	unit_recorder_set_playback_rate_smooth (main_mammoth, .8, 4);	
	print ("TORT SPEED = .8");
	
//	sleep_until (volume_test_object (tv_tort_prechop_first_stop, main_mammoth));
//	print ("HIT!");
//	
//	sleep (30 * 3);

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 58.5, 1);

	print ("HIT!");
	
//	thread (unreserve_mammoth_vehicles());
	tort_hogs_reserve_bool = false;
	
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_d);
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	prechop_recording_loaded = true;
	thread (mam_dust_off());
	print ("tortoise_0526_d has been set up");
	
	if 
		s_bubbles_burst < 2
	then
		thread (open_tort_doors_prechopper_start());
		print ("Tort doors opening");
		sleep_until(s_bubbles_burst >= 1);
		unit_recorder_set_playback_rate_smooth (main_mammoth, .6, 4);	
		print ("TORT SPEED = .6");
		thread (close_tort_doors_prechopper_start());	
	else
		print ("Tort doors not opening at prechopper");
		sleep_until(s_bubbles_burst >= 1);
		unit_recorder_set_playback_rate_smooth (main_mammoth, .6, 4);	
		print ("TORT SPEED = .6");
	end
	sleep (30 * 2);
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
	tort_stopped = FALSE;
	
	sleep (30 * 5);
	
//	sleep_until (volume_test_object (tv_tort_rec_prechopper_pt0, main_mammoth));

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 22, 1);
	
	tort_hogs_reserve_bool = true;
	
	unit_recorder_pause_smooth (main_mammoth, true, 2);
	tort_stopped = TRUE;
	
	thread (reserve_mammoth_vehicles());
	
	sleep_until(s_bubbles_burst >= 2);
	sleep_forever (detect_players_after_cliffside);
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;


//	sleep_until (volume_test_object (tv_tort_prechop_last_stop, main_mammoth));
//	print ("HIT!");
//	
//	sleep (30 * 2);

	sleep_until (unit_recorder_get_time_position_seconds (main_mammoth) > 36, 1);

	print ("HIT!");
	
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_e);
	prechop_recording_loaded_2 = true;
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("tortoise_0716_e has been set up");

//	thread (open_tort_doors_prechopper_end());

	sleep_until(s_bubbles_burst >= 3);
//	thread (open_tort_doors_prechopper_end());
		
	wake (chop_tortoise_recorded);
	sleep_s(1);
	thread (new_tort_chopper_part_1_speed_test());
end

script dormant prechopper_tortoise_recorded_insertion()
//	sleep_until (volume_test_object (tv_tort_prechop_first_stop, main_mammoth));
//	print ("HIT!");
//	
//	sleep (30 * 3);
//	
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_d);
//	unit_recorder_play (main_mammoth);
//	unit_recorder_pause (main_mammoth, true);
//	tort_stopped = TRUE;
	prechop_recording_loaded = true;
	thread (mam_dust_off());
	print ("tortoise_0526_d has been set up");
	

	if 
		s_bubbles_burst < 2
	then
		thread (open_tort_doors_prechopper_start());
		print ("Tort doors opening");
		sleep_until(s_bubbles_burst >= 1);
		unit_recorder_set_playback_rate_smooth (main_mammoth, .4, 4);	
		print ("TORT SPEED = .4");
		thread (close_tort_doors_prechopper_start());	
	else
		print ("Tort doors not opening at prechopper");
		sleep_until(s_bubbles_burst >= 1);
		unit_recorder_set_playback_rate_smooth (main_mammoth, .4, 4);	
		print ("TORT SPEED = .4");
	end
	
	sleep (30 * 2);
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
	tort_stopped = FALSE;
	
	sleep (30 * 5);
	
	// just in case?
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
	tort_stopped = FALSE;
	print ("unpausing again?");
	
	sleep_until (volume_test_object (tv_tort_rec_prechopper_pt0, main_mammoth));
	unit_recorder_pause_smooth (main_mammoth, true, 2);
	tort_stopped = TRUE;
	
	sleep_until(s_bubbles_burst >= 2);
	sleep_forever (detect_players_after_cliffside);
	unit_recorder_pause_smooth (main_mammoth, false, 2);
	tort_stopped = FALSE;


	sleep_until (volume_test_object (tv_tort_prechop_last_stop, main_mammoth));
	print ("HIT!");
	
	sleep (30 * 2);
	
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_e);
	unit_recorder_play_and_blend (main_mammoth, 2);
	unit_recorder_pause (main_mammoth, true);
	tort_stopped = TRUE;
	thread (mam_dust_off());
	print ("tortoise_0203b has been set up");

//	thread (open_tort_doors_prechopper_end());

	sleep_until(s_bubbles_burst >= 3);
//	thread (open_tort_doors_prechopper_end());
		
	wake (chop_tortoise_recorded);
	sleep_s(1);
	thread (new_tort_chopper_part_1_speed_test());
end

//script dormant prechopper_tortoise_recorded_insertion()
//	sleep_until(s_bubbles_burst >= 1);
////	object_override_physics_motion_type(main_mammoth, 2);
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:closing", false);
//	tort_bay_doors_opened = false;	
//	sleep (30 * 3);
//	unit_recorder_pause_smooth (main_mammoth, false, 3);	
//	tort_stopped = FALSE;
//	
//	sleep_until (volume_test_object (tv_tort_rec_prechopper_pt0, main_mammoth));
//	unit_recorder_pause_smooth (main_mammoth, true, 3);
//	tort_stopped = TRUE;
//	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);	
//	tort_bay_doors_opened = true;
//	sleep (30 * 3);
//	object_override_physics_motion_type(main_mammoth, 1);
//	
//	sleep_until(s_bubbles_burst >= 2);
//	object_override_physics_motion_type(main_mammoth, 2);
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:closing", false);
//	tort_bay_doors_opened = false;	
//	sleep_forever (detect_players_after_cliffside);
//	unit_recorder_pause_smooth (main_mammoth, false, 2);
//	tort_stopped = FALSE;
//
//
//	sleep_until (volume_test_object (tv_prechopper_05, main_mammoth));
//	sleep (30 * 4);	
//	unit_recorder_pause_smooth (main_mammoth, true, 2);
//	tort_stopped = TRUE;
//
//	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_e);
//	unit_recorder_play (main_mammoth);
//	unit_recorder_pause (main_mammoth, true);
//	tort_stopped = TRUE;
//	thread (mam_dust_off());
//
//	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);	
//	tort_bay_doors_opened = true;
//	object_override_physics_motion_type(main_mammoth, 1);
//
//	sleep_until(s_bubbles_burst >= 3);
//	object_override_physics_motion_type(main_mammoth, 2);
//	custom_animation (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:closing", false);
//	tort_bay_doors_opened = false;	
//		
//	wake (chop_tortoise_recorded);
//	sleep_s(1);
//	wake (tort_chopper_repeating_speed_test);
//end

//-------------------------UTILITY--------------------------//
//
//script static void test_targeting()
//	if
//		volume_test_players (tv_bubble_1)
//		and
//		object_get_health (uplink_base_1) != -1
//	then
//		cs_shoot (object_get_ai (volume_return_objects (tv_bubble_1)), true, uplink_base_1);
//end