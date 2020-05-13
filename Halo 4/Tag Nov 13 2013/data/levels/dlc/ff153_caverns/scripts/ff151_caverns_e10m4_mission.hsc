// ======================================================================================================================
// ============================================ E10M4 MEZZANINE MISSION SCRIPT ==========================================
// ======================================================================================================================


// ===================================================	GLOBALS	=========================================================

global boolean e10m4_nomoremechs = FALSE;
global boolean e10m4_movetoexit = FALSE;
global boolean e10m4_leavebuttonarea = FALSE;
global boolean e10m4_playerinmech = FALSE;

// ================================================	STARTUP SCRIPT	=====================================================

script startup e10m4_caverns_startup()
	dprint( "Caverns E10M4 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e10m4_var_startup") ) then
		wake( e10m4_caverns_init);
	end
end


script dormant e10m4_caverns_init()
	print ("e10m4 variant started");
	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e10_m4", e10m4_main, e10m4_ff_all, e10m4_spawnpoints_0, 50);
	//	//	//	FOLDER SPAWNING	\\	\\	\\
	object_destroy (cavern_back_door);
	object_destroy (cavern_front_door);
	//	add "Devices" folders
	f_add_crate_folder (e10m4_devicemachines);
	//	add "Vehicles" folders
	f_add_crate_folder (e10m4_mechs);
	f_add_crate_folder (e10m4_pelicans);
	//	add "Crates" folders
	f_add_crate_folder (cr_e10m4_props);
	f_add_crate_folder (cr_e10m4_weaponracks);
	//	add Spawn point folders 
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_0, 50);					//	
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_1, 49);					//	
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_2, 48);					//	
	//	add "Items" folders
	//	add "Enemy Squad" Templates
	//	add "Objective Items"
	firefight_mode_set_objective_name_at( e10m4_aa_switch, 30);	//	
	firefight_mode_set_objective_name_at( e10m4_frontdoor_switch, 31);	//	
	//	add "LZ" areas
	thread (e10m4_threadlist());
	thread (e10m4_mechs());
	thread (e10m4_initialenemyspawns());
	thread (e10m4_gettomechs());
	thread (e10m4_puppeteer_start());
	dm_droppod_1 = e10m4_drop_1;
	//	dm_droppod_2 = e6m2_drop_02;
	//	dm_droppod_3 = e6m2_drop_03;
	//	dm_droppod_4 = e6m2_drop_04;
	//	dm_droppod_5 = e6m2_drop_05;
	thread (e10m4_deletestuff());
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	
end


script static void e10m4_puppeteer_start
	print ("starting puppetteer");
	sleep_until (f_spops_mission_ready_complete(), 1);
	//intro();
//	pup_disable_splitscreen(true);
//	pup_play_show ( );
	sleep (15);
//	sleep_until (f_narrativein_done == TRUE);
	f_spops_mission_intro_complete (TRUE);
//	pup_disable_splitscreen(false);
	print ("waiting for mission start");
	sleep_until( f_spops_mission_start_complete(), 1 );
	sleep_s (0.5);
	fade_in (0,0,0,15);
	object_cannot_take_damage(e10m4_covshield);
	print ("Shield is now immortal");
	thread (e10m4_vo_aa_guns());
//	effect_new_on_object_marker (environments\solo\m10_crash\fx\fire\parts\fire_calmly_burning_smoke.particle, e10m4_downedpelican01, "right_front_back_thruster");
//	effect_new_on_object_marker (environments\solo\m10_crash\fx\fire\parts\fire_calmly_burning_smoke.particle, e10m4_downedpelican02, "left_front_back_thruster");
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
end


script static void e10m4_mechs()
	repeat
			if	(object_get_health (e10m4_mech_01) <= 0)	then
				object_create_anew (e10m4_mech_01);
			end
			if	(object_get_health (e10m4_mech_02) <= 0)	then
				object_create_anew (e10m4_mech_02);
			end
			if	(object_get_health (e10m4_mech_03) <= 0)	then
				object_create_anew (e10m4_mech_03);
			end
			if	(object_get_health (e10m4_mech_04) <= 0)	then
				object_create_anew (e10m4_mech_04);
			end
			if	(object_get_health (e10m4_mech_05) <= 0)	then
				object_create_anew (e10m4_mech_05);
			end
			if	(object_get_health (e10m4_mech_06) <= 0)	then
				object_create_anew (e10m4_mech_06);
			end
			if	(object_get_health (e10m4_mech_07) <= 0)	then
				object_create_anew (e10m4_mech_07);
			end
			if	(object_get_health (e10m4_mech_08) <= 0)	then
				object_create_anew (e10m4_mech_08);
			end
			sleep (30 * 3);
	until (e10m4_nomoremechs == TRUE);
end


script static void e10m4_deletestuff()
	object_destroy(cr_e6_m3_pod_top_1);
	object_destroy(cr_e6_m3_pod_top_2);
	object_hide(cr_e6_m3_pod_top_1, true);
	object_hide(cr_e6_m3_pod_top_2, true);
	object_destroy(e6_m3_cov_base_01);
	object_destroy(e6_m3_cov_base_02);
	object_hide(e8m3_pod_1, true);
	object_destroy(e8m3_base_1);
	//Remove pods from E10_M2
	object_destroy(e10_m2_base_1);
	object_destroy(e10_m2_pod_1);
	object_destroy(e10_m2_base_2);
	object_destroy(e10_m2_pod_2);
	object_destroy(e10_m2_base_3);
	object_destroy(e10_m2_pod_3); 
end

// ============================================	MISSION SCRIPT	========================================================


									//*//*//*//*//*//*//*//*//*//*	Thread List	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_threadlist()
	thread (e10m4_yard02_1());
	thread (e10m4_yard02_2());
	thread (e10m4_yard02_3());
	thread (e10m4_yard03_1());
	thread (e10m4_yard03_2());
	thread (e10m4_yard03_3());
	thread (e10m4_yard03_4());
	thread (e10m4_yard03_5());
	thread (e10m4_yard03_6());
	thread (e10m4_yard03_7());
	thread (e10m4_walkway_1());
	thread (e10m4_buttonarea_1());
	thread (e10m4_leavethecave());
	thread (e10m4_exitarea_1());
	thread (e10m4_exitarea_2());
	thread (e10m4_exitarea_3());
	thread (e10m4_exitarea_4());
	thread (e10m4_exitarea_5());
	thread (e10m4_frontdoorswitch());
	thread (e10m4_endmission());
	print ("e10m4 threads threaded");
end


									//*//*//*//*//*//*//*//*//*//*	0.time_passed	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_initialenemyspawns()
	ai_place (sq_e10m4_mixed01);
	ai_place (sq_e10m4_4paw_01);
	ai_place (sq_e10m4_1eli_01);
	ai_place (sq_e10m4_2kni_01);
	ai_place (sq_e10m4_2kni_02);
	ai_place (sq_e10m4_2paw_01);
	ai_place (sq_e10m4_1jak_01);
	ai_place (sq_e10m4_2eli_01);
	ai_place (sq_e10m4_2jak_01);
	sleep (10);
	sleep_until (ai_living_count (e10m4_ff_all) <= 6, 1);
	if (e10m4_playerinmech == FALSE)	then
		thread (e10m4_vo_gotomech());
		sleep (30);
		sleep_until (e10m4_narrative_is_on == FALSE, 1);
		f_blip_object_cui (e10m4_mech_01, "navpoint_goto");
		f_blip_object_cui (e10m4_mech_02, "navpoint_goto");
		f_blip_object_cui (e10m4_mech_03, "navpoint_goto");
		f_blip_object_cui (e10m4_mech_04, "navpoint_goto");
		sleep (30);
		sleep_until (e10m4_narrative_is_on == FALSE, 1);
		f_new_objective (e10m4_obj_02);
	end
end


script static void e10m4_gettomechs()
	sleep_until (object_valid (e10m4_mech_01), 1);
	print ("e10m4 Mechs are now vehicles");
	vehicle (e10m4_mech_01);
	vehicle (e10m4_mech_02);
	vehicle (e10m4_mech_03);
	vehicle (e10m4_mech_04);
	sleep (30);
	sleep_until (vehicle_test_seat (e10m4_mech_01 , mantis_d) or	
							 vehicle_test_seat (e10m4_mech_02 , mantis_d) or	
							 vehicle_test_seat (e10m4_mech_03 , mantis_d) or	
							 vehicle_test_seat (e10m4_mech_04 , mantis_d), 1);
	print ("Player in Vehicle, moving to next goal.");
	f_unblip_object_cui (e10m4_mech_01);
	f_unblip_object_cui (e10m4_mech_02);
	f_unblip_object_cui (e10m4_mech_03);
	f_unblip_object_cui (e10m4_mech_04);
	sleep (60);
	e10m4_playerinmech = TRUE;
	b_end_player_goal = true;
end


									//*//*//*//*//*//*//*//*//*//*	1.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_yard02_1()
	sleep_until (LevelEventStatus ("e10m4_yard02_01"), 1);
	ai_place (sq_e10m4_mixed02);
	sleep (30 * 2);
	thread (e10m4_vo_keepkilling());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
end


script static void e10m4_yard02_2()
	sleep_until (LevelEventStatus ("e10m4_yard02_02"), 1);
	ai_place (sq_e10m4_6paw_01);
end


script static void e10m4_yard02_3()
	sleep_until (LevelEventStatus ("e10m4_yard02_03"), 1);
	ai_place (sq_e10m4_2kni_03);
end


script static void e10m4_yard03_1()
	sleep_until (LevelEventStatus ("e10m4_yard03_01"), 1);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	f_dlc_load_drop_pod (e10m4_drop_1, sq_e10m4_4eli_01, none, e10m4_droppod_01);
end


script static void e10m4_yard03_2()
	sleep_until (LevelEventStatus ("e10m4_yard03_02"), 1);
	ai_place (sq_e10m4_2kni_03);
end


script static void e10m4_yard03_3()
	sleep_until (LevelEventStatus ("e10m4_yard03_03"), 1);
	ai_place (sq_e10m4_2paw_02);
	ai_place (sq_e10m4_2bish_01);
end


script static void e10m4_yard03_4()
	sleep_until (LevelEventStatus ("e10m4_yard03_04"), 1);
	ai_place (sq_e10m4_2paw_03);
	ai_place (sq_e10m4_2bish_02);
end


									//*//*//*//*//*//*//*//*//*//*	2.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_yard03_5()
	sleep_until (LevelEventStatus ("e10m4_yard03_05"), 1);
	ai_place (sq_e10m4_2paw_04);
	ai_place (sq_e10m4_2bish_03);
end


script static void e10m4_yard03_6()
	sleep_until (LevelEventStatus ("e10m4_yard03_06"), 1);
	ai_place (sq_e10m4_2paw_05);
	ai_place (sq_e10m4_2bish_04);
end


script static void e10m4_yard03_7()
	sleep_until (LevelEventStatus ("e10m4_yard03_07"), 1);
	ai_place (sq_e10m4_2paw_06);
	ai_place (sq_e10m4_2bish_05);
end


script static void e10m4_walkway_1()
	sleep_until (LevelEventStatus ("e10m4_walkway_01"), 1);
	ai_place (sq_e10m4_2paw_07);
	ai_place (sq_e10m4_1kni_01);
end


									//*//*//*//*//*//*//*//*//*//*	3.object_destruction	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e10m4_buttonarea_1()
	sleep_until (LevelEventStatus ("e10m4_buttonarea_01"), 1);
	ai_place (sq_e10m4_1kni_02);
	e10m4_movetoexit = TRUE;
	device_set_power (e10m4_aa_switch, 1);
	thread (e10m4_vo_turnoffaaguns());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_03);
end


									//*//*//*//*//*//*//*//*//*//*	4.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_leavethecave()
	sleep_until (LevelEventStatus ("e10m4_movetoexterior"), 1);
	e10m4_leavebuttonarea = TRUE;
	object_destroy (e10m4_covshield);
	device_set_power (e10m4_aa_switch, 0);
	thread (e10m4_vo_killmore());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
end


script static void e10m4_exitarea_1()
	sleep_until (LevelEventStatus ("e10m4_exitarea_01"), 1);
	ai_place (sq_e10m4_2paw_08);
end


script static void e10m4_exitarea_2()
	sleep_until (LevelEventStatus ("e10m4_exitarea_02"), 1);
	ai_place (sq_e10m4_2paw_09);
end


script static void e10m4_exitarea_3()
	sleep_until (LevelEventStatus ("e10m4_exitarea_03"), 1);
	ai_place (sq_e10m4_2paw_10);
end


script static void e10m4_exitarea_4()
	sleep_until (LevelEventStatus ("e10m4_exitarea_04"), 1);
	ai_place (sq_e10m4_2paw_11);
end


script static void e10m4_exitarea_5()
	sleep_until (LevelEventStatus ("e10m4_exitarea_05"), 1);
	ai_place (sq_e10m4_2paw_12);
end


									//*//*//*//*//*//*//*//*//*//*		5. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_frontdoorswitch()
	sleep_until (LevelEventStatus ("e10m4_frontswitch"), 1);
	prepare_to_switch_to_zone_set(e10m4_second);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e10m4_second);	
	thread (e10m4_beachenemies());
	object_create (e10m4_frontdoor_switch);
	sleep (10);
	thread (e10m4_vo_doorswitch());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_04);
	device_set_power (e10m4_frontdoor_switch, 1);
	sleep (10);
	f_blip_object_cui (e10m4_frontdoor_switch, "navpoint_deactivate");
	sleep_until (device_get_position (e10m4_frontdoor_switch) > 0.0, 1);
	f_unblip_object_cui (e10m4_frontdoor_switch);
	sleep (30);
	device_set_power (e10m4_frontdoor_switch, 0);
	object_destroy (dm_e10m4_frontdoor);
	thread (e10m4_beachvocallout());
	b_end_player_goal = true;
end

									//*//*//*//*//*//*//*//*//*//*		6. no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_beachenemies()
	ai_place (sq_e10m4_4wraith_01);
	ai_place (sq_e10m4_1kni_03);
	ai_place (sq_e10m4_2kni_05);
	ai_place (sq_e10m4_2kni_06);
	ai_place (sq_e10m4_1wraith_01);
	ai_place (sq_e10m4_4eli_02);
	ai_place (sq_e10m4_2wraith_02);
	ai_place (sq_e10m4_2kni_07);
	ai_place (sq_e10m4_2eli_02);
end									


script static void e10m4_beachvocallout()
	sleep (60);
	thread (e10m4_vo_beachfight());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
	sleep (30);
	sleep_until (ai_living_count (e10m4_ff_all) <= 10, 1);
	thread (e10m4_vo_pelicanarrived());
	sleep (30);
	sleep_until (ai_living_count (e10m4_ff_all) <= 0, 1);
	thread (e10m4_vo_gettopelican());
end

									//*//*//*//*//*//*//*//*//*//*		7. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_endmission()
	sleep_until (LevelEventStatus ("e10m4_endmission"), 1);
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_05);
	sleep (30);
	fade_out (0, 0, 0, 15);
	e10m4_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
end

script static void e10m4_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end																


// ============================================	PLACEMENT SCRIPT	========================================================

script command_script cs_e10m4_phantom01()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 );
	sleep (30 * 1);
	ai_exit_limbo (sq_e10m4_phantom_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 );
	sleep (30 * 3);
	print ("everything is ready for phantom. moving out now");
//	cs_fly_to_and_face (ps_e10m4_phantom01.p0, ps_e10m4_phantom01.p0);
//	cs_fly_to_and_face (ps_e10m4_phantom01.p1, ps_e10m4_phantom01.p1);
//	cs_fly_to_and_face (ps_e10m4_phantom01.p2, ps_e10m4_phantom01.p2);
//	sleep (30 * 2);
//	f_unload_phantom (sq_e10m4_phantom_01, left);
//	sleep (30 * 5);
//	cs_fly_to_and_face (ps_e10m4_phantom01.p3, ps_e10m4_phantom01.p3);
//	cs_fly_to_and_face (ps_e10m4_phantom01.p4, ps_e10m4_phantom01.p4);
//	cs_fly_to_and_face (ps_e10m4_phantom01.p5, ps_e10m4_phantom01.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 );
	sleep (30 * 6);
	ai_erase (sq_e10m4_phantom_01);
end