// =============================================================================================================================
//=========== ENGINE E7M5 FIREFIGHT SCRIPT =====================================================================================
// =============================================================================================================================
global boolean b_e7m5_hall_push = FALSE; 
global boolean b_e7m5_vent_clear = FALSE;
global boolean b_e7m5_hallway_1_clear = FALSE;
global boolean b_e7m5_hallway_2_clear = FALSE;
global boolean b_e7m5_hunter_hallway_clear = FALSE;
global boolean b_e7m5_server_clear = FALSE;
global boolean b_e7_m5_head_to_hanger = FALSE;
global real s_objcon_e7_m5_hall_1 = 0;

script startup dlc01_engine_e7_m5

	//gmurphy 12-20-2012
	//bug 10795
	//disable the lift kill volume for all the missions, will turn on when needed
	kill_volume_disable (kill_volume_lifts);
	if ( f_spops_mission_startup_wait("e7_m5") ) then
		wake( dlc01_engine_e7_m5_init );
	end
end

script dormant dlc01_engine_e7_m5_init
	//Start the intro
	sleep_until (LevelEventStatus("e7_m5"), 1);
	print ("**************STARTING E7 M5******************");       
	f_spops_mission_setup("e7_m5", e7_m5, gr_e7_m5_ff_all, sc_e7_m5_spawn_point_0, 90);

	thread(f_start_player_intro_e7_m5());
	thread (e7m5_start_mission());		// thread the rest of the event threads
	thread (f_start_all_events_e7_m5());	// thread the rest of the event threads
	thread(f_music_e07m5_start());	
	
//============ OBJECTS ==================================================================
// Set Crate names
	f_add_crate_folder(sc_e7_m5_props);
	f_add_crate_folder(cr_e7_m5_unsc_cover);
	f_add_crate_folder(cr_e7_m5_cov_cover);	
	f_add_crate_folder(cr_e7_m5_unsc_ammo);	
	f_add_crate_folder(cr_e7_m5_rox);	
	//f_add_crate_folder(cr_e7_m5_cov_ammo);	
	f_add_crate_folder(cr_e7_m5_props);	
	f_add_crate_folder(eq_e7_m5_ammo);
	f_add_crate_folder(ma_e7_m5_doors);	
	f_add_crate_folder(ma_e7_m5_lift);		
	f_add_crate_folder(e7_m5_controls);	
	f_add_crate_folder(wp_e7_m5_weapons);
	f_add_crate_folder(veh_e7m5);
	object_create(engine_server_hum_01);
	object_create(engine_server_hum_02);
	object_create(engine_server_hum_03);
	object_create(engine_server_hum_04);
	object_create(engine_server_hum_05);
	object_create(engine_server_hum_06);
	
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_0, 90); 	//spawns in base
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_1, 91); 	//spawns at exit of ventcore
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_2, 92); 	//spawns pointing to Data Room
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_3, 93); 	//spawns pointing to H hallway
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_4, 94); 	//spawns outside the hangar
	firefight_mode_set_crate_folder_at(sc_e7_m5_spawn_point_5, 95); 	//spawns outside the end of H
	
// controls
	firefight_mode_set_objective_name_at(dc_e7m5_door_switch1, 1); 	
	firefight_mode_set_objective_name_at(dc_e7m5_door_switch2, 2); 	
	firefight_mode_set_objective_name_at(dc_e7m5_door_switch3, 3); 	

// locations
	firefight_mode_set_objective_name_at(lz_50, 50); 							
	firefight_mode_set_objective_name_at(lz_51, 51); 							
	firefight_mode_set_objective_name_at(lz_52, 52); 							
	
// set squad group names
	// Ventcore
	firefight_mode_set_squad_at(sq_e7_m5_vent_pawns1a, 11);				
	firefight_mode_set_squad_at(sq_e7_m5_vent_pawns1b, 14);				
	firefight_mode_set_squad_at(sq_e7_m5_ventg_2, 12);		
	firefight_mode_set_squad_at(sq_e7_m5_vent_pawns2a, 13);	
	firefight_mode_set_squad_at(sq_e7_m5_vent_pawns2b, 15);	
	
	// hallway 1	
	firefight_mode_set_squad_at(sq_e7_m5_hallway1c_2, 2);			
	firefight_mode_set_squad_at(sq_e7_m5_hallway1c_3, 3);			
	firefight_mode_set_squad_at(sq_e7_m5_hallway1c_4, 4);			
	firefight_mode_set_squad_at(sq_e7_m5_hallway1c_5, 5);			
	firefight_mode_set_squad_at(sq_e7_m5_hallway2c_left, 6);		
	firefight_mode_set_squad_at(sq_e7_m5_hallway2c_right, 7);				
		
	// DATA ROOM
	
	// firefight_mode_set_squad_at(sq_e7_m5_bishop_start, 41);	
	// firefight_mode_set_squad_at(sq_e7_m5_airoomg_1, 42);
	// firefight_mode_set_squad_at(sq_e7_m5_airoomg_2, 43);
	// firefight_mode_set_squad_at(sq_e7_m5_airoomg_final, 44);
	// firefight_mode_set_squad_at(sq_e7_m5_bishop_1, 45);
	// firefight_mode_set_squad_at(sq_e7_m5_bishop_2, 46);
	// firefight_mode_set_squad_at(sq_e7_m5_pawns4, 47);


	// Loading Bay
	// firefight_mode_set_squad_at(sq_e7_m5_bay_grunts, 61);	

	
	effect_new(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
	f_spops_mission_setup_complete( TRUE );	
		
end

	
//=========== MAIN SCRIPT STARTS ==================================================================


//threading all the event scripts that are called through the gameenginevarianttag
	script static void f_start_all_events_e7_m5
		print ("threading all the event scripts");
		//event tags		
		thread (e7m5_ventcore());	
		thread (e7m5_open_ventdoor());	
		thread (e7m5_hallway1_setup());		
		thread (e7m5_airoom_open());	
		thread (e7m5_airoom_end());			
		thread (e7m5_hhallway_start());	
		thread (e7m5_hhallway_end());	
		thread (e7m5_hangar_start());	
		thread (f_end_mission_e7_m5());	
		thread (e7m5_pistons());
		thread (f_fx_ai_server_start());
	end
	
// ================================================================
// ========= STARTING E7 M5 - VENTCORE ============================
// ================================================================
	script static void e7m5_start_mission()
		sleep_until (LevelEventStatus("start_mission"), 1);
			dprint ("START start_mission");
		sleep_until( f_spops_mission_start_complete(), 1 );
			dprint ("Players Spawned!");	
			//print ("Dec 5 | 4:00PM");	
			ai_allegiance ( forerunner, covenant );
		  ai_allegiance ( covenant, forerunner );
			thread(f_music_e07m5_clean_stragglers());
			
			sleep(1);			
		sleep_until( not b_e7m5_narrative_is_on , 1);
			thread( vo_e7m5_clean_stragglers() );		
				// Miller : We've got the ship on lockdown, the guns firing, and the engine room secure. Time to clean up the stragglers, Crimson.			
					
				// Blip goto		
			thread( e7m5_vent_spawns_start());
			object_create(lz_50);
			thread( e7m5_breadcrumb_blips() );
		
				// OBJECTIVE - CLEAR THE AREA	
			f_new_objective(ch_7_5_1);		
			//print ("waiting for trigger to be hit");
		sleep_until (volume_test_players (tv_e7_m5_start), 1);
			//print ("trigger hit");
			sleep_s(1);	
				// FX Spawn Pawns		
				// Remove blip goto
			//thread(f_blip_object_cui (lz_50, "")); 	
			object_destroy(lz_50);				
			f_e7m5_crawlers_callouts();
			//thread(e7m5_ventcore_waves());		
			sleep_s(1);			
		sleep_until( not b_e7m5_narrative_is_on, 1);
			vo_e7m5_clear_area();
				// Miller : Clear the area of bad guys and move on.		
			sleep_rand_s(2, 5);
		sleep_until( not b_e7m5_narrative_is_on, 1);
			vo_e7m5_infinity_01();
	end	
	

	
script static void e7m5_ventcore()
		sleep_until (LevelEventStatus("ventcore"), 1);	
			sleep_s(0.25);
			//prepare_to_switch_to_zone_set (e7_m5_b);                   // starting zone switch
			//sleep_s(1.75);
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
			vo_e7m5_into_halls();
			b_e7m5_vent_clear = TRUE;
				// Miller : Let's get out in the halls and clear them as well.
			thread(f_music_e07m5_server_room());
			f_new_objective(ch_7_5_2);
		//sleep_until (not PreparingToSwitchZoneSet(), 1);
			//switch_zone_set (e7_m5_b);
			sleep_s(0.25);		
			object_create(dc_e7m5_door_switch1);
			device_set_power(dc_e7m5_door_switch1, 1);			
		//f_blip_object_cui (dc_e7m5_door_switch1, "navpoint_activate");		
		//device_set_position_track( e7m5_button1, "device:position", 0 );
		//device_animate_position (e7m5_button1, 1, 0.25, 1, 0, 0);
			thread(f_e7m5_heavyforces_callouts());
			print("sleeping until button press");	
		//sleep_until (device_get_power(device(dc_e7m5_door_switch1)) < 1 or device_get_position(device(dc_e7m5_door_switch1)) > 0, 1);
		
		b_end_player_goal = TRUE;		
end	

global long l_e7m5_shard_4 = -1;	
script static void e7m5_vent_spawns_start()

	local long l_e7m5_shard_1 = -1;
	local long l_e7m5_shard_2 = -1;
	local long l_e7m5_shard_3 = -1;

	
	ai_place_in_limbo(sq_e7_m5_pawn_intro);
	sleep_until( volume_test_players( tv_e7_m5_start ), 1, 30 * 6);
		e7_m5_ai_watcher_spawn(  sq_e7_m5_vent_bishop_01.one, flg_e7m5_bishop_1, "ai_e7_m5_ventcore_1" );
		sleep_s(0.5);
		e7_m5_ai_watcher_spawn(  sq_e7_m5_vent_bishop_02.one, flg_e7m5_bishop_2, "ai_e7_m5_ventcore_1" );
		sleep_s(0.5);
		e7_m5_ai_watcher_spawn(  sq_e7_m5_vent_bishop_01.two, flg_e7m5_bishop_3, "ai_e7_m5_ventcore_1" );
		sleep_s(0.5);
		e7_m5_ai_watcher_spawn(  sq_e7_m5_vent_bishop_02.two, flg_e7m5_bishop_4, "ai_e7_m5_ventcore_1" );
		sleep_s(0.5);

	sleep_until (ai_living_count (gr_e7_m5_ventcore_pawn) <= 2 or ai_living_count (gr_e7_m5_vent_bish) <= 3, 1);
		if ai_living_count(gr_e7_m5_vent_bish) > 0  then
			dprint("shard1");
			l_e7m5_shard_1 = ai_place_with_shards( sq_e7_m5_vent_pawns1a );
			sleep_s( 4 );
			l_e7m5_shard_3 = ai_place_with_shards( sq_e7_m5_vent_pawns1b );
			dprint("shard2");
			sleep_s(5 );
		end
		
	sleep_until ( ai_living_count (gr_e7_m5_ventcore_pawn) <= 2 or ai_living_count (gr_e7_m5_vent_bish) <= 2, 1 );
			if ai_living_count(gr_e7_m5_vent_bish) > 0  then
			
				DestroyDynamicTask( l_e7m5_shard_1 );
				DestroyDynamicTask( l_e7m5_shard_3 );
				l_e7m5_shard_2 = ai_place_with_shards( sq_e7_m5_vent_pawns2a );
				dprint("shard3");
				sleep_s( 5 );	
			end
			sleep_s(2);
	sleep_until ( ai_living_count (gr_e7_m5_ff_all) <= 1, 1 );;
		sleep_rand_s (1, 3);
		ai_place_in_limbo(sq_e7_m5_ventg_2);
		thread(f_e7m5_knights_callouts());	
		sleep_s(1);
		local short bishops_count = ai_living_count(gr_e7_m5_vent_bish);
		ai_place_with_birth(sq_e7_m5_vent_bishop_03);
		sleep_s(0.75); 
		if bishops_count <= 1 then
			ai_place_with_birth(sq_e7_m5_vent_bishop_04);
		end
		DestroyDynamicTask( l_e7m5_shard_1 );
		DestroyDynamicTask( l_e7m5_shard_2 );
		DestroyDynamicTask( l_e7m5_shard_3 );

		local long l_e7m5_vent_pawnthread = thread( e7m5_vent_knight_pawn_shards() );
		sleep_s( 6 );	

		
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 0, 1);
			DestroyDynamicTask( l_e7m5_shard_4 );
				// END VENTCORE GOAL
			kill_thread( l_e7m5_vent_pawnthread );
			
			b_end_player_goal = TRUE;	
end	
	


script static void e7m5_vent_knight_pawn_shards()
	sleep_until( ai_living_count(gr_e7_m5_vent_bish ) > 0 , 1 );
		sleep_s(0.5);
		l_e7m5_shard_4 = ai_place_with_shards( sq_e7_m5_vent_pawns2b );
end
	
script static void e7m5_breadcrumb_blips()
	local long l_e7_m5_breadcrumb = -1;
	local long l_e7_m5_breadcrumb2 = -1;
	spops_blip_object (lz_50, TRUE, "navpoint_goto");
	
	sleep_until( volume_test_players( tv_e7_m5_start ), 1);
		sleep_s(2);
		spops_unblip_object (lz_50);

	sleep_until( b_e7m5_vent_clear, 1 );
		//spops_blip_flag (flg_e7m5_enter_hallway_1 , TRUE, "default" );
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_hallway_1, "default", tv_e7_m5_hallway_1, FALSE );
	//sleep_until( device_get_position(e7m5_ventdoor_1) >= 0.95 , 1 );
		//spops_unblip_flag (flg_e7m5_enter_hallway_1);
		//l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_hallway_1, "default", tv_e7_m5_hallway_1, FALSE );
	sleep_until( b_e7m5_hallway_1_clear, 1 );
		kill_thread( l_e7_m5_breadcrumb );
		sleep(1);
		//spops_blip_flag (flg_e7m5_enter_server_1 , TRUE, "default" );
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_server_1, "default", tv_e7_m5_server, FALSE );
	sleep_until( b_e7m5_server_clear, 1 );
		kill_thread( l_e7_m5_breadcrumb );
		sleep(1);
	sleep_until( b_e7_m5_head_to_hanger , 1);
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger(  flg_e7m5_server_hallway , "default", tv_e7_m5_server_hallway, TRUE );	
		//lz_53
		//tv_e7_m5_server_hallway
	sleep_until( device_get_position(e7m5_halldoor_2) >= 0.95 , 1 );
		kill_thread(l_e7_m5_breadcrumb);
		sleep(1);		
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7_m5_hunter_hallway, "default", tv_e7_m5_hunter_hallway, FALSE );
		//spops_unblip_flag (flg_e7m5_enter_server_1);
		//l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_server_1, "default", tv_e7_m5_server, FALSE );
	sleep_until( b_e7m5_hunter_hallway_clear, 1 );
		kill_thread( l_e7_m5_breadcrumb );
		sleep(1);
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_hallway_2, "default", tv_e7_m5_hallway_2, FALSE );
		//spops_blip_flag (flg_e7m5_enter_hallway_2 , TRUE, "default" );
	//sleep_until( device_get_position(e7m5_halldoor_3) >= 0.95 , 1 );
		//spops_unblip_flag (flg_e7m5_enter_hallway_2);		
		//l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7m5_enter_hallway_2, "default", tv_e7_m5_hallway_2, FALSE );
	sleep_until( b_e7m5_hallway_2_clear, 1 );
		kill_thread( l_e7_m5_breadcrumb );
		spops_blip_flag (flg_e7_m5_enter_hanger , TRUE, "default" );
	sleep_until( device_get_position(e7m5_baydoor_1) >= 0.95 , 1 );
		spops_unblip_flag (flg_e7_m5_enter_hanger);		
	
		l_e7_m5_breadcrumb = spops_blip_auto_flag_trigger( flg_e7_m5_hanger, "default", tv_e7_m5_hanger, FALSE );				
		
end	

///

// ================================================================
// ========= HALLWAY PHASE 1 ======================================
// ================================================================

script static void e7m5_open_ventdoor
	sleep_until (LevelEventStatus("open_ventdoor"), 1);
	
	//thread(e7m5_open_ventdoor_1()); // Open door to exit Ventcore	
	thread( e7_m5_door_open_wait(tv_e7_m5_vent_door, e7m5_ventdoor_1, e7m5_button1 , FALSE ) );
	thread( e7m5_setup_hallway_1_objcon() );
	object_destroy(dc_e7m5_door_switch1);
end	
	
script static void e7m5_setup_hallway_1_objcon()
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_10, 10 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_20, 20 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_30, 30 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_40, 40 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_50, 50 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_50, 55 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_60, 60 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_70, 70 ) );
	thread(f_e7_m5_objcon_setup(tv_e7_m5_objcon_h_80, 80 ) );
end

	
script static void e7m5_hallway1_setup()
		sleep_until (LevelEventStatus("hallway1_setup"), 1);		

					// Open monster closet Hallway	
			thread(e7m5_hallway_waves());
			sleep_rand_s(2, 5);
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
			vo_e7m5_infinity_02();		
		sleep_until (volume_test_players(tv_e7_m5_hallwayrusher), 1);
		
			//hallway is clear
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 0, 1);
			b_end_player_goal = TRUE;
			prepare_to_switch_to_zone_set (e7_m5);                   // starting zone switch	
			sleep_s(1);	
					
		sleep_until (not PreparingToSwitchZoneSet(), 1);
			switch_zone_set (e7_m5);	
		sleep_until( not b_e7m5_narrative_is_on, 1);		
			thread(vo_e7m5_server_room() );		
				// Roland : Spartan Miller, there's another -- admittedly pitiful -- attempt to get back into the server room.
				// Miller : Crimson, let's go show our friends why that's a bad idea.	
		//f_blip_object_cui (dc_e7m5_door_switch2, "navpoint_activate");	
			sleep_s(2);
			b_e7m5_hallway_1_clear = TRUE;
			f_new_objective(ch_7_5_3);	
			device_set_power(dc_e7m5_door_switch2, 1);
			device_set_position_track( e7m5_button2, "device:position", 0 );
			device_animate_position (e7m5_button2, 1, 0.25, 1, 0, 0);
			e7m5_open_aidoor_1();	
			//sleep_until (device_get_power(device(dc_e7m5_door_switch2)) < 1 or device_get_position(device(dc_e7m5_door_switch2)) > 0, 1);
			b_end_player_goal = TRUE;
	end		
	
script static void e7m5_hallway_waves()	
				// Place 1st section
			ai_place(sq_e7_m5_hallway1c_1);
			
			
			ai_place(sq_e7_m5_hallway1_comm);	
			sleep(1);
			ai_place(sq_e7_m5_hallway1c_3);
			ai_place( sq_e7_m5_hallway1_elite );
			sleep(5);
			ai_place(sq_e7_m5_hallway1c_1a);
			thread(e7m5_obj_hall_push());	
		sleep_until( b_e7m5_hall_push, 1);
			ai_place(sq_e7_m5_hallway1c_1b.grunt);
			ai_place(sq_e7_m5_hallway1c_1b.zeal_1);
			if game_coop_player_count() > 2 then
			  //spawn extra zealot
			 ai_place(sq_e7_m5_hallway1c_1b.zeal_2);
			end		
			
			thread(e7m5_open_halldoor_1());		
					
		sleep_until ( ai_living_count (gr_e7_m5_ff_all) <= 10  or  ( ai_living_count (gr_e7_m5_ff_all) <= 15 and s_objcon_e7_m5_hall_1 >= 20 ), 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) then
				ai_place(sq_e7_m5_hallway1c_2);
									
			end
			sleep_s(2);
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 12 and  s_objcon_e7_m5_hall_1 >= 20, 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) and s_objcon_e7_m5_hall_1 <= 70 then
				ai_place(sq_e7_m5_hallway1c_5);	
				ai_place(sq_e7_m5_hallway1c_3j);			
			end
			
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 8 and  s_objcon_e7_m5_hall_1 >= 50, 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) and s_objcon_e7_m5_hall_1 <= 70 then
				ai_place(sq_e7_m5_hallway1c_3j);				
			end			
	end	
	
	
	
script static void e7m5_obj_hall_push()
		sleep_until (volume_test_players (tv_e7_m5_hallway6), 1);	
			b_e7m5_hall_push = true;
		
			//print("Sleeping until relief");
		// Re-enforce Trigger
		//sleep_until (s_objcon_e7_m5_hall_1 >= 30, 1);
		//print("trigger hit");
		//sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 10, 1);
		//print("relief spawning");
			//thread(f_e7m5_reinforcements());	
		//sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 18, 1);	
			//if (volume_test_players(tv_e7_m5_hallwayrusher) != true) then
			//	ai_place(sq_e7_m5_hallway1_comm);
			//end
	/*		
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 16, 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) then
				ai_place(sq_e7_m5_hallway1c_relief);
			end
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 12, 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) then
				ai_place(sq_e7_m5_hallway1c_relief, 6);
			end	
			*/
		sleep_until ( ( ai_living_count (gr_e7_m5_ff_all) <= 16 and s_objcon_e7_m5_hall_1 >= 40 ), 1);
			if (volume_test_players(tv_e7_m5_hallwayrusher) != true) then	
				ai_place(sq_e7_m5_hallway1c_4);	//moar zealots		
			end
			sleep_s(8);
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 10 and  s_objcon_e7_m5_hall_1 >= 55, 1);
			if s_objcon_e7_m5_hall_1 <= 70 then				
				if game_coop_player_count() > 2 then
					ai_place(sq_e7_m5_hallway1c_4, 1);
				end		
			end	
	end
// ================================================================
// ============= AI ROOM ==========================================
// ================================================================

	script static void e7m5_airoom_open()
		sleep_until (LevelEventStatus("airoom_open"), 1);
		object_destroy(dc_e7m5_door_switch2);
			
		ai_place(sq_e7_m5_bishop_start);
		ai_place(sq_e7_m5_kni); //special knight
		thread(e7m5_airoom_shard());
		thread(f_music_e07m5_secure_server());	
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
		thread(vo_e7m5_secure_server());
						// Miller : Give em hell, Crimson!			
		thread(e7m5_airoom_waves());
	end	
	
	script static void e7m5_airoom_waves()
		sleep_s(2.5);
		ai_place_in_limbo(sq_e7_m5_pawns1);
		ai_place_with_shards(sq_e7_m5_turret_2);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 2, 1);
				//	Spawn Wall pawns1
		sleep_rand_s (4, 6);
		ai_place_in_limbo(sq_e7_m5_pawns3);
		sleep_s(1);
		thread(f_e7m5_crawlers_callouts());
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 2, 1);
				//	Spawn Wall pawns2
		//sleep_s(2.5);
		////#ai_place_in_limbo(sq_e7_m5_pawns2);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 1, 1);
				//	Spawn Wall pawns3 & bishop
		sleep_s(2.5);
		ai_place_in_limbo(sq_e7_m5_pawns4);
		sleep_s(1);
		ai_place(sq_e7_m5_bishop_2);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 3, 1);
				//	Spawn knights and bishop
		sleep_s(2);		
		ai_place_in_limbo(sq_e7_m5_airoomg_1);
		thread(f_e7m5_knights_callouts());
		sleep_s(1);
		ai_place(sq_e7_m5_bishop_1);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 1, 1);		
		sleep_s(2);
				// Spawn pawns back1
		ai_place_in_limbo(sq_e7_m5_airoomg_3);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 0, 1);
		sleep_rand_s (3, 5);
				// Spawn pawns back2
		
		ai_place_in_limbo(sq_e7_m5_ai_pawns_sniper);
		sleep(15);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 2, 1);
		sleep_rand_s (1, 3);
		ai_place_in_limbo(sq_e7_m5_pawns3);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 2, 1);		
				//	Spawn pawn relief
		sleep_s(2);
		//ai_place_in_limbo(sq_e7_m5_ai_pawns_sniper);
		ai_place_in_limbo(sq_e7_m5_airoomg_4);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 2, 1);
				//	Spawn boss & pawns
		sleep_s(3);
		ai_place_in_limbo(sq_e7_m5_airoomg_final1);

		sleep_s(2);
		print("birthing bishop");				
		thread(f_e7m5_knights_callouts());	
		thread(e7m5_knight_births());	
		sleep_s(3);	
		local long l_e7m5_turret = thread( e7m5_last_turret() );
		//ai_place_with_shards(sq_e7_m5_turret_1);
		sleep_s(4);
		sleep_until(ai_living_count(gr_e7_m5_ff_all) <= 0, 1);
		sleep_s(1);
		kill_thread(l_e7m5_turret );
		b_end_player_goal = TRUE;
	end
	
	script static void e7m5_knight_births()	
		repeat
			if (ai_living_count(sq_e7_m5_airoomg_final1) > 0) then
				ai_place_with_birth(sq_e7_m5_bishop_birth);
				sleep_s(5);
			else
				dprint("no knight to birth from");
			end
		until ((ai_living_count(sq_e7_m5_bishop_birth) > 0) or (ai_living_count(sq_e7_m5_airoomg_final1) <= 0), 1);
		dprint("out of repeat");
	end
	
	
script static void e7m5_last_turret()
	sleep_until(ai_living_count(sq_e7_m5_bishop_birth) > 0,1 );
		ai_place_with_shards(sq_e7_m5_turret_1);
end

	
	script static void e7m5_airoom_end()
		sleep_until (LevelEventStatus("airoom_end"), 1);
			b_e7m5_server_clear = TRUE;
			thread(f_music_e07m5_towards_hangar());
			//prepare_to_switch_to_zone_set (e7_m5_b);                   // starting zone switch
		//sleep_until (not PreparingToSwitchZoneSet(), 1);
			//switch_zone_set (e7_m5_b);	
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
			thread(vo_e7m5_towards_hangar());
				// Miller : Back out in the halls, Crimson. Lets head back towards the hangar.
				// Roland : Spartan Miller, there's a massive reduction in enemy forces in Crimson's area.
				// Miller : Because Crimson have shot most of them!
				// Roland : That is one possible explanation.
				
				// OBJECTIVE - OPEN BULKHEADS
		sleep_s(3);
		f_new_objective(ch_e7_m2_9);
		b_e7_m5_head_to_hanger = TRUE;
		//lz_53
				// Location check - if in AI Room breadcrumb
	/*
		if(volume_test_players (tv_e7_m5_hallway) != true) then
			// BLIP GOTO
				object_create(lz_53);
				thread(f_blip_object_cui (lz_53, "navpoint_goto"));
			sleep_until (volume_test_players (tv_e7_m5_hallway) == true);
				print("Trigger hit");
				// UNBLIP GOTO
				thread(f_blip_object_cui (lz_53, ""));				
		end
		*/
		sleep_until ( not volume_test_players (tv_e7_m5_server_hallway) , 1);
		thread(f_init_navmesh_prop());
		sleep_s(0.25);
		sleep_until( not b_e7m5_narrative_is_on, 1);
		vo_e7m5_open_bulkhead();
				// Miller : Crimson, open those doors to get access to the hangar hallway.	
				
				// Blip Door Control & Power On
		object_create(dc_e7m5_door_switch3);
		device_set_power (dc_e7m5_door_switch3, 1);
		thread( spops_blip_object (dc_e7m5_door_switch3, TRUE, "activate") );	
		device_set_position_track( e7m5_button3, "device:position", 0 );
		device_animate_position (e7m5_button3, 1, 0.25, 1, 0, 0);		
		print("sleeping until button press");	
		sleep_until (device_get_power(device(dc_e7m5_door_switch3)) < 1 or device_get_position(device(dc_e7m5_door_switch3)) > 0, 1);
		thread(e7m5_open_halldoor_2());			
		object_destroy(dc_e7m5_door_switch3);
		b_end_player_goal = TRUE;
	end		
	
// ================================================================
// ============= H HALLWAY ========================================
// ================================================================

	script static void e7m5_hhallway_start()
		sleep_until (LevelEventStatus("hhallway_start"), 1);
			dprint ("START hhallway_start");	
				// SPAWN HUNTERS
			ai_place(sq_e7_m5_hallway_hunt_l);
			ai_place(sq_e7_m5_hallway_hunt_r);
		sleep_until(volume_test_players (tv_e7_m5_hallway5), 1);
		sleep_until( not b_e7m5_narrative_is_on, 1);
			thread(vo_e7m5_hunters());
				// Miller : Hunters!
				// Roland : And there's the OTHER possible explanation for where all the bad guys went. They were running, Spartan Miller.
				// Miller : Well, Crimson's not going to run!
			sleep_s(3);
			thread( e7m5_hunters_dead_vo() );
		//dprint("Waiting for 1 hunter to die");
		//sleep_until(ai_living_count(gr_e7_m5_hallway2_wave1b) <= 1);
		//dprint("1 now on following");	
	end		
	
	
	script static void e7m5_hhallway_end()
		sleep_until (LevelEventStatus("hhallway_end"), 1);
		//print ("START hhallway_end");		
			sleep_s(1);	
			b_e7m5_hunter_hallway_clear = TRUE;
		if (ai_living_count(gr_e7_m5_ff_all) > 0) then
			f_e7m5_remaningcov_callouts();
			f_blip_ai_cui(gr_e7_m5_ff_all, "navpoint_enemy");	
		end
		sleep_until (ai_living_count(gr_e7_m5_ff_all) <= 0, 1);
			f_unblip_ai_cui(gr_e7_m5_ff_all);
			
			sleep_s(.5);
				// OBJECTIVE - PUSH TO THE HANGAR BAY
			f_new_objective(ch_7_5_5);
				// BLIP SWITCH
			object_create(dc_e7m5_door_switch4);
			device_set_power (dc_e7m5_door_switch4, 1);		
			thread(f_blip_object_cui (dc_e7m5_door_switch4, "navpoint_activate"));
			device_set_position_track( e7m5_button4, "device:position", 0 );
			device_animate_position (e7m5_button4, 1, 0.25, 1, 0, 0);
			//sleep_until (device_get_power(device(dc_e7m5_door_switch4)) < 1 or device_get_position(device(dc_e7m5_door_switch4)) > 0, 1);
			thread(e7m5_open_halldoor_3());	
				// UNBLIP SWITCH
			//thread(f_blip_object_cui (dc_e7m5_door_switch4, ""));				
			object_destroy(dc_e7m5_door_switch4);
				// change spawn points
			f_create_new_spawn_folder(95);
		
				// SPAWN SMALL GROUP BEHIND DOOR
		//ai_place(gr_e7_m5_hallway3_wave1);
		ai_place( sq_e7_m5_hallway3c_back );
		sleep(2);
		ai_place( sq_e7_m5_hallway3c_front );
		sleep(1);
		//ai_place( sq_e7_m5_hallway3c_front2 );
				// Bring in some backup 
		sleep_s(2);		
		
		ai_vehicle_enter( sq_e7_m5_hallway3c_back, veh_e7_m5_plas_1 );
		thread(e7m5_open_halldoor_4());
		ai_place(sq_e7_m5_hallway3c_front2);
		sleep(1);
		ai_place( sq_e7_m5_hw3c_kamikaze_1 );
		sleep(15);
		thread( e7m5_hallway_3_ranger_spawner());
		sleep_rand_s( 2, 4 );
		ai_grunt_kamikaze(sq_e7_m5_hw3c_kamikaze_1);
		sleep_rand_s(3, 6);
		
		sleep_until( not b_e7m5_narrative_is_on, 1);
			thread( vo_e7m5_infinity_03()) ;
				// Sleep until AI Dead
		sleep_until(ai_living_count(gr_e7_m5_ff_all)  <= 0 and b_e7_m5_hallway_ranger_done, 1);		
				// BLIP SWITCH
			sleep_s(1);
			object_create(dc_e7m5_door_switch5);
			device_set_power (dc_e7m5_door_switch5, 1);	
			//thread(f_blip_object_cui (dc_e7m5_door_switch5, "navpoint_activate"));	
			device_set_position_track( e7m5_button5, "device:position", 0 );
			device_animate_position (e7m5_button5, 1, 0.25, 1, 0, 0);
			if object_valid( dm_e7_m2_launchpad1 ) then
				object_destroy( dm_e7_m2_launchpad1 );
			end
			if object_valid( dm_e7_m2_launchpad2 ) then
				object_destroy( dm_e7_m2_launchpad2 );
			end

		//sleep_until (device_get_power(device(dc_e7m5_door_switch5)) < 1 or device_get_position(device(dc_e7m5_door_switch5)) > 0, 1);
				// UNBLIP SWITCH
		//thread(f_blip_object_cui (dc_e7m5_door_switch5, ""));			
		/////////////////////////	
		//START HANAGER SPAWNS
		///////////////////////////
		
		object_destroy(dc_e7m5_door_switch5);
		b_e7m5_hallway_2_clear = TRUE;
		e7m5_open_baydoor_1();
		f_create_new_spawn_folder (94);	
		ai_place(sq_e7_m5_bay_start1);
		ai_place(sq_e7_m5_bay_start2);
		ai_place(sq_e7_m5_bay_start3);
		
		if not object_valid( dm_e7m5_launchpad1  ) then
			object_create(dm_e7m5_launchpad1);
		end
		if not object_valid( dm_e7m5_launchpad2 ) then
			object_create(dm_e7m5_launchpad2);
		end
	
	
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 5, 1);		
			sleep_s(1);
			ai_place(sq_e7_m5_bay_commander_1);	
			
			if game_coop_player_count() > 2 then
				sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 3, 1);	
					ai_place(sq_e7_m5_bay_commander_2);
					sleep_s(1);
					ai_place_with_birth(sq_e7_m5_bay_bishop_2);
			end
			
		sleep_s(1);
		ai_place_with_birth(sq_e7_m5_bay_bishop_1);
	sleep_until ( not b_e7m5_narrative_is_on, 1);
		b_e7m5_narrative_is_on = true;
		vo_glo15_miller_reinforcements_01();
		b_e7m5_narrative_is_on = FALSE;
				
		//ai_place(sq_e7_m5_bay_closet);
		//sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
			//thread(vo_glo15_miller_covenant_02());
		//thread(e7m5_open_baydoor_2());	
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 3, 1);
			sleep_s(1);
			f_e7m5_remaningcov_callouts();
			f_blip_ai_cui(gr_e7_m5_ff_all, "navpoint_enemy");		
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 0, 1);
			f_unblip_ai_cui(gr_e7_m5_ff_all);
		
		sleep_s(2);		
				// END GOAL

		b_end_player_goal = TRUE;			
	end		
	
script static void e7m5_hunters_dead_vo()
	sleep_until(  ai_living_count( sq_e7_m5_hallway_hunt_l ) <= 0 and  ai_living_count( sq_e7_m5_hallway_hunt_r ) <= 0, 3);
		thread(f_music_e07m5_hunters_down());		
		sleep_until( not b_e7m5_narrative_is_on , 1);
			vo_e7m5_hunters_down();
				// Miller : See? Nothing to worry about. Let's get back to the hangar bay and confirm lockdown.	

end

global boolean b_e7_m5_hallway_ranger_done = FALSE;

script static void e7m5_hallway_3_ranger_spawner()

	sleep_until( ai_living_count (gr_e7_m5_ff_all) <= 6 or ai_living_count( sq_e7_m5_hallway3c_back ) == 0 or volume_test_players(tv_e7_m5_hallway_3_rear) );
		ai_place(sq_e7_m5_hallway2_ranger_1);
		
		if game_coop_player_count() > 2 then
			sleep_s(1.5);
		 ai_place( sq_e7_m5_hallway2_ranger_2 );
		end	

	sleep_s(1);
	b_e7_m5_hallway_ranger_done = TRUE;
end	
	
// ================================================================
// ============= HANGAR BAY =======================================
// ================================================================
	
	script static void e7m5_hangar_start()
		sleep_until (LevelEventStatus("hangar_start"), 1);
		print ("START hangar_start");
		thread(e7m5_rox_refiller());		
		thread(f_music_e07m5_hangar_clear());
		sleep_s(1);
		thread(f_music_e07m5_hangar_hunters());
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
		thread(vo_e7m5_entering_hangar());		
				// Miller : All quiet. Crimson wins the day.
				// Roland : Spartan?
				// Miller : Excellent work as ever, Spartans.
				// Roland : Spartan Miller.
				// Miller : What is it, Rol-- HUNTERS?!
				// Roland : Lots of them.
				
				// START LIFT & SPAWN HUNTERS
		sleep_s(5);
		thread(e7m5_lift());		// also spawns waves
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
		sleep_s(3);		
		sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
		vo_e7m5_kill_them();
				// Miller : Crimson, I know this looks nuts, but you can do this.
				// Roland : They can?!
				
				// OBJECTIVE - KILL REMAINING COVENANT
		f_new_objective(ch_7_5_6);		
		sleep_until (ai_living_count (gr_e7_m5_ff_all) <= 0, 1);		
				// END GOAL
		b_end_player_goal = TRUE;	
	end	
// =================================================================
// ====== ENDING E7 M5 =============================================
// =================================================================

script static void f_end_mission_e7_m5	()
	sleep_until (LevelEventStatus("e7_m5_mission_end"), 1);
	thread(f_music_e07m5_ending());
	sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
	vo_e7m5_shot_up();
			// Miller : That was really something else, Crimson.
			// Roland : Even for Spartans, the dedication to shooting things was... impressive.
	sleep_s(2);
	sleep_until(b_e7m5_narrative_is_on == FALSE, 1);
	vo_e7m5_you_win();
			// Miller : That's that. Crimson, you've got that corner of Infinity secured. Great work. We're gonna win this thing yet.
	sleep_s(3);
	b_wait_for_narrative_hud = false;
	b_end_player_goal = TRUE;
	thread(f_music_e07m5_finish());
	dprint ("ending the mission with fadeout and episode complete");
	fade_out( 0, 0, 0, seconds_to_frames(2.0) );
	player_control_fade_out_all_input( 0.1 );
	cui_load_screen ( 'ui\in_game\pve_outro\episode_complete.cui_screen' );	
	sleep_s( 2.0 );
end

// ====================================================================
// ====== INTRO =======================================================
// ====================================================================

script static void f_start_player_intro_e7_m5
	sleep_until(f_spops_mission_ready_complete(), 1);
	if editor_mode() then
		sleep_s (1);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e7m5_vin_sfx_intro', NONE, 1);
		//intro_vignette_e7_m5();
	end
	f_spops_mission_intro_complete( TRUE );
end

script static void intro_vignette_e7_m5
	dprint ("_____________starting vignette__________________");
	//sleep_s (8);	
	cinematic_start();	
	ai_enter_limbo (gr_e7_m5_ff_all);	
//	thread (f_music_e7m5_vignette_start());
//	b_wait_for_narrative = true;	
//	pup_play_show(e7_m5_intro);
//	vo_e7m5_intro();
//	thread (f_music_e7m5_vignette_finish());	
//	sleep_until (b_wait_for_narrative == false);
	ai_exit_limbo (gr_e7_m5_ff_all);
	cinematic_stop();
end

// ==================================================================
// ====== PISTONS ================================================
// ==================================================================
script static void e7m5_pistons
	print("pistons start!");
	if object_valid(dm_piston01) then
		device_set_power(dm_piston01, 1);
		device_set_position_track( dm_piston01, 'any:idle', 1 );
		device_animate_position(dm_piston01, 1, 8, 1, 0, 0 );
	else
		dprint("object 1 failed");
	end
	sleep_s(0.25);
	if object_valid(dm_piston02) then
		device_set_power(dm_piston02, 1);
		device_set_position_track( dm_piston02, 'any:idle', 1 );
		device_animate_position(dm_piston02, 1, 8, 1, 0, 0 );
	else
		dprint("object 2 failed");
	end
	sleep_s(0.25);
	if object_valid(dm_piston03) then
		device_set_power(dm_piston03, 1);
		device_set_position_track( dm_piston03, 'any:idle', 1 );
		device_animate_position(dm_piston03, 1, 8, 1, 0, 0 );
	else
		dprint("object 3 failed");
	end
end
// ==================================================================
// ====== OPEN DOORS ================================================
// ==================================================================

script static void e7m5_open_ventdoor_1
	//f_engine_open_door(dc_e7m5_door_switch1, e7m5_ventdoor_1, e7m5_button1);
	sleep_forever();
end

//hallway spawn closet
script static void e7m5_open_halldoor_1
	f_engine_open_monster_door(e7m5_halldoor_1);
	sleep_forever();
end


script static void e7m5_open_halldoor_2()  
	//thread( e7_m5_door_open_wait(tv_e7_m5_vent_door, e7m5_ventdoor_1, e7m5_button1 , FALSE ) );
	f_engine_open_door(dc_e7m5_door_switch3, e7m5_halldoor_2, e7m5_button3);
	sleep_forever();
end

//hallway 2 entrace
script static void e7m5_open_halldoor_3()
	thread( e7_m5_door_open_wait(tv_e7_m5_hallway_door, e7m5_halldoor_3, e7m5_button4 , TRUE ) );
	//f_engine_open_door(dc_e7m5_door_switch4, e7m5_halldoor_3, e7m5_button4);
	sleep_forever();
end


//hallway spawn closet
script static void e7m5_open_halldoor_4()
	f_engine_open_monster_door(e7m5_halldoor_4);
	sleep_forever();
end

script static void e7m5_open_aidoor_1()
	thread(e7_m5_door_open_wait(tv_e7_m5_server_door, e7m5_aidoor_1, e7m5_button2 , FALSE ) );
	sleep_until( volume_test_players( tv_e7_m5_server_door ) ,1 );
	//f_engine_open_door(dc_e7m5_door_switch2, e7m5_aidoor_1, e7m5_button2);
	//sleep_forever();
end

script static void e7m5_open_baydoor_1()
	thread( e7_m5_door_open_wait(tv_e7_m5_hanger_door, e7m5_baydoor_1, e7m5_button5 , TRUE ) );
	sleep_until( volume_test_players( tv_e7_m5_hanger_door ) ,1 );
	//f_engine_open_door(dc_e7m5_door_switch5, e7m5_baydoor_1, e7m5_button5);
	//sleep_forever();
end


//ai hanger spawn closet
script static void e7m5_open_baydoor_2()
	//thread( e7_m5_door_open_wait(tv_e7_m5_vent_door, e7m5_ventdoor_1, e7m5_button1 , FALSE ) );
	f_engine_open_monster_door(e7m5_baydoor_2);
	sleep_forever();
end

// =================================================================
// ====== BUTTON PUSHES ============================================
// =================================================================

script static void f_e7_m5_switch_pushed(object control, unit player)
	g_ics_player = player;

/*
	if control == dc_e7m5_door_switch1 then
		print("Opening ventcore");
		pup_play_show("ppt_ventcore_button");
	elseif control == dc_e7m5_door_switch2 then
		print("Opening Server");
		pup_play_show("ppt_hallway1_button");	
	elseif control == dc_e7m5_door_switch3 then
		print("Opening H Hall");
		pup_play_show("ppt_hallway2_button");		
	elseif control == dc_e7m5_door_switch4 then
		print("Opening Back hall");
		pup_play_show("ppt_hallway3_button");	
	elseif control == dc_e7m5_door_switch5 then
		print("Opening Hanger");
		pup_play_show("ppt_hallway4_button");	
	end
	
	*/
	
	if control == dc_e7m5_door_switch1 then
		print("Opening ventcore");
		pup_play_show("ppt_ventcore_button");
	elseif control == dc_e7m5_door_switch2 then
		print("Opening Server");
		pup_play_show("ppt_hallway1_button");	
	elseif control == dc_e7m5_door_switch3 then
		print("Opening H Hall");
		pup_play_show("ppt_hallway2_button");		
	elseif control == dc_e7m5_door_switch4 then
		print("Opening Back hall");
		pup_play_show("ppt_hallway3_button");	
	elseif control == dc_e7m5_door_switch5 then
		print("Opening Hanger");
		pup_play_show("ppt_hallway4_button");	
	end	
end

// =================================================================
// ====== CS STUFF============================================
// =================================================================
script command_script cs_e7_m5_pawn_spawn()
	//sleep_rand_s (0.1, 0.6);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e7_m5_knight_spawn()
	//sleep_rand_s (0.1, 0.6);
	cs_phase_in();
end
script command_script cs_e7_m5_knight_start()
	sleep_s(0.25);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	cs_phase_to_point(ps_knight.p0);
	ai_erase (ai_current_actor);
end

script command_script cs_e7_m5_knight_spawnbirth()
	//sleep_rand_s (0.1, 3);
	ai_exit_limbo(ai_current_actor);
	cs_phase_in();
end

script static void e7m5_airoom_shard()
	ai_place_with_shards(sq_e7_m5_pawns_shard);
	sleep_s(5);
	sleep_until (ai_living_count(sq_e7_m5_pawns_shard) > 1);	
	print("shard attempt completed");
	if (ai_living_count(sq_e7_m5_bishop_start) > 0) then
		ai_set_objective(sq_e7_m5_bishop_start, ai_e7_m5_flying);
	end
	print("success objective change");
end


// ==================================================================
// ====== LIFT ======================================================
// ==================================================================
script static void e7m5_lift()
	if not object_valid( dm_e7m5_launchpad1  ) then
		object_create(dm_e7m5_launchpad1);
	end
	if not object_valid( dm_e7m5_launchpad2 ) then
		object_create(dm_e7m5_launchpad2);
	end

	if object_valid( dm_e7_m2_launchpad1 ) then
		object_destroy( dm_e7_m2_launchpad1 );
	end
	if object_valid( dm_e7_m2_launchpad2 ) then
		object_destroy( dm_e7_m2_launchpad2 );
	end
		
	thread(e7m5_lift_rail1());
	thread(e7m5_lift_rail2());
	
	//gmurphy 12-20-2012 -- enabling the kill_lift volume after the lift is up to kill any AI that might have fallen through
	//bug 10795
	thread (e7m5_lift_kill());
	
	ai_place(sq_e7_m5_bay_lift1);	
	ai_place(sq_e7_m5_bay_hunt_r);
	ai_place( sq_e7_m5_bay_bishop_4	);	
	
	sleep_s(0.25); // waiting for ai to spawn
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_lift_01_in', dm_e7m5_launchpad1, 1);
	device_set_position_track( dm_e7m5_launchpad1, "any:idle", 0.0 );
	device_animate_position( dm_e7m5_launchpad1, 1, 8, 1.0, 1.0, 0 );
	ai_place_with_shards(sq_e7_m5_bay_turret_1);
	sleep_s(7);
	ai_place(sq_e7_m5_bay_lift2);	
	ai_place(sq_e7_m5_bay_hunt_l);	
	ai_place( sq_e7_m5_bay_bishop_3	);	
	sleep_s(0.25);
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_lift_01_in', dm_e7m5_launchpad2, 1);
	device_set_position_track( dm_e7m5_launchpad2, "any:idle", 0.0 );
	device_animate_position( dm_e7m5_launchpad2, 1, 10, 1.0, 1.0, 0 );	
	ai_place_with_shards(sq_e7_m5_bay_turret_2);
	sleep_forever();
end

script static void e7m5_lift_rail1()	
	print("waiting for lift");
	sleep_until(device_get_position(device(dm_e7m5_launchpad2)) >= 1, 1);
	print("lift up");
	device_set_position_track( dm_railing2, "any:idle", 0.0 );
	device_animate_position( dm_railing2, 1, 2, 1.0, 1.0, 0 );	
	object_move_to_point(block_nav1, 0, ps_lift.p0);
end
script static void e7m5_lift_rail2()
	print("waiting for lift");
	sleep_until(device_get_position(device(dm_e7m5_launchpad1)) >= 1, 1);
	print("lift up");
	device_set_position_track( dm_railing1, "any:idle", 0.0 );
	device_animate_position( dm_railing1, 1, 2, 1.0, 1.0, 0 );	
	object_move_to_point(block_nav2, 0, ps_lift.p1);
end

//gmurphy 12-20-2012 -- bug 10795
script static void e7m5_lift_kill
	print ("enabling kill_lift volume when the lift is all the way up");
	sleep_until(device_get_position(dm_e7m5_launchpad2) >= 1 and device_get_position(dm_e7m5_launchpad1) >= 1);
	
	print ("kill volume enabled");
	kill_volume_enable (kill_volume_lifts);
end
// ==================================================================
// ====== ROCKET LOOP ===============================================
// ==================================================================
script static void e7m5_rox_refiller()
	repeat
		f_add_crate_folder(cr_e7_m5_rox);
		sleep_s(10);
	until (ai_living_count (gr_e7_m5_ff_all) <= 0);
end
// ==================================================================
// ====== VO CALLOUTS ===============================================
// ==================================================================

script static void f_e7m5_knights_callouts()
	repeat
		print ("knights event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo_knights_01();
			vo_glo_knights_02();
			vo_glo_knights_03();
			vo_glo_knights_04();
			vo_glo_knights_05();		
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end

script static void f_e7m5_remaningcov_callouts()
	repeat
		print ("cov remaining event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo15_miller_few_more_03();
			vo_glo15_miller_few_more_05();
			vo_glo15_miller_few_more_07();
			//vo_glo_remainingcov_04();
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end

script static void f_e7m5_heavyforces_callouts()
	repeat
		print ("heavy forces event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo_heavyforces_01();
			vo_glo_heavyforces_03();
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end

script static void f_e7m5_crawlers_callouts()
	repeat
		print ("crawlers event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo_crawlers_01();
			vo_glo_crawlers_02();
			//vo_glo_crawlers_03();
			//vo_glo_crawlers_04();
			//vo_glo_crawlers_05();
			vo_glo15_miller_crawlers_01();
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end

script static void f_e7m5_watcher_callouts()
	repeat
		print ("watchers event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo_watchers_01();
			vo_glo_watchers_02();
			vo_glo_watchers_03();
			vo_glo_watchers_04();
			vo_glo_watchers_05();
			vo_glo15_miller_watchers_01();
			vo_glo15_miller_watchers_02();
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end

script static void f_e7m5_reinforcements()
	repeat
		print ("watchers event");
		
		sleep_until (b_e7m5_narrative_is_on == false, 1);
		b_e7m5_narrative_is_on = true;

		begin_random_count (1)
			vo_glo15_miller_reinforcements_01();
			vo_glo15_miller_reinforcements_02();
			vo_glo15_miller_reinforcements_03();
		end		
		b_e7m5_narrative_is_on = false;		
	until (b_e7m5_narrative_is_on == false);
end



						
						
						// scale
		
script static void e7_m5_ai_watcher_spawn(  ai ai_placed, cutscene_flag flg_loc, string_id sid_objective )
	
	ai_place_in_limbo( ai_placed );
	
	
	local object obj_placed = ai_get_object( ai_placed );

	object_set_scale( obj_placed, 0.0001, 0 );
	sleep(1);
	object_move_to_flag( obj_placed, 0, flg_loc );
	// portal fx
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect', flg_loc );
	sleep_s( 0.50 );
	
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	sleep_s( 0.25 );
	
	// scale in
	object_set_scale( ai_get_object(ai_placed), 1.0, 50 );
	
	// set objective
	if sid_objective != NONE then
		ai_set_objective( ai_placed, sid_objective );
	end
	
	// exit limbo
	ai_exit_limbo( ai_placed );
	
	// kill fx
	sleep_s( 0.50 );
	effect_kill_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	effect_delete_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );

end


script static void debug_e7_m5()

	game_set_variant ( e7_m5_engine_roadtrip );
end

script static void meh()
	thread( e7_m5_door_open_wait(tv_e7_m5_vent_door, e7m5_ventdoor_1, e7m5_button1 , FALSE ) );
end
//
script static void e7_m5_door_open_wait( trigger_volume tv, device dm_door,  device dm_switch, boolean b_stay_open)

		device_set_position_track( dm_switch, "device:position", 0 );
		device_animate_position (dm_switch, 1, 0.25, 1, 0, 0);
		
		
	if 	b_stay_open then
		sleep_until( volume_test_players( tv ), 1 );
			thread(e7_m5_engine_open_door(dm_door));	
	else
		repeat
			sleep_until( volume_test_players( tv ), 1 );
				thread(e7_m5_engine_open_door(dm_door));
				sleep_s(7);
			sleep_until( not volume_test_players( tv ), 1 );
				thread(e7_m5_engine_close_door(dm_door));
		until( FALSE, 15 );
	end

end


script static void e7_m5_engine_open_door( device dm_door)
	dprint("dlc_engine.hsc: opening door");
	// wait for pup to play
	//device_animate_position (dm_switch, 0, 2.5, 1, 0, 0);
		
	sleep_s(1);
	
	device_set_position_track( dm_door, 'any:idle', 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1);
	
	device_animate_position( dm_door, 1, 3.5, 1.0, 1.0, TRUE );
	
	sleep_until( (device_get_position(dm_door) >= 0.6), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	
	
end


script static void e7_m5_engine_close_door( device dm_door)
	print("dlc_engine.hsc: closing door");
	//device_set_position_track( dm_switch, 'any:idle', 0 );
		


	//device_set_position_track( dm_door, 'any:idle', 0 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_set', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1 );
	
	device_animate_position (dm_door, 0, 2, 1, 0, 0);
	
	sleep_until( (device_get_position(dm_door) <= 0.0), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_end_set', dm_door, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	
end

script command_script cs_active_camo_use()
	if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		dprint( "cs_active_camo_use: ENABLED" );
		thread( f_e7m5_active_camo_manager(ai_current_actor) );
	end
end


script static void f_e7m5_active_camo_manager( ai ai_actor )
 local long l_timer = 0;
 local object obj_actor = ai_get_object( ai_actor );
	//dprint( "cs_active_camo_use: ENABLED" );

	repeat
	
		// activate camo
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, TRUE );
			dprint( "f_active_camo_manager: ACTIVE" ); 
		end
		
		// disable camo
		sleep_until( (unit_get_health(ai_actor) <= 0.0) or   objects_distance_to_object(Players(),obj_actor) <= 6.5  or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 3 );
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, FALSE );
			dprint( "f_active_camo_manager: DISABLED" ); 
		end
		
		// manage resetting
		if ( unit_get_health(ai_actor) > 0.0 ) then
			l_timer = timer_stamp( 2.5, 5.0 );
			sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
		end
		if ( unit_get_health(ai_actor) > 0.0 ) then
			dprint( "f_active_camo_manager: RESET" ); 
		end
	
	until ( unit_get_health(ai_actor) <= 0.0, 1 );

end


script static void f_e7_m5_objcon_setup( trigger_volume tv, real value)


	sleep_until (volume_test_players (tv) or s_objcon_e7_m5_hall_1 >= value, 1);
		if s_objcon_e7_m5_hall_1 <= value then
			s_objcon_e7_m5_hall_1 = value;
			dprint("s_objcon_e10_m3 = ");
			inspect(s_objcon_e7_m5_hall_1);
		end
end


/*
script static void f_e10_m3_objcon_10()


	sleep_until (volume_test_players (tv_e10_m3_objcon_10) or s_objcon_e10_m3 >= 10, 1);
		if s_objcon_e10_m3 <= 10 then
			s_objcon_e10_m3 = 10;
			dprint("s_objcon_e10_m3 = 10 ");
		end
end
*/