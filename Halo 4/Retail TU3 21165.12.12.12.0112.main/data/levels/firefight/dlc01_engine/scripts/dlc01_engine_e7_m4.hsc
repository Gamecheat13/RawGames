// =========================================================================================
// =========== ENGINE E7M4 FIREFIGHT SCRIPT ================================================
// =========================================================================================
global long l_bulkheads_remaining = 5;
global long l_jammers_remaining = 3;
global boolean b_e7_m4_marine_follow = FALSE; 
global boolean b_e7_m4_bulkhead1 = FALSE; 
global boolean b_e7m4_stop_firing = FALSE; 
global boolean b_e7m4_start_firing = FALSE; 
global boolean b_e7m4_hallway_end = FALSE; 

script startup dlc01_engine_e7_m4
	if ( f_spops_mission_startup_wait("e7_m4") ) then
		wake( dlc01_engine_e7_m4_init );
	end
end

script startup e7m4_holo_effect
	effect_new(levels\firefight\dlc01_engine\fx\airoom_server_holo.effect, fx_mkr_server_center );
end

script dormant dlc01_engine_e7_m4_init
	//Start the intro
	sleep_until (LevelEventStatus("e7_m4"), 1);
	dprint ("**************STARTING E7 M4******************");  
	f_spops_mission_setup("e7_m4", e7_m4, gr_e7_m4_ff_all, sc_e7_m4_spawn_point_0, 90);
	
	thread(f_start_player_intro_e7_m4());	
	thread (e7m4_start_mission());
	thread (f_start_all_events_e7_m4());	//thread the rest of the event threads
	
//============ OBJECTS ==================================================================
	// Set Crate names
	f_add_crate_folder(cr_e7_m4_unsc_cover);
	f_add_crate_folder(cr_e7_m4_unsc_ammo);
	f_add_crate_folder(cr_e7_m4_cov_cover);	
	f_add_crate_folder(e7_m4_controls);	
	f_add_crate_folder(ma_e7_m4_doors);
	f_add_crate_folder(eq_e7_m4_ammo);
	f_add_crate_folder(wp_e7_m4_weapons);
	f_add_crate_folder(e7_m4_turrets);

	
// set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_0, 90); //spawns in the main starting area (engine room)
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_1, 91); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_2, 92); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_3, 93); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_4, 94); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_5, 95); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_6, 96); 
	firefight_mode_set_crate_folder_at(sc_e7_m4_spawn_point_7, 97); 
	

// controls
	firefight_mode_set_objective_name_at(dc_e7m4_ventcore, 1); 		// mission complete	

// covenant objects
	firefight_mode_set_objective_name_at(ventroom_base1, 10); 					// objective button to enable observation deck 
	firefight_mode_set_objective_name_at(ventroom_base2, 11); 					// objective button to enable observation deck 
	firefight_mode_set_objective_name_at(ventroom_base3, 12); 					// objective button to enable observation deck 

// locations
	firefight_mode_set_objective_name_at(lz_41, 50); 							//objective move to location outside engine hallway
	
// set squad group names

	// Engine Room
	firefight_mode_set_squad_at(sq_e7_m4_engine_1a, 1);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_1b, 2);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_1c, 8);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_1d, 9);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_2a, 3);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_2b, 10);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_3a, 4);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_3b, 21);			
	firefight_mode_set_squad_at(sq_e7_m4_engine_4a, 5);		
	firefight_mode_set_squad_at(sq_e7_m4_engine_4b, 6);		


	// Hallway 1
	firefight_mode_set_squad_at(sq_e7_m4_marines, 11);
	firefight_mode_set_squad_at(sq_e7_m4_marines_door, 18);
	
	// Ventcore Room Stage 1
	firefight_mode_set_squad_at(sq_e7_m4_ventcore_rangers, 81);			// elite squad
	firefight_mode_set_squad_at(gr_e7_m4_ventcore_wave_hunter, 82);			// hunters backup
	firefight_mode_set_squad_at(sq_e7_m4_ventcore_def1, 83);			// defense 1
	firefight_mode_set_squad_at(sq_e7_m4_ventcore_def2, 84);			// defense 2
	firefight_mode_set_squad_at(sq_e7_m4_ventcore_end, 85);				// grunt relief
	firefight_mode_set_squad_at(gr_e7_m4_ventcore_wave_grunt, 86);				// grunt relief


	// Enable soft Kill	
	f_spops_mission_setup_complete( TRUE );		
end

	
// ================================================================
// ========= E7 M4 - MAIN SCRIPTS =================================
// ================================================================	

//threading all the event scripts that are called through the gameenginevarianttag
script static void f_start_all_events_e7_m4
	dprint ("threading all the event scripts");
	//event tags		
	thread (e7m4_engine_room());
	thread (e7m4_hallway_start());	
	thread (e7m4_ventcore_start());		
	thread (e7m4_ventcore_end());		
	thread (e7m4_ventcore_hunters());		
	thread (e7m4_enable_system());		
	thread (e7m4_end_mission());		
	thread (f_start_engine_doors());	
	thread (f_bulkhead_close_doors());						
	thread (e7m4_extra_spawns());
	thread (f_music_e07m4_start());
	//thread (e7m4_teleport_debug());
end

// ================================================================
// ========= STARTING E7 M4 - ENGINE ==============================
// ================================================================	
script static void e7m4_start_mission		// Engine Room
	sleep_until (LevelEventStatus("start_mission"), 1);
	dprint ("START start_mission");
	sleep_until( f_spops_mission_start_complete(), 1 );	
	thread(f_music_e07m4_seal_engine());		
	dprint ("Players Spawned!");	
	dprint ("Dec 7 | 1:00AM");	
	sleep_s(4);
	// VO suggesting incoming covies
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	thread(vo_e7m4_rolandsayshello());
	sleep_s(2);
	f_new_objective(ch_7_4_1);
	object_create(lz_42);
	f_blip_object_cui (lz_42, "navpoint_enemy_vehicle");
	thread (e7m4_blipcheck());
	b_end_player_goal = TRUE;
			// ENDING TIME PASS 1
end

script static void e7m4_engine_room	
	sleep_until (LevelEventStatus("e7_m4_engine_room_script"), 1);	
	kill_volume_enable(playerkill_tv_e7_m4_server1);
	kill_volume_enable(playerkill_tv_e7_m4_server2_soft);
	ai_place(sq_e7_m4_engine_1push);	
	ai_place(sq_e7_m4_engine_1a2);		
	thread(e7m4_engine_longrange());	
	sleep_until (b_e7_m4_bulkhead1 == TRUE);
	thread(e7m4_vo_bulkheads());
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 7, 1);
	ai_set_objective(gr_e7_m4_ff_all, ai_e7_m4_engine_follow);	
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 4, 1);	
	b_end_player_goal = TRUE;
	sleep_s(2);
			// ENDING TIME PASS 2
	thread(e7m4_engine_waves());
	sleep_until (l_bulkheads_remaining <= 0, 1);	
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 0, 1);
	f_unblip_ai_cui(gr_e7_m4_ff_all);
	f_create_new_spawn_folder(95);
	thread(f_music_e07m4_lockdone());
	f_add_crate_folder(cr_e7_m4_unsc_cover);
	sleep_s(2);
	prepare_to_switch_to_zone_set (e7_m4_a);                   // starting zone switch
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e7_m4_a);
	current_zone_set_fully_active();
	f_add_crate_folder(cr_e7_m4_unsc_cover);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_gotocore();
			// Roland: Spartan Miller!  Infinity's aft defenses are offline!
			// Miller : What?  How?
			// Roland : Weapon cooling systems are deactivated.
			// Roland : Weapons overheated and safety protocols kicked in.
			// Roland : We're defenseless.
			// Miller : Crimson, aft weapon control is just off the engine room.
			// Miller : I'm sending you to help.
	thread(f_music_e07m4_gotocore());
				// OBJECTIVE - GET TO THE COOLING ROOM
	f_new_objective(ch_7_4_3);
	b_end_player_goal = TRUE;		
			// ENDING TIME PASS 3
end	
script static void e7m4_blipcheck
	repeat
		if (volume_test_players (tv_e7_m4_intro) == true) then
			dprint("trigger hit, removing blip");
			sleep_s(2);
			f_blip_object_cui (lz_42, "");
			object_destroy(lz_42);
		elseif (ai_living_count(sq_e7_m4_engine_1b) > 0) then
			dprint("AI count reached, removing blip");
			sleep_s(2);
			f_blip_object_cui (lz_42, "");
			object_destroy(lz_42);
		end 
	until (object_valid(lz_42) == false);	
end
// ================================================================
// ========= HALLWAY PHASE 1 ======================================
// ================================================================
script static void e7m4_hallway_start			
	sleep_until (LevelEventStatus("hallway_start"), 1);		
	dprint("starting hallway");
	ai_place(sq_e7_m4_hallway_2);
	ai_place(sq_e7_m4_hallway_3);
			// OPEN HALLWAY DOOR
	thread (e7m4_open_intro_door());	
	sleep_until (volume_test_players (tv_e7_m4_hallway_start) == true, 1);
	f_engine_close_monster_door(intro_door_1);
			// Waiting until door closes
	sleep_until(device_get_position(intro_door_1) == 0, 1);
	volume_teleport_players_not_inside (tv_e7_m4_tele, fl_e7_m4_tele);											// 12-20-12: https://trochia:8443/browse/MNDE-10802
	prepare_to_switch_to_zone_set (e7_m4_b);                   // starting zone switch
	sleep_until (not PreparingToSwitchZoneSet(), 1);
//	volume_teleport_players_not_inside (tv_e7_m4_tele, fl_e7_m4_tele);	
	switch_zone_set (e7_m4_b);
	current_zone_set_fully_active();
	dprint("switching ai objective");
	ai_set_objective(sq_e7_m4_marines_door, ai_e7_m4_hallway_marines);
	thread(e7m4_loadafterswitch());
	dprint("waiting for wave to deplete");
	sleep_until(ai_living_count(gr_e7_m4_ff_all) <= 8, 1);
	dprint("let the attack commence!");
			// Make sure jammers are immune
	object_cannot_take_damage(ventroom_base1);
	object_cannot_take_damage(ventroom_base2);
	object_cannot_take_damage(ventroom_base3);	
			// OPEN FLOOD GATES
	thread (e7m4_open_vent_door1());
	pup_play_show("cruiser_explosion");
	sleep_until(b_e7m4_narrative_is_on == FALSE, 1);
	vo_e7m4_infinity_01();
	ai_place(sq_e7_m4_hallway_4);		
	dprint("waiting til 8 left");
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 8, 1);	
	if (volume_test_players (tv_e7_m4_hallway_end) != true) then
		dprint("spawning relief 1");
		ai_place(sq_e7_m4_hallway_5a);
		ai_place(sq_e7_m4_hallway_5b);
	else
		b_e7m4_hallway_end = true;
		dprint("ending spawning");
	end
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 8, 1);	
			// Spawn Heroic/Legendary Wave
	if (b_e7m4_hallway_end != true and volume_test_players (tv_e7_m4_hallway_end) != true and game_coop_player_count() > 2) then
		ai_place(sq_e7_m4_hallway_6);
		dprint("spawning relief hard 2");
	end
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 8, 1);	
			// Spawn Final Wave
	if (b_e7m4_hallway_end != true and volume_test_players (tv_e7_m4_hallway_end) != true and game_coop_player_count() > 2) then
		dprint("spawning relief 2");
		ai_place(sq_e7_m4_hallway_5a);
		ai_place(sq_e7_m4_hallway_5b);
	elseif (b_e7m4_hallway_end != true and volume_test_players (tv_e7_m4_hallway_end) != true and game_coop_player_count() <= 2) then
			dprint("spawning relief 2 for 2 or less players");
		ai_place(sq_e7_m4_hallway_5a);
	end		
	dprint("waiting til 2 left");
	sleep_until (ai_living_count (gr_e7_m4_ff_all) <= 6, 1);
	ai_set_objective(gr_e7_m4_ff_all, ai_e7_m4_hallway_follow);
	sleep_until (ai_living_count (gr_e7_m4_ff_all) <= 0, 1);
	b_e7_m4_marine_follow = TRUE;	
	ai_place(sq_e7_m4_ventcore_front);
	ai_place(sq_e7_m4_ventcore_mid);
	ai_place(sq_e7_m4_ventcore_def1);
	ai_place(sq_e7_m4_ventcore_def2);
	ai_place(sq_e7_m4_ventcore_def3);
	sleep_until (volume_test_players (tv_e7_m4_ventcore) == true, 1);	
	sleep_s(1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_incore();
	thread(f_music_e07m4_incore());
		// Miller : Roland, what are those?
		// Roland : Jammers. They're blocking the hardware comm systems in here, causing the cooling system to malfunction.
		// Miller : Clear 'em, Crimson!	
	b_end_player_goal = TRUE;
end
script static void e7m4_loadafterswitch	
	f_add_crate_folder(cr_e7_m4_cov_objects);
	f_add_crate_folder(cr_e7_m4_cov_cover);
	f_add_crate_folder(cr_e7_m4_unsc_cover);
	f_add_crate_folder(cr_e7_m4_unsc_ammo);
	object_create(dm_piston01); 
	object_create(dm_piston02);
	object_create(dm_piston03);

	f_init_navmesh_prop();
end


// ================================================================
// ========= VENTCORE ROOM ========================================
// ================================================================
script static void e7m4_ventcore_start		
	sleep_until (LevelEventStatus("ventcore_start"), 1);	
			// OBJECTIVE - DESTROY THE JAMMERS	
	f_new_objective(ch_7_4_4);	
	object_can_take_damage(ventroom_base1);
	object_can_take_damage(ventroom_base2);
	object_can_take_damage(ventroom_base3);
	thread(e7m4_vo_destroy());
	sleep_until(b_e7m4_narrative_is_on == FALSE, 1);
	vo_e7m4_infinity_02();
end

script static void e7m4_ventcore_end
	sleep_until (LevelEventStatus("ventcore_end"), 1);
			// Waiting for VO to end
	sleep_until(ai_living_count(gr_e7_m4_ff_all) <= 4);
	ai_set_objective(gr_e7_m4_ff_all, ai_e7_m4_ventcore_follow);
	sleep_until(b_e7m4_narrative_is_on == FALSE, 1);
	sleep_s(2);
			// VO suggesting incoming covies
	f_e7m4_incoming();	
	b_end_player_goal = TRUE;
end

script static void e7m4_ventcore_hunters
	sleep_until (LevelEventStatus("ventcore_hunters"), 1);
	thread (e7m4_open_vent_door2());
	sleep(10);
	thread(f_music_e07m4_hunters());
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_hunters();
			// Roland : Spartan!  Hunters have entered the area!
			// Miller : You can take them, Crimson!
	sleep_s(1);	
			// OBJECTIVE - ELIMINATE THE HUNTERS
	f_new_objective(ch_7_4_hunter); 
	sleep_rand_s(2, 5);
	sleep_until(b_e7m4_narrative_is_on == FALSE, 1);
	vo_e7m4_infinity_03();
	sleep_until(ai_living_count(gr_e7_m4_ff_all) <=0, 1);
	thread(f_music_e07m4_enablecore());
	sleep_s(5);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
		vo_e7m4_enablecore();
		// Roland : Got it!  Marking the controls for Crimson now.
		// Miller : And these will bring the guns back online?
		// Roland : Yes!  Why would I tell Crimson to press buttons that don't do anything?!
	b_end_player_goal = TRUE;
end		

script static void e7m4_enable_system	
	sleep_until (LevelEventStatus("enable_system"), 1);
	object_create(dc_e7m4_ventcore);
	device_set_power(dc_e7m4_ventcore, 1); 	
			// OBJECTIVE - ENABLE SYSTEMS
	f_new_objective(ch_7_4_5);
end
	
// =================================================================
// ====== ENDING E7 M4 =============================================
// =================================================================
script static void e7m4_end_mission
	sleep_until (LevelEventStatus("end_mission"), 1);		
	object_destroy(dc_e7m4_ventcore);
	thread(e7m4_pistons_start());
	object_create(engine_piston_loop_01);
	object_create(engine_piston_loop_02);
	object_create(engine_piston_loop_03);
	
	sleep_s(2);
	dprint ("==============================================================");
	dprint ("================= combat all done =============================");
	dprint ("==============================================================");	
	thread(f_music_e07m4_finish());
	b_e7m4_start_firing = true;
	ai_place (sq_e7_m4_missle_turrets);
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_cruiser_explosion_in', none, 1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_online();
			// Roland : See?  Worked perfectly.
			// Roland : Guns are back online.
			// Roland : Enjoy the fireworks, Crimson.
			// Miller : Yeah!		
//	sleep_s(10);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_ending();
			// Miller : You’re really knocking some heads together, Crimson! Let’s take down the rest of these freaks and call it a day.
	sleep_s(1);
	b_end_player_goal = TRUE;	
	dprint ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input( 0.1 );
	cui_load_screen( 'ui\in_game\pve_outro\chapter_complete.cui_screen' );
	ai_erase_all();
	sleep_s( 2.0 );	
end

// =================================================================
// ====== INTRO ====================================================
// =================================================================
script static void f_start_player_intro_e7_m4
	sleep_until(f_spops_mission_ready_complete(), 1);
	if editor_mode() then
		sleep_s (1);
	else

//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e7m4_vin_sfx_intro', NONE, 1);
		intro_vignette_e7_m4();
	end
	f_spops_mission_intro_complete( TRUE );
end

script static void intro_vignette_e7_m4
	dprint ("_____________starting vignette__________________");
	//sleep_s (8);	
//	cinematic_start();	
//	ai_enter_limbo (gr_e7_m4_ff_all);	
//	thread (f_music_e7m2_vignette_start());
//	b_wait_for_narrative = true;
//	pup_play_show(e7_m2_intro);
//	vo_e7m2_intro();
//	thread (f_music_e7m2_vignette_finish());	
//	sleep_until (b_wait_for_narrative == false);
//	ai_exit_limbo (gr_e7_m4_ff_all);
//	cinematic_stop();
end
// =========================================================
// ====== SPAWNS ===========================================
// =========================================================
script static void e7m4_engine_waves
			// Door 2 Open and Spawn	
	ai_place(sq_e7_m4_engine_2a);
	ai_place(sq_e7_m4_engine_2b);
	ai_place(sq_e7_m4_engine_2side);
	notifylevel("bulkhead_doors2"); 
	f_create_new_spawn_folder(94);
	sleep_until(ai_living_count(gr_e7_m4_ff_all) <= 14, 1);
			// Drop guys from above
	ai_place(sq_e7_m4_engine_2top);
	dprint("sleep until button");
	sleep_until (l_bulkheads_remaining <= 3, 1);
	dprint("button pushed");	
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 2, 1);
	sleep_s(2);
			// change spawn points
	f_create_new_spawn_folder(94);	
	sleep_s(1);
				// Pressure	
	ai_place(sq_e7_m4_engine_top_left);
	ai_place(sq_e7_m4_engine_3a);

		ai_place(sq_e7_m4_engine_3b);

		// Door 3 Open and Spawn
	notifylevel("bulkhead_doors3"); 				
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 12, 1);	
	ai_place(sq_e7_m4_engine_top_gruntl);
	if game_coop_player_count() > 2 then
		ai_place(sq_e7_m4_engine_2side);
	end
	sleep_until (l_bulkheads_remaining <= 2, 1);
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 8, 1);	
	sleep_s(1);	
			// change spawn points
	f_create_new_spawn_folder(93);	
	sleep_s(1);
			// Door 5 Open and Spawn
	ai_place(sq_e7_m4_engine_4b);
	ai_place(sq_e7_m4_engine_4c);	
	notifylevel("bulkhead_doors5"); 
	dprint("sleep until button");
	sleep_s(5);
	if game_coop_player_count() > 2 then
		ai_place(sq_e7_m4_engine_4side);
	end
	sleep_until (l_bulkheads_remaining <= 1, 1);
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 2, 1);
	sleep_s(1);	

				// change spawn points
	f_create_new_spawn_folder(93);	
	sleep_s(1);
				// Door 4 Open and Spawn
	ai_place(sq_e7_m4_engine_4a);
	ai_place(gr_e7_m4_engine_rangers);
	if game_coop_player_count() > 2 then
		ai_place(sq_e7_m4_engine_top_gruntr);
	end
	notifylevel("bulkhead_doors4"); 
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 12, 1);
	ai_place(sq_e7_m4_engine_4side);	
	sleep_until (ai_living_count(gr_e7_m4_ff_all) <= 5, 1);
	sleep_until(b_e7m4_narrative_is_on == FALSE, 1);
	sleep_s(1);
	if (ai_living_count(gr_e7_m4_ff_all) > 0) then
		f_e7m4_remaningcov();
		f_blip_ai_cui(gr_e7_m4_ff_all, "navpoint_enemy");
	end
end
script static void e7m4_engine2_relief
	sleep_s(5);
	sleep_until(ai_living_count(sq_e7_m4_engine_2side) <= 4, 1);
	ai_place(sq_e7_m4_engine_2side);
end
script static void e7m4_engine4_relief
	sleep_until(ai_living_count(sq_e7_m4_engine_4side) <= 4, 1);
end
script static void e7m4_engine_longrange
	sleep_until(ai_living_count(sq_e7_m4_engine_1c) > 0, 1);
	sleep_until(ai_living_count(sq_e7_m4_engine_1c) <= 2, 1);
	if (l_bulkheads_remaining == 5) then
		ai_place(sq_e7_m4_engine_1long);
	end
	sleep_until(ai_living_count(sq_e7_m4_engine_1b) > 0, 1);
	sleep_s(5);
	sleep_until(ai_living_count(gr_e7_m4_ff_all) <= 10, 1);
	if ((ai_living_count(sq_e7_m4_engine_1b) > 5) and (l_bulkheads_remaining == 5)) then
		ai_place(sq_e7_m4_engine_1long);
	end
end
// =============================================================================
// ====== COUNTER VO'S =========================================================
// =============================================================================
script static void e7m4_vo_bulkheads	
	if (ai_living_count(gr_e7_m4_engine_wave_1) > 5) then
		sleep_until (b_e7m4_narrative_is_on == false, 1);
		vo_glo15_miller_few_more_02();
		sleep_until (LevelEventStatus("bulkhead_doors2"), 1);	
		sleep_until(global_narrative_is_on == false, 1);
		vo_e7m4_lockprogress1();
	else
		sleep_until (b_e7m4_narrative_is_on == false, 1);
		vo_e7m4_lockprogress1();
	end	
	//vo_e7m4_lockprogress1();
			// Miller : That's one door secure.  Move on to the next.	
	sleep_until (l_bulkheads_remaining == 3, 1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_lockprogress2();
			// Miller : That'll keep them out for awhile.  Get the others sealed.
	sleep_until (l_bulkheads_remaining == 2, 1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_lockprogress3();
			// Miller : Excellent work.  Engine room's nearly locked down.
	sleep_until (l_bulkheads_remaining == 1, 1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_lockprogress4();
			// Miller : One more to go!  Great work.
	sleep_until (l_bulkheads_remaining == 0, 1);
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_lockprogress5();
			// Miller : That's it!  Last one!
end

script static void e7m4_vo_destroy
	thread(e7m4_jammer1());
	thread(e7m4_jammer2());
	thread(e7m4_jammer3());
	sleep_until(l_jammers_remaining == 2, 1);	
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_1stoverride();
			// Miller : One down.  Two to go.
	sleep_until(l_jammers_remaining == 1, 1);	
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_2ndoverride();
			// Miller : That's two!
			// Roland : One to go!
	sleep_until(l_jammers_remaining == 0, 1);	
	thread(f_music_e07m4_3rdoverride());
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_3rdoverride();
			// Roland : That's all three overrides.
	dprint("***Long silent pause***");
			// Miller : The guns are still not firing.
			// Roland : So I noticed.
			// Roland : Trying to find out why, but you humans are awful at writing technical manuals.
			// Roland : A moment, please.
end
script static void e7m4_jammer1
	sleep_until(object_valid(ventroom_base1) == FALSE, 1);
	l_jammers_remaining = l_jammers_remaining - 1;
end
script static void e7m4_jammer2
	sleep_until(object_valid(ventroom_base2) == FALSE, 1);
	l_jammers_remaining = l_jammers_remaining - 1;
end
script static void e7m4_jammer3
	sleep_until(object_valid(ventroom_base3) == FALSE, 1);
	l_jammers_remaining = l_jammers_remaining - 1;
end
// =============================================================================
// ====== OPEN DOORS ===========================================================
// =============================================================================
script static void f_start_engine_doors	
	thread (e7_m4_door1_open());
	thread (e7_m4_door2_open());
	thread (e7_m4_door3_open());
	thread (e7_m4_door4_open());
	thread (e7_m4_door5_open());
	thread (e7_m4_door6_open());
	thread (e7m4_open_vent_door3());	
end
script static void e7_m4_door1_open
	sleep_until (LevelEventStatus("bulkhead_open1"), 1);	
	f_engine_open_monster_door(engine_door_1);
	sleep_forever();
end
script static void e7_m4_door2_open
	sleep_until (LevelEventStatus("bulkhead_doors2"), 1);	
	f_engine_open_monster_door(engine_door_2);
	sleep_forever();
end
script static void e7_m4_door3_open
	sleep_until (LevelEventStatus("bulkhead_doors3"), 1);
	f_engine_open_monster_door(engine_door_3);
	sleep_forever();
end
script static void e7_m4_door4_open
	sleep_until (LevelEventStatus("bulkhead_doors4"), 1);
	f_engine_open_monster_door(engine_door_4);	
	sleep_forever();
end	
script static void e7_m4_door5_open
	sleep_until (LevelEventStatus("bulkhead_doors5"), 1);
	f_engine_open_monster_door(engine_door_5);
	sleep_forever();
end
script static void e7_m4_door6_open
	sleep_until (LevelEventStatus("bulkhead_doors6"), 1);
	f_engine_open_monster_door(engine_door_6);
	sleep_forever();
end
script static void e7m4_open_intro_door  
	f_engine_open_monster_door(intro_door_1);
	sleep_forever();
end
script static void e7m4_open_vent_door1
	f_engine_open_monster_door(vent_door_1);
	sleep_forever();
end
script static void e7m4_open_vent_door2
	f_engine_open_monster_door(vent_door_2);
	sleep_forever();
end
script static void e7m4_open_vent_door3
	sleep_until (LevelEventStatus("e7_m4_open_vent_door3"), 1);	
	f_engine_open_monster_door(vent_door_3);
	sleep_forever();
end
// ================================================================
// ====== CLOSE ENGINE DOORS ======================================
// ================================================================
script static void f_bulkhead_close_doors
	thread (e7_m4_door1_close());
	thread (e7_m4_door2_close());
	thread (e7_m4_door3_close());
	thread (e7_m4_door4_close());
	thread (e7_m4_door5_close());
	thread (e7_m4_door6_close());
end
script static void e7_m4_door1_close
	sleep_until (LevelEventStatus("bulkhead_doors1"), 1);
	sleep_s(5);		
	sleep_until (b_e7m4_narrative_is_on == false, 1);
	vo_e7m4_playstart();
			// Miller : Crimson, I'm marking emergency bulkhead door releases. If you can reach these, you can seal up the engine room so tight the Covies will never be able to get in.
			// OBJECTIVE - SEAL THE BULKHEAD DOORS	
	f_new_objective(ch_7_4_2);		// *** Seal Bulkheads
	device_set_position_track( e7m4_button1, "device:position", 0 );
	device_animate_position (e7m4_button1, 1, 0.25, 1, 0, 0);
	device_set_power(dc_e7m4_bulkhead_1, 1);                                                                 
	f_blip_object_cui (dc_e7m4_bulkhead_1, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_1)) < 1 or device_get_position(device(dc_e7m4_bulkhead_1)) > 0, 1);
	object_destroy (dc_e7m4_bulkhead_1);
	sleep_forever();
end
script static void e7_m4_door2_close
	sleep_until (LevelEventStatus("bulkhead_doors2"), 1);
	sleep_s(2);
	//vo_glo_gotit_03();
	device_set_position_track( e7m4_button2, "device:position", 0 );
	device_animate_position (e7m4_button2, 1, 0.25, 1, 0, 0);
	device_set_power(dc_e7m4_bulkhead_2, 1);    
	f_blip_object_cui (dc_e7m4_bulkhead_2, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_2)) < 1 or device_get_position(device(dc_e7m4_bulkhead_2)) > 0, 1);	
	object_destroy (dc_e7m4_bulkhead_2);
	sleep_forever();
end
script static void e7_m4_door3_close
	sleep_until (LevelEventStatus("bulkhead_doors3"), 1);
	sleep_s(3);
	device_set_position_track( e7m4_button3, "device:position", 0 );
	device_animate_position (e7m4_button3, 1, 0.25, 1, 0, 0);
	device_set_power(dc_e7m4_bulkhead_3, 1); 
	f_blip_object_cui (dc_e7m4_bulkhead_3, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_3)) < 1 or device_get_position(device(dc_e7m4_bulkhead_3)) > 0, 1);
	object_destroy (dc_e7m4_bulkhead_3);
	sleep_forever();
end
script static void e7_m4_door4_close
	sleep_until (LevelEventStatus("bulkhead_doors4"), 1);
	sleep_s(3);
	device_set_position_track( e7m4_button4, "device:position", 0 );
	device_animate_position (e7m4_button4, 1, 0.25, 1, 0, 0);
	device_set_power(dc_e7m4_bulkhead_4, 1); 
	f_blip_object_cui (dc_e7m4_bulkhead_4, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_4)) < 1 or device_get_position(device(dc_e7m4_bulkhead_4)) > 0, 1);
	object_destroy (dc_e7m4_bulkhead_4);
	sleep_forever();
end
script static void e7_m4_door5_close
	sleep_until (LevelEventStatus("bulkhead_doors5"), 1);
	sleep_s(3);
    device_set_position_track( e7m4_button5, "device:position", 0 );
	device_animate_position (e7m4_button5, 1, 0.25, 1, 0, 0);	
	device_set_power(dc_e7m4_bulkhead_5, 1); 
	f_blip_object_cui (dc_e7m4_bulkhead_5, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_5)) < 1 or device_get_position(device(dc_e7m4_bulkhead_5)) > 0, 1);
	object_destroy (dc_e7m4_bulkhead_5);
	sleep_forever();
end
script static void e7_m4_door6_close
	sleep_until (LevelEventStatus("bulkhead_doors6"), 1);
	sleep_s(3);
    device_set_position_track( e7m4_button6, "device:position", 0 );
	device_animate_position (e7m4_button6, 1, 0.25, 1, 0, 0);	
	device_set_power(dc_e7m4_bulkhead_6, 1); 
	f_blip_object_cui (dc_e7m4_bulkhead_6, "navpoint_activate");
	sleep_until (device_get_power(device(dc_e7m4_bulkhead_6)) < 1 or device_get_position(device(dc_e7m4_bulkhead_6)) > 0, 1);
	object_destroy (dc_e7m4_bulkhead_6);
	sleep_forever();
end

// ==========================================================================
// ====== BUTTON PUSHES =====================================================
// ==========================================================================
script static void f_e7_m4_switch_pushed(object control, unit player)	
	g_ics_player = player;
	if control == dc_e7m4_bulkhead_1 then		
		f_engine_close_door(dc_e7m4_bulkhead_1, engine_door_1, e7m4_button1);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		b_e7_m4_bulkhead1 = TRUE;		
		sleep_s(2);
		kill_volume_enable(kill_tv_e7_m4_engine1);							// enable kill volumes		
		
	elseif control == dc_e7m4_bulkhead_2 then		
		f_engine_close_door(dc_e7m4_bulkhead_2, engine_door_2, e7m4_button2);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		sleep_s(2);		
		kill_volume_enable(kill_tv_e7_m4_engine2);							// enable kill volume	
	
	elseif control == dc_e7m4_bulkhead_3 then
		f_engine_close_door(engine_door_3, engine_door_3, e7m4_button3);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		sleep_s(2);
		kill_volume_enable(kill_tv_e7_m4_engine3);							// enable kill volume		
				
	elseif control == dc_e7m4_bulkhead_4 then
		f_engine_close_door(engine_door_4, engine_door_4, e7m4_button4);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		sleep_s(2);
		kill_volume_enable(kill_tv_e7_m4_engine4);							// enable kill volume	
				
	elseif control == dc_e7m4_bulkhead_5 then
		f_engine_close_door(engine_door_5, engine_door_5, e7m4_button5);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		sleep_s(2);
		kill_volume_enable(kill_tv_e7_m4_engine5);							// enable kill volume	
		
	elseif control == dc_e7m4_bulkhead_6 then		
		f_engine_close_door(engine_door_6, engine_door_6, e7m4_button6);
		l_bulkheads_remaining = l_bulkheads_remaining - 1;
		sleep_s(2);
		kill_volume_enable(kill_tv_e7_m4_engine6);							// enable kill volume			
	elseif		
		control == dc_e7m4_ventcore then
		pup_play_show("ppt_start_ventcore");
	elseif
		control == dc_teleport1 then
		dprint("using teleport");
	end	
end 
// ==========================================================================
// ====== CS JUMP ===========================================================
// ==========================================================================														
script command_script e7m4_ranger_west_goon_init()
	sleep(1);
	cs_go_to_and_face(west_goon.p0,west_goon.p1);
	cs_jump(60, 8);
end
script command_script e7m4_ranger_east_goon_init()
	sleep(1);
	cs_go_to_and_face(east_goon.p0,east_goon.p1);
	cs_jump(60, 8);
end
script command_script e7m4_ranger_vent_goon1_init()
	sleep(1);
	cs_go_to_and_face(vent_goon1.p0,vent_goon1.p1);
	cs_jump(60, 5);
end
script command_script e7m4_ranger_vent_goon2_init()
	sleep(1);
	cs_go_to_and_face(vent_goon2.p0,vent_goon2.p1);
	cs_jump(60, 5);
end
script command_script e7m4_engbottom_right_relief_init1()
	cs_go_to_and_face(eng_relief1.p0,eng_relief1.p1);
	cs_jump(60, 4);	
end
script command_script e7m4_engbottom_right_relief_init2()
	cs_go_to_and_face(eng_relief1.p2,eng_relief1.p1);
	cs_jump(60, 4);	
end
script command_script e7m4_engtop_relief_init1()
	cs_go_to_and_face(eng_relief3.p0,eng_relief3.p2);
	cs_jump(45, 3);	
end
script command_script e7m4_engtop_relief_init2()
	cs_go_to_and_face(eng_relief3.p1,eng_relief3.p3);
	cs_jump(45, 4);	
end
script command_script e7m4_wave1_start_init1()
	cs_go_to_and_face(start_ranger.p0,start_ranger.p3);
	cs_jump(60, 7);	
end
script command_script e7m4_wave1_start_init2()
	cs_go_to_and_face(start_ranger.p1,start_ranger.p3);
	cs_jump(60, 7);	
end
script command_script e7m4_wave1_start_init3()
	cs_go_to_and_face(start_ranger.p5,start_ranger.p6);
	cs_jump(60, 6);	
end

// ==========================================================================
// ====== WEST JUMP =========================================================
// ==========================================================================
script command_script e7m4_wave2_west_init1()
	cs_go_to_and_face(west_goon.p0,west_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave2_west_init2()
	cs_go_to_and_face(west_goon.p2,west_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave2_west_init3()
	cs_go_to_and_face(west_goon.p3,west_goon.p4);
	cs_jump(60, 5);
end
script command_script e7m4_wave2_west_init4()
	sleep_s(4);
	cs_go_to_and_face(west_goon.p0,west_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave2_west_init5()
	sleep_s(4);
	cs_go_to_and_face(west_goon.p2,west_goon.p4);
	cs_jump(60, 5);
end

// ==========================================================================
// ====== EAST JUMP =========================================================
// ==========================================================================

script command_script e7m4_wave3_east_init1()	
	cs_go_to_and_face(east_goon.p0,east_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init2()
	cs_go_to_and_face(east_goon.p2,east_goon.p5);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init3()
	cs_go_to_and_face(east_goon.p3,east_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init4()
	cs_go_to_and_face(east_goon.p4,east_goon.p5);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init5()
	sleep_s(3);
	cs_go_to_and_face(east_goon.p0,east_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init6()
	sleep_s(3);
	cs_go_to_and_face(east_goon.p3,east_goon.p1);
	cs_jump(60, 5);
end
script command_script e7m4_wave3_east_init7()
	sleep_s(3);
	cs_go_to_and_face(east_goon.p4,east_goon.p1);
	cs_jump(60, 5);
end

// ==========================================================================
// ====== HUNTER SMASH ======================================================
// ==========================================================================
script command_script e7m4_hunter_smash1()
	//sleep_until(device_get_position(device(vent_door_2)) >= 0.6, 1);
	if (volume_test_players (tv_e7_m4_hunter1)) then
		dprint ("hunter smash");
		cs_go_to (ps_hunter.p2, 1);
		cs_custom_animation(objects\characters\storm_hunter\storm_hunter.model_animation_graph, "any:any:melee_tackle", 1);
	else
		dprint ("hunter 1 moving");
		cs_go_to (ps_hunter.p0, 1);
	end
end
script command_script e7m4_hunter_smash2()
	//sleep_until(device_get_position(device(vent_door_2)) >= 0.5, 1);
	if (volume_test_players (tv_e7_m4_hunter1)) then
		dprint ("hunter 2 shoot");
		cs_crouch (1);
		cs_shoot (1);
	else
		dprint ("hunter 2 moving");
		cs_go_to (ps_hunter.p1, 1);
	end	
end
// ==========================================================================
// ====== EXTRA SPAWNS ======================================================
// ==========================================================================
script static void e7m4_extra_spawns
	thread (e7m4_engine_bottom_relief());	
end
script static void e7m4_engine_bottom_relief
	sleep_until (LevelEventStatus("bulkhead_doors2"), 1);
	ai_place(sq_e7_m4_engine_bottom_relief);
	ai_place(sq_e7_m4_engine_top_relief);
end
// ==================================================================
// ====== VO CALLOUTS ===============================================
// ==================================================================
script static void f_e7m4_incoming
	repeat
		dprint ("incoming event");
		
		sleep_until (b_e7m4_narrative_is_on == false, 1);
		b_e7m4_narrative_is_on = true;
		begin_random_count (1)
			vo_glo_incoming_01();
			vo_glo_incoming_02();
			vo_glo_incoming_03();
			vo_glo_incoming_04();
			vo_glo_incoming_05();
		end		
		b_e7m4_narrative_is_on = false;		
	until (b_e7m4_narrative_is_on == false);
end

script static void f_e7m4_remaningcov
	repeat
		dprint ("cov remaining event");		
		sleep_until (b_e7m4_narrative_is_on == false, 1);
		b_e7m4_narrative_is_on = true;
		begin_random_count (1)
			vo_glo_remainingcov_01();
			vo_glo_remainingcov_02();
			//vo_glo_remainingcov_03();
			vo_glo_remainingcov_04();
		end		
		b_e7m4_narrative_is_on = false;		
	until (b_e7m4_narrative_is_on == false);
end

// ==================================================================
// ====== PISTONS ================================================
// ==================================================================
script static void e7m4_pistons_start
		dprint("pistons start!");
	if object_valid(dm_piston01) then
		sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_pistons_activate_in', none, 1);
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
// ====== DEBUG ================================================
// ==================================================================
// script static void	e7m4_teleport_debug	
	// sleep_until (device_get_power(device(dc_teleport1)) < 1 or device_get_position(device(dc_teleport1)) > 0, 1);	
	// prepare_to_switch_to_zone_set (e7_m4_b);                   // starting zone switch
	// sleep_until (not PreparingToSwitchZoneSet(), 1);
	// switch_zone_set (e7_m4_b);
	// volume_teleport_players_not_inside (tv_e7_m4_tele, fl_e7_m4_tele_debug);		
	// dprint("teleport done");
	// sleep_s(4);	
	// ai_erase(gr_e7_m4_ff_all);
	// pup_play_show("cruiser_explosion");
	// object_create(dc_e7m4_ventcore);
	// device_set_power(dc_e7m4_ventcore, 1);
	// f_blip_object_cui (dc_e7m4_ventcore, "navpoint_activate");
	// sleep_until (device_get_power(device(dc_e7m4_ventcore)) < 1 or device_get_position(device(dc_e7m4_ventcore)) > 0, 1);
	// notifylevel("end_mission"); 
// end

// ==================================================================
// ====== MISSLES ================================================
// ==================================================================

script command_script e7m4misslebatt01
	print ("shoot motherfucker");
//	cs_shoot_point (true, e7m4_cruiser_shots.p0);
//	cs_pause (2);
	cs_shoot (true, e7m4_explodingcruiser);
end

script command_script e7m4misslebatt02
	 cs_shoot_point (true, e7m4_cruiser_shots.p1);
end

// ==================================================================
// ====== SPACE BATTLE ================================================
// ==================================================================

script command_script broadswordrun_1
//	cs_ignore_obstacles (TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 1 );
	cs_fly_to (ps_e7m4_space_1.p0);
	sleep (30 * 4);
	ai_erase (ai_current_actor);
end