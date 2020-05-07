//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			donut
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short aa_fire = 5;
global short ledge_flank = 5;
global short playfighting = 10;
global short donut_switch_check = 0;
global short left1_obj_count = 0;
global short left2_obj_count = 0;
global short right1_obj_count = 0;
global short right2_obj_count = 0;
global short final_obj_count = 0;
global boolean b_phantom_in_place = FALSE;
global boolean b_commander_has_shot = FALSE;
global boolean b_right1_covenant_advance = FALSE;
global boolean b_cryptum_cinematic_go = FALSE;
global boolean b_right_side2_knights_dead = FALSE;
global boolean b_donut_left_door_button_hit = FALSE;
global boolean b_donut_right_door_button_hit = FALSE;
global object g_ics_player2 = NONE;

// =================================================================================================
// =================================================================================================
// *** DONUT ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_donut()	
	sleep_until (volume_test_players (tv_insertion_wake_donut), 1);
	dprint  ("::: donut start :::");
//	wake (camera_shake_donut);
	wake (cryptum_obj_blip);
//	wake (ambient_turrets);
	wake (left_side_spawn_1);
	wake (left_side_spawn_2);
	wake (left_room_checkpoint);
	wake (final_knight_fight);
	wake (right_side_spawn_1);
	wake (right_side_spawn_2);
	wake (right_room_checkpoint);
	wake (left_endramp_save);
	wake (right_endramp_save);
	wake (phantom_flybys);
	wake (left2_obj_count_10);
	wake (right2_obj_count_10);
	wake (m30_donut_enter); //Narrative Scripting
	wake (f_donut_repeating_gc);

	game_save_no_timeout();
	ai_lod_full_detail_actors (24);
	data_mine_set_mission_segment ("m30_donut");
	m30_donut_grinder->f_animate();
	thread (donut_door_activate());	
	thread (f_mus_m30_e08_start());
	
	device_set_position_immediate (donut_left_elevator_01, 0);
	device_set_power (donut_left_elevator_01, 0);
	device_set_position_immediate (donut_right_elevator_01, 0);
	device_set_power (donut_right_elevator_01, 0);
	dprint ("elevators turned off");
	
	Object_set_function_variable (m30_donut_grinder, electricity_on, 1, 0);
	
	game_insertion_point_unlock (9);
	dprint ("you unlocked the Donut Insertion Point!");
	
	if game_difficulty_get_real() == "legendary" then		
		wake (donut_jackal_check);
	else	
		sleep (1);
	end
	
	kill_script (ghost_boost_help);
	kill_script (destroy_all_banshees);
	
end

// ====================================================================
// DONUT DOORS =================================================
// ====================================================================

script static void donut_door_activate()
	dprint ("donut_door_activate is a go");

	wake (donut_door_failsafe);

	sleep_until ((ai_task_status (cov_skirmish.parent) == ai_task_status_exhausted) or (donut_skirmish_task_check()) or (b_donut_fight_failsafe == TRUE), 1);
	
	dprint ("covvies are dead, blipping and activating switches");
	sleep_forever (donut_door_failsafe);
	
	sleep (60);

	f_blip_flag (donut_left_door_flag, "activate");
	f_blip_flag (donut_right_door_flag, "activate");
	device_group_set_immediate (left_front_door_group, 1);
	device_group_set_immediate (right_front_door_group, 1);
	thread (donut_door_logic());
//	thread (donut_left_door_open());
	//thread (donut_right_door_open());
	
end

script static boolean donut_skirmish_task_check()

	ai_task_status (cov_skirmish.parent) == ai_task_status_empty and ai_task_status (cov_skirmish.sniper) == ai_task_status_empty and ai_task_status (cov_skirmish.grunts) == ai_task_status_empty;

end

global boolean b_donut_fight_failsafe = FALSE;

script dormant donut_door_failsafe
	sleep_until (volume_test_players (tv_donut_skirmish_timer), 1);
	
	sleep (30 * 60);
	
	dprint ("door lock failsafe timer triggered");
	b_donut_fight_failsafe = TRUE;
	
end

script static void f_activator_get_2( object trigger, unit activator )
	g_ics_player2 = activator;
end

script static void donut_door_logic()
	
	inspect (device_get_position (donut_right_front_door));
  dprint ("right door status above");
  inspect (device_get_position (donut_left_front_door));
  dprint ("left door status above");
	
	sleep_until ((device_get_position (donut_right_front_door) != 0) or (device_get_position (donut_left_front_door) != 0), 1);
	//sleep_until (device_get_position (donut_left_front_door) != 0);

	inspect (device_get_position (donut_right_front_door));
  dprint ("right door status above");
  inspect (device_get_position (donut_left_front_door));
  dprint ("left door status above");

	sleep (5);

		//if the right door is hit and opening

	
		//if the left door is hit and opening
		if (device_get_position (donut_left_front_door) != 0) then
	
			device_group_set_immediate (left_front_door_group, 0);
			device_group_set_immediate (right_front_door_group, 0);
			dprint ("left door opening, right door locked");
		
			f_unblip_flag (donut_left_door_flag);
			f_unblip_flag (donut_right_door_flag);
			dprint ("button press anim go!");
			pup_play_show ("left_button_press");

			sleep (60);
	
			pup_play_show ("left_door_open");
		
			sleep (1);
		
			thread (f_donut_left_door_2_open());
			thread (f_donut_left_door_3_open());	
			
		elseif (device_get_position (donut_right_front_door) != 0) then
	
			device_group_set_immediate (right_front_door_group, 0);
			device_group_set_immediate (left_front_door_group, 0);
			dprint ("right door opening, left door locked");
	
			f_unblip_flag (donut_left_door_flag);
			f_unblip_flag (donut_right_door_flag);
	
			dprint ("button press anim go!");
			pup_play_show ("right_button_press");

			sleep (60);

			pup_play_show ("right_door_open");
	
			sleep (1);
	
			thread (f_donut_right_door_2_open());
			thread (f_donut_right_door_3_open());	

		end
	
end

script static void donut_left_door_open()
	
	sleep_until (device_get_position (donut_left_front_door) != 0);
	
	sleep (5);
	
	if (device_get_position (donut_right_front_door) != 1) then
	
		device_group_set_immediate (left_front_door_group, 0);
		device_group_set_immediate (right_front_door_group, 0);
		sleep_forever (donut_right_door_open);
		
		f_unblip_flag (donut_left_door_flag);
		f_unblip_flag (donut_right_door_flag);
		dprint ("button press anim go!");
		pup_play_show ("left_button_press");

		sleep (60);
	
		dprint ("left door opening, right door locked");
		pup_play_show ("left_door_open");
	
		sleep (1);
		
		thread (f_donut_left_door_2_open());
		thread (f_donut_left_door_3_open());
	
	elseif (device_get_position (donut_right_front_door) != 0) then
	
		device_group_set_immediate (left_front_door_group, 1);
		
		thread (donut_left_door_open());
		
	end
	
end

script static void donut_right_door_open()
	
	sleep_until (device_get_position (donut_right_front_door) != 0);
	
	sleep (5);
	
	if 	(device_get_position (donut_left_front_door) != 1) then
		
		device_group_set_immediate (right_front_door_group, 0);
		device_group_set_immediate (left_front_door_group, 0);
		sleep_forever (donut_left_door_open);	
	
		f_unblip_flag (donut_left_door_flag);
		f_unblip_flag (donut_right_door_flag);
	
		dprint ("button press anim go!");
		pup_play_show ("right_button_press");

		sleep (60);
	
		dprint ("right door opening, left door locked");
		pup_play_show ("right_door_open");
	
		sleep (1);
	
		thread (f_donut_right_door_2_open());
		thread (f_donut_right_door_3_open());
	
	elseif (device_get_position (donut_right_front_door) != 0) then
	
		device_group_set_immediate (right_front_door_group, 1);
		
		thread (donut_right_door_open());
	
	end
	
end

script static void f_donut_left_door_2_open()
	sleep_until (volume_test_players (tv_donut_left_door_2_open), 1);

	donut_door_left_02->open_slow();
	
	thread (f_donut_left_door_2_close());
end

script static void f_donut_left_door_2_close()
	sleep_until (volume_test_players (tv_donut_left_door_2_close), 1);

	donut_door_left_02->close_slow();
	
	thread (f_donut_left_door_2_open());
end

script static void f_donut_left_door_3_open()
	sleep_until (volume_test_players (tv_donut_left_door_3_open), 1);

	donut_door_left_03->open_slow();
	
	thread (f_donut_left_door_3_close());
end

script static void f_donut_left_door_3_close()
	sleep_until (volume_test_players (tv_donut_left_door_3_close), 1);

	donut_door_left_03->close_slow();
	
	thread (f_donut_left_door_3_open());
end



script static void f_donut_right_door_2_open()
	sleep_until (volume_test_players (tv_donut_right_door_2_open), 1);

	donut_door_right_02->open_slow();
	
	thread (f_donut_right_door_2_close());
end

script static void f_donut_right_door_2_close()
	sleep_until (volume_test_players (tv_donut_right_door_2_close), 1);

	donut_door_right_02->close_slow();
	
	thread (f_donut_right_door_2_open());
end

script static void f_donut_right_door_3_open()
	sleep_until (volume_test_players (tv_donut_right_door_3_open), 1);

	donut_door_right_03->open_slow();
	
	thread (f_donut_right_door_3_close());
end

script static void f_donut_right_door_3_close()
	sleep_until (volume_test_players (tv_donut_right_door_3_close), 1);

	donut_door_right_03->close_slow();
	
	thread (f_donut_right_door_3_open());
end

// ====================================================================
// GARBAGE COLLECTION =================================================
// ====================================================================

script dormant f_donut_repeating_gc()
	sleep_until (volume_test_players (tv_donut_garbage), 1);
		
		repeat
		
			sleep( 30 * 30 );
			dprint( "Garbage collecting..." );
			add_recycling_volume_by_type (tv_donut_garbage, 1, 10, 1 + 2 + 1024);
		
		until (not volume_test_players (tv_donut_garbage), 1);	

end

// ====================================================================
// OBJECTIVE COUNT CHANGES ============================================
// ====================================================================

script dormant left2_obj_count_10
	sleep_until (volume_test_players (tv_left2_obj_10), 1);
	
	dprint ("left2_obj_count set to 10");
	left2_obj_count = 10;
	
end

script dormant right2_obj_count_10
	sleep_until (volume_test_players (tv_right2_obj_10), 1);
	
	dprint ("right2_obj_count set to 10");
	right2_obj_count = 10;
	
end

// ====================================================================
// PLAYFIGHTING STUFF =================================================
// ====================================================================

script command_script donut_playfighting
	unit_only_takes_damage_from_players_team (ai_current_actor, TRUE);
end

// ====================================================================
// AMBIENT SCRIPTS ====================================================
// ====================================================================

script dormant camera_shake_donut()
	sleep_until (volume_test_players (tv_donut_ambience), 1);
	sleep (random_range (120, 300));
	thread(start_camera_shake_loop (medium, long)); 
	sleep (random_range (120, 300));
	thread(start_camera_shake_loop (weak, long));
end

script dormant cryptum_obj_blip()
	sleep_until (volume_test_players (tv_cryptum_obj1) or volume_test_players (tv_cryptum_obj2), 1);
	
	f_blip_flag (cryptum_button_flag, "activate");
	
	device_group_set_immediate (cryptum_controlgroup, 1);
	
	object_hide (cryptum_activate_button, TRUE);
	
	wake (cryptum_activate);
end

script dormant cryptum_activate()
	sleep_until (device_get_position (cryptum_activate_button) != 0);
	sleep_forever(f_dialog_m30_cryptum_approach);
	kill_script(f_dialog_m30_cryptum_approach);
	f_unblip_flag (cryptum_button_flag);
	donut_switch_check = 15;
	dprint ("g_ics_player is set to player");
	sleep (5);
	local long show = pup_play_show(cryptum);	
	device_group_set_immediate (cryptum_controlgroup, 0);
		

		
	//sleep_until (not pup_is_playing(show) , 1);
	

	
end

script dormant donut_jackal_check
		repeat
		sleep_until (volume_test_players (tv_jackal_check), 1);
	
		sleep (30 * 5);
		
		if
			
			volume_test_players (tv_jackal_check)
		
		then

			dprint ("boop");
			sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );			
			object_create (portal_crate_2);
			sleep (1);
			sleep_until(object_get_health(portal_crate_2) < 1 , 1);
  		sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
			object_destroy (portal_crate_2);
			object_create (portal_crate_3);
			sleep (1);
			sleep_until(object_get_health(portal_crate_3) < 1 , 1);
  		sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
  		object_destroy (portal_crate_3);

  		sleep (5);
  
			sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );

 			object_create (old_debug_rack_2);
			object_create (old_debug_rack_3);

		end

	until (object_valid (old_debug_rack_2) or volume_test_players (tv_left_spawn_1) or volume_test_players (tv_right_spawn_1), 1);
	
end

script dormant ambient_turrets()
	sleep_until (volume_test_players (tv_donut_ambience), 1);
	
	ai_place (aa_turret_left_1);
	vehicle_hover (aa_turret_left_1, TRUE);
	ai_disregard (ai_actors(aa_turret_left_1), TRUE);

	ai_place (aa_turret_left_2);
	vehicle_hover (aa_turret_left_2, TRUE);
	ai_disregard (ai_actors(aa_turret_left_2), TRUE);
	
	ai_place (aa_turret_left_3);
	vehicle_hover (aa_turret_left_3, TRUE);
	ai_disregard (ai_actors(aa_turret_left_3), TRUE);
	
	ai_place (aa_turret_left_4);
	vehicle_hover (aa_turret_left_4, TRUE);
	ai_disregard (ai_actors(aa_turret_left_4), TRUE);
	
	ai_place (aa_turret_right_1);
	vehicle_hover (aa_turret_right_1, TRUE);
	ai_disregard (ai_actors(aa_turret_right_1), TRUE);

	ai_place (aa_turret_right_2);
	vehicle_hover (aa_turret_right_2, TRUE);
	ai_disregard (ai_actors(aa_turret_right_2), TRUE);
	
	ai_place (aa_turret_right_3);
	vehicle_hover (aa_turret_right_3, TRUE);
	ai_disregard (ai_actors(aa_turret_right_3), TRUE);
	
	ai_place (aa_turret_right_4);
	vehicle_hover (aa_turret_right_4, TRUE);
	ai_disregard (ai_actors(aa_turret_right_4), TRUE);
	
end

// ====================================================
// GAME SAVES
// ====================================================

script dormant left_endramp_save()
	sleep_until (volume_test_players (tv_final_ramp_left_save), 1);
	
	thread (donut_left_area1_cleanup());
	thread (donut_left_area2_cleanup());
	
	game_save_no_timeout();
end

script dormant right_endramp_save()
	sleep_until (volume_test_players (tv_final_ramp_right_save), 1);	

	thread (donut_right_area1_cleanup());
	thread (donut_right_area2_cleanup());

	game_save_no_timeout();
end

// ====================================================
// PHANTOM SPAWNING
// ====================================================

script dormant phantom_flybys()
	print ("phantom flybys set up");
	//ai_place (phantom_flyby_3);
	sleep_until (volume_test_players (tv_donut_ambience), 1);
	print ("incoming phantom flybys");
	ai_place (phantom_flyby_3);
	sleep (30);
	ai_place (phantom_flyby_1);
//	ai_place (phantom_flyby_4);
	sleep (30);
	ai_place (phantom_flyby_2);
	sleep (30 * 2);

end


// ====================================================
// PHANTOM COMMAND SCRIPTS
// ====================================================

script command_script cs_phantom_flyby_1
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_flyby_1.p0);
	cs_fly_to (ps_phantom_flyby_1.p1);
	cs_pause (1.0);
	cs_fly_to (ps_phantom_flyby_1.p3);
	cs_fly_to (ps_phantom_flyby_1.p4);
	cs_fly_to (ps_phantom_flyby_1.p5);
	cs_fly_to (ps_phantom_flyby_1.p6);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 180);
	sleep (180);
	ai_erase (phantom_flyby_1);
end

script command_script cs_phantom_flyby_2
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_flyby_2.p0);
	cs_fly_to (ps_phantom_flyby_2.p1);
	cs_pause (2.0);
	cs_fly_to (ps_phantom_flyby_2.p2);
	cs_fly_to (ps_phantom_flyby_2.p3);
	cs_fly_to (ps_phantom_flyby_2.p4);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 180);
	sleep (180);
	ai_erase (phantom_flyby_2);
end

script command_script cs_phantom_flyby_3
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 90);
	
	ai_place (phantom_cov_skirmish_grunts);
	ai_place (phantom_cov_skirmish_jackal);
	
	//f_load_phantom (ai_vehicle_get(ai_current_actor),	"left", phantom_cov_skirmish_grunts, phantom_cov_skirmish_jackal, none, none);
	
	sleep_until (ai_living_count (phantom_cov_skirmish_grunts) > 0 and ai_living_count (phantom_cov_skirmish_jackal) > 0);
		
	ai_vehicle_enter_immediate ( phantom_cov_skirmish_grunts, phantom_flyby_3, "phantom_p_lb" );
	ai_vehicle_enter_immediate ( phantom_cov_skirmish_jackal, phantom_flyby_3, "phantom_p_lf" );

	cs_fly_to (ps_phantom_flyby_3.p2);
	cs_fly_to_and_face (ps_phantom_flyby_3.p3, ps_phantom_flyby_3.p4);
	f_unload_phantom (ai_vehicle_get(ai_current_actor),	"left");
	sleep (30);
	cs_fly_to (ps_phantom_flyby_3.p5);
	cs_fly_to (ps_phantom_flyby_3.p6);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 240);
	sleep (240);
	ai_erase (phantom_flyby_3);
	
end

script command_script cs_phantom_3_jackal_left
	
	cs_move_towards_point (ps_skirmish_moves.p0, 0.2);
	cs_move_towards_point (ps_skirmish_moves.p1, 0.2);
	cs_move_towards_point (ps_skirmish_moves.p2, 0.2);
	
	ai_erase (ai_current_actor);
	
end

script command_script cs_phantom_3_jackal_right
	
	cs_move_towards_point (ps_skirmish_moves.p3, 0.2);
	cs_move_towards_point (ps_skirmish_moves.p4, 0.2);
	cs_move_towards_point (ps_skirmish_moves.p5, 0.2);
	
	ai_erase (ai_current_actor);
	
end

script command_script cs_phantom_flyby_4
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_flyby_4.p0);
	cs_fly_to (ps_phantom_flyby_4.p1);
	cs_fly_to (ps_phantom_flyby_4.p2);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_flyby_4.p2);
	damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), hull, 10000);
end


// ====================================================
// AA TURRET COMMAND SCRIPTS
// ====================================================

script command_script aa_turret_left_1_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_left_1.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_1.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_left_1.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_1.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_left_2_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_left_2.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_2.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_left_2.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_2.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_left_3_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_left_3.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_3.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_left_3.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_3.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_left_4_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_left_4.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_4.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_left_4.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_left_4.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_right_1_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_right_1.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_1.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_right_1.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_1.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_right_2_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_right_2.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_2.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_right_2.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_2.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_right_3_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_right_3.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_3.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_right_3.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_3.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

script command_script aa_turret_right_4_shoot()
	repeat
		cs_shoot_point (TRUE, ps_turret_right_4.p0);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_4.p1);
		sleep (random_range (15, 90));	
		cs_shoot_point (TRUE, ps_turret_right_4.p2);
		sleep (random_range (15, 90));
		cs_shoot_point (TRUE, ps_turret_right_4.p3);
		sleep (random_range (15, 90));
	until (1 == 0);
end

// ====================================================
// LEFT SIDE - NEW VERSION
// ====================================================

script dormant left_side_spawn_1()
	sleep_until (volume_test_players (tv_left_spawn_1), 1);
	
	thread (f_mus_m30_e08_finish());
	thread (f_mus_m30_e09_start());
	
	game_save();
	
	ai_place (area1_left_cov_1);
	ai_prefer_target_team (area1_left_cov_1, forerunner);
	ai_place (area1_left_cov_2);
	ai_prefer_target_team (area1_left_cov_2, forerunner);
	ai_place (area1_left_cov_3);
	ai_prefer_target_team (area1_left_cov_3, forerunner);
	ai_place (area1_left_cov_4);
	ai_prefer_target_team (area1_left_cov_4, forerunner);
	
	ai_place (area1_left_fore_1);
	ai_disregard (ai_actors(area1_left_fore_1), TRUE);
	ai_place (area1_left_fore_2);
	unit_only_takes_damage_from_players_team (area1_left_fore_2, TRUE);
	ai_prefer_target_team (area1_left_fore_2, covenant);
	ai_allow_resurrect (area1_left_fore_2, FALSE);
	ai_place (area1_left_fore_3);
	unit_only_takes_damage_from_players_team (area1_left_fore_3, TRUE);
	ai_prefer_target_team (area1_left_fore_3, covenant);
	ai_place (area1_left_fore_4);
	unit_only_takes_damage_from_players_team (area1_left_fore_4, TRUE);
	ai_prefer_target_team (area1_left_fore_4, covenant);
	ai_place (area1_left_fore_5);
	unit_only_takes_damage_from_players_team (area1_left_fore_5, TRUE);
	ai_prefer_target_team (area1_left_fore_5, covenant);
	
	sleep (5);
	
	AutomatedTurretActivate (ai_vehicle_get(area1_left_fore_1.spawn_points_0));
	
	wake (left_encounter_1_over_save);
	
end

script static void donut_left_area1_cleanup()
	dprint ("attempting to clean up donut_left_side, area1");
	f_ai_garbage_kill (area1_left_cov_1, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_cov_2, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_cov_3, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_cov_4, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_fore_1, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_fore_2, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_fore_3, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_fore_4, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_left_fore_5, 5, -1, -1, -1, TRUE);
end

script dormant left_encounter_1_over_save()

	sleep_until 
	(
	ai_living_count (left_area1_center_cov) == 0 and
	ai_living_count (left_area1_ledge_cov) == 0 and
	ai_living_count (area1_left_fore_1) == 0 and
	ai_living_count (area1_left_fore_2) == 0 and
	ai_living_count (area1_left_fore_3) == 0 and
	ai_living_count (area1_left_fore_4) == 0 and
	ai_living_count (area1_left_fore_5) == 0
	);
	
	game_save_no_timeout();
	
end

script dormant left_room_checkpoint()
	sleep_until (volume_test_players (tv_left_spawn_2), 1);
	wake (donut_left_side_elevator_poweron);
	sleep_forever (left_encounter_1_over_save);
	thread (donut_left_area1_cleanup());
	wake (final_right_side_cov_spawn);
	sleep (5);
	game_save_no_timeout();
end

script dormant donut_left_side_elevator_poweron
	
	sleep_until (volume_test_players (tv_left_elevator), 1);
		
	device_set_power (donut_left_elevator_01, 1);
	
end


script dormant left_side_objcon
	sleep_until (volume_test_players (tv_left1_obj_10), 1);
	
	left1_obj_count = 10;
	dprint ("left1_obj_count = 10");
	
end

script dormant left_side_spawn_2()
	sleep_until (volume_test_players (tv_left_spawn_2), 1);
	
	ai_place (area2_left_cov_1);
	ai_place (area2_left_cov_2);
	ai_place (area2_left_cov_3);
	ai_place (area2_left_cov_4);
	
	ai_place (area2_left_fore_1);
	unit_only_takes_damage_from_players_team (area2_left_fore_1, TRUE);
	ai_prefer_target_team (area2_left_fore_1, covenant);
	ai_place (area2_left_fore_2);
	unit_only_takes_damage_from_players_team (area2_left_fore_2, TRUE);
	ai_prefer_target_team (area2_left_fore_2, covenant);
	ai_place (area2_left_fore_3);
	unit_only_takes_damage_from_players_team (area2_left_fore_3, TRUE);
	ai_prefer_target_team (area2_left_fore_3, covenant);
	ai_place (area2_left_fore_4);
	unit_only_takes_damage_from_players_team (area2_left_fore_4, TRUE);
	ai_prefer_target_team (area2_left_fore_4, covenant);
	//ai_place (area2_left_fore_5);
	//unit_only_takes_damage_from_players_team (area2_left_fore_5, TRUE);
	//ai_prefer_target_team (area2_left_fore_5, covenant);
	//ai_disregard (ai_actors(area2_left_fore_5), TRUE);
	
	wake (left_encounter_2_over_save);
	
	sleep (5);
	
	AutomatedTurretActivate (ai_vehicle_get(area2_left_fore_5.spawn_points_0));

end

script dormant left_encounter_2_over_save()

	sleep_until 
	(
	ai_living_count (area2_left_cov_1) == 0 and
	ai_living_count (area2_left_cov_2) == 0 and
	ai_living_count (area2_left_cov_3) == 0 and
	ai_living_count (area2_left_cov_4) == 0 and
	ai_living_count (area1_left_fore_1) == 0 and
	ai_living_count (area1_left_fore_2) == 0 and
	ai_living_count (area1_left_fore_3) == 0 and
	ai_living_count (area1_left_fore_4) == 0 and
	ai_living_count (area1_left_fore_5) == 0
	);
	
	game_save_no_timeout();
	
end

script static void donut_left_area2_cleanup()
	dprint ("attempting to clean up donut_left_side, area2");
	f_ai_garbage_kill (area2_left_cov_1, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_cov_2, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_cov_3, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_cov_4, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_fore_1, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_fore_2, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_fore_3, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_fore_4, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_left_fore_5, 5, -1, -1, -1, FALSE);
end


// ====================================================
// RIGHT SIDE - NEW VERSION
// ====================================================

script dormant right_side_spawn_1()
	sleep_until (volume_test_players (tv_right_spawn_1), 1);
	
	thread (f_mus_m30_e08_finish());
	thread (f_mus_m30_e10_start());
	
	game_save();
	
	ai_place (phantom_crash_1);
	
	ai_place (area1_right_cov_1);
	unit_only_takes_damage_from_players_team (area1_right_cov_1, TRUE);
	ai_place (area1_right_cov_2);
	unit_only_takes_damage_from_players_team (area1_right_cov_2, TRUE);
	ai_place (area1_right_cov_3);
	unit_only_takes_damage_from_players_team (area1_right_cov_3, TRUE);
	
	ai_place (area1_right_fore_1);
	ai_disregard (ai_actors(area1_right_fore_1), TRUE);
	ai_place (area1_right_fore_2);
	ai_place (area1_right_fore_3);
	ai_place (area1_right_fore_4);
	ai_place (area1_right_fore_5);
	
	sleep (5);
	
	AutomatedTurretActivate (ai_vehicle_get(area1_right_fore_1.spawn_points_0));

end

script dormant right_encounter_1_over_save()
	
	sleep_until 
	(
	ai_living_count (area1_right_cov_1) == 0 and
	ai_living_count (area1_right_cov_2) == 0 and
	ai_living_count (area1_right_cov_3) == 0 and
	ai_living_count (area1_right_fore_1) == 0 and
	ai_living_count (area1_right_fore_2) == 0 and
	ai_living_count (area1_right_fore_3) == 0 and
	ai_living_count (area1_right_fore_4) == 0 and
	ai_living_count (area1_right_fore_5) == 0
	);
	
	game_save_no_timeout();

end

script static void right_side_1_debris_move()
	dprint ("boom.");
	ai_kill (area1_right_fore_2);
	ai_kill (area1_right_fore_3);
	ai_kill (area1_right_fore_4);
	ai_kill (area1_right_fore_5);
	sleep (30 * 3);
	object_create (fore_coil_1);
	object_create (fore_coil_2);
	//object_create (fore_coil_3);
	//object_create (fore_coil_4);
	//object_create (fore_coil_5);
	sleep (5);
	damage_object (fore_coil_1, "default", 10000);
	damage_object (fore_coil_2, "default", 10000);
	//damage_object (fore_coil_3, "default", 10000);
	//damage_object (fore_coil_4, "default", 10000);
	//damage_object (fore_coil_5, "default", 10000);
	
	sleep (30 * 2);
	add_recycling_volume (tv_rightside1_recycle, 1, 5);

end


script static void donut_right_area1_cleanup()
	dprint ("attempting to clean up donut_right_side, area1");
	f_ai_garbage_kill (area1_right_cov_1, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_cov_2, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_cov_3, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_fore_1, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_fore_2, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_fore_3, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_fore_4, 5, -1, -1, -1, TRUE);
	f_ai_garbage_kill (area1_right_fore_5, 5, -1, -1, -1, TRUE);
end

script command_script donut_phantom_crash_1
	cs_shoot (TRUE);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 90);
	cs_fly_to (ps_phantom_crash_1.p0);
	cs_fly_to (ps_phantom_crash_1.p1);
	
	b_phantom_in_place = TRUE;
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\phantom_crash\phantom_cliff_explosion1.effect, ps_phantom_crash_1.p1); 
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_phantom_crash_1.p1);
	
	cs_fly_to (ps_phantom_crash_1.p4);
	
	b_right1_covenant_advance = TRUE;
	thread (right_side_1_debris_move());
	damage_object (coil_4, "default", 10000);
	damage_object (coil_5, "default", 10000);
	damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), hull, 10000);
	

	
end

script dormant right_side_spawn_2()
	sleep_until (volume_test_players (tv_right_spawn_2), 1);
	
	wake (donut_right_side_elevator_poweron);

	ai_place (area2_right_cov_1);
	unit_only_takes_damage_from_players_team (area2_right_cov_1, TRUE);
	ai_place (area2_right_cov_2);
	unit_only_takes_damage_from_players_team (area2_right_cov_2, TRUE);
	ai_place (area2_right_cov_3);
	unit_only_takes_damage_from_players_team (area2_right_cov_3, TRUE);
	
	//ai_place (area2_right_fore_1);
	//ai_disregard (ai_actors(area2_right_fore_1), TRUE);
	b_right_side2_knights_dead = FALSE;
	ai_place (area2_right_fore_2);
	ai_place (area2_right_fore_3);
	ai_place (area2_right_fore_4);

	AutomatedTurretActivate (ai_vehicle_get(area2_right_fore_1.spawn_points_0));

	sleep_until (volume_test_players (tv_donut_right_door_3_close), 1);

	sleep (30 * 2);

	ai_place (phantom_right_side2_flank);

end

script dormant right_encounter_2_over_save()
	
	sleep_until 
	(
	ai_living_count (area2_right_cov_1) == 0 and
	ai_living_count (area2_right_cov_2) == 0 and
	ai_living_count (area2_right_cov_3) == 0 and
	ai_living_count (area2_right_fore_1) == 0 and
	ai_living_count (area2_right_fore_2) == 0 and
	ai_living_count (area2_right_fore_3) == 0 and
	ai_living_count (area2_right_fore_4) == 0
	);
	
	game_save_no_timeout();

end

script dormant donut_right_side_elevator_poweron
	
	sleep_until (volume_test_players (tv_right_elevator), 1);
	
	device_set_power (donut_right_elevator_01, 1);
	
end

script static void donut_right_area2_cleanup()
	dprint ("attempting to clean up donut_right_side, area2");
	f_ai_garbage_kill (area2_right_cov_1, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_cov_2, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_cov_3, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_fore_1, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_fore_2, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_fore_3, 5, -1, -1, -1, FALSE);
	f_ai_garbage_kill (area2_right_fore_4, 5, -1, -1, -1, FALSE);

end

script command_script right_side2_flank_phantom
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 60);
	cs_fly_to_and_face (ps_phantom_flank.p0, ps_phantom_flank.p1);
	unit_set_current_vitality (area2_right_fore_2, 0.1, 0.1);
	unit_set_current_vitality (area2_right_fore_3, 0.1, 0.1);
	unit_set_current_vitality (area2_right_fore_4, 0.1, 0.1);
	cs_fly_to_and_face (ps_phantom_flank.p2, ps_phantom_flank.p3);
	
	cs_vehicle_speed (0.15);
	cs_fly_to_and_dock (ps_phantom_flank.p2, ps_phantom_flank.p3, 2);
	
	thread (right_side2_knight_weakening());
	
	sleep_until (b_right_side2_knights_dead == TRUE or volume_test_players (tv_right_endpath_spawn), 1);
	
	sleep (30 * 2);
	
	cs_vehicle_speed (1);
	cs_fly_to_and_face (ps_phantom_flank.p2, ps_phantom_flank.p3);
	cs_fly_to_and_face (ps_phantom_flank.p0, ps_phantom_flank.p1);
	cs_fly_to_and_face (ps_phantom_flank.p4, ps_phantom_flank.p1);
	
	object_set_scale (ai_vehicle_get(ai_current_actor), 1, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 90);
	
	sleep (90);
	
	ai_erase (phantom_right_side2_flank);
	dprint ("bye bye");
	
end

script static void right_side2_knight_weakening()
	repeat
		dprint ("weakening right side2 knights");
		unit_set_current_vitality (area2_right_fore_2, 0.25, 0.25);
		unit_set_current_vitality (area2_right_fore_3, 0.25, 0.25);
		unit_set_current_vitality (area2_right_fore_4, 0.25, 0.25);
		sleep (30 * 5);
	until ((ai_living_count (area2_right_fore_2) == 0) and (ai_living_count (area2_right_fore_3) == 0) and (ai_living_count (area2_right_fore_4) == 0));

	b_right_side2_knights_dead = TRUE;
	dprint ("right side2 knights are dead - covenant advancing!");
	
end


script dormant right_room_checkpoint()
	sleep_until (volume_test_players (tv_right_spawn_2), 1);
	sleep_forever (right_encounter_1_over_save);
	thread (donut_right_area1_cleanup());
	wake (final_left_side_cov_spawn);
	sleep (5);
	game_save();
end


// ====================================================
// FINAL BATTLE SCRIPTS
// ====================================================

script dormant final_knight_fight()
	sleep_until ((volume_test_players (tv_left_endpath_spawn)) or (volume_test_players (tv_right_endpath_spawn)), 1);
	
	sleep_forever (left_encounter_2_over_save);
	sleep_forever (right_encounter_2_over_save);
	
	thread (hovering_cover_start(shieldwall_1));
	thread (hovering_cover_start(shieldwall_2));
	thread (hovering_cover_start(shieldwall_3));
	thread (hovering_cover_start(shieldwall_4));
	thread (hovering_cover_start(shieldwall_5));
	thread (hovering_cover_start(shieldwall_6));
	thread (f_mus_m30_e09_finish());
	thread (f_mus_m30_e10_finish());
	thread (f_mus_m30_e11_start());
	
	ai_place (final_fore_3);
	
	sleep (30 * 3);
	
	ai_place (final_fore_2);
	ai_place (final_fore_1);
	ai_place (final_fore_4);

	sleep (5);
	
	AutomatedTurretActivate( ai_vehicle_get( final_fore_3.spawn_points_0 ) );
	
	wake (m30_cryptum_approach);
	
end

script static void hovering_cover_start (object_name shieldwall)
	sleep (random_range (10, 45));
	repeat
    object_move_by_offset(shieldwall, 3, 0.0, 0.0, -0.03);
    sleep (20);
    object_move_by_offset(shieldwall, 3, 0.0, 0.0, 0.03);
  until(1 == 0);
end

script dormant final_left_side_cov_spawn
	sleep_until (volume_test_players (tv_right_endpath_spawn), 1);
	
	//sleep_forever (final_right_side_cov_spawn);
	
	ai_place (left_cov_final_fight);
	ai_prefer_target_team (left_cov_final_fight, forerunner);
	dprint ("final elites prefer fighting knights");
	
	sleep_until (ai_living_count (final_fore_1) == 0 and ai_living_count (sg_cov_final_fight) == 0, 1);
	
	ai_prefer_target_team (left_cov_final_fight, player);
	dprint ("final elites prefer fighting the player");
	
end

script dormant final_right_side_cov_spawn
	sleep_until (volume_test_players (tv_left_endpath_spawn), 1);
	
	//sleep_forever (final_left_side_cov_spawn);
	
	ai_place (right_cov_final_fight);
	ai_prefer_target_team (right_cov_final_fight, forerunner);
	dprint ("final elites prefer fighting knights");
	
	sleep_until (ai_living_count (final_fore_1) == 0 and ai_living_count (sg_cov_final_fight) == 0, 1);
	
	ai_prefer_target_team (right_cov_final_fight, player);
	dprint ("final elites prefer fighting the player");
	
end

// ====================================================
// END KNIGHT COMMAND SCRIPTS
// ====================================================

script command_script left_endknight_1()
	cs_phase_to_point (ps_endknight_phase.p0);
end

script command_script left_endknight_2()
	cs_phase_to_point (ps_endknight_phase.p1);
end

script command_script right_endknight_1()
	cs_phase_to_point (ps_endknight_phase.p2);
end

script command_script right_endknight_2()
	cs_phase_to_point (ps_endknight_phase.p3);
end

script command_script final_endknight_1()
	cs_phase_to_point (ps_endknight_phase.p4);
end

script command_script final_endknight_2()
	cs_phase_to_point (ps_endknight_phase.p5);
end

// ====================================================
// OLD STUFF BELOW
// ====================================================
/*

// ====================================================
// PHANTOM FLYBYS
// ====================================================

script dormant f_phantom_flyby_1()
	sleep_until (volume_test_players (tv_phantom_flyby_1), 1);
	ai_place (sq_phantom_flyby_1);
	ai_place (sq_phantom_flyby_2);
	print ("phantom flyby 1 start");
	game_save_no_timeout();
end

script dormant f_phantom_left_shotdown()
	sleep_until (volume_test_players (tv_left_spawn_1), 1);
	ai_place (sq_phantom_shotdown_left);
//	print ("incoming phantom above");
end
	
script dormant f_turret_spawn_left()
	sleep_until (volume_test_players (tv_phantom_flyby_1), 1);
	
	ai_place (sq_aa_left_2);
	unit_only_takes_damage_from_players_team (sq_aa_left_2, TRUE);
	vehicle_hover (sq_aa_left_2, TRUE);
	
	ai_place (sq_aa_left_1);
	unit_only_takes_damage_from_players_team (sq_aa_left_1, TRUE);
	vehicle_hover (sq_aa_left_1, TRUE);
	
	ai_place (sq_ainf_left_1);
	unit_only_takes_damage_from_players_team (sq_ainf_left_1, TRUE);
	vehicle_hover (sq_ainf_left_1, TRUE);
	
	ai_place (sq_aa_left_3);
	unit_only_takes_damage_from_players_team (sq_aa_left_3, TRUE);
	vehicle_hover (sq_aa_left_3, TRUE);
	
	ai_place (sq_aa_left_4);
	unit_only_takes_damage_from_players_team (sq_aa_left_4, TRUE);
	vehicle_hover (sq_aa_left_4, TRUE);
end

script dormant f_turret_spawn_right()
	sleep_until (volume_test_players (tv_phantom_flyby_1), 1);
	
	ai_place (sq_aa_right_2);
	vehicle_hover (sq_aa_right_2, TRUE);
	
	ai_place (sq_aa_right_1);
	vehicle_hover (sq_aa_right_1, TRUE);
	
	ai_place (sq_ainf_right_1);
	vehicle_hover (sq_ainf_right_1, TRUE);
	
	ai_place (sq_aa_right_3);
	vehicle_hover (sq_aa_right_3, TRUE);
	
	ai_place (sq_aa_right_4);
	vehicle_hover (sq_aa_right_4, TRUE);
end

script command_script cs_phantom_flyby_1()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_flyby_1.p0);
	cs_fly_to (ps_phantom_flyby_1.p1);
	cs_fly_to (ps_phantom_flyby_1.p2);
//	sleep (30 * 2);
	cs_fly_to (ps_phantom_flyby_1.p3);
	cs_fly_to (ps_phantom_flyby_1.p4);	
	cs_fly_to (ps_phantom_flyby_1.p5);	
	cs_fly_to (ps_phantom_flyby_1.p6);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120);
	sleep (30 * 4);
	ai_erase (sq_phantom_flyby_1);
end

script command_script cs_phantom_shotdown_left()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_shotdown_left.p0);
	cs_fly_to (ps_phantom_shotdown_left.p1);
	sleep (30 * 3);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_shotdown_left.p1);
	sleep (10);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_shotdown_left.p3);
	cs_fly_by (ps_phantom_shotdown_left.p2);
	sleep (10);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_shotdown_left.p2);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 15);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_shotdown_left.p2);
	sleep (30);
	ai_erase (sq_phantom_shotdown_left);
end

script command_script cs_phantom_left_1()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	f_load_phantom (sq_phantom_left_1, "right", sq_left_cov_4, none, none, none);
//	f_load_phantom (sq_phantom_left_1, "chute",  sq_left_cov_5, none, none, none);
	cs_fly_to (ps_phantom_left_1.p0);
	cs_fly_to_and_face (ps_phantom_left_1.p1, ps_phantom_left_1.p2);
	sleep (15);
	f_unload_phantom (sq_phantom_left_1, "right");
//	sleep (3 * 30);
	cs_fly_to (ps_phantom_left_1.p3);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_1.p3);
	sleep (10);
//	f_unload_phantom (sq_phantom_left_1, "chute");
	cs_fly_by (ps_phantom_left_1.p4);
	sleep (10);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_1.p4);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 60);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_1.p4);
	sleep (30 * 2);
	ai_erase (sq_phantom_left_1);
end
	
script command_script cs_phantom_left_2()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	f_load_phantom (sq_phantom_left_2, "right", sq_left_cov_5, none, none, none);
	cs_fly_to (ps_phantom_left_2.p0);
	cs_fly_to_and_face (ps_phantom_left_2.p1, ps_phantom_left_2.p2);
	sleep (15);
	f_unload_phantom (sq_phantom_left_2, "right");
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_2.p1);
	cs_fly_to (ps_phantom_left_2.p2);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_2.p2);
	sleep (10);
	cs_fly_to (ps_phantom_left_2.p3);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_2.p3);
	cs_fly_to (ps_phantom_left_2.p4);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 60);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_phantom_left_2.p4);
	sleep (30 * 2);
	ai_erase (sq_phantom_left_2);
end

// ====================================================
// AA TURRETS
// ====================================================

script command_script cs_aa_left_2_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_left_2.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_left_2.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_left_2.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_left_1_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_left_1.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_left_1.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_left_1.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_left_3_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_left_3.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_left_3.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_left_3.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_left_4_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_left_4.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_left_4.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_left_4.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_right_1_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_right_1.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_right_1.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_right_1.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_right_2_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_right_2.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_right_2.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_right_2.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_right_3_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_right_3.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_right_3.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_right_3.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

script command_script cs_aa_right_4_fire()
	repeat
	cs_shoot_point (TRUE, ps_aa_right_4.p0);
	sleep (random_range (15, 90));
	cs_shoot_point (TRUE, ps_aa_right_4.p1);
	sleep (random_range (15, 90));	
	cs_shoot_point (TRUE, ps_aa_right_4.p2);
	sleep (random_range (15, 90));
	until (aa_fire == 0);
end

// ====================================================
// LEFT PATH
// ====================================================

script dormant left_side_start()
	sleep_until (volume_test_players (tv_left_spawn_1), 1);
	wake (f_left_side_spawn_1);
	wake (f_ledge_flank_check);
	wake (f_left_side_spawn_2);
	wake (f_left_side_phantoms);
	object_create (left1_1);
	object_create (left1_2);
	object_create (left1_3);
	object_create (left1_4);
	object_create (left1_5);
	object_create (left1_6);
	object_create (left1_7);
	object_create (left1_8);
	object_create (left1_9);
	object_create (left1_10);
	object_create (left1_11);
	object_create (left1_12);
	object_create (left1_13);
	object_create (left1_14);
	object_create (left1_15);
	object_create (left1_16);
	object_create (left1_17);
	object_create (left1_18);
	object_create (left1_19);
	object_create (left1_20);
	object_create (left1_21);
	object_create (left1_22);
	object_create (left1_23);
end

script dormant f_ledge_flank_check()
	sleep_until (volume_test_players (tv_ledge_flank), 1);
	ledge_flank == 4;
end

script dormant f_left_side_spawn_1()
	ai_place (sq_left_cov_1);
	unit_only_takes_damage_from_players_team (sq_left_cov_1, TRUE);
	ai_place (sq_left_cov_2);
	unit_only_takes_damage_from_players_team (sq_left_cov_2, TRUE);
	ai_place (sq_left_cov_3);
	unit_only_takes_damage_from_players_team (sq_left_cov_3, TRUE);
	ai_place (sq_left_fore_1);
	unit_only_takes_damage_from_players_team (sq_left_fore_1, TRUE);
	ai_place (sq_left_fore_2);
	unit_only_takes_damage_from_players_team (sq_left_fore_2, TRUE);
	ai_place (sq_left_fore_3);
	unit_only_takes_damage_from_players_team (sq_left_fore_3, TRUE);
	ai_place (sq_left_fore_4);
	unit_only_takes_damage_from_players_team (sq_left_fore_4, TRUE);
	ai_place (sq_left_fore_5);
	unit_only_takes_damage_from_players_team (sq_left_fore_5, TRUE);
end

script dormant f_left_side_spawn_2()
	sleep_until (volume_test_players (tv_left_spawn_2), 1);
	ai_place (sq_left_fore_6);
	unit_only_takes_damage_from_players_team (sq_left_fore_6, TRUE);
	ai_place (sq_left_fore_7);
	unit_only_takes_damage_from_players_team (sq_left_fore_7, TRUE);
	ai_place (sq_left_fore_8);
	unit_only_takes_damage_from_players_team (sq_left_fore_8, TRUE);
	ai_place (sq_left_fore_9);
	unit_only_takes_damage_from_players_team (sq_left_fore_9, TRUE);
	object_create (left2_1);
	object_create (left2_2);
	object_create (left2_3);
	object_create (left2_4);
	object_create (left2_5);
	object_create (left2_6);
	object_create (left2_7);
	object_create (left2_8);
	object_create (left2_9);
end

script dormant f_left_side_mid_save()
	sleep_until (volume_test_players (tv_left_mid_save), 1);
	//Checks to make sure player not being fired at, falling, etc... and keeps waiting for good time, like being behind cover.
	game_save_no_timeout();
	print ("game saved");
end

script dormant f_left_side_phantoms()
	sleep_until (volume_test_players (tv_left_phantoms), 1);
	ai_place (sq_phantom_left_1);
	ai_place (sq_phantom_left_2);
end
	
	
/*
script command_script left_cov_1_playfight()
	cs_abort_on_damage (sq_left_cov_1, TRUE);
	repeat
	cs_move_towards_point (ps_left_cov_1_playfighting.p0, 2);
	cs_shoot_point (TRUE, ps_left_cov_1_playfighting.p3);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_cov_1_playfighting.p1, 2);
	cs_shoot_point (TRUE, ps_left_cov_1_playfighting.p5);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_cov_1_playfighting.p2, 0.5);
	cs_shoot_point (TRUE, ps_left_cov_1_playfighting.p4);
	sleep (random_range (15, 60));
	until (playfighting == 0);
end

script command_script left_cov_3_playfight()
	cs_abort_on_damage (sq_left_cov_3, TRUE);
	repeat
	cs_move_towards_point (ps_left_cov_3_playfighting.p0, 1);
	sleep (30);
	cs_shoot_point (TRUE, ps_left_cov_3_playfighting.p4);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_cov_3_playfighting.p1, 1);
	sleep (30);
	cs_shoot_point (TRUE, ps_left_cov_3_playfighting.p5);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_cov_3_playfighting.p2, 3);
	sleep (30);
	cs_shoot_point (TRUE, ps_left_cov_3_playfighting.p3);
	sleep (random_range (15, 60));
	until (playfighting == 0);
end

script command_script left_fore_1_playfight()
	cs_abort_on_damage (sq_left_fore_1, TRUE);
	repeat
	cs_move_towards_point (ps_left_fore_1_playfighting.p0, 1);
	sleep (30);
	cs_shoot_point (TRUE, ps_left_fore_1_playfighting.p3);
	sleep (random_range (15, 90));
	cs_shoot_point (FALSE, ps_left_fore_1_playfighting.p3);
	cs_shoot_point (TRUE, ps_left_fore_1_playfighting.p4);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_fore_1_playfighting.p1, 1);
	sleep (15);
	cs_shoot_point (TRUE, ps_left_fore_1_playfighting.p5);
	sleep (random_range (15, 60));
	cs_move_towards_point (ps_left_fore_1_playfighting.p2, 1);
	sleep (random_range (15, 60));
	until (playfighting == 0);
end	


script command_script cs_jackal_1()
	cs_abort_on_damage (sq_left_cov_2, TRUE);
//	cs_abort_on_alert (TRUE);
	print ("jackals moving to ramps");
	cs_move_towards_point (ps_jackals_1.p0, 5);
	cs_move_towards_point (ps_jackals_1.p1, 2);
	cs_move_towards_point (ps_jackals_1.p2, 0.5);
	cs_move_towards_point (ps_jackals_1.p3, 0.5);
end

// ====================================================
// RIGHT PATH
// ====================================================

script dormant f_right_side_start()
	sleep_until (volume_test_players (tv_right_spawn_1), 1);
	ai_place (sq_right_cov_1);
	ai_place (sq_right_cov_2);
	ai_place (sq_right_cov_3);
	ai_place (sq_right_fore_1);
	ai_place (sq_right_fore_2);
	ai_place (sq_right_cov_4);
	ai_place (sq_phantom_right_1);
	wake (f_right_side_start_2);
	object_create (right1_1);
	object_create (right1_2);
	object_create (right1_3);
	object_create (right1_4);
	object_create (right1_5);
	object_create (right1_6);
	object_create (right1_7);
	object_create (right1_8);
	object_create (right1_9);
	object_create (right1_10);
	object_create (right1_11);
	object_create (right1_12);
	object_create (right1_13);
	object_create (right1_14);
	object_create (right1_15);
	object_create (right1_16);
	object_create (right1_17);
	object_create (right1_18);
	object_create (right1_19);
	object_create (right1_20);
	object_create (right1_21);
	object_create (right1_22);
	object_create (right1_23);
	object_create (right1_24);
	object_create (right1_25);
	object_create (right1_26);
	object_create (right1_27);
	object_create (right1_28);
	object_create (right1_29);
	object_create (right1_30);
end

script command_script charging_elite()
	cs_abort_on_damage (TRUE);
	cs_shoot (TRUE, sq_right_fore_1);
	cs_move_towards_point (ps_right_cov_4.p0, 1);
	cs_move_towards_point (ps_right_cov_4.p1, 1);
	cs_move_towards_point (ps_right_cov_4.p2, 1);
	cs_move_towards_point (ps_right_cov_4.p3, 1);
	cs_move_towards_point (ps_right_cov_4.p4, 1);
end

script command_script winning_phantom()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_right_phantom_1.p0);
	cs_fly_to (ps_right_phantom_1.p1);
	cs_fly_to (ps_right_phantom_1.p2);
	sleep (30 * 4);
	cs_shoot_point (TRUE, ps_right_phantom_1.p6);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_right_phantom_1.p6);
//	damage_object (ai_vehicle_get_from_spawn_point (sq_ainf_right_1.driver), left_door, 1000); 
	ai_kill (sq_ainf_right_1);
	ai_erase (sq_ainf_right_1);
	cs_shoot_point (TRUE, ps_right_phantom_1.p7);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_right_phantom_1.p7);
	ai_kill (sq_aa_right_2);
	ai_erase (sq_aa_right_2);
	cs_shoot_point (TRUE, ps_right_phantom_1.p8);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_right_phantom_1.p8);
	ai_kill (sq_aa_right_1);
	ai_erase (sq_aa_right_1);
	sleep (10);
	cs_fly_by (ps_right_phantom_1.p3);
	cs_fly_to (ps_right_phantom_1.p4);
	cs_fly_to (ps_right_phantom_1.p5);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120);
	sleep (30 * 4);
	ai_erase (sq_phantom_right_1);
end

script dormant f_right_side_mid_save()
	sleep_until (volume_test_players (tv_right_mid_save), 1);
	//Checks to make sure player not being fired at, falling, etc... and keeps waiting for good time, like being behind cover.
	game_save_no_timeout();
	print ("game saved");
end

script dormant f_right_side_start_2()
	sleep_until (volume_test_players (tv_right_spawn_2), 1);
	ai_place (sq_right_fore_3);
	ai_place (sq_right_fore_4);
	ai_place (sq_right_fore_5);
	ai_place (sq_right_fore_6);
	ai_place (sq_right_cov_5);
	ai_place (sq_right_cov_6);
	ai_place (sq_phantom_right_2);
	object_create (right2_1);
	object_create (right2_2);
	object_create (right2_3);
	object_create (right2_4);
	object_create (right2_5);
	object_create (right2_6);
	object_create (right2_7);
	object_create (right2_8);
	object_create (right2_9);
end

script command_script jackal_advance_2()
	cs_abort_on_damage (sq_right_cov_5, TRUE);
	cs_move_towards_point (ps_right_cov_5.p0, 1);
	cs_move_towards_point (ps_right_cov_5.p1, 1);
	cs_move_towards_point (ps_right_cov_5.p2, 1);
	cs_move_towards_point (ps_right_cov_5.p3, 1);
end

script command_script right_phantom_2()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	f_load_phantom (sq_phantom_right_2, "dual", sq_right_cov_7, sq_right_cov_8, none, none);
	cs_fly_to (ps_right_phantom_2.p0);
	cs_fly_to (ps_right_phantom_2.p1);
	cs_fly_to (ps_right_phantom_2.p2);
	cs_fly_to (ps_right_phantom_2.p3);
	f_unload_phantom (sq_phantom_right_2, "dual");
	cs_shoot_point (TRUE, ps_right_phantom_2.p7);
	sleep (3 * 30);
	cs_shoot_point (TRUE, ps_right_phantom_2.p8);
	sleep (3 * 30);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_right_phantom_2.p8);
	effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, ps_right_phantom_2.p7);
	ai_kill (sq_aa_right_3);
	ai_erase (sq_aa_right_3);
	ai_kill (sq_aa_right_4);
	ai_erase (sq_aa_right_4);
	sleep (30);
	cs_fly_to_and_face (ps_right_phantom_2.p4, ps_right_phantom_2.p5);
	cs_fly_to (ps_right_phantom_2.p5);
	cs_fly_to (ps_right_phantom_2.p6);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120);
	sleep (30 * 4);
	ai_erase (sq_phantom_right_2);
end	

script command_script cs_phantom_flyby_2()
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 0);
	object_set_scale (ai_vehicle_get(ai_current_actor), 1.0, 120);
	cs_fly_to (ps_phantom_flyby_2.p0);
	cs_fly_to (ps_phantom_flyby_2.p1);
	cs_fly_to (ps_phantom_flyby_2.p2);
	cs_fly_to (ps_phantom_flyby_2.p3);
	cs_fly_to (ps_phantom_flyby_2.p4);
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120);
	sleep (30 * 4);
	ai_erase (sq_phantom_flyby_2);
end
*/

/*

script dormant endknights_left()
	sleep_until (volume_test_players (tv_left_endknights), 1);
	
	ai_place (sq_left_endknights);
	
end

script dormant endknights_right()
	sleep_until (volume_test_players (tv_right_endknights), 1);
	
	ai_place (sq_right_endknights);
	
end

script command_script endknight_1()
	cs_phase_to_point (ps_endramp_knights.p0);
end

script command_script endknight_2()
	cs_phase_to_point (ps_endramp_knights.p1);
end

script command_script endknight_3()
	cs_phase_to_point (ps_endramp_knights.p2);
end

script command_script endknight_4()
	cs_phase_to_point (ps_endramp_knights.p3);
end