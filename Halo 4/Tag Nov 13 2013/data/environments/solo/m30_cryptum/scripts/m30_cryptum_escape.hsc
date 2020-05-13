//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			escape
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global boolean b_escape_started	= FALSE;
global boolean b_escape_over = FALSE;
global boolean b_speed_fx_playing = FALSE;
global short rift_pulse = 0;
global short cruiser_explosion_check = 0;
global boolean b_section_one_closed = FALSE;
global boolean b_section_two_closed = FALSE;
global boolean b_section_three_closed = FALSE;
global boolean b_section_four_closed = FALSE;
global boolean b_kill_timer_expired = FALSE;
global boolean b_phantom_crash_1_explosion = FALSE;
global boolean b_escape_respawns = FALSE;
global boolean b_boost_tutorial = FALSE;
global long player_0_kill = -1;
global long player_1_kill =	-1;
global long player_2_kill = -1;
global long player_3_kill = -1;
global object g_ics_player = NONE;

// =================================================================================================
// ***CO-OP AND EASY SCRIPTING DELAYS ***
// =================================================================================================

global long r_short_coop_delay = 0;
global long r_medium_coop_delay = 0;
global long r_long_coop_delay = 0;
global long r_verylong_coop_delay = 0;


script static void coop_escape_check
	if game_is_cooperative() or (game_difficulty_get_real() == "easy") or (game_difficulty_get_real() == "normal") then
			
			dprint ("co-op timing values updated");
			r_short_coop_delay = (real_random_range (1, 1.75));
			dprint ("short delay set to");
			inspect (r_short_coop_delay);
			r_medium_coop_delay = (real_random_range (2, 3));
			dprint ("medium delay set to");
			inspect (r_medium_coop_delay);
			r_long_coop_delay = (real_random_range (3, 4.25));
			dprint ("long delay set to");
			inspect (r_long_coop_delay);
			r_verylong_coop_delay = (real_random_range (5, 6.5));
			dprint ("very long delay set to");
			inspect (r_verylong_coop_delay);
		
	end
end

// =================================================================================================
// =================================================================================================
// *** ESCAPE ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_escape()	
	sleep_until (volume_test_players (tv_insertion_wake_escape), 1);

	thread (coop_escape_check());

	cinematic_exit_no_fade ("cin_m031_didact", TRUE);

	g_ics_player = player_get_first_valid();
	local long show = pup_play_show(ghost_escape);
	cinematic_tag_fade_in_to_game ("cin_m031_didact");
	
	sleep_until (not pup_is_playing(show),1);
	
	dprint  ("::: escape start :::");
	effects_distortion_enabled = TRUE;
	//thread (f_mus_m30_e12_start()); 
	
	wake (escape_start);
	wake (escape_chaos_1);
	wake (escape_chaos_2);
	wake (escape_chaos_3);
	wake (escape_chaos_4);
	wake (phantom_crash_1);
	wake (rock_slam_1);
	wake (large_ambient_fires);
	wake (smaller_ambient_fires);
	wake (escape_collapse_1);
	wake (cave_collapse_1);
	thread (escape_speed_lines(player0));
	thread (escape_speed_lines(player1));
	thread (escape_speed_lines(player2));
	thread (escape_speed_lines(player3));
	wake (escape_collapse_4);
	wake (escape_chaos_6);
	wake (escape_chaos_7);
	wake (escape_chaos_8);
	wake (rock_ramp_raise);
	wake (wall_moving_1);
	wake (escape_collapse_5);
	wake (rocksplosion_v2);
	wake (escape_collapse_6);
	wake (terrain_fall_fx_2);
	wake (escape_final_chaos);
	wake (escape_chaos_10);
	wake (cave_1_explosions);
	wake (escape_save_1);
	wake (escape_save_2);
	wake (escape_section_1);
	wake (escape_section_2);
	wake (escape_section_3);
	wake (escape_section_4);
	wake (corner_explosions);
	data_mine_set_mission_segment ("m30_escape");
	wake (cave_2_explosion);
	thread (escape_ambient_rock_fx());
	wake (temp_rumble_sound_start);
	wake (M30_escape_open_vignette); //Narrative Scripting
	wake (m30_escape_volume_01);//Narrative Scripting
	wake (m30_escape_volume_02); //Narrative Scripting
	wake (m30_escape_volume_03); //Narrative Scripting
	//wake (f_start_escape_timer);
	thread (out_of_ghost_timer(player0));
	thread (out_of_ghost_timer(player1));
	thread (out_of_ghost_timer(player2));
	thread (out_of_ghost_timer(player3));
	thread (ambient_crack_fx_1());
	thread (ambient_crack_fx_2());
	thread (ambient_crack_fx_3());
	thread (ambient_crack_fx_4());
	thread (ambient_crack_fx_5());
	thread (placed_ambient_rocks_1());
	thread (placed_ambient_rocks_2());
	wake (area_1_fx_shutdown);
	wake (area_2_fx_shutdown);
	wake (area_3_fx_shutdown);
	wake (area_4_fx_shutdown);	
	wake (escape_collapse_8_go);
	thread (set_ghost_respawns());
	wake (escape_dead_phantom_cleanup);
//	thread (cave_dust_1());
//	thread (cave_dust_2());
	
end

// ====================================================
// ESCAPE TIMER =======================================
// ====================================================


/*
script dormant f_start_escape_timer()
	dprint ("escape timer has started!");
	sleep (30 * 80);
	b_section_one_closed = TRUE;
	dprint ("b_section_one_closed = TRUE");
	sleep_until (device_get_position (escape_collapse_2) == 1);
	sleep (30 * 70);
	b_section_two_closed = TRUE;
	dprint ("b_section_two_closed = TRUE");
	sleep_until (device_get_position (escape_collapse_3) == 1);
	sleep (30 * 70);
	b_section_three_closed = TRUE;
	dprint ("b_section_three_closed = TRUE");
	sleep_until (device_get_position (escape_collapse_4) == 1);
	sleep (30 * 70);
	b_section_four_closed = TRUE;
	dprint ("b_section_four_closed = TRUE");
	
end
*/

script static void out_of_ghost_timer(player p_player)
	
	sleep_until (unit_in_vehicle (p_player), 1);
	
	sleep (30 * 2);
	
	unit_falling_damage_disable (player0, TRUE);
	unit_falling_damage_disable (player1, TRUE);
	unit_falling_damage_disable (player2, TRUE);
	unit_falling_damage_disable (player3, TRUE);
	
	thread (player_dies_in_escape (player0));
	thread (player_dies_in_escape (player1));
	thread (player_dies_in_escape (player2));
	thread (player_dies_in_escape (player3));

	thread (player_boost_tutorial (player0));
	thread (player_boost_tutorial (player1));	
	thread (player_boost_tutorial (player2));
	thread (player_boost_tutorial (player3));
	
	wake (m30_objective_8);
	
	dprint ("timer has begun... don't get out of the ghost!");
	
	local long thread_ID = -1;
	
	repeat
		if not
			unit_in_vehicle (p_player) 
		then
			dprint ("you got out of the ghost - timer started!");
			wake (m30_leave_ghost);
			thread_ID = thread (kill_player_off_ghost (p_player));
			sleep_until (unit_in_vehicle (p_player), 1);
			dprint ("lucky bugger got back in the ghost");
			kill_thread (thread_ID);
		end
	until (b_escape_over == TRUE, 1);

end	

script static void kill_player_off_ghost (player p_player)
	sleep (30 * 10);
	dprint ("BOOM YOU DEAD");
	
	effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, p_player, "drop");

	unit_kill (p_player);
end


script static void player_dies_in_escape (player p_player)
	
	sleep_until (object_get_health(p_player) <= 0, 1);
	
	dprint ("BOOM YOU DEAD");
	effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, p_player, "drop");
	fade_out_for_player (p_player);
	
	sleep (30);
	
	sleep_until (object_get_health(p_player) > 0, 1) or (b_escape_over == TRUE);
	
	fade_in_for_player (p_player);

	thread (player_dies_in_escape (p_player));
	thread (player_escape_shield_stun (p_player));

end

script static void player_boost_tutorial (player p_player)
	
	sleep (30);
	dprint ("LEARN TO BOOST, MORTAL");
	chud_show_screen_training (p_player, "training_ghostboost");

  sleep (30 * 3);
  
	if unit_in_vehicle (p_player) then

  	unit_action_test_reset (p_player);
  	sleep_until (unit_action_test_grenade_trigger (p_player) or not unit_in_vehicle (p_player), 1);
  	chud_show_screen_training (p_player, "");
  	
  else 
  
  	chud_show_screen_training (p_player, "");
  
  end
  
end

script static void player_escape_shield_stun (player p_player)
	
	dprint ("SHIELD STUNNED");
	
	object_set_shield (p_player, 0);
	
	object_set_shield_stun_infinite (p_player);
	
  sleep_until (volume_test_players (tv_finish_escape), 1);

  object_set_shield_stun (player0, 0);
  object_set_shield_stun (player1, 0);
  object_set_shield_stun (player2, 0);
  object_set_shield_stun (player3, 0);
  
  dprint ("SHIELD RESTORED");
  
end

// ====================================================
// ESCAPE GHOST RESPAWNING ============================
// ====================================================

script static void set_ghost_respawns()

	player_set_respawn_vehicle ( player0, "objects\vehicles\covenant\storm_ghost\storm_ghost_infinite_boost.vehicle");
  player_set_respawn_vehicle ( player1, "objects\vehicles\covenant\storm_ghost\storm_ghost_infinite_boost.vehicle");
  player_set_respawn_vehicle ( player2, "objects\vehicles\covenant\storm_ghost\storm_ghost_infinite_boost.vehicle");
  player_set_respawn_vehicle ( player3, "objects\vehicles\covenant\storm_ghost\storm_ghost_infinite_boost.vehicle");                     
  
end

script static void remove_ghost_respawns()		
		
	player_set_respawn_vehicle ( player0, none );
	player_set_respawn_vehicle ( player1, none );
	player_set_respawn_vehicle ( player2, none );
	player_set_respawn_vehicle ( player3, none );
	
end


// ====================================================
// PROGRESSION BLOCKER TESTS ==========================
// ====================================================

script dormant escape_section_1()
	
	sleep_until ((device_get_position (escape_collapse_2) >= 0.85) or (b_section_one_closed == TRUE), 1);
		
		dprint ("section one is closed off!");
		thread( f_mus_m30_r19_escape_section2() ); // cue music for section 2
		
		if volume_test_object (tv_escape_section_1, player0) then 
			dprint ("attempting to kill player 1");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player0, "drop");
			unit_kill (player0);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_1, player1) then 
			dprint ("attempting to kill player 2");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player1, "drop");
			unit_kill (player1);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_1, player2) then 
			dprint ("attempting to kill player 3");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player2, "drop");
			unit_kill (player2);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_1, player3) then 
			dprint ("attempting to kill player 4");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player3, "drop");
			unit_kill (player3);
		else
			sleep (1);
		end
end

script dormant escape_section_2()
	sleep_until ((device_get_position (escape_collapse_3) >= 0.95) or (b_section_two_closed == TRUE), 1);
		
		dprint ("section two is closed off!");
		thread( f_mus_m30_r20_escape_section3() ); // cue music for section 3
		
		if volume_test_object (tv_escape_section_2, player0) then 
			dprint ("attempting to kill player 1");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player0, "drop");
			unit_kill (player0);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_2, player1) then 
			dprint ("attempting to kill player 2");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player1, "drop");
			unit_kill (player1);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_2, player2) then 
			dprint ("attempting to kill player 3");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player2, "drop");
			unit_kill (player2);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_2, player3) then 
			dprint ("attempting to kill player 4");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player3, "drop");
			unit_kill (player3);
		else
			sleep (1);
		end
end

script dormant escape_section_3()
	sleep_until ((device_get_position (escape_collapse_4) >= 0.75) or (b_section_three_closed == TRUE), 1);
		
		dprint ("section three is closed off!");
		thread( f_mus_m30_r21_escape_section4() ); // cue music for section 4
		
		if volume_test_object (tv_escape_section_3, player0) then 
			dprint ("attempting to kill player 1");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player0, "drop");
			unit_kill (player0);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_3, player1) then 
			dprint ("attempting to kill player 2");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player1, "drop");
			unit_kill (player1);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_3, player2) then 
			dprint ("attempting to kill player 3");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player2, "drop");
			unit_kill (player2);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_3, player3) then 
			dprint ("attempting to kill player 4");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player3, "drop");
			unit_kill (player3);
		else
			sleep (1);
		end
		
end

script dormant escape_section_4()
	sleep_until ((device_get_position (escape_collapse_5) >= 0.85) or (b_section_four_closed == TRUE), 1);
		
		dprint ("section four is closed off!");
		thread( f_mus_m30_r22_escape_section5() ); // cue music for section 5
		
		if volume_test_object (tv_escape_section_4, player0) then 
			dprint ("attempting to kill player 1");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player0, "drop");
			unit_kill (player0);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_4, player1) then 
			dprint ("attempting to kill player 2");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player1, "drop");
			unit_kill (player1);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_4, player2) then 
			dprint ("attempting to kill player 3");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player2, "drop");
			unit_kill (player2);
		else
			sleep (1);
		end
		
		if volume_test_object (tv_escape_section_4, player3) then 
			dprint ("attempting to kill player 4");
			effect_new_on_object_marker (environments\solo\m30_cryptum\fx\rock\playerdeath.effect, player3, "drop");
			unit_kill (player3);
		else
			sleep (1);
		end
end


// ====================================================
// CAMERA SHAKES ===================================
// ====================================================

script static void strong_camera_shake()
	camera_shake_all_coop_players(1, 1, 2, 2, escape_camera_shake_weak);
end

script static void weak_camera_shake()
	camera_shake_all_coop_players(1, 1, 1, 1, escape_camera_shake_strong);
end

// ====================================================
// SET UP AND SAVES ===================================
// ====================================================

script dormant escape_start()
	sleep_until (volume_test_players (tv_start_escape), 1);
	physics_set_gravity (0.7);
	dprint ("gravity set to 0.7");
	fade_in_for_player (player0);	
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	game_save();
	//thread (strong_camera_shake(player0));
	//thread (strong_camera_shake(player1));
	//thread (strong_camera_shake(player2));
	//thread (strong_camera_shake(player3));
	object_create (escape_collapse_7);
end

// ====================================================
// BOOSTING EFFECTS ===================================
// ====================================================

script static void escape_speed_lines(player p_player)
	repeat
		sleep_until (unit_in_vehicle (p_player), 1);

		unit_action_test_reset (p_player);
	
		if (unit_action_test_grenade_trigger (p_player)) then
			f_play_speed_lines();
		else
			f_stop_speed_lines();
			
			if b_boost_tutorial == FALSE then
			
				f_remind_player_to_boost(p_player);
			
			end
		
		end

	until (b_escape_over == TRUE);

end	

script static void f_play_speed_lines()
	if (b_speed_fx_playing == FALSE) 
		then
			print ("speed FX playing - old, no FX played here anymore");
			//effect_attached_to_camera_new (environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect);
			//effect_attached_to_camera_new (environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect);   
			b_speed_fx_playing = TRUE;
		end
end

script static void f_stop_speed_lines()
	if (b_speed_fx_playing == TRUE)
		then
			print ("speed FX stopped - old, no FX played here anymore");
			//effect_attached_to_camera_stop (environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect);
			//effect_attached_to_camera_stop (environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect);    
			b_speed_fx_playing = FALSE;
		end
end

script static void f_remind_player_to_boost(player p_player)
	
		b_boost_tutorial = TRUE;
	
		sleep (30 * 3);
		unit_action_test_reset(p_player);
	
		if not unit_action_test_grenade_trigger (p_player) and unit_in_vehicle (p_player) then
		
				print ("REMEMBER TO BOOST, MORTAL");	
				chud_show_screen_training (p_player, "training_ghostboost");
 				sleep (30 * 3);
 				
 				if unit_in_vehicle (p_player) then

  				unit_action_test_reset (p_player);
  				sleep_until (unit_action_test_grenade_trigger (p_player) or not unit_in_vehicle(p_player), 1);
 					chud_show_screen_training (p_player, "");
					b_boost_tutorial = FALSE;
				
				else
				
					chud_show_screen_training (p_player, "");
					b_boost_tutorial = FALSE;
				
				end
		
		else
		
			chud_show_screen_training (p_player, "");
			b_boost_tutorial = FALSE;
				
		end
			
			
			
end

// ====================================================
// FX CONTROL =========================================
// ====================================================
	
script dormant area_1_fx_shutdown()
	sleep_until (volume_test_players (tv_chaos_5), 1) or (b_section_one_closed == TRUE);
	
	dprint ("turning off FX in area 1");
	effect_delete_all_in_volume (tv_escape_section_1);
	
end

script dormant area_2_fx_shutdown()
	sleep_until (volume_test_players (tv_chaos_7), 1) or (b_section_two_closed == TRUE);

	dprint ("turning off FX in area 1");
	dprint ("turning off FX in area 2");
	effect_delete_all_in_volume (tv_escape_section_1);
	effect_delete_all_in_volume (tv_escape_section_2);
	
end
	
script dormant area_3_fx_shutdown()
	sleep_until (volume_test_players (tv_rock_ramp), 1) or (b_section_three_closed == TRUE);

	dprint ("turning off FX in area 1");
	dprint ("turning off FX in area 2");
	dprint ("turning off FX in area 3");
	effect_delete_all_in_volume (tv_escape_section_1);
	effect_delete_all_in_volume (tv_escape_section_2);
	effect_delete_all_in_volume (tv_escape_section_3);

end	

script dormant area_4_fx_shutdown()
	sleep_until (volume_test_players (tv_final_chaos), 1) or (b_section_four_closed == TRUE);	
	
	dprint ("turning off FX in area 1");
	dprint ("turning off FX in area 2");
	dprint ("turning off FX in area 3");
	dprint ("turning off FX in area 4");
	effect_delete_all_in_volume (tv_escape_section_1);
	effect_delete_all_in_volume (tv_escape_section_2);
	effect_delete_all_in_volume (tv_escape_section_3);
	effect_delete_all_in_volume (tv_escape_section_4);
	effect_delete_all_in_volume (tv_escape_section_5);
end
	
	
// ====================================================
// AMBIENT ROCKS ======================================
// ====================================================

script static void escape_ambient_rock_fx()

	effect_attached_to_camera_new (environments\solo\m30_cryptum\fx\rock\rock_player_pebbles.effect);
	effect_attached_to_camera_new (environments\solo\m30_cryptum\fx\rock\rock_player_pebbles.effect);
	effect_attached_to_camera_new (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect);
	effect_attached_to_camera_new (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect);

	sleep_until (b_escape_over == TRUE);
	
	effect_attached_to_camera_stop (environments\solo\m30_cryptum\fx\rock\rock_player_pebbles.effect);
	effect_attached_to_camera_stop (environments\solo\m30_cryptum\fx\rock\rock_player_pebbles.effect);
	effect_attached_to_camera_stop (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect);
	effect_attached_to_camera_stop (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect);

end	

script static void placed_ambient_rocks_1()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p0);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p2);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p3);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p4);
	
	sleep_until (volume_test_players (tv_rock_slam_1), 1);

	garbage_collect_now();

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p5);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p6);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p7);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p8);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p9);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p11);
	
	sleep_until (volume_test_players (tv_ambient_rocks_2), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p12);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p13);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p14);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p15);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p16);
	
	sleep_until (volume_test_players (tv_cave_1_explosions), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p17);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p18);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p19);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p20);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p21);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p22);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p23);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p24);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p25);
	
	sleep_until (volume_test_players (tv_rock_ramp), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p26);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p27);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p28);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p29);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p30);
	
end

script static void placed_ambient_rocks_2()
	
	sleep_until (volume_test_players (tv_cave_2_explosions), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks.p31);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p0);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p2);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p3);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p4);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p5);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p6);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p7);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p8);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p9);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p11);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p12);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p13);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p14);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_largefloating.effect, ps_floating_rocks_2.p15);
end


// ====================================================
// AMBIENT CRACK FX ===================================
// ====================================================

script static void ambient_crack_fx_1()

	sleep_until (volume_test_players (tv_rock_slam_1), 1);

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p12);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p16);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p21);
	sleep (random_range (1, 8));
	
	sleep_until (volume_test_players (tv_ambient_rocks_2), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p23);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p29);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks.p31);
end

script static void ambient_crack_fx_2()

	sleep_until (volume_test_players (tv_rumble_start_1), 1);
	garbage_collect_now();

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p12);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p16);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p21);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p23);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p29);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_2.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_2.p31);
end

script static void ambient_crack_fx_3()

	sleep_until (volume_test_players (tv_collapse_1), 1);
	garbage_collect_now();

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p12);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p16);
	sleep (random_range (1, 8));
	
	sleep_until (volume_test_players (tv_escape_save_2), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p21);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p23);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_3.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p29);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_3.p31);
end

script static void ambient_crack_fx_4()

	sleep_until (volume_test_players (tv_corner_explosions), 1);
	garbage_collect_now();

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p12);
	
	sleep_until (volume_test_players (tv_rock_ramp), 1);
	garbage_collect_now();
	
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p16);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p21);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p23);
	sleep (random_range (1, 8));
	
	sleep_until (volume_test_players (tv_cave_2_explosions), 1);
	garbage_collect_now();
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_xsml_loop.effect, ps_orange_cracks_4.p29);
	sleep (random_range (1, 8));
	
	sleep_until (volume_test_players (tv_chaos_9), 1);
	garbage_collect_now();	
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_4.p31);
end

script static void ambient_crack_fx_5()

	sleep_until (volume_test_players (tv_chaos_9), 1);
	garbage_collect_now();

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\energy\energy_geyser_small_loop.effect, ps_orange_cracks_5.p10);
end

// ====================================================
// CAVE DUST ==========================================
// ====================================================

script static void cave_dust_1()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p12);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p16);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p21);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p23);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p29);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust.p31);
end

script static void cave_dust_2()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p0);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p1);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p2);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p3);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p4);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p5);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p6);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p7);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p8);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p9);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p10);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p11);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p12);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p13);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p14);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p15);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p16);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p17);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p18);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p19);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p20);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p21);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p22);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p23);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p24);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p25);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p26);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p27);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p28);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p29);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p30);
	sleep (random_range (1, 8));
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_fallingdebris_long.effect, ps_cave_dust_2.p31);
end

// ====================================================
// CHAOS (NEW STUFF) ==================================
// ====================================================

script dormant escape_chaos_1()
	sleep_until (volume_test_players (tv_chaos_1), 1);
	
	// THUNDER AND LIGHTNING VERY VERY FRIGHTENING
	sound_impulse_start('sound\environments\solo\m030\vin\play_m30_ghost_escape_thunder_start', NONE, 1 );
	
	game_save();
	sleep_s (r_short_coop_delay);
	
	/*
	thread (rock_raise_1());
	sleep (15);
	thread (rock_raise_2());
	sleep (25);
	thread (rock_raise_5());
	sleep (25);
	thread (rock_raise_6());
	*/
	sleep (30 * 3);
	thread (terrain_raise_1());
	thread (terrain_raise_2());
	thread (terrain_raise_3());
	thread (terrain_raise_4());
	thread (terrain_raise_5());
	thread (terrain_raise_6());
	
end

script static void rock_raise_1()
	thread (weak_camera_shake());

	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p0);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_nodust.effect, ps_rock_raising.p0);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p0);
	object_move_to_flag (rock_raise_1, 0.6, flag_rock_raise_1);
	wake (m30_escape_destruction_01);
end

script static void rock_raise_2()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p1);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p1);
	object_move_to_flag (rock_raise_2, 0.6, flag_rock_raise_2);
end

script static void rock_raise_5()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p25);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl, ps_rock_raising.p11);
	object_move_to_flag (rock_raise_5, 0.6, flag_rock_raise_5);
end

script static void rock_raise_6()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl, ps_rock_raising.p12);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl, ps_rock_raising.p12);
	object_move_to_flag (rock_raise_6, 0.1, flag_rock_raise_6);
end

script static void terrain_raise_1()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_1, 2.3, flag_terrain_raise_1);
end

script static void terrain_raise_2()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_2, 2.9, flag_terrain_raise_2);
end

script static void terrain_raise_3()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_3, 2.3, flag_terrain_raise_3);
end

script static void terrain_raise_4()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_4, 2.9, flag_terrain_raise_4);
end

script static void terrain_raise_5()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_5, 2.4, flag_terrain_raise_5);
end

script static void terrain_raise_6()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_terrain_raise', NONE, 1 );
	object_move_to_flag (terrain_raise_6, 3.2, flag_terrain_raise_6);
end

script dormant escape_chaos_2()
	sleep_until (volume_test_players (tv_chaos_2), 1);
	
	thread (rock_raise_3());
	thread (rock_raise_4());
	
end	

script static void rock_raise_3()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p2);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl, ps_rock_raising.p2);
	object_move_to_flag (rock_raise_3, 0.4, flag_rock_raise_3);
end	

script static void rock_raise_4()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p3);
	thread (weak_camera_shake());

	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar1', rock_raise_4, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p3);
	object_move_to_flag (rock_raise_4, 0.3, flag_rock_raise_4);
end	

script dormant escape_chaos_3()
	sleep_until (volume_test_players (tv_chaos_3), 1);
	
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar7', terrain_move_1, 1 );
	object_move_to_flag (terrain_move_1, 24.2, flag_world_center);

end

script dormant phantom_crash_1()
	sleep_until (volume_test_players (tv_phantom_crash_1), 1);
	
	thread (phantom_1_crashing());
//	thread (ambient_rocks_2_start());
	
end

script dormant temp_rumble_sound_start()
	sleep_until (volume_test_players (tv_rumble_start_1), 1);
	sound_impulse_start (sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_slides_loop, NONE, 1 );
	wake (temp_rumble_sound_stop);
end

script dormant temp_rumble_sound_stop()
	sleep_until (volume_test_players (tv_chaos_5), 1);
	sound_impulse_stop (sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_slides_loop);
end

script static void phantom_1_crashing()
	/*
	object_create (sce_phantom_crash_1);
	object_set_scale (sce_phantom_crash_1, 0.01, 0);
	object_set_scale (sce_phantom_crash_1, 0.5, 80);
	object_set_scale (sce_phantom_crash_1, 1.0, 40);
	object_move_to_point (sce_phantom_crash_1, 3.0, ps_phantom_crashes.p1);
	object_destroy (sce_phantom_crash_1);
	*/
	pup_play_show ("pup_phantom_crash");

	sleep_until (b_phantom_crash_1_explosion == TRUE);

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\phantom_crash\main_explosion.effect, ps_phantom_crashes.p1);
	
	sound_impulse_start('sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_01', NONE, 1 );
	// sound_impulse_start('sound\environments\solo\m030\vin\play_m30_ghost_escape_phantom_crash_02', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_phantom_crashes.p1);
	sleep (5);
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_phantom_crashes.p2);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sleep (5);
	thread (weak_camera_shake());

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\phantom_crash\main_explosion.effect, ps_phantom_crashes.p3);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_nodust.effect, ps_phantom_crashes.p3);
end

script dormant rock_slam_1()
	sleep_until (volume_test_players (tv_rock_slam_1), 1);
	
	// Jump #1
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_ghost_jump', NONE, 1 );	// player enters tv_rock_slam_1 right before jumping the ghost
	
	thread (phantom_debris());
	
	thread (rock_1_slamup());
	sleep (15);
	thread (rock_2_slamup());
	sleep (15);
	thread (rock_3_slamup());
	sleep (25);
	thread (rock_4_slamup());
	sleep (30);
	thread (rock_5_slamup());
	sleep (25);
	thread (rock_6_slamup());
	sleep (20);
	thread (rock_7_slamup());
	sleep (25);
	
	
end
	
script static void rock_1_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p4);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\sound\environments\solo\m030\vin\m30_ghost_escape_pillar3', rockslam_1, 1 );
	object_move_to_flag (rockslam_1, 0.3, flag_rockslam_1);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p4);
end

script static void rock_2_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p5);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rockslam_2, 0.3, flag_rockslam_2);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p5);
end

script static void rock_3_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p6);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar4to6', NONE, 1 );
	object_move_to_flag (rockslam_3, 0.3, flag_rockslam_3);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p6);
end

script static void rock_4_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p7);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rockslam_4, 0.3, flag_rockslam_4);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p7);
end

script static void rock_5_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p8);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rockslam_5, 0.3, flag_rockslam_5);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p8);
end

script static void rock_6_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p9);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rockslam_6, 0.3, flag_rockslam_6);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p9);
end

script static void rock_7_slamup()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p10);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rockslam_7, 0.3, flag_rockslam_7);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p10);
end

script static void phantom_debris()
	ai_place (sq_dead_phantom1);
	ai_place (sq_dead_phantom2);
	ai_place (sq_dead_phantom3);
	ai_place (sq_dead_phantom4);
	ai_place (sq_dead_phantom5);
	ai_place (sq_dead_phantom6);
	
	sleep (30 * 3);
	
	ai_place (sq_cov_panic_1);
	ai_place (sq_cov_panic_2);
	ai_place (sq_cov_panic_3);
	
	sleep (1);
	
	thread (cov_panic_1_flee_anims());
	thread (cov_panic_2_flee_anims());
	thread (cov_panic_3_flee_anims());
end

script static void cov_panic_1_flee_anims()
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_0), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_1), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_2), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_3), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_4), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_5), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_6), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_1.spawn_points_7), "flee");
end

script static void cov_panic_2_flee_anims()
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_0), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_1), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_2), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_3), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_4), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_5), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_6), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_2.spawn_points_7), "flee");
end

script static void cov_panic_3_flee_anims()
	unit_set_stance (ai_get_unit (sq_cov_panic_3.spawn_points_0), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_3.spawn_points_1), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_3.spawn_points_2), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_3.spawn_points_3), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_3.spawn_points_4), "flee");
end

script static void cov_panic_4_flee_anims()
	unit_set_stance (ai_get_unit (sq_cov_panic_4.spawn_points_0), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_4.spawn_points_1), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_4.spawn_points_2), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_4.spawn_points_3), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_4.spawn_points_4), "flee");
end

script static void cov_panic_5_flee_anims()
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_0), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_1), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_2), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_3), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_4), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_5), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_6), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_7), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_8), "flee");
	unit_set_stance (ai_get_unit (sq_cov_panic_5.spawn_points_9), "flee");
end

script command_script cs_cov_panic_1()
	cs_abort_on_damage (ai_current_actor, TRUE);
	cs_go_to (ps_cov_panic.p0);
	cs_go_to (ps_cov_panic.p1);
	cs_go_to (ps_cov_panic.p2);
	cs_go_to (ps_cov_panic.p3);
	cs_go_to (ps_cov_panic.p4);
	cs_go_to (ps_cov_panic.p5);
	cs_go_to (ps_cov_panic.p6);
	cs_go_to (ps_cov_panic.p7);
	cs_go_to (ps_cov_panic.p8);
	ai_kill (ai_current_actor);
end

script command_script cs_cov_panic_2()
	cs_abort_on_damage (ai_current_actor, TRUE);
	cs_go_to (ps_cov_panic.p3);
	cs_go_to (ps_cov_panic.p4);
	cs_go_to (ps_cov_panic.p5);
	cs_go_to (ps_cov_panic.p6);
	cs_go_to (ps_cov_panic.p7);
	cs_go_to (ps_cov_panic.p8);
	ai_kill (ai_current_actor);
end

script command_script cs_cov_panic_3()
	cs_abort_on_damage (ai_current_actor, TRUE);
	cs_go_to (ps_cov_panic.p5);
	cs_go_to (ps_cov_panic.p6);
	cs_go_to (ps_cov_panic.p7);
	cs_go_to (ps_cov_panic.p8);
	ai_kill (ai_current_actor);
end

script command_script sq_dead_phantom_explode()
	damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000);
	damage_object (unit_get_vehicle(ai_current_actor), hull, 10000);
end

script dormant escape_chaos_4()
	sleep_until (volume_test_players (tv_chaos_4), 1);
	
	sleep_s (r_medium_coop_delay);
	
	// Jump #2
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_ghost_jump', NONE, 1 );	// player enters escape_chaos_4 right before jumping the ghost
	
	thread (weak_camera_shake());
	
	escape_collapse_2->f_animate();
	thread (ragdoll_bodies());

	// wait for the player to exit tv_choas_4, this is right before the 3rd ghost jump
	sleep_until (volume_test_players (tv_chaos_4), 0);
	
	// Jump #3
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_ghost_jump', NONE, 1 );
end


script dormant escape_save_1()
	//sleep_until (f_escape_save_check (tv_escape_save_1, player0) or f_escape_save_check (tv_escape_save_1, player1) or f_escape_save_check (tv_escape_save_1, player2) or f_escape_save_check (tv_escape_save_1, player3), 1);
	sleep_until (volume_test_players (tv_escape_save_1), 1);
	
	if is_skull_active(skull_iron) then
		dprint ("You have iron skull on, WELCOME TO HELL");
	elseif game_is_cooperative() then
		
		sleep (5);
		
		volume_teleport_players_not_inside_with_vehicles (tv_escape_save_1,  flag_escape_teleport_1);
		
		sleep (5);
		
		game_save();
		
	elseif unit_in_vehicle (player0) then
		game_save();
	elseif not unit_in_vehicle (player0) then
		dprint ("Not in a vehicle - not going to save you!");	
	end	
	
	
end

script dormant escape_save_2()
	//sleep_until (f_escape_save_check (tv_escape_save_2, player0) or f_escape_save_check (tv_escape_save_2, player1) or f_escape_save_check (tv_escape_save_2, player2) or f_escape_save_check (tv_escape_save_2, player3), 1);
	sleep_until (volume_test_players (tv_escape_save_2), 1);
	
	if is_skull_active(skull_iron) then
		dprint ("You have iron skull on, WELCOME TO HELL");
	elseif game_is_cooperative() then
		
		sleep (5);
		
		volume_teleport_players_not_inside_with_vehicles (tv_escape_save_2,  flag_escape_teleport_2);
		
		sleep (5);
		
		game_save();
		
	elseif unit_in_vehicle (player0) then
		game_save();
	elseif not unit_in_vehicle (player0) then
		dprint ("Not in a vehicle - not going to save you!");	
	end	

end

script static boolean f_escape_save_check(trigger_volume tv_save, player p_player)
	volume_test_players (tv_save) and unit_in_vehicle (p_player);
end

script dormant escape_dead_phantom_cleanup()
	sleep_until (volume_test_players (tv_escape_save_2), 1);
	
	ai_place (sq_cov_panic_4);
	sleep (1);
	thread (cov_panic_4_flee_anims());
	ai_erase (sq_dead_phantom1);
	ai_erase (sq_dead_phantom2);
	ai_erase (sq_dead_phantom3);
	ai_erase (sq_dead_phantom4);
	ai_erase (sq_dead_phantom5);
	ai_erase (sq_dead_phantom6);
	ai_erase (sq_cov_panic_1);
	ai_erase (sq_cov_panic_2);
	ai_erase (sq_cov_panic_3);
	wake (cov_panic_2_kill);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p23);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (15);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p24);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (15);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p26);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (20);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p27);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	
end

script command_script cov_panic_2()
	cs_shoot (TRUE);
	cs_move_towards_point (ps_cov_panic_2.p1, 3);
	
end

script dormant cov_panic_2_kill()
	sleep_until (device_get_position (escape_collapse_4) > 0.2);

	ai_kill (sq_cov_panic_4);
end

script dormant large_ambient_fires()
	sleep_until (volume_test_players (tv_chaos_5), 1);
//	thread (ambient_rocks_3_start());
	thread (phantom_2_crashing());
	thread (ambient_fire_1());
	thread (ambient_fire_2());
	thread (ambient_fire_3());
	thread (ambient_fire_4());
	thread (ambient_fire_5());
	thread (ambient_fire_6());
	thread (ambient_fire_7());
	thread (ambient_fire_8());
	thread (ambient_fire_9());
	thread (ambient_fire_10());
	thread (ambient_fire_13());
	thread (ambient_fire_14());
	thread (ambient_fire_15());
	thread (ambient_fire_16());
	sleep (60);
	dprint ("world_move_1 go!");
	object_move_to_flag (world_move_1, 4.2, flag_world_move_1);
	
end

script dormant smaller_ambient_fires()
	sleep_until (volume_test_players (tv_chaos_5), 1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p0);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p2);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_small.effect, ps_phantom_fires_2.p3);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p4);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p5);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p6);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p7);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p8);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p9);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_small.effect, ps_phantom_fires_2.p11);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p12);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p13);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p14);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p15);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p16);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_small.effect, ps_phantom_fires_2.p17);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p18);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p19);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p20);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p21);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_phantom_fires_2.p22);
end

script static void ragdoll_bodies()
	object_wake_physics (body1);
	object_wake_physics (body2);
	object_wake_physics (body3);
	object_wake_physics (body4);
	object_wake_physics (body5);
	object_wake_physics (body6);
	object_wake_physics (body7);
	object_wake_physics (body8);
	object_wake_physics (body9);
	object_wake_physics (body10);
	object_wake_physics (body11);
	object_wake_physics (body12);
end

script static void ambient_fire_1()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p0);
end

script static void ambient_fire_2()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p1);
end

script static void ambient_fire_3()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p2);
end

script static void ambient_fire_4()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p3);
end

script static void ambient_fire_5()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p4);
end

script static void ambient_fire_6()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p5);
end

script static void ambient_fire_7()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p6);
end

script static void ambient_fire_8()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p7);
end

script static void ambient_fire_9()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p8);
end

script static void ambient_fire_10()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p9);
end

script static void ambient_fire_11()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p10);
end

script static void ambient_fire_12()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p11);
end

script static void ambient_fire_13()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p12);
end

script static void ambient_fire_14()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p13);
end

script static void ambient_fire_15()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p14);
end

script static void ambient_fire_16()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_fires.p15);
end


script static void phantom_2_crashing()
	
	//sleep_s (r_short_coop_delay);
	
	object_create (sce_phantom_crash_2);
	object_set_scale (sce_phantom_crash_2, 0.01, 0);
	object_set_scale (sce_phantom_crash_2, 1.0, 120);
	
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_phantom_incoming_02', sce_phantom_crash_2, 1 );
	object_move_to_point (sce_phantom_crash_2, 3.0, ps_phantom_crashes.p0);
	
	object_destroy (sce_phantom_crash_2);
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_phantom_crashes.p4);
	
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_create (phantom_crash_2_debris);
	thread (phantom_2_fire_1());
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\phantom_crash\phantom_cliff_explosion1.effect, ps_phantom_crashes.p4);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\phantom_crash\phantom_cliff_explosion2.effect, ps_phantom_crashes.p5);
	thread (phantom_2_fire_2());
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_phantom_crashes.p0);
	sound_impulse_start('sound\environments\solo\m030\vin\play_m30_ghost_escape_phantom_crash_02', sce_phantom_crash_2, 1 );
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	thread (phantom_2_fire_3());
end

script static void phantom_2_fire_1()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_crashes.p4);
end

script static void phantom_2_fire_2()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_crashes.p5);	
end

script static void phantom_2_fire_3()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_large.effect, ps_phantom_crashes.p0);	
end

script dormant escape_collapse_1()
	sleep_until (volume_test_players (tv_collapse_1), 1);
	sleep_s (r_medium_coop_delay);

	escape_collapse_1->f_animate();
	print ("device machine: escape_collapse_1 animating");
end

script dormant cave_collapse_1()
	sleep_until (volume_test_players (tv_cave_collapse), 1);
	
	sleep_s (r_medium_coop_delay);
	
	thread (strong_camera_shake());
	
	escape_collapse_3->f_animate();
end

script dormant cave_1_explosions()
	sleep_until (volume_test_players (tv_cave_1_explosions), 1);
	
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p0);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p0);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p1);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p1);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sleep (30);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p2);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p2);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p3);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p3);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sleep (30);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p4);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p4);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p5);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p5);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p6);
	//effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p6);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
end

script dormant corner_explosions()
	sleep_until (volume_test_players (tv_corner_explosions), 1);
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p9);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (20);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p10);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sleep (15);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p7);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p8);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
end

script dormant escape_chaos_6()
	sleep_until (volume_test_players (tv_chaos_8), 1);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p28);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar9', rock_raise_7, 1 );
	object_move_to_flag (rock_raise_7, 0.4, flag_rock_raise_7);
	object_move_to_flag (rock_raise_9, 2.8, flag_rock_raise_9);
end

script dormant escape_chaos_7()
	sleep_until (volume_test_players (tv_chaos_6), 1);
	
	// Jump #4
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_ghost_jump', NONE, 1 ); // player enters tv_chaos_6 right before a jump
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p11);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p12);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	
	thread (rock_raise_10_go());
	sleep (random_range (5, 45));
	thread (rock_raise_11_go());
	
end

script static void rock_raise_10_go()
	object_move_to_flag (rock_raise_10, 2.2, flag_rock_raise_10);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar10', rock_raise_10, 1 );
end

script static void rock_raise_11_go()
	object_move_to_flag (rock_raise_11, 2.8, flag_rock_raise_11);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
end

script dormant escape_chaos_8()
	sleep_until (volume_test_players (tv_chaos_7), 1);
	thread (weak_camera_shake());

	thread (rock_raise_12_go());
	thread (rock_raise_13_go());
	thread (rock_raise_14_go());
	sleep (30);
	
	object_move_to_flag (rock_raise_15, 6.8, flag_rock_raise_15);
end

script static void rock_raise_12_go()
	object_move_to_flag (rock_raise_12, 3.8, flag_rock_raise_12);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar14_turnoff_area2', rock_raise_12, 1 );
end

script static void rock_raise_13_go()
	object_move_to_flag (rock_raise_13, 4.2, flag_rock_raise_13);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
end

script static void rock_raise_14_go()
	object_move_to_flag (rock_raise_14, 4.1, flag_rock_raise_14);
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar15_stone_burst', rock_raise_14, 1 );
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
end

script dormant escape_collapse_4()
	sleep_until (volume_test_players (tv_escape_collapse_4), 1);
	
	//sleep_s (r_short_coop_delay);
	
	thread (weak_camera_shake());
	thread (escape_collapse_4_explosions());
	escape_collapse_4->f_animate();

end

script static void escape_collapse_4_explosions()
	sleep (30 * 3);
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p13);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p14);
	//sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (5);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p15);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
end

script dormant rock_ramp_raise()
	sleep_until (volume_test_players (tv_rock_ramp), 1);
	ai_place (sq_cov_panic_5);
	sleep (1);
	thread (cov_panic_5_flee_anims());
	
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar17_slide', rock_raise_16, 1 );
		
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p13);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p14);

	object_move_to_flag (rock_raise_16, 0.3, flag_rock_raise_16);

	sleep (25);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p19);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p20);

end

script dormant wall_moving_1()
	sleep_until (volume_test_players (tv_wall_crush), 1);
	
	sleep_s (r_medium_coop_delay);
	
	thread (weak_camera_shake());
	
	sound_impulse_start('sound\environments\solo\m030\vin\m30_ghost_escape_pillar18_22_collapse', wall_move_1, 1 );

	thread (wall_move_1_go());
	thread (wall_move_2_go());
	sleep (60);
	thread (rocksplosion_1_go());
	sleep (25);
	thread (rocksplosion_2_go());
	sleep (15);
	thread (rock_raise_17_go());
	thread (rocksplosion_3_go());
	sleep (20);
	thread (rocksplosion_4_go());
	sleep (10);
	thread (rocksplosion_5_go());
end

script static void wall_move_1_go()
	object_move_to_flag (wall_move_1, 6.8, flag_wall_move_1);
end

script static void wall_move_2_go()
	object_move_to_flag (wall_move_2, 6.8, flag_wall_move_2);
end

script static void rock_raise_17_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p15);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rock_raise_17, 1.2, flag_rock_raise_17);
end

script static void rocksplosion_1_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p16);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rocksplosion_1, 0.5, flag_rocksplosion_1);
end

script static void rocksplosion_2_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p17);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rocksplosion_2, 0.6, flag_rocksplosion_2);
end

script static void rocksplosion_3_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_raising.p18);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rocksplosion_3, 0.8, flag_rocksplosion_3);
end

script static void rocksplosion_4_go()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rocksplosion_4, 5.8, flag_rocksplosion_4);
end

script static void rocksplosion_5_go()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rocksplosion_5, 4.4, flag_rocksplosion_5);
end

script dormant cave_2_explosion()
	sleep_until (volume_test_players (tv_cave_2_explosions), 1);
	
	sleep_s (r_short_coop_delay);
	
	sleep (30);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p16);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (55);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p17);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (45);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p18);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (55);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p19);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_large.effect, ps_rubble_explosions_1.p20);
	sleep (65);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rubble_explosions_1.p21);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	//effect_new_at_ai_point (fx\reach\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large.effect, ps_rubble_explosions_1.p22);
end

script dormant escape_collapse_5()
	sleep_until (volume_test_players (tv_escape_collapse_5), 1);
	sleep_s (r_short_coop_delay);
	
	thread (weak_camera_shake());
	escape_collapse_5->f_animate();
	
end

script dormant rocksplosion_v2()
	sleep_until (volume_test_players (tv_chaos_9), 1);
	ai_erase (sq_cov_panic_5);
	ai_erase (sq_cov_panic_4);
	thread (rocksplosion_6_go());
	sleep (10);
	thread (rocksplosion_7_go());
	
end

script static void rocksplosion_6_go()
	object_move_to_flag (rocksplosion_6, 3.8, flag_rocksplosion_6);
end

script static void rocksplosion_7_go()
	object_move_to_flag (rocksplosion_7, 2.8, flag_rocksplosion_7);
end

script dormant escape_collapse_6()
	sleep_until (volume_test_players (tv_escape_collapse_7), 1);
	
	//sleep_s (r_short_coop_delay);
	
	effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_end.effect, escape_end_portal_flag);
	
	thread (weak_camera_shake());
	thread (terrain_fall_fx());
	escape_collapse_7->f_animate(tv_escape_collapse_7v2);
end

script dormant escape_collapse_8_go
	sleep_until (volume_test_players (tv_escape_collapse_7v2), 1);
	
	escape_collapse_8->f_animate();
end

script dormant escape_chaos_10()
	sleep_until (volume_test_players (tv_chaos_10), 1);
	
	thread (rock_boom_4_go());
	sleep (15);
	thread (rock_boom_1_go());
	sleep (15);
	thread (rock_boom_2_go());
	sleep (30);
	thread (rock_boom_3_go());
	
end

script static void terrain_fall_fx()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p1);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p2);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
end

script dormant terrain_fall_fx_2()
	sleep_until (volume_test_players (tv_escape_collapse_7v2), 1);
	
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p3);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sleep (10);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p4);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
end

script static void rock_boom_1_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p0);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rock_boom_1, 0.4, flag_rock_boom_1);
end

script static void rock_boom_2_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p5);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (rock_boom_2, 0.3, flag_rock_boom_2);
end

script static void rock_boom_3_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_rock_booms.p6);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (rock_boom_3, 0.5, flag_rock_boom_3);
end

script static void rock_boom_4_go()
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	sound_impulse_start('sound\environments\solo\m030\vin\play_m30_ghost_escape_pillar26to27', rock_boom_4, 1 );
	object_move_to_flag (rock_boom_4, 4.5, flag_rock_boom_4);
end

script dormant final_camera_shake()
	sleep_until (volume_test_players (tv_escape_collapse_7v2), 1);
	
	thread (weak_camera_shake());
	
end

script dormant escape_final_chaos()
	sleep_until (volume_test_players (tv_final_chaos), 1);
	
	sleep_s (r_short_coop_delay);
	
	thread (weak_camera_shake());
	
	thread (m30_level_end(player0));
	thread (m30_level_end(player1));
	thread (m30_level_end(player2));
	thread (m30_level_end(player3));
	
	thread (final_rock_1_go());
	thread (final_rock_2_go());
	
	sleep (15);
	
	thread (final_rock_3_go());
	thread (final_rock_4_go());
	
	sleep (15);
	
	thread (final_rock_5_go());
	thread (final_rock_6_go());
	
	thread (remove_ghost_respawns());

	sleep_until (volume_test_players (m30_escape_volume_end), 1);
	
	thread (f_mus_m30_e12_finish());
	
	effects_distortion_enabled = 1;
	self_illum_color_setting_set(0);
	
end

global boolean wake_m30_cinematic = true;

script static void m30_level_end (player p_player)
	sleep_until (volume_test_players (m30_escape_volume_end) and (unit_in_vehicle (p_player)), 1);
	
	unit_falling_damage_disable (player0, FALSE);
	unit_falling_damage_disable (player1, FALSE);
	unit_falling_damage_disable (player2, FALSE);
	unit_falling_damage_disable (player3, FALSE);
	
	thread (m30_flavor_cheevo_check (p_player));

	if wake_m30_cinematic then
		wake_m30_cinematic = false;
		effects_distortion_enabled = 1;
		self_illum_color_setting_set(0);
		wake (M30_escape_volume_end);
	end

end

script static void final_rock_1_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p0);
	
	sound_impulse_start('sound\environments\solo\m030\vin\play_m30_ghost_escape_pillar29to32_end', final_rock_1, 1 );
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (final_rock_1, 0.3, flag_final_rock_1);
end

script static void final_rock_2_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p1);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_1', NONE, 1 );
	object_move_to_flag (final_rock_2, 0.4, flag_final_rock_2);
end

script static void final_rock_3_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p2);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (final_rock_3, 0.5, flag_final_rock_3);
end

script static void final_rock_4_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p3);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (final_rock_4, 0.4, flag_final_rock_4);
end

script static void final_rock_5_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p4);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_3', NONE, 1 );
	object_move_to_flag (final_rock_5, 0.5, flag_final_rock_5);
end

script static void final_rock_6_go()
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\rock\rock_dust_burst_xl.effect, ps_final_rocks.p5);
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_m30_escape_run\Amb_m30_rock_explodes_tier_2', NONE, 1 );
	object_move_to_flag (final_rock_6, 0.4, flag_final_rock_6);
end

