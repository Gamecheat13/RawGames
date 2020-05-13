//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_01
// =================================================================================================
// =================================================================================================

//VARIABLES
global boolean b_sp01_deactivated 							   = FALSE;
global boolean b_sp01_tower_1_spawn_exit 					 = FALSE;
global boolean b_sp01_tower_2_spawn_exit 					 = FALSE;
global boolean b_final_gondola_ride								 = FALSE;
global boolean DEF_SPIRE_01_SPAWN_STEALTH   			 = FALSE;
global boolean sp01_gondola_moving 								 = FALSE;
global boolean B_GONDOLA_ACTIVE 									 = FALSE;
global boolean b_blip_gondola_start 							 = FALSE;
global long L_sp01_int_door_03_thread = 0;
global long L_door_function_thread = 0;

// functions
// === f_spire_01_INT_init::: Initialize
script dormant f_spire_01_init()

	// setup cleanup watch
	wake( f_spire_01_deinit );
	
	sleep_until( f_spire_01_Zone_Active() and not f_spire_state_complete(DEF_SPIRE_01) and f_spire_state_active(DEF_SPIRE_01), 1 );
	dprint( "::: f_spire_01_INT_init :::" );

	// initialize modules
	wake( f_spire_01_AI_init );
	wake( f_spire_01_audio_init );
	wake( f_spire_01_fx_init );


	// initialize sub modules
	wake( f_spire_01_main );

end


// === f_spire_01_INT_Cleanup::: Cleanup area
script dormant f_spire_01_deinit()
	sleep_until( f_spire_state_complete(DEF_SPIRE_01) and (not f_spire_01_INT_Zone_Active()), 1 );
	dprint( "::: f_spire_01_INT_Cleanup :::" );
	
	// deinitialize scripts
		// kill functions
	sleep_forever( f_spire_01_init );

	// deinitialize modules
	wake( f_spire_01_AI_deinit );
	wake( f_spire_01_audio_deinit );
	wake( f_spire_01_fx_deinit );

	// deinitialize sub modules
	sleep_forever( f_spire_01_main );
	
end

// === f_spire_01_INT_Zone_Active::: Checks if the current zone set is for this area
script static boolean f_spire_01_INT_Zone_Active()
	( current_zone_set_fully_active() >= DEF_S_ZONESET_SPIRE_01_INT_A ) and ( current_zone_set_fully_active() <= DEF_S_ZONESET_SPIRE_01_INT_B );
end

script static boolean f_spire_01_Zone_Active()
	(current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_01_EXT) or  f_spire_01_INT_Zone_Active();
end



//======================================================
// SPIRE 01 INT MAIN
//======================================================
script dormant f_spire_01_main()

	dprint("f_spire_01_INT_main");
	//thread(f_spire_01_door_enter());
	//wake(f_spire_01_int_doors);
	//wake(f_dm_spire_01_int_door_02);
	thread(f_sp01_door_enter());
	
	sleep_until(f_spire_01_INT_Zone_Active(), 1);
	data_mine_set_mission_segment ("m70_spire_01"); 
	player_set_profile( profile_coop_respawn );
	if f_check_first_spire(DEF_SPIRE_02) then 
		s_flight_state = S_DEF_FLIGHT_STATE_SECOND_COMPLETE();
		game_insertion_point_unlock(4);
	else
		s_flight_state = S_DEF_FLIGHT_STATE_START_COMPLETE();
		game_insertion_point_unlock(3);
	end
		
	wake(f_spire_01_setup);
	garbage_collect_now();

	sleep_until(volume_test_players(tv_spire01_int_enter), 1);
	
	device_set_power(dc_spire01_gondola_switch, 0);
	//xxx beam_effects
	thread(f_sp01_beam_effects_init());
	dprint("SPIRE_01_GONDOLA_RIDE_01");
	
	object_create (sc_sp01_bridge_00);
	
	
	sleep_until( 	b_blip_gondola_start, 1 );
	
	
	f_blip_flag( flg_sp01_gondola_switch_01,"activate");

	//objectives_show_up_to(1);
/*
	if f_check_first_spire(DEF_SPIRE_01) then
			objectives_show_up_to(2);
	elseif f_check_first_spire(DEF_SPIRE_02) then
			objectives_show_up_to(3);
	end
	*/
	
	f_gondola_button();
	
	f_unblip_flag( flg_sp01_gondola_switch_01 );
	
	local long show_button_gondola_01 = pup_play_show("pup_sp01_gondola_switch_01");
	sleep_until (not pup_is_playing(show_button_gondola_01) , 1);

	sleep_s(1.25);
	
	game_save_no_timeout();
	
	thread(f_sp01_gondola_player_effects());
	
	wake(f_nar_spire_01_gondola_first_stop);
	
	// GONDOLA RIDE 1
	thread(f_audio_gondola_moving_start()); // gondola audio
	local long show_gondola_ride_01 = pup_play_show("pup_sp01_gondola_ride_01");
	thread(stop_gondala_ride_1_helper(show_gondola_ride_01));
	sleep_until (not pup_is_playing(show_gondola_ride_01) or volume_test_players(tv_tower_01_area), 1);
		
	game_save_no_timeout();
	sleep_s(1);

	sleep_until(b_gondola_waypoint_1, 1);
	
	sleep_s(1.25);
	
	f_blip_flag( flg_sp01_tw01_switch,"activate");
	
	f_sp01_tower_01_button();
	
	f_unblip_flag( flg_sp01_tw01_switch );
	
	
	local long show_tower_01 = pup_play_show("pup_sp01_tw01_switch");
	sleep_until (not pup_is_playing(show_tower_01) , 1);
	
	game_save_no_timeout();
	sleep_s(2);
	
	b_sp01_tower_1_spawn_exit = TRUE;
	
	sleep_s (2);
	
	// GONDOLA RIDE 2
	thread(f_audio_gondola_moving_start()); // gondola audio
	local long show_gondola_ride_02 = pup_play_show("pup_sp01_gondola_ride_02");
	sleep_until (not pup_is_playing(show_gondola_ride_02) , 1);
	thread(f_audio_gondola_moving_stop()); // gondola audio
	
	game_save_no_timeout();
	sleep_s(0.25);
	
	local long show_button_reset_01 = pup_play_show("pup_sp01_gondola_switch_reset");
	sleep_until (not pup_is_playing(show_button_reset_01) , 1);
	sleep_s (0.25);
	game_save_no_timeout();
	
	// :: SPIRE_01_GONDOLA_RIDE_02
	dprint("SPIRE_01_GONDOLA_RIDE_02");
	//xxx
	wake(f_sp01_gondola_squad_nudge);
	sleep_s(3);
	sleep_until(ai_living_count(sq_tw1_exit_knight) == 0, 1);
	f_unblip_flag(flg_sp01_gondola_secure);
	sleep_s(1);
	
	tower_01_start_gondola_back_up = TRUE;
	f_blip_flag( flg_sp01_gondola_switch_02,"activate");
	f_gondola_button();
	f_unblip_flag( flg_sp01_gondola_switch_02 );
	
	local long show_button_gondola_02 = pup_play_show("pup_sp01_gondola_switch_02");
	sleep_until (not pup_is_playing(show_button_gondola_02), 1);
	
	sleep_s(0.25);
	game_save_no_timeout();
	sleep_s (2);
	
	wake(f_nar_spire_gondola_ride_02);
	
	// GONDOLA RIDE 3
	thread(f_sp01_gondola_player_effects());
	thread(f_audio_gondola_moving_start()); // gondola audio
	
	wake(f_sp01_main_objective_beam);
	//xxxx fx_distortion
	dprint("DISABLE EFFECT DISTORTIONS");
	effects_distortion_enabled = FALSE;

	local long show_gondola_ride_03 = pup_play_show("pup_sp01_gondola_ride_03");
	sleep_until (not pup_is_playing(show_gondola_ride_03) , 1);
	thread(f_audio_gondola_moving_stop()); // gondola audio
	
	game_save_no_timeout();
	sleep_s (3);
	
	
	////xxxx
	//set two global varables switch true, generator true
	//set two conditionals button press switch pop
	//sleep until one condition is commited to, then do that.
	/// branch scripts here
	//wake conditions, thread button
	// :: SPIRE_01_TOWER_02_SWITCH
	dprint("SPIRE_01_TOWER_02_SWITCH");

	
	//f_sp01_tower_02_button();
	thread(f_sp01_tower_02_button());
	//wake(f_sp01_main_objective_beam);
	sleep_until(device_get_position(dc_spire01_tower_02) != 0 or b_sp01_deactivated, 1);
	
	if b_sp01_deactivated then 
		f_spire_02_end_path_generator_first();
	else
		f_spire_02_end_path_button_first();
	end
	b_final_gondola_ride = TRUE;
	game_save_no_timeout();
	sleep_s(0.5);
	
	// GONDOLA RIDE 5
	thread(f_sp01_gondola_player_effects());
	thread(f_audio_gondola_moving_start()); // gondola audio
	local long show_gondola_ride_05 = pup_play_show("pup_sp01_gondola_ride_05");
	sleep_until (not pup_is_playing(show_gondola_ride_05) or volume_test_players(tv_spire01_int_enter), 1);
	thread(f_audio_gondola_moving_stop()); // gondola audio
	sleep_s(1);
	
	game_save_no_timeout();
	
	f_blip_flag( flg_sp01_end, "recon" );
	
	thread(f_sp01_door_exit());
	
	sleep_until(volume_test_players(tv_spire01_int_enter) or volume_test_players(tv_sp01_int_to_ext), 1);
	
	f_unblip_flag(flg_sp01_end);
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE());
	game_save();
	
	//xxxx fx_distortion
	dprint("ENABLE EFFECT DISTORTIONS");
	effects_distortion_enabled = TRUE;
	
	sleep_until(volume_test_players(tv_sp01_int_to_ext), 1);

end

script static void stop_gondala_ride_1_helper(long gondola_show_index)
	sleep_until (not pup_is_playing(gondola_show_index), 1);

	thread(f_audio_gondola_moving_stop()); // gondola audio
end

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//SPLIT SCRIPTS
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
script static void f_spire_02_end_path_button_first()
	f_unblip_flag( flg_sp01_tw02_switch );
	
	b_sp01_tower_2_spawn_exit = TRUE;
	
	local long show_tower_02 = pup_play_show("pup_sp01_tw02_switch");
	sleep_until (not pup_is_playing(show_tower_02), 1);
	
	game_save_no_timeout();
	
	sleep_s (1);

	// GONDOLA RIDE 4
	thread(f_sp01_gondola_player_effects());
	thread(f_audio_gondola_moving_start()); // gondola audio
	
	local long show_gondola_ride_04 = pup_play_show("pup_sp01_gondola_ride_04");
	sleep_until (not pup_is_playing(show_gondola_ride_04) , 1);
	thread(f_audio_gondola_moving_stop()); // gondola audio
	
	local long show_button_reset_02 = pup_play_show("pup_sp01_gondola_switch_reset");
	sleep_until (not pup_is_playing(show_button_reset_02) , 1);
	
	game_save_no_timeout();
	
	sleep_s(0.75);
	
	// :: SPIRE_01_SHEILD_LOCK
	dprint("SPIRE_01_SHEILD_LOCK");
	
	wake(f_nar_spire_gondola_carrier_wave_generator);
	//wake(f_sp01_main_objective_beam);
	
	sleep_until(b_sp01_deactivated, 1);
	thread(f_sp01_int_levers());
	thread(f_sp01_beams_effects_disable());
	
	game_save_no_timeout();
	
	f_unblip_flag(flg_sp01_shield_lock);
	
	// :: SPIRE_01_GONDOLA_END
	dprint("SPIRE_01_GONDOLA_END");
	sleep_until(b_sp01_bishop_attack, 1);
	sleep_s(5);
	f_blip_flag( flg_sp01_gondola_switch_03,"activate");
	f_gondola_button();
	f_unblip_flag( flg_sp01_gondola_switch_03 );
	
	local long show_button_gondola_03 = pup_play_show("pup_sp01_gondola_switch_03");
	sleep_until (not pup_is_playing(show_button_gondola_03) , 1);
end

//===============================================================================
//===============================================================================
script static void f_spire_02_end_path_generator_first()
	dprint("f_spire_02_end_path_generator_first");
	wake(f_nar_spire_gondola_carrier_wave_generator);
	
	sleep_until(device_get_position(dc_spire01_tower_02) != 0, 1);	
	f_unblip_flag( flg_sp01_tw02_switch );
	
	b_sp01_tower_2_spawn_exit = TRUE;
	
	local long show_tower_02 = pup_play_show("pup_sp01_tw02_switch");
	sleep_until (not pup_is_playing(show_tower_02), 1);
	
	game_save_no_timeout();
	
	sleep_s (1);

	// GONDOLA RIDE 4
	thread(f_sp01_gondola_player_effects());
	thread(f_audio_gondola_moving_start()); // gondola audio
	local long show_gondola_ride_04 = pup_play_show("pup_sp01_gondola_ride_04");
	sleep_until (not pup_is_playing(show_gondola_ride_04) , 1);
	thread(f_audio_gondola_moving_stop()); // gondola audio
	
	local long show_button_reset_02 = pup_play_show("pup_sp01_gondola_switch_reset");
	sleep_until (not pup_is_playing(show_button_reset_02) , 1);
	
	game_save_no_timeout();
	
	sleep_s(0.75);
		
	sleep_until(b_sp01_deactivated, 1);
	
	thread(f_sp01_int_levers());
	
	game_save_no_timeout();
	
	sleep_s(1);
	
	f_blip_flag( flg_sp01_gondola_switch_03,"activate");
	f_gondola_button();
	f_unblip_flag( flg_sp01_gondola_switch_03 );
	
	local long show_button_gondola_03 = pup_play_show("pup_sp01_gondola_switch_03");
	sleep_until (not pup_is_playing(show_button_gondola_03) , 1);
end
	
	
	//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
script dormant f_spire_01_setup()
	f_spire_01_tower_01_device_machines();
	f_spire_01_tower_02_device_machines();
	wake(f_spire_01_gondola_weapon_racks);
end

script dormant f_spire_01_gondola_weapon_racks()
	dprint("f_spire_01_gondola_weapon_racks");
	objects_physically_attach(dm_sp01_gondola, "m_crate_01", cr_sp01_wr_gondola_01, "" );
	objects_physically_attach(dm_sp01_gondola, "m_crate_02", cr_sp01_wr_gondola_02, "" );
	objects_physically_attach(dm_sp01_gondola, "m_crate_03", cr_sp01_wr_gondola_03, "" );
	objects_physically_attach(dm_sp01_gondola, "m_crate_04", cr_sp01_wr_gondola_04, "" );
	objects_physically_attach(dm_sp01_gondola, "m_crate_05", cr_sp01_wr_gondola_05, "" );
	objects_physically_attach(dm_sp01_gondola, "m_crate_06", cr_sp01_wr_gondola_06, "" );
end

script static void f_spire_01_tower_01_device_machines()
	thread(dm_sp01_tw1_bridge->f_activate( 1, 8, 4, 2.25));
	thread(dm_sp01_tw1_shield_right->f_activate( 1, 8, 4, 2.25));
	thread(dm_sp01_tw1_shield_left->f_activate( 1, 8, 4, 2.25));

end

script static void f_spire_01_tower_02_device_machines()
	thread(dm_sp01_tw2_bridge->f_activate( 1, 8, 4, 2.25));
	thread(dm_sp01_tw2_shield_right->f_activate( 1, 8, 4, 2.25));
	thread(dm_sp01_tw2_shield_left->f_activate( 1, 8, 4, 2.25));

end


script dormant f_sp01_gondola_squad_nudge()
	if not volume_test_players(tv_spire01_gondola) then
		f_blip_flag(flg_sp01_gondola_secure,  "recon");
		sleep_until(volume_test_players(tv_spire01_gondola), 1);
		f_unblip_flag(flg_sp01_gondola_secure);
	end
	sleep_s(25);
	if ai_living_count(sq_tw1_exit_knight) > 0 then
		thread(f_blip_ai_until_dead(sq_tw1_exit_knight));
		//thread(f_blip_ai_until_dead(sq_tw1_exit_pawn_01));
		//thread(f_blip_ai_until_dead(sq_tw1_exit_pawn_02));
	end
end
//==========================================================
//SPIRE 01 GONDOLA
//==========================================================

script static void f_gondola_button()
	device_set_power(dc_spire01_gondola_switch, 1);
	device_set_position_immediate(dc_spire01_gondola_switch, 0);
	sleep_until(device_get_position(dc_spire01_gondola_switch) != 0, 1);
	device_set_position_immediate(dc_spire01_gondola_switch, 0);
	device_set_power(dc_spire01_gondola_switch, 0);
end

script static void f_sp01_tower_01_button()
	device_set_power(dc_spire01_tower_01, 1);
	sleep_until(device_get_position(dc_spire01_tower_01) != 0, 1);
	device_set_power(dc_spire01_tower_01, 0);
end

script static void f_sp01_tower_02_button()
	device_set_power(dc_spire01_tower_02, 1);
	sleep_until(device_get_position(dc_spire01_tower_02) != 0, 1);
	device_set_power(dc_spire01_tower_02, 0);
end

//tv_tower_01_area
//tv_tower_02_area

//STUPID_CATCHER
script static void f_sp01_gondola_return_01()
	repeat
		if not volume_test_players(tv_tower_01_area) then
			dprint("DUM DUM JUMPED OFF BRING GONDOLA BACK");
			device_set_position_track(dm_sp01_gondola, "any:idle", 0.35);
			dprint("set animation");
			device_animate_position(dm_sp01_gondola, 0.35, 0, 0.1, 0.1, TRUE );
			dprint("set position");
			sleep(5);
			device_animate_position(dm_sp01_gondola, 0.02, 15, 0.1, 0.1, TRUE );
			dprint("animate back");
			sleep_until(device_get_position(dm_sp01_gondola) == 0.02 and volume_test_players(tv_spire01_gondola), 1);
			dprint("back and player on");
			sleep_s(1);
			device_animate_position(dm_sp01_gondola, 0.35, 25, 0.1, 0.1, TRUE );
			dprint("go forwadr");
			sleep_until(device_get_position(dm_sp01_gondola) == 0.35, 1);	
			dprint("done");
		end
	until(volume_test_players(tv_tower_01_area), 1);
end
//234 == 0.4875
//401 == 0.83541667

//==========================================================
//SPIRE 01 DOORS
//==========================================================

//INT DOORS
script static void f_sp01_door_enter()
	dprint("f_sp01_door_enter");
	sleep_until(volume_test_players(tv_sp01_hallway_teleport), 1);
	
	sleep(1);
	
	sleep_until(not volume_test_players(tv_dm_sp01_int_door_01), 1);
	
	device_set_power(dm_sp01_int_door_01, 0);
	
	sleep_until(device_get_position(dm_sp01_int_door_01) == 0, 1);
	
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp01_hallway_check, flg_sp01_hallway_teleport);
		sleep(15);
	end
	
	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_01_INT_A );


	device_set_power(dm_sp01_int_door_03, 1);
	
	game_save();	
	
	sleep_until(volume_test_players(tv_spire01_gondola), 1);
	
	sleep_until(1);
	
	sleep_until(not volume_test_players(tv_dm_sp01_int_door_03), 1);
	
	device_set_power(dm_sp01_int_door_03, 0);
	
	sleep_until(device_get_position(dm_sp01_int_door_03) == 0, 1);
				
	volume_teleport_players_inside(tv_sp01_hallway_check, flg_teleport_start);

end

//flip dis function.
script static void f_sp01_door_exit()

	device_set_power(dm_sp01_int_door_03, 1);
	
	sleep_until(volume_test_players(tv_sp01_hallway_teleport), 1);
	
	sleep(1);
	
	sleep_until(not volume_test_players(tv_dm_sp01_int_door_03), 1);
	
	device_set_power(dm_sp01_int_door_03, 0);
	
	sleep_until(device_get_position(dm_sp01_int_door_03) == 0, 1);
	
	if game_is_cooperative() then
		volume_teleport_players_not_inside(tv_sp01_hallway_check, flg_spire01_exit_teleport);
		sleep_s(1);
	end

	zoneset_prepare_and_load( DEF_S_ZONESET_SPIRE_01_EXT );
	
	
	device_set_power(dm_sp01_int_door_01, 1);
	
	game_save();
	
	thread(f_spire01_exit());
		
	sleep_until(vehicle_test_players(), 1);
	
	sleep(1);
	
	sleep_until(not volume_test_players(tv_dm_sp01_int_door_01), 1);
	
	device_set_power(dm_sp01_int_door_01, 0);
	
	sleep_until(device_get_position(dm_sp01_int_door_01) == 0, 1);
		
	volume_teleport_players_inside(tv_sp01_hallway_check, flg_spire01_exterior_teleport);
	
end

//==========================================================
//SPIRE 01 POWER SOURCE
//==========================================================

//STUN SHIELD
script dormant f_sp01_main_objective_beam()
	dprint("f_sp01_main_objective_beam");
	thread(f_sp01_shield_emp_disable( player0));
	thread(f_sp01_shield_emp_disable( player1));
	thread(f_sp01_shield_emp_disable( player2));
	thread(f_sp01_shield_emp_disable( player3));
end

script static void f_sp01_shield_emp_disable(player player_num)
	local real r_player_shield_current = object_get_shield(player_num);
	repeat 
	sleep_until(volume_test_object(tv_spire01_final_shieldbreak, player_num), 1);
	screen_effect_new( environments\solo\m70_liftoff\fx\energy\parts\spire_beam_walkin_screen.area_screen_effect, fx_08_spirebeam_big);
	thread(f_camera_shake_emp_hit(player_num));
	sleep_s(0.5);
	
	if volume_test_object(tv_spire01_final_shieldbreak, player_num) then

		thread(f_camera_shake_emp_hit(player_num));
		sleep_s(1);
		
		if volume_test_object(tv_spire01_final_shieldbreak, player_num) then
				if not b_sp01_deactivated then
					b_sp01_deactivated = TRUE;
					//xxx
					//disable beam effect for player
					effect_new( environments\solo\m70_liftoff\fx\energy\spire_beam_walkin_burst.effect, fx_08_spirebeam_big); 
					effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_walkin.effect, fx_08_spirebeam_big);
					thread(f_sp01_beams_effects_disable());
					
					thread(f_sp01_emp_shield_pop());
				end
		end
		screen_effect_delete ( environments\solo\m70_liftoff\fx\energy\parts\spire_beam_walkin_screen.area_screen_effect, fx_08_spirebeam_big);
	end
	until(b_sp01_deactivated, 1);
end

script static void f_sp01_emp_shield_pop()
	f_stun_player_shield( player0, 7);
	f_stun_player_shield( player1, 7);
	f_stun_player_shield( player2, 7);
	f_stun_player_shield( player3, 7);
end

script static void f_stun_player_shield( player player_number, real stun_time)
	object_set_shield(unit(player_number), 0.0);
	object_set_shield_stun(unit(player_number), stun_time);
	thread(f_camera_shake_emp_pop(player_number));
end

script static void f_sp01_destroy_beam(object_name beam)
	if object_valid(beam) then
		object_destroy(beam);
	end
end

	// SPIRE_01_EXIT
script static void f_spire01_exit()
	dprint("f_spire01_exit");
	sleep_until((current_zone_set_fully_active() == DEF_S_ZONESET_SPIRE_01_EXT), 1);
	game_save_no_timeout();
	
	if f_check_first_spire(DEF_SPIRE_01) then 
		s_flight_state = S_DEF_FLIGHT_STATE_SECOND();
	else
		s_flight_state = S_DEF_FLIGHT_STATE_THIRD();
	end
	sleep(15);
	
	f_spires_exit_clear_pelican();
	object_create(flight_pelican_sp01);
	thread(f_pelican_disable_extra_seats( flight_pelican_sp01, flight_pelican_sp01));
	sleep(5);
	thread(f_spire_exit_respawn_pelican( flight_pelican_sp01, flight_pelican_sp01, tv_sp01_pelican));
	sleep_s(4);
	thread(f_sp01_blip_pelican());
end

script static void f_sp01_gondola_player_effects()
dprint("camera_shake");
	sleep_until(sp01_gondola_moving, 1);
	
	//thread(f_rumble_gondola(player0));
//	thread(f_rumble_gondola(player1));
	//thread(f_rumble_gondola(player2));
	//thread(f_rumble_gondola(player3));
	
	repeat
	
		if volume_test_object(tv_gondola_path, player0) then
			thread(f_camera_shake_gondola(player0));
			player_effect_set_max_rumble_for_player(player0(), 0.1, 0.1);
		else
			player_effect_set_max_rumble_for_player(player0(), 0, 0);
		end
		
		if volume_test_object(tv_gondola_path, player1) then
			thread(f_camera_shake_gondola(player1));
			player_effect_set_max_rumble_for_player(player1(), 0.1, 0.1);
		else
			player_effect_set_max_rumble_for_player(player1(), 0, 0);
		end
		
		if volume_test_object(tv_gondola_path, player2) then
			thread(f_camera_shake_gondola(player2));
			player_effect_set_max_rumble_for_player(player2(), 0.1, 0.1);
		else
			player_effect_set_max_rumble_for_player(player2(), 0, 0);
		end
		
		if volume_test_object(tv_gondola_path, player3) then
			thread(f_camera_shake_gondola(player3));
			player_effect_set_max_rumble_for_player(player3(), 0.1, 0.1);
		else
			player_effect_set_max_rumble_for_player(player3(), 0, 0);
		end
		sleep(10);
	
	until(not sp01_gondola_moving, 1);
	player_effect_set_max_rumble_for_player(player0(), 0, 0);
	player_effect_set_max_rumble_for_player(player1(), 0, 0);
	player_effect_set_max_rumble_for_player(player2(), 0, 0);
	player_effect_set_max_rumble_for_player(player3(), 0, 0);
end

//Gondola
//xxx teleport
script static void f_sp01_start_left_behind()
	if not volume_test_players_all(tv_tower_01_area) then
		volume_teleport_players_not_inside(tv_tower_01_area, flg_teleport_tower_01 );
	end
end

script static void f_sp01_tower_01_left_behind()
	if not volume_test_players_all(tv_gondola_path) then
		volume_teleport_players_inside(tv_tower_01_area, flg_teleport_mid );
	end
end

script static void f_sp01_end_left_behind()
	if not volume_test_players_all(tv_gondola_path) then
		volume_teleport_players_inside(tv_tower_02_area, flg_teleport_end);
	end

end
//xxx
script static void f_sp01_end_left_behind_01()
	if not volume_test_players_all(tv_gondola_path) then
		volume_teleport_players_inside(tv_tower_01_area, flg_teleport_start);
		volume_teleport_players_inside(tv_tower_02_area, flg_teleport_start);
	end
	
end

script static void f_sp01_beam_effects_init()
	dprint("f_sp01_beam_effects_init");
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_1);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_2);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_3);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_4);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_5);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_6);
	//big beam
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_walkin.effect, fx_08_spirebeam_big);
	effect_new(environments\solo\m70_liftoff\fx\energy\spire_beam_walkin_top.effect, fx_08_spirebeam_bigtop);

end

script static void f_sp01_beams_effects_disable()
	dprint("f_sp01_beams_effects_disable");
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_walkin_top.effect, fx_08_spirebeam_bigtop);
	sleep_s(2);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_6);
	sleep_s(1.5);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_5);
	sleep_s(1.25);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_4);
	sleep_s(1);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_3);
	sleep_s(0.5);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_2);
	sleep_s(0.25);
	effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\spire_beam_cryptum.effect, fx_08_spirebeam_1);

end

//XXX
global real r_lever_crouch = 0;

script static void f_sp01_int_levers()
	dprint("f_sp01_int_levers");
	if game_difficulty_get() >= "legendary" then
		thread(f_sp01_int_levers_test(player0));
		thread(	f_sp01_int_levers_test(player1));
		thread(f_sp01_int_levers_test(player2));
		thread(f_sp01_int_levers_test(player3));
		sleep_until(r_lever_crouch == 343 or volume_test_players(tv_spire01_int_enter), 1);
		sleep_s(0.25);
		if r_lever_crouch == 343 then
			dprint("you win funtime");
			object_create(ee_gh_01);
			object_create(ee_gh_02);
			object_create(ee_gh_03);
			object_create(ee_gh_04);
		end
	end
end


script static void f_sp01_int_levers_test(player p_player)
	repeat
		sleep_s(0.25);
		unit_action_test_reset(p_player);
		sleep_until(unit_action_test_cancel (p_player), 1);
		if volume_test_players(tv_spire01_final_shieldbreak) then
		r_lever_crouch = r_lever_crouch + 1;
		end
	until(r_lever_crouch == 343 or volume_test_players(tv_spire01_int_enter), 1);
end

/*
script static void f_sp01_null_blips()
	ai_place(sq_blip_null);
	sleep_s(1.25);
	ai_place(sq_blip_null);

end
*/

script command_script f_sp01_cs_null_blips()
	sleep(random_range(25, 30));
	ai_erase(ai_current_actor);
end


script static void f_sp01_checkpoint_combat(ai ai_group)
	local real save_on_squad_kill  = (ai_living_count(ai_group) * 0.65);
	sleep_until(ai_living_count(ai_group) <= save_on_squad_kill, 1);
	checkpoint_no_timeout( TRUE, "SPIRE 1 TOWER COMBAT CHECKPOINT" );
end

