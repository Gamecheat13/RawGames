//fx_portal 
//fx_portal_center

// =============================================================================================================================
//========= CATHEDRAL FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================
// =============================================================================================================================
//========= GLOBAL===================================================================

// west tower: dm_cathedral_tower01
// -13.977892, 1.729129, -4.656361 -90.000000, -0.000000, -0.000000
// east:
// 12.825177, 1.565771, -4.656361 -90.000000, -0.000000, -0.000000
// interior pieces: dm_cathedral_floor
// -0.476282, 2.994663, -2.614286
// -0.475631, 2.997262, -2.614286 -180


//    inspect(ai_living_count (e3m5_all_foes))
//		b_e3m5_pop_spam = true;
// 		inspect ()


global boolean s_never_true = FALSE;									// used for holding pattern loop
global boolean b_e3m5_intro_done = FALSE;							// intro pup complete
global boolean b_e3m5_conch = FALSE;									// WHOEVER HOLDS THE CONCH GETS TO SPEAK
global short s_ranger_arranger = 0;										// use in aio to move stage 1 rangers around
global short s_e3m5_hinter = 0;												// used to move mobs around the map during the end battle
global short s_e3m5_forward_progress = 0;							// players' physical progress through map
global short s_e3m5_phantom_mid_state = 0;						// used to load phantom
global short s_e3m5_big_pod_state = 0;								// used to load big drop pod
global short s_e3m5_last_faux_dst = 0;								// prevents same faux-dst from spawning back to back
global short s_e3m5_end_convo = 0;										// used to step through end conversation, objective and puppeteer
global short s_e3m5_backup_count = 0;									// used to cap # of reinforcement waves

// =============================================================================================================================
// ================================================== TITLES ==================================================================

//== startup
script startup courtyard_e3_m5
	//Start the intro
	sleep_until (LevelEventStatus("e3_m5_startup"), 1);
	//firefight_mode_set_player_spawn_suppressed(true);
	print ("************************************************STARTING E3 M5*********************");
	switch_zone_set (e3_m5);
	mission_is_e3_m5 = true;
	b_wait_for_narrative = true;
	ai_ff_all = e3m5_all_foes;
	thread(f_start_player_intro_e3_m5());
//	fade_out (0,0,0,1);
	f_add_crate_folder(e3m5_top_deck);
	f_add_crate_folder(e3m5_middle_deck);
	f_add_crate_folder(e3m5_weapon_lockers);
	f_add_crate_folder(e3m5_ground_level);
	f_add_crate_folder(e3m5_turrets);
	f_add_crate_folder(e3m5_temp);
	f_add_crate_folder(e3m5_waypoints);
	f_add_crate_folder(e3m5_dms);
	f_add_crate_folder(e3m5_ammo);
	f_add_crate_folder(e3m5_loose_weapons);
	// set spawn folder names
	firefight_mode_set_crate_folder_at(e3m5_spawn_start, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(e3m5_spawn_ground_mid, 91); 
	firefight_mode_set_crate_folder_at(e3m5_spawn_structure_mid, 92); 
	firefight_mode_set_crate_folder_at(e3m5_spawn_structure_top, 93); 
	// set objective names
	firefight_mode_set_objective_name_at(e3m5_evac_pt, 81); 			//pelican dustoff spot
	// set LZ spots
	firefight_mode_set_objective_name_at(lz_0, 50);	
//== set squad group names
//	firefight_mode_set_squad_at(e3m5_stg1_w_lane, 1);	//left building
		firefight_mode_set_squad_at(e3m5_phtm_huntship, 3);
//	title_switch_obj_1 = switch_obj_1;
	firefight_mode_set_player_spawn_suppressed(false);
	thread (f_start_events_e3_m5_1());
end

script static void f_start_player_intro_e3_m5
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
		b_wait_for_narrative = true;
		firefight_mode_set_player_spawn_suppressed(false);
		fade_out (0,0,0,1);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30); 
		b_wait_for_narrative = true;
		ai_enter_limbo(e3m5_all_foes);
		intro_vignette_e3_m5();
	end
	firefight_mode_set_player_spawn_suppressed(false);
	print ("_____________done with vignette---SPAWNING__________________");
	//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (object_get_health (player0) > 0, 1);
	print("passed player get health sleep");
	ai_exit_limbo (e3m5_all_foes);
	print("1");
	f_add_crate_folder(e3m5_shades);																												// doing this here so they don't appear in the opening puppeteer
	print("2");
	sleep (4);
	print("3");
	fade_in (0,0,0,30);
	print("4");
end

script static void intro_vignette_e3_m5
	//initialize the game for “interruptive” cutscenes (no split screen)
	cinematic_start();
	print ("_____________starting vignette__________________");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m5_vin_sfx_intro', NONE, 1);
	thread(f_music_e3m5_intro_vignette_start());
	
	//play the puppeteer
	pup_play_show (e3_m5_intro);
	wake(e3m5_vo_intro);
			// Miller : Comms online. The Op is live, Commander.
			// Palmer : Crimson, we've got a solid line on Parg Vol.
	// wait until the puppeteer is complete		
	sleep_until(b_e3m5_intro_done == true);
	
	//turn off split screen
	cinematic_stop();
	
	thread(f_music_e3m5_intro_vignette_finish());
end

script static void f_start_events_e3_m5_1
	print ("***********************************STARTING start_e3_m5_1*************");
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e3_m5.scenery", 
															"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");

	sleep(30);
		thread(e3m5_isthmus_trigger());
		thread(e3m5_kami());
		thread(e3m5_forward_progress_tracker_1());
		thread(e3m5_goon_spawner());
		thread(e3m5_installation_reached());
		thread(e3m5_round_up_stage1());
		thread(e3m5_stage2e_reinforce());
		thread(e3m5_stage2w_reinforce());
		thread(e3m5_watchtower());
		kill_volume_disable(kill_air);
		kill_volume_disable(kill_air_2);
		kill_volume_disable(kill_megazon_a);
		kill_volume_disable(kill_megazon_b);
		kill_volume_disable(kill_megazon_c);
		kill_volume_disable(kill_megazon_d);
		kill_volume_disable(kill_megazon_e);
		kill_volume_disable(kill_megazon_f);
	
	sleep(30);
		ai_place(e3m5_stage1_nest_snipers);
		ai_place(e3m5_stage1_rock_snipers);
		ai_place(e3m5_five_gunners);
	
		ai_place(e3m5_ranger_westrocker);
		ai_place(e3m5_ranger_eastrocker.spawn_points_0);
		ai_place(e3m5_ranger_crossrocker.spawn_points_0);
	
		ai_place(e3m5_stage1_kamikazes);				// 5 grunts
		ai_place(e3m5_stage_1_turret_gunner);
		ai_place(e3m5_perch_sniper);

	fade_in (0,0,0,30);
	
	thread(f_music_e3m5_initial_fade_in());
	
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	f_new_objective(e3m5_objective_01); // "Locate Parg Vol"
	
	sleep(30);
	sleep(30);
	ai_place(e3m5_ranger_jetstepper.spawn_points_0);
	thread(e3m5_stage1_reinf_1());
	sleep(30);
	
	ai_place(e3m5_stage1_insta_snipers);
	sleep(30); 
	thread(f_e3m5_ranger_arranger());
end
//== trigger names and locations:
// e2m1
// trigger_volume_1					// prior to installation, at tower junction
// trigger_volume_stage2e 		//	rounding corner
// trigger_volume_stage2w 		//	rounding corner
// trigger_volume_stage3			//	breach platform
// trigger_volume_2						//	mid alley
// trigger_volume_fr_east			//	pylon east
// trigger_volume_fr_west			//	pylon west
// trigger_turret_vo					//	C-shaped approaching middle lane
// trigger_volumes_5					// very beginning, no avoiding
// trigger_volume_east_lane 	// entrance to east lane
// trigger_parg_1							// ramp up to top of installation
// trigger_parg_2							// top of installation
// hinter_trigger							// entire hinterlands

//== VO
script static void e3m5_vo_hunters
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	
	// Miller : Oh hell, it's the kitchen sink today, isn't it?  Here come Hutners!
	start_radio_transmission( "miller_transmission_name" );
	dprint ("Miller: Oh hell, it's the kitchen sink today, isn't it?  Here come Hutners!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hunters_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_03\e5m3_hunters_00100'));
	end_radio_transmission();
	
	b_e3m5_conch = false;
end

//== VO callbacks
script static void e3m5_callback_intro
//	b_e3m5_conch = false;				
	sleep(10);
	wake(e3m5_vo_playstart);
				// Palmer : Job's simple -- hit Parg Vol's camp hard, leave nothing standing.
end
script static void e3m5_callback_playstart 
	b_e3m5_conch = false;
	sleep(10);
end
script static void e3m5_callback_targetid 
	b_e3m5_conch = false;
	b_end_player_goal = TRUE;							//advance objectives
	f_new_objective(e3m5_objective_02); // "Eliminate Parg Vol"
end
script static void e3m5_callback_targetdown 
	b_e3m5_conch = false;
	sleep(10);
	f_new_objective(e3m5_objective_03); // "Clear All Remaining Hostiles"
end
script static void e3m5_callback_backup 
	b_e3m5_conch = false;
	sleep(10);
	thread(f_e3m5_invasion_start());
end
script static void e3m5_callback_droppods 
	b_e3m5_conch = false;
	thread(e3m5_air_control_phase_1());
end
script static void e3m5_callback_phantoms 
	b_e3m5_conch = false;
	sleep(10);
end
script static void e3m5_callback_snipers 
	b_e3m5_conch = false;
	sleep(10);
end
script static void e3m5_callback_jetpacks 
	b_e3m5_conch = false;
	sleep(10);
end
script static void e3m5_callback_holdout 
	b_e3m5_conch = false;
	sleep(10);
end
script static void e3m5_callback_lotsphantoms 
	b_e3m5_conch = false;
	sleep(30 * 4);												// give players time to reach cover
	b_end_player_goal = TRUE;							// advance objectives
end
script static void e3m5_callback_bombingrun
	b_e3m5_conch = false;
	sleep(10);
	s_e3m5_end_convo = 4;
end
//==
//==scenario
//==
script static void e3m5_watchtower
	sleep_until(object_get_health(e3m5_watchtower_pod) <= 0);
	object_set_phantom_power(e3m5_tower_base, false);
	
	// thread(f_music_e3m5_jetpacks_vo());
end

script static void e3m5_kami
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	sleep(30*2.2);
	ai_grunt_kamikaze(e3m5_grunt_kamis_1);
	ai_set_objective(e3m5_grunt_kamis_1,aio_kamis_seek_players);
//	sleep(45);
//	ai_grunt_kamikaze(e3m5_grunt_kamis_2);
//	ai_set_objective(e3m5_grunt_kamis_2,aio_kamis_seek_players);
//	sleep(25);
//	ai_grunt_kamikaze(e3m5_grunt_kamis_3);
//	ai_set_objective(e3m5_grunt_kamis_3,aio_kamis_seek_players);
//	sleep(30*2);
//	ai_grunt_kamikaze(e3m5_grunt_kamis_4);
//	ai_set_objective(e3m5_grunt_kamis_4,aio_kamis_seek_players);
//	sleep(20);
//	ai_grunt_kamikaze(e3m5_grunt_kamis_5);
//	ai_set_objective(e3m5_grunt_kamis_5,aio_kamis_seek_players);
end

script command_script e3m5_ground_turret_gunner
	sleep(2);
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	ai_braindead(ai_current_actor, false);
	sleep(30 * 10);
	cs_go_to_vehicle(e3m5_plasma_ground, "");
end

script command_script e3m5_turret_gunner_me
	sleep(30*1);
	ai_vehicle_enter_immediate(e3m5_tgunner_me, e3m5_plasma_me);
	cs_queue_command_script(e3m5_tgunner_me,e3m5_gunner_catatonia);
end

script command_script e3m5_turret_gunner_mw
	sleep(30*1);
	ai_vehicle_enter_immediate(e3m5_tgunner_mw, e3m5_plasma_mw);
	cs_queue_command_script(e3m5_tgunner_mw,e3m5_gunner_catatonia);
end

script command_script e3m5_turret_gunner_te
	sleep(30*1);
	print("tgunner run");
	ai_vehicle_enter_immediate(e3m5_tgunner_te, e3m5_plasma_te);
	cs_queue_command_script(e3m5_tgunner_te,e3m5_gunner_catatonia);
end

script command_script e3m5_turret_gunner_tm
	sleep(30*1);
	ai_vehicle_enter_immediate(e3m5_tgunner_tm, e3m5_plasma_1);
	cs_queue_command_script(e3m5_tgunner_tm,e3m5_gunner_catatonia);
end

script command_script e3m5_turret_gunner_tw
	sleep(30*1);
	ai_vehicle_enter_immediate(e3m5_tgunner_tw, e3m5_plasma_tw);
	cs_queue_command_script(e3m5_tgunner_tw,e3m5_gunner_catatonia);
end

script static void e3m5_stage1_reinf_1
	repeat
		sleep_until(ai_living_count(ai_ff_all) < 10);
		if(s_e3m5_forward_progress == 0) then
			ai_place(e3m5_stage1_reinf_a);
			elseif(s_e3m5_forward_progress == 1) then
				ai_place(e3m5_stage1_reinf_b);
				elseif(s_e3m5_forward_progress == 2) then
					ai_place(e3m5_stage1_reinf_c);
					elseif(s_e3m5_forward_progress == 3) then
						ai_place(e3m5_stage1_reinf_d);
		end
		s_e3m5_backup_count = s_e3m5_backup_count + 1;									// note: var can be reset at forward progress points
	until((s_e3m5_backup_count >= 7), 1);															// 7 waves of reinforcement
end

script static void e3m5_goon_spawner
	sleep_until ((volume_test_players (trigger_volume_stage2e)) or (volume_test_players (trigger_volume_stage2w)));
	if(s_e3m5_forward_progress < 4)then
		ai_place(e3m5_ranger_east_goon);
		ai_place(e3m5_ranger_west_goon);
	end
end

//== PROGRESS TRACKERS
script static void e3m5_forward_progress_tracker_1 
	sleep_until (volume_test_players (trigger_volume_1), 1);
		s_e3m5_forward_progress = 1;
		s_e3m5_backup_count = 0;																				// reset reinforcement wave count
		thread(f_music_e3m5_progress_1());
		thread(e3m5_forward_progress_tracker_2());
		thread(e3m5_forward_progress_tracker_3());
		thread(e3m5_forward_progress_tracker_4());
		thread(vo_glo_heavyforces_04());
		thread(e3m5_whats_going_down_in_the_hinterlands());
end

script static void e3m5_forward_progress_tracker_3
	sleep_until ((volume_test_players (trigger_volume_stage2e)) or (volume_test_players (trigger_volume_stage2w)));
	sleep(4);
		thread(f_music_e3m5_progress_2());
		if(s_e3m5_forward_progress < 2)then
		s_e3m5_forward_progress = 2;
		s_e3m5_backup_count = 0;																				// reset reinforcement wave count
		f_create_new_spawn_folder (91);
		end
end

script static void e3m5_forward_progress_tracker_2
	sleep_until (volume_test_players (trigger_volume_2), 1);
	thread(f_music_e3m5_progress_3());
	if(s_e3m5_forward_progress < 3)then
		s_e3m5_forward_progress = 3;
	end
end

script static void e3m5_forward_progress_tracker_4
	sleep_until (volume_test_players (trigger_volume_stage3), 1);
	thread(f_music_e3m5_progress_4());
	s_e3m5_forward_progress = 4;
	s_e3m5_backup_count = 7;																				// kill reinforcement waves
end

//== RANGERS

script static void f_e3m5_ranger_arranger
	s_ranger_arranger = 3;
	sleep(30 * 6);
	s_ranger_arranger = 1;
	sleep(30 * 4);
	repeat
		print(" ");
		local short s_random = real_random_range(1,3);
		if (s_random == 1)then
			s_ranger_arranger = 1;
		elseif(s_random == 2)then
			s_ranger_arranger = 2;
		else
			s_ranger_arranger = 3;
		end
		sleep(30 * 4);
	until((s_e3m5_forward_progress > 2), 1);
	print("************************************** rangers moving to installation");
	print("*********************************************************************");
	print("*********************************************************************");
	print("*********************************************************************");
	print("*********************************************************************");
	sleep_forever();
end
//......  ISTHMUS																e3m5_ranger_isthmus
script static void e3m5_isthmus_trigger
	sleep_until ((volume_test_players (trigger_volume_1)) or (volume_test_players (trigger_volume_east_lane)));
	ai_place(e3m5_ranger_isthmus);
end

script command_script e3m5_ranger_isthmus_init
	sleep(3);
	cs_go_to(isthmus.p0);
	sleep(5);
	ai_set_objective(e3m5_ranger_isthmus, aio_stage1_rangers);
end

//...... EAST ALLEY															e3m5_ranger_east_goon
script command_script e3m5_ranger_east_goon_init
	sleep(2);
	cs_go_to(east_goon.p0);
	cs_go_to_and_face(east_goon.p1,east_goon.p2);
	cs_jump(45, 6);
	sleep(15);
	ai_set_objective(e3m5_ranger_east_goon, aio_stage1_rangers);
end

//..... WEST ALLEY															e3m5_ranger_west_goon
script command_script e3m5_ranger_west_goon_init
	sleep(2);
	cs_go_to_and_face(west_goon.p0,west_goon.p1);
	cs_jump(75, 7);
	sleep(15);
	ai_set_objective(e3m5_ranger_west_goon, aio_stage1_rangers);
end

//..... JETSTEP																	e3m5_ranger_jetstepper 
script command_script e3m5_ranger_jetstepper_init
	sleep(2);
	cs_go_to_and_face(jetstepper.p0,jetstepper.p1);
	sleep(10);
	cs_jump(55, 5);
	thread(e3m5_jetstep_respawn());
	cs_abort_on_damage(true);
	cs_go_to_and_face(jetstepper.p2,jetstepper.p3);
	cs_jump(65, 5);
	ai_set_objective(e3m5_ranger_jetstepper, aio_stage1_rangers);
end
script command_script cs_e3m5_ranger_jetstepper_sniper
	sleep(2);
	cs_go_to_and_face(jetstepper.p4,jetstepper.p5);
	sleep(10);
	cs_jump(65, 6.8);
	sleep(60);
	ai_set_objective(e3m5_ranger_jetstepper, aio_stage1_rangers);
end
script command_script cs_e3m5_ranger_jetstepper_bkp
	sleep(2);
	cs_go_to_and_face(jetstepper.p4,jetstepper.p6);
	sleep(10);
	cs_jump(55, 6.7);
	sleep(60);
	ai_set_objective(e3m5_ranger_jetstepper, aio_stage1_rangers);
end
script static void e3m5_jetstep_respawn
	sleep_until(ai_living_count(e3m5_ranger_jetstepper) < 1);
	if(s_e3m5_forward_progress == 0)then
			if(object_get_health(e3m5_watchtower_pod) > 0)then
				ai_place(e3m5_ranger_jetstepper.spawn_points_1);						// sniper
			else
				ai_place(e3m5_ranger_jetstepper.spawn_points_2);
			end
	end
end


//..... WESTROCK L															e3m5_ranger_westrocker 
script command_script e3m5_ranger_westrocker_init
	sleep(2);
	cs_abort_on_damage(true);
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	cs_jump(68, 5.75);
	sleep(2);
	ai_set_objective(e3m5_ranger_westrocker, aio_stage1_rangers);
end
//.....	EASTROCK L															e3m5_ranger_eastrocker 
script command_script e3m5_ranger_eastrocker_init
	sleep(2);
	cs_abort_on_damage(true);
	thread(e3m5_eastrock_respawn());
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	sleep(30 * 3);
	cs_enable_targeting(e3m5_ranger_eastrocker, true);
	cs_enable_moving(e3m5_ranger_eastrocker, true);
	cs_go_to_and_face(eastrocker.p0,eastrocker.p1);
	cs_go_to_and_face(eastrocker.p2,eastrocker.p3);
	cs_jump(65, 6);
	ai_set_objective(e3m5_ranger_eastrocker, aio_stage1_rangers);
end
script command_script cs_e3m5_ranger_eastrocker_bkp
	cs_go_to_and_face(eastrocker.p4,eastrocker.p5);
	cs_jump(45, 7.5);
	ai_set_objective(e3m5_ranger_eastrocker, aio_stage1_rangers);
end
script static void e3m5_eastrock_respawn
	sleep_until(ai_living_count(e3m5_ranger_eastrocker) < 1);
	if(s_e3m5_forward_progress == 0)then
		ai_place(e3m5_ranger_eastrocker.spawn_points_1);
	end
end
//..... CROSSROCK																e3m5_ranger_crossrocker 
script command_script e3m5_ranger_crossrocker_init
	sleep(2);
	cs_abort_on_damage(true);
	thread(e3m5_crossrock_respawn());
	sleep_until (volume_test_players (trigger_volumes_5), 1);
	cs_go_to_and_face(crossrocker.p4,crossrocker.p1);
	cs_go_to_and_face(crossrocker.p0,crossrocker.p1);
	cs_jump(64, 5);
	cs_enable_targeting(e3m5_ranger_crossrocker, true);
	cs_enable_moving(e3m5_ranger_crossrocker, true);
	cs_go_to_and_face(crossrocker.p2,crossrocker.p3);
	cs_jump(64, 6.4);
	ai_set_objective(e3m5_ranger_crossrocker, aio_stage1_rangers);
end
script command_script cs_e3m5_ranger_crossrocker_bkp
	cs_go_to_and_face(crossrocker.p5,crossrocker.p6);
	if(object_get_health(e3m5_watchtower_pod) > 0)then
		cs_go_to_and_face(crossrocker.p6,crossrocker.p6);
	end
	ai_set_objective(e3m5_ranger_crossrocker, aio_stage1_rangers);
end
script static void e3m5_crossrock_respawn
	sleep_until(ai_living_count(e3m5_ranger_crossrocker) < 1);
	if(s_e3m5_forward_progress == 0)then
		ai_place(e3m5_ranger_crossrocker.spawn_points_1);
	end
end

script command_script e3m5_gunner_catatonia
	cs_abort_on_damage(true);
	sleep_until(s_e3m5_forward_progress > 1);
end


//== Stage2
script static void e3m5_round_up_stage1
	sleep_until (s_e3m5_forward_progress > 2);
//	ai_set_objective(e3m5_stage1_foes, aio_seek_players);									// I think we should be ok without this (should be covered by other aios)
end

script static void e3m5_stage2e_reinforce
	sleep_until (volume_test_players (trigger_volume_stage2e));
	if((ai_living_count(e3m5_all_foes) < 15) and (s_e3m5_forward_progress < 3))then
		ai_place(e3m5_stage2_e_fodder);
		ai_place(e3m5_stage2_e_lancer);
		ai_place(e3m5_stage2_e_lancer_b);
		ai_place(e3m5_stage2_e_lancer_c);
	elseif((ai_living_count(e3m5_all_foes) < 17) and (s_e3m5_forward_progress < 3))then
		ai_place(e3m5_stage2_e_fodder);
		ai_place(e3m5_stage2_e_lancer);
	end
end

script static void e3m5_stage2w_reinforce
	sleep_until (volume_test_players (trigger_volume_stage2w));
	if((ai_living_count(e3m5_all_foes) < 15) and (s_e3m5_forward_progress < 3))then
		ai_place(e3m5_stage2_w_fodder);
		ai_place(e3m5_stage2_w_lancer);
		ai_place(e3m5_stage2_w_lancer_b);
		ai_place(e3m5_stage2_w_lancer_c);
	elseif((ai_living_count(e3m5_all_foes) < 17) and (s_e3m5_forward_progress < 3))then
		ai_place(e3m5_stage2_w_fodder);
		ai_place(e3m5_stage2_w_lancer);
	end
end

//== Parg Vol
script static void e3m5_installation_reached 
	sleep_until (volume_test_players (trigger_volume_stage3), 1);
	f_create_new_spawn_folder (92);
	thread(e3m5_parg_kamikazes());
	thread(e3m5_parg_almost_done());
	thread(e3m5_parg_killed());
	thread(e3m5_air_warning());
	ai_place(parg_vol);
	if(ai_living_count(e3m5_all_foes) < 6)then
		
		ai_place(e3m5_midtier);
		
		ai_place(parg_lieutenant);
		ai_place(parg_skirmishers);
		ai_place(parg_attendants);
		ai_place(parg_assassin);
		ai_place(parg_kamikaze);
		ai_place(parg_filler);
		sleep(2);
		ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) < 9)then
		ai_place(parg_lieutenant);
		ai_place(parg_skirmishers);
		ai_place(parg_attendants);
		ai_place(parg_assassin);
		ai_place(parg_kamikaze);
		ai_place(parg_filler);
		sleep(2);
		ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) == 11)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
			ai_place(parg_attendants);
			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
			ai_place(parg_filler);
			sleep(2);
			ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) < 13)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
			ai_place(parg_attendants);
			ai_place(parg_assassin);
			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
			sleep(2);
			ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) == 13)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
			ai_place(parg_attendants);
//			ai_place(parg_assassin);
			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
	elseif(ai_living_count(e3m5_all_foes) == 13)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
			ai_place(parg_attendants);
//			ai_place(parg_assassin);
			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
	elseif(ai_living_count(e3m5_all_foes) == 14)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
//			ai_place(parg_attendants);
			ai_place(parg_assassin);
			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
			sleep(2);
			ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) == 15)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
			ai_place(parg_attendants);
			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
			sleep(2);
			ai_set_active_camo(parg_assassin, true);
	elseif(ai_living_count(e3m5_all_foes) == 16)then
			ai_place(parg_lieutenant);
//			ai_place(parg_skirmishers);
//			ai_place(parg_attendants);
//			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
			ai_place(parg_filler);
	elseif(ai_living_count(e3m5_all_foes) == 17)then
//			ai_place(parg_lieutenant);
//			ai_place(parg_skirmishers);
//			ai_place(parg_attendants);
//			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
			ai_place(parg_filler);
	elseif(ai_living_count(e3m5_all_foes) == 18)then
			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
//			ai_place(parg_attendants);
//			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
	elseif(ai_living_count(e3m5_all_foes) < 20)then
//			ai_place(parg_lieutenant);
			ai_place(parg_skirmishers);
//			ai_place(parg_attendants);
//			ai_place(parg_assassin);
//			ai_place(parg_kamikaze);
//			ai_place(parg_filler);
	end
	f_blip_ai_cui (parg_vol, "navpoint_enemy");
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	
	thread(f_music_e3m5_targetid_vo());
	wake(e3m5_vo_targetid);
							// Miller : Target identified, Commander.  There's Parg Vol.
							// Palmer : Take him down, Crimson!
	thread(f_e3m5_parg_vol_cheat());
end

script static void e3m5_parg_kamikazes
	sleep_until ((volume_test_players (trigger_parg_1)) or (volume_test_players (trigger_parg_2)));
	if (ai_living_count(parg_kamikaze) > 0) then
		ai_braindead(parg_kamikaze, false);
		ai_grunt_kamikaze(parg_kamikaze);
		ai_set_objective(parg_kamikaze,aio_seek_players);
	end
end
script static void f_e3m5_parg_vol_cheat
	sleep_until(unit_get_health(parg_vol) < .25);
	print("RENEWING*****************************************************");
	ai_renew(parg_vol);
	sleep(35);
	sleep_until(unit_get_health(parg_vol) < .25);
	sleep(3);
	print("RENEWING*****************************************************");
	ai_renew(parg_vol);
	sleep_forever();
end
script static void e3m5_parg_killed
	sleep_until(ai_living_count(parg_vol) <= 0);
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(30);
	
	thread(f_music_e3m5_targetdown_vo());
	wake(e3m5_vo_targetdown);
							// Miller : Parg Vol is down!  Confirmed kill!
							// Palmer : Great work, Crimson.
end

script static void e3m5_parg_almost_done
	sleep_until (LevelEventStatus("e3m5_parg_pop_blip"), 1);
end

//=== Air Assault
script static void e3m5_air_warning
	sleep_until (LevelEventStatus("e3m5_air_warning"), 1);
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(30 * 2);
	wake(e3m5_vo_backup);
							// Dalton : Commander Palmer, tell Crimson to get ready.  They've upset the locals and have a little bit of everything headed their way.
							// Palmer : Few things make me happier than upsetting the Covenant.  Spartans!  Ready up.
							// *** callback threads f_e3m5_invasion_start
end

script static void  f_e3m5_invasion_start
	f_new_objective(e3m5_objective_04);
							// "Prepare for Invasion"
	sleep(30 * 12);
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	
	thread(f_music_e3m5_drop_pods_vo());
	wake(e3m5_vo_droppods);
							// Miller : Oh wow.  Dalton wasn't kidding.  Drop pods inbound on Crimson's location.
							// *** callback threads e3m5_air_control_phase_1
end

script static void e3m5_air_control_phase_1
	f_create_new_spawn_folder (93);
	s_e3m5_forward_progress = 5;																						// air assault
	
	// part 1 - rain of drop pods =========================================================================
	thread(f_music_e3m5_control_tower_drop_pods());
	thread(e3m5_droppod_wave_start());																			
	thread(e3m5_air_control_2_attack_of_the_phantoms());
	thread(e3m5_scenario_complete_sequence());
	sleep(30 * 4);
	f_new_objective(e3m5_objective_05);
							// "Defend"	
	sleep_until (LevelEventStatus("e3m5_droppods_complete"), 1);
	sleep(30 * 1);
	sleep_until(ai_living_count(e3m5_all_foes) < 16);
	thread(f_e3m5_random_faux_dst());
	sleep(30 * 2);

	thread(f_e3m5_random_faux_dst());
	sleep(30 * 3);
	thread(f_e3m5_random_faux_dst());
	
	thread(f_music_e3m5_incoming_vo());
	thread(vo_glo_incoming_03());
							// Miller : Don't relax yet. You've got more hostiles headed your way.

	// part 2 - second drop pod ==============================================================================
	sleep_until(ai_living_count(e3m5_all_foes) < 11);
	thread(e3m5_big_drop_2());
	sleep_until(ai_living_count(e3m5_all_foes) < 12);
	thread(f_e3m5_random_faux_dst());																																						
	sleep(30);
	thread(f_e3m5_random_faux_dst());
	print("------------------------------------------------------A");
	sleep_until(ai_living_count(e3m5_all_foes) < 11);
	thread(f_e3m5_random_faux_dst());
	print("------------------------------------------------------B");
	sleep(10);
	sleep_until(ai_living_count(e3m5_all_foes) < 9);
	// part 3 - Hunters =====================================================================================
	f_e3m5_random_faux_dst();																								// population bump
	ai_place_in_limbo(e3m5_phtm_huntship);	
	thread(f_e3m5_vo_hunters_almost_done());																// gated event vo
	sleep(30 * 3);
	thread(e3m5_hunters_objective_set_to_nmws());
	thread(f_music_e3m5_snipers_vo());
	thread(f_e3m5_hunter_snipers());
							// Miller : Snipers! Marking them for you as I see them, Crimson.
	sleep(30 * 7); 
	thread(e3m5_vo_hunters());
							// Miller : Oh hell, it's the kitchen sink today, isn't it?  Here come Hunters!
//	sleep_until (LevelEventStatus("e3m5_huntship_clear"), 1) or (ai_living_count(e3m5_phtm_huntship) < 1);
	thread(e3m5_hunter_headpat());		
	thread(f_music_e3m5_phantoms_vo());	
	thread(f_e3m5_vo_phantoms());																						// waits til < 9 mobs
							// Dalton : Phantoms near Crimson's location, Commander.
							// Palmer : We see them, Dalton.  How are we on air support?
							// Dalton : Spread thin at the moment, but I'm working on it.
							// Palmer : Work faster, please.
end

script static void e3m5_hunters_objective_set_to_nmws
	sleep_until(firefight_mode_current_player_goal_type() == time_passed);
	b_end_player_goal = TRUE;																								// advance objectives (to nmw's)
end

script static void e3m5_air_control_2_attack_of_the_phantoms
	sleep_until (LevelEventStatus("e3m5_air_phase_1_done"), 1);							// triggered from bonobo after hunter wave is all done
// part 4 - phase 2 prep ===========================================================================
	sleep(30);
	thread(f_music_e3m5_heavy_forces_vo());
	f_e3m5_vo_heavyforces();																								// not threading, need to wait til this returns
							// Miller : Commander --
							// Palmer : I see it too. Crimson, heavy enemy movement, coming your way. Ready up
	f_new_objective(e3m5_objective_04); 																		// "Prepare for Invasion"
	sleep(30 * 2);
	
	thread(f_music_e3m5_ordnance_vo());
	f_e3m5_vo_ordnance();
							// Palmer : Dalton, Crimson could use some new toys.
							// Dalton : I can arrange that, Commander.
	sleep(30);
	thread(e3m5_ordnance_drop_1());
	sleep(30 * 7);
	vo_glo_incoming_05();
							// Miller : Get ready, more bad guys headed your way.
	sleep(30 * 3);

// part 5 - phantoms ==============================================================================
	thread(e3m5_phantom_sortie_1());
	thread(f_e3m5_random_faux_dst());
	thread(f_e3m5_random_faux_dst());
	sleep(30 * 2); 
	thread(f_e3m5_random_faux_dst()); 
	sleep(30 * 1); 
	thread(f_music_e3m5_defend_objective_set());
	thread(f_new_objective(e3m5_objective_05)); 
							// "Defend"	
	sleep(30 * 3);
	sleep_until(ai_living_count(e3m5_all_foes) < 16);
	ai_place(e3m5_faux_cdst_1);
	sleep(10);
	ai_place(e3m5_faux_cdst_2);
	ai_place(e3m5_faux_cdst_5);
	sleep(30 * 2);
	ai_place(e3m5_faux_cdst_1);
	sleep(10);
	ai_place(e3m5_faux_cdst_2);
	sleep_until(ai_living_count(e3m5_all_foes) < 16);
	ai_place(e3m5_faux_cdst_5);
	sleep(30 * 2);
	ai_place(e3m5_faux_cdst_5);
	sleep(30 * 2);
	ai_place(e3m5_faux_cdst_5);
	sleep(30 * 2);
	ai_place(e3m5_faux_cdst_5);
	sleep_until(ai_living_count(e3m5_all_foes) < 7);
	thread(f_e3m5_transport_gunship());
	thread(vo_glo_phantom_08());
							// Miller : Phantom!
	sleep(30 * 2);
	thread(f_music_e3m5_holdout_vo());
	ordnance_show_nav_markers(false);
	thread(f_e3m5_vo_holdout());
							// Palmer : Dalton!  Where's that air support you promised me?
							// Dalton : I didn't promise -- I said I was working on it!
							// Palmer : Same thing, Dalton.  Get Crimson some air support and get it to them soon.
	sleep(30 * 15);
	sleep_until(ai_living_count(e3m5_sg_paratroops) < 6);										// ground troops only
	thread(f_music_e3m5_part5_stragglers());
	f_blip_ai_cui (e3m5_sg_paratroops, "navpoint_enemy");										// blip stragglers
	sleep_until(ai_living_count(e3m5_sg_paratroops) < 1);										// ground troops only
	sleep(30);
	thread(f_e3m5_phantom_swarm_in());
end

script static void f_e3m5_phantom_swarm_in
	print ("--------------------------------------------sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1); 
	switch_zone_set (e3_m5_b);
	current_zone_set_fully_active(); 
	ai_place_in_limbo(ph_e3m5_center_gunship);
	sleep(30);
	ai_place_in_limbo(ph_e3m5_faux_gunship);
	if(ai_living_count(ph_e3m5_gunship_1a) < 1) and (ai_living_count(ph_e3m5_gunship_1b) < 1)then
		ai_place_in_limbo(ph_e3m5_gunship_1b);
	end
	sleep(30);
	ai_place_in_limbo(ph_e3m5_faux_dropship);
	if(ai_living_count(ph_e3m5_transport_gunship) < 1) and (ai_living_count(ph_e3m5_transport_gunship_bkp) < 1)then
		ai_place_in_limbo(ph_e3m5_transport_gunship_bkp);
	end
	thread(f_music_e3m5_cover_vo());
	wake(e3m5_vo_lotsphantoms);
							// Miller : Commander!  Multiple Phantoms closing in on Crimson!  Oh, this is bad!
							// Palmer : Dalton!  Air support!  Now!
							// Dalton : Inbound, Commander!  Get Crimson to cover! 
							// Palmer : You heard the man, Crimson!  Get your asses into some shelter!
							// **** var flipped to Advance Objectives	
end

script static void f_e3m5_vo_holdout
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
							
	wake(e3m5_vo_holdout);
							// Palmer : Dalton!  Where's that air support you promised me?
							// Dalton : I didn't promise -- I said I was working on it!
							// Palmer : Same thing, Dalton.  Get Crimson some air support and get it to them soon.
end

script static void f_e3m5_vo_ordnance
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(30);
	vo_glo_ordnance_02();
							// Palmer : Dalton, Crimson could use some new toys.
							// Dalton : I can arrange that, Commander.
	b_e3m5_conch = false;
end
script static void f_e3m5_vo_hunters_almost_done
	sleep_until (LevelEventStatus("e3m5_hunters_almost_done"), 1);
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(30 * 1.5);
	thread(vo_glo_remainingcov_05());
							// PALMER : Couple Covies still knocking about. Take 'em down.
	sleep(30 * 3.5);
	b_e3m5_conch = false;
end

script static void f_e3m5_vo_phantoms
	sleep_until(ai_living_count(e3m5_all_foes) < 9);
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(30);
	wake(e3m5_vo_phantoms);
							// Dalton : Phantoms near Crimson's location, Commander.
							// Palmer : We see them, Dalton.  How are we on air support?
							// Dalton : Spread thin at the moment, but I'm working on it.
							// Palmer : Work faster, please.
end

script static void f_e3m5_vo_heavyforces
	sleep_until(b_e3m5_conch == false);
	b_e3m5_conch = true;
	sleep(20);
	thread(vo_glo_heavyforces_05());
							// Miller : Commander --
							// Palmer : I see it too. Crimson, heavy enemy movement, coming your way. Ready up.
	sleep(30 * 4);
	b_e3m5_conch = false;
end

script static void e3m5_hunter_headpat
	sleep(30 * 10);
	sleep_until(ai_living_count(e3m5_hunter_1) <= 0);
	sleep_until(ai_living_count(e3m5_hunter_2) <= 0);
	thread(f_e3m5_zone_swap_prep());
	if (b_e3m5_conch == false)then
		b_e3m5_conch = true;
		sleep(20);
		thread(f_music_e3m5_nicework_vo());
		thread(vo_glo_nicework_02());
							// Palmer : Nice work, Crimson.
		sleep(30 * 3);
		b_e3m5_conch = false;
	end
end

script static void f_e3m5_zone_swap_prep()
	sleep(30 * 5);
	prepare_to_switch_to_zone_set (e3_m5_b);
end

script static void e3m5_whats_going_down_in_the_hinterlands								// used in aio's
	sleep_until(s_e3m5_forward_progress == 5);
	if(volume_test_players_all (hinter_trigger) == true)then
		s_e3m5_hinter = 2;
		elseif(volume_test_players (hinter_trigger) == true)then
			s_e3m5_hinter = 1;
			else
				s_e3m5_hinter = 0;
	end
	if(s_e3m5_end_convo > 0)then																						// all done
		sleep_forever();
	end
end

script static void e3m5_ordnance_drop_1
	print("-------------------ordnance called");
//	cinematic_set_title (e3m5_ordnance);
	ordnance_drop(flag1, "storm_rocket_launcher");
	sleep(30);
	ordnance_drop(flag2, "storm_spartan_laser");
	sleep(10);
	ordnance_drop(flag3, "storm_spartan_laser");
	sleep(5);
	ordnance_drop(flag4, "storm_rocket_launcher");
	sleep(30);
//	ordnance_drop(flag5, "storm_rocket_launcher");
end

script static void f_e3m5_hunter_snipers
	ai_place(sq_e3m5_sniper_nest_1a);
	sleep(20);
	thread(f_e3m5_miller_marks_snipers());
	
	ai_place(sq_e3m5_sniper_nest_2a);
	sleep(30);
	ai_place(sq_e3m5_sniper_nest_2b);
	thread(f_music_e3m5_sniper_stragglers());
	f_blip_ai_cui (sq_e3m5_sniper_nest_1a, "navpoint_enemy");
	ai_place(sq_e3m5_sniper_nest_1b);
	sleep(30);
	ai_place(sq_e3m5_sniper_nest_2c);
	sleep(30);
	f_blip_ai_cui (sq_e3m5_sniper_nest_2a, "navpoint_enemy");
	sleep(20);
	f_blip_ai_cui (sq_e3m5_sniper_nest_2b, "navpoint_enemy");
	sleep(10);
	f_blip_ai_cui (sq_e3m5_sniper_nest_1b, "navpoint_enemy");
	sleep(20);
	f_blip_ai_cui (sq_e3m5_sniper_nest_2c, "navpoint_enemy");
	thread(f_e3m5_sniper_timer());
end

script static void f_e3m5_miller_marks_snipers
	sleep_until(b_e3m5_conch == false);
	sleep(30);
	b_e3m5_conch = true;
	
	wake(e3m5_vo_snipers);
							// Miller : Snipers! Marking them for you as I see them, Crimson.
end

script command_script cs_e3m5_nest_sniper_1a
	sleep(2);
	cs_jump(60, 4.2);
	sleep(10);
end

script command_script cs_e3m5_nest_sniper_1b
	sleep(2);
	cs_jump(55, 3.5);
	sleep(10);
end

script command_script cs_e3m5_nest_sniper_2
	sleep(2);
	cs_jump(60, 4);
	sleep(10);
end

script static void f_e3m5_sniper_timer
	sleep(30 * 120);																												//2 minutes

	if(ai_living_count(sq_e3m5_sniper_nest_1a) > 0)then
		thread(f_sniper_jump_1a());
	end
	sleep(10);
	if(ai_living_count(sq_e3m5_sniper_nest_2a) > 0)then
		thread(f_sniper_jump_1b());
	end
	sleep(30 * 1.5);
	
	if(ai_living_count(sq_e3m5_sniper_nest_1b) > 0)then
		thread(f_sniper_jump_2a());
	end
	if(ai_living_count(sq_e3m5_sniper_nest_2b) > 0)then
		thread(f_sniper_jump_2b());
	end
	
	sleep(30 * 2);
	
	if(ai_living_count(sq_e3m5_sniper_nest_2c) > 0)then
		thread(f_sniper_jump_2c());
	end
	
	s_e3m5_forward_progress = 6;
end

script static void f_sniper_jump_1a
	thread(f_e3m5_sniper_nest_1_jump_down(sq_e3m5_sniper_nest_1a));
	sleep( 30* 3);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_1a)) < -2)then
		sleep_forever();
	end
	cs_look(sq_e3m5_sniper_nest_1a, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sq_e3m5_sniper_nest_1a, true, cdst_pts.jump9);
	sleep(3);
	cs_jump(sq_e3m5_sniper_nest_1a, true, 75, 7.5);
	sleep( 30* 6);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_1a)) < -2)then
		sleep_forever();
	else
		ai_kill(sq_e3m5_sniper_nest_1a);
	end
end
script static void f_sniper_jump_1b
	thread(f_e3m5_sniper_nest_1_jump_down(sq_e3m5_sniper_nest_1b));
	sleep( 30* 4);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_1b)) < -2)then
		sleep_forever();
	end
	cs_look(sq_e3m5_sniper_nest_1b, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sq_e3m5_sniper_nest_1b, true, cdst_pts.jump9);
	sleep(3);
	cs_jump(sq_e3m5_sniper_nest_1b, true, 75, 7.5);
	sleep( 30* 7);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_1b)) < -2)then
		sleep_forever();
	else
		ai_kill(sq_e3m5_sniper_nest_1b);
	end
end
script static void f_sniper_jump_2a
	thread(f_e3m5_sniper_nest_1_jump_down(sq_e3m5_sniper_nest_2a));
	sleep( 30* 4);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2a)) < -2)then
		sleep_forever();
	end
	cs_look(sq_e3m5_sniper_nest_2a, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sq_e3m5_sniper_nest_2a, true, cdst_pts.jump9);
	sleep(3);
	cs_jump(sq_e3m5_sniper_nest_2a, true, 75, 7.5);
	sleep( 30* 7);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2a)) < -2)then
		sleep_forever();
	else
		ai_kill(sq_e3m5_sniper_nest_2a);
	end
end
script static void f_sniper_jump_2b
	thread(f_e3m5_sniper_nest_1_jump_down(sq_e3m5_sniper_nest_2b));
	sleep( 30* 4);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2b)) < -2)then
		sleep_forever();
	end
	cs_look(sq_e3m5_sniper_nest_2b, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sq_e3m5_sniper_nest_2b, true, cdst_pts.jump9);
	sleep(3);
	cs_jump(sq_e3m5_sniper_nest_2b, true, 75, 7.5);
	sleep( 30* 7);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2b)) < -2)then
		sleep_forever();
	else
		ai_kill(sq_e3m5_sniper_nest_2b);
	end
end
script static void f_sniper_jump_2c
	thread(f_e3m5_sniper_nest_1_jump_down(sq_e3m5_sniper_nest_2c));
	sleep( 30* 4);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2c)) < -2)then
		sleep_forever();
	end
	cs_look(sq_e3m5_sniper_nest_2c, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sq_e3m5_sniper_nest_2c, true, cdst_pts.jump9);
	sleep(3);
	cs_jump(sq_e3m5_sniper_nest_2c, true, 75, 7.5);
	sleep( 30* 7);
	if(object_get_z(ai_get_object(sq_e3m5_sniper_nest_2c)) < -2)then
		sleep_forever();
	else
		ai_kill(sq_e3m5_sniper_nest_2c);
	end
end

script static void f_e3m5_sniper_nest_1_jump_down(ai sniper)
	sleep(3);
	cs_look(sniper, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sniper, true, cdst_pts.jump9);
//	cs_go_to_and_face(sniper, true, cdst_pts.sniper1, cdst_pts.jump9);
	sleep(10);
	cs_jump(sniper, true, 45, 5);
end

script static void f_e3m5_sniper_nest_2_jump_down(ai sniper)
	sleep(3);
	cs_look(sniper, true, cdst_pts.jump9);
	sleep(3);
	cs_face(sniper, true, cdst_pts.jump9);
//	cs_go_to_and_face(sniper, true, cdst_pts.sniper1, cdst_pts.jump9);
	sleep(10);
	cs_jump(sniper, true, 45, 5);
end

//== phantoms



script static void e3m5_phantom_sortie_1																// peak cost- 16, leaves 12 ground forces
	ai_place(ph_e3m5_gunship_1a);
	sleep(30 * 1.5);
	f_e3m5_paradrop_1();
end


//	"phantom_p_lf"
//	"phantom_p_ml_f"
//	"phantom_p_ml_b"
//	"phantom_p_rb"
//	"phantom_p_rf"
//	"phantom_p_mr_f"
//	"phantom_p_mr_b"
//	"phantom_p_lf"
//	"phantom_p_rf"
//	"phantom_p_lb"
//	"phantom_p_rb"
//	
script static void f_e3m5_paradrop_1																	// 4 jax, 8 grunts

	ai_place_in_limbo (ph_e3m5_flyby_mid, 1);
	
	ai_place_in_limbo (sq_e3m5_para_2jax_a, 2);
	ai_place_in_limbo (sq_e3m5_para_2jax_b, 2);
	ai_place_in_limbo (sq_e3m5_para_4grunt_a, 4);
	ai_place_in_limbo (sq_e3m5_para_4grunt_b, 4);
	
	sleep_until(s_e3m5_phantom_mid_state == 1);
	
	ai_exit_limbo(sq_e3m5_para_2jax_a);
	ai_vehicle_enter_immediate(sq_e3m5_para_2jax_a, ph_e3m5_flyby_mid, "phantom_p_lf");
	ai_exit_limbo(sq_e3m5_para_4grunt_a);
	ai_vehicle_enter_immediate(sq_e3m5_para_4grunt_a, ph_e3m5_flyby_mid, "phantom_p_rb");
	ai_exit_limbo(sq_e3m5_para_2jax_b);
	ai_vehicle_enter_immediate(sq_e3m5_para_2jax_b, ph_e3m5_flyby_mid, "phantom_p_rf");
	ai_exit_limbo(sq_e3m5_para_4grunt_b);
	ai_vehicle_enter_immediate(sq_e3m5_para_4grunt_b, ph_e3m5_flyby_mid, "phantom_p_lb");
	
	sleep(4);
	
	s_e3m5_phantom_mid_state = 2;
	
end

script static void f_e3m5_transport_gunship																	// 8 jax, 2 grunt, 1 3-man phantom

	ai_place_in_limbo (ph_e3m5_transport_gunship, 1);
	
	ai_place_in_limbo (sq_e3m5_para_4jax_a, 4);
	ai_place_in_limbo (sq_e3m5_para_4jax_b, 4);
	ai_place_in_limbo (sq_e3m5_para_2grunt, 2);
	
	sleep_until(s_e3m5_phantom_mid_state == 1);
	
	ai_exit_limbo(sq_e3m5_para_4jax_a);
	ai_vehicle_enter_immediate(sq_e3m5_para_4jax_a, ph_e3m5_transport_gunship, "phantom_p_lf");
	ai_exit_limbo(sq_e3m5_para_4jax_b);
	ai_vehicle_enter_immediate(sq_e3m5_para_4jax_b, ph_e3m5_transport_gunship, "phantom_p_rf");
	ai_exit_limbo(sq_e3m5_para_2grunt);
	ai_vehicle_enter_immediate(sq_e3m5_para_2grunt, ph_e3m5_transport_gunship, "phantom_p_lb");
	
	sleep(4);
	
	s_e3m5_phantom_mid_state = 2;
	
end
	
script command_script e3m5_phantom_huntship_init 

	thread(e3m5_hunter_spawner());
 	print("----------------=-=-=-=-=- Hunter Spawner called");
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (1);
	ai_exit_limbo (ai_current_actor);
	sleep (1);
	sleep_until(ai_in_limbo_count(e3m5_sg_hunter_1) >0 and ai_in_limbo_count(e3m5_sg_hunter_2) >0);
	
	ai_exit_limbo(e3m5_sg_hunter_1);
	ai_vehicle_enter_immediate(e3m5_sg_hunter_1, e3m5_phtm_huntship, "phantom_p_rf");
	ai_exit_limbo(e3m5_sg_hunter_2);
	ai_vehicle_enter_immediate(e3m5_sg_hunter_2, e3m5_phtm_huntship, "phantom_p_lf");
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 60 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	
	// fly in and move into boarding position
	cs_fly_to_and_face (phtm_orbit_pts.p13, phtm_orbit_pts.p11);
	cs_fly_to_and_face (phtm_orbit_pts.p9, phtm_orbit_pts.p7);
	cs_fly_to_and_face (phtm_orbit_pts.p8, phtm_orbit_pts.p7);
	cs_fly_to_and_face (phtm_orbit_pts.board1, phtm_orbit_pts.board2);
	
//board1 - 7.202955, -7.626394, 0.499145

//dropoff
	f_unload_phantom (ai_current_squad, "right");
	sleep (30 * 2.5);
	cs_fly_to_and_face (phtm_orbit_pts.board4, phtm_orbit_pts.board3);
	cs_fly_to_and_face (phtm_orbit_pts.board1, phtm_orbit_pts.board3);
	sleep(20);
	f_unload_phantom (ai_current_squad, "left");
	sleep (30 * 2.5);

//outro
	cs_fly_to_and_face (phtm_orbit_pts.p8, phtm_orbit_pts.p9);
	cs_fly_to_and_face (phtm_orbit_pts.p9, phtm_orbit_pts.p13);
	NotifyLevel ("e3m5_huntship_clear");  
	cs_fly_to_and_face (phtm_orbit_pts.p13, phtm_orbit_pts.p15);
	cs_fly_to_and_face (phtm_orbit_pts.p14, phtm_orbit_pts.p14);
	sleep(30);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
end

script static void e3m5_hunter_spawner
 	ai_place_in_limbo (e3m5_sg_hunter_1, 1);			
 	ai_place_in_limbo (e3m5_sg_hunter_2, 1);			
end

script command_script cs_e3m5_ph_gunship_1a
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (4);
	ai_exit_limbo (ai_current_actor);
	sleep(2);
	thread(f_e3m5_gunship1_replacer());
	ai_teleport(ai_current_squad, w_e_flyby.f0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 180 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(90);
	cs_fly_to_and_face (w_e_flyby.f1, w_e_flyby.f2);
	ai_set_blind (ai_current_squad, FALSE);
//	if(game_difficulty_get() == legendary)then
//		cs_enable_targeting(true);
//	end
	
	cs_fly_to_and_face (w_e_flyby.f7, w_e_flyby.face0);							// position one, left side presented
	sleep(30 * 3);
	cs_fly_to_and_face (w_e_flyby.f3, w_e_flyby.face2);							// front of installation, left side presented
	sleep(30 * 3);
	cs_fly_to_and_face (w_e_flyby.f4, w_e_flyby.face1);							// position two, left side presented
	sleep(30 * 3);
	cs_fly_to_and_face (w_e_flyby.f5, w_e_flyby.face1);							// position two, left side presented, pulled back a bit
	sleep(30 * 3);
	//turn, present right side
	cs_fly_to_and_face (w_e_flyby.f5, w_e_flyby.f4);
	cs_fly_to_and_face (w_e_flyby.f5, w_e_flyby.f3);
	cs_fly_to_and_face (w_e_flyby.f3, w_e_flyby.f2);								// front of installation, right side presented
	
	//go to pos1, wheel around to face installation
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face5);
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face6);
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face1);							// pos 1, nose facing installation
	sleep(30 * 3);
	cs_queue_command_script(ai_current_squad, cs_e3m5_gunship_area1_random_hover);
end	

script command_script cs_e3m5_gunship_1b
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); 
	sleep (5);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 60 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	
	cs_fly_to_and_face (phtm_orbit_pts.p1, phtm_orbit_pts.p0);
	
	ai_set_blind (ai_current_squad, FALSE);
//	cs_enable_targeting(true);
	sleep(2);
	ai_set_blind (ai_current_squad, FALSE);
	sleep(2);
	// settle in @ 1 o'clock
	cs_fly_to_and_face (phtm_orbit_pts.p2, phtm_orbit_pts.p0);
//	cs_fly_to_and_face (phtm_orbit_pts.p3, phtm_orbit_pts.p0);
//	cs_fly_to_and_face (phtm_orbit_pts.p4, phtm_orbit_pts.p0);
	sleep(30*2);
	
	// zoom in close
	cs_fly_to_and_face (phtm_orbit_pts.p5, phtm_orbit_pts.p0);
	sleep(30*5);
	
	cs_queue_command_script(ai_current_squad, cs_e3m5_gunship_area1_random_hover);
end


script command_script cs_e3m5_gunship_area1_hover									// assumes phantom is at position  cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face1);
	// *** MOTHBALLED ****
	// hover spot 2
	cs_fly_to_and_face (w_e_flyby.p3, w_e_flyby.face_center);
	sleep(30 * 4);
	// hover spot 3
	cs_fly_to_and_face (w_e_flyby.f7, w_e_flyby.face_center);
	sleep(30 * 4);
	cs_fly_to_and_face (w_e_flyby.f7, w_e_flyby.p1);
	sleep(30 * 2);
	// hover spot 1
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face_center);
	sleep(30 * 4);
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.p1);
	sleep(30 * 4);
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face6);
	sleep(30 * 2);
	cs_fly_to_and_face (w_e_flyby.p2, w_e_flyby.face6);
	sleep(30 * 1);
	// hover spot 4
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.p1);
	sleep(30 * 4);
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face4);
	sleep(30 * 4);
	// hover spot 5 - in close
	cs_fly_to_and_face (w_e_flyby.p1, w_e_flyby.m1);
	sleep(30 * 4);
	// hover spot 4
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.m1);
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face1);
	cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face_center);
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face1);
end

script command_script cs_e3m5_gunship_area1_random_hover
	repeat
		local short s_random = real_random_range(1,6);
		if (s_random == 1)then
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.m1);
			cs_fly_to_and_face (w_e_flyby.p1, w_e_flyby.m1);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.m1);
		elseif (s_random == 2)then
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.p1);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face4);
			sleep(30 * 4);
		elseif (s_random == 3)then
			cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face_center);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.p1);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.face6);
			sleep(30 * 2);
			cs_fly_to_and_face (w_e_flyby.p2, w_e_flyby.face6);
			sleep(30 * 1);
		elseif (s_random == 4)then
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.m1);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face4);
			sleep(30 * 4);
		elseif (s_random == 5)then
			cs_fly_to_and_face (w_e_flyby.f7, w_e_flyby.face_center);
			sleep(30 * 4);
			cs_fly_to_and_face (w_e_flyby.f7, w_e_flyby.p1);
			sleep(30 * 2);
		elseif (s_random == 6)then
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face6);
			cs_fly_to_and_face (w_e_flyby.p1, w_e_flyby.face7);
			sleep(30 * 5);
			cs_fly_to_and_face (w_e_flyby.p0, w_e_flyby.face6);
		end
	until(s_never_true == true);
//	until(unit_get_health(unit_get_vehicle(ph_e3m5_gunship_1a)) < .2);
	print(" <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
	print(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	print(" <<<<<<<<< gunship random passed          <<<<<<<<");
	print(" <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
	print(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		//unit_get_health(unit_get_vehicle(ph_e3m5_gunship_1a)) 
	cs_queue_command_script(ai_current_squad, cs_e3m5_gunship1_retreat);
	
end
script command_script cs_e3m5_gunship1_retreat
//	 --- PHANTOM RETREAT FROM FRONT OF INSTALLATION ---
	print(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> retreat");
	cs_fly_to_and_face (w_e_flyby.f2, w_e_flyby.f1);
	sleep(30);
	
	ai_set_blind (ai_current_squad, TRUE);
	cs_enable_targeting(false);
	
	cs_fly_to_and_face (w_e_flyby.f1, w_e_flyby.f0);
	cs_fly_to_and_face (w_e_flyby.f6, w_e_flyby.face3);
	cs_fly_to_and_face (w_e_flyby.f0, w_e_flyby.face3);
	sleep(30);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180); //Shrink size over time (making it quick because it shouldn't be seen)
	
	sleep_s (7);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
end
script static void f_e3m5_gunship1_replacer
	sleep_until(ai_living_count(ph_e3m5_gunship_1a) < 1);
	print ("gunship down");
	sleep(30 * 12);
	if(s_e3m5_end_convo > 0)then
		sleep_forever();
	end
	if(ai_living_count(e3m5_all_foes) < 17)then
		ai_place(e3m5_faux_cdst_3);
		sleep(10);
		ai_place(e3m5_faux_cdst_4);
		sleep(30 * 2);
		ai_place(e3m5_faux_cdst_3);
		sleep(10);
		ai_place(e3m5_faux_cdst_4);
	end
	sleep_until(ai_living_count(e3m5_all_foes) < 17);
	ai_place(ph_e3m5_gunship_1b);
end
script static void f_e3m5_gunship2_replacer
	sleep_until(ai_living_count(ph_e3m5_transport_gunship) < 1);
	print ("gunship down");
	sleep(30 * 12);
	if(s_e3m5_end_convo > 0)then
		sleep_forever();
	end
	if(ai_living_count(e3m5_all_foes) < 17)then
		ai_place(e3m5_faux_cdst_1);
		sleep(10);
		ai_place(e3m5_faux_cdst_2);
		sleep(30 * 2);
		ai_place(e3m5_faux_cdst_1);
		sleep(10);
		ai_place(e3m5_faux_cdst_2);
	end
	sleep_until(ai_living_count(e3m5_all_foes) < 17);
	ai_place(ph_e3m5_transport_gunship_bkp);
end

script command_script cs_e3m5_ph_flyby_mid
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (4);
	ai_exit_limbo (ai_current_actor);
	sleep(2);
	ai_teleport(ai_current_squad, w_e_flyby.m0);
	sleep(2);
	s_e3m5_phantom_mid_state = 1;																			//Tell paratroop spawner function that it's time to load
	object_cannot_take_damage(ai_actors(ai_current_actor));
	sleep_until(s_e3m5_phantom_mid_state == 2);												//Wait til that function passes back
	sleep(2);
	s_e3m5_phantom_mid_state = 0;																			//var reset
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 180 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(90);
	cs_fly_to_and_face (w_e_flyby.m1, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.m3, w_e_flyby.face4);
	object_can_take_damage(ai_actors(ai_current_actor));
		
	f_unload_phantom (ai_current_squad, "dual");
	sleep (30 * 4);
	
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.f4);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.f3);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.f2);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.face3);
	cs_fly_to_and_face (w_e_flyby.m1, w_e_flyby.face3);
	cs_fly_to_and_face (w_e_flyby.m4, w_e_flyby.face3);
	cs_fly_to_and_face (w_e_flyby.m0, w_e_flyby.face3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180); //Shrink size over time (making it quick because it shouldn't be seen)
	
	sleep_s (7);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
end	

script command_script cs_e3m5_transport_gunship
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (4);
	ai_exit_limbo (ai_current_actor);
	sleep(2);
	ai_teleport(ai_current_squad, w_e_flyby.m0);
	sleep(2);
	thread(f_e3m5_gunship2_replacer());
	s_e3m5_phantom_mid_state = 1;																			//Tell paratroop spawner function that it's time to load
	object_cannot_take_damage(ai_actors(ai_current_actor));
	sleep_until(s_e3m5_phantom_mid_state == 2);												//Wait til that function passes back
	sleep(2);
	s_e3m5_phantom_mid_state = 0;																			//var reset
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 180 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(90);
	cs_fly_to_and_face (w_e_flyby.m1, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.face4);
	cs_fly_to_and_face (w_e_flyby.m3, w_e_flyby.face4);
	object_can_take_damage(ai_actors(ai_current_actor));
		
	f_unload_phantom (ai_current_squad, "dual");
	sleep (30 * 4);
	
	// up and swivel
	cs_fly_to_and_face (w_e_flyby.m2, w_e_flyby.face2);
	cs_fly_to_and_face (w_e_flyby.swivel1, w_e_flyby.face6);
	cs_fly_to_and_face (w_e_flyby.swivel2, w_e_flyby.face0);
	
	// move into attack position 
//	cs_fly_to_and_face (phtm_orbit_pts.p8, w_e_flyby.face0);
	ai_set_blind (ai_current_squad, false);
	cs_fly_to_and_face (phtm_orbit_pts.board1, phtm_orbit_pts.board2);
	print("===<><><><><><><><>====================================== (phtm_orbit_pts.board1, phtm_orbit_pts.board2);");
	sleep(30 * 6);
	
	cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.p2);
	cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.p1);
	cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.hover3);
	print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover4, phtm_orbit_pts.hover3);");
	
		
	sleep(30 * 6);
	
	cs_fly_to_and_face (phtm_orbit_pts.hover3, phtm_orbit_pts.look_center);
	print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover3, phtm_orbit_pts.look_center);");
	
	sleep(30 * 6);
	
	cs_fly_to_and_face (phtm_orbit_pts.hover2, phtm_orbit_pts.look_center);
	print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover2, phtm_orbit_pts.look_center);");
	
	
	sleep(30 * 6);
	
	cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.hover2);			
	cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.p2);					
	cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.p7);
	print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover5, phtm_orbit_pts.p7);");
	sleep(30 * 6);
	
	cs_queue_command_script(ai_current_actor, cs_e3m5_transport_gunship_area2_random_hover);
end	

script command_script cs_e3m5_transport_gunship_bkp 

	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (1);
	ai_exit_limbo (ai_current_actor);
	sleep (1);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 60 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	
	// fly in and move into boarding position
	cs_fly_to_and_face (phtm_orbit_pts.p13, phtm_orbit_pts.p11);
	cs_fly_to_and_face (phtm_orbit_pts.p9, phtm_orbit_pts.p7);
	cs_fly_to_and_face (phtm_orbit_pts.p8, phtm_orbit_pts.p7);
	cs_fly_to_and_face (phtm_orbit_pts.board1, phtm_orbit_pts.board2);
	
	ai_set_blind (ai_current_squad, false);
	
	sleep(30 * 6);
	
	cs_fly_to_and_face (phtm_orbit_pts.p8, phtm_orbit_pts.p7);
	
	cs_queue_command_script(ai_current_actor, cs_e3m5_transport_gunship_area2_random_hover);

end

script command_script cs_e3m5_transport_gunship_area2_random_hover
	repeat
		local short s_random = real_random_range(1,6);
		if (s_random == 1)then
			cs_fly_to_and_face (phtm_orbit_pts.outer2a, phtm_orbit_pts.p0);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.outer2a, phtm_orbit_pts.p0);");
			sleep(30 * 6);
			cs_fly_to_and_face (phtm_orbit_pts.outer2a, phtm_orbit_pts.look_center);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.outer2a, phtm_orbit_pts.look_center)");
			sleep(30 * 6);
		elseif (s_random == 2)then
			cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.p2);
			cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.p1);
			cs_fly_to_and_face (phtm_orbit_pts.hover4, phtm_orbit_pts.hover3);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover4, phtm_orbit_pts.hover3);");
			sleep(30 * 6);
		elseif (s_random == 3)then
			cs_fly_to_and_face (phtm_orbit_pts.hover3, phtm_orbit_pts.look_center);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover3, phtm_orbit_pts.look_center);");
			sleep(30 * 6);
		elseif (s_random == 4)then
			cs_fly_to_and_face (phtm_orbit_pts.hover2, phtm_orbit_pts.look_center);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover2, phtm_orbit_pts.look_center);");
			sleep(30 * 6);
		elseif (s_random == 5)then
			cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.hover2);
			cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.p2);
			cs_fly_to_and_face (phtm_orbit_pts.hover5, phtm_orbit_pts.p7);
			print("===<><><><><><><><>====================================== (phtm_orbit_pts.hover5, phtm_orbit_pts.p7);");
			sleep(30 * 6);
		end
	until(s_never_true == true);
end
	
script command_script cs_e3m5_center_gunship
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (1);
	ai_exit_limbo (ai_current_actor);
	sleep (1);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	
	cs_fly_to_and_face (hinterland_phantoms.p1, hinterland_phantoms.look_center);
	cs_fly_to_and_face (hinterland_phantoms.p2, hinterland_phantoms.look_center);
	cs_fly_to_and_face (hinterland_phantoms.p3, hinterland_phantoms.look_center);
	ai_set_blind (ai_current_squad, false);
//	cs_enable_targeting(ai_current_squad, false);
	repeat
	cs_fly_to_and_face (hinterland_phantoms.p4, hinterland_phantoms.look_center);
	sleep(30);
	cs_fly_to_and_face (hinterland_phantoms.p5, hinterland_phantoms.look_center);
	cs_fly_to_and_face (hinterland_phantoms.p6, hinterland_phantoms.look_center);
	sleep(30 * 3);
	cs_fly_to_and_face (hinterland_phantoms.p5, hinterland_phantoms.look_center);
	cs_fly_to_and_face (hinterland_phantoms.p4, hinterland_phantoms.look_center);
	sleep(30 * 5);
	cs_fly_to_and_face (hinterland_phantoms.p6, hinterland_phantoms.look_center);
	sleep(30 * 5);
	until(s_never_true == true);
end

script command_script cs_e3m5_faux_gunship
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (1);
	ai_exit_limbo (ai_current_actor);
	sleep (1);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, false);
	
	cs_fly_to_and_face (hinterland_phantoms.p7, hinterland_phantoms.p12);
	cs_fly_to_and_face (hinterland_phantoms.p8, hinterland_phantoms.p12);
	cs_fly_to_and_face (hinterland_phantoms.p9, hinterland_phantoms.p12);
	cs_fly_to_and_face (hinterland_phantoms.p10, hinterland_phantoms.p12);
	sleep(30 * 2);
	cs_fly_to_and_face (hinterland_phantoms.p11, hinterland_phantoms.p12);
	sleep(30 * 2);
	cs_fly_to_and_face (hinterland_phantoms.p12, hinterland_phantoms.look12);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(ai_current_squad, false);
	sleep(30 * 3);
	cs_fly_to_and_face (hinterland_phantoms.p12, hinterland_phantoms.look13);
	cs_fly_to_and_face (hinterland_phantoms.p12, hinterland_phantoms.look14);
	sleep(30);
	cs_fly_to_and_face (hinterland_phantoms.p11, hinterland_phantoms.p10);
	sleep(30 * 2);
	cs_fly_to_and_face (hinterland_phantoms.p10, hinterland_phantoms.p7);
	
end

script command_script cs_e3m5_faux_dropship
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 ); //Shrink size over time
	sleep (4);
	ai_exit_limbo (ai_current_actor);
	sleep(2);
	ai_teleport(ai_current_squad, w_e_flyby.f0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 180 ); //Grow over time	// 90 == time
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, false);
	sleep(90);
	cs_fly_to_and_face (w_e_flyby.p4, w_e_flyby.p5);
	cs_fly_to_and_face (w_e_flyby.p5, w_e_flyby.p6);
	cs_fly_to_and_face (w_e_flyby.p6, w_e_flyby.m3);
end

script command_script e5m2_phantom_passenger_relay
	sleep(30 * 7);
	ai_set_objective (ai_current_squad, aio_seek_players);
end

//== pods
script static void e3m5_droppod_wave_start
	thread(e3m5_drop_pods_bkg());								//background pods
	sleep(30*2.2);
	thread(e3m5_big_drop_1());
	//drop pod sequence
	thread(e3m5_drop_pod_1());
	sleep(30 * 2);
	thread(e3m5_drop_pod_3());
	sleep(15);
	thread(e3m5_drop_pod_8());
	sleep(30);
	thread(e3m5_drop_pod_6());
	sleep(15);
	thread(e3m5_drop_pod_4());
	sleep(10);
	thread(e3m5_drop_pod_5());
	sleep(35);
	thread(e3m5_drop_pod_7());
	sleep(10);
	thread(e3m5_drop_pod_2());
	
	sleep_until(ai_living_count(e3m5_all_foes) < 18); 
	ai_place(e3m5_faux_cdst_3);
	sleep(30 * 3); 
	ai_place(e3m5_faux_cdst_2);
	sleep(30 * 1); 
	//ai_place(e3m5_faux_cdst_1);

	NotifyLevel ("e3m5_droppods_complete");  
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- droppod notify sent----------");

end

script static void e3m5_big_drop_1
			ai_place_in_limbo (e3m5_sg_paradrop_1);
			f_load_drop_pod (dm_e3m5_rail, e3m5_sg_paradrop_1, e3m5_big_pod, false);
end

script static void e3m5_big_drop_2
			ai_place_in_limbo (e3m5_sg_paradrop_2);
			f_load_drop_pod (dm_e3m5_rail, e3m5_sg_paradrop_2, e3m5_big_pod, false);
end

script static void e3m5_drop_pod_1
	object_create (e3m5_pod_1);
	thread(e3m5_pod_1->drop_to_point(e3m5_cdst_1, pod_pts.p1,.8, DEFAULT ));
end

script static void e3m5_drop_pod_2
	object_create (e3m5_pod_2);
	thread(e3m5_pod_2->drop_to_point(e3m5_cdst_2, pod_pts.p2,.8, DEFAULT ));
end

script static void e3m5_drop_pod_3
	object_create (e3m5_pod_3);
	thread(e3m5_pod_3->drop_to_point(e3m5_cdst_3, pod_pts.p3,.8, DEFAULT ));
end

script static void e3m5_drop_pod_4
	object_create (e3m5_pod_4);
	thread(e3m5_pod_4->drop_to_point(e3m5_cdst_4, pod_pts.p4,.8, DEFAULT ));
end

script static void e3m5_drop_pod_5
	object_create (e3m5_pod_5);
	thread(e3m5_pod_5->drop_to_point(e3m5_cdst_5, pod_pts.p5,.8, DEFAULT ));
end

script static void e3m5_drop_pod_6
	object_create (e3m5_pod_6);
	thread(e3m5_pod_6->drop_to_point(e3m5_cdst_6, pod_pts.p6,.8, DEFAULT ));
end

script static void e3m5_drop_pod_7
	object_create (e3m5_pod_7);
	thread(e3m5_pod_7->drop_to_point(e3m5_cdst_7, pod_pts.p7,.8, DEFAULT ));
end

script static void e3m5_drop_pod_8
	object_create (e3m5_pod_8);
	thread(e3m5_pod_8->drop_to_point(e3m5_cdst_8, pod_pts.p8,.8, DEFAULT ));
end

script static void e3m5_drop_pod_a(real scale, real speed)
	object_create (e3m5_pod_a);
	object_set_scale (e3m5_pod_a, scale, 01 ); 
	e3m5_pod_a->dead_drop_to_point(pod_pts.f1, speed, DEFAULT );
	object_destroy(e3m5_pod_a);
end

script static void e3m5_drop_pod_b(real scale, real speed)
	object_create (e3m5_pod_b);
	object_set_scale (e3m5_pod_b, scale, 01 ); 
	e3m5_pod_b->dead_drop_to_point(pod_pts.f2,speed, DEFAULT );
	object_destroy(e3m5_pod_b);
end

script static void e3m5_drop_pod_c(real scale, real speed)
	object_create (e3m5_pod_c);
	object_set_scale (e3m5_pod_c, scale, 01 ); 
	e3m5_pod_c->dead_drop_to_point(pod_pts.f3,speed, DEFAULT );
	object_destroy(e3m5_pod_c);
end

script static void e3m5_drop_pod_d(real scale, real speed)
	object_create (e3m5_pod_d);
	object_set_scale (e3m5_pod_d, scale, 01 ); 
	e3m5_pod_d->dead_drop_to_point(pod_pts.f4,speed, DEFAULT );
	object_destroy(e3m5_pod_d);
end

script static void e3m5_drop_pod_e(real scale, real speed)
	object_create (e3m5_pod_e);
	object_set_scale (e3m5_pod_e, scale, 01 ); 
	e3m5_pod_e->dead_drop_to_point(pod_pts.f5,speed, DEFAULT );
	object_destroy(e3m5_pod_e);
end

script static void e3m5_drop_pod_f(real scale, real speed)
	object_create (e3m5_pod_f);
	object_set_scale (e3m5_pod_f, scale, 01 ); 
	e3m5_pod_f->dead_drop_to_point(pod_pts.f6,speed, DEFAULT );
	object_destroy(e3m5_pod_f);
end

script static void e3m5_drop_pod_g(real scale, real speed)
	object_create (e3m5_pod_g);
	object_set_scale (e3m5_pod_g, scale, 01 ); 
	e3m5_pod_g->dead_drop_to_point(pod_pts.f7,speed, DEFAULT );
	object_destroy(e3m5_pod_g);
end

script static void e3m5_drop_pod_h(real scale, real speed)
	object_create (e3m5_pod_h);
	object_set_scale (e3m5_pod_h, scale, 01 ); 
	e3m5_pod_h->dead_drop_to_point(pod_pts.f8,speed, DEFAULT );
	object_destroy(e3m5_pod_h);
end

script static void e3m5_drop_pod_i(real scale, real speed)
	object_create (e3m5_pod_i);
	object_set_scale (e3m5_pod_i, scale, 01 ); 
	e3m5_pod_i->dead_drop_to_point(pod_pts.f9,speed, DEFAULT );
	object_destroy(e3m5_pod_i);
end

script static void e3m5_drop_pod_j(real scale, real speed)
	object_create (e3m5_pod_j);
	object_set_scale (e3m5_pod_j, scale, 01 ); 
	e3m5_pod_j->dead_drop_to_point(bkg_pods.f10,speed, DEFAULT );
	object_destroy(e3m5_pod_j);
end

script static void e3m5_drop_pod_k(real scale, real speed)
	object_create (e3m5_pod_k);
	object_set_scale (e3m5_pod_k, scale, 01 ); 
	e3m5_pod_k->dead_drop_to_point(bkg_pods.f11,speed, DEFAULT );
	object_destroy(e3m5_pod_k);
end

script static void e3m5_drop_pod_l(real scale, real speed)
	object_create (e3m5_pod_l);
	object_set_scale (e3m5_pod_l, scale, 01 ); 
	e3m5_pod_l->dead_drop_to_point(bkg_pods.f12,speed, DEFAULT );
	object_destroy(e3m5_pod_l);
end

script static void e3m5_drop_pod_m(real scale, real speed)
	object_create (e3m5_pod_m);
	object_set_scale (e3m5_pod_m, scale, 01 ); 
	e3m5_pod_m->dead_drop_to_point(bkg_pods.f13,speed, DEFAULT);
	object_destroy(e3m5_pod_m);
end

script static void e3m5_drop_pod_n(real scale, real speed)
	object_create (e3m5_pod_n);
	object_set_scale (e3m5_pod_n, scale, 01 ); 
	e3m5_pod_n->dead_drop_to_point(bkg_pods.f14,speed, DEFAULT );
	object_destroy(e3m5_pod_n);
end

script static void e3m5_drop_pod_o(real scale, real speed)
	object_create (e3m5_pod_o);
	object_set_scale (e3m5_pod_o, scale, 01 ); 
	e3m5_pod_o->dead_drop_to_point(bkg_pods.f15,speed, DEFAULT );
	object_destroy(e3m5_pod_o);
end

script static void e3m5_drop_pods_bkg
	// D-G-a-j-K-O
	thread(e3m5_drop_pod_d(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_g(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_a(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_j(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_k(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_o(.75, 1.25));
	sleep(12);
	// B-E-M-J
	thread(e3m5_drop_pod_b(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_e(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_j(.75, 1.25));
	sleep(12);
	// a-C-F-h-L-n
	thread(e3m5_drop_pod_a(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_c(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_f(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_h(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_l(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_n(.5, 1.5));
	sleep(12);
	// e-N-i-M-B-c
	thread(e3m5_drop_pod_e(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_n(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_i(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_b(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_c(.5, 1.5));
	sleep(12);
	// g-H-d-M-n-o
	thread(e3m5_drop_pod_g(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_h(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_d(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_n(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_o(.5, 1.5));
	sleep(12);
	
	// D-G-a-j-K-O
	thread(e3m5_drop_pod_d(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_g(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_a(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_j(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_k(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_o(.75, 1.25));
	sleep(12);
	// B-E-M-J
	thread(e3m5_drop_pod_b(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_e(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_j(.75, 1.25));
	sleep(12);
	// a-C-F-h-L-n
	thread(e3m5_drop_pod_a(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_c(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_f(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_h(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_l(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_n(.5, 1.5));
	sleep(12);
	// e-N-i-M-B-c
	thread(e3m5_drop_pod_e(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_n(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_i(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_b(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_c(.5, 1.5));
	sleep(12);
	// g-H-d-M-n-o
	thread(e3m5_drop_pod_g(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_h(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_d(.5, 1.5));
	sleep(6);
	thread(e3m5_drop_pod_m(.75, 1.25));
	sleep(6);
	thread(e3m5_drop_pod_n(.5, 1.5));
	sleep(12);
	thread(e3m5_drop_pod_o(.5, 1.5));
end

//	p0			-2.968354, -19.028044, -5.191618
// 	p1			15.194799, -34.203506, -0.965373
//	p2			15.196451, -54.061882, -3.187371
//	p3			8.118011, -50.817528, -3.634797
//	p4			-0.828943, -46.380733, -0.875781
//	p5			-17.867081, -26.468172, -1.420290
//	p6			-30.370314, -21.274532, 7.731047
//	pa			46.625175, -29.397625, 8.034913
//	pb			34.266483, -66.537750, 9.906209
//	pc			4.791811, -74.218002, 4.433260
//	pd			-10.958844, -63.903004, 2.671556
//	pe			-37.697578, -18.514374, 13.668387


script command_script cs_e3m5_drop_pod_cdst_1
	sleep(30 * 3.25);
	cs_go_to_and_face(cdst_pts.p1, cdst_pts.jump1);
	sleep(4);
	cs_jump(45, 6);
end
script command_script cs_e3m5_drop_pod_cdst_2
	sleep(30 * 5);
	cs_go_to_and_face(cdst_pts.p2, cdst_pts.jump2);
	sleep(4);
	cs_jump(45, 6.4);
end
script command_script cs_e3m5_drop_pod_cdst_3
	sleep(30 * 5);
	print(" ");
	cs_go_to_and_face(cdst_pts.p3, cdst_pts.jump3);
	print(" ");
	sleep(4);
	cs_jump(45, 6.4);
end
script command_script cs_e3m5_drop_pod_cdst_4
	sleep(30 * 5);
	cs_go_to_and_face(cdst_pts.p4, cdst_pts.jump4);
	sleep(4);
	cs_jump(45, 6.4);
end
script command_script cs_e3m5_drop_pod_cdst_5
	sleep(30 * 5);
	cs_go_to_and_face(cdst_pts.p5, cdst_pts.jump5);
	sleep(4);
	cs_jump(45, 7);
end
script command_script cs_e3m5_drop_pod_cdst_6
	sleep(30 * 5);
	cs_go_to_and_face(cdst_pts.p6, cdst_pts.jump6);
	sleep(4);
	cs_jump(45, 7);
end
script command_script cs_e3m5_drop_pod_cdst_8
	sleep(30 * 5);
	cs_go_to_and_face(cdst_pts.p0, cdst_pts.jump0);
	sleep(4);
	cs_jump(45, 7.5);
end
script command_script cs_e3m5_drop_pod_cdst
	sleep(30 * 6);
	ai_teleport(ai_current_actor, bkg_pods.p0);
end

script command_script cs_e3m5_drop_pod_null
	sleep(30 * 6);
	ai_erase(ai_current_actor);
end

script static void f_e3m5_random_faux_dst
	local short s_random = real_random_range(1,5);
	if(s_random == s_e3m5_last_faux_dst)then
		s_random = s_random +1;
	end
	if (s_random == 1)then
		ai_place(e3m5_faux_cdst_1);
	elseif (s_random == 2)then
		ai_place(e3m5_faux_cdst_2);
	elseif (s_random == 3)then
		ai_place(e3m5_faux_cdst_3);
	elseif (s_random == 4)then
		ai_place(e3m5_faux_cdst_4);
	elseif (s_random == 5)then
		ai_place(e3m5_faux_cdst_5);
	end
	s_e3m5_last_faux_dst = s_random;
end

script command_script cs_e3m5_faux_cdst_1
	sleep(2);
	cs_go_to_and_face(cdst_pts.p8, cdst_pts.jump8);
	sleep(2);
	cs_jump(25, 7.5);
	sleep(10);
	ai_set_objective (ai_current_squad, aio_air_cdsts);
end
script command_script cs_e3m5_faux_cdst_2
	sleep(2);
	cs_jump(65, 6.5);
	sleep(20);
	ai_set_objective (ai_current_squad, aio_air_cdsts);
end
script command_script cs_e3m5_faux_cdst_3
	sleep(2);
	cs_jump(55, 6.3);
	sleep(20);
	ai_set_objective (ai_current_squad, aio_air_cdsts);
end
script command_script cs_e3m5_faux_cdst_4
	sleep(2);
	cs_jump(40, 7.6);
	sleep(20);
	ai_set_objective (ai_current_squad, aio_air_cdsts);
end
script command_script cs_e3m5_faux_cdst_5
	sleep(2);
	cs_jump(40, 7);
	sleep(20);
	ai_set_objective (ai_current_squad, aio_air_cdsts);
end

//== End Sequence
script static void e3m5_scenario_complete_sequence
	sleep_until (LevelEventStatus("e3m5_start_end_sequence"), 1);
	sleep_until(b_e3m5_conch == false);
	sleep(30);
	b_e3m5_conch = true;
	
	thread(f_music_e3m5_bombingrun_start());
	
	wake(e3m5_vo_bombingrun);
								// Dalton : Missiles inbound.  If Crimson's not somewhere safe yet, they've got about three seconds.
								// (sleep_until s_e3m5_end_convo == 1)
	sleep(30 * 3);
// ------------------  Broadsword Bombing Run
	thread(f_e3m5_broadsword_bombing_run());					// fire longsword bombing sequence
	sleep_until(s_e3m5_end_convo == 1);							// set in broadsword function
								// Miller : Multiple confirmed hits on target.  Phantoms are all down!
								// Palmer : Better late than never, Dalton.  Thanks.  Now send Crimson a Pelican.
								// Dalton : Already on its way, Commander.
	sleep(30 * 3);
	ai_place(v_e3m5_pelican);
	sleep(30);
	thread(f_blip_object_cui (v_e3m5_pelican, "navpoint_goto"));
	f_new_objective(cath_objective_c);	
					 			// "Evac"
	sleep(30);
	
	
	sleep_until (s_e3m5_end_convo == 2, 1);	// sleep until these lines play to this point "already on its way, commander"
	sleep(30 * 3);
	sleep_until (volume_test_players (tv_pelican), 1);
	
	b_end_player_goal = TRUE;								// advance objectives, fires following event
	sleep_until (LevelEventStatus("e3m5_start_end_pup"), 1);// sleep_until point reached
	thread(f_music_e3m5_bombingrun_finish());
	
// ------------------ Closing Puppeteer
	firefight_mode_set_player_spawn_suppressed(true);
	b_wait_for_narrative = true;
	ai_enter_limbo(e3m5_all_foes);
	fade_out (0,0,0,30);
	player_control_fade_out_all_input (30);
	sleep(30);
	
	object_destroy(unit_get_vehicle (v_e3m5_pelican));
	sleep(30);
	
	thread(f_music_e3m5_end_cinematic_start());
	// sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m5_vin_sfx_outro', NONE, 1);
	cinematic_start();		// initialize the game for “interruptive” cutscenes (no split screen)
	pup_play_show (e3_m5_outro);
									// *** pup sets s_e3m5_end_convo to 3, which continues the dialog:
									// Palmer : Crimson?  Damn fine work down there today.  Once you're back to the ship, first round's on me.
									// *** callback sets  s_e3m5_end_convo to 4:
									
	
// ------------------ Scenario Complete Sequence
	sleep_until(s_e3m5_end_convo == 4, 1);	// wait until the convo complete		
	thread(f_music_e3m5_end_cinematic_finish());
	
	//cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
	sleep(30 * 1.5);
	b_wait_for_narrative_hud = false;
	sleep(30);
	b_end_player_goal = TRUE;																								//ends scenario
	cinematic_stop();																												//turn off no-split screen
end

script static void contrail_test
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, (ai_vehicle_get_from_spawn_point(ph_e3m5_center_gunship.spawn_points_0)), "target_cockpit");
	print("target_cockpit");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "target_hull");
	print("target_hull");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "target_troop_door_left");
	print("target_troop_door_left");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "target_troop_door_right");
	print("target_troop_door_right");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "target_engine_right");
	print("target_engine_right");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "target_engine_left");
	print("target_engine_left");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_rudder_right");
	print("garbage_rudder_right");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_tail");
	print("garbage_tail");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_01");
	print("garbage_destroyed_chunk_01");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_02");
	print("garbage_destroyed_chunk_02");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_03");
	print("garbage_destroyed_chunk_03");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_04");
	print("garbage_destroyed_chunk_04");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_05");
	print("garbage_destroyed_chunk_05");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_06");
	print("garbage_destroyed_chunk_06");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_destroyed_chunk_07");
	print("garbage_destroyed_chunk_07");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "garbage_turret_door_right");
	print("garbage_turret_door_right");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "chud_nav_point");
	print("chud_nav_point");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "fx_hull_explosion");
	print("fx_hull_explosion");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "fx_rudder_right_medium_damage");
	print("fx_rudder_right_medium_damage");
	sleep(30);
	effect_new_on_object_marker(objects\equipment\remote_strike\fx\ordnance_droppod_trail.effect, ph_e3m5_center_gunship, "fx_tail_major_damage");
	print("fx_tail_major_damage");
	sleep(30);
end

script static void f_e3m5_broadsword_bombing_run
	ai_place(v_e3m5_broadsword_b);
	sleep(20);
	ai_place(v_e3m5_broadsword_d);
	
	damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_center_gunship.spawn_points_0), "hull",5000);
	thread(f_e3m5_random_explosions());
	sleep(20);
	ai_place(v_e3m5_broadsword_c);
	sleep(45);
	if		(ai_living_count(ph_e3m5_transport_gunship) > 0)then
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_transport_gunship.spawn_points_0), "hull",5000);
	elseif(ai_living_count(ph_e3m5_transport_gunship_bkp) > 0)then
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_transport_gunship_bkp.spawn_points_1), "hull",5000);
		sleep(2);
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_transport_gunship_bkp.spawn_points_0), "hull",5000);
		sleep(2);
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_transport_gunship_bkp.spawn_points_2), "hull",5000);
	end
	ai_place(v_e3m5_broadsword_a);
	sleep(45);
	damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_faux_gunship.spawn_points_0), "hull",5000);
	ai_place(v_e3m5_broadsword_c);
	sleep(45);
	damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_faux_dropship.spawn_points_0), "hull",5000);
	ai_place(v_e3m5_broadsword_d);
	sleep(30 * 1);
	if		(ai_living_count(ph_e3m5_gunship_1a) > 0)then
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_gunship_1a.spawn_points_0), "hull",5000);
		sleep(2);
		ai_kill(e3m5_all_foes);
	elseif		(ai_living_count(ph_e3m5_gunship_1b) > 0)then
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_gunship_1b.spawn_points_0), "hull",5000);
		sleep(2);
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_gunship_1b.spawn_points_1), "hull",5000);
		sleep(2);
		damage_objects(ai_vehicle_get_from_spawn_point(ph_e3m5_gunship_1b.spawn_points_2), "hull",5000);
		sleep(2);
		ai_kill(e3m5_all_foes);
	end
	
		kill_volume_enable(kill_air);
		kill_volume_enable(kill_air_2);
		sleep(5);
		ai_kill(e3m5_all_foes);
		sleep(10);
		kill_volume_disable(kill_air);
		kill_volume_disable(kill_air_2);
	
	if(ai_living_count(e3m5_sg_phantoms) > 0)then														//worst case scenario
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_transport_gunship));
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_transport_gunship_bkp));
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_gunship_1a));
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_gunship_1b));
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_faux_dropship));
		thread(e1_m2_phantom_despawn_hack(ph_e3m5_center_gunship));
	end
	sleep(30 * 2);
	s_e3m5_end_convo = 1;
end

script command_script cs_e3m5_broadsword_a
	sleep(2);
	//sound_impulse_start ( 'sound\environments\multiplayer\cathedral\machines\new_machines\machine_48_broadsword_flyby.sound', switch, 1 );
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(4);
	cs_fly_by(e3m5_broadsword_pts.p7);
	cs_fly_by(e3m5_broadsword_pts.p8, 30);
	cs_fly_by(e3m5_broadsword_pts.p9, 30);
	ai_erase(ai_current_actor);
end

script command_script cs_e3m5_broadsword_b
	sleep(2);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(4);
	cs_fly_by(e3m5_broadsword_pts.b0);
	cs_fly_by(e3m5_broadsword_pts.a6, 30);
	cs_fly_by(e3m5_broadsword_pts.a7, 30);
	ai_erase(ai_current_actor);
end

script command_script cs_e3m5_broadsword_c
	sleep(2);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(4);
	cs_fly_by(e3m5_broadsword_pts.p4, 20);
	cs_fly_by(e3m5_broadsword_pts.p5, 30);
	cs_fly_by(e3m5_broadsword_pts.p6, 30);
	ai_erase(ai_current_actor);
end

script command_script cs_e3m5_broadsword_d
	sleep(2);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	sleep(4);
	cs_fly_by(e3m5_broadsword_pts.p1, 20);
	cs_fly_by(e3m5_broadsword_pts.p2, 30);
	cs_fly_by(e3m5_broadsword_pts.p3, 30);
	ai_erase(ai_current_actor);
end

//	ai_place(v_e3m5_proxy1)
//	ai_place(ph_e3m5_center_gunship)

//script command_script cs_e3m5_proxy_gun_1
//	sleep(5);
////	cs_enable_targeting(true);
//	ai_object_set_targeting_ranges(ai_get_object(v_e3m5_proxy1), 0, 90000);
////	cs_shoot(v_e3m5_proxy1, true, ai_vehicle_get_from_spawn_point(ph_e3m5_center_gunship.spawn_points_0));
//	cs_shoot(v_e3m5_proxy1, true, ai_get_object(ph_e3m5_center_gunship));
//	print("-----------------------proxy turret aiming");
//end

script static void f_e3m5_random_explosions
	
	f_e3m5_explosion (1);
	sleep(20);
	f_e3m5_explosion (2);
	sleep(30);
	f_e3m5_explosion (3);
	sleep(10);
	f_e3m5_explosion (4);
	sleep(10);
	f_e3m5_explosion (5);
	sleep(35);
	f_e3m5_explosion (6);
	sleep(10);
	f_e3m5_explosion (7);
	sleep(35);
	f_e3m5_explosion (8);
	sleep(10);
	f_e3m5_explosion (9);
	sleep(10);
	f_e3m5_explosion (10);
	sleep(10);
end

script static void f_e3m5_explosion (cutscene_flag flag)
	print ("shake start");
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
	print ("EXPLOSION");
	sleep (10);
	print ("stop");
end

script command_script cs_e3m5_pelican
	object_cannot_take_damage(ai_get_object(v_e3m5_pelican));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	cs_fly_to_and_face (e3m5_pelican_pts.p0, e3m5_pelican_pts.look0);
	cs_fly_to_and_face (e3m5_pelican_pts.p1, e3m5_pelican_pts.look1);
	cs_fly_to_and_face (e3m5_pelican_pts.p2, e3m5_pelican_pts.look2);
	cs_fly_to_and_face (e3m5_pelican_pts.p3, e3m5_pelican_pts.look3);
	cs_fly_to_and_face (e3m5_pelican_pts.p4, e3m5_pelican_pts.look4);
	cs_fly_to_and_face (e3m5_pelican_pts.p5, e3m5_pelican_pts.look4);
end

script static void e1_m2_phantom_despawn_hack(ai phantom)
	sleep(30);
	print("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
		print("----=-=-=-=-----phantom alive, trying to erase");
		ai_erase (ai_get_squad(phantom));
		print("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		e1_m2_phantom_despawn_hack(phantom);
	else
		print("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end

//== DEBUG

