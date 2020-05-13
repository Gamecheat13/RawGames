// =============================================================================================================================
// ============================================ E8M5 MEZZANINE MISSION SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================
	global boolean b_loc_1_done = FALSE;
	global boolean b_loc_2_done = FALSE;
	global boolean b_loc_3_done = FALSE;
	global boolean b_loc_4_done = FALSE;
	global boolean b_loc_5_done = FALSE;
	global boolean b_loc_6_done = FALSE;
	global boolean b_loc_7_done = FALSE;
	global boolean b_loc_8_done = FALSE;
	
	global boolean b_loc_1_active = FALSE;
	global boolean b_loc_2_active = FALSE;
	global boolean b_loc_3_active = FALSE;
	global boolean b_loc_4_active = FALSE;
	global boolean b_loc_5_active= FALSE;
	global boolean b_loc_6_active = FALSE;
	global boolean b_loc_7_active = FALSE;
	global boolean b_loc_8_active = FALSE;
	
	global short s_special_1 = 0;
	global short s_special_2 = 0;
	global short s_special_3 = 0;
	global short s_special_4 = 0;
	global short s_special_5 = 0;
	global short s_special_6 = 0;
	global short s_special_7 = 0;
	global short s_special_8 = 0;
	
// ============================================	STARTUP SCRIPT	========================================================

script startup e8m5_caverns_startup

	print( "e8m5 caverns startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m5") ) then
		wake( e8m5_mezzanine_init );
	end

end

script dormant e8m5_mezzanine_init()
		//sleep_until (LevelEventStatus ("e8_m5"), 1);
		f_spops_mission_setup( "e8_m5", e8m5_main, e8m5_ff_all, e8_m5_spawn_init, 90 );
		//ai_ff_all = e8m5_ff_all;
		print ("e8m5 variant started");
		//switch_zone_set (e8m5_main);
		//ai_allegiance (human, player);
		//ai_allegiance (player, human);
		ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery", "objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect" );
		ai_allegiance (player, forerunner);
		
//	//	//	//	FOLDER SPAWNING	\\	\\	\\

//  "Devices" folders
		f_add_crate_folder (e8m5_device_machines);
		f_add_crate_folder (e8m5_device_controls);
		
		
//	add "Vehicles" folders
//		f_add_crate_folder ( );

//	add "Crates" folders
		f_add_crate_folder (e8m5_cov_crates);
		object_destroy_folder(cr_e6m2_weaponcrates);

//  Spawn point folders 
		f_add_crate_folder (e8_m5_spawn_init);

		firefight_mode_set_crate_folder_at( e8_m5_spawn_init, 90);					//	Initial Spawn Area for E8M5	
	
//	//	add "Items" folders

//	//	add "Enemy Squad" Templates

//  "Objective Items"
		firefight_mode_set_objective_name_at( e8m5_insert_map_dc, 50);	//	Test Starting Obj
		
//  "Squad Declaration"
		firefight_mode_set_squad_at( e8m5_ff_init_all, 1);	//	Starting Squad
		firefight_mode_set_squad_at( e8m5_ff_wave_1, 2);	//	First Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_2, 3);	//	Second Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_3, 4);	//	Third Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_4_spec, 5);	//	Fourth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_5, 6); // Fifth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_6, 7); // Sixth Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_7, 8); // Seventh Wave
		firefight_mode_set_squad_at( e8m5_ff_wave_8_spec, 9); // Eigth Wave
		firefight_mode_set_squad_at( e8m5_ff_wraiths_1, 10); // Wraith Wave 1
		firefight_mode_set_squad_at( e8m5_ff_wraiths_2, 11); // Wraith Wave 2
		firefight_mode_set_squad_at( e8m5_ff_hunters, 12); // Hunters
		
// "Phantom Declaration"
		firefight_mode_set_squad_at( e8m5_phantom_wave_1, 13);
		firefight_mode_set_squad_at( e8m5_phantom_wave_2, 14);
		firefight_mode_set_squad_at( e8m5_phantom_wave_3, 15);
		
//	"LZ" areas
	firefight_mode_set_objective_name_at( e8_m5_lz_0, 51);
		
// call the setup complete
 	 f_spops_mission_setup_complete( TRUE );
	  
	 	sleep_until (f_spops_mission_ready_complete(), 1);
//intro();
//f_e9_m2_intro_vignette();
	
		f_spops_mission_intro_complete( TRUE );

//	firefight_mode_set_player_spawn_suppressed(TRUE);
		//sleep_until (LevelEventStatus ("loadout_screen_complete"), 1); 
//	cinematic_start();
//	pup_play_show ( );
//	sleep (15);
//	sleep_until (f_narrativein_done == TRUE);
//	cinematic_stop();
//	firefight_mode_set_player_spawn_suppressed(FALSE);
		//sleep_until (b_players_are_alive(), 1);
		sleep_until( f_spops_mission_start_complete(), 1 );
		sleep_s (0.5);
		fade_in (0,0,0,15);
		//ordnance_drop(flg_e8m5_ord_1, "storm_rocket_launcher");
// Event Script Threading
		thread(f_start_event_e8m5_0());
		thread(f_start_event_e8m5_1());
		thread(f_end_event_e8m5_1());
		thread(f_start_event_e8m5_2());
		thread(f_end_event_e8m5_2());
		thread(f_start_event_e8m5_3());
		thread(f_end_event_e8m5_3());
		thread(f_start_event_e8m5_4());
		thread(f_end_event_e8m5_4());
		thread(f_start_event_e8m5_5());
		thread(f_end_event_e8m5_5());
		thread(f_start_event_e8m5_6());
		thread(f_end_event_e8m5_6());
		thread(f_start_event_e8m5_7());
		thread(f_end_event_e8m5_7());
		thread(f_start_event_e8m5_8());
		thread(f_end_event_e8m5_8());
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_1);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_2);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_3);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_4);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_5);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_6);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_7);
		//effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_e8m5_area_fx_8);
end

// ============================================	MISSION SCRIPT	========================================================

script static void f_start_event_e8m5_0()
		//sleep_until(LevelEventStatus("start_event_0"), 1);
		print("STARTING EVENT 0");
		sleep_until(ai_living_count(e8m5_ff_init_all) <= 5);
		f_blip_ai_cui(e8m5_ff_all, "navpoint_enemy");
		//f_blip_ai_cui(e8m5_ff_init_all, "navpoint_enemy");
		//print("BLIPPING AI");
end

script static void f_start_event_e8m5_1()
		sleep_until(LevelEventStatus("start_event_1"), 1);
		print("STARTING EVENT 1");
		//device_set_power(e8m5_insert_map_dc, 1);
		print("starting timer");
		f_setup_loc_fx(flg_e8m5_area_fx_1);
		b_loc_1_active = TRUE;
		thread(f_location_timer_1());
		sleep_until(s_special_1 == 3);
		//sleep(1);
		b_loc_1_active = FALSE;
		b_loc_1_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;	
end

script static void f_end_event_e8m5_1()
		sleep_until(LevelEventStatus("end_event_1"), 1);
		print("ENDING EVENT 1");	
		//object_destroy(e8m5_insert_map_dc);
		//pup_play_show(e8m5_close_map);
		f_remove_loc_fx(flg_e8m5_area_fx_1);
end

script static void f_start_event_e8m5_2()
		sleep_until(LevelEventStatus("start_event_2"), 1);
		print("STARTING EVENT 2");
		f_setup_loc_fx(flg_e8m5_area_fx_2);
		b_loc_2_active = TRUE;
		print("starting timer");
		thread(f_location_timer_2());
		sleep_until((s_special_2 >= 15) or (ai_living_count(e8m5_ff_wave_1) <= 0));
		f_sleep_check_special(s_special_2, tv_e8m3_2);
		f_remove_loc_fx(flg_e8m5_area_fx_2);
		b_loc_2_active = FALSE;
		b_loc_2_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;	
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_2()
		sleep_until(LevelEventStatus("end_event_2"), 1);
		print("ENDING EVENT 2");
		pup_play_show(e8m5_defense_spires_up);
end

script static void f_start_event_e8m5_3()
		sleep_until(LevelEventStatus("start_event_3"), 1);
		print("STARTING EVENT 3");
		f_setup_loc_fx(flg_e8m5_area_fx_3);
		b_loc_3_active = TRUE;
		print("starting timer");
		thread(f_location_timer_3());
		sleep_until((s_special_3 >= 30) or (ai_living_count(e8m5_ff_wave_2) <= 0));
		f_sleep_check_special(s_special_3, tv_e8m3_3);
		f_remove_loc_fx(flg_e8m5_area_fx_3);
		b_loc_3_active = FALSE;
		b_loc_3_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_3()
		sleep_until(LevelEventStatus("end_event_3"), 1);
		print("ENDING EVENT 3");	
end

script static void f_start_event_e8m5_4()
		sleep_until(LevelEventStatus("start_event_4"), 1);
		print("STARTING EVENT 4");
		f_setup_loc_fx(flg_e8m5_area_fx_4);
		b_loc_4_active = TRUE;
		print("starting timer");
		thread(f_location_timer_4());
		sleep_until((s_special_4 >= 30) or (ai_living_count(e8m5_ff_wave_3) <= 0));
		f_sleep_check_special(s_special_4, tv_e8m3_4);
		f_remove_loc_fx(flg_e8m5_area_fx_4);
		b_loc_4_active = FALSE;
		b_loc_4_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;	
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_4()
		sleep_until(LevelEventStatus("end_event_4"), 1);
		print("ENDING EVENT 4");	
end

script static void f_start_event_e8m5_5()
		sleep_until(LevelEventStatus("start_event_5"), 1);
		print("STARTING EVENT 5");
		f_setup_loc_fx(flg_e8m5_area_fx_5);
		b_loc_5_active = TRUE;
		print("starting timer");
		thread(f_location_timer_5());
		sleep_until((s_special_5 >= 30) or (ai_living_count(e8m5_ff_wave_4_spec) <= 0));
		f_sleep_check_special(s_special_5, tv_e8m3_5);
		f_remove_loc_fx(flg_e8m5_area_fx_5);
		b_loc_5_active = FALSE;
		b_loc_5_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_5()
		sleep_until(LevelEventStatus("end_event_5"), 1);
		print("ENDING EVENT 5");	
end

script static void f_start_event_e8m5_6()
		sleep_until(LevelEventStatus("start_event_6"), 1);
		print("STARTING EVENT 6");
		f_setup_loc_fx(flg_e8m5_area_fx_6);
		b_loc_6_active = TRUE;
		print("starting timer");
		thread(f_location_timer_6());
		sleep_until((s_special_6 >= 20) or (ai_living_count(e8m5_ff_wave_5) <= 0));
		f_sleep_check_special(s_special_6, tv_e8m3_6);
		f_remove_loc_fx(flg_e8m5_area_fx_6);
		b_loc_6_active = FALSE;
		b_loc_6_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_ff_all);
end
script static void f_end_event_e8m5_6()
		sleep_until(LevelEventStatus("end_event_6"), 1);
		print("ENDING EVENT 6");	
end

script static void f_start_event_e8m5_7()
		sleep_until(LevelEventStatus("start_event_7"), 1);
		print("STARTING EVENT 7");
		f_setup_loc_fx(flg_e8m5_area_fx_7);
		b_loc_7_active = TRUE;
		print("starting timer");
		thread(f_location_timer_7());
		sleep_until((s_special_7 >= 15) or (ai_living_count(e8m5_ff_wave_6) <= 0));
		f_sleep_check_special(s_special_7, tv_e8m3_7);
		f_remove_loc_fx(flg_e8m5_area_fx_7);
		b_loc_7_active = FALSE;
		b_loc_7_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_7()
		sleep_until(LevelEventStatus("end_event_7"), 1);
		print("ENDING EVENT 7");
		ai_place_in_limbo(e8m5_air_turret_1);
end

script static void f_start_event_e8m5_8()
		sleep_until(LevelEventStatus("start_event_8"), 1);
		print("STARTING EVENT 8");
		f_setup_loc_fx(flg_e8m5_area_fx_8);
		b_loc_8_active = TRUE;
		print("starting timer");
		thread(f_location_timer_8());
		sleep_until((s_special_8 >= 15) or (ai_living_count(e8m5_ff_wave_7) <= 0));
		f_sleep_check_special(s_special_8, tv_e8m3_8);
		f_remove_loc_fx(flg_e8m5_area_fx_8);
		b_loc_8_active = FALSE;
		b_loc_8_done = TRUE;
		f_blip_remaining();
		b_end_player_goal = TRUE;
		f_unblip_ai_cui(e8m5_ff_all);
end

script static void f_end_event_e8m5_8()
		sleep_until(LevelEventStatus("end_event_8"), 1);
		print("ENDING EVENT 8");
		ai_place_in_limbo(e8m5_air_turret_2);
end

// ============================================	PLACEMENT SCRIPT	========================================================

// PHANTOM SCRIPTING

script command_script cs_e8m5_phantom_1()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_wave_1_ps.p0 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p2 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p3 );

	f_unload_phantom( e8m5_phantom_wave_1, "dual" );

	print ("unload phantom_1");
	
	f_blip_ai_cui(e8m5_ff_wave_1, "navpoint_enemy");
	
	cs_fly_to( e8m5_phantom_wave_1_ps.p4 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p6 );
	cs_fly_to( e8m5_phantom_wave_1_ps.p7 );

	ai_erase (e8m5_phantom_wave_1);
end

script command_script cs_e8m5_phantom_2()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_wave_2_ps.p0 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p2 );

	f_unload_phantom( e8m5_phantom_wave_2, "dual" );

	print ("unload phantom_2");
	
	cs_fly_to( e8m5_phantom_wave_2_ps.p3 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p4 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p6 );
	cs_fly_to( e8m5_phantom_wave_2_ps.p7 );

	ai_erase (e8m5_phantom_wave_2);
end

script command_script cs_e8m5_phantom_3()

	cs_ignore_obstacles( ai_current_actor, TRUE );	

	cs_fly_to( e8m5_phantom_wave_3_ps.p0 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p1 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p2 );
	cs_fly_to_and_face( e8m5_phantom_wave_3_ps.p3, e8m5_phantom_wave_3_ps.p7 );
	
	f_unload_phantom( e8m5_phantom_wave_3, "dual" );

	print ("unload phantom_3");
	
	cs_fly_to( e8m5_phantom_wave_3_ps.p4 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p6 );

	ai_erase (e8m5_phantom_wave_3);
end

// AIR TURRETS

script command_script cs_air_turrets() 
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .35, 0);
	ai_exit_limbo(ai_current_actor);
end

// ============================================ LOCATION TIMERS ==========================================================

script static void f_location_timer_1()
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_1) == TRUE);
		s_special_1 = (s_special_1 + 1);
	until
		(b_loc_1_done == TRUE);
	end
	
script static void f_location_timer_2()
	thread(f_active_defenses_2());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_2) == TRUE);
		s_special_2 = (s_special_2 + 1);
	until
		(b_loc_2_done == TRUE);
	end
	
script static void f_location_timer_3()
	thread(f_active_defenses_3());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_3) == TRUE);
		s_special_3 = (s_special_3 + 1);
	until
		(b_loc_3_done == TRUE);
	end
	
script static void f_location_timer_4()
	thread(f_active_defenses_4());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_4) == TRUE);
		s_special_4 = (s_special_4 + 1);
	until
		(b_loc_4_done == TRUE);
	end
	
script static void f_location_timer_5()
	thread(f_active_defenses_5());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_5) == TRUE);
		s_special_5 = (s_special_5 + 1);
	until
		(b_loc_5_done == TRUE);
	end
	
script static void f_location_timer_6()
	thread(f_active_defenses_6());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_6) == TRUE);
		s_special_6 = (s_special_6 + 1);
	until
		(b_loc_6_done == TRUE);
	end
	
script static void f_location_timer_7()
	thread(f_active_defenses_7());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_7) == TRUE);
		s_special_7 = (s_special_7 + 1);
	until
		(b_loc_7_done == TRUE);
	end
	
script static void f_location_timer_8()
	thread(f_active_defenses_8());
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_e8m3_8) == TRUE);
		s_special_8 = (s_special_8 + 1);
	until
		(b_loc_8_done == TRUE);
	end
	
script static void f_location_timer_missed(trigger_volume tv_loc)
	local short s_time = 0;
	print("player missed bonus");
	repeat
		sleep(1);
		sleep_until(volume_test_players(tv_loc) == TRUE);
		s_time = (s_time + 1);
	until
		(s_time == 3);
	end
	
// ============================================ ACTIVE DEFENSES ==========================================================

script static void f_active_defenses_2()
	sleep_until(s_special_2 >= 1);
	device_set_power(e8m5_cvr_1b_1, 1);
	sleep_until(s_special_2 >= 2);
	device_set_power(e8m5_cvr_1a_1, 1);
	sleep_until(s_special_2 >= 3);
	device_set_power(e8m5_cvr_1b_2, 1);
	sleep_until(s_special_2 >= 5);
	device_set_power(e8m5_cvr_1b_4, 1);
	sleep_until(s_special_2 >= 6);
	device_set_power(e8m5_cvr_1a_2, 1);
	sleep_until(s_special_2 >= 7);
	device_set_power(e8m5_cvr_1b_3, 1);
	sleep_until(s_special_2 >= 8);
	ai_place(e8m5_turrets_1);
	sleep_until(s_special_2 >= 15);
	object_create_folder(e8m5_fore_weapons_1);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_3()
	sleep_until(s_special_3 >= 3);
	device_set_power(e8m5_cvr_2a_4, 1);
	sleep_until(s_special_3 >= 4);
	device_set_power(e8m5_cvr_2a_3, 1);
	sleep_until(s_special_3 >= 7);
	device_set_power(e8m5_cvr_2a_1, 1);
	sleep_until(s_special_3 >= 8);
	device_set_power(e8m5_cvr_2a_2, 1);
	sleep_until(s_special_3 >= 13);
	ai_place(e8m5_turrets_2);
	sleep_until(s_special_3 >= 14);
	device_set_power(e8m5_cvr_2c_2, 1);
	sleep_until(s_special_3 >= 19);
	device_set_power(e8m5_cvr_2c_1, 1);
	sleep_until(s_special_3 >= 24);
	device_set_power(e8m5_cvr_1b_1, 1);
	sleep_until(s_special_3 >= 25);
	device_set_power(e8m5_cvr_1b_2, 1);
	sleep_until(s_special_3 >= 30);
	object_create_folder(e8m5_fore_weapons_2);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_4()
	sleep_until(s_special_4 >= 3);
	device_set_power(e8m5_cvr_3_2, 1);
	sleep_until(s_special_4 >= 4);
	device_set_power(e8m5_cvr_3_1, 1);
	sleep_until(s_special_4 >= 7);
	device_set_power(e8m5_cvr_3_4, 1);
	sleep_until(s_special_4 >= 12);
	ai_place(e8m5_turrets_3);
	sleep_until(s_special_4 >= 17);
	device_set_power(e8m5_cvr_3_8, 1);
	sleep_until(s_special_4 >= 18);
	device_set_power(e8m5_cvr_3_9, 1);
	sleep_until(s_special_4 >= 19);
	device_set_power(e8m5_cvr_3_10, 1);
	sleep_until(s_special_4 >= 23);
	device_set_power(e8m5_cvr_3_5, 1);
	sleep_until(s_special_4 >= 24);
	device_set_power(e8m5_cvr_3_6, 1);
	sleep_until(s_special_4 >= 25);
	device_set_power(e8m5_cvr_3_7, 1);
	sleep_until(s_special_4 >= 30);
	object_create_folder(e8m5_fore_weapons_3);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_5()
	sleep_until(s_special_5 >= 3);
	device_set_power(e8m5_cvr_4_6, 1);
	sleep_until(s_special_5 >= 4);
	device_set_power(e8m5_cvr_4_7, 1);
	sleep_until(s_special_5 >= 7);
	device_set_power(e8m5_cvr_4_1, 1);
	sleep_until(s_special_5 >= 8);
	device_set_power(e8m5_cvr_4_8, 1);
	sleep_until(s_special_5 >= 13);
	ai_place(e8m5_turrets_4);
	sleep_until(s_special_5 >= 18);
	device_set_power(e8m5_cvr_4_2, 1);
	sleep_until(s_special_5 >= 19);
	device_set_power(e8m5_cvr_4_4, 1);
	sleep_until(s_special_5 >= 24);
	device_set_power(e8m5_cvr_4_3, 1);
	sleep_until(s_special_5 >= 25);
	device_set_power(e8m5_cvr_4_5, 1);
	sleep_until(s_special_5 >= 30);
	object_create_folder(e8m5_fore_weapons_4);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_6()
	sleep_until(s_special_6 >= 3);
	device_set_power(e8m5_cvr_5_3, 1);
	sleep_until(s_special_6 >= 4);
	device_set_power(e8m5_cvr_5_2, 1);
	sleep_until(s_special_6 >= 7);
	device_set_power(e8m5_cvr_5_5, 1);
	sleep_until(s_special_6 >= 8);
	device_set_power(e8m5_cvr_5_4, 1);
	sleep_until(s_special_6 >= 10);
	ai_place(e8m5_turrets_5);
	sleep_until(s_special_6 >= 15);
	device_set_power(e8m5_cvr_5_2, 1);
	sleep_until(s_special_6 >= 16);
	device_set_power(e8m5_cvr_5_1, 1);
	sleep_until(s_special_6 >= 20);
	object_create_folder(e8m5_fore_weapons_5);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_7()
	sleep_until(s_special_7 >= 3);
	device_set_power(e8m5_cvr_6_1, 1);
	sleep_until(s_special_7 >= 5);
	device_set_power(e8m5_cvr_6_2, 1);
	sleep_until(s_special_7 >= 8);
	ai_place(e8m5_turrets_7);
	sleep_until(s_special_7 >= 13);
	device_set_power(e8m5_cvr_6_3, 1);
	sleep_until(s_special_7 >= 15);
	object_create_folder(e8m5_fore_weapons_6);
	print("FULL BONUS OBTAINED");
end

script static void f_active_defenses_8()
	sleep_until(s_special_8 >= 3);
	device_set_power(e8m5_cvr_7_1, 1);
	sleep_until(s_special_8 >= 5);
	device_set_power(e8m5_cvr_7_2, 1);
	sleep_until(s_special_8 >= 8);
	ai_place(e8m5_turrets_6);
	sleep_until(s_special_8 >= 13);
	device_set_power(e8m5_cvr_7_3, 1);
	sleep_until(s_special_8 >= 25);
	object_create_folder(e8m5_fore_weapons_7);
	print("FULL BONUS OBTAINED");
end

script static void f_setup_loc_fx(cutscene_flag flg_blip)
	f_blip_flag(flg_blip, "navpoint_goto");
	effect_new( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_blip);
end

script static void f_remove_loc_fx(cutscene_flag flg_blip)
	f_unblip_flag(flg_blip);
	effect_kill_from_flag( environments\solo\m70_liftoff\fx\energy\gravlift_base.effect, flg_blip);
end

script static void f_sleep_check_special( short s_special, trigger_volume tv_loc)
		if
			s_special < 3
		then
			f_location_timer_missed(tv_loc);
		end
end

script static void f_blip_remaining()
	if
		ai_living_count(e8m5_ff_all) > 4
	then
		f_blip_ai_cui(e8m5_ff_all, "navpoint_enemy");
	end
	sleep_until(ai_living_count(e8m5_ff_all) <= 4);
end
	
// ============================================ ACTIVE CAMO SCRIPT =======================================================
script command_script cs_active_camo_use()
  if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
  	dprint( "cs_active_camo_use: ENABLED" );
  	thread( f_active_camo_manager(ai_current_actor) );
  end
end

script static void f_active_camo_manager( ai ai_actor )
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
  sleep_until( (unit_get_health(ai_actor) <= 0.0) or (objects_distance_to_object(Players(),obj_actor) <= 3.00) or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 1 );
   if ( unit_get_health(ai_actor) > 0.0 ) then
   	ai_set_active_camo( ai_actor, FALSE );
    dprint( "f_active_camo_manager: DISABLED" ); 
   end
                                
	// manage resetting
   if ( unit_get_health(ai_actor) > 0.0 ) then
     l_timer = timer_stamp( 5.0, 10.0 );
     sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
   end
   if ( unit_get_health(ai_actor) > 0.0 ) then
     dprint( "f_active_camo_manager: RESET" ); 
   end
                
   until ( unit_get_health(ai_actor) <= 0.0, 1 );

end
