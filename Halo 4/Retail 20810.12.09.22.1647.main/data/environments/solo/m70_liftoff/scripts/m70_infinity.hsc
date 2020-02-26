//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// infinity
// =================================================================================================
// =================================================================================================
// variables
global long pup_pelican_no_fx = 0;
// functions
// === f_infinity_startup::: Auto startup
script startup f_infinity_startup()
	sleep_until( b_mission_started == TRUE, 1 );
	
	// wake init
	wake( f_infinity_init );
	
	
end

// === f_infinity_init::: Initialize
script dormant f_infinity_init()

	// setup cleanup watch
	wake( f_infinity_cleanup );
	
	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY, 1 );
	dprint( "::: f_infinity_init :::" );
	if not b_flight_insertion then 
	// initialize modules
	wake( f_infinity_AI_init );
	wake( f_infinity_narrative_init );
	wake( f_infinity_audio_init );
	wake( f_infinity_FX_init );

	// initialize sub modules
	wake( f_infinity_main );
	//wake( f_infinity_pelican_init );
	end
end

// === f_infinity_deinit::: Deinitialize
script dormant f_infinity_deinit()
	dprint( "::: f_infinity_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_init );
	// deinitialize modules
	wake( f_infinity_AI_deinit );
	wake( f_infinity_narrative_deinit );
	wake( f_infinity_audio_deinit );
	wake( f_infinity_FX_deinit );

	// deinitialize sub modules
//	wake( f_infinity_start_deinit );
	//wake( f_infinity_pelican_deinit );

end

// === f_infinity_cleanup::: Cleanup area
script dormant f_infinity_cleanup()
	sleep_until( current_zone_set_fully_active() > DEF_S_ZONESET_INFINITY, 1 );
	dprint( "::: f_infinity_cleanup :::" );

	// Cleanup
	wake( f_infinity_deinit );
	
end



// -------------------------------------------------------------------------------------------------
// infinity: start
// -------------------------------------------------------------------------------------------------
// === f_infinity_init::: Initialize
script dormant f_infinity_main()
	dprint( "f_infinity_start_init" );
	//thread(f_infinity_weapon_down_state());
	  
	dprint( "f_infinity_trigger" );
//	wake( f_infinity_start_action );
	b_pelican_open = FALSE;
	sleep(5);
	device_set_position_track(dm_inf_launchpad, "device:position", 0);
	object_create(inf_pelican_gunship);
	vehicle_set_player_interaction(inf_pelican_gunship, "" , FALSE, FALSE);
	object_cannot_take_damage(inf_pelican_gunship);
	game_save();
	
	//wake( f_inf_pelican_start );
	dprint("f_inf_pelican_start");
	wake(f_inf_blip_armory);
	sleep_until( dialog_id_played_check(L_dlg_infinity_start), 1 );
	thread(f_m70_objective_set(ct_obj_main));
	//pm_obj
	//objectives_show_up_to(0);
	sleep_s(1);
	f_blip_flag(flg_pelican_blip, "default");
	wake(f_pelican_open_infinity);
	
	thread(f_pelican_disable_extra_seats(inf_pelican_gunship, inf_pelican_gunship));

	
	wake(f_inf_pelican_disable_pilot);


	sleep_until(vehicle_test_players_all() and vehicle_test_seat (inf_pelican_gunship, "pelican_d"), 1);
	f_unblip_flag(flg_pelican_blip);
	wake(f_infinity_narrative_pelican_02);
	sleep_s(3);
	f_objective_set( DEF_R_OBJECTIVE_NONE, FALSE, FALSE, FALSE, TRUE );
	sleep_s(2);
	wake(f_infinity_pelican_launch_lower);
end

script dormant f_inf_pelican_disable_pilot()
	dprint("f_inf_pelican_disable_pilot");
	sleep_until(vehicle_test_seat (inf_pelican_gunship, "pelican_d"), 1);
	pup_pelican_no_fx = pup_play_show(pup_pelican_lower_idle);
		
	player_enable_input(false);
	objects_attach (dm_inf_launchpad, "m_attach", inf_pelican_gunship, "");
	hud_show_crosshair(FALSE);
	hud_show_radar (FALSE);
	hud_show_shield (FALSE);
	hud_show_weapon (FALSE);
	game_safe_to_respawn(FALSE);
	teleport_players_into_vehicle(inf_pelican_gunship);
	device_set_position_track(dm_inf_launchpad, "device:position", 0);
	objects_attach (dm_inf_launchpad, "m_attach", inf_pelican_gunship, "");
	objects_detach (dm_inf_launchpad, inf_pelican_gunship);
end


script dormant f_pelican_open_infinity()
	sleep_until(volume_test_players(tv_open_pelican) and volume_test_players_all_lookat(tv_inf_pelican, 10, 10), 1);
	unit_open(inf_pelican_gunship);
	sleep_until(vehicle_test_seat (inf_pelican_gunship, "pelican_d"), 1);
	unit_close(inf_pelican_gunship);
end

// -------------------------------------------------------------------------------------------------
// infinity: pelican
// -------------------------------------------------------------------------------------------------
script static void f_inf_lower_launchpad()
dprint("f_inf_lower_launchpad");

sleep_s(1);


dprint("test complete");
end

// === f_infinity_pelican_action::: Pelican trigger action
script dormant f_infinity_pelican_launch_lower()
	dprint("f_infinity_pelican_launch_lower");
	//xxx for insertion
	if not object_valid(inf_pelican_gunship) then
		object_create(inf_pelican_gunship);
	end
	sleep(5);
	if not vehicle_test_players_all() then
		teleport_players_into_vehicle(inf_pelican_gunship);
		game_safe_to_respawn(FALSE);
	end
	
	f_inf_pelican_lower();
	

	//local long show_inf_pelican_lower = pup_play_show(pup_inf_pelican_lower);
	
	//device_set_position_track(dm_inf_launchpad, "device:position", 0);
	//device_animate_position(dm_inf_launchpad, 1, 7, 0.1, 0.1, true);
	//sleep_until(not pup_is_playing(show_inf_pelican_lower), 1);
	sleep(5);
	object_can_take_damage(inf_pelican_gunship);


	s_flight_state = S_DEF_FLIGHT_STATE_START();

	thread(f_flight_state_start());
  
end



script static void f_inf_pelican_lower()

	if not pup_is_playing(pup_pelican_no_fx) then
		pup_pelican_no_fx = pup_play_show(pup_pelican_lower_idle);
	end
	sleep_s(1);
	sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_inf_lift', dm_inf_launchpad, 1 ); //AUDIO!
	device_animate_position(dm_inf_launchpad, 1, 10, 0.1, 0.1, TRUE);
	sleep_s(6);
	fade_out(0, 0, 0, 60);
	sleep_s(2);
	
	pup_stop_show(pup_pelican_no_fx);
	sleep(5);
	objects_detach(dm_inf_launchpad, inf_pelican_gunship);
	sleep(5);
	player_control_lock_gaze(player0(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player1(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player2(), ps_pelican_launch.p_end, 500);
	player_control_lock_gaze(player3(), ps_pelican_launch.p_end, 500);
end


//XXX remove this and make it better


script static void f_infinity_weapon_down_state()
dprint("weapon down state");
/*
			players_weapon_down( -1, 1.0, TRUE );
			dprint("START down");
			repeat 
				dprint("START CHECK");
				player_action_test_reset();
				sleep(1);
				if player_action_test_context_primary() or player_action_test_grenade_trigger() or player_action_test_rotate_weapons()  or player_action_test_primary_trigger() or player_action_test_primary_trigger() then
					players_weapon_down( -1, 0.01, FALSE );
					sleep_s(3);
					dprint("weapon up");
				else
					players_weapon_down( -1, 1.0, TRUE );
					dprint("weapon down");
				end
			until(object_valid(pelican_switch_01) and (device_get_position(pelican_switch_01) > 0.0));
			dprint("check over player gun is always up");
			players_weapon_down( -1, 0.25, FALSE );
*/
end


script dormant f_inf_blip_armory()
	sleep_s(6);
	f_blip_flag( flg_inf_pelican_armory_1, "ammo");
	f_blip_flag( flg_inf_pelican_armory_2, "ammo");
	sleep_until(volume_test_players(tv_inf_pelican_armory_nudge) or vehicle_test_players(), 1);
	f_unblip_flag(flg_inf_pelican_armory_1);
	f_unblip_flag(flg_inf_pelican_armory_2);
end


//cs_push_stance( sq_inf_dock_worker.spawn_points_0, "panic");
//cs_push_stance( sq_inf_dock_worker, flee);
//ai_flee_target(sq_inf_dock_worker, player0());
//ai_flee_target (sq_inf_dock_worker, player0);
//script command_script()
//

//script command_script cs_panic()
//ai_flee_target (sq_inf_dock_worker, player0);
//cs_stow(TRUE);
//cs_push_stance( "panic" );

//end
//cs_push_stance(sq_inf_dock_worker, "flee" );
//script command_script cs_flee()
//cs_push_stance( "flee" );
//sleep_s(30);
//end