//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	Walls
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

global boolean b_walls_complete = FALSE;
global boolean b_walls_last_stand = FALSE;
global boolean b_walls_debug_last_stand = FALSE;
global boolean b_walls_wave_2_active = FALSE;
script startup m90_walls()		
	if b_debug then 
		print_difficulty(); 
	end
	
	dprint("You are having lots of fun");
	sleep_until( b_teleport_complete , 4 );
	sleep_until( volume_test_players( tv_walls_init ) or volume_test_players( tv_walls_init_teleport ) ,5 );
		dprint("walls startup");

		data_mine_set_mission_segment ("m90_walls");
		set_broadsword_respawns ( false );
		zone_set_trigger_volume_enable( "begin_zone_set:jump", FALSE);
		wake( f_walls_controller );
		wake (f_walls_eye_teleport);
		wake( f_walls_turret_defense_start );
		wake( nar_walls_init );
		//wake( f_walls_blip_controller_update );
		wake( f_walls_last_stand_init );
		//object_create_folder(crs_walls);
		
		//creating dms in teleports
		//object_create_folder(dms_walls);
		sleep( 1 );
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_close', cr_walls_plinth, 1 ); //AUDIO!
		object_hide(cr_walls_plinth, TRUE);
		
		//to make neutral turrets
		ai_allegiance (player, human);	
		ai_allegiance (human, player);
		ai_place(sq_walls_player_turret_2);
		ai_place(sq_walls_player_turret_1);
	//	ai_allegiance (forerunner, human);	
	//	ai_allegiance (human, forerunner);
		wake( f_walls_setup_portal );
		sleep(1);
		sleep_until( volume_test_players( tv_walls_init ),2 );		
			sleep_s(2);
			thread(on_walls_entry());
			sleep_s(1);
			thread( f_teleport_close_portal(dm_walls_enter , true, flg_none ));
			
			garbage_collect_now();
			
		wake (walls_distortion_control);
end

script dormant f_walls_cleanup()
	dprint("walls cleanup");
	object_destroy_folder(crs_walls);
	object_destroy_folder(dms_walls);
	object_destroy( dc_walls_turret_activator );
	//object_destroy( cr_walls_exit_portal );
	kill_script( f_walls_turret_defense_start );
	ai_erase( sg_walls_all );
end

//cr_walls_false_portal
// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script dormant f_walls_eye_teleport()

	sleep_until ( b_walls_exit_portal_active == TRUE and volume_test_players( tv_walls_to_jump_teleport ), 1 );
	
		dprint("clear blips");
		thread( f_walls_clear_blip());
		f_teleport_party_to_next_portal( flag_eye_teleport_a, flag_eye_teleport_b,flag_eye_teleport_c,flag_eye_teleport_d,ps_walls.p0, dm_jump_portal_enter );
		f_teleport_return_from_teleport();
		sleep(3);
		b_walls_complete = TRUE;
		thread( f_mus_m90_e04_finish() );
		wake( f_walls_cleanup );
		garbage_collect_now();
		sleep( 1 );
		f_m90_game_save_no_timeout();
		
end

script dormant walls_distortion_control
	
	effects_distortion_enabled = FALSE;
	
	sleep_until (b_walls_complete == TRUE);

	effects_distortion_enabled = TRUE;
	
end


script dormant f_walls_setup_portal()

	//device_set_position_track( dm_walls_exit_portal, 'open:portal', 0.0 );	
	device_set_position_track( dm_walls_exit_portal, 'open_portal', 0.0 );
	//device_animate_position(  dm_walls_exit_portal , 1 , 1, 0.1, 0.0, TRUE );
//	device_set_position (dm_walls_exit_portal, 1.0);
	device_set_position_track( dm_walls_enter, 'stop_idle', 0.0 );	

end



script dormant f_wall_activate_portals()

	//device_animate_position(  dm_walls_enter , 0 , 1.5, 0.1, 0.0, TRUE );
	
	//sleep( 3 );
	
	//f_teleport_manual_open(dm_walls_exit_false, flg_none);
	f_teleport_manual_close(dm_walls_exit_false, flg_none);
	//device_animate_position(  dm_walls_exit_false , 1 , 1.0, 0.1, 0.0, TRUE );
	//sleep_s(3);
	//thread( f_teleport_close_portal( dm_walls_exit_false, FALSE ) );
end

global boolean b_walls_intro_fight = FALSE;

script dormant f_walls_controller()



	ai_place (sq_walls_3_pawns);
	sleep(3);

	
	sleep_until ( volume_test_players( tv_walls_3 ) or ai_living_count( sq_walls_3_pawns ) < 2 , 1 );
		//wake( f_wall_activate_portals );
		sleep(60);
		print("walls 1");
		//ai_place (sg_walls_3);
		//ai_place (sq_walls_3_knight_ground);
		thread( f_mus_m90_e04_start() );
		thread( f_walls_spawn_false_portal () );
		ai_place (sq_walls_3_bishop);
		///game_save();

		b_walls_intro_fight = TRUE;
	sleep_until ( volume_test_players( tv_walls_end), 1 );
		print("walls end");		
		f_m90_game_save();
	

end



script static void f_walls_spawn_false_portal(   )

	//object_create( cr_walls_false_portal );

	sleep( 25 );
	
	//effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect,ps_walls.p1);	
	ai_place_in_limbo( sq_walls_3_knight_ground );
	//ai_place( sq_walls_3_knight_ground );
	sleep( 35 );
	//object_destroy( cr_walls_false_portal );

	
end

global boolean b_walls_cortana_pulled = FALSE;
global boolean b_walls_exit_portal_active = FALSE;

script static void test_pull()
	b_SHOW_BLIP = TRUE;

		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_open', cr_walls_plinth, 1 ); //AUDIO!
		f_m90_global_rezin( cr_walls_plinth , fx_dissolve );
		thread( f_walls_cortana_start() );
		thread( f_walls_next_blip( s_DEF_PLINTH_GRAB ));
	device_set_power(dc_walls_turret_activator ,1 );
	sleep_until( device_get_position( dc_walls_turret_activator ) != 0 );
		pup_play_show(pup_walls_cort_pull);
		device_set_power(dc_walls_turret_activator , 0 );	

end

global long g_wall_end_time=0;
global long g_wall_animation=0;

script static void f_walls_cortana_start()

	pup_play_show( pup_walls_cortana );
		sleep(1);
	wake( f_walls_ignore_cortana );
end

global boolean b_walls_cortana_come_get_me = FALSE;

script dormant f_walls_activate_exit_portal()

	thread( nar_walls_portal_open() );
	b_walls_cortana_come_get_me = TRUE;
	thread(f_walls_clear_blip());	
	sleep_s(1);
	device_set_power(dc_walls_turret_activator ,1 );

	thread( f_walls_next_blip( s_DEF_PLINTH_GRAB ));
	zone_set_trigger_volume_enable( "begin_zone_set:jump", TRUE);
	sleep_until( device_get_position( dc_walls_turret_activator ) != 0 );
		b_walls_last_stand = TRUE;
		pup_play_show(pup_walls_cort_pull);
		device_set_power(dc_walls_turret_activator , 0 );
		//object_destroy( biped_walls_cortana );

		thread( f_walls_clear_blip());
		//power to switch

		sleep( 15 );
		thread( f_teleport_open_portal( dm_walls_exit_portal, 3.0, TRUE, flg_none ) );
		//object_create( cr_walls_exit_portal );
		sleep_s(1.5);
		b_walls_exit_portal_active = TRUE;
		thread( f_walls_next_blip(s_DEF_WALLS_EXIT) );
		thread( f_objective_set( DEF_R_OBJECTIVE_ON_FOOT_GO, TRUE, FALSE, TRUE,TRUE ) );
end


//
script dormant f_walls_start_objective()
	local long l_timer = timer_stamp( 15 ); 
	sleep_until( dialog_id_played_check( l_walls_hold_off ) or timer_expired(l_timer), 1 );
		sleep_s(2);
		thread( f_walls_clear_blip());
		sleep(1);
		thread(f_walls_next_blip( s_DEF_DEFEND_ALL));
		thread( f_objective_set( DEF_R_OBJECTIVE_WALLS_HOLD, TRUE, FALSE, TRUE,TRUE ) );
end

global boolean b_walls_begin_attack = FALSE;
global boolean b_walls_plinth_ready = FALSE;

script dormant f_walls_turret_defense_start()

	sleep_until( volume_test_players( tv_walls_4 ), 1 );
		dprint("tv_walls_4 check");
		sleep_s(3);
	sleep_until ( ai_living_count ( sg_walls_3 ) <= 1 and ai_living_count( sq_walls_3_knight_ground ) <= 0, 1 );
		//thread( nar_walls_need_time() );
		dprint("starting f_walls_turret_defense_start" );
	//(sq_walls_player_turret_1);
	//ai_place(sq_walls_player_turret_2);

	sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\amb_m90_dm_plinth_open', cr_walls_plinth, 1 ); //AUDIO!
	f_m90_global_rezin( cr_walls_plinth , fx_dissolve );
	object_dissolve_from_marker( cr_walls_plinth , phase_out, fx_dissolve );
	sleep(30);

	dprint("clear blips");

	thread(f_walls_clear_blip());	
	sleep( 30 );
	object_create(dc_walls_turret_activator);
	sleep( 1 );
	device_set_power(dc_walls_turret_activator , 0 );
	b_walls_plinth_ready = TRUE;
	dprint("**** PLINTH BLIP ****");
	//thread( f_walls_next_blip( s_DEF_PLINTH_START ) );

	thread( f_walls_cortana_start() );
	sleep(1);

	//wake ( f_wall_portal_dialogue );
	ai_lod_full_detail_actors (22);
	thread( f_wall_td_wave_spawner_main() );
	wake( f_walls_start_objective );
	//wake( f_walls_close_false_portal );   
	sleep(5);
	f_m90_game_save();

	//sleep_until( volume_test_players( tv_walls_start_defense ) , 1 );

	sleep_s(6);
	
	b_walls_begin_attack = TRUE;
	dprint("1st wave");  

	//thread(f_walls_next_blip( s_DEF_DEFEND_ALL));
	//thread( f_objective_set( DEF_R_OBJECTIVE_WALLS_HOLD, TRUE, FALSE, TRUE,TRUE ) );
	sleep_s(6);
 
	thread( f_wall_td_wave_spawner_main() );
	sleep_s(4);
	thread( f_wall_td_wave_spawner_main() );
	//thread( f_wall_td_wave_spawner_main() );
	sleep_s(5);
	thread( f_wall_td_wave_spawner_main() );
					
   		
  	sleep_until( ai_living_count ( sg_walls_4 ) < 3 or volume_test_players( tv_walls_going_for_it ) , 1 );
   			//garbage_collect_now();	
 				
   			sleep_s( 5 );
   			//thread(f_walls_clear_blip( ));	 
   			dprint("2nd wave");  
	   		thread( f_wall_td_wave_spawner_flank() );
	   		sleep_s(3);
	   		//wake( f_dialog_m90_final_portal_wave2 );
	   		//thread(f_walls_next_blip( s_DEF_DEFEND_FLANK ));
	   		//sleep_s(3);	
	   		//thread( f_wall_td_wave_spawner_flank() );	
	   		 	sleep_s(1);	
	   		 	b_walls_wave_2_active = TRUE;
	   		thread( f_walls_raise_turrets() );
	   		sleep_s(5);
	   		thread( f_wall_td_wave_spawner_flank() );
				thread( f_wall_td_wave_spawner_flank() ); 				
				 	sleep_s(7);	
				thread( f_wall_td_wave_spawner_flank() ); 	
	   	sleep_until( ai_living_count ( sg_walls_4_flank ) < 3 or volume_test_players( tv_walls_going_for_it ) , 1 );
	   		dprint("clear blips");
	   		//thread(f_walls_clear_blip());	
	   		b_walls_wave_2_active = FALSE;
	   		sleep_s( 3 );
	   		//wake( f_dialog_m90_final_portal_wave3 );
	   		thread( f_wall_td_wave_spawner_main() );
	   		//thread(f_walls_next_blip( s_DEF_DEFEND_ALL));  
	   		sleep_s( 9 );
	   		dprint("3rd wave");
	   		thread( f_wall_td_wave_spawner_flank() );   		
	   		sleep_s(2);
	   		//wake( f_dialog_m90_on_the_walls );
	   		thread( f_wall_td_wave_spawner_main() );  
	   		//thread( f_wall_td_wave_spawner_flank() );	
	   		sleep_s(3);
	   		//thread( f_wall_td_wave_spawner_main() );	
	   	//	sleep_s(4);
	   		thread( f_wall_td_wave_spawner_main() );
	   		if (difficulty_legendary() and game_is_cooperative() ) then
	   			thread( f_wall_td_wave_spawner_flank() );
	   		end
	   	sleep_until( ( ai_living_count ( sg_walls_4 ) + ai_living_count ( sg_walls_4_flank ) < 3 )  or volume_test_players( tv_walls_going_for_it ) , 1 );
	   	//	garbage_collect_now();
	   		
	   		sleep_s(3);	   		
	   		f_m90_game_save();
	   		dprint("4th wave"); 
	   		thread( f_wall_td_wave_spawner_main() );
	   		sleep_s(2);  		   		
	  		wake( f_walls_activate_exit_portal ); 
	  		sleep_s(3);		
	  		wake( f_walls_exit_spawns );	  
	  				
	  	sleep_until( ( ai_living_count ( sg_walls_4 ) + ai_living_count ( sg_walls_4_flank )  < 1 ) , 1 );	  			  		
	  		ai_lod_full_detail_actors (18);
	  		garbage_collect_now();
	  		
	  		f_m90_game_save();
	   		
end

script dormant f_walls_ignore_cortana()
	sleep_until( object_valid(biped_walls_cortana) , 1);
		ai_disregard ( biped_walls_cortana ,TRUE);
end
//f_dialog_m90_behind_you - Chief, behind you!
//f_dialog_m90_from_above - Coming from above!
//f_dialog_m90_turn_around - Turn around!
//f_dialog_m90_came_in - The way you came in!

script dormant f_walls_exit_spawns()
	//local short s_walls_flood_count = 0;
	sleep_until( b_walls_exit_portal_active , 1 );	
	wake( f_walls_exit_spawns_bridge );
	sleep_rand_s( 10,13 );
	repeat 
		//s_walls_flood_count = s_walls_flood_count + 1;
		ai_place(sq_walls_end_flood_1);
		sleep(4);
		sleep_until( ai_living_count(sq_walls_end_flood_1)  <= 1 );
		sleep_s(4);
	until( b_walls_complete , 1 );	
		

end

script dormant f_walls_exit_spawns_bridge()

	
	//side spawns for flavor ,like the walls are crawling with pawns from everywhere
	repeat
		sleep_until( ai_living_count( sg_walls_all ) <= 9  and s_walls_objcon >= 10 , 1);	
			sleep_rand_s(5,7);
			if not b_walls_complete then
				ai_place(sq_walls_flood_bridge, 2);
			end
			
			sleep_until( ai_living_count( sg_walls_all ) <= 11 );
				if not b_walls_complete then
					ai_place(sq_walls_flood_bridge2, 2);
					sleep_rand_s(10,13);
				end
			
			
	until( b_walls_complete , 5);

end

script static void f_wall_td_wave_spawner_flank()


	if ( ai_living_count ( sq_walls_td_pawn_flank ) >= 3 ) then
		ai_place( sq_walls_td_pawn_flank, 2 );
	//elseif ( ai_living_count ( sq_walls_td_pawn_flank ) >= 3 ) then
		//ai_place( sq_walls_td_pawn_flank, 2 );
	else
		ai_place( sq_walls_td_pawn_flank, 3 );
	end

end


script static void f_wall_td_wave_spawner_main()

	if ( ai_living_count ( sq_walls_4_pawn_td_1 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_1 );
	//dprint("place pawns 1");
	elseif ( ai_living_count ( sq_walls_4_pawn_td_2 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_2, 3 );
		//dprint("place pawns 2");
	elseif ( ai_living_count ( sq_walls_4_pawn_td_3 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_3 );
		//dprint("place pawns 3");
	else
		dprint("no pawns needed");
		sleep(1);
	end

end

script dormant f_walls_flanking_reminder()

	sleep_until( not ( volume_test_players (tv_walls_4 ) ) , 1);
		if b_walls_wave_2_active then
			//wake( f_dialog_m90_flanking_us );
			sleep(1);
		end
end


script dormant f_wall_portal_dialogue()
	 //nar_walls_portal_opening() ;
	 nar_walls_incoming() ;
	 sleep(1);
	 
end
	
script dormant f_walls_close_false_portal()
	//device_animate_position(  dm_walls_exit_false , 0 , 1.5, 0.1, 0.0, TRUE );
//	thread( f_teleport_close_portal( dm_walls_exit_false, TRUE ) );
			//device_set_position_track( dm_walls_exit_false, 'any:idle', 0.0 );
			object_destroy(dm_walls_exit_false);	
			sleep(3);
			object_create(dm_walls_exit_false);	
end
	


script static void f_walls_raise_turrets()
	thread( nar_walls_turrets() );
	
	// raise turret pillar out of the floor
	sound_impulse_start_marker('sound\environments\solo\m090\amb_m90_device_machines\add_on_machine_tags\machine_m90_for_pillar_crate_rise', cr_walls_turret_tower_a, audio_marker_topw, 1);
	object_move_by_offset( cr_walls_turret_tower_a, 0.5 , 0, 0, 0.65);

	sleep(30);

	thread( f_walls_turret_rez_in( sq_walls_player_turret_2.casbah ) );
	ai_set_blind( sq_walls_player_turret_2.casbah, FALSE );
	ai_braindead ( sq_walls_player_turret_2.casbah, FALSE );
	sleep_s(20);

	// raise turret pillar out of the floor
	sound_impulse_start_marker('sound\environments\solo\m090\amb_m90_device_machines\add_on_machine_tags\machine_m90_for_pillar_crate_rise', cr_walls_turret_tower_b, audio_marker_topw, 1);
	object_move_by_offset( cr_walls_turret_tower_b, 0.5, 0, 0, 0.65);
	
	sleep(30);

	thread( f_walls_turret_rez_in( sq_walls_player_turret_1.pinback ) );
end




///////////////////////////
// LAST STAND
//////////////////////////
script static void f_walls_debug_last_stand()
	dprint("debug last stand");
	b_walls_debug_last_stand = TRUE;
	b_walls_last_stand = TRUE;
	wake( f_walls_last_stand_init );

end

script dormant f_walls_spawn_last_stand_turrets()
	sleep_until( (b_walls_exit_portal_active  or s_walls_objcon >= 10 ) , 1 );

		//sleep_s(1);
		ai_allegiance (player, human);	

		//ai_place( sq_walls_player_turret_ls_1 );


		sleep(5);
		//AutomatedTurretActivate( ai_vehicle_get( sq_walls_player_turret_ls_1.last_stand_1 ) );
		ai_place(sq_walls_player_turret_ls_1.last_stand_1);
		sleep(5);
		thread( f_walls_turret_rez_in( sq_walls_player_turret_ls_1.last_stand_1 ) );
		//AutomatedTurretSwitchTeams(ai_vehicle_get( sq_walls_player_turret_ls_1.last_stand_1 ), player_get_first_valid() );
		sleep(5);
		ai_place(sq_walls_player_turret_ls_1.last_stand_2);
		//AutomatedTurretActivate( ai_vehicle_get( sq_walls_player_turret_ls_1.last_stand_2 ) );
		sleep(5);
		thread( f_walls_turret_rez_in( sq_walls_player_turret_ls_1.last_stand_2 ) );
		//AutomatedTurretSwitchTeams(ai_vehicle_get( sq_walls_player_turret_ls_1.last_stand_2 ), player_get_first_valid() );	
	
	sleep_until ( s_walls_objcon >= 10, 1);

		sleep_s(2);
		//ai_place( sq_walls_player_turret_ls_2 );
				dprint("spawning far turrets");
		//sleep(5);
	
		//AutomatedTurretActivate( ai_vehicle_get( sq_walls_player_turret_ls_2.last_stand_3 ) );
		ai_place(sq_walls_player_turret_ls_2.last_stand_3);
		sleep(5);
		thread( f_walls_turret_rez_in( sq_walls_player_turret_ls_2.last_stand_3 ) );
		//AutomatedTurretSwitchTeams(ai_vehicle_get( sq_walls_player_turret_ls_2.last_stand_3 ), player_get_first_valid() );
		sleep(5);
		//AutomatedTurretActivate( ai_vehicle_get( sq_walls_player_turret_ls_2.last_stand_4 ) );
		ai_place(sq_walls_player_turret_ls_2.last_stand_4);
		sleep(5);
		thread( f_walls_turret_rez_in(sq_walls_player_turret_ls_2.last_stand_4 ) );
		//AutomatedTurretSwitchTeams(ai_vehicle_get( sq_walls_player_turret_ls_2.last_stand_4 ), player_get_first_valid() );	
end

global short s_walls_objcon = 0;

script dormant f_walls_spawn_last_stand_objcon_10()
	sleep_until (volume_test_players ( tv_walls_last_stand_front ) or s_walls_objcon >= 10, 1);
		if s_walls_objcon <= 10 then
			s_walls_objcon = 10;
			dprint("s_walls_objcon = 10 ");
		end
end

script dormant f_walls_spawn_last_stand_objcon_20()					
	sleep_until (volume_test_players ( tv_walls_last_stand_mid ) or s_walls_objcon >= 20, 1);
		if s_walls_objcon <= 20 then
			s_walls_objcon = 20;
			dprint("s_walls_objcon = 20 ");
		end
end

script dormant f_walls_spawn_last_stand_objcon_30()		
	sleep_until (volume_test_players ( tv_walls_last_stand_rear ) or s_walls_objcon >= 30, 1);
		if s_walls_objcon <= 30 then 
			s_walls_objcon = 30;
			dprint("s_walls_objcon = 30 ");
		end
	
end


script dormant f_walls_last_stand_init()
	dprint("last stand init");

	sleep_until(  b_walls_last_stand , 1 );
		garbage_collect_now();

		sleep(5);
		wake( f_walls_spawn_last_stand_objcon_10 );
		wake( f_walls_spawn_last_stand_objcon_20 );
		wake( f_walls_spawn_last_stand_objcon_30 );
		thread( f_wall_last_stand_spawner() );
		sleep( 3 );
		thread( f_wall_last_stand_spawner() );
		sleep( 3 );
		thread( f_wall_last_stand_spawner() );
		wake( f_walls_spawn_last_stand_turrets );
		//wake( f_dialog_m90_catwalk );
		repeat
				sleep_until( ai_living_count( sg_walls_4 ) <= 5 );

					//thread( f_wall_last_stand_spawner() );
					if s_walls_objcon <= 20 then
						thread( f_wall_last_stand_spawner() );
						sleep(15);
					end

					if s_walls_objcon <= 10 then
						thread( f_wall_last_stand_spawner() );
						thread( f_wall_last_stand_spawner() );
						thread( f_wall_last_stand_spawner() );
					end
					sleep_s(5);
		until( s_walls_objcon >= 30 , 1 );
end

script static void f_wall_last_stand_spawner()
	dprint("lll");
	if ( ai_living_count ( sq_walls_4_pawn_td_1 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_1,3 );
		//dprint("place pawns 1");
	elseif ( ai_living_count ( sq_walls_4_pawn_td_2 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_2, 2 );
		//dprint("place pawns 2");
	elseif ( ai_living_count ( sq_walls_4_pawn_td_3 ) <= 2 ) then
		ai_place( sq_walls_4_pawn_td_3, 2 );
		//dprint("place pawns 3");
	else
		dprint("no pawns needed");
		ai_place( sq_walls_4_pawn_td_1, 1 );
		if (difficulty_legendary() and game_coop_player_count() >= 3) then
			ai_place( sq_walls_4_pawn_td_2, 3 );
		end
		sleep(1);
	end

end



global short s_walls_blip_index = -1;
global short s_DEF_PLINTH_START = 0;
global short s_DEF_DEFEND_FRONT = 1;
global short s_DEF_DEFEND_FLANK = 2;
global short s_DEF_DEFEND_ALL 	= 3;
global short s_DEF_PLINTH_GRAB 	= 4;
global short s_DEF_WALLS_EXIT 	= 5;
global boolean b_SHOW_BLIP			= FALSE;



script static void f_walls_next_blip( short DEF_BLIP )
	//thread( f_walls_clear_blip());
	sleep(15 );
	s_walls_blip_index = DEF_BLIP;
	dprint("turning on blip");
	b_SHOW_BLIP = TRUE;
	thread( f_walls_blip_controller_update() );
end

script static void f_walls_clear_blip()
	//dprint("turning off blips");
	b_SHOW_BLIP = FALSE;
	if object_valid( dc_walls_turret_activator ) then
		thread( f_unblip_object ( dc_walls_turret_activator ) );	
	end
	thread( f_unblip_flag ( flag_walls_cortana ) );	
	thread( f_unblip_flag ( flag_walls_exit ));	
	thread( f_unblip_flag ( flag_walls_defend_a ));
	thread( f_unblip_flag ( flag_walls_defend_b ));
	thread( f_unblip_flag ( flag_walls_defend_c ));
	//sleep(5);
end



script static void f_walls_blip_controller_update()


	
		if b_SHOW_BLIP then
			if s_walls_blip_index == s_DEF_PLINTH_START then
				thread( f_blip_flag (flag_walls_cortana, "default") );
			end
			
			if s_walls_blip_index == s_DEF_DEFEND_FRONT then
				thread( f_blip_flag ( flag_walls_defend_a, "defend" ) );
			end
			
			if s_walls_blip_index == s_DEF_DEFEND_FLANK then
				thread( f_blip_flag ( flag_walls_defend_b, "defend" ) );
			end
			
			if s_walls_blip_index == s_DEF_DEFEND_ALL then
				thread(f_blip_flag ( flag_walls_defend_c, "defend" ) );
			end

			if s_walls_blip_index == s_DEF_PLINTH_GRAB then
				thread( f_blip_object (dc_walls_turret_activator, "activate") );
			end
			
			if s_walls_blip_index == s_DEF_WALLS_EXIT then
				thread( f_blip_flag( flag_walls_exit ,"default") );
			end

		end
		
		if not b_SHOW_BLIP then
			//dprint("clear blips");
			thread( f_walls_clear_blip() );
		end

end

script command_script turret_phasein()
	object_hide(ai_vehicle_get ( ai_current_actor ) , TRUE);
	ai_set_blind(ai_current_actor, TRUE);
	ai_braindead (ai_current_actor, TRUE);
	
	
end

script static void f_walls_turret_rez_in(ai turret )
	AutomatedTurretSwitchTeams(ai_vehicle_get( turret ), player_get_first_valid()  );
	object_dissolve_from_marker( ai_vehicle_get ( turret ), phase_in, control_marker );
	sleep(5);
	ai_set_blind( turret, FALSE );
	ai_braindead ( turret, FALSE );
	
	
	//giving a little xtra vitality, because they die easily to pawns. we inherit health from the normal turret and we cant adjust it on the tag
	sleep_until( object_get_health( 	ai_vehicle_get( turret ) ) <= 0.10 ,1 );
		//dprint("double the effort turret!");
		object_set_health (ai_vehicle_get( turret ),1 );
		sleep(2);
	sleep_until( object_get_health( 	ai_vehicle_get( turret ) ) <= 0.10 ,1 );
		object_set_health (ai_vehicle_get( turret ),1 );
end



script command_script m90_pawn_phasein()
	object_dissolve_from_marker(ai_get_object(ai_current_actor), "resurrect", "phase_in");
end