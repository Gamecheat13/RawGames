//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	crash
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================



// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

global short s_objcon_arcade = 0;
global boolean b_arcade_complete = FALSE;
global boolean b_arcade_bishop_3_fallback = FALSE;
global boolean b_arcade_scan_done = FALSE;
global boolean b_arcade_birth_done = FALSE;
global boolean b_arcade_intro_door_open = FALSE;
global boolean b_TransitionCinStart = FALSE;
global boolean b_TransitionCinEnd = FALSE;
global boolean b_arcade_in_dropdown = FALSE;
global boolean b_arcade_cin_intro_done = FALSE;

script startup m90_arcade()		
	if b_debug then 
		print_difficulty(); 
	end
	
	sleep_until( b_Eye_Complete , 4 );
	thread( f_disable_all_trench_kill_vols() );
	thread( f_flight_stop_direction_check() );
	sleep_until( volume_test_players( tv_arcade_init ),2 );
		dprint("=== ARCADE INIT ===");
		data_mine_set_mission_segment ("m90_arcade");
		f_m90_update_2_objectives();
		set_broadsword_respawns ( false );

		f_m90_loadout_set( 0 );
		garbage_collect_now();	
		sleep(1);
		object_create_folder( crs_arcade );
		object_create_folder( dms_arcade );
		object_create_folder(crs_arcade_fixed);
		wake ( f_arcade_controller );
		wake ( f_arcade_objcon_controller );				
		wake ( f_arcade_didact_scan_01 );
		wake ( f_arcade_1_save_xtra );
		wake ( f_arcade_1_save );
		wake ( nar_arcade_init );
		wake ( f_dropdown_finish_wait );
		wake ( f_arcade_cleanup );
		//f_m90_game_save();
		
		
	sleep_until ( ( b_TransitionCinStart == FALSE and b_TransitionCinEnd == FALSE ) or  (  b_TransitionCinEnd  ) );
		game_insertion_point_unlock(1);
		sleep(3);
		thread(  f_flight_cleanup_goals() );
		f_m90_game_save_no_timeout();
		sleep(5);
		fade_in ( 0,0,0,0);
		f_m90_show_chapter_title( title_on_foot );
		b_arcade_cin_intro_done = TRUE;
		//wake( f_arcade_fight_intro );
		
		wake( f_dropdown_clear_blip2 );
		sleep_until( s_objcon_arcade > 10, 1 );
		  //f_objective_set(r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip )
			thread( f_objective_set( DEF_R_OBJECTIVE_ON_FOOT_GO, TRUE, FALSE, TRUE,TRUE ) );


end





script dormant f_arcade_cleanup()
	sleep_until( volume_test_players( tv_arcade_cleanup ),3 );
	//	f_m90_set_normal_g();
		ai_erase( sg_arcade_all );
		object_destroy_folder( crs_arcade );
		//object_destroy_folder( dms_arcade );
		f_unblip_flag( fg_dropdown_jump_wp );
		f_unblip_flag( flag_dropdown_wp_2);
		b_arcade_complete = TRUE;
		sleep(1);
		kill_script(f_arcade_bishop_3_fallback);
		kill_script(f_arcade_1_save);
		kill_script(f_arcade_1_save_xtra);
		kill_script(f_arcade_blip_dropdown);
		kill_script(f_arcade_spawn_rear_turrets);
		kill_script(f_arcade_2_knight_teleport_in);
		
end




script static void f_crash_cinematic_transition ()	
	
	sleep_until (b_third_gun_destroyed == TRUE);
	
	if player_get_first_alive() != NONE then
		b_Eye_Complete = TRUE;
		thread( f_mus_m90_e01_finish() );
		b_TransitionCinStart = TRUE;
		//b_eye_plug_fire = FALSE;
		b_on_foot_cinematic_set = TRUE;
		cinematic_show_letterbox (TRUE);
	 	sleep_s (0.5);
	 	
	 	if player_get_first_alive() != NONE then
			fade_out( 1,1,1,0);
			thread( ins_cin_91() );
		end
	end


end

script dormant f_arcade_controller()
	sleep_until ( volume_test_players( tv_start_door ), 1 );
		//f_m90_game_save();
		ai_place (sg_arcade_1);
	


	sleep_until ( volume_test_players( tv_arcade_door_1 ), 1 );
		print("arcade door 1");
		
		//think about firing this off based on enemy death
		f_m90_game_save();
		
		
		sleep(60);
		ai_place_in_limbo ( sq_for_arc_2_knights_bw_1 );
		sleep(1);
		ai_place ( sq_for_arc_2_bishop_1 );
		sleep( 5 );		
		ai_place_in_limbo( sq_for_arc_2_knights );
		wake( f_arcade_2_knight_door );
		sleep( 15 );
		ai_place_in_limbo ( sq_for_arc_4_ranger );
		sleep(5);
		ai_place_in_limbo ( sq_for_arc_4_ranger_2 );
		sleep(1);
		ai_place_in_limbo ( sq_for_arc_4_bw );
		//ai_place( sq_for_arc_2_turret );
		
		
		wake( f_arcade_2_2nd_knight_spawn );
		sleep(3);
		wake( f_arcade_2_turret_spawn );


	
	sleep_until ( volume_test_players( tv_arcade_door_2 ), 1 );

		f_m90_game_save_no_timeout();
		//ai_place (sg_arcade_3);
		//wake( f_arcade_spawn_arc_3_turrets );
		//ai_place_with_shards( sq_for_arc_3_turret );
		//device_set_position (arcade_door_2, 1);
		ai_place ( sq_for_arc_4_bishop );
		//wake( f_arcade_bishop_3_fallback );
		sleep(3);
		wake( f_arcade_pawn_shard );
	
	sleep_until ( volume_test_players( tv_hallway_save ), 1 );
		f_m90_game_save_no_timeout();	
	sleep_until ( volume_test_players( tv_arcade_finish ), 1 );
		thread( f_mus_m90_e02_finish() );



end

script dormant f_arcade_2_turret_spawn()

		sleep_until( object_get_shield( ai_get_object( sq_for_arc_2_bishop_1) ) < 1 or volume_test_players( tv_arcade_2_mid ) , 1 );
				//RequestAutomatedTurretActivation( ai_vehicle_get( sq_for_arc_2_turret.front ) );
				ai_place_with_shards( sq_for_arc_2_turret );
end




script dormant  f_arcade_didact_scan_01()

	dprint("** waiting for scan ");
	sleep_until( volume_test_players( tv_arcade_1st_scan ), 1);
		//dprint("scan 1");
		//effect_new (environments\solo\m90_sacrifice\fx\scan\dscan_crash2.effect, flag_didact01_scan_2 );
		
	sleep_until( device_get_position( dm_arcade_door_intro ) == 1.0);	
		//sleep(15);	
		thread( f_mus_m90_e02_start() );
		b_arcade_intro_door_open = TRUE;
		sleep(2);
		//thread(f_arcade_bishop_move());
		
	  effect_new (environments\solo\m90_sacrifice\fx\scan\dscan_crash.effect, flag_didact01_scan );

		b_arcade_scan_done = TRUE;
	
	
	sleep_until( object_get_shield( ai_get_object( sq_for_arc_1_bishop) ) < 1 or volume_test_players( tv_arcade_intro_turret ) , 1 );
		dprint("request front turret");
		ai_place_with_shards( sq_for_arc_1_turret);
				//RequestAutomatedTurretActivation( ai_vehicle_get(sq_for_arc_1_turret.front) );	
end

script dormant f_arcade_bishop_3_fallback()

		//sleep( 30 * 10 );
		//dprint("bishop fallback");
		sleep_until( ai_spawn_count( sq_for_arc_3_turret ) == 2 );
			dprint("bishop fallback");
			b_arcade_bishop_3_fallback = TRUE;
end



script dormant f_arcade_1_save_xtra()
	sleep_until ( volume_test_players( tv_arcade_1_save_xtra), 1 );
		f_m90_game_save();
		
end


script dormant f_arcade_1_save()
	sleep_until ( volume_test_players( tv_arcade_1_save ), 1 );
		f_m90_game_save();
		
end

script dormant f_arcade_2_knight_door()
	sleep_until ( volume_test_objects( tv_arcade_2_open_knight_door, ai_actors(sq_for_arc_2_knights) ) or 	not b_arcade_2_reserve , 1 );
			dprint("opening door 2 ");
			device_set_position (arcade_door_2, 1);
		
end


script dormant f_arcade_pawn_shard()
	sleep_until( s_objcon_arcade >= 60 or object_get_shield( ai_get_object( sq_for_arc_4_bishop ) ) < .99 , 1 );
		dprint("placing pawns with shards");
		ai_place_with_shards(sq_for_arc_3_pawns , 3);

end

script dormant f_arcade_objcon_controller()

	garbage_collect_now();
	sleep_until (volume_test_players (tv_arcade_objcon_10) or s_objcon_arcade >= 10, 1);
		if s_objcon_arcade <= 10 then
			s_objcon_arcade = 10;
			dprint("s_objcon_arcade = 10 ");
		end
					
	sleep_until (volume_test_players (tv_arcade_objcon_20) or s_objcon_arcade >= 20, 1);
		if s_objcon_arcade <= 20 then
			s_objcon_arcade = 20;
			dprint("s_objcon_arcade = 20 ");
		end
		wake( f_arcade_spawn_rear_turrets );

	sleep_until (volume_test_players (tv_arcade_objcon_30) or s_objcon_arcade >= 30, 1);
		if s_objcon_arcade <= 30 then 
			s_objcon_arcade = 30;
			dprint("s_objcon_arcade = 30 ");
		end
		

		
	sleep_until (volume_test_players (tv_arcade_objcon_40) or s_objcon_arcade >= 40, 1);
		if s_objcon_arcade <= 40 then 
			s_objcon_arcade = 40;
			dprint("s_objcon_arcade = 40 ");
		end
		
		
	sleep_until (volume_test_players (tv_arcade_objcon_50) or s_objcon_arcade >= 50, 1);
		if s_objcon_arcade <= 50 then 
			s_objcon_arcade = 50;
			dprint("s_objcon_arcade = 50 ");
		end		

	sleep_until (volume_test_players (tv_arcade_objcon_55) or s_objcon_arcade >= 55, 1);
		if s_objcon_arcade <= 55 then 
			s_objcon_arcade = 55;
			dprint("s_objcon_arcade = 55 ");
		end	
		
		

	sleep_until (volume_test_players (tv_arcade_objcon_60) or s_objcon_arcade >= 60, 1);
		if s_objcon_arcade <= 60 then 
			s_objcon_arcade = 60;
			dprint("s_objcon_arcade = 60 ");
		end
		
	//ai_place (sg_arcade_4);
		wake( f_arcade_blip_dropdown );
	sleep_until (volume_test_players (tv_arcade_objcon_70) or s_objcon_arcade >= 70, 1);
		if s_objcon_arcade <= 70 then 
			s_objcon_arcade = 70;
			dprint("s_objcon_arcade = 70 ");
		end

	sleep_until (volume_test_players (tv_arcade_objcon_80) or s_objcon_arcade >= 80, 1);
		if s_objcon_arcade <= 80 then 
			s_objcon_arcade = 80;
			dprint("s_objcon_arcade = 80 ");
		end
		wake( f_teleport_intro_crates );
		thread( f_drop_down_effects() );
		f_m90_loadout_set( 1 );
end

script dormant f_arcade_blip_dropdown()
	sleep_until (ai_living_count (sg_arcade_4) <= 0 and s_objcon_arcade >= 70, 1);
		sleep_s(3);
		if not b_arcade_in_dropdown then
		
			f_blip_flag( fg_dropdown_jump_wp, "default" );
		end
end
//
script dormant f_dropdown_finish_wait()
	sleep_until (volume_test_players (tv_arcade_objcon_80) or volume_test_players (tv_dropdown_finish) 	, 1);
		
		
		if player_valid( player0 ) then
			dprint("disable damage for player 0");
			thread( f_dropdown_stop_fall_damage_player( player0 ) );
		end
		if player_valid( player1 ) then
			dprint("disable damage for player 1");
			thread( f_dropdown_stop_fall_damage_player( player1 ) );
		end
		if player_valid( player2 ) then
			dprint("disable damage for player 2");
			thread( f_dropdown_stop_fall_damage_player( player2 ) );
		end
		if player_valid( player3 ) then
			dprint("disable damage for player 3");
			thread( f_dropdown_stop_fall_damage_player( player3 ) );
		end		

		b_arcade_in_dropdown = TRUE;
		sleep( 5 );
		
		//thread( f_dropdown_stop_fall_damage( TRUE ) );
		dprint("SETUP: DROP DOWN::disabled fall damage");
end

script static void f_dropdown_stop_fall_damage_player( unit p_player )
	sleep_until ( volume_test_objects( tv_dropdown_finish, p_player ), 1 );
		f_unblip_flag( fg_dropdown_jump_wp );
		f_blip_flag( flag_dropdown_wp_2, "default" );
		dprint("disable damage for player");
		unit_falling_damage_disable ( p_player, TRUE );
	sleep_until ( volume_test_objects( tv_teleport_init, p_player ) or b_engineroom_done, 1 );	
		unit_falling_damage_disable ( p_player, FALSE );
end

script dormant f_dropdown_clear_blip2()
	sleep_until ( volume_test_players( tv_teleport_intro_crate), 1 );
		f_unblip_flag( flag_dropdown_wp_2 );

end

script static void f_dropdown_stop_fall_damage( boolean b_No_Fall_Damage )
	unit_falling_damage_disable ( player0, b_No_Fall_Damage );
	unit_falling_damage_disable ( player1, b_No_Fall_Damage );
	unit_falling_damage_disable ( player2, b_No_Fall_Damage );
	unit_falling_damage_disable ( player3, b_No_Fall_Damage );
end

script dormant f_arcade_spawn_rear_turrets()
			dprint("Spawn left_ turrets");
			//RequestAutomatedTurretActivation( ai_vehicle_get( sq_for_arc_1_turret.left ) );
			ai_place_with_shards(sq_for_arc_1_turret_2);
			sleep(1);
		sleep_until( object_get_health(sq_for_arc_1_turret_2) > 0 and object_get_health(sq_for_arc_1_turret) < 0, 1 );
			dprint("Spawn right_ turrets");
			
			if ( difficulty_legendary() or game_is_cooperative() ) then
				//RequestAutomatedTurretActivation( ai_vehicle_get( sq_for_arc_1_turret.right ) );
				ai_place_with_shards(sq_for_arc_1_turret_3);
			end
		
end

global boolean b_arcade_2_reserve = TRUE;
script static void f_arcade_2_knight_teleport_in()
	sleep_until( ai_spawn_count( sq_for_arc_2_knights_bw_1 ) > 0 and ai_living_count( sq_for_arc_2_knights_bw_1 ) < 1)  ;
			b_arcade_2_reserve = FALSE;	
			sleep_rand_s(0.5,1);
	
			if ( b_arcade_turret_2_activated and object_get_health ( ai_get_object (sq_for_arc_2_turret) ) > 0 ) then	
				dprint("turret 2 still alive");		
				sleep_rand_s(3,5);
			end

	if s_objcon_arcade < 60 then
		dprint("teleporting knight");
	end
	
	sleep_until( ai_spawn_count( sq_for_arc_2_knights ) > 0 and ai_living_count( sq_for_arc_2_knights ) < 1)  ;
		f_m90_game_save_no_timeout();

end

script dormant f_arcade_2_2nd_knight_spawn()
	sleep_until( b_arcade_birth_done or ai_living_count( sq_for_arc_2_knights_bw_1 ) == 0 or s_objcon_arcade >= 50, 1 );
		dprint( "spawn arcade 2 reserve knight");
		//ai_place( sq_for_arc_2_knights );
		thread( f_arcade_2_knight_teleport_in() );
end


// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================
global boolean b_arcade_turret_2_activated = FALSE;


script static void f_drop_down_effects()

	effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1a);
	effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1b);
	effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1c);
	effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, flag_dropdown_effect_1a, flag_dropdown_effect_2);
end

script static void f_drop_down_effects_cleanup()

	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1a );
	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1b );
	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flag_dropdown_effect_1c );
	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, flag_dropdown_effect_1a );
	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, flag_dropdown_effect_2 );
end
/*

script static void ActivateTurretArc2(ai turretPilot, unit turretVeh)
    dprint("Turret Activated");
    	
    effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ai_vehicle_get(turretPilot), "target_turret" );
    sleep(10);
    effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ai_vehicle_get(turretPilot), "target_turret" );
    object_hide( ai_vehicle_get(turretPilot), false);
    ai_braindead (turretPilot, false);
    ai_disregard (ai_actors (turretPilot), false);
end
*/



script static void rp()
	inspect( object_get_shield( ai_get_object( sq_for_arc_1_bishop_direction ) )) ;
end




