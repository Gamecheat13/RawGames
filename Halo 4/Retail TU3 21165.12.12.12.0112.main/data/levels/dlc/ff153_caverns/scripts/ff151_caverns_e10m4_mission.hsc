// ======================================================================================================================
// ============================================ E10M4 MEZZANINE MISSION SCRIPT ==========================================
// ======================================================================================================================


// ===================================================	GLOBALS	=========================================================

global boolean e10m4_nomoremechs = FALSE;
global boolean e10m4_movetoexit = FALSE;
global boolean e10m4_leavebuttonarea = FALSE;
global boolean e10m4_playerinmech = FALSE;
global boolean e10m4_pelican_has_landed = FALSE;
global boolean e10m4_calloutshield = FALSE;
global boolean e10m4_movetomechnow = FALSE;
global boolean e10m4_over = FALSE;
global short e10m4_coresdead = 0;
global short e10m4_rumble = 0;
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

	//	add "Vehicles" folders
	f_add_crate_folder (e10m4_mechs);
	//	add "Crates" folders
	f_add_crate_folder (cr_e10m4_props);
	f_add_crate_folder (cr_e10m4_weaponracks);
	f_add_crate_folder (cr_e10m4_objectivecrates);
	// Turn on Light Bridge Audio
	if not object_valid( light_bridge_audio_a ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
		object_create( light_bridge_audio_a );
	end
	if not object_valid( light_bridge_audio_b ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
		object_create( light_bridge_audio_b );
	end
	
	//	add Spawn point folders 
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_0, 50);					//	
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_1, 49);					//	
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_2, 48);					//	
	firefight_mode_set_crate_folder_at( e10m4_spawnpoints_3, 47);					//	
	//	add "Items" folders
	f_add_crate_folder (e10m4_ammoboxes);
	//	add "Enemy Squad" Templates
	firefight_mode_set_squad_at (sq_e10m4_pawtemplate_01, 1);							//	Pawn Squad near Yard 3
	firefight_mode_set_squad_at (sq_e10m4_pawtemplate_02, 2);							//	Pawn Squad near Yard 3
	firefight_mode_set_squad_at (sq_e10m4_knitemplate_01, 3);							//	Knight Squad near Yard 3
	//	add "Objective Items"
	firefight_mode_set_objective_name_at( e10m4_aa_switch, 30);	//	
	firefight_mode_set_objective_name_at( e10m4_frontdoor_switch, 31);	//	
	//	add "LZ" areas
	thread (e10m4_threadlist());
	//thread (e10m4_mechs());
	thread (e10m4_initialenemyspawns());
	thread (e10m4_gettomechs());
	thread (e10m4_puppeteer_start());
	thread (e10m4_deletestuff());
	thread (e10m4_garbageman());
	dm_droppod_1 = e10m4_drop_1;
	dm_droppod_2 = e10m4_drop_2;
	dm_droppod_3 = e10m4_drop_3;
	dm_droppod_4 = e10m4_drop_4;
	dm_droppod_5 = e10m4_drop_5;
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	
end


script static void e10m4_puppeteer_start
	print ("starting puppeteer");
	sleep_until (f_spops_mission_ready_complete(), 1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_main_sfx, 1 ); //AUDIO!

	thread(f_e10_m4_start_fx());
	
//	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_main_bottom_fx, f_app_main_top_fx);
//	sleep(5);
//	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	object_set_scale(caverns_app_oct, 0.6, 1);
	pup_play_show (pup_e10_m4_main_app);
	effect_new_on_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core01, core_pos);
	effect_new_on_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core02, core_pos);
	effect_new_on_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core03, core_pos);
	thread (aud_e10m4_music_start());
	f_spops_mission_intro_complete (TRUE);
	print ("waiting for mission start");
	sleep_until( f_spops_mission_start_complete(), 1 );
	sleep (45);
	thread (aud_e10m4_player_start());
	device_set_power(cavern_back_door, 1);  // added by KSchmitt 10/11/12
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_retexturedtempledoor_open_mnde845', cavern_back_door, 1 ); //AUDIO!
	device_set_position(cavern_back_door, 1);
	thread (e10m4_random_rumble());
	object_cannot_take_damage(e10m4_covshield);
	object_cannot_take_damage (e10m4_core01);
	object_cannot_take_damage (e10m4_core02);
	object_cannot_take_damage (e10m4_core03);
	print ("Shield is now immortal");
	thread (f_e10_m4_core_attach_setup());
	sleep (180);
	thread (vo_e10m4_narr_in());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
	thread (vo_e10m4_skyfall());
end


script static void e10m4_garbageman()
	repeat
		add_recycling_volume(tv_e10m4_garbage, 0, 5);
		add_recycling_volume(tv_e10m4_yard02, 0, 5);
		sleep(5*30);
	until(e10m4_movetoexit == TRUE);
end


script static void f_e10_m4_start_fx()
	if not object_valid( f_app_main_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_main_sfx_loop );
		dprint ( "=========== TURN ON F_APP_MAIN BEAM ===========" );
	end

	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_bottom_fx_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_bottom_fx_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_2_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_2_cap);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg_on.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg_on.effect, f_app_main_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup_on.effect, f_app_main_top_fx_cap);
	sleep(5);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_bottom_fx_cap);
	if not object_valid( f_app_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_1_sfx_loop );
		dprint ( "=========== TURN ON F_APP_1 BEAM ===========" );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_bottom_fx_cap);
	if not object_valid( f_app_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_2_sfx_loop );
		dprint ( "=========== TURN ON F_APP_2 BEAM ===========" );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_2_cap);
	if not object_valid( f_app_switch_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_1_sfx_loop );
		dprint ( "=========== TURN ON F_APP_SWITCH_1 BEAM ===========" );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_2_cap);
	if not object_valid( f_app_switch_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_2_sfx_loop );
		dprint ( "=========== TURN ON F_APP_SWITCH_2 BEAM ===========" );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_app_main_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup.effect, f_app_main_top_fx_cap);
	
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_1_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_2_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_1_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_2_hardlight);
	
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_b);
	
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_b);
	
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_b);
	
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx_lg.area_screen_effect, f_obj_main_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_1_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_2_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_1_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_2_glare);
	

end


script static void e10m4_mechs()
	repeat
			if	(object_get_health (e10m4_mech_01) <= 0)	then
				sleep (90);
				object_create_anew (e10m4_mech_01);
			end
//			if	(object_get_health (e10m4_mech_02) <= 0)	then
//				sleep (90);
//				object_create_anew (e10m4_mech_02);
//			end
//			if	(object_get_health (e10m4_mech_03) <= 0)	then
//				sleep (90);
//				object_create_anew (e10m4_mech_03);
//			end
//			if	(object_get_health (e10m4_mech_04) <= 0)	then
//				sleep (90);
//				object_create_anew (e10m4_mech_04);
//			end
			sleep (90);
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
	thread (e10m4_yard03_8());
	thread (e10m4_yard03_9());
	thread (e10m4_yard03_10());
	thread (e10m4_yard03_11());
	thread (e10m4_yard03_12());
	thread (e10m4_yard03_13());
	thread (e10m4_yard03_14());
	thread (e10m4_yard03_15());
	thread (e10m4_yard03_16());
	thread (e10m4_yard03_17());	
	thread (e10m4_walkway_1());
	thread (e10m4_buttonarea_1());
	thread (e10m4_walkway02());
	thread (e10m4_walkway03());
	thread (e10m4_walkway04());
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
	ai_place (sq_e10m4_aaturrets);
	ai_place (sq_e10m4_2eli_10);
	ai_place (sq_e10m4_2eli_09);
	ai_place (sq_e10m4_2paw_01);
	ai_place (sq_e10m4_2eli_03);
	ai_place (sq_e10m4_mixed01);
	//ai_place (sq_e10m4_1eli_02);
	//ai_place (sq_e10m4_2eli_01);
	thread (e10m4_shield_callout());
	sleep (10);
	sleep_until (ai_living_count (e10m4_ff_all) <= 8, 1);
	if (e10m4_playerinmech == FALSE)	then
		sleep_until (e10m4_narrative_is_on == FALSE, 1);
		sleep (60);
		e10m4_movetomechnow = TRUE;
		thread (aud_e10m4_pelican_mantis());
		thread (vo_e10m4_grab_toys());
		sleep (30);
		sleep_until (e10m4_narrative_is_on == FALSE, 1);
		f_blip_object_cui (e10m4_mech_01, "navpoint_goto");
//		f_blip_object_cui (e10m4_mech_02, "navpoint_goto");
//		f_blip_object_cui (e10m4_mech_03, "navpoint_goto");
//		f_blip_object_cui (e10m4_mech_04, "navpoint_goto");
		f_new_objective (e10m4_obj_02);
	end
end


script static void e10m4_gettomechs()
	sleep_until (object_valid (e10m4_mech_01), 1);
	object_cannot_take_damage (e10m4_mech_01);
	print ("e10m4 Mechs are now vehicles");
	vehicle (e10m4_mech_01);
//	vehicle (e10m4_mech_02);
//	vehicle (e10m4_mech_03);
//	vehicle (e10m4_mech_04);
	sleep (30);
	sleep_until (vehicle_test_seat (e10m4_mech_01 , mantis_d), 1);
	print ("Player in Vehicle, moving to next goal.");
	f_unblip_object_cui (e10m4_mech_01);
//	f_unblip_object_cui (e10m4_mech_02);
//	f_unblip_object_cui (e10m4_mech_03);
//	f_unblip_object_cui (e10m4_mech_04);
	sleep (60);
	e10m4_playerinmech = TRUE;
	object_can_take_damage (e10m4_mech_01);
	thread (e10m4_garbage_collect_02());
	thread (aud_e10m4_mantis_enter());
	thread (vo_e10m4_in_a_mantis());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
	b_end_player_goal = true;
end


script static void e10m4_pawn01_reinforcement()
	sleep_until (LevelEventStatus ("e10m4_pawns01"), 1);
	ai_place (sq_e10m4_pawtemplate_01);
end


script static void e10m4_pawn02_reinforcement()
	sleep_until (LevelEventStatus ("e10m4_pawns02"), 1);
	ai_place (sq_e10m4_pawtemplate_02);
end


script static void e10m4_knight_reinforcement()
	sleep_until (LevelEventStatus ("e10m4_knights"), 1);
	ai_place_in_limbo (sq_e10m4_knitemplate_01);
end


script static void e10m4_garbage_collect_02()
	print ("Starting Garbage Collection");
	repeat
		garbage_collect_unsafe();
		sleep_s (2);		
	until (e10m4_leavebuttonarea == TRUE);
	print ("Ending Garbage Collection");
end


									//*//*//*//*//*//*//*//*//*//*	1.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_yard02_1()
	sleep_until (LevelEventStatus ("e10m4_yard02_01"), 1);
	ai_place (sq_e10m4_1gho_01);
	//ai_place (sq_e10m4_1gho_02);
	ai_place_in_limbo (sq_e10m4_phantom_01);
	sleep (30 * 2);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	thread (aud_e10m4_phantom_arrives());
end

script static void e10m4_shield_callout()
	sleep_until (volume_test_players (tv_e10m4_shield_callout) or e10m4_calloutshield == TRUE, 1);
	sleep (60);
	thread (vo_e10m4_shield_blocking());
end

script static void e10m4_yard02_2()
	sleep_until (LevelEventStatus ("e10m4_yard02_02"), 1);
	ai_place (sq_e10m4_6paw_01);
	print ("Yard 02-2 loaded");
end


script static void e10m4_yard02_3()
	sleep_until (LevelEventStatus ("e10m4_yard02_03"), 1);
	ai_place_in_limbo (sq_e10m4_2kni_03);
	thread (aud_e10m4_fore_reinforcements01());
	print ("Yard 02-3 loaded");
end


script static void e10m4_yard03_1()
	sleep_until (LevelEventStatus ("e10m4_yard03_01"), 1);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (vo_e10m4_globals_miller_droppod_01());
	ai_place_in_limbo (sq_e10m4_mixed03);
	thread (f_dlc_load_drop_pod (e10m4_drop_1, sq_e10m4_mixed03, none, e10m4_droppod_01));
	thread (aud_e10m4_droppod());
	f_new_objective (e10m4_obj_01);
	print ("Yard 03-1 loaded");
end


script static void e10m4_yard03_2()
	sleep_until (LevelEventStatus ("e10m4_yard03_02"), 1);
	ai_place_in_limbo (sq_e10m4_2kni_04);
	thread (aud_e10m4_fore_reinforcements02());
	print ("Yard 03-2 loaded");
end


script static void e10m4_yard03_3()
	sleep_until (LevelEventStatus ("e10m4_yard03_03"), 1);
	ai_place (sq_e10m4_2paw_02);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
//	sleep_s(3);
	ai_place_in_limbo (sq_e10m4_2bish_01);
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
	thread (aud_e10m4_bish_reinforcements01());
	print ("Yard 03-3 loaded");
end


script static void e10m4_yard03_4()
	sleep_until (LevelEventStatus ("e10m4_yard03_04"), 1);
	
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04); 
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	sleep_s(3);
	ai_place_in_limbo (sq_e10m4_2bish_04);
	//ai_place_in_limbo (sq_e10m4_2bish_02);
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04 );
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	sleep_s(0.5);
//	
//	sleep_s(3);
//	
//	sleep_s(3);
//	
//	sleep_s(1.5);
	print ("Yard 03-4 loaded");
	
end


									//*//*//*//*//*//*//*//*//*//*	2.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_yard03_5()
	sleep_until (LevelEventStatus ("e10m4_yard03_05"), 1);
	ai_place (sq_e10m4_2paw_04);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	sleep_s(3);
	ai_place_in_limbo (sq_e10m4_2bish_03);
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
	ai_place_with_shards (sq_e10m4_shardturr_01);
	thread (aud_e10m4_bish_reinforcements02());
	print ("Yard 03-5 loaded");
end


script static void e10m4_yard03_6()
	sleep_until (LevelEventStatus ("e10m4_yard03_06"), 1);
	ai_place (sq_e10m4_2paw_05);
	ai_place (sq_e10m4_2paw_03);
	e10m4_calloutshield = TRUE;
	print ("Yard 03-6 loaded");
end


script static void e10m4_yard03_7()
	sleep_until (LevelEventStatus ("e10m4_yard03_07"), 1);
	ai_place (sq_e10m4_2paw_06);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05 );
//	sleep_s(3);
	ai_place_in_limbo (sq_e10m4_2bish_05);
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05 );
	thread (aud_e10m4_bish_reinforcements03());
	print ("Yard 03-7 loaded");
end


script static void e10m4_yard03_8()
	sleep_until (LevelEventStatus ("e10m4_yard03_08"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_06);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01 );
	print ("Yard 03-8 loaded");
end


script static void e10m4_yard03_9()
	sleep_until (LevelEventStatus ("e10m4_yard03_09"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_07);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
	thread (aud_e10m4_bish_reinforcements04());
	print ("Yard 03-9 loaded");
end


script static void e10m4_yard03_10()
	sleep_until (LevelEventStatus ("e10m4_yard03_10"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_08);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
	//ai_place_with_shards (sq_e10m4_shardturr_02);

//			SPAWN KNIGHTS HERE
	print ("Yard 03-10 loaded");
end


script static void e10m4_yard03_11()
	sleep_until (LevelEventStatus ("e10m4_yard03_11"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_09);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04 );
	
	thread (vo_e10m4_how_going_roland());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
	thread (aud_e10m4_bish_reinforcements05());
	print ("Yard 03-11 loaded");
end

script static void e10m4_yard03_12()
	sleep_until (LevelEventStatus ("e10m4_yard03_12"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_10);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05);
//	sleep_s(3);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05 );
	print ("Yard 03-12 loaded");
end


script static void e10m4_yard03_13()
	sleep_until (LevelEventStatus ("e10m4_yard03_13"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_11);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01);
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal01);
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01);
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal01);
	thread (aud_e10m4_bish_reinforcements06());
	print ("Yard 03-13 loaded");
end


script static void e10m4_yard03_14()
	sleep_until (LevelEventStatus ("e10m4_yard03_14"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_12);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02);
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal02 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal02 );

//	SPAWN CRAWLERS HERE
	print ("Yard 03-14 loaded");

end


script static void e10m4_yard03_15()
	sleep_until (LevelEventStatus ("e10m4_yard03_15"), 1);
	ai_place_with_shards (sq_e10m4_shardturr_03);
	ai_place_in_limbo (sq_e10m4_2bish_13);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal03 );
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal03 );
	print ("Yard 03-15 loaded");
end


script static void e10m4_yard03_16()
	sleep_until (LevelEventStatus ("e10m4_yard03_16"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_14);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04);
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal04);
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04);
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal04);
	print ("Yard 03-16 loaded");
end


script static void e10m4_yard03_17()
	sleep_until (LevelEventStatus ("e10m4_yard03_17"), 1);
	ai_place_in_limbo (sq_e10m4_2bish_15);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05); 
//	sleep_s(0.5);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05);
//	sleep_s(6);
//	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, fl_e10m4_bishportal05);
//	sleep_s(1.5);
//	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05);
//	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, fl_e10m4_bishportal05);
	thread (aud_e10m4_bish_reinforcements07());
	print ("Yard 03-17 loaded");
end


script static void e10m4_walkway_1()
	sleep_until (LevelEventStatus ("e10m4_walkway_01"), 1);
	ai_place (sq_e10m4_2paw_07);
	ai_place_in_limbo (sq_e10m4_1kni_01);
end


									//*//*//*//*//*//*//*//*//*//*	3.time_passed	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e10m4_buttonarea_1()
	sleep_until (LevelEventStatus ("e10m4_buttonarea_01"), 1);
	ai_place_in_limbo (sq_e10m4_3kni_01);
	e10m4_movetoexit = TRUE;
	thread (vo_e10m4_hang_on_orbs());
	thread (aud_e10m4_orbs());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	thread (e10m4_turnoffcore01fx());
	thread (e10m4_turnoffcore02fx());
	thread (e10m4_turnoffcore03fx());
	thread (e10m4_1coredown());
	thread (e10m4_2coresdown());
	thread (e10m4_gotodoor());
	f_new_objective (e10m4_obj_03);
	sleep_until (e10m4_coresdead == 3, 1);
	
	thread(f_e10_m4_kill_main_core_fx());
	
	thread (aud_e10m4_all_destroyed());
	sleep (30);
	effect_kill_from_flag (levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_main_bottom_fx);
	effect_kill_from_flag (levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_main_bottom_fx);
	ai_erase (sq_e10m4_aaturrets.turret05);
	//ai_erase (sq_e10m4_aaturrets.turret06);
	sleep (60);
	b_end_player_goal = true;
end

script static void f_e10_m4_kill_main_core_fx()
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_stop_mnde862', f_app_main_sfx, 1 ); //AUDIO!

	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg_off.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup_off.effect, f_app_main_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg_off.effect, f_app_main_bottom_fx_cap);
	sleep(2);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg.effect, f_app_main_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup.effect, f_app_main_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_app_main_bottom_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_t);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_b);
	
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_switch_1_sfx, 1 ); //AUDIO!
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_switch_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_2_2_cap);
	sleep(2);
	object_destroy ( f_app_switch_1_sfx_loop ); //KILL AUDIO!
	dprint ( "=========== TURN OFF F_APP_SWITCH_1 BEAM ===========" );
	object_destroy ( f_app_switch_2_sfx_loop ); //KILL AUDIO!
	dprint ( "=========== TURN OFF F_APP_SWITCH_2 BEAM ===========" );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_1);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_2);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_1_hardlight );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_2_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_1_glare);
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_2_glare);
	
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx_lg.area_screen_effect, f_obj_main_glare);
	
	object_destroy ( f_app_main_sfx_loop ); //KILL AUDIO!
end


script static void e10m4_1coredown()
	sleep_until (e10m4_coresdead == 1, 1);
	ai_erase (sq_e10m4_aaturrets.turret01);
	ai_erase (sq_e10m4_aaturrets.turret02);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	sleep (60);
	print ("1 Core down!");
	thread (vo_e10m4_one_orb_destroyed());
end


script static void e10m4_2coresdown()
	sleep_until (e10m4_coresdead == 2, 1);
	//ai_erase (sq_e10m4_aaturrets.turret03);
	ai_erase (sq_e10m4_aaturrets.turret04);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	sleep (60);
	print ("2 Cores down!");
	thread (vo_e10m4_two_orb_destroyed());
	thread (aud_e10m4_final_object());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	object_can_take_damage (e10m4_core03);
	effect_kill_object_marker( levels\dlc\ff152_vortex\crates\forerunner_spherebase\forerunner_spherebase\fx\spherebase_shield.effect, e10m4_core03, core_pos);
	//	SET UP cavern_app_main_bottom IN PLACE OF CORE 3
	f_blip_object_cui (e10m4_core03->core_object(), "navpoint_healthbar_neutralize");
end


script static void e10m4_turnoffcore01fx()
	sleep_until (object_get_health (e10m4_core01->core_object()) <= 0, 1);
	thread(f_e10_m4_kill_fx_core_1());
	e10m4_coresdead = e10m4_coresdead + 1;
end

script static void f_e10_m4_kill_fx_core_1()
	sound_impulse_start('sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_1_bottom_fx, f_app_1_top_fx_cap);
	sleep(2);
	object_destroy ( f_app_1_sfx_loop ); //KILL AUDIO!
	dprint ( "=========== TURN OFF F_APP_1 BEAM ===========" );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_1_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_bottom_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_1_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_1_glare);
	
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_t);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_b);
	interpolator_start(beam_front_off);
	interpolator_stop(beam_front_off);
end


script static void e10m4_turnoffcore02fx()
	sleep_until (object_get_health (e10m4_core02->core_object()) <= 0, 1);
	thread(f_e10_m4_kill_fx_core_2());
	e10m4_coresdead = e10m4_coresdead + 1;
end

script static void f_e10_m4_kill_fx_core_2()
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_2_bottom_fx_cap);
	sleep(2);
	object_destroy ( f_app_2_sfx_loop ); //KILL AUDIO!
	dprint ( "=========== TURN OFF F_APP_2 BEAM ===========" );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_2_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_bottom_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_2_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_2_glare);
	
	
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_t);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_b);
	interpolator_start(beam_middle_off);
	interpolator_stop(beam_middle_off);
end


script static void e10m4_turnoffcore03fx()
	sleep_until (object_get_health (e10m4_core03->core_object()) <= 0, 1);
	e10m4_coresdead = e10m4_coresdead + 1;
end


script static void e10m4_movecore01()
	repeat
		object_move_to_flag (e10m4_core01, 1.5, fl_e10m4_orb01bot);
		object_move_to_flag (e10m4_core01, 1.5, fl_e10m4_orb01top);
	until (object_get_health (e10m4_core01) <= 0);
end


script static void e10m4_movecore02()
	repeat
		object_move_to_flag (e10m4_core02, 1.5, fl_e10m4_orb02bot);
		object_move_to_flag (e10m4_core02, 1.5, fl_e10m4_orb02top);
	until (object_get_health (e10m4_core02) <= 0);
end


script static void e10m4_movecore03()
	repeat
		object_move_to_flag (e10m4_core03, 1.5, fl_e10m4_orb03bot);
		object_move_to_flag (e10m4_core03, 1.5, fl_e10m4_orb03top);
	until (object_get_health (e10m4_core03) <= 0);
end


script static void e10m4_walkway02()
	sleep_until (LevelEventStatus ("e10m4_walkway02"), 1);
	ai_place_in_limbo (sq_e10m4_1kni_04);
	ai_place (sq_e10m4_3paw_01);
end


script static void e10m4_walkway03()
	sleep_until (LevelEventStatus ("e10m4_walkway03"), 1);
	ai_place_in_limbo (sq_e10m4_2kni_08);
	ai_place (sq_e10m4_2paw_13);
end


script static void e10m4_walkway04()
	sleep_until (LevelEventStatus ("e10m4_walkway04"), 1);
	ai_place (sq_e10m4_4paw_02);
end


									//*//*//*//*//*//*//*//*//*//*	4.time_passed	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\
									
script static void e10m4_gotodoor()
	sleep_until (LevelEventStatus ("e10m4_gotolockeddoor"), 1);
	e10m4_leavebuttonarea = TRUE;
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e8m3_cov_shield_off_mnde875', e10m4_covshield, 1 ); //AUDIO!
	object_destroy (e10m4_covshield);
	device_set_power (e10m4_aa_switch, 0);
	thread (vo_e10m4_third_orb_destroyed());
	sleep (30);
	thread (aud_e10m4_pawns());
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	thread (vo_e10m4_global_miller_waypoint_01());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_04);
	spops_blip_object (cavern_front_door, TRUE, "navpoint_goto");
	sleep_until (volume_test_players (tv_e10m4_lockeddoor_callout), 1);
	thread (aud_e10m4_lockeddoor());
	sleep (60);
	spops_unblip_object (cavern_front_door);
	thread (vo_e10m4_door_is_locked());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	b_end_player_goal = true;
end
									
									//*//*//*//*//*//*//*//*//*//*	5.no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_leavethecave()
	sleep_until (LevelEventStatus ("e10m4_movetoexterior"), 1);
	thread (aud_e10m4_enemy_reinforcements());
end


script static void e10m4_exitarea_1()
	sleep_until (LevelEventStatus ("e10m4_exitarea_01"), 1);
	ai_place (sq_e10m4_2paw_08);
	thread (vo_e10m4_globals_miller_crawlers_01());
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
	sleep_until (ai_living_count (e10m4_ff_all) <= 5, 1);
	thread (vo_e10m4_global_miller_few_more_01());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_blip_ai_cui (e10m4_ff_all, "navpoint_enemy");
end


									//*//*//*//*//*//*//*//*//*//*		6. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_frontdoorswitch()
	sleep_until (LevelEventStatus ("e10m4_frontswitch"), 1);
	sleep (90);
	prepare_to_switch_to_zone_set(e10m4_second);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e10m4_second);	
	thread (e10m4_beachenemies());
	object_create (e10m4_frontdoor_switch);
	sleep (10);
	thread (vo_e10m4_way_through());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_06);
	device_set_power (cavern_front_door, 1);
	device_set_power (e10m4_frontdoor_switch, 1);
	sleep (10);
	f_blip_object_cui (cavern_fdoor_button_in, "navpoint_deactivate");
	sleep_until (device_get_position (e10m4_frontdoor_switch) > 0.0, 1);
	f_unblip_object_cui (cavern_fdoor_button_in);
	sleep (30);
	device_set_position (cavern_fdoor_button_in, 1);
	sleep (50);
	device_set_power (e10m4_frontdoor_switch, 0);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_cavern_door_open_mnde9186', cavern_front_door, 1 ); //AUDIO!
	device_set_position (cavern_front_door, 1);
	thread (aud_e10m4_door_opened());
	sleep (180);
	thread (e10m4_beachvocallout());
	ai_place_in_limbo (sq_e10m4_2eli_06);
	ai_place_in_limbo (sq_e10m4_2eli_07);
	ai_place_in_limbo (sq_e10m4_2eli_08);
	ai_place_in_limbo (sq_e10m4_1eli_05);
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	thread (f_dlc_load_drop_pod (e10m4_drop_3, sq_e10m4_2eli_06, none, e10m4_droppod_03));
	thread (f_dlc_load_drop_pod (e10m4_drop_4, sq_e10m4_2eli_07, sq_e10m4_1eli_05, e10m4_droppod_04));
	thread (f_dlc_load_drop_pod (e10m4_drop_5, sq_e10m4_2eli_08, none, e10m4_droppod_05));
	b_end_player_goal = true;
end

									//*//*//*//*//*//*//*//*//*//*		7. no_more_waves	*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_beachenemies()
	ai_place (sq_e10m4_2wraith_01);
	ai_place (sq_e10m4_1eli_03);
	ai_place (sq_e10m4_2eli_04);
	ai_place (sq_e10m4_1eli_04);
	ai_place (sq_e10m4_2wraith_02);
	ai_place (sq_e10m4_2eli_05);
	ai_place (sq_e10m4_2gho_01);
	ai_place (sq_e10m4_1gho_03);
end									


script static void e10m4_beachvocallout()
	sleep (60);
	thread (vo_e10m4_clear_the_breach());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_01);
	sleep (30);
	sleep_until (ai_living_count (e10m4_ff_all) <= 8, 1);
	print ("last drop pod");
	//	New drop pod load (dm object name, squad 01, squad 02, pod vehicle name);
	ai_place_in_limbo (sq_e10m4_4eli_02);
	ai_place_in_limbo (sq_e10m4_2eli_02);
	thread (f_dlc_load_drop_pod (e10m4_drop_2, sq_e10m4_4eli_02, sq_e10m4_2eli_02, e10m4_droppod_02));
	sleep (60);
	thread (vo_e10m4_globals_miller_droppod_02());
	sleep (30);
	sleep_until (ai_living_count (e10m4_ff_all) <= 5, 1);
	thread (vo_e10m4_miller_few_more_03());
	sleep (30);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	sleep_until (ai_living_count (e10m4_ff_all) <= 0, 1);
	thread (aud_e10m4_ai_dead());
end

									//*//*//*//*//*//*//*//*//*//*		8. time_passed		*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\

script static void e10m4_endmission()
	sleep_until (LevelEventStatus ("e10m4_endmission"), 1);
	print ("starting end mission script");
	sleep (90);
	prepare_to_switch_to_zone_set(zs_e10m4_out);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (zs_e10m4_out);	
	sleep (30);
	ai_place_in_limbo (sq_e10m4_pelican_01);
	sleep (60);
	thread (vo_e10m4_pelican_arrives());
	thread (aud_e10m4_pelican_arrives());
	sleep (60);
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	f_new_objective (e10m4_obj_05);
	sleep (30);
	sleep_until (e10m4_pelican_has_landed == TRUE, 1);
	thread (aud_e10m4_evac());
	sleep_until (volume_test_players (tv_e10m4_endvolume), 1);
	thread (aud_e10m4_stop_music());
	f_unblip_flag (fl_e10m4_endarea);
	fade_out (0, 0, 0, 15);
	e10m4_hide_players_outro();
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("MISSION DONE!");
	sleep (30 * 1);
	e10m4_over = TRUE;
	b_end_player_goal = true;
	sleep (90);
	b_game_won = TRUE;
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
	f_load_phantom (sq_e10m4_phantom_01, left, sq_e10m4_mixed02, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e10m4_phantom_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e10m4_1gho_01.driver ) );
	//vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e10m4_phantom_01.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e10m4_1gho_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 );
	sleep (30 * 1);
	ai_exit_limbo (sq_e10m4_phantom_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 );
	sleep (30 * 3);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e10m4_phantom01.p0, ps_e10m4_phantom01.p0);
	cs_fly_to_and_face (ps_e10m4_phantom01.p1, ps_e10m4_phantom01.p1);
	thread (vo_e10m4_global_miller_phantom_01());
	cs_fly_to_and_face (ps_e10m4_phantom01.p2, ps_e10m4_phantom01.p2);
	sleep (30 * 2);
	f_unload_phantom (sq_e10m4_phantom_01, left);
	sleep (30 * 5);
	f_load_phantom (sq_e10m4_phantom_01, right, sq_e10m4_2jak_01, none, none, none);
	cs_fly_to_and_face (ps_e10m4_phantom01.p6, ps_e10m4_phantom01.p6, 1);
	sleep (60);
	f_unload_phantom (sq_e10m4_phantom_01, right);
	sleep (150);
	cs_fly_to_and_face (ps_e10m4_phantom01.p7, ps_e10m4_phantom01.p7, 1);
	sleep (30);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e10m4_phantom_01.driver ), "phantom_lc" );
	//sleep (60);
	//vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e10m4_phantom_01.driver ), "phantom_sc" );
	sleep (30);
	cs_fly_to_and_face (ps_e10m4_phantom01.p3, ps_e10m4_phantom01.p3);
	cs_fly_to_and_face (ps_e10m4_phantom01.p4, ps_e10m4_phantom01.p4);
	cs_fly_to_and_face (ps_e10m4_phantom01.p5, ps_e10m4_phantom01.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 );
	sleep (30 * 6);
	ai_erase (ai_current_squad);
end


script command_script cs_e10m4_pelican01()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );
	object_cannot_take_damage (ai_vehicle_get_from_spawn_point ( sq_e10m4_pelican_01.driver ));
	sleep (30 * 1);
	ai_exit_limbo (sq_e10m4_pelican_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );
	sleep (30 * 4);
	print ("everything is ready for pelican. moving out now");
	thread (e10m4_pelicanlanding());
end

script static void e10m4_pelicanlanding()
	sleep_until	(ai_living_count (e10m4_ff_all) <= 0, 1);
	f_blip_object (ai_vehicle_get_from_spawn_point ( sq_e10m4_pelican_01.driver ), default);
	cs_fly_to_and_face (sq_e10m4_pelican_01, TRUE, ps_e10m4_pelican01.p1, ps_e10m4_pelican01.p1);
	cs_ignore_obstacles (sq_e10m4_pelican_01, TRUE);
	cs_fly_to_and_face (sq_e10m4_pelican_01, TRUE, ps_e10m4_pelican01.p0, ps_e10m4_pelican01.p0);
	ai_braindead (sq_e10m4_pelican_01, TRUE);
	e10m4_pelican_has_landed = TRUE;
	sleep (30);
end



///343///343///343///343///343///343///343///343	Forerunner Spawn Scripts	///343///343///343///343///343///343///343///343

script command_script cs_e10m4_knights_phasein
	print ("knight phase in");
	cs_phase_in();
end

script command_script cs_e10m4_pawn_spawn
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	print ("pawns phase in");
end

script command_script cs_e10m4_pawn_spawn_template
	print ("pawns phase in");
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e10m4_bishop_spawn
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 0); //Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	sleep(40);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50); //grow size over time
end


///343///343///343///343///343///343///343///343	AA Gun Spawn Scripts	///343///343///343///343///343///343///343///343

script command_script cs_e10_m4_turret()
	object_set_scale(ai_vehicle_get(ai_current_actor ), .20, 0);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
	repeat
		begin_random
	
		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p0);
		sleep_rand_s(1,3);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p0);
		sleep_rand_s(1,2);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p0);
		sleep_rand_s(1,4);
		end
	
		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p1);
		sleep_rand_s(1,2);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p1);
		sleep_rand_s(1,3);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p1);
		sleep_rand_s(1,4);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p1);
		sleep_rand_s(1,5);
		end
		
		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p2);
		sleep_rand_s(1,2);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p2);
		sleep_rand_s(1,3);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p2);
		sleep_rand_s(1,5);
		end
		
		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p3);
		sleep_rand_s(1,2);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p3);
		sleep_rand_s(1,3);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p3);
		sleep_rand_s(1,4);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p3);
		sleep_rand_s(1,5);
		end

		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p4);
		sleep_rand_s(1,2);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p4);
		sleep_rand_s(1,3);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p4);
		sleep_rand_s(2,4);
		end
		
		begin
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p5);
		sleep_rand_s(1,2);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p5);
		sleep_rand_s(1,3);
		cs_shoot_point(true, ps_e10m4_turretfiringpoints.p5);
		sleep_rand_s(1,3);
		cs_shoot_point(false, ps_e10m4_turretfiringpoints.p5);
		sleep_rand_s(1,2);
		end
		
		end
	until( e10m4_coresdead == 3);
end	

//==PUPPETEER SCRIPT

global object g_e10m4_ics_player = none;

script static void f_e10_m4_barrier_switch (object dev, unit player)
	print ("barrier switch puppeteer");
	g_e10m4_ics_player = player;
	
	local long show = pup_play_show(pup_e10m4_doorhologram);
	sleep_until (not pup_is_playing(show), 1);
	print ("1st person Anim played");
end

//==========	Random Camera Shake
script static void e10m4_random_rumble()
	repeat
	print ("sleeping random count till rumble");
	begin_random_count (1)

		sleep (120 * 30);
		sleep (180 * 30);
		sleep (60 * 30);
		sleep (60 * 30);
		sleep (90 * 30);
		sleep (150 * 30);
		sleep (150 * 30);
	end
	if e10m4_rumble == 0 then
		print ("rumble commencing");
		begin_random_count (1)
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.8, 2, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), -0.3, .75, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_low.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -0.2, .8, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' );
//	EXAMPLE:
//		f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.5, -1, -0.5, 'insert sound tag name here' )
//			This will start the screenshake sound tag sound and scale to medium intensity over 0.5s, sustain the medium indensity screenshake for the time of the sound file, and scale intensity back down in the last 0.5s of the sound
		end	
	elseif e10m4_rumble == 1 then
	print ("no rumble needed");
	end
	print ("rumble ended");
	
	until (e10m4_rumble == 1);
end



//=======	Power source trampstamp

//you will need to place 4 named power cores in your level and have them in all the designer zones needed
//environments\shared\crates\cov\cov_lich_power_source\cov_lich_power_source.crate
//this is the function you will call when you want your players to start having the core. I’m guessing at the beginning of your level

script static void f_e10_m4_core_attach_setup()
	if player_valid( player0() )then
		f_e10_m4_core_attach_loop( player0 );
	end
	                
	if player_valid( player1() ) then
		f_e10_m4_core_attach_loop( player1 );
	end
	                
	if player_valid( player2() ) then
		f_e10_m4_core_attach_loop( player2 );
	end                        
	
	if player_valid( player3() ) then
		f_e10_m4_core_attach_loop( player3 );
	end
end

//this function keeps a loop on the player, it waits until they are alive to attach the core and repeats when they die
//it will stop doing the loop after you set a boolean. For me it was at the end of my level:  b_e10_m3_win

script static void f_e10_m4_core_attach_loop(player p_player)
	repeat
		sleep_until( object_get_health( p_player ) > 0 , 1 );
		//dprint("player is alive attach core");
		thread( f_e10_m4_core_attach_to_player(p_player) );
		sleep_until( object_get_health( p_player ) <= 0 , 1 );
		//dprint("player is dead");
		sleep(15);
	until( e10m4_over == TRUE , 1 );
end

//this function will create the actually object and attach it to the player

script static void f_e10_m4_core_attach_to_player(player p_player)
	//dprint("attach bomb");
	if player_valid( p_player )then
		if p_player == player0 then
			object_create_anew( e10m4_powersource01 );
			sleep(1);
			objects_attach (p_player, "package", e10m4_powersource01, "m_attach_player" );
		end

		if p_player == player1  then
			object_create_anew( e10m4_powersource02 );
			sleep(1);
			objects_attach ( p_player, "package", e10m4_powersource02, "m_attach_player" );
		end

		if p_player == player2  then
			object_create_anew( e10m4_powersource03 );
			sleep(1);
			objects_attach (p_player, "package", e10m4_powersource03, "m_attach_player" );
		end                        

		if p_player == player3  then
			object_create_anew( e10m4_powersource04 );
			sleep(1);
			objects_attach ( p_player, "package", e10m4_powersource04, "m_attach_player" );
		end
	end
	sleep(1);
end
