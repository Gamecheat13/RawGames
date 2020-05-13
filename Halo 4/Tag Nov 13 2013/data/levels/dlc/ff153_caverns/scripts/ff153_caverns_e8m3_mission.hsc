// =============================================================================================================================
// ============================================ E8M3 CAVERNS MISSION SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

global real r_units_in_squad_1 = 0;
global real r_units_in_squad_2 = 0;
global boolean b_beach_adds_entered = FALSE;
global boolean b_player_entered_cave = FALSE;
global boolean b_player_is_in_cave = FALSE;
global boolean b_shield_on = TRUE;
global boolean b_trigger_forest_adds = FALSE;

// ============================================	STARTUP SCRIPT	========================================================
script startup e8m3_caverns_startup

	print( "e8m3 caverns startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m3") ) then
		wake( e8m3_caverns_init );
	end

end

script dormant e8m3_caverns_init
//	sleep_until (LevelEventStatus ("e9m2_var_startup"), 1);

	print ("************STARTING E8 M3*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e8_m3", e8_m3_ext, sg_e8m3_all, e8_m3_spawn_init, 90 );

		//sleep_until (LevelEventStatus ("e8_m3"), 1);
		//ai_ff_all = sg_e8m3_all;
		print ("e8m3 variant started");
		//switch_zone_set (e8_m3_ext);
		//ai_allegiance (human, player);
		//ai_allegiance (player, human);
		ai_allegiance (covenant, forerunner);
		//b_end_player_goal = FALSE;
		//ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m3.scenery", "objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect" );
		
//	//	//	//	FOLDER SpawnING	\\	\\	\\

//  "Devices" folders
		//f_add_crate_folder (e8m5_device_machines);
		//f_add_crate_folder (e8m5_device_controls);
		
//	add "Vehicles" folders
		f_add_crate_folder (e8m3_hogs_1);

//	//	add "Crates" folders
		f_add_crate_folder ( e8m3_shield_1);
		f_add_crate_folder ( e8m3_grass_crates);
		object_destroy_folder ( e10m2_outside_crates);
		object_destroy_folder ( e10m2_towers);
		object_destroy_folder ( e10_m2_cov_turrets);
		object_hide(e8m3_pod_1, false);
		object_create(e8m3_base_1);
		object_hide(cr_e6_m3_pod_top_1, false);
		object_hide(cr_e6_m3_pod_top_2, false);
		object_create(e6_m3_cov_base_01);
		object_create(e6_m3_cov_base_02);
		object_create( cr_e6_m3_light_bridge_1 );
		object_create( cr_e6_m3_light_bridge_2 );

//  Spawn point folders 
		f_add_crate_folder (e8_m3_spawn_init);
		//f_add_crate_folder (e8m3_spawn_beach);
		//f_add_crate_folder (e8m3_spawn_cave);

		firefight_mode_set_crate_folder_at( e8_m3_spawn_init, 90);					//	Initial Spawn Area for E8M5	
		firefight_mode_set_crate_folder_at( e8m3_spawn_beach, 91);					//	Beach Spawn
		firefight_mode_set_crate_folder_at( e8m3_spawn_cave, 92);						//	Cave Spawn
		
//	//	add "Items" folders

//	//	add "Enemy Squad" Templates

//  "Objective Items"
		firefight_mode_set_objective_name_at( e8m3_core_1, 50);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_core_2, 51);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_core_3, 52);	//	Grass Generator 1
		firefight_mode_set_objective_name_at( e8m3_beach_door, 53); // Foredoor on Beach
		firefight_mode_set_objective_name_at( e8m3_shield_location, 54); // Button to release marines
		firefight_mode_set_objective_name_at( e8m3_release_marines, 55); // Button to release marines
		firefight_mode_set_objective_name_at( m8e3_lz_final, 56); // Escape LZ m8e3_lz_final
		
//  "Squad Declaration"

		firefight_mode_set_squad_at( sg_e8m3_grass_init, 1);	//	Starting Squad
		firefight_mode_set_squad_at( e8m3_ghosts_g_1, 2);	//	Starting Squad 2
		firefight_mode_set_squad_at( sg_e8m3_beach_init, 3);	//	Beach Squads
		firefight_mode_set_squad_at( sg_e8m3_beach_adds, 4);	//	Beach Adds
		firefight_mode_set_squad_at( sg_e8m3_cavern_init, 5);	//	Starting Squad Cavern
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_1, 6);	//	Cavern Adds 1
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_2, 7);	//	Cavern Adds 2
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_3, 8);	//	Cavern Adds 3
		firefight_mode_set_squad_at( sg_e8m3_cavern_adds_4, 9);	//	Cavern Adds 4
		firefight_mode_set_squad_at( sg_e8m3_forest_init, 10);	//	Forest Start
		firefight_mode_set_squad_at( sg_e8m3_forest_adds, 11);	//	Forest Adds
		firefight_mode_set_squad_at( sg_e8m3_finale, 12);	//	Finale

// "Phantom Declaration"
		//firefight_mode_set_squad_at( e8m5_phantom_wave_1, 13);
		//firefight_mode_set_squad_at( e8m5_phantom_wave_2, 14);
		//firefight_mode_set_squad_at( e8m5_phantom_wave_3, 15);
		
//	"LZ" areas
	//firefight_mode_set_objective_name_at( e8_m5_lz_0, 51);``
	
//	firefight_mode_set_player_spawn_suppressed(TRUE);

//  call the setup complete
	  f_spops_mission_setup_complete( TRUE );
	  
	  sleep_until (f_spops_mission_ready_complete(), 1);
		//intro();
		//f_e9_m2_intro_vignette();
	
		f_spops_mission_intro_complete( TRUE );
		
		//sleep_until (LevelEventStatus ("loadout_screen_complete"), 1); 
//	cinematic_start();
//	pup_play_show ( );
//	sleep (15);
//	sleep_until (f_narrativein_done == TRUE);
//	cinematic_stop();
//	firefight_mode_set_player_spawn_suppressed(FALSE);
		thread(f_main_friendly_setup());
		//sleep_until (b_players_are_alive(), 1);
		sleep_until( f_spops_mission_start_complete(), 1 );
		sleep_s (0.5);
		fade_in (0,0,0,15);
		//ordnance_drop(flg_e8m5_ord_1, "storm_rocket_launcher");
		
		object_cannot_take_damage(e8m3_core_1);
		object_cannot_take_damage(e8m3_core_2);
		object_cannot_take_damage(e8m3_core_3);

// Event Script Threading
		thread(f_objective_track_grass());
		thread(f_start_event_e8m3_1());
		thread(f_end_event_e8m3_1());
		thread(f_start_event_e8m3_3());
		thread(f_start_event_e8m3_5());
		thread(f_start_event_e8m3_6());
		thread(f_start_event_e8m3_8());
		thread(f_end_event_e8m3_8());

end

// ============================================	MISSION SCRIPT	========================================================

script static void f_main_friendly_setup()
	ai_place(e8_m3_marines_1);
end

script static void f_objective_track_grass()
	sleep_until(volume_test_players(e8m3_tv_grass_enter) or ai_living_count(e8m3_ghosts_g_1) <= 1);
	sleep_s(random_range(1, 5));
	ai_place(e8m3_ghosts_g_2);
	sleep_until(ai_living_count(sg_e8m3_grass_vehicles) <= 2);
	sleep_s(random_range(1, 5));
	ai_place(e8m3_ghosts_g_3);
	sleep_until(ai_living_count(sg_e8m3_grass_vehicles) <= 2 or ai_living_count(sg_e8m3_grass_init) <= 5);
	sleep_s(random_range(1, 5));
	ai_place(e8m3_wraith_g_2);
	sleep_s(random_range(5, 10));	
	ai_place(e8m3_wraith_g_1);
	r_units_in_squad_1 = ai_living_count(sg_e8m3_grass_vehicles);
	r_units_in_squad_2 = ai_living_count(sg_e8m3_grass_init);
	sleep_until((ai_living_count(sg_e8m3_grass_vehicles) == r_units_in_squad_1 - 1) or (ai_living_count(sg_e8m3_grass_init) == r_units_in_squad_2 - 1));
	b_end_player_goal = TRUE;	
end

script static void f_start_event_e8m3_1()
		sleep_until(LevelEventStatus("start_event_1"), 1);
		print("START EVENT 1");
		object_can_take_damage(e8m3_core_1);
		object_can_take_damage(e8m3_core_2);
		object_can_take_damage(e8m3_core_3);
		ai_object_set_team(e8m3_core_1, "covenant");
		ai_object_set_team(e8m3_core_2, "covenant");
		ai_object_set_team(e8m3_core_3, "covenant");
		ai_object_enable_targeting_from_vehicle(e8m3_core_1, true);
		ai_object_enable_targeting_from_vehicle(e8m3_core_2, true);
		ai_object_enable_targeting_from_vehicle(e8m3_core_3, true);
end

script static void f_end_event_e8m3_1()
		sleep_until(LevelEventStatus("end_event_1"), 1);
		print("END EVENT 1");
		object_destroy_folder(e8m3_shield_1);
		object_create_folder(e8m3_beach_crates);
		object_create_folder(e8m3_beach_vehicles);
		b_end_player_goal = FALSE;	
end

script static void f_start_event_e8m3_3()
		sleep_until(LevelEventStatus("start_event_3"), 1);
		print("START EVENT 3");
		device_set_power(cavern_front_door, 1);
		sleep(1);
		device_set_position(cavern_front_door, 1);
		b_beach_adds_entered = TRUE;
		sleep_until(volume_test_players(e8m3_tv_cave_enter) or ai_living_count(sg_e8m3_beach_all) <= 0, 1);
		sleep(1);
		if b_player_is_in_cave == FALSE
			then
			f_blip_flag(e8m3_flg_caverns_enter, "default");
			sleep_until(volume_test_players(e8m3_tv_cave_enter), 1);
			f_unblip_flag(e8m3_flg_caverns_enter);
		end
		b_end_player_goal = TRUE;
		object_create_folder(e8m3_cavern_crates);
		object_create_folder(e8m3_shield_2);
		object_create_folder(e8m3_cavern_vehicles);
		ai_place(e8_m3_marines_2);
		b_player_entered_cave = TRUE;
		thread(f_close_beach_door());
end

script static void f_enter_cave_check()
	sleep_until(volume_test_players(e8m3_tv_cave_enter), 1);
	b_player_is_in_cave = TRUE;	
end

script static void f_close_beach_door()
	print("WERE YOU BORN IN A BARN OR SOMETHING?");
	device_set_position(cavern_front_door, 0);
	f_ai_garbage_kill( sg_e8m3_before_door, 15, 45, -1, -1, FALSE );
end

script static void f_start_event_e8m3_5()
	sleep_until(LevelEventStatus("start_event_5"), 1);
	print("START EVENT 5");
	b_end_player_goal = FALSE;
	sleep_until(ai_living_count(sg_e8m3_forest_init) <= 5);
	b_trigger_forest_adds = TRUE;
end

script static void f_start_event_e8m3_6()
	sleep_until(LevelEventStatus("start_event_6"), 1);
	print("START EVENT 6");
	sleep_until(b_trigger_forest_adds == TRUE);
	b_end_player_goal = TRUE;
	device_set_power(cavern_back_door, 1);
	sleep(1);
	device_set_position(cavern_back_door, 1);
end

script static void f_start_event_e8m3_8()
	sleep_until(LevelEventStatus("start_event_8"), 1);
	print("START EVENT 8");
	device_set_power(e8m3_release_marines, 1);
end

script static void f_end_event_e8m3_8()
	sleep_until(LevelEventStatus("end_event_8"), 1);
	print("END EVENT 8");
	device_set_power(e8m3_release_marines, 0);
	object_destroy_folder(e8m3_shield_2);
	b_shield_on = FALSE;
end





// ============================================	PLACEMENT SCRIPT	========================================================

// PHANTOM SCRIPTING

/*script command_script cs_e8m5_phantom_1()

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
	cs_fly_to( e8m5_phantom_wave_3_ps.p3 );
	
	f_unload_phantom( e8m5_phantom_wave_3, "dual" );

	print ("unload phantom_3");
	
	cs_fly_to( e8m5_phantom_wave_3_ps.p4 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p5 );
	cs_fly_to( e8m5_phantom_wave_3_ps.p6 );

	ai_erase (e8m5_phantom_wave_3);
end
*/