//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice Flight
//	Insertion Points:	start (or ist)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343





// =================================================================================================
// =================================================================================================
// SHIP HANDLERS
// =================================================================================================
// =================================================================================================
global real _TURRET_SCALE_SIZE = 0.85;
global boolean b_OpeningIntroStart = FALSE;
global boolean b_SpaceFlight_Start = TRUE;
global boolean b_Init_Flight = FALSE;
global boolean b_trench_a_complete = FALSE;
global boolean b_trench_b_complete = FALSE;
global boolean b_trench_c_complete = FALSE;
global boolean b_trench_d_complete = FALSE;
global boolean b_trench_e_complete = FALSE;
global boolean b_showing_tutorial = FALSE;


script dormant f_flight_start_init()

	dprint("======= f_flight_start_init:: waiting for mission start =====");
	sleep_until ( b_mission_started == TRUE) ;

		dprint ("::: Flight starting :::");
		create_player_ships (v_ship0, v_ship1, v_ship2, v_ship3);
		sleep(1);
		load_player_ships (v_ship0, v_ship1, v_ship2, v_ship3);
		f_space_particles_on( true );
		//wake (f_trench_main);	
		sleep(30);
		fade_in(0,0,0,0);
		hud_play_global_animtion (screen_fade_in);
	
		hud_stop_global_animtion (screen_fade_in);
		b_SpaceFlight_Start = TRUE;

		thread (f_ship_speed_check (player0));
		thread (f_ship_speed_check (player1));
		thread (f_ship_speed_check (player2));
		thread (f_ship_speed_check (player3));
		
		thread (player_dies_in_trench (player0));
		thread (player_dies_in_trench (player1));
		thread (player_dies_in_trench (player2));
		thread (player_dies_in_trench (player3));
	
		sleep (30 * 6);
	
		thread (f_flight_tutorial (player0));
		thread (f_flight_tutorial (player1));		
		thread (f_flight_tutorial (player2));
		thread (f_flight_tutorial (player3));
						
end

script static void f_ship_speed_check(player p_player)
	
	sleep_until (object_active_for_script (unit_get_vehicle (p_player)), 1);
	
	sleep (1);
	
	sleep_until (object_get_velocity (unit_get_vehicle (p_player)) > 15);
	
	sleep (1);
	
	sleep_until ((object_get_health (p_player) <= 0) or (object_get_velocity (unit_get_vehicle (p_player)) <= 15), 1);
			
	damage_object (unit_get_vehicle (p_player), default, 10000);
	
end

script static void player_dies_in_trench (player p_player)
	
	local long l_speedcheck = 0;
	
	repeat
	
		dprint ("waiting for player to be dead");
		sleep_until (object_get_health(p_player) <= 0, 1);
		
		sleep (5);
		
		if (b_Eye_Complete == FALSE) then

			if (game_coop_player_count() == 1) then	
	
				// if this is a single-player game then wait 2.5 seconds and fade to black since 
				// it'll take another 5 seconds to respawn and then we won't come back from black
					
				dprint ("2.5 second wait");
				sleep_s(2.5);

				dprint ("YOU HAVE DIED, fading out");
				fade_out_for_player (p_player);

				// if this is a single player game then increase the wait for another 5 seconds
				// we should revert to save before this ever comes back.
				sleep_s(5);
			else
				dprint ("YOU HAVE DIED, fading out");
				fade_out_for_player (p_player);

				dprint ("3 second wait");
				sleep_s(3);		
			end

			dprint ("fading back in");
			fade_in_for_player (p_player);

			dprint ("waiting for player to be alive again, or for the eye to be completed");
			sleep_until (object_get_health (p_player) > 0, 1) or (b_Eye_Complete == TRUE);
			
			if (b_eye_complete == FALSE) then
			
				sleep (5);
			
				l_speedcheck = thread (f_ship_speed_check(p_player));
				dprint ("restarting speed check for this player, about to repeat");			
				
			else
			
				kill_thread (l_speedcheck);
				dprint ("you beat flight");
				
			end
	
		end
	
	until (b_eye_complete == TRUE);
		
end

script dormant f_trench_a_init()


	sleep_until( b_Init_Flight, 4 );
	sleep_until ( volume_test_players( tv_flight_start ) and current_zone_set_fully_active() == s_start_idx , 1);
		dprint("INIT::: Trench A");
		set_broadsword_respawns ( true );
		data_mine_set_mission_segment ("m90_flight");
		//inspect(current_zone_set_fully_active());
		wake(f_trench_a_blocker_controller);
		thread(f_trench_a_cleanup());
	
		//object_create( dm_trench_a_door_1 );		
		object_create_folder( crs_trench_a_ants );
		object_create_folder( crs_trench_a );
		wake( f_trench_a_door_1_wait );
		//wake(f_trench_a_exit_wait);
		//wake(f_trench_a_fire_tut_wait);
		wake(f_trench_a_gate_blip_wait);
		wake( nar_flight_start_init );
		thread(f_trench_a_turret_reveal_wait());
		thread( f_trench_a_turret_end_wait());	
		//thread( f_trench_a_setup_intro_obs() );	
		thread( f_trench_a_setup_end_objs () );	
		wake( f_trench_a_containers );
		wake( f_trans_ab_wait );
		thread( f_mus_m90_e01_start() );
		//fade_in (0, 0, 0, 0);
		sleep(1);
		game_save_immediate();
		sleep(1);
	sleep_until( b_SpaceFlight_Start );
		thread(f_m90_show_chapter_title( title_intro ));
		//sleep( 5 );
		thread( nar_ship_growing() );

		f_m90_start_objectives();


		sleep(45);
		//thread( f_weapon_turning_tutorial());

		sleep_s(6);
		thread( f_objective_set( DEF_R_OBJECTIVE_START, TRUE, FALSE, TRUE,TRUE ) );
		wake( f_flight_waypoint_goals );
		sleep(1);
		wake( f_flight_setup_players_waypoints );
		thread( f_death_orb_damage(tv_trench_a_gate, cr_trench_a_gate_lock) );
		
		//clear_all_text(); 
		
		
		//f_trench_door_close(maya_tr_ab_tran_dr_1_inner_1)

end

script static void f_trench_a_cleanup()
	sleep_until(volume_test_players( tv_trench_a_cleanup ) or b_ForceCleanup == true, 1);
		dprint("CLEANUP:: trench a");

		object_destroy_folder( crs_trench_a_ants );
		object_destroy_folder( crs_trench_a );
		b_trench_a_complete = TRUE;
		ai_erase(sq_for_trench_a_tur);
		ai_erase(sq_for_trench_a_tur_2);
		ai_erase(sq_for_trench_a_front);
		wake( f_trench_a_device_cleanup );
		f_unblip_flag(fg_tr_a_gate_wp);
		
end

global real r_tutorial_time = 7;

script static void player_boost_tutorial (player p_player)
	/*
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
  */
  dprint ("old tutorial stuff");
  
end

script static void f_flight_tutorial (player p_player)
	
	dprint ("LEARN TO STEER");
	chud_show_screen_training (p_player, "tut_bsword_steer");

  sleep (30 * 4);
  
  chud_show_screen_training (p_player, "");
  
  sleep (30);
  
  dprint ("LEARN TO BANK");
	chud_show_screen_training (p_player, "tut_bsword_bank");
	
	sleep (30 * 4);
	
	chud_show_screen_training (p_player, "");
  
  sleep (30);
	
  dprint ("LEARN TO BOOST");
	chud_show_screen_training (p_player, "tut_bsword_boost");
	
	sleep (30 * 4);
	
	chud_show_screen_training (p_player, "");
  
  sleep (30);
	
	dprint ("LEARN TO SHOOT");
	chud_show_screen_training (p_player, "tut_bsword_shoot");
	
	sleep (30 * 4);
	
	chud_show_screen_training (p_player, "");
  
  sleep (30);
	
	dprint ("LEARN TO CHANGE WEAPONS");
	chud_show_screen_training (p_player, "tut_bsword_toggle_weap");
	
	sleep (30 * 4);
	
	chud_show_screen_training (p_player, "");
  

	
end



/*
script static void f_tut_1()
	
	
	local unit playerx = player_get_first_valid();
	if not difficulty_legendary() then
		b_showing_tutorial = TRUE;

		f_tutorial_right_bumper( playerx, tut_bsword_toggle_weap);
		b_showing_tutorial = FALSE;
	end
end

script static void f_tut_trick()
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	if not difficulty_legendary() then
		//	f_tutorial_tricks( player0, tut_bsword_trick);
		b_showing_tutorial = TRUE;
		f_tutorial_begin ( playerx, tut_bsword_trick );
			//thread( f_weapon_switch_tut_timer());
			sleep(1);
		sleep_until( unit_action_test_vehicle_trick_secondary( playerx ) or timer_expired( l_timer ), 1 );
			f_tutorial_end (playerx);
			b_showing_tutorial = FALSE;	
			//dprint("Trick complete");
	end
end

script static void f_tut_2()
		local unit playerx = player_get_first_valid();
		if not difficulty_legendary() then
			b_showing_tutorial = TRUE;
			f_tutorial_left_bumper( playerx, tut_bsword_steer);
			b_showing_tutorial = FALSE;
		end
end


global boolean b_tut_timeup = FALSE;

script static void f_weapon_switch_tutorial()
	dprint("weapon switch tut");
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	if not difficulty_legendary() then
		b_showing_tutorial = TRUE;
	//f_tutorial_rotate_weapons( player0, tut_bsword_toggle_weap);
		f_tutorial_begin ( playerx, tut_bsword_toggle_weap );
		//thread( f_weapon_switch_tut_timer());
		sleep(1);
		sleep_until(unit_action_test_rotate_weapons( playerx ) or timer_expired( l_timer ), 1);
			f_tutorial_end (playerx);	
			b_showing_tutorial = FALSE;
	end
end
/*
script static void f_weapon_switch_tut_timer()
	b_tut_timeup = FALSE;
	sleep_s(10);
	b_tut_timeup = TRUE;

end

script static void f_weapon_turning_tutorial()
	//f_tutorial_turn(player0, tut_bsword_steer);
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	b_showing_tutorial = TRUE;
	f_tutorial_begin ( player0, tut_bsword_steer );
	sleep_until(unit_action_test_look_relative_all_directions ( playerx ) or timer_expired( l_timer ), 1);
		sleep_s (3);
		f_tutorial_end ( playerx );
		b_showing_tutorial = FALSE;
		f_weapon_banking_tutorial();	
end

script static void f_weapon_banking_tutorial()
	//f_tutorial_turn(player0, tut_bsword_steer);
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	b_showing_tutorial = TRUE;
	f_tutorial_begin ( player0, tut_bsword_bank );
	sleep_until(unit_action_test_move_relative_all_directions ( playerx ) or timer_expired( l_timer ), 1);
		sleep_s (3);
		f_tutorial_end ( playerx );
		b_showing_tutorial = FALSE;
		f_weapon_fire_tutorial();
end

script static void f_weapon_fire_tutorial()
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	//f_tutorial_fire_weapon(player0, tut_bsword_shoot);
	b_showing_tutorial = TRUE;
	f_tutorial_begin (playerx, tut_bsword_shoot);
	//sleep_s (4);
	sleep_until(unit_action_test_primary_trigger ( playerx )or timer_expired( l_timer ), 1);
		sleep_s (4);
		f_tutorial_end ( playerx );	
		b_showing_tutorial = FALSE;
		f_weapon_switch_tutorial();
end

script static void f_weapon_boost_tutorial()
	//f_tutorial_boost(player0, tut_bsword_boost);
	local unit playerx = player_get_first_valid();
	local long l_timer = timer_stamp( r_tutorial_time ); 
	b_showing_tutorial = TRUE;
	f_tutorial_begin (playerx, tut_bsword_boost);
	sleep_until(unit_action_test_grenade_trigger ( playerx )or timer_expired( l_timer ), 1);
		sleep_s (3);
		f_tutorial_end ( playerx );	
		b_showing_tutorial = FALSE;
end

script dormant f_trench_a_fire_tut_wait()
	
	sleep_until (volume_test_players( tv_trench_a_fire_tut ), 1);
		
		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end
		
		sleep_s(1);
		f_weapon_fire_tutorial();
		//sleep_s(1);
		
		//f_weapon_switch_tutorial();
end

*/

script dormant f_trench_a_spawns()

	ai_place( sq_for_trench_a_front );
	sleep(30);
	ai_place(sq_for_trench_a_tur);
	sleep( 30 );
	ai_place(sq_for_trench_a_tur_2);


	//cs_shoot(  sq_for_trench_a_tur.reveal ,TRUE, player0 );

end



//


script dormant f_trench_main()
	dprint("=== Trench Main INIT ===");	

	wake( f_trench_a_init );
	wake( f_trench_b_init ) ;
	wake( f_trench_c_init );
	wake( f_trench_d_init ) ;
	wake( f_trench_e_init ) ;
	wake( f_eye_flight_init );

end

script static void create_player_ships (object_name ship0, object_name ship1, object_name ship2, object_name ship3)
	
	if (player_valid( player0 )) then
		object_create (ship0);
		//dprint ("trying to load ship");
	end
	if (player_valid( player1 )) then
		object_create (ship1);
		//dprint ("trying to load ship");
	end
	if (player_valid( player2 )) then
		object_create (ship2);
		//dprint ("trying to load ship");
	end
	if (player_valid( player3 )) then
		object_create (ship3);
		//dprint ("trying to load ship");
	end
	
	sleep(1);
end

script static void load_player_ships (vehicle ship0, vehicle ship1, vehicle ship2, vehicle ship3)
	
		
	if (player_valid( player0 )) then
		vehicle_load_magic (ship0, "warthog_d", player0());
		//dprint ("trying to load ship");
	end
	
	if (player_valid( player1 )) then
		vehicle_load_magic (ship1, "warthog_d", player1());
	end

	if (player_valid( player2 )) then
		vehicle_load_magic (ship2, "warthog_d", player2());
	end	
		
	if (player_valid( player3 )) then
		vehicle_load_magic (ship3, "warthog_d", player3());
	end
		
end



script dormant f_trench_a_blocker_controller()

	sleep_until(any_players_in_vehicle(),1);

		wake(f_trench_a_gate_wait);
		wake( f_trench_a_ralphie_wake );
		thread( f_trench_a_closing_tunnel_wake() );
	
end


script static void f_trench_a_setup_end_objs()
	device_set_position_track( maya_tr_a_end_0_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_0_left, 1, 0, 0.1, 0.0, TRUE );
	device_set_position_track( maya_tr_a_end_0_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_0_right, 1, 0, 0.1, 0.0, TRUE );
	
	device_set_position_track( maya_tr_a_end_1_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_1_left, 0.6, 0, 0.1, 0.0, TRUE );
	device_set_position_track( maya_tr_a_end_1_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_1_right, 0.9, 0, 0.1, 0.0, TRUE );
	
	device_set_position_track( maya_tr_a_end_2_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_2_left, 0.9, 0, 0.1, 0.0, TRUE );
	device_set_position_track( maya_tr_a_end_2_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_2_right, 0.6, 0, 0.1, 0.0, TRUE );	

	device_set_position_track( maya_tr_a_end_3_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_3_left, 0.6, 0, 0.1, 0.0, TRUE );
	device_set_position_track( maya_tr_a_end_3_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_3_right, 0.9, 0, 0.1, 0.0, TRUE );
	
	device_set_position_track( maya_tr_a_end_4_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_4_left, 0.7, 0, 0.1, 0.0, TRUE );
	device_set_position_track( maya_tr_a_end_4_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_end_4_right, 0.7, 0, 0.1, 0.0, TRUE );
end


script dormant f_trench_a_containers()
	sleep_until( object_valid( maya_tr_a_container_1 ), 1 );
		//dprint("containers");
		device_set_position_track( maya_tr_a_container_1, 'any:idle', 0.0 );
		sleep(90);
		device_set_position_track( maya_tr_a_container_2, 'any:idle', 0.0 );
		sleep(60);
		device_set_position_track( maya_tr_a_container_3, 'any:idle', 0.0 );
		sleep(30);
		device_set_position_track( maya_tr_a_container_4, 'any:idle', 0.0 );
end

//maya_tr_a_blocker_left
//maya_tr_a_blocker_right
script dormant f_trench_a_ralphie_wake()
		thread ( ralphie_set() );
		sleep_until (volume_test_players(tv_trench_a_ralphie), 1);

			thread(f_trench_a_scubbo());
			sleep(30);
			thread(f_trench_a_ralphie());
			//sleep(60);
			//thread( f_weapon_switch_tutorial() );		

end

// test
script static void ralphie()
			thread( f_trench_a_scubbo() ) ;
			sleep(15);
			thread( f_trench_a_ralphie() );
end

script static void ralphie_set()

			device_set_position_track( maya_tr_a_pg_b_left, 'any:idle', 0.0 );
			device_animate_position( maya_tr_a_pg_b_left, 0.75, 0, 0.1, 0.0, TRUE );

			device_set_position_track( maya_tr_a_pg_b_right, 'any:idle', 0.0 );
			device_animate_position( maya_tr_a_pg_b_right, 0.75, 0, 0.1, 0.0, TRUE );
			//sleep(30);
			device_set_position_track( maya_tr_a_pg_a_right, 'any:idle', 0.0 );
			device_animate_position( maya_tr_a_pg_a_right, 1, 0, 0.1, 0.0, TRUE );

			device_set_position_track( maya_tr_a_pg_a_left, 'any:idle', 0.0 );
			device_animate_position( maya_tr_a_pg_a_left, 1, 0, 0.1, 0.0, TRUE );


		
end

script static void f_trench_a_ralphie()
	device_animate_position( maya_tr_a_pg_a_left, 0.8, 1.75, 0.1, 0.0, TRUE );
	device_animate_position( maya_tr_a_pg_a_right, 0.8, 1.75, 0.1, 0.0, TRUE );
end

script static void f_trench_a_scubbo()
	device_animate_position( maya_tr_a_pg_b_left, 0.8, 1.75, 0.1, 0.0, TRUE );
	device_animate_position( maya_tr_a_pg_b_right, 0.8, 1.75, 0.1, 0.0, TRUE );
end


script static void f_trench_a_closing_tunnel_wake()
		device_set_position_track( maya_tr_a_tun_a_1, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_a_tun_a_2, 'any:idle', 0.0 );
		
		sleep_until (volume_test_players(tv_trench_a_closing_tunnel), 1);
			sleep(45);
			device_animate_position( maya_tr_a_tun_a_1, 0.36, 2.5, 0.1, 0.0, TRUE );
			sleep(60);
			device_animate_position( maya_tr_a_tun_a_2, 0.36, 2.5, 0.1, 0.0, TRUE );
			
end




//fg_tr_a_gate_wp
script dormant f_trench_a_gate_blip_wait()
	sleep_until (volume_test_players(tv_trench_a_shoot_ball), 1);
		
	if object_get_health(cr_trench_a_gate_lock) > 0 then
		f_blip_flag(fg_tr_a_gate_wp, "neutralize");
	end
	
end



script static void f_trench_a_turret_reveal_wait()

	device_set_position_track( maya_tr_a_b1_b_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_b_right, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_a_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_a_right, 'any:idle', 0.0 );

	device_set_position_track( maya_tr_a_blocker_left, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_blocker_left, 0.9, 0, 0.1, 0.0, TRUE );
	
	device_set_position_track( maya_tr_a_blocker_right, 'any:idle', 0.0 );
	device_animate_position( maya_tr_a_blocker_right, 0.9, 0, 0.1, 0.0, TRUE );	
	


	sleep_until (volume_test_players(tv_trench_a_turret_reveal), 1);
		wake(f_trench_a_spawns);	
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_a_left));
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_a_right));
		sleep(30);
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_b_left));
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_b_right));
	sleep_s(1.5);
		device_animate_position( maya_tr_a_blocker_left, 0.4, 2.5, 0.1, 0.0, FALSE );
		device_animate_position( maya_tr_a_blocker_right, 0.4, 2.5, 0.1, 0.0, FALSE );	
end


script static void reveal_test()
	device_set_position_track( maya_tr_a_b1_b_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_b_right, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_a_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_a_b1_a_right, 'any:idle', 0.0 );
		sleep(1);
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_a_left));
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_a_right));
		sleep(30);
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_b_left ));
		thread(f_trench_a_turret_reveal_move( maya_tr_a_b1_b_right));

end

global real s_TR_A_TIME = 3.5;
global real s_TR_A_POSITION = 0.85;
///////////////////////////////////
///  FIRST TURRET REVEAL         // 
///////////////////////////////////

script static void f_trench_a_turret_reveal_move( device dm )
	device_animate_position( dm, 0.55, s_TR_A_TIME / 2, 0.1, 0.0, TRUE );
	sleep_s(s_TR_A_TIME / 2);
	device_animate_position( dm, s_TR_A_POSITION, s_TR_A_TIME / 2, 0.1, 0.0, TRUE );
end

///////////////////////////////////
///  END TURRET REVEAL         // 
///////////////////////////////////
script static void f_trench_a_turret_end_wait()

	sleep_until (volume_test_players(tv_trench_a_turret_end), 1);
		thread(f_trench_a_turret_reveal_end_left());
		thread(f_trench_a_turret_reveal_end_right());

end

script static void end_turret()
		thread(f_trench_a_turret_reveal_end_left());
		thread(f_trench_a_turret_reveal_end_right());
end

script static void f_trench_a_turret_reveal_end_left()
	device_animate_position( maya_tr_a_end_4_left, 0.80, s_TR_A_TIME, 0.1, 0.0, TRUE );
	sleep_s(0.75);
	//device_animate_position( maya_tr_a_end_3_left, 1, s_TR_A_TIME, 0.1, 0.0, TRUE );
	thread(f_trench_a_open_obj( maya_tr_a_end_3_left, 09 ));
	//sleep(30);
	sleep_until( volume_test_players( tv_trench_a_door_1 ) , 1 );

		device_animate_position( maya_tr_a_end_2_left, 0, s_TR_A_TIME, 0.1, 0.0, TRUE );
		sleep_s( 0.75 );
		//device_animate_position( maya_tr_a_end_1_left, 1, 0.5, 0.1, 0.0, TRUE );
		thread(f_trench_a_open_obj( maya_tr_a_end_1_left, 09 ));
		sleep_s( 0.75 );
		device_animate_position( maya_tr_a_end_0_left,0.95, s_TR_A_TIME, 0.1, 0.0, TRUE );
end

script static void f_trench_a_turret_reveal_end_right()
	device_animate_position( maya_tr_a_end_4_right, 0.80, s_TR_A_TIME, 0.1, 0.0, TRUE );
	sleep_s(0.75);
	device_animate_position( maya_tr_a_end_3_right, 0.0, s_TR_A_TIME, 0.1, 0.0, TRUE );
	sleep_until( volume_test_players( tv_trench_a_door_1 ) , 1 );
		//device_animate_position( maya_tr_a_end_2_right, 1.0, s_TR_A_TIME, 0.1, 0.0, TRUE );
		thread(f_trench_a_open_obj( maya_tr_a_end_2_right, 09 ));
		sleep_s( 0.75 );
		device_animate_position( maya_tr_a_end_1_right, 0.1, s_TR_A_TIME, 0.1, 0.0, TRUE );
		sleep_s( 0.75 );
		device_animate_position( maya_tr_a_end_0_right, 0.8, s_TR_A_TIME, 0.1, 0.0, TRUE );
end

script static void f_trench_a_open_obj( device dm, real pos )

	//device_set_position_track( dm, 'any:idle', 0.0 );
	//sleep(5);
	device_animate_position( dm, 0.75, 1.0, 0.1, 0.0, TRUE );
	sleep_s(1);
	device_animate_position( dm, pos, 1.5, 0.1, 0.0, TRUE );
end






///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRANSITION AB
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


script dormant f_trench_a_gate_wait()
	device_set_position_track( maya_tr_a_gate_1, 'any:idle', 0.0 );
	sleep_until(object_get_health(cr_trench_a_gate_lock) <= 0, 1);		
		dprint("open gate");
		device_animate_position( maya_tr_a_gate_1, 1.0, 1.75, 0.1, 0.0, TRUE );
		sleep(3);		
		f_unblip_flag(fg_tr_a_gate_wp);
end





script dormant f_trench_a_door_1_wait()

	sleep_until (volume_test_players(tv_trench_a_door_1), 1);
		thread(f_close_trench_a_door_1());
end

script static void f_close_trench_a_door_1()

	sleep_until( object_valid(dm_trench_a_door_1), 1 );
		device_set_position_track( dm_trench_a_door_1, 'any:idle', 0.0 );
		device_animate_position( dm_trench_a_door_1, 0.70, 5, 0.1, 0.0, TRUE );
	sleep_until(volume_test_players(tv_trench_a_door_1_shut), 1);
	//sleep_s(4);
		device_animate_position( dm_trench_a_door_1, 1.0, 5, 0.1, 0.0, TRUE );
		sleep_s( 8 );
		f_trench_activate_death_zone( kill_trench_a_tv, true );
end

script dormant f_trench_a_exit_wait()
	sleep_until (volume_test_players(tv_trench_a_exit), 1);
		object_create( dm_trans_1_probe_1 );
end



script dormant f_trans_ab_wait()
	sleep_until( volume_test_players( tv_trench_a_exit ), 1);
		//object_create_folder( crs_trans_ab );
		sleep(3);
		
		//thread( cr_trans_ab_tower_1->f_wait_destruction( cr_trans_ab_lock_1 ) );
		//thread( cr_trans_ab_tower_2->f_wait_destruction( cr_trans_ab_lock_2 ) );
		//thread( cr_trans_ab_tower_3->f_wait_destruction( cr_trans_ab_lock_3 ) );
		//thread( cr_trans_ab_tower_4->f_wait_destruction( cr_trans_ab_lock_4 ) );
		
end

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRENCH B
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

script dormant f_trench_b_init()
	sleep_until (volume_test_players(tv_trench_b_init), 1);	
		//thread( f_tut_trick() );
		dprint("INIT::: trench b");
		set_broadsword_respawns ( true );
		object_create_folder(trench_b_blockers);
		object_create_folder(trench_b_ants);
		//object_create(dm_trench_b_gate);
		wake( nar_flight_trench_b_init );
		thread( f_trench_door_close_setup(maya_tr_ab_tran_dr_1_inner_1, 8, true, 7, tv_trench_a_cleanup, kill_trans_ab_1) );
		sleep(3);
		garbage_collect_now();
		object_create( sc_trench_b_splip_space );
		sleep(1);
		object_cinematic_visibility(sc_trench_b_splip_space, TRUE);
////		SetSkyObjectOverride("m90_trench_sky");
		//wake(f_trench_b_gate_wait);
	sleep_until (volume_test_players(tv_trench_b_post_init), 1);	
			dprint("create trench b objects");

			sleep(1);

			wake(f_trench_b_turret_spawn_controller);
			thread(f_trench_b_cleanup());
			//wake(f_trench_b_end_turr_destroy_wait);
			wake(f_trench_b_teeth_wait);
			wake(f_trench_b_rail_guard_wait);

			wake(f_trench_b_platform_save_wait);
			wake( f_trench_bc_trans_door_setup );
			thread( f_trench_b_wall_reveal_wait() );
			thread( f_death_orb_damage(tv_trench_b_gate_a, cr_trench_b_lock_4) );
			thread( f_death_orb_damage(tv_trench_b_gate_b, cr_trench_b_lock_7) );
			thread( f_death_orb_damage(tv_trench_b_gate_c, cr_trench_b_lock_5) );
			thread( f_death_orb_damage(tv_trench_b_gate_d, cr_trench_b_lock_6) );
			garbage_collect_now();
			sleep(1);
			
		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end


end

script dormant f_trench_b_turret_spawn_controller()
				
	ai_place(sq_for_trenchb_turrets_begin);
	
	sleep_until (volume_test_players(tv_trench_b_spawn_mid_turs) , 1);			
		ai_place(sq_for_trenchb_mid);
		sleep(3);
		
		ai_place( sq_for_trenchb_power_end );
		sleep(5);
		ai_place(sq_for_trenchb_av_end);
		sleep(1);	
		ai_place( sq_for_trenchb_tracers_end );		
		sleep(1);
		
	sleep_until (volume_test_players(	tv_trench_b_spawn_end_turrs) , 1);			

		ai_erase ( sq_for_trenchb_turrets_begin );
		sleep(3);
		
		
end

script dormant f_trench_b_phase_in_turrets_mid()
	sleep(1);
	//object_dissolve_from_marker( ai_vehicle_get ( turret ), phase_in, fx_life_source );
	//object_dissolve_from_marker( ai_vehicle_get ( turret ), phase_in, fx_life_source );
	//object_dissolve_from_marker( ai_vehicle_get ( turret ), phase_in, fx_life_source );

end

script static void f_trench_b_cleanup()
	sleep_until (volume_test_players(tv_trench_b_cleanup) or b_ForceCleanup == true, 1);	
		dprint("ClEANUP::: trench b");
		object_destroy_folder(trench_b_blockers);
		object_destroy_folder(trench_b_ants);
		b_trench_b_complete = TRUE;
		ai_erase( sq_for_trenchb_turrets_begin );
		ai_erase( sq_for_trenchb_mid );
		ai_erase( sq_for_trenchb_av_end );
		ai_erase( sq_for_trenchb_tracers_end );
		ai_erase( sq_for_trenchb_power_end );
		wake ( f_trench_b_device_cleanup );

end

//maya_tr_b_m90_door_left
//maya_tr_b_m90_door_right


script static void f_trench_b_wall_reveal_wait()

	device_set_position_track( maya_tr_b_m90_door_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_m90_door_right, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_m90_door_right_2, 'any:idle', 0.0 );
	device_animate_position( maya_tr_b_m90_door_left, 1 , 0, 0.1, 0, FALSE );
	device_animate_position( maya_tr_b_m90_door_right, 1 , 0, 0.1, 0, FALSE );
	device_animate_position( maya_tr_b_m90_door_right_2, 1 , 0, 0.1, 0, FALSE );
	//maya_tr_b_m90_door_right_2
	sleep_until (volume_test_players(tv_trench_b_spawn_mid_turs), 1);
		device_animate_position( maya_tr_b_m90_door_right_2, 0 , 6, 0.1, 0, FALSE );
		sleep(30);	
		device_animate_position( maya_tr_b_m90_door_left, 0 , 6, 0.1, 0, FALSE );
		sleep(15);
		device_animate_position( maya_tr_b_m90_door_right, 0 , 6, 0.1, 0, FALSE );

end

script static void tb_reveal()
	device_set_position_track( maya_tr_b_m90_door_left, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_m90_door_right, 'any:idle', 0.0 );
	sleep(1);
	device_animate_position( maya_tr_b_m90_door_left, 1 , 0, 0.1, 0, FALSE );
	device_animate_position( maya_tr_b_m90_door_right, 1 , 0, 0.1, 0, FALSE );
	sleep(90);
	
	device_animate_position( maya_tr_b_m90_door_left, 0 , 6, 0.1, 0, FALSE );
	sleep(60);
	device_animate_position( maya_tr_b_m90_door_right, 0 , 6, 0.1, 0, FALSE );
	
end

script dormant f_trench_b_platform_save_wait()
	sleep_until (volume_test_players(tv_trench_b_platform_1), 1);

		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end

		sleep_s(2);
		object_cinematic_visibility(sc_trench_b_splip_space, FALSE);
		sleep(1);
		object_set_function_variable(sc_trench_a_splip_space, exit_slipspace, 1, 4.0);
		object_set_function_variable(sc_trench_b_splip_space, exit_slipspace, 1, 4.0);
		sound_set_state( 'set_state_amb_m90_ac_flight_nonslipspace' );
		sound_impulse_start( 'sound\environments\solo\m090\amb_m90_slipspace_exit_st', NONE, 1 );
end



script dormant f_trench_b_teeth_wait()
	sleep_until (volume_test_players(tv_trench_b_teeth), 1);
	

		f_trench_b_teeth();
end


script static void f_trench_b_teeth()
	if not object_valid(maya_tr_b_teeth_rise) then
		object_create(maya_tr_b_teeth_rise);
		sleep(2);
	end
	device_set_position_track( maya_tr_b_teeth_rise, 'any:idle', 0.0 );
	device_animate_position( maya_tr_b_teeth_rise, 1.0, 7.0, 0.1, 0.0, TRUE );
	
	sleep_until( device_get_position( maya_tr_b_teeth_rise ) >= .98 , 1 );
			object_dissolve_from_marker( ai_vehicle_get ( sq_for_trenchb_tracers_end.teeth_2 ), phase_in, fx_life_source );
			object_dissolve_from_marker( ai_vehicle_get ( sq_for_trenchb_av_end.teeth_1 ), phase_in, fx_life_source );
		//ai_place(sq_for_trenchb_av_end);	
		//ai_place( sq_for_trenchb_tracers_end );
end


global real TOOTH_TIME = 2.0;
script dormant f_trench_b_rail_guard_wait()

	device_set_position_track( maya_tr_b_wall_guard_2, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_wall_guard_3, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_wall_guard_4, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_wall_guard_5, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_wall_guard_6, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_b_wall_guard_7, 'any:idle', 0.0 );
	
	//sleep_until (volume_test_players(tv_trench_b_rail_guard_a), 1);
		
	sleep_until (volume_test_players(tv_trench_b_rail_guard_b), 1);
		//dprint("RAIL GUARD");
		device_animate_position( maya_tr_b_wall_guard_2, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
		sleep(60);
		device_animate_position( maya_tr_b_wall_guard_3, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
		sleep(120);
		device_animate_position( maya_tr_b_wall_guard_4, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
		sleep(90);
		device_animate_position( maya_tr_b_wall_guard_5, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
		sleep(90);
		device_animate_position( maya_tr_b_wall_guard_6, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
		sleep(90);
		device_animate_position( maya_tr_b_wall_guard_7, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );

end


script static void f_trench_b_rail_guard(device dm)
	device_animate_position( dm, 1.0, TOOTH_TIME, 0.1, 0.0, TRUE );
end



script static void f_trench_b_exit_gate()
	sleep_s(17.5);
	f_trench_activate_death_zone( kill_trench_b_tv, true );
end

script dormant f_trench_bc_trans_door_setup()
		sleep_until( object_valid( maya_tr_bc_tran_dr_1_outer), 1);
		thread( f_trench_door_close_setup( maya_tr_bc_tran_dr_1_outer, 12, TRUE,  6, tv_trench_b_door_1 , kill_trench_b_tv) );
		sleep_until( object_valid( maya_tr_bc_tran_dr_1_inner), 1);
			thread( f_trench_door_close_setup( maya_tr_bc_tran_dr_1_inner, 8, TRUE,  5, tv_trench_b_exit, kill_trans_bc_1 ) );
		//sleep_until( object_valid( maya_tr_bc_transition_door_1), 1);
			//thread( f_trench_door_close_setup( maya_tr_bc_transition_door_1, 8, FALSE,  0, tv_trench_bc_door_2, tv_none ) );
		//sleep_until( object_valid( maya_tr_bc_transition_door_2), 1);
			//thread( f_trench_door_close_setup( maya_tr_bc_transition_door_2, 12, FALSE,  0, tv_trench_bc_door_2, tv_none ) );
		sleep_until( object_valid( maya_tr_bc_transition_door_3), 1);
			thread( f_trench_door_close_setup( maya_tr_bc_transition_door_3, 8, FALSE,  0, tv_trench_b_cleanup, tv_none ) );
		sleep_until( object_valid( maya_tr_bc_transition_door_4), 1);
			thread( f_trench_door_close_setup( maya_tr_bc_transition_door_4, 12, TRUE,  6, tv_trench_b_cleanup, kill_trans_bc_2 ) );
end





///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRANSITION BC
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRENCH C
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
script dormant f_trench_c_init()
	sleep_until (volume_test_players(tv_trench_c_init), 5);	
		dprint("INIT::TRENCH C");
		set_broadsword_respawns ( true );
////		SetSkyObjectOverride("m90_trench_sky");
		
		
		//object_create_folder(dm_trench_c);
		object_create_folder(crs_trench_c);
		//object_create_folder(trench_c_ants);
		//thread(f_death_beam_damage(tv_trench_c_longbeam));
		//object_create(cr_tr_c_beam_left_a);
		//object_create(cr_tr_c_beam_left_b);
		wake( nar_flight_trench_c_init );
		wake( f_trench_c_spawn_controller );
		wake ( f_trench_c_entry_save );
		sleep(5);

		thread(f_trench_c_cleanup());
		wake(f_trench_c_entryblock_wait);
		wake(f_trench_c_entryblock_wait_2);
		wake( f_trench_c_exitblock_wait );

		
		wake(f_trench_c_init_tower_wait);
		wake(f_trench_c_containers);
		wake ( f_trench_c_tun_a_lock_wait );
//		wake ( f_trench_c_tun_b_lock_wait );

		wake( f_trench_c_side_walls );
		
		//wake ( f_trench_c_turrets_end_wait );
		garbage_collect_now();

		sleep( 60 );
		thread( f_trench_cd_trans_init() );
		//thread( f_weapon_boost_tutorial() );
		wake( f_transition_cd_doors_wait );
		
		thread( f_death_orb_damage(tv_trench_c_gate, cr_tc_lock_intro_1) );
		thread( f_death_orb_damage(tv_trench_c_intro_left, cr_tc_intro_left) );
		thread( f_death_orb_damage(tv_trench_c_intro_right, cr_tc_intro_right) );
			sleep(5);
			
		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end			
		
end

script static void f_trench_c_cleanup()

	
	sleep_until ( volume_test_players(tv_trench_c_cleanup) or b_ForceCleanup == true, 1);	

	//object_destroy_folder(dm_trench_c);
	object_destroy_folder(crs_trench_c);
	//object_destroy_folder(trench_c_ants);
	b_trench_c_complete = TRUE;
	ai_erase( sq_for_tr_c_turrets_beg );
	ai_erase( sq_for_tr_c_turrets_mid );
	ai_erase( sq_for_tr_c_turrets_mid_joined );
	ai_erase( sq_for_tr_c_turrets_end );
	ai_erase( sq_for_tr_c_turrets_trans );
	wake ( f_trench_c_device_cleanup );
	f_unblip_flag( flag_trench_c_under );
		dprint("CLEANUP::: trench c");

end


script dormant f_trench_c_entry_save()
	sleep_until ( volume_test_players(tv_trench_c_entry_save) , 1);	
		
		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end		

end




script dormant f_trench_c_side_walls()
	device_set_position_track( maya_trench_c_mid_side_a, 'any:idle', 0.0 );
	device_set_position_track( maya_trench_c_mid_side_b, 'any:idle', 0.0 );
	device_animate_position ( maya_trench_c_mid_side_a, 1, 0, 0.1, 0.1, TRUE);
	device_animate_position ( maya_trench_c_mid_side_b, 1, 0, 0.1, 0.1, TRUE);

end

script dormant f_trench_c_spawn_controller()


	sleep_until ( volume_test_players(tv_trench_c_spawn_beg) , 1);
		ai_place( sq_for_tr_c_turrets_beg );
		ai_place( sq_for_tr_c_turr_a );
	sleep_until ( volume_test_players(tv_trench_c_spawn_mid) , 1);	
		ai_place( sq_for_tr_c_turrets_mid );
		ai_place( sq_for_tr_c_turrets_mid_joined );
		sleep(1);

		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end

	sleep_until ( volume_test_players(tv_trench_c_spawn_end) , 1);	
		ai_erase( sq_for_tr_c_turrets_beg );
		sleep(3);
		ai_erase( sq_for_tr_c_turr_a );
		ai_place( sq_for_tr_c_turrets_end );
		f_unblip_flag(flag_trench_c_under);
	sleep_until ( volume_test_players(tv_trench_c_spawn_trans) , 1);	
		ai_erase( sq_for_tr_c_turrets_mid );
		sleep(3);
		ai_place( sq_for_tr_c_turrets_trans );
end





script dormant f_trench_c_init_tower_wait()

		//thread( cr_tc_tower_1->f_wait_destruction( cr_tc_lock_1 ) );
		//thread( cr_tc_tower_2->f_wait_destruction( cr_tc_lock_2 ) );
		//thread( cr_tc_tower_3->f_wait_destruction( cr_tc_lock_3 ) );

		//thread( cr_tc_tower_5->f_wait_destruction( cr_tc_lock_5 ) );
		//thread( cr_tc_tower_6->f_wait_destruction( cr_tc_lock_6 ) );
		//thread( cr_tc_tower_7->f_wait_destruction( cr_tc_lock_7 ) );	
	sleep(1);

end

script dormant f_trench_c_turrets_end_wait()
	//sleep_until( object_get_health(cr_tc_lock_7 ) <= 0, 1 );
		sleep(3);
	
		//f_trench_c_turr_end_destroy();
				
end


script static void f_trench_c_turr_end_destroy()

	damage_object( ai_vehicle_get(sq_for_tr_c_turrets_mid_joined.1 ), "default" , 100000);
	damage_object( ai_vehicle_get(sq_for_tr_c_turrets_mid_joined.3 ), "default" , 100000);

	sleep(15);
	damage_object( ai_vehicle_get(sq_for_tr_c_turrets_mid_joined.2 ), "default" , 100000);
	damage_object( ai_vehicle_get(sq_for_tr_c_turrets_mid_joined.4 ), "default" , 100000);
	sleep(2);

end

//cr_tc_lock_7


script static void tc_overhead()
	wake(f_trench_c_containers);
end

script dormant f_trench_c_containers()
	sleep_until( object_valid(maya_trench_c_giant_container), 1 );
		device_set_position_track( maya_trench_c_giant_container, 'any:idle', 0.0 );

end

script dormant f_trench_c_entryblock_wait()



	device_set_position_track( maya_trench_c_intro_obstacle_rt, 'any:idle', 0.0 );

		
	sleep_until(object_get_health(cr_tc_lock_intro_1) <= 0, 1);
		sleep(3);
		device_animate_position( maya_trench_c_intro_obstacle_rt,2.0, 1, 0.1, 0.0, TRUE );

		
end

script dormant f_trench_c_entryblock_wait_2()

		
	sleep_until(object_get_health( cr_tc_lock_turrets_a_1 ) <= 0, 1);
			thread( f_trench_c_blip_under() );
	//sleep_until(object_get_health(cr_tc_lock_turrets_a_2) <= 0, 1);
		sleep(3);
		device_animate_position ( maya_trench_c_mid_side_a, 0.57, 1.0, 0.1, 0.1, TRUE);
		device_animate_position ( maya_trench_c_mid_side_b, 0.57, 1.0, 0.1, 0.1, TRUE);
		sleep_s(0.5);
		f_trench_c_turr_a_destroy();	
		sleep_s(1.25);
		device_animate_position ( maya_trench_c_mid_side_a, 0.9, 1.5, 0.1, 0.1, TRUE);
		device_animate_position ( maya_trench_c_mid_side_b, 0.9, 1.5, 0.1, 0.1, TRUE);
		//device_animate_position ( maya_trench_c_mid_side_a, 0.0, 0.5, 0.1, 0.1, TRUE);
		//device_animate_position ( maya_trench_c_mid_side_b, 0.0, 0.5, 0.1, 0.1, TRUE);
		//sleep_s(1);

end




script static void f_trench_c_turr_a_destroy()
	sleep( 3);
	//effect_new_at_ai_point ( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect,  ps_trench_c.splode_0 );

	//ai_erase( (sq_for_tr_c_turr_a) );
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_1 ), "default" , 100000);

	sleep(2);
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_2 ), "default" , 100000);
	//sleep(7);
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_3 ), "default" , 100000);
	//sleep(3);
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_4 ), "default" , 100000);
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_5 ), "default" , 100000);
	sleep(2);
	damage_object( ai_vehicle_get(sq_for_tr_c_turr_a.tur_a_6 ), "default" , 100000);

end

script static void f_trench_c_blip_under()
	f_blip_flag(flag_trench_c_under, "default");
	sleep_until ( volume_test_players(tv_trench_c_blip_under) or volume_test_players(tv_trench_c_spawn_mid), 1);	
			f_unblip_flag(flag_trench_c_under);
end


script dormant f_trench_c_exitblock_wait()

	device_set_position_track( maya_trench_c_intro_obs_end_rt, 'any:idle', 0.0 );
	device_set_position_track( maya_trench_c_intro_obs_end_lt, 'any:idle', 0.0 );

		
	device_animate_position( maya_trench_c_intro_obs_end_rt, 0.75, 0, 0.1, 0.0, TRUE );
	device_animate_position( maya_trench_c_intro_obs_end_lt, 0.75, 0, 0.1, 0.0, TRUE );
	sleep_until (volume_test_players( tv_trench_c_probes ), 1);	
	//f_blip_flag( flag_tr_c_destroy, "neutralize" );
	sleep_until(object_get_health(cr_tc_lock_end) <= 0, 1);
		sleep(3);
		device_animate_position( maya_trench_c_intro_obs_end_rt,1, 2, 0.1, 0.0, TRUE );
		device_animate_position( maya_trench_c_intro_obs_end_lt, 1, 2, 0.1, 0.0, TRUE );	
		//f_unblip_flag( flag_tr_c_destroy );	
end




script dormant f_trench_c_tun_a_lock_wait()
	
	sleep_until( object_get_health( cr_tc_lock_end ) <= 0, 1);
		//sleep(3);
		//object_move_by_offset(so_maya_trench_c_obs_08 , 0.33, 0,20,0);		
end





script static void f_trench_cd_trans_init()

	//sleep_until( current_zone_set_fully_active() >= s_trench_c_idx, 1 );
	sleep_until (volume_test_players(tv_trench_c_probes), 1);	
		dprint("f_trench_e_trans_init");
		sleep_until( object_valid(maya_tr_d_molars_1) and object_valid(maya_tr_d_molars_2) ,1);
		device_set_position_track( maya_tr_d_molars_1, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_d_molars_2, 'any:idle', 0.0 );
		sleep(5);
		device_animate_position( maya_tr_d_molars_1, 1.0, 0.1, 0.1, 0.0, TRUE );
		device_animate_position( maya_tr_d_molars_2, 1.0, 0.1, 0.1, 0.0, TRUE );
	sleep_until (volume_test_players(tv_trench_cd_trans_1), 1);	
		device_animate_position( maya_tr_d_molars_1, 0.0, 1.0, 0.1, 0.0, TRUE );	
	sleep_until (volume_test_players(tv_trench_cd_trans_2), 1);	
		device_animate_position( maya_tr_d_molars_2, 0.0, 1.0, 0.1, 0.0, TRUE );
end


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRANSITION CD
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
//		sleep_until( object_valid( maya_tr_bc_tran_dr_1_outer), 1);
//		thread( f_trench_door_close_setup( maya_tr_bc_tran_dr_1_outer, 12, TRUE,  4, tv_trench_b_door_1 , kill_trench_b_tv) );
//maya_tr_cd_transition_door_1
//maya_tr_trans_cd_door_4

script dormant f_transition_cd_doors_wait()
		sleep_until( object_valid( maya_tr_cd_transition_door_1), 1);
			thread( f_trench_door_close_setup( maya_tr_cd_transition_door_1, 12, TRUE,  6, tv_trench_c_spawn_trans , kill_trench_c_tv) );
		sleep_until( object_valid( maya_tr_trans_cd_door_4), 1);
			thread( f_trench_door_close_setup( maya_tr_trans_cd_door_4, 9, TRUE,  6, tv_trench_cd_exit_door , kill_trans_cd_1) );
end

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRENCH D
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

global boolean b_trench_d_active = FALSE;

script dormant f_trench_d_init()


	sleep_until (volume_test_players(tv_trench_d_init), 1);	
		dprint("INIT:::TRENCH D");
		set_broadsword_respawns ( true );
////		SetSkyObjectOverride("m90_trench_sky");
		object_create_folder(crs_trench_d);
		thread( f_trench_e_trans_init() );
		wake(f_trench_d_chomp_molars_wait);
		wake(f_stomp_molars_wait);

//// Death Beam Enabling
		thread(f_death_beam_damage(tv_cr_td_beam_1));
		thread(f_death_beam_damage(tv_cr_td_beam_1b));
		thread(f_death_beam_damage(tv_cr_td_beam_2));
		thread(f_death_beam_damage(tv_cr_td_beam_2b));
		thread(f_death_beam_damage(tv_cr_td_beam_2c));
		thread(f_death_beam_damage(tv_cr_td_beam_3));
		thread(f_death_beam_damage(tv_cr_td_beam_4));
		thread(f_death_beam_damage(tv_cr_td_beam_4b));
		thread(f_death_beam_damage(tv_cr_td_beam_5));
		
		thread (f_trench_d_save_prevention());
		
		wake( nar_flight_trench_d_init );
		thread(f_trench_d_cleanup());
		b_trench_d_active = TRUE;
		sleep(1);
		wake( f_transition_de_doors_wait );
		garbage_collect_now();
		sleep(1);

		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end

end

script static void f_trench_d_save_prevention()
	//this is to avoid death loops in the laser field
	
	repeat
	
		if 
		volume_test_players (tv_not_safe_to_save_1) or 
		volume_test_players (tv_not_safe_to_save_2) or 
		volume_test_players (tv_not_safe_to_save_3) or 
		volume_test_players (tv_not_safe_to_save_4) or 
		volume_test_players (tv_not_safe_to_save_5) or 
		volume_test_players (tv_not_safe_to_save_6)
		then
	
			game_save_cancel();
		
		else
		
			sleep (1);
			
		end		
	
	until (b_trench_d_active == FALSE);
	
end

script static void f_trench_d_cleanup()

	
	sleep_until ( volume_test_players(tv_trench_d_cleanup) or b_ForceCleanup == true, 1);	
		ai_erase(sq_for_tr_d_turrets_1);
		ai_erase(sq_for_tr_d_turrets_2);
		ai_erase(sq_for_tr_d_turrets_3);
		ai_erase(sq_for_tr_d_turrets_4);
		ai_erase(sq_for_tr_d_turrets_5);
		b_trench_d_complete = TRUE;
		dprint("CLEANUP::: trench D");
		object_destroy_folder(crs_trench_d);
		object_destroy_folder(crs_trench_d_special);
		wake ( f_trench_d_device_cleanup );
		b_trench_d_active = FALSE;
end




script dormant f_trench_d_chomp_molars_wait()
	sleep_until (volume_test_players(tv_trench_d_teeth), 1);
		thread(f_chomp_molars());
end

global short s_MOLAR_MOVE_DISTANCE_UP = 30;
global short s_MOLAR_MOVE_DISTANCE_DOWN = -30;

script dormant f_stomp_molars_wait()
	device_set_position_track( dm_maya_tr_d_beamobj_1, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_beamobj_2, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_beamobj_3, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_beamobj_4, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_beamobj_5, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_beamobj_6, 'any:idle', 0.0 );
	device_animate_position( dm_maya_tr_d_beamobj_1, 0.80, 0, 0.0, 1, TRUE );
	device_animate_position( dm_maya_tr_d_beamobj_2, 0.60, 0, 0.0, 1, TRUE );
	sleep(5);
	device_animate_position( dm_maya_tr_d_beamobj_3, 0.55, 0, 0.1, 1, TRUE );
	device_animate_position( dm_maya_tr_d_beamobj_4, 0.85, 0, 0.1, 1, TRUE );	
	sleep(5);
	device_animate_position( dm_maya_tr_d_beamobj_5, 0.7, 0, 0.1, 1, TRUE );
	device_animate_position( dm_maya_tr_d_beamobj_6, 0.7, 0, 0.1, 1, TRUE );	
	sleep_until (volume_test_players(tv_trench_d_blockers), 1);	
		f_stomp_molars();
end



script static void f_stomp_molars()

	sleep(80);
	//object_create(cr_td_beam_1);
	//object_create(cr_td_beam_1b);
	//thread(f_trench_d_beam_mover( cr_td_beam_1, 7, 25, false ));
	//thread(f_trench_d_beam_mover( cr_td_beam_1b, 7, 25, false));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_1_left, 7, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_1_right, 7, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_1b_left, 7, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_1b_right, 7, 25, false ));
	sleep(15);
	//object_create(cr_td_beam_2);
	//object_create(cr_td_beam_2b);
	//object_create(cr_td_beam_2c);
	//thread(f_trench_d_beam_mover( cr_td_beam_2, 3.0, 25,  false));
	//thread(f_trench_d_beam_mover( cr_td_beam_2b, 3.0, 25,  false ));
	//thread(f_trench_d_beam_mover( cr_td_beam_2c, 3.0, 25,  false  ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2_left, 3.0, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2_right, 3.0, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2b_right, 3.0, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2b_left, 3.0, 25, false ));	
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2c_left, 3.0, 25, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_2c_right, 3.0, 25, false ));		
	sleep(15);	
	
	//object_create(cr_td_beam_3);
	//object_create(cr_td_beam_4);
	//object_create(cr_td_beam_4b);
	
	//thread(f_trench_d_beam_mover( cr_td_beam_3, 1, 10, false ));
	//thread(f_trench_d_beam_mover( cr_td_beam_4b, 1, 10, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_3_left, 1, 10, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_3_right, 1, 10, false ));	
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_4b_left, 1, 10, false ));
	thread(f_trench_d_beam_mover( cr_tr_d_beamhole_4b_right, 1, 10, false ));	
	//object_create(cr_td_beam_5);
	//thread(f_trench_d_beam_mover( cr_td_beam_3, 5 ));		
end



script static void f_trench_d_beam_mover( object_name o, real time, real dist, boolean b_oddmove)
	repeat
		if b_oddmove then
			object_move_by_offset( o, time, 0,dist,0);
			object_move_by_offset( o, time, 0,-(dist),0);		
		
		else
			object_move_by_offset( o, time, 0,0,dist);
			object_move_by_offset( o, time, 0,0,-(dist));

		end
	//sleep(1);

	until ( b_trench_d_active == FALSE , 1 );

end


script static void f_chomp_molars()
	local real s_A_TIME = 1.4;
	device_set_position_track( dm_maya_tr_d_molars_1, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_molars_2, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_molars_3, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_molars_4, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_molars_5, 'any:idle', 0.0 );
	device_set_position_track( dm_maya_tr_d_molars_6, 'any:idle', 0.0 );
	
	

	device_animate_position( dm_maya_tr_d_molars_2, 1.0, s_A_TIME, 0.1, 0.0, TRUE );

	sleep(15);
	device_animate_position( dm_maya_tr_d_molars_3, 1.0, s_A_TIME, 0.1, 0.2, TRUE );
	thread(f_trench_d_spawn_turret_squad( sq_for_tr_d_turrets_1 ));
	sleep(15);
	device_animate_position( dm_maya_tr_d_molars_4, 1.0, s_A_TIME, 0.1, 0.2, TRUE );
	thread(f_trench_d_spawn_turret_squad( sq_for_tr_d_turrets_2 ));
	sleep(15);
	device_animate_position( dm_maya_tr_d_molars_5, 1.0, s_A_TIME, 0.1, 0.2, TRUE );
	thread(f_trench_d_spawn_turret_squad( sq_for_tr_d_turrets_3 ));
	sleep(15);
	device_animate_position( dm_maya_tr_d_molars_6, 1.0, s_A_TIME, 0.1, 0.2, TRUE );
	thread(f_trench_d_spawn_turret_squad( sq_for_tr_d_turrets_4 ));
	sleep(15);
	device_animate_position( dm_maya_tr_d_molars_1, 1.0, s_A_TIME, 0.1, 0.2, TRUE );
	thread(f_trench_d_spawn_turret_squad( sq_for_tr_d_turrets_5 ));
	
	//sleep(20);
	//ai_place( sq_for_tr_d_turrets );
end


script static void f_trench_d_spawn_turret_squad( ai squad )
	sleep(30);
	ai_place( squad );
	//sleep(1);
end




script dormant f_trench_e_trans_init_tower_wait()
		object_create( cr_tr_e_trans_lock_01 );
		object_create( cr_tr_e_trans_lock_02 );
		object_create( cr_tr_e_trans_lock_03 );
//		object_create( cr_tr_e_trans_lock_04 );
		sleep(5);
end






script static void f_trench_e_trans_init()

		sleep_until( volume_test_players(tv_trans_04_e_init), 1 );
		dprint("f_trench_e_trans_init");
		device_set_position_track( maya_tr_de_molars_1, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_de_molars_2, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_de_molars_3, 'any:idle', 0.0 );
		//device_set_position_track( maya_tr_de_molars_4, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_de_molars_5, 'any:idle', 0.0 );
		//device_set_position_track( maya_tr_de_molars_6, 'any:idle', 0.0 );
		device_set_position_track( maya_tr_de_molars_7, 'any:idle', 0.0 );
		object_create( cr_tr_e_trans_lock_01 );
		object_create( cr_tr_e_trans_lock_02 );
		object_create( cr_tr_e_trans_lock_03 );
		//object_create( cr_tr_e_trans_lock_04 );
		object_create( cr_tr_e_trans_lock_05 );
		//object_create( cr_tr_e_trans_lock_06 );
		object_create( cr_tr_e_trans_lock_07 );
		sleep(5);
		wake( nar_flight_trench_e_init );
		
		thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_01, maya_tr_de_molars_1, FALSE ) );
		thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_02, maya_tr_de_molars_2, FALSE ) );
		thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_03, maya_tr_de_molars_3, FALSE ) );
		//thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_04, maya_tr_de_molars_4, FALSE ) );
		thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_05, maya_tr_de_molars_5, FALSE ) );
		//thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_06, maya_tr_de_molars_6, FALSE ) );
		thread( f_trench_de_molar_wait( cr_tr_e_trans_lock_07, maya_tr_de_molars_7, FALSE ) );
end

script static void f_trench_de_molar_wait(object_name lock, device molar, boolean b_reverse )
	sleep_until( object_get_health(lock) <= 0 , 1);
		if b_reverse then
			device_animate_position( molar, 0.0, 0.5, 0.1, 0.0, TRUE );
		else
			device_animate_position( molar, 1.0, 0.75, 0.1, 0.0, TRUE );
		end
		//dprint("open molar");
end

script static void f_move_molar_up(object molar)
	object_move_by_offset( molar, 1.15, 0,0,s_MOLAR_MOVE_DISTANCE_UP);
end

script static void f_move_molar_down(object molar)
	object_move_by_offset( molar, 1.15, 0,0,s_MOLAR_MOVE_DISTANCE_DOWN);
end


script static void f_move_molar_down_r(object molar, short distance, real r_time)
	object_move_by_offset( molar, r_time, 0,0,distance);
end

script static void f_move_molar_in_r(object molar, short distance, real r_time)
	object_move_by_offset( molar, r_time, distance,0,0);
end


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRANSITION DE
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
script dormant f_transition_de_doors_wait()
		object_create( dm_trench_de_exit_door );
		
		thread( f_death_orb_damage(tv_trans_de_gate_a, cr_tr_e_trans_lock_01) );
		thread( f_death_orb_damage(tv_trans_de_gate_b, cr_tr_e_trans_lock_02) );
		thread( f_death_orb_damage(tv_trans_de_gate_c, cr_tr_e_trans_lock_03) );
		thread( f_death_orb_damage(tv_trans_de_gate_d, cr_tr_e_trans_lock_05) );
		thread( f_death_orb_damage(tv_trans_de_gate_e, cr_tr_e_trans_lock_07 ) );
		sleep_until( object_valid( maya_tr_trans_de_door_1), 1);
			thread( f_trench_door_close_setup( maya_tr_trans_de_door_1, 9, TRUE,  6, tv_trench_d_door , kill_trench_d) );
		sleep_until( object_valid( dm_trench_de_exit_door), 1);
			thread( f_trench_door_close_setup( dm_trench_de_exit_door, 9, TRUE,  5, tv_trench_d_cleanup , kill_trans_de_1) );
end


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
// TRENCH E
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

//global boolean b_trench_e_door_towers_alive = TRUE;

script dormant f_trench_e_init()

	sleep_until (volume_test_players(tv_trench_e_init), 1);	
		dprint("INIT::: trench e");
		//b_Eye_Complete = FALSE;
		set_broadsword_respawns ( true );
////		SetSkyObjectOverride("m90_trench_sky");
		wake(f_trench_e_eye_gate_wait);
		thread(f_trench_e_cleanup());
		wake(f_trench_e_save_wait);

		
		//object_create( dm_trench_e_gate );
		object_create_folder(crs_trench_e);
		//object_create(dm_eye_gate);
		
		//wake(f_eye_door_1_init);
		sleep(1);

		//object_create( dm_tr_e_tower_01 );
		//object_create( dm_tr_e_tower_02 );
		wake( f_trench_e_rail_guard_wait );
		

		sleep(5);

		garbage_collect_now(); 
		sleep(1);
		
		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end
		
		sleep(5);
		//clear_all_text(); 
		
		//thread(f_trench_c_chainsaw());
end

script static void f_trench_e_cleanup()

	
	sleep_until (volume_test_players( tv_eye_close ) or b_ForceCleanup == true, 1);	
		dprint("CLEANUP::: trench e");
		b_trench_e_complete = TRUE;
		//object_destroy( dm_tr_e_tower_01 );
		//object_destroy( dm_tr_e_tower_02 );

		object_destroy_folder(crs_trench_e);
		
		object_destroy( dm_trench_de_exit_door );
//		object_destroy( dm_tr_e_trans_tower_01 );
	//	object_destroy( dm_tr_e_trans_tower_02 );
	//	object_destroy( dm_tr_e_trans_tower_03 );
	//	object_destroy( dm_tr_e_trans_tower_04 );
		object_destroy( cr_tr_e_trans_lock_01 );
		object_destroy( cr_tr_e_trans_lock_02 );
		object_destroy( cr_tr_e_trans_lock_03 );
//		object_destroy( cr_tr_e_trans_lock_04 );		
		wake ( f_trench_e_device_cleanup );
//		thread(f_open_eye_door_1());
end

script dormant f_trench_e_save_wait()
	sleep_until (volume_test_players(tv_trench_e_save), 1);
		dprint("SAVE::: Trench E");
		sleep(1);

		if is_skull_active(skull_iron) then
			dprint ("iron skull on, no save");
		else	
		 	f_m90_game_save_no_timeout();
		end

end





script dormant f_trench_e_rail_guard_wait()
	device_set_position_track( maya_tr_e_finger_r_1, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_r_2, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_r_3, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_r_4, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_l_1, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_l_2, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_l_3, 'any:idle', 0.0 );
	device_set_position_track( maya_tr_e_finger_l_4, 'any:idle', 0.0 );

	sleep(2);

	sleep_until (volume_test_players(tv_trench_e_guard), 1);

		device_animate_position( maya_tr_e_finger_r_4, 1, 1.5, 0.1, 0.0, TRUE );
		device_animate_position( maya_tr_e_finger_l_4, 1, 1.5, 0.1, 0.0, TRUE );	
		sleep(30);		
		device_animate_position( maya_tr_e_finger_r_3, 1, 1.5, 0.1, 0.0, TRUE );
		device_animate_position( maya_tr_e_finger_l_3, 1, 1.5, 0.1, 0.0, TRUE );
		sleep(30);		
		device_animate_position( maya_tr_e_finger_r_2, 1, 1.5, 0.1, 0.0, TRUE );
		device_animate_position( maya_tr_e_finger_l_2, 1, 1.5, 0.1, 0.0, TRUE );
		sleep(30);
		device_animate_position( maya_tr_e_finger_r_1, 1, 1.5, 0.1, 0.0, TRUE );
		device_animate_position( maya_tr_e_finger_l_1, 1, 1.5, 0.1, 0.0, TRUE );
end

script dormant f_trench_e_eye_gate_wait()

	
	device_set_position_track( maya_tr_e_gate_right, 'any:idle', 0.0 );	
	device_set_position_track( maya_tr_e_gate_left, 'any:idle', 0.0 );



	sleep_until (volume_test_players(tv_eye_gate), 1);

		//thread( f_weapon_boost_tutorial() );
		f_trench_e_eye_gate();
		//dprint("no gate for you");

end


script static void f_trench_e_eye_gate()
	//dprint("EYE GATE");

	//sleep(5);
	sleep_until( object_valid(maya_tr_e_gate_right) and object_valid(maya_tr_e_gate_left) ,1 );
	device_animate_position( maya_tr_e_gate_right, 0.15, 3, 0.1, 0.0, FALSE );
	device_animate_position( maya_tr_e_gate_left, 0.15, 3, 0.1, 0.0, FALSE );		
	//device_animate_position( dm_maya_eye_gate, 0.45, 3.0, 0.1, 0.0, TRUE );
	sleep_s(3);
	//device_animate_position( dm_maya_eye_gate, 0.9, 12, 0.1, 0.0, TRUE );
	if game_is_cooperative() and not difficulty_legendary() then
		device_animate_position( maya_tr_e_gate_right, 0.50, 7.5, 0.1, 0.0, FALSE );
		device_animate_position( maya_tr_e_gate_left, 0.50, 7.5, 0.1, 0.0, FALSE );	
		sleep_s(7.5);
	else
		device_animate_position( maya_tr_e_gate_right, 0.50, 3.5, 0.1, 0.0, FALSE );
		device_animate_position( maya_tr_e_gate_left, 0.50, 3.5, 0.1, 0.0, FALSE );	
		sleep_s(3.5);
	end
	//device_animate_position( dm_maya_eye_gate, 1.0, 5, 0.1, 0.0, TRUE );
	sleep_s(1);
	
	f_trench_activate_death_zone( kill_trench_e_tv, true );
end







///////////////////////////////////////////
// trench a turret command scripts
///////////////////////////////////////////

script command_script cs_scale_flight_ship()
	//dprint("scale banshee");
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , 4.0, 0);

	ai_set_clump ( ai_current_actor, 2 );
	ai_designer_clump_perception_range( 650 );
	//cs_force_combat_status (3);

	//cs_shoot ( TRUE, player0);

end

script command_script cs_turret_auto_target_init()
	//dprint("Scale up bro");
	//object_set_scale ( ai_vehicle_get ( ai_current_actor ), _TURRET_SCALE_SIZE, 0);
//	vehicle_hover ( ai_vehicle_get ( ai_current_actor ), TRUE); 

	ai_set_clump ( ai_current_actor, 1 );
	ai_designer_clump_perception_range( 650 );
	//cs_force_combat_status (3);
	ai_magically_see_object ( ai_current_actor , player0	);
	cs_shoot ( TRUE, player0);
end

script command_script cs_turret_generic_init()

	object_dissolve_from_marker( ai_vehicle_get ( ai_current_actor ), phase_in, fx_life_source );
	ai_set_clump ( ai_current_actor, 1 );
	ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
end

script command_script cs_turret_generic_init_hidden()


	ai_set_clump ( ai_current_actor, 1 );
	ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	object_hide(ai_vehicle_get(ai_current_actor), TRUE);
end

script command_script cs_turret_init_a_1()

	object_dissolve_from_marker( ai_vehicle_get ( ai_current_actor ), phase_in, fx_life_source );
	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_a.hita);

		sleep(45);
		cs_shoot_point(false, ps_trench_a.hita);
		//sleep_rand_s(0.75,1.5);

		cs_shoot_point(true, ps_trench_a.p2);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p2);
		//sleep_rand_s(0.75,1.5);
		
		cs_shoot_point(true, ps_trench_a.p3);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p3);
		//sleep_rand_s(0.75,1.5);
		
		cs_shoot_point(true, ps_trench_a.p0);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p0);
		
		
		cs_shoot_point(true, ps_trench_a.p6);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p6);
		
		cs_shoot_point(true, ps_trench_a.p7);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p7);
		
		cs_shoot_point(true, ps_trench_a.p8);
		sleep(45);
		cs_shoot_point(false, ps_trench_a.p8);
		sleep_rand_s(0.75,1.5);
	until( b_trench_a_complete ,5 );
	sleep_forever();

end


script command_script cs_turret_init_a_2()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_a.hitb);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.hitb);
		sleep_rand_s(0.75,1.5);

		cs_shoot_point(true, ps_trench_a.p3);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p3);
		sleep_rand_s(0.75,1.5);
		
		cs_shoot_point(true, ps_trench_a.p2);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p2);
		sleep_rand_s(0.75,1.5);
		
		cs_shoot_point(true, ps_trench_a.p1);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p1);
		sleep_rand_s(0.75,1.5);
	until( b_trench_a_complete ,1 );
	sleep_forever();

end


script command_script cs_turret_init_a_3()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_a.p5);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p5);
		sleep_rand_s(1.5,2);

		cs_shoot_point(true, ps_trench_a.p4);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p4);
		sleep_rand_s(1.5,2);
		

	until( b_trench_a_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_a_4()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_a.p4);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p4);
		sleep_rand_s(1.5,2);

		cs_shoot_point(true, ps_trench_a.p5);
		sleep(30);
		cs_shoot_point(false, ps_trench_a.p5);
		sleep_rand_s(1.5,2);
		
	until( b_trench_a_complete ,1 );
	sleep_forever();

end




script command_script cs_turret_init_b_1()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_b.p0);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p0);
		sleep_rand_s(1.5,2);

		cs_shoot_point(true, ps_trench_b.p1);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p1);
		sleep_rand_s(1.5,2);
		
		cs_shoot_point(true, ps_trench_b.p2);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p2);
		sleep_rand_s(1.5,2);		
	until( b_trench_b_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_b_2()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_b.p1);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p1);
		sleep_rand_s(1.5,2);

		cs_shoot_point(true, ps_trench_b.p2);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p2);
		sleep_rand_s(1.5,2);
		
		cs_shoot_point(true, ps_trench_b.p0);
		sleep(30);
		cs_shoot_point(false, ps_trench_b.p0);
		sleep_rand_s(1.5,2);		
		
	until( b_trench_b_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_b_3()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_b.p5);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p5);
		sleep_rand_s(0.5,1);

		cs_shoot_point(true, ps_trench_b.p6);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p6);
		sleep_rand_s(0.5,1);
		
	until( b_trench_b_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_b_4()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_b.p3);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p3);
		sleep_rand_s(0.5,1);

		cs_shoot_point(true, ps_trench_b.p4);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p4);
		sleep_rand_s(0.5,1);
		
	until( b_trench_b_complete ,1 );
	sleep_forever();

end

//mid turret
script command_script cs_turret_init_b_5()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_b.p7);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p7);
		sleep_rand_s(0.2,0.3);

		cs_shoot_point(true, ps_trench_b.p8);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p8);
		sleep_rand_s(0.2,0.3);
		
		cs_shoot_point(true, ps_trench_b.p9);
		sleep(20);
		cs_shoot_point(false, ps_trench_b.p9);
		sleep_rand_s(0.2,0.3);	
		
	until( b_trench_b_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_c_1()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_c.p4);
		sleep(20);
		cs_shoot_point(false, ps_trench_c.p4);
		//sleep_rand_s(0.5,0.5);
		sleep(30);

		cs_shoot_point(true, ps_trench_c.p5);
		sleep(20);
		cs_shoot_point(false, ps_trench_c.p5);
		sleep(30);
		//sleep_rand_s(0.5,0.5);
		
	until( b_trench_c_complete ,1 );
	sleep_forever();

end

script command_script cs_turret_init_c_2()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_c.p5);
		sleep(20);
		cs_shoot_point(false, ps_trench_c.p5);
		//sleep_rand_s(0.5,0.5);
		sleep(30);

		cs_shoot_point(true, ps_trench_c.p4);
		sleep(20);
		cs_shoot_point(false, ps_trench_c.p4);
		sleep(30);
		//sleep_rand_s(0.5,0.5);
		
	until( b_trench_c_complete ,1 );
	sleep_forever();

end
script command_script cs_turret_init_transcd_1()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_d.p7);
		sleep(20);
		cs_shoot_point(false, ps_trench_d.p7);
		//sleep_rand_s(0.5,0.5);
		sleep(30);

		cs_shoot_point(true, ps_trench_d.p9);
		sleep(20);
		cs_shoot_point(false, ps_trench_d.p9);
		sleep(30);
		//sleep_rand_s(0.5,0.5);
		
	until( b_trench_d_complete ,1 );
	sleep_forever();

end


script command_script cs_turret_init_transcd_2()


	ai_set_clump ( ai_current_actor, 1 );
		ai_designer_clump_perception_range( 650 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
	repeat
		cs_shoot_point(true, ps_trench_d.p10);
		sleep(20);
		cs_shoot_point(false, ps_trench_d.p10);
		sleep(30);
		//sleep_rand_s(0.5,0.5);

		cs_shoot_point(true, ps_trench_d.p8);
		sleep(20);
		cs_shoot_point(false, ps_trench_d.p8);
		sleep(30);
		//sleep_rand_s(0.5,0.5);
		
	until( b_trench_d_complete ,1 );
	sleep_forever();

end





script command_script cs_turret_generic_eye_init()


	ai_set_clump ( ai_current_actor, 1 );
	ai_designer_clump_perception_range( 500 );
	object_dissolve_from_marker( ai_vehicle_get ( ai_current_actor ), phase_in, fx_life_source );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ) , _TURRET_SCALE_SIZE, 0);
end




script command_script cs_trench_d_fire()

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), _TURRET_SCALE_SIZE, 0);
	cs_shoot_point (TRUE, ai_nearest_point ( ai_current_actor,  ps_trench_d));

	object_dissolve_from_marker( ai_vehicle_get ( ai_current_actor ), phase_in, fx_life_source );
	ai_set_clump ( ai_current_actor, 3 );
	ai_designer_clump_perception_range( 800 );
end




script static void f_trench_activate_death_zone( trigger_volume tv , boolean b_on)

	if b_on then
		kill_volume_enable (tv);
		dprint("activating death volume");
	else
		kill_volume_disable (tv);
		dprint("DE-activating death volume");
	end

end






script static void f_trench_door_close_setup(device dm, real r_time, boolean b_full_close, real r_full_close_time, trigger_volume tv, trigger_volume dv)

	device_set_position_track( dm, 'any:idle', 0.0 );
	sleep_until( volume_test_players( tv ) , 1);
		if b_full_close then
			if r_time > 0.1 then			
				device_animate_position( dm, 0.7, r_time  , 0.1, 0.0, TRUE );	
				sleep( 30 * r_time );
				if volume_test_players( dv ) then
					game_save_cancel();
				end
				sleep(1);
				
				if r_full_close_time > 0 then
					device_animate_position( dm, 1.0, r_full_close_time, 0.1, 0.0, TRUE );	
					sleep_s( r_full_close_time );
				else
					device_animate_position( dm, 1.0, 6, 0.1, 0.0, TRUE );	
					sleep_s( 6 );
				end
				
			else
				device_animate_position( dm, 1.0, r_time , 0.1, 0.0, TRUE );
			end
			
			if dv != TV_NONE then
				
				sleep_s(3);
				f_trench_activate_death_zone( dv, true );
			end
		else
			device_animate_position( dm, 0.7, r_time, 0.1, 0.0, TRUE );	
		end
	
end


script dormant f_trench_a_device_cleanup()
	dprint("a device cleanup");
	object_destroy( dm_trench_a_door_1 );
	object_destroy( maya_tr_a_end_0_left );
	object_destroy( maya_tr_a_end_0_right );
	object_destroy( maya_tr_a_end_1_left );
	object_destroy( maya_tr_a_end_1_right );
	object_destroy( maya_tr_a_end_2_left );
	object_destroy( maya_tr_a_end_2_right );
	object_destroy( maya_tr_a_end_4_left );
	object_destroy( maya_tr_a_end_4_right );
	object_destroy( maya_tr_a_container_1 );
	object_destroy( maya_tr_a_container_2 );
	object_destroy( maya_tr_a_container_3 );
	object_destroy( maya_tr_a_container_4 );
	object_destroy( maya_tr_a_pg_b_left );
	object_destroy( maya_tr_a_pg_b_right );
	object_destroy( maya_tr_a_pg_a_right );
	object_destroy( maya_tr_a_pg_a_left );
	object_destroy( maya_tr_a_tun_a_1 );
	object_destroy( maya_tr_a_tun_a_2 );
	object_destroy( maya_tr_a_gate_1 );

	object_destroy( maya_tr_a_b1_a_left );
	object_destroy( maya_tr_a_b1_a_right );
	object_destroy( maya_tr_a_b1_b_left );
	object_destroy( maya_tr_a_b1_b_right );
	object_destroy( maya_tr_a_end_4_left );
	object_destroy( maya_tr_a_end_3_left );
	object_destroy( maya_tr_a_end_2_left );
	object_destroy( maya_tr_a_end_1_left );
	object_destroy( maya_tr_a_end_0_left );
	object_destroy( maya_tr_a_end_4_right );
	object_destroy( maya_tr_a_end_3_right );
	object_destroy( maya_tr_a_end_2_right );
	object_destroy( maya_tr_a_end_1_right );
	object_destroy( maya_tr_a_end_0_right );

end

script dormant f_trench_b_device_cleanup()
	dprint("b device cleanup");

	object_destroy( dm_trench_a_door_1 );
	object_destroy( maya_tr_b_teeth_rise );
	object_destroy( maya_tr_b_wall_guard_2 );
	object_destroy( maya_tr_b_wall_guard_3 );
	object_destroy( maya_tr_b_wall_guard_4 );
	object_destroy( maya_tr_b_wall_guard_5 );
	object_destroy( maya_tr_b_wall_guard_6 );
	object_destroy( maya_tr_b_wall_guard_7 );
	object_destroy( dm_trans_1_probe_1 );
end

script dormant f_trench_c_device_cleanup()
	dprint("c device cleanup");
	object_destroy( maya_tr_bc_tran_dr_1_inner );
	object_destroy( maya_tr_bc_tran_dr_1_outer );
	object_destroy( maya_trench_c_mid_side_b );
	object_destroy( maya_trench_c_mid_side_a );
	object_destroy( maya_trench_c_intro_obstacle_rt );
	object_destroy( maya_trench_c_giant_container );
	object_destroy( maya_trench_c_intro_obs_end_rt );
	object_destroy( maya_trench_c_intro_obs_end_lt );


end

script dormant f_trench_d_device_cleanup()
	dprint("d device cleanup");
	object_destroy( dm_maya_tr_d_beamobj_1 );
	object_destroy( dm_maya_tr_d_beamobj_2 );
	object_destroy( dm_maya_tr_d_beamobj_3 );
	object_destroy( dm_maya_tr_d_beamobj_4 );
	object_destroy( dm_maya_tr_d_beamobj_5 );
	object_destroy( dm_maya_tr_d_beamobj_6 );

	object_destroy( dm_maya_tr_d_molars_1 );
	object_destroy( dm_maya_tr_d_molars_2 );
	object_destroy( dm_maya_tr_d_molars_3 );
	object_destroy( dm_maya_tr_d_molars_4 );
	object_destroy( dm_maya_tr_d_molars_5 );
	object_destroy( dm_maya_tr_d_molars_6 );
	object_destroy( maya_tr_d_molars_1  ); //trans cd
	object_destroy( maya_tr_d_molars_2 );  //trans cd
end

script dormant f_trench_e_device_cleanup()
	dprint("e device cleanup");

	object_destroy( maya_tr_de_molars_1 );
	object_destroy( maya_tr_de_molars_2 );
	object_destroy( maya_tr_de_molars_3 );
	object_destroy( maya_tr_de_molars_5 );
	object_destroy( maya_tr_de_molars_7 );

	object_destroy( maya_tr_e_finger_r_1 );
	object_destroy( maya_tr_e_finger_r_2 );
	object_destroy( maya_tr_e_finger_r_3 );
	object_destroy( maya_tr_e_finger_r_4 );
	object_destroy( maya_tr_e_finger_l_1 );
	object_destroy( maya_tr_e_finger_l_2 );
	object_destroy( maya_tr_e_finger_l_3 );
	object_destroy( maya_tr_e_finger_l_4 );
	object_destroy( maya_tr_e_gate_right );
	object_destroy( maya_tr_e_gate_left );

end

script dormant f_trench_eye_device_cleanup()
	dprint("eye device cleanup");
	
end

script static void trench_a_editor()
	wake( f_trench_e_device_cleanup );
	wake( f_trench_b_device_cleanup );
	wake( f_trench_c_device_cleanup );
	wake( f_trench_d_device_cleanup );
end

script static void trench_b_editor()
	wake( f_trench_a_device_cleanup );
	wake( f_trench_e_device_cleanup );
	wake( f_trench_c_device_cleanup );
	wake( f_trench_d_device_cleanup );
end

script static void trench_c_editor()
	wake( f_trench_a_device_cleanup );
	wake( f_trench_e_device_cleanup );
	wake( f_trench_b_device_cleanup );
	wake( f_trench_d_device_cleanup );
end

script static void trench_d_editor()
	wake( f_trench_a_device_cleanup );
	wake( f_trench_b_device_cleanup );
	wake( f_trench_d_device_cleanup );
	wake( f_trench_e_device_cleanup );
end

script static void trench_e_editor()
	wake( f_trench_a_device_cleanup );
	wake( f_trench_b_device_cleanup );
	wake( f_trench_c_device_cleanup );
	wake( f_trench_d_device_cleanup );
end






global boolean b_trench_a_exit_wp = FALSE;
global boolean b_flight_player_0_wrong_way = FALSE;
global boolean b_flight_player_1_wrong_way = FALSE;
global boolean b_flight_player_2_wrong_way = FALSE;
global boolean b_flight_player_3_wrong_way = FALSE;
global boolean b_flight_wp_check_done = FALSE;
global cutscene_flag flag_flight_waypoint_goal = flag_tr_a_exit_wp;



script dormant f_flight_waypoint_goals()
	flag_flight_waypoint_goal = flag_tr_a_exit_wp;
	sleep_until ( volume_test_players(tv_trench_a_door_1 ) , 1);
		//b_trench_a_exit_wp = TRUE;

		f_blip_flag( flag_tr_a_exit_wp , "default" );
	sleep_until ( volume_test_players(tv_trench_a_door_1_shut ) , 1);
		thread(  f_flight_cleanup_goals() );
		flag_flight_waypoint_goal = flag_trans_ab_exit;
		f_unblip_flag( flag_tr_a_exit_wp );
	sleep_until ( volume_test_players( tv_trans_ab_exit ) , 1);
		thread(  f_flight_cleanup_goals() );		
 		flag_flight_waypoint_goal = flag_tr_b_exit_wp;
 		f_unblip_flag( flag_trans_ab_exit );
 	sleep_until ( volume_test_players(tv_trench_b_exit ), 1);			
 		thread(  f_flight_cleanup_goals() );
 		flag_flight_waypoint_goal = flag_trans_bc_exit;
 		f_unblip_flag( flag_tr_b_exit_wp );
 	//sleep_until ( volume_test_players(tv_trench_bc_door_2 ) , 1);		
 		//tv_trench_bc_door_2
 	sleep_until ( volume_test_players(tv_trans_bc_exit ) , 1);	 		
 		thread(  f_flight_cleanup_goals() );
 		flag_flight_waypoint_goal = flag_tr_c_exit;
 		f_unblip_flag( flag_trans_bc_exit ); 		
 	sleep_until ( volume_test_players(tv_trench_cd_trans_1 ), 1);	 
 		thread(  f_flight_cleanup_goals() );		
 		flag_flight_waypoint_goal = flag_trans_cd_exit;
 		f_unblip_flag( flag_tr_c_exit );
 		//f_unblip_flag( flag_tr_c_destroy );	
 	sleep_until ( volume_test_players(tv_trench_c_cleanup ), 1);	
 		thread(  f_flight_cleanup_goals() ); 		
 		flag_flight_waypoint_goal = flag_tr_d_exit_wp;
 		f_unblip_flag( flag_trans_cd_exit );
 	sleep_until ( volume_test_players(tv_trench_e_init ), 1);	 	
 		thread(  f_flight_cleanup_goals() );	
 		flag_flight_waypoint_goal = flag_trans_de_exit;
 		f_unblip_flag( flag_tr_d_exit_wp );
 	sleep_until ( volume_test_players(tv_trench_e_save ), 1);	
 		thread(  f_flight_cleanup_goals() ); 		
 		flag_flight_waypoint_goal = flag_tr_e_exit_wp;
 		f_unblip_flag( flag_trans_de_exit );
 	sleep_until ( volume_test_players(tv_trench_e_exit_wp ), 1);
 		thread(  f_flight_cleanup_goals() );	 		
 		flag_flight_waypoint_goal = flag_trans_ee_exit;
 		f_unblip_flag( flag_tr_e_exit_wp );
 	sleep_until ( volume_test_players(tv_open_eye_door_1 ), 1);	
 		thread(  f_flight_cleanup_goals() ); 		
 		flag_flight_waypoint_goal = flg_none;
 		f_unblip_flag( flag_trans_ee_exit );
 		sleep(60);
		thread(  f_flight_cleanup_goals() );
end

script static void f_flight_cleanup_goals()
		f_unblip_flag( flag_tr_a_exit_wp );
		f_unblip_flag( flag_trans_ab_exit );
		f_unblip_flag( flag_tr_b_exit_wp ); 
		f_unblip_flag( flag_trans_bc_exit ); 
		f_unblip_flag( flag_tr_c_exit );
		f_unblip_flag( flag_trans_cd_exit );
		f_unblip_flag( flag_tr_d_exit_wp );
 		f_unblip_flag( flag_trans_de_exit );
 		f_unblip_flag( flag_tr_e_exit_wp );
 		f_unblip_flag( flag_trans_ee_exit );
 		f_unblip_flag( flg_none );
 		
end

script dormant f_flight_setup_players_waypoints()
	b_flight_wp_check_done = FALSE;
	
	
	//DISABLED FOR NOW
//	thread( f_flight_direction_update() );
	if player_valid( player0() ) then
		thread( f_flight_waypoints( player0() ));
	end

	if player_valid( player1() ) then
		thread( f_flight_waypoints( player1() ));
	end
	
	if player_valid( player2() ) then
		thread( f_flight_waypoints( player2() ));
	end
	
	if player_valid( player3() ) then
		thread( f_flight_waypoints( player3() ));
	end		

	
end

script static void f_flight_waypoints( unit playa)
	local real cur_distance = 0;
	local real new_distance = 0;
	repeat
		if flag_flight_waypoint_goal != flg_none then
			if f_flight_is_going_backwards( playa, flag_flight_waypoint_goal ) then
					dprint("TURN AROUND");
					
									
					if not f_trench_get_turn_around_var( playa ) then		
						dprint("bliping trench goal");	
						if not b_flight_wp_check_done then	
									
							f_blip_flag( flag_flight_waypoint_goal , "default" );
							f_trench_set_turn_around_var(  playa, true );	
						else
							f_trench_set_turn_around_var(  playa, FALSE );
						end
					end
					
								
			else
				if f_trench_get_turn_around_var ( playa ) then
					f_trench_set_turn_around_var( playa, FALSE );
				end
			end

		end	
	until( b_flight_wp_check_done, 15 );	
	
	f_trench_set_turn_around_var( playa, FALSE );
	sleep(1);
	kill_script( f_flight_direction_update );
end


script static boolean f_flight_is_going_backwards(unit playa, cutscene_flag flag_g)
	local real cur_distance = 0;
	local real new_distance = 0;
	local boolean b_backwards = FALSE;
	cur_distance = objects_distance_to_flag ( playa, flag_g );
	//inspect( cur_distance );
	sleep(60);
	new_distance = objects_distance_to_flag ( playa, flag_g );		

	if new_distance - 60 > cur_distance then
		b_backwards = TRUE;
	end
	b_backwards;
end


script static void f_trench_set_turn_around_var( unit playa, boolean b_on)

	if playa == player0 then
		b_flight_player_0_wrong_way = b_on ; 		
	elseif playa == player1 then
		b_flight_player_1_wrong_way = b_on ; 
	elseif playa == player2 then
		b_flight_player_2_wrong_way = b_on ;
	elseif playa == player3 then
		b_flight_player_3_wrong_way = b_on ;
	end
end

script static boolean f_trench_get_turn_around_var( unit playa)
	local boolean var = FALSE;
	if playa == player0 then
		var = b_flight_player_0_wrong_way; 		
	elseif playa == player1 then
		var = b_flight_player_1_wrong_way; 
	elseif playa == player2 then
		var = b_flight_player_2_wrong_way;
	elseif playa == player3 then
		var = b_flight_player_3_wrong_way;
	end
	
	var;
end


script static void f_flight_stop_direction_check()


	b_flight_wp_check_done = TRUE;
	sleep(30);
	//kill_script( f_flight_direction_update );
	
	b_flight_player_0_wrong_way = FALSE;
	b_flight_player_1_wrong_way = FALSE;
	b_flight_player_2_wrong_way = FALSE;
	b_flight_player_3_wrong_way = FALSE;
	sleep(1);
	chud_show_screen_training( player0,"" ); 
	chud_show_screen_training( player1,"" ); 
	chud_show_screen_training( player2,"" ); 
	chud_show_screen_training( player3,"" ); 
	thread( f_flight_cleanup_goals() );
end

global boolean b_just_showed_message_player0 = FALSE;
global boolean b_just_showed_message_player1 = FALSE;
global boolean b_just_showed_message_player2 = FALSE;
global boolean b_just_showed_message_player3 = FALSE;


script static void f_flight_wrongway_message_timer( unit playa )

	local long l_timer = timer_stamp( 12 );
	
	if playa == player0 then
		b_just_showed_message_player0 = TRUE; 		
	elseif playa == player1 then
		b_just_showed_message_player1 = TRUE; 
	elseif playa == player2 then
		b_just_showed_message_player2 = TRUE;
	elseif playa == player3 then
		b_just_showed_message_player3 = TRUE;
	end
	
	sleep_until( timer_expired(l_timer), 1 );
		if playa == player0 then
			b_just_showed_message_player0 = FALSE; 		
		elseif playa == player1 then
			b_just_showed_message_player1 = FALSE; 
		elseif playa == player2 then
			b_just_showed_message_player2 = FALSE;
		elseif playa == player3 then
			b_just_showed_message_player3 = FALSE;
		end		
end

script static void f_flight_direction_update( )

	dprint("start waypoint update");
	repeat
	
		if not b_showing_tutorial then
			if b_flight_player_0_wrong_way and( unit_get_health(player_get(player_00)) > 0 and not b_flight_wp_check_done) then
				 //dprint("show turn around");
				 thread ( f_flight_wrongway_message_timer	(player0) );
				 chud_show_screen_training( player0, bsword_turn_around ); 	
			else
				chud_show_screen_training( player0,"" ); 
			end		
			if b_flight_player_1_wrong_way and( unit_get_health(player_get(player_01)) > 0 and not b_flight_wp_check_done)then
				 thread ( f_flight_wrongway_message_timer	(player1) );
				 chud_show_screen_training( player1, bsword_turn_around ); 	
			else
				chud_show_screen_training( player1,"" ); 
			end	
	
			if b_flight_player_2_wrong_way and( unit_get_health(player_get(player_02)) > 0 and not b_flight_wp_check_done)then
				 thread ( f_flight_wrongway_message_timer	(player2) );
				 chud_show_screen_training( player2, bsword_turn_around ); 	
			else
				chud_show_screen_training( player2,"" ); 
			end	
			if b_flight_player_3_wrong_way and( unit_get_health(player_get(player_03)) > 0  and not b_flight_wp_check_done)then
				thread ( f_flight_wrongway_message_timer	(player3) );
				chud_show_screen_training( player3, bsword_turn_around ) ; 	
			else
				chud_show_screen_training( player3,"" ); 
			end	
		end
		
	until( b_flight_wp_check_done, 15 );
	dprint("end waypoint update");
	chud_show_screen_training( player0,"" ); 
	chud_show_screen_training( player1,"" ); 
	chud_show_screen_training( player2,"" ); 
	chud_show_screen_training( player3,"" ); 
	

end

/////////////////////////////////////////////////////////////////////////////////////////////////
//DAMAGE FROM BEAMS
/////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_death_beam_damage( trigger_volume the_trig )
	
	if player_valid( player0 ) then
		thread(f_beam_damage_per_player(the_trig, player0));
	end
	
	if player_valid( player1 ) then
		thread(f_beam_damage_per_player(the_trig, player1));
	end
	
	if player_valid( player2 ) then
		thread(f_beam_damage_per_player(the_trig, player2));
	end
	
	if player_valid( player3 ) then
		thread(f_beam_damage_per_player(the_trig, player3));
	end
end

script static void f_beam_damage_per_player(trigger_volume the_trig, player the_player)
	local vehicle the_ship = NONE;
	repeat
		if player_valid( the_player ) then	
			sleep_until (volume_test_object (the_trig, the_player) , 1);
				if not b_Eye_Complete then
					the_ship = unit_get_vehicle( the_player );
					damage_object(the_ship, "default", 250);
					damage_objects_effect ("objects\vehicles\covenant\storm_wraith\turrets\storm_wraith_mortar\weapon\projectiles\damage_effects\storm_wraith_mortar_round_impact.damage_effect", the_ship);
					dprint("Hit by a beam");
					thread( f_eye_beam_camera_shake(the_player )  );
				end
				sleep (10);
		end
	until ( b_eye_complete , 1);
end

/////////////////////////////////////////////////////////////////////////////////////////////////
//DAMAGE FROM DOOR ORBS
/////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_death_orb_damage( trigger_volume the_trig, object_name orb )
	
	if player_valid( player0 ) then
		thread(f_orb_damage_per_player(the_trig, orb, player0));
	end
	
	if player_valid( player1 ) then
		thread(f_orb_damage_per_player(the_trig, orb, player1));
	end
	
	if player_valid( player2 ) then
		thread(f_orb_damage_per_player(the_trig, orb, player2));
	end
	
	if player_valid( player3 ) then
		thread(f_orb_damage_per_player(the_trig, orb, player3));
	end
end

script static void f_orb_damage_per_player(trigger_volume the_trig, object_name orb, player the_player)
	local vehicle the_ship = NONE;
	sleep_until( object_valid( orb ),1);
	repeat
		if player_valid( the_player ) then	
			sleep_until (volume_test_object (the_trig, the_player) or b_Eye_Complete, 1);
				if not b_Eye_Complete and object_get_health(orb) > 0 then
					the_ship = unit_get_vehicle( the_player );
					damage_object(the_ship, "default", 250);
					damage_objects_effect ("objects\vehicles\covenant\storm_wraith\turrets\storm_wraith_mortar\weapon\projectiles\damage_effects\storm_wraith_mortar_round_impact.damage_effect", the_ship);
					dprint("Hit by orb energy");
					thread( f_eye_beam_camera_shake(the_player )  );
				end
				sleep (8);
		end
	until ( object_get_health(orb) <= 0 or b_Eye_Complete, 1);
end