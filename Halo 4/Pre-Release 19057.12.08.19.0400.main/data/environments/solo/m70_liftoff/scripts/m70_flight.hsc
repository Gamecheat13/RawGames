//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
// M70_FLIGHT
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

//==========================================
//FUNCTIONS_INDEX
//==========================================


//==========================================
//FLIGHT_VARIABLES
//==========================================

global boolean b_flight_launch_active = FALSE;
global boolean b_flight_insertion = FALSE;
global boolean b_flight_blip_clear = TRUE;
global boolean b_flight_main_spires_blip = FALSE;
global short s_flight_state = 0;

script static short S_DEF_FLIGHT_STATE_START()							1; end
script static short S_DEF_FLIGHT_STATE_START_COMPLETE()			2; end
script static short S_DEF_FLIGHT_STATE_SECOND()							3; end
script static short S_DEF_FLIGHT_STATE_SECOND_COMPLETE()		4; end
script static short S_DEF_FLIGHT_STATE_THIRD()							5; end
script static short S_DEF_FLIGHT_STATE_THIRD_COMPLETE()			6; end

global long l_didact_kill_volume = 0;

//==========================================
//FLIGHT_MAIN
//==========================================
// :: FLIGHT_INIT
script startup f_flight_startup()
	sleep_until( b_mission_started == TRUE, 1 );
	wake( f_flight_init ); 	// wake init
end


script dormant f_flight_init()
	dprint( "::: prepare f_flight_init :::" );
	// setup cleanup watch
	wake( f_flight_cleanup );
	
	sleep_until( F_Flight_Zone_Active(), 1);
	dprint( "::: f_flight_init :::" );
	// initialize modules
	wake( f_flight_AI_init );
	wake( f_flight_narrative_init );
	wake( f_flight_audio_init );
	wake( f_flight_FX_init );
	kill_volume_disable(kill_didact_attack);

	sleep(60);
	// initialize sub modules
	dprint("f_flight_main");
	if s_flight_state < S_DEF_FLIGHT_STATE_START_COMPLETE() then
		thread(f_flight_state_start());
	end
	
	if s_flight_state < S_DEF_FLIGHT_STATE_SECOND_COMPLETE() then
		thread(f_flight_state_second_spire());
	end

	if s_flight_state < S_DEF_FLIGHT_STATE_THIRD_COMPLETE() then
		thread(f_flight_state_third_spire());
	end
	
end

// :: FLIGHT_CLEANUP
script dormant f_flight_cleanup()
	sleep_until( s_flight_state >= S_DEF_FLIGHT_STATE_THIRD_COMPLETE(), 1 );
	dprint( "::: f_flight_cleanup :::" );

	// deinitialize modules
	wake( f_flight_AI_deinit );
	wake( f_flight_narrative_deinit );
	wake( f_flight_audio_deinit );
	wake( f_flight_FX_deinit );
	
	//functions
	sleep_forever( f_flight_init );
	//sleep_forever(f_flight_state_start);
	//sleep_forever(f_flight_state_second_spire);
//	sleep_forever(f_flight_state_third_spire);
	sleep_forever(f_flight_start_game_save);
	sleep_forever(f_flight_launch_main);
	sleep_forever(f_flight_launch_tutorial);
	sleep_forever(f_dlg_flight_first_spire);
	
end

//==========================================
//FLIGHT_GATES
//==========================================

// :: FLIGHT_GATES
script static boolean f_Flight_Zone_Active()
	( current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY_EXT ) or
	( current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_01_EXT ) or
	( current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_02_EXT ) or
	( current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_03_EXT );
end

script static boolean f_Flight_Zone_current_zoneset()
	( current_zone_set() == DEF_S_ZONESET_INFINITY_EXT ) or
	( current_zone_set() == DEF_S_ZONESET_SPIRE_01_EXT ) or
	( current_zone_set() == DEF_S_ZONESET_SPIRE_02_EXT ) or
	( current_zone_set() == DEF_S_ZONESET_SPIRE_03_EXT );
end
//================================
// FLIGHT_STATES
//================================

// :: STATE_START
script static void f_flight_state_start()
	sleep_until(s_flight_state == S_DEF_FLIGHT_STATE_START(), 1);
	dprint("f_flight_state_start");
	sleep_until(F_Flight_Zone_Active(), 1);
	data_mine_set_mission_segment ("m70_flight_01"); 
	//xxx test drop
	s_drop_protection_thread = thread(f_pelican_drop_protection());
	game_save_no_timeout();
	thread(f_flight_ai_spawn());
	thread(f_flight_flocks());
	thread(f_didact_ship());
	
	wake(f_flight_start_game_save);
	wake(f_flight_launch_main);
	//xxx DANGER this shit could break it all
	thread(f_anti_pelican_grief(inf_pelican_gunship));
	//XXX NAR
	//thread(f_flight_nar_defense_spires());
	
	sleep_until(not b_flight_launch_active, 1);
	
	wake(f_flight_infinity_depart);
	
	if game_is_cooperative() then
		thread(f_flight_airspace_coop_control());
		thread(f_flight_check_safe_to_respawn());
	end
	
	game_save_no_timeout();
	
	wake(f_nar_flight_first_didact_reveal);

	sleep_until(b_flight_main_spires_blip, 1);
	
	wake(f_nar_flight_first_spire_approach);
	
	thread(f_flight_blip_both_spires());
	
	
	thread(f_flight_start_spire_01());
	thread(f_flight_start_spire_02());
end


// :: STATE_SECOND
script static void f_flight_state_second_spire()
	sleep_until(s_flight_state == S_DEF_FLIGHT_STATE_SECOND() and f_check_first_spire_complete(), 1);
	dprint("f_flight_state_second_spire");
	sleep_until(F_Flight_Zone_Active(), 1);
	data_mine_set_mission_segment ("m70_flight_02"); 
	//xxx test drop
	kill_thread(s_drop_protection_thread);
	sleep(5);
	s_drop_protection_thread = thread(f_pelican_drop_protection());
	b_flight_blip_clear = FALSE;
	
	thread(f_flight_ai_spawn());
	thread(f_flight_flocks());
	thread(f_didact_ship());
	
	if game_is_cooperative() then
		thread(f_flight_airspace_coop_control());
		thread(f_flight_check_safe_to_respawn());
	end
//xxx DANGER this shit could break it all
	thread(f_anti_pelican_grief(flight_pelican_sp01));
	
	//XXX NAR
	wake(f_nar_flight_second_spire_approach);
	wake(f_nar_flight_second_didact_ship);

	game_save();

	f_pelican_open_flight();
	
	sleep_until(vehicle_test_players(), 1);
	sleep_s(2);
	f_m70_objective_set(ct_obj_spire_second);
	sleep_s(1);
	
	if not f_spire_state_complete(DEF_SPIRE_01) then
		f_blip_flag(flg_sp02_to_sp01, "recon");
		sleep_until(not volume_test_players(tv_flight_spire_02_landing_pad), 1);
		f_unblip_flag(flg_sp02_to_sp01);
		f_blip_flag(flg_spire_01_approach, "recon");
		thread(f_flight_blip_spire_01());
		thread(f_flight_start_spire_01());
	elseif not f_spire_state_complete(DEF_SPIRE_02) then
		f_blip_flag(flg_sp01_to_sp02, "recon");
		sleep_until(not volume_test_players(tv_flight_spire_01_landing_pad), 1);
		f_unblip_flag(flg_sp01_to_sp02);
		f_blip_flag(flg_spire_02_approach, "recon");
		thread(f_flight_blip_spire_02());
		thread(f_flight_start_spire_02());
	end
	
end

// :: STATE_THIRD
script static void f_flight_state_third_spire()
	sleep_until(s_flight_state == S_DEF_FLIGHT_STATE_THIRD() and f_check_both_spire_complete(), 1);
	dprint("f_flight_state_third_spire");
	sleep_until(F_Flight_Zone_Active(), 1);
	//xxx test drop
	kill_thread(s_drop_protection_thread);
	sleep(5);
	s_drop_protection_thread = thread(f_pelican_drop_protection());
	
	data_mine_set_mission_segment ("m70_flight_03"); 

	thread(f_flight_flocks());
	thread(f_didact_ship());

	thread(f_flight_didact_cryptum_kill_volume());
	
	if game_is_cooperative() then
		thread(f_flight_airspace_coop_control());
		thread(f_flight_check_safe_to_respawn());
	end
	
	//xxx DANGER this shit could break it all
	thread(f_anti_pelican_grief(flight_pelican_sp02));
	
	f_pelican_open_flight();
	
	sleep_until(vehicle_test_players(), 1);
	
	game_save();
	
	sleep_s(2);
	
	thread(f_m70_objective_set(ct_obj_spire_final));
	
	wake(f_nar_flight_didact_warning);
	
	wake(f_nar_flight_third_spire);
	
	if volume_test_players(tv_flight_spire_01_landing_pad) then
		f_flight_blip_clear_all();
		f_blip_flag(flg_sp01_to_sp03, "recon");
	elseif volume_test_players(tv_flight_spire_02_landing_pad) then
		f_flight_blip_clear_all();
		f_blip_flag(flg_sp02_to_sp03, "recon");
	end
	
	sleep_until(not volume_test_players(tv_flight_spire_01_landing_pad) and not volume_test_players(tv_flight_spire_02_landing_pad), 1);
	sleep_s(1);
	f_flight_blip_clear_all();

//xxx
//	thread(f_music_m70_v07_didact_voice_8());
	
	sleep_s(1.5);
	f_blip_flag(flg_spire_03_approach, "recon");	
	
	sleep_until(volume_test_players(tv_flight_spire_03_airspace) and f_check_both_spire_complete(), 1);
	thread(f_flight_spire_03());

end

//==========================
// FLIGHT_SPIRES
//==========================
script static boolean f_not_in_airspace()
	not volume_test_players_all(tv_flight_spire_02_airspace) and not volume_test_players_all(tv_flight_spire_01_airspace);
end

script static void f_flight_blip_clear_all()
	dprint("CLEAR ALL BLIPS");
	f_unblip_flag(flg_spire_01_approach);
	f_unblip_flag(flg_spire_02_approach);	
	f_unblip_flag(flg_spire_03_approach);
	f_unblip_flag(flg_spire_01_entrance);
	f_unblip_flag(flg_spire_02_entrance);
	f_unblip_flag(flg_spire_03_entrance);
	f_unblip_flag(flg_sp01_enter);
	f_unblip_flag(flg_sp02_enter);
	f_unblip_flag(flg_sp03_enter);
	f_unblip_flag(flg_sp01_to_sp03);
	f_unblip_flag(flg_sp02_to_sp03);
end



script static void f_flight_blip_both_spires()
	dprint("f_flight_blip_both_spires");
	repeat
		local long l_sp01_blip_thd_id = thread(f_flight_blip_spire_01());
		local long l_sp02_blip_thd_id = thread(f_flight_blip_spire_02());
		sleep_until(volume_test_players(tv_flight_spire_01_airspace) or volume_test_players(tv_flight_spire_02_airspace), 1);

		sleep_s(0.50);
		sleep_until(not volume_test_players(tv_flight_spire_01_airspace) and not volume_test_players(tv_flight_spire_02_airspace), 1);

		kill_thread(l_sp01_blip_thd_id);
		kill_thread(l_sp02_blip_thd_id);
		sleep_s(0.25);
		f_flight_blip_clear_all();
		sleep_s(0.25);
		until(f_spires_state_active(), 1);
		f_flight_blip_clear_all();
end

script static void f_flight_blip_spire_01()
	dprint("f_flight_blip_spire_01");
	f_blip_flag(flg_spire_01_approach, "recon");
	sleep_until(volume_test_players_all(tv_flight_spire_01_airspace) or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
		
		if not f_spires_state_active() then
			sleep_s(0.25);
			f_blip_flag(flg_spire_01_entrance, "recon");
		end
	sleep_until( not vehicle_test_players_all() or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
		
		if not f_spires_state_active() then
		sleep_s(0.25);
		f_blip_flag(flg_sp01_enter, "recon");
		end
	sleep_until(volume_test_players(tv_flight_spire_01_entrance) or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
end


script static void f_flight_blip_spire_02()
	dprint("f_flight_blip_spire_02");
	dprint("blip spire_02_approach");
	f_blip_flag(flg_spire_02_approach, "recon");
	sleep_until(volume_test_players_all(tv_flight_spire_02_airspace)  or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
		if not f_spires_state_active() then
		sleep_s(0.25);
		dprint("blip enter");
		f_blip_flag(flg_spire_02_entrance, "recon");
		end
	sleep_until( not vehicle_test_players_all()  or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
		if not f_spires_state_active() then
		sleep_s(0.25);
		dprint("blip enter_2");
		f_blip_flag(flg_sp02_enter, "recon");
		end
	sleep_until(volume_test_players(tv_flight_spire_02_entrance)  or f_spires_state_active(), 1);
		f_flight_blip_clear_all();
end


script static void f_flight_start_spire_01()
	dprint("f_flight_spire_01");
	
	local long nudge_thread_01 = thread(f_flight_nudge_lower_pelican(tv_sp01_landing_nudge, sg_flight_sp01));
	
	sleep_until(volume_test_players(tv_flight_spire_01_entrance) or f_spires_state_active(), 1);
		
		if not f_spires_state_active() then
			f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_START());
			game_save_no_timeout();
		end
		
	kill_thread(nudge_thread_01);
end

script static void f_flight_start_spire_02()
	dprint("f_flight_spire_02");
	local long nudge_thread_02 = thread(f_flight_nudge_lower_pelican(tv_sp02_landing_nudge, sg_flight_sp02));
	
	sleep_until(volume_test_players(tv_flight_spire_02_entrance) or f_spires_state_active(), 1);
	if not f_spires_state_active() then
		f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_START());
		game_save_no_timeout();
	end
	kill_thread(nudge_thread_02);
end

script static void f_flight_spire_03()
	sleep_until(s_flight_state == S_DEF_FLIGHT_STATE_THIRD() and f_check_both_spire_complete(), 1);
	dprint("f_flight_spire_03");
	local long pup_show_sp03_door = pup_play_show(pup_spire_03_door_open);
	
	sleep_until(volume_test_players(tv_flight_spire_03_door), 1);
	
	f_flight_blip_clear_all();
	
	sleep_until (not pup_is_playing(pup_show_sp03_door), 1);
	
	local long nudge_thread_03 = thread(f_flight_nudge_lower_pelican(tv_sp03_landing_nudge, sg_flight_sp03));
	
	f_spire_state_set ( DEF_SPIRE_03, DEF_SPIRE_STATE_START());
	
	sleep_s(1.5);

	f_blip_flag(flg_spire_03_entrance, "recon");	
	
	sleep_until(not vehicle_test_players_all(), 1);
	
	f_flight_blip_clear_all();
	
	sleep_s(1);
	
	if not f_spires_state_active() then
		f_blip_flag(flg_sp03_enter, "recon");	
	end
	
	sleep_until(volume_test_players(tv_flight_spire_03_entrance) or f_spires_state_active(), 1);
	
	sleep_s(0.25);
	f_flight_blip_clear_all();
	kill_thread(nudge_thread_03);
end

// :: FLIGHT_GAME_SAVE
script dormant f_flight_start_game_save()
	dprint("f_flight_start_game_save");
end

//==============================
// DIDACT_SHIP
//==============================
// :: DIDACT_SHIP_REVEAL
script static void f_didact_ship()
dprint("f_didact_ship");
	object_create_anew(cr_didact_ship);
	sleep_until(object_valid(cr_didact_ship), 1);
	if not object_valid(cr_didact_ship) then
		object_create(cr_didact_ship);
	end
	
	if s_flight_state <= S_DEF_FLIGHT_STATE_START() then
		if not object_valid(cr_didact_shield_large) then
			dprint("Didact large shield");
			object_create(cr_didact_shield_large);
			thread(f_flight_didact_large_shield_kill_volume()); //256
		end
		if object_valid(cr_didact_shield_small) then
			object_destroy(cr_didact_shield_small);
		end
	elseif s_flight_state == S_DEF_FLIGHT_STATE_SECOND() then
		//effect_new_on_object_marker( environments\solo\m70_liftoff\fx\cryptum\cryptum_shield_small.effect, cr_didact_ship, fx_ambient);
		if not object_valid(cr_didact_shield_small) then
			object_create(cr_didact_shield_small);
			thread(f_flight_didact_small_shield_kill_volume()); //256
		end
		if object_valid(cr_didact_shield_large) then
			object_destroy(cr_didact_shield_large);
		end
	else
		if not object_valid(cr_didact_shield_small) then
			object_destroy(cr_didact_shield_small);
		end
		if object_valid(cr_didact_shield_large) then
			object_destroy(cr_didact_shield_large);
		end
	end
end

script static void cryptum_fx_test_shield()
	dprint("FX cryptum fx shield PLAY");
	effect_new_on_object_marker( environments\solo\m70_liftoff\fx\cryptum\cryptum_shield.effect, cr_didact_ship, fx_ambient);
end

script static void cryptum_fx_test_shield_small()
	dprint("FX cryptum fx shield PLAY");
	effect_new_on_object_marker( environments\solo\m70_liftoff\fx\cryptum\cryptum_shield_small.effect, cr_didact_ship, fx_ambient);
end

//=========================================
// FLIGHT_SENTINALS
//=========================================
//flock_destroy(flock_flight_spire_01_sent);
script static void f_flight_flocks()
	thread(f_flight_flocking_cruisers());
	thread(f_flight_flocking_lich());
end

script static void f_flight_flocking_cruisers()
dprint("f_flight_flocking_cruisers");
	local long show_flight_flocking_cruisers = pup_play_show(pup_ambient_ships);
	sleep_until(not F_Flight_Zone_Active(), 1);
	pup_stop_show(show_flight_flocking_cruisers);
end

script static void f_flight_flocking_lich()
	dprint("f_flight_flocking_lich");
	flock_create(flock_flight_lich_01);
	flock_create(flock_flight_lich_02);
	flock_create(flock_flight_lich_03);
	flock_create(flock_flight_lich_04);
	sleep_until(not f_Flight_Zone_current_zoneset(), 1);
	flock_destroy(flock_flight_lich_01);
	flock_destroy(flock_flight_lich_02);
	flock_destroy(flock_flight_lich_03);
	flock_destroy(flock_flight_lich_04);
	garbage_collect_now();
end

//======================================
// FLIGHT_LAUNCH
//======================================
//xxx set player
////
script dormant f_flight_launch_kill_volume_control()
	dprint("f_flight_launch_kill_volume_control");
	kill_volume_disable(kill_soft_04);
	sleep_until(volume_test_players(tv_flight_didact_ship_reveal), 1);
	sleep_s(4);
	kill_volume_enable(kill_soft_04);
end
// :: FLIGHT_LAUNCH_MAIN
script dormant f_flight_launch_main()
	dprint("f_flight_launch");
	b_flight_launch_active = TRUE;
	object_create(dm_flight_launch_tube);
	wake(f_flight_launch_kill_volume_control);
	
	//f_set_current_pilot();
	object_teleport_to_ai_point(inf_pelican_gunship, ps_pelican_launch.p_start);
	//objects_attach(sc_flight_sync_action, "", inf_pelican_gunship, "landing_tires" );
	sleep(25);
	player_control_lock_gaze(player0(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player1(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player2(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player3(), ps_pelican_launch.p_end, 500);
	
	pup_play_show(pup_pelican_launch);
	sleep(5);
	fade_in(0, 0, 0, 360);
	
	wake(f_flight_launch_tutorial);
	
	thread(f_m70_chapter_title(ch_flight));
	
	wake(f_dlg_flight_launch_start);
	
	game_save();

	sleep_until(b_pelican_launch_triggered, 1);
	
	thread(f_launch_return_control());
	
	sleep_s(5);
	object_destroy(dm_flight_launch_tube);
	
	//object_move_to_point(sc_flight_sync_action, 1, ps_pelican_launch.p_end);
	//objects_detach(sc_pelican_octopus, inf_pelican_gunship);
	//object_set_velocity(inf_pelican_gunship, 50);
	b_flight_launch_active = FALSE;
	
end


// :: FLIGHT_LAUNCH_RETURN_CONTROL
script static void f_launch_return_control()
	sleep_s(5);
	player_enable_input(TRUE);
	player_control_unlock_gaze(player0);
	player_control_unlock_gaze(player1);
	player_control_unlock_gaze(player2);
	player_control_unlock_gaze(player3);
	sleep_s(0.25);
	player_disable_movement(FALSE);
	hud_show_radar (TRUE);
	hud_show_shield (TRUE);
	hud_show_weapon (TRUE);
	hud_show_crosshair(TRUE);
end

//=========================================
// FLIGHT_PELICAN_LAUNCH_TUTORIAL
//=========================================

// :: LAUNCH_TUTORIAL
global boolean b_pelican_launch_triggered = FALSE;

script dormant f_flight_launch_tutorial()
	dprint("f_flight_launch_tutorial");
	f_flight_set_pilot(inf_pelican_gunship);
	sleep_s(1);
	sleep_until(dialog_id_played_check(L_dlg_flight_launch_start), 1);
	
	chud_show_screen_training( p_pelican_pilot, "pelican_boost" );
	unit_action_test_reset (p_pelican_pilot);
	
	sleep_until ( unit_action_test_grenade_trigger (p_pelican_pilot) );
	b_pelican_launch_triggered = TRUE;
	//NotifyLevel("flight_launch_start");
	
	chud_show_screen_training (p_pelican_pilot, "");
	sound_impulse_start (sfx_tutorial_complete, p_pelican_pilot, 1);
	
	sleep_until(not b_flight_launch_active, 1);
	
	game_safe_to_respawn(TRUE);
	
	//xxx narative
	wake( m70_first_flight );
	wake( f_dlg_flight_a_tutorial );
	sleep_s(1.75);
	f_flight_pelican_tutorial(p_pelican_pilot, "pelican_steer", 4);
	sleep_s(1);
	f_flight_pelican_tutorial(p_pelican_pilot, "pelican_rise", 4);
	sleep_s(1);
	f_flight_pelican_tutorial(p_pelican_pilot, "pelican_descend", 4);
	//sleep_s(1);
	//f_flight_pelican_tutorial(p_pelican_pilot, "pelican_weapon_swap", 4);
end

// :: FLIGHT_PELICAN_TUTORIALS

script static void f_flight_pelican_tutorial(player player_num, string_id display_title, real r_time)
	chud_show_screen_training (player_num, "display_title");
	if r_time == 0 then
		unit_action_test_reset (player_num);
		sleep_until ( f_get_unit_action_test(display_title, player_num));
	else
		r_time = (game_tick_get() + (r_time * 30));
		unit_action_test_reset (player_num);
		sleep_until ( r_time <= game_tick_get() or f_get_unit_action_test(display_title, player_num));
	end

	sleep_s(1);

	chud_show_screen_training (player_num, "");
	sound_impulse_start (sfx_tutorial_complete, player_num, 1);
end
	
// :: GET_UNIT_ACTION_TEST
script static boolean f_get_unit_action_test(string_id display_title, player player_num)
	
	if display_title == "pelican_move" then 
		unit_action_test_move_relative_all_directions(player_num);
	elseif display_title == "pelican_steer" then 
		unit_action_test_move_relative_all_directions(player_num);
	elseif display_title == "pelican_rise" then 
		unit_action_test_melee (player_num);
	elseif display_title == "pelican_descend" then 
		unit_action_test_equipment (player_num);	
	elseif display_title == "pelican_boost" then 
		unit_action_test_grenade_trigger (player_num);
	elseif display_title == "pelican_shoot" then 
		unit_action_test_primary_trigger(player_num);
	elseif display_title == "pelican_shoot_secondary" then 
		unit_action_test_primary_trigger(player_num);
	elseif display_title == "pelican_weapon_swap" then 
		unit_action_test_rotate_weapons(player_num);
	end
	
end



script static void f_flight_nudge_lower_pelican(trigger_volume tv_spire, ai spire_air_squad)
	dprint("f_flight_nudge_lower_pelican");
	repeat
	
	sleep_until(volume_test_players(tv_spire) and ai_living_count(spire_air_squad) <= 0 or not vehicle_test_players_all(), 1);
	sleep_s(10);
	
	if volume_test_players(tv_spire) and vehicle_test_players_all() then
		f_flight_pelican_tutorial(p_pelican_pilot, "pelican_descend", 4);
	end
	sleep_s(20);
	until(not f_Flight_Zone_Active() or not vehicle_test_players_all(), 1);

end

//f_flight_nudge_lower_pelican(tv_sp01_landing_nudge, sg_flight_sp01)
//f_flight_nudge_lower_pelican(tv_sp02_landing_nudge, sg_flight_sp02)
//f_flight_nudge_lower_pelican(tv_sp03_landing_nudge, sg_flight_sp03)


//======================================
// FLIGHT_NARRATIVE
//======================================


//xxx NAR ADD

script static void f_flight_nar_defense_spires()
	dprint("f_flight_nar_defense_spires");
	sleep_until( volume_test_players(tv_flight_spire_01_landing_pad) or volume_test_players(tv_flight_spire_02_landing_pad),1);
	repeat	
	
	sleep_until( volume_test_players(tv_flight_spire_01_landing_pad) or volume_test_players(tv_flight_spire_02_landing_pad) or not f_Flight_Zone_Active(),1);
	
	if f_Flight_Zone_Active() then
		b_first_flight_defense_spires = TRUE;
	end
	
	sleep_until( not volume_test_players(tv_flight_spire_01_landing_pad) or not volume_test_players(tv_flight_spire_02_landing_pad) or not f_Flight_Zone_Active(),1);
	
	if f_Flight_Zone_Active() then
		b_first_flight_defense_spires = FALSE;
	end
	
	until(not f_Flight_Zone_Active(), 1);

end
//256
//171
//110

//s_flight_state > S_DEF_FLIGHT_STATE_SECOND();	
//s_flight_state > S_DEF_FLIGHT_STATE_THIRD();	
script static void f_flight_didact_large_shield_kill_volume()
	sleep_until(objects_distance_to_flag(players(), flg_didact_center) <= 256 or s_flight_state > S_DEF_FLIGHT_STATE_START(), 1);
	//xxx 
	//add kill effect
	//sleep(15);
	if s_flight_state <= S_DEF_FLIGHT_STATE_START() then
	thread(f_flight_didact_kill_effect());
	f_flight_didact_kill_pelican();
	end
end

script static void f_flight_didact_small_shield_kill_volume()
	sleep_until(objects_distance_to_flag(players(), flg_didact_center) <= 170 or s_flight_state > S_DEF_FLIGHT_STATE_SECOND(), 1);
	if s_flight_state <= S_DEF_FLIGHT_STATE_SECOND() then
	thread(f_flight_didact_kill_effect());
	f_flight_didact_kill_pelican();
	end
end

script static void f_flight_didact_cryptum_kill_volume()
	sleep_until(objects_distance_to_flag(players(), flg_didact_center) <= 180 or s_flight_state > S_DEF_FLIGHT_STATE_THIRD(), 1);
	//xxx 
	//add kill effect
	//sleep(15);
	if s_flight_state <= S_DEF_FLIGHT_STATE_THIRD() then
	thread(f_flight_didact_kill_effect());
	sleep_s(0.25);
	f_flight_didact_kill_pelican();
	thread(f_flight_didact_kill_effect());
	end
end


script static void f_flight_didact_kill_pelican()
damage_object (unit_get_vehicle(player_get_first_alive() ), hull, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), engine_lb, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), engine_lf, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), engine_rb, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), engine_rf, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), stands, 10000);
damage_object (unit_get_vehicle(player_get_first_alive() ), turrets, 10000);

end



script dormant f_nar_flight_didact_warning()
	dprint("f_flight_nar_didact_warning");
	repeat
	sleep_until(volume_test_players(tv_didact_warning) or not f_Flight_Zone_Active(), 1);
	
	if f_Flight_Zone_Active() then
		b_third_flight_near_didact = TRUE;
	end
	
	sleep_until(not volume_test_players(tv_didact_warning) or not f_Flight_Zone_Active(), 1);
	
	if f_Flight_Zone_Active() then
		b_third_flight_near_didact = FALSE;
	end
	
	until(not f_Flight_Zone_Active(), 1);
end

//co-op controls
// vehicle_test_players_all()
//vehicle_test_players()
//if game_is_cooperative() then

script static void f_flight_airspace_coop_control()
local short current_zoneset = 0;
local short new_zoneset = 0;
	repeat
		if f_Flight_Zone_current_zoneset() then
			
			//sleep_until(PreparingToSwitchZoneSet(), 1);	
			//sleep_s(1);
			//sleep_until(not PreparingToSwitchZoneSet(), 1);			
			
			if current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY_EXT and f_players_in_vehicle_but_not_all() and f_players_abandoned_infinity() then
				thread(f_flight_fade_to_teleport(inf_pelican_gunship, inf_pelican_gunship));
				thread(f_flight_fade_to_teleport(flight_pelican_sp01, flight_pelican_sp01));
				thread(f_flight_fade_to_teleport(flight_pelican_sp02, flight_pelican_sp02)); 
			end
			
			if current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_01_EXT and f_players_in_vehicle_but_not_all() and f_players_abandoned_on_spire_1() then
				thread(f_flight_fade_to_teleport(inf_pelican_gunship, inf_pelican_gunship));
				thread(f_flight_fade_to_teleport(flight_pelican_sp01, flight_pelican_sp01));
				thread(f_flight_fade_to_teleport(flight_pelican_sp02, flight_pelican_sp02));
			end
			
			if current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_02_EXT and f_players_in_vehicle_but_not_all() and f_players_abandoned_on_spire_2() then
				thread(f_flight_fade_to_teleport(inf_pelican_gunship, inf_pelican_gunship));
				thread(f_flight_fade_to_teleport(flight_pelican_sp01, flight_pelican_sp01));
				thread(f_flight_fade_to_teleport(flight_pelican_sp02, flight_pelican_sp02));
			end
			
			if current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_03_EXT and f_players_in_vehicle_but_not_all() and f_players_abandoned_on_spire_3() then
				thread(f_flight_fade_to_teleport(inf_pelican_gunship, inf_pelican_gunship));
				thread(f_flight_fade_to_teleport(flight_pelican_sp01, flight_pelican_sp01));
				thread(f_flight_fade_to_teleport(flight_pelican_sp02, flight_pelican_sp02));
			end
			
		end
		
	until(not f_Flight_Zone_current_zoneset(), 1);
	
end

script static void f_flight_fade_to_teleport(object_name obj_pelican, vehicle v_pelican)
	dprint("check fade teleport");
	if object_valid(obj_pelican) and player_in_vehicle(v_pelican) then
		teleport_players_into_vehicle(v_pelican);
	end
end

script static boolean f_players_in_vehicle_but_not_all()
	vehicle_test_players() and not vehicle_test_players_all();
end

script static boolean f_players_abandoned_infinity()
f_players_abandoned_on_spire_1() or f_players_abandoned_on_spire_2() or f_players_abandoned_on_spire_3();
end
script static boolean f_players_abandoned_on_spire_1()
	volume_test_players( tv_flight_spire_01_airspace) and not volume_test_players_all(tv_flight_spire_01_airspace);
end

script static boolean f_players_abandoned_on_spire_2()
	volume_test_players( tv_flight_spire_02_airspace) and not volume_test_players_all(tv_flight_spire_02_airspace);
end

script static boolean f_players_abandoned_on_spire_3()
	volume_test_players( tv_flight_spire_03_airspace) and not volume_test_players_all(tv_flight_spire_03_airspace);
end


//script static void f_flight_fade_to_teleport(object_name obj_pelican, vehicle v_pelican)
	//dprint("check fade teleport");
	/*
	local boolean b_player0_fade = FALSE;
	local boolean b_player1_fade = FALSE;
	local boolean b_player2_fade = FALSE;
	local boolean b_player3_fade = FALSE;
	*/
	//if object_valid(obj_pelican) and player_in_vehicle(v_pelican) then
	/*
		if not unit_in_vehicle (player0()) and  then
			fade_out_for_player(player0());
			b_player0_fade = TRUE;
		end
		
		if not unit_in_vehicle (player1()) and f_flight_player_in_landingpad() then
			fade_out_for_player (player1());
			b_player1_fade = TRUE;
		end
		
		if not unit_in_vehicle (player2()) and f_flight_player_in_landingpad() then
			fade_out_for_player(player2());
			b_player2_fade = TRUE;
		end
		
		if not unit_in_vehicle (player3()) and f_flight_player_in_landingpad() then
			fade_out_for_player(player3());
			b_player3_fade = TRUE;
		end
		*/
		//sleep_s(3);
		//teleport_players_into_vehicle(v_pelican);
		/*
		if b_player0_fade then
			fade_in_for_player(player0());
			b_player0_fade = FALSE;
		end
	
		if b_player1_fade then
			fade_in_for_player(player1());
			b_player1_fade = FALSE;
		end
	
		if b_player2_fade then
			fade_in_for_player(player2());
			b_player2_fade = FALSE;
		end
	
		if b_player3_fade then
			fade_in_for_player(player3());
			b_player3_fade = FALSE;
		end
		*/
	//end
//end



//inf_pelican_gunship
//flight_pelican_sp01
//flight_pelican_sp02


script static boolean f_flight_pelican_in_airspace(object_name obj_pelican)
	volume_test_object(tv_flight_spire_01_door , obj_pelican ) or
	volume_test_object(tv_flight_spire_02_door , obj_pelican) or
	volume_test_object(tv_flight_spire_03_door , obj_pelican);
end

script static boolean f_flight_player_in_landingpad()
	volume_test_players(tv_flight_spire_01_pilot_valid) and
	volume_test_players(tv_flight_spire_02_pilot_valid) and
  volume_test_players(tv_flight_spire_03_pilot_valid);
end

////////////////////////////////
script dormant f_flight_infinity_depart()
	object_create_anew(sc_infinity);
	sleep_until(object_valid(sc_infinity), 1);	
	effect_new_on_object_marker(cinematics\cin_m032_end\fx\Infinity\fx_18_left_engine_flare.effect, sc_infinity, "fx_enginethrust_left"); 
	effect_new_on_object_marker(cinematics\cin_m032_end\fx\Infinity\fx_18_center_engine_flare.effect, sc_infinity, "fx_enginethrust_main"); 
	effect_new_on_object_marker(cinematics\cin_m032_end\fx\Infinity\fx_18_right_engine_flare.effect, sc_infinity, "fx_enginethrust_right"); 
	pup_play_show(pup_inf_leaving);
end


script static void f_pelican_open_flight()
	sleep_until(object_valid(flight_pelican_sp01) or object_valid(flight_pelican_sp02), 1);
	if object_valid(flight_pelican_sp01) then
		thread(f_pelican_open_spires(flg_sp01_pelican, flight_pelican_sp01,flight_pelican_sp01, tv_sp01_pelican));
		thread(f_sp01_blip_armory());
	elseif object_valid(flight_pelican_sp02) then
		thread(f_pelican_open_spires(flg_sp02_pelican, flight_pelican_sp02,flight_pelican_sp02, tv_sp02_pelican));
		thread(f_sp02_blip_armory());
	end
end

script static void f_pelican_open_spires(cutscene_flag flag_blip, vehicle v_pelican, object_name obj_pelican, trigger_volume tv_lookat)
f_blip_flag(flag_blip, "recon");
sleep_until(volume_test_players_all_lookat(tv_lookat, 25, 25), 1);
if object_valid(obj_pelican) then
	unit_open(v_pelican);
	sleep_s(1);
end
sleep_until(vehicle_test_seat (v_pelican, "pelican_d") or not object_valid(obj_pelican), 1);
if object_valid(obj_pelican) then
	unit_close(v_pelican);
end
sleep_until(vehicle_test_players(), 1);
f_unblip_flag(flag_blip);
end



script static void f_sp01_blip_armory()
	sleep_s(2);
	f_blip_flag( flg_sp01_pelican_armory_1, "ammo");
	f_blip_flag( flg_sp01_pelican_armory_2, "ammo");
	sleep_until(volume_test_players(tv_sp01_pelican_armory_nudge) or vehicle_test_players(), 1);
	f_unblip_flag(flg_sp01_pelican_armory_1);
	f_unblip_flag(flg_sp01_pelican_armory_2);
end



script static void f_sp02_blip_armory()
	sleep_s(2);
	f_blip_flag( flg_sp02_pelican_armory_1, "ammo");
	f_blip_flag( flg_sp02_pelican_armory_2, "ammo");
	sleep_until(volume_test_players(tv_sp02_pelican_armory_nudge) or vehicle_test_players(), 1);
	f_unblip_flag(flg_sp02_pelican_armory_1);
	f_unblip_flag(flg_sp02_pelican_armory_2);
end


//xxx DANGER this shit could break it all
script static void f_anti_pelican_grief(object_name obj_pelican)
	sleep_until(object_get_health(obj_pelican) <= 0 or not f_Flight_Zone_current_zoneset(), 1);
	dprint("pelican gone??");
	sleep_s(10);
	if f_Flight_Zone_Active() then
		if object_get_health(player0()) > 0 or object_get_health(player1()) > 0 or object_get_health(player2()) > 0 or object_get_health(player3()) > 0  then 
		dprint("pelican gone");
		dprint("revert?");
			//fade_out(0,0,0, 3);
			//sleep_s(4);
			//dprint("revert in 2 seconds");
		//	game_revert();
			//sleep_s(2);
			//fade_in(0,0,0, 3);
		end
	end
end

script static void f_flight_check_safe_to_respawn()
	repeat
		if not f_flight_player_in_airspace() and vehicle_test_players() then
			game_safe_to_respawn (FALSE);
		else
			game_safe_to_respawn (TRUE);		
		end
		
	until(not f_Flight_Zone_current_zoneset(), 1);
	
		game_safe_to_respawn (TRUE);
end

script static boolean f_flight_player_in_airspace()
	volume_test_players(tv_flight_spire_01_door) or volume_test_players(tv_flight_spire_02_door) or volume_test_players(tv_flight_spire_03_door);
end