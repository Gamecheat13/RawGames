//============================================ VALHALLA FIREFIGHT SCRIPT E3 M3========================================================
//=============================================================================================================================

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== LEVEL SCRIPT ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_end = lz_end;
//global cutscene_title title_pelican_crash = pelican_crash;
//global cutscene_title title_aa_guns_disabled = aa_guns_disabled;
//global cutscene_title title_disable_aa_1 = disable_aa_guns;
//global cutscene_title title_use_vehicles = use_vehicles;
//global ai ai_ff_allies_1 = gr_ff_allies_1;
//global ai ai_ff_allies_2 = gr_ff_allies_2;
//global ai ai_ff_all = gr_ff_all;

global short e10m5_rumble = 0;
global short artifact_break = 0;
global boolean e10_m5_breach_outro = false;

script startup vortex_e10_m5()
	print ("testing startup");
	sleep_until (LevelEventStatus("e10_m5"), 1);
	print ("well this worked");
	dprint( "vortex_e10_m5: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	// THFRENCH - Moved your intilization into it's own function and hooked this stuff into here
	//Wait for start
	if ( f_spops_mission_startup_wait("e10_m5") ) then
		wake( vortex_e10_m5_init );
	end

end


	

script dormant vortex_e10_m5_init()
	// THFRENCH - Basically inserted the new mission flow stuff into your stuff and removed unnecessary scripting that is automatically handled by the mission flow

	//firefight_mode_set_player_spawn_suppressed(true);
	print ("************************************************STARTING E10 M5*********************");

//	fade_out (0,0,0,1);
//	thread (e10_m5_iron_players());
	print ("Player living count");

	// set standard mission init
	f_spops_mission_setup( "e10_m5", e10_m5, e10_m5_ff_all, e10m5_spawn_points_0, 90 );
	

	
	//switch_zone_set (e6_m4);		// THFRENCH - Hangled by f_spops_mission_setup
//	mission_is_e6_m4 = true;		// THFRENCH - Hangled by f_spops_mission_setup
//	b_wait_for_narrative = true;
	//ai_ff_all = e6m4_all_foes;		// THFRENCH - Hangled by f_spops_mission_setup
//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(dm_e10m5_scarab);										//UNSC crates and barriers around the dias
	f_add_crate_folder(dc_e10m5_scarab);										//UNSC crates and barriers around the dias
	f_add_crate_folder(e10m5_cov_encounter_1);	
	
//set spawn folder names
//	firefight_mode_set_crate_folder_at(e9m1_spawn_start, 90); //SA Spawn location: back of temple, split up 2 per side near doors

//f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy")
	// set objective names
//	firefight_mode_set_objective_name_at(c_e6m4_core_1, 80);
//	firefight_mode_set_objective_name_at(e9m1_lz_hilltop, 81);
//	firefight_mode_set_objective_name_at(dc_e6m4_scan, 82);
//	firefight_mode_set_objective_name_at(e9m1_lz_east_door, 83);
//	firefight_mode_set_objective_name_at(c_e6m4_core_2, 84);
//	firefight_mode_set_objective_name_at(c_e6m4_core_3, 85);
//	firefight_mode_set_objective_name_at(dc_e6m4_door_switch, 86);
	
	// set e9m1_lz spots
	firefight_mode_set_objective_name_at(e10m5_obj1, 	50); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(scarab_control, 	51); //SA objective location: front pad of temple
	firefight_mode_set_objective_name_at(e10m5_obj3, 	52); //SA objective location: near middle of temple
	firefight_mode_set_objective_name_at(e10m5_obj4, 	53); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(e10m5_obj5, 	54); //SA objective location: on lower platform by ramp to upper level, leading to back of canyon
	firefight_mode_set_objective_name_at(door_control_button, 	55); //SA objective location: entrance to canyon from valley
	firefight_mode_set_objective_name_at(fore_artifact, 	56); //SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(e10m5_obj8, 	57); //SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(scarab_fire, 	58); //SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(e10m5_obj2, 	59); //SA objective location: front of cayon into valley
////== set squad group names
	firefight_mode_set_squad_at(e10_m5_cov_attack_1, 				1);	//BR: First Covenant encounter on the way to excavator.
//	firefight_mode_set_squad_at(e9m1_phantom_01, 20);
//	firefight_mode_set_squad_at(e9m1_phantom_01, 2);
//		
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_3, 93);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_4, 94);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_5, 95);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_6, 96);
	firefight_mode_set_crate_folder_at(e10m5_spawn_points_7, 97);
// THFRENCH - This will now allow everything to start spawning
	f_spops_mission_setup_complete( TRUE );	
	//firefight_mode_set_player_spawn_suppressed(false);	// THFRENCH - Not needed, now managed by above
	
	thread (f_start_events_e10_m5());

end


	
//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================


	
// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================

script static void e10m5_random_rumble
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
		sleep (30 * 30);
		sleep (15 * 30);
	end
	fx_dust_ambient();
	if e10m5_rumble == 0 then
		print ("rumble commencing");
		begin_random_count (1)
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.8, 2, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), -0.3, .75, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_low.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -0.2, .8, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -0.3, 1, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -1, 1, -1, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
//	EXAMPLE:
//		f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.5, -1, -0.5, 'insert sound tag name here' )
//			This will start the screenshake sound tag sound and scale to medium intensity over 0.5s, sustain the medium indensity screenshake for the time of the sound file, and scale intensity back down in the last 0.5s of the sound
		end	
	elseif e10m5_rumble == 1 then
	print ("no rumble needed");
	end
	print ("rumble ended");
	
	until (e10m5_rumble == 1);
end

script static void e10m5_final_rumble
	repeat
	print ("sleeping random count till rumble");
	begin_random_count (1)

		
		
		sleep (15 * 30);
		sleep (5 * 30);
		sleep (45 * 30);
		sleep (30 * 30);
	end
	if e10m5_rumble == 1 then
		print ("rumble commencing");
		begin_random_count (1)
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -0.2, .6, -6, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -0.3, 1.5, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
				f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -2, 1, -2.5, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' );
		end	
	elseif e10m5_rumble == 2 then
	print ("no rumble needed");
	end
	print ("rumble ended");
	
	until (e10m5_rumble == 2);
end
//
//script static void t2
//	object_destroy (test_pod);
//
//end
// ==============================================================================================================
// ====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================



//// ==============================================================================================================
//// ====== PELICAN COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

script command_script cs_ff_e10_m5_pelican01
//	cs_ignore_obstacles (TRUE);
	ai_cannot_die (ai_current_squad, TRUE);
	sleep (1);
	cs_fly_to (pelican_01.p0);
	cs_fly_by (pelican_01.p1); 
	cs_fly_by (pelican_01.p2); 
	cs_fly_by (pelican_01.p3);
	cs_vehicle_speed (.5);
	cs_fly_to_and_face (pelican_01.p4, pelican_01.p5);
	cs_vehicle_speed_instantaneous(0);
	thread (pelican_door_anim());

end

//// ==============================================================================================================
//// ====== AI COMMAND SCRIPTS ===============================================================================
//// ==============================================================================================================

script command_script cs_ff_e10m5_hunter_1()
	cs_crouch (true);
	repeat
	if volume_test_players (trigger_volumes_1) then
	cs_shoot_point (true, hunter_shoot.p0);
	sleep (20);
	cs_crouch (false);
	end
	until (volume_test_players (trigger_volumes_1));
	ai_set_objective (e10m5_hunter_right, e10m5_cov_2);
end

script command_script cs_ff_e10m5_hunter_2()
	cs_crouch (true);
	repeat
	if volume_test_players (trigger_volumes_1) then
	cs_shoot_point (true, hunter_shoot.p1);
	sleep (20);
	cs_crouch (false);
	end
	until (volume_test_players (trigger_volumes_1));
	ai_set_objective (e10m5_hunter_left, e10m5_cov_2);
end

//script command_script forerunner_squads_0
//	
//	cs_phase_in_blocking();
//end

script command_script forerunner_squads_0 
	print ("knight phase in"); 
	// print_cs(); 
	sleep_rand_s (0.1, 0.6); 
	cs_phase_in();
	ai_exit_limbo(ai_current_actor); 
end

script command_script final_elite_cammo
	print ("elites are invisible");
	ai_set_active_camo (ai_current_actor, true);
	ai_exit_limbo(ai_current_actor);
	ai_braindead (ai_current_actor, true);
	sleep_until (volume_test_players (trigger_volumes_11), 1);
	ai_braindead (ai_current_actor, false);
	sleep_rand_s (.3, 1);
	ai_set_active_camo (ai_current_actor, false);
end


script command_script cs_pawn_spawn_e10m5
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================



// ==============================================================================================================
// ====== E10_M5_BREACH==============================================================================
// ==============================================================================================================

global boolean b_wait_for_narrative = false;
global boolean e10m5_narrative_is_on = FALSE;

//script static void f_start_player_intro
//	print ("start player intro");
//	firefight_mode_set_player_spawn_suppressed(false);
////	f_e3_m3_start();
////	print ("guards_1 spawn");
//end

script static void f_start_player_intro_e10_m5
	sleep_until (f_spops_mission_ready_complete(), 1);
	if editor_mode() then
		sleep_s (1);
//		intro_vignette_e10_m5();
//		b_wait_for_narrative = false;
//		firefight_mode_set_player_spawn_suppressed(false);
	else
		
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1);
	thread (f_e10_m5_music_start());
	intro_vignette_e10_m5();
		
	end
	f_spops_mission_intro_complete( TRUE );
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e10_m5
	print ("_____________starting vignette__________________");
	pup_disable_splitscreen (true);
	local long show = pup_play_show(e10_m5_intro);
	vo_e10m5_narr_in();
	sleep_until (not pup_is_playing(show), 1);
	pup_disable_splitscreen (false);
//	print ("_____________done with vignette---SPAWNING__________________");
//	firefight_mode_set_player_spawn_suppressed(false);


end

//script static void f_narrative_done
//	print ("narrative done");
//	b_wait_for_narrative = false;
//	print ("huh");
//end

script static void f_start_events_e10_m5
	print ("***********************************STARTING start_e10_m5*************");

	sleep(30);
	
	object_create_anew(dm_maw);
	device_set_position_immediate(dm_maw, 1);


	thread(f_start_player_intro_e10_m5());
	

	
	thread (e10_m5_master_story());
	print ("Hello. Here is our story.");
	
	thread (e10_m5_covenant_spawn());
	print ("digger exterior and interior spawns");
	
	thread (e10_m5_all_cov_dead());
	print ("hide button till all dead");
	
	thread (firethedigger());
	print ("fire the digger");
	
	thread (first_cave_fx());
	print ("first cave fx");
	
	thread (e10_m5_zone_switch());
	print ("prepped for switching zone sets");
	
	thread (e10_m5_promethean_01());
	print ("uh oh, you woke up prometheans");
	
	thread (e10_m5_all_prom_dead());
	print ("uh oh, you killed the prometheans");
	
	thread (e10_m5_powerupdoor());
	print ("need to open the door");
	
	thread (e10_m5_doorisopen());
	print ("door is open, now kick open the artifact");
	
	thread (e10_m5_gettotheplane());
	print ("spartans, leave");
	
//	ai_place(sq_e6m4_mouth);
	print ("sleeping till mission start complete");
	sleep_until( f_spops_mission_start_complete(), 1 );
	print ("adding falling debris");
	thread (fx_skyfall_all_on());
	print ("fading in");
	fade_in (0,0,0,30);
	print ("did i fade in");
//		thread(e6m4_());
//		kill_volume_disable(kill_);
end



script static void e10_m5_master_story
	sleep_until (b_players_are_alive(), 1);
	b_end_player_goal = TRUE;
	thread (f_e10_m5_event0_start());
	sleep_s (1);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.2, 2, -2.2, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
	fx_dust_mission_start();
	thread (first_encounter_fx());
	thread (e10m5_random_rumble());
	vo_e10m5_head_to_excavator();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	print ("Get to the Digger");
	f_new_objective (e10_m5_objective_2);
	thread (f_e10_m5_event0_stop());
	thread (f_e10_m5_event1_start());
	sleep_until (ai_living_count (e10_m5_ff_all) <= 17, 1);
	
	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
	thread (f_e10_m5_event3_start());
//	f_digger_hole_damage();
//	vo_e10m5_excavator_fires();
//	f_new_objective (e10_m5_objective_5_1);
//	thread (f_e10_m5_event3_stop());
end

script static void first_encounter_fx
	sleep_until (volume_test_players (trigger_volumes_15), 1);
	print ("playing first encounter fx");
	fx_dust_path_from_start();
end


script static void first_cave_fx
	sleep_until (volume_test_players (trigger_volumes_16), 1);
	print ("playing first encounter fx");
	fx_dust_cave_front();
end

//script static void first_encounter_fx_test (trigger_volume tv_volume, string effect)
//	sleep_until (volume_test_players (tv_volume), 1);
//	print ("playing first encounter fx");
//	notifylevel ("effect");
//end

script static void e10_m5_covenant_spawn
	sleep_until (ai_living_count (e10_m5_ff_all) >= 13, 1);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 13, 1);
	ai_place (e10m5_cov_05);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 9, 1);
	ai_place (e10m5_hunter_left);
	ai_place (e10m5_hunter_right);
	ai_place (e10m5_elites_digger);
	ai_place (gr_e10m5_digger_extra_1);
	ai_place (gr_e10m5_digger_extra_2);
end

script static void e10_m5_all_cov_dead
	sleep_until (LevelEventStatus ("alldead"), 1);
	b_wait_for_narrative_hud = true;
	sleep_s (1);
	vo_e10m5_tickingclock();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);	

	object_create (e10m5_obj2);
	navpoint_track_object_named(e10m5_obj2, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_2), 1); 
	object_destroy (e10m5_obj2);
	vo_e10m5_get_in_excavator();
	f_add_crate_folder (e10m5_spawn_points_2);
	sleep_s (1);
	object_destroy_folder  (e10m5_spawn_points_1);
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 1, 1);
	vo_glo15_miller_one_more_04();
	f_blip_ai_cui (e10_m5_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	thread (f_e10_m5_event1_stop());
	sleep_s (3);
	thread (f_e10_m5_event2_start());
	f_new_objective (e10_m5_objective_1);
	vo_glo15_miller_attaboy_02();
	vo_glo15_miller_allclear_01();
	vo_e10m5_power_up();
	b_wait_for_narrative_hud = false;
	device_set_power (scarab_control, 1);
	sleep_until (device_get_position (scarab_control) != 0);
	sleep_s (3);
//	print ("play comms switch puppetshow");
//	local long nuke = pup_play_show (e10_m5_nuke_in_digger);
//	sleep_until (not pup_is_playing(nuke), 1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_excavator_open_mnde1065', scarab_fire_door, 1 ); //AUDIO!
	device_set_position (scarab_fire_door, 1);
	thread (f_e10_m5_event2_stop());
	vo_e10m5_room_opens();
	object_create_anew (e10m5_obj2);
	vo_e10m5_enter_room();
	f_new_objective (e10_m5_objective_4);
	sleep_until (device_get_position (scarab_fire) != 0);
	sleep_s (3);
	print ("play comms switch puppetshow");
//	local long show = pup_play_show (e10_m5_scarab_fire);
//	sleep_until (not pup_is_playing(show), 1);
	device_set_position (scarab_fire_switch, 1);
end

global long g_scarab_fire_show = 0;

script static void f_push_fore_switch (object control, unit player)
//script static void f_push_fore_switch (unit player)
print ("pushing the forerunner switch");

	g_ics_player = player;
// g_ics_player = player0;
	if control == scarab_control then
	print ("play left portal switch puppetshow");
	pup_play_show (e10_m5_nuke_in_digger);
// elseif dev == power_switch_temp then
// pup_play_show (e1_m5_push_power_button);

	elseif control == scarab_fire then
	print ("play button 2 puppetshow");
	g_scarab_fire_show = pup_play_show (e10_m5_scarab_fire);
	
	elseif control == fore_artifact then
	print ("play button 3 puppetshow");
	pup_play_show (e10_m5_artifact_button);
	end
end

script static void firethedigger
	sleep_until (LevelEventStatus ("hidebeforefire"), 1);
	b_wait_for_narrative_hud = true;
	sleep_until (LevelEventStatus ("thedoorishere"), 1);
	b_wait_for_narrative_hud = false;
end

script static void f_digger_rumble
	f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -1, -5, -8, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' );
end

script static void f_digger_hole_damage
	print ("prepare damage");
	damage_object (hole_1, default, 1000);
	
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_2);
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_1);
	effect_new (objects\weapons\support_high\storm_spartan_laser\projectiles\damage_effects\storm_spartan_laser_beam_impact.damage_effect, cutscene_flags_0);
	print ("damage unleashed");
end

script static void e10_m5_zone_switch
	sleep_until (LevelEventStatus ("ohnoprometheans"), 1);
	sleep_s(1);
	sleep_until (not pup_is_playing(g_scarab_fire_show), 1);
	print ("harvester beam");
	hud_show_navpoints (false);

//	cinematic_start();
	local long beam = pup_play_show (e10_m5_diggerbeam);
	sleep_until (not pup_is_playing(beam), 1);
	hud_show_navpoints (true);
//	cinematic_stop();
	prepare_to_switch_to_zone_set(e10_m5_interior);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e10_m5_interior);
	current_zone_set_fully_active();
	print ("switched zone sets");
	f_new_objective (e10_m5_objective_5_1);
	sleep_s (1);
	object_destroy (cr_tunnel_blast);
	print ("tunnel open");
	object_create_folder_anew (dm_e10_m5_interior_devices);
	pup_play_show (e10_m5_artifact);
	f_add_crate_folder (e10m5_spawn_points_3);
	sleep_s (1);
	object_destroy_folder (e10m5_spawn_points_2);
	sleep_until (volume_test_players (trigger_volumes_2), 1);
	vo_e10m5_head_into_cave();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);	
//	object_create_anew (door_control_button);
//	device_set_position (door_activation, 0);
//	device_set_position (door_control_button, 0);

end

script static void e10_m5_promethean_01
	sleep_until (volume_test_players (trigger_volumes_3), 1);
	ai_place_in_limbo (gr_knight_guard01);
	thread (f_e10_m5_event4_start());
	sleep_until (volume_test_players (trigger_volumes_4), 1);
	ai_place (crawler_guard02);
	effects_perf_armageddon = 0;
	sleep_until (ai_living_count (crawler_guard02) <= 3, 1);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -3, 2, -3, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
	thread (fx_dust_cave_mid());
	print ("did you place early?");
	ai_place (crawler_guard02);
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), -1, 1, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_low.sound' ));
	thread (fx_dust_cave_back());
	ai_place_in_limbo (knight_guard02_front_knights);
	ai_place_in_limbo (knight_guard02_back_knight);
	ai_place (knight_guard02_pawns);
	effects_perf_armageddon = 1;
	ai_place (knight_guard02_pawn_sniper);
	f_add_crate_folder (e10m5_spawn_points_4);
	sleep_s (1);
	object_destroy_folder (e10m5_spawn_points_3);
	ai_place_with_birth (knight_guard02_bishop_1);
	ai_place_with_birth (knight_guard02_bishop_2);
	vo_e10m5_fr_int();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	vo_e10m5_clear_area();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	sleep_until (ai_living_count (knight_guard02_pawns) <= 2, 1);
	ai_place (knight_guard02_pawns_2);
		sleep_until (ai_living_count (knight_guard02_front_knights) <= 0, 1);
	ai_place (gr_knight_guard_mid_reinf_base);
end

script static void e10_m5_all_prom_dead
	sleep_until (LevelEventStatus ("allpromdead"), 1);
	sleep_until (ai_living_count (knight_guard02_pawns) <= 0, 1);
	f_new_objective (e10_m5_objective_5);
	
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	thread (f_e10_m5_event4_stop());
	f_add_crate_folder (e10m5_spawn_points_5);
	sleep_s (1);
	object_destroy_folder (e10m5_spawn_points_4);
	sleep_s (1);
	sleep_s (1);
	vo_e10m5_find_artifact();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);	
	object_create (e10m5_obj5);
	f_new_objective (e10_m5_objective_6);
	navpoint_track_object_named(e10m5_obj5, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_6), 1); 
	object_destroy (e10m5_obj5);


	b_end_player_goal = TRUE;
	b_wait_for_narrative_hud = true;
end

script static void e10_m5_powerupdoor
	sleep_until (LevelEventStatus ("openthedoorboss"), 1);
	vo_e10m5_not_opening();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	sleep_s (2);
	vo_e10m5_power_source();
	f_new_objective(e10_m5_objective_7);
	object_create (e10m5_obj6);
	navpoint_track_object_named(e10m5_obj6, "navpoint_goto");
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	sleep_until (volume_test_players (trigger_volumes_7), 1);
	thread (f_e10_m5_event5_start());
	object_destroy (e10m5_obj6);
	device_set_power (e10m5_lower_door, 1);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_artifactroomdoor_mnde1063', e10m5_lower_door, audio_center, 1 ); //AUDIO!
	device_set_position (e10m5_lower_door, 1);
	object_create (e10m5_obj6_1);
	navpoint_track_object_named(e10m5_obj6_1, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_8), 1); 
	object_destroy (e10m5_obj6_1);
	ai_place_in_limbo (knight_guard_3);
	ai_place_with_birth (knight_guard_3_bishop);
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	b_end_player_goal = TRUE;
	sleep_s (2);
	b_wait_for_narrative_hud = false;
	device_set_power (door_control_button, 1);
	sleep_until (device_get_position (door_control_button) == 1, 1);
	device_set_position (e10m5_lower_generator, 1);
	device_set_position (e10m5_lower_generator, 1);
	thread (f_e10_m5_event5_stop());
end

script static void e10_m5_doorisopen
	sleep_until (LevelEventStatus ("doorisopenboss"), 1);
	sleep_s (4);
	vo_e10m5_powered_up();
	
	if not object_valid( artifact_circle_sfx ) then //CREATE SOUND SCENERY OBJECT FOR ARTIFACT RINGS!
		object_create( artifact_circle_sfx );
	end
	
	effect_new (levels\dlc\ff155_breach\fx\lensflares\bre_forerun_door_flare.effect, cutscene_flags_5);
	object_create (e10m5_obj7);
	navpoint_track_object_named(e10m5_obj7, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_6), 1);
	sleep_s (1);
	object_destroy (e10m5_obj7);
	device_set_power (e10m5_lower_door2, 1);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_generatordoor_open_mnde1064', e10m5_lower_door2, audio_center, 1 ); //AUDIO!
	device_set_position (e10m5_lower_door2, 1);
	effect_kill_from_flag (levels\dlc\ff155_breach\fx\lensflares\bre_forerun_door_flare.effect, cutscene_flags_5);
	thread (f_e10_m5_event6_start());
	vo_e10m5_open_artifact_door();
	sleep_s (2);
	thread (e10_m5_player_teleport());
	sleep_until (volume_test_players (trigger_volumes_10), 1);
	f_add_crate_folder (e10m5_spawn_points_6);
	sleep (2);
	object_destroy_folder  (e10m5_spawn_points_5);
	vo_e10m5_quiet();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	vo_e10m5_control();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	vo_e10m5_there_it_is();
	sleep(1);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	thread (vo_e10m5_kickass());
	f_new_objective(e10_m5_objective_8);
	b_end_player_goal = TRUE;
	device_set_power (fore_artifact, 1);

end

script static void e10_m5_player_teleport
	sleep_until (volume_test_players (trigger_volumes_10), 1);
	sleep_s (2);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_generatordoor_close_mnde1064', e10m5_lower_door2, audio_center, 1 ); //AUDIO!
	device_set_position (e10m5_lower_door2, 0);
	sleep_s (2);
	print ("teleporting stragglers");
	volume_teleport_players_not_inside (trigger_volumes_10, cutscene_flags_3);
end


script static void e10_m5_gettotheplane
	sleep_until (LevelEventStatus ("gettheheckoutofdodge"), 1);
	sleep_s (1);
	device_set_power (e10m5_zen_switch_panel, 1);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_activate', e10m5_zen_switch_panel, 1 ); //CONTROL PANEL AUDIO!
	device_set_position (e10m5_zen_switch_panel, 1);
	sleep_s (2);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', e10m5_zen_switch_panel, 1 ); //DEREZ AUDIO!
	object_dissolve_from_marker(e10m5_zen_switch_panel, phase_out, panel);
	device_set_position (e10m5_zen_switch, 1);
	thread (f_e10_m5_event6_stop());
	e10m5_rumble = 1;
	thread (f_e10_m5_event7_stop());
	sleep_s (2);
	object_destroy (e10m5_zen_switch_panel);
	device_set_position (e10m5_zen_artifact, 1);
	notifylevel ("artifactoffline");
	sleep_s (4);
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	thread (	vo_e10m5_success());
	thread ( e10_m5_artifact_destroy_sfx() );
	sleep_s (3);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -3, -5, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' ));
	sleep_s (4);
	artifact_break = 1;

	sleep_s (1.5);
	object_destroy ( artifact_circle_sfx ); //KILL AUDIO!
	thread (vo_e10m5_ceiling());
	sleep(1);
//	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -6, -5, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' ));
	sleep(1);
	thread (getyourasstomars());
	thread (e10_m5_final_zone_switch());
	thread (e10m5_final_rumble());
	sleep_until(e10m5_narrative_is_on == FALSE, 1);
	f_new_objective(e10_m5_objective_9);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_generatordoor_open_mnde1064', e10m5_lower_door2, audio_center, 1 ); //AUDIO!
	device_set_position (e10m5_lower_door2, 1);
	object_create (e10m5_obj7);
	navpoint_track_object_named(e10m5_obj7, "navpoint_goto");
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -1, -6, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
	sleep_until (volume_test_players (trigger_volumes_6), 1);

	object_destroy (e10m5_obj7);
	object_create (e10m5_obj4);
	navpoint_track_object_named(e10m5_obj4, "navpoint_goto");
	sleep_until (volume_test_players (trigger_volumes_23), 1);
	object_destroy (e10m5_obj4);

	sleep_until (volume_test_players (trigger_volumes_11), 1);
	thread (f_e10_m5_event7_stop());
	thread (e10_m5_final_fx_shake());
//	device_set_position (e10m5_falling_rock, 1);
	object_destroy (e10m5_obj3);
	f_add_crate_folder (e10m5_spawn_points_8);
	sleep_s (1);
	object_destroy_folder  (e10m5_spawn_points_7);
//	ai_place_in_limbo (e10m5_final_elites);
	thread (vo_e10m5_zealots());
	thread (f_e10_m5_event8_start());
	thread (	f_new_objective(e10_m5_objective_8_1));
	sleep_until (ai_living_count (e10_m5_ff_all) <= 0, 1);
	sleep_s (1);
	thread (f_e10_m5_event8_stop());
	prepare_to_switch_to_zone_set(e10_m5_outro);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e10_m5_outro);
	current_zone_set_fully_active();
	print ("switched zone sets");
	thread (f_e10_m5_event9_start());
	f_new_objective(e10_m5_objective_9);
	vo_e10m5_get_out();

end

script static void e10_m5_artifact_destroy_sfx
	sleep_s (3);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_artifact_destruction_mnde851', e10m5_zen_rings, audio_center, 1 ); //AUDIO!
	sleep_s (4);
	object_destroy ( artifact_circle_sfx ); //KILL AUDIO!
end
	

script static void e10_m5_final_fx_shake
	sleep_until (volume_test_players (trigger_volumes_16), 1);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -1, -2, -3, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' ));	
	fx_dust_cave_exit();
end

script static void e10_m5_final_zone_switch
	prepare_to_switch_to_zone_set(e10_m5_before_outro);
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e10_m5_before_outro);
	current_zone_set_fully_active();
	print ("switched zone sets");
	sleep_s (1);
	object_destroy (fore_artifact);
	object_destroy (cr_tunnel_blast);
	print ("tunnel open");
end


global long e10_m5_out_show = 0;

script static void spawn_e10m5_outro_pelican

	e10_m5_out_show = pup_play_show(e10_m5_outro);
	object_cannot_take_damage (v_pelican);
end

//script static void e10_m5_iron_players
//	sleep_until (LevelEventStatus ("soyouwantachallenge"), 1);
//	print ("iron mode activated");
//	sleep (1);
//	sleep_until (b_players_are_alive(), 1);
//	sleep (1);
//	repeat
//	sleep_until (spops_player_living_cnt() == 0, 1);
//	if (game_coop_player_count() >= 2) then 
//		print ("all players are dead");
//		firefight_mode_set_player_spawn_suppressed(true);
//		sleep_s (4);
//		fade_out  (0, 0, 0, 30);
//		print ("mission failed");
//		cui_load_screen (ui\in_game\pve_outro\mission_failed.cui_screen);
//		sleep_s (1);
//		b_game_lost = true;
//		sleep (1);
//	elseif (game_coop_player_count() <= 1) then
//		print ("good luck solo player");
//	end
//	until (b_game_won == true or b_game_lost == true, 1);
//end

script static void glow_test
	interpolator_start (glow);
end

script static void e10_m5_ending
	sleep_until (volume_test_players (trigger_volumes_9), 1);
	fade_out  (0, 0, 0, 5);
	f_unblip_object (v_pelican);
	sleep (6);
	e10_m5_breach_outro = true;
	thread (f_e10_m5_event9_stop());
	e10m5_rumble = 2;
	cinematic_start();
	sleep_until (b_players_are_alive(), 1);
	thread (e10m5_immortal_players());
	thread (e10m5_hide_players_outro());
//	ai_erase (squads_13);
//	e10m5_hide_players_outro();
//	pup_disable_splitscreen (true);
//	local long show = pup_play_show(e10_m5_outro);
	thread (f_e10_m5_event10_start());
	vo_e10m5_dust_off();
	sleep_until (not pup_is_playing(e10_m5_out_show), 1);
	pup_disable_splitscreen (false);
	cinematic_stop();
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//  sleep (90);
	b_end_player_goal = TRUE;
	thread (f_e10_m5_event10_stop());
	player_camera_control (false);
	player_enable_input (FALSE);
end

script static void e10m5_immortal_players()
	object_cannot_take_damage(player0);
	object_cannot_take_damage(player1);
	object_cannot_take_damage(player2);
	object_cannot_take_damage(player3);
	print ("all players now immortal!");
end

script static void pelican_door_anim()
	custom_animation_hold_last_frame (ai_vehicle_get_from_spawn_point (squads_13.spawn_points_0), "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", false);
//	sleep_until (volume_test_players (tv_rally_tele_temp), 1);
	sleep (30 * 1);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", player0);
	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (squads_13.spawn_points_0)), 1);
	print (":  : Teleporting into seat :  :");
	sleep (30 * 5);
	unit_stop_custom_animation (ai_vehicle_get_from_spawn_point (squads_13.spawn_points_0));
end

script static void e10m5_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show_navpoints (false);
//	object_hide (player0, true);
//	object_hide (player1, true);
//	object_hide (player2, true);
//	object_hide (player3, true);
	f_players_in_seat_2();
end



script static void e10m5_hide_mid_players
	print ("teleporting stragglers");
	volume_teleport_players_not_inside (trigger_volumes_17, cutscene_flags_4);
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	object_hide (player0, true);
	object_hide (player1, true);
	object_hide (player2, true);
	object_hide (player3, true);
end

script static void e10m5_show_mid_players
	print ("show the players");
	//	player_enable_input (false);
	player_control_fade_in_all_input (.1);
	hud_show (true);
	object_hide (player0, false);
	object_hide (player1, false);
	object_hide (player2, false);
	object_hide (player3, false);
	
end

script static void getyourasstomars()
	sleep_until (volume_test_players (trigger_volumes_12), 1);
	print ("float and slam");
	physics_set_gravity (.01);
	print ("pulse players");
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_gravity_flux_mnde8281', NONE, 1 ); //GRAVITY FLUX AUDIO!
	object_set_velocity (player0, -1, 0, 10);
	object_set_velocity (player1, -1, 0, 10);
	object_set_velocity (player2, -1, 0, 10);
	object_set_velocity (player3, -1, 0, 10);
	player_disable_movement (true);
	thread (vo_e10m5_gravity());
	sleep (60);
	print ("slamming and can't die");
	object_cannot_die (player0, true);
	object_cannot_die (player1, true);
	object_cannot_die (player2, true);
	object_cannot_die (player3, true);
	physics_set_gravity (12);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -1, -2, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
//	object_set_velocity (player0, 0, 0, -15);
	sleep (30);
	player_disable_movement (false);
	sleep (10);
	physics_set_gravity (1);
//	physics_set_gravity (10);	
//	sleep (10);
//	physics_set_gravity (6);	
//	sleep (30);
//	physics_set_gravity (.1);
//	object_set_velocity (player0, -1, 0, 12);
//	sleep (30);
//	physics_set_gravity (6);
//	sleep (30);
//	print ("normal gravity");
//	physics_set_gravity (1);
//	print ("can die");
	object_cannot_die (player0, false);
	object_cannot_die (player1, false);
	object_cannot_die (player2, false);
	object_cannot_die (player3, false);
//	sleep_until (volume_test_players (trigger_volumes_5), 1);
	sleep_until (volume_test_players (trigger_volumes_14), 1);
	print ("float and slam");
	physics_set_gravity (.25);
	print ("pulse players");
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_gravity_flux_mnde8281', NONE, 1 ); //GRAVITY FLUX AUDIO!
	object_set_velocity (player0, -1, -8, 3);
	object_set_velocity (player1, -1, -8, 3);
	object_set_velocity (player2, -1, -8, 3);
	object_set_velocity (player3, -1, -8, 3);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -1, -2, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
	sleep (20);
	print ("slamming and can't die");
	object_cannot_die (player0, true);
	object_cannot_die (player1, true);
	object_cannot_die (player2, true);
	object_cannot_die (player3, true);
	physics_set_gravity (12);
//	object_set_velocity (player0, 0, 0, -15);
	sleep (30);
	physics_set_gravity (.25);
	sleep_S (4);
	physics_set_gravity (1);
	sleep_until (volume_test_players (trigger_volumes_4), 1);
	ai_place_in_limbo (e10m5_final_elites);
	ai_place (e10m5_final_elites_rangers);
	ai_place (e10m5_final_elites_retreat);	
	print ("float and slam");
	physics_set_gravity (.10);
	print ("pulse players");
	
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_gravity_flux_mnde8281', NONE, 1 ); //GRAVITY FLUX AUDIO!
	object_set_velocity (player0, -1, 5, 5);
	object_set_velocity (player1, -1, 5, 5);
	object_set_velocity (player2, -1, 5, 5);
	object_set_velocity (player3, -1, 5, 5);
	sleep (60);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e10m5_gravity_flux_mnde8281', NONE, 1 ); //GRAVITY FLUX AUDIO!
	object_set_velocity (player0, -1, -5, 2);
	object_set_velocity (player1, -1, -5, 2);
	object_set_velocity (player2, -1, -5, 2);
	object_set_velocity (player3, -1, -5, 2);
	print ("slamming and can't die");
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -1, -2, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));

	sleep (40);
	physics_set_gravity (.25);
	sleep_S (4);
	physics_set_gravity (1);
	object_cannot_die (player0, false);
	object_cannot_die (player1, false);
	object_cannot_die (player2, false);
	object_cannot_die (player3, false);
end

script static void f_generator_breach_on
	interpolator_start (cavepowerswitch);
end



script static void f_players_in_pelican
	vehicle_set_player_interaction (v_pelican, pelican_d, 0, 0);
	vehicle_set_player_interaction (v_pelican, pelican_p_l05, 1, 0);
	vehicle_set_player_interaction (v_pelican, pelican_p_l04, 1, 0);
	vehicle_set_player_interaction (v_pelican, pelican_p_r05, 1, 0);
	vehicle_set_player_interaction (v_pelican, pelican_p_r04, 1, 0);	
end

script static void f_players_in_seat
	unit_enter_vehicle_immediate (v_pelican, player0, "pelican_p_l01");
end

script static void f_players_in_seat_2
	vehicle_load_magic (v_pelican, "pelican_p_l05", player0);
	vehicle_load_magic (v_pelican, "pelican_p_l04", player1);
	vehicle_load_magic (v_pelican, "pelican_p_r05", player2);
	vehicle_load_magic (v_pelican, "pelican_p_r04", player3);
end
