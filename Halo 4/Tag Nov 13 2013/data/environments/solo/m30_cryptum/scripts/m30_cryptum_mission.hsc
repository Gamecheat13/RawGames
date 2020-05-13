//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//
//	Insertion Points:	start (or ipo)	- Beginning
//										ica							- Caves
//										ie1							- Exterior 1
//										ifo							- Fort 1
//										ib1							- Beams 1
//										is2							- Start Pylon 2
//										ie2							- Exterior 2
//										ib2							- Beams 2
//										ido							- Donut
//										icr							- Cryptum
//										ies							- Escape
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short pylon_1_activated_check = 0;
global boolean b_pylon1_shutdown_start = FALSE;
global boolean b_pylon2_shutdown_start = FALSE;
global boolean b_pylon1_portal_up = FALSE;
global boolean b_pylon2_portal_up = FALSE;

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m30_cryptum()
		
	//fade_out (255, 255, 255, 0);	
		
	if b_debug then 
		print_difficulty(); 
	end
	
	if b_debug then 
		print ("::: M30 - CRYPTUM :::");
	end
	
	if b_encounters then
		
		zone_set_trigger_volume_enable ("begin_zone_set:2_start", FALSE);
		zone_set_trigger_volume_enable ("zone_set:2_start", FALSE);
	
		zone_set_trigger_volume_enable ("begin_zone_set:3_donut", FALSE);
		zone_set_trigger_volume_enable ("zone_set:3_donut", FALSE);
		
		wake (m30_cryptum_intro_forerunners);
		wake (m30_cryptum_exterior_1);
		wake (m30_cryptum_forts_1);
		wake (m30_cryptum_exterior_2);
		wake (m30_cryptum_forts_2);
		wake (m30_cryptum_donut);
		wake (m30_cryptum_escape);
		wake (pylon_1_activated);
		wake (pylon_2_activated);
		//wake (chapter_two_display);
		wake (chapter_three_display);

		thread (door_setup());
		
		self_illum_color_setting_set(1);
		//effects_distortion_enabled = 0;
		
	objectives_set_string (0, m30_pause_obj_1);
	objectives_set_string (1, m30_pause_obj_2);
	objectives_set_string (2, m30_pause_obj_3);
	objectives_set_string (3, m30_pause_obj_4);
		
	end

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
	ai_lod_full_detail_actors (22);

end

// =================================================================================================
// M30 ACHIEVEMENTS
// =================================================================================================

script static void m30_flavor_cheevo_check (player p_player) 
	
	if (difficulty_heroic()) or (difficulty_legendary()) then
	
		if (unit_has_weapon (p_player, objects\weapons\rifle\storm_assault_rifle\storm_assault_rifle.weapon)) or (unit_has_weapon (p_player, objects\weapons\pistol\storm_magnum\storm_magnum.weapon)) then
			dprint ("You unlocked the Achievement This is my Rifle, This is my Gun");
			//achievement_grant_to_player (p_player, "m30_special");
			submit_incident_with_cause_player (achieve_m30_special, p_player);
		else
			dprint ("No UNSC Weapons: No cheevo for you, sorry!");
		end
	
	else	
		dprint ("Difficulty to low: No cheevo for you, sorry!");
	end	
		
end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()

	f_insertion_index_load( game_insertion_point_get() );                


end

// =================================================================================================
// =================================================================================================
// PYLON CONTROL
// =================================================================================================
// =================================================================================================


script dormant pylon_1_activated()
	sleep_until (volume_test_players (tv_pylon_1_setup), 1);
	object_hide (forts1_reclaimer, TRUE);
	device_group_set_immediate (pylon_1_devicegroup, 1);
	f_blip_flag (pylon_1_button_flag, "activate");
	game_save();
	wake (pylon_1_buttonpress);
	sleep (30);
	pylon1_door->f_animate();
end

script dormant pylon_1_buttonpress()
	sleep_until (device_get_position (pylon_1_button) != 0);
	 
	f_unblip_flag (pylon_1_button_flag);
	hud_play_global_animtion (screen_fade_out);
	sleep (15);
	local long show = pup_play_show(pylon1);
	hud_stop_global_animtion (screen_fade_out);

	device_group_set_immediate (pylon_1_devicegroup, 0);

	sleep_until (not pup_is_playing(show) , 1);
	
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);

	b_pylon1_shutdown_start = TRUE;
	
	sleep_until (b_pylon1_portal_up == TRUE);
	
	portal_count = 10;

	f_blip_flag (pylon_1_exit_flag, "default");
	
	thread (pylon_1_to_deck());

	
end

script static void pylon_1_to_deck()
	sleep_until (volume_test_players (tv_pylon_1_exit) and (portal_count == 10), 1);
		
	f_unblip_flag (pylon_1_exit_flag);
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleports.p3);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);
	
	object_teleport (player0, deck_portal_return_1);
	object_teleport (player1, deck_portal_return_2);
	object_teleport (player2, deck_portal_return_3);
	object_teleport (player3, deck_portal_return_4);
	
	print ("TELEPORT!");
	
	pup_play_show ("obs_portal");
	
	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	
end

script dormant pylon_2_activated()
	sleep_until (volume_test_players (tv_pylon_2_setup), 1);
	object_hide (forts2_reclaimer, TRUE);
	device_group_set_immediate (pylon_2_devicegroup, 1);
	f_blip_flag (pylon_2_button_flag, "activate");
	dprint ("pylon2 door is opening");

	game_save();
	wake (pylon_2_buttonpress);
	
	sleep (30);
	
	pylon2_door->f_animate();
end

script dormant pylon_2_buttonpress()
	sleep_until (device_get_position (pylon_2_button) != 0);

	f_unblip_flag (pylon_2_button_flag);
	hud_play_global_animtion (screen_fade_out);
	sleep (15);
	local long show = pup_play_show(pylon2);
	hud_stop_global_animtion (screen_fade_out);
	device_group_set_immediate (pylon_2_devicegroup, 0);	
	
	sleep_until (not pup_is_playing(show) , 1);
	
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);

	b_pylon2_shutdown_start = TRUE;
	
	sleep_until (b_pylon2_portal_up == TRUE);
	
	portal_count = 20;

	f_blip_flag (pylon_2_exit_flag, "default");

	thread (pylon_2_to_deck());

end


script static void pylon_2_to_deck()
	sleep_until (volume_test_players (tv_pylon_2_exit) and (portal_count == 20), 1);
	
	f_unblip_flag (pylon_2_exit_flag);
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleports.p4);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);

	object_teleport (player0, deck_portal_return_1);
	object_teleport (player1, deck_portal_return_2);
	object_teleport (player2, deck_portal_return_3);
	object_teleport (player3, deck_portal_return_4);
	
	print ("TELEPORT!");
	
	pup_play_show ("obs_portal");
	
	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	
end

// =================================================================================================
// =================================================================================================
// CHAPTER TITLES
// =================================================================================================
// =================================================================================================


script dormant chapter_one_display()
	sleep_until (volume_test_players (tv_tsb1) and (portal_count == 0), 1);
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (ch_chapter1);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);	
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
end

script dormant chapter_two_display()
	//sleep_until (volume_test_players (tv_tsb1) and (portal_count == 10), 1);
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (ch_chapter2);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
end

script dormant chapter_three_display()
	sleep_until (volume_test_players (tv_tsb_donut), 1);
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (ch_chapter3);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
end

script dormant chapter_four_display()

	sleep (30);

	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (ch_chapter4);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
	
end


// =================================================================================================
// =================================================================================================
// DOOR CONTROLS
// =================================================================================================
// =================================================================================================

script static void door_setup()
	thread (f_door_deck_open());
	thread (f_door_hallway_1_in_open());
	thread (f_door_hallway_1_out_open());
	thread (f_door_hallway_2_in_open());
	thread (f_door_hallway_2_out_open());
	thread (f_door_hallway_3_in_open());
	thread (f_door_hallway_3_out_open());
end

// observation_door_01 is the first door at the beginning of the level
script static void f_door_deck_open()
	sleep_until (volume_test_players (tv_deck_door_control), 1);
	dprint ("deck door opening");
	
	// special one-off for the observatory door
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_30_observation_deck_door_oneoff', observation_door_01, 1);
	
	observation_door_01->open_default();
	thread (f_door_deck_close());
end

script static void f_door_deck_close()
	sleep_until (not volume_test_players (tv_deck_door_control), 1);
	dprint ("deck door closing");

	observation_door_01->close_default();
	thread (f_door_deck_open());
end


script static void f_door_hallway_1_in_open()
	sleep_until (volume_test_players (tv_door_1_open) and (knight_gating == 15), 1);

	door_hallway_1_in->open_default();
	
	thread (f_door_hallway_1_in_close());
end

script static void f_door_hallway_1_in_close()
	sleep_until (volume_test_players (tv_door_1_close), 1);
	
	door_hallway_1_in->close_default();
	
	sleep_until (device_get_position (door_hallway_1_in) <= 0, 1);
	
	volume_teleport_players_not_inside (tv_door_1_close,  flag_caves_door_teleport);
	
	zoneset_prepare_and_load (zs_exterior1_idx);

	thread (f_door_hallway_1_out_open());
	
end

script static void f_door_hallway_1_out_open()
	sleep_until (volume_test_players (tv_door_2_open), 1);

	door_hallway_1_out->open_default();
	
	thread (f_door_hallway_1_out_close());
end

script static void f_door_hallway_1_out_close()
	sleep_until (volume_test_players (tv_door_2_close) and not volume_test_players (tv_door_2_open), 1);

	door_hallway_1_out->close_default();
	
	thread (f_door_hallway_1_out_open());
end

script static void f_door_hallway_2_in_open()
	sleep_until (volume_test_players (tv_door_3_upper_open), 1);

	door_hallway_2_in->open_default();
	
	thread (f_door_hallway_2_in_close());
end

script static void f_door_hallway_2_in_close()

	sleep_until (volume_test_players (tv_door_3_upper_close), 1);

	door_hallway_2_in->close_default();
	
	sleep_until (device_get_position (door_hallway_2_in) <= 0, 1);
	
	volume_teleport_players_not_inside(tv_door_3_upper_close,  flag_door_teleport);

	zoneset_prepare_and_load (zs_forts_idx);

	thread (f_door_hallway_2_out_open());
	
end

script static void f_door_hallway_2_out_open()
	sleep_until (volume_test_players (tv_door_4_upper_open), 1);

	door_hallway_2_out->open_default();
	
	thread (f_door_hallway_2_out_close());
end

script static void f_door_hallway_2_out_close()
	sleep_until (volume_test_players (tv_door_4_upper_close) and not volume_test_players (tv_door_4_upper_open), 1);
//	object_move_by_offset (door_4_upper, 1, 0, 0, -3);
	door_hallway_2_out->close_default();
	thread (f_door_hallway_2_out_open());
end

script static void f_door_hallway_3_in_open()
	sleep_until (volume_test_players (tv_door_5_open), 1);
//	object_move_by_offset (door_5, 1, 0, 0, 3);
	door_hallway_3_in->open_fast();
	thread (f_door_hallway_3_in_close());
end

script static void f_door_hallway_3_in_close()
	sleep_until (volume_test_players (tv_door_5_close), 1);
	
	wake (forts2_save);
	
	door_hallway_3_in->close_fast();
	
	//thread (f_door_hallway_3_in_open());
	
	sleep_until (device_get_position (door_hallway_3_in) <= 0, 1);
	
	volume_teleport_players_not_inside_with_vehicles (tv_door_5_close,  flag_ext2_door_teleport);
	
	zoneset_prepare_and_load (zs_forts2_idx);

	thread (f_door_hallway_3_out_open());
end

script static void f_door_hallway_3_out_open()
	sleep_until (volume_test_players (tv_door_6_open), 1);
//	object_move_by_offset (door_6, 1, 0, 0, 3);
	door_hallway_3_out->open_fast();
	thread (f_door_hallway_3_out_close());
end

script static void f_door_hallway_3_out_close()
	sleep_until (volume_test_players (tv_door_6_close) and not volume_test_players (tv_door_6_open), 1);
//	object_move_by_offset (door_6, 1, 0, 0, -3);
	door_hallway_3_out->close_fast();
	thread (f_door_hallway_3_out_open());
end

// =================================================================================================
// =================================================================================================
// ICS INVINCIBILITY
// =================================================================================================
// =================================================================================================

script static void ics_player_deathless_on()
 	dprint ("ICS player made invincible for ICS");
	object_cannot_die (g_ics_player, TRUE);
	//object_cannot_die (player1, TRUE);
	//object_cannot_die (player2, TRUE);
	//object_cannot_die (player3, TRUE);
end

script static void ics_player_deathless_off()
	dprint ("ICS player made vulnerable for ICS");
	object_cannot_die (g_ics_player, FALSE);
	//object_cannot_die (player1, TRUE);
	//object_cannot_die (player2, TRUE);
	//object_cannot_die (player3, TRUE);
end