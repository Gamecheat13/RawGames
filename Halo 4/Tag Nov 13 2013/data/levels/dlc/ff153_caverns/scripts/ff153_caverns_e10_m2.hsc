//=============================================================================================================================
//============================================ E10_M2 CAVERN KILL SCRIPT ==================================================
//=============================================================================================================================
global boolean b_e10m2_narrative_in_over = FALSE;

script startup f_cavern_e10_m2
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e10_m2") ) then
		wake( f_cavern_e10_m2_placement );
	end
end

script dormant f_cavern_e10_m2_placement()
	f_spops_mission_setup( "e10_m2", e10_m2_dz_1, gr_ff_e10_m2_all, sp_e10_m2_start_pos, 80 );
	print("___________________________________running e10 m2");
	//fade_out(0,0,0,15);

//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e10_m2_dms);
	f_add_crate_folder(e10m2_outside_crates);
	f_add_crate_folder(e10m2_inside_crates);
	//f_add_crate_folder(e10m2_towers);
	f_add_crate_folder(e10m2_dcs);
	f_add_crate_folder(e10_m2_cov_turrets);

	firefight_mode_set_objective_name_at(e10m2_switch_1, 1);
	firefight_mode_set_objective_name_at(e10m2_switch_2, 2);
	firefight_mode_set_objective_name_at(e10m2_switch_3, 3);
	firefight_mode_set_objective_name_at(e10m2_door_control, 4);
	firefight_mode_set_objective_name_at(e10m2_bridge_control, 5);
	firefight_mode_set_objective_name_at(e10m2_switch_back_door, 6);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sp_e10_m2_start_pos, 80);

//set objective names
	firefight_mode_set_objective_name_at(e10_m2_lz_00, 50);
	firefight_mode_set_objective_name_at(e10_m2_lz_01, 51);
	firefight_mode_set_objective_name_at(e10_m2_lz_02, 52);
	firefight_mode_set_objective_name_at(e10_m2_lz_03, 53);
	firefight_mode_set_objective_name_at(e10_m2_lz_04, 54);
	firefight_mode_set_objective_name_at(e10_m2_lz_05, 55);
	firefight_mode_set_objective_name_at(e10_m2_lz_06, 56);
		
//set squad group names
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_1, 1);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_2, 2);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_3, 3);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_4, 4);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_5, 5);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_6, 6);
	
	thread(f_e10_m2_intro());

// Add Crates
//	object_create_anew(e10_m2_base_1);
//	object_create_anew(e10_m2_pod_1);
//	object_create_anew(e10_m2_base_2);
//	object_create_anew(e10_m2_pod_2);
	object_create_anew(e10_m2_base_3);
	object_create_anew(e10_m2_pod_3);
	
	// Destroy Crates
  object_destroy(cr_ff153_caverns_bridge_a);
  object_destroy(cr_ff153_caverns_bridge_b);
  object_destroy(e8m3_base_1);

  object_set_scale(e10_m2_front_door_switch_base, 0.6, 1);
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e2_m1.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );
end

//----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS END -------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------	

//-----------------------------------------------------------------------
//--------- Starting Mission stuff --------------------------------------
//-----------------------------------------------------------------------
script command_script cs_e10m2_pawn_spawn()
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e10m2_knight_spawn()
	cs_phase_in_blocking();
end

script static void f_e10m2_narrative_in_over()
	b_e10m2_narrative_in_over = TRUE;
end

script static void f_e10_m2_intro()
	sleep_until (f_spops_mission_ready_complete(), 1);
//	if editor_mode() then
//		print ("editor mode, no intro playing");
//		b_e10m2_narrative_in_over = TRUE;
//	else
//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m1_vin_sfx_intro', NONE, 1);
//		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
//		ai_enter_limbo(gr_ff_e10_m2_all);
//		cinematic_start();

		//intro();
	//f_e6_m5_intro_vignette();
	
//	end
//	sleep_until(b_e10m2_narrative_in_over == TRUE);
//	cinematic_stop();	

	f_spops_mission_intro_complete( TRUE );
	
	sleep_until( f_spops_mission_start_complete(), 1 );
	
	sleep_s(0.5);
	fade_in(0,0,0,15);
	//ai_exit_limbo(gr_ff_e10_m2_all);
	
	ai_place(e10m2_pelican_in);
	ai_place(e10_m2_tower_1);
	ai_place(e10_m2_tower_2);
	ai_place(e10_m2_tower_3);
	print("_______________________ MILLER: coming in hot Crimson");
	sleep_s(3);
	print("_______________________ MILLER: lots of dudes");
	sleep_s(3);
	vo_glo_ordnance_01();
	sleep_s(2);
	ordnance_drop(e10_m2_ord_1, "storm_rocket_launcher");
	sleep_s(0.5);
	ordnance_drop(e10_m2_ord_2, "storm_rail_gun_pve");
	sleep_s(0.25);
	ordnance_drop(e10_m2_ord_3, "storm_lmg");
	sleep_s(0.25);
	ordnance_drop(e10_m2_ord_4, "storm_rocket_launcher");
	sleep_s(2.5);
	thread(vo_glo_gotit_02());
	//sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 16, 1);
	print("_______________________ MILLER: get to that door!");
	b_end_player_goal = TRUE;
	thread(f_e10m2_at_door());
	thread(f_e10_m2_cov_cavern_fighting());
end



script static void f_e10m2_at_door
	sleep_until(LevelEventStatus ("e10_m2_at_door"), 1);
	sleep_s(3);
	print("___________________________ MILLER: Its blocked. hold on, we are hacking the door controls!");
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 3, 1);
	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
	print("___________________________ ROLAND: Got it!");
	sleep_s(3);
	b_end_player_goal = TRUE;
	thread(f_e10_m2_front_door_open());
	device_set_power(e10m2_door_control, 1);
	device_set_power(cavern_front_door, 1);
	sleep_until(device_get_position(e10m2_door_control) == 1, 1);
	device_set_power(e10m2_door_control, 0);
	device_set_position(cavern_front_door, 1);
end

script static void f_e10_m2_cov_cavern_fighting()
	sleep_until(volume_test_players(t_e10_m2_spawn_cov_cavern), 1);
	ai_place(e10_m2_int_gunners);
	thread(f_e10_m2_spawn_back_door());
end
	
script static void f_e10_m2_front_door_open
	sleep_until(LevelEventStatus ("e10_m2_front_door_open"), 1);
	sleep_until((device_get_position(cavern_front_door) == 1), 1);
	//sleep_s(2);
	print("___________________________ROLAND: get in there boys!");
	sleep_s(3);
	//b_end_player_goal = TRUE;
	object_create_anew(e10_m2_lz_01);
	navpoint_track_object_named(e10_m2_lz_01, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10_m2_loc_1), 1);
	f_unblip_object_cui(e10_m2_lz_01);
	object_create_anew(e10_m2_lz_02);
	navpoint_track_object_named(e10_m2_lz_02, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
	f_unblip_object_cui(e10_m2_lz_02);
	sleep_s(3);
	print("___________________________ MILLER: doors locked, what do we do?");
	sleep_s(3);
	print("___________________________ ROLAND: hit this switch");
	navpoint_track_object_named(e10m2_switch_back_door, "navpoint_activate");
	thread(f_e10_m2_at_bridge_controls());
	
	sleep_until(volume_test_players(t_e10_m2_derez_switch), 1);
	navpoint_track_object(e10m2_switch_back_door, FALSE);
	object_destroy(e10m2_back_door_console);
	sleep_s(3);
	print("___________________________ MILLER: Roland, what happened?");
	sleep_s(3);
	print("___________________________ ROLAND: hold on, let me think");
	sleep_s(3);
	print("___________________________ MILLER: in the meantime, kill these dudes");
	sleep_s(3);
	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
	f_blip_ai_cui(gr_ff_e10_m2_all, "navpoint_enemy");
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 0, 1);
	
	//++++++++++++++++++++++++++++++++++++++++++
	// zone set switch here
	//+++++++++++++++++++++++++++++++++++++++++
	
	print("___________________________ MILLER: ok, all dead, now what?");
	sleep_s(3);
	print("___________________________ ROLAND: We need to get power back to that console.");
	sleep_s(3);
	print("___________________________ MILLER: OK,  how?");
	sleep_s(3);
	print("___________________________ ROLAND: Looks like we need to get access to the Forerunner structure.");
	sleep_s(3);
	print("___________________________ MILLER: The covenant have turned off the bridges, you will have to activate them again.");

	sleep_s(1);
	b_end_player_goal = TRUE;
	device_set_power(e10m2_bridge_control, 1);
	
	thread(f_e10_m2_at_security_office());
end

script static void f_e10_m2_at_bridge_controls
	sleep_until(LevelEventStatus ("e10_m2_at_bridge_controls"), 1);
	thread(f_e10m2_switch3_1_guards());
	thread(f_e10m2_switch3_2_guards());
	sleep_s(3);
	object_create_anew(cr_ff153_caverns_bridge_a);
	object_create_anew(cr_ff153_caverns_bridge_b);
	print("___________________________ now go here");
	sleep_s(1);
	
	object_create_anew(e10_m2_lz_06);
	navpoint_track_object_named(e10_m2_lz_06, "navpoint_goto");
	sleep_until(volume_test_players(t_e10_m2_security_office), 1);
	object_destroy(e10_m2_lz_06);
	sleep_s(1);
	print("___________________________ Miller: What are they looking for?");
	sleep_s(3);
	print("___________________________ ROLAND: Marking it now");
	sleep_s(3);
	b_end_player_goal = TRUE;
	device_set_power(e10m2_switch_3, 1);
end

script static void f_e10m2_switch3_1_guards
	sleep_until(volume_test_players(t_e10_m2_switch_3_1), 1);
	ai_place_in_limbo(e10_m2_int_fr_switch_3_1);
end

script static void f_e10m2_switch3_2_guards
	sleep_until(volume_test_players(t_e10_m2_switch_3_2), 1);
	ai_place_in_limbo(e10_m2_int_fr_switch_3_2);
	ai_place_with_birth(e10_m2_int_fr_switch_3_2_b);
end

script static void f_e10_m2_at_security_office
	sleep_until(LevelEventStatus ("e10_m2_at_security_office"), 1);
	device_set_power(e10m2_switch_3, 0);
	sleep_s(3);
	print("___________________________ MILLER: Ok, so now what did that do.");
	sleep_s(3);
	print("___________________________ ROLAND: I believe Crimson has activated the backup generator.");
	sleep_s(3);
	print("___________________________ ROLAND: Getting a read on its location now. There. Marking it.");
	object_create_anew(e10_m2_lz_04);
	navpoint_track_object_named(e10_m2_lz_04, "navpoint_goto");
	
	thread(f_e10m2_power_switch_1());
	thread(f_e10m2_power_switch_2());
	
	sleep_until(volume_test_players(t_e10_m2_switch_2), 1);
	object_destroy(e10_m2_lz_04);
	ai_place_in_limbo(e10_m2_int_fr_switch_2);
	ai_place_with_birth(e10_m2_int_fr_switch_2_b);
	sleep_s(2);
	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_2) <= 0, 1);
	sleep_s(3);
	print("___________________________ ROLAND: Activate that device. It should route power to the switch.");
	navpoint_track_object_named(e10m2_switch_2, "navpoint_activate");
	device_set_power(e10m2_switch_2, 1);
	sleep_until((device_get_position(e10m2_switch_2) == 1), 1);
	navpoint_track_object(e10m2_switch_2, FALSE);
	device_set_power(e10m2_switch_2, 0);
	object_destroy(e10m2_shell_2);
	print("___________________________ eventually, this will spin on and dissolve out.");
	sleep_s(3);
	print("___________________________ ROLAND: thats only hald the curcuit. go here now.");
	
	object_create_anew(e10_m2_lz_03);
	navpoint_track_object_named(e10_m2_lz_03, "navpoint_goto");
	
	sleep_until(volume_test_players(t_e10_m2_switch_1), 1);
	object_destroy(e10_m2_lz_03);
	ai_place_in_limbo(e10_m2_int_fr_switch_1);
	ai_place_with_birth(e10_m2_int_fr_switch_1_b);
	sleep_s(2);
	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_1) <= 0, 1);
	navpoint_track_object_named(e10m2_switch_1, "navpoint_activate");
	device_set_power(e10m2_switch_1, 1);
	sleep_until((device_get_position(e10m2_switch_1) == 1), 1);
	navpoint_track_object(e10m2_switch_1, FALSE);
	device_set_power(e10m2_switch_1, 0);
	object_destroy(e10m2_shell_1);
	
	print("___________________________ ROLAND: that should do it. terminal should be back up.");
	thread(f_e10_m2_at_back_door_controls_2());
	b_end_player_goal = TRUE;
	object_create_anew(e10m2_back_door_console);
	object_create_anew(e10m2_switch_back_door);
	device_set_power(e10m2_switch_back_door, 1);
end

script static void f_e10_m2_at_back_door_controls_2
	sleep_until(LevelEventStatus ("e10_m2_at_back_door_controls_2"), 1);
	device_set_power(e10m2_switch_back_door, 0);
	device_set_power(cavern_back_door, 1);
	device_set_position(cavern_back_door, 1);
	object_create_anew(e10_m2_lz_02);
	navpoint_track_object_named(e10_m2_lz_02, "navpoint_goto");
	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
	
	object_destroy(e10_m2_lz_06);
	object_create_anew(e10_m2_lz_07);
	navpoint_track_object_named(e10_m2_lz_07, "navpoint_goto");
	sleep_until(volume_test_players(t_e10_m2_end), 1);
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	b_end_player_goal = TRUE;
end

script static void f_e10m2_power_switch_1()
	sleep_until(device_get_position(e10m2_switch_1) == 1, 1);
	device_set_power(e10m2_switch_1, 0);
end

script static void f_e10m2_power_switch_2()
	sleep_until(device_get_position(e10m2_switch_2) == 1, 1);
	device_set_power(e10m2_switch_2, 0);
end

script static void f_e10_m2_at_back_door
	sleep_until(LevelEventStatus ("e10_m2_at_3rd_control"), 1);
	object_create_anew(e10_m2_lz_06);
	navpoint_track_object_named(e10_m2_lz_06, "navpoint_goto");
	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
	
	object_destroy(e10_m2_lz_06);
	object_create_anew(e10_m2_lz_07);
	navpoint_track_object_named(e10_m2_lz_07, "navpoint_goto");
	sleep_until(volume_test_players(t_e10_m2_end), 1);
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	b_end_player_goal = TRUE;
end

script command_script cs_e10_m2_tower1_grunt1()
	ai_vehicle_enter(e10_m2_tower_1.spawn_points_0, (object_get_turret(e10_m2_pod_1, 2)));
end

script command_script cs_e10_m2_tower2_grunt1()
	ai_vehicle_enter(e10_m2_tower_2.spawn_points_0, (object_get_turret(e10_m2_pod_2, 2)));
end

script command_script cs_e10_m2_tower3_grunt1()
	ai_vehicle_enter(e10_m2_tower_3.spawn_points_0, (object_get_turret(e10_m2_pod_3, 1)));
end

script static void f_e10_m2_spawn_back_door
	sleep_until(volume_test_players(t_e10_m2_spawn_back_door), 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 15 then
		ai_place(e10_m2_int_back_door);
	end
end

script command_script cs_e10m2_pelican_in
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(5);
	cs_fly_to_and_face (e10m2_pelican_in.p0, e10m2_pelican_in.p4);
	sleep_s(5);
	cs_fly_to_and_face (e10m2_pelican_in.p1, e10m2_pelican_in.p2);
	cs_fly_to_and_face (e10m2_pelican_in.p2, e10m2_pelican_in.p3);
	cs_fly_to_and_face (e10m2_pelican_in.p3, e10m2_pelican_in.p3);
	ai_erase(e10m2_pelican_in);
end