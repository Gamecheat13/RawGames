
// =================================================================================================
// =================================================================================================
// THE BEACON ENCOUNTER
// =================================================================================================
// =================================================================================================

global short s_objcon_beacon	= 0;
global boolean b_suck_beacon_ships = false;
global boolean b_beacon_played = false;
global long show_missile = 0;

//DEFINE BEACON OBJECTIVES



script dormant f_beacon_main()
	sleep_until (b_mission_started == TRUE);

	wake (f_beacon_airlock_entrance_control);
		
	sleep_until (current_zone_set_fully_active() == S_zoneset_28_airlock_30_beacons, 1);

	// set co-op profiles
	thread(f_loadout_set ("beacon"));
	
	ai_grenades(FALSE);
	
	// objective scripting
	wake(f_beacon_objectives);
	
	object_create(close_cruiser2);
	zone_set_trigger_volume_enable ("begin_zone_set:32_broken_34_maintenance", FALSE);
	zone_set_trigger_volume_enable ("zone_set:32_broken_34_maintenance", FALSE);
	kill_volume_disable(kill_observatory);
	dprint  ("::: BEACON START :::");
	ai_erase(ai_all_hall_to_flank);
	object_create_folder_anew(dm_beacon);
	pup_play_show(beacon_ships); // needs to be after object_create_folder_anew because the ships are in the dm_beacon folder
	pup_play_show(debris_show);
	sleep(5);
	//object_create (ragdoll_phantom);
	physics_toggle_force_gravity_actions(true, .005);  // 0.001  
	object_create (missile_control_switch);
	object_create (beacon_ship);
	object_create (maw_door);
	object_create (grav_br);
	object_create (grav_cc);
	object_cinematic_visibility(beacon_ship,true);
	object_cinematic_visibility(m10_maw,true);
	object_cinematic_visibility(maw_door,true);
	object_cinematic_visibility(archer,true);
	
	object_create_folder_anew(beacon_cov_crates);
	wake(f_move_close_ship_beac);
	
	//DATA MINE
	data_mine_set_mission_segment ("m10_beacon");
	
	wake(f_beac_weapons);
	
	ai_grenades(FALSE);
	
	//MUSIC
	sleep_s(2);
	
	//dprint("::: staging complete:::");
	thread(f_music_beacon_deck_reached_first_airlock());
	//dprint(":::place ai:::");
	//game_save();
	//dprint(":::open door:::");
	//wake (f_crate_angular_velocity);
	object_set_velocity(grav_br, .09, 0, -.07);
	object_set_angular_velocity(grav_br, 1, 1, 1); 
	object_set_angular_velocity(grav_cc, 1, 1, 1);  
	wake(f_door_airlock_1_exterior_open);
	//thread(f_door_airlock_1_exterior_close());


	//ENCOUNTER START
	//sleep_until (volume_test_players (tv_beacon_start), 1);
	thread(f_mus_m10_e04_begin());
	//sleep_s(2);
	wake (f_objcon_beacon);
	//wake (f_weapon_crate_rise);
	
	//ai_place (sq_1_jackals);	
	//ai_place (sq_1_grunts);	
	ai_place (sg_2_jackals);
	ai_place (sq_1_jackals);	
	ai_place (sg_3_first_spawn);	
	ai_place (sq_phantom_2);	
	
	wake (f_missile_control_switch);
	
	
	//sleep_s(2);
	ai_place (sq_2_grunts_1);
	sleep(105);
	ai_place (sq_phantom_1);
	sleep(1);
	wake(f_beac_late_spawn);
	
	//sleep_until (volume_test_players (tv_sq_4), 1);
	//ai_place (sq_phantom_3);
	
	sleep_until (volume_test_players (tv_dialog_near_missile_room), 1);
	sleep_until(volume_test_players_lookat(tv_see_terminal_beacons, 30, 20), 1);
	//ai_place (sq_phantom_4);
	wake (f_dialog_near_missile_room);
	
end

// f_objective_set( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip )
script dormant f_beacon_objectives
	// blip the missile control
	sleep_until(LevelEventStatus("blip missile control"), 1);
	thread (f_objective_blip( DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS, TRUE, TRUE ));
	
	// complete it, and un-blip the missile control
	sleep_until(LevelEventStatus("unblip missile control"), 1);
	thread (f_objective_complete( DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS, TRUE, TRUE ));
	
	// show the mag push point
	sleep_until(LevelEventStatus("blip push point"), 1);
	thread (f_objective_set( DEF_R_OBJECTIVE_MANUAL_LAUNCH, TRUE, TRUE, FALSE, FALSE ));

	// pushed it, complete
	sleep_until(LevelEventStatus("unblip push point"), 1);
	thread (f_objective_complete( DEF_R_OBJECTIVE_MANUAL_LAUNCH, FALSE, TRUE ));
	
	// oh noes time to leave
	sleep_until(LevelEventStatus("blip exit to broken"), 1);
	thread (f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, TRUE, TRUE, FALSE, FALSE ));
	wake (f_airlock_exit_blip);
	
	// got to exit
	sleep_until(LevelEventStatus("unblip exit to broken"), 1);
	thread (f_objective_blip( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE ));
		
end

//script dormant f_weapon_crate_rise

	//sleep_until (volume_test_players (tv_weapon_rise), 1);
	



//end
script dormant f_move_close_ship_beac()
	object_move_to_point (beacon_ship, 500, ps_close_ship_beacons.p0);
end


script command_script cs_phantom_1()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	ai_set_blind ((sq_phantom_1.driver), TRUE);
	ai_set_deaf ((sq_phantom_1.driver), TRUE);
		
	f_load_phantom( sq_phantom_1, "left", sq_1_grunts, sq_1_grunts_2, none, none );
	sleep_s(1);
	cs_fly_to( ps_phantom_1.p3 );
	cs_fly_to( ps_phantom_1.p2 );
	
	//sleep_until (volume_test_players (tv_phantom_1_drop), 1);
	//sleep( 30 * 4.0 );	

	f_unload_phantom( sq_phantom_1, "left" );
	print ("unload phantom_1");
	
	cs_fly_to( ps_phantom_1.p0 );
	cs_fly_to( ps_phantom_1.p1 );
	//object_erase( ai_vehicle_get( ai_current_actor ) );
	ai_erase (sq_phantom_1);
	
end

script command_script cs_phantom_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	//ai_set_blind ((sq_phantom_2.driver), TRUE);
	//ai_set_deaf ((sq_phantom_2.driver), TRUE);
		
	f_load_phantom( sq_phantom_2, "left", none, sq_2_elite_1, none, none );
	f_load_phantom( sq_phantom_2, "right", sq_2_grunts_2, sq_2_elite_2, none, none );
	
	//sleep_until (volume_test_players (tv_phantom_1_drop), 1);
	//sleep( 30 * 4.0 );	

	ai_set_blind ((sq_phantom_2.driver), FALSE);
	ai_set_deaf ((sq_phantom_2.driver), FALSE);

	f_unload_phantom( sq_phantom_2, "left" );
	f_unload_phantom( sq_phantom_2, "right" );
	print ("unload phantom_2");
	
	cs_fly_to( ps_phantom_2.p0 );
	cs_fly_to( ps_phantom_2.p1 );
	//object_erase( ai_vehicle_get( ai_current_actor ) );
	ai_erase (sq_phantom_2);
	
end

script command_script cs_phantom_3()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	//sleep( 30 * 2.0 );	
	cs_fly_to( ps_phantom_3.p0 );
	cs_fly_to( ps_phantom_3.p1 );
	
	f_load_phantom( sq_phantom_3, "right", none, none, sq_4_grunts_1, none );
	f_load_phantom( sq_phantom_3, "left", none, sq_4_elite_grunts , sq_4_grunts_2, sq_4_jackal_3 );

	f_unload_phantom( sq_phantom_3, "right" );
	f_unload_phantom( sq_phantom_3, "left" );


	print ("unload phantom_2");
	
	cs_fly_to( ps_phantom_3.p2 );
	cs_fly_to( ps_phantom_3.p3 );
	//object_erase( ai_vehicle_get( ai_current_actor ) );
	ai_erase (sq_phantom_3);
end

script command_script cs_phantom_4()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	
	//f_load_phantom( sq_phantom_4, "left", sq_4_elite_jackal, sq_4_jackal_3, none, none );
	f_load_phantom( sq_phantom_4, "dual", none, sq_4_elite_jackal, none, sq_4_jackal_1);
	
	cs_fly_to( ps_phantom_4.p0 );
	cs_fly_to( ps_phantom_4.p1 );
	
	//f_unload_phantom( sq_phantom_4, "left" );
	f_unload_phantom( sq_phantom_4, "dual" );
	print ("unload phantom_2");
	
	cs_fly_to( ps_phantom_4.p2 );
	cs_fly_to( ps_phantom_4.p3 );
	//object_erase( ai_vehicle_get( ai_current_actor ) );
		ai_erase (sq_phantom_4);	
end

script dormant f_objcon_beacon()

		sleep_until (volume_test_players (tv_objcon_beacon_10), 1);
		s_objcon_beacon = 10;
		print ("objcon_beacon = 10");
		
		sleep_until (volume_test_players (tv_objcon_beacon_20), 1);
		s_objcon_beacon = 20;
		print ("objcon_beacon = 20");
		
		sleep_until (volume_test_players (tv_objcon_beacon_30), 1);
		s_objcon_beacon = 30;
		print ("objcon_beacon = 30");
		
		sleep_until (volume_test_players (tv_objcon_beacon_40), 1);
		object_set_angular_velocity(grav_cc, 1, 1, 1);  
		s_objcon_beacon = 40;
		print ("objcon_beacon = 40");
		
end	

global boolean g_airlockEffectsBeforeSwitch = true;

script dormant f_beacon_airlock_entrance_control

	sleep_until(volume_test_players(tv_near_airlock1),1);

	door_airlock_1_interior->open_default();
	
	if game_is_cooperative() == TRUE then
	f_blip_flag(flg_beac_door_blip, "default");
	end
	sleep_until (volume_test_players_all (tv_airlock_inside), 1);
	f_unblip_flag(flg_beac_door_blip);
	wake (f_dialog_airlock_beacon);
	game_save_cancel();
	sleep(1);
	game_save_no_timeout();
	f_door_airlock_1_interior_close();
	
	//dprint("check for door to close 100%");
	sleep_until (door_airlock_1_interior->check_close(), 1);
	
	prepare_to_switch_to_zone_set( f_zoneset_get(S_zoneset_28_airlock_30_beacons) );
	sleep_until (not PreparingToSwitchZoneSet(), 1); // poll whether async load is complete
	f_insertion_zoneload( S_zoneset_28_airlock_30_beacons, TRUE );

	B_airlock_1_complete = TRUE;

end

// this is used

script dormant f_beacon_airlock_exit_control
	
	door_airlock_2_exterior->speed_set( door_airlock_2_exterior->speed_fast() );
	door_airlock_2_exterior->open();
	
	sleep_until (volume_test_players_all (tv_inside_airlock_02), 1);
	
	// BLIP - is called at the end of BEACON PUPPETEER
	//device_operates_automatically_set(door_airlock_2_exterior, FALSE );
	door_airlock_2_exterior->auto_trigger_close( tv_inside_airlock_02, TRUE, TRUE, TRUE );

	sleep_until(door_airlock_2_exterior->check_close(), 1);

	
	// don't continue until the door is closed otherwise we might see beacons getting unloaded
	//prepare_to_switch_to_zone_set( f_zoneset_get(S_zoneset_32_broken_34_maintenance) ); // start to load zone set
	zone_set_trigger_volume_enable ("begin_zone_set:32_broken_34_maintenance", TRUE);
	
	// Play airlock-filling-with-air effects
	f_unblip_flag(flg_blip_coop_exit_beacons);
	thread(f_mus_m10_e04_finish());
	sound_impulse_start( 'sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_airlock_low_to_high.sound', NONE, 1 );
	fx_airlock_compression();
	fx_airlock_compression2();
	f_zero_g_airlock_2_drop();
	physics_remove_all_gravity_actions();
	physics_toggle_force_gravity_actions(false, 0);
	sound_set_state( 'set_state_high_gravity' );
	

	game_save_cancel();
	sleep_until (not PreparingToSwitchZoneSet(), 1); // poll whether async load is complete		
	game_save_no_timeout();
	zone_set_trigger_volume_enable ("zone_set:32_broken_34_maintenance", TRUE);
	//f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE ); // do acually zone switch
	sleep_until( current_zone_set_fully_active() > (S_zoneset_28_airlock_30_beacons), 1 );
	f_unblip_flag(flg_blip_coop_exit_beacons);
	
	door_airlock_2_interior->open();

end

script dormant f_airlock_exit_blip

	sleep_until(volume_test_players(tv_airlock_exit),1);
	NotifyLevel("unblip exit to broken");
	if
		game_is_cooperative() == TRUE then
	  f_blip_flag(flg_blip_coop_exit_beacons, "default");
	  sleep_until(volume_test_players_all (tv_inside_airlock_02));
	  f_unblip_flag(flg_blip_coop_exit_beacons);
	 end
	
end

/*script dormant f_maw_grav_tv

		sleep_until (volume_test_players (tv_maw_grav_10), 1);
		s_maw_grav = 10;
		print ("maw_grav = 10");
		
		sleep_until (volume_test_players (tv_maw_grav_20), 1);
		s_maw_grav = 20;
		print ("maw_grav = 20");
		
end*/

///////////////////////////////////////////////////////
//BEACON AI
///////////////////////////////////////////////////////






script dormant f_beacon_airlock2_exit()
	f_door_airlock_2_exterior();
	sleep_until (volume_test_players_all (tv_inside_airlock_02), 1);
	f_door_airlock_2_exterior_close();
end


// BEACON WEAPON RACKS 
script dormant f_beac_weapons()
	wake (f_wr_beac_a_airlock);
	wake (f_wr_beac_b_airlock);
end

script dormant f_wr_beac_a_airlock()
	wr_beac_airlock_a_02->chain_parent_open( wr_beac_airlock_a_01, wr_beac_airlock_a_02->close_position(), wr_beac_airlock_a_02->S_chain_state_greater() );
	wr_beac_airlock_a_03->chain_parent_open( wr_beac_airlock_a_02, wr_beac_airlock_a_03->close_position(), wr_beac_airlock_a_03->S_chain_state_greater() );
	wr_beac_airlock_a_04->chain_parent_open( wr_beac_airlock_a_03, wr_beac_airlock_a_04->close_position(), wr_beac_airlock_a_04->S_chain_state_greater() );
	wr_beac_airlock_a_01->auto_distance_open( -4.0, FALSE );
	
end

script dormant f_wr_beac_b_airlock()
	wr_beac_airlock_b_02->chain_parent_open( wr_beac_airlock_b_01, wr_beac_airlock_b_01->close_position(), wr_beac_airlock_b_02->S_chain_state_greater() );
	wr_beac_airlock_b_03->chain_parent_open( wr_beac_airlock_b_02, wr_beac_airlock_b_02->close_position(), wr_beac_airlock_b_03->S_chain_state_greater() );
	wr_beac_airlock_b_04->chain_parent_open( wr_beac_airlock_b_03, wr_beac_airlock_b_03->close_position(), wr_beac_airlock_b_04->S_chain_state_greater() );
	wr_beac_airlock_b_01->auto_distance_open( -4.0, FALSE );
end

// ANGULAR VELOCITY

script dormant f_crate_angular_velocity()
	object_set_angular_velocity(b_antennae_1, 0, 0, 1); 
	object_set_angular_velocity(b_antennae_2, 0, 0, 1);
	object_set_angular_velocity(b_antennae_3, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_1, 0, 0, 1); 
	object_set_angular_velocity(b_crate_space_2, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_3, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_4, 0, 0, 1); 
	object_set_angular_velocity(b_crate_space_5, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_6, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_7, 0, 0, 1);
	object_set_angular_velocity(b_crate_space_8, 0, 0, 1);
end



//DOORS
script dormant f_door_airlock_1_exterior_open()
	//sleep_until( B_airlock_1_complete, 1 );
	sound_impulse_start( 'sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_airlock_high_to_low.sound', NONE, 1 );
	thread(fx_airlock_decompression());
	thread(fx_airlock_decompression2());
	sleep(45);
	f_zero_g_airlock_1_lift();
	sound_set_state( 'set_state_no_gravity' );
	door_airlock_1_exterior->open_default();

end

script static void f_door_airlock_1_exterior_close()
	door_airlock_1_exterior->auto_trigger_close( tv_airlock_inside, FALSE, FALSE, TRUE );
end

script static void f_door_airlock_2_exterior()
	door_airlock_2_exterior->speed_set( door_airlock_2_exterior->speed_fast() );
	door_airlock_2_exterior->open();
end

script static void f_door_airlock_2_exterior_close()
	//device_operates_automatically_set(door_airlock_2_exterior, FALSE );
	door_airlock_2_exterior->close();
end


script dormant f_blip_missile()
		sleep_until (volume_test_players (tv_blip_missile_control), 1);
		wake (f_dialog_beacon_enter);
		//print ("blip missile control");
		//NotifyLevel("blip missile control");
end

script static void f_activator_get( object trigger, unit activator )
	g_ics_player = activator;
end


script dormant f_missile_control_switch()
	
		object_create (missile_control_switch);
		
		wake (f_blip_missile);	
		sleep_until( device_get_position( missile_control_switch ) > 0.0, 1 );
		print ("Missile Switch Fired");
	  f_ai_garbage_erase(sg_beac_erase, 10, 20, -1, -1, TRUE);
		NotifyLevel("unblip missile control");
		show_missile = pup_play_show (missile_button);
		sleep_s(1.5);
		game_save();
		wake (f_accelerator_switch);
		show_missile = pup_play_show (missile_control);
		wake (f_dialog_missile_launched);
		
		sleep_s(2);
		sleep_until(ai_living_count(sg_beacons_all) < 15);
		ai_place (sq_phantom_3);
		
		sleep_s(1);
		sleep_until(ai_living_count(sg_beacons_all) < 12);
		ai_place (sq_phantom_4);
		
		sleep_s(3.5);
		wake (f_dialog_magec_jam);
	

end


script dormant f_accelerator_switch()

		// sleep the length of the Missile Launch
		sleep_s(14.5);
		
		//wake (f_dialog_magac_jam);
		object_create (mag_push_switch);
		sleep_s(1);
		NotifyLevel("blip push point");
		
	
		sleep_until( device_get_position( mag_push_switch ) > 0.0, 1 );
		NotifyLevel("unblip push point");
		pup_stop_show(show_missile);
		//sleep_s(1); 
		object_destroy (mag_push_switch);
		
		local long show = pup_play_show(beacon);
		
		ai_erase_all();
		/*ai_erase(sq_phantom_3);
		//ai_set_deaf (sq_phantom_3, 1);
		ai_set_deaf (sq_phantom_4, 1);
		ai_set_blind (sq_phantom_4, 1);
		ai_erase (sg_1);
		ai_erase (sg_2);
		ai_erase(sg_2_jackals);
		ai_erase (sg_3);
		ai_erase (sg_4);
		ai_erase(sg_2_elites);
		ai_erase (sg_3_lr_jackals);
		ai_erase (sg_4_grunts_front_right);
		ai_erase (sg_4_grunts_back_phantom);*/

		//Music
		thread(f_music_beacon_deck_beacon_objective_complete());

		wake (f_beacon_airlock_exit_control);
		sleep(940);
		thread( f_maw_light_increase());
		sleep_until (b_beacon_played == TRUE); 		// Set true in Puppeter Script
		//sleep_until(not pup_is_playing(show), 1);
		
		game_save_immediate();
		print ("turn on way point");
		
		// GTFO!
		sleep_s(2);
		f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_BEACON_END );
		wake (maw_opens_description);
		pup_play_show(maw_grav_pull); 
		wake (f_dialog_beacon_get_objective_leave_beacon);
		wake (f_airlock_2_grav_trigger);

		objectives_finish(1);
		objectives_show_up_to(2);
			
		// Begin streaming in some of the next zone set.
		prepare_to_switch_to_zone_set("broken_maintenance_preload");
		
		sleep(30 * 2);
		NotifyLevel("blip exit to broken");
		
end

script dormant f_airlock_2_grav_trigger()	
	sleep_until(volume_test_players(tv_airlock_2_gravity),1);
	print("Player Hit Trigger");
	f_zero_g_airlock_2();
end

script static void mag_accel_push( object trigger, unit activator )
	g_ics_player = activator;
end

script dormant fx_grav_pull()
	effect_new ('fx\library\stand-in\stand_in_huge.effect', fx_beac_grav_exp_1 );
	sleep (2);
	effect_new ('fx\library\stand-in\stand_in_huge.effect', fx_beac_grav_exp_2 );
	effect_new ('fx\library\stand-in\stand_in_huge.effect', fx_beac_grav_exp_3 );
	sleep (2);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_4 );
  object_set_angular_velocity(b_crate_space_6, .5, 1, .8);
  sleep (17);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_5 );
  object_set_angular_velocity(b_crate_space_4, 1, .6, .2);
  object_set_angular_velocity(b_cov_barrier_6, .2, .9, .8);
  sleep (9);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_11 );
  object_set_angular_velocity(b_crate_space_5, 1, .8, .2);
  sleep (50);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_26 );
  object_set_angular_velocity(b_antennae_3, .8, .6, .7);
  sleep (23);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_6 );
  object_set_angular_velocity(b_cov_barrier_7, .3, .6, .5);
  object_set_angular_velocity(b_cov_barrier_5, 1, .2, 1);
  sleep (30);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_12 );
  object_set_angular_velocity(b_crate_space_8, .5, .6, 0);
  sleep (9);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_13 );
  sleep (47);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_14 );
  object_set_angular_velocity(b_antennae_1, 0, .5, .2);
  sleep (90);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_15 );
  object_set_angular_velocity(b_crate_space_8, .8, .7, 9);
  object_set_angular_velocity(b_cov_barrier_5, .6, .5, .3);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_7 );
  sleep (30);
  object_set_angular_velocity(b_cov_barrier_1, 1, .4, .6);
  sleep (15);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_8 );
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_9 );
  sleep (9);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_16 );
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_22 );
  object_set_angular_velocity(b_crate_space_7, .3, 1, .4);
  object_set_angular_velocity(b_cov_barrier_3, .8, .7, .6);
  sleep (11);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_23 );
  sleep (11);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_18 );
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_10 );
  object_set_angular_velocity(b_cov_barrier_4, .5, .7, .5);
  sleep (18);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_21 );
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_17 );
  object_set_angular_velocity(b_antennae_2, .6, .9, .1);  
  sleep (11);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_19 );
  object_set_angular_velocity(b_crate_space_3, 0, 0, .8);
  sleep (32);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_20 );
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_25 );
  object_set_angular_velocity(b_cov_barrier_8, 1, 1, 1);
  sleep (21);
  effect_new ('fx\library\stand-in\stand_in_large.effect', fx_beac_grav_exp_24 );
end

script static void f_zero_g_airlock_2()
	object_set_velocity (airlock_2_cr_1, .1, .35, 0);
	object_set_velocity (airlock_2_cr_2, .4, .1, .35);
	object_set_velocity (airlock_2_cr_3, 0, .3, .15);
	object_set_velocity (airlock_2_cr_4, .35, .5, .1);
	object_set_velocity (airlock_2_cr_5, .45, .5, 0);
	print ("Shoot that debris");
	object_create(airlock_phantom);
end

script static void f_zero_g_airlock_2_drop()
	object_set_gravity (airlock_2_cr_1, 1, 1);
	object_set_gravity (airlock_2_cr_2, 1, 1);
	object_set_gravity (airlock_2_cr_3, 1, 1);
	object_set_gravity (airlock_2_cr_4, 1, 1);
	object_set_gravity (airlock_2_cr_5, 1, 1);
	object_set_velocity (airlock_2_cr_1, 0, .1, .1);
	object_set_velocity (airlock_2_cr_2, 0, .1, .1);
	object_set_velocity (airlock_2_cr_3, 0, .1, .1);
	object_set_velocity (airlock_2_cr_4, 0, .1, .1);
	object_set_velocity (airlock_2_cr_5, 0, .1, .1);
end

script static void f_zero_g_airlock_1_lift()
	object_set_gravity (cr_airlock_01, 0, 1);
	object_set_gravity (cr_airlock_02, 0, 1);
	object_set_gravity (cr_airlock_03, 0, 1);
	object_set_gravity (cr_airlock_04, 0, 1);
	object_set_gravity (cr_airlock_05, 0, 1);
	object_set_gravity (cr_airlock_06, 0, 1);
	object_set_gravity (cr_airlock_07, 0, 1);
	object_set_gravity (cr_airlock_08, 0, 1);
	object_set_gravity (cr_airlock_09, 0, 1);
	object_set_velocity (cr_airlock_01, .5, .1, 0);
	object_set_velocity (cr_airlock_02, .5, .1, 0);
	object_set_velocity (cr_airlock_03, .5, .1, 0);
	object_set_velocity (cr_airlock_04, .5, .1, 0);
	object_set_velocity (cr_airlock_05, .5, .1, 0);
	object_set_velocity (cr_airlock_06, .5, .1, 0);
	object_set_velocity (cr_airlock_07, .5, .1, 0);
	object_set_velocity (cr_airlock_08, .5, .1, 0);
	object_set_velocity (cr_airlock_09, .5, .1, 0);
end

script dormant f_beac_late_spawn()
	sleep_until(ai_living_count(sg_beacons_all) <= 20);
	sleep_until(volume_test_players_lookat(tv_late_spawn_1, 40, 40) == FALSE AND volume_test_players_lookat(tv_late_spawn_2, 40, 40) == FALSE);
	ai_place(sq_2_jackal_2);
	ai_place(sq_3_elite);
end

/// Lighting increase in beacons when the Maw opens

script static void f_maw_light_increase()
	print("::light is increasing::");
	interpolator_start('sun');
end